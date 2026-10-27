# Verifisering: automatisk_poengberegning.feature

- **Dato:** 2026-10-27 12:35
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_poengberegning.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (main, 651c89a7fa, oppdatert), `fs-admin` (main, 293c918cf, oppdatert)
- **Omfang:** alle krav uansett status (fra prompten)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Team:** 4 finnere (`fs-verify-krav`), 4 kontrollører (`fs-verify-kontroll`), 1–1 feature-filer per finner
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `POENG` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/poeng`
- `VGS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs`
- `CARD` = `fs-admin/src/domains/soknadsbehandling/features/PoengberegningCard`

## Oppsummering

- Scenarioer: 11 funnet, 3 ikke funnet, 0 usikker, av 14
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-018` | `@OPT-REG-RAN-002` Poengberegning | 1 | `@implemented` | – | Regel: Karakterpoeng, realfagspoeng og språkpoeng beregnes fra søkerens eneste vitnemål |

Avhengigheter: 1 på nivå 1, 0 av dem ikke `@implemented`.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-018` | Poengtype som beregnes fra vitnemålet | funnet | `POENG/AutomatiskPoengberegningService.java:110-146`, `POENG/PoengService.java:171-203` — koblingen til KAR/REA/SPR på poengtypen styrer at kontrollmotoren regner poenget, som lagres med vitnemålet det kommer fra |
| `@OPT-BEH-BEH-018` | Poengtype uten kobling til vitnemålet beregnes ikke | funnet | `POENG/AutomatiskPoengberegningService.java:149-153` — raden hoppes over uten kobling og uten algoritme |
| `@OPT-BEH-BEH-018` | Beregnet poeng rundes til antall desimaler poengtypen har | funnet | `POENG/PoengService.java:179-186` — `PoengAvrunder.avrund` mot poengtypen før lagring |
| `@OPT-BEH-BEH-018` | Skolepoeng beregnet fra vitnemålspoengene | funnet | `POENG/PoengformelParser.java:95-138`, `POENG/PoengberegningEvaluator.java:126`, `PoengsumService.java:178` — skolepoeng er en poengformel i regelverket; `fs-plattform/opptak/opptak-subgraph/src/test/java/no/sikt/fs/opptak/saksbehandling/SkolepoengEndeTilEndeIT.java:285,387-455` viser vitnemål → KAR/REA/SPR → `KAR + min(4, REA + SPR)` |
| `@OPT-BEH-BEH-018` | Ingen automatiske vitnemålspoeng når <grunn> | funnet | `VGS/VgsDokumentVitnemaalService.java:40-57` — tomt ved flere, ingen eller annullert dokument, og når det ene er et kompetansebevis; `POENG/AutomatiskPoengberegningService.java:121-133` og `POENG/PoengService.java:210-215` nullstiller og skriver «Fant ikke entydig vitnemål» |
| `@OPT-BEH-BEH-018` | Kompetansebevis ved siden av ett vitnemål hindrer ikke beregningen | ikke funnet | `VGS/VgsDokumentVitnemaalService.java:46` — `size() != 1` teller også kompetansebeviset, så vitnemål + kompetansebevis gir ingen poeng (det motsatte av scenarioet) — søkt etter «KB», «kompetansebevis», «VGDOKTYPEKODE» i fs-plattform |
| `@OPT-BEH-BEH-018` | Automatisk beregnede vitnemålspoeng fjernes når søkeren har to vitnemål | funnet | `POENG/AutomatiskPoengberegningService.java:121-125`, `POENG/PoengService.java:210-215` — poenget nullstilles og får merknad; rader med «la stå» røres ikke |
| `@OPT-BEH-BEH-018` | Poeng som saksbehandleren endrer, blir stående | funnet | `POENG/SettPoengService.java:122,161` — manuell setting gir «la stå» som standard; `POENG/PoengService.java:52,66,200` hopper over slike rader |
| `@OPT-BEH-BEH-018` | Saksbehandleren overstyrer automatisk beregnet <poeng> | funnet | `POENG/SettPoengService.java:122,161`, `POENG/PoengService.java:200` — karakter-, realfags- og språkpoeng kan overstyres og låses. Skolepoeng er poengsummen fra formelen, og regnes på nytt ved hver endring (`PoengsumService.java:235-265`) — avgjort av brukeren: funnet; skolepoeng er ikke et poeng som skal overstyres, raden skal ut av kravet |
| `@OPT-BEH-BEH-018` | Låst poeng beregnes ikke på nytt | funnet | `POENG/AutomatiskPoengberegningService.java:72-84`, `POENG/PoengService.java:200` — bare rader uten «la stå» velges og oppdateres |
| `@OPT-BEH-BEH-018` | Poeng som ikke er låst, beregnes på nytt | funnet | `POENG/AutomatiskPoengberegningService.java:72-84,94-146`, `POENG/PoengService.java:194` — poenget overskrives |
| `@OPT-BEH-BEH-018` | Saksbehandlerens merknad på poenget er uendret | funnet | `POENG/PoengService.java:193-198` — skriver bare den automatiske merknaden, aldri saksbehandlerens |
| `@OPT-BEH-BEH-018` | Se hvilket vitnemål et automatisk beregnet poeng bygger på | ikke funnet | API-et har `vitnemaalsnummer` og `merknadAutomatisk` (`fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/poeng.graphqls:82-83,99`), men `CARD/PoengberegningCard.tsx:16-45` og `CARD/PoengberegningCardRow.tsx` henter og viser dem ikke — søkt etter «vitnemaalsnummer», «merknadAutomatisk», «vgdoknr» i fs-admin |
| `@OPT-BEH-BEH-018` | Se hvorfor vitnemålspoengene ikke er beregnet | ikke funnet | merknaden skrives (`POENG/PoengService.java:210-214`) og er i API-et, men vises ikke i `CARD/` — samme søk |

## Kontroll

Kontrollen endret ingen resultater.

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

- `@OPT-BEH-BEH-018` — Automatisk beregning av vitnemålspoeng (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_poengberegning.feature`, `@draft` → `@in-progress`, 10/14 funnet) — `@implemented` på: Regel: Karakterpoeng, realfagspoeng og språkpoeng beregnes fra søkerens eneste vitnemål (linje 21), Regel: Skolepoeng settes sammen av karakterpoeng, realfagspoeng og språkpoeng (linje 49), Scenario: Ingen automatiske vitnemålspoeng når <grunn> (linje 67), Scenario: Automatisk beregnede vitnemålspoeng fjernes når søkeren har to vitnemål (linje 86), Scenario: Poeng som saksbehandleren endrer, blir stående (linje 96), Scenario: Låst poeng beregnes ikke på nytt (linje 114), Scenario: Poeng som ikke er låst, beregnes på nytt (linje 119), Scenario: Saksbehandlerens merknad på poenget er uendret (linje 125)

