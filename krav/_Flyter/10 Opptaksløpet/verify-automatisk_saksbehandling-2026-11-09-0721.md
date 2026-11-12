# Verifisering: Automatisk saksbehandling (`@FLY-OPT-AUT-001`) med avhengighetene

- **Dato:** 2026-11-09 07:21
- **Krav:** `krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling.feature` (1 feature-fil), lest på `origin/main` (55ae1e89). Den utsjekkede branchen `krav/poeng-hoyere-utdanning` er 168 commits bak main, så kravene og koden er lest i egne worktrees av `origin/main`
- **Kode:** `fs-plattform` (origin/main, c4ae39cbde, oppdatert), `fs-admin` (origin/main, cbd320dc2, oppdatert). De utsjekkede klonene står på `mahj/autopuff/kravelementer` (204 og 84 bak main) og er ikke brukt. `min-kompetanse` finnes ikke lokalt
- **Åpne MR-er:** 100 åpne MR-er i fs-plattform og 47 i fs-admin; 6 MR-er og 12 brancher uten MR med mulig kode for kravene (4 MR-er med kode for scenarioer som ikke er funnet på main)
- **Omfang:** flyter (fra prompten: «hele flyten»)
- **Avhengigheter:** 1 nivå, verifisert i koden
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Team:** 4 finnere (`fs-verify-krav`), 18 kontrollører (`fs-verify-kontroll`), 3–8 feature-filer per finner
- **Skjermbilder:** nei

Gating-sett: scenarioene som ikke er tagget `@draft`, `@deprecated` eller `@demo` (`@openquestion` alene er med). Avhengighetene er verifisert uansett status (alle scenarioer minus `@draft`, `@deprecated` og `@demo`).

Stiene er forkortet:

