# Analysis: Selvbetjent tilgangsstyring for applikasjoner (Initiativ #31)

**Initiativ:** [`sikt-no/fs#31`](https://github.com/sikt-no/fs/issues/31) — Grunnleggende selvbetjent tilgangsstyring for applikasjoner via FS Admin
**Scope:** Hele initiativet — Iter 2 (#434), Iter 3 (#435), Iter 4 (Endringslogg, @draft) og Nice-to-have (#437)
**Krav-branch:** `fruitbat` i `sikt-no/fs`
**Working branch:** `FSADMIN-pattern-skills` (fs-admin)
**Tidligere analyser:** To analyser fra 2026-05-12 finnes i coord-repoet (`agents/fs-admin/2026-05-12-applikasjoner-iter2-3/` og `agents/fs-admin/2026-05-12-applikasjoner-tilgangsstyring/`). Begge beskriver et `/tilgangsstyring/maskinbrukere/*`-rute-tre som **ikke finnes** på den nåværende working-branchen — de er sannsynligvis skrevet på en annen branch (`OPPF-3518-...`/`TIL-1-...`/`TIL-9-...` finnes på origin). Denne analysen baserer seg på den faktiske current state.

## Problem Statement

Applikasjonsadministratorer ved læresteder og hos Sikt mangler i dag en effektiv, selvbetjent måte å forvalte applikasjoner (tidligere "API-brukere") som har tilgang til FS-data. Dagens FS Admin har en MSW-mocked `/applications`-feature med kun listevisning og en svært enkel informasjons-detalj — den dekker en brøkdel av kravene og bruker engelsk terminologi som ikke matcher domeneterminologien i kravspecene.

Initiativet leveres som **fire iterasjoner** + nice-to-have. Krav-arbeidet er i sluttfasen — alle ikke-`@draft` features er `@planned` på `fruitbat`. Issue #31 sier eksplisitt:

- *"Vi lager en ny løsning tilgangsstyring av applikasjoner, vi bygger ikke i videre på dagens POC for visning av maskinbruker i FS Admin."*
- *"Dagens løsning for maskinbruker i FS Admin er ikke innført og skal fjernes."*
- *"Vi skal lage nye graphql spørringer for applikasjon. Vi skal ikke gjenbruke dagens graphql spørringer for maskinbruker."*

Backend-leveransene er sporet i [`sikt-no/fs#455`](https://github.com/sikt-no/fs/issues/455) (label `agent:backend`) — det issuet dekker Iter 2 + 3 og lenker til en tidligere analyse på `agents/fs-admin/analyses/2026-05-02-supergraf-applikasjon-administrasjon-iter2-3.md` (i coord-repoets fruitbat-branch).

## Current State

### `FSADMIN-pattern-skills`-branchen — det som faktisk finnes

| Område | Filer / state |
|---|---|
| **Live applications-rute** | `src/app/applications/page.tsx`, `src/app/applications/layout.tsx`, `src/app/applications/[id]/page.tsx` — bruker `ApplicationOverview`/`ApplicationDetails` |
| **ApplicationOverview** | `src/domains/support/features/ApplicationOverview/ApplicationOverview.tsx` — `ListPageLayout` med `ListPageSidebar` (kun navn- og status-filter), `ListPageContent` (`ApplicationResultList`). Hooks: `useGetApplications` (MSW-mocked via `gql` direkte fra `@apollo/client`, ikke fra codegen), `useGetApplicationState` (URL-synket via `useDataListState`). Komponenter: `ApplicationFilterName`, `ApplicationFilterStatus`, `ApplicationFilterReset`, `ApplicationOrderBy`, `ApplicationResultList`. |
| **ApplicationDetails** | `src/domains/support/features/ApplicationDetails/ApplicationDetails.tsx` — `DetailPageLayout` med kun `DetailPageTopBar` + `ApplicationInformation`. **Ingen tabs**, ingen tilganger, ingen action-knapper. Hook: `useGetApplication(id)`. |
| **Mock-API** | `src/mocks/handlers/applicationHandlers.ts` (MSW GraphQL for `GetApplications`, `GetApplication`), `src/mocks/data/mockApplications.ts` (150 deterministiske rader), `src/mocks/schema/application.graphql.md` (forventet schema for backend) |
| **Mock-schema** | `Application` med: `id`, `name`, `description`, `status` (ACTIVE/INACTIVE), `organizationCode`, `organizationName`, `createdAt`, `updatedAt`, `owner.{firstName,lastName}`. Query: `applicationsV2(filter: ApplicationFilterInput!, orderBy, first, after)` + `applicationById(id)`. **Engelsk type-system.** |
| **Apollo cache** | `src/common/lib/apollo/cacheConfig.ts` har `applicationsV2: nodesCursorPagination(['filter', 'orderBy'])` registrert |
| **Tilgangsstyring-landing** | `src/app/tilgangsstyring/page.tsx` → `src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.tsx`. Kortet "tilgangsstyring" peker p.t. til **`/applications`** (engelsk rute, ikke `/tilgangsstyring/applikasjoner`). Bruker i18n-nøkkelen `maskinbrukereLabel` (legacy navn). |
| **Maskinbruker-rute** | **Eksisterer ikke** under `src/app/tilgangsstyring/maskinbrukere/*`. Branches `BAT-23-...`, `OPPF-3518-...`, `TIL-1-...`, `TIL-9-...`, `TIL-34-...`, `TIL-39-...` på origin har sannsynligvis hatt det, men det er ikke merget inn på `FSADMIN-pattern-skills`. Tidligere analyser refererer til det som om det er live — det er feil for denne branchen. |
| **CommandPalette** | `src/domains/search/features/CommandPalette/hooks/useCommands.tsx` har en `maskinbruker`-kommando referert i strings — sjekk om den fortsatt peker noe sted gyldig |
| **Auto-memory** | `project_applications_feature.md` — beskriver det MSW-mockede `/applications`-feature-et og codegen-eksklusjonsmønsteret |

### Eksisterende byggeklosser i `src/common/`

| Byggekloss | Sti | Bruks-status |
|---|---|---|
| `ListPageLayout` (m/ `ListPageSidebar`, `ListPageContent`, `ListPageActionbar`) | `src/common/components/layouts/ListPageLayout/` | I bruk i `ApplicationOverview` |
| `DetailPageLayout` (m/ `DetailPageTopBar`, `DetailPageTabbedContent`, `DetailPageTabbedContentPanel`) | `src/common/components/layouts/DetailPageLayout/` | Brukt i forenklet form i `ApplicationDetails` |
| `BasicPageLayout` | `src/common/components/layouts/BasicPageLayout/` | I bruk i `TilgangsstyringIndex` |
| `NavigationList`, `ActionList`, `ExpandList` | `src/common/components/lists/` | NavigationList for klikkbare rader, ActionList for rader med handlinger |
| `FilterWrapper`, `FilterReset`, `FilterChip`, `OrderByButton` | `src/common/components/list-enhancers/` | I bruk |
| `useDataListState` (URL-synket via `nuqs`) | `src/common/hooks/useDataListState/` | I bruk i `useGetApplicationState` |
| `useDataListQuery` (Apollo `fetchMore`-paginering) | `src/common/hooks/useDataListQuery/` | I bruk i `useGetApplications` |
| `useFragmentUpdate`, `useGetMutationErrors`, `useMineLaresteder` | `src/common/hooks/`, `src/lib/auth/globalUserContext` | Org-scoping og mutation-feilhåndtering |
| `Dialog` (`@sikt/sds-dialog`) | Sikt SDS | Råmønster for tilpasset dialog-innhold |
| `ButtonWithConfirmation` | `src/common/components/buttons/ButtonWithConfirmation/` | Bekreftelsesdialog med fast tittel/knapper |

### Krav på `fruitbat` — entitetsmodell utledet fra .feature-filene

| Konsept | Beskrivelse | Krav-fil |
|---|---|---|
| **Applikasjon** | Erstatter "API-bruker"/"maskinbruker". Har: navn, beskrivelse, status (aktiv/deaktivert), organisasjon, identitetsleverandør, ekstern ID, intern ID, miljøer, ansvarlig, sporingsfelt (opprettet/endret av+tidspunkt). | alle |
| **Identitetsleverandør** (idP) | Enum: `Feide`, `Maskinporten`, `FS`. FS er utfaset for opprettelse, men eksisterende FS-applikasjoner består. | -009 |
| **Miljø** | Enum (sannsynlig: test/prod, men ikke spesifisert i kravet). En applikasjon kan ha tilganger i flere miljøer, og er "aktiv i" et miljø når den har en tilgang der. | -001, -003, -007 |
| **Tilgang** | Tildeling av en tilgangskode i et miljø for en organisasjon. Tilhører en applikasjon. | -003, -007, -008 |
| **Ansvarlig** | Feide-bruker eller (@could) feide-gruppe fra applikasjonens organisasjon. Arver passordbytte-rett. | -005 |
| **Roller** | `applikasjonsadministrator` (per org) og `super-applikasjonsadministrator` (på tvers). Brukere kan også være `ansvarlig` for enkeltapplikasjoner uten å være administrator. | -001, alle handlinger |
| **Passord** | Kun for FS-applikasjoner (basic auth). Systemgenerert, ett aktivt om gangen, vises éngangs etter generering. | -004 |

## Key Findings

1. **Initiativet er en ren erstatter** — ikke en utvidelse — av eksisterende `/applications`-feature. Norsk terminologi (`Applikasjon`/`applikasjoner` på rute, types, komponenter), nye GraphQL-operasjoner, mye bredere funksjonalitet. Eksisterende MSW-mock kan tjene som strukturelt skjelett, men ikke gjenbrukes som-er.

2. **`fruitbat` har 17 nye filer** i `krav/07.../applikasjoner/`: 13 .feature, 3 systemkrav.md, 1 oversikt.md. 10 features er `@planned @must` (Iter 2+3), 1 er `@must @draft` (endringslogg), 2 er `@could @draft` (NTH). Alle inneholder `# GitHub:`-markører som lenker til sub-issues #438–#454 (samt #448–#451 som per-krav-issues).

3. **Mønsterpasning er entydig for de to sentrale sidene** (jf. `bat-fs-admin-patterns`):
   - **`BRU-APP-API-001` (listevisning) → ListPageLayout** (confidence 100)
   - **`BRU-APP-API-002/-003/-004/-005/-006/-010` (detalj + handlinger) → DetailPageLayout** (confidence 100), med cross-pattern list↔detail
   - Reference: `EmnerOverview` ↔ `EmneDetails` i `src/domains/utdanning/features/` — gullstandard.
   - **Resten er sub-features inni de to sidene** (dialoger, bekreftelser, nested liste) — ikke separate pattern-treff. Pattern-katalogen er på sidenivå.

4. **Tilganger-tab (-003) er en nestet ListPageLayout-aktig liste i en DetailPageLayout-tab.** Krav: filter på miljø + tilgang (begrenset til applikasjonens egne data), sortering, paginering 50. Riktig komponent: **`ActionList` med checkbox-seleksjon** — IKKE `NavigationList` — fordi krav -008 trenger bulk-fjern fra denne lista. Nested `useDataListState`/`useDataListQuery` med egen nuqs-prefix (eller local state) er en åpen avveining — sjekk konvensjon i andre nested-liste-implementasjoner.

5. **Opprette applikasjon (-009)** matcher ingen pattern i katalogen — det er form/wizard. Følg de-facto-konvensjon `OpprettRundeModalButton` + `OpprettRundeForm` i `src/domains/plasstildeling/`. Ny capability i flyten: **idP-verifisering**. Brukeren taster ekstern ID; backend verifiserer mot Feide/Maskinporten før applikasjonen lagres. Visningsnavn hentes fra idP og må være globalt unikt. Tre avvisningsgrunner UI må håndtere: ID ikke funnet, ID allerede registrert, visningsnavn i bruk.

6. **Passordbytte (-004)** har sterke UX-krav:
   - Systemgenerert passord vises **én gang**, kan ikke hentes opp igjen
   - Skjult som default, vis/skjul-toggle, kopier-knapp
   - Mutation må returnere passord — sjelden mønster i fs-admin; vurder å lagre i lokal komponent-state og ikke i Apollo cache for å unngå utilsiktet persistering
   - Nytt passord erstatter gammelt umiddelbart
   - Kun for applikasjoner brukeren har rettighet til (og kun FS-applikasjoner per `K5` — `passordbytte` er ikke meningsfullt for Feide/Maskinporten-applikasjoner; bekreft med backend at mutation håndhever dette)

7. **Tildele tilgang (-007)** har spesielle krav som påvirker GraphQL:
   - Valglisten over tilganger må kun vise tilganger **brukeren har rettighet til å tildele** → ny server-query "tildelbare tilganger i miljø Y for org Z"
   - Allerede tildelte tilganger vises **gråtonet og ikke valgbar** (ikke skjult) — disabled-state
   - Organisasjon implisitt for én-org admin, eksplisitt valg for fler-org
   - Multi-tilgang i samme miljø i én operasjon

8. **Autorisasjon er gjennomgående** i alle features:
   - `applikasjonsadministrator` (per org): ser/administrerer applikasjoner i sine orgs + applikasjoner fra andre orgs med tilganger inn i mine orgs (K11, K12)
   - `super-applikasjonsadministrator`: ser/administrerer alt, inkl. orgs-løse
   - `ansvarlig`: ser applikasjonen i listen selv uten admin-rolle (`@could`: også via feide-gruppe)
   - Action-knapper på detaljsiden **kun synlige** når brukeren har rettighet for applikasjonens organisasjon
   - Server-side håndheving i alle queries og mutations

9. **Deaktivering (-010) er reversibel og tilgangs-bevarende.** Bekreftelsesdialog → ikke aktiv lenger → tilganger bevart men ikke aktive → reaktivering gjenoppretter. Bruker `ButtonWithConfirmation` direkte. Krever to mutations (`deaktiver`, `reaktiver`) eller én toggle.

10. **Endringslogg (-016, Iter 4)** er `@draft` med fire `@openquestion`-scenarios: hva logges, loggpost-innhold, retention, paginering/filtrering. Ikke planlegges teknisk før produkt avklarer. Pattern: ny tab i DetailPageLayout med ActionList eller enkel liste (avhenger av om filter/paginering kreves).

11. **Codegen-eksklusjon for mock-only hooks** — mønsteret er etablert i `codegen.ts` for `ApplicationOverview`/`ApplicationDetails` (jf. auto-memory). Hvis vi velger å fortsette med MSW-mocking under utvikling, må samme eksklusjon legges til for hver ny mock-hook.

12. **Inkonsistens mellom rute-prefix og terminologi** må adresseres:
    - Dagens `/applications` (engelsk) vs. krav-terminologi "applikasjoner"
    - `TilgangsstyringIndex` bruker `maskinbrukere`-i18n-nøkler men peker til `/applications`
    - Konvensjon i andre features: norsk på rute-nivå (`/utdanninger`, `/regelverk`, `/soknadsbehandling`)
    - Foreslått ny rute: **`/applikasjoner`** (eller `/tilgangsstyring/applikasjoner`, jf. eksisterende `/tilgangsstyring`-prefix). Avklar med UX/produkt.

## Pattern Analysis (fra `bat-fs-admin-patterns`)

### POSITIVE: ListPageLayout (confidence 100)

**For:** Applikasjoner-listesiden
**Krav:** `BRU-APP-API-001` (#438, #448, #449)

Byggeklosser, hooks, filstruktur og anti-patterns: se pattern-skill-rapporten. Hovedpunkter:

- `ListPageLayout` + `ListPageSidebar` + `ListPageContent` + `ListPageActionbar` ("Opprett applikasjon"-knapp)
- Sidebar-filtre: navn (fritekst), org (multi-select), status (aktiv/deaktivert), tilgang (multi-select, @could)
- `NavigationList` med `NavigationListItem.href` til detaljside (ikke `router.push`)
- `useDataListState` + `useDataListQuery` med 50 / last-flere
- Per krav skal hver rad vise: Navn, Beskrivelse, Miljøer, Ansvarlig, Organisasjon, Status
- Anti-pattern: gjenbruke `applicationsV2`-query, ha `eierOrganisasjonskode` i URL-state

**Reference:** `src/domains/utdanning/features/EmnerOverview/`

### POSITIVE: DetailPageLayout (confidence 100)

**For:** Applikasjon-detaljsiden
**Krav:** `-002`, `-003`, `-004`, `-005`, `-006`, `-010` (+ `-016` i Iter 4)

Hovedpunkter:

- `DetailPageLayout` + `DetailPageTopBar` (navn, status-tag, miljø-chips, ansvarlig, sporingsinfo) + `DetailPageTabbedContent`
- Topbar-actions: "Bytt passord", "Deaktiver"/"Reaktiver", "Rediger beskrivelse" — kun synlige ved rettighet
- Tabs: **Informasjon**, **Tilganger** (nested ActionList m/ filter/sort/paginering), **Endringslogg** (Iter 4)
- Egen `useGetApplikasjon(id)` for hovedentitet; nested state for Tilganger-tab
- Mutations: `useMutation` lokalt i action-komponentene; cache-oppdatering via `useFragmentUpdate` eller `refetchQueries`

**Reference:** `src/domains/utdanning/features/EmneDetails/`

### Cross-pattern: list↔detail

Aktiv. Følg `cross-patterns/list-page-layout--detail-page-layout.md`:
- URL er state-kilde — automatisk bevaring ved tilbake-navigering
- `NavigationListItem.href` (ikke `router.push`)
- Apollo cache deles — list-query og detail-query må returnere konsistent `id` + `__typename`
- Detail må fungere ved deep-link (uavhengig av at list ble lastet først)

### NEGATIVE: form/wizard, dialog/bekreftelse

Ingen sidemønstre. Behandle som sub-features inni de to sidene:

| Krav | Komponent-strategi |
|---|---|
| `-004` Passordbytte | `PassordbytteDialog` (`Dialog` fra `@sikt/sds-dialog`) — egen flyt: bekreft → vis passord skjult+toggle+kopier → lukk |
| `-005` Sett ansvarlig | `SettAnsvarligDialog` (`Dialog`) m/ søk-input + result-liste. Søk org-scopet. @could: feide-grupper. Vurder gjenbruk av søk-komponenter fra `src/domains/person/`. |
| `-006` Rediger beskrivelse | `RedigerBeskrivelseDialog` (`Dialog`) m/ `TextField` + lagre/avbryt. Anbefal dialog over inline-edit. |
| `-007` Tildele tilgang | `TildelTilgangDialog` (`Dialog`) m/ multi-step: velg miljø + org, multi-select tilganger med disabled-rader for allerede tildelte. |
| `-008` Fjerne tilgang (enkelt) | `ButtonWithConfirmation` direkte — melding inkluderer tilgang + miljø |
| `-008` Fjerne tilgang (bulk) | `BulkFjernTilgangDialog` (`Dialog`) — egen, fordi `ButtonWithConfirmation` ikke støtter custom innhold som lister tilgangene |
| `-009` Opprette | `OpprettApplikasjonModalButton` + `OpprettApplikasjonForm` — speil `OpprettRundeModalButton`-mønster. Form-trinn: idP → ekstern ID + verifisering → org-valg (hvis flere) → bekreft. **Vurder modal vs. egen rute med UX.** |
| `-010` Deaktiver/reaktiver | `ButtonWithConfirmation` direkte med kontekst-spesifikk melding |

## Technical Constraints

- **CLAUDE.md (root):** Next.js 16 App Router (Webpack), React 19, Apollo Client 4, NextAuth/Feide, next-intl, Sikt Design System (`@sikt/sds-*`).
- **CLAUDE.md (root):** *"GraphQL queries should be closely related to components they're used in. Do NOT reuse queries between different components, even if similar."* → applikasjoner-feature får sine egne queries lokalt i hooks. **Gjenbruk IKKE `applicationsV2`-queryen** (jf. eksplisitt instruks i issue #31).
- **CLAUDE.md (root):** Hver ny komponent MÅ ha `*.a11y.test.tsx`. Coverage-terskler: 60 % branches/functions/lines, 90 % statements.
- **CLAUDE.md (root):** Norsk er domenespråk, engelsk er kodespråk. Strenger eksternaliseres til `src/common/messages/nb/<domene>.json`. Vurder ny `applikasjoner.json` vs. eksisterende `support.json` (≥ 50 nøkler → egen fil).
- **CLAUDE.md (root):** Aldri commit hardkodede strenger. Bruk `useTranslations`. `externalize-i18n`-skill kan ekstrahere etterpå.
- **Routes:** Generert via `next typegen` i postinstall. Nye ruter (`/applikasjoner`, `/applikasjoner/[applikasjonId]`) genererer typer automatisk.
- **Apollo cache (`src/common/lib/apollo/cacheConfig.ts`):** `applicationsV2` allerede registrert. Nye typer (`Applikasjon`, `Tilgang`, etc.) trenger trolig `keyFields`-konfigurasjon når schema lander.
- **`bat-fs-admin-patterns` regel:** Aldri modifisér `src/common/`. Bruk byggeklossene som de er. Hvis et mønster mangler, spør utvikler.
- **Identitetsleverandører:** Feide og Maskinporten støttes for nye applikasjoner; FS er utfaset for opprettelse, men eksisterende FS-applikasjoner består og forvaltes (inkl. passordbytte). Mutation `byttPassord` skal kun være meningsfull for `autentiseringstype = FS`.
- **MSW-strategi:** Eksisterende `applications`-feature bruker MSW + codegen-eksklusjon. Hvis vi fortsetter med mocking under utvikling, må eksklusjons-mønsteret følges for hver ny mock-hook.

## Dependencies

### Internal (innenfor fs-admin)

- **Eksisterende `/applications`-feature** (`src/app/applications/*`, `src/domains/support/features/ApplicationOverview/`, `src/domains/support/features/ApplicationDetails/`, `src/mocks/handlers/applicationHandlers.ts`, `src/mocks/data/mockApplications.ts`, `src/mocks/schema/application.graphql.md`, `applicationsV2` i `cacheConfig.ts`): Skal fjernes eller migreres når den nye norske `/applikasjoner`-feature lander. Beslutning kreves om de lever parallelt midlertidig, eller om de fjernes som del av samme PR.
- **`TilgangsstyringIndex`** (`src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.tsx`): Lenken peker p.t. til `/applications` med i18n-nøkkel `maskinbrukereLabel`. Må oppdateres til ny rute + nye i18n-nøkler ("applikasjoner").
- **`CommandPalette`** (`src/domains/search/features/CommandPalette/hooks/useCommands.tsx`): Trenger ny "Gå til applikasjoner"-kommando (og evt. "Opprett applikasjon").
- **`Header/Menu`** (`src/features/Header/Menu/Menu.tsx`): Lenker til ny rute må oppdateres hvis applikasjoner skal være i hovedmenyen.
- **`FSAdminIndex`** (`src/features/FSAdminIndex/FSAdminIndex.tsx`): Sjekk om applikasjoner skal eksponeres som domene-kort.
- **i18n** (`src/common/messages/nb/support.json`, evt. ny `applikasjoner.json`): Nye nøkler for hele applikasjoner-feature. Eksisterende engelske strenger i `ApplicationOverview`/`ApplicationDetails` skal erstattes.
- **`codegen.ts`:** Hvis MSW-mocking fortsetter for nye hooks, må eksklusjoner legges til.
- **Apollo cache config:** Type-policies for nye typer når schema lander.
- **Generert routes** (`src/common/types/generated/routes.d.ts`): Auto-oppdateres ved `next typegen`.

### External

- **GraphQL API (SuperGrafen):** Nye operasjoner kreves — sporet i [`sikt-no/fs#455`](https://github.com/sikt-no/fs/issues/455). Hovedbehov:
  - **Queries:** `applikasjoner(filter, orderBy, first, after)` (connection), `applikasjon(id)`, evt. `applikasjonTilganger(...)` eller `tilganger`-relasjon med filter/orderBy/paginering, søk på feide-bruker/gruppe i org, "tildelbare tilganger i miljø Y for org Z" (`-007`).
  - **Mutations:** `opprettApplikasjon` (m/ idP-verifisering), `byttPassord` (returnerer passord, kun FS), `settAnsvarlig`/`fjernAnsvarlig`, `oppdaterBeskrivelse`, `tildelTilganger` (multi i ett miljø), `fjernTilganger` (multi), `deaktiverApplikasjon`, `reaktiverApplikasjon`.
  - **Type-modell:** `Applikasjon`, `Tilgang` (med miljø + tilgangskode), `Identitetsleverandør`-enum (FEIDE, MASKINPORTEN, FS), `Miljø`-enum, `Ansvarlig` (union FeideBruker | FeideGruppe?), `ApplikasjonStatus`-enum (AKTIV, DEAKTIVERT), sporingsfelter.
  - **Autorisasjon server-side** i alle queries og mutations basert på applikasjonsadministrator-roller per org. Synlighet via `ansvarlig`-relasjon i listevisning.
- **Identitetsleverandør-oppslag:** Backend verifiserer ekstern ID mot Feide/Maskinporten ved opprettelse — ny capability.
- **Roller/autorisasjon:** Server-side filtrering basert på "applikasjonsadministrator"-rolle. Sjekk om dette finnes i Feide-claims eller egen rettighetstjeneste.
- **Confluence-referanser** i krav-filene (rammeinnsikt 4401102853, discovery 4612784227) — bakgrunn for designvalg, ikke implementasjonskrav.

### Cross-agent

- **`backend`-agent (sikt-no/fs):** Issue [`#455`](https://github.com/sikt-no/fs/issues/455) finnes allerede, label `agent:backend`, lenker til prior backend-analyse i coord-repoet. Inneholder oversikt over manglende felter, mutations, filter-utvidelser, roller-modell for **Iter 2 + 3**. **Ingen ny hand-off trengs for Iter 2+3** — issuet dekker scope-en.
  - **Status:** Open. Backend lukker når schema er deployet til SuperGrafen og synlig via codegen i fs-admin.
  - **Mulig oppdatering av #455** hvis denne analysen identifiserer nye GraphQL-behov utover scope: "tildelbare tilganger i miljø Y" (`-007`), søk feide-bruker/gruppe i org (`-005`), idP-ID-verifisering (`-009`).
  - **Iter 4 + nice-to-have:** ikke dekket av #455. Egen hand-off for endringslogg-schema kan vurderes etter at `@openquestion`-scenarios er avklart.

## Requirements Impact

Det finnes ingen `docs/ACTIVE/requirements-*.md` — krav-grunnlaget er utelukkende `.feature`-filene fra `fruitbat` (lagret i `docs/ACTIVE/krav-input/fruitbat/`).

| Krav-ID | Iterasjon | GitHub | Status | Pattern |
|---|---|---|---|---|
| `BRU-APP-API-001` Listevisning og søk | 2 | #438, #448, #449 | @planned @must | ListPageLayout |
| `BRU-APP-API-002` Se detaljer | 2 | #439 | @planned @must | DetailPageLayout topbar + Informasjon-tab |
| `BRU-APP-API-003` Vise tilganger | 2 | #440 | @planned @must | Nested ActionList i DetailPageLayout-tab |
| `BRU-APP-API-004` Passordbytte | 2 | #441 | @planned @must | Custom Dialog |
| `BRU-APP-API-005` Administrere ansvarlig | 2 | #442 | @planned @must | Dialog m/ søk |
| `BRU-APP-API-006` Redigere beskrivelse | 2 | #443 | @planned @must | Dialog m/ TextField |
| `BRU-APP-API-007` Tildele tilgang | 3 | #444, #450 | @planned @must | Dialog m/ multi-select + disabled |
| `BRU-APP-API-008` Fjerne tilgang | 3 | #445, #451 | @planned @must | ButtonWithConfirmation (enkelt) + Dialog (bulk) |
| `BRU-APP-API-009` Opprette applikasjon | 3 | #446 | @planned @must | Modal m/ wizard (idP-verifisering) |
| `BRU-APP-API-010` Deaktivere applikasjon | 3 | #447 | @planned @must | ButtonWithConfirmation (deaktiver/reaktiver) |
| `BRU-APP-API-015` Sist brukt tidspunkt | NTH | #452 | @could @draft | Felt i Informasjon-tab |
| `BRU-APP-API-016` Endringslogg | 4 | #453 | @must @draft | Ny tab i DetailPageLayout |
| `BRU-APP-API-017` Masseadministrasjon | NTH | #454 | @could @draft | Ute av scope inntil videre |

**Krav i risikoområdet:**

- **`-009` Opprette** — ID-verifisering mot ekstern idP er ny capability i backend. Visningsnavn-unikhet på tvers av alle orgs krever ny global validering.
- **`-007` Tildele** — "tilganger jeg har rettighet til å tildele" krever ny autorisert query.
- **`-005` Ansvarlig** — søk på feide-bruker (`@could`: feide-gruppe) i applikasjonens org krever ny API.
- **`-004` Passordbytte** — mutation som returnerer passord er sjeldent mønster; må håndteres tydelig server-side (logging-utelukkelse) og klient-side (ikke persisteres i cache).
- **`-016` Endringslogg** — fire `@openquestion`-scenarios. Produkt må avklare før teknisk planning.

## Krav-input fra GitHub

- **Kilde:** initiativ-issue `#31` + sub-issues `#434`, `#435`, `#437` + leaf-issues `#438–#447, #448–#451, #452–#454` (alle med `# GitHub:`-markører i `.feature`-filene)
- **Linket PR(s):** ingen direkte på #31 eller sub-issues. Krav lever på `fruitbat`-branchen uten egen PR ennå.
- **Cross-reference:** [#455](https://github.com/sikt-no/fs/issues/455) (`agent:backend`) — schema-utvidelse for Iter 2+3.
- **Repo / ref:** `sikt-no/fs` @ `fruitbat`
- **Hentede `.feature`-filer:** 17 filer under [`docs/ACTIVE/krav-input/manifest.md`](krav-input/manifest.md)
- **Hentet:** 2026-05-13

## Open Questions

- [ ] **Rute-navn for ny feature:** `/applikasjoner` (flat, matcher dagens `/applications`-konvensjon) eller `/tilgangsstyring/applikasjoner` (under eksisterende `/tilgangsstyring`-prefix, matcher landings-konteksten)? Påvirker også `TilgangsstyringIndex`-kortet og CommandPalette.
- [ ] **Migreringsstrategi for `/applications`-feature:** Fjernes som del av samme PR som ny `/applikasjoner` lander, eller leve parallelt midlertidig? Inkluderer fjerning av `ApplicationOverview`/`ApplicationDetails`, MSW-handlers, mock-data, schema-md, `applicationsV2` i `cacheConfig.ts`, og codegen-eksklusjoner.
- [ ] **Plassering av "Opprett applikasjon"-flyt:** Modal fra listesiden (anbefalt — naturlig flyt for verifiser-steget, brukeren returnerer til lista) eller egen rute `/applikasjoner/ny` (bedre djup-lenking)? UX-beslutning.
- [ ] **Plassering av "Rediger beskrivelse"-flyt:** Dialog (anbefalt, pattern-skill har ingen inline-edit-pattern) eller inline edit i Informasjon-tab? UX-beslutning.
- [ ] **i18n-fil-struktur:** Holder vi applikasjons-strenger i eksisterende `support.json`, eller skiller vi ut til ny `applikasjoner.json`? Avhenger av forventet mengde (sannsynligvis ≥ 50 nøkler → egen fil).
- [ ] **Tilganger-tab GraphQL-form:** Skal `tilganger`-relasjonen på `Applikasjon` støtte filter+orderBy+connection direkte, eller egen top-level `applikasjonTilganger`-query? Avklares i `bat-graphql-dev`-fasen / sammen med backend via #455.
- [ ] **Nested state for Tilganger-tab:** URL-synket via egen nuqs-prefix, eller local state? Sjekk konvensjon i lignende nested-liste-implementasjoner (`MaskinBruker/ApiTilganger` historisk på origin, hvis tilgjengelig).
- [ ] **`@could` i `-001` (filter på tilgang) og `-005` (feide-gruppe som ansvarlig):** Inn i Iter 2-leveransen, eller utsettes? Påvirker GraphQL-scope og UI-implementasjon.
- [ ] **Apollo cache `typePolicies`:** Hvilke nye typer (`Applikasjon`, `Tilgang`, `Ansvarlig`, `FeideBruker`, `FeideGruppe`) trenger `keyFields`-konfigurasjon? Sjekkes når schema er klart.
- [ ] **Mocking under utvikling?** Backend-issue #455 er åpen. Hvis frontend-utvikling skal starte før schema er ferdig, fortsett MSW-mønsteret med codegen-eksklusjon. Trade-off: rask iterasjon nå vs. dobbel implementasjon hvis schema avviker fra mock-skissen. Bekreft med backend hvilke felt-navn/enums de tar.
- [ ] **Passordbytte cache-strategi:** Hvor lagres det returnerte passordet før dialogen lukkes? Anbefalt: lokal komponent-state (Zustand eller `useState`), ikke Apollo cache.
- [ ] **`byttPassord` kun for FS-applikasjoner:** Server-side håndhevelse er antatt. Bekreft med backend at mutation avviser ikke-FS-applikasjoner og UI skjuler knappen for dem.
- [ ] **Search-pattern for feide-bruker i org:** Finnes eksisterende søk-komponenter i `src/domains/person/` eller `src/common/` som kan brukes til ansvarlig-søk? Sjekkes når vi går til planning.
- [ ] **Endringslogg-krav:** Fire `@openquestion`-scenarios må avklares med produkt før Iter 4 kan planlegges teknisk.
- [ ] **Forhold til de tidligere analysene fra 2026-05-12:** Begge baserer seg på antagelser om en `/tilgangsstyring/maskinbrukere/*`-POC som ikke eksisterer på denne branchen. Skal de tidligere analysene markeres som "supersedert", eller beholdes som kontekst for hva som skjedde på andre branches?