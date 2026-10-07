import { execFile } from 'node:child_process';
import { accessSync, chmodSync, constants, rmSync, statSync } from 'node:fs';
import { createRequire } from 'node:module';
import { homedir } from 'node:os';
import { delimiter, dirname, join, resolve } from 'node:path';
import { promisify } from 'node:util';
import type { ExecuteTarget, PtyEvent, PtyInfo, PtyStartRequest } from '../shared/api.ts';
import { dirArgs, EXECUTE_BASH, EXECUTE_DENY_BASH, executeArgs, posix, projectSkills, SKILL_NAME, writeMcpConfig } from './claude.ts';
import { readMcpServers, readonlyTools } from './mcp.ts';

/**
 * Terminalen: interaktiv `claude` i en pseudo-terminal (node-pty), vist med xterm.js i Claude-panelet. Agent teams
 * kan bare startes i en interaktiv økt (ikke med `-p` eller Agent SDK), så det er her de virker i FS Kravforvaltning.
 *
 * Det som ikke står i `--allowedTools`, spør Claude Code om i terminalen, også for teammatene. Appens `approve` brukes
 * ikke. `git push` og `gh` avvises både med `--disallowedTools` og i `--settings`, i tilfelle teammates ikke arver
 * CLI-flaggene.
 */

const exec = promisify(execFile);
const isWin = process.platform === 'win32';

/** Verktøyene et agent team trenger: starte teammates, sende meldinger og dele oppgavelista */
export const TEAM_TOOLS = ['Agent', 'SendMessage', 'TaskCreate', 'TaskGet', 'TaskList', 'TaskUpdate'];
/** Skillene i `verify`-modus */
export const VERIFY_SKILLS = ['fs-verify', 'fs-verify-agent-teams'];
/** Bash som bare leser, i `verify`-modus. Resten (f.eks. `rm` når fs-verify sletter et krav) spørres om i terminalen */
export const VERIFY_BASH = ['Bash(git log:*)', 'Bash(git show:*)', 'Bash(git grep:*)', 'Bash(git status:*)', 'Bash(ls:*)'];
/** Teammates vises i samme terminal (ikke tmux eller iTerm2), og git push og gh avvises også for dem */
export const TERMINAL_SETTINGS = JSON.stringify({ teammateMode: 'in-process', permissions: { deny: EXECUTE_DENY_BASH } });
/**
 * Variablene en Claude Code-økt setter for prosessene den starter. Startes appen eller dev-serveren fra en Claude
 * Code-økt, skal terminalen ikke arve dem: da blir den en underøkt (uten lagret samtale) som kan sende meldinger til
 * økten som startet den.
 */
export const PARENT_SESSION_ENV = [
  'CLAUDECODE',
  'CLAUDE_PID',
  'CLAUDE_CODE_CHILD_SESSION',
  'CLAUDE_CODE_ENTRYPOINT',
  'CLAUDE_CODE_EXECPATH',
  'CLAUDE_CODE_MESSAGING_SOCKET',
  'CLAUDE_CODE_MESSAGING_TOKEN',
  'CLAUDE_CODE_SESSION_ATTENDED',
  'CLAUDE_CODE_SESSION_ID',
  'CLAUDE_CODE_SSE_PORT',
];
/** Hvor mye av utdataene som spilles av igjen etter en omlasting */
export const BUFFER_MAX = 200_000;

const TERMINAL_LINES = [
  'Du kjører i terminalen i FS Kravforvaltning: interaktiv Claude Code, ikke Claude-panelet. Svar kort og på norsk.',
  'Brukeren svarer på spørsmål (AskUserQuestion) og godkjenner verktøykall her i terminalen.',
  'Agent teams er slått på, og teammatene vises i samme terminal. Steng teamet før du sier at du er ferdig.',
  'mcp__kravforvaltning__save_sketch finnes ikke her: lagre skjermbilder med take_screenshot og filePath satt til stien.',
  'Du kan ikke pushe eller lage PR (git push og gh er avvist). Brukeren lager PR fra FS Kravforvaltning.',
];

