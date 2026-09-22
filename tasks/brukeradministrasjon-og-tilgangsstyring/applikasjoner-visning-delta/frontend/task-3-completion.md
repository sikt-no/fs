# Task #3 Completion Report: Refaktorer listevisnings-filter til å bruke nye kilder

## Status: COMPLETED

**Date Completed**: 2026-06-19
**Task**: Refaktorer listevisnings-filter til å bruke nye kilder
**Priority**: High
**Size**: S

## Summary

Switched the two listevisnings-filter components to consume the new TRANSITIONAL hooks introduced in Task #2. `ApplikasjonerMiljoFilter` now reads its options from `useGetMineSynligeMiljoer` instead of a hardcoded `[demo, prod]`-constant (and gets the same `disabled={loading || options.length === 0}` semantic the organisation-filter already had). `ApplikasjonerOrganisasjonFilter` swaps its hook from `useGetMineApplikasjonsAdminOrganisasjoner` (which represents *redigeringsrett*) to `useGetMineSynligeOrganisasjoner` (which represents *innsynsscope* — the rolle-utledet union (a)+(b) per analysis-beslutning #1). All TRANSITIONAL/intent doc-comments are updated to match the new semantics, and the existing a11y tests are re-pointed at the new mock-handlers.

## Files Created

None.

## Files Modified

### 1. `src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/filter/ApplikasjonerMiljoFilter/ApplikasjonerMiljoFilter.tsx`

Replaced the hardcoded `options: MiljoOption[] = [{ value: 'demo', label: t('miljoDemo') }, { value: 'prod', label: t('miljoProd') }]`-constant with `const { miljoer, loading } = useGetMineSynligeMiljoer()` + `const options = miljoer.map((m) => ({ value: m.kode, label: m.navn }))`. Added `disabled={loading || options.length === 0}` to the `Select` (per `fs-admin-inputs` §10/§D). Removed the `MiljoOption` local interface — `options` is now an anonymous inline-typed array, consistent with `ApplikasjonerOrganisasjonFilter`. Updated the JSDoc-comment to describe the new source (`mineSynligeMiljoer` rolle-utledet innsynsscope, union of (a)+(b)) and to remove the "Options are kept inline (demo / prod) until a dedicated `miljoer`-query exists"-stub-note. Chip-mode `getLabel(value)` logic unchanged — still uses `options.find((o) => o.value === selected)?.label ?? selected`; the array is re-evaluated on every render, which is fine since it's at most ~5 entries (per `analysis` § Technical Constraints and Op #2 § Lag C).

### 2. `src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/filter/ApplikasjonerOrganisasjonFilter/ApplikasjonerOrganisasjonFilter.tsx`

Swapped import + hook call from `useGetMineApplikasjonsAdminOrganisasjoner` to `useGetMineSynligeOrganisasjoner`. Hook return-shape is identical (`{ organisasjoner, loading, error }`) so no other changes were needed in the component body. Updated the JSDoc-comment: removed the "This intentionally does not show every org the admin can 'see' (synlighet is server-enforced for the list itself); the filter narrows within the admin's own orgs only"-text and replaced it with a short note that the hook returns `innsynsscope` (rolle-utledet union (a)+(b)) and a cross-link clarifying that `mineApplikasjonsAdminOrganisasjoner` is now reserved for `redigeringsrett` (Opprett-knapp-gating only).

### 3. `src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetMineApplikasjonsAdminOrganisasjoner.tsx`

Doc-comment-only update (no runtime change). Expanded the JSDoc-block to:

- Explicitly call out that this hook represents *redigeringsrett* only.
- List all four call-sites that still use it (`ApplikasjonerOverview`, `OpprettApplikasjonModal`, `TildelTilgangModal`, `FjernTilgangModal`) — i.e. it's no longer a filter-source.
- Cross-link the two sibling hooks `useGetMineSynligeOrganisasjoner` and `useGetMineSynligeMiljoer` which now own the filter-source semantic.
- Reference `plan-applikasjoner-visning-delta.md` § Key Technical Decisions #1 for the rationale.

Per File Changes Overview bullet #8 in the plan.

### 4. `src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/filter/ApplikasjonerMiljoFilter/ApplikasjonerMiljoFilter.a11y.test.tsx`

