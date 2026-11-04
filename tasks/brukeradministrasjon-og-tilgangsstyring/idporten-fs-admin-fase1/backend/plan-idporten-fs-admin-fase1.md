# Plan: ID-porten som utsteder i coprocessoren (fase 1)

Bygger på [`analysis-idporten-fs-admin-fase1.md`](analysis-idporten-fs-admin-fase1.md) og
kravet `TIL-PÅL-PÅL-003` i [`spec-idporten-fs-admin-fase1.md`](../spec/spec-idporten-fs-admin-fase1.md).
Alle sju åpne spørsmål i analysen er avklart; beslutningene er premisser her.

## Proposed Solution

### Architecture Approach

ID-porten legges inn som en fjerde utsteder langs den eksisterende aksen i coprocessoren:
`iss` leses usignert i `BearerTokenAuthenticator`, verifiseringen delegeres til en navngitt
Quarkus OIDC-tenant, og resultatet blir en `AuthorizationCodeResult` som resten av
`CoprocessorService` allerede vet hva den skal gjøre med. Ingenting i tokenutstedelsen,
metrikkene eller miljøhåndteringen trenger å endres for å kjenne ID-porten — de leser
utstedernavnet fra resultatet.

Fire ting bryter med «bare en gren til», og de er det planen egentlig handler om:

1. **`acr` finnes ikke i modellen.** Et nullbart felt legges på autentiseringsresultatene og
   bæres videre med `addClaimIfPresent`. Dette treffer alle utstedere, ikke bare ID-porten.
2. **Utstedertilliten må bli sti-avhengig.** `BearerTokenAuthenticator` deles med
   subgraf-stien, så ID-porten åpnes begge steder med mindre kallstedet skiller dem.
3. **Åpne roller må hentes aktivt.** Dagens `Orgtilganger.EMPTY`-snarvei gir mindre enn
   kravets «kun tilgang til det som er åpent for alle innloggede brukere».
4. **Ingen userinfo-runde.** Feide-flyten henter identitet via to sekvensielle HTTP-kall;
   ID-porten leverer `pid`, `acr` og `sub` i selve tokenet. Det holder oss innenfor
   tidsbudsjettet uten videre tiltak, og er en egenskap ved designet som må bevares.

### Key Technical Decisions

1. **Sti-gating med to navngitte metoder** — `BearerTokenAuthenticator` får
   `authenticateForCoprocessor(...)` og `authenticateForSubgraf(...)` over en felles privat
   kjerne som tar settet av tillatte utstedere.
   - *Hvorfor:* kallstedet navngir stien, og det finnes ingen boolean eller enum-verdi som kan
     sendes feil. Policyen blir værende i authenticatoren.
   - *Vurdert alternativ:* en `Sti`-parameter på dagens metode (mindre diff, men stien blir en
     verdi noen kan glemme), og at kallerne holder hvert sitt sett av godtatte utstedere
     (sprer policyen på to steder).

2. **`acr` som nullbart felt, satt med `addClaimIfPresent`** — samme mønster som
   `name`/`email`/`nin`.
   - *Hvorfor:* kravet sier «alltid, for alle utstedere», men Maskinporten er client
     credentials uten brukerautentisering. Mekanismen blir uniform uten å dikte opp et
     autentiseringsnivå der ingen person er autentisert.
   - *Vurdert alternativ:* kun ID-porten (bryter ordlyden), eller konstruerte verdier for alle
     (claimet ville løyet).

3. **`sub` = ID-portens `sub`, `pid` → `nin`** — fødselsnummeret havner i det claimet
   nedstrøms allerede leser og som alltid sladdes i logg.
   - *Hvorfor:* `sub` logges usladdet i coprocessoren og leses opakt av `utdanningsregisteret`
     og `sis`.
   - *Vurdert alternativ:* `pid` som `sub` (én identifikator, men fnr i et felt som logges i
     klartekst).

