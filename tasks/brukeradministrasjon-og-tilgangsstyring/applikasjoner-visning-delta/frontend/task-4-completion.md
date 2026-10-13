# Task #4 Completion Report: Utvid `applikasjonMedTilganger`-query med filter-kilder og refaktorer tilganger-tab-filter

## Status: COMPLETED

**Date Completed**: 2026-06-19
**Task**: Utvid `applikasjonMedTilganger`-query med filter-kilder og refaktorer tilganger-tab-filter
**Priority**: High
**Size**: M

## Summary

Implemented **variant (b)** from the plan's design-choice AC: introduced a new lean Apollo hook `useGetApplikasjonTilgangerFilterOptions(applikasjonId)` with its own operation name `applikasjonTilgangerFilterOptions`, fetching only `tilgangerMiljoer { kode, navn }` and `tilgangerOrganisasjoner { id, navn }` from `applikasjon(id)`. The tab-container `ApplikasjonTilganger.tsx` now calls this hook and prop-drills `miljoer`/`organisasjoner`/`loading` down to `ApplikasjonTilgangerFilter`, which in turn prop-drills to the two filter children. The two child filter components (`ApplikasjonTilgangerMiljoFilter`, `ApplikasjonTilgangerOrganisasjonFilter`) are now props-driven — the hardcoded `[demo, prod]`-constant and the `useGetMineApplikasjonsAdminOrganisasjoner`-import are gone. Mock-API is extended with one new handler that shares the `toWire()`-projection with the existing `applikasjon`-handler.

## Files Created

### 1. `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/hooks/useGetApplikasjonTilgangerFilterOptions.tsx` (90 lines)

