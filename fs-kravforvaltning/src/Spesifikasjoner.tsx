import { useEffect, useMemo, useState } from 'preact/hooks';
import { CODE_DIRS } from '../shared/api';
import type { GitInfo, Snapshot } from '../shared/model';
import { applySpec, newSpecText, parseSpec, slugify, type SpecDoc } from '../shared/spec';
import { DOMAINS, type RawTask, type TasksSnapshot } from '../shared/tasks';
import { parseUtforing, serializeUtforing, withRun, type SpecRun, type Utforing } from '../shared/utforing';
import { domShort } from './oppgaveflyt';
import { SpecDetail, type SpecActions } from './SpecDetail';
import {
  buildCards,
  canDrop,
  colOf,
  COL_WHY,
  columns,
  currentRepo,
  featsOf,
  flags,
  idIndex,
  missing,
  moveTo,
  prShort,
  stepIcon,
  type Card,
  type ColConf,
  type ColKey,
} from './specboard';
import { transport } from './transport';

/** Nøkkelen til et nytt utkast som ikke er skrevet til disk ennå */
export const NEW_KEY = 'ny';

const COLS_KEY = 'kravforvaltning:specCols';
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

/** Utkastet til en ny spesifikasjon, før det har tittel og domene og kan skrives til disk */
interface NewDraft {
  doc: SpecDoc;
  dom: string;
}
const emptyDoc = (): SpecDoc => ({ title: '', delta: false, omfang: '', krav: [], skisser: [], ingenSkisse: null, sporsmal: [], rute: [] });

/** Teksten i filene slik de er etter lagring, til watcheren har sendt den nye tilstanden */
type Overrides = Record<string, string>;

/** Legger filer som er lagret (men ikke lest inn igjen ennå) over snapshotet, også nye filer og oppgavemapper */
function withOverrides(snap: TasksSnapshot, over: Overrides): TasksSnapshot {
  const paths = Object.keys(over);
  if (!paths.length) return snap;
  const tasks: RawTask[] = snap.tasks.map(t => ({ ...t, files: [...t.files], sources: { ...t.sources } }));
  for (const p of paths) {
    const m = p.match(/^tasks\/([^/]+)\/([^/]+)\/(.+)$/);
    if (!m) continue;
    let t = tasks.find(x => x.dom === m[1] && x.slug === m[2]);
    if (!t) tasks.push((t = { dom: m[1], slug: m[2], files: [], sources: {}, mtimes: {} }));
    if (!t.files.includes(m[3])) t.files.push(m[3]);
    t.sources[m[3]] = over[p];
  }
  return { ...snap, tasks };
}

const sourceOf = (snap: TasksSnapshot, path: string) => {
  const m = path.match(/^tasks\/([^/]+)\/([^/]+)\/(.+)$/);
  return m ? snap.tasks.find(t => t.dom === m[1] && t.slug === m[2])?.sources[m[3]] : undefined;
};

interface Props {
  snap: TasksSnapshot;
  entries: Snapshot;
  git: GitInfo | null;
  /** Redigering er mulig (dev-serveren og desktop-appen, ikke statisk bygg) */
  editable: boolean;
  sel: string | null;
  onSel: (key: string | null) => void;
  onOpenKrav: (path: string) => void;
  /** Hvem som står i loggen: `@login` fra GitHub, ellers «vieweren» */
  me: string;
  actions: SpecActions;
}

const colIcon = (c: ColConf) =>
  c.key.startsWith('repo:') ? 'sp-ic sp-ic--repo' : c.key === 'verifisering' ? 'sp-ic sp-ic--verif' : `st st--${c.key === 'utkast' ? 'draft' : c.key === 'klar' ? 'planned' : 'implemented'}`;

/**
 * Spesifikasjoner (designet «Spesifikasjoner», runde 1): tavla over spesifikasjonene fra fs-specify, med én kolonne
 * per repo på veien gjennom kode-repoene, og detaljpanelet der alt kan redigeres. Endringene skrives til
 * spesifikasjonen (spec/spec-*.md) og tilstandsfila (utforing.md), og sendes med «Lag PR».
 */
