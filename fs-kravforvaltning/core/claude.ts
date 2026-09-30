import { spawn, execFile, type ChildProcess } from 'node:child_process';
import { EventEmitter } from 'node:events';
import { accessSync, constants, readdirSync, readFileSync, statSync } from 'node:fs';
import { homedir } from 'node:os';
import { delimiter, dirname, isAbsolute, join, resolve } from 'node:path';
import { promisify } from 'node:util';
import { CLAUDE_SKILLS, CODE_DIRS, type ClaudeEvent, type CodeDir, type ClaudeRunRequest, type ClaudeSkill, type ClaudeSkills, type ClaudeStatus } from '../shared/api.ts';

const exec = promisify(execFile);
const isWin = process.platform === 'win32';

/**
 * Verktøyene Claude får bruke. `-p` kan ikke spørre brukeren om lov, så med `--permission-mode dontAsk`
 * avvises alt som ikke står her (også Bash og nettverk). Endringer i filene plukkes opp av watcheren
 * og vises i vieweren som når de lagres i en editor. Skill-verktøyet tillates bare for skillene som er tillatt i visningen.
 */
export const CLAUDE_TOOLS = ['Read', 'Glob', 'Grep', 'Edit', 'Write', 'TodoWrite'];

const isDir = (p: string) => {
  try {
    return statSync(p).isDirectory();
  } catch {
    return false;
  }
};

/**
 * Kodeklonene fs-verify leter i. Stien er overstyringen fra vieweren, ellers `KRAV_FS_ADMIN` /
 * `KRAV_FS_PLATTFORM`, ellers mappa ved siden av repoet (der de ligger i en vanlig utviklermappe).
 * `siblings: false` (desktop-appen, der repoet er appens egen klone): ingen standardsti, brukeren velger mappa.
 */
export function codeDirs(repo: string, env: NodeJS.ProcessEnv = process.env, overrides: unknown = {}, siblings = true): CodeDir[] {
  const o = overrides && typeof overrides === 'object' ? (overrides as Record<string, unknown>) : {};
  return CODE_DIRS.map(name => {
    const given = o[name];
    const fromEnv = env[`KRAV_${name.replace('-', '_').toUpperCase()}`];
    const path = typeof given === 'string' && given.trim() ? given.trim() : fromEnv || (siblings ? resolve(repo, '..', name) : '');
    return { name, path, exists: !!path && isAbsolute(path) && isDir(path) };
  });
}

/** En absolutt sti som regel i `--disallowedTools`: `//sti` (POSIX-form, også på Windows: `//c/Users/…`) */
const posix = (p: string) => resolve(p).replace(/\\/g, '/').replace(/^([A-Za-z]):/, (_, d: string) => '/' + d.toLowerCase());

/**
 * Argumentene for kodemappene: `--add-dir` så Claude kan lese dem, og `Edit(//<sti>/**)` i
 * `--disallowedTools` så de ikke kan endres (Edit-regler gjelder alle verktøy som skriver filer).
 * Bare absolutte stier til mapper som finnes, tas med.
 */
export function dirArgs(dirs: unknown): { paths: string[]; add: string[]; deny: string[] } {
  const ok = [...new Set((Array.isArray(dirs) ? dirs : []).filter((d): d is string => typeof d === 'string' && isAbsolute(d) && isDir(d)).map(d => resolve(d)))];
  return { paths: ok, add: ok.flatMap(d => ['--add-dir', d]), deny: ok.map(d => `Edit(/${posix(d)}/**)`) };
}

const canRun = (p: string) => {
  try {
    accessSync(p, isWin ? constants.F_OK : constants.X_OK);
    return true;
  } catch {
    return false;
  }
};

/**
 * Finner den lokale `claude`-installasjonen. En app som startes fra Finder eller Start-menyen har en
 * kort PATH, så vanlige installasjonssteder og innloggingsskallets PATH sjekkes også.
 */
