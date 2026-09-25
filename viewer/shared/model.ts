export const STATUSES = ['draft', 'planned', 'in-progress', 'implemented'] as const;
export type Status = (typeof STATUSES)[number];

/** Statusene slik vieweren viser dem: statustaggen, pluss ingen status og delvis utkast. Rekkefølgen er legendens. */
export const DISPLAY_STATUSES = ['draft', 'planned', 'in-progress', 'implemented', 'none', 'partial'] as const;
export type DisplayStatus = (typeof DISPLAY_STATUSES)[number];

export const STATUS_LABEL: Record<DisplayStatus, string> = {
  draft: 'draft',
  planned: 'planned',
  'in-progress': 'in-progress',
  implemented: 'implemented',
  none: 'ingen status',
  partial: 'delvis utkast',
};

export function displayStatus(e: { status: Status | null; partialDraft?: boolean }): DisplayStatus {
  if (!e.status) return 'none';
  if (e.partialDraft && e.status !== 'draft') return 'partial';
  return e.status;
}

export interface Step {
  kw: string;
  text: string;
  ln: number;
  table?: string[][];
  doc?: string;
  /** Kommentarer som står mellom stegene, rett før dette steget */
  notes?: Note[];
}

/** En sammenhengende kommentarblokk. `question` er en «# ÅPNE SPØRSMÅL:»-blokk, `note` alt annet. */
export interface Note {
  kind: 'question' | 'note';
  ln: number;
  head?: string; // f.eks. «AVKLART» eller «Merk» for vanlige kommentarer
  items: { text: string; ln: number }[];
}

export interface Lint {
  rule: string; // id i shared/rules.ts
  sev: 'error' | 'warning';
  msg: string;
  ln: number;
}

export interface Examples {
  name: string;
  tags: string[];
  desc: string;
  rows: string[][];
}

export interface Scen {
  kind: string; // Bakgrunn | Scenario | Scenariomal
  name: string;
  ln: number;
  tags: string[];
  desc: string;
  notes: Note[];
  steps: Step[];
  examples: Examples[];
}

/** En Regel-blokk. `name: null` betyr en navnløs blokk (felles Bakgrunn eller scenarioer utenfor Regel). */
export interface Rule {
  name: string | null;
  tags: string[];
  desc: string;
  notes: Note[];
  ln: number;
  scenarios: Scen[];
}

export interface Question {
  text: string;
  ln: number;
}

export interface FeatureModel {
  tags: string[];
  title: string;
  desc: { lead: string; rest: string }[];
  issue: string | null;
  lang: string;
  rules: Rule[];
  notes: Note[]; // kommentarer som hører til selve egenskapen
  questions: Question[]; // alle åpne spørsmål i filen, flatt
  lint: Lint[]; // avvik fra gherkin-konvensjonene
  partialDraft: boolean; // egenskapen er ikke @draft, men har @draft-deler
  nLines: number;
  nRules: number;
  nScen: number;
}

export interface Entry {
  path: string; // relativt til repo-roten, f.eks. "krav/02 Opptak/x.feature"
  kind: 'feature' | 'md';
  status: Status | null;
  partialDraft?: boolean;
  lint?: number; // antall konvensjonsavvik
  model?: FeatureModel; // sist gyldige versjon
  error?: string;
  source?: string; // kun for .md
  savedAt: number;
}

export type Snapshot = Record<string, Entry>;

export interface UpdateEvent {
  path: string;
  entry: Entry | null; // null = filen er slettet
}

export function statusOf(tags: string[]): Status | null {
  for (const t of tags) {
    const s = t.replace(/^@/, '');
    if ((STATUSES as readonly string[]).includes(s)) return s as Status;
  }
  return null;
}

/** Sendt fra VS Code-utvidelsen: hvilken fil som er aktiv i editoren, og markert linjeområde. */
export interface FocusEvent {
  path: string;
  line: number | null; // første markerte linje (1-basert)
  to: number | null; // siste markerte linje; lik `line` når ingenting er markert
}

/** Git-status for en fil under krav/. `U` = ny fil som ikke er lagt til i git. */
export type GitCode = 'M' | 'A' | 'D' | 'U';

export interface GitChange {
  path: string; // relativt til repo-roten, som Entry.path
  code: GitCode;
  plus: number;
  minus: number;
}

/** Endringer under krav/: ucommitted mot HEAD, og committet siden branchen gikk ut fra main. */
export interface GitInfo {
  branch: string;
  commits: number; // commits siden merge-base med main
  uncommitted: GitChange[];
  committed: GitChange[];
}
