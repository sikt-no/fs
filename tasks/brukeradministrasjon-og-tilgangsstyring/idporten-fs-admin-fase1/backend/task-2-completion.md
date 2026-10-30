# Task #2 Completion Report: `IdportenAuthenticator` og OIDC-tenant-konfigurasjon

## Status: ✅ COMPLETED

**Date Completed**: 2026-09-22
**Task**: `IdportenAuthenticator` og OIDC-tenant-konfigurasjon
**Priority**: High
**Size**: M

## Summary

ID-porten er lagt inn som utsteder i coprocessoren: en ny `IdportenAuthenticator` etter malen fra
`MaskinportenAuthenticator`, med to tenants (`idporten`, `idporten-test`), lazy tenant-oppslag og
samme tredelte feilhåndtering. Identiteten leses utelukkende fra det verifiserte tokenet — `pid`
går i `nin`, `sub` blir subjektet og `acr` bæres videre — uten noe userinfo-kall. OIDC-tenanten er
konfigurert i default-, produksjons- og testprofilen med URL-er hentet fra Digdirs publiserte
OIDC-metadata.

Ingenting ruter ennå trafikk hit; `BearerTokenAuthenticator` er Task #3.

## Files Created

### 1. `tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/coprocessor/IdportenAuthenticator.java` (75 linjer)

`@ApplicationScoped`-bean med `@Tenant("idporten")` og `@Tenant("idporten-test")`. Én privat
felles `authenticate(rawToken, identityProvider)` med `await().atMost(250 ms)`, som bygger
`AuthorizationCodeResult("idporten", client_id, sub, null, null, pid, null, null, acr)`.
`getAcr` ignorerer et `acr` som ikke er en streng, på samme måte som `FeideAuthenticator`.

### 2. `tilgangsstyring/tilgangsstyring-app/src/test/java/no/sikt/fs/tilgangsstyring/coprocessor/IdportenAuthenticatorTest.java` (142 linjer)

Ren JUnit/Mockito-test (ingen `@QuarkusTest`), samme form som `FeideAuthenticatorTest`: selvsignerte
tokens parset med `DefaultJWTParser`, mocket `TenantIdentityProvider`.

## Files Modified

### 1. `tilgangsstyring-app/src/main/resources/application.properties`

Ny `quarkus.oidc.idporten`-tenant mot ID-portens testmiljø (`discovery-enabled=false`,
`allow-jwt-introspection=false`, `application-type=service`, eksplisitt `jwks-path`), pluss
`tilgangsstyring.issuer.idporten`. Ingen `token.audience`.

### 2. `tilgangsstyring-app/src/main/resources/application-platon-production.properties`

`quarkus.oidc.idporten` mot produksjonsutstederen og `quarkus.oidc.idporten-test` mot testmiljøet,
med `tilgangsstyring.issuer.idporten` og `tilgangsstyring.issuer.idporten-test`. Kommentaren peker
til begrunnelsen som allerede står over Maskinporten-test-tenanten.

### 3. `tilgangsstyring-app/src/main/resources/application-test.properties`

`idporten`-tenanten pekes på den lokale JWKS-stubben (`JwksResource`) på testporten, mens
`token.issuer` beholder ID-portens testutsteder — samme grep som for Feide og Maskinporten, slik at
ingen test går ut på nettet.

## Key Features Implemented

### ✅ `IdportenAuthenticator` med to tenants

`authenticate(...)` og `authenticateTestIdporten(...)` over én privat kjerne. Test-tenanten slås opp
lazy, så injeksjonen er trygg i profilene som ikke konfigurerer den.

### ✅ Tredelt feilhåndtering

`AuthenticationFailedException` → «ID-porten token verification failed», `TimeoutException` →
«… timed out», `OIDCException` → «… unavailable» (med `Log.warnf`, som i de eksisterende
authenticatorene, fordi feilen ellers havner i `@Fallback` og logges misvisende som timeout).

### ✅ Identitet fra tokenet alene

`pid` → `nin`, ID-portens `sub` → `subject`, `client_id` → `clientId`, `acr` → `acr`.
`name`, `email`, `schacHomeOrganization` og `externalServiceId` er null. Ingen HTTP-kall i flyten.

### ✅ OIDC-konfigurasjon i tre profiler

Default/test-URL i `application.properties`, prod + testutsteder i `application-platon-production`,
lokal JWKS-stubb i `application-test`. `token.audience` er bevisst ikke satt.

