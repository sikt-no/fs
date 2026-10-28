# Verifisering: automatisk_poengberegning.feature

- **Dato:** 2026-10-28 09:20
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_poengberegning.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (main, 6aef37f4a4, oppdatert), `fs-admin` (main, 56703096c, oppdatert)
- **Åpne MR-er:** 2 MR-er i fs-admin, 1 branch uten MR i fs-plattform (0 med kode for kravene)
- **Omfang:** alle krav uansett status (fra prompten)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Team:** 4 finnere (`fs-verify-krav`), 4 kontrollører (`fs-verify-kontroll`), 1–1 feature-filer per finner
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `POENG` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/poeng`
- `AUTOSAK` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak`
- `VGS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs`
- `SCHEMA` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling`
- `CARD` = `fs-admin/src/domains/soknadsbehandling/features/PoengberegningCard`

## Oppsummering

- Scenarioer: 10 funnet, 6 ikke funnet, 1 usikker, av 17
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0
- Tilgang og datakonsistens: ikke sjekket i denne kjøringen
- Regler i koden uten scenario: 2
- Åpne spørsmål: 0 regler og 1 scenarioer i gating-settet, 0 utenfor gating (`@draft`)

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-018` | `@OPT-BEH-BEH-015` Automatisk GSK-konklusjon | 1 | `@planned` | – | ikke levert, `@OPT-BEH-BEH-018` kan ikke leveres før dette |
| `@OPT-BEH-BEH-018` | `@OPT-BEH-BEH-019` Automatisk grunnlag | 1 | `@draft` | – | ikke levert, `@OPT-BEH-BEH-018` kan ikke leveres før dette (verifisert i egen rapport på branchen krav/automatisk-grunnlag) |
| `@OPT-BEH-BEH-018` | `@OPT-REG-RAN-002` Poengberegning | 1 | `@implemented` | – | Regel: Karakterpoeng, realfagspoeng og språkpoeng beregnes fra søkerens eneste vitnemål |

