# Analysis: Applikasjoner — Grunnleggende selvbetjent tilgangsstyring (greenfield)

## Problem Statement

Build 9 features for application-management (BRU-APP-API-001–010 except 005) on a **fresh greenfield branch** (`applications-and-application-detail-greenfield-build`) that branched from `main`. The spec at [`spec-applikasjoner.md`](spec-applikasjoner.md) defines *what* to build (overview, detail-with-tabs, 5 modals, GraphQL contract). This analysis answers *how* it fits the existing fs-admin codebase — what to reuse, what to remove, and what depends on the backend agent.

Key context: the codebase already contains a partial **MaskinBruker** implementation. The initiative-body in #31 mentions removal — but per user beslutning (2026-06-01), **MaskinBruker-koden skal IKKE fjernes som del av dette arbeidet**. Det nye applikasjons-arbeidet bygges parallelt under et nytt domain-tre uten å røre MaskinBruker. Selve `Vi skal ikke gjenbruke dagens graphql spørringer for maskinbruker`-direktivet respekteres ved at vi spør på nye `Applikasjon`-types — eksisterende MaskinBruker-types ignoreres, de slettes ikke.

Noen UI-mønstre fra MaskinBruker er likevel **inspirasjon** (ikke kopiert kode): `MigrerPassord` viser passordbytte-mønsteret (skjult passord, kopier-knapp, dialog-lukking), og `DataTilganger`/`ApiTilganger` viser in-tab filter+list-strukturen. Ny applikasjons-kode skriver disse fra bunnen i sin egen feature-folder.

## Current State

### Layouts available (canonical location: `src/common/components/layouts/`)

- **`ListPageLayout`** — page-level orchestrator for `Applikasjoner`-oversikten (BRU-APP-API-001). With `ListPageSidebar`, `ListPageActionbar`, `ListPageContent`. CLAUDE.md at `src/common/components/layouts/ListPageLayout/CLAUDE.md`.
- **`DetailPageLayout`** — page-level orchestrator for the Applikasjon-detalj-side (BRU-APP-API-002, -003, -006, -010). With `DetailPageTopBar`, `DetailPageTabbedContent`, `DetailPageTabbedContentPanel`, `DetailPageActionbar`. CLAUDE.md at `src/common/components/layouts/DetailPageLayout/CLAUDE.md`.
- **Note on imports:** `src/components/layouts/...` exists but is **deprecated tunnel exports** ([`src/components/CLAUDE.md`](../../../src/components/CLAUDE.md) sier dette eksplisitt). Greenfield-koden må importere fra `@/common/components/...`, ikke `@/components/...`. Eksisterende referanseimplementasjoner (`EmnerOverview.tsx`, `EmneDetails.tsx`) bruker fortsatt deprecated-stier — ikke kopier de importene blindt.
- **Error-handling deprecation**: `DetailPageLayout.error`-prop er deprecated (CLAUDE.md sier explicit). Bruk `LayoutMessage`-komponent for page-level feil.

### Hooks (canonical: `src/common/hooks/`)

- **`useDataListState`** — URL-synced filter/orderBy/pagination state via `nuqs`. CLAUDE.md ved `src/common/hooks/useDataListState/CLAUDE.md`. **Brukes for både applikasjons-oversikten og tilgangs-tab-en på detalj-siden** (begge er filter+list+pagination — bare ulike state-instanser).
- **`useDataListQuery`** — Apollo-query-orchestrator som bruker state fra `useDataListState`. CLAUDE.md ved `src/common/hooks/useDataListQuery/CLAUDE.md`.
- **`useMineLaresteder`** (i `@/lib/auth/globalUserContext`) — gir `effectiveOrganisasjonskode` og rolle-info. Brukes på begge sider (oversikt + detalj) for org-scoping og adgangskontroll. **Sannsynligvis må utvides** for å eksponere applikasjonsadministrator-rollene (super-admin / admin per org); bekreft i `bat-plan` mot faktisk type-definisjon.
- **`useGetMutationErrors`** — håndterer union-feilenveloppe fra mutasjoner. Brukes for alle 7 mutasjonene spec-en lister.
- **`useTranslated`** — for lokaliserte felter på `Miljo.navn` osv. (om backend leverer lokaliserte strenger som union).

