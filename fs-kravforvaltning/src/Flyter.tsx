// Flyter-visningen: flytene i krav/_Flyter og relasjonene deres, portet fra designet «Flyter» (Claude Design, runde 1).
// Den valgte flyten vises som tidslinje (oversiktsflyten som svømmebane), med kravene hver fase bygger på og kjeden
// av @depends-on- under dem, til nivået brukeren velger. Logikken er rene funksjoner i flows.ts.
import type { JSX } from 'preact';
import { useEffect, useMemo, useRef, useState } from 'preact/hooks';
import type { Status } from '../shared/model';
import {
  chainBehind,
  chainLow,
  countTo,
  depsOf,
  domainOf,
  exists,
  flatKrav,
  flowTree,
  flowWarnings,
  focusLn,
  isFlowId,
  isPartial,
  ORD,
  partCount,
  partsOf,
  type FlowPart,
  pathOf,
  phaseStatus,
  progress,
  statusOf,
  titleOf,
  type DepNode,
  type Depth,
  type FlatKrav,
  type Flow,
  type FlowIndex,
  type FlowPhase,
  type Focus,
  type FlowWarning,
  type Follow,
  type Handover,
  type PhaseStatus,
} from './flows';

interface Props {
  ix: FlowIndex;
  /** Flyten som er valgt, `null` for startsiden */
  path: string | null;
  depth: Depth;
  onSelect: (path: string | null) => void;
  onDepth: (d: Depth) => void;
  /** Åpner en fil i Krav, eventuelt på en linje */
  onOpen: (path: string, line?: number) => void;
  sideHidden: boolean;
  outlineHidden: boolean;
}

type Tab = 'phases' | 'krav' | 'dom' | 'mx';
type Sort = 'level' | 'status' | 'domain';

const STC: Record<Status, string> = {
  draft: 'var(--st-draft)',
  planned: 'var(--st-planned)',
  'in-progress': 'var(--st-in-progress)',
  implemented: 'var(--st-implemented)',
  deprecated: 'var(--st-deprecated)',
};
const ORDER: (Status | 'none')[] = ['implemented', 'in-progress', 'planned', 'draft', 'deprecated', 'none'];
const stColor = (s: Status | null) => (s ? STC[s] : 'var(--st-none)');
const chip = (ix: FlowIndex, id: string) => (!exists(ix, id) ? { c: 'var(--err)', l: 'finnes ikke' } : { c: stColor(statusOf(ix, id)), l: statusOf(ix, id) ?? 'ingen status' });
const KW: Record<string, string> = { Gitt: 'var(--k-gitt)', Når: 'var(--k-naar)', Så: 'var(--k-saa)' };
/** Hva som er levert av kravet: «hele kravet», «3 av 9 regler», eller `null` når ingenting er levert */
function levert(ix: FlowIndex, id: string): string | null {
  const k = ix.krav.get(id);
  if (!k) return null;
  const d = k.delivery;
  if (k.status === 'implemented') return d.rulesDone < d.rules ? `hele kravet · ${d.rules - d.rulesDone} ${d.rules - d.rulesDone === 1 ? 'regel endres' : 'regler endres'}` : 'hele kravet';
  if (d.rulesDone) return `${d.rulesDone} av ${d.rules} regler`;
  if (d.scenDone) return `${d.scenDone} av ${d.scen} scenarioer`;
  return null;
}
/** Merket på et krav som er delvis levert */
const Partial = ({ ix, id }: { ix: FlowIndex; id: string }) => {
  const k = ix.krav.get(id);
  return k && isPartial(k) ? <span class="fl-partial mono" title="Kravet er ikke levert som helhet, men noen regler eller scenarioer er det">delvis levert · {levert(ix, id)}</span> : null;
};
const depthText = (d: Depth) => (d === 1 ? '1 nivå' : d === Infinity ? 'alle nivåer' : d + ' nivåer');
const nivå = (n: number) => n + (n === 1 ? ' nivå' : ' nivåer');
const coll = new Intl.Collator('nb', { numeric: true });

/** Fargen og etiketten på fasen. Fasen uten krav er stiplet */
function phaseLook(s: PhaseStatus, overview: boolean) {
  if (s === 'missing') return { c: 'var(--muted)', fill: 'transparent', dashed: true, l: overview ? 'mangler flyt' : 'mangler krav' };
  if (s === 'broken') return { c: 'var(--err)', fill: 'var(--err)', dashed: false, l: 'finnes ikke' };
  return { c: STC[s], fill: STC[s], dashed: false, l: s === 'implemented' ? 'levert' : s };
}

const Dot = ({ c, fill = c, dashed = false, z = 7 }: { c: string; fill?: string; dashed?: boolean; z?: number }) => (
  <span class="fl-dot" style={{ width: z + 'px', height: z + 'px', background: fill, border: `1.5px ${dashed ? 'dashed' : 'solid'} ${c}` }} />
);
const St = ({ c, l }: { c: string; l: string }) => (
  <span class="fl-st">
    <Dot c={c} />
    {l}
  </span>
);

/** Fremdriftsstolpen: ett segment per fase, farget med fasens status */
function Segs({ ix, f, h = 8, nums = false }: { ix: FlowIndex; f: Flow; h?: number; nums?: boolean }) {
  const segs = f.phases.map(p => {
    const look = phaseLook(phaseStatus(ix, p), f.overview);
    return { n: p.n, look, aria: `Fase ${p.n}: ${look.l}` };
  });
  return (
    <div class="fl-segs" role="img" aria-label={segs.map(s => s.aria).join(', ')}>
      <div class="fl-segrow" style={{ height: h + 'px' }}>
        {segs.map(s => (
          <span key={s.n} title={s.aria} style={{ background: s.look.dashed ? 'transparent' : s.look.fill, boxShadow: s.look.dashed ? 'inset 0 0 0 1px var(--muted)' : 'none' }} />
        ))}
      </div>
      {nums && (
        <div class="fl-segnums">
          {segs.map(s => <span key={s.n}>{s.n}</span>)}
        </div>
      )}
    </div>
  );
}
const progText = (ix: FlowIndex, f: Flow) => {
  const p = progress(ix, f);
  return `${p.delivered} av ${p.total} faser levert`;
};

/** Seglet i verktøylinja og fanene */
function Seg<T extends string | number>({ opts, cur, set, label }: { opts: { v: T; l: string; n?: string; title?: string }[]; cur: T; set: (v: T) => void; label: string }) {
  return (
    <div class="fl-seg" role="radiogroup" aria-label={label}>
      {opts.map(o => (
        <button key={String(o.v)} role="radio" aria-checked={o.v === cur} title={o.title} onClick={() => set(o.v)}>
          {o.l}
          {o.n && <span class="n">{o.n}</span>}
        </button>
      ))}
    </div>
  );
}

const WARN_LABEL: Record<FlowWarning['kind'], string> = {
  missing: 'fase uten krav',
  broken: 'brutt referanse',
  deprecated: 'avviklet krav',
  'part-left': 'del som er utkast',
  'flow-behind': 'flyten bak kravene',
  'cross-process': 'annen prosess',
  cycle: 'ring',
  break: 'kjent brudd',
};