## Project skills consulted

Repoet har to egne skills (`/home/skurtveito/dev/sikt/fs-plattform/.claude/skills/`):
`fs-testdata-creation` og `graphql-ytelsesanalyse`. Ingen av dem dekker denne oppgaven — den rører
verken testdata i utviklingsdatabasen eller GraphQL-ytelse, og subgrafens skjema er uendret.
Konvensjonene er hentet fra `CLAUDE.md`, `RETNINGSLINJER.md` → «Dokumentasjon og kommentarer»
(kommenterer bare det som overrasker; ingen migrerings- eller saksreferanser i kode) og
`tilgangsstyring/CLAUDE.local.md`.

## Test Results

Kjørt fra `/home/skurtveito/dev/sikt/fs-plattform/tilgangsstyring` (Maven og Java via mise):

```
mise exec -- mvn -o -pl :tilgangsstyring-app test -Dtest=IdportenAuthenticatorTest
  → Tests run: 4, Failures: 0, Errors: 0, Skipped: 0

mise exec -- mvn -o -pl :tilgangsstyring-app test
  → BUILD SUCCESS — Tests run: 434, Failures: 0, Errors: 0, Skipped: 5
    (de 5 skippede er OracleChangeApplierOracleTest, som før — krever Oracle)
```

Testene er Java/JUnit i modulens egne testkataloger, som resten av prosjektet; `npx tsx` er ikke
relevant i et Maven/Quarkus-repo.

De fire testmetodene:

- `gyldigTokenGirAuthorizationCodeResult` — alle ni feltene i resultatet, inkludert at `name`,
  `email`, `schacHomeOrganization` og `externalServiceId` er null.
- `acrSomManglerGirNull` — både manglende `acr` og et `acr` som er et objekt.
- `feilkilderSkillesFraHverandre` — de tre unntakene gir hver sin begrunnelse.
- `testutstederBrukerEgenTenant` — `authenticateTestIdporten` rører ikke produksjons-tenanten.

Den lokale PostgreSQL-instansen som allerede kjørte ble brukt av `@QuarkusTest`-ene. Ingen docker
compose-tjenester ble startet, stoppet eller nullstilt.

## Technical Decisions

### 1. Utsteder- og JWKS-URL hentet fra Digdirs live metadata, ikke fra planen

**Why**: planen oppga `https://idporten.no/` og `https://test.idporten.no/` med etterfølgende
skråstrek, og `/jwks` som sti. Metadataene var tilgjengelige, og de sier noe annet
(hentet 2026-09-22):

| Miljø | `issuer` | `jwks_uri` |
| --- | --- | --- |
| Test | `https://test.idporten.no` | `https://test.idporten.no/jwks.json` |
| Prod | `https://idporten.no` | `https://idporten.no/jwks.json` |

Utsteder-sammenligningen i `BearerTokenAuthenticator` er ren strengsammenligning, og
`quarkus.oidc.*.token.issuer` valideres eksakt mot `iss` i tokenet — en skråstrek for mye ville gitt
401 på alle ID-porten-tokens. URL-ene er derfor **verifiserte**, ikke antatte.
`acr_values_supported` i samme metadata bekrefter dessuten kravets eksempelverdier
(`selfregistered-email`, `idporten-loa-substantial`, `idporten-loa-high`).

### 2. `acr` leses defensivt, `pid` og `client_id` ikke

**Why**: `acr` er valgfritt og kan komme i uventet form — samme begrunnelse som i
`FeideAuthenticator`, der `instanceof String` gir null i stedet for `ClassCastException`. `pid` og
`client_id` leses rett, som `client_id` gjør i Feide-flyten: mangler de, er tokenet uansett ikke
brukbart, og en stille null er da bedre enn en konstruert verdi.

### 3. Ingen `token.audience` i noen profil

**Why**: eksplisitt akseptansekriterium. Audiensen avklares med fs-admin (fase 1b), og skal settes
før produksjonssetting. Kommentaren i `application.properties` sier at fraværet er bevisst, slik at
ingen leser det som en forglemmelse.

### 4. `idporten-test` kun i `platon-production`

**Why**: speiler `maskinporten-test`. Prod-deploymenten betjener alle miljøer via
`/coprocessor/{env}`, så den er den eneste som trenger å verifisere tokens fra begge utstedere.
Task #3 gjør `tilgangsstyring.issuer.idporten-test` til en `Optional<String>` i
`BearerTokenAuthenticator`, slik at de øvrige profilene ikke feiler ved oppstart.