export async function findClaude(env: NodeJS.ProcessEnv = process.env): Promise<string | null> {
  if (env.KRAV_CLAUDE_PATH) return canRun(env.KRAV_CLAUDE_PATH) ? env.KRAV_CLAUDE_PATH : null;
  const names = isWin ? ['claude.exe', 'claude.cmd'] : ['claude'];
  const home = homedir();
  const dirs = [
    ...(env.PATH ?? '').split(delimiter),
    join(home, '.local', 'bin'),
    join(home, '.claude', 'local'),
    ...(isWin ? [join(env.APPDATA ?? '', 'npm')] : ['/opt/homebrew/bin', '/usr/local/bin']),
  ].filter(Boolean);
  for (const d of dirs) for (const n of names) if (canRun(join(d, n))) return join(d, n);
  if (!isWin && env.SHELL) {
    try {
      const p = (await exec(env.SHELL, ['-ilc', 'command -v claude'], { timeout: 5000 })).stdout.trim().split('\n').pop();
      if (p && canRun(p)) return p;
    } catch {
      /* ingen claude i innloggingsskallet heller */
    }
  }
  return null;
}

/** Gyldige skill-navn, også fra plugins (`plugin:skill`) */
export const SKILL_NAME = /^[\w.-]+(:[\w.-]+)?$/;