- `P` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/`
- `S` = `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/`
- `G` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/`
- `PM` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/`
- `A` = `fs-admin/src/domains/`
- Filnavn uten sti (`SettPoengService.java:104`, `V480__stopp_endringslogg.sql`, `sak.graphqls`) ligger under `P/`, `PM/`, `G/` eller `A/`, i samme undermappe som nærmeste sti foran i samme celle.

## Oppsummering

- Scenarioer: 8 funnet, 14 ikke funnet, 0 usikker, av 22
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0
- Tilgang og datakonsistens: 0 stemmer, 0 avviker, 0 ikke funnet, 0 usikker, av 0
- Regler i koden uten scenario: 0
- Åpne spørsmål: 2 regler og 1 scenarioer i gating-settet, 0 utenfor gating (`@draft`)

## Fremdrift for flyter

Fremdriften kommer fra statusen på delen av kravene fasene bygger på (`@depends-on-`, og ankrene innenfor reglene i «…», ellers alle ankrene, ellers reglene i «…»). Den endrer ingen tagger.

Flyten har også `@depends-on-FLY-OPT-SAK-001` på `Egenskap:`, og den flyten er `@planned`. Lest strengt er da ingen fase levert. Tabellen viser fasene ut fra kravene hver fase bygger på, og overleveringene i de seks fasene som er levert ut fra dem, er verifisert i koden.

| Flyt | Fase | Bygger på | Fase levert |
| --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Søkerens resultater importeres fra KREG når saken er opprettet | `@OPT-BEH-BEH-030` (`@in-progress`, Regel: Resultatene hentes når saken er opprettet ikke levert (4/5 scenarioer `@implemented`), Regel: Alle vitnemål og kompetansebevis søkeren har i KREG, importeres levert) | nei |
| `@FLY-OPT-AUT-001` | Den automatiske behandlingen starter når søkerens resultater er importert | `@OPT-BEH-BEH-032` (`@in-progress`, Regel: Behandlingen kjører for hver ny sak saksbehandlertildelingen oppretter ikke levert, Regel: Behandlingen kjører når importen har hentet vitnemålene til en søker uten vitnemål ikke levert) | nei |
| `@FLY-OPT-AUT-001` | Søknaden får GSK-konklusjonen når vitnemålet importeres fra KREG | `@OPT-BEH-BEH-015` (`@in-progress`, 2 av 5 ankrede regler levert), `@OPT-BEH-BEH-027` (`@in-progress`, hele kravet) | nei |
| `@FLY-OPT-AUT-001` | Den automatiske behandlingen setter GSK-konklusjonen der den mangler | `@OPT-BEH-BEH-015` (`@in-progress`, Regel: GSK-konklusjonen settes også når den automatiske behandlingen kjører levert) | ja |
| `@FLY-OPT-AUT-001` | Vitnemålet som gir GSK, avgjør om saken behandles helautomatisk | `@OPT-BEH-BEH-015` (`@in-progress`, Regel: Vitnemålet gir GSK når det har GSK OK fra KREG levert), `@OPT-BEH-BEH-025` (`@in-progress`, Regel: Bare saker der søkeren har ett vitnemål, og vitnemålet gir GSK, behandles helautomatisk levert) | ja |
| `@FLY-OPT-AUT-001` | To identiske vitnemål reknes som ett vitnemål | – (`@wont @openquestion`) | mangler krav |
| `@FLY-OPT-AUT-001` | Saken får grunnlag fra vitnemålet | `@OPT-BEH-BEH-019` (`@in-progress`, 2 av 3 ankrede regler levert; Regel: Grunnlaget velges ut fra egenskapene regelverket har gitt det har 6/7) | nei |
| `@FLY-OPT-AUT-001` | Poengene beregnes fra grunnlaget og rangeringsregelverket | `@OPT-BEH-BEH-018` (`@in-progress`, 1 av 3 ankrede regler levert), `@OPT-REG-RAN-001` (`@implemented`), `@OPT-REG-RAN-002` (`@implemented`) | nei |
| `@FLY-OPT-AUT-001` | Søknaden får tilleggspoeng når grunnlaget er satt | `@OPT-BEH-BEH-028` (`@in-progress`, 1 av 4 ankrede regler levert) | nei |
| `@FLY-OPT-AUT-001` | Søknaden dobbeltrangeres automatisk etter 23/5-regelen | – (`@wont @openquestion`, ingen scenarioer) | mangler krav |
| `@FLY-OPT-AUT-001` | Kravelementene vurderes mot vitnemålet når poengene er beregnet | `@OPT-BEH-BEH-020` (`@in-progress`, alle 3 ankrede regler levert) | ja |
| `@FLY-OPT-AUT-001` | Kvotespørsmålene med algoritme besvares automatisk | `@OPT-BEH-BEH-012` (`@implemented`, Regel: Kvotespørsmål med algoritme besvares automatisk og kan ikke endres av saksbehandleren levert), `@OPT-REG-KVO-002` (`@implemented`) | ja |
| `@FLY-OPT-AUT-001` | Kvalifiseringen oppdateres når kravelementene er vurdert | `@OPT-BEH-BEH-020` (`@in-progress`, Regel: Om søkeren er kvalifisert, avgjøres per grunnlag levert) | ja |
| `@FLY-OPT-AUT-001` | Søkeren fordeles på kvoter når kvalifiseringen og kvotesvarene er satt | `@OPT-BEH-BEH-012` (`@implemented`, begge ankrede regler levert) | ja |
| `@FLY-OPT-AUT-001` | Søkeren får poengsum per kvote når søkeren er fordelt på kvoter | `@OPT-BEH-BEH-031` (`@in-progress`, 5 av 6 ankrede regler levert; Regel: Poengsummen regnes ut på nytt når det den bygger på, endres har 1/2), `@OPT-REG-KVO-001` (`@implemented`, Regel: En kvotetype kan ha en default poengformel levert), `@OPT-REG-RAN-002` (`@implemented`) | nei |
| `@FLY-OPT-AUT-001` | Saken får mangeltekster når kravelementene er vurdert | `@OPT-BEH-BEH-036` (`@in-progress`, Regel: Saken får automatiske mangeltekster når søkeren ikke er kvalifisert, 8/11) | nei |
| `@FLY-OPT-AUT-001` | Mangelen for GSK som fullføres i vår sjekkes ut før saken blir ferdig behandlet | `@OPT-BEH-BEH-036` (`@in-progress`, 1 av 2 ankrede regler levert; Regel: Mangelen for generell studiekompetanse som fullføres i vår settes og sjekkes ut automatisk har 4/10) | nei |
| `@FLY-OPT-AUT-001` | Saken blir ferdig behandlet og er klar til å være med i plasstildelingen | `@OPT-BEH-BEH-025` (`@in-progress`, 0 av 2 ankrede regler levert), `@OPT-BEH-BEH-029` (`@in-progress`, 0 av 2 ankrede regler levert) | nei |
| `@FLY-OPT-AUT-001` | Søknadsalternativene beregnes på nytt når regelverket er rettet | `@OPT-BEH-BEH-026` (`@in-progress`, 2 av 3 ankrede regler levert; Regel: Bare saker som er ferdig behandlet, beregnes på nytt har 3/4) | nei |

`@FLY-OPT-AUT-001`: 6 av 19 faser levert (2 av fasene mangler krav), og flyten den bygger på (`@FLY-OPT-SAK-001`), er `@planned`.

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | `@OPT-REG-RAN-001` Rangeringsregelverk | 1 | `@implemented` | 5/5 |  |
| `@FLY-OPT-AUT-001` | `@OPT-REG-RAN-002` Poengberegning | 1 | `@implemented` | 10/10 |  |
| `@FLY-OPT-AUT-001` | `@OPT-REG-KVO-001` Kvotetype | 1 | `@implemented` | 9/20 |  |
| `@FLY-OPT-AUT-001` | `@OPT-REG-KVO-002` Kvotespørsmål | 1 | `@implemented` | 7/7 |  |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-012` Automatisk kvoteplassering | 1 | `@implemented` | 13/16 |  |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-015` Automatisk GSK-konklusjon | 1 | `@in-progress` | 41/53 | ikke levert, `@FLY-OPT-AUT-001` kan ikke leveres før dette |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-018` Automatisk beregning av vitnemålspoeng | 1 | `@in-progress` | 10/15 | ikke levert, `@FLY-OPT-AUT-001` kan ikke leveres før dette |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-019` Automatisk grunnlag | 1 | `@in-progress` | 21/29 | ikke levert, `@FLY-OPT-AUT-001` kan ikke leveres før dette |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-020` Automatisk vurdering av spesielle opptakskrav | 1 | `@in-progress` | 30/33 | ikke levert, `@FLY-OPT-AUT-001` kan ikke leveres før dette |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-025` Ferdigbehandle en sak | 1 | `@in-progress` | 10/17 | ikke levert, `@FLY-OPT-AUT-001` kan ikke leveres før dette |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-026` Beregne automatisk på nytt | 1 | `@in-progress` | 19/24 | ikke levert, `@FLY-OPT-AUT-001` kan ikke leveres før dette |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-027` Beregne GSK fra vitnemål | 1 | `@in-progress` | 27/27 | ikke levert, `@FLY-OPT-AUT-001` kan ikke leveres før dette |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-028` Automatiske tilleggspoeng | 1 | `@in-progress` | 17/26 | ikke levert, `@FLY-OPT-AUT-001` kan ikke leveres før dette |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-029` Behandlingsstatus | 1 | `@in-progress` | 7/10 | ikke levert, `@FLY-OPT-AUT-001` kan ikke leveres før dette |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-030` Importere resultater fra KREG | 1 | `@in-progress` | 11/18 | ikke levert, `@FLY-OPT-AUT-001` kan ikke leveres før dette |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-031` Beregne poengsum per kvote | 1 | `@in-progress` | 13/13 | ikke levert, `@FLY-OPT-AUT-001` kan ikke leveres før dette |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-032` Starte automatisk behandling | 1 | `@in-progress` | 2/9 | ikke levert, `@FLY-OPT-AUT-001` kan ikke leveres før dette |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-036` Automatiske mangler | 1 | `@in-progress` | 15/28 | ikke levert, `@FLY-OPT-AUT-001` kan ikke leveres før dette |
| `@FLY-OPT-AUT-001` | `@FLY-OPT-SAK-001` Saksbehandlertildeling | 1 | `@planned` | 7/7 | ikke levert, `@FLY-OPT-AUT-001` kan ikke leveres før dette |

Avhengigheter: 19 på nivå 1, 14 av dem ikke `@implemented`.

### Scenarioer i avhengighetene

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-REG-RAN-001` | Opprette rangeringsregelverk | funnet | `P/opptak/RangeringsregelverkMutations.java:36,44,49`; `regelverk.graphqls:33`; `A/regelverk/features/Rangeringsregelverk/components/Rangeringsregelverk/Rangeringsregelverk.tsx:215` |
| `@OPT-REG-RAN-001` | Koble grunnlag til poengtyper | funnet | `P/opptak/RangeringsregelverkMutations.java:61,90` — `rangeringsgrunnlag_poengtype`; `A/regelverk/features/Rangeringsregelverk/components/PoengtypeRangering/PoengtypeRangering.tsx:43-101` |
| `@OPT-REG-RAN-001` | Deaktivere rangeringsregelverk | funnet | `A/opptak/features/OpptakManagement/OpptakSøknadsalternativer/hooks/useRegelverkOptions.ts:73-74` — bare aktive; `SettRegelverkBody.tsx:42,76` |
| `@OPT-REG-RAN-001` | Slette rangeringsregelverk | funnet | `G/regelverk/regelverk.graphqls:37`; `A/regelverk/features/Rangeringsregelverk/components/Rangeringsregelverk/Rangeringsregelverk.tsx:218-229` |
| `@OPT-REG-RAN-001` | Kan ikke slette rangeringsregelverk som er i bruk | funnet | `A/regelverk/features/Rangeringsregelverk/components/Rangeringsregelverk/Rangeringsregelverk.tsx:230-238` viser `deleteError`; sperren er FK fra `utdanningstilbud.rangeringsregelverk_kode` (ikke lest av finneren) |
| `@OPT-REG-RAN-002` | Opprette poengklasse | funnet | `P/regelverk/poeng/PoengklasseService.java:35,138-150`; `A/regelverk/features/Poengklasser/PoengklasseDetails/PoengklasseDetails.tsx` |
| `@OPT-REG-RAN-002` | Poengklasse med flerspråklig navn | funnet | `P/regelverk/poeng/PoengklasseService.java:138-150` — `poengklasse_sprak` |
| `@OPT-REG-RAN-002` | Opprette poengvariant | funnet | `P/regelverk/poeng/PoengvariantService.java:35,137-149`; `A/regelverk/features/Poengvarianter/PoengvariantDetails/PoengvariantDetails.tsx` |
| `@OPT-REG-RAN-002` | Opprette poengtype | funnet | `P/regelverk/poeng/PoengtypeService.java:38-48,64`; `A/regelverk/features/Poengtyper/PoengtyperDetails/PoengtyperDetails.tsx:127` |
| `@OPT-REG-RAN-002` | Poengtype med algoritme | funnet | `P/regelverk/poeng/PoengtypeService.java:48`; `P/regelverk/poeng/AlgoritmepoengService.java:83-84`; `PoengtyperDetails.tsx:39,157` (koden heter `ALD_…`) |
| `@OPT-REG-RAN-002` | Poengtype med poengtrinn | funnet | `P/regelverk/poeng/PoengAvrunder.java:24-25`; `P/regelverk/poeng/PoengService.java:204`; `PoengtypeService.java:47` |
| `@OPT-REG-RAN-002` | Opprette poengformel | funnet | `P/regelverk/poeng/PoengformelService.java:35-39,134-139`; `A/regelverk/features/Poengformler/PoengformelDetails/PoengformelDetails.tsx:78` |
| `@OPT-REG-RAN-002` | Ugyldig formeluttrykk avvises | funnet | `A/regelverk/features/Poengformler/PoengformelDetails/PoengformelDetails.tsx:97-99,196,383`; `PoengformelEditor.tsx:372`. Merk: backend validerer ikke uttrykket (`P/regelverk/poeng/PoengformelService.java:35-40`) |
| `@OPT-REG-RAN-002` | Slette poengklasse som ikke er i bruk | funnet | `P/regelverk/poeng/PoengklasseService.java:104,111`; `PoengklasseDetails.tsx:104` |
| `@OPT-REG-RAN-002` | Kan ikke slette poengtype som er i bruk | funnet | `P/regelverk/poeng/PoengtypeService.java:146-154` — `PoengtypeIBrukException`; `PoengtyperDetails.tsx:243-256` (egen melding for `PoengtypeIBrukError`); FK `V188__regelverksamling_rangeringsregelverk.sql:119-122` |
| `@OPT-REG-KVO-001` | Opprette ordinær kvote | funnet | `P/regelverk/kvotetype/KvotetypeMutations.java:38-66`; `A/regelverk/features/Kvoteregelverk/Kvoteregelverk.tsx:135-139`, `A/regelverk/features/Kvoteregelverk/components/KvoteBasicInfoCard/KvoteBasicInfoCard.tsx:45-66` |
| `@OPT-REG-KVO-001` | Opprette førstegangsvitnemålskvote | funnet | `P/regelverk/kvotetype/KvotetypeMutations.java:45-46` — kvoterangering SP |
| `@OPT-REG-KVO-001` | Flerspråklig navn på kvotetype | funnet | `P/regelverk/kvotetype/KvotetypeMutations.java:53,215-224`; `KvoteBasicInfoCard.tsx:14` |
| `@OPT-REG-KVO-001` | Sette default poengformel | funnet | `P/regelverk/kvotetype/KvotetypeMutations.java:47-48`; `P/regelverk/poeng/PoengberegningService.java:366-384`; `KvoteBasicInfoCard.tsx:41,50-52,68-75` |
| `@OPT-REG-KVO-001` | Koble grunnlag til kvotetype | funnet | `P/regelverk/kvotetype/KvotetypeMutations.java:55-60,197-213`; `P/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:243-336`; `A/regelverk/features/Kvoteregelverk/components/KvoteGrunnlag/KvoteGrunnlag.tsx` |
| `@OPT-REG-KVO-001` | Aldersgrensen følger grunnlaget | funnet | `KvoteplasseringGrunnlagService.java:243-336`; `P/saksbehandling/SoknadKvoteOppretterService.java:167-231` |
| `@OPT-REG-KVO-001` | Kvotetype uten grunnlag og kvotespørsmål | funnet | `SoknadKvoteOppretterService.java:53-58,91`; `KvoteplasseringGrunnlagService.java:151-153` |
| `@OPT-REG-KVO-001` | Kvotetypen har plasser som standard | ikke funnet | ikke funnet på main — finnes i MR !6602 (åpen, fs-plattform, feature/take-492-kvotetype-innstillinger): `V513__kvotetype_innstillinger.sql:7-10` (`uten_plasser DEFAULT false`). Søkt «uten_plasser», «utenPlasser» på main |
| `@OPT-REG-KVO-001` | Opprette kvotetype uten plasser | ikke funnet | ikke funnet på main — finnes i MR !6602 (åpen, fs-plattform, feature/take-492-kvotetype-innstillinger): `KvotetypeMutations.java:48,134-148`. Ikke i fs-admin |
| `@OPT-REG-KVO-001` | Hovedkvoten kan ikke være uten plasser | ikke funnet | ikke funnet på main — finnes i MR !6602 (åpen, fs-plattform, feature/take-492-kvotetype-innstillinger): `KvotetypeMutations.java:87-90,150-161`, `KvoteoppsettMutations.java:50-54` (meldingen gjelder plassflyt, ikke hovedkvoten spesielt) |
| `@OPT-REG-KVO-001` | En kvotetype som mottar plassflyt, kan ikke være uten plasser | ikke funnet | ikke funnet på main — finnes i MR !6602 (åpen, fs-plattform, feature/take-492-kvotetype-innstillinger): `KvotetypeMutations.java:150-161` |
| `@OPT-REG-KVO-001` | Kvotetypen er ikke standardkvote som standard | ikke funnet | ikke funnet på main — finnes i MR !6602 (åpen, fs-plattform, feature/take-492-kvotetype-innstillinger): `V513__kvotetype_innstillinger.sql:8`. Søkt «standardkvote» på main |
| `@OPT-REG-KVO-001` | Utdanningstilbud som legges til i opptaket, får standardkvoten | ikke funnet | ikke funnet på main — finnes i MR !6602 (åpen, fs-plattform, feature/take-492-kvotetype-innstillinger): `UtdanningstilbudMutations.java:1387-1411` |
| `@OPT-REG-KVO-001` | Utdanningstilbud som allerede er i opptaket, får ikke standardkvoten | ikke funnet | ikke funnet på main — finnes i MR !6602 (åpen, fs-plattform, feature/take-492-kvotetype-innstillinger): `UtdanningstilbudMutations.java:1387-1389`, `KvotetypeMutations.java:134-148` |
| `@OPT-REG-KVO-001` | Kvoten blir stående når kvotetypen ikke lenger er standardkvote | ikke funnet | ikke funnet på main — finnes i MR !6602 (åpen, fs-plattform, feature/take-492-kvotetype-innstillinger): `KvotetypeMutations.java:134-148` |
| `@OPT-REG-KVO-001` | Kvotetypen er åpen for fjerning som standard | ikke funnet | ikke funnet på main — finnes i MR !6602 (åpen, fs-plattform, feature/take-492-kvotetype-innstillinger): `V513__kvotetype_innstillinger.sql:10` (`kan_fjernes DEFAULT true`). Søkt «kan_fjernes» på main |
| `@OPT-REG-KVO-001` | Stenge kvotetypen for fjerning | ikke funnet | ikke funnet på main — finnes i MR !6602 (åpen, fs-plattform, feature/take-492-kvotetype-innstillinger): `KvotetypeMutations.java:145-147`, `KvoteMutations.java:545,567` |
| `@OPT-REG-KVO-001` | Organisasjonen som eier opptaket, kan ikke overstyre stengingen | ikke funnet | ikke funnet på main — finnes i MR !6602 (åpen, fs-plattform, feature/take-492-kvotetype-innstillinger): `V513__kvotetype_innstillinger.sql:16-24` — RLS-policy for DELETE |
| `@OPT-REG-KVO-001` | Slette kvotetype | funnet | `G/regelverk/kvote.graphqls:62-63`; `A/regelverk/features/Kvoteregelverk/Kvoteregelverk.tsx:172-190` |
| `@OPT-REG-KVO-001` | Kan ikke slette kvotetype som er i bruk | funnet | `kvote.graphqls:361,399-408` — `KvotetypeIBrukError`; `A/regelverk/features/Kvoteregelverk/Kvoteregelverk.tsx:180-183` |
| `@OPT-REG-KVO-002` | Opprette kvotespørsmål | funnet | `P/regelverk/kvoteplassering/KvotesporsmalService.java:28,39,179-193`; `kvote.graphqls:19`; `A/regelverk/features/Kvotesporsmal/KvotesporsmalDetails/KvotesporsmalDetails.tsx:164` |
| `@OPT-REG-KVO-002` | Flerspråklig kvotespørsmål | funnet | `P/regelverk/kvoteplassering/KvotesporsmalService.java:120-170,179-193`; `A/regelverk/features/Kvotesporsmal/KvotesporsmalDetails/KvotesporsmalDetails.tsx:272-278` |
| `@OPT-REG-KVO-002` | Tilgjengelige algoritmer | funnet | `A/regelverk/features/Kvotesporsmal/KvotesporsmalDetails/KvotesporsmalDetails.tsx:87-93`; `V297__seed_kvotesporsmal_kjonnsalgoritmer.sql:8-9` |
| `@OPT-REG-KVO-002` | Koble kvotespørsmål til en algoritme | funnet | `P/regelverk/kvoteplassering/SettKvotesporsmalAlgoritmeService.java:26-27`; `A/regelverk/features/Kvotesporsmal/KvotesporsmalDetails/KvotesporsmalDetails.tsx:136-159`; `P/autosak/KvotesporsmalAlgoritmeService.java:131-150,228` |
| `@OPT-REG-KVO-002` | Knytte kvotespørsmål til kvotetype | funnet | `P/regelverk/kvotetype/KvotetypeMutations.java:130-144`; `A/regelverk/features/Kvoteregelverk/Kvoteregelverk.tsx:161,264`; `P/saksbehandling/KvotesporsmalSvarService.java:303-321,377` |
| `@OPT-REG-KVO-002` | Knytte flere kvotespørsmål til samme kvotetype | funnet | `P/saksbehandling/KvotesporsmalSvarService.java:402-413`; `KvotetypeMutations.java:144` |
| `@OPT-REG-KVO-002` | Slette kvotespørsmål | funnet | `P/regelverk/kvoteplassering/KvotesporsmalService.java:102-113` — FK-brudd gir `KvotesporsmalIBrukException`; `A/regelverk/features/Kvotesporsmal/KvotesporsmalDetails/KvotesporsmalDetails.tsx:188` |
| `@OPT-BEH-BEH-012` | Plassering i kvote uten kvotespørsmål | funnet | `P/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:89-188,243-336`; `P/saksbehandling/KvotesumV2Service.java:175-210`; `A/soknadsbehandling/features/OppsummeringCard/components/PoengTable/PoengTable.tsx:58-65` |
| `@OPT-BEH-BEH-012` | Søkeren er ikke kvalifisert på grunnlaget | funnet | `P/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:307`; `P/saksbehandling/SoknadKvoteOppretterService.java:53-58,91,251-278` |
| `@OPT-BEH-BEH-012` | Kvote uten kvotespørsmål vises ikke blant kvotespørsmålene | funnet | `A/soknadsbehandling/features/KvoteplasseringCard/KvoteplasseringCard.tsx:86-126` — bare `kvotesporsmalSvar`; `P/saksbehandling/SoknadKvotesporsmalSvarOppdateringService.java` steg 2 |
| `@OPT-BEH-BEH-012` | Grunnlag som ikke er koblet til kvotetypen | funnet | `P/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:243-336,151-153` |
| `@OPT-BEH-BEH-012` | Alder på datoen for aldersberegning | funnet | `P/saksbehandling/AldersberegningsdatoUtleder.java:12,47-55`; `P/opptak/AldersberegningsdatoDefault.java:14-16`; `P/regelverk/kvoteplassering/Aldersgrense.java:55-57` |
| `@OPT-BEH-BEH-012` | Aldersgrense på grunnlaget | funnet | `P/regelverk/kvoteplassering/Aldersgrense.java:28-45`; `P/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:336` — alle fem radene |
| `@OPT-BEH-BEH-012` | Kvotespørsmål stilles ikke når aldersgrensen ikke er møtt | funnet | `P/saksbehandling/SoknadKvoteOppretterService.java:41,106,167-231` |
| `@OPT-BEH-BEH-012` | Alle kvotespørsmål besvart ja | funnet | `P/saksbehandling/KvotesporsmalSvarService.java:364-368,401-413` |
| `@OPT-BEH-BEH-012` | Ett kvotespørsmål besvart nei | funnet | `P/saksbehandling/KvotesporsmalSvarService.java:405-408` |
| `@OPT-BEH-BEH-012` | Kvotespørsmålene vises i søknadsbehandlingen | funnet | `A/soknadsbehandling/features/KvoteplasseringCard/KvoteplasseringCard.tsx:111-117,144-156` |
| `@OPT-BEH-BEH-012` | Samme kvotespørsmål på flere kvotetyper vises én gang | funnet | `A/soknadsbehandling/features/KvoteplasseringCard/KvoteplasseringCard.tsx:88-110,128-130` |
| `@OPT-BEH-BEH-012` | Automatisk besvart kvotespørsmål vises låst | funnet | `P/autosak/KvotesporsmalAlgoritmeService.java:210-262`; `P/regelverk/kvoteplassering/KvotesporsmalKjonnsAlgoritme.java:16-17`; `A/soknadsbehandling/features/KvoteplasseringCard/KvoteplasseringCard.tsx:118-119,149-151`, `A/soknadsbehandling/features/KvoteplasseringCard/components/KvotesporsmalRow/KvotesporsmalRow.tsx:36,54-61` |
| `@OPT-BEH-BEH-012` | Svar på automatisk kvotespørsmål avvises i API-et | funnet | `P/saksbehandling/KvotesporsmalSvarService.java:120-134` — `KvotesporsmalBesvaresAutomatiskException` |
| `@OPT-BEH-BEH-012` | Automatisk kvoteplassering i endringsloggen | ikke funnet | `V480__stopp_endringslogg.sql:1-28` (og V483 fjerner `bruker_id`). Søkt «endringslogg», «audit», «maskinbruker» |
| `@OPT-BEH-BEH-012` | Endringsloggen viser opptaksalderen | ikke funnet | Opptaksalder i `sak_kvote.merknad_automatisk` (`P/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:172-177,195-225`), men endringsloggen fylles ikke og fs-admin henter ikke merknaden |
| `@OPT-BEH-BEH-012` | Ny automatisk behandling uten endring gir ikke nytt innslag | usikker | Finneren: `P/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:172-177` — merknaden skrives bare ved endring. Kontrollen: `Så` holder bare fordi endringsloggen ikke fylles i det hele tatt etter V480 (`V480__stopp_endringslogg.sql`), og merknaden er ikke endringsloggen |
| `@OPT-BEH-BEH-015` | Opptakssystemets påstand er at søkeren har generell studiekompetanse | funnet | `P/vgs/HentVgsVitnemaalService.java:193,204-213`; `P/autosak/gsk/GskPaastandService.java:36-42`; `P/autosak/gsk/GskKonklusjonEvaluator.java:93-98` |
| `@OPT-BEH-BEH-015` | Opptakssystemets påstand beregnes uavhengig av GSK OK fra KREG | funnet | `P/autosak/gsk/GskKonklusjonEvaluator.java:93-98` — leser ikke `gsk_ok` |
| `@OPT-BEH-BEH-015` | Hvert vitnemål får sin egen påstand | funnet | `P/vgs/HentVgsVitnemaalService.java:173-193` |
| `@OPT-BEH-BEH-015` | Grunnlagskoder som settes automatisk | funnet | `P/autosak/gsk/GskKonklusjonEvaluator.java:116-131`; `V275__vgs_loep.sql:29` |
| `@OPT-BEH-BEH-015` | Opptakssystemets påstand er at søkeren ikke har GSK når <grunn> | funnet | Kontrollen (lest av lead): `P/autosak/gsk/GskKonklusjonEvaluator.java:96-97` — ukjent løp (`loep == null`) og ulik reform (`P/autosak/gsk/GskKonklusjonEvaluator.java:123-124`) gir grunnlagskode null og dermed ikke GSK; alle tre radene dekket. Finneren: `P/autosak/gsk/GskKonklusjonEvaluator.java:96-97` dekker manglende dato og seksfagskontroll; «løpet ikke gir GSK»: løp i listen uten grunnlagstype gir KLY/RFA (`P/autosak/gsk/GskKonklusjonEvaluator.java:120-131`), så uklart hva raden betyr |
| `@OPT-BEH-BEH-015` | Annullert vitnemål får ingen påstand fra opptakssystemet | funnet | `P/autosak/gsk/GskPaastandService.java:66-67,35-42` |
| `@OPT-BEH-BEH-015` | Vitnemålet gir GSK når det har GSK OK fra KREG | funnet | `P/autosak/gsk/GskVedtakAutoService.java:158`; `P/autosak/gsk/GskKonklusjonEvaluator.java:61-76` |
| `@OPT-BEH-BEH-015` | Vitnemålet gir ikke GSK når det ikke har GSK OK fra KREG | funnet | `P/autosak/gsk/GskKonklusjonEvaluator.java:61-63` |
| `@OPT-BEH-BEH-015` | Uenighet med skolen stopper ikke den automatiske behandlingen | funnet | `P/autosak/gsk/GskKonklusjonEvaluator.java:64-76`; `P/autosak/gsk/GskVedtakAutoService.java:198,210-212`; `P/autosak/FerdigbehandlingService.java:98-100` |
| `@OPT-BEH-BEH-015` | Annullert vitnemål gir ikke GSK | funnet | `P/autosak/gsk/GskVedtakAutoService.java:74-79` |
| `@OPT-BEH-BEH-015` | Saksbehandleren ser at opptakssystemet er uenig med skolen når vitnemålet <skolen> GSK OK fra KREG | funnet | `P/vgs/VgsDokumentGskKontrollService.java:52-59`; `vgs-dokument.graphqls:36`; `A/soknadsbehandling/features/VitnemalsbehandlingSection/VitnemalsbehandlingSection.tsx:86,107-112` |
| `@OPT-BEH-BEH-015` | Søknaden får konklusjonen fra vitnemålet | funnet | `S/app/SoknadshendelseJobb.java:412,426-431` → `P/autosak/gsk/GskKonklusjonEtterImportService.java:41-54` → `P/autosak/gsk/GskVedtakAutoService.java:213-225` |
| `@OPT-BEH-BEH-015` | Søknaden får konklusjonen fra vitnemålet når saken er <status> | funnet | `P/autosak/gsk/GskKonklusjonEtterImportService.java:66-75` — ingen statusfilter, status endres ikke |
| `@OPT-BEH-BEH-015` | Søknaden får grunnlagskoden for løpet når opptakssystemet er uenig med skolen | funnet | `P/autosak/gsk/GskKonklusjonEvaluator.java:64,72-76` |
| `@OPT-BEH-BEH-015` | Søknaden får grunnlagskoden <grunnlagskode> når et løp fra <reform> ikke finnes i opptakssystemets liste over løp | funnet | `P/autosak/gsk/GskKonklusjonEvaluator.java:65-70,79-84` |
| `@OPT-BEH-BEH-015` | Et vitnemål med et løp i listen brukes før et nyere vitnemål med et ukjent løp | funnet | `P/autosak/gsk/GskVedtakAutoService.java:86-106` |
| `@OPT-BEH-BEH-015` | Det nyeste vitnemålet brukes når ingen av løpene finnes i listen | funnet | `P/autosak/gsk/GskVedtakAutoService.java:78,94-97,102-105` |
| `@OPT-BEH-BEH-015` | Søknaden får grunnlagskoden <grunnlagskode> når et løp fra <reform> ikke har en grunnlagskode | funnet | `P/autosak/gsk/GskKonklusjonEvaluator.java:120-131,73-74` |
| `@OPT-BEH-BEH-015` | Vitnemål som ikke gir GSK, gir ingen konklusjon | funnet | `P/autosak/gsk/GskVedtakAutoService.java:98-100,113` |
| `@OPT-BEH-BEH-015` | Vitnemålet med senest utstedelsesdato brukes | funnet | `P/autosak/gsk/GskVedtakAutoService.java:78,90-92` |
| `@OPT-BEH-BEH-015` | Alle søknader uten konklusjon oppdateres | funnet | `P/autosak/gsk/GskKonklusjonEtterImportService.java:43-54`; `P/autosak/gsk/GskVedtakAutoService.java:59-60,135-142` |
| `@OPT-BEH-BEH-015` | Søknader i avsluttede opptak oppdateres ikke | funnet | `P/autosak/gsk/GskVedtakAutoService.java:62-63,144-150` |
| `@OPT-BEH-BEH-015` | Nytt vitnemål fra KREG etter at søknaden er opprettet | ikke funnet | Ingen import for aktive søkere (som OPT-BEH-BEH-030); søkt på main, MR !6629, !6628 og branchene |
| `@OPT-BEH-BEH-015` | Gjenbruke positiv konklusjon fra tidligere samordna opptak | funnet | `P/autosak/gsk/TidligereGskKonklusjonService.java:86-96,139-188`; `V481__gsk_konklusjon_historikk.sql`; `P/autosak/gsk/GskVedtakAutoService.java:107-112,169-182` |
| `@OPT-BEH-BEH-015` | Vitnemålet går foran tidligere konklusjon | funnet | `P/autosak/gsk/GskVedtakAutoService.java:86-107` |
| `@OPT-BEH-BEH-015` | Bare den siste tidligere konklusjonen gjenbrukes | funnet | `P/autosak/gsk/TidligereGskKonklusjonService.java:80-96` |
| `@OPT-BEH-BEH-015` | Negative konklusjoner gjenbrukes ikke | funnet | `P/autosak/gsk/TidligereGskKonklusjonService.java:82,119-120,171-172` |
| `@OPT-BEH-BEH-015` | Gjenbruke positiv konklusjon fra lokalt opptak | funnet | `P/autosak/gsk/TidligereGskKonklusjonService.java:98-137` |
| `@OPT-BEH-BEH-015` | Gjenbruke kvalitetssikret konklusjon fra FS-klienten | ikke funnet | Kildene er bare `gsk_vedtak` og SODA (`P/autosak/gsk/TidligereGskKonklusjonService.java:86-89`); søkt «kvalitetssikr», «FS-klient» på main og branchene |
| `@OPT-BEH-BEH-015` | Annullert konklusjon gjenbrukes ikke | funnet | `P/autosak/gsk/TidligereGskKonklusjonService.java:115-116,140-145,167-168` |
| `@OPT-BEH-BEH-015` | Konklusjon med annullering fram i tid gjenbrukes ikke | funnet | `P/autosak/gsk/TidligereGskKonklusjonService.java:115,167` — uten datosjekk |
| `@OPT-BEH-BEH-015` | Konklusjon som bygger på et annullert vitnemål gjenbrukes ikke | funnet | `P/autosak/gsk/TidligereGskKonklusjonService.java:118,170,191-197` |
| `@OPT-BEH-BEH-015` | Ingen grunnlag for generell studiekompetanse | funnet | `P/autosak/gsk/GskVedtakAutoService.java:113`; `A/soknadsbehandling/features/GSKCard/GSKCard.tsx:348-349,367` |
| `@OPT-BEH-BEH-015` | Konklusjon på søknaden overskrives ikke | funnet | `P/autosak/gsk/GskVedtakAutoService.java:59-60,129-142` |
| `@OPT-BEH-BEH-015` | Systemet setter aldri en negativ konklusjon | funnet | `P/autosak/gsk/GskVedtakAutoService.java:172,216` — begge KVALIFISERT |
| `@OPT-BEH-BEH-015` | Grunnlagskoden rettes når opptaksforvalteren starter det | ikke funnet | Ingen retting; søkt «rettGrunnlag», «korriger.*grunnlag», «ukjent løp» i fs-plattform og fs-admin, og branchene |
| `@OPT-BEH-BEH-015` | Grunnlagskoden rettes ikke før opptaksforvalteren starter det | usikker | Holder fordi ingenting retter, men rettingen finnes ikke |
| `@OPT-BEH-BEH-015` | Grunnlagskoden rettes også i en sak som er ferdig behandlet | ikke funnet | Ingen retting |
| `@OPT-BEH-BEH-015` | Grunnlagskoden rettes ikke etter at resultatet av siste plasstildelingsrunde er publisert | ikke funnet | Ingen retting |
| `@OPT-BEH-BEH-015` | Opptaksforvalteren ser søknadene som får grunnlagskoden rettet, før rettingen startes | ikke funnet | Ingen forhåndsvisning eller retting |
| `@OPT-BEH-BEH-015` | En konklusjon saksbehandleren har satt, rettes ikke | ikke funnet | Ingen retting |
| `@OPT-BEH-BEH-015` | Søknaden får konklusjonen fra vitnemålet i den automatiske behandlingen | funnet | `P/autosak/AutomatiskSaksbehandlingService.java:96,154-163` — steg 0a |
| `@OPT-BEH-BEH-015` | Søknaden får konklusjonen fra et tidligere opptak i den automatiske behandlingen | funnet | Steg 0a → `P/autosak/gsk/GskVedtakAutoService.java:107-112` |
| `@OPT-BEH-BEH-015` | Konklusjonen overskrives ikke i den automatiske behandlingen | funnet | `P/autosak/gsk/GskVedtakAutoService.java:59-60`; `AutomatiskSaksbehandlingService.java:165-170` |
| `@OPT-BEH-BEH-015` | Overskrive positiv konklusjon med negativ konklusjon | funnet | `P/soknad/gskvedtak/GskVedtakService.java:99-105,437-460,349-361`; `A/soknadsbehandling/features/GSKCard/GSKCard.tsx:367-396` |
| `@OPT-BEH-BEH-015` | Legge til positiv konklusjon når ingen finnes | funnet | `P/soknad/gskvedtak/GskVedtakService.java:68,396-412`; `A/soknadsbehandling/features/GSKCard/GSKCard.tsx:397-405` |
| `@OPT-BEH-BEH-015` | Bare positive konklusjoner kan legges til når ingen finnes | usikker | Backend avviser (`GskVedtakService.java:406-411`), men `A/soknadsbehandling/features/GSKCard/GSKCard.tsx:367,383-396` viser «Ikke kvalifisert» også uten konklusjon, så saksbehandleren får en feil |
| `@OPT-BEH-BEH-015` | Automatisk konklusjon står når vitnemålet annulleres | funnet | `P/saksbehandling/AnnullertVitnemaalService.java:44-58,84-90,22-27` |
| `@OPT-BEH-BEH-015` | Gjenbrukt konklusjon står når vitnemålet annulleres | funnet | `P/autosak/gsk/GskVedtakAutoService.java:178`; `AnnullertVitnemaalService.java:84-90` |
| `@OPT-BEH-BEH-015` | Konklusjon i avsluttet opptak trekkes ikke tilbake | funnet | `AnnullertVitnemaalService.java:22-27` — ingen kode endrer konklusjonen |
| `@OPT-BEH-BEH-015` | Annulleringen oppdages uten at søkeren endrer søknaden | ikke funnet | Ingen import for aktive søkere |
| `@OPT-BEH-BEH-015` | Se hva den automatiske konklusjonen bygger på | ikke funnet | `A/soknadsbehandling/features/GSKCard/GSKCard.tsx:350-352`, `A/soknadsbehandling/features/GSKCard/utils/gskUtils.ts:50-53` viser «Satt automatisk» bare for AUT; GJENBRUK vises som «Ukjent». ikke funnet på main — finnes i MR !3358 (utkast, fs-admin, solov/gsk-konklusjon-kilde-opptak): `gskUtils.ts` (`gskEndretAvTekst`) |
| `@OPT-BEH-BEH-015` | Se hvilket opptak en gjenbrukt konklusjon kommer fra | ikke funnet | `kilde_opptak_kode` lagres (`P/autosak/gsk/GskVedtakAutoService.java:177`), ikke i GraphQL. ikke funnet på main — finnes i MR !6628 (åpen, fs-plattform): `gsk.graphqls` (`kildeOpptak`) og MR !3358 (utkast, fs-admin): `GSKCard.tsx` |
| `@OPT-BEH-BEH-018` | Poengtype som beregnes fra vitnemålet | funnet | `P/regelverk/poeng/AutomatiskPoengberegningService.java:77-119`; `P/regelverk/poeng/PoengService.java:245-261`; `P/autosak/kontrollmotor/KontrollMotor.java:168-170`; `P/regelverk/poeng/PoengService.java:190-222` — alle tre radene |
| `@OPT-BEH-BEH-018` | Poengtype uten kobling til vitnemålet beregnes ikke | funnet | `P/regelverk/poeng/AutomatiskPoengberegningService.java:88`; `P/regelverk/poeng/AlgoritmepoengService.java:79-81` |
| `@OPT-BEH-BEH-018` | Beregnet poeng rundes til antall desimaler poengtypen har | funnet | `P/regelverk/poeng/PoengService.java:198-205`; `P/regelverk/poeng/PoengAvrunder.java:22-31` |
| `@OPT-BEH-BEH-018` | Skolepoeng beregnet fra vitnemålspoengene | usikker | Poengformelen på kvotetypen (`P/regelverk/poeng/PoengsumService.java:67`), formelspråket har `min(` (`PoengformelParser.java:15,95,138`). Taket på 4 er regelverkdata, ikke kode; bare testen `SkolepoengEndeTilEndeIT.java:206,388` setter `KAR + min(4, REA + SPR)`. Ingen formel som grunndata |
| `@OPT-BEH-BEH-018` | Ingen automatiske vitnemålspoeng når <grunn> | ikke funnet | Rad 1-3: `P/vgs/VgsDokumentVitnemaalService.java:42-56`, `P/regelverk/poeng/AutomatiskPoengberegningService.java:93-105`, `P/regelverk/poeng/PoengService.java:229-234`. Rad 4 (ikke GSK): poengberegningen sjekker ikke `gsk_ok`. Rad 5 (ingen grunnlag): ingen poengrader (`P/saksbehandling/PoengRadOppdateringService.java:46-48`), men ingenting viser grunnen. Søkt «gsk_ok», «GskOk» i `regelverk/poeng/` |
| `@OPT-BEH-BEH-018` | Opplastet kompetansebevis hindrer ikke beregningen | funnet | `P/vgs/VgsDokumentVitnemaalService.java:43-47` |
| `@OPT-BEH-BEH-018` | Poeng som saksbehandleren endrer, blir stående | funnet | `P/regelverk/poeng/SettPoengService.java:104` — `la_staa = true`; `P/regelverk/poeng/AlgoritmepoengService.java:61`, `P/regelverk/poeng/PoengService.java:219` |
| `@OPT-BEH-BEH-018` | Saksbehandleren overstyrer automatisk beregnet <poeng> | funnet | `P/regelverk/poeng/SettPoengService.java:124-153,104`; `P/regelverk/poeng/PoengService.java:212-220` — alle tre poengtypene |
| `@OPT-BEH-BEH-018` | Låst poeng beregnes ikke på nytt | funnet | `P/regelverk/poeng/AlgoritmepoengService.java:61`; `P/regelverk/poeng/PoengService.java:219` |
| `@OPT-BEH-BEH-018` | Låse opp et poeng | funnet | `A/soknadsbehandling/features/PoengberegningCard/PoengberegningCardRow/PoengberegningCardRow.tsx:168-175,244-250`; `P/regelverk/poeng/SettPoengService.java:93-102,159-185` |
| `@OPT-BEH-BEH-018` | Poeng som ikke er låst, beregnes på nytt | funnet | `P/regelverk/poeng/PoengService.java:212-220` |
| `@OPT-BEH-BEH-018` | Saksbehandlerens merknad på poenget er uendret | funnet | `P/regelverk/poeng/PoengService.java:212-220,45-56` — `merknad` røres ikke |
| `@OPT-BEH-BEH-018` | Se at poenget er beregnet automatisk, og hvilket vitnemål det bygger på | usikker | `A/soknadsbehandling/features/PoengberegningCard/PoengberegningCardRow/PoengberegningCardRow.tsx:198` viser «KAR beregnet fra vitnemålet» (`P/regelverk/poeng/PoengService.java:208-210`), men vitnemålsnummeret (`P/regelverk/poeng/PoengService.java:217` `vgdoknr`) hentes ikke (`P/PoengberegningCard/PoengberegningCard.tsx:20-27`) og vises ikke |
| `@OPT-BEH-BEH-018` | Se hvorfor vitnemålspoengene ikke er beregnet | usikker | `P/regelverk/poeng/AutomatiskPoengberegningService.java:93-97`, `P/regelverk/poeng/PoengService.java:229-234`, `A/soknadsbehandling/features/PoengberegningCard/PoengberegningCardRow/PoengberegningCardRow.tsx:198-222` viser «Fant ikke entydig vitnemål» — men kontrollen: bare for saker med poengrader og uten flere vitnemål; ved flere vitnemål rulles autosaken tilbake (`P/autosak/SetteGrunnlagService.java:111-114`) og grunnen vises bare i snackbaren (`BehandleSakAutomatiskButton.tsx:40-42`) |
| `@OPT-BEH-BEH-018` | Finne saker som er behandlet automatisk | ikke funnet | `status_automatisk_behandlet` settes (`P/autosak/AutomatiskSaksbehandlingService.java:114-119`), men ikke i `SakFilterV2Input` (`sak.graphqls:297`) eller skjemaet; søkt også i fs-admin og branchene |
| `@OPT-BEH-BEH-019` | Grunnlag ut fra førstegangsvitnemål og alder | funnet | `P/autosak/SetteGrunnlagService.java:301-336`, `:338-345` — alle tre radene |
| `@OPT-BEH-BEH-019` | Alderen regnes ut på datoen for aldersberegning | funnet | `P/autosak/SetteGrunnlagService.java:165-168`; `P/regelverk/kvoteplassering/Aldersgrense.java:55-57`; `P/saksbehandling/AldersberegningsdatoUtleder.java:43-56` |
| `@OPT-BEH-BEH-019` | Førstegangsvitnemål går foran | funnet | `P/autosak/SetteGrunnlagService.java:287-288`, `:330-335`, `:188-205` |
| `@OPT-BEH-BEH-019` | Ingen grunnlag settes når flere grunnlag passer like godt | ikke funnet | `P/autosak/SetteGrunnlagService.java:289-298` — ved likhet velges laveste kode og settes. Søkt «like godt», «samme prioritet» på main og branchene |
| `@OPT-BEH-BEH-019` | Grunnlag uten egenskaper for automatikken settes ikke | funnet | `P/autosak/SetteGrunnlagService.java:256-259` |
| `@OPT-BEH-BEH-019` | Bare grunnlag i regelverket til utdanningstilbudene i søknaden kan settes | funnet | `P/autosak/SetteGrunnlagService.java:134-153`, `:236-253` |
| `@OPT-BEH-BEH-019` | Grunnlag som ikke er aktivt, settes ikke | funnet | `P/autosak/SetteGrunnlagService.java:254` — `ER_AKTIV` |
| `@OPT-BEH-BEH-019` | Ingen grunnlag settes automatisk når <grunn> | funnet | `P/autosak/SetteGrunnlagService.java:116-118`, `:128-130`, `:171-182` — alle tre radene |
| `@OPT-BEH-BEH-019` | Søker med flere vitnemål behandles ikke automatisk | funnet | `P/autosak/SetteGrunnlagService.java:111-115` — `FlereVitnemaalException` ruller tilbake (`P/autosak/AutomatiskSaksbehandlingService.java:112-158`); GSK settes likevel først (`P/autosak/AutomatiskSaksbehandlingService.java:97`) |
| `@OPT-BEH-BEH-019` | Opplastet kompetansebevis stopper ikke automatikken | funnet | `P/autosak/SetteGrunnlagService.java:371-376` — bare `vgs_dokument` |
| `@OPT-BEH-BEH-019` | Annullert vitnemål teller ikke | funnet | `P/autosak/SetteGrunnlagService.java:374` |
| `@OPT-BEH-BEH-019` | Grunnlaget settes etter GSK-konklusjonen | funnet | `P/autosak/AutomatiskSaksbehandlingService.java:97` før `P/autosak/AutomatiskSaksbehandlingService.java:123-124` |
| `@OPT-BEH-BEH-019` | Hver sak i søknaden får grunnlaget når den automatiske behandlingen kjører for saken | funnet | `P/autosak/SetteGrunnlagService.java:98`, `:190-193` — per `SakNokkel` |
| `@OPT-BEH-BEH-019` | Grunnlaget settes av den automatiske behandlingen | funnet | `P/autosak/AutomatiskSaksbehandlingService.java:123-124`; `P/autosak/SetteGrunnlagService.java:198` |
| `@OPT-BEH-BEH-019` | Automatikken setter ikke grunnlag når saksbehandleren har lagt til et grunnlag | funnet | `P/autosak/SetteGrunnlagService.java:100-106`, `:227-234` |
| `@OPT-BEH-BEH-019` | Grunnlaget saksbehandleren legger til, gjelder bare saken hos organisasjonen | funnet | `P/saksbehandling/LeggTilGrunnlagService.java:93-96`; `A/soknadsbehandling/features/GrunnlagCard/GrunnlagCard.tsx:121-127` |
| `@OPT-BEH-BEH-019` | Saksbehandleren velger et grunnlag som automatikken har satt | funnet | `P/saksbehandling/LeggTilGrunnlagService.java:108-112` |
| `@OPT-BEH-BEH-019` | Automatikken fjerner ikke grunnlag saksbehandleren har lagt til | funnet | `P/autosak/SetteGrunnlagService.java:100-106`; `P/saksbehandling/KvalifikasjonsgrunnlagOppdateringService.java:103-112` |
| `@OPT-BEH-BEH-019` | Grunnlaget blir stående når studieønsket som ga det, fjernes | funnet | `KvalifikasjonsgrunnlagOppdateringService.java:60-63,103-112` |
| `@OPT-BEH-BEH-019` | Saksbehandleren fjerner et grunnlag som er satt automatisk | funnet | `P/saksbehandling/FjernGrunnlagService.java:70-86`; `A/soknadsbehandling/features/GrunnlagCard/GrunnlagCard.tsx:117` |
| `@OPT-BEH-BEH-019` | Automatikken setter ikke et grunnlag som saksbehandleren har fjernet | ikke funnet | `P/saksbehandling/FjernGrunnlagService.java:72-78` sletter uten å huske; `P/autosak/SetteGrunnlagService.java:188-205` setter det på nytt. Søkt «fjernet», «la_staa», «sperr» |
| `@OPT-BEH-BEH-019` | Automatikken erstatter grunnlaget når søkeren passer til et annet | ikke funnet | `P/autosak/SetteGrunnlagService.java:86-87`, `:188-205` — andre automatiske rader slettes ikke |
| `@OPT-BEH-BEH-019` | Grunnlag utenfor aldersgrensen kan ikke velges manuelt | ikke funnet | `P/saksbehandling/LeggTilGrunnlagService.java:143-171`, `:81-86` — ingen alderskontroll. Søkt «aldersgrense» i LTG og GrunnlagCard |
| `@OPT-BEH-BEH-019` | Opptaket mangler dato for aldersberegning | ikke funnet | Backend: `P/saksbehandling/LeggTilGrunnlagService.java:40` → `ManglerAldersberegningsdatoFeil` (`sak.graphqls:1131-1136`), men fs-admin viser bare «Kunne ikke endre grunnlag» (`A/soknadsbehandling/features/GrunnlagCard/GrunnlagCard.tsx:140-148`). Kontrollen gjelder hele opptaket (`OpptakKreverAlderUtleder.java:22-31`) |
| `@OPT-BEH-BEH-019` | Opptakskrav, kvoter og tilleggspoeng følger grunnlaget saksbehandleren legger til | funnet | `P/saksbehandling/LeggTilGrunnlagService.java:44-48`; `P/saksbehandling/PropageringService.java:104-111,134-137,170-174` |
| `@OPT-BEH-BEH-019` | Opptakskrav, kvoter og tilleggspoeng følger grunnlaget som er satt automatisk | funnet | `P/autosak/AutomatiskSaksbehandlingService.java:129` — samme `propagerFraGrunnlag` |
| `@OPT-BEH-BEH-019` | Se at grunnlaget er satt automatisk | ikke funnet | `status_automatisk_utregnet` lagres (`P/autosak/SetteGrunnlagService.java:198`), men ikke i GraphQL (`kvalifisering.graphqls:140-150`) eller `A/soknadsbehandling/features/GrunnlagCard/GrunnlagCard.tsx:19-42` |
| `@OPT-BEH-BEH-019` | Se hvorfor grunnlaget ble valgt | ikke funnet | `merknad_automatisk` lagres (`P/autosak/SetteGrunnlagService.java:349-361`), ikke eksponert eller vist |
| `@OPT-BEH-BEH-019` | Endringsloggen viser at den automatiske behandlingen satte grunnlaget | ikke funnet | `V480__stopp_endringslogg.sql:1-29`; `sak.graphqls:196` |
| `@OPT-BEH-BEH-020` | Fagkrav som er oppfylt på vitnemålet | funnet | `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:100-133,170-179` — kontrollmotoren mot vitnemålet, skriver `kravet_er_oppfylt`; `P/autosak/kontrollmotor/KontrollMotor.java:90-95` (R1M) |
| `@OPT-BEH-BEH-020` | Fagkrav som ikke er oppfylt på vitnemålet | funnet | `P/autosak/kontrollmotor/KontrollMotor.java:196-198`; `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:168-171` |
| `@OPT-BEH-BEH-020` | Karakteren fra vitnemålet registreres på fagkravet | funnet | `KontrollMotor.java:74-77,196-198`; `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:162,172` lagrer `resultat` |
| `@OPT-BEH-BEH-020` | Fagkrav uten karakter oppfylles uten karakter | usikker | `P/autosak/kontrollmotor/FagSoek.java:415-424` — tom/«-» gir `Karakter.Ingen` og oppfylt; men «B», «IM», «F» gir `Karakter.Ugyldig` → `kravet_er_oppfylt` null og «vurder manuelt» (`P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:161-168`). Bestått fag uten tallkarakter blir ikke oppfylt automatisk |
| `@OPT-BEH-BEH-020` | Karakterkrav får karakteren fra vitnemålet | funnet | `KontrollMotor.java:161,282-296`; `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:162,172` |
| `@OPT-BEH-BEH-020` | Beste karakter gjelder for programfag matematikk | funnet | `KontrollMotor.java:84-89` (`Karakterstrategi.BESTE`); `FagSoek.java:381-398` |
| `@OPT-BEH-BEH-020` | Kravelement som ikke er koblet til vitnemålet, vurderes ikke | funnet | `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:118-129` — uten kode1 eller ukjent kode hoppes over |
| `@OPT-BEH-BEH-020` | Kravelementer fra en annen sak i søknaden vurderes ikke i saken | funnet | `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:111,210-214` — bare sakens nøkkel; `P/regelverk/kvalifisering/KvalifiseringDescent.java:91,135-152` |
| `@OPT-BEH-BEH-020` | Kravelement vurderes mot vitnemål fra R94 | funnet | `P/autosak/kontrollmotor/Kravelementer.java:376-429,565-567` — KL- og R94-koder |
| `@OPT-BEH-BEH-020` | Ugyldig karakter må vurderes manuelt | funnet | `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:161-168`; `A/soknadsbehandling/features/KravlisteStudierCard/utils/kravelementerUtils.ts:129`, `A/soknadsbehandling/features/KravlisteStudierCard/components/AutomatiskVurdering.tsx:24-25` |
| `@OPT-BEH-BEH-020` | Ingen automatisk vurdering når <grunn> | funnet | `P/vgs/VgsDokumentVitnemaalService.java:42-50`; `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:92-95` — begge radene |
| `@OPT-BEH-BEH-020` | Opplastet kompetansebevis stopper ikke vurderingen | funnet | `P/vgs/VgsDokumentVitnemaalService.java:43-47` — bare `vgs_dokument` fra KREG |
| `@OPT-BEH-BEH-020` | Kvalifisert når alle kravelementene i en kravliste er oppfylt | funnet | `P/regelverk/kvalifisering/KvalifiseringEvaluator.java:148-167`; `P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:97-116` |
| `@OPT-BEH-BEH-020` | Kvalifisert når én av kravlistene er oppfylt | funnet | `P/regelverk/kvalifisering/KvalifiseringEvaluator.java:161-162` |
| `@OPT-BEH-BEH-020` | Karakteren må nå karakterkravet | funnet | `P/regelverk/kvalifisering/KvalifiseringEvaluator.java:205-213` |
| `@OPT-BEH-BEH-020` | Søkeren kan være kvalifisert på ett grunnlag og ikke på et annet | funnet | `P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:137-173,97-116` |
| `@OPT-BEH-BEH-020` | Kravelementet vurderes i den automatiske behandlingen | funnet | `P/autosak/AutomatiskSaksbehandlingService.java:131-147` — steg 1b etter poeng |
| `@OPT-BEH-BEH-020` | Feil i vurderingen stopper ikke resten av behandlingen | funnet | `P/autosak/AutomatiskSaksbehandlingService.java:213-221` |
| `@OPT-BEH-BEH-020` | Saksbehandleren overstyrer vurderingen automatikken har satt | funnet | `P/regelverk/kvalifisering/KvalifiserKravelementV4Service.java:161-198`; `A/soknadsbehandling/features/KravlisteStudierCard/KravlisteStudierCard.tsx:220-231` |
| `@OPT-BEH-BEH-020` | Saksbehandleren overstyrer karakteren som automatikken har satt | funnet | `P/regelverk/kvalifisering/KvalifiserKravelementV4Service.java:166-170,188-198`; `A/soknadsbehandling/features/KravlisteStudierCard/KravlisteStudierCard.tsx:217` |
| `@OPT-BEH-BEH-020` | Kravelement som saksbehandleren vurderer, låses | funnet | `P/regelverk/kvalifisering/KvalifiserKravelementV4Service.java:184-198` — `la_staa` |
| `@OPT-BEH-BEH-020` | Saksbehandleren velger "la stå" på kravelementet | ikke funnet | API finnes (`P/regelverk/kvalifisering/KvalifiserKravelementV4Service.java:139-146,213-223`, `kvalifisering.graphqls:8`), men ikke i fs-admin: «laStaa», «la stå» bare i PoengberegningCard, ikke KravlisteStudierCard; ikke på `mahj/STEK-651` |
| `@OPT-BEH-BEH-020` | Kravelement som saksbehandleren bare ser på, vurderes automatisk igjen | funnet | `P/regelverk/kvalifisering/KvalifiserKravelementV4Service.java:184-199`; `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:112` |
| `@OPT-BEH-BEH-020` | Låst kravelement vurderes ikke på nytt | funnet | `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:112,178` |
| `@OPT-BEH-BEH-020` | Andre kravelementer vurderes selv om saksbehandleren har vurdert ett | funnet | `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:112,141-149,176-178` — låsen er per rad |
| `@OPT-BEH-BEH-020` | Nullstilt kravelement kan vurderes automatisk igjen | funnet | `P/regelverk/kvalifisering/KvalifiserKravelementV4Service.java:184-198`, `P/regelverk/kvalifisering/EffektivVerdi.java:17-25`; `A/soknadsbehandling/features/KravlisteStudierCard/KravlisteStudierCard.tsx:198-201,227-229` |
| `@OPT-BEH-BEH-020` | Unntak per grunnlag endres ikke | funnet | `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:170-179` — bare hovedraden |
| `@OPT-BEH-BEH-020` | Kravelementer for et grunnlag som fjernes, beholder vurderingen | funnet | `P/regelverk/kvalifisering/KvalifiseringKravelementV2OppdateringService.java:26,78-81,141,152` — `er_aktiv=false` |
| `@OPT-BEH-BEH-020` | Kravelementer for et nytt grunnlag vurderes | funnet | `P/regelverk/kvalifisering/KvalifiseringKravelementV2OppdateringService.java:78-86`; steg 0b/1b `AutomatiskSaksbehandlingService.java:128,140` |
| `@OPT-BEH-BEH-020` | Se at kravelementet er vurdert automatisk | funnet | `A/soknadsbehandling/features/KravlisteStudierCard/components/AutomatiskVurdering.tsx:19-28`; `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:167` |
| `@OPT-BEH-BEH-020` | Manuell endring fjerner markeringen som automatisk vurdert | funnet | `P/regelverk/kvalifisering/KvalifiserKravelementV4Service.java:160-162`; `AutomatiskVurdering.tsx:19` |
| `@OPT-BEH-BEH-020` | Endringsloggen viser at automatikken vurderte kravelementet | ikke funnet | `PM/V480__stopp_endringslogg.sql:1-28` fjerner audit-triggerne. Søkt «endringslogg», «audit», «hendelse» etter V480 |
| `@OPT-BEH-BEH-020` | Finne søkere som ikke er kvalifisert | funnet | `A/soknadsbehandling/features/SakOverviewView/components/SakFilter/SakFilter.tsx:110-115`; `sak.graphqls:385,543-547` |
| `@OPT-BEH-BEH-025` | Saken behandles helautomatisk når søkeren har ett vitnemål, og vitnemålet gir GSK | funnet | `P/autosak/SetteGrunnlagService.java:110-130`; `P/autosak/FerdigbehandlingService.java:82-100` (`erHelautomatisk`) |
| `@OPT-BEH-BEH-025` | Saken behandles ikke helautomatisk når ingen vitnemål gir GSK | funnet | `P/autosak/SetteGrunnlagService.java:128`; `P/autosak/FerdigbehandlingService.java:89`; flere dokumenter `P/autosak/SetteGrunnlagService.java:111` |
| `@OPT-BEH-BEH-025` | Saken behandles ikke helautomatisk før saksbehandleren har valgt vitnemål | funnet | `P/autosak/SetteGrunnlagService.java:111` — `FlereVitnemaalException`, tilbakerulling (`P/autosak/AutomatiskSaksbehandlingService.java:118-161`) |
| `@OPT-BEH-BEH-025` | Saken behandles ikke helautomatisk når søkeren har flere vitnemål, og bare ett gir GSK | funnet | `P/autosak/SetteGrunnlagService.java:111`; GSK settes likevel (`P/autosak/gsk/GskVedtakAutoService.java:86-92`) |
| `@OPT-BEH-BEH-025` | Saken er ferdig behandlet når den automatiske behandlingen har avgjort alt | funnet | `P/autosak/FerdigbehandlingService.java:58` — alt avgjort (:106-211) setter `statustype_kode = BEHANDLET` (`P/autosak/FerdigbehandlingService.java:65-68`) |
| `@OPT-BEH-BEH-025` | Saken er ferdig behandlet selv om kravelementene ga mangeltekst | funnet | `P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:204,207-214`; `P/autosak/FerdigbehandlingService.java:133-135,209`; `P/regelverk/poeng/PoengsumService.java:218`; `P/autosak/FerdigbehandlingService.java:65` |
| `@OPT-BEH-BEH-025` | Den automatiske behandlingen publiserer manglene når saken blir ferdig behandlet | ikke funnet | `P/autosak/FerdigbehandlingService.java:58-74` publiserer ingenting; bare `SakMangelService.java:297/319` (saksbehandlerens mutation). Søkt «publiser», «KAN_PUBLISERES» på main og branchene. min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-025` | Saksbehandleren ser hva den automatiske behandlingen har avgjort | ikke funnet | Vises for kravelementer, poeng, kvotespørsmål, poengsum (`A/soknadsbehandling/features/KravlisteStudierCard/utils/kravelementerUtils.ts:76-77`, `A/soknadsbehandling/features/PoengberegningCard/PoengberegningCardRow/PoengberegningCardRow.tsx:198-226`, `A/soknadsbehandling/features/KvoteplasseringCard/KvoteplasseringCard.tsx:109-151`, `A/soknadsbehandling/features/OppsummeringCard/OppsummeringsCardNy/OppsummeringsCardNy.tsx:205`), men ikke for grunnlaget (`A/soknadsbehandling/features/GrunnlagCard/GrunnlagCard.tsx:19-40`) og kvote uten spørsmål |
| `@OPT-BEH-BEH-025` | Saksbehandleren ser når den automatiske behandlingen avgjorde hvert steg | ikke funnet | (kontroll: endringsloggen får ingen nye rader etter V480; bare GSK-kortet viser tidspunkt, `GSKCard.tsx:352`) `A/soknadsbehandling/features/AuditLogCard/AuditLogItem/AuditLogItem.tsx:39` viser tidspunkt per endring, men endringsloggen fylles ikke etter V480; kortene viser ikke tidspunkt per steg |
| `@OPT-BEH-BEH-025` | Varselet om uenighet om GSK krever ikke at saksbehandleren gjør noe | funnet | `P/vgs/VgsDokumentGskKontrollService.java:58`; `A/soknadsbehandling/features/VitnemalsbehandlingSection/VitnemalsbehandlingSection.tsx:172-174`; status endres bare fra UBEHANDLET (`SettSaksdokumentErLestService.java:63-66`) |
| `@OPT-BEH-BEH-025` | Det som kan avgjøres, blir avgjort når <steg> ikke kan avgjøres | ikke funnet | (kontroll: raden «kravelementene» stemmer ikke) Poeng: `P/regelverk/poeng/PoengberegningService.java:162`; kvote: `P/autosak/KvotesporsmalAlgoritmeService.java:210-226`; kravelementer: isolert (`AutomatiskSaksbehandlingService.java:213-221`), men kvalifiseringen kjører likevel (:146) og setter `er_kvalifisert=false` — blir avgjort som ikke kvalifisert, ikke stående uavgjort |
| `@OPT-BEH-BEH-025` | Saken blir stående som ikke behandlet når et steg ikke kan avgjøres | funnet | `P/autosak/FerdigbehandlingService.java:106` — mangler poengsum, ingen BEHANDLET |
| `@OPT-BEH-BEH-025` | Opptaksforvalteren får varsel første gang en feil i regelverket stopper et steg | ikke funnet | Søkt «varsel», «regelverksfeil», «regelverksvarsel» på main og branchene; feilen logges (`PoengberegningService.java:165`) og står som merknad (:270) |
| `@OPT-BEH-BEH-025` | Opptaksforvalteren får varselet om feilen bare første gang | ikke funnet | Samme søk, ingen varsling |
| `@OPT-BEH-BEH-025` | <feil i regelverket> stopper <steg> | ikke funnet | Raden «to grunnlag passer like godt» stemmer ikke: `P/autosak/SetteGrunnlagService.java:291` velger deterministisk. Øvrige feil finnes (`P/regelverk/poeng/Poengberegningsfeil.java:4-16`, `KvotesporsmalAlgoritmeService.java:210`, `AldersberegningsdatoUtleder.java:20`), ikke lest i detalj |
| `@OPT-BEH-BEH-025` | Saksbehandleren ferdigbehandler saken etter å ha gjort resten | funnet | `A/soknadsbehandling/features/StageNavigation/components/MerkSomBehandletButton/MerkSomBehandletButton.tsx:43`; `P/saksbehandling/EndreStatusService.java:31-34` |
| `@OPT-BEH-BEH-025` | Saken blir ikke ferdig behandlet av seg selv når saksbehandleren har gjort resten | funnet | `P/regelverk/poeng/SettPoengService.java:192-198` — UBEHANDLET → UNDER_BEHANDLING; FB kalles bare fra autosaken (`AutomatiskSaksbehandlingService.java:225`) |
| `@OPT-BEH-BEH-026` | Opptaksforvalteren beregner på nytt for søknadsalternativene med <utvalg> | funnet | `P/saksbehandling/regelverksoppdatering/RegelverksoppdateringUtvalg.java:57-85`; `A/soknadsbehandling/features/RegelverksoppdateringButton/RegelverksoppdateringModal.tsx:46-48,81-84,136-170` — alle fire radene |
| `@OPT-BEH-BEH-026` | Saker med søknadsalternativer med andre regelverk, beregnes ikke på nytt | funnet | `P/saksbehandling/regelverksoppdatering/RegelverksoppdateringUtvalg.java:35-54` |
| `@OPT-BEH-BEH-026` | Saker med ett av regelverkene som er valgt, beregnes på nytt | funnet | `P/saksbehandling/regelverksoppdatering/RegelverksoppdateringUtvalg.java:85` — ELLER |
| `@OPT-BEH-BEH-026` | Opptaksforvalteren ser hvor mange saker som beregnes på nytt, før beregningen starter | funnet | `P/saksbehandling/regelverksoppdatering/RegelverksoppdateringService.java:81-91`; `A/soknadsbehandling/features/RegelverksoppdateringButton/RegelverksoppdateringModal.tsx:89-95,178-179` |
| `@OPT-BEH-BEH-026` | Regelverkene opptaksforvalteren kan velge, er regelverkene i opptaket | funnet | `A/soknadsbehandling/features/RegelverksoppdateringButton/RegelverksoppdateringButton.tsx:61`, `A/soknadsbehandling/features/RegelverksoppdateringButton/queries.ts:25-57`; `P/saksbehandling/regelverksoppdatering/RegelverksoppdateringService.java:120-159` |
| `@OPT-BEH-BEH-026` | Kravelementene og poengene beregnes på nytt i en sak den automatiske behandlingen har behandlet | funnet | `P/saksbehandling/regelverksoppdatering/RegelverksoppdateringKjoringService.java:245-247` → `P/autosak/AutomatiskSaksbehandlingService.java:194-203` |
| `@OPT-BEH-BEH-026` | Kravelementet saksbehandleren har vurdert, beregnes ikke på nytt | funnet | `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:112,178` |
| `@OPT-BEH-BEH-026` | Poengene saksbehandleren har satt, beregnes ikke på nytt | funnet | `P/regelverk/poeng/PoengService.java:54,70,170,219`; `AlgoritmepoengService.java:61`; `SettPoengService.java:135` |
| `@OPT-BEH-BEH-026` | Poengsummen regnes ut på nytt i en sak saksbehandleren har behandlet | funnet | `P/saksbehandling/regelverksoppdatering/RegelverksoppdateringKjoringService.java:249-251`; `P/saksbehandling/PropageringService.java:99-112` |
| `@OPT-BEH-BEH-026` | Kravelementet saksbehandleren har vurdert, er uendret | funnet | `P/saksbehandling/regelverksoppdatering/RegelverksoppdateringKjoringService.java:249`; `KvalifiseringKravelementV2OppdateringService.java:78-86` |
| `@OPT-BEH-BEH-026` | Saken saksbehandleren har behandlet, får taggen "Regelverk endret" | funnet | `P/saksbehandling/regelverksoppdatering/RegelverksoppdateringKjoringService.java:250`; `P/saksbehandling/regelverksoppdatering/RegelverkEndretTagger.java:15,20-56` |
| `@OPT-BEH-BEH-026` | Saken den automatiske behandlingen har behandlet, får ikke taggen "Regelverk endret" | funnet | `P/saksbehandling/regelverksoppdatering/RegelverksoppdateringKjoringService.java:245-247` |
| `@OPT-BEH-BEH-026` | Saksbehandleren finner sakene med taggen "Regelverk endret" | funnet | `A/soknadsbehandling/features/SakOverviewView/components/SakFilter/SakFilter.tsx:20,360-366` |
| `@OPT-BEH-BEH-026` | Saken er fortsatt ferdig behandlet etter at poengene er beregnet på nytt | funnet | `P/saksbehandling/regelverksoppdatering/RegelverksoppdateringKjoringService.java:232-253`; `AutomatiskSaksbehandlingService.java:189-193` |
| `@OPT-BEH-BEH-026` | En sak med behandlingsstatusen "<status>" beregnes ikke på nytt | funnet | `P/saksbehandling/regelverksoppdatering/RegelverksoppdateringUtvalg.java:38`; `P/saksbehandling/regelverksoppdatering/RegelverksoppdateringKjoringService.java:242-243` |
| `@OPT-BEH-BEH-026` | Søkeren ser den nye mangelteksten i en sak som er ferdig behandlet | usikker | min-kompetanse ikke sjekket; `P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:102-117`. Utvalget kan ikke være et kravelement (`P/saksbehandling/regelverksoppdatering/RegelverksoppdateringUtvalg.java:57-85`) |
| `@OPT-BEH-BEH-026` | Den automatiske mangelteksten slettes når søkeren blir kvalifisert etter beregningen | usikker | min-kompetanse ikke sjekket; `KvalifiseringOppdateringService.java:104-113` |
| `@OPT-BEH-BEH-026` | Opptaksforvalteren ser når beregningen er ferdig | funnet | `S/app/RegelverksoppdateringPoller.java:23-31`; `P/saksbehandling/regelverksoppdatering/RegelverksoppdateringKjoringService.java:189,282-304`; `A/soknadsbehandling/features/RegelverksoppdateringButton/RegelverksoppdateringStatus.tsx:36-54` |
| `@OPT-BEH-BEH-026` | Opptaksforvalteren kan ikke starte en ny beregning før den forrige er ferdig | funnet | `P/saksbehandling/regelverksoppdatering/RegelverksoppdateringService.java:65-72,77-79`; `V509__regelverksoppdatering.sql:80`; `A/soknadsbehandling/features/RegelverksoppdateringButton/RegelverksoppdateringModal.tsx:112-114` |
| `@OPT-BEH-BEH-026` | Opptaksforvalteren kan ikke beregne på nytt mens en plasstildeling kjører | ikke funnet | `P/saksbehandling/regelverksoppdatering/RegelverksoppdateringService.java:53-75` sjekker ikke plasstildelingen. Søkt «plasstildeling», «publiser» i regelverksoppdatering og fs-admin, og på `mahj/STEK-651` |
| `@OPT-BEH-BEH-026` | Saksloggen viser at den automatiske behandlingen endret saken, og hvem som startet beregningen | ikke funnet | `V480__stopp_endringslogg.sql:1-28`; `V509__regelverksoppdatering.sql:9` lagrer ikke hvem. Søkt «sakslogg», «startet_av», «bestilt_av» |
| `@OPT-BEH-BEH-026` | En plasstildeling som er kjørt, endres ikke | funnet | `P/saksbehandling/regelverksoppdatering/RegelverksoppdateringKjoringService.java:232-253` — skriver bare sakstabellene |
| `@OPT-BEH-BEH-026` | Neste plasstildeling bruker det som er beregnet på nytt | funnet | `P/plasstildeling/service/KvotesumService.java:151,231,247-250` |
| `@OPT-BEH-BEH-026` | Opptaksforvalteren kan ikke beregne på nytt etter at resultatet av siste plasstildelingsrunde er publisert | ikke funnet | `P/saksbehandling/regelverksoppdatering/RegelverksoppdateringService.java:105-151` sjekker ikke publisering. Søkt «publiser», «PUBLISERING_RESULTAT» |
| `@OPT-BEH-BEH-027` | Delkravene for <reform> | funnet | `P/autosak/kontrollmotor/Kravelementer.java:1263-1272` — R94 går til `gskR94` (`P/autosak/kontrollmotor/Kravelementer.java:1278-1285`), ellers KL-delkravene |
| `@OPT-BEH-BEH-027` | Vitnemål fra Kunnskapsløftet uten <delkrav> får påstanden ikke GSK | funnet | `P/autosak/kontrollmotor/Kravelementer.java:1267-1271` — delkravene AND-es; `P/autosak/gsk/GskKonklusjonEvaluator.java:97` gir ikke GSK |
| `@OPT-BEH-BEH-027` | Vitnemål fra Reform 94 uten <delkrav> får påstanden ikke GSK | funnet | `P/autosak/kontrollmotor/Kravelementer.java:1278-1285` — R94-delkravene AND-es; `P/autosak/gsk/GskKonklusjonEvaluator.java:97` |
| `@OPT-BEH-BEH-027` | Matematikkravet er oppfylt med <alternativ> | funnet | `P/autosak/kontrollmotor/Kravelementer.java:1112-1132`, `P/autosak/kontrollmotor/Kravelementer.java:1134-1136`, `P/autosak/kontrollmotor/Kravelementer.java:647-649`, `P/autosak/kontrollmotor/Kravelementer.java:1141-1171`, `P/autosak/kontrollmotor/Kravelementer.java:461-490` — alle fem radene |
| `@OPT-BEH-BEH-027` | Påbygging med matematikk <fag> på vg1 | funnet | `P/autosak/kontrollmotor/Kravelementer.java:1143-1170` — 1P-Y og 1T-Y på vg1 med vg3-faget |
| `@OPT-BEH-BEH-027` | Matematikk for yrkesfag på vg1 alene oppfyller ikke matematikkravet | funnet | `P/autosak/kontrollmotor/Kravelementer.java:1112-1132`, `P/autosak/kontrollmotor/Kravelementer.java:1170` — påbygging krever vg3-faget |
| `@OPT-BEH-BEH-027` | Naturfagkravet er oppfylt med <alternativ> | funnet | `P/autosak/kontrollmotor/Kravelementer.java:1174-1184`, settene `P/autosak/kontrollmotor/Kravelementer.java:349-374` |
| `@OPT-BEH-BEH-027` | Vg1 og vg3 fra ulike planer oppfyller ikke naturfagkravet | funnet | `P/autosak/kontrollmotor/Kravelementer.java:1181-1183` — vg1 og vg3 i samme plan |
| `@OPT-BEH-BEH-027` | Samfunnsfagkravet er oppfylt med <fagkode> | funnet | `P/autosak/kontrollmotor/Kravelementer.java:1187-1189` — SAF1001, SAF1002, SAK1001, SAK1002 |
| `@OPT-BEH-BEH-027` | Engelskkravet er oppfylt med <fagkode> | funnet | `P/autosak/kontrollmotor/Kravelementer.java:1192-1208` — alle 13 fagkodene |
| `@OPT-BEH-BEH-027` | Standard norsk med <variant> | funnet | `P/autosak/kontrollmotor/Kravelementer.java:869-871`, `P/autosak/kontrollmotor/Kravelementer.java:824-826`, `P/autosak/kontrollmotor/Kravelementer.java:845-861`, `P/autosak/kontrollmotor/Kravelementer.java:864-866` — alle seks radene |
| `@OPT-BEH-BEH-027` | Merknaden VMM25 med <fag> gir ikke standard norsk | funnet | `P/autosak/kontrollmotor/Kravelementer.java:846-848` — VMM25 stenger grenene |
| `@OPT-BEH-BEH-027` | NOR1049 som privatist med merknaden VMM25 erstatter norsk hovedmål | funnet | `P/autosak/kontrollmotor/Kravelementer.java:833-838` — NOR1049 privatist + VMM25 dekker hovedmålet |
| `@OPT-BEH-BEH-027` | Norskkravet er oppfylt med <variant> | funnet | `P/autosak/kontrollmotor/Kravelementer.java:884-891`, `P/autosak/kontrollmotor/Kravelementer.java:778-782`, `P/autosak/kontrollmotor/Kravelementer.java:819-821`, `P/autosak/kontrollmotor/Kravelementer.java:879-881` |
| `@OPT-BEH-BEH-027` | Standard norsk krever historie etter standard plan (<fagkode>) | funnet | `P/autosak/kontrollmotor/Kravelementer.java:1237-1245` — standard norsk && HIS1002/1010/1003/1011 |
| `@OPT-BEH-BEH-027` | Standard norsk med historie etter samisk plan oppfyller ikke kravet | funnet | `P/autosak/kontrollmotor/Kravelementer.java:1238-1243` — HIS1005 ikke i standard-historien |
| `@OPT-BEH-BEH-027` | <variant> godtar alle historiefagene | funnet | `P/autosak/kontrollmotor/Kravelementer.java:1222-1235` — `harSfHistorie` med alle ti kodene |
| `@OPT-BEH-BEH-027` | Delkravet for <delkrav> er oppfylt med <alternativ> | funnet | `P/autosak/kontrollmotor/Kravelementer.java:1288-1410` — alle 15 radene |
| `@OPT-BEH-BEH-027` | Norsk for tegnspråklige alene oppfyller ikke norskkravet | funnet | `P/autosak/kontrollmotor/Kravelementer.java:1405` — VG4122 krever VG4190 |
| `@OPT-BEH-BEH-027` | Løpet settes sammen av programområdene etter nivå | funnet | `P/vgs/VgsDokumentVitnemaalMapper.java:112-118` — sortert på nivåkode, slått sammen med `_` |
| `@OPT-BEH-BEH-027` | Påstanden er GSK med grunnlagskoden for løpet | funnet | `P/autosak/gsk/GskKonklusjonEvaluator.java:96-98`, `P/autosak/gsk/GskKonklusjonEvaluator.java:120-121` — grunnlagstype fra `vgs_loep` |
| `@OPT-BEH-BEH-027` | Grunnlagskoden gis selv om påstanden ikke er GSK | funnet | `P/autosak/gsk/GskKonklusjonEvaluator.java:96-98` og `GskPaastandService.java:38` — lagres uansett |
| `@OPT-BEH-BEH-027` | Ukjent løp | funnet | `P/autosak/gsk/GskKonklusjonEvaluator.java:96-97` — `loep == null` gir ikke GSK |
| `@OPT-BEH-BEH-027` | Påbyggingsruten PBPBY4 gir grunnlagskoden KLF | funnet | `P/autosak/gsk/GskKonklusjonEvaluator.java:44-49`, `P/autosak/gsk/GskKonklusjonEvaluator.java:117-118` — KLF før løpets grunnlagstype |
| `@OPT-BEH-BEH-027` | Påbyggingsruten PBPBY4 på et ukjent løp | funnet | `P/autosak/gsk/GskKonklusjonEvaluator.java:96-97` — løpet uten tillegget finnes ikke |
| `@OPT-BEH-BEH-027` | Løp fra <reform> uten grunnlagskode gir grunnlagskoden <grunnlagskode> | funnet | `P/autosak/gsk/GskKonklusjonEvaluator.java:123-131` — RFA (R94) og KLY (KL) |
| `@OPT-BEH-BEH-027` | Løp og vitnemål fra ulike reformer | funnet | `P/autosak/gsk/GskKonklusjonEvaluator.java:123-125` — ulik reformkode gir null |
| `@OPT-BEH-BEH-028` | Alderspoeng for søkerens alder | funnet | `P/regelverk/poeng/Alderspoeng.java:31-90` — alle åtte radene; `P/regelverk/poeng/PoengService.java:94-107` |
| `@OPT-BEH-BEH-028` | Alderspoengene viser hvilken alder de er regnet ut for | funnet | `P/regelverk/poeng/PoengService.java:103-105`, `P/regelverk/poeng/Alderspoeng.java:99-101`; `A/soknadsbehandling/features/PoengberegningCard/PoengberegningCardRow/PoengberegningCardRow.tsx:198-222` |
| `@OPT-BEH-BEH-028` | Standarddatoen brukes når datoen for aldersberegning ikke er satt | funnet | `P/saksbehandling/AldersberegningsdatoUtleder.java:43-56`; `P/opptak/AldersberegningsdatoDefault.java:19-21` |
| `@OPT-BEH-BEH-028` | Kjønnspoeng for søkerens kjønn | funnet | `P/regelverk/poeng/Kjonnspoeng.java:28-30`, `P/regelverk/poeng/KjonnspoengAlgoritme.java:11-19` — alle sju radene; `P/regelverk/poeng/PoengService.java:291-302` |
| `@OPT-BEH-BEH-028` | Kjønnspoengene viser hvilket kjønn de er regnet ut for | funnet | `P/regelverk/poeng/PoengService.java:117-119`; `A/soknadsbehandling/features/PoengberegningCard/PoengberegningCardRow/PoengberegningCardRow.tsx:198-222` |
| `@OPT-BEH-BEH-028` | Poeng for høyere utdanning | usikker | `P/regelverk/poeng/HoyereUtdanningspoeng.java:12-17` — alle seks radene; men HOY_ALG1 mangler i kodeverket |
| `@OPT-BEH-BEH-028` | Poengene for høyere utdanning viser hvor mange studiepoeng de er regnet ut for | usikker | `P/regelverk/poeng/PoengService.java:131-133`; HOY_ALG1 mangler i kodeverket |
| `@OPT-BEH-BEH-028` | Søker uten resultater fra høyere utdanning får 0 poeng | usikker | `P/regelverk/poeng/PoengService.java:279` — `coalesce(...,0)`; HOY_ALG1 mangler |
| `@OPT-BEH-BEH-028` | Bare beståtte emner teller | ikke funnet | Kontrollen: ingen filter på bestått, uavhengig av HOY_ALG1 (`P/regelverk/poeng/PoengService.java:278-289`, `P/vitnemalsportalen/ElmoMapper.java:161-237`). Finneren: `P/regelverk/poeng/PoengService.java:278-289` filtrerer ikke på bestått; importen (`P/vitnemalsportalen/ElmoMapper.java:161-200`) heller ikke; HOY_ALG1 mangler |
| `@OPT-BEH-BEH-028` | Fagskolepoeng teller ikke | usikker | `P/regelverk/poeng/PoengService.java:285-286` — bare NKR 6-8; HOY_ALG1 mangler |
| `@OPT-BEH-BEH-028` | Innpassede emner telles bare én gang | usikker | `P/regelverk/poeng/PoengService.java:287,33`; HOY_ALG1 mangler |
| `@OPT-BEH-BEH-028` | Innpassede emner telles med studiepoengene fra lærestedet der de ble tatt | usikker | `P/regelverk/poeng/PoengService.java:287`; HOY_ALG1 mangler |
| `@OPT-BEH-BEH-028` | Studiepoengene telles når poengene regnes ut | usikker | `P/regelverk/poeng/PoengService.java:278-289`; HOY_ALG1 mangler |
| `@OPT-BEH-BEH-028` | Automatikken velger grunnlaget | funnet | `P/autosak/AutomatiskSaksbehandlingService.java:123-129`; `P/saksbehandling/PropageringService.java:109`; `P/regelverk/poeng/AutomatiskPoengberegningService.java:121` |
| `@OPT-BEH-BEH-028` | Saksbehandleren velger grunnlaget | funnet | `P/saksbehandling/LeggTilGrunnlagService.java:44-48` → `P/saksbehandling/PropageringService.java:109` → `P/regelverk/poeng/AlgoritmepoengService.java:34-48` |
| `@OPT-BEH-BEH-028` | Saksbehandleren får kjønnspoengene grunnlaget gir | funnet | `P/regelverk/poeng/AlgoritmepoengService.java:85-86` → `P/regelverk/poeng/PoengService.java:112-121` |
| `@OPT-BEH-BEH-028` | Poengene for grunnlaget som er fjernet, vises ikke lenger | funnet | `FjernGrunnlagService.java:38-42`; `P/saksbehandling/PoengRadOppdateringService.java:95-102,140-142`; `sak.graphqls:96-98` |
| `@OPT-BEH-BEH-028` | Poengene regnes ut på nytt når saksbehandleren endrer grunnlaget | funnet | `PoengRadOppdateringService.java:104-113`; `P/saksbehandling/PropageringService.java:109`, `P/regelverk/poeng/AlgoritmepoengService.java:34-48` |
| `@OPT-BEH-BEH-028` | Poengene regnes ikke ut på nytt av seg selv når datoen for aldersberegning endres | funnet | Algoritmepoeng bare fra `P/saksbehandling/PropageringService.java:137`, `AutomatiskPoengberegningService.java:67`, `RegelverksoppdateringKjoringService.java:246`; ingenting i `opptak/opptak/` |
| `@OPT-BEH-BEH-028` | Søker uten elektronisk vitnemål får tilleggspoeng | funnet | `P/regelverk/poeng/AlgoritmepoengService.java:34-48,42-44`; `P/regelverk/poeng/PoengService.java:263-274` |
| `@OPT-BEH-BEH-028` | Poengene er satt av saksbehandleren og står | funnet | `P/regelverk/poeng/AlgoritmepoengService.java:50-62`; `P/regelverk/poeng/PoengService.java:47-56` |
| `@OPT-BEH-BEH-028` | Saksbehandleren overstyrer et alderspoeng som er regnet ut automatisk | funnet | `P/regelverk/poeng/SettPoengService.java:104`; `P/regelverk/poeng/AlgoritmepoengService.java:61`, `P/regelverk/poeng/PoengService.java:54` |
| `@OPT-BEH-BEH-028` | Poengene som er regnet ut automatisk, er merket som det | funnet | `P/regelverk/poeng/PoengService.java:51`; `A/soknadsbehandling/features/PoengberegningCard/PoengberegningCardRow/PoengberegningCardRow.tsx:198` |
| `@OPT-BEH-BEH-028` | Poengene er ikke merket som automatiske etter at saksbehandleren har endret dem | funnet | `P/regelverk/poeng/SettPoengService.java:136,151`; `A/soknadsbehandling/features/PoengberegningCard/PoengberegningCardRow/PoengberegningCardRow.tsx:198` |
| `@OPT-BEH-BEH-028` | Poengtypen har en algoritme som ikke kan regnes ut | funnet | `P/regelverk/poeng/AlgoritmepoengService.java:89-91` → `P/regelverk/poeng/PoengService.java:142-145,63-72`; `A/soknadsbehandling/features/PoengberegningCard/PoengberegningCardRow/PoengberegningCardRow.tsx:198-222` |
| `@OPT-BEH-BEH-028` | Automatikken fortsetter med de andre poengene når en algoritme ikke kan regnes ut | usikker | Vitnemålspoeng regnes, autosak fortsetter (`AutomatiskSaksbehandlingService.java:134-151`), saken blir ikke behandlet (`FerdigbehandlingService.java:103-106`); men autosak setter aldri UNDER_BEHANDLING, så saken blir stående med statusen den hadde |
| `@OPT-BEH-BEH-029` | Ny sak er Ikke behandlet | funnet | `P/saksbehandling/BehandlertildelingService.java:459`; `V291__saksbehandling_skjema.sql:75` — `DEFAULT 'UBEHANDLET'` |
| `@OPT-BEH-BEH-029` | Endre behandlingsstatus fra <fra> til <til> | funnet | `P/saksbehandling/EndreStatusService.java:31-34` — alle fire radene; `A/soknadsbehandling/features/PersonaliaCard/PersonaliaCard.tsx:219-227` |
| `@OPT-BEH-BEH-029` | Sette saken til Behandlet fra <fra> når saken har <innhold> | funnet | `P/saksbehandling/EndreStatusService.java:31-34`; `A/soknadsbehandling/features/StageNavigation/components/MerkSomBehandletButton/MerkSomBehandletButton.tsx:41-43` |
| `@OPT-BEH-BEH-029` | Saken kan ikke bli Behandlet uten mangel eller grunnlag | ikke funnet | `EndreStatusService.java:22-41` sjekker ikke mangel eller grunnlag; `MerkSomBehandletButton.tsx:41` sperrer bare når statusen alt er Behandlet. Søkt «minst én mangel», «kanSettesTilBehandlet» på main og branchene |
| `@OPT-BEH-BEH-029` | Saken blir Under behandling når saksbehandleren <handling> | ikke funnet | Radene «Behandlet → endrer kvalifisering/poeng/kvoteplassering» stemmer ikke: `P/regelverk/poeng/SettPoengService.java:198`, `KvalifiserKravelementV4Service.java:79`, `EndreKvoteplasseringService.java:126` flipper bare fra UBEHANDLET. «Registrerer et grunnlag»: ingen flipp i LeggTilGrunnlagService |
| `@OPT-BEH-BEH-029` | Behandlingsstatusen endres ikke når saksbehandleren <handling> | funnet | `P/saksbehandling/MerknadService.java:66-68`; TilordningService skriver ikke status |
| `@OPT-BEH-BEH-029` | Å markere et dokument som lest endrer ikke statusen på en sak som er Behandlet | funnet | `P/saksbehandling/SettSaksdokumentErLestService.java:63-66` |
| `@OPT-BEH-BEH-029` | Behandlingsstatusen <status> endres ikke når saksbehandleren åpner saken | funnet | Status skrives bare i mutations; lesing skriver ingenting |
| `@OPT-BEH-BEH-029` | Ny dokumentasjon endrer ikke behandlingsstatusen | funnet | `P/vgs/VgsLagringService.java:71`; `LagreVitnemalUtregningService.java:402`. Merk: annullert vitnemål flytter BEHANDLET → UNDER_BEHANDLING (`P/saksbehandling/AnnullertVitnemaalService.java:103-109`) |
| `@OPT-BEH-BEH-029` | Saksloggen viser endring av behandlingsstatus når <årsak> | ikke funnet | Kontrollen: audit-triggerne er droppet i `V480__stopp_endringslogg.sql:14-44`, `sak.graphqls:196`; ingen annen logging av statusendringer. Finneren: audit-trigger `V291__saksbehandling_skjema.sql:1489`, `A/soknadsbehandling/features/AuditLogCard/AuditLogItem/AuditLogItem.tsx:39-44` viser tid og `intensjon`, men ingen kode setter `saksbehandling.intensjon`, og årsaken vises ikke. (Endringsloggen er stoppet i V480, se andre krav) |
| `@OPT-BEH-BEH-030` | Resultatene hentes når søkeren sender inn søknaden | funnet | `P/soknad/StudiekurvService.java:952` — SOKNAD-hendelse; `S/app/SoknadshendelseJobb.java:314-321,129-138` — tildeler og henter vitnemål fra KREG (`S/app/SoknadshendelseJobb.java:396-399`) |
| `@OPT-BEH-BEH-030` | Resultatene hentes når søknaden registreres på vegne av søkeren | funnet | `P/soknad/StudiekurvService.java:826-827` — samme `leverSoknadskladd`; import i `S/app/SoknadshendelseJobb.java:129-138` |
| `@OPT-BEH-BEH-030` | Resultatene hentes når en endring av søknaden gir en ny sak | funnet | `P/soknad/StudiekurvService.java:1062-1067` — SOKNAD-hendelse ved endring; `S/app/SoknadshendelseJobb.java:314-321`; `P/vgs/VgsLagringService.java:49-56` |
| `@OPT-BEH-BEH-030` | Resultatene hentes først når saken er opprettet | funnet | `S/app/SoknadshendelseJobb.java:301-308` — uten behandlertildelingsregel utsettes hendelsen; bare tildelte får import (`S/app/SoknadshendelseJobb.java:320-321`) |
| `@OPT-BEH-BEH-030` | Resultatene hentes med D-nummer når søkeren ikke har fødselsnummer | ikke funnet | `P/vgs/HentVgsVitnemaalService.java:101-114` slår bare opp FØDSELSNUMMER. Søkt «D-NUMMER», «dnummer», «d_nummer» på main og branchene: ingen treff (bare `TidligereGskKonklusjonService.java:45`) |
| `@OPT-BEH-BEH-030` | Det importerte vitnemålet har opplysningene saksbehandlingen trenger | funnet | `P/vgs/KregVgsParser.java:96-130`; `P/vgs/VgsLagringService.java:71-101` |
| `@OPT-BEH-BEH-030` | Søker med flere vitnemål får alle importert | funnet | `P/vgs/KregVgsParser.java:70-76`; `P/vgs/HentVgsVitnemaalService.java:173-174` |
| `@OPT-BEH-BEH-030` | Vitnemål som er importert fra før, importeres ikke på nytt | funnet | `P/vgs/VgsLagringService.java:49-56` — `FANTES_FRA_FOER` |
| `@OPT-BEH-BEH-030` | Annullert vitnemål importeres som annullert | funnet | `P/vgs/KregVgsParser.java:107`; `P/vgs/VgsLagringService.java:84,97` |
| `@OPT-BEH-BEH-030` | Vitnemål som annulleres etter importen, blir annullert | funnet | `P/vgs/VgsLagringService.java:53-63` — `ANNULLERING_OPPDATERT` |
| `@OPT-BEH-BEH-030` | Vitnemålet blir stående som annullert når KREG opphever annulleringen | funnet | `P/vgs/VgsLagringService.java:53-56` — bare overgangen til annullert |
| `@OPT-BEH-BEH-030` | Søker uten fødselsnummer og D-nummer får ingen resultater importert | funnet | `P/vgs/HentVgsVitnemaalService.java:112-114`; `S/app/SoknadshendelseJobb.java:396-418` |
| `@OPT-BEH-BEH-030` | Resultatene hentes når KREG svarer igjen | ikke funnet | `S/app/SoknadshendelseJobb.java:416-417` — feilen logges, hendelsen er kvittert (`S/app/SoknadshendelseJobb.java:365`), ingen ny henting. Søkt «retry», «backoff», «@Retry», «maxRetries» på main og branchene |
| `@OPT-BEH-BEH-030` | Søkeren får vitnemålet etter at søknaden er levert | ikke funnet | Ingen jobb for aktive søkere blant `@Scheduled` i opptak; `HentVgsVitnemaalService` kalles bare fra `S/app/SoknadshendelseJobb.java:398`. Søkt også i MR !6629 og branchene |
| `@OPT-BEH-BEH-030` | Vitnemålene hentes én gang for søkeren med søknader i flere opptak | ikke funnet | Ingen importjobb for aktive søkere |
| `@OPT-BEH-BEH-030` | Vitnemålene hentes ikke for søkeren som ikke er aktiv | ikke funnet | Ingen importjobb for aktive søkere |
| `@OPT-BEH-BEH-030` | Vitnemålet annulleres og erstattes av et nytt etter at opptakssystemet har behandlet søknaden | ikke funnet | Bare når søknaden endres (`StudiekurvService.java:1062-1067`); ingen jobb |
| `@OPT-BEH-BEH-030` | Vitnemålet annulleres uten at det kommer et nytt, etter at opptakssystemet har behandlet søknaden | ikke funnet | Samme som over |
| `@OPT-BEH-BEH-031` | Poengsum for grunnlaget kvoten er koblet til | funnet | `P/regelverk/poeng/PoengsumService.java:120-134,147-186` — `sak_poengsum` per gyldig kvote og grunnlag |
| `@OPT-BEH-BEH-031` | Grunnlag kvoten ikke er koblet til, gir ingen poengsum i kvoten | funnet | `P/regelverk/poeng/PoengberegningService.java:141`; `P/regelverk/poeng/PoengsumService.java:120-127` |
| `@OPT-BEH-BEH-031` | Kvote søkeren ikke er plassert i, gir ingen poengsum | funnet | `P/regelverk/poeng/PoengsumService.java:67-75` — bare `skal_kvoteplasseres` og `er_aktiv` |
| `@OPT-BEH-BEH-031` | Poengsummen følger poengformelen til kvotetypen | funnet | `P/regelverk/poeng/PoengberegningService.java:315-341,366-384,141-161` |
| `@OPT-BEH-BEH-031` | Grunnlag søkeren ikke er kvalifisert på, gir ingen poengsum | funnet | `P/regelverk/poeng/PoengsumService.java:136-138,166-169,267-277` |
| `@OPT-BEH-BEH-031` | Poengsummen regnes ut på nytt når <endring> | funnet | `P/saksbehandling/PropageringService.java:53-55,62-64,72-77,99-112` — alle fire radene (grunnlag, poeng, kravelement, kvoteplassering) |
| `@OPT-BEH-BEH-031` | Uendret poengsum gir ikke nytt innslag i endringsloggen | funnet | `P/regelverk/poeng/PoengsumService.java:61-66,394-430` — skriver bare endrede rader. Merk: endringsloggen fylles ikke lenger (`V480__stopp_endringslogg.sql:1-28`) |
| `@OPT-BEH-BEH-031` | Poengsummen i de andre kvotene regnes ut når én kvote feiler | funnet | `P/regelverk/poeng/PoengberegningService.java:162-188` |
| `@OPT-BEH-BEH-031` | Saksbehandleren ser hvorfor poengsummen ikke kan regnes ut | funnet | `P/regelverk/poeng/PoengberegningService.java:177-184,194-203`; `P/regelverk/poeng/PoengsumService.java:188-189,279-315` (`sak_poengsum_merknad`); `A/soknadsbehandling/features/OppsummeringCard/OppsummeringsCardNy/OppsummeringsCardNy.tsx:65-75,203-211,322`, `A/soknadsbehandling/features/OppsummeringCard/components/PoengsumMerknader/PoengsumMerknader.tsx:16-31` |
| `@OPT-BEH-BEH-031` | Poengsummene fjernes når søkeren ikke er plassert i noen kvote | funnet | `P/regelverk/poeng/PoengsumService.java:77-80,591-600` |
| `@OPT-BEH-BEH-031` | Poengsummene fjernes når saken ikke har noe grunnlag | funnet | `P/regelverk/poeng/PoengsumService.java:96-105` |
| `@OPT-BEH-BEH-031` | Den høyeste poengsummen i kvoten vises | funnet | `P/saksbehandling/KvotesumV2Service.java:175-210`; `A/soknadsbehandling/features/OppsummeringCard/OppsummeringsCardNy/OppsummeringsCardNy.tsx:57-64,192-201,318`, `A/soknadsbehandling/features/OppsummeringCard/components/PoengTable/PoengTable.tsx:51-66` |
| `@OPT-BEH-BEH-031` | Søknadsalternativ søkeren ikke er kvalifisert til, viser ingen poengsum | funnet | `KvotesumV2Service.java:149,154-157` |
| `@OPT-BEH-BEH-032` | Den nye saken behandles automatisk når saksbehandlertildelingen har opprettet den | ikke funnet | `S/app/SoknadshendelseJobb.java:396-412` gjør bare import og GSK-konklusjon; `behandleSakAutomatisk` kalles bare fra mutasjonen. ikke funnet på main — finnes i MR !6629 (åpen, fs-plattform, solov/autosak-start-etter-import): `SoknadshendelseJobb.java` (`startAutomatiskBehandling`) og `AutomatiskBehandlingEtterImportService.java` |
| `@OPT-BEH-BEH-032` | Saken behandles automatisk når importen har hentet søkerens vitnemål | ikke funnet | Ingen import for aktive søkere (bare `S/app/SoknadshendelseJobb.java:398`). Søkt «nye vitnem», «aktive søkere», «kreg» på main, MR !6629 og branchene |
| `@OPT-BEH-BEH-032` | Saken behandles ikke helautomatisk når importen henter to vitnemål for søkeren | ikke funnet | Ingen import for aktive søkere. `P/autosak/SetteGrunnlagService.java:111-114` og `P/autosak/FerdigbehandlingService.java:98-100` i manuell start; MR !6629 behandler ikke `FLERE_VITNEMAAL` i det hele tatt |
| `@OPT-BEH-BEH-032` | Saken med behandlingsstatusen <status> behandles ikke automatisk når importen henter søkerens vitnemål | ikke funnet | Importen i `Når` finnes ikke; utfallet er bare sant fordi ingenting starter av seg selv (endret fra usikker av kontrollen). ikke funnet på main — finnes i MR !6629 (åpen, fs-plattform, solov/autosak-start-etter-import): `AutomatiskBehandlingEtterImportService.vurder` gir `BEHANDLINGEN_ER_BEGYNT` når saken ikke er UBEHANDLET, bare i tildelingsløpet |
| `@OPT-BEH-BEH-032` | Saken behandles ikke automatisk på nytt når det kommer et nytt vitnemål | ikke funnet | Som over (endret fra usikker av kontrollen). ikke funnet på main — finnes i MR !6629 (åpen, fs-plattform, solov/autosak-start-etter-import): vakten `BEHANDLET_AUTOMATISK` i `AutomatiskBehandlingEtterImportService.vurder`; main setter bare flagget (`P/autosak/AutomatiskSaksbehandlingService.java:113-118`) |
| `@OPT-BEH-BEH-032` | Saksbehandleren starter bare behandlingen for saker hos organisasjonen | funnet | `P/autosak/AutomatiskSaksbehandlingService.java:160-166` — `UkjentSakException` under RLS; `V501__tilbyderoppslag_per_sak.sql:37-52`, `V291__saksbehandling_skjema.sql:1550-1558`. Merk: saksbehandler ved tilbyderen ser saken (V501:43-52) |
| `@OPT-BEH-BEH-032` | Grunnlaget saksbehandleren har valgt, står når behandlingen startes | funnet | `P/autosak/SetteGrunnlagService.java:100-106,227-233`; `P/autosak/FerdigbehandlingService.java:83-90` |
| `@OPT-BEH-BEH-032` | Saken som er ferdig behandlet automatisk, viser at den er behandlet automatisk | ikke funnet | `status_automatisk_behandlet` settes (`P/autosak/AutomatiskSaksbehandlingService.java:113-118`), men er ikke i GraphQL-skjemaet og vises ikke i fs-admin (søkt «automatisk_behandlet», «automatiskBehandlet», «behandlet automatisk»; også branchene) |
| `@OPT-BEH-BEH-032` | Saken viser at den ikke kunne behandles automatisk fordi søkeren ikke har vitnemål | ikke funnet | `INGEN_VITNEMAAL` bare internt (`P/autosak/gsk/GskVedtakAutoService.java:82`, logget `AutomatiskSaksbehandlingService.java:104-109`); ikke lagret på saken, ikke vist i fs-admin |
| `@OPT-BEH-BEH-036` | Saken får en automatisk mangeltekst når <vurdert av> vurderer at et kravelement ikke er oppfylt | funnet | `P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:104,204-214` — begge radene via propagerFraKravelement (`AutomatiskSaksbehandlingService.java:146`, `KvalifiserKravelementV4Service.java:63`) |
| `@OPT-BEH-BEH-036` | Saken får ikke mangeltekst når søkeren er kvalifisert på en annen kravliste | funnet | `P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:104-113`; `P/regelverk/kvalifisering/ManglendeKravBeregner.java:72-74` |
| `@OPT-BEH-BEH-036` | Saken får mangeltekster i alle kravlistene når søkeren ikke er kvalifisert på noen | funnet | `P/regelverk/kvalifisering/ManglendeKravBeregner.java:54-60,75-80` |
| `@OPT-BEH-BEH-036` | Mangelteksten viser kravelementene som ikke er oppfylt, ordnet etter kravlistene | ikke funnet | `P/regelverk/kvalifisering/ManglendeKravTekstService.java:103-126` — kravlistene vises ikke med navn («Ett av følgende:»), og en liste med ett manglende element slås sammen (`kombiner`, :82-89) — kontroll: kravlistene får aldri navn (`P/regelverk/kvalifisering/ManglendeKravBeregner.java:98-99`, `P/regelverk/kvalifisering/ManglendeKravTekstService.java:122-124`), så «Fysikk 2» står ikke under kravlisten slik `Så` sier; kommentaren i kravet sier «avgjøres i designet» |
| `@OPT-BEH-BEH-036` | De automatiske mangeltekstene slettes når <vurdert av> vurderer at søkeren er kvalifisert | funnet | `P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:113,212-214` |
| `@OPT-BEH-BEH-036` | Saksbehandleren ser de automatiske mangeltekstene sammen med de registrerte manglene | ikke funnet | `A/soknadsbehandling/features/SakDrawer/components/ManglerCard/queries.ts:3-23` henter bare `Sak.mangler` (`sak_mangel`); `manglende_krav_*` finnes ikke i fs-admin. Søkt «manglendeKrav», «Soknadsmangel» |
| `@OPT-BEH-BEH-036` | Søkeren ser de automatiske mangeltekstene når saken er ferdig behandlet | ikke funnet | `P/autosak/FerdigbehandlingService.java:58-74` setter ikke `status_kan_publiseres`; viewet krever det (`PM/V514__behandlingsstatus_fjern_ferdig_behandlet.sql:176`); bare `SakMangelService.java:319`. min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-036` | Søkeren ser ikke de automatiske mangeltekstene mens saken er under behandling | usikker | `PM/V514__behandlingsstatus_fjern_ferdig_behandlet.sql:176`, `P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:207-211` — upublisert når den lages; men viewet tar med UNDER_BEHANDLING (`PM/V514__behandlingsstatus_fjern_ferdig_behandlet.sql:20`), så en publisert tekst vises. min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-036` | Søkeren ser mangeltekstene per søknadsalternativ | usikker | `PM/V514__behandlingsstatus_fjern_ferdig_behandlet.sql:141-189`; `sak.graphqls:927`. min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-036` | Søkeren ser ikke mangelteksten når søknadsalternativet er fjernet | usikker | `PM/V514__behandlingsstatus_fjern_ferdig_behandlet.sql:46-50` — `sa.slettet IS NULL`. min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-036` | Saksbehandleren kan ikke endre en automatisk mangeltekst | usikker | Teksten vises ikke i fs-admin i det hele tatt, så ingen knapper — men det er ikke det kravet beskriver |
| `@OPT-BEH-BEH-036` | Opptaksforvalteren merker mangelkoden for generell studiekompetanse som fullføres i vår | funnet | `P/regelverk/MangeltypeService.java:52,96`; `A/regelverk/features/Mangelkoder/MangelkodeDetails/MangelkodeDetails.tsx:402-413` |
| `@OPT-BEH-BEH-036` | Bare én mangelkode i regelverkssamlingen kan være merket for generell studiekompetanse som fullføres i vår | funnet | `P/regelverk/MangeltypeService.java:128-140` |
| `@OPT-BEH-BEH-036` | Mangelkoden kan ikke merkes når den <avvik> | funnet | `P/regelverk/MangeltypeService.java:123-127` — begge radene |
| `@OPT-BEH-BEH-036` | Opptaksforvalteren ser en advarsel på mangelkodene når ingen mangelkode er merket | funnet | `A/regelverk/features/Mangelkoder/MangelkoderOverview.tsx:36-56` |
| `@OPT-BEH-BEH-036` | Sakene i søknadene som finnes fra før, får ikke mangelen når mangelkoden merkes | funnet | `P/regelverk/MangeltypeService.java:52,96` rører ikke `sak_mangel`; synken kalles bare fra `S/app/SoknadshendelseJobb.java:317` |
| `@OPT-BEH-BEH-036` | Saken får mangelen når søkeren endrer søknaden etter at mangelkoden er merket | funnet | `SoknadshendelseJobb.java:317`; `P/saksbehandling/GskFullforesIVarMangelSync.java:36,48,62-91` |
| `@OPT-BEH-BEH-036` | Manglene som finnes fra før, blir stående når merkingen fjernes | funnet | `P/saksbehandling/GskFullforesIVarMangelSync.java:38` returnerer uten sletting |
| `@OPT-BEH-BEH-036` | Alle sakene i søknaden får mangel når søkeren oppgir at generell studiekompetanse fullføres i vår | ikke funnet | `P/saksbehandling/GskFullforesIVarMangelSync.java:62-91` setter mangelen på alle sakene; men «saksloggen viser grunnen» er usikkert: logglinja viser `intensjon` (`AuditLogItem.tsx:44`), som ingen kode setter — kontroll: mangelen settes (`P/saksbehandling/GskFullforesIVarMangelSync.java:62-91`), men saksloggen får ingen rader (`V480__stopp_endringslogg.sql`) |
| `@OPT-BEH-BEH-036` | Saken får ikke mangel når ingen mangelkode er merket | ikke funnet | Ingen mangel (`P/saksbehandling/GskFullforesIVarMangelSync.java:38`), men varselet til opptaksforvalteren finnes ikke. Søkt «varsel», «ingen mangelkode» |
| `@OPT-BEH-BEH-036` | Opptaksforvalteren får varselet bare første gang | ikke funnet | Samme søk, ingen varsling |
| `@OPT-BEH-BEH-036` | Søkeren ser den automatiske mangelen i Min kompetanse | ikke funnet | `P/saksbehandling/GskFullforesIVarMangelSync.java:82` publisert, men viewet tar bare UNDER_BEHANDLING/BEHANDLET (`PM/V514__behandlingsstatus_fjern_ferdig_behandlet.sql:19-20`). min-kompetanse ikke sjekket — kontroll: viewet joiner `publiserbar_sak`, som bare tar UNDER_BEHANDLING/BEHANDLET (`PM/V514__behandlingsstatus_fjern_ferdig_behandlet.sql:17-20,74-77`); en ny sak er UBEHANDLET, så API-et viser ikke DUA |
| `@OPT-BEH-BEH-036` | Søkeren får ikke egen melding om den automatiske mangelen | funnet | `P/saksbehandling/GskFullforesIVarMangelSync.java:62-91` sender ingen melding; MangelMeldingService bare fra `SakMangelService.java:117/140` |
| `@OPT-BEH-BEH-036` | Mangelen slettes når søkeren endrer søknaden | ikke funnet | `P/saksbehandling/GskFullforesIVarMangelSync.java:93-100` sletter; saksloggen usikker som over — kontroll: `P/saksbehandling/GskFullforesIVarMangelSync.java:93-101` sletter, men saksloggen får ingen rader (V480) |
| `@OPT-BEH-BEH-036` | Mangel som er sjekket ut slettes ikke når søkeren endrer søknaden | funnet | `P/saksbehandling/GskFullforesIVarMangelSync.java:100` — krever `status_utsjekket` null/false |
| `@OPT-BEH-BEH-036` | Saksbehandleren kan ikke slette den automatiske mangelen | funnet | `A/soknadsbehandling/features/SakDrawer/components/ManglerCard/Mangel/Mangel.tsx:146`. Backend har ingen sperre (`SakMangelService.java:360`) |
| `@OPT-BEH-BEH-036` | Mangelen sjekkes ut når saken er behandlet helautomatisk | ikke funnet | `P/autosak/FerdigbehandlingService.java:64,213-227` sjekker ut før BEHANDLET (:65); saksloggen usikker som over — kontroll: `P/autosak/FerdigbehandlingService.java:64,213-227` sjekker ut, men saksloggen får ingen rader (V480) |
| `@OPT-BEH-BEH-036` | Mangelen sjekkes ikke ut når saken ikke er behandlet helautomatisk | funnet | `P/autosak/FerdigbehandlingService.java:59-63` |
| `@FLY-OPT-SAK-001` | Lærestedene kan velge behandlertildelingsregelen opptaket har satt opp | funnet | lages: `P/regelverk/BehandlertildelingsregelMutations.java:41,44-51` · brukes: `P/opptak/UtdanningstilbudMutations.java:969` — inaktive regler avvises; `A/opptak/features/OpptakManagement/OpptakSøknadsalternativer/hooks/useBehandlertildelingsregelOptions.ts:8` (`erAktiv: true`) |
| `@FLY-OPT-SAK-001` | Utdanningstilbudet får behandlertildelingsregelen fra opptaket | funnet | lages: `P/regelverk/BehandlertildelingsregelMutations.java:41` · brukes: `P/opptak/UtdanningstilbudMutations.java:485-486` — `utdanningstilbud.behandlertildelingsregel_kode`, sjekket mot opptaket (`P/opptak/UtdanningstilbudMutations.java:451`) og aktiv (`P/opptak/UtdanningstilbudMutations.java:969`) |
| `@FLY-OPT-SAK-001` | Søknaden blir én sak hos hver saksbehandlende organisasjon | funnet | lages: `P/opptak/UtdanningstilbudMutations.java:485` · brukes: `P/saksbehandling/BehandlertildelingService.java:173,186,361,459-466` — én `sak` per organisasjon; kjøres av `SoknadshendelseJobb.java:315` |
| `@FLY-OPT-SAK-001` | Organisasjonen som saksbehandler på vegne av lærestedet får saken | funnet | lages: `P/regelverk/BehandlertildelingsregelMutations.java:58` (`behandlertildelingsregel_pa_vegne_av`) · brukes: `P/saksbehandling/BehandlertildelingService.java:192-208,459`; `BehandlertildelingAlgoritme.java:52` |
| `@FLY-OPT-SAK-001` | Saksbehandleren ved den saksbehandlende organisasjonen ser saken | funnet | lages: `P/saksbehandling/BehandlertildelingService.java:459` (`sak.organisasjonskode`) · brukes: `V501__tilbyderoppslag_per_sak.sql:37-40` — RLS på organisasjonen |
| `@FLY-OPT-SAK-001` | Tilbyderen kan sette tilbudsgaranti på søknadsalternativet som en annen organisasjon saksbehandler | funnet | lages: `P/saksbehandling/BehandlertildelingService.java:361` · brukes: `P/saksbehandling/SettTilbudsgarantitypeService.java:55,93-96`; `V454__forvalter_ser_saker_krever_modifisere_opptak.sql:61-62`; `A/soknadsbehandling/features/SakDrawer/components/SoknadsalternativerList/components/TilbudsgarantitypeSelect/TilbudsgarantitypeSelect.tsx:101` |
| `@FLY-OPT-SAK-001` | Saksbehandlertildelingen bruker fristen opptaket har satt | funnet | lages: `P/saksbehandling/UtdanningsbakgrunnOverstyringService.java:48,74`; `P/opptak/Utdanningsbakgrunnsfrist.java:34-37` · brukes: `P/saksbehandling/BehandlertildelingService.java:283-288,386-416` |

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Vitnemålet fra KREG er klart for behandlingen når saken er opprettet | ikke funnet | fasen er ikke levert |
| `@FLY-OPT-AUT-001` | Saken behandles automatisk når vitnemålet er importert | ikke funnet | fasen er ikke levert — ikke funnet på main, finnes i MR !6629 (åpen, fs-plattform, solov/autosak-start-etter-import): `SoknadshendelseJobb.startAutomatiskBehandling` → `AutomatiskBehandlingEtterImportService.startForSoker` etter `settGskKonklusjon` |
| `@FLY-OPT-AUT-001` | Søknaden får GSK-konklusjonen fra vitnemålet som er importert fra KREG | ikke funnet | fasen er ikke levert |
| `@FLY-OPT-AUT-001` | Søknaden uten GSK-konklusjon får konklusjonen i kjøringen | funnet | lages: `P/vgs/VgsLagringService.java:82` · brukes: `P/autosak/gsk/GskVedtakAutoService.java:158` — importen skriver `vgs_dokument.gsk_ok`; steg 0a (`P/autosak/AutomatiskSaksbehandlingService.java:97`) leser den og skriver `gsk_vedtak` KVALIFISERT/AUT (`GskVedtakAutoService.java:213`) bare uten konklusjon fra før (:59, :135) |
| `@FLY-OPT-AUT-001` | Saken behandles helautomatisk på vitnemålet som gir GSK | funnet | lages: `P/vgs/VgsLagringService.java:82` · brukes: `P/autosak/SetteGrunnlagService.java:110` — ett ikke-annullert VM med `gsk_ok` (:111-130, :371-375) gir automatisk grunnlag (:190-205); `P/autosak/FerdigbehandlingService.java:82-100` (`erHelautomatisk`) bruker samme vilkår |
| `@FLY-OPT-AUT-001` | Søkeren hoppes over når ingen vitnemål gir GSK | funnet | lages: `P/vgs/VgsLagringService.java:82` · brukes: `P/autosak/SetteGrunnlagService.java:128` — uten `gsk_ok` ingen grunnlag; flere dokumenter kaster FlereVitnemaalException (:111-114); ikke helautomatisk (`FerdigbehandlingService.java:89`) |
| `@FLY-OPT-AUT-001` | Saken behandles helautomatisk når søkeren har to identiske vitnemål | ikke funnet | fasen mangler krav (`@wont`, ingen `@depends-on-`) |
| `@FLY-OPT-AUT-001` | Saken får grunnlag | ikke funnet | fasen er ikke levert |
| `@FLY-OPT-AUT-001` | Søknadsalternativet får poengsum | ikke funnet | fasen er ikke levert |
| `@FLY-OPT-AUT-001` | Søknaden får tilleggspoengene for grunnlaget | ikke funnet | fasen er ikke levert |
| `@FLY-OPT-AUT-001` | Kravelementet er vurdert mot vitnemålet | funnet | lages: `P/regelverk/kvalifisering/KvalifiseringKravelementV2OppdateringService.java:84` · brukes: `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:100` — grunnlaget gir uvurderte rader i `sak_kvalifisering_kravelement` (`PropageringService.java:105`); kontrollmotoren vurderer mot vitnemålet (:133) og skriver `kravet_er_oppfylt` (:170-179); poeng før kravelementer (`AutomatiskSaksbehandlingService.java:134-140`) |
| `@FLY-OPT-AUT-001` | Kvotespørsmålet er besvart automatisk | funnet | lages: `P/saksbehandling/SoknadKvoteOppretterService.java:59` · brukes: `P/autosak/KvotesporsmalAlgoritmeService.java:68` — `sak_kvote` fra grunnlag og `kvotetype_grunnlag`; algoritmen leser `kvotetype_kvotespørsmål` og algoritmekode (:93-150) og skriver `sak_kvotesporsmal_svar` (:228-262). Merk: `sak_kvote` lages bare når søkeren er kvalifisert (:251-278), som ikke står i `Gitt` |
| `@FLY-OPT-AUT-001` | Søkeren er kvalifisert når vitnemålet oppfyller kravelementene | funnet | lages: `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:171` · brukes: `P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:152` — `kravet_er_oppfylt` leses, `er_kvalifisert` skrives (:204); steg 3 (`AutomatiskSaksbehandlingService.java:146`); krever også GSK-konklusjon (:124) |
| `@FLY-OPT-AUT-001` | Den kvalifiserte søkeren plasseres i kvoten grunnlaget er koblet til | funnet | lages: `P/regelverk/kvalifisering/KvalifiseringOppdateringService.java:204` · brukes: `P/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:307` — `er_kvalifisert` gir `sak_kvote` og `skal_kvoteplasseres` (:149, :170) |
| `@FLY-OPT-AUT-001` | Søkeren plasseres i kvoten når kvotespørsmålet er besvart ja automatisk | funnet | lages: `P/autosak/KvotesporsmalAlgoritmeService.java:238` · brukes: `P/saksbehandling/KvotesporsmalSvarService.java:327` — alle ja og kvalifisert gir `skal_kvoteplasseres` (:356-377) |
| `@FLY-OPT-AUT-001` | Søkeren har poengsum i kvoten | ikke funnet | fasen er ikke levert |
| `@FLY-OPT-AUT-001` | Saken får mangeltekst for kravelementet vitnemålet ikke oppfyller | ikke funnet | fasen er ikke levert |
| `@FLY-OPT-AUT-001` | Saken med mangelen for GSK som fullføres i vår blir ferdig behandlet | ikke funnet | fasen er ikke levert |
| `@FLY-OPT-AUT-001` | Saken er ferdig behandlet når den automatiske behandlingen har avgjort alt | ikke funnet | fasen er ikke levert |
| `@FLY-OPT-AUT-001` | Søkeren ser mangelteksten fra kravelementene når saken er ferdig behandlet | ikke funnet | fasen er ikke levert |
| `@FLY-OPT-AUT-001` | Saken blir ikke ferdig behandlet når poengene ikke kan avgjøres | ikke funnet | fasen er ikke levert |
| `@FLY-OPT-AUT-001` | Poengene beregnes på nytt når rangeringsregelverket er rettet | ikke funnet | fasen er ikke levert |

## Tilgang og datakonsistens

Sjekket på kodenivå (*Tilgang og datakonsistens* i `fs-verify`): at rollene og tilgangene er implementert slik kravet sier. Ingenting er kjørt, og rollene er ikke testet. Radene er grunnlaget for testbrukerne i testplanen. Radene er ikke scenarioer, og står ikke i `## Scenarioer`.

