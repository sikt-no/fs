# Verifisering: Automatisk saksbehandling (@FLY-OPT-AUT-001)

- **Dato:** 2026-11-12 07:56
- **Krav:** `krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling.feature` (1 feature-fil, flyten `@FLY-OPT-AUT-001`)
- **Kode:** `fs-plattform` (origin/main, e010217bb8, oppdatert), `fs-admin` (origin/main, 1d43d5795, oppdatert). Lest fra origin/main i egne arbeidskopier; de utsjekkede branchene i klonene er ikke brukt. Kravrepoet: main, 5e80f47c
- **Repoer:** P = fs-plattform, A = fs-admin, M = min-kompetanse · ✓ funnet, ✗ mangler, ~ delvis eller usikker, – ikke relevant
- **Åpne MR-er:** åpne MR-er i fs-plattform og fs-admin gjennomgått (1 med kode for flyten: !6728 i fs-plattform)
- **Omfang:** flyter (fra prompten: bare `@FLY-OPT-AUT-001`, den helautomatiske flyten)
- **Avhengigheter:** 1 nivå, verifisert i koden. Rapporten er avgrenset til flyten: avhengighetene står bare med statusen og delene fasene bygger på, ikke med resultatene per scenario og funnene i dem
- **Korrigert:** 2026-11-12, avgrenset til flyten. Resultatene per scenario i avhengighetene og funnene som bare gjelder avhengighetene, er tatt ut
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Team:** 5 finnere (`fs-verify-krav`), 11 kontrollører (`fs-verify-kontroll`)
- **Skjermbilder:** nei

Gating-sett: scenarioene i flyten som ikke er tagget `@draft`, `@deprecated` eller `@demo`.

Stiene er forkortet:

- `os/` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/`
- `osg/` = `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/`
- `SH` = `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java`
- `KIJ` = `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/KregImportJobb.java`
- `ABEI` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/AutomatiskBehandlingEtterImportService.java`
- `GVA` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/gsk/GskVedtakAutoService.java`
- `FB` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/FerdigbehandlingService.java`
- `SGS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/SetteGrunnlagService.java`


## Oppsummering

Tallene for hele kjøringen, regnet ut fra tabellene under.

- Scenarioer: 11 funnet, 9 ikke funnet, 0 usikker, av 20
- Mangler: fs-plattform 9 scenarioer, fs-admin 0, min-kompetanse 1 (1 usikker)
- Forslag: 0 kan leveres, 0 delvis levert, 0 kan slettes, 5 kan leveres når det er avklart, 1 blir stående
- Tilgang og datakonsistens: 0 stemmer, 0 avviker, 0 ikke funnet, 0 usikker, av 0 (flyten har ingen roller, og avhengighetene sjekkes ikke for tilgang)
- Regler i koden uten scenario: 6
- Åpne spørsmål: 2 regler og 1 scenarioer i gating-settet, 0 utenfor gating (`@draft`)

## Forslag til endringer

Hva som kan endres i kravene, ut fra resultatene. *Kan leveres* og *Delvis levert* er sikre: alle scenarioene er funnet, og kontrollen har bekreftet hver rad. De settes i kjøringen når brukeren sier ja (se `## Endringer`). Resten må avklares: gi rapporten tilbake til `fs-verify`.

**Kan leveres når det er avklart**

