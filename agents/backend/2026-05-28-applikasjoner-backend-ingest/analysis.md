---
status: final
source: fs-plattform/docs/specs/applikasjoner-backend-ingest/analysis-applikasjoner.md
---
# Analysis: Applikasjoner GraphQL surface — backend ingest

## Problem Statement

`docs/ingest/applikasjoner.graphql` is a mock SDL written on the **fs-admin frontend** side. It models an application-access-management surface (admins register and govern OAuth/Feide/Maskinporten/FS applications, assign responsible owners, and grant per-environment access codes). Today this surface only exists in the frontend's `src/mocks/` — the frontend reads/writes against MSW handlers, and `applikasjoner.graphql.md` explicitly notes the mock is the "long-lived contract" *until the real schema lands upstream*.

The question is: **how do we land that real schema in `fs-plattform`?** Specifically — which module hosts it, what already exists vs. what is missing, and which conventions does an implementation need to follow.

This is analysis only — no solution design.

## Current State

### The contract being ingested

The mock SDL (`docs/ingest/applikasjoner.graphql`) defines:

- **4 queries** (`applikasjoner`, `applikasjon`, `ansvarligKandidater`, `tildelbareApplikasjonTilganger`) with Relay-style cursor pagination on the listing.
- **9 mutations** covering the full lifecycle: create, change password, set/remove ansvarlig, edit beskrivelse, grant/revoke tilganger, deactivate/reactivate.
- **Domain types** `Applikasjon`, `ApplikasjonTilgang`, `TildelbarApplikasjonTilgang`, `ApplikasjonOrganisasjon` (intentionally distinct from the upstream `Organisasjon`), `ApplikasjonPerson` (audit attribution).
- **Per-app permission flags** on `Applikasjon` — `kanEndrePassord`, `kanAdministrereAnsvarlig`, `kanRedigereBeskrivelse`, `kanTildeleTilganger`, `kanFjerneTilganger`, `kanDeaktivere` (all `Boolean!`, server-evaluated for the simulated persona).
- **Ansvarlig as union** — `union Ansvarlig = FeideBruker | FeideGruppe`.
- **Identity-provider enum** — `IdentitetsleverandorType { FEIDE, MASKINPORTEN, FS }`.
- **Error envelope** — `interface Error { message, path }` plus closed sets of per-mutation error variants (e.g. `OpprettApplikasjonError = IdentitetsleverandorIdIkkeFunnet | IdentitetsleverandorIdAlleredeIBruk | VisningsnavnAlleredeIBruk | UgyldigInput`); payloads return `errors: [Error!]` with `__typename`-narrowed details.

### Backend today (`tilgangsstyring/`)

The destination module is `tilgangsstyring/` (the `auth` subgraph in `graphql.config.yaml:21-24`). Its current footprint:

- **GraphQL prod surface** is essentially empty —
  `tilgangsstyring/tilgangsstyring-app/src/main/resources/schema/schema_prod.graphqls:1-32` exposes only `Query.kontaktpersoner` and `Query.internalTilgangsstyringNode`, plus the shared `PageInfo` and `Node` interface. Federation v2.4 is enabled.
- **Experimental schema** exposes machine-user data (`Maskinbruker`, `Api`) and a `genererOgSettNyttPassord` mutation — useful as a reference, not as scaffolding.
- **Service layer** is sparse — only `PassordService.java` exists in `tilgangsstyring-service/`. New domain services would be net-new code.
- **Database is largely ready.** The PostgreSQL schema in `tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0003-create-tilgangsstyring-tables.sql` already defines three application tables, all hanging off a polymorphic `tilgangsstyring.subjekt` root:
  - `tilgangsstyring.feide_applikasjon` — OAuth/OIDC via Feide/Dataporten; `client_id`, `organisasjonskode`, `ansvarlig_subjekt_id` (FK to person/group), audit timestamps.
  - `tilgangsstyring.maskinporten_applikasjon` — M2M via Maskinporten; adds `iso6523_actorid_upis`.
  - `tilgangsstyring.maskinbruker_applikasjon` — legacy web-service accounts; uses `brukernavn` instead of `client_id`.
  - The `subjekt_type` enum already includes `feide_applikasjon`, `maskinporten_applikasjon`, `maskinbruker_applikasjon`, `feide_bruker`, `feide_gruppe`.
- **Audit pattern is automatic.** All tables carry `opprettet_av / opprettet_tidspunkt / endret_av / endret_tidspunkt`, populated by triggers from JWT context (function defined in `0002-create-functions.sql`).

### Codegen pipeline (Graphitron)

`fs-plattform` is specification-first (`CLAUDE.md:134-151`):
1. Liquibase migrations define DB schema (already done for applikasjon tables).
2. jOOQ codegen produces type-safe records (the `tilgangsstyring-new-jooq` module).
3. Graphitron transforms `.graphqls` files into resolvers using directives from `graphitron-directives/graphitron.graphqls`:
   - `@table(name:)`, `@field(name:, javaName:)` — bind a GraphQL type/field to jOOQ table/column.
   - `@asConnection` — auto-generates `*Connection`, `*Edge`, `PageInfo`, cursor pagination from a list field. **This is critical** — the codebase does **not** hand-write Relay connection wrappers. The mock SDL hand-writes them (`ApplikasjonerConnection`, `ApplikasjonerConnectionEdge`, etc.) — porting will either delete those in favor of `@asConnection`, or accept hand-written variants explicitly.
   - `@error(handlers:)` — maps DB exceptions (Oracle code / PG SQLSTATE / message-substring) to GraphQL error types. The mock-style `errors: [Error!]` envelope is **compatible** with Graphitron — each concrete error type lands as `type X implements Error @error(handlers: [...])`.
   - `@service`, `@externalField`, `@splitQuery` — escape hatches for hand-written Java when the directive-driven defaults aren't enough.