### List-komponenter (canonical: `src/common/components/lists/`)

- **`NavigationList`** + `NavigationListItem` — for applikasjons-oversikten (BRU-APP-API-001). Hver rad linker til detalj-siden. Bruk `href`-prop, ikke `router.push`.
- **`ActionList`** — for tilgangs-tab-en på detalj-siden (BRU-APP-API-003). Rad-er navigerer ikke; de har in-row actions (`Fjern`-knapp på rader bruker har rettighet til, ifølge `kanFjernes`-feltet i spec-skjemaet).
- **`ExpandList`** — *kandidat* for tilgangs-tab-en hvis arvede-tilganger-opphav skal vises som inline-ekspanderbar rad (jf. spec-beslutning om "Arvet"-tag). Avgjøres i `bat-plan`.
- **Cell-komponenter:** `ListItemCell`, `ListItemStartCell`, `ListItemEndCell` — for å lage rad-innhold. Aldri bare strings/divs direkte i listItems.

### Filter-primitivene (canonical: `src/common/components/`)

- **`FilterWrapper`** — sidebar-container med chip-rendering.
- **`FilterReset`** — "Tøm filter"-knapp som skissene viser.
- **`FilterChip`** — kompakt visning av aktive filtre over result-listen (når filter-sidebar er skjult).
- **`FSFilterList` + `FilterListSection` + `FilterListItem`** — for zero/one/many-of-N filter (sannsynligvis ikke nødvendig her; spec-filtrene er rene single-select Selects + fritekst-input).

### Input-komponenter (følger `fs-admin-inputs`-konvensjonene)

- **`TextInput`** — fritekst (filter-navn, filter-tilgangskode, redigering av applikasjon-navn/beskrivelse, opprett-applikasjon ekstern ID).
  - **NB:** Aldri `type="search"`; ingen placeholder-as-label.
- **`Select`** (fra `@sikt/sds-select`) — for status / org / miljø / tilknytning / identitetsleverandør / tilgangskode. Alltid med "Alle ..."-default for filter, eller "Ikke valgt" for modal-felter.
- **`TextArea`** — for beskrivelse-feltet i rediger-modus.
- **`Dialog` / `Modal`** — for de 5 modalene (tildel, fjern, deaktiver, reaktiver, passordbytte) + 1 opprett-applikasjon-modal. Brukes konsekvent gjennom fs-admin; nøyaktig komponentpath fastsettes i `bat-plan` (Sikt Design System har `@sikt/sds-dialog`).

### Eksisterende reference-implementasjoner

1. **`EmnerOverview` ↔ `EmneDetails`** (`src/domains/utdanning/features/`) — gull-standard for ListPageLayout ↔ DetailPageLayout master-detail-flow. Følger nesten alle konvensjoner; bruker fortsatt deprecated `@/components/...`-import-stier og deprecated `DetailPageLayout.error`-prop. Strukturen er ellers idiomatisk.
2. **`MaskinBruker.tsx`** + sub-komponenter (`src/domains/support/features/MaskinBruker/`) — illustrerer detail-side med to filter+list-tabs (`DataTilganger` + `ApiTilganger`). **Skal fjernes**, men *mønsteret* er nøyaktig det vi trenger for Applikasjon-detalj-siden:
   - `DataTilganger.tsx` viser hvordan tab-innholdet komponeres (`BreakpointRender` for sidebar-filter på ultraWide, `Flex` for layout, separat result-list-komponent).
   - `MigrerPassord/MigrerPassord.tsx` + `MigrerPassordDialog.tsx` — direkte inspirasjon for BRU-APP-API-004 (passordbytte) per beslutning i spec-en. Skjult passord, kopier-knapp, dialog-lukking. Disse kan kopieres til den nye applikasjons-feature-folderen og tilpasses den nye GraphQL-mutasjonen før MaskinBruker-koden slettes.

### GraphQL-skjema (current state)

