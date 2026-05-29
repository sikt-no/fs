# Plan: Applikasjoner GraphQL surface — backend ingest

Companion to `analysis-applikasjoner.md` in this folder. Translates the seven design decisions there into an implementation work-breakdown for landing the applikasjon-tilgangsstyring surface in the `tilgangsstyring/` module.

## Proposed Solution

### Architecture Approach

Land the surface inside the existing `tilgangsstyring/` module as a new schema-fil (no new module needed). The work follows the codebase's specification-first pipeline (`CLAUDE.md:134-151`) in this order:

1. **DB extensions** — close the per-column gaps documented in the analysis (`status`, `endretTidspunkt` nullability, `tilgangsstyring.organisasjon.navn` if missing) and add a unifying SQL view `tilgangsstyring.applikasjon_v` that UNIONs `feide_applikasjon` / `maskinporten_applikasjon` / `maskinbruker_applikasjon` into a single relation with a unified `ekstern_id` expression.
2. **jOOQ regeneration** — `tilgangsstyring-new-jooq` picks up the new view + columns.
3. **Schema file** — drop a new `schema_applikasjoner.graphqls` next to `schema_prod.graphqls`. Federation v2.4 is already imported in `schema_prod.graphqls:1-5`; the new file extends `Query` and `Mutation` and defines the applikasjoner-specific types.
4. **Graphitron resolves** — `@table`, `@field`, `@asConnection`, `@node`, `@key`, `@error` directives wire most of the surface. The schema sketch in this plan's `## GraphQL-endringer` is the source of truth for which directive lands where.
5. **Services for non-declarative behaviour** — three new service classes in `tilgangsstyring-service`:
   - `ApplikasjonService` — opprett/redigerBeskrivelse/deaktiver/reaktiver, tildel/fjernTilganger, set/fjernAnsvarlig.
   - `AnsvarligKandidatService` — hybrid cache + Feide-API fallback (decision § "ansvarligKandidater: hybrid").
   - `MaskinportenHemmelighetsService` — Maskinporten Admin API client for `byttApplikasjonPassord` (decision § "byttApplikasjonPassord: Maskinporten-only").
   - `KanFlagsResolver` — Java resolver for the six `kanX` permission flags on `Applikasjon` (decision § "kanX flags: Java resolver").
6. **Tests** — service-layer unit tests + Graphitron approval-tests for the schema (mirroring the `QueryFilesApprovalIT` pattern in `sis/`).

### Key Technical Decisions

All seven design decisions are recorded with full rationale in `analysis-applikasjoner.md` § Decisions. Summarised here so the plan is self-contained:

1. **Connection types: `@asConnection`, not hand-written.** Graphitron emits `nodes`, `edges { cursor node }`, `pageInfo`, `totalCount` — verified against production query files. Hand-written wrappers in the mock SDL get deleted.
   - Why: 66:0 convention in the repo; `PageInfo` already declared `@shareable` in `schema_prod.graphqls:17`.
   - Alternative considered: keep hand-written for mock-parity — rejected because the mock is explicitly transitional.

2. **`IdentitetsleverandorType` enum value: `MASKINBRUKER`, not `FS`.**
   - Why: the storage table is `tilgangsstyring.maskinbruker_applikasjon` and `subjekt_type = 'maskinbruker_applikasjon'`. Display label "FS-bruker" belongs in the frontend.

3. **Federate `Organisasjon`, keep `ApplikasjonPerson` trimmed for audit attribution.**
   - Why: org is a real entity (`@key(fields: "id")` lets other subgraphs extend); audit attribution is denormalized display metadata.

4. **`Applikasjon` and `ApplikasjonTilgang` are full federation entities.** `implements Node @node(typeId: …) @key(fields: "id") @table(name: …)`.
   - Why: matches `Kontaktperson` template at `schema_prod.graphqls:13`. `@asConnection` + `@key` compose (line 9 + 13).

5. **`kanX` flags computed in Java via `KanFlagsResolver`.** Each flag is `@externalField`, resolver reads `AuthenticatedContextProvider.orgtilganger` and applies type-specific rules in-process.
   - Why: tight iteration on the rule set; no DB schema churn per flag change. N+1 risk mitigated by in-memory computation (no per-field DB call).

6. **`byttApplikasjonPassord` is Maskinporten-only.** `PassordService` is **not** in the path — the new mutation rotates Maskinporten client_secret via Maskinporten Admin API.
   - Why: per user clarification — "passord" in this UX means Maskinporten client_secret, not a bcrypt hash.

7. **`ansvarligKandidater` is hybrid.** Local `feide_bruker` / `feide_gruppe` cache first; on miss, call Feide/Dataporten via existing `FeideClient` and upsert before returning.
   - Why: the FK from `*_applikasjon.ansvarlig_subjekt_id` to `tilgangsstyring.subjekt` is load-bearing — a returned candidate must have a row by the time assignment commits.

Plus these plan-level resolutions of the open DDL gaps surfaced in the analysis:

8. **`status` is derived from `deaktivert_tidspunkt TIMESTAMPTZ`** added to all three applikasjon tables. Null = AKTIV, non-null = INAKTIV. Preserves "when was this deactivated" without a join. Matches the temporal pattern already used in `subjektrolletildeling.gyldig_periode`.

9. **`miljoer: [Miljo!]!` is derived** from `SELECT DISTINCT miljokode FROM subjektrolletildeling WHERE subjekt_id = … AND upper(gyldig_periode) = 'infinity'`. No new link table — the existing tilgang model already carries miljø per granted role.

10. **`sistBrukt: String` ships as `null` initially.** No event source exists yet; the field is declared in the schema for forward-compatibility but the resolver returns null until product/auth-team clarifies the source. Tracked as a follow-up.

11. **`endretTidspunkt: String` (nullable).** Mock SDL relaxes from `String!` to `String` to match the DB column (`endret_tidspunkt` is null until first edit). Cross-agent confirmation with fs-admin needed (see hand-off candidates at end of plan).

12. **`eksternId` unified via SQL view `tilgangsstyring.applikasjon_v`** that UNIONs the three subtype tables with `ekstern_id = COALESCE(service_id, client_id, brukernavn)`. Graphitron binds `Applikasjon @table(name: "applikasjon_v")`. Avoids three `@field` overrides on a polymorphic GraphQL type.

