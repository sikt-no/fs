# Plan: Applikasjon-tilgangsstyring — Iter 3 oppdateringer

> **Følger fra:** [`analysis-applikasjon-tilgangsstyring-iter3.md`](analysis-applikasjon-tilgangsstyring-iter3.md) — delta-analyse av de 7 commitene på `fruitbat`-branchen.
>
> **Scope:** Endringene i de 7 commitene (commits `e04d704`, `a7efc9f`, `ccaf83a`, `7ceb640`, `59eba3d`, `cee226d`, `4f2e9a4`) — listevisning, detaljer, vise/tildele/fjerne tilganger, oppretting, redigering. **Endringslogg (BRU-APP-API-016) er IKKE i scope** — det er Iterasjon 4 og fortsatt `@draft`.
>
> **Strategi:** Mock-API først, ekte schema parallelt. Frontend kan progressere uavhengig av backend; ekte schema-endringer fileres som hand-off-issues etter at planen er publisert.
>
> **Forutsetning:** Iter 2 er levert på branch `poc-skills-execute-result` (22 tasks fullført). Denne plan-en bygger oppå den.

## Proposed Solution

### Architecture Approach

Planen er en **kombinasjon av strukturelle refactors og additive utvidelser** på den eksisterende Iter 2-implementasjonen:

1. **Structurelle endringer** (krever rework av eksisterende kode):
   - Info-fanen på detaljsiden flytter fra "knapp pr. felt → dialog" til **inline rediger-modus** med én samlet rediger-toggle (BRU-APP-API-006, BRU-APP-API-002).
   - `FjernTilgangerDialog` endres fra "hak av rader → bekreft" til **samlet modal med (org, miljø, tilganger)-valg inni** (BRU-APP-API-008).
   - `TildelTilgangerDialog` får kaskaderende **organisasjon → miljø → tilgangskode**-state (BRU-APP-API-007).
   - **`Fjern ansvarlig`-flyten fjernes** (knapp, dialog, mutation-bruk) — ansvarlig er nå obligatorisk (BRU-APP-API-005).

2. **Additive utvidelser** (utvidelser uten å bryte eksisterende kode):
   - `ApplikasjonerFilter` får miljø-filter.
   - `ApplikasjonerResultRow` får "Antall tilganger"-kolonne.
   - `ApplikasjonInformation` får idP, organisasjon og status som synlige felter i info-fanen (i tillegg til at de finnes i topbar-en).
   - `OpprettApplikasjonDialog` får navn og ansvarlig som obligatoriske felter.
   - `ApplikasjonTilgangerFilter` får organisasjon-filter, fritekst-tilgangskode-filter, og "Vis arvede"-toggle.
   - `ApplikasjonTilgangerResultRow` får beskrivelse, organisasjon, og "Arvet"-badge med opphav-tooltip.

3. **Tverrgående mekanikk** (ny mønster i fs-admin):
   - **Discardable-changes-guard** ved navigering/tab-bytte under rediger-modus (BRU-APP-API-006 Regel: "Ulagrede endringer forkastes ved navigering"). Komponent-lokalt mønster basert på Next.js `useEffect` + `beforeunload` + `usePathname`-watch.

Implementasjonen følger Iter 2's mønster: **mock-handlers i `src/mocks/handlers/applikasjoner/` oppgraderes først** med nye felter og typer, frontend bygger mot mock, og ekte schema-endringer (se `## GraphQL-endringer`) fileres som hand-off-issues til backend.

### Key Technical Decisions

1. **Inline rediger-modus med toggle, ikke separate dialoger**
   - **Hvorfor:** Krav BRU-APP-API-006 + skissen (`applikasjon-detaljevisning-aktiv-tab-detaljer-rediger-modus.png`) viser én "Rediger detaljer"-knapp som gjør alle redigerbare felter (navn, beskrivelse, ansvarlig) om til inputs samtidig. Dialog-mønsteret pr. felt fra Iter 2 skalerer ikke pent når antallet redigerbare felter øker.
   - **Alternativ vurdert:** Beholde dialog-mønsteret og legge til en `RedigerNavnDialog`. Forkastet: bryter krav-en eksplisitt + dårlig UX når bruker vil endre flere felter samtidig.

2. **Mock-API først, ekte schema parallelt**
   - **Hvorfor:** Brukerens valg. Iter 2 brukte samme strategi; mock-handlers eksisterer allerede og kan utvides. Frontend kan ha alle Tasks klare og PR-merget før backend leverer.
   - **Alternativ vurdert:** Vente på backend. Forkastet pga. kalender-avhengighet.