- **`schema.graphql`** (lokal SDL-snapshot fra `supergraf-gateway-test.fsweb.no`) inneholder:
  - **0 `Applikasjon`-types.** Ingen `Applikasjon`-, `ApplikasjonTilgang`-, `Identitetsleverandor`-, `verifiserApplikasjonEksternId`-, `opprettApplikasjon`-symboler finnes.
  - **83 `Maskinbruker`-references**: `Maskinbruker`-type, `MaskinbrukerApiTilgangerConnection`, `MaskinbrukerApiTilgangerConnectionEdge`, `MaskinbrukerApiTilgangerFilterInput`/V2, `MaskinbrukerDatatilgangerConnection`/Edge, `MaskinbrukereFilter`. Alle disse er den nåværende test-gateway-snapshotten — backend-agent fjerner dem på `fruitbat`-branchen før den deploys til test.
- **`src/__generated__/graphql.ts`** — auto-genereret fra skjemaet via codegen; ingen `Applikasjon`-types her heller. Genereres på nytt når `schema.graphql` oppdateres.
- **Konsekvens for fs-admin (forbrukerside):** alle 7 mutasjoner og de 4 query-tilleggene i spec-skjemaet **må implementeres backend-side først** før forbruker-koden kan bygges mot ekte typer. Mock-API kan brukes som overgang (jf. `fs-admin-mock-api-with-data`-skillen) hvis greenfield-implementasjonen skal kunne testes UI-end før backend lander.

### MaskinBruker-kode — IKKE rør (kun inspirasjon)

Per beslutning 2026-06-01: MaskinBruker-koden **forblir uberørt**. Listen under er for å vite *hvor* mønstrene ligger (slik at man kan lese dem som referanse), ikke for sletting.

**App-routes som forblir** (Next.js):
- `src/app/tilgangsstyring/maskinbrukere/` (list-route — fortsetter å eksistere)
- `src/app/tilgangsstyring/maskinbrukere/[maskinbrukerid]/` (detail-route — fortsetter å eksistere)

**Feature-folders som forblir** (under `src/domains/support/features/`):
- `MaskinBruker/` — hele detalj-side-feature, inkludert:
  - `components/MigrerPassord/MigrerPassord.tsx` + `MigrerPassordDialog.tsx` — **referanse for BRU-APP-API-004 (passordbytte)-mønsteret**. Ny `ApplikasjonPassord/` skrives fra bunnen i ny feature; ingen kode kopieres.
  - `components/DataTilganger/`, `components/ApiTilganger/` — **referanse for in-tab filter+list-strukturen** (BRU-APP-API-003). Ny `ApplikasjonTilganger/` skrives fra bunnen.
- `Maskinbrukere/` — hele oversikts-feature, **forblir uberørt**.

**Andre referanser som forblir**:
- `src/domains/search/features/CommandPalette/hooks/useCommands.tsx` — beholder eksisterende maskinbrukere-kommando, og **får eventuelt en ny applikasjoner-kommando i tillegg** (avgjøres i `bat-plan`).
- Eksisterende `src/messages/nb/support/MaskinBruker*`-i18n-nøkler beholdes. Nye nøkler for applikasjoner legges under `domains.tilgangsstyring.*`.
- Sidebar/sidemeny: eksisterende `/tilgangsstyring/maskinbrukere`-link beholdes. Ny `/tilgangsstyring/applikasjoner`-link legges til ved siden av — avgjøres i `bat-plan`.

**GraphQL-spørringer**:
- Eksisterende `gql(...)`-blokker mot `maskinbruker(...)` / `maskinbrukere(...)` / `Maskinbruker*`-types **forblir uberørt**.
- Nye `gql(...)`-blokker skrives mot de nye `Applikasjon`-types (når backend leverer dem). Per initiativ-direktiv "Vi skal ikke gjenbruke dagens graphql spørringer for maskinbruker" — vi henter ikke fra maskinbruker-typer, men sletter heller ikke disse.

### Pattern-match-resultat (fra `fs-admin-patterns`-skillen)

Ble invokert i denne kjøringen. Resultater:

- **ListPageLayout** — confidence 100 (alle primary + secondary signaler matchet). Bekreftet pattern for applikasjons-oversikten.
- **DetailPageLayout** — confidence ~90+ (details for + singular Applikasjon, edit, breadcrumb, tabs). Bekreftet pattern for detalj-siden.
- **Cross-pattern `list-page-layout--detail-page-layout`** — er den dokumenterte master-detail-flowen. Referanse-implementasjon: `EmnerOverview` ↔ `EmneDetails`.

## Key Findings

- **Greenfield, men ikke tom**: branchen er fra `main`, så **alle layout-, hook-, list-, filter-, input-konvensjoner er allerede etablert og dokumentert i `src/common/`**. Implementasjonen er rent en *anvendelse* av eksisterende mønstre.
- **MaskinBruker-koden røres ikke** (beslutning 2026-06-01). Den fortsetter å eksistere parallelt; nye applikasjons-features bygges som rene tilbygninger. `MigrerPassord` og `DataTilganger`/`ApiTilganger` brukes som *referanse for mønstre*, ikke som kilde for kopiert kode.
- **GraphQL-skjemaet eksisterer ikke ennå på forbrukersiden**: ingen `Applikasjon`-types i nåværende `schema.graphql`. Hele spec-skjemaet er backend-arbeid. Implementasjon avhenger av at backend leverer.
- **Deprecated import-stier** og **deprecated `DetailPageLayout.error`-prop** finnes i eksisterende reference-impls. Greenfield-koden må bruke nye stier (`@/common/...`) og nye mønstre (`LayoutMessage` i stedet for `error`-prop).
- **Filter-impl deles ikke mellom oversikten og detalj-tab**: per spec-beslutning. To separate `useGetApplikasjonerState` og `useGetApplikasjonTilgangerState`-hooks, hver med sin egen filter-form.
- **Master-detail URL-state-bevaring er innebygd**: bruk `useDataListState` + `NavigationList href`. Apollo-cache deler `Applikasjon:<id>` mellom oversikt og detalj automatisk hvis begge spørringer henter `id` + `__typename`.
- **MaskinBruker har en separat URL-route under `/tilgangsstyring/maskinbrukere/`** som forblir uberørt. Ny `/tilgangsstyring/applikasjoner/`-route legges til ved siden av; begge eksisterer parallelt.

## Technical Constraints

### Fra CLAUDE.md / fs-admin-konvensjoner

- **Hver komponent MÅ ha `ComponentName.a11y.test.tsx`** (a11y-test). Coverage-terskler i jest: 60% branches/functions/lines, 90% statements.
- **i18n via next-intl**, norsk (nb). Aldri hardkodete strenger i UI (heller ikke `headingScreenReaderOnly`-flagged). Alle `headingText`-props på ListPage*/DetailPage* skal være `t(...)`. Kommando: `/externalize-i18n <fil>`.
- **GraphQL via Apollo Client 4** med `gql(...)` fra `@/__generated__/gql.ts`. Schema-first; codegen kjøres ved `npm run compile`.
- **Mutasjons-feilenveloppe** er union-pattern, ikke top-level `errors`-felt. Spec-skjemaet følger dette.
- **CSS Modules** (`*.module.css`) + Sikt Design System (`@sikt/sds-*`). Ingen generiske UI-libs.
- **Husky + lint-staged pre-commit**: ESLint --fix + stylelint --fix + Prettier --write.
- **Conventional commits**, branch-naming `<user>/<issue>-<type>-<description>`.

### Framework-spesifikt

- **Next.js 16 App Router** — alle pages er `'use client'` i feature-komponentene; layout/routing-filer er typisk server. Webpack-bundler (ikke Turbopack). `next typegen` kjører i postinstall.
- **NextAuth.js / Feide OIDC** — session/auth-token håndteres via `globalUserContext`. Mutasjoner kan trigge token-refresh; eksisterende ErrorLink + `authErrorInterceptor` håndterer dette.
- **React 19** — alle nye komponenter må bruke moderne React-mønstre (Suspense for async, server components der mulig).

### Performance / a11y

- Tilgangs-listen kan være lang (>50 rader); `Last inn flere`-paginering må bruke `loadedCount` / `totalCount` / `hasNextPage` slik `fs-admin-list-results`-skillen krever.
- Modal-fokus-håndtering (focus trap, ESC-lukking) ivaretas av Sikt Design System Dialog. Verifiseres i a11y-tester.
- Sketch-detaljer fra spec-en (passord skjult, kopier-knapp, kan ikke hentes opp igjen) krever spesielt fokus på security-UX-mønsteret i `MigrerPassord`.

