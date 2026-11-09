# Task #6 Completion Report: Del `Fodselsnummer` med service-laget

## Status: ✅ COMPLETED

**Date Completed**: 2026-09-25
**Task**: Del `Fodselsnummer` med service-laget
**Priority**: Medium
**Size**: S

## Summary
`Fodselsnummer` and `FodselsnummerTest` now live in `tilgangsstyring-service`, in package
`no.sikt.fs.tilgangsstyring_service`. The coprocessor classes import the class from there, and
their behaviour is unchanged. The new method `erGyldigForRegistrering` accepts ordinary numbers,
D-numbers and Tenor numbers with valid check digits, and rejects everything else, including
FS-generated numbers and H-numbers.

## Files Created (moved)
### 1. `tilgangsstyring/tilgangsstyring-service/src/main/java/no/sikt/fs/tilgangsstyring_service/Fodselsnummer.java` (165 lines)
Moved from `tilgangsstyring-app/.../coprocessor/`. The package declaration changed, the class
javadoc now covers registration as well, and `erGyldigForRegistrering(@Nullable String)` was added.

### 2. `tilgangsstyring/tilgangsstyring-service/src/test/java/no/sikt/fs/tilgangsstyring_service/FodselsnummerTest.java` (242 lines)
Moved from `tilgangsstyring-app/src/test/.../coprocessor/`. It has a new `@Nested Registrering`
block (15 cases).

## Files Modified
### 1. `tilgangsstyring/tilgangsstyring-service/pom.xml`
Added `org.jspecify:jspecify:1.0.0`, the same version `tilgangsstyring-app` uses, because the
class uses `@Nullable`.

### 2. `tilgangsstyring-app/.../coprocessor/CoprocessorService.java`, `SyntetiskPerson.java`, `TilgangsstyringDataTilgangerService.java`
Each one now has `import no.sikt.fs.tilgangsstyring_service.Fodselsnummer;`. No other changes.

## Key Features Implemented
### ✅ Shared class
`tilgangsstyring-app` already depends on `tilgangsstyring-service` (`tilgangsstyring-app/pom.xml:19`),
so no shared module was needed.

### ✅ `erGyldigForRegistrering`
It requires the eleven-digit form and valid mod-11 check digits, plus either month 01–12
(ordinary or D-number) or the Tenor series (month 81–92). FS-generated numbers (month 51–62) and
H-numbers (month 41–52) fall outside these ranges and are rejected.

## Project skills consulted
None applied. This is a pure Java refactor with no GraphQL, schema or DB changes, and none of the
repo skills (subgraph-expand, fs-testdata-creation, etc.) cover it.

## Test Results
Command (from `tilgangsstyring/`):
`mise exec -- mvn -q -o -pl :tilgangsstyring-service,:tilgangsstyring-app test -Dtest='Fodselsnummer*,Coprocessor*,Idporten*,SyntetiskPerson*,TilgangsstyringDataTilganger*' -Dsurefire.failIfNoSpecifiedTests=false`
(first ran `install -DskipTests` on `:tilgangsstyring-service`)

- `FodselsnummerTest`: 63 tests, 0 failures (the new `Registrering` block has 15)
- `CoprocessorResourceTest`: 87 passed
- `IdportenCoprocessorTest`: 9 passed
- `IdportenAuthenticatorTest`: 4 passed
- `CoprocessorMetrikkerTest`: 7 passed
- `CoprocessorServiceAudienceTest`: 2 passed

This is a Java/Maven project, so the tests are JUnit, not TypeScript.

## Technical Decisions
### 1. Tenor must also have valid check digits for registration
**Why**: The acceptance criterion puts "kontrollsifre gyldige" first, and ID-porten only delivers
numbers that pass mod-11. `erSyntetiskSerie` still ignores check digits, because the sudo
validation and log redaction depend on that.

### 2. Corrected a test comment that was factually wrong
**Why**: The comment claimed that neither Feide guardian number had valid check digits. In fact
`18848599901` (month 84) passes mod-11, which the new test caught. Only the 81 number lacks valid
check digits. The comment now says so, and the 84 number is used as an accepted Tenor case in
`Registrering`. None of the existing assertions changed.

## Build Status
✅ **Build successful**: service and app compile (main and test), and the targeted tests pass.
✅ **No new warnings introduced**
✅ **All imports resolved correctly**: there are no leftover references to `coprocessor.Fodselsnummer` in the repo.

## Integration Points
Task #10 (`IdPortenBrukerRegistreringService`) can call `Fodselsnummer.erGyldigForRegistrering`
and `Fodselsnummer.sladd` directly from the same package.

## Acceptance Criteria Met
- ✅ The class and its test are in `tilgangsstyring-service`, the coprocessor uses them from there, and behaviour is unchanged. Evidence: the files above, the three imports, and the coprocessor tests passing.
- ✅ `erGyldigForRegistrering` exists and is tested with ordinary, D, H, FS-generated (low and high month), Tenor (valid and invalid check digits), mistyped, malformed and null input. Evidence: `FodselsnummerTest$Registrering`, 15/15.

## Next Steps
Task #10 uses the method in the registration service and throws `UgyldigFodselsnummerException`.

## Conclusion
The task is done and ready for review. Nothing was run in git, and neither the DB nor
spec.log.md was touched.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
