# Plan: Applikasjoner — Grunnleggende selvbetjent tilgangsstyring (iter 2 + 3)

## Proposed Solution

### Architecture Approach

Build 9 features for application-management as **two greenfield feature folders** under a **new domain `src/domains/tilgangsstyring/`**, mirroring the canonical `EmnerOverview ↔ EmneDetails` master-detail pattern:

- `src/domains/tilgangsstyring/features/ApplikasjonerOverview/` — list page (BRU-APP-API-001) + opprett-modal (BRU-APP-API-009 launched from actionbar).
- `src/domains/tilgangsstyring/features/ApplikasjonDetails/` — detail page with two tabs:
  - **Detaljer-tab**: view/edit toggle (BRU-APP-API-002 + BRU-APP-API-006), top-bar action for deaktiver/reaktiver (BRU-APP-API-010), passordbytte-button (BRU-APP-API-004).
  - **Tilganger-tab**: filter+list+pagination (BRU-APP-API-003) with actionbar buttons "Tildel tilganger" (BRU-APP-API-007) and "Fjern tilganger" (BRU-APP-API-008) launching modals.

Routes:

- `src/app/tilgangsstyring/applikasjoner/page.tsx` — list route.
- `src/app/tilgangsstyring/applikasjoner/[id]/page.tsx` — detail route.

Existing MaskinBruker code at `src/domains/support/features/MaskinBruker/` and `src/domains/support/features/Maskinbrukere/` is **not touched** (per beslutning 2026-06-01). Both URLs coexist (`/tilgangsstyring/maskinbrukere` + new `/tilgangsstyring/applikasjoner`).

**Implementation strategy: mock-API-first.** The full Applikasjon-GraphQL-API doesn't exist in `schema.graphql` yet. We scaffold a mock API (MSW + fixture data) per the spec's API-skjema-section as Task #2, so UI work can proceed in parallel with backend implementation. Teardown is cheap when backend lands.

### Key Technical Decisions

1. **Decision: New domain `src/domains/tilgangsstyring/`, not reuse `support/`.**
   - Why: Matches URL path `/tilgangsstyring/applikasjoner`. Will likely host related access-management features (roller, organisasjoner) over time. Clean separation from legacy MaskinBruker which lives in `support/`.
   - Alternative considered: Reuse `support/` — rejected because "support" misrepresents that self-service org-admins also use these features.

2. **Decision: Mock-API-first via `fs-admin-mock-api-with-data` skill.**
   - Why: Backend schema doesn't exist yet; without mock, all 9 features block on backend. Skill is optimized for cheap teardown.
   - Alternative considered: Wait for backend — rejected because it serializes work that can run in parallel.

3. **Decision: Use `@/common/...` imports throughout; avoid deprecated `@/components/...`.**
   - Why: Greenfield code should follow current conventions. `src/components/CLAUDE.md` explicitly marks the old path as deprecated tunnel exports.
   - Alternative considered: Match existing `EmnerOverview` imports — rejected because EmnerOverview is legacy and uses deprecated paths.

4. **Decision: Use `LayoutMessage` for detail-page errors, not the deprecated `error`-prop.**
   - Why: `DetailPageLayout.error` is marked deprecated in `CLAUDE.md`. `LayoutMessage` is the new pattern.

5. **Decision: Two separate `useGetXxxState`-hooks for list vs detail-tab filters.**
   - Why: Different entities (`Applikasjon` vs `ApplikasjonTilgang`), different filter fields, different default order-by. `fs-admin-list-filters`-skillen enforces shared *rules* (chip-strip, "Alle ..."-default, URL-sync), not shared *code*.

6. **Decision: List-query stays lean (7 fields + id + __typename); detail-query is its own roundtrip.**
   - Why: Apollo cache normalizes on id+__typename so overlapping fields show instantly anyway. Smaller list payload = faster initial load.

7. **Decision: `MigrerPassord` is read-only inspiration; new `ApplikasjonPassord` is written from scratch.**
   - Why: Per user beslutning. Keeps the two features fully independent — no transient shared-component coordination, no risk of breaking MaskinBruker.

8. **Decision: Org-felt i tildel/fjern-modaler vises som disabled med org-navnet forhåndsutfylt når admin kun har én org.**
   - Why: Spec-beslutning. Konsistent med `fs-admin-inputs` (disabled select krever forklarende verdi), tydeligere UX enn å skjule feltet helt.

9. **Decision: "Arvet"-tag plasseres ved siden av miljø-tagene på rad i tilgangs-tab; opphav vises ved interaksjon.**
   - Why: Spec-beslutning basert på skissens visuelle posisjon. Eksakt interaksjons-mekanisme (popover vs ExpandList) bestemmes i Task #9.

### File Changes Overview

**New files** (all under `src/domains/tilgangsstyring/`):