4. **Åpne roller via ny `SECURITY DEFINER`-funksjon** — `tilganger_for_apne_roller(p_env)`,
   en tynn wrapper over `utvidede_apne_roller(p_env)`, granted til `${coprocessor_role}`.
   - *Hvorfor:* alle sju eksisterende tilgangsfunksjoner har `∪ åpne` innebygd; uten dette blir
     ID-porten den eneste utstederen der en autentisert bruker havner under modellens gulv.
   - *Vurdert alternativ:* bokstavelig tomt sett (null kode, men avviket ville dukket opp igjen
     i fase 2a).
   - **Viktig avgrensning:** koblingen i `hentActualOrgTilganger` må gjelde *kun* når utstederen
     er `idporten`. Dagens `externalServiceId == null → EMPTY` er en bevisst fail-closed for
     Feide, og den skal stå.

5. **Egen testutsteder, gated til syntetiske datamiljø** — `tilgangsstyring.issuer.idporten-test`
   som `Optional<String>`, nøyaktig som `maskinporten-test`.
   - *Hvorfor:* kravets `@openquestion`-scenario er formulert som «godtas i syntetiske
     datamiljøer», og mønsteret med tilhørende test finnes ferdig.

6. **Bygg mot selvsignerte tokens** — full testdekning nå via `JwksResource` som lokal
   JWKS-stubb; ende-til-ende mot ID-portens testmiljø er en egen oppfølging når
   klientregistreringen hos Digdir (fase 0) er på plass.

### File Changes Overview

**`tilgangsstyring-app` — endres:**

- `coprocessor/model/AuthenticationResult.java` — nullbart `acr` på `AuthorizationCodeResult`
  og `ClientCredentialsResult`.
- `coprocessor/CoprocessorService.java` — `acr`-claim i `buildSignedJwt`; issuer-skopet
  tilgangsoppslag for `idporten` i `hentActualOrgTilganger`; oppdatert sudo-kopi i
  `hentOrgTilganger`.
- `coprocessor/BearerTokenAuthenticator.java` — ID-porten-gren, testutsteder-gate, to navngitte
  inngangsmetoder.
- `coprocessor/FeideAuthenticator.java`, `coprocessor/MaskinportenAuthenticator.java`,
  `auth/AuthorizationHeaderAuthenticator.java` — nye recordfelt ved konstruksjon.
- `coprocessor/TilgangsstyringDataTilgangerService.java` — `tilgangerForApneRoller(env)`.
- `coprocessor/CoprocessorMetrikker.java` — javadoc: `sti`-verdimengden får `idporten`.
- `src/main/resources/application.properties`, `application-test.properties`,
  `application-platon-production.properties` — OIDC-tenant og utsteder-URL-er.

**`tilgangsstyring-app` — nye filer:**

- `coprocessor/IdportenAuthenticator.java`
- `src/test/java/.../coprocessor/IdportenCoprocessorTest.java`

**`tilgangsstyring-new-db` — nye filer:**

- `src/main/resources/db/changelog/0072-apne-roller-uten-tildelinger.sql` (+ include i
  `db-changelog-root.xml`)
- `src/test/sql/63_apne_roller_uten_tildelinger.sql`

**`tilgangsstyring/docs`** — `tilgangsmodell.md` (ny funksjon i funksjonstabellen),
`en-instans-for-alle-miljo.md` (sti-avhengig utstedertillit).

**Ingen GraphQL-endringer.** Kravet er `@integration` og har ingen brukerflate; subgrafens
skjema røres ikke, og `bat-graphql-dev` er derfor ikke kjørt.

## Implementation Tasks

### Task #1: Bær `acr` gjennom autentiseringsmodellen ✅

Fullført 2026-09-22 — se [`task-1-completion.md`](task-1-completion.md).

**Priority**: High
**Size**: M
**Dependencies**: None
**Addresses Requirements**: `TIL-PÅL-PÅL-003`, regel «Autentiseringsnivået (acr) bæres videre, men håndheves ikke i fase 1»

**Acceptance Criteria**:

- [ ] `AuthorizationCodeResult` og `ClientCredentialsResult` har et nullbart `acr`-felt
      (`@Nullable`, jspecify som resten av modellen).
- [ ] Alle konstruksjonspunkter er oppdatert: `FeideAuthenticator.extractIdentity`,
      `MaskinportenAuthenticator.authenticate`, `AuthorizationHeaderAuthenticator.devLogin`,
      og den sudo-fakede kopien i `CoprocessorService.hentOrgTilganger`.