export function Flyter({ ix, path, depth, onSelect, onDepth, onOpen, sideHidden, outlineHidden }: Props) {
  const flow = path ? (ix.flows.find(f => f.path === path) ?? null) : null;
  const [q, setQ] = useState('');
  const [closed, setClosed] = useState<Record<string, boolean>>({});
  const [follow, setFollow] = useState<Follow>('part');
  const [tab, setTab] = useState<Tab>('phases');
  const [sort, setSort] = useState<Sort>('level');
  const [fold, setFold] = useState<Record<string, boolean>>({});
  const [oqOpen, setOqOpen] = useState<Record<number, boolean>>({});
  const [hoOpen, setHoOpen] = useState<Record<number, boolean>>({});
  const [hl, setHl] = useState<string | null>(null);
  const [flash, setFlash] = useState<string | null>(null);
  // Oversiktsflyten (og fasen) flyten ble åpnet fra, til brødsmulen
  const [from, setFrom] = useState<{ path: string; title: string; phase: number; to: string } | null>(null);
  const mainRef = useRef<HTMLElement>(null);

  // Ny flyt: tilbake til fasene, og øverst
  useEffect(() => {
    setTab('phases');
    setHl(null);
    mainRef.current?.scrollTo({ top: 0 });
  }, [path]);

  // Live: fremdriften markeres kort når den endres
  const lastProg = useRef<Record<string, number>>({});
  const [progFlash, setProgFlash] = useState(false);
  useEffect(() => {
    if (!flow) return;
    const d = progress(ix, flow).delivered;
    const before = lastProg.current[flow.id];
    lastProg.current[flow.id] = d;
    if (before === undefined || before === d) return;
    setProgFlash(true);
    const t = setTimeout(() => setProgFlash(false), 2000);
    return () => clearTimeout(t);
  }, [ix, flow?.id]);

  const scrollToPhase = (n: number) => {
    const m = mainRef.current;
    const el = m?.querySelector<HTMLElement>(`[data-phase="${n}"]`);
    if (!m || !el) return;
    const top = el.getBoundingClientRect().top - m.getBoundingClientRect().top + m.scrollTop - 64;
    m.scrollTo({ top: Math.max(0, top), behavior: 'smooth' });
    const row = el.parentElement;
    if (row && row.scrollWidth > row.clientWidth) row.scrollTo({ left: el.offsetLeft - row.offsetLeft - 8, behavior: 'smooth' });
  };
  const toPhase = (n: number) => {
    setTab('phases');
    setTimeout(() => scrollToPhase(n), 40);
  };
  const goSeen = (phase: number, id: string) => {
    toPhase(phase);
    setFlash(id);
    setTimeout(() => setFlash(f => (f === id ? null : f)), 1800);
  };
  const openFlow = (f: Flow, phase?: number, fromPhase?: number) => {
    setFrom(fromPhase && flow ? { path: flow.path, title: flow.title, phase: fromPhase, to: f.path } : null);
    onSelect(f.path);
    if (phase) setTimeout(() => scrollToPhase(phase), 80);
  };
  /** Åpner kravet i Krav, på delen fasen bygger på når den er kjent (ankeret, ellers regelen i kommentaren) */
  const openKrav = (id: string, focus?: Focus) => {
    const p = pathOf(ix, id);
    if (!p) return;
    if (isFlowId(id)) return openFlow(ix.byId.get(id)!);
    onOpen(p, focusLn(ix, id, focus ?? null));
  };
  const isHl = (id: string) => hl === id || flash === id;
  const hover = (id: string) => ({ onMouseEnter: () => setHl(id), onMouseLeave: () => setHl(null), onFocus: () => setHl(id), onBlur: () => setHl(null) });

  // Treet til venstre: prosessene og flytene
  const ql = q.trim().toLowerCase();
  const side = (
    <aside class="fl-side">
      <div class="fl-sidehead">
        <div class="fl-sidepath mono">
          <span>krav</span>
          <span class="sep">/</span>
          <span class="cur">_Flyter</span>
        </div>
        <input value={q} onInput={e => setQ((e.target as HTMLInputElement).value)} placeholder="Filtrer flyter…" aria-label="Filtrer flyter" />
      </div>
      <div class="fl-tree" role="tree">
        {ix.byProcess.map(([proc, flows]) => {
          const shown = flows.filter(f => !ql || (f.title + f.file + f.id).toLowerCase().includes(ql));
          if (ql && !shown.length) return null;
          const open = !closed[proc] || !!ql;
          return (
            <div key={proc} role="group">
              <div role="treeitem" aria-expanded={open} tabIndex={0} class={'fl-trow dir' + (!flow ? ' sel' : '')} onClick={() => onSelect(null)} onKeyDown={e => e.key === 'Enter' && onSelect(null)}>
                <span
                  class="chev"
                  onClick={e => {
                    e.stopPropagation();
                    setClosed(c => ({ ...c, [proc]: open }));
                  }}
                >
                  {open ? '▾' : '▸'}
                </span>
                <span class="name">{proc}</span>
                <span class="fl-dirbar">
                  {flows.map(f => <span key={f.id} style={{ width: 100 / flows.length + '%', background: stColor(f.status) }} />)}
                </span>
                <span class="mono n">{flows.length}</span>
              </div>
              {open &&
                shown.map(f => (
                  <div key={f.path} role="treeitem" tabIndex={0} class={'fl-trow file' + (f.path === path ? ' sel' : '')} onClick={() => openFlow(f)} onKeyDown={e => e.key === 'Enter' && openFlow(f)} title={f.title}>
                    <span class="chev" />
                    {f.overview ? <span class="fl-ovicon" style={{ borderColor: stColor(f.status) }}><span style={{ background: stColor(f.status) }} /><span style={{ background: stColor(f.status) }} /></span> : <Dot c={stColor(f.status)} />}
                    <span class="name">{f.file}</span>
                    {f.overview && <span class="mono sub">oversikt</span>}
                    {f.error && <span class="fl-errmark" title="Fila kan ikke leses">!</span>}
                  </div>
                ))}
            </div>
          );
        })}
      </div>
      <div class="fl-legend">
        <span class="fl-ovicon" style={{ borderColor: 'var(--muted)' }} />
        oversiktsflyt
        <Dot c="var(--muted)" />
        flyt
      </div>
    </aside>
  );

  let body: JSX.Element;
  let outline: JSX.Element | null = null;
  if (!flow) body = <Start ix={ix} onOpen={(f, n) => openFlow(f, n)} />;
  else {
    const v = (
      <FlowView
        {...{ ix, flow, depth, onDepth, follow, setFollow, tab, setTab, sort, setSort, fold, setFold, oqOpen, setOqOpen, hoOpen, setHoOpen, isHl, hover, goSeen, toPhase, openFlow, openKrav, onOpen, progFlash }}
        crumbs={
          <div class="fl-crumbs">
            <a onClick={() => onSelect(null)}>{flow.process}</a>
            {from?.to === flow.path && (
              <>
                <span class="sep">→</span>
                <a onClick={() => openFlow(ix.flows.find(f => f.path === from.path)!, from.phase)}>
                  {from.title} · fase {from.phase}
                </a>
              </>
            )}
            <span class="sep">→</span>
            <span class="cur">{flow.title}</span>
          </div>
        }
      />
    );
    body = v;
    const tree = flowTree(ix, flow, follow);
    const nKrav = flatKrav(ix, flow, tree, depth).length;
    outline = (
      <aside class="fl-outline">
        <span class="fl-olhead mono">FASENE</span>
        {flow.phases.map(p => {
          const look = phaseLook(phaseStatus(ix, p), flow.overview);
          return (
            <button key={p.n} class="fl-olrow" onClick={() => toPhase(p.n)}>
              <span class="mono n">{p.n}</span>
              <span class="t">
                <span>{p.title}</span>
                <span class="fl-st">
                  <Dot c={look.c} fill={look.fill} dashed={look.dashed} z={6} />
                  {look.l}
                  {p.links.length > 0 && p.questions.length > 0 && <span class="q">· ?</span>}
                </span>
              </span>
            </button>
          );
        })}
        <div class="fl-olsep" />
        <button class="fl-ollink" onClick={() => setTab('krav')}>
          Kravene i flyten · {nKrav}
        </button>
      </aside>
    );
  }

  return (
    <div class={'flyter' + (sideHidden ? ' noside' : '') + (outlineHidden || !outline ? ' nooutline' : '')}>
      {!sideHidden && side}
      <main class="fl-main" ref={mainRef}>
        {body}
      </main>
      {!outlineHidden && outline}
    </div>
  );
}

// Startsiden -----------------------------------------------------------------------------------

