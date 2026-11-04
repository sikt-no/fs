# Task #7 Completion Report: Coprocessoren slår opp personen ved ID-porten-innlogging

## Status: ✅ COMPLETED

**Date Completed**: 2026-09-25
**Task**: Coprocessoren slår opp personen ved ID-porten-innlogging
**Priority**: High
**Size**: M

## Summary
ID-porten-grenen i coprocessoren kaller nå `tilganger_for_idporten_bruker(env, client_id, pid)`. Tilgangen regnes dermed som for en Feide-bruker, og appens tak avgjør om en uregistrert person får gulvet. Iterasjon 1s `tilgangerForApneRoller` er fjernet i Java, og `tilganger_for_apne_roller` er droppet i en ny migrering (0084), fordi funksjonen ikke hadde andre kallere. Når `client_id` er ukjent, får personen bare åpne roller. Det gir en WARN med `client_id` og telles i en egen coprocessorteller. `IdportenCoprocessorTest` kjører nå mot den lokale basen med testklientene fra eksempeldataene.

## Files Created
### 1. `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0084-idporten-klient-finnes.sql` (39 linjer)
- `idporten_klient_finnes(client_id) RETURNS BOOLEAN`: STABLE, SECURITY DEFINER, fast search_path. Funksjonen svarer sant for både aktive og deaktiverte klienter. Den har `REVOKE PUBLIC`, og bare `${coprocessor_role}` har EXECUTE.
- `DROP FUNCTION tilganger_for_apne_roller(TEXT)`. 0077 er ikke rørt, og headeren der står.

### 2. `…/tilgangsstyring-new-db/src/test/sql/75_idporten_klient_finnes.sql` (9 assertions)
Settet fester fem ting. FS Admin (test) og Min kompetanse (test) er kjente. En deaktivert klient er også kjent. Ukjent klient, `NULL` og en Feide-`service_id` er ikke kjent. App- og replikeringsrollen har ikke EXECUTE, men coprocessorrollen kan kalle funksjonen uten tabellrettigheter, og app-rollen får 42501.

## Files Modified
### 1. `…/db/changelog/db-changelog-root.xml`
Include for 0084 med avhengighetskommentar, og en merknad på 0077-kommentaren om at funksjonen fjernes i 0084. Det er en XML-kommentar, så det påvirker ingen checksum.

### 2. `…/src/test/sql/68_apne_roller_uten_tildelinger.sql` (omskrevet, 9 assertions)
Settet testet den fjernede funksjonen. Det tester nå den samme egenskapen gjennom den nye inngangen. Med `tilganger_for_idporten_bruker('test', <ukjent klient>, NULL)` skal svaret være de åpne rollene, rolleekspandert og filtrert på subgrafrolle, og bare det: ikke et annet miljø, ikke en tildeling og ikke en forretningsrolle. Det samme gjelder gjennom coprocessorrollen. DEL 2 fester at `tilganger_for_apne_roller` er borte.

### 3. `…/src/test/sql/74_tilganger_for_idporten_bruker.sql`
Fasiten for «bare åpne roller» var `tilganger_for_apne_roller('test')`, som ikke finnes lenger. Den er byttet ut med et temp-view `apne_i_test`, som er `utvidede_apne_roller('test')` filtrert på subgrafrolle. Det er det samme uttrykket som kroppen til 0077 hadde. Ingen påstander er endret.

### 4. `…/tilgangsstyring-app/.../coprocessor/TilgangsstyringDataTilgangerService.java`
- `tilgangerForIdportenBruker(env, clientId, nin)` kaller `TILGANGER_FOR_IDPORTEN_BRUKER` med `@Retry` som de andre oppslagene.
- `idportenKlientFinnes(clientId)` er package-private og har `@CacheResult(cacheName = "idporten-klient")`. Den har ingen `@Retry`.
- `tilgangerForApneRoller` er fjernet sammen med javadoc-en som kalte de åpne rollene «gulvet».

