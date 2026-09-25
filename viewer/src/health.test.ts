// Tester aggregeringen i avviksdashbordet (health.ts) mot et lite snapshot parset med den ekte parseren.
import assert from 'node:assert/strict';
import { test } from 'node:test';
import { buildEntry } from '../server/parse.ts';
import type { Snapshot } from '../shared/model.ts';
import { agentPrompt, files, fixed, health, NO_FILTER, tree } from './health.ts';

const src = (tags: string, body = '') => `# language: no
${tags}
Egenskap: Noe
  Som administrator
  ønsker jeg noe
  slik at noe skjer

  Scenario: Et scenario
    Gitt noe
    Når noe skjer
    Så skjer noe${body}
`;

const P = 'krav/02 Opptak/10 Regelverk/01 Krav/';
const Q = 'krav/09 Organisasjon/10 Finn organisasjon/01 Søk/';
const snap: Snapshot = Object.fromEntries(
  [
    [P + 'ren_fil.feature', src('@OPT-REG-KRA-001 @must @planned')],
    [P + 'uten_status.feature', src('@OPT-REG-KRA-002 @must')],
    [P + 'Feil-navn.feature', src('@OPT-REG-KRA-003 @draft', '\n    # TODO: avklar')],
    [Q + 'uten_id.feature', src('@should @implemented')],
  ].map(([p, s]) => [p, buildEntry(p, s, 0)]),
);
snap['krav/README.md'] = { path: 'krav/README.md', kind: 'md', status: null, source: '# x', savedAt: 0 };

const all = files(snap);
const root = tree(all);

test('bare feature-filer under krav/ telles', () => {
  assert.equal(all.length, 4);
  assert.deepEqual(root.kids.map(k => k.name), ['02 Opptak', '09 Organisasjon']);
});

test('nøkkeltall og avvik per regel', () => {
  const h = health(all, root, NO_FILTER);
  assert.equal(h.kpi.nF, 4);
  assert.equal(h.kpi.clean, 1);
  assert.equal(h.kpi.nBad, 3);
  const n = (id: string) => h.ruleCounts.find(r => r.rule.id === id)!.n;
  assert.equal(n('missing-status'), 1);
  assert.equal(n('missing-id'), 1);
  assert.equal(n('not-snake-case'), 1);
  assert.equal(n('todo-comment'), 1);
  assert.equal(h.kpi.nL, h.kpi.nErr + h.kpi.nWarn);
});

test('filter på mappe, regel og alvorlighetsgrad', () => {
  assert.equal(health(all, root, { ...NO_FILTER, path: ['09 Organisasjon'] }).kpi.nF, 1);
  const r = health(all, root, { ...NO_FILTER, rule: 'missing-status' });
  assert.deepEqual(r.bad.map(b => b.f.name), ['uten_status.feature']);
  const w = health(all, root, { ...NO_FILTER, sev: 'warning' });
  assert.ok(w.bad.every(b => b.lints.every(l => l.sev === 'warning')));
});

test('statusfordelingen filtreres ikke på seg selv', () => {
  const h = health(all, root, { ...NO_FILTER, status: 'draft' });
  assert.equal(h.kpi.nF, 1);
  assert.equal(h.stDist.find(s => s.key === 'planned')!.n, 1);
  assert.equal(h.stDist.find(s => s.key === 'none')!.n, 1);
});

test('regel × mappe går ned i mappene og ender i filer', () => {
  const top = health(all, root, NO_FILTER).heat;
  assert.deepEqual(top.rows.map(r => r.label), ['02 Opptak', '09 Organisasjon']);
  assert.equal(top.total, top.rows.reduce((a, r) => a + r.sum, 0));
  const leaf = health(all, root, { ...NO_FILTER, path: ['02 Opptak', '10 Regelverk', '01 Krav'] }).heat;
  assert.ok(leaf.rows.every(r => r.file));
  assert.equal(leaf.rows.length, 3);
});

test('agent-prompten lister filer og linjer', () => {
  const flt = { ...NO_FILTER, rule: 'missing-status' };
  const p = agentPrompt(health(all, root, flt), flt);
  assert.match(p, /«Mangler status» \(missing-status\)/);
  assert.match(p, /- krav\/02 Opptak\/10 Regelverk\/01 Krav\/uten_status\.feature\n {2}- L3 \[missing-status\]/);
});

test('rettede avvik mellom to versjoner', () => {
  const l = (rule: string) => ({ rule, sev: 'error' as const, msg: '', ln: 1 });
  assert.deepEqual(fixed([l('a'), l('a'), l('b')], [l('a')]), ['a', 'b']);
  assert.deepEqual(fixed([l('a')], [l('a'), l('c')]), []);
});
