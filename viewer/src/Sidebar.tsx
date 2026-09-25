import type { JSX } from 'preact';
import { useState } from 'preact/hooks';
import { STATUSES, type Entry, type GitChange, type GitCode, type GitInfo, type Snapshot } from '../shared/model';

export type TreeMode = 'files' | 'changes';

interface Dir {
  name: string;
  path: string;
  dirs: Dir[];
  files: Entry[];
  counts: number[]; // antall per status, i STATUSES-rekkefølge
}

const collator = new Intl.Collator('nb', { numeric: true, sensitivity: 'base' });
const baseName = (p: string) => p.slice(p.lastIndexOf('/') + 1);
const parentName = (p: string) => baseName(p.slice(0, p.lastIndexOf('/')));

export function buildTree(entries: Snapshot): Dir {
  const root: Dir = { name: 'krav', path: 'krav', dirs: [], files: [], counts: [0, 0, 0, 0] };
  const index = new Map<string, Dir>([['krav', root]]);
  const dirFor = (path: string): Dir => {
    let d = index.get(path);
    if (!d) {
      const parent = dirFor(path.slice(0, path.lastIndexOf('/')));
      d = { name: baseName(path), path, dirs: [], files: [], counts: [0, 0, 0, 0] };
      parent.dirs.push(d);
      index.set(path, d);
    }
    return d;
  };
  for (const e of Object.values(entries)) {
    const parentPath = e.path.slice(0, e.path.lastIndexOf('/'));
    dirFor(parentPath).files.push(e);
    const si = e.status ? STATUSES.indexOf(e.status) : -1;
    if (si >= 0) {
      // Tell opp status for alle foreldremapper
      for (let p = parentPath; p; p = p.includes('/') ? p.slice(0, p.lastIndexOf('/')) : '') {
        const d = index.get(p);
        if (d) d.counts[si]++;
      }
    }
  }
  const sort = (d: Dir) => {
    d.dirs.sort((a, b) => collator.compare(a.name, b.name));
    d.files.sort((a, b) => collator.compare(baseName(a.path), baseName(b.path)));
    d.dirs.forEach(sort);
  };
  sort(root);
  return root;
}

export const statusColor = (s: string | null) => (s ? `var(--st-${s})` : 'var(--st-none)');

const gitColor: Record<GitCode, string> = {
  M: 'var(--st-in-progress)',
  A: 'var(--st-implemented)',
  U: 'var(--st-implemented)',
  D: 'var(--err)',
};

/** Mappetre over endrede filer, bygd fra stiene */
interface ChangeDir {
  dirs: Map<string, ChangeDir>;
  files: GitChange[];
  n: number; // antall filer i mappen og undermapper
}

function changeTree(changes: GitChange[]): ChangeDir {
  const root: ChangeDir = { dirs: new Map(), files: [], n: 0 };
  for (const c of changes) {
    let d = root;
    d.n++;
    for (const part of c.path.split('/').slice(0, -1)) {
      if (!d.dirs.has(part)) d.dirs.set(part, { dirs: new Map(), files: [], n: 0 });
      d = d.dirs.get(part)!;
      d.n++;
    }
    d.files.push(c);
  }
  return root;
}

interface Props {
  entries: Snapshot;
  tree: Dir;
  current: string;
  open: Record<string, boolean>;
  query: string;
  onQuery: (q: string) => void;
  onToggle: (dirPath: string) => void;
  onSelect: (path: string) => void;
  mode: TreeMode;
  onMode: (mode: TreeMode) => void;
  git: GitInfo | null;
}