```
src/app/tilgangsstyring/applikasjoner/
├── page.tsx
└── [id]/
    └── page.tsx

src/domains/tilgangsstyring/
├── features/
│   ├── ApplikasjonerOverview/
│   │   ├── ApplikasjonerOverview.tsx
│   │   ├── components/
│   │   │   ├── ApplikasjonerFilter/
│   │   │   ├── ApplikasjonerResultList/
│   │   │   ├── ApplikasjonerOrderBy/
│   │   │   └── OpprettApplikasjonModal/
│   │   └── hooks/
│   │       ├── useGetApplikasjonerState.ts
│   │       └── useGetApplikasjoner.ts
│   └── ApplikasjonDetails/
│       ├── ApplikasjonDetails.tsx
│       ├── components/
│       │   ├── ApplikasjonTopBar/
│       │   ├── ApplikasjonDetaljer/         # view+edit detaljer (BRU-APP-API-002, -006)
│       │   ├── ApplikasjonPassord/          # passordbytte (BRU-APP-API-004)
│       │   ├── DeaktiverApplikasjonModal/   # deaktiver (BRU-APP-API-010)
│       │   ├── ReaktiverApplikasjonModal/   # reaktiver (BRU-APP-API-010)
│       │   ├── ApplikasjonTilganger/        # tilgangs-tab feature (BRU-APP-API-003)
│       │   │   ├── ApplikasjonTilganger.tsx
│       │   │   ├── components/
│       │   │   │   ├── ApplikasjonTilgangerFilter/
│       │   │   │   ├── ApplikasjonTilgangerResultList/
│       │   │   │   ├── ApplikasjonTilgangerOrderBy/
│       │   │   │   ├── TildelTilgangModal/     # tildel (BRU-APP-API-007)
│       │   │   │   └── FjernTilgangModal/      # fjern (BRU-APP-API-008)
│       │   │   └── hooks/
│       │   │       ├── useGetApplikasjonTilgangerState.ts
│       │   │       └── useGetApplikasjonTilganger.ts
│       └── hooks/
│           └── useGetApplikasjon.ts
└── components/                              # shared inside domain (NoOrgError equivalent, etc.)
```

**Modified files**:

