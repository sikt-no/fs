import { render } from 'preact';
import { useEffect, useMemo, useRef, useState } from 'preact/hooks';
import initial from 'virtual:krav';
import initialGit from 'virtual:krav-git';
import type { FeatureModel, FocusEvent, GitInfo, Scen, Snapshot, Step, UpdateEvent } from '../shared/model';
import { FeatureView, scenKey, stepKey } from './FeatureView';
import { Outline } from './Outline';
import { buildTree, Sidebar, type TreeMode } from './Sidebar';
import { StatusBar } from './StatusBar';
import { TopBar, type Theme } from './TopBar';
import './theme.css';

// localStorage kan være utilgjengelig (privat vindu, blokkert lagring)
function load<T>(key: string, fallback: T): T {
  try {
    const v = localStorage.getItem('krav-viewer:' + key);
    return v === null ? fallback : (JSON.parse(v) as T);
  } catch {
    return fallback;
  }
}
function save(key: string, value: unknown) {
  try {
    localStorage.setItem('krav-viewer:' + key, JSON.stringify(value));
  } catch {
    /* ignorer */
  }
}

const fromHash = () => decodeURIComponent(location.hash.replace(/^#\/?/, ''));
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

function defaultPath(entries: Snapshot) {
  if (entries['krav/README.md']) return 'krav/README.md';
  return Object.keys(entries).sort()[0] ?? '';
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
  const [treeMode, setTreeMode] = useState<TreeMode>(() => load('treeMode', 'files'));
  const [git, setGit] = useState<GitInfo | null>(initialGit);
  const [connected, setConnected] = useState(!!import.meta.hot);
  const [focus, setFocus] = useState<(FocusEvent & { seq: number }) | null>(null);
  const focusedKey = useRef<string | null>(null);
  const mainRef = useRef<HTMLElement>(null);
  const state = useRef({ entries, current });
  state.current = { entries, current };

  const entry = entries[current];
  const tree = useMemo(() => buildTree(entries), [entries]);

  useEffect(() => {
    document.documentElement.dataset.theme = theme;
  }, [theme]);
  useEffect(() => save('open', openDirs), [openDirs]);
  useEffect(() => save('lineNumbers', lineNumbers), [lineNumbers]);
  useEffect(() => save('treeHidden', treeHidden), [treeHidden]);
  useEffect(() => save('treeMode', treeMode), [treeMode]);

  // Hash-ruting: #/krav/…/fil.feature
  useEffect(() => {
    if (fromHash() !== current) history.replaceState(null, '', '#/' + encodeURI(current));
    setOpenDirs(o => (ancestors(current).every(a => o[a]) ? o : { ...o, ...Object.fromEntries(ancestors(current).map(a => [a, true])) }));
    mainRef.current?.scrollTo({ top: 0 });
    focusedKey.current = null;
  }, [current]);

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
  useEffect(() => {
    const onHash = () => {
      const p = fromHash();
      if (state.current.entries[p]) setCurrent(p);
    };
    addEventListener('hashchange', onHash);
    return () => removeEventListener('hashchange', onHash);
  }, []);

  // Live-oppdateringer fra Vite-pluginen
  useEffect(() => {
    const hot = import.meta.hot;
    if (!hot) return;
    let timer: ReturnType<typeof setTimeout> | undefined;
    const onUpdate = ({ path, entry: next }: UpdateEvent) => {
      const prev = state.current.entries[path];
      setEntries(e => {
        const copy = { ...e };
        if (next) copy[path] = next;
        else delete copy[path];
        return copy;
      });
      if (path !== state.current.current || !next) return;
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
      if (!state.current.entries[f.path]) return;
      if (f.path !== state.current.current) {
        setCurrent(f.path);
        history.pushState(null, '', '#/' + encodeURI(f.path));
      }
      setFocus({ ...f, seq: ++seq });
    };
    const onBlur = () => setFocus(null);
    const onConnect = () => setConnected(true);
    const onDisconnect = () => setConnected(false);
    hot.on('krav:update', onUpdate);
    hot.on('krav:git', setGit);
    hot.on('krav:focus', onFocus);
    hot.on('krav:blur', onBlur);
    hot.on('vite:ws:connect', onConnect);
    hot.on('vite:ws:disconnect', onDisconnect);
    return () => {
      clearTimeout(timer);
      hot.off('krav:update', onUpdate);
      hot.off('krav:git', setGit);
      hot.off('krav:focus', onFocus);
      hot.off('krav:blur', onBlur);
      hot.off('vite:ws:connect', onConnect);
      hot.off('vite:ws:disconnect', onDisconnect);
    };
  }, []);

  const select = (path: string) => {
    setCurrent(path);
    history.pushState(null, '', '#/' + encodeURI(path));
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
    requestAnimationFrame(() => {
      const el = main?.querySelector<HTMLElement>(key === 'q' ? '[data-q]' : `[data-rule="${key}"]`);
      if (main && el) {
        const top = asCompact(main, offset => main.scrollTop + el.getBoundingClientRect().top - main.getBoundingClientRect().top - offset);
        main.scrollTo({ top, behavior: 'smooth' });
      }
    });
  };
  const allScenKeys = () => entry?.model?.rules.flatMap((r, ri) => r.scenarios.map((_, si) => scenKey(ri, si))) ?? [];
  const fileName = current.slice(current.lastIndexOf('/') + 1);

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
      />
      <div class={'grid' + (treeHidden ? ' notree' : '')}>
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
            mode={treeMode}
            onMode={setTreeMode}
            git={git}
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
          {!entry ? (
            <div class="empty">
              <div class="mono" style={{ color: 'var(--ink)' }}>{fileName || 'krav'}</div>
              <div>{fileName ? 'Filen finnes ikke lenger.' : 'Velg en fil i treet.'}</div>
            </div>
          ) : entry.kind === 'md' ? (
            <pre class="markdown">{entry.source}</pre>
          ) : (
            <FeatureView
              entry={entry}
              collapsed={collapsed[current] ?? {}}
              flash={flash}
              lineNumbers={lineNumbers}
              mark={mark}
              mainRef={mainRef}
              onToggle={k => setCollapsed(c => ({ ...c, [current]: { ...c[current], [k]: !c[current]?.[k] } }))}
            />
          )}
        </main>
        <Outline
          model={entry?.model}
          onJump={jump}
          onFoldAll={() => setCollapsed(c => ({ ...c, [current]: Object.fromEntries(allScenKeys().map(k => [k, true])) }))}
          onOpenAll={() => setCollapsed(c => ({ ...c, [current]: {} }))}
        />
      </div>
      <StatusBar
        connected={connected}
        live={!!import.meta.hot}
        fileName={fileName}
        savedAt={entry?.savedAt}
        updated={updated}
        lineNumbers={lineNumbers}
        onLineNumbers={() => setLineNumbers(v => !v)}
      />
    </div>
  );
}

render(<App />, document.getElementById('app')!);
