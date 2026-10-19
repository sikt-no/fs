import { useEffect, useMemo, useState } from 'preact/hooks';
import type { GitInfo, Snapshot } from '../shared/model';
import { isSpecPath } from '../shared/paths';
import { applySpec, newSpecText, parseSpec, slugify, type Sketch, type SpecDoc } from '../shared/spec';
import { DOMAINS, newOppgaveText, type IssueRef, type RawTask, type TasksSnapshot } from '../shared/tasks';
import { parseUtforing, serializeUtforing, withRun, type SpecRun, type Utforing } from '../shared/utforing';
import { SpecDetail, type SpecActions } from './SpecDetail';
import {
  activeSpecs,
  BOARD_REPOS,
  buildBoard,
  canDrop,
  colIcon,
  colOf,
  COL_WHY,
  columns,
  currentRepo,
  DERIVED_COLS,
  dragSpec,
  featsOf,
  flags,
  idIndex,
  missing,
  moveTo,
  pickable,
  leadSpec,
  prShort,
  startStep,
  stepIcon,
  taskColOf,
  taskFlags,
  taskMissing,
  type Card,
  type ColConf,
  type ColKey,
  type Flag,
  type TaskCard,
} from './specboard';
import { NewTaskForm, TaskDetail, type KravFrom } from './TaskDetail';
import { NEW_TASK, splitSel } from './tavleHash';
import { transport } from './transport';

/** Nøkkelen til en ny spesifikasjon i en oppgave (`<dom>/<slug>/ny`), før den er skrevet til disk */
export const NEW_KEY = 'ny';

const COLS_KEY = 'kravforvaltning:specCols';
const FILTER_KEY = 'kravforvaltning:tavleFilter';

/** Filtrene på tavla. De huskes (localStorage) til de nullstilles. */
interface TavleFilter {
  dom: string | null;
  /** Scope-slug, `–` for oppgaver uten scope, eller tom */
  scope: string;
  repo: string;
  /** `meg`, `agent`, `andre`, `ingen` eller tom */
  by: string;
}
const NO_FILTER: TavleFilter = { dom: null, scope: '', repo: '', by: '' };
const DRAFT_KEY = 'kravforvaltning:specDraft';
const readJson = <T,>(key: string, fallback: T): T => {
  try {
    const v = localStorage.getItem(key);
    return v === null ? fallback : (JSON.parse(v) as T);
  } catch {
    return fallback;
  }
};
const writeJson = (key: string, v: unknown) => {
  try {
    if (v === null) localStorage.removeItem(key);
    else localStorage.setItem(key, JSON.stringify(v));
  } catch {
    /* utilgjengelig lagring */
  }
};

export const today = () => {
  const d = new Date();
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
};

/** Domenet (tasks-slug) for en sti under krav/, fra toppmappa */
export const domainOf = (path: string) => {
  const top = path.split('/')[1];
  return Object.entries(DOMAINS).find(([, v]) => v === top)?.[0] ?? null;
};

/** Kort domenenavn til chips og kort: hele navnet når det er kort, ellers første ord, forkortet hvis det er langt */
export function domShort(dom: string) {
  const w = dom.length <= 14 ? dom : dom.split('-')[0];
  return w.length > 12 ? w.slice(0, 9) + '.' : w;
}

/** Utkastet til en ny spesifikasjon i oppgaven `dom/slug`, før det har tittel og kan skrives til disk */
interface NewDraft {
  doc: SpecDoc;
  dom: string;
  slug: string;
}
const emptyDoc = (): SpecDoc => ({ title: '', delta: false, omfang: '', krav: [], skisser: [], ingenSkisse: null, sporsmal: [], rute: [] });

/** Teksten i filene slik de er etter lagring, til watcheren har sendt den nye tilstanden */
type Overrides = Record<string, string>;

/** Legger filer som er lagret (men ikke lest inn igjen ennå) over snapshotet, også nye filer, oppgavemapper og scope-filer */
function withOverrides(snap: TasksSnapshot, over: Overrides): TasksSnapshot {
  const paths = Object.keys(over);
  if (!paths.length) return snap;
  const tasks: RawTask[] = snap.tasks.map(t => ({ ...t, files: [...t.files], sources: { ...t.sources } }));
  const scopes = { ...(snap.scopes ?? {}) };
  for (const p of paths) {
    if (/^tasks\/[^/]+\/scope-[^/]+\.md$/.test(p)) {
      scopes[p] = over[p];
      continue;
    }
    const m = p.match(/^tasks\/([^/]+)\/([^/]+)\/(.+)$/);
    if (!m) continue;
    let t = tasks.find(x => x.dom === m[1] && x.slug === m[2]);
    if (!t) tasks.push((t = { dom: m[1], slug: m[2], files: [], sources: {}, mtimes: {} }));
    if (!t.files.includes(m[3])) t.files.push(m[3]);
    t.sources[m[3]] = over[p];
  }
  return { ...snap, tasks, scopes };
}

