# Utkast til Jira: Gjennomføre plasstildelingen

Utkast 2026-10-28, ikke opprettet. Kravene er `@draft`, og lenkene går til `main` (kravene kommer dit når PR #850 er merget).

## Epic (TAKE-3, ny tittel): Gjennomføre plasstildelingen

Ny tittel og beskrivelse. TAKE-3 beholder de tekniske sakene om kjøringen og snapshotet (TAKE-159, TAKE-165, TAKE-265, TAKE-267, TAKE-278) og TAKE-74. TAKE-327 flyttes til epicen for rundetyper og runder, og TAKE-156, TAKE-268, TAKE-288, TAKE-330 og TAKE-331 til epicen for publisering og svar.

Opptaksforvalter starter plasstildelingen i en runde, og den gjennomføres etter innstillingene i runden, med plassflyt, kompensasjonstilbud og tilbudsgaranti. Opptaksforvalter og lærestedene ser resultatet før det publiseres. Bygger på rundetyper og runder.

Verifisering 2026-10-28: 28 av 76 scenarioer finnes i koden.

Krav: [scope-plasstildeling-2027](https://github.com/sikt-no/fs/blob/main/tasks/opptak/scope-plasstildeling-2027.md)

---

## Story: Plasstildelingen følger innstillingene i runden

Bortfall, flere tilbud per søker, og om plasstildelingen bygger på forrige runde, styres av innstillingene fra rundetypen, ikke av koden. I dag gis bortfall alltid, høyst ett ordinært tilbud, og plasstildelingen bygger alltid på sist publiserte runde.

Akseptansekriterier:

- Innstillingene for plasstildelingsrunden avgjør hva som skjer med lavere prioriteter og tidligere tilbud (`@OPT-PLA-TIL-002`)
- En plasstildeling bygger på forrige publiserte plasstildelingsrunde når rundetypen sier det (`@OPT-PLA-TIL-001`)
- I etterfylling gis nøyaktig det antallet tilbud som er satt (`@OPT-PLA-INN-001`)

Krav: [gjennomføre_plasstildeling.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/gjennomf%C3%B8re_plasstildeling.feature) · [starte_plasstildeling.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/starte_plasstildeling.feature)

## Story: Starte plasstildelingen på riktig grunnlag

Bare saker som er ferdig behandlet, er med, og plasstildelingen starter ikke når forrige runde ikke er publisert eller grunnlaget er tomt. Bare opptakets forvalter ser muligheten til å starte.

Akseptansekriterier:

- Opptaksforvalter bestiller en plasstildeling som kjører i bakgrunnen (`@OPT-PLA-TIL-001`)
- Plasstildelingen starter ikke på et tomt grunnlag
- En plasstildeling som feiler erstattes av en ny

Krav: [starte_plasstildeling.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/starte_plasstildeling.feature)

## Story: Tilbudsgaranti fra saksbehandlingen og SPEV i plasstildelingen

Tilbudsgaranti som er satt i saksbehandlingen, gir tilbud i plasstildelingen, også uten poengsum, og teller med i antall tilbud. Er det flere med tilbudsgaranti enn antall tilbud, får alle med tilbudsgaranti tilbud, og ingen andre. SPEV-kvoten har ingen egne plasser. I dag virker bare tilbudsgarantien fra et tilbud søkeren har takket ja til.

Akseptansekriterier:

- Søker med tilbudsgaranti får tilbud uavhengig av poengsum (`@OPT-PLA-TIL-002`)

Krav: [gjennomføre_plasstildeling.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/gjennomf%C3%B8re_plasstildeling.feature)

## Story: Avslag og søkere som har mistet kvalifiseringen

Hver kvotesøknad får ett resultat, også avslag, og en søker som har mistet kvalifiseringen, forsvinner ikke stille. Kvotetyper uten kvoteprioritet eller plassflyt brukes ikke.

Akseptansekriterier:

- Ingen søker forsvinner stille (`@OPT-PLA-TIL-002`)
- Søkeren prøves i utdanningskvotene etter kvoteprioritet
- Poenglikhetsregelen avgjør rekkefølgen ved lik poengsum (underrepresentert kjønn og loddtrekning mangler)

Krav: [gjennomføre_plasstildeling.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/gjennomf%C3%B8re_plasstildeling.feature)

## Story: Poenggrense per utdanningskvote

Plasstildelingen beregner og lagrer poenggrensen per utdanningskvote, og om alle kvalifiserte fikk tilbud. I dag skrives poenggrensen aldri. Se også TAKE-265.

Akseptansekriterier:

- Poenggrensen beregnes per utdanningskvote (`@OPT-PLA-TIL-002`)

Krav: [gjennomføre_plasstildeling.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/gjennomf%C3%B8re_plasstildeling.feature)

## Story (TAKE-328, beskrivelsen oppdateres): Kompensasjonstilbud ved opprykk

Ny beskrivelse: kompensasjonstilbudet styres av innstillingen i rundetypen, ikke av at det er en suppleringsrunde. I dag gis frigjorte plasser videre i alle runder, og `kompenserForOpprykk()` kalles ikke.

Akseptansekriterier:

- En plass som frigjøres ved opprykk gis til neste på ventelisten (`@OPT-PLA-TIL-003`)
- Kompensasjonstilbud teller mot antall tilbud som skal gis i plasstildelingsrunden
- Kompensasjonstilbud gis bare når rundetypen har kompensasjonstilbud ved opprykk

Krav: [kompensasjonstilbud_ved_opprykk.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/kompensasjonstilbud_ved_opprykk.feature)

## Story (TAKE-329 deles, ny sak): Resultatet før publisering

Opptaksforvalter og lærestedene ser resultatet av plasstildelingen før det publiseres, avgrenset til søknadene organisasjonen saksbehandler eller tilbyr, og kan sammenligne plasstildelinger i runden. TAKE-329 blir saken for det publiserte resultatet (epicen for publisering og svar).

Akseptansekriterier:

- Opptaksforvalter ser ett tydelig resultat per søknad (`@OPT-PLA-RES-001`)
- Opptaksforvalter ser totaltall for plasstildelingen
- Det kan spores at en plass kom via plassflyt
- Søkerne ser ikke plasstildelingen før den er publisert, men lærestedene gjør det
- Lærestedene kontrollerer resultatet før plasstildelingsrunden publiseres
- Plasstildelinger i samme plasstildelingsrunde kan sammenlignes

Krav: [vise_resultat.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/vise_resultat.feature)

## Bug: Tilgangen til plasstildelingen gjelder hele opptaket

Opptaksforvalter og saksbehandler ved en deltakende organisasjon ser alle søknadene i plasstildelingen, ikke bare søknadene organisasjonen saksbehandler eller tilbyr. Startknappen vises også for deltakende organisasjoner.

Forventet: Søkerne ser ikke plasstildelingen før den er publisert, men lærestedene gjør det (`@OPT-PLA-RES-001`), og bare opptakets forvalter starter plasstildelingen (`@OPT-PLA-TIL-001`).

Kode: `fs-plattform/…/V306__plasstildeling_v2_rls.sql:41-52,155-160`, `V350__soknadsbehandler_ser_plasstildeling.sql:16`, `fs-admin/…/ParameterFeature/ParameterFeature.tsx:374-380`.

Krav: [vise_resultat.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/vise_resultat.feature) · [starte_plasstildeling.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/starte_plasstildeling.feature) · [verify-2026-10-28-1645.md](https://github.com/sikt-no/fs/blob/main/akseptansetest/plasstildeling-2027/verify-2026-10-28-1645.md)

## Bug: Plassflyt til en kvote utdanningstilbudet ikke har, stopper kjøringen

Peker plassflyten på en kvote utdanningstilbudet ikke har, feiler hele plasstildelingen. Det samme skjer når en kvote som andre flyter til, slettes.

Forventet: Ledige plasser går til den første kvoten i kjeden som finnes på utdanningstilbudet (`@OPT-PLA-INN-002`).

Kode: `fs-plattform/…/plasstildeling/service/PlasstildelingKjoringService.java:256-263`.

Krav: [plassflyt.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/02%20Tildelingsinnstillinger/plassflyt.feature) · [verify-2026-10-28-1645.md](https://github.com/sikt-no/fs/blob/main/akseptansetest/plasstildeling-2027/verify-2026-10-28-1645.md)

## Bug: «Ønsket antall tilbud» i resultatet blir omtrent 0

For brukere som har tilgang til opptaket, trekkes overbookingen fra et tall som allerede er overbookingen, så «Ønsket antall tilbud» blir omtrent 0.

Forventet: Antall tilbud som skal gis vises med tilgang til plasstildelingen (`@OPT-PLA-RES-001`).

Kode: `fs-plattform/…/plasstildeling/TilbudslisteService.java:548` og `KvoterService.java:98-103`.

Krav: [vise_resultat.feature](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/vise_resultat.feature) · [verify-2026-10-28-1645.md](https://github.com/sikt-no/fs/blob/main/akseptansetest/plasstildeling-2027/verify-2026-10-28-1645.md)
