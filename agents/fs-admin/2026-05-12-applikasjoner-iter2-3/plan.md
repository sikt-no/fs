# Plan: Applikasjon-administrasjon (Iter 2 + Iter 3)

**Initiativ:** [`sikt-no/fs#31`](https://github.com/sikt-no/fs/issues/31)
**Sub-issues:** [`#434`](https://github.com/sikt-no/fs/issues/434) (Iter 2), [`#435`](https://github.com/sikt-no/fs/issues/435) (Iter 3)
**Analyse:** [`analysis-applikasjoner.md`](analysis-applikasjoner.md)
**Krav-input:** [`krav-input/manifest.md`](krav-input/manifest.md) — branch `fruitbat`, 10 `.feature`-filer
**Scope:** 10 krav `BRU-APP-API-001` til `-010`. `bat-graphql-dev` er bevisst hoppet over — backend-leveranse er sporet i [`sikt-no/fs#455`](https://github.com/sikt-no/fs/issues/455). Iter 4 og Nice-to-have (#437) er utenfor scope.

## Proposed Solution

### Architecture Approach

Nytt feature-tre under `src/domains/support/features/Applikasjoner/` (liste) og `Applikasjon/` (detalj), eksponert via nye ruter under `src/app/tilgangsstyring/applikasjoner/`. Eksisterende maskinbruker-POC står urørt og lever parallelt — migrering/avvikling er en separat beslutning utenfor denne planen.

To primære sider:

```
/tilgangsstyring/applikasjoner/                  → Applikasjoner (ListPageLayout)
/tilgangsstyring/applikasjoner/[applikasjonId]/  → Applikasjon  (DetailPageLayout med tabs)
```

Dialog/modal-flyter (passordbytte, sett ansvarlig, rediger beskrivelse, opprett, tildel tilgang, fjern tilgang bulk) bygges som child-komponenter av enten lista (opprett) eller detaljsiden (resten). Alle dialoger trigges av knapper i topbar/actionbar — ingen egne ruter.

Vi følger pattern-anbefalingene fra analysen 1:1: `ListPageLayout` + `useDataListState`/`useDataListQuery` for lista; `DetailPageLayout` med tabbed content + `ActionList` for nestet tilganger-listing; `ButtonWithConfirmation` for enkle bekreftelses-flyter; `Dialog` fra `@sikt/sds-dialog` for alt med custom-innhold.

### Key Technical Decisions

1. **Iter 2 leveres som lese-feature med passordbytte; Iter 3 påbygger med skriveoperasjoner.**
   - Hvorfor: Iter 2's verdiforslag er intern support, ikke selvbetjent administrasjon. Lese-flyten kan demoes uten at backend leverer mutations.
   - Alternativ vurdert: levere alt i én PR-runde. Forkastet — øker risiko og forsinker tilgjengelig support-funksjonalitet.

2. **Opprett-flyt bygges som modal fra lista**, ikke egen rute.
   - Hvorfor: ID-verifiserings-flyten passer naturlig i flertrinns dialog; brukeren returnerer til lista uten ekstra navigering. Følger `OpprettRundeModalButton`-mønsteret.
   - Alternativ vurdert: dedikert rute `/tilgangsstyring/applikasjoner/ny`. Bedre djup-lenking, men ingen krav som tilsier behov for det. Avklares med UX som siste sjekk før Iter 3-implementasjon.

3. **Rediger beskrivelse leveres som dialog**, ikke inline-edit.
   - Hvorfor: pattern-skill har ingen inline-edit-pattern, og vi etablerer ikke nye mønstre i denne leveransen. Dialog er enklere a11y og passer eksisterende konvensjon.

4. **Tilganger-tab bruker `ActionList`** (ikke `NavigationList`).
   - Hvorfor: Krav `-008` krever bulk-fjerning av tilganger med checkbox-seleksjon. `ActionList` støtter dette out-of-the-box.

5. **Passordbytte-mutation returnerer passord; passordet lagres aldri i Apollo cache.**
   - Hvorfor: Krav `-004` sier "passordet kan ikke hentes opp igjen etter at dialogen er lukket". Vi holder passord i lokal `useState` i dialog-komponenten og kaster den ved unmount.
   - Alternativ vurdert: cache-update via `useFragmentUpdate`. Forkastet — risikerer utilsiktet persistering / re-render.

6. **`useDataListState` for nestet tilganger-tab** bruker egen `nuqs`-prefix (f.eks. `t_`) for å unngå kollisjon med list-state på samme rute.
   - Hvorfor: URL-synking i en tab kan være ønsket for djup-lenking, og `useDataListState` støtter prefix. Sjekk eksisterende konvensjon i `MaskinBruker/ApiTilganger` før implementasjon.

7. **i18n-strenger plasseres i ny fil `src/common/messages/nb/applikasjoner.json`** (ikke i `support.json`).
   - Hvorfor: Volumet forventes å bli stort (10+ flyter, dialoger, valideringsmeldinger). Egen fil reduserer merge-konflikter mot eksisterende støtte-strenger og gjør domeneoppdelingen renere.
   - Alternativ vurdert: `support.json`. Forkastet — terminologisk skille mellom "applikasjon" og "maskinbruker" gjør det rotete.
   - Avhenger av: `messages/index.ts`-registrering (sjekk eksisterende mønster).

8. **Ny `TilgangsstyringIndex`-kort for applikasjoner**, ved siden av eksisterende maskinbruker-kort.
   - Hvorfor: Tydelig at applikasjoner er ny inngang uten å skjule eksisterende.
   - Cleanup: Maskinbruker-kortet fjernes når POC-en avvikles (utenfor denne planens scope).

9. **CommandPalette-kommando "Gå til applikasjoner"** legges til samtidig som rute-tre.
   - Hvorfor: Konsistens med eksisterende maskinbruker-kommando.

10. **Ingen MSW-mocking i denne leveransen.** Vi venter på reell schema fra backend (#455).
    - Hvorfor: Auto-memory beskriver et codegen-eksklusjonsmønster fra forrige applications-feature, men det er ekstra kompleksitet vi unngår siden #455 er aktivt arbeid.
    - Alternativ vurdert: MSW for parallell utvikling. Hold som backup hvis backend forsinker — kan introduseres etterpå hvis nødvendig.

### File Changes Overview

**Nye filer (rute-tre):**
- `src/app/tilgangsstyring/applikasjoner/page.tsx`
- `src/app/tilgangsstyring/applikasjoner/layout.tsx`
- `src/app/tilgangsstyring/applikasjoner/[applikasjonId]/page.tsx`
- `src/app/tilgangsstyring/applikasjoner/[applikasjonId]/layout.tsx`

**Nye filer (liste-feature):**
- `src/domains/support/features/Applikasjoner/Applikasjoner.tsx` (+ `.module.css`, `.a11y.test.tsx`, evt. `.test.tsx`)
- `src/domains/support/features/Applikasjoner/components/ApplikasjonerFilter.tsx` (+ `.a11y.test.tsx`)
- `src/domains/support/features/Applikasjoner/components/ApplikasjonerOrderBy.tsx` (+ `.a11y.test.tsx`)
- `src/domains/support/features/Applikasjoner/components/ApplikasjonerResultList.tsx` (+ `.a11y.test.tsx`)
- `src/domains/support/features/Applikasjoner/components/filter/ApplikasjonerSearchFilter.tsx`
- `src/domains/support/features/Applikasjoner/components/filter/ApplikasjonerOrganisasjonFilter.tsx`
- `src/domains/support/features/Applikasjoner/components/filter/ApplikasjonerStatusFilter.tsx`
- `src/domains/support/features/Applikasjoner/components/filter/ApplikasjonerTilgangFilter.tsx` (`@could` — kan utsettes)
- `src/domains/support/features/Applikasjoner/components/OpprettApplikasjonModalButton/OpprettApplikasjonModalButton.tsx`
- `src/domains/support/features/Applikasjoner/components/OpprettApplikasjonModalButton/OpprettApplikasjonForm.tsx`
- `src/domains/support/features/Applikasjoner/hooks/useGetApplikasjoner.ts`
- `src/domains/support/features/Applikasjoner/hooks/useGetApplikasjonerState.tsx`
- `src/domains/support/features/Applikasjoner/hooks/useOpprettApplikasjon.ts`
- `src/domains/support/features/Applikasjoner/hooks/useVerifiserApplikasjonId.ts`

**Nye filer (detalj-feature):**
- `src/domains/support/features/Applikasjon/Applikasjon.tsx` (+ `.module.css`, `.a11y.test.tsx`)
- `src/domains/support/features/Applikasjon/components/ApplikasjonInformation/ApplikasjonInformation.tsx` (+ tester)
- `src/domains/support/features/Applikasjon/components/ApplikasjonTilganger/ApplikasjonTilganger.tsx` (+ tester)
- `src/domains/support/features/Applikasjon/components/ApplikasjonTilganger/ApplikasjonTilgangerFilter.tsx`
- `src/domains/support/features/Applikasjon/components/ApplikasjonTilganger/ApplikasjonTilgangerOrderBy.tsx`
- `src/domains/support/features/Applikasjon/components/ApplikasjonTilganger/ApplikasjonTilgangerList.tsx`
- `src/domains/support/features/Applikasjon/components/PassordbytteDialog/PassordbytteDialog.tsx` (+ tester)
- `src/domains/support/features/Applikasjon/components/RedigerBeskrivelseDialog/RedigerBeskrivelseDialog.tsx`
- `src/domains/support/features/Applikasjon/components/SettAnsvarligDialog/SettAnsvarligDialog.tsx`
- `src/domains/support/features/Applikasjon/components/TildelTilgangDialog/TildelTilgangDialog.tsx`
- `src/domains/support/features/Applikasjon/components/BulkFjernTilgangDialog/BulkFjernTilgangDialog.tsx`
- `src/domains/support/features/Applikasjon/components/DeaktiverApplikasjonButton/DeaktiverApplikasjonButton.tsx`
- `src/domains/support/features/Applikasjon/hooks/useGetApplikasjon.ts`
- `src/domains/support/features/Applikasjon/hooks/useGetApplikasjonTilgangerState.tsx`
- `src/domains/support/features/Applikasjon/hooks/useByttPassord.ts`
- `src/domains/support/features/Applikasjon/hooks/useSetAnsvarlig.ts`
- `src/domains/support/features/Applikasjon/hooks/useFjernAnsvarlig.ts`
- `src/domains/support/features/Applikasjon/hooks/useOppdaterBeskrivelse.ts`
- `src/domains/support/features/Applikasjon/hooks/useTildelTilgang.ts`
- `src/domains/support/features/Applikasjon/hooks/useFjernTilganger.ts`
- `src/domains/support/features/Applikasjon/hooks/useDeaktiverApplikasjon.ts`
- `src/domains/support/features/Applikasjon/hooks/useReaktiverApplikasjon.ts`
- `src/domains/support/features/Applikasjon/hooks/useSokeFeidePrincipal.ts`

**Nye filer (i18n):**
- `src/common/messages/nb/applikasjoner.json`

**Modifiserte filer:**
- `src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.tsx` — nytt `Surface`-kort med lenke til `/tilgangsstyring/applikasjoner`
- `src/domains/search/features/CommandPalette/hooks/useCommands.tsx` — ny kommando "Gå til applikasjoner"
- `src/common/lib/apollo/cacheConfig.ts` — `typePolicies` for `Applikasjon`, `ApplikasjonTilgang`, `FeideBruker`, `FeideGruppe` (verifiser etter schema lander)
- `src/common/messages/index.ts` (eller equivalent registreringspunkt) — registrere `applikasjoner.json`
- `src/common/messages/nb/support.json` — evt. flytt fellesstrenger hvis det er behov

**Auto-generert (ikke manuelt):**
- `src/common/types/generated/routes.d.ts` — oppdateres via `next typegen`
- `src/__generated__/*` — oppdateres via `npm run compile` når schema er klar

## Implementation Tasks

Tasks er gruppert i fire faser. **Fase 0** (forberedelser) kan starte umiddelbart. **Fase 1** (Iter 2 lese) krever ny `applikasjoner`-query og `applikasjon(id)`-query fra backend. **Fase 2** (Iter 2 skrive) krever passordbytte-, ansvarlig- og beskrivelse-mutations. **Fase 3** (Iter 3) krever opprett-, tildel-, fjern-, deaktiver-mutations + ID-verifisering.

Tasks innenfor en fase kan parallelliseres; tasks mellom faser har implisitt avhengighet på backend-leveranse i forrige fase.

---

### Fase 0 — Forberedelser (kan starte uavhengig av backend)

#### Task #1: Sett opp rute-tre og layout-skall

**Priority:** High
**Size:** S
**Dependencies:** None
**Addresses Requirements:** Forutsetning for `-001`, `-002`

**Acceptance Criteria:**
- [ ] `src/app/tilgangsstyring/applikasjoner/page.tsx` rendrer `<Applikasjoner />` (placeholder-komponent)
- [ ] `src/app/tilgangsstyring/applikasjoner/layout.tsx` bruker `PageHeaderWrapper` med breadcrumb-tittel fra i18n
- [ ] `src/app/tilgangsstyring/applikasjoner/[applikasjonId]/page.tsx` rendrer `<Applikasjon />` (placeholder)
- [ ] `src/app/tilgangsstyring/applikasjoner/[applikasjonId]/layout.tsx` har breadcrumb-tittel
- [ ] `npm run dev` viser begge ruter uten 404 og uten konsollfeil
- [ ] `npm run test:typecheck` grønn

**Implementation Notes:**
Speil filstrukturen fra `src/app/tilgangsstyring/maskinbrukere/`. Placeholder-komponentene returnerer bare en heading + "Under utvikling"-tekst inntil senere tasks.

---

#### Task #2: Opprett `applikasjoner.json` i18n-fil og registrere den

**Priority:** High
**Size:** S
**Dependencies:** None

**Acceptance Criteria:**
- [ ] `src/common/messages/nb/applikasjoner.json` opprettet med tomme objekter for hver feature-seksjon
- [ ] Fila registrert i messages-loaderen (sjekk eksisterende mønster i `src/common/messages/`)
- [ ] `useTranslations('applikasjoner.foo')` fungerer uten warnings i komponentene fra Task #1
- [ ] `npm run generate:translations` (hvis kjørt) ikke skader fila

**Implementation Notes:**
Initial-struktur:
```json
{
  "app": { "pageTitle": "Applikasjoner", "breadcrumbTitle": "Applikasjoner" },
  "Applikasjoner": { ... },
  "Applikasjon": { ... },
  "PassordbytteDialog": { ... },
  "SettAnsvarligDialog": { ... },
  "RedigerBeskrivelseDialog": { ... },
  "OpprettApplikasjon": { ... },
  "TildelTilgangDialog": { ... },
  "BulkFjernTilgangDialog": { ... },
  "DeaktiverApplikasjonButton": { ... }
}
```

---

#### Task #3: Oppdater `TilgangsstyringIndex` med applikasjoner-kort

**Priority:** Medium
**Size:** S
**Dependencies:** Task #1, Task #2

**Acceptance Criteria:**
- [ ] Nytt `Surface`-kort i `TilgangsstyringIndex.tsx` med tittel "Applikasjoner", beskrivelse fra i18n, og `ButtonLink` til `/tilgangsstyring/applikasjoner`
- [ ] Eksisterende maskinbruker-kort uberørt
- [ ] a11y-test: ny lenke har riktig label og er fokuserbar
- [ ] `npm run test:a11y` grønn

---

#### Task #4: Legg til CommandPalette-kommando "Gå til applikasjoner"

**Priority:** Low
**Size:** S
**Dependencies:** Task #1

**Acceptance Criteria:**
- [ ] Ny kommando i `useCommands.tsx` med label "Gå til applikasjoner"
- [ ] Navigerer til `/tilgangsstyring/applikasjoner` ved utvelgelse
- [ ] Unit-test for kommandolisten oppdatert hvis den finnes

---

### Fase 1 — Iter 2 lese-flyt (BRU-APP-API-001, -002, -003)

> **Forutsetning:** Backend har levert `applikasjoner(filter, orderBy, first, after)`-connection-query, `applikasjon(id: ID!)`-query, og `Applikasjon`-typen med `tilganger`-relasjon. Sjekk codegen før implementasjon: `npm run compile` skal produsere `Applikasjon`, `ApplikasjonFilterInput`, `ApplikasjonOrderByInput`-typer.

#### Task #5: `useGetApplikasjoner`-hook + `useGetApplikasjonerState`

**Priority:** High
**Size:** M
**Dependencies:** Task #1, Task #2, backend-leveranse for `applikasjoner`-query
**Addresses Requirements:** BRU-APP-API-001

**Acceptance Criteria:**
- [ ] `useGetApplikasjonerState` wrapper rundt `useDataListState` med filter-shape: `{ search, organisasjoner, statuses, tilganger? }`
- [ ] `useGetApplikasjoner(state)` bruker `useDataListQuery` med Apollo-query `GetApplikasjoner`
- [ ] Query er definert inline i hooken (ikke i `queries.ts` — feature-lokalt)
- [ ] First=50, paginering via `fetchMore`
- [ ] Standard sortering: navn stigende
- [ ] Unit-tests for state-default verdier

**Implementation Notes:**
Speil signaturen til `useGetMaskinbrukere`/`useGetMaskinbrukereState`, men ingen kode-gjenbruk. Bruk `gql` template literal og la codegen produsere typer.

---

#### Task #6: `Applikasjoner`-feature komponent (liste-skall)

**Priority:** High
**Size:** M
**Dependencies:** Task #5
**Addresses Requirements:** BRU-APP-API-001 (struktur)

**Acceptance Criteria:**
- [ ] `Applikasjoner.tsx` bruker `ListPageLayout` med:
  - `ListPageActionbar` med placeholder for "Opprett applikasjon" (Iter 3 — render som disabled eller utelat inntil Iter 3 implementeres)
  - `ListPageSidebar` med `<ApplikasjonerFilter />` + `FilterReset`
  - `ListPageContent` med `<ApplikasjonerResultList />`
- [ ] Title fra i18n: `applikasjoner.app.pageTitle`
- [ ] a11y-test grønn

---

#### Task #7: `ApplikasjonerFilter` med org/status/søk

**Priority:** High
**Size:** M
**Dependencies:** Task #5, Task #6
**Addresses Requirements:** BRU-APP-API-001 (søk + filter)

**Acceptance Criteria:**
- [ ] `ApplikasjonerSearchFilter` (fritekst på navn) — debounced input som oppdaterer `state.search`
- [ ] `ApplikasjonerOrganisasjonFilter` (multi-select) — henter org-liste fra eksisterende `useGetOrganisasjoner` eller equivalent
- [ ] `ApplikasjonerStatusFilter` (multi-select: AKTIV, DEAKTIVERT)
- [ ] Alle filtre pakket i `FilterWrapper`
- [ ] Kombinasjon av filtre + søk vises i URL via `useDataListState`
- [ ] a11y-tester for hver filter-komponent

**Implementation Notes:**
`ApplikasjonerTilgangFilter` er `@could` i kravet — utelates fra første leveranse, legges til som task i Iter 3 (Task #19) eller backlog.

---

#### Task #8: `ApplikasjonerOrderBy` (sortering på navn)

**Priority:** High
**Size:** S
**Dependencies:** Task #5
**Addresses Requirements:** BRU-APP-API-001 (sortering)

**Acceptance Criteria:**
- [ ] Toggle stigende/synkende på navn
- [ ] State synkes via `useDataListState`
- [ ] a11y-test

---

#### Task #9: `ApplikasjonerResultList` — navigasjonsliste

**Priority:** High
**Size:** M
**Dependencies:** Task #5
**Addresses Requirements:** BRU-APP-API-001 (resultatliste + paginering + navigering)

**Acceptance Criteria:**
- [ ] `NavigationList` med rader som viser: Navn, Beskrivelse, Miljøer (chips), Ansvarlig, Organisasjon, Status (chip)
- [ ] Klikk på rad navigerer til `/tilgangsstyring/applikasjoner/[id]`
- [ ] "Last 50 flere"-knapp under listen når `hasNextPage` (skjult når alt er lastet)
- [ ] Total/lastet count vises (f.eks. "50 av 137 applikasjoner")
- [ ] Loading skeleton (følg `MaskinbrukereResultList`-mønsteret)
- [ ] Empty-state med beskjed: "Ingen applikasjoner funnet"
- [ ] Feilmelding ved Apollo-error
- [ ] a11y-test

---

#### Task #10: `useGetApplikasjon`-hook + `Applikasjon`-detalj-skall

**Priority:** High
**Size:** M
**Dependencies:** Task #1, backend `applikasjon(id)`-query
**Addresses Requirements:** BRU-APP-API-002

**Acceptance Criteria:**
- [ ] `useGetApplikasjon(id)` bruker Apollo `useQuery` med inline GraphQL-query
- [ ] `Applikasjon.tsx` bruker `DetailPageLayout` med:
  - `DetailPageTopBar`: visningsnavn, status-chip, org, miljøer (chips), ansvarlig
  - `DetailPageTabbedContent` med to tabs: "Informasjon", "Tilganger" (panel-placeholder i denne tasken)
- [ ] Loading / error / not-found states
- [ ] a11y-test

---

#### Task #11: `ApplikasjonInformation`-tab

**Priority:** High
**Size:** M
**Dependencies:** Task #10
**Addresses Requirements:** BRU-APP-API-002 (alle scenarios)

**Acceptance Criteria:**
- [ ] Viser i logiske datagrupper:
  - Grunnleggende: navn, beskrivelse
  - Identifikasjon: identitetsleverandør, ekstern ID, intern ID
  - Miljøer: chips
  - Ansvarlig: navn/type + "Endre"-knapp (Task #14)
  - Sporing: opprettet av/tid, endret av/tid (formatert via `useLocalizedDateFunctions`)
- [ ] Action-knapper "Rediger beskrivelse" (Task #15) synlig kun når bruker har rettighet
- [ ] a11y-test

---

#### Task #12: `ApplikasjonTilganger`-tab (nestet liste)

**Priority:** High
**Size:** L
**Dependencies:** Task #10, backend `tilganger`-relasjon på `Applikasjon`
**Addresses Requirements:** BRU-APP-API-003

**Acceptance Criteria:**
- [ ] Egen `useGetApplikasjonTilgangerState` (separat `nuqs`-prefix `t_` for å unngå kollisjon)
- [ ] `ActionList` med checkbox-seleksjon (forberedelse for Task #21 bulk-fjern)
- [ ] Filter på miljø (dynamisk valgliste — kun miljøer applikasjonen har)
- [ ] Filter på tilgang (dynamisk valgliste — kun tilganger applikasjonen er tildelt)
- [ ] Sortering på miljø eller tilgangskode
- [ ] Paginering 50 + last-flere
- [ ] a11y-test

**Implementation Notes:**
Hvis backend ikke støtter `nuqs`-synket state i tab — verifiser konvensjon i `MaskinBruker/ApiTilganger` først. Hvis ikke, fall tilbake til local state.

---

### Fase 2 — Iter 2 skrive-flyt (BRU-APP-API-004, -005, -006)

> **Forutsetning:** Backend har levert mutations `byttPassord`, `setAnsvarlig`, `fjernAnsvarlig`, `oppdaterBeskrivelse`, samt søk-API for feide-bruker/gruppe i org.

#### Task #13: `PassordbytteDialog` + `useByttPassord`-hook

**Priority:** High
**Size:** M
**Dependencies:** Task #10, backend `byttPassord`-mutation
**Addresses Requirements:** BRU-APP-API-004

**Acceptance Criteria:**
- [ ] Trigger-knapp "Bytt passord" i `DetailPageTopBar` — synlig kun ved rettighet
- [ ] Dialog-flyt:
  - Steg 1: bekreftelses-skjerm ("Et nytt passord vil genereres. Det gamle slutter å virke umiddelbart.")
  - Steg 2 (etter generering): vis passord skjult med vis/skjul-toggle og kopier-til-utklippstavle-knapp
  - "Lukk" → state nulles, dialog stenges, passord ikke gjenfinnelig
- [ ] Passord lagres i `useState` lokalt — ikke i Apollo cache
- [ ] `useByttPassord` bruker `useMutation` med `optimisticResponse: undefined` (vi vil ikke at passord skal mistolkes som persistert)
- [ ] a11y-test inkl. focus trap og copy-action
- [ ] Test: stenging av dialog mellom steg 1 og steg 2 avbryter ikke mutationen (den må kjøres ferdig på server hvis allerede igangsatt)

**Implementation Notes:**
Bruk `Dialog` fra `@sikt/sds-dialog` direkte, ikke `ButtonWithConfirmation` (vi trenger custom innhold). Kopier-til-utklippstavle via `navigator.clipboard.writeText`. Vis advarsel hvis bruker er i Iframe / clipboard blokkert.

---

#### Task #14: `SettAnsvarligDialog` + søk-hook + mutations

**Priority:** High
**Size:** L
**Dependencies:** Task #11, backend `setAnsvarlig`/`fjernAnsvarlig` + søk-API
**Addresses Requirements:** BRU-APP-API-005

**Acceptance Criteria:**
- [ ] "Endre ansvarlig"-knapp i `ApplikasjonInformation`-tab — synlig ved rettighet for applikasjonens org
- [ ] Dialog med:
  - Tekst-input for søk (debounced)
  - Resultatliste — kun treff fra applikasjonens egen org
  - Velg → ny ansvarlig settes via mutation
  - "Fjern ansvarlig"-knapp i topbar når ansvarlig finnes
- [ ] `useSokeFeidePrincipal(query, organisasjonId)` returnerer feide-brukere; `@could`: også feide-grupper i samme respons
- [ ] Cache-oppdatering via `useFragmentUpdate` på `Applikasjon.ansvarlig`
- [ ] a11y-test
- [ ] Test: rettighet sjekkes server-side; UI vise/skjuler kun

**Implementation Notes:**
`@could`-scenarios for feide-gruppe: implementer hvis backend leverer det i samme søke-API. Hvis ikke, dokumenter som backlog.

---

#### Task #15: `RedigerBeskrivelseDialog` + `useOppdaterBeskrivelse`

**Priority:** Medium
**Size:** S
**Dependencies:** Task #11, backend `oppdaterBeskrivelse`-mutation
**Addresses Requirements:** BRU-APP-API-006

**Acceptance Criteria:**
- [ ] "Rediger beskrivelse"-knapp i `ApplikasjonInformation`-tab — synlig ved rettighet
- [ ] Dialog med `TextField`/`TextArea` + "Lagre"/"Avbryt"
- [ ] Tom beskrivelse er gyldig (krav sier ikke noe om obligatorisk)
- [ ] Cache-oppdatering via `useFragmentUpdate`
- [ ] a11y-test

---

### Fase 3 — Iter 3 selvbetjent administrasjon (BRU-APP-API-007 til -010)

> **Forutsetning:** Backend har levert mutations `opprettApplikasjon` (med ID-verifisering), `tildelTilgang`, `fjernTilganger`, `deaktiverApplikasjon`, `reaktiverApplikasjon`, samt query for tildelbare tilganger.

#### Task #16: `OpprettApplikasjonModalButton` + `OpprettApplikasjonForm`

**Priority:** High
**Size:** XL
**Dependencies:** Task #6, backend mutations + verifiseringsflyt
**Addresses Requirements:** BRU-APP-API-009

**Acceptance Criteria:**
- [ ] Knapp i `ListPageActionbar` på `Applikasjoner`-lista (erstatter placeholder fra Task #6)
- [ ] Modal-flyt med stadier:
  - **Steg 1: Velg identitetsleverandør** (radio: Feide / Maskinporten — FS er ikke valgbar)
  - **Steg 2: Ekstern ID + verifisering** (input + "Verifiser"-knapp → kaller `verifiserApplikasjonId(idP, eksternId)`; viser hentet navn fra idP)
  - **Steg 3: Velg organisasjon** (kun synlig hvis bruker har flere orgs / er super-admin; ellers implisitt)
  - **Steg 4: Bekreft** → kaller `opprettApplikasjon`-mutation → naviger til detaljside for ny applikasjon
- [ ] Feilhåndtering for tre avvisningsgrunner:
  - "ID-en kunne ikke verifiseres" (ikke funnet hos idP)
  - "ID-en er allerede registrert"
  - "Visningsnavnet er allerede i bruk"
- [ ] Avbryt-knapp tilgjengelig på alle steg
- [ ] Apollo cache `refetchQueries: [GetApplikasjoner]` etter opprettelse
- [ ] a11y-test for hvert steg + focus management
- [ ] Test: super-admin ser alle orgs i org-valg

**Implementation Notes:**
**XL — vurder splitting:** Hvis dette blir for stort, splitt i: (a) modal-skall + idP-valg (S), (b) ID-input + verifisering (M), (c) org-valg + opprettelse (M), (d) feilhåndtering + naviger (S). Speil `OpprettRundeModalButton`+`OpprettRundeForm`-mønsteret.

---

#### Task #17: `TildelTilgangDialog` + `useTildelTilgang`

**Priority:** High
**Size:** L
**Dependencies:** Task #12, backend mutation + "tildelbare tilganger"-query
**Addresses Requirements:** BRU-APP-API-007

**Acceptance Criteria:**
- [ ] "Tildel tilgang"-knapp i `ApplikasjonTilganger`-tab — synlig ved rettighet for applikasjonens org
- [ ] Dialog-flyt:
  - Velg miljø (dropdown — kun miljøer brukeren administrerer)
  - Velg org (dropdown — kun synlig hvis bruker administrerer flere orgs)
  - Multi-select tilganger — kun tilganger brukeren har rett til å tildele
  - Allerede tildelte tilganger i valgt miljø vises **gråtonet og ikke-valgbar** med tooltip "Allerede tildelt"
- [ ] Multi-tilgang i samme miljø → én mutation-kall med liste
- [ ] Cache-oppdatering via `useFragmentUpdate` på `Applikasjon.tilganger`
- [ ] a11y-test (multi-select med disabled-state er a11y-utfordrende — verifiser)

**Implementation Notes:**
Disabled-rader i multi-select: bruk `aria-disabled="true"` + `aria-describedby` for tooltip-tekst. Sjekk SDS-multi-select-komponenten for støtte.

---

#### Task #18: `BulkFjernTilgangDialog` + enkelt-fjern + `useFjernTilganger`

**Priority:** High
**Size:** M
**Dependencies:** Task #12, backend `fjernTilganger`-mutation
**Addresses Requirements:** BRU-APP-API-008

**Acceptance Criteria:**
- [ ] Enkelt-fjern via `ButtonWithConfirmation` på hver `ActionList`-rad — message inkluderer tilgang + miljø
- [ ] Bulk-fjern via knapp i `ActionList`-actionbar (synlig når én eller flere er valgt) → åpner `BulkFjernTilgangDialog`
- [ ] Dialog lister alle valgte tilganger + felles miljø; "Bekreft"/"Avbryt"
- [ ] Skjul fjern-handling for tilganger uten rettighet
- [ ] Cache-oppdatering
- [ ] a11y-test

**Implementation Notes:**
Krav `-008` sier "flere tilganger i ett miljø" — bulk-flyten er begrenset til ett miljø om gangen. Hvis brukeren har valgt på tvers av miljøer, fall tilbake til "Velg tilganger fra ett miljø om gangen"-feilmelding eller filtrér seleksjonen til aktivt miljø.

---

#### Task #19: `ApplikasjonerTilgangFilter` (`@could` fra `-001`)

**Priority:** Low
**Size:** S
**Dependencies:** Task #7
**Addresses Requirements:** BRU-APP-API-001 (`@could` filter på tilgang)

**Acceptance Criteria:**
- [ ] Multi-select med tilgangs-typer fra backend
- [ ] State i `useGetApplikasjonerState`-filter
- [ ] a11y-test

**Implementation Notes:**
`@could` — vurder å droppe hvis backend ikke leverer eller hvis det kompliserer prioritert leveranse.

---

#### Task #20: `DeaktiverApplikasjonButton` + reaktivering

**Priority:** Medium
**Size:** S
**Dependencies:** Task #10, backend `deaktiver`/`reaktiver`-mutations
**Addresses Requirements:** BRU-APP-API-010

**Acceptance Criteria:**
- [ ] Knapp i `DetailPageTopBar` — synlig ved rettighet
- [ ] Tekst dynamisk: "Deaktiver" / "Reaktiver" basert på status
- [ ] `ButtonWithConfirmation` med kontekst-spesifikk message
- [ ] Cache-oppdatering setter `status` riktig
- [ ] Status-chip i topbar oppdateres
- [ ] Tilgangene blir bevart i datamodellen (verifiser via cache + re-fetch)
- [ ] a11y-test

---

### Fase 4 — Felles forbedringer

#### Task #21: Apollo cache `typePolicies` for nye typer

**Priority:** Medium
**Size:** S
**Dependencies:** Task #5, Task #10 (når GraphQL-typer er importert)

**Acceptance Criteria:**
- [ ] `typePolicies` for `Applikasjon`, `ApplikasjonTilgang`, `FeideBruker`, `FeideGruppe` med `keyFields: ['id']`
- [ ] `applikasjoner`-feltet på Query bruker `relayStylePagination` eller equivalent (sjekk eksisterende mønster i `cacheConfig.ts`)
- [ ] Test: cache merge mellom flere `fetchMore`-kall fungerer
- [ ] Test: mutation-oppdateringer reflekteres uten manuell refetch

---

#### Task #22: Slå sammen i18n-strenger og kjør `externalize-i18n` på alle nye komponenter

**Priority:** Low
**Size:** S
**Dependencies:** Alle øvrige feature-tasks

**Acceptance Criteria:**
- [ ] Ingen hardkodede norske strenger igjen i nye komponenter
- [ ] `applikasjoner.json` har konsistent nøkkel-naming
- [ ] `npm run formatcheck` grønn på i18n-fila

---

## Risk Assessment

### Technical Risks

- **Risk: Backend-leveranse i #455 er bredere enn forventet og inkluderer breaking changes på eksisterende `Maskinbruker`-type.**
  - **Mitigation:** Hold maskinbruker-feature urørt; ny `Applikasjon`-type lever parallelt. Verifiser med backend-agent at de ikke renamer eksisterende.

- **Risk: ID-verifisering mot idP i `-009` har lang latens (Maskinporten/Feide-oppslag kan ta sekunder).**
  - **Mitigation:** Loading-state med spinner i form-steg 2. Timeout og brukervennlig feilmelding.

- **Risk: Multi-select med disabled-rader for allerede tildelte tilganger er a11y-utfordrende.**
  - **Mitigation:** Sjekk SDS-komponentstøtte tidlig. Hvis ikke støttet, fallback til separat "Tildelte"/"Ikke tildelte"-seksjoner.

- **Risk: Passord-mutation returnerer sensitive data; utilsiktet persistering i Apollo cache er sikkerhetsrisiko.**
  - **Mitigation:** Eksplisitt aldri lagre i cache (`fetchPolicy: 'no-cache'` på mutation eller manuell håndtering). Sikkerhetsreview av PR.

- **Risk: Roller/autorisasjon ikke håndhevet konsistent server-side → UI viser knapper bruker ikke har rett til.**
  - **Mitigation:** Frontend rendrer kun basert på data fra `Me`-query / felter på `Applikasjon` (f.eks. `kanRedigere`-felt). Forventer at backend leverer dette på `Applikasjon`-typen.

- **Risk: `nuqs`-prefix-kollisjon mellom list-state og tab-state.**
  - **Mitigation:** Bruk eksplisitt prefix `t_` på `ApplikasjonTilganger`-state. Verifiser at filter-state ikke deles på tvers av tabs.

### Project Risks

- **Risk: Iter 2 lese-flyt landes før Iter 3 mutations — hva skjer hvis bruker prøver å gjøre en handling i mellomtiden?**
  - **Mitigation:** Iter 2-PR landes med action-knapper skjult (feature flag eller `disabled`). Iter 3-PR aktiverer dem.

- **Risk: Backend forsinkelse blokkerer hele leveransen.**
  - **Mitigation:** Hold MSW-mock-tilnærmingen i bakhånd. Auto-memory har eksisterende mønster for codegen-eksklusjon hvis vi må gå dit.

### Testing Requirements

- Unit tests for hver hook (input/output, error handling)
- a11y-tester for hver komponent (mandatory per CLAUDE.md)
- Integration test: list → detalj → tilbake bevarer filter/sort/page-state
- Integration test: opprett applikasjon-flyt (alle tre avvisnings-stier)
- Manuell test i dev-server: golden path for hver flyt + golden tab-navigering
- Visuell test: kjør Storybook for nye komponenter hvis tidsbudsjett tillater

## Success Criteria

- [ ] Alle 10 krav `BRU-APP-API-001` til `-010` har minst én tilhørende task
- [ ] Alle `@must @planned`-scenarios passerer (Playwright når lage-steps kjøres etterpå)
- [ ] `npm run lint`, `npm run test:typecheck`, `npm run test`, `npm run test:a11y` grønne
- [ ] Coverage-terskler holdes (60 % branches/functions/lines, 90 % statements)
- [ ] Ingen regresjoner i eksisterende maskinbruker-feature
- [ ] PR(er) reviewes av minst én utvikler + UX-sjekk for opprett-/passord-/tildel-dialogene
- [ ] Code lever uten konsollfeil i dev-server

## Requirements Traceability

| Krav-ID | Krav-tittel | Adresseres av tasks | Iterasjon | Status |
|---|---|---|---|---|
| BRU-APP-API-001 | Listevisning og søk | #5, #6, #7, #8, #9, #19 (`@could`) | 2 | Planlagt |
| BRU-APP-API-002 | Se detaljer | #10, #11 | 2 | Planlagt |
| BRU-APP-API-003 | Vise tilganger | #12 | 2 | Planlagt |
| BRU-APP-API-004 | Passordbytte | #13 | 2 | Planlagt |
| BRU-APP-API-005 | Administrere ansvarlig | #14 | 2 | Planlagt |
| BRU-APP-API-006 | Redigere beskrivelse | #15 | 2 | Planlagt |
| BRU-APP-API-007 | Tildele tilgang | #17 | 3 | Planlagt |
| BRU-APP-API-008 | Fjerne tilgang | #18 | 3 | Planlagt |
| BRU-APP-API-009 | Opprette applikasjon | #16 | 3 | Planlagt |
| BRU-APP-API-010 | Deaktivere applikasjon | #20 | 3 | Planlagt |

**Tverr-gående tasks** som ikke er knyttet til et enkelt krav:
- Task #1 (rute-tre) — forutsetning for `-001`, `-002`
- Task #2 (i18n-fil) — forutsetning for all UI
- Task #3 (TilgangsstyringIndex) — discovery/navigasjon
- Task #4 (CommandPalette) — discovery
- Task #21 (Apollo cache) — felles kvalitet
- Task #22 (i18n-cleanup) — felles kvalitet

## Delivery Order

**Anbefalt PR-rekkefølge:**

1. **PR-1 (Fase 0):** Tasks #1, #2, #3, #4 — rute-skall + i18n + navigasjon. Kan landes uten backend.
2. **PR-2 (Fase 1):** Tasks #5–#12 — Iter 2 lese-flyt. Krever backend `applikasjoner`/`applikasjon`-queries.
3. **PR-3 (Fase 2):** Tasks #13, #14, #15 — Iter 2 skrive-flyt. Krever passord-/ansvarlig-/beskrivelse-mutations.
4. **PR-4 (Fase 3):** Tasks #16, #17, #18, #19, #20 — Iter 3 admin-flyt. Krever opprett-/tildel-/fjern-/deaktiver-mutations + ID-verifisering.
5. **PR-5 (cleanup):** Tasks #21, #22 — Apollo cache-policies + i18n-finpuss.

PR-1 kan starte umiddelbart; PR-2 til -4 venter på backend-milestones i #455. PR-5 kan kjøres parallelt med PR-3/-4.