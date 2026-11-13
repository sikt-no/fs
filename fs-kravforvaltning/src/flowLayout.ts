// Oppsettet for fanen «Kart» i Flyter: fasene i en kolonne til venstre, og kravene fasene bygger på (@depends-on-)
// i kolonner til høyre, én kolonne per nivå. Rene funksjoner over FlowTree, testet i flowLayout.test.ts. Komponenten
// (FlowMap.tsx) gjør dem om til noder og kanter i React Flow.
import type { Status } from '../shared/model.ts';
import {
  exists,
  isFlowId,
  nodesTo,
  partStatus,
  phaseStatus,
  statusOf,
  titleOf,
  type Flow,
  type FlowIndex,
  type FlowPhase,
  type FlowTree,
  type Focus,
  type Follow,
  type PhaseStatus,
} from './flows.ts';

export const PHASE_W = 300;
export const KRAV_W = 290;
export const KRAV_H = 92;
const GAP_X = 120;
const GAP_Y = 40;
const KRAV_GAP = 12;

/** Høyden på fasekortet: tittelen bryter etter omtrent 38 tegn, og merkene for overleveringer og spørsmål tar en linje */
export function phaseHeight(p: FlowPhase): number {
  return 78 + (p.questions.length || p.handovers.length ? 26 : 0) + (p.title.length > 38 ? 18 : 0) + (p.title.length > 76 ? 18 : 0);
}
/** x for kolonnen: 0 er fasene, 1 er kravene fasene bygger på, 2 kravene de bygger på, osv. */
export const columnX = (col: number) => (col === 0 ? 0 : PHASE_W + GAP_X + (col - 1) * (KRAV_W + GAP_X));

export interface MapPhase {
  kind: 'phase';
  id: string;
  x: number;
  y: number;
  h: number;
  phase: FlowPhase;
  status: PhaseStatus;
}
export interface MapKrav {
  kind: 'krav';
  id: string;
  /** Feature-ID-en, eller ID-en til flyten */
  kravId: string;
  /** Kolonnen: det laveste nivået kravet står på i kjeden */
  level: number;
  x: number;
  y: number;
  h: number;
  title: string;
  status: Status | null;
  exists: boolean;
  flow: boolean;
  /** Domenet og sub-domenet, eller «Flyt» og prosessen */
  domain: string;
  sub: string;
  /** Delen den første fasen eller det første kravet bygger på: avgjør hvor kravet åpnes */
  focus: Focus;
  /** Kjeden fra kravet peker tilbake til et krav over (ring) */
  ring: boolean;
}
export type MapNode = MapPhase | MapKrav;
export interface MapEdge {
  id: string;
  kind: 'seq' | 'dep';
  source: string;
  target: string;
  /** Statusen på delen som følges («Bare delen fasen bygger på»), eller på hele kravet. `broken` når ID-en ikke finnes */
  status: Status | null | 'broken';
  /** Antall deler kanten bygger på (ankrene eller reglene i «…»), med «Bare delen fasen bygger på» */
  parts: number | null;
}

const phaseId = (n: number) => 'p' + n;
const kravId = (id: string) => 'k:' + id;
const partsIn = (f: Focus) => (!f ? null : f.kind === 'anchor' ? f.parts.length : f.rules.length);

export function flowMapLayout(ix: FlowIndex, f: Flow, tree: FlowTree, depth: number, follow: Follow): { nodes: MapNode[]; edges: MapEdge[] } {
  const nodes: MapNode[] = [];
  const edges: MapEdge[] = [];
  const tops = new Map<number, number>();
  let y = 0;
  f.phases.forEach((p, i) => {
    const h = phaseHeight(p);
    nodes.push({ kind: 'phase', id: phaseId(p.n), x: 0, y, h, phase: p, status: phaseStatus(ix, p) });
    tops.set(p.n, y);
    if (i > 0) edges.push({ id: `seq${p.n}`, kind: 'seq', source: phaseId(f.phases[i - 1].n), target: phaseId(p.n), status: null, parts: null });
    y += h + GAP_Y;
  });

  // Kravene: ett kort per ID, i kolonnen for det laveste nivået. Rekkefølgen er den nodene først dukker opp i
  // (fasene i rekkefølge, taggene i rekkefølge, kjeden under hver)
  const cards = new Map<string, MapKrav & { order: number; parents: string[]; phase: number }>();
  const all = nodesTo(tree, depth);
  for (const n of all) {
    if (n.cycle) {
      if (n.parent) {
        const c = cards.get(n.parent.id);
        if (c) c.ring = true;
      }
      continue;
    }
    let c = cards.get(n.id);
    if (!c) {
      const k = ix.krav.get(n.id);
      const flow = isFlowId(n.id);
      c = {
        kind: 'krav',
        id: kravId(n.id),
        kravId: n.id,
        level: tree.seen.get(n.id)?.level ?? n.level,
        x: 0,
        y: 0,
        h: KRAV_H,
        title: titleOf(ix, n.id),
        status: statusOf(ix, n.id),
        exists: exists(ix, n.id),
        flow,
        domain: flow ? 'Flyt' : (k?.domain ?? 'Ukjent domene'),
        sub: flow ? (ix.byId.get(n.id)?.process ?? '') : (k?.sub ?? 'Kravet finnes ikke'),
        focus: n.focus,
        ring: false,
        order: cards.size,
        parents: [],
        phase: n.phase,
      };
      cards.set(n.id, c);
    }
    if (n.parent) c.parents.push(n.parent.id);
    const source = n.parent ? kravId(n.parent.id) : phaseId(n.phase);
    const id = `${source}>${n.id}`;
    if (edges.some(e => e.id === id)) continue;
    const st = !exists(ix, n.id) ? 'broken' : follow === 'part' ? partStatus(ix, n.id, n.focus) : statusOf(ix, n.id);
    edges.push({ id, kind: 'dep', source, target: kravId(n.id), status: st, parts: follow === 'part' ? partsIn(n.focus) : null });
  }

  // Plasseringen, kolonne for kolonne: nivå 1 i høyde med den første fasen som bruker kravet, dypere nivåer i høyde
  // med det første kravet over som står i en kolonne til venstre. Kortene skyves ned så de ikke overlapper
  const placed = new Map<string, number>();
  const max = Math.max(0, ...[...cards.values()].map(c => c.level));
  for (let col = 1; col <= max; col++) {
    const list = [...cards.values()]
      .filter(c => c.level === col)
      .map(c => {
        const parent = c.parents.find(p => placed.has(p));
        return { c, want: parent !== undefined ? placed.get(parent)! : (tops.get(c.phase) ?? 0) };
      })
      .sort((a, b) => a.want - b.want || a.c.order - b.c.order);
    let floor = -Infinity;
    for (const { c, want } of list) {
      c.x = columnX(col);
      c.y = Math.max(want, floor);
      floor = c.y + KRAV_H + KRAV_GAP;
      placed.set(c.kravId, c.y);
    }
  }
  for (const c of cards.values()) {
    const { order: _o, parents: _p, phase: _ph, ...card } = c;
    nodes.push(card);
  }
  return { nodes, edges };
}
