# Analysis: Applikasjon-tilgangsstyring — justeringer (ansvarlig-fjerning + filter-scope)

## Problem Statement

Krav-kilden (delta-en `11ce66c..40f04cb` på `sikt-no/fs` branch `fruitbat`)
strammer inn applikasjon-tilgangsstyringen langs to ortogonale akser:

1. **Ansvarlig-rollen er fjernet fra datamodellen for applikasjoner.** Ikke
   omdøpt, ikke redusert i scope — *fjernet*. Hele K18-kapabiliteten
   ("Administrere ansvarlig for applikasjon") og den V2-baserte
   opprettelses-kontrakten som tvang `ansvarligId` skal bort. Påvirker
   listevisning (kolonne + synlighetsregel), detaljside (felt + dialog),
   opprettelses-flyten, redigér-detaljer-skjemaet, og en kandidat-handling
   i den planlagte endringslogg-fanen (iter 4).
2. **Miljø- og organisasjonsfiltrene endrer scope-semantikk.** På
   applikasjonsoversikten og på tilganger-fanen flyttes filter-opsjonene fra
   "*det som faktisk er i resultatlisten nå*" til "*alt brukeren /
   applikasjonen potensielt kan ha å gjøre med*". For listevisningen er det
   "alle miljøer på tvers av brukerens organisasjoner" og "alle
   organisasjoner brukeren har rettighet til". For tilganger-fanen er det
   "alle miljøer applikasjonen kan tilordnes tilganger i" og "alle
   organisasjoner som kan gi applikasjonen en tilgang".

Spec-doc med autoritativ liste over alle berørte krav-filer ligger i
[`spec-changes-2026-06-01-11ce66c..40f04cb.md`](spec-changes-2026-06-01-11ce66c..40f04cb.md).
Denne analysen kartlegger hvordan eksisterende fs-admin-kode står seg mot
de nye kravene.

## Current State

Begge featurene er allerede implementert mot et tidligere kravsett (Iter 2
+ Iter 3, inkludert K18 "ansvarlig" og resultat-derivert filter-scope).
Featurene følger fs-admin-mønstrene `ListPageLayout` og `DetailPageLayout`
+ `DetailPageTabbedContent`. Tilganger-fanen rendrer en innebygd
`ListPageLayout` inni tab-body (et dokumentert cross-pattern fra
`fs-admin-patterns`).

### Applikasjonsliste (Iter 2 K1/K2/K11/K12) — `src/domains/support/features/Applikasjoner/`

- **Page entry:** [`Applikasjoner.tsx:17-35`](../../../src/domains/support/features/Applikasjoner/Applikasjoner.tsx) — `ListPageLayout` + sidebar-filter + result-list.
- **Skjerm-nivå query:** `GET_APPLIKASJONER` i [`useGetApplikasjoner.tsx:26-62`](../../../src/domains/support/features/Applikasjoner/hooks/useGetApplikasjoner.tsx). Selecter `ansvarlig { __typename ... on FeideBruker { visningsnavn } ... on FeideGruppe { visningsnavn } }` (linje 45-53).
- **Result list:** [`ApplikasjonerResultList.tsx`](../../../src/domains/support/features/Applikasjoner/components/ApplikasjonerResultList.tsx) viser 6 celler per rad — Navn/beskrivelse, Miljøer, **Ansvarlig** (linje 58 + 112-115), Organisasjon, Antall tilganger, Status.
- **Filtre** (alle i `components/filter/`):
  - `ApplikasjonerSearchFilter` — fritekst (uendret).
  - `ApplikasjonerStatusFilter` — hardkodet enum (uendret).
  - `ApplikasjonerMiljoFilter.tsx:18` — hardkodet `MILJO_OPTIONS = [Produksjon, Demo, Test, Utvikling]`. Alle fire opsjoner vises uavhengig av kontekst.
  - `ApplikasjonerOrganisasjonFilter.tsx:42` — leser fra `useMineLaresteder()` (persona-scoped lærested-liste).
- **State:** `useGetApplikasjonerState` på `useDataListState` (URL-synket).

### Detaljside (Iter 2 K3 + Iter 3 + K19 + K5) — `src/domains/support/features/Applikasjon/`

