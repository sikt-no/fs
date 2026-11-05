import { colIcon } from './specboard';
import type { KravFrom } from './TaskDetail';

/**
 * Båndet øverst i Krav når kravet ble åpnet fra scope-panelet på tavla (designet «Spesifikasjoner», runde 4):
 * «← <scope>» tilbake til scopet, kolonnen den står i, og filtrene på tavla, som er tatt vare på.
 */
export function TaskBackBar({ from, onBack }: { from: KravFrom; onBack: () => void }) {
  return (
    <div class="sptaskback">
      <button class="sptaskback-btn" onClick={onBack} title="Tilbake til scopet på tavla">
        ← {from.title}
      </button>
      <span class="sptaskback-col mono">
        <span class={colIcon(from.col)} />
        {from.colName}
      </span>
      <span class="omuted">Du kom hit fra scopet</span>
      <span class="sptaskback-f">
        <span class="omuted">Filtrene på tavla:</span>
        <span class="mono ell">{from.filters}</span>
      </span>
    </div>
  );
}
