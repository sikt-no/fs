# Task #1 Completion Report: Mock-API for personbrukere (`src/mocks/personbrukere/`)

## Status: ✅ COMPLETED

**Date Completed**: 2026-07-08
**Task**: Mock-API for personbrukere (`src/mocks/personbrukere/`)
**Priority**: High
**Size**: L

## Summary

Built the complete mock-first API surface for personbruker-brukeradministrasjon in fs-admin: a reference SDL realising the plan's entire GraphQL section (Op #1–#7), 84 deterministic personbruker-fixtures (77 visible to the brukeradministrator persona — pagination past 50 exercisable), a resettable in-memory store, MSW handlers for all 8 query operation names and all 6 mutations (with per-element delvis-suksess-avvisning and frys-semantikk), standalone handler tests (57 assertions-suites, all green), env-var-gated registration in `src/mocks/handlers.ts`, and a teardown document carrying the three open GraphQL questions as checkpoints.

## Files Created

All paths relative to the fs-admin repo (`/Users/mats.myhre/Dev/Sikt/fs-admin`).

### 1. `src/mocks/personbrukere/schema/personbrukere.graphql` (327 lines)

Reference-only SDL mirroring the plan's normative GraphQL section (Op #1–#7): `Personbruker` with nested `tilganger`/`roller` connections, `PersonbrukerTilgang`/`PersonbrukerRolle` with `tildeltAv`/`tildeltTidspunkt`/`status`/`kanFjernes`, all 6 query fields, all 6 mutations with per-element delvis-suksess-konvolutt (`TildelingAvvist`/`TildelingAvvistArsak`), and the skeleton types (`Miljo`, `Organisasjon`, `Person`, `MutasjonAvvist`, `MutasjonAvvistArsak`) re-declared identically to `applikasjoner.graphql`. Header comment follows the applikasjoner pattern (reference only, not codegen, teardown pointer) and lists the three open questions as input to the subgraph-plan step.

### 2. `src/mocks/personbrukere/types.ts` (333 lines)

Mock-local TS types mirroring the SDL 1:1 (`__typename`-tagged, Connection/PageInfo Graphitron shape, filter inputs, result unions), with the migration recipe in the header. Never imported by consumer code.

### 3. `src/mocks/personbrukere/fixtures/` (7 files, ~1,160 lines)

