# Task #10 Completion Report: Master-detail-integrasjonstest og tverrgående gjennomgang

## Status: ✅ COMPLETED

**Date Completed**: 2026-07-08
**Task**: Master-detail-integrasjonstest og tverrgående gjennomgang
**Priority**: Medium
**Size**: M

## Summary

Wrote the `PersonbrukerMasterDetail`-integration test covering the full master-detail round-trip (list → load more → filter → detail → tildel with delvis suksess → fjern with delvis suksess → deaktiver/frys → reaktiver) against the **real mock-handler logic** with the resettable `personbrukereStore`. The cross-cutting review found and fixed one real integration bug (stale `kan*`-gating after deaktiver/reaktiver), verified every `@planned` krav-scenario is covered by at least one test or explicitly backend-ansvar (traceability table below), and confirmed the i18n review is clean. The full verification battery is green.

## Files Created

### 1. `src/domains/tilgangsstyring/integration/PersonbrukerMasterDetail.integration.test.tsx` (508 lines)

Two integration tests after the `ApplikasjonMasterDetail`-pattern:

1. **`list → load more → filter → row-href → detail from shared cache → back restores filter`** — initial page of exactly 50 rows, «Last inn flere» appends via `nodesCursorPagination` (no row loss) until all 77 persona-visible fixtures are loaded and the button disappears, persona-visibility (uib-only fixture never shown), navn-filter narrows to one row with nuqs URL-sync asserted, row `<Link>`-href resolves to the typed detail route, detail page renders from the shared Apollo cache (heading instantly, `kan*`-gated topbar action from the second query), and back-restore re-hydrates the filter input + filtered rows from the captured URL.
2. **`tildel (delvis suksess) → fjern (delvis suksess) → deaktiver (frys) → reaktiver`** — on the curated `pb-kan-ikke-fjernes`-fixture: tildel-modal cascade (org → miljø → checkbox catalog with `alleredeTildelt` disabled), submit of one valid + the `SPERRET-TILGANG`-trigger → modal stays open with per-element result (`tildelte`/`avviste` + handler-produced årsak-text), refetched tab-list shows the new tildeling; fjern-modal submit of one fjernbar + one `kanFjernes: false`-row → delvis suksess again, fjernet row leaves the list; deaktivering flips status-tag, freezes rows to INAKTIV (beholdt — not removed) and removes the tildel/fjern-actionbar (`kan*`-flags); reaktivering restores AKTIV rows and actions without re-tildeling.

**Test transport**: a terminating `ApolloLink` dispatches every operation *by operation name* to the exported response-builders in `src/mocks/personbrukere/handlers/{queries,mutations}.ts` — the exact functions the MSW handlers are documented as "thin wrappers" around — with `resetStore()` between tests and the production `cacheConfig`. MSW itself cannot load under Jest (ESM-only transitive deps outside `transformIgnorePatterns` + missing fetch-API globals in jsdom; verified empirically), so the `msw` module is stubbed with `jest.mock` while the handler *logic* runs unstubbed. All filter/sort/pagination/persona/delvis-suksess/frys-semantics exercised are the handlers' own, not test-local fixtures.

## Files Modified

### 1. `src/domains/tilgangsstyring/features/PersonbrukerDetails/hooks/useDeaktiverPersonbruker.tsx`

**Bug fix (found by the integration test)**: the suksess-selection now includes all six `kan*`-flags (was: only `kanDeaktiveres`/`kanReaktiveres`). The mock/backend flips all six on deaktivering, but the normalized cache kept the four stale tildelings-flags — so the Tildel/Fjern-actionbars stayed visible on a deaktivert bruker, contradicting the plan's permission model («klient-gating skjer utelukkende via kan*-flaggene»). Docstring updated.

### 2. `src/domains/tilgangsstyring/features/PersonbrukerDetails/hooks/useReaktiverPersonbruker.tsx`

Same fix for the reaktiver-direction (actionbars now reappear via the cache-merge, without refetching the lean query). Docstring updated.

### 3. `src/domains/tilgangsstyring/features/PersonbrukerDetails/hooks/usePersonbrukerStatusMutationsTypes.ts`

