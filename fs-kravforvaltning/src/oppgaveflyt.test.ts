import assert from 'node:assert/strict';
import { test } from 'node:test';
import type { Snapshot } from '../shared/model.ts';
import type { Lag, Task } from '../shared/tasks.ts';
import { buildEntry } from '../server/parse.ts';
import { agentPrompt, domShort, gate, kravFor, nextOf, reviewNote, treeRows } from './oppgaveflyt.ts';

const task = (o: Partial<Task> = {}): Task => ({
  dom: 'brukeradministrasjon-og-tilgangsstyring',
  slug: 'sok',
  dir: 'tasks/brukeradministrasjon-og-tilgangsstyring/sok',
  files: ['oppgave.md'],
  hasOppgave: true,
  title: 'Søk',
  issue: 41,
  initiativ: null,
  phase: 'prioritert',
  p: 0,
  prio: 'Must',
  owner: null,
  metaDom: null,
  metaSlug: null,
  kravLink: null,
  specKrav: [],
  prs: 0,
  design: false,
  spec: false,
  flow: false,
  memory: false,
  lag: [],
  reviews: [],
  log: [],
  updated: null,
  lint: [],
  ...o,
});
const lag = (k: string, o: Partial<Lag> = {}): Lag => ({ k, analysis: true, plan: [0, 3], completions: 0, verification: false, ...o });
const at = (p: number, o: Partial<Task> = {}) => task({ p, phase: (['prioritert', 'utforskning', 'utvikling', 'innføring', 'levert'] as const)[p], ...o });
const okReview = (from: string, to: string) => ({ n: 1, file: `reviews/r01-${from}-til-${to}.md`, from, to, who: '@ola', ok: true });

test('prioritert: design.md og review', () => {
  const g = gate(at(0));
  assert.deepEqual(
    g.items.map(i => [i.t, i.ok]),
    [
      ['design.md opprettet', false],
      ['Review for improvement', false],
    ],
  );
  assert.equal(g.sum, '2 av 2 mangler');
  assert.equal(nextOf(at(0)), 'fs-oppgave · opprett design.md');
  const klar = at(0, { design: true, reviews: [okReview('prioritert', 'utforskning')] });
  assert.equal(gate(klar).sum, 'klar');
  assert.equal(nextOf(klar), 'fs-oppgave · prioritert → utforskning');
});

test('utforskning: spec, analyse og plan per lag', () => {
  assert.equal(nextOf(at(1)), 'fs-specify');
  assert.equal(nextOf(at(1, { spec: true })), 'bat-analyze');
  assert.ok(gate(at(1, { spec: true })).items.some(i => i.t === 'Plan for minst ett lag' && !i.ok));
  assert.equal(nextOf(at(1, { spec: true, lag: [lag('frontend', { analysis: false, plan: null })] })), 'bat-analyze frontend');
  assert.equal(nextOf(at(1, { spec: true, lag: [lag('frontend', { plan: null })] })), 'bat-plan frontend');
  assert.equal(nextOf(at(1, { spec: true, lag: [lag('frontend')] })), 'fs-oppgave · utforskning → utvikling');
});

test('utvikling: planboksene styrer gaten, og completion-filene neste task', () => {
  const t = at(2, { lag: [lag('backend', { plan: [4, 4] }), lag('frontend', { plan: [0, 70], completions: 10 })] });
  const g = gate(t);
  assert.deepEqual(
    g.items.filter(i => i.t.includes('planbokser')).map(i => [i.t, i.ok, i.sub]),
    [
      ['backend: alle planbokser avkrysset', true, '4/4'],
      ['frontend: alle planbokser avkrysset', false, '0/70'],
    ],
  );
  assert.equal(nextOf(t), 'bat-execute frontend · task-11');
});

test('innføring: verifisering per lag og PR-lenker', () => {
  const t = at(3, { lag: [lag('backend', { plan: [4, 4], verification: true }), lag('frontend', { plan: [2, 2] })], prs: 0 });
  assert.deepEqual(
    gate(t).items.map(i => i.ok),
    [true, false, false, false],
  );
  assert.equal(nextOf(t), 'bat-verify frontend');
});

test('levert har ingen gate', () => {
  assert.equal(gate(at(4)).items.length, 0);
  assert.equal(nextOf(at(4)), 'ingen · levert');
  assert.equal(reviewNote(at(4)), 'Ligger i roadmap-arkivet.');
});

test('regelbrudd gir et eget punkt i gaten', () => {
  const t = at(0, { design: true, lint: [{ rule: 'r1', title: 'plan-krav.md ligger i oppgave-rota', hint: 'Flytt den.', file: 'plan-krav.md' }] });
  assert.ok(gate(t).items.some(i => i.t === 'Ingen regelbrudd i mappa' && !i.ok));
  assert.match(agentPrompt(t), /plan-krav\.md ligger i oppgave-rota\. Flytt den\./);
});

