// Tavla «Oppgaver» (portet fra designet «Spesifikasjoner», runde 1): ett kort per oppgave, med spesifikasjonene i
// oppgaven, kolonnen hvert kort står i, hva som mangler, dra og slipp, og promptene til Claude. Bygget fra oppgavene
// og scopene (shared/tasks.ts), spesifikasjonene (spec/spec-*.md), tilstandsfila (utforing.md), verifiseringsrapportene
// (spec/verify-*.md) og de parsede kravene i krav/. Rene funksjoner, testet i specboard.test.ts.
import type { Entry, Scen, Snapshot, Status } from '../shared/model.ts';
import { parseSpec, type SpecDoc } from '../shared/spec.ts';
import { buildScopes, buildTasks, type RawTask, type Scope, type Task, type TasksSnapshot } from '../shared/tasks.ts';
import { kravFor, type KravRow } from './scope.ts';
import { screenshotLine } from './verifyPrompt.ts';
import { emptyStep, parseUtforing, runFor, type SpecRun, type StepState, type Utforing } from '../shared/utforing.ts';

export type Result = 'funnet' | 'ikke funnet' | 'usikker';

/** Ett scenario i gating-settet: det fs-verify sjekker. `remove`: koden skal bort (`@deprecated`). */
export interface Gate {
  t: string;
  remove: boolean;
  r: Result | null;
  bevis: string;
}

/**
 * Hvor et krav er: `planned` (ikke hentet inn av fs-specify), `ready` (`@in-progress`, eller `@deprecated` som skal
 * fjernes), `done` (levert uten åpne deler, eller slettet etter avvikling), `draft`, eller `missing` (finnes ikke i krav/).
 */
export type FeatPhase = 'planned' | 'ready' | 'done' | 'draft' | 'missing';

export interface FeatCard {
  id: string;
  file: string;
  /** Stien under krav/, når kravet finnes */
  path: string | null;
  title: string;
  status: Status | null;
  phase: FeatPhase;
  remove: boolean;
  sc: Gate[];
}

export interface Card {
  /** `<dom>/<slug>/<fil>` */
  key: string;
  dom: string;
  slug: string;
  /** `tasks/<dom>/<slug>` */
  dir: string;
  /** `spec-x.md` */
  file: string;
  /** `tasks/<dom>/<slug>/spec/spec-x.md` */
  path: string;
  text: string;
  doc: SpecDoc;
  /** Tilstanden i utforing.md (tom når spesifikasjonen ikke er sendt) */
  run: SpecRun;
  /** Hele utforing.md for oppgaven, som den skrives om fra */
  utforing: Utforing;
  feats: FeatCard[];
  mtime: number | null;
  /** Dato (og tidspunkt, `YYYY-MM-DD HH:MM`, når rapporten har det) for verifiseringsrapporten resultatene kommer fra */
  verified: string | null;
}

const ID = /^@[A-ZÆØÅ]{3}-[A-ZÆØÅ]{3}-[A-ZÆØÅ]{3}-\d{3}$/;
export const featureId = (e: Entry) => e.model?.tags.find(t => ID.test(t)) ?? null;
const base = (p: string) => p.slice(p.lastIndexOf('/') + 1);
const has = (tags: string[], t: string) => tags.includes('@' + t);

// —— Verifiseringsrapporter ——

export interface VerifyReport {
  file: string;
  date: string;
  /** Klokkeslettet (`HH:MM`) fra `- **Dato:**` eller filnavnet (`verify-<dato>-<HHMM>.md`), eller null i eldre rapporter */
  time: string | null;
  /** Spesifikasjonen rapporten gjelder (filnavnet), eller null når den ikke står */
  spec: string | null;
  rows: { id: string; sc: string; r: Result; bevis: string }[];
}

// Filnavnet: `verify-<dato>.md`, `verify-<dato>-<HHMM>.md`, og `-2`, `-3` … når fila finnes fra før
const VERIFY_FILE = /(\d{4}-\d{2}-\d{2})(?:-(\d{2})(\d{2}))?(?:-(\d{1,3}))?\.md$/;

