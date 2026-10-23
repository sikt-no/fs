// Flytene i krav/_Flyter og relasjonene deres: fasene, kravene hver fase bygger på (@depends-on-),
// og kjeden av @depends-on- videre fra kravene. Rene funksjoner over snapshotet, testet i flows.test.ts.
import type { FeatureModel, Note, Snapshot, Status } from '../shared/model';

export const FLOW_ROOT = 'krav/_Flyter/';
const DEP = '@depends-on-';
const REF = '@ref-';
const ID = /^@([A-ZÆØÅ]+-[A-ZÆØÅ]+-[A-ZÆØÅ]+-\d{3})$/;

/** Rekkefølgen på statusene for «laveste status». `@deprecated` er lavest, en ID som ikke finnes er under alle */
export const ORD: Record<Status, number> = { deprecated: -1, draft: 0, planned: 1, 'in-progress': 2, implemented: 3 };
const ord = (s: Status | null) => (s ? ORD[s] : -2);

/** En @depends-on- i et vanlig krav, og hvor den står */
export interface KravDep {
  id: string;
  part: 'feature' | 'rule' | 'scenario';
  /** Regel- eller scenariotittelen, `null` for hele kravet */
  partName: string | null;
  /** Regelen delen hører til (for et scenario: regelen over), `null` for hele kravet */
  rule: string | null;
  ln: number;
  /** Regeltitlene i kravet det pekes på, fra «…» i kommentaren under taggen */
  notes: string[];
}

/** En regel eller et scenario med `@ref-<A>`: A bygger bare på denne delen når A har `@depends-on-` til kravet (*Anker*) */
export interface Anchor {
  part: 'rule' | 'scenario';
  /** Regel- eller scenariotittelen */
  name: string;
  /** Regelen delen hører til (for et scenario: regelen over) */
  rule: string | null;
  ln: number;
}

/**
 * Delen av kravet som følges: ankrene (de innenfor reglene i «…» når det står regler der), reglene fra kommentaren
 * under taggen, eller hele kravet (`null`)
 */
export type Focus = { kind: 'anchor'; parts: Anchor[] } | { kind: 'note'; rules: string[] } | null;

/** Hva som er levert av kravet: reglene og scenarioene som er med (ikke `@draft`, `@deprecated` eller `@demo`) */
export interface Delivery {
  rules: number;
  rulesDone: number;
  scen: number;
  scenDone: number;
}

export interface Krav {
  id: string;
  path: string;
  title: string;
  status: Status | null;
  /**
   * Reglene i kravet, og om regelen er levert (`null`: ikke med, fordi den er `@draft`, `@deprecated` eller `@demo`).
   * `status` er statusen delen har (`partStatus`)
   */
  rules: { name: string; ln: number; done: boolean | null; status: Status | null }[];
  /** Scenarioene i kravet, med regelen over og statusen delen har */
  scenarios: { name: string; rule: string | null; ln: number; status: Status | null }[];
  delivery: Delivery;
  /** `02 Opptak` og `13 Søknad og saksbehandling` fra stien */
  domain: string;
  sub: string;
  deps: KravDep[];
  /** ID-en i `@ref-` på en regel eller et scenario → delene med den taggen (ankrene) */
  anchors: Map<string, Anchor[]>;
}

export interface PhaseLink {
  id: string;
  /** Regeltitlene i kravet fra «…» i kommentaren under taggen */
  notes: string[];
  /** Delen av kravet fasen bygger på (`focusOf`): avgjør når fasen er levert */
  focus: Focus;
}

export interface Handover {
  name: string;
  ln: number;
  steps: { kw: string; text: string }[];
  openQuestion: boolean;
}

export interface FlowPhase {
  n: number;
  title: string;
  ln: number;
  /** `@depends-on-` på fasen: kravene (eller flytene) fasen bygger på */
  links: PhaseLink[];
  /** `@ref-` på fasen: henvisninger, ikke avhengigheter */
  refs: string[];
  /** Spørsmålene fra `# ÅPNE SPØRSMÅL:` på fasen og scenarioene i den */
  questions: string[];
  handovers: Handover[];
}

export interface Flow {
  path: string;
  id: string;
  title: string;
  file: string;
  /** Prosessmappa, f.eks. `10 Opptaksløpet` */
  process: string;
  /** Oversiktsflyten for prosessen: ID-en er `FLY-<p>-<p>-001` */
  overview: boolean;
  status: Status | null;
  prio: string | null;
  tags: string[];
  /** Beskrivelsen, ett avsnitt per element */
  desc: string[];
  knownBreaks: string[];
  phases: FlowPhase[];
  /** Parse-feilen når fila ikke kan leses (visningen viser sist gyldige versjon) */
  error: string | null;
}

