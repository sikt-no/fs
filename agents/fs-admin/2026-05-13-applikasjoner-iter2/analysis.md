# Analysis: Applikasjoner — Iterasjon 2 (Support: oversikt og passordbytte)

**Initiativ:** [`sikt-no/fs#31`](https://github.com/sikt-no/fs/issues/31)
**Iterasjon (parent sub-issue):** [`#434`](https://github.com/sikt-no/fs/issues/434) — Iterasjon 2: Support — Oversikt og passordbytte
**Krav-branch:** `fruitbat` i `sikt-no/fs`
**Working branch:** `FSADMIN-pattern-skills` (fs-admin)
**Backend-schema:** sporet i [`#455`](https://github.com/sikt-no/fs/issues/455) (`agent:backend`, CLOSED). Dekker iter 2 + 3.
**Tidligere analyser i coord-repo:** [`2026-05-13-applikasjoner-initiativ/analysis.md`](../../../fs/agents/fs-admin/2026-05-13-applikasjoner-initiativ/analysis.md) (initiativ-nivå, samme dato). Denne analysen er en *fokusert* nedskalering til Iter 2 og henter detalj per krav.

## Problem Statement

Iterasjon 2 er den første frontend-leveransen for initiativet «Grunnleggende selvbetjent tilgangsstyring for applikasjoner». Den dekker **support-rollen**: Sikt-support og lokale applikasjonsadministratorer skal kunne *finne* riktig applikasjon (listevisning + søk + filtre), *se* hva applikasjonen er og hvilke tilganger den har, og *bistå* med passordbytte og lett vedlikehold (ansvarlig, beskrivelse). Det er ingen opprettelse, ingen deaktivering, og ingen tilgangsendring i denne iterasjonen — det kommer i Iter 3 (#435).

Issue #31 setter tre eksplisitte rammer som direkte styrer denne iterasjonen:

> «Vi lager en ny løsning tilgangsstyring av applikasjoner, vi bygger ikke i videre på dagens POC for visning av maskinbruker i FS Admin.»
> «Dagens løsning for maskinbruker i FS Admin er ikke innført og skal fjernes.»
> «Vi skal lage nye graphql spørringer for applikasjon. Vi skal ikke gjenbruke dagens graphql spørringer for maskinbruker.»

Dagens `/applications`-rute er en MSW-mocket POC med kun listevisning og en svært enkel detalj-topbar. Den er engelsk-navngitt, mangler 90 % av Iter 2-kravene, og bruker en `applicationsV2`-query mot et mock-schema som er en utdatert subset av det nye `Applikasjon`-schemaet på fruitbat. Iter 2 leveres som en **erstatter** — ikke en utvidelse — med norsk terminologi og nye GraphQL-operasjoner.

## Krav-input fra GitHub

- **Kilde:** parent sub-issue `#434` + leaf-issues `#438, #439, #440, #441, #442, #443` (+ `#448, #449` for utvidede synlighets-scenarier i K11/K12).
- **Linket PR(s):** ingen direkte på #31 eller #434. Krav lever på `fruitbat`-branchen uten PR.
- **Cross-reference:** [`#455`](https://github.com/sikt-no/fs/issues/455) (`agent:backend`, CLOSED) — schema-utvidelse for Iter 2 + 3.
- **Repo / ref:** `sikt-no/fs` @ `fruitbat`
- **Hentede `.feature`-filer:**
  - [`listevisning_og_sok.feature`](krav-input/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20–%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature) — `BRU-APP-API-001` (#438, #448, #449)
  - [`se_detaljer.feature`](krav-input/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20–%20Oversikt%20og%20passordbytte/se_detaljer.feature) — `BRU-APP-API-002` (#439)
  - [`vise_tilganger.feature`](krav-input/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20–%20Oversikt%20og%20passordbytte/vise_tilganger.feature) — `BRU-APP-API-003` (#440)
  - [`passordbytte.feature`](krav-input/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20–%20Oversikt%20og%20passordbytte/passordbytte.feature) — `BRU-APP-API-004` (#441)
  - [`administrere_ansvarlig.feature`](krav-input/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20–%20Oversikt%20og%20passordbytte/administrere_ansvarlig.feature) — `BRU-APP-API-005` (#442)
  - [`rediger_beskrivelse.feature`](krav-input/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20–%20Oversikt%20og%20passordbytte/rediger_beskrivelse.feature) — `BRU-APP-API-006` (#443)
  - [`systemkrav.md`](krav-input/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20–%20Oversikt%20og%20passordbytte/systemkrav.md) — iterasjons-oversikt
- **Hentet:** 2026-05-13. Manifest: [`docs/ACTIVE/krav-input/manifest.md`](krav-input/manifest.md).

## Current State

### Eksisterende `/applications`-feature på `FSADMIN-pattern-skills`

| Lag | Hva som finnes |
|---|---|
| Route | `src/app/applications/page.tsx` → `ApplicationOverview`; `src/app/applications/[id]/page.tsx` → `ApplicationDetails`; `src/app/applications/layout.tsx` har feilaktig `metadata.title = "Søknader \| FS Admin"` (POC-tegn, ikke i bruk). |
| Listeside | `src/domains/support/features/ApplicationOverview/ApplicationOverview.tsx` — `ListPageLayout` + `ListPageSidebar` (kun navn- og status-filter) + `ListPageContent` med `ApplicationResultList`. Ingen `ListPageActionbar`. |
| Listeside-hooks | `useGetApplicationState` (URL-synket via `useDataListState`, init `nameContains`/`isActive`/sort på `NAME`/first 50) og `useGetApplications` (Apollo `useDataListQuery` mot mock-query `applicationsV2`). |
| Detaljside | `src/domains/support/features/ApplicationDetails/ApplicationDetails.tsx` — `DetailPageLayout` + `DetailPageTopBar` + `ApplicationInformation`. **Ingen tabs, ingen tilganger, ingen action-knapper.** |
| Detaljside-hook | `useGetApplication(id)` (Apollo mot mock-query). |
| Komponenter | `ApplicationFilterName`, `ApplicationFilterStatus`, `ApplicationOrderBy`, `ApplicationResultList`, `ApplicationInformation`. |
| MSW-mock | `src/mocks/handlers/applicationHandlers.ts`, `src/mocks/data/mockApplications.ts` (150 deterministiske rader), `src/mocks/schema/application.graphql.md` (forventet schema-skisse). |
| Mock-schema | `Application` (engelsk): `id`, `name`, `description`, `status`-enum `ACTIVE/INACTIVE`, `organizationCode`/`organizationName`, `createdAt`/`updatedAt`, `owner.{firstName,lastName}`. Query `applicationsV2(filter, orderBy, first, after)` + `applicationById(id)`. Mangler miljøer, tilganger, ansvarlig, sporingsfelter med "endret av". |
| Apollo cache | `src/common/lib/apollo/cacheConfig.ts:45` har `applicationsV2: nodesCursorPagination(['filter', 'orderBy'])`. |
| Codegen | `codegen.ts` ekskluderer `useGetApplications.tsx` og `useGetApplication.tsx` siden de bruker mock-schema som ikke finnes i SuperGrafen. |
| Inngang | `src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.tsx`: kort med `ButtonLink href="/applications"` og i18n-nøkkel `maskinbrukereLabel` ("Gå til maskinbrukere"). `src/features/Header/Menu/Menu.tsx:108` peker på `/tilgangsstyring/maskinbrukere` (ikke-eksisterende rute på denne branchen). `src/domains/search/features/CommandPalette/hooks/useCommands.tsx:84` peker på `/applications`. |
| i18n | `src/common/messages/nb/support.json` har nøkler både for `maskinbrukere*` (legacy) og for `ApplicationOverview/ApplicationDetails` (POC, engelsk-orientert: "Søk på navn", "Status"). Ingen `applikasjoner.json` finnes. |
| Auto-memory | Eksisterende memory `project_applications_feature.md` beskriver akkurat denne POC-en + codegen-eksklusjons-mønsteret. |

### Eksisterende byggeklosser som matcher Iter 2

| Byggekloss | Sti | Status for Iter 2 |
|---|---|---|
| `ListPageLayout` + `ListPageSidebar`/`ListPageContent`/`ListPageActionbar` | `src/common/components/layouts/ListPageLayout/` | Direkte bruk for listesiden. |
| `DetailPageLayout` + `DetailPageTopBar`/`DetailPageTabbedContent`/`DetailPageTabbedContentPanel` | `src/common/components/layouts/DetailPageLayout/` | Direkte bruk; *må utvides* med tabs (Iter 2 trenger Informasjon + Tilganger). |
| `NavigationList`, `NavigationListItem` | `src/common/components/lists/NavigationList/` | Liste-rader m/ `href` til detalj. |
| `ActionList`, `ActionListItem` | `src/common/components/lists/ActionList/` | Tilganger-tab (-003). Iter 2 trenger ikke seleksjon, men `ActionList` matcher visningsformen og er rett komponent for Iter 3-utvidelse (-008 bulk-fjern). |
| `FilterWrapper`, `FilterReset`, `FilterChip`, `OrderByButton` | `src/common/components/list-enhancers/` | Sidebar-filtre og sortering. |
| `useDataListState` (URL-synket via nuqs) | `src/common/hooks/useDataListState/` (med CLAUDE.md — kanonisk) **eller** `src/hooks/dataList/useDataListState/` (alternativ — eksisterende `ApplicationOverview` bruker denne via `@/hooks/dataList/...`). | **⚠️ To paths sameksisterer.** Bekreft med team hvilken er kanonisk før nytt feature lander; CLAUDE.md-eksistens peker på `src/common/hooks/`. |
| `useDataListQuery` | Samme dualitet som over. | Samme avklaring. |
| `useMineLaresteder` | `src/lib/auth/globalUserContext` | Brukes til org-scoping; men merk K11/K12 utvidelser (se Key Findings #5). |
| `Dialog` (`@sikt/sds-dialog`) | Sikt SDS | Brukes i `OpprettRundeModalButton`, `RedigerRundeModal`, `ParameterDialog` (`src/domains/plasstildeling/`), `InviterOrganisasjonerModal` (`src/domains/opptak/`). Råmønster for `-004`, `-005`, `-006`. |
| Referanse for cross-pattern | `src/domains/utdanning/features/EmnerOverview/` ↔ `EmneDetails/` | Gullstandard for liste↔detalj med URL-state. |

### Krav på `fruitbat` — entitetsmodell utledet fra `.feature`-filene (Iter 2-subset)

| Konsept | Brukt av krav | Felter / atferd |
|---|---|---|
| **Applikasjon** | -001 til -006 | `navn`, `beskrivelse`, `status` (aktiv/deaktivert — kun *vises* i Iter 2, endres ikke), `organisasjon` (eier), `miljøer` (aktive — fra tilganger), `ansvarlig` (FeideBruker, evt. FeideGruppe `@could`), sporing (`opprettetAv`, `opprettetTidspunkt`, `endretAv`, `endretTidspunkt`), passord (kun for FS-applikasjoner; ikke representert som felt, kun via mutation). |
| **Tilgang** | -003 | Tilgangskode + miljø. Tilhører en applikasjon. Listevisning krever paginering (50+). |
| **Ansvarlig** | -005 | FeideBruker fra applikasjonens organisasjon. `@could`: FeideGruppe. Arver passordbytte-rett. Søk org-scopet. |
| **Roller (autorisasjon)** | alle | `applikasjonsadministrator` (per org), `super-applikasjonsadministrator` (på tvers). I tillegg `ansvarlig` som synlighet uten admin-rolle. Eksponeres på `Me` og håndheves server-side. |
| **Identitetsleverandør** | implisitt | FS / Feide / Maskinporten. Iter 2 påvirkes kun av at passordbytte-knappen skal være meningsfull *kun for FS-applikasjoner*. Resten av idP-modellen er Iter 3-tema. |

## Key Findings

1. **Iter 2 er en *erstatter* av dagens `/applications`-POC**, ikke en utvidelse. Norsk rute, norsk type-system, ny GraphQL-modell, dialog-flyter for lett redigering, og en helt ny Tilganger-tab. POC-en kan brukes som *strukturelt skjelett* (komponent-tre, hooks-shape, codegen-eksklusjons-mønster) men ingen kode/queries skal gjenbrukes direkte.

2. **Mønsterpasning fra `bat-fs-admin-patterns`** (Iter 2-subset):

   | Krav | Pattern | Confidence | Rolle |
   |---|---|---|---|
   | `BRU-APP-API-001` listevisning | **ListPageLayout** | 100/100 | Standalone side. |
   | `BRU-APP-API-002` se detaljer | **DetailPageLayout** | 94/100 | Standalone side, Informasjon-tab. |
   | `BRU-APP-API-003` vise tilganger | sub-feature i tab | n/a | Nested liste (`ActionList` eller fragment) i DetailPageLayout-tab — ikke standalone pattern. |
   | `BRU-APP-API-004` passordbytte | Dialog | n/a | Action på detaljside (`@sikt/sds-dialog`). |
   | `BRU-APP-API-005` administrere ansvarlig | Dialog m/ søk | n/a | Action på detaljside. |
   | `BRU-APP-API-006` rediger beskrivelse | Dialog m/ TextField | n/a | Action på detaljside. |

   **Cross-pattern `list-page-layout ↔ detail-page-layout`** gjelder. URL-state via `useDataListState`/`nuqs` bevarer filter/sortering/paginering ved tilbake-navigering. Referanse: `EmnerOverview ↔ EmneDetails`.

3. **Tilganger-tab (-003) krever paginering på nested liste** ("Laste flere tilganger ... applikasjonen har flere enn 50 tilganger"). Det skyver implementasjonen fra *enkel fragment-liste* mot *egen `applikasjonTilganger`-query med connection*. Filter på miljø/tilgang skal være *begrenset til applikasjonens egne data* (filter-valgene populeres dynamisk fra applikasjonens egne tilganger, ikke fra et globalt enum) — krever enten en `availableMiljoer`/`availableTilganger`-felt på Applikasjon, eller at klient utleder fra første side. Hvilket: avklares i `bat-graphql-dev`.

4. **Passordbytte (-004) har sjeldne tekniske krav** som UI må håndtere bevisst:
   - Mutation må returnere passord i payload (uvanlig — verdt å bekrefte med backend at #455 dekker dette).
   - Returnert passord **må holdes i lokal komponent-state** (`useState`/ref i `PassordbytteDialog`), **ikke i Apollo cache**. Når dialogen lukkes, skal verdien glemmes og ikke kunne hentes opp igjen.
   - Skjult-som-default + vis/skjul-toggle + kopier. Vurder `<input type="password">` + en separat "vis"-toggle for å unngå at passwordmanagers fanger det.
   - Server må *utelukke* passord fra logging.
   - Mutation skal **kun være meningsfull for FS-applikasjoner**. UI må skjule "Bytt passord"-knappen for Feide/Maskinporten-applikasjoner; server må håndheve at mutationen avvises.

5. **K11/K12-synlighet utvider listevisning på en ikke-trivielt måte** (sub-issues #448, #449):
   - Applikasjonsadministrator for org X ser *i tillegg* applikasjoner som **tilhører andre orgs** men har **tilganger inn i X**.
   - Super-administrator ser også applikasjoner *uten* org-tilhørighet.
   - Bruker som er `ansvarlig` (direkte, eller `@could`: via feide-gruppe) ser applikasjonen *uten* å være administrator.

   Det betyr at `useGetApplikasjoner` **ikke** kan filtrere `eierOrganisasjonskode = mine orgs` klient-side. Synligheten må håndheves server-side basert på `Me`-rolle-claims, og query-en returnerer hele fellesmengden. Det stemmer overens med "DO NOT include eierOrganisasjonskode" i `useDataListState`-konvensjonen.

6. **`@could`-scenarier i Iter 2** — to stk., må avklares før planning fullføres:
   - `-001`: filter på tilgang (krever ny filter-input + ny query-arg for "list of tilgang-koder").
   - `-005`: feide-gruppe som ansvarlig (krever union-type `Ansvarlig = FeideBruker | FeideGruppe` i schema). Hvis utsatt: gjør UI-en åpen for utvidelse, men ikke implementér søk på grupper.

7. **Autorisasjon er gjennomgående og synlig i UI**. Action-knapper på detaljsiden (`-004`, `-005`, `-006`) er **kun synlige** når brukeren har admin-rett for applikasjonens org *eller* er super-admin. Synligheten må kunne avgjøres uten å fyre ekstra queries — `Me`-claim (`applikasjonsadministratorFor: [orgKode]` + `superApplikasjonsadministrator: Boolean`) eksponert i context er beste mønster. Server-side håndhevelse i alle mutations er en separat sak.

8. **Detalj-topbar (-002) skal vise *aktive miljøer*** ("hvilke miljøer applikasjonen er aktiv i"). Det utledes fra tilganger (en applikasjon er aktiv i miljø Y hvis den har minst én tilgang i Y), ikke fra et eksplisitt miljø-felt. Avklar med backend om server beregner dette og eksponerer som `aktiveMiljoer: [Miljo!]!` på `Applikasjon`, eller om klient må utlede fra `tilganger`. Det første er foretrukket — det er stabilt på tvers av paginering.

9. **Iter 2 lar listen være sortert kun på navn (stigende/synkende)**, men POC har også `CREATED_AT`/`STATUS` i sin orderBy-enum. Iter 2-krav nevner ikke disse — hvis backend velger å beholde dem i schema, må UI ikke eksponere dem som valg.

10. **Codegen-eksklusjon for mock-only hooks** — hvis vi velger å bygge Iter 2 med MSW-mocking før schema lander, må eksklusjonene i `codegen.ts` utvides for hver ny mock-hook (`useGetApplikasjoner`, `useGetApplikasjon`, `useApplikasjonTilganger`, og fire mutations). Alternativet er å vente til backend lukker #455 og codegen produserer typer.

11. **Inngangs-inkonsistens må ryddes**: `TilgangsstyringIndex` peker til `/applications`; `Menu.tsx:108` peker til `/tilgangsstyring/maskinbrukere` (eksisterer ikke på denne branchen); `CommandPalette` peker til `/applications`. Når Iter 2-ruten lander må alle tre oppdateres samtidig, ellers risikerer vi død-lenker. i18n-nøkkelen `maskinbrukereLabel` må også få et nytt navn.

## Komponentmønster pr. krav (Iter 2)

| Krav | Side | Hovedkomponent | Sub-komponenter | Hook(s) | Mutation |
|---|---|---|---|---|---|
| `-001` Listevisning og søk | `/applikasjoner` | `ApplikasjonerOverview` | `ApplikasjonerFilter*` (navn, org, status, `@could` tilgang), `ApplikasjonerOrderBy` (kun navn), `ApplikasjonerResultList` (NavigationList) | `useGetApplikasjonerState`, `useGetApplikasjoner` | — |
| `-002` Se detaljer | `/applikasjoner/[id]` | `ApplikasjonDetails` (Informasjon-tab) | `ApplikasjonInformation` (topbar: navn, status, aktive miljø-chips, ansvarlig, sporing); `ApplikasjonInfoTab` (grunninfo + sporing-blokk) | `useGetApplikasjon` | — |
| `-003` Vise tilganger | `/applikasjoner/[id]` (Tilganger-tab) | `ApplikasjonTilgangerTab` | `ApplikasjonTilgangerFilter` (miljø, tilgang — scoped), `ApplikasjonTilgangerList` (ActionList eller fragment-liste m/ paginering) | `useGetApplikasjonTilganger` (egen connection-query for paginering) eller fragment | — |
| `-004` Passordbytte | Topbar action | `PassordbytteButton` + `PassordbytteDialog` | — | lokal `useState` for returnert passord, `useMutation` | `byttPassord(applikasjonId): String` |
| `-005` Administrere ansvarlig | Topbar action | `SettAnsvarligButton` + `SettAnsvarligDialog` (m/ søk-input + result-liste, scoped til app.org); `FjernAnsvarligButton` (`ButtonWithConfirmation`) | `useSearchFeideBrukere` (org-scoped) | `settAnsvarlig(applikasjonId, brukerId)`, `fjernAnsvarlig(applikasjonId)` |
| `-006` Rediger beskrivelse | Topbar action eller inline i Informasjon | `RedigerBeskrivelseButton` + `RedigerBeskrivelseDialog` (TextField + Lagre/Avbryt) | — | `useMutation` lokalt | `oppdaterBeskrivelse(applikasjonId, beskrivelse): Applikasjon` |

Synlighet pr. action: avled fra `Me.{applikasjonsadministratorFor, superApplikasjonsadministrator}` + applikasjonens `organisasjonskode`. Skjul knappen hvis ingen match.

## Technical Constraints

- **CLAUDE.md (root):** Next.js 16 (App Router, Webpack), React 19, Apollo Client 4, NextAuth/Feide, next-intl, Sikt Design System (`@sikt/sds-*`). TypeScript med strict types.
- **CLAUDE.md (root):** «GraphQL queries should be closely related to components they're used in. Do NOT reuse queries between different components, even if similar.» → applikasjoner-queries lever lokalt i hooks. Issue #31 forsterker: ingen gjenbruk av `applicationsV2` eller maskinbruker-queries.
- **CLAUDE.md (root):** Hver ny komponent MÅ ha `*.a11y.test.tsx`. Coverage-terskler 60 % / 90 %.
- **CLAUDE.md (root):** Norsk er domenespråk, engelsk er kodespråk. Strenger eksternaliseres til `src/common/messages/nb/<domene>.json`. Iter 2 er stor nok til at det forsvarer **ny `applikasjoner.json`** i stedet for å fortsette i `support.json`.
- **CLAUDE.md (root):** Aldri commit hardkodede strenger. Bruk `useTranslations`. `externalize-i18n`-skill kan brukes for opprydning.
- **Routes:** Generert via `next typegen` i postinstall. Nye ruter `/applikasjoner` og `/applikasjoner/[id]` gir auto-genererte typer.
- **`bat-fs-admin-patterns`-regel:** Aldri modifisér `src/common/` for å passe en feature. Hvis et eksisterende mønster ikke holder, eskaler til utvikler.
- **Apollo cache (`src/common/lib/apollo/cacheConfig.ts`):** `applicationsV2` allerede registrert med `nodesCursorPagination`. Når ny `applikasjoner`-query lander må den også registreres tilsvarende (`['filter', 'orderBy']`-keyArgs). Type-policies for nye typer (`Applikasjon`, `Tilgang`, `FeideBruker`) trenger trolig `keyFields`-konfigurasjon — sjekkes når schema er klart.
- **MSW-strategi:** Eksisterende mock-pattern med codegen-eksklusjon er ferdig dokumentert. Hvis vi mocker Iter 2 før schema lander, gjenbruk mønsteret — ikke oppfinn noe nytt.
- **Identitetsleverandører:** Iter 2 må kunne *vise* alle idP-typer i listen, men passordbytte-knappen er kun for FS-applikasjoner. Server håndhever; klient skjuler knappen.
- **Norsk domenespråk i type-system og komponentnavn:** `Applikasjon` (ikke `Application`), `Tilgang` (ikke `Access`), `Ansvarlig` (ikke `Owner`), `Miljo`/`Miljoer` (ikke `Environment`), `aktiv`/`deaktivert` (ikke `ACTIVE`/`INACTIVE`). Filterfelt på norsk i schema: avklares med backend (#455).

## Dependencies

### Internal (innenfor fs-admin)

- **Eksisterende `/applications`-feature** må fjernes som del av Iter 2-leveransen eller leve parallelt midlertidig. Følgende elementer faller bort: `src/app/applications/*`, `src/domains/support/features/ApplicationOverview/*`, `src/domains/support/features/ApplicationDetails/*`, `src/mocks/handlers/applicationHandlers.ts`, `src/mocks/data/mockApplications.ts`, `src/mocks/schema/application.graphql.md`, `applicationsV2`-entry i `cacheConfig.ts`, codegen-eksklusjoner for de gamle hooksene. Beslutning åpen — se Open Questions.
- **`TilgangsstyringIndex`** (`src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.tsx`): `ButtonLink href="/applications"` + i18n-nøkkel `maskinbrukereLabel`. Må oppdateres til ny rute (`/applikasjoner` eller `/tilgangsstyring/applikasjoner`) og ny i18n-nøkkel (f.eks. `applikasjonerLabel`).
- **`CommandPalette`** (`src/domains/search/features/CommandPalette/hooks/useCommands.tsx:84`): nåværende `typedRouter.push({ pathname: '/applications' })` må peke til ny rute. Vurder også egen "Gå til applikasjoner"-kommando med norsk label.
- **`Header/Menu`** (`src/features/Header/Menu/Menu.tsx:108`): peker på `/tilgangsstyring/maskinbrukere` som ikke eksisterer på denne branchen. Død-lenke uavhengig av Iter 2 — bør rettes til ny rute i samme leveranse.
- **i18n** (`src/common/messages/nb/support.json` + ny `applikasjoner.json`): nye nøkler for hele Iter 2. Eksisterende `support.ApplicationOverview` / `support.ApplicationDetails` blir overflødige når POC fjernes.
- **`codegen.ts`:** legge til eksklusjoner for nye mock-hooks (hvis MSW-strategi), eller fjerne POC-eksklusjonene (hvis POC fjernes).
- **Apollo cache config** (`src/common/lib/apollo/cacheConfig.ts`): ny `applikasjoner`-query med `nodesCursorPagination`. Sjekk om Tilganger-tab krever egen entry hvis det blir en top-level connection. `keyFields` for `Applikasjon`/`Tilgang` hvis nødvendig.
- **Genererte routes** (`src/common/types/generated/routes.d.ts`): auto-oppdateres ved `next typegen`.
- **Auto-memory** (`project_applications_feature.md`): beskriver POC-en. Når POC fjernes må memory enten oppdateres eller flagges som utdatert.

### External

- **GraphQL API (SuperGrafen):** dekkes av **[#455](https://github.com/sikt-no/fs/issues/455)** (`agent:backend`, CLOSED). For Iter 2 spesifikt trenger frontend:
  - **Queries:**
    - `applikasjoner(filter: ApplikasjonerFilter, orderBy: ApplikasjonerOrderBy, first: Int, after: String): ApplikasjonerConnection` — med felter på node-en: `id`, `navn`, `beskrivelse`, `status`, `organisasjon { kode, navn }`, `aktiveMiljoer` (utledet), `ansvarlig` (FeideBruker, evt. union), `opprettetAv`/`opprettetTidspunkt`/`endretAv`/`endretTidspunkt`, `autentiseringstype` (idP-enum — for å vise/skjule passordbytte-knapp).
    - `applikasjon(id: ID!): Applikasjon` — samme felter + `tilganger`-relasjon.
    - **Tilganger på applikasjon:** enten relasjon `Applikasjon.tilganger(filter, orderBy, first, after): TilgangerConnection`, eller egen top-level `applikasjonTilganger(applikasjonId, filter, orderBy, first, after)`. Avklares i `bat-graphql-dev`.
    - **Søk på FeideBruker scopet til org:** ny query for `-005`-dialog. Trolig `feideBrukere(organisasjonskode: String!, q: String!): [FeideBruker!]!`. (`@could`: union med FeideGruppe.)
  - **Mutations:**
    - `byttPassord(applikasjonId: ID!): BytPassordPayload` — returnerer nytt passord, krever `autentiseringstype = FS`.
    - `settAnsvarlig(applikasjonId: ID!, brukerId: ID!): Applikasjon`.
    - `fjernAnsvarlig(applikasjonId: ID!): Applikasjon`.
    - `oppdaterBeskrivelse(applikasjonId: ID!, beskrivelse: String): Applikasjon`.
  - **Autorisasjon server-side** på alle queries og mutations. `Me.applikasjonsadministratorFor: [String!]!` og `Me.superApplikasjonsadministrator: Boolean!` (eller tilsvarende) — eksponeres for synlighets-logikk i UI.
  - **`@could`-utvidelser** som påvirker schema:
    - Filter på tilgang (-001).
    - Ansvarlig som FeideGruppe (-005) — union/interface.

- **Backend-eierskap:** #455 er CLOSED, så schema antas å være tilgjengelig i SuperGrafen test-miljøet. **Verifiser** med `npm run compile` mot `GRAPHQL_ENDPOINT_URL` før Iter 2-implementasjon starter at typer faktisk finnes; hvis ikke — re-åpne #455 via en hand-off-issue.

- **Confluence-referanser** i krav-filene (K1–K5, K11/K12, K18, K19, ramme-innsikt 4401102853, discovery 4612784227) — bakgrunn for designvalg, ikke implementasjonskrav. Linker ligger i `systemkrav.md`.

### Cross-agent

Disse er *kandidater* for hand-off — `bat-plan` revisiterer dem etter at planen er publisert.

- **`backend`-agent (sikt-no/fs)**: `#455` dekker schema for Iter 2 og er **CLOSED**. Hvis verifisering mot SuperGrafen viser at noe mangler (sannsynlige hull: `aktiveMiljoer` utledet av server, `autentiseringstype`-eksponering, FeideBruker-søk scopet til org, struktur på tilganger-relasjon med paginering, mutation-payload for passordbytte med autentiseringstype-håndhevelse), åpne ny hand-off-issue som lenker til denne feature-folderen. Ikke fil hand-off fra denne analysen — vent på `bat-plan` for konkret kontekst.

## Requirements Impact

Det finnes ingen `docs/ACTIVE/requirements-*.md` — krav-grunnlaget er `.feature`-filene fra `fruitbat` (lagret i [`docs/ACTIVE/krav-input/fruitbat/`](krav-input/fruitbat/)).

| Krav-ID | GitHub | Status | Risiko / kompleksitet |
|---|---|---|---|
| `BRU-APP-API-001` Listevisning og søk | #438, #448, #449 | @planned @must | Medium. K11/K12-synlighet (#448, #449) er ikke-trivielt server-side. `@could` filter på tilgang utsettbar. |
| `BRU-APP-API-002` Se detaljer | #439 | @planned @must | Lav. Standard DetailPageLayout-topbar + Informasjon-tab. Avhenger av om `aktiveMiljoer` kommer fra server. |
| `BRU-APP-API-003` Vise tilganger | #440 | @planned @must | Medium. Paginering på nested liste; filter-valgene må scopes til applikasjonens egne data. |
| `BRU-APP-API-004` Passordbytte | #441 | @planned @must | Høy. Mutation som returnerer passord (sjeldent mønster), kun-én-gang-visning, server-side håndhevelse av `autentiseringstype = FS`, server-logging-utelukkelse. |
| `BRU-APP-API-005` Administrere ansvarlig | #442 | @planned @must | Medium. Trenger ny org-scopet søk-query. `@could` feide-gruppe utsettbar. |
| `BRU-APP-API-006` Redigere beskrivelse | #443 | @planned @must | Lav. Standard dialog m/ TextField. |

**Krav-spørsmål som blokkerer planning:**

- Skal `@could`-scenariene (filter på tilgang i -001, feide-gruppe som ansvarlig i -005) være med i Iter 2? Påvirker schema og UI-kompleksitet.
- Skal POC-en (`/applications`) fjernes i samme PR som Iter 2 lander, eller leve parallelt en periode? Påvirker rekkefølge og PR-størrelse.

## Open Questions

- [ ] **Rute-navn for ny feature:** `/applikasjoner` (flat, matcher dagens `/applications`-konvensjon) eller `/tilgangsstyring/applikasjoner` (under eksisterende `/tilgangsstyring`-prefix). Påvirker også `TilgangsstyringIndex`-kortet, `CommandPalette` og `Menu.tsx`.
- [ ] **Migreringsstrategi for `/applications`-POC:** Fjernes som del av Iter 2-PR-en, eller leve parallelt midlertidig? Hvis parallelt: hvor lenge, og hvilken rute er "default" i Tilgangsstyring-landingen.
- [ ] **Domene-mappe:** Skal Iter 2-koden ligge under `src/domains/support/` (matcher Iter 2-konteksten "Support oversikt og passordbytte") eller `src/domains/applikasjoner/` (lever sammen med Iter 3+ uten omflytting). Anbefaling: ny `applikasjoner/` siden hele initiativet over fire iterasjoner vil samles der.
- [ ] **`@could` i Iter 2:** Filter på tilgang (-001) — inn eller ut? FeideGruppe som ansvarlig (-005) — inn eller ut?
- [ ] **i18n-fil-struktur:** Ny `applikasjoner.json` eller blir det utvidelser i `support.json`? Anbefaling: egen `applikasjoner.json` (sannsynlig ≥ 50 nøkler over alle iterasjoner).
- [ ] **`useDataListState`-import-path:** `src/common/hooks/useDataListState/` (har CLAUDE.md, kanonisk) eller `src/hooks/dataList/useDataListState/` (det POC-en bruker, mer brukt på tvers av repoet). Trenger team-avklaring før Iter 2 begynner — ikke for analyse-doc-en.
- [ ] **Tilganger-tab GraphQL-form:** Relasjon på `Applikasjon` med connection, eller egen top-level `applikasjonTilganger`-query? Avklares i `bat-graphql-dev`.
- [ ] **`aktiveMiljoer`:** Beregnes server-side og eksponert som felt på `Applikasjon`, eller utledes klient-side fra `tilganger`-relasjonen? Foretrukket: server.
- [ ] **`autentiseringstype` på listevisning:** Skal feltet være synlig per rad i listen (f.eks. ikon/chip ved siden av status), eller kun på detaljside? Krav -001 nevner ikke idP eksplisitt, men det er informasjon support trenger for å avgjøre om de skal foreslå passordbytte. UX-beslutning.
- [ ] **Mutation-flyt for passordbytte:** Mutation må returnere passord — bekreft med backend at `byttPassord(applikasjonId)`-payload faktisk inneholder passordstrengen, og at server-side håndhever `autentiseringstype = FS` (avvis ellers). Bekreft også at passord *ikke* logges noe sted.
- [ ] **Passordbytte UI-detalj:** `<input type="password">` med vis/skjul-toggle, eller `<input type="text">` med skjul-som-default + show? Førstnevnte unngår å lokke passwordmanagers til å lagre engangs-passord; sistnevnte gir bedre kopier-til-utklipp-flyt. UX-beslutning.
- [ ] **Sortering i listevisning:** Iter 2 spesifiserer kun "navn stigende/synkende". Skal vi *fjerne* `CREATED_AT`/`STATUS` fra orderBy-eksponeringen i UI (selv om schema kan ha dem), eller la dem bli? Anbefaling: kun navn for Iter 2; legg til når kravet sier det.
- [ ] **Sporing av endringer for `-005`/`-006`:** Krever "endret av" / "endret tidspunkt" å bli oppdatert server-side ved settAnsvarlig / oppdaterBeskrivelse? (Logisk ja, men ikke eksplisitt i Iter 2-krav.) Avklar med backend.
- [ ] **Forhold til Iter 4 endringslogg:** `-005`/`-006` er handlinger som vil generere endringslogg-innslag i Iter 4. Bekreft at server begynner å logge fra Iter 2 så Iter 4 har historikk å vise.