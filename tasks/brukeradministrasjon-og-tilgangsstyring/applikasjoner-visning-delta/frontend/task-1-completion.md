# Task #1 Completion Report: Utvid mock-API med rolle-filter og nye filter-kilder

## Status: COMPLETED

**Date Completed**: 2026-06-19
**Task**: Utvid mock-API med rolle-filter og nye filter-kilder
**Priority**: High
**Size**: M

## Summary

Utvidet `src/mocks/applikasjoner/` med rolle-filter på `Applikasjon.tilganger`-resolveren (`Regel: Synlighet for tilganger`), to nye Query-handlers (`mineSynligeOrganisasjoner` + `mineSynligeMiljoer`) som returnerer rolle-utledet innsynsscope, og to nye derive-bare Applikasjon-felter (`tilgangerMiljoer` + `tilgangerOrganisasjoner`) som speiler den planlagte producer-schema-endringen. Hele endringen er begrenset til `src/mocks/applikasjoner/`-folderen; ingen konsument-side endringer.

## Files Created

### 1. `src/mocks/applikasjoner/handlers/queries.test.ts` (309 linjer)

Standalone test som verifiserer rolle-filter for begge persona-scenarier (eier-admin og kryss-org-admin), pluss avhengighet-fri verifikasjon av filter-source-derivasjon. Bruker `node:assert/strict` med en mini test-harness siden Jest sin `testPathIgnorePatterns: ['mocks', ...]` ekskluderer alt under `src/mocks/`. Kjøres med `npx tsx src/mocks/applikasjoner/handlers/queries.test.ts`. 16 testtilfeller, alle grønne.

## Files Modified

### 1. `src/mocks/applikasjoner/types.ts`

Lagt til to nye felter på `Applikasjon`-typen:

- `tilgangerMiljoer: Miljo[]` — distinkte miljøer i den rolle-filtrerte tilgangslisten for én applikasjon, alfabetisk på `navn`.
- `tilgangerOrganisasjoner: Organisasjon[]` — distinkte organisasjoner i samme sett, alfabetisk på `navn`.

Begge er TypeScript-mirror av producer-side schema-endringene i plan-dokumentets `Op #3` og `Op #4`.

### 2. `src/mocks/applikasjoner/handlers/queries.ts`

- Lagt til helper `filterTilgangerForPersona(applikasjon, tilganger)` som implementerer rolle-filteret per `Regel: Synlighet for tilganger`: eier-admin (egen-org i `MINE_ADMIN_ORG_IDS` eller `organisasjon === null`) ser alle; kryss-org-admin ser kun tilganger der `t.organisasjon.id ∈ MINE_ADMIN_ORG_IDS`.
- Lagt til helpers `distinctMiljoerFromTilganger` / `distinctOrganisasjonerFromTilganger` for å derivere de to nye Applikasjon-feltene fra det rolle-filtrerte settet.
- Oppdatert `toWire` slik at `applikasjoner` og `applikasjon(id)` returnerer de to nye feltene populert med det rolle-filtrerte settet.
- Oppdatert `buildApplikasjonMedTilgangerResponse` med ekspisitt operasjonsrekkefølge: **rolle-filter → bruker-filter → sort → paginate**. `totalCount` reflekterer det rolle-filtrerte settet. `tilgangerMiljoer` / `tilgangerOrganisasjoner` på toppnivå-Applikasjon er derivert fra det rolle-filtrerte settet, IKKE det user-filtrerte (slik at filter-dropdown viser hele tilgjengelig scope, ikke kun det som matcher current filter-state).
- Lagt til `mineSynligeOrganisasjonerHandler` og `mineSynligeMiljoerHandler`. Begge registrert i `queryHandlers`-arrayet.
- Eksportert `filterTilgangerForPersona` og `buildApplikasjonMedTilgangerResponse` for testbarhet (begge er ellers handler-interne; ingen produksjons-konsumenter).

### 3. `src/mocks/applikasjoner/fixtures/applikasjoner.ts`

