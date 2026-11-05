#!/usr/bin/env node
// Lager teamvisningen av testcasene for den interne akseptansetesten: én HTML-fil ved siden av fila.
// Bruk (fra rota av repoet): node .claude/skills/fs-testcaser-intern/references/teamvisning/bygg.mjs akseptansetest/<slug>/testcaser-intern.md
// Skriver testcaser-intern.html og skriver stien til stdout.
// Stilarket er felles for alle teamvisningene: .claude/references/teamvisning/stil.css. Siden står i mal.html.
import { dirname, join, resolve, relative } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const arg = process.argv[2];
if (!arg) { console.error('Bruk: node bygg.mjs <testcaser-intern.md>'); process.exit(1); }
const src = resolve(arg);
const { findRoot, parseMd, writePage, read, now } = await import(join(here, '../../../../references/teamvisning/felles.mjs'));
const root = findRoot(dirname(src)) ?? findRoot(here);
const doc = parseMd(read(src));
const leveranse = doc.h1.replace(/^Intern akseptansetest\s*[–-]\s*/i, '') || doc.h1;
const out = writePage({
  root,
  template: join(here, 'mal.html'),
  title: 'Intern test · ' + leveranse,
  data: { ...doc, kilde: relative(root, src), laget: now() },
  out: src.replace(/\.md$/, '') + '.html',
});
console.log(relative(process.cwd(), out));