export interface FlowIndex {
  flows: Flow[];
  byId: Map<string, Flow>;
  /** Kravene utenfor _Flyter, på Feature-ID */
  krav: Map<string, Krav>;
  byProcess: [string, Flow[]][];
  /** Flyt-ID → oversiktsflytene (og fasen) som bygger på den */
  usedBy: Map<string, { flow: string; phase: number }[]>;
  /** Krav-ID → flytene og fasene som bygger direkte på kravet */
  through: Map<string, { flow: string; phase: number }[]>;
}

export const isFlowId = (id: string) => id.startsWith('FLY-');

/** Tekstene i «…» i kommentarene som står før `before` (mellom taggen og nøkkelordet) */
function quotes(notes: Note[], before: number): string[] {
  const text = notes.filter(n => n.kind === 'note' && n.ln < before).map(n => n.items.map(i => i.text).join(' ')).join(' ');
  return [...text.matchAll(/«([^»]+)»/g)].map(m => m[1].trim());
}

const has = (tags: string[], t: string) => tags.includes('@' + t);
const left = (tags: string[]) => has(tags, 'draft') || has(tags, 'deprecated') || has(tags, 'demo');

/**
 * Det som er levert av kravet, regel for regel og scenario for scenario (*Delvis levert* og *Endring av levert krav*
 * i krav/README.md). Er egenskapen `@implemented`, er alt levert unntatt delene som er `@planned` eller `@in-progress`.
 * Er den `@in-progress`, er bare delene som er tagget `@implemented` levert (taggen på en regel gjelder scenarioene i
 * den). Ellers er ingenting levert. En regel er levert når alle scenarioene i den er det; en regel uten scenarioer
 * når den selv er det.
 *
 * Statusen på en del er `implemented` når delen er levert, ellers statustaggen på delen (`@draft`, `@deprecated`,
 * `@planned`, `@in-progress`), ellers statusen på egenskapen. En `@demo`-del har ingen status. En regel med
 * scenarioer har den laveste statusen blant dem.
 */
export function deliveryOf(status: Status | null, m: FeatureModel): { rules: Krav['rules']; scenarios: Krav['scenarios']; delivery: Delivery } {
  const d: Delivery = { rules: 0, rulesDone: 0, scen: 0, scenDone: 0 };
  const rules: Krav['rules'] = [];
  const scenarios: Krav['scenarios'] = [];
  const open = (tags: string[]) => has(tags, 'planned') || has(tags, 'in-progress');
  const done = (tags: string[]) => (status === 'implemented' ? !open(tags) : status === 'in-progress' ? has(tags, 'implemented') : false);
  const partSt = (tags: string[]): Status | null =>
    status === 'deprecated' || has(tags, 'deprecated') ? 'deprecated'
    : has(tags, 'draft') ? 'draft'
    : has(tags, 'demo') ? null
    : done(tags) ? 'implemented'
    : has(tags, 'in-progress') ? 'in-progress'
    : has(tags, 'planned') ? 'planned'
    : status;
  for (const r of m.rules) {
    const out = status === 'deprecated' || left(r.tags);
    const all = r.scenarios.filter(sc => sc.kind !== 'Bakgrunn');
    for (const sc of all) scenarios.push({ name: sc.name, rule: r.name, ln: sc.ln, status: partSt([...r.tags, ...sc.tags]) });
    const scs = out ? [] : all.filter(sc => !left(sc.tags));
    const scDone = scs.filter(sc => done([...r.tags, ...sc.tags])).length;
    d.scen += scs.length;
    d.scenDone += scDone;
    if (r.name === null) continue;
    const ruleDone = out ? null : scs.length ? scDone === scs.length : done(r.tags);
    const ruleSt = out || !scs.length ? partSt(r.tags) : lowest(scs.map(sc => partSt([...r.tags, ...sc.tags])));
    rules.push({ name: r.name, ln: r.ln, done: ruleDone, status: ruleSt });
    if (ruleDone !== null) {
      d.rules++;
      if (ruleDone) d.rulesDone++;
    }
  }
  return { rules, scenarios, delivery: d };
}

/** Den laveste statusen. Deler uten status (`@demo`) telles ikke, og uten noen status er svaret `null` */
function lowest(sts: (Status | null | undefined)[]): Status | null {
  const known = sts.filter((s): s is Status => s != null);
  return known.length ? known.reduce((a, b) => (ORD[b] < ORD[a] ? b : a)) : null;
}

/** Kravet er ikke levert som helhet, men noen regler eller scenarioer er det */
export const isPartial = (k: Krav) => k.status !== 'implemented' && (k.delivery.rulesDone > 0 || k.delivery.scenDone > 0);

const tagIds = (tags: string[], prefix: string) => tags.filter(t => t.startsWith(prefix)).map(t => t.slice(prefix.length));
const featureId = (tags: string[]) => tags.map(t => ID.exec(t)?.[1]).find(Boolean) ?? null;
const PRIO = ['must', 'should', 'could', 'wont'];