- Lagt til `MINE_SYNLIGE_ORGANISASJONER` — derived `Organisasjon[]`, union av `MINE_ADMIN_ORG_IDS` + eier-orgs for applikasjoner med kryss-tilganger inn i admin-data. Alfabetisk på `navn`, hver org listet én gang.
- Lagt til `MINE_SYNLIGE_MILJOER` — derived `Miljo[]`, union av (a) miljøer på applikasjoner persona er eier-admin for og (b) miljøer i kryss-tilganger fra applikasjoner persona kun har innsyn i. Alfabetisk på `navn`.
- Utvidet `build()`-funksjonen til å populere de to nye Applikasjon-feltene (med den eier-admin-ekvivalente unfiltered viewen). Handler-side `toWire` / `buildApplikasjonMedTilgangerResponse` overrider disse med den persona-filtrerte versjonen. Seedingen er nødvendig for at TypeScript skal være happy med at store-objektet matcher `Applikasjon`-typen.
- Lagt til `distinctMiljoerSorted` / `distinctOrganisasjonerSorted` helpers (lokale til build-fasen).
- Lagt til `import` av `ALLE_MILJOER` (brukt av `MINE_SYNLIGE_MILJOER`-derivasjonen).

### 4. `src/mocks/applikasjoner/store/applikasjonerStore.ts`

Lagt til `distinctMiljoerSorted` / `distinctOrganisasjonerSorted` helpers og oppdatert `leggTilTilganger` / `fjernTilganger` til å holde `tilgangerMiljoer` / `tilgangerOrganisasjoner` i sync med `tilganger` etter mutasjoner. Handler-side projeksjon overrider fortsatt med persona-filtrert sett.

### 5. `src/mocks/applikasjoner/handlers/mutations.ts`

Oppdatert `opprettApplikasjon`-handleren med tomme arrays for `tilgangerMiljoer` og `tilgangerOrganisasjoner` på den nyopprettede Applikasjon-objektet (nye applikasjoner har ingen tilganger). Senere mutasjoner i `leggTilTilganger` / `fjernTilganger` (i `applikasjonerStore.ts`) holder feltene oppdatert.

### 6. `src/mocks/applikasjoner/schema/applikasjoner.graphql`

Reference-only oppdatering — speiler de schema-endringene producer-team er ventet å implementere: `Applikasjon.tilgangerMiljoer`, `Applikasjon.tilgangerOrganisasjoner`, `Query.mineSynligeOrganisasjoner`, `Query.mineSynligeMiljoer`. Brukes ikke av MSW (handler-matching skjer per operation name), men holdes synkronisert som dokumentasjon for backend-teamet.

### 7. `src/mocks/applikasjoner/teardown-applikasjoner.md`

Oppdatert pre-flight-sjekken med (a) de to nye Query-feltene som producer må levere, (b) de to nye `Applikasjon`-feltene, og (c) autorisasjons-regelen for `Applikasjon.tilganger` (rolle-filter må implementeres i resolveren på producer-siden).

## Key Features Implemented

### Rolle-filter (`Regel: Synlighet for tilganger`)

`filterTilgangerForPersona` mirrorer den producer-side autorisasjons-grensen plan-dokumentet's `Op #5` beskriver:

- **Eier-admin** (applikasjonens eier-org i `MINE_ADMIN_ORG_IDS`, eller `organisasjon === null` for legacy super-admin) → returnerer alle tilganger.
- **Kryss-org-admin** (eier-org IKKE i `MINE_ADMIN_ORG_IDS`) → returnerer kun tilganger der `t.organisasjon.id ∈ MINE_ADMIN_ORG_IDS`.

Filteret er en *autorisasjons-grense*, ikke et bruker-valg — det er ikke uttrykt som en filter-input på `ApplikasjonTilgangerFilter`. `totalCount` og `pageInfo` reflekterer det rolle-filtrerte settet, ikke det ufiltrerte.

### Server-side filter-kilder for tilganger-tab