- **Page entry:** [`Applikasjon.tsx`](../../../src/domains/support/features/Applikasjon/Applikasjon.tsx) — `DetailPageLayout` + topbar + tabs.
- **To tabs montert i dag:** `Informasjon` (med `ApplikasjonInformation`-fragment) og `Tilganger` (med `ApplikasjonTilganger`-fragment + nestet `ListPageLayout`). **Endringslogg-tab finnes ikke ennå** — det er fortsatt iter 4 / `@draft`.
- **Informasjon-fanen:** [`ApplikasjonInformation.tsx`](../../../src/domains/support/features/Applikasjon/components/ApplikasjonInformation.tsx) eksponerer fragmentet `ApplikasjonInformationFields` (linje 45-93) med `ansvarlig`-union (linje 57-77) + tillatelses-flagget `kanAdministrereAnsvarlig` (linje 88). Rendrer "Miljøer og ansvarlig"-seksjonen som inkluderer ansvarlig som tredje `OutputField` (linje 233-256).
- **RedigerDetaljer-skjema:** [`RedigerDetaljerForm.tsx`](../../../src/domains/support/features/Applikasjon/components/RedigerDetaljer/RedigerDetaljerForm.tsx) håndterer navn + beskrivelse + ansvarlig som en treenighet. Embedder `SettAnsvarligDialog` som "popover" (linje 19-22, 187-205) og har dedikert dirty-tracking (`ansvarligEndret`, linje 205).
- **SettAnsvarligDialog:** Dedikert mappe `Applikasjon/components/SettAnsvarligDialog/` med `searchAnsvarligKandidater.ts` (query `GET_ANSVARLIG_KANDIDATER`) + `settApplikasjonAnsvarligMutation.ts` + dialog-komponenten.
- **Tilganger-fanen:** [`ApplikasjonTilganger.tsx`](../../../src/domains/support/features/Applikasjon/components/ApplikasjonTilganger.tsx) eksponerer fragmentet `ApplikasjonTilgangerFields` (linje 66-78) som selecter `miljoer` + `organisasjon`. Lazy sub-query `GET_APPLIKASJON_TILGANGER` (separat operation).
  - `availableMiljoer` = `applikasjon.miljoer` (linje 247) — dvs. miljøene applikasjonen **er aktiv i** (har tilganger i).
  - `availableOrganisasjoner` (linje 131-145) = **deduplisert klient-side** fra de innlastede tilgangs-radene, via `apolloClient.cache.readFragment` mot `APPLIKASJON_TILGANG_ROW_FRAGMENT`.

### Opprett-flyt (Iter 3 K8)

- **Dialog:** `Applikasjoner/components/OpprettApplikasjonDialog/OpprettApplikasjonDialog.tsx` + `AnsvarligSearch.tsx` (frittstående søk-komponent i samme mappe).
- **Mutation:** [`mutation.ts:21-57`](../../../src/domains/support/features/Applikasjoner/components/OpprettApplikasjonDialog/mutation.ts) bruker `OpprettApplikasjonV2($input: OpprettApplikasjonInputV2!)`. V2-shapen krever `ansvarligId: ID!` (se mock-skjema `src/mocks/schema/applikasjoner.graphql:319`). Skjemaet har én feilvariant `AnsvarligPaakrevdVedOpprettelse` som returneres når feltet mangler.

### Mock-API (utviklings-fasen)

Per `bat-skill fs-admin-mock-api-with-data`-konvensjonen er hele backend-overflaten satt opp som mock-API i `src/mocks/`. Krav-endringen berører:
- `src/mocks/schema/applikasjoner.graphql` — typene `Ansvarlig`, `AnsvarligType`, `AnsvarligIkkeIApplikasjonsOrganisasjon`, `AnsvarligPaakrevdVedOpprettelse`, mutations `settApplikasjonAnsvarlig` + `fjernApplikasjonAnsvarlig`, query `ansvarligKandidater`, input `SettApplikasjonAnsvarligInput`, og `ansvarligId: ID!` på `OpprettApplikasjonInputV2`.
- `src/mocks/types/applikasjoner.ts` — speiler skjema-typene.
- `src/mocks/fixtures/applikasjoner/ansvarlige.ts` + `applikasjoner.ts:181-360` — synlighets-flagget `personaIsAnsvarlig` + `PERSONA_ANSVARLIG_APP_IDS` realiserer den (nå fjernede) "Synlighet via ansvarlig-relasjon"-regelen i fiksturene.
- `src/mocks/handlers/applikasjoner/queries.ts` + `mutations.ts` — resolvers for ansvarlig-baserte mutasjoner og kandidat-søk.

