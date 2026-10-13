# Task #7 Completion Report: PersonbrukerRoller — Roller-fane

## Status: ✅ COMPLETED

**Date Completed**: 2026-07-08
**Task**: PersonbrukerRoller — Roller-fane
**Priority**: Medium
**Size**: M

## Summary

Implemented the Roller-tab on the Personbruker detail page as a structural twin of the
Task #5 Tilganger-tab: own `PersonbrukerRoller/`-folder with tab-container
(`DetailPageContentFilterAndResult`), URL-synced state hook (prefix `roller.*`),
TRANSITIONAL query hook against operation `personbrukerMedRoller`, three child filters
(Navn/Status/Organisasjon), OrderBy, ActionList-based result list with rollenavn +
rollekode in the Navn-cell, and a kan\*-gated actionbar with disabled Tildel/Fjern-buttons
(modals come in Task #8). The `Personbruker.fields.roller`-connection is registered in
`cacheConfig.ts`, the temporary Roller-placeholder in `PersonbrukerDetails.tsx` is
replaced by the real component, and the detail-page tests are updated with
`personbrukerMedRoller`-mocks (SDS TabPanel mounts panels eagerly).

All paths below are relative to the fs-admin repo
(`/Users/mats.myhre/Dev/Sikt/fs-admin`).

## Files Created

All under `src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerRoller/`:

### 1. `PersonbrukerRoller.tsx` (74 lines)

Tab-container. Wires `DetailPageContentFilterAndResult`'s five slots to the
roller-specific filter, result list, actionbar and `useGetPersonbrukerRollerState`'s
`onReset`/`isModified`. Org-filter source and `kan*`-flags are prop-drilled from the lean
detail-query (`useGetPersonbruker`, Task #4) — no extra filter-options operation.

### 2. `PersonbrukerRoller.a11y.test.tsx` (119 lines)

jest-axe test for the whole tab with Apollo mocks for `personbruker` +
`personbrukerMedRoller` and the shared `cacheConfig`.

### 3. `hooks/useGetPersonbrukerRollerTypes.ts` (128 lines)

TRANSITIONAL manually-mirrored types for the `personbruker(id) { roller(...) }` contract
(node with `rollekode`, `PersonbrukerRollerConnection`, filter input, query
data/variables, re-declared `TildelingStatus`/`PersonbrukerTildelingerOrderBy` enums).
Documents the migration path for teardown.

### 4. `hooks/useGetPersonbrukerRollerState.tsx` (50 lines)

`useDataListState` with `roller.*`-prefixed URL keys (`roller.navn`, `roller.status`,
`roller.organisasjonId`, `roller.orderBy`), `initFirst: 50` — coexists with the
Tilganger-tab's `tilganger.*`-keys and the overview page's bare keys on the same URL.

### 5. `hooks/useGetPersonbrukerRollerState.test.tsx` (165 lines)

Unit tests: defaults, prefix non-collision (incl. against `tilganger.*`), URL read-back,
onFilterChange/onFirstChange/onOrderByChange/onReset, isModified.

### 6. `hooks/useGetPersonbrukerRoller.tsx` (122 lines)

TRANSITIONAL `gql` (from `@apollo/client`) query with operation name
`personbrukerMedRoller` (matches the MSW handler, Task #1), lean row field-set including
`rollekode`, wired through `useDataListQuery` with empty-string→null filter mapping and
`skip: !personbrukerId`.

### 7. `hooks/useGetPersonbrukerRoller.test.tsx` (305 lines)

Unit tests: default variables + paginated result shape, id-from-argument, URL-filter
mapping (empty→null), increased `first`, `hasNextPage`, skip on empty id.

### 8. `components/PersonbrukerRollerFilter/PersonbrukerRollerFilter.tsx` (91 lines)

Composite filter — single `FilterWrapper`, `FilterReset` as first chip in chip-mode,
`renderAsChip` propagated to all three children, spread-then-override `onFilterChange`.
No a11y test (carve-out: returns a single `FilterWrapper`).

### 9–14. Child filters under `components/PersonbrukerRollerFilter/filter/` (each in its own folder with a11y test)

- `PersonbrukerRollerNavnFilter/` — `TextInput` (no `type="search"`, `autoComplete="off"`), chip renders `null` when empty (49 + 41 lines)
- `PersonbrukerRollerStatusFilter/` — 2-value enum `Select` with «Alle statuser»-option (72 + 40 lines)
- `PersonbrukerRollerOrganisasjonFilter/` — `Select` with «Alle organisasjoner»-option, `disabled` while loading/empty options (84 + 72 lines)

### 15. `components/PersonbrukerRollerOrderBy/PersonbrukerRollerOrderBy.tsx` (46 lines)

Thin `OrderByButton`-wrapper adapting NAVN_ASC/NAVN_DESC to the `{ orderByField, direction }`
shape. No a11y test (carve-out).

### 16. `components/PersonbrukerRollerActionbar/PersonbrukerRollerActionbar.tsx` (67 lines)

«Tildel roller»/«Fjern roller» `FSButton`s gated on `kanTildeleRoller`/`kanFjerneRoller`
from the detail node; renders `null` when node is undefined or neither flag is set.
Buttons are `disabled` with `TODO(Task #8)`-comments until the modals exist.

### 17–18. Actionbar tests (97 + 59 lines)

Unit tests for all gating combinations plus the disabled-until-Task-#8 contract; a11y
tests for visible-buttons and null states.

### 19. `components/PersonbrukerRollerResultList/PersonbrukerRollerResultList.tsx` (156 lines)

Single `ActionList` (read-only rows) with all state props wired
(`message`/`loading`/`loadedCount`/`totalCount`/`hasNextPage`/`loadingMore`/`onLoadMore`),
`filterElement={<PersonbrukerRollerFilter renderAsChips …/>}`, `orderByElement`,
parent-provided `actionsElement`. Navn-cell stacks rollenavn (strong) +
`<ScreenReaderPause />` + rollekode; status tag `success`/`neutral` for AKTIV/INAKTIV;
Tildelt dato formatted from `tildeltTidspunkt`. No a11y test (carve-out).

### 20. `components/PersonbrukerRollerResultList/PersonbrukerRollerResultList.test.tsx` (246 lines)

Unit tests: full row content incl. rollekode, aktive/inaktive status-tags, empty state,
actionsElement-slot, «Last inn flere» URL-`first` increment.

## Files Modified

### 1. `src/common/lib/apollo/cacheConfig.ts`

Added `roller: nodesCursorPagination(['filter', 'orderBy'])` under `Personbruker.fields`
next to the existing `tilganger` registration; updated the TRANSITIONAL comment to cover
both tabs. Without this, «Last inn flere» would replace instead of append rows.

### 2. `src/domains/tilgangsstyring/features/PersonbrukerDetails/PersonbrukerDetails.tsx`

Replaced the temporary Roller-placeholder `Paragraph` with
`<PersonbrukerRoller personbrukerId={id} />`; removed the now-unused `Paragraph` import;
updated the doc-comment.

### 3. `src/domains/tilgangsstyring/features/PersonbrukerDetails/PersonbrukerDetails.test.tsx`

Added a `personbrukerMedRoller`-mock to the wrapper (SDS TabPanel mounts panels eagerly,
so the roller-query fires on page render). Rewrote the tabs-test: the Roller-tab now
asserts the real kan\*-gated actionbar buttons (visible + disabled until Task #8); the
Tilganger-assertion switched from the now-ambiguous `getByText('headerText')` (both list
tabs render it) to the tab-unique buttons.

### 4. `src/domains/tilgangsstyring/features/PersonbrukerDetails/PersonbrukerDetails.a11y.test.tsx`

Added the equivalent `ROLLER_MOCK` to the wrapper.

### 5. `src/common/messages/nb/domains.json`

Added namespaces `PersonbrukerRoller`, `PersonbrukerRollerFilter`,
`PersonbrukerRollerResultList` («Ingen roller funnet» + default filter suggestion),
`PersonbrukerRollerOrderBy`, `PersonbrukerRollerActionbar` («Tildel roller»/«Fjern
roller»), placed after the tilganger-modal cluster. Removed the orphaned
`PersonbrukerDetails.rollerPlaceholder` key.

## Key Features Implemented

### ✅ Roller-fane with filter and paginated list (BRU-PER-GRU-002)

Same filter- and column-set as the Tilganger-tab (Navn/Status/Organisasjon/Tildelt
av/Tildelt dato), NAVN_ASC/DESC sorting, «Last inn flere» with cache-safe append,
loading/empty/error states per list-results conventions.

### ✅ Rollenavn + rollekode in row cells (Task #7 AC, unlike the tilganger list)

Stacked in the Navn-cell with a single `ScreenReaderPause` between the two distinct
datapoints (per `fs-admin-list-results` §8).

### ✅ kan\*-gated actionbar

«Tildel roller»/«Fjern roller» gated on `kanTildeleRoller`/`kanFjerneRoller` — never on
rollekoder (plan Decision #7). Disabled with TODO(Task #8) until the modals land.

### ✅ No sharing with the Tilganger-tab (plan decision #2)

Own components, own hooks, own operation (`personbrukerMedRoller`), own TRANSITIONAL
type-file — deliberately duplicated rather than abstracted.

## Project skills consulted

- `fs-admin-detail-pages` — `DetailPageContentFilterAndResult` as the mandatory wrapper for a filter+list pair inside a tab (§6); no cross-family layout imports; the tab is the heading for the panel (no duplicate heading).
- `fs-admin-list-filters` — composite/child `renderAsChips`/`renderAsChip` contract, folder-per-child-filter with a11y test, spread-then-override onChange, URL-state hook, `FilterReset` as first chip (legacy form, mirroring the sibling tab), no a11y test for the composite (carve-out).
- `fs-admin-list-results` — `ActionList` for non-navigating rows, full state-prop wiring, `headerText`="Resultater"/`emptyText`="Ingen roller funnet"/default `emptyTextSuggestion`, inline row rendering (no `*ResultRow.tsx`), `ScreenReaderPause` only between datapoints in the same cell, carve-outs for ResultList/OrderBy a11y tests.
- `fs-admin-inputs` — noun-phrase labels («Navn», «Status», «Organisasjon»), `autoComplete="off"`, null-state options («Alle …»), `disabled` when options are loading/empty, no `type="search"`, no placeholder-as-label.
- `fs-admin-buttons` — `FSButton` default, verb-phrase labels via next-intl; destructive emphasis deferred to the Task #8 modal submit-button (mirroring the tilganger actionbar).
- `fs-admin-grid-and-flex` — `<Flex direction="row" gap="small" flexWrap="wrap">` for the button row; no raw `display: flex` anywhere in new code (no new CSS at all).
- `graphql-consumer` — deviation consciously mirrored: the TRANSITIONAL flat-query pattern (`gql` from `@apollo/client`, manual types) is the established pattern in this area («Ikke best practice — eksisterende mønster i området», plan Op #2 Lag C); colocation revisited at teardown. Relay-cursor consumption via `nodes`/`totalCount`/`pageInfo`.
- i18n conventions (`src/common/messages/CLAUDE.md`) — PascalCase component namespaces in `domains.json`, semantic camelCase keys, no hardcoded Norwegian strings, orphaned `rollerPlaceholder` key removed.

## Test Results

New/updated TypeScript test files (Jest + RTL, run via the project's Jest configs — not `node -e`):

- `.../PersonbrukerRoller/hooks/useGetPersonbrukerRollerState.test.tsx` — 8 tests
- `.../PersonbrukerRoller/hooks/useGetPersonbrukerRoller.test.tsx` — 6 tests
- `.../PersonbrukerRollerResultList/PersonbrukerRollerResultList.test.tsx` — 5 tests
- `.../PersonbrukerRollerActionbar/PersonbrukerRollerActionbar.test.tsx` — 6 tests
- a11y: `PersonbrukerRoller.a11y.test.tsx`, `PersonbrukerRollerActionbar.a11y.test.tsx`, 3 × child-filter `.a11y.test.tsx`
- Updated: `PersonbrukerDetails.test.tsx`, `PersonbrukerDetails.a11y.test.tsx`

Commands and results:

- `npm run test:typecheck` — ✅ pass
- `npm test -- --testPathPatterns "PersonbrukerDetails|PersonbrukerRoller"` — ✅ 14 suites, 91 tests passed
- `npm run test:a11y -- --testPathPatterns "PersonbrukerDetails|PersonbrukerRoller"` — ✅ 15 suites, 40 tests passed
- `npm run test:sincemain` — ✅ 53 suites, 349 passed / 3 skipped (pre-existing skips); coverage thresholds met
- `npm run lint` — ✅ 0 errors
- `npm run build` — ✅ production build succeeds
- Prettier — ✅ all changed files formatted

Note: the detail-page not-found test logs a benign Apollo `No more mocked responses`
console-warning for `id: "missing"` on the tildelings-queries during the loading window
(panels mount eagerly). This pre-existed for `personbrukerMedTilganger` since Task #5;
the roller-query now mirrors it symmetrically. Tests pass; not altered to stay in scope.

## Technical Decisions

### 1. Re-declared `TildelingStatus`/`PersonbrukerTildelingerOrderBy` enums in the roller type-file

**Why**: Plan decision #2 forbids sharing between the tabs; each TRANSITIONAL type-file
must be independently deletable at teardown. String-values are identical, so URL state
and wire format are interchangeable.

### 2. Actionbar buttons rendered but `disabled` (not hidden) when flags allow

**Why**: The Task #7 AC requires the buttons gated on `kanTildeleRoller`/`kanFjerneRoller`
with the modals deferred to Task #8 — same transitional shape the plan prescribed for
Task #5 («inntil da disabled med TODO»). Gating still hides buttons entirely when the
flags are false or the node hasn't loaded.

### 3. Rollenavn + rollekode stacked in one cell with a single `ScreenReaderPause`

**Why**: The AC requires both values in the row cells; two distinct datapoints inside the
same cell is exactly the case `fs-admin-list-results` §8 prescribes a pause for (mirrors
`EmnerResultList`'s kode+navn pattern) while keeping the five-column layout identical to
the Tilganger-tab.

### 4. Detail-page test assertions switched from `getByText('headerText')` to tab-unique buttons

**Why**: With both tildelings-tabs eagerly mounted, two list headers with the same
translated key exist in the DOM; `getByText` would throw on multiple matches. The
actionbar button names (`tildelTilganger` vs `tildelRoller`) are unique per tab.

## Build Status

✅ **Build successful** — `npm run build` (Next.js 16, webpack) completes; both
`/tilgangsstyring/personbrukere` routes present.
✅ **No new linter warning types** — 0 errors; the single new warning
(`no-restricted-imports` on `gql` from `@apollo/client` in `useGetPersonbrukerRoller.tsx`)
is the documented TRANSITIONAL pattern carried by every sibling personbruker/applikasjoner
mock-first hook, removed at teardown.
✅ **All imports resolved correctly** — typecheck clean.

## Integration Points

- `PersonbrukerDetails.tsx` (Task #4) now renders `PersonbrukerRoller` in the Roller-panel; `kan*`-flags and derived `organisasjoner` flow from the shared lean `personbruker`-query via Apollo's normalized cache (`Personbruker:<id>`).
- MSW mock handler `personbrukerMedRoller` (Task #1) answers the new query — nothing under `src/mocks/` was touched.
- `cacheConfig.ts` registration makes «Last inn flere» append-safe for the roller-connection (risk called out in the plan's Risk Assessment).
- Task #8 hooks in here: the actionbar's TODO(Task #8) markers show exactly where `TildelRolleModal`/`FjernRolleModal` and their open-state wiring go; `refetchQueries: ['personbrukerMedRoller']` will target this tab's operation.
- Task #10's master-detail integration test will exercise this tab against the mock handlers.

## Acceptance Criteria Met

- ✅ `PersonbrukerRoller/` — same form as Task #5, own components/hooks, operation `personbrukerMedRoller`, no sharing with the Tilganger-tab — Evidence: `src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerRoller/` (20 new files; no imports from `PersonbrukerTilganger/`)
- ✅ Connection registered in `cacheConfig.ts` (`Personbruker.fields.roller`) — Evidence: `src/common/lib/apollo/cacheConfig.ts:105`
- ✅ Same filter- and column-set (Navn/Status/Organisasjon/Tildelt av/Tildelt dato), rollenavn + rollekode in row cells — Evidence: `PersonbrukerRollerResultList.tsx:131-134`; test `PersonbrukerRollerResultList.test.tsx` ("renders one row per rolle with navn + rollekode + …")
- ✅ Actionbar «Tildel roller»/«Fjern roller» gated on `kanTildeleRoller`/`kanFjerneRoller` (modals in Task #8 — buttons disabled with TODO) — Evidence: `PersonbrukerRollerActionbar.tsx:46-67`; tests for all gating combinations
- ✅ Unit- and a11y-tests; i18n keys — Evidence: 4 unit-test files + 5 a11y-test files (carve-outs applied per skills for composite filter/order-by/result list); `src/common/messages/nb/domains.json` `tilgangsstyring.PersonbrukerRoller*` namespaces

## Next Steps

- Task #8: `TildelRolleModal`/`FjernRolleModal` — replace the disabled actionbar buttons with modal-open wiring (mirror `PersonbrukerTilgangerActionbar` after Task #6).
- Task #9: Deaktiver/Reaktiver — its `refetchQueries` must include `personbrukerMedRoller` (already anticipated in the plan).
- Task #10: master-detail integration test covering this tab.
- Teardown (post-subgraph): swap `gql` import, delete `useGetPersonbrukerRollerTypes.ts`, keep operation name `personbrukerMedRoller`.

## Conclusion

The Roller-tab is feature-complete for BRU-PER-GRU-002 (roller): filterable, sortable,
paginated list with rollenavn + rollekode, gated actions, full test coverage, green
typecheck/lint/build. Ready for review; Task #8 can start on top of it.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