- `@FLY-OPT-AUT-001` — Automatisk saksbehandling (`krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling.feature:3`): kan få `@implemented` når de 7 fasene som ikke er levert, er levert, de to `@wont`-fasene er avklart (`@wont` tas ikke ut av gating-settet, så «Saken behandles helautomatisk når søkeren har to identiske vitnemål» (`krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling.feature:106`) er `ikke funnet`), og `@FLY-OPT-SAK-001` er `@implemented` eller taggen er endret (se `## Andre funn`) `[P ✗ · A – · M ~]` · mangler i fs-plattform (9), min-kompetanse (1)
- `@OPT-BEH-BEH-018` — Regel: Skolepoeng settes sammen av karakterpoeng, realfagspoeng og språkpoeng (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_poengberegning.feature:66`): funnet i koden, men har ingen statustag (1/1 scenarioer funnet). Verifiser med kravet i scope.
- `@OPT-BEH-BEH-020` — Regel: Saksbehandlerens vurdering av et kravelement endres ikke av automatikken (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_kvalifisering.feature:295`): funnet i koden, men har ingen statustag (10/10 scenarioer funnet). Verifiser med kravet i scope.
- `@OPT-BEH-BEH-029` — Regel: Saken kan bare bli Behandlet når den har minst én mangel eller ett grunnlag (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/behandlingsstatus.feature:60`): funnet i koden, men har ingen statustag (2/2 scenarioer funnet). Verifiser med kravet i scope.
- `@OPT-BEH-BEH-029` — Regel: Saken blir Under behandling når saksbehandleren endrer vurderingen (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/behandlingsstatus.feature:82`): funnet i koden, men har ingen statustag (6/6 scenarioer funnet). Verifiser med kravet i scope.

**Blir stående**

- `@FLY-OPT-AUT-001` — Automatisk saksbehandling (`@planned`, 11/20 funnet): 10 av 19 faser er levert; i de leverte fasene er alle overleveringene funnet. 8 scenarioer ligger i faser som ikke er levert, og 1 i en fase uten krav · mangler i fs-plattform (9), min-kompetanse (1)

## Oversikt per krav

Hvor mange scenarioer som er funnet i hvert krav, og hvor mange som mangler i hvert repo.

| Feature-ID | Egenskap | Funnet | Mangler i P | Mangler i A | Mangler i M | Hva som gjenstår |
| --- | --- | --- | --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Automatisk saksbehandling | 11/20 | 9 | – | 1 (1 usikker) | 7 faser er ikke levert i kravene de bygger på, og 1 fase mangler krav; overleveringene i de 10 leverte fasene er funnet |

Mangler: fs-plattform 9 scenarioer i 1 krav, fs-admin 0 i 0 krav, min-kompetanse 1 i 1 krav (1 usikker). 0 av 1 krav er funnet i alle repoene.

`Funnet` er scenarioene som er funnet i alle repoene de gjelder, av alle scenarioene i kravet. `Mangler i P`, `A` og `M` er scenarioene som ikke er funnet i repoet (`ikke funnet` eller `usikker`). Et scenario som mangler i flere repoer, telles i hvert av dem. `–` betyr at ingen scenarioer i kravet gjelder repoet.

## Fremdrift for flyter

Hvilke faser i flyten som er levert, ut fra statusen på delene av kravene fasen bygger på.

