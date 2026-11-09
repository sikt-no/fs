// Verifisering: verify-rapportene fra fs-verify i et filtre som i Krav, med rapporten til høyre, som rapportvisning
// (HTML-fila ved siden av rapporten) eller som markdown.
import type { JSX } from 'preact';
import { useEffect, useMemo, useState } from 'preact/hooks';
import type { Entry } from '../shared/model';
import { reportName, VERIFY_ROOTS, type VerifyReport, type VerifySnapshot } from '../shared/verify';
import { parseMd } from './markdown';
import { MarkdownView } from './MarkdownView';
import { ResizeHandle } from './ResizeHandle';
import { TREE_WIDTH } from './Sidebar';
import { reportHtml } from './transport';

/** Hvordan rapporten vises: rapportvisningen (HTML), eller markdown formatert eller som tekst */
export type ReportView = 'html' | 'pretty' | 'raw';

interface Dir {
  name: string;
  path: string;
  dirs: Dir[];
  files: VerifyReport[];
  n: number;
}

const collator = new Intl.Collator('nb', { numeric: true, sensitivity: 'base' });

/** Mappetreet over rapportene: krav/, tasks/ og akseptansetest/ øverst, de nyeste rapportene først med samme navn */
export function verifyTree(verify: VerifySnapshot): Dir[] {
  const index = new Map<string, Dir>();
  const roots: Dir[] = [];
  const dirFor = (path: string): Dir => {
    let d = index.get(path);
    if (!d) {
      const cut = path.lastIndexOf('/');
      d = { name: path.slice(cut + 1), path, dirs: [], files: [], n: 0 };
      (cut < 0 ? roots : dirFor(path.slice(0, cut)).dirs).push(d);
      index.set(path, d);
    }
    return d;
  };
  for (const r of Object.values(verify)) {
    const parent = r.path.slice(0, r.path.lastIndexOf('/'));
    dirFor(parent).files.push(r);
    for (let p = parent; p; p = p.includes('/') ? p.slice(0, p.lastIndexOf('/')) : '') index.get(p)!.n++;
  }
  const sort = (d: Dir) => {
    d.dirs.sort((a, b) => collator.compare(a.name, b.name));
    d.files.sort((a, b) => {
      const x = reportName(a.path), y = reportName(b.path);
      return collator.compare(x.name, y.name) || collator.compare(y.date ?? '', x.date ?? '');
    });
    d.dirs.forEach(sort);
  };
  roots.forEach(sort);
  const order = VERIFY_ROOTS as readonly string[];
  return roots.sort((a, b) => order.indexOf(a.name) - order.indexOf(b.name));
}

/** Overskriften i rapporten (`# Verifisering: …`), uten «Verifisering: » */
const titleOf = (r: VerifyReport) => /^#\s+(.+)$/m.exec(r.source)?.[1].replace(/^Verifisering:\s*/, '').replace(/`/g, '') ?? null;

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

interface Props {
  verify: VerifySnapshot;
  /** Rapporten som er valgt, eller `null` */
  sel: string | null;
  onSelect: (path: string) => void;
  view: ReportView;
  onView: (v: ReportView) => void;
  /** Lenker i markdown: finnes målet i vieweren, og åpne det */
  has: (path: string) => boolean;
  onNavigate: (path: string) => void;
  /** Skjul treet (samme knapp som filtreet i Krav) */
  treeHidden: boolean;
  width: number;
  onWidth: (w: number) => void;
}