/** `spec/verify-<dato>-<HHMM>.md` fra fs-verify: `- **Dato:**`, `- **Spec:**` og tabellen `## Scenarioer` */
export function parseVerify(text: string, file: string): VerifyReport {
  const spec = text.match(/^-\s+\*\*Spec:?\*\*:?\s*`?([^`\n]+?)`?\s*$/m)?.[1];
  const dato = text.match(/^-\s+\*\*Dato:?\*\*:?\s*(\d{4}-\d{2}-\d{2})(?:[ T](\d{2}):(\d{2}))?/m);
  const named = file.match(VERIFY_FILE);
  const date = dato?.[1] ?? named?.[1] ?? '';
  const time = dato?.[2] ? `${dato[2]}:${dato[3]}` : named?.[2] ? `${named[2]}:${named[3]}` : null;
  const rows: VerifyReport['rows'] = [];
  const sec = text.split(/^## /m).find(s => /^Scenarioer\b/.test(s)) ?? '';
  for (const l of sec.split('\n')) {
    const cells = l.split('|').slice(1, -1).map(c => c.replace(/`/g, '').trim());
    if (cells.length < 3 || !cells[0].startsWith('@')) continue;
    const r = cells[2].toLowerCase() as Result;
    if (r === 'funnet' || r === 'ikke funnet' || r === 'usikker') rows.push({ id: cells[0], sc: cells[1], r, bevis: cells[3] ?? '' });
  }
  return { file, date, time, spec: spec ? base(spec) : null, rows };
}

/** Eldste først: dato, klokkeslett (rapporter uten kommer først samme dag) og `-2`, `-3` … Filnavnet alene sorterer `-2` før den uten. */
export function verifyOrder(a: VerifyReport, b: VerifyReport): number {
  const n = (r: VerifyReport) => Number(r.file.match(VERIFY_FILE)?.[4] ?? 1);
  return a.date.localeCompare(b.date) || (a.time ?? '').localeCompare(b.time ?? '') || n(a) - n(b) || a.file.localeCompare(b.file);
}

// —— Gating-settet ——

/** Scenarioene i et krav som skal implementeres (eller fjernes), med regelen de står under. Holdes i synk med fs-verify. */
export function gating(e: Entry | undefined): { t: string; remove: boolean }[] {
  const m = e?.model;
  if (!m) return [];
  const out: { t: string; remove: boolean }[] = [];
  const st = e!.status;
  for (const r of m.rules) {
    for (const s of r.scenarios) {
      if (s.kind === 'Bakgrunn') continue;
      const tags = [...r.tags, ...s.tags];
      const off = has(tags, 'openquestion') || has(tags, 'demo');
      if (st === 'deprecated') out.push({ t: s.name, remove: true });
      else if (has(tags, 'deprecated')) {
        if (st === 'implemented' || st === 'in-progress') out.push({ t: s.name, remove: true });
      } else if (st === 'implemented') {
        if ((has(tags, 'planned') || has(tags, 'in-progress')) && !off) out.push({ t: s.name, remove: false });
      } else if (!off && !has(tags, 'draft')) out.push({ t: s.name, remove: false });
    }
  }
  return out;
}

const partTags = (e: Entry) => (e.model?.rules ?? []).flatMap(r => [r.tags, ...r.scenarios.map((s: Scen) => [...r.tags, ...s.tags])]);

/** Hvor kravet er, ut fra taggene (se `FeatPhase`) */
export function phaseOf(e: Entry | undefined, remove: boolean): FeatPhase {
  if (!e) return remove ? 'done' : 'missing';
  const parts = partTags(e);
  const any = (t: string) => parts.some(p => has(p, t));
  switch (e.status) {
    case 'in-progress':
    case 'deprecated':
      return 'ready';
    case 'planned':
      return 'planned';
    case 'implemented':
      if (any('planned')) return 'planned';
      return any('in-progress') || any('deprecated') ? 'ready' : 'done';
    default:
      return 'draft';
  }
}

/** Kan kravet plukkes inn i en spesifikasjon? Hele krav plukkes: `@planned`, levert med åpne deler, eller `@deprecated`. */
export function pickable(e: Entry): { ok: boolean; why: string } {
  const parts = partTags(e);
  const any = (t: string) => parts.some(p => has(p, t));
  switch (e.status) {
    case 'planned':
      return { ok: true, why: '' };
    case 'deprecated':
      return { ok: true, why: 'skal fjernes' };
    case 'implemented':
      return any('planned') || any('deprecated') ? { ok: true, why: 'endres' } : { ok: false, why: 'levert' };
    case 'in-progress':
      return { ok: false, why: '@in-progress' };
    case 'draft':
      return { ok: false, why: 'utkast' };
    default:
      return { ok: false, why: 'uten status' };
  }
}

// —— Kortene ——