## Dependencies

### Internal

- **`src/common/components/layouts/`** — `ListPageLayout`, `DetailPageLayout`, `LayoutMessage`. Brukes uten endring.
- **`src/common/hooks/`** — `useDataListState`, `useDataListQuery`, `useDebounce`, `useTranslated`, `useGetMutationErrors`. Brukes uten endring.
- **`src/common/components/lists/`** — `NavigationList`, `ActionList` (og evt. `ExpandList`). Brukes uten endring.
- **`src/common/components/`** — `FilterWrapper`, `FilterReset`, `FilterChip`, `Flex`, `Skeleton`, `BreakpointRender`. Brukes uten endring.
- **`src/lib/auth/globalUserContext`** — `useMineLaresteder`. **Kan trenge utvidelse** for å eksponere applikasjonsadministrator-rolle-felt (super-admin vs org-admin). Sjekkes i `bat-plan`.
- **`src/lib/apollo/`** — Apollo Client setup, ingen endringer forventet.
- **`src/messages/nb/`** — nye oversettelser legges til under `domains.support` eller en ny `domains.tilgangsstyring`-prefiks (TBD i `bat-plan`).
- **`src/app/tilgangsstyring/`** — ny route `applikasjoner/` (list) og `applikasjoner/[id]/` (detail). MaskinBruker-routen slettes parallelt.

### External

- **`@sikt/sds-*`** (Design System) — `Button`, `TextInput`, `Select`, `TextArea`, `Dialog`. Ingen nye eksterne biblioteker.
- **`nuqs`** — brukes via `useDataListState`. Allerede installert.
- **`@apollo/client`** v4 — for GraphQL. Allerede installert.

### Cross-agent (kandidater — `bat-plan` filer hand-offs)

Disse identifiserer arbeid som hører på andre registrerte agenter. Fra spec-en (`spec-applikasjoner.md` → "Cross-agent-avhengigheter") + analyse av eksisterende skjema:

1. **Backend-agent: Hele applikasjons-GraphQL-API-et.** Spec-skjemaet (types, queries, mutations, union errors) finnes ikke i nåværende `schema.graphql`. Backend må implementere:
   - Types: `Applikasjon`, `ApplikasjonTilgang`, `Identitetsleverandor`-enum, `ApplikasjonStatus`-enum, `Miljo`, `Tilknytning`-enum.
   - Queries: `applikasjoner`, `applikasjon`, `verifiserApplikasjonEksternId`, `tildelbareTilgangskoder`, `mineApplikasjonsAdminOrganisasjoner`.
   - Mutations: `opprettApplikasjon`, `oppdaterApplikasjonDetaljer`, `genererNyttApplikasjonPassord`, `deaktiverApplikasjon`, `reaktiverApplikasjon`, `tildelApplikasjonTilganger`, `fjernApplikasjonTilganger`.
   - Union-feilenveloppe-types: `ApplikasjonEksternIdIkkeFunnet`, `ApplikasjonEksternIdAlleredeRegistrert`, `ApplikasjonVisningsnavnAlleredeIBruk`, `ApplikasjonNavnObligatorisk`, `ApplikasjonOpprettelseAvvist`, `MutasjonAvvist`.
   - **Hvorfor blokkerer**: forbruker kan ikke generere typed `gql(...)` mot ikke-eksisterende skjema. Mock-API er en mellomløsning.

2. **Backend-agent: idP-verifisering (Feide + Maskinporten klienter).** `verifiserApplikasjonEksternId`-query og serverside-validering i `opprettApplikasjon` krever Feide/Dataporten-API-klient + Maskinporten-API-klient (med service-account credentials). Forbruker har ingen vei dit fra browser.
   - **Hvorfor blokkerer**: BRU-APP-API-009 (opprette_applikasjon) krever at backend pulls navn fra idP.