function Start({ ix, onOpen }: { ix: FlowIndex; onOpen: (f: Flow, phase?: number) => void }) {
  const warns = useMemo(() => ix.flows.flatMap(f => flowWarnings(ix, f).map(w => ({ w, f }))), [ix]);
  if (!ix.flows.length)
    return (
      <div class="fl-start">
        <h1>Ingen flyter ennå</h1>
        <p>
          En flyt er et løp på tvers av domener, fase for fase. Flytene ligger i <code>krav/_Flyter</code>, og skrives med <code>fs-krav</code>.
        </p>
        <a href="#/krav/README.md">Les om Flyter i krav/README.md</a>
      </div>
    );
  const nPh = ix.flows.reduce((a, f) => a + f.phases.length, 0);
  const nums = [
    { n: ix.flows.length, l: 'flyter' },
    { n: nPh, l: 'faser' },
    { n: ix.flows.reduce((a, f) => a + progress(ix, f).missing, 0), l: 'faser uten krav', warn: true },
    { n: ix.flows.filter(f => f.status === 'implemented').length, l: 'flyter implemented' },
    { n: ix.flows.reduce((a, f) => a + f.knownBreaks.length, 0), l: 'kjente brudd', warn: true },
  ];
  return (
    <div class="fl-start">
      <div class="fl-starthead">
        <h1>Flyter</h1>
        <p>En flyt er et løp på tvers av domener, fase for fase. Den viser hvilke krav hver fase bygger på, og om overleveringene mellom fasene virker.</p>
      </div>
      <div class="fl-nums">
        {nums.map(m => (
          <div key={m.l}>
            <span class="mono" style={{ color: m.warn && m.n ? 'var(--warn)' : 'var(--ink)' }}>{m.n}</span>
            <span>{m.l}</span>
          </div>
        ))}
      </div>
      {ix.byProcess.map(([proc, flows]) => (
        <section key={proc} class="fl-sec">
          <div class="fl-sechead">
            <h2>{proc}</h2>
            <span class="mono">{flows.length} flyter</span>
          </div>
          <div class="fl-box">
            {flows.map(f => (
              <div key={f.path} class={'fl-flowrow' + (f.overview ? ' ov' : '')} tabIndex={0} onClick={() => onOpen(f)} onKeyDown={e => e.key === 'Enter' && onOpen(f)}>
                <div class="t">
                  <div>
                    {f.overview && <span class="fl-ovtag mono">oversikt</span>}
                    <span class="title">{f.title}</span>
                  </div>
                  <span class="mono sub">
                    {f.id} · {f.file}
                  </span>
                </div>
                <div class="p">
                  <Segs ix={ix} f={f} />
                  <span>{progText(ix, f)}</span>
                </div>
                <div class="s">
                  <span class="fl-tagchip mono">
                    <Dot c={stColor(f.status)} />@{f.status ?? 'ingen status'}
                  </span>
                  <span class="sub">flytens status</span>
                </div>
              </div>
            ))}
          </div>
        </section>
      ))}
      <section class="fl-sec">
        <div class="fl-sechead">
          <h2>Varsler</h2>
          <span class="mono">{warns.length} · regnet med alle nivåer</span>
        </div>
        <div class="fl-box">
          {warns.length === 0 && <div class="fl-empty">Ingen varsler.</div>}
          {warns.map(({ w, f }, i) => (
            <div key={i} class="fl-warnrow" tabIndex={0} onClick={() => onOpen(f, w.phase)} onKeyDown={e => e.key === 'Enter' && onOpen(f, w.phase)}>
              <span class={'fl-kind mono' + (w.kind === 'missing' ? ' dashed' : '') + (w.kind === 'broken' || w.kind === 'cycle' ? ' err' : '')}>{w.kind === 'missing' && f.overview ? 'fase uten flyt' : WARN_LABEL[w.kind]}</span>
              <div class="t">
                <span>
                  {f.title}
                  {w.phase ? ` · fase ${w.phase} · ${f.phases[w.phase - 1]?.title ?? ''}` : ''}
                </span>
                <span class="sub">{w.kind === 'break' ? `${w.text} · løpet er kjent brutt` : w.text}</span>
              </div>
              <span class="go">{w.phase ? 'Vis fasen →' : 'Vis flyten →'}</span>
            </div>
          ))}
        </div>
      </section>
    </div>
  );
}

// Den valgte flyten -----------------------------------------------------------------------------

interface ViewProps {
  ix: FlowIndex;
  flow: Flow;
  crumbs: JSX.Element;
  depth: Depth;
  onDepth: (d: Depth) => void;
  follow: Follow;
  setFollow: (f: Follow) => void;
  tab: Tab;
  setTab: (t: Tab) => void;
  sort: Sort;
  setSort: (s: Sort) => void;
  fold: Record<string, boolean>;
  setFold: (f: (o: Record<string, boolean>) => Record<string, boolean>) => void;
  oqOpen: Record<number, boolean>;
  setOqOpen: (f: (o: Record<number, boolean>) => Record<number, boolean>) => void;
  hoOpen: Record<number, boolean>;
  setHoOpen: (f: (o: Record<number, boolean>) => Record<number, boolean>) => void;
  isHl: (id: string) => boolean;
  hover: (id: string) => Record<string, () => void>;
  goSeen: (phase: number, id: string) => void;
  toPhase: (n: number) => void;
  openFlow: (f: Flow, phase?: number, fromPhase?: number) => void;
  openKrav: (id: string, focus?: Focus) => void;
  onOpen: (path: string, line?: number) => void;
  progFlash: boolean;
}

