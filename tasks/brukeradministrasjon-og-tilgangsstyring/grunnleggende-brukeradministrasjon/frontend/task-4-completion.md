# Task #4 Completion Report: PersonbrukerDetails — skjelett, topbar og Detaljer-fane

## Status: ✅ COMPLETED

**Date Completed**: 2026-07-08
**Task**: PersonbrukerDetails — skjelett, topbar og Detaljer-fane
**Priority**: High
**Size**: L

## Summary

Built the `PersonbrukerDetails` detail-page skeleton in `src/domains/tilgangsstyring/features/PersonbrukerDetails/` as a structural twin of `ApplikasjonDetails`: `DetailPageLayout` with topbar (navn + status-tag + actions-slot for Task #9) and three tabs (Detaljer/Tilganger/Roller) where the Detaljer tab renders the BRU-PER-GRU-007 data groups and the two other tabs render temporary placeholders for Tasks #5/#7. The lean Op #2 detail query (operation `personbruker`, incl. all six `kan*`-flags) is wired through a TRANSITIONAL `useGetPersonbruker` hook with verified list → detail normalized-cache merging, and the `[id]`-route now renders the feature behind the `tilgangsstyring-brukeradministrasjon` flag.

## Files Created

All paths relative to the fs-admin repo.

### 1. `src/domains/tilgangsstyring/features/PersonbrukerDetails/PersonbrukerDetails.tsx` (123 lines)

Main feature component. `DetailPageLayout` with entity-name title (translated `defaultTitle` fallback while loading), SR-only-headed `LayoutTopBar` hosting `PersonbrukerTopBar`, and `DetailPageTabbedContent` with three `DetailPageTabbedContentPanel`s (`detaljer` default, `tilganger`, `roller` — URL-synced via `?tab=`). Error/not-found states via `LayoutMessage severity="critical"` wrapping the domain's `NoAccessError`/`NotFoundError` with personbruker-specific messages.

### 2. `src/domains/tilgangsstyring/features/PersonbrukerDetails/hooks/useGetPersonbruker.tsx` (97 lines)

Lean Op #2 query (operation name `personbruker`, locked to the MSW handler contract): id, navn, feideId, status, organisasjoner { id navn } + all six `kan*`-flags (`kanTildeleTilganger`, `kanFjerneTilganger`, `kanTildeleRoller`, `kanFjerneRoller`, `kanDeaktiveres`, `kanReaktiveres`). `NetworkStatus`-based loading semantics so cached list-row fields render instantly on list → detail navigation. TRANSITIONAL header with the four-step migration checklist (same as `useGetApplikasjon`).

### 3. `src/domains/tilgangsstyring/features/PersonbrukerDetails/hooks/useGetPersonbrukerTypes.ts` (82 lines)

TRANSITIONAL manually-mirrored types for the detail contract (`PersonbrukerDetailNode`, `PersonbrukerQueryData/Variables`, re-declared `PersonbrukerStatus`), with migration notes and pointers to the mock SDL.

### 4. `src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerTopBar/PersonbrukerTopBar.tsx` (77 lines)

Topbar Variant B (wrapping Flex row, mirroring `ApplikasjonTopBar`): Navn (label + value) and Status (`TagStatus` — success/Aktiv, neutral/Deaktivert). `actionsElement?: ReactNode` slot anchored top-right via outer `justifyContent="space-between"` — Task #9's `PersonbrukerStatusActions` drops in there.

### 5. `src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerDetaljer/PersonbrukerDetaljer.tsx` (75 lines)

Detaljer-tab content: data groups Navn, Feide-ID, Organisasjoner (derived, plural — comma-separated inline string with `ingenOrganisasjoner` fallback), Status (`TagStatus`) as `OutputField`s in a responsive `<Grid>` (`{ base: '1fr', tablet: repeat(2), desktop: repeat(4) }`). No «Sist brukt» (deferred per spec). Reads through the same `useGetPersonbruker` hook (Apollo dedupes).

### 6–12. Tests

- `PersonbrukerDetails.test.tsx` (210 lines) — title fallback → entity name; three tabs with Detaljer default; placeholder text in Tilganger/Roller on tab click; topbar content (scoped to the topbar region); not-found and no-access states without tabs.
- `PersonbrukerDetails.a11y.test.tsx` (90 lines) — axe on the settled tree + the not-found state.
- `hooks/useGetPersonbruker.test.tsx` (321 lines) — success shape incl. all six `kan*`-flags, entity-null → `undefined`, network error, `skip` on empty id, and the list → detail Apollo cache-merge integration test (primes the cache with `GET_PERSONBRUKERE`, asserts `Personbruker:pb-1` holds lean fields before the detail fetch and merged `kan*`-flags after).
- `components/PersonbrukerTopBar/PersonbrukerTopBar.test.tsx` (69 lines) — navn/status rendering for AKTIV/DEAKTIVERT; actions-slot renders provided content and nothing when omitted.
- `components/PersonbrukerTopBar/PersonbrukerTopBar.a11y.test.tsx` (58 lines) — axe for AKTIV, DEAKTIVERT and with-actions variants.
- `components/PersonbrukerDetaljer/PersonbrukerDetaljer.test.tsx` (146 lines) — four data groups, plural organisasjoner join, `ingenOrganisasjoner` fallback, Deaktivert tag, explicit no-«Sist brukt» assertion, null-render before data.
- `components/PersonbrukerDetaljer/PersonbrukerDetaljer.a11y.test.tsx` (64 lines) — axe on the settled grid.

## Files Modified

### 1. `src/app/tilgangsstyring/personbrukere/[id]/page.tsx`

Task #2 placeholder replaced: now renders `<PersonbrukerDetails id={id} />`, preserving the `FeatureFlag flag="tilgangsstyring-brukeradministrasjon"` gating (same `environmentsOverride` as before).

### 2. `src/app/tilgangsstyring/personbrukere/[id]/page.a11y.test.tsx`

Updated from asserting the placeholder text to rendering the real detail page (MockedProvider + NuqsTestingAdapter + `GET_PERSONBRUKER` mock) and running axe on the settled tree.

### 3. `src/domains/tilgangsstyring/components/NotFoundError/NotFoundError.tsx` + `.../NoAccessError/NoAccessError.tsx`

Added an optional `message?: string` prop (defaults to the existing applikasjon-specific translation). The stored default messages were hardcoded to Applikasjon wording ("Applikasjonen ble ikke funnet." etc.); the prop lets `PersonbrukerDetails` pass personbruker-specific text without touching Applikasjon behavior. Additive — existing callers unchanged.

### 4. `src/common/messages/nb/domains.json`

Added `tilgangsstyring.PersonbrukerDetails` (title/headings/tab labels/placeholders/errors), `tilgangsstyring.PersonbrukerTopBar` and `tilgangsstyring.PersonbrukerDetaljer` namespaces. Removed the now-orphaned `app.personbrukerPlaceholderText` (its only consumer was the Task #2 placeholder page). Existing per-component duplication of `statusAktiv`/`statusDeaktivert` mirrors the established applikasjoner pattern in this file.

## Key Features Implemented

### ✅ DetailPageLayout skeleton with three tabs (BRU-PER-GRU-007 + frame for 002/003/004)

Tabs Detaljer (default) / Tilganger / Roller via `DetailPageTabbedContent`, URL-synced (`?tab=`), icons `BookOpenIcon`/`KeyIcon`/`UserGearIcon`. Tilganger/Roller are `Paragraph` placeholders replaced wholesale in Tasks #5/#7.

### ✅ Lean Op #2 detail query with kan*-flags

Operation `personbruker` fetched exactly per plan Lag B — the six `kan*`-flags are in the cache now so Tasks #5/#7/#9 can gate their buttons without query changes.

### ✅ List → detail instant partial render

Normalized cache merge verified by an integration-style hook test: lean list-row fields available under `Personbruker:<id>` before the detail response; `kan*`-flags merged after.

### ✅ Topbar with actions-slot

Navn + status-tag now; `actionsElement` prop reserves the top-right cluster for Task #9's `PersonbrukerStatusActions`.

### ✅ Error/not-found states via the domain components

`NoAccessError` on query failure, `NotFoundError` on settled-null (server-side visibility also nulls invisible users), both with personbruker-specific messages.

## Project skills consulted

- **`fs-admin-detail-pages`** (mandatory) — drove the whole structure: title vs `headingText` split with translated loading fallback (§1), SR-only topbar heading (§3), topbar Variant B with top-right actions cluster (§4), tabs for major sections with no duplicated panel headings (§5), responsive-only content (§7), no cross-family layout imports (§9).
- **`graphql-consumer`** — operation shape/variables/naming; the flat-query + manual-types deviation from the colocation default is the documented TRANSITIONAL mock-first pattern in this domain ("Ikke best practice — eksisterende mønster i området", per the plan's Lag C for Op #2). `gql` from `@apollo/client` as `TypedDocumentNode` matches every sibling hook; operation name locked to the MSW handler.
- **`fs-admin-grid-and-flex`** — no `display: flex/grid` in CSS anywhere in the new code; topbar uses nested `<Flex>` (wrap + space-between), Detaljer tab uses `<Grid>` with responsive object-form `gridTemplateColumns`. (Deliberately did NOT copy `ApplikasjonDetaljer`'s grandfathered `.module.css` grid.)
- **`src/messages/CLAUDE.md` i18n conventions** — component-named PascalCase namespaces in the domain file, semantic camelCase keys, orphaned key removed.

## Test Results

All run from the fs-admin repo root:

- `npx jest src/domains/tilgangsstyring/features/PersonbrukerDetails --coverage=false` — 4 suites, 21 tests passed
- `npm test` (full unit suite) — 225 suites, 1822 passed / 3 skipped
- `npm run test:a11y` (full a11y suite) — 272 suites, 868 passed (incl. 6 new a11y tests + updated route-page test)
- `npm run test:typecheck` — clean
- `npm run lint` — 0 errors; only pre-existing warnings plus the expected `no-restricted-imports` warning on `useGetPersonbruker.tsx` (`gql` from `@apollo/client`), which is intrinsic to the TRANSITIONAL pattern and identical to every sibling hook in the domain
- `npm run build` — `✓ Compiled successfully`; `/tilgangsstyring/personbrukere/[id]` present in the route table

## Technical Decisions

### 1. `actionsElement` slot prop on PersonbrukerTopBar instead of an empty inline cluster

**Why**: The AC requires an actions-slot ready for Task #9 without shipping buttons now. A typed `ReactNode` prop makes the slot part of the component contract, renders nothing when omitted, and is covered by tests. Task #9 can pass `<PersonbrukerStatusActions>` (or refactor to internal rendering à la `ApplikasjonTopBar` if preferred — both fit the slot).

### 2. Optional `message` prop on NotFoundError/NoAccessError

**Why**: The AC mandates "via domenets NotFoundError/NoAccessError", but their messages were hardcoded to Applikasjon wording. An optional override with the old default is the smallest additive change that keeps Applikasjon behavior byte-identical.

### 3. Navn rendered in the topbar despite the page title also being the navn

**Why**: The AC explicitly lists «navn» as topbar content. This does not violate `fs-admin-detail-pages` §1/§3 (which govern `title` vs `headingText`, not info-field content); the topbar heading itself is a static SR-only `topBarHeading`.

### 4. Organisasjoner as a comma-separated inline string in the Detaljer tab

**Why**: `OutputField` wraps children in a `<p>`; block elements inside it would be invalid HTML. The comma-join keeps the plural, derived value inline-safe, with `ingenOrganisasjoner` fallback when empty.

### 5. Placeholders inline in PersonbrukerDetails rather than stub components

**Why**: Tasks #5/#7 replace the whole panel body with `PersonbrukerTilganger`/`PersonbrukerRoller` feature folders; inline `Paragraph`s give zero teardown surface.

### 6. No cacheConfig changes

**Why**: The lean detail query has no paginated connections; `Personbruker` normalizes on the default `__typename:id` key. The `tilganger`/`roller` connection registrations belong to Tasks #5/#7 per the plan.

## Build Status

✅ **Build successful** — `npm run build` compiles, `[id]`-route registered
✅ **No new linter errors**; the single new warning is the domain-standard TRANSITIONAL `gql`-import warning present on all sibling hooks
✅ **All imports resolved correctly** (typecheck clean)

## Integration Points

- **Route**: `src/app/tilgangsstyring/personbrukere/[id]/page.tsx` renders the feature behind the `tilgangsstyring-brukeradministrasjon` flag; breadcrumb layout from Task #2 untouched.
- **Task #3 (list)**: rows navigate here; overlapping fields (`navn`, `feideId`, `status`, `organisasjoner`) render instantly from the normalized cache (verified by test). `PersonbrukereOverview` untouched.
- **Task #1 (mock)**: query matches the MSW `personbruker` handler by operation name; nothing under `src/mocks/` was modified.
- **Task #5/#7**: replace the Tilganger/Roller placeholder panels; `kan*`-flags for their actionbars are already in the cache via this hook.
- **Task #9**: `PersonbrukerStatusActions` mounts in the topbar's `actionsElement` slot; `kanDeaktiveres`/`kanReaktiveres` already fetched.

## Acceptance Criteria Met

- ✅ `PersonbrukerDetails.tsx` — DetailPageLayout, three faner via DetailPageTabbedContent, rendres av `[id]`-ruten, title = navn med oversatt fallback, statisk `headingText` — Evidence: `src/domains/tilgangsstyring/features/PersonbrukerDetails/PersonbrukerDetails.tsx:60,86,90` + `src/app/tilgangsstyring/personbrukere/[id]/page.tsx:25`; tested in `PersonbrukerDetails.test.tsx`
- ✅ `hooks/useGetPersonbruker.tsx` — lean Op #2-query (operation `personbruker`); normalisert cache gir delvis rendering fra lista — Evidence: `hooks/useGetPersonbruker.tsx:45-64`; cache-merge test in `hooks/useGetPersonbruker.test.tsx` ("shares overlapping fields with the list-side cache")
- ✅ `PersonbrukerTopBar/` — navn, status-tag (Aktiv/Deaktivert) og actions-slot — Evidence: `components/PersonbrukerTopBar/PersonbrukerTopBar.tsx:55-75`; slot tested in `PersonbrukerTopBar.test.tsx`
- ✅ `PersonbrukerDetaljer/` — datagrupper Navn, Feide-ID, Organisasjon(er) (avledet, flertall), Status; ingen «Sist brukt» — Evidence: `components/PersonbrukerDetaljer/PersonbrukerDetaljer.tsx:49-73`; explicit no-«Sist brukt» test in `PersonbrukerDetaljer.test.tsx`
- ✅ Tilganger/Roller-fanene rendrer midlertidige plassholdere — Evidence: `PersonbrukerDetails.tsx:108-119`; tab-click tests in `PersonbrukerDetails.test.tsx`
- ✅ Feil-/ikke-funnet-tilstander via domenets `NotFoundError`/`NoAccessError` — Evidence: `PersonbrukerDetails.tsx:64-82`; both states unit- and a11y-tested
- ✅ Unit- og a11y-tester; i18n-nøkler — Evidence: 7 new test files (21 unit + 6 a11y assertions), all suites green; keys in `src/common/messages/nb/domains.json` under `PersonbrukerDetails`/`PersonbrukerTopBar`/`PersonbrukerDetaljer`

## Next Steps

- **Task #5**: `PersonbrukerTilganger` fane (DetailPageContentFilterAndResult, operation `personbrukerMedTilganger`, cacheConfig-registrering av `Personbruker.fields.tilganger`)
- **Task #7**: `PersonbrukerRoller` fane (samme form)
- **Task #9**: `PersonbrukerStatusActions` i topbarens `actionsElement`-slot + deaktiver/reaktiver-modaler
- **Fix candidate (out of scope, flagged)**: `LayoutMessage` wraps element children in `<Paragraph>`, so nesting the Alert-based domain error components produces a dev-only `<p>><div>` DOM-nesting warning — pre-existing in the ApplikasjonDetails template; the right fix lives in `src/common/components/layouts/components/LayoutMessage/LayoutMessage.tsx`.

## Conclusion

The PersonbrukerDetails skeleton is complete, tested and green across typecheck/lint/unit/a11y/build, exactly framing Tasks #5, #7 and #9. Ready for review.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
