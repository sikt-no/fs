# Analysis: ID-porten som utsteder i coprocessoren (fase 1)

## Problem Statement

Coprocessoren i `tilgangsstyring-app` kjenner i dag tre utstedere: Feide, Maskinporten og
test-Maskinporten. Kravet `TIL-PÅL-PÅL-003` legger til ID-porten som en fjerde, slik at FS Admin
kan sende forespørsler på vegne av en fagskoleansatt uten Feide-identitet. Tokenet coprocessoren
utsteder skal bære identitet, autentiseringsmetode (`amr`) og autentiseringsnivå (`acr`), med
tomt tilgangssett inntil fase 2a.

Sett fra koden er dette tre uavhengige endringer med svært ulik størrelse: utstederrutingen er
en ny gren i én `if`-kjede, `acr` finnes ikke noe sted i plattformen i dag, og «tomt tilgangssett»
er allerede default-oppførselen — men ikke helt slik kravet formulerer den.

## Current State

### Autentiseringskjeden

```
CoprocessorResource  →  CoprocessorService.handle
                          ├─ authenticate(header, env)  →  BearerTokenAuthenticator  →  {Feide,Maskinporten}Authenticator
                          ├─ hentOrgTilganger(...)      →  TilgangsstyringDataTilgangerService  →  auth.tilganger_for_*
                          └─ buildSignedJwt(...)        →  supergraph-authorization-header
```

- **Utstederruting:** `BearerTokenAuthenticator.authenticate`
  (`fs-plattform/tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/coprocessor/BearerTokenAuthenticator.java:40-75`)
  dekoder JWT-en usignert bare for å lese `iss`, og ruter til riktig authenticator i en
  `if/else`-kjede. Utstedernavnene kommer fra `tilgangsstyring.issuer.{feide,maskinporten,
  maskinporten-test}`; selve verifiseringen gjøres av en navngitt Quarkus OIDC-tenant
  (`@Tenant("feide")` / `@Tenant("maskinporten")`) med 250 ms timeout.
- **Test-utsteder-mønsteret finnes ferdig.** `maskinporten-test` er `Optional<String>` (null i alle
  profiler unntatt `platon-production`), og tokens derfra avvises mot ikke-syntetiske miljø
  (`BearerTokenAuthenticator.java:61-69`) via `SyntetiskeDatamiljoer`.
- **Resultatmodellen:** `AuthenticationResult`
  (`fs-plattform/tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/coprocessor/model/AuthenticationResult.java`)
  er en sealed interface. En innlogget person er `AuthorizationCodeResult(issuer, clientId,
  subject, name, email, nin, schacHomeOrganization, externalServiceId)` — **ingen `acr`**.
- **Tokenutstedelse:** `CoprocessorService.buildSignedJwt`
  (`fs-plattform/tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/coprocessor/CoprocessorService.java:532-584`)
  setter `iss`, `aud` (miljø + tillitsdomene), `sub`, `client_id`, `amr`, `orgtilganger`, og for
  personflyten `name`/`email`/`nin`/`hjemmeorganisasjonskodeMidlertidigClaim`.
- **`amr` er allerede utstedernavnet:** `getAmr` returnerer `List.of(issuer)` for både
  `AuthorizationCodeResult` og `ClientCredentialsResult` (`CoprocessorService.java:632-644`).

### Tilgangsoppslaget

`hentActualOrgTilganger` (`CoprocessorService.java:510-530`) velger databasefunksjon per flyt.
For personflyten kreves `externalServiceId` (Feides service-id, lest fra `act`-claimet); er den
`null`, returneres `Orgtilganger.EMPTY` **uten databasetreff** — en bevisst fail-closed, fordi
tomt delegeringstak ellers kunne leses som ubegrenset.

### Miljø og profiler

Én deployment betjener alle miljø (`fs-plattform/tilgangsstyring/docs/en-instans-for-alle-miljo.md`).
Utstedertilliten er derfor miljøbetinget, ikke deployment-betinget. Lokalt kjører
`dev`-profilen på port 8081 (`application-dev.properties:2`) — samme endepunkt som er i bruk i
den lokale supergrafen i denne økten — med `application.environment.synthetic=true` og
dev-innlogging uten credentials.

## Key Findings

