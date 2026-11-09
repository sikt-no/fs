# Task #4 Completion Report: Gate ID-porten til coprocessor-stien

## Status: ✅ COMPLETED

**Date Completed**: 2026-09-22
**Task**: Gate ID-porten til coprocessor-stien
**Priority**: High
**Size**: S

## Summary

Utstedertilliten i `BearerTokenAuthenticator` er nå sti-avhengig: `authenticateForCoprocessor(...)`
godtar alle fire utstederne, `authenticateForSubgraf(...)` godtar alle unntatt ID-porten og
test-ID-porten. Begge går gjennom én privat kjerne som tar settet av tillatte utstedere, så
policyen bor ett sted og kallstedet navngir stien i stedet for å sende en verdi.

Et ID-porten-token som coprocessoren utsteder på, gir nå 401 mot `/graphql/{env}` og når aldri
`SessionIdentity.mount`. Feide, Maskinporten, test-Maskinporten og basic auth er uendret på begge
stier.

## Files Created

Ingen.

## Files Modified

### 1. `tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/coprocessor/BearerTokenAuthenticator.java`

- To offentlige inngangsmetoder, `authenticateForCoprocessor` og `authenticateForSubgraf`, over en
  privat `authenticate(rawToken, targetEnvironment, Set<Utsteder>)`.
- Utstederstrengene oversettes én gang i `utsteder(issuer)` til en privat `Utsteder`-enum; settene
  `COPROCESSOR_UTSTEDERE` (alle) og `SUBGRAF_UTSTEDERE` (uten de to ID-porten-utstederne) er
  konstanter i klassen.
- Ukjent utsteder gir «Unknown token issuer» som før; en kjent utsteder som ikke er tillatt på
  stien gir en egen begrunnelse («Token issuer is not accepted on this path»), slik at logg og
  feilsøking skiller de to.
- Klassejavadoc som sier at tilliten er sti-avhengig, og en javadoc på `authenticateForSubgraf`
  som forklarer HVORFOR ID-porten holdes utenfor (ingen Feide service-id, ingen annen inngang enn
  `auth.login_feide_bruker` i `SessionIdentity.mount`).

### 2. `tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/coprocessor/CoprocessorService.java`

`bearer`-armen i den private `authenticate(...)` kaller `authenticateForCoprocessor`.

### 3. `tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/auth/AuthorizationHeaderAuthenticator.java`

`bearer`-armen kaller `authenticateForSubgraf`. Klassejavadoc-en sier nå at utstederne ikke er de
samme på begge stier, med peker til `authenticateForSubgraf` for begrunnelsen.

### 4. `tilgangsstyring/tilgangsstyring-app/src/test/java/no/sikt/fs/tilgangsstyring/coprocessor/BearerTokenAuthenticatorTest.java`

De fem eksisterende testene kaller `authenticateForCoprocessor`. Tre nye tester for subgraf-stien:
ID-porten avvises (også i et miljø coprocessoren godtar den i), test-ID-porten avvises selv i et
syntetisk datamiljø, og Feide/Maskinporten rutes som før.

### 5. `tilgangsstyring/tilgangsstyring-app/src/test/java/no/sikt/fs/tilgangsstyring/EnvironmentGraphqlResourceTest.java`

Ny full-stack-test `idportenTokenGir401PaaSubgrafStien`: samme token sendes først til
`/coprocessor/test` (200 `continue` — tokenet er gyldig for ID-porten-tenanten i test-profilen,
signert med JWKS-stubbens nøkkel) og deretter til `/graphql/test` (401). Kontrasten er poenget:
avvisningen er stiens valg, ikke en verifiseringsfeil.

## Key Features Implemented

### ✅ Sti-avhengig utstedertillit

Kallstedet velger metode; det finnes ingen boolean eller enum-verdi som kan sendes feil. Settene av
tillatte utstedere er de eneste stedene policyen uttrykkes.

### ✅ Subgraf-stien avviser ID-porten før montering

`AuthenticationFailedResult` → 401-gaten i `AuthenticatedSession.login` → `SessionIdentity.mount`
kalles aldri. `AuthorizationCodeResult` har fortsatt ingen `default -> throw` i `mount`, slik
planen krever.

