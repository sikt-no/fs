import { useEffect, useRef, useState } from 'preact/hooks';
import { vscodeUrl } from './vscode';

export type Theme = 'light' | 'dark';
export type Mode = 'krav' | 'avvik' | 'oppgaver' | 'flyter';
/** Visningene som kan vises i menyen (designet «Menyvalg»). Krav og Flyter er alltid med, Avvik og Oppgaver er skjult til de velges */
export type Optional = 'avvik' | 'oppgaver';
export type MenuShow = Record<Optional, boolean>;
export const MENU_DEFAULT: MenuShow = { avvik: false, oppgaver: false };

interface Props {
  path: string;
  connected: boolean;
  theme: Theme;
  onTheme: (t: Theme) => void;
  treeHidden: boolean;
  onToggleTree: () => void;
  /** Innholdspanelet til høyre i Krav (innhold og søk i fila) */
  tocHidden: boolean;
  onToggleToc: () => void;
  onHome: () => void;
  mode: Mode;
  onMode: (m: Mode) => void;
  /** Antall filer med avvik, vist på Avvik-knappen */
  nBad: number;
  /** Antall oppgaver som ikke er verifisert, vist på Oppgaver-knappen */
  nActive: number;
  /** Brødsmulen i Oppgaver-modus */
  oCrumbs: string[];
  /** Flyten som er valgt i Flyter, `null` på startsiden */
  flowPath: string | null;
  /** Antall flyter i krav/_Flyter, vist på Flyter-knappen */
  nFlows: number;
  /** Hvilke av Avvik og Oppgaver som vises i menyen, og tannhjulet som endrer det */
  menu: MenuShow;
  onMenu: (m: MenuShow) => void;
  /** Claude-panelet: `null` når Claude Code ikke er tilgjengelig, ellers om panelet er åpent */
  claude: boolean | null;
  onClaude: () => void;
  /** Oppgaver: skrivebeskyttet (statisk bygg), antall endrede filer under tasks/, og «Lag PR» */
  specState: { ro: boolean; dirty: number; onPr: (() => void) | null };
  /** Desktop-appen: main på GitHub er nyere enn klonen; knappen henter siste. `null`: ingenting å hente */
  onUpdate: (() => void) | null;
  /** «Hent siste» pågår */
  pulling: boolean;
  /** Desktop-appen: en ny versjon av appen er lastet ned, og kortet nede til høyre er skjult med «Senere». `null`: ingen knapp */
  appUpdate: { version: string; onRestart: () => void } | null;
  /** Absolutt sti til repoet, for «Åpne i VS Code». `null` i statisk bygg */
  repoRoot: string | null;
}