/** Feature-ID → krav-fila */
export function idIndex(entries: Snapshot): Map<string, Entry> {
  const m = new Map<string, Entry>();
  for (const e of Object.values(entries)) {
    if (e.kind !== 'feature' || !e.path.startsWith('krav/')) continue;
    const id = featureId(e);
    if (id && !m.has(id)) m.set(id, e);
  }
  return m;
}

function lookup(entries: Snapshot, ids: Map<string, Entry>, k: { id: string; file: string; path: string | null }): Entry | undefined {
  if (k.id && ids.has(k.id)) return ids.get(k.id);
  if (k.path && entries[k.path]) return entries[k.path];
  const hits = Object.values(entries).filter(e => e.kind === 'feature' && base(e.path) === k.file);
  return hits.length === 1 ? hits[0] : undefined;
}

export function buildCards(snap: TasksSnapshot, entries: Snapshot): Card[] {
  const ids = idIndex(entries);
  const out: Card[] = [];
  for (const t of snap.tasks) {
    if (t.dom === 'mal') continue;
    const utforing = parseUtforing(t.sources['utforing.md'] ?? '');
    const reports = t.files
      .filter(f => /^spec\/verify-[^/]+\.md$/.test(f) && t.sources[f] !== undefined)
      .map(f => parseVerify(t.sources[f], f))
      .sort(verifyOrder);
    const specs = t.files.filter(f => /^spec\/spec-[^/]+\.md$/.test(f) && t.sources[f] !== undefined);
    for (const f of specs) out.push(card(t, f, utforing, reports, specs.length, entries, ids));
  }
  return out.sort((a, b) => a.dom.localeCompare(b.dom, 'nb') || a.doc.title.localeCompare(b.doc.title, 'nb'));
}

/** Kravene i spesifikasjonen, slått opp i krav/, med gating-scenarioene og resultatene fra verifiseringen */
export function featsOf(doc: SpecDoc, entries: Snapshot, ids: Map<string, Entry>, res: Map<string, { r: Result; bevis: string }> = new Map()): FeatCard[] {
  return doc.krav.map((k): FeatCard => {
    const e = lookup(entries, ids, k);
    const remove = k.remove || e?.status === 'deprecated';
    return {
      id: k.id,
      file: k.file,
      path: e?.path ?? null,
      title: e?.model?.title ?? '',
      status: e?.status ?? null,
      phase: phaseOf(e, remove),
      remove,
      sc: gating(e).map(g => {
        const v = res.get(`${k.id}|${g.t}`);
        return { ...g, r: v?.r ?? null, bevis: v?.bevis ?? '' };
      }),
    };
  });
}

function card(t: RawTask, f: string, utforing: Utforing, reports: VerifyReport[], nSpecs: number, entries: Snapshot, ids: Map<string, Entry>): Card {
  const file = base(f);
  const text = t.sources[f];
  const doc = parseSpec(text, file);
  // Siste rapport som gjelder spesifikasjonen; uten «Spec:» gjelder den bare når oppgaven har én spesifikasjon
  const report = [...reports].reverse().find(r => r.spec === file || (r.spec === null && nSpecs === 1)) ?? null;
  const res = new Map((report?.rows ?? []).map(r => [`${r.id}|${r.sc}`, r]));
  const feats = featsOf(doc, entries, ids, res);
  return {
    key: `${t.dom}/${t.slug}/${file}`,
    dom: t.dom,
    slug: t.slug,
    dir: `tasks/${t.dom}/${t.slug}`,
    file,
    path: `tasks/${t.dom}/${t.slug}/${f}`,
    text,
    doc,
    run: runFor(utforing, f),
    utforing,
    feats,
    mtime: t.mtimes?.[f] ?? null,
    verified: report ? (report.time ? `${report.date} ${report.time}` : report.date) : null,
  };
}

// —— Kolonner ——

/**
 * Kolonnene: I scope (`scope`), Kravarbeid (`kravarbeid`) og Spesifiseres (`spesifiseres`) svarer til fs-scope, fs-krav og
 * fs-specify, og utledes fra kravene. Så Klart til utvikling, repoene, Til verifisering og Verifisert.
 */
export type ColKey = 'scope' | 'kravarbeid' | 'spesifiseres' | 'klar' | 'verifisering' | 'verifisert' | `repo:${string}`;
/** Kolonnene som utledes, og som et kort ikke kan dras til */
export const DERIVED_COLS: ColKey[] = ['scope', 'kravarbeid', 'spesifiseres', 'verifisert'];

