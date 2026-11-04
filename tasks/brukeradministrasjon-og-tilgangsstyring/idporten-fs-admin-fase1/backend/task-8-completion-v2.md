# Task #8 Completion Report: Audiens fail-closed og ID-porten av i produksjon

## Status: ✅ COMPLETED

**Date Completed**: 2026-09-25
**Task**: Audiens fail-closed og ID-porten av i produksjon
**Priority**: High
**Size**: M

## Summary
ID-porten-tenantene krever nå audiens. Verdien kommer fra én påkrevd egenskap, `tilgangsstyring.audience.idporten`. En ny oppstartskontroll stopper appen når en ID-porten-utsteder er satt uten `token.audience`. `tilgangsstyring.issuer.idporten` er `Optional`, og `platon-production` har ingen ID-porten-tenant og ingen utsteder. Coprocessortesten viser at feil eller manglende audiens gir 401 uten oppslag, for både FS Admin og Min Kompetanse og for begge utstederne.

## Files Created
### 1. `fs-plattform/tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/coprocessor/IdportenAudienskontroll.java` (40 linjer)
En `@ApplicationScoped`-bønne som observerer `StartupEvent`. For `idporten` og `idporten-test` gjelder: er `tilgangsstyring.issuer.<tenant>` satt og `quarkus.oidc.<tenant>.token.audience` mangler eller er blank, kastes `IllegalStateException`. Meldingen navngir begge egenskapene. Selve sjekken er `static kontroller(Config)`, så den kan enhetstestes.

### 2. `…/src/test/java/no/sikt/fs/tilgangsstyring/coprocessor/IdportenAudienskontrollTest.java` (141 linjer, 10 tester)
- Kontrollen alene: utsteder uten audiens feiler, med begge egenskapene i meldingen. Test-tenanten kontrolleres for seg. Blank audiens teller som manglende. Konfigurert og fraværende slipper gjennom.
- Profilene slik oppstarten leser dem: `application.properties` pluss `application-<profil>.properties`, lastet med `SmallRyeConfigBuilder.withProfile`.
  - `platon-production` har ingen `quarkus.oidc.idporten*`- eller `tilgangsstyring.issuer.idporten*`-egenskaper, og kontrollen slipper den gjennom.
  - Legges `tilgangsstyring.issuer.idporten` inn i produksjon uten audiens, feiler kontrollen.
  - `dev`, `docker-local`, `platon-test` og `test` har utsteder, og `token.audience` er lik `tilgangsstyring.audience.idporten`.

## Files Modified
### 1. `…/src/main/resources/application.properties`
ID-porten-blokken (tenant, utsteder og ny audiens) er skopet med `%dev,docker-local,platon-test.`, slik at `platon-production` ikke arver den. Den uprefiksede `tilgangsstyring.issuer.idporten` under «Configurable issuer URLs» er fjernet. `token.audience=${tilgangsstyring.audience.idporten}`. Verdien `urn:sikt:fs-graphql-api:ikke-registrert` er foreløpig og merket som ikke registrert hos Digdir. Kommentaren «token.audience er ikke satt — audiensen avklares med fs-admin» er erstattet.

### 2. `…/src/main/resources/application-platon-production.properties`
`idporten`- og `idporten-test`-tenantene og begge `tilgangsstyring.issuer.idporten*` er fjernet. I stedet står det en merknad: de legges inn når Digdir-registreringen gir audiensen, begge med `token.audience=${tilgangsstyring.audience.idporten}`.

### 3. `…/src/main/resources/application-test.properties`
Test-profilen har nå hele `idporten`-tenanten mot JWKS-stubben, fordi den ikke lenger arver den fra basen. Den har også `token.audience=${tilgangsstyring.audience.idporten}`, `tilgangsstyring.issuer.idporten` og testaudiensen `https://fs-graphql-api.test.invalid`.

### 4. `…/coprocessor/BearerTokenAuthenticator.java`
`tilgangsstyring.issuer.idporten` er `Optional<String>`, og `.orElse(null)` brukes som for `-test`. Uten utsteder er `idporten.no` en ukjent utsteder. Testmiljø-gaten (`IDPORTEN_TEST` bare mot syntetiske miljø) er uendret.

### 5. `…/coprocessor/IdportenAuthenticator.java`
Kommentaren om lazy injeksjon gjelder nå begge tenantene, fordi ingen av dem finnes i alle profiler. Ingen kodeendring.

