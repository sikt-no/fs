// Tester oppsettet for fanen «Kart» i Flyter (flowLayout.ts) mot et lite snapshot parset med den ekte parseren.
import assert from 'node:assert/strict';
import { test } from 'node:test';
import { buildEntry } from '../server/parse.ts';
import type { Snapshot } from '../shared/model.ts';
import { buildFlows, flowTree } from './flows.ts';
import { columnX, flowMapLayout, KRAV_H, type MapKrav, type MapPhase } from './flowLayout.ts';

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
  [A + 'a.feature']: krav('@OPT-REG-KRA-001 @must @in-progress @depends-on-OPT-BEH-BEH-002', 'A', `
  @implemented
  Regel: Første regel i A
    Scenario: S
      Gitt noe
      Når noe
      Så noe

  Regel: Andre regel i A
    Scenario: T
      Gitt noe
      Når noe
      Så noe
`),
  [B + 'b.feature']: krav('@OPT-BEH-BEH-001 @must @planned', 'B', `
  Regel: Regel i B
`),
  [B + 'd.feature']: krav('@OPT-BEH-BEH-002 @must @planned @depends-on-OPT-REG-KRA-001', 'D', `
  Regel: Regel i D
`),
  [A + 'c.feature']: krav('@OPT-REG-KRA-002 @must @draft', 'C', `
  Regel: Regel i C
`),
  [F + 'saken.feature']: krav('@FLY-OPT-SAK-001 @must @planned @e2e', 'Saken', `
  @depends-on-OPT-REG-KRA-001
  # «Første regel i A»
  Regel: Fase en

  @depends-on-OPT-BEH-BEH-001 @depends-on-OPT-REG-KRA-001
  Regel: Fase to

  @depends-on-OPT-REG-KRA-002
  Regel: Fase tre

  Regel: Fase fire uten krav
`),
};
const snap: Snapshot = Object.fromEntries(Object.entries(files).map(([p, s]) => [p, buildEntry(p, s, 0)]));
const ix = buildFlows(snap);
const sak = ix.byId.get('FLY-OPT-SAK-001')!;
const layout = (depth: number, follow: 'part' | 'whole' = 'part') => flowMapLayout(ix, sak, flowTree(ix, sak, follow), depth, follow);
const card = (l: ReturnType<typeof layout>, id: string) => l.nodes.find((n): n is MapKrav => n.kind === 'krav' && n.kravId === id);
const phase = (l: ReturnType<typeof layout>, n: number) => l.nodes.find((x): x is MapPhase => x.kind === 'phase' && x.phase.n === n)!;

test('fasene står i rekkefølge i kolonne 0, med en kant fra hver fase til den neste', () => {
  const l = layout(1);
  const ps = l.nodes.filter((n): n is MapPhase => n.kind === 'phase');
  assert.deepEqual(ps.map(p => p.phase.n), [1, 2, 3, 4]);
  assert.ok(ps.every((p, i) => p.x === 0 && (i === 0 || p.y > ps[i - 1].y + ps[i - 1].h)));
  assert.deepEqual(l.edges.filter(e => e.kind === 'seq').map(e => `${e.source}>${e.target}`), ['p1>p2', 'p2>p3', 'p3>p4']);
  assert.equal(phase(l, 4).status, 'missing');
});

test('et krav flere faser bygger på, får ett kort ved den første fasen, og en kant fra hver fase', () => {
  const l = layout(1);
  assert.equal(l.nodes.filter(n => n.kind === 'krav' && n.kravId === 'OPT-REG-KRA-001').length, 1);
  assert.equal(card(l, 'OPT-REG-KRA-001')!.y, phase(l, 1).y);
  assert.deepEqual(l.edges.filter(e => e.target === 'k:OPT-REG-KRA-001').map(e => e.source), ['p1', 'p2']);
  assert.equal(card(l, 'OPT-BEH-BEH-001')!.y, phase(l, 2).y);
});

test('kortene i samme kolonne overlapper ikke', () => {
  const l = layout(Infinity);
  const cols = new Map<number, MapKrav[]>();
  for (const n of l.nodes) if (n.kind === 'krav') cols.set(n.x, [...(cols.get(n.x) ?? []), n]);
  for (const list of cols.values()) {
    const ys = list.map(c => c.y).sort((a, b) => a - b);
    ys.forEach((v, i) => i === 0 || assert.ok(v - ys[i - 1] >= KRAV_H, `${v} og ${ys[i - 1]} overlapper`));
  }
});

test('kortet viser domenet og sub-domenet fra mappa', () => {
  const c = card(layout(1), 'OPT-BEH-BEH-001')!;
  assert.equal(c.domain, '02 Opptak');
  assert.equal(c.sub, '13 Søknad og saksbehandling');
});

test('nivå 2 står i kolonne 2, med kanten fra kravet over, og bare når nivået er valgt', () => {
  assert.equal(card(layout(1), 'OPT-BEH-BEH-002'), undefined);
  const l = layout(2);
  const d = card(l, 'OPT-BEH-BEH-002')!;
  assert.equal(d.level, 2);
  assert.equal(d.x, columnX(2));
  assert.equal(d.y, card(l, 'OPT-REG-KRA-001')!.y);
  assert.ok(l.edges.some(e => e.source === 'k:OPT-REG-KRA-001' && e.target === 'k:OPT-BEH-BEH-002'));
});

test('en ring gir ingen kant tilbake, men merker kravet kjeden går tilbake fra', () => {
  const l = layout(Infinity);
  assert.equal(l.edges.some(e => e.source === 'k:OPT-BEH-BEH-002'), false);
  assert.equal(card(l, 'OPT-BEH-BEH-002')!.ring, true);
  assert.equal(card(l, 'OPT-REG-KRA-001')!.ring, false);
});

test('kanten har statusen på delen fasen bygger på, eller på hele kravet med «Hele kravet»', () => {
  const edge = (l: ReturnType<typeof layout>, id: string) => l.edges.find(e => e.id === id)!;
  const part = layout(1, 'part');
  assert.equal(edge(part, 'p1>OPT-REG-KRA-001').status, 'implemented');
  assert.equal(edge(part, 'p1>OPT-REG-KRA-001').parts, 1);
  assert.equal(edge(part, 'p2>OPT-REG-KRA-001').status, 'in-progress');
  const whole = layout(1, 'whole');
  assert.equal(edge(whole, 'p1>OPT-REG-KRA-001').status, 'in-progress');
  assert.equal(edge(whole, 'p1>OPT-REG-KRA-001').parts, null);
});