Ingen krav i scope har roller, organisasjoner eller data som endres.

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker (*Regler uten scenario* i `fs-verify`). Input til testplanen og den agentiske testen (fase 2). Listen er ikke fullstendig: den har det som ble sett under letingen.

Ingen.

## Åpne spørsmål

Tellet fra `@openquestion` i kravfilene. `@openquestion` stopper ikke leveransen og testen: delen testes som den står, og `@draft @openquestion` er utenfor gating-settet. Spørsmålene står i `## Oppfølging`.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Automatisk saksbehandling | 2 av 19 | 1 av 22 | 0 |

## Åpne MR-er og brancher

Koden i disse er ikke merget, og regnes ikke som levert. Scenarioene som bare finnes her, står som `ikke funnet` i `## Scenarioer`, med `finnes i MR !<iid>` i beviset.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-plattform` | !6629 STEK-678: den automatiske behandlingen starter etter importen fra KREG (`solov/autosak-start-etter-import`) | åpen | `@FLY-OPT-AUT-001` (fasen «Den automatiske behandlingen starter …»), `@OPT-BEH-BEH-032` | 1/22 (flyten), 4/9 (032, bare tildelingsløpet) | Starter ikke behandlingen ved flere vitnemål, og har ingen import for aktive søkere. Har også `kildeOpptak` (015) |
| `fs-plattform` | !6628 STEK-249: GskVedtak.kildeOpptak viser opptaket konklusjonen er gjenbrukt fra (`solov/gsk-konklusjon-kilde-opptak`) | åpen | `@OPT-BEH-BEH-015` | 1/53 | Nullstiller også `merknad_automatisk` når saksbehandleren endrer et poeng (018) |
| `fs-admin` | !3358 vis hvilket opptak en gjenbrukt GSK-konklusjon kommer fra (`solov/gsk-konklusjon-kilde-opptak`) | utkast | `@OPT-BEH-BEH-015` | 2/53 | |
| `fs-plattform` | !6602 TAKE-492: Innstillinger på kvotetype (`feature/take-492-kvotetype-innstillinger`) | åpen | `@OPT-REG-KVO-001` (de tre `@planned`-reglene) | 11/20 | Bare backend, fs-admin har ingenting. Migrasjonen V513 er tatt på main (høyeste er V516) og må nummereres om |
| `fs-admin` | !3066 SHI-696 hovedregel for behandlertildeling (`tuva/SHI-696-hovedregel-behandlertildeling`) | åpen | `@FLY-OPT-SAK-001` | 0/7 | usikker kobling, ikke lett i (alt funnet på main) |
| `fs-admin` | !3362 STEK-675 alle søknadsalternativene i saken (`STEK-675-alle-soknadsalternativer`) | åpen | – | 0 | usikker kobling |
| `fs-plattform` | `solov/gsk-konklusjon-fra-importen` | branch uten MR | `@OPT-BEH-BEH-015` | 0 | Endrer ingen rad som er `ikke funnet` |
| `fs-plattform` | `solov/automatisk-saksbehandling-start-publisering` | branch uten MR | `@OPT-BEH-BEH-032` | 0 | Bare én linje i `opptakshendelse.graphqls` |
| `fs-admin` | `solov/automatisk-saksbehandling-frister` | branch uten MR | `@OPT-BEH-BEH-032` | 0 | |
| `fs-plattform`, `fs-admin` | `mahj/behandlet-statuskode`, `mahj/behandlet-statuskode-fjern-gammel` | branch uten MR | `@OPT-BEH-BEH-025`, `@OPT-BEH-BEH-029` | 0 | Innholdet (STEK-253, BEHANDLET) er alt på main |
| `fs-plattform`, `fs-admin` | `mahj/STEK-651` | branch uten MR | `@OPT-BEH-BEH-026` | 0 | Innholdet er alt på main (V509) |
| `fs-plattform`, `fs-admin` | `mahj/STEK-673` | branch uten MR | `@OPT-BEH-BEH-018`, `@OPT-BEH-BEH-028` | 0 | Squash-merget, innholdet er på main |
| `fs-admin` | `mahj/knapp-158-001`, `mahj/STEK-665-statusetikett-tolerant` | branch uten MR | `@OPT-BEH-BEH-032`, `@OPT-BEH-BEH-029` | 0 | |
| `fs-plattform` | `STEK-676-median-fra-forrige-opptak` | branch uten MR | – | 0 | usikker kobling |

## Kontroll

| Feature-ID | Type | Scenario, rad eller regel | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-012` | scenario | Ny automatisk behandling uten endring gir ikke nytt innslag | funnet | usikker | `PM/V480__stopp_endringslogg.sql` — `Så` holder bare fordi endringsloggen ikke fylles i det hele tatt; merknaden er ikke endringsloggen |
| `@OPT-BEH-BEH-015` | scenario | Opptakssystemets påstand er at søkeren ikke har GSK når <grunn> | usikker | funnet | `P/autosak/gsk/GskKonklusjonEvaluator.java:96-97,123-124` — ukjent løp og ulik reform gir grunnlagskode null og ikke GSK (lest av lead) |
| `@OPT-BEH-BEH-018` | scenario | Se hvorfor vitnemålspoengene ikke er beregnet | funnet | usikker | `P/autosak/SetteGrunnlagService.java:111-114` — ved flere vitnemål rulles autosaken tilbake, og grunnen vises bare i snackbaren |
| `@OPT-BEH-BEH-025` | scenario | Saksbehandleren ser når den automatiske behandlingen avgjorde hvert steg | usikker | ikke funnet | `PM/V480__stopp_endringslogg.sql` — endringsloggen får ingen nye rader |
| `@OPT-BEH-BEH-025` | scenario | Det som kan avgjøres, blir avgjort når <steg> ikke kan avgjøres | usikker | ikke funnet | `P/autosak/AutomatiskSaksbehandlingService.java:146-147` — kvalifiseringen kjører likevel og setter `er_kvalifisert=false` når kravelementene ikke kan avgjøres |
| `@OPT-BEH-BEH-028` | scenario | Bare beståtte emner teller | usikker | ikke funnet | `P/regelverk/poeng/PoengService.java:278-289` — ingen filter på bestått, uavhengig av HOY_ALG1 |
| `@OPT-BEH-BEH-029` | scenario | Saksloggen viser endring av behandlingsstatus når <årsak> | usikker | ikke funnet | `PM/V480__stopp_endringslogg.sql:14-44` — audit-triggerne er droppet, ingen annen logging |
| `@OPT-BEH-BEH-032` | scenario | Saken med behandlingsstatusen <status> behandles ikke automatisk når importen henter søkerens vitnemål | usikker | ikke funnet | Importen i `Når` finnes ikke; sperren finnes bare i MR !6629 |
| `@OPT-BEH-BEH-032` | scenario | Saken behandles ikke automatisk på nytt når det kommer et nytt vitnemål | usikker | ikke funnet | Som over; vakten `BEHANDLET_AUTOMATISK` finnes bare i MR !6629 |
| `@OPT-BEH-BEH-036` | scenario | Mangelteksten viser kravelementene som ikke er oppfylt, ordnet etter kravlistene | usikker | ikke funnet | `P/regelverk/kvalifisering/ManglendeKravBeregner.java:98-99` — kravlistene får ikke navn |
| `@OPT-BEH-BEH-036` | scenario | Alle sakene i søknaden får mangel når søkeren oppgir at generell studiekompetanse fullføres i vår | usikker | ikke funnet | Saksloggen får ingen rader (V480) |
| `@OPT-BEH-BEH-036` | scenario | Søkeren ser den automatiske mangelen i Min kompetanse | usikker | ikke funnet | `PM/V514__behandlingsstatus_fjern_ferdig_behandlet.sql:17-20,74-77` — viewet tar bare saker som er under behandling eller behandlet |
| `@OPT-BEH-BEH-036` | scenario | Mangelen slettes når søkeren endrer søknaden | usikker | ikke funnet | Saksloggen får ingen rader (V480) |
| `@OPT-BEH-BEH-036` | scenario | Mangelen sjekkes ut når saken er behandlet helautomatisk | usikker | ikke funnet | Saksloggen får ingen rader (V480) |

