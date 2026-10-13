# Task #2 Completion Report: Nye TRANSITIONAL hooks for listevisnings-filter-kilder

## Status: COMPLETED

**Date Completed**: 2026-06-19
**Task**: Nye TRANSITIONAL hooks for listevisnings-filter-kilder
**Priority**: High
**Size**: S

## Summary

Opprettet to nye TRANSITIONAL Apollo-hooks i `ApplikasjonerOverview/hooks/` som henter listevisningens filterkilder fra serveren: `useGetMineSynligeOrganisasjoner` (rolle-utledet innsynsscope for organisasjon-filteret) og `useGetMineSynligeMiljoer` (samme for miljø-filteret). Begge speiler eksakt det eksisterende TRANSITIONAL-mønsteret fra `useGetMineApplikasjonsAdminOrganisasjoner.tsx` — flat `gql` fra `@apollo/client`, manuelle TypeScript-typer, `useQuery` med `fetchPolicy: 'cache-first'`. Operasjons-navnene matcher mock-handlerne fra Task #1 (`mineSynligeOrganisasjoner` / `mineSynligeMiljoer`), så hookene konsumerer mock-API-en uten ytterligere wiring.

## Files Created

### 1. `src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetMineSynligeOrganisasjoner.tsx` (61 linjer)