13. **`iso6523_actorid_upis` stays absent from the mock surface** unless fs-admin requests it. Flagged as a cross-agent question.

### File Changes Overview

- **`tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/`**:
  - new `0011-add-deaktivert-tidspunkt.sql` — adds `deaktivert_tidspunkt TIMESTAMPTZ` to all three applikasjon tables.
  - new `0012-create-applikasjon-view.sql` — `CREATE VIEW tilgangsstyring.applikasjon_v` UNIONing the three subtype tables.
  - update `db-changelog-root.xml` — include the two new changesets.
- **`tilgangsstyring/tilgangsstyring-new-jooq/`** — no source changes; codegen re-runs and produces records for the view + new column.
- **`tilgangsstyring/tilgangsstyring-app/src/main/resources/schema/`**:
  - new `schema_applikasjoner.graphqls` — the schema sketched in `## GraphQL-endringer` below.
  - existing `schema_prod.graphqls` — no changes (federation `@link` already imports the needed directives; `PageInfo` already `@shareable`).
- **`tilgangsstyring/tilgangsstyring-service/src/main/java/no/sikt/fs/tilgangsstyring_service/`**:
  - new `ApplikasjonService.java` — write-mutation orchestration.
  - new `AnsvarligKandidatService.java` — hybrid cache + Feide fallback.
  - new `MaskinportenHemmelighetsService.java` — Maskinporten Admin API client.
  - new `KanFlagsResolver.java` — `@externalField` resolver for the six `kanX` flags.
  - new `record/` POJOs for mutation input/payload records (Graphitron `@record` binding).
- **`docs/ingest/applikasjoner.graphql`** — update source-of-truth SDL to match the producer-side conventions: switch enum value `FS` → `MASKINBRUKER`, replace hand-written `*Connection` types with `@asConnection` on the list-returning fields, relax `endretTidspunkt: String!` → `String`. This is a frontend-facing change and requires fs-admin alignment (see hand-off candidates).

## GraphQL-endringer

Drop-in `schema_applikasjoner.graphqls` for `tilgangsstyring/tilgangsstyring-app/src/main/resources/schema/`. Citations into existing call sites prove each directive choice has precedent.

### Queries — extend root Query

```graphql
extend type Query {
  """Listing av applikasjoner. Cursor-paginert via @asConnection (genererer
  ApplikasjonerConnection, ApplikasjonerEdge, totalCount, nodes, pageInfo)."""
  applikasjoner(
    filter: ApplikasjonerFilterInput
    orderBy: ApplikasjonerOrderBy
  ): [Applikasjon] @asConnection

  applikasjon(id: ID! @nodeId(typeName: "Applikasjon")): Applikasjon
    @reference(path: [{table: "applikasjon_v"}])

  """Søk etter Feide-bruker- og gruppe-kandidater scopet til en
  organisasjon. Cache-first med Feide/Dataporten fallback ved miss."""
  ansvarligKandidater(
    organisasjonsId: ID! @nodeId(typeName: "Organisasjon")
    query: String!
    includeFeideGrupper: Boolean = false
    first: Int = 20
  ): [Ansvarlig!]
    @service(service: {className: "no.sikt.fs.tilgangsstyring_service.AnsvarligKandidatService", method: "soekKandidater"})

  """Hvilke roller kan tildeles applikasjonen i gitt org/miljø, og hvilke er allerede tildelt."""
  tildelbareApplikasjonTilganger(
    applikasjonsId: ID! @nodeId(typeName: "Applikasjon")
    miljo: Miljo!
    organisasjonsId: ID! @nodeId(typeName: "Organisasjon")
  ): [TildelbarApplikasjonTilgang!]!
    @service(service: {className: "no.sikt.fs.tilgangsstyring_service.ApplikasjonService", method: "hentTildelbareTilganger"})
}
```

**Implementeres av:** Task #5 (schema) for the SDL, Task #7 (services) for `ansvarligKandidater`/`tildelbareApplikasjonTilganger`. `applikasjoner` and `applikasjon` are pure Graphitron — no Java needed beyond `KanFlagsResolver`.

### Mutations — extend root Mutation

```graphql
extend type Mutation {
  opprettApplikasjon(input: OpprettApplikasjonInput!): OpprettApplikasjonPayload!
    @service(service: {className: "no.sikt.fs.tilgangsstyring_service.ApplikasjonService", method: "opprettApplikasjon"})

  byttApplikasjonPassord(input: ByttApplikasjonPassordInput!): ByttApplikasjonPassordPayload!
    @service(service: {className: "no.sikt.fs.tilgangsstyring_service.MaskinportenHemmelighetsService", method: "roterHemmelighet"})

  settApplikasjonAnsvarlig(input: SettApplikasjonAnsvarligInput!): SettApplikasjonAnsvarligPayload!
    @service(service: {className: "no.sikt.fs.tilgangsstyring_service.ApplikasjonService", method: "settAnsvarlig"})

  fjernApplikasjonAnsvarlig(input: FjernApplikasjonAnsvarligInput!): FjernApplikasjonAnsvarligPayload!
    @service(service: {className: "no.sikt.fs.tilgangsstyring_service.ApplikasjonService", method: "fjernAnsvarlig"})

  redigerApplikasjonBeskrivelse(input: RedigerApplikasjonBeskrivelseInput!): RedigerApplikasjonBeskrivelsePayload!
    @service(service: {className: "no.sikt.fs.tilgangsstyring_service.ApplikasjonService", method: "redigerBeskrivelse"})

  tildelApplikasjonTilganger(input: TildelApplikasjonTilgangerInput!): TildelApplikasjonTilgangerPayload!
    @service(service: {className: "no.sikt.fs.tilgangsstyring_service.ApplikasjonService", method: "tildelTilganger"})

  fjernApplikasjonTilganger(input: FjernApplikasjonTilgangerInput!): FjernApplikasjonTilgangerPayload!
    @service(service: {className: "no.sikt.fs.tilgangsstyring_service.ApplikasjonService", method: "fjernTilganger"})

  deaktiverApplikasjon(input: DeaktiverApplikasjonInput!): DeaktiverApplikasjonPayload!
    @service(service: {className: "no.sikt.fs.tilgangsstyring_service.ApplikasjonService", method: "deaktiver"})

  reaktiverApplikasjon(input: ReaktiverApplikasjonInput!): ReaktiverApplikasjonPayload!
    @service(service: {className: "no.sikt.fs.tilgangsstyring_service.ApplikasjonService", method: "reaktiver"})
}
```