### Oversetting

`src/common/messages/nb/support.json` har ~25 `ansvarlig`-nøkler fordelt på fire seksjoner:
- `OpprettApplikasjonDialog` (linje 79-91) — `ansvarligLegend`, `ansvarligSearchLabel`, `ansvarligSearchPlaceholder`, `ansvarligEmptyResults`, `ansvarligHintMinLength`, `ansvarligHintVelgOrganisasjonFørst`, `errorAnsvarligRequired`, `errorAnsvarligPaakrevdVedOpprettelse`.
- `Applikasjon` (linje 107-126) — `miljoerOgAnsvarligSectionTitle`, `ansvarligLabel`, `ansvarligEmpty`, `ansvarligTypeFeideBruker`/`FeideGruppe`, `settAnsvarligButton`, `endreAnsvarligButton`.
- `RedigerDetaljerForm` (linje 158-165) — `ansvarligLabel`, `ansvarligPlaceholder`, `ansvarligReadOnlyHelp`, `errorAnsvarligRequired`.
- `SettAnsvarligDialog` (linje 389-403) — `headingSett`, `headingEndre`, `searchLabel`, submit-knapper.
- Beskrivelses-tekst på domene-index-siden (linje 468) inkluderer ordet "ansvarlige" — bør justeres.

## Key Findings

### F1 — Ansvarlig-fjerningen er en typebaserende kjede

`ansvarlig` er ikke et tekstfelt vi kan rive ut isolert. Det er et union-felt (`FeideBruker | FeideGruppe`) typet inn i to colocated fragmenter (`ApplikasjonInformationFields`, query-inline shape på `GetApplikasjoner`), med tilhørende permission-flagg (`kanAdministrereAnsvarlig`) og dedikerte typer i error-unionen (`AnsvarligIkkeIApplikasjonsOrganisasjon`, `AnsvarligPaakrevdVedOpprettelse`). Når serverskjemaet dropper feltet, må klient-fragmentene oppdateres *atomisk* med serveren — ellers slår codegen feil. I praksis: én rekkefølge for endringen som mocks-først holder klienten kompilerbar gjennom hele endringen.

### F2 — `RedigerDetaljerForm` mister én av tre felter, og det forenkler en del

Skjemaet er bygget rundt navn + beskrivelse + ansvarlig som tre parallelle redigerbare felt med uavhengig dirty-tracking, parallelle mutations via `Promise.allSettled`, og en innebygd dialog for ansvarlig-popover-en. Når ansvarlig forsvinner:
- "Lagre"-handleren skal kun fire `REDIGER_APPLIKASJON_NAVN` + `REDIGER_APPLIKASJON_BESKRIVELSE` (Promise.allSettled-loopen blir 2-vei i stedet for 3-vei minus-en-defensiv-no-op).
- `currentAnsvarlig`/`ansvarligDialogMode`-state og `SettAnsvarligDialog`-importen kan fjernes.
- `kanRedigereDetaljer = kanRedigereNavn || kanRedigereBeskrivelse` (uten || `kanAdministrereAnsvarlig`).
- Seksjons-overskriften "Miljøer og ansvarlig" i lesemodus blir bare "Miljøer".

Skjemaet blir merkbart enklere — dette er positiv kompleksitetsreduksjon, ikke teknisk gjeld vi tar på oss.

### F3 — `OpprettApplikasjonDialog` mutation-shapen må bestemmes eksplisitt

V2-mutasjonen ble innført for å innføre `ansvarligId` som obligatorisk. Når kravet fjernes, finnes tre alternativer:
- **(a)** Reverse til V1 (`opprettApplikasjon($input: OpprettApplikasjonInput!)`). V1-mutasjonen er fortsatt på skjemaet men deprecated. Krever ingen schema-endring, men mister V1's `navn` ikke er obligatorisk-egenskap (V1-shapen tillot kanskje at navn ble hentet kun fra idP).
- **(b)** Modifiser V2 til å gjøre `ansvarligId` valgfri, beholde `navn` som obligatorisk. Krever schema-endring (`ansvarligId: ID` i stedet for `ansvarligId: ID!`).
- **(c)** Introduser V3 uten ansvarligId-feltet. Mest renslig hvis V2 må holdes for backwards-compat, men gir to deprecated mutasjoner samtidig.