3. ~~**Backend-agent: Sletting av maskinbruker-skjema.**~~ **Frafalt (2026-06-01)** — MaskinBruker beholdes uberørt på både forbruker- og skjema-side. De to løsningene eksisterer parallelt.

4. **Backend-agent: Rettighet-baserte felter.** `Applikasjon.kanRedigeres`, `kanByttePassord`, `kanDeaktiveres`, `kanTildeleTilganger`, `kanFjerneTilganger`; `ApplikasjonTilgang.kanFjernes`. Server må beregne disse basert på innlogget brukers rolle.
   - **Hvorfor blokkerer**: spec-en bruker disse til å skjule/disable UI-handlinger. Uten dem må forbruker enten lage egen rolle-logikk (DRY-brudd) eller forsøke handlinger og fange 403 (dårlig UX).

5. **Backend-agent: `tildelbareTilgangskoder`-query med `alleredeTildelt`-flag.** Returnerer kun tilgangskoder brukeren har rettighet til å tildele i valgt org+miljø, med flag som merker allerede-tildelte som ikke-valgbare. Krever at tilgangs-rettighetsmodellen er ferdig på backend.

6. **Backend-agent: `mineApplikasjonsAdminOrganisasjoner`-query.** Brukerens administrerte organisasjoner — for org-Select-en i opprett-modalen og evt. tildel/fjern-modalene. *Kan allerede finnes* under et annet navn (f.eks. `useMineLaresteder`-eksisterende felt); verifiseres mot faktisk skjema.

## Requirements Impact

Mapper hver krav-ID til codebase-status. Spec-doc-en eier den autoritative beskrivelsen av *hva* hver krav-ID innebærer.

| Krav-ID | Krav-tittel | Status mot codebase | Hvor det implementeres |
|---|---|---|---|
| BRU-APP-API-001 | Listevisning og søk i applikasjoner | Pattern fullt dekket av `ListPageLayout` + `useDataListState` + `NavigationList`. Skjema ikke i `schema.graphql` ennå. | `src/app/tilgangsstyring/applikasjoner/page.tsx` + `src/domains/<tbd>/features/ApplikasjonerOverview/` |
| BRU-APP-API-002 | Se detaljer for applikasjon | Pattern dekket av `DetailPageLayout` + `DetailPageTopBar` + `DetailPageTabbedContent`. | `src/app/tilgangsstyring/applikasjoner/[id]/page.tsx` + `.../features/ApplikasjonDetails/` (Detaljer-tab) |
| BRU-APP-API-003 | Vise tilganger for applikasjon | In-tab filter+list — pattern dekket av `useDataListState` + `ActionList` (eller `ExpandList` for arvet-opphav-utvidning). Skjema ikke i `schema.graphql`. **Arvet-tag-rendering**: ny `ListItemStartCell`-bruk med tag ved siden av miljø-tag. | `.../features/ApplikasjonDetails/components/ApplikasjonTilganger/` |
| BRU-APP-API-004 | Passordbytte for applikasjon | UI-mønster direkte kopierbart fra `MigrerPassord/MigrerPassord.tsx` + `MigrerPassordDialog.tsx`. Mutasjon `genererNyttApplikasjonPassord` ikke i skjemaet ennå. | `.../features/ApplikasjonDetails/components/ApplikasjonPassord/` |
| BRU-APP-API-006 | Redigere detaljer for applikasjon | View/edit-toggle på `Detaljer`-tab; mønster eksisterer i andre detalj-features (`PersonDetails`/`EmneDetails`). Mutasjon `oppdaterApplikasjonDetaljer` ikke i skjemaet ennå. | Samme tab som -002 (Detaljer-panelet) |
| BRU-APP-API-007 | Tildele tilgang | Modal-pattern; org-felt **disabled** når admin har én org (spec-beslutning). Mutasjon `tildelApplikasjonTilganger` ikke i skjemaet ennå. | `.../features/ApplikasjonDetails/components/TildelTilgangModal/` |
| BRU-APP-API-008 | Fjerne tilgang | Modal-pattern; samme layout som tildel-modal, rød destruktiv-knapp. Mutasjon `fjernApplikasjonTilganger` ikke i skjemaet ennå. | `.../features/ApplikasjonDetails/components/FjernTilgangModal/` |
| BRU-APP-API-009 | Opprette applikasjon | Modal launched fra oversikt-`ListPageActionbar`. Krever idP-verifisering-query. Mutasjon `opprettApplikasjon` ikke i skjemaet ennå. | `.../features/ApplikasjonerOverview/components/OpprettApplikasjonModal/` |
| BRU-APP-API-010 | Deaktivere applikasjon (inkl. reaktivering) | To bekreftelses-modaler (deaktiver / reaktiver). Mutasjoner `deaktiverApplikasjon`, `reaktiverApplikasjon` ikke i skjemaet ennå. | `.../features/ApplikasjonDetails/components/DeaktiverApplikasjonModal/` + `.../ReaktiverApplikasjonModal/` |

