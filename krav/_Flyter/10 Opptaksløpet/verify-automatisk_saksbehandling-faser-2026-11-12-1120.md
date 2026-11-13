# Verifisering: tre faser i Automatisk saksbehandling (@FLY-OPT-AUT-001)

- **Dato:** 2026-11-12 11:20
- **Krav:** delene tre faser i `@FLY-OPT-AUT-001` bygger på, der koden ser ut til å finnes (4 feature-filer): `@OPT-BEH-BEH-036` Regel: Mangelen for generell studiekompetanse som fullføres i vår settes og sjekkes ut automatisk, `@OPT-BEH-BEH-025` Scenario: Den automatiske behandlingen publiserer manglene når saken blir ferdig behandlet, `@OPT-BEH-BEH-029` Regel: Saksloggen viser endringene i behandlingsstatusen, og `@OPT-BEH-BEH-026` Scenario: Søkeren ser den nye mangelteksten i en sak som er ferdig behandlet
- **Kode:** `fs-plattform` (origin/main, 56f4f1080a, oppdatert), `fs-admin` (origin/main, 1033997f4, oppdatert). Lest fra origin/main i egne arbeidskopier. Kravrepoet: krav/verify-aut-001-2026-11-12, dc7636a9
- **Repoer:** P = fs-plattform, A = fs-admin, M = min-kompetanse · ✓ funnet, ✗ mangler, ~ delvis eller usikker, – ikke relevant
- **Åpne MR-er:** 1 i fs-plattform med kode for kravene (!6728)
- **Omfang:** delene av kravene som fasene «Mangelen for GSK som fullføres i vår sjekkes ut før saken blir ferdig behandlet», «Saken blir ferdig behandlet og er klar til å være med i plasstildelingen» og «Søknadsalternativene beregnes på nytt når regelverket er rettet» bygger på, og som ikke er `@implemented` (fra prompten)
- **Avhengigheter:** ingen
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Skjermbilder:** nei

Gating-sett: scenarioene i delene over som ikke er tagget `@draft`, `@deprecated`, `@demo` eller `@implemented` (de leverte scenarioene i delene er ikke sjekket på nytt).

Stiene er forkortet:

- `os/` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/`
- `mig/` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/`
- `GMS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/GskFullforesIVarMangelSync.java`
- `FB` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/FerdigbehandlingService.java`
- `SH` = `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java`

## Oppsummering

Tallene for hele kjøringen, regnet ut fra tabellene under.

- Scenarioer: 0 funnet, 8 ikke funnet, 1 usikker, av 9
- Mangler: fs-plattform 9 scenarioer, fs-admin 2, min-kompetanse 3 (3 usikker)
- Forslag: 0 kan leveres, 0 delvis levert, 0 kan slettes, 0 kan leveres når det er avklart, 4 blir stående
- Tilgang og datakonsistens: 0 stemmer, 0 avviker, 0 ikke funnet, 0 usikker, av 0 (ikke sjekket: delene handler om automatikken, ikke om roller)
- Regler i koden uten scenario: 1
- Åpne spørsmål: 0 regler og 0 scenarioer i gating-settet, 0 utenfor gating (`@draft`)

## Forslag til endringer

Hva som kan endres i kravene, ut fra resultatene. *Kan leveres* og *Delvis levert* er sikre: alle scenarioene er funnet, og kontrollen har bekreftet hver rad. De settes i kjøringen når brukeren sier ja (se `## Endringer`). Resten må avklares: gi rapporten tilbake til `fs-verify`.

**Blir stående**

- `@OPT-BEH-BEH-036` — Regel: Mangelen for generell studiekompetanse som fullføres i vår settes og sjekkes ut automatisk (`@in-progress`, 0/6 funnet): mangelen settes, slettes og sjekkes ut (`GMS:45-101`, `FB:68,222-236`), men saksloggen fylles ikke (3 scenarioer), varselet til opptaksforvalteren finnes ikke (2), og søkeren ser ikke mangelen mens saken er Ikke behandlet (1) · mangler i fs-plattform (6), fs-admin (2), min-kompetanse (1)
- `@OPT-BEH-BEH-029` — Regel: Saksloggen viser endringene i behandlingsstatusen (`@in-progress`, 0/1 funnet): saksloggen fylles ikke etter `mig/V480__stopp_endringslogg.sql` · mangler i fs-plattform (1)
- `@OPT-BEH-BEH-026` — Scenario: Søkeren ser den nye mangelteksten i en sak som er ferdig behandlet (`@in-progress`, 0/1 funnet): en ny mangeltekst blir ikke publisert; bare i MR !6728 · mangler i fs-plattform (1), min-kompetanse (1)
- `@OPT-BEH-BEH-025` — Scenario: Den automatiske behandlingen publiserer manglene når saken blir ferdig behandlet (`@in-progress`, 0/1 funnet): bare i MR !6728 · mangler i fs-plattform (1), min-kompetanse (1)

## Oversikt per krav

Hvor mange scenarioer som er funnet i hvert krav, og hvor mange som mangler i hvert repo.