- `src/messages/nb/<location-tbd>.json` — new translation keys under `domains.tilgangsstyring.*`. Exact file structure follows existing fs-admin convention; check `src/messages/CLAUDE.md`.
- `src/__generated__/graphql.ts` — regenerated by codegen after schema is updated (backend-driven) **or** after MSW handlers' typeDefs are picked up by codegen during mock-API setup.
- Sidebar/nav config (TBD location — checked in Task #1) — add `/tilgangsstyring/applikasjoner` link alongside existing `maskinbrukere`-link.
- Optional: `src/domains/search/features/CommandPalette/hooks/useCommands.tsx` — add `applikasjoner`-kommando (low priority, not blocking).

**Not touched**:

- `src/domains/support/features/MaskinBruker/`
- `src/domains/support/features/Maskinbrukere/`
- `src/app/tilgangsstyring/maskinbrukere/`
- All `gql(...)` blocks referring to `Maskinbruker*`-types.

## GraphQL-endringer

The full GraphQL contract is specified in [`spec-applikasjoner.md` → "API-skjema (GraphQL)"](spec-applikasjoner.md#api-skjema-graphql). This plan does not duplicate it; it references the operations by name and links each to the Task that consumes it.

**Consumer-side operations (this plan implements):**

| Operation | Type | Used by Task | Notes |
|---|---|---|---|
| `applikasjoner` | Query | Task #4 | List page. Lean field-set (id, navn, beskrivelse, miljoer.kode, miljoer.navn, organisasjon.navn, antallTilganger, status, __typename). |
| `applikasjon` | Query | Task #6 | Detail page. Full Applikasjon-fields incl. all `kan*`-flags. |
| `verifiserApplikasjonEksternId` | Query | Task #11 | Called from opprett-modal before submit (or skipped if mutation does serverside-verify and returns ApplikasjonEksternIdIkkeFunnet directly). |
| `tildelbareTilgangskoder` | Query | Task #14 | Fetched when org+miljø are selected in tildel-modal. |
| `mineApplikasjonsAdminOrganisasjoner` | Query | Task #4 (gate "Opprett"-knapp), Task #11 | Drives whether "Opprett applikasjon" appears at all + org-Select-content in opprett-modal. |
| `opprettApplikasjon` | Mutation | Task #11 | Union-return: success-type + ApplikasjonEksternIdIkkeFunnet / -AlleredeRegistrert / VisningsnavnAlleredeIBruk / OpprettelseAvvist. |
| `oppdaterApplikasjonDetaljer` | Mutation | Task #7 | Updates navn + beskrivelse together. Union-return covers tomt navn + ikke-funnet + rettighet. |
| `genererNyttApplikasjonPassord` | Mutation | Task #8 | Returns the new password ONCE. Klient viser én gang og forkaster ved modal-lukking. |
| `deaktiverApplikasjon` / `reaktiverApplikasjon` | Mutation | Task #10 | Two separate mutations to keep success/error union narrow. |
| `tildelApplikasjonTilganger` | Mutation | Task #14 | Multi-tilgang per call (i samme org+miljø). |
| `fjernApplikasjonTilganger` | Mutation | Task #15 | Multi-tilgang per call. |

**Backend-side work (NOT this plan — cross-agent hand-off):**

The entire schema additions listed in `spec-applikasjoner.md` § API-skjema do not exist in `schema.graphql` today (0 `Applikasjon`-references). This is a backend-agent responsibility. Until backend lands, the **mock API in Task #2 stands in** for all of the above — same operation names, same union envelopes, same input shapes.

When backend lands:

1. Backend pushes new schema to test-gateway → `schema.graphql` is updated on next `npm run compile`.
2. Mock API is torn down (single PR, removes `src/mocks/` entries for Applikasjon-types).
3. End-to-end tests are updated to point at real endpoints.

## Implementation Tasks

Tasks are ordered to maximize parallelism between mock-API/UI work and to keep each task atomic. Where dependencies allow, frontend can be developed against the mock and switched over to backend without further code changes.

---

### Task #1: Bootstrap domain folder + app-route shells

**Priority**: High
**Size**: S (1-2hr)
**Dependencies**: None
**Addresses Requirements**: BRU-APP-API-001 (skeleton), BRU-APP-API-002 (skeleton)

**Acceptance Criteria**:
- [ ] `src/domains/tilgangsstyring/` exists with `features/`, `components/`, `hooks/` subdirs (empty `.gitkeep` placeholders OK).
- [ ] `src/app/tilgangsstyring/applikasjoner/page.tsx` exists, renders a placeholder `<ApplikasjonerOverview />`.
- [ ] `src/app/tilgangsstyring/applikasjoner/[id]/page.tsx` exists, renders `<ApplikasjonDetails id={...} />`.
- [ ] Translation files have empty `domains.tilgangsstyring.ApplikasjonerOverview.*` and `.ApplikasjonDetails.*` namespaces (one `title`-key each is enough to verify wiring).
- [ ] Sidebar nav config has a new entry pointing to `/tilgangsstyring/applikasjoner` (placement next to maskinbrukere-entry — exact file located in this task).
- [ ] `npm run lint` and `npm run test:typecheck` pass.

**Implementation Notes**:
- Mirror `EmnerOverview`-page.tsx structure for the page shell (server component thin wrapper).
- Locate sidebar config by `grep -rn "maskinbrukere" src/` and find the nav-data file.
- Do NOT use deprecated import paths; import from `@/common/...`.

---

### Task #2: Scaffold mock API (MSW handlers + fixture data)

**Priority**: High
**Size**: M (3-4hr)
**Dependencies**: Task #1
**Addresses Requirements**: All — unblocks frontend implementation of every Applikasjon-feature.

**Acceptance Criteria**:
- [ ] Mock GraphQL types for `Applikasjon`, `ApplikasjonTilgang`, `Miljo`, `Organisasjon`-ref (use existing fs-admin Organisasjon-type if available), enums (`Identitetsleverandor`, `ApplikasjonStatus`, `Tilknytning`).
- [ ] MSW handlers for all queries and mutations listed in `spec-applikasjoner.md` § API-skjema, returning realistic, type-varied fixtures (mix of Feide / Maskinporten / legacy FS identitetsleverandører; mix of statuser; mix of rettighet-flagger; ≥120 applikasjoner across multiple orgs to exercise paginering and filtre).
- [ ] Union-error envelopes implemented — mutations can return success OR each named error type depending on input (e.g. `eksternId: "NOT_FOUND"` triggers `ApplikasjonEksternIdIkkeFunnet`).
- [ ] Handlers can be enabled/disabled via existing fs-admin mock toggle (check how mock-toggling is done today — likely env-var or `NEXT_PUBLIC_*`).
- [ ] `npm test` still green; `npm run dev` serves mock data when toggled on.

**Implementation Notes**:
- Use `fs-admin-mock-api-with-data` skill to generate the scaffolding.
- Per beslutning, keep teardown cheap: all mock-files live under `src/mocks/applikasjoner/` or similar single-directory, ready for single-PR removal.
- For `verifiserApplikasjonEksternId`: hardcode 2-3 valid Feide-IDs and 2-3 valid Maskinporten-IDs in fixtures; everything else returns IkkeFunnet.

---

### Task #3: `useGetApplikasjonerState` + `useGetApplikasjoner` hooks (list)

**Priority**: High
**Size**: M (3-4hr)
**Dependencies**: Task #2
**Addresses Requirements**: BRU-APP-API-001 (filter, sort, paginering, search)

**Acceptance Criteria**:
- [ ] `useGetApplikasjonerState` follows `useDataListState` pattern from `useGetEmnerState` reference. URL-synced state for: `navnContains` (fritekst), `miljoKode` (single Select), `organisasjonId` (single Select), `status` (single Select). `orderBy` for navn ASC/DESC. `first` for paginering.
- [ ] `useGetApplikasjoner` runs the `applikasjoner`-query (lean field-set per Decision #6), exposes `result`, `loading`, `loadingMore`, `hasNextPage`, `totalCount`, `loadedCount`.
- [ ] `onReset` and `isModified` derived from state for `FilterReset` integration.
- [ ] No `eierOrganisasjonskode` in URL state (per cross-pattern doc Pitfall #5) — server-side filtering by user's accessible orgs.
- [ ] Unit tests for hook contract (state shape, query variables, paginering increments).

**Implementation Notes**:
- Reference: `src/domains/utdanning/features/EmnerOverview/hooks/useGetEmnerState.tsx` + `useGetEmner.tsx`.
- Use `@/common/hooks/useDataListState`, not deprecated path.

---

### Task #4: `ApplikasjonerOverview` page + filter + result list

**Priority**: High
**Size**: L (5-8hr)
**Dependencies**: Task #3
**Addresses Requirements**: BRU-APP-API-001

**Acceptance Criteria**:
- [ ] `ApplikasjonerOverview.tsx` composes `ListPageLayout` + `ListPageActionbar` (with "Opprett applikasjon"-knapp, gated by `mineApplikasjonsAdminOrganisasjoner` query returning non-empty) + `ListPageSidebar` (containing `ApplikasjonerFilter`) + `ListPageContent` (containing `ApplikasjonerResultList`).
- [ ] `ApplikasjonerFilter` follows `fs-admin-list-filters` rules: TextInput for navn (no `type="search"`, no placeholder-as-label), Select for miljø/organisasjon/status (with "Alle ..."-default). `renderAsChips` prop supported.
- [ ] `ApplikasjonerResultList` is a `NavigationList` linking each row to `/tilgangsstyring/applikasjoner/[id]`. Row shows: navn, beskrivelse, miljø-tags, organisasjon-navn, antallTilganger, status-tag. Uses `ListItemStartCell` / `ListItemCell` / `ListItemEndCell` correctly.
- [ ] "Last inn flere"-paginering via `loadedCount` / `totalCount` / `hasNextPage` / `onLoadMore` per `fs-admin-list-results` convention.
- [ ] Translation keys for all `headingText`-props (4 on ListPageLayout family + headerText/emptyText on list).
- [ ] a11y-test (`ApplikasjonerOverview.a11y.test.tsx`) green.
- [ ] Visually matches the "Applikasjoner – oversikt med filter"-skisse.

**Implementation Notes**:
- "Opprett applikasjon"-knappen i actionbar er ikke modalen selv — det er trigger-en. Modal-implementasjon i Task #11.
- Reference for structure: `EmnerOverview.tsx`. Avoid deprecated imports.
- Use `useMineLaresteder` for `effectiveOrganisasjonskode`-context only if needed by `<NoOrgError />`-pattern; otherwise rely on server-side rettighet-filtering.

---

### Task #5: `useGetApplikasjon` hook (detail-side)

**Priority**: High
**Size**: S (1-2hr)
**Dependencies**: Task #2
**Addresses Requirements**: BRU-APP-API-002 (skeleton for all detail-side features)

**Acceptance Criteria**:
- [ ] `useGetApplikasjon(id: string)` runs the `applikasjon(id)`-query.
- [ ] Returns `{ data, loading, error }`.
- [ ] `data.__typename === 'Applikasjon'` narrow used in consuming components (see `EmneDetails`-pattern).
- [ ] Apollo cache integration verified: navigating from list → detail shows partial data from cache while detail-query is in-flight.

---

### Task #6: `ApplikasjonDetails` page-shell + tabs + topbar

**Priority**: High
**Size**: L (5-8hr)
**Dependencies**: Task #5
**Addresses Requirements**: BRU-APP-API-002 (deler), BRU-APP-API-003 (tab-shell), BRU-APP-API-010 (deaktiver-knapp i topbar)

**Acceptance Criteria**:
- [ ] `ApplikasjonDetails.tsx` composes `DetailPageLayout` (title = applikasjons-navn with translated fallback while loading) + `DetailPageTopBar` (status + miljø + organisasjon + antallTilganger + "Deaktiver"/"Reaktiver"-knapp avhengig av status) + `DetailPageTabbedContent` with 2 panels: "Detaljer" (default) and "Tilganger".
- [ ] Page-level error håndteres med `LayoutMessage`, IKKE deprecated `error`-prop på `DetailPageLayout`.
- [ ] `NotFoundError` / `NoAccessError` / `NoOrgError` patterns following `EmneDetails` structure.
- [ ] "Deaktiver"-knapp synes når `kanDeaktiveres && status === AKTIV`; "Reaktiver"-knapp når `kanDeaktiveres && status === DEAKTIVERT`. Knappene åpner respektive modaler (implementert i Task #10).
- [ ] a11y-test green.
- [ ] Breadcrumb: Hjem / Tilgangsstyring / Applikasjoner / `<navn>`.

**Implementation Notes**:
- The two tab-panels render `<ApplikasjonDetaljer />` (Task #7) and `<ApplikasjonTilganger />` (Task #13) — these can be placeholders initially.
- Reference: `EmneDetails.tsx` (note: it uses deprecated `error`-prop — do not copy that; use LayoutMessage).

---

### Task #7: `ApplikasjonDetaljer` panel — view/edit toggle for detaljer-tab

**Priority**: High
**Size**: L (5-8hr)
**Dependencies**: Task #6
**Addresses Requirements**: BRU-APP-API-002, BRU-APP-API-006

**Acceptance Criteria**:
- [ ] **View-modus**: viser navn, beskrivelse, organisasjon, identitetsleverandør, sporingsinfo (opprettet av/tidspunkt, sist endret av/tidspunkt), miljø, status. Layout matcher skissen.
- [ ] "Rediger"-knapp synes når `kanRedigeres === true`. Klikk veksler til redigerings-modus.
- [ ] **Redigerings-modus**: kun **navn** og **beskrivelse** blir TextInput/TextArea. Alle andre felter forblir ren tekst.
- [ ] "Avbryt"-knapp forkaster endringer og vekslar tilbake til view-modus.
- [ ] "Lagre"-knapp kjører `oppdaterApplikasjonDetaljer`-mutasjon. Union-respons håndtert: success oppdaterer cache + viser view-modus; `ApplikasjonNavnObligatorisk` viser feilmelding på navn-feltet; `ApplikasjonVisningsnavnAlleredeIBruk` viser global feilmelding; `MutasjonAvvist` viser generisk feilmelding.
- [ ] Ulagrede endringer forkastes når brukeren bytter tab (Tilganger-tab) eller navigerer bort fra detalj-siden.
- [ ] Tomt navn → lagre avvises klientside (samtidig som server også avviser).
- [ ] a11y-test green; CSS-modul fil for layout.

**Implementation Notes**:
- Bruk `useGetMutationErrors` for union-håndteringen.
- Inspirasjon for view/edit-toggle: andre fs-admin detail-features (sjekk hvor `ViewEditSelect` eller lignende brukes).

---

### Task #8: `ApplikasjonPassord` — passord-knapp + dialog

**Priority**: Medium
**Size**: M (3-4hr)
**Dependencies**: Task #7
**Addresses Requirements**: BRU-APP-API-004

**Acceptance Criteria**:
- [ ] "Bytt passord"-knapp synes i Detaljer-panelet kun når `kanByttePassord === true`.
- [ ] Klikk åpner bekreftelses-dialog: "Generer nytt passord for `<navn>`? Det nåværende passordet vil slutte å fungere umiddelbart."
- [ ] Bekreft → kjører `genererNyttApplikasjonPassord`-mutasjon → viser ny dialog med det genererte passordet **skjult som default**, med toggle for å vise, og kopier-knapp.
- [ ] Lukk-knapp / Escape: dialog lukkes, passordet er **ikke** lenger tilgjengelig (klient holder ikke state etter lukking).
- [ ] Inspirasjon: `MigrerPassord.tsx` (les men ikke kopier).
- [ ] a11y-test green; fokus-håndtering verifisert (focus trap, focus-return ved lukking).

**Implementation Notes**:
- Sikt Design System `@sikt/sds-dialog` (eller hvilken Dialog-komponent fs-admin standardiserer på).
- Sikkerhets-UX: ingen `console.log` av passordet, ingen state-persistering, kun in-memory mens dialogen er åpen.

---

### Task #9: Deaktiver-/Reaktiver-bekreftelsesmodaler

**Priority**: Medium
**Size**: M (3-4hr)
**Dependencies**: Task #6
**Addresses Requirements**: BRU-APP-API-010

**Acceptance Criteria**:
- [ ] `DeaktiverApplikasjonModal`: tittel "Deaktivere applikasjon?", forklaring matcher skissen ("Applikasjonen «X» vil ikke lenger kunne benyttes til autentisering, og kan dermed ikke brukes i integrasjoner eller datauttrekk. Tilgangene bevares, og vil gjenopprettes ved reaktivering."), destruktiv rød knapp "Deaktiver applikasjon", "Avbryt × " topp-høyre.
- [ ] `ReaktiverApplikasjonModal`: tittel "Aktivere applikasjon?", forklaring "Applikasjonen «X» vil igjen kunne benyttes til autentisering. Tilgangene som er tildelt applikasjonen vil gjenopprettes.", lilla primær-knapp "Aktiver applikasjon".
- [ ] Bekreft → kjører `deaktiverApplikasjon` / `reaktiverApplikasjon`-mutasjon. Union-respons: success oppdaterer cache (Applikasjon.status endrer seg, topbar-knappen veksler mellom Deaktiver/Reaktiver). `MutasjonAvvist` viser feilmelding.
- [ ] Avbryt / Escape lukker uten endringer.
- [ ] a11y-test green; visuell match mot skissene.

---

### Task #10: `useGetApplikasjonTilgangerState` + `useGetApplikasjonTilganger` hooks (tilgangs-tab)

**Priority**: High
**Size**: M (3-4hr)
**Dependencies**: Task #2
**Addresses Requirements**: BRU-APP-API-003 (filter/sort/paginering)

**Acceptance Criteria**:
- [ ] `useGetApplikasjonTilgangerState` følger samme `useDataListState`-pattern som applikasjons-oversikten, men med ApplikasjonTilganger-spesifikke filterfelt: `tilgangskode` (fritekst), `miljoKode` (Select), `organisasjonId` (Select), `tilknytning` (Select med "Alle / Direkte / Arvet").
- [ ] `useGetApplikasjonTilganger(applikasjonId)` kjører `applikasjon(id) { tilganger(...) }`-spørringen med filter/orderBy/first fra state.
- [ ] Returnerer `result`, `loading`, `loadingMore`, `hasNextPage`, `totalCount`, `loadedCount` slik som applikasjons-oversikten.
- [ ] State er **separat URL-instans** fra applikasjons-listens state (egen nuqs-konfig).

**Implementation Notes**:
- Per Decision #5, ingen delt state-hook mellom applikasjons-oversikt og tilgangs-tab.

---

### Task #11: `ApplikasjonTilganger` panel — tilgangs-tab feature

**Priority**: High
**Size**: L (5-8hr)
**Dependencies**: Task #10
**Addresses Requirements**: BRU-APP-API-003

**Acceptance Criteria**:
- [ ] `ApplikasjonTilganger.tsx` viser filter-sidebar + result-list i tab-panel-en (BreakpointRender-mønster fra `DataTilganger.tsx`-referansen).
- [ ] `ApplikasjonTilgangerFilter` følger `fs-admin-list-filters` med renderAsChips-støtte.
- [ ] `ApplikasjonTilgangerResultList` er `ActionList` (ikke NavigationList — rader navigerer ikke). Hver rad viser tilgangskode, beskrivelse, organisasjon, miljø-tags. Hvis `tilknytning === ARVET`: vis "Arvet"-tag ved siden av miljø-tagene, med interaksjon (popover eller inline expand) som viser `arvetFra`-listen.
- [ ] Actionbar over listen med "Tildel tilganger"-knapp (primær, lilla) + "Fjern tilganger"-knapp (sekundær), synlige hvis `applikasjon.kanTildeleTilganger` / `applikasjon.kanFjerneTilganger`.
- [ ] "Last inn flere"-paginering per `fs-admin-list-results`.
- [ ] a11y-test green.

**Implementation Notes**:
- Arvet-tag-interaksjon: start med popover (enklere); hvis design-review sier "trenger inline expand", swap til ExpandList. Avgjøres i task-implementasjonen.

---

### Task #12: `OpprettApplikasjonModal` — opprette ny applikasjon

**Priority**: High
**Size**: L (5-8hr)
**Dependencies**: Task #4
**Addresses Requirements**: BRU-APP-API-009

**Acceptance Criteria**:
- [ ] Modal launched fra `ApplikasjonerOverview`-actionbar "Opprett applikasjon"-knapp.
- [ ] Felter (i rekkefølge):
  1. **Identitetsleverandør** — Select med kun `FEIDE` + `MASKINPORTEN` (FS er ikke valgbar; jf. krav-scenario "FS er ikke en valgbar identitetsleverandør"). Default "Ikke valgt".
  2. **Ekstern ID** — TextInput. Verifiseres via `verifiserApplikasjonEksternId`-query når brukeren forlater feltet (onBlur) eller ved submit; viser inline feedback med navn fra idP eller feilmelding.
  3. **Organisasjon** — Select. Hvis admin har én org: disabled med org-navnet forhåndsutfylt. Hvis flere: Select med "Ikke valgt"-default; valg fra `mineApplikasjonsAdminOrganisasjoner`-listen. Super-admin: alle organisasjoner.
- [ ] **Navn** vises som ren tekst etter idP-verifisering (kommer fra `ApplikasjonEksternIdVerifisert.navnFraIdp`). Ikke et input-felt — krav sier navn hentes fra idP.
- [ ] Primær-knapp "Opprett applikasjon" kjører `opprettApplikasjon`-mutasjon.
- [ ] Union-response håndteres: success (lukker modal, navigerer til detalj-siden for nye applikasjonen, eller bare oppdaterer listen — TBD design-valg), `ApplikasjonEksternIdIkkeFunnet`, `ApplikasjonEksternIdAlleredeRegistrert` (link til eksisterende applikasjon hvis `eksisterendeApplikasjonId` non-null), `ApplikasjonVisningsnavnAlleredeIBruk`, `ApplikasjonOpprettelseAvvist`.
- [ ] a11y-test green.

**Implementation Notes**:
- Apollo cache update etter success: refetch `applikasjoner`-listen eller manuelt legge til den nye i cache.
- For super-admin: `mineApplikasjonsAdminOrganisasjoner` returnerer alle orger (forventer at backend håndterer dette).

---

### Task #13: `TildelTilgangModal` — tildele tilganger

**Priority**: High
**Size**: L (5-8hr)
**Dependencies**: Task #11
**Addresses Requirements**: BRU-APP-API-007

**Acceptance Criteria**:
- [ ] Modal launched fra "Tildel tilganger"-knapp i tilgangs-tab-actionbar.
- [ ] Felter:
  1. **Organisasjon** — Select (eller disabled med forhåndsutfylt navn hvis admin har én org per Decision #8).
  2. **Miljø** — Select. Disabled inntil organisasjon er valgt.
  3. **Tilgangskoder** — multi-Select. Hentes via `tildelbareTilgangskoder(applikasjonId, organisasjonId, miljoKode)`-query når begge over er valgt. Allerede-tildelte tilganger vises gråtonet / ikke-valgbare (basert på `TilgangskodeValg.alleredeTildelt`-flag).
- [ ] Primær-knapp "Tildel tilganger" kjører `tildelApplikasjonTilganger`-mutasjon med valgte koder.
- [ ] Success → modal lukkes, tilgangs-listen refreshes (cache update), suksess-toast.
- [ ] `MutasjonAvvist` → feilmelding i modal.
- [ ] Avbryt × / Escape lukker uten endringer.
- [ ] a11y-test green; visuell match mot "Modal - tildel tilganger"-skisse.

---

### Task #14: `FjernTilgangModal` — fjerne tilganger

**Priority**: High
**Size**: M (3-4hr)
**Dependencies**: Task #11
**Addresses Requirements**: BRU-APP-API-008

**Acceptance Criteria**:
- [ ] Samme layout som TildelTilgangModal men med rød destruktiv-knapp "Fjern tilganger".
- [ ] Tilgangskode-listen viser kun tilganger applikasjonen **faktisk har** (i valgt org+miljø) som brukeren **har rettighet til å fjerne** (`ApplikasjonTilgang.kanFjernes === true`) og som **ikke er arvet** (jf. krav: "Arvede tilganger kan ikke fjernes direkte").
- [ ] Bekreft → kjører `fjernApplikasjonTilganger`-mutasjon.
- [ ] Success → modal lukkes, tilgangs-listen oppdateres.
- [ ] a11y-test green; visuell match mot "Modal - fjern tilganger"-skisse.

---

### Task #15: Translations + i18n cleanup

**Priority**: Medium
**Size**: M (3-4hr)
**Dependencies**: Tasks #4, #6, #7, #8, #9, #11, #12, #13, #14
**Addresses Requirements**: All — i18n is a project-wide constraint, not a feature-specific one.

**Acceptance Criteria**:
- [ ] Alle `headingText`, `headerText`, `emptyText`, label, button-text, modal-text i de nye komponentene er `t(...)`-kall mot `domains.tilgangsstyring.*`-nøkler.
- [ ] Norsk (nb) oversettelser komplette.
- [ ] `npm run lint` rapporterer ingen i18n-feil (hvis lint-regelen finnes); `/externalize-i18n`-kommandoen kan kjøres uten å foreslå endringer.
- [ ] `npm run generate:translations` (om relevant) oppdatert.

---

### Task #16: End-to-end a11y + integrasjons-tester

**Priority**: Medium
**Size**: L (5-8hr)
**Dependencies**: Tasks #4–#14
**Addresses Requirements**: A11y er krav på alle komponenter (CLAUDE.md).

**Acceptance Criteria**:
- [ ] Hver ny komponent har `*.a11y.test.tsx` som passerer `jest-axe`.
- [ ] Integration tests: full master-detail-flow (åpne oversikt → filtrér → klikk rad → se detaljer → back-button restorer state).
- [ ] Mutation-flow-tester: opprett, oppdater detaljer, deaktiver, reaktiver, tildel, fjern, passordbytte. Hver tester både success-path og minst én union-error-path.
- [ ] Coverage-terskler nådd: 60% branches/functions/lines, 90% statements.

---

### Task #17: Mock API teardown (etter backend leverer)

**Priority**: Low (utløses når backend er klar)
**Size**: S (1-2hr)
**Dependencies**: Backend-agent leverer Applikasjon-types i `schema.graphql`.
**Addresses Requirements**: All — krever ekte API for prod.

**Acceptance Criteria**:
- [ ] `npm run compile` regenerere `src/__generated__/graphql.ts` mot ekte schema.
- [ ] Slett alle mock-handlers og fixture-filer under `src/mocks/applikasjoner/` (eller hvor de havnet).
- [ ] Verifiser at alle 9 feature-flows fungerer mot ekte test-gateway.
- [ ] Tilpass tester som lente seg på spesifikke mock-fixture-data.

## Risk Assessment

### Technical Risks

- **Risk**: Backend leverer skjema som avviker fra spec-en (f.eks. annet feltnavn på rettighet-flagg, eller `verifiserApplikasjonEksternId` returnerer scalars i stedet for union).
  - **Mitigation**: Mock-API er optimalisert for cheap teardown. Når backend lander, refactor på consumer-side er minimal hvis vi holder oss til kun de operasjonene spec-en lister. Avvik dokumenteres som scope-endring og evt. spec-update.

- **Risk**: `useMineLaresteder` mangler den rolle-info vi trenger for visse UI-gates (Decision #3 i analysis-doc'en flagget dette).
  - **Mitigation**: `mineApplikasjonsAdminOrganisasjoner`-query returnerer org-listen som er aktiv for "Opprett"-knappen og dropdownen i opprett-modalen. Hvis videre rolle-info trengs, utvides backend-typen, ikke `useMineLaresteder`.

- **Risk**: `MigrerPassord`-mønsteret er sikkerhetsfølsomt; en feilkopiering kan lekke passordet (f.eks. via console.log eller persistent state).
  - **Mitigation**: Task #8 spesifiserer eksplisitt: ingen console.log, ingen state etter dialog-lukking. Code review for `ApplikasjonPassord` har eksplisitt sjekk på dette.

- **Risk**: Apollo cache-koordinering mellom liste, detalj, og mutasjoner blir komplisert (mutasjoner i én modal må reflekteres i list-cache + detail-cache).
  - **Mitigation**: Bruk `refetchQueries` eller `update`-callbacks med navngitte query-names. Standardiser tidlig i Task #4/#7 så mønsteret er likt overalt.

- **Risk**: "Arvet"-tag interaksjon (popover vs ExpandList) er ikke design-låst.
  - **Mitigation**: Start med popover i Task #11. Hvis design-review sier "endre", er det en isolert komponent-swap.

- **Risk**: i18n-nøkler skifter shape underveis; oversetter må omarbeide.
  - **Mitigation**: Konsolider i18n-arbeid i Task #15 etter at komponentene er stabile.

### Testing Requirements

- A11y-tester på hver komponent (prosjekt-krav).
- Unit-tester for hver hook (`useGetApplikasjoner`, `useGetApplikasjon`, state-hooks).
- Integration-tester for master-detail-flow inkl. URL-state-bevaring.
- Mutation-tester for hver av de 7 mutasjonene, både success og minst én union-error-variant.
- Visuell verifisering mot 8 sketcher (manuell + Storybook-stories der hensiktsmessig).

### Open questions (carried from analysis + spec)

Alle 13 åpne spørsmål (7 fra spec + 6 fra analyse) er løst med beslutninger registrert i `spec-applikasjoner.md` og `analysis-applikasjoner.md`. Ingen blokkerende åpne spørsmål gjenstår for planen.

## Success Criteria

- [ ] Alle 9 funksjonelle krav (BRU-APP-API-001 t.o.m. -010 ekskl. -005) er implementert og verifiserbar mot mock-API.
- [ ] Alle a11y-tester passerer.
- [ ] `npm run lint` + `npm run test:typecheck` + `npm run test` + `npm run test:a11y` grønne.
- [ ] Coverage-terskler nådd (60/60/60/90).
- [ ] Norske oversettelser komplette via `next-intl`.
- [ ] Master-detail URL-state-bevaring fungerer (back-button restorer filtre).
- [ ] MaskinBruker-koden er uberørt; `/tilgangsstyring/maskinbrukere` fungerer fortsatt.
- [ ] Mock API kan slås på/av; teardown-PR (Task #17) krever ingen consumer-kode-endringer.
- [ ] Cross-agent hand-off-issue(r) filet på backend-agent (se neste seksjon).

## Requirements Traceability

| Krav-ID | Krav-tittel | Tasks | Status |
|---|---|---|---|
| BRU-APP-API-001 | Listevisning og søk i applikasjoner | #1, #2, #3, #4, #15, #16 | Planlagt |
| BRU-APP-API-002 | Se detaljer for applikasjon | #1, #2, #5, #6, #7, #15, #16 | Planlagt |
| BRU-APP-API-003 | Vise tilganger for applikasjon | #2, #6, #10, #11, #15, #16 | Planlagt |
| BRU-APP-API-004 | Passordbytte for applikasjon | #2, #8, #15, #16 | Planlagt |
| BRU-APP-API-006 | Redigere detaljer for applikasjon | #2, #7, #15, #16 | Planlagt |
| BRU-APP-API-007 | Tildele tilgang til applikasjon | #2, #13, #15, #16 | Planlagt |
| BRU-APP-API-008 | Fjerne tilgang fra applikasjon | #2, #14, #15, #16 | Planlagt |
| BRU-APP-API-009 | Opprette applikasjon | #2, #4 (knapp), #12, #15, #16 | Planlagt |
| BRU-APP-API-010 | Deaktivere applikasjon (inkl. reaktivering) | #2, #6 (topbar), #9, #15, #16 | Planlagt |
