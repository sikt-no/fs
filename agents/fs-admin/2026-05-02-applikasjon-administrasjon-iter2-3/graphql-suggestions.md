# GraphQL-forslag: Applikasjon-administrasjon (Iterasjon 2 + 3)

> **Følger fra:** [analysis-applikasjon-administrasjon-iter2-3.md](analysis-applikasjon-administrasjon-iter2-3.md)
> **Audience:** schema-eier (`sikt-no/fs` @ `fruitbat`) + fs-admin
> **Premiss:** **konservativ** — minst mulig schema-endring som dekker BRU-APP-API-001 til 010. Forslaget rører ikke ved felter som ikke kreves av iterasjon 2/3.
> **Domeneterm brukt:** `Applikasjon` (per analyse Key Finding #1; `Maskinbruker` er den nåværende termen og fases ut. Backend kan velge å beholde `Maskinbruker` som schema-type-navn og kun introdusere `Applikasjon` på nye felter — se *Åpne spørsmål* nederst.)
> **Status:** **DRY-RUN** — produsert for å validere `bat-graphql-dev`-skill-malen mot en reell analyse. Skopet er en *representativ delmengde* (5 av 10 BRU-APP-API-krav). De øvrige fem (004 passordbytte, 005 ansvarlig, 006 beskrivelse, 008 fjerne rolle, 010-reaktiver) følger samme former som de som er skissert her.

## Sammendrag

- **2 nye queries** (`Applikasjoner`, `ApplikasjonDetaljer`)
- **3 nye mutations** (`OpprettApplikasjon`, `TilordneRolleTilApplikasjon`, `DeaktiverApplikasjon`)
- **~12 nye / endrede typer og inputs**, hvorav 4 nye error-typer som implementerer `Error`-interfacet
- **5 tverrgående spørsmål** (se nederst)

## Operasjoner

---

### Op #1: `Applikasjoner` — paginert listevisning med filter og søk

**Dekker krav:** BRU-APP-API-001 (Listevisning og søk)

#### Lag A — Schema-tillegg

```graphql
# Nye felter på Applikasjon (utvider den eksisterende Maskinbruker-typen).
# Listet her i sin helhet for tydelighet — backend bør strengt tatt kun lese
# diff-en mot dagens type på line 19692.

type Applikasjon implements Node {
  # Eksisterende felter (ikke endret): id, brukernavn, organisasjon, kontaktperson, ...

  beskrivelse: String
  ansvarlig: Ansvarlig
  autentiseringstype: Autentiseringstype!
  miljoer: [Miljo!]!
  aktiv: Boolean!
  opprettetAv: AuthBruker
  opprettetTidspunkt: DateTime
  endretAv: AuthBruker
  endretTidspunkt: DateTime
}

enum Autentiseringstype {
  FS
  FEIDE
  MASKINPORTEN
}

enum Miljo {
  PROD
  DEMO
  TEST
}

# `ansvarlig` er enten en Feide-bruker eller en Feide-gruppe (analyse Key Finding #10)
union Ansvarlig = FeideBruker | FeideGruppe

type FeideBruker implements Node {
  id: ID!
  feideId: String!
  navn: String
  epost: String
}

type FeideGruppe implements Node {
  id: ID!
  gruppeId: String!
  navn: String
}

# Listevisning: utvid eksisterende MaskinbrukereFilter med felter krav-modellen forventer
input ApplikasjonerFilter {
  # Bevares (kompatibilitet)
  trengerPassordbytte: Boolean

  # Nye, jf. BRU-APP-API-001
  organisasjonId: ID
  autentiseringstype: Autentiseringstype
  aktiv: Boolean              # Oppfølgingsstatus: true=aktiv, false=deaktivert
  navnSok: String             # Server-side fritekst-søk på brukernavn (Fuse.js fjernes)
}

input ApplikasjonerOrderBy {
  field: ApplikasjonerOrderByField!
  direction: OrderDirection!  # eksisterer allerede i schema
}

enum ApplikasjonerOrderByField {
  Brukernavn
  Beskrivelse
  Organisasjon
  Autentiseringstype
  EndretTidspunkt
}

# Connection-typen følger eksisterende Relay-mønster
type ApplikasjonerConnection {
  edges: [ApplikasjonerConnectionEdge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type ApplikasjonerConnectionEdge {
  cursor: String!
  node: Applikasjon!
}

# Root: legg til på Query-typen
extend type Query {
  applikasjoner(
    first: Int
    after: String
    filter: ApplikasjonerFilter
    orderBy: ApplikasjonerOrderBy
  ): ApplikasjonerConnection!
}
```

#### Lag B — fs-admin call-site

```ts
// src/domains/support/features/Applikasjoner/queries.ts (forslag)
export const GET_APPLIKASJONER = gql(/* GraphQL */ `
  query Applikasjoner(
    $first: Int
    $after: String
    $filter: ApplikasjonerFilter
    $orderBy: ApplikasjonerOrderBy
  ) {
    applikasjoner(first: $first, after: $after, filter: $filter, orderBy: $orderBy) {
      pageInfo {
        hasNextPage
        endCursor
      }
      totalCount
      edges {
        cursor
        node {
          id
          brukernavn
          beskrivelse
          autentiseringstype
          aktiv
          miljoer
          organisasjon {
            id
            navn
            forkortelse
          }
          ansvarlig {
            ... on FeideBruker {
              id
              navn
              epost
            }
            ... on FeideGruppe {
              id
              navn
            }
          }
        }
      }
    }
  }
`)
```

```ts
// Skisse — IKKE for build, kun for reviewer
const { data, loading, error, fetchMore } = useQuery(GET_APPLIKASJONER, {
  variables: {
    first: 50, // krav-modellen: 50 om gangen
    filter: { aktiv: true, organisasjonId: valgtOrgId, navnSok: søketekst },
    orderBy: { field: 'Brukernavn', direction: 'ASC' },
  },
})
// "Last 50 til" → fetchMore({ variables: { after: data.applikasjoner.pageInfo.endCursor } })
```

#### Lag C — Begrunnelse

- **Krav:** BRU-APP-API-001 (Listevisning og søk).
- **Hvorfor denne formen:** Bytter ut dagens 1000-rader-klient-Fuse.js (analyse-Findings #5) med server-side Relay-paginering og server-side søk på `navnSok`. Filter-feltet utvides med `organisasjonId`, `autentiseringstype` og `aktiv` — disse driver tre separate filter-kontroller i UI som dagens `OrganisationConnectionEnum` ikke kan dekke.
- **Alternativer vurdert:**
  - *Tilby søk via globalt `search(...)` rotfelt* — forkastet: dagens listevisning vil filtrere + sortere + paginere i samme call, og en separat search-resolver tvinger to round-trips.
  - *Beholde `MaskinbrukereFilter`-navnet* — forkastet: navne-skiftet er definert som del av krav-domenet (analyse Key Finding #1), så input-typen bør følge samme term.

---

### Op #2: `ApplikasjonDetaljer` — detaljside med roller × miljø

**Dekker krav:** BRU-APP-API-002 (Se detaljer), BRU-APP-API-003 (Vise roller)

#### Lag A — Schema-tillegg

```graphql
# Roller-modellen kollapser fra to tabs (apiTilgangerV2 + datatilganger) til én
# tab med dimensjonene rolle × miljø (analyse-Findings #6).
# Forslag: ny relasjons-type RolletilordningPerMiljo erstatter dagens to felt.

type RolletilordningPerMiljo implements Node {
  id: ID!
  rolle: Rolle!
  miljo: Miljo!
  organisasjon: AuthOrganisasjon         # Hvilken org rollen gjelder for, om relevant
  tildeltAv: AuthBruker
  tildeltTidspunkt: DateTime
}

# `Rolle` finnes ikke i dag — krav-modellen forventer at den eksisterer som
# første-klasse, ikke avledet av apiTilganger/datatilganger.
type Rolle implements Node {
  id: ID!
  rollekode: String!
  beskrivelse: BeskrivelseAlleSprak  # følger eksisterende lokal-mønster
  api: Api                            # null hvis rollen er datatilgang, ikke API-tilgang
}

# Connection for roller på en applikasjon, med filter på rolle og miljø
type ApplikasjonRollerConnection {
  edges: [ApplikasjonRollerConnectionEdge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type ApplikasjonRollerConnectionEdge {
  cursor: String!
  node: RolletilordningPerMiljo!
}

input ApplikasjonRollerFilter {
  miljoer: [Miljo!]
  rolleIder: [ID!]
}

# Utvid Applikasjon-typen
extend type Applikasjon {
  roller(
    first: Int
    after: String
    filter: ApplikasjonRollerFilter
  ): ApplikasjonRollerConnection!
}

extend type Query {
  applikasjon(id: ID!): Applikasjon
}
```

#### Lag B — fs-admin call-site

```ts
// src/domains/support/features/Applikasjon/queries.ts (forslag)
export const GET_APPLIKASJON_DETALJER = gql(/* GraphQL */ `
  query ApplikasjonDetaljer($id: ID!, $rollerFilter: ApplikasjonRollerFilter) {
    applikasjon(id: $id) {
      id
      brukernavn
      beskrivelse
      autentiseringstype
      aktiv
      miljoer
      organisasjon {
        id
        navn
        forkortelse
      }
      ansvarlig {
        ... on FeideBruker {
          id
          navn
          epost
        }
        ... on FeideGruppe {
          id
          navn
        }
      }
      kontaktperson {
        id
        navn
        epost
        telefonnummer
      }
      opprettetAv {
        id
        navn
      }
      opprettetTidspunkt
      endretAv {
        id
        navn
      }
      endretTidspunkt
      roller(first: 50, filter: $rollerFilter) {
        pageInfo {
          hasNextPage
          endCursor
        }
        totalCount
        edges {
          node {
            id
            miljo
            rolle {
              id
              rollekode
              beskrivelse {
                nb
              }
              api {
                id
                navn
              }
            }
          }
        }
      }
    }
  }
`)
```

```ts
// Skisse — IKKE for build, kun for reviewer
const { data, loading } = useQuery(GET_APPLIKASJON_DETALJER, {
  variables: {
    id: applikasjonId,
    rollerFilter: { miljoer: ['PROD'], rolleIder: [] },
  },
})
```

#### Lag C — Begrunnelse

- **Krav:** BRU-APP-API-002 (sporing, miljøer, ansvarlig, beskrivelse) + BRU-APP-API-003 (én Roller-tab i stedet for to, dimensjon rolle × miljø).
- **Hvorfor denne formen:** Krav-modellens "én Roller-tab" tvinger en sammenslåing av dagens `apiTilgangerV2` + `datatilganger`. Forslaget introduserer `RolletilordningPerMiljo` som en eksplisitt relasjon — `api` på `Rolle` er nullable så datatilganger (uten API) faller naturlig inn. `Kontaktperson` beholdes ved siden av `Ansvarlig` (analyse Key Finding #10) i påvente av schema-eier-svar (se Åpent spørsmål 3).
- **Alternativer vurdert:**
  - *Beholde `apiTilgangerV2` og `datatilganger` parallelt og bare slå dem sammen i UI-laget* — forkastet: dimensjonene er ulike (API × tilgang vs rolle × miljø), så UI-koden måtte gjøre uforholdsmessig mye normalisering. Bryter også Findings #6 sin observasjon.
  - *Returnere `roller` som `[RolletilordningPerMiljo!]` uten Connection* — forkastet: krav-modellen forventer 50-batches også her.

---

### Op #3: `OpprettApplikasjon` — opprettelse med autentiseringstype-branching

**Dekker krav:** BRU-APP-API-009 (Opprette applikasjon)

#### Lag A — Schema-tillegg

```graphql
input OpprettApplikasjonInput {
  brukernavn: String!
  organisasjonId: ID!
  autentiseringstype: Autentiseringstype!
  beskrivelse: String
  ansvarligFeideBrukerId: ID            # Én av disse to settes (eller ingen),
  ansvarligFeideGruppeId: ID            # se "Open question 2" om validering.
  miljoer: [Miljo!]!

  # Påkrevd for FEIDE — ekstern Feide-applikasjons-ID som verifiseres mot Feide-API
  feideApplikasjonId: String

  # Påkrevd for MASKINPORTEN — Maskinporten-klient-ID som verifiseres
  maskinportenKlientId: String
}

type OpprettApplikasjonPayload {
  applikasjon: Applikasjon
  errors: [OpprettApplikasjonErrors!]!
}

union OpprettApplikasjonErrors =
    BrukernavnAlleredeIBruk
  | IkkeRettighetTilOrganisasjon
  | UgyldigAutentiseringstypeKonfigurasjon
  | EksternIdpVerifikasjonFeilet

type BrukernavnAlleredeIBruk implements Error {
  message: String!
  path: [String!]!
  konfliktMedApplikasjonId: ID
}

type IkkeRettighetTilOrganisasjon implements Error {
  message: String!
  path: [String!]!
  organisasjonId: ID!
}

type UgyldigAutentiseringstypeKonfigurasjon implements Error {
  message: String!
  path: [String!]!
  autentiseringstype: Autentiseringstype!
  manglendeFelter: [String!]!
}

type EksternIdpVerifikasjonFeilet implements Error {
  message: String!
  path: [String!]!
  idp: Autentiseringstype!         # FEIDE eller MASKINPORTEN
  eksternFeilkode: String
}

extend type Mutation {
  opprettApplikasjon(input: OpprettApplikasjonInput!): OpprettApplikasjonPayload!
}
```

#### Lag B — fs-admin call-site

```ts
// src/domains/support/features/Applikasjoner/queries.ts (forslag)
export const OPPRETT_APPLIKASJON = gql(/* GraphQL */ `
  mutation OpprettApplikasjon($input: OpprettApplikasjonInput!) {
    opprettApplikasjon(input: $input) {
      applikasjon {
        id
        brukernavn
      }
      errors {
        ... on Error {
          message
          path
        }
        ... on UgyldigAutentiseringstypeKonfigurasjon {
          autentiseringstype
          manglendeFelter
        }
        ... on EksternIdpVerifikasjonFeilet {
          idp
          eksternFeilkode
        }
      }
    }
  }
`)
```

```ts
// Skisse — IKKE for build, kun for reviewer
const [opprett, { loading, error }] = useMutation(OPPRETT_APPLIKASJON, {
  onCompleted: (data) => {
    const result = data.opprettApplikasjon
    if (result.errors.length === 0 && result.applikasjon) {
      router.push(`/tilgangsstyring/applikasjoner/${result.applikasjon.id}`)
    }
    // Errors ruter til form-felt-feilmeldinger via path[0]
  },
})
```

#### Lag C — Begrunnelse

- **Krav:** BRU-APP-API-009.
- **Hvorfor denne formen:** Én mutation med diskriminert input — `autentiseringstype` driver hvilke andre felter som er påkrevd (`feideApplikasjonId` ved FEIDE, `maskinportenKlientId` ved MASKINPORTEN, ingen ekstra ved FS). Dette gir én call-side i UI mens schema fortsatt validerer kombinasjonen via `UgyldigAutentiseringstypeKonfigurasjon`-error. Maskinporten-verifikasjon (analyse Findings #4 — ny ekstern integrasjon) flagges via `EksternIdpVerifikasjonFeilet` så UI kan vise riktig feilmelding.
- **Alternativer vurdert:**
  - *Tre separate mutations* (`opprettFsApplikasjon`, `opprettFeideApplikasjon`, `opprettMaskinportenApplikasjon`) — forkastet: dupliserer `beskrivelse`/`ansvarlig`/`organisasjon`/`miljoer`, og UI-formen er én form med én "Opprett"-knapp uansett.
  - *Gjøre `feideApplikasjonId` og `maskinportenKlientId` til en union/oneof-input* — forkastet: GraphQL har ikke native `@oneOf` på input ennå (avhengig av server-versjon), og kompliserer typen mer enn det forenkler.

---

### Op #4: `TilordneRolleTilApplikasjon` — rolle × miljø-tildeling

**Dekker krav:** BRU-APP-API-007 (Tilordne rolle)

#### Lag A — Schema-tillegg

```graphql
input TilordneRolleTilApplikasjonInput {
  applikasjonId: ID!
  rolleId: ID!
  miljoer: [Miljo!]!     # Multi-select: én call kan tilordne samme rolle i PROD+DEMO+TEST
  organisasjonId: ID     # Påkrevd hvis rollen er org-skopert (datatilgang); null for API-tilgang
}

type TilordneRolleTilApplikasjonPayload {
  applikasjon: Applikasjon
  rolletilordninger: [RolletilordningPerMiljo!]!
  errors: [TilordneRolleTilApplikasjonErrors!]!
}

union TilordneRolleTilApplikasjonErrors =
    ApplikasjonFinnesIkke
  | RolleFinnesIkke
  | RolleAlleredeTilordnet
  | IkkeRettighetTilOrganisasjon
  | UgyldigRolleForAutentiseringstype

type ApplikasjonFinnesIkke implements Error {
  message: String!
  path: [String!]!
  applikasjonId: ID!
}

type RolleFinnesIkke implements Error {
  message: String!
  path: [String!]!
  rolleId: ID!
}

type RolleAlleredeTilordnet implements Error {
  message: String!
  path: [String!]!
  miljo: Miljo!
}

type UgyldigRolleForAutentiseringstype implements Error {
  message: String!
  path: [String!]!
  autentiseringstype: Autentiseringstype!
  rolleId: ID!
}

extend type Mutation {
  tilordneRolleTilApplikasjon(
    input: TilordneRolleTilApplikasjonInput!
  ): TilordneRolleTilApplikasjonPayload!
}
```

#### Lag B — fs-admin call-site

```ts
// src/domains/support/features/Applikasjon/queries.ts (forslag)
export const TILORDNE_ROLLE_TIL_APPLIKASJON = gql(/* GraphQL */ `
  mutation TilordneRolleTilApplikasjon($input: TilordneRolleTilApplikasjonInput!) {
    tilordneRolleTilApplikasjon(input: $input) {
      applikasjon {
        id
      }
      rolletilordninger {
        id
        miljo
        rolle {
          id
          rollekode
        }
      }
      errors {
        ... on Error {
          message
          path
        }
      }
    }
  }
`)
```

```ts
// Skisse — IKKE for build, kun for reviewer
const [tilordne] = useMutation(TILORDNE_ROLLE_TIL_APPLIKASJON, {
  refetchQueries: [GET_APPLIKASJON_DETALJER], // Roller-tab oppfriskes
})

// Bruker velger rolle og krysser av miljøer i én dialog → én call
void tilordne({
  variables: {
    input: {
      applikasjonId,
      rolleId,
      miljoer: ['PROD', 'DEMO'],
      organisasjonId: null,
    },
  },
})
```

#### Lag C — Begrunnelse

- **Krav:** BRU-APP-API-007.
- **Hvorfor denne formen:** `miljoer: [Miljo!]!` lar én UI-handling tildele samme rolle i flere miljøer på én gang — en svært vanlig support-flyt (gi rollen i PROD + DEMO samtidig). `organisasjonId` er nullable fordi rollen kan være enten API-skopert (uten org) eller data-skopert (med org). `RolleAlleredeTilordnet` returnerer `miljo` så UI kan vise *hvilket* miljø som var konflikten.
- **Alternativer vurdert:**
  - *Én call per miljø* — forkastet: gir N round-trips for støtte-personalets vanligste flyt og bryter med BRU-APP-API-007 sin "atomær" forventning.
  - *`miljo: Miljo!` (singular)* — forkastet av samme grunn.

---

### Op #5: `DeaktiverApplikasjon` — deaktivere uten å slette

**Dekker krav:** BRU-APP-API-010 (Deaktivere)

#### Lag A — Schema-tillegg

```graphql
input DeaktiverApplikasjonInput {
  applikasjonId: ID!
  begrunnelse: String      # Valgfritt — krav forventer fritekst-felt for sporing
}

type DeaktiverApplikasjonPayload {
  applikasjon: Applikasjon
  errors: [DeaktiverApplikasjonErrors!]!
}

union DeaktiverApplikasjonErrors =
    ApplikasjonFinnesIkke
  | ApplikasjonAlleredeDeaktivert
  | IkkeRettighetTilOrganisasjon

type ApplikasjonAlleredeDeaktivert implements Error {
  message: String!
  path: [String!]!
  deaktivertTidspunkt: DateTime!
}

extend type Mutation {
  deaktiverApplikasjon(input: DeaktiverApplikasjonInput!): DeaktiverApplikasjonPayload!
}
```

#### Lag B — fs-admin call-site

```ts
// src/domains/support/features/Applikasjon/queries.ts (forslag)
export const DEAKTIVER_APPLIKASJON = gql(/* GraphQL */ `
  mutation DeaktiverApplikasjon($input: DeaktiverApplikasjonInput!) {
    deaktiverApplikasjon(input: $input) {
      applikasjon {
        id
        aktiv
      }
      errors {
        ... on Error {
          message
          path
        }
      }
    }
  }
`)
```

```ts
// Skisse — IKKE for build, kun for reviewer
const [deaktiver, { loading }] = useMutation(DEAKTIVER_APPLIKASJON, {
  // Apollo cache-oppdatering: aktiv-feltet flippes automatisk siden id er identifier
})
```

#### Lag C — Begrunnelse

- **Krav:** BRU-APP-API-010.
- **Hvorfor denne formen:** Deaktivering er et state-skifte (`aktiv: true → false`), ikke en sletting. Returnerer `applikasjon` så Apollo-cachen kan oppdatere `aktiv`-feltet på alle ko-lokerte queries automatisk via `id`-merging — ingen `refetchQueries` nødvendig. `begrunnelse` er valgfri men forventet brukt — krav-modellen ber om sporing.
- **Alternativer vurdert:**
  - *Generisk `setApplikasjonAktiv(id, aktiv)`* — forkastet: krav definerer *deaktivere* og *reaktivere* som to separate brukerhandlinger med ulike rettigheter (analyse Krav-input). To eksplisitte mutations gir bedre auditabilitet og mer presise error-unioner.

---

## Tverrgående schema-bekymringer

### Permission-modell

**Forslag:** Hybrid — server-side `Me.kanAdministrereApplikasjoner(organisasjonId: ID): Boolean!` for å gate UI-knapper *før* mutation, **og** `IkkeRettighetTilOrganisasjon`-error i hver mutation som final autoritativ sjekk.

```graphql
extend type Me {
  kanAdministrereApplikasjoner(organisasjonId: ID!): Boolean!
  erSuperApplikasjonsadministrator: Boolean!
}
```

Begrunnelse: ren klient-policy bryter med "skopering kan endres uten klient-redeploy"-prinsipp. Ren mutation-feilkode tvinger UI til å vise "Opprett"-knappen til alle og avsløre at handlingen feilet etter klikk. Kombinasjonen lar UI gjøre *optimistisk skjul* og samtidig være *trygt* mot privilege escalation.

### Error-union-medlemmer (samlet)

| Mutation | Error-union | Medlemmer |
|----------|-------------|-----------|
| `opprettApplikasjon` | `OpprettApplikasjonErrors` | `BrukernavnAlleredeIBruk`, `IkkeRettighetTilOrganisasjon`, `UgyldigAutentiseringstypeKonfigurasjon`, `EksternIdpVerifikasjonFeilet` |
| `tilordneRolleTilApplikasjon` | `TilordneRolleTilApplikasjonErrors` | `ApplikasjonFinnesIkke`, `RolleFinnesIkke`, `RolleAlleredeTilordnet`, `IkkeRettighetTilOrganisasjon`, `UgyldigRolleForAutentiseringstype` |
| `deaktiverApplikasjon` | `DeaktiverApplikasjonErrors` | `ApplikasjonFinnesIkke`, `ApplikasjonAlleredeDeaktivert`, `IkkeRettighetTilOrganisasjon` |

Alle error-typer implementerer eksisterende `Error`-interfacet ([schema.graphql:10306](../../schema.graphql#L10306)) — `message: String!` og `path: [String!]!`. Domain-spesifikke felter er additive.

### Sporings-felter (`opprettetAv`, `endretAv`, ...)

**Anbefales:** legges på `Applikasjon`-typen **nå**, ikke senere. Iterasjon 4 (#436, `endringslogg.feature`) avhenger av disse. Å innføre dem retroaktivt betyr datamigrering eller `null`-felter på alle eksisterende rader. Bedre å betale kostnaden én gang nå.

`AuthBruker` antas å allerede eksistere som basetype — bekreft (Åpent spørsmål 5).

### Versjonering

**Anbefales:** Nye mutations beholder navnene fra forslaget (`opprettApplikasjon`, ikke `opprettApplikasjonV2`). Eksisterende `genererOgSettNyttPassord` ([schema.graphql:20840](../../schema.graphql#L20840)) bevares uendret — passordbytte er allerede en del av Iterasjon 2 og UI-en får bare en gating-justering, ikke schema-endring.

`Maskinbruker`-typen kan beholdes som schema-side-alias for `Applikasjon` i en deprecation-periode hvis schema-eier ønsker. Forslaget tar ikke stilling.

### Discovery-side (Confluence side 4612784227)

Analyse-dependency 4 viser til Confluence-side om Feide-/Maskinporten-verifikasjon. Forslaget antar at verifikasjonsregler er som beskrevet der. Hvis siden inneholder ekstra valideringer (f.eks. "Maskinporten-klient-ID må eksistere i Maskinporten-API før applikasjonen kan opprettes"), må disse reflekteres i `EksternIdpVerifikasjonFeilet`-error eller i nye error-typer.

## Åpne spørsmål til schema-eier

1. **Type-navn vs term-skift:** Skal vi (a) endre type-navnet `Maskinbruker` → `Applikasjon` direkte i schema, eller (b) beholde `Maskinbruker` som schema-type og bare introdusere `Applikasjon` som term i nye felter/inputs/payloads? Valg (b) gir backward-compat, valg (a) er renere langsiktig. Fs-admin må gjøre samme renaming uansett — schema-valget styrer bare om vi får én eller to navn å forholde oss til i en periode.

2. **`ansvarligFeideBrukerId` vs `ansvarligFeideGruppeId`:** Skal kun *én* settes, kan *ingen* settes (uten ansvarlig), eller skal det modelleres med en oneOf/union-input? Forslaget antar at maks én settes og at backend validerer dette med `UgyldigAutentiseringstypeKonfigurasjon` ved konflikt. Bekreft.

3. **`Kontaktperson` vs `Ansvarlig`:** Beholdes `Kontaktperson` ved siden av `Ansvarlig` (analyse Key Finding #10), eller fases den ut? Hvis utfases — er det i denne iterasjonen eller senere? Påvirker hvilke felter som returneres i `ApplikasjonDetaljer`-query.

4. **Permission-modellens scope:** Er `kanAdministrereApplikasjoner(organisasjonId: ID!)` riktig signatur, eller må den støtte både organisasjons-skopert og global super-admin? Forslagets `erSuperApplikasjonsadministrator: Boolean!` antar todelt modell.

5. **`AuthBruker`:** Forslaget bruker `AuthBruker` som type for `opprettetAv` og `endretAv`. Bekreft at den eksisterer (eller at riktig navn er noe annet — `Bruker`, `AuthSubject`, etc.).

## Hand-off-pakke

- **Repo / ref:** `sikt-no/fs` @ `fruitbat`
- **Foreslått issue-tittel:** `[applikasjon-administrasjon] Schema-utvidelse for Iterasjon 2 + 3 (BRU-APP-API-001 til 010)`
- **Skal linkes som blocker for:** initiativ-issue [#31](https://github.com/sikt-no/fs/issues/31), iter 2 [#434](https://github.com/sikt-no/fs/issues/434), iter 3 [#435](https://github.com/sikt-no/fs/issues/435)
- **Foreslått label på upstream-side:** `agent:<schema-owner-agent-id>` (krever `agent-coord`-oppslag for korrekt id)
- **Forslag til hand-off-melding:**
  > Vi har analysert iterasjon 2 + 3 av initiativ #31 og identifisert at ~80 % av kravene avhenger av schema-utvidelser som ikke finnes i dag. Vedlagt dokument inneholder konkrete forslag til 2 queries, 3 mutations, og ~12 nye/endrede typer som dekker en representativ delmengde (de øvrige 5 kravene følger samme former). Fem åpne spørsmål blokkerer endelig implementasjon — særlig type-navn-skiftet (Q1) og permission-modellen (Q4). Vi ønsker en avklaringsrunde før noen av endringene merges.
