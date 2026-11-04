# Task #6 Completion Report: Ende-til-ende coprocessortest for ID-porten

## Status: ✅ COMPLETED

**Date Completed**: 2026-09-22
**Task**: Ende-til-ende coprocessortest for ID-porten
**Priority**: High
**Size**: M

## Summary

Ny `IdportenCoprocessorTest` kjører kravets scenarier gjennom hele coprocessorstien: token inn på
`/coprocessor/{env}`, utstedt token ut, parset og påstått på. Profilen speiler dual-utsteder-
oppsettet fra `platon-production` — `idporten.no` og `test.idporten.no` som hver sin OIDC-tenant
mot den lokale JWKS-stubben — etter mønster av `MaskinportenTestIssuerCoprocessorTest`.

Alle kravets fire regler har nå hver sin testmetode med scenarionavnet i `@DisplayName`. Ingen
produksjonskode er endret i denne oppgaven, og ingen defekt ble funnet i koden fra Task #1–#5.

## Files Created

### 1. `tilgangsstyring/tilgangsstyring-app/src/test/java/no/sikt/fs/tilgangsstyring/coprocessor/IdportenCoprocessorTest.java` (251 linjer)

`@QuarkusTest` mot `CoprocessorResource` med egen `DualIdportenIssuerProfile`. Sju testmetoder
(ni kjøringer med scenariomalens tre verdier), tokens signert med `SigningKeyConfig` og verifisert
mot `JwksResource`.

## Files Modified

Ingen.

## Key Features Implemented

### ✅ Dual-utsteder-profil for ID-porten

`DualIdportenIssuerProfile` setter `tilgangsstyring.issuer.idporten=https://idporten.no` og
`tilgangsstyring.issuer.idporten-test=https://test.idporten.no`, med `idporten-test`-tenanten
konfigurert mot `http://localhost:${quarkus.http.test-port}/jwks.json`
(`discovery-enabled=false`, `allow-jwt-introspection=false`, `application-type=service`). Ingen
test går ut på nettet, og begge utstederne verifiseres for ekte.

### ✅ Kravets scenarier én-til-én

| Krav (regel → scenario) | Testmetode | `@DisplayName` |
| --- | --- | --- |
| ID-porten er en egen utsteder → «Gyldig ID-porten-token godtas» | `gyldigIdportenTokenGodtas` | Gyldig ID-porten-token godtas |
| … → «Token med ugyldig signatur eller utløpt gyldighet avvises» | `ugyldigSignaturAvvises` | … — ugyldig signatur |
| … → samme scenario, andre halvdel | `utloptTokenAvvises` | … — utløpt gyldighet |
| `acr` bæres videre → scenariomalen | `autentiseringsnivaaBaeresIDetInterneTokenet` | Autentiseringsnivå fra ID-porten bæres i det interne tokenet (tre verdier) |
| Tilgangssettet er tomt → «Innlogget med ID-porten uten tildelte roller» | `innloggetUtenTildelteRoller` | Innlogget med ID-porten uten tildelte roller |
| Testmiljøet kan brukes → «Token fra ID-portens testmiljø godtas i syntetiske datamiljøer» | `testmiljoTokenGodtasISyntetiskDatamiljo` | Token fra ID-portens testmiljø godtas i syntetiske datamiljøer |
| … → gaten i samme scenario (`@openquestion`) | `testmiljoTokenAvvisesMotProduksjonsdata` | Token fra ID-portens testmiljø avvises mot produksjonsdata |

Påstandene per scenario:

- **Gyldig token godtas**: 200 med `control == "continue"`, `amr == ["idporten"]`,
  `sub` = tokenets `sub`, `nin` = `pid`, `client_id` fra tokenet, `aud == {production}`.
- **Avvisning**: `control.break == 401`, ingen `supergraph-authorization`-header, ingen
  databaseoppslag.
