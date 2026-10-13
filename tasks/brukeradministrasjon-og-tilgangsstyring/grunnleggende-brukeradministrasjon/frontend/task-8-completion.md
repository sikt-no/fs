# Task #8 Completion Report: TildelRolleModal + FjernRolleModal

## Status: ✅ COMPLETED

**Date Completed**: 2026-07-08
**Task**: TildelRolleModal + FjernRolleModal
**Priority**: Medium
**Size**: M

## Summary

Implemented the two tildelings-modals for the Personbruker Roller-tab (BRU-PER-GRU-003, roller) as a file-for-file mirror of the Task #6 tilganger-modals (the canonical template per the plan): `TildelRolleModal` (Organisasjon → Miljø → checkbox multi-select of tildelbare roller from Op #4's `tildelbarePersonbrukerRoller`, cascade-enabled, lazy, `alleredeTildelt` disabled with explanation) and `FjernRolleModal` (destructive `variant="critical"` submit, multi-select among the user's existing AKTIVE rolle-tildelinger within valgt org+miljø). Both consume the Op #6-mutations through new typed hooks with `refetchQueries: ['personbrukerMedRoller']` + `awaitRefetchQueries: true`, and both implement the identical delvis-suksess-switch: on `Suksess` with `avviste.length > 0` the modal stays open and shows the per-element result panel (same `TildelingAvvist`-visning as Task #6); full success closes with a snackbar; `MutasjonAvvist` renders inline without closing. The Task #7 actionbar's disabled buttons are now wired to open the modals.

All code paths below are relative to `/Users/mats.myhre/Dev/Sikt/fs-admin`.

## Files Created

All under `src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerRoller/`:

### Hooks (`hooks/`)

### 1. `useTildelbarePersonbrukerRoller.tsx` (79 lines)

`useLazyQuery`-hook for Op #4 (`tildelbarePersonbrukerRoller(personbrukerId, organisasjonId, miljoKode)`), `fetchPolicy: 'cache-and-network'`. Fired from the Tildel-modal only when BOTH org AND miljø are chosen (cascade), and re-executed after delvis suksess so newly-tildelte rows flip to disabled.

### 2. `useTildelbarePersonbrukerRollerTypes.ts` (57 lines)

Transitional types for the Op #4 contract (`TildelbarRolleNode { rollekode, navn, alleredeTildelt }`), with the standard migration recipe for when the real schema lands. Re-declared, not imported from the Tilganger-tab (plan decision #2).

### 3. `useFjernbarePersonbrukerRoller.tsx` (108 lines)

`useLazyQuery`-hook for the Fjern-modal's source list over `personbruker(id) { roller(...) }` with server-side filter `{ status: AKTIV, organisasjonId }`, `first: 200` at the call-site. **Deliberately named operation `personbrukerMedRoller`** — analogous to Task #6's fjern-source reusing `personbrukerMedTilganger`: the personbrukere-mock has no dedicated fjernbare-handler (MSW matches by operation name and returns the full type-space), and sharing the name means the mutations' `refetchQueries` refreshes the modal's own list too. Safe while `src/domains/tilgangsstyring/**` is codegen-excluded; the docstring carries the same rename-on-teardown note.

### 4. `useFjernbarePersonbrukerRollerTypes.ts` (95 lines)

Transitional types for the fjern-source rows (`id, rollekode, navn, status, miljo { kode }, kanFjernes`). Re-exports `TildelingStatus`/`PersonbrukerRollerFilterInput` from the Roller-tab's own `useGetPersonbrukerRollerTypes` (same-tab import — plan decision #2 only forbids cross-tab sharing, mirroring the Task #6 layout exactly).

### 5. `useTildelPersonbrukerRoller.tsx` (98 lines)

Op #6-mutation hook: `useMutation(TILDEL_PERSONBRUKER_ROLLER, { refetchQueries: ['personbrukerMedRoller'], awaitRefetchQueries: true })`. Selection per plan Op #6 Lag B (identical form to Op #5): `personbruker { id antallRoller }`, `tildelte { id navn }`, `avviste { kode navn arsak feilmelding }`, plus the `MutasjonAvvist`-arm. NB: selects `antallRoller` (not `antallTilganger`) so the normalized cache keeps the roller-count fresh.

### 6. `useTildelPersonbrukerRollerTypes.ts` (139 lines)

