# Task #1 Completion Report: Bær `acr` gjennom autentiseringsmodellen

## Status: ✅ COMPLETED

**Date Completed**: 2026-09-22
**Task**: Bær `acr` gjennom autentiseringsmodellen
**Priority**: High
**Size**: M

## Summary

`AuthorizationCodeResult` og `ClientCredentialsResult` har fått et nullbart `acr`-felt, og
verdien bæres fra det verifiserte utstedertokenet helt ut i tokenet coprocessoren utsteder —
med `addClaimIfPresent`, slik at claimet utelates når utstederen ikke leverte noe. Feide leser
`acr` fra tokenet sitt, Maskinporten setter null, og sudo følger samme presedens som `amr` og
subjekt. Verdien håndheves ingen steder, som kravet forutsetter.

## Files Created

Ingen nye filer. Endringen er formendring på eksisterende modell pluss testdekning i
eksisterende testklasser.

## Files Modified

### 1. `tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/coprocessor/model/AuthenticationResult.java` (71 linjer)
`@Nullable String acr` lagt til som siste komponent i både `ClientCredentialsResult` og
`AuthorizationCodeResult`, med en kort javadoc om at verdien bæres videre og ikke håndheves.

### 2. `tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/coprocessor/FeideAuthenticator.java` (108 linjer)
`extractIdentity` leser `acr` fra det verifiserte tokenet og sender det med i begge resultatene.
Ny privat `getAcr(JsonWebToken)` som ignorerer et `acr` som ikke er en streng — samme forsiktighet
som `act`-lesingen har fra før.

### 3. `tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/coprocessor/MaskinportenAuthenticator.java`
Setter `acr = null`, med én linje om hvorfor (client credentials — ingen person autentisert).

### 4. `tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/coprocessor/CoprocessorService.java` (756 linjer)
- `addClaimIfPresent(jwtBuilder, "acr", getAcr(authInfo))` i `buildSignedJwt`.
- Ny `getAcr(AuthenticationResult)` etter mønster fra `getAmr`/`getSubject`: sudo med påtatt
  identitet gir ingen `acr`, sudo uten påtatt identitet arver fra den faktiske autentiseringen,
  basic auth og manglende autentisering gir null, avviste forespørsler kaster som de øvrige.
- Den sudo-fakede kopien i `hentOrgTilganger` får `null` for `acr`.
- Alle posisjonelle record-mønstre utvidet med én komponent (`sti`, `getAmr`, `getSubject`,
  `describeSudoActor`, `hentActualOrgTilganger`).

### 5. `tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/auth/AuthorizationHeaderAuthenticator.java`
`devLogin` konstruerer `AuthorizationCodeResult` med `acr = null`.

### 6. `tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/auth/SessionIdentity.java`
Begge destruktureringene i `mount` utvidet med `var ignoredAcr` — subgraf-stien bruker ikke
verdien.

### 7. `tilgangsstyring/tilgangsstyring-app/src/test/java/no/sikt/fs/tilgangsstyring/coprocessor/FeideAuthenticatorTest.java` (285 linjer)
To nye tester: `acr` fra tokenet havner i resultatet / feltet er null uten claim, og et
`acr` som ikke er en streng ignoreres uten å kaste.

### 8. `tilgangsstyring/tilgangsstyring-app/src/test/java/no/sikt/fs/tilgangsstyring/coprocessor/CoprocessorResourceTest.java` (2505 linjer)
Ny test `acrBaeresVidereFraUtstederen`: et Feide-token med `acr` gir `acr` i det utstedte
tokenet, og et token uten `acr` gir et utstedt token uten claimet. Maskinporten-testen har fått
en `assertNull(parsed.getClaim("acr"))`. To små hjelpemetoder (`feideJwtMedClaims`,
`utstedtToken`) for å slippe å kopiere hele request-kroppen.

### 9. `tilgangsstyring/tilgangsstyring-app/src/test/java/no/sikt/fs/tilgangsstyring/SessionIdentityMountTest.java`
Konstruksjonen av `AuthorizationCodeResult` oppdatert til ny aritet.

## Key Features Implemented

### ✅ Nullbart `acr` på autentiseringsresultatene
`@Nullable String acr` (jspecify, som resten av modellen) på både `ClientCredentialsResult` og
`AuthorizationCodeResult`.

### ✅ `acr` i det utstedte tokenet, utelatt når det mangler
`addClaimIfPresent` — samme mønster som `name`/`email`/`nin`, så et token fra en utsteder uten
`acr` ser nøyaktig ut som før.

### ✅ Sudo-presedens lik `amr` og subjekt
Påtatt sudo-identitet (`Sudo-Username`/`Sudo-Fodselsnr`) → ingen `acr`; bare tilgangsaksen satt
→ `acr` fra den faktiske autentiseringen.

## Project skills consulted

Ingen av skillene i repoet dekker denne endringen: `fs-testdata-creation` og
`graphql-ytelsesanalyse` er de eneste repo-lokale skillene
(`/home/skurtveito/dev/sikt/fs-plattform/.claude/skills/`), og oppgaven rører verken testdata
eller GraphQL-skjema. Konvensjonene er hentet fra `CLAUDE.md`,
`RETNINGSLINJER.md` → «Dokumentasjon og kommentarer» (kommenterer bare det som overrasker, ingen
sak-/migrasjonsreferanser i kode) og `tilgangsstyring/CLAUDE.local.md`.

## Test Results

Kjørt fra `/home/skurtveito/dev/sikt/fs-plattform/tilgangsstyring` (Maven og Java via mise):

