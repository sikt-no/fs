# Task #9 Completion Report: GraphQL, lesing: `IdPortenBruker`, `idPortenBrukere` og `tilganger`

## Status: ✅ COMPLETED

**Date Completed**: 2026-09-25
**Task**: GraphQL, lesing: `IdPortenBruker`, `idPortenBrukere` og `tilganger`
**Priority**: High
**Size**: L

## Summary
Op #1 og Op #2 er implementert i en ny sone nederst i `schema_brukeradmin.graphqls`: typene
`IdPortenBruker` (20022) og `IdPortenBrukerTilgang` (20023), `Query.idPortenBrukere` med filter og
sortering, og `IdPortenBruker.tilganger`. Navnet kommer fra et nytt security_invoker-view,
`personsubjekt_med_navn` (0085). Viewet har én rad per person med gjeldende `subjektnavn`-rad og er
tabellen til `IdPortenBruker`. Synligheten ligger i RLS. Nytt pgTAP-sett 76 (14 assertions) og en
ny GraphQL-testklasse (10 tester) er grønne.

## Files Created
### 1. `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0085-personsubjekt-med-navn.sql` (44)
Et changeset, `tilgangsstyring:0085-view-personsubjekt-med-navn`. Viewet
`personsubjekt_med_navn WITH (security_invoker = true)` er `personsubjekt LEFT JOIN subjektnavn`
på gjeldende rad (`invalidert_tidspunkt IS NULL AND gyldig_periode @> now()`, høyst én rad takket
være WITHOUT OVERLAPS). Kolonnene er `subjekt_id`, `fodselsnummer` (bare for eksakt søk),
`fornavn`, `etternavn`, `sortering_etternavn` og `sortering_fornavn`. De to siste er
`coalesce(lower(...), '')`. Viewet har COMMENT og `GRANT SELECT` til app-rollen.
### 2. `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/test/sql/76_personsubjekt_med_navn.sql` (142, 14 assertions)
- DEL 1: viewet finnes, er security_invoker, og app-rollen har SELECT.
- DEL 2: én rad per synlig person, også den uten navn. Bare det gjeldende navnet vises, ikke en
  lukket rad. Sorteringsnøklene er navnet i små bokstaver, og tom streng uten navn. Fødselsnummeret
  er med.
- DEL 3: en annen organisasjon gir ikke innsyn, og heller ikke riktig organisasjon i et annet miljø.
  Feide-nøklene gir ikke innsyn. PERSON_SKRIV gir samme innsyn som på `personsubjekt`. Eieren ser
  alle tre (kontroll).
### 3. `fs-plattform/tilgangsstyring/tilgangsstyring-service/src/main/java/no/sikt/fs/tilgangsstyring_service/IdPortenBrukereFilterConditions.java` (112)
- `fodselsnummer`: eksakt `eq`.
- `navnContains`: case-insensitiv delstreng i fornavn, etternavn eller «fornavn etternavn».
- `organisasjoner` / `miljoer`: dekoder node-ID-er og gjør EXISTS mot aktive tildelinger, som
  `FeideBrukereFilterConditions`.
### 4. `fs-plattform/tilgangsstyring/tilgangsstyring-service/src/main/java/no/sikt/fs/tilgangsstyring_service/IdPortenBrukerTilgangerFilterConditions.java` (26)
`tilgangskodeContains` over arv-viewet. Klassen er egen av samme grunn som Feide-varianten har sin.
### 5. `fs-plattform/tilgangsstyring/tilgangsstyring-app/src/test/java/no/sikt/fs/tilgangsstyring/IdPortenBrukereQueryTest.java` (398, 10 tester)
Se Test Results.

## Files Modified
### 1. `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/db-changelog-root.xml`
Include for 0085 etter 0084, med en kommentar om avhengigheten til 0080.
### 2. `fs-plattform/tilgangsstyring/tilgangsstyring-new-jooq/pom.xml`
Syntetisk PK `personsubjekt_med_navn(subjekt_id)` og syntetisk FK `fk_psmn_subjekt`
(`personsubjekt_med_navn.subjekt_id` → `subjekt`). FK-en har én kolonne, som de andre syntetiske
subjekt-FK-ene.
### 3. `fs-plattform/tilgangsstyring/tilgangsstyring-app/src/main/resources/schema/features/experimental/schema_brukeradmin.graphqls`
Ny sone «--- ID-porten-brukere --- personer uten Feide» (fra linje 597):
- `type IdPortenBruker implements Node @table(name: "personsubjekt_med_navn") @node(typeId: "20022", keyColumns: ["SUBJEKT_ID"])`
  med `id`, `fornavn` og `etternavn`. Begge navnene er nullable.
