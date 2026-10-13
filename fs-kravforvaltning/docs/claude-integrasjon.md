# Claude Code i en TypeScript-app

Dette dokumentet forklarer hvordan Claude-panelet i FS Kravforvaltning er bygget, slik at det samme kan lages i en annen TypeScript-app. Beskrivelsen er generisk: det som er spesielt for denne appen (skills, kodemapper for verifisering, krav-stier), er utelatt eller byttet ut med plassholdere.

Integrasjonen bruker ikke Anthropic-API-et direkte. Appen starter brukerens lokalt installerte **Claude Code** (`claude`) som en barneprosess, én prosess per melding, og leser svaret som en strøm av JSON-linjer. Det gir tre fordeler:

- Brukeren bruker sin egen innlogging og sitt eget abonnement. Appen trenger ingen API-nøkkel.
- Claude Code har allerede verktøyene (lese, søke, endre filer), samtalehukommelse (`--resume`) og komprimering av konteksten.
- Appen styrer bare hva Claude får lov til (verktøy og mapper), og hva den får vite (systemtekst).

Kravet er at appen har en Node-backend (en dev-server, en Express-server, eller main-prosessen i Electron) som kan starte prosesser på brukerens maskin. En ren nettside kan ikke gjøre dette.

## Oversikt

```
┌────────────── Renderer (nettleser / Electron-vindu) ──────────────┐
│  ClaudePanel ──► samtale-state (rene funksjoner + modul-store)    │
│       │                          ▲                                │
│       │ call('claudeRun', …)     │ on('app:claude', {runId,event})│
│       ▼                          │                                │
│  transport  (HTTP POST + websocket   |   IPC via preload)         │
└───────┼──────────────────────────┼────────────────────────────────┘
        ▼                          │
┌────────────── Backend (Node) ─────┼────────────────────────────────┐
│  api.dispatch(method, arg)        │                                │
│       ▼                           │                                │
│  ClaudeRunner ── emit({runId, event}) ◄── parseStreamLine(linje)   │
│       │                                        ▲                   │
│       ▼ spawn                                  │ stdout (JSONL)    │
│  claude -p --output-format stream-json …  ─────┘                   │
│       ▲ stdin: meldingen                                           │
└────────────────────────────────────────────────────────────────────┘
```

Filene i denne appen, som referanse:

| Del | Fil |
|-----|-----|
| Prosessen, argumentene og tolkningen av strømmen | `core/claude.ts` |
| Typene som deles av backend og renderer | `shared/api.ts` |
| API-et og navnesjekken | `core/api.ts` |
| Transport i dev-serveren (HTTP + websocket) | `server/kravPlugin.ts` |
| Transport i desktop-appen (IPC) | `electron/main.ts`, `electron/preload.ts` |
| Transport-abstraksjonen i rendereren | `src/transport.ts` |
| Samtale-state (rene funksjoner) | `src/claudeChat.ts` |
| Panelet | `src/ClaudePanel.tsx` |
| Markdown i svarene | `src/ChatMarkdown.tsx` |
| PR-forslag fra Claude (strukturert handling) | `src/prProposal.ts` |
| Andre visninger sender prompt til panelet, eller legger tekst i inputfeltet | `src/claudeBridge.ts` |
| Markert tekst i feature-visningen: «Kopier» / «Legg i samtalen» | `src/SelectionMenu.tsx`, `src/selection.ts` |

## 1. Kommandolinja

Hver melding er én kjøring av `claude` i «print mode»:

```
claude -p
  --output-format stream-json
  --verbose
  --permission-mode dontAsk
  --allowedTools Read Glob Grep Edit Write TodoWrite
  --append-system-prompt "<kontekst fra appen>"
  [--resume <sessionId>]
  [--add-dir <mappe> …]
  [--disallowedTools "Edit(//<mappe>/**)" …]
```

med arbeidsmappa (`cwd`) satt til prosjektet Claude skal jobbe i, og **meldingen på stdin**.

