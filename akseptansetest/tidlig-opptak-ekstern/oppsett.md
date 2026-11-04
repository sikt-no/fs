# Oppsett – Tidlig opptak og tilbudsgaranti, ekstern akseptansetest

Hva som må være på plass i testmiljøet før den eksterne akseptansetesten, og hvordan det sjekkes. Testbrukerne, søkerne og testcasene står i [testcaser-ekstern.md](testcaser-ekstern.md). Det som kan gjøres i løsningen, gjøres der. SQL brukes bare der løsningen ikke kan gjøre det.

Skriptet i [`oppsett/`](oppsett/) kjøres mot databasen for testmiljøet, som superbruker (tabellene har RLS). Det er skrevet mot fs-plattform origin/main (2026-11-03), og må sjekkes mot skjemaet hvis migreringene har endret tabellene.

## Før testen

| # | Hva | Hvordan | Hvem |
|---|---|---|---|
| 1 | Tilbudsgarantitypene «Tilbudsgaranti etter ny vurdering» og «Tilbudsgaranti, forhåndsløfte» finnes i opptak 34 | Finnes fra testen av tilbudsgaranti. Mangler de (databasen er nullstilt), kjør `oppsett/for-testen-1-kopier-tilbudsgarantityper.sql` fra `akseptansetest/tilbudsgaranti-2027/` (PR #787). Det finnes ingen måte å gjøre det på i løsningen | Den som har tilgang til databasen |
| 2 | Hver tester har sin egen søker, som ikke er brukt | Kontaktpersonen fyller ut «Tester» i «Søkere til testerne», og sjekker at søkeren er «ikke brukt» | Kontaktpersonen |
| 3 | Kontaktpersonen har kjørt testcase 0 med én søker, og saken behandles av UiT | Min kompetanse og FS Admin, som i testcase 0 og 2a. Søkeren som brukes, kan ikke deles ut til en tester etterpå | Kontaktpersonen |

## Sjekk

Kjør [`sjekk-testdata.sql`](oppsett/sjekk-testdata.sql). Det bare leser, og gir én tabell med én rad per sjekk. Alle radene skal ha `ok = true`:

- Opptak 34: tidlig opptak er slått på, lenken er satt, og fristene er ikke ute.
- Opptak 34: grunnlaget i 1b, konklusjonen i 2c og tilbudsgarantitypene i 3a og 3b er aktive.
- De tre studiene finnes én gang i opptak 34, med riktig verdi for tidlig opptak.
- Hver søker finnes, vises i «Velg testsøker», og er «ikke brukt». Etter testcase 0 viser raden søknaden, studieønskene, om søkeren har søkt om tidlig opptak, og hvem som behandler saken. Den skal være UiT (186).

Er en rad `false`, viser `faktisk` hva som er feil. Er en søker brukt, eller vises ikke i «Velg testsøker», del ut en annen.

## Etter testen

| # | Hva | Hvordan |
|---|---|---|
| 1 | Søkerne er brukt | Kan ikke settes tilbake: søknaden om tidlig opptak kan ikke trekkes. En ny testrunde trenger nye søkere |
