# Task #10 Completion Report: GraphQL, `registrerIdPortenBruker`

## Status: ✅ COMPLETED

**Date Completed**: 2026-09-25
**Task**: GraphQL, `registrerIdPortenBruker`
**Priority**: High
**Size**: M

## Summary
Op #3 is implemented in the ID-porten zone of `schema_brukeradmin.graphqls`. It adds the mutation
`registrerIdPortenBruker`, the input and payload, the union `RegistrerIdPortenBrukerError`, and the
new error type `UgyldigFodselsnummer`. `IdPortenBrukerRegistreringService` checks the number with
`Fodselsnummer.erGyldigForRegistrering` before calling `registrer_person` (0081). It maps 42501 to
`ManglerTildelingsrett` and P0002 «tilgangskoden» to `TilgangskodeIkkeFunnet`. The new GraphQL
test class has 8 tests and passes. No DB change was needed.

## Files Created
### 1. `fs-plattform/tilgangsstyring/tilgangsstyring-service/src/main/java/no/sikt/fs/tilgangsstyring_service/IdPortenBrukerRegistreringService.java` (72)
- Validates the number before any DB call and throws `UgyldigFodselsnummerException`.
- Calls `Routines.registrerPerson(...)`.
- Returns a `PersonsubjektMedNavnRecord` with only `SUBJEKT_ID` set.
- Translates DB errors the same way `FeideBrukerTilgangService` does.

### 2. `.../tilgangsstyring_service/UgyldigFodselsnummerException.java` (20)
Uses a fixed message, «Fødselsnummeret er ikke et gyldig fødselsnummer eller D-nummer.», with no
constructor that takes a message, so the number can never end up in it.

### 3. `.../tilgangsstyring_service/records/RegistrerIdPortenBrukerInput.java` (78)
A mutable POJO in the same style as `TildelFeideBrukerTilgangerInput`, with `@nodeId` fields for
the role, organisation and environment. `toString()` redacts the number with `Fodselsnummer.sladd`.

### 4. `.../tilgangsstyring_service/records/RegistrerIdPortenBrukerPayload.java` (42)
Holds `idPortenBruker` (`PersonsubjektMedNavnRecord`) and `errors`, like the Feide payloads.

### 5. `fs-plattform/tilgangsstyring/tilgangsstyring-app/src/test/java/no/sikt/fs/tilgangsstyring/IdPortenBrukerRegistreringGraphqlTest.java` (429, 8 tests)
See Test Results.

## Files Modified
### 1. `fs-plattform/tilgangsstyring/tilgangsstyring-app/src/main/resources/schema/features/experimental/schema_brukeradmin.graphqls`
New block at the bottom of the ID-porten zone (lines 755–828):
- `RegistrerIdPortenBrukerInput`: `fodselsnummer`, `fornavn`, `etternavn` and
  `tilgangId`/`organisasjonId`/`miljoId`, each with `@nodeId`.
- `RegistrerIdPortenBrukerPayload { idPortenBruker: IdPortenBruker, errors: [RegistrerIdPortenBrukerError] }`
- `union RegistrerIdPortenBrukerError = UgyldigFodselsnummer | ManglerTildelingsrett | TilgangskodeIkkeFunnet`
- `type UgyldigFodselsnummer implements Error @error(handlers: [{ handler: GENERIC, className: "…UgyldigFodselsnummerException", description: … }])`
- `extend type Mutation { registrerIdPortenBruker(input: RegistrerIdPortenBrukerInput!): RegistrerIdPortenBrukerPayload @service(…IdPortenBrukerRegistreringService, registrerIdPortenBruker) }`

`ManglerTildelingsrett` and `TilgangskodeIkkeFunnet` are the existing types in `stable/feil.graphqls`.

## Key Features Implemented
### ✅ Validation before the DB call
Ordinary numbers, D-numbers and Tenor numbers with valid check digits are accepted. FS-generated
numbers, H-numbers, invalid check digits and badly formed input all give `UgyldigFodselsnummer`.
Neither the message nor the response contains the number.
### ✅ Same outcome for a new and a known person
`registrer_person` checks both permissions before it looks up the number. For a known person the
role goes on her existing record and her name stays the same. There is no «allerede registrert»
error.
### ✅ Error routing
- 42501 → `ManglerTildelingsrett`, with the same message as the Feide mutations.
- P0002 «tilgangskoden» → `TilgangskodeIkkeFunnet`.
- Anything else passes through untranslated and is redacted by `ErrorRouter.redact`.