/** Systemteksten i `execute`-modus: kode-repoet, spesifikasjonen og protokollen for utforing.md */
export function executeTeamPrompt(target: ExecuteTarget, repoRoot: string): string {
  const spec = /^tasks\/[^/]+\/[^/]+\/spec\/spec-[^/]+\.md$/.test(target.spec) ? target.spec : null;
  const dir = spec ? spec.replace(/\/spec\/[^/]+$/, '') : null;
  return [
    ...TERMINAL_LINES,
    `Du implementerer i repoet ${target.repo} (arbeidsmappa). Kravrepoet sikt-no/fs ligger i ${resolve(repoRoot)} (lagt til med --add-dir). Der kan du lese alt, men bare endre utforing.md i oppgavemappa.`,
    spec ? `Spesifikasjonen: ${join(resolve(repoRoot), spec)}. Les den, feature-filene den peker på og implementasjonsdetaljene (<feature>.design.md ved siden av feature-fila) før du begynner.` : '',
    'Bruk repoets egne skills og konvensjoner (CLAUDE.md).',
    'Dekker spesifikasjonen flere lag (f.eks. frontend, tester), del arbeidet i et agent team: én teammate per lag, med oppgavelista. Du (lead) koordinerer og oppdaterer utforing.md selv.',
    `Du kan bygge, teste og committe lokalt (${EXECUTE_BASH.map(b => b.slice(5, -1).replace(/:\*$/, '')).join(', ')}).`,
    dir
      ? `Protokoll: sett «Status: pågår» og «Tatt av» under «### ${target.repo}» i ${join(resolve(repoRoot), dir, 'utforing.md')} når du begynner. Når du er ferdig, skriv «Overlevering», og si fra til brukeren at steget kan settes til levert når PR-en finnes. Er du blokkert, sett «Blokkert» med grunn.`
      : '',
  ]
    .filter(Boolean)
    .join('\n');
}

/** Systemteksten i `verify`-modus: kravrepoet er arbeidsmappa, og kodemappene kan leses */
export function verifyTeamPrompt(dirs: string[]): string {
  return [
    ...TERMINAL_LINES,
    'Du verifiserer FS-krav i dette repoet mot koden, med fs-verify eller fs-verify-agent-teams.',
    dirs.length ? `Kodeklonene er ${dirs.join(', ')} (lagt til med --add-dir). Du og teammatene kan lese dem, men ikke endre dem.` : 'Ingen kodekloner er valgt; spør brukeren om stiene.',
  ].join('\n');
}

/**
 * Argumentene til interaktiv `claude` i terminalen. Prompten står først: flaggene som tar flere verdier
 * (`--allowedTools`, `--add-dir` …) ville ellers tatt den med.
 */
export function terminalArgs(
  req: PtyStartRequest,
  ctx: { repoRoot: string; mcpFile: string; kravSkills: string[] },
): { cwd: string; args: string[] } {
  const prompt = typeof req?.prompt === 'string' ? req.prompt.trim() : '';
  if (!prompt) throw new Error('Skriv en melding først');
  if (prompt.startsWith('-')) throw new Error('Meldingen kan ikke begynne med «-»');
  const common = ['--permission-mode', 'default', '--settings', TERMINAL_SETTINGS, '--mcp-config', ctx.mcpFile];
  if (req.mode === 'execute') {
    const x = executeArgs(ctx.repoRoot, req.target, ctx.kravSkills);
    return {
      cwd: x.cwd,
      args: [
        prompt,
        ...common,
        '--setting-sources', 'user,project,local',
        '--append-system-prompt', executeTeamPrompt(req.target!, ctx.repoRoot),
        ...x.add,
        '--allowedTools', ...x.allow, ...TEAM_TOOLS, ...readonlyTools(),
        '--disallowedTools', ...x.deny,
      ],
    };
  }
  if (req.mode !== 'verify') throw new Error('Ukjent modus');
  const repo = resolve(ctx.repoRoot);
  const dirs = dirArgs((Array.isArray(req.dirs) ? req.dirs : []).filter(d => typeof d === 'string' && resolve(d) !== repo));
  const others = [...new Set(ctx.kravSkills.filter(n => SKILL_NAME.test(n) && !VERIFY_SKILLS.includes(n)))].sort();
  return {
    cwd: repo,
    args: [
      prompt,
      ...common,
      '--append-system-prompt', verifyTeamPrompt(dirs.paths),
      ...dirs.add,
      '--allowedTools',
      'Read', 'Glob', 'Grep', 'TodoWrite',
      ...VERIFY_SKILLS.map(s => `Skill(${s})`),
      `Edit(/${posix(repo)}/krav/**)`,
      `Edit(/${posix(repo)}/tasks/*/*/spec/**)`,
      `Edit(/${posix(repo)}/tasks/*/*/utforing.md)`,
      ...VERIFY_BASH,
      ...TEAM_TOOLS,
      ...readonlyTools(),
      '--disallowedTools', ...EXECUTE_DENY_BASH, ...dirs.deny, ...others.map(n => `Skill(${n})`),
    ],
  };
}