`PersonbrukerStatusRef` extended with `kanTildeleTilganger`/`kanFjerneTilganger`/`kanTildeleRoller`/`kanFjerneRoller`; docstring explains why (and that Task #10 found it).

### 4–6. Mutation-result mocks updated for the new selection

- `.../DeaktiverPersonbrukerModal/DeaktiverPersonbrukerModal.test.tsx`
- `.../ReaktiverPersonbrukerModal/ReaktiverPersonbrukerModal.test.tsx`
- `.../PersonbrukerDetails.test.tsx` (deaktiverMock)

## Key Features Implemented

### ✅ Integration test against live mock-handler semantics

Unlike the `ApplikasjonMasterDetail`-template (per-request `MockedProvider`-mocks), every operation is answered by the actual handler builders + mutable store — the test exercises the same code the browser mock runs, including store mutation, refetch behaviour and per-element-avvisning classification.

### ✅ Cross-cutting defect fix: stale `kan*`-gating after deaktiver/reaktiver

See Files Modified #1–#3. Small, additive, and verified by both the integration test and the updated unit suites.

### ✅ Krav-scenario traceability

Every `@planned` scenario in the five .feature files mapped to covering test(s) or explicitly noted as backend-ansvar — see the table below.

### ✅ i18n review

No hardcoded Norwegian strings in any new non-test code (grep for `[æøåÆØÅ]` in string literals/JSX across `PersonbrukereOverview/`, `PersonbrukerDetails/`, `src/app/tilgangsstyring/personbrukere/`, `Menu.tsx`, `TilgangsstyringIndex.tsx` — all hits are comments/docstrings; all UI strings go through `next-intl` with keys present in `src/common/messages/nb/domains.json`). `/externalize-i18n` was not needed.

## Project skills consulted

- **graphql-consumer** — invoked before writing the test. No new GraphQL operations were authored (the test consumes the existing transitional operations); the skill's guidance on Apollo Client 4 wiring (link contract, `OperationVariables`, hook behaviour) shaped the custom terminating link. The area's flat-query style is the documented transitional pattern («Ikke best practice — eksisterende mønster i området»), unchanged by this task.
- **i18n conventions** (`src/common/messages/CLAUDE.md`) — consulted for the i18n review scope and key conventions.
- The `fs-admin-*` UI skills were not needed directly (no new UI components); their conventions are asserted *through* the test (row/cell structure, list pagination props, dialog patterns).

## Test Results

- **New test**: `src/domains/tilgangsstyring/integration/PersonbrukerMasterDetail.integration.test.tsx` — `npx jest src/domains/tilgangsstyring/integration/PersonbrukerMasterDetail.integration.test.tsx --coverage=false` → **2/2 pass**, stable across 3 consecutive isolated runs (< 1 s each; explicit 30 s timeout per test because the full parallel suite runs them measurably slower under worker contention).
- `npm test` → **241 suites, 1936 passed, 3 skipped** (pre-existing skips; the global-coverage notice on unfiltered runs is the known pre-existing artifact — the project's gate is `test:sincemain`).
- `npm run test:a11y` → **289 suites, 917 passed**.
- `npm run test:typecheck` (`tsc --noEmit`) → **clean, exit 0**.
- `npm run lint` → **0 errors** (298 pre-existing warnings repo-wide, none in files touched by this task).
- `npm run test:sincemain` → **59 suites, 393 passed, 3 skipped; coverage thresholds met** (94.04 % stmts / 83.72 % branches / 94.73 % funcs / 96 % lines on the gated set). One run out of four had a single flaky failure in a timing-contended suite that passed on immediate re-run — consistent with the flakiness already documented in task-2/task-9 completion docs; three consecutive clean runs afterwards.
- Mock-handler standalone tests (unchanged, re-verified): `npx tsx src/mocks/personbrukere/handlers/queries.test.ts` → **42 pass, 0 fail**; `npx tsx src/mocks/personbrukere/handlers/mutations.test.ts` → **15 pass, 0 fail**.

## Technical Decisions

### 1. Builder-dispatch ApolloLink instead of MSW `setupServer`

**Why**: MSW v2 cannot be evaluated under this Jest setup — probing showed its ESM-only transitive dep (`rettime`) is outside `transformIgnorePatterns`, and jsdom lacks the fetch-API globals (`Response` etc.) MSW needs at module scope. Rather than reshaping global Jest config for one test, the test stubs the `msw` module (`jest.mock`) and routes operations through a terminating `ApolloLink` to the same exported builders the MSW handlers wrap — identical dispatch contract (operation name), identical semantics, real store, real `cacheConfig`. Resolution is deferred one macrotask so Apollo's loading states behave like a real transport.

### 2. Fix the stale-flag bug rather than assert around it

**Why**: the task explicitly allows fixing small in-scope defects found during the review. Asserting the buggy behaviour would have codified a violation of the plan's permission model. The fix is a pure selection-set extension (additive, no behaviour change elsewhere), verified by the integration test and all existing suites.

### 3. Row-scoped status assertions via `getListRow`-helper

**Why**: the tabs' status-*filters* render the same translation-mocked `statusAktiv`/`statusInaktiv` strings as `<option>`-labels, so page-wide text counts cannot distinguish rows from filter options. All status-tag assertions are scoped to the `<li>`-row containing the tildeling's navn (and topbar assertions to the `region`-landmark, mirroring `PersonbrukerDetails.test.tsx`).

### 4. `dialog[open]`-scoping for modal interaction

**Why**: SDS `Dialog` keeps closed dialogs (and their content) mounted, and this page mounts six modals with identical translation-mocked labels. A `getOpenDialog()`-helper (single `document.querySelector('dialog[open]')`, with an eslint-disable + justification for `testing-library/no-node-access`) is the narrowest reliable scope.

## Build Status

✅ **Build successful** — `npm run build` completes; route table emitted incl. `/tilgangsstyring/personbrukere` + `/[id]`
✅ **No new linter warnings** — 0 errors; only the area's two pre-existing TRANSITIONAL `gql`-import warnings appear in touched files (documented teardown items)
✅ **All imports resolved correctly** — typecheck clean

## Integration Points

- The test is the end-to-end guard for the whole feature: it exercises `PersonbrukereOverview` (+ filter/state/pagination hooks), `PersonbrukerDetails` (+ all three tabs, both actionbars, all six modals), the six mutations, the `cacheConfig`-registrations (`Query.personbrukere`, `Personbruker.tilganger`, `Personbruker.roller`) and the mock-handler layer in one flow.
- The `kan*`-selection fix makes deaktiver/reaktiver update *all* gating surfaces (topbar + both tab-actionbars) through the normalized cache — relevant for the real subgraph too: the teardown keeps the same selection set.
- Mock teardown: the test imports from `src/mocks/personbrukere/**` and dies with the mock layer; noted for `teardown-personbrukere.md`-followers (the test must be rewritten against the real API or MSW-in-CI at teardown, same as the browser-mock itself).

## Kravscenario-sjekk (traceability)

Scope: alle `@planned` `Egenskap:` i de fem .feature-filene under `krav-input/local/`. Scenarier/regler tagget `@draft` inne i disse filene er utenfor scope (markert nederst). «Integrasjonstest» = `src/domains/tilgangsstyring/integration/PersonbrukerMasterDetail.integration.test.tsx` (test 1 = liste-flyten, test 2 = detalj-flyten). Handler-tester = `src/mocks/personbrukere/handlers/queries.test.ts` / `mutations.test.ts` (kjøres med `npx tsx`).

### BRU-PER-GRU-001 — `søke_opp_bruker.feature`

| Scenario | Dekket av |
|---|---|
| Se liste over personbrukere (kolonner, sortert navn stigende) | `PersonbrukereResultList.test.tsx` («renders one NavigationListItem per result, with navn + feideId + organisasjoner + status»); handler-test «NAVN_ASC er default og sorterer på navn»; integrasjonstest 1 |
| Velge sorteringsretning for navn (stigende/synkende) | Handler-tester «NAVN_ASC er default …» + «NAVN_DESC snur navnesorteringen …»; URL-state: `useGetPersonbrukereState.test.tsx` |
| Liste viser de 50 første personbrukerne (totalt + lastet) | Integrasjonstest 1 (eksakt 50 rader + `loadMoreButton` med `{showing} 50 {of} N`); handler-test «default first=50 gir 50 rader og hasNextPage» |
| Laste inn 50 flere personbrukere | Integrasjonstest 1 (append forbi 50, ingen rad-tap); handler-test «paginering forbi 50: neste side gir resten uten duplikater»; `PersonbrukereResultList.test.tsx` («clicking "Last inn flere" increments URL `first` by pageSize») |
| Alle personbrukere er lastet inn → last-inn-flere utilgjengelig | Integrasjonstest 1 (`loadMoreButton` forsvinner når alle 77 er lastet) |
| Navigere til detaljside for personbruker | Integrasjonstest 1 (rad-href → typed route → detaljside rendres med delt cache) |
| Navn er tie-break ved likt verdi i annet sorteringsfelt | **Ikke aktuell i v1 / backend-ansvar**: eneste sorterbare felt i v1 er navn («Sist brukt»-sortering er `@draft`). Prinsippet er dokumentert i SDL-en/enum-docstring og gjelder først når et annet sorteringsfelt innføres. |
| Feide-ID er tie-break når navn er likt | Handler-test «tie-break: likt navn sorteres på feideId stigende (NAVN_ASC)» (+ DESC-varianten); fixtures `pb-tiebreak-a`/`pb-tiebreak-b` |
| Fritekst-søk på navn | Handler-test «navn: case-insensitiv delstreng»; integrasjonstest 1 (filter → én rad); `PersonbrukereFilter.test.tsx` |
| Fritekst-søk på Feide-ID | Handler-test «feideId: case-insensitiv delstreng»; `PersonbrukereFilter.test.tsx` («writes feideId-changes through to URL state») |
| Tilgjengelige statuser i filter (Alle/Aktiv/Deaktivert, default Alle) | `PersonbrukereFilter.test.tsx` («renders the six filter inputs …», default-tilstand «renders no chips when the filter is at defaults»); `PersonbrukereStatusFilter.a11y.test.tsx` |
| Filtrere på status | Handler-test «status: DEAKTIVERT» |
| Tilgjengelige organisasjoner i filter (mine brukeradmin-orgs, distinct, alfabetisk, default Alle) | Handler-test «mineBrukerAdminOrganisasjoner: persona-orgs, alfabetisk på navn»; `useGetMineBrukerAdminOrganisasjoner.test.tsx`; `PersonbrukereOrganisasjonFilter.a11y.test.tsx` |
| Filtrere på organisasjon | Handler-test «organisasjonId: matcher avledede (persona-synlige) organisasjoner» |
| Tilgjengelige roller i filter (tildelt minst én i listen, distinct, alfabetisk, default Alle) | Handler-tester «roller er distinct på rollekode og alfabetisk på navn» + «hver rolle i kilden er tildelt minst én synlig personbruker (persona-scopet)»; `useGetPersonbrukereFilterOptions.test.tsx` |
| Filtrere på rolle | Handler-test «rollekode: matcher persona-synlige roller» |
| Tilgjengelige miljøer i filter (representert blant tildelinger, distinct, alfabetisk, default Alle) | Handler-test «miljoer er distinct, alfabetisk og hentet fra demo/prod»; `useGetPersonbrukereFilterOptions.test.tsx` |
| Filtrere på miljø | Handler-test «miljoKode: matcher tildelinger i begge entitetstyper» |
| Kombinere søk og filtre | Handler-test «kombinert filter og tomt resultat» |
| Brukeradministrator ser personbrukere i organisasjoner jeg administrerer | Handler-tester «bruker med tildelinger ved persona-org er synlig» / «… kun ved andre organisasjoner er usynlig» / «persona-synlighet: usynlige brukere er aldri med»; integrasjonstest 1 (uib-fixture aldri i lista) |
| Super-brukeradministrator ser alle personbrukere | Handler-tester «super_brukeradministrator ser alle» + «persona-synlighet: … super ser alle» |

### BRU-PER-GRU-002 — `se_brukers_tilganger.feature`

| Scenario | Dekket av |
|---|---|
| Se brukerens roller (Navn/Status/Organisasjon/Tildelt av/Tildelt dato) | `PersonbrukerRollerResultList.test.tsx` («renders one row per rolle with navn + rollekode + status + organisasjon + tildelt av + tildelt dato»); handler-test «sporing: tildeltAv og tildeltTidspunkt er satt på alle rader» |
| Se brukerens tilganger (samme kolonner) | `PersonbrukerTilgangerResultList.test.tsx` («renders one row per tilgang with …»); integrasjonstest 2 (rader med navn + status-tag) |
| Skille mellom aktive og inaktive tildelinger | Begge `*ResultList.test.tsx` («visually distinguishes aktive and inaktive tildelinger via status-tags»); integrasjonstest 2 (radene flipper AKTIV↔INAKTIV gjennom frys-flyten) |
| Filtrere på navn | Handler-test «bruker-filter: navn-delstreng og organisasjonId»; `useGetPersonbrukerTilganger.test.tsx` (variabel-mapping) |
| Tilgjengelige statuser i filter (Alle/Aktiv/Inaktiv, default Alle) | `PersonbrukerTilgangerStatusFilter.a11y.test.tsx` / `PersonbrukerRollerStatusFilter.a11y.test.tsx` (option-settet); default-tilstand i `useGetPersonbrukerTilgangerState.test.tsx` / `useGetPersonbrukerRollerState.test.tsx` |
| Filtrere på status | Handler-test «bruker-filter: status INAKTIV på aktiv bruker med utløpte tildelinger» |
| Tilgjengelige organisasjoner i filter (fra ufiltrert liste, distinct, alfabetisk, default Alle) | Handler-test «toWirePersonbruker rederiverer organisasjoner/antall fra persona-filtrert sett» (distinct + alfabetisk kilde = `Personbruker.organisasjoner`); `PersonbrukerTilgangerOrganisasjonFilter.a11y.test.tsx` |
| Filtrere på organisasjon | Handler-test «bruker-filter: navn-delstreng og organisasjonId» |
| Kombinere filtre | Samme handler-test (navn + organisasjonId kombinert); filterlogikken er felles `applyTildelingerFilter` for alle tre felt |

### BRU-PER-GRU-003 — `tildele_og_fjerne_tilganger.feature`

«Endringen er sporbar i historikk» i alle scenariene: **backend-ansvar** (analysebeslutning #4 — v1-UI-flaten er `tildeltAv`/`tildeltTidspunkt`, dekket av handler-testen «nye koder tildeles med sporing og oppdaterer store» og kolonne-testene over; full endringshistorikk er BRU-PER-HIS).

| Scenario | Dekket av |
|---|---|
| Tildele en rolle | `TildelRolleModal.test.tsx` («closes the modal and fires a success snackbar»); handler-mutasjonstester (roller speiler tilganger) |
| Tildele en enkelt tilgang | `TildelTilgangModal.test.tsx` (samme testsett); handler-test «nye koder tildeles med sporing og oppdaterer store» (aktiv fra tildelingstidspunktet: `status: AKTIV` + `tildeltTidspunkt`) |
| Tildele flere roller og tilganger samtidig | Handler-test «nye koder tildeles med sporing …» (batch); integrasjonstest 2 (to koder i én operasjon); modaltestenes fler-valg |
| Delvis suksess ved samtidig tildeling | Integrasjonstest 2 (sperret trigger → per-element-resultat med årsak); `TildelTilgangModal.test.tsx`/`TildelRolleModal.test.tsx` («keeps the modal open and shows the per-element result (tildelte + avviste with årsak)»); handler-tester «blanding av ok/allerede-tildelt/sperret/utgått/ukjent gir tildelte + avviste med årsak» + «tildel: ny + allerede-tildelt + sperret gir delvis suksess» |
| Fjerne en aktiv rolle | `FjernRolleModal.test.tsx` («closes the modal and fires a success snackbar») |
| Fjerne en aktiv tilgang | `FjernTilgangModal.test.tsx` (samme); integrasjonstest 2 (fjernet rad forsvinner fra fanen). Merk: «som ikke kommer via en rolle» — kilde-merking direkte/via-rolle er bevisst utsatt (åpent spørsmål #3/design-spørsmål #6); dagens modell har kun direkte tildelinger. |
| Fjerne flere tildelinger samtidig | Integrasjonstest 2 (to koder i én operasjon, inkl. delvis suksess på `kanFjernes: false`); handler-tester «ok + kanFjernes=false + ikke-tildelt gir fjernede + avviste med årsak» + «fjern: kanFjernes=false avvises, resten fjernes» |

### BRU-PER-GRU-004 — `aktivere_og_deaktivere_bruker.feature`

| Scenario | Dekket av |
|---|---|
| Deaktivere en personbruker med aktive tildelinger | Integrasjonstest 2 (status → «Deaktivert», alle rader INAKTIV, radene beholdt); handler-test «deaktiver: status → DEAKTIVERT og ALLE tildelinger → INAKTIV»; `DeaktiverPersonbrukerModal.test.tsx`. «Kan ikke nå FS-data ved neste innloggingsforsøk»: **backend-ansvar** (innloggings-håndheving skjer i FS-API-ene, ikke i admin-UI-et). «Sporbar i historikk»: **backend-ansvar** (som over). |
| Reaktivere en deaktivert personbruker | Integrasjonstest 2 (status → «Aktiv», radene AKTIVE igjen); handler-tester «reaktiver: status → AKTIV og tildelinger → AKTIV igjen» + «reaktiver av fixture-frossen bruker fungerer»; `ReaktiverPersonbrukerModal.test.tsx`. «Utløpte tildelinger blir ikke automatisk aktive»: **backend-ansvar** — eksplisitt dokumentert mock-forenkling (SDL-docstring på `deaktiverPersonbruker` + `personbrukereStore.ts`-docstring); subgraph-plan må realisere nyansen. «Sporbar i historikk»: **backend-ansvar**. |
| Deaktivering skiller seg fra fjerning av tildelinger | Integrasjonstest 2 (tildelingene overlever deaktiver → reaktiver uten ny tildeling — «Utstede vitnemål» og «Lese opptaksdata» består gjennom hele flyten); handler-testenes frys/gjenopprett-par |

### BRU-PER-GRU-007 — `se_detaljer.feature`

| Scenario | Dekket av |
|---|---|
| Se navn | `PersonbrukerDetaljer.test.tsx` («renders the four data groups: Navn, Feide-ID, Organisasjoner and Status»); integrasjonstest 1 (heading = navn) |
| Se Feide-ID | Samme `PersonbrukerDetaljer.test.tsx`-test; integrasjonstest 1 (`hakdah@sikt.no` i Detaljer-fanen) |
| Se organisasjon (avledet av tildelingene) | `PersonbrukerDetaljer.test.tsx` («renders the derived organisasjoner in plural as a comma-separated list» + fallback-testen); handler-test «toWirePersonbruker rederiverer organisasjoner …» |
| Se status (aktiv/deaktivert) | `PersonbrukerDetaljer.test.tsx` («renders the Deaktivert status-tag …»); `PersonbrukerTopBar.test.tsx`; integrasjonstest 2 (begge tilstander) |

### Utenfor scope (tagget `@draft` inne i `@planned`-filene)

`Se tidsbegrensning på en tildeling`, `Se stedkoder på en tildeling` (GRU-002); `Personbruker med tilganger i flere organisasjoner` (GRU-001 — kjerne-atferden er likevel dekket av handler-testen «totalCount reflekterer det persona-filtrerte settet (pb-mixed-orgs)»); hele `Regel: Sist brukt-kolonne og sortering` (GRU-001) og `Regel: Sist brukt` (GRU-007). Disse er ikke `@planned` og kravsjekkes ikke her.

## Next Steps

- **Teardown**: this integration test imports the mock-handler builders and must be re-pointed (or rewritten against MSW-in-CI / the real API) when `src/mocks/personbrukere/` is deleted — add it to the checklist consumers of `teardown-personbrukere.md`.
- **Subgraph-plan followers**: keep the deaktiver/reaktiver suksess-selection (all six `kan*`-flags) in the real schema so the cache-driven re-gating keeps working.
- Operator: review + git handling (no git operations performed by this task).

## Conclusion

Task #10 is complete: the master-detail integration test runs the full user journey against the live mock-handler logic and is stable; every `@planned` krav-scenario is traceable to at least one test or an explicit backend-ansvar note; the i18n review is clean; one real cross-cutting defect (stale `kan*`-gating after deaktiver/reaktiver) was found and fixed; and the full verification battery (`lint`, `test`, `test:a11y`, `test:typecheck`, `test:sincemain`, production build, standalone handler tests) is green.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
