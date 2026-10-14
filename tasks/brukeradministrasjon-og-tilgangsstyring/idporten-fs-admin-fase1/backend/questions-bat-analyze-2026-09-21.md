# Spørsmål og svar — `bat-analyze` (2026-09-21)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Gjennomgang av åpne spørsmål

**Spørsmål:** Analysen har 7 åpne spørsmål — 4 fra spec-en (audiens, subjekt, testutsteder, fase 0) og 3 nye (åpne roller ved tomt tilgangssett, subgraf-stien, `acr` for Feide/Maskinporten). Vil du gå gjennom dem nå?

**Alternativer:**
- Gå gjennom dem nå — Ett spørsmål om gangen; jeg undersøker alternativene i koden og gir en anbefaling før du bestemmer. Beslutningene skrives inn i analysedokumentet.
- Stopp her — Analysen står som den er med spørsmålene åpne; du tar dem senere eller lar `bat-plan` møte dem.

**Svar:** Gå gjennom dem nå

---

## 2. Åpne roller ved tomt tilgangssett

**Spørsmål:** Skal en ID-porten-bruker uten tildelinger få de åpne rollene (`utvidede_apne_roller`), eller bokstavelig tomt tilgangssett?

**Alternativer:**
- Åpne roller med (Anbefalt) — Ny tynn SECURITY DEFINER-funksjon `tilganger_for_apne_roller(env)` etter mønsteret fra 0061, granted til coprocessor_role. Tro mot kravets ordlyd og mot resten av tilgangsmodellen.
- Bokstavelig tomt sett — Ingen databaseendring; `Orgtilganger.EMPTY` som i dag. Minimal fase 1, men ID-porten-brukeren får mindre enn alle andre autentiserte flyter.
- Utsett til fase 2a — Tomt sett nå, med en eksplisitt notis i analysen om at åpne roller først innføres når ikke-Feide-brukere støttes i tilgangsstyring.

**Svar:** Åpne roller med (Anbefalt)

---

## 3. Subgraf-stien

**Spørsmål:** Hva skal skje når et ID-porten-token treffer subgraf-stien `/graphql/{env}` i tilgangsstyring?

**Alternativer:**
- Gate til coprocessoren (Anbefalt) — Utstedertilliten gjøres sti-avhengig: ID-porten godtas kun av coprocessoren, subgraf-stien avviser med 401. Holder fase 1 innenfor kravet.
- Egen login-flyt i basen — Ny `auth.login_idporten_bruker` + ny `app.flyt`-verdi, slik at begge stier støttes. Større endring; overlapper med fase 2a.
- Eksplisitt 401 i SessionIdentity — Behold delt authenticator, men la subgraf-stien avvise ukjent utsteder som en autentiseringsfeil (401, ikke 500). Minst kode, men utstedertilliten blir fortsatt delt.

**Svar:** Gate til coprocessoren (Anbefalt)

---

## 4. `acr` for de andre utstederne

**Spørsmål:** Hvordan skal `acr` håndteres for Feide og Maskinporten når mekanismen uansett innføres?

**Alternativer:**
- Felles mekanisme, verdi når den finnes (Anbefalt) — Nullbart `acr`-felt på alle varianter; claimet settes med addClaimIfPresent. Feide får sin `acr` hvis tokenet bærer en, Maskinporten får ingen.
- Bare ID-porten i fase 1 — `acr` leses og bæres kun på ID-porten-stien; de andre utstederne røres ikke. Minst diff, men bryter med ordlyden «for alle utstedere».
- Fyll aktivt for alle — Feide og Maskinporten får også en `acr`-verdi, om nødvendig en konstruert en. Uniform claim-form, men verdien blir delvis oppdiktet.

**Svar:** Felles mekanisme, verdi når den finnes (Anbefalt)

---

## 5. Subjektet i det interne tokenet

**Spørsmål:** Hva skal bli `sub` i det interne tokenet for en ID-porten-bruker?

**Alternativer:**
- ID-portens `sub`, `pid` → `nin` (Anbefalt) — Opak identifikator i `sub`, fødselsnummer i `nin` som i Feide-flyten. Holder fnr ute av felter som logges usladdet.
- `pid` som `sub` — Fødselsnummeret blir subjektet. Én identifikator å forholde seg til, men fnr havner i et felt som logges i klartekst og leses opakt nedstrøms.
- Utsett — avklar med fase 2a — Lar spørsmålet stå åpent til tilgangskoblingen for ikke-Feide-brukere er designet, siden det er den som egentlig nøkler på subjektet.

**Svar:** ID-portens `sub`, `pid` → `nin` (Anbefalt)

---

## 6. Audiens

**Spørsmål:** Hvilken audiens skal coprocessoren kreve på ID-porten-tokenet i fase 1?

**Alternativer:**
- Sikt mot FS GraphQL, ikke pinn ennå (Anbefalt) — Design for audiens satt fra fs-admins flyt, men la `token.audience` stå usatt i dev/test til klientregistreringen finnes. Blokkerer ikke på fase 0.
- Pinn til klient-id — Krev `aud` = Sikts ID-porten-klient-id (ID-portens default når ingen resource oppgis). Konkret og verifiserbart, men binder oss til én klient per konsument.
- Ingen audienssjekk i fase 1 — Som Maskinporten-tenantene i dag: ingen `token.audience`. Enklest, men tokenet kan gjenbrukes mot andre Sikt-tjenester som stoler på ID-porten.
- Avklar med fs-admin først — La spørsmålet stå åpent i analysen og ta det som en eksplisitt avhengighet mot fase 1b før planen skrives.

**Svar:** Sikt mot FS GraphQL, ikke pinn ennå (Anbefalt)

---

## 7. ID-portens testmiljø

**Spørsmål:** Skal ID-portens testmiljø gates til syntetiske datamiljøer slik test-Maskinporten er?

**Alternativer:**
- Ja, som test-Maskinporten (Anbefalt) — Egen `tilgangsstyring.issuer.idporten-test` (Optional), godtas kun når `SyntetiskeDatamiljøer.erSyntetisk`. Gjenbruker eksisterende mønster og test.
- Ingen egen testutsteder — Bare én ID-porten-utsteder per profil, satt til test-URL i ikke-prod-profilene. Enklere config, men prod-deploymenten kan ikke betjene syntetiske miljøer med testtokens.

**Svar:** Ja, som test-Maskinporten (Anbefalt)

---

## 8. Fase 0 — klientregistrering hos Digdir

**Spørsmål:** Hvordan skal fase 1 forholde seg til at klientregistreringen hos Digdir (fase 0) ikke er bestilt?

**Alternativer:**
- Bygg mot selvsignerte tokens (Anbefalt) — Full implementasjon og testdekning med lokal JWKS-stubb nå; ende-til-ende mot ID-portens testmiljø som egen oppfølging når klienten finnes.
- Vent på klientregistrering — Utsett implementasjonen til fase 0 er levert, slik at alt kan verifiseres mot ekte tokens i én omgang.
- Bygg nå, men bestill fase 0 først — Samme som anbefalingen, men planen starter med å få bestillingen til Digdir på plass som første oppgave.

**Svar:** Bygg mot selvsignerte tokens (Anbefalt)