**Implementeres av:** Task #5 (SDL), Task #7 (`ApplikasjonService`), Task #8 (`MaskinportenHemmelighetsService`).

### Enums

```graphql
enum ApplikasjonStatus { AKTIV INAKTIV }

enum IdentitetsleverandorType { FEIDE MASKINPORTEN MASKINBRUKER }   # MASKINBRUKER per decision §2

enum Miljo { PRODUKSJON DEMO TEST UTVIKLING }                       # maps to tilgangsstyring.miljo.miljokode

enum ApplikasjonerOrderByField { NAVN ORGANISASJON STATUS SIST_BRUKT }

enum ApplikasjonTilgangerOrderByField { MILJO TILGANGSKODE }

enum AnsvarligType { FEIDE_BRUKER FEIDE_GRUPPE }
```

**Note:** `OrderDirection` is provided by the upstream supergraph schema (per the mock SDL comment at line 106).

### Domain types

```graphql
"""Organisasjon — federation entity. tilgangsstyring binder den lokalt mot
tilgangsstyring.organisasjon; andre subgraphs kan extende uten å redeklarere."""
type Organisasjon implements Node @table(name: "organisasjon") @node(typeId: "20011", keyColumns: ["organisasjonskode"]) @key(fields: "id") {
  id: ID! @nodeId
  organisasjonskode: Int @field(name: "organisasjonskode")
  # "navn" er en åpen variabel — den nye tilgangsstyring.organisasjon-tabellen har ingen
  # navnekolonne ennå. Enten utvides DDL'en, eller resolveren tar navn fra en annen
  # navnekilde (KDTO, UH-org-registeret). Tracked som follow-up i Task #1.
  navn: String @field(name: "navn")
}

"""Audit-attribusjon — trimmet shape, ikke føderert (decision §3)."""
type ApplikasjonPerson {
  id: ID!
  navn: String!
}

type FeideBruker implements Node @table(name: "feide_bruker") @node(typeId: "20012", keyColumns: ["subjekt_id"]) @key(fields: "id") {
  id: ID! @nodeId
  visningsnavn: String @field(name: "visningsnavn")  # TBD: column ikke ennå på feide_bruker — Task #1 vurderer å legge til, eller hente fra Feide on-demand
  feideId: String! @field(name: "feide_id")
  organisasjon: Organisasjon @reference(path: [{condition: {className: "no.sikt.fs.tilgangsstyring_service.conditions.FeideBrukerOrganisasjonCondition", method: "fraFeideId"}}])
}

type FeideGruppe implements Node @table(name: "feide_gruppe") @node(typeId: "20013", keyColumns: ["subjekt_id"]) @key(fields: "id") {
  id: ID! @nodeId
  visningsnavn: String! @field(name: "navn")
  feideGruppeId: String! @field(name: "feide_id")
  organisasjon: Organisasjon # resolved via feide_id realm — like FeideBruker
}

union Ansvarlig = FeideBruker | FeideGruppe

"""Applikasjon — føderert entitet, bundet mot view applikasjon_v som
UNIONer feide_applikasjon / maskinporten_applikasjon / maskinbruker_applikasjon."""
type Applikasjon implements Node @table(name: "applikasjon_v") @node(typeId: "20014", keyColumns: ["subjekt_id"]) @key(fields: "id") {
  id: ID! @nodeId
  navn: String!
  beskrivelse: String
  organisasjon: Organisasjon @reference(path: [{table: "organisasjon"}])
  identitetsleverandor: IdentitetsleverandorType! @field(name: "subjekt_type")  # mapping: feide_applikasjon→FEIDE, maskinporten_applikasjon→MASKINPORTEN, maskinbruker_applikasjon→MASKINBRUKER
  eksternId: String! @field(name: "ekstern_id")
  status: ApplikasjonStatus! @field(name: "status")  # view-derived: deaktivert_tidspunkt IS NULL → AKTIV
  ansvarlig: Ansvarlig  # union resolved via ansvarlig_type
  miljoer: [Miljo!]!
    @service(service: {className: "no.sikt.fs.tilgangsstyring_service.ApplikasjonService", method: "miljoerForApplikasjon"})
    # SELECT DISTINCT miljokode FROM subjektrolletildeling WHERE subjekt_id = $1 AND upper(gyldig_periode) = 'infinity'
  opprettetAv: ApplikasjonPerson  # joins via opprettet_av FK to subjekt → subtype.visningsnavn
  opprettetTidspunkt: String! @field(name: "opprettet_tidspunkt")
  endretAv: ApplikasjonPerson
  endretTidspunkt: String @field(name: "endret_tidspunkt")   # NULLABLE — relaxed from mock String!, see decision §11
  sistBrukt: String  # always null until event source defined, see decision §10

  # Per-app permission flags — Java resolver, evaluated per-request from
  # AuthenticatedContextProvider. See KanFlagsResolver.
  kanEndrePassord: Boolean!
    @externalField @service(service: {className: "no.sikt.fs.tilgangsstyring_service.KanFlagsResolver", method: "kanEndrePassord"})
  kanAdministrereAnsvarlig: Boolean!
    @externalField @service(service: {className: "no.sikt.fs.tilgangsstyring_service.KanFlagsResolver", method: "kanAdministrereAnsvarlig"})
  kanRedigereBeskrivelse: Boolean!
    @externalField @service(service: {className: "no.sikt.fs.tilgangsstyring_service.KanFlagsResolver", method: "kanRedigereBeskrivelse"})
  kanTildeleTilganger: Boolean!
    @externalField @service(service: {className: "no.sikt.fs.tilgangsstyring_service.KanFlagsResolver", method: "kanTildeleTilganger"})
  kanFjerneTilganger: Boolean!
    @externalField @service(service: {className: "no.sikt.fs.tilgangsstyring_service.KanFlagsResolver", method: "kanFjerneTilganger"})
  kanDeaktivere: Boolean!
    @externalField @service(service: {className: "no.sikt.fs.tilgangsstyring_service.KanFlagsResolver", method: "kanDeaktivere"})

  tilganger(
    filter: ApplikasjonTilgangerFilterInput
    orderBy: ApplikasjonTilgangerOrderBy
  ): [ApplikasjonTilgang] @asConnection @splitQuery
    @reference(path: [{table: "subjektrolletildeling", condition: {className: "no.sikt.fs.tilgangsstyring_service.conditions.ApplikasjonTilgangerCondition", method: "aktiveTildelinger"}}])
}

"""Aktiv subjektrolletildeling for en applikasjon."""
type ApplikasjonTilgang implements Node @table(name: "subjektrolletildeling") @node(typeId: "20015", keyColumns: ["subjekt_id", "rollekode", "organisasjonskode", "miljokode"]) @key(fields: "id") {
  id: ID! @nodeId
  tilgangskode: String! @field(name: "rollekode")
  tilgangsbeskrivelse: String! @reference(path: [{table: "rolle"}])
    # → tilgangsstyring.rolle.beskrivelse, joined via rollekode
  miljo: Miljo! @field(name: "miljokode")
  organisasjon: Organisasjon @reference(path: [{table: "organisasjon"}])
  tildeltAv: ApplikasjonPerson  # → opprettet_av
  tildeltTidspunkt: String! @field(name: "opprettet_tidspunkt")
}

type TildelbarApplikasjonTilgang @record(record: {className: "no.sikt.fs.tilgangsstyring_service.record.TildelbarApplikasjonTilgangRecord"}) {
  tilgangskode: String!
  tilgangsbeskrivelse: String!
  alleredeTildelt: Boolean!
}
```