**Requirements addressed by current code:** *none directly* — dette er greenfield-tilbygging. Men *patterns* er fullt på plass for alle 9.

**Requirements at risk:**
- **BRU-APP-API-009** (Opprette applikasjon) — krever idP-verifisering serverside som per nåværende status ikke finnes. Backend-cross-agent-blokk.
- **BRU-APP-API-001 felter på rad** — spec-en lister `Navn`, `Beskrivelse`, `Miljøer`, `Organisasjon`, `Antall tilganger`, `Status`. Skissen viser disse i blanding av rad-celler og tags; eksakt cell-layout bekreftes i `bat-plan` mot `fs-admin-list-results`-konvensjonen for kolonnebredder.
- **Arvet tilgang-merking** (BRU-APP-API-003) — krever ny tag-komponent for "Arvet"-status pluss interaksjon for å vise opphav. Konsept låst i spec; eksakt komponent (popover vs ExpandList vs inline) avgjøres i `bat-plan`.

**Missing requirements discovered:** ingen — spec-en er dekkende. Men spec-en har ikke en **placement-beslutning for "Opprett applikasjon"-knappen i `ListPageActionbar`** ut over at skissen viser den øverst til høyre. Antas standard fs-admin-actionbar-pattern.

## Krav-input referanse

- **Spec-dokument:** [`spec-applikasjoner.md`](spec-applikasjoner.md)
- **Krav-input-manifest:** [`krav-input/manifest.md`](krav-input/manifest.md)
- **Krav-branch & SHA:** `sikt-no/fs` @ `fruitbat` på SHA `40f04cb39b95ba833ea25f5c4dbee54d090b691b` (pinned). 9 `.feature`-filer + 2 `systemkrav.md` i scope. Skisser: 8 PNG-er kopiert til `krav-input/sketches/`, alle dybde-validert mot scenario-tekst.

## Open Questions

- [x] **Domain-folder for de nye features.** Skal `ApplikasjonerOverview` + `ApplikasjonDetails` legges under `src/domains/support/features/` (samme domene som MaskinBruker bor i nå) eller under en ny `src/domains/tilgangsstyring/features/` (matcher app-route-path-en `/tilgangsstyring/...`)? Påvirker også oversettelses-prefiksen i `src/messages/nb/`.
  - **Beslutning (2026-06-01):** Ny domain-folder `src/domains/tilgangsstyring/`. Matcher URL-path-en `/tilgangsstyring/applikasjoner`. Vil sannsynligvis vokse med flere access-management-features senere (roller, organisasjoner). Oversettelses-prefiks: `domains.tilgangsstyring.*` i `src/messages/nb/`. MaskinBruker (som flyttes/slettes) blir liggende i `support`-domain inntil fjerning, så domain-grensen reflekterer "ny applikasjonshåndtering" vs "legacy support-features".
- [x] **Skal Apollo-cache-prefetching brukes på listevisning?** Cross-pattern-doc-en nevner det som opsjon: list-query kan inkludere detail-felter slik at detalj-siden vises umiddelbart fra cache. Verdt det for Applikasjon, eller hold listen lett? Avhenger av forventet skjema-størrelse.
  - **Beslutning (2026-06-01):** Nei — hold listen lett. List-query henter kun de 7 feltene som vises på rad + `id` + `__typename`. Detail-query gjør sin egen roundtrip. Apollo cacher fortsatt `Applikasjon:<id>` på de feltene som overlapper, så detalj-siden viser partielt fra cache umiddelbart og fyller inn resten i bakgrunnen — uten å belaste list-payloaden.