export function Sidebar({ entries, tree, current, open, query, onQuery, onToggle, onSelect, mode, onMode, git }: Props) {
  // Lukkede mapper i endringstreet; alle er åpne som standard
  const [closed, setClosed] = useState<Record<string, boolean>>({});
  const rows: JSX.Element[] = [];
  const pad = (depth: number) => ({ paddingLeft: `${8 + depth * 14}px` });

  const fileRow = (e: Entry, depth: number, sub?: string) => (
    <div
      key={e.path}
      class={'row' + (e.path === current ? ' sel' : '')}
      style={pad(depth)}
      onClick={() => onSelect(e.path)}
      title={e.path}
    >
      <span class="chev" />
      {e.kind === 'feature' ? (
        <span
          class={'dot' + (e.partialDraft ? ' partial' : '')}
          style={{ background: statusColor(e.status) }}
          title={(e.status ?? 'ingen status') + (e.partialDraft ? ' · delvis utkast' : '')}
        />
      ) : (
        <span class="md">md</span>
      )}
      <span class="name">{baseName(e.path)}</span>
      {sub && <span class="sub">{sub}</span>}
      {e.error ? <span class="err">feil</span> : e.lint ? <span class="warn" title={`${e.lint} avvik fra konvensjoner`}>!</span> : null}
    </div>
  );

  const changeRow = (c: GitChange, depth: number, key: string) => {
    const e = entries[c.path];
    return (
      <div
        key={key}
        class={'row' + (c.path === current ? ' sel' : '') + (c.code === 'D' ? ' del' : '') + (e ? '' : ' gone')}
        style={pad(depth)}
        onClick={e ? () => onSelect(c.path) : undefined}
        title={c.path}
      >
        <span class="chev" />
        {c.path.endsWith('.feature') ? (
          <span class={'dot' + (e?.partialDraft ? ' partial' : '')} style={{ background: statusColor(e?.status ?? null) }} />
        ) : (
          <span class="md">md</span>
        )}
        <span class="name">{baseName(c.path)}</span>
        <span class="gitstat">
          {c.plus > 0 && <span class="plus">+{c.plus}</span>}
          {c.minus > 0 && <span class="minus">−{c.minus}</span>}
          <span class="code" style={{ color: gitColor[c.code] }}>
            {c.code}
          </span>
        </span>
      </div>
    );
  };

  const q = query.trim().toLowerCase();
  const nChanges = git ? git.uncommitted.length + git.committed.length : 0;
  if (mode === 'changes') {
    const groups: [string, GitChange[]][] = git
      ? [
          ['IKKE COMMITTET', git.uncommitted],
          ['COMMITTET I BRANCH', git.committed],
        ]
      : [];
    for (const [group, all] of groups) {
      const changes = q ? all.filter(c => baseName(c.path).toLowerCase().includes(q)) : all;
      if (!changes.length) continue;
      rows.push(
        <div key={group} class="ghead">
          <span>{group}</span>
          <span>{changes.length}</span>
        </div>,
      );
      const walk = (d: ChangeDir, path: string, depth: number) => {
        for (const [name, child] of d.dirs) {
          const key = group + '|' + path + name;
          const isOpen = !closed[key];
          rows.push(
            <div key={key} class="row gdir" style={pad(depth)} onClick={() => setClosed(c => ({ ...c, [key]: isOpen }))}>
              <span class="chev">{isOpen ? '▼' : '▶'}</span>
              <span class="name">{name}</span>
              <span class="gitstat">
                <span class="code">{child.n}</span>
              </span>
            </div>,
          );
          if (isOpen) walk(child, path + name + '/', depth + 1);
        }
        d.files.forEach(c => rows.push(changeRow(c, depth, group + '|' + c.path)));
      };
      walk(changeTree(changes), '', 0);
    }
    if (!rows.length) {
      const msg = !git ? 'Git er ikke tilgjengelig' : nChanges ? 'Ingen treff' : 'Ingen endringer mot main';
      rows.push(<div key="none" class="row dim" style={pad(0)}>{msg}</div>);
    }
  } else if (q) {
    const hits = Object.values(entries)
      .filter(e => baseName(e.path).toLowerCase().includes(q) || e.model?.title.toLowerCase().includes(q))
      .sort((a, b) => collator.compare(baseName(a.path), baseName(b.path)));
    hits.forEach(e => rows.push(fileRow(e, 0, parentName(e.path))));
    if (!hits.length) rows.push(<div key="none" class="row dim" style={pad(0)}>Ingen treff</div>);
  } else {
    const walk = (d: Dir, depth: number) => {
      const isOpen = !!open[d.path];
      const total = d.counts.reduce((a, b) => a + b, 0);
      rows.push(
        <div key={d.path} class="row" style={pad(depth)} onClick={() => onToggle(d.path)}>
          <span class="chev">{isOpen ? '▼' : '▶'}</span>
          <span class="name">{d.name}</span>
          <span class="dirstat">
            <span class="bar">
              {d.counts.map((n, i) => (
                <span key={i} style={{ width: `${total ? (n / total) * 100 : 0}%`, background: statusColor(STATUSES[i]) }} />
              ))}
            </span>
            <span class="count">{total || ''}</span>
          </span>
        </div>,
      );
      if (isOpen) {
        d.dirs.forEach(c => walk(c, depth + 1));
        d.files.forEach(f => rows.push(fileRow(f, depth + 1)));
      }
    };
    walk(tree, 0);
  }

  return (
    <aside class="sidebar">
      <div class="treehead">
        <div class="seg" role="group" aria-label="Visning av treet">
          <button aria-pressed={mode === 'files'} onClick={() => onMode('files')}>
            Filer
          </button>
          {git && (
            <button aria-pressed={mode === 'changes'} onClick={() => onMode('changes')}>
              Endringer<span class="badge">{nChanges}</span>
            </button>
          )}
        </div>
        {mode === 'changes' && git && (
          <div class="gitmeta">
            <span class="branch">{git.branch}</span>
            <span>← main · {git.commits} commits</span>
          </div>
        )}
      </div>
      <div class="filter">
        <input
          type="search"
          value={query}
          onInput={e => onQuery((e.target as HTMLInputElement).value)}
          placeholder="Filtrer filnavn og Egenskap…"
          aria-label="Filtrer filnavn og Egenskap"
        />
      </div>
      <div class="tree">{rows}</div>
      <div class="legend">
        {STATUSES.map((s, i) => (
          <div key={s}>
            <span class="dot" style={{ background: statusColor(s) }} />
            <span>{s}</span>
            <span class="n">{tree.counts[i]}</span>
          </div>
        ))}
        <div>
          <span class="dot" style={{ background: statusColor(null) }} />
          <span>ingen status</span>
          <span class="n">{Object.values(entries).filter(e => e.kind === 'feature' && !e.status).length}</span>
        </div>
        <div>
          <span class="dot partial" style={{ background: statusColor('planned') }} />
          <span>delvis utkast</span>
          <span class="n">{Object.values(entries).filter(e => e.partialDraft).length}</span>
        </div>
      </div>
    </aside>
  );
}