Krav-eier-intensjonen: "Opprettelse krever **et navn**" (`opprette_applikasjon.feature` Regel) + "Opprettelse krever **valg av identitetsleverandør**" + "Opprettelse krever **en organisasjon**". Ingen ansvarlig-krav. Min lesning er at (b) bevarer V2's øvrige V1→V2-stramminger (obligatorisk `navn`, navn-uniqueness, etc.) uten å introdusere V3 — men dette er en producer-side avgjørelse, ikke en konsument-avgjørelse. Flagges i Open Questions.

### F4 — Filter-scope-endringen krever nye datakilder, ikke bare ny logikk

**Listevisning miljø-filter:** Nåværende `MILJO_OPTIONS` hardkoder hele enum-en. Krav: "alle miljøer applikasjoner kan tilordnes tilganger i, på tvers av organisasjonene brukeren har rettighet til". Dette er en *snittmengde*, ikke en *avgrensning* — kreves et serverside-felt eller -query som returnerer det persona-scopede miljø-settet, scope-et til organisasjoner-med-rettighet. Hardkodet enum vil typisk være en supermengde (alle 4 miljøer vises selv om brukeren ikke har rettighet til noen organisasjon i Utvikling-miljøet), så det er en strammere kontrakt, ikke en mildere.

**Listevisning organisasjons-filter:** Bruker allerede `useMineLaresteder()`. Semantisk match-en med kravet "alle organisasjoner brukeren har rettighet til" avhenger av om `megVedLarested` betyr *applikasjonsadministrator-rolle-på-organisasjon* eller en bredere *affiliasjon*. Verifiseres mot real-API-en før vi kan si dette er match-en — flagges i Open Questions.

**Tilganger-fanen begge filtre:** Større endring. Begge option-sett-ene er klient-derivert fra resultat-rader/applikasjons-fragmentet i dag, og kravet flytter dem til "potensielt scope". `availableMiljoer = applikasjon.miljoer` blir feil (det er "er aktiv i", mens kravet er "kan tilordnes tilganger i"). `availableOrganisasjoner = dedup-fra-loaded-rows` blir feil (det er "har tilganger hos", mens kravet er "kan gi applikasjonen en tilgang"). For begge trengs serverside-eksponering — enten som nye felt på `Applikasjon`-typen (f.eks. `applikasjon.potensielleMiljoer`, `applikasjon.potensielleTildelendeOrganisasjoner`) eller som en sub-query. Det er en producer-side designavgjørelse som hører hjemme i `bat-graphql-dev` når planen lages.

### F5 — Endringslogg-fanen er fortsatt `@draft`, ingen kode-impact

`endringslogg.feature` ble endret slik at "ansvarlig" droppes fra AVKLAR-spørsmålets eksempel-handlinger. Hele iterasjon 4 har fortsatt status `@must @draft`, og Applikasjon.tsx monterer ikke noen endringslogg-tab i dag. Den eneste impact er at *når* iter 4 implementeres, listen over loggbare handlinger skal ikke inkludere ansvarlig (men det er hypotetisk allerede løst ved at hele ansvarlig-rollen er borte når iter 4 lander).

### F6 — Mock-API-en er den faktiske backend i dag

Mock-API-en speiler hva producer-teamet skal levere. Endringen på klient-siden er ikke gjennomførbar uten å oppdatere mocken parallelt — ellers vil verken Apollo-codegen eller dev-server stå seg. Per `fs-admin-mock-api-with-data`-konvensjonen skal mock-skjemaet alltid kunne rives ned billig når den ekte API-en lander, så endringene her er ikke "teknisk gjeld" — de er en del av kontrakts-spesifikasjonen producer-teamet skal speile.

### F7 — Krav-eier-inkonsistenser oppdaget under analysen

To inkonsistenser i krav-kilden som spec-doc-en ikke flagget:

1. **`vise_tilganger.feature` motstrider seg selv.** Scenarioet `Tilgjengelige miljøer i filter` sier "alle miljøer applikasjonen kan tilordnes tilganger i" (potential scope, ny semantikk). Scenarioet `Filtrere tilgangsliste på miljø` sier "Og filtervalget er begrenset til miljøer applikasjonen har tilganger i" (gammel "loaded-result"-semantikk). Samme mønster for organisasjoner (`Tilgjengelige organisasjoner i filter` vs. `Filtrere tilgangsliste på organisasjon` — linje 28-29 vs. 38-41 i feature-fila).
2. **`iterasjon_2_og_3_oversikt.md`** sin innebygde gherkin for BRU-APP-API-001 viser en *tynnere* versjon enn frittstående `listevisning_og_sok.feature` — kolonne `Antall tilganger` mangler, scenario-malen for sorteringsretning mangler, status-filter og miljø-filter-scenariene mangler. Spec-doc-en sier den innebygde gherkin-en er "oppdatert tilsvarende", men de er ikke identiske. Antagelig er den frittstående feature-fila autoritativ og oversikten er en summary, men dette bør bekreftes.

## Technical Constraints

### Fra `CLAUDE.md` og `AGENTS.md`

- **Codegen-kjeden er real-time** (`npm run watch:codegen`). Schema-endringer i `src/mocks/schema/applikasjoner.graphql` regenererer `src/__generated__/graphql.ts` umiddelbart. Klient-fragment-endringer må derfor være atomisk med schema-endringene — ellers slår TypeScript-build feil.
- **Sikt Design System** — ingen nye dependencies introduseres her. Alle filtre bygger på `@sikt/sds-filter-list` og `@sikt/sds-input`.
- **Norsk domenespråk, engelsk kode.** Alle UI-strenger via `next-intl` mot `src/messages/nb/`. Ingen hardkodede norske strenger i komponentene.
- **A11y-tester er obligatorisk** (`*.a11y.test.tsx`) for hver feature/komponent. De finnes allerede for filtrene som endres; må oppdateres når props/data-driven option-sets endres.
- **Feature flag `'tilgangsstyring-applikasjoner'`** styrer både `/tilgangsstyring/applikasjoner` og `/tilgangsstyring/applikasjoner/[applikasjonId]` (sjekkes i `src/app/tilgangsstyring/applikasjoner/page.tsx` og `[applikasjonId]/page.tsx`). Flagget er på i dev/review/test og av i prod — endringen kjøres trygt bak flagget mens producer-teamet jobber med ekte backend.

### Fra fs-admin-mønstrene (skill-output)

- **Anti-pattern: Klient-side derivering av filter-option-sett**. DetailPageLayout-pattern §1 forbyr at sub-list-filtre henter option-sett fra `useMemo`-deduplisering av allerede-lastede rader. Det er nettopp denne formen Tilganger-fanen bruker i dag — det er en kjent svakhet, ikke et bevisst valg, og krav-endringen er en god anledning til å rydde det.
- **Filter-state må fortsatt være URL-synket på listevisningen** (via `useDataListState`) — option-set-endringen flytter ikke state-modellen, kun data-kilden for option-listen.
- **Tilganger-fanens state forblir bevisst ikke URL-synket** (Context-only via `useApplikasjonTilgangerState`, dokumentert i file-comment) — option-set-endringen påvirker ikke denne avgjørelsen.

## Dependencies

### Internal

- **`src/__generated__/graphql.ts`** — regenereres ved schema-endring; alle typer som referer til `Ansvarlig`, `AnsvarligType`, `AnsvarligIkkeIApplikasjonsOrganisasjon`, `AnsvarligPaakrevdVedOpprettelse`, `kanAdministrereAnsvarlig` og felt-shaped tilstedeværelse på `OpprettApplikasjonInputV2`/`SettApplikasjonAnsvarligInput`/`FjernApplikasjonAnsvarligInput` blir fjernet.
- **`src/common/lib/auth/globalUserContext.tsx`** — `useMineLaresteder()` er allerede konsumert av `ApplikasjonerOrganisasjonFilter`. Verifiser semantikken (se Open Questions).
- **`useDataListState` / `useDataListQuery`** — uendret. Filter-shape kan trenge nye felt hvis serverside-filtrering på `miljoApplikasjonenKanTilordnesTilgangerI` ol. introduseres, men URL-state-kontrakten endres ikke.
- **i18n nøkler** — ~25 ansvarlig-strenger i `src/common/messages/nb/support.json` må fjernes; én tekst i `applikasjonerDescription` justeres. Skilleren `/externalize-i18n` brukes ikke her — vi *fjerner* strenger, vi legger ikke til.