| Feature-ID | Egenskap | Funnet | Mangler i P | Mangler i A | Mangler i M | Hva som gjenstår |
| --- | --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-036` | Automatiske mangler | 0/6 | 6 (1 usikker) | 2 | 1 (1 usikker) | Saksloggen, varselet til opptaksforvalteren, og at søkeren ser mangelen |
| `@OPT-BEH-BEH-029` | Behandlingsstatus | 0/1 | 1 | – | – | Saksloggen |
| `@OPT-BEH-BEH-026` | Beregne automatisk på nytt | 0/1 | 1 | – | 1 (1 usikker) | Publiseringen av den nye mangelteksten (MR !6728) |
| `@OPT-BEH-BEH-025` | Ferdigbehandle en sak | 0/1 | 1 | – | 1 (1 usikker) | Publiseringen av manglene (MR !6728) |

Mangler: fs-plattform 9 scenarioer i 4 krav, fs-admin 2 i 1 krav, min-kompetanse 3 i 3 krav (3 usikker). Alle kravene mangler noe.

`Funnet` er scenarioene som er funnet i alle repoene de gjelder, av alle scenarioene i kravet. `Mangler i P`, `A` og `M` er scenarioene som ikke er funnet i repoet (`ikke funnet` eller `usikker`). Et scenario som mangler i flere repoer, telles i hvert av dem. `–` betyr at ingen scenarioer i kravet gjelder repoet.

## Fremdrift for flyter

Hvilke faser i flyten som er levert, ut fra statusen på delene av kravene fasen bygger på.

| Flyt | Fase | Bygger på | Fase levert |
| --- | --- | --- | --- |
| `@FLY-OPT-AUT-001` | Mangelen for GSK som fullføres i vår sjekkes ut før saken blir ferdig behandlet | `@OPT-BEH-BEH-036` (`@in-progress`, Regel: Opptaksforvalteren merker én mangelkode for generell studiekompetanse som fullføres i vår levert, Regel: Mangelen for generell studiekompetanse som fullføres i vår settes og sjekkes ut automatisk ikke levert) | nei |
| `@FLY-OPT-AUT-001` | Saken blir ferdig behandlet og er klar til å være med i plasstildelingen | `@OPT-BEH-BEH-025` (`@in-progress`, Regel: Den automatiske behandlingen setter saken til ferdig behandlet når alt er avgjort ikke levert), `@OPT-BEH-BEH-029` (`@in-progress`, Regel: Saken kan bare bli Behandlet … levert, Regel: Saksloggen viser endringene i behandlingsstatusen ikke levert) | nei |
| `@FLY-OPT-AUT-001` | Søknadsalternativene beregnes på nytt når regelverket er rettet | `@OPT-BEH-BEH-026` (`@in-progress`, Regel: Bare saker som er ferdig behandlet, beregnes på nytt ikke levert; de to andre reglene i «…» levert) | nei |

`@FLY-OPT-AUT-001`: ingen av de tre fasene blir levert i denne kjøringen. Flyten har fortsatt 11 av 19 faser levert.

## Scenarioer

Resultatet for hvert scenario i gating-settet etter kontrollen, med beviset i koden. Tallene i rapporten regnes ut herfra, og FS Kravforvaltning leser tabellen.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-036` | Alle sakene i søknaden får mangel når søkeren oppgir at generell studiekompetanse fullføres i vår | ikke funnet | P ~ · A ~ · M – — mangelen settes på alle sakene (`GMS:45-91`, kalt fra `SH:334`), men saksloggen fylles ikke: `mig/V480__stopp_endringslogg.sql` fjerner audit-triggerne, og ingen senere migrasjon gjeninnfører dem. FS Admin viser endringsloggen (`fs-admin/src/domains/soknadsbehandling/features/AuditLogCard/AuditLogCard.tsx:23`), men den får ikke nye rader |
| `@OPT-BEH-BEH-036` | Saken får ikke mangel når ingen mangelkode er merket | ikke funnet | P ~ · A ~ · M – — ingen mangel uten merket mangelkode (`GMS:38-40`), men varselet til opptaksforvalteren finnes ikke. FS Admin har bare en fast advarsel på mangelkodene når ingen kode er merket (`fs-admin/src/domains/regelverk/features/Mangelkoder/MangelkoderOverview.tsx:56`), ikke et varsel når en søknad ikke får mangelen; søkt etter «varsel», «advarsel», «notifikasjon» i P og A |
| `@OPT-BEH-BEH-036` | Opptaksforvalteren får varselet bare første gang | ikke funnet | P ✗ · A ✗ · M – — varselet finnes ikke (se over). Varslingen i `kommunikasjon` gjelder e-post og SMS til personer, og brukes ikke her |
| `@OPT-BEH-BEH-036` | Søkeren ser den automatiske mangelen i Min kompetanse | usikker | P ~ · A – · M ~ — mangelen settes som klar til publisering (`GMS:70,82`), men `soknadsmangel` viser bare saker som er Under behandling eller Behandlet (`mig/V514__behandlingsstatus_fjern_ferdig_behandlet.sql:16-23`), og en ny sak er Ikke behandlet. I den helautomatiske behandlingen sjekkes mangelen ut før saken blir Behandlet (`FB:68`), og en utsjekket mangel vises ikke. Søkeren ser den bare når saksbehandleren har satt saken til Under behandling. min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-036` | Mangelen slettes når søkeren endrer søknaden | ikke funnet | P ~ · A – · M – — mangelen slettes når den er automatisk og ikke sjekket ut (`GMS:92-101`), men saksloggen fylles ikke (`mig/V480__stopp_endringslogg.sql`) |
| `@OPT-BEH-BEH-036` | Mangelen sjekkes ut når saken er behandlet helautomatisk | ikke funnet | P ~ · A – · M – — mangelen sjekkes ut før saken blir Behandlet (`FB:68,222-236`), men saksloggen fylles ikke (`mig/V480__stopp_endringslogg.sql`) |
| `@OPT-BEH-BEH-029` | Saksloggen viser endring av behandlingsstatus når <årsak> | ikke funnet | P ✗ · A – · M – — ingen logg skrives når statusen endres (`FB:69-72`), og audit-triggerne er fjernet (`mig/V480__stopp_endringslogg.sql`); søkt etter andre loggtabeller (`insertInto` på logg, historikk og hendelse) uten treff. `sak.status_automatisk_behandlet` (GraphQL `erBehandletAutomatisk`) sier at automatikken satte saken til Behandlet, men ikke når, eller fra og til hvilken status |
| `@OPT-BEH-BEH-026` | Søkeren ser den nye mangelteksten i en sak som er ferdig behandlet | ikke funnet | P ✗ · A – · M ~ — ikke funnet på main: en ny mangeltekst får `status_kan_publiseres = false` (`os/regelverk/kvalifisering/KvalifiseringOppdateringService.java:199-210`), bare `os/saksbehandling/SakMangelService.java:311-324` publiserer den, og `soknadsmangel` viser bare publiserte (`mig/V514__behandlingsstatus_fjern_ferdig_behandlet.sql:176`). Finnes i MR !6728 (åpen, fs-plattform, solov/mangler-publiseres): publisering i en sak som er Behandlet. min-kompetanse ikke sjekket |
| `@OPT-BEH-BEH-025` | Den automatiske behandlingen publiserer manglene når saken blir ferdig behandlet | ikke funnet | P ✗ · A – · M ~ — ikke funnet på main: `FB:62-79` setter saken til Behandlet uten å publisere, og bare den manuelle publiseringen i `os/saksbehandling/SakMangelService.java:283-330` publiserer og sender melding. Finnes i MR !6728 (åpen, fs-plattform, solov/mangler-publiseres): `ManglerPublisering.publiserAlleOgVarsle` etter statusoppdateringen i `FB`. min-kompetanse ikke sjekket |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker. Input til testplanen og den agentiske testen (fase 2). Lista har det som ble sett under letingen, og er ikke fullstendig.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-036` | Mangelen settes ikke når mangelkoden som er merket for generell studiekompetanse som fullføres i vår, er inaktiv | tilstandsovergang | `GMS:51-53` | legg til scenario med `fs-krav` |