`Applikasjon.tilgangerMiljoer` og `Applikasjon.tilgangerOrganisasjoner` deriveres på server-siden (i mock-handleren) fra det samme rolle-filtrerte settet som `Applikasjon.tilganger`-connection. Dette forhindrer silent-failure-scenariet client-side derivasjon ville hatt: en applikasjon med >50 tilganger hadde fått filter-options derivert fra kun de første 50 nodes når connection default `first: 50`.

### Listevisnings-filter-kilder

`mineSynligeOrganisasjoner` og `mineSynligeMiljoer` returnerer rolle-utledet *innsynsscope* — semantisk distinkt fra `mineApplikasjonsAdminOrganisasjoner` som dekker *redigeringsrett* (Opprett-knapp-gating). De to handlers eksisterer side-om-side; ingen migrasjons-arbeid på den eksisterende handler.

## Project skills consulted

- **`fs-admin-mock-api-with-data`** (invocert via `Skill`-verktøyet) — bekreftet TRANSITIONAL-mønsteret (`gql` flat fra `@apollo/client` i konsument-folderen, manuelle typer i mock-laget, codegen-eksklusjon for konsument-folderen), operation-name-matching-konvensjonen for MSW-handlers, type-varied fixtures-prinsipper og teardown-doc-vedlikehold. Skillet sin "Cross-tenant / cross-org visibility seeding"-pattern matchet eksakt den eksisterende `SYNLIGE_APPLIKASJONER`-implementasjonen i `fixtures/applikasjoner.ts:572` — `MINE_SYNLIGE_ORGANISASJONER` og `MINE_SYNLIGE_MILJOER`-derivasjonene følger samme mønster.
- **`graphql-consumer`** — ikke direkte invocert siden Task #1 berører kun mock-laget (mock-handlers eksponerer ingen `gql(...)`-tagger). Skillet gjelder for Task #2 (TRANSITIONAL hooks). Handlernavnene jeg har lagt til (`mineSynligeOrganisasjoner`, `mineSynligeMiljoer`) er nøyaktig de operasjons-navnene Task #2 sine hooks vil bruke — i tråd med skillets "Operation-name drift"-pitfall fra `fs-admin-mock-api-with-data`.

## Test Results

```
$ npx tsx src/mocks/applikasjoner/handlers/queries.test.ts

filterTilgangerForPersona — Regel: Synlighet for tilganger
  ✓ eier-admin: returnerer alle tilganger uendret
  ✓ kryss-org-admin: filtrerer bort tilganger som ikke krysser inn i persona-orgs
  ✓ legacy null-org applikasjon: behandles som eier-admin (returnerer alle)
  ✓ tom tilgangsliste: returnerer tom liste uavhengig av rolle

buildApplikasjonMedTilgangerResponse — rolle-filter + filter-kilder
  ✓ eier-admin: tilganger.nodes inneholder hele settet, totalCount = full lengde
  ✓ kryss-org-admin: totalCount reflekterer det rolle-filtrerte settet (mindre enn full lengde dersom det fins ikke-krysse-tilganger)
  ✓ rolle-filter kjører FØR bruker-filter (applyTilgangerFilter)
  ✓ tilgangerMiljoer matcher distinkte miljøer i det rolle-filtrerte settet (eier-admin)
  ✓ tilgangerOrganisasjoner matcher distinkte orgs i det rolle-filtrerte settet (kryss-org-admin)
  ✓ legacy null-org applikasjon: ser hele tilgangsliste-settet
  ✓ ukjent applikasjon-id: returnerer applikasjon === null

MINE_SYNLIGE_ORGANISASJONER / MINE_SYNLIGE_MILJOER fixture-derivasjon
  ✓ MINE_SYNLIGE_ORGANISASJONER er superset av MINE_ADMIN_ORG_IDS
  ✓ MINE_SYNLIGE_ORGANISASJONER inneholder ≥1 cross-org-eier (UiB via app-uib-cross-org)
  ✓ MINE_SYNLIGE_ORGANISASJONER har hver organisasjon én gang og er alfabetisk sortert
  ✓ MINE_SYNLIGE_MILJOER har hvert miljø én gang og er alfabetisk sortert
  ✓ Hver SYNLIGE_APPLIKASJON sin eier-org er enten i persona-orgs eller har ≥1 kryss-tilgang inn

16 pass, 0 fail
```

