#!/usr/bin/env node
// Lager teamvisningen av en verify-rapport: én HTML-fil ved siden av rapporten, med designet i mal.html.
// Bruk (fra rota av repoet): node .claude/skills/fs-verify/references/teamvisning/bygg.mjs <verify-rapport.md>
// Skriver <rapport>.html (samme navn, .html i stedet for .md) og skriver stien til stdout.
// Designet ligger bare i mal.html. Endre det der, ikke i de genererte filene.
import { readFileSync, writeFileSync, readdirSync, existsSync } from 'node:fs';
import { dirname, join, relative, resolve, basename } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const arg = process.argv[2];
if (!arg) { console.error('Bruk: node bygg.mjs <verify-rapport.md>'); process.exit(1); }
const reportPath = resolve(arg);
const md = readFileSync(reportPath, 'utf8');

function findRoot(start) {
  let d = start;
  while (d !== dirname(d)) { if (existsSync(join(d, 'krav')) && existsSync(join(d, '.claude'))) return d; d = dirname(d); }
  return null;
}
const root = findRoot(dirname(reportPath)) ?? findRoot(here) ?? process.cwd();

const REPO_INFO = {
  P: ['fs-plattform', 'API, tjenestene og databasen'],
  A: ['fs-admin', 'Det saksbehandlere og forvaltere ser og gjør'],
  M: ['min-kompetanse', 'Det søkeren ser og gjør'],
};

