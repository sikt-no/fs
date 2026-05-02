# Analysis: Applikasjon-administrasjon (Iterasjon 2 + 3)

> **Scope:** Sub-issues [#434](https://github.com/sikt-no/fs/issues/434) og [#435](https://github.com/sikt-no/fs/issues/435) under initiativ [#31](https://github.com/sikt-no/fs/issues/31). Krav hentet fra branch `sikt-no/fs@fruitbat` — se [krav-input/manifest.md](krav-input/manifest.md).

## Problem Statement

Initiativ #31 ("Grunnleggende selvbetjent brukeradministrasjon for API-brukere via FS Admin") har som mål å gi support og lokale administratorer kontroll over hvilke API-brukere ("applikasjoner") som har tilgang til lærestedenes data — som ledd i å ivareta databehandler-ansvar og personvern.

To av iterasjonene er nå spesifisert som krav på `fruitbat`-branchen:

- **Iterasjon 2 (#434)**: Lese-flyten — listevisning, søk, detaljer, roller, passordbytte, redigere ansvarlig + beskrivelse.
- **Iterasjon 3 (#435)**: Skrive-flyten — opprette applikasjon, tilordne/fjerne roller, deaktivere/reaktivere.

I dag dekker fs-admin **bare deler av Iterasjon 2** (lesevisning, søk, passordbytte for FS-applikasjoner). Iterasjon 3 er ikke implementert — og dagens UI bruker eksterne Nettskjema-lenker for opprette- og tilgangs-flyter. Tre strukturelle endringer i krav-domenet driver mest av kompleksiteten: entiteten skifter navn fra `Maskinbruker` → `Applikasjon`, det innføres en `autentiseringstype` (FS/Feide/Maskinporten), og en helt ny rolle-modell (`applikasjonsadministrator` / `super-applikasjonsadministrator`) introduseres som ikke finnes i koden i dag.

## Current State

### Routes

- **Listside:** [src/app/tilgangsstyring/maskinbrukere/page.tsx](src/app/tilgangsstyring/maskinbrukere/page.tsx) → `<Maskinbrukere />`
- **Detaljside:** [src/app/tilgangsstyring/maskinbrukere/[maskinbrukerid]/page.tsx](src/app/tilgangsstyring/maskinbrukere/[maskinbrukerid]/page.tsx) → `<Maskinbruker id={...} />`
- **Tilgangsstyring-index:** [src/app/tilgangsstyring/page.tsx](src/app/tilgangsstyring/page.tsx) → [TilgangsstyringIndex](src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.tsx)
- **Layout / brødsmuler:** [src/app/tilgangsstyring/layout.tsx:10-17](src/app/tilgangsstyring/layout.tsx#L10-L17)

### Listevisning og søk (i dag)

| Krav-aspekt (BRU-APP-API-001) | Dagens implementasjon | Gap |
|---|---|---|
| Paginering 50 om gangen, "last 50 til" | Henter **1000 rader** klient-side, deretter Fuse.js-søk lokalt; "last flere"-knapp via `hasNextPage`/`loadMore` | Stor — pagineringen må byttes ut. Server-side `first: 50` + cursor. |
| Kolonner: Navn, Beskrivelse, Miljøer, Ansvarlig, Organisasjon, Type applikasjon, Oppfølgningsstatus | brukernavn, organisasjon, kontaktperson.navn, apiTilgangerV2-tags, trengerPassordbytte | Stor — 5 av 7 kolonner er nye. Krever schema-felter `beskrivelse`, `miljøer`, `ansvarlig`, `autentiseringstype`, `oppfølgingsstatus` (deaktivert/aktiv). |
| Fritekst-søk på navn | Klient-side Fuse.js på navn/organisasjon/API | Søke-skopen må strammes inn til navn; bør flyttes server-side. |
| Filter på organisasjon | `OrganisationConnectionEnum` (Alle/Tilknyttet/IkkeTilknyttet) | Krever ny filter-struktur — picker for spesifikk organisasjon, ikke connection-status. |
| Synlighet styres av admin-rettigheter | Ingen rettighets-filtrering i klient | Helt nytt — se "Permissions" under. |

Komponenter:
- Liste-parent: [Maskinbrukere.tsx](src/domains/support/features/Maskinbrukere/Maskinbrukere.tsx)
- Resultat-liste: [MaskinbrukereResultList.tsx](src/domains/support/features/Maskinbrukere/components/MaskinbrukereResultList.tsx)
- Filter-UI: [MaskinbrukereSearchFilter](src/domains/support/features/Maskinbrukere/components/filter/MaskinbrukereSearchFilter/), [MaskinbrukereFilter.tsx](src/domains/support/features/Maskinbrukere/components/MaskinbrukereFilter.tsx)
- State-hook: [useGetMaskinbrukereState.tsx](src/domains/support/features/Maskinbrukere/hooks/useGetMaskinbrukereState.tsx)
- Data-hook: [useGetMaskinbrukere.ts:65](src/domains/support/features/Maskinbrukere/hooks/useGetMaskinbrukere.ts#L65)

### Detaljside (i dag)

- Hovedkomponent: [Maskinbruker.tsx:21-54](src/domains/support/features/MaskinBruker/Maskinbruker.tsx#L21-L54), 2 tabs (`data` / `api`).
- Datablokker: [MaskinbrukerInformation.tsx:31-119](src/domains/support/features/MaskinBruker/components/MaskinbrukerInformation/MaskinbrukerInformation.tsx#L31-L119)
  - Navn-seksjon: brukernavn + organisasjon
  - Kontaktinfo-seksjon: navn, e-post, telefon (read-only)
  - API-tilganger-seksjon: tags
  - Passord-seksjon (kun hvis `trengerPassordbytte`)
- **Sporingsinfo (`opprettet av/tidspunkt`, `endret av/tidspunkt`)** finnes ikke i UI i dag.
- **Miljøer** vises ikke som egen datagruppe.
- **`Ansvarlig`** finnes ikke som konsept — i dag bare `kontaktperson` (lese-felt fra Kontaktperson-entitet).
- **`Beskrivelse`** finnes ikke i UI.

### Roller-tabs (i dag)

- To separate tabs: `ApiTilganger` ([ApiTilganger.tsx:15-30](src/domains/support/features/MaskinBruker/components/ApiTilganger/ApiTilganger/ApiTilganger.tsx#L15-L30)) og `DataTilganger` ([DataTilganger.tsx:15-30](src/domains/support/features/MaskinBruker/components/DataTilganger/DataTilganger.tsx#L15-L30)).
- Krav-modellen forventer **én** "Roller"-tab med rollekode + miljø — vår nåværende oppsplitting er smalere/dypere.
- Filter: API-checkbox + sortering på rollekode/beskrivelse/apiNavn ([useGetMaskinbruker.ts:228-239](src/domains/support/features/MaskinBruker/hooks/useGetMaskinbruker.ts#L228-L239)). Krav forventer filter på **miljø** og **rolle**.
- Paginering: ingen i dag — krav forventer 50 om gangen.

### Passordbytte (i dag)

- [MigrerPassordDialog.tsx:27-128](src/domains/support/features/MaskinBruker/components/MigrerPassord/MigrerPassordDialog.tsx#L27-L128)
- Mutation: `genererOgSettNyttPassord` finnes allerede.
- Flyt matcher krav (BRU-APP-API-004) godt: generate → vise skjult/copy → kan ikke hentes igjen.
- **Avvik**: knappen er bundet til `trengerPassordbytte`-flagget. Krav: alle administratorer med rettighet skal kunne gjøre passordbytte når som helst — flagget bør drive en egen indikator, ikke gate selve knappen.
- **Avvik #2**: Krav gjelder **kun** FS-applikasjoner (basic auth). Feide/Maskinporten-applikasjoner skal ikke kunne bytte passord. Per nå er det ingen `autentiseringstype`-skille.

### GraphQL-flate (i dag)

- Type: [`Maskinbruker`](schema.graphql#L19692) — fields: `apiTilganger`, `apiTilgangerV2`, `brukernavn`, `database`, `datatilganger`, `harApiTilgangTilalleOrganisasjoner`, `id`, `kontaktperson`, `nyttPassordHash`, `organisasjon`, `passordHash`, `trengerPassordbytte`.
- Filter-input [`MaskinbrukereFilter`](schema.graphql#L19756): kun `trengerPassordBytte: Boolean`.
- Mutations: `genererOgSettNyttPassord` ([schema.graphql#L20840](schema.graphql#L20840)). Deprecated: `xxxNullUtPassord` ([schema.graphql#L22098](schema.graphql#L22098)).
- **Helt fraværende på schema-nivå:**
  - `autentiseringstype` (FS/Feide/Maskinporten)
  - `beskrivelse`, `ansvarlig`, `miljøer`, `aktiv` på Maskinbruker
  - Sporingsfelt (`opprettetAv`, `opprettetTidspunkt`, `endretAv`, `endretTidspunkt`)
  - Mutations: `opprett*`, `deaktiver*`, `reaktiver*`, `tilordneRolle*`, `fjerneRolle*`, `settAnsvarlig*`, `redigerBeskrivelse*`
  - Permission-relevante typer (admin-roller på bruker)

### Auth / brukerkontekst (i dag)

- Globalt user-context i [src/common/lib/auth/](src/common/lib/auth/), med hooks som `useAdmissioUserInfo`, `useMeMetaInformation`, `useAdmissioUserActions`.
- **Ingen** referanse til `applikasjonsadministrator`, `super-applikasjonsadministrator`, eller analog rolle-konstant i kodebasen i dag.
- Larested-cookie-mekanisme finnes (`fsadmin_selected_larested`), men ingen org-scoped admin-flagg.

### Eksterne flyter (i dag)

- "Ny tilgang"-knapp: [NyTilgangButton.tsx:16](src/domains/support/features/components/NyTilgangButton/NyTilgangButton.tsx#L16) lenker til `https://nettskjema.no/a/324543` for opprettelse + rolle-endringer. Iterasjon 3 erstatter denne med in-app flyter.

### i18n (i dag)

- [src/common/messages/nb/support.json](src/common/messages/nb/support.json) — ~30 nøkler under `Maskinbrukere`/`Maskinbruker`/`MaskinbrukerMigrerPassordDialog` etc.
- Termen "Maskinbruker" er gjennomgående brukervendt (ikke bare et internt navn).
- "API-bruker" finnes også som begrep — krav-modellen kaller dette nå "applikasjon".

### Tester / Storybook (i dag)

- **0** filer med `.test.tsx`, `.a11y.test.tsx` eller `.stories.tsx` i `src/domains/support/features/Maskinbruker*` eller `src/domains/support/features/MaskinBruker/**`.
- CLAUDE.md krever obligatorisk a11y-test per komponent — eksisterende kode oppfyller ikke dette.

## Key Findings

1. **Stor terminologisk forskyving**: `Maskinbruker` → `Applikasjon`, `kontaktperson` → `ansvarlig`, "API-bruker" → "applikasjon". Dette er ikke en intern omdøping, det treffer routes, i18n, GraphQL-felter, brødsmuler, kommandopalett-treff og storyboard-eksterne dokumenter.
2. **Schema-gap er arkitekturens flaskehals.** ~80% av krav-funksjonaliteten avhenger av felter og mutations som ikke finnes i `schema.graphql` i dag. Iterasjonene kan ikke implementeres ferdig før upstream supergraf-skjemaet utvides — fs-admin er bare leveransen.
3. **Ny rolle-modell mangler helt.** `applikasjonsadministrator` / `super-applikasjonsadministrator` — krever både schema-side modellering og frontend-rettighets-gating med organisasjons-skopering.
4. **Autentiseringstype-skille er fundamentalt.** UI-flyter forgrener på FS / Feide / Maskinporten ved opprettelse, ved passordbytte (kun FS), ved verifikasjon (eksternt oppslag mot Feide / Maskinporten). Maskinporten-verifikasjon er en ny ekstern integrasjon.
5. **Søk + paginering må re-arkitekteres.** Dagens 1000-rader-klient-Fuse.js bryter med kravet om server-side 50-batches. Dette er en arkitekturendring, ikke et oppussings-tweak.
6. **Roller-modellen kollapser.** Dagens to tabs (ApiTilganger + DataTilganger) blir én "Roller"-tab i krav-modellen, men dimensjonene er rolle × miljø — ikke API × tilgang. Det er sannsynlig at den underliggende `apiTilgangerV2` / `datatilganger`-modellen må slås sammen til én rolle-graf på upstream-skjemaet.
7. **Eksisterende passordbytte-flyt kan gjenbrukes** med to justeringer: koble ut `trengerPassordbytte`-gating, og legg til `autentiseringstype === 'FS'` som forutsetning.
8. **Test-debt blokkerer trygg endring.** 0 tester i hele Maskinbruker-domenet. Hver endring i Iterasjon 2 risikerer regresjon i CLOSED sub-issues #32/#33-funksjonalitet uten en test-base først.
9. **`# GitHub:`-marker-konvensjonen brukes** i de nye krav-filene (linje 2 i hver `.feature` peker tilbake til saksnummer). Dette er nytt for fs-krav og gjør sporbarhet enklere — bør tas i bruk i Mikado-roadmaps.
10. **Kontaktperson ≠ ansvarlig.** I dag er `kontaktperson` en egen `Kontaktperson`-entitet. Krav definerer `ansvarlig` som en **Feide-bruker** (eller @could Feide-gruppe) fra applikasjonens organisasjon. Disse er to ulike domene-konsepter — kontaktperson sannsynligvis fortsatt relevant, men ansvarlig kommer som et nytt ortogonalt felt.

## Technical Constraints

- **CLAUDE.md (rot):** Hver komponent **må** ha `*.a11y.test.tsx`. GraphQL-queries skal ligge nær komponenten, ikke deles på tvers av features.
- **CLAUDE.md (rot):** Norsk forretningsspråk, engelsk kodespråk — komponentnavn forblir engelske selv ved omdøping (men "Maskinbruker" er allerede norsk og gjennomgående). Renaming er sannsynligvis: filsti-segmenter `maskinbrukere` → `applikasjoner`, komponentnavn `Maskinbruker` → `Applikasjon`, men brukernavn-feltet på selve entiteten heter fortsatt `brukernavn`.
- **Sikt Design System (`@sikt/sds-*`)** er pålagt — ingen generiske UI-libs.
- **Apollo Client 4** med data-masking via Apollo (ikke fragment masking fra codegen).
- **Next.js 16 App Router** med Webpack-bundler. `next typegen` brukes for typede ruter — endring av URL-segmenter må følges av regenerering.
- **next-intl** med kun `nb`-locale — i18n-nøkler under [src/common/messages/nb/support.json](src/common/messages/nb/support.json).
- **Ingen Pages Router** — alle nye sider via App Router.
- **Coverage-terskler:** 60 % branches/functions/lines, 90 % statements (`npm run test:sincemain`).
- **Schema-styrt utvikling:** `schema.graphql` er upstream-eid. fs-admin kan ikke utvide schemaet — endringer må skje i `sikt-no/fs`/SuperGrafen først.
- **Permissions-skopering:** ny rolle-modell må kunne svare på "har bruker X rettighet til org Y for handling Z?" — sannsynlig server-side i schema (felt på `Me` eller `Maskinbruker`), ikke ren klient-policy.

## Dependencies

### Internal (fs-admin)

- [`globalUserContext`](src/common/lib/auth/globalUserContext.tsx) — må utvides med admin-roller for applikasjoner.
- [TilgangsstyringIndex](src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.tsx) — sannsynlig oppdatert tittel/beskrivelse ved omdøping.
- [CommandPalette useCommands.tsx](src/domains/search/features/CommandPalette/hooks/useCommands.tsx) — har "Maskinbruker"-treff som må navne-renames.
- Eksisterende [MigrerPassord*](src/domains/support/features/MaskinBruker/components/MigrerPassord/) — gjenbrukbart men trenger justert gating.
- [NyTilgangButton.tsx](src/domains/support/features/components/NyTilgangButton/NyTilgangButton.tsx) — Nettskjema-lenken erstattes; komponenten kan gå.

### External (utenfor fs-admin)

- **`sikt-no/fs` (SuperGrafen-schema)** — eier av `Maskinbruker`/`Applikasjon`-typen. ~6-10 nye mutations + 5+ nye felter må legges til før fs-admin kan bygge tilsvarende UI. **Dette er den kritiske avhengigheten — uten schema, ingen leveranse.**
- **Feide-API (Identity Provider)** — verifisering av Feide-bruker / Feide-gruppe (for `ansvarlig`) og av Feide-applikasjons-ID ved opprettelse.
- **Maskinporten-API** — verifisering av Maskinporten-klient-ID ved opprettelse. Ny integrasjon — er ikke i bruk fra fs-admin i dag.
- **Confluence (Discovery: Registrer applikasjon, side 4612784227)** — referert i `opprette_applikasjon.feature`. Kan inneholde flyt-detaljer som ikke står i `.feature`-filen.

### Cross-agent

> **Note:** `$COORD_REPO`-protokollen er aktiv her — coord-sync header viser `coord-sync (fs-admin @ fruitbat)`. Alle hand-offs nedenfor er kandidater for `agent-coord`-flyt. Brukeren tar avgjørelsen om hvilke som faktisk filerer som issues på andre agenters kø.

- **Target: `fs` / supergrafen-eier** — utvidelse av Maskinbruker/Applikasjon-schemaet. Trolig den største blokkereren. Kandidat for hand-off med `# GitHub:`-markert intent for hvert manglende felt og hver mutation.
- **Target: `fs` / krav-eier** — bekreftelse på navn-konvensjon (`maskinbruker` vs `applikasjon` i runtime-API), om `kontaktperson` skal fases ut eller leve videre ved siden av `ansvarlig`, og om "Maskinporten" som autentiseringstype krever ny ekstern integrasjon på backend-siden.
- **Target: design-/UX-agent (om eksisterer)** — visuell utforming av tabs (én Roller-tab vs. dagens to), rolle-tilordning-dialog (multi-select i ett miljø), bekreftelses-dialoger, og samspill mellom listevisningens "Oppfølgingsstatus"-kolonne og Iterasjon 3-deaktivering.

## Requirements Impact

Det finnes ingen `docs/ACTIVE/requirements-*.md` i dag, så delen "Requirements addressed/at risk" er ikke applikabel her. Krav-grunnlaget er `.feature`-filene selv; eventuelle prosjekt-overordnede krav-dokumenter er ikke i bruk i fs-admin-rommet.

**Discovered gaps relativt til krav (BRU-APP-API-001 til 010):**

- BRU-APP-API-001 *Listevisning og søk* — delvis dekket; trenger arkitekturendringer.
- BRU-APP-API-002 *Se detaljer* — delvis dekket; sporings-info og miljøer mangler.
- BRU-APP-API-003 *Vise roller* — strukturelt avvik (to tabs vs. én).
- BRU-APP-API-004 *Passordbytte* — ~80 % dekket; trenger gating-justering.
- BRU-APP-API-005 *Administrere ansvarlig* — ikke dekket.
- BRU-APP-API-006 *Redigere beskrivelse* — ikke dekket.
- BRU-APP-API-007 *Tilordne rolle* — ikke dekket (ekstern flyt i dag).
- BRU-APP-API-008 *Fjerne rolle* — ikke dekket (ekstern flyt i dag).
- BRU-APP-API-009 *Opprette applikasjon* — ikke dekket (ekstern flyt i dag).
- BRU-APP-API-010 *Deaktivere* — ikke dekket.

## Krav-input fra GitHub

- **Kilde:** issues `#31` (initiativ) → `#434` (Iter 2) + `#435` (Iter 3) og deres sub-issues `#438-#447` (+ referansene `#448-#451`)
- **Linket PR(s):** ingen — krav lever direkte på branchen `fruitbat`
- **Repo / ref:** `sikt-no/fs` @ `fruitbat`
- **Hentede `.feature`-filer:** se [krav-input/manifest.md](krav-input/manifest.md) for full liste med klikkbare lenker
- **Hentet:** 2026-05-02

## Open Questions

- [ ] **Schema-eierskap & timing:** Når blir Maskinbruker → Applikasjon-utvidelsen tilgjengelig på SuperGrafen? Er det realistisk å parallellisere fs-admin-arbeid mot et stub-schema, eller venter vi på upstream først?
- [ ] **Rename-strategi:** Skal vi gjøre full renaming `Maskinbruker → Applikasjon` (route-segment, komponentnavn, i18n, command palette) i samme leveranse som Iterasjon 2, eller er en kompatibilitetsperiode (alias-route, dobbel i18n) ønskelig? Konsekvenser for bookmarks, dypere lenker, og support-kommunikasjon.
- [ ] **Kontaktperson vs ansvarlig:** Skal `kontaktperson` fases ut eller leve videre ved siden av `ansvarlig`? Krav-tekstene snakker bare om `ansvarlig`, men fjerning av `kontaktperson` fra dagens detaljside kan bryte etablert support-flyt.
- [ ] **Roller-tab-konsolidering:** Slås `ApiTilganger`/`DataTilganger` sammen til én "Roller"-tab? I så fall: er det riktig å skifte fra dagens API × tilgang-modell til rolle × miljø-modell, eller er begge dimensjonene fortsatt relevante?
- [ ] **Permission-modell:** Hvor bor "har X rettighet til Y" — på `Me`-typen i schemaet, som mutation-feilkode, eller som klient-side policy? Dette avgjør UI-arkitektur (hvilke knapper må vi skjule før mutation, hvilke kan vi la brønne opp).
- [ ] **Maskinporten-integrasjon:** Hvor verifiseres Maskinporten-ID — i fs-admin (BFF), i SuperGrafen-resolveren, eller direkte mot Maskinporten? Svaret påvirker både feilhåndtering og autentisering.
- [ ] **Test-strategi for renaming:** Bygger vi a11y/unit-tester for dagens `Maskinbruker*`-komponenter **før** vi renameser, eller skriver vi nye tester på `Applikasjon*` etter renameset? Førstnevnte gir bedre regresjonsvern; sistnevnte gir mindre dødvekt.
- [ ] **Iterasjons-rekkefølge i fs-admin:** Krav antar at Iter 2 leveres før Iter 3. Skal vi følge samme rekkefølge, eller pakke renaming + opprette-flyt i én tidlig leveranse for å unngå dobbel turbulens i routing/i18n?
- [ ] **Kommunikasjon utad:** Brukervendt språk skifter (Maskinbruker → Applikasjon, kontaktperson → ansvarlig). Trenger vi en intern release-note og support-tale eller kan endringen "bare lande"?
- [ ] **Endringslogg (Iter 4 / #436):** Iterasjon 4 er ikke i scope nå, men `endringslogg.feature` på `fruitbat` antyder at sporings-felter må modelleres allerede i Iter 2/3. Skal sporing innføres "ferdig" nå (felt + visning), eller kun strukturelt (felt) nå og UI senere?