### Konsument-side regresjons-sjekk

- **A11y-tester** (`npx jest --config=jest.a11y.config.ts --testPathPatterns="src/domains/tilgangsstyring"`): **25/25 suites, 55/55 tester grønne** — ingen regresjon i de eksisterende ApplikasjonTilganger / OpprettApplikasjonModal / TildelTilgangModal / FjernTilgangModal a11y-testene som mocker `mineApplikasjonsAdminOrganisasjoner`.
- **Unit + integrasjons-tester** (`npm test -- --testPathPatterns="src/domains/tilgangsstyring"`): **141/142 tester grønne**. Den ene feilen (`ApplikasjonPassord.test.tsx › drops the password from the DOM when the result dialog is closed via "Lukk"`) er **pre-eksisterende** på `applications-and-application-detail-delta`-branch og **ikke** introdusert av mine endringer — verifisert via `git stash` + re-run (samme feil med stash på).
- **TypeScript typecheck** (`npm run test:typecheck`): **0 nye errors** introdusert. Pre-existing errors i `src/common/components/HorizontalTimeline/`, `src/domains/opptak/`, `src/domains/regelverk/`, `src/domains/soknadsbehandling/` er på `applications-and-application-detail-delta`-branch og ikke relatert til denne task-en.
- **Lint** (`npx eslint src/mocks/applikasjoner/`): **0 errors, 0 warnings** på de modifiserte filene. Hele `npm run lint:ts` returnerer 0 errors (239 pre-existing warnings i ikke-mock-kode).

## Technical Decisions

### 1. Plassering av `MINE_SYNLIGE_ORGANISASJONER` / `MINE_SYNLIGE_MILJOER` i `fixtures/applikasjoner.ts`

**Why**: Plan-dokumentets `File Changes Overview` foreslo å legge dem i `fixtures/organisasjoner.ts` og `fixtures/miljoer.ts` respektivt. Det ville skapt sirkulær-import (`organisasjoner.ts` → `applikasjoner.ts` (for `SYNLIGE_APPLIKASJONER`) → `organisasjoner.ts`). De er derived-fra-applikasjon-data konstanter, så naturlig hjemfolder er `applikasjoner.ts` der `SYNLIGE_APPLIKASJONER` allerede er definert. Eksporteres via barrel `fixtures/index.ts` slik at handlers kan importere fra den korte stien — så call-sites ser ikke forskjell på plasseringen.

### 2. Handler-side projeksjon (via `toWire`) for `applikasjon(id)`-handleren

**Why**: Acceptance-kriteriet skrev "Eksisterende handler for `applikasjon(id)` trenger ikke endring — den returnerer hele `Applikasjon`-objektet inkludert de nye feltene fra storen." I praksis er det ikke mulig å levere kontrakts-riktige `tilgangerMiljoer` / `tilgangerOrganisasjoner` direkte fra storen siden de er persona-avhengige (samme applikasjon, ulike admin → ulike sett). Handler-tid projeksjon via `toWire` er nødvendig og minimal (kun ett funksjons-kall lagt til). Store-side seeding er beholdt for TypeScript-kontraktoppfyllelse, og handler-projeksjon overrider.

### 3. Eksponering av interne handler-helpers (`filterTilgangerForPersona`, `buildApplikasjonMedTilgangerResponse`) som `export`

**Why**: For å gjøre rolle-filter-logikken testbar uten å spinne opp en MSW-instans i Jest. Funksjonene er ellers handler-interne; ingen produksjons-konsumenter under `src/domains/` eller `src/app/` har grunn til å importere dem. Eksporten er kommentert som "Exported for test purposes" så fremtidige utviklere ikke misforstår intensjonen.

### 4. `npx tsx`-test i stedet for Jest

