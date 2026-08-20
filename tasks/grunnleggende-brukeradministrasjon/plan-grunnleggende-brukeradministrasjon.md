# Plan: Grunnleggende brukeradministrasjon (personbrukere)

> Backend i `tilgangsstyring`-subgrafen + migrering av fs-admin-prototypen (branch
> `BAT-185-grunnleggende-brukeradministrasjon-v-1-frontend`) fra MSW-mock til ekte API.
> Scope: BRU-PER-GRU-001–004 (prototypens omfang). Se
> [`spec-grunnleggende-brukeradministrasjon.md`](spec-grunnleggende-brukeradministrasjon.md) og
> [`analysis-grunnleggende-brukeradministrasjon.md`](analysis-grunnleggende-brukeradministrasjon.md).

## Proposed Solution

### Architecture Approach

Brukeradministrasjonen bygges som en tro kopi av applikasjonsadministrasjonens vertikale snitt,
på samme datamodell: Liquibase-migrasjon → pgTAP → jOOQ-regen → Graphitron-skjema → `@service`-
klasser → Quarkus-IT → fs-admin-migrering. Autorisasjon håndheves utelukkende i databasen (RLS +
`SECURITY INVOKER`-funksjoner); Java-laget beregner ingen rettigheter.

Arbeidet deles i **én liten felles grunnmur** pluss **to uavhengige vertikaler** for to
fullstack-utviklere:

- **Vertikal A — oversikt, detalj, deaktiver/reaktiver.** Eier `feide_bruker`-lesing og status.
  Kan leveres og demos uavhengig av B og av fase4-branchen.
- **Vertikal B — tildelinger.** Eier `subjektrolletildeling`-flaten: visning av tilganger/roller
  og tildel/fjern-mutasjonene. Bygger på fase4-tildel-fjern-maskineriet.

### Key Technical Decisions