test('reviewNote: forbedringer foreslått, eier og ingen eier', () => {
  const t = at(1, { reviews: [{ n: 1, file: 'reviews/r01-utforskning-til-utvikling.md', from: 'utforskning', to: 'utvikling', who: '@ingrid', ok: false }] });
  assert.equal(reviewNote(t), 'ingrid foreslo forbedringer. Neste review må gjøres av en annen enn ingrid.');
  assert.equal(reviewNote(at(1, { owner: '@kari' })), 'Reviewer må være en annen enn eier (kari).');
  assert.equal(reviewNote(at(1)), 'Ingen eier satt. Reviewer må være en tredjepart.');
});

test('agentPrompt tar med oppgave, fase, neste steg og det som mangler', () => {
  const p = agentPrompt(at(0));
  assert.match(p, /^Oppgave #41 \(tasks\/brukeradministrasjon-og-tilgangsstyring\/sok\/\): Søk/);
  assert.match(p, /Fase: prioritert\. Neste steg: fs-oppgave · opprett design\.md\./);
  assert.match(p, /Mangler før utforskning: design\.md opprettet; Review for improvement\./);
});

const feature = (tag: string) => `# language: no\n@BRU-BRU-PER-001 @must @${tag}\nEgenskap: X\n  Beskrivelse\n\n  Scenario: S\n    Gitt a\n    Når b\n    Så c\n`;
const snap = (paths: string[]): Snapshot => Object.fromEntries(paths.map(p => [p, buildEntry(p, feature('in-progress'), 0)]));
const DIR = 'krav/07 Brukeradministrasjon og tilgangsstyring/12 Brukeradministrasjon/personbrukere';

const ref = (file: string, id = '', path: string | null = null) => ({ file, id, path, remove: false });

test('kravFor: kravene i spesifikasjonen vinner over lenken', () => {
  const entries = snap([`${DIR}/søke_opp_bruker.feature`, `${DIR}/se_detaljer.feature`, 'krav/02 Opptak/10 Regelverk/01 Krav/søke_opp_bruker.feature']);
  const t = task({ kravLink: DIR, specKrav: [ref('søke_opp_bruker.feature'), ref('omdøpt.feature')] });
  const k = kravFor(t, entries);
  assert.equal(k.from, 'spec');
  assert.deepEqual(
    k.items.map(i => i.path),
    [`${DIR}/søke_opp_bruker.feature`],
    'samme filnavn i et annet domene tas ikke med når lenken snevrer inn',
  );
  assert.equal(k.items[0].status, 'in-progress');
  assert.equal(k.items[0].sub, '1 scen.', 'uten Regel: vises bare scenarioer');
  assert.deepEqual(k.missing, ['omdøpt.feature']);
});

test('kravFor: Feature-ID først, så stien i lenken', () => {
  const p = 'krav/07 Brukeradministrasjon og tilgangsstyring/applikasjoner/01 It/vise_tilganger.feature';
  const flyttet = `${DIR}/flyttet.feature`;
  assert.deepEqual(
    kravFor(task({ specKrav: [ref('gammelt_navn.feature', '@BRU-BRU-PER-001', 'krav/borte/gammelt_navn.feature')] }), snap([flyttet])).items.map(i => i.path),
    [flyttet],
    'omdøpt fil finnes på Feature-ID',
  );
  assert.deepEqual(
    kravFor(task({ specKrav: [ref('vise_tilganger.feature', '@UKJENT-001', p)] }), snap([p])).items.map(i => i.path),
    [p],
  );
});

test('kravFor: faller tilbake til mappa i lenken, med tak', () => {
  const paths = Array.from({ length: 10 }, (_, i) => `${DIR}/f${i}.feature`);
  const k = kravFor(task({ kravLink: DIR }), snap([...paths, 'krav/02 Opptak/x/y/z.feature']));
  assert.equal(k.from, 'lenke');
  assert.equal(k.items.length, 8);
  assert.equal(k.more, 2);
  assert.deepEqual(kravFor(task(), snap(paths)), { items: [], more: 0, missing: [], from: null });
});

test('treeRows: slår sammen completion-filer og dypere mapper, og markerer regelbrudd', () => {
  const t = task({
    files: ['oppgave.md', 'plan-krav.md', 'flow.md', 'frontend/plan-sok.md', 'frontend/task-1-completion.md', 'frontend/task-2-completion.md', 'spec/spec-sok.md', 'spec/krav-input/local/a.feature', 'spec/krav-input/manifest.md'],
    lag: [lag('frontend', { plan: [1, 5] })],
    lint: [{ rule: 'r1', title: '', hint: '', file: 'plan-krav.md' }],
  });
  const rows = treeRows(t).map(r => `${'  '.repeat(r.depth)}${r.name}${r.note ? ' · ' + r.note : ''}${r.bad ? ' !' : ''}`);
  assert.deepEqual(rows, [
    'sok/',
    '  oppgave.md',
    '  flow.md · alfred',
    '  plan-krav.md !',
    '  spec/',
    '    spec-sok.md',
    '    krav-input/ · 2 filer',
    '  frontend/',
    '    plan-sok.md · 1/5',
    '    task-*-completion.md · 2',
  ]);
});

test('domShort forkorter lange domenenavn', () => {
  assert.equal(domShort('opptak'), 'opptak');
  assert.equal(domShort('gjennomfore-studier'), 'gjennomfore');
  assert.equal(domShort('brukeradministrasjon-og-tilgangsstyring'), 'brukeradm.');
});