/** Hva som mangler før spesifikasjonen er klar til utvikling */
export function missing(c: Pick<Card, 'doc' | 'feats'>): string[] {
  const m: string[] = [];
  if (!c.doc.title.trim()) m.push('Mangler tittel');
  if (!c.doc.omfang.trim()) m.push('Mangler omfang');
  if (!c.feats.length) m.push('Ingen feature-fil');
  if (!c.doc.skisser.length && c.doc.ingenSkisse === null) m.push('Ingen skisse');
  const q = c.doc.sporsmal.filter(q => !q.done).length;
  if (q) m.push(`${q} åpne spørsmål`);
  const gone = c.feats.filter(f => f.phase === 'missing');
  if (gone.length) m.push(`${gone.map(f => f.file).join(', ')} finnes ikke under krav/`);
  const np = c.feats.filter(f => f.phase === 'planned' || f.phase === 'draft');
  if (np.length) m.push(`${np.map(f => f.file).join(', ')} er ikke @in-progress`);
  return m;
}

/** Alle kravene er levert (eller slettet), eller fs-verify har funnet alle scenarioene */
export function isVerified(c: Pick<Card, 'feats'>): boolean {
  if (!c.feats.length) return false;
  if (c.feats.every(f => f.phase === 'done')) return true;
  const all = c.feats.flatMap(f => f.sc);
  return all.length > 0 && all.every(s => s.r === 'funnet');
}

const stepOf = (run: SpecRun, repo: string): StepState => run.steps.find(s => s.repo === repo) ?? emptyStep(repo);

export function colOf(c: Pick<Card, 'doc' | 'feats' | 'run'>): ColKey {
  if (isVerified(c)) return 'verifisert';
  if (c.run.route.length) {
    const r = c.run.route.find(r => stepOf(c.run, r).status !== 'levert');
    return r ? `repo:${r}` : 'verifisering';
  }
  return missing(c).length ? 'spesifiseres' : 'klar';
}

/** Repoet i det gjeldende steget (første som ikke er levert), når kortet står i en repo-kolonne */
export const currentRepo = (c: Pick<Card, 'doc' | 'feats' | 'run'>) => {
  const k = colOf(c);
  return k.startsWith('repo:') ? k.slice(5) : null;
};

/**
 * Kan spesifikasjonen slippes i kolonnen? Som i designet, med ett unntak: I scope, Kravarbeid, Spesifiseres og
 * Verifisert utledes fra kravene, spesifikasjonen og verifiseringsrapporten, så de kan ikke settes for hånd.
 */
export function canDrop(c: Pick<Card, 'doc' | 'feats' | 'run'>, key: ColKey): boolean {
  const col = colOf(c);
  if (col === key || col === 'verifisert' || DERIVED_COLS.includes(key)) return false;
  if (missing(c).length) return false;
  if (key === 'verifisering') return c.run.route.length > 0 || c.doc.rute.length > 0;
  return true;
}

/**
 * Det som skjer når kortet slippes i kolonnen: ny kjøring (rute og steg), forslaget til rute (Rute i spec-dokumentet),
 * og teksten til loggen. Slippes det tilbake i Klart til utvikling, blir ruta et forslag igjen.
 */
export function moveTo(c: Pick<Card, 'doc' | 'run'>, key: ColKey, name: string): { run: SpecRun; rute: string[]; log: string } {
  const run: SpecRun = structuredClone(c.run);
  let rute = c.doc.rute;
  if (key === 'klar') {
    return { run: { ...run, route: [], steps: [] }, rute: run.route.length ? run.route : rute, log: 'tilbake til Klart til utvikling' };
  }
  if (!run.route.length) {
    run.route = [...rute];
    run.steps = [];
    rute = [];
  }
  const ensure = (r: string) => {
    let s = run.steps.find(x => x.repo === r);
    if (!s) run.steps.push((s = emptyStep(r)));
    return s;
  };
  if (key.startsWith('repo:')) {
    const r = key.slice(5);
    if (!run.route.includes(r)) run.route.push(r);
    const i = run.route.indexOf(r);
    run.route.forEach((y, j) => {
      const s = ensure(y);
      if (j < i) s.status = 'levert';
      else if (j === i) {
        if (s.status === 'levert') s.status = 'pågår';
      } else if (s.status === 'levert') s.status = 'venter';
    });
    return { run, rute, log: `flyttet til ${name}` };
  }
  run.route.forEach(y => {
    const s = ensure(y);
    s.status = 'levert';
    s.back = null;
  });
  return { run, rute, log: 'alle steg levert · til verifisering' };
}

// —— Flagg ——

