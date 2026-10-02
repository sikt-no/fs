import type { MainInfo } from '../shared/api';
import { mainInfoText } from './mainStatus';

interface Props {
  /** Mangler når GitHub ikke kunne spørres; da vises bare tittelen */
  info?: MainInfo;
  /** «Hent siste» pågår */
  pulling: boolean;
  onLater: () => void;
  onPull: () => void;
}

/** Desktop-appen: banner under toppfeltet når main på GitHub er nyere enn klonen */
export function MainBanner({ info, pulling, onLater, onPull }: Props) {
  return (
    <div class="mainbanner" role="status">
      <span class="dot" aria-hidden="true" />
      <span class="title">Det finnes en ny versjon av main</span>
      {info && <span class="info">{mainInfoText(info, Date.now())}</span>}
      <div class="btns">
        <button class="later" onClick={onLater} disabled={pulling} title="Skjul til main endres igjen. Knappen i toppfeltet blir stående.">
          Senere
        </button>
        <button class="pull" onClick={onPull} disabled={pulling} aria-busy={pulling} title="Hent siste versjon av main fra GitHub (lokale endringer blir stående)">
          {pulling ? (
            <>
              <span class="spinner" aria-hidden="true" />
              Henter…
            </>
          ) : (
            'Hent siste'
          )}
        </button>
      </div>
    </div>
  );
}