export function buildFlows(entries: Snapshot): FlowIndex {
  const krav = new Map<string, Krav>();
  const pending: { k: Krav; dep: KravDep; quoted: string[] }[] = [];
  const flows: Flow[] = [];

  for (const e of Object.values(entries)) {
    if (e.kind !== 'feature' || !e.model || !e.path.startsWith('krav/')) continue;
    const m = e.model;
    const id = featureId(m.tags);
    if (!id) continue;
    const seg = e.path.split('/');

    if (e.path.startsWith(FLOW_ROOT)) {
      const [, p2, p3] = id.split('-');
      const breaks = m.notes.flatMap(n =>
        n.head && /^kjent brudd$/i.test(n.head.trim()) ? n.items.map(i => i.text) : n.items.map(i => i.text).filter(t => /^kjent brudd:/i.test(t)).map(t => t.replace(/^kjent brudd:\s*/i, '')),
      );
      const desc: string[] = [];
      let par = '';
      for (const d of m.desc) {
        const t = [d.lead, d.rest].filter(Boolean).join(' ').trim();
        if (!t) {
          if (par) desc.push(par);
          par = '';
        } else par = par ? par + ' ' + t : t;
      }
      if (par) desc.push(par);
      const phases: FlowPhase[] = [];
      for (const r of m.rules) {
        if (r.name === null) continue;
        const quoted = quotes(r.notes, r.ln);
        phases.push({
          n: phases.length + 1,
          title: r.name,
          ln: r.ln,
          links: tagIds(r.tags, DEP).map(t => ({ id: t, notes: [], focus: null, quoted }) as PhaseLink & { quoted: string[] }),
          refs: tagIds(r.tags, REF),
          questions: [...r.notes, ...r.scenarios.flatMap(s => [...s.notes, ...s.steps.flatMap(st => st.notes ?? [])])].filter(n => n.kind === 'question').flatMap(n => n.items.map(i => i.text)),
          handovers: r.scenarios.map(s => ({ name: s.name, ln: s.ln, steps: s.steps.map(st => ({ kw: st.kw.trim(), text: st.text })), openQuestion: s.tags.includes('@openquestion') })),
        });
      }
      flows.push({
        path: e.path,
        id,
        title: m.title,
        file: seg[seg.length - 1],
        process: seg[2] ?? '',
        overview: !!p2 && p2 === p3,
        status: e.status,
        prio: m.tags.map(t => t.slice(1)).find(t => PRIO.includes(t)) ?? null,
        tags: m.tags,
        desc,
        knownBreaks: breaks,
        phases,
        error: e.error ?? null,
      });
      continue;
    }

    const k: Krav = {
      id,
      path: e.path,
      title: m.title,
      status: e.status,
      ...deliveryOf(e.status, m),
      domain: seg[1] ?? '',
      sub: seg[2] ?? '',
      deps: [],
      anchors: new Map(),
    };
    const add = (tags: string[], dep: Omit<KravDep, 'id' | 'notes'>, quoted: string[]) => {
      for (const t of tagIds(tags, DEP)) {
        const d: KravDep = { ...dep, id: t, notes: [] };
        k.deps.push(d);
        pending.push({ k, dep: d, quoted });
      }
    };
    // @ref- på Egenskap: betyr hele kravet, og er ikke et anker
    const anchor = (tags: string[], a: Anchor) => {
      for (const t of tagIds(tags, REF)) k.anchors.set(t, [...(k.anchors.get(t) ?? []), a]);
    };
    add(m.tags, { part: 'feature', partName: null, rule: null, ln: m.ln }, quotes(m.notes, m.ln));
    for (const r of m.rules) {
      if (r.name !== null) {
        add(r.tags, { part: 'rule', partName: r.name, rule: r.name, ln: r.ln }, quotes(r.notes, r.ln));
        anchor(r.tags, { part: 'rule', name: r.name, rule: r.name, ln: r.ln });
      }
      for (const s of r.scenarios) {
        add(s.tags, { part: 'scenario', partName: s.name, rule: r.name, ln: s.ln }, quotes(s.notes, s.ln));
        if (s.kind !== 'Bakgrunn') anchor(s.tags, { part: 'scenario', name: s.name, rule: r.name, ln: s.ln });
      }
    }
    if (!krav.has(id)) krav.set(id, k);
  }

  // Kommentaren under taggen gjelder reglene i kravet det pekes på, når tekstene i «…» er regeltitler der
  const rulesIn = (target: string, quoted: string[]) => {
    const t = krav.get(target);
    return t ? [...new Set(quoted.filter(q => t.rules.some(r => r.name === q)))] : [];
  };
  for (const p of pending) p.dep.notes = rulesIn(p.dep.id, p.quoted);
  for (const f of flows)
    for (const ph of f.phases)
      ph.links = ph.links.map(l => {
        const { quoted, ...rest } = l as PhaseLink & { quoted: string[] };
        const notes = rulesIn(l.id, quoted);
        return { ...rest, notes, focus: focusIn(krav, l.id, f.id, notes) };
      });

  const coll = new Intl.Collator('nb', { numeric: true });
  flows.sort((a, b) => coll.compare(a.process, b.process) || Number(b.overview) - Number(a.overview) || coll.compare(a.title, b.title));
  const byId = new Map(flows.map(f => [f.id, f]));
  const groups = new Map<string, Flow[]>();
  for (const f of flows) groups.set(f.process, [...(groups.get(f.process) ?? []), f]);
  const usedBy = new Map<string, { flow: string; phase: number }[]>();
  const through = new Map<string, { flow: string; phase: number }[]>();
  for (const f of flows)
    for (const ph of f.phases)
      for (const l of ph.links) {
        const m = isFlowId(l.id) ? usedBy : through;
        m.set(l.id, [...(m.get(l.id) ?? []), { flow: f.id, phase: ph.n }]);
      }
  return { flows, byId, krav, byProcess: [...groups.entries()], usedBy, through };
}