1. **Utstederrutingen er billig; `acr` er ikke.** Å legge ID-porten inn i
   `BearerTokenAuthenticator` er én gren pluss én OIDC-tenant per profil. `acr` derimot finnes
   **ingen steder** i `fs-plattform` i dag (søk på `acr` i Java/properties/SQL: null treff), og
   kravet — bekreftet av spec-en: «`acr` bæres alltid for alle utstedere» — tvinger et nytt felt
   på `AuthenticationResult`-variantene og dermed endring i alle konstruksjonspunktene:
   `FeideAuthenticator.java:72,76`, `MaskinportenAuthenticator.java:45`,
   `AuthorizationHeaderAuthenticator.java:86-88` og den sudo-fakede kopien i
   `CoprocessorService.java:442-443`.

2. **Tomt tilgangssett kommer gratis — men *åpne roller* uteblir.** En ID-porten-bruker har ingen
   Feide service-id, så `hentActualOrgTilganger` treffer `externalServiceId != null ? … :
   Orgtilganger.EMPTY` og gir tomt sett uten å spørre basen. Kravet sier derimot at brukeren skal ha
   «kun tilgang til det som er åpent for alle innloggede brukere». Alle tilgangsfunksjonene i basen
   har `∪ åpne` innebygd (`fs-plattform/tilgangsstyring/docs/tilgangsmodell.md:346-352`),
   men **ingen** av dem tar en bruker uten `service_id`/`subjekt_id`. Skal åpne roller med, trengs
   en ny funksjon i basen (`tilganger_for_apne_roller(env)` e.l.); godtas bokstavelig tomt sett,
   er kodeendringen null. Dette er et reelt valg, ikke en detalj.

3. **Å slippe ID-porten inn i `BearerTokenAuthenticator` åpner to stier samtidig.**
   `AuthorizationHeaderAuthenticator` (subgraf-stien, `/graphql/{env}`) gjenbruker samme
   authenticator (`AuthorizationHeaderAuthenticator.java:64`). Et ID-porten-token vil dermed også
   nå `SessionIdentity.mount`, der `AuthorizationCodeResult` uansett utsteder havner i
   `Routines.loginFeideBruker(externalServiceId, email, nin)`
   (`fs-plattform/tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/auth/SessionIdentity.java:39-42`)
   — med `externalServiceId = null` og `email = null`. Kravet omtaler bare coprocessoren, så
   subgraf-stien må enten gates eller håndteres eksplisitt. Uten et valg her får vi en
   udokumentert sti inn i `feide_bruker`-flyten.

4. **`SyntetiskPerson` er Feide-formet, og treffer testmiljø-scenarioet.**
   `erSyntetisk` (`fs-plattform/tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/coprocessor/SyntetiskPerson.java:37-41`)
   leser `schacHomeOrganization`, realm fra eppn, og Tenor-nummerserien. En ID-porten-bruker har
   ingen av de to første. I et syntetisk miljø blir identiteten derfor strippet (`sub = "sudo"`,
   ingen `name`/`email`/`nin`) med mindre fødselsnummeret ligger i Tenor-serien — hvilket det gjør
   for ID-portens testbrukere, men det er en antakelse som må verifiseres, ikke forutsettes.

5. **Audiens er tenant-konfigurasjon, ikke kode, og ingen token-veksling trengs.** Feide-tenanten
   pinner `quarkus.oidc.feide.token.audience=https://n.feide.no/datasources/<clientId>`
   (`application.properties:208`); Maskinporten-tenantene setter ingen audiens.
   `FeideClient.exchangeToken` er en veksling for å nå Feides *userinfo*, ikke for å sette audiens
   mot FS GraphQL — den har ingen parallell i ID-porten-flyten. Det åpne audiens-spørsmålet koker
   dermed ned til én linje: skal `quarkus.oidc.idporten.token.audience` settes, og til hva.

6. **Ingen nedstrøms konsument leser `amr`.** Søk i `sis`, `opptak`, `utdanningsregisteret`,
   `kompetanse`, `fskode` og `node-subgraph`: null treff. `amr = ["idporten"]` er dermed trygt,
   men heller ikke lastbærende ennå — den er sporing, ikke en beslutningsnøkkel.

