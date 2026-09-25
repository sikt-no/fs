export type Theme = 'light' | 'dark';
export type Mode = 'krav' | 'avvik';

interface Props {
  path: string;
  connected: boolean;
  theme: Theme;
  onTheme: (t: Theme) => void;
  treeHidden: boolean;
  onToggleTree: () => void;
  onHome: () => void;
  mode: Mode;
  onMode: (m: Mode) => void;
  /** Antall filer med avvik, vist på Avvik-knappen */
  nBad: number;
}

export function TopBar({ path, connected, theme, onTheme, treeHidden, onToggleTree, onHome, mode, onMode, nBad }: Props) {
  const parts = mode === 'avvik' ? ['krav', '#/avvik'] : path ? path.split('/') : [];
  return (
    <header class="topbar">
      {mode === 'krav' && (
        <button
          class="treebtn"
          title={treeHidden ? 'Vis filtre' : 'Skjul filtre'}
          aria-label={treeHidden ? 'Vis filtre' : 'Skjul filtre'}
          aria-pressed={!treeHidden}
          onClick={onToggleTree}
        >
          <span class="treeicon"><span /></span>
        </button>
      )}
      <button class="brand" title="Til forsiden" onClick={onHome}>
        <span class="brand-mark" /><span>krav</span><span class="brand-sub">viewer</span>
      </button>
      <div class="seg modeseg" role="group" aria-label="Visning">
        <button aria-pressed={mode === 'krav'} onClick={() => onMode('krav')}>Krav</button>
        <button aria-pressed={mode === 'avvik'} onClick={() => onMode('avvik')} title={`${nBad} filer med avvik fra konvensjonene`}>
          Avvik{nBad > 0 && <span class="badge">{nBad}</span>}
        </button>
      </div>
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