| Flyt | Fase | Bygger på | Fase levert |
| --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Søkerens resultater importeres fra KREG når saken er opprettet | `@OPT-BEH-BEH-030` (`@implemented`) | ja |
| `@FLY-OPT-AUT-001` | Den automatiske behandlingen starter når søkerens resultater er importert | `@OPT-BEH-BEH-032` (`@in-progress`, Regel: Behandlingen kjører for hver ny sak saksbehandlertildelingen oppretter og Regel: Behandlingen kjører når importen har hentet vitnemålene til en søker uten vitnemål levert) | ja |
| `@FLY-OPT-AUT-001` | Søknaden får GSK-konklusjonen når vitnemålet importeres fra KREG | `@OPT-BEH-BEH-015` (`@in-progress`, Regel: Automatikken setter bare positive konklusjoner, og bare der ingen finnes ikke levert: «Automatikken kan sette en ny konklusjon etter annulleringen» mangler `@implemented`), `@OPT-BEH-BEH-027` (`@implemented`) | nei |
| `@FLY-OPT-AUT-001` | Den automatiske behandlingen setter GSK-konklusjonen der den mangler | `@OPT-BEH-BEH-015` (`@in-progress`, Regel: GSK-konklusjonen settes også når den automatiske behandlingen kjører levert) | ja |
| `@FLY-OPT-AUT-001` | Vitnemålet som gir GSK, avgjør om saken behandles helautomatisk | `@OPT-BEH-BEH-015` (`@in-progress`, Regel: Vitnemålet gir GSK når det har GSK OK fra KREG levert), `@OPT-BEH-BEH-025` (`@in-progress`, Regel: Bare saker der søkeren har ett vitnemål, og vitnemålet gir GSK, behandles helautomatisk levert) | ja |
| `@FLY-OPT-AUT-001` | To identiske vitnemål reknes som ett vitnemål | – (`@wont`) | mangler krav |
| `@FLY-OPT-AUT-001` | Saken får grunnlag fra vitnemålet | `@OPT-BEH-BEH-019` (`@in-progress`, de tre reglene i «…» levert) | ja |
| `@FLY-OPT-AUT-001` | Poengene beregnes fra grunnlaget og rangeringsregelverket | `@OPT-BEH-BEH-018` (`@in-progress`, Regel: Skolepoeng settes sammen av karakterpoeng, realfagspoeng og språkpoeng ikke levert), `@OPT-REG-RAN-001` (`@implemented`), `@OPT-REG-RAN-002` (`@implemented`) | nei |
| `@FLY-OPT-AUT-001` | Søknaden får tilleggspoeng når grunnlaget er satt | `@OPT-BEH-BEH-028` (`@in-progress`, Regel: Poeng for høyere utdanning regnes ut fra søkerens studiepoeng ikke levert) | nei |
| `@FLY-OPT-AUT-001` | Søknaden dobbeltrangeres automatisk etter 23/5-regelen | – (`@wont`, ingen scenarioer) | mangler krav |
| `@FLY-OPT-AUT-001` | Kravelementene vurderes mot vitnemålet når poengene er beregnet | `@OPT-BEH-BEH-020` (`@in-progress`, de tre reglene i «…» levert) | ja |
| `@FLY-OPT-AUT-001` | Kvotespørsmålene med algoritme besvares automatisk | `@OPT-BEH-BEH-012` (`@implemented`), `@OPT-REG-KVO-002` (`@implemented`) | ja |
| `@FLY-OPT-AUT-001` | Kvalifiseringen oppdateres når kravelementene er vurdert | `@OPT-BEH-BEH-020` (`@in-progress`, Regel: Om søkeren er kvalifisert, avgjøres per grunnlag levert) | ja |
| `@FLY-OPT-AUT-001` | Søkeren fordeles på kvoter når kvalifiseringen og kvotesvarene er satt | `@OPT-BEH-BEH-012` (`@implemented`) | ja |
| `@FLY-OPT-AUT-001` | Søkeren får poengsum per kvote når søkeren er fordelt på kvoter | `@OPT-BEH-BEH-031` (`@implemented`), `@OPT-REG-KVO-001` (`@implemented`), `@OPT-REG-RAN-002` (`@implemented`) | ja |
| `@FLY-OPT-AUT-001` | Saken får mangeltekster når kravelementene er vurdert | `@OPT-BEH-BEH-036` (`@in-progress`, Regel: Saken får automatiske mangeltekster når søkeren ikke er kvalifisert ikke levert) | nei |
| `@FLY-OPT-AUT-001` | Mangelen for GSK som fullføres i vår sjekkes ut før saken blir ferdig behandlet | `@OPT-BEH-BEH-036` (`@in-progress`, Regel: Mangelen for generell studiekompetanse som fullføres i vår settes og sjekkes ut automatisk ikke levert) | nei |
| `@FLY-OPT-AUT-001` | Saken blir ferdig behandlet og er klar til å være med i plasstildelingen | `@OPT-BEH-BEH-025` (`@in-progress`, Regel: Den automatiske behandlingen setter saken til ferdig behandlet når alt er avgjort ikke levert), `@OPT-BEH-BEH-029` (`@in-progress`, Regel: Saken kan bare bli Behandlet … og Regel: Saksloggen viser endringene i behandlingsstatusen ikke levert) | nei |
| `@FLY-OPT-AUT-001` | Søknadsalternativene beregnes på nytt når regelverket er rettet | `@OPT-BEH-BEH-026` (`@in-progress`, Regel: Bare saker som er ferdig behandlet, beregnes på nytt ikke levert) | nei |