Wrapped both `render` calls in `<MockedProvider mocks={[miljoerMock]}>` to provide the data the component now expects from the `useGetMineSynligeMiljoer`-hook. The mock returns a deterministic `[{kode:'demo',navn:'Demo'},{kode:'prod',navn:'Prod'}]`-payload matching the production fixture-shape. Added `GET_MINE_SYNLIGE_MILJOER`-import. The component used to render with hardcoded options and didn't need an Apollo provider; now it does — same wrapper pattern as the existing `ApplikasjonerOrganisasjonFilter.a11y.test.tsx`.

### 5. `src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/filter/ApplikasjonerOrganisasjonFilter/ApplikasjonerOrganisasjonFilter.a11y.test.tsx`

Mock import + payload swapped from `GET_MINE_APPLIKASJONS_ADMIN_ORGANISASJONER` / `mineApplikasjonsAdminOrganisasjoner`-key to `GET_MINE_SYNLIGE_ORGANISASJONER` / `mineSynligeOrganisasjoner`-key — i.e. the test now mocks the hook the component actually calls. Data-shape (`[{id, navn, __typename:'Organisasjon'}]`) is identical so no further changes were needed.

### 6. `src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/ApplikasjonerFilter/ApplikasjonerFilter.test.tsx`

Composite-filter unit test (not part of the originally enumerated AC files, but it broke when the child filters changed their hook calls — a contract-driven update). Two changes:

- Mock-set widened: replaced single `orgsMock` (pointing at `GET_MINE_APPLIKASJONS_ADMIN_ORGANISASJONER`) with `orgsMock` (pointing at `GET_MINE_SYNLIGE_ORGANISASJONER`) plus a new `miljoerMock` (pointing at `GET_MINE_SYNLIGE_MILJOER`). Both are now passed to `MockedProvider`.
- Two test bodies — `hydrates input values from the URL` and `renders a chip for each non-empty filter value` — wrapped their now-async miljø-assertions in `waitFor(...)`. Reason: the miljø Select's `value` (and the corresponding chip-label resolution) now depends on options arriving from the `mineSynligeMiljoer`-query; the previous synchronous-options world doesn't apply anymore. The other 5 tests pass unchanged.

## Key Features Implemented

### Listevisning-filter now reflects rolle-utledet innsynsscope, not redigeringsrett

The user now sees in the miljø- and organisasjon-Selects exactly the entities the producer-side `mineSynlige*`-queries return — i.e. the union of (a) admin-egne orgs and (b) orgs that own applikasjoner with tilganger pointing into admin-egne data. This is the central correction the delta-iterasjonen requires (`spec-changes-2026-06-16-b0e8de5.md` § Endret). Mock-handlers from Task #1 supply the data; the hooks from Task #2 fetch it; this task wires them to the UI.

### Empty-list-disabled semantics aligned across both filters

Both `ApplikasjonerMiljoFilter` and `ApplikasjonerOrganisasjonFilter` now `disabled={loading || options.length === 0}` on their Selects (per `fs-admin-inputs` §10/§D — `Select` must `disabled` while loading or when no options can be selected). This was already in place for the organisasjon-filter; the miljø-filter inherited it as part of switching off the hardcoded constant.

### Semantic separation `redigeringsrett` vs. `innsynsscope` preserved

