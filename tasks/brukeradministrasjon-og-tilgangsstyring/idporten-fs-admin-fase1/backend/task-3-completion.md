# Task #3 Completion Report: Utstederruting og testutsteder-gate

## Status: ✅ COMPLETED

**Date Completed**: 2026-09-22
**Task**: Utstederruting og testutsteder-gate
**Priority**: High
**Size**: S

## Summary

`BearerTokenAuthenticator` ruter nå ID-porten-tokens til `IdportenAuthenticator`, og
test-utstederen `https://test.idporten.no` slipper kun gjennom mot syntetiske datamiljøer — ellers
avvises den med miljønavnet i begrunnelsen. Test-utstederen er en `Optional<String>`, så profilene
uten den starter som før, og ukjent utsteder avvises fortsatt (fail closed).

Rutingen er lagt inn som en egen gren ved siden av `maskinporten-test`, ikke slått sammen med den.

## Files Created

### 1. `tilgangsstyring/tilgangsstyring-app/src/test/java/no/sikt/fs/tilgangsstyring/coprocessor/BearerTokenAuthenticatorTest.java` (134 linjer)

Ren JUnit/Mockito-enhetstest (ingen `@QuarkusTest`): konstruerer `BearerTokenAuthenticator` direkte
med mockede authenticatorer og en ekte `SyntetiskeDatamiljoer`, og verifiserer rutingen og begge
retninger av testutsteder-gaten. Tokens signeres med et engangs-nøkkelpar; signaturen brukes ikke —
`decodeJwtContent` leser bare `iss`.

## Files Modified

### 1. `tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/coprocessor/BearerTokenAuthenticator.java`

- Ny konstruktørparameter `IdportenAuthenticator`, samt `tilgangsstyring.issuer.idporten` (påkrevd,
  satt i alle profiler) og `tilgangsstyring.issuer.idporten-test` (`Optional<String>`, satt kun i
  `platon-production`).
- To nye grener i utstedervalget: `idporten` → `authenticate(...)`, `idporten-test` → samme
  syntetisk-miljø-gate som `maskinporten-test`, deretter `authenticateTestIdporten(...)`.

## Key Features Implemented

### ✅ Ruting på utsteder

`iss == tilgangsstyring.issuer.idporten` går til `IdportenAuthenticator.authenticate(...)`. De
eksisterende grenene for Feide og Maskinporten er uendret, og rekkefølgen er uendret.

### ✅ Gate for testutstederen

`iss == tilgangsstyring.issuer.idporten-test` krever
`SyntetiskeDatamiljoer.erSyntetisk(targetEnvironment)`. Feiler den, returneres
`AuthenticationFailedResult("ID-porten test issuer is not accepted for environment: %s")` og
`IdportenAuthenticator` røres ikke. Kommentaren over gaten sier hvorfor den finnes, formulert som i
`maskinporten-test`-grenen.

### ✅ Valgfri testutsteder

`Optional<String>` → `orElse(null)`. Med null-felt gir `issuer.equals(idportenTestIssuer)` false, og
et token fra test.idporten.no faller gjennom til «Unknown token issuer» i profilene som ikke har
konfigurert utstederen. Ingen oppstartsfeil.

## Project skills consulted

Repoets egne skills (`/home/skurtveito/dev/sikt/fs-plattform/.claude/skills/`) er
`fs-testdata-creation` og `graphql-ytelsesanalyse`. Ingen av dem dekker denne oppgaven: den rører
verken testdata i utviklingsdatabasen eller GraphQL-ytelse, og subgrafens skjema er uendret.
`tilgangsstyring/` har ingen egen `.claude/skills/`. Konvensjonene er hentet fra `CLAUDE.md`,
`RETNINGSLINJER.md` → «Dokumentasjon og kommentarer» og `tilgangsstyring/CLAUDE.local.md`.

## Test Results

Kjørt fra `/home/skurtveito/dev/sikt/fs-plattform/tilgangsstyring` (Maven og Java via mise):

```
mise exec -- mvn -o -pl :tilgangsstyring-app test -Dtest=BearerTokenAuthenticatorTest
  → Tests run: 5, Failures: 0, Errors: 0, Skipped: 0 — BUILD SUCCESS

mise exec -- mvn -o -pl :tilgangsstyring-app test -Dtest='no.sikt.fs.tilgangsstyring.coprocessor.**'
  → Tests run: 181, Failures: 0, Errors: 0, Skipped: 0 — BUILD SUCCESS

mise exec -- mvn -o -pl :tilgangsstyring-app test
  → Tests run: 439, Failures: 1, Errors: 0, Skipped: 5
    Eneste feil: SamlingstildelingerGraphqlTest.samlingTilgangerFilterKanter (se nedenfor)
```

De fem testmetodene:

- `idportenUtsteder_rutes` — prod-utstederen treffer `authenticate`, aldri `authenticateTestIdporten`,
  og verken Feide- eller Maskinporten-authenticatoren røres.
- `testUtsteder_syntetiskMiljo_rutes` — `test` er syntetisk, så `authenticateTestIdporten` kalles.
- `testUtsteder_produksjonsmiljo_avvises` — `production` gir `AuthenticationFailedResult` med
  miljønavnet i begrunnelsen, og `IdportenAuthenticator` kalles ikke.
- `testUtsteder_ikkeKonfigurert_erUkjent` — uten konfigurert test-utsteder er test.idporten.no
  «Unknown token issuer», selv i et syntetisk miljø.
- `ukjentUtsteder_avvises` — en fremmed utsteder avvises uten å treffe noen authenticator.

