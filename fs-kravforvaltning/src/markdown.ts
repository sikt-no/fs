/**
 * Enkel markdown-parser for .md-filene i vieweren (README.md og filene i krav/), portet fra designet
 * «Gherkin Viewer» (1a, forside). Støtter overskrifter, avsnitt, lister (nestede og sjekklister),
 * sitater, skillelinjer, kodeblokker, tabeller, frontmatter, lenker, `kode`, **fet**, *kursiv* og
 * ~~gjennomstreket~~ tekst. Resultatet rendres som JSX, så ingenting tolkes som HTML.
 */

export type Seg =
  | { kind: 'plain'; t: string }
  | { kind: 'code'; t: string }
  /** Fet, kursiv og gjennomstreket tekst kan inneholde `kode` og annen formatering (`c`); `t` er teksten uten tegn */
  | { kind: 'bold' | 'em' | 'strike'; t: string; c: Seg[] }
  | { kind: 'link'; t: string; href: string };

/** `task` er satt for sjekklistepunkter (`- [ ]` / `- [x]`), `sub` er en nestet liste */
export interface ListItem {
  segs: Seg[];
  task?: boolean;
  sub?: List;
}
export interface List {
  type: 'ul' | 'ol';
  /** Første nummer i en nummerert liste, når det ikke er 1 */
  start?: number;
  items: ListItem[];
}

export type Block =
  | { type: 'h1' | 'h2' | 'h3'; text: string; segs: Seg[] }
  | { type: 'p'; segs: Seg[] }
  | List
  | { type: 'quote'; blocks: Block[] }
  | { type: 'hr' }
  | { type: 'code'; lang: string; body: string[] }
  | { type: 'card'; href: string; host: string; path: string }
  | { type: 'table'; head: Seg[][]; rows: Seg[][][] };

export interface Heading {
  key: string; // data-rule-nøkkel, `md-<blokkindeks>`
  num: string;
  name: string;
  sub: string;
}

