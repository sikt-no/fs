# Plan: Applikasjoner — Iterasjon 2 (Listevisning)

> **Skop:** Listevisningen for applikasjoner i fs-admin per krav [BRU-APP-API-001](krav-input/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature) (initiativ [#31](https://github.com/sikt-no/fs/issues/31), sub-issue [#434](https://github.com/sikt-no/fs/issues/434)). Forankret i sketchen [`applikasjoner-listevisning.png`](applikasjoner-listevisning.png).
>
> **Følger fra:** [`analysis-applikasjoner-iter2.md`](analysis-applikasjoner-iter2.md). Planens skop er bevisst smal: bare listevisningen. Detaljside-flyten (se detaljer, vise tilganger, passordbytte, ansvarlig, beskrivelse) og POC-fjerning ligger i separate planer.
>
> **Planlegging-defaults brukt** (per brukerens valg ved plan-start, dokumentert som antagelser i Risk Assessment):
>
> - Miljø-filter inkluderes i listevisningen (sketch wins over feature-fil).
> - "Antall tilganger" inkluderes som radfelt (sketch wins).
> - "+ Opprett"-knapp **skjules** i Iter 2 (kommer i Iter 3 — `opprette_applikasjon.feature`).
> - `@could`-krav (tilgang-filter, ansvarlig via feide-gruppe) **utsettes**.
> - POC-fjerning av `Maskinbrukere`/`MaskinBruker` er **ikke i denne planen** — koordineres separat med backend-deprecation.

## Proposed Solution

### Architecture Approach

Listevisningen bygges som en kanonisk `ListPageLayout`-implementasjon, med `EmnerOverview` ↔ `EmneDetails` som referansemodell. Patteren er allerede etablert i fs-admin og dekker alle UI-behovene fra sketchen ut av boksen: sidebar-filter, søk, sortert NavigationList med load-more, totalCount/loadedCount, navigasjon til detalj.

**Domeneplassering:** `src/domains/tilgangsstyring/` — et nytt domene parallelt med `support` (der POC-en lever i dag). Domenenavnet matcher menyens "Tilgangsstyring" og er konsistent med ruten `/tilgangsstyring/...` som allerede brukes for `maskinbrukere`. POC-en blir liggende uendret under `src/domains/support/features/Maskinbrukere*` til den fjernes i en separat omgang.

**Rute:** `/tilgangsstyring/applikasjoner` (liste) og `/tilgangsstyring/applikasjoner/[id]` (detalj-stub for Iter 2 — full implementasjon i senere plan).

**State-arkitektur:** URL-synket filter/orderBy/first via `useDataListState` (kanonisk per `src/common/hooks/useDataListState/CLAUDE.md`). Frontend injiserer **ikke** `eierOrganisasjonskode` i filteret — synlighet er server-side per krav K11/K12 (se GraphQL-section). Dette avviker bevisst fra `EmnerOverview`-mønsteret og er begrunnet av krav-spesifikasjonen.

**Data-arkitektur:** `useDataListQuery` over `GET_APPLIKASJONER`-querien. Server-side filter + orderBy + paginering. Ingen klient-side filtrering. Ingen Fuse.js. Ingen `first: 1000`. (Eksplisitt anti-pattern flagget i pattern-skillen og i initiativ-issuet.)

**Tilgangskontroll i UI:** ny user-action(er) i `userActions.ts` (`SE_APPLIKASJONER` minimum, `MODIFISERE_APPLIKASJONER` nice-to-have for Iter 3-bro). Meny-oppføring i `Menu.tsx` under `/tilgangsstyring` gates på den nye user-actionen.

**i18n:** Nytt namespace `tilgangsstyring.ApplikasjonerOverview` + `tilgangsstyring.ApplikasjonerResultList` i `src/messages/nb/tilgangsstyring.json` (eller utvidelse av eksisterende fil hvis den allerede finnes). Følger samme mønster som `utdanning.EmnerOverview`.

### Key Technical Decisions

1. **Decision: Bruk `ListPageLayout` + `useDataListState`/`useDataListQuery` uendret — ikke gjenbruk noe fra Maskinbruker-POC-en.**
   - Why: Pattern-skillen matcher med 100/100 confidence; `EmnerOverview` er gold-standard; initiativ-issuet sier eksplisitt at POC-en ikke skal videreføres.
   - Alternative considered: Refaktorere `Maskinbrukere`-koden til ny pattern. Forkastet — issue-body §1 forbyr det, og refaktoreringen ville vært større enn å bygge nytt.

2. **Decision: Nytt domene `tilgangsstyring`, parallelt med `support`.**
   - Why: Konsistent med rute-prefiks `/tilgangsstyring/...` og menynavn. POC-en kan ligge urørt under `support/` til den fjernes.
   - Alternative considered: Plassere under `support/features/Applikasjoner*`. Forkastet — `support`-domenet er knyttet til POC-tankegangen; ny flate fortjener egen domene-mappe og en ren navngivning matcher menyen.

3. **Decision: `Ansvarlig`-feltet rendres med `__typename`-discriminert switch (FeideBruker / FeideGruppe).**
   - Why: Matcher GraphQL union-mønsteret i schema-section. Lar UI-en tegne feide-bruker som default og feide-gruppe når `@could` aktiveres uten ny pattern.
   - Alternative considered: To separate felt på `Applikasjon` (`ansvarligBruker`, `ansvarligGruppe`). Forkastet — bryter med "én ansvarlig av gangen"-semantikken i krav `administrere_ansvarlig.feature`.

4. **Decision: Synlighetsfilter (K11/K12) håndheves server-side, frontend sender ingen rolle-info.**
   - Why: Frontend kan ikke trygt avgjøre rettigheter. Server kjenner prinsipalen via auth-token. Konsistent med `mineSoknader`-mønsteret i schema-prinsippene.
   - Alternative considered: Frontend henter brukerens roller og legger til et `synlighetFilter`-argument. Forkastet — sikkerhetsrisiko og duplikat-logikk.

5. **Decision: Bruk `NavigationList` med `href`-prop, ikke `router.push`.**
   - Why: Bevarer URL-state, scroll, browser-historikk per cross-pattern `list-page-layout--detail-page-layout`.
   - Alternative considered: `onClick`-handler + `router.push`. Forkastet — anti-pattern i pattern-guiden.

6. **Decision: Detaljsiden får en *stub* (`page.tsx` som rendrer en placeholder) i Iter 2.**
   - Why: `href`-prop'en på `NavigationListItem` må peke til en eksisterende rute, ellers feiler typegen og navigasjonen. Full detaljside-implementasjon hører til senere plan(er).
   - Alternative considered: La detaljside-rutingen være udefinert til detaljside-planen leveres. Forkastet — bryter listevisningens "klikk → detaljside"-scenario i feature-fila.

7. **Decision: Skjul "+ Opprett"-knappen helt i Iter 2 (ikke disabled med tooltip).**
   - Why: Mindre UI-støy; tydeligere skille mot Iter 3. Knappen legges til i `ListPageActionbar` i Iter 3-planen.
   - Alternative considered: Vise disabled-knapp. Akseptabelt, men gir falske forventninger. (Hvis design overstyrer dette, er endringen liten — én flag i `ListPageActionbar`-prop.)

### File Changes Overview

**Nye filer:**

- `src/app/tilgangsstyring/applikasjoner/page.tsx` — Next.js route (klient-komponent, rendrer `ApplikasjonerOverview`).
- `src/app/tilgangsstyring/applikasjoner/layout.tsx` — `PageHeaderWrapper` med breadcrumb-tittel.
- `src/app/tilgangsstyring/applikasjoner/[applikasjonid]/page.tsx` — detaljside-stub for Iter 2 (rendrer "Kommer snart"-tekst eller `PlaceholderError`).
- `src/app/tilgangsstyring/applikasjoner/[applikasjonid]/layout.tsx` — breadcrumb-wrapper for detalj.
- `src/domains/tilgangsstyring/features/ApplikasjonerOverview/ApplikasjonerOverview.tsx` — page-level komponent (mirror av `EmnerOverview.tsx`).
- `src/domains/tilgangsstyring/features/ApplikasjonerOverview/ApplikasjonerOverview.module.css` — hvis trengs.
- `src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetApplikasjonerState.tsx` — URL-state via `useDataListState`.
- `src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetApplikasjoner.tsx` — Apollo-query via `useDataListQuery`.
- `src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/ApplikasjonerFilter.tsx` — sidebar-filtre + chips-modus.
- `src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/ApplikasjonerOrderBy.tsx` — sort-knapp (NAVN asc/desc).
- `src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/ApplikasjonerResultList.tsx` — NavigationList med rad-rendering.
- `src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/*.a11y.test.tsx` — én a11y-test per komponent (CLAUDE.md-krav).
- `src/domains/tilgangsstyring/components/NoOrgError/NoOrgError.tsx` (hvis ikke finnes — sannsynligvis ja, gjenbruk fra utdanning-domenet via flytting eller felles plassering).
- `src/messages/nb/tilgangsstyring.json` (ny eller utvidet) — i18n-nøkler.

**Endrede filer:**

- `src/features/Header/Menu/Menu.tsx` — legg til ny sub-meny-oppføring "Applikasjoner" under `/tilgangsstyring`, gated på ny user-action og evt. Unleash-flag (se OQ).
- `src/common/types/userActions.ts` — utvid enum med `SE_APPLIKASJONER` (og evt. `MODIFISERE_APPLIKASJONER`).
- `src/codegen.ts` — ingen endring trengs hvis backend leverer typene; query-fila plukkes automatisk opp.
- `src/messages/nb/*.json` — i18n-keys for menyen og bruk-andre-steder.

**Uberørt (eksplisitt):**

- `src/domains/support/features/Maskinbrukere/`, `MaskinBruker/`, `TilgangsstyringIndex/` — POC blir liggende, fjernes i separat plan.
- `src/app/tilgangsstyring/maskinbrukere/` — POC-rute blir liggende.

## GraphQL-endringer

> **Premiss:** konservativ (minimum schema-endring for å dekke Iter 2-listevisningen; detalj-mutations refereres bare som "out of scope")
> **Domeneterm:** `Applikasjon` (besluttet 2026-05-13; erstatter den tidligere `Maskinbruker`-POC-flaten per initiativ [#31](https://github.com/sikt-no/fs/issues/31) §3: *"Vi skal lage nye graphql spørringer for applikasjon. Vi skal ikke gjenbruke dagens graphql spørringer for maskinbruker."*)
> **Følger fra:** [`analysis-applikasjoner-iter2.md`](analysis-applikasjoner-iter2.md) — Key Findings #4 (ingen `Applikasjon`-typer i schema), Dependencies → Cross-agent (backend).

### Sammendrag

- **1 ny query** (`applikasjoner` — listevisning, paginert)
- **0 nye mutations** i denne planen (detalj-mutations — passordbytte, ansvarlig, beskrivelse — hører til detaljside-planen og er eksplisitt ute av skop her)
- **6 nye typer + 2 enums + 1 union** (`Ansvarlig`): `Applikasjon`, `ApplikasjonConnection`, `ApplikasjonEdge`, `ApplikasjonerFilter`, `QueryApplikasjonerOrderByInput`, `Ansvarlig` (union over `FeideBruker` + `FeideGruppe`), `ApplikasjonStatus`, `Miljo`, `QueryApplikasjonerOrderByField`
- **2 åpne spørsmål** som blokkerer (se nederst i denne seksjonen)

### Operasjoner

#### Op #1: `applikasjoner` — paginert listevisning med filter og sortering

**Dekker krav:** BRU-APP-API-001 (K1, K2, K11, K12 fra [`listevisning_og_sok.feature`](krav-input/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature))
**Implementeres av:** Task #3 (query-hook + GraphQL-operasjon); konsumert av Task #4 (filter), Task #5 (orderBy), Task #6 (result list)

##### Lag A — Schema-tillegg

```graphql
"""Applikasjon (tidligere kjent som API-bruker / maskinbruker) som autentiserer seg mot FS-økosystemet."""
type Applikasjon implements Node {
  id: ID!

  """Visningsnavn for applikasjonen. Vises i listevisning, søkes på, og brukes som sortering."""
  navn: String

  """Fri-tekst beskrivelse satt av applikasjonsadministrator."""
  beskrivelse: String

  """Miljøene applikasjonen er aktiv i. Vises som tags i listevisningen."""
  miljoer: [Miljo!]

  """
  Hvem som er ansvarlig for applikasjonen. Kan være en feide-bruker (default) eller en feide-gruppe (`@could`-krav).
  Null hvis ingen ansvarlig er satt.
  """
  ansvarlig: Ansvarlig

  """Organisasjonen applikasjonen tilhører. Kan være null for super-admin-eide applikasjoner uten organisasjon."""
  organisasjon: Organisasjon

  """Driftsstatus. Iter 2 er kun lesing; deaktivering kommer i Iter 3."""
  status: ApplikasjonStatus

  """Antall tilganger applikasjonen er tildelt på tvers av miljøer. Vises i listevisning ('13 tilganger')."""
  antallTilganger: Int
}

"""Driftsstatus for en applikasjon."""
enum ApplikasjonStatus {
  AKTIV
  DEAKTIVERT
}

"""Miljøer som FS-applikasjoner kan ha tilgang til."""
enum Miljo {
  PROD
  DEMO
  TEST
  UTV
}

"""Union over hvem som kan være ansvarlig for en applikasjon."""
union Ansvarlig = FeideBruker | FeideGruppe

"""Filter-input for `Query.applikasjoner`. Synlighet (K11/K12 + ansvarlig-relasjon) håndheves server-side basert på innlogget bruker — ikke i dette filteret."""
input ApplikasjonerFilter {
  """Fritekst-søk på navn. Case-insensitive substring-matching."""
  navnContains: String

  """Begrens til applikasjoner som tilhører én av disse organisasjonene."""
  organisasjonskoder: [String!]

  """Begrens til applikasjoner med én av disse statusene."""
  statuser: [ApplikasjonStatus!]

  """Begrens til applikasjoner som er aktive i ett eller flere av disse miljøene."""
  miljoer: [Miljo!]

  # NB: `tilgangskoder: [String!]` er `@could` i Iter 2 og er bevisst utelatt i første pass.
  # Legges til når kravet flyttes fra `@could` til `@must` eller når Iter 3 åpner for det.
}

"""Sorteringsfelt for `Query.applikasjoner`. Iter 2 trenger kun NAVN; flere felt kan legges til senere uten breaking change."""
enum QueryApplikasjonerOrderByField {
  NAVN
}

input QueryApplikasjonerOrderByInput {
  orderByField: QueryApplikasjonerOrderByField!
  direction: OrderDirection!
}

type ApplikasjonConnection {
  edges: [ApplikasjonEdge]
  nodes: [Applikasjon]
  pageInfo: PageInfo
  totalCount: Int
}

type ApplikasjonEdge {
  cursor: String
  node: Applikasjon
}

extend type Query {
  """
  Liste over applikasjoner som innlogget bruker har lov til å se.
  Synlighet håndheves server-side basert på prinsipalens rettigheter (K11/K12):
   - super-applikasjonsadministrator: alle, inkludert applikasjoner uten organisasjon
   - applikasjonsadministrator for org X: applikasjoner som tilhører X, og applikasjoner med tilganger inn i X
   - direkte ansvarlig (eller via feide-gruppe — `@could`): applikasjoner man er ansvarlig for
  """
  applikasjoner(
    filter: ApplikasjonerFilter
    orderBy: QueryApplikasjonerOrderByInput
    first: Int
    after: String
    last: Int
    before: String
  ): ApplikasjonConnection
}
```

##### Lag B — fs-admin call-site

```ts
// src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetApplikasjoner.tsx (forslag)
export const GET_APPLIKASJONER = gql(/* GraphQL */ `
  query GetApplikasjoner(
    $filter: ApplikasjonerFilter
    $orderBy: QueryApplikasjonerOrderByInput
    $first: Int
    $after: String
  ) {
    applikasjoner(filter: $filter, orderBy: $orderBy, first: $first, after: $after) {
      nodes {
        id
        navn
        beskrivelse
        miljoer
        status
        antallTilganger
        organisasjon {
          organisasjonskode
          navnAlleSprak { nb nn en }
        }
        ansvarlig {
          __typename
          ... on FeideBruker {
            id
            # ... visningsfelter for feide-bruker (verifiseres mot schema)
          }
          ... on FeideGruppe {
            id
            # ... visningsfelter for feide-gruppe (`@could` — kan utelates i v1)
          }
        }
      }
      totalCount
      pageInfo {
        endCursor
        hasNextPage
      }
    }
  }
`)
```

```ts
// Skisse — IKKE for build, kun for reviewer
export function useGetApplikasjoner() {
  const { filter, orderBy, first } = useGetApplikasjonerState()
  const variables = { filter, orderBy, first }

  return useDataListQuery<GetApplikasjonerQuery, typeof variables, ApplikasjonNode>({
    query: GET_APPLIKASJONER,
    variables,
    selectConnection: (data) => data?.applikasjoner,
  })
}
```

Merk: i motsetning til `useGetEmner` injiseres **ikke** `eierOrganisasjonskode` her — synlighet er server-side per krav K11/K12. Lokale admin-er kan velge å filtrere på `organisasjonskoder: [...]` for å snevre listen til én av sine organisasjoner, men det er en *valgfri innsnevring*, ikke en sikkerhetssjekk.

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-APP-API-001 — alle fire regler i `listevisning_og_sok.feature` (K1 liste, K2 søk/filter, K11/K12 synlighet, ansvarlig-relasjon). Sketchens kolonner (Navn, Beskrivelse, Miljøer, Ansvarlig, Organisasjon, Status, antall tilganger) er én-til-én med `Applikasjon`-feltene.
- **Form:** Relay Cursor Connection per `fs-sikt-no-producer-schema-design §Vi følger Cursor Connections Specification for paginering` og `fs-sikt-no-producer-best-practice §Paginering` (regelen om paginering ved >10 elementer er klart oppfylt — kravet sier 50 per side).
- **`Node`-implementering:** `Applikasjon` har `id: ID!` og implementerer `Node` per `fs-sikt-no-producer-schema-design §Vi følger Global Object Identification-spesifikasjonen` — entiteten vil bli referert ofte (detalj, mutations, cache i Apollo).
- **Nullability:** Alle felt utenom `id` er nullable per `fs-sikt-no-producer-best-practice §Nullability`.
- **Navngivning:** norske domenetermer (`navn`, `beskrivelse`, `miljoer`, `ansvarlig`, `organisasjon`, `status`, `antallTilganger`), lowerCamelCase, ÆØÅ → AOA (`miljoer` ikke `miljøer`), ingen forkortelser — per `fs-sikt-no-producer-naming §Bruk norsk for domenebegreper`, `§lowerCamelCase`, `§Unngå forkortelser`.
- **Synlighet håndheves server-side, ikke via filter-input:** per `fs-sikt-no-producer-schema-design §Vi innfører gjerne egne felt og typer for semantisk nyttige data-uttrekk` — feltet `applikasjoner` er semantisk "applikasjoner den autentiserte brukeren har lov til å se", på samme måte som `mineSoknader` i ref-eksempelet. Frontend skal ikke kunne sende et filter som *utvider* synligheten.
- **`Ansvarlig` som union, ikke som separat felt:** lar én radkolonne i sketchen vise enten en feide-bruker eller en feide-gruppe. Union er rett valg når medlemstypene er reelt forskjellige typer.
- **`QueryApplikasjonerOrderByField` som enum med ett medlem:** matcher mønsteret i `QueryEmnerOrderByField` (sjekket i kall-stedet `useGetEmner.tsx`). Enum kan utvides bakoverkompatibelt per `fs-sikt-no-producer-schema-design §Endringer i API bør ikke ødelegge for klienter`.
- **Alternativer vurdert:**
  - *Egen `mineApplikasjoner`-feltet (semantisk variant) i tillegg til det generelle `applikasjoner`-feltet.* Forkastet for Iter 2: én query med server-side synlighetsregel dekker alle tre aktørene. Kan legges til som tilleggsfelt senere uten breaking change.
  - *`Ansvarlig` som interface (`Ansvarlig { id: ID! }`).* Forkastet: medlemmene (FeideBruker, FeideGruppe) deler ikke nok felt til at interface gir mening.
  - *Inkludere `tilgangskoder: [String!]` i filter nå.* Forkastet: er `@could` i Iter 2.
  - *Inkludere full `Tilgang`-liste på `Applikasjon`.* Forkastet: detaljsidens ansvar; `antallTilganger: Int` er nok for listevisningen.

### Åpne spørsmål

- [ ] **`FeideGruppe`-type:** finnes denne i SuperGraf-skjemaet allerede? Søk i `schema.graphql` viser kun `FeideBruker`-relaterte typer. Hvis ikke: backend må enten legge den til, eller `Ansvarlig`-union må starte som *kun* `FeideBruker` i v1, og utvides når feide-gruppe-kravet (`@could`) flyttes til `@must`. **Hvem svarer:** backend-agenten / schema-eier.
- [ ] **`Miljo`-enum:** finnes en kanonisk enum for miljøer i FS-økosystemet allerede (under et annet navn)? Hvis ja: gjenbruk den. **Hvem svarer:** backend-agenten / schema-eier.

## Implementation Tasks

### Task #1: Sett opp domene-mappe, ruter og detaljside-stub

**Priority:** High
**Size:** S
**Dependencies:** None
**Addresses Requirements:** BRU-APP-API-001 (struktur)

**Acceptance Criteria:**

- [ ] `src/domains/tilgangsstyring/features/ApplikasjonerOverview/` opprettet (tom mappe-struktur med `components/`, `hooks/`).
- [ ] `src/app/tilgangsstyring/applikasjoner/page.tsx` rendrer `<ApplikasjonerOverview />`-placeholder (klient-komponent).
- [ ] `src/app/tilgangsstyring/applikasjoner/layout.tsx` har `PageHeaderWrapper` med breadcrumb-tittel fra i18n.
- [ ] `src/app/tilgangsstyring/applikasjoner/[applikasjonid]/page.tsx` rendrer "Kommer snart"-placeholder.
- [ ] `src/app/tilgangsstyring/applikasjoner/[applikasjonid]/layout.tsx` med breadcrumb.
- [ ] `npm run generate:routes` genererer typed routes uten feil.
- [ ] `npm run lint` passerer.

**Implementation Notes:**

- Speil filstrukturen i `src/app/tilgangsstyring/maskinbrukere/` (route-layoutet er identisk).
- Detaljside-stub er bevisst tom — full implementasjon i senere plan.

### Task #2: Implementer `useGetApplikasjonerState`-hooken

**Priority:** High
**Size:** S
**Dependencies:** Task #1
**Addresses Requirements:** BRU-APP-API-001 (URL-state for filter, orderBy, paginering)

**Acceptance Criteria:**

- [ ] `useGetApplikasjonerState.tsx` wrapper `useDataListState` med init-filter (`navnContains: ''`, `organisasjonskoder: []`, `statuser: []`, `miljoer: []`), init-orderBy (`{ direction: ASC, orderByField: NAVN }`), `initFirst: 50`.
- [ ] **Ikke** inkluder `eierOrganisasjonskode` i URL-state (avvik fra `useGetEmnerState` er bevisst — server-side synlighet).
- [ ] Hooken returnerer samme API som `useGetEmnerState` (filter, orderBy, first, onReset, isModified osv.).
- [ ] Type-import fra `@/__generated__/graphql` — *blokkert til schema er på plass*; bruk midlertidige lokale typer i mellomtiden hvis nødvendig.

**Implementation Notes:**

- Referanse: [`useGetEmnerState.tsx`](../../src/domains/utdanning/features/EmnerOverview/hooks/useGetEmnerState.tsx).
- Hvis backend ikke har levert typer ved Task-start: midlertidig stub-type lokalt, byttes ut når codegen kjører.

### Task #3: Implementer `useGetApplikasjoner`-hooken med `GET_APPLIKASJONER`-query

**Priority:** High
**Size:** M
**Dependencies:** Task #2; **blokkeres av** backend-leveranse av `Applikasjon`-typene (se hand-off).
**Addresses Requirements:** BRU-APP-API-001 — datafetching for K1, K2, K11, K12

**Acceptance Criteria:**

- [ ] `GET_APPLIKASJONER`-query (se GraphQL-section Op #1 Lag B) definert med `gql(/* GraphQL */ \`...\`)` fra `@/__generated__`.
- [ ] `useGetApplikasjoner` wrapper `useDataListQuery` med `selectConnection: (data) => data?.applikasjoner`.
- [ ] **Ingen** `eierOrganisasjonskode` injiseres i variables.
- [ ] `npm run compile` (codegen) passerer.
- [ ] `npm run test:typecheck` passerer.

**Implementation Notes:**

- Referanse: [`useGetEmner.tsx`](../../src/domains/utdanning/features/EmnerOverview/hooks/useGetEmner.tsx).
- Hvis backend ikke har levert typer: vurder MSW-mock som mellom-løsning (se Risk #2). Hvis MSW velges: ekskluder denne fila fra `codegen.ts` documents-globben midlertidig (samme mønster som var brukt for det tidligere `/applications`-eksperimentet).

### Task #4: Implementer `ApplikasjonerFilter`-komponenten

**Priority:** High
**Size:** M
**Dependencies:** Task #2, Task #3
**Addresses Requirements:** BRU-APP-API-001 K2 (søk og filtrering)

**Acceptance Criteria:**

- [ ] Søkefelt for `navnContains` (tekst-input med debounce — match Emner-mønster).
- [ ] Filter for `organisasjonskoder: [String!]` (multi-select).
- [ ] Filter for `statuser: [ApplikasjonStatus!]` (multi-select med AKTIV/DEAKTIVERT-options).
- [ ] Filter for `miljoer: [Miljo!]` (multi-select).
- [ ] `renderAsChips`-modus støttes (for å vise aktive filtre som chips over result list).
- [ ] `FilterReset` integrert i sidebar-header via `onReset` fra state-hooken.
- [ ] **Ikke** legg til `tilgangskoder`-filter (`@could` — utsatt).
- [ ] A11y-test (`ApplikasjonerFilter.a11y.test.tsx`) — alle filter-controls har tilgjengelige labels og fungerer med skjermleser.

**Implementation Notes:**

- Referanse: [`EmnerFilter.tsx`](../../src/domains/utdanning/features/EmnerOverview/components/EmnerFilter.tsx).
- Organisasjonsvalg: bruk eksisterende org-picker fra utdanning-domenet hvis den finnes, eller introduser en felles komponent under `src/components/` hvis ikke.

### Task #5: Implementer `ApplikasjonerOrderBy`-komponenten

**Priority:** High
**Size:** S
**Dependencies:** Task #2
**Addresses Requirements:** BRU-APP-API-001 K1 (sorteringsretning for navn)

**Acceptance Criteria:**

- [ ] Sort-toggle for NAVN ASC/DESC (eneste sorteringsfelt i Iter 2).
- [ ] Default: NAVN ASC (per krav-fil linje 19).
- [ ] State drives av `useGetApplikasjonerState`.
- [ ] A11y-test.

**Implementation Notes:**

- Referanse: [`EmnerOrderBy.tsx`](../../src/domains/utdanning/features/EmnerOverview/components/EmnerOrderBy.tsx).
- Bruk `OrderByButton`-komponenten fra `src/common/components/list-enhancers/OrderByButton/`.

### Task #6: Implementer `ApplikasjonerResultList`-komponenten

**Priority:** High
**Size:** L
**Dependencies:** Task #3, Task #4, Task #5
**Addresses Requirements:** BRU-APP-API-001 K1 (radvisning, paginering, navigasjon til detalj)

**Acceptance Criteria:**

- [ ] `NavigationList` med alle anbefalte props: `headerText`, `emptyText`, `emptyTextSuggestion`, `loading`, `loadingMore`, `message` (error), `loadedCount`, `totalCount`, `hasNextPage`, `onLoadMore`, `orderByElement`, `filterElement` (chips-modus).
- [ ] Hver `NavigationListItem` har `href={{ pathname: '/tilgangsstyring/applikasjoner/[applikasjonid]', params: { applikasjonid: applikasjon.id } }}` — **ikke** `onClick + router.push`.
- [ ] Rad-rendering matcher sketchen: Navn (m/ miljø-tags fra `miljoer`), Beskrivelse, Organisasjon (`organisasjon.navnAlleSprak.nb`), Ansvarlig (discriminert på `__typename`), antall tilganger (`{antallTilganger} tilganger`), Status (`TagStatus` AKTIV/DEAKTIVERT).
- [ ] `onLoadMore` inkrementerer `first` med 50.
- [ ] Tom-tilstand med `emptyTextSuggestion` (e.g. "Prøv å justere filtre eller søk").
- [ ] Error-tilstand via `parseBasicError` + `t('errorText')`.
- [ ] A11y-test — radnavigasjon med tastatur, korrekt ARIA-rolle, screenreader-pauser mellom celler.

**Implementation Notes:**

- Referanse: [`EmnerResultList.tsx`](../../src/domains/utdanning/features/EmnerOverview/components/EmnerResultList.tsx).
- Bruk `TagStatus` fra `@sikt/sds-tag` for status (samme som POC-en bruker; design-system-godkjent).
- Bruk `TagWithIcon` for miljø-tags hvis det matcher sketchen visuelt; eller plain `Tag` hvis enklere.

### Task #7: Implementer `ApplikasjonerOverview`-side-komponenten

**Priority:** High
**Size:** S
**Dependencies:** Task #4, Task #5, Task #6
**Addresses Requirements:** BRU-APP-API-001 (komplett listevisning)

**Acceptance Criteria:**

- [ ] `ApplikasjonerOverview.tsx` wrapper `ListPageLayout` med `title={t('title')}`.
- [ ] `ListPageSidebar` med `headingText`, `headerActions={<FilterReset />}`, og `<ApplikasjonerFilter />` som content.
- [ ] `ListPageContent` med `<ApplikasjonerResultList />`.
- [ ] **Ingen** `ListPageActionbar` i Iter 2 (Opprett-knapp utsatt til Iter 3).
- [ ] Bruker `useMineLaresteder` for organisasjonskontekst — men *kun* for å avgjøre om vi skal vise `<NoOrgError />` eller listen; ikke for å filtrere queryen.
- [ ] A11y-test for hele siden.

**Implementation Notes:**

- Referanse: [`EmnerOverview.tsx`](../../src/domains/utdanning/features/EmnerOverview/EmnerOverview.tsx).
- Avklar med design om `<NoOrgError />` er rett UI når brukeren ikke har noen organisasjon — alternativt kan super-admin uten organisasjon fortsatt se "alle applikasjoner uten organisasjon"-listen (per K11 scenario 3). Om dette: la `NoOrgError` ligge for nå; iterér på det hvis super-admin-flowen viser at det er feil.

### Task #8: Legg til meny-oppføring og user-actions

**Priority:** High
**Size:** S
**Dependencies:** Task #1
**Addresses Requirements:** BRU-APP-API-001 (navigering inn til siden)

**Acceptance Criteria:**

- [ ] `src/common/types/userActions.ts` utvidet med `SE_APPLIKASJONER` (og evt. `MODIFISERE_APPLIKASJONER`).
- [ ] `Menu.tsx` får ny sub-meny-oppføring under `/tilgangsstyring`: "Applikasjoner" → `/tilgangsstyring/applikasjoner`, gated på `SE_APPLIKASJONER`.
- [ ] Avklar med backend: hvilke roller (lokal applikasjonsadministrator, super-applikasjonsadministrator) gir `SE_APPLIKASJONER`? Antagelig nytt `handlinger`-felt på `minBruker`-resolveren.
- [ ] Eksisterende `/tilgangsstyring/maskinbrukere`-oppføring **berøres ikke** i denne planen.
- [ ] A11y-test for Menu.tsx oppdatert hvis eksisterende test brytes.

**Implementation Notes:**

- Trenger koordinering med backend-agenten for hvilken backend-enum-verdi som mappes til `SE_APPLIKASJONER` i `useAdmissioUserActions`.

### Task #9: i18n-nøkler

**Priority:** Medium
**Size:** S
**Dependencies:** Task #4, Task #6, Task #7 (helst etter at strenger er identifisert)
**Addresses Requirements:** Prosjektkrav (norsk UI-språk, `/externalize-i18n`-mønsteret)

**Acceptance Criteria:**

- [ ] Alle hardkodede norske strenger i nye komponenter er flyttet til `src/messages/nb/tilgangsstyring.json` (eller tilsvarende namespace).
- [ ] Keys følger eksisterende mønster (`tilgangsstyring.ApplikasjonerOverview.title`, `tilgangsstyring.ApplikasjonerResultList.headerText`, osv.).
- [ ] Ingen `'use client'`-komponent har hardkodede strenger (kjør `/externalize-i18n` på hver fil etter Task #6/#7).

**Implementation Notes:**

- Foretrukket flyt: skriv komponentene med inline-strenger i Task #4-7, deretter kjør `/externalize-i18n` for batched ekstrahering.

### Task #10: A11y-tester for alle nye komponenter

**Priority:** High
**Size:** M
**Dependencies:** Task #4, Task #5, Task #6, Task #7
**Addresses Requirements:** Prosjektkrav (CLAUDE.md: "every component MUST have ComponentName.a11y.test.tsx")

**Acceptance Criteria:**

- [ ] `ApplikasjonerOverview.a11y.test.tsx` — passerer `npm run test:a11y`.
- [ ] `ApplikasjonerFilter.a11y.test.tsx`.
- [ ] `ApplikasjonerOrderBy.a11y.test.tsx`.
- [ ] `ApplikasjonerResultList.a11y.test.tsx`.
- [ ] Hver test bruker `jest-axe` og dekker minst tom/loading/data/error-tilstander.
- [ ] Detaljside-stub-en (Task #1) har også a11y-test.

**Implementation Notes:**

- Referanse: a11y-test for `EmnerOverview` hvis den finnes, eller `ListPageLayout.a11y.test.tsx` for mønsteret.
- MSW eller Apollo `MockedProvider` brukes for å levere mock-data; følg eksisterende konvensjon i prosjektet.

## Risk Assessment

### Technical Risks

- **Risk #1: Backend leverer ikke `Applikasjon`-typer i tide.**
  - **Mitigation:** Hand-off til backend-agenten åpnes umiddelbart etter at planen er publisert. Hvis schema-arbeidet glir: bygg Task #2, #4, #5, #6 mot MSW-mocks med samme query-form som planlagt; ekskluder de mock-only hooks fra codegen (samme mønster som tidligere `/applications`-eksperiment). Risiko: mock-shape divergerer fra hva backend leverer; mitigeres ved å holde GraphQL-section i denne planen som *kontrakt*.
- **Risk #2: `FeideGruppe`-type finnes ikke — `Ansvarlig`-union må starte som kun `FeideBruker`.**
  - **Mitigation:** Ansvarlig-feltet i query og rad-rendering er allerede `__typename`-discriminert, så å legge til `FeideGruppe` senere er bakoverkompatibelt. Hvis backend bekrefter at typen mangler: dropp `FeideGruppe`-feltet fra unionen i v1, oppdater GraphQL-section, og oppdater Task #6 så `ansvarlig`-rendring kun håndterer `FeideBruker`.
- **Risk #3: `Miljo`-enum kolliderer med eksisterende kanonisk enum.**
  - **Mitigation:** Backend-agenten sjekker schema-en og velger navn ved schema-design. Frontend-koden refererer kun til den genererte typen, så et navnebytte i denne planen er en query-fil-endring, ikke en arkitektur-endring.
- **Risk #4: `useMineLaresteder` passer ikke for super-applikasjonsadministratorer.**
  - **Mitigation:** Hooken returnerer `effectiveOrganisasjonskode`. For en super-admin uten organisasjon kan dette være `null` — som i dag trigger `<NoOrgError />`. Det vil hindre super-admin fra å se listen. *Det må verifiseres i Task #7* — hvis dette skjer, lag en domene-spesifikk `NoOrgError`-variant som checker user-actions og lar super-admin igjennom.
- **Risk #5: To agenter jobber på samme initiativ.**
  - **Mitigation:** `fs-admin-mats` har en bredere analyse (Iter 2+3) i coord-repoet. Plan-eier (denne agenten) tar listevisningen; detaljside-flyten kan delegeres til `fs-admin-mats` eller koordineres som split. Avklaring med bruker før Task-start (se "Sketch-mapping" i analyse-dokumentet sin Open Questions).

### Assumptions (Planning Defaults Documented)

Disse antagelsene er kommet til av plan-defaults. Hvis design/produkt korrigerer, krever det Task-justeringer i samme størrelsesorden.

- **A1:** Miljø-filter er en del av Iter 2 (sketch wins).
- **A2:** "Antall tilganger" er en radkolonne i listevisningen (sketch wins).
- **A3:** "+ Opprett"-knapp er skjult i Iter 2.
- **A4:** `@could`-krav (tilgang-filter, feide-gruppe som ansvarlig) er utsatt.
- **A5:** Domeneplassering er `src/domains/tilgangsstyring/`.
- **A6:** Rute er `/tilgangsstyring/applikasjoner` (parallelt med eksisterende POC-rute).
- **A7:** Unleash-flagging gjenbruker `tilgangsstyring-meny` til POC-en er fjernet (alternativ: ny `applikasjoner-meny`-flag).

### Testing Requirements

- A11y-tester for **alle** nye komponenter (Task #10).
- Unit-tester for `useGetApplikasjonerState`-defaults og reset-oppførsel.
- Integrasjonstest (manuell eller via Storybook) for filter-kombinasjoner: navn + organisasjon + status + miljø, alle kombinert med søk.
- Test for browser-back-button: filter aktivert → klikk inn i detalj-stub → back → samme filter-state.
- Test for direct-URL: kopier filtret URL → åpne i ny fane → samme state.

## Success Criteria

- [ ] Alle akseptansekriterier for Task #1–#10 møtt.
- [ ] `npm test`, `npm run test:a11y`, `npm run test:typecheck`, `npm run lint`, `npm run formatcheck` passerer.
- [ ] `npm run compile` (codegen) passerer mot ekte schema (ikke mock-fallback).
- [ ] Visuell verifikasjon mot sketchen: sidebar-filter, søk, "X applikasjoner i listen", rader med chevron, "Last inn flere"-knapp.
- [ ] Manuell verifikasjon: K1 (lik liste, sortering), K2 (alle filter + søk), K11 (lokal admin ser kun sine + applikasjoner med tilganger inn til seg), K12 (super-admin ser alt), ansvarlig-relasjon-synlighet.
- [ ] Maskinbruker-POC-en er **ikke** rørt (verifisert ved git diff).

## Requirements Traceability

| Requirement ID                                  | Requirement Summary                                                                          | Addressed by Task(s)               | Status  |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------- | ---------------------------------- | ------- |
| BRU-APP-API-001 — K1 (liste, sortering, paginering) | Vise sortert liste av applikasjoner med 50 om gangen, totalt antall, navigering til detalj | Task #3, #5, #6, #7                | Planned |
| BRU-APP-API-001 — K2 (søk og filter)            | Fritekst-søk på navn, filter på org/status/miljø; tilgang-filter `@could` utsatt              | Task #2, #3, #4                    | Planned |
| BRU-APP-API-001 — K11/K12 (synlighet)           | Server-side håndhevelse via prinsipal                                                        | Task #3 + backend-hand-off         | Planned |
| BRU-APP-API-001 — Ansvarlig-relasjon (synlighet) | Brukere som er ansvarlig ser applikasjonen; feide-gruppe `@could` utsatt                    | Task #3 + backend-hand-off         | Planned |
| BRU-APP-API-002 til -006 (detaljside-flyt)      | **Ute av skop** — egen plan                                                                  | —                                  | Deferred |
| Prosjektkrav: a11y-tester                       | Hver komponent har `.a11y.test.tsx`                                                          | Task #10                           | Planned |
| Prosjektkrav: i18n via next-intl                | Norske strenger ekstrahert til `src/messages/nb/`                                            | Task #9                            | Planned |