**Implementeres av:** Task #5 (schema), Task #7 (`ApplikasjonService.miljoerForApplikasjon`, `hentTildelbareTilganger`), Task #10 (`KanFlagsResolver`), Task #11 (filter/condition classes for `tilganger`).

### Inputs

```graphql
input ApplikasjonerFilterInput {
  navnContains: String @field(name: "NAVN")  # ILIKE — exact directive TBD per Graphitron filter conventions
  organisasjonsIder: [ID!] @field(name: "organisasjonskode") @nodeId(typeName: "Organisasjon")
  status: [ApplikasjonStatus!] @field(name: "status")
  tilgangskoder: [String!]  # joins through subjektrolletildeling — needs @reference or condition
}

input ApplikasjonerOrderBy {
  direction: OrderDirection!
  orderByField: ApplikasjonerOrderByField!
}

input ApplikasjonTilgangerFilterInput {
  miljoer: [Miljo!] @field(name: "miljokode")
  tilgangskoder: [String!] @field(name: "rollekode")
}

input ApplikasjonTilgangerOrderBy {
  direction: OrderDirection!
  orderByField: ApplikasjonTilgangerOrderByField!
}

input OpprettApplikasjonInput @record(record: {className: "no.sikt.fs.tilgangsstyring_service.record.OpprettApplikasjonInputRecord"}) {
  identitetsleverandor: IdentitetsleverandorType!
  eksternId: String!
  organisasjonsId: ID! @nodeId(typeName: "Organisasjon")
}

input ByttApplikasjonPassordInput @record(record: {className: "no.sikt.fs.tilgangsstyring_service.record.ByttApplikasjonPassordInputRecord"}) {
  applikasjonsId: ID! @nodeId(typeName: "Applikasjon")
}

input SettApplikasjonAnsvarligInput @record(record: {className: "no.sikt.fs.tilgangsstyring_service.record.SettApplikasjonAnsvarligInputRecord"}) {
  applikasjonsId: ID! @nodeId(typeName: "Applikasjon")
  ansvarligId: ID!
  ansvarligType: AnsvarligType!
}

input FjernApplikasjonAnsvarligInput @record(record: {className: "no.sikt.fs.tilgangsstyring_service.record.FjernApplikasjonAnsvarligInputRecord"}) {
  applikasjonsId: ID! @nodeId(typeName: "Applikasjon")
}

input RedigerApplikasjonBeskrivelseInput @record(record: {className: "no.sikt.fs.tilgangsstyring_service.record.RedigerApplikasjonBeskrivelseInputRecord"}) {
  applikasjonsId: ID! @nodeId(typeName: "Applikasjon")
  beskrivelse: String!
}

input TildelApplikasjonTilgangerInput @record(record: {className: "no.sikt.fs.tilgangsstyring_service.record.TildelApplikasjonTilgangerInputRecord"}) {
  applikasjonsId: ID! @nodeId(typeName: "Applikasjon")
  miljo: Miljo!
  organisasjonsId: ID! @nodeId(typeName: "Organisasjon")
  tilgangskoder: [String!]!
}

input FjernApplikasjonTilgangerInput @record(record: {className: "no.sikt.fs.tilgangsstyring_service.record.FjernApplikasjonTilgangerInputRecord"}) {
  applikasjonsId: ID! @nodeId(typeName: "Applikasjon")
  miljo: Miljo!
  tilgangIds: [ID!]!
}

input DeaktiverApplikasjonInput @record(record: {className: "no.sikt.fs.tilgangsstyring_service.record.DeaktiverApplikasjonInputRecord"}) {
  applikasjonsId: ID! @nodeId(typeName: "Applikasjon")
}

input ReaktiverApplikasjonInput @record(record: {className: "no.sikt.fs.tilgangsstyring_service.record.ReaktiverApplikasjonInputRecord"}) {
  applikasjonsId: ID! @nodeId(typeName: "Applikasjon")
}
```

### Error envelope

