# Plan: Applikasjoner (Iter 2 + Iter 3)

> **Følger fra:** [`analysis-applikasjoner.md`](analysis-applikasjoner.md). Scope: initiativ [sikt-no/fs#31](https://github.com/sikt-no/fs/issues/31) → sub-issues [#434](https://github.com/sikt-no/fs/issues/434) (Iter 2) + [#435](https://github.com/sikt-no/fs/issues/435) (Iter 3) + `@could` filter-på-tilgang.
>
> **Decisions locked in plan-fase (2026-05-18):**
> - Single combined plan, to faser (Iter 2 → Iter 3).
> - Rute: `/tilgangsstyring/applikasjoner` + `/tilgangsstyring/applikasjoner/[id]`.
> - Passord: rå basic-auth-streng i mutation-respons (én gang).
> - IdP-vises kun i detaljside (badge i topbar), ikke i listen.
> - Synlighet løses server-side (UI sender ingen `organisasjonskode`-parameter til `applikasjoner`-query).
> - Maskinbruker-POC fjernes **etter** Iter 3 er i prod.
> - `@could` filter-på-tilgang: **inkludert** i Iter 2.
> - `@could` feide-gruppe-ansvarlig: **utsatt** til Iter 4.

## Proposed Solution

### Architecture Approach

Master-detail-modul under `support`-domenet, parallell med eksisterende maskinbruker-POC. Bygd fra bunnen mot ny `Applikasjon`-type i SuperGrafen (ingen gjenbruk av maskinbruker-queries, jf. eksplisitt krav i #31). To Next.js-ruter:

- `/tilgangsstyring/applikasjoner` — `ApplikasjonerOverview` (`ListPageLayout` + URL-state-synket filter/sort/paginering).
- `/tilgangsstyring/applikasjoner/[id]` — `ApplikasjonDetails` (`DetailPageLayout` + tabs).

Mønster: cross-pattern `list-page-layout` ↔ `detail-page-layout` per `.claude/skills/bat-fs-admin-patterns/cross-patterns/list-page-layout--detail-page-layout.md`. Referanseimplementasjon: `EmnerOverview` ↔ `EmneDetails` i `utdanning`-domenet.

To-fase-leveransen:

- **Iter 2 (#434):** Listevisning + detalj-shell + tab "Tilganger" (lese) + tab "Detaljer"-handlinger (ansvarlig, beskrivelse, passordbytte). Leverer en lese- og lett-redigerings-flyt.
- **Iter 3 (#435):** Opprette applikasjon (modal med idP-valg og ekstern-ID-verifisering), tildele/fjerne tilgang på tabben, deaktivere/reaktivere som handling i topbar.
- **Etter Iter 3 i prod:** Cleanup-Task fjerner maskinbruker-POC-rutene, komponentene og oversettelses-nøklene.

### Key Technical Decisions

1. **Bruk `useDataListState` + `useDataListQuery` for listen.**
   - Hvorfor: URL-synket state, browser-back bevarer filter/sort/paginering automatisk, ingen klient-side Fuse.js. Eksplisitt dokumentert som riktig mønster i `.claude/skills/bat-fs-admin-patterns/known-patterns/list-page-layout-pattern/anti-patterns.md` (POC-en bruker anti-patternet — vi *kopierer ikke*).
   - Alternativ vurdert: `useState` + `useQuery` med `first: 1000` (POC-mønsteret) — forkastet, dokumentert anti-pattern.

2. **Egen rot-query `tilgangerForApplikasjon` for sub-listen, ikke nestet under `applikasjon(id)`.**
   - Hvorfor: Tilgangslisten har reelle server-side filtre (miljø, tilgangskode) og paginering. Frittstående query gjør at Apollo cache kan oppdatere `Tilgang:<id>`-noder etter tildel/fjern uten å skrive om hele `Applikasjon`-cache-entry.
   - Alternativ vurdert: Fragment-only sub-list (samme query som detaljsiden) — forkastet, krever klient-side filtrering (dokumentert anti-pattern i detail-page anti-patterns).

3. **Raw passord i mutation-respons (Op-M3), én gang, ingen Apollo-cache.**
   - Hvorfor: Brukeren bestemte 2026-05-18. UI viser i modal med skjult/vis-toggle og copy-knapp, og kaster verdien ved dialog-lukking. Schema-doc-string markerer "må ikke logges/caches".
   - Alternativ vurdert: Signert URL + ekstra GET — forkastet etter brukerbeslutning. Hvis sikkerhets-policy endrer seg, legg til `settPassordPaApplikasjonV2` (versjonering på feltnivå).

4. **Server-side synlighet, ikke `effectiveOrganisasjonskode`-parameter.**
   - Hvorfor: Synlighetsregelen "ser også applikasjoner med tilganger i mine organisasjoner" kan ikke regnes ut klient-side uten å lekke data. Brukerbeslutning 2026-05-18: backend resolveren håndterer alle tre synlighetsnivåer (super-admin / admin-for-org / ansvarlig).
   - Alternativ vurdert: Union av to klient-queries — forkastet, kompleks og lekker data.

5. **`ApplikasjonAnsvarlig`-union forberedt for feide-gruppe i Iter 4, men kun `FeideBruker` i denne planen.**
   - Hvorfor: Union-form gjør at Iter 4-utvidelsen er additive change uten å bryte klienter. `@could`-scenarier for feide-gruppe utsettes per brukerbeslutning.

6. **Beholde POC-rutene under `/tilgangsstyring/maskinbrukere` til Iter 3 er i prod.**
   - Hvorfor: Iter 2 alene dekker ikke alt POC-en gjør (ingen opprettelse, ingen deaktivering). Brukerbeslutning 2026-05-18: cleanup-Task etter Iter 3.

### File Changes Overview

**Ny kode (Iter 2 + 3):**

- `src/app/tilgangsstyring/applikasjoner/page.tsx` — wrapper for `ApplikasjonerOverview`.
- `src/app/tilgangsstyring/applikasjoner/[id]/page.tsx` — wrapper for `ApplikasjonDetails`.
- `src/domains/support/features/ApplikasjonerOverview/`
  - `ApplikasjonerOverview.tsx`
  - `queries.ts`
  - `hooks/useGetApplikasjonerState.tsx`
  - `hooks/useGetApplikasjoner.ts`
  - `components/ApplikasjonerFilter/` (Navn, Organisasjon, Tilgang, Status)
  - `components/ApplikasjonerOrderBy/ApplikasjonerOrderBy.tsx`
  - `components/ApplikasjonerResultList/ApplikasjonerResultList.tsx`
  - `__tests__/ApplikasjonerOverview.a11y.test.tsx`
- `src/domains/support/features/ApplikasjonDetails/`
  - `ApplikasjonDetails.tsx`
  - `queries.ts`
  - `hooks/useGetApplikasjon.ts`
  - `components/ApplikasjonInformation/` (topbar — navn, idP-badge, status-badge, org)
  - `components/GrunninfoTab/` (beskrivelse + sporing)
  - `components/TilgangerTab/`
    - `TilgangerTab.tsx`
    - `hooks/useGetTilgangerForApplikasjon.ts`
    - `hooks/useGetTilgangerForApplikasjonState.tsx`
    - `components/TilgangerFilter/`
    - `components/TilgangerOrderBy/`
    - `components/TilgangerResultList/`
    - `components/TildelTilgangModal/` (Iter 3)
    - `components/FjernTilgangerBekreftelse/` (Iter 3)
  - `components/AnsvarligEditor/`
  - `components/BeskrivelseEditor/`
  - `components/PassordbytteModal/`
  - `components/DeaktiveringActions/` (Iter 3 — deaktiver + reaktiver)
  - `__tests__/ApplikasjonDetails.a11y.test.tsx`
- `src/domains/support/features/OpprettApplikasjon/` (Iter 3)
  - `OpprettApplikasjonButton.tsx` (i topbar over listen)
  - `OpprettApplikasjonModal.tsx`
  - `queries.ts`
  - `hooks/useOpprettApplikasjon.ts`
  - `hooks/useVerifiserEksternId.ts`
  - `hooks/useMineOrganisasjonerForApplikasjonsadmin.ts`
- `src/common/messages/nb/domain/ApplikasjonerOverview.json`
- `src/common/messages/nb/domain/ApplikasjonDetails.json`
- `src/common/messages/nb/domain/ApplikasjonInformation.json`
- `src/common/messages/nb/domain/TilgangerTab.json`
- `src/common/messages/nb/domain/OpprettApplikasjon.json`

**Endrede filer:**

- `src/common/messages/nb/features.json` — ny nøkkel for "Applikasjoner" som modul.
- `src/common/messages/nb/search.json` — ny kommando-palett-oppføring "Gå til applikasjoner".
- Codegen: `npm run compile` etter at SuperGrafen-schemaet lander.

**Fjernes etter Iter 3 i prod (egen cleanup-Task):**

- `src/app/tilgangsstyring/maskinbrukere/` (hele mappen).
- `src/domains/support/features/Maskinbrukere/` (hele).
- `src/domains/support/features/MaskinBruker/` (hele).
- Maskinbruker-nøklene i `src/common/messages/nb/support.json`, `features.json`, `search.json`.

## GraphQL-endringer

> **Premiss:** konservativ — minst mulig schema-endring som dekker Iter 2 + Iter 3 must-have + `@could` filter-på-tilgang. Skiller `Applikasjon` som ny `Node`-type i stedet for å utvide eksisterende `Maskinbruker`, per eksplisitt krav i #31 om at maskinbruker-queries ikke skal gjenbrukes.
> **Domeneterm:** `Applikasjon` (besluttet 2026-05-18; tidligere `Maskinbruker` i POC-en — ny term konsekvent gjennom hele seksjonen).
> **Følger fra:** [`analysis-applikasjoner.md`](analysis-applikasjoner.md) — gap-listen i *External dependencies* og *Cross-agent candidates*.

### Sammendrag

- 7 nye queries (Op-Q1–Q7).
- 8 nye mutations (Op-M1–M8).
- 5 nye/endrede typer på toppnivå (`Applikasjon`, `ApplikasjonerConnection`, `Tilgang`, `TilgangerForApplikasjonConnection`, `Identitetsleverandor`-enum) + 1 `ApplikasjonStatus`-enum + 8 mutation-payloads og 8 error-unions.
- 3 åpne spørsmål (se nederst).

### Felles typer (refereres fra flere operasjoner)

```graphql
"""Applikasjon med tilgang til FS-data. Erstatter dagens Maskinbruker for POC-en (#31)."""
type Applikasjon implements Node {
  id: ID!
  """Globalt unikt visningsnavn hentet fra idP-en ved opprettelse."""
  navn: String!
  beskrivelse: String
  identitetsleverandor: Identitetsleverandor!
  """ID slik den er registrert hos identitetsleverandøren. Null for FS-applikasjoner."""
  eksternId: String
  status: ApplikasjonStatus!
  organisasjon: Organisasjon
  """Miljøer applikasjonen er aktiv i (et miljø blir aktivt ved første tilgangstildeling)."""
  aktiveMiljoer: [Miljo!]!
  ansvarlig: ApplikasjonAnsvarlig
  opprettetAv: String
  opprettetTidspunkt: DateTime
  endretAv: String
  endretTidspunkt: DateTime
}

enum Identitetsleverandor {
  FEIDE
  MASKINPORTEN
  """Utfaset. Eksisterende applikasjoner består, men kan ikke opprettes."""
  FS
}

enum ApplikasjonStatus {
  AKTIV
  DEAKTIVERT
}

"""
Ansvarlig for en applikasjon. I dag kun feide-bruker.
Union forberedt for `@could` feide-gruppe i Iter 4 (åpent spørsmål #2).
"""
union ApplikasjonAnsvarlig = FeideBruker
# Senere: union ApplikasjonAnsvarlig = FeideBruker | FeideGruppe

"""En tilgang tildelt en applikasjon i et gitt miljø."""
type Tilgang implements Node {
  id: ID!
  applikasjon: Applikasjon!
  miljo: Miljo!
  tilgangskode: String!
  beskrivelse: String
  tildeltAv: String
  tildeltTidspunkt: DateTime
}
```

> **Konvensjoner sitert:**
> - `Applikasjon` og `Tilgang` implementerer `Node` per `fs-sikt-no-producer-schema-design.md §Vi følger Global Object Identification-spesifikasjonen`.
> - Felt-navn lowerCamelCase, norsk for domene, verb-prefiks på fremtidige booleans per `fs-sikt-no-producer-naming.md`.
> - Nullability per `fs-sikt-no-producer-best-practice.md §Nullability` (`beskrivelse`, `organisasjon`, `ansvarlig`, `eksternId` er nullable).
> - `Identitetsleverandor` som enum (fast verdimengde, vises i UI som badge).

### Operasjoner

#### Op-Q1: `applikasjoner` — paginert liste med filter/sortering

**Dekker krav:** `BRU-APP-API-001`. **Implementeres av:** Task #L1.

```graphql
extend type Query {
  """
  Paginert liste over applikasjoner brukeren har synlighet til.
  Synlighet løses server-side basert på rolle:
    - super-applikasjonsadministrator: alle (inkl. uten organisasjon)
    - applikasjonsadministrator for org X: applikasjoner i X + applikasjoner i andre org
      som har tildelte tilganger inn i X
    - bruker som er registrert ansvarlig: applikasjoner de er ansvarlig for
  Klienten sender ikke organisasjonskode — synlighet er implisitt.
  """
  applikasjoner(
    filter: ApplikasjonerFilterInput
    orderBy: ApplikasjonerOrderByInput
    first: Int, after: String, last: Int, before: String
  ): ApplikasjonerConnection
}

input ApplikasjonerFilterInput {
  navnContains: String
  organisasjonskoder: [String!]
  """@could fra Iter 2: vis bare applikasjoner som har minst én av disse tilgangskodene."""
  harTilgangskoder: [String!]
  statuser: [ApplikasjonStatus!]
}

input ApplikasjonerOrderByInput {
  orderByField: ApplikasjonerOrderByField!
  direction: OrderDirection!
}

enum ApplikasjonerOrderByField { NAVN }

type ApplikasjonerConnection {
  edges: [ApplikasjonerConnectionEdge]
  nodes: [Applikasjon]
  pageInfo: PageInfo
  totalCount: Int
}

type ApplikasjonerConnectionEdge {
  cursor: String
  node: Applikasjon
}
```

```ts
// src/domains/support/features/ApplikasjonerOverview/queries.ts (forslag)
export const GET_APPLIKASJONER = gql(/* GraphQL */ `
  query GetApplikasjoner(
    $filter: ApplikasjonerFilterInput
    $orderBy: ApplikasjonerOrderByInput
    $first: Int
  ) {
    applikasjoner(filter: $filter, orderBy: $orderBy, first: $first) {
      totalCount
      pageInfo { hasNextPage endCursor }
      nodes {
        id navn beskrivelse status identitetsleverandor
        aktiveMiljoer { id kode }
        organisasjon { organisasjonskode navn }
        ansvarlig { ... on FeideBruker { id brukernavn } }
      }
    }
  }
`)
```

```ts
// Skisse — IKKE for build. Følger EmnerOverview-mønsteret.
export function useGetApplikasjoner() {
  const { filter, orderBy, first } = useGetApplikasjonerState()
  return useDataListQuery({
    query: GET_APPLIKASJONER,
    variables: { filter, orderBy, first },
    selectConnection: (data) => data?.applikasjoner,
  })
}
```

**Begrunnelse:** Dekker `BRU-APP-API-001`. Relay cursor connection per `fs-sikt-no-producer-schema-design.md §Cursor Connections`. Default page size 50 settes i fs-admin (`useDataListState`), ikke i schema per `fs-sikt-no-producer-best-practice.md §Paginering`. `navnContains`-stilen matcher eksisterende `BrukereBrukergruppeFilterInput`. Forkastet alternativ: `identitetsleverandor`-filter (kravet sier eksplisitt at idP ikke er filter).

---

#### Op-Q2: `applikasjon(id)` — enkelt-applikasjon

**Dekker krav:** `BRU-APP-API-002`. **Implementeres av:** Task #D1.

```graphql
extend type Query {
  """Hent én applikasjon. Synlighet styres av samme regler som i `applikasjoner`."""
  applikasjon(id: ID!): Applikasjon
}
```

```ts
export const GET_APPLIKASJON = gql(/* GraphQL */ `
  query GetApplikasjon($id: ID!) {
    applikasjon(id: $id) {
      id navn beskrivelse identitetsleverandor eksternId status
      aktiveMiljoer { id kode }
      organisasjon { organisasjonskode navn }
      ansvarlig { ... on FeideBruker { id brukernavn } }
      opprettetAv opprettetTidspunkt endretAv endretTidspunkt
    }
  }
`)
```

**Begrunnelse:** Dekker `BRU-APP-API-002`. Single-field-query per `fs-sikt-no-producer-schema-design.md §Global Object Identification`. Nullable returtype per `fs-sikt-no-producer-best-practice.md §Nullability` (ren null-respons ved 404/manglende synlighet).

---

#### Op-Q3: `tilgangerForApplikasjon` — paginert sub-liste

**Dekker krav:** `BRU-APP-API-003`. **Implementeres av:** Task #D2.

```graphql
extend type Query {
  """
  Paginert liste over tilganger en applikasjon har.
  Egen rot-query for at klient-side filtrering ikke trengs.
  """
  tilgangerForApplikasjon(
    applikasjonId: ID!
    filter: TilgangerForApplikasjonFilterInput
    orderBy: TilgangerForApplikasjonOrderByInput
    first: Int, after: String, last: Int, before: String
  ): TilgangerForApplikasjonConnection
}

input TilgangerForApplikasjonFilterInput {
  miljoer: [ID!]
  tilgangskoder: [String!]
}

input TilgangerForApplikasjonOrderByInput {
  orderByField: TilgangerForApplikasjonOrderByField!
  direction: OrderDirection!
}

enum TilgangerForApplikasjonOrderByField {
  TILGANGSKODE
  MILJOE
}

type TilgangerForApplikasjonConnection {
  edges: [TilgangerForApplikasjonConnectionEdge]
  nodes: [Tilgang]
  pageInfo: PageInfo
  totalCount: Int
}

type TilgangerForApplikasjonConnectionEdge {
  cursor: String
  node: Tilgang
}
```

```ts
export const GET_TILGANGER_FOR_APPLIKASJON = gql(/* GraphQL */ `
  query GetTilgangerForApplikasjon(
    $applikasjonId: ID!
    $filter: TilgangerForApplikasjonFilterInput
    $orderBy: TilgangerForApplikasjonOrderByInput
    $first: Int
  ) {
    tilgangerForApplikasjon(
      applikasjonId: $applikasjonId
      filter: $filter
      orderBy: $orderBy
      first: $first
    ) {
      totalCount
      pageInfo { hasNextPage endCursor }
      nodes {
        id tilgangskode beskrivelse
        miljo { id kode }
      }
    }
  }
`)
```

**Begrunnelse:** Dekker `BRU-APP-API-003`. Egen rot-query gjør cache-oppdateringer enklere etter mutations og avverger dokumentert anti-pattern (klient-side Fuse.js, jf. POC-en). Sortering-enum bruker `MILJOE` per `fs-sikt-no-producer-naming.md §ÆØÅ→AOA`.

---

#### Op-Q4: `sokFeideBrukerForOrganisasjon`

**Dekker krav:** `BRU-APP-API-005`. **Implementeres av:** Task #D5.

```graphql
extend type Query {
  """Søk etter feide-brukere innenfor én organisasjon."""
  sokFeideBrukerForOrganisasjon(
    organisasjonskode: String!
    query: String!
    first: Int
  ): FeideBrukerSokConnection
}

type FeideBrukerSokConnection {
  edges: [FeideBrukerSokConnectionEdge]
  nodes: [FeideBruker]
  pageInfo: PageInfo
  totalCount: Int
}

type FeideBrukerSokConnectionEdge {
  cursor: String
  node: FeideBruker
}
```

```ts
export const SOK_FEIDEBRUKER_FOR_ORGANISASJON = gql(/* GraphQL */ `
  query SokFeideBrukerForOrganisasjon(
    $organisasjonskode: String!
    $query: String!
    $first: Int
  ) {
    sokFeideBrukerForOrganisasjon(
      organisasjonskode: $organisasjonskode
      query: $query
      first: $first
    ) {
      nodes { id brukernavn }
    }
  }
`)
```

**Begrunnelse:** Dekker `BRU-APP-API-005` *Regel: Søk etter ansvarlig er avgrenset til applikasjonens organisasjon*. `FeideBruker`-typen finnes allerede i schemaet. **Åpent:** kanskje gjenbruk av eksisterende `personProfilerGittFeideBrukere`-mønster — se *Åpne spørsmål #1*.

---

#### Op-Q5: `mineOrganisasjonerForApplikasjonsadmin`

**Dekker krav:** `BRU-APP-API-009`, `BRU-APP-API-007`. **Implementeres av:** Task #E1, Task #E4.

```graphql
extend type Query {
  """Organisasjoner der innlogget bruker har applikasjonsadministrator-rollen."""
  mineOrganisasjonerForApplikasjonsadmin: [Organisasjon!]!
}
```

```ts
export const GET_MINE_ORGANISASJONER_FOR_APPLIKASJONSADMIN = gql(/* GraphQL */ `
  query GetMineOrganisasjonerForApplikasjonsadmin {
    mineOrganisasjonerForApplikasjonsadmin {
      organisasjonskode navn
    }
  }
`)
```

**Begrunnelse:** Semantisk felt på Query-rot per `fs-sikt-no-producer-schema-design.md §Vi innfører gjerne egne felt og typer` (samme mønster som `mineSoknader`). Returnerer liste (ikke connection) fordi antall organisasjoner per bruker er svært lavt per `fs-sikt-no-producer-best-practice.md §Paginering`.

---

#### Op-Q6: `tilgjengeligeTilgangerForTildeling`

**Dekker krav:** `BRU-APP-API-007`. **Implementeres av:** Task #E4.

```graphql
extend type Query {
  """
  Tilganger admin har rettighet til å tildele i et gitt miljø for en applikasjon.
  Allerede tildelte tilganger inkluderes med `erAlleredeTildelt = true` slik at UI
  kan vise dem gråtonet.
  """
  tilgjengeligeTilgangerForTildeling(
    applikasjonId: ID!
    organisasjonskode: String!
    miljoId: ID!
  ): [TilgjengeligTilgangValg!]!
}

type TilgjengeligTilgangValg {
  tilgangskode: String!
  beskrivelse: String
  erAlleredeTildelt: Boolean!
}
```

```ts
export const GET_TILGJENGELIGE_TILGANGER_FOR_TILDELING = gql(/* GraphQL */ `
  query GetTilgjengeligeTilgangerForTildeling(
    $applikasjonId: ID!
    $organisasjonskode: String!
    $miljoId: ID!
  ) {
    tilgjengeligeTilgangerForTildeling(
      applikasjonId: $applikasjonId
      organisasjonskode: $organisasjonskode
      miljoId: $miljoId
    ) {
      tilgangskode beskrivelse erAlleredeTildelt
    }
  }
`)
```

**Begrunnelse:** Dekker `BRU-APP-API-007` *Regel: Allerede tildelt tilgang vises som ikke-valgbar*. Boolean med verb-prefiks (`erAlleredeTildelt`) per `fs-sikt-no-producer-naming.md §Boolean-felt navngis med verb`.

---

#### Op-Q7: `verifiserEksternIdHosIdentitetsleverandor`

**Dekker krav:** `BRU-APP-API-009`. **Implementeres av:** Task #E1.

```graphql
extend type Query {
  """
  Pre-flight-sjekk: slår opp en ekstern ID hos idP og returnerer navn +
  om den allerede er registrert. Null hvis ID-en ikke finnes hos idP.
  """
  verifiserEksternIdHosIdentitetsleverandor(
    identitetsleverandor: Identitetsleverandor!
    eksternId: String!
  ): EksternIdVerifikasjon
}

type EksternIdVerifikasjon {
  navn: String!
  erAlleredeRegistrert: Boolean!
  """ID-en til den eksisterende applikasjonen, hvis erAlleredeRegistrert er true."""
  registrertSomApplikasjonId: ID
}
```

```ts
export const VERIFISER_EKSTERN_ID = gql(/* GraphQL */ `
  query VerifiserEksternId(
    $identitetsleverandor: Identitetsleverandor!
    $eksternId: String!
  ) {
    verifiserEksternIdHosIdentitetsleverandor(
      identitetsleverandor: $identitetsleverandor
      eksternId: $eksternId
    ) {
      navn erAlleredeRegistrert registrertSomApplikasjonId
    }
  }
`)
```

**Begrunnelse:** Dekker `BRU-APP-API-009` *Scenariomal: Opprettelse avvises når ID ikke finnes / allerede registrert*. Pre-flight gir bedre UX — UI viser navnet før "Opprett". **Åpent:** `registrertSomApplikasjonId` kan lekke ID på tvers av org — se *Åpne spørsmål #3*.

---

#### Op-M1: `settAnsvarligPaApplikasjon`

**Dekker krav:** `BRU-APP-API-005`. **Implementeres av:** Task #D5.

```graphql
extend type Mutation {
  settAnsvarligPaApplikasjon(input: SettAnsvarligPaApplikasjonInput!): SettAnsvarligPaApplikasjonPayload
}

input SettAnsvarligPaApplikasjonInput {
  applikasjonId: ID!
  """null = fjern ansvarlig."""
  feideBrukerId: ID
}

type SettAnsvarligPaApplikasjonPayload {
  applikasjon: Applikasjon
  errors: [SettAnsvarligPaApplikasjonErrors!]!
}

union SettAnsvarligPaApplikasjonErrors =
    IkkeRettighetTilApplikasjon
  | FeideBrukerIkkeIApplikasjonensOrganisasjon

type IkkeRettighetTilApplikasjon implements Error {
  message: String!
  path: [String!]!
  applikasjonId: ID!
}

type FeideBrukerIkkeIApplikasjonensOrganisasjon implements Error {
  message: String!
  path: [String!]!
  feideBrukerId: ID!
  applikasjonensOrganisasjonskode: String!
}
```

```ts
export const SETT_ANSVARLIG_PA_APPLIKASJON = gql(/* GraphQL */ `
  mutation SettAnsvarligPaApplikasjon($input: SettAnsvarligPaApplikasjonInput!) {
    settAnsvarligPaApplikasjon(input: $input) {
      applikasjon { id ansvarlig { ... on FeideBruker { id brukernavn } } }
      errors { ... on Error { message path } }
    }
  }
`)
```

**Begrunnelse:** Dekker `BRU-APP-API-005`. Mutation på `Mutation`-typen per `fs-sikt-no-producer-best-practice.md §Bare felt på Mutation-typen kan utføre endringer`. Error-envelope-mønster (plural `Errors`-union, medlemmer implementerer `Error`-interface) matcher eksisterende `OpprettFagpersonerGittFodselsnumreErrors`. `IkkeRettighetTilApplikasjon` gjenbrukes på tvers av M1–M8.

---

#### Op-M2: `redigerBeskrivelsePaApplikasjon`

**Dekker krav:** `BRU-APP-API-006`. **Implementeres av:** Task #D6.

```graphql
extend type Mutation {
  redigerBeskrivelsePaApplikasjon(input: RedigerBeskrivelsePaApplikasjonInput!): RedigerBeskrivelsePaApplikasjonPayload
}

input RedigerBeskrivelsePaApplikasjonInput {
  applikasjonId: ID!
  """null eller tom streng fjerner beskrivelsen."""
  beskrivelse: String
}

type RedigerBeskrivelsePaApplikasjonPayload {
  applikasjon: Applikasjon
  errors: [RedigerBeskrivelsePaApplikasjonErrors!]!
}

union RedigerBeskrivelsePaApplikasjonErrors =
    IkkeRettighetTilApplikasjon
  | ForLangBeskrivelse

type ForLangBeskrivelse implements Error {
  message: String!
  path: [String!]!
  maksLengde: Int!
}
```

```ts
export const REDIGER_BESKRIVELSE_PA_APPLIKASJON = gql(/* GraphQL */ `
  mutation RedigerBeskrivelsePaApplikasjon($input: RedigerBeskrivelsePaApplikasjonInput!) {
    redigerBeskrivelsePaApplikasjon(input: $input) {
      applikasjon { id beskrivelse }
      errors { ... on Error { message path } }
    }
  }
`)
```

**Begrunnelse:** Dekker `BRU-APP-API-006`. Verb-form på mutation-navn følger eksisterende stil (`deaktiverFagpersoner`, `fjernFagpersonkategori`).

---

#### Op-M3: `settPassordPaApplikasjon` — engangs-passord

**Dekker krav:** `BRU-APP-API-004`. **Implementeres av:** Task #D7.

```graphql
extend type Mutation {
  """
  Genererer nytt basic-auth-passord. Det rå passordet returneres KUN i denne responsen
  og lagres aldri i klart. Gamle passord ugyldig umiddelbart.

  ⚠️ Klienter må ikke logge, cache eller persistere `nyttPassord`.
  """
  settPassordPaApplikasjon(input: SettPassordPaApplikasjonInput!): SettPassordPaApplikasjonPayload
}

input SettPassordPaApplikasjonInput {
  applikasjonId: ID!
}

type SettPassordPaApplikasjonPayload {
  """Returneres kun én gang. Null hvis errors er ikke-tom."""
  nyttPassord: String
  applikasjon: Applikasjon
  errors: [SettPassordPaApplikasjonErrors!]!
}

union SettPassordPaApplikasjonErrors =
    IkkeRettighetTilApplikasjon
  | ApplikasjonErDeaktivert

type ApplikasjonErDeaktivert implements Error {
  message: String!
  path: [String!]!
  applikasjonId: ID!
}
```

```ts
export const SETT_PASSORD_PA_APPLIKASJON = gql(/* GraphQL */ `
  mutation SettPassordPaApplikasjon($input: SettPassordPaApplikasjonInput!) {
    settPassordPaApplikasjon(input: $input) {
      nyttPassord
      errors { ... on Error { message path } }
    }
  }
`)
```

**Begrunnelse:** Dekker `BRU-APP-API-004` *Regel: Nytt passord genereres av systemet* + *Regel: Vises én gang* + *Regel: Kun ett passord aktivt*. `nyttPassord` nullable (null på feil, aldri på suksess) per `fs-sikt-no-producer-best-practice.md §Nullability`. Sikkerhets-merknad i doc-string nødvendig fordi schemaet er kontrakten klienten leser. Versjonering: hvis sikkerhets-policy endrer seg senere, legg til `settPassordPaApplikasjonV2` per `fs-sikt-no-producer-schema-design.md §Endringer i API bør ikke ødelegge for klienter`.

---

#### Op-M4: `opprettApplikasjon`

**Dekker krav:** `BRU-APP-API-009`. **Implementeres av:** Task #E1.

```graphql
extend type Mutation {
  opprettApplikasjon(input: OpprettApplikasjonInput!): OpprettApplikasjonPayload
}

input OpprettApplikasjonInput {
  identitetsleverandor: IdentitetsleverandorForOpprettelse!
  eksternId: String!
  organisasjonskode: String!
}

"""Subset av Identitetsleverandor — FS er utfaset for opprettelse."""
enum IdentitetsleverandorForOpprettelse { FEIDE  MASKINPORTEN }

type OpprettApplikasjonPayload {
  applikasjon: Applikasjon
  errors: [OpprettApplikasjonErrors!]!
}

union OpprettApplikasjonErrors =
    IkkeRettighetTilOrganisasjon
  | EksternIdIkkeFunnetHosIdentitetsleverandor
  | EksternIdAlleredeRegistrert
  | VisningsnavnAlleredeIBruk

type IkkeRettighetTilOrganisasjon implements Error {
  message: String!
  path: [String!]!
  organisasjonskode: String!
}

type EksternIdIkkeFunnetHosIdentitetsleverandor implements Error {
  message: String!
  path: [String!]!
  identitetsleverandor: Identitetsleverandor!
  eksternId: String!
}

type EksternIdAlleredeRegistrert implements Error {
  message: String!
  path: [String!]!
  eksisterendeApplikasjonId: ID!
}

type VisningsnavnAlleredeIBruk implements Error {
  message: String!
  path: [String!]!
  visningsnavn: String!
}
```

```ts
export const OPPRETT_APPLIKASJON = gql(/* GraphQL */ `
  mutation OpprettApplikasjon($input: OpprettApplikasjonInput!) {
    opprettApplikasjon(input: $input) {
      applikasjon { id navn }
      errors { ... on Error { message path } }
    }
  }
`)
```

**Begrunnelse:** Dekker hele `BRU-APP-API-009`. Egen sub-enum `IdentitetsleverandorForOpprettelse` håndhever på schema-nivå at FS ikke kan velges som idP for nye — klient kan ikke "lure seg unna". Fire spesifikke error-typer dekker hver `Scenariomal`.

---

#### Op-M5: `tildelTilgangerTilApplikasjon`

**Dekker krav:** `BRU-APP-API-007`. **Implementeres av:** Task #E4.

```graphql
extend type Mutation {
  tildelTilgangerTilApplikasjon(input: TildelTilgangerTilApplikasjonInput!): TildelTilgangerTilApplikasjonPayload
}

input TildelTilgangerTilApplikasjonInput {
  applikasjonId: ID!
  organisasjonskode: String!
  miljoId: ID!
  tilgangskoder: [String!]!
}

type TildelTilgangerTilApplikasjonPayload {
  applikasjon: Applikasjon
  tildelteTilganger: [Tilgang!]
  errors: [TildelTilgangerTilApplikasjonErrors!]!
}

union TildelTilgangerTilApplikasjonErrors =
    IkkeRettighetTilApplikasjon
  | IkkeRettighetTilTilgangstildeling
  | TilgangAlleredeTildelt

type IkkeRettighetTilTilgangstildeling implements Error {
  message: String!
  path: [String!]!
  tilgangskoder: [String!]!
}

type TilgangAlleredeTildelt implements Error {
  message: String!
  path: [String!]!
  tilgangskoder: [String!]!
  miljoId: ID!
}
```

```ts
export const TILDEL_TILGANGER_TIL_APPLIKASJON = gql(/* GraphQL */ `
  mutation TildelTilgangerTilApplikasjon($input: TildelTilgangerTilApplikasjonInput!) {
    tildelTilgangerTilApplikasjon(input: $input) {
      applikasjon { id aktiveMiljoer { id kode } }
      tildelteTilganger { id tilgangskode miljo { id kode } }
      errors { ... on Error { message path } }
    }
  }
`)
```

**Begrunnelse:** Dekker `BRU-APP-API-007` *Scenario: Tildele flere tilganger samtidig i ett valgt miljø*. Plural mutation-navn fordi bulk er standardformen.

---

#### Op-M6: `fjernTilgangerFraApplikasjon`

**Dekker krav:** `BRU-APP-API-008`. **Implementeres av:** Task #E5.

```graphql
extend type Mutation {
  fjernTilgangerFraApplikasjon(input: FjernTilgangerFraApplikasjonInput!): FjernTilgangerFraApplikasjonPayload
}

input FjernTilgangerFraApplikasjonInput {
  """ID-er til Tilgang-objektene. Må alle tilhøre samme applikasjon og samme miljø."""
  tilgangIder: [ID!]!
}

type FjernTilgangerFraApplikasjonPayload {
  applikasjon: Applikasjon
  errors: [FjernTilgangerFraApplikasjonErrors!]!
}

union FjernTilgangerFraApplikasjonErrors =
    IkkeRettighetTilApplikasjon
  | TilgangerFraUlikeMiljoer
  | IngenTilgangerOppgitt

type TilgangerFraUlikeMiljoer implements Error { message: String!  path: [String!]! }
type IngenTilgangerOppgitt implements Error { message: String!  path: [String!]! }
```

```ts
export const FJERN_TILGANGER_FRA_APPLIKASJON = gql(/* GraphQL */ `
  mutation FjernTilgangerFraApplikasjon($input: FjernTilgangerFraApplikasjonInput!) {
    fjernTilgangerFraApplikasjon(input: $input) {
      applikasjon { id }
      errors { ... on Error { message path } }
    }
  }
`)
```

**Begrunnelse:** Dekker `BRU-APP-API-008`. ID-basert identifikasjon (Tilgang er `Node`) — ingen behov for `applikasjonId` på nytt per `fs-sikt-no-producer-schema-design.md §Global Object Identification`.

---

#### Op-M7 / Op-M8: `deaktiverApplikasjon` / `reaktiverApplikasjon`

**Dekker krav:** `BRU-APP-API-010`. **Implementeres av:** Task #E6.

```graphql
extend type Mutation {
  deaktiverApplikasjon(input: DeaktiverApplikasjonInput!): DeaktiverApplikasjonPayload
  reaktiverApplikasjon(input: ReaktiverApplikasjonInput!): ReaktiverApplikasjonPayload
}

input DeaktiverApplikasjonInput { applikasjonId: ID! }
input ReaktiverApplikasjonInput { applikasjonId: ID! }

type DeaktiverApplikasjonPayload {
  applikasjon: Applikasjon
  errors: [DeaktiverApplikasjonErrors!]!
}

type ReaktiverApplikasjonPayload {
  applikasjon: Applikasjon
  errors: [ReaktiverApplikasjonErrors!]!
}

union DeaktiverApplikasjonErrors =
    IkkeRettighetTilApplikasjon
  | ApplikasjonAlleredeDeaktivert

union ReaktiverApplikasjonErrors =
    IkkeRettighetTilApplikasjon
  | ApplikasjonAlleredeAktiv

type ApplikasjonAlleredeDeaktivert implements Error { message: String!  path: [String!]!  applikasjonId: ID! }
type ApplikasjonAlleredeAktiv implements Error { message: String!  path: [String!]!  applikasjonId: ID! }
```

**Begrunnelse:** Dekker `BRU-APP-API-010`. Separate mutations (ikke én `settApplikasjonStatus`) fordi de to verbene har ulike error-tilfeller og bekreftelses-dialoger. Ingen permanent sletting per *Notat: K10 er bevisst utelatt*.

---

### Tverrgående schema-bekymringer

**Permission-modell:** Rettigheter sjekkes i resolveren. UI utleder hva som er mulig fra (a) `mineOrganisasjonerForApplikasjonsadmin` og (b) hvilke felt `Applikasjon`/`Tilgang` returnerer. Detaljerte handlings-rettigheter returneres som **error-typer ved mutation-tid** (`IkkeRettighetTilApplikasjon`), ikke som boolean-felt på `Applikasjon`. Forkastet alternativ: `kanEndrePassord: Boolean!` — schema-evolusjon-risiko + race-condition fortsatt nødvendig å håndtere.

**Felles error-typer (gjenbrukt på tvers):** `IkkeRettighetTilApplikasjon`.

**Sporings-felter:** Lagt på `Applikasjon` nå (eksplisitt krav i `BRU-APP-API-002`) og `Tilgang.tildeltAv/tildeltTidspunkt`.

**Versjonering:** Ingen versjoneringskonflikter — alt er nytt. Kjente fremtidige endringer: `ApplikasjonAnsvarlig`-union utvides med `FeideGruppe` i Iter 4 (additive).

---

### Åpne spørsmål

- [ ] **Op-Q4 — eksisterende bruker-søk?** Finnes det allerede et org-avgrenset bruker-søk-felt i schemaet vi kan gjenbruke, eller må SuperGraf legge til `sokFeideBrukerForOrganisasjon`? Påvirker estimat for Task #D5.
- [ ] **`Tilgang.beskrivelse` — oversettelser?** Skal feltet være `String` eller `OversatteTekster` (jf. `TilgangsrolleBeskrivelseAlleSprak`-mønsteret)? Ikke blokkerende for Iter 2 hvis vi starter med `String` og versjonerer til `beskrivelseV2: OversatteTekster` senere.
- [ ] **Op-Q7 — ID-lekkasje?** Skal `registrertSomApplikasjonId` returneres selv når applikasjonen ligger i en organisasjon brukeren ikke har synlighet til? Påvirker UX i opprett-modal — kan vi linke direkte, eller bare vise melding?

## Implementation Tasks

### Iter 2 — Listevisning + Detalj-shell + lese-flyt

#### Task #L1: Sett opp rute + `ApplikasjonerOverview`-skall med URL-state

**Priority:** High · **Size:** M · **Dependencies:** SuperGraf Op-Q1 i deploy
**Addresses Requirements:** `BRU-APP-API-001`

**Acceptance Criteria:**

- [ ] `src/app/tilgangsstyring/applikasjoner/page.tsx` rendrer `<ApplikasjonerOverview />`.
- [ ] `ApplikasjonerOverview.tsx` bruker `ListPageLayout` med `ListPageActionbar`, `ListPageSidebar`, `ListPageContent`.
- [ ] `useGetApplikasjonerState` (nuqs-basert via `useDataListState`) eksponerer `filter`, `orderBy`, `first`, `onFilterChange`, `onOrderByChange`, `onFirstChange`.
- [ ] Ingen `useState` for filter-verdier; alle endringer synkroniseres til URL-en.
- [ ] Browser-back fra detaljside bevarer filter/sort/paginering.
- [ ] a11y-test (`ApplikasjonerOverview.a11y.test.tsx`).

**Implementation Notes:** Kopier strukturen fra `src/domains/utdanning/features/EmnerOverview/EmnerOverview.tsx`. URL-state-mønster i `hooks/useGetEmnerState.tsx` er den nærmeste referansen. Ikke ta med `useMineLaresteder` — synlighet håndteres server-side.

---

#### Task #L2: `ApplikasjonerResultList` med NavigationList

**Priority:** High · **Size:** M · **Dependencies:** Task #L1, Op-Q1
**Addresses Requirements:** `BRU-APP-API-001`

**Acceptance Criteria:**

- [ ] `NavigationList` med `NavigationListItem` som `href` til `/tilgangsstyring/applikasjoner/[id]`.
- [ ] Hver rad viser: Navn, Beskrivelse, Miljøer (badge-liste), Ansvarlig (brukernavn eller "—"), Organisasjon (forkortelse), Status (badge).
- [ ] `useGetApplikasjoner` bruker `useDataListQuery` med `GET_APPLIKASJONER` (Op-Q1).
- [ ] "Last inn flere" øker `first` med 50 (default page size).
- [ ] Tom-tilstand med tekst og forslag (når filter gir 0 treff).
- [ ] Sortering-knapp (`ApplikasjonerOrderBy`) — kun NAVN i Iter 2.
- [ ] Total antall og lastet antall vises (`totalCount`, `loadedCount`).
- [ ] Ingen idP-ikon i listen (brukerbeslutning 2026-05-18).

**Implementation Notes:** Speil `EmnerResultList.tsx`. Bruk `NavigationListItem` med `href`-prop (ikke `onClick` + `router.push`) for å bevare Next.js prefetching + scroll-restore.

---

#### Task #L3: `ApplikasjonerFilter`-sidebar

**Priority:** High · **Size:** L · **Dependencies:** Task #L1
**Addresses Requirements:** `BRU-APP-API-001` (inkl. `@could` filter-på-tilgang)

**Acceptance Criteria:**

- [ ] `NavnSearchFilter` — fritekst, debounced, oppdaterer `filter.navnContains`.
- [ ] `OrganisasjonFilter` — multi-select dropdown med organisasjoner fra `mineOrganisasjonerForApplikasjonsadmin` (eller alle hvis super-admin). **Avhengig av Op-Q5 — kan demos med dummy-data i lokal-utvikling.**
- [ ] `TilgangFilter` — multi-select dropdown med tilgangskoder. (`@could`, inkludert i Iter 2.)
- [ ] `StatusFilter` — multi-select dropdown med AKTIV/DEAKTIVERT.
- [ ] `FilterReset`-knapp tilbakestiller alle filtre.
- [ ] Aktive filtre vises som chips i `filterElement` på `NavigationList`.
- [ ] Kombinasjon av flere filtre fungerer (server-side AND).

**Implementation Notes:** Bruk `EmnerFilter`-komponenten som referanse. Tilgangskoder-listen kan trenge en hjelpe-query (åpent spørsmål — kan løses ad-hoc i Iter 2 og forbedres i Iter 4).

---

#### Task #D1: `ApplikasjonDetails`-skall + `useGetApplikasjon`

**Priority:** High · **Size:** M · **Dependencies:** SuperGraf Op-Q2 i deploy
**Addresses Requirements:** `BRU-APP-API-002`

**Acceptance Criteria:**

- [ ] `src/app/tilgangsstyring/applikasjoner/[id]/page.tsx` extracter `id` fra `params` og rendrer `<ApplikasjonDetails id={id} />`.
- [ ] `ApplikasjonDetails.tsx` bruker `DetailPageLayout` + `DetailPageTopBar` + `DetailPageTabbedContent`.
- [ ] `useGetApplikasjon(id)` returnerer `{ applikasjon, loading, error }`.
- [ ] `NotFoundError`-fallback når applikasjonen ikke finnes (eller bruker mangler synlighet).
- [ ] Breadcrumb: "Hjem / Tilgangsstyring / Applikasjoner / {navn}".
- [ ] `ApplikasjonInformation`-topbar viser navn, status-badge, idP-badge, organisasjonsforkortelse, ansvarlig.
- [ ] Tabs: "Detaljer" (default) + "Tilganger" (Task #D2).
- [ ] a11y-test (`ApplikasjonDetails.a11y.test.tsx`).

**Implementation Notes:** Speil `EmneDetails.tsx`. Bruk Sikt-ikoner eller tekst-badges for idP — bekreft hva som finnes i `@sikt/sds-icons` (kan også løses i Task #D1 review).

---

#### Task #D2: "Tilganger"-tab med paginert sub-liste

**Priority:** High · **Size:** L · **Dependencies:** Task #D1, Op-Q3
**Addresses Requirements:** `BRU-APP-API-003`

**Acceptance Criteria:**

- [ ] `TilgangerTab` rendres når brukeren velger tab.
- [ ] `useGetTilgangerForApplikasjon` bruker `useDataListQuery` (separat URL-state-instans per tab — eller egen state-hook for tabben).
- [ ] `TilgangerFilter` — multi-select på miljø og tilgangskode. Valglistene begrenses til miljøer/tilganger applikasjonen faktisk har (server-side enforcement).
- [ ] `TilgangerOrderBy` — TILGANGSKODE og MILJOE.
- [ ] `TilgangerResultList` — `ActionList` med "Last inn flere".
- [ ] Tom-tilstand når applikasjonen har 0 tilganger.
- [ ] **Ingen Fuse.js, ingen klient-side sortering** — dokumentert anti-pattern (detail-page anti-patterns §1).

**Implementation Notes:** Tab-state må enten dele eller skille seg fra hovedlistens URL-state. Anbefaling: egen state-key-prefix (`t_miljoer`, `t_tilgangskoder`) så de ikke kolliderer.

---

#### Task #D3: "Detaljer"-tab — `GrunninfoTab`

**Priority:** Medium · **Size:** S · **Dependencies:** Task #D1
**Addresses Requirements:** `BRU-APP-API-002`

**Acceptance Criteria:**

- [ ] Viser beskrivelse (med "ingen beskrivelse"-tekst hvis tom).
- [ ] Viser sporingsinfo: opprettet av, opprettet tidspunkt, endret av, endret tidspunkt (formatert som norsk dato).
- [ ] Viser aktive miljøer som badge-liste.
- [ ] Skeleton-loading mens query kjører.

---

#### Task #D5: `AnsvarligEditor` + bruker-søk + mutation

**Priority:** High · **Size:** L · **Dependencies:** Task #D1, Op-Q4, Op-M1
**Addresses Requirements:** `BRU-APP-API-005`

**Acceptance Criteria:**

- [ ] Ansvarlig-feltet i topbar kan klikkes/åpnes for redigering (kun hvis bruker har rettighet).
- [ ] `AnsvarligEditor`-popover/-modal har bruker-søkefelt som kaller `SOK_FEIDEBRUKER_FOR_ORGANISASJON` (debounced).
- [ ] Søk er begrenset til applikasjonens organisasjon (server-side enforcement, men UI sender `organisasjonskode` eksplisitt).
- [ ] "Fjern ansvarlig"-knapp kaller `SETT_ANSVARLIG_PA_APPLIKASJON` med `feideBrukerId: null`.
- [ ] Suksess-melding (toast) ved fullført endring.
- [ ] Error-håndtering for `FeideBrukerIkkeIApplikasjonensOrganisasjon` og `IkkeRettighetTilApplikasjon`.
- [ ] Feide-gruppe-søk **ikke** inkludert (utsatt til Iter 4 per brukerbeslutning).

---

#### Task #D6: `BeskrivelseEditor` + mutation

**Priority:** Medium · **Size:** M · **Dependencies:** Task #D3, Op-M2
**Addresses Requirements:** `BRU-APP-API-006`

**Acceptance Criteria:**

- [ ] Beskrivelse i `GrunninfoTab` er redigerbar inline eller via "Rediger"-knapp.
- [ ] Maks-lengde valideres klient-side (info-melding) og server-side (error-type `ForLangBeskrivelse`).
- [ ] "Avbryt" forkaster endringer.
- [ ] "Lagre" kaller `REDIGER_BESKRIVELSE_PA_APPLIKASJON` og oppdaterer cache.
- [ ] Knappen er gråtonet/skjult hvis bruker mangler rettighet.

---

#### Task #D7: `PassordbytteModal` med engangs-visning

**Priority:** High · **Size:** L · **Dependencies:** Task #D1, Op-M3
**Addresses Requirements:** `BRU-APP-API-004`

**Acceptance Criteria:**

- [ ] "Generer nytt passord"-knapp i topbar/handlings-meny (kun hvis bruker har rettighet og applikasjonen er aktiv).
- [ ] Bekreftelsesdialog før mutation kjøres ("Dette ugyldiggjør forrige passord umiddelbart").
- [ ] Etter `SETT_PASSORD_PA_APPLIKASJON`: modal viser passordet skjult (●●●), med "Vis"-toggle og "Kopier til utklippstavle"-knapp.
- [ ] Når modalen lukkes, kastes passord-strengen fra React-state.
- [ ] Apollo cache for denne mutationen er disabled (default — ingen `update` eller `refetchQueries` som persisterer passordet).
- [ ] **Verifisering:** passordet logges aldri til console (sjekk i dev-tools), og finnes ikke i Apollo cache etter modal-lukking (sjekk Apollo DevTools).
- [ ] Error-håndtering for `ApplikasjonErDeaktivert`.

**Implementation Notes:** ⚠️ Sikkerhets-sensitiv komponent. Code-review skal eksplisitt verifisere at passordet ikke flyter ut av modalen, ikke logges, og ikke ligger i Apollo cache. Test må mocke mutation og asserte at strengen er borte fra DOM/state ved unmount.

---

### Iter 3 — Tilgangsstyring + opprette + deaktivere

#### Task #E1: `OpprettApplikasjonModal` med idP-flyt

**Priority:** High · **Size:** XL · **Dependencies:** Task #L1, Op-Q5, Op-Q7, Op-M4
**Addresses Requirements:** `BRU-APP-API-009`

**Acceptance Criteria:**

- [ ] "Opprett applikasjon"-knapp i `ListPageActionbar` (kun synlig hvis `mineOrganisasjonerForApplikasjonsadmin` returnerer ≥1).
- [ ] Steg 1: Velg idP (radio: Feide / Maskinporten). FS er ikke listet.
- [ ] Steg 2: Oppgi ekstern ID. På blur: `VERIFISER_EKSTERN_ID` kjøres.
  - [ ] Viser navn fra idP hvis funnet.
  - [ ] Viser "ID ikke funnet"-feilmelding hvis ikke.
  - [ ] Viser "ID allerede registrert"-feilmelding hvis brukt (med lenke hvis backend tillater).
- [ ] Steg 3: Velg organisasjon (dropdown fra `mineOrganisasjonerForApplikasjonsadmin`). Hopp over hvis bruker bare har én.
- [ ] Steg 4: Bekreft + "Opprett"-knapp kaller `OPPRETT_APPLIKASJON`.
- [ ] Etter suksess: navigerer til `/tilgangsstyring/applikasjoner/{id}` for den nye applikasjonen.
- [ ] Error-håndtering for alle fire error-typer i `OpprettApplikasjonErrors`.
- [ ] Den nye applikasjonen synlig i `applikasjoner`-listen ved retur via breadcrumb (refetch eller cache-update).

---

#### Task #E4: `TildelTilgangModal` på "Tilganger"-tab

**Priority:** High · **Size:** L · **Dependencies:** Task #D2, Op-Q5, Op-Q6, Op-M5
**Addresses Requirements:** `BRU-APP-API-007`

**Acceptance Criteria:**

- [ ] "Tildel tilganger"-knapp i `TilgangerTab` (synlig hvis bruker har rettighet).
- [ ] Modal: Velg organisasjon (hvis flere) → velg miljø → velg én eller flere tilganger (multi-select).
- [ ] Tilgangslisten kommer fra `GET_TILGJENGELIGE_TILGANGER_FOR_TILDELING` og inkluderer `erAlleredeTildelt`-flagg. Allerede tildelte vises gråtonet og er ikke valgbare.
- [ ] "Tildel"-knapp kaller `TILDEL_TILGANGER_TIL_APPLIKASJON`.
- [ ] Tilgangslisten (Op-Q3) refetches/oppdateres slik at de nye tilgangene vises.
- [ ] `applikasjon.aktiveMiljoer` oppdateres hvis miljøet er nytt.
- [ ] Error-håndtering for `IkkeRettighetTilTilgangstildeling` og `TilgangAlleredeTildelt`.

---

#### Task #E5: `FjernTilgangerBekreftelse` på "Tilganger"-tab

**Priority:** High · **Size:** M · **Dependencies:** Task #D2, Op-M6
**Addresses Requirements:** `BRU-APP-API-008`

**Acceptance Criteria:**

- [ ] Checkbox-utvalg i `TilgangerResultList` (gruppe-fjerning).
- [ ] "Fjern valgte"-knapp åpner bekreftelsesdialog som lister alle valgte tilganger og miljøet.
- [ ] Dialog håndhever at alle valgte tilganger er i samme miljø (UI viser feilmelding hvis brukeren prøver å krysse miljø).
- [ ] "Bekreft" kaller `FJERN_TILGANGER_FRA_APPLIKASJON`.
- [ ] "Avbryt" lukker dialogen uten endring.
- [ ] Tilgangslisten oppdateres etter mutation.

---

#### Task #E6: `DeaktiveringActions` + bekreftelse

**Priority:** Medium · **Size:** M · **Dependencies:** Task #D1, Op-M7, Op-M8
**Addresses Requirements:** `BRU-APP-API-010`

**Acceptance Criteria:**

- [ ] "Deaktiver"-knapp i topbar/handlings-meny (kun hvis bruker har rettighet og applikasjonen er aktiv).
- [ ] "Reaktiver"-knapp samme sted (når applikasjonen er deaktivert).
- [ ] Bekreftelsesdialog før hver av de to operasjonene.
- [ ] Etter `DEAKTIVER_APPLIKASJON`: status-badge i topbar oppdateres til "Deaktivert"; passord-, tildel-tilgang-, fjern-tilgang-, rediger-handlinger gråtones.
- [ ] Etter `REAKTIVER_APPLIKASJON`: status-badge tilbake til "Aktiv".
- [ ] Aktive miljøer beholdes etter deaktivering (visuell verifisering på `GrunninfoTab`).

---

### Cleanup (etter Iter 3 i prod)

#### Task #C1: Fjerne maskinbruker-POC

**Priority:** Medium · **Size:** M · **Dependencies:** Iter 3 i prod
**Addresses Requirements:** #31 *Implementasjonsdetaljer: "Dagens løsning for maskinbruker i FS Admin er ikke innført og skal fjernes"*

**Acceptance Criteria:**

- [ ] Slett `src/app/tilgangsstyring/maskinbrukere/` (hele).
- [ ] Slett `src/domains/support/features/Maskinbrukere/` og `MaskinBruker/` (hele).
- [ ] Fjern maskinbruker-nøklene fra `src/common/messages/nb/support.json`, `features.json`, `search.json`.
- [ ] Fjern `GET_MASKINBRUKERE`-relaterte filer (codegen ryddes ved neste `npm run compile`).
- [ ] Verifiser ingen referanser i kodebasen (`grep -ri maskinbruker src/` skal kun returnere migrasjonskommentarer hvis vi velger å beholde dem).
- [ ] Linje i CHANGELOG / changeset om at maskinbruker-modulen er fjernet.

**Implementation Notes:** Egen MR. Ikke kjør før Iter 3 er bekreftet stabil i prod (minimum 1 uke + ingen kritiske bug-rapporter).

## Risk Assessment

### Technical Risks

- **Risk:** SuperGrafen-skjemaet for `Applikasjon`-typen er ikke i deploy når fs-admin-arbeid starter.
  - **Mitigation:** Iter 2-arbeid kan starte mot MSW-mockede handlers (jf. `bat-fs-mock-api-with-data`-mønsteret i fs-admin). Bytte til ekte endepunkt skjer når codegen importerer typene. Sett opp en mock-fixture-fil tidlig.

- **Risk:** Synlighetsregelen "applikasjoner med tilganger inn i mine organisasjoner" er kompleks å implementere effektivt på backend.
  - **Mitigation:** UI er bygget agnostisk — vi henter bare `applikasjoner`-query og lar resolveren bestemme synlighet. Hvis det er en performance-flaskehals, kan vi avtale en fallback (f.eks. lazy-load denne kategorien som egen "Vis flere"-knapp). Flag som hand-off til SuperGraf-team.

- **Risk:** Passord-mutation lekker passord til Apollo cache eller console-logger.
  - **Mitigation:** Eksplisitt sikkerhets-review i Task #D7. Test verifiserer at strengen er borte fra DOM/state ved modal-unmount og at Apollo cache ikke har en `settPassordPaApplikasjon`-entry.

- **Risk:** `useDataListState` for tab-state (Task #D2) kolliderer med hovedlistens URL-state.
  - **Mitigation:** Bruk prefiks-konvensjon (`t_miljoer`, `t_tilgangskoder`) i tab-staten. Verifiseres i a11y-test (browser-back fra detaljside skal bevare *både* hovedlistens og tabbens state).

- **Risk:** ID-lekkasje i `verifiserEksternIdHosIdentitetsleverandor` (Op-Q7) — `registrertSomApplikasjonId` for applikasjoner brukeren ikke har synlighet til.
  - **Mitigation:** Flag som åpent spørsmål til SuperGraf-team før Task #E1 implementeres. Hvis backend returnerer null for ikke-synlige, viser UI bare meldingen uten lenke.

### Testing Requirements

- a11y-test for hver feature-komponent (`*.a11y.test.tsx`) per fs-admin CLAUDE.md krav.
- Unit-tester for state-hooks (`useGetApplikasjonerState`, `useGetTilgangerForApplikasjonState`) — verifiser URL-serialisering.
- Integrasjons-test for browser-back-flyten (Task #L1 acceptance).
- Sikkerhets-test for passord-håndtering (Task #D7 acceptance).
- Test-coverage må holde fs-admin-standarden (60% gren/funksjon/linje, 90% statements).

## Success Criteria

- [ ] Alle acceptance criteria på Iter 2-tasks (#L1, #L2, #L3, #D1, #D2, #D3, #D5, #D6, #D7) møtt.
- [ ] Alle acceptance criteria på Iter 3-tasks (#E1, #E4, #E5, #E6) møtt.
- [ ] Cleanup-Task #C1 utført etter Iter 3 i prod.
- [ ] Alle a11y-tester passerer.
- [ ] Alle Gherkin-scenarier i `docs/ACTIVE/krav-input/fruitbat/.../*.feature` er manuelt verifisert mot UI-en (eller dekkes av automatiserte tester der mulig).
- [ ] Ingen klient-side filter/sortering på listene (Fuse.js / `first: 1000`-mønsteret) — verifiseres ved code-review.
- [ ] `npm run lint`, `npm run test:typecheck`, `npm test`, `npm run test:a11y` passerer.

## Requirements Traceability

| Requirement ID | Krav (kort) | Addressed by Task(s) | Status |
| --- | --- | --- | --- |
| `BRU-APP-API-001` | Listevisning og søk (K1, K2, K11, K12) | #L1, #L2, #L3 | Planlagt |
| `BRU-APP-API-002` | Se detaljer (K3) | #D1, #D3 | Planlagt |
| `BRU-APP-API-003` | Vise tilganger (K4) | #D2 | Planlagt |
| `BRU-APP-API-004` | Passordbytte (K5) | #D7 | Planlagt |
| `BRU-APP-API-005` | Administrere ansvarlig (K18) | #D5 | Planlagt |
| `BRU-APP-API-006` | Redigere beskrivelse (K19) | #D6 | Planlagt |
| `BRU-APP-API-007` | Tildele tilgang (K6, K13) | #E4 | Planlagt |
| `BRU-APP-API-008` | Fjerne tilgang (K7, K14) | #E5 | Planlagt |
| `BRU-APP-API-009` | Opprette applikasjon (K8) | #E1 | Planlagt |
| `BRU-APP-API-010` | Deaktivere/reaktivere (K9) | #E6 | Planlagt |
| #31 *Cleanup* | Fjern maskinbruker-POC | #C1 | Planlagt (etter Iter 3 i prod) |
| `@could` filter-på-tilgang | Filter på tilgang i listevisning | #L3 (inkludert i scope) | Planlagt |
| `@could` feide-gruppe-ansvarlig | Feide-gruppe som ansvarlig | (Utsatt) | Iter 4 |

---

*Plan generert av `bat-plan`. GraphQL-endringer-seksjonen produsert av `bat-graphql-dev`. Følger fra [`analysis-applikasjoner.md`](analysis-applikasjoner.md).*
