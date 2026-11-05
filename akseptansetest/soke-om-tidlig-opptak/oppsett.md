# Oppsett – Søke om tidlig opptak

Hva som må gjøres i testmiljøet før og etter den interne akseptansetesten, og hvordan det sjekkes. Testbrukerne, testdataene og testcasene står i [akseptansetesting.md](akseptansetesting.md). Det som kan gjøres i løsningen, gjøres der. SQL brukes bare der løsningen ikke kan gjøre det.

Skriptene i [`oppsett/`](oppsett/) kjøres mot databasen for testmiljøet, som superbruker (tabellene har RLS). De er skrevet mot fs-plattform `26d0862b43` (2026-10-26), og må sjekkes mot skjemaet hvis migreringene har endret tabellene.

## Før testen

| # | Hva | Hvordan | Hvem |
|---|---|---|---|
| 1 | Grunnlaget «Avvikle virksomheten» er inaktivt i opptak 34 (3.1) | SQL: [`for-testen-gjor-grunnlag-inaktivt.sql`](oppsett/for-testen-gjor-grunnlag-inaktivt.sql). Det finnes ingen måte å gjøre det på i løsningen | Den som har tilgang til databasen |
| 2 | Testbruker 1 (Samtidig Sild) har «Biovitenskap» ved UiO i søknaden | Min kompetanse, som testbruker 1: åpne søknaden, velg «Legg til studieønsker», legg til «Biovitenskap» med søknadsfrist 13. oktober 2027, og send søknaden | Testeren |
| 3 | Testbruker 2 (Heidi Lykke) har en sendt søknad med bare «Rettsvitenskap (jus)» ved UiO | Min kompetanse, hvis søknaden er borte: som testbruker 2, legg til «Rettsvitenskap (jus)» ved UiO med søknadsfrist 13. oktober 2027 som eneste studieønske, og send søknaden. Søknadsnummeret begynner med 34- | Testeren |
| 4 | Testbruker 3 (Frisk Frosk) har ingen søknad i «Samordna UHG-simulering høsten 2026», heller ikke en som ikke er sendt. Søknaden startes i 1.2 | Min kompetanse, hvis det finnes en søknad som ikke er sendt: som testbruker 3, åpne søknaden og fjern studieønsket. Det finnes ingen knapp for å slette søknaden, men uten studieønsker er den borte. En sendt søknad kan ikke fjernes, og da trengs en ny testbruker 3 | Testeren |

Søknadene i testmiljøet blir ikke liggende lenge, så punkt 2, 3 og 4 sjekkes dagen før testen.

## Sjekk

Kjør [`sjekk-testdata.sql`](oppsett/sjekk-testdata.sql). Det bare leser, og gir én tabell med én rad per sjekk. Alle radene skal ha `ok = true`:

- Opptak 34: tidlig opptak er slått på, lenken er satt, og søknadsfristen for tidlig opptak er ikke ute.
- Opptak 34: «Avvikle virksomheten» er inaktivt, og de fire andre grunnlagene er aktive.
- Opptak 2: tidlig opptak er slått på, og søknadsfristen for tidlig opptak er ute.
- Testbruker 1, 2 og 4 har søknadene testcasene forventer, og testbruker 3 har ingen søknad i opptak 34. Kolonnen `faktisk` viser studieønskene.

Er en rad `false`, viser `faktisk` hva som er feil. Gjør punktet under «Før testen» på nytt, og kjør sjekken igjen.

## Etter testen

| # | Hva | Hvordan |
|---|---|---|
| 1 | «Avvikle virksomheten» er aktivt igjen i opptak 34 | SQL: [`etter-testen-gjor-grunnlag-aktivt.sql`](oppsett/etter-testen-gjor-grunnlag-aktivt.sql) |
| 2 | Testbruker 1 har søkt om tidlig opptak i 2.4, og kan ikke brukes til 1.1, 2.1, 2.2, 2.4 og 3.1 igjen | Kan ikke settes tilbake i løsningen. Neste gjennomkjøring trenger en ny testbruker 1 |
| 3 | Testbruker 3 har en søknad som ikke er sendt, fra 1.2 | Min kompetanse, som testbruker 3: åpne søknaden og fjern studieønsket. Det finnes ingen knapp for å slette søknaden, men uten studieønsker er den borte |