### Federation / subgraph context

- `graphql.config.yaml:21-24` already registers the `auth` subgraph at `tilgangsstyring/tilgangsstyring-app/.../schema/**.graphql`.
- New schema files dropped into that directory are picked up automatically.
- `node-subgraph/` (Apollo Federation v2.4) composes subgraphs via `@key(fields: "id")` on `Node`-implementing types. The mock does not currently declare `Applikasjon` as a federated entity; ingesting it raises the question of whether it should be (so other subgraphs can resolve references to applications).

### POC branch status

Current branch is `matsgm/applikasjoner-poc`. `git log main..HEAD` is empty — **no code changes have been made yet** beyond what's on main. The mock SDL in `docs/ingest/` is the only artifact of the POC so far.

## Key Findings

1. **The database is the smallest gap.** Three application tables, the polymorphic subjekt root, the subjekt_type enum, and the audit machinery are already in place. The bulk of the work is GraphQL surface + resolvers, not DDL.
2. **The contract is mock-shaped, not Graphitron-shaped.** Two specific mismatches stand out:
   - Connection types are hand-written; the codebase convention is `@asConnection`. Either the SDL drops the hand-written wrappers or the team accepts a non-standard pattern just for applikasjoner.
   - `ApplikasjonOrganisasjon` and `ApplikasjonPerson` are intentionally mock-local shapes (`applikasjoner.graphql:113-131`). Backend has richer types — `Organisasjon` with localized names, `Person` with student/employee detail. Whether to expose those richer types directly, keep the trimmed mock shapes, or use federation `@key` to let consumers join across subgraphs is an open decision.
3. **Naming mismatch on the third idP.** Mock enum is `IdentitetsleverandorType { FEIDE, MASKINPORTEN, FS }`. Backend table is `maskinbruker_applikasjon` (legacy web-service accounts), not "FS". Either the enum value renames, or the backend exposes a "FS"-flavored façade over `maskinbruker_applikasjon`.
4. **Authorization is opaque from the contract.** Mock declares `kanX: Boolean!` flags on `Applikasjon` and error variants like `IngenRettighetTilApplikasjon`, but where the authorization decision is computed — DB row-level rules, JWT claim inspection, or hand-written `@externalField` resolvers — isn't decided.
5. **The audit-attribution pattern is split.** Mock has its own `ApplikasjonPerson` for `opprettetAv`/`endretAv`/`tildeltAv`. Backend already populates `opprettet_av` / `endret_av` columns via triggers from JWT subject. Mapping those columns into the GraphQL surface is straightforward; mapping them to a richer `Person` upstream type is not.
6. **The frontend will eventually delete its mock.** `applikasjoner.graphql.md:10-13` says `src/mocks/` is deleted "in its entirety per `src/mocks/teardown-applikasjoner.md`" when the real schema lands. The backend ingest needs to produce a federation-composable surface that the frontend can swap to with no source-of-truth change beyond switching MSW off — meaning operation names, input shapes, and error variants should land identical to the mock unless there is a deliberate divergence.

## Technical Constraints

- **Specification-first.** Schema lands before resolvers (`CLAUDE.md:139-141`). Editing `.graphqls` then running Graphitron is the entry point — not writing Java first.
- **Module conventions.** `{domain}-db`, `{domain}-jooq`, `{domain}-service`, `{domain}-app` — applikasjon work fits inside the existing `tilgangsstyring-*` set; no new module needed.
- **Codegen order matters.** Liquibase → jOOQ → Graphitron. Schema-side changes require Graphitron regeneration; new columns require new Liquibase changesets (`tilgangsstyring-new-db/.../db-changelog-root.xml`).
- **PageInfo is `@shareable`.** `schema_prod.graphqls:17` already declares it federation-shareable. New connections in this subgraph should reuse it, not redeclare.
- **Federation v2.4** with `@tag`, `@shareable`, `@key`, `@override`, `@inaccessible` is the imported set. Anything outside that requires extending the `@link` import list.
- **Connections via `@asConnection`** is the established convention. Hand-written `*Connection` types are inconsistent with the rest of the codebase.
- **Audit triggers expect JWT context.** The `set_opprettet_av` / `set_endret` triggers read from session context populated by the coprocessor JWT. Service-layer code that writes to applikasjon tables must run within that authenticated context, not as a maintenance role.

## Dependencies

- **Internal:**
  - `tilgangsstyring-new-db` — DDL extensions (e.g. `beskrivelse`, `status`, `sist_brukt` columns if not already present in `0010-add-beskrivelse.sql` and friends — needs verification per-field as design progresses).
  - `tilgangsstyring-new-jooq` — regenerated records.
  - `tilgangsstyring-service` — new application/lifecycle services (currently only `PassordService`).
  - `tilgangsstyring-app` — schema, Graphitron-generated resolvers, federation entity decisions.
  - `graphitron-directives` — used as-is; no expected change.
  - Coprocessor JWT (`tilgangsstyring-app/src/main/java/.../coprocessor/`) — already issues `sub`, `orgtilganger`, etc.; will be the source of `persona`/authorization signal.
- **External:**
  - Feide/Dataporten API for `ansvarligKandidater` (resolving FeideBruker / FeideGruppe).
  - Maskinporten / Dataporten OAuth client provisioning (out of scope of GraphQL, but `eksternId` and `client_id` lifecycle touches them).