Avhengigheter: 3 på nivå 1, 2 av dem ikke `@implemented`.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-018` | Poengtype som beregnes fra vitnemålet | funnet | `POENG/AutomatiskPoengberegningService.java:110-138`, `POENG/PoengService.java:171-202` — kravkoden på poengtypen styrer kontrollmotoren (KAR/REA/SPR i `AUTOSAK/kontrollmotor/KontrollMotor.java:168-170`), og poenget lagres med vitnemålet det kommer fra |
| `@OPT-BEH-BEH-018` | Poengtype uten kobling til vitnemålet beregnes ikke | funnet | `POENG/AutomatiskPoengberegningService.java:149-153` — raden hoppes over uten kravkode og uten algoritme |
| `@OPT-BEH-BEH-018` | Beregnet poeng rundes til antall desimaler poengtypen har | funnet | `POENG/PoengService.java:179-186`, `POENG/PoengAvrunder.java:22-31` — poengtrinn og `setScale(antallDesimaler, HALF_UP)` før lagring |
| `@OPT-BEH-BEH-018` | Skolepoeng beregnet fra vitnemålspoengene | funnet | `AUTOSAK/AutomatiskSaksbehandlingService.java:146-147` → `PropageringService.java:83,183-187` (PoengsumService), `POENG/PoengformelParser.java:94-96` (`min`) — taket på 4 står i poengformelen i regelverket; `SkolepoengEndeTilEndeIT.java:389-451` går fra vitnemål til `KAR + min(4, REA + SPR)` |
| `@OPT-BEH-BEH-018` | Ingen automatiske vitnemålspoeng når <grunn> | ikke funnet | Fire av seks rader stemmer: ingen vitnemål, annullert, bare kompetansebevis og flere vitnemål gir tomt i `VGS/VgsDokumentVitnemaalService.java:42-54`, og poenget nullstilles med «Fant ikke entydig vitnemål» (`POENG/AutomatiskPoengberegningService.java:121-133`, `POENG/PoengService.java:210-215`). «Vitnemålet gir ikke generell studiekompetanse»: `byggVitnemaalForPerson` sjekker ikke GSK, så poeng beregnes når søknaden har poengrader (bare `AUTOSAK/SetteGrunnlagService.java:127-129` sperrer, for grunnlaget). «Søknaden har ikke noe grunnlag»: ingen poengrader (`AutomatiskPoengberegningService.java:72-84`), men ingen melding om hvorfor. Kontrollen endret fra usikker |
| `@OPT-BEH-BEH-018` | Kompetansebevis ved siden av ett vitnemål hindrer ikke beregningen | ikke funnet | Koden gjør det motsatte: `VGS/VgsDokumentVitnemaalService.java:43-50` teller alle ikke-annullerte dokumenter uansett type, og `AUTOSAK/SetteGrunnlagService.java:109-113` kaster `FlereVitnemaalException` — søkt etter «kompetansebevis», «KB», «VGDOKTYPEKODE» i fs-plattform og fs-admin (også !3235 og !3193) |
| `@OPT-BEH-BEH-018` | Automatisk beregnede vitnemålspoeng fjernes når søkeren har to vitnemål | usikker | `POENG/PoengService.java:210-215` — den frittstående `beregnPoengAutomatisk` (`SCHEMA/automatisk-saksbehandling.graphqls:9-15`) nullstiller poenget, men fs-admin kaller den ikke. `behandleSakAutomatisk`, som fs-admin bruker, kaster i `AUTOSAK/SetteGrunnlagService.java:110-113` før poengsteget og ruller tilbake, så de gamle poengene står |
| `@OPT-BEH-BEH-018` | Vitnemålspoeng fra vitnemålet saksbehandleren har valgt | ikke funnet | `POENG/AutomatiskPoengberegningService.java:185-194` bruker bare `byggVitnemaalForPerson`; `byggVitnemaal(vgdoknr)` brukes bare til visning (`VGS/VgsDokumentPoengService.java:36`) og for GSK (`AUTOSAK/gsk/SettGskKonklusjonService.java:104-129`) — søkt etter «valgtVitnemaal», «valgt_vitnem», «velgVitnem», «valgtVgdoknr» i fs-plattform og fs-admin (også !3193, som bare viser vitnemålene) |
| `@OPT-BEH-BEH-018` | Poeng som saksbehandleren endrer, blir stående | funnet | `CARD/PoengberegningCardRow/PoengberegningCardRow.tsx:138-140` sender `settPoengV4` uten `laStaa`, `POENG/SettPoengService.java:122,161` setter `la_staa = true`, `POENG/AutomatiskPoengberegningService.java:82` og `POENG/PoengService.java:200` hopper over raden |
| `@OPT-BEH-BEH-018` | Saksbehandleren overstyrer automatisk beregnet <poeng> | funnet | `POENG/SettPoengService.java:122,161-162` — verdien, `la_staa = true` og `status_automatisk_utregnet = false` for alle poengtyper; `POENG/AutomatiskPoengberegningService.java:82` |
| `@OPT-BEH-BEH-018` | Låst poeng beregnes ikke på nytt | funnet | `POENG/AutomatiskPoengberegningService.java:82`, `POENG/PoengService.java:200` — bare rader med `la_staa = false` |
| `@OPT-BEH-BEH-018` | Låse opp et poeng | funnet | `CARD/PoengberegningCardRow/PoengberegningCardRow.tsx:161-167` sender bare `laStaa`, `POENG/SettPoengService.java:110-118,186-207` oppdaterer bare låsen, og neste kjøring tar raden med (`AutomatiskPoengberegningService.java:82`) |
| `@OPT-BEH-BEH-018` | Poeng som ikke er låst, beregnes på nytt | funnet | `POENG/PoengService.java:193-202` — `POENG`, `MERKNAD_AUTOMATISK` og `VGDOKNR` overskrives når raden ikke er låst |
| `@OPT-BEH-BEH-018` | Saksbehandlerens merknad på poenget er uendret | funnet | `POENG/PoengService.java:45-53,193-202,210-215` — bare `MERKNAD_AUTOMATISK` skrives, aldri `MERKNAD` |
| `@OPT-BEH-BEH-018` | Se at poenget er beregnet automatisk, og hvilket vitnemål det bygger på | ikke funnet | API-et har `vitnemaalsnummer`, `statusAutomatiskUtregnet` og `merknadAutomatisk` (`SCHEMA/poeng.graphqls:82-83,97-104`), men `CARD/PoengberegningCard.tsx:15-43` henter dem ikke — søkt etter «merknadAutomatisk», «vitnemaalsnummer», «statusAutomatiskUtregnet» i fs-admin `src` (også !3235 og !3193) |
| `@OPT-BEH-BEH-018` | Se hvorfor vitnemålspoengene ikke er beregnet | ikke funnet | Merknaden skrives (`POENG/PoengService.java:210-215`), men vises ikke i `CARD/PoengberegningCard.tsx:15-43` — samme søk, og «entydig» i fs-admin `src` |
| `@OPT-BEH-BEH-018` | Finne søknader som er behandlet automatisk | ikke funnet | Ingen felt i `SakFilterV2Input` (`SCHEMA/sak.graphqls:271+`) eller i `SakFilterConditions.java` gjelder automatisk behandling — søkt etter «behandletAutomatisk», «automatiskBehandlet», «helautomatisk», «halvautomatisk», «autosak» i fs-admin `src`; bare `endringsloggV2` per sak (`SCHEMA/sak.graphqls:151-152`) |

## Tilgang og datakonsistens

Sjekket på kodenivå (*Tilgang og datakonsistens* i `fs-verify`): at rollene og tilgangene er implementert slik kravet sier. Ingenting er kjørt, og rollene er ikke testet. Radene er grunnlaget for testbrukerne i testplanen. Radene er ikke scenarioer, og står ikke i `## Scenarioer`.

