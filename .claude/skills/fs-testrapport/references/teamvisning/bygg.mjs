#!/usr/bin/env node
// Lager teamvisningen av testrapporten (intern og ekstern akseptansetest): én HTML-fil ved siden av fila.
// Bruk (fra rota av repoet): node .claude/skills/fs-testrapport/references/teamvisning/bygg.mjs akseptansetest/<slug>/testrapport-<nivå>-<dato>.md
// Skriver testrapport-<nivå>-<dato>.html og skriver stien til stdout.
// Stilarket er felles for alle teamvisningene: .claude/references/teamvisning/stil.css. Siden står i mal.html.
import { dirname, join, resolve, relative } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const arg = process.argv[2];
if (!arg) { console.error('Bruk: node bygg.mjs <testrapport-….md>'); process.exit(1); }
const src = resolve(arg);
const { findRoot, parseMd, writePage, read, now } = await import(join(here, '../../../../references/teamvisning/felles.mjs'));
const root = findRoot(dirname(src)) ?? findRoot(here);
const doc = parseMd(read(src));
const leveranse = doc.h1.replace(/^Testrapport\s*[–-]\s*[^–-]+[–-]\s*/i, '') || doc.h1;
const out = writePage({
  root,
  template: join(here, 'mal.html'),
  title: 'Testrapport · ' + leveranse,
  data: { ...doc, kilde: relative(root, src), laget: now() },
  out: src.replace(/\.md$/, '') + '.html',
});
console.log(relative(process.cwd(), out));