function FlowView(p: ViewProps) {
  const { ix, flow, depth, follow, tab } = p;
  const tree = useMemo(() => flowTree(ix, flow, follow), [ix, flow, follow]);
  const warns = useMemo(() => flowWarnings(ix, flow), [ix, flow]);
  const list = useMemo(() => flatKrav(ix, flow, tree, depth), [ix, flow, tree, depth]);
  const pr = progress(ix, flow);
  const low = chainLow(ix, tree, depth);
  const nOq = flow.phases.reduce((a, ph) => a + ph.questions.length, 0);
  const firstOq = flow.phases.find(ph => ph.questions.length);
  const usedBy = ix.usedBy.get(flow.id) ?? [];
  const countLabel = (d: Depth) => {
    const c = countTo(ix, tree, d);
    return c.krav ? `${c.krav} krav` : `${c.flows} flyt`;
  };
  // Nivået teller der det kommer nye krav: et krav som er med høyere opp, kan stå dypere i treet uten å telle
  const levelMsg = depth === Infinity ? `Ingen nye krav etter nivå ${tree.max}.` :depth > tree.max ? `Ingen nye krav på nivå ${depth}: alle avhengighetene er vist.` : '';
  const headWarns = warns.filter(w => w.kind === 'flow-behind' || w.kind === 'cross-process' || w.kind === 'cycle');
  const domCount = new Set(list.map(k => ix.krav.get(k.id)!.domain + '/' + ix.krav.get(k.id)!.sub)).size;
  const followT = follow === 'part' ? ', bare delen fasen bygger på' : '';

  return (
    <>
      {flow.error && (
        <div class="fl-alert err" role="alert">
          <span>
            <span class="mono">{flow.file}</span> kan ikke leses. Visningen viser sist gyldige versjon.
          </span>
          <span class="mono small">{flow.error}</span>
        </div>
      )}
      <div class="fl-head">
        {p.crumbs}
        <div class="fl-title">
          <div class="fl-tags mono">
            <span class="id">@{flow.id}</span>
            {flow.tags.filter(t => t !== '@' + flow.id && !(t.slice(1) in ORD)).map(t => <span key={t}>{t}</span>)}
            {flow.overview && <span class="fl-ovtag">oversiktsflyt</span>}
            <a onClick={() => p.onOpen(flow.path)}>{flow.file}</a>
          </div>
          <h1>{flow.title}</h1>
          {flow.desc.map((d, i) => <p key={i}>{d}</p>)}
        </div>

        <div class="fl-boxes">
          <div class="fl-card">
            <div class="fl-cardhead">
              <b>Fremdrift</b>
              <span>fra kravene fasene bygger på</span>
            </div>
            <Segs ix={ix} f={flow} h={12} nums />
            <div class="fl-progt">
              <span class={'bigt' + (p.progFlash ? ' flash' : '')}>{progText(ix, flow)}</span>
              {pr.missing > 0 && <span>{pr.missing} faser uten {flow.overview ? 'flyt' : 'krav'}</span>}
            </div>
            {(() => {
              const ks = list.map(k => ix.krav.get(k.id)!);
              const ready = list.filter(k => !k.open.size).length;
              const whole = ks.filter(k => k.status === 'implemented').length;
              const part = ks.filter(isPartial).length;
              const pc = partCount(list);
              return (
                <div class="fl-levert">
                  <span>
                    Kravene, {depthText(depth)}: <b>{ready} av {ks.length}</b> levert for flyten{follow === 'part' ? <> · {whole} som helhet{part > 0 && <>, {part} delvis levert</>}</> : part > 0 && <>, {part} delvis levert</>}
                  </span>
                  <span title={follow === 'part' ? 'Ankrene, ellers reglene i «…» under taggen, ellers reglene i hele kravet' : 'Reglene i kravene, unntatt utkast og avviklede regler'}>
                    {follow === 'part' ? 'Delene flyten bygger på' : 'Reglene i kravene'}: <b>{pc.done} av {pc.total}</b> levert
                  </span>
                </div>
              );
            })()}
            <div class="fl-chain">
              <span>Kjeden, {depthText(depth)}: laveste status</span>
              <St c={low ? stColor(low.status) : 'var(--st-none)'} l={low ? (low.status ?? 'ingen status') : '–'} />
              {low && <span class="muted">{low.at.level === 1 ? `på nivå 1, fase ${low.at.phase}` : `${nivå(low.at.level - 1)} ned, fase ${low.at.phase}`}</span>}
            </div>
          </div>
          <div class="fl-card">
            <div class="fl-cardhead">
              <b>Flytens egen status</b>
              <span>fra taggen på flyten</span>
            </div>
            <div class="fl-own">
              {(['draft', 'planned', 'implemented'] as const).map((k, i) => (
                <span key={k} class="ostep">
                  {i > 0 && <span class="arrow">→</span>}
                  <span class={'fl-tagchip mono' + (k === flow.status ? ' on' : '')}>
                    <Dot c={k === flow.status ? STC[k] : 'var(--line2)'} />@{k}
                  </span>
                </span>
              ))}
            </div>
            <span class="bigt">{flow.status === 'implemented' ? 'Overleveringene er verifisert i koden' : 'Overleveringene er ikke verifisert'}</span>
            <span class="muted small">Går draft → planned → implemented, uten in-progress.</span>
          </div>
        </div>

        <div class="fl-alerts">
          {flow.knownBreaks.map(b => (
            <div key={b} class="fl-alert warn inline" role="alert">
              <span class="mono label">KJENT BRUDD</span>
              <span>{b}</span>
            </div>
          ))}
          {headWarns.map((w, i) => (
            <div key={i} class={'fl-alert ' + (w.kind === 'cycle' ? 'err' : 'warn')} role="alert">
              <span class="mono label">{w.kind === 'cycle' ? `RING · ${nivå(w.level ?? 1).toUpperCase()} NED` : WARN_LABEL[w.kind].toUpperCase()}</span>
              <span class={w.kind === 'cycle' ? 'mono small' : ''}>{w.text}</span>
            </div>
          ))}
          <div class="fl-headmeta">
            {nOq > 0 && firstOq && (
              <span>
                <span class="fl-q mono">?</span>
                {nOq} åpne spørsmål
                <a
                  onClick={() => {
                    p.setOqOpen(o => ({ ...o, [firstOq.n]: true }));
                    p.toPhase(firstOq.n);
                  }}
                >
                  gå til det første
                </a>
              </span>
            )}
            {usedBy.length > 0 ? (
              <span>
                Brukes i
                {usedBy.map(u => {
                  const f = ix.byId.get(u.flow)!;
                  return (
                    <a key={u.flow + u.phase} onClick={() => p.openFlow(f, u.phase)}>
                      {f.title}, fase {u.phase}
                    </a>
                  );
                })}
              </span>
            ) : (
              <span class="muted">{flow.overview ? 'Oversiktsflyt for prosessen' : 'Brukes ikke i noen oversiktsflyt'}</span>
            )}
          </div>
        </div>
      </div>

      <div class="fl-toolbar">
        <div class="fl-tabs" role="tablist">
          {(
            [
              { v: 'phases', l: 'Fasene', n: String(flow.phases.length) },
              { v: 'krav', l: 'Kravene i flyten', n: String(list.length) },
              { v: 'dom', l: 'Per domene', n: String(domCount) },
              { v: 'mx', l: 'Matrise', n: '' },
            ] as const
          ).map(t => (
            <button key={t.v} role="tab" aria-selected={tab === t.v} onClick={() => p.setTab(t.v)}>
              {t.l}
              {t.n && <span class="n mono">{t.n}</span>}
            </button>
          ))}
        </div>
        <span class="vsep" />
        <div class="fl-ctl">
          <span>Nivåer</span>
          <Seg
            label="Nivåer av avhengigheter"
            cur={depth}
            set={p.onDepth}
            opts={[1, 2, 3, Infinity].map(v => ({ v, l: v === 1 ? '1 nivå' : v === Infinity ? 'Alle' : String(v), n: countLabel(v), title: v === 1 ? 'Kravene fasene bygger på' : 'Også kravene de kravene bygger på' }))}
          />
        </div>
        <div class="fl-ctl">
          <span>Følg</span>
          <Seg
            label="Hvilken del av kravet som følges"
            cur={follow}
            set={p.setFollow}
            opts={[
              { v: 'part', l: 'Bare delen fasen bygger på' },
              { v: 'whole', l: 'Hele kravet' },
            ]}
          />
        </div>
        {levelMsg && <span class="muted small">{levelMsg}</span>}
      </div>

      {tab === 'phases' && <Phases {...p} tree={tree} />}
      {tab === 'krav' && <KravTab {...p} tree={tree} list={list} intro={`Det som må være levert for at flyten skal virke, til ${depthText(depth)}${followT}.`} />}
      {tab === 'dom' && <DomTab ix={ix} list={list} follow={follow} onOpen={p.onOpen} intro={`Kravene flyten bygger på, til ${depthText(depth)}${followT}, samlet per domene og sub-domene. Hvert sub-domene er et team som kan levere til flyten.`} />}
      {tab === 'mx' && <MatrixTab ix={ix} flow={flow} list={list} toPhase={p.toPhase} depth={depth} follow={follow} />}
    </>
  );
}

// Fasene ---------------------------------------------------------------------------------------

function Phases(p: ViewProps & { tree: ReturnType<typeof flowTree> }) {
  const { ix, flow, depth, follow, tree } = p;
  const lane = flow.overview;
  const occ: Record<string, number[]> = {};
  flow.phases.forEach(ph => ph.links.forEach(l => (occ[l.id] = [...(occ[l.id] ?? []), ph.n])));
  return (
    <div class={'fl-phases' + (lane ? ' lane' : ' line')}>
      {flow.phases.map((ph, i) => (
        <Phase key={ph.n} {...p} ph={ph} roots={tree.roots[i]} occ={occ} last={i === flow.phases.length - 1} lane={lane} depth={depth} follow={follow} />
      ))}
    </div>
  );
}