7. **`nin` er lastbærende nedstrøms — subjekt-valget er det ikke.** `opptak` provisjonerer
   bruker og søker på `nin` (`AuthenticatedContextProvider.java:178,228,306`), og `sis` leser
   `nin` (`TilgangsstyringUserInfoProvider.java:72`). Begge provisjoneringene er gated på
   ikke-tomme orgtilganger / søkerhandling, så et ID-porten-token med tomt tilgangssett utløser
   **ingen** utilsiktet provisjonering. Det gjør `pid`-vs-`sub`-valget til et rent
   identitetsspørsmål i fase 1 — men det låser hva fase 2a kan koble tilganger mot.

8. **Metrikkstien følger utstederen av seg selv.** `sti()` (`CoprocessorService.java:170-182`)
   bruker issuer-strengen som tagg, så `idporten` dukker opp uten kodeendring. Javadoc-en i
   `CoprocessorMetrikker` lister verdimengden eksplisitt og går ut av takt hvis den ikke
   oppdateres.

## Technical Constraints

- **Tidsbudsjett.** `CoprocessorService.handle` har `@Timeout(900 ms)` med `@Fallback` som stopper
  forespørselen med 503; Apollo Router blokkerer etter 1 s. Budsjettet er 250 ms
  tokenverifisering + inntil 500 ms databaseoppslag. ID-porten-verifiseringen må holde samme
  250 ms-grense som de øvrige tenantene, og **må ikke** legge til et userinfo-kall à la Feide —
  det kallet er allerede dokumentert som noe som ikke får plass
  (`fs-plattform/tilgangsstyring/docs/tidsbudsjett.md`, `CoprocessorService.java:66-74`).
- **Fail closed.** Ukjent utsteder → `AuthenticationFailedResult` → 401. Ny gren må ikke gjøre
  «ukjent» til «slipp gjennom uten tilganger».
- **Headerstørrelse.** `supergraph-authorization` er allerede nær taket
  (`fs-plattform/tilgangsstyring/docs/headerstorrelse.md`);
  `acr` er én kort streng og er uproblematisk, men claim-settet er ikke gratis.
- **Loggdisiplin.** Angriperstyrte verdier logges på `debug`, avkortet, aldri med stacktrace
  (`CoprocessorService.java:152-159`) — log-flooding er en eksplisitt trusselmodell her.
- **Fødselsnummer sladdes i logg** (`Fodselsnummer.sladd`). Gjelder også `pid` fra ID-porten.
- **Profilstruktur.** Nye tenants må settes i `application.properties` (default),
  `application-platon-production.properties` (prod) og `application-test.properties` (lokal
  JWKS-stubb mot `JwksResource`) — tre steder, ikke ett.
- **Klientregistrering hos Digdir (fase 0) er ikke bestilt.** Ende-til-ende-test mot ID-portens
  testmiljø er blokkert til den er på plass; `MaskinportenTestIssuerCoprocessorTest` viser
  imidlertid at hele flyten kan dekkes med selvsignerte tokens mot en lokal JWKS-stubb.

## Dependencies

- **Internt:**
  - `BearerTokenAuthenticator`, `AuthenticationResult`, `CoprocessorService` — kjernen i endringen.
  - `AuthorizationHeaderAuthenticator` + `SessionIdentity` — treffes som bieffekt (funn 3).
  - `SyntetiskPerson` / `SyntetiskeDatamiljoer` — avgjør identitetsvidereføring og testutsteder-gate.
  - `tilgangsstyring-new-db` — kun hvis åpne roller skal med (funn 2).
- **Eksternt:**
  - ID-porten (Digdir): JWKS-endepunkt, utsteder-URL, klientregistrering (fase 0, ikke bestilt).
  - Quarkus OIDC `TenantIdentityProvider` — samme mekanikk som Feide/Maskinporten.
- **Cross-contributor:**
  - **fs-admin (frontend):** innloggingsflyten mot ID-porten (NextAuth) er fase 1b og er en egen
    task. Den avgjør i praksis audiens-spørsmålet, siden det er fs-admin som starter
    autorisasjonsflyten og dermed bestemmer om `resource`/audiens kan settes mot FS GraphQL.
    Coprocessor-siden kan ikke ferdigstilles som ende-til-ende-verifisert uten den.
  - **Digdir/Sikt-forvaltning:** klientregistrering (fase 0). Blokkerer verifikasjon, ikke
    implementasjon.

## Requirements Impact

Kravgrunnlaget er `TIL-PÅL-PÅL-003` (`@must @integration @planned`), fire regler:

| Regel | Status i koden i dag | Vurdering |
|---|---|---|
| ID-porten som egen utsteder (gyldig godtas / ugyldig avvises) | Ikke dekket | Rett frem: ny gren + tenant. Avvisningsstien finnes allerede og er fail-closed. |
| `acr` bæres videre, håndheves ikke | Ikke dekket, ikke engang for Feide/Maskinporten | Største enkeltbit. Treffer modellen og alle utstedere, ikke bare ID-porten. |
| Tomt tilgangssett → kun åpen funksjonalitet | Delvis dekket | Tomt sett er default. «Åpent for alle innloggede» er **ikke** dekket — se funn 2. |
| ID-portens testmiljø i utvikling og test | Ikke dekket | Mønsteret finnes ferdig (`maskinporten-test`); avhenger av åpent spørsmål om testutsteder-gate. |

- **Krav adressert av eksisterende kode:** ingen — utstederen finnes ikke.
- **Krav med risiko:** regelen om tomt tilgangssett, fordi ordlyden «kun tilgang til det som er
  åpent for alle innloggede brukere» og kodens `Orgtilganger.EMPTY` ikke er samme ting.
- **Manglende krav oppdaget:** subgraf-stien (`/graphql/{env}`) er ikke omtalt i kravet, men åpnes
  som bieffekt av implementasjonen (funn 3). Bør enten dekkes av et krav eller eksplisitt lukkes.

## Krav-input referanse

- **Spec-dokument:** [`spec-idporten-fs-admin-fase1.md`](../spec/spec-idporten-fs-admin-fase1.md)
- **Krav-input-manifest:** [`krav-input/manifest.md`](../spec/krav-input/manifest.md)

## Open Questions

Fra spec-en (uavklarte):

- [x] **Audiens.** Hvilken audiens skal coprocessoren kreve på ID-porten-tokenet — settes
      `quarkus.oidc.idporten.token.audience`, og til hva? Analysen viser at spørsmålet er
      ren tenant-konfigurasjon, men svaret eies av fs-admins autorisasjonsflyt (fase 1b).
      Alternativer: (a) sikt mot FS GraphQL uten å pinne ennå, (b) pinn til klient-id,
      (c) ingen audienssjekk, (d) avklar med fs-admin først.
      **Besluttet (a):** design for audiens satt fra fs-admins autorisasjonsflyt, men la
      `quarkus.oidc.idporten.token.audience` stå usatt i dev/test til klientregistreringen hos
      Digdir finnes. Begrunnelse: fase 1 blokkeres ikke av fase 0, og endringen er én linje per
      profil når verdien er avklart. **Må bekreftes:** at ID-porten støtter `resource`-parameteren
      for å sette `aud` mot FS GraphQL — sjekk Digdirs dokumentasjon før planen fester dette.
- [x] **Subjekt.** `pid` (fødselsnummer) eller ID-portens `sub` som `sub` i det interne tokenet?
      Merk at `nin`-claimet er et separat valg fra `sub`, og at `nin` er det nedstrøms faktisk
      leser.
      Alternativer: (a) ID-portens `sub` med `pid` → `nin`, (b) `pid` som `sub`, (c) utsett til fase 2a.
      **Besluttet (a):** `sub` = ID-portens `sub`, `pid` legges i `nin`-claimet slik Feide-flyten
      gjør med `norEduPersonNIN`. Begrunnelse: `sub` leses opakt nedstrøms (`UserInfoFactory.java:162`,
      `FeideJwt.java:42`) og logges usladdet i coprocessoren, mens fødselsnummer alltid går gjennom
      `Fodselsnummer.sladd` og allerede har `nin` som sitt ene sted.
- [x] **Testutsteder.** Skal ID-portens testmiljø gates til syntetiske datamiljø slik
      test-Maskinporten er? Mønsteret er ferdig implementert og koster lite å gjenbruke.
      Alternativer: (a) ja, som test-Maskinporten, (b) ingen egen testutsteder.
      **Besluttet (a):** egen `tilgangsstyring.issuer.idporten-test` (`Optional<String>`), godtas
      kun når `SyntetiskeDatamiljoer.erSyntetisk(targetEnvironment)`. Begrunnelse: kravets
      `@openquestion`-scenario er formulert som «godtas i syntetiske datamiljøer», og mønsteret
      med tilhørende test (`MaskinportenTestIssuerCoprocessorTest`) finnes ferdig.