- `personbrukere.ts` — 13 curated + 71 bulk records (seeded Mulberry32 PRNG, deterministic). Curated edge cases with stable IDs: `pb-paginering-stress` (60 tilganger → nested «Last inn flere»), `pb-deaktivert-frossen` (DEAKTIVERT, all tildelinger INAKTIV), `pb-kun-roller`/`pb-kun-tilganger` (empty-tab states), `pb-tiebreak-a`/`pb-tiebreak-b` (identical navn, distinct feideId), `pb-uib-usynlig` (invisible for persona), `pb-mixed-orgs` (nested persona-filtering demonstrable), `pb-readonly` (all kan*-flags false), `pb-kan-ikke-fjernes` (kanFjernes=false → per-element-avvisning ved fjern), `pb-utlopte-tildelinger` (INAKTIVE tildelinger on AKTIV user), `pb-uten-tildelinger`. `verifyFixtureCounts()` guards the invariants at seed time.
- `persona.ts` — `PERSONA_BRUKERADMINISTRATOR` (admin for sikt/uio/ntnu) and `PERSONA_SUPER_BRUKERADMINISTRATOR`, with the arbeidsverdi-rollekoder `brukeradministrator`/`super_brukeradministrator` confined to the mock layer (analysebeslutning #7). Also exports `MINE_BRUKERADMIN_ORGANISASJONER` (query source).
- `roller.ts` / `tilganger.ts` — catalogs incl. the arbeidsverdi-rollekoder and the rejection triggers `sperret` (→ MANGLER_RETTIGHET) and `utgatt` (→ UGYLDIG_TILSTAND), which stay listed in the tildelbare-queries so delvis suksess is demonstrable from the UI.
- `organisasjoner.ts`, `miljoer.ts` (demo/prod, spec-beslutning #4), `personer.ts` (tildeltAv pool), `index.ts` (barrel).

### 4. `src/mocks/personbrukere/store/personbrukereStore.ts` (239 lines)

Mutable in-memory state seeded lazily from fixtures (deep clone) with `resetStore()` for tests — the `applikasjonerStore` pattern. `leggTilTilganger`/`fjernTilganger`/`leggTilRoller`/`fjernRoller` (resync of derived `organisasjoner`/`antall*` fields), plus `deaktiverPersonbruker`/`reaktiverPersonbruker` implementing the frys-semantikk (deaktiver → all tildelinger INAKTIV + kan*-flags flip; reaktiver → AKTIV again).

### 5. `src/mocks/personbrukere/handlers/queries.ts` (523 lines)

MSW handlers (scoped to `/api/graphql`, matched on operation name) for all 8 contract operation names: `personbrukere`, `personbruker`, `personbrukerMedTilganger`, `personbrukerMedRoller`, `personbrukereFilterOptions`, `mineBrukerAdminOrganisasjoner`, `tildelbarePersonbrukerTilganger`, `tildelbarePersonbrukerRoller`. Full semantics: two fritekst-filters (navn, feideId — case-insensitive substring), status/org/rolle/miljø-filters, NAVN_ASC/DESC sorting with feideId-ascending tie-break in both directions, Relay-cursor pagination, and server-side persona visibility (`erPersonbrukerSynligForPersona` + `filterTildelingerForPersona` + `toWirePersonbruker` — persona-filter runs BEFORE user filter/sort/paginate so `totalCount`/`pageInfo` reflect the visible set). All builders exported for tests, MSW handlers are thin wrappers.

### 6. `src/mocks/personbrukere/handlers/mutations.ts` (560 lines)

All 6 mutations. Shared total-avvisning checks (trigger-id, unknown/invisible bruker → RESSURS_IKKE_FUNNET, org outside persona scope → MANGLER_RETTIGHET, deaktivert bruker → UGYLDIG_TILSTAND) and per-element classification for delvis suksess: tildel → UKJENT/UGYLDIG_TILSTAND/MANGLER_RETTIGHET/ALLEREDE_TILDELT; fjern → IKKE_TILDELT/MANGLER_RETTIGHET (kanFjernes=false). New tildelinger carry `tildeltAv` (persona) + `tildeltTidspunkt` (now). Deaktiver/reaktiver delegate to the store's frys-semantikk.

### 7. `src/mocks/personbrukere/handlers/index.ts` (10 lines)

Handler registry (`personbrukereHandlers`).

### 8. `src/mocks/personbrukere/handlers/queries.test.ts` (524 lines) + `mutations.test.ts` (376 lines)

Standalone `npx tsx` tests with `node:assert/strict` following the applikasjoner `queries.test.ts` pattern (Jest ignores `src/mocks/**` by config). Coverage: fixture invariants, persona-synlighet (both personas), filter (all six fields), sortering + tie-break (both directions), paginering past 50 (root and nested, no duplicates/gaps), filter-/modal-sources, full/delvis/total mutation outcomes with per-element årsaker, and the frys/reaktiver cycle.

### 9. `src/mocks/personbrukere/teardown-personbrukere.md` (89 lines)

Teardown doc after the `teardown-applikasjoner.md` template: pre-flight operation/type checklist, the three open GraphQL questions as explicit checkpoints (envelope form, tilgangskode/rollekode keys + arbeidsverdi-rollekoder, source-tagging of tilganger), consumer-migration recipe, scaffold removal, codegen-exclusion notes, env-var removal and verification steps. Also documents the mock simplification that reaktivering sets ALL tildelinger AKTIV (utløpt-nuance is backend responsibility).

## Files Modified

### 1. `src/mocks/handlers.ts`

Registers `personbrukereHandlers` in `ALL_HANDLERS`, gated behind `NEXT_PUBLIC_ENABLE_PERSONBRUKER_MOCKS`. Follows the repo's documented `ENABLE_*` convention: ON unless explicitly set to `false` (build-time var; restart `npm run dev` to toggle). Comment points at the teardown doc.

## Key Features Implemented

### ✅ Reference SDL for Op #1–#7 (input to subgraph-plan)

Whole GraphQL section realised verbatim, self-explanatory docstrings, skeleton types identical to applikasjoner.

### ✅ Persona-based visibility (server-side rule in the mock)

`brukeradministrator` sees only personbrukere (and tildelinger) at own orgs; `super_brukeradministrator` sees everything. Counts and derived `organisasjoner` re-derived from the persona-filtered sets.

### ✅ Delvis suksess (BRU-PER-GRU-003)

Success variants carry `tildelte`/`fjernede` + `avviste: TildelingAvvist[]` with kode/navn/arsak/feilmelding per element; all five `TildelingAvvistArsak` values are reachable via fixture triggers.

### ✅ Frys-semantikk (BRU-PER-GRU-004)

Deaktiver → status DEAKTIVERT, all tildelinger INAKTIV (kept, not removed), kan*-flags flip; reaktiver reverses. Tildel/fjern on a deactivated user → total UGYLDIG_TILSTAND.

### ✅ Pagination past 50, both levels

77 visible personbrukere at the root; `pb-paginering-stress` with 60 tilganger on the nested connection. Fixed a latent off-by-one from the applikasjoner template: `after` now means "start AFTER the cursor" (Relay semantics), verified by no-overlap tests.

## Project skills consulted

- **fs-admin-mock-api-with-data** (blocking, consulted before writing code): followed its workflow — API shape from the plan's SDL, stack detection (MSW + `src/mocks/`), type-varied fixture generation (all enum values, nullable/empty/long-string cases, cross-tenant visibility seeding pattern), fixed mutation-behavior rules (in-memory store for entity/nested-connection mutations), teardown doc written up front, and its known-pitfalls reference (operation-name fidelity, no mock leakage outside `src/mocks/`, single env-var gate, build-time env caveat, Pitfall #11 noted in teardown for future consumer tasks).
- **graphql-consumer**: not applicable to this task's code — Task #1 writes no consumer-side `gql` operations (those come in Tasks #3–#9); the SDL is producer-shaped reference material specified normatively by the plan.

## Test Results

- `npx tsx src/mocks/personbrukere/handlers/queries.test.ts` → **42 pass, 0 fail** (persona-synlighet, filter ×6, sortering + tie-break begge retninger, paginering root/nested, filter-/modal-kilder)
- `npx tsx src/mocks/personbrukere/handlers/mutations.test.ts` → **15 pass, 0 fail** (full/delvis/total suksess for tilganger og roller, sporing, frys/reaktiver-syklus)
- `npm test` → **213 suites / 1758 tests pass** (the global coverage-threshold notice on full runs is pre-existing; enforcement is per-branch via `test:sincemain`, and `src/mocks/**` is excluded from both test discovery and coverage)
- `npm run test:typecheck` → clean (earlier errors in `src/domains/soknadsbehandling/` were stale local codegen output, resolved by `npm run compile`; none related to this task)

## Technical Decisions

### 1. Persona as a parameter with a fixed `AKTIV_PERSONA` default

**Why**: The plan requires persona-based visibility "som `filterTilgangerForPersona`". Making every builder take `persona: MockPersona = AKTIV_PERSONA` keeps the handlers fixed per session (no runtime switching, per the mock skill's rules) while letting tests exercise both `brukeradministrator` and `super_brukeradministrator` without global state.

### 2. Nested tildelinger are persona-filtered too

**Why**: Plan § Tverrgående — Permission-modell prescribes persona-filtrering in the style of `filterTilgangerForPersona`. A brukeradministrator therefore sees only tildelinger at own orgs even on visible mixed-org users, and `totalCount`/`antall*`/`organisasjoner` reflect that (demonstrable via `pb-mixed-orgs`).

### 3. Per-element rejection triggers live in the catalogs (`sperret`/`utgatt`)

**Why**: The acceptance criterion requires "minst ett element som gir avvisning ved tildel/fjern". Catalog flags plus natural rules (ALLEREDE_TILDELT, IKKE_TILDELT, kanFjernes=false) make every `TildelingAvvistArsak` value reachable from the UI, so Task #6/#8 can demo delvis suksess end-to-end without magic strings (one applikasjoner-style trigger-id `MANGLER_RETTIGHET` kept for total-avvisning parity).

### 4. Relay-correct `after` semantics (deviation from the applikasjoner template)

**Why**: The template's `paginate` starts AT the `after` offset while `endCursor` is the cursor OF the last item — fetchMore would duplicate one row per page. The personbrukere `paginate` starts AFTER the cursor; the no-overlap pagination tests would have caught the template behavior (they did, during development).

### 5. Env-var gate defaults ON (`!== 'false'`)

**Why**: Matches the repo's documented `ENABLE_*` convention in CLAUDE.md, and the plan's success criteria require the feature to be demonstrable in review environments where the var will not be set. Opt-out via `NEXT_PUBLIC_ENABLE_PERSONBRUKER_MOCKS=false`; build-time caveat documented in the gate comment and teardown doc.

### 6. Handler tests as standalone `npx tsx` scripts

**Why**: `jest.config.ts` has `testPathIgnorePatterns: ['mocks', ...]` — the applikasjoner mock established this exact pattern (`queries.test.ts` header documents it), and the plan's acceptance criterion names that pattern as the template.

## Build Status

✅ **`npm run compile` unaffected** — codegen succeeds; `src/mocks/**` remains excluded via the existing `'!src/mocks/**/*'` entry; no tracked generated files changed
✅ **No new linter errors or warnings** — `npx eslint src/mocks/personbrukere src/mocks/handlers.ts` is clean; full `npm run lint` now reports 0 errors (260 pre-existing warnings elsewhere, down from 279 during development)
✅ **All imports resolved correctly** — `tsc --noEmit` clean; Prettier check clean

## Integration Points

- **`src/mocks/handlers.ts` → `MockProvider`/`browser.ts`**: the personbrukere handlers ride the existing MSW scaffold (worker mounts in dev/review/test via the `mock-applikasjon-enabled` override); no scaffold changes were needed.
- **Tasks #3–#9 (consumer hooks/components)**: the 8 query + 6 mutation operation names in `handlers/queries.ts`/`mutations.ts` are the frozen contract; stable fixture IDs (`pb-paginering-stress`, `pb-deaktivert-frossen`, `pb-mixed-orgs`, …) are pin-able in integration tests (Task #10).
- **fs-plattform subgraph-plan (pipeline step 4)**: `schema/personbrukere.graphql` is the hand-off artifact; open questions are tracked in the teardown doc.

## Acceptance Criteria Met

- ✅ `schema/personbrukere.graphql` realises the whole GraphQL section with applikasjoner-style header — Evidence: src/mocks/personbrukere/schema/personbrukere.graphql:1-29 (header), full Op #1–#7 coverage
- ✅ `fixtures/` — 84 personbrukere (77 synlige > 50), tildelinger with `tildeltAv`/`tildeltTidspunkt`, organisasjoner, miljøer demo/prod, roller with arbeidsverdi-rollekoder, deaktivert bruker with INAKTIVE tildelinger (`pb-deaktivert-frossen`), rejection-triggering elements (`SPERRET-TILGANG`, `sperret_testrolle`, `UTGATT-*`, kanFjernes=false) — Evidence: fixtures/personbrukere.ts + `verifyFixtureCounts()`; queries.test.ts "fixture-forutsetninger"
- ✅ `store/personbrukereStore.ts` — mutable in-memory state with `resetStore()`, applikasjonerStore pattern — Evidence: src/mocks/personbrukere/store/personbrukereStore.ts:38-46
- ✅ `handlers/queries.ts` — all 6 schema queries (8 operation names) with two-fritekst filter, status/org/rolle/miljø, NAVN_ASC/DESC + feideId tie-break, pagination, persona visibility — Evidence: queries.test.ts, 42 passing tests
- ✅ `handlers/mutations.ts` — all 6 mutations incl. per-element-avvisning and frys-semantikk — Evidence: mutations.test.ts, 15 passing tests
- ✅ Handler tests after the `queries.test.ts` pattern (filter, sortering, tie-break, paginering, delvis suksess, persona-synlighet) — Evidence: `npx tsx` runs above
- ✅ Wired into `src/mocks/handlers.ts` gated behind `NEXT_PUBLIC_ENABLE_PERSONBRUKER_MOCKS` — Evidence: src/mocks/handlers.ts:19-24
- ✅ `teardown-personbrukere.md` after the applikasjoner template incl. the three open questions as checkpoints — Evidence: src/mocks/personbrukere/teardown-personbrukere.md § "Open questions"
- ✅ `npm run compile` unaffected — Evidence: successful run, no working-tree changes to generated files

## Next Steps

- Task #2 (feature flag, routes, navigation) can proceed in parallel; Tasks #3–#9 consume these operation names via transitional `gql` hooks (remember the codegen feature-folder exclusion — Pitfall #11 — when the first consumer `gql` document lands).
- Hand the SDL to the subgraph-plan step (alfred copies `*.graphql` into the task folder).
- Optional live smoke test: `npm run dev` and issue a `personbrukere` operation against `/api/graphql` once a consumer exists (no consumer code exists yet by design).

## Conclusion

The complete mock API surface for grunnleggende brukeradministrasjon is in place, tested and gated. Frontend tasks #2–#9 are unblocked, the operation-name contract is frozen, and teardown is documented with the subgraph-plan checkpoints.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