### 5. Ingen egen `@QuarkusTest` i denne oppgaven

**Why**: ende-til-ende-dekningen (inkludert idporten-test-tenanten mot den lokale JWKS-stubben) er
Task #6, og krever ruting fra Task #3 for å gi mening. Enhetstesten dekker det Task #2 faktisk
innfører: claim-uttrekket og de tre feilgrenene.

## Build Status

✅ **Build successful** — `mise exec -- mvn -o -pl :tilgangsstyring-app test` gir BUILD SUCCESS
✅ **No new linter warnings** — ingen nye advarsler fra javac
✅ **All imports resolved correctly**

## Integration Points

- **Task #3** (`BearerTokenAuthenticator`): ruter `iss == tilgangsstyring.issuer.idporten` til
  `authenticate(...)` og `iss == tilgangsstyring.issuer.idporten-test` til
  `authenticateTestIdporten(...)`. Ingen annen kode kaller beanen i dag, så ID-porten-tokens avvises
  fortsatt som ukjent utsteder.
- **`CoprocessorService`**: `AuthorizationCodeResult` med `issuer = "idporten"` gir `amr =
  ["idporten"]` og `sti = idporten` i metrikkene uten kodeendring; `acr` bæres av mekanismen fra
  Task #1.
- **Task #5**: `externalServiceId = null` fra denne authenticatoren er grunnen til at
  `hentActualOrgTilganger` må skopes på issuer — Feides fail-closed for null `externalServiceId`
  skal stå.
- **Digdir (fase 0)**: klientregistreringen er fortsatt ikke bestilt. Ende-til-ende mot ID-portens
  testmiljø er en egen oppfølging; alt her er testet mot selvsignerte tokens.

## Acceptance Criteria Met

- ✅ Ny `IdportenAuthenticator` med begge tenants, lazy oppslag, 250 ms `await().atMost` — Evidence:
  `IdportenAuthenticator.java:20-44`
- ✅ Tre feilkilder, hver sin begrunnelse — Evidence: `IdportenAuthenticator.java:58-68`, testet i
  `IdportenAuthenticatorTest.feilkilderSkillesFraHverandre`
- ✅ `AuthorizationCodeResult` med `issuer = "idporten"`, `sub`, `pid` → `nin`, `acr`, `client_id`,
  og null for `externalServiceId`/`schacHomeOrganization`/`email`/`name` — Evidence:
  `IdportenAuthenticator.java:46-56`, testet i
  `IdportenAuthenticatorTest.gyldigTokenGirAuthorizationCodeResult`
- ✅ Ingen userinfo-kall — Evidence: klassen har ingen rest-klient og ingen andre avhengigheter enn
  de to `TenantIdentityProvider`-ene
- ✅ OIDC-tenant i alle tre profilene med `discovery-enabled=false`,
  `allow-jwt-introspection=false`, `application-type=service` — Evidence:
  `application.properties:222-227`, `application-platon-production.properties:72-88`,
  `application-test.properties:15-17`
- ✅ `tilgangsstyring.issuer.idporten` i alle profiler, `…idporten-test` kun i `platon-production` —
  Evidence: `application.properties:232`, `application-platon-production.properties:78,89`
- ✅ `token.audience` ikke satt noe sted — Evidence: `grep -rn "oidc.idporten.*audience"` gir null
  treff

## Next Steps

- **Task #3**: utstederruting og gaten for testutstederen i `BearerTokenAuthenticator`.
- **Task #6**: ende-til-ende-test, inkludert en `QuarkusTestProfile` som konfigurerer
  `idporten-test`-tenanten mot den lokale JWKS-stubben.
- **Før produksjonssetting**: audiensen må avklares med fs-admin og settes per profil, og
  klientregistreringen hos Digdir (fase 0) må være på plass for en ekte ende-til-ende-verifikasjon
  av `pid`- og `acr`-formen.

## Conclusion

`IdportenAuthenticator` er på plass med verifiserte utsteder-URL-er, tredelt feilhåndtering og
claim-uttrekk uten nettverkskall, og OIDC-konfigurasjonen er satt i de tre profilene kravet peker
på. Hele modulens testsuite er grønn. Klar for review og for Task #3.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
