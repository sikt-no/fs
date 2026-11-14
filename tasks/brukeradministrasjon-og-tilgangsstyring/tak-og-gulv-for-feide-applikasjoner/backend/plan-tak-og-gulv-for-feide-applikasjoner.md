
# Plan: Tak og gulv for Feide-applikasjoner

- **Krav:** `@BRU-APP-API-018` (taket), `@BRU-APP-API-019` (gulvet). Jira: [BAT-411](https://sikt.atlassian.net/browse/BAT-411). Spec: `tasks/brukeradministrasjon-og-tilgangsstyring/tak-og-gulv-for-feide-applikasjoner/spec/spec-tak-og-gulv-for-feide-applikasjoner.md` (sikt-no/fs#914).
- **Repo og rolle:** fs-plattform (tilgangsstyring), `backend`. Bare fs-plattform. fs-admin er neste ledd (se «Kontrakt for fs-admin»).
- **Kodegrunnlag:** fs-plattform `origin/main` `b0c555e201` (2026-11-04). Analysen: `backend/analysis-tak-og-gulv-for-feide-applikasjoner.md`.
- **Beslutninger som ligger til grunn** (Kjetil, 04.11.2026):
  - Bare forretningsroller filtreres i valglisten i FS Admin. Serveren avgrenser ikke, og eksisterende rader røres ikke.
  - Samlingstak vises der en direkte takrad ville vært synlig (0104/0107).
  - Valglistene for organisasjon og miljø utledes i klienten fra `mineTilganger`.
  - `local`/`test`: varselet i docs holder.
  - I2 for taket er med.
  - Direkte tildeling når rollen alt er i taket via samling: klienten hindrer det, serveren avviser ikke.
  - Gulvet forvaltes etter `kan_forvalte_delegering` (ikke eget privilegium).
  - Bare det som gjelder nå vises, med filter i spørringen.
  - Gyldighetsperioden vises, men settes ikke.
  - Delvis suksess kommer fra alias-batch i klienten.
  - Ingen endringslogg, ingen nekt.

## Proposed Solution

### Architecture Approach

RLS er porten, som for taket i dag. Arbeidet har tre spor, og alle bygger på mekanismer som finnes:

1. **Gulvet blir skrivbart** (`applikasjon_brukergrunntilgang`, 0099):
   - Tabellrettighetene gis tilbake til app-rollen.
   - Tre policyer (`_opprett/_endre/_slett`) som alle kaller `kan_forvalte_delegering(subjekt_id, organisasjonskode, miljokode)`. Gulvradene har samme signatur som takradene, så regelen står fortsatt ett sted.
   - I grafen kommer en ny søsterfil `schema_gulv.graphqls` i experimental, som speiler `schema_delegeringstak.graphqls`:
     - typen `Brukergrunntilgang`
     - feltet `FeideApplikasjon.brukergrunntilganger(filter)`
     - mutasjonene `leggTilBrukergrunntilganger` / `fjernBrukergrunntilganger` gjennom en ny `BrukergrunntilgangForvaltningService`, som er en kopi av `BrukerdelegeringForvaltningService`.

2. **Samlingstak per organisasjon:**
   - En SECURITY DEFINER-funksjon `samlingstak_i_mine_les_organisasjoner()` utvider `applikasjon_brukerdelegering_organisasjonssamling` til samlingens aktive medlemmer. Den gir én rad per (app, rolle, organisasjon, miljø, samling), med samme synlighet som `applikasjon_brukerdelegering_les`:
     - gren 1: LES i (miljø, medlemsorganisasjon)
     - gren 2: LES i eierorganisasjonen
     - I2 i tillegg
   - Et `security_invoker`-view `applikasjon_brukerdelegering_med_samling` slår sammen direkte rader (under RLS) og samlingsradene, med `tilknytning` (`DIREKTE`/`SAMLING`) og `organisasjonssamlingslopenr`. Det er samme grep som `subjektrolletildeling_med_arv_samling` / `subjektrolletildeling_med_arv` (0104/0107).
   - `Brukerdelegering` flyttes til viewet og får `tilknytning` og `organisasjonssamling`.

3. **I2 for taket:**
   - Lesepolicyene `applikasjon_brukerdelegering_les` og `applikasjon_brukerdelegering_organisasjonssamling_les` får I2. Det er ferdig i **!6238 (BAT-318)**: changeset 0109, pgTAP 94, godkjent av alfle, men 130 commits bak main. Oppgaven er å rebase og merge den, ikke å skrive den på nytt.
   - Samlingstak-funksjonen i spor 2 håndhever I2 selv, fordi den leser forbi RLS.

Opprydding: «eget privilegium» rettes i nye `COMMENT ON` i changeset 0131. Kjørte changesets endres ikke, så `--`-kommentarene i 0099/0117/0048/0119 blir stående. Headeren i 0131 sier at de er foreldet. Docs (`tilgangsmodell.md`, `syntetiske-og-ekte-data.md`, `plan-gulv-per-applikasjon.md`) rettes.

### Key Technical Decisions

1. **Decision: Gulvet forvaltes med `kan_forvalte_delegering`, uendret funksjon, nye policyer.**
   - Why:
     - Det er beslutningen.
     - Funksjonen tar akkurat (subjekt_id, organisasjonskode, miljokode).
     - Ledd 1 og 2 matcher radens miljø (I5).
     - Den er SECURITY INVOKER, så eieroppslaget går gjennom `feide_applikasjon_les`, som er fail-closed og allerede har I2 (0105).
     - Servicen kan bruke samme funksjon for svarvalget når ingenting skrives.
   - Alternative considered:
     - En ny `kan_forvalte_grunntilgang` som omslag gir to navn på én regel. Forkastet.
     - Et eget privilegium er forkastet av Kjetil.
   - Følge: funksjonens `COMMENT` sier i dag «én delegeringstakrad» og navngir den døde policyen `applikasjon_brukerdelegering_skriv`. Den skrives på nytt i 0131 og nevner begge tabellene og de seks policyene.

2. **Decision: I2 står eksplisitt i USING på `applikasjon_brukergrunntilgang_endre/_slett`, men ikke i WITH CHECK eller på `_opprett`.**
   - Why:
     - Det er bestillingen («per 0117»).
     - 0117 er allerede konvensjonen på gulvtabellen (`_les` har I2 fra 0117).
     - En `UPDATE t SET …` uten WHERE bruker bare `_endre`/`_slett` (0117:63–66).
   - Merk: vilkåret er strengt tatt redundant. `kan_forvalte_delegering` svarer allerede nei for en ekte app fra et syntetisk miljø, fordi den leser eieren gjennom `feide_applikasjon_les`. Det er argumentet !6238 bruker for å la tak-`_endre/_slett` være uten I2. Begge deler er sant. Gulvet får det eksplisitte vilkåret som beltet over selene, så det ikke henger på at `feide_applikasjon_les` beholder sin I2. Kommentaren på policyene sier dette, så en reviewer ikke tror tak og gulv er inkonsistente ved en feil. Om taket skal få det samme, er spørsmål 4.
   - Alternative considered: ingen I2 i USING, som taket i !6238. Forkastet fordi bestillingen er eksplisitt.

3. **Decision: Ikke reimplementere I2 for taket. Merge !6238 som T1.**
   - Why: !6238 gjør nøyaktig det beslutning 5 krever, for begge taktabellene, med negativ kontroll og pgTAP 94. Den har review.
   - Alternative considered: skrive I2 for taket inn i 0131 eller 0133. Det gir dobbelt arbeid og konflikt med en godkjent MR. Hvis Kjetil heller vil lukke !6238, flyttes 0109-innholdet uendret til et nytt changeset i T5 (spørsmål 1).

4. **Decision: Samlingstak vises gjennom en SECURITY DEFINER-funksjon og et union-view, og `Brukerdelegering` flyttes til viewet (alternativ A).**
   - Why:
     - FS Admin trenger én paginert liste med `totalCount`.
     - Klienten må kunne avgjøre «allerede i taket» per (organisasjon, miljø) for både direkte tak og samlingstak.
     - Lesepolicyen på samlingstabellen krever full dekning (`kan_lese_delegering_samling`), og det er strengere enn «synlig der en direkte rad ville vært det». Derfor må lesingen gå forbi RLS i en smal definer-funksjon, slik 0107 gjorde for tildelinger.
     - Taket i domenet er direkte ∪ samling. Det er slik `raa_delegeringstilganger` og `roller_i_applikasjonstak` regner. Da er det riktig at `brukerdelegeringer` viser begge.
     - Feltet er experimental, og fs-admin bruker det ikke (`git grep` i fs-admin `origin/main`: ingen treff på `brukerdelegeringer`).
   - Kostnad:
     - Syntetisk PK og FK-er i `tilgangsstyring-new-jooq/pom.xml`, som `fk_srt_med_arv_*`.
     - Ekte kolonner for `gyldig_fra`/`gyldig_til`/`er_aktiv` i viewet. De syntetiske periodekolonnene gjelder bare tabeller (`periodetabeller` matcher hele tabellnavnet, ikke `…_med_samling`; verifiser i generert kode).
     - `@reference`-nøklene i SDL får nye navn.
   - Alternative considered:
     - **A′:** nytt felt `FeideApplikasjon.delegeringstak` med en slank type på viewet. `brukerdelegeringer` står urørt, men det blir to felt for samme begrep.
     - **B:** eget felt bare for samlingsrader. Enklest på serveren, men klienten må slå sammen og mister felles `totalCount`/paginering.
     - Begge er dårligere for klienten. Valget mellom A og A′ er spørsmål 3.

5. **Decision: Ny enum `BrukerdelegeringTilknytning { DIREKTE, SAMLING }`, ikke den stabile `Tilknytning`.**
   - Why: `ARVET` forekommer aldri i taket, fordi taket lagres uekspandert. En verdi klienten aldri ser gjør kontrakten uklar. Enumen brukes bare som output. Et filterfelt på tilknytning er ikke nødvendig, fordi klienten viser begge.
   - Alternative considered: gjenbruke `Tilknytning`. Forkastet.

6. **Decision: Samlingsradene i viewet er bare de som gjelder nå.**
   - Why:
     - Kravet viser bare det som gjelder nå.
     - Funksjonen er en definer-flate, og å utvide historikk gjennom den gir et større innsynsvindu uten behov.
     - Direkte rader beholder historikken (filtret `erAktivNaa` uendret).
   - Gyldighetsperioden på en samlingsrad er snittet av takradens og medlemskapets periode, som i 0107.
   - Alternative considered: historikk for samlingsrader. Ikke etterspurt.

7. **Decision: Nye, gulvspesifikke feiltyper.**
   - Typene er:
     - `ManglerGrunntilgangsforvaltning` (DATABASE 42501 og GENERIC-exception)
     - `BrukergrunntilgangApplikasjonFinnesIkke` (GENERIC «Decoded NodeId did not match»)
     - `BrukergrunntilgangTilgangskodeFinnesIkke` (DATABASE 23503, matches `brukergrunntilgang_rolle`)
     - `SyntetiskApplikasjonIEktMiljo` (DATABASE `TS204`)
   - Why:
     - Teksten i `ManglerDelegeringsforvaltning` er skrevet for taket.
     - `@error` er per type.
     - TS204 kastes bare av gulvets I4-trigger (`gulv_krever_lik_klassifisering`), og uten en handler blir feilen redigert bort. Mønsteret er `SyntetiskPersonIEktMiljo` (`schema_personbruker_tilgang_med_nummer.graphqls:59`). TS204 kan i praksis ikke treffe en INSERT som har kommet forbi `_opprett` fra et syntetisk miljø, men den treffer fra et ekte miljø (syntetisk app i production).
   - Alternative considered: generalisere `ManglerDelegeringsforvaltning` til «forvaltning av tak og gulv». Det endrer en eksisterende kontrakt. Forkastet.

8. **Decision: `fjernBrukerdelegeringer` på en rolle som bare kommer fra en samling forblir en idempotent suksess.**
   - Why: det følger av beslutning 6, der klienten hindrer og serveren ikke avviser. UPDATE-en treffer null direkte rader, `kan_forvalte_delegering` sier ja, og det blir suksess uten endring. Feltet `tilknytning` gjør at klienten ikke viser fjern-knappen.
   - Alternative considered: `SamlingstakKanIkkeFjernes`, som `SamlingstildelingKanIkkeFjernes` i 0107. Det er spørsmål 2.

9. **Decision: Ingen serverside avgrensning til forretningsroller, ingen valglistekilde for organisasjon og miljø, ingen speiling til `local`.**
   - Why: beslutning 1, 3 og 4.

### File Changes Overview

**Database** (`tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/`):
- `0109-delegeringstak-syntetiske-applikasjoner.sql`: fra !6238 (T1), uendret.
- **Ny** `0131-gulv-forvaltes-som-taket.sql` (T2):
  - `GRANT INSERT, UPDATE, DELETE ON applikasjon_brukergrunntilgang TO ${app_role}`
  - `CREATE POLICY applikasjon_brukergrunntilgang_opprett/_endre/_slett`
  - `COMMENT ON` for tabellen, `_les`, de tre nye policyene, `kan_forvalte_delegering` og `applikasjon_brukerdelegering_opprett` (som i dag sier at gulvet «har sin egen forvaltning»)
- **Ny** `0133-samlingstak-per-organisasjon.sql` (T5): funksjonen `samlingstak_i_mine_les_organisasjoner()`, viewet `applikasjon_brukerdelegering_med_samling`, `GRANT EXECUTE`/`SELECT`.
- `db-changelog-root.xml`: én include med forklaringskommentar per changeset, sist i fila.

**pgTAP** (`tilgangsstyring/tilgangsstyring-new-db/src/test/sql/`):
- `01_structural_tests.sql`: `policies_are` for gulvet (fire policyer), `policy_cmd_is` for de tre nye, oppdatert `plan(...)`.
- `12_tilgangsmodell_rls_gc.sql:113–123`: snus. SKRIV hos eier og rad gir nå INSERT, og en negativ variant uten eierleddet legges til.
- **Ny** `112_gulv_forvaltes_som_taket.sql` (T2) og **ny** `113_samlingstak_per_organisasjon.sql` (T5).

**jOOQ:** `tilgangsstyring/tilgangsstyring-new-jooq/pom.xml` (T5): syntetisk primærnøkkel og syntetiske fremmednøkler for `applikasjon_brukerdelegering_med_samling`.

**Graf** (`tilgangsstyring/tilgangsstyring-app/src/main/resources/schema/features/experimental/`):
- **Ny** `schema_gulv.graphqls` (T3 lesing, T4 forvaltning).
- `schema_delegeringstak.graphqls` (T6): `Brukerdelegering @table` til viewet, nye felt, nye nøkkelnavn, enum, oppdatert dokumentasjon.

**Service** (`tilgangsstyring/tilgangsstyring-service/src/main/java/no/sikt/fs/tilgangsstyring_service/`):
- **Nye:** `BrukergrunntilgangForvaltningService.java`, `BrukergrunntilgangerFilterConditions.java`, `ManglerGrunntilgangsforvaltningException.java` (T3/T4).
- `BrukerdelegeringerFilterConditions.java` (T6): parametertypen byttes til view-klassen.
- Javadoc i `BrukerdelegeringForvaltningService.java` (T6): «les `brukerdelegeringer`» omfatter nå samlingstak.

**IT** (`tilgangsstyring/tilgangsstyring-app/src/test/java/no/sikt/fs/tilgangsstyring/`):
- **Ny** `GulvGraphqlTest.java` (T3/T4).
- `DelegeringstakGraphqlTest.java` (T6).

**Docs** (`tilgangsstyring/docs/`):
- `syntetiske-og-ekte-data.md` («Hvor reglene håndheves», I2-raden): oppdateres i T2 og T5, i samme MR som håndhevingen (CLAUDE.md).
- `tilgangsmodell.md` (T7):
  - §`applikasjon_brukergrunntilgang` ca. :630–642
  - §Effektiv tilgang ca. :704–709
  - takforvaltningen ca. :1094–1101
  - samlingstak-lesingen
- `specs/gulv-per-applikasjon/plan-gulv-per-applikasjon.md:39, :51` (T7): en datert merknad om at beslutningen er endret, ikke en omskriving av en historisk plan.
- `malarkitektur.md:198` (`APPLIKASJON_ADMINISTRATOR`): foreslås rettet i den åpne !6551, som endrer samme fil.

## GraphQL-endringer

Laget uten `bat-graphql-dev`. Malen er `schema_delegeringstak.graphqls`, med samme konvensjoner: ingen node-id når perioden er i PK, payload er applikasjonen, alt-eller-ingenting med `transactionResult`, og `@error` med én exception per kall.

### Op 1: Lese gulvet. `FeideApplikasjon.brukergrunntilganger` (Implementeres av: Task #3)

```graphql
"""Én rolle i gulvet til en Feide-applikasjon: alle brukere av applikasjonen får rollen i organisasjonen og miljøet, også brukere uten egne roller. Ligger utenfor taket."""
type Brukergrunntilgang @table(name: "applikasjon_brukergrunntilgang") {
  tilgangsrolle: Tilgangsrolle @reference(path: [{key: "applikasjon_brukergrunntilgang__fk_applikasjon_brukergrunntilgang_rolle"}])
  organisasjon: Organisasjon @reference(path: [{key: "applikasjon_brukergrunntilgang__fk_applikasjon_brukergrunntilgang_organisasjon"}])
  miljo: Miljo @reference(path: [{key: "applikasjon_brukergrunntilgang__fk_applikasjon_brukergrunntilgang_miljo"}])
  gyldighetsperiode: BrukergrunntilgangGyldighetsperiode
  erAktivNaa: Boolean @field(name: "ER_AKTIV")
  lagtTilAvFeideBruker: FeideBruker @reference(path: [{key: "applikasjon_brukergrunntilgang__fk_applikasjon_brukergrunntilgang_opprettet_av_bruker"}])
  fjernetAvFeideBruker: FeideBruker @reference(path: [{key: "applikasjon_brukergrunntilgang__fk_applikasjon_brukergrunntilgang_fjernet_av_bruker"}])
  # Applikasjonsleddene i sporingen (opprettet/fjernet_av_applikasjon) kan legges til med
  # @referenceFor som på Brukerdelegering; ikke nødvendig for fanen.
}

type BrukergrunntilgangGyldighetsperiode {
  fraTidspunkt: DateTime @field(name: "GYLDIG_FRA")
  tilTidspunkt: DateTime @field(name: "GYLDIG_TIL")
}

input BrukergrunntilgangerFilterInput {
  miljoer: [ID!] @nodeId(typeName: "Miljo")
  organisasjoner: [ID!] @nodeId(typeName: "Organisasjon")
  erAktivNaa: Boolean @condition(condition: {className: "no.sikt.fs.tilgangsstyring_service.BrukergrunntilgangerFilterConditions", method: "erAktivNaa"}, override: true)
}

extend type FeideApplikasjon {
  brukergrunntilganger(filter: BrukergrunntilgangerFilterInput): [Brukergrunntilgang]
    @asConnection(defaultFirstValue: 10)
    @splitQuery
    @reference(path: [ ... ])   # se under
    @defaultOrder(fields: [{name: "ORGANISASJONSKODE"}, {name: "MILJOKODE"}, {name: "ROLLEKODE"}, {name: "OPPRETTET_TIDSPUNKT"}])
}
```

- **Referansestien er en felle.** Gulvets FK går til `subjekt(subjekt_id, subjekt_type)`, ikke til `feide_applikasjon`, som er ulikt taket. Velg én av to:
  - to hopp via subjekt: `feide_applikasjon__fk_feide_applikasjon_subjekt` og så `applikasjon_brukergrunntilgang__fk_applikasjon_brukergrunntilgang_subjekt`, som `tilganger` via subjekt-ankeret
  - en syntetisk FK `fk_applikasjon_brukergrunntilgang_feide_applikasjon` (subjekt_id → feide_applikasjon) i jOOQ-pom-en, som gir ett hopp
  
  Verifiser nøkkelnavnene i generert `Keys`.
- Sorteringsnøkkelen er den samme som taket bruker. Den er unik over historikken fordi to perioder for samme kombinasjon ikke kan ha samme `opprettet_tidspunkt` (tomt intervall avvises).

### Op 2–3: Forvalte gulvet. `leggTilBrukergrunntilganger`, `fjernBrukergrunntilganger` (Implementeres av: Task #4)

```graphql
input LeggTilBrukergrunntilgangerInput {
  applikasjonId: ID! @nodeId(typeName: "FeideApplikasjon")
  tilgangskodeId: ID! @nodeId(typeName: "Tilgangsrolle")
  organisasjonId: ID! @nodeId(typeName: "Organisasjon")
  miljoId: ID! @nodeId(typeName: "Miljo")
}
input FjernBrukergrunntilgangerInput { applikasjonId: ID! @nodeId(typeName: "FeideApplikasjon")  tilgangskodeId: ID! @nodeId(typeName: "Tilgangsrolle")  organisasjonId: ID! @nodeId(typeName: "Organisasjon")  miljoId: ID! @nodeId(typeName: "Miljo") }

type LeggTilBrukergrunntilgangerPayload { feideApplikasjoner: [FeideApplikasjon]  errors: [LeggTilBrukergrunntilgangerError] }
type FjernBrukergrunntilgangerPayload  { feideApplikasjoner: [FeideApplikasjon]  errors: [FjernBrukergrunntilgangerError] }

type ManglerGrunntilgangsforvaltning implements Error @error(handlers: [
  { handler: DATABASE, sqlState: "42501", description: "Du har ikke rettighet til å forvalte gulvet." },
  { handler: GENERIC, className: "no.sikt.fs.tilgangsstyring_service.ManglerGrunntilgangsforvaltningException", description: "Du har ikke rettighet til å forvalte gulvet." }]) { path: [String!]!  message: String! }
type BrukergrunntilgangApplikasjonFinnesIkke implements Error @error(handlers: [
  { handler: GENERIC, className: "graphql.GraphqlErrorException", matches: "Decoded NodeId did not match", description: "Applikasjonen finnes ikke som Feide-applikasjon." }]) { path: [String!]!  message: String! }
type BrukergrunntilgangTilgangskodeFinnesIkke implements Error @error(handlers: [
  { handler: DATABASE, sqlState: "23503", matches: "brukergrunntilgang_rolle", description: "Tilgangskoden finnes ikke i rollekatalogen." }]) { path: [String!]!  message: String! }
type SyntetiskApplikasjonIEktMiljo implements Error @error(handlers: [
  { handler: DATABASE, sqlState: "TS204", description: "En syntetisk applikasjon kan ikke få gulv i et ekte miljø." }]) { path: [String!]!  message: String! }

union LeggTilBrukergrunntilgangerError = ManglerGrunntilgangsforvaltning | BrukergrunntilgangApplikasjonFinnesIkke | BrukergrunntilgangTilgangskodeFinnesIkke | SyntetiskApplikasjonIEktMiljo
union FjernBrukergrunntilgangerError  = ManglerGrunntilgangsforvaltning | BrukergrunntilgangApplikasjonFinnesIkke

extend type Mutation {
  leggTilBrukergrunntilganger(input: [LeggTilBrukergrunntilgangerInput!]!): LeggTilBrukergrunntilgangerPayload
    @service(service: {className: "no.sikt.fs.tilgangsstyring_service.BrukergrunntilgangForvaltningService", method: "leggTilBrukergrunntilganger"})
  fjernBrukergrunntilganger(input: [FjernBrukergrunntilgangerInput!]!): FjernBrukergrunntilgangerPayload
    @service(service: {className: "no.sikt.fs.tilgangsstyring_service.BrukergrunntilgangForvaltningService", method: "fjernBrukergrunntilganger"})
}
```

- Semantikken er identisk med taket:
  - Begge er idempotente.
  - Å legge til en rolle som gjelder fra før skriver ikke noe, men sjekker retten.
  - Fjerning lukker `gyldig_periode` med `tstzrange(lower, now(), '[)')`. Treffer UPDATE-en null rader, kalles `kan_forvalte_delegering` for å skille «ingen rett» fra «gjelder ikke».
  - Hele kallet er alt eller ingenting i `ctx.transactionResult` (graphitron#530).
  - Mutasjonsbeskrivelsen sier tydelig at gulvet gir **alle** brukere rollen, også ukjente, og at det utvider tilgangene til eksisterende brukere.
- I4 i fjern-unionen er ikke aktuelt: triggeren fyrer bare på `UPDATE OF subjekt_id, miljokode`.
- At DATABASE-handleren for `TS204` faktisk fyrer gjennom `@service`, verifiseres i `GulvGraphqlTest`. Fyrer den ikke, gjør servicen det samme som `SyntetiskPersonIEktMiljo`: den fanger `DataAccessException` med SQLSTATE TS204 og kaster en egen exception med GENERIC-handler.

### Op 4: Samlingstak i taklisten. `Brukerdelegering` på viewet (Implementeres av: Task #6)

```graphql
"""Hvor en rolle i taket kommer fra."""
enum BrukerdelegeringTilknytning {
  "Lagt i taket for organisasjonen selv. Kan fjernes med fjernBrukerdelegeringer."
  DIREKTE
  "Lagt i taket for en organisasjonssamling organisasjonen er aktivt medlem av. Kan ikke fjernes for én organisasjon."
  SAMLING
}

type Brukerdelegering @table(name: "applikasjon_brukerdelegering_med_samling") {
  # eksisterende felt, med @reference-nøkler byttet til applikasjon_brukerdelegering_med_samling__fk_*
  tilknytning: BrukerdelegeringTilknytning! @field(name: "TILKNYTNING")
  "Samlingen taket er gitt gjennom. Null for DIREKTE."
  organisasjonssamling: Organisasjonssamling @reference(path: [{key: "applikasjon_brukerdelegering_med_samling__fk_abms_organisasjonssamling"}])
  # trukketTilbakeAv* er null for SAMLING (samlingsradene er bare de som gjelder nå)
}

extend type FeideApplikasjon {
  brukerdelegeringer(filter: BrukerdelegeringerFilterInput): [Brukerdelegering]
    @asConnection(defaultFirstValue: 10) @splitQuery
    @reference(path: [{key: "applikasjon_brukerdelegering_med_samling__fk_abms_feide_applikasjon"}])
    @defaultOrder(fields: [{name: "ORGANISASJONSKODE"}, {name: "MILJOKODE"}, {name: "ROLLEKODE"}, {name: "TILKNYTNING"}, {name: "KILDENOKKEL"}, {name: "OPPRETTET_TIDSPUNKT"}])
}
```

- **Sorteringsnøkkelen må være unik** (CLAUDE.md). Samme (org, miljø, rolle) kan komme fra en direkte rad og fra flere samlinger. `KILDENOKKEL = coalesce(organisasjonssamlingslopenr, 0)` er NOT NULL, fordi en nullbar kolonne i seek-predikatet ville miste rader.
- Filteret er uendret (`miljoer`, `organisasjoner`, `erAktivNaa`). `miljoer`/`organisasjoner` går over syntetiske FK-er på viewet. `erAktivNaa` leser viewets ekte `ER_AKTIV`.

### Klientskisse (fs-admin)

```ts
const TAK_OG_GULV = gql`
  query TakOgGulv($id: ID!, $miljoer: [ID!]) {
    node(id: $id) { ... on FeideApplikasjon {
      brukerdelegeringer(first: 100, filter: { erAktivNaa: true, miljoer: $miljoer }) {
        totalCount
        nodes { tilknytning tilgangsrolle { id kode } organisasjon { id navn } miljo { id }
                gyldighetsperiode { fraTidspunkt tilTidspunkt }
                organisasjonssamling { id navnAlleSprak { nb } } }
      }
      brukergrunntilganger(first: 100, filter: { erAktivNaa: true, miljoer: $miljoer }) {
        totalCount
        nodes { tilgangsrolle { id kode } organisasjon { id navn } miljo { id }
                gyldighetsperiode { fraTidspunkt tilTidspunkt } }
      }
    } }
  }`;
// Delvis suksess: alias-batch, ett alias per element, som useTildelPersonbrukerTilganger/byggAliasBatch:
// mutation { a0: leggTilBrukergrunntilganger(input: [{...}]) { errors { __typename ... on Error { message } } } a1: ... }
```

Feltnavnene på `Tilgangsrolle`/`Organisasjon` følger dagens typer; verifiser mot supergrafen.

## Implementation Tasks

### Task #1: Land !6238 (I2 for taket)

**Priority**: High
**Size**: S
**Dependencies**: None
**Addresses Requirements**: Beslutning 5. `@BRU-APP-API-018` («Syntetiske og ekte miljøer … som ved tildeling av roller til personbrukere»).

**Acceptance Criteria**:
- [ ] !6238 er rebaset på main. Changeset 0109 og pgTAP 94 er uendret i innhold. Includen ligger sist i `db-changelog-root.xml` (konflikt med !6495/!6518/!6550 løses av den som merger sist).
- [ ] I2-raden i `syntetiske-og-ekte-data.md` sier at taket er håndhevet (konflikt med !6355 forventes, se MR-teksten).
- [ ] pgTAP grønn, inkludert 34 (én policy per operasjon) og 94 med negativ kontroll.

**Implementation Notes**: Ingen ny kode. Hvis Kjetil heller vil lukke !6238, flyttes de to `ALTER POLICY` i 0109 uendret til et nytt changeset først i T5, og pgTAP 94 blir en del av 113.

### Task #2: Gulvet kan skrives i databasen etter samme regel som taket (changeset 0131)

**Priority**: High
**Size**: M
**Dependencies**: None. Teknisk uavhengig av T1, merges gjerne etter.
**Addresses Requirements**: `@BRU-APP-API-019`, reglene «Forvaltning av gulvet krever applikasjonsadministrator-rollen for applikasjonseieren og for organisasjonen gulvet gjelder, i samme miljø», «Tildeling …» og «Fjerning …».

**Acceptance Criteria**:
- [ ] `0131-gulv-forvaltes-som-taket.sql`, i egne changesets med `SET LOCAL lock_timeout = '2s'`:
  - `GRANT INSERT, UPDATE, DELETE ON tilgangsstyring.applikasjon_brukergrunntilgang TO ${app_role}`. Speiler grantene fra 0007, som 0099 trakk tilbake. DELETE blokkeres fortsatt av `trig_enforce_temporal_immutability`.
  - `applikasjon_brukergrunntilgang_opprett` FOR INSERT, WITH CHECK `kan_forvalte_delegering(subjekt_id, organisasjonskode, miljokode)`.
  - `_endre` FOR UPDATE, USING `kan_forvalte_delegering(...) AND <I2>`, WITH CHECK `kan_forvalte_delegering(...)`.
  - `_slett` FOR DELETE, USING `kan_forvalte_delegering(...) AND <I2>`.
  - `<I2>` er ordrett leddet fra `applikasjon_brukergrunntilgang_les` (0117:47–52).
- [ ] Nye `COMMENT ON`:
  - TABLE `applikasjon_brukergrunntilgang` (ikke lenger «bare lesing … eget privilegium»)
  - POLICY `_les` (fjern «Det finnes ingen skrivepolicy … eget privilegium»)
  - de tre nye policyene, med en forklaring av hvorfor I2 står i USING selv om funksjonen allerede er fail-closed
  - FUNCTION `kan_forvalte_delegering` (begge tabellene, de seks policyene, både `BrukerdelegeringForvaltningService` og `BrukergrunntilgangForvaltningService`)
  - POLICY `applikasjon_brukerdelegering_opprett` (gulvet forvaltes etter samme regel, ikke «egen forvaltning»)
- [ ] Headeren i 0131 sier at `--`-kommentarene om eget privilegium i 0099 (:9–12, :94–97), 0117 og 0048 er foreldet og ikke rettes, fordi kjørte changesets ikke endres.
- [ ] pgTAP 01: `policies_are` for gulvet med fire policyer, `policy_cmd_is` INSERT/UPDATE/DELETE, `plan` justert.
- [ ] pgTAP 12 (:113–123): «kan ikke skrive, heller ikke med SKRIV hos eieren» erstattes av:
  - (a) SKRIV i rad og eier gir INSERT
  - (b) SKRIV bare i raden, med eier i en annen organisasjon, gir 42501
- [ ] Ny pgTAP 112:
  - Scenariomatrisen fra kravet: tildele og fjerne med eier og rad i samme miljø gir ok, ulikt miljø gir 42501, og for fjerning null rader.
  - Eier = rad krever bare én rolle.
  - Lukking av perioden som UPDATE med WHERE: sporingen (`fjernet_av_*`) settes av triggeren.
  - DELETE blokkeres.
  - Fra et syntetisk miljø gir `UPDATE … SET invalidert_tidspunkt = now()` uten WHERE 0 rader mot en ekte app, også med SKRIV overalt (som pgTAP 94).
  - TS204 fyrer fortsatt for en syntetisk app i production.
  - En regresjon: en gulvrad skrevet av app-rollen gir rollen i `tilganger_for_bruker*` for en bruker uten roller, og lukket gir den ikke.
  - Forventet antall policyer per operasjon.
- [ ] `syntetiske-og-ekte-data.md`, «Hvor reglene håndheves»: I2-raden nevner `applikasjon_brukergrunntilgang_endre/_slett`, og I4-raden nevner at gulvet nå skrives gjennom grafen. Tester: 112.
- [ ] Hele pgTAP-suiten er grønn.

**Implementation Notes**: Changeset 0131 (ledig, !6521 er lukket). Test-fikstur: rader som skal lukkes, seedes med nedre grense i fortiden (`now()` er transaksjonskonstant, se javadoc i `BrukerdelegeringForvaltningService`). Mal for policyformen: `0119-applikasjon-brukerdelegering`. Mal for I2 i USING: `brukerrollenekt_endre/_slett` i 0117. Ingen grafendring. Uten T4 finnes ingen vei for klienter å skrive, så merge og deploy eksponerer ingenting.

### Task #3: Gulvet i grafen, lesing (`schema_gulv.graphqls`)

**Priority**: High
**Size**: M
**Dependencies**: None (lesepolicyen og jOOQ finnes). Kan gå parallelt med T2.
**Addresses Requirements**: `@BRU-APP-API-019`, reglene «Fanen for gulvet viser rollene i gulvet til applikasjonen som gjelder nå», «Se gyldighetstidsrommet» og «Alle som kan se applikasjonen, ser fanen».

**Acceptance Criteria**:
- [ ] `Brukergrunntilgang`, `BrukergrunntilgangGyldighetsperiode`, `BrukergrunntilgangerFilterInput` og `FeideApplikasjon.brukergrunntilganger` som i Op 1, med beskrivelser på norsk etter stilen i `schema_delegeringstak.graphqls`. Begrunnelsene står som `#`-kommentarer inne i blokker, ikke mellom definisjoner.
- [ ] `BrukergrunntilgangerFilterConditions.erAktivNaa` leser `ER_AKTIV`, som `BrukerdelegeringerFilterConditions`.
- [ ] Referansestien fra `FeideApplikasjon` er verifisert mot generert `Keys`, enten to hopp via subjekt eller en syntetisk FK i pom-en (velg én og begrunn i en kommentar).
- [ ] `GulvGraphqlTest` (lesing):
  - LES i radens organisasjon ser raden.
  - LES bare hos eieren ser kryssorganisatoriske rader.
  - LES i en annen organisasjon ser ingenting.
  - `erAktivNaa: true` skjuler en avsluttet rad og en rad som starter senere.
  - `gyldighetsperiode.tilTidspunkt` er null for en åpen periode og satt for en lukket.
  - Fra et syntetisk miljø er gulvet til en ekte app usynlig.
  - `miljoer`/`organisasjoner` filtrerer.
  - `totalCount` stemmer.
- [ ] Supergrafen/composition er grønn.

**Implementation Notes**: Gulvrader seedes i fiksturen med SQL som eier (som `DelegeringstakGraphqlTest`), siden skriving gjennom grafen først kommer i T4.

### Task #4: Gulvet i grafen, forvaltning (service, mutasjoner, feil)

**Priority**: High
**Size**: L
**Dependencies**: Task #2, Task #3
**Addresses Requirements**: `@BRU-APP-API-019`, reglene om tildeling, fjerning, forvaltningsretten og delvis suksess (via alias-batch i klienten).

**Acceptance Criteria**:
- [ ] `BrukergrunntilgangForvaltningService` med `leggTilBrukergrunntilganger`/`fjernBrukergrunntilganger`:
  - Speiler `BrukerdelegeringForvaltningService` (idempotens, lukking av perioden, `transactionResult`, payload = `FeideApplikasjonRecord` med bare PK).
  - Svarvalget ved null skrivinger kaller `Routines.kanForvalteDelegering`, altså samme funksjon som policyene.
  - Ingen egen rettighetslogikk foran skrivingen.
- [ ] Inputs, payloads, de fire feiltypene og unionene som i Op 2–3. `ManglerGrunntilgangsforvaltningException` har konstant melding.
- [ ] `GulvGraphqlTest` (forvaltning):
  - Tildeling i eierorganisasjonen med én rolle gir ok.
  - Kryssorganisatorisk med rollen i begge, i samme miljø, gir ok.
  - Bare den ene siden, eller feil miljø, gir `ManglerGrunntilgangsforvaltning`, både for tildeling og fjerning (også fjerning av en rad som finnes, men er usynlig).
  - Idempotens: samme rolle to ganger gir én rad og uendret `fraTidspunkt`; fjerning av noe som ikke gjelder er suksess.
  - Fjerning lukker perioden, raden er borte med `erAktivNaa: true` og ligger i historikken.
  - Ukjent rollekode gir `BrukergrunntilgangTilgangskodeFinnesIkke`.
  - Id-en til en Maskinporten-app gir `BrukergrunntilgangApplikasjonFinnesIkke`.
  - En syntetisk app i production gir `SyntetiskApplikasjonIEktMiljo`.
  - Batch med ett feilende element gir at ingenting er skrevet.
  - Alias-batch med to mutasjonsfelt, ett ok og ett feil, gir at det gyldige er skrevet. Det dokumenterer at delvis suksess fungerer med klientens mønster.
- [ ] Effekten: en Feide-bruker uten roller som logger inn gjennom appen, får gulvrollen etter `leggTil`, og ikke etter `fjern`. Én IT-test med eksisterende innloggingshjelpere, eller en henvisning til pgTAP 112 hvis IT-oppsettet ikke støtter det.

**Implementation Notes**: Mutasjonsbeskrivelsene sier at gulvet gir alle brukere rollen, også ukjente, at det ligger utenfor taket, og at retten er den samme som for taket. TS204: se merknaden under Op 2–3.

### Task #5: Samlingstak per organisasjon i databasen (changeset 0133)

**Priority**: High
**Size**: L
**Dependencies**: Task #1 (myk avhengighet: uten !6238 har direkte takrader ikke I2 mens samlingsradene har det, og synligheten blir ujevn i syntetiske miljøer)
**Addresses Requirements**: `@BRU-APP-API-018`, regelen «Tak for en organisasjonssamling vises som tak for hver organisasjon i samlingen», og scenariene «Listen viser hvor taket kommer fra» og «Rolle i taket gjennom en organisasjonssamling regnes som allerede i taket».

**Acceptance Criteria**:
- [ ] `samlingstak_i_mine_les_organisasjoner()`:
  - Returnerer TABLE(subjekt_id, rollekode, organisasjonskode, miljokode, organisasjonssamlingslopenr, opprettet_av_bruker, opprettet_tidspunkt, gyldig_periode).
  - `SECURITY DEFINER`, `SET search_path = tilgangsstyring, pg_temp`, STABLE.
  - Leser `applikasjon_brukerdelegering_organisasjonssamling` × `organisasjonssamlingsmedlemskap`, med begge aktive nå. Perioden er snittet.
  - Filter: `(m.miljokode, m.organisasjonskode) IN orger_med_tilgang('BRUKERADMIN_WSBRUKER_LES')`, ELLER `(t.subjekt_id, t.miljokode) IN feide_applikasjoner_eid_av_mine_les_organisasjoner_per_miljo()`, OG I2 (`ekte_applikasjoner()` / kallende miljø), som `_les` etter !6238.
  - `REVOKE ALL … FROM PUBLIC`, `GRANT EXECUTE` til app-rollen.
  - `COMMENT` peker på 0107 og sier at takleddene også står i `raa_delegeringstilganger` og `roller_i_applikasjonstak` og skal følge med ved endring.
- [ ] Viewet `applikasjon_brukerdelegering_med_samling` (`security_invoker = true`):
  - Direkte rader fra `applikasjon_brukerdelegering` (RLS) med `tilknytning = 'DIREKTE'`, `organisasjonssamlingslopenr = NULL` og `kildenokkel = 0`.
  - UNION ALL samlingsrader fra funksjonen med `'SAMLING'`, lopenr og `kildenokkel = lopenr`.
  - Ekte kolonner `gyldig_fra`/`gyldig_til` (uttrykkene fra `subjektrolletildeling_med_arv`, med infinity som NULL) og `er_aktiv = gyldig_periode @> now()`.
  - Sporingskolonnene. `fjernet_*` er NULL for samlingsrader.
  - `GRANT SELECT`. `COMMENT` på view og kolonner.
- [ ] jOOQ-pom: syntetisk PK (subjekt_id, rollekode, organisasjonskode, miljokode, tilknytning, kildenokkel, opprettet_tidspunkt), og syntetiske FK-er til:
  - feide_applikasjon (subjekt_id)
  - rolle
  - organisasjon
  - miljo
  - organisasjonssamling (lopenr)
  - feide_bruker (opprettet/fjernet_av_bruker)
  - subjekt (opprettet/fjernet_av_applikasjon)
  
  Prefiks `fk_abms_`. Verifiser at `periodetabeller`-regexen ikke treffer viewet.
- [ ] pgTAP 113:
  - Samling med UiS og UiB i production gir én rad per medlem med `SAMLING` og lopenr.
  - En organisasjon som er meldt ut eller ennå ikke inn, gir ingen rad.
  - Et avsluttet samlingstak gir ingen rad.
  - LES bare i UiS gir bare UiS-raden. Det er nettopp der leseregelen er mildere enn full dekning i `_les` på samlingstabellen.
  - LES hos eieren gir alle rader.
  - Fra et syntetisk miljø er ekte apper usynlige, også uten montert miljø.
  - Direkte rad og samlingsrad for samme (org, miljø, rolle) gir to rader med ulik `tilknytning`.
  - Viewet respekterer RLS på direkte rader.
  - Funksjonen er SECURITY DEFINER og ikke kjørbar for PUBLIC.
- [ ] `syntetiske-og-ekte-data.md`, I2-raden: «Applikasjonenes samlingstak i taklisten (`samlingstak_i_mine_les_organisasjoner`): radene til ekte applikasjoner er skjult i funksjonen». Tester: 113.

**Implementation Notes**: Ingen grafendring. Viewet har ingen lesere før T6, så merge og deploy er ufarlig. Hold funksjonen smal: én SELECT, ingen parametre, alt filtreres på kallerens privilegier.

### Task #6: Samlingstak i grafen (`Brukerdelegering` på viewet)

**Priority**: High
**Size**: M
**Dependencies**: Task #5
**Addresses Requirements**: `@BRU-APP-API-018`, samme regler som T5. «Tak fra en organisasjonssamling kan ikke fjernes» (via `tilknytning` i klienten).

**Acceptance Criteria**:
- [ ] `Brukerdelegering @table(name: "applikasjon_brukerdelegering_med_samling")`, alle `@reference`/`@referenceFor`-nøkler byttet til viewets syntetiske FK-er, og nye felt `tilknytning: BrukerdelegeringTilknytning!` og `organisasjonssamling: Organisasjonssamling`.
- [ ] `@defaultOrder` er utvidet med `TILKNYTNING`, `KILDENOKKEL`, og kommentaren om unik nøkkel er oppdatert.
- [ ] Beskrivelsen på `FeideApplikasjon.brukerdelegeringer` er oppdatert:
  - Taket omfatter samlingstak per medlemsorganisasjon.
  - Samlingsrader er bare de som gjelder nå.
  - Synligheten for samlingsrader følger den direkte leseregelen.
  - En samlingsrad fjernes ikke med `fjernBrukerdelegeringer`.
- [ ] Beskrivelsen på `fjernBrukerdelegeringer` nevner at en rolle som bare finnes via en samling, gir suksess uten endring (eller ny feil, avhenger av spørsmål 2).
- [ ] `BrukerdelegeringerFilterConditions.erAktivNaa` tar view-klassen.
- [ ] `DelegeringstakGraphqlTest`:
  - Eksisterende tester er grønne.
  - Nye: samlingstak vises per medlem med `tilknytning: SAMLING` og `organisasjonssamling.id`.
  - Direkte rad har `organisasjonssamling: null`.
  - `erAktivNaa: true` og `organisasjoner`-filter virker på begge.
  - Paginering over en side med direkte rad og to samlingsrader for samme (org, miljø, rolle) mister ingen rader.
  - `leggTilBrukerdelegeringer` for en rolle som alt er i taket via samling, lykkes og gir en DIREKTE-rad ved siden av (beslutning 6).

**Implementation Notes**: Kontraktsendring i experimental. Ingen konsument i fs-admin per `origin/main`. Varsle i MR-teksten.

### Task #7: Docs. Tilgangsmodellen sier at gulvet forvaltes som taket, og at samlingstak vises

**Priority**: Medium
**Size**: S
**Dependencies**: Task #2 (og T5 for samlingsavsnittet). Rebase etter !6495, som endrer `tilgangsmodell.md` ca. :1000–1300.
**Addresses Requirements**: Beslutningen om forvaltningsretten. Analysens hovedfunn 2.

**Acceptance Criteria**:
- [ ] `tilgangsmodell.md`:
  - §`applikasjon_brukergrunntilgang` (ca. :630–642): retten er `kan_forvalte_delegering`, skrives gjennom `leggTil/fjernBrukergrunntilganger`.
  - §Effektiv tilgang (ca. :704–709): «Derfor skal gulvet ha et eget privilegium» erstattes med begrunnelsen for at samme rett holder (krever rollen hos eier og rad i samme miljø, og gulvet er synlig i FS Admin).
  - Takforvaltningen (ca. :1094–1101): «eget privilegium, og fram til det kommer, ingen skriverett» rettes.
  - Nytt avsnitt om samlingstak i taklisten (0133).
  - Varselet om at `local` må holdes lik `test` (ca. :551–557) står og nevner at skrivingen i FS Admin bare treffer `test`.
- [ ] `specs/gulv-per-applikasjon/plan-gulv-per-applikasjon.md`: en datert merknad under tabellen (:39 «Forvaltning», :41 «Grafflate») og ved :51 om at BAT-411 (04.11.2026) gjør gulvet skrivbart med samme rett som taket.
- [ ] Ingen gjenværende «eget privilegium» om gulvet i `tilgangsstyring/docs` (grep).
- [ ] `malarkitektur.md:198` er rettet i !6551 eller her.

**Implementation Notes**: Docs-only MR, ingen deploy-effekt. Ble skilt ut for å holde konfliktflaten mot !6495/!6518/!6322 unna DB-MR-ene. `syntetiske-og-ekte-data.md` oppdateres likevel i T2/T5, slik CLAUDE.md krever.

## Kontrakt for fs-admin

Dette er hva frontend får. Grunnlag for `bat-analyze` i fs-admin.

| Behov i fanen | Grafen | Task |
|---|---|---|
| Taklisten (gjelder nå) | `FeideApplikasjon.brukerdelegeringer(filter: { erAktivNaa: true, miljoer?, organisasjoner? })` med `tilgangsrolle`, `organisasjon`, `miljo`, `gyldighetsperiode { fraTidspunkt, tilTidspunkt }`, `tilknytning` (`DIREKTE`/`SAMLING`), `organisasjonssamling { id, navnAlleSprak }` | T6 (direkte rader finnes i dag) |
| Gulvlisten (gjelder nå) | `FeideApplikasjon.brukergrunntilganger(filter: { erAktivNaa: true, … })` med `tilgangsrolle`, `organisasjon`, `miljo`, `gyldighetsperiode` | T3 |
| Tildele i taket / gulvet | `leggTilBrukerdelegeringer(input: [{ applikasjonId, tilgangskodeId, organisasjonId, miljoId }])` / `leggTilBrukergrunntilganger(...)` | finnes / T4 |
| Fjerne fra taket / gulvet | `fjernBrukerdelegeringer(...)` / `fjernBrukergrunntilganger(...)`, med de fire delene, ingen id | finnes / T4 |
| Delvis suksess | Alias-batch, ett mutasjonsfelt per element (som `useTildelPersonbrukerTilganger`/`byggAliasBatch`). Hvert felt er alt eller ingenting. | – |
| Feil, tak | `ManglerDelegeringsforvaltning`, `BrukerdelegeringApplikasjonFinnesIkke`, `BrukerdelegeringTilgangskodeFinnesIkke` | finnes |
| Feil, gulv | `ManglerGrunntilgangsforvaltning`, `BrukergrunntilgangApplikasjonFinnesIkke`, `BrukergrunntilgangTilgangskodeFinnesIkke`, `SyntetiskApplikasjonIEktMiljo` | T4 |
| Kan forvalte? (gating) | Klienten utleder fra `Query.mineTilganger(filter: { miljo })` per miljø (`mineSynligeMiljoer`): `BRUKERADMIN_WSBRUKER_SKRIV` i (miljø, eierorganisasjon) **og** (miljø, radens organisasjon). Ingen `kan*`-flagg fra serveren. | – |
| Valgliste organisasjon | Organisasjonene med `BRUKERADMIN_WSBRUKER_SKRIV` i minst ett miljø der eieren også har det. Bare organisasjoner, aldri samlinger. | – |
| Valgliste miljø | Miljøene der SKRIV gjelder for både eier og valgt organisasjon | – |
| Valgliste rolle | Rollekatalogen filtrert til navneromstype `forretning` i klienten. Serveren avgrenser ikke. Allerede i taket = finnes i taklisten for (org, miljø), uansett `tilknytning`. Allerede i gulvet = finnes i gulvlisten. | – |
| Fjern-knapp | Bare for `tilknytning: DIREKTE`, og bare der gatingen over holder for radens organisasjon og miljø | – |

Viktige egenskaper for klienten:
- Listene er paginert, standard `first: 10`.
- Gyldighetsperioden er halvåpen, og `tilTidspunkt: null` betyr «til videre».
- Eksisterende gulvrader kan ha koder som ikke er forretningsroller (fra migreringen i 0099). De vises og kan fjernes.
- Mutasjonspayloaden er applikasjonen. Hent listene på nytt med eget filter.

## Risk Assessment

### Technical Risks

- **Risk**: Deploy ved merge. En DB-endring går ut med én gang.
  - **Mitigation**: Rekkefølgen DB → graf er trygg. T2 gir app-rollen skriverett, men det finnes ingen skrivevei uten T4. T5 lager et view uten lesere til T6. Hver MR er additiv. Ingen `DROP` eller `CREATE OR REPLACE` av eksisterende funksjoner. 0131 bruker `ALTER`/`CREATE POLICY` med `lock_timeout`.
- **Risk**: Konflikt i `db-changelog-root.xml`. Alle tasks og !6495/!6518/!6550/!6238 legger includen sist.
  - **Mitigation**: Den som merger sist, løser konflikten. Ingen avhengighet mellom includene utover rekkefølgen T1 før T5. Kommentarene i root-xml-en noterer hvilke numre som er holdt.
- **Risk**: Tekstkonflikter i docs.
  - **Mitigation**:
    - I2-raden i `syntetiske-og-ekte-data.md` endres av !6238, !6355, T2 og T5. !6495 legger til en I5-rad, og !6518 endrer I0/I1/I4. Rebase i rekkefølge.
    - `tilgangsmodell.md`: !6495 (ca. :1000–1300, overlapper :1101 i T7), !6518 (:39, :93, :513, :850–972) og !6322 (stale, 340 bak). Gulvavsnittene ca. :630–709 overlapper ikke.
    - !6322 endrer også `plan-gulv-per-applikasjon.md` og pgTAP 01/20. T7 må rebases mot den hvis den merges først.
- **Risk**: Numre tatt før merge.
  - **Mitigation**:
    - Holdt av åpne MR-er: 0064 (!6322), 0109 (!6238), 0121 (!6355), 0126 (!6357), 0129 (!6495), 0130 (!6518), 0132 (!6550).
    - Reservert i root-xml: 0037–0039, 0046, 0055/0056.
    - pgTAP holdt: 94, 102, 109, 110, 111.
    - Forslag: **0131** (T2), **0133** (T5), pgTAP **112**, **113**. Lavere hull (0091, 0097, 0103, 0110; pgTAP 36, 40, 45–47, 77, 82) kan være ledige etter regelen «første ledige» i `tilgangsstyring/CLAUDE.md`, men krever sjekk av lukkede reservasjoner. Sjekk `glab mr list` rett før hver MR.
- **Risk**: Graphitron-seek mister rader i union-viewet hvis sorteringsnøkkelen ikke er unik eller har NULL.
  - **Mitigation**: `KILDENOKKEL` NOT NULL og `TILKNYTNING` i nøkkelen. Pagineringstest i T6.
- **Risk**: Gulvets FK går til `subjekt`, ikke `feide_applikasjon`, så `@reference` fra `FeideApplikasjon` er ikke ett hopp.
  - **Mitigation**: To hopp via subjekt eller en syntetisk FK (T3). Verifiser i generert `Keys`.
- **Risk**: Det er ikke verifisert at DATABASE-handleren for `TS204` fyrer gjennom `@service`.
  - **Mitigation**: Test i T4. Ellers servicefangst og GENERIC (mønsteret fra `SyntetiskPersonIEktMiljo`).
- **Risk**: Takleddene står nå tre steder (`raa_delegeringstilganger`, `roller_i_applikasjonstak`, `samlingstak_i_mine_les_organisasjoner`).
  - **Mitigation**: Kryssreferanse i `COMMENT` på alle tre. Pga. CLAUDE.md («a relation is already a function») er funksjonen begrunnet som en SECURITY DEFINER-inngang.
- **Risk**: Sikkerhet. Gulvet gir alle brukere roller, og nå kan hvem som helst med APPLIKASJONSADMINISTRATOR hos eier og rad skrive det.
  - **Mitigation**: Det er beslutningen. Kryssorganisatorisk krever samtykke fra begge. I5 holder production og test adskilt. I4 (TS204) stopper syntetiske apper i ekte miljø. Mutasjonsbeskrivelsen sier konsekvensen eksplisitt. Skriving i `test` speiles ikke til `local` (varselet står).
- **Risk**: Eksisterende gulvrader med tilganger, ikke forretningsroller (analysens funn 10, ikke verifisert).
  - **Mitigation**: Ingen serverendring (beslutning 1). Klienten viser dem.

### Testing Requirements

- pgTAP:
  - 01 (inventar)
  - 12 (snudd)
  - 112 (gulvforvaltning, I2, I4, effekt)
  - 113 (samlingstak per organisasjon, I2)
  - 94 (fra !6238)
  - hele suiten grønn, inkludert 34
- IT:
  - `GulvGraphqlTest` (lesing T3, forvaltning T4, inkludert alias-batch for delvis suksess og effekten ved innlogging)
  - `DelegeringstakGraphqlTest` utvidet (T6)
- Negativ kontroll i T2 og T5: uten changesetet feiler de nye pgTAP-testene. Noter i MR-teksten hvilke.
- Composition og supergraf-sjekk for T3, T4 og T6.

## Success Criteria

- [ ] All acceptance criteria met
- [ ] All tests passing (pgTAP, tilgangsstyring-service, tilgangsstyring-app)
- [ ] Code follows project conventions (`tilgangsstyring/CLAUDE.md`: én policy per operasjon, regelen ett sted, additivt, numre sjekket mot åpne MR-er, `syntetiske-og-ekte-data.md` oppdatert i samme MR som håndhevingen)
- [ ] All must-have requirements addressed (`@BRU-APP-API-018` og `@BRU-APP-API-019` er begge `@must`)
- [ ] Ingen gjenværende «eget privilegium» om gulvet i gjeldende `COMMENT`-er eller docs
- [ ] Kontrakten for fs-admin er publisert sammen med planen

## Requirements Traceability

| Requirement ID | Requirement Summary | Addressed by Task(s) | Status |
| --- | --- | --- | --- |
| BRU-APP-API-018 / 019 | Fane bare for Feide-applikasjoner | – (FK/CHECK mot `feide_applikasjon`, feltet ligger på `FeideApplikasjon`). Fanen i fs-admin | Dekket |
| BRU-APP-API-018 | Alle som kan se appen ser taket. Listen viser det som gjelder nå, med gyldighetstidsrom | Finnes for direkte. T1 (I2), T6 | Planned |
| BRU-APP-API-019 | Alle som kan se appen ser gulvet. Det som gjelder nå, med gyldighetstidsrom | T3 | Planned |
| BRU-APP-API-018 | Samlingstak vises per organisasjon, med kilde | T5, T6 | Planned |
| BRU-APP-API-018 | Samlingstak kan ikke fjernes eller velges, og regnes som allerede i taket | T6 (`tilknytning`). Klienten. Spørsmål 2 | Planned |
| BRU-APP-API-018 | Tildele og fjerne én eller flere i taket, delvis suksess | Finnes (alias-batch i klienten) | Dekket |
| BRU-APP-API-019 | Tildele og fjerne én eller flere i gulvet, delvis suksess | T2, T4 | Planned |
| BRU-APP-API-018 / 019 | Bare forretningsroller | Klienten (beslutning 1) | Utenfor fs-plattform |
| BRU-APP-API-018 | Forvaltning krever rollen hos eier og radens organisasjon, i samme miljø | Finnes (`kan_forvalte_delegering`) | Dekket |
| BRU-APP-API-019 | Samme for gulvet | T2, T4 | Planned |
| BRU-APP-API-018 / 019 | Valglister for organisasjon og miljø begrenset | Klienten via `mineTilganger` (beslutning 3) | Utenfor fs-plattform |
| BRU-APP-API-018 / 019 | En rolle som alt er i taket eller gulvet kan ikke velges | Klienten, ut fra listene (T3, T6) | Planned |
| BRU-APP-API-018 | Effekten av taket | Finnes (pgTAP 20/37/70) | Dekket |
| BRU-APP-API-019 | Effekten av gulvet | Finnes. Regresjon i T2 (112) og T4 | Planned |
| BRU-APP-API-018 / 019 | Syntetisk og ekte som for personbrukere | T1 (I2 tak), T2 (I2 i `_endre/_slett`, I4), T5 (I2 i funksjonen) | Planned |

## Åpne spørsmål (til Kjetil)

1. **!6238:** merge som den er først (T1), eller lukke den og ta 0109-innholdet inn i T5?
2. **Fjerne en rolle som bare kommer fra en samling:** fortsatt stille suksess, eller en ny `SamlingstakKanIkkeFjernes`-feil som `SamlingstildelingKanIkkeFjernes` (0107)?
3. **Samlingstak i grafen:** flytte `Brukerdelegering` til union-viewet (A, anbefalt), eller et nytt felt `delegeringstak` ved siden av (A′)?
4. **Symmetri for I2:** skal tak-`_endre/_slett` også få I2 eksplisitt i USING, som gulvet? Det er redundant i dag, men gir samme form på begge tabellene.

## Cross-contributor

- **fs-admin (frontend):**
  - Behov: fanene for tak og gulv, dialogene, gating via `mineTilganger`, forretningsrollefilter, alias-batch.
  - Hvorfor det blokkerer: taket med direkte rader kan bygges nå. Samlingsrader trenger T6, og hele gulvet trenger T3 og T4.
- **Krav og design (sikt-no/fs#914):**
  - Behov: åpne designspørsmål om fanenavn, visning av kilde og advarsel for gulvet.
  - Hvorfor det blokkerer: ikke for fs-plattform, bare for teksten i fs-admin.
- **Review:** alfle er reviewer på !6238 og bør ta T2/T5 for kontinuitet.