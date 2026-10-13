# Analysis: GraphQL Schema Diff — Mock vs. Real Endpoints

## Problem Statement

The fs-admin frontend currently uses a mocked GraphQL schema at `src/mocks/applikasjoner/schema/applikasjoner.graphql` for development. A real working GraphQL schema is now available at `schema.graphql` in the repository. This analysis compares the two schemas to identify breaking changes, incompatibilities, and required code updates before switching from mock to real endpoints.

## Current State

### Mock Schema (`src/mocks/applikasjoner/schema/applikasjoner.graphql`)

The mock schema defines:
- **Single `Applikasjon` type** with fields:
  - `id: ID!`, `navn: String!`, `beskrivelse: String`
  - `eksternId: String!`, `internId: String!`
  - `identitetsleverandor: Identitetsleverandor!` (enum: FEIDE, MASKINPORTEN, MASKINBRUKER)
  - `organisasjon: Organisasjon` (with `id: ID!`, `navn: String!`, `organisasjonskode: String!`)
  - `status: ApplikasjonStatus!` (enum: AKTIV, DEAKTIVERT)
  - `miljoer: [Miljo!]!` (with `kode: String!`, `navn: String!`)
  - `tilganger(first, after, filter, orderBy): [ApplikasjonTilgang!]!` with pagination
  - `tilgangerMiljoer: [Miljo!]!`, `tilgangerOrganisasjoner: [Organisasjon!]!`
  - `antallTilganger: Int!`
  - `opprettetAv: Person!`, `opprettetTidspunkt: LocalDateTime!`
  - `sistEndretAv: Person`, `sistEndretTidspunkt: LocalDateTime`
  - Permission checks: `kanRedigeres`, `kanByttePassord`, `kanDeaktiveres`, `kanTildeleTilganger`, `kanFjerneTilganger` (all `Boolean!`)
- **`Person` type** with `id: ID!`, `navn: String!`
- **`ApplikasjonTilgang` type** with:
  - `id: ID!`, `tilgangskode: String!`, `beskrivelse: String`
  - `miljo: Miljo!`, `organisasjon: Organisasjon!`
  - `tilknytning: Tilknytning!` (enum: DIREKTE, ARVET)
  - `arvetFra: [ApplikasjonTilgang!]!`
  - `kanFjernes: Boolean!`

### Real Schema (`schema.graphql`)

The real schema defines:
- **`Applikasjon` interface** (implements `Node`) with common fields:
  - `id: ID!`, `navn: String`, `beskrivelse: String`
  - `eksternId: String` (no `internId`)
  - `organisasjon: TilgangsstyringOrganisasjon` (different type)
  - `miljoer: [Miljo]` (nullable)
  - `tilganger: [ApplikasjonTilgang]` (no pagination parameters)
  - `opprettetAv: FeideBruker!`, `opprettetTidspunkt: DateTime!`
  - `sistEndretAv: FeideBruker`, `sistEndretTidspunkt: DateTime`
  - **No permission check fields** (`kanRedigeres`, etc. are absent)
  - **No derived fields** (`tilgangerMiljoer`, `tilgangerOrganisasjoner`, `antallTilganger`)
- **Three concrete implementations:**
  - `FeideApplikasjon` — implements all interface fields (same as interface)
  - `MaskinbrukerApplikasjon` — implements all interface fields
  - `MaskinportenApplikasjon` — implements all interface fields + **additional field** `konsumentId: String` (ISO 6523 org ID)
- **`ApplikasjonTilgang` type** with:
  - `tilgangskode: String!`, `beskrivelse: String`
  - `miljoKode: String!` (changed from `miljo: Miljo!`)
  - `organisasjonskode: Int!` (changed from `organisasjon: Organisasjon!`)
  - **No** `id`, `tilknytning`, `arvetFra`, `kanFjernes` fields
- **Supporting types:**
  - `FeideBruker` replaces `Person` (with `feideId: String` field)
  - `Miljo` implements `Node` interface (additional capabilities)
  - `TilgangsstyringOrganisasjon` (context-specific org type for permissions)

## Key Findings

### 1. **Type Structure Difference: Single Type → Interface + Implementations**

**Finding:** The mock uses a single `Applikasjon` type with an `Identitetsleverandor` enum to distinguish application types. The real schema uses an `Applikasjon` interface with three concrete implementing types (`FeideApplikasjon`, `MaskinbrukerApplikasjon`, `MaskinportenApplikasjon`).

