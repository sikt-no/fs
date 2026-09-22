# Analysis: Grunnleggende brukeradministrasjon (personbrukere)

> Teknisk kodeanalyse av fs-admin mot kravene i
> [spec-grunnleggende-brukeradministrasjon.md](../spec/spec-grunnleggende-brukeradministrasjon.md)
> (BRU-PER-GRU-001/002/003/004/007, sikt-no/fs#350). Utført 2026-07-08.
> Alle stier er relative til fs-admin-repoet der ikke annet er sagt.

## Problem Statement

FS Admin mangler i dag enhver UI for administrasjon av **personbrukere**: en
brukeradministrator kan ikke se hvilke personer som har roller/tilganger ved
sine organisasjoner, ikke tildele eller fjerne tilganger, og ikke deaktivere en
bruker. Spec-en definerer en master-detail-flyt (liste → detaljside med faner →
modaler for tildele/fjerne/deaktivere) under Tilgangsstyring-domenet.
Kodebasen har nylig fått en nesten identisk strukturert feature —
**applikasjoner** (`merge applications into main`) — som etablerer alle
mønstrene denne featuren trenger, inkludert mock-API-tilnærmingen for utvikling
før subgraf-endringene lander.

## Current State

### Det finnes ingen personbruker-administrasjon i dag

- `src/domains/tilgangsstyring/features/` inneholder kun `ApplikasjonerOverview/`,
  `ApplikasjonDetails/` og `components/`.
- Rutene under `src/app/tilgangsstyring/` er kun `page.tsx` (domene-indeks) og
  `applikasjoner/` + `applikasjoner/[id]/`.
- `TilgangsstyringIndex` (`src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.tsx:60`)
  har i dag bare en **deaktivert** «Maskinbrukere»-knapp — ingen
  personbruker-inngang. (Maskinbrukere-featuren som mønster-katalogen omtaler
  som anti-pattern-referanse er fjernet fra kodebasen; kun placeholder-knappen
  står igjen.)
- `person`-domenet (`src/domains/person/` — PersonSearch/GroupSearch/PersonDetails)
  er **rent oppslag** av personinformasjon (adresse, kontakt, institusjonsdata),
  ikke bruker-/tilgangsadministrasjon. Det er et annet use-case og skal ikke
  gjenbrukes som base, men viser at «person» som entitet allerede finnes i
  appen med egne ruter (`/person/personsok/[id]`).

### Nærmeste eksisterende slektning: applikasjoner-featuren

Applikasjoner dekker strukturelt alle de fem kravene, bare for entiteten
Applikasjon i stedet for Personbruker:

| Behov i denne featuren | Eksisterende motstykke |
|---|---|
| Liste med filter/sortering/paginering | `src/domains/tilgangsstyring/features/ApplikasjonerOverview/` |
| URL-synket filtertilstand | `ApplikasjonerOverview/hooks/useGetApplikasjonerState.tsx:25-38` (`useDataListState`, `initFirst: 50`) |
| Detaljside med topbar + faner | `ApplikasjonDetails/ApplikasjonDetails.tsx:44-106` (`DetailPageLayout` + `DetailPageTabbedContent`) |
| Filterbar tilgangsliste i fane | `ApplikasjonDetails/components/ApplikasjonTilganger/ApplikasjonTilganger.tsx` (kanonisk bruker av `DetailPageContentFilterAndResult`) |
| Tildel-modal (org → miljø → fler-valg) | `ApplikasjonTilganger/components/TildelTilgangModal/TildelTilgangModal.tsx:73-313` |
| Fjern-modal (destruktiv, fler-valg) | `ApplikasjonTilganger/components/FjernTilgangModal/FjernTilgangModal.tsx:90-342` |
| Deaktiver/reaktiver med bekreftelsesmodal | `ApplikasjonDetails/components/DeaktiverApplikasjonModal/` + `ReaktiverApplikasjonModal/` |
| Mock-API før backend | `src/mocks/applikasjoner/` (schema, fixtures, handlers, store, teardown-plan) |

### GraphQL i dag

- Skjema hentes av codegen fra `GRAPHQL_SCHEMA_LOCATION` (fallback:
  supergraf-test-gateway); sjekket inn som `schema.graphql` (`codegen.ts:8`).
- Reelt skjema har en `brukere`-query (`schema.graphql:42626`) som returnerer
  `QueryBrukereConnection` av **`PersonProfil`** (har `feideBruker`, `larested`,
  navnefelt), men filteret (`QueryBrukereFilterInput`, `schema.graphql:47683`)
  har kun `eierOrganisasjonskode!` + `brukergrupper` — **ingen** navn/Feide-ID/
  status/rolle/miljø-filter, ingen orderBy, og ingen modell for tildelinger
  (tilgang/rolle med «Tildelt av»/«Tildelt dato»), status Aktiv/Deaktivert
  eller deaktiver/reaktiver-mutasjoner.
- Applikasjoner løste tilsvarende gap med en **lokal mock-SDL**
  (`src/mocks/applikasjoner/schema/applikasjoner.graphql`) + MSW-handlers, og
  holder feature-mappen utenfor codegen inntil ekte skjema finnes
  (`codegen.ts:15-28`: `'!src/mocks/**/*'`, `'!src/domains/tilgangsstyring/**/*'`).
  Migrasjonsplanen er dokumentert i `src/mocks/applikasjoner/teardown-applikasjoner.md`.

## Key Findings

1. **Cross-pattern bekreftet (ListPageLayout ↔ DetailPageLayout).**
   Mønster-deteksjon ga listeside ~98/100 og detaljside ~97/100. Gullstandard-
   referanser: `EmnerOverview` ↔ `EmneDetails` (utdanning) for master-detail-
   navigasjon med URL-tilstand, og applikasjoner for alt tilgangsstyring-
   spesifikt. Skissens brødsmulesti («Hjem > Tilgangsstyring > Personbrukere»)
   plasserer featuren i `tilgangsstyring`-domenet.

2. **Skissen matcher komponentbiblioteket 1:1.** Listen (sub-frame 01) er
   `ListPageLayout` + `NavigationList` med filter-sidebar (Navn, Feide-ID,
   Organisasjon, Rolle, Status — Miljø kom til i krav-avklaringen), sortering
   og «Last inn flere». Tilganger-fanen (sub-frame 03) er nøyaktig
   `DetailPageContentFilterAndResult`-formen: filter-sidebar + resultatliste +
   bulk-knapper «Tildel tilganger»/«Fjern tilganger» i actions-slot.
   Detaljsiden har tre faner (Detaljer/Tilganger/Roller) — merk at kravet
   (BRU-PER-GRU-002) sier «seksjoner», skissen viser **faner**; faner er
   etablert praksis (`DetailPageTabbedContentPanel`).

3. **Tildel-modalen i skissen er samme form som `TildelTilgangModal`:**
   Organisasjon-select → Miljø-select → «Navn»-velger (fler-valg, jf.
   spec-beslutning #3). Applikasjoner bruker kaskade-enabling (miljø disabled
   til org er valgt, koder disabled til begge er valgt) og checkbox-liste for
   fler-valg — direkte gjenbrukbart.

4. **Union-of-errors-konvolutten finnes, men dekker ikke delvis suksess.**
   Konvensjonen er `union XxxResultat = XxxSuksess | MutasjonAvvist` med
   `MutasjonAvvist { arsak: MutasjonAvvistArsak!, feilmelding: String! }`
   (mock-SDL `applikasjoner.graphql:166-293`). Suksess-varianten returnerer
   alt-eller-ingenting. Kravet «Delvis suksess ved samtidig tildeling» krever
   **per-element-resultat** («jeg ser tydelig hvilke tildelinger som ikke ble
   gjennomført, og hvorfor») — konvolutten for personbruker-mutasjonene må
   utvides (f.eks. suksess-variant med både `tildelte` og `avviste` lister).
   Dette er et skjemadesign-punkt for subgraph-planen.

5. **Autorisasjon/synlighet har frontend-grunnlag.** `GlobalUserProvider`
   (`src/common/lib/auth/providers/GlobalUserProvider.tsx`) eksponerer
   `effectiveUser.rollekode` og `useMineLaresteder()` gir
   `effectiveOrganisasjonskode`. Applikasjoner-mocken filtrerer per persona
   (`src/mocks/applikasjoner/handlers/queries.ts`, `filterTilgangerForPersona`)
   — samme grep kan simulere brukeradministrator vs. super-brukeradministrator.
   Selve håndhevingen er backend-ansvar; frontenden skal ikke implementere
   synlighetsreglene, bare sende org-kontekst og vise det API-et returnerer.

6. **Filterkildene i kravet trenger egne query-felt.** «Alle roller som er
   tildelt minst én personbruker i listen», «alle miljøer representert blant
   tilgangene» og «alle organisasjoner jeg har brukeradministrator-rollen for»
   tilsvarer applikasjoner-mønstrene `applikasjonTilgangerFilterOptions`,
   `mineSynligeMiljoer` og `mineApplikasjonsAdminOrganisasjoner` — det trengs
   personbruker-varianter av disse.

7. **Historikk («sporbar i historikk») har ingen UI- eller API-flate i dag.**
   Ingen endringshistorikk finnes for tilganger (kun `sporing`-felt som
   opprettetAv/sistEndretAv på Applikasjon). Kravene krever at endringer *er*
   sporbare, men ingen av de fem featurene beskriver en historikk-**visning**
   (det ligger i BRU-PER-HIS-kravfamilien, utenfor scope). Tolkning: persistens
   av historikk er backend-ansvar; UI-et viser kun «Tildelt av»/«Tildelt dato».
   Bør bekreftes (se Open Questions).

8. **Miljø-begrepet er etablert, men verdikilden er midlertidig.**
   `Miljo { kode, navn }` med verdiene demo/prod; applikasjoner hardkoder
   options i modaler/filtre i påvente av `mineSynligeMiljoer`-endepunkt
   (`TildelTilgangModal.tsx:157-164`). Spec-beslutning #4 sier samme kilde som
   applikasjoner — altså arves også den midlertidige hardkodingen og
   opprydningspunktet.

9. **Sorteringskonvensjonen er retning-i-enum** (`NAVN_ASC`/`NAVN_DESC`), ikke
   separat `OrderDirection` — nyere mock-SDL avviker her fra det eldre
   supergraf-mønsteret. Kravets tie-break (navn → Feide-ID, og navn som
   tie-break for andre felt) er server-side-ansvar og må inn i skjemadesignet.

10. **Codegen/mock-mekanikken er avklart og repeterbar.** Mock-koden er
    ekskludert fra codegen; feature-koden bruker manuelle TS-typer
    (`useGetApplikasjonerTypes.ts`-mønsteret) inntil ekte skjema lander, og
    `useDataListQuery`-queries **må** registreres i
    `src/lib/apollo/cacheConfig.ts` med `nodesCursorPagination(['filter', 'orderBy'])`
    — ellers forsvinner resultater ved «Last inn flere».

## Technical Constraints

- **Ingen klient-side filtrering/sortering** — alt via GraphQL-variabler og
  `useDataListQuery`; sidestørrelse 50 med «Last inn flere» (spec-beslutning #5).
- **`DetailPageContentFilterAndResult` er obligatorisk** for filter+liste i
  detaljfaner — ikke håndrull responsiv splitt (anti-pattern 5 i
  detail-page-katalogen).
- **Layout-helpers:** aldri `display: flex/grid` i module.css — bruk `<Flex>`/
  `<Grid>`-helperne (fs-admin-grid-and-flex).
- **Knapper:** `FSButton`; opprett-knapper heter bare «Opprett»; async-knapper
  disables + progressiv label; destruktive handlinger = `variant="critical"`
  med bekreftelsesmodal (fs-admin-buttons; jf. Deaktiver-modalen i skissen med
  rød knapp).
- **Inputs:** labels er substantiv («Feide-ID», ikke «Søk etter …»); selects
  med null-verdi må ha synlig «Alle …»-option (kravet spesifiserer «Alle
  statuser»/«Alle organisasjoner»/«Alle roller»/«Alle miljøer» som default) —
  matcher fs-admin-inputs/list-filters-reglene.
- **a11y-tester er påkrevd** for hver komponent (`*.a11y.test.tsx`);
  coverage-terskler 60/90 (CLAUDE.md).
- **i18n:** alle strenger via next-intl; nøkler per komponent i
  `src/messages/nb/` etter domenestruktur; tre nivåer av common
  (`src/common/messages/CLAUDE.md`... merk: message-docs ligger i
  `src/messages/CLAUDE.md`).
- **Typed routes** genereres fra `src/app/`-strukturen
  (`npm run generate:routes`) — nye ruter gir nye `*Href`-typer automatisk.
- **Feature-gating:** menyen er gated bak `tilgangsstyring-meny`-flagget
  (`src/features/Header/Menu/Menu.tsx:83-98`); nye flagg genereres med
  `npm run generate:unleash`. Et `personer`-flagg finnes, men brukes av
  person-domenet — ikke gjenbruk uten avklaring.
- **Mutasjonskonvolutt:** union-of-errors med delt `MutasjonAvvist`;
  `refetchQueries` + `awaitRefetchQueries: true` for listeoppdatering
  (`useTildelApplikasjonTilganger.tsx:87-88`) i stedet for manuell
  cache-kirurgi.
- **Apollo cache:** paginerte queries registreres i
  `src/lib/apollo/cacheConfig.ts`; detaljsider bruker normalisert cache for
  umiddelbar delvis rendering fra liste-navigasjon.

## Dependencies

- **Internal:**
  - `src/common/components/layouts/` (ListPageLayout, DetailPageLayout,
    DetailPageContentFilterAndResult, LayoutMessage) og
    `src/common/components/lists/` (NavigationList, ActionList) — gjenbrukes as-is.
  - `src/common/hooks/useDataListState` + `useDataListQuery` — gjenbrukes as-is.
  - `GlobalUserProvider`/`useMineLaresteder` for org-kontekst og rollekode.
  - `TilgangsstyringIndex` (support-domenet) og `Menu.tsx` må oppdateres med
    Personbrukere-inngang.
  - `src/mocks/handlers.ts` + `MockProvider.tsx` — ny personbruker-mock kobles
    inn her (gated bak env-var som applikasjoner:
    `NEXT_PUBLIC_ENABLE_APPLIKASJON_MOCKS`-mønsteret).
- **External:**
  - `@sikt/sds-*` (Dialog, Select, TextInput, CheckboxInput, Alert, Tag/Badge) —
    allerede i bruk; ingen nye avhengigheter identifisert.
  - `nuqs` (URL-state) og MSW — allerede i bruk.
- **Cross-contributor:**
  - **fs-plattform (subgraf-teamet, pipeline-steg 4 og 6):** hele
    personbruker-API-et må designes og bygges — liste-query med filter/orderBy/
    Relay-paginering, detalj-query, tildelinger-connection med «Tildelt av»/
    «Tildelt dato»/status, filter-options-queries, mutasjoner
    (tildel/fjern/deaktiver/reaktiver) med delvis-suksess-konvolutt, og
    håndheving av synlighetsreglene (brukeradministrator vs.
    super-brukeradministrator). Blokkerer overgang fra mock til ekte data —
    men ikke frontend-utviklingen (mock-first som applikasjoner).
  - **Produkteier/design:** åpent spørsmål #6 fra spec-en (skille direkte
    tildelinger fra rolle-avledede i Tilganger-fanen) + detaljert dialog-UX
    for tildele/fjerne (fler-valg-velgeren) er bevisst utsatt til designfasen.
    Påvirker Tilganger/Roller-fanenes kolonner og modal-innhold, ikke
    grunnstrukturen.

## Requirements Impact

Kravene er dekket mønster-messig av eksisterende kode, men 100 % av
personbruker-**API-et** mangler. Ingen krav er i konflikt med kodebasen.

- **BRU-PER-GRU-001 (liste/søk):** Mønster klart (ApplikasjonerOverview-mal).
  Gap: `brukere`-queryen i supergrafen mangler alle kravets filtre og
  sortering; mock-SDL må definere `personbrukere`-query med to fritekstfelt
  (navn, feideId), status/organisasjon/rolle/miljø-filter, orderBy med
  tie-break-semantikk og totalCount. Synlighetsregelen (admin ser kun egne
  org-brukere) håndheves i backend/mock.
- **BRU-PER-GRU-002 (se tilganger/roller):** Mønster klart
  (`DetailPageContentFilterAndResult` + ActionList). Gap: tildelings-modellen
  (Navn/Status/Organisasjon/Tildelt av/Tildelt dato, aktiv/inaktiv) finnes
  ikke i noe skjema. Skissen splitter i to faner (Tilganger, Roller) — kravets
  «seksjoner» tolkes som faner. Åpent design-spørsmål #6 påvirker
  kilde-merking, ikke strukturen.
- **BRU-PER-GRU-003 (tildele/fjerne):** Modal- og mutasjonsmønster klart
  (TildelTilgangModal/FjernTilgangModal). Gap: delvis-suksess-konvolutt
  (per-element-resultat) finnes ikke i dagens konvensjon og må designes;
  «Navn»-velgeren er fler-valg (spec-beslutning #3); autorisasjonsregel
  avgrenset til org-scope (spec-beslutning #7) håndheves i backend.
- **BRU-PER-GRU-004 (deaktivere/reaktivere):** Mønster klart
  (Deaktiver/ReaktiverApplikasjonModal, destruktiv rød knapp jf. skisse).
  Gap: frys-semantikken (tildelinger beholdes men blir inaktive; utløpte
  reaktiveres ikke) er ren backend-logikk; frontenden viser bare status og
  refetcher.
- **BRU-PER-GRU-007 (se detaljer):** Enkleste kravet — Detaljer-fane med
  datagrupper (Navn, Feide-ID, Organisasjon(er), Status);
  `ApplikasjonDetaljer`-malen gjenbrukes. Merk: «hvilke organisasjoner
  personbrukerens tilganger gjelder for» er flertall — feltet er avledet av
  tildelingene, ikke et enkeltfelt.
- **Sporbarhet (alle GRU-003/004-scenarier):** «endringen er sporbar i
  historikk» tolkes som backend-persistens (ingen historikk-UI i disse
  kravene); UI viser Tildelt av/dato. Se Open Questions #4.
- **Missing requirements discovered:** ingen nye funksjonelle krav, men to
  tekniske forutsetninger kravene ikke nevner eksplisitt: (a) filter-options-
  queries for rolle/miljø/organisasjon-filtrene, (b) cacheConfig-registrering
  for alle paginerte lister.

## Foreslått plassering (til plan-fasen — ikke en beslutning)

Speiler applikasjoner. Ruter: `/tilgangsstyring/personbrukere` +
`/tilgangsstyring/personbrukere/[id]` (matcher skissens brødsmulesti
«Tilgangsstyring > Personbrukere»).

```
src/domains/tilgangsstyring/features/
├── PersonbrukereOverview/          # BRU-PER-GRU-001
│   ├── PersonbrukereOverview.tsx
│   ├── components/ (Filter/, OrderBy/, ResultList/, filter/*)
│   └── hooks/ (useGetPersonbrukereState, useGetPersonbrukere, …)
└── PersonbrukerDetails/            # BRU-PER-GRU-002/003/004/007
    ├── PersonbrukerDetails.tsx     # DetailPageLayout + 3 faner
    ├── components/
    │   ├── PersonbrukerTopBar/     # + status-actions (Deaktiver/Aktiver)
    │   ├── PersonbrukerDetaljer/   # Detaljer-fane
    │   ├── PersonbrukerTilganger/  # Tilganger-fane (FilterAndResult + modaler)
    │   ├── PersonbrukerRoller/     # Roller-fane (samme form)
    │   ├── DeaktiverPersonbrukerModal/
    │   └── ReaktiverPersonbrukerModal/
    └── hooks/
src/mocks/personbrukere/            # schema/, fixtures/, handlers/, store/, teardown-md
```

## Krav-input referanse

Autoritativ kravtekst og kildemetadata ligger i spec-fasen — dupliseres ikke her.

- **Spec-dokument:** [spec-grunnleggende-brukeradministrasjon.md](../spec/spec-grunnleggende-brukeradministrasjon.md)
- **Krav-input-manifest:** [krav-input/manifest.md](../spec/krav-input/manifest.md)
- **Skisser:** [krav-input/sketches/figma/brukeradministrasjon-malbilde/](../spec/krav-input/sketches/figma/brukeradministrasjon-malbilde/design-context.md)

## Open Questions

Tekniske spørsmål fra kodeanalysen. (Kravspørsmål #6 fra spec-en — direkte vs.
via-rolle — ligger hos design og gjentas ikke her.)

- [x] **1 — Mock-first-utvikling:** Skal frontenden bygges mot en lokal
      mock-SDL + MSW (som applikasjoner, med egen `src/mocks/personbrukere/`
      og teardown-plan), slik at fs-admin-arbeidet ikke blokkeres av
      subgraf-stegene i pipelinen? (a) Ja — mock-first som applikasjoner
      (anbefalt gitt pipeline-rekkefølgen: analyse → plan → subgraph-plan →
      execute); (b) Nei — vent på subgraf-skjema og bygg mot generert typer
      direkte. **Beslutning (2026-07-08): (a) mock-first.** Egen
      `src/mocks/personbrukere/` med schema/fixtures/handlers/store +
      teardown-dokument, codegen-eksklusjon og env-var-gating etter
      applikasjoner-mønsteret. Mock-SDL-en blir samtidig input til
      subgraph-plan-steget (alfred kopierer `*.graphql` inn i task-mappen).
- [x] **2 — Delvis suksess-konvolutt:** Dagens `Suksess | MutasjonAvvist`-union
      er alt-eller-ingenting. Skal personbruker-mutasjonene (a) utvide
      suksess-varianten med både `tildelte` og `avviste` per-element-lister,
      eller (b) beholde konvensjonen og la backend avvise hele operasjonen?
      Kravet («delvis suksess … ser tydelig hvilke som ikke ble gjennomført,
      og hvorfor») peker på (a). Må samordnes med subgraph-plan.
      **Beslutning (2026-07-08): (a) per-element-resultat.** Suksess-varianten
      utvides med `tildelte`/`fjernede` + `avviste` (med årsak per element);
      `MutasjonAvvist` beholdes for totalfeil (f.eks. manglende rettighet).
      Mock-SDL-en modellerer dette, og beslutningen tas med som føring inn i
      subgraph-plan-steget.
- [x] **3 — Feature flag:** Hvordan gates featuren? (a) Nytt flagg
      `personbrukere` (generate:unleash); (b) gjenbruk `tilgangsstyring-meny`
      (featuren blir synlig samtidig som menyen); (c) gjenbruk eksisterende
      `personer`-flagg (frarådes — eies av person-domenet).
      **Beslutning (2026-07-08): (a) nytt flagg — navngitt
      `tilgangsstyring-brukeradministrasjon`** (korrigert av Batman etter
      walkthrough; ikke `personbrukere`). Opprettes i Unleash +
      `npm run generate:unleash`; gates meny-underpunktet i `Menu.tsx`, kortet
      på `TilgangsstyringIndex` og rutene. Samme `environmentsOverride`-oppsett
      som `tilgangsstyring-meny` (dev/review/test på, prod av inntil
      lansering).
- [x] **4 — Historikk-tolkning:** Er det riktig at «sporbar i historikk» i v1
      kun betyr backend-persistens + «Tildelt av»/«Tildelt dato» i UI, uten
      egen historikk-visning (som ligger i BRU-PER-HIS-kravene)?
      **Beslutning (2026-07-08): ja.** Ingen historikk-UI i denne iterasjonen;
      UI-flaten er «Tildelt av»/«Tildelt dato» på tildelingene.
      Skjemadesignet (subgraph-plan) må likevel sikre at tildel/fjern/
      deaktiver/reaktiver persisteres slik at BRU-PER-HIS-kravene kan bygges
      senere uten datamodell-endring.
- [x] **5 — Rolle- og miljø-filterkilder:** Kravet sier filtrene skal vise
      verdier «representert i listen». Skal mock/skjema tilby dedikerte
      filter-options-queries (à la `applikasjonTilgangerFilterOptions`), eller
      statiske kilder i v1 (miljø hardkodet demo/prod som applikasjoner)?
      **Beslutning (2026-07-08): dedikerte filter-options-queries.**
      Mock-SDL-en definerer en `personbrukereFilterOptions`-aktig query
      (roller/miljøer representert i utvalget) + en
      `mineBrukerAdminOrganisasjoner`-aktig query for org-filteret. Miljø-
      verdiene bak queryen er fortsatt demo/prod (spec-beslutning #4 — samme
      kilde som applikasjoner). Tas med som føring inn i subgraph-plan.
- [x] **6 — Rute-navn:** `/tilgangsstyring/personbrukere` (anbefalt, matcher
      brødsmulestien) vs. `/tilgangsstyring/brukere/personer` (åpner for
      maskinbrukere som sibling under `/brukere/` senere)?
      **Beslutning (2026-07-08): `/tilgangsstyring/personbrukere`** med
      detaljside på `/tilgangsstyring/personbrukere/[id]` — sibling til
      `applikasjoner/`, matcher skissens brødsmulesti. En ev. fremtidig
      maskinbruker-feature får sin egen rute
      (`/tilgangsstyring/maskinbrukere`) på samme nivå.
- [x] **7 — Rollekode-verdier:** Hvilke konkrete `rollekode`-verdier
      representerer «brukeradministrator» og «super-brukeradministrator» i
      Feide/FS-konteksten? Trengs for mock-personas og ev. frontend-gating av
      knapper (f.eks. skjule «Tildel» uten rettighet). Applikasjoner-mocken
      har persona-filtrering som kan gjenbrukes når verdiene er kjent.
      **Beslutning (2026-07-08): arbeidsverdier i mock.** Mock-personas bruker
      `brukeradministrator` og `super_brukeradministrator` som arbeidsverdier;
      de endelige kodene bekreftes mot rolledefinisjonsarbeidet i
      «4 - Opprette og administrere roller» senest før teardown av mocken.
      Frontend-koden skal ikke hardkode verdiene utenfor mock-laget — den
      forholder seg til det API-et/konteksten returnerer.