- [ ] `buildSignedJwt` setter `acr` med `addClaimIfPresent` — claimet utelates når verdien er null.
- [ ] Feide leser `acr` fra det verifiserte tokenet når claimet finnes; Maskinporten setter null.
- [ ] Sudo-stien bærer `acr` fra den faktiske autentiseringen når ingen sudo-identitet er påtatt,
      og ingen `acr` når den er det — samme presedens som `amr` og subjekt.
- [ ] Enhetstest som viser at `acr` havner i det utstedte tokenet, og at claimet mangler når
      utstederen ikke leverte en.

**Implementation Notes**:
Gjøres først fordi det endrer formen på recordene alt annet bygger på. Verdien håndheves ikke
noe sted — det er eksplisitt i kravet. Ikke sladd `acr` i logg; den er ikke persondata.

### Task #2: `IdportenAuthenticator` og OIDC-tenant-konfigurasjon ✅

Fullført 2026-09-22 — se [`task-2-completion.md`](task-2-completion.md).

**Priority**: High
**Size**: M
**Dependencies**: Task #1
**Addresses Requirements**: `TIL-PÅL-PÅL-003`, regel «ID-porten er en egen utsteder i coprocessoren»

**Acceptance Criteria**:

- [ ] Ny `IdportenAuthenticator` med `@Tenant("idporten")` og `@Tenant("idporten-test")`,
      samme form som `MaskinportenAuthenticator` (lazy tenant-oppslag, 250 ms `await().atMost`).
- [ ] Feilhåndtering dekker de tre kildene separat, som i de eksisterende authenticatorene:
      `AuthenticationFailedException`, `TimeoutException` og `OIDCException` → hver sin
      `AuthenticationFailedResult` med egen begrunnelse.
- [ ] Returnerer `AuthorizationCodeResult` med `issuer = "idporten"`, `subject` = tokenets `sub`,
      `nin` = `pid`, `acr` = tokenets `acr`, `clientId` = `client_id`,
      `externalServiceId = null`, `schacHomeOrganization = null`, `email = null`, `name = null`.
- [ ] **Ingen userinfo-kall.** Alle claims leses fra det verifiserte tokenet.
- [ ] OIDC-tenant satt i `application.properties` (default/test-URL),
      `application-platon-production.properties` (prod + test-utsteder) og
      `application-test.properties` (lokal JWKS-stubb mot `JwksResource`), med
      `discovery-enabled=false`, `allow-jwt-introspection=false`, `application-type=service`.
- [ ] `tilgangsstyring.issuer.idporten` satt i alle profiler;
      `tilgangsstyring.issuer.idporten-test` kun i `platon-production`.
- [ ] `token.audience` er **ikke** satt — audiensen avklares med fs-admin (fase 1b), se Risiko.

**Implementation Notes**:
`MaskinportenAuthenticator` er den nærmeste malen — samme struktur, to tenants, én privat
felles metode. Kommentaren om at test-tenanten bare er konfigurert i enkelte profiler og at
oppslaget derfor er lazy gjelder like mye her.

### Task #3: Utstederruting og testutsteder-gate ✅

Fullført 2026-09-22 — se [`task-3-completion.md`](task-3-completion.md).

**Priority**: High
**Size**: S
**Dependencies**: Task #2
**Addresses Requirements**: `TIL-PÅL-PÅL-003`, regler «ID-porten er en egen utsteder» og «ID-portens testmiljø kan brukes i utvikling og test»

**Acceptance Criteria**:

- [ ] `BearerTokenAuthenticator` ruter `iss == tilgangsstyring.issuer.idporten` til
      `IdportenAuthenticator`.
- [ ] `iss == tilgangsstyring.issuer.idporten-test` godtas kun når
      `SyntetiskeDatamiljoer.erSyntetisk(targetEnvironment)`; ellers
      `AuthenticationFailedResult` med miljønavnet i begrunnelsen.
- [ ] `idporten-test` er `Optional<String>` og er null i profiler uten test-utsteder — ingen
      oppstartsfeil.
- [ ] Ukjent utsteder gir fortsatt `AuthenticationFailedResult` (fail closed).
- [ ] Enhetstester for begge retninger av testutsteder-gaten.

