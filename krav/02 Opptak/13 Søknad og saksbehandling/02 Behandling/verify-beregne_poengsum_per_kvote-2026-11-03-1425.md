# Verifisering: beregne_poengsum_per_kvote.feature

- **Dato:** 2026-11-03 14:25
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/beregne_poengsum_per_kvote.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (origin/main, c0b792ff84, lest fra origin/main; utsjekket branch `mahj/autopuff/kravelementer` er 32 bak main), `fs-admin` (origin/main, 3fba97c73, lest fra origin/main; utsjekket branch `mahj/autopuff/kravelementer` er 21 bak main)
- **Åpne MR-er:** 2 MR-er i fs-plattform, 2 i fs-admin (1 med kode for kravene: fs-plattform !6509)
- **Omfang:** alle krav uansett status, for OPT-BEH-BEH-031 (valgt). Kravet var `@in-progress` etter pull, så gating-settet er det vanlige.
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Skjermbilder:** nei

Gating-sett: scenarioene som ikke er tagget `@draft`, `@deprecated` eller `@demo` (`@openquestion` alene er med).

Stiene er forkortet:

- `P-poeng` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/poeng`
- `P-sak` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling`
- `P-mig` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `A-opps` = `fs-admin/src/domains/soknadsbehandling/features/OppsummeringCard`

## Oppsummering