export const prettyUrl = (h: string) => h.replace(/^https?:\/\//, '').replace(/\/$/, '');

// Innholdet i fet/kursiv/gjennomstreket er tegn uten markøren, eller et `kodespenn` (som kan inneholde markøren)
const INLINE = /(`[^`]+`|\*\*(?:[^*`]|`[^`]+`)+\*\*|~~(?:[^~`]|`[^`]+`)+~~|\*(?![\s*])(?:[^*`]|`[^`]+`)+?(?<!\s)\*|(?<!\w)_(?![\s_])(?:[^_`]|`[^`]+`)+?(?<!\s)_(?!\w)|\[[^\]]+\]\([^)\s]+\)|<https?:\/\/[^>\s]+>|https?:\/\/[^\s<>)]+)/;

/** Teksten uten markdown-tegn, til innholdsfortegnelsen */
const plain = (segs: Seg[]) => segs.map(g => g.t).join('');

const nested = (kind: 'bold' | 'em' | 'strike', inner: string): Seg => {
  const c = inline(inner);
  return { kind, t: plain(c), c };
};

export function inline(t: string): Seg[] {
  return t
    .split(INLINE)
    .filter(Boolean)
    .map((s): Seg => {
      if (/^`.+`$/.test(s)) return { kind: 'code', t: s.slice(1, -1) };
      if (/^\*\*.+\*\*$/.test(s)) return nested('bold', s.slice(2, -2));
      if (/^~~.+~~$/.test(s)) return nested('strike', s.slice(2, -2));
      if (/^(\*.+\*|_.+_)$/s.test(s)) return nested('em', s.slice(1, -1));
      const md = s.match(/^\[([^\]]+)\]\(([^)\s]+)\)$/);
      if (md) return { kind: 'link', t: md[1], href: md[2] };
      const u = s.match(/^<?(https?:\/\/[^>\s]+?)>?$/);
      if (u) return { kind: 'link', t: prettyUrl(u[1]), href: u[1] };
      return { kind: 'plain', t: s };
    });
}

interface RawItem {
  text: string;
  task?: boolean;
  sub?: RawList;
}
interface RawList {
  type: 'ul' | 'ol';
  start?: number;
  items: RawItem[];
}
const toList = (l: RawList): List => ({
  type: l.type,
  ...(l.start !== undefined && { start: l.start }),
  items: l.items.map(it => ({
    segs: inline(it.text),
    ...(it.task !== undefined && { task: it.task }),
    ...(it.sub && { sub: toList(it.sub) }),
  })),
});

const LIST_ITEM = /^(\s*)([-*+]|(\d+)[.)])\s+(.*)$/;
const indent = (l: string) => l.match(/^\s*/)![0].replace(/\t/g, '    ').length;
const isHr = (l: string) => /^(-{3,}|\*{3,}|_{3,})$/.test(l.replace(/\s+/g, ''));

const cells = (l: string) =>
  l
    .replace(/^\|/, '')
    .replace(/\|$/, '')
    .split('|')
    .map(c => inline(c.trim()));
const isSep = (l: string) => /^\|?\s*:?-{2,}:?\s*(\|\s*:?-{2,}:?\s*)*\|?$/.test(l);

export function parseMd(src: string): Block[] {
  const L = src.split('\n');
  const out: Block[] = [];
  let i = 0;
  let para: string[] | null = null;
  // Listene som er åpne, ytterst først, med innrykket til punktene i hver
  let stack: { indent: number; list: RawList }[] = [];
  const flushPara = () => {
    if (!para) return;
    const t = para.join(' ');
    const u = t.match(/^<?(https?:\/\/[^\s>]+?)>?$/);
    if (u) {
      const p = prettyUrl(u[1]);
      const k = p.indexOf('/');
      out.push({ type: 'card', href: u[1], host: k < 0 ? p : p.slice(0, k), path: k < 0 ? '' : p.slice(k) });
    } else out.push({ type: 'p', segs: inline(t) });
    para = null;
  };
  const flushList = () => {
    if (stack.length) out.push(toList(stack[0].list));
    stack = [];
  };
  const lastItem = () => {
    const items = stack[stack.length - 1].list.items;
    return items[items.length - 1];
  };
  const flush = () => {
    flushPara();
    flushList();
  };
  // Frontmatter (YAML mellom --- øverst i fila) vises som en kodeblokk
  if (L[0]?.trim() === '---') {
    const end = L.findIndex((x, k) => k > 0 && x.trim() === '---');
    if (end > 0) {
      out.push({ type: 'code', lang: 'frontmatter', body: L.slice(1, end) });
      i = end + 1;
    }
  }
  while (i < L.length) {
    const l = L[i].trim();
    let m: RegExpMatchArray | null;
    if (l.startsWith('```')) {
      flush();
      const lang = l.slice(3).trim();
      const body: string[] = [];
      i++;
      while (i < L.length && !L[i].trim().startsWith('```')) body.push(L[i++]);
      out.push({ type: 'code', lang, body });
      i++;
      continue;
    }
    if (l.startsWith('|') && i + 1 < L.length && isSep(L[i + 1].trim())) {
      flush();
      const head = cells(l);
      const rows: Seg[][][] = [];
      i += 2;
      while (i < L.length && L[i].trim().startsWith('|')) rows.push(cells(L[i++].trim()));
      out.push({ type: 'table', head, rows });
      continue;
    }
    if ((m = l.match(/^(#{1,6})\s+(.*)$/))) {
      flush();
      const segs = inline(m[2].replace(/\s+#+\s*$/, ''));
      out.push({ type: ('h' + Math.min(m[1].length, 3)) as 'h1' | 'h2' | 'h3', text: plain(segs), segs });
      i++;
      continue;
    }
    if (isHr(l)) {
      flush();
      out.push({ type: 'hr' });
      i++;
      continue;
    }
    if (l.startsWith('>')) {
      flush();
      const body: string[] = [];
      while (i < L.length && L[i].trim().startsWith('>')) body.push(L[i++].trim().replace(/^>\s?/, ''));
      out.push({ type: 'quote', blocks: parseMd(body.join('\n')) });
      continue;
    }
    const li = L[i].match(LIST_ITEM);
    if (li) {
      flushPara();
      const n = indent(li[1]);
      const type = li[3] ? 'ol' : 'ul';
      while (stack.length > 1 && stack[stack.length - 1].indent > n) stack.pop();
      if (stack.length && n > stack[stack.length - 1].indent) {
        // Nestet liste under forrige punkt
        const sub: RawList = { type, items: [] };
        lastItem().sub = sub;
        stack.push({ indent: n, list: sub });
      } else if (stack.length === 1 && stack[0].list.type !== type) flushList();
      if (!stack.length) stack = [{ indent: n, list: { type, items: [] } }];
      const top = stack[stack.length - 1].list;
      if (!top.items.length && li[3] && li[3] !== '1') top.start = Number(li[3]);
      const t = li[4].match(/^\[([ xX])\]\s+(.*)$/);
      top.items.push(t ? { text: t[2], task: t[1] !== ' ' } : { text: li[4] });
      i++;
      continue;
    }
    if (!l) {
      flushPara();
      // En blank linje avslutter ikke lista hvis den fortsetter under (løs liste)
      let k = i + 1;
      while (k < L.length && !L[k].trim()) k++;
      if (!stack.length || k >= L.length || !(LIST_ITEM.test(L[k]) || /^\s/.test(L[k]))) flushList();
      i++;
      continue;
    }
    // Innrykket fortsettelse av et listepunkt
    if (stack.length && /^\s/.test(L[i])) {
      lastItem().text += ' ' + l;
      i++;
      continue;
    }
    flushList();
    // En URL alene på en linje blir et lenkekort, også rett under et avsnitt
    if (/^<?https?:\/\/[^\s>]+>?$/.test(l)) {
      flushPara();
      para = [l];
      flushPara();
      i++;
      continue;
    }
    (para ??= []).push(l);
    i++;
  }
  flush();
  return out;
}

/** Innholdsfortegnelsen: h2 nummereres, h3 legges som undertekst. Filer uten h2 bruker h1 og h3. */
export function headings(blocks: Block[]): Heading[] {
  const top = blocks.some(b => b.type === 'h2') ? 'h2' : 'h1';
  const out: Heading[] = [];
  blocks.forEach((b, i) => {
    if (b.type === top) out.push({ key: 'md-' + i, num: String(out.length + 1), name: b.text, sub: '' });
    else if (b.type === 'h3' && out.length) {
      const last = out[out.length - 1];
      last.sub = last.sub ? last.sub + ' · ' + b.text : b.text;
    }
  });
  return out;
}

export const GITHUB = 'https://github.com/sikt-no/fs/blob/main/';

/** Den statiske versjonen på GitHub Pages */
export const PAGES = 'https://sikt-no.github.io/fs/';

/** HTML-sider i rota av repoet som publiseres ved siden av vieweren (`staticPages` i vite.config.ts) */
export const STATIC_PAGES = ['kom-i-gang.html'];

/**
 * Relative lenker løses mot mappen til md-filen. Finnes målet i vieweren, blir det en intern lenke
 * (`path`). En side i `STATIC_PAGES` åpnes fra `pageBase`, der den publiseres sammen med vieweren.
 * Ellers pekes det til filen på GitHub.
 */
export function resolveLink(
  href: string,
  from: string,
  has: (path: string) => boolean,
  pageBase = './',
): { href: string; path?: string } {
  if (/^([a-z]+:|#)/i.test(href)) return { href };
  let target: string;
  try {
    target = decodeURIComponent(href.split('#')[0]);
  } catch {
    target = href.split('#')[0];
  }
  const parts = from.split('/').slice(0, -1);
  for (const p of target.split('/')) {
    if (p === '..') parts.pop();
    else if (p && p !== '.') parts.push(p);
  }
  const path = parts.join('/');
  if (has(path)) return { href: '#/' + encodeURI(path), path };
  if (STATIC_PAGES.includes(path)) return { href: pageBase + encodeURI(path) };
  return { href: GITHUB + encodeURI(path) };
}