export interface Flag {
  t: string;
  kind: 'err' | 'warn' | 'plain' | 'acc';
}

/** Datoen spesifikasjonen ble sendt (første «sendte til»-linje i loggen) */
export const sentDate = (run: SpecRun) => run.log.find(l => l.t.startsWith('sendte til'))?.d ?? null;

const isoDay = (ms: number) => {
  const d = new Date(ms);
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
};

/** Spesifikasjonen er endret etter at den ble sendt */
export const specChanged = (c: Pick<Card, 'run' | 'mtime'>) => {
  const sent = sentDate(c.run);
  return !!sent && !!c.mtime && c.run.route.length > 0 && isoDay(c.mtime) > sent;
};

export function flags(c: Card, dirty: boolean): Flag[] {
  const out: Flag[] = [];
  if (c.run.route.some(r => stepOf(c.run, r).blocked)) out.push({ t: 'blokkert', kind: 'err' });
  if (specChanged(c)) out.push({ t: 'spec endret', kind: 'warn' });
  if (c.doc.skisser.some(k => k.kind === 'Avvik')) out.push({ t: 'skisse-avvik', kind: 'warn' });
  const q = c.doc.sporsmal.filter(q => !q.done).length;
  if (q) out.push({ t: `${q} åpne spørsmål`, kind: 'plain' });
  if (dirty) out.push({ t: 'ikke merget', kind: 'acc' });
  return out;
}

/** Klassene til statusikonet for et steg: levert, pågår, eller venter (tom ring) */
export const stepIcon = (status: string | undefined) => (status === 'levert' ? 'st st--implemented' : status === 'pågår' ? 'st st--in-progress' : 'sp-ic sp-ic--wait');

// —— Promptene ——

/** `https://github.com/sikt-no/fs-plattform/pull/123` → `fs-plattform#123` */
export const prShort = (u: string) => {
  const m = u.match(/github\.com\/[^/]+\/([^/]+)\/pull\/(\d+)/);
  return m ? `${m[1]}#${m[2]}` : u;
};

const nGating = (c: Pick<Card, 'feats'>) => c.feats.reduce((a, f) => a + f.sc.length, 0);

/** Til en Claude Code-økt i repoet (utførekjøring i panelet, eller kopiert til en egen økt) */
export function handoffPrompt(c: Card, repo: string): string {
  const route = c.run.route.length ? c.run.route : c.doc.rute;
  const i = route.indexOf(repo);
  const prev = i > 0 ? route[i - 1] : null;
  const prevStep = prev ? stepOf(c.run, prev) : null;
  return [
    `Du jobber i ${repo}. Hent siste main i sikt-no/fs-klonen først (coord_repo i .claude/spec.local.md).`,
    '',
    `Spesifikasjon: ${c.path}`,
    ...(c.doc.omfang ? ['', 'Omfang:', c.doc.omfang] : []),
    '',
    'Krav:',
    ...c.feats.map(f => `- ${f.path ?? f.file} (${f.id})${f.remove ? ' — skal fjernes' : ''}`),
    '',
    'Skisser:',
    ...(c.doc.skisser.length ? c.doc.skisser.map(k => `- ${k.name}: ${k.url || '(uten lenke)'}`) : [`- ${c.doc.ingenSkisse !== null ? 'Ingen skisse: ' + c.doc.ingenSkisse : 'ingen'}`]),
    '',
    'Implementasjonsdetaljer: <feature>.design.md ved siden av feature-fila, når den finnes. Tekstene der (hjelpetekster, feilmeldinger og andre tekster med variasjoner) er fasiten, også når en skisse viser noe annet.',
    `Gating-scenarioer: ${nGating(c)} (det er disse fs-verify sjekker).`,
    `Steg ${i + 1} av ${route.length}: ${repo}.`,
    prevStep ? `Overlevering fra ${prev}:\n${prevStep.handoff || '(ingen)'}` : 'Første steg på ruta.',
    '',
    `Protokoll: sett Status: pågår og Tatt av under «### ${repo}» i seksjonen «## spec/${c.file}» i ${c.dir}/utforing.md. Lever med PR og Overlevering (Status: levert), eller sett Blokkert med grunn. Se tasks/README.md (Utføring).`,
  ].join('\n');
}

