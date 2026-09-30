import type { OView } from './Oppgaver';

export type Theme = 'light' | 'dark';
export type Mode = 'krav' | 'avvik' | 'oppgaver';

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
  /** Vis Oppgaver-knappen (dev-serveren er startet med `--mode oppgaver`) */
  oppgaver: boolean;
  /** Antall oppgaver som ikke er levert, vist på Oppgaver-knappen */
  nActive: number;
  oView: OView;
  onOView: (v: OView) => void;
  /** Brødsmulen i Oppgaver-modus */
  oCrumbs: string[];
  /** Claude-panelet: `null` når Claude Code ikke er tilgjengelig, ellers om panelet er åpent */
  claude: boolean | null;
  onClaude: () => void;
  /** Desktop-appen: main på GitHub er nyere enn klonen; knappen henter siste. `null`: ingenting å hente */
  onUpdate: (() => void) | null;
  /** «Hent siste» pågår */
  pulling: boolean;
}

export function TopBar({ path, connected, theme, onTheme, treeHidden, onToggleTree, onHome, mode, onMode, nBad, oppgaver, nActive, oView, onOView, oCrumbs, claude, onClaude, onUpdate, pulling }: Props) {
  const parts = mode === 'avvik' ? ['krav', '#/avvik'] : mode === 'oppgaver' ? oCrumbs : path ? path.split('/') : [];
  return (
    <header class="topbar">
      {/* Venstrepanelet: filtreet i Krav, mappene med avvik i Avvik */}
      {(mode === 'krav' || mode === 'avvik') && (
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
        <span class="brand-mark" /><span>FS</span><span class="brand-sub">Kravforvaltning</span>
      </button>
      <div class="seg modeseg" role="group" aria-label="Visning">
        <button aria-pressed={mode === 'krav'} onClick={() => onMode('krav')}>Krav</button>
        <button aria-pressed={mode === 'avvik'} onClick={() => onMode('avvik')} title={`${nBad} filer med avvik fra konvensjonene`}>
          Avvik{nBad > 0 && <span class="badge">{nBad}</span>}
        </button>
        {oppgaver && (
          <button aria-pressed={mode === 'oppgaver'} onClick={() => onMode('oppgaver')} title={`${nActive} aktive oppgaver i tasks/`}>
            Oppgaver<span class="badge neutral">{nActive}</span>
          </button>
        )}
      </div>
      {mode === 'oppgaver' && (
        <div class="seg oviewseg" role="group" aria-label="Oppgavevisning">
          <button aria-pressed={oView === 'mappe'} onClick={() => onOView('mappe')}>
            <span class="oic-mappe" aria-hidden="true"><span /><span /><span /></span>Mappe
          </button>
          <button aria-pressed={oView === 'tavle'} onClick={() => onOView('tavle')}>
            <span class="oic-tavle" aria-hidden="true"><span /><span /><span /></span>Tavle
          </button>
        </div>
      )}
      <nav class="crumbs" aria-label="Sti">
        {parts.map((p, i) => (
          <span key={i} style={{ display: 'flex', gap: '6px' }}>
            {i > 0 && <span class="sep">/</span>}
            <span class={i === parts.length - 1 ? 'last' : ''}>{p}</span>
          </span>
        ))}
      </nav>
      <div class="topbar-right">
        {onUpdate && (
          <button
            class="updatebtn"
            onClick={onUpdate}
            disabled={pulling}
            aria-busy={pulling}
            title="Det finnes en nyere versjon av main på GitHub. Klikk for å hente den (lokale endringer blir stående)."
          >
            {pulling ? (
              <>
                <span class="spinner" aria-hidden="true" />
                Henter siste main…
              </>
            ) : (
              <>
                <span class="dot" aria-hidden="true" />
                Ny versjon av main · Hent siste
              </>
            )}
          </button>
        )}
        {claude !== null && (
          <button class="claudebtn" aria-pressed={claude} onClick={onClaude} title="Spør den lokale Claude Code-en om kravene">
            <span class="claude-mark" />Claude
          </button>
        )}
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