### ✅ Uendret oppførsel for de øvrige utstederne

Feide, Maskinporten, test-Maskinporten og basic auth går samme vei som før på begge stier; gaten for
test-Maskinporten (syntetiske datamiljø) ligger uendret i samme switch.

## Project skills consulted

Repoets egne skills (`/home/skurtveito/dev/sikt/fs-plattform/.claude/skills/`) er
`fs-testdata-creation` og `graphql-ytelsesanalyse`. Ingen av dem dekker denne oppgaven: den rører
verken testdata i utviklingsdatabasen eller GraphQL-ytelse, og subgrafens skjema er uendret.
`tilgangsstyring/` har ingen egen `.claude/skills/`. Konvensjonene er hentet fra `CLAUDE.md`,
`RETNINGSLINJER.md` → «Dokumentasjon og kommentarer» og `tilgangsstyring/CLAUDE.local.md`.

## Test Results

Kjørt fra `/home/skurtveito/dev/sikt/fs-plattform/tilgangsstyring` (Maven og Java via mise):

```
mise exec -- mvn -o -pl :tilgangsstyring-app test -Dtest='BearerTokenAuthenticatorTest,EnvironmentGraphqlResourceTest'
  → Tests run: 31, Failures: 0, Errors: 0, Skipped: 0 — BUILD SUCCESS

mise exec -- mvn -o -pl :tilgangsstyring-app test
  → Tests run: 443, Failures: 1, Errors: 0, Skipped: 5
    Eneste feil: SamlingstildelingerGraphqlTest.samlingTilgangerFilterKanter — kjent og urelatert
    (akkumulerte IT_SAMLTILD_BATCH_A-rader i den lokale, langlevde PostgreSQL-en presser den
    forventede raden ut av første side). Ikke rørt, ingen databasenullstilling.
```

Regresjonsvernet for de øvrige utstederne er grønt uendret: `CoprocessorResourceTest` (69),
`MaskinportenTestIssuerCoprocessorTest` (3), `FeideAuthenticatorTest` (10),
`IdportenAuthenticatorTest` (4), `DevLoginGraphqlTest` (3), `DevLoginFeideGraphqlTest` (1).

### Testen er beviselig lastbærende

Med kallstedet i `AuthorizationHeaderAuthenticator` midlertidig satt tilbake til
coprocessor-varianten feiler den nye testen:

```
EnvironmentGraphqlResourceTest.idportenTokenGir401PaaSubgrafStien
  {"data":{"applikasjoner":{"edges":[]}}} ==> expected: <401> but was: <200>
```

Kallstedet ble umiddelbart satt tilbake. Merk avviket fra analysens funn 3: uten gaten gir
dagens skjema **ikke** 500, men 200 med tom respons — `auth.login_feide_bruker` provisjonerer ikke
når `p_feide_id` er NULL (`IF ... AND p_feide_id IS NOT NULL`), og monterer i stedet en identitet
uten subjekt, som RLS gir ingenting. Ingen rader ble skrevet av prøvekjøringen. Utfallet er
mildere enn analysen antok, men mer stillegående: en autentisert sesjon uten identitet i stedet
for en tydelig feil. Gaten er dermed like riktig, og akseptansekriteriet («401, ikke 500, og
treffer aldri `mount`») er oppfylt.

## Technical Decisions

### 1. Utstederstrengene oversettes til en privat enum før valget tas

**Why**: settet av tillatte utstedere må uttrykkes som en verdi for å kunne sendes inn i kjernen.
Med strenger måtte settet bygges av konfigurasjonsverdier som kan være null (test-utstederne), og
et `Set<String>` med null i ville vært en felle. Enumen gjør dessuten `switch`-en uttømmende, så en
ny utsteder gir kompileringsfeil i stedet for en glemt gren.

### 2. Egen begrunnelse for «kjent, men ikke tillatt her»

**Why**: «Unknown token issuer» ville løyet i loggen for et ID-porten-token på subgraf-stien og
sendt feilsøkingen mot konfigurasjonen av utstedere. Klienten ser uansett bare «Unauthorized».