- Scenarioer: 11 funnet, 0 ikke funnet, 2 usikker, av 13
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0
- Tilgang og datakonsistens: 1 stemmer, 0 avviker, 0 ikke funnet, 0 usikker, av 2 (1 ikke beskrevet)
- Regler i koden uten scenario: 8
- Åpne spørsmål: 0 regler og 0 scenarioer i gating-settet, 0 utenfor gating (`@draft`)

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-031` | `@OPT-REG-KVO-001` Kvoterregelverk | 1 | `@implemented` | – | Regel: Poengsummen regnes ut med poengformelen til kvotetypen |
| `@OPT-BEH-BEH-031` | `@OPT-REG-RAN-002` Poengberegning | 1 | `@implemented` | – | Regel: Poengsummen regnes ut med poengformelen til kvotetypen |

Avhengigheter: 2 på nivå 1, 0 av dem ikke `@implemented`.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-031` | Poengsum for grunnlaget kvoten er koblet til | funnet | `P-poeng/PoengsumService.java:123-125` — gyldige (kvote, grunnlag) fra `kvotetype_grunnlag`; `:146-180` én `sak_poengsum`-rad per resultat |
| `@OPT-BEH-BEH-031` | Grunnlag kvoten ikke er koblet til, gir ingen poengsum i kvoten | funnet | `P-poeng/PoengberegningService.java:141-144` — hopper over kombinasjoner utenfor `gyldigeKvoteGrunnlag`; `P-poeng/PoengsumService.java:343-348` sletter rader som ikke beregnes |
| `@OPT-BEH-BEH-031` | Kvote søkeren ikke er plassert i, gir ingen poengsum | funnet | `P-poeng/PoengsumService.java:67-74` — bare kvoter med `SKAL_KVOTEPLASSERES` og `ER_AKTIV` |
| `@OPT-BEH-BEH-031` | Poengsummen følger poengformelen til kvotetypen | funnet | `P-poeng/PoengberegningService.java:362-388` — formelen fra `KVOTETYPE.POENGFORMEL_KODE_DEFAULT`; `P-poeng/PoengberegningEvaluator.java:119-122` summerer |
| `@OPT-BEH-BEH-031` | Grunnlag søkeren ikke er kvalifisert på, gir ingen poengsum | funnet | `P-poeng/PoengsumService.java:164-167, 205-215` — grunnlag uten kvalifisering gir ingen rad |
| `@OPT-BEH-BEH-031` | Poengsummen regnes ut på nytt når <endring> | funnet | `P-sak/PropageringService.java:52-112, 170-174` — `oppdaterPoengsumIsolert` fra alle inngangene; kalt ved grunnlag (`LeggTilGrunnlagService.java:48`), poeng (`SettPoengService.java:46`), kravelement (`KvalifiserKravelementV4Service.java:63`) og kvoteplassering (`EndreKvoteplasseringService.java:51`), også fra `AutomatiskSaksbehandlingService.java:117, 135` |
| `@OPT-BEH-BEH-031` | Uendret poengsum gir ikke nytt innslag i endringsloggen | usikker | `P-poeng/PoengsumService.java:332-372` — `skrivDiff` skriver bare rader som er endret (`compareTo != 0`), og ingen setning når ingenting er endret. Endringsloggen på `sak_poengsum` (`P-mig/V291__saksbehandling_skjema.sql:1498`) er stoppet: `P-mig/V480__stopp_endringslogg.sql:13-28` fjernet audit-triggerne i `saksbehandling`, så endringsloggen får ingen innslag i det hele tatt. Rettet etter verifiseringen av OPT-BEH-BEH-020 samme dag |
| `@OPT-BEH-BEH-031` | Poengsummen i de andre kvotene regnes ut når én kvote feiler | funnet | `P-poeng/PoengberegningService.java:146-188` — try/catch per (kvote × grunnlag), løkka går videre |
| `@OPT-BEH-BEH-031` | Poengtypen viser hvorfor poengsummen ikke kan regnes ut | usikker | Årsaken lagres per kvote i `sak_poengsum_merknad` (`P-poeng/PoengsumService.java:186-187, 217-253`, `P-mig/V497__sak_poengsum_merknad.sql`), og vises i oppsummeringen under poengtabellen som «<vitnemålsnr>: <årsak> (<grunnlag>)» (`A-opps/components/PoengsumMerknader/PoengsumMerknader.tsx:16-31`, `A-opps/OppsummeringsCardNy/OppsummeringsCardNy.tsx:201-211, 320`). På poengtypen skrives «Poengberegning feilet: Mangler poeng for X/Y» bare for `ManglerPoeng` (`P-poeng/PoengService.java:141-156`), og fs-admin viser det ikke: `PoengberegningCard.tsx:15-40` spør ikke etter `merknadAutomatisk`. En poengtype uten poeng gir bare feil når minimum > 0, ellers regnes den som 0 (`P-poeng/PoengberegningEvaluator.java:193-200`). Årsaken vises altså per kvote, ikke på poengtypen. Avgjort av brukeren: vet ikke |
| `@OPT-BEH-BEH-031` | Poengsummene fjernes når søkeren ikke er plassert i noen kvote | funnet | `P-poeng/PoengsumService.java:76-79` — `slettAlle`, også merknadene |
| `@OPT-BEH-BEH-031` | Poengsummene fjernes når saken ikke har noe grunnlag | funnet | `P-poeng/PoengsumService.java:100-103` — `slettAlle` |
| `@OPT-BEH-BEH-031` | Den høyeste poengsummen i kvoten vises | funnet | `P-sak/KvotesumV2Service.java:173-210, 248-252` — maks per kvotetype på tvers av grunnlag; `A-opps/OppsummeringsCardNy/OppsummeringsCardNy.tsx:56-63, 316` viser den i `PoengTable` |
| `@OPT-BEH-BEH-031` | Søknadsalternativ søkeren ikke er kvalifisert til, viser ingen poengsum | funnet | `P-sak/KvotesumV2Service.java:149, 155-158` — tom liste når ingen kompetanseregelverk er kvalifisert |

## Tilgang og datakonsistens

Sjekket på kodenivå (*Tilgang og datakonsistens* i `fs-verify`): at rollene og tilgangene er implementert slik kravet sier. Ingenting er kjørt, og rollene er ikke testet. Radene er grunnlaget for testbrukerne i testplanen. Radene er ikke scenarioer, og står ikke i `## Scenarioer`.