### 6. `…/test/.../coprocessor/IdportenCoprocessorTest.java`
- Dual-profilen gir også `idporten-test` `token.audience=${tilgangsstyring.audience.idporten}`. Det er én verdi for begge tenantene.
- `idportenJwt(...)` setter tokenets `aud` fra konfigurasjonen. `idportenJwtUtenAudiens(...)` er basen.
- Nye `@ParameterizedTest` over `klienterOgUtstedere()` = {FS Admin, Min Kompetanse} × {`idporten.no`→production, `test.idporten.no`→test}:
  - `tokenForAnnenTjenesteAvvises` («Token utstedt for en annen tjeneste avvises»), med `aud=https://annen-tjeneste.example`
  - `tokenUtenAudiensAvvises`
  Begge bruker `avvisesUtenTokenOgUtenOppslag`: `control.break=401`, ingen intern autorisasjonsheader (forespørselen når ikke subgrafene) og ingen kall til `TilgangsstyringDataTilgangerService`.

### 7. `…/test/.../coprocessor/BearerTokenAuthenticatorTest.java`
Konstruktøren tar `Optional` for ID-porten-utstederen. Ny test: uten konfigurert ID-porten-utsteder er `idporten.no` ukjent, og `IdportenAuthenticator` røres ikke.

### 8. `…/test/.../coprocessor/CoprocessorResourceTest.java` og `…/test/.../EnvironmentGraphqlResourceTest.java`
ID-porten-tokenene setter `aud` fra `tilgangsstyring.audience.idporten`. Uten det ble de riktig avvist med 401, og testene deres gjelder noe annet.

## Key Features Implemented
### ✅ Audiensen er påkrevd og fail-closed
Tenanten sjekker `aud` mot én verdi, FS GraphQL API. Mangler verdien, feiler oppstarten. Det gjelder også hvis noen senere legger inn utstederen uten audiens.
### ✅ ID-porten er av i produksjon
Ingen tenant og ingen utsteder. Et `idporten.no`-token gir «Unknown token issuer» og 401.
### ✅ Avvisningen gjelder alle ID-porten-klienter
Testet med begge testklientene og begge utstederne.

## Project skills consulted
- `sta-development-starter-pack:telemetri-compliance` og `subgraph-expand` ble vurdert, men gjaldt ikke. Det er ingen ny logging, metrikk eller schema-endring.
- `fs-testdata-creation` gjaldt ikke. Det er ingen DB-endring.
- Ingen andre repo-lokale skills matchet OIDC- og konfigurasjonsarbeid.

## Test Results
Java/Maven-prosjekt. Testene er JUnit, ikke TypeScript.

- Målrettet: `mise exec -- mvn -q -pl :tilgangsstyring-app test -Dtest='Idporten*,Coprocessor*,BearerToken*,Maskinporten*,AnonymTilgang*' -Dsurefire.failIfNoSpecifiedTests=false` ga exit 0.
  - `IdportenCoprocessorTest` 24/24 (16 fra før + 8 nye)
  - `IdportenAudienskontrollTest` 10/10
  - `BearerTokenAuthenticatorTest` 6/6
  - `CoprocessorResourceTest` 87/87
  - `IdportenAuthenticatorTest` 4/4
  - `MaskinportenTestIssuerCoprocessorTest` 3/3
  - `AnonymTilgangCoprocessorTest` 7/7
  - `CoprocessorServiceAudienceTest` 2/2
- Hele app-suiten: `mise exec -- mvn -q -pl :tilgangsstyring-app test` ga 497 tester, 5 hoppet over.
  - `EnvironmentGraphqlResourceTest.idportenTokenGir401PaaSubgrafStien` feilet fordi tokenet manglet `aud`. Det er rettet, og `EnvironmentGraphqlResourceTest` går nå 23/23.
  - To feil gjenstår, og begge skyldes ikke-idempotente tester mot en gjenbrukt lokal base. De er uavhengige av denne endringen:
    - `RollekatalogForvaltningGraphqlTest.tildelingKunITestAvvises`, den kjente.
    - `SamlingstildelingerGraphqlTest.samlingTilgangerFilterKanter`: historikken har vokst til ti `IT_SAMLTILD_BATCH_A`-rader fra tidligere kjøringer, så B faller utenfor første side. Testen bruker ikke ID-porten.
- Oppstart, verifisert med den pakkede appen (`mvn -q -pl :tilgangsstyring-app package -DskipTests`, exit 0):
  - `java -Dquarkus.profile=dev,local -Dquarkus.http.port=18081 -Dreplicator.enabled=false -jar target/quarkus-app/quarkus-run.jar` ga «started in 4.225s».
  - Samme kommando med `-Dtilgangsstyring.issuer.idporten-test=https://test.idporten.no` ga «Failed to start application … IllegalStateException: tilgangsstyring.issuer.idporten-test is set, but quarkus.oidc.idporten-test.token.audience is missing. Without an audience the tenant accepts tokens issued for any service.»
  - `platon-production` kan ikke startes lokalt (Vault, Oracle via CMAN, RDS). Den er verifisert på konfigurasjonsnivå i `IdportenAudienskontrollTest.produksjon_utenIdporten`, med de ekte egenskapsfilene lastet i Quarkus' rekkefølge.