New TRANSITIONAL Apollo hook for the tilganger-tab filter-source fields. Mirrors the existing `useGetMineSynlige*`-hook pattern (flat `gql` from `@apollo/client`, manual types, `fetchPolicy: 'cache-first'`). Operation name is **`applikasjonTilgangerFilterOptions`** — distinct from `applikasjonMedTilganger` (required by graphql-codegen's no-duplicates rule, per plan-doc Implementation Notes). Returns `{ miljoer, organisasjoner, loading, error }` with `[]` defaults so consumers always have a non-null iterable. Skips the query when `applikasjonId` is falsy.

## Files Modified

### 1. `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/hooks/useGetApplikasjonTilgangerTypes.ts`

Added `tilgangerMiljoer?: ApplikasjonTilgangerListMiljo[]` and `tilgangerOrganisasjoner?: ApplikasjonTilgangerListOrganisasjon[]` as **optional** fields on `ApplikasjonTilgangerOwner`. Optional (not required) because the existing `applikasjonMedTilganger`-selection-set does NOT include these fields — they're owned by the sibling `applikasjonTilgangerFilterOptions`-operation introduced in this task. The shared `Applikasjon:id`-cache-entry is what bridges the two operations. The JSDoc explicitly documents this.

### 2. `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/ApplikasjonTilganger.tsx`

Tab-container now calls `useGetApplikasjonTilgangerFilterOptions(applikasjonId)` and prop-drills `miljoer`/`organisasjoner`/`loading` into `<ApplikasjonTilgangerFilter />` (the `filter` slot of `DetailPageContentFilterAndResult`). Updated JSDoc accordingly.

### 3. `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/components/ApplikasjonTilgangerFilter/ApplikasjonTilgangerFilter.tsx`

Composite filter now accepts new optional props `miljoer`, `organisasjoner`, `loading` (all defaulted: `[]` / `[]` / `false`), and prop-drills them to `ApplikasjonTilgangerMiljoFilter` and `ApplikasjonTilgangerOrganisasjonFilter`. The default values mean the composite still renders cleanly in chip-mode contexts where options aren't yet wired (e.g. the test re-uses for chip-mode without an Apollo provider).

### 4. `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/components/ApplikasjonTilgangerFilter/filter/ApplikasjonTilgangerMiljoFilter/ApplikasjonTilgangerMiljoFilter.tsx`

Removed the hardcoded `options: MiljoOption[] = [...]`-constant. Now takes `miljoer: ApplikasjonTilgangerListMiljo[]` + `loading: boolean` as new required props, builds `options` from `miljoer.map((m) => ({ value: m.kode, label: m.navn }))`. Added `disabled={loading || options.length === 0}` on the Select per `fs-admin-inputs` §10/§D. Removed the `MiljoOption` local interface (now anonymous inline type, consistent with the organisasjon-filter). Updated JSDoc: removed "Options are kept inline (demo / prod) — same as `ApplikasjonerMiljoFilter`"-text; replaced with content-utledet rolle-filtrert source description.

### 5. `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/components/ApplikasjonTilgangerFilter/filter/ApplikasjonTilgangerOrganisasjonFilter/ApplikasjonTilgangerOrganisasjonFilter.tsx`

Removed `import { useGetMineApplikasjonsAdminOrganisasjoner }`. Now takes `organisasjoner: ApplikasjonTilgangerListOrganisasjon[]` + `loading: boolean` as new required props. Updated JSDoc: removed "Reuses the same hook as the list-page filter"-text; replaced with content-utledet semantic description that explicitly distinguishes from both `mineApplikasjonsAdminOrganisasjoner` (redigeringsrett) and `mineSynligeOrganisasjoner` (rolle-utledet innsynsscope used by list-page filter).

### 6. `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/components/ApplikasjonTilgangerResultList/ApplikasjonTilgangerResultList.tsx`

Now also calls `useGetApplikasjonTilgangerFilterOptions(applikasjonId)` and threads `miljoer`/`organisasjoner`/`loading` into `<ApplikasjonTilgangerFilter renderAsChips ... />` in the `filterElement`-slot of the `ActionList`. This ensures chip-mode chips resolve human-readable labels (`miljo.navn` / `organisasjon.navn`) via the same source-of-truth as the sidebar filter. Apollo's normalized cache dedupes the call across the tab-container and the result-list, so cold-cache cost is one round-trip total.

### 7. `src/mocks/applikasjoner/handlers/queries.ts`

Added `applikasjonTilgangerFilterOptionsHandler` that responds to the new operation name. Reuses the same `toWire(findApplikasjon(id))`-projection as the existing `applikasjon`-handler (shared-response pattern from the plan's Implementation Notes, mirroring how `applikasjonFjernbareTilganger` shares with `applikasjonMedTilganger`). Registered in `queryHandlers` array.

### 8. `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/components/ApplikasjonTilgangerFilter/filter/ApplikasjonTilgangerMiljoFilter/ApplikasjonTilgangerMiljoFilter.a11y.test.tsx`

Updated to pass `miljoer` and `loading` props explicitly. Removed Apollo provider (not needed — the component is now pure props-driven). Added a third test case ("when disabled (loading, empty options)") to cover the new disabled-state semantic.

### 9. `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/components/ApplikasjonTilgangerFilter/filter/ApplikasjonTilgangerOrganisasjonFilter/ApplikasjonTilgangerOrganisasjonFilter.a11y.test.tsx`

Updated to pass `organisasjoner` and `loading` props explicitly. Removed `MockedProvider` + `GET_MINE_APPLIKASJONS_ADMIN_ORGANISASJONER`-mock (the hook is gone). Added a third test case ("when disabled").

### 10. `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/components/ApplikasjonTilgangerFilter/ApplikasjonTilgangerFilter.test.tsx`

Updated all test cases to pass `miljoer`/`organisasjoner`/`loading` props explicitly. Removed `MockedProvider` + `GET_MINE_APPLIKASJONS_ADMIN_ORGANISASJONER`-mock (the composite no longer fetches anything itself). Added two new test cases:
- "disables the miljø-select when no options are available" — verifies the §10/§D `disabled` semantic.
- "disables both miljø and organisasjon selects while filter-options are loading" — verifies loading-state propagation through both child filters.

The remaining 5 original tests (`full-inputs mode`-3, `chip mode`-2) are kept but now run synchronously without Apollo round-trips, which is faster and more direct.

### 11. `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/ApplikasjonTilganger.a11y.test.tsx`

Added `filterOptionsMock` for the new `GET_APPLIKASJON_TILGANGER_FILTER_OPTIONS`-operation. Removed `GET_MINE_APPLIKASJONS_ADMIN_ORGANISASJONER`-mock and its import (no longer called from this component tree).

### 12. `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/components/ApplikasjonTilgangerResultList/ApplikasjonTilgangerResultList.test.tsx`

Replaced the `orgsMock` (pointing at the now-unused `GET_MINE_APPLIKASJONS_ADMIN_ORGANISASJONER`) with `filterOptionsMock` (pointing at the new `GET_APPLIKASJON_TILGANGER_FILTER_OPTIONS`). The result-list itself now calls this query, so the mock has a real caller.

## Key Features Implemented

### Content-utledet filter-options via server-side derived fields

Per `Tilgjengelige miljøer i filter` and `Tilgjengelige organisasjoner i filter` (tilganger-tab variants) in `spec-changes-2026-06-16-b0e8de5.md`, the two filter Selects on the tilganger-tab now reflect the **actual miljøer/organisasjoner represented in the rolle-filtrerte tilgangs-listen for the current applikasjon** — not a hardcoded `[demo, prod]`-constant (miljø), and not the admin-org-set (organisasjon, which was semantically wrong). Mock-API derives both arrays server-side from the same rolle-filtered set as `Applikasjon.tilganger`-connection (per Task #1), so the autorisasjons-grense is consistent across the connection and the two derived fields.

### Lean, separate-hook design (variant b)

Filter-source data is fetched by `useGetApplikasjonTilgangerFilterOptions` — a small standalone hook with its own operation name. Three design wins:
1. `useGetApplikasjonTilganger` (the paginated connection hook wrapped via `useDataListQuery`) stays narrow — it still returns only `{ result, loading, hasNextPage, ... }`, not detail-page-level fields.
2. Apollo's normalized cache shares the `Applikasjon:id`-entry between the two operations — both calls (tab-container + result-list) hit cache after the first.
3. No new wiring needed in `useDataListQuery`; the filter-source query is fired exactly when needed.

### Props-driven filter children

Both `ApplikasjonTilgangerMiljoFilter` and `ApplikasjonTilgangerOrganisasjonFilter` are now pure props-driven — they take `miljoer`/`organisasjoner` + `loading` as props and have no hook calls. This is testable in isolation without Apollo providers (see the simplified a11y tests). Matches the contract from `fs-admin-list-filters` (children of `FilterWrapper` are minimal: `value`, `onChange`, `renderAsChip`, plus their data).

### Disabled-state semantic per fs-admin-inputs §10/§D

Both filter Selects now `disabled={loading || options.length === 0}`. When the filter-options query is in flight, the Selects are disabled until data arrives. When an applikasjon has no tilganger (or none visible to the current persona), the options are an empty array and the Selects stay disabled — there's nothing to filter on, so the user can't accidentally apply a no-op filter.

### `Regel: Synlighet for tilganger` (frontend data-flow confirmed)

Per the AC, this rule is server-side (`Applikasjon.tilganger`-resolver rolle-filter, already mocked in Task #1). The frontend has **no UI signal** and no new behavior. Task #4 confirms the data-flow contract: the two derived fields (`tilgangerMiljoer` / `tilgangerOrganisasjoner`) consume the same rolle-filtered set as the connection, so what the user sees in the filter dropdowns matches what they see in the list. No information leaks between persona-scopes.

## Project skills consulted

- **`graphql-consumer`** (invoked via `Skill`-tool): The skill establishes fragment-colocation + codegen as the default for new operations. Plan-doc decision #6 explicitly authorizes a TRANSITIONAL deviation here — `useGetApplikasjonTilgangerFilterOptions.tsx` mirrors the exact TRANSITIONAL pattern from Task #2's `useGetMineSynlige*`-hooks (flat `gql` from `@apollo/client`, manual types, comment-block with explicit migration steps). Operation name follows skill §3 (PascalCase / SCREAMING_SNAKE_CASE constants + lowerCamelCase operation name on the server side). Skill §11 mandated `fetchPolicy: 'cache-first'` for the default — applied here. Skill's "operation name must be unique" rule from §3 + the plan-doc's note about graphql-codegen rejecting duplicates → drove the choice of operation name `applikasjonTilgangerFilterOptions` (distinct from `applikasjonMedTilganger`).

- **`fs-admin-detail-pages`** (invoked via `Skill`-tool): Confirmed the canonical layout (the tab-container `ApplikasjonTilganger.tsx` already uses `DetailPageContentFilterAndResult` per rule §6 — unchanged). The tab-container is the right place to fetch entity-scoped data and prop-drill into the filter slot (consistent with the data-fetching-hook pattern). Verified that adding the new hook call doesn't break the rule §6 layout contract (`filter` slot is still `<ApplikasjonTilgangerFilter />`; the prop-drilled options are arguments to that filter component, not a new layout slot).

- **`fs-admin-list-filters`** (invoked via `Skill`-tool): Confirmed the dual-render contract (`renderAsChips` chip-mode + full-input mode) is preserved through the new props. The new `miljoer`/`organisasjoner` props go to children alongside the existing `renderAsChip`-prop — children's signature stays minimal as the skill requires. The `getLabel(value)` chip-rendering pattern is unchanged. The skill's "composite-wide audit"-step prompted me to also wire the chip-mode usage inside `ApplikasjonTilgangerResultList`'s `filterElement` (calling the hook there as well), so chips resolve human-readable labels in both render modes.

- **`fs-admin-inputs`** (loaded via the `fs-admin-list-filters`-companion note): §10/§D — `disabled={loading || options.length === 0}` on both Selects, matching Task #3's identical wiring on the listevisning-filter.

## Test Results

### Touched a11y tests

```
$ npx jest --config=jest.a11y.config.ts --testPathPatterns="ApplikasjonTilganger"

Test Suites: 9 passed, 9 total
Tests:       23 passed, 23 total
```

All 23 a11y tests across 9 suites green — including the two updated filter a11y tests with their new third "disabled when loading + empty options"-test case.

### Touched unit tests

```
$ npm test -- --testPathPatterns="ApplikasjonTilganger"

Test Suites: 7 passed, 7 total
Tests:       59 passed, 59 total
```

All 59 unit tests green, including:
- 5 (original) + 2 (new) tests in `ApplikasjonTilgangerFilter.test.tsx` — both new tests verify the §10/§D disabled-state semantic.
- 6 tests in `ApplikasjonTilgangerResultList.test.tsx` — all green with the new `filterOptionsMock` replacing the dead `orgsMock`.
- 4 tests in `useGetApplikasjonTilganger.test.tsx` — unaffected by my changes.

### Mock-API tests

```
$ npx tsx src/mocks/applikasjoner/handlers/queries.test.ts

16 pass, 0 fail
```

All 16 pre-existing mock-handler tests (Task #1) still pass — I only added one new handler, didn't modify the test-covered ones.

### Broader tilgangsstyring suite

```
$ npm test -- --testPathPatterns="src/domains/tilgangsstyring"

Test Suites: 1 failed, 20 passed, 21 total
Tests:       1 failed, 151 passed, 152 total
```

151/152 grønne. The 1 failure is `ApplikasjonPassord.test.tsx › drops the password from the DOM when the result dialog is closed via "Lukk"` — **pre-existing** on `applications-and-application-detail-delta`-branch, documented in Task #1/#2/#3 completion reports. Not introduced by this task.

```
$ npx jest --config=jest.a11y.config.ts --testPathPatterns="src/domains/tilgangsstyring"

Test Suites: 25 passed, 25 total
Tests:       57 passed, 57 total
```

All 25 tilgangsstyring a11y suites (57 tests) green.

## Technical Decisions

### 1. Variant (b) chosen over variant (a) — separate hook with its own operation

**Decision**: Introduce `useGetApplikasjonTilgangerFilterOptions(applikasjonId)` with operation name `applikasjonTilgangerFilterOptions`, distinct from `applikasjonMedTilganger`.

**Why**:
1. **Plan recommends (b) explicitly.** The AC says "Anbefalt: (b)". No hard reason found in the code to override that recommendation.
2. **Separation of concerns.** `useGetApplikasjonTilganger` is wrapped via `useDataListQuery` and returns the standard pagination shape (`{ result, loading, hasNextPage, ... }`). It does not expose raw `data`. Extending its selection-set with two Applikasjon-level fields would force one of two ugly outcomes: either expose `data` on the hook's return shape (breaks the `useDataListQuery`-abstraction), or add a side-channel for these fields (a second hook anyway). Variant (b) avoids both.
3. **Apollo cache sharing.** Both operations select `id` on the same `Applikasjon`-node; Apollo's normalized cache stitches them on `id + __typename`. After the first round-trip, the second consumer reads from cache.
4. **Filter-source data is structurally different from connection data.** The two derived fields are bounded sets (typically ≤10 organisasjoner, ≤5 miljøer per applikasjon, per plan §GraphQL-endringer Op #3-#4 Lag C). They're not paginated. Coupling them to a paginated connection query would conflate two different data shapes.

**Alternative considered**: Variant (a) — extend the existing `applikasjonMedTilganger`-selection-set with the two new fields and prop-drill from `ApplikasjonTilgangerResultList` upward to `ApplikasjonTilganger` and across to `ApplikasjonTilgangerFilter`. Rejected because (a) it requires lifting state up across three components vs. (b)'s one-hop call from the tab-container, and (b) Apollo's `useDataListQuery`-wrapped return shape doesn't expose raw `data` on its return.

### 2. Both tab-container AND result-list call `useGetApplikasjonTilgangerFilterOptions`

**Why**: Chip-mode usage inside the result list (`<ApplikasjonTilgangerFilter renderAsChips />`) needs the same `miljoer`/`organisasjoner`-arrays so `getLabel(value)` can resolve human-readable chip labels. Apollo's normalized cache deduplicates the call (same operation + same variables = single network hit). Two cleaner-looking alternatives — passing options down through the result-list props, or passing them up via the layout — would either require lifting state up further or coupling unrelated components. The double-call-with-cache-dedup approach is the idiomatic Apollo pattern for "two siblings need the same data" and matches how `useGetApplikasjon` is called in multiple places throughout the detail-page.

### 3. `tilgangerMiljoer` / `tilgangerOrganisasjoner` are **optional** on `ApplikasjonTilgangerOwner`, not required

**Why**: The AC says "utvidet med `tilgangerMiljoer: ApplikasjonTilgangerListMiljo[]` og `tilgangerOrganisasjoner: ApplikasjonTilgangerListOrganisasjon[]` på `ApplikasjonTilgangerOwner`-interfacet" — but the AC was written generically across both variants. In variant (b) the existing `applikasjonMedTilganger`-operation does NOT select these fields; only the new `applikasjonTilgangerFilterOptions`-operation does. Typing them as required on `ApplikasjonTilgangerOwner` would force the connection-query result-shape mocks to provide them as a TypeScript lie. Optional captures the contract honestly — Apollo's normalized cache may yet populate them on the `Applikasjon:id`-entry via the sibling operation, but the connection-query's result-typing doesn't promise they're present. The JSDoc on the interface documents this explicitly so future readers don't try to "fix" the optional to required.

### 4. Mock-handler reuses `toWire()` projection from the `applikasjon`-handler

**Why**: The new `applikasjonTilgangerFilterOptions`-handler must return the same rolle-filtered `tilgangerMiljoer` / `tilgangerOrganisasjoner` as the existing `applikasjon`-handler — they're projections of the same in-store state. Calling `toWire(findApplikasjon(id))` is the one-liner that gives this for free, and it's the same pattern `applikasjonFjernbareTilganger` already uses for sharing logic with `applikasjonMedTilganger`. No new helper function needed.

### 5. Default props on `ApplikasjonTilgangerFilter` (`miljoer = []`, `organisasjoner = []`, `loading = false`)

**Why**: The composite filter is rendered in two contexts — tab-container (with props supplied) and result-list (with props supplied). Both wire the hook. Defaults are a safety net: if a future test or storybook renders `<ApplikasjonTilgangerFilter />` without these props, the component still works — chip-mode resolves to value-as-label (the same fallback `getLabel(value)` has used since day one). The defaults don't mask bugs; they make the props *opt-in* for parents that don't yet wire them, which is consistent with the gradual-rollout TRANSITIONAL spirit of this entire delta.

### 6. New unit-test cases for §10/§D disabled-state semantic

**Why**: The previous `ApplikasjonTilgangerFilter.test.tsx` had no test for the disabled-state — the hardcoded `[demo, prod]`-constant meant `options.length === 0` was unreachable. With props-driven options, both the empty-options case and the loading-case are now reachable, and the AC explicitly mandates the `disabled={loading || options.length === 0}`-semantic. Two new test cases lock the contract in.

## Build Status

- **`npm run test:typecheck`** — 23 pre-existing errors (same count as Task #1, #2, #3 reports). **0 new errors** from my changes; verified via `npm run test:typecheck 2>&1 | grep -E "tilgangsstyring|src/mocks/applikasjoner"` returning empty.
- **`npm run lint:ts`** — 0 errors, 242 warnings (was 241 in Task #3). **+1 warning** from the new TRANSITIONAL `gql`-import in `useGetApplikasjonTilgangerFilterOptions.tsx` — expected per plan decision #6.
- **A11y tests (touched)** — 23/23 green across 9 suites.
- **Unit tests (touched)** — 59/59 green across 7 suites.
- **Mock-API tests** — 16/16 green.
- **Full tilgangsstyring a11y suite** — 25/25 suites, 57/57 tests green.
- **Full tilgangsstyring unit suite** — 151/152 green (1 pre-existing failure documented in prior reports).
- **`npm run build`** not run — would take several minutes for a delta-iteration touching 7 source files + 5 test files. All build-relevant gates (typecheck, lint, all relevant test-suites) are individually green for the modified files.

## Integration Points

- **`src/mocks/applikasjoner/handlers/queries.ts`** (Task #1): the new `applikasjonTilgangerFilterOptions`-handler is live in the `queryHandlers`-array. Reuses `toWire()` so `tilgangerMiljoer` / `tilgangerOrganisasjoner` come from the same rolle-filtered set as `Applikasjon.tilganger`.
- **`src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/`** (this task's scope): all wiring is internal to this folder + its `hooks/`. No upstream callers (`ApplikasjonDetails.tsx`, route-level pages) need changes.
- **Apollo cache** (analyse-beslutning #4): no new invalidation needed. `usePersonaOverride.applyPersonaChange` already wipes the cache on persona-bytte, dropping both `applikasjonMedTilganger` and `applikasjonTilgangerFilterOptions` consistently — they refetch with the new persona's rolle-filter on next read.
- **`Applikasjon.fields.tilganger`** cache-key in `cacheConfig.ts` is unchanged (verified via `git diff --stat src/common/lib/apollo/cacheConfig.ts` returning empty). The key-args are still `['filter', 'orderBy']` — rolle-filter is a server-side autorisasjons-grense, not a query-argument, so it doesn't need to participate in the cache-key.
- **Producer team (cross-contributor)**: the schema-skisser in plan-doc § GraphQL-endringer Op #3-#4 reflect what this mock implements. Backend can diff against the mock as "live spec".

## Acceptance Criteria Met

- **Designvalg avklart i kode-review: variant (b)** — see Technical Decision #1.
  Evidence: New hook file `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/hooks/useGetApplikasjonTilgangerFilterOptions.tsx` exists with operation name `applikasjonTilgangerFilterOptions`. The existing `useGetApplikasjonTilganger.tsx` is unchanged.

- **`useGetApplikasjonTilgangerTypes.ts` utvidet med `tilgangerMiljoer` og `tilgangerOrganisasjoner` på `ApplikasjonTilgangerOwner`-interfacet**.
  Evidence: `useGetApplikasjonTilgangerTypes.ts:115-120` (the two new fields, with JSDoc explaining why they're optional per the variant-(b) design — see Technical Decision #3).

- **Ny operasjon (variant b) henter `tilgangerMiljoer { kode, navn }` og `tilgangerOrganisasjoner { id, navn }` fra `applikasjon(id)`**.
  Evidence: `useGetApplikasjonTilgangerFilterOptions.tsx:46-60` (the `GET_APPLIKASJON_TILGANGER_FILTER_OPTIONS`-document), `src/mocks/applikasjoner/handlers/queries.ts:300-307` (the matching mock-handler).

- **`ApplikasjonTilganger.tsx` (tab-container): henter filter-options + loading, prop-driller dem til `ApplikasjonTilgangerFilter`**.
  Evidence: `ApplikasjonTilganger.tsx:40-44` (`useGetApplikasjonTilgangerFilterOptions(applikasjonId)`-call), `:47-53` (prop-drill to `<ApplikasjonTilgangerFilter miljoer={...} organisasjoner={...} loading={...} />`).

- **`ApplikasjonTilgangerFilter.tsx`: tar inn nye props `miljoer`, `organisasjoner`, `loading`; prop-driller videre til de to filter-barna**.
  Evidence: `ApplikasjonTilgangerFilter.tsx:20-39` (the new props on `ApplikasjonTilgangerFilterProps`), `:80-86` (prop-drill to `ApplikasjonTilgangerMiljoFilter`), `:89-94` (prop-drill to `ApplikasjonTilgangerOrganisasjonFilter`).

- **`ApplikasjonTilgangerMiljoFilter.tsx`: hardkodet `[demo, prod]`-konstant fjernet; `miljoer, loading` brukes fra props. `disabled={loading || options.length === 0}`**.
  Evidence: `ApplikasjonTilgangerMiljoFilter.tsx:51` (`options = miljoer.map(...)` — no hardcoded constant), `:74` (`disabled={loading || options.length === 0}`).

- **`ApplikasjonTilgangerOrganisasjonFilter.tsx`: import av `useGetMineApplikasjonsAdminOrganisasjoner` fjernet; `organisasjoner, loading` brukes fra props**.
  Evidence: `ApplikasjonTilgangerOrganisasjonFilter.tsx` — `grep -c "useGetMineApplikasjonsAdminOrganisasjoner" /Users/mats.myhre/Dev/Sikt/fs-admin/src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/components/ApplikasjonTilgangerFilter/filter/ApplikasjonTilgangerOrganisasjonFilter/ApplikasjonTilgangerOrganisasjonFilter.tsx` returns 0. Hook + import gone; `options = organisasjoner.map(...)` (line 60).

- **TRANSITIONAL-kommentarer oppdatert i begge filter-komponentene**.
  Evidence: `ApplikasjonTilgangerMiljoFilter.tsx:31-44` — no longer mentions "Options are kept inline (demo / prod)"-text; replaced with content-utledet description. `ApplikasjonTilgangerOrganisasjonFilter.tsx:32-47` — no longer mentions "Reuses the same hook as the list-page filter"-text; replaced with content-utledet description that explicitly distinguishes from `mineApplikasjonsAdminOrganisasjoner` (redigeringsrett) AND `mineSynligeOrganisasjoner` (rolle-utledet innsynsscope used by list-page filter).

- **Eksisterende `*.a11y.test.tsx` for `ApplikasjonTilgangerMiljoFilter` og `ApplikasjonTilgangerOrganisasjonFilter` oppdatert til å sende inn `miljoer`/`organisasjoner`/`loading` props eksplisitt**.
  Evidence: Both a11y tests updated; both now pass `miljoer` / `organisasjoner` and `loading` props on every render call. Both have a new third test case ("disabled when loading + empty options"). Test results: 6/6 green across both files.

- **Manuell verifikasjon-prosedyre dokumentert** (browser-launch is out-of-scope for a subagent; I document the procedure for the user / Task #5):

  **For eier-admin scenario:**
  1. Start dev-server: `npm run dev` from `/Users/mats.myhre/Dev/Sikt/fs-admin/`.
  2. Open `http://localhost:3000/tilgangsstyring/applikasjoner/app-sikt-bibsys` (or any applikasjon whose eier-org is in `MINE_ADMIN_ORG_IDS` — typically `sikt`, `uio`, `ntnu`).
  3. Switch to "Tilganger"-tab.
  4. **Verify**: Miljø-filter dropdown shows ALL distinct miljøer represented in the applikasjon's tilganger (typically `Demo`, `Prod`, possibly others). Organisasjon-filter dropdown shows ALL distinct organisasjoner from the tilganger.
  5. **Verify**: Both dropdowns show "Alle miljøer" / "Alle organisasjoner" as the default-selected first option.

  **For kryss-org-admin scenario:**
  1. Open `http://localhost:3000/tilgangsstyring/applikasjoner/app-uib-cross-org` (an applikasjon eid av en organisasjon IKKE i `MINE_ADMIN_ORG_IDS`).
  2. Switch to "Tilganger"-tab.
  3. **Verify**: Miljø-filter dropdown shows ONLY miljøer represented in the rolle-filtered tilganger (i.e. tilganger whose `organisasjon.id ∈ MINE_ADMIN_ORG_IDS`). Same for organisasjon-filter.
  4. **Verify**: Both dropdowns are disabled if no rolle-filtrert tilgang has been returned (empty options-list).

  **Apollo-cache-check (DevTools)**:
  1. Open Apollo DevTools → Cache → search `Applikasjon:app-sikt-bibsys` (or whichever ID).
  2. **Verify**: The cache entry shows BOTH `tilganger`-connection AND `tilgangerMiljoer` + `tilgangerOrganisasjoner` arrays — fed from the two distinct operations into the same normalized entry. Apollo's cache stitches them by id.
  3. **Verify**: Switching persona (via the persona-override UI documented in Task #5) triggers `cache.reset` — re-opening the same applikasjon refetches both queries and the filter dropdowns reflect the new persona's scope.

  Data-path verification via test + mock-handler-read: confirmed by Task #1's unit tests (16/16 green, including `tilgangerMiljoer matcher distinkte miljøer i det rolle-filtrerte settet (eier-admin)` and `tilgangerOrganisasjoner matcher distinkte orgs i det rolle-filtrerte settet (kryss-org-admin)`). The mock-handler reads from the same `toWire()`-projection for both `applikasjon` and `applikasjonTilgangerFilterOptions`, guaranteeing the new operation returns the same rolle-filtered set the connection uses.

- **`Applikasjon.fields.tilganger` cache-key i `cacheConfig.ts` uendret (`['filter', 'orderBy']`)**.
  Evidence: `git diff --stat /Users/mats.myhre/Dev/Sikt/fs-admin/src/common/lib/apollo/cacheConfig.ts` returns empty — file not touched. The cache-key remains correct because rolle-filter is server-side (an autorisasjons-grense, not a query argument). Persona-bytte invalidates the cache via the existing `usePersonaOverride.applyPersonaChange`-mechanism (analyse-beslutning #4).

## Next Steps

- **Task #5** (cache-konsistens på tvers av rolle/persona-bytte): now unblocked. Both `applikasjonMedTilganger` and `applikasjonTilgangerFilterOptions` rely on the same `Applikasjon:id`-cache-entry, so the manual verification procedure described above covers both. Task #5 should add the new `applikasjonTilgangerFilterOptions`-operation to its persona-bytte verification list.

- **Task #6** (producer hand-off): can now cite the mock-implementation of the new operation as "live spec" for producer to diff against. The plan-doc's § GraphQL-endringer Op #3-#4 schema-skisser are unchanged — variant (b) is purely a consumer-side choice; the server-side fields are identical.

- **Future TRANSITIONAL migration** (when producer-schema lands): three TRANSITIONAL artifacts to migrate in one batch — the existing `useGetApplikasjonTilganger.tsx` + types, the new `useGetApplikasjonTilgangerFilterOptions.tsx` + its colocated types, and the `useGetMineSynlige*`-hooks from Task #2. All four use the same TRANSITIONAL-comment-block pattern with explicit migration steps, so the batch will be mechanical.

## Conclusion

The tilganger-tab filter is now fully content-utledet from the rolle-filtrerte tilgangs-listen for the current applikasjon, with both Selects disabled-while-loading per `fs-admin-inputs` §10/§D. Filter-source data flows through one lean hook (`useGetApplikasjonTilgangerFilterOptions`) that doesn't muddy the existing paginated connection hook. Apollo's normalized cache + Task #1's mock-API let the entire delta-end-to-end be verified locally without producer-rundtur. Tests are explicit about the props-driven contract (both a11y tests now pass props, both unit-test cases for the new disabled-state semantic are in place), and the cache-key invariant from the AC is verified unchanged.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