### 3. Full-stack-testen ligger i `EnvironmentGraphqlResourceTest`, ikke i en ny testklasse

**Why**: subgraf-stiens kontrakt bor der, og testen gjenbruker profilen og Quarkus-oppstarten som
allerede kjører. En egen `@QuarkusTest`-profil ville kostet en ny oppstart uten å gi noe.

### 4. Testen sender samme token til coprocessoren først

**Why**: «et ellers gyldig ID-porten-token» må vises, ikke påstås. Uten kontrasten kunne 401 like
gjerne kommet av at tokenet ikke lot seg verifisere.

## Build Status

✅ **Build successful** — `mise exec -- mvn -o -pl :tilgangsstyring-app test` kompilerer rent
(408 kilder + 41 testkilder)
✅ **No new linter warnings** — ingen nye advarsler fra javac
✅ **All imports resolved correctly**

## Integration Points

- **`CoprocessorService`**: eneste kaller av `authenticateForCoprocessor`; ID-porten er fortsatt
  godtatt der, uendret fra Task #3.
- **`AuthorizationHeaderAuthenticator` / `EnvironmentGraphqlResource` / `AuthenticatedSession`**:
  subgraf-stien avviser ID-porten før montering. `SessionIdentity` er urørt.
- **Task #5**: `hentActualOrgTilganger` er urørt her; åpne roller for ID-porten er fortsatt åpen.
- **Task #6**: ende-til-ende-testene for coprocessoren skal bruke `authenticateForCoprocessor`-stien
  via `/coprocessor/{env}` — inngangen er nå navngitt.
- **Task #7**: `docs/en-instans-for-alle-miljo.md` skal si at utstedertilliten er sti-avhengig.

## Acceptance Criteria Met

- ✅ `authenticateForCoprocessor(...)` og `authenticateForSubgraf(...)` over en felles privat kjerne
  som tar settet av tillatte utstedere — Evidence:
  `BearerTokenAuthenticator.java:66-80` (inngangene), `:82-137` (kjernen), `:27-30` (settene)
- ✅ `CoprocessorService` kaller coprocessor-varianten; `AuthorizationHeaderAuthenticator` kaller
  subgraf-varianten — Evidence: `CoprocessorService.java:412`,
  `AuthorizationHeaderAuthenticator.java:65`
- ✅ ID-porten-token mot `/graphql/{env}` gir 401, ikke 500, og treffer aldri `SessionIdentity.mount`
  — Evidence: `EnvironmentGraphqlResourceTest.idportenTokenGir401PaaSubgrafStien`; `mount` nås bare
  etter 401-gaten i `AuthenticatedSession.login`, som `AuthenticationFailedResult` aldri passerer
- ✅ Feide, Maskinporten og basic auth uendret på begge stier — Evidence: `CoprocessorResourceTest`,
  `MaskinportenTestIssuerCoprocessorTest`, `EnvironmentGraphqlResourceTest` og
  `DevLogin*GraphqlTest` grønne uendret; `BearerTokenAuthenticatorTest.subgraf_feideOgMaskinporten_rutes`
- ✅ Test som viser 401 fra subgraf-stien for et ellers gyldig ID-porten-token — Evidence:
  `EnvironmentGraphqlResourceTest.idportenTokenGir401PaaSubgrafStien` (samme token gir 200
  `continue` fra coprocessoren i samme test)

## Next Steps

- **Task #5**: `tilganger_for_apne_roller(env)` i basen og issuer-skopet oppslag i
  `hentActualOrgTilganger`.
- **Task #6**: ende-til-ende coprocessortest for kravets fire regler.
- **Task #7**: dokumentér den sti-avhengige utstedertilliten i `docs/en-instans-for-alle-miljo.md`.

## Conclusion

Subgraf-stien er lukket for ID-porten, coprocessor-stien er uendret åpen, og begge stiene deler én
implementasjon med policyen uttrykt som to navngitte sett. Avgrensningen av `TIL-PÅL-PÅL-003` er
dermed håndhevet i kode og dekket av test. Klar for review og for Task #5.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
