# Analysis: Applikasjon-administrasjon (Iter 2 + Iter 3)

**Initiativ:** [`sikt-no/fs#31`](https://github.com/sikt-no/fs/issues/31) — Grunnleggende selvbetjent tilgangsstyring for applikasjoner via FS Admin
**Scope:** Iter 2 (#434) + Iter 3 (#435) — 10 `@planned` krav. Nice-to-have (#437) er bevisst utelatt etter bekreftelse fra bruker.
**Krav-branch:** `fruitbat` i `sikt-no/fs` (commit `aa3facc1`)
**Forgjenger:** Det finnes en bredere analyse fra 2026-05-12 i coord-repoet ([`agents/fs-admin/2026-05-12-applikasjoner-tilgangsstyring/analysis.md`](file:///Users/siktutv/Documents/code/fs/agents/fs-admin/2026-05-12-applikasjoner-tilgangsstyring/analysis.md)) som også dekker Iter 4 og Nice-to-have. Denne analysen er Iter 2+3-fokusert.

## Problem Statement

Applikasjonsadministratorer ved læresteder og hos Sikt mangler i dag en effektiv, selvbetjent måte å forvalte applikasjoner (tidligere "API-brukere") som har tilgang til FS-data. Dagens POC for *maskinbrukere* dekker delvis visningsbehovet for intern support, men:

- POC-en støtter ikke skriveoperasjoner (passordbytte, opprettelse, tildele/fjerne tilganger, deaktivering, sett ansvarlig, redigere beskrivelse).
- Synlighet/autorisasjon er ikke modellert per administrasjons-rolle (`applikasjonsadministrator` per organisasjon / `super-applikasjonsadministrator`).
- Terminologi er på vei vekk fra "maskinbruker"/"API-bruker" til **"applikasjon"**.
- Issue #31 sier eksplisitt at *"vi bygger ikke i videre på dagens POC for visning av maskinbruker i FS Admin"* og *"Vi skal ikke gjenbruke dagens graphql spørringer for maskinbruker"* — Iter 2+3 leveres som et **nytt feature-tre** under `/tilgangsstyring/applikasjoner/`.

Iter 2 leverer leseflyt og passordbytte for intern support; Iter 3 åpner for selvbetjent administrasjon (opprette, deaktivere, tildele/fjerne tilganger). Begge iterasjoner er avhengig av schema-utvidelser eid av backend (sporet i [`sikt-no/fs#455`](https://github.com/sikt-no/fs/issues/455), label `agent:backend`).

## Current State

### Eksisterende "POC" — Maskinbrukere

| Område | Fil(er) |
|---|---|
| **Routes** | `src/app/tilgangsstyring/page.tsx` (landing), `src/app/tilgangsstyring/maskinbrukere/page.tsx`, `src/app/tilgangsstyring/maskinbrukere/[maskinbrukerid]/page.tsx` (+ layouts) |
| **Listevisning** | `src/domains/support/features/Maskinbrukere/` — `Maskinbrukere.tsx` bruker `ListPageLayout` med `ListPageSidebar` (`MaskinbrukereFilter`), `ListPageContent` (`MaskinbrukereResultList`), `ListPageActionbar` med `NyTilgangButton`. Filter-state via `useGetMaskinbrukereState`. Eget OrderBy under `components/`. |
| **Detalj** | `src/domains/support/features/MaskinBruker/` — bruker `DetailPageLayout` med tabs: `MaskinbrukerInformation`, `ApiTilganger`, `DataTilganger`, `MigrerPassord`. Hooks: `useGetMaskinbruker`, 2 Zustand-stores for tilganger-filtre. |
| **Landing** | `src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.tsx` — bruker `BasicPageLayout` + `Surface`-kort. I dag kun ett kort: maskinbrukere. |
| **GraphQL** | `maskinbrukere` (liste), `maskinbruker(id)` (detalj). Definert inline i hooks. Ingen mutations. |
| **i18n** | `src/common/messages/nb/support.json` — alle maskinbruker-strenger her. |
| **CommandPalette** | `src/domains/search/features/CommandPalette/hooks/useCommands.tsx` (maskinbruker-kommando). |
| **Routes-typer** | `src/common/types/generated/routes.d.ts` (`TilgangsstyringMaskinbrukereHref`, `TilgangsstyringMaskinbrukereMaskinbrukeridHref`). Generert via `next typegen`. |
| **Apollo cache** | `src/common/lib/apollo/cacheConfig.ts` — endret på denne branchen. |

### Tidligere `applications`-feature

På denne branchen er en tidligere MSW-mocked `applications`-feature slettet (`src/app/applications/*`, `src/domains/support/features/ApplicationDetails/*`). Det er ingen funksjonelle rester — vi starter fra et tomt utgangspunkt for `/tilgangsstyring/applikasjoner/`.

Auto-memory `project_applications_feature.md` beskriver et codegen-eksklusjonsmønster for mock-only hooks fra denne fjernede feature-en. Det er ikke relevant for `applikasjoner` med mindre vi velger å mock-utvikle mens vi venter på schema fra backend — se "Open Questions".

### Eksisterende mønstre i `src/common/`

| Byggekloss | Sti |
|---|---|
| `ListPageLayout` (sidebar + content + actionbar) | `src/common/components/layouts/ListPageLayout/CLAUDE.md` |
| `DetailPageLayout` (med `DetailPageTopBar`, `DetailPageTabbedContent`, `DetailPageTabbedContentPanel`) | `src/common/components/layouts/DetailPageLayout/CLAUDE.md` |
| `BasicPageLayout` | `src/common/components/layouts/BasicPageLayout/CLAUDE.md` |
| `NavigationList`, `ActionList`, `ExpandList` | `src/common/components/lists/*/CLAUDE.md` |
| `FilterWrapper` (list-enhancer) | `src/common/components/list-enhancers/FilterWrapper/CLAUDE.md` |
| `useDataListState` (URL-synket filter/sort/paginering via `nuqs`) | `src/common/hooks/useDataListState/CLAUDE.md` |
| `useDataListQuery` (GraphQL paginering med Apollo `fetchMore`) | `src/common/hooks/useDataListQuery/CLAUDE.md` |
| `ButtonWithConfirmation` (bekreftelsesdialog med fast tittel/knapper) | `src/common/components/buttons/ButtonWithConfirmation/ButtonWithConfirmation.tsx` |
| `Dialog` (`@sikt/sds-dialog`) — rådialog | brukt fra `OpprettRundeModalButton`, `ParameterDialog`, `CommonFilterAsDialog`, `ListPageSidebar` |

### Reference-implementasjoner for nye flyter

| Flyt | Referanse |
|---|---|
| Liste m/ filter, sort, paginering | `src/domains/support/features/Maskinbrukere/` (struktur, **ikke** query/komponentgjenbruk). Pattern-skill anbefaler `EmnerOverview` som gullstandard. |
| Detalj m/ tabs | `src/domains/support/features/MaskinBruker/` (struktur, **ikke** query/komponentgjenbruk). Pattern-skill anbefaler `StudieprogramDetails`/`EmneDetails`. |
| Modal med form/wizard (opprettelse) | `src/domains/plasstildeling/features/OpprettRundeModalButton/` + `OpprettRundeForm/` |
| Modal for redigering | `src/domains/plasstildeling/features/RedigerRundeModal/` + `RedigerRundeForm/` |
| Bekreftelsesdialog | `ButtonWithConfirmation` direkte, eller `src/domains/plasstildeling/features/ParameterFeature/components/ParameterDialog/ParameterDialog.tsx` for større innhold |

## Key Findings

1. **Initiativet er en ren erstatter** av maskinbruker-POC-en, ikke en utvidelse. Iter 2+3 leveres på ny URL-prefix `/tilgangsstyring/applikasjoner/`, med **nye** GraphQL-operasjoner og komponenter. Migreringen/avviklingen av maskinbrukere-rutene er en separat beslutning.

2. **Domeneskifte i terminologi.** Krav-filene bruker konsekvent **"applikasjon"** (ikke "maskinbruker" eller "API-bruker"). Confluence-referansene K1–K19 mapper fra "API-bruker" → "applikasjon". Komponenter, ruter, GraphQL-typer, i18n-nøkler skal følge dette.

3. **Mønsterpasning er svært tydelig for kjerneflytene:**
   - **`-001` (listevisning) → `ListPageLayout`** med `useDataListState` + `useDataListQuery`. Krav matcher 1:1 med `EmnerOverview`/`Maskinbrukere`.
   - **`-002`, `-005`, `-006`, `-010` (detalj + handlinger) → `DetailPageLayout`** med tabbed content (Informasjon, Tilganger). Topbar-actions for "Bytt passord", "Deaktiver"/"Reaktiver", "Rediger beskrivelse".
   - **`-003` (tilganger-tab) → nestet liste** med `ActionList` (siden vi trenger checkbox-seleksjon for bulk-fjerning, jf. `-008`) + `FilterWrapper`. Krever filter+sort+paginering på `tilganger`-relasjonen til en applikasjon — schema-spørsmål til backend.
   - **`-004`, `-005`, `-007`, `-008`, `-009`, `-010` → Dialog/modal-mønstre**:
     - Bekreftelsesdialog (`-008`, `-010`) → `ButtonWithConfirmation` direkte.
     - Bekreftelse + lister innhold (`-008` bulk-fjern) → `Dialog` med custom innhold (følg `ParameterDialog`-mønster).
     - Passordbytte (`-004`) → eget dialog-mønster med skjult/vis toggle, kopier-knapp, éngangs-visning.
     - Opprette applikasjon (`-009`) → `Dialog` + flertrinns form (følg `OpprettRundeModalButton` + `OpprettRundeForm`).
     - Sett ansvarlig (`-005`) → `Dialog` med søk-input + result-liste.
     - Rediger beskrivelse (`-006`) → enklest som dialog med TextField (alternativt inline edit; pattern-skill har ingen formell inline-edit-pattern).

4. **Autorisasjons-modellen er gjennomgående.** Tre rolle-nivåer:
   - **`applikasjonsadministrator`** for én eller flere organisasjoner: ser/administrerer applikasjoner i sine orgs + applikasjoner fra andre orgs som har tilganger inn i sine orgs (K11, K12).
   - **`super-applikasjonsadministrator`**: ser/administrerer alle applikasjoner inkl. orgs-løse.
   - **`ansvarlig`** (registrert som ansvarlig for en applikasjon): ser applikasjonen i listen selv uten admin-rolle for orgen. `@could`: også via feide-gruppe-medlemskap.

   Dette må gjenspeiles både i GraphQL (server-side filtrering på `applikasjoner`-query og handling-mutations) og i UI (action-knapper kun synlige når brukeren har rettighet for applikasjonens organisasjon).

5. **Tildeling-flyt har spesielle krav** (`-007`):
   - Valglisten over tilganger må kun vise tilganger brukeren har rettighet til å tildele.
   - Allerede tildelte tilganger i valgt miljø vises **gråtonet og ikke-valgbar** i listen (ikke skjult).
   - Organisasjon er implisitt når admin har én org; eksplisitt valg når flere — valglisten begrenses til orgs brukeren administrerer.
   - Multi-tilgang i samme miljø skal kunne tildeles i én operasjon.

6. **Passordbytte (`-004`)** har sterke UX-krav:
   - Systemgenerert passord vist **én gang**, kan ikke hentes opp igjen etter dialog er lukket.
   - Default skjult med vis/skjul-toggle.
   - Kopier-til-utklippstavle-funksjonalitet.
   - Mutation må returnere passord (sjelden hos oss — vurder om dette skal være en spesial-extension med tydelig server-side håndtering).

7. **Opprette applikasjon (`-009`)** har ny capability-flyt — ID-verifisering mot idP:
   - Identitetsleverandør: kun **Feide** eller **Maskinporten**. FS er utfaset.
   - Brukeren taster inn ekstern ID; backend verifiserer den mot idP-en før applikasjon lagres.
   - Visningsnavn hentes fra idP og må være **globalt unikt** på tvers av alle organisasjoner.
   - Tre avvisningsgrunner som UI må håndtere:
     - ID finnes ikke hos idP
     - ID allerede registrert (med samme idP)
     - Visningsnavn allerede i bruk
   - Org velges hvis admin har flere; ellers implisitt.
   - **Beslutning som kreves:** modal fra listesiden eller egen rute `/tilgangsstyring/applikasjoner/ny`? Jeg foreslår modal fordi (a) verifiser-flyten passer naturlig i steg-form, (b) brukeren kommer tilbake til lista uten ekstra navigering. Sjekk med UX.

8. **Deaktivering (`-010`) er reversibel og tilgangs-bevarende.** Bekreftelsesdialog → ikke aktiv lenger → tilganger bevart men ikke aktive → reaktivering gjenoppretter. Bruker `ButtonWithConfirmation` direkte; krever to mutations (`deaktiverApplikasjon`, `reaktiverApplikasjon`) eller én med toggle.

9. **Tilganger-tab er nestet listevisning.** Krav-fila (`-003`) spesifiserer:
   - Filter på miljø (begrenset til miljøer applikasjonen har tilganger i)
   - Filter på tilgang (begrenset til tilganger applikasjonen er tildelt)
   - Sortering på miljø eller tilgangskode
   - Paginering med 50 + last-flere
   
   Dette er nestet `useDataListState`/`useDataListQuery`-bruk i en `DetailPageTabbedContentPanel`. Krever at backend støtter filter+orderBy+pagination på `tilganger`-relasjonen til `Applikasjon` (alternativ: egen top-level `applikasjonTilganger(applikasjonId, ...)`-query). Mest naturlig som relasjon — **hand-off-spørsmål til `bat-graphql-dev`**.

10. **`useDataListState`-state er URL-synket via `nuqs`** — master/detail-navigering bevarer filter-state automatisk. Ingen ekstra håndtering trengs ved tilbake-navigering fra detalj.

## Pattern Analysis (sammendrag fra `detect-implementation-pattern` + manuell synthesis)

`detect-implementation-pattern`-skillen dokumenterer p.t. kun **ListPageLayout** formelt. De andre mønstrene er detektert manuelt fra `src/common/`-CLAUDE.md-filer og eksisterende feature-implementasjoner.

### POSITIVE: ListPageLayout (konfidens ~98)

**For:** `/tilgangsstyring/applikasjoner` (rot-liste)
**Krav:** `BRU-APP-API-001` (#438, #448, #449)

| Aspekt | Detalj |
|---|---|
| **Layout** | `ListPageLayout` med `ListPageSidebar` (filtre), `ListPageContent` (resultatliste), `ListPageActionbar` ("Opprett applikasjon"-knapp) |
| **Filtre (sidebar)** | Org (multi-select), Status (aktiv/deaktivert), Tilgang (multi-select, `@could`), Søk (fritekst på navn) — alle gjennom `FilterWrapper` |
| **Sortering** | Navn (stigende default, kan toggles til synkende) — eget OrderBy-komponent som `Maskinbrukere`-strukturen |
| **Resultatliste** | `NavigationList` + `NavigationListItem` (klikkbare rader → detaljside). Per krav skal hvert innslag vise: Navn, Beskrivelse, Miljøer, Ansvarlig, Organisasjon, Status |
| **Paginering** | 50 + "last flere"-knapp, totalt antall + lastet antall vist. Standard `useDataListQuery`-flyt. |
| **State** | `useDataListState` (URL-synket filter/sort/first via `nuqs`) + egen `useGetApplikasjoner(filter, orderBy, first, after)`-hook som wrapper rundt query |
| **Filstruktur** | `src/domains/support/features/Applikasjoner/` (speil av `Maskinbrukere/`, men ingen kode-/query-gjenbruk) |

### POSITIVE: DetailPageLayout (konfidens ~98)

**For:** `/tilgangsstyring/applikasjoner/[applikasjonId]`
**Krav:** `-002`, `-003`, `-004`, `-005`, `-006`, `-010` (#439, #440, #441, #442, #443, #447)

| Aspekt | Detalj |
|---|---|
| **Layout** | `DetailPageLayout` med `DetailPageTopBar` (visningsnavn, status-chip, org, miljøer, ansvarlig) og `DetailPageTabbedContent` |
| **Topbar-handlinger** | "Bytt passord" (åpner `PassordbytteDialog`), "Deaktiver"/"Reaktiver" (via `ButtonWithConfirmation`), "Rediger beskrivelse" (åpner `RedigerBeskrivelseDialog`) — kun synlige når bruker har rettighet for org |
| **Tabs** | (1) Informasjon — navn, beskrivelse, identitetsleverandør, ekstern ID, intern ID, miljøer, ansvarlig (med "Endre ansvarlig"-knapp), sporingsinfo. (2) Tilganger — nestet liste, se under. |
| **Hooks** | `useGetApplikasjon(id)`. For mutations: bruk Apollo `useMutation` direkte i action-komponentene; oppdater cache via `useFragmentUpdate` eller `refetchQueries: [GetApplikasjon]`. |
| **Filstruktur** | `src/domains/support/features/Applikasjon/` (speil av `MaskinBruker/`, men ingen kode-/query-gjenbruk) |

### POSITIVE: Nested list i DetailPageLayout-tab (konfidens ~85)

**For:** Tilganger-tab på detaljsiden
**Krav:** `BRU-APP-API-003` (#440)

| Aspekt | Detalj |
|---|---|
| **Komponent** | `ActionList` (gir checkbox-seleksjon for bulk-fjern jf. `-008`) eller `NavigationList` hvis ingen bulk-handling. Krav fra `-008` tilsier `ActionList`. |
| **Filtre** | Miljø, Tilgang — begge `@filter` med dynamisk valgliste fra applikasjonens egne data |
| **Sortering** | Miljø eller tilgangskode |
| **Paginering** | 50 + "last flere" |
| **State** | Egen `useDataListState`-instans (kan ha egen `nuqs`-prefix eller bruke local state hvis URL-synking i en tab ikke ønskes — sjekk eksisterende konvensjon i `MaskinBruker/ApiTilganger`) |
| **Backend** | Krever at `tilganger`-relasjonen på `Applikasjon` støtter filter/orderBy/connection. **Hand-off til `bat-graphql-dev`.** |

### POSITIVE: Dialog-flyter

| Krav | Komponent-strategi |
|---|---|
| `-004` Passordbytte | Ny komponent `PassordbytteDialog` basert på `Dialog` fra `@sikt/sds-dialog`. Egen flyt: (1) bekreft generering, (2) vis passord (skjult default + toggle + kopier-knapp), (3) "Lukk" → passord ikke gjenfinnelig. |
| `-005` Sett ansvarlig | Ny `SettAnsvarligDialog` med søk-input + result-liste. Søk er org-begrenset. `@could`: feide-grupper med i samme søk. Bruk eksisterende søke-mønstre fra `src/domains/person/` hvis tilgjengelig. |
| `-006` Rediger beskrivelse | `RedigerBeskrivelseDialog` med `TextField` + lagre/avbryt. Alternativ: inline edit i Informasjon-tab. Anbefaling: dialog (enklere a11y, ingen ny inline-edit-pattern å etablere). |
| `-007` Tildele tilgang | `TildelTilgangDialog` — flertrinns: (1) velg miljø + org, (2) multi-select tilganger med disabled-rader for allerede tildelte. Backend må eksponere "tildelbare tilganger i miljø Y for org Z"-query. |
| `-008` Fjerne tilgang (enkelt) | `ButtonWithConfirmation` direkte — message inkluderer tilgang + miljø. |
| `-008` Fjerne tilgang (bulk) | Egen `BulkFjernTilgangDialog` (`ButtonWithConfirmation` har ikke custom innhold-støtte for å liste tilgangene som fjernes). Følg `ParameterDialog`-mønster. |
| `-009` Opprette | `OpprettApplikasjonModalButton` + `OpprettApplikasjonForm` — speil `OpprettRundeModalButton/`-mønsteret. Form-stadier: idP → ekstern ID + verifisering → org-valg (hvis flere) → bekreft. |
| `-010` Deaktiver/reaktiver | `ButtonWithConfirmation` direkte med kontekst-spesifikk message. |

### NEGATIVE: Form/wizard pattern

`detect-implementation-pattern` har ingen form/wizard-pattern formelt. Vi følger `OpprettRundeModalButton`+`OpprettRundeForm`-konvensjonen fra `plasstildeling`-domenet som de facto-standard. Verifiser med UX om opprette-flyten skal være modal eller egen rute før implementasjon.

### Cross-pattern: List ↔ Detail

`useDataListState` med `nuqs` gjør URL-en til state-kilden — ingen ekstra håndtering trengs ved tilbake-navigering fra detaljside.

## Technical Constraints

- **CLAUDE.md (root):** Next.js 16 App Router (Webpack), React 19, Apollo Client 4, NextAuth/Feide, next-intl, Sikt Design System (`@sikt/sds-*`).
- **CLAUDE.md (root):** *"GraphQL queries should be closely related to components they're used in. Do NOT reuse queries between different components, even if similar."* → applikasjoner-feature får sine egne queries lokalt i hooks, separat fra maskinbruker.
- **CLAUDE.md (root):** Hver ny komponent MÅ ha `*.a11y.test.tsx`. Coverage-terskler: 60 % branches/functions/lines, 90 % statements.
- **CLAUDE.md (root):** Norsk er domenespråk, engelsk er kodespråk. Strenger eksternaliseres til `src/common/messages/nb/support.json` (jf. eksisterende støtte-strenger). Vurder ny `applikasjoner.json` hvis volumet blir stort (≥ 50 nøkler) — bør avklares før implementasjon.
- **CLAUDE.md (root):** Aldri commit hardkodede strenger. Bruk `useTranslations` fra `next-intl`. `externalize-i18n`-skill kan ekstrahere etterpå hvis nødvendig.
- **Routes:** Generert via `next typegen` i postinstall. Nye ruter (`/tilgangsstyring/applikasjoner`, `/tilgangsstyring/applikasjoner/[applikasjonId]`) genererer typer automatisk.
- **Apollo cache (`src/common/lib/apollo/cacheConfig.ts`):** Modifisert på branchen — sjekk om `Applikasjon`/`Tilgang`-typer trenger eksplisitt `keyFields` (typisk `id` eller `internId`).
- **Apollo cache:** Mutations som endrer applikasjonens state må enten oppdatere cache via `useFragmentUpdate` eller `refetchQueries`. Passordbytte returnerer passord men endrer ingen synlige felter (kanskje `sistEndret`).
- **Pattern-skill PATTERNS.md:** Aldri modifisér `src/common/`. Bruk byggeklossene som de er. Hvis et mønster mangler, spør utvikler — ikke etabler nytt mønster selv.
- **Identitetsleverandører:** Feide og Maskinporten støttes for nye applikasjoner; FS er utfaset for opprettelse, men eksisterende FS-applikasjoner består og forvaltes (inkl. passordbytte).

## Dependencies

### Internal (innenfor fs-admin)

- **Maskinbruker-POC** (`src/domains/support/features/Maskinbrukere/` og `MaskinBruker/`, samt `/tilgangsstyring/maskinbrukere/*`-ruter): Avvikles/migreres. Beslutning kreves om de lever parallelt, redirectes, eller fjernes. **Foreslåtte alternativer:** (a) la dem leve parallelt til Iter 4; (b) fjern dem når Iter 2 lander; (c) redirect `/tilgangsstyring/maskinbrukere/[id]` → `/tilgangsstyring/applikasjoner/[id]` når data er felles. Påvirker også CommandPalette og TilgangsstyringIndex.
- **TilgangsstyringIndex** (`src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.tsx`): Må få nytt kort/lenke til `/tilgangsstyring/applikasjoner`. Trolig erstatter maskinbruker-kortet, eller komplementerer det inntil POC-en avvikles.
- **CommandPalette** (`src/domains/search/features/CommandPalette/hooks/useCommands.tsx`): Ny kommando "Gå til applikasjoner" (og kanskje "Opprett applikasjon").
- **PageHeaderWrapper / Header-meny:** Lenker til ny rute.
- **i18n (`src/common/messages/nb/support.json`):** Nye nøkler for hele applikasjoner-feature. Avklar om de skal i `support.json` eller egen `applikasjoner.json`.
- **Apollo cache config** (`src/common/lib/apollo/cacheConfig.ts`): Sjekk type-policies for nye typer.
- **Generated routes** (`src/common/types/generated/routes.d.ts`): Auto-oppdateres ved `next typegen` — ingen manuell endring.

### External

- **GraphQL API (SuperGrafen):** Nye operasjoner kreves. Sporet i [`sikt-no/fs#455`](https://github.com/sikt-no/fs/issues/455) eid av backend.
  - Queries: `applikasjoner(filter, orderBy, first, after)` (connection-pattern), `applikasjon(id)`, evt. `applikasjonTilganger(applikasjonId, filter, orderBy, first, after)` eller relasjon på `Applikasjon`, søk på feide-bruker/gruppe i org, "tildelbare tilganger i miljø Y for org Z".
  - Mutations: `opprettApplikasjon`, `verifiserApplikasjonId` (eller del av `opprettApplikasjon`), `byttPassord` (returnerer passord), `setAnsvarlig`, `fjernAnsvarlig`, `oppdaterBeskrivelse`, `tildelTilgang` (multi i samme miljø), `fjernTilgang` (multi), `deaktiverApplikasjon`, `reaktiverApplikasjon`.
  - Type-modell: `Applikasjon`, `Tilgang` (med miljø + tilgangskode), `Identitetsleverandør`-enum (FEIDE, MASKINPORTEN, FS), `Miljø`-enum, `Ansvarlig` (union FeideBruker | FeideGruppe?), `ApplikasjonStatus`-enum (AKTIV, DEAKTIVERT), sporingsfelter (`opprettetAv`, `opprettetTidspunkt`, `endretAv`, `endretTidspunkt`).
  - **Autorisasjon må håndheves server-side** i alle queries og mutations basert på applikasjonsadministrator-roller per org.
- **Identitetsleverandør-oppslag:** Backend verifiserer ekstern ID mot Feide/Maskinporten ved opprettelse.
- **Roller/autorisasjon:** Server-side filtrering basert på "applikasjonsadministrator"-rolle. Sjekk om dette finnes i Feide-claims eller en separat rettighetstjeneste.
- **Confluence-referanser** i krav-filene (rammeinnsikt 4401102853, discovery 4612784227) — bakgrunn for designvalg, ikke implementasjonskrav.

### Cross-agent

- **`backend`-agent (sikt-no/fs)**: Issue [`#455`](https://github.com/sikt-no/fs/issues/455) finnes allerede, label `agent:backend`, lenker til prior analyse i coord-repoet. Inneholder oversikt over manglende felter, mutations, filter-utvidelser, roller-modell. Iter 2+3 er blokkert på leveranse fra backend her.
  - **Status:** Eksisterende issue. **Ingen ny hand-off trengs** — issuen dekker scope-en for Iter 2+3.
  - Mulig oppdatering: hvis denne analysen identifiserer nye GraphQL-behov utover #455 (f.eks. "tildelbare tilganger i miljø Y", "søk feide-bruker i org") bør de tilføyes via kommentar eller egen sub-issue.

## Requirements Impact

Det finnes ingen `docs/ACTIVE/requirements-*.md` i prosjektet — krav-grunnlaget er utelukkende `.feature`-filene fra `fruitbat`. Krav-IDene følger `BRU-APP-API-NNN`-mønsteret.

| Krav-ID | Iterasjon | GitHub | Mønster | Risiko |
|---|---|---|---|---|
| `BRU-APP-API-001` Listevisning og søk | 2 | #438, #448, #449 | ListPageLayout | — |
| `BRU-APP-API-002` Se detaljer | 2 | #439 | DetailPageLayout | — |
| `BRU-APP-API-003` Vise tilganger | 2 | #440 | Nested list i tab | Backend må støtte filter+orderBy+paginering på tilganger-relasjonen |
| `BRU-APP-API-004` Passordbytte | 2 | #441 | Dialog (custom) | Mutation må returnere passord engangs; nytt mønster i fs-admin |
| `BRU-APP-API-005` Administrere ansvarlig | 2 | #442 | Dialog m/ søk | Søk-API for feide-brukere i org må finnes |
| `BRU-APP-API-006` Redigere beskrivelse | 2 | #443 | Dialog | — |
| `BRU-APP-API-007` Tildele tilgang | 3 | #444, #450 | Dialog m/ multi-select | Query for "tildelbare tilganger i miljø Y for org Z" må finnes |
| `BRU-APP-API-008` Fjerne tilgang | 3 | #445, #451 | Bekreftelsesdialog (bulk) | — |
| `BRU-APP-API-009` Opprette applikasjon | 3 | #446 | Modal m/ wizard | ID-verifisering mot idP er ny capability; visningsnavn-unikhet på tvers av alle orgs |
| `BRU-APP-API-010` Deaktivere applikasjon | 3 | #447 | Bekreftelsesdialog | — |

**Krav i risikoområdet (Iter 2+3):**
- `-009` ID-verifisering mot idP — avhenger fullt av backend-leveranse.
- `-007` "tilganger jeg har rettighet til å tildele" krever ny autoriserings-query.
- `-005` søk på feide-bruker (`@could`: + feide-gruppe) i applikasjonens org — avhenger av backend-API.

## Krav-input fra GitHub

- **Kilde:** initiativ-issue `#31` + Iter 2 (#434) + Iter 3 (#435) + leaf-issues `#438–#447, #448–#451` (alle med `# GitHub:`-markører i `.feature`-filene)
- **Linket PR(s):** ingen direkte på #31 eller sub-issues. Krav lever på `fruitbat`-branchen uten egen PR enda.
- **Repo / ref:** `sikt-no/fs` @ `fruitbat` (commit `aa3facc1`)
- **Hentede `.feature`-filer:** 10 stk under [`docs/ACTIVE/krav-input/manifest.md`](krav-input/manifest.md)
- **Hentet:** 2026-05-12

## Open Questions

- [ ] **Migreringsstrategi for maskinbruker-POC:** Lever de gamle rutene `/tilgangsstyring/maskinbrukere/*` parallelt, eller fjernes/redirectes de når applikasjoner er live? Påvirker route-tre, CommandPalette, navigasjon, TilgangsstyringIndex. Produkt-/UX-beslutning.
- [ ] **Plassering av "Opprett applikasjon"-flyt:** Modal fra listesiden (anbefalt — naturlig flyt for verifiser-steget) eller egen rute `/tilgangsstyring/applikasjoner/ny` (bedre djup-lenking)? Avklar med UX.
- [ ] **Plassering av "Rediger beskrivelse"-flyt:** Dialog (anbefalt) eller inline edit i Informasjon-tab? Pattern-skillen har ikke inline-edit-pattern — vi bør ikke etablere nytt mønster uten å spørre.
- [ ] **i18n-fil:** Holder vi applikasjons-strenger i eksisterende `support.json`, eller skiller vi ut til ny `applikasjoner.json`? Avhenger av forventet mengde og fremtidig domeneoppdeling.
- [ ] **Tilganger-tab GraphQL-form:** Skal `tilganger`-relasjonen på `Applikasjon` støtte filter+orderBy+connection direkte, eller egen top-level `applikasjonTilganger`-query? Avgjøres i `bat-graphql-dev`-fasen / sammen med backend.
- [ ] **`@could` i `-001` (filter på tilgang) og `-005` (feide-gruppe som ansvarlig):** Skal disse inn i Iter 2-leveransen, eller utsettes? Påvirker GraphQL-scope og UI-implementasjon.
- [ ] **Apollo cache `typePolicies`:** Hvilke nye typer (`Applikasjon`, `Tilgang`, `Ansvarlig`, `FeideBruker`, `FeideGruppe`) trenger `keyFields`-konfigurasjon? Sjekkes når schema er klart.
- [ ] **Mocke API under utvikling?** Backend-issue #455 er åpen. Hvis frontend-utvikling skal starte før schema er ferdig, kan vi gjenta MSW-mock-tilnærmingen som ble brukt i den slettede `applications`-feature-en. Auto-memory beskriver codegen-eksklusjonsmønsteret. Trade-off: rask iterasjon nå vs. dobbel implementasjon hvis schema avviker.
- [ ] **Mutation for passordbytte returnerer passord — hvordan håndterer vi det i Apollo cache?** Vurder om responsen skal lagres i lokal state (Zustand/component) og ikke i cache, for å unngå utilsiktet persistering.
- [ ] **Search-pattern for feide-bruker i org:** Finnes det eksisterende søk-komponenter i `src/domains/person/` eller `src/common/` som kan brukes? Sjekkes når vi går videre til implementasjons-planning.