**Impact:**
- GraphQL queries must use inline fragments or type conditions to differentiate:
  ```graphql
  query {
    applikasjoner {
      ... on FeideApplikasjon { id name }
      ... on MaskinportenApplikasjon { id name konsumentId }
    }
  }
  ```
- Current mock-based queries using `identitetsleverandor: Identitetsleverandor!` field will break
- **Risk Level:** HIGH — requires refactoring all queries touching `Applikasjon`

### 2. **Missing Permission Check Fields**

**Finding:** The real schema does not include `kanRedigeres`, `kanByttePassord`, `kanDeaktiveres`, `kanTildeleTilganger`, `kanFjerneTilganger` fields on the `Applikasjon` type.

**Impact:**
- All current button-gating logic (e.g., `disabled={!applikasjon.kanRedigeres}`) will fail with GraphQL error
- Authorization is likely handled server-side (via role-based rules) rather than field-level in the schema
- Frontend must either:
  - Query a separate authorization endpoint
  - Infer permissions from user role + org membership
  - Implement client-side role logic based on `FeideBruker` context
- **Risk Level:** HIGH — affects all detail-page action buttons

### 3. **Missing Derived Filter-Source Fields**

**Finding:** The real schema does not include `tilgangerMiljoer: [Miljo!]!` and `tilgangerOrganisasjoner: [Organisasjon!]!` fields on `Applikasjon`.

**Impact:**
- The delta-spec (bat-specify-delta analysis) requires these fields for the tilganger-tab filter sources (see `plan-applikasjoner-visning-delta.md` § **GraphQL-endringer** § **Nye Applikasjon-felter**)
- Current mock implementation already has these; real schema must be extended before switching
- These are **planned** as part of Task #1 (mock-API updates in the coordination task)
- **Risk Level:** MEDIUM-HIGH — requires producer coordination but is already tracked in the plan

### 4. **Removed Metadata Fields**

**Finding:** Real schema removes:
- `internId: String!` — no longer exposed
- `status: ApplikasjonStatus!` (AKTIV/DEAKTIVERT enum) — no longer present
- `antallTilganger: Int!` — no longer present

**Impact:**
- Code checking `applikasjon.status` or displaying `antallTilganger` will fail
- `internId` may be used for internal tracking; confirm with backend whether it's still available via a different query
- **Risk Level:** MEDIUM — check codebase for usage of these fields

### 5. **`ApplikasjonTilgang` Structure Change**

**Finding:** The real schema simplifies `ApplikasjonTilgang`:
- Old: `miljo: Miljo!` (nested object) → New: `miljoKode: String!` (scalar)
- Old: `organisasjon: Organisasjon!` (nested object) → New: `organisasjonskode: Int!` (scalar)
- Old: has `id`, `tilknytning`, `arvetFra`, `kanFjernes` → New: removed

**Impact:**
- All table/list rendering of tilganger must change from `tilgang.miljo.navn` to a separate fetch or prop-drill
- The real schema trades nested objects for flat scalars, reducing overfetching but requiring additional context
- Filters on miljo/org cannot use nested filtering directly
- **Risk Level:** HIGH — affects the entire tilganger-tab UI

### 6. **Type Replacements**

| Mock | Real | Impact |
|------|------|--------|
| `Person` | `FeideBruker` | `opprettetAv.navn` → `opprettetAv.feideId` or similar field |
| `Organisasjon` | `TilgangsstyringOrganisasjon` | Field names/structure may differ; confirm schema |
| `LocalDateTime` | `DateTime` | Scalar type change; may affect serialization in JS |

**Risk Level:** MEDIUM — type changes are usually safe if field names align

### 7. **Pagination Differences**

**Finding:** Mock schema defines `tilganger(first, after, filter, orderBy)` as a paginated field. Real schema shows `tilganger: [ApplikasjonTilgang]` (no explicit pagination parameters).

**Impact:**
- Either pagination is implicit (handled via separate query) or the schema excerpt is incomplete
- Must confirm with producer whether a separate `applikasjonTilganger(...)` query exists or if pagination is client-side
- **Risk Level:** MEDIUM — pagination may move to a different query or use GraphQL offset-based patterns

## Technical Constraints