export function TopBar({ path, connected, theme, onTheme, treeHidden, onToggleTree, tocHidden, onToggleToc, onHome, mode, onMode, nBad, nActive, oCrumbs, flowPath, nFlows, menu, onMenu, specState, claude, onClaude, onUpdate, pulling, appUpdate, repoRoot }: Props) {
  const parts =
    mode === 'avvik' ? ['krav', '#/avvik'] : mode === 'oppgaver' ? oCrumbs : mode === 'flyter' ? (flowPath ? flowPath.split('/') : ['krav', '#/flyter']) : path ? path.split('/') : [];
  return (
    <header class="topbar">
      {/* Venstrepanelet: filtreet i Krav, mappene med avvik i Avvik, flytene i Flyter */}
      {mode !== 'oppgaver' && (
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
        {menu.avvik && (
          <button aria-pressed={mode === 'avvik'} onClick={() => onMode('avvik')} title={`${nBad} filer med avvik fra konvensjonene`}>
            Avvik{nBad > 0 && <span class="badge">{nBad}</span>}
          </button>
        )}
        {menu.oppgaver && (
          <button aria-pressed={mode === 'oppgaver'} onClick={() => onMode('oppgaver')} title={`${nActive} oppgaver i tasks/ som ikke er verifisert`}>
            Oppgaver<span class="badge neutral">{nActive}</span>
          </button>
        )}
        <button aria-pressed={mode === 'flyter'} onClick={() => onMode('flyter')} title={`${nFlows} flyter i krav/_Flyter`}>
          Flyter<span class="badge neutral">{nFlows}</span>
        </button>
      </div>
      <MenuGear menu={menu} onMenu={onMenu} />
      <nav class="crumbs" aria-label="Sti">
        {parts.map((p, i) => (
          <span key={i} style={{ display: 'flex', gap: '6px' }}>
            {i > 0 && <span class="sep">/</span>}
            <span class={i === parts.length - 1 ? 'last' : ''}>{p}</span>
          </span>
        ))}
      </nav>
      <div class="topbar-right">
        {mode === 'oppgaver' && (
          <span class="spstate mono">
            {specState.ro ? (
              <>
                <span class="dot" style={{ background: 'var(--st-none)' }} />
                statisk bygg · skrivebeskyttet
              </>
            ) : specState.dirty ? (
              <>
                <span class="dot" style={{ background: 'var(--st-in-progress)' }} />
                {specState.dirty} endret · ikke merget
                {specState.onPr && (
                  <button class="spbtn solid small" onClick={specState.onPr}>
                    Lag PR
                  </button>
                )}
              </>
            ) : (
              <>
                <span class="dot" style={{ background: 'var(--st-implemented)' }} />
                som på main
              </>
            )}
          </span>
        )}
        {appUpdate && (
          <button class="apppill" onClick={appUpdate.onRestart} title={`Start på nytt for å installere ${appUpdate.version}`}>
            <span class="ver mono">{appUpdate.version}</span>
            Start på nytt
          </button>
        )}
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
        {repoRoot && (
          <a class="codebtn" href={vscodeUrl(repoRoot, { newWindow: true })} title={`Åpne ${repoRoot} i et nytt VS Code-vindu`}>
            VS Code
          </a>
        )}
        {(mode === 'krav' || mode === 'flyter') && (
          <button
            class="tocbtn"
            title={tocHidden ? 'Vis innhold' : 'Skjul innhold'}
            aria-label={tocHidden ? 'Vis innhold' : 'Skjul innhold'}
            aria-pressed={!tocHidden}
            onClick={onToggleToc}
          >
            <span class="tocicon"><span><span /><span /><span /></span></span>
          </button>
        )}
        {claude !== null && (
          <button
            class="claudebtn"
            aria-pressed={claude}
            onMouseDown={e => e.preventDefault()}
            onClick={onClaude}
            title={claude ? 'Skjul Claude' : 'Vis Claude'}
          >
            <span class="claudeicon"><span /></span>Claude
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

const MENU_ITEMS: { key: Mode; label: string; locked?: boolean }[] = [
  { key: 'krav', label: 'Krav', locked: true },
  { key: 'avvik', label: 'Avvik' },
  { key: 'oppgaver', label: 'Oppgaver' },
  { key: 'flyter', label: 'Flyter', locked: true },
];

/** Tannhjulet rett etter menyen: velg hvilke visninger som vises. Lukkes med klikk utenfor eller Esc */
function MenuGear({ menu, onMenu }: { menu: MenuShow; onMenu: (m: MenuShow) => void }) {
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);
  useEffect(() => {
    if (!open) return;
    const down = (e: MouseEvent) => !ref.current?.contains(e.target as Node) && setOpen(false);
    const key = (e: KeyboardEvent) => e.key === 'Escape' && setOpen(false);
    addEventListener('mousedown', down);
    addEventListener('keydown', key);
    return () => {
      removeEventListener('mousedown', down);
      removeEventListener('keydown', key);
    };
  }, [open]);
  return (
    <div class="menugear" ref={ref}>
      <button class="gearbtn" title="Velg hva som vises i menyen" aria-label="Velg hva som vises i menyen" aria-expanded={open} onClick={() => setOpen(o => !o)}>
        ⚙︎
      </button>
      {open && (
        <div class="menupop" role="menu" aria-label="Vis i menyen">
          <div class="menupop-head">VIS I MENYEN</div>
          <div class="menupop-items">
            {MENU_ITEMS.map(i => {
              const on = i.locked || menu[i.key as Optional];
              return (
                <button
                  key={i.key}
                  role="menuitemcheckbox"
                  aria-checked={on}
                  disabled={i.locked}
                  class={i.locked ? 'locked' : ''}
                  onClick={() => !i.locked && onMenu({ ...menu, [i.key]: !menu[i.key as Optional] })}
                >
                  <span class={'box' + (on ? ' on' : '')}>{on ? '✓' : ''}</span>
                  <span class="label">{i.label}</span>
                  {i.locked && <span class="always">alltid</span>}
                </button>
              );
            })}
          </div>
          <div class="menupop-foot">Lagres på denne maskinen.</div>
        </div>
      )}
    </div>
  );
}
