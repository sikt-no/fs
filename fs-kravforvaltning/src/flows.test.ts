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
  focusLn,
  parseFlyterHash,
  partStatus,
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

test('fremdriften: en fase er levert når delen av kravene den bygger på, er levert, og en fase uten krav teller i totalen', () => {
  assert.equal(phaseStatus(ix, sak.phases[0]), 'implemented');
  assert.equal(phaseStatus(ix, sak.phases[1]), 'deprecated');
  assert.equal(phaseStatus(ix, sak.phases[2]), 'missing');
  assert.deepEqual(progress(ix, sak), { delivered: 1, total: 3, missing: 1 });
  assert.equal(phaseStatus(ix, opt.phases[0]), 'planned'); // flyten fasen peker på
  assert.equal(phaseStatus(ix, opt.phases[1]), 'broken');
});

test('hele kravet følger alle @depends-on-, bare delen følger regelen kommentaren peker på', () => {
  const whole = flowTree(ix, sak, 'whole');
  assert.deepEqual([1, 2, 3, Infinity].map(d => countTo(ix, whole, d).krav), [2, 3, 4, 4]);
  const part = flowTree(ix, sak, 'part');
  // Fase en følger bare «Første regel i A», men fase to følger hele A (ingen regel i kommentaren)
  assert.deepEqual([1, 2, 3, Infinity].map(d => countTo(ix, part, d).krav), [2, 3, 4, 4]);
  assert.deepEqual(part.roots[0][0].focus, { kind: 'note', rule: 'Første regel i A' });
  assert.equal(part.roots[1][0].focus, null);
  assert.deepEqual(depsOf(ix, 'OPT-REG-KRA-001', { kind: 'note', rule: 'Første regel i A' }, 'part'), []);
  assert.deepEqual(depsOf(ix, 'OPT-REG-KRA-001', null, 'part').map(d => [d.id, d.parts]), [['OPT-BEH-BEH-001', [{ k: 'Regel', t: 'Andre regel i A' }]]]);
});

// Ankeret: delene i kravet med @ref-<ID-en som peker på kravet> (*Anker* i krav/README.md)
const ank: Record<string, string> = {
  [A + 'x.feature']: krav('@OPT-REG-KRA-010 @must @planned', 'X', `
  @depends-on-OPT-REG-KRA-011
  Regel: Første regel i X
    Scenario: S1
      Gitt noe
      Når noe
      Så noe

  @depends-on-OPT-REG-KRA-012
  Regel: Andre regel i X
    @ref-FLY-OPT-ANK-001
    Scenario: S2
      Gitt noe
      Når noe
      Så noe

    @depends-on-OPT-REG-KRA-013
    Scenario: S3
      Gitt noe
      Når noe
      Så noe
`),
  [A + 'y.feature']: krav('@OPT-REG-KRA-012 @must @planned @ref-OPT-REG-KRA-099', 'Y', `
  @depends-on-OPT-REG-KRA-014
  Regel: Y1

  @ref-OPT-REG-KRA-010
  Regel: Y2
    @depends-on-OPT-REG-KRA-015
    Scenario: S4
      Gitt noe
      Når noe
      Så noe
`),
  ...Object.fromEntries(['011', '013', '014', '015'].map(n => [A + `k${n}.feature`, krav(`@OPT-REG-KRA-${n} @must @planned`, 'K' + n, '')])),
  [F + 'anker.feature']: krav('@FLY-OPT-ANK-001 @must @planned @e2e', 'Anker', `
  @depends-on-OPT-REG-KRA-010
  # «Første regel i X»
  Regel: Fasen bygger på ett scenario i X
    Scenario: Overleveringen
      Gitt noe
      Når noe
      Så noe
`),
};
const aix = buildFlows(Object.fromEntries(Object.entries(ank).map(([p, s]) => [p, buildEntry(p, s, 0)])));
const anker = aix.byId.get('FLY-OPT-ANK-001')!;
const ids = (ns: { id: string }[]) => ns.map(n => n.id).sort();

test('ankeret: @ref- på en regel eller et scenario samles per ID, @ref- på Egenskap: er ikke et anker', () => {
  assert.deepEqual([...aix.krav.get('OPT-REG-KRA-010')!.anchors.keys()], ['FLY-OPT-ANK-001']);
  assert.deepEqual(aix.krav.get('OPT-REG-KRA-010')!.anchors.get('FLY-OPT-ANK-001')!.map(a => [a.part, a.name, a.rule]), [['scenario', 'S2', 'Andre regel i X']]);
  assert.deepEqual([...aix.krav.get('OPT-REG-KRA-012')!.anchors.keys()], ['OPT-REG-KRA-010']);
});

test('ankeret går foran kommentaren, og et scenario følger også taggene på regelen over', () => {
  const t = flowTree(aix, anker, 'part');
  const x = t.roots[0][0];
  assert.equal(x.focus?.kind, 'anchor');
  // Scenarioet S2 følger @depends-on- på «Andre regel i X», ikke på S3 eller «Første regel i X» (kommentaren)
  assert.deepEqual(ids(x.children), ['OPT-REG-KRA-012']);
  // Y har ankeret @ref-OPT-REG-KRA-010 på Y2, så bare scenarioet under Y2 følges, ikke Y1
  const y = x.children[0];
  assert.deepEqual(y.focus, { kind: 'anchor', parts: [{ part: 'rule', name: 'Y2', rule: 'Y2', ln: y.focus?.kind === 'anchor' ? y.focus.parts[0].ln : 0 }] });
  assert.deepEqual(ids(y.children), ['OPT-REG-KRA-015']);
  assert.equal(focusLn(aix, 'OPT-REG-KRA-010', x.focus), aix.krav.get('OPT-REG-KRA-010')!.anchors.get('FLY-OPT-ANK-001')![0].ln);
  assert.deepEqual([...flatKrav(aix, anker, t, Infinity).find(k => k.id === 'OPT-REG-KRA-010')!.rules], ['Andre regel i X']);
});