export const statusOf = (ix: FlowIndex, id: string): Status | null => (isFlowId(id) ? ix.byId.get(id)?.status : ix.krav.get(id)?.status) ?? null;
export const exists = (ix: FlowIndex, id: string) => (isFlowId(id) ? ix.byId.has(id) : ix.krav.has(id));
export const titleOf = (ix: FlowIndex, id: string) => (isFlowId(id) ? ix.byId.get(id)?.title : ix.krav.get(id)?.title) ?? '';
export const pathOf = (ix: FlowIndex, id: string) => (isFlowId(id) ? ix.byId.get(id)?.path : ix.krav.get(id)?.path) ?? null;
/** `02 Opptak › 13 Søknad og saksbehandling`, eller `flyt` */
export const domainOf = (ix: FlowIndex, id: string) => {
  const k = ix.krav.get(id);
  return isFlowId(id) ? 'flyt' : k ? `${k.domain} › ${k.sub}` : '';
};

/**
 * Statusen på delen av kravet som følges (`focus`): den laveste statusen blant ankrene eller reglene i «…»,
 * eller statusen på kravet når hele kravet følges (og for en flyt). Er delen levert, er den `implemented`, også når
 * resten av kravet ikke er det (*Anker* i krav/README.md)
 */
export function partStatus(ix: FlowIndex, id: string, focus: Focus): Status | null {
  const k = ix.krav.get(id);
  if (!k || !focus) return statusOf(ix, id);
  const sts =
    focus.kind === 'note'
      ? focus.rules.map(n => k.rules.find(r => r.name === n)?.status)
      : focus.parts.map(a => (a.part === 'rule' ? k.rules.find(r => r.ln === a.ln) : k.scenarios.find(s => s.ln === a.ln))?.status);
  return sts.some(s => s != null) ? lowest(sts) : k.status;
}

/** Fasen er levert når delen av hvert krav den bygger på, er levert, og flytene den bygger på, er `@implemented` (som fremdriften i fs-verify) */
export const delivered = (ix: FlowIndex, p: FlowPhase) => p.links.length > 0 && p.links.every(l => partStatus(ix, l.id, l.focus) === 'implemented');

export type PhaseStatus = Status | 'missing' | 'broken';
/** Levert, den laveste statusen blant delene fasen bygger på, `broken` når en ID ikke finnes, og `missing` uten krav */
export function phaseStatus(ix: FlowIndex, p: FlowPhase): PhaseStatus {
  if (!p.links.length) return 'missing';
  if (delivered(ix, p)) return 'implemented';
  let low: Status | null = null;
  let first = true;
  for (const l of p.links) {
    const s = partStatus(ix, l.id, l.focus);
    if (!exists(ix, l.id)) return 'broken';
    if (first || ord(s) < ord(low)) low = s;
    first = false;
  }
  return low ?? 'broken';
}

export function progress(ix: FlowIndex, f: Flow) {
  const d = f.phases.filter(p => delivered(ix, p)).length;
  return { delivered: d, total: f.phases.length, missing: f.phases.filter(p => !p.links.length).length };
}

// Avhengighetstreet -----------------------------------------------------------------------------

export type Follow = 'part' | 'whole';
export interface Part {
  k: string;
  t: string;
}

export interface DepNode {
  id: string;
  level: number;
  /** Fasen treet står under */
  phase: number;
  /** Regeltitlene i «…» i kommentaren under taggen, de som er regler i kravet */
  notes: string[];
  /** Delen av kravet som følges fra kravet (eller flyten) over: ankrene (innenfor reglene i `notes`), ellers reglene i `notes` */
  focus: Focus;
  /** Hvor taggen står i kravet over: hele kravet, en regel eller et scenario (fasene for en flyt) */
  parts: Part[] | null;
  /** Linja i kravet over der taggen står (for å åpne den) */
  parentLn: number | null;
  children: DepNode[];
  /** Kravet er vist før, på dette stedet: vis som lenke, ikke tre */
  seenAt: { phase: number; level: number } | null;
  /** Kjeden peker tilbake hit: stopp */
  cycle: boolean;
  chain: string[];
  parent: DepNode | null;
}