/** Det node-pty gir: nok til å skrive, endre størrelse, avslutte og lytte */
export interface PtyProcess {
  onData(cb: (data: string) => void): unknown;
  onExit(cb: (e: { exitCode: number; signal?: number }) => void): unknown;
  write(data: string): void;
  resize(cols: number, rows: number): void;
  kill(signal?: string): void;
}
export type PtySpawn = (file: string, args: string[], opts: { name: string; cols: number; rows: number; cwd: string; env: Record<string, string> }) => PtyProcess;

/**
 * node-pty 1.1 kommer med ferdigbygde binærfiler for macOS og Windows (N-API, så de virker i både Node og Electron),
 * men `spawn-helper` er ikke kjørbar etter `npm install`, og da feiler alle økter med «posix_spawnp failed».
 * `scripts/node-pty-helper.mjs` retter det etter installasjonen; dette er reserven når appen kjører.
 */
function fixSpawnHelper() {
  if (isWin) return;
  try {
    const dir = dirname(createRequire(import.meta.url).resolve('node-pty/package.json')).replace('app.asar', 'app.asar.unpacked');
    for (const sub of ['build/Release', `prebuilds/${process.platform}-${process.arch}`]) {
      const f = join(dir, sub, 'spawn-helper');
      try {
        accessSync(f, constants.X_OK);
      } catch {
        try {
          chmodSync(f, statSync(f).mode | 0o111);
        } catch {
          /* finnes ikke, eller kan ikke endres (signert app) */
        }
      }
    }
  } catch {
    /* node-pty er ikke installert */
  }
}

async function nodePtySpawn(): Promise<PtySpawn> {
  fixSpawnHelper();
  const pty = await import('node-pty');
  return (file, args, opts) => (pty.spawn ?? (pty as unknown as { default: typeof pty }).default.spawn)(file, args, opts);
}

/** PATH fra innloggingsskallet: appen startet fra Finder har en kort PATH, og chrome-devtools-MCP trenger `npx` */
async function loginPath(env: NodeJS.ProcessEnv): Promise<string | null> {
  if (isWin || !env.SHELL) return null;
  try {
    return (await exec(env.SHELL, ['-ilc', 'printf %s "$PATH"'], { timeout: 5000 })).stdout.trim().split('\n').pop() || null;
  } catch {
    return null;
  }
}

interface Session {
  proc: PtyProcess;
  buffer: string;
  exited: boolean;
  code: number | null;
  mcpFile: string;
}

export interface PtyRunnerOpts {
  /** Stien til `claude` (`ClaudeRunner.binary`) */
  bin: () => Promise<string | null>;
  /** node-pty, eller en falsk i testene */
  spawn?: PtySpawn;
  env?: NodeJS.ProcessEnv;
  /** Hjemmemappa der `~/.claude.json` leses (tester) */
  home?: string;
}

/** Terminaløktene: én pseudo-terminal per økt, med utdataene i en buffer som spilles av etter en omlasting */
export class PtyRunner {
  private readonly sessions = new Map<string, Session>();
  private readonly listeners = new Set<(ev: PtyEvent) => void>();
  private seq = 0;
  private path: Promise<string | null> | null = null;
  readonly repoRoot: string;
  private readonly opts: PtyRunnerOpts;

  constructor(repoRoot: string, opts: PtyRunnerOpts) {
    this.repoRoot = repoRoot;
    this.opts = opts;
  }

  on(l: (ev: PtyEvent) => void) {
    this.listeners.add(l);
    return () => void this.listeners.delete(l);
  }

