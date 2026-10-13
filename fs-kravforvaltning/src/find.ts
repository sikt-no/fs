import Fuse from 'fuse.js';
import type { FeatureModel, Note } from '../shared/model.ts';
import { FUSE_OPTS } from './search.ts';

/**
 * Søket i fila (Cmd/Ctrl+F), etter designet «Gherkin Viewer v2». Hvert ord i søket treffer som delstreng,
 * og ord på minst 4 tegn treffer også ord i fila som Fuse.js finner, med de samme innstillingene som søket
 * i treet (`FUSE_OPTS`). `'ord` gir bare eksakt treff. Fuse søker i ordene i fila, ikke i hele tekster,
 * så et treff er et helt ord som kan markeres, ikke spredte tegn.
 */

export type Range = [number, number];

const WORD = /[\p{L}\p{N}-]+/gu;
const lower = (t: string) => t.toLocaleLowerCase('nb');

/** Fuse-indeks over de unike ordene i tekstene */
export function wordIndex(texts: Iterable<string>) {
  const words = new Set<string>();
  for (const t of texts) for (const m of lower(t).matchAll(WORD)) words.add(m[0]);
  return new Fuse([...words], FUSE_OPTS);
}
export type WordIndex = ReturnType<typeof wordIndex>;

/**
 * Søket gjort om til ett ledd per ord (den eksakte delstrengen og ordene i fila som Fuse treffer),
 * og hele søket som frase når det har flere ord
 */
export interface Matcher {
  terms: { sub: string; words: Set<string> }[];
  phrase: string | null;
}

