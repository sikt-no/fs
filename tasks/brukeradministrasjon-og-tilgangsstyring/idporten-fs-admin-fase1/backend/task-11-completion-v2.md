# Task #11 Completion Report: GraphQL, tildel og fjern tilganger

## Status: ✅ COMPLETED

**Date Completed**: 2026-09-25
**Task**: GraphQL, tildel og fjern tilganger
**Priority**: Medium
**Size**: M

## Summary
Op #4 and Op #5 are implemented: `tildelIdPortenBrukerTilganger` and `fjernIdPortenBrukerTilganger`,
backed by the new `IdPortenBrukerTilgangService`, which calls `tildel_persontilgang` /
`fjern_persontilgang` (0079). The new error type `IdPortenBrukerIkkeFunnet` covers unknown, invisible
and wrongly typed ids the same way. **One DB change was needed** (new migration 0086): before it, a
person stayed visible after her last tildeling was removed, which contradicts the requirement. The
new GraphQL test class (8 tests) and pgTAP set 77 (6 assertions) are green.

## Files Created
### 1. `fs-plattform/tilgangsstyring/tilgangsstyring-service/src/main/java/no/sikt/fs/tilgangsstyring_service/IdPortenBrukerTilgangService.java` (163)
A mirror of `FeideBrukerTilgangService`:
- It runs `ctx.transactionResult`, so each batch is all-or-nothing.
- It decodes `idPortenBrukerId` (20022) and `idPortenBrukerTilgangId` (20023, four parts) itself. An
  id it cannot decode throws `IdPortenBrukerIkkeFunnetException`.
- It reads the row back from `subjektrolletildeling_med_arv` using the caller's RLS.
- `oversett` maps DB errors: P0002 «personen» → IkkeFunnet, P0002 «tilgangskoden» →
  TilgangskodeIkkeFunnet, 42501 → ManglerTildelingsrett, 23001 «arvet» → ArvetTilgangKanIkkeFjernes.
  Any other error passes through untranslated.
### 2. `.../tilgangsstyring_service/IdPortenBrukerIkkeFunnetException.java` (19)
The message is fixed («Personen finnes ikke, eller du har ikke tilgang til henne.») and there is no
constructor that takes a message.
### 3. `.../tilgangsstyring_service/records/` (5 POJOs)
- `TildelIdPortenBrukerTilgangerInput`
- `FjernIdPortenBrukerTilgangerInput`
- `TildelIdPortenBrukerTilgangerPayload`
- `FjernIdPortenBrukerTilgangerPayload`
- `FjernetIdPortenBrukerTilgang`
### 4. `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0086-personsynlighet-bare-gjeldende-tildelinger.sql` (57)
`CREATE OR REPLACE` of `brukere_i_mine_person_les_organisasjoner()` and `_skriv_`. Both now count
only tildelinger with `invalidert_tidspunkt IS NULL AND upper(gyldig_periode) > now()`, meaning
current or future ones. The COMMENT is updated. GRANT/REVOKE from 0078 are kept.
### 5. `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/test/sql/77_personsynlighet_gjeldende.sql` (6 assertions)
- Current and future tildelinger give visibility. Ended and invalidated ones do not.
- The view `personsubjekt_med_navn` follows the same rule.
- `krev_personsubjekt` gives P0002 for a person who only has ended tildelinger.
- The write set is the same as the read set.
- The function privileges are unchanged.
### 6. `fs-plattform/tilgangsstyring/tilgangsstyring-app/src/test/java/no/sikt/fs/tilgangsstyring/IdPortenBrukerTilgangGraphqlTest.java` (8 tests)
See Test Results.

## Files Modified
### 1. `tilgangsstyring-app/src/main/resources/schema/features/experimental/schema_brukeradmin.graphqls`
A new block at the bottom of the ID-porten zone, after `registrerIdPortenBruker`. It follows Op #4/#5
in the plan exactly:
- Inputs: `TildelIdPortenBrukerTilgangerInput` (`idPortenBrukerId` without `@nodeId`) and
  `FjernIdPortenBrukerTilgangerInput`.
- Payloads: `TildelIdPortenBrukerTilgangerPayload`, `FjernIdPortenBrukerTilgangerPayload` and
  `FjernetIdPortenBrukerTilgang`.
- Unions (singular): `TildelIdPortenBrukerTilgangerError` and `FjernIdPortenBrukerTilgangerError`.
- `IdPortenBrukerIkkeFunnet` with three handlers: GENERIC on the exception, GENERIC on «Decoded NodeId
  did not match», and DATABASE on P0002 «personen».
