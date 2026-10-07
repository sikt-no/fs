import { spawn, execFile, type ChildProcess } from 'node:child_process';
import { createHash } from 'node:crypto';
import { EventEmitter } from 'node:events';
import { accessSync, constants, readdirSync, readFileSync, rmSync, statSync, writeFileSync } from 'node:fs';
import { homedir, tmpdir } from 'node:os';
import { delimiter, dirname, isAbsolute, join, resolve } from 'node:path';
import { promisify } from 'node:util';
import { CLAUDE_SKILLS, CODE_DIRS, type ClaudeAnswerRequest, type ClaudeApproveRequest, type ClaudeEvent, type ClaudeMcpServer, type CodeDir, type ClaudeRunRequest, type ClaudeSkill, type ClaudeSkills, type ClaudeStatus } from '../shared/api.ts';
import { APPROVE_TIMEOUT_MS, APPROVE_TOOL, Approver, QUESTION_TIMEOUT_MS, isAskable, SAVE_SKETCH_TOOL, SECRET_KEY } from './approve.ts';
import { MCP_SERVERS, OWN_SERVER, readMcpServers, readonlyTools, type McpServers } from './mcp.ts';
import { saveSketch } from './save.ts';

const exec = promisify(execFile);
const isWin = process.platform === 'win32';

/**
 * Verktøyene Claude får bruke uten å spørre. Endringer i filene plukkes opp av watcheren og vises i vieweren som
 * når de lagres i en editor. Skill-verktøyet tillates bare for skillene som er tillatt i visningen. Alt annet går til
 * `--permission-prompt-tool` (appens `approve`, core/approve.ts): `mcp__*` og WebFetch spørres brukeren om i panelet,
 * resten avvises.
 */
export const CLAUDE_TOOLS = ['Read', 'Glob', 'Grep', 'Edit', 'Write', 'TodoWrite', SAVE_SKETCH_TOOL];

/**
 * Det som alltid avvises i panelet, uten spørsmål. Bash må stå her: Claude Code kjører kommandoer som bare leser
 * (`ls`, `cat`) uten å spørre, også med `dontAsk`.
 */
export const PANEL_DENY = ['Bash', 'WebSearch', 'NotebookEdit', 'Task', 'Agent'];

/** Argumentene som gjelder både panelet og utførekjøringen: spørsmål om lov går til appens `approve` */
export const PERMISSION_ARGS = ['--permission-mode', 'default', '--permission-prompt-tool', APPROVE_TOOL];

/** «Tillat alltid i denne samtalen» fra vieweren: bare verktøy som kan godkjennes (`isAskable`) */
export function allowedAlways(raw: unknown): string[] {
  return Array.isArray(raw) ? [...new Set(raw.filter(isAskable))].sort() : [];
}

/**
 * Kommandoene en utførekjøring kan kjøre i kode-repoet: bygge, teste og committe lokalt. Ikke push eller gh:
 * brukeren pusher og lager PR selv.
 */
export const EXECUTE_BASH = [
  'Bash(npm test:*)',
  'Bash(npm run:*)',
  'Bash(npx tsc:*)',
  'Bash(npx vitest:*)',
  'Bash(./gradlew:*)',
  'Bash(mvn:*)',
  'Bash(git status:*)',
  'Bash(git diff:*)',
  'Bash(git log:*)',
  'Bash(git switch -c:*)',
  'Bash(git add:*)',
  'Bash(git commit:*)',
];
export const EXECUTE_DENY_BASH = ['Bash(git push:*)', 'Bash(gh:*)'];

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
export const posix = (p: string) => resolve(p).replace(/\\/g, '/').replace(/^([A-Za-z]):/, (_, d: string) => '/' + d.toLowerCase());

/**
 * Argumentene for kodemappene: `--add-dir` så Claude kan lese dem, og `Edit(//<sti>/**)` i
 * `--disallowedTools` så de ikke kan endres (Edit-regler gjelder alle verktøy som skriver filer).
 * Bare absolutte stier til mapper som finnes, tas med.
 */
