# CDP-tester: Innstillinger

Tester for kravet [innstillinger.feature](../../../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) (`@OPT-OVO-INN-001`), i `innstillinger.feature` i denne mappa.

## Krever

| Nøkkel | Type | Brukes av |
|---|---|---|
| `opptak-forvalter-forvaltende` | testbruker | alle scenarioer |
| `opptak-samordna-uten-utdanningstilbud` | testdata | scenarioene med `@endrer-data`, og «Legge til utdanningsbakgrunner fra godkjent liste» |
| `opptak-samordna-med-utdanningstilbud` | testdata | «Kan ikke endre opptakstype …», «Kan ikke endre regelverkssamling …» |
| `opptak-utdanningsbakgrunn-valgt-av-soker` | testdata | «Utdanningsbakgrunn som søkere har valgt, kan ikke fjernes» |
| `opptak-en-utdanningsbakgrunn` | testdata | «Den siste utdanningsbakgrunnen kan ikke fjernes» |
| `regelverkssamling-samordna` | testdata | Utfylling A |
| `regelverkssamling-samordna-annen` | testdata | «Endre regelverkssamling når ingen utdanningstilbud er knyttet til opptaket» |
| `utdanningsbakgrunner-godkjente` | testdata | regelen om utdanningsbakgrunner |
| `poenglikhetsregler` | testdata | regelen om poenglikhetsregel |