- `extend type Mutation` with both `@service` fields.

There is no delete-person mutation (decision 10). A comment in the SDL says so.
### 2. `tilgangsstyring-new-db/src/main/resources/db/changelog/db-changelog-root.xml`
Include for 0086 after 0085.

## Key Features Implemented
### ✅ Assign and remove via the person functions
The mutations are idempotent both ways. The ids are `IdPortenBrukerTilgang` ids that match the
generated ones bit for bit. `fortsattEffektiv` shows an inherited tildeling after its direct one is
removed.
### ✅ The ids reveal nothing
All of these give the same response: an unknown id, an invisible person, a subject of the wrong type
(an application), a node id of the wrong type (FeideBruker, Miljo, FeideBrukerTilgang), a three-part
id, and garbage.
### ✅ Rights stay separate
Feide rights alone give `ManglerTildelingsrett`, and the response is the same for a known and an
unknown person.
### ✅ Removing the last tildeling makes the person invisible (0086)
Tildelinger in other organisations are kept.

## Project skills consulted
- `sta-fso-bat-utilitybelt:subgraph-expand`:
  - I used the subgraph table (tilgangsstyring, `.graphqls`, service package, Liquibase in
    `-new-db`) and its execution flow.
  - Op #4/#5 in the plan is the verified plan. The shape copies `tildel/fjernFeideBrukerTilganger`
    exactly, so I did not run `subgraph-plan` separately.
  - I checked the directives against the code Graphitron generated.
    `ErrorMappings.TILDEL_ID_PORTEN_BRUKER_TILGANGER_PAYLOAD = concat(MANGLER_TILDELINGSRETT, ID_PORTEN_BRUKER_IKKE_FUNNET, TILGANGSKODE_IKKE_FUNNET)`,
    and the fjern payload has the same form plus ARVET.
  - As instructed, I skipped the skill's spec.log.md and `subgraph-expansion-*.md` steps.
- The Graphitron MCP docs were not in my toolset.

## Test Results
- **pgTAP (Testcontainers)**: `cd fs-plattform/tilgangsstyring && mise exec -- mvn -q -pl :tilgangsstyring-new-db test`
  → `tests="1454" errors="0" failures="0"` (1448 before). Set 77 passes 6/6. Sets 69, 71, 72 and 76
  are still green.
- **Local DB**: `mise run migrate` ran 0086 («ran successfully»), and `mise run jooq` gave BUILD SUCCESS.
- **Service**: `mise exec -- mvn -q -o -pl :tilgangsstyring-service install` (with tests) is green.
- **GraphQL**: `mise exec -- mvn -q -o -pl :tilgangsstyring-app test -Dtest='IdPortenBrukerTilgangGraphqlTest,IdPortenBrukereQueryTest,IdPortenBrukerRegistreringGraphqlTest'`
  → 8/8, 10/10 and 8/8. The new tests:
  - `tildelOgFjernRundtur`: assign twice and remove twice, which is idempotent. Checks the id,
    `DIREKTE`, the organisation and the DB state.
  - `sisteTildelingFjernetGjorPersonenUsynlig`: after the removal, `idPortenBrukere(fodselsnummer)`
    gives 0 and `tilgangsstyringNode` gives null. The tildeling in the other organisation is still active.
  - `andreOrganisasjonersTildelingerBeholdes`: removing in her own org leaves the other org's
    tildelinger alone. Trying to remove the other org's tildeling gives `ManglerTildelingsrett`, and
    it stays.
  - `arvetTilgangKanIkkeFjernes`: an inherited tildeling gives `ArvetTilgangKanIkkeFjernes`. A direct
    tildeling that is also inherited returns `fortsattEffektiv` ARVET, with `arvetFra` set to [ROLLE].
  - `ikkeFunnetVedTildelingErUskjelnelig` and `ikkeFunnetVedFjerningErUskjelnelig`: six kinds of id
    each, all with an identical payload.
  - `feideAdministratorManglerTildelingsrett`: covers tildel and fjern. A known and an unknown person
    get the same response.
  - `ukjentTilgangskodeRullerTilbake`: gives `TilgangskodeIkkeFunnet`, and the first element in the
    batch is rolled back.
  - Every response is checked to make sure it does not contain any of the fixture numbers.
- **Idempotency**: the fixtures use fixed ids (-9635…-9639, orgs 96121/96122, fictitious numbers with
  month 89). Each test opens and closes its own preconditions as owner. The class passed twice: once
  on its own and once in the full suite.