- [x] **`useMineLaresteder`-utvidelse for applikasjonsadministrator-rolle.** Trenger forbruker-siden å vite om innlogget bruker er `super-applikasjonsadministrator`, `applikasjonsadministrator` for hvilke orger, eller ingen av delene? Det meste kan løses via rettighet-felt på `Applikasjon` (spec-skjema), men noen UI-valg (vis "Opprett"-knapp, vis ListPageActionbar-elementer i det hele tatt) krever vet-jeg-noe-i-det-hele-tatt-svar. Sjekk hva `useMineLaresteder` returnerer i dag.
  - **Beslutning (2026-06-01):** `useMineLaresteder` (i `src/common/lib/auth/globalUserContext.tsx:72`) returnerer `MeMetaInformationQuery.megVedLarested` — utdannings-institusjoner, ikke applikasjon-admin-roller. La den være urørt. Backend eksponerer per-entity-rettigheter på `Applikasjon`-typen (`kanRedigeres`, `kanByttePassord`, `kanDeaktiveres`, `kanTildeleTilganger`, `kanFjerneTilganger`) og på `ApplikasjonTilgang.kanFjernes` per spec-skjema. For toppnivå-spørsmål ("vis Opprett-knappen i det hele tatt?") brukes `mineApplikasjonsAdminOrganisasjoner`-query (allerede i spec-skjemaet) — hvis listen er tom, vis ikke "Opprett". Cross-agent-avhengighet på backend, men ingen forbruker-side-hook-utvidelse er nødvendig.
- [x] **`MigrerPassord`-kopiering kontra wholesale-kopi.** Spec sier bruk det som inspirasjon for BRU-APP-API-004 — er det best å (a) kopier filene 1:1 til ny applikasjons-feature og endre import-stier + mutasjoner, eller (b) ekstrahere den generelle dialogen til `src/common/components/` slik at både legacy MaskinBruker (mens den fortsatt eksisterer) og ny Applikasjon bruker samme komponent? Sannsynligvis (a) siden MaskinBruker uansett slettes.
  - **Beslutning (2026-06-01):** Lag en helt ny komponent for applikasjon (`ApplikasjonPassord/` i ny feature-folder). Bruk `MigrerPassord.tsx` kun som **inspirasjon for mønsteret** (skjult passord, kopier-knapp, dialog-lukking) — ikke kopier kode. La MaskinBruker-versjonen være i fred fram til den slettes som del av wholesale-MaskinBruker-fjerning. Holder de to features fullt uavhengige; ingen midlertidig delt-komponent-koordinering.
- [x] **Endringslogg for fjerning av MaskinBruker.** Trenger vi en `.changeset/`-fil eller annen migrasjons-notat? Det finnes allerede `.changeset/stale-numbers-wink.md` (untracked); kan være en kandidat eller en irrelevant tidligere endring.
  - **Beslutning (2026-06-01):** MaskinBruker-koden skal **ikke** fjernes som del av dette arbeidet. Spørsmålet er irrelevant. Eksisterende `.changeset/stale-numbers-wink.md` er om Opptak/utdanningstilbud (urelatert). Changesets for applikasjons-arbeidet opprettes av `bat-plan`/`bat-execute` per task når koden faktisk lander.
- [x] **Mock-API som overgang.** Skal vi bruke `fs-admin-mock-api-with-data`-skillen til å scaffolde MSW-handlers + fixture-data mens vi venter på at backend leverer skjemaet? Det vil la forbruker-siden bygges og testes parallelt med backend-arbeidet, men koster teardown senere.
  - **Beslutning (2026-06-01):** Ja — scaffold mock-API nå. `fs-admin-mock-api-with-data`-skillen er optimalisert for cheap teardown når ekte API lander. API-skjema-seksjonen i `spec-applikasjoner.md` brukes som input. `bat-plan` planlegger eksakt timing (typisk tidlig i implementasjons-rekkefølgen slik at UI-arbeidet kan begynne mot mock).