  private emit(ev: PtyEvent) {
    for (const l of this.listeners) l(ev);
  }

  async start(req: PtyStartRequest): Promise<{ id: string }> {
    const bin = await this.opts.bin();
    if (!bin) throw new Error('Fant ikke Claude Code (claude) på maskinen');
    const id = `t${Date.now().toString(36)}-${++this.seq}`;
    const cwdFor = req?.mode === 'execute' ? executeArgs(this.repoRoot, req.target, []).cwd : this.repoRoot;
    const dirs = req?.mode === 'verify' ? dirArgs(req.dirs).paths : [];
    const mcpFile = writeMcpConfig(id, readMcpServers(cwdFor, dirs, this.opts.home ?? homedir()));
    let cwd: string;
    let args: string[];
    try {
      ({ cwd, args } = terminalArgs(req, { repoRoot: this.repoRoot, mcpFile, kravSkills: projectSkills(this.repoRoot).map(s => s.name) }));
    } catch (e) {
      rmSync(mcpFile, { force: true });
      throw e;
    }
    const env = { ...(this.opts.env ?? process.env) };
    for (const k of PARENT_SESSION_ENV) delete env[k];
    this.path ??= loginPath(env);
    const shellPath = await this.path;
    env.PATH = [dirname(bin), shellPath, env.PATH].filter(Boolean).join(delimiter);
    env.CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = '1';
    env.TERM = 'xterm-256color';
    env.COLORTERM = 'truecolor';
    const spawn = this.opts.spawn ?? (await nodePtySpawn());
    const cmd = isWin && bin.toLowerCase().endsWith('.cmd') ? { file: env.ComSpec ?? 'cmd.exe', args: ['/c', bin, ...args] } : { file: bin, args };
    const cols = Math.max(20, Math.min(500, Number(req.cols) || 100));
    const rows = Math.max(5, Math.min(300, Number(req.rows) || 30));
    let proc: PtyProcess;
    try {
      proc = spawn(cmd.file, cmd.args, { name: 'xterm-256color', cols, rows, cwd, env: env as Record<string, string> });
    } catch (e) {
      rmSync(mcpFile, { force: true });
      throw e;
    }
    const s: Session = { proc, buffer: '', exited: false, code: null, mcpFile };
    this.sessions.set(id, s);
    proc.onData(data => {
      s.buffer = (s.buffer + data).slice(-BUFFER_MAX);
      this.emit({ id, kind: 'data', data });
    });
    proc.onExit(({ exitCode }) => {
      s.exited = true;
      s.code = exitCode ?? null;
      rmSync(mcpFile, { force: true });
      this.emit({ id, kind: 'exit', code: s.code });
      this.prune();
    });
    return { id };
  }

  /** Avsluttede økter huskes til det er flere enn 10, så de kan vises etter en omlasting */
  private prune() {
    const done = [...this.sessions].filter(([, s]) => s.exited);
    for (const [id] of done.slice(0, Math.max(0, done.length - 10))) this.sessions.delete(id);
  }

  write(id: string, data: string): boolean {
    const s = this.sessions.get(id);
    if (!s || s.exited || typeof data !== 'string') return false;
    s.proc.write(data);
    return true;
  }

  resize(id: string, cols: number, rows: number): boolean {
    const s = this.sessions.get(id);
    if (!s || s.exited || !(cols > 0) || !(rows > 0)) return false;
    s.proc.resize(Math.min(500, Math.floor(cols)), Math.min(300, Math.floor(rows)));
    return true;
  }

  kill(id: string): boolean {
    const s = this.sessions.get(id);
    if (!s || s.exited) return false;
    s.proc.kill();
    return true;
  }

  active(): PtyInfo[] {
    return [...this.sessions].map(([id, s]) => ({ id, exited: s.exited, code: s.code }));
  }

  buffer(id: string): string {
    return this.sessions.get(id)?.buffer ?? '';
  }

  /** Appen eller dev-serveren avsluttes: alle økter stoppes */
  close() {
    for (const s of this.sessions.values()) {
      if (!s.exited) s.proc.kill();
      rmSync(s.mcpFile, { force: true });
    }
    this.sessions.clear();
  }
}