- **Scenariomal**: `acr` uendret ut for `idporten-loa-substantial`, `idporten-loa-high` og
  `selfregistered-email`.
- **Uten tildelte roller**: `orgtilganger` er nøyaktig de åpne rollene (tom JSON-diff),
  `never()` på de fire øvrige tilgangsoppslagene og `verifyNoInteractions(feideClient)`.
- **Testmiljø**: samme token gir 200 mot `test` og 401 mot `production`.

### ✅ Avvisningen er festet på tre ting samtidig

`avvisesUtenTokenOgUtenOppslag` påstår `control.break == 401`, at `supergraph-authorization`-headeren
mangler (forespørselen når ikke subgrafene) og `verifyNoInteractions` mot
`TilgangsstyringDataTilgangerService` (ingen databaseoppslag). Brukt av begge halvdelene av
avvisningsscenarioet og av testmiljø-gaten.

## Project skills consulted

Repoets egne skills (`/home/skurtveito/dev/sikt/fs-plattform/.claude/skills/`) er
`fs-testdata-creation` og `graphql-ytelsesanalyse`; `tilgangsstyring/` har ingen egen
`.claude/skills/`. Ingen av dem dekker denne oppgaven: testen oppretter ingen rader i
utviklingsdatabasen (tilgangsoppslaget er mocket) og rører verken GraphQL-ytelse eller subgrafens
skjema. Konvensjonene er hentet fra `CLAUDE.md`, `RETNINGSLINJER.md` → «Dokumentasjon og
kommentarer» (kommentarer kun der noe overrasker; ingen migrerings- eller saksreferanser i kode) og
`tilgangsstyring/CLAUDE.local.md`. Formen på testen er kopiert fra
`MaskinportenTestIssuerCoprocessorTest`.

## Test Results

Kjørt fra `/home/skurtveito/dev/sikt/fs-plattform/tilgangsstyring` (Maven og Java via mise):

```
mise exec -- mvn -o -pl :tilgangsstyring-app test -Dtest=IdportenCoprocessorTest
  → Tests run: 9, Failures: 0, Errors: 0, Skipped: 0 — BUILD SUCCESS

mise exec -- mvn -o -pl :tilgangsstyring-app test
  → Tests run: 453, Failures: 2, Errors: 0, Skipped: 5
    De to feilene er de kjente, pre-eksisterende på denne maskinen:
    SamlingstildelingerGraphqlTest.samlingTilgangerFilterKanter og
    DelegeringstakGraphqlTest.lesefeltet — append-only-tester der akkumulerte
    IT_*_BATCH_*-rader i den langlevde lokale PostgreSQL-en presser den forventede raden ut av
    første side. Ikke rørt, ingen databasenullstilling, ingen compose-operasjoner.
```

Regresjonsvernet er grønt uendret: `CoprocessorResourceTest` (70),
`MaskinportenTestIssuerCoprocessorTest` (3), `BearerTokenAuthenticatorTest` (8),
`IdportenAuthenticatorTest` (4), `FeideAuthenticatorTest` (10).

Java/JUnit er testformen i dette Maven/Quarkus-repoet; `npx tsx` er ikke relevant her.

### Verifiseringen skjer for ekte

Loggen fra kjøringen viser at de to avviste tokenene faktisk ble forkastet av OIDC-verifiseringen,
ikke av en formfeil lenger ute:

```
Token verification has failed: Invalid JWS Signature: …
Token verification has failed: The JWT is no longer valid - the evaluation time … is on or after
the Expiration Time …
```

### Mutasjonssjekk bevisst utelatt

De foregående oppgavene viste at testene var lastbærende ved å mutere produksjonskoden midlertidig.
Det er **ikke** gjort her: mutasjonen ville ha vært å fjerne `SyntetiskeDatamiljoer`-gaten i
`BearerTokenAuthenticator`, altså å svekke en sikkerhetsgate i arbeidstreet, og brukeren har
besluttet at det ikke skal gjøres.

