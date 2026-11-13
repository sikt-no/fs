# Verifisering: GSK ved import, tilleggspoeng og mangeltekster i Automatisk saksbehandling (@FLY-OPT-AUT-001)

- **Dato:** 2026-11-12 11:39
- **Krav:** delene tre faser i `@FLY-OPT-AUT-001` bygger på, og som ikke er `@implemented` (3 feature-filer): `@OPT-BEH-BEH-015` Scenario: Automatikken kan sette en ny konklusjon etter annulleringen, `@OPT-BEH-BEH-036` Regel: Saken får automatiske mangeltekster når søkeren ikke er kvalifisert, og `@OPT-BEH-BEH-028` Regel: Poeng for høyere utdanning regnes ut fra søkerens studiepoeng
- **Kode:** `fs-plattform` (origin/main, 56f4f1080a, oppdatert), `fs-admin` (origin/main, 1033997f4, oppdatert). Lest fra origin/main. Kravrepoet: krav/verify-aut-001-2026-11-12, f067a72a
- **Repoer:** P = fs-plattform, A = fs-admin, M = min-kompetanse · ✓ funnet, ✗ mangler, ~ delvis eller usikker, – ikke relevant
- **Åpne MR-er:** 1 i fs-plattform med kode for kravene (!6728)
- **Omfang:** delene av kravene som fasene «Søknaden får GSK-konklusjonen når vitnemålet importeres fra KREG», «Søknaden får tilleggspoeng når grunnlaget er satt» og «Saken får mangeltekster når kravelementene er vurdert» bygger på (fra prompten). For `@OPT-BEH-BEH-028` er utregningen verifisert, ikke importen, som eies av `@OPT-BEH-BEH-038` (fra prompten)
- **Avhengigheter:** ingen
- **Kontroll:** `fs-verify-kontroll` for `@OPT-BEH-BEH-028`. Resultatene for `@OPT-BEH-BEH-015` og `@OPT-BEH-BEH-036` er ikke kontrollert, og ingenting i dem er retagget
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Skjermbilder:** nei

Gating-sett: scenarioene i delene over som ikke er tagget `@draft`, `@deprecated`, `@demo` eller `@implemented` (de leverte scenarioene i delene er ikke sjekket på nytt).

Stiene er forkortet:

- `os/` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/`
- `mig/` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/`
- `PS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/poeng/PoengService.java`
- `MKB` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvalifisering/ManglendeKravBeregner.java`
- `MKT` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvalifisering/ManglendeKravTekstService.java`

## Oppsummering

Tallene for hele kjøringen, regnet ut fra tabellene under.

- Scenarioer: 7 funnet, 3 ikke funnet, 2 usikker, av 12
- Mangler: fs-plattform 5 scenarioer, fs-admin 1, min-kompetanse 1
- Forslag: 0 kan leveres, 1 delvis levert, 0 kan slettes, 2 kan leveres når det er avklart, 2 blir stående
- Tilgang og datakonsistens: 0 stemmer, 0 avviker, 0 ikke funnet, 0 usikker, av 0 (ikke sjekket: delene handler om automatikken, ikke om roller)
- Regler i koden uten scenario: 0
- Åpne spørsmål: 0 regler og 0 scenarioer i gating-settet, 0 utenfor gating (`@draft`)
- Endringer gjort: 0 krav og 7 deler fikk ny status, 0 filer og 0 blokker slettet

## Forslag til endringer

Hva som kan endres i kravene, ut fra resultatene. *Kan leveres* og *Delvis levert* er sikre: alle scenarioene er funnet, og kontrollen har bekreftet hver rad. De settes i kjøringen når brukeren sier ja (se `## Endringer`). Resten må avklares: gi rapporten tilbake til `fs-verify`.

**Delvis levert**