export interface FlowTree {
  roots: DepNode[][];
  /** Hva som følges: avgjør om statusen er delen eller hele kravet (`nodeStatus`) */
  follow: Follow;
  seen: Map<string, { phase: number; level: number }>;
  /** Det dypeste nivået */
  max: number;
}

/**
 * Delen av kravet `id` som `from` (kravet eller flyten over) bygger på: delene i kravet med `@ref-<from>` (ankeret),
 * ellers reglene i kommentaren under taggen, ellers hele kravet. Står det både anker og regler i «…», er delen
 * ankrene innenfor de reglene (et scenario hører til regelen over), så flere faser eller deler som bygger på samme
 * krav, kan skilles. Ligger ingen av ankrene i reglene, gjelder alle ankrene. Noden nås bare gjennom en
 * `@depends-on-`, så `@ref-` på delen er alltid et anker her
 */
export const focusOf = (ix: FlowIndex, id: string, from: string | null, notes: string[]): Focus => focusIn(ix.krav, id, from, notes);

function focusIn(krav: Map<string, Krav>, id: string, from: string | null, notes: string[]): Focus {
  const k = krav.get(id);
  if (!k) return null;
  const rules = notes.filter(n => k.rules.some(r => r.name === n));
  const parts = from ? k.anchors.get(from) : undefined;
  if (parts?.length) {
    const inside = parts.filter(a => a.rule !== null && rules.includes(a.rule));
    return { kind: 'anchor', parts: inside.length ? inside : parts };
  }
  return rules.length ? { kind: 'note', rules } : null;
}

/** `@depends-on-` på en regel gjelder scenarioene i den, så et scenario følger også taggene på regelen over */
const inFocus = (f: NonNullable<Focus>, d: KravDep) =>
  f.kind === 'note' ? d.rule !== null && f.rules.includes(d.rule) : f.parts.some(a => (a.part === 'rule' ? d.rule === a.name : d.rule === a.rule && (d.part === 'rule' || d.partName === a.name)));

/** Linja i kravet der delen som følges, står */
export const focusLn = (ix: FlowIndex, id: string, f: Focus) => (f?.kind === 'anchor' ? f.parts[0].ln : f?.kind === 'note' ? ix.krav.get(id)?.rules.find(r => r.name === f.rules[0])?.ln : undefined);

/** Delene som følges, som tekst: `Regel: …` og `Scenario: …` */
export const focusParts = (f: Focus): Part[] =>
  f?.kind === 'anchor' ? f.parts.map(a => ({ k: a.part === 'rule' ? 'Regel' : 'Scenario', t: a.name })) : f?.kind === 'note' ? f.rules.map(t => ({ k: 'Regel', t })) : [];

/** Det et krav eller en flyt bygger på, gruppert per ID. Med `follow: 'part'` følges bare delen i `focus` og `Egenskap:` */
export function depsOf(ix: FlowIndex, id: string, focus: Focus, follow: Follow) {
  const out = new Map<string, { id: string; parts: Part[]; notes: string[]; ln: number }>();
  if (isFlowId(id)) {
    for (const p of ix.byId.get(id)?.phases ?? [])
      for (const l of p.links) {
        const o = out.get(l.id) ?? { id: l.id, parts: [{ k: 'Fase', t: '' }], notes: l.notes, ln: p.ln };
        o.parts[0].t = o.parts[0].t ? `${o.parts[0].t}, ${p.n}` : String(p.n);
        out.set(l.id, o);
      }
    return [...out.values()];
  }
  const k = ix.krav.get(id);
  if (!k) return [];
  const only = follow === 'part' ? focus : null;
  for (const d of k.deps) {
    if (only && d.part !== 'feature' && !inFocus(only, d)) continue;
    const o = out.get(d.id) ?? { id: d.id, parts: [], notes: [], ln: d.ln };
    o.parts.push(d.part === 'feature' ? { k: 'Hele kravet', t: '' } : { k: d.part === 'rule' ? 'Regel' : 'Scenario', t: d.partName ?? '' });
    for (const n of d.notes) if (!o.notes.includes(n)) o.notes.push(n);
    out.set(d.id, o);
  }
  return [...out.values()];
}

const MAX_LEVEL = 50;

/**
 * Treet bygges bredde først, så hvert krav får det laveste nivået det finnes på. Et krav som er fulgt før, vises
 * som lenke (`seenAt`). Med `follow: 'part'` følges et krav på nytt for en annen del, eller helt, hvis det bare
 * er fulgt for én del før: det er ulike avhengigheter.
 */
