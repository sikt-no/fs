// Tester flytene og avhengighetstreet (flows.ts) mot et lite snapshot parset med den ekte parseren.
import assert from 'node:assert/strict';
import { test } from 'node:test';
import { buildEntry } from '../server/parse.ts';
import type { Snapshot } from '../shared/model.ts';
import {
  buildFlows,
  chainBehind,
  chainLow,
  countTo,
  depsOf,
  flatKrav,
  flowTree,
  flowWarnings,
  flyterHash,
  parseFlyterHash,
  phaseStatus,
  progress,
} from './flows.ts';

const krav = (tags: string, title: string, body: string) => `# language: no
${tags}
Egenskap: ${title}
  Beskrivelse.
${body}
`;

const A = 'krav/02 Opptak/10 Regelverk/01 Krav/';
const B = 'krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/';
const F = 'krav/_Flyter/10 Opptaksløpet/';

const files: Record<string, string> = {
  [A + 'a.feature']: krav('@OPT-REG-KRA-001 @must @implemented', 'A', `
  Regel: Første regel i A
    Scenario: S
      Gitt noe
      Når noe
      Så noe

  @depends-on-OPT-BEH-BEH-001
  Regel: Andre regel i A
    Scenario: T
      Gitt noe
      Når noe
      Så noe
`),
  [A + 'c.feature']: krav('@OPT-REG-KRA-002 @must @draft', 'C', `
  Regel: Regel i C
`),
  [B + 'b.feature']: krav('@OPT-BEH-BEH-001 @must @planned @depends-on-OPT-REG-KRA-002', 'B', `
  Regel: Regel i B
`),
  [B + 'd.feature']: krav('@OPT-BEH-BEH-002 @must @deprecated', 'D', `
  Regel: Regel i D
`),
  [F + 'saken.feature']: krav('@FLY-OPT-SAK-001 @must @planned @e2e', 'Saken', `
  # Kjent brudd: STEK-1, saken kommer ikke fram.

  @depends-on-OPT-REG-KRA-001
  # «Første regel i A»
  Regel: Fase en
    Scenario: Overleveringen
      Gitt at noe er gjort
      Når noe skjer
      Så er noe laget

  @depends-on-OPT-REG-KRA-001 @depends-on-OPT-BEH-BEH-002 @ref-OPT-BEH-BEH-001
  Regel: Fase to
    Scenario: Videre
      Gitt noe
      Når noe
      Så noe

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Kravet for fasen er ikke skrevet.
  Regel: Fase tre
`),
  [F + 'opptaksløpet.feature']: krav('@FLY-OPT-OPT-001 @must @draft @e2e', 'Opptaksløpet', `
  @depends-on-FLY-OPT-SAK-001
  Regel: Saken fordeles

  @depends-on-OPT-XXX-XXX-999
  Regel: Fase med brutt referanse
`),
};
const snap: Snapshot = Object.fromEntries(Object.entries(files).map(([p, s]) => [p, buildEntry(p, s, 0)]));
const ix = buildFlows(snap);
const sak = ix.byId.get('FLY-OPT-SAK-001')!;
const opt = ix.byId.get('FLY-OPT-OPT-001')!;

test('flytene leses fra krav/_Flyter, med prosess, oversikt og fasene', () => {
  assert.deepEqual(ix.flows.map(f => f.id), ['FLY-OPT-OPT-001', 'FLY-OPT-SAK-001']);
  assert.equal(opt.overview, true);
  assert.equal(sak.overview, false);
  assert.equal(sak.process, '10 Opptaksløpet');
  assert.deepEqual(sak.phases.map(p => p.title), ['Fase en', 'Fase to', 'Fase tre']);
  assert.deepEqual(sak.knownBreaks, ['STEK-1, saken kommer ikke fram.']);
  assert.deepEqual(sak.phases[1].refs, ['OPT-BEH-BEH-001']);
  assert.deepEqual(sak.phases[2].questions, ['Kravet for fasen er ikke skrevet.']);
  assert.deepEqual(sak.phases[0].handovers[0].steps.map(s => s.kw), ['Gitt', 'Når', 'Så']);
});

test('kommentaren under taggen blir regelen fasen bygger på, bare når regelen finnes i kravet', () => {
  assert.equal(sak.phases[0].links[0].note, 'Første regel i A');
  assert.equal(sak.phases[1].links[0].note, null);
});

test('fremdriften: en fase er levert når alle kravene er implemented, og en fase uten krav teller i totalen', () => {
  assert.equal(phaseStatus(ix, sak.phases[0]), 'implemented');
  assert.equal(phaseStatus(ix, sak.phases[1]), 'deprecated');
  assert.equal(phaseStatus(ix, sak.phases[2]), 'missing');
  assert.deepEqual(progress(ix, sak), { delivered: 1, total: 3, missing: 1 });
  assert.equal(phaseStatus(ix, opt.phases[0]), 'planned'); // flyten fasen peker på
  assert.equal(phaseStatus(ix, opt.phases[1]), 'broken');
});

test('hele kravet følger alle @depends-on-, bare regelen følger regelen kommentaren peker på', () => {
  const whole = flowTree(ix, sak, 'whole');
  assert.deepEqual([1, 2, 3, Infinity].map(d => countTo(ix, whole, d).krav), [2, 3, 4, 4]);
  const rule = flowTree(ix, sak, 'rule');
  // Fase en følger bare «Første regel i A», men fase to følger hele A (ingen regel i kommentaren)
  assert.deepEqual([1, 2, 3, Infinity].map(d => countTo(ix, rule, d).krav), [2, 3, 4, 4]);
  assert.deepEqual(depsOf(ix, 'OPT-REG-KRA-001', 'Første regel i A', 'rule'), []);
  assert.deepEqual(depsOf(ix, 'OPT-REG-KRA-001', null, 'rule').map(d => [d.id, d.parts]), [['OPT-BEH-BEH-001', [{ k: 'Regel', t: 'Andre regel i A' }]]]);
});

