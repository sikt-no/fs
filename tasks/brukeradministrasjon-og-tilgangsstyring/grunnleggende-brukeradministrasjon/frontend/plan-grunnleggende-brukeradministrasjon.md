# Plan: Grunnleggende brukeradministrasjon (personbrukere)

> Implementasjonsplan for fs-admin basert på
> [spec-grunnleggende-brukeradministrasjon.md](../spec/spec-grunnleggende-brukeradministrasjon.md) og
> [analysis-grunnleggende-brukeradministrasjon.md](analysis-grunnleggende-brukeradministrasjon.md)
> (BRU-PER-GRU-001/002/003/004/007, sikt-no/fs#350). Skrevet 2026-07-08.
> Alle stier er relative til fs-admin-repoet der ikke annet er sagt.

## Proposed Solution

### Architecture Approach

Featuren bygges som en **strukturell tvilling av applikasjoner-featuren** i
`src/domains/tilgangsstyring/`: en `ListPageLayout`-basert overview
(`PersonbrukereOverview`) med URL-synket filter/sortering/paginering, og en
`DetailPageLayout`-basert detaljside (`PersonbrukerDetails`) med tre faner
(Detaljer, Tilganger, Roller), modaler for tildel/fjern per entitet, og
deaktiver/reaktiver-modaler i topbaren.

Utviklingen er **mock-first** (analysebeslutning #1): all GraphQL går mot en
lokal referanse-SDL + MSW-handlers i `src/mocks/personbrukere/`, gated bak en
egen env-var, med teardown-dokument for migrering når subgrafen lander
(pipeline-steg 4 og 6 i fs-plattform). Mock-SDL-en i denne planens
GraphQL-seksjon er samtidig **input til subgraph-plan-steget** — alfred
kopierer `*.graphql`-fila inn i task-mappen når fs-plattform-steget starter.

Hele featuren gates bak nytt feature flag `tilgangsstyring-brukeradministrasjon`
(analysebeslutning #3) på rutene, meny-underpunktet og indeks-kortet.

### Key Technical Decisions

1. **Decision: Mock-first med `src/mocks/personbrukere/` (analysebeslutning #1)**
   - Why: fs-admin-arbeidet skal ikke blokkeres av subgraf-stegene som ligger
     senere i pipelinen; applikasjoner har etablert og dokumentert nøyaktig
     denne mekanikken (codegen-eksklusjon, manuelle TS-typer, teardown-plan).
   - Alternative considered: vente på subgraf-skjema og bygge mot genererte
     typer — forkastet: serialiserer pipelinen unødvendig.

2. **Decision: Separate modal-komponenter per entitet (plan-beslutning, bekreftet av Batman 2026-07-08)**
   - Why: `TildelTilgangModal`/`FjernTilgangModal` + `TildelRolleModal`/
     `FjernRolleModal` følger applikasjoner-idiomet, gir egne queries/mutasjoner
     per komponent (jf. CLAUDE.md-regelen om å ikke dele queries mellom
     komponenter) og unngår prematur abstraksjon.
   - Alternative considered: felles parameteriserte modaler med type-prop —
     forkastet: mer kompleks props/query-håndtering, bryter
     query-eierskap-konvensjonen.

3. **Decision: Per-element delvis-suksess-konvolutt (analysebeslutning #2)**
   - Why: kravet «delvis suksess … jeg ser tydelig hvilke tildelinger som ikke
     ble gjennomført, og hvorfor» (BRU-PER-GRU-003) kan ikke uttrykkes i dagens
     alt-eller-ingenting-konvolutt. Suksess-varianten utvides med
     `tildelte`/`fjernede` + `avviste`-lister; `MutasjonAvvist` beholdes for
     totalfeil. Se GraphQL-seksjonen Op #5/#6.
   - Alternative considered: beholde alt-eller-ingenting og la backend avvise
     hele operasjonen — forkastet: oppfyller ikke kravet.

4. **Decision: Rute `/tilgangsstyring/personbrukere` + `/[id]` (analysebeslutning #6)**
   - Why: sibling til `applikasjoner/`, matcher skissens brødsmulesti
     «Tilgangsstyring > Personbrukere». Fremtidige maskinbrukere får egen rute
     på samme nivå.

5. **Decision: Dedikerte filter-options-queries (analysebeslutning #5)**
   - Why: kravet sier filtrene skal vise verdier «representert i listen»
     (roller/miljøer) hhv. «organisasjoner jeg har brukeradministrator-rollen
     for» — det krever server-utledede kilder, ikke statiske lister.
     Miljø-verdiene bak queryen er demo/prod (spec-beslutning #4).

6. **Decision: Kolonne-lean liste-query + normalisert cache for liste→detalj**
   - Why: samme grep som `useGetApplikasjoner` — listen henter kun radfeltene;
     Apollo-cachen (id + `__typename`) gir umiddelbar delvis rendering på
     detaljsiden. Alle paginerte queries registreres i
     `src/lib/apollo/cacheConfig.ts` med
     `nodesCursorPagination(['filter', 'orderBy'])` (analysefunn #10).

7. **Decision: Arbeidsverdier for rollekoder kun i mock-laget (analysebeslutning #7)**
   - Why: `brukeradministrator`/`super_brukeradministrator` er ubekreftede
     arbeidsverdier; frontend-koden forholder seg til det API-et returnerer
     (`kan*`-flagg), aldri hardkodede rollekoder utenfor mock.

### File Changes Overview

- `src/mocks/personbrukere/` — **ny**: `schema/personbrukere.graphql`,
  `fixtures/`, `store/personbrukereStore.ts`, `handlers/queries.ts` +
  `handlers/mutations.ts`, `types.ts`, `teardown-personbrukere.md` (Task #1)
- `src/mocks/handlers.ts` — kobler inn personbruker-handlers gated bak
  `NEXT_PUBLIC_ENABLE_PERSONBRUKER_MOCKS` (Task #1)
- `src/app/tilgangsstyring/personbrukere/` — **ny**: `layout.tsx`, `page.tsx`,
  `[id]/layout.tsx`, `[id]/page.tsx` (Task #2)
- `src/features/Header/Menu/Menu.tsx` — nytt underpunkt gated bak flagget (Task #2)
- `src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.tsx`
  — nytt Personbrukere-kort (Task #2)
- `src/domains/tilgangsstyring/features/PersonbrukereOverview/` — **ny**
  (Task #3, struktur under)
- `src/domains/tilgangsstyring/features/PersonbrukerDetails/` — **ny**
  (Task #4–#9, struktur under)
- `src/lib/apollo/cacheConfig.ts` — registrering av `personbrukere` (Task #3)
  og tildelings-connections på `Personbruker` (Task #5/#7)
- `src/messages/nb/` — nye meldingsfiler per komponent (Task #2–#9)
- `src/domains/tilgangsstyring/integration/` — ny master-detail-integrasjonstest
  (Task #10)

Mappestruktur (fra analysen — speiler applikasjoner):

```
src/domains/tilgangsstyring/features/
├── PersonbrukereOverview/          # BRU-PER-GRU-001
│   ├── PersonbrukereOverview.tsx
│   ├── components/ (PersonbrukereFilter/, PersonbrukereOrderBy/,
│   │                PersonbrukereResultList/, filter/*)
│   └── hooks/ (useGetPersonbrukereState, useGetPersonbrukere,
│               useGetPersonbrukereFilterOptions,
│               useGetMineBrukerAdminOrganisasjoner, *Types.ts)
└── PersonbrukerDetails/            # BRU-PER-GRU-002/003/004/007
    ├── PersonbrukerDetails.tsx     # DetailPageLayout + 3 faner
    ├── components/
    │   ├── PersonbrukerTopBar/     # + PersonbrukerStatusActions
    │   ├── PersonbrukerDetaljer/   # Detaljer-fane
    │   ├── PersonbrukerTilganger/  # Tilganger-fane (FilterAndResult + modaler)
    │   │   └── components/ (TildelTilgangModal/, FjernTilgangModal/, …)
    │   ├── PersonbrukerRoller/     # Roller-fane (samme form)
    │   │   └── components/ (TildelRolleModal/, FjernRolleModal/, …)
    │   ├── DeaktiverPersonbrukerModal/
    │   └── ReaktiverPersonbrukerModal/
    └── hooks/
```

## GraphQL-endringer

> **Premiss:** konservativ — minste skjema-flate som dekker de fem kravene.
> **Domeneterm:** `Personbruker` (fra kravene; distinkt fra supergrafens
> `PersonProfil`-oppslag og person-domenets rene personsøk).
> **Følger fra:** [`analysis-grunnleggende-brukeradministrasjon.md`](analysis-grunnleggende-brukeradministrasjon.md)
> — Key Findings #4/#6/#9, Requirements Impact (100 % av personbruker-API-et mangler).
>
> **Mock-first-kontekst:** Alt under er **referanse-SDL** for
> `src/mocks/personbrukere/schema/personbrukere.graphql` (Task #1) — ikke
> kompilert, ikke konsumert av codegen; MSW matcher på operation name.
> Seksjonen er samtidig føring inn i subgraph-plan-steget i fs-plattform.
> Skjelett-typene `Miljo`, `Organisasjon`, `Person`, `MutasjonAvvist` og
> `MutasjonAvvistArsak` re-deklareres i mock-SDL-en identisk med
> `src/mocks/applikasjoner/schema/applikasjoner.graphql` og gjentas ikke her.

### Sammendrag

- 6 nye queries (2 entitet, 2 filter-kilder, 2 modal-kilder)
- 6 nye mutations (tildel/fjern × tilganger/roller, deaktiver/reaktiver)
- 12 nye typer + 5 inputs + 5 enums
- 3 åpne spørsmål (se nederst)

### Operasjoner

#### Op #1: `personbrukere` — liste-query med filter/sortering/paginering

**Dekker krav:** BRU-PER-GRU-001
**Implementeres av:** Task #1 (mock), Task #3 (consumer)

##### Lag A — Schema-tillegg

```graphql
"En personbruker: en person med brukerkonto som kan tildeles roller og tilganger."
type Personbruker {
  id: ID!
  navn: String!
  feideId: String!
  status: PersonbrukerStatus!
  "Avledet av tildelingene: organisasjonene personbrukerens tilganger/roller gjelder for."
  organisasjoner: [Organisasjon!]!
  antallTilganger: Int!
  antallRoller: Int!
  kanTildeleTilganger: Boolean!
  kanFjerneTilganger: Boolean!
  kanTildeleRoller: Boolean!
  kanFjerneRoller: Boolean!
  kanDeaktiveres: Boolean!
  kanReaktiveres: Boolean!
}

enum PersonbrukerStatus {
  AKTIV
  DEAKTIVERT
}

extend type Query {
  "Synlighet håndheves server-side: brukeradministrator ser kun personbrukere ved egne organisasjoner."
  personbrukere(
    first: Int = 50
    after: String
    filter: PersonbrukereFilter
    orderBy: PersonbrukereOrderBy = NAVN_ASC
  ): [Personbruker!]! # @asConnection — Graphitron-emitted Connection shape
}

input PersonbrukereFilter {
  "Fritekst, case-insensitiv delstreng mot navn."
  navn: String
  "Fritekst, case-insensitiv delstreng mot Feide-ID."
  feideId: String
  status: PersonbrukerStatus
  organisasjonId: ID
  rollekode: String
  miljoKode: String
}

enum PersonbrukereOrderBy {
  "Tie-break: feideId stigende (server-side, jf. kravets sorteringsregel)."
  NAVN_ASC
  NAVN_DESC
}
```

##### Lag B — fs-admin call-site

```ts
// src/domains/tilgangsstyring/features/PersonbrukereOverview/hooks/useGetPersonbrukere.tsx
// TRANSITIONAL: gql fra @apollo/client + manuelle typer i useGetPersonbrukereTypes.ts
// (speiler useGetApplikasjoner). Operation name = MSW-handler-navn, stabilt ved teardown.
export const GET_PERSONBRUKERE = gql`
  query personbrukere(
    $first: Int
    $after: String
    $filter: PersonbrukereFilter
    $orderBy: PersonbrukereOrderBy
  ) {
    personbrukere(first: $first, after: $after, filter: $filter, orderBy: $orderBy) {
      nodes {
        id
        navn
        feideId
        status
        organisasjoner {
          id
          navn
        }
      }
      totalCount
      pageInfo {
        endCursor
        hasNextPage
      }
    }
  }
` as TypedDocumentNode<PersonbrukereQueryData, PersonbrukereQueryVariables>

export function useGetPersonbrukere() {
  const { filter, orderBy, first } = useGetPersonbrukereState()
  return useDataListQuery({
    query: GET_PERSONBRUKERE,
    variables: { first, filter: normalisert(filter), orderBy: orderBy.orderBy },
    selectConnection: (data) => data?.personbrukere,
  })
}
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-PER-GRU-001 — liste med Navn/Feide-ID/Organisasjon/Status,
  to fritekstfelt (spec-avklaring #1), status/organisasjon/rolle/miljø-filter
  (spec-avklaring #2), sortering med tie-break, «50 + last inn flere».
- **Form:** Relay-cursor-paginering med `nodes`/`totalCount`/`pageInfo` per
  `fs-sikt-no-producer-schema-design §Vi følger Cursor Connections Specification
  for paginering` og `graphql-learn-pagination §Complete connection model`.
  Tie-break-sortering er server-side-ansvar og dokumenteres i enum-beskrivelsen
  (analysefunn #9: retning-i-enum, ikke separat OrderDirection). Feltnavn på
  norsk i lowerCamelCase per `fs-sikt-no-producer-naming §Bruk norsk for
  domenebegreper…`; boolean-flagg med verb-prefiks (`kanDeaktiveres`) per
  `fs-sikt-no-producer-naming §Boolean-felt navngis med verb`.
- **Colocation-status:** Ikke best practice — flat query i hook, speiler det
  transisjonelle mock-first-mønsteret i tilgangsstyring-domenet (manuelle
  TS-typer, `gql` fra `@apollo/client`, operation name låst til MSW-handler).
  Colocation per `graphql-golden-path-fragment-colocation` vurderes ved
  teardown, når codegen-typer og data masking tar over.
- **Alternativer vurdert:** utvide supergrafens `brukere`-query — forkastet:
  returnerer `PersonProfil`, mangler alle kravets filtre/sortering, og eies av
  et annet domene (analysen, «GraphQL i dag»).

#### Op #2: `personbruker` — detalj-query med tildelings-connections

**Dekker krav:** BRU-PER-GRU-002, BRU-PER-GRU-007
**Implementeres av:** Task #1 (mock), Task #4/#5/#7 (consumer)

##### Lag A — Schema-tillegg

```graphql
extend type Personbruker {
  tilganger(
    first: Int = 50
    after: String
    filter: PersonbrukerTilgangerFilter
    orderBy: PersonbrukerTildelingerOrderBy = NAVN_ASC
  ): [PersonbrukerTilgang!]! # @asConnection
  roller(
    first: Int = 50
    after: String
    filter: PersonbrukerRollerFilter
    orderBy: PersonbrukerTildelingerOrderBy = NAVN_ASC
  ): [PersonbrukerRolle!]! # @asConnection
}

extend type Query {
  personbruker(id: ID!): Personbruker
}

"En tildelt tilgang. INAKTIV når brukeren er deaktivert (frys-semantikk, BRU-PER-GRU-004)."
type PersonbrukerTilgang {
  id: ID!
  tilgangskode: String!
  navn: String!
  status: TildelingStatus!
  organisasjon: Organisasjon!
  miljo: Miljo!
  tildeltAv: Person!
  tildeltTidspunkt: LocalDateTime!
  kanFjernes: Boolean!
}

"En tildelt rolle. Samme form som PersonbrukerTilgang."
type PersonbrukerRolle {
  id: ID!
  rollekode: String!
  navn: String!
  status: TildelingStatus!
  organisasjon: Organisasjon!
  miljo: Miljo!
  tildeltAv: Person!
  tildeltTidspunkt: LocalDateTime!
  kanFjernes: Boolean!
}

enum TildelingStatus {
  AKTIV
  INAKTIV
}

input PersonbrukerTilgangerFilter {
  navn: String
  status: TildelingStatus
  organisasjonId: ID
}

input PersonbrukerRollerFilter {
  navn: String
  status: TildelingStatus
  organisasjonId: ID
}

enum PersonbrukerTildelingerOrderBy {
  NAVN_ASC
  NAVN_DESC
}
```

##### Lag B — fs-admin call-site

```ts
// src/domains/tilgangsstyring/features/PersonbrukerDetails/hooks/useGetPersonbruker.tsx
// Operation `personbruker`: topbar + Detaljer-fane (lean, uten connections).
export const GET_PERSONBRUKER = gql`
  query personbruker($id: ID!) {
    personbruker(id: $id) {
      id
      navn
      feideId
      status
      organisasjoner { id navn }
      kanTildeleTilganger
      kanFjerneTilganger
      kanTildeleRoller
      kanFjerneRoller
      kanDeaktiveres
      kanReaktiveres
    }
  }
` as TypedDocumentNode<PersonbrukerQueryData, PersonbrukerQueryVariables>

// …/components/PersonbrukerTilganger/hooks/useGetPersonbrukerTilganger.tsx
// Operation `personbrukerMedTilganger`: Tilganger-fanens filtrerte, paginerte liste.
// (Roller-fanen får tilsvarende `personbrukerMedRoller` — eget hook-par, egen query.)
export const GET_PERSONBRUKER_MED_TILGANGER = gql`
  query personbrukerMedTilganger(
    $id: ID!
    $first: Int
    $after: String
    $filter: PersonbrukerTilgangerFilter
    $orderBy: PersonbrukerTildelingerOrderBy
  ) {
    personbruker(id: $id) {
      id
      tilganger(first: $first, after: $after, filter: $filter, orderBy: $orderBy) {
        nodes {
          id
          navn
          status
          organisasjon { id navn }
          tildeltAv { id navn }
          tildeltTidspunkt
          kanFjernes
        }
        totalCount
        pageInfo { endCursor hasNextPage }
      }
    }
  }
` as TypedDocumentNode<…>
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-PER-GRU-002 (kolonner Navn/Status/Organisasjon/Tildelt
  av/Tildelt dato; skille aktive/inaktive; filter på navn/status/organisasjon)
  og BRU-PER-GRU-007 (datagrupper Navn/Feide-ID/Organisasjon(er)/Status).
- **Form:** nøstede connections med samme filter/orderBy-form som toppnivå-
  lista, per `fs-sikt-no-producer-schema-design §Cursor Connections` — speiler
  `Applikasjon.tilganger`. «Tildelt dato» realiseres som
  `tildeltTidspunkt: LocalDateTime!` (konsistent med applikasjoner-mockens
  `opprettetTidspunkt`; UI formaterer dato). Sporingsfeltene (`tildeltAv`,
  `tildeltTidspunkt`) er UI-flaten for «sporbar i historikk» i v1
  (analysebeslutning #4). To separate detalj-operasjoner (lean `personbruker` +
  per-fane connection-query) gir uavhengige filter-variabler per fane og
  målrettede `refetchQueries` — samme splitt som applikasjoner
  (`applikasjonMedTilganger`).
- **Colocation-status:** Ikke best practice — speiler det transisjonelle
  mønsteret i området (se Op #1); revurderes ved teardown.
- **Alternativer vurdert:** én stor detalj-query med begge connections —
  forkastet: kobler fanenes filter-tilstand sammen og gjør refetch grovkornet
  (jf. `graphql-golden-path-overfetching`-problemet ved skjerm-store queries).

#### Op #3: `personbrukereFilterOptions` + `mineBrukerAdminOrganisasjoner` — filterkilder

**Dekker krav:** BRU-PER-GRU-001 (filterkildene)
**Implementeres av:** Task #1 (mock), Task #3 (consumer)

##### Lag A — Schema-tillegg

```graphql
extend type Query {
  "Filter-kilder utledet av brukerens synlighetsscope (ikke av aktivt filter)."
  personbrukereFilterOptions: PersonbrukereFilterOptions!
  "Organisasjoner den innloggede har brukeradministrator-rollen for. Styrer org-filter og modal-gating."
  mineBrukerAdminOrganisasjoner: [Organisasjon!]!
}

type PersonbrukereFilterOptions {
  "Roller tildelt minst én synlig personbruker. Alfabetisk på navn, distinct på rollekode."
  roller: [RolleValg!]!
  "Miljøer representert blant synlige tildelinger. Verdiene bak er demo/prod (spec-beslutning #4)."
  miljoer: [Miljo!]!
}

type RolleValg {
  rollekode: String!
  navn: String!
}
```

##### Lag B — fs-admin call-site

```ts
// …/PersonbrukereOverview/hooks/useGetPersonbrukereFilterOptions.tsx
export const GET_PERSONBRUKERE_FILTER_OPTIONS = gql`
  query personbrukereFilterOptions {
    personbrukereFilterOptions {
      roller { rollekode navn }
      miljoer { kode navn }
    }
  }
` as TypedDocumentNode<…>
// Konsumeres av RolleFilter/MiljoFilter (Select med «Alle …»-option).
// useGetMineBrukerAdminOrganisasjoner tilsvarende for OrganisasjonFilter.
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-PER-GRU-001 — «alle roller som er tildelt minst én
  personbruker i listen», «alle miljøer representert», «alle organisasjoner
  jeg har brukeradministrator-rollen for» (analysefunn #6).
- **Form:** semantiske felt med forretningskontekst i navnet per
  `fs-sikt-no-producer-schema-design §Vi innfører gjerne egne felt og typer for
  semantisk nyttige data-uttrekk` — speiler `mineApplikasjonsAdminOrganisasjoner`
  og `mineSynligeMiljoer`. Upaginert: kildene er små, avgrensede utvalg
  (unntaket i `fs-sikt-no-producer-best-practice §Paginering` for lister med
  god kontroll på antall).
- **Colocation-status:** Ikke best practice — speiler transisjonelt mønster
  (se Op #1).
- **Alternativer vurdert:** statiske/hardkodede kilder i frontend (som
  applikasjoner-modalene gjør midlertidig for miljø) — forkastet:
  analysebeslutning #5 valgte dedikerte queries; hardkodingen i applikasjoner
  er et kjent opprydningspunkt (analysefunn #8).

#### Op #4: `tildelbarePersonbrukerTilganger` + `tildelbarePersonbrukerRoller` — modal-kilder

**Dekker krav:** BRU-PER-GRU-003 (fler-valg-velgeren i tildel-modalene)
**Implementeres av:** Task #1 (mock), Task #6/#8 (consumer)

##### Lag A — Schema-tillegg

```graphql
extend type Query {
  "Valgbare tilganger gitt org + miljø. Krever brukeradministrator-rettighet for organisasjonen."
  tildelbarePersonbrukerTilganger(
    personbrukerId: ID!
    organisasjonId: ID!
    miljoKode: String!
  ): [TildelbarTilgang!]!
  tildelbarePersonbrukerRoller(
    personbrukerId: ID!
    organisasjonId: ID!
    miljoKode: String!
  ): [TildelbarRolle!]!
}

type TildelbarTilgang {
  tilgangskode: String!
  navn: String!
  alleredeTildelt: Boolean!
}

type TildelbarRolle {
  rollekode: String!
  navn: String!
  alleredeTildelt: Boolean!
}
```

##### Lag B — fs-admin call-site

```ts
// …/PersonbrukerTilganger/components/TildelTilgangModal/ bruker hook-paret
// useTildelbareTilganger (lazy — fyrer når org + miljø er valgt, kaskade-enabling
// som TildelTilgangModal i applikasjoner). Checkbox-liste over resultatet;
// `alleredeTildelt` rendres disabled med forklaring.
const [hentTildelbare, { data, loading }] = useLazyQuery(TILDELBARE_PERSONBRUKER_TILGANGER)
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-PER-GRU-003 — «Navn»-velgeren er fler-valg avgrenset av
  Organisasjon + Miljø (spec-beslutning #3); autorisasjon avgrenses på
  org-scope (spec-beslutning #7, håndheves server-side).
- **Form:** speiler `tildelbareTilgangskoder`/`TilgangskodeValg` fra
  applikasjoner-mocken 1:1 (samme argument-trio, samme `alleredeTildelt`-flagg).
  Upaginert liste: utvalget er avgrenset av org + miljø og konsumeres av en
  checkbox-liste som trenger hele utvalget; unntak per
  `fs-sikt-no-producer-best-practice §Paginering`. Subgraph-plan bør revurdere
  hvis reelle utvalg kan bli store (åpent spørsmål #2).
- **Colocation-status:** Ikke best practice — speiler transisjonelt mønster
  (se Op #1).

#### Op #5: `tildelPersonbrukerTilganger` + `fjernPersonbrukerTilganger` — med delvis suksess

**Dekker krav:** BRU-PER-GRU-003
**Implementeres av:** Task #1 (mock), Task #6 (consumer)

##### Lag A — Schema-tillegg

```graphql
extend type Mutation {
  tildelPersonbrukerTilganger(
    input: TildelPersonbrukerTilgangerInput!
  ): TildelPersonbrukerTilgangerResultat!
  fjernPersonbrukerTilganger(
    input: FjernPersonbrukerTilgangerInput!
  ): FjernPersonbrukerTilgangerResultat!
}

input TildelPersonbrukerTilgangerInput {
  personbrukerId: ID!
  organisasjonId: ID!
  miljoKode: String!
  tilgangskoder: [String!]!
}

input FjernPersonbrukerTilgangerInput {
  personbrukerId: ID!
  organisasjonId: ID!
  miljoKode: String!
  tilgangskoder: [String!]!
}

union TildelPersonbrukerTilgangerResultat =
  | TildelPersonbrukerTilgangerSuksess
  | MutasjonAvvist

"""
Delvis suksess (BRU-PER-GRU-003): mutasjonen fullfører selv om enkelte
elementer avvises. `avviste` er tom ved full suksess. `MutasjonAvvist`
(totalfeil, f.eks. manglende rettighet) betyr at ingenting ble endret.
"""
type TildelPersonbrukerTilgangerSuksess {
  personbruker: Personbruker!
  tildelte: [PersonbrukerTilgang!]!
  avviste: [TildelingAvvist!]!
}

union FjernPersonbrukerTilgangerResultat =
  | FjernPersonbrukerTilgangerSuksess
  | MutasjonAvvist

type FjernPersonbrukerTilgangerSuksess {
  personbruker: Personbruker!
  "Tilgangskodene som ble fjernet."
  fjernede: [String!]!
  avviste: [TildelingAvvist!]!
}

"Per-element-avvisning med årsak — «jeg ser tydelig hvilke som ikke ble gjennomført, og hvorfor»."
type TildelingAvvist {
  "Tilgangskode eller rollekode, avhengig av mutasjonen."
  kode: String!
  navn: String!
  arsak: TildelingAvvistArsak!
  feilmelding: String!
}

enum TildelingAvvistArsak {
  ALLEREDE_TILDELT
  "Kun relevant for fjern-mutasjonene."
  IKKE_TILDELT
  MANGLER_RETTIGHET
  UGYLDIG_TILSTAND
  UKJENT
}
```

##### Lag B — fs-admin call-site

```ts
// …/PersonbrukerTilganger/hooks/useTildelPersonbrukerTilganger.tsx
export const TILDEL_PERSONBRUKER_TILGANGER = gql`
  mutation tildelPersonbrukerTilganger($input: TildelPersonbrukerTilgangerInput!) {
    tildelPersonbrukerTilganger(input: $input) {
      __typename
      ... on TildelPersonbrukerTilgangerSuksess {
        personbruker { id antallTilganger }
        tildelte { id navn }
        avviste { kode navn arsak feilmelding }
      }
      ... on MutasjonAvvist {
        arsak
        feilmelding
      }
    }
  }
` as TypedDocumentNode<…>

export function useTildelPersonbrukerTilganger() {
  return useMutation(TILDEL_PERSONBRUKER_TILGANGER, {
    refetchQueries: ['personbrukerMedTilganger'],
    awaitRefetchQueries: true,
  })
}
// Konsument-switch på __typename: Suksess med avviste.length === 0 → lukk modal
// + suksessmelding; Suksess med avviste → hold modalen åpen og vis per-element-
// resultat (tildelte + avviste med årsak); MutasjonAvvist → inline-feil.
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-PER-GRU-003 — «Tildele flere … samtidig», «Delvis
  suksess ved samtidig tildeling», «Fjerne flere … samtidig», alt på org-scope
  (spec-beslutning #7).
- **Form:** toppnivåfelt på `Mutation` per `fs-sikt-no-producer-best-practice
  §Bare felt på Mutation-typen kan utføre endringer`; formålsbygde mutasjoner
  med non-null input-felt per `graphql-learn-mutations §Purpose-built
  mutations`. Konvolutten utvider applikasjoner-konvensjonen
  (`Resultat = Suksess | MutasjonAvvist`) med per-element-lister i
  suksess-varianten (analysebeslutning #2) — én atomisk operasjon med
  rapport, i stedet for N enkelt-mutasjoner (serielle toppnivåfelt gir ingen
  transaksjon uansett, jf. `graphql-learn-mutations §Multiple fields in
  mutations`). `refetchQueries` + `awaitRefetchQueries` for listeoppdatering
  — samme cache-strategi som `useTildelApplikasjonTilganger` (analysen,
  Technical Constraints).
- **Colocation-status:** Ikke best practice — speiler transisjonelt mønster
  (se Op #1).
- **Alternativer vurdert:** (a) alt-eller-ingenting — forkastet, dekker ikke
  kravet; (b) supergrafens `Errors`-union + `Error`-interface-mønster —
  utsatt til subgraph-plan (åpent spørsmål #1): mocken speiler nabofeaturen
  for konsistens i domenet, og frontend-switchen på `__typename` er robust
  for begge former.

#### Op #6: `tildelPersonbrukerRoller` + `fjernPersonbrukerRoller`

**Dekker krav:** BRU-PER-GRU-003
**Implementeres av:** Task #1 (mock), Task #8 (consumer)

##### Lag A — Schema-tillegg

```graphql
extend type Mutation {
  tildelPersonbrukerRoller(
    input: TildelPersonbrukerRollerInput!
  ): TildelPersonbrukerRollerResultat!
  fjernPersonbrukerRoller(
    input: FjernPersonbrukerRollerInput!
  ): FjernPersonbrukerRollerResultat!
}

input TildelPersonbrukerRollerInput {
  personbrukerId: ID!
  organisasjonId: ID!
  miljoKode: String!
  rollekoder: [String!]!
}

input FjernPersonbrukerRollerInput {
  personbrukerId: ID!
  organisasjonId: ID!
  miljoKode: String!
  rollekoder: [String!]!
}

union TildelPersonbrukerRollerResultat =
  | TildelPersonbrukerRollerSuksess
  | MutasjonAvvist

type TildelPersonbrukerRollerSuksess {
  personbruker: Personbruker!
  tildelte: [PersonbrukerRolle!]!
  avviste: [TildelingAvvist!]!
}

union FjernPersonbrukerRollerResultat =
  | FjernPersonbrukerRollerSuksess
  | MutasjonAvvist

type FjernPersonbrukerRollerSuksess {
  personbruker: Personbruker!
  "Rollekodene som ble fjernet."
  fjernede: [String!]!
  avviste: [TildelingAvvist!]!
}
```

##### Lag B — fs-admin call-site

Identisk form som Op #5 — eget hook-par
(`useTildelPersonbrukerRoller`/`useFjernPersonbrukerRoller`) med
`refetchQueries: ['personbrukerMedRoller']`, konsumert av
`TildelRolleModal`/`FjernRolleModal` (separate komponenter per
plan-beslutning #2).

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-PER-GRU-003 for roller (kravet omtaler «roller og
  tilganger» likestilt; skissens sub-frames 06/08 viser egne rolle-modaler).
- **Form:** som Op #5. Egne mutasjoner per entitet (ikke felles
  `tildelTildelinger` med type-diskriminator) per `graphql-learn-mutations
  §Purpose-built mutations` — gir non-null `rollekoder`-input og speiler
  beslutningen om separate modal-komponenter.
- **Colocation-status:** Ikke best practice — speiler transisjonelt mønster
  (se Op #1).
- **Alternativer vurdert:** felles mutasjon med `type`-felt — forkastet:
  nullable/utydelige inputs, og resultat-typene ville måtte unione
  tilgang/rolle.

#### Op #7: `deaktiverPersonbruker` + `reaktiverPersonbruker`

**Dekker krav:** BRU-PER-GRU-004
**Implementeres av:** Task #1 (mock), Task #9 (consumer)

##### Lag A — Schema-tillegg

```graphql
extend type Mutation {
  """
  Fryser brukerens tildelinger (status → INAKTIV) uten å fjerne dem.
  Frys/gjenopprettings-semantikken (utløpte tildelinger reaktiveres ikke)
  er backend-ansvar; klienten viser bare status og refetcher.
  """
  deaktiverPersonbruker(personbrukerId: ID!): DeaktiverPersonbrukerResultat!
  reaktiverPersonbruker(personbrukerId: ID!): ReaktiverPersonbrukerResultat!
}

union DeaktiverPersonbrukerResultat = DeaktiverPersonbrukerSuksess | MutasjonAvvist

type DeaktiverPersonbrukerSuksess {
  personbruker: Personbruker!
}

union ReaktiverPersonbrukerResultat = ReaktiverPersonbrukerSuksess | MutasjonAvvist

type ReaktiverPersonbrukerSuksess {
  personbruker: Personbruker!
}
```

##### Lag B — fs-admin call-site

```ts
// …/PersonbrukerDetails/hooks/useDeaktiverPersonbruker.tsx — speiler
// useDeaktiverApplikasjon. Suksess-varianten returnerer personbruker { id status
// kanDeaktiveres kanReaktiveres } slik at normalisert cache oppdaterer topbar-
// status uten refetch; tildelings-fanene refetches for INAKTIV-visning:
export function useDeaktiverPersonbruker() {
  return useMutation(DEAKTIVER_PERSONBRUKER, {
    refetchQueries: ['personbrukerMedTilganger', 'personbrukerMedRoller'],
    awaitRefetchQueries: true,
  })
}
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-PER-GRU-004 — deaktivere/reaktivere med
  bekreftelsesmodal (skisse-sub-frames 09/10); frys ivaretas av
  `TildelingStatus.INAKTIV` på tildelingene (Op #2).
- **Form:** speiler `deaktiverApplikasjon`/`reaktiverApplikasjon` 1:1.
  Enkelt-ID-argument (ikke input-objekt) — konsistent med nabofeaturen for
  én-parameters mutasjoner.
- **Colocation-status:** Ikke best practice — speiler transisjonelt mønster
  (se Op #1).

### Tverrgående schema-bekymringer

#### Permission-modell

Synlighet og redigeringsrett håndheves **server-side** (mock: persona-filtrering
som `filterTilgangerForPersona`, analysefunn #5). Klient-gating skjer
utelukkende via `kan*`-flaggene på `Personbruker` — frontend hardkoder aldri
rollekoder (analysebeslutning #7). Totalavvisning uttrykkes som `MutasjonAvvist
{ arsak: MANGLER_RETTIGHET }`.

#### Error-union-medlemmer

| Mutation | Resultat-union | Medlemmer |
|----------|----------------|-----------|
| `tildelPersonbrukerTilganger` | `TildelPersonbrukerTilgangerResultat` | `TildelPersonbrukerTilgangerSuksess`, `MutasjonAvvist` |
| `fjernPersonbrukerTilganger` | `FjernPersonbrukerTilgangerResultat` | `FjernPersonbrukerTilgangerSuksess`, `MutasjonAvvist` |
| `tildelPersonbrukerRoller` | `TildelPersonbrukerRollerResultat` | `TildelPersonbrukerRollerSuksess`, `MutasjonAvvist` |
| `fjernPersonbrukerRoller` | `FjernPersonbrukerRollerResultat` | `FjernPersonbrukerRollerSuksess`, `MutasjonAvvist` |
| `deaktiverPersonbruker` | `DeaktiverPersonbrukerResultat` | `DeaktiverPersonbrukerSuksess`, `MutasjonAvvist` |
| `reaktiverPersonbruker` | `ReaktiverPersonbrukerResultat` | `ReaktiverPersonbrukerSuksess`, `MutasjonAvvist` |

Per-element-avvisninger (delvis suksess) ligger i suksess-variantene som
`avviste: [TildelingAvvist!]!` — de er *resultatdata*, ikke operasjonsfeil.
Merk: det reelle supergraf-skjemaet bruker plural `Errors`-union +
`Error`-interface (verifisert ved grep: 7 unions, `interface Error`, 230
implementeringer) — se åpent spørsmål #1.

#### Sporings-felter

`tildeltAv`/`tildeltTidspunkt` legges på tildelingstypene **nå** (kravets
kolonner). Full endringshistorikk er backend-persistens uten UI i v1
(analysebeslutning #4); skjemaet må ikke utvides for BRU-PER-HIS her, men
subgraph-designet må persistere nok til at HIS-kravene kan bygges uten
datamodell-endring.

#### Versjonering

Alle deklarasjoner er nye — ingen `@deprecated`/`V2`-behov. Mock-SDL-en er
per definisjon eksperimentell; det reelle subgraf-skjemaet publiseres først
via subgraph-plan (per `fs-sikt-no-producer-schema-design §Endringer i API bør
ikke ødelegge for klienter` er det uproblematisk så lenge ingenting av dette
finnes i supergrafen i dag).

#### Nullability

Mocken speiler applikasjoner-SDL-ens non-null-tunge stil (referanse-SDL for
UI-utvikling). Reell subgraf bør vurdere nullable felter/`@semanticNonNull`
per `fs-sikt-no-producer-best-practice §Nullability` — føring til
subgraph-plan, ikke til mock-implementasjonen.

### Åpne spørsmål

- [ ] **1 — Konvolutt-form i reell subgraf:** Mocken følger applikasjoner-
      konvensjonen (`Resultat = Suksess | MutasjonAvvist`); supergrafen for
      øvrig bruker plural `Errors`-union + `Error`-interface. Subgraph-plan
      (fs-plattform, pipeline-steg 4) må velge endelig form — spesielt hvordan
      per-element-resultatet uttrykkes. Frontend-risikoen er lav
      (`__typename`-switch isolert i hooks), men teardown-kostnaden avhenger
      av svaret. **Blokkerer ikke mock-first-utviklingen; blokkerer teardown.**
- [ ] **2 — Nøkler for tilgang/rolle:** Mocken antar `tilgangskode` og
      `rollekode` som stabile identifikatorer (speiler applikasjoner).
      Subgraph-plan må bekrefte mot FS-datamodellen; rollekode-arbeidsverdiene
      (`brukeradministrator`/`super_brukeradministrator`) bekreftes mot
      rolledefinisjonsarbeidet i «4 - Opprette og administrere roller»
      (analysebeslutning #7). **Blokkerer teardown, ikke mock.**
- [ ] **3 — Kilde-merking av tilganger (design-spørsmål #6 fra spec-en):**
      `PersonbrukerTilgang` har bevisst ikke noe `tilknytning`-/kilde-felt
      (direkte vs. via rolle) — avventer design. Hvis design lander på
      kilde-merking, må feltet inn i mock + subgraf (à la applikasjoners
      `Tilknytning`). **Påvirker kolonner i Tilganger-fanen, ikke
      grunnstrukturen.**

## Implementation Tasks

### Task #1: Mock-API for personbrukere (`src/mocks/personbrukere/`) ✅

> ✅ Fullført 2026-07-08 — se [task-1-completion.md](task-1-completion.md)

**Priority**: High
**Size**: L
**Dependencies**: None
**Addresses Requirements**: BRU-PER-GRU-001–004, 007 (API-flaten for alle)

**Acceptance Criteria**:

- [ ] `schema/personbrukere.graphql` — referanse-SDL som realiserer hele
      GraphQL-seksjonen (Op #1–#7), med header-kommentar etter mønster fra
      `applikasjoner.graphql` (reference only, ikke codegen, teardown-pekere)
- [ ] `fixtures/` — 60+ personbrukere (paginering forbi 50 må kunne utøves),
      tildelinger med `tildeltAv`/`tildeltTidspunkt`, organisasjoner, miljøer
      (demo/prod), roller med arbeidsverdi-rollekoder; minst én deaktivert
      bruker med INAKTIVE tildelinger; minst ett element som gir avvisning ved
      tildel/fjern (delvis suksess demonstrerbar)
- [ ] `store/personbrukereStore.ts` — muterbar in-memory-state med reset (for
      tester), etter `applikasjonerStore`-mønsteret
- [ ] `handlers/queries.ts` — alle 6 queries med filter- (to fritekstfelt,
      status/org/rolle/miljø), sorterings- (NAVN_ASC/DESC + tie-break feideId)
      og pagineringssemantikk, samt persona-basert synlighet
      (brukeradministrator ser kun egne org-brukere)
- [ ] `handlers/mutations.ts` — alle 6 mutasjoner inkl. per-element-avvisning
      og frys-semantikk (deaktiver → alle tildelinger INAKTIV; reaktiver →
      AKTIV igjen)
- [ ] Handler-tester etter `queries.test.ts`-mønsteret (filter, sortering,
      tie-break, paginering, delvis suksess, persona-synlighet)
- [ ] Koblet inn i `src/mocks/handlers.ts` gated bak
      `NEXT_PUBLIC_ENABLE_PERSONBRUKER_MOCKS` (applikasjoner-mønsteret)
- [ ] `teardown-personbrukere.md` etter mal fra `teardown-applikasjoner.md`
      (inkl. de tre åpne spørsmålene fra GraphQL-seksjonen som sjekkpunkter)
- [ ] `npm run compile` upåvirket (mock allerede ekskludert via `!src/mocks/**/*`)

**Implementation Notes**:
Mock-SDL-fila blir input til subgraph-plan — hold den selvforklarende med
docstrings. Operation names i handlers er kontrakten mot frontend-hooks og må
ikke endres etter at consumer-tasks har startet.

### Task #2: Feature flag, ruter og navigasjonsinnganger ✅

> ✅ Fullført 2026-07-08 — se [task-2-completion.md](task-2-completion.md).
> NB: flagget må også opprettes i Unleash-serveren (GitLab feature flags,
> prosjekt 3136, prod av) før deploy, deretter `npm run generate:unleash`.

**Priority**: High
**Size**: M
**Dependencies**: None (kan gå parallelt med Task #1)
**Addresses Requirements**: BRU-PER-GRU-001 (inngangen til featuren)

**Acceptance Criteria**:

- [ ] Feature flag `tilgangsstyring-brukeradministrasjon` opprettet i Unleash
      med samme `environmentsOverride`-oppsett som `tilgangsstyring-meny`
      (dev/review/test på, prod av), og `npm run generate:unleash` kjørt
- [ ] Ruter: `src/app/tilgangsstyring/personbrukere/{layout,page}.tsx` og
      `personbrukere/[id]/{layout,page}.tsx` etter applikasjoner-mønsteret;
      page-komponentene rendrer inntil videre en enkel plassholder
      (byttes til feature-komponentene i Task #3/#4)
- [ ] Rutene gated bak flagget (samme mekanisme som applikasjoner-rutene);
      `npm run generate:routes` kjørt slik at typed `*Href` finnes
- [ ] Meny-underpunkt «Personbrukere» i `Menu.tsx` under Tilgangsstyring,
      gated bak både `tilgangsstyring-meny` og det nye flagget
- [ ] Aktivt «Personbrukere»-kort i `TilgangsstyringIndex` gated bak flagget
      (den deaktiverte Maskinbrukere-knappen røres ikke)
- [ ] i18n-nøkler for meny/kort/plassholder i `src/messages/nb/`
- [ ] a11y-tester for endrede komponenter passerer

**Implementation Notes**:
Ikke gjenbruk `personer`-flagget (eies av person-domenet, analysen Technical
Constraints). Brødsmulesti skal gi «Hjem > Tilgangsstyring > Personbrukere».

### Task #3: PersonbrukereOverview — listeside med filter, sortering og paginering ✅

> ✅ Fullført 2026-07-08 — se [task-3-completion.md](task-3-completion.md).
> NB: cacheConfig ligger i `src/common/lib/apollo/cacheConfig.ts` (planens
> `src/lib/apollo/`-sti finnes ikke).

**Priority**: High
**Size**: L
**Dependencies**: Task #1, Task #2
**Addresses Requirements**: BRU-PER-GRU-001

**Acceptance Criteria**:

- [ ] `PersonbrukereOverview.tsx` med `ListPageLayout` (actionbar uten
      Opprett-knapp — opprettelse er utenfor scope), filter-sidebar og
      resultatliste; rendres av `/tilgangsstyring/personbrukere`-ruten
- [ ] `hooks/useGetPersonbrukereState.tsx` — `useDataListState` med
      `initFirst: 50` og URL-synk for alle filterfelt + orderBy
- [ ] `hooks/useGetPersonbrukere.tsx` + `useGetPersonbrukereTypes.ts` —
      Op #1-queryen via `useDataListQuery` (TRANSITIONAL-kommentar som
      applikasjoner-hooks)
- [ ] `hooks/useGetPersonbrukereFilterOptions.tsx` +
      `useGetMineBrukerAdminOrganisasjoner.tsx` — Op #3-queriene
- [ ] `personbrukere`-queryen registrert i `src/lib/apollo/cacheConfig.ts` med
      `nodesCursorPagination(['filter', 'orderBy'])` — «Last inn flere»
      mister ikke rader
- [ ] Filterkomponenter under `components/filter/`: Navn (TextInput), Feide-ID
      (TextInput), Organisasjon (Select, kilde
      `mineBrukerAdminOrganisasjoner`, «Alle organisasjoner»-option), Rolle
      (Select, kilde `filterOptions.roller`, «Alle roller»), Status (Select,
      «Alle statuser»/Aktiv/Deaktivert), Miljø (Select, kilde
      `filterOptions.miljoer`, «Alle miljøer») — chips over lista via
      `filterElement`-slot
- [ ] `NavigationList`-rader med Navn, Feide-ID, Organisasjon(er), Status
      (status i `ListItemEndCell`); rad navigerer til detaljsiden med typed route
- [ ] Sortering NAVN_ASC (default)/NAVN_DESC; «Last inn flere» med
      `loadedCount`/`totalCount`; tom-/laste-/feiltilstander per
      list-results-konvensjonene («Ingen personbrukere funnet»)
- [ ] Unit- og a11y-tester for alle nye komponenter; i18n-nøkler på plass

**Implementation Notes**:
Kopiér strukturen fra `ApplikasjonerOverview` fil for fil. Tom-streng → null-
mapping i filter-variablene (samme fotfelle som `useGetApplikasjoner`
dokumenterer). Konsulter skills `fs-admin-list-pages`, `fs-admin-list-filters`
og `fs-admin-list-results` før koding.

### Task #4: PersonbrukerDetails — skjelett, topbar og Detaljer-fane ✅

> ✅ Fullført 2026-07-08 — se [task-4-completion.md](task-4-completion.md).
> Topbar-actions realisert som `actionsElement`-prop (fylles i Task #9);
> `NotFoundError`/`NoAccessError` fikk additiv `message`-prop.

**Priority**: High
**Size**: L
**Dependencies**: Task #1, Task #2
**Addresses Requirements**: BRU-PER-GRU-007 (+ rammen for 002/003/004)

**Acceptance Criteria**:

- [ ] `PersonbrukerDetails.tsx` — `DetailPageLayout` med tre faner
      (Detaljer/Tilganger/Roller) via `DetailPageTabbedContent`; rendres av
      `[id]`-ruten; `title` er personbrukerens navn (med oversatt fallback
      under lasting), `headingText` statisk etikett
- [ ] `hooks/useGetPersonbruker.tsx` — lean Op #2-query (operation
      `personbruker`); normalisert cache gir delvis rendering ved navigasjon
      fra lista
- [ ] `PersonbrukerTopBar/` — navn, status-tag (Aktiv/Deaktivert) og
      actions-slot (knappene kommer i Task #9)
- [ ] `PersonbrukerDetaljer/` — datagrupper Navn, Feide-ID, Organisasjon(er)
      (avledet, flertall), Status; ingen «Sist brukt» (utsatt, jf. spec)
- [ ] Tilganger/Roller-fanene rendrer midlertidige plassholdere (fylles i
      Task #5/#7)
- [ ] Feil-/ikke-funnet-tilstander via domenets `NotFoundError`/`NoAccessError`
- [ ] Unit- og a11y-tester; i18n-nøkler

**Implementation Notes**:
Kravets «seksjoner» realiseres som faner (etablert praksis, analysefunn #2).
Konsulter skillen `fs-admin-detail-pages` før koding.

### Task #5: PersonbrukerTilganger — Tilganger-fane med filter og liste ✅

> ✅ Fullført 2026-07-08 — se [task-5-completion.md](task-5-completion.md).
> Org-filterkilden er avledet av `Personbruker.organisasjoner` (ingen
> fane-nivå filter-options-query i mock/SDL).

**Priority**: High
**Size**: L
**Dependencies**: Task #4
**Addresses Requirements**: BRU-PER-GRU-002

**Acceptance Criteria**:

- [ ] `PersonbrukerTilganger/` med `DetailPageContentFilterAndResult`
      (obligatorisk — ikke håndrullet splitt)
- [ ] `hooks/useGetPersonbrukerTilgangerState.tsx` (URL-synket) +
      `useGetPersonbrukerTilganger.tsx` (operation `personbrukerMedTilganger`,
      Op #2) + typer
- [ ] Connection registrert i `cacheConfig.ts`
      (`Personbruker.fields.tilganger`, key-args `['filter', 'orderBy']`)
- [ ] Filter: Navn (TextInput), Status (Select «Alle statuser»/Aktiv/Inaktiv),
      Organisasjon (Select «Alle organisasjoner»)
- [ ] Liste med kolonner Navn, Status, Organisasjon, Tildelt av, Tildelt dato
      (formatert fra `tildeltTidspunkt`); aktive og inaktive visuelt skilt
      (status-tag); sortering NAVN_ASC/DESC; «Last inn flere»
- [ ] Actionbar med «Tildel tilganger»/«Fjern tilganger»-knapper gated på
      `kanTildeleTilganger`/`kanFjerneTilganger` (åpner modalene fra Task #6;
      inntil da disabled med TODO)
- [ ] Unit- og a11y-tester; i18n-nøkler

**Implementation Notes**:
`ApplikasjonTilganger` er kanonisk referanse for hele fanen, inkl.
state-hook-splitten og `filterElement`-wiring. Kolonnerekkefølge fra skissen
(sub-frame 03), feltene fra kravet.

### Task #6: TildelTilgangModal + FjernTilgangModal med delvis-suksess-håndtering ✅

> ✅ Fullført 2026-07-08 — se [task-6-completion.md](task-6-completion.md).
> Fjern-modalens kildeliste gjenbruker operation-navnet
> `personbrukerMedTilganger` (mocken har ingen egen fjernbare-handler);
> rename ved teardown er dokumentert i hooken.

**Priority**: High
**Size**: L
**Dependencies**: Task #5
**Addresses Requirements**: BRU-PER-GRU-003 (tilganger)

**Acceptance Criteria**:

- [ ] `TildelTilgangModal/` — Organisasjon-select (kilde
      `mineBrukerAdminOrganisasjoner`) → Miljø-select (kilde
      `filterOptions.miljoer`) → checkbox-fler-valg av tilganger (kilde Op #4,
      lazy når org+miljø er valgt, kaskade-enabling som applikasjoner);
      `alleredeTildelt` disabled med forklaring
- [ ] `FjernTilgangModal/` — destruktiv variant (`variant="critical"`, rød
      knapp jf. skisse) med fler-valg blant eksisterende AKTIVE tildelinger
      innen valgt org+miljø
- [ ] `hooks/useTildelPersonbrukerTilganger.tsx` +
      `useFjernPersonbrukerTilganger.tsx` — Op #5-mutasjonene med
      `refetchQueries: ['personbrukerMedTilganger']` +
      `awaitRefetchQueries: true`
- [ ] Delvis suksess: ved `avviste.length > 0` holdes modalen åpen og viser
      per-element-resultat (hva gikk gjennom, hva ble avvist, med årsak);
      full suksess lukker modalen med bekreftelse; `MutasjonAvvist` vises
      inline uten å lukke
- [ ] Async-knapper: `disabled` + progressiv label under mutasjon
      («Tildeler …»/«Fjerner …»)
- [ ] Unit-tester som dekker full suksess, delvis suksess og totalavvisning;
      a11y-tester; i18n-nøkler

**Implementation Notes**:
`TildelTilgangModal`/`FjernTilgangModal` i applikasjoner er malen for
kaskade-flyt og konsument-switch — men delvis-suksess-visningen er ny her.
Detaljert dialog-UX kan justeres når design-avklaringen (spec-spørsmål #6)
lander; grunnflyten er krav-bundet. Konsulter `fs-admin-buttons` og
`fs-admin-inputs`.

### Task #7: PersonbrukerRoller — Roller-fane ✅

> ✅ Fullført 2026-07-08 — se [task-7-completion.md](task-7-completion.md)

**Priority**: Medium
**Size**: M
**Dependencies**: Task #4 (mønster fra Task #5)
**Addresses Requirements**: BRU-PER-GRU-002 (roller)

**Acceptance Criteria**:

- [ ] `PersonbrukerRoller/` — samme form som Task #5 med egne komponenter og
      hooks (operation `personbrukerMedRoller`, egne queries — ingen deling
      med Tilganger-fanen)
- [ ] Connection registrert i `cacheConfig.ts` (`Personbruker.fields.roller`)
- [ ] Samme filter- og kolonnesett (Navn/Status/Organisasjon/Tildelt av/
      Tildelt dato), rollenavn + rollekode i rad-cellene
- [ ] Actionbar «Tildel roller»/«Fjern roller» gated på `kanTildeleRoller`/
      `kanFjerneRoller` (modaler i Task #8)
- [ ] Unit- og a11y-tester; i18n-nøkler

**Implementation Notes**:
Speil Task #5-strukturen; ikke abstraher felles komponenter mellom fanene i
denne omgangen (plan-beslutning #2 — evt. refaktorering tas som egen sak
senere hvis dupliseringen viser seg å svi).

### Task #8: TildelRolleModal + FjernRolleModal ✅

> ✅ Fullført 2026-07-08 — se [task-8-completion.md](task-8-completion.md)

**Priority**: Medium
**Size**: M
**Dependencies**: Task #7 (mønster fra Task #6)
**Addresses Requirements**: BRU-PER-GRU-003 (roller)

**Acceptance Criteria**:

- [ ] `TildelRolleModal/` + `FjernRolleModal/` — samme flyt som Task #6 med
      Op #4-rollekilden og Op #6-mutasjonene
      (`refetchQueries: ['personbrukerMedRoller']`)
- [ ] Delvis-suksess-håndtering identisk med Task #6 (samme
      `TildelingAvvist`-visning)
- [ ] Unit-tester (full/delvis/total-avvist), a11y-tester, i18n-nøkler

### Task #9: Deaktiver/Reaktiver personbruker ✅

> ✅ Fullført 2026-07-08 — se [task-9-completion.md](task-9-completion.md)

**Priority**: High
**Size**: M
**Dependencies**: Task #4
**Addresses Requirements**: BRU-PER-GRU-004

**Acceptance Criteria**:

- [ ] `PersonbrukerStatusActions` i topbaren: «Deaktiver bruker» (destruktiv,
      `variant="critical"`) når status er AKTIV og `kanDeaktiveres`;
      «Aktiver bruker» når DEAKTIVERT og `kanReaktiveres`
- [ ] `DeaktiverPersonbrukerModal/` + `ReaktiverPersonbrukerModal/` —
      bekreftelsesmodaler (skisse-sub-frames 09/10) som forklarer
      konsekvensen (tildelinger fryses/gjenopprettes, fjernes ikke)
- [ ] `hooks/useDeaktiverPersonbruker.tsx` + `useReaktiverPersonbruker.tsx` —
      Op #7-mutasjonene med refetch av begge tildelings-queries
- [ ] Etter deaktivering: status-tag oppdatert i topbar (normalisert cache),
      tildelinger vises som INAKTIV i fanene
- [ ] Async-knapper med progressiv label; unit- og a11y-tester; i18n-nøkler

**Implementation Notes**:
`DeaktiverApplikasjonModal`/`ReaktiverApplikasjonModal` +
`ApplikasjonStatusActions` er malen. Frys-semantikken er backend/mock-ansvar
(Task #1) — frontenden viser status og refetcher.

### Task #10: Master-detail-integrasjonstest og tverrgående gjennomgang ✅

> ✅ Fullført 2026-07-08 — se [task-10-completion.md](task-10-completion.md)
> (inkl. kravscenario-traceability-tabell). Fant og fikset stale
> `kan*`-gating etter deaktiver/reaktiver (Task #9-mutasjonene).

**Priority**: Medium
**Size**: M
**Dependencies**: Task #3–#9
**Addresses Requirements**: Alle (verifikasjon)

**Acceptance Criteria**:

- [ ] `src/domains/tilgangsstyring/integration/PersonbrukerMasterDetail.integration.test.tsx`
      etter `ApplikasjonMasterDetail`-mønsteret: liste → filtrer → naviger til
      detalj → tildel (inkl. delvis suksess) → fjern → deaktiver → reaktiver,
      mot mock-handlers
- [ ] Kravscenario-sjekk: hvert `@planned`-scenario i de fem .feature-filene
      er dekket av minst én test (unit eller integrasjon) eller eksplisitt
      notert som backend-ansvar
- [ ] `npm run lint`, `npm test`, `npm run test:a11y`,
      `npm run test:typecheck` grønne; coverage-terskler holdt
      (`npm run test:sincemain`)
- [ ] i18n-gjennomgang: ingen hardkodede norske strenger i ny kode
      (`/externalize-i18n` ved behov)

## Risk Assessment

### Technical Risks

- **Risk**: Skjema-drift mellom mock-SDL og det reelle subgraf-skjemaet
  (spesielt konvolutt-formen, åpent spørsmål #1) gir teardown-kostnad.
  - **Mitigation**: Mock-SDL-en er eksplisitt input til subgraph-plan
    (alfred kopierer den inn i task-mappen); konvolutt-switching er isolert i
    hooks; teardown-dokumentet (Task #1) lister de åpne spørsmålene som
    sjekkpunkter. Operation names holdes stabile.
- **Risk**: Design-avklaringen (direkte vs. via-rolle, spec-spørsmål #6) kan
  endre Tilganger-fanens kolonner og modal-innhold etter at Task #5/#6 er bygd.
  - **Mitigation**: Beslutningen påvirker kilde-merking, ikke grunnstrukturen
    (analysen, Cross-contributor). Bygg fanen uten kilde-felt; et evt.
    `tilknytning`-felt er additivt i både mock og UI.
- **Risk**: Manglende cacheConfig-registrering gir stille pagineringstap
  («Last inn flere» erstatter i stedet for å appende).
  - **Mitigation**: Egne akseptkriterier i Task #3/#5/#7; integrasjonstesten
    (Task #10) utøver paginering.
- **Risk**: Rollekode-arbeidsverdiene viser seg feil når
  rolledefinisjonsarbeidet lander.
  - **Mitigation**: Verdiene finnes kun i mock-fixtures (analysebeslutning #7);
    frontend gater på `kan*`-flagg.
- **Risk**: Flagget lekker featuren til prod før lansering.
  - **Mitigation**: `environmentsOverride` med prod av (Task #2), verifiseres
    i Unleash før merge.

### Testing Requirements

- Unit-tester for alle nye hooks og komponenter (Jest + RTL)
- a11y-test (`*.a11y.test.tsx`) for hver ny komponent — obligatorisk
- Handler-tester for mock-API-et (filter/sortering/paginering/delvis suksess/
  persona-synlighet)
- Integrasjonstest for master-detail-flyten (Task #10)
- Coverage: 60 % branches/functions/lines, 90 % statements
  (`npm run test:sincemain`)

## Success Criteria

- [ ] Alle akseptkriterier i Task #1–#10 oppfylt
- [ ] Alle fem krav (BRU-PER-GRU-001/002/003/004/007) demonstrerbare mot mock
  i review-miljø bak feature flag
- [ ] `npm run lint`, `npm test`, `npm run test:a11y`,
  `npm run test:typecheck` grønne
- [ ] Mock-SDL overlevert som input til subgraph-plan (pipeline-steg 4)
- [ ] Teardown-dokument på plass med de tre åpne GraphQL-spørsmålene som
  sjekkpunkter

## Requirements Traceability

| Requirement ID | Requirement Summary | Addressed by Task(s) | Status |
| -------------- | ------------------- | -------------------- | ------- |
| BRU-PER-GRU-001 | Listevisning og søk i personbrukere | #1, #2, #3 | Implemented (mot mock) |
| BRU-PER-GRU-002 | Se brukers tilganger og roller | #1, #4, #5, #7 | Implemented (mot mock) |
| BRU-PER-GRU-003 | Tildele og fjerne tilganger/roller (delvis suksess) | #1, #6, #8 | Implemented (mot mock) |
| BRU-PER-GRU-004 | Deaktivere og reaktivere bruker (frys) | #1, #9 | Implemented (mot mock) |
| BRU-PER-GRU-007 | Se detaljer for personbruker | #1, #4 | Implemented (mot mock) |
| Sporbarhet (003/004) | Backend-persistens; UI viser Tildelt av/dato | #1 (mock), subgraph-plan | UI implemented; persistens → subgraph-plan |