- **Full app suite**: `mise exec -- mvn -q -o -pl :tilgangsstyring-app test` ran 523 tests with 3
  failures. All three are the known, unrelated ones: `DelegeringstakGraphqlTest.lesefeltet`,
  `RollekatalogForvaltningGraphqlTest.tildelingKunITestAvvises` and
  `SamlingstildelingerGraphqlTest.samlingTilgangerFilterKanter`.

## Technical Decisions
### 1. New migration 0086: ended tildelinger no longer give visibility
**Why**: the first run of `sisteTildelingFjernetGjorPersonenUsynlig` failed, because the person was
still visible. The cause: 0078 (Task #1) wrote `brukere_i_mine_person_les_organisasjoner` as
«bevisst uten aktivitetsfilter … så personen forblir forvaltbar», copying the Feide pattern. That
contradicts the requirement («Mister personen sin eneste tildeling … er ikke lenger synlig»,
spec-changes-2026-09-23) and this task's acceptance criterion. The filter
`upper(gyldig_periode) > now()` also keeps future-dated tildelinger visible. The Feide side is
unchanged.
**Consequences** (to review, and to document in Task #12):
- A person with no current tildelinger can no longer be reached through `tildelIdPortenBrukerTilganger`
  (IkkeFunnet). She is brought back with `registrerIdPortenBruker`, which finds her by number.
- A repeated `fjern` after the last visible tildeling gives `IdPortenBrukerIkkeFunnet` instead of an
  idempotent success.
- `personsubjekt_skriv` (DELETE outside the API) also covers only persons with current tildelinger.
### 2. The shared error types, and nothing else from Feide
`ManglerTildelingsrett`, `TilgangskodeIkkeFunnet` and `ArvetTilgangKanIkkeFjernes` are shared. All
inputs, payloads, unions, the exception and the service are separate.
### 3. The ids are decoded in the service
**Why**: three node types sit over the same view record (open question 3 in the plan, now verified).
Decoding in the service makes wrongly typed ids indistinguishable from unknown ones.

## Build Status
✅ **Build successful**: pgTAP 1454/1454, `migrate` + `jooq` BUILD SUCCESS, the service is installed,
and Graphitron codegen plus the app tests are green (apart from the known failures).
✅ **No new linter warnings**
✅ **All imports resolved correctly**
⚠️ `mise run build` was not run, as instructed.

## Integration Points
- fs-admin: `TILDEL_ID_PORTEN_BRUKER_TILGANGER` / `FJERN_ID_PORTEN_BRUKER_TILGANGER` from Lag B work
  against the schema as written.
- Task #12 (docs):
  - Document 0086: visibility follows only current and future tildelinger, and a person who is
    «fjernet» is brought back through registration.
  - The comment on `brukere_i_mine_person_les_organisasjoner` in 0078 is outdated. The DB COMMENT is
    updated by 0086.
- Owner of Task #1: the choice in 0078 («forvaltbar») is overridden by 0086. This should be confirmed
  in review.

## Acceptance Criteria Met
- ✅ Op #4 and Op #5 are implemented via `tildel_persontilgang` / `fjern_persontilgang`. Evidence:
  `IdPortenBrukerTilgangService.java` (`Routines.tildelPersontilgang` / `fjernPersontilgang`) and the
  SDL block at the bottom of `schema_brukeradmin.graphqls`.
- ✅ `IdPortenBrukerIkkeFunnet` applies to unknown, invisible and wrongly typed ids in the same way.
  Evidence: `ikkeFunnetVedTildelingErUskjelnelig` and `ikkeFunnetVedFjerningErUskjelnelig`.
- ✅ Tests cover the following:
  - The person is invisible after her last tildeling is removed: `sisteTildelingFjernetGjorPersonenUsynlig`
    and pgTAP 77, which needed 0086.
  - Tildelinger in other organisations are kept: `andreOrganisasjonersTildelingerBeholdes` and
    `sisteTildelingFjernetGjorPersonenUsynlig`.
  - An inherited tildeling cannot be removed: `arvetTilgangKanIkkeFjernes`.
  - A Feide administrator gets `ManglerTildelingsrett`: `feideAdministratorManglerTildelingsrett`.

## Next Steps
- Task #12: documentation, including the consequences of 0086.
- Review: confirm 0086 against the choice in 0078.

## Conclusion
Assign and remove for ID-porten users are in place and tested. The number never appears in a
response. The requirement that removing the last tildeling makes the person invisible now holds,
through 0086. Ready for review. No git commands were run, and neither spec.log.md nor the plan was
touched.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