export function Spesifikasjoner({ snap, entries, git, editable, sel, onSel, onOpenKrav, me, actions }: Props) {
  const ro = !editable;
  const [over, setOver] = useState<Overrides>({});
  const [conf, setConf] = useState<ColConf[]>(() => readJson(COLS_KEY, []));
  const [draft, setDraft] = useState<NewDraft | null>(() => readJson(DRAFT_KEY, null));
  const [dom, setDom] = useState<string | null>(null);
  const [repoF, setRepoF] = useState('');
  const [byF, setByF] = useState('');
  const [editCols, setEditCols] = useState(false);
  const [drag, setDrag] = useState<string | null>(null);
  const [overCol, setOverCol] = useState<ColKey | null>(null);

  useEffect(() => writeJson(COLS_KEY, conf), [conf]);
  useEffect(() => writeJson(DRAFT_KEY, draft), [draft]);
  // Det som er lagret og lest inn igjen, trenger ikke ligge over lenger
  useEffect(() => {
    setOver(o => {
      const next = Object.fromEntries(Object.entries(o).filter(([p, t]) => sourceOf(snap, p) !== t));
      return Object.keys(next).length === Object.keys(o).length ? o : next;
    });
  }, [snap]);

  const merged = useMemo(() => withOverrides(snap, over), [snap, over]);
  const saved = useMemo(() => buildCards(merged, entries), [merged, entries]);
  const ids = useMemo(() => idIndex(entries), [entries]);
  const draftCard: Card | null = draft
    ? {
        key: NEW_KEY,
        dom: draft.dom,
        slug: slugify(draft.doc.title),
        dir: `tasks/${draft.dom || '‹domene›'}/${slugify(draft.doc.title) || '‹slug›'}`,
        file: `spec-${slugify(draft.doc.title) || 'ny'}.md`,
        path: `tasks/${draft.dom || '‹domene›'}/${slugify(draft.doc.title) || '‹slug›'}/spec/spec-${slugify(draft.doc.title) || 'ny'}.md`,
        text: '',
        doc: draft.doc,
        run: { spec: '', route: [], steps: [], log: [{ d: today(), who: me, t: 'opprettet spesifikasjonen' }] },
        utforing: { runs: [] },
        feats: featsOf(draft.doc, entries, ids),
        mtime: null,
        verified: null,
      }
    : null;
  const cards = draftCard ? [draftCard, ...saved] : saved;

  const changed = useMemo(() => new Set(git ? [...git.uncommitted, ...git.committed].map(c => c.path) : []), [git]);
  const isDirty = (c: Card) => c.key === NEW_KEY || changed.has(c.path) || changed.has(`${c.dir}/utforing.md`);

  const cols = columns(conf, [...CODE_DIRS].reverse(), cards.map(c => c.run.route));
  const repoName = (r: string) => cols.find(c => c.key === `repo:${r}`)?.name ?? r;
  const updConf = (key: ColKey, patch: Partial<ColConf>) =>
    setConf(cs => {
      const all = columns(cs, [...CODE_DIRS].reverse(), cards.map(c => c.run.route));
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
    for (const e of Object.values(entries)) {
      const id = e.model?.tags.find(x => /^@[A-ZÆØÅ]{3}-[A-ZÆØÅ]{3}-[A-ZÆØÅ]{3}-\d{3}$/.test(x));
      if (id && e.model) t[id] = e.model.title;
    }
    return t;
  }, [entries]);

  const writeRun = (c: Card, run: SpecRun, log: string | null) => {
    const r: SpecRun = { ...run, spec: `spec/${c.file}`, log: log ? [...run.log, { d: today(), who: me, t: log }] : run.log };
    const u: Utforing = withRun(c.utforing, r);
    save(`${c.dir}/utforing.md`, serializeUtforing(u));
  };

  /** Skriver det nye utkastet til disk når det har tittel og domene; gir kortet det blir til */
  const materialize = (d: NewDraft) => {
    let slug = slugify(d.doc.title);
    const exists = (s: string) => merged.tasks.some(t => t.dom === d.dom && t.slug === s && t.files.includes(`spec/spec-${s}.md`));
    for (let i = 2; exists(slug); i++) slug = `${slugify(d.doc.title)}-${i}`;
    const dir = `tasks/${d.dom}/${slug}`;
    const path = `${dir}/spec/spec-${slug}.md`;
    const skeleton = newSpecText(d.doc.title, dir, today());
    save(path, applySpec(skeleton, parseSpec(skeleton), d.doc, titles, `${dir}/spec`));
    const utf = merged.tasks.find(t => t.dom === d.dom && t.slug === slug)?.sources['utforing.md'];
    const run: SpecRun = { spec: `spec/spec-${slug}.md`, route: [], steps: [], log: [{ d: today(), who: me, t: 'opprettet spesifikasjonen' }] };
    const u = withRun(utf ? parseUtforing(utf) : { runs: [] }, run);
    save(`${dir}/utforing.md`, serializeUtforing(u));
    setDraft(null);
    onSel(`${d.dom}/${slug}/spec-${slug}.md`);
  };

  const updDoc = (c: Card, fn: (d: SpecDoc) => void, log?: string) => {
    if (ro) return;
    const next: SpecDoc = structuredClone(c.doc);
    fn(next);
    if (c.key === NEW_KEY) {
      const d: NewDraft = { doc: next, dom: draft?.dom || (next.krav[0]?.path ? (domainOf(next.krav[0].path) ?? '') : '') };
      if (d.doc.title.trim() && d.dom) materialize(d);
      else setDraft(d);
      return;
    }
    save(c.path, applySpec(c.text, c.doc, next, titles, `${c.dir}/spec`));
    if (log) writeRun(c, c.run, log);
  };
  const updRun = (c: Card, fn: (r: SpecRun) => void, log?: string) => {
    if (ro || c.key === NEW_KEY) return;
    const run: SpecRun = structuredClone(c.run);
    fn(run);
    writeRun(c, run, log ?? null);
  };

  const newSpec = () => {
    if (ro) return;
    setDraft({ doc: emptyDoc(), dom: '' });
    setDom(null);
    setRepoF('');
    setByF('');
    setEditCols(false);
    onSel(NEW_KEY);
  };

  // —— Filtre ——
  const byKind = (by: string) => (!by ? 'ingen' : by === me ? 'meg' : by.startsWith('agent:') ? 'agent' : 'andre');
  const shown = cards.filter(c => {
    if (dom && c.dom !== dom) return false;
    if (repoF && !c.run.route.includes(repoF)) return false;
    if (byF) {
      const r = currentRepo(c);
      if (byKind(r ? (c.run.steps.find(s => s.repo === r)?.by ?? '') : '') !== byF) return false;
    }
    return true;
  });
  const doms = [...new Set(cards.map(c => c.dom).filter(Boolean))];
  const visCols = editCols ? cols : cols.filter(c => !c.hidden);
  const repoCols = cols.filter(c => c.key.startsWith('repo:'));
  const dragged = drag ? cards.find(c => c.key === drag) : null;
  const selCard = cards.find(c => c.key === sel) ?? null;

  const drop = (c: Card, key: ColKey) => {
    const name = cols.find(x => x.key === key)?.name ?? key;
    const m = moveTo(c, key, name);
    if (m.rute.join() !== c.doc.rute.join()) save(c.path, applySpec(c.text, c.doc, { ...c.doc, rute: m.rute }, titles, `${c.dir}/spec`));
    writeRun(c, m.run, m.log);
  };

  return (
    <div class={'spwrap' + (selCard ? ' open' : '')}>
      <div class="spboard">
        <div class="sphead">
          <h1>Spesifikasjoner</h1>
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
              <button class="spbtn acc" onClick={newSpec}>
                + Ny spesifikasjon
              </button>
            </div>
          )}
        </div>

        <div class="spcols">
          {visCols.map(col => {
            const colCards = shown.filter(c => colOf(c) === col.key);
            const ok = !!dragged && canDrop(dragged, col.key);
            const home = !!dragged && colOf(dragged) === col.key;
            const isRepo = col.key.startsWith('repo:');
            const ri = repoCols.findIndex(c => c.key === col.key);
            const usedIn = isRepo ? cards.filter(c => c.run.route.includes(col.key.slice(5))).length : 0;
            const swap = (d: number) => {
              const other = repoCols[ri + d];
              if (!other) return;
              setConf(() => {
                const order = cols.map(c => (c.key === col.key ? other : c.key === other.key ? col : c));
                // Fjernede repo-kolonner står ikke i `cols`, men skal fortsatt være fjernet
                return [...order.map(c => ({ ...(conf.find(x => x.key === c.key) ?? c) })), ...conf.filter(c => c.removed)];
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
                  if (ok && dragged) drop(dragged, col.key);
                }}
              >
                {!editCols ? (
                  <div class="spcol-h">
                    <div class="spcol-t">
                      <span class={colIcon(col)} />
                      <span class="spcol-name">{col.name}</span>
                      <span class="mono">{colCards.length}</span>
                    </div>
                    <span class="spcol-why">{COL_WHY[col.key] ?? 'Repo'}</span>
                  </div>
                ) : (
                  <div class="spcol-h edit">
                    <div class="spcol-t">
                      <span class={colIcon(col)} />
                      <input value={col.name} onChange={e => updConf(col.key, { name: (e.target as HTMLInputElement).value })} />
                    </div>
                    <div class="spcol-tools mono">
                      <span>{isRepo ? `repo · ${usedIn} ruter` : 'utledet · fast plass'}</span>
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
                              for (const c of cards.filter(c => c.key !== NEW_KEY && c.run.route.includes(r))) byDir.set(c.dir, [...(byDir.get(c.dir) ?? []), c]);
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
                  {colCards.map(c => (
                    <SpecCard
                      key={c.key}
                      c={c}
                      col={col.key}
                      sel={sel === c.key}
                      dirty={!ro && isDirty(c)}
                      repoName={repoName}
                      me={me}
                      draggable={!ro && !editCols && c.key !== NEW_KEY}
                      dragging={drag === c.key}
                      onClick={() => onSel(sel === c.key ? null : c.key)}
                      onDragStart={e => {
                        if (e.dataTransfer) {
                          e.dataTransfer.effectAllowed = 'move';
                          e.dataTransfer.setData('text/plain', c.key);
                        }
                        setTimeout(() => setDrag(c.key), 0);
                      }}
                      onDragEnd={() => {
                        setDrag(null);
                        setOverCol(null);
                      }}
                    />
                  ))}
                  {!colCards.length && (
                    <span class="spcol-empty">{!cards.length && col.key === 'utkast' ? 'Ingen spesifikasjoner ennå. Plukk krav med «Ny spesifikasjon».' : 'Ingen spesifikasjoner'}</span>
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

      {selCard && (
        <SpecDetail
          key={selCard.key}
          c={selCard}
          col={cols.find(x => x.key === colOf(selCard)) ?? { key: colOf(selCard), name: colOf(selCard) }}
          repos={repoCols.map(c => c.key.slice(5))}
          repoName={repoName}
          cards={cards}
          entries={entries}
          ro={ro}
          dirty={!ro && isDirty(selCard)}
          me={me}
          onClose={() => onSel(null)}
          onDoc={(fn, log) => updDoc(selCard, fn, log)}
          onRun={(fn, log) => updRun(selCard, fn, log)}
          onSend={() => {
            const rute = selCard.doc.rute;
            if (!rute.length) return;
            save(selCard.path, applySpec(selCard.text, selCard.doc, { ...selCard.doc, rute: [] }, titles, `${selCard.dir}/spec`));
            writeRun(selCard, { ...selCard.run, route: [...rute], steps: rute.map(r => ({ repo: r, status: 'venter', by: '', pr: [], handoff: '', blocked: null, back: null })) }, `sendte til ${repoName(rute[0])}`);
          }}
          onOpenKrav={onOpenKrav}
          actions={actions}
        />
      )}
    </div>
  );
}

interface CardProps {
  c: Card;
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

function SpecCard({ c, col, sel, dirty, repoName, me, draggable, dragging, onClick, onDragStart, onDragEnd }: CardProps) {
  const cur = col.startsWith('repo:') ? col.slice(5) : null;
  const stp = cur ? c.run.steps.find(s => s.repo === cur) ?? null : null;
  const all = c.feats.flatMap(f => f.sc);
  const n = all.length;
  const cnt = (r: string) => all.filter(x => x.r === r).length;
  const [ok, us, no] = [cnt('funnet'), cnt('usikker'), cnt('ikke funnet')];
  const pct = (x: number) => (n ? `${Math.round((100 * x) / n)}%` : '0%');
  const fl = flags(c, dirty);
  const m = col === 'utkast' ? missingText(c) : '';
  const lastPr = stp?.pr.length ? prShort(stp.pr[stp.pr.length - 1]) : '';
  const other = !!stp?.by && stp.by !== me && !stp.by.startsWith('agent:');
  return (
    <div
      class={'spcard' + (sel ? ' sel' : '')}
      style={{ opacity: dragging ? 0.4 : 1, cursor: draggable ? 'grab' : 'pointer' }}
      draggable={draggable}
      onDragStart={onDragStart}
      onDragEnd={onDragEnd}
      onClick={onClick}
    >
      <div class="spcard-top mono">
        <span class="ell">{c.dom ? domShort(c.dom) : 'nytt domene'}</span>
        {c.doc.delta && <span class="sptag">delta</span>}
        <span class="push">{c.feats.length} feature</span>
      </div>
      <div class="spcard-title">
        <span class={c.doc.title ? '' : 'omuted'}>{c.doc.title || 'Uten tittel'}</span>
        {c.doc.skisser.length > 0 && <span class="spthumb" title={c.doc.skisser.map(k => k.name).join(', ')} />}
      </div>
      {c.run.route.length > 0 && (
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
      {m && <span class="spmissing">{m}</span>}
      <div class="spprog mono">
        <span class="spprog-bar">
          <span style={{ width: pct(ok), background: 'var(--st-implemented)' }} />
          <span style={{ width: pct(us), background: 'var(--st-in-progress)' }} />
          <span style={{ width: pct(no), background: 'var(--err)' }} />
        </span>
        <span>{ok + us + no ? `${ok}/${n} funnet` : `${n} scenarioer`}</span>
      </div>
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

const missingText = (c: Card) => {
  const m = missing(c);
  return m.length ? 'Mangler: ' + m.join(' · ') : '';
};