### External

- **`@sikt/sds-filter-list`, `@sikt/sds-input`, `@sikt/sds-button`, `@sikt/sds-core`** — alle fortsatt brukt; ingen versjons-bumps som følge av denne endringen.
- **`next-intl`** — uendret.
- **`Apollo Client 4`** — uendret. Fragment-data-masking-kontrakten holder.

### Cross-agent

Det finnes ett tydelig kandidat for cross-agent hand-off, og det bør **bli behandlet i `bat-plan`-steget, ikke fra denne analysen**:

- **Backend / producer-team (agent-ID ukjent for denne agenten i dag — antagelig `backend` eller `producer` i `$COORD_REPO/agents/`).** Trengs for:
  - Fjerne `ansvarlig`-feltet, `kanAdministrereAnsvarlig`, `Ansvarlig`-union, `AnsvarligType`-enum og tilhørende error-typer fra produksjons-skjemaet.
  - Slette mutations `settApplikasjonAnsvarlig` + `fjernApplikasjonAnsvarlig`, query `ansvarligKandidater`, og inputs `SettApplikasjonAnsvarligInput` + `FjernApplikasjonAnsvarligInput`.
  - Bestemme strategien for `OpprettApplikasjonInputV2.ansvarligId` (alt (a)/(b)/(c) under F3 — producer-side avgjørelse).
  - Eksponere de nye potential-scope-feltene/-queriene for Tilganger-fanen (`Applikasjon.potensielleMiljoer` + `Applikasjon.potensielleTildelendeOrganisasjoner`, eller tilsvarende sub-queries). Konkret shape avgjøres av producer-teamet i `bat-graphql-dev`-seksjonen av planen.
  - Bekrefte semantikken av "organisasjoner brukeren har rettighet til" mot eksisterende `megVedLarested`-query — er disse to mengdene like, eller trengs et nytt felt?

Hand-off-issue blir mer presis hvis vi venter til `bat-plan` legger plan + GraphQL-skisser på bordet — det er hele poenget med å holde dette som *kandidat-dependency* her og ikke filing-target.

## Requirements Impact

Spec-doc-en grupperer endringene i to spor (`11ce66c` ansvarlig-fjerning, `40f04cb` filter-scope). Mapping mot konkrete krav:

### Krav adressert (eksisterende kode dekker den nye versjonen direkte eller med små justeringer)

- **`BRU-APP-API-001` / Synlighet via administrasjons-rettigheter (K11, K12).** Visibility-flagg som `personaHasTilgangerInOrgA` + organisasjonen brukeren administrerer er allerede modellert i fiksturen og resolve-handlers. Eneste justering er at "Synlighet via ansvarlig-relasjon"-regelen fjernes — det er en netto-reduksjon.
- **`BRU-APP-API-002` / Se detaljer.** Scenarioet `Se ansvarlig` er fjernet; alle andre detaljside-scenarier består uendret. `ApplikasjonInformation`-fragmentet får et fragment-felt mindre.

### Krav i risiko (krever koordinert kode-/schema-endring)

- **`BRU-APP-API-001` / "Tilgjengelige miljøer i filter"** — krav scope endres fra hardkodet enum til persona-scope-mengde. Krever ny datakilde fra producer (eller en eksisterende kombinasjon av rettighets-baserte query-er klienten kan komponere).
- **`BRU-APP-API-001` / "Tilgjengelige organisasjoner i filter"** — semantikk-bekreftelse av `useMineLaresteder` mot "alle organisasjoner brukeren har rettighet til". Lav risiko hvis disse stemmer; ellers kreves nytt felt.
- **`BRU-APP-API-003` / "Tilgjengelige miljøer/organisasjoner i filter"** (Tilganger-fanen) — størst delta. Krever to nye serverside-eksponeringer (eller fragment-utvidelser) som klient-koden i dag ikke har tilgjengelig.
- **`BRU-APP-API-009` / "Opprette applikasjon"** — V2-input må endres (producer-avgjørelse).