/** fs-verify avgrenset til spesifikasjonen, med kodemappene som er valgt */
export function verifyPrompt(c: Card, screenshots?: boolean): string {
  return [
    `Verifiser spesifikasjonen ${c.path} mot koden i kodemappene.`,
    '',
    'Krav:',
    ...c.feats.map(f => `- ${f.path ?? f.file} (${f.id})${f.remove ? ' — skal fjernes' : ''}`),
    '',
    `Skriv rapporten i ${c.dir}/spec/verify-<dato>-<HHMM>.md (tidspunktet du starter) med «- **Dato:** <dato> <HH:MM>», «- **Spec:** spec/${c.file}» og tabellen «## Scenarioer» (Feature-ID, Scenario, Resultat, Bevis).`,
    `Mangler noe, sett steget i repoet der koden mangler, tilbake til «Status: pågår» med «Tilbake: <dato>» i ${c.dir}/utforing.md.`,
    // Uten valget spør fs-verify selv
    ...(screenshots === undefined ? [] : [screenshotLine(screenshots)]),
  ].join('\n');
}

/** fs-specify (eller fs-specify-delta) på spesifikasjonen som er laget i vieweren: feature-filene og skissene står der */
export function specifyPrompt(c: Card): string {
  return [
    `Kjør ${c.doc.delta ? 'fs-specify-delta' : 'fs-specify'} på spesifikasjonen ${c.path}.`,
    'Feature-filene og skissene står i dokumentet. Ikke spør etter dem: ta med alt som er @planned eller @deprecated i hver fil, og retagg.',
    '',
    'Krav:',
    ...c.feats.map(f => `- ${f.path ?? f.file} (${f.id})`),
    '',
    'Skisser:',
    ...(c.doc.skisser.length ? c.doc.skisser.map(k => `- ${k.name}: ${k.url || '(uten lenke)'}`) : [`- ${c.doc.ingenSkisse !== null ? 'Ingen skisse: ' + c.doc.ingenSkisse : 'ingen'}`]),
  ].join('\n');
}

// —— Kolonneoppsettet ——

export interface ColConf {
  key: ColKey;
  name: string;
  hidden?: boolean;
  /** Repo-kolonne brukeren har fjernet; kommer tilbake bare hvis repoet står i en rute */
  removed?: boolean;
}

export const FIXED_COLS: ColConf[] = [
  { key: 'scope', name: 'I scope' },
  { key: 'kravarbeid', name: 'Kravarbeid' },
  { key: 'spesifiseres', name: 'Spesifiseres' },
  { key: 'klar', name: 'Klart til utvikling' },
  { key: 'verifisering', name: 'Til verifisering' },
  { key: 'verifisert', name: 'Verifisert' },
];

export const COL_WHY: Record<string, string> = {
  scope: 'Avgrenset · fs-scope',
  kravarbeid: 'Kravene skrives · fs-krav',
  spesifiseres: 'Spesifikasjonen lages · fs-specify',
  klar: 'Komplett, uten rute',
  verifisering: 'Alle steg levert',
  verifisert: 'Krav @implemented eller alt funnet',
  'repo:fs-plattform': 'Subgraph og backend',
  'repo:fs-admin': 'Frontend',
  'repo:min-kompetanse': 'Søkerside',
};

/** Repo-kolonnene på tavla når brukeren ikke har valgt noe, i den rekkefølgen en spesifikasjon typisk går gjennom dem */
export const BOARD_REPOS = ['fs-plattform', 'fs-admin', 'min-kompetanse'];

/**
 * Kolonnene i rekkefølge: I scope, Kravarbeid, Spesifiseres og Klart til utvikling, repo-kolonnene, Til verifisering og Verifisert.
 * Repoene er de lagrede (med rekkefølge, navn og skjult), pluss standardrepoene og repoene som står i en rute.
 */
export function columns(saved: ColConf[], defaults: string[], routes: string[][]): ColConf[] {
  const conf = new Map(saved.map(c => [c.key, c]));
  const used = new Set(routes.flat());
  const repos = saved.filter(c => c.key.startsWith('repo:')).map(c => c.key.slice(5));
  for (const r of [...defaults, ...used]) if (!repos.includes(r)) repos.push(r);
  const shown = repos.filter(r => !conf.get(`repo:${r}`)?.removed || used.has(r));
  const fixed = (k: ColKey) => conf.get(k) ?? FIXED_COLS.find(c => c.key === k)!;
  return [
    fixed('scope'),
    fixed('kravarbeid'),
    fixed('spesifiseres'),
    fixed('klar'),
    ...shown.map(r => ({ ...(conf.get(`repo:${r}`) ?? { key: `repo:${r}` as ColKey, name: r }), removed: undefined })),
    fixed('verifisering'),
    fixed('verifisert'),
  ];
}

