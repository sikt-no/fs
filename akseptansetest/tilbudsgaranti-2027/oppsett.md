# Oppsett – Tilbudsgaranti i saksbehandlingen 2027

Hva som må gjøres i testmiljøet før og etter den interne akseptansetesten, og hvordan det sjekkes. Testbrukerne og testdataene står i [testplanen](testplan.md), og «Gjør klar»-stegene i [testcasene](testcaser-intern.md). Det som kan gjøres i løsningen, gjøres der. SQL brukes bare der løsningen ikke kan gjøre det.

Skriptene i [`oppsett/`](oppsett/) kjøres mot databasen for testmiljøet, som superbruker (tabellene har RLS). De er skrevet mot fs-plattform i oktober 2026 (testet mot `0229f59fb3` og nyere), og må sjekkes mot skjemaet hvis migreringene har endret tabellene.

## Før testen

Gjør punktene i rekkefølge. **Unntaket (punkt 2) må være på plass før utdanningsbakgrunnen overstyres i 1.18.** Legges det inn mens en søknad har overstyrt utdanningsbakgrunn UTLAND, flytter neste søknadshendelse saken med en gang. Det skjedde 2026-10-26.

| # | Hva | Hvordan | Hvem |
|---|---|---|---|
| 1 | Opptak 34 har tilbudsgarantitypene fra opptak 1, uten TEL (1.10) | SQL: [`for-testen-1-kopier-tilbudsgarantityper.sql`](oppsett/for-testen-1-kopier-tilbudsgarantityper.sql). Skriptet sletter typene i opptak 34 først. Kjør «Før»-spørringen først: den viser typer som er i bruk i opptak 34, men ikke finnes i opptak 1. Står det noe der, feiler kopieringen | Den som har tilgang til databasen |
| 2 | Regelen ORD i opptak 34 har unntaket UTLAND → forvalteren av opptaket (1.18) | SQL: [`for-testen-2-unntak-utland-til-forvalter.sql`](oppsett/for-testen-2-unntak-utland-til-forvalter.sql). Kan kanskje også gjøres i FS Admin, hvis siden for saksbehandlertildeling finnes der | Den som har tilgang til databasen |
| 3 | «Elektronisk systemingeniør …» er prioritet 1 i søknad 1000836, uten tilbudsgaranti | I FS Admin: velg «Ikke valgt» i de tre feltene for tilbudsgaranti. I Min kompetanse: flytt søknadsalternativet til prioritet 1 | Testeren |

Punkt 1 og 2 trengs bare én gang, og må gjøres på nytt hvis testdatabasen nullstilles.

## Sjekk

Kjør [`sjekk-testdata.sql`](oppsett/sjekk-testdata.sql). Det bare leser, og gir én tabell med én rad per sjekk. Alle radene skal ha `ok = true`:

- Opptak 34 har KLA, RES, REA og FOR, og de er aktive. TEL finnes i opptak 1, men ikke i opptak 34.
- Unntaket ORD + UTLAND går til forvalteren av opptak 34.
- Søknad 1000836 har ikke overstyrt utdanningsbakgrunn, og alle søknadsalternativene behandles av 194 (NTNU).
- «Elektronisk systemingeniør …» er prioritet 1, og har ingen tilbudsgaranti.

Er en rad `false`, viser `faktisk` hva som er feil. Gjør punktet under «Før testen» på nytt, eller «Etter testen» hvis søknaden er flyttet, og kjør sjekken igjen.

## Etter testen

1.18 flytter saken til HK-dir, og den kommer ikke tilbake av seg selv, selv om utdanningsbakgrunnen settes tilbake. Skal søknaden brukes igjen, gjør dette i rekkefølge:

| # | Hva | Hvordan |
|---|---|---|
| 1 | Overstyringen av utdanningsbakgrunnen er fjernet | FS Admin: fjern overstyringen i saken til Overbevisende Havhest. Gjøres dette ikke først, flytter neste tildeling saken til HK-dir igjen |
| 2 | Søknadsalternativene er tilbake hos 194, og saken hos 194 er aktiv | SQL: [`etter-testen-flytt-soknad-1000836-tilbake-til-194.sql`](oppsett/etter-testen-flytt-soknad-1000836-tilbake-til-194.sql). Kjør «Før»-spørringene først, og se at de stemmer med kommentarene |
| 3 | «Elektronisk systemingeniør …» er prioritet 1, uten tilbudsgaranti | Som punkt 3 under «Før testen» |

Tilbudsgarantitypene og unntaket blir stående. Testen endrer dem ikke.