### Manglende krav oppdaget under analyse

- **Ingen helt nye krav-mangler avdekt.** Inkonsistensene under F7 (vise_tilganger.feature internal contradiction, oversikt vs. standalone) er krav-eier-side, ikke kode-side, og hører hjemme i Open Questions for krav-eier å rydde, ikke som nye krav.

## Krav-input referanse

- **Spec-dokument:** [`spec-changes-2026-06-01-11ce66c..40f04cb.md`](spec-changes-2026-06-01-11ce66c..40f04cb.md)
- **Krav-input-manifest:** [`krav-input/changes/2026-06-01-11ce66c..40f04cb/manifest.md`](krav-input/changes/2026-06-01-11ce66c..40f04cb/manifest.md)

## Open Questions

- [x] **Q1 — Mutation-strategi for ansvarligId-fjerning.** Hvilken av (a)/(b)/(c) under F3 går vi for?
  - **Opprinnelige alternativer** (beholdt for kontekst): (a) reverse til V1, (b) gjør `ansvarligId` valgfri på V2, (c) introduser V3.
  - **Analysens opprinnelige anbefaling:** alternativ (b).
  - **Avgjørelse (2026-06-01):** alternativ (d) — **kollapse V1/V2/V3-progressionen helt**. Det finnes ikke ekte backend-konsumenter å bevare backwards-compat for, så schema-en eksponerer bare *én* operation `opprettApplikasjon` uten `ansvarligId`. Både V1-mutation (deprecated) og V2-mutation (`OpprettApplikasjonV2`) + `OpprettApplikasjonInputV2` + `AnsvarligPaakrevdVedOpprettelse`-error-typen fjernes fra mock-skjemaet og klient-koden refererer en enkelt, ren `OPPRETT_APPLIKASJON` (eller tilsvarende) som inputtar `navn`, `identitetsleverandor`, `eksternId`, `organisasjonsId`.
  - **Rasjonale:** Versjonerings-suffikser (`V2`, `V3`) er meningsfulle bare når konsumenter på ekte produksjon må holdes kjørende på gammel shape mens nye lander. I dette repoet er hele backend mock-et — det er ingen ekstern konsument. Å holde en V1/V2-distinksjon i mock-skjemaet bare for å speile et hypotetisk produksjons-utviklingsmønster legger til kompleksitet uten gevinst.
- [x] **Q2 — Semantikk-match `useMineLaresteder` vs. "organisasjoner brukeren har rettighet til".**
  - **Opprinnelig formulering:** Er `megVedLarested` per-organisasjon en strict-equivalent til "har applikasjonsadministrator-rolle for organisasjonen", eller er det en bredere affiliasjons-set?
  - **Avgjørelse (2026-06-01):** `megVedLarested` har **ikke noe med denne oppgaven å gjøre**. Lærested-affiliasjon er en annen entitet enn applikasjonsadministrator-rettighet per organisasjon — disse mengdene overlapper kanskje, men er ikke definert til å være like, og den nåværende implementasjonen i `ApplikasjonerOrganisasjonFilter.tsx:42` (som bruker `useMineLaresteder()`) er derfor **feil kilde** for det nye kravet.
  - **Implikasjon for planning:** Org-filteret på applikasjonsoversikten må re-sources fra en data-shape som representerer "organisasjoner brukeren har applikasjonsadministrator-rolle for" — typisk et nytt felt på Meg-query-en (f.eks. `megSomApplikasjonsadministrator { organisasjoner { id, navn } }`) eller en dedikert query. Konkret shape avgjøres i `bat-graphql-dev` på planning-steget, ikke her.
  - **Oppdatering til F4 (Listevisning organisasjons-filter):** Det opprinnelige avsnittet ovenfor sa "Bruker allerede `useMineLaresteder()`. Semantisk match-en med kravet ... avhenger av om `megVedLarested` betyr ..." — denne premissen er feil. Korrigert lesning: nåværende implementasjon er **ikke i nærheten av krav-en**, og må byttes ut helt. Risiko-graden flyttes derfor fra "lav (verifiser semantikk)" til "medium (krever ny data-kilde)".
