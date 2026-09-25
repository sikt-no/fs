export type Theme = 'light' | 'dark';

interface Props {
  path: string;
  connected: boolean;
  theme: Theme;
  onTheme: (t: Theme) => void;
  treeHidden: boolean;
  onToggleTree: () => void;
  onHome: () => void;
}

export function TopBar({ path, connected, theme, onTheme, treeHidden, onToggleTree, onHome }: Props) {
  const parts = path ? path.split('/') : [];
  return (
    <header class="topbar">
      <button
        class="treebtn"
        title={treeHidden ? 'Vis filtre' : 'Skjul filtre'}
        aria-label={treeHidden ? 'Vis filtre' : 'Skjul filtre'}
        aria-pressed={!treeHidden}
        onClick={onToggleTree}
      >
        <span class="treeicon"><span /></span>
      </button>
      <button class="brand" title="Til forsiden" onClick={onHome}>
        <span class="brand-mark" /><span>krav</span><span class="brand-sub">viewer</span>
      </button>
      <nav class="crumbs" aria-label="Sti">
        {parts.map((p, i) => (
          <span key={i} style={{ display: 'flex', gap: '6px' }}>
            {i > 0 && <span class="sep">/</span>}
            <span class={i === parts.length - 1 ? 'last' : ''}>{p}</span>
          </span>
        ))}
      </nav>
      <div class="topbar-right">
        <div class="live">
          <span class="dot" style={{ background: connected ? 'var(--st-implemented)' : 'var(--err)' }} />
          {connected ? 'live' : 'frakoblet'}
        </div>
        <div class="seg" role="group" aria-label="Tema">
          <button aria-pressed={theme === 'light'} onClick={() => onTheme('light')}>Lys</button>
          <button aria-pressed={theme === 'dark'} onClick={() => onTheme('dark')}>Mørk</button>
        </div>
      </div>
    </header>
  );
}