Ikke sjekket i denne kjøringen (se `## Oppfølging`).

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker (*Regler uten scenario* i `fs-verify`). Input til testplanen og den agentiske testen (fase 2). Listen er ikke fullstendig: den har det som ble sett under letingen.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-018` | Poengsummen (skolepoeng) regnes ut bare i `behandleSakAutomatisk`, ikke i den frittstående `beregnPoengAutomatisk` | annet | `AUTOSAK/AutomatiskSaksbehandlingService.java:146-147` | uklart om ønsket |
| `@OPT-BEH-BEH-018` | Med flere vitnemål ruller `behandleSakAutomatisk` tilbake hele behandlingen, og feilen vises bare i en snackbar i fs-admin | tilstandsovergang | `AUTOSAK/SetteGrunnlagService.java:110-113`, `fs-admin/src/domains/soknadsbehandling/features/SakActionButtons/components/BehandleSakAutomatiskButton/BehandleSakAutomatiskButton.tsx:37-40` | legg til scenario med `fs-krav` |

## Åpne spørsmål

Tellet fra `@openquestion` i kravfilene. `@openquestion` stopper ikke leveransen og testen: delen testes som den står, og `@draft @openquestion` er utenfor gating-settet. Spørsmålene står i `## Oppfølging`.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-018` | Automatisk beregning av vitnemålspoeng | 0 av 5 | 1 av 17 | 0 |

## Åpne MR-er og brancher

Koden i disse er ikke merget, og regnes ikke som levert. Scenarioene som bare finnes her, står som `ikke funnet` i `## Scenarioer`, med `finnes i MR !<iid>` i beviset.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-admin` | !3235 feat(soknadsbehandling): vis poengtypenavn i poengsteget (`solov/poengtypenavn-poengsteg`) | åpen | `@OPT-BEH-BEH-018` | 0/17 | legger bare til navnet på poengtypen |
| `fs-admin` | !3193 feat(soknadsbehandling): vis søkerens elektroniske vitnemål (`opptak/vise-elektroniske-vitnemal`) | åpen | `@OPT-BEH-BEH-018` | 0/17 | usikker kobling; viser poeng per vitnemål, uten valg av vitnemål |
| `fs-plattform` | `mahj/STEK-511` | branch uten MR | – | 0/17 | usikker kobling; bare lokal, gjelder søknadsmangler |

## Kontroll

| Feature-ID | Type | Scenario, rad eller regel | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-018` | scenario | Ingen automatiske vitnemålspoeng når <grunn> | usikker | ikke funnet | `VGS/VgsDokumentVitnemaalService.java:42-54` — `byggVitnemaalForPerson` sjekker ikke GSK, så raden «vitnemålet gir ikke generell studiekompetanse» gir poeng; raden «ikke noe grunnlag» gir ingen melding |

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

Ingen. Brukeren har valgt å beholde `@draft` til kravet er validert.

**Kan slettes**

Ingen.

**Blir stående**

- `@OPT-BEH-BEH-018` — Automatisk beregning av vitnemålspoeng (`@draft`, 10/17 funnet) — 6 ikke funnet, 1 usikker; brukeren har valgt å beholde `@draft` til kravet er validert

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-018` | Automatisk beregning av vitnemålspoeng | `@draft` | 10/17 | 6 ikke funnet, 1 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Vitnemål og kompetansebevis:** `VGS/VgsDokumentVitnemaalService.java:43-50` teller alle ikke-annullerte dokumenter. Samme avvik står i `@OPT-BEH-BEH-019` og `@OPT-BEH-BEH-020`, så det er én endring i koden.
- **Valgt vitnemål:** poengberegningen bruker aldri vitnemålet saksbehandleren har valgt. Saksbehandleren kan bare velge vitnemål for GSK (`AUTOSAK/gsk/SettGskKonklusjonService.java:104-129`). Samme avvik i `@OPT-BEH-BEH-019` og `@OPT-BEH-BEH-020`.
- **fs-admin viser ikke det automatikken har gjort:** `CARD/PoengberegningCard.tsx:15-43` henter ikke `vitnemaalsnummer`, `merknadAutomatisk` eller `statusAutomatiskUtregnet`, som API-et har.
- **Åpent spørsmål:** `@OPT-BEH-BEH-018` «Finne søknader som er behandlet automatisk» — Er det et filter i saksoversikten, en logg, eller begge?
- **Åpent spørsmål:** `@OPT-BEH-BEH-018` (egenskapen) — Skal automatikken kunne skrus av etter en dato, eller bare kjøre i en periode?
- **Ikke sjekket:** tilgang og datakonsistens. Finnerne og kontrollørene fikk ikke denne sjekken i denne kjøringen.
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-018` bygger på `@OPT-BEH-BEH-015` (`@planned`) og `@OPT-BEH-BEH-019` (`@draft`)
- **Forrige rapport:** `verify-automatisk_poengberegning-2026-10-27-1235.md` er slettet etter ønske fra brukeren (én verify-fil per krav).
