interface Props {
  /** Versjonen som er lastet ned */
  version: string;
  onLater: () => void;
  onRestart: () => void;
}

/**
 * Desktop-appen: kort nede til høyre når en ny versjon av appen er lastet ned, portet fra designet
 * «Oppdateringsvarsler», 1c (Claude Design). Main har båndet under toppfeltet, appen har kortet, så de ikke forveksles.
 * «Senere» skjuler kortet, og legger knappen «<versjon> Start på nytt» i toppfeltet
 */
export function UpdateToast({ version, onLater, onRestart }: Props) {
  return (
    <div class="updatetoast" role="status">
      <div class="text">
        <span class="title">FS Kravforvaltning {version} er lastet ned</span>
        <span class="info">Den nye versjonen installeres når du starter appen på nytt.</span>
      </div>
      <div class="btns">
        <button class="later" onClick={onLater} title="Skjul kortet. Knappen i toppfeltet blir stående, og den nye versjonen installeres når appen avsluttes.">
          Senere
        </button>
        <button class="restart" onClick={onRestart} title="Avslutt appen, installer den nye versjonen og start den igjen">
          Start på nytt
        </button>
      </div>
    </div>
  );
}