- **Cross-agent:**
  - **fs-admin (frontend)** — the contract owner. Any divergence between this ingest and `docs/ingest/applikasjoner.graphql` (renamed enum value, swapped connection style, dropped fields) needs alignment with the frontend team before they tear down `src/mocks/`. Candidate hand-off — `bat-plan` will surface a concrete ask (e.g. "ok to use `@asConnection` instead of hand-written connection types?") once the plan exists. Not filed from this skill.

## Requirements Impact

No `requirements-*.md` document exists for this analysis. Acceptance criteria for the ingest would need to come from a follow-on `bat-krav` or specify session — at minimum: operation parity with the mock, error-variant parity, federation composability, and a teardown signal for `src/mocks/`.

## Krav-input fra GitHub

No GitHub issue referenced. This analysis is purely local against the mock SDL in `docs/ingest/`.

## Decisions

### Connection types: `@asConnection` over hand-written (2026-05-28)

**Question.** Should the connection types stay hand-written (mock parity) or migrate to `@asConnection` (codebase parity)?

**Options considered.**

| Option | Description | Effort | Codebase fit | Frontend swap impact |
| --- | --- | --- | --- | --- |
| **A. Hand-written** | Port `ApplikasjonerConnection` / `ApplikasjonTilgangerConnection` / `PageInfo` verbatim from the mock SDL into `tilgangsstyring-app`. | Low up-front, but every future field/type lands as Java + SDL. | Breaks a 66:0 convention — no hand-written connection exists anywhere in `fs-plattform`. | Zero shape change. |
| **B. `@asConnection`** | Declare each list-returning field as `field(...): [T!]! @asConnection`. Graphitron generates connection + edge wrappers; reuse the subgraph's shared `PageInfo @shareable`. | Smallest backend surface — directive does the work. | Matches the convention exactly (`schema_prod.graphqls:9`, `schema_exp.graphqls:1–16`, `regelverk_exp.graphqls`, etc.). | **None** — Graphitron emits `nodes`, `edges { cursor, node }`, `pageInfo`, and `totalCount` (verified against production query files; see Rationale point 5). |
| **C. Hybrid (`connectionName` override)** | Use `@asConnection(connectionName: "...")` so Graphitron writes the generated parts under a name we control. | Medium. | Mostly conventional, with one localized deviation per connection. | Same as B; the override only matters if a specific generated name needs control. |

**Decision: Option B — `@asConnection`.**

**Rationale.**

1. **Convention is unanimous.** 66 `@asConnection` call sites across `tilgangsstyring`, `opptak`, `sis`, and others; zero hand-written `type *Connection` exist anywhere in the repo (`graphitron-directives/transformer.graphqls:6` defines the directive; representative sites at `schema_prod.graphqls:9` and `schema_exp.graphqls:1–16`). Hand-rolling here would be the first exception in the codebase, with no precedent justifying it.
2. **The mock is explicitly the transitional contract.** `applikasjoner.graphql.md:10–13` calls `src/mocks/` the "long-lived contract *until the real schema lands upstream*" — convergence on backend conventions is the point of ingest, not preservation of mock idiosyncrasies.
3. **PageInfo is already shared.** `schema_prod.graphqls:17` declares `PageInfo @shareable`. Hand-writing a second `PageInfo` in the applikasjoner schema would either duplicate or collide with it at federation composition time. `@asConnection` reuses the shared one for free.
4. **No shape divergence vs. the mock.** Graphitron-generated connections include `nodes`, `totalCount`, `edges { cursor, node }`, and `pageInfo` — verified against real production query files: `sis/sis-app/src/it/resources/QueryFilesApprovalIT/queries/feilmeldingVedFeilID.graphql:3` selects `totalCount` from `studenter(...)`, and `studieprogramBeskrivelsesavsnittPaginert.graphql:6–20` plus `emneBeskrivelsesavsnittPaginert.graphql:3–17` select `nodes`, `pageInfo`, and `edges`. All four convenience fields the mock relies on come out of `@asConnection` for free. The kompetanse-module draft `PageInfo` at `kompetanse/.../skjema-utkast.graphqls:596–602` also reflects this with `totalCount: Int`.
5. **Filter args coexist.** Real-world `@asConnection` call sites already pair the directive with filter inputs (e.g. `maskinbrukere(filter: MaskinbrukereFilter): [Maskinbruker] @asConnection`, `apiTilgangerForMaskinbrukereV2(filter: ...)`), so the `applikasjoner(filter:, orderBy:, first:, after:, ...)` signature ports without compromise.

**Risks / follow-ups.**

- **Implication for the mock SDL itself.** Since the ingest folder must reflect best practice (not a frozen mock), the `docs/ingest/applikasjoner.graphql` source should be updated to use `@asConnection` on the list-returning fields (`applikasjoner(...): [Applikasjon!]! @asConnection`, `tilganger(...): [ApplikasjonTilgang!]! @asConnection`), and the hand-written `ApplikasjonerConnection`, `ApplikasjonerConnectionEdge`, `ApplikasjonTilgangerConnection`, `ApplikasjonTilgangerConnectionEdge`, and `PageInfo` types should be deleted from the SDL. The mock's expanded-shape executable schema (consumed by MSW) is a separate, generated artifact — not the source-of-truth file in `docs/ingest/`. This change lands in `bat-plan` as a concrete task.
- **Federation entity interaction.** If `Applikasjon` ends up declared `@key(fields: "id")` (separate open question), confirm that `@asConnection` cooperates with `@key`-bearing node types. None of the surveyed call sites combine both, so this is unverified.
- **Edge type naming.** Mock uses `ApplikasjonerConnectionEdge`; Graphitron's default may be `ApplikasjonerEdge`. If the frontend's generated TypeScript types rely on the longer name, use `@asConnection(connectionName: "...")` to control the generated naming — or, more likely, regenerate the frontend types from the post-ingest schema and adopt whatever name Graphitron emits.
- **Cross-agent alignment.** Frontend (fs-admin) consumes the mock as its current source-of-truth. Both the source-SDL change (mock → `@asConnection` form) and any naming choice (`connectionName` override, if needed) should be confirmed with the fs-admin owner before they tear down `src/mocks/`. This is the concrete ask `bat-plan` will surface as a hand-off candidate.