**Implementation Notes**:
Kopier formen fra `maskinporten-test`-grenen (`BearerTokenAuthenticator:61-69`) inkludert
kommentaren om hvorfor gaten finnes. Ikke slå sammen de to test-utstederne til én sjekk — de
har ulike URL-er og ulike tenants.

### Task #4: Gate ID-porten til coprocessor-stien ✅

Fullført 2026-09-22 — se [`task-4-completion.md`](task-4-completion.md).

**Priority**: High
**Size**: S
**Dependencies**: Task #3
**Addresses Requirements**: Avgrensning av `TIL-PÅL-PÅL-003` (kravet gjelder coprocessoren); lukker funn 3 i analysen

**Acceptance Criteria**:

- [ ] `BearerTokenAuthenticator` eksponerer `authenticateForCoprocessor(...)` og
      `authenticateForSubgraf(...)` over en felles privat kjerne som tar settet av tillatte
      utstedere.
- [ ] `CoprocessorService` kaller coprocessor-varianten; `AuthorizationHeaderAuthenticator`
      kaller subgraf-varianten.
- [ ] Et ID-porten-token mot `/graphql/{env}` gir `AuthenticationFailedResult` → **401**, ikke
      500, og treffer aldri `SessionIdentity.mount`.
- [ ] Feide, Maskinporten og basic auth oppfører seg uendret på begge stier — dekket av
      eksisterende tester.
- [ ] Test som viser 401 fra subgraf-stien for et ellers gyldig ID-porten-token.

**Implementation Notes**:
Dette er den eneste endringen som rører subgraf-stien. `SessionIdentity.mount` har allerede en
`default -> throw` for ukjent utsteder på `ClientCredentialsResult`; `AuthorizationCodeResult`
har det ikke, og skal fortsatt ikke få det — gaten ligger foran, i authenticatoren.

### Task #5: Åpne roller for bruker uten tildelinger ✅

Fullført 2026-09-22 — se [`task-5-completion.md`](task-5-completion.md). Funksjonskroppen fikk
ett ledd mer enn planen skrev: `WHERE rollekode IN (SELECT rollekode FROM subgrafrolle)`.
Verifisert mot `0063-subgrafroller-i-claim.sql`, som legger samme filter på alle sju
eksisterende selektorer `${coprocessor_role}` har EXECUTE på — den nye er den åttende.

**Priority**: High
**Size**: M
**Dependencies**: Task #2
**Addresses Requirements**: `TIL-PÅL-PÅL-003`, regel «Tilgangssettet er tomt inntil ikke-Feide-brukere er innført»

**Acceptance Criteria**:

- [ ] Ny migrering `0072-apne-roller-uten-tildelinger.sql` med
      `tilgangsstyring.tilganger_for_apne_roller(p_env TEXT)`: `STABLE SECURITY DEFINER`,
      `SET search_path TO 'tilgangsstyring', 'pg_temp'`, kropp = `utvidede_apne_roller(p_env)`.
- [ ] `REVOKE ALL ... FROM PUBLIC` + `GRANT EXECUTE ... TO ${coprocessor_role}`, som
      `0061-grant-sudo-innganger`.
- [ ] `COMMENT ON FUNCTION` som navngir hva den gir: de åpne rollene i miljøet, ingen identitet,
      ingen tildelinger.
- [ ] Include lagt til i `db-changelog-root.xml` med en kommentar om rekkefølgekravet
      (etter `0061`, som eier `utvidede_apne_roller`).
- [ ] DB-test `src/test/sql/63_apne_roller_uten_tildelinger.sql`: funksjonen returnerer de åpne
      rollene for miljøet, og `coprocessor_role` er den eneste rollen med EXECUTE.
- [ ] `TilgangsstyringDataTilgangerService.tilgangerForApneRoller(String env)` med `@Retry`,
      samme form som de øvrige metodene.
- [ ] `hentActualOrgTilganger` kaller den **kun** når `issuer == "idporten"`; Feides
      `externalServiceId == null → EMPTY` er uendret.
- [ ] jOOQ regenerert (`mise run migrate` → `mise run jooq`).

