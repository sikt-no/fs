# Testrapport – agentisk funksjonstest – Gi tilbudsgaranti ved tidlig opptak

- **Nivå**: agentisk
- **Fase**: 2
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5181997074
- **Scope**: @scope-tidlig-opptak
- **Grunnlag**: [`kjoring-2026-11-11-1057/resultat.md`](kjoring-2026-11-11-1057/resultat.md), lest 2026-11-11. Prøven [`kjoring-2026-11-10-1440`](kjoring-2026-11-10-1440/resultat.md) (3 testcaser ikke testet på grunn av F1) er ikke talt med: alle testcasene er kjørt på nytt 2026-11-11, etter at F1 var rettet
- **Branch**: `testplan/beh-007-tidligopptak` (PR #989), oppdatert mot origin, 92 commits bak main (fortsatt uten å hente main)
- **Confluence**: –
- **Laget**: 2026-11-11 av fs-testrapport

---

Testrapport for «Gi tilbudsgaranti ved tidlig opptak». Den bygger på den agentiske kjøringen 2026-11-11 i TEST, med testene i [`cdp-tester/02 Opptak/13 Søknad og saksbehandling/02 Behandling/`](../../cdp-tester/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature).

## Oppsummering

| Felt | Innhold |
|---|---|
| Kjøring | `kjoring-2026-11-11-1057`, startet av Jens Peter Thomassen og kjørt av Claude (cdp-skillen), mot TEST (https://test-fsadmin.sikt.no, opptak 34 «Samordna UHG-simulering høsten 2026»). Versjonen er ikke notert i kjøringen |
| Testcaser | 40 bestått, 0 ikke bestått, 5 ikke testet, 0 ikke fylt ut, av 45 (foreslått av agenten) |
| Fra scenarioene i kravene | 33 testcaser: 29 bestått, 4 ikke testet |
| Utledet av agenten | 12 testcaser (regler uten scenario, grenseverdier, beslutningstabell, tilstandsoverganger og ekvivalensklasser): 11 bestått, 1 ikke testet |
| Funn | Ingen nye. F1 fra prøven 2026-11-10 (opptaksforvalteren så ikke «Kjør tidligopptak») er rettet i rollekatalogen. 0 «Kravet dekker ikke» |
| Testdata | Søkerne og poenggrensene fantes. To lister i miljøfila stemmer ikke med TEST (`sak-tidlig-opptak-prioritet-1-uten-tidlig-opptak` og `sak-tidlig-opptak-to-saker`), og to opptak finnes ikke (`opptak-tidlig-opptak-uten-tilbudsgarantitype` og `opptak-tidlig-opptak-to-tilbudsgarantityper`). Se «Testdata og bevis» |
| Gjennomgått av testansvarlig | [Fylles ut av testansvarlig] |
| Stikkprøve av beståtte testcaser | [Fylles ut av testansvarlig] (størrelsen avgjøres etter en risikovurdering, det er ikke noe fast antall) |
| Inngangskriterium til intern akseptansetest | Ikke oppfylt ennå: testansvarlig har ikke gått gjennom rapporten (se «Inngangskriteriet til intern akseptansetest») |

Tallene: 3 bestått i scenariomalen «Tilbudsgaranti ut fra poenggrensen», 5 i scenariomalen med medianen, og 2 ikke testet i scenariomalen «Tidligopptaket stopper …», talt per eksempel.

## Inngangskriteriet til intern akseptansetest

Sjekkes for seg, fordi det er inngangen til fase 3. Den agentiske rapporten har ingen beslutning, bare dette.

| Kriterium | Oppfylt |
|---|---|
| Alle testcasene er kjørt (ingen «ikke fylt ut», og «ikke testet» har begrunnelse) | Ja: alle 45 har status, og de 5 som er «ikke testet», har begrunnelse (se «Ikke testet») |
| Ingen funn med «Stopper» står åpne | Ja: ingen åpne funn |
| Testansvarlig har gått gjennom rapporten, også funnene og stikkprøven av de beståtte | [Fylles ut av testansvarlig] |

## Resultat per krav

Kravet er [Gi tilbudsgaranti ved tidlig opptak](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature) (`@OPT-BEH-BEH-007`, delvis levert: de 25 leverte scenarioene er testet).

| Krav | Regel | Teknikk | Bestått | Ikke bestått | Ikke testet |
|---|---|---|---|---|---|
| `@OPT-BEH-BEH-007` | Opptaksforvalter gjennomfører tidligopptaket | Positiv | 18 | 0 | 2 |
| `@OPT-BEH-BEH-007` | Opptaksforvalter gjennomfører tidligopptaket | Grenseverdi | 4 | 0 | 0 |
| `@OPT-BEH-BEH-007` | Opptaksforvalter gjennomfører tidligopptaket | Beslutningstabell | 3 | 0 | 0 |
| `@OPT-BEH-BEH-007` | Opptaksforvalter gjennomfører tidligopptaket | Tilstandsovergang | 2 | 0 | 0 |
| `@OPT-BEH-BEH-007` | Opptaksforvalter gjennomfører tidligopptaket | Ekvivalensklasse | 4 | 0 | 0 |
| `@OPT-BEH-BEH-007` | Median poengsum fra forrige opptak brukes når poenggrensen ikke er satt | Grenseverdi | 6 | 0 | 0 |
| `@OPT-BEH-BEH-007` | Median poengsum fra forrige opptak brukes når poenggrensen ikke er satt | Positiv | 1 | 0 | 0 |
| `@OPT-BEH-BEH-007` | Opptaksforvalter ser utfallet av tidligopptaket | Positiv | 1 | 0 | 2 |
| `@OPT-BEH-BEH-007` | Opptaksforvalter ser utfallet av tidligopptaket | Ekvivalensklasse | 0 | 0 | 1 |
| `@OPT-BEH-BEH-007` | Manuell tilbudsgaranti krever ikke deltakelse i tidligopptaket | Positiv | 1 | 0 | 0 |
| | **Til sammen** | | **40** | **0** | **5** |

«Positiv» er scenarioene i kravet som står uten egen teknikk i testen. Eksemplene i scenariomalene «Tilbudsgaranti ut fra poenggrensen» (P − 5, P og P + 5) og «Tilbudsgaranti ut fra poenggrensen eller medianen fra forrige opptak» (over, lik og under medianen, P + 2 og P − 2) er fra kravet, men er grenseverdier, og står under «Grenseverdi».

## Regler uten scenario

Fra «Regler uten scenario» i omfanget (verify-rapporten 2026-11-09). 7 av de 12 reglene skulle testes i fase 2, og alle 7 er testet og bestått. De 5 andre var ikke planlagt testet i fase 2.

| Krav | Regel i koden | Funnet i | Testet i fase 2 | Kravet bør få scenario |
|---|---|---|---|---|
| `@OPT-BEH-BEH-007` | Søknadsalternativ uten poengsum i garantikvoten gir ikke tilbudsgaranti | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:765-775` | ja: «… søknadsalternativet har ingen poengsum», bestått | nei |
| `@OPT-BEH-BEH-007` | Utdanningstilbud uten rangeringsregelverk, kvoter eller kompetanseregelverk gir ikke tilbudsgaranti | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:699-708, 745-763` | nei: utgangstilstanden kan ikke lages i opptak 34 uten å endre utdanningstilbudene andre tester bruker | nei: visningen er utsatt i kravet |
| `@OPT-BEH-BEH-007` | Kansellerte utdanningstilbud er ikke med i tidligopptaket | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:362-363` | nei: utdanningstilbudene i opptak 34 brukes av andre tester | nei |
| `@OPT-BEH-BEH-007` | Poengsummen tas bare fra kvoter søkeren skal kvoteplasseres i og som tilbudet har, og fra grunnlag rangeringsregelverket åpner for | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:922-927, 937-960` | ja: «… poengsummen i en kvote søkeren ikke skal kvoteplasseres i», bestått | nei |
| `@OPT-BEH-BEH-007` | Kvalifiseringen: ett kvalifisert grunnlag holder, ellers ikke kvalifisert bare når alle grunnlagene er vurdert til nei | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:790-813` | ja: «… kvalifiseringen har flere grunnlag» (2 eksempler), bestått | nei |
| `@OPT-BEH-BEH-007` | Trukne søknadsalternativer og saker som ikke er aktive, er ikke med | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:534, 544, 868-869` | ja: «… søknadsalternativet med høyest prioritet er trukket», bestått (se «Bestått, men faktisk resultat avviker») | nei |
| `@OPT-BEH-BEH-007` | En søker som ikke har søkt om tidlig opptak, men har et tidligopptakstilbud, er med og får tilbudsgaranti | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:520-545` | ja: «… tidligopptakstilbud uten søknad om tidlig opptak», bestått | uklart om ønsket: avklares med `fs-krav` |
| `@OPT-BEH-BEH-007` | Reservert studieplass i kolonnen til opptaksforvalter erstattes av tilbudsgarantien fra tidligopptaket | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:692-694, 1022-1024` | ja: «… reservert studieplass fra opptaksforvalter blir erstattet», bestått | ja (`fs-krav`) |
| `@OPT-BEH-BEH-007` | Treffer en skriving ingen rad, stoppes hele gjennomføringen og rulles tilbake | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:1005-1012` | nei: krever samtidige endringer | nei |
| `@OPT-BEH-BEH-007` | Gjennomføringen er sperret i fs-admin til prøvekjøringen har gitt en oppsummering, når poenggrenser ikke er lagret, og når prøvekjøringen gir feil | `fs-admin/…/TidligOpptakResultModal.tsx:150-154, 162-165` | ja: «… poenggrensen er ikke lagret», bestått. Sperren ved feil i prøvekjøringen er ikke sett (opptakene uten eller med to tilbudsgarantityper finnes ikke) | nei |
| `@OPT-BEH-BEH-007` | Antallet i meldingen etter gjennomføringen teller avvik, tar med overskredet kvote, og vises bare når det er over 0 | `fs-admin/…/KjorTidligopptakButton.tsx:129-134` | nei: venter på at avvikene vises i prøvekjøringen. Meldingen er sett i kjøringen: «3 utdanningstilbud er feilkonfigurert for tidlig opptak.» og «2 utdanningstilbud er feilkonfigurert …» | uklart om ønsket |
| `@OPT-BEH-BEH-007` | Kvotevarselet er 30 prosent når grensen ikke er angitt | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:96-97` | nei: kvotevarselet er utsatt | nei: dekkes av det utsatte scenarioet |

## Testdata og bevis

| Felt | Innhold |
|---|---|
| Testdata | Søkerne i miljøfila ([`test.md`](../../cdp-tester/_Milj%C3%B8er/test.md)), med søknadene laget i Min kompetanse 2026-11-10 og kvalifiseringen og poengsummen fra SQL-skriptet. Poenggrensene fra oppsettet 2026-11-10 (0,0 på «Datateknikk ingeniør» og «Elektronisk systemingeniør», tom på «Paramedisin» og «Medisin» ved UiT) sto fortsatt, og ble satt tilbake etter hvert scenario. Manglet eller var i feil tilstand: søkerne i `sak-tidlig-opptak-prioritet-1-uten-tidlig-opptak` har saken hos organisasjon 224, ikke UiT, og søkerne i `sak-tidlig-opptak-to-saker` har én sak, ikke to (søknaden får én sak, hos organisasjonen som behandler prioritet 1). `opptak-tidlig-opptak-uten-tilbudsgarantitype` og `opptak-tidlig-opptak-to-tilbudsgarantityper` finnes ikke i TEST |
| Kan kjøres på nytt | Ja, med nye søkere: gjennomføringen kan ikke settes tilbake, så hver testcase bruker sin egen søker. 45 søkere er brukt. Igjen i `sak-tidlig-opptak-kvalifisert`: Klok Netthinne, Robust Skatoll, Idiotsikker Matte og Misfornøyd Ambassade. Poenggrensene er satt tilbake |
| Bevis | `akseptansetest/gi-tilbudsgaranti-ved-tidlig-opptak/kjoring-2026-11-11-1057/` (`resultat.md` er i git, skjermbilder er lokale og ikke i git) |

Opptak 34 endres av andre i TEST: fristen for poenggrensene ble satt og noen medianer ble endret 2026-11-11, og tallene i prøvekjøringen tar med søkere fra andre tester. Testcasene sjekker derfor søkerens egen sak, og «Se antall søkere …» sjekker forskjellen i tallet.

## Ikke bestått

Ingen.

## Bestått, men faktisk resultat avviker

Testcaser med status «Bestått» der «Faktisk resultat» beskriver noe annet enn forventet resultat. Testansvarlig ser på dem og avgjør status. Skillen endrer ikke statusen.

| Nr | Scenario | Forventet resultat | Faktisk resultat |
|---|---|---|---|
| 1 | Tilbudsgaranti ut fra poenggrensen (grense P + 5) | «Tilbudsgaranti, forhåndsløfte» står ikke under «Tilbudsgaranti fra forvalter» for «Datateknikk ingeniør» | Som forventet for «Datateknikk ingeniør». Søkeren fikk i tillegg tilbudsgaranti på «Elektronisk systemingeniør» (prioritet 2), fordi poenggrensen der er 0,0 fra oppsettet. Testen sjekker bare prioritet 1 |
| 2 | Opptaksforvalter gjennomfører tidligopptaket: søknadsalternativet med høyest prioritet er trukket | Søkeren fjerner «Datateknikk ingeniør» fra søknaden i Min kompetanse, og får tilbudsgaranti på det andre søknadsalternativet | Tilbudsgarantien kom på «Elektronisk systemingeniør», som forventet. Men søknaden ble endret gjennom API-et Min kompetanse bruker, som søkeren, ikke i skjermen: «Velg testsøker» kunne ikke velges med CDP. Saken i FS Admin viser bare det gjenværende søknadsalternativet, ikke det fjernede som trukket |
| 3 | Tilbudsgaranti ut fra poenggrensen eller medianen fra forrige opptak (lik, tom poenggrense) | Klargjøring K lagres, og søkeren får tilbudsgaranti | Første klargjøring ble ikke lagret: etter ny innlasting sto saken som «Ikke behandlet» og «Konklusjon» «Ikke valgt», og saken var ikke med i gjennomføringen. Andre gang ble den lagret, og en egen gjennomføring ga tilbudsgaranti |

## Ikke testet

Testansvarlig vurderer begrunnelsene før beslutningen.

| Nr | Scenario | Begrunnelse |
|---|---|---|
| 1 | Annen tilbudsgaranti på et høyere prioritert søknadsalternativ stopper ikke tidligopptaket | Testdataene stemmer ikke: saken til Aktuell Kjepphest ligger hos organisasjon 224, som behandler prioritet 1 («Bachelorstudium i arbeids- og velferdsfag»), og saksbehandleren ved UiT ser ikke «Konklusjon» og «Behandlingsstatus». Miljøfila og testen må rettes |
| 2 | Søknadsalternativ uten tilbudsgaranti går videre til ordinært opptak | Stegene før virket (ingen tilbudsgaranti). «Prøvetildeling» finnes ikke: «Plasstildeling» har «Runder», «Sammenlign kjøringer» og «Opprett runde», og opptak 34 har ingen runder. Agenten opprettet ikke en runde i et opptak andre bruker. Steget er merket `[Sjekk begrep]` i testen |
| 3 | Opptaksforvalter ser utfallet av tidligopptaket: en søker med to saker som ikke er ferdig behandlet | Testdataene stemmer ikke: søkerne i `sak-tidlig-opptak-to-saker` har én sak (hos UiT), fordi UiT også behandler «Elektronisk systemingeniør» |
| 4 | Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak (`opptak-tidlig-opptak-uten-tilbudsgarantitype`) | Opptaket finnes ikke i TEST (miljøfila: «Finnes ikke»). Feilmeldingen «Fant ingen tilbudsgarantitype» er ikke sett |
| 5 | Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak (`opptak-tidlig-opptak-to-tilbudsgarantityper`) | Opptaket finnes ikke i TEST, og tilbudsgarantityper kan ikke legges til i FS Admin. Feilmeldingen med «tvetydig» er ikke sett |

Nr. 1, 3, 4 og 5 er kjent på forhånd som data testene ikke kan lage, og er kandidater til delen «Det den agentiske testen ikke klarte» i den interne akseptansetesten. Nr. 2 trenger at stegene for prøvetildelingen avklares først.

## Funn

Sortert etter alvorlighetsgrad. «Fase funnet» er 2.

Ingen nye funn i kjøringen 2026-11-11. F1 fra prøven 2026-11-10 er rettet og bekreftet:

| # | Fase funnet | Testcase | Type | Hva skjedde | Alvorlighetsgrad | Sak | Oppfølging |
|---|---|---|---|---|---|---|---|
| F1 | 2 | Alle testcasene med Gjennomføring G | Feil | «Kjør tidligopptak» vistes ikke for opptaksforvalteren ved HK-dir: rollen OPPTAK_FORVALTER ga ikke `FS-ADMIN_SE_SØKNADSBEHANDLING` | Ikke satt i kjøringen | – | Rettet i rollekatalogen før kjøringen 2026-11-11. Knappen vises, og gjennomføringen virker |

## Neste steg

- Testansvarlig går gjennom rapporten, funnene, «Bestått, men faktisk resultat avviker» og «Ikke testet», og tar en stikkprøve av de beståtte testcasene. Da er inngangskriteriet oppfylt, og neste steg er `fs-testcaser-intern` (testcasene for fase 3).
- Testene og miljøfila: rett listene `sak-tidlig-opptak-prioritet-1-uten-tidlig-opptak` og `sak-tidlig-opptak-to-saker` (saken følger prioritet 1), og avklar stegene for prøvetildelingen (`fs-testcaser-cdp`).
- Kravet: to av reglene uten scenario bør avklares med `fs-krav` (reservert studieplass fra opptaksforvalter som erstattes, og tidligopptakstilbud uten søknad om tidlig opptak).

## Læring

Fylles ut etter det korte møtet mellom testerne og teamlederne.

- Hvilke feil burde vært fanget tidligere? F1 (rollen til opptaksforvalteren) ble ikke fanget i fase 1, fordi `fs-verify` leste kravene til rollene i koden, men ikke rollekatalogen i TEST.
- Hva bør endres i testprosessen?
- Testcaser som var feil eller uklare: testdataene for søkere med prioritet 1 uten tidlig opptak og med to saker bygde på at én søknad kan få flere saker. Steget for prøvetildelingen er ikke avklart.
- Regler uten scenario som burde vært i kravet: reservert studieplass fra opptaksforvalter som erstattes (`fs-krav`), og om et tidligopptakstilbud uten søknad om tidlig opptak er ønsket (uklart).