export function dirArgs(dirs: unknown): { paths: string[]; add: string[]; deny: string[] } {
  const ok = [...new Set((Array.isArray(dirs) ? dirs : []).filter((d): d is string => typeof d === 'string' && isAbsolute(d) && isDir(d)).map(d => resolve(d)))];
  return { paths: ok, add: ok.flatMap(d => ['--add-dir', d]), deny: ok.map(d => `Edit(/${posix(d)}/**)`) };
}

/**
 * Argumentene til en utførekjøring: cwd er kode-repoet (så repoets CLAUDE.md, innstillinger og skills gjelder),
 * kravrepoet får `--add-dir`. Edit tillates bare i kode-repoet og i `tasks/<d>/<s>/utforing.md` i kravrepoet
 * (med `dontAsk` avvises alt som ikke er tillatt). Skills tillates, unntatt kravrepoets egne (fs-krav, fs-specify …),
 * som skal brukes fra FS Kravforvaltning, ikke i en kjøring som endrer kode.
 */
export function executeArgs(repoRoot: string, target: unknown, kravSkills: string[]): { cwd: string; allow: string[]; deny: string[]; add: string[] } {
  const t = target && typeof target === 'object' ? (target as Record<string, unknown>) : {};
  const dir = typeof t.dir === 'string' ? t.dir : '';
  if (!dir || !isAbsolute(dir) || !isDir(dir)) throw new Error(`Fant ikke kodemappa ${typeof t.repo === 'string' ? t.repo : ''}: ${dir || '(ingen sti)'}`);
  const code = resolve(dir);
  if (code === resolve(repoRoot)) throw new Error('Kodemappa kan ikke være kravrepoet');
  return {
    cwd: code,
    allow: ['Read', 'Glob', 'Grep', 'TodoWrite', 'Skill', `Edit(/${posix(code)}/**)`, `Edit(/${posix(repoRoot)}/tasks/*/*/utforing.md)`, ...EXECUTE_BASH],
    deny: [...kravSkills.filter(n => SKILL_NAME.test(n)).sort().map(n => `Skill(${n})`), ...EXECUTE_DENY_BASH],
    add: ['--add-dir', resolve(repoRoot)],
  };
}

