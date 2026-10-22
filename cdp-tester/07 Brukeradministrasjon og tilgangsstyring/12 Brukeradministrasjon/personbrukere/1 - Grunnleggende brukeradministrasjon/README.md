# CDP-tester: Listevisning og søk i personbrukere

Tester for [søke_opp_bruker.feature](../../../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/søke_opp_bruker.feature) (`@BRU-PER-GRU-001`). Pilot: 5 av 17 scenarioer i gating-settet er skrevet, de som ikke trenger bestemte testdata. Skrevet for hånd, før `fs-testcaser-cdp` er prøvd ut.

## Krever

| Nøkkel | Type | Beskrivelse | Brukes av |
|---|---|---|---|
| `brukeradministrator-alle-miljoer` | testbruker | Brukeradministrator i alle miljøer, ved organisasjon A. Har rollen `BRUKERADMINISTRASJON_LES` i fs-admin | alle scenarioer |
| `over-50-personbrukere` | testdata | Minst 51 personbrukere synlige for testbrukeren (verifiseringen 7.10 fant 71 aktive i testmiljøet: kontrolleres før kjøring) | «Liste viser de 50 første personbrukerne», «Laste inn 50 flere personbrukere», «Alle personbrukere er lastet inn» |

Nøklene slås opp i `akseptansetest/grunnleggende-brukeradministrasjon/testplan.md` (kolonnene `Nøkkel`, `Innlogging`, `Start-URL`).

## Ikke kjørbart

| Scenario | Grunn | Kan kjøres når |
|---|---|---|
| «Navigere til detaljside for personbruker», «Fritekst-søk på navn», «Fritekst-søk på Feide-ID», «Tilgjengelige roller i filter», «Filtrere på rolle», «Kombinere søk og filtre» | Ikke med i piloten. Trenger ingen bestemte testdata: søketeksten og filterverdiene hentes fra selve listen | Etter piloten |
| «Filtrere på status» | Bare «Aktiv» kan sjekkes: ingen deaktiverte personbrukere i testmiljøet (verifiseringen 7.10) | Det finnes en deaktivert personbruker, eller `personbruker-deaktiveres` er deaktivert |
| «Tilgjengelige hjemorganisasjoner i filter», «Filtrere på hjemorganisasjon» | Alle personbrukere har hjemorganisasjon Sikt (verifiseringen 7.10), og filteret kan tilby organisasjoner som ikke finnes i listen (BAT-276) | Testmiljøet har personbrukere fra flere hjemorganisasjoner, og BAT-276 er rettet |
| «Brukeradministrator ser personbrukere med hjemorganisasjon i organisasjonene jeg administrerer», «Brukeradministrator ser personbrukere fra andre organisasjoner med aktiv rolle i organisasjonene jeg administrerer», «Personbrukere med annen hjemorganisasjon er ikke synlige når rollen gjelder i et miljø jeg ikke administrerer» | Synligheten i koden har flere grener enn kravet (domene, aktiv tildeling og saksbehandlergren, BAT-298), og trenger testbrukere i flere organisasjoner og testdata fra testplanen | Testbrukere og testdata for synlighet er fylt ut, og BAT-298 er avklart |