/** `name` og `description` fra frontmatter i en SKILL.md (også foldet YAML: `description: >`) */
export function skillMeta(src: string): { name: string | null; description: string } {
  const fm = src.match(/^---\r?\n([\s\S]*?)\r?\n---/)?.[1] ?? '';
  const lines = fm.split(/\r?\n/);
  const value = (key: string) => {
    const i = lines.findIndex(l => l.startsWith(key + ':'));
    if (i < 0) return '';
    const v = lines[i].slice(key.length + 1).trim();
    if (/^[>|][-+]?$/.test(v)) {
      const body: string[] = [];
      for (const l of lines.slice(i + 1)) {
        if (l.trim() && !/^\s/.test(l)) break;
        body.push(l.trim());
      }
      return body.join(' ').replace(/\s+/g, ' ').trim();
    }
    return v.replace(/^(['"])(.*)\1$/, '$2');
  };
  return { name: value('name') || null, description: value('description') };
}

/** Skillene i repoets `.claude/skills/<navn>/SKILL.md` */
export function projectSkills(cwd: string): ClaudeSkill[] {
  const dir = join(cwd, '.claude', 'skills');
  let names: string[];
  try {
    names = readdirSync(dir, { withFileTypes: true }).filter(d => d.isDirectory()).map(d => d.name);
  } catch {
    return [];
  }
  return names
    .flatMap(n => {
      try {
        const meta = skillMeta(readFileSync(join(dir, n, 'SKILL.md'), 'utf8'));
        return [{ name: meta.name ?? n, description: meta.description }];
      } catch {
        return [];
      }
    })
    .filter(s => SKILL_NAME.test(s.name))
    .sort((a, b) => a.name.localeCompare(b.name, 'nb'));
}

/** Kort, lesbar oppsummering av et verktøykall: filnavnet, mønsteret eller skill-navnet */
export function toolSummary(name: string, input: Record<string, unknown> = {}): string {
  const file = (p: unknown) => (typeof p === 'string' ? p.replace(/^.*?\/krav\//, 'krav/') : '');
  if (input.file_path) return file(input.file_path);
  if (typeof input.pattern === 'string') return input.pattern + (input.path ? ` i ${file(input.path)}` : '');
  if (typeof input.skill === 'string') return input.skill;
  if (Array.isArray(input.todos)) return `${input.todos.length} punkter`;
  return name;
}

/** Største kontekstvindu blant modellene i `modelUsage` (hovedmodellen har det største; underagenter kan ha mindre) */
function contextWindow(modelUsage: unknown): number | null {
  if (!modelUsage || typeof modelUsage !== 'object') return null;
  const sizes = Object.values(modelUsage as Record<string, { contextWindow?: unknown }>)
    .map(m => m?.contextWindow)
    .filter((n): n is number => typeof n === 'number' && n > 0);
  return sizes.length ? Math.max(...sizes) : null;
}

/** Oversetter én linje fra `--output-format stream-json` til hendelsene vieweren viser */
export function parseStreamLine(line: string): ClaudeEvent[] {
  let msg: any;
  try {
    msg = JSON.parse(line);
  } catch {
    return [];
  }
  if (msg.type === 'system' && msg.subtype === 'init') {
    const skills = Array.isArray(msg.skills) ? msg.skills.filter((x: unknown): x is string => typeof x === 'string') : [];
    return [{ kind: 'init', sessionId: msg.session_id, model: msg.model ?? null, skills }];
  }
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
  if (msg.type === 'user' && msg.parent_tool_use_id == null) {
    return (msg.message?.content ?? []).flatMap((c: any): ClaudeEvent[] =>
      c.type === 'tool_result' ? [{ kind: 'toolResult', id: c.tool_use_id, isError: !!c.is_error }] : [],
    );
  }
  if (msg.type === 'result') {
    return [
      {
        kind: 'done',
        ok: msg.subtype === 'success' && !msg.is_error,
        sessionId: msg.session_id ?? null,
        durationMs: msg.duration_ms ?? null,
        turns: msg.num_turns ?? null,
        error: msg.subtype === 'success' && !msg.is_error ? null : (typeof msg.result === 'string' && msg.result) || msg.subtype || 'Ukjent feil',
        contextWindow: contextWindow(msg.modelUsage),
      },
    ];
  }
  return [];
}

/** Skillene fra `pool` som kan velges i panelet, i fast rekkefølge */
export function skillPool(pool: unknown): string[] {
  return Array.isArray(pool) ? CLAUDE_SKILLS.filter(s => pool.includes(s)) : [];
}

/**
 * Argumentene som bestemmer hvilke skills Claude kan bruke: den valgte og skillene i `pool` (de som er
 * tillatt i visningen). Den valgte er bare et forslag som lastes med meldingen; Claude kan bytte til en
 * annen i `pool` når oppgaven krever det. De får `Skill(<navn>)` i `--allowedTools`, og alle andre kjente skills får
 * `Skill(<navn>)` i `--disallowedTools`. Allowlisten alene holder ikke: `dontAsk` slipper gjennom enkelte
 * skills som ikke står der, så de andre må avvises eksplisitt.
 */
export function skillArgs(skill: string | null, known: Iterable<unknown>, pool: unknown = []): { allow: string[]; deny: string[] } {
  const chosen = skill && CLAUDE_SKILLS.includes(skill) ? skill : null;
  const inPool = skillPool(pool);
  const allowed = CLAUDE_SKILLS.filter(s => s === chosen || inPool.includes(s));
  const others = new Set<string>();
  for (const n of known) if (typeof n === 'string' && SKILL_NAME.test(n) && !allowed.includes(n)) others.add(n);
  return { allow: allowed.map(n => `Skill(${n})`), deny: [...others].sort().map(n => `Skill(${n})`) };
}

/** Stiene brukeren har lagt ved med @: bare under krav/, uten `..`, og høyst 50 */
export function mentionPaths(raw: unknown): string[] {
  if (!Array.isArray(raw)) return [];
  const ok = raw.filter((p): p is string => typeof p === 'string' && p.startsWith('krav/') && !p.split('/').includes('..') && !/[\n\r]/.test(p));
  return [...new Set(ok)].slice(0, 50);
}

/** Systemteksten som forteller Claude hvor den er, og hva brukeren ser på */
export function contextPrompt(
  path: string | null | undefined,
  skill: string | null = null,
  pool: string[] = [],
  dirs: string[] = [],
  mentions: string[] = [],
): string {
  const skills = CLAUDE_SKILLS.filter(s => s === skill || pool.includes(s));
  const others = skills.filter(s => s !== skill);
  return [
    'Du kjører inne i FS Kravforvaltning (desktop-appen eller dev-serveren) for FS-kravene i dette repoet.',
    'Brukeren er typisk en domeneekspert. Svar kort og på norsk.',
    'Følg konvensjonene i krav/README.md når du skriver eller endrer .feature-filer.',
    skill
      ? `Brukeren har valgt skillen ${skill} for denne samtalen, og den er lastet. ` +
        (others.length ? `Trenger oppgaven en annen skill, kan du bruke den med Skill-verktøyet: ${others.join(', ')}. ` : '') +
        'Andre skills er ikke tilgjengelige.'
      : pool.length
        ? `Brukeren har ikke valgt noen skill. Du kan bruke disse med Skill-verktøyet når oppgaven passer: ${pool.join(', ')}. Andre skills er ikke tilgjengelige.`
        : 'Brukeren har ikke valgt noen skill, og ingen skills er tilgjengelige.',
    'Endringer du gjør i filene vises straks i FS Kravforvaltning. Du kan ikke committe, pushe eller lage PR selv, men du kan foreslå en PR, som brukeren sender med ett klikk.',
    'Ber brukeren om en PR, eller har du endret filer under krav/ som brukeren sannsynligvis vil sende, avslutter du svaret med PR-forslaget i en kodeblokk med språket krav-pr og JSON: ' +
      '{"title": "Krav: …", "branch": "kort-slug-uten-prefiks", "body": "Kort beskrivelse på norsk av hva som er endret og hvorfor", "paths": ["krav/…"]}. ' +
      'Blokken er slik PR lages her: brukeren får et kort med «Åpne i «Lag PR»», som åpner «Lag PR» ferdig utfylt. Si ikke at du ikke kan lage PR, og be ikke brukeren fylle ut «Lag PR» for hånd. ' +
      'paths er .feature- og .md-filene under krav/ som er endret i samtalen. Filer utenfor krav/ (f.eks. tasks/) kan ikke sendes fra FS Kravforvaltning: ta dem ikke med i paths, men si fra om dem i teksten.',
    'Du har ikke shell-tilgang; bruk Read, Glob, Grep, Edit og Write. AskUserQuestion finnes ikke her: still spørsmålene i svaret, og vent på brukeren.',
    dirs.length ? `Du kan lese kodeklonene ${dirs.join(', ')}, men ikke endre dem.` : '',
    skills.includes('fs-verify')
      ? 'fs-verify: du kan ikke slette filer. Skal en @deprecated-fil slettes, si hvilken, så sletter brukeren den selv. Blokker i en fil kan du fjerne med Edit.' +
        (dirs.length ? '' : ' Ingen kodekloner er tilgjengelige; brukeren setter dem under «Kodemapper» i panelet.')
      : '',
    path ? `Brukeren ser nå på fila ${path}.` : '',
    mentions.length
      ? `Brukeren har lagt ved disse filene og mappene med @: ${mentions.join(', ')}. Les dem (mappene med Glob og Read) før du svarer.`
      : '',
  ]
    .filter(Boolean)
    .join('\n');
}

interface Run {
  proc: ChildProcess;
  cancelled: boolean;
}

/**
 * Kjører den lokale Claude Code-en (`claude -p … --output-format stream-json`) med repoet som arbeidsmappe.
 * Hver melding er én kjøring; samtalen fortsetter med `--resume <sessionId>`. Claude bruker brukerens egen
 * innlogging og innstillinger. Hendelsene sendes som `krav:claude` med `{ runId, event }`.
 */
export class ClaudeRunner {
  private readonly emitter = new EventEmitter();
  private readonly runs = new Map<string, Run>();
  private bin: Promise<string | null> | null = null;
  /** Alle skills Claude meldte ved siste oppstart (også plugins og personlige); `null` før første kjøring */
  private lastSkills: string[] | null = null;
  private seq = 0;

  readonly cwd: string;
  /** `siblingDirs: false`: kodeklonene har ingen standardsti ved siden av repoet (desktop-appen) */
  private readonly opts: { env?: NodeJS.ProcessEnv; spawn?: typeof spawn; siblingDirs?: boolean };

  constructor(cwd: string, opts: { env?: NodeJS.ProcessEnv; spawn?: typeof spawn; siblingDirs?: boolean } = {}) {
    this.cwd = cwd;
    this.opts = opts;
  }

  on(fn: (data: { runId: string; event: ClaudeEvent }) => void) {
    this.emitter.on('krav:claude', fn);
    return () => void this.emitter.off('krav:claude', fn);
  }

  private emit(runId: string, event: ClaudeEvent) {
    this.emitter.emit('krav:claude', { runId, event });
  }

  private find() {
    this.bin ??= findClaude(this.opts.env).then(b => {
      if (!b) this.bin = null; // prøv igjen neste gang, i tilfelle brukeren installerer i mellomtiden
      return b;
    });
    return this.bin;
  }

  async status(): Promise<ClaudeStatus> {
    const bin = await this.find();
    if (!bin) return { available: false, path: null, version: null };
    const version = await exec(bin, ['--version'], { timeout: 10000, shell: bin.endsWith('.cmd') })
      .then(r => r.stdout.trim(), () => null);
    return { available: true, path: bin, version };
  }

  async run(req: ClaudeRunRequest): Promise<{ runId: string }> {
    if (typeof req?.prompt !== 'string' || !req.prompt.trim()) throw new Error('Skriv en melding først');
    const bin = await this.find();
    if (!bin) throw new Error('Fant ikke Claude Code (claude) på maskinen');
    // Unik også på tvers av omstarter, siden vieweren husker kjøringen som pågår i samtalen
    const runId = `${Date.now().toString(36)}-${++this.seq}`;
    const skill = req.skill && CLAUDE_SKILLS.includes(req.skill) ? req.skill : null;
    // Alle skills vi kjenner: prosjektets fra disk, de Claude meldte sist, og de vieweren husker fra før
    const known = [...projectSkills(this.cwd).map(s => s.name), ...(this.lastSkills ?? []), ...(Array.isArray(req.knownSkills) ? req.knownSkills : [])];
    const pool = skillPool(req.skills);
    const { allow, deny } = skillArgs(skill, known, pool);
    const dirs = dirArgs(req.dirs);
    const args = [
      '-p',
      '--output-format', 'stream-json',
      '--verbose',
      '--permission-mode', 'dontAsk',
      '--allowedTools', ...CLAUDE_TOOLS, ...allow,
      ...dirs.add,
      '--append-system-prompt', contextPrompt(req.path, skill, pool, dirs.paths, mentionPaths(req.mentions)),
      ...(req.sessionId ? ['--resume', req.sessionId] : []),
      ...(deny.length || dirs.deny.length ? ['--disallowedTools', ...deny, ...dirs.deny] : []),
    ];
    const env = { ...(this.opts.env ?? process.env) };
    // Den korte PATH-en fra Finder: ta med mappa claude ligger i (npm-installasjoner trenger node derfra)
    env.PATH = [dirname(bin), env.PATH].filter(Boolean).join(delimiter);
    const proc = (this.opts.spawn ?? spawn)(bin, args, { cwd: this.cwd, env, shell: bin.endsWith('.cmd'), stdio: ['pipe', 'pipe', 'pipe'] });
    const run: Run = { proc, cancelled: false };
    this.runs.set(runId, run);

    let buf = '';
    let stderr = '';
    let done = false;
    proc.stdout!.setEncoding('utf8');
    proc.stdout!.on('data', (chunk: string) => {
      buf += chunk;
      let nl: number;
      while ((nl = buf.indexOf('\n')) >= 0) {
        const line = buf.slice(0, nl).trim();
        buf = buf.slice(nl + 1);
        for (const ev of line ? parseStreamLine(line) : []) {
          if (ev.kind === 'done') done = true;
          if (ev.kind === 'init' && ev.skills.length) this.lastSkills = ev.skills;
          this.emit(runId, ev);
        }
      }
    });
    proc.stderr!.setEncoding('utf8');
    proc.stderr!.on('data', (chunk: string) => (stderr = (stderr + chunk).slice(-4000)));
    proc.on('error', e => {
      this.runs.delete(runId);
      this.emit(runId, { kind: 'done', ok: false, sessionId: null, durationMs: null, turns: null, error: `Kunne ikke starte claude: ${e.message}` });
    });
    proc.on('close', code => {
      this.runs.delete(runId);
      if (done) return;
      const error = run.cancelled ? 'Avbrutt' : stderr.trim().split('\n').slice(-3).join('\n') || `claude avsluttet med kode ${code}`;
      this.emit(runId, { kind: 'done', ok: false, sessionId: null, durationMs: null, turns: null, error });
    });
    // Meldingen går inn på stdin, så den aldri kan tolkes som et flagg. `/<skill>` først laster skillen.
    proc.stdin!.end(skill && req.invoke ? `/${skill} ${req.prompt}` : req.prompt);
    return { runId };
  }

  /** Prosjektets skills fra disk, og de andre Claude har meldt om (etter første kjøring) */
  skills(): ClaudeSkills {
    const project = projectSkills(this.cwd);
    const own = new Set(project.map(p => p.name));
    return { project, other: this.lastSkills?.filter(n => !own.has(n)) ?? null };
  }

  /** Kodeklonene med standardstiene (eller `overrides` fra vieweren), og om de finnes */
  dirs(overrides?: unknown): CodeDir[] {
    return codeDirs(this.cwd, this.opts.env ?? process.env, overrides, this.opts.siblingDirs ?? true);
  }

  /** Kjøringene som pågår; vieweren kobler seg på igjen etter en omlasting */
  active(): string[] {
    return [...this.runs.keys()];
  }

  async cancel(runId: string) {
    const run = this.runs.get(runId);
    if (!run) return;
    run.cancelled = true;
    run.proc.kill();
  }

  close() {
    for (const id of [...this.runs.keys()]) void this.cancel(id);
  }
}