export function flowTree(ix: FlowIndex, f: Flow, follow: Follow): FlowTree {
  const seen = new Map<string, { phase: number; level: number }>();
  const followed = new Set<string>();
  const scope = (fc: Focus) => (follow === 'whole' || !fc ? '*' : fc.kind === 'note' ? 'r:' + fc.rules.join('|') : 'a:' + fc.parts.map(a => a.ln).join(','));
  const node = (id: string, level: number, phase: number, notes: string[], parent: DepNode | null, parts: Part[] | null, parentLn: number | null): DepNode => ({
    id, level, phase, notes, focus: focusOf(ix, id, parent?.id ?? f.id, notes), parts, parentLn, children: [], seenAt: null, cycle: false, chain: [...(parent?.chain ?? []), id], parent,
  });
  // Følger noden videre, eller merker den som vist før
  const place = (n: DepNode, into: DepNode[]) => {
    const sc = scope(n.focus);
    if (followed.has(n.id + '|*') || followed.has(n.id + '|' + sc)) n.seenAt = seen.get(n.id)!;
    else {
      followed.add(n.id + '|' + sc);
      if (!seen.has(n.id)) seen.set(n.id, { phase: n.phase, level: n.level });
      into.push(n);
    }
  };
  let frontier: DepNode[] = [];
  const roots = f.phases.map(p =>
    p.links.map(l => {
      const n = node(l.id, 1, p.n, l.notes, null, null, p.ln);
      place(n, frontier);
      return n;
    }),
  );
  let lvl = 1;
  while (frontier.length && lvl < MAX_LEVEL) {
    lvl++;
    const next: DepNode[] = [];
    for (const n of frontier)
      for (const d of depsOf(ix, n.id, n.focus, follow)) {
        const c = node(d.id, lvl, n.phase, d.notes, n, d.parts, d.ln);
        if (n.chain.includes(d.id) || d.id === f.id) c.cycle = true;
        else place(c, next);
        n.children.push(c);
      }
    frontier = next;
  }
  let max = 1;
  seen.forEach(v => (max = Math.max(max, v.level)));
  return { roots, follow, seen, max };
}

/** Alle nodene til og med `depth`, også dem som er vist før */
export function nodesTo(t: FlowTree, depth: number): DepNode[] {
  const out: DepNode[] = [];
  const walk = (n: DepNode) => {
    if (n.level > depth) return;
    out.push(n);
    n.children.forEach(walk);
  };
  t.roots.forEach(a => a.forEach(walk));
  return out;
}

/** Antall krav og flyter som finnes, til og med `depth` */
export function countTo(ix: FlowIndex, t: FlowTree, depth: number) {
  let k = 0;
  let fl = 0;
  t.seen.forEach((v, id) => {
    if (v.level <= depth && exists(ix, id)) {
      if (isFlowId(id)) fl++;
      else k++;
    }
  });
  return { krav: k, flows: fl };
}

/**
 * Advarselen på fasen: et krav lenger ned i kjeden har lavere status enn kravet over. `level` er nivået til kravet,
 * og finnes det ingen innenfor `depth`, letes det i hele kjeden (visningen tilbyr da å vise flere nivåer)
 */
export function chainBehind(ix: FlowIndex, roots: DepNode[], depth: number): { status: Status; level: number } | null {
  const all: DepNode[] = [];
  const walk = (n: DepNode) => {
    all.push(n);
    n.children.forEach(walk);
  };
  roots.forEach(walk);
  const inDepth = all.filter(n => n.level <= depth);
  for (const pool of [inDepth, all])
    for (const n of pool) {
      if (!n.parent || n.seenAt || n.cycle) continue;
      const a = statusOf(ix, n.id);
      const b = statusOf(ix, n.parent.id);
      if (a && b && ORD[a] < ORD[b]) return { status: a, level: n.level };
    }
  return null;
}

/** Statusen på noden: delen som følges med `follow: 'part'`, ellers hele kravet */
export const nodeStatus = (ix: FlowIndex, n: DepNode, follow: Follow) => (follow === 'part' ? partStatus(ix, n.id, n.focus) : statusOf(ix, n.id));

/** Den laveste statusen i kjeden til og med `depth`, og hvor den er. Med `follow: 'part'` er det statusen på delen som følges */
export function chainLow(ix: FlowIndex, t: FlowTree, depth: number): { status: Status | null; at: DepNode } | null {
  let low: { status: Status | null; at: DepNode } | null = null;
  for (const n of nodesTo(t, depth)) {
    if (n.cycle || !exists(ix, n.id)) continue;
    const s = nodeStatus(ix, n, t.follow);
    if (!low || ord(s) < ord(low.status)) low = { status: s, at: n };
  }
  return low;
}

// Kravene i flyten ------------------------------------------------------------------------------

/** En del av et krav flyten bygger på: en regel eller et scenario, eller kravet selv når det ikke har regler */
export interface FlowPart {
  part: 'feature' | 'rule' | 'scenario';
  name: string;
  /** Regelen delen hører til (for et scenario: regelen over) */
  rule: string | null;
  /** Linja i kravet (0 for kravet selv) */
  ln: number;
  /** Statusen delen har (`implemented` når den er levert, se `deliveryOf`) */
  status: Status | null;
}