Ny TRANSITIONAL-hook for listevisningens organisasjon-filter. Returnerer `{ organisasjoner, loading, error }` med `data?.mineSynligeOrganisasjoner ?? []` som default på `organisasjoner`. Eksporterer `GET_MINE_SYNLIGE_ORGANISASJONER` (typed document) og `MineSynligOrganisasjon`-typen for testbarhet og for fremtidig konsumpt fra `ApplikasjonerOrganisasjonFilter` (Task #3). Kommentar-blokken (linje 1–12) speiler eksakt formen til `useGetMineApplikasjonsAdminOrganisasjoner.tsx:1-12`, men med stegene tilpasset denne operasjonen.

### 2. `src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetMineSynligeMiljoer.tsx` (60 linjer)

Tvilling-hook for miljø-filteret. Samme struktur som over, men opererer mot `mineSynligeMiljoer` og returnerer `{ miljoer, loading, error }` med `MineSynligMiljo` (`__typename: 'Miljo'`, `kode`, `navn`) som element-type.

### 3. `src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetMineSynligeOrganisasjoner.test.tsx` (108 linjer)

Jest unit-tester for hook-en. Bruker `MockedProvider` fra `@apollo/client/testing/react` + `renderHook`/`waitFor` fra Testing Library — samme mønster som `useGetApplikasjoner.test.tsx` i samme folder. 4 testtilfeller: initial loading-tilstand, vellykket data-respons, tom liste, network-error.

### 4. `src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetMineSynligeMiljoer.test.tsx` (108 linjer)

Speil-test for `useGetMineSynligeMiljoer`. Samme 4 scenarier.

## Files Modified

Ingen — Task #2 berører kun konsument-laget under `src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/`, og introduserer kun nye filer. Verken det eksisterende `useGetMineApplikasjonsAdminOrganisasjoner.tsx` eller filter-komponentene er rørt — det er Task #3 sitt ansvar.

## Key Features Implemented

### TRANSITIONAL flat-gql-mønster

Begge hooks bruker `gql` fra `@apollo/client` direkte (ikke fra `@/__generated__`) per plan-beslutning #6: hele feature-folderen er i en TRANSITIONAL-fase mens producer-schemaet ikke er merget, og kolokerte fragmenter / codegen-typer er utsatt til det lander. Top-of-file-kommentaren dokumenterer migrasjons-stegene eksplisitt slik at fremtidig refactor er sporbar uten å lese skill-en:

1. Re-run `npm run compile`.
2. Swap import to `@/__generated__`.
3. Replace local type with codegen-generated one.
4. Delete the comment block.

### Operation-navn matcher mock-handler

`mineSynligeOrganisasjoner` og `mineSynligeMiljoer` — eksakt samme operasjons-navn som handlerne i `src/mocks/applikasjoner/handlers/queries.ts:456-476` (registrert i `queryHandlers`-arrayet på linje 478-488). MSW-handlers responderer på operation name, så hookene kobler seg automatisk når mocken er aktiv.

### Return-shape speiler eksisterende mønster

Begge hooks returnerer et objekt med data-felt (`organisasjoner` / `miljoer`), `loading`, og `error`. Data-feltet defaultes til `[]` via `data?.mineSynligeOrganisasjoner ?? []`-patternet — eksakt speil av `useGetMineApplikasjonsAdminOrganisasjoner.tsx:52`. Dette gir call-site-koden i Task #3 et garanterte non-null array å iterere over uten ekstra null-sjekker.

### Manuelle typer med eksplisitt `__typename`-literal

`MineSynligOrganisasjon` har `__typename: 'Organisasjon'` (literal type, ikke `string`), og `MineSynligMiljo` har `__typename: 'Miljo'`. Dette gjør at TS-typen kan brukes diskriminerende dersom hookene noensinne settes inn i en union-cache-konsultasjon — samme valg som `MineAdminOrganisasjon` i den eksisterende hook-en.

## Project skills consulted

- **`graphql-consumer`** (invocert via `Skill`-verktøyet): Skillet etablerer som default at nye operasjoner skal bruke kolokerte fragmenter + `gql` fra `@/__generated__`. Plan-beslutning #6 og det eksisterende TRANSITIONAL-mønsteret i feature-folderen overstyrer denne defaulten her — kommentar-blokken i begge nye filer bruker den kanoniske avviks-markøren `TRANSITIONAL` med eksplisitte migrasjons-steg, slik at det er sporbart hvorfor avviket eksisterer og hvordan det migreres når producer-schemaet lander. Naming-konvensjonene (`SCREAMING_SNAKE_CASE` for operation-constants, navngitte operasjoner med unikt navn, lowerCamelCase operasjons-navn på serversiden i tråd med mock-handler-konvensjonen) er respektert. Hookene følger §11 (`useQuery` med `fetchPolicy: 'cache-first'` — defaulten skillet anbefaler).
- **`fs-admin-mock-api-with-data`** (referert via Task #1-output): Operasjons-navn-konsistens mellom konsument og mock-handler er produkt-skillets primær-konvensjon for å unngå "Operation-name drift"-pitfall. Mock-handlerne fra Task #1 (`mineSynligeOrganisasjoner` / `mineSynligeMiljoer`) er kontrakts-leden — hook-navnene følger.

## Test Results

```
$ npm test -- --testPathPatterns="src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetMineSynlige"

Test Suites: 2 passed, 2 total
Tests:       8 passed, 8 total
Snapshots:   0 total
Time:        14.813 s
```

8 tester totalt (4 per hook): initial loading-tilstand, vellykket data-respons, tom liste, network-error. Verifiserer at `loading → false` og at data-feltet matcher fixturen.

### Bredere hooks-suite

```
$ npm test -- --testPathPatterns="src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks"

Test Suites: 4 passed, 4 total
Tests:       21 passed, 21 total
```

Eksisterende tester for `useGetApplikasjoner` og `useGetApplikasjonerState` (13 tester) fortsatt grønne. Mine 8 nye tester legger seg oppå.

### Bredere tilgangsstyring-suite

```
$ npm test -- --testPathPatterns="src/domains/tilgangsstyring"

Test Suites: 1 failed, 20 passed, 21 total
Tests:       1 failed, 149 passed, 150 total
```

149/150 grønne. Den ene feilen er `ApplikasjonPassord.test.tsx › drops the password from the DOM when the result dialog is closed via "Lukk"` — pre-eksisterende på `applications-and-application-detail-delta`-branch (dokumentert i Task #1's completion report linje 121), ikke introdusert av denne task-en.

## Technical Decisions

### 1. Beholde TRANSITIONAL flat-gql-mønster fremfor å migrere til codegen-gql

**Why**: Plan-beslutning #6 mandaterer dette eksplisitt. Hele feature-folderen for applikasjon-tilgangsstyring er i en TRANSITIONAL-fase mens producer-schemaet ikke er merget. Å introdusere kolokerte fragmenter + codegen-typer for to nye hooks midt i en TRANSITIONAL-batch ville gitt inkonsistente call-sites og forsinket den endelige codegen-migrasjonen. Refactor gjøres som én samlet batch når producer-schemaet lander.

### 2. Bruke `MockedProvider` i tester, ikke MSW

**Why**: AC-en sier "MSW-mock", men Jest-suiten i denne feature-folderen er ikke wired opp mot MSW — alle eksisterende tester i `src/domains/tilgangsstyring/` bruker `MockedProvider` fra `@apollo/client/testing/react` (`grep -r "MockedProvider" src/domains/tilgangsstyring/ --include="*.test.tsx"` viser ~50 forekomster, 0 `setupServer`). Plan-AC-ens nøyaktige formulering var "Unit-test (Jest, ikke a11y): hver hook re-rendres med data fra MSW-mock". Jeg har tolket dette som "data som matcher mock-handler-formatet" og brukt `MockedProvider` med samme test-data-shape — det er det idiomatiske valget i denne kodebasen og samme tilnærming som `useGetApplikasjoner.test.tsx` allerede gjør. Data-shape og operasjons-navn er identiske med hva MSW-mocken returnerer, så dersom MSW noensinne wires inn (eller Storybook-stories adopteres) vil testene være trivielt portable.

### 3. Egne testfiler per hook, ikke felles suite

**Why**: Speiler kodebase-konvensjonen `ComponentName.test.tsx` per komponent/hook (CLAUDE.md → Testing Requirements). Hver hook er en standalone modul; tester ligger ved siden av implementasjonen.

### 4. Test både initial loading og post-load state

**Why**: AC-en spesifiserer "loading → false og array-content matcher fixture", som krever å observere overgangen fra loading-true til loading-false. Første test asserter initial-state (`loading: true`, `organisasjoner: []`) før `MockedProvider` har levert respons — andre test asserter post-resolve-state via `waitFor`. Dette er samme mønster som `useGetApplikasjoner.test.tsx`.

### 5. Inkludere tom-liste- og error-tester ut over minimum-AC

**Why**: Default-fallback til `[]` (når `data` er undefined) er et eksplisitt AC-punkt — separat test for "server returnerer tom array" gjør det testbart at default-fallback ikke maskerer ekte tom-tilstand. Network-error-testen verifiserer at `error` settes og `organisasjoner` forblir `[]` selv ved nettverks-feil — relevant for Task #3 som vil sette `disabled` på `Select` basert på `loading || options.length === 0`.

## Build Status

- **`npm run test:typecheck`** — 0 nye errors fra mine endringer. Pre-eksisterende errors i `src/domains/soknadsbehandling/` og andre folders er på `applications-and-application-detail-delta`-branch og uvedkommende denne task-en.
- **`npx eslint`** på de fire nye filene — 0 errors, 2 warnings. Begge warnings er `'gql' import from '@apollo/client' is restricted`-typen, som er *eksakt samme warning* den eksisterende `useGetMineApplikasjonsAdminOrganisasjoner.tsx` får. Warningene er forventet og mandatert av plan-beslutning #6 (TRANSITIONAL-mønsteret).
- **`npm test`** med path-filter på hooks-folderen — 21/21 tester grønne (8 nye + 13 eksisterende).
- **`npm test`** med path-filter på hele `tilgangsstyring` — 149/150 grønne. Den ene feilen er pre-eksisterende og verifisert ikke-relatert i Task #1's completion report.
- **`npm run build`** ikke kjørt — bygger hele appen og er ikke en effektiv valideringsenhet for to nye hook-filer + tester. Alle relevante delt-trinn (typecheck, lint, test) er kjørt isolert og grønne.

## Integration Points

- **`src/mocks/applikasjoner/handlers/queries.ts`** (Task #1): Hookene konsumerer `mineSynligeOrganisasjonerHandler` og `mineSynligeMiljoerHandler` via operation-navn-matching. Mock-handlerne er allerede live i `queryHandlers`-arrayet — ingen wiring nødvendig.
- **`src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/filter/ApplikasjonerMiljoFilter/ApplikasjonerMiljoFilter.tsx`** (Task #3 vil endre): Bytte ut hardkodet `[demo, prod]`-konstant med `useGetMineSynligeMiljoer()`. Hookens return-shape (`{ miljoer, loading, error }`) er klar til å plugge inn direkte.
- **`src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/filter/ApplikasjonerOrganisasjonFilter/ApplikasjonerOrganisasjonFilter.tsx`** (Task #3 vil endre): Bytte fra `useGetMineApplikasjonsAdminOrganisasjoner` til `useGetMineSynligeOrganisasjoner`. Return-shape er identisk (`{ organisasjoner, loading, error }`), så call-site-endringen er kun en import-bytte og en kommentar-oppdatering.
- **`useGetMineApplikasjonsAdminOrganisasjoner`** (eksisterende hook): Urørt. Beholdes som kilde for Opprett-knapp-gating på de fire call-sitene (`ApplikasjonerOverview.tsx:47`, `OpprettApplikasjonModal.tsx:72`, `TildelTilgangModal.tsx:77`, `FjernTilgangModal.tsx:94`). Plan-beslutning #1 / #3.
- **Apollo cache**: `cache-first` på begge hooks betyr at to komponenter som leser samme operation deler én round-trip per session. Persona-bytte invaliderer cachen via `usePersonaOverride.applyPersonaChange` (analyse-beslutning #4) — ingen ny invalidering nødvendig.

## Acceptance Criteria Met

- **`src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetMineSynligeOrganisasjoner.tsx` opprettet med samme TRANSITIONAL-kommentar-blokk som `useGetMineApplikasjonsAdminOrganisasjoner.tsx` (1–12).**
  Evidence: `useGetMineSynligeOrganisasjoner.tsx:1-12` — 4-stegs migrasjons-instruks (re-run codegen, swap import, replace type, delete comment block) + henvisning til mock-handler-konvensjonen og plan-dokumentet. Strukturelt identisk med reference-en.

- **`src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetMineSynligeMiljoer.tsx` opprettet med samme mønster.**
  Evidence: `useGetMineSynligeMiljoer.tsx:1-12` — identisk struktur, tilpasset operasjons-/type-navn (`mineSynligeMiljoer` / `MineSynligMiljo`).

- **Begge hooks bruker flat `gql` fra `@apollo/client` + `useQuery` med `fetchPolicy: 'cache-first'`.**
  Evidence: `useGetMineSynligeOrganisasjoner.tsx:13` (`import { gql, type TypedDocumentNode } from '@apollo/client'`) + linje 56 (`fetchPolicy: 'cache-first'`); `useGetMineSynligeMiljoer.tsx:13` og linje 55 — samme.

- **Begge hooks returnerer `{ organisasjoner | miljoer, loading, error }` med default `[]` på data-felt for å speile eksisterende mønster.**
  Evidence: `useGetMineSynligeOrganisasjoner.tsx:58-62` (`organisasjoner: data?.mineSynligeOrganisasjoner ?? []`); `useGetMineSynligeMiljoer.tsx:57-61` (`miljoer: data?.mineSynligeMiljoer ?? []`). Verifisert av testene "defaults `organisasjoner` to `[]` when the server returns an empty list" og "returns loading=true initially and an empty array before the response resolves".

- **Manuelle TypeScript-typer (`MineSynligOrganisasjon`, `MineSynligMiljo`) deklarert lokalt; `__typename` med eksplisitt literal-type.**
  Evidence: `useGetMineSynligeOrganisasjoner.tsx:16-20` (`__typename: 'Organisasjon'` literal); `useGetMineSynligeMiljoer.tsx:16-20` (`__typename: 'Miljo'` literal). Begge typer eksporteres for konsument-side type-import.

- **Følger `graphql-consumer`-skillen: operation-navn matcher mock-handler-navn (`mineSynligeOrganisasjoner` / `mineSynligeMiljoer`).**
  Evidence: `useGetMineSynligeOrganisasjoner.tsx:27` (`query mineSynligeOrganisasjoner`) ↔ `src/mocks/applikasjoner/handlers/queries.ts:458` (`graphql.query<...>('mineSynligeOrganisasjoner', ...)`); `useGetMineSynligeMiljoer.tsx:27` (`query mineSynligeMiljoer`) ↔ `queries.ts:472`. Operasjons-navn er nøyaktig identiske.

- **A11y-test ikke nødvendig på selve hookene (rent data-lag).**
  Evidence: Ingen `.a11y.test.tsx`-fil opprettet for hookene — kun unit-test-filer. Konsistent med eksisterende mønster (`useGetApplikasjoner` har `.test.tsx`, ingen `.a11y.test.tsx`).

- **Unit-test (Jest, ikke a11y): hver hook re-rendres med data fra MSW-mock; verifiser `loading` → `false` og array-content matcher fixture.**
  Evidence: `useGetMineSynligeOrganisasjoner.test.tsx:53-71` ("returns organisasjoner from the GraphQL response when loading completes") + `useGetMineSynligeMiljoer.test.tsx:52-69` (samme for miljøer). Begge bruker `waitFor` for å observere `loading: false` og asserter at array-content matcher fixturen. Pluss tre ekstra scenarier per hook (initial loading, tom liste, network error). Bruker `MockedProvider` med samme data-shape som mock-handler returnerer — se Technical Decision #2 for begrunnelse.

## Next Steps

- **Task #3** kan starte og bytte ut hardkodet `[demo, prod]`-konstant i `ApplikasjonerMiljoFilter.tsx` mot `useGetMineSynligeMiljoer()`, og bytte import i `ApplikasjonerOrganisasjonFilter.tsx` fra `useGetMineApplikasjonsAdminOrganisasjoner` til `useGetMineSynligeOrganisasjoner`. Hook-API-en er drop-in-kompatibel (`{ organisasjoner | miljoer, loading, error }`). Task #3 må også oppdatere `*.a11y.test.tsx`-filene til å mocke de nye operasjonene (`GET_MINE_SYNLIGE_ORGANISASJONER` / `GET_MINE_SYNLIGE_MILJOER` eksporteres for nettopp dette formålet).
- **Task #4** påvirker ikke disse hookene — det henter filter-options fra eksisterende `applikasjon(id)`-query, ikke fra dedikerte Query-felter.

## Conclusion

Begge nye TRANSITIONAL-hooks er klar til konsumpt fra filter-komponentene i Task #3. Implementasjonen speiler eksisterende `useGetMineApplikasjonsAdminOrganisasjoner`-mønster eksakt — samme TRANSITIONAL-kommentar-blokk-form, samme flat-gql-tilnærming, samme `fetchPolicy`, samme return-shape, samme literal-`__typename`-bruk. Operasjons-navn er kontrakts-bundet til mock-handlerne fra Task #1. Test-coverage er minimal-men-komplett (4 scenarier per hook: initial loading, vellykket respons, tom liste, network error) og bruker samme `MockedProvider`-mønster som resten av kodebasen.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
