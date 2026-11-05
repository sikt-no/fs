// Felles for teamvisningene av testrapportene (den interne testen).
// Leser markdown-fila til en enkel struktur, og skriver HTML-siden fra malen med det felles stilarket.
import { readFileSync, writeFileSync, existsSync } from 'node:fs';
import { dirname, join, relative } from 'node:path';
import { fileURLToPath } from 'node:url';

export const here = dirname(fileURLToPath(import.meta.url));

export function findRoot(start) {
  let d = start;
  while (d !== dirname(d)) {
    if (existsSync(join(d, 'krav')) && existsSync(join(d, '.claude'))) return d;
    d = dirname(d);
  }
  return null;
}

function splitRow(l) {
  return l.trim().replace(/^\|/, '').replace(/\|$/, '').split(/(?<!\\)\|/).map(c => c.trim().replace(/\\\|/g, '|'));
}

// Blokker: { t: 'p', text } | { t: 'ul' | 'ol', items: [text] } | { t: 'table', head: [..], rows: [[..]] }
function blocksOf(lines) {
  const out = [];
  let i = 0;
  while (i < lines.length) {
    const l = lines[i];
    const t = l.trim();
    if (!t) { i++; continue; }
    if (t.startsWith('```')) { // kodeblokk: hoppes over
      i++; while (i < lines.length && !lines[i].trim().startsWith('```')) i++; i++; continue;
    }
    if (t.startsWith('|')) {
      const tl = [];
      while (i < lines.length && lines[i].trim().startsWith('|')) { tl.push(lines[i]); i++; }
      const rows = tl.filter(x => !/^\|\s*:?-{3}/.test(x.trim())).map(splitRow);
      if (rows.length) out.push({ t: 'table', head: rows[0], rows: rows.slice(1) });
      continue;
    }
    const li = t.match(/^(-|\*|\d+\.)\s+(.*)$/);
    if (li) {
      const ordered = /\d/.test(li[1]);
      const items = [];
      while (i < lines.length) {
        const m = lines[i].trim().match(/^(-|\*|\d+\.)\s+(.*)$/);
        if (m && (/\d/.test(m[1]) === ordered)) { items.push(m[2]); i++; continue; }
        if (lines[i].trim() && /^\s{2,}/.test(lines[i]) && !lines[i].trim().startsWith('|') && items.length) { items[items.length - 1] += ' ' + lines[i].trim(); i++; continue; }
        break;
      }
      out.push({ t: ordered ? 'ol' : 'ul', items });
      continue;
    }
    const para = [];
    while (i < lines.length && lines[i].trim() && !/^(\||#|```|(-|\*|\d+\.)\s)/.test(lines[i].trim())) { para.push(lines[i].trim()); i++; }
    if (para.length) out.push({ t: 'p', text: para.join(' ') });
    else i++;
  }
  return out;
}

// { h1, meta: {felt: verdi}, sections: [{ level, title, blocks }] }
// Metadataene er «- **Felt**: verdi» og «- **Felt:** verdi» over den første streken (---) eller den første ##.
// Teksten mellom streken og den første ## blir en seksjon med level 0.
export function parseMd(md) {
  const lines = md.replace(/\r/g, '').split('\n');
  let h1 = '';
  const meta = {};
  let i = 0;
  for (; i < lines.length; i++) {
    const l = lines[i];
    if (/^# /.test(l) && !h1) { h1 = l.slice(2).trim(); continue; }
    if (/^---\s*$/.test(l)) { i++; break; }
    if (/^##+ /.test(l)) break;
    const m = l.match(/^- \*\*(.+?)(?::\*\*|\*\*:)\s*(.*)$/);
    if (m) meta[m[1].trim()] = m[2].trim();
  }
  const sections = [];
  let cur = { level: 0, title: '', lines: [] };
  for (; i < lines.length; i++) {
    const m = lines[i].match(/^(#{2,4}) (.*)$/);
    if (m) {
      sections.push(cur);
      cur = { level: m[1].length, title: m[2].replace(/\s{2,}\[.*\]\s*$/, '').trim(), lines: [] };
    } else cur.lines.push(lines[i]);
  }
  sections.push(cur);
  return {
    h1, meta,
    sections: sections.map(s => ({ level: s.level, title: s.title, blocks: blocksOf(s.lines) }))
      .filter(s => s.level > 0 || s.blocks.length),
  };
}

// Skriver siden: malen med stilarket, de felles hjelpefunksjonene og dataene.
export function writePage({ root, template, title, data, out }) {
  const tv = join(root, '.claude/references/teamvisning');
  const esc = s => String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;');
  const html = readFileSync(template, 'utf8')
    .replace('__TITLE__', () => esc(title))
    .replace('__STIL__', () => readFileSync(join(tv, 'stil.css'), 'utf8'))
    .replace('__FELLES__', () => readFileSync(join(tv, 'felles.js'), 'utf8'))
    .replace('__DATA__', () => JSON.stringify(data).replace(/</g, '\\u003c'));
  writeFileSync(out, html);
  return out;
}

export function rel(root, p) { return relative(root, p); }
export function read(p) { return readFileSync(p, 'utf8'); }
export function now() { return new Date().toISOString().slice(0, 16).replace('T', ' '); }