const sourceOf = (snap: TasksSnapshot, path: string) => {
  if (snap.scopes?.[path] !== undefined) return snap.scopes[path];
  const m = path.match(/^tasks\/([^/]+)\/([^/]+)\/(.+)$/);
  return m ? snap.tasks.find(t => t.dom === m[1] && t.slug === m[2])?.sources[m[3]] : undefined;
};

interface Props {
  snap: TasksSnapshot;
  entries: Snapshot;
  git: GitInfo | null;
  /** Redigering er mulig (dev-serveren og desktop-appen, ikke statisk bygg) */
  editable: boolean;
  /** `<dom>/<slug>`, `<dom>/<slug>/<spec-fil>`, `<dom>/<slug>/ny` eller `ny-oppgave` (se tavleHash.ts) */
  sel: string | null;
  onSel: (key: string | null) => void;
  /** Åpner kravet i Krav; `from` er oppgaven lenken kom fra, så Krav-visningen kan vise veien tilbake */
  onOpenKrav: (path: string, from: KravFrom | null) => void;
  /** Hvem som står i loggen: `@login` fra GitHub, ellers «vieweren» */
  me: string;
  actions: SpecActions;
}



/**
 * Tavla «Oppgaver»: ett kort per oppgave fra den opprettes (fs-scope eller «+ Ny oppgave») til kravene er verifisert.
 * Kolonnen utledes alltid: fra kravene (I scope, Kravarbeid, Spesifiseres) og fra spesifikasjonene på veien gjennom
 * kode-repoene. Detaljpanelet viser oppgaven, scopet og kravene, og spesifikasjonene i oppgaven, der alt kan redigeres.
 * Endringene skrives til spesifikasjonen (spec/spec-*.md), tilstandsfila (utforing.md) og oppgave.md, og sendes med «Lag PR».
 */