Java/JUnit er testformen i dette Maven/Quarkus-repoet; `npx tsx` er ikke relevant her.

Den lokale PostgreSQL-instansen som allerede kjørte ble brukt av `@QuarkusTest`-ene. Ingen docker
compose-tjenester ble startet, stoppet eller nullstilt.

### Kjent, urelatert testfeil

`SamlingstildelingerGraphqlTest.samlingTilgangerFilterKanter` feiler også isolert
(`-Dtest=SamlingstildelingerGraphqlTest`), og feiler på akkumulert databasetilstand, ikke på
autentisering: testen åpner en ny `IT_SAMLTILD_BATCH_A`-tildeling for hver kjøring uten å rydde,
og feilmeldingen viser ti identiske `IT_SAMLTILD_BATCH_A` i første side, slik at
`IT_SAMLTILD_BATCH_B` faller utenfor. Testen rører ingen kode denne oppgaven endrer
(`BearerTokenAuthenticator` er ikke i flyten for GraphQL-spørringene der), og
`mise run db-down`/reset er utenfor mandatet for denne oppgaven.

## Technical Decisions

### 1. Egen gren for `idporten-test`, ikke felles sjekk med `maskinporten-test`

**Why**: eksplisitt i planen. De to test-utstederne har ulike URL-er og ulike OIDC-tenants, og en
felles «er dette en test-utsteder»-sjekk ville skjult hvilken tenant tokenet faktisk verifiseres mot.

### 2. Gate-feilmeldingen er på engelsk, som nabogrenen

**Why**: `reason` går i logg og i 401-svaret, og de øvrige grunnene i klassen er engelske. En norsk
tekst her ville bare vært inkonsistent for leseren av loggen.

### 3. `SyntetiskeDatamiljoer` er ekte, ikke mocket, i testen

**Why**: den er en ren funksjon av konfigurasjonen, og en ekte instans gjør det synlig i testen hvilke
miljønavn som faktisk er syntetiske. Samme grep som `SyntetiskeDatamiljoerTest`.

### 4. Ingen `@QuarkusTest` for gaten i denne oppgaven

**Why**: ende-til-ende-dekningen (coprocessor-endepunkt, JWKS-stubb, utstedt token) er Task #6, og
avhenger dessuten av Task #4 og #5. Enhetstesten dekker akkurat det Task #3 innfører: valget av gren.

## Build Status

✅ **Build successful** — `mise exec -- mvn -o -pl :tilgangsstyring-app test` kompilerer rent
(408 kilder + 41 testkilder); eneste testfeil er den urelaterte `SamlingstildelingerGraphqlTest`
✅ **No new linter warnings** — ingen nye advarsler fra javac
✅ **All imports resolved correctly**

## Integration Points

- **`CoprocessorService`**: kaller fortsatt `authenticate(rawToken, targetEnvironment)`. Én inngang
  fremdeles — delingen i coprocessor- og subgraf-variant er Task #4.
- **`AuthorizationHeaderAuthenticator`** (subgraf-stien): bruker samme inngang, og godtar derfor
  ID-porten inntil Task #4 gater den bort. Dette er kjent og planlagt, ikke et sidefunn.
- **Task #5**: `hentActualOrgTilganger` ser nå faktisk `issuer == "idporten"` i produksjonskode,
  siden rutingen er på plass.
- **Task #6**: `QuarkusTestProfile` for `idporten-test` mot den lokale JWKS-stubben kan bygge på
  `MaskinportenTestIssuerCoprocessorTest.DualMaskinportenIssuerProfile`.

## Acceptance Criteria Met

- ✅ Ruter `iss == tilgangsstyring.issuer.idporten` til `IdportenAuthenticator` — Evidence:
  `BearerTokenAuthenticator.java:80-81`, testet i `BearerTokenAuthenticatorTest.idportenUtsteder_rutes`
- ✅ `idporten-test` kun i syntetiske miljø, ellers `AuthenticationFailedResult` med miljønavnet —
  Evidence: `BearerTokenAuthenticator.java:82-90`, testet i
  `testUtsteder_syntetiskMiljo_rutes` og `testUtsteder_produksjonsmiljo_avvises`
- ✅ `idporten-test` er `Optional<String>`, null i profiler uten test-utsteder, ingen oppstartsfeil —
  Evidence: `BearerTokenAuthenticator.java:37,46`; hele `@QuarkusTest`-suiten starter på
  `application-test`-profilen, som ikke setter egenskapen, og
  `testUtsteder_ikkeKonfigurert_erUkjent` dekker null-tilfellet
- ✅ Ukjent utsteder gir fortsatt `AuthenticationFailedResult` — Evidence:
  `BearerTokenAuthenticator.java:91-95`, testet i `ukjentUtsteder_avvises`
- ✅ Enhetstester for begge retninger av gaten — Evidence:
  `BearerTokenAuthenticatorTest.java` (5 tester, alle grønne)

## Next Steps

- **Task #4**: del inngangen i `authenticateForCoprocessor(...)` / `authenticateForSubgraf(...)`, slik
  at ID-porten kun godtas på coprocessor-stien.
- **Task #5**: åpne roller for ID-porten-brukeren.
- **Task #6**: ende-til-ende coprocessortest, inkludert dual-utsteder-profilen for ID-porten.

## Conclusion

Utstederrutingen for ID-porten er på plass med samme form og samme gate som Maskinporten, testet i
begge retninger, og uten å endre oppførselen for de eksisterende utstederne. Klar for review og for
Task #4.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