Beviset som står i stedet er testparet: `testmiljoTokenGodtasISyntetiskDatamiljo` og
`testmiljoTokenAvvisesMotProduksjonsdata` sender **samme** token fra `https://test.idporten.no` mot
henholdsvis `test` og `production`, og får 200 med utstedt token mot det ene og 401 uten token mot
det andre. Utfallet kan da ikke skyldes tokenet eller verifiseringen — loggen har ingen
verifiseringsfeil for den avviste av de to — og må komme fra miljøvalget, som er nøyaktig det gaten
avgjør.

## Technical Decisions

### 1. Scenariene som påstår identitet kjører mot `production`

**Why**: `CoprocessorService.baererIdentitet` videresender ikke identiteten til en ekte person i et
syntetisk miljø. Mot `test` ville `sub` blitt `"sudo"` og `nin` utelatt, og akseptansekriteriets
«`sub` = tokenets `sub`, `nin` = `pid`» ville ikke kunnet påstås — ikke fordi ID-porten-stien er
feil, men fordi en annen, eksisterende regel slår inn. `production` er dessuten miljøet en
saksbehandler i kravet faktisk jobber i.

### 2. `pid` er et Tenor-nummer (måned + 80)

**Why**: testdataene skal ikke se ut som et ekte fødselsnummer. Bivirkningen er ønsket: nummeret er
syntetisk per definisjon, så påstandene henger ikke på at miljøet er ikke-syntetisk alene.

### 3. Begge halvdelene av avvisningsscenarioet er egne testmetoder

**Why**: «ugyldig signatur eller utløpt gyldighet» er to ulike veier til samme utfall, og en felles
testmetode ville skjult hvilken av dem som eventuelt slutter å virke. `@DisplayName` beholder
scenarionavnet i begge, med halvdelen som suffiks.

### 4. Scenariomalen er en `@ParameterizedTest` med kravets tre `acr`-verdier

**Why**: Gherkins «Eksempler»-tabell oversettes direkte til `@ValueSource`, så en ny verdi i kravet
er én linje i testen.

### 5. Egen testklasse, ikke flere tester i `CoprocessorResourceTest`

**Why**: dual-utsteder-oppsettet krever en egen `QuarkusTestProfile` (prod-utstederen må være
`https://idporten.no`, ikke test-utstederen som `application-test.properties` setter).
`idportenAuthorizationCode_faarApneRoller` i `CoprocessorResourceTest` er urørt — den fester
koblingen mellom utstederen og `tilganger_for_apne_roller` i standardprofilen, og dupliseres ikke
her; `innloggetUtenTildelteRoller` går lenger og påstår at settet er *nøyaktig* de åpne rollene.

## Build Status

✅ **Build successful** — testkildene kompilerer rent (42 testkilder), ingen endring i main
✅ **No new linter warnings** — ingen nye advarsler fra javac
✅ **All imports resolved correctly**

## Integration Points

- **`CoprocessorResource` / `CoprocessorService`**: testen går inn samme vei som Apollo Router, med
  `RouterRequest`-kroppen, og leser svaret som routeren ville gjort.
- **`JwksResource` + `SigningKeyConfig`**: begge ID-porten-tenantene henter nøkler fra appens egen
  JWKS-stubb, så signaturverifiseringen er ekte uten nettverk.