| Feature-ID | Sjekk | Rolle og handling | Kravet sier | Koden gjør | Resultat | Bevis |
| --- | --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-031` | organisasjon | saksbehandler leser og endrer årsaken til at poengsummen ikke kan regnes ut | ikke beskrevet | RLS på `sak_poengsum_merknad` sjekker bare handlingen (`har_tilgang`), ikke organisasjonen. `sak_poengsum` binder skrivingen til sakens organisasjon (`har_orgtilgang`, `P-mig/V493__tilbyder_ser_saksbehandlingen.sql:134-141`) | ikke beskrevet | `P-mig/V497__sak_poengsum_merknad.sql:61-79` — select/insert/update/delete med `auth.har_tilgang(...)` uten organisasjonskode |
| `@OPT-BEH-BEH-031` | konsistens | automatikken sletter og endrer poengsum og merknad | «Poengsummene fjernes når …» | FK med `ON DELETE CASCADE` til `sak_kvote` og `sak_rangeringsgrunnlag`; poengsum og merknad skrives i samme transaksjon, og en kombinasjon havner enten i resultatene eller i feilene | stemmer | `P-mig/V497__sak_poengsum_merknad.sql:21-37`, `P-poeng/PoengsumService.java:184-187`, `P-poeng/PoengberegningService.java:146-188` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker (*Regler uten scenario* i `fs-verify`). Input til testplanen og den agentiske testen (fase 2). Listen er ikke fullstendig: den har det som ble sett under letingen.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-031` | Årsaken er «Formelen for kvoten X kan ikke tolkes» ved feil i formelen, «Poengsummen for kvoten X kan ikke regnes ut: <årsak>» når årsaken er kjent, ellers «Poengsummen for kvoten X kan ikke regnes ut» | annet | `P-poeng/PoengberegningService.java:195-209` | testes i fase 2 |
| `@OPT-BEH-BEH-031` | En poengtype uten poeng gir bare feil når minimum > 0; ellers regnes den som 0, og poengsummen regnes ut uten årsak. En poengklasse uten poengtype i grunnlaget droppes fra formelen | grense | `P-poeng/PoengberegningEvaluator.java:181-200` | uklart om ønsket |
| `@OPT-BEH-BEH-031` | Vitnemålsnummeret står foran årsaken bare når saken har nøyaktig ett vitnemål | annet | `P-poeng/PoengsumService.java:226, 255-263` | testes i fase 2 |
| `@OPT-BEH-BEH-031` | Årsaken på poengraden («Mangler poeng») overskriver ikke en merknad som alt står der, skrives ikke når «la stå» er valgt, og skrives ikke når poengraden mangler | annet | `P-poeng/PoengberegningService.java:235-244`, `P-poeng/PoengService.java:141-156` | testes i fase 2 |
| `@OPT-BEH-BEH-031` | Kvotetype uten poengformel gir ingen poengsum og ingen årsak | standardverdi | `P-poeng/PoengberegningService.java:378` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-031` | Plasserbar kvote uten kobling til grunnlag gir ingen poengsum, bare en logglinje | annet | `P-poeng/PoengsumService.java:461-483` | uklart om ønsket |
| `@OPT-BEH-BEH-031` | Poengsummen og årsakene som vises, avgrenses til tilbudets rangeringsregelverk, grunnlagene i det og kvotene på utdanningstilbudet | annet | `P-sak/KvotesumV2Service.java:176-203`, `P-sak/PoengsumMerknadService.java:100-127` | testes i fase 2 |
| `@OPT-BEH-BEH-031` | Årsakene vises bare for søknadsalternativ søkeren er kvalifisert til, én per (kvotetype, grunnlag) | annet | `P-sak/PoengsumMerknadService.java:101-104, 113-140` | testes i fase 2 |

## Åpne spørsmål

Tellet fra `@openquestion` i kravfilene. `@openquestion` stopper ikke leveransen og testen: delen testes som den står, og `@draft @openquestion` er utenfor gating-settet. Spørsmålene står i `## Oppfølging`.

Ingen åpne spørsmål.

## Åpne MR-er og brancher

