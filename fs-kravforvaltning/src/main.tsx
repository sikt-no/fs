import { render } from 'preact';
import { useEffect, useMemo, useRef, useState } from 'preact/hooks';
import type { ClaudeStatus, MainStatus } from '../shared/api';
import type { Entry, FeatureModel, FocusEvent, GitInfo, Scen, Snapshot, Step, UpdateEvent } from '../shared/model';
import { RULE } from '../shared/rules';
import { buildTasks, type TasksSnapshot } from '../shared/tasks';
import { Avvik } from './Avvik';
import { changedFile } from './edit';
import { Editor, type EditorFlush } from './Editor';
import { fixed, NO_FILTER, type Filter } from './health';
import { FeatureView, scenKey, stepKey } from './FeatureView';
import { findGroups, findHits } from './find';
import { headings, parseMd } from './markdown';
import { MainBanner } from './MainBanner';
import { bannerShown } from './mainStatus';
import { MarkdownView, type MdMode } from './MarkdownView';
import { Oppgaver, taskKey, type OView } from './Oppgaver';
import { Outline } from './Outline';
import { PrDialog, proposeDraft } from './PrDialog';
import type { PrProposal } from './prProposal';
import { CLAUDE_WIDTH, ClaudePanel } from './ClaudePanel';
import { refreshSkills } from './ClaudeSkills';
import { buildTree, Sidebar, type TreeMode } from './Sidebar';
import { StatusBar } from './StatusBar';
import { TopBar, type Mode, type Theme } from './TopBar';
import { transport } from './transport';
import './theme.css';

// Startdata: bakt inn i nettleserbygget (virtual:krav*), hentet over IPC i desktop-appen
const boot = await transport.boot();
const initial = boot.entries;
const initialGit = boot.git;
const initialTasks = boot.tasks;
/**
 * Skillene Claude kan bruke i hver visning. Krav: fs-krav (standard), fs-krav-avvik og fs-verify. Avvik: fs-krav
 * (standard) og fs-krav-avvik.
 * I Oppgaver er ingen valgt på forhånd, og uten valg kan Claude bruke alle de fire. `codeDirs`: Claude
 * kan lese kodeklonene (fs-admin, fs-plattform), som fs-verify trenger.
 */
const CLAUDE_SKILLS_BY_MODE: Record<Mode, { allowed: string[]; preselect: boolean; codeDirs: boolean }> = {
  krav: { allowed: ['fs-krav', 'fs-krav-avvik', 'fs-verify'], preselect: true, codeDirs: true },
  avvik: { allowed: ['fs-krav', 'fs-krav-avvik'], preselect: true, codeDirs: false },
  oppgaver: { allowed: ['fs-krav', 'fs-specify', 'fs-specify-delta', 'fs-verify'], preselect: false, codeDirs: true },
};
const MODE_LABEL: Record<Mode, string> = { krav: 'Krav', avvik: 'Avvik', oppgaver: 'Oppgaver' };
/** Hvorfor en skill ikke kan velges i `mode`: «brukes i Krav og Oppgaver, ikke i Avvik» */
const skillHint = (mode: Mode) => (skill: string) => {
  const where = (Object.keys(CLAUDE_SKILLS_BY_MODE) as Mode[]).filter(m => CLAUDE_SKILLS_BY_MODE[m].allowed.includes(skill)).map(m => MODE_LABEL[m]);
  return `brukes i ${where.join(' og ') || 'ingen visninger'}, ikke i ${MODE_LABEL[mode]}`;
};
/** Krav kan redigeres og sendes som PR (dev-serveren og desktop-appen) */
const EDITABLE = boot.editable;

// localStorage kan være utilgjengelig (privat vindu, blokkert lagring)
function load<T>(key: string, fallback: T): T {
  try {
    const v = localStorage.getItem('kravforvaltning:' + key);
    return v === null ? fallback : (JSON.parse(v) as T);
  } catch {
    return fallback;
  }
}
function save(key: string, value: unknown) {
  try {
    localStorage.setItem('kravforvaltning:' + key, JSON.stringify(value));
  } catch {
    /* ignorer */
  }
}