test('et krav som er vist før, får seenAt i stedet for et nytt tre', () => {
  const t = flowTree(ix, sak, 'whole');
  assert.equal(t.roots[0][0].seenAt, null);
  assert.deepEqual(t.roots[1][0].seenAt, { phase: 1, level: 1 });
  assert.equal(t.roots[0][0].children[0].id, 'OPT-BEH-BEH-001');
  assert.equal(t.roots[0][0].children[0].children[0].id, 'OPT-REG-KRA-002');
});

test('flyt på flyt teller som ett nivå', () => {
  const t = flowTree(ix, opt, 'whole');
  assert.deepEqual(countTo(ix, t, 1), { krav: 0, flows: 1 });
  assert.equal(countTo(ix, t, 2).krav, 2);
});

test('kjeden bak og laveste status i kjeden', () => {
  const t = flowTree(ix, sak, 'whole');
  assert.deepEqual(chainBehind(ix, t.roots[0], 1), { status: 'planned', level: 2 }); // dypere enn valgt nivå
  assert.equal(chainLow(ix, t, 1)?.status, 'deprecated');
  assert.equal(chainLow(ix, flowTree(ix, opt, 'whole'), Infinity)?.status, 'deprecated');
});

test('kravene i flyten: hvert krav én gang, på det laveste nivået, med fasene og veien dit', () => {
  const list = flatKrav(ix, sak, flowTree(ix, sak, 'whole'), Infinity);
  const a = list.find(k => k.id === 'OPT-REG-KRA-001')!;
  assert.equal(a.level, 1);
  assert.deepEqual([...a.phases], [1, 2]);
  assert.deepEqual([...a.rules], ['Første regel i A']);
  assert.equal(a.whole, true); // fase to peker på hele kravet
  const c = list.find(k => k.id === 'OPT-REG-KRA-002')!;
  assert.equal(c.level, 3);
  assert.deepEqual([...c.via], ['OPT-BEH-BEH-001']);
});

test('varslene regnes med alle nivåer', () => {
  const kinds = (f: typeof sak) => flowWarnings(ix, f).map(w => w.kind);
  assert.deepEqual(kinds(sak), ['break', 'missing', 'deprecated']);
  assert.deepEqual(kinds(opt), ['deprecated', 'broken']);
});

test('ruta: #/flyter, stien og nivåene', () => {
  assert.deepEqual(parseFlyterHash('flyter'), { path: null, depth: null });
  assert.deepEqual(parseFlyterHash('flyter/krav/_Flyter/10 Opptaksløpet/saken.feature?nivåer=alle'), { path: 'krav/_Flyter/10 Opptaksløpet/saken.feature', depth: Infinity });
  assert.deepEqual(parseFlyterHash('flyter/x.feature?nivåer=2'), { path: 'x.feature', depth: 2 });
  assert.equal(parseFlyterHash('krav/README.md'), undefined);
  assert.equal(flyterHash('krav/_Flyter/a.feature', 1), '#/flyter/krav/_Flyter/a.feature');
  assert.equal(flyterHash('krav/_Flyter/a.feature', Infinity), '#/flyter/krav/_Flyter/a.feature?nivåer=alle');
  assert.equal(flyterHash(null, 3), '#/flyter');
});

test('hele kravet levert, og regler og scenarioer levert i et krav som er delvis levert', async () => {
  const { deliveryOf, isPartial } = await import('./flows.ts');
  const del = (tags: string, body: string) => {
    const e = buildEntry(A + 'x.feature', krav(tags, 'X', body), 0);
    return deliveryOf(e.status, e.model!);
  };
  const sc = (name: string, tags = '') => `${tags ? '    ' + tags + '\n' : ''}    Scenario: ${name}
      Gitt noe
      Når noe
      Så noe
`;
  // Delvis levert: @implemented på regelen gjelder scenarioene i den, ellers bare scenarioene som er tagget
  const part = del('@OPT-REG-KRA-009 @must @in-progress', `
  @implemented
  Regel: Levert regel
${sc('S1')}${sc('S2')}
  Regel: Halvveis
${sc('S3', '@implemented')}${sc('S4')}
  @draft @openquestion
  Regel: Utkast
    # ÅPNE SPØRSMÅL:
    # - Hva?
${sc('S5')}`);
  assert.deepEqual(part.delivery, { rules: 2, rulesDone: 1, scen: 4, scenDone: 3 });
  assert.deepEqual(part.rules.map(r => r.done), [true, false, null]);
  // Levert krav som endres: delene som er @planned, er ikke levert
  const changing = del('@OPT-REG-KRA-010 @must @implemented', `
  Regel: Levert
${sc('S1')}
  @planned
  Regel: Ny
${sc('S2')}`);
  assert.deepEqual(changing.delivery, { rules: 2, rulesDone: 1, scen: 2, scenDone: 1 });
  // Ikke levert: ingenting er levert, også når en del er tagget @implemented (det er bare lov under @in-progress)
  assert.equal(del('@OPT-REG-KRA-011 @must @planned', `\n  Regel: R\n${sc('S1')}`).delivery.rulesDone, 0);
  const k = { ...ix.krav.get('OPT-REG-KRA-001')!, status: 'in-progress' as const, delivery: part.delivery };
  assert.equal(isPartial(k), true);
  assert.equal(isPartial(ix.krav.get('OPT-REG-KRA-001')!), false); // hele kravet er levert
});