`@FLY-OPT-AUT-001`: 10 av 19 faser levert. Flyten har i tillegg `@depends-on-FLY-OPT-SAK-001` på `Egenskap:`, og den flyten er `@planned`. Leses taggen strengt, er ingen fase levert før `@FLY-OPT-SAK-001` er `@implemented` (se `## Andre funn`).

## Avhengigheter

Kravene flyten bygger på (`@depends-on-`), med statusen deres. Hvilke deler fasene bygger på, og om de er levert, står i `## Fremdrift for flyter`.

| Krav i scope | Bygger på | Nivå | Status | Merknad |
| --- | --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | `@FLY-OPT-SAK-001` Saksbehandlertildeling | 1 | `@planned` | ikke levert (flyt på flyt, på `Egenskap:`). Angår ikke den automatiske behandlingen |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-030` Importere resultater fra KREG | 1 | `@implemented` |  |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-032` Starte automatisk behandling | 1 | `@in-progress` | ikke levert som helhet; delene fasen bygger på er levert |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-015` Automatisk GSK-konklusjon | 1 | `@in-progress` | ikke levert som helhet |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-027` Beregne GSK fra vitnemål | 1 | `@implemented` |  |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-025` Ferdigbehandle en sak | 1 | `@in-progress` | ikke levert |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-019` Automatisk grunnlag | 1 | `@in-progress` | ikke levert som helhet; delene fasen bygger på er levert |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-018` Automatisk beregning av vitnemålspoeng | 1 | `@in-progress` | ikke levert |
| `@FLY-OPT-AUT-001` | `@OPT-REG-RAN-001` Rangeringsregelverk | 1 | `@implemented` |  |
| `@FLY-OPT-AUT-001` | `@OPT-REG-RAN-002` Poengberegning | 1 | `@implemented` |  |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-028` Automatiske tilleggspoeng | 1 | `@in-progress` | ikke levert |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-020` Automatisk vurdering av spesielle opptakskrav | 1 | `@in-progress` | ikke levert som helhet; delene fasene bygger på er levert |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-012` Automatisk kvoteplassering | 1 | `@implemented` |  |
| `@FLY-OPT-AUT-001` | `@OPT-REG-KVO-002` Kvotespørsmål | 1 | `@implemented` |  |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-031` Beregne poengsum per kvote | 1 | `@implemented` |  |
| `@FLY-OPT-AUT-001` | `@OPT-REG-KVO-001` Kvotetype | 1 | `@implemented` | levert; `@planned`-deler endres |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-036` Automatiske mangler | 1 | `@in-progress` | ikke levert |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-029` Behandlingsstatus | 1 | `@in-progress` | ikke levert |
| `@FLY-OPT-AUT-001` | `@OPT-BEH-BEH-026` Beregne automatisk på nytt | 1 | `@in-progress` | ikke levert |

## Scenarioer

Resultatet for hvert scenario i gating-settet etter kontrollen, med beviset i koden. Tallene i rapporten regnes ut herfra, og FS Kravforvaltning leser tabellen.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Søknaden får GSK-konklusjonen fra vitnemålet som er importert fra KREG | ikke funnet | P ✗ · A – · M – — fasen er ikke levert: `@OPT-BEH-BEH-015` Regel: Automatikken setter bare positive konklusjoner, og bare der ingen finnes har et scenario uten `@implemented` («Automatikken kan sette en ny konklusjon etter annulleringen», ikke funnet i koden). Overleveringen finnes: `os/autosak/KregImportService.java:98` → `GVA:104-113,306` |
| `@FLY-OPT-AUT-001` | Saken behandles helautomatisk når søkeren har to identiske vitnemål | ikke funnet | P ✗ · A – · M – — fasen mangler krav (`@wont`, ingen `@depends-on-`). Koden behandler to vitnemål som flere (`SGS:112-115`) |
| `@FLY-OPT-AUT-001` | Søknadsalternativet får poengsum | ikke funnet | P ✗ · A – · M – — fasen er ikke levert: `@OPT-BEH-BEH-018` Regel: Skolepoeng settes sammen av karakterpoeng, realfagspoeng og språkpoeng er ikke `@implemented` (funnet i koden i denne kjøringen: `os/regelverk/kvalifisering/Skolepoeng.java:50`) |
| `@FLY-OPT-AUT-001` | Søknaden får tilleggspoengene for grunnlaget | ikke funnet | P ✗ · A – · M – — fasen er ikke levert: `@OPT-BEH-BEH-028` Regel: Poeng for høyere utdanning regnes ut fra søkerens studiepoeng er ikke `@implemented` |
| `@FLY-OPT-AUT-001` | Saken får mangeltekst for kravelementet vitnemålet ikke oppfyller | ikke funnet | P ✗ · A – · M – — fasen er ikke levert: `@OPT-BEH-BEH-036` Regel: Saken får automatiske mangeltekster når søkeren ikke er kvalifisert har scenarioer uten `@implemented` |
| `@FLY-OPT-AUT-001` | Saken med mangelen for GSK som fullføres i vår blir ferdig behandlet | ikke funnet | P ✗ · A – · M – — fasen er ikke levert: `@OPT-BEH-BEH-036` Regel: Mangelen for generell studiekompetanse som fullføres i vår settes og sjekkes ut automatisk er ikke levert. Koden finnes: `FB:68,222-236` |
| `@FLY-OPT-AUT-001` | Saken er ferdig behandlet når den automatiske behandlingen har avgjort alt | ikke funnet | P ✗ · A – · M – — fasen er ikke levert: `@OPT-BEH-BEH-025` og `@OPT-BEH-BEH-029` har deler fasen bygger på som ikke er `@implemented`. Koden finnes: `os/autosak/AutomatiskSaksbehandlingService.java:200` → `FB:62-71` |
| `@FLY-OPT-AUT-001` | Søkeren ser mangelteksten fra kravelementene når saken er ferdig behandlet | ikke funnet | P ✗ · A – · M ~ — fasen er ikke levert. Ikke funnet på main — finnes i MR !6728 (åpen, fs-plattform, solov/mangler-publiseres): `FB:79` `ManglerPublisering.publiserAlleOgVarsle`. min-kompetanse ikke sjekket |
| `@FLY-OPT-AUT-001` | Poengene beregnes på nytt når rangeringsregelverket er rettet | ikke funnet | P ✗ · A – · M – — fasen er ikke levert: `@OPT-BEH-BEH-026` Regel: Bare saker som er ferdig behandlet, beregnes på nytt har et scenario uten `@implemented`. Koden finnes: `os/autosak/AutomatiskSaksbehandlingService.java:252-262` |
| `@FLY-OPT-AUT-001` | Vitnemålet fra KREG er klart for behandlingen når saken er opprettet | funnet | P ✓ · A – · M – — lages: `SH:331` (`os/saksbehandling/BehandlertildelingService.java:463`), `SH:140` → `SH:411` → `os/vgs/HentVgsVitnemaalService.java:152` (`os/vgs/VgsLagringService.java:82`) · brukes: `GVA:168-183` |
| `@FLY-OPT-AUT-001` | Saken behandles automatisk når vitnemålet er importert | funnet | P ✓ · A – · M – — lages: `os/autosak/KregImportService.java:65-68` (fra `SH:140` og `KIJ:160`) · brukes: `os/autosak/KregImportService.java:110` → `ABEI:71-98,149-153` → `os/autosak/AutomatiskSaksbehandlingService.java:126` |
| `@FLY-OPT-AUT-001` | Søknaden uten GSK-konklusjon får konklusjonen i kjøringen | funnet | P ✓ · A – · M – — lages: `os/vgs/KregVgsParser.java:104`, `os/vgs/VgsLagringService.java:82` · brukes: `os/autosak/AutomatiskSaksbehandlingService.java:134` → `GVA:69,168,306` |
| `@FLY-OPT-AUT-001` | Saken behandles helautomatisk på vitnemålet som gir GSK | funnet | P ✓ · A – · M – — lages: `os/vgs/KregVgsParser.java:104`, `os/vgs/VgsLagringService.java:82` · brukes: `SGS:111-131`, `ABEI:139-146` |
| `@FLY-OPT-AUT-001` | Saken får grunnlag | funnet | P ✓ · A – · M – — lages: `os/vgs/VgsLagringService.java:82` · brukes: `os/autosak/AutomatiskSaksbehandlingService.java:170` → `SGS:129-131,191` |
| `@FLY-OPT-AUT-001` | Kravelementet er vurdert mot vitnemålet | funnet | P ✓ · A – · M – — lages: `SGS:191` → `os/saksbehandling/PropageringService.java:107` → `os/regelverk/kvalifisering/KvalifiseringKravelementV2OppdateringService.java:82-86` · brukes: `os/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:88,102-118,182-190` |
| `@FLY-OPT-AUT-001` | Kvotespørsmålet er besvart automatisk | funnet | P ✓ · A – · M – — lages: `os/saksbehandling/SoknadKvoteOppretterService.java:59,159` · brukes: `os/autosak/KvotesporsmalAlgoritmeService.java:67-80,144,243` |
| `@FLY-OPT-AUT-001` | Søkeren er kvalifisert når vitnemålet oppfyller kravelementene | funnet | P ✓ · A – · M – — lages: `os/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:182-190` · brukes: `os/autosak/AutomatiskSaksbehandlingService.java:195` → `os/saksbehandling/PropageringService.java:77` → `os/regelverk/kvalifisering/KvalifiseringOppdateringService.java:152-157,204` |
| `@FLY-OPT-AUT-001` | Den kvalifiserte søkeren plasseres i kvoten grunnlaget er koblet til | funnet | P ✓ · A – · M – — lages: `os/regelverk/kvalifisering/KvalifiseringOppdateringService.java:204` · brukes: `os/saksbehandling/PropageringService.java:78,187` → `os/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:154,169-170,301-308` |
| `@FLY-OPT-AUT-001` | Søkeren plasseres i kvoten når kvotespørsmålet er besvart ja automatisk | funnet | P ✓ · A – · M – — lages: `os/autosak/KvotesporsmalAlgoritmeService.java:243` · brukes: `os/autosak/KvotesporsmalAlgoritmeService.java:165` → `os/saksbehandling/KvotesporsmalSvarService.java:365,373,383` |
| `@FLY-OPT-AUT-001` | Søkeren har poengsum i kvoten | funnet | P ✓ · A – · M – — lages: `os/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:169` og `sak_poeng` · brukes: `os/regelverk/poeng/PoengsumService.java:68-87,180-186`, `os/regelverk/poeng/PoengberegningService.java:134-152` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker. Input til testplanen og den agentiske testen (fase 2). Lista har det som ble sett under letingen, og er ikke fullstendig.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Kvotespørsmål besvares, og saksbehandlingskvoter opprettes, bare for kvoter der søkeren er kvalifisert på et grunnlag som er koblet til kvotetypen. Fasen «Kvotespørsmålene med algoritme besvares automatisk» kommer derfor etter «Kvalifiseringen oppdateres» i koden, ikke før, slik flyten har det | tilstandsovergang | `os/saksbehandling/SoknadKvoteOppretterService.java:77-95,106,251-278` | uklart om ønsket |
| `@FLY-OPT-AUT-001` | En sak som er ferdig behandlet, får ingen GSK-konklusjon ved import, og en gjenbrukt konklusjon erstattes av vitnemålet | tilstandsovergang | `GVA:104-137` | legg til scenario med `fs-krav` |
| `@FLY-OPT-AUT-001` | Behandlingen starter etter importen bare mens den automatiske saksbehandlingen pågår i opptaket | tilstandsovergang | `ABEI:82-87` | testes i fase 2 |
| `@FLY-OPT-AUT-001` | Behandlingen starter ikke etter importen når saken er under behandling eller allerede behandlet automatisk, eller når søkeren har kompetansebevis, flere vitnemål eller ingen | tilstandsovergang | `ABEI:129-146`, `os/autosak/AutomatiskSaksbehandlingService.java:151-165` | testes i fase 2 |
| `@FLY-OPT-AUT-001` | Ingen automatisk GSK-konklusjon i et arkivert opptak, og et vitnemål med kjent løp går foran et vitnemål med ukjent løp | tilstandsovergang | `GVA:72-74,180-197` | testes i fase 2 |
| `@FLY-OPT-AUT-001` | Grunnlaget settes ikke automatisk når saksbehandleren har satt et grunnlag | tilstandsovergang | `SGS:101-107` | testes i fase 2 |

## Åpne spørsmål

Hvor mange regler og scenarioer i hvert krav som har `@openquestion`. Spørsmålene stopper ikke leveransen, men står i testplanen til de er besvart.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Automatisk saksbehandling | 2 av 19 | 1 av 20 | 0 |

## Åpne MR-er og brancher

MR-er og brancher som ser ut til å levere kravene. Koden i disse er ikke merget, og regnes ikke som levert.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-plattform` | [!6728 STEK-665: Publiser manglene når saken blir behandlet](https://gitlab.sikt.no/fs/fs-plattform/-/merge_requests/6728) (`solov/mangler-publiseres`) | åpen | `@FLY-OPT-AUT-001`, og avhengighetene `@OPT-BEH-BEH-025`, `@OPT-BEH-BEH-036`, `@OPT-BEH-BEH-026` | 1/1 | gjelder «Søkeren ser mangelteksten fra kravelementene når saken er ferdig behandlet» (fasen er ikke levert ennå) |

## Andre funn

Det som må følges opp, og som ikke står i de andre tabellene: det kravet ikke sier, det kontrollen rettet, spørsmålene, og det som ikke ble sjekket. Én rad per funn, sortert etter type og så i rekkefølgen kravene står i.

| Type | Feature-ID | Gjelder | Hva |
| --- | --- | --- | --- |
| Kravet er bak koden | `@FLY-OPT-AUT-001` | Kjent brudd om GSK-vitnemålsberegningen (`krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling.feature:31-32`) | Utdatert: påstanden beregnes og lagres når vitnemålet importeres (`os/vgs/HentVgsVitnemaalService.java:205-217` → `os/autosak/gsk/GskPaastandService.java:36-42`), og konklusjonen settes ved import (`os/autosak/KregImportService.java:98`). Foreslå å fjerne bruddet med `fs-krav` (modus E) |
| Kravet er bak koden | `@FLY-OPT-AUT-001` | Kjent brudd om uenig kontroll (`krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling.feature:33`) | Utdatert: uenigheten stopper ikke automatikken (`os/autosak/gsk/GskKonklusjonEvaluator.java:61-76`), og saksbehandleren får varsel (`os/vgs/VgsDokumentGskKontrollService.java:53-58`, `fs-admin/src/domains/soknadsbehandling/features/VitnemalsbehandlingSection/VitnemalsbehandlingSection.tsx:86,172-174`). Varselet ligger i experimental-skjemaet |
| Kravet er bak koden | `@FLY-OPT-AUT-001` | Kjent brudd om at ingenting starter behandlingen (`krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling.feature:34-35`) | Utdatert: behandlingen starter etter importen fra KREG (`os/autosak/KregImportService.java:110` → `ABEI:71-98`), både etter saksbehandlertildelingen (`SH:140`) og i den daglige importen (`KIJ:160-170`) |
| Åpent spørsmål | `@FLY-OPT-AUT-001` | Regel: To identiske vitnemål reknes som ett vitnemål (`krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling.feature:99`) | Utenfor scope i første fase. Ingen krav beskriver når to vitnemål er identiske, eller hvilket av dem saken behandles helautomatisk på. Hvilket krav skal eie regelen: OPT-BEH-BEH-025 eller et nytt krav? |
| Åpent spørsmål | `@FLY-OPT-AUT-001` | Regel: Søknaden dobbeltrangeres automatisk etter 23/5-regelen (`krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling.feature:141`) | Utenfor scope i første fase. Hvordan skal den automatiske dobbeltrangeringen gjøres, hvilket krav skal eie regelen, og skal fasen hete 23/5 eller 23/6? |
| Bygger på krav som ikke er levert | `@FLY-OPT-AUT-001` | – | Flyten har `@depends-on-FLY-OPT-SAK-001` på `Egenskap:`, og den flyten er `@planned`. Leses taggen strengt, er ingen fase levert før `@FLY-OPT-SAK-001` er `@implemented`. Det som holder `@FLY-OPT-SAK-001` igjen, angår ikke den automatiske behandlingen. Vurder med `fs-krav` om taggen skal være `@ref-FLY-OPT-SAK-001`: flyten bruker bare at saken er opprettet, og den overleveringen er funnet (`SH:331`) |
| Ikke sjekket | – | min-kompetanse | Klonen finnes ikke lokalt. Scenarioene der søkeren ser noe i Min kompetanse, er `usikker` eller har M ~ |
| Merknad | `@FLY-OPT-AUT-001` | `@wont` på fasene «To identiske vitnemål …» og «… dobbeltrangeres …» | `@wont` tas ikke ut av gating-settet, så «Saken behandles helautomatisk når søkeren har to identiske vitnemål» teller som `ikke funnet`, og flyten kan ikke bli `@implemented` med fasen som den står. Vurder `@draft @openquestion` på fasen med `fs-krav` |
| Merknad | `@FLY-OPT-AUT-001` | Fasen «Poengene beregnes fra grunnlaget og rangeringsregelverket» | Skolepoengene er funnet i koden (`os/regelverk/kvalifisering/Skolepoeng.java:50`, kravelementalgoritmen FPSKO), men regelen i `@OPT-BEH-BEH-018` er ikke tagget `@implemented`. Skolepoengene er resultatet på et kravelement med FPSKO, ikke en egen poengtype. Verifiser `@OPT-BEH-BEH-018` med seg selv i scope, så kan fasen bli levert |
| Merknad | `@FLY-OPT-AUT-001` | Den daglige KREG-importen | `opptak.kreg-import.cron` er `off` i `opptak-subgraph/src/main/resources/application.properties:110-111`, og bare på i `application-platon-test.properties:20-21`. I produksjon hentes vitnemålene bare når søknaden endres, og behandlingen starter ikke når et opptak publiseres igjen |
| Merknad | `@FLY-OPT-AUT-001` | Knappen «Start automatisk behandling» i FS Admin | Ligger bak feature-flagget `automatisk-soknadsbehandling-trigger`, som er på i test, review og dev, men ikke i produksjon (`BehandleSakAutomatiskButton.tsx:65-67`) |