### 5. `…/coprocessor/CoprocessorService.java`
- ID-porten-grenen i `hentActualOrgTilganger` tar ut `clientId` og kaller `hentIdportenTilganger(env, clientId, nin)`. Kommentaren som sa «bare modellens gulv», er skrevet om. Nå forklarer den at taket er ID-porten-appens og slås opp på `client_id`.
- `hentIdportenTilganger` logger oppslaget på debug med `Fodselsnummer.sladd(nin)`, gjør tilgangsoppslaget og sjekker deretter klienten. Er klienten ukjent, telles den, og det logges en WARN første gang per `(tillitsdomene, klient)`, med tak på 200, etter samme mønster som `loggForsteGang`. En manglende `client_id` telles som `mangler`.
- `erKjentIdportenKlient` fanger feil i sjekken og svarer da «kjent». Sjekken finnes bare for varselet, så en feil i den skal ikke velte innloggingen.

### 6. `…/coprocessor/CoprocessorMetrikker.java`
Ny teller `tilgangsstyring.coprocessor.idporten.ukjent.klient` med taggene `miljo` (rullet opp til tillitsdomenet) og `klient`, og metoden `tellUkjentIdportenKlient(miljo, klient)`.

### 7. `…/coprocessor/CoprocessorTaggtak.java`
Taket for den nye telleren er 20 verdier på `miljo` og 50 på `klient`, samme tak som `sudo.avvik`. Klassedokumentasjonen nevner telleren.

### 8. `…/tilgangsstyring-app/src/main/resources/application.properties`
Cachen `idporten-klient`: `maximum-size=100`, `expire-after-write=3600S`.

### 9. `…/src/test/java/.../coprocessor/IdportenCoprocessorTest.java` (omskrevet)
- `@InjectSpy` på `TilgangsstyringDataTilgangerService` og `CoprocessorMetrikker` i stedet for `@InjectMock`. Oppslagene går mot den ekte basen, og `verifyNoInteractions` i avvisningstestene virker fortsatt.
- Profilen har også JDBC-overstyringen fra `DockerAwarePostgresHostProfile`, slik at CI når basen via `docker`.
- `CLIENT_ID = "fs-admin"` er erstattet av testklientene `idporten-test-fs-admin` og `idporten-test-min-kompetanse`.
- Fikstur via admin-tilkoblingen, med negative id-er og egen kode:
  - person -9771 med `pid` 09899077001 og saksbehandler @ 7777 test,
  - deaktivert ID-porten-app -9772 (`idporten-it-deaktivert`),
  - åpen rolle `IT_IDPORTEN_APEN` @ 97701 test.

  Den åpne rollen lukkes i `@AfterAll`, og en rolle som er blitt stående åpen etter en avbrutt kjøring, lukkes i `@BeforeAll`. Åpne roller gjelder alle kallere, så en rolle som ble stående, ville endret svaret i andre tester.
- Fasiten for «bare åpne» leses fra basen (`utvidede_apne_roller('test')` filtrert på subgrafrolle) og er ikke hardkodet.

### 10. `…/coprocessor/CoprocessorResourceTest.java`
Den mock-baserte ID-porten-testen stubber og verifiserer nå `tilgangerForIdportenBruker(eq("test"), eq("fs-admin"), eq("09090912345"))`. Det er enhetsbeviset for at tokenets `client_id` og `pid` går inn i kallet. Feide-testen uten service-id verifiserer `never()` på den nye metoden.

### 11. `…/coprocessor/CoprocessorMetrikkerTest.java`
Ny test som viser at `klient` på den nye telleren samles under `ukjent` over taket på 50.

### 12. `fs-plattform/tilgangsstyring/docs/coprocessor-metrikker.md`
Ny seksjon «Telleren på ukjente ID-porten-klienter». Den beskriver taggene, begrunner hvorfor det er en egen teller og ikke en `resultat`-verdi, og forklarer at en deaktivert klient ikke telles. Den beskriver også WARN-dedupliseringen og cachen og har en PromQL-spørring. Setningen om taggtaket nevner den nye telleren.