### idP enum value: `MASKINBRUKER` (2026-05-28)

**Question.** Does `IdentitetsleverandorType.FS` become `MASKINBRUKER`, or does the backend expose `maskinbruker_applikasjon` under an `FS` façade?

**Options considered.**

| Option | Description | API naming | Codegen mapping |
| --- | --- | --- | --- |
| **A. Keep `FS`** | Mock parity; admin-facing label. Resolver maps `FS` → `maskinbruker_applikasjon`. | `IdentitetsleverandorType { FEIDE, MASKINPORTEN, FS }` | Declarative `@enum` binding with name divergence between schema and DB. |
| **B. Rename to `MASKINBRUKER`** | API value matches backend table name. | `IdentitetsleverandorType { FEIDE, MASKINPORTEN, MASKINBRUKER }` | 1:1 mapping; no translation in resolver. Frontend renders display label ("FS-bruker") from the enum. |
| **C. Both with deprecation** | Ship `MASKINBRUKER` canonical, keep `FS` as `@deprecated` alias. | Both values valid; one preferred. | Two values to map; deprecation lifecycle to track. |

**Decision: Option B — rename to `MASKINBRUKER`.**

**Rationale.**

1. **Direct alignment with the storage layer.** Backend table is `tilgangsstyring.maskinbruker_applikasjon` (`0003-create-tilgangsstyring-tables.sql:279`) and the `subjekt_type` discriminator is `'maskinbruker_applikasjon'` (lines 281, 295). Naming the enum value `MASKINBRUKER` makes the schema → table mapping unambiguous in resolvers, Graphitron `@field` bindings, and any subjekt-type-discriminated logic — no translation step between SDL terminology and DB terminology.
2. **Display labels belong in the UI, not the API.** Localized / admin-friendly strings like "FS-bruker" are a frontend concern; the API surface should carry the canonical domain term. fs-admin can render `MASKINBRUKER` as "FS-bruker" (or any localized variant) via the standard label-translation path it already uses for other enums.
3. **Avoids a category mistake.** "FS" is a system, not an identity provider type. Keeping `FEIDE`, `MASKINPORTEN`, `MASKINBRUKER` makes the enum a coherent taxonomy of authentication mechanisms; mixing in `FS` would conflate a product name with an idP type.

**Risks / follow-ups.**

- **Mock SDL must change too.** `docs/ingest/applikasjoner.graphql:79` declares `FS` and is referenced from `OpprettApplikasjonInput.identitetsleverandor` (line 263), `Applikasjon.identitetsleverandor` (line 154), and the error envelope `IdentitetsleverandorIdIkkeFunnet.identitetsleverandor` (line 322). All of these must move to `MASKINBRUKER` when the ingest folder is updated.
- **Frontend label translation.** fs-admin currently consumes `FS` and likely uses it verbatim or via an existing label-map. The enum-value rename is a breaking change for any consumer that string-matches `"FS"`; coordinate via the fs-admin hand-off that `bat-plan` will surface.
- **MSW handlers.** While `src/mocks/` is alive, the frontend's handlers will return `FS`. The swap to the real backend and the rename to `MASKINBRUKER` should land together; otherwise the frontend has to dual-handle for a transition window.

### Org/Person shapes: federate org, trim audit (2026-05-28)

**Question.** Are `ApplikasjonOrganisasjon` and `ApplikasjonPerson` permanent trimmed shapes, or should the surface federate into the upstream `Organisasjon` / `Person` types?

**Options considered.**

| Option | Org reference | Audit attribution | Effort | Federation surface |
| --- | --- | --- | --- | --- |
| **A. Keep trimmed shapes** | `ApplikasjonOrganisasjon { id, navn }` | `ApplikasjonPerson { id, navn }` | Lowest. | None — types are subgraph-local; other subgraphs can't extend them. |
| **B. Federate org, trim audit** | New `Organisasjon implements Node @key(fields: "id") @table(name: "organisasjon")` bound to `tilgangsstyring.organisasjon` | `ApplikasjonPerson { id, navn }` for `opprettetAv` / `endretAv` / `tildeltAv` | Medium — new entity plus typeId allocation. | Org is federatable; audit fields remain display metadata. |
| **C. Federate everything** | Same as B for org | Audit fields point to `Kontaktperson` or a `Subjekt` union over `Kontaktperson` / `Maskinbruker` / etc. | Highest — discriminated union over the polymorphic `tilgangsstyring.subjekt`. | Full surface. |

**Decision: Option B — federate org, keep trimmed `ApplikasjonPerson` for audit.**

**Rationale.**

