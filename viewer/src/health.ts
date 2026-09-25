// Aggregering for avviksdashbordet (designet «Gherkin Viewer v2», Avvik-modus).
// Rene funksjoner over snapshotet, uten Preact, så de kan testes med node --test.
import { displayStatus, type DisplayStatus, type Lint, type Snapshot, type Status } from '../shared/model.ts';
import { RULE, RULES, type RuleDef, type Severity } from '../shared/rules.ts';

export type StatusKey = Status | 'none';
export type PrioKey = 'must' | 'should' | 'could' | 'wont' | 'none';
export const STATUS_KEYS: StatusKey[] = ['draft', 'planned', 'in-progress', 'implemented', 'none'];
export const PRIO_KEYS: PrioKey[] = ['must', 'should', 'could', 'wont', 'none'];

export interface Filter {
  path: string[] | null; // mappesegmenter under krav/
  file: string | null; // Entry.path
  rule: string | null;
  sev: 'all' | Severity;
  status: StatusKey | null;
  prio: PrioKey | null;
}
export const NO_FILTER: Filter = { path: null, file: null, rule: null, sev: 'all', status: null, prio: null };

export interface FileInfo {
  path: string;
  name: string;
  segs: string[]; // mappene under krav/
  st: StatusKey;
  icon: DisplayStatus;
  prio: PrioKey;
  lints: Lint[];
  nScen: number;
  nQ: number;
  error: boolean;
}

const collator = new Intl.Collator('nb', { numeric: true, sensitivity: 'base' });

/** Feature-filene under krav/, med det dashbordet trenger */
export function files(entries: Snapshot): FileInfo[] {
  const prios = ['must', 'should', 'could', 'wont'] as const;
  return Object.values(entries)
    .filter(e => e.kind === 'feature' && e.path.startsWith('krav/'))
    .map((e): FileInfo => {
      const parts = e.path.split('/');
      const tags = e.model?.tags ?? [];
      const prio = prios.find(p => tags.includes('@' + p)) ?? 'none';
      return {
        path: e.path,
        name: parts[parts.length - 1],
        segs: parts.slice(1, -1),
        st: e.status ?? 'none',
        icon: displayStatus(e),
        prio,
        lints: e.model?.lint ?? [],
        nScen: e.model?.nScen ?? 0,
        nQ: e.model?.questions.length ?? 0,
        error: !!e.error,
      };
    })
    .sort((a, b) => collator.compare(a.path, b.path));
}

/** Mappetre bygd fra stiene; `all` er alle filer i mappen og undermappene */
export interface Node {
  name: string;
  segs: string[];
  key: string;
  kids: Node[];
  files: FileInfo[];
  all: FileInfo[];
}
export function tree(fs: FileInfo[]): Node {
  const root: Node = { name: 'krav', segs: [], key: '', kids: [], files: [], all: [] };
  for (const f of fs) {
    let n = root;
    n.all.push(f);
    f.segs.forEach((s, i) => {
      let k = n.kids.find(x => x.name === s);
      if (!k) {
        const segs = f.segs.slice(0, i + 1);
        k = { name: s, segs, key: segs.join('/'), kids: [], files: [], all: [] };
        n.kids.push(k);
        n.kids.sort((a, b) => collator.compare(a.name, b.name));
      }
      n = k;
      n.all.push(f);
    });
    n.files.push(f);
  }
  return root;
}
export function findNode(root: Node, segs: string[] | null): Node {
  let n = root;
  for (const s of segs ?? []) {
    const k = n.kids.find(x => x.name === s);
    if (!k) return root;
    n = k;
  }
  return n;
}

const under = (f: FileInfo, segs: string[] | null) => !segs || segs.every((s, i) => f.segs[i] === s);

export interface Health {
  scope: FileInfo[]; // filene innenfor mappe-, fil-, status- og prioritetsfilteret
  kpi: { nF: number; clean: number; nL: number; nErr: number; nWarn: number; nBad: number; nQ: number; nQFiles: number; nErrors: number; nPartial: number; nScen: number };
  ruleCounts: { rule: RuleDef; n: number }[];
  stDist: { key: StatusKey; n: number }[];
  prDist: { key: PrioKey; n: number }[];
  bad: { f: FileInfo; lints: Lint[] }[]; // sortert etter antall avvik
  heat: Heat;
}
export interface Heat {
  cols: RuleDef[];
  rows: { label: string; dir: Node | null; file: FileInfo | null; cells: number[]; sum: number }[];
  foot: number[];
  total: number;
  max: number;
}