- **`BearerTokenAuthenticator`**: testmiljø-gaten dekkes nå både som enhetstest (Task #3) og
  ende-til-ende.
- **Task #7**: dokumentasjonen er ikke rørt her.
- **Fase 1b**: når audiensen avklares, skal profilen få `quarkus.oidc.idporten.token.audience` og
  testene et token med riktig `aud`.

## Acceptance Criteria Met

- ✅ Ny `IdportenCoprocessorTest` etter mønster av `MaskinportenTestIssuerCoprocessorTest`, med egen
  `QuarkusTestProfile` for idporten- og idporten-test-tenants mot lokal JWKS-stubb og tokens signert
  med `SigningKeyConfig` — Evidence: `IdportenCoprocessorTest.java:59-74` (profilen), `:205-212`
  (signeringen)
- ✅ «Gyldig ID-porten-token godtas»: 200 `continue`, `amr == ["idporten"]`, `sub` = tokenets `sub`,
  `nin` = `pid` — Evidence: `IdportenCoprocessorTest.gyldigIdportenTokenGodtas`
- ✅ «Token med ugyldig signatur eller utløpt gyldighet avvises»: `control.break == 401`, ingen
  `supergraph-authorization`-header, ingen databaseoppslag — Evidence: `ugyldigSignaturAvvises`,
  `utloptTokenAvvises`, begge via `avvisesUtenTokenOgUtenOppslag` med `verifyNoInteractions`
- ✅ Scenariomal «Autentiseringsnivå bæres»: alle tre verdiene havner uendret i `acr` — Evidence:
  `autentiseringsnivaaBaeresIDetInterneTokenet` (`@ValueSource` med kravets tre verdier, tre grønne
  kjøringer)
- ✅ «Innlogget uten tildelte roller»: `orgtilganger` er de åpne rollene og ingenting annet —
  Evidence: `innloggetUtenTildelteRoller` (JSON-diff mot forventet sett + `never()` på de fire
  øvrige tilgangsoppslagene og `verifyNoInteractions(feideClient)`)
- ✅ «Token fra ID-portens testmiljø»: godtas mot syntetisk miljø, avvises med 401 mot `production` —
  Evidence: `testmiljoTokenGodtasISyntetiskDatamiljo`, `testmiljoTokenAvvisesMotProduksjonsdata`

## Deviations

1. **Scenariene som påstår identitet kjører mot `production`, ikke `test`.** Se Technical
   Decisions #1: `baererIdentitet` stripper identiteten til en ekte person i syntetiske miljø, så
   `sub`/`nin` er bare påstålbare i et ikke-syntetisk miljø. Dette er den Feide-formede regelen
   planen flagget som risiko, ikke en ID-porten-defekt.
2. **`pid` er et Tenor-nummer** (`09899012345`), slik at testdataene ikke ligner et ekte
   fødselsnummer.
3. **Avvisningsscenarioet er splittet i to testmetoder** (ugyldig signatur / utløpt gyldighet), som
   oppgavens implementasjonsnotat ber om. Scenarionavnet står i `@DisplayName` for begge.
4. **Egen testklasse i stedet for flere tester i `CoprocessorResourceTest`**, fordi dual-utsteder-
   oppsettet krever sin egen `QuarkusTestProfile`. Task #5s
   `idportenAuthorizationCode_faarApneRoller` er urørt og ikke duplisert.
5. **Ingen mutasjonssjekk av testmiljø-gaten.** Se «Mutasjonssjekk bevisst utelatt» over: gaten er i
   stedet bevist av testparet med identisk token og ulikt miljø. Produksjonskoden er ikke rørt.

## Next Steps

- **Task #7**: `CoprocessorMetrikker`-javadoc og de to dokumentene i `tilgangsstyring/docs`.
- **`bat-verify`**: kravet er `@integration` uten brukerflate; disse testmetodene er beviset, og
  `@DisplayName` bærer scenarionavnene fra `.feature`-fila.
- **Fase 0/1b**: ende-til-ende mot ID-portens faktiske testmiljø, og audiensen, står fortsatt igjen
  — testene her bruker selvsignerte tokens, som planen forutsetter.

## Conclusion

Kravets fire regler har hver sin grønne ende-til-ende-test gjennom coprocessoren, avvisningene er
festet på både statuskode, manglende token og fravær av databaseoppslag, og de eksisterende
utstederne er uberørte. Klar for review og for Task #7.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
