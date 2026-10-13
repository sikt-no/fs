# Task #6 Completion Report: TildelTilgangModal + FjernTilgangModal med delvis-suksess-håndtering

## Status: ✅ COMPLETED

**Date Completed**: 2026-07-08
**Task**: TildelTilgangModal + FjernTilgangModal med delvis-suksess-håndtering
**Priority**: High
**Size**: L

## Summary

Implemented the two tildelings-modals for the Personbruker Tilganger-tab (BRU-PER-GRU-003): `TildelTilgangModal` (Organisasjon → Miljø → checkbox multi-select of tildelbare tilganger, cascade-enabled, lazy Op #4-query, `alleredeTildelt` disabled with explanation) and `FjernTilgangModal` (destructive `variant="critical"` submit, multi-select among the user's existing AKTIVE tildelinger within valgt org+miljø). Both consume the Op #5-mutations through new typed hooks with `refetchQueries: ['personbrukerMedTilganger']` + `awaitRefetchQueries: true`, and both implement the delvis-suksess-switch that is new relative to the applikasjoner-template: on `Suksess` with `avviste.length > 0` the modal stays open and shows a per-element result panel (what went through, what was rejected, with per-element årsak); full success closes with a snackbar; `MutasjonAvvist` renders inline without closing. The Task #5 actionbar buttons are now wired to open the modals.

## Files Created

All paths relative to `/Users/mats.myhre/Dev/Sikt/fs-admin/src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerTilganger/`.

### Hooks (`hooks/`)

### 1. `useTildelbarePersonbrukerTilganger.tsx` (77 lines)

`useLazyQuery`-hook for Op #4 (`tildelbarePersonbrukerTilganger(personbrukerId, organisasjonId, miljoKode)`), `fetchPolicy: 'cache-and-network'`. Fired from the Tildel-modal only when BOTH org AND miljø are chosen (cascade), and re-executed after delvis suksess so newly-tildelte rows flip to disabled.

### 2. `useTildelbarePersonbrukerTilgangerTypes.ts` (50 lines)

Transitional types for the Op #4 contract (`TildelbarTilgangNode { tilgangskode, navn, alleredeTildelt }`), with the standard migration recipe for when the real schema lands.

### 3. `useFjernbarePersonbrukerTilganger.tsx` (103 lines)

`useLazyQuery`-hook for the Fjern-modal's source list over `personbruker(id) { tilganger(...) }` with server-side filter `{ status: AKTIV, organisasjonId }`. **Deliberately named operation `personbrukerMedTilganger`** — the personbrukere-mock has no dedicated fjernbare-handler (MSW matches by operation name and returns the full type-space), and sharing the name means the mutations' `refetchQueries` refreshes the modal's own list too. The duplicate-op-name situation is safe while `src/domains/tilgangsstyring/**` is codegen-excluded; the docstring carries the rename-on-migration note (same situation as `applikasjonFjernbareTilganger`).

### 4. `useFjernbarePersonbrukerTilgangerTypes.ts` (90 lines)

Transitional types for the fjern-source rows (`id, tilgangskode, navn, status, miljo { kode }, kanFjernes`) — a leaner, different field-set than the tab list (needs `tilgangskode` for the mutation input and `miljo.kode` for client-side miljø-narrowing, since `PersonbrukerTilgangerFilter` has no miljø-field).

### 5. `useTildelPersonbrukerTilganger.tsx` (93 lines)

Op #5-mutation hook: `useMutation(TILDEL_PERSONBRUKER_TILGANGER, { refetchQueries: ['personbrukerMedTilganger'], awaitRefetchQueries: true })`. Selection per plan Lag B: `personbruker { id antallTilganger }`, `tildelte { id navn }`, `avviste { kode navn arsak feilmelding }`, plus the `MutasjonAvvist`-arm.

### 6. `useTildelPersonbrukerTilgangerTypes.ts` (133 lines)

Transitional mutation types incl. the shared envelope pieces (`TildelingAvvist`, `TildelingAvvistArsak`, `MutasjonAvvist`, `MutasjonAvvistArsak`) and the mock's trigger conventions documented in the header.

### 7. `useFjernPersonbrukerTilganger.tsx` (84 lines)

Op #5-mutation hook for `fjernPersonbrukerTilganger` — same refetch strategy; suksess-variant carries `fjernede` (bare koder per plan) + `avviste`.

### 8. `useFjernPersonbrukerTilgangerTypes.ts` (88 lines)

Transitional fjern-mutation types; re-exports the shared envelope types from the tildel-types file (same pattern as `useFjernApplikasjonTilgangerTypes`).

### Components (`components/`)

### 9. `TildelTilgangModal/TildelTilgangModal.tsx` (359 lines)

The tildel-modal. Organisasjon-select (kilde `mineBrukerAdminOrganisasjoner`, single-org prefilled+disabled), Miljø-select (kilde `personbrukereFilterOptions.miljoer` — NOT hardcoded, unlike the applikasjoner-template whose hardcoding is a known cleanup point), checkbox-fieldset (lazy Op #4, cascade-enabled, `alleredeTildelt` disabled with "(allerede tildelt)"-explanation). Submit-switch: full success → close + snackbar; delvis suksess → stays open with per-element result panel (success-Alert with tildelte-liste + critical-Alert with avviste-liste incl. feilmelding per element), selection cleared, tildelbare-list re-fetched; `MutasjonAvvist` → inline critical Alert. Async submit: `disabled={submitLoading}` + progressive label «Tildeler …» + spinner + `aria-busy`.

### 10. `TildelTilgangModal/TildelTilgangModal.module.css` (69 lines)

Non-layout styling only (border/colors/spinner/list) — all flex layout is done with the `<Flex>` helper in the TSX per the fs-admin layout rule (no `display: flex` in new CSS, unlike the grandfathered template CSS).

### 11. `TildelTilgangModal/TildelTilgangModal.test.tsx` (547 lines)

8 unit tests: opening, cascade-enabling (miljø disabled until org; miljø options sourced from filterOptions), lazy query + `alleredeTildelt` disabled rows, submit gating, full success (close + snackbar), async in-flight state (disabled + «tildelerAction»-label, via delayed mock), delvis suksess (modal open, per-element panel, feilmelding visible, refreshed list flips row to disabled, no snackbar), totalavvisning/`MutasjonAvvist` (inline error, modal open, no panel).

### 12. `TildelTilgangModal/TildelTilgangModal.a11y.test.tsx` (160 lines)

4 jest-axe states: closed, open single-org, open multi-org, rows loaded incl. disabled `alleredeTildelt`-row (driven with userEvent so the loaded state is genuinely exercised).

### 13. `FjernTilgangModal/FjernTilgangModal.tsx` (375 lines)

The fjern-modal (destructive variant). Same cascade skeleton; source list = existing AKTIVE tildelinger within valgt org+miljø (server filter `{ status: AKTIV, organisasjonId }`, client-narrow on `miljo.kode` + defensive AKTIV-assertion). Rows with `kanFjernes === false` remain selectable — the server rejects them per element and the panel explains why (this makes the `pb-kan-ikke-fjernes`-fixture demonstrable end-to-end; see Technical Decisions). Submit button `variant="critical"` (rød) with progressive «Fjerner …»-label. Delvis-suksess panel maps the returned `fjernede`-koder back to display-navn via a snapshot taken BEFORE the mutation (the source list refetches and shrinks before the promise resolves under `awaitRefetchQueries`).

### 14. `FjernTilgangModal/FjernTilgangModal.module.css` (59 lines)

Non-layout styling only, same rules as the tildel-modal CSS.

### 15. `FjernTilgangModal/FjernTilgangModal.test.tsx` (551 lines)

8 unit tests: opening + cascade, critical-variant assertion on the submit button, source-list loading (navn + kode), client-side miljø-narrowing, full success (close + snackbar), async in-flight state, delvis suksess (fjernede-navn + avviste med feilmelding, refetched list shrinks, modal open, no snackbar), totalavvisning/`MutasjonAvvist`. Every submit-test provides the post-mutation refetch mock (the modal's own active `personbrukerMedTilganger` observer is refetched by the mutation — also on the `MutasjonAvvist`-branch).

### 16. `FjernTilgangModal/FjernTilgangModal.a11y.test.tsx` (174 lines)

4 jest-axe states: closed, open single-org, open multi-org, source list loaded (driven with userEvent).

## Files Modified

### 1. `.../PersonbrukerTilgangerActionbar/PersonbrukerTilgangerActionbar.tsx` (102 lines)

Wired the Task #5 buttons: dropped the `disabled`-props and TODO(Task #6)-comment, added `tildelModalOpen`/`fjernModalOpen` state and mounted both modals (gated on `kanTildeleTilganger`/`kanFjerneTilganger`), mirroring `ApplikasjonTilgangerActionbar` exactly.

### 2. `.../PersonbrukerTilgangerActionbar/PersonbrukerTilgangerActionbar.test.tsx` (188 lines)

Wrapped in `MockedProvider` (the mounted modals query orgs + filter-options on mount), replaced the "buttons disabled until Task #6"-test with two modal-open tests (click → dialog heading appears), kept all gating tests.

### 3. `.../PersonbrukerTilgangerActionbar/PersonbrukerTilgangerActionbar.a11y.test.tsx` (113 lines)

Wrapped in `MockedProvider` for the same reason; same two axe-states as before.

### 4. `src/common/messages/nb/domains.json`

Added the namespaces `tilgangsstyring.PersonbrukerTildelTilgangModal` (18 keys) and `tilgangsstyring.PersonbrukerFjernTilgangModal` (17 keys): titles, «Avbryt», action/progressive labels («Tildel tilganger»/«Tildeler …», «Fjern tilganger»/«Fjerner …»), noun-phrase input labels (Organisasjon/Miljø/Tilganger), «Ikke valgt»-null-options, hint/loading/empty-texts, `alleredeTildelt`-suffix, pluralized `successToast` and the delvis-suksess headings (`delvisTildelteHeading`/`delvisFjernedeHeading`/`delvisAvvisteHeading`).

### 5. `.../PersonbrukerTilganger/PersonbrukerTilganger.tsx`

Docstring only: the actionbar note no longer says "buttons disabled until Task #6".

## Key Features Implemented

### ✅ Kaskade-flyt (Organisasjon → Miljø → Tilganger)

Miljø-select disabled until org is chosen (and while options load / are empty, per `fs-admin-inputs` §10/§D); tilganger-fieldset disabled with hint text until BOTH are chosen; Op #4 / source-list queries fire lazily only then. Single-org admins get the org prefilled + disabled.

### ✅ `alleredeTildelt` disabled med forklaring

Rows are rendered gråtonet, `disabled` on the `CheckboxInput`, with an "(allerede tildelt)"-suffix.

### ✅ Delvis suksess (the new part vs. the applikasjoner-template)

On `Suksess` with `avviste.length > 0` the modal stays open and shows a two-part result panel: a success-Alert listing what went through (navn per element) and a critical-Alert (role="alert") listing every rejected element with its server-provided feilmelding. Full success closes with a pluralized snackbar; `MutasjonAvvist` shows inline without closing. Tildel additionally re-fetches the tildelbare-list (tildelte flip to disabled); Fjern's list refreshes automatically via the shared operation name.

### ✅ Async-knapper

`disabled={submitLoading}` + progressive label («Tildeler …»/«Fjerner …») + spinner icon + `aria-busy` — per `fs-admin-buttons` rule 3.

### ✅ Destruktiv variant

Fjern-modalens submit er `FSButton variant="critical"` (rød); the modal itself is the explicit confirmation step (custom-Dialog pattern per `fs-admin-buttons` rule 4). The actionbar-trigger stays `subtle` — destructive emphasis at the point of confirmation, mirroring applikasjoner.

## Project skills consulted

- **`graphql-consumer`** — operation placement (transitional flat style mirrored, deviation is the documented transitional pattern in the area), typed `TypedDocumentNode` casts, single `$input`-argument on mutations, `__typename`-switch on the union envelope, `useLazyQuery` for on-demand fetches, no `queries.ts` barrel, enums imported from the (transitional) types modules. The `gql`-from-`@apollo/client` import is the area's established transitional pattern (codegen excluded until the real schema lands) — every file carries the migration recipe.
- **`fs-admin-buttons`** — async-button pattern (disabled + progressive label), `variant="critical"` + explicit-confirmation for the destructive fjern-action, verb-phrase labels via `t(...)`, modal-footer variant table.
- **`fs-admin-inputs`** — noun-phrase labels («Organisasjon», «Miljø», «Tilganger»), «Ikke valgt»-null-options, `disabled` on selects with unmet prerequisites / no options, `autoComplete="off"`, no placeholders, controlled inputs, `CheckboxInput` for many-of-N.
- **`fs-admin-grid-and-flex`** — zero `display: flex`/`display: grid` in the new CSS modules; all layout via `<Flex>` (dialog body stack, checkbox column, footer row); CSS modules carry only non-layout styling.
- **i18n conventions (`src/common/messages/CLAUDE.md`)** — component-named namespaces in `domains.json`; prefixed `Personbruker*` to avoid colliding with the applikasjoner-modals' existing namespaces (documented in the component docstrings).

## Test Results

All test files are TypeScript (`.tsx`), run via the project's Jest configs:

- `npx jest --config jest.config.ts src/domains/tilgangsstyring/features/PersonbrukerDetails` → **10 suites, 65 tests passed** (includes the 8+8 new modal tests + 7 updated actionbar tests)
- `npm test` (full unit suite) → **231 suites, 1866 passed, 3 skipped** (the global coverage-threshold notice is pre-existing: coverage is only collected from `src/features/**`/`src/app/_components/**`/`src/utils/**`/`src/hooks/**`, none of which this task touches; branch coverage is checked via `npm run test:sincemain` in CI per project convention)
- `npm run test:a11y` (full a11y suite) → **279 suites, 889 passed** (8 new axe-tests across the two modals; actionbar a11y updated)
- `npm run test:typecheck` → **passes**
- `npm run lint` → **0 errors**; the warnings in the new files are the exact same transitional-pattern warnings the canonical applikasjoner-template files already carry (`no-restricted-imports` on the transitional `gql`-import, `react-hooks/set-state-in-effect` on the template's prefill/reset-effects) — no new warning classes
- `npm run formatcheck` → all `src/` files clean (the two remaining warnings are pre-existing untracked `docs/ingest/` files unrelated to this task)

Coverage of the required paths: **full suksess** (both modals: close + snackbar), **delvis suksess** (both modals: panel with per-element result, modal open, list refresh), **totalavvisning** (`MutasjonAvvist`: inline error, modal open) — plus cascade, gating, disabled rows, miljø-narrowing and in-flight button state.

## Technical Decisions

### 1. Fjern-source query reuses the operation name `personbrukerMedTilganger`

**Why**: The personbrukere-mock (Task #1, untouchable) registers handlers only for the contract's operation names; there is no fjernbare-specific handler. MSW matches by operation name and returns the full type-space, so the modal defines its own lean selection under the shared name. Bonus: the mutations' `refetchQueries: ['personbrukerMedTilganger']` automatically refreshes the modal's own list. Safe while the folder is codegen-excluded; the hook docstring carries the rename-on-migration note (same as `applikasjonFjernbareTilganger` did for the applikasjoner-mock, which registered a separate handler — the personbrukere-mock did not).

### 2. Miljø narrowed client-side in the Fjern-modal

**Why**: `PersonbrukerTilgangerFilter` (plan Op #2) has no `miljoKode`-field, so the source query filters on `{ status: AKTIV, organisasjonId }` server-side and the modal narrows on `miljo.kode` client-side (hence `miljo { kode }` in the selection). A defensive `status === AKTIV` assertion also runs client-side — silently dropping is the safer failure mode for a destructive action.

### 3. `kanFjernes === false`-rows stay selectable in the Fjern-modal

**Why**: The acceptance criterion asks for multi-select among "eksisterende AKTIVE tildelinger innen valgt org+miljø" (no kanFjernes-carve-out), and the mock deliberately keeps the `pb-kan-ikke-fjernes`-fixture's tildeling rejectable per element so delvis suksess is demonstrable on fjern (mirroring how sperret/utgått stay listed in tildelbare). The server is the authority; the per-element panel explains the rejection. (The applikasjoner-template filtered these out due to a feature-specific krav-regel that does not apply here.)

### 4. Fjernede-navn snapshotted before the mutation

**Why**: The fjern-suksess-variant returns bare koder, and with `awaitRefetchQueries: true` the source list has already been refetched (and shrunk) by the time the promise resolves — so the kode→navn lookup map is built from the pre-mutation rows.

### 5. Separate i18n namespaces `PersonbrukerTildelTilgangModal`/`PersonbrukerFjernTilgangModal`

**Why**: `domains.tilgangsstyring.TildelTilgangModal`/`FjernTilgangModal` are already owned by the applikasjoner-modals with partially different content (and plan decision #2 forbids sharing between the features). The prefix follows the file's existing `Personbruker*`-naming; the deviation from the exact-component-name convention is documented in both component docstrings.

### 6. Delvis-suksess panel rendered inline in each modal (no shared component)

**Why**: Plan decision #2 — parallel implementations, no shared parameterized abstractions in this round. Task #8's rolle-modals will mirror the same panel; if the duplication stings, refactoring is a separate sak (per the plan's own note).

### 7. New CSS modules contain no `display: flex`

**Why**: `fs-admin-grid-and-flex` hard rule for new code. The applikasjoner-template's CSS (grandfathered) uses `display: flex` in `.form`/`.tilgangskoderFieldset`/`.tilgangskodeRow`; the new modals move that layout to `<Flex>` helpers (dialog-body stack, checkbox column) and keep only non-layout styling in CSS.

## Build Status

✅ **Build successful** — `npm run build` completes; `/tilgangsstyring/personbrukere/[id]` compiles.
✅ **No new linter warnings** — 0 errors; warnings match the template's established transitional patterns 1:1.
✅ **All imports resolved correctly** — typecheck clean.

## Integration Points

- **Task #5 (Tilganger-fane)**: `PersonbrukerTilgangerActionbar` now opens the modals; the tab's `personbrukerMedTilganger`-list refetches after every mutation (filter/sort/paging state preserved).
- **Task #4 (detaljside)**: the mutations select `personbruker { id antallTilganger }`, so the normalized cache keeps any mounted detail-surface's count fresh.
- **Task #1 (mock-API)**: consumed unmodified — operation names, envelope shapes and rejection triggers (`SPERRET-TILGANG` → MANGLER_RETTIGHET, `UTGATT-TILGANG` → UGYLDIG_TILSTAND, `pb-kan-ikke-fjernes` → fjern-avvisning, `MANGLER_RETTIGHET`-id / deaktivert bruker → MutasjonAvvist) all work end-to-end in dev.
- **Task #8 (rolle-modals)**: these two modals + hook-pairs are the declared template for the Op #6-consumers («samme flyt som Task #6», «delvis-suksess-håndtering identisk»).

## Acceptance Criteria Met

- ✅ `TildelTilgangModal/` med Organisasjon-select (`mineBrukerAdminOrganisasjoner`) → Miljø-select (`filterOptions.miljoer`) → checkbox-fler-valg (Op #4, lazy, kaskade); `alleredeTildelt` disabled med forklaring — Evidence: `TildelTilgangModal.tsx` (selects: ~L280–300; fieldset: ~L302–357), tests «kaskade-enabling» in `TildelTilgangModal.test.tsx`
- ✅ `FjernTilgangModal/` — destruktiv variant (`variant="critical"`) med fler-valg blant eksisterende AKTIVE tildelinger innen valgt org+miljø — Evidence: `FjernTilgangModal.tsx` (~L262 critical-button; source filter ~L118–131 + client-narrow ~L186–189), test «renders the primary submit button with the critical (rød) FSButton variant»
- ✅ `hooks/useTildelPersonbrukerTilganger.tsx` + `useFjernPersonbrukerTilganger.tsx` med `refetchQueries: ['personbrukerMedTilganger']` + `awaitRefetchQueries: true` — Evidence: both hook files, bottom `useMutation`-wrappers
- ✅ Delvis suksess: `avviste.length > 0` → modal holdes åpen med per-element-resultat; full suksess lukker med bekreftelse; `MutasjonAvvist` inline uten å lukke — Evidence: submit-switch in both modals + the three «submission — …»-describe-blocks in each test file
- ✅ Async-knapper: `disabled` + progressiv label («Tildeler …»/«Fjerner …») — Evidence: footer-buttons in both modals; «progressive label»-tests with delayed mocks
- ✅ Unit-tester (full suksess, delvis suksess, totalavvisning), a11y-tester, i18n-nøkler — Evidence: 16 modal-unit-tests + 8 modal-axe-tests all passing; `domains.json` namespaces added

## Next Steps

- **Task #8** (TildelRolleModal + FjernRolleModal) mirrors this task against Op #4-rolle-kilden and Op #6-mutasjonene with `refetchQueries: ['personbrukerMedRoller']`.
- **Task #9** (Deaktiver/Reaktiver) — independent of this task.
- Design-avklaring (spec-spørsmål #6) may refine the dialog-UX later; grunnflyten her er krav-bundet.
- On real-schema migration: rename the Fjern-modal's source operation (duplicate op-name vs. the tab once codegen exclusion is lifted) — noted in `useFjernbarePersonbrukerTilganger.tsx`.

## Conclusion

Task #6 is complete: both modals with the full cascade flow and the new delvis-suksess-handling are implemented, wired to the Task #5 actionbar, fully typed against the mock-API contract, tested across full/partial/total-rejection paths, a11y-verified, and building cleanly.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