// Temaet settes før første tegning, så vieweren ikke starter i feil tema
document.documentElement.dataset.theme = load<Theme | null>('theme', null) ?? (matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');

const fromHash = () => decodeURIComponent(location.hash.replace(/^#\/?/, ''));

// Uten hash (desktop-appen starter alltid slik, og en ny fane i nettleseren) går vieweren tilbake dit
// brukeren var sist: fila, avviksdashbordet eller oppgaven. En fil som er borte, gir forsiden som før.
if (!location.hash) {
  const last = load<string | null>('hash', null);
  if (last?.startsWith('#/')) history.replaceState(null, '', last);
}
const ancestors = (path: string) => {
  const parts = path.split('/').slice(0, -1);
  return parts.map((_, i) => parts.slice(0, i + 1).join('/'));
};

/**
 * Kjører `fn` med egenskapshodet i kompakt tilstand (uten animasjon), slik siden ser ut når et hopp er ferdig.
 * Hodet ligger i flyten, så sammenslåingen flytter også innholdet under; posisjoner må derfor måles slik.
 * `offset` er høyden som dekkes av sticky feilbanner og hode, pluss litt luft.
 */
function asCompact<T>(main: HTMLElement, fn: (offset: number) => T): T {
  const head = main.querySelector<HTMLElement>('.fhead');
  const was = head?.classList.contains('compact');
  head?.classList.add('measure', 'compact');
  const banner = main.querySelector<HTMLElement>('.errbanner')?.offsetHeight ?? 0;
  const out = fn(banner + (head?.offsetHeight ?? 0) + 16);
  if (head) {
    if (!was) head.classList.remove('compact');
    void head.offsetHeight; // flush før animasjonene slås på igjen, så tilbakestillingen ikke animeres
    head.classList.remove('measure');
  }
  return out;
}

/** Oppgaver-modusen i hashen: `#/oppgaver` (tavle), `#/oppgaver/<dom>/<slug>` (mappe), `#/oppgaver/tavle/<dom>/<slug>` (tavle med panel) */
interface OState {
  view: OView;
  sel: string | null;
  panel: boolean;
}
/** Oppgaver-modusen finnes bare når dev-serveren er startet med `--mode oppgaver` (eller `OPPGAVER=1`) */
const OPPGAVER = initialTasks !== null;
function parseOppgaverHash(h: string): OState | null {
  if (!OPPGAVER) return null;
  if (h !== 'oppgaver' && !h.startsWith('oppgaver/')) return null;
  const rest = h.split('/').slice(1).filter(Boolean);
  if (rest[0] === 'tavle') return rest.length >= 3 ? { view: 'tavle', sel: rest.slice(1, 3).join('/'), panel: true } : { view: 'tavle', sel: null, panel: false };
  if (rest[0] === 'mappe' && rest.length === 1) return { view: 'mappe', sel: null, panel: false };
  if (rest.length >= 2) return { view: 'mappe', sel: rest.slice(0, 2).join('/'), panel: false };
  return { view: 'tavle', sel: null, panel: false };
}
function oppgaverHash(o: OState) {
  if (o.view === 'tavle') return '#/oppgaver' + (o.panel && o.sel ? '/tavle/' + encodeURI(o.sel) : '');
  return '#/oppgaver/' + (o.sel ? encodeURI(o.sel) : 'mappe');
}

/** Forsiden: krav/README.md */
const README = 'krav/README.md';

function defaultPath(entries: Snapshot) {
  if (entries['krav/README.md']) return 'krav/README.md';
  return Object.keys(entries).sort()[0] ?? '';
}

/** Samme innhold i fila som før (bare lagret eller skrevet på nytt) */
function sameContent(prev: Entry | undefined, next: Entry) {
  if (!prev) return false;
  if (next.kind === 'md') return prev.source === next.source;
  return prev.error === next.error && JSON.stringify(prev.model) === JSON.stringify(next.model);
}

/** Nøkler for steg som er nye eller endret siden forrige versjon. */
function changedSteps(prev: FeatureModel | undefined, next: FeatureModel | undefined): string[] {
  if (!prev || !next) return [];
  const sig = (s: Scen, st: Step) => [s.kind, s.name, st.kw, st.text, JSON.stringify(st.table ?? null), st.doc ?? ''].join('\u0000');
  const old = new Map<string, number>();
  prev.rules.forEach(r => r.scenarios.forEach(s => s.steps.forEach(st => old.set(sig(s, st), (old.get(sig(s, st)) ?? 0) + 1))));
  const out: string[] = [];
  next.rules.forEach((r, ri) =>
    r.scenarios.forEach((s, si) =>
      s.steps.forEach((st, ti) => {
        const n = old.get(sig(s, st)) ?? 0;
        if (n > 0) old.set(sig(s, st), n - 1);
        else out.push(stepKey(ri, si, ti));
      }),
    ),
  );
  return out;
}

function App() {
  const [entries, setEntries] = useState<Snapshot>(initial);
  const [current, setCurrent] = useState(() => (initial[fromHash()] ? fromHash() : defaultPath(initial)));
  // #/avvik er avviksdashbordet, #/oppgaver… er oppgavene; alle andre hasher er en fil
  const [mode, setMode] = useState<Mode>(() => (fromHash() === 'avvik' ? 'avvik' : parseOppgaverHash(fromHash()) ? 'oppgaver' : 'krav'));
  const [tasksSnap, setTasksSnap] = useState<TasksSnapshot>(initialTasks ?? { domains: {}, tasks: [] });
  const [oState, setOState] = useState<OState>(() => parseOppgaverHash(fromHash()) ?? { view: 'tavle', sel: null, panel: false });
  const [avvikFilter, setAvvikFilter] = useState<Filter>(NO_FILTER);
  const [fixMsg, setFixMsg] = useState<string | null>(null);
  // Overskriften i README-en som «Les regelen» skal hoppe til når forsiden er vist
  const [pendingSection, setPendingSection] = useState<string | null>(null);
  const [theme, setTheme] = useState<Theme>(() =>
    load<Theme | null>('theme', null) ?? (matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'),
  );
  const [openDirs, setOpenDirs] = useState<Record<string, boolean>>(() => load('open', { krav: true }));
  const [query, setQuery] = useState('');
  const [collapsed, setCollapsed] = useState<Record<string, Record<string, boolean>>>({});
  const [flash, setFlash] = useState<Set<string>>(new Set());
  const [updated, setUpdated] = useState(false);
  const [lineNumbers, setLineNumbers] = useState(() => load('lineNumbers', true));
  const [treeHidden, setTreeHidden] = useState(() => load('treeHidden', false));
  const [tocHidden, setTocHidden] = useState(() => load('tocHidden', false));
  // Søket i fila (Cmd/Ctrl+F): søketeksten, gjeldende treff, og scenarioer brukeren har lukket mens søket står
  const [find, setFind] = useState<{ q: string; cur: number; closed: Record<string, boolean> }>({ q: '', cur: 0, closed: {} });
  // Claude-panelet: den lokale Claude Code-en, når den finnes (dev-serveren og desktop-appen)
  const [claude, setClaude] = useState<ClaudeStatus | null>(null);
  const [claudeOpen, setClaudeOpen] = useState(() => load('claudeOpen', false));
  useEffect(() => save('claudeOpen', claudeOpen), [claudeOpen]);
  const [claudeWidth, setClaudeWidth] = useState(() => load('claudeWidth', CLAUDE_WIDTH));
  useEffect(() => save('claudeWidth', claudeWidth), [claudeWidth]);
  useEffect(() => {
    if (EDITABLE) transport.call('claudeStatus').then(setClaude, () => setClaude(null));
  }, []);
  const [treeMode, setTreeMode] = useState<TreeMode>(() => load('treeMode', 'files'));
  const [mdMode, setMdMode] = useState<MdMode>(() => load('mdMode', 'pretty'));
  const [git, setGit] = useState<GitInfo | null>(initialGit);
  const [connected, setConnected] = useState(transport.live);
  const [editing, setEditing] = useState(false);
  // «Lag PR» i detaljvinduet: `false` er lukket, `null` åpnet fra sidebaren, en sti åpnet fra fila (som da er valgt)
  const [prFor, setPrFor] = useState<string | null | false>(false);
  // Øker for hvert PR-forslag fra Claude, så «Lag PR» monteres på nytt og leser det nye utkastet
  const [prSeq, setPrSeq] = useState(0);
  // Editoren lagrer ulagrede endringer før brukeren går til en annen fil eller visning
  const editorFlush = useRef<EditorFlush | null>(null);
  const [focus, setFocus] = useState<(FocusEvent & { seq: number }) | null>(null);
  const focusedKey = useRef<string | null>(null);
  const mainRef = useRef<HTMLElement>(null);
  const state = useRef({ entries, current, mode });
  state.current = { entries, current, mode };

  const entry = entries[current];
  const tree = useMemo(() => buildTree(entries), [entries]);
  const md = useMemo(() => (entry?.kind === 'md' ? parseMd(entry.source ?? '') : null), [entry]);
  const nBad = useMemo(() => Object.values(entries).filter(e => e.kind === 'feature' && e.path.startsWith('krav/') && e.lint).length, [entries]);
  const tasks = useMemo(() => buildTasks(tasksSnap), [tasksSnap]);
  const nActive = tasks.filter(t => t.p < 4).length;

  useEffect(() => {
    document.documentElement.dataset.theme = theme;
  }, [theme]);
  useEffect(() => save('open', openDirs), [openDirs]);
  useEffect(() => save('lineNumbers', lineNumbers), [lineNumbers]);
  useEffect(() => save('treeHidden', treeHidden), [treeHidden]);
  useEffect(() => save('tocHidden', tocHidden), [tocHidden]);
  useEffect(() => save('treeMode', treeMode), [treeMode]);
  useEffect(() => save('mdMode', mdMode), [mdMode]);
  useEffect(() => {
    const onUnload = (e: BeforeUnloadEvent) => {
      if (editorFlush.current?.dirty()) e.preventDefault();
    };
    addEventListener('beforeunload', onUnload);
    return () => removeEventListener('beforeunload', onUnload);
  }, []);

  // Hash-ruting: #/krav/…/fil.feature
  useEffect(() => {
    if (state.current.mode === 'krav' && fromHash() !== current) history.replaceState(null, '', '#/' + encodeURI(current));
    setOpenDirs(o => (ancestors(current).every(a => o[a]) ? o : { ...o, ...Object.fromEntries(ancestors(current).map(a => [a, true])) }));
    mainRef.current?.scrollTo({ top: 0 });
    focusedKey.current = null;
    setFind({ q: '', cur: 0, closed: {} });
  }, [current]);
  // Husk hvor brukeren er, til neste gang vieweren åpnes uten hash
  useEffect(() => save('hash', location.hash), [current, mode, oState]);

  // Følg markøren i VS Code: scroll til regelen/scenarioet som inneholder linjen
  useEffect(() => {
    const model = entry?.model;
    if (!focus || focus.path !== current || focus.line === null || !model) return;
    let key = 'top'; // markøren står i tittel/fortelling
    let best = 0;
    model.rules.forEach((r, ri) => {
      if (r.name !== null && r.ln <= focus.line! && r.ln >= best) [key, best] = [`rule:${ri}`, r.ln];
      r.scenarios.forEach((s, si) => {
        if (s.ln <= focus.line! && s.ln >= best) [key, best] = [scenKey(ri, si), s.ln];
      });
    });
    // Nytt scenario: scroll det til toppen. Samme scenario: bare hold markert linje synlig, så visningen ikke hopper
    const moved = key !== focusedKey.current;
    focusedKey.current = key;
    const k = key;
    if (k !== 'top' && !k.startsWith('rule:')) {
      setCollapsed(c => (c[current]?.[k] ? { ...c, [current]: { ...c[current], [k]: false } } : c));
    }
    requestAnimationFrame(() => {
      const main = mainRef.current;
      if (!main) return;
      const pos = (el: HTMLElement) => main.scrollTop + el.getBoundingClientRect().top - main.getBoundingClientRect().top;
      const marked = main.querySelector<HTMLElement>('.cursor');
      const view = main.clientHeight - 40;
      if (!moved) {
        const y = marked && pos(marked);
        if (marked && y !== null && (y < main.scrollTop || y + marked.offsetHeight > main.scrollTop + view)) {
          marked.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
        }
        return;
      }
      const sel = k.startsWith('rule:') ? `[data-rule="${k.slice(5)}"]` : `[data-scen="${k}"]`;
      const el = k === 'top' ? null : main.querySelector<HTMLElement>(sel);
      if (!el) return main.scrollTo({ top: 0, behavior: 'smooth' });
      const top = asCompact(main, offset => {
        const t = pos(el) - offset;
        // Lange scenarioer: sørg for at den markerte linjen også kommer med
        return marked && pos(marked) + marked.offsetHeight > t + view ? pos(marked) - main.clientHeight / 3 : t;
      });
      main.scrollTo({ top, behavior: 'smooth' });
    });
  }, [focus, entry, current]);
  const mark =
    focus && focus.path === current && focus.line !== null ? { from: focus.line, to: focus.to ?? focus.line } : null;

  // Søket i fila: treffene i modellen, så også lukkede scenarioer telles og åpnes
  const findModel = entry?.kind === 'feature' ? entry.model : undefined;
  const findResult = useMemo(() => (findModel && find.q.trim() ? findHits(findModel, find.q) : null), [findModel, find.q]);
  const findTotal = findResult?.hits.length ?? 0;
  const findCur = Math.min(find.cur, Math.max(0, findTotal - 1));
  const groups = useMemo(() => findGroups(findResult?.hits ?? []), [findResult]);
  // Går til et treff; et scenario brukeren har lukket under søket, åpnes igjen når treffet står der
  const findGo = (next: (cur: number) => number) =>
    setFind(f => {
      const cur = next(Math.min(f.cur, findTotal - 1));
      const scen = findResult?.hits[cur]?.scen;
      if (!scen || !f.closed[scen]) return { ...f, cur };
      const { [scen]: _, ...closed } = f.closed;
      return { ...f, cur, closed };
    });
  const findStep = (d: 1 | -1) => findTotal && findGo(c => (c + d + findTotal) % findTotal);
  const findRef = useRef({ can: false, active: false, step: findStep });
  findRef.current = { can: mode === 'krav' && !editing && prFor === false && !!findModel, active: findTotal > 0, step: findStep };
  // Cmd/Ctrl+F åpner innholdspanelet og søkefeltet; Cmd/Ctrl+G går til neste treff (med Shift: forrige)
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      const k = e.key.toLowerCase();
      if (!(e.metaKey || e.ctrlKey) || e.altKey || (k !== 'f' && k !== 'g')) return;
      if (!findRef.current.can || (e.target as Element | null)?.tagName === 'TEXTAREA') return;
      if (k === 'f') {
        e.preventDefault();
        const focus = () => {
          const input = document.querySelector<HTMLInputElement>('input[data-find]');
          input?.focus();
          input?.select();
          return !!input;
        };
        // Panelet er skjult: vis det først, og fokuser når feltet er tegnet
        if (!focus()) {
          setTocHidden(false);
          setTimeout(focus, 30);
        }
      } else if (findRef.current.active) {
        e.preventDefault();
        findRef.current.step(e.shiftKey ? -1 : 1);
      }
    };
    addEventListener('keydown', onKey);
    return () => removeEventListener('keydown', onKey);
  }, []);
  // Hopp til gjeldende treff når det ikke er synlig: 30 % ned under egenskapshodet
  useEffect(() => {
    if (!findTotal) return;
    requestAnimationFrame(() => {
      const main = mainRef.current;
      const el = main?.querySelector<HTMLElement>(`[data-hit="f-${findCur}"]`);
      if (!main || !el) return;
      const top = asCompact(main, offset => {
        const y = main.scrollTop + el.getBoundingClientRect().top - main.getBoundingClientRect().top;
        const shown = y >= main.scrollTop + offset && y + el.offsetHeight <= main.scrollTop + main.clientHeight - 48;
        return shown ? null : Math.max(0, y - offset - (main.clientHeight - offset) * 0.3);
      });
      if (top !== null) main.scrollTo({ top, behavior: 'smooth' });
    });
  }, [find.q, findCur, current, findTotal > 0]);
  useEffect(() => {
    const onHash = () => {
      const p = fromHash();
      const o = parseOppgaverHash(p);
      if (p === 'avvik') setMode('avvik');
      else if (o) {
        setMode('oppgaver');
        setOState(o);
      } else if (state.current.entries[p]) {
        setMode('krav');
        setCurrent(p);
      }
    };
    addEventListener('hashchange', onHash);
    return () => removeEventListener('hashchange', onHash);
  }, []);

  // Live-oppdateringer fra Vite-pluginen eller desktop-appen
  useEffect(() => {
    if (!transport.live) return;
    let timer: ReturnType<typeof setTimeout> | undefined;
    let fixTimer: ReturnType<typeof setTimeout> | undefined;
    const onUpdate = ({ path, entry: next }: UpdateEvent) => {
      const prev = state.current.entries[path];
      // Avvik som forsvant ved lagringen: «↻ Mangler status rettet i fil.feature»
      const gone = prev?.model && next?.model && !next.error ? fixed(prev.model.lint, next.model.lint) : [];
      if (gone.length) {
        const what = gone.length === 1 ? RULE[gone[0]]?.label ?? gone[0] : `${gone.length} avvik`;
        setFixMsg(`${what} rettet i ${path.slice(path.lastIndexOf('/') + 1)}`);
        clearTimeout(fixTimer);
        fixTimer = setTimeout(() => setFixMsg(null), 2600);
      }
      setEntries(e => {
        const copy = { ...e };
        if (next) copy[path] = next;
        else delete copy[path];
        return copy;
      });
      // Samme innhold som vi har (f.eks. watcheren etter «Hent siste», som allerede har byttet inn filene): ingen markering
      if (path !== state.current.current || !next || sameContent(prev, next)) return;
      const keys = next.error ? [] : changedSteps(prev?.model, next.model);
      if (keys.length) {
        // Åpne scenarioene som inneholder endringer
        setCollapsed(c => {
          const mine = { ...c[path] };
          keys.forEach(k => delete mine[k.split('-').slice(0, 2).join('-')]);
          return { ...c, [path]: mine };
        });
      }
      setFlash(new Set(keys));
      setUpdated(true);
      clearTimeout(timer);
      timer = setTimeout(() => {
        setFlash(new Set());
        setUpdated(false);
      }, 1800);
    };
    let seq = 0;
    const onFocus = (f: FocusEvent) => {
      // Avviksdashbordet og oppgavene følger ikke markøren i VS Code
      if (!state.current.entries[f.path] || state.current.mode !== 'krav') return;
      if (f.path !== state.current.current) {
        setCurrent(f.path);
        history.pushState(null, '', '#/' + encodeURI(f.path));
      }
      setFocus({ ...f, seq: ++seq });
    };
    const onBlur = () => setFocus(null);
    const onConnect = () => setConnected(true);
    const onDisconnect = () => setConnected(false);
    const off = [
      transport.on('krav:update', onUpdate),
      transport.on('krav:git', setGit),
      transport.on('krav:tasks', setTasksSnap),
      transport.on('krav:focus', onFocus),
      transport.on('krav:blur', onBlur),
      transport.on('krav:connect', onConnect),
      transport.on('krav:disconnect', onDisconnect),
    ];
    return () => {
      clearTimeout(timer);
      clearTimeout(fixTimer);
      off.forEach(f => f());
    };
  }, []);

  /** Lagrer ulagrede endringer i editoren før brukeren går videre. `false`: lagringen feilet, bli der. */
  const leaveEditor = async () => {
    try {
      await editorFlush.current?.flush();
      return true;
    } catch (e) {
      alert(`Kunne ikke lagre endringene: ${(e as Error).message}`);
      return false;
    }
  };
  // Desktop-appen: sjekk om main på GitHub er nyere enn klonen, ved oppstart, hvert tiende minutt og når
  // vinduet får fokus (høyst hvert andre minutt). Da vises banneret «Det finnes en ny versjon av main» og knappen
  // i toppfeltet. «Senere» skjuler banneret til main får en ny commit (`mainLater` er commiten det gjaldt).
  const [mainStatus, setMainStatus] = useState<MainStatus | null>(null);
  const [mainLater, setMainLater] = useState<string | null>(() => load('mainLater', null));
  const [pulling, setPulling] = useState(false);
  useEffect(() => {
    if (transport.kind !== 'electron') return;
    let last = 0;
    const check = () => {
      last = Date.now();
      transport.call('mainStatus').then(setMainStatus, () => {});
    };
    const onFocus = () => Date.now() - last > 2 * 60_000 && check();
    check();
    const timer = setInterval(check, 10 * 60_000);
    addEventListener('focus', onFocus);
    return () => {
      clearInterval(timer);
      removeEventListener('focus', onFocus);
    };
  }, []);
  // Desktop-appen: hent siste main, og bytt inn de nye filene uten å laste vieweren på nytt (det blinker,
  // og folding, scroll og søket i fila går tapt)
  const pull = async () => {
    if (pulling || !(await leaveEditor())) return;
    setPulling(true);
    try {
      const res = await transport.call('pull');
      setEntries(res.entries);
      setGit(res.git);
      if (res.tasks) setTasksSnap(res.tasks);
      if (!res.entries[state.current.current]) setCurrent(defaultPath(res.entries));
      setMainStatus({ behind: false });
      transport.call('mainStatus').then(setMainStatus, () => {});
      // «Hent siste» kan ha endret skillene: samtaler som lastet en eldre versjon, får varsel
      void refreshSkills();
    } catch (e) {
      alert((e as Error).message);
    } finally {
      setPulling(false);
    }
  };
  const later = () => {
    const sha = mainStatus?.remote ?? null;
    setMainLater(sha);
    save('mainLater', sha);
  };
  const select = async (path: string, line?: number) => {
    if (path !== state.current.current && !(await leaveEditor())) return;
    setPrFor(false);
    setMode('krav');
    setCurrent(path);
    history.pushState(null, '', '#/' + encodeURI(path));
    // Scenariotreff fra søket: gjenbruk fokus fra VS Code for å scrolle til og åpne scenarioet
    if (line) setFocus({ path, line, to: line, seq: Date.now() });
  };
  /** Viser mappa i treet: Krav-modus, filtreet uten søk, og mappa og alle over den åpne */
  const reveal = (dir: string) => {
    setMode('krav');
    setTreeHidden(false);
    setTreeMode('files');
    setQuery('');
    setOpenDirs(o => {
      const next = { ...o };
      for (let p = dir; p.includes('/'); p = p.slice(0, p.lastIndexOf('/'))) next[p] = true;
      return { ...next, krav: true };
    });
  };
  const jump = (key: string) => {
    const main = mainRef.current;
    // «q» = første blokk med åpne spørsmål; åpne kortet den ligger i hvis det er foldet sammen
    if (key === 'q') {
      const first = entry?.model?.questions[0];
      const model = entry?.model;
      if (first && model) {
        model.rules.forEach((r, ri) =>
          r.scenarios.forEach((s, si) => {
            const k = scenKey(ri, si);
            if (s.notes.some(n => n.items.some(i => i.ln === first.ln)))
              setCollapsed(c => ({ ...c, [current]: { ...c[current], [k]: false } }));
          }),
        );
      }
    }
    if (key.startsWith('md-')) setMdMode('pretty');
    requestAnimationFrame(() => {
      const el = main?.querySelector<HTMLElement>(key === 'q' ? '[data-q]' : `[data-rule="${key}"]`);
      if (main && el) {
        const top = asCompact(main, offset => main.scrollTop + el.getBoundingClientRect().top - main.getBoundingClientRect().top - offset);
        main.scrollTo({ top, behavior: 'smooth' });
      }
    });
  };
  // «Les regelen»: hopp til overskriften når README-en er vist
  useEffect(() => {
    if (!pendingSection || mode !== 'krav' || current !== README || !md) return;
    const i = md.findIndex(b => (b.type === 'h2' || b.type === 'h3') && b.text === pendingSection);
    setPendingSection(null);
    if (i >= 0) jump('md-' + i);
  }, [pendingSection, mode, current, md]);
  const readRule = (section: string) => {
    if (current !== README || mode !== 'krav') select(README);
    setPendingSection(section);
  };
  const changeMode = async (m: Mode) => {
    if (m === mode || !(await leaveEditor())) return;
    if (m === 'avvik') {
      setMode('avvik');
      history.pushState(null, '', '#/avvik');
    } else if (m === 'oppgaver') {
      setMode('oppgaver');
      history.pushState(null, '', oppgaverHash(oState));
    } else if (mode === 'avvik' && avvikFilter.file && entries[avvikFilter.file]) select(avvikFilter.file); // fila som er valgt i dashbordet
    else {
      setMode('krav');
      history.pushState(null, '', '#/' + encodeURI(current));
    }
  };
  // Endringen i git for en fil, til filene på PR-kortet i Claude-panelet (ucommittet først, som i «Lag PR»)
  const gitChange = useMemo(() => {
    const m = new Map((git ? [...git.committed, ...git.uncommitted] : []).map(c => [c.path, c]));
    return (p: string) => m.get(p);
  }, [git]);
  // «Åpne i «Lag PR»» på et forslag fra Claude: forslaget blir utkastet, og «Lag PR» åpnes i Krav
  const proposePr = async (p: PrProposal) => {
    if (!(await leaveEditor())) return;
    proposeDraft(p);
    if (mode !== 'krav') {
      setMode('krav');
      history.pushState(null, '', '#/' + encodeURI(current));
    }
    setPrSeq(n => n + 1);
    setPrFor(null);
  };
  const setOppgaver = (o: OState) => {
    setOState(o);
    history.pushState(null, '', oppgaverHash(o));
  };
  // Oppgaven Mappe viser: den valgte, ellers den første som ikke er levert
  const shownTask = tasks.find(t => taskKey(t) === oState.sel) ?? tasks.find(t => t.p < 4) ?? tasks[0];
  const oCrumbs = oState.view === 'tavle' ? ['tasks', '*/roadmap.md'] : shownTask ? ['tasks', shownTask.dom, shownTask.slug] : ['tasks'];
  const allScenKeys = () => entry?.model?.rules.flatMap((r, ri) => r.scenarios.map((_, si) => scenKey(ri, si))) ?? [];
  const fileName = current.slice(current.lastIndexOf('/') + 1);
  // «Lag PR» i filvisningen: bare for en fil med endringer
  const filePr = EDITABLE && changedFile(git, current) ? () => setPrFor(current) : undefined;
  // Claude-panelet: samme samtale i alle visningene, med skills og fil-kontekst for visningen man er i
  const claudeShown = !!claude && claudeOpen;
  const claudeSkills = CLAUDE_SKILLS_BY_MODE[mode];
  // I Oppgaver: oppgaven som er valgt (mappa, eller panelet i tavla), ikke en tilfeldig i tavla
  const claudeTask = oState.view === 'mappe' || oState.panel ? shownTask : undefined;
  const claudePath =
    mode === 'krav' ? (entry ? current : null)
    : mode === 'avvik' ? (avvikFilter.file ?? null)
    : claudeTask ? `tasks/${claudeTask.dom}/${claudeTask.slug}` : null;

  return (
    <div class="app">
      <TopBar
        path={current}
        connected={connected}
        theme={theme}
        onTheme={t => {
          setTheme(t);
          save('theme', t);
        }}
        treeHidden={treeHidden}
        onToggleTree={() => setTreeHidden(v => !v)}
        tocHidden={tocHidden}
        onToggleToc={() => setTocHidden(v => !v)}
        onHome={() => {
          const home = defaultPath(entries);
          if (home === current && mode === 'krav') mainRef.current?.scrollTo({ top: 0, behavior: 'smooth' });
          else select(home);
        }}
        mode={mode}
        onMode={changeMode}
        nBad={nBad}
        oppgaver={OPPGAVER}
        nActive={nActive}
        oView={oState.view}
        onOView={view => setOppgaver({ ...oState, view, sel: oState.sel ?? (shownTask ? taskKey(shownTask) : null) })}
        oCrumbs={oCrumbs}
        claude={claude ? claudeOpen : null}
        onClaude={() => setClaudeOpen(o => !o)}
        onUpdate={mainStatus?.behind ? pull : null}
        pulling={pulling}
      />
      {bannerShown(mainStatus, mainLater) && <MainBanner info={mainStatus?.info} pulling={pulling} onLater={later} onPull={pull} />}
      <div
        class="workspace"
        // Et smalere vindu enn sist: panelet tar aldri mer enn 70 % av bredden
        style={claudeShown ? { '--claude-w': `min(${claudeWidth}px, 70vw)` } : undefined}
      >
        {mode === 'oppgaver' ? (
          <Oppgaver
            tasks={tasks}
            entries={entries}
            view={oState.view}
            sel={oState.sel}
            panel={oState.panel}
            onSel={(sel, view, panel) => setOppgaver({ sel, view, panel })}
            onClosePanel={() => setOppgaver({ ...oState, panel: false })}
            onOpenKrav={path => select(path)}
          />
        ) : mode === 'avvik' ? (
          <Avvik entries={entries} filter={avvikFilter} onFilter={setAvvikFilter} onOpen={select} onReadRule={readRule} panelHidden={treeHidden} />
        ) : (
          <div class={'grid' + (treeHidden ? ' notree' : '') + (tocHidden ? ' notoc' : '')}>
            {!treeHidden && (
              <Sidebar
                entries={entries}
                tree={tree}
                current={current}
                open={openDirs}
                query={query}
                onQuery={setQuery}
                onToggle={p => setOpenDirs(o => ({ ...o, [p]: !o[p] }))}
                onSelect={select}
                mode={git ? treeMode : 'files'}
                onMode={setTreeMode}
                git={git}
                onPr={EDITABLE && git ? () => setPrFor(null) : undefined}
                onPull={transport.kind === 'electron' ? pull : undefined}
                pulling={pulling}
              />
            )}
            <main
              class="main"
              ref={mainRef}
              // Klikk utenfor et kort fjerner markeringen fra VS Code
              onClick={e => {
                if (focus && !(e.target as Element).closest('.card')) setFocus(null);
              }}
            >
              {prFor !== false && git ? (
                <PrDialog key={prSeq} git={git} entries={entries} preselect={prFor ?? undefined} onClose={() => setPrFor(false)} />
              ) : editing && current ? (
                <Editor
                  path={current}
                  entry={entry}
                  onClose={() => setEditing(false)}
                  onFlush={f => (editorFlush.current = f)}
                  changed={changedFile(git, current)}
                  onPr={EDITABLE && git ? () => setPrFor(current) : undefined}
                />
              ) : !entry ? (
                <div class="empty">
                  <div class="mono" style={{ color: 'var(--ink)' }}>{fileName || 'krav'}</div>
                  <div>{fileName ? 'Filen finnes ikke lenger.' : 'Velg en fil i treet.'}</div>
                </div>
              ) : md ? (
                <MarkdownView
                  entry={entry}
                  blocks={md}
                  mode={mdMode}
                  onMode={setMdMode}
                  has={p => !!entries[p]}
                  onNavigate={select}
                  onEdit={EDITABLE ? () => setEditing(true) : undefined}
                  onPr={filePr}
                />
              ) : (
                <FeatureView
                  entry={entry}
                  collapsed={collapsed[current] ?? {}}
                  flash={flash}
                  lineNumbers={lineNumbers}
                  mark={mark}
                  mainRef={mainRef}
                  onLine={ln => select(current, ln)}
                  onToggle={k => setCollapsed(c => ({ ...c, [current]: { ...c[current], [k]: !c[current]?.[k] } }))}
                  find={findResult && { result: findResult, cur: findCur }}
                  findClosed={find.closed}
                  onFindClose={k => setFind(f => ({ ...f, closed: { ...f.closed, [k]: true } }))}
                  onEdit={EDITABLE ? () => setEditing(true) : undefined}
                  onPr={filePr}
                />
              )}
            </main>
            {!tocHidden && (
              <Outline
                model={entry?.model}
                headings={md ? headings(md) : undefined}
                onJump={jump}
                onFoldAll={() => setCollapsed(c => ({ ...c, [current]: Object.fromEntries(allScenKeys().map(k => [k, true])) }))}
                onOpenAll={() => setCollapsed(c => ({ ...c, [current]: {} }))}
                find={
                  findModel && !editing && prFor === false
                    ? {
                        q: find.q,
                        onQ: q => setFind({ q, cur: 0, closed: {} }),
                        groups,
                        total: findTotal,
                        cur: findCur,
                        onCur: cur => findGo(() => cur),
                        onStep: findStep,
                        onClear: () => setFind({ q: '', cur: 0, closed: {} }),
                      }
                    : undefined
                }
              />
            )}
          </div>
        )}
        {claude && claudeShown && (
          // Panelet ligger utenfor visningene, så samtalen følger med mellom Krav, Avvik og Oppgaver
          <ClaudePanel
            status={claude}
            width={claudeWidth}
            onWidth={setClaudeWidth}
            allowedSkills={claudeSkills.allowed}
            skillHint={skillHint(mode)}
            preselect={claudeSkills.preselect}
            codeDirs={claudeSkills.codeDirs}
            path={claudePath}
            entries={entries}
            has={p => !!entries[p]}
            onOpen={p => select(p)}
            onReveal={reveal}
            onPr={EDITABLE && git ? proposePr : undefined}
            change={gitChange}
            onClose={() => setClaudeOpen(false)}
          />
        )}
      </div>
      <StatusBar
        connected={connected}
        live={transport.live}
        origin={transport.kind === 'electron' ? 'desktop-app' : `vite · ${location.host}`}
        fileName={fileName}
        savedAt={entry?.savedAt}
        updated={updated}
        lineNumbers={lineNumbers}
        onLineNumbers={() => setLineNumbers(v => !v)}
        avvik={mode !== 'krav'}
        fixMsg={fixMsg}
      />
    </div>
  );
}

render(<App />, document.getElementById('app')!);