- `Query.idPortenBrukere(filter, orderBy)`: `@asConnection(defaultFirstValue: 100)`,
  `@defaultOrder` på `SORTERING_ETTERNAVN, SORTERING_FORNAVN, SUBJEKT_ID`.
- `IdPortenBrukereFilterInput`: `fodselsnummer`, `navnContains`, `organisasjoner`, `miljoer`, alle
  som `@condition(override: true)`.
- `IdPortenBrukereOrderByInput` / `IdPortenBrukereOrderByFieldInput { ETTERNAVN }`.
- `type IdPortenBrukerTilgang implements Node @table(name: "subjektrolletildeling_med_arv") @node(typeId: "20023", ...)`,
  felt for felt som `FeideBrukerTilgang`.
- `IdPortenBruker.tilganger`: `@asConnection(defaultFirstValue: 10) @defaultOrder(ROLLEKODE) @splitQuery`
  og `@reference(path: [personsubjekt_med_navn__fk_psmn_subjekt, subjektrolletildeling_med_arv__fk_srt_med_arv_subjekt])`.
- `IdPortenBrukerTilgangerFilterInput` (rolletype, tilknytning, tilgangskodeContains,
  organisasjoner og miljoer med `@nodeId`) og `IdPortenBrukerTilgangerOrderByInput` / `…FieldInput { TILGANGSKODE }`.

Ingen Feide-typer, -inputs eller -condition-klasser er gjenbrukt. De eneste som deles er
grunnmuren (`Rolletype`, `RolletypeInput`, `Tilknytning`, `TilknytningInput`) og `tildeltAv: FeideBruker`.
Administratorene er Feide-brukere (funn 9).

## Key Features Implemented
### ✅ Personsøket med synlighet fra RLS
`totalCount` og `pageInfo` følger `personsubjekt_les`. En Feide-administrator får 0, og et
node-oppslag gir null.
### ✅ Navnet fra gjeldende `subjektnavn`-rad
Viewet velger bare den gjeldende raden, og en person uten navn forsvinner ikke.
### ✅ Eksakt fødselsnummersøk uten at nummeret returneres
Nummeret er ikke et felt på typen. Testen sjekker at ingen av fiksturnumrene står i svaret.
### ✅ Tilgangslisten med arv, filtrert av RLS
Tildelinger i en annen organisasjon hverken vises eller telles.
### ✅ Sortering på etternavn med stabil paginering
NULL-fri sorteringsnøkkel og `SUBJEKT_ID` som tie-breaker.

## Project skills consulted
- `sta-fso-bat-utilitybelt:subgraph-expand` (og PATTERNS.md): tabellen i skillen ga subgrafreglene
  for tilgangsstyring. Liquibase-view-mønsteret, `@condition(override: true)` med null/tom-håndtering,
  `@asConnection` på Node-typer og `@orderBy` / `@defaultOrder` med flere felt ble fulgt. Skillens
  steg om spec.log.md og `subgraph-expansion-*.md` er hoppet over etter instruks, og innholdet står her.