- [x] **Fase 0 (utenfor kravet).** Klientregistrering hos Digdir er ikke bestilt. Skal fase 1
      bygges og enhetstestes mot selvsignerte tokens i mellomtiden?
      Alternativer: (a) bygg mot selvsignerte tokens, (b) vent på klientregistrering,
      (c) bygg nå, men bestill fase 0 først.
      **Besluttet (a):** full implementasjon og testdekning nå, med selvsignerte tokens mot
      `JwksResource` som lokal JWKS-stubb — samme oppsett som `MaskinportenTestIssuerCoprocessorTest`.
      Ende-til-ende mot ID-portens testmiljø er en egen oppfølging når klienten finnes.
      Begrunnelse: utstederruting, avvisning, claims og miljø-gaten kan verifiseres uten Digdir;
      det eneste som gjenstår er å bekrefte at et ekte token har den formen vi antar
      (`pid`, `acr`-verdier, `aud`).

Nye, fra denne analysen:

- [x] **Åpne roller ved tomt tilgangssett.** Skal en ID-porten-bruker få `utvidede_apne_roller(env)`
      (krever ny databasefunksjon), eller er bokstavelig tomt sett godt nok i fase 1?
      Alternativer: (a) åpne roller med, (b) bokstavelig tomt sett, (c) utsett til fase 2a.
      **Besluttet (a):** åpne roller skal med, via en tynn `SECURITY DEFINER`-wrapper
      (`tilganger_for_apne_roller(env)`) granted til `coprocessor_role`, etter mønsteret fra
      `tilganger_for_sudo` i `0061-sudo-orgtilganger.sql`. Begrunnelse: kravets ordlyd er «kun
      tilgang til det som er åpent for alle innloggede brukere», og alle øvrige tilgangsfunksjoner
      har `∪ åpne` innebygd. Uten dette blir ID-porten den eneste utstederen der en autentisert
      bruker havner under modellens gulv — et avvik som ville dukket opp igjen i fase 2a.
- [x] **Subgraf-stien.** Skal `/graphql/{env}` også godta ID-porten-tokens, eller skal utstederen
      gates til coprocessor-stien i fase 1? Uten et valg havner ID-porten-brukere i
      `loginFeideBruker` med tomme argumenter.
      Alternativer: (a) gate til coprocessoren, (b) egen `auth.login_idporten_bruker`-flyt,
      (c) eksplisitt 401 i `SessionIdentity` med delt utstedertillit.
      **Besluttet (a):** utstedertilliten gjøres sti-avhengig — ID-porten godtas kun av
      coprocessoren, subgraf-stien avviser med 401. Begrunnelse: kravet omtaler bare
      coprocessoren, en egen login-flyt i basen hører hjemme i fase 2a sammen med ikke-Feide-
      brukere, og et ID-porten-token er ikke «avvist» i dag — det slipper forbi 401-gaten i
      `AuthenticatedSession.login` og monterer en identitet uten subjekt.

      *Korrigert 2026-09-22 under implementasjonen (Task #4):* utfallet er ikke 500, slik denne
      analysen først anslo. `auth.login_feide_bruker` provisjonerer bare når `p_feide_id IS NOT
      NULL`, så sesjonen monteres uten subjekt og RLS gir ingenting — kalleren får **200 med tom
      respons**. Mildere enn antatt, men mer stillegående: en autentisert sesjon uten identitet
      ser ut som at det ikke finnes data. Beslutningen står uendret.
- [x] **`acr` for Feide og Maskinporten.** Kravet sier «alltid, for alle utstedere». Skal `acr`
      fylles for Feide og Maskinporten i samme endring, eller bare bæres der utstederen leverer den?
      Alternativer: (a) felles mekanisme, verdi når den finnes, (b) bare ID-porten i fase 1,
      (c) fyll aktivt for alle.
      **Besluttet (a):** nullbart `acr`-felt på `AuthenticationResult`-variantene og
      `addClaimIfPresent(jwtBuilder, "acr", …)` i `buildSignedJwt` — samme mønster som
      `name`/`email`/`nin`. Feide får sin `acr` når tokenet bærer en; Maskinporten er client
      credentials uten brukerautentisering og får ingen. Begrunnelse: mekanismen blir uniform
      slik kravet krever, uten å dikte opp et autentiseringsnivå der ingen person er autentisert.
