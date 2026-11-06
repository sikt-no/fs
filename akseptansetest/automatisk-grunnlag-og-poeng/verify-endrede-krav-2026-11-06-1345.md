# Verifisering: endrede krav i automatisk saksbehandling (PR #970 og #971)

- **Dato:** 2026-11-06 13:45
- **Krav:** delene av `@OPT-BEH-BEH-018`, `@OPT-BEH-BEH-019`, `@OPT-BEH-BEH-020`, `@OPT-BEH-BEH-015`, `@OPT-BEH-BEH-030`, `@OPT-BEH-BEH-036` og `@OPT-BEH-BEH-039` som er endret siden kjøringen 2026-11-06 11:28 (7 feature-filer, fem scopes)
- **Kode:** `fs-plattform` (main, f55f84cbe7, oppdatert), `fs-admin` (main, 613363da5, oppdatert), `min-kompetanse` (main, 05c50147, oppdatert). Kravrepoet: main (6a7d1df3)
- **Repoer:** P = fs-plattform, A = fs-admin, M = min-kompetanse · ✓ funnet, ✗ mangler, ~ delvis eller usikker, – ikke relevant
- **Åpne MR-er:** ikke sjekket (glab er ikke installert); bare brancher med navn som peker på kravene, 2 brancher i fs-plattform (`origin/vitnemalsbehandling-tabeller`, `origin/mahj/STEK-673`), ingen med kode for de endrede delene
- **Omfang:** delene som er endret i PR #970 og #971, uansett status, og de nye `@deprecated`-delene (fra prompten)
- **Avhengigheter:** ingen
- **Bygger på:** `akseptansetest/automatisk-grunnlag-og-poeng/verify-2026-11-06-1128.md` og de fem andre rapportene fra 11:28
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Team:** 2 finnere (`fs-verify-krav`), 6 kontrollører (`fs-verify-kontroll`)
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `P/…` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/…`
- `opptak-subgraph/…` = `fs-plattform/opptak/opptak-subgraph/src/main/…`
- `opptak-migrations/…` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/…`
- `A/…` = `fs-admin/src/domains/soknadsbehandling/features/…`

## Oppsummering

Tallene for hele kjøringen, regnet ut fra tabellene under.

- Scenarioer: 7 funnet, 1 ikke funnet, 1 usikker, av 9
- Mangler: fs-plattform 2 scenarioer, fs-admin 2, min-kompetanse 0 (1 usikker)
- Forslag: 0 kan leveres, 4 delvis levert, 0 kan slettes, 1 kan leveres når det er avklart, 5 blir stående
- Tilgang og datakonsistens: 3 stemmer, 2 avviker, 0 ikke funnet, 0 usikker, av 5
- Regler i koden uten scenario: 10
- Åpne spørsmål: 0 regler og 0 scenarioer i gating-settet, 2 utenfor gating (`@draft`)
- Endringer gjort: 0 krav og 7 deler fikk ny status, 0 filer og 0 blokker slettet

## Forslag til endringer

Hva som kan endres i kravene, ut fra resultatene. *Kan leveres* og *Delvis levert* er sikre: alle scenarioene er funnet, og kontrollen har bekreftet hver rad. De settes i kjøringen når brukeren sier ja (se `## Endringer`). Resten må avklares: gi rapporten tilbake til `fs-verify`.

**Delvis levert**

