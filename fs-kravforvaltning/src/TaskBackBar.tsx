import { colIcon } from './specboard';
import type { KravFrom } from './TaskDetail';

/**
 * Båndet øverst i Krav når kravet ble åpnet fra oppgavepanelet på tavla (designet «Spesifikasjoner», runde 4):
 * «← <oppgave>» tilbake til oppgaven, kolonnen den står i, og filtrene på tavla, som er tatt vare på.
 */
export function TaskBackBar({ from, onBack }: { from: KravFrom; onBack: () => void }) {
  return (
    <div class="sptaskback">
      <button class="sptaskback-btn" onClick={onBack} title="Tilbake til oppgaven på tavla">
        ← {from.title}
      </button>
      <span class="sptaskback-col mono">
        <span class={colIcon(from.col)} />
        {from.colName}
      </span>
      <span class="omuted">Du kom hit fra oppgaven</span>
      <span class="sptaskback-f">
        <span class="omuted">Filtrene på tavla:</span>
        <span class="mono ell">{from.filters}</span>
      </span>
    </div>
  );
}