## Key Features Implemented
### ✅ Personoppslag ved ID-porten-innlogging
`(tak ∩ (tildelinger ∪ gulv)) ∪ åpne − nekt` med personen på `pid` og appen på `client_id`. Oppslaget går i ett kall til `tilganger_for_idporten_bruker`, og det finnes ingen særlogikk i Java.
### ✅ Ukjent klient er synlig
Personen får bare åpne roller og ingen 401. Hendelsen gir én WARN per ny klient og telles i `tilgangsstyring.coprocessor.idporten.ukjent.klient`.
### ✅ 0077-inngangen er fjernet
Funksjonen er borte i Java og i basen (0084), og pgTAP 68 fester at den ikke finnes.

## Project skills consulted
- `sta-development-starter-pack:telemetri-compliance`: brukt til formen på den nye telleren og loggen. Tre krav var relevante. PII skal ikke i klartekst: `pid` logges bare sladdet, og `client_id` er ikke persondata. Egne metrikker skal ha applikasjonsprefiks: `tilgangsstyring.coprocessor.…`. DEBUG skal ikke brukes i produksjon: personoppslaget logges på debug, og varselet på WARN.
- `fs-testdata-creation` er vurdert, men ikke brukt. Testfiksturen er testskopet og seedes i testen, slik som i `DelegeringstakGraphqlTest`.
- Ingen GraphQL- eller schema-endringer, så `subgraph-expand` og lignende gjaldt ikke.

## Test Results
Dette er et Java/Maven-prosjekt. Testene er JUnit og pgTAP, ikke TypeScript.

- pgTAP (Testcontainers, alle migreringer mot tom base): `mise exec -- mvn -q -pl :tilgangsstyring-new-db test` ga `tests="1434" errors="0" failures="0"`. Det er 1426 − 10 (gamle 68) + 9 (nye 68) + 9 (75).
- Lokal base: `mise run migrate` og `mise run jooq` ga BUILD SUCCESS. `IdportenKlientFinnes` er generert, og `TilgangerForApneRoller` er borte.
- Målrettet: `mise exec -- mvn -q -pl :tilgangsstyring-app test -Dtest='Idporten*,Coprocessor*' -Dsurefire.failIfNoSpecifiedTests=false`
  - `IdportenCoprocessorTest` 16/16
  - `CoprocessorResourceTest` 87/87
  - `CoprocessorMetrikkerTest` 8/8
  - `IdportenAuthenticatorTest` 4/4
  - `AnonymTilgangCoprocessorTest` 7/7
  - `CoprocessorServiceAudienceTest` 2/2
  - `MaskinportenTestIssuerCoprocessorTest` 3/3
- Hele suiten: `mise exec -- mvn -q -pl :tilgangsstyring-service,:tilgangsstyring-app test` ga app 478 tester, 1 feil og 5 hoppet over. Feilen er `RollekatalogForvaltningGraphqlTest.tildelingKunITestAvvises`, den kjente ikke-idempotensen mot en gjenbrukt base. Den er uavhengig av denne endringen.
- Etter kjøringen er fiksturens åpne rolle lukket i den lokale basen, verifisert med en spørring.

Scenariene i `IdportenCoprocessorTest`, i miljøet `test` med utsteder `test.idporten.no`:

| Test | Scenario | Sporer til |
|---|---|---|
| `innloggetUtenTildelteRoller` | uregistrert via FS Admin gir nøyaktig åpne roller (og forutsetning: de er ikke tomme). Ingen Feide-oppslag og ingen telling | 003 |
| `registrertMedRolleGirRollensOrgtilganger` | registrert via FS Admin gir åpne ∪ saksbehandler @ 7777 | 003, BRU-PER-GRU-013 |
| `uregistrertViaMinKompetanseFaarGulvet` | uregistrert via Min Kompetanse gir åpne ∪ student @ 7777/7778 | 004 regel 1 |
| `innloggingViaMinKompetanseRegistrererIkkePersonen` | ingen `personsubjekt`-rad for `pid` etter innloggingen | 004 regel 2 |
| `sammePersonViaToKlienterGirUliktToken` | samme `pid` via Min Kompetanse og FS Admin gir ulik `orgtilganger`, både for uregistrert og registrert person | analyse v3, funn 2 |
| `registrertViaMinKompetanseBegrensesAvTaket` | registrert via Min Kompetanse gir åpne ∪ gulv, uten saksbehandler | delta-beslutning 2 (ikke 004) |
| `ukjentClientIdGirBareApne` | registrert person via ukjent klient gir nøyaktig åpne roller. Klienten telles | 004 regel 3 |
| `deaktivertAppGirTomt` | token utstedt, `orgtilganger` tomt, ingen telling | analyse v3, spørsmål 1 |