export function Tavle({ snap, entries, git, editable, sel, onSel, onOpenKrav, me, actions }: Props) {
  const ro = !editable;
  const [over, setOver] = useState<Overrides>({});
  const [conf, setConf] = useState<ColConf[]>(() => readJson(COLS_KEY, []));
  // Eldre utkast (fra Spesifikasjoner) hadde ingen oppgave, og forkastes
  const [draft, setDraft] = useState<NewDraft | null>(() => {
    const d = readJson<NewDraft | null>(DRAFT_KEY, null);
    return d?.slug && d.dom ? d : null;
  });
  const [filter, setFilter] = useState<TavleFilter>(() => ({ ...NO_FILTER, ...readJson<Partial<TavleFilter>>(FILTER_KEY, {}) }));
  const { dom, scope: scopeF, repo: repoF, by: byF } = filter;
  const setDom = (v: string | null) => setFilter(f => ({ ...f, dom: v }));
  const setScopeF = (v: string) => setFilter(f => ({ ...f, scope: v }));
  const setRepoF = (v: string) => setFilter(f => ({ ...f, repo: v }));
  const setByF = (v: string) => setFilter(f => ({ ...f, by: v }));
  const [editCols, setEditCols] = useState(false);
  const [drag, setDrag] = useState<string | null>(null);
  const [overCol, setOverCol] = useState<ColKey | null>(null);

  useEffect(() => writeJson(COLS_KEY, conf), [conf]);
  useEffect(() => writeJson(DRAFT_KEY, draft), [draft]);
  useEffect(() => writeJson(FILTER_KEY, filter.dom || filter.scope || filter.repo || filter.by ? filter : null), [filter]);
  // Det som er lagret og lest inn igjen, trenger ikke ligge over lenger
  useEffect(() => {
    setOver(o => {
      const next = Object.fromEntries(Object.entries(o).filter(([p, t]) => sourceOf(snap, p) !== t));
      return Object.keys(next).length === Object.keys(o).length ? o : next;
    });
  }, [snap]);

  const merged = useMemo(() => withOverrides(snap, over), [snap, over]);
  const ids = useMemo(() => idIndex(entries), [entries]);
  const draftCard: Card | null = draft
    ? {
        key: `${draft.dom}/${draft.slug}/${NEW_KEY}`,
        dom: draft.dom,
        slug: draft.slug,
        dir: `tasks/${draft.dom}/${draft.slug}`,
        file: `spec-${slugify(draft.doc.title) || 'ny'}.md`,
        path: `tasks/${draft.dom}/${draft.slug}/spec/spec-${slugify(draft.doc.title) || 'ny'}.md`,
        text: '',
        doc: draft.doc,
        run: { spec: '', route: [], steps: [], log: [{ d: today(), who: me, t: 'opprettet spesifikasjonen' }] },
        utforing: { runs: [] },
        feats: featsOf(draft.doc, entries, ids),
        mtime: null,
        verified: null,
      }
    : null;
  const board = useMemo(() => buildBoard(merged, entries, draftCard ? [draftCard] : []), [merged, entries, draftCard && JSON.stringify(draft)]);
  const cards = board.cards;
  const specs = board.specs;

  const changed = useMemo(() => new Set(git ? [...git.uncommitted, ...git.committed].map(c => c.path).filter(isSpecPath) : []), [git]);
  const specDirty = (c: Card) => c.key.endsWith('/' + NEW_KEY) || changed.has(c.path) || changed.has(`${c.dir}/utforing.md`);
  const taskDirty = (t: TaskCard) => t.specs.some(specDirty) || changed.has(`${t.dir}/oppgave.md`) || (!!t.scope && changed.has(t.scope.path));

  const cols = columns(conf, BOARD_REPOS, specs.map(c => c.run.route));
  const order = cols.map(c => c.key);
  const colOfTask = (t: TaskCard) => taskColOf(t, order);
  const repoName = (r: string) => cols.find(c => c.key === `repo:${r}`)?.name ?? r;
  const updConf = (key: ColKey, patch: Partial<ColConf>) =>
    setConf(cs => {
      const all = columns(cs, BOARD_REPOS, specs.map(c => c.run.route));
      const base = cs.length ? cs : all;
      const has = base.some(c => c.key === key);
      return has ? base.map(c => (c.key === key ? { ...c, ...patch } : c)) : [...base, { ...all.find(c => c.key === key)!, ...patch }];
    });

  // —— Lagring ——
  const save = (path: string, text: string) => {
    setOver(o => ({ ...o, [path]: text }));
    transport.call('save', { path, text }).catch((e: Error) => alert(`Kunne ikke lagre ${path}: ${e.message}`));
  };
  const titles = useMemo(() => {
    const t: Record<string, string> = {};
    for (const [id, e] of ids) if (e.model) t[id] = e.model.title;
    return t;
  }, [ids]);

  const writeRun = (c: Card, run: SpecRun, log: string | null) => {
    const r: SpecRun = { ...run, spec: `spec/${c.file}`, log: log ? [...run.log, { d: today(), who: me, t: log }] : run.log };
    const u: Utforing = withRun(c.utforing, r);
    save(`${c.dir}/utforing.md`, serializeUtforing(u));
  };

  /** Skriver den nye spesifikasjonen til disk når den har tittel; velger den */
  const materialize = (d: NewDraft) => {
    const t = merged.tasks.find(x => x.dom === d.dom && x.slug === d.slug);
    const base = slugify(d.doc.title) || 'ny';
    let file = `spec-${base}.md`;
    for (let i = 2; t?.files.includes(`spec/${file}`); i++) file = `spec-${base}-${i}.md`;
    const dir = `tasks/${d.dom}/${d.slug}`;
    const scope = cards.find(c => c.key === `${d.dom}/${d.slug}`)?.scope?.slug ?? null;
    const skeleton = newSpecText(d.doc.title, dir, today(), scope);
    save(`${dir}/spec/${file}`, applySpec(skeleton, parseSpec(skeleton), d.doc, titles, `${dir}/spec`));
    const utf = t?.sources['utforing.md'];
    const run: SpecRun = { spec: `spec/${file}`, route: [], steps: [], log: [{ d: today(), who: me, t: 'opprettet spesifikasjonen' }] };
    save(`${dir}/utforing.md`, serializeUtforing(withRun(utf ? parseUtforing(utf) : { runs: [] }, run)));
    setDraft(null);
    onSel(`${d.dom}/${d.slug}/${file}`);
  };

  const updDoc = (c: Card, fn: (d: SpecDoc) => void, log?: string) => {
    if (ro) return;
    const next: SpecDoc = structuredClone(c.doc);
    fn(next);
    if (c.key.endsWith('/' + NEW_KEY)) {
      const d: NewDraft = { doc: next, dom: c.dom, slug: c.slug };
      if (d.doc.title.trim()) materialize(d);
      else setDraft(d);
      return;
    }
    save(c.path, applySpec(c.text, c.doc, next, titles, `${c.dir}/spec`));
    if (log) writeRun(c, c.run, log);
  };
  const updRun = (c: Card, fn: (r: SpecRun) => void, log?: string) => {
    if (ro || c.key.endsWith('/' + NEW_KEY)) return;
    const run: SpecRun = structuredClone(c.run);
    fn(run);
    writeRun(c, run, log ?? null);
  };

  /** «+ Ny spesifikasjon» i oppgaven: kravene uten spesifikasjon som kan plukkes, og skissene fra scope-raden */
  const newSpec = (t: TaskCard) => {
    if (ro) return;
    const doc = emptyDoc();
    for (const k of t.unspecced) if (k.entry && k.path && pickable(k.entry).ok) doc.krav.push({ file: k.file, id: k.id ?? '', path: k.path, remove: k.status === 'deprecated' });
    const rows = t.scope?.rows.filter(r => r.task === t.slug) ?? [];
    for (const sk of rows.flatMap(r => r.sketches)) {
      if (doc.skisser.some(x => x.url === sk.url)) continue;
      const s: Sketch = { name: sk.name, url: sk.url, kind: 'Uavklart', note: '', dekker: '', fields: [] };
      doc.skisser.push(s);
    }
    setDraft({ doc, dom: t.dom, slug: t.slug });
    onSel(`${t.key}/${NEW_KEY}`);
  };

  /** «+ Ny oppgave»: en minimal oppgave.md fra malen */
  const createTask = (o: { title: string; dom: string; issue: IssueRef | null; owner: string | null }) => {
    let slug = slugify(o.title);
    const base = slug;
    for (let i = 2; merged.tasks.some(t => t.dom === o.dom && t.slug === slug); i++) slug = `${base}-${i}`;
    save(`tasks/${o.dom}/${slug}/oppgave.md`, newOppgaveText({ ...o, slug, date: today(), via: 'Opprettet i FS Kravforvaltning («+ Ny oppgave»)' }));
    onSel(`${o.dom}/${slug}`);
  };

  // —— Filtre ——
  const byKind = (by: string) => (!by ? 'ingen' : by === me ? 'meg' : by.startsWith('agent:') ? 'agent' : 'andre');
  const shown = cards.filter(t => {
    if (dom && t.dom !== dom) return false;
    if (scopeF && (t.scope?.slug ?? '–') !== scopeF) return false;
    if (repoF && !t.specs.some(s => s.run.route.includes(repoF))) return false;
    if (byF) {
      const kinds = activeSpecs(t).map(s => {
        const r = currentRepo(s);
        return byKind(r ? (s.run.steps.find(x => x.repo === r)?.by ?? '') : '');
      });
      if (!(kinds.length ? kinds : ['ingen']).includes(byF)) return false;
    }
    return true;
  });
  const doms = [...new Set(cards.map(c => c.dom))];
  const scopeSlugs = board.scopes.map(s => s.slug);
  const visCols = editCols ? cols : cols.filter(c => !c.hidden);
  const repoCols = cols.filter(c => c.key.startsWith('repo:'));
  const dragged = drag ? cards.find(c => c.key === drag) : null;
  const draggedSpec = dragged ? dragSpec(dragged) : null;

  const { task: selTask, spec: selSpecFile, newTask } = splitSel(sel);
  const selCard = cards.find(c => c.key === selTask) ?? null;
  // Spesifikasjonen i det brede panelet: bare når den er valgt (`<dom>/<slug>/<fil>` eller `…/ny`)
  const selSpec = selCard && selSpecFile ? (selCard.specs.find(s => (selSpecFile === NEW_KEY ? s.key.endsWith('/' + NEW_KEY) : s.file === selSpecFile)) ?? null) : null;
  const open = !!selCard || newTask;
  const specSel = (t: TaskCard, s: Card) => `${t.key}/${s.key.endsWith('/' + NEW_KEY) ? NEW_KEY : s.file}`;

  const hasFilter = !!(dom || scopeF || repoF || byF);
  const filterText = [dom, scopeF ? (scopeF === '–' ? 'uten scope' : `scope-${scopeF}`) : '', repoF ? repoName(repoF) : '', byF ? `tatt av ${byF}` : ''].filter(Boolean).join(' · ') || 'ingen';
  /** Åpner kravet i Krav, med oppgaven som er valgt som vei tilbake */
  const openKrav = (path: string) => {
    if (!selCard) return onOpenKrav(path, null);
    const k = colOfTask(selCard);
    const paths = [...selCard.krav.map(x => x.path), ...selCard.specs.flatMap(s => s.feats.map(f => f.path))].filter((p): p is string => !!p);
    onOpenKrav(path, { sel: selCard.key, title: selCard.task.title, col: k, colName: cols.find(c => c.key === k)?.name ?? k, paths: [...new Set(paths)], filters: filterText });
  };
  /** «Sett rute og send»: ruta fra spesifikasjonen blir ruta i utforing.md, med alle steg som venter */
  const sendSpec = (c: Card) => {
    const rute = c.doc.rute;
    if (ro || !rute.length) return;
    save(c.path, applySpec(c.text, c.doc, { ...c.doc, rute: [] }, titles, `${c.dir}/spec`));
    writeRun(c, { ...c.run, route: [...rute], steps: rute.map(r => ({ repo: r, status: 'venter', by: '', pr: [], handoff: '', blocked: null, back: null })) }, `sendte til ${repoName(rute[0])}`);
  };
  /** Steget i repoet settes til «pågår» før en utførekjøring */
  const startRun = (c: Card, r: string, what: string) => updRun(c, run => startStep(run, r), `startet ${what} i ${repoName(r)}`);

  const drop = (c: Card, key: ColKey) => {
    const name = cols.find(x => x.key === key)?.name ?? key;
    const m = moveTo(c, key, name);
    if (m.rute.join() !== c.doc.rute.join()) save(c.path, applySpec(c.text, c.doc, { ...c.doc, rute: m.rute }, titles, `${c.dir}/spec`));
    writeRun(c, m.run, m.log);
  };

  return (
    <div class={'spwrap' + (open ? ' open' : '')}>
      <div class="spboard">
        <div class="sphead">
          <h1>Oppgaver</h1>
          <div class="spchips">
            <button class={'spchip' + (!dom ? ' on' : '')} onClick={() => setDom(null)}>
              Alle<span class="mono">{cards.length}</span>
            </button>
            {doms.map(d => (
              <button key={d} class={'spchip' + (dom === d ? ' on' : '')} title={d} onClick={() => setDom(dom === d ? null : d)}>
                {domShort(d)}
                <span class="mono">{cards.filter(c => c.dom === d).length}</span>
              </button>
            ))}
          </div>
          <span class="spsep" />
          {scopeSlugs.length > 0 && (
            <label class="spsel">
              Scope
              <select value={scopeF} onChange={e => setScopeF((e.target as HTMLSelectElement).value)}>
                <option value="">alle</option>
                {scopeSlugs.map(s => (
                  <option key={s} value={s}>
                    {s}
                  </option>
                ))}
                <option value="–">uten scope</option>
              </select>
            </label>
          )}
          <label class="spsel">
            Repo
            <select value={repoF} onChange={e => setRepoF((e.target as HTMLSelectElement).value)}>
              <option value="">alle</option>
              {repoCols.map(c => (
                <option key={c.key} value={c.key.slice(5)}>
                  {c.name}
                </option>
              ))}
            </select>
          </label>
          <label class="spsel">
            Tatt av
            <select value={byF} onChange={e => setByF((e.target as HTMLSelectElement).value)}>
              {[['', 'alle'], ['meg', 'meg'], ['agent', 'agent'], ['andre', 'andre'], ['ingen', 'ingen']].map(([v, t]) => (
                <option key={v} value={v}>
                  {t}
                </option>
              ))}
            </select>
          </label>
          {hasFilter && (
            <button class="spfilter-reset" title="Filtrene huskes til du nullstiller dem" onClick={() => setFilter(NO_FILTER)}>
              Nullstill filtre
              <span class="sptag acc mono">huskes</span>
            </button>
          )}
          {!ro && (
            <div class="spactions">
              <button class={'spbtn' + (editCols ? ' solid' : '')} onClick={() => setEditCols(v => !v)}>
                <span class="sp-colsic" aria-hidden="true">
                  <span />
                  <span />
                  <span />
                </span>
                {editCols ? 'Ferdig' : 'Kolonner'}
              </button>
              <button
                class="spbtn acc"
                onClick={() => {
                  setEditCols(false);
                  onSel(NEW_TASK);
                }}
              >
                + Ny oppgave
              </button>
            </div>
          )}
        </div>

        <div class="spcols">
          {visCols.map(col => {
            const colCards = shown.filter(c => colOfTask(c) === col.key);
            const ok = !!draggedSpec && canDrop(draggedSpec, col.key);
            const home = !!dragged && colOfTask(dragged) === col.key;
            const isRepo = col.key.startsWith('repo:');
            const derived = DERIVED_COLS.includes(col.key);
            const ri = repoCols.findIndex(c => c.key === col.key);
            const usedIn = isRepo ? specs.filter(c => c.run.route.includes(col.key.slice(5))).length : 0;
            const swap = (d: number) => {
              const other = repoCols[ri + d];
              if (!other) return;
              setConf(() => {
                const ordered = cols.map(c => (c.key === col.key ? other : c.key === other.key ? col : c));
                // Fjernede repo-kolonner står ikke i `cols`, men skal fortsatt være fjernet
                return [...ordered.map(c => ({ ...(conf.find(x => x.key === c.key) ?? c) })), ...conf.filter(c => c.removed)];
              });
            };
            return (
              <div
                key={col.key}
                class={'spcol' + (overCol === col.key && ok ? ' over' : '') + (editCols ? ' editing' : '')}
                style={{ opacity: col.hidden ? 0.5 : dragged && !ok && !home ? 0.45 : 1 }}
                onDragOver={e => {
                  if (!ok) return;
                  e.preventDefault();
                  if (e.dataTransfer) e.dataTransfer.dropEffect = 'move';
                  if (overCol !== col.key) setOverCol(col.key);
                }}
                onDragLeave={e => {
                  if (!(e.currentTarget as HTMLElement).contains(e.relatedTarget as Node) && overCol === col.key) setOverCol(null);
                }}
                onDrop={e => {
                  e.preventDefault();
                  setDrag(null);
                  setOverCol(null);
                  if (ok && draggedSpec) drop(draggedSpec, col.key);
                }}
              >
                {!editCols ? (
                  <div class="spcol-h">
                    <div class="spcol-t">
                      <span class={colIcon(col.key)} />
                      <span class="spcol-name">{col.name}</span>
                      <span class="mono">{colCards.length}</span>
                    </div>
                    <span class="spcol-why">{COL_WHY[col.key] ?? 'Repo'}</span>
                  </div>
                ) : (
                  <div class="spcol-h edit">
                    <div class="spcol-t">
                      <span class={colIcon(col.key)} />
                      <input value={col.name} onChange={e => updConf(col.key, { name: (e.target as HTMLInputElement).value })} />
                    </div>
                    <div class="spcol-tools mono">
                      <span>{isRepo ? `repo · ${usedIn} ruter` : derived ? 'utledet fra kravene · fast plass' : 'utledet · fast plass'}</span>
                      <span class="spcol-btns">
                        {isRepo && (
                          <>
                            <button title="Flytt til venstre" style={{ opacity: ri > 0 ? 1 : 0.35 }} onClick={() => swap(-1)}>
                              ‹
                            </button>
                            <button title="Flytt til høyre" style={{ opacity: ri < repoCols.length - 1 ? 1 : 0.35 }} onClick={() => swap(1)}>
                              ›
                            </button>
                          </>
                        )}
                        <button onClick={() => updConf(col.key, { hidden: !col.hidden })}>{col.hidden ? 'Vis' : 'Skjul'}</button>
                        {isRepo && (
                          <button
                            class="danger"
                            title={usedIn ? `Fjernes også fra ${usedIn} ruter` : 'Fjern kolonnen'}
                            onClick={() => {
                              const r = col.key.slice(5);
                              // Én skriving per utforing.md: flere spesifikasjoner i samme oppgave deler fila
                              const byDir = new Map<string, Card[]>();
                              for (const c of specs.filter(c => !c.key.endsWith('/' + NEW_KEY) && c.run.route.includes(r))) byDir.set(c.dir, [...(byDir.get(c.dir) ?? []), c]);
                              for (const [dir, cs] of byDir) {
                                let u: Utforing = cs[0].utforing;
                                for (const c of cs) {
                                  const run: SpecRun = structuredClone(c.run);
                                  run.spec = `spec/${c.file}`;
                                  run.route = run.route.filter(x => x !== r);
                                  run.steps = run.steps.filter(s => s.repo !== r);
                                  run.log = [...run.log, { d: today(), who: me, t: `${r} fjernet fra ruta` }];
                                  u = withRun(u, run);
                                }
                                save(`${dir}/utforing.md`, serializeUtforing(u));
                              }
                              updConf(col.key, { removed: true });
                            }}
                          >
                            Fjern
                          </button>
                        )}
                      </span>
                    </div>
                  </div>
                )}
                <div class="spcol-list">
                  {colCards.map(t => {
                    const canDrag = !ro && !editCols && !!dragSpec(t) && !dragSpec(t)!.key.endsWith('/' + NEW_KEY);
                    return (
                      <TaskCardView
                        key={t.key}
                        t={t}
                        col={col.key}
                        sel={selTask === t.key}
                        dirty={!ro && taskDirty(t)}
                        repoName={repoName}
                        me={me}
                        draggable={canDrag}
                        dragging={drag === t.key}
                        onClick={() => onSel(selTask === t.key ? null : t.key)}
                        onDragStart={e => {
                          if (e.dataTransfer) {
                            e.dataTransfer.effectAllowed = 'move';
                            e.dataTransfer.setData('text/plain', t.key);
                          }
                          setTimeout(() => setDrag(t.key), 0);
                        }}
                        onDragEnd={() => {
                          setDrag(null);
                          setOverCol(null);
                        }}
                      />
                    );
                  })}
                  {!colCards.length && (
                    <span class="spcol-empty">{!cards.length && col.key === 'scope' ? 'Ingen oppgaver ennå. Avgrens et initiativ med fs-scope, eller lag en oppgave med «+ Ny oppgave».' : 'Ingen oppgaver'}</span>
                  )}
                </div>
              </div>
            );
          })}
          {editCols && !ro && (
            <div class="spnewcol">
              <span class="ot">Ny repo-kolonne</span>
              <span class="omuted">Blir et repo som ruter kan inneholde. Plasseres før Til verifisering.</span>
              <input
                class="mono"
                placeholder="f.eks. fs-integrasjon"
                onKeyDown={e => {
                  const el = e.target as HTMLInputElement;
                  const name = el.value.trim();
                  if (e.key !== 'Enter' || !name) return;
                  el.value = '';
                  const key = `repo:${name}` as ColKey;
                  setConf(() => {
                    const all = cols.map(c => conf.find(x => x.key === c.key) ?? c).filter(c => c.key !== key);
                    const at = all.findIndex(c => c.key === 'verifisering');
                    all.splice(at, 0, { key, name });
                    return [...all, ...conf.filter(c => c.removed && c.key !== key)];
                  });
                }}
              />
              <span class="omuted small">Enter for å legge til</span>
            </div>
          )}
        </div>
      </div>

      {newTask && !ro && <NewTaskForm me={me} onClose={() => onSel(null)} onCreate={createTask} />}
      {selCard && (
        <TaskDetail
          key={selCard.key}
          t={selCard}
          col={cols.find(x => x.key === colOfTask(selCard)) ?? { key: colOfTask(selCard), name: colOfTask(selCard) }}
          open={selSpec}
          ro={ro}
          dirty={!ro && taskDirty(selCard)}
          colName={k => cols.find(x => x.key === k)?.name ?? k}
          repoName={repoName}
          actions={actions}
          onSpec={s => onSel(specSel(selCard, s))}
          onNewSpec={() => newSpec(selCard)}
          onClose={() => onSel(null)}
          onOpenKrav={openKrav}
          onSend={sendSpec}
          onStart={startRun}
        />
      )}
      {selCard && selSpec && (
        <SpecDetail
          key={selSpec.key}
          c={selSpec}
          col={cols.find(x => x.key === colOf(selSpec)) ?? { key: colOf(selSpec), name: colOf(selSpec) }}
          repos={repoCols.map(c => c.key.slice(5))}
          repoName={repoName}
          cards={specs}
          entries={entries}
          ro={ro}
          dirty={!ro && specDirty(selSpec)}
          me={me}
          taskTitle={selCard.task.title}
          siblings={selCard.specs}
          onPick={s => onSel(specSel(selCard, s))}
          prefer={selCard.krav.map(k => k.path).filter((p): p is string => !!p)}
          scope={selCard.scope?.slug ?? null}
          onClose={() => onSel(selCard.key)}
          onDoc={(fn, log) => updDoc(selSpec, fn, log)}
          onRun={(fn, log) => updRun(selSpec, fn, log)}
          onSend={() => sendSpec(selSpec)}
          onOpenKrav={openKrav}
          actions={actions}
        />
      )}
    </div>
  );
}