function Phase(p: ViewProps & { ph: FlowPhase; roots: DepNode[]; occ: Record<string, number[]>; last: boolean; lane: boolean }) {
  const { ix, flow, ph, roots, depth, follow } = p;
  const s = phaseStatus(ix, ph);
  const look = phaseLook(s, flow.overview);
  const missing = s === 'missing';
  const behind = chainBehind(ix, roots, depth);
  const hoOpen = !!p.hoOpen[ph.n];
  const oqOpen = !!p.oqOpen[ph.n];
  return (
    <div class="fl-phase" data-phase={ph.n} style={p.lane ? { flex: missing ? '1 1 0' : '2 1 0' } : undefined}>
      {!p.lane && (
        <div class="fl-rail" aria-hidden="true">
          <span class="num mono" style={{ borderColor: look.c, borderStyle: look.dashed ? 'dashed' : 'solid' }}>
            {ph.n}
          </span>
          {!p.last && <span class="line" />}
        </div>
      )}
      <div class="fl-phbody">
        <div class="fl-phhead">
          <div class="meta">
            <span class="mono muted">Fase {ph.n}</span>
            <span class="fl-st">
              <Dot c={look.c} fill={look.fill} dashed={look.dashed} />
              {look.l}
            </span>
            <a class="mono muted lnk" onClick={() => p.onOpen(flow.path, ph.ln)} title="Åpne fasen i Krav">
              L{ph.ln}
            </a>
          </div>
          <h3>{ph.title}</h3>
          {behind && (
            <span class="fl-chip warn">
              Fasen bygger på et krav som er {behind.status}, {nivå(behind.level - 1)} ned
              {behind.level > depth && <a onClick={() => p.onDepth(behind.level)}>Vis {nivå(behind.level)}</a>}
            </span>
          )}
        </div>

        {missing && (
          <div class="fl-missing">
            <div>
              <span class="fl-kind mono dashed">{flow.overview ? 'ingen flyt' : 'ingen krav'}</span>
              <span class="mono muted">@openquestion</span>
            </div>
            <span>{ph.questions[0] ?? `Fase ${ph.n} bygger ikke på noe ${flow.overview ? 'flyt' : 'krav'}.`}</span>
          </div>
        )}

        {roots.map(n => (
          <DepCard key={n.id} {...p} n={n} />
        ))}

        {ph.refs.length > 0 && (
          <div class="fl-refs">
            <span class="mono muted">henvisning · ikke en avhengighet</span>
            {ph.refs.map(id => (
              <div key={id} onClick={() => p.openKrav(id)}>
                <span class="mono">{id}</span>
                <span>{titleOf(ix, id) || 'Finnes ikke'}</span>
              </div>
            ))}
          </div>
        )}

        {!missing && ph.questions.length > 0 && (
          <div class="fl-oq">
            <button aria-expanded={oqOpen} onClick={() => p.setOqOpen(o => ({ ...o, [ph.n]: !o[ph.n] }))}>
              <span class="chev">{oqOpen ? '▾' : '▸'}</span>
              <span class="fl-q mono">? {ph.questions.length}</span>
              {ph.questions.length === 1 ? '1 åpent spørsmål' : `${ph.questions.length} åpne spørsmål`}
            </button>
            {oqOpen && (
              <div class="list">
                {ph.questions.map((q, i) => <span key={i}>{q}</span>)}
              </div>
            )}
          </div>
        )}

        {ph.handovers.length > 0 && (
          <div class="fl-ho">
            <button class="mono" aria-expanded={hoOpen} onClick={() => p.setHoOpen(o => ({ ...o, [ph.n]: !o[ph.n] }))}>
              <span class="chev">{hoOpen ? '▾' : '▸'}</span>
              {(p.last ? 'Overlevering: det fasen lager' : `Overlevering til fase ${ph.n + 1}`) + (hoOpen ? ' · alle steg' : ' · Gitt og Så')}
            </button>
            {ph.handovers.map(h => {
              const firstOf = (kw: string) => h.steps.find(st => st.kw === kw);
              const shown = hoOpen ? h.steps : [firstOf('Gitt'), firstOf('Så')].filter((st): st is Handover['steps'][number] => !!st);
              const hidden = h.steps.length - shown.length;
              return (
                <div key={h.ln} class="fl-scen">
                  <div class="head" onClick={() => p.onOpen(flow.path, h.ln)}>
                    <span class="kb mono">Scenario</span>
                    <span class="t">{h.name}</span>
                    {h.openQuestion && <span class="fl-q mono">?</span>}
                    <span class="mono muted lnk">L{h.ln}</span>
                  </div>
                  <div class="fsteps">
                    {shown.map((st, i) => (
                      <div key={i} class="fstep">
                        <span class="kw mono" style={{ color: KW[st.kw] ?? 'var(--k-gitt)' }}>
                          {st.kw}
                        </span>
                        <span>{st.text}</span>
                      </div>
                    ))}
                    {hidden > 0 && (
                      <button class="mono more" onClick={() => p.setHoOpen(o => ({ ...o, [ph.n]: true }))}>
                        + {hidden} steg til
                      </button>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}

/** Kortet for et krav (eller en flyt) fasen bygger på, med kjeden under */
function DepCard(p: ViewProps & { ph: FlowPhase; n: DepNode; occ: Record<string, number[]> }) {
  const { ix, ph, n, depth, follow } = p;
  const fl = isFlowId(n.id) ? ix.byId.get(n.id) : null;
  const ok = exists(ix, n.id);
  const st = chip(ix, n.id);
  const other = (p.occ[n.id] ?? []).filter(x => x !== ph.n);
  const hl = p.isHl(n.id);
  const rows: JSX.Element[] = [];
  if (!n.seenAt) walkRows(p, n, ph.n, rows);
  const hasOwnDeps = depsOf(ix, n.id, n.focus, follow).length > 0;

  if (!ok)
    return (
      <div class="fl-dep broken">
        <div class="body">
          <div class="drow">
            <span class="mono errl">Finnes ikke</span>
            <span class="mono">{n.id}</span>
          </div>
          <span>
            Fase {ph.n} peker på en Feature-ID som ikke finnes under krav/. Rett taggen <span class="mono">@depends-on-{n.id}</span>
            {' '}
            <a onClick={() => p.onOpen(p.flow.path, ph.ln)}>ved linje {ph.ln}</a>.
          </span>
        </div>
      </div>
    );

  return (
    <div class={'fl-dep' + (hl ? ' hl' : '') + (statusOf(ix, n.id) === 'deprecated' ? ' dep' : '')} tabIndex={0} {...p.hover(n.id)} onKeyDown={e => e.key === 'Enter' && e.target === e.currentTarget && p.openKrav(n.id, n.focus)}>
      <div class="body" onClick={() => p.openKrav(n.id, n.focus)}>
        <div class="drow">
          <St c={fl ? stColor(fl.status) : st.c} l={fl ? `flyten er ${fl.status ?? 'uten status'}` : st.l} />
          <Partial ix={ix} id={n.id} />
          <span class="mono id">{n.id}</span>
          {other.length > 0 && (
            <span class="fl-rep mono" title="Samme krav står i flere faser">
              også i fase {other.join(', ')}
            </span>
          )}
          <span class="mono muted dom">{domainOf(ix, n.id)}</span>
        </div>
        <span class={'title' + (statusOf(ix, n.id) === 'deprecated' ? ' struck' : '')}>{titleOf(ix, n.id)}</span>
        {fl && (
          <div class="flow">
            <Segs ix={ix} f={fl} h={6} />
            <div class="drow small">
              <span>{progText(ix, fl)}</span>
              <span class="fl-tagchip mono">
                <Dot c={stColor(fl.status)} z={6} />@{fl.status ?? 'ingen status'}
              </span>
            </div>
            <a
              onClick={e => {
                e.stopPropagation();
                p.openFlow(fl, undefined, ph.n);
              }}
            >
              Åpne flyten →
            </a>
          </div>
        )}
        {n.focus && (
          <div
            class="dnote"
            title={n.focus.kind === 'anchor' ? `Delene i ${n.id} med @ref-${p.flow.id}${n.notes.length ? ' i reglene i «…»' : ''}: fasen bygger bare på dem` : 'Reglene i «…» i kommentaren under taggen: fasen bygger bare på dem'}
          >
            <span class="mono muted">{n.focus.kind === 'anchor' ? '@ref-' : n.notes.length > 1 ? 'regler' : 'regel'}</span>
            <span class="parts">
              {partsOf(ix, n.id, n.focus).map(pt => (
                <PartLink key={pt.ln} pt={pt} open={() => p.onOpen(pathOf(ix, n.id)!, pt.ln)} />
              ))}
            </span>
          </div>
        )}
        {follow === 'part' && !n.focus && hasOwnDeps && depth > 1 && !fl && <span class="muted small">Ikke noe anker eller regel i kommentaren: hele kravet følges</span>}
      </div>
      {statusOf(ix, n.id) === 'deprecated' && <div class="deprecated">Kravet er avviklet. Fasen peker på det, og må peke på kravet som erstatter det.</div>}
      {rows.length > 0 && (
        <div class="fl-deptree" role="tree" aria-label={fl ? 'Kravene i flyten' : `${n.id} bygger på`}>
          <span class="mono muted cap">{fl ? 'Kravene i flyten · fra flyten' : `${n.id} bygger på · fra kravet`}</span>
          {rows}
        </div>
      )}
      {n.seenAt && depth > 1 && hasOwnDeps && <div class="seenmsg">Avhengighetene står under fase {n.seenAt.phase}</div>}
    </div>
  );
}

const partSt = (pt: FlowPart) => (pt.status === 'implemented' ? 'levert' : (pt.status ?? 'ingen status'));
/** En del av kravet med statusen sin, som åpner kravet på delen */
const PartLink = ({ pt, open }: { pt: FlowPart; open: () => void }) => (
  <a
    class="fl-part"
    title={partSt(pt)}
    onClick={e => {
      e.stopPropagation();
      open();
    }}
  >
    <Dot c={stColor(pt.status)} z={6} />
    <span class="mono">{pt.part === 'rule' ? 'Regel' : pt.part === 'scenario' ? 'Scenario' : 'Hele kravet'}:</span> {pt.name}
  </a>
);

/** Radene i treet under et kort, til og med valgt nivå */
function walkRows(p: ViewProps, node: DepNode, pn: number, out: JSX.Element[]) {
  const { ix, depth } = p;
  for (const c of node.children) {
    if (c.level > depth) continue;
    const key = pn + '|' + c.chain.join('>');
    const kids = c.children.filter(x => x.level <= depth);
    const folded = !!p.fold[key];
    const ok = exists(ix, c.id);
    const x = 6 + (c.level - 2) * 18;
    const st = chip(ix, c.id);
    const parts = (c.parts ?? [{ k: 'Hele kravet', t: '' }]).map((pt, i) => (
      <span key={i} class="part">
        <span class="mono">{pt.k}{pt.t ? ':' : ''}</span> {pt.t}
      </span>
    ));
    // Delen av kravet som følges: ankrene (@ref-<kravet over>), ellers regelen i kommentaren under taggen
    const focus = c.focus
      ? partsOf(ix, c.id, c.focus).map(pt => (
          <span key={'f' + pt.ln} class="part focus" title={`${c.focus?.kind === 'anchor' ? `${c.id} har @ref-${node.id} på delen: ${node.id} bygger bare på den` : 'Regelen i kommentaren under taggen'} · ${partSt(pt)}`}>
            <span class="mono">→</span> <PartLink pt={pt} open={() => p.onOpen(pathOf(ix, c.id)!, pt.ln)} /> <span class="mono muted">{c.focus?.kind === 'anchor' ? '@ref-' : '«…»'}</span>
          </span>
        ))
      : [];
    out.push(
      <div
        key={key}
        role="treeitem"
        aria-level={c.level}
        aria-expanded={kids.length && !c.seenAt && !c.cycle ? !folded : undefined}
        tabIndex={0}
        class={'fl-trrow' + (p.isHl(c.id) ? ' hl' : '')}
        style={{ paddingLeft: x + 14 + 'px' }}
        {...p.hover(c.id)}
      >
        <span class="elbow" aria-hidden="true" style={{ left: x + 'px' }} />
        <span class="chev" onClick={() => p.setFold(o => ({ ...o, [key]: !o[key] }))}>
          {kids.length && !c.seenAt && !c.cycle ? (folded ? '▸' : '▾') : ''}
        </span>
        <div class="c">
          {c.cycle ? (
            <span class="err small">↺ {c.id} er allerede i kjeden. Treet stopper her.</span>
          ) : !ok ? (
            <span class="err small">
              <span class="mono">{c.id}</span> · Finnes ikke
            </span>
          ) : c.seenAt ? (
            <>
              <div class="line">
                <span class="mono">{c.id}</span>
                <a onClick={() => p.goSeen(c.seenAt!.phase, c.id)}>{c.seenAt.phase === pn ? 'se høyere i treet' : `se fase ${c.seenAt.phase}`}</a>
                <St c={st.c} l={st.l} />
              </div>
              {parts}
            </>
          ) : (
            <>
              <div class="line" onClick={() => p.openKrav(c.id, c.focus)}>
                <span class="mono">{c.id}</span>
                <span class="t">{titleOf(ix, c.id)}</span>
                <span class="fl-st right">
                  <Dot c={st.c} z={6} />
                  {st.l}
                  <span class="muted">· nivå {c.level}</span>
                  <Partial ix={ix} id={c.id} />
                </span>
              </div>
              {parts}
              {focus}
              {statusOf(ix, c.id) === 'deprecated' && <span class="warn small">Avviklet: {node.id} må peke på kravet som erstatter det.</span>}
            </>
          )}
        </div>
      </div>,
    );
    if (kids.length && !folded && !c.seenAt && !c.cycle) walkRows(p, c, pn, out);
  }
}

// Kravene i flyten -----------------------------------------------------------------------------

function KravTab(p: ViewProps & { tree: ReturnType<typeof flowTree>; list: FlatKrav[]; intro: string }) {
  const { ix, flow, list, sort } = p;
  // De andre flytene og kravene i dem, med alle nivåer
  const others = useMemo(() => ix.flows.filter(f => f !== flow).map(f => ({ title: f.title, seen: flowTree(ix, f, 'whole').seen })), [ix, flow]);
  const other = (id: string) =>
    others
      .filter(o => o.seen.has(id))
      .map(o => o.title)
      .join(', ') || '–';
  const ordOf = (id: string) => {
    const s = statusOf(ix, id);
    return s ? ORD[s] : -2;
  };
  const sorter = {
    level: (a: FlatKrav, b: FlatKrav) => a.level - b.level || a.id.localeCompare(b.id),
    status: (a: FlatKrav, b: FlatKrav) => ordOf(a.id) - ordOf(b.id) || a.level - b.level,
    domain: (a: FlatKrav, b: FlatKrav) => coll.compare(domainOf(ix, a.id), domainOf(ix, b.id)) || a.id.localeCompare(b.id),
  }[sort];
  const sorted = [...list].sort(sorter);
  const via = (k: FlatKrav) => [...k.via].map(v => (v === 'fasen' ? 'står på fasen' : v === 'flyten' ? 'står i flyten' : v)).join(', ');
  const groups = flow.overview
    ? [...new Set(flow.phases.flatMap(ph => ph.links.map(l => l.id)).filter(isFlowId))].map(g => ({
        title: titleOf(ix, g),
        sub: `${g} · fase ${flow.phases.filter(ph => ph.links.some(l => l.id === g)).map(ph => ph.n).join(', ')}`,
        rows: sorted.filter(k => k.group === g),
        empty: 'Velg 2 nivåer eller flere for å se kravene i flyten.',
      }))
    : [{ title: '', sub: '', rows: sorted, empty: 'Flyten bygger ikke på noen krav ennå.' }];
  return (
    <div class="fl-tab">
      <div class="fl-tabhead">
        <span>{p.intro}</span>
        <div class="fl-ctl right">
          <span>Sorter</span>
          <Seg
            label="Sorter"
            cur={sort}
            set={p.setSort}
            opts={[
              { v: 'level', l: 'Nivå' },
              { v: 'status', l: 'Status' },
              { v: 'domain', l: 'Domene' },
            ]}
          />
        </div>
      </div>
      {groups.map(g => (
        <div key={g.title} class="fl-group">
          {g.title && (
            <div class="fl-sechead">
              <b>{g.title}</b>
              <span class="mono">{g.sub}</span>
            </div>
          )}
          <div class="fl-table krav" role="table">
            <div role="row" class="hd mono">
              <span>STATUS</span>
              <span>KRAV</span>
              <span title={p.follow === 'part' ? 'Reglene og scenarioene flyten bygger på: ankrene, ellers reglene i «…», ellers reglene i kravet' : 'Reglene i kravet'}>{p.follow === 'part' ? 'FOR FLYTEN' : 'REGLER'}</span>
              <span title="Hele kravet">LEVERT</span>
              <span>NIVÅ</span>
              <span>FASER</span>
              <span>VIA</span>
              <span>ANDRE FLYTER</span>
              <span>DOMENE</span>
            </div>
            {g.rows.map(k => {
              const st = chip(ix, k.id);
              return (
                <div key={k.id} role="row" tabIndex={0} class={'tr' + (p.isHl(k.id) ? ' hl' : '')} onClick={() => p.openKrav(k.id)} {...p.hover(k.id)}>
                  <St c={st.c} l={st.l} />
                  <span class="k">
                    <span class="mono">{k.id}</span>
                    <span>{titleOf(ix, k.id)}</span>
                  </span>
                  <ForFlow ix={ix} k={k} follow={p.follow} onOpen={p.onOpen} />
                  <span class={'small' + (isPartial(ix.krav.get(k.id)!) ? ' partial' : '')}>{levert(ix, k.id) ?? '–'}</span>
                  <span class="mono">{k.level}</span>
                  <span>fase {[...k.phases].sort((a, b) => a - b).join(', ')}</span>
                  <span class="mono small">{via(k)}</span>
                  <span>{other(k.id)}</span>
                  <span class="mono muted small">{domainOf(ix, k.id)}</span>
                </div>
              );
            })}
            {!g.rows.length && <div class="fl-empty">{g.empty}</div>}
          </div>
        </div>
      ))}
    </div>
  );
}

/** Delene av kravet flyten bygger på, og hvor mange av dem som er levert. Med «Bare delen» står delene med status under */
function ForFlow({ ix, k, follow, onOpen }: { ix: FlowIndex; k: FlatKrav; follow: Follow; onOpen: (path: string, line?: number) => void }) {
  const pc = partCount([k]);
  const parts = [...k.parts.values()].sort((a, b) => a.ln - b.ln);
  const whole = parts.length === 1 && parts[0].part === 'feature';
  const unit = whole ? '' : follow === 'part' ? (pc.total === 1 ? ' del' : ' deler') : pc.total === 1 ? ' regel' : ' regler';
  return (
    <span class="k fl-forflow">
      <span class={'small' + (pc.done === pc.total ? ' partial' : '')}>{whole ? (pc.done ? 'hele kravet' : 'hele kravet, ikke levert') : `${pc.done} av ${pc.total}${unit}`}</span>
      {follow === 'part' &&
        !whole &&
        parts.map(pt => (
          <a
            key={pt.ln}
            class="small"
            title={`${pt.part === 'rule' ? 'Regel' : 'Scenario'}: ${pt.name} · ${pt.status === 'implemented' ? 'levert' : (pt.status ?? 'ingen status')} · fase ${[...pt.phases].sort((a, b) => a - b).join(', ')}`}
            onClick={e => {
              e.stopPropagation();
              onOpen(ix.krav.get(k.id)!.path, pt.ln);
            }}
          >
            <Dot c={stColor(pt.status)} z={6} />
            {pt.name}
          </a>
        ))}
    </span>
  );
}

// Per domene -----------------------------------------------------------------------------------

function statusBar(ix: FlowIndex, arr: FlatKrav[]) {
  const st: Record<string, number> = {};
  arr.forEach(k => {
    const s = statusOf(ix, k.id) ?? 'none';
    st[s] = (st[s] ?? 0) + 1;
  });
  return {
    bar: ORDER.filter(o => st[o]).map(o => ({ w: (st[o] / arr.length) * 100 + '%', c: o === 'none' ? 'var(--st-none)' : STC[o] })),
    text: [...ORDER.filter(o => st[o]).map(o => `${st[o]} ${o === 'none' ? 'ingen status' : o}`), ...(() => {
      const n = arr.filter(k => { const kr = ix.krav.get(k.id); return kr && isPartial(kr); }).length;
      return n ? [`${n} delvis levert`] : [];
    })()].join(' · '),
  };
}
/** Stolpen for delene i fasen, etter statusen på hver del */
function partBar(arr: FlatKrav[], phase: number) {
  const st: Record<string, number> = {};
  let n = 0;
  for (const k of arr)
    for (const pt of k.parts.values())
      if (pt.phases.has(phase)) {
        st[pt.status ?? 'none'] = (st[pt.status ?? 'none'] ?? 0) + 1;
        n++;
      }
  return ORDER.filter(o => st[o]).map(o => ({ w: (st[o] / n) * 100 + '%', c: o === 'none' ? 'var(--st-none)' : STC[o] }));
}
const Bar = ({ bar, h = 6, title }: { bar: { w: string; c: string }[]; h?: number; title?: string }) => (
  <span class="fl-bar" title={title} style={{ height: h + 'px' }}>
    {bar.map((b, i) => <span key={i} style={{ width: b.w, background: b.c }} />)}
  </span>
);

/** Kravene gruppert per domene og sub-domene, i sortert rekkefølge */
function byDomain(ix: FlowIndex, list: FlatKrav[]) {
  const m = new Map<string, Map<string, FlatKrav[]>>();
  for (const k of list) {
    const kr = ix.krav.get(k.id)!;
    if (!m.has(kr.domain)) m.set(kr.domain, new Map());
    const d = m.get(kr.domain)!;
    d.set(kr.sub, [...(d.get(kr.sub) ?? []), k]);
  }
  return [...m.entries()].sort((a, b) => coll.compare(a[0], b[0])).map(([dom, subs]) => ({ dom, subs: [...subs.entries()].sort((a, b) => coll.compare(a[0], b[0])) }));
}

function DomTab({ ix, list, follow, intro, onOpen }: { ix: FlowIndex; list: FlatKrav[]; follow: Follow; intro: string; onOpen: (path: string) => void }) {
  const groups = byDomain(ix, list);
  const agg = (arr: FlatKrav[]) => {
    const nr = arr.reduce((a, k) => a + (ix.krav.get(k.id)?.rules.length ?? 0), 0);
    // Delene flyten bygger på: også et scenario med ankeret som ikke står under en regel
    const pc = partCount(arr);
    const used = pc.total ? `${pc.total} ${follow === 'part' ? (pc.total === 1 ? 'del' : 'deler') : pc.total === 1 ? 'regel' : 'regler'} · ${pc.done} levert` : '–';
    const whole = follow === 'part' ? arr.filter(k => k.whole).length : 0;
    const ph = new Set(arr.flatMap(k => [...k.phases]));
    return {
      nK: arr.length,
      nR: nr,
      used,
      whole: whole ? (whole === 1 ? '1 krav følges helt' : `${whole} krav følges helt`) : '',
      ...statusBar(ix, arr),
      phases: ph.size ? 'fase ' + [...ph].sort((a, b) => a - b).join(', ') : '–',
    };
  };
  const nSub = groups.reduce((a, g) => a + g.subs.length, 0);
  const tot = agg(list);
  return (
    <div class="fl-tab">
      <span class="fl-intro">{intro}</span>
      <div class="fl-table dom" role="table">
        <div role="row" class="hd mono">
          <span>DOMENE / SUB-DOMENE</span>
          <span class="r">KRAV</span>
          <span class="r">REGLER</span>
          <span>{follow === 'part' ? 'DELER FLYTEN BYGGER PÅ' : 'REGLER FLYTEN BYGGER PÅ'}</span>
          <span>STATUS PÅ KRAVENE</span>
          <span>FASER</span>
        </div>
        {!list.length && <div class="fl-empty">Flyten bygger ikke på noen krav på dette nivået.</div>}
        {groups.map(({ dom, subs }) => {
          const a = agg(subs.flatMap(s => s[1]));
          return [
            <div key={dom} role="row" class="tr domrow">
              <span>
                <b>{dom}</b> <span class="mono muted small">{subs.length} sub-domener</span>
              </span>
              <span class="mono r bold">{a.nK}</span>
              <span class="mono r bold">{a.nR}</span>
              <span class="mono small">{a.used}</span>
              <Bar bar={a.bar} title={a.text} />
              <span>{a.phases}</span>
            </div>,
            ...subs.map(([sub, arr]) => {
              const s = agg(arr);
              const first = ix.krav.get(arr[0].id)!;
              return (
                <div key={dom + sub} role="row" tabIndex={0} class="tr subrow" onClick={() => onOpen(first.path)} title={`Åpne ${first.path} i Krav`}>
                  <span class="k">
                    <span>{sub}</span>
                    <span class="ids mono">{arr.map(k => <span key={k.id}>{k.id}</span>)}</span>
                  </span>
                  <span class="mono r">{s.nK}</span>
                  <span class="mono r">{s.nR}</span>
                  <span class="k">
                    <span class="mono small">{s.used}</span>
                    {s.whole && <span class="muted small">{s.whole}</span>}
                  </span>
                  <span class="k">
                    <Bar bar={s.bar} />
                    <span class="mono muted small">{s.text}</span>
                  </span>
                  <span>{s.phases}</span>
                </div>
              );
            }),
          ];
        })}
        {list.length > 0 && (
          <div role="row" class="tr sumrow">
            <span>
              Sum · {nSub} sub-domener i {groups.length} domene{groups.length > 1 ? 'r' : ''}
            </span>
            <span class="mono r bold">{tot.nK}</span>
            <span class="mono r bold">{tot.nR}</span>
            <span class="mono small">{tot.used}</span>
            <Bar bar={tot.bar} title={tot.text} />
            <span>{tot.phases}</span>
          </div>
        )}
      </div>
      <span class="muted small">
        {follow === 'part'
          ? '«Deler flyten bygger på» er reglene og scenarioene med ankeret (@ref- til flyten eller kravet over), ellers reglene i «…» i kommentaren under taggen. Et krav uten anker eller regel i «…» følges helt, og da teller alle reglene i kravet. «Levert» er delene som er levert.'
          : '«Regler flyten bygger på» er alle reglene i kravene, unntatt utkast og avviklede regler. «Levert» er reglene som er levert.'}
      </span>
    </div>
  );
}

// Matrise --------------------------------------------------------------------------------------

function MatrixTab({ ix, flow, list, toPhase, depth, follow }: { ix: FlowIndex; flow: Flow; list: FlatKrav[]; toPhase: (n: number) => void; depth: Depth; follow: Follow }) {
  // Enheten er kravet eller delene: et krav gjenstår i fasen til delen fasen bygger på, er levert (hele kravet med
  // «Følg: Hele kravet»), og en del (regel eller scenario) til den selv er levert
  const [unit, setUnit] = useState<'krav' | 'deler'>('krav');
  const unitT = unit === 'krav' ? 'krav' : follow === 'part' ? 'deler' : 'regler';
  const val = (arr: FlatKrav[], phase?: number) => (unit === 'krav' ? arr.length : partCount(arr, phase).total);
  const remOf = (arr: FlatKrav[], phase?: number) =>
    unit === 'krav' ? arr.filter(k => (phase === undefined ? k.open.size > 0 : k.open.has(phase))).length : partCount(arr, phase).open;
  const cellsFor = (arr: FlatKrav[]) =>
    flow.phases.map(ph => {
      const inP = arr.filter(k => k.phases.has(ph.n));
      return { tot: val(inP, ph.n), rem: remOf(inP, ph.n), inP, phase: ph.n };
    });
  const tip = (inP: FlatKrav[], phase: number) =>
    unit === 'krav'
      ? inP.map(k => `${k.id} ${statusOf(ix, k.id) ?? ''}${levert(ix, k.id) ? ` (levert: ${levert(ix, k.id)})` : ''}`).join('\n')
      : inP
          .flatMap(k =>
            [...k.parts.values()].filter(pt => pt.phases.has(phase)).map(pt => `${k.id} ${pt.part === 'feature' ? 'hele kravet' : (pt.part === 'rule' ? 'Regel: ' : 'Scenario: ') + pt.name} · ${pt.status === 'implemented' ? 'levert' : (pt.status ?? 'ingen status')}`),
          )
          .join('\n');
  const intro =
    unit === 'krav'
      ? `Hvor mange krav som gjenstår per sub-domene i hver fase, til ${depthText(depth)}${follow === 'part' ? ', bare delen fasen bygger på' : ''}. Tallet er kravene der ${follow === 'part' ? 'delen fasen bygger på' : 'hele kravet'} ikke er levert, av alle kravene sub-domenet leverer til fasen.`
      : follow === 'part'
        ? `Hvor mange deler som gjenstår per sub-domene i hver fase, til ${depthText(depth)}. En del er en regel eller et scenario fasen bygger på (ankeret, ellers regelen i «…»), eller reglene i kravet når fasen bygger på hele kravet. Tallet er delene som ikke er levert, av alle delene sub-domenet leverer til fasen.`
        : `Hvor mange regler som gjenstår per sub-domene i hver fase, til ${depthText(depth)}. Tallet er reglene i kravene som ikke er levert, av alle reglene (unntatt utkast og avviklede) sub-domenet leverer til fasen.`;
  const groups = byDomain(ix, list);
  const rows = groups.flatMap(({ dom, subs }) => [{ name: dom, isDom: true, arr: subs.flatMap(s => s[1]) }, ...subs.map(([sub, arr]) => ({ name: sub, isDom: false, arr }))]);
  let maxRem = 1;
  rows.forEach(r => !r.isDom && cellsFor(r.arr).forEach(c => (maxRem = Math.max(maxRem, c.rem))));
  const cols = `minmax(190px,1.6fr) repeat(${flow.phases.length}, minmax(84px,1fr)) 92px`;
  const cell = (c: { tot: number; rem: number; inP: FlatKrav[]; phase: number }, strong: boolean, key: number) => {
    if (!c.tot)
      return (
        <div key={key} role="cell" class="mxc" aria-label="ingen">
          <span class="dotempty">·</span>
        </div>
      );
    const done = c.rem === 0;
    const pct = Math.round(6 + (26 * Math.min(c.rem, maxRem)) / maxRem);
    return (
      <div
        key={key}
        role="cell"
        class="mxc"
        aria-label={done ? `alt levert, ${c.tot} ${unitT}` : `${c.rem} av ${c.tot} ${unitT} gjenstår`}
        title={tip(c.inP, c.phase)}
        style={{ background: done ? 'transparent' : `color-mix(in oklch, var(--warn) ${pct}%, var(--surface))` }}
      >
        <span class="v">
          <span class="mono" style={{ color: done ? 'var(--st-implemented)' : 'var(--ink)', fontWeight: strong ? 600 : 500 }}>
            {done ? '✓' : c.rem}
          </span>
          <span class="of">av {c.tot}</span>
        </span>
        <Bar bar={unit === 'krav' ? statusBar(ix, c.inP).bar : partBar(c.inP, c.phase)} h={4} />
      </div>
    );
  };
  const totRem = remOf(list);
  return (
    <div class="fl-tab">
      <div class="fl-tabhead">
        <span class="fl-intro">{intro}</span>
        <div class="fl-ctl right">
          <span>Tell</span>
          <Seg
            label="Tell"
            cur={unit}
            set={setUnit}
            opts={[
              { v: 'krav', l: 'Krav' },
              { v: 'deler', l: follow === 'part' ? 'Deler' : 'Regler', title: follow === 'part' ? 'Reglene og scenarioene fasene bygger på' : 'Reglene i kravene' },
            ]}
          />
        </div>
      </div>
      {list.length ? (
        <div class="fl-mxwrap">
          <div class="fl-mx" role="table" aria-label="Gjenstår per sub-domene og fase" style={{ minWidth: 190 + flow.phases.length * 84 + 92 + 'px' }}>
            <div role="row" class="hd" style={{ gridTemplateColumns: cols }}>
              <span role="columnheader" class="mono lbl">DOMENE / SUB-DOMENE</span>
              {flow.phases.map(ph => {
                const look = phaseLook(phaseStatus(ix, ph), flow.overview);
                return (
                  <button key={ph.n} role="columnheader" title={ph.title} onClick={() => toPhase(ph.n)}>
                    <span class="mono n">
                      <Dot c={look.c} fill={look.fill} dashed={look.dashed} />
                      Fase {ph.n}
                    </span>
                    <span class="t">{ph.title}</span>
                  </button>
                );
              })}
              <span role="columnheader" class="mono lbl last">GJENSTÅR</span>
            </div>
            {rows.map(r => {
              const tot = val(r.arr);
              const rem = remOf(r.arr);
              return (
                <div key={(r.isDom ? 'd:' : 's:') + r.name} role="row" class={'tr' + (r.isDom ? ' domrow' : '')} style={{ gridTemplateColumns: cols }}>
                  <span role="rowheader" class="rh" style={{ paddingLeft: r.isDom ? '14px' : '28px', fontWeight: r.isDom ? 600 : 500 }}>
                    {r.name}
                  </span>
                  {cellsFor(r.arr).map((c, i) => cell(c, r.isDom, i))}
                  <div role="cell" class="mxc last">
                    <span class="v">
                      <span class="mono bold" style={{ color: rem ? 'var(--ink)' : 'var(--st-implemented)' }}>
                        {rem || '✓'}
                      </span>
                      <span class="of">av {tot}</span>
                    </span>
                  </div>
                </div>
              );
            })}
            <div role="row" class="tr foot" style={{ gridTemplateColumns: cols }}>
              <span role="rowheader" class="rh">Gjenstår per fase</span>
              {flow.phases.map(ph => {
                const inP = list.filter(k => k.phases.has(ph.n));
                const tot = val(inP, ph.n);
                const rem = remOf(inP, ph.n);
                return (
                  <div key={ph.n} role="cell" class="mxc">
                    {!ph.links.length ? (
                      <span class="fl-kind mono dashed">mangler</span>
                    ) : !tot ? (
                      <span class="muted small">ikke på nivået</span>
                    ) : (
                      <>
                        <span class="v">
                          <span class="mono bold" style={{ color: rem ? 'var(--ink)' : 'var(--st-implemented)' }}>
                            {rem || '✓'}
                          </span>
                          <span class="of">av {tot}</span>
                        </span>
                        <span class="muted small">{new Set(inP.map(k => domainOf(ix, k.id))).size} sub-dom.</span>
                      </>
                    )}
                  </div>
                );
              })}
              <div role="cell" class="mxc last">
                <span class="v">
                  <span class="mono bold">{totRem || '✓'}</span>
                  <span class="of">av {val(list)}</span>
                </span>
              </div>
            </div>
          </div>
        </div>
      ) : (
        <div class="fl-emptybox">{flow.overview ? 'Velg 2 nivåer eller flere for å se kravene i flytene.' : 'Flyten bygger ikke på noen krav ennå.'}</div>
      )}
      <div class="fl-mxlegend">
        <span>
          <span class="sw" style={{ background: 'color-mix(in oklch, var(--warn) 32%, var(--surface))' }} />
          mest som gjenstår
        </span>
        <span>
          <span class="sw" style={{ background: 'color-mix(in oklch, var(--warn) 8%, var(--surface))' }} />
          lite
        </span>
        <span>
          <span class="mono" style={{ color: 'var(--st-implemented)' }}>✓</span>alt levert
        </span>
        <span>
          {unit === 'krav'
            ? `Et krav gjenstår til ${follow === 'part' ? 'delen fasen bygger på' : 'hele kravet'} er levert. Gjenstår-kolonnen teller hvert krav én gang, selv om det er med i flere faser. Hold over en celle for å se kravene.`
            : `En ${follow === 'part' ? 'del' : 'regel'} gjenstår til den selv er levert. Gjenstår-kolonnen teller hver ${follow === 'part' ? 'del' : 'regel'} én gang, selv om den er med i flere faser. Hold over en celle for å se ${follow === 'part' ? 'delene' : 'reglene'}.`}
        </span>
      </div>
    </div>
  );
}