## Technical Decisions
### 1. Ukjent klient oppdages med et eget oppslag som caches
**Why**: `tilganger_for_idporten_bruker` gir bare rader. For en ukjent klient er radene like svaret for en kjent klient uten tak, så de kan ikke skille de to. Et flagg i samme funksjon ville krevd en ny signatur via DROP/CREATE i en ny migrering, og akseptansekriteriet binder Java-metoden til `tilganger_for_idporten_bruker`. Svaret er per klient og ikke per person. Med `@CacheResult` er tilgangsoppslaget derfor det eneste databasekallet per innlogging, bortsett fra første gang per klient og time. Det følger mønsteret til `organisasjonskodeGittDomene`. Sjekken har ingen `@Retry`, så den bruker ikke av tidsbudsjettet for et svar innloggingen ikke trenger. Feiler den, går innloggingen videre uten varsel. Et utdatert cache-svar gir i verste fall et varsel for mye, fordi nye klienter kommer via migrering.
### 2. Egen teller, ikke en `resultat`-verdi eller en tagg på `forespoersler`
**Why**: planen lot valget stå åpent mot `docs/coprocessor-metrikker.md` og taggtaket. Utfallet for kalleren er `beriket`, og en ny `resultat`-verdi ville fått «beriket»-tallene til å stemme dårligere. En tagg på `forespoersler` ville doblet alle seriene for å skille ut én sti. `sudo.avvik` er presedens for en egen teller med verifisert `klient` og tak på 50 i `CoprocessorTaggtak`.
### 3. En deaktivert klient er «kjent»
**Why**: den gir tomt resultat og er et bevisst stengsignal, ikke en feilkonfigurasjon (analyse v3, spørsmål 1). Den skal ikke utløse varselet om ukjent klient.
### 4. `tilganger_for_apne_roller` droppes i 0084
**Why**: akseptansekriteriet sier at funksjonen skal fjernes hvis den ikke har andre kallere. Søket fant ingen i Java, sudo-stiene eller `AnonymTilgang`. Funksjonen ble bare brukt som fasit i pgTAP 68 og 74, og begge er skrevet om. Den kom inn på denne branchen (BAT-244) og er ikke deployert.
### 5. Coprocessortesten kjører mot den ekte basen
**Why**: kriteriene om ingen `personsubjekt`-rad, deaktivert app og ulikt token via to klienter krever den faktiske beregningen. Med mocker kunne testene vært grønne selv om `client_id` ble ignorert (funn 2).

## Build Status
✅ **Build successful**: new-db (pgTAP 1434/1434), migrate, jooq, service og app kompilerer
✅ **No new linter warnings**
✅ **All imports resolved correctly**: ingen referanser til `tilgangerForApneRoller` eller `TILGANGER_FOR_APNE_ROLLER` står igjen i Java

## Integration Points
- **Task #8**: audiensen. Uten håndhevet audiens kan hvilken som helst ID-porten-klient sende tokens. De vil vises som ukjente klienter i den nye telleren, med tak på 50.
- **Task #12, `docs/tilgangsmodell.md`**: linje ~360–371 beskriver fortsatt `tilganger_for_apne_roller (0077)` som en av åtte selektorer. Den linjen må erstattes av `tilganger_for_idporten_bruker` (0083), og avsnittet om at `tilganger_for_apne_roller` er GRANT-et til coprocessorrollen alene må rettes. `idporten_klient_finnes` (0084) er også GRANT-et bare til coprocessorrollen. Jeg har ikke rørt filen, fordi den hører til Task #12.
- Sudo med `sudoUsername` for en ID-porten-bruker gir fortsatt tomt resultat (funn 11, utenfor scope). Den er ikke endret.