- `@OPT-BEH-BEH-018` — Automatisk beregning av vitnemålspoeng (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_poengberegning.feature`, 1/2 endrede funnet): `@implemented` på Scenario: Opplastet kompetansebevis hindrer ikke beregningen (linje 99) `[P ✓ · A ✓]`
- `@OPT-BEH-BEH-019` — Automatisk grunnlag (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_grunnlag.feature`, 3/3 endrede funnet): `@implemented` på Scenariomal: Ingen grunnlag settes automatisk når <grunn> (linje 143), Scenario: Opplastet kompetansebevis stopper ikke automatikken (linje 162), Scenario: Hver sak i søknaden får grunnlaget når den automatiske behandlingen kjører for saken (linje 190) `[P ✓ · A ✓]`
- `@OPT-BEH-BEH-020` — Automatisk vurdering av spesielle opptakskrav (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_kvalifisering.feature`, 2/2 endrede funnet): `@implemented` på Scenariomal: Ingen automatisk vurdering når <grunn> (linje 190), Scenario: Opplastet kompetansebevis stopper ikke vurderingen (linje 201) `[P ✓]`
- `@OPT-BEH-BEH-036` — Automatiske mangler (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatiske_mangler.feature`, 1/1 endret funnet): `@implemented` på Scenario: Saksbehandleren kan ikke slette den automatiske mangelen (linje 274) `[P ✓ · A ✓]`

**Kan leveres når det er avklart**