export function Verifisering({ verify, sel, onSelect, view, onView, has, onNavigate, treeHidden, width, onWidth }: Props) {
  const roots = useMemo(() => verifyTree(verify), [verify]);
  const [open, setOpen] = useState<Record<string, boolean>>(() => load('verifyOpen', { krav: true, tasks: true, akseptansetest: true }));
  const [query, setQuery] = useState('');
  useEffect(() => save('verifyOpen', open), [open]);
  // Mappene over rapporten som er valgt, åpnes
  useEffect(() => {
    if (!sel) return;
    const parts = sel.split('/').slice(0, -1);
    const up = parts.map((_, i) => parts.slice(0, i + 1).join('/'));
    setOpen(o => (up.every(p => o[p]) ? o : { ...o, ...Object.fromEntries(up.map(p => [p, true])) }));
  }, [sel]);

  const report = sel ? verify[sel] : undefined;
  const hasHtml = !!report?.html;
  const shown: ReportView = view === 'html' && !hasHtml ? 'pretty' : view;

  // Rapportvisningen hentes fra HTML-fila når den vises, og på nytt når fila er endret
  const [html, setHtml] = useState<{ path: string; at: number | null; text: string | null; error: string | null } | null>(null);
  useEffect(() => {
    if (!report?.html || shown !== 'html') return;
    if (html && html.path === report.html && html.at === report.htmlAt && html.text) return;
    let alive = true;
    const path = report.html;
    const at = report.htmlAt;
    setHtml({ path, at, text: null, error: null });
    reportHtml(path).then(
      text => alive && setHtml({ path, at, text, error: null }),
      e => alive && setHtml({ path, at, text: null, error: (e as Error).message }),
    );
    return () => {
      alive = false;
    };
  }, [report?.html, report?.htmlAt, shown]);

  const blocks = useMemo(() => (report ? parseMd(report.source) : []), [report?.source]);
  const entry: Entry | null = report ? { path: report.path, kind: 'md', status: null, source: report.source, savedAt: report.savedAt } : null;
  const nHtml = Object.values(verify).filter(r => r.html).length;

  // Treet: mappene med antall rapporter, og rapportene med navn og dato
  const rows: JSX.Element[] = [];
  const pad = (depth: number) => ({ paddingLeft: `${8 + depth * 14}px` });
  const fileRow = (r: VerifyReport, depth: number, sub?: string) => {
    const { name, date } = reportName(r.path);
    const title = titleOf(r);
    return (
      <div
        key={r.path}
        class={'row two' + (r.path === sel ? ' sel' : '')}
        style={pad(depth)}
        onClick={() => onSelect(r.path)}
        title={(title ? title + '\n' : '') + r.path}
      >
        <span class="chev" />
        <span class="md">{r.html ? 'html' : 'md'}</span>
        <span class="namecol">
          <span class="name">{name}</span>
          <span class="idline">
            <span class="id">{date ?? 'uten dato'}</span>
            {sub && ` · ${sub}`}
          </span>
        </span>
      </div>
    );
  };
  const q = query.trim().toLowerCase();
  if (q) {
    const hits = Object.values(verify)
      .filter(r => r.path.toLowerCase().includes(q) || (titleOf(r) ?? '').toLowerCase().includes(q))
      .sort((a, b) => b.savedAt - a.savedAt || collator.compare(a.path, b.path));
    hits.forEach(r => rows.push(fileRow(r, 0, r.path.split('/').slice(-2, -1)[0])));
    if (!hits.length) rows.push(<div key="none" class="row dim" style={pad(0)}>Ingen treff</div>);
  } else {
    const walk = (d: Dir, depth: number) => {
      const isOpen = !!open[d.path];
      rows.push(
        <div key={d.path} class="row" style={pad(depth)} onClick={() => setOpen(o => ({ ...o, [d.path]: !isOpen }))}>
          <span class="chev">{isOpen ? '▼' : '▶'}</span>
          <span class="name">{d.name}</span>
          <span class="dirstat">
            <span class="count">{d.n}</span>
          </span>
        </div>,
      );
      if (!isOpen) return;
      d.dirs.forEach(c => walk(c, depth + 1));
      d.files.forEach(f => rows.push(fileRow(f, depth + 1)));
    };
    roots.forEach(d => walk(d, 0));
    if (!roots.length) rows.push(<div key="none" class="row dim" style={pad(0)}>Ingen verify-rapporter</div>);
  }

  const toggle = (
    <div class="seg" role="group" aria-label="Visning av rapporten">
      <button
        aria-pressed={shown === 'html'}
        disabled={!hasHtml}
        title={hasHtml ? `Rapportvisningen: ${report!.html!.slice(report!.html!.lastIndexOf('/') + 1)}` : 'Rapporten har ingen rapportvisning (HTML-fil) ved siden av seg'}
        onClick={() => onView('html')}
      >
        Rapportvisning
      </button>
      <button aria-pressed={shown === 'pretty'} onClick={() => onView('pretty')}>Visning</button>
      <button aria-pressed={shown === 'raw'} onClick={() => onView('raw')}>Markdown</button>
    </div>
  );

  return (
    <div class={'vgrid' + (treeHidden ? ' notree' : '')} style={{ '--tree-w': `min(${width}px, 50vw)` }}>
      {!treeHidden && (
        <aside class="sidebar">
          <ResizeHandle width={width} onWidth={onWidth} edge="right" min={200} max={() => Math.max(200, Math.min(640, Math.round(innerWidth * 0.5)))} fallback={TREE_WIDTH} label="Endre bredden på treet" />
          <div class="filter vfilter">
            <input
              type="search"
              value={query}
              onInput={e => setQuery((e.target as HTMLInputElement).value)}
              placeholder="Søk i rapportene…"
              aria-label="Søk i verify-rapportene på sti og overskrift"
            />
          </div>
          <div class="tree">{rows}</div>
          <div class="legend vlegend">
            <div>
              <span class="md">md</span>
              <span>rapporter</span>
              <span class="n">{Object.keys(verify).length}</span>
            </div>
            <div>
              <span class="md">html</span>
              <span>med rapportvisning</span>
              <span class="n">{nHtml}</span>
            </div>
          </div>
        </aside>
      )}
      <main class="main">
        {!report || !entry ? (
          <div class="empty">
            <div class="mono" style={{ color: 'var(--ink)' }}>Verifisering</div>
            <div>{sel ? 'Rapporten finnes ikke lenger.' : `Velg en av de ${Object.keys(verify).length} verify-rapportene i treet.`}</div>
          </div>
        ) : shown === 'html' ? (
          <div class="vdoc">
            <div class="md-meta">
              <span class="file">{report.html!.slice(report.html!.lastIndexOf('/') + 1)}</span>
              <span>{report.path.slice(0, report.path.lastIndexOf('/'))}</span>
              {toggle}
            </div>
            {html?.error ? (
              <div class="empty">Kunne ikke hente rapportvisningen: {html.error}</div>
            ) : html?.text && html.path === report.html ? (
              // Sandkasse uten allow-same-origin: siden kjører skriptet sitt, men når ikke vieweren eller lagringen dens
              <iframe class="vframe" title={`Rapportvisning: ${titleOf(report) ?? report.path}`} sandbox="allow-scripts allow-popups allow-popups-to-escape-sandbox" srcDoc={html.text} />
            ) : (
              <div class="empty">
                <span class="spinner" aria-hidden="true" />
                Henter rapportvisningen …
              </div>
            )}
          </div>
        ) : (
          <MarkdownView
            entry={entry}
            blocks={blocks}
            mode={shown}
            onMode={m => onView(m)}
            has={has}
            onNavigate={onNavigate}
            toggle={toggle}
          />
        )}
      </main>
    </div>
  );
}