- [x] **Q3 — Producer-design for Tilganger-fanens potential-scope-felter.** Skal `potensielleMiljoer` + `potensielleTildelendeOrganisasjoner` ligge direkte på `Applikasjon`-typen som arrays, eller skal de være paginerte sub-queries?
  - **Opprinnelige alternativer** (beholdt for kontekst): direkte-felt vs. paginerte sub-queries.
  - **Avgjørelse (2026-06-01):** **Deferred til `bat-plan` / `bat-graphql-dev`-seksjonen av planen.** Shape-en avgjøres sammen med backend-agenten på producer-siden når GraphQL-skissen utformes. Denne analysen flagger behovet og setter rammen (direkte-felt er sannsynligvis tilstrekkelig — sett-ene forventes små); selve API-shape-en er en cross-agent-avgjørelse.
- [x] **Q4 — Krav-eier-inkonsistens i `vise_tilganger.feature`.**
  - **Opprinnelig formulering:** Scenarioene `Tilgjengelige miljøer i filter` (potential scope) og `Filtrere tilgangsliste på miljø` (gammel "begrenset til miljøer applikasjonen har tilganger i") motstrider hverandre. Hvilken er autoritativ?
  - **Avgjørelse (2026-06-02, assumed-authoritative reading):** Den **nyere "potential scope"-formuleringen er autoritativ** (linje 21 i `vise_tilganger.feature` og analog linje for organisasjon). Implementasjonen bygges mot denne. De gamle "begrenset til"-linjene i `Filtrere tilgangsliste på miljø` (linje 29) og `Filtrere tilgangsliste på organisasjon` (linje 41) er restprodukter fra forrige krav-iterasjon og bør oppdateres av krav-eier for konsistens — flagges som follow-up til krav-eier, men *blokkerer ikke* planen eller implementasjonen.
  - **Hvis krav-eier korrigerer i motsatt retning** (dvs. "begrenset til"-versjonen er autoritativ), faller hele filter-scope-spor #2 i delta-en bort — planen må re-vurderes. Lav sannsynlighet siden hele commit `40f04cb` er eksplisitt om å flytte til potential scope.
- [x] **Q5 — Krav-eier-inkonsistens i `iterasjon_2_og_3_oversikt.md`.**
  - **Opprinnelig formulering:** Den innebygde gherkin-en for BRU-APP-API-001 mangler `Antall tilganger`-kolonne, scenario-malen for sorteringsretning, status-filter-scenariene, og miljø-filter-scenariene som finnes i den frittstående `listevisning_og_sok.feature`. Skal oversikten oppdateres til paritet, eller er den bevisst en summary?
  - **Avgjørelse (2026-06-02, assumed-authoritative reading):** Den **frittstående `.feature`-fila er autoritativ**. `iterasjon_2_og_3_oversikt.md` er en aggregert oversikt for å se hele Iter 2+3 på ett sted; over tid har den drevet ut av synk med de frittstående filene. Implementasjonen bygges mot de frittstående feature-filene. Oversikts-fila bør re-genereres / oppdateres av krav-eier på neste pass — flagges som follow-up til krav-eier, men *blokkerer ikke* planen eller implementasjonen.
- [x] **Q6 — Mock-fjernings-rekkefølge.**
  - **Opprinnelige alternativer:** (a) én MR per krav-akse (ansvarlig-fjerning vs. filter-scope), (b) én single atomic MR, (c) split mocks-først-så-klient.
  - **Analysens opprinnelige anbefaling:** (a) — én MR per krav-akse.
  - **Avgjørelse (2026-06-02):** **(b) — én single atomic MR.** Hele delta-en (ansvarlig-fjerning + filter-scope + mock-skjema + klient-fragmenter + i18n) går inn som én sammenhengende endring. Reviewer-en ser hele konsekvensen samlet, og codegen-en er konsistent gjennom hele.
  - **Rasjonale (user-supplied):** Selv om aksene er ortogonale konseptuelt, er delta-en avgrenset nok (én feature-mappe + ett mock-schema-fil + én i18n-fil) til at split-en gir mer overhead enn den sparer. Bevarer "én krav-delta → én MR"-koblingen som er lett å spore tilbake.