1. **Right level of indirection per use case.** `Applikasjon.organisasjon` (and the org on `FeideBruker`/`FeideGruppe`) is a *real entity relationship* — a federated `@key(fields: "id")` entity lets other subgraphs extend it without this subgraph re-declaring the org schema. Audit attribution is *display metadata* (rendering "Created by Ola Nordmann at …") — the trimmed `{id, navn}` shape covers the actual UI use case without forcing every subjekt-type to be modeled as a discriminated union.
2. **`tilgangsstyring.organisasjon` has no GraphQL type yet.** The existing `AuthOrganisasjon` (`schema_exp.graphqls:55`) is bound to the legacy `WSINST_DB` table — not the new `tilgangsstyring.organisasjon` that the applikasjon tables FK to. So a new `Organisasjon` type is required regardless; the only choice is whether it gets `@key` (Option B/C) or stays local (Option A).
3. **Audit attribution comes from the polymorphic `subjekt` root.** `opprettet_av` / `endret_av` columns hold `subjekt_id` pointing into `tilgangsstyring.subjekt`, whose `subjekt_type` can be `feide_bruker`, `feide_gruppe`, `maskinporten_applikasjon`, `maskinbruker_applikasjon`, etc. Modeling that as a federated union (Option C) requires every subjekt subtype to have a federation entity *and* a runtime discriminator. `ApplikasjonPerson { id, navn }` sidesteps this with a denormalized label — the JWT-trigger machinery (`0002-create-functions.sql`) populates `opprettet_av` from the authenticated subject, and a join to `feide_bruker.visningsnavn` / `kontaktperson.navn` etc. can render `navn` without exposing the polymorphic discriminator on the API.
4. **Matches the previous decisions' direction.** Connection types: `@asConnection` (codebase convention). idP enum: `MASKINBRUKER` (backend nomenclature). Federating `Organisasjon` continues the pattern of converging on the platform's federation idiom rather than carrying mock-local types.

**Risks / follow-ups.**

- **TypeId allocation for `Organisasjon`.** The tilgangsstyring subgraph reserves typeIds `20001+` (`Kontaktperson: "20001"`, `AuthOrganisasjon: "20007"`, etc.). Pick the next unused typeId in that range when declaring `@node(typeId: "...")`.
- **Resolver of `ApplikasjonPerson.navn`.** Audit-attribution rendering needs a path from `subjekt_id` → human label. The simplest path is a Graphitron `@field` mapping to a denormalized column (e.g. `opprettet_av_navn` cached at write time) or a `@externalField` resolver that joins through `tilgangsstyring.subjekt` to whichever subtype owns the row. Implementation detail for `bat-plan`.
- **Schema-team coordination.** Introducing a new federation entity `Organisasjon` on the `auth` subgraph means other subgraphs will start being able to extend it. This is benign (additive) but worth flagging in the producer-guidelines review per `bat-graphql-dev`.
- **Frontend swap.** The frontend currently selects `organisasjon { id, navn }` on `ApplikasjonOrganisasjon`. The same selection set works on a federated `Organisasjon`. Zero query change for the org reference. Audit-attribution selection sets also unchanged (still `ApplikasjonPerson { id, navn }`).

### `Applikasjon` as federation entity (2026-05-28)

**Question.** Should `Applikasjon` declare `@key(fields: "id")` so other subgraphs can resolve references?

**Decision: Option A — yes, full federation citizen.** `Applikasjon` (and `ApplikasjonTilgang`) declare `implements Node @node(typeId: "...") @key(fields: "id") @table(name: "...")`.

**Rationale.**

1. **Matches the production pattern.** `Kontaktperson` at `schema_prod.graphqls:13` is the established prod-schema template for `tilgangsstyring`: `implements Node @table @node(typeId) @key(fields: "id")`. The opptak subgraph follows the same template across every entity (`schema_opptak.graphqls:85, 141`; `regelverk_exp.graphqls:39, 44, 76, …`). Hand-writing `Applikasjon` without it would be a one-off deviation with no precedent.
2. **`@asConnection` + `@key` are proven to compose.** `kontaktpersoner: [Kontaktperson] @asConnection` at `schema_prod.graphqls:9` returns a type that is itself `@key(fields: "id")` (line 13). This dissolves the risk flagged in the connection-types decision.
3. **Consistency with the prior Org/Person decision.** That decision introduces `Organisasjon @key(fields: "id")`. Applying the same pattern to `Applikasjon` and `ApplikasjonTilgang` keeps the subgraph internally coherent: every primary entity is reachable via global node-id and is composable across subgraphs.
4. **Unlocks cross-subgraph use cases.** Other producers (e.g. `sis`, `opptak`) can resolve references to an `Applikasjon` (e.g. audit fields elsewhere that record which API client performed an action). Without `@key`, those subgraphs would have to redeclare an `Applikasjon` stub or denormalize.

**Risks / follow-ups.**

- **TypeId allocation.** Pick the next unused typeIds in the tilgangsstyring `20001+` range for both `Applikasjon` and `ApplikasjonTilgang`. Current usage: `Kontaktperson: 20001`, `ApiTilgangsrolle: 20003`, `DatatilgangForMaskinbruker: 20004`, `Maskinbruker: 20005`, `ApiTilgangForMaskinbruker: 20006`, `AuthOrganisasjon: 20007`, `Datatilgangsrolle: 20008`, `Api: 20009`, `ApiTilgangForMaskinbrukerV2: 20010`. Next free: `20011+`.
- **keyColumns choice for the polymorphic root.** `Applikasjon` straddles three physical tables (`feide_applikasjon`, `maskinporten_applikasjon`, `maskinbruker_applikasjon`) discriminated on `subjekt_type`. The `@node(keyColumns: [...])` value should be the polymorphic `subjekt.subjekt_id` (or `subjekt.subjekt_id + subjekt_type` if Graphitron needs the discriminator for typeId reconstruction). This needs a small implementation spike — flag for `bat-plan`.
- **`ApplikasjonTilgang` keyColumns.** TBD per the access-grant table's primary key. Same spike scope as above.