/** Systemteksten i en utførekjøring: hvilket repo, hvilken spesifikasjon, og protokollen for utforing.md */
export function implementPrompt(target: { repo: string; spec: string }, repoRoot: string): string {
  const spec = typeof target.spec === 'string' && /^tasks\/[^/]+\/[^/]+\/spec\/spec-[^/]+\.md$/.test(target.spec) ? target.spec : null;
  const dir = spec ? spec.replace(/\/spec\/[^/]+$/, '') : null;
  return [
    `Du kjører en utførekjøring fra FS Kravforvaltning i repoet ${target.repo} (arbeidsmappa). Svar kort og på norsk.`,
    `Kravrepoet sikt-no/fs ligger i ${resolve(repoRoot)} (lagt til med --add-dir). Der kan du lese alt, men bare endre utforing.md i oppgavemappa.`,
    spec ? `Spesifikasjonen som skal implementeres: ${join(resolve(repoRoot), spec)}. Les den, feature-filene den peker på og implementasjonsdetaljene (<feature>.design.md ved siden av feature-fila, når den finnes) før du begynner. Tekstene i implementasjonsdetaljene er fasiten, også når en skisse viser noe annet.` : '',
    'Bruk repoets egne skills og konvensjoner (CLAUDE.md) når du implementerer.',
    `Du kan bygge, teste og committe lokalt (${EXECUTE_BASH.map(b => b.slice(5, -1).replace(/:\*$/, '')).join(', ')}), men ikke pushe eller lage PR: det gjør brukeren.`,
    dir
      ? `Protokoll: sett «Status: pågår» og «Tatt av» under «### ${target.repo}» i ${join(resolve(repoRoot), dir, 'utforing.md')} når du begynner. Når du er ferdig, skriv «Overlevering» (det neste repo trenger å vite: nye felt, queries og mutations, endepunkter, kjente avvik), og si fra til brukeren at steget kan settes til levert når PR-en finnes. Er du blokkert, sett «Blokkert» med grunn.`
      : '',
    'AskUserQuestion virker: brukeren får spørsmålene som et kort med valgene, og svarene kommer tilbake til deg. Bruk det når du trenger et valg fra brukeren. Hopper brukeren over, still spørsmålene i svaret, og vent på brukeren.',
    'MCP-verktøy (mcp__*) og WebFetch kan brukes, men brukeren må godkjenne hvert kall i FS Kravforvaltning. Blir et kall avvist, ikke prøv igjen uten å spørre brukeren.',
  ]
    .filter(Boolean)
    .join('\n');
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

/**
 * Versjonen av en skill: sha1 over alle filene i mappa (relativ sti og innhold, sortert), så en endring i
 * `references/` også teller. Vieweren sammenligner den med versjonen som var lastet i samtalen.
 */
export function skillHash(dir: string): string {
  return skillFiles(dir).hash;
}

/** Når en fil i skillmappa sist ble endret på disk (ms). «Hent siste» og `git pull` skriver bare om filene som er endret. */
export function skillChangedAt(dir: string): number {
  return skillFiles(dir).changedAt;
}

function skillFiles(dir: string): { hash: string; changedAt: number } {
  const h = createHash('sha1');
  let changedAt = 0;
  const walk = (rel: string) => {
    let list;
    try {
      list = readdirSync(join(dir, rel), { withFileTypes: true }).sort((a, b) => (a.name < b.name ? -1 : a.name > b.name ? 1 : 0));
    } catch {
      return;
    }
    for (const d of list) {
      const r = rel ? `${rel}/${d.name}` : d.name;
      if (d.isDirectory()) walk(r);
      else if (d.isFile()) {
        try {
          const body = readFileSync(join(dir, r));
          h.update(r).update('\0').update(body).update('\0');
          changedAt = Math.max(changedAt, statSync(join(dir, r)).mtimeMs);
        } catch {
          /* fila forsvant underveis */
        }
      }
    }
  };
  walk('');
  return { hash: h.digest('hex'), changedAt: Math.round(changedAt) };
}

/** Skillene i repoets `.claude/skills/<navn>/SKILL.md`, med versjonen (`skillHash`) og når de sist ble endret */
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
        const { hash, changedAt } = skillFiles(join(dir, n));
        return [{ name: meta.name ?? n, description: meta.description, hash, changedAt }];
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
  const mcp = name.match(/^mcp__([\w.-]+?)__([\w.-]+)$/);
  if (mcp && mcp[1] === OWN_SERVER && mcp[2] === 'save_sketch' && typeof input.path === 'string') return input.path;
  if (mcp) {
    const vals = Object.entries(input)
      .filter(([k, v]) => (typeof v === 'string' || typeof v === 'number') && !SECRET_KEY.test(k) && String(v).length <= 60)
      .slice(0, 2)
      .map(([k, v]) => `${k} ${v}`);
    // claude.ai-koblinger: `claude_ai_Atlassian_Rovo` → «Atlassian Rovo»
    return `${mcp[1].replace(/^claude_ai_/, '').replace(/_/g, ' ')} · ${mcp[2]}${vals.length ? ` (${vals.join(', ')})` : ''}`;
  }
  if (input.file_path) return file(input.file_path);
  if (typeof input.url === 'string') return input.url.replace(/[?#].*$/, '');
  if (typeof input.pattern === 'string') return input.pattern + (input.path ? ` i ${file(input.path)}` : '');
  if (typeof input.skill === 'string') return input.skill;
  if (Array.isArray(input.todos)) return `${input.todos.length} punkter`;
  if (Array.isArray(input.questions)) return input.questions.map(q => (q as { header?: unknown })?.header).filter(h => typeof h === 'string').join(', ') || name;
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

/** MCP-serverne i `MCP_SERVERS` fra init-meldingen; claude.ai-koblinger logges inn på claude.ai, ikke med `/mcp` */
function mcpStatus(raw: unknown): ClaudeMcpServer[] {
  if (!Array.isArray(raw)) return [];
  return raw
    .filter((m): m is { name: string; status: string; source?: unknown } => !!m && typeof m.name === 'string' && typeof m.status === 'string')
    .filter(m => MCP_SERVERS.includes(m.name) && m.source !== 'claudeai')
    .map(m => ({ name: m.name, status: m.status }));
}

/** Et bilde fra et verktøyresultat (Figma `get_screenshot`, Read av et bilde), som `save_sketch` kan lagre */
export interface ToolImage {
  toolUseId: string;
  mediaType: string;
  data: string;
}

/** Bildene i verktøyresultatene på én linje fra stream-json. De sendes ikke til vieweren. */
export function streamImages(line: string): ToolImage[] {
  if (!line.includes('"image"')) return [];
  let msg: any;
  try {
    msg = JSON.parse(line);
  } catch {
    return [];
  }
  if (msg.type !== 'user' || !Array.isArray(msg.message?.content)) return [];
  return msg.message.content.flatMap((c: any): ToolImage[] =>
    c?.type === 'tool_result' && typeof c.tool_use_id === 'string' && Array.isArray(c.content)
      ? c.content
          .filter((x: any) => x?.type === 'image' && x.source?.type === 'base64' && typeof x.source.data === 'string')
          .map((x: any) => ({ toolUseId: c.tool_use_id, mediaType: String(x.source.media_type ?? ''), data: x.source.data }))
      : [],
  );
}

const EXT_TYPES: Record<string, string[]> = { png: ['image/png'], jpg: ['image/jpeg'], jpeg: ['image/jpeg'], webp: ['image/webp'] };

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
    return [{ kind: 'init', sessionId: msg.session_id, model: msg.model ?? null, skills, mcp: mcpStatus(msg.mcp_servers) }];
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

/** Det samme i panelet og i utførekjøringen: MCP-verktøy og WebFetch må godkjennes, og skisser lagres med save_sketch */
export const MCP_PROMPT =
  'MCP-verktøy (mcp__*) og WebFetch kan brukes, men brukeren må godkjenne hvert kall i panelet. Blir et kall avvist, ikke prøv igjen uten å spørre brukeren. ' +
  'Viser en MCP-server seg som ikke logget inn (needs-auth), si at brukeren må kjøre `claude` i terminalen og `/mcp` én gang for å logge inn; det kan ikke gjøres herfra. ' +
  `Bilder fra et verktøykall (get_screenshot i Figma, take_screenshot i chrome-devtools uten filePath) lagres med ${SAVE_SKETCH_TOOL} rett etter kallet (uten tool_use_id lagres det siste bildet), ikke med Write, som bare skriver tekst.`;

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
    'Ber brukeren om en PR, avslutter du svaret med PR-forslaget i en kodeblokk med språket krav-pr og JSON: ' +
      '{"title": "Krav: …", "branch": "kort-slug-uten-prefiks", "body": "Kort beskrivelse på norsk av hva som er endret og hvorfor", "paths": ["krav/…"]}. ' +
      'Blokken er slik PR lages her: brukeren får et kort med «Åpne i «Lag PR»», som åpner «Lag PR» ferdig utfylt. Si ikke at du ikke kan lage PR, og be ikke brukeren fylle ut «Lag PR» for hånd. ' +
      'Foreslå ikke PR på eget initiativ når du har endret filer: brukeren har knappen «Lag forslag til PR» i panelet. ' +
      'paths er filene som er endret i samtalen: .feature- og .md-filene under krav/, og i oppgavemappa (tasks/<domene>/<slug>/) alt under spec/ (spesifikasjonen, spec.log.md, questions-*.md, verify-*.md, krav-input/ med manifest, Figma-artefakter og skisser) og utforing.md. ' +
      'Ta med alt fs-specify, fs-specify-delta og fs-verify har skrevet der. Andre filer (f.eks. oppgave.md, roadmap.md) kan ikke sendes fra FS Kravforvaltning: ta dem ikke med i paths, men si fra om dem i teksten.',
    'Ber brukeren om en oppsummering av samtalen, så den kan brukes i en ny samtale, svarer du med en kodeblokk med språket krav-oppsummering og JSON: ' +
      '{"mal": "…", "gjort": "…", "beslutninger": "…", "apneSporsmal": "…", "nesteSteg": "…", "paths": ["…"]}. ' +
      'Feltene er korte setninger på norsk; la et felt være tomt når det ikke er noe å si. paths er filene som er lest eller endret i samtalen og er viktige for å fortsette, relative til repoet. ' +
      'Brukeren får et kort med «Start ny samtale med oppsummeringen».',
    'Du har ikke shell-tilgang; bruk Read, Glob, Grep, Edit og Write. AskUserQuestion virker: brukeren får spørsmålene som et kort med valgene, og svarene kommer tilbake til deg. Bruk det når du trenger et valg fra brukeren. Hopper brukeren over, still spørsmålene i svaret, og vent på brukeren.',
    MCP_PROMPT,
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
 * Skriver MCP-konfigen til en midlertidig fil som bare brukeren kan lese, så hemmeligheter i headers og env ikke
 * står på kommandolinja (`ps`). Fila slettes når kjøringen er ferdig.
 */
export function writeMcpConfig(runId: string, servers: McpServers): string {
  const file = join(tmpdir(), `krav-mcp-${process.pid}-${runId}.json`);
  writeFileSync(file, JSON.stringify({ mcpServers: servers }), { mode: 0o600 });
  return file;
}

export interface RunnerOpts {
  env?: NodeJS.ProcessEnv;
  spawn?: typeof spawn;
  /** `false`: kodeklonene har ingen standardsti ved siden av repoet (desktop-appen) */
  siblingDirs?: boolean;
  /** Hjemmemappa der `~/.claude.json` leses (tester) */
  home?: string;
  /** Hvor lenge et spørsmål om lov venter (tester) */
  approveTimeoutMs?: number;
  /** Hvor lenge spørsmål fra AskUserQuestion venter (tester) */
  questionTimeoutMs?: number;
  /** En skisse er skrevet av `save_sketch`; git-endringene skal leses på nytt */
  onSaved?: (path: string) => void;
  /** En kjøring er ferdig; Claude kan ha skrevet filer, også under tasks/ (som ikke overvåkes uten Oppgaver og Spesifikasjoner) */
  onDone?: () => void;
}

/** Hvor mange bilder fra verktøyresultater som huskes til `save_sketch` (de nyeste) */
const MAX_IMAGES = 30;

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
  /** Bildene fra verktøyresultatene, etter `tool_use_id`, så `save_sketch` kan lagre dem */
  private readonly images = new Map<string, ToolImage[]>();
  /** Appens MCP-server: spørsmål om lov (`approve`) og `save_sketch` */
  readonly approver: Approver;

  readonly cwd: string;
  private readonly opts: RunnerOpts;

  constructor(cwd: string, opts: RunnerOpts = {}) {
    this.cwd = cwd;
    this.opts = opts;
    this.approver = new Approver({
      emit: (runId, ev) => this.emit(runId, ev),
      saveSketch: (id, path) => this.saveSketch(id, path),
      timeoutMs: opts.approveTimeoutMs,
      questionTimeoutMs: opts.questionTimeoutMs,
    });
  }

  /**
   * Skriver bildet fra verktøykallet `toolUseId` til `path` (`isSketchFile`). Uten `toolUseId` det siste bildet:
   * modellen ser ikke ID-ene til verktøykallene, så den kaller `save_sketch` rett etter kallet som ga bildet.
   */
  private async saveSketch(toolUseId: string, path: string): Promise<string> {
    const img = toolUseId ? this.images.get(toolUseId)?.[0] : [...this.images.values()].at(-1)?.at(-1);
    if (!img) {
      throw new Error(
        toolUseId
          ? `Fant ikke noe bilde fra verktøykallet ${toolUseId}. Utelat tool_use_id for å lagre det siste bildet.`
          : 'Fant ikke noe bilde å lagre. Ta skjermbildet først (f.eks. take_screenshot uten filePath), og kall save_sketch rett etter.',
      );
    }
    const ext = path.split('.').pop()?.toLowerCase() ?? '';
    if (EXT_TYPES[ext] && !EXT_TYPES[ext].includes(img.mediaType)) {
      const right = Object.keys(EXT_TYPES).find(e => EXT_TYPES[e].includes(img.mediaType));
      throw new Error(`Bildet er ${img.mediaType}${right ? `; bruk .${right}` : ''}.`);
    }
    await saveSketch(this.cwd, path, Buffer.from(img.data, 'base64'));
    this.opts.onSaved?.(path);
    return path;
  }

  private rememberImages(list: ToolImage[]) {
    for (const img of list) {
      const list = [...(this.images.get(img.toolUseId) ?? []), img];
      this.images.delete(img.toolUseId); // det nyeste bildet står sist
      this.images.set(img.toolUseId, list);
      while (this.images.size > MAX_IMAGES) this.images.delete(this.images.keys().next().value!);
    }
  }

  on(fn: (data: { runId: string; event: ClaudeEvent }) => void) {
    this.emitter.on('krav:claude', fn);
    return () => void this.emitter.off('krav:claude', fn);
  }

  private emit(runId: string, event: ClaudeEvent) {
    this.emitter.emit('krav:claude', { runId, event });
  }

  /** Stien til `claude`, eller `null` (også for terminalen, `core/pty.ts`) */
  binary(): Promise<string | null> {
    return this.find();
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
    const skill = !req.target && req.skill && CLAUDE_SKILLS.includes(req.skill) ? req.skill : null;
    let cwd = this.cwd;
    let args: string[];
    const always = allowedAlways(req.allowTools);
    let mcpFile: string;
    if (req.target) {
      // Utførekjøring: kode-repoet er arbeidsmappa, med repoets skills og CLAUDE.md
      const x = executeArgs(this.cwd, req.target, projectSkills(this.cwd).map(s => s.name));
      cwd = x.cwd;
      mcpFile = writeMcpConfig(runId, { ...readMcpServers(cwd, [], this.home()), [OWN_SERVER]: await this.approver.register(runId, { always, sketches: false }) });
      args = [
        '-p',
        '--output-format', 'stream-json',
        '--verbose',
        ...PERMISSION_ARGS,
        '--mcp-config', mcpFile,
        '--setting-sources', 'user,project,local',
        '--allowedTools', ...x.allow, ...readonlyTools(), ...always,
        ...x.add,
        '--append-system-prompt', implementPrompt(req.target, this.cwd),
        ...(req.sessionId ? ['--resume', req.sessionId] : []),
        '--disallowedTools', ...x.deny,
      ];
    } else {
      // Alle skills vi kjenner: prosjektets fra disk, de Claude meldte sist, og de vieweren husker fra før
      const known = [...projectSkills(this.cwd).map(s => s.name), ...(this.lastSkills ?? []), ...(Array.isArray(req.knownSkills) ? req.knownSkills : [])];
      const pool = skillPool(req.skills);
      const { allow, deny } = skillArgs(skill, known, pool);
      const dirs = dirArgs(req.dirs);
      // MCP-serverne brukeren har satt opp et annet sted (andre mapper, .mcp.json i kodemappene), og appens egen
      mcpFile = writeMcpConfig(runId, { ...readMcpServers(this.cwd, dirs.paths, this.home()), [OWN_SERVER]: await this.approver.register(runId, { always }) });
      args = [
        '-p',
        '--output-format', 'stream-json',
        '--verbose',
        ...PERMISSION_ARGS,
        '--mcp-config', mcpFile,
        '--allowedTools', ...CLAUDE_TOOLS, ...allow, ...readonlyTools(), ...always,
        ...dirs.add,
        '--append-system-prompt', contextPrompt(req.path, skill, pool, dirs.paths, mentionPaths(req.mentions)),
        ...(req.sessionId ? ['--resume', req.sessionId] : []),
        '--disallowedTools', ...PANEL_DENY, ...deny, ...dirs.deny,
      ];
    }
    const env = { ...(this.opts.env ?? process.env) };
    // Den korte PATH-en fra Finder: ta med mappa claude ligger i (npm-installasjoner trenger node derfra)
    env.PATH = [dirname(bin), env.PATH].filter(Boolean).join(delimiter);
    // Claude Code gir opp et MCP-kall etter omtrent 60 s uten MCP_TOOL_TIMEOUT, også spørsmålet om lov. Den må vente
    // til brukeren har fått tid til å svare (også på AskUserQuestion), selv når brukeren har satt en lavere verdi selv.
    const wait = Math.max(this.opts.approveTimeoutMs ?? APPROVE_TIMEOUT_MS, this.opts.questionTimeoutMs ?? QUESTION_TIMEOUT_MS);
    env.MCP_TOOL_TIMEOUT = String(Math.max(Number(env.MCP_TOOL_TIMEOUT) || 0, wait + 60_000));
    const cleanup = () => {
      this.approver.unregister(runId);
      rmSync(mcpFile, { force: true });
    };
    let proc: ChildProcess;
    try {
      proc = (this.opts.spawn ?? spawn)(bin, args, { cwd, env, shell: bin.endsWith('.cmd'), stdio: ['pipe', 'pipe', 'pipe'] });
    } catch (e) {
      this.approver.unregister(runId);
      rmSync(mcpFile, { force: true });
      throw e;
    }
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
        this.rememberImages(streamImages(line));
        for (const ev of line ? parseStreamLine(line) : []) {
          if (ev.kind === 'done') done = true;
          // Skillene fra en utførekjøring er kode-repoets; de skal ikke blandes med kravrepoets
          if (ev.kind === 'init' && ev.skills.length && !req.target) this.lastSkills = ev.skills;
          this.emit(runId, ev);
        }
      }
    });
    proc.stderr!.setEncoding('utf8');
    proc.stderr!.on('data', (chunk: string) => (stderr = (stderr + chunk).slice(-4000)));
    proc.on('error', e => {
      this.runs.delete(runId);
      cleanup();
      this.emit(runId, { kind: 'done', ok: false, sessionId: null, durationMs: null, turns: null, error: `Kunne ikke starte claude: ${e.message}` });
    });
    proc.on('close', code => {
      this.runs.delete(runId);
      cleanup();
      this.opts.onDone?.();
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

  private home() {
    return this.opts.home ?? homedir();
  }

  /** Brukerens svar på et spørsmål om lov fra `approve` */
  async approve(req: ClaudeApproveRequest): Promise<boolean> {
    return this.approver.answer(req);
  }

  /** Brukerens svar på spørsmålene fra AskUserQuestion */
  async answer(req: ClaudeAnswerRequest): Promise<boolean> {
    return this.approver.answerQuestion(req);
  }

  /** Spørsmålene som venter (om lov, og fra AskUserQuestion) */
  pending() {
    return this.approver.pending();
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
    this.approver.close();
  }
}