**Implementation Notes**:
Rør ikke `kombiner_tildelinger` — det er ingen tak, ingen nekt og ingen bruker i denne flyten,
så en ren `SELECT` fra `utvidede_apne_roller` er hele kroppen. Merk at `utvidede_apne_roller`
er INVOKER; wrapperen er DEFINER fordi coprocessorrollen ikke har tabellrettigheter — samme
begrunnelse som står i `0061`.

### Task #6: Ende-til-ende coprocessortest for ID-porten ✅

Fullført 2026-09-22 — se [`task-6-completion.md`](task-6-completion.md). Scenariene som slår
fast identitet kjøres mot et ikke-syntetisk miljø: `baererIdentitet` stripper en ekte persons
identitet i syntetiske miljø, så `sub` og `nin` er ikke observerbare der.

**Priority**: High
**Size**: M
**Dependencies**: Task #3, Task #4, Task #5
**Addresses Requirements**: `TIL-PÅL-PÅL-003`, alle fire regler

**Acceptance Criteria**:

- [ ] Ny `IdportenCoprocessorTest` etter mønster av `MaskinportenTestIssuerCoprocessorTest`:
      egen `QuarkusTestProfile` med idporten- og idporten-test-tenants mot lokal JWKS-stubb,
      tokens signert med `SigningKeyConfig`.
- [ ] Scenario «Gyldig ID-porten-token godtas»: 200 `continue`, utstedt JWT har
      `amr == ["idporten"]`, `sub` = tokenets `sub`, `nin` = `pid`.
- [ ] Scenario «Token med ugyldig signatur eller utløpt gyldighet avvises»: `control.break == 401`,
      ingen `supergraph-authorization`-header, ingen databaseoppslag (`verify(..., never())`).
- [ ] Scenariomal «Autentiseringsnivå bæres»: `idporten-loa-substantial`, `idporten-loa-high`
      og `selfregistered-email` havner uendret i `acr`.
- [ ] Scenario «Innlogget uten tildelte roller»: `orgtilganger` inneholder de åpne rollene for
      miljøet og ingenting annet.
- [ ] Scenario «Token fra ID-portens testmiljø»: godtas mot syntetisk miljø, avvises med 401 mot
      `production`.

**Implementation Notes**:
Kravets fire regler oversettes én-til-én til testmetoder, så `bat-verify` kan matche dem mot
`.feature`-fila. `@integration`-kravet har ingen brukerflate, så disse testene *er* beviset.

### Task #7: Dokumentasjon og metrikk-kommentar ✅

Fullført 2026-09-22 — se [`task-7-completion.md`](task-7-completion.md). Fikk to ekstra
dokumentasjonsrettelser: antallet `tilganger_for_*`-selektorer i `navnerom-for-roller.md`, og
påstanden i `tilgangsmodell.md` om at sudo-inngangene var de eneste funksjonene `GRANT`-et til
`${coprocessor_role}` alene. Begge ble usanne av Task #5.

**Priority**: Medium
**Size**: S
**Dependencies**: Task #4, Task #5
**Addresses Requirements**: —

**Acceptance Criteria**:

- [ ] `CoprocessorMetrikker`-javadoc: `sti`-verdimengden utvides med `idporten`.
- [ ] `docs/tilgangsmodell.md`: `tilganger_for_apne_roller` inn i tabellen over
      tilgangsfunksjoner, med flyt og innhold.
- [ ] `docs/en-instans-for-alle-miljo.md`: at utstedertilliten nå er sti-avhengig, og hvorfor.
- [ ] Ingen migreringsnumre eller issue-referanser i koden — de hører hjemme i commit og MR
      (`RETNINGSLINJER.md`).

**Implementation Notes**:
Kommenter bare det som er overraskende. At ID-porten er en utsteder er åpenbart fra koden;
at subgraf-stien avviser den, er det ikke.

## Risk Assessment

### Technical Risks

- **Risk**: Vi kjenner ikke formen på et ekte ID-porten-token. `pid`, `acr`-verdiene og `aud`
  er antakelser til klientregistreringen hos Digdir (fase 0) er på plass.
  - **Mitigation**: All logikk testes mot selvsignerte tokens nå. Claims-uttrekket isoleres i
    `IdportenAuthenticator` slik at en korreksjon treffer én metode. Ende-til-ende mot
    ID-portens testmiljø settes opp som eksplisitt oppfølging.