export function matcher(index: WordIndex, q: string): Matcher {
  const m: Matcher = { terms: [], phrase: null };
  const toks = q.trim().split(/\s+/).filter(Boolean);
  for (const tok of toks) {
    const exact = tok.startsWith("'");
    const t = lower(tok.replace(/^'/, ''));
    if (t.length < 2) continue;
    const words = new Set<string>();
    // Korte ord gir for mye støy i Fuse, og søkes bare eksakt
    if (!exact && t.length >= 4) for (const r of index.search(t)) words.add(r.item);
    m.terms.push({ sub: t, words });
  }
  if (toks.length > 1) m.phrase = lower(toks.map(t => t.replace(/^'/, '')).join(' '));
  return m;
}

/**
 * Områdene i `text` som treffer søket (`q`, eller en ferdig `Matcher`), sortert og slått sammen.
 * Med flere ord må alle treffe i teksten, og står hele søket i teksten, blir frasen ett treff
 * (en innlimt scenariotittel gir da ett treff på tittelen).
 */
export function findRanges(text: string, q: string | Matcher): Range[] {
  const m = typeof q === 'string' ? matcher(wordIndex([text]), q) : q;
  if (!m.terms.length) return [];
  const low = lower(text);
  const out: Range[] = [];
  const subs = (t: string) => {
    const rs: Range[] = [];
    for (let i = low.indexOf(t); i >= 0; i = low.indexOf(t, i + t.length)) rs.push([i, i + t.length]);
    return rs;
  };
  for (const { sub, words } of m.terms) {
    const rs = subs(sub);
    if (words.size) for (const w of low.matchAll(WORD)) if (words.has(w[0])) rs.push([w.index!, w.index! + w[0].length]);
    if (!rs.length) return [];
    out.push(...rs);
  }
  if (m.phrase) out.push(...subs(m.phrase));
  out.sort((x, y) => x[0] - y[0]);
  const merged: Range[] = [];
  for (const r of out) {
    const last = merged[merged.length - 1];
    // Med flere ord blir ord som bare har mellomrom mellom seg, ett treff
    const join = last && (r[0] <= last[1] || (m.phrase !== null && !text.slice(last[1], r[0]).trim()));
    if (join) last[1] = Math.max(last[1], r[1]);
    else merged.push([r[0], r[1]]);
  }
  return merged;
}

/** Blokka et treff hører til i trefflista: egenskapen, en regel eller et scenario */
export interface FindCtx {
  g: string;
  kind: string;
  label: string;
  /** Nøkkelordet eller merket foran utdraget: steget, `?` for åpne spørsmål, `#` for kommentarer, `|` for tabeller */
  kw: string;
}

export interface Hit {
  id: number;
  /** Tekstbiten i visningen treffet står i, se `findHits` */
  loc: string;
  /** Scenarioet treffet står i (`scenKey`), eller `null` */
  scen: string | null;
  ctx: FindCtx;
  text: string;
  s: number;
  e: number;
}

export interface FindResult {
  hits: Hit[];
  /** Treffene per tekstbit, med id-en som markeringen og «neste treff» bruker */
  at: Map<string, { s: number; e: number; id: number }[]>;
  /** Antall treff per scenario (`scenKey`) */
  perScen: Map<string, number>;
}

/**
 * Alle treff i fila, i samme rekkefølge som `FeatureView` tegner tekstene, så «neste treff» går nedover.
 * Tekstbitene (`loc`): `title`, `desc:i`, notater `<p>n<i>` (spørsmål `<p>n<i>:<j>`), `r<ri>` og `r<ri>:desc`,
 * `s<key>` og `s<key>:desc`, steg `t<key>-<ti>`, tabellceller `t<key>-<ti>:<rad>:<kol>`, docstring
 * `t<key>-<ti>:doc`, og eksempler `x<key>-<ei>:<rad>:<kol>` og `x<key>-<ei>:name`. `key` er `scenKey`.
 */
export function findHits(model: FeatureModel, q: string): FindResult {
  const res: FindResult = { hits: [], at: new Map(), perScen: new Map() };
  if (!q.trim()) return res;
  const { pieces, index } = prepared(model);
  const m = matcher(index, q);
  for (const { loc, text, ctx, scen } of pieces) {
    const rs = findRanges(text, m);
    if (!rs.length) continue;
    res.at.set(
      loc,
      rs.map(([s, e]) => {
        const id = res.hits.length;
        res.hits.push({ id, loc, scen, ctx, text, s, e });
        return { s, e, id };
      }),
    );
    if (scen) res.perScen.set(scen, (res.perScen.get(scen) ?? 0) + rs.length);
  }
  return res;
}

interface Piece {
  loc: string;
  text: string;
  ctx: FindCtx;
  scen: string | null;
}

/** Tekstbitene og ordindeksen for en versjon av fila; bygges én gang, ikke for hvert tastetrykk */
const cache = new WeakMap<FeatureModel, { pieces: Piece[]; index: WordIndex }>();
function prepared(model: FeatureModel) {
  let c = cache.get(model);
  if (!c) {
    const pieces = collect(model);
    cache.set(model, (c = { pieces, index: wordIndex(pieces.map(p => p.text)) }));
  }
  return c;
}

/** Tekstene i fila i samme rekkefølge som `FeatureView` tegner dem */
function collect(model: FeatureModel): Piece[] {
  const pieces: Piece[] = [];
  let scen: string | null = null;
  const add = (loc: string, text: string, ctx: FindCtx) => void (text && pieces.push({ loc, text, ctx, scen }));
  const notes = (p: string, list: Note[], ctx: FindCtx) =>
    list.forEach((n, ni) => {
      if (n.kind === 'question') n.items.forEach((it, ii) => add(`${p}n${ni}:${ii}`, it.text, { ...ctx, kw: '?' }));
      else if (n.items.length) add(`${p}n${ni}`, n.items.map(i => i.text).join('\n'), { ...ctx, kw: '#' });
    });
  const table = (p: string, rows: string[][], ctx: FindCtx) =>
    rows.forEach((r, ri) => r.forEach((c, ci) => add(`${p}:${ri}:${ci}`, c, { ...ctx, kw: '|' })));

  const head: FindCtx = { g: 'head', kind: 'EGENSKAP', label: model.title, kw: '' };
  add('title', model.title, head);
  model.desc.forEach((d, i) => add(`desc:${i}`, d.rest, head));
  notes('f', model.notes, head);
  let num = 0;
  model.rules.forEach((r, ri) => {
    if (r.name !== null) num++;
    const rctx: FindCtx = { g: 'r' + ri, kind: 'REGEL ' + num, label: r.name ?? '', kw: '' };
    if (r.name !== null) add('r' + ri, r.name, rctx);
    if (r.desc) add(`r${ri}:desc`, r.desc, rctx);
    notes('r' + ri, r.notes, rctx);
    r.scenarios.forEach((s, si) => {
      const key = `${ri}-${si}`;
      scen = key;
      const label = s.name || (s.kind === 'Bakgrunn' ? 'Felles forutsetninger' : '');
      const sctx: FindCtx = { g: 's' + key, kind: (r.name !== null ? `REGEL ${num} · ` : '') + s.kind.toUpperCase(), label, kw: '' };
      add('s' + key, label, sctx);
      if (s.desc) add(`s${key}:desc`, s.desc, sctx);
      notes('s' + key, s.notes, sctx);
      s.steps.forEach((st, ti) => {
        const p = `t${key}-${ti}`;
        notes(p, st.notes ?? [], sctx);
        add(p, st.text, { ...sctx, kw: st.kw });
        if (st.table) table(p, st.table, sctx);
        if (st.doc !== undefined) add(`${p}:doc`, st.doc, { ...sctx, kw: '"""' });
      });
      s.examples.forEach((ex, ei) => {
        const p = `x${key}-${ei}`;
        if (ex.name) add(`${p}:name`, ex.name, { ...sctx, kw: 'Eks' });
        table(p, ex.rows, sctx);
      });
      scen = null;
    });
  });
  return pieces;
}

/** En bit av en tekst: `mark` er om biten treffer `re` (parameter eller referanse), `hit` er treff-id-en */
export interface Seg {
  t: string;
  mark: boolean;
  hit?: number;
}

/** Deler `text` i biter etter `re` (med én fangegruppe) og etter treffene i `ranges` */
export function segments(text: string, re: RegExp | null, ranges: readonly { s: number; e: number; id: number }[] = []): Seg[] {
  // `split` med én fangegruppe gir vekselvis vanlig tekst og treff på `re`
  const base = (re ? text.split(re).map((t, i) => ({ t, mark: i % 2 === 1 })) : [{ t: text, mark: false }]).filter(b => b.t);
  if (!ranges.length) return base;
  const out: Seg[] = [];
  let off = 0;
  for (const b of base) {
    const s0 = off;
    const s1 = off + b.t.length;
    let p = s0;
    for (const r of ranges) {
      if (r.e <= s0 || r.s >= s1) continue;
      const x = Math.max(r.s, s0);
      const y = Math.min(r.e, s1);
      if (x > p) out.push({ t: text.slice(p, x), mark: b.mark });
      out.push({ t: text.slice(x, y), mark: b.mark, hit: r.id });
      p = y;
    }
    if (p < s1) out.push({ t: text.slice(p, s1), mark: b.mark });
    off = s1;
  }
  return out;
}

export interface FindGroup {
  g: string;
  kind: string;
  label: string;
  items: { id: number; kw: string; pre: string; hl: string; post: string }[];
}

/** Trefflista i innholdspanelet: treffene gruppert per blokk, med utdrag rundt hvert treff */
export function findGroups(hits: Hit[]): FindGroup[] {
  const groups: FindGroup[] = [];
  for (const h of hits) {
    let g = groups[groups.length - 1];
    if (!g || g.g !== h.ctx.g) groups.push((g = { g: h.ctx.g, kind: h.ctx.kind, label: h.ctx.label, items: [] }));
    const a0 = Math.max(0, h.s - 26);
    g.items.push({
      id: h.id,
      kw: h.ctx.kw,
      pre: (a0 > 0 ? '…' : '') + h.text.slice(a0, h.s),
      hl: h.text.slice(h.s, h.e),
      post: h.text.slice(h.e, h.e + 36) + (h.e + 36 < h.text.length ? '…' : ''),
    });
  }
  return groups;
}

/** «12 treff i 4 blokker · 3 av 12», eller «Ingen treff» */
export function findSummary(total: number, groups: number, cur: number) {
  if (!total) return 'Ingen treff';
  return `${total} treff i ${groups} ${groups === 1 ? 'blokk' : 'blokker'} · ${cur + 1} av ${total}`;
}