Transitional mutation types incl. the envelope pieces (`TildelingAvvist`, `TildelingAvvistArsak`, `MutasjonAvvist`, `MutasjonAvvistArsak`) — re-declared (not imported from the Tilganger-tab, per plan decision #2 and the template's own "self-contained and trivially deletable" principle) — and the mock's trigger conventions documented in the header.

### 7. `useFjernPersonbrukerRoller.tsx` (85 lines)

Op #6-mutation hook for `fjernPersonbrukerRoller` — same refetch strategy; suksess-variant carries `fjernede` (bare rollekoder per plan) + `avviste`.

### 8. `useFjernPersonbrukerRollerTypes.ts` (92 lines)

Transitional fjern-mutation types; re-exports the shared envelope types from the roller tildel-types file (same-tab import, same pattern as `useFjernPersonbrukerTilgangerTypes`).

### Components (`components/`)

### 9. `TildelRolleModal/TildelRolleModal.tsx` (361 lines)

The tildel-modal. Organisasjon-select (kilde `mineBrukerAdminOrganisasjoner`, single-org prefilled+disabled), Miljø-select (kilde `personbrukereFilterOptions.miljoer` — not hardcoded), checkbox-fieldset (lazy Op #4, cascade-enabled, `alleredeTildelt` disabled with "(allerede tildelt)"-explanation, rollenavn + rollekode per row). Submit-switch: full success → close + pluralized snackbar; delvis suksess → stays open with per-element result panel (success-Alert with tildelte-liste + critical-Alert with avviste-liste incl. feilmelding per element), selection cleared, tildelbare-list re-fetched so tildelte rows flip to disabled; `MutasjonAvvist` → inline critical Alert. Async submit: `disabled={submitLoading}` + progressive label «Tildeler …» + spinner + `aria-busy`.

### 10. `TildelRolleModal/TildelRolleModal.module.css` (69 lines)

Non-layout styling only (border/colors/spinner/list) — all flex layout is done with the `<Flex>` helper in the TSX per the fs-admin layout rule (no `display: flex` in new CSS).

### 11. `TildelRolleModal/TildelRolleModal.test.tsx` (541 lines)

8 unit tests mirroring the Task #6 template: opening, cascade-enabling (miljø disabled until org; options sourced from filterOptions), lazy query + `alleredeTildelt` disabled rows, submit gating, **full suksess** (close + snackbar), async in-flight state (disabled + «tildelerAction»-label via delayed mock), **delvis suksess** (modal open, per-element panel, feilmelding visible, refreshed list flips row to disabled, no snackbar), **totalavvisning**/`MutasjonAvvist` (inline error, modal open, no panel).

### 12. `TildelRolleModal/TildelRolleModal.a11y.test.tsx` (161 lines)

4 jest-axe states: closed, open single-org, open multi-org, rows loaded incl. disabled `alleredeTildelt`-row (driven with userEvent).

### 13. `FjernRolleModal/FjernRolleModal.tsx` (376 lines)

The fjern-modal (destructive variant). Same cascade skeleton; source list = existing AKTIVE rolle-tildelinger within valgt org+miljø (server filter `{ status: AKTIV, organisasjonId }`, client-narrow on `miljo.kode` + defensive AKTIV-assertion). Rows with `kanFjernes === false` remain selectable — the server rejects them per element and the panel explains why (same decision as Task #6). Submit button `variant="critical"` (rød) with progressive «Fjerner …»-label. Delvis-suksess panel maps the returned `fjernede`-koder back to display-navn via a snapshot taken BEFORE the mutation (the source list refetches and shrinks before the promise resolves under `awaitRefetchQueries`).

### 14. `FjernRolleModal/FjernRolleModal.module.css` (59 lines)

Non-layout styling only, same rules as the tildel-modal CSS.

### 15. `FjernRolleModal/FjernRolleModal.test.tsx` (549 lines)

8 unit tests: opening + cascade, critical-variant assertion on the submit button, source-list loading (navn + rollekode), client-side miljø-narrowing, **full suksess** (close + snackbar), async in-flight state, **delvis suksess** (fjernede-navn + avviste med feilmelding, refetched list shrinks, modal open, no snackbar), **totalavvisning**/`MutasjonAvvist`. Every submit-test provides the post-mutation refetch mock (the modal's own active `personbrukerMedRoller` observer is refetched by the mutation — also on the `MutasjonAvvist`-branch).

### 16. `FjernRolleModal/FjernRolleModal.a11y.test.tsx` (175 lines)

4 jest-axe states: closed, open single-org, open multi-org, source list loaded (driven with userEvent).

## Files Modified

### 1. `.../PersonbrukerRollerActionbar/PersonbrukerRollerActionbar.tsx` (105 lines)

Wired the Task #7 buttons: dropped the `disabled`-props and TODO(Task #8)-comments, added `tildelModalOpen`/`fjernModalOpen` state and mounted both modals (gated on `kanTildeleRoller`/`kanFjerneRoller`), mirroring `PersonbrukerTilgangerActionbar` (post-Task #6) exactly.

### 2. `.../PersonbrukerRollerActionbar/PersonbrukerRollerActionbar.test.tsx` (190 lines)

Wrapped in `MockedProvider` (the mounted modals query orgs + filter-options on mount), replaced the "buttons disabled until Task #8"-test with two modal-open tests (click → dialog heading appears), kept all gating tests.

### 3. `.../PersonbrukerRollerActionbar/PersonbrukerRollerActionbar.a11y.test.tsx` (114 lines)

Wrapped in `MockedProvider` for the same reason; same two axe-states as before.

### 4. `src/common/messages/nb/domains.json`

Added the namespaces `tilgangsstyring.PersonbrukerTildelRolleModal` (18 keys) and `tilgangsstyring.PersonbrukerFjernRolleModal` (17 keys) after the roller-actionbar cluster: titles, «Avbryt», action/progressive labels («Tildel roller»/«Tildeler …», «Fjern roller»/«Fjerner …»), noun-phrase input labels (Organisasjon/Miljø/Roller), «Ikke valgt»-null-options, hint/loading/empty-texts, `alleredeTildelt`-suffix, pluralized `successToast` and the delvis-suksess headings (`delvisTildelteHeading`/`delvisFjernedeHeading`/`delvisAvvisteHeading`), `errors.mutasjonAvvist`.

### 5. `src/domains/tilgangsstyring/features/PersonbrukerDetails/PersonbrukerDetails.test.tsx`

Roller-tab assertions flipped from "visible + disabled until Task #8" to "visible + enabled" (buttons now open the modals); comment updated.

### 6. `.../PersonbrukerRoller/PersonbrukerRoller.tsx`

Docstring only: the actionbar note no longer says "buttons disabled until the modals land in Task #8" — now "mounts the Tildel-/Fjern-modals (Task #8)".

## Key Features Implemented

### ✅ Samme flyt som Task #6 (kaskade Organisasjon → Miljø → Roller)

Miljø-select disabled until org is chosen (and while options load / are empty); roller-fieldset disabled with hint until BOTH are chosen; Op #4 / source-list queries fire lazily only then. Single-org admins get the org prefilled + disabled. `alleredeTildelt`-rows gråtonet + disabled with explanation.

### ✅ Op #6-mutasjonene med `refetchQueries: ['personbrukerMedRoller']`

Both hooks use `refetchQueries: ['personbrukerMedRoller']` + `awaitRefetchQueries: true` — refreshing the Roller-tab list (filter/sort/paging state preserved) AND the Fjern-modal's own source list (shared op-name).

### ✅ Delvis-suksess-håndtering identisk med Task #6

Same `TildelingAvvist`-visning: on `Suksess` with `avviste.length > 0` the modal stays open with a two-part result panel — success-Alert listing what went through (navn per element) and critical-Alert (role="alert") listing every rejected element with its server-provided feilmelding. Full success closes with a pluralized snackbar; `MutasjonAvvist` shows inline without closing. Tildel re-fetches the tildelbare-list (tildelte flip to disabled); Fjern's list refreshes automatically via the shared operation name.

### ✅ Async-knapper og destruktiv variant

`disabled={submitLoading}` + progressive label («Tildeler …»/«Fjerner …») + spinner + `aria-busy` per `fs-admin-buttons` rule 3. Fjern-modalens submit er `FSButton variant="critical"`; the modal itself is the explicit confirmation step (custom-Dialog pattern per rule 4); the actionbar-trigger stays `subtle`.

## Project skills consulted

- **`graphql-consumer`** — typed `TypedDocumentNode` casts, single `$input`-argument on mutations, `__typename`-switch on the union envelope, `useLazyQuery` for on-demand fetches, no `queries.ts` barrel, unique operation-name rule (the deliberate `personbrukerMedRoller`-duplicate is documented with the rename-on-teardown note). The `gql`-from-`@apollo/client` import is the area's established transitional pattern («Ikke best practice — eksisterende mønster i området», plan Op #6 Lag C) — every file carries the migration recipe.
- **`fs-admin-buttons`** — async-button pattern (disabled + progressive label), `variant="critical"` + explicit-confirmation for the destructive fjern-action, verb-phrase labels via `t(...)`, modal-footer variant table.
- **`fs-admin-inputs`** — noun-phrase labels («Organisasjon», «Miljø», «Roller»), «Ikke valgt»-null-options, `disabled` on selects with unmet prerequisites / no options, `autoComplete="off"`, no placeholders, controlled inputs, `CheckboxInput` for many-of-N.
- **`fs-admin-grid-and-flex`** — zero `display: flex`/`display: grid` in the new CSS modules; all layout via `<Flex>` (dialog body stack, checkbox column, footer row); CSS modules carry only non-layout styling.
- **i18n conventions (`src/common/messages/CLAUDE.md`)** — component-named PascalCase namespaces in `domains.json`, semantic camelCase keys, parameterized/pluralized messages, no hardcoded Norwegian strings; `Personbruker*`-prefix kept for consistency with the sibling tilganger-modal namespaces (documented in both component docstrings).

## Test Results

All test files are TypeScript (`.tsx`), run via the project's Jest configs (not `node -e`):

- `npm test -- --testPathPatterns "PersonbrukerRoller|PersonbrukerDetails"` → **16 suites, 109 tests passed** (includes the 8+8 new modal tests + 7 updated actionbar tests + updated detail-page test)
- `npm test` (full unit suite) → **237 suites, 1910 passed, 3 skipped** (the pre-existing skips; the filtered-run coverage notice is the known artifact — coverage is only collected from `src/features/**`/`src/app/_components/**`/`src/utils/**`/`src/hooks/**`, none touched here)
- `npm run test:a11y` (full a11y suite) → **286 suites, 910 passed** (8 new axe-tests across the two modals; actionbar a11y updated)
- `npm run test:a11y -- --testPathPatterns "PersonbrukerRoller|PersonbrukerDetails"` → **17 suites, 48 tests passed**
- `npm run test:sincemain` → **55 suites, 367 passed, 3 skipped**; coverage thresholds met
- `npm run test:typecheck` → **passes**
- `npm run lint` → **exit 0, 0 errors**; the warnings in the new files are the exact same transitional-pattern warnings the Task #6 template files carry (`no-restricted-imports` on the transitional `gql`-import, `react-hooks/set-state-in-effect` on the template's prefill/reset-effects) — no new warning classes
- Prettier → all new/changed files clean (`npx prettier --check` on the changed set)

Coverage of the required paths per the AC: **full suksess** (both modals: close + snackbar), **delvis suksess** (both modals: panel with per-element result incl. feilmelding, modal open, list refresh), **total-avvisning** (`MutasjonAvvist`: inline error, modal open) — plus cascade, gating, disabled rows, miljø-narrowing and in-flight button state.

## Technical Decisions

### 1. Fjern-source query reuses the operation name `personbrukerMedRoller`

**Why**: Mandated by the task brief and mirrors Task #6's `personbrukerMedTilganger`-decision 1:1 — the personbrukere-mock (untouchable) registers handlers only for the contract's operation names; there is no fjernbare-roller-handler. Sharing the name also means `refetchQueries: ['personbrukerMedRoller']` automatically refreshes the modal's own list. Safe while the folder is codegen-excluded; the hook docstring carries the rename-on-migration note.

### 2. Envelope types re-declared in the Roller-tab, re-used within it

**Why**: Plan decision #2 forbids sharing between the tabs — `MutasjonAvvistArsak`/`TildelingAvvist*` are re-declared in `useTildelPersonbrukerRollerTypes.ts` (not imported from the Tilganger-tab), while `useFjernPersonbrukerRollerTypes.ts` re-exports them from its same-tab tildel-sibling and `useFjernbarePersonbrukerRollerTypes.ts` re-exports `TildelingStatus` from the same-tab `useGetPersonbrukerRollerTypes.ts` — exactly the import-topology of the Task #6 template.

### 3. Mutation selects `antallRoller` (not `antallTilganger`)

**Why**: The Op #6 suksess-variant's `personbruker`-ref exists to keep the normalized cache's count fresh; for roller-mutations the relevant counter on `Personbruker` is `antallRoller`.

### 4. `kanFjernes === false`-rows stay selectable in the Fjern-modal

**Why**: Same as Task #6 (Technical Decision #3 there): the AC asks for multi-select among existing AKTIVE tildelinger with no kanFjernes-carve-out; the server is the authority, rejects per element, and the panel explains why — keeping delvis suksess demonstrable on fjern.

### 5. Fjernede-navn snapshotted before the mutation

**Why**: The fjern-suksess-variant returns bare rollekoder, and with `awaitRefetchQueries: true` the source list has already been refetched (and shrunk) by the time the promise resolves — so the kode→navn lookup map is built from the pre-mutation rows (same as Task #6).

### 6. Delvis-suksess panel duplicated inline (no shared component with Task #6)

**Why**: Plan decision #2 — parallel implementations, no shared parameterized abstractions in this round; the plan's own note says an eventual refactor is a separate sak.

## Build Status

✅ **Build successful** — `npm run build` (Next.js 16, webpack) completes; `/tilgangsstyring/personbrukere` + `/tilgangsstyring/personbrukere/[id]` both present.
✅ **No new linter warning classes** — 0 errors; warnings match the Task #6 template's established transitional patterns 1:1.
✅ **All imports resolved correctly** — typecheck clean.

## Integration Points

- **Task #7 (Roller-fane)**: `PersonbrukerRollerActionbar` now opens the modals; the tab's `personbrukerMedRoller`-list refetches after every mutation (filter/sort/paging state preserved via cacheConfig key-args).
- **Task #4 (detaljside)**: the mutations select `personbruker { id antallRoller }`, so the normalized cache keeps any mounted detail-surface's count fresh.
- **Task #1 (mock-API)**: consumed unmodified — operation names (`tildelbarePersonbrukerRoller`, `tildelPersonbrukerRoller`, `fjernPersonbrukerRoller`, `personbrukerMedRoller`), envelope shapes and rejection triggers all work end-to-end against the MSW handlers; nothing under `src/mocks/` was touched.
- **Task #6 (tilganger-modals)**: untouched — no changes to the Tilganger-tab or its modals; the roller-side is a deliberate parallel implementation.
- **Task #9 (deaktiver/reaktiver)**: independent; its planned refetch of `personbrukerMedRoller` will refresh this tab.
- **Task #10**: the master-detail integration test will exercise these modals against the mock handlers.

## Acceptance Criteria Met

- ✅ `TildelRolleModal/` + `FjernRolleModal/` — samme flyt som Task #6 med Op #4-rollekilden (`tildelbarePersonbrukerRoller`) og Op #6-mutasjonene med `refetchQueries: ['personbrukerMedRoller']` — Evidence: `TildelRolleModal.tsx` (cascade selects ~L288–312, lazy Op #4-effect ~L115–124), `FjernRolleModal.tsx` (source filter ~L120–135 + client-narrow ~L195–198), `useTildelPersonbrukerRoller.tsx:88–93` + `useFjernPersonbrukerRoller.tsx:79–84` (refetchQueries + awaitRefetchQueries)
- ✅ Delvis-suksess-håndtering identisk med Task #6 (samme `TildelingAvvist`-visning) — Evidence: submit-switch + result panel in both modals (structurally identical to the Task #6 template, same Alert composition and t-keys pattern); tests «submission — delvis suksess» in both test files
- ✅ Unit-tester (full/delvis/total-avvist), a11y-tester, i18n-nøkler — Evidence: 16 modal-unit-tests + 8 modal-axe-tests all passing; `domains.json` namespaces `PersonbrukerTildelRolleModal`/`PersonbrukerFjernRolleModal` added

## Next Steps

- **Task #9** (Deaktiver/Reaktiver personbruker) — independent of this task; its `refetchQueries` includes `personbrukerMedRoller`.
- **Task #10** (master-detail integration test) — covers tildel/fjern incl. delvis suksess end-to-end against the mock handlers.
- On real-schema migration: rename the Fjern-modal's source operation (duplicate op-name vs. the tab once codegen exclusion is lifted) — noted in `useFjernbarePersonbrukerRoller.tsx`; swap `gql`-imports and delete the transitional type-files per each file's migration recipe.

## Conclusion

Task #8 is complete: both rolle-modals with the full Task #6 cascade flow and identical delvis-suksess-handling are implemented, wired to the Task #7 actionbar, fully typed against the mock-API contract, tested across full/partial/total-rejection paths, a11y-verified, and building cleanly. The Tilganger-tab and `src/mocks/` were not touched.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
