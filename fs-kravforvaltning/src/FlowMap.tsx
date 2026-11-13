// Fanen «Kart» i Flyter: fasene og kravene de bygger på (@depends-on-) som et kart i React Flow, portet fra forslaget
// «Flytkart» (artefakt i claude.ai). Oppsettet er rene funksjoner i flowLayout.ts. Komponenten lastes først når fanen
// åpnes (lazy i Flyter.tsx), så React Flow ikke gjør resten av appen tregere å starte.
import '@xyflow/react/dist/base.css';
import { Background, Controls, Handle, MarkerType, MiniMap, Panel, Position, ReactFlow, ReactFlowProvider, useReactFlow, type Edge, type Node } from '@xyflow/react';
import { useEffect, useMemo, useState } from 'preact/hooks';
import { Dot, phaseLook, stColor } from './flowLook';
import { flowMapLayout, KRAV_W, PHASE_W, type MapEdge, type MapKrav, type MapPhase } from './flowLayout';
import type { Depth, Flow, FlowIndex, FlowTree, Focus, Follow } from './flows';

interface Props {
  ix: FlowIndex;
  flow: Flow;
  tree: FlowTree;
  depth: Depth;
  follow: Follow;
  /** Bytter til «Fasene» og går til fasen */
  toPhase: (n: number) => void;
  /** Åpner kravet i Krav, på delen fasen bygger på (en flyt åpnes i Flyter) */
  openKrav: (id: string, focus?: Focus) => void;
  /** Kartet dekker hele appen */
  full: boolean;
  onFull: (on: boolean) => void;
}

type PhaseData = { m: MapPhase; overview: boolean; dim: boolean };
type KravData = { m: MapKrav; dim: boolean; hl: boolean };

const Handles = () => (
  <>
    <Handle type="target" position={Position.Left} id="l" isConnectable={false} />
    <Handle type="source" position={Position.Right} id="r" isConnectable={false} />
    <Handle type="target" position={Position.Top} id="t" isConnectable={false} />
    <Handle type="source" position={Position.Bottom} id="b" isConnectable={false} />
    <Handle type="target" position={Position.Right} id="rt" isConnectable={false} />
  </>
);

function PhaseNode({ data }: { data: PhaseData }) {
  const { m, overview, dim } = data;
  const p = m.phase;
  const look = phaseLook(m.status, overview);
  return (
    <div class={'fl-mn fl-mn-phase' + (m.status === 'missing' ? ' missing' : '') + (dim ? ' dim' : '')} style={{ width: PHASE_W + 'px' }} title="Gå til fasen i «Fasene»">
      <Handles />
      <div class="hd">
        <span>Fase {p.n}</span>
        <span class="lbl">
          {look.l}
          <Dot c={look.c} fill={look.fill} dashed={look.dashed} z={9} />
        </span>
      </div>
      <div class="bd">{p.title}</div>
      {(p.handovers.length > 0 || p.questions.length > 0) && (
        <div class="ft">
          {p.handovers.length > 0 && <span class="chip">{p.handovers.length === 1 ? '1 overlevering' : `${p.handovers.length} overleveringer`}</span>}
          {p.questions.length > 0 && <span class="chip oq">{p.questions.length} åpne spørsmål</span>}
        </div>
      )}
    </div>
  );
}

function KravNode({ data }: { data: KravData }) {
  const { m, dim, hl } = data;
  return (
    <div class={'fl-mn fl-mn-krav' + (m.flow ? ' isflow' : '') + (!m.exists ? ' broken' : '') + (dim ? ' dim' : '') + (hl ? ' hl' : '')} style={{ width: KRAV_W + 'px' }} title={m.flow ? 'Åpne flyten' : 'Åpne kravet i Krav'}>
      <Handles />
      <div class="dom">
        <b>{m.domain}</b>
        {m.sub}
      </div>
      <div class="kbody">
        <Dot c={m.exists ? stColor(m.status) : 'var(--err)'} z={9} />
        <span class="id mono">{m.kravId}</span>
        <span class="kst mono">{m.exists ? (m.status ?? 'ingen status') : 'finnes ikke'}</span>
        <span class="t">{m.exists ? m.title : 'Kravet finnes ikke'}</span>
        {m.ring && <span class="ring mono" title="Kjeden fra kravet peker tilbake til et krav over">ring</span>}
      </div>
    </div>
  );
}

const nodeTypes = { phase: PhaseNode, krav: KravNode } as const;

const edgeColor = (e: MapEdge) => (e.status === 'broken' ? 'var(--err)' : stColor(e.status));