/**
 * Delene av kravet som følges: ankrene, reglene i «…», eller, uten `focus`, reglene i kravet som er med (ikke
 * `@draft`, `@deprecated` eller `@demo`). Et krav uten slike regler er én del, med statusen på kravet
 */
export function partsOf(ix: FlowIndex, id: string, focus: Focus): FlowPart[] {
  const k = ix.krav.get(id);
  if (!k) return [];
  const rule = (name: string) => k.rules.find(r => r.name === name);
  if (focus?.kind === 'anchor')
    return focus.parts.map(a => ({ ...a, status: (a.part === 'rule' ? k.rules.find(r => r.ln === a.ln) : k.scenarios.find(s => s.ln === a.ln))?.status ?? null }));
  if (focus?.kind === 'note') return focus.rules.flatMap(n => (rule(n) ? [{ part: 'rule' as const, name: n, rule: n, ln: rule(n)!.ln, status: rule(n)!.status }] : []));
  const rules = k.rules.filter(r => r.done !== null).map(r => ({ part: 'rule' as const, name: r.name, rule: r.name, ln: r.ln, status: r.status }));
  return rules.length ? rules : [{ part: 'feature', name: k.title, rule: null, ln: 0, status: k.status }];
}

export interface FlatKrav {
  id: string;
  /** Nivået kravet først dukker opp på */
  level: number;
  phases: Set<number>;
  /** Kravet det kommer via, eller `fasen` / `flyten` når det står på fasen */
  via: Set<string>;
  /** Flyten kravet hører til (i en oversiktsflyt: flyten fasen peker på) */
  group: string;
  /** Reglene i kravet som flyten bygger på: fra ankrene (for et scenario: regelen over), ellers fra kommentaren under taggen */
  rules: Set<string>;
  /** Minst én referanse til kravet sier ikke hvilken regel den gjelder */
  whole: boolean;
  /** Fasene der delen som følges (eller hele kravet, med `follow: 'whole'`), ikke er levert: kravet gjenstår der */
  open: Set<number>;
  /**
   * Delene flyten bygger på, på linja i kravet, med fasene de er med i: delen som følges med `follow: 'part'`
   * (`partsOf`), og reglene i kravet med `follow: 'whole'`
   */
  parts: Map<number, FlowPart & { phases: Set<number> }>;
}

/** Delene i `list` flyten bygger på, og hvor mange av dem som er levert. Med `phase` bare delene i den fasen */
export function partCount(list: FlatKrav[], phase?: number) {
  let total = 0;
  let done = 0;
  for (const k of list)
    for (const pt of k.parts.values())
      if (phase === undefined || pt.phases.has(phase)) {
        total++;
        if (pt.status === 'implemented') done++;
      }
  return { total, done, open: total - done };
}

/** Kravene flyten bygger på, til og med `depth`, uten duplikater */
export function flatKrav(ix: FlowIndex, f: Flow, t: FlowTree, depth: number): FlatKrav[] {
  const items = new Map<string, FlatKrav>();
  const walk = (n: DepNode, group: string) => {
    if (n.level > depth || n.cycle) return;
    if (!isFlowId(n.id) && exists(ix, n.id)) {
      let it = items.get(n.id);
      if (!it) items.set(n.id, (it = { id: n.id, level: n.level, phases: new Set(), via: new Set(), group, rules: new Set(), whole: false, open: new Set(), parts: new Map() }));
      it.phases.add(n.phase);
      if (nodeStatus(ix, n, t.follow) !== 'implemented') it.open.add(n.phase);
      for (const pt of partsOf(ix, n.id, t.follow === 'part' ? n.focus : null)) {
        const have = it.parts.get(pt.ln);
        if (have) have.phases.add(n.phase);
        else it.parts.set(pt.ln, { ...pt, phases: new Set([n.phase]) });
      }
      // Delen står i ankrene i kravet, eller i kommentaren under taggen. Uten dem gjelder referansen hele kravet
      const fc = n.focus;
      if (fc?.kind === 'anchor') fc.parts.forEach(a => a.rule && it!.rules.add(a.rule));
      else if (fc?.kind === 'note') fc.rules.forEach(r => it!.rules.add(r));
      else it.whole = true;
      it.via.add(n.parent && !isFlowId(n.parent.id) ? n.parent.id : f.overview ? 'flyten' : 'fasen');
    }
    if (!n.seenAt) n.children.forEach(c => walk(c, group));
  };
  t.roots.forEach(a => a.forEach(n => walk(n, isFlowId(n.id) ? n.id : f.id)));
  return [...items.values()];
}

// Varsler ---------------------------------------------------------------------------------------