interface CardProps {
  t: TaskCard;
  col: ColKey;
  sel: boolean;
  dirty: boolean;
  repoName: (r: string) => string;
  me: string;
  draggable: boolean;
  dragging: boolean;
  onClick: () => void;
  onDragStart: (e: DragEvent) => void;
  onDragEnd: () => void;
}

function TaskCardView({ t, col, sel, dirty, repoName, me, draggable, dragging, onClick, onDragStart, onDragEnd }: CardProps) {
  const c = leadSpec(t, col);
  const cur = col.startsWith('repo:') ? col.slice(5) : null;
  const stp = c && cur ? (c.run.steps.find(s => s.repo === cur) ?? null) : null;
  const all = t.specs.flatMap(s => s.feats.flatMap(f => f.sc));
  const n = all.length;
  const cnt = (r: string) => all.filter(x => x.r === r).length;
  const [ok, us, no] = [cnt('funnet'), cnt('usikker'), cnt('ikke funnet')];
  const pct = (x: number) => (n ? `${Math.round((100 * x) / n)}%` : '0%');
  // Flaggene på spesifikasjonene som ikke er verifisert, og på oppgaven
  const fl: Flag[] = [];
  for (const f of [...activeSpecs(t).flatMap(s => flags(s, false)), ...taskFlags(t, dirty)]) if (!fl.some(x => x.t === f.t)) fl.push(f);
  const m = col === 'spesifiseres' && c ? missing(c) : taskMissing(t);
  const lastPr = stp?.pr.length ? prShort(stp.pr[stp.pr.length - 1]) : '';
  const other = !!stp?.by && stp.by !== me && !stp.by.startsWith('agent:');
  const nSpecs = t.specs.filter(s => !s.key.endsWith('/' + NEW_KEY)).length;
  return (
    <div
      class={'spcard' + (sel ? ' sel' : '')}
      style={{ opacity: dragging ? 0.4 : 1, cursor: draggable ? 'grab' : 'pointer' }}
      draggable={draggable}
      onDragStart={onDragStart}
      onDragEnd={onDragEnd}
      onClick={onClick}
      title={draggable ? undefined : activeSpecs(t).length > 1 ? 'Oppgaven har flere spesifikasjoner: flytt dem i detaljpanelet' : undefined}
    >
      <div class="spcard-top mono">
        <span class="ell">{domShort(t.dom)}</span>
        {t.scope && <span class="sptag acc" title={t.scope.title}>{t.scope.slug}</span>}
        {t.task.issue && <span>{t.task.issue.key}</span>}
        <span class="push">
          {t.krav.length} krav{nSpecs ? ` · ${nSpecs} spec` : ''}
        </span>
      </div>
      <div class="spcard-title">
        <span>{t.task.title}</span>
        {t.specs.some(s => s.doc.skisser.length > 0) && <span class="spthumb" />}
      </div>
      {c && c.run.route.length > 0 && (
        <div class="sproute mono">
          {c.run.route.map((r, i) => {
            const s = c.run.steps.find(x => x.repo === r);
            return (
              <span key={r} class="sproute-i">
                {i > 0 && <span class="sproute-sep">→</span>}
                <span class={stepIcon(s?.status)} />
                <span style={{ color: r === cur ? 'var(--ink)' : 'var(--muted)', fontWeight: r === cur ? 600 : 400 }}>{repoName(r).replace(/^fs-/, '')}</span>
              </span>
            );
          })}
        </div>
      )}
      {stp && (
        <div class="spstep">
          <span style={{ color: stp.status === 'pågår' ? 'var(--st-in-progress)' : 'var(--ink2)', fontWeight: 500 }}>{stp.status}</span>
          <span class="omuted">·</span>
          <span class="mono ell" style={{ color: other ? 'var(--st-in-progress)' : 'var(--ink2)' }}>
            {stp.by || 'ingen har tatt steget'}
          </span>
          {lastPr && <span class="mono push spprlink">{lastPr}</span>}
        </div>
      )}
      {m.length > 0 && <span class="spmissing">{'Mangler: ' + m.join(' · ')}</span>}
      {n > 0 && (
        <div class="spprog mono">
          <span class="spprog-bar">
            <span style={{ width: pct(ok), background: 'var(--st-implemented)' }} />
            <span style={{ width: pct(us), background: 'var(--st-in-progress)' }} />
            <span style={{ width: pct(no), background: 'var(--err)' }} />
          </span>
          <span>{ok + us + no ? `${ok}/${n} funnet` : `${n} scenarioer`}</span>
        </div>
      )}
      {fl.length > 0 && (
        <div class="spflags">
          {fl.map(f => (
            <span key={f.t} class={'spflag ' + f.kind}>
              <span class="spflag-d" />
              {f.t}
            </span>
          ))}
        </div>
      )}
    </div>
  );
}