| Flagg | Hvorfor |
|-------|---------|
| `-p` | Ikke-interaktiv kjøring: leser meldingen, svarer og avslutter. |
| `--output-format stream-json` | Én JSON-hendelse per linje mens Claude jobber, så panelet kan vise tekst og verktøykall fortløpende. |
| `--verbose` | Påkrevd sammen med `stream-json` i print mode. Uten det avviser `claude` kombinasjonen. |
| `--permission-mode dontAsk` | `-p` kan ikke spørre brukeren om lov. Med `dontAsk` avvises alt som ikke er eksplisitt tillatt, i stedet for at kjøringen henger eller feiler. |
| `--allowedTools …` | Hvitelisten. Det som ikke står her (Bash, WebFetch, WebSearch, …), er avvist. Velg lista etter hva appen trenger. |
| `--append-system-prompt` | Kontekst fra appen, lagt til Claude Codes egen systemtekst (se avsnitt 6). |
| `--resume <id>` | Fortsetter samtalen. Claude Code lagrer selve samtalen; appen husker bare `sessionId`. |
| `--add-dir` | Gir Claude lesetilgang til mapper utenfor `cwd`. |
| `--disallowedTools "Edit(//sti/**)"` | Gjør en mappe skrivebeskyttet. `Edit(...)`-regler gjelder alle verktøy som skriver filer. |

Meldingen sendes på stdin, ikke som argument. Da kan en melding som begynner med `--`, aldri bli tolket som et flagg, og lange meldinger treffer ikke grensen for kommandolinja.