- `@OPT-BEH-BEH-028` — Automatiske tilleggspoeng (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatiske_tilleggspoeng.feature`, 7/8 funnet i regelen): `@implemented` på Scenariomal: Poeng for høyere utdanning (linje 90) og 6 scenarioer til i Regel: Poeng for høyere utdanning regnes ut fra søkerens studiepoeng (linje 79) `[P ✓ · A ✓]` — bygger på `@OPT-BEH-BEH-038`, som er `@draft`

**Kan leveres når det er avklart**

- `@OPT-BEH-BEH-028` — Regel: Poeng for høyere utdanning regnes ut fra søkerens studiepoeng (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatiske_tilleggspoeng.feature:79`): kan få `@implemented` hvis resultatene fra høyere utdanning bare har beståtte emner — «Bare beståtte emner teller» (`krav/…/automatiske_tilleggspoeng.feature:119`) er `usikker` `[P ~ · A –]`: `PS:278-289` filtrerer ikke på bestått · mangler i fs-plattform (1)
- `@OPT-BEH-BEH-036` — Scenario: Mangelteksten viser kravelementene som ikke er oppfylt, ordnet etter kravlistene (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatiske_mangler.feature:71`): kan få `@implemented` hvis «under kravlisten» betyr at teksten er gruppert, ikke at navnet på kravlisten står i teksten — `usikker` `[P ~ · A –]`: `MKT:112-134` viser bare kravelementene · mangler i fs-plattform (1)

**Blir stående**

- `@OPT-BEH-BEH-015` — Automatisk GSK-konklusjon (`@in-progress`, 0/1 funnet): «Automatikken kan sette en ny konklusjon etter annulleringen» er ikke funnet: en annullert konklusjon stopper automatikken · mangler i fs-plattform (1)
- `@OPT-BEH-BEH-036` — Automatiske mangler (`@in-progress`, 0/3 funnet i regelen): saksbehandleren ser ikke den automatiske mangelteksten, og søkeren ser den ikke når saken blir behandlet (MR !6728) · mangler i fs-plattform (3), fs-admin (1), min-kompetanse (1)

## Endringer

Det som er endret i kravfilene og i resultatet: i kjøringen (det sikre, når brukeren sa ja) og i gjennomgangen av rapporten.

| Feature-ID | Egenskap eller del | Endring | Avklart |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-028` | Scenariomal: Poeng for høyere utdanning, og Scenario: Poengene for høyere utdanning viser hvor mange studiepoeng de er regnet ut for, Søker uten resultater fra høyere utdanning får 0 poeng, Fagskolepoeng teller ikke, Innpassede emner telles bare én gang, Innpassede emner telles med studiepoengene fra lærestedet der de ble tatt, Studiepoengene telles når poengene regnes ut | `@implemented` på delen (7 scenarioer) | Funnet i utregningen og bekreftet av kontrollen. Regelen bygger på `@OPT-BEH-BEH-038` (`@draft`). Skal utregningen få `@implemented` selv om importen ikke er levert? Ja |

## Oversikt per krav

Hvor mange scenarioer som er funnet i hvert krav, og hvor mange som mangler i hvert repo.

| Feature-ID | Egenskap | Funnet | Mangler i P | Mangler i A | Mangler i M | Hva som gjenstår |
| --- | --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-015` | Automatisk GSK-konklusjon | 0/1 | 1 | – | – | En annullert konklusjon må ikke stoppe automatikken |
| `@OPT-BEH-BEH-036` | Automatiske mangler | 0/3 | 3 (1 usikker) | 1 | 1 | Kravlistene i teksten, mangelteksten for saksbehandleren, og publisering (MR !6728) |
| `@OPT-BEH-BEH-028` | Automatiske tilleggspoeng | 7/8 | 1 (1 usikker) | – | – | Bestått-filteret, og importen (`@OPT-BEH-BEH-038`) |

Mangler: fs-plattform 5 scenarioer i 3 krav, fs-admin 1 i 1 krav, min-kompetanse 1 i 1 krav. Alle kravene mangler noe.

`Funnet` er scenarioene som er funnet i alle repoene de gjelder, av alle scenarioene i kravet. `Mangler i P`, `A` og `M` er scenarioene som ikke er funnet i repoet (`ikke funnet` eller `usikker`). Et scenario som mangler i flere repoer, telles i hvert av dem. `–` betyr at ingen scenarioer i kravet gjelder repoet.

## Fremdrift for flyter

Hvilke faser i flyten som er levert, ut fra statusen på delene av kravene fasen bygger på.

| Flyt | Fase | Bygger på | Fase levert |
| --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Søknaden får GSK-konklusjonen når vitnemålet importeres fra KREG | `@OPT-BEH-BEH-015` (`@in-progress`, Regel: Automatikken setter bare positive konklusjoner, og bare der ingen finnes ikke levert), `@OPT-BEH-BEH-027` (`@implemented`) | nei |
| `@FLY-OPT-AUT-001` | Søknaden får tilleggspoeng når grunnlaget er satt | `@OPT-BEH-BEH-028` (`@in-progress`, Regel: Poeng for høyere utdanning regnes ut fra søkerens studiepoeng ikke levert: 7 av 8 scenarioer `@implemented`) | nei |
| `@FLY-OPT-AUT-001` | Saken får mangeltekster når kravelementene er vurdert | `@OPT-BEH-BEH-036` (`@in-progress`, Regel: Saken får automatiske mangeltekster når søkeren ikke er kvalifisert ikke levert) | nei |

`@FLY-OPT-AUT-001`: ingen av de tre fasene blir levert i denne kjøringen. Flyten har fortsatt 11 av 19 faser levert.

## Scenarioer

Resultatet for hvert scenario i gating-settet etter kontrollen, med beviset i koden. Tallene i rapporten regnes ut herfra, og FS Kravforvaltning leser tabellen.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-015` | Automatikken kan sette en ny konklusjon etter annulleringen | ikke funnet | P ✗ · A – · M – — en annullert konklusjon er vedtakstypen `KVALIFISERT_MEN_ANNULLERT` (`os/soknad/gskvedtak/GskVedtakService.java:60`), som er blant de gjeldende vedtakstypene (`os/soknad/gskvedtak/GskVedtakConditions.java:14-15`). Automatikken stopper da med «gjeldende vedtak finnes» (`os/autosak/gsk/GskVedtakAutoService.java:69-70,245-252`). Kravet sier at en annullert konklusjon regnes som ingen konklusjon. Ingen åpen MR funnet (søkt etter «annull» og «gsk») |
| `@OPT-BEH-BEH-036` | Mangelteksten viser kravelementene som ikke er oppfylt, ordnet etter kravlistene | usikker | P ~ · A – · M – — teksten har bare kravelementene som mangler, og én tekst per kompetanseregelverk (`MKB:28-53,64-70`), men kravlistene får ikke navn i teksten, og en kravliste med ett element som mangler, slås sammen med elementet (`MKT:112-134`). Eksempelet gir «Ett av følgende: Matematikk R2, Fysikk 2». Uklart om «under kravlisten» krever navnet på kravlisten |
| `@OPT-BEH-BEH-036` | Saksbehandleren ser de automatiske mangeltekstene sammen med de registrerte manglene | ikke funnet | P ✗ · A ✗ · M – — manglerkortet i FS Admin henter bare `Sak.mangler` (`fs-admin/src/domains/soknadsbehandling/features/SakDrawer/components/ManglerCard/queries.ts:3-50`). Den automatiske teksten ligger i `sak_kvalifikasjonsgrunnlag.manglende_krav_*`, og ingen del av saksbehandler-API-et viser den; søkt etter «manglendeKrav», «mangeltekst» og «automatiskMangel» i skjemaet og i FS Admin |
| `@OPT-BEH-BEH-036` | Søkeren ser de automatiske mangeltekstene når saken er ferdig behandlet | ikke funnet | P ✗ · A – · M ~ — ikke funnet på main: søkeren ser bare publiserte tekster (`mig/V514__behandlingsstatus_fjern_ferdig_behandlet.sql:176`), og bare saksbehandleren publiserer (`os/saksbehandling/SakMangelService.java:311-324`). Finnes i MR !6728 (åpen, fs-plattform, solov/mangler-publiseres): publisering når saken blir behandlet. min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-028` | Bare beståtte emner teller | usikker | P ~ · A – · M – — `PS:278-289` filtrerer ikke på bestått, bare på «Innpasset», og importen lagrer resultatet uten filter (`os/vitnemalsportalen/ElmoMapper.java:182`). Testdataene fra Vitnemålsportalen har bare beståtte resultater, men det er ikke bevist at kilden bare gir beståtte emner |
| `@OPT-BEH-BEH-028` | Poeng for høyere utdanning | funnet | P ✓ · A – · M – — `os/regelverk/poeng/HoyereUtdanningspoengAlgoritme.java:9`, `os/regelverk/poeng/HoyereUtdanningspoeng.java:12-17`, `os/regelverk/poeng/AlgoritmepoengService.java:87-88`, `PS:126-135` |
| `@OPT-BEH-BEH-028` | Poengene for høyere utdanning viser hvor mange studiepoeng de er regnet ut for | funnet | P ✓ · A ✓ · M – — `PS:131-133`, `os/regelverk/poeng/HoyereUtdanningspoeng.java:19-21`; A `fs-admin/src/domains/soknadsbehandling/features/PoengberegningCard/PoengberegningCardRow/PoengberegningCardRow.tsx:199,227-239` |
| `@OPT-BEH-BEH-028` | Søker uten resultater fra høyere utdanning får 0 poeng | funnet | P ✓ · A – · M – — `PS:279` |
| `@OPT-BEH-BEH-028` | Fagskolepoeng teller ikke | funnet | P ✓ · A – · M – — `PS:285-286` |
| `@OPT-BEH-BEH-028` | Innpassede emner telles bare én gang | funnet | P ✓ · A – · M – — `PS:33,287` |
| `@OPT-BEH-BEH-028` | Innpassede emner telles med studiepoengene fra lærestedet der de ble tatt | funnet | P ✓ · A – · M – — `PS:287` |
| `@OPT-BEH-BEH-028` | Studiepoengene telles når poengene regnes ut | funnet | P ✓ · A – · M – — `PS:128,278-289` |

## Åpne MR-er og brancher

MR-er og brancher som ser ut til å levere kravene. Koden i disse er ikke merget, og regnes ikke som levert.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-plattform` | [!6728 STEK-665: Publiser manglene når saken blir behandlet](https://gitlab.sikt.no/fs/fs-plattform/-/merge_requests/6728) (`solov/mangler-publiseres`) | åpen | `@OPT-BEH-BEH-036` | 1/3 | bare publiseringen; ikke mangelteksten for saksbehandleren |

## Andre funn

Det som må følges opp, og som ikke står i de andre tabellene: det kravet ikke sier, det kontrollen rettet, spørsmålene, og det som ikke ble sjekket. Én rad per funn, sortert etter type og så i rekkefølgen kravene står i.

| Type | Feature-ID | Gjelder | Hva |
| --- | --- | --- | --- |
| Bygger på krav som ikke er levert | `@OPT-BEH-BEH-028` | Regel: Poeng for høyere utdanning regnes ut fra søkerens studiepoeng (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatiske_tilleggspoeng.feature:79`) | bygger på `@OPT-BEH-BEH-038` (`@draft`). Importen fra Vitnemålsportalen finnes (`os/vitnemalsportalen/VitnemalsportalenService.java`), men kalles ikke fra noe sted på main, bare fra en enhetstest. Ingenting skriver studiepoeng til opptak, så alle søkere får 0 poeng for høyere utdanning |
| Ikke sjekket | – | min-kompetanse | Klonen finnes ikke lokalt. Scenarioene der søkeren ser noe i Min kompetanse, har M ~ |
| Merknad | `@OPT-BEH-BEH-028` | Algoritmen for høyere utdanning | `HOY_ALG1` er ikke lagt inn i `regelverk.poengalgoritme` på main, og fremmednøkkelen på poengtypen (`mig/V4__regelverk.sql:587-588`) gjør at ingen poengtype kan knyttes til den. Det er med vilje: «HOY_ALG1 er bevisst ikke seedet i regelverket før resultatimporten finnes» (`fs-plattform/opptak/opptak-subgraph/src/test/java/no/sikt/fs/opptak/saksbehandling/PropageringHoyereUtdanningspoengIT.java:55`). `Gitt`-steget om algoritmen kan derfor ikke settes opp i noe miljø før importen er levert, og scenarioene kan ikke testes i fase 2 før da |
| Merknad | `@OPT-BEH-BEH-028` | Rader uten nivå i det norske kvalifikasjonsrammeverket | Emner uten EQF-nivå får standarden `FS-STUDIENIVÅ` (`os/vitnemalsportalen/ElmoMapper.java:197-201`), og telles ikke (`PS:285-286`). Det kan gi for få studiepoeng, men gjelder importen |
| Merknad | `@OPT-BEH-BEH-028` | «Innpassede emner telles med studiepoengene fra lærestedet der de ble tatt» | Eksempelet skiller ikke mellom tolkningene: 30, 37,5, 40 og 47,5 studiepoeng gir alle 1 poeng. Vurder andre tall med `fs-krav` |