Graphitron's generated dispatch table is
`REGISTRER_ID_PORTEN_BRUKER_PAYLOAD = concat(UGYLDIG_FODSELSNUMMER, MANGLER_TILDELINGSRETT, TILGANGSKODE_IKKE_FUNNET)`.
### ✅ Visibility follows RLS
The payload carries only the key. Graphitron then looks up `personsubjekt_med_navn` using the
caller's own read rules, so `idPortenBruker` is null for a caller who cannot see the person.

## Project skills consulted
- `sta-fso-bat-utilitybelt:subgraph-expand`: I used the subgraph table (tilgangsstyring, `.graphqls`,
  service package) and its execution flow. A mutation with `@service` is not a plain 1:1 pattern
  match, but the plan's Op #3 is the verified plan and the shape mirrors `tildelFeideBrukerTilganger`
  and `opprettFeideBruker` exactly. I therefore did not run `subgraph-plan` separately. I checked the
  directives against the code Graphitron generated (fetcher, error mappings and payload re-entry).
  As instructed, I skipped the skill's spec.log.md and `subgraph-expansion-*.md` steps, and that
  content is in this document.
- The Graphitron MCP docs were not in my toolset.

## Test Results
- **Target test**: `cd fs-plattform/tilgangsstyring && mise exec -- mvn -q -o -pl :tilgangsstyring-app test -Dtest=IdPortenBrukerRegistreringGraphqlTest -Dsurefire.failIfNoSpecifiedTests=false`
  gave 8/8. The tests:
  - `nyPersonMedRolle`: a freshly drawn ordinary number. The name and role are in the response, the id
    is type 20022, and the person exists afterwards. A repeated call gives the same id and a single
    tildeling (idempotent).
  - `kjentNummerFraAnnenOrganisasjon`: the response for a known person has the same shape (keys and
    `errors`) as for a new one. The id is the known person's, and the name is still «Kjent Person»
    (no new name row). Only the caller's own tildeling is visible, and the tildeling in the other
    organisation is untouched.
  - `ugyldigNummerAvvises`: invalid check digit, 10 digits, and letters. Each gives
    `UgyldigFodselsnummer` with a fixed message and no person is created. Every call also asserts
    that the response does not contain the number.
  - `dNummerGodtas`, `tenorNummerGodtas`: both accepted, and the person is created.
  - `fsGenerertNummerAvvises`: FS-generated numbers (month+50, pnr ≥ 70000) and H-numbers, both with
    valid check digits, are rejected and not created.
  - `manglerRettGirSammeSvarForKjentOgUkjent`: a caller without SKRIV and a caller with only Feide
    rights both get `ManglerTildelingsrett`. The response is identical for a known and an unknown
    number, and nothing is created.
  - `ukjentTilgangskode`: gives `TilgangskodeIkkeFunnet` and creates no person.
- **Idempotency against the reused DB**: every number that should give a new person is drawn fresh
  on each run. They are on the non-existent date 30 February or in the Tenor series, so they are not
  real people, and each is checked as unused. The test passed twice: once on its own and once in the
  full suite.
- **Service**: `mise exec -- mvn -q -o -pl :tilgangsstyring-service test` is green.
- **Full app suite**: `mise exec -- mvn -q -o -pl :tilgangsstyring-app test` ran 515 tests with 3
  failures, none caused by this task:
  - The two known ones: `RollekatalogForvaltningGraphqlTest.tildelingKunITestAvvises` and
    `SamlingstildelingerGraphqlTest.samlingTilgangerFilterKanter`.
  - `DelegeringstakGraphqlTest.lesefeltet`: the first page of the history list is filled with
    `IT_DELEG_BATCH_A/B` rows from earlier runs, so `LESE_ROLLE` falls off the page. This is
    accumulated data in the reused local DB, in application delegation ceilings, which this task
    does not touch.

