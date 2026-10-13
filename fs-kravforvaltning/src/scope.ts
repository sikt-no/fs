// Koblingen mellom kravene, scopene og oppgavene: kravene et scope har (fra taggen @scope-<slug>), kravene hver
// oppgave har (fra tabellen «Oppgaver» i scope-fila), og avvikene mellom dem. Uten scope: kravene i spesifikasjonene,
// eller mappa «Krav (Gherkin)» i oppgave.md lenker til. Rene funksjoner, testet i scope.test.ts.
import { displayStatus, scopeOf, type DisplayStatus, type Entry, type Snapshot, type Status } from '../shared/model.ts';
import type { Scope, Task } from '../shared/tasks.ts';
import { featureId, idIndex } from './specboard.ts';

export interface KravRow {
  /** Stien under krav/, eller null når kravet ikke finnes */
  path: string | null;
  /** Feature-ID med @, når den er kjent */
  id: string | null;
  file: string;
  title: string;
  status: Status | null;
  display: DisplayStatus;
  /** Kravet har ingen scenarioer ennå (et skjelett fra fs-scope), eller finnes ikke */
  skeleton: boolean;
  /** `@wont` på egenskapen (eller MoSCoW «Won't» i scope-raden): teller ikke for kolonnen */
  wont: boolean;
  /** Slugen i `@scope-<slug>` på egenskapen eller en del, når den finnes */
  scope: string | null;
  /** «3 regler · 12 scen.» */
  sub: string;
  entry?: Entry;
}

const base = (p: string) => p.slice(p.lastIndexOf('/') + 1);

/** Alle scope-taggene i kravet: på egenskapen og på delene */
export function scopesIn(e: Entry): string[] {
  const m = e.model;
  if (!m) return [];
  const out = new Set<string>();
  const add = (tags: string[]) => {
    const s = scopeOf(tags);
    if (s) out.add(s);
  };
  add(m.tags);
  for (const r of m.rules) {
    add(r.tags);
    for (const sc of r.scenarios) add(sc.tags);
  }
  return [...out];
}

export function kravRow(e: Entry | undefined, ref: { id?: string | null; file?: string; moscow?: string | null } = {}): KravRow {
  const m = e?.model;
  const scopes = e ? scopesIn(e) : [];
  return {
    path: e?.path ?? null,
    id: (e && featureId(e)) ?? ref.id ?? null,
    file: e ? base(e.path) : (ref.file ?? ref.id ?? ''),
    title: m?.title ?? '',
    status: e?.status ?? null,
    display: e ? displayStatus(e) : 'none',
    skeleton: !m || m.skeleton,
    wont: !!m?.tags.includes('@wont') || /^won/i.test(ref.moscow ?? ''),
    scope: scopes[0] ?? null,
    sub: m ? `${m.nRules ? m.nRules + ' regler · ' : ''}${m.nScen} scen.` : '',
    entry: e,
  };
}

const kravEntries = (entries: Snapshot) => Object.values(entries).filter(e => e.kind === 'feature' && e.path.startsWith('krav/'));

/** Kravene i én rad av scope-tabellen, slått opp på Feature-ID og så på stien i lenken */
function rowKrav(row: Scope['rows'][number], entries: Snapshot, ids: Map<string, Entry>): KravRow[] {
  const out: KravRow[] = [];
  const seen = new Set<string>();
  for (const id of row.ids) {
    const e = ids.get(id);
    if (e && seen.has(e.path)) continue;
    if (e) seen.add(e.path);
    out.push(kravRow(e, { id, moscow: row.moscow }));
  }
  for (const p of row.paths) {
    if (seen.has(p)) continue;
    const e = entries[p];
    // En lenke uten Feature-ID som ikke finnes, vises med filnavnet
    if (!e && row.ids.length) continue;
    seen.add(p);
    out.push(kravRow(e, { file: base(p), moscow: row.moscow }));
  }
  return out;
}