- `@OPT-BEH-BEH-018` — Scenariomal: Ingen automatiske vitnemålspoeng når <grunn> (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_poengberegning.feature:85`): kan få `@implemented` hvis kravet tilpasses koden, eller koden kravet — «Ingen automatiske vitnemålspoeng når <grunn>» er `usikker` `[P ~ · A ~]`: radene om annullert vitnemål og ingen vitnemål virker; flere vitnemål stopper hele den automatiske behandlingen med en feilmelding (`P/autosak/SetteGrunnlagService.java:110-115`) i stedet for merknaden på poengene; «ikke generell studiekompetanse» og «ikke noe grunnlag» gir ingen poeng, men ingen merknad, og med manuelt grunnlag beregnes poeng fra et vitnemål uten GSK (`P/vgs/VgsDokumentVitnemaalService.java:42-56`) · mangler i fs-plattform (1), fs-admin (1)

**Blir stående**

- `@OPT-BEH-BEH-039` — Behandle automatisk på vitnemålet saksbehandleren velger (`@planned`, 0/1 endret funnet): «Vitnemålspoeng fra vitnemålet saksbehandleren har valgt» er ikke funnet · mangler i fs-plattform (1), fs-admin (1)
- `@OPT-BEH-BEH-015` — Scenario: Kompetansebevis får ingen påstand fra opptakssystemet (`@deprecated`): finnes fortsatt i `P/autosak/gsk/GskPaastandService.java:66` — ingen påstand når dokumentet ikke er vitnemål, kalt under importen fra KREG
- `@OPT-BEH-BEH-019` — Scenariomal: Ingen grunnlag settes automatisk når <grunn> (avvikles), raden om kompetansebevis (`@deprecated`): finnes fortsatt i `P/autosak/SetteGrunnlagService.java:119-127` — et ensomt kompetansebevis gir ikke grunnlag («kompetansebevis krever foreløpig manuell behandling»)
- `@OPT-BEH-BEH-020` — Scenariomal: Ingen automatisk vurdering når <grunn> (avvikles), raden om kompetansebevis (`@deprecated`): finnes fortsatt i `P/vgs/VgsDokumentVitnemaalService.java:52-54` — et ensomt kompetansebevis gir ikke vitnemål til vurderingen
- `@OPT-BEH-BEH-030` — Scenario: Kompetansebevis importeres (`@deprecated`): finnes fortsatt i `P/vgs/KregVgsParser.java:70-78,98` og `P/vgs/VgsLagringService.java:42-104` — kompetansebevis fra KREG importeres og lagres som vitnemål

## Endringer

Det som er endret i kravfilene og i resultatet: i kjøringen (det sikre, når brukeren sa ja) og i gjennomgangen av rapporten.

| Feature-ID | Egenskap eller del | Endring | Avklart |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-018` | Scenario: Opplastet kompetansebevis hindrer ikke beregningen | `@implemented` på delen | ja i kjøringen |
| `@OPT-BEH-BEH-019` | Scenariomal: Ingen grunnlag settes automatisk når <grunn> | `@implemented` på delen | ja i kjøringen |
| `@OPT-BEH-BEH-019` | Scenario: Opplastet kompetansebevis stopper ikke automatikken | `@implemented` på delen | ja i kjøringen |
| `@OPT-BEH-BEH-019` | Scenario: Hver sak i søknaden får grunnlaget når den automatiske behandlingen kjører for saken | `@implemented` på delen | ja i kjøringen |
| `@OPT-BEH-BEH-020` | Scenariomal: Ingen automatisk vurdering når <grunn> | `@implemented` på delen | ja i kjøringen |
| `@OPT-BEH-BEH-020` | Scenario: Opplastet kompetansebevis stopper ikke vurderingen | `@implemented` på delen | ja i kjøringen |
| `@OPT-BEH-BEH-036` | Scenario: Saksbehandleren kan ikke slette den automatiske mangelen | `@implemented` på delen | ja i kjøringen |

## Oversikt per krav

Hvor mange scenarioer som er funnet i hvert krav, og hvor mange som mangler i hvert repo.

| Feature-ID | Egenskap | Funnet | Mangler i P | Mangler i A | Mangler i M | Hva som gjenstår |
| --- | --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-018` | Automatisk beregning av vitnemålspoeng | 1/2 | 1 (1 usikker) | 1 (1 usikker) | – | merknaden når søkeren ikke har ett entydig vitnemål, GSK-sjekk i poengberegningen |
| `@OPT-BEH-BEH-019` | Automatisk grunnlag | 3/3 | 0 | 0 | – | |
| `@OPT-BEH-BEH-020` | Automatisk vurdering av spesielle opptakskrav | 2/2 | 0 | – | – | |
| `@OPT-BEH-BEH-036` | Automatiske mangler | 1/1 | 0 | 0 | – | |
| `@OPT-BEH-BEH-039` | Behandle automatisk på vitnemålet saksbehandleren velger | 0/1 | 1 | 1 | – | valg av vitnemål og poengberegning fra det |

Mangler: fs-plattform 2 scenarioer i 2 krav, fs-admin 2 i 2 krav, min-kompetanse 0 i 0 krav (1 usikker). 3 av 5 krav er funnet i alle repoene.

`Funnet` er scenarioene som er funnet i alle repoene de gjelder, av alle scenarioene i kravet. `Mangler i P`, `A` og `M` er scenarioene som ikke er funnet i repoet (`ikke funnet` eller `usikker`). Et scenario som mangler i flere repoer, telles i hvert av dem. `–` betyr at ingen scenarioer i kravet gjelder repoet.

## Scenarioer

Resultatet for hvert scenario i gating-settet etter kontrollen, med beviset i koden. Tallene i rapporten regnes ut herfra, og FS Kravforvaltning leser tabellen.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-039` | Vitnemålspoeng fra vitnemålet saksbehandleren har valgt | ikke funnet | P ✗ · A ✗ · M – — med to vitnemål gir `P/vgs/VgsDokumentVitnemaalService.java:48-50` tomt vitnemål og ingen poeng (`P/regelverk/poeng/AutomatiskPoengberegningService.java:88-104`); `BehandleSakInput` og `BeregnPoengAutomatiskInput` har bare `sakId` (`opptak-subgraph/resources/schema/features/experimental/saksbehandling/automatisk-saksbehandling.graphqls:64-71,189-195`); `A/SakActionButtons/components/BehandleSakAutomatiskButton/BehandleSakAutomatiskButton.tsx:35-38` sender bare `sakId`. Valget finnes bare som tabell i branchen `origin/vitnemalsbehandling-tabeller` (V503), og hører til vitnemålsbehandleren (`@OPT-BEH-BEH-004`); søkt etter «valgtVitnem», «valgtVgdoknr», «vgdoknr», «velgVitnem» i fs-plattform og fs-admin |
| `@OPT-BEH-BEH-018` | Ingen automatiske vitnemålspoeng når <grunn> | usikker | P ~ · A ~ · M – — rad 2 og 3: `P/vgs/VgsDokumentVitnemaalService.java:43-50`, `P/regelverk/poeng/AutomatiskPoengberegningService.java:89-105`, `P/regelverk/poeng/PoengService.java:228-232` (nullstilt poeng og merknaden «Fant ikke entydig vitnemål»), `A/PoengberegningCard/PoengberegningCardRow/PoengberegningCardRow.tsx:198`. Rad 1 (flere vitnemål): i «Behandle automatisk» kaster `P/autosak/SetteGrunnlagService.java:110-115` `FlereVitnemaalException` før poengberegningen, transaksjonen rulles tilbake, og det som fremgår, er bare en feilmelding (`BehandleSakAutomatiskButton.tsx:40-42`); merknaden på poengene skrives bare når grunnlaget er satt manuelt. Rad 4 (ikke GSK): poengberegningen sjekker ikke `gsk_ok`; i automatikken gir ingen GSK ingen grunnlag (`SetteGrunnlagService.java:128`) og deaktiverte poengrader (`P/saksbehandling/PoengRadOppdateringService.java:46-48`), så ingen poeng, men heller ingen merknad; med manuelt grunnlag beregnes poeng. Rad 5 (ikke grunnlag): ingen poeng, men ingen merknad, fordi det ikke finnes poengrad å skrive den på. Finneren hadde A ✓, kontrollen A ~ |
| `@OPT-BEH-BEH-018` | Opplastet kompetansebevis hindrer ikke beregningen | funnet | P ✓ · A ✓ · M – — `P/vgs/VgsDokumentVitnemaalService.java:43-55`, `opptak-subgraph/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java:197-205`, `P/saksbehandling/SakFilterConditions.java:556-557,593-595`, `P/saksbehandling/SakService.java:64-76`, `A/SakOverviewView/components/SakFilter/SakFilter.tsx:81-84` |
| `@OPT-BEH-BEH-019` | Ingen grunnlag settes automatisk når <grunn> | funnet | P ✓ · A – · M – — `P/autosak/SetteGrunnlagService.java:116-118`, `:128-130`, `:171-182`, `:371-376` |
| `@OPT-BEH-BEH-019` | Opplastet kompetansebevis stopper ikke automatikken | funnet | P ✓ · A – · M – — `P/autosak/SetteGrunnlagService.java:110-131,371-375`, `P/autosak/gsk/GskVedtakAutoService.java:74-78`, `opptak-subgraph/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java:197-205` |
| `@OPT-BEH-BEH-019` | Hver sak i søknaden får grunnlaget når den automatiske behandlingen kjører for saken | funnet | P ✓ · A ✓ · M – — `P/autosak/AutomatiskSaksbehandlingService.java:93-94,119-124`, `P/autosak/SetteGrunnlagService.java:188-205`, `P/saksbehandling/KvalifikasjonsgrunnlagOppdateringService.java:158-163,172`, `opptak-subgraph/resources/schema/features/experimental/saksbehandling/automatisk-saksbehandling.graphqls:53-59`, `fs-admin/src/app/opptak/[id]/soknadsbehandling/sak/[sakId]/(sak)/layout.tsx:112` |
| `@OPT-BEH-BEH-020` | Ingen automatisk vurdering når <grunn> | funnet | P ✓ · A – · M – — `P/vgs/VgsDokumentVitnemaalService.java:43-50`, `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:92-95` |
| `@OPT-BEH-BEH-020` | Opplastet kompetansebevis stopper ikke vurderingen | funnet | P ✓ · A – · M – — `P/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java:199-207`, `P/vgs/VgsDokumentVitnemaalService.java:43-55`, `P/vitnemalsportalen/ElmoMapper.java:141-145` |
| `@OPT-BEH-BEH-036` | Saksbehandleren kan ikke slette den automatiske mangelen | funnet | P ✓ · A ✓ · M – — `A/SakDrawer/components/ManglerCard/Mangel/Mangel.tsx:146`, `A/SakDrawer/components/ManglerCard/queries.ts:28`, `opptak-subgraph/resources/schema/features/experimental/saksbehandling/mangel.graphqls:164`, `P/saksbehandling/GskFullforesIVarMangelSync.java:72,83` |

## Tilgang og datakonsistens

Om koden gir rollene tilgang slik kravet sier, holder data fra andre organisasjoner utenfor, og ikke gir foreldreløse eller motstridende data ved sletting og endring. Sjekket på kodenivå, ikke testet. Radene er grunnlaget for testbrukerne i testplanen.

### Avvik

Sjekkene der koden ikke gjør det kravet sier, kravet ikke sier noe, eller tilgangssjekken ikke er funnet. Det kravet ikke beskriver, står også i `## Regler uten scenario`.

| Feature-ID | Sjekk | Rolle og handling | Resultat | Bevis |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-018` | konsistens | automatisk behandling av en søker med flere vitnemål, med automatisk poeng fra før | avviker | kravet sier at saken ikke får vitnemålspoeng beregnet automatisk (Scenariomal: Ingen automatiske vitnemålspoeng når <grunn>), koden kaster før poengberegningen og ruller tilbake, så et gammelt automatisk poeng blir stående — `P/autosak/SetteGrunnlagService.java:110-115`, `P/regelverk/poeng/AutomatiskPoengberegningService.java:95-97` |
| `@OPT-BEH-BEH-036` | tilgang | saksbehandler sletter den automatiske mangelen gjennom API-et | avviker | kravet sier at saksbehandleren ikke kan slette den automatiske mangelen (Scenario: Saksbehandleren kan ikke slette den automatiske mangelen), fs-admin skjuler knappen, men `fjernMangelFraSak` sletter uten å sjekke om mangelen er automatisk — `P/saksbehandling/SakMangelService.java:351-367`, `opptak-subgraph/resources/schema/features/experimental/saksbehandling/mangel.graphqls:29` |

### Stemmer

Sjekkene der koden gjør det kravet sier.

| Feature-ID | Sjekk | Rolle og handling | Resultat | Bevis |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-019` | organisasjon | saksbehandler ved organisasjonen saken behandles hos endrer grunnlaget i saken | stemmer | `P/autosak/SetteGrunnlagService.java:193`, `opptak-migrations/V493__tilbyder_ser_saksbehandlingen.sql:89-96` |
| `@OPT-BEH-BEH-019` | organisasjon | saksbehandler leser sakene med filteret «Ubehandlet opplastet dok.» | stemmer | `P/saksbehandling/SakService.java:73-75`, `opptak-migrations/V499__dokument_rls_via_sak.sql` |
| `@OPT-BEH-BEH-036` | organisasjon | saksbehandler sletter en mangel i en sak ved en annen organisasjon | stemmer | `opptak-migrations/V291__saksbehandling_skjema.sql:1735-1738`, `A/SakDrawer/components/ManglerCard/ManglerCard.tsx:35` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker. Input til testplanen og den agentiske testen (fase 2). Lista har det som ble sett under letingen, og er ikke fullstendig.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-018` | Vitnemålspoeng beregnes fra et vitnemål uten generell studiekompetanse når saken har poengrader (f.eks. manuelt grunnlag) | annet | `P/vgs/VgsDokumentVitnemaalService.java:42-56` | uklart om ønsket (strider mot rad 4 i scenariomalen) |
| `@OPT-BEH-BEH-018` | Et ensomt kompetansebevis fra KREG gir ingen vitnemålspoeng | validering | `P/vgs/VgsDokumentVitnemaalService.java:52-54` | uklart om ønsket (raden er tatt ut av kravet) |
| `@OPT-BEH-BEH-018` | Merknaden er alltid «Fant ikke entydig vitnemål for automatisk <poengtype>», uansett årsak | annet | `P/regelverk/poeng/PoengService.java:228-232` | testes i fase 2 |
| `@OPT-BEH-BEH-018` | Flere vitnemål i «Behandle automatisk» stopper hele behandlingen, og vises bare som feilmelding | tilstandsovergang | `P/autosak/SetteGrunnlagService.java:110-115`, `fs-admin/src/domains/soknadsbehandling/features/SakActionButtons/components/BehandleSakAutomatiskButton/BehandleSakAutomatiskButton.tsx:40-42` | uklart om ønsket |
| `@OPT-BEH-BEH-018` | Har saken et grunnlag satt manuelt, hoppes vitnemålssjekken i grunnlagsvalget over, og poengene beregnes eller får merknaden | annet | `P/autosak/SetteGrunnlagService.java:100-106` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-019` | «Ubehandlet opplastet dok.» viser sakene med minst ett ulest saksdokument, uansett dokumenttype | annet | `P/saksbehandling/SakFilterConditions.java:593-595`, `P/saksbehandling/SakService.java:64-76` | legg til scenario med `fs-krav` (filteret er ikke beskrevet i et krav) |
| `@OPT-BEH-BEH-020` | Et vitnemål og et kompetansebevis fra KREG telles som to dokumenter, så kravelementene vurderes ikke | validering | `P/vgs/VgsDokumentVitnemaalService.java:43-48`, `P/autosak/SetteGrunnlagService.java:110-115` | uklart om ønsket (forsvinner når kompetansebevis ikke importeres) |
| `@OPT-BEH-BEH-020` | «Ubehandlet opplastet dok.» viser sakene med minst ett ulest saksdokument, uansett dokumenttype | annet | `P/saksbehandling/SakService.java:64-76` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-036` | Sletting av en mangel setter en ubehandlet sak til under behandling | tilstandsovergang | `P/saksbehandling/SakMangelService.java:365` | testes i fase 2 |
| `@OPT-BEH-BEH-036` | Sletting av en registrert mangel må bekreftes | annet | `A/SakDrawer/components/ManglerCard/Mangel/Mangel.tsx:171-200` | testes i fase 2 |

## Åpne spørsmål

Hvor mange regler og scenarioer i hvert krav som har `@openquestion`. Spørsmålene stopper ikke leveransen, men står i testplanen til de er besvart.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-018` | Automatisk beregning av vitnemålspoeng | 0 av 1 | 0 av 2 | 0 |
| `@OPT-BEH-BEH-019` | Automatisk grunnlag | 0 av 2 | 0 av 3 | 1 |
| `@OPT-BEH-BEH-020` | Automatisk vurdering av spesielle opptakskrav | 0 av 1 | 0 av 2 | 0 |
| `@OPT-BEH-BEH-036` | Automatiske mangler | 0 av 1 | 0 av 1 | 0 |
| `@OPT-BEH-BEH-039` | Behandle automatisk på vitnemålet saksbehandleren velger | 0 av 1 | 0 av 1 | 1 |

## Åpne MR-er og brancher

MR-er og brancher som ser ut til å levere kravene. Koden i disse er ikke merget, og regnes ikke som levert.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-plattform` | `origin/vitnemalsbehandling-tabeller` | branch uten MR | `@OPT-BEH-BEH-004` | 0/1 | bare migreringen V503 (`vitnemalsbehandling.vgdoknr`); valget hører til vitnemålsbehandleren, ikke `@OPT-BEH-BEH-039` |
| `fs-plattform` | `origin/mahj/STEK-673` | branch uten MR | `@OPT-BEH-BEH-028` | 0/0 | poeng for høyere utdanning; rører ikke de endrede delene |

## Andre funn

Det som må følges opp, og som ikke står i de andre tabellene: det kravet ikke sier, det kontrollen rettet, spørsmålene, og det som ikke ble sjekket. Én rad per funn, sortert etter type og så i rekkefølgen kravene står i.

| Type | Feature-ID | Gjelder | Hva |
| --- | --- | --- | --- |
| Kravet er bak koden | `@OPT-BEH-BEH-030` | Avklaringen 06.11.2026: kompetansebevis kommer ikke fra KREG | KREG-modulen i fs-plattform har meldingstypen `KOMPETANSEBEVIS` og behandlingstypen `INNSENDING_KOMPETANSEBEVIS` (`fs-plattform/kreg/kreg-db/src/main/java/no/sikt/nvb/db/behandling/MeldingType.java:5`, `BehandlingType.java:4`), og importen leser dokumenttypen VM/KB fra KREG (`P/vgs/KregVgsParser.java:98`). Sjekk med KREG at kompetansebevis aldri kommer derfra, før koden fjernes |
| Kontrollen endret | `@OPT-BEH-BEH-018` | «Ingen automatiske vitnemålspoeng når <grunn>» | A ✓ → A ~, og rad 1 (flere vitnemål) fra dekket til delvis: «Behandle automatisk» stopper med feilmelding før poengberegningen, og skriver ikke merknaden |
| Kontrollen endret | `@OPT-BEH-BEH-018` | konsistens: tidligere automatisk poeng nullstilles | stemmer → avviker: ved flere vitnemål rulles behandlingen tilbake, og poenget blir stående |
| Kontrollen endret | `@OPT-BEH-BEH-019` | «Opplastet kompetansebevis stopper ikke automatikken» | A ✓ → A –: filteret står bare i en kommentar, ikke i stegene |
| Kontrollen endret | `@OPT-BEH-BEH-019` | regel uten scenario: ensomt kompetansebevis gir ikke grunnlag | fjernet: dekket av raden i den avviklede scenariomalen (linje 130) |
| Kontrollen endret | `@OPT-BEH-BEH-020` | «Opplastet kompetansebevis stopper ikke vurderingen» | A ✓ → A –: filteret står bare i en kommentar, ikke i stegene |
| Kontrollen endret | `@OPT-BEH-BEH-036` | «Saksbehandleren kan ikke slette den automatiske mangelen» | P ~ → P ✓: `Så` sier at saksbehandleren ikke ser muligheten; at API-et tillater sletting, står som tilgangsavvik |
| Ikke sjekket | – | Åpne MR-er | glab er ikke installert, så åpne MR-er er ikke listet. Det er lett i brancher med navn som peker på kravene |
| Ikke valgt i denne kjøringen | `@FLY-OPT-SAM-001` | `krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling_på_sammensatt_vitnemål.feature` (`@draft`) | bare regeltittelen i «…» er endret; fremdriften er uendret |
| Ikke valgt i denne kjøringen | – | resten av kravene | bare delene som er endret i PR #970 og #971; resultatene for resten står i rapportene fra 11:28 |
| Merknad | `@OPT-BEH-BEH-015` | `P/autosak/gsk/GskPaastandService.java:66` | sjekken på vitnemål kan bli stående som forsvarskode når importen av kompetansebevis fjernes. Avgjør om sjekken skal bort, eller bare kommentarene |
| Merknad | – | koden for kompetansebevis | spor som må med når koden fjernes, utenom bevisene over: `P/vgs/VgsDokumentVitnemaalService.java:38-40`, `P/autosak/FerdigbehandlingService.java:92-100`, `P/autosak/gsk/GskAutomatikkAarsak.java:12`, `P/autosak/gsk/GskVedtakAutoService.java:32,47,77`, `opptak-migrations/V176__kompetanse_vgs.sql:124`, `opptak-migrations/V275__vgs_loep.sql:32`, testen `SetteGrunnlagServiceTest.java:665-678` |
| Merknad | – | Én rapport for fem scopes | delene som er endret, hører til fem scopes (import-og-start, grunnlag-og-poeng, gsk-konklusjon, kvalifisering-og-poengsum, ferdigbehandling). Rapporten ligger i scopet med flest endringer |
