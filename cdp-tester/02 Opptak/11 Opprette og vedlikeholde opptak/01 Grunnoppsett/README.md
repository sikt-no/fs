# CDP-tester: Grunnoppsett

Tester for kravet [opprett_opptak.feature](../../../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) (`@OPT-OVO-GRU-001`), i `opprett_opptak.feature` i denne mappa.

## Krever

| Nøkkel | Type | Brukes av |
|---|---|---|
| `opptak-forvalter-forvaltende` | testbruker | alle scenarioer for samordna opptak |
| `opptak-forvalter-lokalt` | testbruker | «Opprette et lokalt opptak», «… opptakstypene i et lokalt opptak» |
| `regelverkssamling-samordna` | testdata | Utfylling A |
| `regelverkssamling-lokalt` | testdata | Utfylling B |
| `utdanningsbakgrunner-godkjente` | testdata | Utfylling A («Realkompetanse») |
| `poenglikhetsregler` | testdata | Utfylling A |
| `organisasjon-som-inviteres` | testdata | «Opprette et samordna opptak» |