export interface ScopeLinks {
  scope: Scope;
  /** Kravene per oppgave i tabellen; `null` er «ikke tildelt» */
  byTask: Map<string | null, KravRow[]>;
  /** Krav med `@scope-<slug>` som ikke står i tabellen */
  notInTable: KravRow[];
  /** Krav i tabellen uten taggen, eller med et annet scope */
  untagged: KravRow[];
  /** Feature-ID-er og lenker i tabellen som ikke finnes i krav/ */
  missing: string[];
}

export function scopeLinks(scope: Scope, entries: Snapshot, ids = idIndex(entries)): ScopeLinks {
  const byTask = new Map<string | null, KravRow[]>();
  const listed = new Set<string>();
  const missing: string[] = [];
  for (const row of scope.rows) {
    const ks = rowKrav(row, entries, ids);
    byTask.set(row.task, [...(byTask.get(row.task) ?? []), ...ks]);
    for (const k of ks) {
      if (k.path) listed.add(k.path);
      else missing.push(k.id ?? k.file);
    }
  }
  const all = [...byTask.values()].flat();
  return {
    scope,
    byTask,
    notInTable: kravEntries(entries)
      .filter(e => !listed.has(e.path) && scopesIn(e).includes(scope.slug))
      .map(e => kravRow(e))
      .sort((a, b) => (a.path ?? '').localeCompare(b.path ?? '')),
    untagged: all.filter(k => k.entry && !scopesIn(k.entry).includes(scope.slug)),
    missing,
  };
}

export interface KravLinks {
  items: KravRow[];
  /** Krav i spesifikasjonene eller scope-raden som ikke finnes i krav/ lenger (omdøpt eller slettet) */
  missing: string[];
  /** Hvor koblingen kom fra: scope-raden, `## Krav` i spesifikasjonene, eller mappa i «Krav (Gherkin)» */
  from: 'scope' | 'spec' | 'lenke' | null;
}

/**
 * Kravene oppgaven gjelder: scope-raden når oppgaven har scope, ellers kravene i spesifikasjonene, ellers
 * feature-filene under mappa i «Krav (Gherkin)». Hele lista, uten tak; detaljpanelet viser de første.
 */
export function kravFor(t: Task, scope: Scope | null, entries: Snapshot, ids = idIndex(entries)): KravLinks {
  if (scope && t.scope === scope.slug) {
    const items: KravRow[] = [];
    const missing: string[] = [];
    for (const row of scope.rows.filter(r => r.task === t.slug))
      for (const k of rowKrav(row, entries, ids)) {
        if (!k.path) missing.push(k.id ?? k.file);
        else if (!items.some(o => o.path === k.path)) items.push(k);
      }
    return { items, missing, from: 'scope' };
  }
  const feats = kravEntries(entries);
  const inLink = (p: string) => !!t.kravLink && (p === t.kravLink || p.startsWith(t.kravLink + '/'));
  // 1. Kravene under «## Krav» i spesifikasjonene, slått opp på Feature-ID, så stien i lenken, så filnavnet
  const found = new Set<string>();
  const missing = new Set<string>();
  for (const k of t.specKrav) {
    const full = (k.id && ids.get(k.id)?.path) || (k.path && entries[k.path] ? k.path : null);
    if (full) {
      found.add(full);
      continue;
    }
    const hits = feats.filter(e => base(e.path) === k.file).map(e => e.path);
    if (!hits.length) missing.add(k.file);
    const narrowed = hits.filter(inLink);
    (narrowed.length ? narrowed : hits).forEach(h => found.add(h));
  }
  let paths = [...found];
  let from: KravLinks['from'] = paths.length ? 'spec' : null;
  // 2. Ellers: feature-filene under mappa oppgave.md lenker til. En lenke til et helt domene (`krav/07 …/`) sier ikke
  // hvilke krav oppgaven har, og brukes ikke
  if (!paths.length && t.kravLink && t.kravLink.split('/').length >= 3) {
    paths = feats.map(e => e.path).filter(inLink);
    if (paths.length) from = 'lenke';
  }
  return { items: paths.sort().map(p => kravRow(entries[p])), missing: [...missing].sort(), from };
}
