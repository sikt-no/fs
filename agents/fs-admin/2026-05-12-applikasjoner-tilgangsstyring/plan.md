# Plan: Applikasjoner tilgangsstyring — Iterasjon 2

**Initiativ:** [`sikt-no/fs#31`](https://github.com/sikt-no/fs/issues/31)
**Iterasjon:** 2 — Support: Oversikt og passordbytte
**Sub-issue:** [`sikt-no/fs#434`](https://github.com/sikt-no/fs/issues/434)
**Analysis:** [`analysis-applikasjoner-tilgangsstyring.md`](analysis-applikasjoner-tilgangsstyring.md)
**Krav-input:** [`krav-input/manifest.md`](krav-input/manifest.md) (branch `fruitbat`)

**Scope:** Six krav fra Iter 2: `BRU-APP-API-001` til `-006`. Iter 3+ utenfor scope.

**Key decisions:**
- Modal-based create flow (Iter 3) → list page må ha en `<NyApplikasjonButton />` placeholder allerede i Iter 2 så plassen er klargjort, men selve modalen leveres i Iter 3.
- Eksisterende `/tilgangsstyring/maskinbrukere/*` ruter forblir uberørt og leverer i parallell.
- Nye ruter under `/tilgangsstyring/applikasjoner/`.
- Mønster: `ListPageLayout` + `useDataListState`/`useDataListQuery` (modern pattern — _ikke_ replikér POC-ens client-side filter/sort/Fuse-tilnærming) + `DetailPageLayout` med tabs.
- Ingen gjenbruk av maskinbruker-queries/-komponenter.

---

## 1. Backend / GraphQL contract (assumed — to be confirmed)

> **Cross-agent hand-off:** Disse operasjonene må eksistere på supergrafen før frontend-tasks kan flettes inn. Bør files som hand-off til agenten som eier `sikt-no/fs`-supergrafen (åpen blocker via `agent-coord`).
> Inntil contract er bekreftet: implementer mot disse signaturene som mock i `cacheConfig`/Apollo-mock, eller utsett til contract er publisert. Hver frontend-task nedenfor markerer hvilken operasjon den avhenger av.

### 1.1 Schema-typer (assumed)

```graphql
type Applikasjon implements Node {
  id: ID!
  visningsnavn: String!          # hentet fra IdP, globalt unikt
  internId: ID!                  # systemgenerert
  eksternId: String!             # ID hos IdP (Feide/Maskinporten)
  identitetsleverandor: Identitetsleverandor!
  beskrivelse: String
  status: ApplikasjonStatus!     # AKTIV | DEAKTIVERT
  organisasjon: Organisasjon     # nullable (super-admin kan ha "uten org")
  ansvarlig: Ansvarlig            # union FeideBruker | FeideGruppe
  miljoer: [Miljo!]!              # miljøer applikasjonen er aktiv i (utledet fra tilganger)
  opprettetAv: Bruker!
  opprettetTidspunkt: DateTime!
  endretAv: Bruker
  endretTidspunkt: DateTime
  tilganger(
    filter: ApplikasjonTilgangerFilterInput
    orderBy: ApplikasjonTilgangerOrderByInput
    first: Int
    after: String
  ): ApplikasjonTilgangerConnection!
}

enum Identitetsleverandor { FEIDE | MASKINPORTEN | FS }   # FS read-only legacy
enum ApplikasjonStatus { AKTIV | DEAKTIVERT }
enum Miljo { PROD | DEMO | TEST }                          # TBD med backend

union Ansvarlig = FeideBruker | FeideGruppe

type ApplikasjonTilgang implements Node {
  id: ID!
  tilgangskode: String!
  miljo: Miljo!
  tildeltAv: Bruker
  tildeltTidspunkt: DateTime
}
```

### 1.2 Queries (Iter 2)

| Operasjon | Variabler | Returns | Brukes av |
|---|---|---|---|
| `applikasjoner` | `filter: ApplikasjonerFilterInput, orderBy: QueryApplikasjonerOrderByInput, first: Int, after: String` | `ApplikasjonerConnection { nodes, totalCount, pageInfo { endCursor, hasNextPage } }` | `useGetApplikasjoner` |
| `node(id: ID!) { ... on Applikasjon }` | `id` | `Applikasjon` | `useGetApplikasjon` |

**`ApplikasjonerFilterInput`** (forslag):
```graphql
input ApplikasjonerFilterInput {
  navnContains: String
  organisasjonsider: [ID!]
  tilgangsider: [ID!]          # @could — kan utsettes til etter Iter 2
  status: [ApplikasjonStatus!]
}
```

**`QueryApplikasjonerOrderByInput`** (forslag):
```graphql
input QueryApplikasjonerOrderByInput {
  orderByField: QueryApplikasjonerOrderByField!
  direction: OrderDirection!
}
enum QueryApplikasjonerOrderByField { VISNINGSNAVN }
```

Synlighet håndteres server-side basert på Feide-claims: super-admin ser alle; vanlig applikasjonsadministrator ser egne org + applikasjoner med tilganger inn i egne org; ansvarlig ser sine.

### 1.3 Mutations (Iter 2)

| Mutation | Input | Returns | Brukes av |
|---|---|---|---|
| `byttApplikasjonPassord` | `BytteApplikasjonPassordInput { applikasjonId: ID! }` | `{ passord: String! }` | `PassordbytteDialog` |
| `setApplikasjonAnsvarlig` | `SetApplikasjonAnsvarligInput { applikasjonId: ID!, ansvarligId: ID, ansvarligType: AnsvarligType }` | `{ applikasjon: Applikasjon! }` | `AdministrereAnsvarligDialog` |
| `oppdaterApplikasjonBeskrivelse` | `OppdaterApplikasjonBeskrivelseInput { applikasjonId: ID!, beskrivelse: String }` | `{ applikasjon: Applikasjon! }` | `RedigerBeskrivelseDialog` |

**Note:** `byttApplikasjonPassord` returnerer det nye passordet **én gang**; det skal aldri kunne hentes opp igjen. Krav fra `passordbytte.feature`.

**Hjelpequery for ansvarlig-søk:**
- `feideBrukereOgGrupper(organisasjonId: ID!, navnContains: String, first: Int)` — for `BRU-APP-API-005`. Antagelig finnes noe lignende i supergrafen allerede (brukt av andre features); spør agenten.

### 1.4 Apollo cache config

Legg til i `src/common/lib/apollo/cacheConfig.ts`:

```typescript
typePolicies: {
  Query: {
    fields: {
      applikasjoner: nodesCursorPagination(['filter', 'orderBy']),
      // ...
    },
  },
  Applikasjon: {
    fields: {
      tilganger: nodesCursorPagination(['filter', 'orderBy']),
    },
  },
}
```

`Applikasjon.tilganger` får sin egen `nodesCursorPagination` slik at tilganger-tab kan paginere uavhengig per applikasjon.

---

## 2. File structure

### 2.1 App router

```
src/app/tilgangsstyring/applikasjoner/
├── layout.tsx                     # PageHeaderWrapper med breadcrumbTitle (i18n: support.app.applikasjonerTitle)
├── page.tsx                       # 'use client' — renders <Applikasjoner />
└── [applikasjonId]/
    ├── layout.tsx                 # PageHeaderWrapper med applikasjonTitle
    └── page.tsx                   # async server component — leser params.applikasjonId, renders <Applikasjon id={applikasjonId} />
```

Speiler den eksisterende strukturen for `/tilgangsstyring/maskinbrukere/*`.

### 2.2 Feature folders (under `src/domains/support/features/`)

**`Applikasjoner/`** (list feature, plural):
```
Applikasjoner/
├── Applikasjoner.tsx                              # ListPageLayout container
├── Applikasjoner.module.css                       # (om styling utover layout trengs)
├── Applikasjoner.a11y.test.tsx
├── components/
│   ├── ApplikasjonerFilter/
│   │   ├── ApplikasjonerFilter.tsx                # FilterWrapper wrapper
│   │   ├── ApplikasjonerFilterNavn.tsx            # fritekst-søk på navn
│   │   ├── ApplikasjonerFilterOrganisasjon.tsx    # multi-select
│   │   ├── ApplikasjonerFilterStatus.tsx          # aktiv / deaktivert
│   │   └── ApplikasjonerFilterTilgang.tsx         # @could — multi-select (kan stubbes ut, sjekk om backend støtter)
│   ├── ApplikasjonerOrderBy/
│   │   └── ApplikasjonerOrderBy.tsx               # sort by visningsnavn (asc/desc)
│   └── ApplikasjonerResultList/
│       ├── ApplikasjonerResultList.tsx            # NavigationList med items
│       └── ApplikasjonerResultListItem.tsx        # row content
└── hooks/
    ├── useGetApplikasjonerState.tsx               # useDataListState wrapper
    └── useGetApplikasjoner.tsx                    # useDataListQuery wrapper
```

**`Applikasjon/`** (detail feature, singular):
```
Applikasjon/
├── Applikasjon.tsx                                # DetailPageLayout container
├── Applikasjon.module.css
├── Applikasjon.a11y.test.tsx
├── components/
│   ├── ApplikasjonInformation/
│   │   ├── ApplikasjonInformation.tsx             # TopBar content (navn, status-badge, org, miljø-chips, identitetsleverandør, IDer, sporing)
│   │   └── ApplikasjonInformation.module.css
│   ├── ApplikasjonTilganger/                      # Tab 1 — nested ListPageLayout-pattern
│   │   ├── ApplikasjonTilganger.tsx
│   │   ├── ApplikasjonTilgangerFilter.tsx         # filter på miljø + tilgang
│   │   ├── ApplikasjonTilgangerOrderBy.tsx
│   │   ├── ApplikasjonTilgangerResultList.tsx     # ActionList (read-only i Iter 2; Iter 3 legger til actions)
│   │   └── hooks/
│   │       ├── useGetApplikasjonTilgangerState.tsx
│   │       └── useGetApplikasjonTilganger.tsx
│   ├── ApplikasjonInfo/                           # Tab "Informasjon" (alternativ: tabben er TopBar selv)
│   │   ├── ApplikasjonInfo.tsx                    # Inneholder beskrivelse + ansvarlig + sporingsinfo
│   │   └── ApplikasjonInfo.module.css
│   ├── RedigerBeskrivelseDialog/
│   │   ├── RedigerBeskrivelseDialog.tsx
│   │   └── RedigerBeskrivelseDialog.module.css
│   ├── AdministrereAnsvarligDialog/
│   │   ├── AdministrereAnsvarligDialog.tsx        # søk feide-bruker/gruppe, sett/endre/fjern
│   │   └── AdministrereAnsvarligDialog.module.css
│   └── PassordbytteDialog/
│       ├── PassordbytteDialog.tsx                 # éngangs-visning, kopier, skjul/vis toggle
│       └── PassordbytteDialog.module.css
├── hooks/
│   └── useGetApplikasjon.tsx                      # Apollo useQuery for detail
└── mutations/                                     # Optional: separate mutation hooks
    ├── useByttApplikasjonPassord.tsx
    ├── useSetApplikasjonAnsvarlig.tsx
    └── useOppdaterApplikasjonBeskrivelse.tsx
```

**Tab-struktur (decision):** Bruker `DetailPageTabbedContent` med to tabs i Iter 2:
1. `info` (default) — beskrivelse, ansvarlig, sporingsinfo. Inneholder edit-knappene for beskrivelse og ansvarlig.
2. `tilganger` — nestet liste (filter, sort, paginering).

Endringslogg-tab (`endringslogg`) legges til i Iter 4 — eksisterer ikke i Iter 2-koden.

**TopBar:** Visningsnavn, statusbadge, organisasjon, identitetsleverandør-chip, miljø-chips. Action-knapper i topbar: "Bytt passord" (åpner `PassordbytteDialog`).

### 2.3 Shared/i18n changes

- `src/common/messages/nb/support.json` — legg til nøkler under `support.app`, `support.Applikasjoner`, `support.Applikasjon`, `support.PassordbytteDialog`, osv. (full liste i §5).
- `src/common/lib/apollo/cacheConfig.ts` — legg til `applikasjoner` og `Applikasjon.tilganger` `nodesCursorPagination`-konfigurasjon.
- `src/common/types/generated/routes.d.ts` — autogenereres når nye ruter legges til (`next typegen` kjøres i postinstall).

### 2.4 Navigation surface

- `src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.tsx` — legg til nytt Surface-kort: "Applikasjoner" som lenker til `/tilgangsstyring/applikasjoner`. Beholder "Maskinbrukere"-kortet i parallell (per brukerens beslutning).
- `src/domains/search/features/CommandPalette/hooks/useCommands.tsx` — legg til kommando "Gå til applikasjoner" / "Finn applikasjon".

---

## 3. Implementation tasks

Hver task er forholdsvis isolert. Avhengigheter er eksplisitte. Estimat er grov — _ikke binding_.

### Phase A — Foundation (forutsetter GraphQL contract bekreftet eller stubbed)

| ID | Task | Avhenger av | Filer berørt |
|---|---|---|---|
| A1 | Apollo cache config for `applikasjoner` og `Applikasjon.tilganger` | `applikasjoner`-query eksisterer | `src/common/lib/apollo/cacheConfig.ts` |
| A2 | Route skeleton (4 filer) — `page.tsx`, `layout.tsx` på begge nivåer | — | `src/app/tilgangsstyring/applikasjoner/...` |
| A3 | i18n-nøkler (initial sett: `support.app.applikasjonerTitle`, `applikasjonTitle`, page titles) | — | `src/common/messages/nb/support.json` |
| A4 | TilgangsstyringIndex får nytt kort | A2 (rute må eksistere for href) | `TilgangsstyringIndex.tsx`, `support.json` |
| A5 | CommandPalette får ny kommando | A2 | `useCommands.tsx`, `search.json` |

### Phase B — List page (`BRU-APP-API-001`)

| ID | Task | Avhenger av | Filer berørt |
|---|---|---|---|
| B1 | `useGetApplikasjonerState` — initFilter (`navnContains`, `organisasjonsider`, `tilgangsider`, `status`), initOrderBy, initFirst: 50 | A3 | `Applikasjoner/hooks/useGetApplikasjonerState.tsx` |
| B2 | `useGetApplikasjoner` — Apollo `useDataListQuery` med `applikasjoner`-query, includes `id, visningsnavn, beskrivelse, status, organisasjon { id, navn, forkortelse }, ansvarlig, miljoer` (minimal list-fields), totalCount, pageInfo | A1, B1, GraphQL: `applikasjoner` | `Applikasjoner/hooks/useGetApplikasjoner.tsx` |
| B3 | `ApplikasjonerResultList` — `NavigationList` med `NavigationListItem` href `/tilgangsstyring/applikasjoner/[applikasjonId]` | B2 | `components/ApplikasjonerResultList/*` |
| B4 | Filter-komponenter (`Navn`, `Organisasjon`, `Status`; `Tilgang` som `@could` stubbes om backend ikke støtter ennå) | B1 | `components/ApplikasjonerFilter/*` |
| B5 | `ApplikasjonerOrderBy` — sort på `visningsnavn` (asc/desc) | B1 | `components/ApplikasjonerOrderBy/*` |
| B6 | `Applikasjoner.tsx` — kompositt med `ListPageLayout`, `ListPageActionbar` (placeholder for "Ny applikasjon"-knapp som er disabled / TBD), `ListPageSidebar`, `ListPageContent` | B3, B4, B5 | `Applikasjoner.tsx` |
| B7 | A11y test for `Applikasjoner` | B6 | `Applikasjoner.a11y.test.tsx` |
| B8 | i18n-nøkler for list page (sidebar title, filter labels, order options, result list header/empty/error) | B4, B5, B6 | `support.json` |

### Phase C — Detail page skeleton (`BRU-APP-API-002`)

| ID | Task | Avhenger av | Filer berørt |
|---|---|---|---|
| C1 | `useGetApplikasjon(id)` — Apollo `useQuery` med `node(id:$id) { ... on Applikasjon { ... } }`, inkludert fragment for `ApplikasjonInformation` | A1, GraphQL: `node`/`Applikasjon` | `Applikasjon/hooks/useGetApplikasjon.tsx` |
| C2 | `ApplikasjonInformation` (TopBar content) — visningsnavn-skeleton, status-badge, org, identitetsleverandør, miljø-chips, IDer, sporingsinfo | C1 | `components/ApplikasjonInformation/*` |
| C3 | `Applikasjon.tsx` — `DetailPageLayout` + `DetailPageTopBar` + `DetailPageTabbedContent` med `info` (default) og `tilganger` tabs | C2 | `Applikasjon.tsx` |
| C4 | `ApplikasjonInfo` (tab "info") — viser beskrivelse, ansvarlig, sporing. Edit-knapper åpner dialoger (stub i denne fasen). | C2 | `components/ApplikasjonInfo/*` |
| C5 | A11y test for `Applikasjon` | C3 | `Applikasjon.a11y.test.tsx` |
| C6 | i18n-nøkler for detail page (topBarHeading, tabbedContentHeading, tabsAriaLabel, infoTab, tilgangerTab, defaultTitle) | C3 | `support.json` |

### Phase D — Tilganger tab (`BRU-APP-API-003`)

| ID | Task | Avhenger av | Filer berørt |
|---|---|---|---|
| D1 | `useGetApplikasjonTilgangerState` — initFilter (`miljoer: []`, `tilgangsider: []`), initOrderBy (`tilgangskode ASC`), initFirst: 50. URL-key prefikset så det ikke kolliderer med top-level (`?tab=tilganger&tilgFirst=50&tilgMiljoer=...` — bruk `useDataListState`-konvensjon for unike keys i nestet kontekst). | — | `components/ApplikasjonTilganger/hooks/useGetApplikasjonTilgangerState.tsx` |
| D2 | `useGetApplikasjonTilganger(applikasjonId)` — query mot `Applikasjon.tilganger` med filter/orderBy/first/after. Bruker fragment fra `useGetApplikasjon`-query for å gjenbruke cache. | C1, D1, GraphQL: `Applikasjon.tilganger(filter, orderBy, first, after)` | `components/ApplikasjonTilganger/hooks/useGetApplikasjonTilganger.tsx` |
| D3 | `ApplikasjonTilgangerResultList` — `ActionList` (read-only i Iter 2; Iter 3 gjør om til selection-aware med bulk-actions). Items viser tilgangskode + miljø-chip. | D2 | `components/ApplikasjonTilganger/ApplikasjonTilgangerResultList.tsx` |
| D4 | Filter (miljø, tilgang) + OrderBy (tilgangskode/miljø, asc/desc) | D1 | `ApplikasjonTilgangerFilter.tsx`, `ApplikasjonTilgangerOrderBy.tsx` |
| D5 | `ApplikasjonTilganger.tsx` — kompositt; bruker `FilterWrapper` for filter-organisering i tab-kontekst | D3, D4 | `ApplikasjonTilganger.tsx` |
| D6 | i18n-nøkler for tilganger-tab | D5 | `support.json` |

### Phase E — Passordbytte (`BRU-APP-API-004`)

| ID | Task | Avhenger av | Filer berørt |
|---|---|---|---|
| E1 | `useByttApplikasjonPassord` — `useMutation` wrapper for `byttApplikasjonPassord`. Returnerer `{ passord, loading, error, mutate }` | GraphQL: `byttApplikasjonPassord` | `Applikasjon/mutations/useByttApplikasjonPassord.tsx` |
| E2 | `PassordbytteDialog` — modal med: "Generer nytt passord" → confirm step → viser passord skjult med `eye`-toggle, "Kopier"-knapp (clipboard API), advarsel "Passordet kan ikke hentes opp igjen". Skal kun vise éngangs-visning; close-knapp clearer state. | E1 | `components/PassordbytteDialog/*` |
| E3 | "Bytt passord"-knapp i `Applikasjon` topbar action area. Skjult hvis bruker mangler rettighet (sjekk `applikasjon.kanByttePassord: Boolean!` eller tilsvarende — _må avklares med backend_; alternativt: `try mutation → catch 403`-fallback for Iter 2). | C3, E2 | `Applikasjon.tsx` |
| E4 | A11y test (focus management, role=alertdialog, clipboard a11y) | E2 | `PassordbytteDialog.a11y.test.tsx` |
| E5 | i18n: `support.PassordbytteDialog.*` (open, generate, hidden, show, copy, copied, warning, close) | E2 | `support.json` |

### Phase F — Administrere ansvarlig (`BRU-APP-API-005`)

| ID | Task | Avhenger av | Filer berørt |
|---|---|---|---|
| F1 | `useSetApplikasjonAnsvarlig` — mutation wrapper. Tre handlinger: sett, endre, fjern (siste sender `ansvarligId: null`). | GraphQL: `setApplikasjonAnsvarlig` | `mutations/useSetApplikasjonAnsvarlig.tsx` |
| F2 | Søke-query for feide-brukere/grupper innen org. **Antagelse:** finnes allerede i supergrafen, må verifiseres. | GraphQL: brukere/grupper query | (eksisterende eller ny hook) |
| F3 | `AdministrereAnsvarligDialog` — søkefelt scoped til `applikasjon.organisasjon.id`, viser resultater (FeideBruker + FeideGruppe `@could`), "Velg"-knapp, "Fjern ansvarlig"-knapp. | F1, F2 | `components/AdministrereAnsvarligDialog/*` |
| F4 | Trigger fra `ApplikasjonInfo` tab — "Rediger ansvarlig"-knapp ved siden av visning. Skjult uten rettighet. | C4, F3 | `ApplikasjonInfo.tsx` |
| F5 | A11y test | F3 | `AdministrereAnsvarligDialog.a11y.test.tsx` |
| F6 | i18n: `support.AdministrereAnsvarligDialog.*` | F3 | `support.json` |

### Phase G — Redigere beskrivelse (`BRU-APP-API-006`)

| ID | Task | Avhenger av | Filer berørt |
|---|---|---|---|
| G1 | `useOppdaterApplikasjonBeskrivelse` — mutation wrapper | GraphQL: `oppdaterApplikasjonBeskrivelse` | `mutations/useOppdaterApplikasjonBeskrivelse.tsx` |
| G2 | `RedigerBeskrivelseDialog` — modal med textarea, lagre/avbryt | G1 | `components/RedigerBeskrivelseDialog/*` |
| G3 | Trigger fra `ApplikasjonInfo` tab — "Rediger beskrivelse"-knapp. Skjult uten rettighet. | C4, G2 | `ApplikasjonInfo.tsx` |
| G4 | A11y test | G2 | `RedigerBeskrivelseDialog.a11y.test.tsx` |
| G5 | i18n: `support.RedigerBeskrivelseDialog.*` | G2 | `support.json` |

### Phase H — Polish & validation

| ID | Task | Avhenger av | Filer berørt |
|---|---|---|---|
| H1 | "Ny applikasjon"-knapp placeholder i `ListPageActionbar` (disabled m/ tooltip "Tilgjengelig i neste iterasjon", eller helt skjult — UX-beslutning). Selve modalen leveres i Iter 3. | B6 | `Applikasjoner.tsx`, `support.json` |
| H2 | Snackbar-feedback for vellykkede mutations (passordbytte er unntak — det viser passordet i modalen, ikke snackbar) | E2, F3, G2 | mutation hooks |
| H3 | Roll-/rettighet-gating gjennomgang — kontroller at alle handlinger sjekker `applikasjon.kanX`-felt (eller tilsvarende) og at filtre/listene respekterer server-side autorisering | E3, F4, G3 | alle dialog-triggere |
| H4 | Manual smoke-test mot dev/test env, sjekk URL-state-sync, browser back, paginering | alle | — |
| H5 | Lint + typecheck + a11y-test-suite må passere før PR | alle | — |

---

## 4. Dependencies summary

### 4.1 Cross-agent

- **Backend-supergraf agent** ([`sikt-no/fs`](https://github.com/sikt-no/fs) eier):
  - `Applikasjon` type + relatert (Connections, enums, union for Ansvarlig)
  - Queries: `applikasjoner`, `node` for Applikasjon, `Applikasjon.tilganger`
  - Mutations: `byttApplikasjonPassord`, `setApplikasjonAnsvarlig`, `oppdaterApplikasjonBeskrivelse`
  - Server-side autorisering for synlighet og handlinger
  - **Hand-off:** Bør opprettes som issue i `sikt-no/fs` med `agent:<owner>`-label via `agent-coord`-skill, lenket til [`agents/fs-admin/2026-05-12-applikasjoner-tilgangsstyring/analysis.md`](../coord/agents/fs-admin/2026-05-12-applikasjoner-tilgangsstyring/analysis.md) og denne plan-fila (`plan.md` i samme folder etter publish).

### 4.2 Intern fs-admin

- `useDataListState` / `useDataListQuery` (eksisterer)
- `ListPageLayout`, `DetailPageLayout` og underkomponenter (eksisterer)
- `NavigationList`, `ActionList`, `FilterWrapper`, `FilterReset` (eksisterer)
- `useMineLaresteder` (eksisterer — gir `effectiveOrganisasjonskode`)
- `PageHeaderWrapper` (eksisterer)
- `gql()`-codegen via `npm run watch:codegen` — produserer typer for nye queries

### 4.3 Decisions still open

Disse er ikke blokkere for Phase A–B, men må avklares før Phase C+:

- [ ] Konkret schema for `Ansvarlig`-union — er det `FeideBruker | FeideGruppe` eller `Ansvarlig` med `type: AnsvarligType`? Påvirker GraphQL query-form (inline fragments vs union access).
- [ ] Hvilken `Miljo`-enum-verdier finnes — `PROD | DEMO | TEST`? Andre? Påvirker UI chips og filter.
- [ ] Hvordan eksponeres rettighetsregler? Boolean-felter på `Applikasjon` (`kanByttePassord`, `kanRedigereBeskrivelse`, `kanAdministrereAnsvarlig`)? En egen `permissions`-blokk? — Trenger avklaring før Phase E/F/G kan implementere riktig gating uten try/catch-fallback.
- [ ] Hvor mange organisasjoner kan en bruker ha applikasjonsadministrator-rollen for? Påvirker `useMineLaresteder`-bruk og om `effectiveOrganisasjonskode` er meningsfullt her (kan være at applikasjoner ikke skal filtreres på samme måte som emner/studieprogram).
- [ ] i18n-fil — beholder i `support.json`, eller egen `applikasjoner.json`? Default: beholder i `support.json` (lavest endring).

---

## 5. Translation keys (initial inventory)

Under `support.json`, tilfør:

```json
{
  "support": {
    "app": {
      "applikasjonerTitle": "Applikasjoner",
      "applikasjonTitle": "Applikasjon"
    },
    "Applikasjoner": {
      "pageTitle": "Applikasjoner",
      "sidebarTitle": "Filter",
      "contentTitle": "Applikasjoner",
      "filter": {
        "navnLabel": "Søk på navn",
        "navnClearAria": "Tøm søk",
        "organisasjonLabel": "Organisasjon",
        "statusLabel": "Status",
        "statusAktiv": "Aktiv",
        "statusDeaktivert": "Deaktivert",
        "tilgangLabel": "Tilgang"
      },
      "orderBy": {
        "visningsnavn": "Navn"
      },
      "resultList": {
        "headerText": "Applikasjoner",
        "emptyResultText": "Ingen applikasjoner matcher filteret",
        "errorText": "Kunne ikke laste applikasjoner",
        "loadMore": "Last inn flere",
        "totalCount": "{loaded} av {total} applikasjoner"
      },
      "nyApplikasjonComingSoon": "Tilgjengelig i neste iterasjon"
    },
    "Applikasjon": {
      "defaultTitle": "Laster applikasjon …",
      "topBarHeading": "Nøkkelinformasjon",
      "tabbedContentHeading": "Applikasjondetaljer",
      "tabsAriaLabel": "Navigasjon mellom applikasjondetaljer",
      "infoTab": "Informasjon",
      "tilgangerTab": "Tilganger",
      "errors": {
        "notFound": "Applikasjonen finnes ikke",
        "loadFailed": "Kunne ikke laste applikasjonen"
      }
    },
    "ApplikasjonInformation": {
      "visningsnavnLabel": "Navn",
      "statusLabel": "Status",
      "organisasjonLabel": "Organisasjon",
      "identitetsleverandorLabel": "Identitetsleverandør",
      "miljoerLabel": "Miljøer",
      "internIdLabel": "Intern ID",
      "eksternIdLabel": "Ekstern ID",
      "opprettetLabel": "Opprettet",
      "endretLabel": "Sist endret"
    },
    "ApplikasjonInfo": {
      "beskrivelseLabel": "Beskrivelse",
      "ansvarligLabel": "Ansvarlig",
      "redigerBeskrivelse": "Rediger beskrivelse",
      "redigerAnsvarlig": "Endre ansvarlig",
      "ingenAnsvarlig": "Ingen ansvarlig registrert"
    },
    "ApplikasjonTilganger": {
      "headerText": "Tilganger",
      "emptyResultText": "Applikasjonen har ingen tilganger",
      "errorText": "Kunne ikke laste tilganger",
      "filter": {
        "miljoLabel": "Miljø",
        "tilgangLabel": "Tilgang"
      },
      "orderBy": {
        "tilgangskode": "Tilgangskode",
        "miljo": "Miljø"
      }
    },
    "PassordbytteDialog": {
      "open": "Bytt passord",
      "title": "Bytt passord for {visningsnavn}",
      "generateButton": "Generer nytt passord",
      "showPasswordAria": "Vis passord",
      "hidePasswordAria": "Skjul passord",
      "copyButton": "Kopier passord",
      "copied": "Passordet er kopiert til utklippstavlen",
      "warning": "Passordet vises kun denne ene gangen. Når du lukker dialogen, må du generere et nytt passord hvis du trenger å se det igjen.",
      "close": "Lukk",
      "errorTitle": "Kunne ikke generere passord",
      "errorDescription": "Prøv igjen, eller kontakt support hvis problemet vedvarer."
    },
    "AdministrereAnsvarligDialog": {
      "openSet": "Sett ansvarlig",
      "openChange": "Endre ansvarlig",
      "title": "Ansvarlig for {visningsnavn}",
      "searchLabel": "Søk etter feide-bruker (eller feide-gruppe) i {organisasjon}",
      "selectButton": "Velg",
      "removeButton": "Fjern ansvarlig",
      "saveButton": "Lagre",
      "cancelButton": "Avbryt",
      "noResults": "Ingen treff",
      "errorTitle": "Kunne ikke oppdatere ansvarlig"
    },
    "RedigerBeskrivelseDialog": {
      "open": "Rediger beskrivelse",
      "title": "Rediger beskrivelse for {visningsnavn}",
      "beskrivelseLabel": "Beskrivelse",
      "saveButton": "Lagre",
      "cancelButton": "Avbryt",
      "errorTitle": "Kunne ikke oppdatere beskrivelse"
    },
    "TilgangsstyringIndex": {
      "applikasjonerLabel": "Applikasjoner",
      "applikasjonerDescription": "Administrer applikasjoner og deres tilganger til FS-data"
    }
  }
}
```

I `search.json`:

```json
{
  "search": {
    "CommandPalette": {
      "commands": {
        "applikasjoner": "Gå til applikasjoner"
      }
    }
  }
}
```

(Endelige nøkler bør i18n-eksternaliseres med `/externalize-i18n` om noe blir hardkodet underveis.)

---

## 6. Risk & mitigation

| Risiko | Sannsynlighet | Impact | Mitigering |
|---|---|---|---|
| GraphQL contract ikke klar i tid | Høy | Blokkerende | Start Phase A–B med stubbede typer + MSW-mocks for å parallellisere; flett først når contract publiseres. |
| Iter 2-rettighetsregler avklares uklart | Middels | Middels | Implementer try/catch-gating som Iter 2-fallback; rens opp i Iter 3 når permissions-felter eksisterer. |
| Tilganger-tab nestet `useDataListState` URL-kollisjon med `?tab=tilganger` | Lav | Lav | Bruk unike URL-keys via `useDataListState`-konfigurasjon (prefiks alle keys, f.eks. `tilg.first`, `tilg.miljoer`). |
| Visningsnavn ikke globalt unikt → kollisjon i lista | Lav | Lav | Krav-fila lover globalt unikt visningsnavn; lita ID i tooltips/sub-text for å disambiguere. |
| `Applikasjon.kanX` boolean-flagg finnes ikke → action-knapper viser uten rettighet | Middels | Middels | Server-side mutation feiler, frontend viser snackbar med "Du har ikke tilgang". Forbedres når permissions-felter blir tilgjengelige. |
| Maskinbruker-Apollo-cache påvirkes av ny `applikasjoner`-typePolicy | Lav | Lav | Sjekk at maskinbruker-flow fortsatt funker etter `cacheConfig.ts`-endring. Begge bruker `nodesCursorPagination` men ulike root-felter, så ingen kollisjon. |

---

## 7. Validation checklist

**Per task:**
- [ ] TypeScript-typer eksportert hvor relevant
- [ ] CSS Modules der det trengs styling
- [ ] `*.a11y.test.tsx` for hver komponent (mandatory per CLAUDE.md)
- [ ] Norsk i UI-strenger via `next-intl` (ingen hardkodet norsk)
- [ ] Engelsk i kode og kommentarer

**Per feature (etter Phase H):**
- [ ] Listside laster ≤ 50 applikasjoner ved første request, "last flere" fungerer uten scroll-jump
- [ ] Filter/sort-state synkes til URL (`?navnContains=...&orderByField=VISNINGSNAVN&first=50`)
- [ ] Browser back fra detalj til liste preserverer filter-state
- [ ] Detaljside henter via Apollo cache når åpnet fra lista (instant render)
- [ ] Tilganger-tab paginerer uavhengig av list-state
- [ ] Passordbytte: passord vises kun én gang, kan kopieres, varsel om at det ikke kan hentes opp
- [ ] Ansvarlig-søk scoped til applikasjonens organisasjon
- [ ] Redigere beskrivelse: cache oppdateres etter mutation, dialog lukkes
- [ ] Action-knapper for handlinger som krever rettighet skjules eller gir snackbar når bruker mangler rettighet
- [ ] Maskinbruker-feature er fortsatt funksjonell (uberørt parallell)
- [ ] `npm run lint`, `npm run test:typecheck`, `npm run test`, `npm run test:a11y` passerer
- [ ] Manuell smoke-test på review-environment

**Per krav-id:**
- [ ] `BRU-APP-API-001` — alle scenarios i `listevisning_og_sok.feature` har tilsvarende UI-flyt
- [ ] `BRU-APP-API-002` — alle datafelter i `se_detaljer.feature` vises på detaljsiden
- [ ] `BRU-APP-API-003` — tilganger-tab oppfyller filter/sort/paginering-scenarios i `vise_tilganger.feature`
- [ ] `BRU-APP-API-004` — alle 5 scenarios i `passordbytte.feature` dekket
- [ ] `BRU-APP-API-005` — alle scenarios i `administrere_ansvarlig.feature` (sett/endre/fjern, søk scoped, rettighetsregler) dekket
- [ ] `BRU-APP-API-006` — alle scenarios i `rediger_beskrivelse.feature` (oppdatere, rettighetsregler) dekket

---

## 8. Out of scope (eksplisitt)

- **Iter 3:** Opprette applikasjon (modal flyt), tildele/fjerne tilgang, deaktivere/reaktivere. Tilganger-tab har bevisst ingen actions (read-only `ActionList`) i Iter 2.
- **Iter 4:** Endringslogg-tab (`@draft`, åpne produktspørsmål).
- **Nice-to-have:** Masseadministrasjon av tilganger, sist brukt tidspunkt.
- **Avvikling av maskinbruker-POC:** Egen aktivitet senere; rutene består uberørt i denne planen.
- **CSV-eksport / batch-operasjoner:** Ikke i krav.
- **Endring av identitetsleverandør på eksisterende applikasjon:** Eksplisitt utelukket i krav.

---

## 9. Sequencing recommendation

**Sprint 1** (parallelliserbar):
- Phase A (foundation) — kan starte med stub-types straks
- Backend hand-off opprettes som issue
- Phase B (list page) — start mot stub, fles inn når contract er på plass

**Sprint 2:**
- Phase C (detail skeleton)
- Phase D (tilganger tab)

**Sprint 3:**
- Phase E, F, G (de tre action-dialogene — kan deles på flere)
- Phase H (polish + validation)

Avhengig av backend-progresjon kan Phase B + C + D kjøres i samme sprint hvis contract er klar fra start.