- Graphitron MCP (`ask_graphitron_md_documentation`) fantes ikke i verktøysettet mitt. Direktivene er
  derfor verifisert mot mønstre som allerede virker i samme skjema (`FeideBruker.tilganger`,
  `feide_bruker_hjemmeorganisasjon`, flerfelt-`@defaultOrder` i `mine-tilganger.graphqls`) og mot
  koden Graphitron genererte (se Technical Decisions 2). `subgraph-plan` ble ikke kjørt separat,
  fordi planens GraphQL-seksjon (Op #1/#2) er den verifiserte planen, og formen er en speiling av
  Feide-sonen.

## Test Results
- **pgTAP (Testcontainers)**: `cd fs-plattform/tilgangsstyring && mise exec -- mvn -q -pl :tilgangsstyring-new-db test`
  → `tests="1448" errors="0" skipped="0" failures="0"`. Sett 76 gir 14/14 ok, og loggen har ingen «not ok».
- **Lokal base**: `mise run migrate` (0085 kjørt: «ran successfully») og `mise run jooq` gir BUILD SUCCESS.
  `PersonsubjektMedNavn`, `SYNTHETIC_PK_PERSONSUBJEKT_MED_NAVN` og `PERSONSUBJEKT_MED_NAVN__FK_PSMN_SUBJEKT` er generert.
- **Service**: `mise exec -- mvn -q -pl :tilgangsstyring-service test` er grønn.
- **GraphQL**: `mise exec -- mvn -q -pl :tilgangsstyring-app test -Dtest=IdPortenBrukereQueryTest`
  → 10/10. Testene:
  - `personadministratorSerEgnePersoner`: personadministratoren ser nøyaktig de tre med tildeling i
    sin organisasjon, sortert (uten navn, Aas, Nordmann), med totalCount 3. Personen som bare har
    tildeling i den andre organisasjonen er ikke med.
  - `feideAdministratorSerIkkePersonen`: FEIDEBRUKER_LES + _SKRIV gir 0 i søket og null i node-oppslaget.
  - `tilgangerViserBareEgneTildelinger`: Nordmanns liste er IT9P_LES (ARVET, arvetFra [IT9P_ROLLE])
    og IT9P_ROLLE (DIREKTE), med totalCount 2. IT9P_ANNEN i den andre organisasjonen er ikke med.
  - `annenOrganisasjonSerBareSine`: administratoren i den andre organisasjonen ser Nordmann og Skjult,
    og i Nordmanns liste bare IT9P_ANNEN.
  - `tilgangsfiltre`, `fodselsnummerFilterErEksakt` (eksakt treff, delstreng gir 0, usynlig person
    gir 0), `navnContainsFilter` (fornavn, etternavn, fullt navn, usynlig navn gir 0),
    `organisasjonsOgMiljofilter`, `fodselsnummeretReturneresIkke`.
  - `pagineringOgSortering`: `first: 1` stopper på personen uten navn, og `after` fortsetter med
    Aas og Nordmann. DESC snur rekkefølgen.
- **Hele app-suiten**: `mise exec -- mvn -q -pl :tilgangsstyring-app test` → 507 tester og 2 feil.
  Begge er de kjente, urelaterte feilene (`RollekatalogForvaltningGraphqlTest.tildelingKunITestAvvises`,
  `SamlingstildelingerGraphqlTest.samlingTilgangerFilterKanter`). Suiten kjørte også
  `IdPortenBrukereQueryTest` en gang til mot den allerede seedede basen, og den var grønn. Det viser
  at seedingen er idempotent.

## Technical Decisions
### 1. `IdPortenBruker` ligger over viewet, ikke over `personsubjekt`
**Why**: planen skisserte `@table(name: "personsubjekt")` med navnet «via gjeldende subjektnavn-rad».
Standardsorteringen er etternavn, og i generert kode sorterer og filtrerer Graphitron bare på
kolonner i typens egen tabell (`orderBy`/`seek` på `personsubjektMedNavnTable.*`). Med viewet som
tabell blir sortering, `navnContains` og navnefeltene rene kolonneoppslag. RLS gjelder uendret
fordi viewet er security_invoker (festet i sett 76).
### 2. Sorteringsnøkler som aldri er NULL
**Why**: markøren er en jOOQ-`seek`, altså en radsammenligning (`ConnectionHelper.decodeCursor` gir
`DSL.val(null)` for en NULL-verdi). En markør på en person uten gjeldende navn ville gitt en tom
neste side. `coalesce(lower(...), '')` hindrer det, og gjør sorteringen uavhengig av store og små
bokstaver. `SUBJEKT_ID` gjør rekkefølgen entydig. Testen `pagineringOgSortering` treffer nettopp
det tilfellet.
### 3. LEFT JOIN mot navnet
**Why**: en person med tildelinger, men uten gjeldende navn, må fortsatt være synlig, ellers kan
ingen fjerne tildelingene hennes. Navnefeltene er derfor nullable.
### 4. `organisasjoner` / `miljoer` i personsøket med `@condition`, ikke `@nodeId`
**Why**: planens skisse brukte `@nodeId(typeName: ...)`. Det går ingen FK-sti fra personen til
organisasjon eller miljø. De finnes bare i tildelingene, som i `FeideBrukereFilterInput`, der samme
grep er dokumentert. På `tilganger`-filteret brukes `@nodeId`, som for Feide, fordi arv-viewet har
FK-ene.
### 5. Fødselsnummeret i viewet
**Why**: det gir eksakt søk som et rent kolonnepredikat. Viewet har samme RLS som tabellen. Nummeret
er ikke et felt i skjemaet og hentes derfor aldri ut av Graphitron.
### 6. Egne condition-klasser for personflaten
**Why**: flaten skal være parallell uten gjenbruk av Feide-kontraktene (analysen, og
`FeideBrukerTilgangerFilterConditions` sin begrunnelse).

## Build Status
✅ **Build successful**: pgTAP 1448/1448, `migrate` + `jooq` BUILD SUCCESS, service er installert og
testet, og Graphitron-kodegenerering + test-compile for app er grønn.
✅ **No new linter warnings**: skjemaet bygger og app-suiten er grønn bortsett fra de to kjente feilene.
✅ **All imports resolved correctly**
⚠️ `mise run build` ble ikke kjørt, etter instruks.

## Integration Points
- **Task #10** (`registrerIdPortenBruker`): payloaden returnerer `IdPortenBruker`. Servicen må slå opp
  raden i `PERSONSUBJEKT_MED_NAVN` på `SUBJEKT_ID` (typeId 20022). Etter registreringen er personen
  synlig for kalleren bare hvis hun også har PERSON_LES i paret (samme «lesereglene»-forbehold som
  Feide-payloadene).
- **Task #11** (tildel/fjern): `IdPortenBrukerTilgang` (20023) er returtypen. Bruker-id-en og
  tilgangs-id-en må dekodes i servicen (`NodeId.decode("20022", …)` / `decodeParts` for 20023),
  fordi arv-view-recorden deles av tre node-typer (åpent spørsmål 3). `IdPortenBrukerIkkeFunnet`
  er ikke definert her. Den hører til mutasjonene.
- **Task #12** (docs): `docs/tilgangsmodell.md` kan nevne at `IdPortenBruker` ligger over
  `personsubjekt_med_navn`, og at navnet er det gjeldende i `subjektnavn`.
- fs-admin: `GetIdPortenBrukere` og `GetIdPortenBruker` fra planens Lag B går mot skjemaet slik det
  står, via `tilgangsstyringNode` for detaljsiden.

## Acceptance Criteria Met
- ✅ Op #1 og Op #2 er implementert i en ny sone i `schema_brukeradmin.graphqls`. Evidens:
  `schema_brukeradmin.graphqls:596–753`.
- ✅ Navnet leses fra gjeldende `subjektnavn`-rad, gjennom et view med én rad per subjekt
  (security_invoker), så RLS gjelder. Evidens: `0085-personsubjekt-med-navn.sql`, sett 76 test 2, 4–5
  og 9–13. **Avvik fra plantekst:** viewet ligger i den nye migreringen 0085, ikke i 0080, etter
  instruks (0078–0084 har kjørt lokalt).
- ✅ `IdPortenBrukereFilterConditions` har `fodselsnummer` (eksakt) og `navnContains`. Evidens:
  `IdPortenBrukereFilterConditions.java`, testene `fodselsnummerFilterErEksakt` og `navnContainsFilter`.
- ✅ GraphQL-testene viser at en personadministrator ser egne tildelinger
  (`personadministratorSerEgnePersoner`, `tilgangerViserBareEgneTildelinger`), at en
  Feide-administrator ikke ser personen (`feideAdministratorSerIkkePersonen`), og at en tildeling i
  en annen organisasjon ikke vises (`tilgangerViserBareEgneTildelinger`, `annenOrganisasjonSerBareSine`).

## Next Steps
- Task #10 og #11 bygger på typene her.
- Åpne spørsmål fra planen står uendret: visning av fødselsnummer (fs-admin),
  `tildelingerOrganisasjoner` / `tildelingerMiljoer`-paritet (utelatt), og node-id-dekoding i Task #11.

## Conclusion
Lesesiden for ID-porten-brukere er på plass og testet mot RLS i begge retninger. Den lokale basen
har 0085 og regenerert jOOQ. Klar for review.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