```
mise exec -- mvn -o -pl :tilgangsstyring-app test -Dtest=FeideAuthenticatorTest
  → Tests run: 10, Failures: 0, Errors: 0, Skipped: 0

mise exec -- mvn -o -pl :tilgangsstyring-app test -Dtest=CoprocessorResourceTest
  → Tests run: 69, Failures: 0, Errors: 0, Skipped: 0

mise exec -- mvn -o -pl :tilgangsstyring-app test
  → BUILD SUCCESS, alle testklasser grønne
    (OracleChangeApplierOracleTest: 5 skipped, som før — krever Oracle)
```

Testene er Java/JUnit i modulens egne testkataloger, som resten av prosjektet; ingen `node -e`
eller tsx er relevant her.

Den lokale PostgreSQL-instansen som allerede kjørte ble brukt av `@QuarkusTest`-ene. Ingen
docker compose-tjenester ble startet, stoppet eller nullstilt.

## Technical Decisions

### 1. `acr` som siste komponent i begge recordene
**Why**: `externalServiceId` ble i sin tid lagt til på samme måte, og posisjonelle mønstre i
`CoprocessorService` og `SessionIdentity` får da ett ekstra `_` i stedet for at eksisterende
bindinger forskyves — mindre risiko for stille feilbinding mellom felt som alle er `String`.

### 2. `acr` leses defensivt i `FeideAuthenticator`
**Why**: claimet er valgfritt hos Feide, og en utsteder kan legge et objekt eller et tall der.
`instanceof String` gir null i stedet for `ClassCastException`, på linje med hvordan `act`
allerede leses.

### 3. Den sudo-fakede kopien får `null`, ikke `it.acr()`
**Why**: kopien brukes bare til tilgangsoppslaget, og den nuller allerede ut alt som ikke er
nøkkel i oppslaget (issuer, subjekt, navn, hjemmeorganisasjon). `acr` inngår ikke i noe oppslag,
og claimet på denne stien styres av `getAcr`, der sudo-identitet uansett gir ingen `acr`.

### 4. Feide-client-credentials bærer også `acr` når tokenet har det
**Why**: mekanismen skal være uniform («bæres for alle utstedere»). En Feide
client-credentials-token har normalt ingen `acr`, så feltet blir null i praksis — men koden
dikter ikke opp en verdi og kaster heller ikke bort en som finnes.

## Build Status

✅ **Build successful** — `mise exec -- mvn -o -pl :tilgangsstyring-app test` gir BUILD SUCCESS
✅ **No new linter warnings** — ingen nye advarsler fra javac; prosjektet har ingen NullAway/
   errorprone-oppsett som endringen kunne brutt
✅ **All imports resolved correctly** — `@Nullable` var allerede importert i de berørte filene

## Integration Points

- **Tokenutstedelsen**: `acr` er et nytt, valgfritt claim i `supergraph-authorization`-headeren.
  Ingen nedstrøms konsument leser det i dag; headerstørrelsen øker bare når utstederen faktisk
  leverer en verdi.
- **Task #2 (`IdportenAuthenticator`)**: kan nå returnere `AuthorizationCodeResult` med `acr`
  fra ID-porten-tokenet uten videre modellendring.
- **Subgraf-stien** (`SessionIdentity.mount`): kompilerer mot ny aritet, bruker ikke verdien.

## Acceptance Criteria Met

- ✅ Nullbart `acr`-felt på begge recordene — Evidence:
  `tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/coprocessor/model/AuthenticationResult.java:46-71`
- ✅ Alle konstruksjonspunkter oppdatert — Evidence: `FeideAuthenticator.java:70,84`,
  `MaskinportenAuthenticator.java:46`, `AuthorizationHeaderAuthenticator.java:88`,
  `CoprocessorService.java:442-444`
- ✅ `buildSignedJwt` setter `acr` med `addClaimIfPresent` — Evidence:
  `CoprocessorService.java:542`; claimet mangler når verdien er null (testet)
- ✅ Feide leser `acr` fra det verifiserte tokenet; Maskinporten setter null — Evidence:
  `FeideAuthenticator.java:89-93`, `MaskinportenAuthenticator.java:45-46`, og
  `CoprocessorResourceTest.java:416`
- ✅ Sudo-presedens som `amr`/subjekt — Evidence: `CoprocessorService.getAcr`
  (`CoprocessorService.java:649-666`), `harSudoIdentitet(sudo) ? null : getAcr(actual)`
- ✅ Enhetstester for at `acr` havner i tokenet og at claimet mangler ellers — Evidence:
  `CoprocessorResourceTest.acrBaeresVidereFraUtstederen`,
  `FeideAuthenticatorTest.acrFraTokenBaeresMed`, `FeideAuthenticatorTest.ikkeStrengAcrIgnoreres`

## Next Steps

Task #2: `IdportenAuthenticator` + OIDC-tenant-konfigurasjon. Den setter `acr` fra ID-portens
token i `AuthorizationCodeResult` som nå finnes. Sudo-presedensen for `acr` er ikke dekket av en
egen test — den er dekket indirekte av at `getAcr` følger samme struktur som `getAmr`; en
eksplisitt sudo-test kan legges på hvis reviewer ønsker det.

## Conclusion

`acr` bæres nå gjennom hele autentiseringsmodellen uten å håndheves, formendringen på recordene
er gjennomført på alle kallsteder, og hele modulens testsuite er grønn. Klar for review og for
Task #2.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