## Technical Decisions
### 1. The payload carries only the key, and Graphitron does the lookup
**Why**: The generated payload fetcher always re-queries on the PK through the caller's DSLContext,
so RLS decides visibility, as with `opprettFeideBruker`. Reading the row in the service as well would
have fetched `fodselsnummer` out of the view for nothing. Task #9's note (look up
`PERSONSUBJEKT_MED_NAVN` on `SUBJEKT_ID`) is covered by the generated re-entry.
### 2. No explicit transaction in the service
**Why**: `registrer_person` is a single statement, and the lookup and tildeling happen inside the
function. Nothing else is written that would need to be all-or-nothing.
### 3. Validation happens before the permission check
**Why**: the plan requires it. Whether a number is valid does not depend on whether it is
registered, so the order does not act as an oracle. The permission check in the DB still runs
before the lookup for every valid number.
### 4. A blank name is left to the DB
**Why**: the plan mentions `@NotBlank` or an optional `UgyldigNavn` "if fs-admin needs it". The
subgraph has no Bean Validation on service input, and adding a new error type is outside the
acceptance criteria. `registrer_person` rejects a blank name with 23514, and the client receives a
redacted, untyped error. This is noted in the SDL.
### 5. The tests call the production endpoint
**Why**: mutations are only allowed on `/graphql/production`, the same as in
`BrukertildelingsmutasjonerGraphqlTest`. The permissions and tildelinger still apply in the `test`
environment.

## Build Status
✅ **Build successful**: the service was installed, and Graphitron codegen plus test-compile for the app passed.
✅ **No new linter warnings**
✅ **All imports resolved correctly**
⚠️ `mise run build` was not run, as instructed. There were no DB changes, and `migrate`/`jooq` were not needed.

## Integration Points
- fs-admin: the Lag B call site from the plan (`REGISTRER_ID_PORTEN_BRUKER`) works against the
  schema as written. `UgyldigFodselsnummer` → field error on the number. Empty `errors` → navigate to
  `idPortenBruker.id`, and a null there means the caller lacks PERSON_LES in the pair.
- Task #11: `IdPortenBrukerIkkeFunnet` is still undefined and belongs to tildel/fjern.
  `ManglerTildelingsrett` and `TilgangskodeIkkeFunnet` are shared.
- Task #12 (docs): document the following.
  - The registration flow, including what an administrator can still see afterwards: the stored
    name of a known person (Task #4).
  - That a blank name gives an untyped error.

## Acceptance Criteria Met
- ✅ Op #3 is implemented. `IdPortenBrukerRegistreringService` validates with `Fodselsnummer` before
  the DB call and throws `UgyldigFodselsnummerException` with a message that does not contain the
  number. Evidence: `IdPortenBrukerRegistreringService.java` (the first `if`),
  `UgyldigFodselsnummerException.MELDING`, `schema_brukeradmin.graphqls:755–828`, and
  `ugyldigNummerAvvises`.
- ✅ 42501 gives `ManglerTildelingsrett`, and an unknown code gives `TilgangskodeIkkeFunnet`. Evidence:
  `oversett(...)` in the service, `manglerRettGirSammeSvarForKjentOgUkjent`, `ukjentTilgangskode`.
- ✅ Tests cover: a new person with a role (`nyPersonMedRolle`); a known number from another
  organisation with the same payload shape, only the caller's own tildeling visible and the name
  unchanged (`kjentNummerFraAnnenOrganisasjon`); an invalid number (`ugyldigNummerAvvises`); a D-number
  (`dNummerGodtas`); a Tenor number (`tenorNummerGodtas`); and an FS-generated number, rejected
  (`fsGenerertNummerAvvises`).

## Next Steps
- Task #11: `tildelIdPortenBrukerTilganger` / `fjernIdPortenBrukerTilganger` with `IdPortenBrukerIkkeFunnet`.
- Open follow-up: a typed `UgyldigNavn`, if fs-admin needs it.

## Conclusion
`registrerIdPortenBruker` is in place. It gives the same outcome for a new and a known person, and
the number never appears in an error or a response. Ready for review. No git commands were run, and
neither spec.log.md nor the plan was touched.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
