# Task #3 Completion Report: PersonbrukereOverview — listeside med filter, sortering og paginering

## Status: ✅ COMPLETED

**Date Completed**: 2026-07-08
**Task**: PersonbrukereOverview — listeside med filter, sortering og paginering
**Priority**: High
**Size**: L

## Summary

Built the `PersonbrukereOverview` feature as a structural twin of `ApplikasjonerOverview`: a `ListPageLayout`-based list page with URL-synced filter (6 fields), NAVN_ASC/DESC sorting, and "Last inn flere"-pagination against the Task #1 mock API (operations `personbrukere`, `personbrukereFilterOptions`, `mineBrukerAdminOrganisasjoner`). The `/tilgangsstyring/personbrukere` route now renders the feature (placeholder from Task #2 replaced, feature-flag gating preserved unchanged), and the `personbrukere` query is registered in Apollo's cacheConfig with `nodesCursorPagination(['filter', 'orderBy'])` so "Last inn flere" appends instead of replacing rows.

All paths below are relative to the fs-admin repo (`/Users/mats.myhre/Dev/Sikt/fs-admin`).

## Files Created

All under `src/domains/tilgangsstyring/features/PersonbrukereOverview/` unless noted.

### Top level

1. **`PersonbrukereOverview.tsx`** (48 lines) — Thin page composition: `ListPageLayout` → `ListPageSidebar` (composite filter + `FilterReset` in `headerActions`) + `ListPageContent` (result list). No actionbar (see Technical Decisions #1).
2. **`PersonbrukereOverview.a11y.test.tsx`** (134 lines) — axe test against the settled tree (2 result rows, aktiv + deaktivert).

### `hooks/`

3. **`useGetPersonbrukereTypes.ts`** (87 lines) — TRANSITIONAL manually-mirrored types for the Op #1 contract (`PersonbrukerStatus`, `PersonbrukereOrderBy`, lean list node, connection, filter input, query data/variables) with migration steps documented.
4. **`useGetPersonbrukereState.tsx`** (46 lines) — `useDataListState` with `initFirst: 50`, URL sync for all six filter fields (`navn`, `feideId`, `organisasjonId`, `rollekode`, `miljoKode`, `status`) + `orderBy` (default `NAVN_ASC`).
5. **`useGetPersonbrukere.tsx`** (92 lines) — Op #1 list query via `useDataListQuery`; lean row selection (`id navn feideId status organisasjoner { id navn }` + `totalCount`/`pageInfo`); empty-string → `null` mapping for every filter variable (the `useGetApplikasjoner` footgun); TRANSITIONAL comment with teardown steps.
6. **`useGetPersonbrukereFilterOptions.tsx`** (77 lines) — Op #3 query `personbrukereFilterOptions { roller { rollekode navn } miljoer { kode navn } }`; consumed by Rolle- and Miljø-filters.
7. **`useGetMineBrukerAdminOrganisasjoner.tsx`** (57 lines) — Op #3 query `mineBrukerAdminOrganisasjoner { id navn }`; consumed by the Organisasjon-filter (and by Task #6/#8 modals later).
8. **Hook tests** — `useGetPersonbrukereState.test.tsx` (151), `useGetPersonbrukere.test.tsx` (239), `useGetPersonbrukereFilterOptions.test.tsx` (122), `useGetMineBrukerAdminOrganisasjoner.test.tsx` (110): defaults, URL hydration, empty-string→null variable mapping, "Last inn flere" `first`-increment, `hasNextPage`, empty/error states.

### `components/`

9. **`PersonbrukereFilter/PersonbrukereFilter.tsx`** (84 lines) — Composite filter; single `<FilterWrapper>`; propagates `renderAsChip={renderAsChips}` to all six children; spread-then-override `onFilterChange`; chip-mode `FilterReset` as first child (legacy form — see Technical Decisions #3). No a11y test per the composite carve-out.
10. **`PersonbrukereFilter/PersonbrukereFilter.test.tsx`** (181 lines) — Sidebar mode (6 labeled inputs, URL hydration, URL write-through, no FilterReset in sidebar) + chip mode (chips per active value, rolle-chip label resolution via filter-options query, no chips at defaults, FilterReset chip when modified).
11. **`PersonbrukereOrderBy/PersonbrukereOrderBy.tsx`** (50 lines) — Thin `OrderByButton` wrapper adapting the flat `NAVN_ASC`/`NAVN_DESC` enum ↔ `{ orderByField, direction }`. No a11y test per the carve-out.
12. **`PersonbrukereResultList/PersonbrukereResultList.tsx`** (112 lines) — Single `<NavigationList>`; all state props wired (`message` via `parseBasicError`, `loading`, `loadedCount`, `totalCount`, `hasNextPage`, `loadingMore`, `onLoadMore`); `filterElement={<PersonbrukereFilter renderAsChips />}`; `orderByElement={<PersonbrukereOrderBy />}`; rows inline with cells Navn (strong) / Feide-ID / Organisasjoner (comma-joined, fallback text) / Status-tag in `ListItemEndCell`; rows navigate via typed route `/tilgangsstyring/personbrukere/[id]`. No a11y test per the carve-out.
13. **`PersonbrukereResultList/PersonbrukereResultList.test.tsx`** (244 lines) — Row rendering, deaktivert-tag + org-fallback, empty state (`emptyResultText`/`emptyTextSuggestion`), "Last inn flere" incrementing URL `first`.

### `components/filter/` (one folder per child, each with `.a11y.test.tsx`)

14. **`PersonbrukereNavnFilter/`** (48 + test) — `TextInput`, label "Navn", `autoComplete="off"`, chip = value, null when empty.
15. **`PersonbrukereFeideIdFilter/`** (54 + test) — `TextInput`, label "Feide-ID", same contract.
16. **`PersonbrukereOrganisasjonFilter/`** (67 + test) — `Select`, source `mineBrukerAdminOrganisasjoner`, first option "Alle organisasjoner", disabled while loading/empty.
17. **`PersonbrukereRolleFilter/`** (67 + test) — `Select`, source `filterOptions.roller` (value = `rollekode`, label = `navn`), first option "Alle roller", disabled while loading/empty.
18. **`PersonbrukereStatusFilter/`** (70 + test) — `Select` with "Alle statuser"/Aktiv/Deaktivert (2-value enum, not the optional-boolean pattern).
19. **`PersonbrukereMiljoFilter/`** (66 + test) — `Select`, source `filterOptions.miljoer`, first option "Alle miljøer", disabled while loading/empty.

## Files Modified

### 1. `src/common/lib/apollo/cacheConfig.ts`

Registered `personbrukere: nodesCursorPagination(['filter', 'orderBy'])` under `Query.fields` with a TRANSITIONAL comment (mirrors the `applikasjoner` entry; field name is shared between mock and real producer, so the entry survives teardown).

### 2. `src/app/tilgangsstyring/personbrukere/page.tsx`

Replaced the Task #2 placeholder (`BasicPageLayout` + paragraph) with `<PersonbrukereOverview />`. The `FeatureFlag flag="tilgangsstyring-brukeradministrasjon"` wrapper with `doNotFetchFlags` + `environmentsOverride` is preserved verbatim — gating unchanged.

### 3. `src/app/tilgangsstyring/personbrukere/page.a11y.test.tsx`

Updated from placeholder-assertion to a full axe test of the mounted overview (Apollo `MockedProvider` with `cacheConfig`-cache + `NuqsTestingAdapter`; waits for heading + result row before running axe).

### 4. `src/common/messages/nb/domains.json`

Added four namespaces under `tilgangsstyring`: `PersonbrukereOverview` (pageTitle/sidebarTitle="Filter"/contentTitle), `PersonbrukereFilter` (12 keys — all labels are noun phrases, all selects have "Alle …"-options), `PersonbrukereResultList` (headerText="Resultater", emptyResultText="Ingen personbrukere funnet", emptyTextSuggestion, errorText, ingenOrganisasjoner, status- and column-header keys), `PersonbrukereOrderBy` (navnOptionLabel). Removed the now-unused `app.personbrukerePlaceholderText` (the singular `personbrukerPlaceholderText` for the `[id]`-page remains until Task #4).

## Key Features Implemented

### ✅ ListPageLayout page (BRU-PER-GRU-001)

Rendered by `/tilgangsstyring/personbrukere`, behind the existing feature flag. Sidebar heading is exactly "Filter"; `FilterReset` lives in `ListPageSidebar.headerActions`; all `headingText`-props translated.

### ✅ Six URL-synced filters with chip strip

Navn + Feide-ID (TextInput), Organisasjon (`mineBrukerAdminOrganisasjoner`), Rolle (`filterOptions.roller`), Status (statisk), Miljø (`filterOptions.miljoer`) — all with "Alle …"-null-options, dual-render (sidebar inputs / chips via the list's `filterElement`-slot), empty value → no chip, one shared state hook.

### ✅ Sorting and pagination

`NAVN_ASC` default / `NAVN_DESC` via `OrderByButton`-wrapper; "Last inn flere" increments URL `first` by 50; `loadedCount`/`totalCount`/`hasNextPage`/`loadingMore` all wired; cacheConfig registration prevents silent row loss on fetch-more.

### ✅ NavigationList rows → detail page

Navn, Feide-ID, Organisasjon(er) (comma-joined; "Ingen organisasjoner"-fallback), Status-tag (`success`/`neutral`) in sticky `ListItemEndCell`; typed route `{ pathname: '/tilgangsstyring/personbrukere/[id]', params: { id } }`.

### ✅ Empty/loading/error states

`emptyText` "Ingen personbrukere funnet" + suggestion, skeleton via `loading`, query errors via `parseBasicError` → `message`.

## Project skills consulted

- **`fs-admin-list-pages`** — page composition (thin overview, sidebar contract "Filter" + single `FilterReset` in `headerActions`, translated `headingText`, actionbar omitted when empty, child-filter placement in the feature folder, a11y-test carve-outs).
- **`fs-admin-list-filters`** — dual-render contract (`renderAsChips`/`renderAsChip`), folder-per-child with a11y tests, null-chip-on-empty, spread-then-override `onChange`, `useGetXxxState` URL state, `autoComplete="off"`, input-type choice per filter shape. Sibling-audit done implicitly: the composite and children mirror the already-compliant `ApplikasjonerFilter` family.
- **`fs-admin-list-results`** — `NavigationList` choice (rows navigate), full state-prop wiring, `headerText`="Resultater"/`emptyText`-conventions, `orderByElement` = `OrderByButton`-wrapper only, cells for all row content, rows inline (no `*ResultRow.tsx`), no `ScreenReaderPause` (one datapoint per cell), no a11y tests for Filter/OrderBy/ResultList.
- **`fs-admin-inputs`** — noun-phrase labels ("Navn", "Feide-ID", "Rolle" — never "Søk etter …"), no `type="search"`, no placeholders, selects with visible "Alle …"-null-option and `disabled` while loading/empty.
- **`graphql-consumer`** — consulted; deliberate documented deviation (see Technical Decisions #2).
- **`fs-admin-grid-and-flex`** — consulted; no custom layout CSS was needed (no `.module.css` files written, no `display: flex/grid` anywhere).

## Test Results

All test files are TypeScript (`.tsx`), run with the project's Jest setup:

| Command | Scope | Result |
| --- | --- | --- |
| `npx jest src/domains/tilgangsstyring/features/PersonbrukereOverview` | 6 suites (4 hook tests + filter + result list) | 32/32 passed |
| `npx jest --config jest.a11y.config.ts src/domains/.../PersonbrukereOverview src/app/tilgangsstyring/personbrukere` | 9 suites (6 child filters, overview, both page tests) | 21/21 passed |
| `npm test` (full unit suite) | 221 suites | 1801 passed, 3 skipped (pre-existing) |
| `npm run test:a11y` (full a11y suite) | 269 suites | 862 passed |
| `npm run test:sincemain` (coverage gate per CLAUDE.md) | 39 suites | 258 passed; coverage 94.0% stmts / 83.7% branches / 94.7% funcs / 96.0% lines — thresholds met |
| `npm run test:typecheck` | whole repo | clean |
| `npm run lint` | whole repo | 0 errors (265 pre-existing warnings repo-wide) |
| `npm run build` | production build | success; `/tilgangsstyring/personbrukere` + `[id]` in route table |
| `npm run compile` | codegen | unaffected (tilgangsstyring + mocks exclusions intact) |

Note: the *global* coverage summary printed by unfiltered `npm test` does not meet thresholds — pre-existing repo condition; the project's stated gate is `test:sincemain` (CLAUDE.md), which passes.

## Technical Decisions

### 1. Actionbar omitted entirely (not rendered empty)

**Why**: The AC says "actionbar uten Opprett-knapp — opprettelse er utenfor scope". With the Opprett-button out of scope there are no actionbar actions at all, and `fs-admin-list-pages` explicitly forbids rendering an empty actionbar ("Don't render an empty actionbar 'just to be consistent'" / anti-pattern table). The skill owns how the code looks, so the actionbar is omitted; adding it back when a create-flow lands is a two-line change. Documented in the component's doc-comment.

### 2. TRANSITIONAL `gql` from `@apollo/client` + manual types (deviation from `graphql-consumer`)

**Why**: Ikke best practice — eksisterende mønster i området. The plan (Op #1 Lag B/C) mandates the mock-first pattern: `src/domains/tilgangsstyring/**` is excluded from codegen (`codegen.ts`), so the typed `gql` from `@/__generated__` cannot compile these operations. Hooks mirror `useGetApplikasjoner` exactly (TRANSITIONAL header comments with teardown steps, operation names locked to the MSW handler contract: `personbrukere`, `personbrukereFilterOptions`, `mineBrukerAdminOrganisasjoner`). Fragment colocation is revisited at teardown per the plan.

### 3. Chip-mode `FilterReset` rendered as first `FilterWrapper` child (legacy form)

**Why**: `fs-admin-list-filters` §3b prefers the wrapper-managed form (`onReset`/`isModified` props on `FilterWrapper`) for new composites, but the repo's actual `FilterWrapper` (`src/common/components/list-enhancers/FilterWrapper/FilterWrapper.tsx`) does not have those props — only `renderAsChips` + `children`. Inventing non-existent props is itself an anti-pattern (`fs-admin-inputs` pitfalls), so the composite uses the documented-still-valid legacy form, identical to `ApplikasjonerFilter`.

### 4. One filter-options hook shared by Rolle- and Miljø-filters

**Why**: The plan's Op #3 defines a single `personbrukereFilterOptions` query feeding both selects ("Konsumeres av RolleFilter/MiljoFilter"). Both children call the same hook; Apollo's `cache-first` policy deduplicates to one network request. This is hook-sharing per the plan, not query-sharing between unrelated components.

### 5. Organisasjoner rendered as one comma-joined cell value

**Why**: The krav column is "Organisasjon(er)" — a single datapoint (the set of orgs), not N distinct datapoints, so one `Paragraph` with `join(', ')` reads correctly for screen readers without `ScreenReaderPause` (per `fs-admin-list-results` §8: when in doubt, leave it out). Fallback "Ingen organisasjoner" for users without tildelinger (visible to super-brukeradministrator).

### 6. Removed the unused plural placeholder i18n key

**Why**: `app.personbrukerePlaceholderText` had exactly one consumer (the replaced placeholder page). Left `app.personbrukerPlaceholderText` (singular) intact — the `[id]`-placeholder page still uses it until Task #4.

## Build Status

✅ **Build successful** — `npm run build` completes; both personbrukere routes emitted
✅ **No new linter warning types** — 0 errors; the new files' 5 warnings (restricted `gql` import ×3, `fireEvent` in tests ×2) are the exact same warning kinds the canonical `ApplikasjonerOverview` template carries (11 of them), inherent to the plan-mandated TRANSITIONAL pattern
✅ **All imports resolved correctly** — typecheck clean, codegen unaffected

## Integration Points

- **Mock API (Task #1)**: operation names match `src/mocks/personbrukere/handlers/queries.ts` verbatim; the MSW handlers implement filter/sort/paginate/persona semantics server-side, so the UI does no client-side filtering.
- **Routes/flag (Task #2)**: the feature renders inside the existing `FeatureFlag` gate; row navigation uses the typed `[id]`-route generated in Task #2.
- **Detail page (Task #4)**: the lean list selection shares `id`/`navn`/`feideId`/`status`/`organisasjoner` with the planned `personbruker` detail query — Apollo's normalized cache gives the detail page instant partial rendering on list → detail navigation.
- **Tilganger/Roller tabs (Task #5/#7)**: `useGetMineBrukerAdminOrganisasjoner` is reusable for modal org-gating per the plan.
- **Integration test (Task #10)** will exercise this page against the MSW handlers, including pagination through the cacheConfig entry.

## Acceptance Criteria Met

- ✅ `PersonbrukereOverview.tsx` with `ListPageLayout`, no Opprett-button, filter sidebar + result list; rendered by `/tilgangsstyring/personbrukere` — Evidence: `src/domains/tilgangsstyring/features/PersonbrukereOverview/PersonbrukereOverview.tsx`, `src/app/tilgangsstyring/personbrukere/page.tsx` (actionbar omitted per skill rule, see Decision #1)
- ✅ `hooks/useGetPersonbrukereState.tsx` — `useDataListState`, `initFirst: 50`, URL sync for all six filter fields + orderBy — Evidence: `useGetPersonbrukereState.tsx:33-46`; hydration/reset covered in `useGetPersonbrukereState.test.tsx`
- ✅ `hooks/useGetPersonbrukere.tsx` + `useGetPersonbrukereTypes.ts` — Op #1 via `useDataListQuery`, TRANSITIONAL comments — Evidence: `useGetPersonbrukere.tsx:1-9` (comment), `:74-96` (hook); empty-string→null covered in `useGetPersonbrukere.test.tsx`
- ✅ `hooks/useGetPersonbrukereFilterOptions.tsx` + `useGetMineBrukerAdminOrganisasjoner.tsx` — Op #3 queries — Evidence: both files + their `.test.tsx` suites
- ✅ `personbrukere` registered in cacheConfig with `nodesCursorPagination(['filter', 'orderBy'])` — Evidence: `src/common/lib/apollo/cacheConfig.ts:60` (entry under `Query.fields`); all list tests run with `new InMemoryCache(cacheConfig)`
- ✅ Six filter components under `components/filter/` with the specified input types, sources and "Alle …"-options; chips via `filterElement`-slot — Evidence: `components/filter/*/` folders; `PersonbrukereResultList.tsx` (`filterElement={<PersonbrukereFilter renderAsChips />}`); chip behavior covered in `PersonbrukereFilter.test.tsx`
- ✅ `NavigationList` rows with Navn, Feide-ID, Organisasjon(er), Status in `ListItemEndCell`; typed-route navigation — Evidence: `PersonbrukereResultList.tsx:76-115`; row/link assertions in `PersonbrukereResultList.test.tsx`
- ✅ NAVN_ASC default/NAVN_DESC; "Last inn flere" with `loadedCount`/`totalCount`; empty/loading/error states («Ingen personbrukere funnet») — Evidence: `PersonbrukereOrderBy.tsx`, `PersonbrukereResultList.tsx:57-70`, `domains.json` (`emptyResultText`); load-more and empty-state tests in `PersonbrukereResultList.test.tsx`
- ✅ Unit + a11y tests for all new components; i18n keys in place — Evidence: 6 unit suites (32 tests) + 9 a11y suites (21 tests) all green; carve-outs applied exactly where the skills prescribe (composite filter, order-by, result list); 4 new namespaces in `src/common/messages/nb/domains.json`

## Next Steps

- Task #4 (PersonbrukerDetails skeleton/topbar/Detaljer-fane) can start — the `[id]`-route placeholder is untouched and the list's lean cache shape is ready for partial detail rendering.
- Task #10's integration test will exercise this page end-to-end against the MSW handlers (including pagination beyond 50 with the 60+ fixtures).
- At mock teardown: swap `gql` imports to `@/__generated__`, delete `useGetPersonbrukereTypes.ts`, keep operation names and the cacheConfig entry (both survive per the TRANSITIONAL comments).

## Conclusion

The Personbrukere list page (BRU-PER-GRU-001) is complete and demonstrable against the mock API behind the feature flag: filter, sort, paginate, and navigate-to-detail all work, with green typecheck, lint, unit, a11y, coverage gate, and production build.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