// —— Oppgavekortene ——

/** Ett kort per oppgave: oppgaven, scopet, kravene og spesifikasjonene i oppgaven */
export interface TaskCard {
  /** `<dom>/<slug>` */
  key: string;
  dom: string;
  slug: string;
  /** `tasks/<dom>/<slug>` */
  dir: string;
  task: Task;
  scope: Scope | null;
  specs: Card[];
  /** Kravene oppgaven har (scope-raden, ellers spesifikasjonene, ellers krav-lenken) */
  krav: KravRow[];
  kravFrom: 'scope' | 'spec' | 'lenke' | null;
  /** Feature-ID-er og filer i scope-raden eller spesifikasjonene som ikke finnes i krav/ */
  kravMissing: string[];
  /** Krav i oppgaven (unntatt `@wont`) som ikke står i noen spesifikasjon, og som ikke er levert */
  unspecced: KravRow[];
}

const inSpec = (k: KravRow, specs: Card[]) => specs.some(s => s.feats.some(f => (k.id && f.id === k.id) || (k.path && f.path === k.path)));

/** Oppgavekortene: alle oppgavemappene (unntatt mal/), med spesifikasjonene fra `specCards` */
export function buildTaskCards(tasks: Task[], scopes: Scope[], specCards: Card[], entries: Snapshot): TaskCard[] {
  const ids = idIndex(entries);
  return tasks
    .filter(t => t.dom !== 'mal')
    .map(t => {
      const scope = (t.scope && scopes.find(s => s.slug === t.scope && s.dom === t.dom)) || null;
      const specs = specCards.filter(c => c.dom === t.dom && c.slug === t.slug);
      const kl = kravFor(t, scope, entries, ids);
      return {
        key: `${t.dom}/${t.slug}`,
        dom: t.dom,
        slug: t.slug,
        dir: t.dir,
        task: t,
        scope,
        specs,
        krav: kl.items,
        kravFrom: kl.from,
        kravMissing: kl.missing,
        unspecced: kl.items.filter(k => !k.wont && !inSpec(k, specs) && phaseOf(k.entry, false) !== 'done'),
      };
    })
    .sort((a, b) => a.dom.localeCompare(b.dom, 'nb') || a.task.title.localeCompare(b.task.title, 'nb'));
}

/** Kolonnen for kravene uten spesifikasjon: skjeletter → I scope, utkast → Kravarbeid, ellers Spesifiseres */
export function kravCol(krav: KravRow[]): ColKey {
  if (krav.every(k => k.skeleton)) return 'scope';
  if (krav.some(k => k.skeleton || k.status === 'draft' || k.status === null)) return 'kravarbeid';
  return 'spesifiseres';
}

/** Spesifikasjonene i oppgaven som ikke er verifisert */
export const activeSpecs = (t: Pick<TaskCard, 'specs'>) => t.specs.filter(s => colOf(s) !== 'verifisert');

/**
 * Kolonnen for oppgaven (tasks/README.md, *Tavla*). Med spesifikasjoner som ikke er verifisert: den tidligste av dem,
 * i kolonnerekkefølgen `order`. Ellers fra kravene som ikke har spesifikasjon (`kravCol`). Verifisert: alle
 * spesifikasjonene er verifisert, og alle kravene (unntatt `@wont`) har spesifikasjon eller er levert.
 */
export function taskColOf(t: Pick<TaskCard, 'specs' | 'unspecced' | 'krav'>, order: ColKey[] = columns([], BOARD_REPOS, []).map(c => c.key)): ColKey {
  const active = activeSpecs(t);
  if (active.length) {
    const rank = (k: ColKey) => {
      const i = order.indexOf(k);
      return i < 0 ? order.indexOf('verifisering') - 0.5 : i;
    };
    return active.map(colOf).sort((a, b) => rank(a) - rank(b))[0];
  }
  if (t.unspecced.length) return kravCol(t.unspecced);
  if (t.specs.length || t.krav.some(k => !k.wont)) return 'verifisert';
  return 'scope';
}

/** Spesifikasjonen et oppgavekort flyttes med når det dras: bare når oppgaven har én aktiv spesifikasjon */
export const dragSpec = (t: Pick<TaskCard, 'specs'>) => {
  const a = activeSpecs(t);
  return a.length === 1 ? a[0] : null;
};

