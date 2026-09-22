# Task #5 Completion Report: PersonbrukerTilganger — Tilganger-fane med filter og liste

## Status: ✅ COMPLETED

**Date Completed**: 2026-07-08
**Task**: PersonbrukerTilganger — Tilganger-fane med filter og liste
**Priority**: High
**Size**: L

## Summary

Implemented the Tilganger tab on the Personbruker detail page (BRU-PER-GRU-002) as a structural twin of the canonical `ApplikasjonTilganger`: a `DetailPageContentFilterAndResult`-wrapped filter + paginated `ActionList` with columns Navn / Status / Organisasjon / Tildelt av / Tildelt dato, URL-synced filter state (`tilganger.*`-prefixed nuqs keys), NAVN_ASC/DESC sorting, «Last inn flere»-pagination, and a `kan*`-gated actionbar with «Tildel tilganger»/«Fjern tilganger» buttons (disabled pending Task #6's modals). The nested `Personbruker.tilganger`-connection is registered in Apollo's cacheConfig so load-more appends instead of replacing rows.

## Files Created

All paths relative to the fs-admin repo. Feature root: `src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerTilganger/`

### 1. `PersonbrukerTilganger.tsx` (70 lines)

Tab container. Single invocation of `DetailPageContentFilterAndResult` (obligatory per detail-page rule §6 — no hand-rolled responsive split). Wires the five slots: `filter` (composite filter with org-options prop-drilled from the lean detail query), `resultList` (render-prop forwarding the responsive `actionsElement`), `resultsActionBar` (kan*-gated buttons), and `onFilterReset`/`isFilterModified` from the state hook.

### 2. `PersonbrukerTilganger.a11y.test.tsx` (121 lines)

jest-axe test of the whole tab with mocked `personbruker` + `personbrukerMedTilganger` responses.

### 3. `hooks/useGetPersonbrukerTilgangerTypes.ts` (119 lines)

TRANSITIONAL manual TS types for the Op #2 contract (`TildelingStatus`, `PersonbrukerTildelingerOrderBy`, lean row node, connection, filter input, query data/variables) with the standard migration checklist for teardown when the real subgraph lands.

### 4. `hooks/useGetPersonbrukerTilgangerState.tsx` (50 lines)

URL-synced state via `useDataListState`: filter fields `tilganger.navn` / `tilganger.status` / `tilganger.organisasjonId`, orderBy `tilganger.orderBy` (default NAVN_ASC), `initFirst: 50`. The `tilganger.`-prefix prevents collisions with the overview-page state and the future Roller tab (`roller.*`, Task #7).

### 5. `hooks/useGetPersonbrukerTilgangerState.test.tsx` (168 lines)

9 unit tests: defaults, prefix contract, URL read/write, filter-change-resets-first, load-more increments, orderBy change, reset, isModified.

### 6. `hooks/useGetPersonbrukerTilganger.tsx` (116 lines)

Operation `personbrukerMedTilganger` (Op #2 Lag B, exact field set from the plan: `id navn status organisasjon{id navn} tildeltAv{id navn} tildeltTidspunkt kanFjernes` + `totalCount`/`pageInfo`) via `useDataListQuery` with `selectConnection: data?.personbruker?.tilganger`. Empty-string → `null` mapping in filter variables. TRANSITIONAL `gql`-from-`@apollo/client` header comment matching the sibling hooks.

### 7. `hooks/useGetPersonbrukerTilganger.test.tsx` (309 lines)

6 unit tests: default variables + result shape, id-from-argument, URL-filter → variables mapping, increased `first`, `hasNextPage`, skip-on-empty-id.

### 8. `components/PersonbrukerTilgangerFilter/PersonbrukerTilgangerFilter.tsx` (91 lines)

Composite filter. Single `<FilterWrapper>`, `FilterReset` as first child in chip mode, `renderAsChip={renderAsChips}` propagated to all children, spread-then-override `onFilterChange`. No a11y test (carve-out: returns a single `FilterWrapper`).

### 9–11. `components/PersonbrukerTilgangerFilter/filter/…` (3 child filters + a11y tests)

- `PersonbrukerTilgangerNavnFilter/` — `TextInput` (no `type="search"`), noun label «Navn», `autoComplete="off"`, chip renders `null` when empty. (49 + 41 test lines)
- `PersonbrukerTilgangerStatusFilter/` — `Select` «Alle statuser»/Aktiv/Inaktiv over `TildelingStatus` (AKTIV/INAKTIV — tildelingens status, not brukerens). (72 + 40 test lines)
- `PersonbrukerTilgangerOrganisasjonFilter/` — `Select` «Alle organisasjoner», options from the derived `Personbruker.organisasjoner`, `disabled` while loading/empty. (84 + 72 test lines)

### 12. `components/PersonbrukerTilgangerOrderBy/PersonbrukerTilgangerOrderBy.tsx` (46 lines)

Thin `OrderByButton`-wrapper adapting NAVN_ASC/NAVN_DESC ↔ `{ orderByField, direction }`. No a11y test (carve-out).

### 13. `components/PersonbrukerTilgangerResultList/PersonbrukerTilgangerResultList.tsx` (150 lines)

Single `<ActionList>` (rows are read-only — no navigation). Columns in sketch order (sub-frame 03): Navn (strong), Status (`TagStatus` `success`/`neutral` — aktive/inaktive visually distinguished), Organisasjon, Tildelt av, Tildelt dato (formatted dd.MM.yyyy from `tildeltTidspunkt` via next-intl `useFormatter` + `dateFormats.date`). All `useDataListQuery` state props wired (`message`/`loading`/`loadedCount`/`totalCount`/`hasNextPage`/`loadingMore`/`onLoadMore`), `filterElement` = composite filter with `renderAsChips`, `orderByElement`, parent-provided `actionsElement`. No a11y test (carve-out).

### 14. `components/PersonbrukerTilgangerResultList/PersonbrukerTilgangerResultList.test.tsx` (244 lines)

5 unit tests: row rendering incl. formatted date, aktiv/inaktiv status-tag distinction, empty state («Ingen tilganger funnet» + suggestion), actionsElement slot, «Last inn flere» URL-first increment.

### 15. `components/PersonbrukerTilgangerActionbar/PersonbrukerTilgangerActionbar.tsx` (67 lines)

List-scoped buttons «Tildel tilganger»/«Fjern tilganger» (`FSButton variant="subtle"`, verb-phrase labels via next-intl), visibility-gated on `kanTildeleTilganger`/`kanFjerneTilganger` from the detail node (never hardcoded rollekoder — plan Decision #7). Renders nothing while loading or when neither flag is set. Buttons are `disabled` with a `TODO(Task #6)` comment describing exactly what to wire when the modals land.

### 16–17. Actionbar tests (96 + 59 lines)

6 unit tests (both/only-tildel/only-fjern/neither/loading gating + disabled-until-Task-#6) and 2 a11y tests.

## Files Modified

### 1. `src/domains/tilgangsstyring/features/PersonbrukerDetails/PersonbrukerDetails.tsx`

Replaced the temporary Tilganger placeholder with `<PersonbrukerTilganger personbrukerId={id} />`; updated the JSDoc (Roller placeholder remains for Task #7).

### 2. `src/common/lib/apollo/cacheConfig.ts`

Registered `Personbruker: { fields: { tilganger: nodesCursorPagination(['filter', 'orderBy']) } }` with a TRANSITIONAL comment mirroring the `Applikasjon.tilganger` entry (`personbrukerId` is part of the parent path — not a key-arg).

### 3. `src/common/messages/nb/domains.json`

Added namespaces `PersonbrukerTilganger`, `PersonbrukerTilgangerFilter`, `PersonbrukerTilgangerResultList`, `PersonbrukerTilgangerOrderBy`, `PersonbrukerTilgangerActionbar`; removed the now-orphaned `PersonbrukerDetails.tilgangerPlaceholder` (no orphan keys per i18n conventions).

### 4. `src/domains/tilgangsstyring/features/PersonbrukerDetails/PersonbrukerDetails.test.tsx`

Placeholder test replaced with a test asserting the real Tilganger tab (result-list header + gated actionbar buttons) and the remaining Roller placeholder. Added a `personbrukerMedTilganger` mock to the shared wrapper because SDS `TabPanel` mounts all panels eagerly (inactive panels are only visually hidden), so the tab's query fires on page render.

### 5. `src/domains/tilgangsstyring/features/PersonbrukerDetails/PersonbrukerDetails.a11y.test.tsx`

Added the same `personbrukerMedTilganger` mock for the eager-mount reason above.

## Key Features Implemented

### ✅ DetailPageContentFilterAndResult layout (obligatory)

The tab is a single five-slot invocation of the shared wrapper — no hand-rolled responsive split, no `useBreakpoints`/`FilterReset` wiring in feature code (anti-pattern 5 avoided).

### ✅ URL-synced filter + query hooks (Op #2)

`useGetPersonbrukerTilgangerState` (nuqs, `tilganger.*` keys) + `useGetPersonbrukerTilganger` (operation `personbrukerMedTilganger` — name matches the MSW handler contract and must survive teardown) + TRANSITIONAL manual types.

### ✅ cacheConfig registration

`Personbruker.fields.tilganger` with key-args `['filter', 'orderBy']` — «Last inn flere» appends rows instead of replacing them (analysefunn #10 risk mitigated; exercised by the load-more unit test).

### ✅ Filter per krav

Navn (TextInput), Status (Select «Alle statuser»/Aktiv/Inaktiv), Organisasjon (Select «Alle organisasjoner», source: derived `Personbruker.organisasjoner`). Chips over the list via the `filterElement`-slot; dual-render contract intact.

### ✅ List per krav + sketch

Columns Navn / Status / Organisasjon / Tildelt av / Tildelt dato (formatted from `tildeltTidspunkt`); status-tags distinguish aktive/inaktive; NAVN_ASC/DESC sorting; «Last inn flere» with `loadedCount`/`totalCount`; empty/loading/error states per list-results conventions.

### ✅ Actionbar gated on kan*-flags

«Tildel tilganger»/«Fjern tilganger» rendered only when the respective flag is true; disabled with TODO until Task #6 wires the modals.

## Project skills consulted

- **fs-admin-detail-pages** — mandated `DetailPageContentFilterAndResult` (rule §6), no cross-family layout imports, tab-is-the-heading (no duplicate heading inside the panel).
- **fs-admin-list-filters** — composite/child filter contract (`renderAsChips` vs `renderAsChip`), folder-per-child-filter with a11y tests, `FilterReset` placement, null-chip rule, spread-then-override onChange, `useDataListState` (no `useState`). Note: used the legacy manual-`FilterReset`-first-child form because the actual `FilterWrapper` component does not (yet) expose the `onReset`/`isModified` props the skill describes as "preferred for new code" — verified against `FilterWrapper.tsx`.
- **fs-admin-list-results** — `ActionList` choice (read-only rows), full state-prop wiring, `headerText`/`emptyText`/`emptyTextSuggestion` conventions («Resultater» / «Ingen tilganger funnet»), inline row rendering (no `*ResultRow.tsx`), a11y carve-outs for ResultList/OrderBy/composite-Filter.
- **fs-admin-inputs** — noun labels («Navn», «Status», «Organisasjon»), no `type="search"`, no placeholder-as-label, «Alle …»-null-options, `disabled` while loading/empty, `autoComplete="off"`.
- **fs-admin-buttons** — `FSButton` default, verb-phrase labels via next-intl, `variant="subtle"` in the list actionbar (destructive rød emphasis belongs on the Fjern-modal's submit in Task #6, mirroring the applikasjoner twin).
- **fs-admin-grid-and-flex** — `<Flex>` helper for the actionbar button row (`flexWrap="wrap"`); no `display: flex/grid` CSS written (no new module.css at all).
- **graphql-consumer** — operation naming/variables/pagination consumption rules; the flat-query + manual-types shape is the documented, sanctioned deviation for this mock-first area («Ikke best practice — speiler transisjonelt mønster», plan Op #2 Lag C); mirrors the existing area style per the skill's own "mirror the existing flat style" rule.
- **i18n conventions** (`src/common/messages/CLAUDE.md`) — component-named namespaces in `domains.json`, no hardcoded Norwegian strings, no orphan keys.

## Test Results

All commands run in `/Users/mats.myhre/Dev/Sikt/fs-admin`:

- `npm run test:typecheck` — ✅ clean (`tsc --noEmit`)
- `npx jest --testPathPatterns "PersonbrukerTilganger|PersonbrukerDetails"` — ✅ 8 suites, 47 tests passed
- `npm test` (full unit suite) — ✅ 229 suites, 1848 passed / 3 skipped (pre-existing), exit 0
- `npm run test:a11y` (full a11y suite) — ✅ 277 suites, 881 tests passed
- `npm run lint` — ✅ 0 errors (see Build Status for the warning accounting)
- `npm run build` — ✅ compiles; `/tilgangsstyring/personbrukere/[id]` route present

New test files (all TypeScript, run via Jest per project convention):

- `hooks/useGetPersonbrukerTilgangerState.test.tsx` (9 tests)
- `hooks/useGetPersonbrukerTilganger.test.tsx` (6 tests)
- `components/PersonbrukerTilgangerResultList/PersonbrukerTilgangerResultList.test.tsx` (5 tests)
- `components/PersonbrukerTilgangerActionbar/PersonbrukerTilgangerActionbar.test.tsx` (6 tests)
- `components/PersonbrukerTilgangerActionbar/PersonbrukerTilgangerActionbar.a11y.test.tsx` (2 tests)
- 3 × child-filter `*.a11y.test.tsx` (10 tests total)
- `PersonbrukerTilganger.a11y.test.tsx` (1 test)

## Technical Decisions

### 1. Organisasjon-filter source = derived `Personbruker.organisasjoner` (no new operation)

**Why**: The mock schema (Task #1) defines no tab-level filter-options query, and the derived field is exactly «organisasjonene personbrukerens tilganger/roller gjelder for» — the content-derived set the user can meaningfully narrow by (persona-visibility already applied server-side). It ships free with the lean detail query (`useGetPersonbruker`, Task #4), so no extra operation or round-trip; Apollo's normalized cache shares the `Personbruker:<id>` entry between the tab container and the result list's chip-label lookup. `mineBrukerAdminOrganisasjoner` was rejected: it is the redigeringsrett scope (overview filter/modal gating), not the content of this list.

### 2. Actionbar buttons rendered-but-disabled (not hidden) until Task #6

**Why**: The acceptance criterion says «inntil da disabled med TODO». Visibility-gating on the `kan*`-flags is already in place (identical narrowing to `ApplikasjonTilgangerActionbar`), so Task #6 only needs to drop `disabled`, add `onClick`, and mount the modals — the TODO comment spells this out, and a unit test documents the temporary disabled state with an inversion note.

### 3. Status column as a regular `ListItemCell` (not `ListItemEndCell`)

**Why**: The acceptance criterion fixes the column order from the sketch (sub-frame 03): Navn, Status, Organisasjon, Tildelt av, Tildelt dato — status is the second column, not right-anchored. The detail-pages skill says the sketch wins over the end-cell default for status tags.

### 4. `TildelingStatus` as a 2-value enum Select (not the optional-boolean pattern)

**Why**: AKTIV/INAKTIV is the tildeling's own status enum (distinct from `PersonbrukerStatus` AKTIV/DEAKTIVERT); both values are legitimate narrowing targets, so a plain enum-Select with «Alle statuser» is correct — same reasoning as `PersonbrukereStatusFilter` documents.

### 5. `tilganger.*` URL-key prefix

**Why**: Same insurance as the applikasjoner twin (documented 2026-05-13 memory note) plus a concrete need here: the sibling Roller tab (Task #7, prefix `roller.*`) will live on the same detail-page URL — bare keys would collide.

## Build Status

✅ **Build successful** — `npm run build` compiles; the `[id]`-route renders the tab
✅ **No new linter errors** (0 errors repo-wide); the single new warning is the domain-standard TRANSITIONAL `gql`-import warning on `useGetPersonbrukerTilganger.tsx`, identical to every sibling mock-first hook (`useGetPersonbruker`, `useGetPersonbrukere`, `useGetApplikasjonTilganger`) and removed at teardown
✅ **All imports resolved correctly** (typecheck clean); Prettier run on all touched files

## Integration Points

- **Task #4 (detail skeleton)**: the tab replaces the placeholder in `PersonbrukerDetails`; the `kan*`-flags for the actionbar come from the existing lean `useGetPersonbruker` (no new fields needed). NB for downstream tests: SDS `TabPanel` mounts all panels eagerly, so any test rendering `PersonbrukerDetails` needs a `personbrukerMedTilganger` mock (added to both existing test files; Task #7 will need the same for `personbrukerMedRoller`).
- **Task #1 (mock)**: the query matches the MSW `personbrukerMedTilganger` handler by operation name; nothing under `src/mocks/` was modified.
- **Task #6 (modals)**: `PersonbrukerTilgangerActionbar` is the mount point — TODO comment lists the exact wiring steps; `kanFjernes` is already selected on the row nodes for the Fjern-modal; `refetchQueries: ['personbrukerMedTilganger']` will target this tab's operation.
- **Task #7 (Roller)**: mirror this folder 1:1 with `roller.*` URL-prefix and its own `Personbruker.fields.roller` cacheConfig entry (deliberately NOT added here — one task, one connection).
- **Teardown**: swap `gql`-import, delete `useGetPersonbrukerTilgangerTypes.ts`, keep operation name and cacheConfig entry (documented in the TRANSITIONAL headers and `teardown-personbrukere.md`).

## Acceptance Criteria Met

- ✅ `PersonbrukerTilganger/` med `DetailPageContentFilterAndResult` (obligatorisk) — Evidence: `PersonbrukerTilganger.tsx:50-69` (single wrapper invocation, no hand-rolled split)
- ✅ `hooks/useGetPersonbrukerTilgangerState.tsx` (URL-synket) + `useGetPersonbrukerTilganger.tsx` (operation `personbrukerMedTilganger`, Op #2) + typer — Evidence: the three hook files + 15 passing hook tests
- ✅ Connection registrert i `cacheConfig.ts` (`Personbruker.fields.tilganger`, key-args `['filter', 'orderBy']`) — Evidence: `src/common/lib/apollo/cacheConfig.ts:99-103`; load-more append exercised by `PersonbrukerTilgangerResultList.test.tsx` («Last inn flere»-test)
- ✅ Filter: Navn (TextInput), Status (Select «Alle statuser»/Aktiv/Inaktiv), Organisasjon (Select «Alle organisasjoner») — Evidence: the three child-filter components + `domains.json` keys `statusAlle`/`statusAktiv`/`statusInaktiv`/`organisasjonAlle`
- ✅ Liste med kolonner Navn, Status, Organisasjon, Tildelt av, Tildelt dato (formatert fra `tildeltTidspunkt`); aktive/inaktive visuelt skilt (status-tag); sortering NAVN_ASC/DESC; «Last inn flere» — Evidence: `PersonbrukerTilgangerResultList.tsx:121-147` + `PersonbrukerTilgangerOrderBy.tsx`; unit tests for date formatting, tag distinction and load-more
- ✅ Actionbar med «Tildel tilganger»/«Fjern tilganger» gated på `kanTildeleTilganger`/`kanFjerneTilganger`, disabled med TODO inntil Task #6 — Evidence: `PersonbrukerTilgangerActionbar.tsx:44-66` + 6 gating/disabled unit tests
- ✅ Unit- og a11y-tester; i18n-nøkler — Evidence: 26 new unit tests + 13 new a11y tests, all green; 5 new i18n namespaces in `domains.json`, orphaned `tilgangerPlaceholder` removed

## Next Steps

- **Task #6**: TildelTilgangModal + FjernTilgangModal — mount in `PersonbrukerTilgangerActionbar`, drop the `disabled`-props, wire Op #5 mutations with `refetchQueries: ['personbrukerMedTilganger']`, invert the disabled-assertion unit test.
- **Task #7**: PersonbrukerRoller — mirror this folder with `roller.*` prefix, `personbrukerMedRoller` operation, `Personbruker.fields.roller` cacheConfig entry; add the roller mock to the PersonbrukerDetails tests (eager TabPanel mounting).
- **Task #9**: status actions in the topbar; after deaktivering the INAKTIV tildelinger show up here via the status-tags already implemented.

## Conclusion

The Tilganger tab is fully functional against the Task #1 mock API behind the feature flag: filterable, sortable, paginated, permission-gated, tested (unit + a11y), and structured 1:1 with the canonical `ApplikasjonTilganger` so Tasks #6/#7 can proceed mechanically. Ready for review.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