export type WarnKind = 'missing' | 'broken' | 'deprecated' | 'part-left' | 'flow-behind' | 'cross-process' | 'cycle' | 'break';
export interface FlowWarning {
  kind: WarnKind;
  flow: string;
  phase?: number;
  id?: string;
  /** Kravet som peker på `id` (for avviklede krav og brutte referanser lenger ned) */
  from?: string;
  level?: number;
  cycle?: string[];
  text: string;
}

/** Varslene for flyten, regnet med alle nivåer og hele kravet, så nivåvalget ikke skjuler noe */
export function flowWarnings(ix: FlowIndex, f: Flow): FlowWarning[] {
  const out: FlowWarning[] = [];
  const t = flowTree(ix, f, 'whole');
  for (const b of f.knownBreaks) out.push({ kind: 'break', flow: f.id, text: b });
  for (const p of f.phases) {
    if (!p.links.length) out.push({ kind: 'missing', flow: f.id, phase: p.n, text: p.questions[0] ?? `Fase ${p.n} bygger ikke på noe krav` });
    for (const l of p.links) {
      const other = isFlowId(l.id) ? ix.byId.get(l.id) : null;
      if (other && other.process !== f.process) out.push({ kind: 'cross-process', flow: f.id, phase: p.n, id: l.id, text: `Fase ${p.n} peker på ${l.id} i ${other.process}. Flyten fasen bygger på, skal ligge i samme prosess.` });
    }
  }
  const done = new Set<string>();
  const once = (key: string) => (done.has(key) ? false : (done.add(key), true));
  let behind: DepNode | null = null;
  for (const n of nodesTo(t, Infinity)) {
    const from = n.parent?.id ?? `fase ${n.phase}`;
    if (n.cycle) {
      if (once('c:' + n.chain.join('>'))) out.push({ kind: 'cycle', flow: f.id, phase: n.phase, id: n.id, level: n.level - 1, cycle: n.chain, text: n.chain.join(' → ') });
      continue;
    }
    if (!exists(ix, n.id)) {
      if (once('b:' + from + n.id)) out.push({ kind: 'broken', flow: f.id, phase: n.phase, id: n.id, from, level: n.level, text: `${from} peker på ${n.id}, som ikke finnes under krav/.` });
      continue;
    }
    const s = statusOf(ix, n.id);
    if (s === 'deprecated' && once('d:' + from + n.id)) out.push({ kind: 'deprecated', flow: f.id, phase: n.phase, id: n.id, from, level: n.level, text: `${n.id} er avviklet. ${from} peker på det, og må peke på kravet som erstatter det.` });
    // Ankeret peker på en del som selv er tagget utkast eller avviklet: delen blir ikke levert, og fasen heller ikke.
    // En del som bare arver `@draft` fra egenskapen, er et vanlig utkast og varsles ikke
    if (s !== 'deprecated' && n.focus?.kind === 'anchor') {
      const k = ix.krav.get(n.id)!;
      for (const a of n.focus.parts) {
        const ps = (a.part === 'rule' ? k.rules.find(r => r.ln === a.ln) : k.scenarios.find(sc => sc.ln === a.ln))?.status;
        if ((ps === 'draft' || ps === 'deprecated') && ps !== s && once('p:' + from + n.id + ':' + a.ln))
          out.push({ kind: 'part-left', flow: f.id, phase: n.phase, id: n.id, from, level: n.level, text: `${from} bygger på «${a.name}» i ${n.id}, som er ${ps === 'draft' ? 'utkast' : 'avviklet'}. Delen blir ikke levert slik den står.` });
      }
    }
    if (f.status === 'implemented' && partStatus(ix, n.id, n.focus) !== 'implemented' && !behind) behind = n;
  }
  if (behind) out.push({ kind: 'flow-behind', flow: f.id, phase: behind.phase, id: behind.id, level: behind.level, text: `Flyten er @implemented, men ${behind.focus ? 'delen flyten bygger på i ' : ''}${behind.id} er ${partStatus(ix, behind.id, behind.focus) ?? 'uten status'}. Kravet er endret etter at flyten ble verifisert.` });
  return out;
}

// Ruta ------------------------------------------------------------------------------------------

export type Depth = number; // Infinity for alle
/** `#/flyter`, `#/flyter/<sti>` og `#/flyter/<sti>?nivåer=2|alle`. Hashen er dekodet. `undefined` når det ikke er flytene */
export function parseFlyterHash(h: string): { path: string | null; depth: Depth | null } | undefined {
  const m = /^flyter(?:\/(.*?))?(?:\?(.*))?$/.exec(h);
  if (!m) return undefined;
  const q = new URLSearchParams(m[2] ?? '').get('nivåer');
  const depth = q === 'alle' ? Infinity : q && +q >= 1 ? Math.floor(+q) : null;
  return { path: m[1] || null, depth };
}
export function flyterHash(path: string | null, depth: Depth): string {
  const q = depth === 1 ? '' : '?nivåer=' + (depth === Infinity ? 'alle' : depth);
  return '#/flyter' + (path ? '/' + encodeURI(path) : '') + (path ? q : '');
}