## Technical Decisions
### 1. ID-porten-blokken er profilskopet i basen (`%dev,docker-local,platon-test.`)
**Why**: profilfiler legges oppå `application.properties`, og ingen profil kan fjerne en egenskap. Sto tenanten ubeskyttet i basen, ville `platon-production` arvet `test.idporten.no` som sin `IDPORTEN`-utsteder, altså uten testmiljø-gaten. Med prefikset står blokken ett sted. Test-profilen eier sin egen blokk mot stubben, så det ikke blir tvil om prioritet mellom multiprofil-prefiks og profilfil.
### 2. Én verdi, `tilgangsstyring.audience.idporten`, med `token.audience=${…}`
**Why**: akseptansekriteriet sier én verdi for begge tenantene og begge appene. Når produksjon får tenantene, peker begge på samme egenskap.
### 3. En foreløpig audiens i dev, docker-local og platon-test
**Why**: kontrollen krever en verdi, og Digdir har ikke gitt én. Uten en verdi ville `mise run dev` og platon-test-deployen ikke startet. `urn:sikt:fs-graphql-api:ikke-registrert` er fail-closed, fordi ingen ekte token har den audiensen. Det finnes heller ingen Digdir-klient å teste med utenfor stubben ennå (analyse v3). Verdien byttes når registreringen finnes.
### 4. Oppstartskontroll i egen klasse
**Why**: `BearerTokenAuthenticator` er `@ApplicationScoped` og lazy, så en sjekk i konstruktøren ville kjørt ved første forespørsel og ikke ved oppstart. En egen observatør på `StartupEvent` med en statisk `kontroller(Config)` kan testes uten Quarkus.

## Build Status
✅ **Build successful**: `mvn -q -pl :tilgangsstyring-app package -DskipTests` ga exit 0.
✅ **No new linter warnings**
✅ **All imports resolved correctly**

## Integration Points
- `BearerTokenAuthenticator` ruter til `IdportenAuthenticator` bare når utstederen er konfigurert. Quarkus OIDC håndhever `token.audience`, og en feil gir `AuthenticationFailedException` og dermed 401.
- Subgraf-stiens ID-porten-gate (`AuthorizationHeaderAuthenticator`) er uendret.
- Utenfor repoet må to lokale oppsett nå sette `aud`, ellers avvises tokenene. Ingen av dem er sjekket inn, og ingen av dem er rørt:
  - `.mise.local.toml` (`dev-idporten`): tokenet må ha `aud=urn:sikt:fs-graphql-api:ikke-registrert`.
  - `demo/idporten/start.sh`: må få `-Dquarkus.oidc.<t>.token.audience=…` og `-Dtilgangsstyring.audience.idporten=…`, og `fake_idporten.py` må minte `aud`. Uten det stopper oppstartskontrollen demoen.

## Acceptance Criteria Met
- ✅ `token.audience` for `idporten` og `idporten-test` settes fra én påkrevd verdi i alle profiler som har tenanten. Evidens: `application.properties` (ID-porten-blokken), `application-test.properties`, `IdportenCoprocessorTest.DualIdportenIssuerProfile`, og `IdportenAudienskontrollTest.profilerMedTenanten_harAudiens`.
- ✅ `tilgangsstyring.issuer.idporten` er `Optional<String>`, og utsteder uten audiens stopper oppstarten med en tydelig melding. Evidens: `BearerTokenAuthenticator.java:46`, `IdportenAudienskontroll.java`, enhetstestene, og den manuelle oppstarten over.
- ✅ `platon-production` har ingen ID-porten-tenant eller -utsteder, appen starter (konfigurasjonsnivå), og merknaden står. Evidens: `application-platon-production.properties`, `IdportenAudienskontrollTest.produksjon_utenIdporten`.
- ✅ Test-profilen har en testaudiens, og feil audiens gir uautentisert uten at forespørselen når subgrafene. Evidens: `IdportenCoprocessorTest.tokenForAnnenTjenesteAvvises` og `tokenUtenAudiensAvvises`.
- ✅ Avvisningen gjelder uavhengig av `client_id`. Evidens: begge testene kjøres for `idporten-test-fs-admin` og `idporten-test-min-kompetanse`.

## Next Steps
- Når Digdir-registreringen finnes: bytt den foreløpige verdien i basen, og legg inn begge tenantene og utstederne i `platon-production` etter merknaden.
- Task #12 (dokumentasjon) kan nevne audienskravet og at ID-porten er av i produksjon.

## Conclusion
Audienskravet i TIL-PÅL-PÅL-003 håndheves for alle ID-porten-klienter, og en manglende verdi stopper oppstarten i stedet for å godta alt. Klar for review.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