3. **Navn-feltet er bruker-overstyrt visningsnavn**
   - **Hvorfor:** Brukerens valg. `rediger_detaljer.feature` er den autoritative tolkningen — navn settes initialt fra idP-en, men kan overstyres.
   - **Alternativ vurdert:** Anta navn er låst etter oppretting. Forkastet — bryter rediger_detaljer-kravet.
   - **Konsekvens:** Schema må utvides med `redigerApplikasjonNavn`-mutation og `kanRedigereNavn`-felt. Backend-bekreftelse av unikhets-håndheving er åpent spørsmål (se Open Question #1).

4. **Arv-modellen mock-først, schema-form til avklaring**
   - **Hvorfor:** Krav-en introduserer "arvet tilgang" som nytt vokabular. Den foreslåtte `ApplikasjonTilgangArv { opphavsTilgang, begrunnelse }`-formen er fs-admin-konsumentens beste gjetning. Mock-API kan bruke den foreslåtte formen for å låse opp UI-arbeid; ekte schema kan avvike og kreve schema-mapping-task senere.
   - **Alternativ vurdert:** Vente på backend-form. Forkastet — blokkerer UI-arbeid i 2–4 uker.

5. **`@V2`-mutation for `opprettApplikasjon`, `extend`-additive for resten**
   - **Hvorfor:** `opprettApplikasjon` får obligatoriske felter — bakover-inkompatibel endring som krever `V2`-runde. Andre endringer er filter-utvidelser, nye felter, ny mutation — alle bakover-kompatible via `extend`.
   - **Alternativ vurdert:** In-place-endring av `OpprettApplikasjonInput`. Forkastet — bryter eventuelle skript/CLI-konsumenter.

6. **Discardable-changes som komponent-lokalt mønster, ikke generisk router-guard**
   - **Hvorfor:** Krav-en gjelder kun rediger-detaljer-fanen. Et generisk router-blocker-mønster (à la React Router `<Prompt>`) finnes ikke som førsteklasses støtte i Next.js App Router. Komponent-lokal `unmount`-cleanup + `beforeunload`-listener dekker scenariene "Forlate siden" og "Bytte fane" i krav-en.
   - **Alternativ vurdert:** Generisk `useUnsavedChangesGuard`-hook. Kan introduseres senere når et annet rediger-flyt får samme behov — foreløpig ett kall-sted, ikke verdt abstraksjonen.

7. **Behold `tilgangskoder: [String!]`-filter, legg til `tilgangskodeContains` parallelt**
   - **Hvorfor:** Backward-kompatibilitet. UI-en vil bruke `tilgangskodeContains` (fritekst) etter Iter 3, men ingen grunn til å bryte eksakt-match-konsumenter umiddelbart.
   - **Alternativ vurdert:** Erstatt direkte. Forkastet — bryter konsumenter, krever `V2`-runde.

### File Changes Overview

**Endrede filer:**

- `src/domains/support/features/Applikasjoner/components/ApplikasjonerResultRow.tsx` — utvid fragment med `antallTilganger`, legg til kolonne.
- `src/domains/support/features/Applikasjoner/components/ApplikasjonerFilter.tsx` — legg til miljø-filter.
- `src/domains/support/features/Applikasjoner/hooks/useGetApplikasjonerState.tsx` — utvid filter-state med `miljoer`.
- `src/domains/support/features/Applikasjon/components/ApplikasjonInformation.tsx` — bygg om til inline rediger-modus, fjern dialog-knapper, legg til idP/org/status-visning, fjern `FjernAnsvarlig`-knapp + dialog-mount, utvid fragment med `kanRedigereNavn`.
- `src/domains/support/features/Applikasjon/components/ApplikasjonTopBar.tsx` — utvid fragment med `antallTilganger`, vis i topbar.
- `src/domains/support/features/Applikasjon/components/ApplikasjonTilgangerResultRow.tsx` — utvid fragment med `erArvet`, `arvetFra`, `organisasjon`, `tilgangsbeskrivelse`; render arv-badge.
- `src/domains/support/features/Applikasjon/components/ApplikasjonTilgangerFilter.tsx` — utvid med organisasjon-filter, fritekst-tilgangskode, "Vis arvede"-toggle.
- `src/domains/support/features/Applikasjon/hooks/useApplikasjonTilgangerState.tsx` — utvid filter-state.
- `src/domains/support/features/Applikasjon/components/ApplikasjonTilgangerOrderBy.tsx` — fjern `Miljø` fra sort-valg.
- `src/domains/support/features/Applikasjon/components/TildelTilgangerDialog/TildelTilgangerDialog.tsx` — restrukturer til kaskade (org → miljø → kode), re-utløs `tildelbareApplikasjonTilganger`-query ved (org, miljø)-endring, fjern "gråtonet"-implementasjon. Støtt tildeling til deaktivert applikasjon.
- `src/domains/support/features/Applikasjon/components/FjernTilgangerDialog/FjernTilgangerDialog.tsx` — restrukturer til samlet modal hvor bruker velger (org, miljø, tilganger) inni modalen. Fjern bulk-selection fra raden. Filtrer ut arvede tilganger. Støtt fjerning fra deaktivert applikasjon.
- `src/domains/support/features/Applikasjon/components/FjernTilgangerDialog/FjernValgteTilgangerButton.tsx` — antagelig erstattes av enkel "Åpne modal"-knapp; selection-state fjernes.
- `src/domains/support/features/Applikasjoner/components/OpprettApplikasjonDialog/OpprettApplikasjonDialog.tsx` — utvid input med navn og ansvarlig (obligatoriske), bytt til `OpprettApplikasjonV2`-mutation.
- `src/mocks/handlers/applikasjoner/queries.ts` + `mutations.ts` — utvid handlers med nye felter, mutations, filter-felter.
- `src/mocks/fixtures/applikasjoner/applikasjoner.ts` + `tilganger.ts` — legg til arv-relasjoner, `antallTilganger`, `kanRedigereNavn` i fixture-data.
- `src/common/messages/nb/support.json` — nye strenger for rediger-modus, arv-badge, navn-validering, obligatoriske felter, modal-headinger, "Vis arvede"-toggle.

**Nye filer:**

- `src/domains/support/features/Applikasjon/components/RedigerDetaljer/RedigerDetaljerForm.tsx` (+ `.a11y.test.tsx`) — inline rediger-form med navn, beskrivelse, ansvarlig.
- `src/domains/support/features/Applikasjon/components/RedigerDetaljer/mutation.ts` — `REDIGER_APPLIKASJON_NAVN` + (gjenbruk eksisterende `redigerApplikasjonBeskrivelse`).
- `src/domains/support/features/Applikasjon/components/RedigerDetaljer/useUnsavedChangesGuard.tsx` (+ test) — komponent-lokal hook for å nullstille ved navigering/tab-bytte.
- `src/domains/support/features/Applikasjoner/components/filter/ApplikasjonerMiljoFilter.tsx` (+ `.a11y.test.tsx`).
- `src/domains/support/features/Applikasjon/components/tilganger/ApplikasjonTilgangerOrganisasjonFilter.tsx` (+ test).
- `src/domains/support/features/Applikasjon/components/tilganger/ApplikasjonTilgangerArvToggle.tsx` (+ test).
- `src/domains/support/features/Applikasjon/components/ApplikasjonTilgangerArvBadge.tsx` (+ test) — gjenbrukbar "Arvet"-badge med tooltip/popover.

**Slettede filer:**

- `src/domains/support/features/Applikasjon/components/RedigerBeskrivelseDialog/` — hele mappa (komponent + test + mutation), erstattes av inline rediger-modus.
- `src/domains/support/features/Applikasjon/components/SettAnsvarligDialog/FjernAnsvarligConfirmDialog.tsx` (+ test).
- `src/domains/support/features/Applikasjon/components/SettAnsvarligDialog/fjernApplikasjonAnsvarligMutation.ts`.

(`SettAnsvarligDialog.tsx` selv beholdes — settes inn som inline-modus i rediger-formen via en søke-popover.)

## GraphQL-endringer

> **Premiss:** konservativ — minst mulig schema-endring som dekker Iter 3-kravene; gjenbruker eksisterende `Applikasjon`-/`ApplikasjonTilgang`-typer og utvider med diskrete felt/input.
> **Domeneterm:** `Applikasjon` (besluttet 2026-05-13; tidligere `Maskinbruker` i POC-en).
> **Følger fra:** [`analysis-applikasjon-tilgangsstyring-iter3.md`](analysis-applikasjon-tilgangsstyring-iter3.md) — gap-listen i Key Findings (1–10) og Dependencies → Cross-agent.
> **Mock-API først:** Plan-en bygger mot mock-handlers; ekte schema-endringer fileres som hand-off-issue til backend-agenten (`sikt-no/fs`). Frontend-koden kan kompileres mot oppdatert mock-schema før produsent-siden er levert.

### Sammendrag

- 0 nye queries (eksisterende `applikasjoner`, `applikasjon`, `tildelbareApplikasjonTilganger` er allerede formet riktig; frontend må bruke dem rett).
- 1 ny mutation (`redigerApplikasjonNavn`).
- 1 endret mutation (`opprettApplikasjonV2`).
- 1 deprecated mutation (`fjernApplikasjonAnsvarlig`).
- 2 utvidede input-typer (`ApplikasjonerFilterInput`, `ApplikasjonTilgangerFilterInput`).
- 4 nye/utvidede typer/felter (`Applikasjon.antallTilganger`, `Applikasjon.kanRedigereNavn`, `ApplikasjonTilgang.arvetFra` med nytt `ApplikasjonTilgangArv`-objekt, `ApplikasjonTilgang.erArvet`).
- 4 nye error-medlemmer (`NavnAlleredeIBruk`, `AnsvarligPaakrevdVedOpprettelse`, `ArvetTilgangKanIkkeFjernes`, +unik error-form ved arv).
- 5 åpne spørsmål (se nederst).

**Allerede dekket av eksisterende schema (ingen endring nødvendig):**

- `tildelbareApplikasjonTilganger(applikasjonsId: ID!, miljo: Miljo!, organisasjonsId: ID!): [TildelbarApplikasjonTilgang!]!` — parameter-formen krav-en ber om (org → miljø → kode-kaskade) er **allerede på plass** ved `schema.graphql:37558`. Frontend må re-utløse queryen ved hver endring i (orgId, miljo) og oppdage skopet — det er en client-side bekymring, ikke en schema-bekymring.
- `ApplikasjonTilgang.organisasjon` (`schema.graphql:1458`) — beskrivelsen + organisasjon pr. rad krav-en ber om er allerede tilgjengelig.
- `Applikasjon.miljoer: [Miljo!]!` (`schema.graphql:1430`) — listevisningens miljø-chips er allerede dekket.

### Operasjoner

#### Op #1: `ApplikasjonerFilterInput.miljoer` — miljø-filter på applikasjonslisten

**Dekker krav:** BRU-APP-API-001 (commit `ccaf83a`: *"legg til krav for filtrering på miljø i applikasjonslisten"*).
**Implementeres av:** Task #1, #2

##### Lag A — Schema-tillegg

```graphql
extend input ApplikasjonerFilterInput {
  """
  Filter på miljø: returner kun applikasjoner som er aktive i ett av de oppgitte miljøene.
  Et tomt eller utelatt felt slår av filteret.
  """
  miljoer: [Miljo!]
}
```

##### Lag B — fs-admin call-site

```ts
// src/domains/support/features/Applikasjoner/hooks/useGetApplikasjoner.tsx
const { data } = useQuery(GET_APPLIKASJONER, {
  variables: {
    filter: {
      navnContains: state.filter.navnContains || null,
      organisasjonsIder: state.filter.organisasjonsIder.length ? state.filter.organisasjonsIder : null,
      status: state.filter.status.length ? state.filter.status : null,
      miljoer: state.filter.miljoer?.length ? state.filter.miljoer : null,  // ← ny
    },
  },
})
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-APP-API-001 (commit `ccaf83a`).
- **Form:** Reuser `Miljo`-enum; nullable `[Miljo!]` følger samme mønster som `organisasjonsIder` og `status`.
- **Colocation-status:** Følger colocation — `ApplikasjonerResultRowFields` har allerede `miljoer`.
- **Konvensjoner sitert:** Backward-compatible `extend input` per `fs-sikt-no-producer-schema-design §Endringer i API bør ikke ødelegge for klienter`. Nullable filter per `fs-sikt-no-producer-best-practice §Nullability`. Felt-navn per `fs-sikt-no-producer-naming`.
- **Alternativer vurdert:** Egen `applikasjonerIMiljo`-query — forkastet: bryter filter-konvensjonen.

---

#### Op #2: `Applikasjon.antallTilganger` — listefelt for antall tilganger

**Dekker krav:** BRU-APP-API-001 (commit `59eba3d`) + BRU-APP-API-002 (topbar-skisse).
**Implementeres av:** Task #3, #11

##### Lag A — Schema-tillegg

```graphql
extend type Applikasjon {
  """
  Antall tilganger applikasjonen har tildelt totalt, på tvers av alle miljøer og organisasjoner.
  Aggregat-felt for listevisning og topbar. Identisk med `tilganger.totalCount` uten filter,
  men eksponert som direkte felt for å unngå at listevisningen må hente hele tilgangsliste-relasjonen.
  """
  antallTilganger: Int!
}
```

##### Lag B — fs-admin call-site

```ts
// src/domains/support/features/Applikasjoner/components/ApplikasjonerResultRow.tsx
export const APPLIKASJONER_RESULT_ROW_FRAGMENT = gql(/* GraphQL */ `
  fragment ApplikasjonerResultRowFields on Applikasjon {
    id
    navn
    beskrivelse
    miljoer
    status
    antallTilganger          # ← ny
    organisasjon { navn }
    ansvarlig { __typename ... on FeideBruker { visningsnavn } ... on FeideGruppe { visningsnavn } }
  }
`)
```

```ts
// src/domains/support/features/Applikasjon/components/ApplikasjonTopBar.tsx
export const APPLIKASJON_TOP_BAR_FRAGMENT = gql(/* GraphQL */ `
  fragment ApplikasjonTopBarFields on Applikasjon {
    navn
    status
    identitetsleverandor
    antallTilganger          # ← ny
    organisasjon { navn }
  }
`)
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-APP-API-001 + BRU-APP-API-002.
- **Form:** Direktefelt (`Int!`) i stedet for `tilganger.totalCount`-aggregering — listen rendrer 50 rader og må ikke utløse `tilganger`-resolvere pr. rad.
- **Colocation-status:** Følger colocation — feltet legges i fragmentene som leser det.
- **Konvensjoner sitert:** Norsk substantiv per `fs-sikt-no-producer-naming §Bruk norsk for domenebegreper`. Backward-compatible per `fs-sikt-no-producer-schema-design §Endringer i API bør ikke ødelegge for klienter`.
- **Alternativer vurdert:** `tilganger(first: 0).totalCount` med tom selection — forkastet: over-fetching og pagination-resolver pr. rad.
- **Tverrgående:** Cache-invalideres via mutation-payload (`applikasjon { id, antallTilganger }`) på `tildelApplikasjonTilganger`/`fjernApplikasjonTilganger`.

---

#### Op #3: `redigerApplikasjonNavn` — mutation for navn-redigering

**Dekker krav:** BRU-APP-API-006 (commit `7ceb640` + `a7efc9f`).
**Implementeres av:** Task #8, #9

##### Lag A — Schema-tillegg

```graphql
extend type Applikasjon {
  """
  Om innlogget bruker kan redigere applikasjonens visningsnavn.
  Følger samme rettighetsmodell som `kanRedigereBeskrivelse`.
  For Feide-/Maskinporten-applikasjoner setter idP-oppslaget et initielt visningsnavn ved
  opprettelse, men brukere med rettighet kan overstyre det i fs-admin.
  """
  kanRedigereNavn: Boolean!
}

extend type Mutation {
  """
  Redigerer det bruker-overstyrte visningsnavnet på en applikasjon. Navnet må være
  globalt unikt på tvers av alle organisasjoner.
  """
  redigerApplikasjonNavn(input: RedigerApplikasjonNavnInput!): RedigerApplikasjonNavnPayload!
}

input RedigerApplikasjonNavnInput {
  applikasjonsId: ID!
  navn: String!
}

type RedigerApplikasjonNavnPayload {
  applikasjon: Applikasjon
  errors: [RedigerApplikasjonNavnErrors!]
}

union RedigerApplikasjonNavnErrors =
    IngenRettighetTilApplikasjon
  | NavnAlleredeIBruk
  | UgyldigInput

type NavnAlleredeIBruk implements Error {
  message: String!
  path: [String!]!
  konfliktMedApplikasjonId: ID
}
```

##### Lag B — fs-admin call-site

```ts
// src/domains/support/features/Applikasjon/components/ApplikasjonInformation.tsx
export const APPLIKASJON_INFORMATION_FRAGMENT = gql(/* GraphQL */ `
  fragment ApplikasjonInformationFields on Applikasjon {
    id
    navn
    beskrivelse
    # ... eksisterende felter ...
    kanRedigereBeskrivelse
    kanRedigereNavn          # ← ny
  }
`)
```

```ts
// src/domains/support/features/Applikasjon/components/RedigerDetaljer/mutation.ts
export const REDIGER_APPLIKASJON_NAVN = gql(/* GraphQL */ `
  mutation RedigerApplikasjonNavn($input: RedigerApplikasjonNavnInput!) {
    redigerApplikasjonNavn(input: $input) {
      applikasjon {
        id
        navn
        endretTidspunkt
        endretAv { id, navn }
      }
      errors {
        ... on Error { message, path }
        ... on NavnAlleredeIBruk { konfliktMedApplikasjonId }
      }
    }
  }
`)
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-APP-API-006.
- **Form:** Egen mutation parallelt med `redigerApplikasjonBeskrivelse` — separate rettighetsregler (`kanRedigereNavn` vs `kanRedigereBeskrivelse`), separate feilmoduser.
- **Colocation-status:** Følger colocation — `ApplikasjonInformationFields` utvides på komponenten som rendrer rediger-modus.
- **Konvensjoner sitert:** Mutation toppnivå per `fs-sikt-no-producer-best-practice §Bare felt på Mutation-typen kan utføre endringer`. Error-envelope med plural `Errors`-union og `Error`-interface (verifisert mønster i `schema.graphql`). Nullable `applikasjon` per `fs-sikt-no-producer-best-practice §Nullability`. Prefiks speiler `redigerApplikasjonBeskrivelse`.
- **Alternativer vurdert:** Utvid `RedigerApplikasjonBeskrivelseInput` til `RedigerApplikasjonDetaljerInput` — forkastet: bryter eksisterende mutation. Generisk patch-mutation — forkastet: bryter "én mutation, én intensjon".
- **Open question:** Se Åpne spørsmål #1 (navn-feltets natur).

---

#### Op #4: `ApplikasjonTilgangerFilterInput` utvidet med organisasjon + fritekst + arv

**Dekker krav:** BRU-APP-API-003 (commit `cee226d` + `4f2e9a4`).
**Implementeres av:** Task #12, #13

##### Lag A — Schema-tillegg

```graphql
extend input ApplikasjonTilgangerFilterInput {
  """
  Filter på organisasjon: returner kun tilganger knyttet til én av de oppgitte organisasjonene.
  Filtervalget begrenses i UI til organisasjoner applikasjonen faktisk har tilganger hos.
  """
  organisasjonsIder: [ID!]

  """
  Fritekstfilter på tilgangskode: returner kun tilganger der tilgangskoden inneholder
  den oppgitte teksten (case-insensitive, substring).
  """
  tilgangskodeContains: String

  """
  Bestemmer om arvede tilganger skal inkluderes i resultatet.
  Standard er `true` (arvede vises sammen med direkte tildelte).
  """
  inkluderArvede: Boolean

  # NB: eksisterende `tilgangskoder: [String!]` beholdes for bakoverkompatibilitet.
}
```

##### Lag B — fs-admin call-site

```ts
// src/domains/support/features/Applikasjon/hooks/useApplikasjonTilganger.tsx
const { data } = useQuery(GET_APPLIKASJON_TILGANGER, {
  variables: {
    applikasjonsId: id,
    filter: {
      miljoer: state.filter.miljoer?.length ? state.filter.miljoer : null,
      organisasjonsIder: state.filter.organisasjonsIder?.length ? state.filter.organisasjonsIder : null,
      tilgangskodeContains: state.filter.tilgangskodeContains || null,
      inkluderArvede: state.filter.skjulArvede ? false : null,
    },
    first: 50,
  },
})
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-APP-API-003.
- **Form:** `organisasjonsIder` speiler `ApplikasjonerFilterInput`. `tilgangskodeContains` følger `*Contains`-suffiks-mønster fra `navnContains` (27 forekomster av `Contains:` i `schema.graphql`).
- **Colocation-status:** Følger colocation — filter-felter brukes i `useApplikasjonTilganger`-hook-en.
- **Konvensjoner sitert:** `*Contains`-suffiks (implisitt mønster). Boolean med verb-prefiks per `fs-sikt-no-producer-naming §Boolean-felt navngis med verb`. Nullable per `fs-sikt-no-producer-best-practice §Nullability`. Backward-compatible per `fs-sikt-no-producer-schema-design`.
- **Alternativer vurdert:** Erstatt `tilgangskoder` direkte — forkastet: bryter bakoverkompatibilitet. `inkluderArvede` default `true` non-null — forkastet: nullable gir enklere URL-state.
- **Tverrgående:** `ApplikasjonTilgangerOrderByField.MILJO` beholdes i schema, men fjernes fra UI sort-valg.

---

#### Op #5: Arv-modell på `ApplikasjonTilgang`

**Dekker krav:** BRU-APP-API-003 (commit `4f2e9a4`) + BRU-APP-API-008 (Regel: arvede kan ikke fjernes).
**Implementeres av:** Task #14, #15, #18

##### Lag A — Schema-tillegg

```graphql
extend type ApplikasjonTilgang {
  """
  Liste over direkte-tildelte tilganger som har gitt opphav til denne arvede tilgangen.
  Tom liste betyr at tilgangen er direkte tildelt (ikke arvet).
  """
  arvetFra: [ApplikasjonTilgangArv!]!

  """
  Om denne tilgangen er arvet (avledet fra én eller flere direkte tilganger).
  """
  erArvet: Boolean!
}

"""
Et opphav (parent) til en arvet tilgang. Refererer til en annen tilgang på samme
applikasjon som er direkte tildelt og som gir denne tilgangen via en arv-regel.
"""
type ApplikasjonTilgangArv {
  opphavsTilgang: ApplikasjonTilgang!
  begrunnelse: String!
}

extend union FjernApplikasjonTilgangerErrors = ArvetTilgangKanIkkeFjernes

type ArvetTilgangKanIkkeFjernes implements Error {
  message: String!
  path: [String!]!
  applikasjonsTilgangId: ID!
}
```

##### Lag B — fs-admin call-site

```ts
// src/domains/support/features/Applikasjon/components/ApplikasjonTilgangerResultRow.tsx
export const APPLIKASJON_TILGANG_ROW_FRAGMENT = gql(/* GraphQL */ `
  fragment ApplikasjonTilgangRowFields on ApplikasjonTilgang {
    id
    tilgangskode
    tilgangsbeskrivelse
    miljo
    organisasjon { id, navn }
    erArvet                  # ← ny
    arvetFra {               # ← ny
      opphavsTilgang { id, tilgangskode }
      begrunnelse
    }
  }
`)
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-APP-API-003 + BRU-APP-API-008.
- **Form:** Self-referential many-to-one via egen `ApplikasjonTilgangArv`-type — gir plass til `begrunnelse`-feltet uten å forurense `ApplikasjonTilgang`.
- **Dedup:** Backend-ansvar — resolveren for `applikasjon.tilganger(filter)` skal dedup'e på (organisasjon, miljø, tilgangskode) før paginering.
- **Colocation-status:** Følger colocation — arv-feltene legges på rad-fragmentet.
- **Konvensjoner sitert:** Boolean `erArvet` med verb-prefiks per `fs-sikt-no-producer-naming`. Norsk type-navn per `fs-sikt-no-producer-naming §Bruk norsk for domenebegreper`. Non-null lister (tom er meningsfull) per `fs-sikt-no-producer-best-practice §Nullability`. Error-medlem speiler `TilgangAlleredeTildelt` på `schema.graphql:60069`.
- **Alternativer vurdert:** Flat `arvetFra: [ApplikasjonTilgang!]!` — forkastet: ingen plass til `begrunnelse`. Egen `ApplikasjonsArvRegel`-type — forkastet: krav-en er per-instans, ikke per-regel. Tag/string-felt — forkastet: mister referanse-integritet.
- **Open question:** Se Åpne spørsmål #2 (arv-modellens form) + #3 (dedup-ansvar).

---

#### Op #6: `opprettApplikasjonV2`-input utvidet med `navn` + `ansvarligId`

**Dekker krav:** BRU-APP-API-009 (commit `a7efc9f`).
**Implementeres av:** Task #19

##### Lag A — Schema-tillegg

```graphql
input OpprettApplikasjonInputV2 {
  eksternId: String!
  identitetsleverandor: IdentitetsleverandorType!
  organisasjonsId: ID!
  navn: String!
  ansvarligId: ID!
}

extend type Mutation {
  opprettApplikasjonV2(input: OpprettApplikasjonInputV2!): OpprettApplikasjonPayload!
  # opprettApplikasjon @deprecated(reason: "Bruk opprettApplikasjonV2. Fjernes etter 2026-09-01.")
}

extend union OpprettApplikasjonErrors =
    NavnAlleredeIBruk
  | AnsvarligPaakrevdVedOpprettelse

type AnsvarligPaakrevdVedOpprettelse implements Error {
  message: String!
  path: [String!]!
}
```

##### Lag B — fs-admin call-site

```ts
// src/domains/support/features/Applikasjoner/components/OpprettApplikasjonDialog/mutation.ts
export const OPPRETT_APPLIKASJON_V2 = gql(/* GraphQL */ `
  mutation OpprettApplikasjonV2($input: OpprettApplikasjonInputV2!) {
    opprettApplikasjonV2(input: $input) {
      applikasjon {
        id
        navn
        identitetsleverandor
        organisasjon { id, navn }
        status
      }
      errors {
        ... on Error { message, path }
        ... on NavnAlleredeIBruk { konfliktMedApplikasjonId }
      }
    }
  }
`)
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-APP-API-009.
- **Form:** `V2`-mutation parallelt med `@deprecated` på eksisterende `opprettApplikasjon` per `fs-sikt-no-producer-schema-design §Hvordan gjøre bakoverkompatible endringer`. Direkte tilføyelse av non-null felter ville være bakoverinkompatibelt.
- **Colocation-status:** Følger colocation — operasjonen lever i dialog-mappen.
- **Konvensjoner sitert:** `V2`-versjonering per `fs-sikt-no-producer-schema-design`. Error-medlemmer per domain-noun-condition-mønsteret. `ansvarligId: ID!` single per krav-en ("en ansvarlig").
- **Alternativer vurdert:** In-place strengere validering — forkastet: bryter konsumenter. Nullable + resolver-validering — forkastet: skjuler kontrakten i codegen-typen.

---

#### Op #7: Deprecation av `fjernApplikasjonAnsvarlig`

**Dekker krav:** BRU-APP-API-005 (commit `a7efc9f`).
**Implementeres av:** Task #7

##### Lag A — Schema-tillegg

```graphql
extend type Mutation {
  fjernApplikasjonAnsvarlig(input: FjernApplikasjonAnsvarligInput!): FjernApplikasjonAnsvarligPayload!
    @deprecated(reason: "Ansvarlig er obligatorisk i BRU-APP-API-005 (per 2026-05-27). Bruk settApplikasjonAnsvarlig for å endre ansvarlig. Mutation fjernes etter 2026-09-01.")
}
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-APP-API-005.
- **Form:** `@deprecated`-direktivet beholder mutationen tilgjengelig i deprecation-vinduet for eventuelle eksterne konsumenter, per `fs-sikt-no-producer-schema-design §Vær raus mot kollegaene dine`.
- **Colocation-status:** N/A — sletting av konsument-kode (egen Task).
- **Alternativer vurdert:** Slett umiddelbart — forkastet: bryter ev. ukjente konsumenter.

### Tverrgående schema-bekymringer

#### Permission-modell

Server-side `kan*`-felt på `Applikasjon` brukes konsekvent — `kanRedigereNavn` blir nytt felt parallelt med `kanRedigereBeskrivelse`. Mutations validerer på nytt resolver-side og returnerer `IngenRettighetTilApplikasjon` ved feil. Per `fs-sikt-no-producer-schema-design §Vi innfører gjerne egne felt og typer for semantisk nyttige data-uttrekk`.

#### Error-union-medlemmer

| Mutation                    | Error-union (status)                  | Medlemmer (nye/endrede)                                                  |
| --------------------------- | ------------------------------------- | ------------------------------------------------------------------------ |
| `redigerApplikasjonNavn`    | `RedigerApplikasjonNavnErrors` (ny)   | `IngenRettighetTilApplikasjon`, `NavnAlleredeIBruk` (ny), `UgyldigInput` |
| `opprettApplikasjonV2`      | `OpprettApplikasjonErrors` (utvidet)  | `+ NavnAlleredeIBruk`, `+ AnsvarligPaakrevdVedOpprettelse`               |
| `fjernApplikasjonTilganger` | `FjernApplikasjonTilgangerErrors` (utvidet) | `+ ArvetTilgangKanIkkeFjernes`                                     |

#### Sporings-felter

`Applikasjon` har allerede `opprettetAv`, `opprettetTidspunkt`, `endretAv`, `endretTidspunkt` (`schema.graphql:1420–1433`). Alle nye mutations skal returnere disse i payload-en.

#### Versjonering

Én `V2`-mutation (`opprettApplikasjonV2`) — alle andre endringer er additive (`extend input`, `extend type`) og bakoverkompatible.

#### Mock-API-strategi

Plan-en bygger frontend mot mock-handlers i `src/mocks/handlers/applikasjoner/`. Mock-en speiler det foreslåtte ekte schema-et 1:1 så fragmenter, types og operasjoner er identiske. Codegen kjøres mot mock-schema-snapshotet inntil ekte schema er deployet.

### Åpne spørsmål

- [ ] **#1 Navn-feltets relasjon til idP-visningsnavn.** Krav-en for opprettelse sier navnet hentes fra idP; rediger-krav-en sier navnet kan endres. **Brukerens valg er bruker-overstyrt visningsnavn** — backend må bekrefte unikhets-håndheving på fs-admin-overstyringen. Hvis backend ikke kan støtte dette, må Op #3 droppes og UI-en justeres.
- [ ] **#2 Arv-modellens form (Op #5).** `ApplikasjonTilgangArv { opphavsTilgang, begrunnelse }` er fs-admin-konsumentens beste gjetning. Backend-modellen kan se annerledes ut.
- [ ] **#3 Dedup-ansvar for arvede tilganger.** Forslaget legger ansvar på backend-resolveren før paginering. Trenger bekreftelse.
- [ ] **#4 Skal `OpprettApplikasjonInput` (V1) fjernes eller bare deprecateres?** Avhenger av om andre konsumenter enn fs-admin finnes.
- [ ] **#5 Deprecation-vindu for `fjernApplikasjonAnsvarlig` (Op #7).** Foreslått 2026-09-01 (~3 mnd) — backend-agent kan ønske lengre vindu.

## Implementation Tasks

Tasks er gruppert i 5 faser etter avhengighet og scope. Iter 2-mønstret følges: mock-API i fase 0, deretter UI parallelt.

### Fase 0 — Mock-API + i18n-grunnlag

#### Task #1: Utvid mock-API med Iter 3 schema-tillegg

**Priority:** High
**Size:** L (5–8t)
**Dependencies:** None
**Addresses Requirements:** BRU-APP-API-001, -002, -003, -005, -006, -007, -008, -009

**Acceptance Criteria:**

- [ ] `src/mocks/handlers/applikasjoner/queries.ts` håndterer nye filter-felter (`miljoer`, `organisasjonsIder`, `tilgangskodeContains`, `inkluderArvede`).
- [ ] `Applikasjon`-fixturer i `src/mocks/fixtures/applikasjoner/applikasjoner.ts` inkluderer `antallTilganger`, `kanRedigereNavn`.
- [ ] `ApplikasjonTilgang`-fixturer i `src/mocks/fixtures/applikasjoner/tilganger.ts` modellerer arv: minst 3 tilganger har `erArvet: true` med `arvetFra`-relasjoner pekende på direkte tildelte; minst 1 har flere opphav for å teste dedup.
- [ ] Mock-handler dedup'er arvede tilganger på (org, miljø, tilgangskode) før den returnerer paginert resultat.
- [ ] Mock-mutations registrert: `redigerApplikasjonNavn`, `opprettApplikasjonV2`. Mock-handler returnerer korrekte error-medlemmer (`NavnAlleredeIBruk`, `AnsvarligPaakrevdVedOpprettelse`, `ArvetTilgangKanIkkeFjernes`).
- [ ] Codegen kjørt og `src/__generated__/graphql.ts` reflekterer nye typer/felter.
- [ ] `npm test`, `npm run test:typecheck`, `npm run lint` består.

**Implementation Notes:**

- Speil schema-formen i `## GraphQL-endringer` 1:1 — frontend-fragmenter må kompilere mot mock og ekte uten endring.
- Behold eksisterende `tilgangskoder: [String!]`-filter parallelt med nytt `tilgangskodeContains`.
- For arv-fixtures: 5 direkte-tildelte tilganger + 3 arvede (én med flere opphav) er nok til å dekke alle scenarier.

#### Task #2: Externalize i18n-strenger for Iter 3-utvidelser

**Priority:** High
**Size:** M (3–4t)
**Dependencies:** None (kan kjøres parallelt med Task #1)

**Acceptance Criteria:**

- [ ] `src/common/messages/nb/support.json` har nye namespaces/nøkler for: rediger-modus-knapper og -labels, navn-validering, arv-badge, "Vis arvede"-toggle, modal-headinger for tildel/fjern, obligatorisk-felt-meldinger, idP-/org-/status-labels i info-fanen.
- [ ] Nøkkel-konvensjon: `support.Applikasjon.*` for detalj-side, `support.Applikasjoner.*` for liste, `support.OpprettApplikasjon.*` for opprett-dialog, `support.RedigerDetaljer.*` for ny inline rediger-form, `support.TildelTilganger.*` og `support.FjernTilganger.*` for modaler.
- [ ] Ingen hardkodede norske strenger igjen i de Iter 3-berørte komponentene (verifisert ved grep).
- [ ] `npm run generate:translations` kjørt; type-sjekk består.

**Implementation Notes:**

- Bruk `/externalize-i18n`-kommandoen for å starte hver komponent.

### Fase 1 — Listevisning-utvidelser

#### Task #3: Legg til `antallTilganger`-kolonne i listevisningen

**Priority:** Medium
**Size:** S (1–2t)
**Dependencies:** Task #1
**Addresses Requirements:** BRU-APP-API-001 (felt-tabell-utvidelse)

**Acceptance Criteria:**

- [ ] `APPLIKASJONER_RESULT_ROW_FRAGMENT` i `ApplikasjonerResultRow.tsx` utvidet med `antallTilganger`.
- [ ] Rad-grid får ny kolonne mellom "Organisasjon" og "Status" som viser tallet med oversettings-nøkkel (eks. *"12 tilganger"*).
- [ ] `.a11y.test.tsx` oppdatert.

**Implementation Notes:**

- Bruk `ListItemCell` for kolonnen, jf. `fs-admin-list-results`-skill.
- Skissen viser tallet med suffix "tilganger" — bruk pluralization-helper hvis det finnes, ellers en enkel i18n-mal.

#### Task #4: Legg til miljø-filter i listevisningen

**Priority:** Medium
**Size:** M (3–4t)
**Dependencies:** Task #1
**Addresses Requirements:** BRU-APP-API-001 (`Filtrere på miljø`-scenario)

**Acceptance Criteria:**

- [ ] Ny fil `src/domains/support/features/Applikasjoner/components/filter/ApplikasjonerMiljoFilter.tsx` (+ `.a11y.test.tsx`) — bruker `FSFilterList` eller `Select`/`SiktCheckbox` som passer for "zero/one/many of N" valg, jf. `fs-admin-list-filters`-skill.
- [ ] `useGetApplikasjonerState.tsx` utvidet med `miljoer: Miljo[]` i filter-shape, URL-synced.
- [ ] `ApplikasjonerFilter.tsx` rendrer den nye komponenten med `renderAsChips`-støtte.
- [ ] `useGetApplikasjoner.tsx` sender `miljoer` i `filter`-variabelen.
- [ ] Reset-knapp resetter også miljø-filteret.

#### Task #5: Verifiser listevisning end-to-end mot oppdaterte mock-fixtures

**Priority:** Low
**Size:** S (1–2t)
**Dependencies:** Task #3, #4
**Addresses Requirements:** BRU-APP-API-001

**Acceptance Criteria:**

- [ ] Manuell test i dev-server: åpne `/tilgangsstyring/applikasjoner`, verifiser at "Antall tilganger" rendres på alle rader, og at miljø-filter snevrer listen riktig.
- [ ] Combine-filter-scenario: miljø + organisasjon + status returnerer riktig snitt.
- [ ] Kombinasjon med fritekst-søk fungerer.

### Fase 2 — Detalj-side: info-fanen til inline rediger

#### Task #6: Bygg `useUnsavedChangesGuard`-hook for discardable-changes

**Priority:** High
**Size:** M (3–4t)
**Dependencies:** None
**Addresses Requirements:** BRU-APP-API-006 (Regel: "Ulagrede endringer forkastes ved navigering")

**Acceptance Criteria:**

- [ ] Ny fil `src/domains/support/features/Applikasjon/components/RedigerDetaljer/useUnsavedChangesGuard.tsx` (+ test).
- [ ] Hook eksponerer `{ markDirty: () => void, markClean: () => void }`.
- [ ] Når `dirty`-state: `beforeunload`-event setter `returnValue` (browser-native dialog).
- [ ] Når `dirty`-state: navigering bort (router-change, tab-change) nullstiller form-state via callback uten å blokkere navigeringen (krav-en sier "forkastes", ikke "blokkeres med dialog").
- [ ] Unit-test dekker mount/unmount-cleanup, dirty→clean-overganger.

**Implementation Notes:**

- Next.js App Router: bruk `usePathname()` + `useEffect` til å oppdage router-bytte. `unstable_useBlocker` finnes ikke, men passive cleanup via `useEffect`-return er nok for "forkastes uten dialog".
- Tab-bytte i `DetailPageTabbedContent` er en lokal state-overgang i React-treet — unmount av rediger-formen rydder state automatisk.

#### Task #7: Fjern `Fjern ansvarlig`-flyten

**Priority:** High
**Size:** S (1–2t)
**Dependencies:** None
**Addresses Requirements:** BRU-APP-API-005 (ny obligatorisk-regel)

**Acceptance Criteria:**

- [ ] Slett `src/domains/support/features/Applikasjon/components/SettAnsvarligDialog/FjernAnsvarligConfirmDialog.tsx` + `.a11y.test.tsx`.
- [ ] Slett `src/domains/support/features/Applikasjon/components/SettAnsvarligDialog/fjernApplikasjonAnsvarligMutation.ts`.
- [ ] Fjern "Fjern ansvarlig"-knappen og mount-state i `ApplikasjonInformation.tsx:282-289` (`fjernAnsvarligDialogOpen`-state også).
- [ ] Knappene "Sett ansvarlig" og "Endre ansvarlig" beholdes, men kalles fra rediger-modus i Task #9 (se nedenfor).
- [ ] i18n-nøkler for fjern-ansvarlig fjernes fra `support.json`.

#### Task #8: Inline rediger-modus — utvid info-fragment + bygg `RedigerDetaljerForm`

**Priority:** High
**Size:** L (5–8t)
**Dependencies:** Task #1, #2, #6, #7
**Addresses Requirements:** BRU-APP-API-002 (rediger-modus), BRU-APP-API-006 (navn + beskrivelse rediger)

**Acceptance Criteria:**

- [ ] `APPLIKASJON_INFORMATION_FRAGMENT` i `ApplikasjonInformation.tsx` utvidet med `kanRedigereNavn`, `identitetsleverandor`.
- [ ] Ny fil `RedigerDetaljer/RedigerDetaljerForm.tsx` (+ `.a11y.test.tsx`) som:
  - Tar `applikasjon`-fragment-ref og rendrer inputs for navn, beskrivelse, ansvarlig.
  - Gating pr. felt: `kanRedigereNavn` → navn-input enabled, ellers read-only; samme for beskrivelse og ansvarlig.
  - Validering: tomt navn → "Navn er obligatorisk"-feilmelding, blokker lagring.
  - Bruker `useUnsavedChangesGuard` for å nullstille ved navigering.
  - Lagre-knapp sender `redigerApplikasjonNavn` + `redigerApplikasjonBeskrivelse` + (ved endret ansvarlig) `settApplikasjonAnsvarlig` parallelt; aggregerer feil i én melding.
  - Avbryt-knapp nullstiller form-state.
- [ ] `ApplikasjonInformation.tsx` bygges om: legger til "Rediger detaljer"-toggle som mounter `RedigerDetaljerForm`; lesemodus skjules samtidig.
- [ ] Dialog-knapper for "Rediger beskrivelse", "Sett ansvarlig", "Endre ansvarlig" fjernes fra lesemodus.
- [ ] `RedigerBeskrivelseDialog/` slettes (mappa, mutation, test).
- [ ] `SettAnsvarligDialog/` beholdes — `RedigerDetaljerForm` bruker den som popover/inline-søk for ansvarlig-feltet, eller restruktureres til ren `<AnsvarligSelect>`-komponent (vurder under implementasjon).

**Implementation Notes:**

- Skissen viser navn + beskrivelse + ansvarlig som inputs i rediger-modus. idP, org, status, miljøer, sporing forblir read-only.
- Behold `OutputField`-komponentet for read-only felter; bruk `TextInput`/`TextArea` for inputs (jf. `fs-admin-inputs`-skill).
- Ny mutation `REDIGER_APPLIKASJON_NAVN` lagres i `RedigerDetaljer/mutation.ts`.

#### Task #9: Vis idP, organisasjon, status i info-fanen

**Priority:** Medium
**Size:** S (1–2t)
**Dependencies:** Task #8
**Addresses Requirements:** BRU-APP-API-002 (commit `cee226d` + `59eba3d`)

**Acceptance Criteria:**

- [ ] Info-fanen viser idP-feltet (navn fra `IdentitetsleverandorType`-enum via i18n-mapping — gjenbruk `getIdentitetsleverandorKey` fra `ApplikasjonTopBar.tsx`).
- [ ] Organisasjon-feltet vises eksplisitt i info-fanen (er der allerede via `applikasjon.organisasjon.navn` — verifiser).
- [ ] Status-felt vises i info-fanen (kan dupliseres fra topbar — krav-en sier "Se status" som scenario).

**Implementation Notes:**

- Topbar viser disse fra før — info-fanen-visningen er for å gi en samlet detalj-oversikt og oppfylle "Se status"/"Se identitetsleverandør"-scenariene.

### Fase 3 — Tilganger-fanen: filter, arv, og restrukturering

#### Task #10: Utvid `Applikasjon`-info i topbar med `antallTilganger`

**Priority:** Low
**Size:** S (1–2t)
**Dependencies:** Task #1
**Addresses Requirements:** BRU-APP-API-002 (topbar-skisse viser "Antall tilganger: 14")

**Acceptance Criteria:**

- [ ] `APPLIKASJON_TOP_BAR_FRAGMENT` utvidet med `antallTilganger`.
- [ ] `ApplikasjonTopBar.tsx` rendrer tallet som ekstra info-line eller chip.
- [ ] `.a11y.test.tsx` oppdatert.

#### Task #11: Sletter `Miljø` fra sort-valg i tilgangs-listen

**Priority:** Low
**Size:** S (1t)
**Dependencies:** None
**Addresses Requirements:** BRU-APP-API-003 (commit `cee226d`: *"fjern miljø-sortering"*)

**Acceptance Criteria:**

- [ ] `ApplikasjonTilgangerOrderBy.tsx` viser kun `Tilgangskode` som sort-valg.
- [ ] Hvis nåværende URL-state har `orderByField=MILJO`, fall tilbake til `TILGANGSKODE`.

#### Task #12: Utvid `useApplikasjonTilgangerState` med organisasjon + fritekst + arv-toggle

**Priority:** High
**Size:** M (3–4t)
**Dependencies:** Task #1
**Addresses Requirements:** BRU-APP-API-003 (commit `cee226d` + `4f2e9a4`)

**Acceptance Criteria:**

- [ ] State-shape utvidet med `organisasjonsIder: string[]`, `tilgangskodeContains: string`, `skjulArvede: boolean`.
- [ ] URL-state-sync via samme mønster som listevisningen.
- [ ] Reset-knapp nullstiller alle nye felter.

#### Task #13: Bygg organisasjon-filter, fritekst-filter, arv-toggle for tilgangs-listen

**Priority:** High
**Size:** M (3–4t)
**Dependencies:** Task #12
**Addresses Requirements:** BRU-APP-API-003

**Acceptance Criteria:**

- [ ] Ny fil `ApplikasjonTilgangerOrganisasjonFilter.tsx` (+ test) — multi-select, valg begrenset til organisasjoner applikasjonen har tilganger hos.
- [ ] Eksisterende `ApplikasjonTilgangerTilgangskodeFilter.tsx` endres fra `tilgangskoder: [String!]` til fritekst `tilgangskodeContains: string` (`TextInput` med debounce, jf. `fs-admin-inputs`-skill — ingen `type="search"`, ingen placeholder-som-label).
- [ ] Ny fil `ApplikasjonTilgangerArvToggle.tsx` (+ test) — `SiktSwitch`/`SiktCheckbox` for "Vis arvede tilganger"-toggle (default på).
- [ ] `ApplikasjonTilgangerFilter.tsx` rendrer alle 4 filtre i sidebar + chips-row med `renderAsChips`.

#### Task #14: Utvid `ApplikasjonTilgangerResultRow` med beskrivelse, organisasjon, arv-badge

**Priority:** High
**Size:** M (3–4t)
**Dependencies:** Task #1
**Addresses Requirements:** BRU-APP-API-003 (commit `cee226d` + `4f2e9a4`)

**Acceptance Criteria:**

- [ ] `APPLIKASJON_TILGANG_ROW_FRAGMENT` utvidet med `tilgangsbeskrivelse`, `organisasjon { id, navn }`, `erArvet`, `arvetFra { opphavsTilgang { id, tilgangskode }, begrunnelse }`.
- [ ] Rad-grid får kolonner i rekkefølge: tilgangskode + idP/arv-badges → beskrivelse → organisasjon (jf. skisse).
- [ ] Ny komponent `ApplikasjonTilgangerArvBadge.tsx` (+ test) — viser "Arvet"-badge med tooltip/popover som lister `arvetFra[].opphavsTilgang.tilgangskode` og første `begrunnelse`.
- [ ] `.a11y.test.tsx` oppdatert med arv-scenarier.

#### Task #15: Verifiser tilgangs-listen end-to-end mot oppdaterte mock-fixtures

**Priority:** Low
**Size:** S (1–2t)
**Dependencies:** Task #11, #12, #13, #14

**Acceptance Criteria:**

- [ ] Manuell test: filtrer på organisasjon → kun matchende tilganger vises.
- [ ] Fritekst-filter "emne" matcher tilgangskoder som inneholder substringen.
- [ ] Toggle av "Vis arvede" skjuler/viser arvede tilganger.
- [ ] Arv-badge tooltip viser korrekte opphav.
- [ ] Dedup-scenario: tilgang med flere opphav listes kun én gang.

### Fase 4 — Tildel / fjern tilganger: kaskade + modal-restrukturering

#### Task #16: Restrukturer `TildelTilgangerDialog` til kaskade (org → miljø → kode)

**Priority:** High
**Size:** L (5–8t)
**Dependencies:** Task #1
**Addresses Requirements:** BRU-APP-API-007 (commit `59eba3d`)

**Acceptance Criteria:**

- [ ] Dialog-flyt: bruker velger organisasjon først, deretter miljø, deretter (etter at begge er valgt) åpnes valglisten for tilgangskoder.
- [ ] `tildelbareApplikasjonTilganger(applikasjonsId, miljo, organisasjonsId)`-query re-utløses ved hver endring i (org, miljø) — bruk `useQuery` med `skip`-flag inntil begge er valgt.
- [ ] Allerede tildelte tilganger vises som ikke-valgbare (uten implementasjons-detalj om "gråtone" — bruker `disabled`-attribute + tilstands-tekst).
- [ ] "Bekreft tildeling"-knapp sender `tildelApplikasjonTilganger`-mutation med valgte tilgangskoder.
- [ ] Dialogen kan åpnes også når applikasjonen er deaktivert; suksess-melding viser status-kontekst.
- [ ] Hvis bruker har kun én organisasjon: skip org-trinn (auto-velg).
- [ ] `.a11y.test.tsx` dekker alle tre trinn.

**Implementation Notes:**

- Skissen `applikasjon-detaljevisning-aktiv-tab-tilganger.png` viser "+ Tildel tilganger"-knapp øverst — knapp finnes allerede.
- Apollo-cache-oppdatering: mutation-payload returnerer `applikasjon { id, antallTilganger }` så listen og topbar oppdateres uten manuell refetch.

#### Task #17: Restrukturer `FjernTilgangerDialog` til samlet modal med org/miljø/tilganger inni

**Priority:** High
**Size:** L (5–8t)
**Dependencies:** Task #1, #14
**Addresses Requirements:** BRU-APP-API-008 (commit `59eba3d` + `4f2e9a4`)

**Acceptance Criteria:**

- [ ] Modal-flyt: bruker åpner modal, velger organisasjon + miljø, ser deretter liste over tilganger applikasjonen har for den kombinasjonen (hentet via `applikasjon.tilganger(filter: { miljoer: [valgt], organisasjonsIder: [valgt] })`).
- [ ] Bruker huker av tilganger som skal fjernes, bekrefter.
- [ ] Arvede tilganger filtreres ut av valglisten på klient-siden (basert på `erArvet`); hvis listen blir tom, vis "Ingen direkte tildelte tilganger å fjerne".
- [ ] "Avbryt" → ingen endring.
- [ ] Modalen kan åpnes også når applikasjonen er deaktivert.
- [ ] In-row select-checkboxes fjernes fra `ApplikasjonTilgangerResultList`; `FjernValgteTilgangerButton.tsx` erstattes/forenkles til en "Åpne fjernings-modal"-knapp.
- [ ] `.a11y.test.tsx` dekker happy path, avbryt, arvet-filtrering, og deaktivert-applikasjon-tilfellet.

**Implementation Notes:**

- Skissen viser "Fjern tilganger"-knapp øverst (samme nivå som "+ Tildel tilganger").
- Hvis backend returnerer `ArvetTilgangKanIkkeFjernes`-error: vis i UI som validerings-feilmelding (skal i prinsippet ikke skje pga. client-side-filtreringen, men trygd mot race conditions).

#### Task #18: Oppdater `FjernTilgangerDialog`-error-handling for `ArvetTilgangKanIkkeFjernes`

**Priority:** Medium
**Size:** S (1–2t)
**Dependencies:** Task #17

**Acceptance Criteria:**

- [ ] `FjernApplikasjonTilganger`-mutation utvidet med `... on ArvetTilgangKanIkkeFjernes { applikasjonsTilgangId }`.
- [ ] Error mappes til norsk feilmelding via i18n.
- [ ] Test simulerer at mock returnerer denne errorn.

#### Task #19: Utvid `OpprettApplikasjonDialog` med navn og ansvarlig (V2-mutation)

**Priority:** High
**Size:** L (5–8t)
**Dependencies:** Task #1
**Addresses Requirements:** BRU-APP-API-009 (commit `a7efc9f`)

**Acceptance Criteria:**

- [ ] `OpprettApplikasjonDialog.tsx` har inputs for navn (`TextInput`, obligatorisk) og ansvarlig (`<AnsvarligSelect>` eller gjenbruk av `SettAnsvarligDialog`s søke-komponent, scopet til valgt organisasjon).
- [ ] Validering: tomt navn → "Navn er obligatorisk", ingen ansvarlig → "Ansvarlig er obligatorisk".
- [ ] Mutation oppgradert til `opprettApplikasjonV2` med `OPPRETT_APPLIKASJON_V2`-konstant.
- [ ] Error-handling: `NavnAlleredeIBruk` → "Navnet er allerede i bruk" + lenke til konflikt-applikasjon, `AnsvarligPaakrevdVedOpprettelse` (server-side-fallback) → "Ansvarlig må velges".
- [ ] Suksess: dialogen lukkes, listen oppdateres, naviger til detaljsiden.
- [ ] `.a11y.test.tsx` dekker validering, suksess, error-states.

**Implementation Notes:**

- Ansvarlig-søk-feltet trenger samme org-skopering som `SettAnsvarligDialog` (begrenset til valgt `organisasjonsId`).

### Fase 5 — Sluttfase: tilstandshåndtering for deaktivert applikasjon, codegen, verifisering

#### Task #20: Verifiser at tildeling/fjerning fungerer på deaktivert applikasjon

**Priority:** Medium
**Size:** S (1–2t)
**Dependencies:** Task #16, #17
**Addresses Requirements:** BRU-APP-API-007 (Regel: tildele til deaktivert), BRU-APP-API-008 (Regel: fjerne fra deaktivert)

**Acceptance Criteria:**

- [ ] Tildel-knapp og Fjern-knapp i `ApplikasjonTilganger.tsx` er ikke disabled når `applikasjon.status === INAKTIV`.
- [ ] Eksisterende `GuidePanel` om deaktivert-tilstand i `ApplikasjonTilganger.tsx` justeres til å si "tilganger kan endres", ikke "tilganger er låst".
- [ ] Mock-fixture inkluderer minst én deaktivert applikasjon med tilganger for å teste flyten.

#### Task #21: Sluttfør codegen og typecheck etter alle endringer

**Priority:** High
**Size:** S (1–2t)
**Dependencies:** Tasks #1–#20

**Acceptance Criteria:**

- [ ] `npm run compile` (codegen) kjørt; `src/__generated__/graphql.ts` reflekterer alle nye typer.
- [ ] `npm run test:typecheck` består uten feil eller advarsler.
- [ ] `npm run lint` består.
- [ ] `npm run formatcheck` består.
- [ ] `npm test` består.
- [ ] `npm run test:a11y` består — alle nye/endrede komponenter har gyldige a11y-tester.

#### Task #22: Manuell verifisering mot Figma-skissene + kravene

**Priority:** Medium
**Size:** M (3–4t)
**Dependencies:** Task #21

**Acceptance Criteria:**

- [ ] Sammenlign listevisningen i dev-server mot `applikasjoner-listevisning.png` (alle felter synlige, "Antall tilganger" på riktig plass, miljø-filter med riktig UI).
- [ ] Sammenlign detaljside-tabben "Detaljer" (lesemodus) mot `applikasjon-detaljevisning-aktiv-tab-detaljer-lese-modus.png`.
- [ ] Sammenlign rediger-modus mot `applikasjon-detaljevisning-aktiv-tab-detaljer-rediger-modus.png` — alle inputs synlige, lagre/avbryt-knapper, navigering bort nullstiller.
- [ ] Sammenlign tilganger-tabben mot `applikasjon-detaljevisning-aktiv-tab-tilganger.png` — sidebar-filtre, arv-badges, "Vis arvede"-toggle, "+ Tildel tilganger" / "Fjern tilganger"-knapper.
- [ ] Gå gjennom hvert `Scenario` i de 7 endrede `.feature`-filene og kryss av at det er dekket.

## Risk Assessment

### Technical Risks

- **Risk:** Inline rediger-modus i info-fanen er en større refactor enn det først ser ut. Mye logikk flyttes fra 5 separate dialoger (`RedigerBeskrivelse`, `SettAnsvarlig`, `FjernAnsvarlig`) til én form.
  - **Mitigation:** Task #8 er bevisst Large (5–8t). Hold `SettAnsvarligDialog` som indre komponent (popover/inline-søk) for å redusere scope.

- **Risk:** Arv-modellen (Op #5) er fs-admins gjetning på schema-form. Når backend leverer kan formen avvike, og rad-fragmentet + arv-badge må refaktoreres.
  - **Mitigation:** Mock-API speiler den foreslåtte formen 1:1 så frontend-koden er testbar. Når backend kommer: ett enkelt sted (rad-fragment + badge-komponent) tilpasses. Risikoen er konsentrert til ett mappenavn.

- **Risk:** Discardable-changes-mekanikken (Task #6) kan introdusere bugs ved router-overgang i Next.js App Router (ingen førsteklasses `useBlocker`).
  - **Mitigation:** Hold mekanismen passiv (cleanup på unmount), ikke aktiv (blokker navigering). Krav-en sier "forkastes", ikke "spør bruker først". Browser-native `beforeunload` for window-close er den eneste aktive interaksjonen.

- **Risk:** `TildelTilgangerDialog`-restruktureringen krever re-fetch av `tildelbareApplikasjonTilganger`-query ved hver (org, miljø)-endring. Dårlig UX hvis det ikke debounces/caches.
  - **Mitigation:** Apollo-cachen normaliserer queries pr. (orgId, miljo)-kombinasjon, så re-fetch er gratis ved tilbake-bytte. Vurder `fetchPolicy: 'cache-and-network'` for å vise siste kjent verdi mens nytt resultat lastes.

- **Risk:** `OpprettApplikasjonV2`-mutation er ikke tilgjengelig i ekte schema før backend leverer. Hvis fs-admin merges før det: produksjons-bygget vil få runtime-feil.
  - **Mitigation:** Feature-flag `tilgangsstyring-meny` (eksisterende) holder hele tilgangsstyring-flyten av i prod. Aktivering planlegges sammen med backend-leveranse.

- **Risk:** Dedup-ansvar for arvede tilganger (Open Question #3) er antatt backend. Hvis backend ikke gjør dette, må frontend gjøre det client-side — bryter paginering (`totalCount` blir feil).
  - **Mitigation:** Mock-handler implementerer dedup på backend-siden så frontend kan utvikles mot forventet kontrakt. Flagges som blocker for ekte schema.

- **Risk:** Externalize-i18n (Task #2) er bredt og lett å miste oversikt over.
  - **Mitigation:** Bruk eksisterende `/externalize-i18n`-kommandoen pr. komponent. Verifiser med grep etter at hver komponent er ferdig.

### Testing Requirements

- **Unit tests:** Hver ny hook (`useUnsavedChangesGuard`) og hver utvidede state-hook (`useGetApplikasjonerState`, `useApplikasjonTilgangerState`) har test-dekning for filter-mapping og state-overganger.
- **A11y tests:** Hver ny eller endret komponent har `.a11y.test.tsx` (CLAUDE.md-krav). Estimat: ~10 nye a11y-test-filer + ~8 oppdaterte.
- **Integration tests** (manuelt eller via mock-API-bekreftelser):
  - Rediger-modus happy path: åpne → endre navn + beskrivelse + ansvarlig → lagre → alle tre lagres.
  - Rediger-modus discardable: åpne → endre → bytt tab → returner → felter er nullstilt.
  - Tildel kaskade: velg org → miljø → tilgangskoder → bekreft → tilgang vises i listen.
  - Fjern via modal: åpne → velg org+miljø → huk av arvet (skjult fra listen) → bekreft → listen er kortere.
  - Opprett med validering: tomt navn blokkerer lagring; navn-kollisjon viser feilmelding.
  - Deaktivert-applikasjon: tildel/fjern fungerer; status-banner reflekterer riktig.
- **Manuell verifikasjon:** Task #22 dekker.

## Success Criteria

- [ ] Alle 22 Tasks fullført med Acceptance Criteria godkjent i PR-review.
- [ ] Alle Iter 3-relaterte `@must @planned`-krav (BRU-APP-API-001..010) dekker de oppdaterte scenariene fra de 7 commitene.
- [ ] `npm test`, `npm run test:a11y`, `npm run test:typecheck`, `npm run lint`, `npm run formatcheck` består.
- [ ] Coverage-tersklene fra `jest.config.ts` (60% branches/functions/lines, 90% statements) er fortsatt oppfylt.
- [ ] Manuell verifisering mot 5 skisser i `docs/skisser/` viser at UI matcher.
- [ ] Feature-flag `tilgangsstyring-meny` fortsatt av i prod ved første merge.
- [ ] Hand-off-issue mot backend-agent fileret med koblet til feature-folder i coord-repo (`agents/fs-admin/2026-05-27-applikasjon-tilgangsstyring/`).
- [ ] Endringslogg (BRU-APP-API-016) **forblir urørt** — Iter 4, fortsatt `@draft`, ikke i scope.

## Requirements Traceability

| Requirement ID  | Summary                                  | Endring i Iter 3                      | Tasks                          | Status  |
| --------------- | ---------------------------------------- | ------------------------------------- | ------------------------------ | ------- |
| BRU-APP-API-001 | Listevisning og søk                      | + Antall tilganger, + miljø-filter    | #1, #2, #3, #4, #5             | Planned |
| BRU-APP-API-002 | Se detaljer                              | + idP/org/status i info, + rediger-toggle | #1, #2, #8, #9, #10        | Planned |
| BRU-APP-API-003 | Vise tilganger                           | + org-filter, fritekst, arv           | #1, #2, #11, #12, #13, #14, #15 | Planned |
| BRU-APP-API-004 | Passordbytte                             | Ingen endring                         | —                              | Done    |
| BRU-APP-API-005 | Administrere ansvarlig                   | Fjerne Fjern-flyten, obligatorisk     | #2, #7, #8                     | Planned |
| BRU-APP-API-006 | Rediger detaljer                         | Navn-redigering, ulagrede forkastes   | #1, #2, #6, #8                 | Planned |
| BRU-APP-API-007 | Tildele tilgang                          | Kaskade, deaktivert-applikasjon       | #1, #2, #16, #20               | Planned |
| BRU-APP-API-008 | Fjerne tilgang                           | Samlet modal, arv-filter, deaktivert  | #1, #2, #17, #18, #20          | Planned |
| BRU-APP-API-009 | Opprette applikasjon                     | Navn + ansvarlig obligatorisk (V2)    | #1, #2, #19                    | Planned |
| BRU-APP-API-010 | Deaktivere                               | Ingen endring                         | —                              | Done    |
| BRU-APP-API-015 | Sist brukt                               | Ingen endring                         | —                              | Done    |
| BRU-APP-API-016 | Endringslogg                             | **Ikke i scope — Iter 4 @draft**      | —                              | Deferred |
| BRU-APP-API-017 | Masseadministrasjon                      | Ikke i scope (`@could @draft`)        | —                              | Deferred |

## Cross-agent Hand-offs (kandidater — bekreftes etter plan-publisering)

Per brukerens valg "Surface kandidater — du bekrefter per hand-off". Fileres med `agent-coord` etter at brukeren bekrefter hvilke som skal opprettes.

1. **Backend / SuperGraf-schema-agent — Iter 3 schema-utvidelser:**
   - `ApplikasjonerFilterInput.miljoer` (Op #1).
   - `Applikasjon.antallTilganger` (Op #2).
   - `Applikasjon.kanRedigereNavn` + `redigerApplikasjonNavn`-mutation + `NavnAlleredeIBruk`-error (Op #3).
   - `ApplikasjonTilgangerFilterInput.organisasjonsIder` + `tilgangskodeContains` + `inkluderArvede` (Op #4).
   - Arv-modell på `ApplikasjonTilgang` (`arvetFra`, `erArvet`, `ApplikasjonTilgangArv`-type) + dedup-ansvar i resolveren (Op #5).
   - `opprettApplikasjonV2`-mutation med `navn` + `ansvarligId` + nye errors (Op #6).
   - `@deprecated` på `fjernApplikasjonAnsvarlig` (Op #7).
   - Bekreftelse av åpne spørsmål #1 (navn-unikhet), #2 (arv-form), #3 (dedup-ansvar), #5 (deprecation-vindu).
   - **Hvorfor blokkerer:** Frontend bygger mot mock-API, men kan ikke aktiveres i prod uten ekte schema.

2. **Produkt-eier (krav-arbeid) — Åpent spørsmål #1:**
   - Bekrefte at navn er bruker-overstyrt visningsnavn (ikke låst til idP).
   - **Hvorfor blokkerer:** Hvis svaret er "låst til idP", droppes Op #3 og Task #8 må justeres.

## Notater

- Plan-en gjenspeiler Iter 2's `mock-API først`-strategi og samme task-granularitet. 22 tasks er forventet ~3 ukers fokusert utvikling for én utvikler.
- Endringslogg-fanen (BRU-APP-API-016) blir egen plan-runde når åpne spørsmål er besvart og krav-en flyttes fra `@draft` til `@planned`.
- POC-fjernings-arbeidet (`docs/ACTIVE-ITERATION-2/` referer til "Maskinbruker-POC fortsatt funksjonell") ligger fortsatt utenfor scope; planlegges som separat oppfølgings-PR når feature-flag aktiveres i prod.