test('hele kravet følger alle @depends-on-, også med anker', () => {
  const t = flowTree(aix, anker, 'whole');
  assert.deepEqual(ids(t.roots[0][0].children), ['OPT-REG-KRA-011', 'OPT-REG-KRA-012', 'OPT-REG-KRA-013']);
  assert.deepEqual([1, 2, 3].map(d => countTo(aix, t, d).krav), [1, 4, 6]);
  assert.deepEqual([1, 2, 3].map(d => countTo(aix, flowTree(aix, anker, 'part'), d).krav), [1, 2, 3]);
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

// Fasen er levert når delen den bygger på, er levert: ankeret, ellers regelen i «…», ellers hele kravet
const lev: Record<string, string> = {
  [A + 'p.feature']: krav('@OPT-REG-KRA-020 @must @in-progress', 'P', `
  @implemented @ref-FLY-OPT-LEV-001
  Regel: Levert del
    Scenario: S1
      Gitt noe
      Når noe
      Så noe

  Regel: Ikke levert
    Scenario: S2
      Gitt noe
      Når noe
      Så noe
`),
  [A + 'q.feature']: krav('@OPT-REG-KRA-021 @must @implemented', 'Q', `
  Regel: Levert
    Scenario: S1
      Gitt noe
      Når noe
      Så noe

  @planned
  Regel: Endres
    Scenario: S2
      Gitt noe
      Når noe
      Så noe
`),
  [A + 'r.feature']: krav('@OPT-REG-KRA-022 @must @in-progress', 'R', `
  @draft @openquestion @ref-FLY-OPT-LEV-001
  Regel: Utkast
    # ÅPNE SPØRSMÅL:
    # - Hva?
    Scenario: S1
      Gitt noe
      Når noe
      Så noe

  @implemented
  Regel: Ferdig
    Scenario: S2
      Gitt noe
      Når noe
      Så noe
`),
  [A + 's.feature']: krav('@OPT-REG-KRA-023 @must @in-progress', 'S', `
  @implemented
  Regel: Ferdig
    Scenario: S1
      Gitt noe
      Når noe
      Så noe

  Regel: Gjenstår
    Scenario: S2
      Gitt noe
      Når noe
      Så noe
`),
  [F + 'levert.feature']: krav('@FLY-OPT-LEV-001 @must @implemented @e2e', 'Levert', `
  @depends-on-OPT-REG-KRA-020
  Regel: Ankeret er levert

  @depends-on-OPT-REG-KRA-021
  # «Levert»
  Regel: Regelen i kommentaren er levert

  @depends-on-OPT-REG-KRA-021
  # «Endres»
  Regel: Regelen i kommentaren endres

  @depends-on-OPT-REG-KRA-022
  Regel: Ankeret er et utkast

  @depends-on-OPT-REG-KRA-023
  Regel: Hele kravet er ikke levert
`),
};
const lix = buildFlows(Object.fromEntries(Object.entries(lev).map(([p, s]) => [p, buildEntry(p, s, 0)])));
const levF = lix.byId.get('FLY-OPT-LEV-001')!;

test('fremdriften: ankeret og regelen i «…» avgjør når fasen er levert, ellers hele kravet', () => {
  assert.deepEqual(levF.phases.map(p => phaseStatus(lix, p)), ['implemented', 'implemented', 'planned', 'draft', 'in-progress']);
  assert.deepEqual(progress(lix, levF), { delivered: 2, total: 5, missing: 0 });
  assert.equal(partStatus(lix, 'OPT-REG-KRA-020', null), 'in-progress');
});

test('matrisen og kjeden: delen som følges, eller hele kravet', () => {
  const open = (follow: 'part' | 'whole') => Object.fromEntries(flatKrav(lix, levF, flowTree(lix, levF, follow), 1).map(k => [k.id, [...k.open]]));
  assert.deepEqual(open('part'), { 'OPT-REG-KRA-020': [], 'OPT-REG-KRA-021': [3], 'OPT-REG-KRA-022': [4], 'OPT-REG-KRA-023': [5] });
  assert.deepEqual(open('whole'), { 'OPT-REG-KRA-020': [1], 'OPT-REG-KRA-021': [], 'OPT-REG-KRA-022': [4], 'OPT-REG-KRA-023': [5] });
  assert.equal(chainLow(lix, flowTree(lix, levF, 'part'), 1)?.status, 'draft');
  assert.equal(chainLow(lix, flowTree(lix, levF, 'whole'), 1)?.status, 'in-progress');
});

test('varslene: ankeret på et utkast, og flyten bak delen den bygger på', () => {
  const w = flowWarnings(lix, levF);
  assert.deepEqual(w.map(x => x.kind), ['part-left', 'flow-behind']);
  assert.match(w[0].text, /«Utkast» i OPT-REG-KRA-022, som er utkast/);
  assert.match(w[1].text, /delen flyten bygger på i OPT-REG-KRA-021 er planned/);
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
