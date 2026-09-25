/**
 * Enkel markdown-parser for .md-filene i vieweren (README.md og filene i krav/), portet fra designet
 * «Gherkin Viewer» (1a, forside). Støtter overskrifter, avsnitt, lister, kodeblokker, tabeller,
 * lenker, `kode` og **fet** tekst. Resultatet rendres som JSX, så ingenting tolkes som HTML.
 */

export type Seg =
  | { kind: 'plain'; t: string }
  | { kind: 'code'; t: string }
  | { kind: 'bold'; t: string }
  | { kind: 'link'; t: string; href: string };

export type Block =
  | { type: 'h1' | 'h2' | 'h3'; text: string }
  | { type: 'p'; segs: Seg[] }
  | { type: 'ul' | 'ol'; items: Seg[][] }
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

const INLINE = /(`[^`]+`|\*\*[^*]+\*\*|\[[^\]]+\]\([^)\s]+\)|<https?:\/\/[^>\s]+>|https?:\/\/[^\s<>)]+)/;

export function inline(t: string): Seg[] {
  return t
    .split(INLINE)
    .filter(Boolean)
    .map((s): Seg => {
      if (/^`.+`$/.test(s)) return { kind: 'code', t: s.slice(1, -1) };
      if (/^\*\*.+\*\*$/.test(s)) return { kind: 'bold', t: s.slice(2, -2) };
      const md = s.match(/^\[([^\]]+)\]\(([^)\s]+)\)$/);
      if (md) return { kind: 'link', t: md[1], href: md[2] };
      const u = s.match(/^<?(https?:\/\/[^>\s]+?)>?$/);
      if (u) return { kind: 'link', t: prettyUrl(u[1]), href: u[1] };
      return { kind: 'plain', t: s };
    });
}

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
  let list: { type: 'ul' | 'ol'; items: string[] } | null = null;
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
    if (list) out.push({ type: list.type, items: list.items.map(inline) });
    list = null;
  };
  const flush = () => {
    flushPara();
    flushList();
  };
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
      out.push({ type: ('h' + Math.min(m[1].length, 3)) as 'h1' | 'h2' | 'h3', text: m[2].replace(/\s+#+\s*$/, '') });
      i++;
      continue;
    }
    const li = l.match(/^[-*+]\s+(.*)$/) ?? l.match(/^\d+[.)]\s+(.*)$/);
    if (li) {
      flushPara();
      const type = /^\d/.test(l) ? 'ol' : 'ul';
      if (list && list.type !== type) flushList();
      (list ??= { type, items: [] }).items.push(li[1]);
      i++;
      continue;
    }
    if (!l) {
      flush();
      i++;
      continue;
    }
    // Innrykket fortsettelse av et listepunkt
    if (list && /^\s/.test(L[i])) {
      list.items[list.items.length - 1] += ' ' + l;
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

const GITHUB = 'https://github.com/sikt-no/fs/blob/main/';

/**
 * Relative lenker løses mot mappen til md-filen. Finnes målet i vieweren, blir det en intern lenke
 * (`path`), ellers pekes det til filen på GitHub.
 */
export function resolveLink(href: string, from: string, has: (path: string) => boolean): { href: string; path?: string } {
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
  return { href: GITHUB + encodeURI(path) };
}