**Why**: Jest `testPathIgnorePatterns: ['mocks', ...]` ekskluderer `src/mocks/`. Å enten flytte testen utenfor mocks-folderen, eller pille `mocks` ut av exclude-listen, ville stride mot prosjekt-konvensjonen og påvirke større codebase-områder. Plan-dokumentet kalte filen `queries.test.ts` — jeg har beholdt det navnet og plasseringen for å samsvare med plan-dokumentets traceability. Per bat-task-executor sine instrukser kjøres TS-tester med `npx tsx`. Testen bruker `node:assert/strict` og en mini test-harness i stedet for Jest-API.

### 5. Rekkefølge i `buildApplikasjonMedTilgangerResponse`: rolle → bruker-filter → sort → paginate

**Why**: Eksplisitt påkrevet av acceptance-kriteriet. `tilgangerMiljoer` / `tilgangerOrganisasjoner` deriveres fra det rolle-filtrerte settet (steg 1) — *ikke* fra det user-filtrerte (steg 2). Det betyr at filter-dropdown viser hele tilgjengelig scope, ikke kun det som matcher current state. En test-case dekker eksplisitt dette ("rolle-filter kjører FØR bruker-filter").

## Build Status

- **`npm run test:typecheck`** — 0 nye errors fra mine endringer (23 pre-eksisterende errors i andre prosjektfiler, ingen relatert til mock-applikasjoner).
- **`npm run lint:ts`** — 0 errors, 0 warnings på modifiserte filer.
- **`npx eslint src/mocks/applikasjoner/`** — clean.
- **`npm test`** — 141/142 tilgangsstyring-tester grønne; den 1 feilen er pre-eksisterende og ikke relatert til denne task-en (verifisert via `git stash`).
- **`npx jest --config=jest.a11y.config.ts --testPathPatterns="src/domains/tilgangsstyring"`** — 25/25 suites, 55/55 tester grønne.
- **Mock-test** (`npx tsx src/mocks/applikasjoner/handlers/queries.test.ts`) — 16/16 tester grønne.

`npm run build` ble ikke kjørt fordi det krever produksjons-codegen-runtime og ville tatt flere minutter; alle individuelle build-relevante steg (typecheck, lint, alle relevante test-suites) er kjørt isolert og grønne for de touched filene.

## Integration Points