1. **Utvid `FeideBruker`, ikke ny `Personbruker`-type.**
   - Hvorfor: `FeideBruker` finnes med `@node(typeId: "20016")` og federert `@key(fields: "brukernavn")`
     (steg 1 mot SIS' personProfil). En parallell type over samme tabell gir to node-id-er for samme
     entitet og bryter SIS-koblingen. Kravterminologien «personbruker» legges i doc-strings.
   - Konsekvens: **`navn` finnes ikke i denne subgrafen** (persondata eies av SIS). Oversikten viser
     `brukernavn` inntil navn kommer via federation. Flagget som avklaring mot produkteier.
   - Alternativ vurdert: egen `Personbruker`-view-type — forkastet (dobbel identitet, mer kode, samme data).

2. **Tilgang vs. rolle: ny katalogkolonne `rolle.rolletype`.**
   - Hvorfor: kravene (og begrepsbruk.md) skiller *tilgang* (atom) fra *rolle* (sammensatt) som
     semantisk lag; ingen eksisterende kolonne bærer dette. Avledning fra `rolle_implikasjon` er skjør
     (klassifiseringen flipper når implikasjoner utløper); `navneromstype` er eierskaps-akse, ikke art.
   - Løsning: `rolletype TEXT NOT NULL DEFAULT 'TILGANG' CHECK (rolletype IN ('TILGANG','ROLLE'))`
     + seed-klassifisering av dagens katalog + pgTAP-konsistenstest («rolle med aktiv utgående
     implikasjon er ROLLE»).

3. **Én tildelingstype `FeideBrukerTildeling` over eksisterende view `subjektrolletildeling_med_arv`.**
   - Hvorfor: viewet er subjekt-generisk (0021). GUI-ets to seksjoner (roller/tilganger) blir to kall
     mot samme connection med `rolletype`-filter — ikke to typer, ikke fire mutasjoner.
   - Viewet utvides bakoverkompatibelt (`CREATE OR REPLACE`, kolonner appendes): `tildelt_av_bruker`,
     `tildelt_tidspunkt`, `rolletype`. `ApplikasjonTilgang` gjenbrukes ikke ved navn (feil domenenavn;
     fase4 gir den app-semantikk og typeId 20018) — søstertype med typeId **20019**.

4. **Deaktiver/reaktiver bruker speiler applikasjonsmønsteret.**
   - `deaktivert_tidspunkt` + GENERATED `status` + aktørkolonner m/ CHECK på `feide_bruker`
     (mal: 0017/0026). Håndheves i autentiseringsstien: `tilganger_for_feidetjeneste_og_bruker`
     (siste definisjon i 0018 — kommentaren «personer kan ikke deaktiveres» fjernes) filtrerer
     `deaktivert_tidspunkt IS NULL`; alle funksjoner som slår opp `feide_bruker.feide_id` sjekkes.
   - «Frys» faller ut gratis: tildelingene røres ikke, så tidsutløp fortsetter å løpe under
     deaktivering (GRU-004s «utløpte reaktiveres ikke» er automatisk oppfylt). Mockens per-tildeling
     `TildelingStatus` droppes — klienten deriverer visning fra `FeideBruker.status`.

5. **Mutasjonspayload som tåler både alt-eller-ingenting og delvis suksess.**
   - `Error`-interfacet har `path: [String!]!` som identifiserer input-elementet. Alt-eller-ingenting =
     tom resultatliste + første feil i `errors`; delvis suksess = vellykkede i resultatlisten + avviste
     i `errors` med path. Den blokkerende kravavklaringen (GRU-003) blir dermed en ren
     service-lag-beslutning (transaksjonsgrense i `ctx.transactionResult`), ikke en skjemabeslutning.
     Inntil avklaring implementeres alt-eller-ingenting (plattformmønsteret), med doc-string-markør.

6. **Gjenbruk fase4-maskineriet for tildelingsrett.**
   - RLS-policyene og funksjonene fra `fase4-tildel-fjern`/0035 (`krev_tildelingsrett`,
     `effektiv_tilgang`, `krev_tilgangskode`, privilegiet `BRUKERADMIN_TILDELING_SKRIV`) er
     subjekt-agnostiske. Nytt: `krev_feide_bruker` + `tildel_brukertilgang`/`fjern_brukertilgang`
     (tynne kopier av `tildel_tilgang`/`fjern_tilgang` med bruker-eksistenssjekk).
   - Eget privilegium for person-tildeling er mulig innstramming senere (avklaring, ikke blokkerende).

7. **Ny skjemafil `schema_brukeradmin.graphqls`.**
   - pom-en laster `experimental/**` som glob (`tilgangsstyring-app/pom.xml`), så en søsterfil ved
     siden av `schema_exp.graphqls` fjerner nesten hele merge-konflikt-flaten mot main og fase4.
   - Risiko som verifiseres i grunnmuren: at Graphitron godtar `extend type FeideBruker` på tvers av
     filer; fallback er å flytte FeideBruker-blokken inn i den nye filen.

8. **Ingen `kan*`-flagg, ingen `mineTilganger` i denne planen.**
   - Arkitekten har avvist server-beregnede rettighetsflagg (`docs/tilgangsmodell.md`). Klient-gating
     via `mineTilganger` eies av andre utviklere. Frontend-migreringen fjerner flaggene og deriverer
     knappesynlighet fra data den allerede har (`tilknytning`, `mineTildelingsorganisasjoner`,
     egen tildelingsliste) + gating-mekanismen når den lander.

### File Changes Overview

**tilgangsstyring (backend):**

- `tilgangsstyring-app/src/main/resources/schema/features/experimental/schema_brukeradmin.graphqls` — NY (all skjemaendring; A/B-soner)
- `tilgangsstyring-new-db/src/main/resources/db/changelog/0033-deaktivering-feide-bruker.sql` — NY (Vertikal A)
- `tilgangsstyring-new-db/src/main/resources/db/changelog/0034-rolletype-og-tildelingsvisning.sql` — NY (grunnmur)
- `tilgangsstyring-new-db/src/main/resources/db/changelog/0036-tildel-og-fjern-brukertilganger.sql` — NY (Vertikal B, etter fase4/0035)
- `tilgangsstyring-new-db/src/main/resources/db/changelog/db-changelog-root.xml` — 3 nye includes (koordinert)
- `tilgangsstyring-new-db/src/test/sql/30_deaktivering_feide_bruker.sql`, `32_rolletype_og_tildelingsvisning.sql`, `33_tildel_og_fjern_brukertilganger.sql` — NYE pgTAP-suiter
- `tilgangsstyring-new-jooq/**` — regenerert (serielt: grunnmur → A → B) + syntetiske nøkler i pom
- `tilgangsstyring-service/.../FeideBrukerStatusService.java`, `FeideBrukereFilterConditions.java`, `FeideBrukerTildelingerFilterConditions.java`, `FeideBrukerTilgangService.java` + records — NYE
- `tilgangsstyring-app/src/test/java/.../BrukerstatusmutasjonerGraphqlTest.java`, `FeideBrukereQueryTest.java`, `BrukertildelingsmutasjonerGraphqlTest.java` — NYE (maler: `SkrivemutasjonerGraphqlTest`, fase4s `TildelingsmutasjonerGraphqlTest`)

**fs-admin (frontend, på/etter BAT-185-branchen):**

- `src/domains/tilgangsstyring/features/PersonbrukereOverview/**` — hooks skrives om til ekte operasjoner + codegen; kolonner justeres (brukernavn)
- `src/domains/tilgangsstyring/features/PersonbrukerDetails/**` — detalj, status-modaler, Tilganger-/Roller-faner, Tildel-/Fjern-modaler mot ekte API
- `codegen.ts` — fjern personbruker-ekskluderinger etter hvert som hooks migreres
- `src/mocks/personbrukere/**` — rives når begge vertikaler er migrert; `src/mocks/handlers.ts` + `NEXT_PUBLIC_ENABLE_PERSONBRUKER_MOCKS` ryddes
- `src/common/lib/apollo/cacheConfig.ts` — key-args oppdateres til nye operasjons-/feltnavn

## GraphQL-endringer

> **Premiss:** konservativ — minste skjemaendring som dekker GRU-001–004; gjenbruker eksisterende typer/enums der de finnes.
> **Domeneterm:** `FeideBruker` (teknisk type; kravets «personbruker» brukes i doc-strings). `Tildeling` for rader i arv-viewet; `tilgang`/`rolle` skilles med `rolletype` (besluttet 2026-08-20, jf. begrepsbruk.md).
> **Følger fra:** [`analysis-grunnleggende-brukeradministrasjon.md`](analysis-grunnleggende-brukeradministrasjon.md) — GAP-matrisen (rad GRU-001–004).

### Sammendrag

- 2 nye queries (`feideBrukere`, `mineSynligeBrukerroller`) + 5 nye felt på `FeideBruker`
- 4 nye mutations (`tildelFeideBrukerTilganger`, `fjernFeideBrukerTilganger`, `deaktiverFeideBrukere`, `reaktiverFeideBrukere`)
- 1 ny node-type (`FeideBrukerTildeling`, typeId 20019), 1 nytt felt på `Tilgangsrolle` (`rolletype`), 6 inputs, 4 payloads, 3 error-unions, 1 ny feiltype (`FeideBrukerIkkeFunnet`)
- 4 åpne spørsmål (se nederst)

Merk om subgraf-idiom: dette er Graphitron-skjemaet til tilgangsstyring-subgrafen, ikke SuperGrafen
direkte. Graphitron-lister med `@asConnection` genererer Relay-connection (`nodes`/`totalCount`/
`pageInfo`) i publisert skjema; direktivene under (`@table`, `@node`, `@field`, `@reference`,
`@condition`, `@splitQuery`, `@error`, `@service`) er kodegen-instruksjoner som ikke når konsumenten.

### Operasjoner

#### Op #1: `GetFeideBrukere` — listevisning og søk i personbrukere

**Dekker krav:** BRU-PER-GRU-001
**Implementeres av:** Task #3 (backend), Task #5 (fs-admin)

##### Lag A — Schema-tillegg

```graphql
extend type Query {
  "Personbrukere (Feide-brukere) du har innsyn i. Synlighet håndheves i databasen (RLS)."
  feideBrukere(
    first: Int
    after: String
    filter: FeideBrukereFilterInput
    orderBy: FeideBrukereOrderByInput @orderBy
  ): [FeideBruker] @asConnection(defaultFirstValue: 100) @defaultOrder(fields: [{name: "FEIDE_ID"}])

  "Roller/tilganger som forekommer blant synlige personbrukeres tildelinger. Kilde for rollefilteret."
  mineSynligeBrukerroller: [Tilgangsrolle]   # @table mot nytt view feide_bruker_tildelingsrolle
}

input FeideBrukereFilterInput {
  "Fritekst: treffer brukernavn (Feide-ID). Navnesøk kommer via SIS-federation senere."
  brukernavnContains: String        # @condition
  status: FeideBrukerStatusInput    # @field(name: "STATUS")
  "Brukere med minst én aktiv tildeling ved noen av organisasjonene."
  organisasjoner: [ID!]             # @condition (EXISTS mot subjektrolletildeling)
  "Brukere med minst én aktiv tildeling av rollene."
  roller: [ID!]                     # @condition
  miljoer: [ID!]                    # @condition
}

input FeideBrukereOrderByInput { direction: OrderDirection!, orderByField: FeideBrukereOrderByFieldInput! }
enum FeideBrukereOrderByFieldInput { BRUKERNAVN }   # @order(fields: [{name: "FEIDE_ID"}])

enum FeideBrukerStatus { AKTIV DEAKTIVERT }
enum FeideBrukerStatusInput { AKTIV DEAKTIVERT }    # input/output-enum holdes adskilt (lint-regel, jf. ApplikasjonStatusInput)

extend type FeideBruker {
  status: FeideBrukerStatus                          # @field(name: "STATUS") — GENERATED-kolonne fra Task #2
  deaktivertTidspunkt: DateTime
  "Organisasjonene brukerens tildelinger gjelder for (avledet — brukeren har ingen egen organisasjon)."
  tildelingerOrganisasjoner: [Organisasjon]          # @splitQuery @reference via subjekt_tilgangsorganisasjon (0023)
  tildelingerMiljoer: [Miljo]                        # @splitQuery @reference via subjekt_tilgangsmiljo (0023)
}
```

##### Lag B — fs-admin call-site

```ts
// src/domains/tilgangsstyring/features/PersonbrukereOverview/components/PersonbrukereResultList/PersonbrukerRow.tsx
export const PERSONBRUKER_ROW_FRAGMENT = gql(/* GraphQL */ `
  fragment PersonbrukerRowFields on FeideBruker {
    id
    brukernavn
    status
    tildelingerOrganisasjoner { id organisasjonskode navnAlleSprak { nb } }
  }
`)
```

```ts
// src/domains/tilgangsstyring/features/PersonbrukereOverview/queries.ts
export const GET_FEIDE_BRUKERE = gql(/* GraphQL */ `
  query GetFeideBrukere($first: Int, $after: String, $filter: FeideBrukereFilterInput, $orderBy: FeideBrukereOrderByInput) {
    feideBrukere(first: $first, after: $after, filter: $filter, orderBy: $orderBy) {
      nodes { ...PersonbrukerRowFields }
      totalCount
      pageInfo { endCursor hasNextPage }
    }
  }
`)
// useQuery(GET_FEIDE_BRUKERE, { variables: { first: 50, filter, orderBy } }) + fetchMore for «Last inn flere»
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-PER-GRU-001 (liste, 50-og-50 m/ totalCount, fritekst, filter status/organisasjon/rolle, sortering, synlighet).
- **Form:** Connection-liste med filter-/orderBy-input speiler `applikasjoner`-queryen i samme subgraf. Paginering per `fs-sikt-no-producer-schema-design §Vi følger Cursor Connections Specification for paginering` og `graphql-learn-pagination` (cursor over offset). Semantisk felt `mineSynligeBrukerroller` per `fs-sikt-no-producer-schema-design §Vi innfører gjerne egne felt og typer for semantisk nyttige data-uttrekk`.
- **Synlighet** ligger i RLS (`feide_bruker_les`), ikke i filteret — `totalCount`/`pageInfo` reflekterer da automatisk brukerens innsyn, som kravet krever.
- **Navngiving:** `brukernavnContains`, `tildelingerOrganisasjoner`, norsk lowerCamelCase per `fs-sikt-no-producer-naming §Bruk norsk for domenebegreper…` og `§Bruk lowerCamelCase`. Nullable felter per `fs-sikt-no-producer-best-practice §Nullability`.
- **Colocation-status:** Etablerer colocation i dette området — eksisterende prototype-hooks bruker flat inline-`gql`, men hele skjermen skrives om ved migreringen, per `graphql-golden-path-fragment-colocation §Implementation notes` og `graphql-golden-path-query-componentization §Why this should be default`.
- **Alternativer vurdert:** rot-query `personbrukere` med ny type — forkastet (dobbel identitet mot federert `FeideBruker`, jf. beslutning 1). `navn`-felt i subgrafen — forkastet (persondata eies av SIS); avvik flagget som åpent spørsmål 2.

#### Op #2: `GetFeideBrukerTildelinger` — se en personbrukers tilganger og roller

**Dekker krav:** BRU-PER-GRU-002
**Implementeres av:** Task #1 (typen, grunnmur), Task #7 (connection, backend B), Task #10 (fs-admin)

##### Lag A — Schema-tillegg

```graphql
extend type FeideBruker {
  "Brukerens tildelinger, direkte og arvede. GUI-ets to seksjoner = to kall med rolletype-filter."
  tildelinger(
    first: Int
    after: String
    filter: FeideBrukerTildelingerFilterInput
    orderBy: FeideBrukerTildelingerOrderByInput @orderBy
  ): [FeideBrukerTildeling] @asConnection(defaultFirstValue: 10) @defaultOrder(fields: [{name: "ROLLEKODE"}])
    # @splitQuery @reference via subjektrolletildeling_med_arv
}

type FeideBrukerTildeling implements Node
    # @table(name: "subjektrolletildeling_med_arv") @node(typeId: "20019",
    #   keyColumns: ["SUBJEKT_ID","ROLLEKODE","ORGANISASJONSKODE","MILJOKODE"])  — firedelt nøkkel som fase4
{
  id: ID!
  kode: String!                       # @field(name: "ROLLEKODE")
  beskrivelse: String                 # @reference via rolle
  "TILGANG (atom) eller ROLLE (sammensatt) — semantisk skille fra begrepsbruk.md."
  rolletype: Rolletype!               # @field(name: "ROLLETYPE") — ny view-kolonne (Task #1)
  tilknytning: Tilknytning!           # DIREKTE | ARVET — gjenbruker eksisterende enum
  "Kodene til tildelingene arven stammer fra."
  arvetFra: [String!]
  organisasjon: Organisasjon          # @reference
  miljo: Miljo                        # @reference
  "Brukeren som gjorde tildelingen. Null for arvede og maskinelle tildelinger."
  tildeltAv: FeideBruker              # @reference via ny view-kolonne tildelt_av_bruker
  tildeltTidspunkt: DateTime          # @field(name: "TILDELT_TIDSPUNKT")
}

enum Rolletype { TILGANG ROLLE }
enum RolletypeInput { TILGANG ROLLE }

input FeideBrukerTildelingerFilterInput {
  rolletype: RolletypeInput
  tilknytning: TilknytningInput
  kodeContains: String                # @condition
  organisasjoner: [ID!]
  miljoer: [ID!]
  status: TildelingStatusInput        # ÅPENT SPØRSMÅL 3 — aktiv/inaktiv-skille på tildelingsnivå
}

input FeideBrukerTildelingerOrderByInput { direction: OrderDirection!, orderByField: FeideBrukerTildelingerOrderByFieldInput! }
enum FeideBrukerTildelingerOrderByFieldInput { KODE }

extend type Tilgangsrolle {
  rolletype: Rolletype                # @field(name: "ROLLETYPE") — for rollevelgere og filterkilder
}
```

##### Lag B — fs-admin call-site

```ts
// src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerTilganger/TildelingRow.tsx
export const TILDELING_ROW_FRAGMENT = gql(/* GraphQL */ `
  fragment TildelingRowFields on FeideBrukerTildeling {
    id
    kode
    beskrivelse
    rolletype
    tilknytning
    arvetFra
    organisasjon { id organisasjonskode navnAlleSprak { nb } }
    miljo { id navn }
    tildeltAv { id brukernavn }
    tildeltTidspunkt
  }
`)
```

```ts
// src/domains/tilgangsstyring/features/PersonbrukerDetails/queries.ts
export const GET_FEIDE_BRUKER_TILDELINGER = gql(/* GraphQL */ `
  query GetFeideBrukerTildelinger($id: ID!, $first: Int, $after: String, $filter: FeideBrukerTildelingerFilterInput) {
    tilgangsstyringNode(id: $id) {
      ... on FeideBruker {
        id
        tildelinger(first: $first, after: $after, filter: $filter) {
          nodes { ...TildelingRowFields }
          totalCount
          pageInfo { endCursor hasNextPage }
        }
      }
    }
  }
`)
// Tilganger-fanen: filter: { rolletype: TILGANG } — Roller-fanen: filter: { rolletype: ROLLE }
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-PER-GRU-002 (Navn→kode/beskrivelse, Status, Organisasjon, Tildelt av, Tildelt dato; skille roller/tilganger; merking av arv).
- **Form:** Én connection over det subjekt-generiske arv-viewet i stedet for to feltpar/typer — samme grep som `ApplikasjonTilgang`, men med korrekt domenenavn og delt mellom seksjonene via `rolletype`-filter. Node-oppslag via `tilgangsstyringNode(id)` per `fs-sikt-no-producer-schema-design §Vi følger Global Object Identification-spesifikasjonen` (typen implementerer `Node` fordi mutasjoner refererer tildelinger med id).
- **Navngiving:** `tildeltAv`/`tildeltTidspunkt` i naturlig ordrekkefølge per `fs-sikt-no-producer-naming §Bruk naturlig ordrekkefølge`; nullable per `fs-sikt-no-producer-best-practice §Nullability` (arvede tildelinger mangler `tildeltAv`).
- **Colocation-status:** Følger colocation — fragmentet eies av rad-komponenten og deles av begge faner, per `graphql-golden-path-fragment-colocation` og `graphql-golden-path-query-componentization`.
- **Alternativer vurdert:** separate `tilganger`-/`roller`-connections på FeideBruker — forkastet (dobbelt skjema for identisk form; filteret uttrykker det samme). Gjenbruk av `ApplikasjonTilgang` — forkastet (feil domenenavn; fase4 gir den applikasjonsspesifikk semantikk og typeId 20018).

#### Op #3: `TildelFeideBrukerTilganger` / `FjernFeideBrukerTilganger` — tildele og fjerne

**Dekker krav:** BRU-PER-GRU-003
**Implementeres av:** Task #8–#9 (backend B), Task #11 (fs-admin)

##### Lag A — Schema-tillegg

```graphql
extend type Mutation {
  "Tildeler tilganger/roller til personbrukere. Skillet tilgang/rolle er katalogegenskapen rolletype — én mutasjon dekker begge."
  tildelFeideBrukerTilganger(input: [TildelFeideBrukerTilgangerInput!]!): TildelFeideBrukerTilgangerPayload
    # @service → FeideBrukerTilgangService.tildelFeideBrukerTilganger
  fjernFeideBrukerTilganger(input: [FjernFeideBrukerTilgangerInput!]!): FjernFeideBrukerTilgangerPayload
    # @service → FeideBrukerTilgangService.fjernFeideBrukerTilganger
}

input TildelFeideBrukerTilgangerInput {
  feideBrukerId: ID!      # @nodeId(typeName: "FeideBruker")
  tilgangId: ID!          # @nodeId(typeName: "Tilgangsrolle")
  organisasjonId: ID!     # @nodeId(typeName: "Organisasjon")
  miljoId: ID!            # @nodeId(typeName: "Miljo")
}

"Tildelings-id-en bærer alle fire nøkkeldelene (fase4-grepet)."
input FjernFeideBrukerTilgangerInput {
  tildelingId: ID!        # @nodeId(typeName: "FeideBrukerTildeling")
}

type TildelFeideBrukerTilgangerPayload {
  """
  Tildelingene slik de står etterpå, ett element per gjennomført input-element.
  Feilede elementer identifiseres av errors[].path. SEMANTIKK AVKLARES (åpent spørsmål 1):
  inntil videre er batchen alt-eller-ingenting.
  """
  tildelinger: [FeideBrukerTildeling]
  errors: [TildelFeideBrukerTilgangerError]
}

type FjernFeideBrukerTilgangerPayload {
  "Per fjernet tildeling: id-en som ble lukket, og tildelingen slik den ev. fortsatt er effektiv via arv."
  fjernedeTildelinger: [FjernetFeideBrukerTildeling]
  errors: [FjernFeideBrukerTilgangerError]
}
type FjernetFeideBrukerTildeling { tildelingId: ID!, fortsattEffektiv: FeideBrukerTildeling }

union TildelFeideBrukerTilgangerError = ManglerTildelingsrett | FeideBrukerIkkeFunnet | TilgangskodeIkkeFunnet
union FjernFeideBrukerTilgangerError  = ManglerTildelingsrett | FeideBrukerIkkeFunnet | TilgangskodeIkkeFunnet | ArvetTilgangKanIkkeFjernes

"Brukeren finnes ikke, er ikke synlig for deg, eller du mangler tilgang — uskjelnelig med vilje."
type FeideBrukerIkkeFunnet implements Error {
  path: [String!]!
  message: String!
}
# @error-handlers: DATABASE sqlState "P0002" matches "brukeren" (fra krev_feide_bruker),
#                  GENERIC IllegalStateException matches "matched zero rows"
```

##### Lag B — fs-admin call-site

```ts
// src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerTilganger/TildelTilgangModal/mutations.ts
export const TILDEL_FEIDE_BRUKER_TILGANGER = gql(/* GraphQL */ `
  mutation TildelFeideBrukerTilganger($input: [TildelFeideBrukerTilgangerInput!]!) {
    tildelFeideBrukerTilganger(input: $input) {
      tildelinger { ...TildelingRowFields }
      errors { ... on Error { message path } }
    }
  }
`)
// useMutation(..., { refetchQueries: [GET_FEIDE_BRUKER_TILDELINGER] });
// UI mapper errors[].path → hvilket valgt element som ble avvist.
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-PER-GRU-003 (tildele/fjerne roller og tilganger, bulk i én operasjon, synlig hvilke som feilet og hvorfor; sporbarhet dekkes av aktørkolonner/append-only i DB).
- **Form:** Toppnivåfelt på `Mutation` per `fs-sikt-no-producer-best-practice §Bare felt på Mutation-typen kan utføre endringer` og `graphql-learn-mutations` (payload returnerer den endrede tilstanden). Batch-input `[XInput!]!` + payload med `errors`-union speiler subgrafens etablerte mønster (`opprettFeideApplikasjoner` m.fl.).
- **Delvis suksess:** `Error.path` per element gjør skjemaet nøytralt til kravavklaringen (beslutning 5) — ingen skjemaendring uansett utfall. Ingen regel i referansene dekker delvis-suksess-semantikk; flagget som åpent spørsmål 1 i stedet for å finne på en.
- **Error-union-navn:** entall `…Error` — bevisst avvik fra malens plural `…Errors`, fordi denne subgrafen konsekvent bruker entall (`OpprettApplikasjonerError`, `DeaktiverApplikasjonerError`); å speile eksisterende skjema trumfer malen. `ManglerTildelingsrett`, `TilgangskodeIkkeFunnet`, `ArvetTilgangKanIkkeFjernes` gjenbrukes fra fase4-branchen.
- **Sikkerhetskonvensjon:** ukjent id, RLS-skjult id og manglende rettighet kollapser i `FeideBrukerIkkeFunnet` (ingen eksistens-orakel) — samme konvensjon som `ApplikasjonIkkeFunnet` på main.
- **Colocation-status:** Følger colocation — payload spreader `TildelingRowFields` fra Op #2 slik at cache-oppdatering treffer radkomponentens felter.
- **Alternativer vurdert:** fire mutasjoner (tilganger × roller, som mocken) — forkastet: skillet er en katalogegenskap, ikke to skriveveier. `MutasjonAvvist`-envelope fra mocken — forkastet: plattformen bruker typed errors-union med `Error`-interface.

#### Op #4: `DeaktiverFeideBrukere` / `ReaktiverFeideBrukere` — frys og gjenoppretting

**Dekker krav:** BRU-PER-GRU-004
**Implementeres av:** Task #2 og #4 (backend A), Task #6 (fs-admin)

##### Lag A — Schema-tillegg

```graphql
extend type Mutation {
  """
  Deaktiverer personbrukere: brukeren når ikke FS-data ved neste tokenutstedelse; tildelingene
  beholdes urørt (frys). Idempotent — allerede deaktivert bruker er en no-op.
  """
  deaktiverFeideBrukere(input: [DeaktiverFeideBrukereInput!]!): DeaktiverFeideBrukerePayload
    # @service → FeideBrukerStatusService.deaktiverFeideBrukere
  "Reaktiverer personbrukere. Tildelinger som utløp på tid under deaktiveringen blir ikke aktive igjen."
  reaktiverFeideBrukere(input: [ReaktiverFeideBrukereInput!]!): ReaktiverFeideBrukerePayload
    # @service → FeideBrukerStatusService.reaktiverFeideBrukere
}

input DeaktiverFeideBrukereInput { feideBrukerId: ID! }   # @nodeId(typeName: "FeideBruker")
input ReaktiverFeideBrukereInput { feideBrukerId: ID! }

type DeaktiverFeideBrukerePayload { feideBrukere: [FeideBruker], errors: [DeaktiverFeideBrukereError] }
type ReaktiverFeideBrukerePayload { feideBrukere: [FeideBruker], errors: [ReaktiverFeideBrukereError] }

union DeaktiverFeideBrukereError = FeideBrukerIkkeFunnet | ManglerSkrivetilgang
union ReaktiverFeideBrukereError = FeideBrukerIkkeFunnet | ManglerSkrivetilgang
```

##### Lag B — fs-admin call-site

```ts
// src/domains/tilgangsstyring/features/PersonbrukerDetails/components/DeaktiverPersonbrukerModal/mutations.ts
export const DEAKTIVER_FEIDE_BRUKERE = gql(/* GraphQL */ `
  mutation DeaktiverFeideBrukere($input: [DeaktiverFeideBrukereInput!]!) {
    deaktiverFeideBrukere(input: $input) {
      feideBrukere { id status deaktivertTidspunkt }
      errors { ... on Error { message path } }
    }
  }
`)
// Fanene trenger ingen refetch: status-feltet i cachen oppdateres, og «inaktiv»-visningen deriveres av det.
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-PER-GRU-004 (deaktivering fryser samlede tildelinger; reaktivering gjenoppretter unntatt tidsutløpte; sporbart via aktørkolonner).
- **Form:** Batch + idempotens speiler `deaktiverApplikasjoner`/`reaktiverApplikasjoner` i samme skjema; toppnivå-mutasjoner per `fs-sikt-no-producer-best-practice §Bare felt på Mutation-typen kan utføre endringer`. Payload returnerer oppdatert `FeideBruker` per `graphql-learn-mutations` («output type that relates to whatever is modified»).
- **Frys-semantikken ligger i DB, ikke i skjemaet:** tildelingsradene røres ikke, derfor finnes ingen «frys tildeling»-mutasjon — og GRU-004s «tidsutløpte reaktiveres ikke» er automatisk sant.
- **Colocation-status:** Følger colocation — modal-mutasjonen selekterer bare statusfeltene den selv viser; radfragmentene eies av fanene.
- **Alternativer vurdert:** per-tildeling `TildelingStatus`-flipp (mockens modell) — forkastet: O(n) temporale lukkinger + tap av «hva var aktivt før frys»; brukeregenskap er enklere og reversibel.

### Tverrgående schema-bekymringer

#### Permission-modell

Alle rettigheter håndheves i databasen: RLS-policyer + `SECURITY INVOKER`-funksjoner
(`BRUKERADMIN_WSBRUKER_LES/_SKRIV` for lesing/status, `BRUKERADMIN_TILDELING_SKRIV` +
`krev_tildelingsrett` for tildel/fjern). Ingen `kan*`-flagg i skjemaet (arkitektbeslutning,
`docs/tilgangsmodell.md`); klienten gater på egne roller (`mineTilganger`-sporet, eies av annet team).

#### Error-union-medlemmer

| Mutation | Union (entall — subgrafens konvensjon) | Medlemmer |
|---|---|---|
| `tildelFeideBrukerTilganger` | `TildelFeideBrukerTilgangerError` | `ManglerTildelingsrett`, `FeideBrukerIkkeFunnet`, `TilgangskodeIkkeFunnet` |
| `fjernFeideBrukerTilganger` | `FjernFeideBrukerTilgangerError` | + `ArvetTilgangKanIkkeFjernes` |
| `deaktiverFeideBrukere` | `DeaktiverFeideBrukereError` | `FeideBrukerIkkeFunnet`, `ManglerSkrivetilgang` |
| `reaktiverFeideBrukere` | `ReaktiverFeideBrukereError` | `FeideBrukerIkkeFunnet`, `ManglerSkrivetilgang` |

Kun `FeideBrukerIkkeFunnet` er ny; resten gjenbrukes fra main/fase4.

#### Sporings-felter

`tildeltAv`/`tildeltTidspunkt` eksponeres nå (kravfelt i GRU-002). `fjernetAv`/`endretAv` utsettes
til historikk-iterasjonen («2 - Historikk») — dataene finnes allerede i tabellene.

#### Versjonering

Alt lander i `experimental`-kontrakten (`schema_brukeradmin.graphqls`), der bakoverinkompatible
endringer er tillatt uten varsel per `fs-sikt-no-producer-schema-design §Endringer i API bør ikke
ødelegge for klienter` (eksperimentelt nivå). Ingen `V2`-felt behøves.

### Åpne spørsmål

- [ ] **1. Delvis suksess vs. alt-eller-ingenting ved bulk-tildeling (GRU-003).** Blokkerer transaksjonssemantikken i `FeideBrukerTilgangService` (Task #9) — ikke skjemaet (beslutning 5). Svar fra kravansvarlig (#481).
- [ ] **2. «Navn»-kolonnen i GRU-001.** Subgrafen eier ikke persondata; listen viser `brukernavn` inntil SIS-federert navn finnes. Trenger aksept fra produkteier/kravansvarlig, ellers må SIS-koblingen forseres.
- [ ] **3. Aktiv/inaktiv-status per tildeling i GRU-002.** Med frys-som-brukeregenskap finnes «inaktiv tildeling» bare som utløpt periode. Skal utløpte (historiske) tildelinger vises i fanene med status, eller kun aktive? Påvirker view-filter og `FeideBrukerTildelingerFilterInput.status`. Kravansvarlig/design (henger på GRU-002s eget åpne spørsmål).
- [ ] **4. Rollekoder for personadministrasjon.** «personadministrator»/«super-personadministrator» er arbeidstitler; i dag håndhever RLS `BRUKERADMIN_WSBRUKER_*`. Eget person-privilegium kan innføres senere uten skjemaendring. Rolledefinisjonsarbeidet («4 - Opprette og administrere roller»).

## Implementation Tasks

Rekkefølge/eierskap: Task #1 (grunnmur) landes først av utvikler B med review fra A. Deretter
kjører **Vertikal A = Task #2–#6 (utvikler A)** og **Vertikal B = Task #7–#11 (utvikler B)**
parallelt. Task #12 tas av den som blir ferdig først. jOOQ-regenerering er serielt punkt:
grunnmur → A → B, alltid på fersk main.

### Task #1: Grunnmur — skjemafil, rolletype-kolonne og tildelingsview (utvikler B, review A)

**Priority**: High
**Size**: M
**Dependencies**: None
**Addresses Requirements**: BRU-PER-GRU-002 (datagrunnlag), forutsetning for alle andre tasks

**Acceptance Criteria**:

- [ ] `schema_brukeradmin.graphqls` opprettet med A/B-soner; bygget verifiserer at `extend type FeideBruker` fungerer på tvers av skjemafiler (fallback: flytt FeideBruker-blokken hit)
- [ ] Migrasjon `0034-rolletype-og-tildelingsvisning.sql`: `rolle.rolletype` m/ CHECK + seed-klassifisering; `CREATE OR REPLACE VIEW subjektrolletildeling_med_arv` m/ appendede kolonner `tildelt_av_bruker`, `tildelt_tidspunkt`, `rolletype`
- [ ] pgTAP `32_rolletype_og_tildelingsvisning.sql` grønn (inkl. konsistenstest «aktiv utgående implikasjon ⇒ ROLLE»)
- [ ] jOOQ regenerert; syntetisk PK for viewet + FK `tildelt_av_bruker → feide_bruker` i `tilgangsstyring-new-jooq/pom.xml`
- [ ] `FeideBrukerTildeling` (typeId 20019) og `Tilgangsrolle.rolletype` definert i skjemaet; `mvn clean install -P quick` grønn

**Implementation Notes**:
Mal for view-utvidelse: `0021-subjektrolletildeling-med-arv.sql`. typeId 20018 og migrasjon 0035/pgTAP 31 er reservert av fase4-branchen — ikke gjenbruk. Kolonner kun appendes (bakoverkompatibelt for `ApplikasjonTilgang`).

### Task #2: Migrasjon 0033 — deaktivering av feide_bruker (Vertikal A)

**Priority**: High
**Size**: L
**Dependencies**: None (uavhengig av Task #1)
**Addresses Requirements**: BRU-PER-GRU-004

**Acceptance Criteria**:

- [ ] `0033-deaktivering-feide-bruker.sql`: `deaktivert_tidspunkt`, GENERATED `status`, `deaktivert_av_bruker`/`deaktivert_av_applikasjon` m/ CHECK (mal: 0017/0026 for applikasjoner)
- [ ] `tilganger_for_feidetjeneste_og_bruker` (siste def., 0018) redefinert med `deaktivert_tidspunkt IS NULL`-filter; alle funksjoner som slår opp `feide_bruker.feide_id` gjennomgått (0018/0019 + senere redefinisjoner)
- [ ] Nytt view `feide_bruker_tildelingsrolle` (DISTINCT rollekode over synlige brukertildelinger, `security_invoker`) som kilde for rollefilteret
- [ ] pgTAP `30_deaktivering_feide_bruker.sql` grønn: deaktivert bruker får tomme tilganger ved innlogging, tildelingsrader urørt, reaktivering gjenoppretter, tidsutløpt under frys forblir utløpt, aktørkolonner fylles, idempotens
- [ ] Eksempeldata (`@eksempeldata`-context) for dev-personaen

**Implementation Notes**:
Kommentaren «personer kan ikke deaktiveres» i 0018 fjernes. RLS-synlighet etter deaktivering er OK ute av boksen (`feide_bruker_les` betinger ikke på aktiv tildelingsperiode).

### Task #3: Skjema + leseside for feideBrukere (Vertikal A)

**Priority**: High
**Size**: M
**Dependencies**: Task #1, Task #2
**Addresses Requirements**: BRU-PER-GRU-001

**Acceptance Criteria**:

- [ ] A-sonen i `schema_brukeradmin.graphqls`: `feideBrukere`-connection (Op #1), `FeideBrukereFilterInput`/`OrderByInput`, statusfelter og `tildelingerOrganisasjoner`/`tildelingerMiljoer` på `FeideBruker` (via 0023-viewene), `mineSynligeBrukerroller`
- [ ] `FeideBrukereFilterConditions` implementert (brukernavnContains, organisasjoner/roller/miljoer via EXISTS mot tildelinger)
- [ ] IT `FeideBrukereQueryTest`: synlighet følger RLS (bruker m/ tilgang i mine org synes, andre ikke; totalCount matcher), filtre og sortering virker, deaktivert bruker vises med status DEAKTIVERT

**Implementation Notes**:
`first`/`after` må deklareres eksplisitt i SDL (Graphitron krever literal Int). Enum-par for input/output (lint-regel). Mal: `applikasjoner`-queryen + `ApplikasjonerFilterConditions`.

### Task #4: FeideBrukerStatusService + deaktiver/reaktiver-mutasjoner (Vertikal A)

**Priority**: High
**Size**: M
**Dependencies**: Task #2, Task #3
**Addresses Requirements**: BRU-PER-GRU-004

**Acceptance Criteria**:

- [ ] Mutasjonene `deaktiverFeideBrukere`/`reaktiverFeideBrukere` (Op #4) + payloads + `FeideBrukerIkkeFunnet` i A-sonen
- [ ] `FeideBrukerStatusService` (mal: `ApplikasjonStatusService`): `ctx.transactionResult`, guarded UPDATE (`.and(deaktivertTidspunkt.isNull())`), 0-rader disambiguert m/ eksistenssjekk scoped av `auth.orger_med_tilgang('BRUKERADMIN_WSBRUKER_SKRIV')`, begge aktørkolonner settes
- [ ] IT `BrukerstatusmutasjonerGraphqlTest` (mal: `SkrivemutasjonerGraphqlTest`): happy path, idempotens, ukjent/RLS-skjult/uten-skriv gir byte-identisk `FeideBrukerIkkeFunnet`, rå Postgres-tekst når aldri klienten

**Implementation Notes**:
Payload: sett kun PK på jOOQ-recorden, Graphitron re-henter. Mutasjoner virker kun på `/graphql/production`-pathen — IT-ene bruker den.

### Task #5: fs-admin — migrer Personbrukere-oversikten (Vertikal A)

**Priority**: High
**Size**: L
**Dependencies**: Task #3 (deployet til test, eller lokal supergraf)
**Addresses Requirements**: BRU-PER-GRU-001

**Acceptance Criteria**:

- [ ] `PersonbrukereOverview/**`-hooks skrevet om til `GET_FEIDE_BRUKERE` m.fl. med kolokerte fragmenter og `import { gql } from '@/__generated__'`; ekskluderinger fjernet fra `codegen.ts`
- [ ] Kolonner: brukernavn (Feide-ID), organisasjoner, status; navnekolonne merket «kommer» eller utelatt (åpent spørsmål 2); «Sist innlogget» utelatt (utsatt)
- [ ] Filtre bruker `mineSynligeBrukerroller` + `mineSynligeMiljoer` + org-liste; `kan*`-avhengig UI fjernet fra oversikten
- [ ] `cacheConfig.ts` oppdatert (key-args for `Query.feideBrukere`); MSW-handlere for migrerte operasjoner fjernet
- [ ] Eksisterende integrasjonstest (`PersonbrukerMasterDetail.integration.test.tsx`) oppdatert og grønn

**Implementation Notes**:
Arbeid skjer på/oppå BAT-185-branchen. Mock-avvikene er katalogisert i `src/mocks/personbrukere/teardown-personbrukere.md` + avviksloggen i analyse-dokumentet.

### Task #6: fs-admin — detaljside + deaktiver/reaktiver-modaler (Vertikal A)

**Priority**: High
**Size**: M
**Dependencies**: Task #4, Task #5
**Addresses Requirements**: BRU-PER-GRU-004

**Acceptance Criteria**:

- [ ] `PersonbrukerDetails`-skallet + Detaljer-fanen henter via `tilgangsstyringNode(id)`; `kan*`-flaggene erstattet (knapper synlige inntil gating-mekanismen fra mineTilganger-teamet lander — grensesnittpunkt dokumentert i koden)
- [ ] Deaktiver-/Reaktiver-modalene kaller `DEAKTIVER_/REAKTIVER_FEIDE_BRUKERE`; status og «tildelinger vises som inaktive» deriveres av `FeideBruker.status`
- [ ] MSW-handlere for `personbruker`, `deaktiverPersonbruker`, `reaktiverPersonbruker` fjernet

### Task #7: Skjema — tildelinger-connection på FeideBruker (Vertikal B)

**Priority**: High
**Size**: M
**Dependencies**: Task #1
**Addresses Requirements**: BRU-PER-GRU-002

**Acceptance Criteria**:

- [ ] B-sonen: `FeideBruker.tildelinger`-connection (Op #2) m/ `FeideBrukerTildelingerFilterInput`/`OrderByInput`, `@splitQuery @reference` via `feide_bruker__fk_feide_bruker_subjekt` → arv-viewet
- [ ] `FeideBrukerTildelingerFilterConditions` (rolletype, tilknytning, kodeContains, organisasjoner, miljoer)
- [ ] IT: tildelinger m/ arv vises korrekt (DIREKTE/ARVET, arvetFra deduplisert), rolletype-filteret splitter roller/tilganger, tildeltAv/tildeltTidspunkt riktige, RLS-scoping (kun tildelinger jeg kan se)

**Implementation Notes**:
Mal: `ApplikasjonTilgang`-oppsettet i `schema_exp.graphqls` + `ApplikasjonTilganger*filterTest`.

### Task #8: Migrasjon 0036 — tildel/fjern brukertilganger i DB (Vertikal B)

**Priority**: High
**Size**: L
**Dependencies**: Task #1; fase4-branchen (`0035`) merget — fallback: cherry-pick 0035-changesetene (RLS-policyer, `orger_med_tildelingsrett`, `effektiv_tilgang`, `krev_*`)
**Addresses Requirements**: BRU-PER-GRU-003

**Acceptance Criteria**:

- [ ] `0036-tildel-og-fjern-brukertilganger.sql`: `krev_feide_bruker` (SQLSTATE P0002, melding «brukeren…»), `tildel_brukertilgang`/`fjern_brukertilgang` (SECURITY INVOKER, gjenbruker `krev_tildelingsrett`/`krev_tilgangskode`; fjern = lukk periode, aldri DELETE)
- [ ] pgTAP `33_tildel_og_fjern_brukertilganger.sql` grønn (mal: fase4s `31_…`): tildel innen rett, tildel utenfor rett avvises (42501/tildelingsrett), fjern direkte OK, fjern arvet avvises, ukjent bruker → P0002, aktørkolonner, idempotens/dobbel-tildeling
- [ ] Eksempeldata for dev-personaen

### Task #9: FeideBrukerTilgangService + tildel/fjern-mutasjoner (Vertikal B)

**Priority**: High
**Size**: L
**Dependencies**: Task #7, Task #8. **Blokkert delvis av åpent spørsmål 1** (kun transaksjonssemantikk — start med alt-eller-ingenting)
**Addresses Requirements**: BRU-PER-GRU-003

**Acceptance Criteria**:

- [ ] Mutasjonene fra Op #3 i B-sonen m/ payloads, `FeideBrukerIkkeFunnet` gjenbrukt fra A (eller definert her hvis B lander først), fase4-feiltypene gjenbrukt
- [ ] `FeideBrukerTilgangService` (mal: fase4s `ApplikasjonTilgangService`): `ctx.transactionResult`, node-id-dekoding via `NodeId`, kaller jOOQ-rutinene fra Task #8
- [ ] Semantikk-beslutningen (åpent spørsmål 1) implementert når den foreligger; doc-strings oppdatert
- [ ] IT `BrukertildelingsmutasjonerGraphqlTest` (mal: fase4s 651-linjers test): happy path begge veier, per-element-feil har korrekt `path`, ingen eksistens-orakel, arvet-kan-ikke-fjernes

### Task #10: fs-admin — Tilganger-/Roller-fanene (visning) (Vertikal B)

**Priority**: High
**Size**: M
**Dependencies**: Task #7
**Addresses Requirements**: BRU-PER-GRU-002

**Acceptance Criteria**:

- [ ] `PersonbrukerTilganger`/`PersonbrukerRoller` migrert til `GET_FEIDE_BRUKER_TILDELINGER` med `rolletype`-filter; kolokert `TildelingRowFields`-fragment delt mellom fanene
- [ ] Kolonner: kode, beskrivelse, tilknytning (m/ arvetFra-merking), organisasjon, miljø, tildelt av, tildelt dato
- [ ] Fanenes filter (organisasjon/miljø/kode/tilknytning) mappet til `FeideBrukerTildelingerFilterInput`; MSW-handlere for visnings-queries fjernet

### Task #11: fs-admin — Tildel-/Fjern-modalene (Vertikal B)

**Priority**: High
**Size**: L
**Dependencies**: Task #9, Task #10
**Addresses Requirements**: BRU-PER-GRU-003

**Acceptance Criteria**:

- [ ] Modalene bruker `mineTildelingsorganisasjoner` + `tildelbareTilgangskoder(organisasjonId, miljoId)` (fase4) som valgkilder; klienten splitter på `Tilgangsrolle.rolletype` og deriverer `alleredeTildelt` fra brukerens egen tildelingsliste
- [ ] `TILDEL_/FJERN_FEIDE_BRUKER_TILGANGER` koblet; avviste elementer vises per element via `errors[].path` (delvis suksess) eller som hel-batch-feil (alt-eller-ingenting) — UI-et tåler begge til avklaringen lander
- [ ] `kanFjernes` erstattet med derivasjon (tilknytning=DIREKTE + org/miljø innenfor egne tildelingsorganisasjoner)
- [ ] MSW-handlere for tildel/fjern + `tildelbarePersonbruker*` fjernet

### Task #12: Opprydding — riv personbruker-mocken (felles, den som er ferdig først)

**Priority**: Medium
**Size**: S
**Dependencies**: Task #5, #6, #10, #11
**Addresses Requirements**: (teknisk gjeld fra prototypen)

**Acceptance Criteria**:

- [ ] `src/mocks/personbrukere/**` slettet; `handlers.ts` og `NEXT_PUBLIC_ENABLE_PERSONBRUKER_MOCKS` ryddet
- [ ] `codegen.ts` uten personbruker-ekskluderinger; `teardown-personbrukere.md` oppdatert til «fullført» eller slettet
- [ ] Unleash-flagget `tilgangsstyring-brukeradministrasjon` verifisert som eneste gate for sidene

## Risk Assessment

### Technical Risks

- **Risk**: Graphitron støtter ikke `extend type FeideBruker` på tvers av skjemafiler.
  - **Mitigation**: Verifiseres som første punkt i Task #1; fallback er å flytte FeideBruker-blokken til den nye filen (liten, mekanisk endring).
- **Risk**: fase4-branchen (`0035`, typeId 20018, pgTAP 31) forsinkes eller endres — Vertikal B bygger på den.
  - **Mitigation**: Task #8 har definert cherry-pick-fallback; nummerregisteret er avtalt på forhånd så ingen kollisjon oppstår uansett rekkefølge.
- **Risk**: jOOQ-generert kode er committet — parallelle regenereringer gir garanterte merge-konflikter.
  - **Mitigation**: Seriell regen-avtale (grunnmur → A → B), alltid på fersk main; regen-endringer isoleres i egne commits.
- **Risk**: Delvis suksess-avklaringen (åpent spørsmål 1) drar ut og blokkerer Task #9.
  - **Mitigation**: Skjemaet er semantikk-nøytralt (beslutning 5); implementer alt-eller-ingenting først, bytt transaksjonsgrense når svaret kommer.
- **Risk**: `brukernavn` i stedet for navn i oversikten avvises av produkteier (åpent spørsmål 2).
  - **Mitigation**: Flagget før implementasjon; SIS-federert navn er additivt og krever ingen endring i denne planens skjema.
- **Risk**: Deaktivering håndheves først ved neste tokenutstedelse (JWT-er lever i inntil 1 time).
  - **Mitigation**: Dokumenteres i doc-strings; sesjonsterminering er eksplisitt åpent kravspørsmål i GRU-004 og holdes utenfor scope.

### Testing Requirements

- pgTAP for alle nye DB-funksjoner/views/kolonner (suitene 30, 32, 33) — kjøres via `mvn -pl :tilgangsstyring-new-db clean test`
- Quarkus-IT per mutasjon/query (maler: `SkrivemutasjonerGraphqlTest`, `TildelingsmutasjonerGraphqlTest`), inkl. negativtester for eksistens-orakel og feilredigering
- fs-admin: oppdaterte integrasjonstester (`PersonbrukerMasterDetail`), jest-a11y der komponenter endres
- Manuell verifisering mot lokal supergraf (`rover dev`) før flaggslipp i test-miljø

## Success Criteria

- [ ] Alle akseptansekriterier i Task #1–#12 oppfylt
- [ ] Alle tester grønne (pgTAP, Quarkus-IT, fs-admin jest)
- [ ] Personbruker-sidene i fs-admin kjører mot ekte API i test-miljø uten MSW
- [ ] Ingen `kan*`-flagg i skjemaet; ingen eksistens-orakler i feilflater
- [ ] Kodekonvensjoner fulgt (CLAUDE.md, subgrafens skjemakonvensjoner, fs-admin-skills)
- [ ] Alle @must-krav i scope (GRU-001–004) adressert; utsettelsene (005/006, sist innlogget) dokumentert

## Requirements Traceability

| Requirement ID | Requirement Summary | Addressed by Task(s) | Status |
|---|---|---|---|
| BRU-PER-GRU-001 | Listevisning og søk i personbrukere | #1, #2, #3, #5 | Planned («Navn» og «Sist innlogget» delvis — se åpne spørsmål 2 og utsettelser) |
| BRU-PER-GRU-002 | Se en personbrukers tilganger og roller | #1, #7, #10 | Planned (tidsrom-/stedkodevisning utsatt m/ 005/006) |
| BRU-PER-GRU-003 | Tildele og fjerne tilganger og roller | #8, #9, #11 | Planned (delvis suksess-semantikk avventer avklaring 1) |
| BRU-PER-GRU-004 | Aktivere og deaktivere bruker | #2, #4, #6 | Planned |
| BRU-PER-GRU-005 | Stedkoder for tildeling | — | Deferred (utenfor scope, besluttet 2026-08-20) |
| BRU-PER-GRU-006 | Tidsbegrensning for tildeling | — | Deferred (utenfor scope; datamodellen støtter allerede perioder) |

## Cross-contributor-avhengigheter

| Rolle | Hva trengs | Blokkerer |
|---|---|---|
| Kravansvarlig (#481) | Beslutning delvis suksess vs. alt-eller-ingenting | Task #9 (kun semantikk; skjema og resten går) |
| Produkteier/kravansvarlig | Aksept for `brukernavn` i stedet for navn inntil SIS-federation | Task #5-kolonnevalg |
| mineTilganger-/gating-teamet | Gating-mekanisme i fs-admin | Erstatter midlertidig knappesynlighet i Task #6/#11 |
| Eier av fase4-branchene | Merge av `fase4-tildel-fjern` | Task #8 (fallback: cherry-pick) |
| Rolledefinisjonsarbeidet | Endelige rollekoder for personadministrasjon | Ingen task — mulig senere innstramming |