function MapView({ ix, flow, tree, depth, follow, toPhase, openKrav, full, onFull }: Props) {
  const rf = useReactFlow();
  const [hover, setHover] = useState<string | null>(null);
  const layout = useMemo(() => flowMapLayout(ix, flow, tree, depth, follow), [ix, flow, tree, depth, follow]);

  // Kravet musen står over, og det som henger direkte sammen med det: resten tones ned
  const near = useMemo(() => {
    if (!hover) return null;
    const s = new Set([hover]);
    for (const e of layout.edges) if (e.kind === 'dep' && (e.source === hover || e.target === hover)) s.add(e.source).add(e.target);
    return s;
  }, [hover, layout]);

  const nodes: Node[] = useMemo(
    () =>
      layout.nodes.map(m =>
        m.kind === 'phase'
          ? { id: m.id, type: 'phase', position: { x: m.x, y: m.y }, data: { m, overview: flow.overview, dim: !!near && !near.has(m.id) } }
          : { id: m.id, type: 'krav', position: { x: m.x, y: m.y }, data: { m, dim: !!near && !near.has(m.id), hl: hover === m.id } },
      ),
    [layout, near, hover, flow.overview],
  );
  const x = useMemo(() => new Map(layout.nodes.map(n => [n.id, n.x])), [layout]);
  const edges: Edge[] = useMemo(
    () =>
      layout.edges.map(e => {
        if (e.kind === 'seq')
          return {
            id: e.id,
            source: e.source,
            sourceHandle: 'b',
            target: e.target,
            targetHandle: 't',
            type: 'smoothstep',
            style: { stroke: 'var(--line2)', strokeWidth: 1.5 },
            markerEnd: { type: MarkerType.ArrowClosed, color: 'var(--line2)', width: 16, height: 16 },
          };
        const c = edgeColor(e);
        // Et krav som står i samme kolonne eller til venstre for kravet over (det står på et lavere nivå et annet
        // sted i kjeden), nås fra høyre side, så kanten ikke går en omvei rundt kortene
        const back = (x.get(e.target) ?? 0) <= (x.get(e.source) ?? 0);
        return {
          id: e.id,
          source: e.source,
          sourceHandle: 'r',
          target: e.target,
          targetHandle: back ? 'rt' : 'l',
          type: back ? 'smoothstep' : 'default',
          label: e.parts ? (e.parts === 1 ? '1 del' : `${e.parts} deler`) : undefined,
          style: { stroke: c, strokeWidth: 1.6, strokeDasharray: e.status === 'implemented' ? undefined : '5 4', opacity: near && !(near.has(e.source) && near.has(e.target)) ? 0.15 : 1 },
        };
      }),
    [layout, near, x],
  );

  // Ny flyt, nivå, «Følg» eller fullskjerm: alt får plass. En lang flyt blir da uleselig, og starter øverst med en
  // zoom som kan leses
  useEffect(() => {
    const t = setTimeout(() => {
      rf.fitView({ padding: 0.12, maxZoom: 1 });
      const vp = rf.getViewport();
      if (vp.zoom < 0.7) rf.setViewport({ x: Math.max(24, vp.x), y: 24, zoom: 0.8 });
    }, 30);
    return () => clearTimeout(t);
  }, [flow.id, depth, follow, full]);

  return (
    <ReactFlow
      nodes={nodes}
      edges={edges}
      nodeTypes={nodeTypes}
      nodesConnectable={false}
      elementsSelectable={false}
      minZoom={0.2}
      maxZoom={1.6}
      fitView
      proOptions={{ hideAttribution: true }}
      onNodeClick={(_: unknown, n: Node) => {
        const d = n.data as PhaseData | KravData;
        if (d.m.kind === 'phase') toPhase(d.m.phase.n);
        else openKrav(d.m.kravId, d.m.focus);
      }}
      onNodeMouseEnter={(_: unknown, n: Node) => n.type === 'krav' && setHover(n.id)}
      onNodeMouseLeave={() => setHover(null)}
    >
      <Background gap={18} size={1.2} color="var(--line2)" />
      <Controls showInteractive={false} position="bottom-left" />
      <MiniMap pannable zoomable position="bottom-right" nodeColor={(n: Node) => (n.type === 'phase' ? 'var(--k-rule-soft)' : 'var(--line2)')} maskColor="rgba(120, 120, 120, .12)" />
      {!full && (
        <Panel position="top-left">
          <button class="fl-fullbtn" onClick={() => onFull(true)} title="Vis kartet i hele vinduet">
            <span aria-hidden="true">⤢</span> Fullskjerm
          </button>
        </Panel>
      )}
      <Panel position="top-right" className="fl-maplegend">
        <span>
          <svg width="26" height="6" aria-hidden="true">
            <line x1="0" y1="3" x2="26" y2="3" stroke="var(--st-implemented)" stroke-width="1.6" />
          </svg>
          levert
        </span>
        <span>
          <svg width="26" height="6" aria-hidden="true">
            <line x1="0" y1="3" x2="26" y2="3" stroke="var(--st-planned)" stroke-width="1.6" stroke-dasharray="5 4" />
          </svg>
          {follow === 'part' ? 'delen er ikke levert' : 'kravet er ikke levert'}
        </span>
      </Panel>
    </ReactFlow>
  );
}

export default function FlowMap(p: Props) {
  return (
    <div class="fl-mapwrap">
      <ReactFlowProvider>
        <MapView {...p} />
      </ReactFlowProvider>
    </div>
  );
}