## Åpne MR-er og brancher

MR-er og brancher som ser ut til å levere kravene. Koden i disse er ikke merget, og regnes ikke som levert.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-plattform` | [!6728 STEK-665: Publiser manglene når saken blir behandlet](https://gitlab.sikt.no/fs/fs-plattform/-/merge_requests/6728) (`solov/mangler-publiseres`) | åpen | `@OPT-BEH-BEH-025`, `@OPT-BEH-BEH-026` | 2/2 | ingen sakslogg og ikke noe varsel til opptaksforvalteren |

## Andre funn

Det som må følges opp, og som ikke står i de andre tabellene: det kravet ikke sier, det kontrollen rettet, spørsmålene, og det som ikke ble sjekket. Én rad per funn, sortert etter type og så i rekkefølgen kravene står i.

| Type | Feature-ID | Gjelder | Hva |
| --- | --- | --- | --- |
| Ikke sjekket | – | min-kompetanse | Klonen finnes ikke lokalt. Scenarioene der søkeren ser noe i Min kompetanse, har M ~ |
| Merknad | `@OPT-BEH-BEH-036` | Saksloggen (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatiske_mangler.feature:232,262,283`) | Saksloggen ble slått av i `mig/V480__stopp_endringslogg.sql`. Det samme gjelder `@OPT-BEH-BEH-029` (`behandlingsstatus.feature:139`). Avklar med `fs-krav` om saksloggen fortsatt skal stå i kravene; så lenge stegene står, kan ingen av fasene bli levert |
| Merknad | `@OPT-BEH-BEH-036` | «Søkeren ser den automatiske mangelen i Min kompetanse» (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatiske_mangler.feature:246`) | Mangelen sjekkes ut før saken blir Behandlet i den helautomatiske behandlingen, så søkeren ser den aldri da. Avklar om søkeren skal se mangelen også når saken behandles helautomatisk |