// —— Seksjoner og tabeller ——
const lines = md.split('\n');
function section(name) {
  const i = lines.findIndex(l => l.trim() === '## ' + name);
  if (i < 0) return null;
  let j = i + 1;
  while (j < lines.length && !/^## /.test(lines[j])) j++;
  return lines.slice(i + 1, j);
}
function sub(sec, name) {
  if (!sec) return null;
  const i = sec.findIndex(l => l.trim() === '### ' + name);
  if (i < 0) return null;
  let j = i + 1;
  while (j < sec.length && !/^###? /.test(sec[j])) j++;
  return sec.slice(i + 1, j);
}
function rows(sec) {
  if (!sec) return [];
  const out = [];
  for (const l of sec) {
    if (!l.startsWith('|') || /^\|\s*-{3}/.test(l)) continue;
    const cells = l.trim().replace(/^\|/, '').replace(/\|$/, '').split(/(?<!\\)\|/).map(c => c.trim().replace(/\\\|/g, '|'));
    out.push(cells);
  }
  return out.slice(1); // uten overskriftsraden
}
const stripId = s => s.replace(/[`@]/g, '').trim();

// —— Metadata ——
const meta = {};
for (const l of lines) {
  if (/^## /.test(l)) break;
  const m = l.match(/^- \*\*(.+?):\*\* (.*)$/);
  if (m) meta[m[1]] = m[2];
}
const abbr = {};
for (const l of lines) {
  const m = l.match(/^- `([^`]+)` = `([^`]+)`/);
  if (m) abbr[m[1]] = m[2];
}
let repos = [];
if (meta['Repoer']) {
  for (const m of meta['Repoer'].matchAll(/\b([PAM]) = ([a-z-]+)/g)) {
    repos.push({ k: m[1], name: m[2], what: (REPO_INFO[m[1]] || [m[2], ''])[1] });
  }
}

// —— Tittel ——
const h1 = (md.match(/^# Verifisering: (.+)$/m) || [])[1]?.trim() ?? basename(reportPath, '.md');
function scopeTitle(slug) {
  const tasks = join(root, 'tasks');
  if (!existsSync(tasks)) return null;
  for (const d of readdirSync(tasks, { withFileTypes: true })) {
    if (!d.isDirectory()) continue;
    const f = join(tasks, d.name, slug, 'scope.md');
    if (existsSync(f)) {
      const t = (readFileSync(f, 'utf8').match(/^# Scope: (.+)$/m) || [])[1];
      if (t) return t.trim();
    }
  }
  return null;
}
const slug = (h1.match(/^@?scope-(.+)$/) || (meta['Krav'] || '').match(/@scope-([a-z0-9-]+)/) || [])[1];
const title = (slug && scopeTitle(slug)) || h1.replace(/^@?scope-/, '');

// —— Kravfilene: tittel, regler og linjer ——
const featureFiles = [];
(function walk(d) {
  if (!existsSync(d)) return;
  for (const e of readdirSync(d, { withFileTypes: true })) {
    const p = join(d, e.name);
    if (e.isDirectory()) walk(p); else if (e.name.endsWith('.feature')) featureFiles.push(p);
  }
})(join(root, 'krav'));
const featureCache = {};
function feature(id) {
  if (id in featureCache) return featureCache[id];
  const re = new RegExp('(^|\\s)@' + id.replace(/[-]/g, '\\-') + '(\\s|$)');
  for (const f of featureFiles) {
    const text = readFileSync(f, 'utf8');
    const ls = text.split('\n');
    const ei = ls.findIndex(l => /^\s*Egenskap:/.test(l));
    if (ei < 0 || !ls.slice(0, ei).some(l => re.test(l))) continue;
    const scen = {};
    let rule = null;
    ls.forEach((l, n) => {
      let m = l.match(/^\s*Regel:\s*(.*)$/); if (m) rule = m[1].trim();
      m = l.match(/^\s*Scenario(?:mal)?:\s*(.*)$/); if (m) scen[m[1].trim()] = { line: n + 1, rule };
    });
    return (featureCache[id] = { file: basename(f), path: relative(root, f), title: ls[ei].replace(/^\s*Egenskap:\s*/, '').trim(), scen });
  }
  return (featureCache[id] = null);
}

// —— Scenarioer ——
const scenarioer = rows(section('Scenarioer')).map(r => {
  const id = stripId(r[0]);
  let bevis = r[3] || '';
  let marks = null;
  const m = bevis.match(/^((?:[PAM] [✓✗~–](?: · )?)+)\s*—\s*(.*)$/);
  if (m) {
    marks = {};
    for (const x of m[1].matchAll(/([PAM]) ([✓✗~–])/g)) marks[x[1]] = x[2];
    bevis = m[2];
  }
  const f = feature(id);
  const sc = f?.scen[r[1]];
  return { id, title: r[1], result: (r[2] || '').toLowerCase(), marks, bevis, line: sc?.line ?? null, rule: sc?.rule ?? null };
});
if (!repos.length) {
  const seen = new Set();
  scenarioer.forEach(s => s.marks && Object.keys(s.marks).forEach(k => seen.add(k)));
  repos = ['P', 'A', 'M'].filter(k => seen.has(k)).map(k => ({ k, name: REPO_INFO[k][0], what: REPO_INFO[k][1] }));
}

// —— Krav ——
const oversikt = {};
for (const r of rows(section('Oversikt per krav'))) oversikt[stripId(r[0])] = { title: r[1], gjenstar: r[r.length - 1] };
const ids = [...new Set(scenarioer.map(s => s.id))];
const krav = ids.map(id => {
  const list = scenarioer.filter(s => s.id === id);
  const f = feature(id);
  return {
    id,
    title: oversikt[id]?.title || f?.title || id,
    file: f?.file || '',
    gjenstar: oversikt[id]?.gjenstar || '',
    found: list.filter(s => s.result === 'funnet').length,
    total: list.length,
  };
});

// —— Tilgang, regler, andre funn, MR-er ——
const tSec = section('Tilgang og datakonsistens');
const tRows = sub(tSec, 'Avvik') || sub(tSec, 'Stemmer') ? [...rows(sub(tSec, 'Avvik')), ...rows(sub(tSec, 'Stemmer'))] : rows(tSec);
const tilgang = tRows.map(r => ({ id: stripId(r[0]), sjekk: r[1], rolle: r[2], resultat: (r[3] || '').toLowerCase(), bevis: r[4] || '' }));
const regler = rows(section('Regler uten scenario')).map(r => ({ id: stripId(r[0]), regel: r[1], type: r[2], bevis: r[3], forslag: r[4] || '' }));
const andre = rows(section('Andre funn')).map(r => ({ type: r[0], id: r[1], gjelder: r[2], hva: r[3] || '' }));
const mr = rows(section('Åpne MR-er og brancher')).map(r => ({ repo: r[0], mr: r[1], status: r[2], krav: r[3], funnet: r[4], merknad: r[5] || '' }));

const data = {
  title, meta, abbr, repos, krav, scenarioer, tilgang, regler, andre, mr,
  rapport: relative(root, reportPath),
  laget: new Date().toISOString().slice(0, 16).replace('T', ' '),
};

const tpl = readFileSync(join(here, 'mal.html'), 'utf8');
const esc = s => s.replace(/&/g, '&amp;').replace(/</g, '&lt;');
const html = tpl
  .replace('__TITLE__', () => esc('Verifisering · ' + title))
  .replace('__DATA__', () => JSON.stringify(data).replace(/</g, '\\u003c'));
const out = reportPath.replace(/\.md$/, '') + '.html';
writeFileSync(out, html);
const missingFeatures = ids.filter(id => !feature(id));
if (missingFeatures.length) console.error('Fant ikke kravfila for: ' + missingFeatures.join(', ') + ' (regler og linjer mangler i visningen)');
console.log(relative(process.cwd(), out));
