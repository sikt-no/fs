# Oppsett – Søke om tidlig opptak

Hva som må gjøres i testmiljøet før og etter den interne akseptansetesten, og hvordan det sjekkes. Testbrukerne og testdataene står i [testplanen](testplan.md), og «Gjør klar»-stegene i [testcasene](testcaser-intern.md). Det som kan gjøres i løsningen, gjøres der. SQL brukes bare der løsningen ikke kan gjøre det.

Skriptene i [`oppsett/`](oppsett/) kjøres mot databasen for testmiljøet, som superbruker (tabellene har RLS). De er skrevet mot fs-plattform `26d0862b43` (2026-10-26), og må sjekkes mot skjemaet hvis migreringene har endret tabellene.

## Før testen

| # | Hva | Hvordan | Hvem |
|---|---|---|---|
| 1 | Grunnlaget «Avvikle virksomheten» er inaktivt i opptak 34 (1.4) | SQL: [`for-testen-gjor-grunnlag-inaktivt.sql`](oppsett/for-testen-gjor-grunnlag-inaktivt.sql). Det finnes ingen måte å gjøre det på i løsningen | Den som har tilgang til databasen |
| 2 | Testbruker 1 (Samtidig Sild) har «Biovitenskap» ved UiO i søknaden | Min kompetanse, som i «Gjør klar»-steget for testbruker 1: legg til «Biovitenskap» med søknadsfrist 13. oktober 2027, og send søknaden | Testeren |
| 3 | Testbruker 2 (Heidi Lykke) har en sendt søknad med bare «Rettsvitenskap (jus)» ved UiO | Min kompetanse, som i «Gjør klar»-steget for testbruker 2, hvis søknaden er borte | Testeren |

Søknadene i testmiljøet blir ikke liggende lenge, så punkt 2 og 3 sjekkes dagen før testen.

## Sjekk

Kjør [`sjekk-testdata.sql`](oppsett/sjekk-testdata.sql). Det bare leser, og gir én tabell med én rad per sjekk. Alle radene skal ha `ok = true`:

- Opptak 34: tidlig opptak er slått på, lenken er satt, og søknadsfristen for tidlig opptak er ikke ute.
- Opptak 34: «Avvikle virksomheten» er inaktivt, og de fire andre grunnlagene er aktive.
- Opptak 2: tidlig opptak er slått på, og søknadsfristen for tidlig opptak er ute.
- Testbruker 1–4 har søknadene testcasene forventer. Kolonnen `faktisk` viser studieønskene.

Er en rad `false`, viser `faktisk` hva som er feil. Gjør punktet under «Før testen» på nytt, og kjør sjekken igjen.

## Etter testen

| # | Hva | Hvordan |
|---|---|---|
| 1 | «Avvikle virksomheten» er aktivt igjen i opptak 34 | SQL: [`etter-testen-gjor-grunnlag-aktivt.sql`](oppsett/etter-testen-gjor-grunnlag-aktivt.sql) |
| 2 | Testbruker 1 har søkt om tidlig opptak i 1.5, og kan ikke brukes til 1.1–1.5 igjen | Kan ikke settes tilbake i løsningen. Neste gjennomkjøring trenger en ny testbruker 1 |
