# CDP-tester: Samordning

Tester for kravet [samordna_opptak.feature](../../../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) (`@OPT-OVO-SAM-001`), i `samordna_opptak.feature` i denne mappa.

## Krever

| Nøkkel | Type | Brukes av |
|---|---|---|
| `opptak-forvalter-forvaltende` | testbruker | alle scenarioer unntatt dem under |
| `opptak-forvalter-deltakende` | testbruker | «Legge til lærested i samordna opptak» (etter byttet), «Opptaksforvalter ved deltakende organisasjon kan se, men ikke endre innstillinger» |
| `opptak-forvalter-ikke-deltakende` | testbruker | «Organisasjon som ikke deltar kan ikke legge til utdanningstilbud», «Organisasjon som ikke deltar, ser ikke opptaket», «… kan ikke åpne opptaket» |
| `opptak-forvalter-lokalt` | testbruker | «Lokalt opptak tillater ikke andre organisasjoner», «Saksbehandlertildeling er ikke relevant for lokale opptak» |
| `opptak-samordna-uten-utdanningstilbud` | testdata | de fleste scenarioene |
| `opptak-samordna-med-utdanningstilbud` | testdata | «Organisasjon som ikke deltar kan ikke legge til utdanningstilbud», «Fjerne en deltakende organisasjon som har utdanningstilbud i opptaket», «… se, men ikke endre innstillinger», «… organisasjon som allerede er lagt til» |
| `opptak-lokalt` | testdata | «Lokalt opptak tillater ikke andre organisasjoner», «Saksbehandlertildeling er ikke relevant for lokale opptak» |
| `organisasjoner-utdanningsregisteret` | testdata | «Legge til lærested …», søket og filtrene i «Inviter» |
| `organisasjon-som-inviteres` | testdata | «Legge til organisasjon som finnes i utdanningsregisteret» |
| `regelverkssamling-samordna-annen` | testdata | «Opptaksforvalter ved forvaltende organisasjon kan endre innstillinger» |