/** Alt dashbordet viser for et filter. `root` er treet over alle filer (fra `tree`). */
export function health(all: FileInfo[], root: Node, flt: Filter): Health {
  const sevOk = (l: Lint) => flt.sev === 'all' || l.sev === flt.sev;
  const inDom = (f: FileInfo) => under(f, flt.path) && (!flt.file || f.path === flt.file);
  const inSt = (f: FileInfo) => !flt.status || f.st === flt.status;
  const inPr = (f: FileInfo) => !flt.prio || f.prio === flt.prio;
  const sel = (f: FileInfo) => f.lints.filter(l => sevOk(l) && (!flt.rule || l.rule === flt.rule));

  const scope = all.filter(f => inDom(f) && inSt(f) && inPr(f));
  const allL = scope.flatMap(sel);
  const nErr = allL.filter(l => l.sev === 'error').length;
  const bad = scope
    .map(f => ({ f, lints: sel(f) }))
    .filter(x => x.lints.length)
    .sort((a, b) => b.lints.length - a.lints.length || collator.compare(a.f.name, b.f.name));
  const kpi = {
    nF: scope.length,
    clean: scope.filter(f => !f.lints.length).length,
    nL: allL.length,
    nErr,
    nWarn: allL.length - nErr,
    nBad: bad.length,
    nQ: scope.reduce((a, f) => a + f.nQ, 0),
    nQFiles: scope.filter(f => f.nQ).length,
    nErrors: scope.filter(f => f.error).length,
    nPartial: scope.filter(f => f.icon === 'partial').length,
    nScen: scope.reduce((a, f) => a + f.nScen, 0),
  };
  const ruleCounts = RULES.map(rule => ({ rule, n: scope.reduce((a, f) => a + f.lints.filter(l => l.rule === rule.id && sevOk(l)).length, 0) }));
  // Hver fordeling filtreres på de andre filtrene, ikke på seg selv
  const stDist = STATUS_KEYS.map(key => ({ key, n: all.filter(f => inDom(f) && inPr(f) && f.st === key).length }));
  const prDist = PRIO_KEYS.map(key => ({ key, n: all.filter(f => inDom(f) && inSt(f) && f.prio === key).length }));

  // Regel × mappe: undermappene i valgt mappe, eller filene når mappen ikke har undermapper
  const node = findNode(root, flt.path);
  const cols = RULES.filter(r => all.some(f => f.lints.some(l => l.rule === r.id)));
  const count = (fs: FileInfo[], r: RuleDef) =>
    fs.filter(f => inSt(f) && inPr(f)).reduce((a, f) => a + f.lints.filter(l => l.rule === r.id && sevOk(l)).length, 0);
  const src = node.kids.length
    ? node.kids.map(k => ({ label: k.name, dir: k, file: null, fs: k.all }))
    : node.files.map(f => ({ label: f.name, dir: null, file: f, fs: [f] }));
  const rows = src.map(s => {
    const cells = cols.map(r => count(s.fs, r));
    return { label: s.label, dir: s.dir, file: s.file, cells, sum: cells.reduce((a, b) => a + b, 0) };
  });
  const foot = cols.map((_, i) => rows.reduce((a, r) => a + r.cells[i], 0));
  const heat = { cols, rows, foot, total: foot.reduce((a, b) => a + b, 0), max: Math.max(1, ...rows.flatMap(r => r.cells)) };

  return { scope, kpi, ruleCounts, stDist, prDist, bad, heat };
}

/** Avvik / filer per mappe i venstrepanelet, filtrert på status og prioritet */
export function dirStat(n: Node, flt: Filter) {
  const fs = n.all.filter(f => (!flt.status || f.st === flt.status) && (!flt.prio || f.prio === flt.prio));
  return { bad: fs.filter(f => f.lints.length).length, total: fs.length };
}

/** Prompt som kan limes inn til en kodeagent for å rette avvikene som vises */
export function agentPrompt(h: Health, flt: Filter): string {
  const r = flt.rule ? RULE[flt.rule] : null;
  const file = flt.file ? h.scope.find(f => f.path === flt.file) : null;
  const scope = flt.path ? 'krav/' + flt.path.join('/') : 'krav/';
  const lines: string[] = [];
  if (r) {
    lines.push(
      `Rett avvik av typen «${r.label}» (${r.id}) ${file ? 'i ' + file.path : 'i kravfilene under ' + scope}.`,
      '',
      'Regelen: ' + r.desc,
      `Hele regelen står i krav/README.md under «${r.section}».`,
    );
  } else if (file) {
    lines.push(`Rett avvikene fra konvensjonene i ${file.path}.`, '', 'Konvensjonene står i krav/README.md.');
  } else {
    lines.push(`Rett avvikene fra konvensjonene i kravfilene under ${scope}.`, '', 'Konvensjonene står i krav/README.md.');
  }
  lines.push('', `Avvik (${h.bad.reduce((a, x) => a + x.lints.length, 0)}), fra kravvieweren:`);
  for (const { f, lints } of h.bad) {
    lines.push('- ' + f.path);
    lints.forEach(l => lines.push(`  - L${l.ln} [${l.rule}]: ${l.msg}`));
  }
  lines.push(
    '',
    'Slik skal du jobbe:',
    '- Endre bare det som trengs for å rette avvikene. Ikke endre innholdet i regler, scenarioer eller steg.',
    '- Følg konvensjonene i krav/README.md.',
    '- Hvis et avvik krever en faglig avgjørelse, for eksempel hvilken status eller ID en fil skal ha, må du ikke gjette. Legg det inn som et åpent spørsmål under # ÅPNE SPØRSMÅL: i fila, og list det opp når du er ferdig.',
    '- Skal en fil flyttes eller få nytt navn, spør først.',
    '- Kjør cd viewer && npm test til slutt, og oppsummer hva du endret per fil.',
  );
  return lines.join('\n');
}

/** Regler som har forsvunnet fra en fil mellom to versjoner, til «↻ … rettet»-varselet */
export function fixed(prev: Lint[], next: Lint[]): string[] {
  const left = new Map<string, number>();
  next.forEach(l => left.set(l.rule, (left.get(l.rule) ?? 0) + 1));
  const out: string[] = [];
  for (const l of prev) {
    const n = left.get(l.rule) ?? 0;
    if (n > 0) left.set(l.rule, n - 1);
    else out.push(l.rule);
  }
  return out;
}
