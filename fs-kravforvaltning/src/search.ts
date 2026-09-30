import Fuse, { type FuseResultMatch, type RangeTuple } from 'fuse.js';
import type { Entry, Snapshot } from '../shared/model.ts';

export const baseName = (p: string) => p.slice(p.lastIndexOf('/') + 1);
export const parentName = (p: string) => (p.includes('/') ? baseName(p.slice(0, p.lastIndexOf('/'))) : '');

/** Ett søkbart element: en fil, eller et scenario i en fil */
interface Doc {
  path: string;
  kind: 'file' | 'scen';
  name: string; // filnavn eller scenarionavn
  title: string; // Egenskap-tittel (kun fil)
  rule: string; // Regel-navn (kun scenario)
  folder: string; // kun fil, ellers matcher alle scenarioer i mappen
  tags: string;
  ln: number;
}

export interface ScenHit {
  name: string;
  ln: number;
  ranges: readonly RangeTuple[];
}

export interface FileHit {
  entry: Entry;
  score: number;
  nameRanges: readonly RangeTuple[];
  scens: ScenHit[];
}

const MAX_SCENS = 5;

function buildDocs(entries: Snapshot): Doc[] {
  const docs: Doc[] = [];
  for (const e of Object.values(entries)) {
    const m = e.model;
    const folder = parentName(e.path);
    docs.push({ path: e.path, kind: 'file', name: baseName(e.path), title: m?.title ?? '', rule: '', folder, tags: m?.tags.join(' ') ?? '', ln: 0 });
    m?.rules.forEach(r =>
      r.scenarios.forEach(s => {
        if (!s.name) return; // navnløs Bakgrunn
        docs.push({ path: e.path, kind: 'scen', name: s.name, title: '', rule: r.name ?? '', folder: '', tags: s.tags.join(' '), ln: s.ln });
      }),
    );
  }
  return docs;
}

/** Felles for søket i treet og @-omtalen i Claude-feltet, så de treffer det samme */
const FUSE_OPTS = {
  includeMatches: true,
  includeScore: true,
  ignoreLocation: true, // treff langt ut i lange scenarionavn skal ikke straffes
  threshold: 0.35,
  minMatchCharLength: 2,
};

export function makeIndex(entries: Snapshot) {
  return new Fuse(buildDocs(entries), {
    ...FUSE_OPTS,
    keys: [
      { name: 'name', weight: 3 },
      { name: 'title', weight: 2 },
      { name: 'rule', weight: 1 },
      { name: 'folder', weight: 1 },
      { name: 'tags', weight: 0.5 },
    ],
  });
}

const rangesFor = (matches: readonly FuseResultMatch[] | undefined, key: string) =>
  matches?.find(m => m.key === key)?.indices ?? [];

/** Søker og grupperer treffene per fil, sortert på beste score (lavest er best) */
export function search(index: Fuse<Doc>, entries: Snapshot, q: string): FileHit[] {
  const byPath = new Map<string, FileHit>();
  for (const r of index.search(q, { limit: 300 })) {
    const d = r.item;
    const entry = entries[d.path];
    if (!entry) continue;
    let hit = byPath.get(d.path);
    if (!hit) {
      hit = { entry, score: r.score ?? 1, nameRanges: [], scens: [] };
      byPath.set(d.path, hit);
    }
    hit.score = Math.min(hit.score, r.score ?? 1);
    if (d.kind === 'file') hit.nameRanges = rangesFor(r.matches, 'name');
    else if (hit.scens.length < MAX_SCENS) hit.scens.push({ name: d.name, ln: d.ln, ranges: rangesFor(r.matches, 'name') });
  }
  return [...byPath.values()].sort((a, b) => a.score - b.score);
}

/** En fil eller mappe under `krav/` som kan legges ved en melding til Claude */
export interface MentionItem {
  path: string;
  dir: boolean;
  name: string;
  /** Foreldremappa */
  parent: string;
  depth: number;
  /** Antall .feature-filer under mappa (0 for filer) */
  count: number;
  entry?: Entry;
}

export interface MentionHit {
  item: MentionItem;
  ranges: readonly RangeTuple[];
}

interface MentionDoc extends MentionItem {
  title: string;
  folder: string;
  tags: string;
}

/** Filene og mappene i treet, med mappene utledet fra filstiene */
export function mentionItems(entries: Snapshot): Map<string, MentionItem> {
  const items = new Map<string, MentionItem>();
  const depth = (p: string) => p.split('/').length - 1;
  const parentOf = (p: string) => p.slice(0, p.lastIndexOf('/'));
  for (const e of Object.values(entries)) {
    items.set(e.path, { path: e.path, dir: false, name: baseName(e.path), parent: parentOf(e.path), depth: depth(e.path), count: 0, entry: e });
    for (let p = parentOf(e.path); p.includes('/'); p = parentOf(p)) {
      let d = items.get(p);
      if (!d) items.set(p, (d = { path: p, dir: true, name: baseName(p), parent: parentOf(p), depth: depth(p), count: 0 }));
      if (e.kind === 'feature') d.count++;
    }
  }
  return items;
}

export function makeMentionIndex(items: Map<string, MentionItem>) {
  const docs: MentionDoc[] = [...items.values()].map(i => ({
    ...i,
    title: i.entry?.model?.title ?? '',
    folder: baseName(i.parent),
    tags: i.entry?.model?.tags.join(' ') ?? '',
  }));
  return new Fuse(docs, {
    ...FUSE_OPTS,
    keys: [
      { name: 'name', weight: 3 },
      { name: 'title', weight: 2 },
      { name: 'folder', weight: 1 },
      { name: 'tags', weight: 0.5 },
    ],
  });
}

/** Filer og mapper som treffer `q`, sortert på beste score (lavest er best), så på dybde */
export function searchMentions(index: Fuse<MentionDoc>, items: Map<string, MentionItem>, q: string): MentionHit[] {
  return index
    .search(q, { limit: 300 })
    .map(r => ({ item: items.get(r.item.path)!, score: r.score ?? 1, ranges: rangesFor(r.matches, 'name') }))
    .filter(h => h.item)
    .sort((a, b) => a.score - b.score || a.item.depth - b.item.depth)
    .map(({ item, ranges }) => ({ item, ranges }));
}