```graphql
interface Error {
  message: String!
  path: [String!]!
}

type IdentitetsleverandorIdIkkeFunnet implements Error @record(record: {className: "no.sikt.fs.tilgangsstyring_service.record.error.IdentitetsleverandorIdIkkeFunnetRecord"}) {
  message: String!
  path: [String!]!
  identitetsleverandor: IdentitetsleverandorType!
}

type IdentitetsleverandorIdAlleredeIBruk implements Error @record(record: {className: "no.sikt.fs.tilgangsstyring_service.record.error.IdentitetsleverandorIdAlleredeIBrukRecord"}) {
  message: String!
  path: [String!]!
  eksisterendeApplikasjon: Applikasjon
}

type VisningsnavnAlleredeIBruk implements Error @record(record: {className: "no.sikt.fs.tilgangsstyring_service.record.error.VisningsnavnAlleredeIBrukRecord"}) {
  message: String!
  path: [String!]!
  visningsnavn: String!
}

type UgyldigInput implements Error @record(record: {className: "no.sikt.fs.tilgangsstyring_service.record.error.UgyldigInputRecord"}) {
  message: String!
  path: [String!]!
}

type IngenRettighetTilApplikasjon implements Error @record(record: {className: "no.sikt.fs.tilgangsstyring_service.record.error.IngenRettighetTilApplikasjonRecord"}) {
  message: String!
  path: [String!]!
  applikasjonsId: ID!
}

type AnsvarligIkkeIApplikasjonsOrganisasjon implements Error @record(record: {className: "no.sikt.fs.tilgangsstyring_service.record.error.AnsvarligIkkeIApplikasjonsOrganisasjonRecord"}) {
  message: String!
  path: [String!]!
  applikasjonsId: ID!
  ansvarligId: ID!
  applikasjonsOrganisasjonsId: ID!
}

type TilgangAlleredeTildelt implements Error @record(record: {className: "no.sikt.fs.tilgangsstyring_service.record.error.TilgangAlleredeTildeltRecord"}) {
  message: String!
  path: [String!]!
  applikasjonsId: ID!
  miljo: Miljo!
  tilgangskode: String!
}

# New error variant for the Maskinporten-only password mutation
# (See decision §6 "byttApplikasjonPassord: Maskinporten-only")
type PassordIkkeStottetForIdentitetsleverandor implements Error @record(record: {className: "no.sikt.fs.tilgangsstyring_service.record.error.PassordIkkeStottetForIdentitetsleverandorRecord"}) {
  message: String!
  path: [String!]!
  applikasjonsId: ID!
  identitetsleverandor: IdentitetsleverandorType!
}
```

### Mutation payloads

```graphql
type OpprettApplikasjonPayload @record(record: {className: "no.sikt.fs.tilgangsstyring_service.record.OpprettApplikasjonPayloadRecord"}) {
  applikasjon: Applikasjon
  errors: [Error!]
}

type ByttApplikasjonPassordPayload @record(record: {className: "no.sikt.fs.tilgangsstyring_service.record.ByttApplikasjonPassordPayloadRecord"}) {
  applikasjon: Applikasjon
  generertPassord: String  # the new Maskinporten client_secret, returned exactly once
  errors: [Error!]
}

# … remaining payloads identical to mock SDL; one record-class per payload.
```

### Open questions raised by this section

- **`Organisasjon.navn` source.** `tilgangsstyring.organisasjon` doesn't currently have a `navn` column — only `organisasjonskode`. Either (a) extend the DDL, (b) resolve via cross-subgraph reference into the canonical org type, or (c) leave `navn` nullable and resolve from a third source (e.g. UH-org-registeret). **Tracked as Task #1 follow-up.**
- **`FeideBruker.visningsnavn` source.** Column doesn't exist on `tilgangsstyring.feide_bruker` (which only has `feide_id`). Either add a column (denormalized at upsert time from Feide Userinfo) or resolve on-demand from `FeideClient` (N+1 risk). **Tracked as Task #7 design note.**
- **`@asConnection` + `@key` interaction with a view-backed entity.** All surveyed `@asConnection` + `@key` sites bind to base tables, not views. Spike during Task #3 (jOOQ regeneration) and Task #5 (schema) to verify Graphitron handles the polymorphic-view binding correctly. If not, fall back to `@splitQuery` over the three base tables.

## Implementation Tasks

Tasks are ordered by dependency. Each task is atomic and testable.

### Task #1: DDL extensions — `deaktivert_tidspunkt` + `Organisasjon.navn` decision

**Priority**: High
**Size**: M
**Dependencies**: None
**Addresses Decisions**: §8 (`status` derivation), open question §13 (`Organisasjon.navn` source)

**Acceptance Criteria**:
- [ ] New changeset `0011-add-deaktivert-tidspunkt.sql` adds `deaktivert_tidspunkt TIMESTAMPTZ NULL` to `feide_applikasjon`, `maskinporten_applikasjon`, and `maskinbruker_applikasjon`.
- [ ] Column has a comment explaining the AKTIV/INAKTIV derivation.
- [ ] Changeset registered in `db-changelog-root.xml`.
- [ ] **Decision recorded** on `Organisasjon.navn`: either add `navn TEXT` column (and source-of-truth process) or document the cross-subgraph/external resolution path. If column added, ship in the same changeset.
- [ ] `mise run oracle` then `mvn liquibase:update` succeeds locally.