### `kanX` flags: Java resolver (2026-05-28)

**Question.** Where do `kanX` permission flags compute — DB-side (RLS / view), JWT claim inspection, or hand-written `@externalField` resolver?

**Decision: Option B — Java resolver inspecting JWT context.** Each `kanX` field is wired as `@externalField` (or `@service`) and computed by a `KanFlagsResolver` that reads tilganger from `AuthenticatedContextProvider` and applies per-type business rules in Java.

**Rationale (user's choice).**

1. **Tight iteration loop on the rule set.** The mock declares six flags, but the actual mapping from "current orgtilganger + applikasjon row state" → boolean is still evolving (per-action tilganger don't yet exist in the role model; type-specific rules need product input). Java code changes ship faster than Liquibase + jOOQ regeneration cycles.
2. **Single language for resolver logic.** All non-RLS authorization in the codebase already routes through Java services (e.g. `PassordService.java`); colocating kan-flag computation with that pattern is consistent.
3. **No DB schema or function migration required for shape changes.** Adding `kanRedigereStatus` later is a Java change only.

**Risks / follow-ups.**

- **Consistency with RLS is now a convention, not a guarantee.** RLS in `0005-create-rls-policies.sql:104–146` allows reads/writes when `auth.har_tilgang('BRUKERADMIN_WSBRUKER_LES'|'…_SKRIV', auth.current_orgtilganger())` succeeds. The Java `kanX` logic must mirror that decision in Java terms, or the UI will offer actions the DB rejects (or hide actions the DB would allow). Mitigation: write parity tests that exercise the same (subject, applikasjon) pairs against both layers and assert the same outcome. Document as a `bat-plan` task.
- **Per-action tilganger.** The DB currently has one `BRUKERADMIN_WSBRUKER_SKRIV` for all writes. The six `kanX` flags imply finer-grained tilganger may be needed eventually (e.g. `BRUKERADMIN_PASSORD_SKRIV` separate from `BRUKERADMIN_BESKRIVELSE_SKRIV`). For now, all `kanX = true` reduces to "viewer has SKRIV on this app's orgkode AND the action makes sense for this app type". When the role model grows finer-grained, the Java logic adapts in one place. Flag this for the access-control product owner.
- **N+1 risk.** Six fields × N applikasjoner per page = up to 6N resolver calls. The resolver must take orgtilganger from the request-scoped `AuthenticatedContextProvider` (constant per request) and compute purely in memory from the loaded `Applikasjon` row — no DB calls per field. Verify in code review.
- **Federation entity caveat.** Because `Applikasjon` is `@key(fields: "id")` (per the prior decision), `kanX` may be requested via entity-reference resolution from another subgraph. The Java resolver must work when the only loaded state is `id` — i.e. the resolver should load the underlying row (type, organisasjonskode, ansvarlig) before computing flags. Handle either via Graphitron's reference-resolution scaffolding or an explicit DataLoader-style fetch in the service.

### Per-column audit vs `Applikasjon` (2026-05-28)

**Question.** What columns are still missing on `feide_applikasjon` / `maskinporten_applikasjon` / `maskinbruker_applikasjon` to satisfy the full `Applikasjon` shape?

**Audit (post migrations 0003 + 0006 + 0010).**

| Mock field | DB source | Status |
| --- | --- | --- |
| `id: ID!` | `subjekt_id` (polymorphic root) | ✓ |
| `navn: String!` | `navn` | ✓ on all three tables |
| `beskrivelse: String` | `beskrivelse` (added in `0010-add-beskrivelse.sql`) | ✓ on all three tables |
| `organisasjon: ApplikasjonOrganisasjon!` | `organisasjonskode` FK → `tilgangsstyring.organisasjon` | ✓ |
| `identitetsleverandor: IdentitetsleverandorType!` | `subjekt_type` discriminator | ✓ — mapped via the `MASKINBRUKER` rename decision |
| `eksternId: String!` | feide: `service_id` (renamed in `0006-alter-table.sql:4`); maskinporten: `client_id`; maskinbruker: `brukernavn` | ⚠ per-type column — needs Graphitron `@field` per subtype or a unifying SQL view |
| `status: ApplikasjonStatus!` | — | ❌ **MISSING** — no `status` column. Required for `kanDeaktivere` + the `deaktiverApplikasjon` / `reaktiverApplikasjon` mutations. |
| `ansvarlig: Ansvarlig` | `ansvarlig_subjekt_id + ansvarlig_type` | ✓ — union resolves via discriminator |
| `miljoer: [Miljo!]!` | — | ❌ **MISSING** as a direct column. Likely derived from distinct miljøer in the app's `ApplikasjonTilgang` rows, or a separate "tildelt miljø"-table. Open design decision. |
| `opprettetAv: ApplikasjonPerson` | `opprettet_av` FK → `subjekt` | ✓ |
| `opprettetTidspunkt: String!` | `opprettet_tidspunkt` | ✓ |
| `endretAv: ApplikasjonPerson` | `endret_av` (nullable in DB) | ✓ |
| `endretTidspunkt: String!` | `endret_tidspunkt` (nullable in DB) | ⚠ **nullability mismatch** — mock declares non-null, DB allows null on unedited rows |
| `sistBrukt: String` | — | ❌ **MISSING** — no `sist_brukt` column. Owner unclear: tilgangsstyring tracks issuance; actual usage may be tracked elsewhere (Feide login events / Maskinporten token issue / FS webservice access logs). |
| `kanX` (6 flags) | computed | ✓ — Java resolver per the prior decision |
| `tilganger` connection | separate `ApplikasjonTilgang` table | not part of this audit |

Also noted: `maskinporten_applikasjon.iso6523_actorid_upis` is *not* surfaced in the mock `Applikasjon` shape. Likely intentional, but flag for confirmation before declaring the schema final.

**Gaps to file as concrete `bat-plan` tasks.**

1. **Add `status` modeling.** Choose between explicit `status TEXT` (with `CHECK (status IN ('AKTIV','INAKTIV'))`) on each of the three applikasjon tables, or a single `deaktivert_tidspunkt TIMESTAMPTZ` with derived `status = CASE WHEN deaktivert_tidspunkt IS NULL THEN 'AKTIV' ELSE 'INAKTIV' END`. The latter preserves "when was this deactivated" without a join.
2. **Decide `miljoer` derivation.** Either compute from `DISTINCT miljo` over `ApplikasjonTilgang` for that app, or model an explicit `applikasjon_miljo` link table if an app can be "deployed to" environments independently of having a tilgang in each.
3. **Decide `sistBrukt` ownership and population path.** Options: (a) add `sist_brukt TIMESTAMPTZ` column updated by the coprocessor / auth-runtime on successful credential use, (b) compute via a separate `applikasjon_usage` log table joined at read time, (c) skip the field initially and ship the schema with `sistBrukt` removed.
4. **Resolve `endretTidspunkt` nullability.** Either (a) relax the mock SDL to `endretTidspunkt: String` (nullable) — small consumer impact, or (b) add a DB trigger that sets `endret_tidspunkt = opprettet_tidspunkt` on insert so the column is effectively non-null after insert.
5. **Unify `eksternId` mapping.** Either three `@field` overrides per subtype on the polymorphic GraphQL type, or a SQL view `tilgangsstyring.applikasjon_v` that UNIONs the three tables with a unified `ekstern_id` column expression.
6. **Confirm `iso6523_actorid_upis` is intentionally absent** from the mock surface.

**Decision.** Record the audit and gaps as `bat-plan` inputs. Each gap requires either product input (sist_brukt source-of-truth), authz input (status semantics), or modeling input (miljoer link), which is outside the scope of this analysis pass.

### `ansvarligKandidater`: hybrid (2026-05-28)

**Question.** Is `ansvarligKandidater` backed by live Feide/Dataporten lookups, a cached projection in `tilgangsstyring.feide_bruker` / `feide_gruppe`, or both?

**Decision: Option C — hybrid.** Search hits `feide_bruker` / `feide_gruppe` first; on a Feide-ID-shaped miss, the resolver calls Feide/Dataporten via the existing `FeideClient` (`coprocessor/feide/FeideClient.java`) and upserts the result into the local table before returning it. Assignment mutations rely on the FK being satisfied by the prior upsert.

**Rationale.**

1. **The FK is load-bearing.** `feide_applikasjon.ansvarlig_subjekt_id` (and the equivalent on `maskinporten_*` / `maskinbruker_*` tables) references `tilgangsstyring.subjekt`. A candidate that doesn't have a row in `feide_bruker` / `feide_gruppe` cannot be assigned. The cache is part of the integrity model, not just a perf layer — so any flow that returns a candidate must guarantee the cache row exists by the time the assignment commits.
2. **Cache-first matches the current population pattern.** `feide_bruker` comments (`0003-create-tilgangsstyring-tables.sql:348–349`) note it is *"provisjoneres fra Feide-katalogen (LDAP) ved lærestedet"* — it's a working cache of users who have been *seen* by tilgangsstyring (login, prior assignment). Searches against this cache are fast and match the established access pattern.
3. **Live fallback handles cold starts.** First-time admins assigning a never-before-seen Feide bruker / gruppe wouldn't find them in cache; the API fallback covers that case without a batch-sync infrastructure layer.
4. **Existing Feide client is sufficient.** `FeideClient`, `FeideUserInfoApi`, `FeideExtendedUserInfo` already exist in the coprocessor package. No new external integration is needed; only a new query method (e.g. `lookupByFeideId(String)`) and the autocomplete-search shape (if Feide's API supports prefix search).

**Risks / follow-ups.**

- **Search semantics.** Cache LIKE-search is straightforward, but Feide's API may only support exact-ID lookup (not prefix autocomplete). If admins need fuzzy search across the full Feide directory, the fallback needs to be product-clarified — either a richer Dataporten search endpoint, or the UX accepts "type a complete Feide-ID for unknown users".
- **Upsert path on assignment.** The `setAnsvarlig` mutation should not assume the row already exists. Either (a) run the lookup-and-upsert as part of `ansvarligKandidater` (returning only candidates with an existing row) and require the frontend to use those returned IDs, or (b) run lookup-and-upsert inside the mutation resolver when the FK insert would otherwise fail. The mock contract returns a `Ansvarlig` union from `ansvarligKandidater`, suggesting (a) — confirm with the frontend owner.
- **GDPR / data minimization.** Upserting Feide users into local storage retains personally identifiable data outside Feide's directory. Confirm retention/cleanup rules (e.g. soft-delete rows for users no longer in Feide) before shipping.
- **Rate limits.** A live API call on every cold-miss can throttle if many admins onboard new users simultaneously. Consider a short in-memory cache for the API fallback to deduplicate repeated lookups of the same ID within a session.
- **Group lookups.** `feide_gruppe` comment (`0003-...:380–381`) notes population *"via Feides Groups API"*. Confirm that the existing client covers the Groups API, or extend it.

### `byttApplikasjonPassord`: Maskinporten-only (2026-05-28)

**Question.** How does the password lifecycle of `byttApplikasjonPassord` reuse `PassordService`, and does it need extension for Maskinporten client-secret rotation?

**Decision (per user clarification): `byttApplikasjonPassord` is for Maskinporten applications only.** What the mock calls "passord" in this mutation is the **Maskinporten client_secret**, rotated via Maskinporten's API — not a locally-stored bcrypt hash. `PassordService` is **not** in the path for this mutation.

**What this means concretely.**

1. **No reuse of `PassordService`.** `PassordService` (`tilgangsstyring-service/.../PassordService.java`) writes to the legacy `Wsbruker.WSBRUKER` table for maskinbruker apps via the existing `genererOgSettNyttPassord` mutation in `schema_exp.graphqls:22`. That lifecycle is independent of the new applikasjoner UX.
2. **New Maskinporten client service required.** A new service (working name: `MaskinportenHemmelighetsService` or similar) wraps the Maskinporten Admin API for client-secret rotation. Responsibilities: call Maskinporten, receive the new secret, return it to the caller exactly once (the secret is not stored locally — Maskinporten is the source of truth).
3. **`kanEndrePassord` is true only for `maskinporten_applikasjon`.** The Java resolver from the prior `kanX`-decision must restrict the flag to `subjekt_type = 'maskinporten_applikasjon'` and `false` for Feide and maskinbruker apps. The `KanFlagsResolver` should encode this rule explicitly.
4. **Error envelope for the wrong app type.** If a Feide or maskinbruker `applikasjonId` reaches the mutation, return a typed error (e.g. `PassordIkkeStottetForIdentitetsleverandor implements Error`) following the mock's closed-set error pattern.

**Risks / follow-ups.**

- **Maskinporten Admin API integration is new code.** No existing Java client for Maskinporten-secret-rotation appears in `tilgangsstyring/`. This needs: auth (likely a service-token Sikt holds against Maskinporten), the rotation endpoint, error mapping (rate limits, unknown client_id, etc.). Out of scope for this analysis; flag as a `bat-plan` task.
- **Existing maskinbruker password flow is separate.** The current `genererOgSettNyttPassord` mutation in `schema_exp.graphqls:22` continues to serve the legacy wsbruker lifecycle. Open follow-up: should the new applikasjoner UI surface maskinbruker password management at all (via a separate mutation), or is that intentionally out of scope here and lives in a different UX? Worth confirming with the frontend owner before declaring the mock complete.
- **Error variant naming.** The mock currently lists error types per mutation (e.g. `OpprettApplikasjonError = IdentitetsleverandorIdIkkeFunnet | IdentitetsleverandorIdAlleredeIBruk | VisningsnavnAlleredeIBruk | UgyldigInput`). Confirm the corresponding error variant set for `byttApplikasjonPassord` matches Maskinporten's actual failure modes (e.g. `ApplikasjonenIkkeRegistrertHosMaskinporten`, `RoteringMislyktes`).
- **Secret-handling boundary.** The new secret is sensitive — return it in the GraphQL response (visible once to the admin) but never log it. Confirm logging policy and the GraphQL response is served over the same auth-bound transport as the rest of fs-admin.

**Important corrigendum for prior decisions.**

- The earlier "kanX flags" decision § (Java resolver) referenced "type-specific rules (e.g. `kanEndrePassord` is meaningless for a Feide app)". That phrasing is now updated by this decision: `kanEndrePassord` is meaningful **only** for `maskinporten_applikasjon`, false for both `feide_applikasjon` and `maskinbruker_applikasjon`. The implementing resolver must reflect this.

## Open Questions

- [x] **Answered (2026-05-28) — see Decisions § "idP enum value: `MASKINBRUKER`".** Does `IdentitetsleverandorType.FS` become `MASKINBRUKER`, or does the backend expose `maskinbruker_applikasjon` under an `FS` façade?
- [x] **Answered (2026-05-28) — see Decisions § "Org/Person shapes: federate org, trim audit".** Are `ApplikasjonOrganisasjon` and `ApplikasjonPerson` permanent trimmed shapes, or should the surface federate into the upstream `Organisasjon` / `Person` types?
- [x] **Answered (2026-05-28) — see Decisions § "`Applikasjon` as federation entity".** Should `Applikasjon` declare `@key(fields: "id")` so other subgraphs can resolve references?
- [x] **Answered (2026-05-28) — see Decisions § "`kanX` flags: Java resolver".** Where do `kanX` permission flags compute — DB-side (RLS / view), JWT claim inspection, or hand-written `@externalField` resolver?
- [x] **Answered (2026-05-28) — see Decisions § "Per-column audit vs `Applikasjon`".** What columns are still missing on `feide_applikasjon` / `maskinporten_applikasjon` / `maskinbruker_applikasjon` to satisfy the full `Applikasjon` shape (`beskrivelse`, `sist_brukt`, `status` if not present)? Needs a per-column audit against the current DDL.
- [x] **Answered (2026-05-28) — see Decisions § "`ansvarligKandidater`: hybrid".** Is `ansvarligKandidater` backed by live Feide/Dataporten lookups, a cached projection in `tilgangsstyring.feide_bruker` / `feide_gruppe`, or both?
- [x] **Answered (2026-05-28) — see Decisions § "`byttApplikasjonPassord`: Maskinporten-only".** How does the password lifecycle of `byttApplikasjonPassord` reuse `PassordService`, and does it need extension for Maskinporten client-secret rotation?
