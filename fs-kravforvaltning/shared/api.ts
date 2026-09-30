import type { GitInfo, Snapshot } from './model.ts';
import type { TasksSnapshot } from './tasks.ts';

/** Det rendereren trenger ved oppstart, uansett transport */
export interface Boot {
  entries: Snapshot;
  git: GitInfo | null;
  tasks: TasksSnapshot | null;
  /** Redigering og PR er tilgjengelig (dev-server og desktop-app, ikke statisk bygg) */
  editable: boolean;
}

export interface SaveRequest {
  path: string; // relativt til repo-roten, under krav/
  text: string;
}

export interface PublishRequest {
  paths: string[]; // krav-filene som skal med i PR-en
  branch: string; // uten prefiks; blir `krav/<branch>`
  title: string;
  body: string;
}

export interface PublishResult {
  url: string;
  branch: string;
}

/** Innlogging mot GitHub (device flow) */
export type AuthStatus =
  | { state: 'ok'; login: string | null; source: 'gh' | 'device' }
  | { state: 'none'; canLogin: boolean } // canLogin: false når ingen OAuth-klient er satt opp
  | { state: 'pending'; userCode: string; verificationUri: string; expiresAt: number };

/** Den lokale Claude Code-installasjonen */
export interface ClaudeStatus {
  available: boolean;
  path: string | null;
  version: string | null;
}

export interface ClaudeRunRequest {
  prompt: string;
  /** Fortsett en samtale (`--resume`) */
  sessionId?: string | null;
  /** Fila brukeren ser på, som kontekst */
  path?: string | null;
  /** Filer og mapper under krav/ som brukeren har lagt ved meldingen med @ */
  mentions?: string[];
  /** Skillen som er valgt (en av `CLAUDE_SKILLS`); alle andre avvises */
  skill?: string | null;
  /** Skillene som er lov der brukeren er; Claude kan bruke dem fritt, også når en skill er valgt */
  skills?: string[];
  /** Kodemappene Claude kan lese (fs-admin, fs-plattform), som absolutte stier; de får `--add-dir`, men kan ikke endres */
  dirs?: string[];
  /** Start meldingen med `/<skill>`, så skillen lastes (første melding etter at den er valgt) */
  invoke?: boolean;
  /** Andre skills vieweren kjenner fra før (plugins, personlige), så de kan avvises også før Claude har meldt dem */
  knownSkills?: string[];
}

/** Skillene som kan velges i Claude-panelet; høyst én om gangen */
export const CLAUDE_SKILLS = ['fs-krav', 'fs-specify', 'fs-specify-delta', 'fs-verify'];

/** Kodeklonene fs-verify leter i, med standardstien backenden fant */
export const CODE_DIRS = ['fs-admin', 'fs-plattform'] as const;
export interface CodeDir {
  name: (typeof CODE_DIRS)[number];
  /** Stien: overstyringen, ellers `KRAV_FS_ADMIN` / `KRAV_FS_PLATTFORM`, ellers mappa ved siden av repoet (ikke i desktop-appen). Tom: ingen valgt */
  path: string;
  /** Finnes mappa */
  exists: boolean;
}

export interface ClaudeSkill {
  name: string;
  description: string;
}

export interface ClaudeSkills {
  /** Skillene i repoets `.claude/skills/` */
  project: ClaudeSkill[];
  /** Andre skills Claude har (plugins, personlige); `null` til Claude har kjørt én gang */
  other: string[] | null;
}

/** Hendelsene fra en Claude-kjøring, forenklet fra `--output-format stream-json` */
export type ClaudeEvent =
  | { kind: 'init'; sessionId: string; model: string | null; skills: string[] }
  | { kind: 'text'; text: string }
  | { kind: 'tool'; id: string; name: string; summary: string }
  | { kind: 'toolResult'; id: string; isError: boolean }
  /** Hvor mye av konteksten siste svar brukte: input, cache-lesing og cache-skriving, pluss svaret */
  | { kind: 'usage'; tokens: number }
  | {
      kind: 'done';
      ok: boolean;
      sessionId: string | null;
      durationMs: number | null;
      turns: number | null;
      error: string | null;
      /** Størrelsen på kontekstvinduet til modellen (fra `modelUsage`), når Claude oppgir den */
      contextWindow?: number | null;
    };

/** Kallene rendereren kan gjøre mot backenden. Navnene brukes både som `POST /__krav/api/<navn>` og som IPC-kall. */
export interface Api {
  /** Teksten i en krav-fil, slik den er på disk */
  read(path: string): Promise<string>;
  save(req: SaveRequest): Promise<void>;
  publish(req: PublishRequest): Promise<PublishResult>;
  authStatus(): Promise<AuthStatus>;
  authStart(): Promise<AuthStatus>;
  authPoll(): Promise<AuthStatus>;
  authLogout(): Promise<AuthStatus>;
  /** Desktop-appen: hent siste main fra GitHub til den lokale klonen */
  pull(): Promise<void>;
  /** Desktop-appen: finnes det en nyere main på GitHub? `null` når det ikke kan sjekkes (dev-serveren, uten nett) */
  mainStatus(): Promise<{ behind: boolean } | null>;
  claudeStatus(): Promise<ClaudeStatus>;
  /** Starter en kjøring; hendelsene kommer som `krav:claude` med `{ runId, event }` */
  claudeRun(req: ClaudeRunRequest): Promise<{ runId: string }>;
  claudeCancel(runId: string): Promise<void>;
  /** Kjøringene som pågår */
  claudeActive(): Promise<string[]>;
  claudeSkills(): Promise<ClaudeSkills>;
  /** Standardstiene til kodeklonene; `paths` sjekker om overstyrte stier finnes */
  claudeDirs(paths?: Record<string, string>): Promise<CodeDir[]>;
  /** Desktop-appen: velg en mappe med mappevelgeren; `null` når brukeren avbryter */
  pickDir(): Promise<string | null>;
}
export type ApiMethod = keyof Api;
export const API_METHODS: ApiMethod[] = ['read', 'save', 'publish', 'authStatus', 'authStart', 'authPoll', 'authLogout', 'pull', 'mainStatus', 'claudeStatus', 'claudeRun', 'claudeCancel', 'claudeActive', 'claudeSkills', 'claudeDirs', 'pickDir'];