## Acceptance Criteria Met
- ✅ `tilgangerForIdportenBruker(env, clientId, nin)` kaller `tilganger_for_idporten_bruker` med tokenets `client_id` og `pid`. Evidence: `TilgangsstyringDataTilgangerService.java` (`tilgangerForIdportenBruker`), `CoprocessorResourceTest.idportenAuthorizationCode_slaarOppPaaClientIdOgPid` (eksakte argumenter) og `IdportenCoprocessorTest.innloggetUtenTildelteRoller` (verify).
- ✅ ID-porten-grenen bruker metoden. `tilgangerForApneRoller` er borte, og `tilganger_for_apne_roller` er fjernet (0084). Evidence: `CoprocessorService.hentActualOrgTilganger` og `hentIdportenTilganger`, `0084-idporten-klient-finnes.sql`, og pgTAP 68 DEL 2.
- ✅ Ukjent `client_id` gir bare åpne roller og ikke 401, logges som WARN med `client_id` og telles. Evidence: `ukjentClientIdGirBareApne` (200 + continue, nøyaktig åpne og `verify(metrikker).tellUkjentIdportenKlient("test", UKJENT_KLIENT)`), `varsleUkjentIdportenKlientForsteGang` og `CoprocessorMetrikker.tellUkjentIdportenKlient`.
- ✅ Testklientene fra eksempeldataene brukes. Evidence: `IdportenCoprocessorTest` (`FS_ADMIN`, `MIN_KOMPETANSE`).
- ✅ De fire scenariene finnes. Evidence: `registrertMedRolleGirRollensOrgtilganger`, `innloggetUtenTildelteRoller`, `uregistrertViaMinKompetanseFaarGulvet` og `ukjentClientIdGirBareApne`.
- ✅ Stubben utsteder tokens med ulik `client_id` for samme `pid`, og det interne tokenet blir ulikt. Evidence: `idportenJwt(issuer, clientId, pid)` og `sammePersonViaToKlienterGirUliktToken`.
- ✅ Registrert person via Min Kompetanse: roller utenfor taket er ikke med, men gulvet er det, og testen sporer til delta-beslutning 2. Evidence: `registrertViaMinKompetanseBegrensesAvTaket`, der både DisplayName og kommentar viser til beslutningen.
- ✅ Deaktivert app: forespørselen autentiseres, og `orgtilganger` er tomt. Evidence: `deaktivertAppGirTomt`.
- ✅ 004 regel 2: ingen `personsubjekt`-rad etter innlogging via Min Kompetanse. Evidence: `innloggingViaMinKompetanseRegistrererIkkePersonen`.
- ✅ Kommentarene er rettet. Kommentaren i `hentActualOrgTilganger` beskriver den nye grenen, og javadoc-en på `tilgangerForApneRoller` er borte sammen med metoden. Headeren i 0077 står urørt. Evidence: `CoprocessorService.java:749-756` og `0077` uendret.
- ✅ Fødselsnummeret logges sladdet. Evidence: `hentIdportenTilganger` logger `Fodselsnummer.sladd(nin)`. WARN-en for ukjent klient inneholder ikke `pid`.

## Next Steps
- Task #8 (audiens fail-closed) og Task #12 (dokumentasjon, se Integration Points om `docs/tilgangsmodell.md`).
- 0084 er kjørt mot den lokale basen og skal ikke redigeres (checksum).

## Conclusion
Task #7 er ferdig og testet ende til ende mot basen. Coprocessoren bruker nå `client_id` og `pid` på ID-porten-stien, og 003- og 004-scenariene, delta-beslutning 2 og deaktiveringsvetoet er festet i `IdportenCoprocessorTest`. Jeg har ikke kjørt noen git-kommandoer og ikke rørt `spec.log.md` eller planen.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