- **Risk**: Audiensen er ikke avklart. Uten `token.audience` kan et ID-porten-token utstedt til
  en annen Sikt-tjeneste brukes mot FS GraphQL.
  - **Mitigation**: Behandles som en åpen avhengighet mot fs-admin (fase 1b), ikke som en
    forglemmelse. Skal settes før produksjonssetting, og er én linje per profil.
    **Må bekreftes:** at ID-porten støtter `resource`-parameteren for å sette `aud` mot
    FS GraphQL — sjekk Digdirs dokumentasjon før verdien festes.

- **Risk**: `SyntetiskPerson.erSyntetisk` er Feide-formet (`schacHomeOrganization`, eppn-realm,
  Tenor-serien). En ID-porten-bruker i et syntetisk miljø får identiteten strippet med mindre
  fødselsnummeret ligger i Tenor-serien.
  - **Mitigation**: Kravet krever bare at forespørselen *autentiseres* i syntetiske miljø, ikke
    at identiteten videresendes — så dagens oppførsel er innenfor. Verifiser antakelsen om at
    ID-portens testbrukere ligger i Tenor-serien; hvis ikke, er en ID-porten-gren i
    `SyntetiskPerson` en egen, liten oppfølging.

- **Risk**: Tilgangsoppslaget for åpne roller legger til et databasekall på en sti som i dag
  ikke har noe. Tidsbudsjettet er 900 ms totalt, hvorav inntil 500 ms database.
  - **Mitigation**: Oppslaget er én funksjon uten join mot bruker eller applikasjon og er
    billigere enn de eksisterende. `@Retry(maxRetries = 1, delay = 100)` som de andre. Mål
    før produksjonssetting hvis `docs/tidsbudsjett.md` skal oppdateres.

- **Risk**: Endringen i `hentActualOrgTilganger` kan ved et uhell gjøres generell og dermed
  endre Feides fail-closed-oppførsel for tokens uten `act`-claim.
  - **Mitigation**: Eksplisitt akseptansekriterium i Task #5, og en test som viser at en
    Feide-bruker uten `externalServiceId` fortsatt får tomt sett.

### Testing Requirements

- Enhetstester for `acr`-gjennomføring (Task #1) og testutsteder-gaten (Task #3).
- Ende-til-ende coprocessortester som speiler kravets fire regler (Task #6).
- 401-test for subgraf-stien (Task #4).
- DB-test for den nye funksjonen og dens grant (Task #5).
- Eksisterende `CoprocessorResourceTest` og `MaskinportenTestIssuerCoprocessorTest` skal være
  grønne uendret — de er regresjonsvernet for at Feide og Maskinporten ikke rører seg.

## Success Criteria

- [ ] Alle akseptansekriterier møtt.
- [ ] `mvn clean install` grønn i `tilgangsstyring`-reaktoren, inkludert DB-testene.
- [ ] Kravets fire regler har hver sin test som kan pekes på i `bat-verify`.
- [ ] Ingen endring i oppførsel for Feide, Maskinporten eller basic auth.
- [ ] Koden følger konvensjonene i `RETNINGSLINJER.md` — kommentarer kun der noe overrasker,
      ingen migreringsnumre eller issue-referanser i koden.

## Requirements Traceability

| Krav-ID | Regel | Dekkes av | Status |
| --- | --- | --- | --- |
| `TIL-PÅL-PÅL-003` | ID-porten er en egen utsteder i coprocessoren | Task #2, Task #3, Task #6 | Planned |
| `TIL-PÅL-PÅL-003` | Autentiseringsnivået (`acr`) bæres videre, håndheves ikke | Task #1, Task #6 | Planned |
| `TIL-PÅL-PÅL-003` | Tilgangssettet er tomt inntil ikke-Feide-brukere er innført | Task #5, Task #6 | Planned |
| `TIL-PÅL-PÅL-003` | ID-portens testmiljø kan brukes i utvikling og test | Task #3, Task #6 | Planned |
| — (avgrensning) | Subgraf-stien skal ikke godta ID-porten i fase 1 | Task #4 | Planned |