**Kan slettes**

Ingen.

**Blir stående**

Ingen.

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-018` | Automatisk beregning av vitnemålspoeng | `@draft` | 11/14 | 3 ikke funnet, 0 usikker. Brukeren beholdt `@draft` til kravet er validert |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **fs-admin viser ikke det automatikken har gjort:** `CARD/PoengberegningCard.tsx:16-45` henter bare `poeng`, `merknad`, `laStaa` og `poengtype`, ikke `vitnemaalsnummer`, `merknadAutomatisk` eller `statusAutomatiskUtregnet`, som API-et har.
- **Vitnemål og kompetansebevis:** `VGS/VgsDokumentVitnemaalService.java:46` teller alle ikke-annullerte dokumenter. Samme avvik står i `@OPT-BEH-BEH-019` og `@OPT-BEH-BEH-020`, så det er én endring i koden.
- **Skolepoeng i scenariomalen (foreslått `fs-krav`):** «Saksbehandleren overstyrer automatisk beregnet <poeng>» (`automatisk_poengberegning.feature:101`) har en rad for skolepoeng. Brukeren avklarte at skolepoeng er poengsummen, som regnes på nytt ved hver endring, og ikke et poeng saksbehandleren overstyrer. Raden fjernes med `fs-krav`.
- **Delvis levert, men ikke validert:** brukeren beholdt `@draft`. Kravet valideres med `fs-krav`, og verifiseres på nytt etterpå.