The existing `useGetMineApplikasjonsAdminOrganisasjoner`-hook is unchanged at the runtime level — only its doc-comment is updated to make the new semantic split explicit and traceable. All four `Opprett`-gating call-sites continue to use it (per `analysis` § Open Questions decision #3). This guarantees the two business rules stay independent and can evolve separately.

### TRANSITIONAL-kommentarer ajourført

Both filter-component-kommentarer no longer reference the demo/prod-stub (miljø) or the "intentionally does not show every org"-explanation (organisasjon), and the redigeringsrett-hook's kommentar makes the cross-link to the new sibling-hooks discoverable. The hook-files themselves (`useGetMineSynligeMiljoer.tsx` / `useGetMineSynligeOrganisasjoner.tsx`) already shipped with the canonical TRANSITIONAL-block from Task #2 — no changes needed there.

### Chip-rendering unchanged

`getLabel(value)` still does `options.find((o) => o.value === selected)?.label ?? selected`. After the swap `options` re-evaluates on each render (rather than being a constant) but this is intentional — the array is small (~2-5 entries), chips only render when a value is selected, and the lookup is O(n) over a tiny list. Verified by the `renders a chip for each non-empty filter value`-test in `ApplikasjonerFilter.test.tsx`.

## Project skills consulted

- **`fs-admin-inputs`** (invocert via `Skill`-verktøyet): Confirmed §10/§D — `Select` must `disabled` when `loading || options.length === 0`. The miljø-filter ACs quote this rule verbatim. Also confirmed §A — a `value=''` first option (`"Alle miljøer"` / `"Alle organisasjoner"`) is the right pattern for these optional filters; both filters had this from greenfield and it was preserved.
- **`fs-admin-list-filters`** (invocert via `Skill`-verktøyet): Confirmed that the dual-render contract (`renderAsChip` chip-mode + full-input-mode) is preserved across the swap. The `getLabel`-lookup against the full options-array is the canonical chip-rendering pattern. Confirmed that `options` re-evaluating on each render is fine for short lists (§"chip-mode-grenen bruker `options.find()` mot full options-array"-note from the Implementation Notes of Task #3 itself, also reflected in the skill's chip-rendering pattern). Reviewed sibling-filters (`ApplikasjonerStatusFilter`, `ApplikasjonerNavnFilter`) for the §"composite-wide audit"-step: both are out-of-scope per Task #3's note ("IKKE påvirket av denne delta-en — ikke rør dem") and both already follow the skill — no remediation needed.
- **`graphql-consumer`** (invocert via `Skill`-verktøyet): Confirmed the consumer-side pattern `const { miljoer, loading } = useGetMineSynligeMiljoer()` — name matches the producer-side operation, `useQuery`-via-`useGetXxx`-helper is the idiomatic shape. Existing TRANSITIONAL flat-`gql`-mønster (per plan-beslutning #6) is mirrored by both new hooks — no new operation authoring on this task, just wiring up the call-sites.

## Test Results

### Touched a11y tests (the AC's primary acceptance gate)

```
$ npx jest --config=jest.a11y.config.ts \
    --testPathPatterns="src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/filter/(ApplikasjonerMiljoFilter|ApplikasjonerOrganisasjonFilter)"

Test Suites: 2 passed, 2 total
Tests:       5 passed, 5 total
Snapshots:   0 total
Time:        3.096 s
```

Both a11y test files (3 tests in `ApplikasjonerMiljoFilter.a11y.test.tsx` + 2 tests in `ApplikasjonerOrganisasjonFilter.a11y.test.tsx`) green.

### Unit test for the composite filter (regression check)

```
$ npx jest src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/ApplikasjonerFilter

Tests:       7 passed, 7 total
Test Suites: 1 passed, 1 total
```

All 7 tests in `ApplikasjonerFilter.test.tsx` green after the mock + `waitFor`-updates.

### Full ApplikasjonerOverview unit suite

```
$ npm test -- --testPathPatterns="src/domains/tilgangsstyring/features/ApplikasjonerOverview"

Test Suites: 7 passed, 7 total
Tests:       41 passed, 41 total
```

### Full tilgangsstyring a11y suite

```
$ npx jest --config=jest.a11y.config.ts --testPathPatterns="src/domains/tilgangsstyring"

Test Suites: 25 passed, 25 total
Tests:       55 passed, 55 total
```

### Full tilgangsstyring unit suite

```
$ npm test -- --testPathPatterns="src/domains/tilgangsstyring"

Test Suites: 1 failed, 20 passed, 21 total
Tests:       1 failed, 149 passed, 150 total
```

149/150 grønne. The 1 failure is `ApplikasjonPassord.test.tsx › drops the password from the DOM when the result dialog is closed via "Lukk"` — **pre-existing** on `applications-and-application-detail-delta`-branch (documented in both `task-1-completion.md` line 121 and `task-2-completion.md` lines 95-97 as unrelated to delta-arbeidet). Not introduced by this task.

## Technical Decisions

### 1. Wrap `ApplikasjonerMiljoFilter.a11y.test.tsx` in `MockedProvider`

**Why**: Previously the component had hardcoded options and rendered without any Apollo data — no provider was needed. After the swap to `useGetMineSynligeMiljoer`, the component issues a `useQuery`-call on every render, which would throw "No ApolloClient instance found" if no provider is in scope. The test was always going to need updating; the existing `ApplikasjonerOrganisasjonFilter.a11y.test.tsx` had `MockedProvider` for the same reason, so I mirrored the exact pattern.

### 2. `waitFor` in the two `ApplikasjonerFilter.test.tsx` tests, not full re-architecture

**Why**: The composite-filter test was not in the listed AC-scope, but it broke because the children's data-source moved from a synchronous constant to an asynchronous `useQuery`-hook. Five of the seven tests passed without modification (they don't assert on miljø-specific Select-state). The two that do — `hydrates input values from the URL` (asserts `miljoLabel`'s `value` after URL-driven hydration) and `renders a chip for each non-empty filter value` (asserts the `miljoProd`-chip label) — now genuinely need to wait for the async response. Adding a `waitFor` block around the miljø-specific assertion is the minimal repair; the other assertions (`navnLabel`, `statusLabel`) stay synchronous because they don't depend on Apollo data. This avoids reworking unrelated tests or restructuring the file.

### 3. Mock-payload uses translation-key strings for `navn` in `ApplikasjonerFilter.test.tsx`

**Why**: `jest.setup` mocks `useTranslations` to return the translation KEY verbatim (top-of-file comment in the test). Production-code passes `miljoer[i].navn` directly to the Select-option as `label` — no `t()`-call around it. So if the mock returns `navn: 'Demo'` literally, the chip's text would be `'Demo'`. But the existing chip-mode-test asserts `expect(screen.getByText('miljoProd')).toBeInTheDocument()` — which is the translation-key, not the literal `'Prod'`. To keep the test's assertion working (and to avoid changing the chip-mode test in a way that diverges from how the rest of the test file uses translation-keys), the miljø-fixture in the test uses `navn: 'miljoDemo'` / `navn: 'miljoProd'` — i.e. the test fixture supplies translation-keys-as-navn for the assertion to match. This is a test-fixture concern, not a production-code one; production `Miljo.navn` is the human-readable Norwegian name (`'Demo'` / `'Prod'`).

### 4. Did NOT touch `useGetMineApplikasjonsAdminOrganisasjoner` runtime, only its doc-comment

**Why**: AC explicitly says "Eksisterende `useGetMineApplikasjonsAdminOrganisasjoner` beholdes uendret for de fire Opprett-gating call-sitene" (`analysis` § Open Questions decision #3 / `plan` § File Changes Overview bullet #8). Verified via `git diff` that only the JSDoc-block changed — no `gql`-import, no operation-string, no return-shape change. The four call-sites (`ApplikasjonerOverview.tsx:47`, `OpprettApplikasjonModal.tsx:72`, `TildelTilgangModal.tsx:77`, `FjernTilgangModal.tsx:94`) still consume the hook unchanged.

### 5. No Storybook stories to update

**Why**: AC says "Storybook-stories (hvis de finnes) oppdatert" — they don't. Confirmed via `find /Users/mats.myhre/Dev/Sikt/fs-admin/src/domains/tilgangsstyring -name "*.stories.*"` — zero hits across the entire tilgangsstyring-domain. The conditional in the AC ("hvis de finnes") covers this exactly.

## Build Status

- **`npm run test:typecheck`** — 23 pre-existing errors (same count as in Task #1 and Task #2 completion reports). Zero new errors introduced by this task. None of the errors are in any file I touched; verified via `npm run test:typecheck 2>&1 | grep tilgangsstyring` returning empty.
- **`npm run lint:ts`** — 0 errors, 241 warnings. Same warning count as before; the only warnings on my files are the expected TRANSITIONAL `gql`-import-warning (per plan-beslutning #6) on the `useGetMineApplikasjonsAdminOrganisasjoner`-hook, and a pre-existing `fireEvent`-warning on `ApplikasjonerFilter.test.tsx` (the import existed before my edit; I didn't add it).
- **`npx eslint`** scoped to the modified files — 0 errors, 2 expected warnings (TRANSITIONAL `gql`, pre-existing `fireEvent`).
- **A11y suite for the two filter components** — 5/5 green.
- **Unit suite for `ApplikasjonerFilter.test.tsx`** — 7/7 green.
- **Full tilgangsstyring a11y suite** — 25/25 suites, 55/55 tests green.
- **Full tilgangsstyring unit suite** — 149/150 tests green; the 1 failure is pre-existing and unrelated (documented in Task #1/#2 completion reports).
- **`npm run build`** not run — would take several minutes for a delta-iterasjon that touches 4 source files + 2 test files. All build-relevant gates (typecheck, lint, all relevant test-suites) are individually green for the modified files.

## Integration Points

- **`src/mocks/applikasjoner/handlers/queries.ts`** (Task #1): The two MSW-handlers `mineSynligeOrganisasjonerHandler` and `mineSynligeMiljoerHandler` are now actively consumed by the filter components — they were previously dormant after Task #1 + Task #2 (only the hook-unit-tests touched them, via `MockedProvider`). End-to-end mock-flow is now wired from MSW → hook → filter-component.
- **`useGetMineApplikasjonsAdminOrganisasjoner`** (existing hook): Continues to gate `Opprett`-button visibility on `ApplikasjonerOverview.tsx:47`, the modal eier-org-Select on `OpprettApplikasjonModal.tsx:72`, and the gate-checks on `TildelTilgangModal.tsx:77` / `FjernTilgangModal.tsx:94`. Its semantic is now documented as `redigeringsrett` only — distinct from the two new `Synlige*`-hooks.
- **Apollo cache** (analyse-beslutning #4): No new invalidering needed. Both `mineSynligeOrganisasjoner` and `mineSynligeMiljoer` use `fetchPolicy: 'cache-first'` per Task #2; `usePersonaOverride.applyPersonaChange` (`src/common/lib/persona/hooks/usePersonaOverride.ts:32-53`) clears the whole cache on persona-bytte, which catches these queries along with everything else.
- **Task #4** (tilganger-tab): Untouched by this task. Task #4 will extend `GET_APPLIKASJON_TILGANGER` with `tilgangerMiljoer` / `tilgangerOrganisasjoner` server-derived fields and prop-drill them to the tab's filter components.

## Acceptance Criteria Met

- **`ApplikasjonerMiljoFilter.tsx`: hardkodet `options: MiljoOption[] = [...]`-konstant fjernet; `miljoer, loading` hentes fra `useGetMineSynligeMiljoer`. `options`-array bygget som `miljoer.map((m) => ({ value: m.kode, label: m.navn }))`. `disabled={loading || options.length === 0}` lagt til på `Select` (per fs-admin-inputs §10).**
  Evidence: `src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/filter/ApplikasjonerMiljoFilter/ApplikasjonerMiljoFilter.tsx:38` (hook call), `:40` (options map), `:64` (`disabled={loading || options.length === 0}`). No `MiljoOption` constant anywhere in the file.

- **`ApplikasjonerOrganisasjonFilter.tsx`: import bytt fra `useGetMineApplikasjonsAdminOrganisasjoner` til `useGetMineSynligeOrganisasjoner`. Kommentar-blokk oppdatert — fjern "intentionally does not show every org…"-tekst, erstatt med kort note om at hooken returnerer `innsynsscope` (rolle-utledet union (a)+(b)).**
  Evidence: `src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/filter/ApplikasjonerOrganisasjonFilter/ApplikasjonerOrganisasjonFilter.tsx:9` (new import), `:37` (new hook call), `:20-24` (updated comment: "Options come from `mineSynligeOrganisasjoner` — the rolle-utledet *innsynsscope* on organisasjon-nivå (union of (a) organisations the admin can administer and (b) organisations that own applikasjoner with tilganger pointing into data the admin administers). Semantically distinct from `mineApplikasjonsAdminOrganisasjoner`, which expresses *redigeringsrett* and is used for Opprett-knapp-gating."). Old "intentionally does not show every org…"-text removed.

- **TRANSITIONAL-kommentar-blokker oppdatert med ny situasjon (fjern "demo / prod-stub" i miljø, fjern "intentionally does not show"-tekst i organisasjon).**
  Evidence: `ApplikasjonerMiljoFilter.tsx:17-31` — JSDoc-blokken refererer nå til `mineSynligeMiljoer` som kilde, beskriver union (a)+(b), forklarer §10 disabled-regelen. Ingen referanser til "demo / prod stub" eller "Options are kept inline (demo / prod) until a dedicated `miljoer`-query exists" lenger. `ApplikasjonerOrganisasjonFilter.tsx:17-29` — JSDoc-blokken refererer nå til `mineSynligeOrganisasjoner` og forklarer skillet mot `mineApplikasjonsAdminOrganisasjoner`. Ingen "intentionally does not show"-tekst lenger.

- **Eksisterende `*.a11y.test.tsx` for begge komponentene grønne — MSW returnerer nye queries automatisk via handlers fra Task #1.**
  Evidence: 5/5 tests passing — `npx jest --config=jest.a11y.config.ts --testPathPatterns="src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/filter/(ApplikasjonerMiljoFilter|ApplikasjonerOrganisasjonFilter)"`. Both test-filer ble oppdatert til å bruke `MockedProvider` med de nye queriene (`GET_MINE_SYNLIGE_MILJOER` / `GET_MINE_SYNLIGE_ORGANISASJONER`) i stedet for det gamle. Strengt tatt bruker testene `MockedProvider`, ikke MSW direkte — samme tilnærming som hele tilgangsstyring-test-suiten følger (se Technical Decision #2 i `task-2-completion.md`).

- **Storybook-stories (hvis de finnes) oppdatert: bytt mock fra hardkodet `[demo, prod]` til MSW-handler-svar (samme rigg som andre tilgangsstyring-stories).**
  Evidence: Conditional N/A. Confirmed via `find /Users/mats.myhre/Dev/Sikt/fs-admin/src/domains/tilgangsstyring -name "*.stories.*"` — zero results. No tilgangsstyring-stories exist; the AC's "hvis de finnes"-condition is unmet by the codebase. Documented in Technical Decision #5.

- **Chip-rendering uendret — `getLabel(value)` finner `miljoer.find((o) => o.value === selected)?.label`.**
  Evidence: `ApplikasjonerMiljoFilter.tsx:50-52` (`return options.find((o) => o.value === selected)?.label ?? selected`). `ApplikasjonerOrganisasjonFilter.tsx:49-51` (samme mønster). Verifisert av `ApplikasjonerFilter.test.tsx` § `renders a chip for each non-empty filter value` — chipet for `miljoKode=prod` viser `miljoProd`-labelet etter at `mineSynligeMiljoer`-queryen returnerer. The `options.find()`-lookup is over the full options-array (re-evaluated each render); array is small (~5 entries max), so the cost is negligible per the plan's Implementation Notes.

## Next Steps

- **Task #4** (Utvid `applikasjonMedTilganger`-query med filter-kilder og refaktorer tilganger-tab-filter) is unblocked by this task — it's an independent parallel track. Same delta-iteration, different feature (`ApplikasjonDetails/components/ApplikasjonTilganger/`), different data source (server-derived fields on `Applikasjon` rather than top-level Query fields), no overlap with the listevisning-filter files touched here.
- **Producer-side schema work** (cross-contributor) for `Query.mineSynligeOrganisasjoner` / `Query.mineSynligeMiljoer` is now confirmed end-to-end on the consumer side — fs-admin can drive the contract from the mock until the producer-PR lands. When it lands, the TRANSITIONAL-blokker in both hooks (per Task #2) tell the migrating developer exactly what to do (re-run `npm run compile`, swap `gql`-import, replace local types, delete the comment block).

## Conclusion

Listevisnings-filter-svingen er fullført. Begge filter-komponentene henter nå sine options fra de nye `mineSynlige*`-queriene, semantisk skille mellom `redigeringsrett` (`mineApplikasjonsAdminOrganisasjoner`) og `innsynsscope` (`mineSynlige*`) er dokumentert i koden, og a11y-tester + den composite-filter unit-testen er oppdatert til å speile den nye data-flyten. Tilgangsfanen (`ApplikasjonTilganger`) er ikke berørt — det er Task #4 sitt ansvar. Mock-API-en fra Task #1 leverer dataene end-to-end uten ytterligere konfigurasjon; ingen producer-rundtur kreves for å verifisere flyten lokalt.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