**Implementation Notes**:
- Mirror the audit-trigger pattern from `0003-create-tilgangsstyring-tables.sql`: no triggers needed for `deaktivert_tidspunkt` itself (it's set explicitly by the deaktiver/reaktiver mutations, not by `set_endret`).
- For `Organisasjon.navn`: lowest-friction is to add the column and let `OpprettApplikasjon` / a separate sync job populate it. Recommend that path unless a strong reason exists to keep `tilgangsstyring.organisasjon` reference-data-only.

---

### Task #2: SQL view `tilgangsstyring.applikasjon_v`

**Priority**: High
**Size**: M
**Dependencies**: Task #1
**Addresses Decisions**: §12 (eksternId unification), §8 (status derivation)

**Acceptance Criteria**:
- [ ] New changeset `0012-create-applikasjon-view.sql` defines `CREATE VIEW tilgangsstyring.applikasjon_v AS …` UNIONing the three applikasjon tables.
- [ ] Output columns: `subjekt_id`, `subjekt_type`, `navn`, `beskrivelse`, `organisasjonskode`, `ekstern_id` (COALESCE of `service_id` / `client_id` / `brukernavn`), `ansvarlig_subjekt_id`, `ansvarlig_type`, `status` (`CASE WHEN deaktivert_tidspunkt IS NULL THEN 'AKTIV' ELSE 'INAKTIV' END`), `opprettet_av`, `opprettet_tidspunkt`, `endret_av`, `endret_tidspunkt`, `deaktivert_tidspunkt`.
- [ ] Grants/RLS reviewed against `0005-create-rls-policies.sql` — view inherits permissions from base tables; verify reads are allowed for the same role-set that today reads the base tables.
- [ ] Changeset registered in `db-changelog-root.xml`.

**Implementation Notes**:
- The view is read-only. INSERTs/UPDATEs in mutations target the base subtype tables directly, then read back through the view for the response.
- Verify jOOQ codegen treats the view as a queryable relation (not a base table). Should be fine — jOOQ supports views — but worth a quick smoke test.

---

### Task #3: jOOQ regeneration + smoke test

**Priority**: High
**Size**: S
**Dependencies**: Task #2

**Acceptance Criteria**:
- [ ] `mvn clean install -pl :tilgangsstyring-new-jooq -amd` produces records for `applikasjon_v` and the new `deaktivert_tidspunkt` column.
- [ ] Generated record class for `applikasjon_v` is referenceable from `tilgangsstyring-service`.
- [ ] Spike: minimal JUnit test that selects from `applikasjon_v` against the seeded `@eksempeldata` from `0003`.

**Implementation Notes**:
- If Graphitron + `@key` over a view doesn't work in Task #5, this is the natural fallback point — drop the view, use `@splitQuery` over the three base tables, regenerate.

---

### Task #4: `Organisasjon` federation entity

**Priority**: High
**Size**: S
**Dependencies**: Task #1, Task #3
**Addresses Decisions**: §3 (federate org)

**Acceptance Criteria**:
- [ ] In a new `schema_applikasjoner.graphqls`, `Organisasjon` declared as `implements Node @table(name: "organisasjon") @node(typeId: "20011", keyColumns: ["organisasjonskode"]) @key(fields: "id")`.
- [ ] Federation entity discoverable via `_entities` query.
- [ ] No typeId collisions — `20011`+ confirmed unused (current usage maxed at `20010` for `ApiTilgangForMaskinbrukerV2` per `schema_exp.graphqls:71`).

**Implementation Notes**:
- This task can land independently of the rest of the applikasjoner surface as a prerequisite. Validates the federation wiring before the bulky Task #5.

---

### Task #5: `schema_applikasjoner.graphqls` — full surface

**Priority**: High
**Size**: L
**Dependencies**: Task #3, Task #4
**Addresses Decisions**: §1, §2, §3, §4

**Acceptance Criteria**:
- [ ] File contains all queries, mutations, enums, inputs, types, errors, and payloads as sketched in `## GraphQL-endringer` above.
- [ ] Graphitron generates resolvers without errors.
- [ ] `mvn clean install` from `tilgangsstyring/` succeeds.
- [ ] Generated GraphQL schema (`schema.graphql`) contains `Applikasjon`, `ApplikasjonTilgang`, all error types, and `*Connection` types generated from `@asConnection`.
- [ ] `schema-diff.sh` shows the new operations in the composed supergraph.

**Implementation Notes**:
- Land this in chunks during code review: domain types → queries → mutations → errors. Each chunk should compile + pass schema-build.
- The `@externalField`s on `kanX` will fail at runtime until Task #10 lands; mark them with stub implementations that throw `UnsupportedOperationException` so the schema compiles.
- TypeId allocation: `Organisasjon` 20011, `FeideBruker` 20012, `FeideGruppe` 20013, `Applikasjon` 20014, `ApplikasjonTilgang` 20015.

---

### Task #6: Error-record records + payload-record records

**Priority**: Medium
**Size**: M
**Dependencies**: Task #5

**Acceptance Criteria**:
- [ ] One Java record per error type under `tilgangsstyring_service/record/error/` (e.g. `IdentitetsleverandorIdIkkeFunnetRecord`, `VisningsnavnAlleredeIBrukRecord`, …).
- [ ] One Java record per mutation payload under `tilgangsstyring_service/record/` (e.g. `OpprettApplikasjonPayloadRecord`).
- [ ] All records implement the appropriate `@record`-target POJO shape Graphitron expects.

**Implementation Notes**:
- Mirror the pattern from `GenererOgSettNyttPassordResultatRecord` (referenced from `schema_exp.graphqls:43`).
- Records are immutable; constructors take all fields positionally.

---

### Task #7: `ApplikasjonService` — opprett + lifecycle mutations

**Priority**: High
**Size**: XL — split during implementation
**Dependencies**: Task #5, Task #6
**Addresses Decisions**: §2 (idP→subtype dispatch), §3 (audit), §8 (status)

**Acceptance Criteria**:
- [ ] `ApplikasjonService.opprettApplikasjon(input, ctx)` writes to the correct subtype table per `identitetsleverandor`, returning a populated `OpprettApplikasjonPayloadRecord` (success or typed error envelope).
- [ ] `settAnsvarlig` / `fjernAnsvarlig` update `ansvarlig_subjekt_id` + `ansvarlig_type`; rejects assignment of a candidate whose org doesn't match (returns `AnsvarligIkkeIApplikasjonsOrganisasjon`).
- [ ] `redigerBeskrivelse` updates the subtype's `beskrivelse` column.
- [ ] `deaktiver` / `reaktiver` set/clear `deaktivert_tidspunkt`.
- [ ] `tildelTilganger` inserts rows into `subjektrolletildeling` (one per `tilgangskode`); rejects duplicates with `TilgangAlleredeTildelt`.
- [ ] `fjernTilganger` closes `gyldig_periode` on the named rows (does NOT delete — preserves history per `0003-create-tilgangsstyring-tables.sql:425-429`).
- [ ] `miljoerForApplikasjon(id)` returns `DISTINCT miljokode` from active rows.
- [ ] `hentTildelbareTilganger(applikasjonsId, miljo, organisasjonsId)` returns the candidate role-set with `alleredeTildelt` flag.
- [ ] Each method runs within the JWT-authenticated transaction context so audit triggers fire correctly.
- [ ] Unit tests cover happy paths + each error variant for each mutation.

**Implementation Notes**:
- Use the polymorphic discriminator (`subjekt_type`) when dispatching from `Applikasjon.id` → subtype table.
- `tildelTilganger` writes against `subjektrolletildeling` using the existing temporal pattern — open new periods, never overwrite.
- Read-back-after-write returns through `applikasjon_v` so the response payload reflects the same shape as the query.
- Reject with `IngenRettighetTilApplikasjon` when the caller's orgtilganger don't cover the applikasjon's `organisasjonskode` — mirror the RLS rule in `0005-create-rls-policies.sql:104-146`.

---

### Task #8: `MaskinportenHemmelighetsService` — Maskinporten Admin API client

**Priority**: Medium
**Size**: L
**Dependencies**: Task #6
**Addresses Decisions**: §6 (`byttApplikasjonPassord`: Maskinporten-only)

**Acceptance Criteria**:
- [ ] HTTP client wired to Maskinporten Admin API endpoint (URL + auth from properties, secret from Vault).
- [ ] `roterHemmelighet(applikasjonsId)` returns the new `client_secret` in `ByttApplikasjonPassordPayload.generertPassord`, exactly once.
- [ ] Returns `PassordIkkeStottetForIdentitetsleverandor` if the `applikasjonsId` resolves to a non-Maskinporten app.
- [ ] Returns `IngenRettighetTilApplikasjon` if the caller's orgtilganger don't cover the app.
- [ ] Maskinporten API errors (rate-limit, unknown client, network) mapped to typed error variants — name them per Maskinporten's actual failure modes.
- [ ] `generertPassord` never logged (verify in code review + structured-logger filter).
- [ ] Integration test against a Maskinporten test environment (or recorded HTTP interactions).

**Implementation Notes**:
- Out-of-band: confirm Sikt's existing Maskinporten service-token can call the Admin API for client-secret rotation, or whether a new credential needs to be provisioned. **Cross-team dependency.**
- Naming: the input contract is `applikasjonsId`, but Maskinporten knows the app by `client_id` — fetch `client_id` from `maskinporten_applikasjon` via the resolved `subjekt_id` first.

---

### Task #9: `AnsvarligKandidatService` — hybrid cache + Feide fallback

**Priority**: Medium
**Size**: L
**Dependencies**: Task #6
**Addresses Decisions**: §7 (hybrid)

**Acceptance Criteria**:
- [ ] `soekKandidater(organisasjonsId, query, includeFeideGrupper, first)` LIKE-searches `feide_bruker` (and optionally `feide_gruppe`) scoped to the organisation.
- [ ] On exact-Feide-ID-shaped input (e.g. `user@realm`), if the cache misses, falls back to `FeideClient` (see `tilgangsstyring-app/.../coprocessor/feide/FeideClient.java`), upserts the result into `feide_bruker` (or `feide_gruppe` if applicable), and includes it in the returned list.
- [ ] Returned union members are concrete `FeideBruker` / `FeideGruppe` instances with the federation `id` materialized.
- [ ] Per-request in-memory cache on the Feide-API fallback to dedupe repeated lookups of the same ID within a session.
- [ ] Unit tests for: cache-hit, cache-miss-API-hit (upserts), API-miss (returns empty), group lookup, error mapping.

**Implementation Notes**:
- The existing `FeideClient` covers UserInfo. Confirm it also covers the Groups API (mentioned in `feide_gruppe` comment in `0003-...:380-381`). If not, extend.
- GDPR: upserting users into local storage retains PII — confirm retention policy with security/compliance before shipping. Recommend a periodic prune of `feide_bruker` rows that haven't been referenced by any active applikasjon-ansvarlig FK in >12mo. **Flag as follow-up.**

---

### Task #10: `KanFlagsResolver` — six `kanX` permission flags

**Priority**: High
**Size**: M
**Dependencies**: Task #5, Task #7 (for the per-action rule definitions)
**Addresses Decisions**: §5 (Java resolver), §6 corrigendum (`kanEndrePassord` is Maskinporten-only)

**Acceptance Criteria**:
- [ ] Each of the six `kanX` fields resolved by a method on `KanFlagsResolver`.
- [ ] Resolver reads orgtilganger from request-scoped `AuthenticatedContextProvider` — no DB call per field.
- [ ] `kanEndrePassord` returns `true` **only** when `subjekt_type = 'maskinporten_applikasjon'` AND caller has the appropriate orgtilgang for the app's `organisasjonskode`.
- [ ] Parity tests assert the resolver agrees with the DB RLS-derived decision for representative (subject, applikasjon) pairs — see Risk #1.
- [ ] N+1: verified by an integration test that selects all six flags across a page of N applikasjoner and asserts only the page-fetch DB call (no per-flag queries).

**Implementation Notes**:
- Encode each flag as a small predicate over `(applikasjon: ApplikasjonRow, caller: AuthenticatedContext)`. Keep the rule set tabular for legibility — easy to add `kanRedigereStatus` later.
- Federation entity-resolution caveat: when `Applikasjon` is loaded via `_entities` from another subgraph with only the `id`, the resolver must hydrate the underlying row (type, organisasjonskode, ansvarlig) before computing flags. Either via Graphitron's reference-resolution scaffolding or a request-scoped DataLoader.

---

### Task #11: Filter / condition / ordering classes

**Priority**: Medium
**Size**: M
**Dependencies**: Task #5

**Acceptance Criteria**:
- [ ] `ApplikasjonTilgangerCondition.aktiveTildelinger` — filters `subjektrolletildeling` to rows where `upper(gyldig_periode) = 'infinity'`.
- [ ] `FeideBrukerOrganisasjonCondition.fraFeideId` — resolves an `Organisasjon` from a `FeideBruker.feide_id`'s realm via `organisasjon_domene`.
- [ ] OrderBy mappings: `NAVN`, `ORGANISASJON`, `STATUS`, `SIST_BRUKT` for `Applikasjon`; `MILJO`, `TILGANGSKODE` for `ApplikasjonTilgang`.
- [ ] `navnContains` filter compiles to an `ILIKE %X%` predicate.

**Implementation Notes**:
- Mirror the `WSBrukerAPITilgangsRolleCondition` pattern referenced from `schema_exp.graphqls:75`.

---

### Task #12: Approval tests for the new schema

**Priority**: High
**Size**: M
**Dependencies**: Task #5, Task #7, Task #10

**Acceptance Criteria**:
- [ ] One `.graphql` query file per listing/detail/tilganger page in `tilgangsstyring-app/src/it/resources/` (or the module's equivalent).
- [ ] Approval-test suite runs them against seeded `@eksempeldata` (the three applikasjoner from `0003-create-tilgangsstyring-tables.sql:226-235`).
- [ ] Each mutation has a positive + negative-path integration test that asserts the typed error variant returned.
- [ ] `mvn verify -Psystemtest-ci` passes.

**Implementation Notes**:
- Pattern: see `sis/sis-app/src/it/resources/QueryFilesApprovalIT/queries/feilmeldingVedFeilID.graphql` and `studieprogramBeskrivelsesavsnittPaginert.graphql` for shape of approval-test query files.

---

### Task #13: Update `docs/ingest/applikasjoner.graphql` to producer conventions

**Priority**: Low (independent of backend code; depends on fs-admin sign-off)
**Size**: S
**Dependencies**: Cross-agent hand-off resolved
**Addresses Decisions**: §1 (`@asConnection`), §2 (`MASKINBRUKER`), §11 (nullable `endretTidspunkt`)

**Acceptance Criteria**:
- [ ] `IdentitetsleverandorType.FS` → `MASKINBRUKER` everywhere it appears (mock SDL + `applikasjoner.graphql.md`).
- [ ] Hand-written `ApplikasjonerConnection`, `ApplikasjonerConnectionEdge`, `ApplikasjonTilgangerConnection`, `ApplikasjonTilgangerConnectionEdge`, and `PageInfo` deleted from the mock SDL.
- [ ] `applikasjoner` and `Applikasjon.tilganger` declared with `@asConnection`.
- [ ] `endretTidspunkt: String!` → `endretTidspunkt: String`.
- [ ] Frontend's MSW fixture data still compiles against the updated mock (smoke-test only — fs-admin owns full validation).

**Implementation Notes**:
- This is a frontend-facing SDL change. Land **only** after fs-admin confirms (see hand-off candidates at end of plan).
- This task lives in the fs-plattform repo (the SDL is here), but the actual frontend integration work is on fs-admin's side.

---

## Risk Assessment

### Technical Risks

- **Risk #1: `KanFlagsResolver` drifts from DB RLS.** The Java `kanX` logic must mirror the RLS decisions in `0005-create-rls-policies.sql:104-146`. If they drift, the UI offers actions the DB rejects (or hides actions the DB would allow).
  - **Mitigation**: parity tests in Task #10 — for representative (subject, applikasjon) pairs, assert both layers return the same allow/deny. Re-run in CI on every change to either layer.

- **Risk #2: `@asConnection` + `@key` over a view (`applikasjon_v`).** All surveyed call sites bind to base tables. Graphitron may or may not generate the right code for a polymorphic view with a `@key`.
  - **Mitigation**: validate during Task #3 + early in Task #5. If broken, fall back to `@splitQuery` over the three base tables — schema-side compromise, no resolver-code change.

- **Risk #3: Maskinporten Admin API access.** Task #8 assumes Sikt has a service-token usable against the Admin API for client-secret rotation. If not, provisioning needs IT/security coordination.
  - **Mitigation**: validate prerequisite before starting Task #8. Out-of-scope of this plan to resolve, but blocking for the password mutation.

- **Risk #4: GDPR / data-minimization for hybrid `ansvarligKandidater` cache.** Upserting Feide users into local storage retains PII outside the Feide directory.
  - **Mitigation**: clarify retention policy with security before Task #9 ships. Default to a periodic prune of unreferenced rows. **Flag as a follow-up.**

- **Risk #5: Federation entity ID stability across the view.** `Applikasjon.id` derives from `subjekt_id`, which is the same across the three subtypes — fine. But if a subjekt ever changes type (e.g. an app migrates from Maskinbruker to Maskinporten), the federation `id` stays the same but the GraphQL "type" implicitly changes. Behaviour unclear.
  - **Mitigation**: declare type-migration out-of-scope for v1. Document; defer.

- **Risk #6: Per-action tilganger don't exist yet.** The six `kanX` flags imply granular role-set (`BRUKERADMIN_PASSORD_SKRIV`, `BRUKERADMIN_BESKRIVELSE_SKRIV`, …). Today the DB has one `BRUKERADMIN_WSBRUKER_SKRIV` covering all writes.
  - **Mitigation**: v1 ships with all `kanX = true` reduced to "viewer has SKRIV on this app's orgkode AND action makes sense for app type". When product introduces finer-grained tilganger, Task #10's rule table adapts in one place.

### Testing Requirements

- Unit tests for `ApplikasjonService`, `MaskinportenHemmelighetsService`, `AnsvarligKandidatService`, `KanFlagsResolver`.
- Integration tests covering each mutation's happy path + each typed error variant.
- Approval tests (Task #12) for the schema's query shapes against `@eksempeldata`.
- Parity test asserting `KanFlagsResolver` agrees with the RLS layer (Risk #1).
- N+1 verification for `kanX` (Task #10, Risk #1).

## Success Criteria

- [ ] All acceptance criteria across Tasks #1–#13 met.
- [ ] `mvn verify -Psystemtest-ci` passes.
- [ ] Composed supergraph schema (via `schema-diff.sh`) reflects all queries, mutations, and types from the schema sketch.
- [ ] All seven decisions in `analysis-applikasjoner.md` § Decisions implemented as specified.
- [ ] fs-admin sign-off on the producer-side SDL changes that land in `docs/ingest/applikasjoner.graphql` (Task #13).
- [ ] Code follows the conventions in `CLAUDE.md` (specification-first; module layout; Liquibase → jOOQ → Graphitron ordering).

## Requirements Traceability

No `requirements-*.md` document exists for this feature; acceptance criteria derive from the mock SDL contract in `docs/ingest/applikasjoner.graphql` and the seven decisions in `analysis-applikasjoner.md` § Decisions. If a follow-on `bat-krav` produces formal requirements, add a traceability matrix here.

---

## Cross-agent hand-off candidates

Surfaced to the user at the end of this turn. **Not yet filed** — agent-coord opens an issue per candidate only with explicit confirmation.

| Target agent | Ask | Why it blocks |
| --- | --- | --- |
| **fs-admin** | Approve producer-side SDL update to `docs/ingest/applikasjoner.graphql`: (a) `IdentitetsleverandorType.FS` → `MASKINBRUKER`, (b) delete hand-written `*Connection` / `PageInfo` types in favour of `@asConnection`, (c) `endretTidspunkt: String!` → `String` (nullable). | Frontend currently consumes `FS` and the hand-written connection shapes; the rename + restructure are breaking changes for any string-match or codegen-snapshot in fs-admin. Backend can ship before this lands, but the mock teardown depends on it. |
| **fs-admin** | Confirm `iso6523_actorid_upis` is intentionally absent from the `Applikasjon` shape, or specify how it should surface. | Affects whether `maskinporten_applikasjon.iso6523_actorid_upis` becomes a public field on `Applikasjon`. Default of "absent" lands without coordination, but a "should be exposed" answer means an SDL extension. |
| **fs-admin** | Confirm `tildelbareApplikasjonTilganger` returns the closed set of *applikasjon-eligible* roles (whatever that set is), or specify a different definition. | Task #7 needs a definition of "tildelbar"; today no metadata distinguishes "an applikasjon can be assigned this role" from "this role exists at all". Without input we'll default to "all roles minus a hardcoded admin-only deny-list", which is a guess. |