/** Hva som mangler før oppgaven kommer videre fra en kolonne som utledes fra kravene (uten aktiv spesifikasjon) */
export function taskMissing(t: TaskCard): string[] {
  if (activeSpecs(t).length) return [];
  const col = taskColOf(t);
  if (col === 'scope') return t.krav.length ? ['Kravene er skjeletter · fs-krav'] : ['Ingen krav ennå · fs-scope'];
  if (col === 'kravarbeid') {
    const n = t.unspecced.filter(k => k.skeleton || k.status === 'draft' || k.status === null).length;
    return [`${n} krav er ikke @planned · fs-krav`];
  }
  if (col === 'spesifiseres') return ['Mangler spesifikasjon · fs-specify'];
  return [];
}

/** Flaggene på oppgavekortet, i tillegg til flaggene på spesifikasjonene */
export function taskFlags(t: TaskCard, dirty: boolean): Flag[] {
  const out: Flag[] = [];
  const active = activeSpecs(t);
  if (active.length && t.unspecced.length) out.push({ t: `${t.unspecced.length} krav uten spesifikasjon`, kind: 'warn' });
  if (t.scope) {
    const row = new Set(t.krav.map(k => k.id ?? k.path));
    const outside = t.specs.flatMap(s => s.feats).filter(f => !row.has(f.id) && !row.has(f.path) && !f.remove);
    if (outside.length) out.push({ t: `${outside.length} krav utenfor scope-raden`, kind: 'warn' });
    const other = t.krav.filter(k => k.scope && k.scope !== t.scope!.slug);
    if (other.length) out.push({ t: `${other.length} krav i et annet scope`, kind: 'warn' });
    const notTagged = t.krav.filter(k => k.entry && !k.scope);
    if (notTagged.length) out.push({ t: `${notTagged.length} krav uten @scope`, kind: 'plain' });
    if (t.scope.mtime && t.specs.some(s => s.run.route.length && sentDate(s.run) && isoDay(t.scope!.mtime!) > sentDate(s.run)!))
      out.push({ t: 'scope endret', kind: 'warn' });
  }
  if (t.kravMissing.length) out.push({ t: `${t.kravMissing.length} krav finnes ikke`, kind: 'err' });
  if (t.task.lint.length) out.push({ t: `${t.task.lint.length} avvik i mappa`, kind: 'err' });
  if (dirty) out.push({ t: 'ikke merget', kind: 'acc' });
  return out;
}

/** Alt tavla bygges av: scopene, oppgavene, spesifikasjonene og oppgavekortene */
export function buildBoard(snap: TasksSnapshot, entries: Snapshot, extraSpecs: Card[] = []) {
  const scopes = buildScopes(snap);
  const tasks = buildTasks(snap, scopes);
  const specs = [...buildCards(snap, entries), ...extraSpecs];
  return { scopes, tasks, specs, cards: buildTaskCards(tasks, scopes, specs, entries) };
}

const kravList = (ks: KravRow[]) => ks.map(k => `- ${k.path ?? k.file}${k.id ? ` (${k.id})` : ''}${k.status ? ` · @${k.status}` : ' · finnes ikke'}${k.skeleton && k.path ? ' · skjelett' : ''}`);

/** fs-krav på kravene i oppgaven som ikke er @planned ennå (I scope og Kravarbeid) */
export function kravPrompt(t: TaskCard): string {
  const open = t.unspecced.filter(k => k.skeleton || k.status === 'draft' || k.status === null);
  return [
    `Skriv og valider kravene i oppgaven ${t.dir}/ (${t.task.title}) med fs-krav.`,
    ...(t.scope ? [`Oppgaven hører til scopet ${t.scope.path}: les mål, ikke-mål og kilder der, og ikke spør om det på nytt.`] : []),
    '',
    'Krav som ikke er @planned:',
    ...kravList(open.length ? open : t.unspecced),
  ].join('\n');
}

/** fs-specify på oppgaven, med kravene og skissene fra scope-raden */
export function taskSpecifyPrompt(t: TaskCard): string {
  const sketches = t.scope ? t.scope.rows.filter(r => r.task === t.slug).flatMap(r => r.sketches) : [];
  return [
    `Kjør fs-specify for oppgaven ${t.dir}/ (${t.task.title}).`,
    ...(t.scope ? [`Oppgaven hører til scopet ${t.scope.path}. Bruk kravene og skisselenkene i scope-raden som utgangspunkt.`] : []),
    '',
    'Krav uten spesifikasjon:',
    ...kravList(t.unspecced),
    ...(sketches.length ? ['', 'Skisser fra scope-raden:', ...sketches.map(k => `- ${k.name}: ${k.url}`)] : []),
  ].join('\n');
}
