# Task #9 Completion Report: Deaktiver/Reaktiver personbruker

## Status: ✅ COMPLETED

**Date Completed**: 2026-07-08
**Task**: Deaktiver/Reaktiver personbruker
**Priority**: High
**Size**: M

## Summary

Implemented BRU-PER-GRU-004 on the Personbruker detail page: a `PersonbrukerStatusActions` button-cluster in the topbar's actions-slot ("Deaktiver bruker" destructive / "Aktiver bruker"), two confirmation modals (sketch sub-frames 09/10) explaining the freeze/restore consequence, and the Op #7 mutation hook-pair `useDeaktiverPersonbruker`/`useReaktiverPersonbruker`. After a successful (de)activation the normalized Apollo cache flips the topbar status-tag and swaps the button without refetching the lean query, while both tildelings-tabs are refetched (awaited) so their rows show INAKTIV/AKTIV. All paths are unit- and a11y-tested; typecheck, lint, full test suites and the production build are green.

All paths below are relative to the fs-admin repo.

## Files Created

### 1. `src/domains/tilgangsstyring/features/PersonbrukerDetails/hooks/usePersonbrukerStatusMutationsTypes.ts` (123 lines)

TRANSITIONAL manually-mirrored types for both status-mutation contracts (plan Op #7), following `useApplikasjonStatusMutationsTypes.ts`: locally-mirrored `MutasjonAvvistArsak`, shared `PersonbrukerStatusMutasjonAvvist`, lean `PersonbrukerStatusRef` (`id`/`status`/`kanDeaktiveres`/`kanReaktiveres`), and the `Deaktiver…`/`Reaktiver…` Suksess/Resultat/MutationData/MutationVariables shapes. Re-exports `PersonbrukerStatus` from the sibling detail-types (same folder, same teardown unit). Full migration/teardown instructions in the header.

### 2. `src/domains/tilgangsstyring/features/PersonbrukerDetails/hooks/useDeaktiverPersonbruker.tsx` (83 lines)

`DEAKTIVER_PERSONBRUKER` mutation (operation name `deaktiverPersonbruker`, matching the MSW handler) with the union envelope: lean `personbruker { id status kanDeaktiveres kanReaktiveres }` on the Suksess-arm (plan Op #7 Lag B — normalized-cache topbar update without refetching the lean query) + `... on MutasjonAvvist { arsak feilmelding }`. Hook wraps `useMutation` with `refetchQueries: ['personbrukerMedTilganger', 'personbrukerMedRoller']` + `awaitRefetchQueries: true` so both tabs re-render with INAKTIV tildelinger before the modal closes.

### 3. `src/domains/tilgangsstyring/features/PersonbrukerDetails/hooks/useReaktiverPersonbruker.tsx` (82 lines)

Mirror of #2 for `reaktiverPersonbruker` (restore semantics — tabs re-render with AKTIV tildelinger).

### 4. `src/domains/tilgangsstyring/features/PersonbrukerDetails/components/DeaktiverPersonbrukerModal/` (127 + 18 lines)

`DeaktiverPersonbrukerModal.tsx` + `DeaktiverPersonbrukerModal.module.css`. Confirmation modal per sketch sub-frame 09: heading «Deaktivere bruker?», body explaining that tildelinger fryses — fjernes ikke — og gjenopprettes ved aktivering, destructive confirm-button (`FSButton variant="critical"`) with progressive label «Deaktiverer...» + `disabled` + spinner while in flight, Avbryt/Escape/X cancels without firing. `MutasjonAvvist` → inline `Alert` (feilmelding, fallback message), modal stays open; Suksess → close.

### 5. `src/domains/tilgangsstyring/features/PersonbrukerDetails/components/ReaktiverPersonbrukerModal/` (130 + 18 lines)

`ReaktiverPersonbrukerModal.tsx` + `ReaktiverPersonbrukerModal.module.css`. Mirror per sketch sub-frame 10: «Aktivere bruker?», primary (non-destructive) `variant="strong"` confirm «Aktiver bruker» / «Aktiverer...», body explaining that frosne tildelinger gjenopprettes uten ny tildeling.

### 6. `src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerTopBar/PersonbrukerStatusActions.tsx` (98 lines)

Button-cluster + co-located modal state for the topbar actions-slot (mirrors `ApplikasjonStatusActions`). Gating computed from the `PersonbrukerDetailNode`: «Deaktiver bruker» (`variant="critical" mode="outlined"`) only when `status === AKTIV && kanDeaktiveres`; «Aktiver bruker» (`variant="strong" mode="outlined"`) only when `status === DEAKTIVERT && kanReaktiveres`; nothing when the flags are false — client gating uses only the API `kan*`-flags (no hardcoded rollekoder, analysebeslutning #7).

### 7. Test files (875 lines total)

- `DeaktiverPersonbrukerModal.test.tsx` (258) — initial render, Avbryt/Escape cancel, success closes, in-flight progressive label + disabled, `MutasjonAvvist` feilmelding + stays open, empty-feilmelding fallback.
- `ReaktiverPersonbrukerModal.test.tsx` (254) — same matrix for reaktiver.
- `PersonbrukerStatusActions.test.tsx` (204) — visibility matrix (AKTIV+kanDeaktiveres → Deaktiver; DEAKTIVERT+kanReaktiveres → Aktiver; flags false → nothing; DEAKTIVERT+kanDeaktiveres → no Deaktiver), modal triggering, button swap on status flip.
- `DeaktiverPersonbrukerModal.a11y.test.tsx` (59), `ReaktiverPersonbrukerModal.a11y.test.tsx` (59), `PersonbrukerStatusActions.a11y.test.tsx` (95) — jest-axe on closed/open modal states and both button states.

## Files Modified

### 1. `src/domains/tilgangsstyring/features/PersonbrukerDetails/PersonbrukerDetails.tsx`

Fills the Task #4 `actionsElement`-slot: `<PersonbrukerTopBar personbruker={…} actionsElement={<PersonbrukerStatusActions personbruker={…} />} />`. Doc comment updated.

### 2. `src/domains/tilgangsstyring/features/PersonbrukerDetails/PersonbrukerDetails.test.tsx`

New `describe('deaktivering (BRU-PER-GRU-004)')`: (a) Deaktiver-button renders in the topbar region; (b) full cache-integration test — click Deaktiver → confirm in modal → mutation Suksess merges into `Personbruker:pb-1` → topbar shows `statusDeaktivert` and the swapped «Aktiver bruker»-button, with second copies of the tab-query mocks answering the awaited refetches. `makeWrapper` extended with an `extraMocks` param.

### 3. `src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerTopBar/PersonbrukerTopBar.tsx`

Comment-only: `actionsElement` docstring updated from "Task #9 fills it" to present tense. No behavior change; existing tests untouched and green.

### 4. `src/common/messages/nb/domains.json`

Three new namespaces under `tilgangsstyring`: `PersonbrukerStatusActions` (`deaktiver`: «Deaktiver bruker», `aktiver`: «Aktiver bruker»), `DeaktiverPersonbrukerModal` and `ReaktiverPersonbrukerModal` (title/body/avbryt/action/progressive-action/errors.mutasjonAvvist), following the `DeaktiverApplikasjonModal`/`ReaktiverApplikasjonModal` key pattern.

## Key Features Implemented

### ✅ Status-gated topbar actions (BRU-PER-GRU-004)

«Deaktiver bruker» destructive trigger when AKTIV + `kanDeaktiveres`; «Aktiver bruker» when DEAKTIVERT + `kanReaktiveres`; nothing otherwise. Never both.

### ✅ Confirmation modals with freeze/restore explanation (sketch 09/10)

Both actions are gated behind explicit confirmation dialogs whose bodies state the consequence: tildelinger fryses (fjernes ikke) / gjenopprettes uten ny tildeling.

### ✅ Normalized-cache status update + awaited tab refetches

Suksess-selection `personbruker { id status kanDeaktiveres kanReaktiveres }` merges on `Personbruker:<id>` → topbar tag + button swap without refetching the lean query; `refetchQueries` of both tab operations (awaited) → tildelinger render INAKTIV/AKTIV. Verified by the new cache-integration test.

### ✅ Async buttons with progressive labels

`disabled={loading}` + «Deaktiverer...»/«Aktiverer...» + spinner + `aria-busy` during the in-flight mutation (fs-admin-buttons Rule 3); tested with delayed mocks.

### ✅ Error handling per the union envelope

`MutasjonAvvist` → inline critical `Alert` with server feilmelding (fallback to generic message), modal stays open for retry/cancel; network errors → generic in-modal error; auth errors remain centrally intercepted.

## Project skills consulted

- **fs-admin-buttons** — destructive trigger `variant="critical" mode="outlined"` in the topbar + `variant="critical"` filled confirm inside the dialog (Rule 4), async disable + progressive-label pattern (Rule 3), verb-phrase labels via `t(...)` (Rule 2), FSButton as default (Rule 1).
- **graphql-consumer** — union-envelope consumption with `__typename`-switch, named operations, variables (single scalar arg mirroring the applikasjon status-mutations), `useMutation` selection. The flat TRANSITIONAL style (gql from `@apollo/client` + manual types) mirrors the existing pattern in the area per the skill's "mirror the existing flat style" rule for mock-first areas: Ikke best practice — eksisterende mønster i området (colocation revisited at teardown, as documented in the plan Op #1 Lag C).
- **fs-admin-detail-pages** — actions in the `DetailPageTopBar`-slot via the Task #4 `actionsElement` prop; error/loading propagation left at the parent.
- **fs-admin-grid-and-flex** — all layout via the `<Flex>` helper; the only new CSS is the spinner keyframes (no `display: flex/grid` in module.css).
- **i18n conventions (`src/common/messages/CLAUDE.md`)** — component-name PascalCase namespaces, `{navn}`-interpolation, no hardcoded Norwegian strings in components.

## Test Results

All tests are TypeScript test files run through the project's Jest setups (no `node -e`).

- `npx jest --config jest.config.ts …PersonbrukerDetails/components/{DeaktiverPersonbrukerModal,ReaktiverPersonbrukerModal,PersonbrukerTopBar}` → **4 suites, 26 tests passed**
- `npx jest --config jest.config.ts …PersonbrukerDetails/PersonbrukerDetails.test.tsx` → **8 tests passed** (incl. the two new BRU-PER-GRU-004 tests)
- `npm test` (full unit suite) → **240 suites, 1934 passed, 3 skipped** (pre-existing skips; the global-coverage notice on full runs is the known artifact — branch coverage is checked via `test:sincemain`)
- `npm run test:a11y` → **289 suites, 917 passed** (first run had one flaky jest-worker SIGSEGV on the untouched `PersonbrukereOverview.a11y.test.tsx`; it passes in isolation and the full re-run was green)
- `npm run test:sincemain` → **58 suites, 391 passed, 3 skipped**; coverage thresholds met
- `npm run test:typecheck` → **passes**
- `npm run lint` → **exit 0, 0 errors**
- `npx prettier --check` on the changed set → **clean**

## Technical Decisions

### 1. Lean suksess-selection (`id status kanDeaktiveres kanReaktiveres`) instead of the full detail shape

**Why**: Plan Op #7 Lag B prescribes exactly this — the normalized cache only needs the status + gating flags to flip the topbar; the tildelings-freeze is delivered via the awaited tab refetches. (The applikasjon template selects the full detail shape; the plan explicitly slims this for personbruker.)

### 2. `PersonbrukerStatusActions` takes the whole `PersonbrukerDetailNode` and computes gating internally

**Why**: Unlike `Applikasjon` (single `kanDeaktiveres` flag, gating computed in the topbar), `Personbruker` has separate `kanDeaktiveres`/`kanReaktiveres` flags, and the topbar exposes a generic `actionsElement`-slot (Task #4 design). Centralizing the status×flag matrix in the actions component keeps `PersonbrukerDetails` declarative, `PersonbrukerTopBar` untouched, and the gating unit-testable in one place.

### 3. Shared types file for the hook-pair (`usePersonbrukerStatusMutationsTypes.ts`)

**Why**: Mirrors the canonical `useApplikasjonStatusMutationsTypes.ts` (one file for the deaktiver/reaktiver pair); `MutasjonAvvistArsak` is mirrored locally per the self-containment principle documented in the sibling personbruker hooks, while `PersonbrukerStatus` is re-exported from the same-folder detail-types (same teardown unit — no drift risk).

### 4. Topbar trigger variants: `critical mode="outlined"` (deaktiver) / `strong mode="outlined"` (aktiver)

**Why**: The acceptance criteria require the destructive `variant="critical"` on the Deaktiver-trigger, and the fs-admin-buttons placement table specifies outlined critical/strong for detail-page topbar triggers. This intentionally diverges from `ApplikasjonStatusActions`' `variant="subtle"` (see Deviations).

## Build Status

✅ **Build successful** — `npm run build` (Next.js 16, webpack) completes; `/tilgangsstyring/personbrukere/[id]` present in the route manifest.
✅ **No new linter warning classes** — 0 errors; the 6 warnings in the new files are the exact same transitional-pattern warnings the canonical template files carry 1:1 (`no-restricted-imports` on the transitional `gql`-import — 1 per hook, and the two `no-unnecessary-condition` defensive-guard warnings that `DeaktiverApplikasjonModal.tsx` also has).
✅ **All imports resolved correctly** — `tsc --noEmit` clean.

## Integration Points

- **Topbar slot (Task #4)**: fills `PersonbrukerTopBar.actionsElement` from `PersonbrukerDetails` — no change to the topbar component's behavior.
- **Tab queries (Tasks #5/#7)**: refetches target the existing operation names `personbrukerMedTilganger`/`personbrukerMedRoller`; no tab internals touched.
- **Mock-API (Task #1)**: operation names `deaktiverPersonbruker`/`reaktiverPersonbruker` match the MSW handlers verbatim; the mock's freeze semantics make the INAKTIV/AKTIV rows visible after refetch. Nothing under `src/mocks/` modified.
- **Task #10**: the master-detail integration test can drive deaktiver → reaktiver end-to-end against the mock handlers using the topbar buttons and modals delivered here.
- **Teardown**: swap `gql` imports to `@/__generated__`, delete `usePersonbrukerStatusMutationsTypes.ts`, keep operation names — documented in both hooks and the types file.

## Acceptance Criteria Met

- ✅ `PersonbrukerStatusActions` i topbaren: «Deaktiver bruker» (destruktiv, `variant="critical"`) når AKTIV og `kanDeaktiveres`; «Aktiver bruker» når DEAKTIVERT og `kanReaktiveres` — Evidence: `PersonbrukerStatusActions.tsx:46-49` (gating), `:54-56` (critical trigger); tests `PersonbrukerStatusActions.test.tsx` (visibility matrix, 5 cases)
- ✅ `DeaktiverPersonbrukerModal/` + `ReaktiverPersonbrukerModal/` — bekreftelsesmodaler (skisse 09/10) som forklarer konsekvensen — Evidence: the two modal components + `domains.json` bodies («fryses — de fjernes ikke, og gjenopprettes …» / «gjenopprettes — ingen tildelinger må gjøres på nytt»); cancel-paths tested
- ✅ `hooks/useDeaktiverPersonbruker.tsx` + `useReaktiverPersonbruker.tsx` — Op #7-mutasjonene med refetch av begge tildelings-queries — Evidence: `useDeaktiverPersonbruker.tsx:80-81` / `useReaktiverPersonbruker.tsx:79-80` (`refetchQueries` + `awaitRefetchQueries`)
- ✅ Etter deaktivering: status-tag oppdatert i topbar (normalisert cache), tildelinger vises som INAKTIV i fanene — Evidence: `PersonbrukerDetails.test.tsx` «deaktivering updates the topbar status-tag and swaps the button via the normalized cache» (cache merge asserted; the awaited tab-refetches are exercised by the required second mock copies; the INAKTIV row-status itself is mock/backend data, per the task's Implementation Notes)
- ✅ Async-knapper med progressiv label; unit- og a11y-tester; i18n-nøkler — Evidence: in-flight tests in both modal test files («disables the confirm button and shows the progressive label …»); 3 new a11y test files; 3 new i18n namespaces in `domains.json`

## Next Steps

- Task #10: master-detail integration test (liste → filtrer → detalj → tildel → fjern → deaktiver → reaktiver) + tverrgående gjennomgang.
- Unchanged open item from the plan: envelope form in the real subgraph (åpent spørsmål #1) — the `__typename`-switch is isolated in the two hooks, so teardown cost stays local.

## Conclusion

Task #9 is complete: BRU-PER-GRU-004 is fully demonstrable against the mock — deactivate freezes (status-tag + INAKTIV rows), reactivate restores — behind confirmation modals matching the sketches, with all quality gates (unit, a11y, typecheck, lint, sincemain-coverage, production build) green. Ready for review.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