```ts
const TOOLS = ['Read', 'Glob', 'Grep', 'Edit', 'Write', 'TodoWrite'];

function buildArgs(req: RunRequest, extraDirs: string[]): string[] {
  const readOnly = extraDirs.map(d => `Edit(/${posix(d)}/**)`);
  return [
    '-p',
    '--output-format', 'stream-json',
    '--verbose',
    '--permission-mode', 'dontAsk',
    '--allowedTools', ...TOOLS,
    ...extraDirs.flatMap(d => ['--add-dir', d]),
    '--append-system-prompt', contextPrompt(req),
    ...(req.sessionId ? ['--resume', req.sessionId] : []),
    ...(readOnly.length ? ['--disallowedTools', ...readOnly] : []),
  ];
}

/** Absolutt sti i regelform: `//sti`, også på Windows (`C:\x` → `//c/x`) */
const posix = (p: string) =>
  resolve(p).replace(/\\/g, '/').replace(/^([A-Za-z]):/, (_, d: string) => '/' + d.toLowerCase());
```

Ta bare med ekstra mapper som er absolutte og finnes (`isAbsolute(d) && statSync(d).isDirectory()`), og fjern duplikater.

## 2. Finne `claude`

En app som startes fra Finder, Start-menyen eller en desktop-launcher, har en kort `PATH` som ofte ikke inneholder `claude`. Let derfor i denne rekkefølgen:

1. En miljøvariabel som overstyrer (her `KRAV_CLAUDE_PATH`). Er den satt, brukes bare den.
2. Mappene i `PATH`.
3. Vanlige installasjonssteder: `~/.local/bin`, `~/.claude/local`, `/opt/homebrew/bin`, `/usr/local/bin`, og på Windows `%APPDATA%\npm`. Filnavnene er `claude` (POSIX) og `claude.exe` / `claude.cmd` (Windows).
4. Innloggingsskallet: `$SHELL -ilc 'command -v claude'` med tidsavbrudd (5 s), siste linje i svaret. Det fanger opp PATH satt i `.zshrc` / `.bashrc`, nvm osv.

Sjekk at fila kan kjøres med `accessSync(p, X_OK)` på POSIX og `F_OK` på Windows.

Når prosessen startes:

- Legg `dirname(bin)` først i `PATH` for barneprosessen. En npm-installert `claude` er et skript som trenger `node` fra samme mappe.
- På Windows må en `.cmd`-fil startes med `shell: true`.
- Hurtigbufre stien, men nullstill bufferet når den ikke ble funnet, så appen finner den hvis brukeren installerer Claude Code mens appen kjører.

`status()` kjører `claude --version` og gir `{ available, path, version }`. Panelet viser en installasjonsveiledning når `available` er `false`.

## 3. Fra `stream-json` til appens hendelser

Strømmen fra Claude Code er detaljert. Backenden oversetter hver linje til en liten, stabil hendelsestype, så rendereren ikke er bundet til formatet til Claude Code:

```ts
type ClaudeEvent =
  | { kind: 'init'; sessionId: string; model: string | null }
  | { kind: 'text'; text: string }
  | { kind: 'tool'; id: string; name: string; summary: string }
  | { kind: 'toolResult'; id: string; isError: boolean }
  | { kind: 'usage'; tokens: number }
  | {
      kind: 'done';
      ok: boolean;
      sessionId: string | null;
      durationMs: number | null;
      turns: number | null;
      error: string | null;
      contextWindow?: number | null;
    };
```

| Linje fra `claude` | Blir til |
|--------------------|----------|
| `{type:'system', subtype:'init', session_id, model}` | `init` |
| `{type:'assistant', message:{content:[…], usage}}` | `text` per tekstblokk (tomme hoppes over), `tool` per `tool_use`-blokk, og én `usage` |
| `{type:'user', message:{content:[{type:'tool_result', tool_use_id, is_error}]}}` | `toolResult` |
| `{type:'result', subtype, is_error, session_id, duration_ms, num_turns, result, modelUsage}` | `done` |
| Alt annet, og linjer som ikke er gyldig JSON | ingenting |

```ts
export function parseStreamLine(line: string): ClaudeEvent[] {
  let msg: any;
  try { msg = JSON.parse(line); } catch { return []; }

  if (msg.type === 'system' && msg.subtype === 'init')
    return [{ kind: 'init', sessionId: msg.session_id, model: msg.model ?? null }];

  // Underagenter (Task-verktøyet) har parent_tool_use_id; vis bare hovedsamtalen
  if (msg.type === 'assistant' && msg.parent_tool_use_id == null) {
    const out: ClaudeEvent[] = (msg.message?.content ?? []).flatMap((c: any): ClaudeEvent[] => {
      if (c.type === 'text' && c.text?.trim()) return [{ kind: 'text', text: c.text }];
      if (c.type === 'tool_use') return [{ kind: 'tool', id: c.id, name: c.name, summary: toolSummary(c.name, c.input) }];
      return [];
    });
    const u = msg.message?.usage;
    if (u) {
      const n = (x: unknown) => (typeof x === 'number' ? x : 0);
      const tokens = n(u.input_tokens) + n(u.cache_creation_input_tokens) + n(u.cache_read_input_tokens) + n(u.output_tokens);
      if (tokens > 0) out.push({ kind: 'usage', tokens });
    }
    return out;
  }

  if (msg.type === 'user' && msg.parent_tool_use_id == null)
    return (msg.message?.content ?? []).flatMap((c: any): ClaudeEvent[] =>
      c.type === 'tool_result' ? [{ kind: 'toolResult', id: c.tool_use_id, isError: !!c.is_error }] : []);

  if (msg.type === 'result') {
    const ok = msg.subtype === 'success' && !msg.is_error;
    return [{
      kind: 'done', ok,
      sessionId: msg.session_id ?? null,
      durationMs: msg.duration_ms ?? null,
      turns: msg.num_turns ?? null,
      error: ok ? null : (typeof msg.result === 'string' && msg.result) || msg.subtype || 'Ukjent feil',
      contextWindow: maxContextWindow(msg.modelUsage),
    }];
  }
  return [];
}
```

Detaljer som er verdt å ta med:

- **Bare hovedsamtalen.** Meldinger med `parent_tool_use_id` kommer fra underagenter. De filtreres bort, ellers fylles panelet med verktøykall brukeren ikke har bedt om.
- **Kontekstbruk.** Hvor mye av kontekstvinduet siste svar brukte, er summen av `input_tokens`, `cache_creation_input_tokens`, `cache_read_input_tokens` og `output_tokens`. `input_tokens` alene er misvisende lavt når prompt-caching er i bruk.
- **Kontekstvinduet** står i `modelUsage` i `result`, som `{ [modell]: { contextWindow } }`. Ta det største tallet: hovedmodellen har det største vinduet, underagenter kan ha mindre.
- **`toolSummary`** lager en kort tekst per verktøykall: `input.file_path` (gjort relativ til prosjektet), ellers `input.pattern` (+ ` i <path>`), ellers antall punkter i `input.todos`, ellers verktøynavnet.

## 4. Runneren

`ClaudeRunner` eier prosessene og sender hendelsene videre. Den vet ingenting om HTTP eller IPC.

```ts
export class ClaudeRunner {
  private emitter = new EventEmitter();
  private runs = new Map<string, { proc: ChildProcess; cancelled: boolean }>();
  private seq = 0;

  constructor(readonly cwd: string, private opts: { env?: NodeJS.ProcessEnv; spawn?: typeof spawn } = {}) {}

  on(fn: (d: { runId: string; event: ClaudeEvent }) => void) {
    this.emitter.on('claude', fn);
    return () => void this.emitter.off('claude', fn);
  }
  private emit(runId: string, event: ClaudeEvent) {
    this.emitter.emit('claude', { runId, event });
  }

  async run(req: RunRequest): Promise<{ runId: string }> {
    if (!req.prompt?.trim()) throw new Error('Tom melding');
    const bin = await this.find();
    if (!bin) throw new Error('Fant ikke claude');

    // Unik også på tvers av omstarter: rendereren lagrer runId sammen med samtalen
    const runId = `${Date.now().toString(36)}-${++this.seq}`;
    const env = { ...(this.opts.env ?? process.env) };
    env.PATH = [dirname(bin), env.PATH].filter(Boolean).join(delimiter);
    const proc = (this.opts.spawn ?? spawn)(bin, buildArgs(req, validDirs(req.dirs)), {
      cwd: this.cwd, env, shell: bin.endsWith('.cmd'), stdio: ['pipe', 'pipe', 'pipe'],
    });
    const run = { proc, cancelled: false };
    this.runs.set(runId, run);

    let buf = '', stderr = '', done = false;
    proc.stdout!.setEncoding('utf8');
    proc.stdout!.on('data', (chunk: string) => {
      buf += chunk;
      let nl: number;
      while ((nl = buf.indexOf('\n')) >= 0) {
        const line = buf.slice(0, nl).trim();
        buf = buf.slice(nl + 1);
        for (const ev of line ? parseStreamLine(line) : []) {
          if (ev.kind === 'done') done = true;
          this.emit(runId, ev);
        }
      }
    });
    proc.stderr!.setEncoding('utf8');
    proc.stderr!.on('data', (c: string) => (stderr = (stderr + c).slice(-4000)));

    proc.on('error', e => {
      this.runs.delete(runId);
      this.emit(runId, failed(`Kunne ikke starte claude: ${e.message}`));
    });
    proc.on('close', code => {
      this.runs.delete(runId);
      if (done) return;
      const error = run.cancelled ? 'Avbrutt'
        : stderr.trim().split('\n').slice(-3).join('\n') || `claude avsluttet med kode ${code}`;
      this.emit(runId, failed(error));
    });

    proc.stdin!.end(req.prompt);
    return { runId };
  }

  active() { return [...this.runs.keys()]; }

  async cancel(runId: string) {
    const run = this.runs.get(runId);
    if (!run) return;
    run.cancelled = true;
    run.proc.kill();
  }

  close() { for (const id of [...this.runs.keys()]) void this.cancel(id); }
}

const failed = (error: string): ClaudeEvent =>
  ({ kind: 'done', ok: false, sessionId: null, durationMs: null, turns: null, error });
```

Poengene:

- **Linjebuffer.** `data` kan komme midt i en linje. Del bare på `\n`, og behold resten til neste bit.
- **Hver kjøring slutter med én `done`.** Kommer det ingen `result`-linje (krasj, avbrutt, feil ved oppstart), lager runneren en `done` selv, med de siste linjene fra stderr, «Avbrutt» eller exit-koden. Da vet rendereren alltid når kjøringen er over.
- **`active()`** gir kjøringene som pågår. Rendereren bruker det etter en omlasting (avsnitt 5).
- **`close()`** kalles når serveren stopper (`httpServer.on('close')`) og når Electron avslutter (`app.on('before-quit')`), så ingen `claude`-prosesser blir hengende igjen.
- **`spawn` og `env` kan injiseres**, så runneren kan testes uten ekte Claude Code (avsnitt 9).

## 5. API og transport

### Kallene

Rendereren kan gjøre fire kall. Navnene er de samme uansett transport:

```ts
interface ClaudeApi {
  claudeStatus(): Promise<{ available: boolean; path: string | null; version: string | null }>;
  /** Starter en kjøring; hendelsene kommer som 'app:claude' med { runId, event } */
  claudeRun(req: RunRequest): Promise<{ runId: string }>;
  claudeCancel(runId: string): Promise<void>;
  claudeActive(): Promise<string[]>;
}

interface RunRequest {
  prompt: string;
  sessionId?: string | null;   // fortsett samtalen
  path?: string | null;        // det brukeren ser på, som kontekst
  mentions?: string[];         // filer/mapper brukeren har lagt ved
  dirs?: string[];             // ekstra mapper Claude kan lese
}
```

Backenden har én `dispatch(api, method, arg)` som sjekker navnet mot en fast liste før den kaller metoden, så transporten aldri kan kalle noe annet enn API-et. Den samme `createApi()` brukes av begge transportene; de pakker bare inn og ut.

### Dev-server / webserver: HTTP + websocket

- **Kall:** `POST /<prefiks>/api/<metode>` med JSON-argumentet som body. Svaret er `{ ok: true, value }` eller `{ ok: false, error }`.
- **Hendelser:** `runner.on(d => ws.send({ type: 'custom', event: 'app:claude', data: d }))`. I Vite er det `server.ws.send`, og rendereren lytter med `import.meta.hot.on('app:claude', …)`. Utenfor Vite fungerer en vanlig websocket eller Server-Sent Events like godt.
- **Beskytt endepunktet.** Det kan starte en prosess som endrer filer. Godta bare `POST`, og avvis kall der `Origin` ikke er samme host som `Host`, så en annen side i nettleseren ikke kan bruke det. Lytt bare på `localhost`.

```ts
const origin = req.headers.origin;
if (req.method !== 'POST' || (origin && new URL(origin).host !== req.headers.host)) {
  res.statusCode = 403;
  return res.end(JSON.stringify({ ok: false, error: 'Ikke tillatt' }));
}
```

### Electron: IPC

- **Main:** `ipcMain.handle('app:invoke', (_e, method, arg) => dispatch(api, method, arg))`, som returnerer `{ ok, value }` / `{ ok: false, error }`. En feil som kastes over IPC, får Electrons «Error invoking remote method …» foran meldingen; med konvolutten blir feilmeldingen ren, og svaret har samme form som over HTTP. Hendelser sendes med `win.webContents.send('app:event', 'app:claude', data)`.
- **Preload:** `contextBridge.exposeInMainWorld('app', { invoke, on })`, der `on` holder en `Map<event, Set<fn>>` og returnerer en funksjon som melder av.
- Vinduet har `contextIsolation: true` og `sandbox: true`. Rendereren får aldri Node-tilgang; den kan bare gjøre kallene i lista.

### Transport-abstraksjonen i rendereren

Komponentene snakker bare med ett objekt:

```ts
interface Transport {
  kind: 'http' | 'electron' | 'static';
  on(event: string, fn: (data: any) => void): () => void;
  call<M extends keyof ClaudeApi>(method: M, ...arg: Parameters<ClaudeApi[M]>): ReturnType<ClaudeApi[M]>;
}
export const transport = window.app ? electron(window.app) : http();
```

Da er panelet likt i nettleseren og i desktop-appen. I et statisk bygg (uten backend) er `kind` `'static'`, og panelet vises ikke.

## 6. Konteksten Claude får

`--append-system-prompt` forteller Claude hvor den kjører, og hva brukeren ser på. Teksten bygges på nytt for hver melding:

```ts
function contextPrompt(req: RunRequest, dirs: string[]): string {
  return [
    'Du kjører inne i <appnavn>, i prosjektet <…>.',
    'Brukeren er <målgruppe>. Svar kort og på <språk>.',
    'Endringer du gjør i filene, vises straks i appen. Du kan ikke committe eller pushe selv.',
    // valgfritt: be om strukturerte handlinger i svaret, se avsnitt 8
    'Vil brukeren sende endringene, avslutter du svaret med en kodeblokk med språket app-pr og JSON: {"title": …, "paths": […]}.',
    'Du har ikke shell-tilgang; bruk Read, Glob, Grep, Edit og Write.',
    'AskUserQuestion finnes ikke her: still spørsmålene i svaret, og vent på brukeren.',
    dirs.length ? `Du kan lese ${dirs.join(', ')}, men ikke endre dem.` : '',
    req.path ? `Brukeren ser nå på ${req.path}.` : '',
    req.mentions?.length ? `Brukeren har lagt ved ${req.mentions.join(', ')}. Les dem før du svarer.` : '',
  ].filter(Boolean).join('\n');
}
```

- **Si fra om begrensningene.** Uten linjene om shell og `AskUserQuestion` prøver Claude verktøy som blir avvist, og bruker steg på det.
- **Det brukeren ser på** sendes med hver melding (stien, ikke innholdet). Claude leser fila selv hvis den trenger den. I panelet vises den som en badge i inputfeltet, og ✕ holder den utenfor til brukeren åpner en annen fil.
- **Vedlegg med `@`.** Brukeren kan søke opp filer og mapper og legge dem ved neste melding. Valider stiene i backenden før de havner i systemteksten: bare under en kjent rotmappe, ingen `..`, ingen linjeskift, og høyst 50.

## 7. Samtale-state i rendereren

### Rene funksjoner

All logikk for samtalen er rene funksjoner over `ClaudeEvent`, så den kan testes med `node --test` uten nettleser:

```ts
type ChatItem =
  | { kind: 'user'; text: string; path: string | null; mentions?: string[] }
  | { kind: 'assistant'; text: string }
  | { kind: 'tool'; id: string; name: string; summary: string; state: 'running' | 'ok' | 'error' }
  | { kind: 'done'; ok: boolean; text: string };

interface Chat {
  items: ChatItem[];
  sessionId: string | null;     // til --resume
  runId: string | null;         // kjøringen som pågår
  touched: string[];            // filer Claude har endret i samtalen
  context: { used: number; window: number | null } | null;
}

export function apply(chat: Chat, runId: string, ev: ClaudeEvent): Chat {
  if (runId !== chat.runId) return chat;            // hendelser fra andre kjøringer ignoreres
  switch (ev.kind) {
    case 'init':  return { ...chat, sessionId: ev.sessionId };
    case 'text':  return { ...chat, items: [...chat.items, { kind: 'assistant', text: ev.text }] };
    case 'tool': {
      const edits = ['Edit', 'Write', 'MultiEdit', 'NotebookEdit'].includes(ev.name);
      const touched = edits && !chat.touched.includes(ev.summary) ? [...chat.touched, ev.summary] : chat.touched;
      return { ...chat, touched, items: [...chat.items, { kind: 'tool', id: ev.id, name: ev.name, summary: ev.summary, state: 'running' }] };
    }
    case 'toolResult':
      return { ...chat, items: chat.items.map(i => i.kind === 'tool' && i.id === ev.id ? { ...i, state: ev.isError ? 'error' : 'ok' } : i) };
    case 'usage':
      return { ...chat, context: { used: ev.tokens, window: chat.context?.window ?? null } };
    case 'done': {
      // Verktøy som aldri fikk svar (avbrutt eller feil), er ikke lenger i gang
      const items = chat.items.map(i => i.kind === 'tool' && i.state === 'running' ? { ...i, state: ev.ok ? 'ok' : 'error' } as ChatItem : i);
      const context = chat.context && ev.contextWindow ? { ...chat.context, window: ev.contextWindow } : chat.context;
      return { ...chat, runId: null, context, sessionId: ev.sessionId ?? chat.sessionId,
        items: [...items, { kind: 'done', ok: ev.ok, text: ev.ok ? 'Ferdig' : ev.error ?? 'Feil' }] };
    }
  }
}
```

Rundt `apply` ligger funksjonene for flere samtaler: `send` (legger til brukerens melding), `started` (setter `runId`), `createConversation` (gjenbruker en tom samtale hvis det finnes en), `removeConversation`, `selectConversation`, `updateConversation` (flytter samtalen øverst ved ny melding, og gir den tittel fra første melding) og `applyEvent` (finner samtalen som eier `runId`).

### Store utenfor komponenten

Samtalene ligger i en variabel på modulnivå med en liste av lyttere, ikke i komponent-state. Da lever de videre når panelet lukkes eller brukeren bytter visning, og hendelser som kommer mens panelet er lukket, havner likevel i riktig samtale. Lytteren på `app:claude` registreres én gang, når modulen lastes.

### Lagring og omlasting

- Samtalene lagres i `localStorage` (debounce 300 ms, og en siste lagring i `beforeunload`). Claude Code husker selve samtalen via `sessionId`; appen lagrer bare det panelet viser.
- `localStorage` er per origin. Bruk en fast port (`strictPort` i Vite), ellers forsvinner samtalene når porten endres.
- **Etter en omlasting** vet ikke rendereren om en lagret kjøring fortsatt pågår. Den spør `claudeActive()`: kjøringer som fortsatt er i gang, beholder `runId`, og panelet fortsetter å ta imot hendelser (backenden sender dem uansett). Kjøringer som ikke er i gang lenger, avsluttes i visningen med en melding om at svaret ligger hos Claude og kommer med neste melding (`--resume` tar det med).

### Hendelser som kommer før `runId`

`claudeRun` returnerer `runId`, men de første hendelsene (`init`, gjerne tekst) kan komme over websocket/IPC før svaret på kallet. Da finnes det ingen samtale med den `runId`-en ennå. Legg dem i en buffer, og spill dem av når `runId` er satt:

```ts
const early = new Map<string, ClaudeEvent[]>();
transport.on('app:claude', ({ runId, event }) => {
  const next = applyEvent(convs, runId, event, Date.now());
  if (next) set(next);
  else early.set(runId, [...(early.get(runId) ?? []), event]);
});

// når brukeren sender
const { runId } = await transport.call('claudeRun', { prompt, sessionId, path, mentions });
set(updateConversation(convs, id, ch => started(ch, runId), Date.now()));
for (const ev of early.get(runId) ?? []) {
  const next = applyEvent(convs, runId, ev, Date.now());
  if (next) set(next);
}
early.delete(runId);
```

## 8. Panelet

Det meste er vanlig UI. Noen ting som gjør panelet nyttig:

- **Svarene er markdown.** Bruk samme markdown-parser som resten av appen. Lenker og `kode` som peker på filer i prosjektet (relative stier, eller absolutte stier inn i prosjektmappa), åpnes i appen i stedet for i nettleseren.
- **Verktøykall** vises som en linje med status (kjører / ok / feil) og en kort oppsummering. Leser eller endrer Claude en fil appen kan vise, er filnavnet en lenke.
- **«Endret i samtalen»** under lista viser `touched`, så brukeren ser hvilke filer som er endret, og kan åpne dem.
- **Kontekstmåler** under tittelen: `used` av `window` (f.eks. «59k av 1M · 6 %»). Claude Code komprimerer samtalen selv når vinduet blir fullt.
- **Avbryt** kaller `claudeCancel(runId)`. Mens en kjøring pågår, kan det ikke sendes ny melding i samme samtale.
- **Lange meldinger** (f.eks. en prompt sendt fra en annen visning) foldes til de første linjene.
- **Utkastet** i inputfeltet (tekst og vedlegg) lagres i `localStorage`, så det overlever omlasting og at panelet lukkes.
- **Enter** sender, **Shift+Enter** gir ny linje.
- **Bredden** kan endres ved å dra i venstre kant (også med piltastene), og huskes.
- **Samtaleliste** med «Ny» og «Slett». Sletting avbryter en kjøring som pågår.

### Strukturerte handlinger i svaret

Claude har ikke lov til å gjøre alt selv (her: lage PR, som krever Bash og nettverk). I stedet ber systemteksten Claude skrive et forslag i en kodeblokk med et fast språknavn og JSON, og markdown-visningen gjør blokken om til en knapp i appen. Brukeren bekrefter handlingen med ett klikk, og appen utfører den med sin egen kode.

````
Jeg har endret kravet.

```krav-pr
{ "title": "Krav: …", "branch": "kort-slug", "body": "…", "paths": ["krav/a.feature"] }
```
````

- Tolkningen er en ren funksjon (her `parsePrProposal` i `src/prProposal.ts`): `JSON.parse`, sjekk påkrevde felt, og filtrer verdiene med de samme reglene som backenden bruker når handlingen utføres. Ugyldig JSON eller manglende felt gir `null`, og blokken vises som vanlig kode.
- Verdier som ikke godtas (her: filer utenfor `krav/`), vises på kortet som «kan ikke tas med», i stedet for å forsvinne.
- Si tydelig i systemteksten at blokken *er* måten handlingen gjøres på her, ellers svarer Claude at den ikke kan, eller ber brukeren gjøre det for hånd.
- Knappen fyller ut appens vanlige dialog (her «Lag PR»), den utfører ikke handlingen direkte. Brukeren ser alltid hva som sendes.

Mønsteret passer for alle handlinger appen vil at Claude skal kunne foreslå, men ikke utføre: opprette en sak, sende en melding, starte en jobb.

### Sende prompt fra andre visninger

Andre deler av appen kan ha knapper som lager en prompt (her: «Send til Claude Code» i dashbordet over avvik). En liten bro på modulnivå kobler dem til panelet uten at de kjenner hverandre:

```ts
let sender: ((text: string) => Promise<void>) | null = null;
let busy = false;
const listeners = new Set<() => void>();

export function registerClaude(s: typeof sender) { sender = s; listeners.forEach(l => l()); }
export function setClaudeBusy(b: boolean) { if (b !== busy) { busy = b; listeners.forEach(l => l()); } }

export function useClaudeTarget() {
  const [, force] = useState(0);
  useEffect(() => { const l = () => force(n => n + 1); listeners.add(l); return () => void listeners.delete(l); }, []);
  return { ready: sender !== null, busy, send: (t: string) => (sender ? sender(t) : Promise.resolve()) };
}
```

Panelet kaller `registerClaude(send)` når det er åpent og Claude Code finnes, og `registerClaude(null)` når det lukkes. Knappen viser «Send til Claude» når `ready`, og «Kopier prompt» ellers.

## 9. Testing

- **Rene funksjoner** (`parseStreamLine`, `contextPrompt`, `apply` og samtalefunksjonene) testes direkte med `node --test`, med linjer fra ekte `stream-json`-utdata som fixtures.
- **Runneren** testes med en falsk `claude`: et lite kjørbart skript i en midlertidig mappe, pekt ut med miljøvariabelen som overstyrer stien (`env` sendes til konstruktøren). Skriptet skriver en `init`-linje, en tekstlinje som ekkoer argumentene, stdin og `cwd` som JSON, og en `result`-linje. Da kan testen sjekke at
  - meldingen går på stdin (også en melding som begynner med `--`),
  - `cwd` er prosjektmappa,
  - argumentene har riktige flagg, verktøy, `--resume` og systemtekst,
  - Bash ikke er tillatt,
  - en krasj gir `done` med feilen fra stderr,
  - `cancel()` gir `done` med «Avbrutt», og `active()` er tom etterpå.
- Slike tester kjøres ikke på Windows (skriptet trenger en shebang), eller de trenger en `.cmd`-variant.

## 10. Sjekkliste for å ta det i bruk

1. Lag `ClaudeRunner` med `findClaude`, `buildArgs`, `parseStreamLine` og `contextPrompt`. Velg `--allowedTools` etter hva appen trenger, og skriv systemteksten for appen.
2. Legg de fire kallene inn i API-et, bak en `dispatch` som sjekker navnet.
3. Koble runneren til transporten: websocket/SSE eller IPC for hendelser, og `POST` med Origin-sjekk (webserver) eller `ipcMain.handle` (Electron) for kall.
4. Skriv samtale-staten som rene funksjoner, med store på modulnivå, `localStorage`, gjenoppretting med `claudeActive()` og buffer for tidlige hendelser.
5. Lag panelet.
6. Test med falsk `claude`.

Det som er spesielt for denne appen, og bør byttes ut:

| Her | Byttes med |
|-----|------------|
| Hendelsesnavnet `krav:claude` | Appens eget, f.eks. `app:claude` |
| `/__krav/api/<metode>` | Appens eget prefiks |
| `KRAV_CLAUDE_PATH` | Appens egen miljøvariabel |
| `kravforvaltning:claudeChats` i `localStorage` | Appens egen nøkkel |
| `krav/` som rotmappe for vedlegg og «Endret i samtalen» | Mappa (eller mappene) appen viser |
| Systemteksten i `contextPrompt` | Tekst for appen og brukerne |
| `CLAUDE_TOOLS` | Verktøyene appen skal tillate |
| `krav-pr`-blokken og «Lag PR» | Handlingene appen vil at Claude skal kunne foreslå |