Koden i disse er ikke merget, og regnes ikke som levert. Scenarioene som bare finnes her, står som `ikke funnet` i `## Scenarioer`, med `finnes i MR !<iid>` i beviset.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-plattform` | [!6509 Automatisk saksbehandling setter saken til Behandlet, og DUA-mangel](https://gitlab.sikt.no/fs/fs-plattform/-/merge_requests/6509) (`mahj/autopuff/behandlet`) | åpen | `@OPT-BEH-BEH-031` | 0/1 | Endrer `PoengberegningEvaluator`, `PoengberegningService` og `PoengService`: en poengrad der den automatiske beregningen feilet, gir `ManglerPoeng` med feilteksten, og poengverdien nulles. Gjelder «Poengtypen viser hvorfor …» |
| `fs-admin` | [!3300 feat(regelverk): kvotetype kan lagres uten poengformel (TAKE-473)](https://gitlab.sikt.no/studieadm/fs-admin/-/merge_requests/3300) (`ross/take-473-opprett-kvote-ute-poengsum`) | åpen | – | 0/0 | usikker kobling: gjør regelen «Kvotetype uten poengformel gir ingen poengsum og ingen årsak» vanligere |

## Kontroll

| Feature-ID | Type | Scenario, rad eller regel | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-031` | tilgang | saksbehandler leser og endrer årsaken (organisasjon) | ikke beskrevet (RLS beskrevet som organisasjonsgrense) | ikke beskrevet, uten organisasjonsgrense | `P-mig/V497__sak_poengsum_merknad.sql:61-79` — `har_tilgang` uten organisasjon, ulikt `sak_poengsum` (`V493:134-141`) |
| `@OPT-BEH-BEH-031` | regel | En poengtype uten poeng … | «droppes fra formelen» | «regnes som 0» | `P-poeng/PoengberegningEvaluator.java:193-200` |
| `@OPT-BEH-BEH-031` | regel | Kvotetype uten poengformel, kvote uten grunnlag, avgrensning av visningen, årsaker bare for kvalifiserte | – | lagt til | 4 regler kontrollen fant |

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

Ingen. (Forslaget om `@implemented` på Regel: Poengsummen regnes ut på nytt når det den bygger på, endres, er trukket: «Uendret poengsum gir ikke nytt innslag i endringsloggen» er usikker.)

**Kan slettes**

Ingen.

**Blir stående**

- `@OPT-BEH-BEH-031` — Beregne poengsum per kvote (`@in-progress`, 11/13 funnet) — «Poengtypen viser hvorfor poengsummen ikke kan regnes ut» er usikker: årsaken vises per kvote i oppsummeringen, ikke på poengtypen. «Uendret poengsum gir ikke nytt innslag i endringsloggen» er usikker: endringsloggen er stoppet (V480)

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-031` | Beregne poengsum per kvote | `@in-progress` | 11/13 | 0 ikke funnet, 2 usikker. Brukeren sa nei til `@implemented` på Regel: Poengsummen regnes ut på nytt når det den bygger på, endres |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Endringsloggen er stoppet:** `P-mig/V480__stopp_endringslogg.sql:13-28` fjernet audit-triggerne i `saksbehandling`. «Uendret poengsum gir ikke nytt innslag i endringsloggen» kan ikke verifiseres før det finnes en erstatning (sporingsloggen). Resultatet ble rettet fra `funnet` til `usikker` etter at rapporten først ble skrevet.
- **Tilgang uten organisasjonsgrense:** `sak_poengsum_merknad` sjekker bare handlingen, ikke organisasjonen, i motsetning til `sak_poengsum` (`P-mig/V497__sak_poengsum_merknad.sql:61-79` mot `P-mig/V493__tilbyder_ser_saksbehandlingen.sql:134-141`). En saksbehandler med `MODIFISERE_SØKNADSBEHANDLING` i én organisasjon kan potensielt skrive årsaker i en sak hos en annen. Bør rettes i fs-plattform med en ny migrering.
- **Feil i merknadsskrivingen kan velte transaksjonen:** `registrerPoengberegningsfeilPaRad` fanger `RuntimeException` i samme transaksjon uten savepoint (`P-poeng/PoengberegningService.java:267-277`). En SQL-feil der setter Postgres-transaksjonen i aborted-tilstand, så kommentaren «skal ikke velte beregningen» holder sannsynligvis ikke.
- **Bruddet i flyten:** `@FLY-OPT-AUT-001` (fasen «Søkeren får poengsum per kvote …») bygger på kravet. Scenarioet «Saken blir ikke ferdig behandlet når poengene ikke kan avgjøres» der får nå en synlig årsak i oppsummeringen.
- **Ikke sjekket:** min-kompetanse finnes ikke lokalt (ikke relevant for kravet, ingen scenarioer gjelder søkeren).