1. **GraphQL Codegen:** The fs-admin project uses `graphql-codegen` to generate TypeScript types from schema. Switching schemas will regenerate types and break any code relying on the old shape.
2. **Apollo Client Cache:** Current cache policies and fragment definitions are built for the mock schema. Interface-based queries may require updates to `__typename` handling.
3. **Authorization Pattern:** Permission checks currently flow from the schema (`kanRedigeres` field). The real schema delegates this to the backend—frontend must adapt.
4. **MSW Mock Interception:** Current MSW handlers match operations by name. Real endpoint will bypass MSW, so handlers must remain in place during development or be removed systematically.

## Dependencies

### Internal
- **ApplikasjonDetail page** — directly uses all `Applikasjon` fields; highest impact
- **ApplikasjonerOverview list** — filters and sorting depend on fields being present
- **ApplikasjonTilgangerTab** — depends on `tilganger` and permission fields
- **Button components** — disable logic depends on `kanX` fields

### External / Producer-Coordination
1. **Schema Extension (Coordination):** The delta-spec requires backend to add:
   - `tilgangerMiljoer: [Miljo!]!` field
   - `tilgangerOrganisasjoner: [Organisasjon!]!` field
   - Role-based visibility rules on `tilganger` field
   - (This is tracked as the "Lag A" work in `task-6-handoff-issue-draft.md`)

2. **Authorization Endpoint or Role-Based Rules:** Clarify how permission checks (`kanRedigeres`, etc.) should be implemented without schema fields.

3. **Pagination Query:** Confirm whether `tilganger` pagination is available as a separate query or requires schema changes.

## Requirements Impact

Referencing `spec-changes-2026-06-16-b0e8de5.md`:

### Requirements Addressed
- **✓** Listevisning og tilganger-tab visibility rules — supported by interface-based schema (can dispatch on `__typename`)
- **✓** Rolle-utledet filtre — filterable once backend adds `tilgangerMiljoer`/`tilgangerOrganisasjoner` fields

### Requirements at Risk
- **✗ CRITICAL:** Button-gating logic (Krav §Applikasjon-handlinger) — depends on permission fields not in real schema
- **✗ CRITICAL:** Filter sources on tilganger-tab (Krav §Tilgjengelige miljøer/organisasjoner i tilganger-filter) — depends on fields not yet in real schema
- **✗ HIGH:** Tilgang-liste display (Krav §Se tilganger for en applikasjon) — depends on `ApplikasjonTilgang` structure not matching real schema

### Missing Requirements Discovered
- **Authorization system design:** Schema does not encode permissions; frontend strategy is unclear
- **Pagination strategy:** No pagination params visible in excerpt; must confirm with producer

## Krav-input referanse

- **Spec-dokument:** [`spec-changes-2026-06-16-b0e8de5.md`](../spec/spec-changes-2026-06-16-b0e8de5.md) — delta-spec for tilganger-filter visibility and role-based filtering
- **Plan-dokument:** [`plan-applikasjoner-visning-delta.md`](plan-applikasjoner-visning-delta.md) § **GraphQL-endringer** — lists required schema additions (`mineSynligeOrganisasjoner`, `mineSynligeMiljoer` queries; `tilgangerMiljoer`/`tilgangerOrganisasjoner` fields)

## Open Questions

- [ ] **Authorization Mechanism:** Without `kanX` fields, how should permission checks be implemented? Options:
  - (a) Query a separate `applikasjonPermissions(applikasjonId)` endpoint
  - (b) Infer from user role + org membership (client-side logic)
  - (c) Assume all actions are allowed and let server reject; show error UI
  - (d) Wait for schema extension to add these fields as planned in `task-6`

- [ ] **ApplikasjonTilgang Structure:** Why does the real schema remove `id`, `tilknytning`, `arvetFra`, `kanFjernes`? Are these available via a different query or query structure?

- [ ] **Pagination for Tilganger:** Does `tilganger: [ApplikasjonTilgang]` support pagination through a separate field/argument, or is pagination handled at the query level?

- [ ] **Schema Extension Timeline:** When will the producer deliver the extended schema with `tilgangerMiljoer` and `tilgangerOrganisasjoner`? Does this block the switch from mock to real?

- [ ] **Status and internId Fields:** Are `status` (AKTIV/DEAKTIVERT) and `internId` still available via a different query, or are they permanently removed?