Kontrollen endret ingen resultater i flyten (22/22 bekreftet). Radene over er i avhengighetene.

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

Ingen.

**Kan slettes**

Ingen.

**Blir stående**

- `@FLY-OPT-AUT-001` — Automatisk saksbehandling (`@planned`, 8/22 funnet) — 11 av 17 faser med krav er ikke levert, 2 faser mangler krav (`@wont`), og flyten bygger på `@FLY-OPT-SAK-001`, som er `@planned`. Overleveringene i de 6 leverte fasene er funnet

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Automatisk saksbehandling | `@planned` | 8/22 | 14 ikke funnet, 0 usikker (13 i faser som ikke er levert, 1 i en fase uten krav) |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Kjente brudd i flyten er utdatert:** to av de fire kjente bruddene i `krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling.feature:30-32` stemmer ikke med main. GSK-påstanden beregnes og lagres på vitnemålet ved importen (`P/vgs/HentVgsVitnemaalService.java:189-213`, `P/autosak/gsk/GskPaastandService.java:30-42`), og GSK-konklusjonen settes rett etter importen (`S/app/SoknadshendelseJobb.java:412`). Uenighet med skolen stopper ikke automatikken (`P/autosak/gsk/GskKonklusjonEvaluator.java:64-76`). Bruddet på linje 33-34 (ingenting starter behandlingen) gjelder fortsatt, men løses av MR !6629. Foreslår `fs-krav` (modus E) for å rette dem
- **Fremdriften i taggene henger etter koden:** koden for flere faser som ikke er levert ut fra taggene, finnes på main: ferdigbehandling og utsjekking av mangelen for GSK som fullføres i vår (`P/autosak/FerdigbehandlingService.java:58-73,213-227`, STEK-253), GSK-konklusjon ved import, og beregning på nytt (V509, STEK-651). Avhengighetene retagges aldri her. Kjør `fs-verify` på scopene (`automatisk-gsk-konklusjon`, `automatisk-ferdigbehandling`, `beregne-automatisk-pa-nytt` m.fl.) for å oppdatere taggene
- **Poeng for høyere utdanning er slått av:** `HOY_ALG1` finnes i koden (`P/regelverk/poeng/HoyereUtdanningspoengAlgoritme.java:9`), men ikke i kodeverket `regelverk.poengalgoritme` (bare `PM/V170__poengalgoritme_alder_kjonn.sql:13-24`), og fremmednøkkelen hindrer at en poengtype kobles til den. Det er bevisst (`PropageringHoyereUtdanningspoengIT.java:55`) til importen av resultater fra høyere utdanning finnes. Fasen «Søknaden får tilleggspoeng …» kan ikke bli levert før dette er på plass
- **Endringsloggen er stoppet:** `PM/V480__stopp_endringslogg.sql` fjernet audit-triggerne i `saksbehandling`, og `G/saksbehandling/sak.graphqls:196` sier at endringsloggen ikke får nye rader. Scenarioer om endringsloggen eller saksloggen er `ikke funnet` i `@OPT-BEH-BEH-012`, `-019`, `-020`, `-025`, `-026`, `-029` og `-036`, og `@OPT-BEH-BEH-031` «Uendret poengsum gir ikke nytt innslag i endringsloggen» holder bare fordi loggen er stoppet. Foreslår å avklare med `fs-krav` om scenarioene skal bli stående
- **Flyten mangler en forutsetning:** scenarioet «Kvotespørsmålet er besvart automatisk» (fasen «Kvotespørsmålene med algoritme besvares automatisk») sier bare at saken har grunnlag, men `sak_kvote` lages bare når søkeren er kvalifisert (`P/saksbehandling/SoknadKvoteOppretterService.java:251-278`). Vurder et åpent spørsmål med `fs-krav`
- **Feil i avhengighetene som bør til `fs-krav`:** `@FLY-OPT-SAK-001`: scenariomalen om fristen trenger en forutsetning om at standardregelen har unntaket «Utenlandsk» → HK-dir (`P/saksbehandling/BehandlertildelingService.java:315-331`), og svaret på det åpne spørsmålet om AHO og OsloMet er ja, fordi koden krever at begge deltar (`P/regelverk/BehandlertildelingsregelMutations.java:286-303`). `@OPT-BEH-BEH-026`: `Når` i de to scenarioene om mangeltekst velger et kravelement, men utvalget kan bare være regelverk (`P/saksbehandling/regelverksoppdatering/RegelverksoppdateringUtvalg.java:57-85`). `@OPT-BEH-BEH-018`: raden «ikke generell studiekompetanse» forventer «ikke ett entydig vitnemål». `@OPT-BEH-BEH-015`: kommentarene om `GskVedtakTilbakekallingService` og `KRYSSJEKK_FEILET` stemmer ikke med main, og `@draft`-regelen om perioden er i praksis bygget (`P/autosak/gsk/GskKonklusjonEtterImportService.java:47`). `@OPT-BEH-BEH-027`: kommentaren på linje 14-15 om at uenighet stopper automatikken, er utdatert
- **Funn i koden utenfor scenarioene:** fs-admin markerer et dokument som lest når saksbehandleren åpner det (`fs-admin/src/domains/soknadsbehandling/features/…/DocumentItem/utils/useDownloadFileFromGqlId.tsx:87`), så saken blir Under behandling av å se på et dokument (mot kommentaren i `@OPT-BEH-BEH-029`). GSK-kortet viser «Ikke kvalifisert» også uten konklusjon, og backend avviser valget (`A/soknadsbehandling/features/GSKCard/GSKCard.tsx:366,383-394`). En saksbehandler ved tilbyderen eller opptaksforvalteren kommer forbi organisasjonssjekken i `P/autosak/AutomatiskSaksbehandlingService.java:161-186`, og GSK-konklusjonen kan lagres før resten feiler (`@OPT-BEH-BEH-032`). Inaktive rangeringsregelverk og ugyldige poengformler stoppes bare i fs-admin. `AnnullertVitnemaalService` tagger også saker i avsluttede opptak (`@OPT-BEH-BEH-034`)
- **Levert, men ikke funnet i koden:** delene som er `@implemented` (eller levert under en `@implemented` egenskap), men ikke er `funnet`: `@OPT-BEH-BEH-012` «Automatisk kvoteplassering i endringsloggen», «Endringsloggen viser opptaksalderen» (ikke funnet) og «Ny automatisk behandling uten endring gir ikke nytt innslag» (usikker); `@OPT-BEH-BEH-020` «Fagkrav uten karakter oppfylles uten karakter» (usikker: bestått uten tallkarakter blir «vurder manuelt»); `@OPT-BEH-BEH-026` «Den automatiske mangelteksten slettes når søkeren blir kvalifisert etter beregningen» (usikker); `@OPT-BEH-BEH-036` «Søkeren ser ikke de automatiske mangeltekstene mens saken er under behandling», «Søkeren ser mangeltekstene per søknadsalternativ», «Søkeren ser ikke mangelteksten når søknadsalternativet er fjernet», «Saksbehandleren kan ikke endre en automatisk mangeltekst» (usikker)
- **`@deprecated` i avhengighetene som fortsatt finnes i koden:** `@OPT-BEH-BEH-030` «Kompetansebevis importeres» (`P/vgs/KregVgsParser.java:70-76`) og «Søker uten fødselsnummer får ingen resultater importert» (`P/vgs/HentVgsVitnemaalService.java:101-114`); `@OPT-BEH-BEH-015` «Kompetansebevis får ingen påstand fra opptakssystemet» (`P/autosak/gsk/GskPaastandService.java:14-15,66-67`); `@OPT-BEH-BEH-019` «Ingen grunnlag settes automatisk når <grunn> (avvikles)» (`P/autosak/SetteGrunnlagService.java:120-127`); `@OPT-BEH-BEH-020` «Ingen automatisk vurdering når <grunn> (avvikles)» (`P/vgs/VgsDokumentVitnemaalService.java:51-54`). De er ikke vurdert for sletting her
- **Åpent spørsmål:** `@FLY-OPT-AUT-001` «Saken behandles helautomatisk når søkeren har to identiske vitnemål» — Utenfor scope i første fase. Fasen er med for å huske den til neste fase. Ingen krav beskriver når to vitnemål er identiske, eller hvilket av dem saken behandles helautomatisk på. Hvilket krav skal eie regelen: OPT-BEH-BEH-025 eller et nytt krav?
- **Åpent spørsmål:** `@FLY-OPT-AUT-001` «Søknaden dobbeltrangeres automatisk etter 23/5-regelen» (regel uten scenarioer) — hvilket krav skal eie den automatiske dobbeltrangeringen (OPT-BEH-BEH-018 eller et nytt krav), og skal fasen hete 23/5 eller 23/6?
- **Ikke sjekket:** `min-kompetanse` finnes ikke lokalt. Scenarioene der søkeren ser noe i Min kompetanse, er `usikker` eller `ikke funnet` ut fra fs-plattform alene. Flyten: «Søkeren ser mangelteksten fra kravelementene når saken er ferdig behandlet» er `ikke funnet` fordi fasen ikke er levert
- **Ikke sjekket:** `glab` kunne ikke kjøres i fs-admin-klonen for én kontrollør (`mise trust`); remote-branchene er sjekket i stedet
- **Bygger på krav som ikke er levert:** `@FLY-OPT-AUT-001` bygger på `@FLY-OPT-SAK-001` (`@planned`), og på `@OPT-BEH-BEH-015`, `-018`, `-019`, `-020`, `-025`, `-026`, `-027`, `-028`, `-029`, `-030`, `-031`, `-032` og `-036` (alle `@in-progress`)
- **Kravrepoet er bak main:** den utsjekkede branchen `krav/poeng-hoyere-utdanning` er 168 commits bak `origin/main`, og flyten er endret på main. Rapporten bygger på main. Commit den på en branch fra main