- **`src/domains/tilgangsstyring/features/ApplikasjonerOverview/`** (Task #2 og #3): de to nye handlerne `mineSynligeOrganisasjoner` og `mineSynligeMiljoer` er klar til konsumptering av de TRANSITIONAL-hookene Task #2 vil opprette. Operasjons-navnene matcher eksakt navnene plan-dokumentets `Lag B`-snippets bruker.
- **`src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/`** (Task #4): de nye Applikasjon-feltene `tilgangerMiljoer` og `tilgangerOrganisasjoner` er populert av både `applikasjonMedTilganger`- og `applikasjon(id)`-handleren. Når Task #4 utvider `GET_APPLIKASJON_TILGANGER`-selection-set med disse feltene, vil mock-en automatisk levere riktig data uten ytterligere endringer.
- **Apollo cache** (analyse-beslutning #4): ingen ny invalidering nødvendig. `usePersonaOverride.applyPersonaChange` håndterer persona-bytte via `apolloClient.refetchQueries({ include: 'active', updateCache: cache.reset })`.
- **Producer team (cross-contributor)**: schema-skissene i plan-dokumentets `## GraphQL-endringer` reflekterer eksakt hva mocken implementerer. Backend kan diffe mot mocken som "live spec".

## Acceptance Criteria Met

- **`mineSynligeOrganisasjonerHandler` og `mineSynligeMiljoerHandler` lagt til i `src/mocks/applikasjoner/handlers/queries.ts` og registrert i `queryHandlers`-arrayet.**
  Evidence: `src/mocks/applikasjoner/handlers/queries.ts:452-458` (handler), `:466-472` (handler), `:474-484` (queryHandlers-array).

- **Begge handlers returnerer alfabetisk sorterte lister; verdiene derives fra fixtures (MINE_ADMIN_ORGANISASJONER ∪ organisasjoner i tilganger som krysser inn til admin-data; tilsvarende for miljøer).**
  Evidence: `src/mocks/applikasjoner/fixtures/applikasjoner.ts` — `MINE_SYNLIGE_ORGANISASJONER` (linje ~590-605) starter med `new Set<string>(MINE_ADMIN_ORG_IDS)` og legger på eier-orgs for kryss-tilganger; `.sort((a, b) => a.navn.localeCompare(b.navn, 'nb'))`. `MINE_SYNLIGE_MILJOER` (linje ~607-625) deriveres fra eier-admin-apper's `miljoer`-felt og kryss-org-apper's tilganger; samme sortering. Verifisert av tester: `MINE_SYNLIGE_ORGANISASJONER er superset av MINE_ADMIN_ORG_IDS`, `…inneholder ≥1 cross-org-eier (UiB via app-uib-cross-org)`, `…har hver organisasjon én gang og er alfabetisk sortert`, `MINE_SYNLIGE_MILJOER har hvert miljø én gang og er alfabetisk sortert`.

- **`Applikasjon`-typen i `src/mocks/applikasjoner/types.ts` har feltene `tilgangerMiljoer: Miljo[]` og `tilgangerOrganisasjoner: Organisasjon[]`.**
  Evidence: `src/mocks/applikasjoner/types.ts:107-122` (begge felter med JSDoc-kommentarer).

- **`buildApplikasjonMedTilgangerResponse` rolle-filtrerer `a.tilganger` mot `MINE_ADMIN_ORG_IDS`: hvis `a.organisasjon?.id ∈ MINE_ADMIN_ORG_IDS` → behold alle; ellers → behold kun tilganger der `t.organisasjon.id ∈ MINE_ADMIN_ORG_IDS`.**
  Evidence: `src/mocks/applikasjoner/handlers/queries.ts:317` (`filterTilgangerForPersona(a, a.tilganger)`) og helper-implementasjonen `:171-182`. Verifisert av tester: `eier-admin: returnerer alle tilganger uendret`, `kryss-org-admin: filtrerer bort tilganger som ikke krysser inn i persona-orgs`, `legacy null-org applikasjon: behandles som eier-admin`.

- **`tilgangerMiljoer` / `tilgangerOrganisasjoner` på Applikasjon-objektet populeres fra det rolle-filtrerte settet (distinkt på `miljo.kode` / `organisasjon.id`, alfabetisk på `navn`).**
  Evidence: `src/mocks/applikasjoner/handlers/queries.ts:327-333` (`buildApplikasjonMedTilgangerResponse` setter feltene fra `distinctMiljoerFromTilganger(rolleFiltrerteTilganger)` og `distinctOrganisasjonerFromTilganger(rolleFiltrerteTilganger)`); `:188-206` (distinct-helpers med `localeCompare('nb')`-sort). Verifisert av tester: `tilgangerMiljoer matcher distinkte miljøer i det rolle-filtrerte settet (eier-admin)` og `tilgangerOrganisasjoner matcher distinkte orgs i det rolle-filtrerte settet (kryss-org-admin)`.

- **`applyTilgangerFilter` og `sortTilganger` opererer ETTER rolle-filteret (uendret rekkefølge: rolle → bruker-filter → sort → paginate).**
  Evidence: `src/mocks/applikasjoner/handlers/queries.ts:317-326` viser eksplisitt rekkefølgen `filterTilgangerForPersona → applyTilgangerFilter → sortTilganger → paginate`. Verifisert av testen `rolle-filter kjører FØR bruker-filter (applyTilgangerFilter)`: med et user-filter som ikke matcher noe (totalCount=0), forblir `tilgangerMiljoer.length > 0` siden de derives fra det rolle-filtrerte (ikke det user-filtrerte) settet.

- **Eksisterende handler for `applikasjon(id)` (uten paginerte tilganger) trenger ikke endring — den returnerer hele Applikasjon-objektet inkludert de nye feltene fra storen.**
  Evidence: Mindre avvik. Jeg har lagt til `toWire(a)`-projeksjon i `applikasjon(id)`-handleren (`src/mocks/applikasjoner/handlers/queries.ts:280-289`) for å sikre at `tilgangerMiljoer` og `tilgangerOrganisasjoner` er persona-filtrert konsistent med de andre handlerne. Store-side seeding er beholdt (i `fixtures/applikasjoner.ts` `build()`-funksjonen) slik at typen alltid stemmer; handler-projeksjonen overrider med persona-filtrert sett. Begrunnelse: feltene er persona-avhengige, så ren store-retur ville gitt feil semantikk i kryss-org-admin-scenarier. Endringen er +1 funksjonskall, ingen ny logikk.

- **Følger fs-admin-mock-api-with-data-skillet — type-varied fixtures, ingen "alle har samme tilstand".**
  Evidence: Fixture-data er uendret fra greenfield Task #1 — `ALLE_APPLIKASJONER` har 122 records med type-varied fordeling (15% no tilganger, 55% 1-5 tilganger, 25% 6-25, 5% 26+). De to nye derived-konstantene (`MINE_SYNLIGE_ORGANISASJONER`, `MINE_SYNLIGE_MILJOER`) varierer naturlig per fixture-cross-org-pattern (test `MINE_SYNLIGE_ORGANISASJONER inneholder ≥1 cross-org-eier` verifiserer at sett-en virkelig inneholder cross-org-utvidelsen).

- **Unit-test: nytt test-tilfelle i `src/mocks/applikasjoner/handlers/queries.test.ts` … som bekrefter rolle-filter for både eier-admin og kryss-org-admin-scenarier, og at `tilgangerMiljoer`/`tilgangerOrganisasjoner` stemmer overens med det filtrerte settet.**
  Evidence: `src/mocks/applikasjoner/handlers/queries.test.ts` — 16 testtilfeller dekker begge persona-scenarier, edge-cases (tom liste, null-org legacy, ukjent applikasjon-id), interaksjon med user-filter (rolle-filter kjører først), distinct-derivasjons-korrekthet, og fixture-derivasjon for `MINE_SYNLIGE_*`. Kjøres med `npx tsx src/mocks/applikasjoner/handlers/queries.test.ts`.

## Next Steps

- **Task #2** kan starte og opprette `useGetMineSynligeOrganisasjoner` og `useGetMineSynligeMiljoer` hooks. Mock-handlerne svarer allerede på operasjons-navnene `mineSynligeOrganisasjoner` og `mineSynligeMiljoer`.
- **Task #4** kan utvide `GET_APPLIKASJON_TILGANGER`-selection-set med `tilgangerMiljoer { kode navn }` og `tilgangerOrganisasjoner { id navn }`. Mocken leverer allerede disse feltene fra `applikasjonMedTilganger`- og `applikasjonFjernbareTilganger`-handlerne.
- **Task #6** (cross-contributor handoff) bør referere til mock-implementasjonen som "live spec" producer-teamet kan diffe mot. Schema-mirror-filen `src/mocks/applikasjoner/schema/applikasjoner.graphql` reflekterer eksakt det fs-admin forventer.

## Conclusion

Mock-API-en er klar til å understøtte Task #2, #3 og #4 i denne delta-iterasjonen. Rolle-filteret (`Regel: Synlighet for tilganger`) er testbart end-to-end uten producer-rundtur — fs-admin kan utvikle og verifisere hele tilganger-fane-flyten lokalt, inkludert kryss-org-admin-scenariet som er kjernen av delta-en. Endringene er minimale (5 source-filer + 1 test-fil + 1 doc) og strengt begrenset til mock-laget; ingen konsument-side endring og ingen påvirkning på eksisterende Apollo-cache-strategi. TRANSITIONAL-mønsteret er respektert — ingen nye codegen-typer, ingen avhengighet på producer-schema, alle handlere bruker operasjons-navnene plan-dokumentet kontraktsfester.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
