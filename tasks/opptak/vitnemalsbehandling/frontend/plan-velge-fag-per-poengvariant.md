# Plan: Velge fag per poengvariant (L3, `@OPT-BEH-BEH-022`)

Rolle: frontend (fs-admin). Bygger på
[`analysis-velge-fag-per-poengvariant.md`](analysis-velge-fag-per-poengvariant.md), med svarene på de 12
åpne spørsmålene der. Kravene står i
[`spec-velge-fag-per-poengvariant.md`](../spec/spec-velge-fag-per-poengvariant.md).

## Proposed Solution

### Architecture Approach

L3 bygges i to faser, fordi L3 skal starte på `main` mens L2 fortsatt er en egen branch (spørsmål 1):

- **Fase 1, uavhengig av L2 og av backend.** Presentasjonskomponenter som tar data som props og ikke
  vet om «Beregn poeng»/«Bruk poeng»: fagtabellen for et vitnemålsutvalg, tilleggsfag, feltene for
  egne poeng, og «V13»-formatet. De testes med mockdata, og kan merges uten at de vises noe sted.
- **Fase 2, når L2 er merget og L3-API-et er i produksjonsskjemaet.** Komponentene kobles inn i
  `VitnemalsbehandlingSection` bak feature flagget. Fagvalg og egne poeng blir en del av input til
  `beregnVitnemaalpoeng` og `leggVitnemaalTilGrunn`.

Enheten i UI-et er raden i «Kvalifisering og poengberegning», altså kombinasjonen (spørsmål 3).
Avkrysningen per rad avgjør hvilke rader «Bruk poeng» lagrer vitnemål og fagvalg på (spørsmål 4).
Fagtabellen viser utvalget for det valgte vitnemålet og den første kryssede raden, slik det sist ble
lagret. Ulagret arbeid er arbeidstilstand i seksjonen, og forkastes ved bytte av vitnemål etter en
advarsel (spørsmål 5).

Fs-admin har ingen fagregler. Om et fag kan velges bort (23/6, valgbar), om tilleggsfag er valgt
som standard, og kvoteregelen for førstegangsvitnemål, kommer fra API-et (spørsmål 8, 4).

### Key Technical Decisions

1. **Decision:** egen komponent `VitnemaalsutvalgFagTabell` på `FSTable`, med eget fragment.
   - Why: datakilden er en annen type enn `VgsDokument.fag`, og spørringer skal ikke gjenbrukes
     mellom komponenter (spørsmål 6).
   - Alternative considered: utvide `VgsDokumentFagTabell`. Forkastet.
2. **Decision:** samme komponent viser både fagene på vitnemålet og tilleggsfagene, i to tabeller
   med hver sin caption.
   - Why: kolonnene er nesten de samme i skissen (tilleggsfag har ikke Forbedret), og valget fungerer
     likt. En `variant`-prop skjuler kolonnene som ikke gjelder.
   - Alternative considered: egen `TilleggsfagTabell`. Gir duplisert avkrysning og a11y-labels.
3. **Decision:** «V13» lages av én hjelpefunksjon, `formaterTerminOgAar`, i
   `src/domains/soknadsbehandling/utils/`, og brukes av både den nye tabellen og
   `VgsDokumentFagTabell` (spørsmål 9).
   - Why: de to tabellene skal ikke skille lag.
4. **Decision:** `validatePoints` flyttes fra `PoengberegningCard/utils/` til
   `src/domains/soknadsbehandling/utils/validatePoints/`, og tar feilmeldingene som argument i stedet
   for `t` fra `soknadsbehandling.PoengberegningCard`.
   - Why: både `PoengberegningCardRow` og de nye poengfeltene bruker den. Meldingene flyttes etter
     `fs-admin-i18n-structure`.
   - Alternative considered: kopiere funksjonen. Gir to sett regler.
5. **Decision:** feature flag `soknadsbehandling-vitnemal-fagvalg` (spørsmål 12). Flagget skjuler
   fagtabellen, tilleggsfagene og poengfeltene. Uten flagg oppfører seksjonen seg som L2.
   - Why: L2 er ute uten flag, og L3 legger til lagring av fagvalg.
6. **Decision:** fase 1 bygges mot mockdata i testene, ikke mot en mock-gateway.
   - Why: komponentene tar props, så Jest-mocks er nok. Mock-API (`fs-admin-mock-api-with-data`)
     trengs først hvis fase 2 må startes før backend er klar, og da som egen avgjørelse.

### File Changes Overview

Fase 1:

- `src/domains/soknadsbehandling/utils/formaterTerminOgAar/formaterTerminOgAar.ts` (ny) + test
- `src/domains/soknadsbehandling/features/VgsDokumentView/components/VgsDokumentFagTabell/VgsDokumentFagTabell.tsx`:
  `terminkode` i fragmentet, «År» via `formaterTerminOgAar`
- `src/domains/soknadsbehandling/utils/validatePoints/validatePoints.ts` (flyttet) + test, og
  `PoengberegningCardRow.tsx` oppdatert
- `src/domains/soknadsbehandling/features/VitnemalsbehandlingSection/components/VitnemaalsutvalgFagTabell/`
  (ny): komponent, `.a11y.test.tsx`, `.test.tsx`
- `src/domains/soknadsbehandling/features/VitnemalsbehandlingSection/components/PoengLagtInnSelv/`
  (ny): komponent, `.a11y.test.tsx`, `.test.tsx`
- `src/common/messages/nb/soknadsbehandling.json` (og `nn`/`en` om de finnes for nøklene):
  `VitnemaalsutvalgFagTabell`, `PoengLagtInnSelv`, flyttede valideringsmeldinger
- `src/common/types/generated/unleash.ts`: det nye flagget (`npm run generate:unleash`)

Fase 2:

- `VitnemalsbehandlingSection.tsx`, `.mocks.ts`, `.test.tsx`, `.a11y.test.tsx`: ny spørring for
  utvalget, fagvalg og egne poeng i input, varsel om forbedringer, advarsel om ulagrede endringer
- `.changeset/*.md`: én for «V13» (fase 1), én for L3 bak flagget (fase 2)

## GraphQL-endringer

> **Premiss:** konservativ. L2-API-et (`vitnemaal-grunnlag.graphqls` på fs-plattform-branchen
> `opptak/L2-legg-vitnemaal-til-grunn`) utvides. Ingen nye mutations.
> **Domeneterm:** `Vitnemaalsutvalg` (skissens «Vitnemålsutvalg <nummer>»: fagene på ett vitnemål for
> én kombinasjon), `VitnemaalsbehandlingKombinasjon` (fra L2).
> **Følger fra:** [`analysis-velge-fag-per-poengvariant.md`](analysis-velge-fag-per-poengvariant.md),
> Funn 4 og 5, og spørsmål 3–8.

### Sammendrag

- 1 nytt query-felt (`Sak.vitnemaalsutvalg`)
- 1 utvidet query (`beregnVitnemaalpoeng`) og 1 utvidet mutation (`leggVitnemaalTilGrunn`)
- 5 nye typer, 2 nye input-typer, 2 nye feiltyper
- 5 åpne spørsmål (se nederst)

### Operasjoner

#### Op #1: `GetVitnemaalsutvalg`: fagene og egne poeng for ett vitnemål på én kombinasjon

**Dekker krav:** `@OPT-BEH-BEH-022`: «Se fagene på vitnemålet», «Se opprinnelig og forbedret karakter
samtidig», «Se merknader på et fag», «Endringer på et vitnemål huskes når jeg bytter tilbake»,
«Tilleggsfag teller ikke før det aktivt velges», «Ikke alle fag kan velges bort», 23/6-scenarioene.
**Implementeres av:** Task #7

##### Lag A: Schema-tillegg

```graphql
extend type Sak {
  """
  Fagene på vitnemålet og poengene saksbehandleren har lagt inn selv, for én kombinasjon, slik de
  sist ble lagret med «Bruk poeng». Er ingenting lagret for vitnemålet på kombinasjonen, er fagene på
  vitnemålet valgt, og tilleggsfagene ikke. Null når vitnemålet ikke tilhører søkeren.
  """
  vitnemaalsutvalg(
    vgdoknr: String!
    kombinasjon: VitnemaalsbehandlingKombinasjonInput!
  ): Vitnemaalsutvalg
}

type Vitnemaalsutvalg {
  vitnemaalsnummer: String!
  "Fagene på vitnemålet, i rekkefølgen på vitnemålet. Én rad per fag, med opprinnelig og forbedret karakter."
  fag: [VitnemaalsutvalgFag!]
  "Tilleggsfag: fag som ikke står på vitnemålet."
  tilleggsfag: [VitnemaalsutvalgFag!]
  "Poengene saksbehandleren har lagt inn selv. Null når ingen er lagt inn."
  poengLagtInnSelv: VitnemaalsutvalgPoeng
}

type VitnemaalsutvalgFag {
  "Stabil per vitnemål, så samme fagvalg kan brukes på flere kombinasjoner."
  radnummer: Int!
  fagkode: String!
  fagnavn: String
  omfang: BigDecimal
  aar: Int
  terminkode: String
  eksamensformkode: String
  opprinneligKarakter: VitnemaalsutvalgKarakter
  "Null når faget ikke er forbedret."
  forbedretKarakter: VitnemaalsutvalgKarakter
  merknader: [VgsDokumentMerknad!]
  "Om faget inngår i beregningen."
  erValgt: Boolean!
  "Om saksbehandleren kan endre erValgt. Avgjøres av opptak (valgbar, 23/6-regelen)."
  kanEndreValg: Boolean!
}

type VitnemaalsutvalgKarakter {
  standpunkt: String
  eksamen: String
}

type VitnemaalsutvalgPoeng {
  karakterpoengOpprinnelig: BigDecimal
  karakterpoengForbedret: BigDecimal
  realfagspoeng: BigDecimal
  spraakpoeng: BigDecimal
}
```

##### Lag B: fs-admin call-site

```ts
// components/VitnemaalsutvalgFagTabell/VitnemaalsutvalgFagTabell.tsx
export const VITNEMAALSUTVALG_FAG_TABELL_FRAGMENT = gql(/* GraphQL */ `
  fragment VitnemaalsutvalgFagTabellFields on VitnemaalsutvalgFag {
    radnummer
    fagkode
    fagnavn
    omfang
    aar
    terminkode
    eksamensformkode
    opprinneligKarakter { standpunkt eksamen }
    forbedretKarakter { standpunkt eksamen }
    merknader { merknadtekst }
    erValgt
    kanEndreValg
  }
`)

// components/PoengLagtInnSelv/PoengLagtInnSelv.tsx
export const POENG_LAGT_INN_SELV_FRAGMENT = gql(/* GraphQL */ `
  fragment PoengLagtInnSelvFields on VitnemaalsutvalgPoeng {
    karakterpoengOpprinnelig
    karakterpoengForbedret
    realfagspoeng
    spraakpoeng
  }
`)
```

```ts
// VitnemalsbehandlingSection.tsx: kjøres når et vitnemål er valgt og minst én rad er krysset
export const GET_VITNEMAALSUTVALG = gql(/* GraphQL */ `
  query GetVitnemaalsutvalg(
    $sakId: ID!
    $vgdoknr: String!
    $kombinasjon: VitnemaalsbehandlingKombinasjonInput!
  ) {
    sak: node(id: $sakId) {
      id
      ... on Sak {
        vitnemaalsutvalg(vgdoknr: $vgdoknr, kombinasjon: $kombinasjon) {
          vitnemaalsnummer
          fag { ...VitnemaalsutvalgFagTabellFields }
          tilleggsfag { ...VitnemaalsutvalgFagTabellFields }
          poengLagtInnSelv { ...PoengLagtInnSelvFields }
        }
      }
    }
  }
`)

// Skisse, ikke for build
const { data } = useQuery(GET_VITNEMAALSUTVALG, {
  variables: { sakId, vgdoknr: valgtVitnemaal!, kombinasjon: forsteKryssede! },
  skip: !visFagvalg || !valgtVitnemaal || !forsteKryssede,
})
```

##### Lag C: Begrunnelse

- **Dekker krav:** se over. `kanEndreValg` dekker «Ikke alle fag kan velges bort» og 23/6-scenarioene
  uten regler i fs-admin (spørsmål 8). At utvalget er lagret per vitnemål, dekker «huskes når jeg
  bytter tilbake» (spørsmål 5).
- **Form:** et felt med argumenter på `Sak` i stedet for på `VitnemaalsbehandlingKombinasjon`, fordi
  kombinasjonen er en verdi uten id (L2), og saken er `Node`. Henting skal ikke endre noe, per
  `fs-sikt-no-producer-best-practice §Bare felt på Mutation-typen kan utføre endringer`. Lagret og
  ulagret utvalg er det samme feltet: backend leverer standarden når ingenting er lagret.
- Én rad per fag med `opprinneligKarakter` og `forbedretKarakter` følger skissens kolonnepar, og
  fjerner nøkkelkollisjonen i Funn 6. Det er en egen type for et semantisk uttrekk, per
  `fs-sikt-no-producer-schema-design §Vi innfører gjerne egne felt og typer for semantisk nyttige data-uttrekk`.
- Listene pagineres ikke. De er avgrenset av vitnemålet (~20–30 fag), som `VgsDokument.fag`, per
  `fs-sikt-no-producer-best-practice §Paginering` («svært god kontroll på at antallet … er lavt»).
  Merk at tommelfingerregelen er 10 elementer, så dette er et bevisst avvik.
- Typene implementerer ikke `Node`: de refereres ikke fra andre steder, og identiteten er
  (sak, kombinasjon, vitnemål), per `fs-sikt-no-producer-schema-design §Vi følger Global Object Identification-spesifikasjonen`
  («Dette betyr ikke at _alle_ typer må implementere det»).
- Nullable felt utenom identitet og valg, per `fs-sikt-no-producer-best-practice §Nullability`.
  Boolean med verb (`erValgt`, `kanEndreValg`), ingen forkortelser, per
  `fs-sikt-no-producer-naming §Boolean-felt navngis med verb` og `§Unngå forkortelser`.
- **Colocation-status:** følger colocation. Hver komponent eier sitt fragment, og seksjonen komponerer
  dem i én operasjon, per `graphql-golden-path-fragment-colocation §Implementation notes` og
  `graphql-golden-path-query-componentization §Why this should be default`. L2-området bruker
  fragmenter med `@unmask`. Planen følger det mønsteret for å kunne sende data som props.
- **Alternativer vurdert:**
  - Utvide `VgsDokument.fag` med fagvalg. Forkastet: fagvalget hører til kombinasjonen, ikke
    dokumentet.
  - Hente alle utvalg for alle vitnemål og kombinasjoner i `GetSakVgsDokumenter`. Forkastet:
    overhenter, og saksbehandleren ser bare ett utvalg om gangen.

#### Op #2: `BeregnVitnemaalpoeng` (utvidet): beregne med fagvalg og egne poeng

**Dekker krav:** «Velge hvilke fag som skal telle», «Søkeren kan få ulik poengsum til ulike
søknadsalternativer», «Tilleggsfag kan velges i ordinær kvote», R2/yrkesfag-scenarioene, «Varsel om
forbedringer … når jeg beregne poengene», «Legge inn <poengtype> selv», «Ugyldig verdi for
<poengtype> stoppes».
**Implementeres av:** Task #8

##### Lag A: Schema-tillegg

```graphql
"Fagvalget og poengene saksbehandleren har lagt inn selv. Uten dette brukes det som sist ble lagret."
input VitnemaalsutvalgInput {
  "Radnumrene (fra Vitnemaalsutvalg) som skal inngå i beregningen, både fag og tilleggsfag."
  valgteRadnumre: [Int!]!
  poengLagtInnSelv: VitnemaalsutvalgPoengInput
}

input VitnemaalsutvalgPoengInput {
  karakterpoengOpprinnelig: BigDecimal
  karakterpoengForbedret: BigDecimal
  realfagspoeng: BigDecimal
  spraakpoeng: BigDecimal
}

extend input BeregnVitnemaalpoengInput {
  "Null betyr: beregn fra det som sist ble lagret, som i L2."
  vitnemaalsutvalg: VitnemaalsutvalgInput
}

extend type Vitnemaalberegning {
  karakterpoengForbedret: BigDecimal
  """
  Kombinasjonene i kvoten for førstegangsvitnemål der grunnlaget har forbedringer (tilleggsfag eller
  forbedrede karakterer). Et varsel, ikke en sperre.
  """
  kombinasjonerMedForbedringerIForstegangskvote: [VitnemaalsbehandlingKombinasjon!]!
}
```

##### Lag B: fs-admin call-site

```ts
// VitnemalsbehandlingSection.tsx: L2-operasjonen får feltene, input får vitnemaalsutvalg
export const BEREGN_VITNEMAALPOENG = gql(/* GraphQL */ `
  query BeregnVitnemaalpoeng($input: BeregnVitnemaalpoengInput!) {
    beregnVitnemaalpoeng(input: $input) {
      karakterpoeng
      karakterpoengForbedret
      realfagspoeng
      spraakpoeng
      sum
      kombinasjonerMedForbedringerIForstegangskvote {
        poengvariantKode
        kompetanseregelverkKode
        grunnlagKode
      }
    }
  }
`)

// Skisse: valgNokkel må også ta med fagvalg og egne poeng, så «Bruk poeng» bare gjelder siste beregning
client.query({
  query: BEREGN_VITNEMAALPOENG,
  variables: { input: { sakId, vgdoknr, kombinasjoner, vitnemaalsutvalg: { valgteRadnumre, poengLagtInnSelv } } },
  fetchPolicy: 'no-cache',
})
```

##### Lag C: Begrunnelse

- **Form:** `beregnVitnemaalpoeng` er en query fordi den ikke lagrer noe (L2). Den forblir en query,
  per `fs-sikt-no-producer-best-practice §Bare felt på Mutation-typen kan utføre endringer`. Feltet
  `vitnemaalsutvalg` er nullable, så L2-kall uten det fungerer som før.
- `kombinasjonerMedForbedringerIForstegangskvote` erstatter L2s sperre med et varsel (spørsmål 2), og
  er per kombinasjon fordi kravet gir varsel per poengvariant. `grunnlagSomKreverForstegangsvitnemaal`
  er L2s felt for vitnemål som ikke er førstegangsvitnemål, og blir stående.
- **Endringen er bakoverinkompatibel bare for `KREVER_FOERSTEGANGSVITNEMAAL`** (spørsmål 2). Den
  fjernes uten deprecation, siden API-et er experimental, per
  `fs-sikt-no-producer-schema-design §Gjennomføring av bakoverinkompatible endringer`.
- **Colocation-status:** ikke best practice, men eksisterende mønster i området. L2 definerer
  operasjonen flatt i seksjonen. Akseptert fordi endringen er to felt. Varselet kan få eget fragment
  hvis det blir egen komponent.

#### Op #3: `LeggVitnemaalTilGrunn` (utvidet): «Bruk poeng» lagrer fagvalg og egne poeng

**Dekker krav:** «Velge hvilke fag som skal telle» (lagret på poengvarianten), «Bruke vitnemålet og
fagvalget fra én poengvariant i andre poengvarianter», «Kravelementene kontrolleres mot fagene i
poengvarianten som lagres», «Ingen poeng lagres for en poengvariant der søkeren ikke er kvalifisert»,
«Varsel om forbedringer … når jeg bruke poengene», «Legge inn <poengtype> selv», «Ugyldig verdi …
stoppes», «Endringer på et vitnemål gjelder ikke for et annet vitnemål».
**Implementeres av:** Task #8

##### Lag A: Schema-tillegg

```graphql
extend input LeggVitnemaalTilGrunnInput {
  """
  Lagres for vitnemålet på alle kombinasjonene som er krysset av. I kvoten for førstegangsvitnemål
  lagres ikke tilleggsfag. Null betyr: behold det som er lagret, som i L2.
  """
  vitnemaalsutvalg: VitnemaalsutvalgInput
}

extend type LeggVitnemaalTilGrunnPayload {
  "Samme varsel som beregningen. Lagringen er gjort."
  kombinasjonerMedForbedringerIForstegangskvote: [VitnemaalsbehandlingKombinasjon!]
}

# Erstatter L2-unionen. KREVER_FOERSTEGANGSVITNEMAAL fjernes fra VitnemaalGrunnlagAvvisning.
union LeggVitnemaalTilGrunnError =
    VitnemaalKanIkkeLeggesTilGrunnError
  | IkkeAutorisertError
  | UgyldigFagvalgError
  | UgyldigPoengLagtInnSelvError

"Et fag som ikke kan velges bort, er valgt bort, eller et radnummer finnes ikke på vitnemålet."
type UgyldigFagvalgError implements Error {
  message: String!
  path: [String!]!
  radnumre: [Int!]!
}

"En verdi lagt inn selv er utenfor grensene på poengtypen."
type UgyldigPoengLagtInnSelvError implements Error {
  message: String!
  path: [String!]!
  "Feltet i VitnemaalsutvalgPoengInput, f.eks. realfagspoeng."
  felt: String!
}
```

##### Lag B: fs-admin call-site

```ts
// VitnemalsbehandlingSection.tsx: L2-mutationen, med ny input og nye feil
export const LEGG_VITNEMAAL_TIL_GRUNN = gql(/* GraphQL */ `
  mutation LeggVitnemaalTilGrunn($input: LeggVitnemaalTilGrunnInput!) {
    leggVitnemaalTilGrunn(input: $input) {
      sak {
        id
        ...VitnemalsbehandlingPoeng @unmask
      }
      kombinasjonerMedForbedringerIForstegangskvote {
        poengvariantKode
        kompetanseregelverkKode
        grunnlagKode
      }
      errors {
        ... on Error { message }
        ... on VitnemaalKanIkkeLeggesTilGrunnError { aarsak }
        ... on UgyldigFagvalgError { radnumre }
        ... on UgyldigPoengLagtInnSelvError { felt }
      }
    }
  }
`)
// refetchQueries: refetchQueryNames(... , 'GetVitnemaalsutvalg'), så tabellen viser det som er lagret
```

##### Lag C: Begrunnelse

- **Form:** utvider L2-mutationen i stedet for en ny `lagreFagvalg`. «Bruk poeng» lagrer grunnlag og
  poeng samlet (L2-kravet «Poengene beregnes og lagres når saksbehandleren bruker dem»). En egen
  mutation ville gitt to lagringer som kan feile hver for seg, jf. `graphql-learn-mutations §Multiple fields in mutations`
  om at serielle mutations ikke er en transaksjon.
- Kopiering til andre rader (spørsmål 4) trenger ikke noe nytt felt. `kombinasjoner` er allerede en
  liste, og `radnummer` må være stabilt per vitnemål. Kvoteregelen for tilleggsfag håndheves i
  backend.
- «Ikke kvalifisert»: kombinasjonen i `sak.vitnemaalsbehandlingKombinasjoner` får `erKvalifisert:
  false`, `vitnemaalsnummer` satt og poeng `null`. Det trengs ikke et nytt felt for å lese utfallet.
  Visningen venter på design (spørsmål 10).
- Feiltypene implementerer `Error` med `message` og `path`. Unionsnavnet er i entall (`…Error`) som
  L2 og resten av schemaet (298 entall mot 5 flertall i `schema.graphql`), et bevisst avvik fra
  skillets flertallsmal.
- **Colocation-status:** som Op #2. Eksisterende mønster i området, `VitnemalsbehandlingPoeng`
  spreades som i L2.

### Tverrgående schema-bekymringer

#### Permission-modell

Uendret fra L2: backend avviser med `IkkeAutorisertError`, og fs-admin skjuler handlinger med
`useKanSaksbehandle`. `kanEndreValg` gjelder faglige regler, ikke rettighet.

#### Error-union-medlemmer

| Operasjon | Union | Medlemmer |
|---|---|---|
| `leggVitnemaalTilGrunn` | `LeggVitnemaalTilGrunnError` | `VitnemaalKanIkkeLeggesTilGrunnError` (uten `KREVER_FOERSTEGANGSVITNEMAAL`), `IkkeAutorisertError`, `UgyldigFagvalgError`, `UgyldigPoengLagtInnSelvError` |

`beregnVitnemaalpoeng` er en query uten payload-feil. Ugyldig fagvalg eller poeng gir GraphQL-feil
der, som i L2. Se åpent spørsmål 4.

#### Sporings-felter

Ikke nå. Endringsloggen (`GetEndringslogg`) dekker hvem som brukte poengene, som i L2.

#### Versjonering

Endringer på stedet, uten `V2`, fordi alt er experimental og bare fs-admin bruker det, per
`fs-sikt-no-producer-schema-design §Gjennomføring av bakoverinkompatible endringer`.

### Åpne spørsmål

- [ ] **G1.** Er `radnummer` stabilt per vitnemål (samme fag har samme nummer på alle kombinasjoner)?
  Det er en forutsetning for kopiering til andre rader. *Backend.*
- [ ] **G2.** Hvilken poengtype validerer KAR forbedret mot? Finnes det en egen poengtype, eller
  gjelder KAR-grensene for begge? Og hvilken KAR inngår i SUM? *Backend/domene (spørsmål 7).*
- [ ] **G3.** Når flere rader er krysset og har ulikt lagret utvalg, hvilket viser fagtabellen?
  Planen antar den første kryssede raden (i tabellens rekkefølge). *Domene/design.*
- [ ] **G4.** Skal `beregnVitnemaalpoeng` returnere ugyldig fagvalg eller poeng som felt i
  `Vitnemaalberegning`, så «Beregn poeng» kan vise samme feil som «Bruk poeng»? *Backend.*
- [ ] **G5.** V503 sletter fagrader ved bytte av vitnemål. Backend må lagre per vitnemål for at
  Op #1 skal kunne levere det som sist ble lagret (spørsmål 5). *Backend.*

## Implementation Tasks

### Fase 1: uavhengig av L2 og backend (start på `main`)

### Task #1: Feature flag `soknadsbehandling-vitnemal-fagvalg`

**Priority**: High
**Size**: S
**Dependencies**: Flagget må opprettes i Unleash av noen med tilgang
**Addresses Requirements**: spørsmål 12

**Acceptance Criteria**:

- [ ] Flagget finnes i Unleash (av i produksjon, på i test og review etter avtale)
- [ ] `src/common/types/generated/unleash.ts` er generert på nytt med `npm run generate:unleash`, ikke
      redigert for hånd
- [ ] Ingen bruk av flagget ennå (kobles inn i Task #7)

**Implementation Notes**: navnet følger `soknadsbehandling-*`-flaggene i filen. Sjekk med teamet
før navnet låses.

### Task #2: «År» som termin og år («V13») i begge fagtabellene

**Priority**: Medium
**Size**: S
**Dependencies**: None
**Addresses Requirements**: «Se fagene på vitnemålet» (År), spørsmål 9

**Acceptance Criteria**:

- [ ] `formaterTerminOgAar(terminkode, aar)` gir `V13` for `('V', 2013)`, `H07` for `('H', 2007)`,
      bare årstallet når terminkoden mangler, og `-` når året mangler. Enhetstestet
- [ ] `VgsDokumentFagTabell` henter `terminkode` i fragmentet og viser «År» med funksjonen
- [ ] Eksisterende tester for `VgsDokumentView` oppdatert, a11y-test grønn
- [ ] Changeset `Søknadsbehandling:` (ikke bak flagget, siden L1-siden er ute)

**Implementation Notes**: sjekk om «V13» trenger en skjermlesertekst (f.eks. `title`/`abbr` med
«Vår 2013»). Bruk `fs-admin-i18n-structure` for oversettelsene av termin.

### Task #3: Flytt `validatePoints` til domenets `utils`

**Priority**: Medium
**Size**: S
**Dependencies**: None
**Addresses Requirements**: «Ugyldig verdi for <poengtype> stoppes» (grunnlag)

**Acceptance Criteria**:

- [ ] `validatePoints` ligger i `src/domains/soknadsbehandling/utils/validatePoints/` og er ikke lenger
      bundet til `soknadsbehandling.PoengberegningCard`-oversettelsene
- [ ] Meldingene er flyttet etter `fs-admin-i18n-structure`, og `PoengberegningCardRow` oppfører seg
      likt (eksisterende tester grønne uten endret forventning)
- [ ] Ren refaktorering, så ingen changeset

### Task #4: `VitnemaalsutvalgFagTabell`: fagene på vitnemålet med avkrysning

**Priority**: High
**Size**: L
**Dependencies**: Task #2
**Addresses Requirements**: «Se fagene på vitnemålet», «Se opprinnelig og forbedret karakter
samtidig», «Se merknader på et fag», «Ikke alle fag kan velges bort», 23/6-scenarioene (visning)

**Acceptance Criteria**:

- [ ] Komponent på `FSTable` som tar rader (formen til `VitnemaalsutvalgFagTabellFields`), valgte
      radnumre, `onEndreValg(radnummer)` og `kanEndre` som props. Ingen spørring i komponenten
- [ ] Kolonner som skissen: avkrysning, Omfang, Fag, Fagnavn (radoverskrift), Stp og Eks opprinnelig,
      Eks.form, Stp og Eks forbedret, År («V13»), Merknad. Tomme verdier vises som `-`
- [ ] «Opprinnelig»/«Forbedret» går fram av kolonnelabels for skjermleser (f.eks. «Standpunkt,
      opprinnelig»), siden `FSTable` ikke har grupperte overskrifter
- [ ] Avkrysningen er låst og valgt når `kanEndreValg` er `false`. Den er deaktivert når `kanEndre` er
      `false`. Labelen er unik per rad (f.eks. «Ta med {fagnavn} ({fagkode}) i beregningen»)
- [ ] `variant="tilleggsfag"` skjuler Forbedret-kolonnene, og har egen caption («Tilleggsfag»)
- [ ] `getRowId` bruker `radnummer`, ikke `fagkode`
- [ ] `.a11y.test.tsx` (begge varianter, med og uten skrivetilgang) og `.test.tsx` (valg, låste fag,
      merknader, forbedret karakter)

**Implementation Notes**: les `src/common/components/tables/FSTable/CLAUDE.md`,
`fs-admin-tables-vs-lists` og `fs-admin-inputs` (checkbox-labels) først. Fragmentet kan defineres
først i Task #7, når typen finnes i schemaet. Til da brukes en lokal TypeScript-type med samme form.
Ingen CSS på selve inputene, og layout med `Flex`/`Grid`.

### Task #5: `PoengLagtInnSelv`: felt for egne poeng

**Priority**: High
**Size**: M
**Dependencies**: Task #3
**Addresses Requirements**: «Legge inn <poengtype> selv på en poengvariant», «Ugyldig verdi for
<poengtype> stoppes», spørsmål 7

**Acceptance Criteria**:

- [ ] Fire felt med `DecimalNumberInput`: KAR opprinnelig, KAR forbedret, REA og SPR, og SUM som
      `OutputField`. Verdier inn og ut som props
- [ ] Hvert felt valideres med `validatePoints` mot poengtypen den får som prop, og viser feilen ved
      feltet (`fs-admin-inputs`). Komponenten melder `harFeil` til forelderen, så «Bruk poeng» kan
      deaktiveres
- [ ] Tomt felt betyr «ikke lagt inn selv» og sendes som `null`
- [ ] Bare lesevisning når `kanEndre` er `false`
- [ ] `.a11y.test.tsx` og `.test.tsx` (gyldig, under minimum, over maksimum, feil trinn, tomt)

**Implementation Notes**: SUM vises fra beregningen, ikke regnet i fs-admin (åpent spørsmål G2).
Midlertidige tekster (spørsmål 11), og PR-en må si at designeren godkjenner dem.

### Fase 2: når L2 er merget og L3-API-et er i produksjonsskjemaet

### Task #6: Oppdater codegen mot L3-API-et

**Priority**: High
**Size**: S
**Dependencies**: L2 merget i fs-admin (med sperren fjernet, spørsmål 2). Op #1–#3 i
produksjonsskjemaet (backend)
**Addresses Requirements**: —

**Acceptance Criteria**:

- [ ] `npm run compile` (`graphql-codegen`) mot `production/experimental` gir
      typene `Vitnemaalsutvalg*`, `VitnemaalsutvalgInput` og de nye feiltypene
- [ ] Fragmentene fra Task #4 og #5 er flyttet fra lokale typer til `gql`-fragmenter

**Implementation Notes**: utvikling før det kan gjøres mot `test/experimental` med
`GRAPHQL_SCHEMA_LOCATION` i `.env.local`, men ikke merges.

### Task #7: Vis vitnemålsutvalget i `VitnemalsbehandlingSection`

**Priority**: High
**Size**: L
**Dependencies**: Task #1, #4, #5, #6
**Addresses Requirements**: «Se fagene på vitnemålet», «Endringer på et vitnemål gjelder ikke for
et annet vitnemål», «Endringer på et vitnemål huskes når jeg bytter tilbake», «Fagvalget i én
poengvariant påvirker ikke en annen», «Tilleggsfag teller ikke før det aktivt velges»

**Acceptance Criteria**:

- [ ] Bak flagget: når et vitnemål er valgt og minst én rad er krysset, henter seksjonen
      `GetVitnemaalsutvalg` for vitnemålet og den første kryssede raden (G3), og viser «Vitnemålsutvalg
      <nummer>» med «Åpne i ny fane», fagtabellen, tilleggsfagene og `PoengLagtInnSelv`
- [ ] Arbeidstilstanden (valgte radnumre, egne poeng) starter fra det som er lagret, og settes
      tilbake når vitnemålet eller den første kryssede raden byttes
- [ ] Uten flagget er seksjonen som i L2, og testene for L2 er uendret
- [ ] Laste- og feiltilstand for utvalget (feil i seksjonen, ikke for hele siden, som L2)
- [ ] Tester: bytte vitnemål og tilbake viser det lagrede utvalget (mock), tilleggsfag ikke valgt
      som standard

### Task #8: Fagvalg og egne poeng i «Beregn poeng» og «Bruk poeng»

**Priority**: High
**Size**: L
**Dependencies**: Task #7
**Addresses Requirements**: «Velge hvilke fag som skal telle», «Søkeren kan få ulik poengsum til
ulike søknadsalternativer», «Kravelementene kontrolleres mot fagene i poengvarianten som lagres»,
«Bruke vitnemålet og fagvalget fra én poengvariant i andre poengvarianter», «Tilleggsfag kan velges
i ordinær kvote», «Varsel om forbedringer … når jeg <handling>», R2- og yrkesfag-scenarioene, «Legge
inn <poengtype> selv», «Ugyldig verdi … stoppes»

**Acceptance Criteria**:

- [ ] `vitnemaalsutvalg` (valgte radnumre og egne poeng) sendes med i både beregn og bruk når flagget
      er på
- [ ] `valgNokkel` tar med fagvalg og egne poeng: «Bruk poeng» er deaktivert til «Beregn poeng» er
      kjørt på de gjeldende valgene, og når `PoengLagtInnSelv` har feil
- [ ] KAR forbedret vises fra beregningen
- [ ] Varselet om forbedringer i kvoten for førstegangsvitnemål (`ApplicationStatus`, warning) vises
      etter «Beregn poeng» og etter «Bruk poeng», og stopper ingenting. Midlertidig tekst
- [ ] `UgyldigFagvalgError` og `UgyldigPoengLagtInnSelvError` gir fs-admins egne tekster, aldri
      serverens `message` (som i L2)
- [ ] Etter «Bruk poeng» hentes `GetVitnemaalsutvalg` på nytt via `refetchQueryNames`, og
      arbeidstilstanden settes til det lagrede
- [ ] Tester per scenario i lista over, med mocks som importerer operasjonene fra komponentfilen

**Implementation Notes**: knappene følger `fs-admin-buttons` (async-tilstand). Kvoteregelen for
tilleggsfag ved kopiering håndheves av backend. Fs-admin viser bare det som kommer tilbake.

### Task #9: Advarsel om ulagrede endringer

**Priority**: Medium
**Size**: M
**Dependencies**: Task #7
**Addresses Requirements**: spørsmål 5, L2-kravet «Advarsel om endringer som ikke er lagret»

**Acceptance Criteria**:

- [ ] `useUnsavedChanges({ current: arbeidstilstand, baseline: lagret })` i seksjonen, med
      `markClean()` etter vellykket «Bruk poeng»
- [ ] Å flytte radioknappen eller endre første kryssede rad med ulagret fagvalg eller egne poeng gir
      en bekreftelse før arbeidstilstanden forkastes
- [ ] Tester for navigasjon bort og for bytte av vitnemål

**Implementation Notes**: `useUnsavedChanges` fanger bare navigasjon, ikke bytte inne i seksjonen
(`UnsavedChangesGuard/CLAUDE.md`). **Spør før en egen dialog bygges.** Sjekk først om guarden har en
måte å vise samme «Bli her / Forkast og fortsett»-dialog på direkte. Hvis ikke, foreslå å utvide
felleskomponenten.

### Task #10: Changeset og brukerveiledning

**Priority**: Low
**Size**: S
**Dependencies**: Task #8, #9
**Addresses Requirements**: —

**Acceptance Criteria**:

- [ ] Changeset med `fs-admin-changesets`, med spørsmål om flagget skal nevnes (skillets regel)
- [ ] Grep i `src/features/Brukerveiledninger/innhold/` bekrefter at ingen veiledning dekker steget
      (analysens Funn 10), eller veiledningen er sjekket med `fs-admin-brukerveiledninger`

### Utsatt: venter på design

- **«Ingen poeng lagres for en poengvariant der søkeren ikke er kvalifisert»** (spørsmål 10).
  API-et leverer utfallet via `erKvalifisert` (Op #3). Visningen planlegges når skissen finnes.

## Risk Assessment

### Technical Risks

- **Risk**: backend-arbeidet (lagring av forbedring og tillegg fra KREG, lagring per vitnemål, Op
  #1–#3) tar lengre tid enn fase 1.
  - **Mitigation**: fase 1 er uavhengig og kan merges. Fase 2 kan startes mot `test/experimental`, eller
    mot mock-API (`fs-admin-mock-api-with-data`) etter egen avgjørelse.
- **Risk**: L2 endres igjen før merge, så Task #7–#9 må tilpasses.
  - **Mitigation**: fase 2 starter først når L2 er merget (spørsmål 1).
- **Risk**: API-formen i `## GraphQL-endringer` er et forslag. Backend kan velge annet.
  - **Mitigation**: komponentene i fase 1 tar props, så bare Task #6–#8 berøres av endringer i
    schemaet.
- **Risk**: det blir en egen dialog for ulagrede endringer inne i seksjonen, ved siden av
  felleskomponenten.
  - **Mitigation**: Task #9 sier at vi spør før det bygges, og foretrekker å utvide
    `UnsavedChangesGuard`.
- **Risk**: «V13» er mindre tydelig for skjermleser og nye brukere.
  - **Mitigation**: Task #2 vurderer en utvidet tekst for skjermleser.

### Testing Requirements

- Enhetstester for `formaterTerminOgAar` og flyttet `validatePoints`
- `.a11y.test.tsx` for `VitnemaalsutvalgFagTabell`, `PoengLagtInnSelv`, og seksjonen med flagget på
- Komponenttester i seksjonen per scenario i kravet, med flagget av og på
- Ingen nye e2e-tester før backend er i test

## Success Criteria

- [ ] All acceptance criteria met
- [ ] All tests passing (`npm run lint`, typesjekk, Jest)
- [ ] Code follows project conventions (CLAUDE.md, UI-føring, GraphQL-regler)
- [ ] Alle scenarioene i `@OPT-BEH-BEH-022` har en task, eller står som utsatt med grunn
- [ ] L2 fungerer uendret med flagget av

## Requirements Traceability

| Scenario (`@OPT-BEH-BEH-022`) | Task(s) | Status |
|---|---|---|
| Se fagene på vitnemålet | #2, #4, #7 | Planned |
| Se opprinnelig og forbedret karakter samtidig | #4, #7 | Planned (backend: forbedring fra KREG) |
| Se merknader på et fag | #4, #7 | Planned |
| Legge ulikt vitnemål til grunn for ulike poengvarianter | L2, #8 | Delvis i L2 |
| Endringer på et vitnemål gjelder ikke for et annet vitnemål | #7, #8 | Planned (backend: G5) |
| Endringer på et vitnemål huskes når jeg bytter tilbake | #7, #9 | Planned (backend: G5) |
| Velge hvilke fag som skal telle | #4, #8 | Planned |
| Fagvalget i én poengvariant påvirker ikke en annen | #7, #8 | Planned |
| Søkeren kan få ulik poengsum til ulike søknadsalternativer | #8 | Planned |
| Kravelementene vurderes per grunnlag | — | Backend (kontrollmotoren) |
| Kravelementene kontrolleres mot fagene i poengvarianten som lagres | #8 | Backend, fs-admin sender fagvalget |
| Ingen poeng lagres … ikke kvalifisert | Utsatt | Venter på design (spørsmål 10) |
| Bruke vitnemålet og fagvalget fra én poengvariant i andre | #8 | Planned (G1) |
| Tilleggsfag teller ikke før det aktivt velges | #4, #7 | Planned (backend: standard) |
| Varsel om forbedringer … førstegangsvitnemål (beregne/bruke) | #8 | Planned, midlertidig tekst |
| Tilleggsfag kan velges i ordinær kvote | #8 | Planned |
| Matematikk R2 på kompetansebevis … førstegangsvitnemål | #8 | Planned (varselet) |
| Poenggivende fag på yrkesfagsløpet … førstegangsvitnemål | #8 | Planned (varselet) |
| Legge inn <poengtype> selv på en poengvariant | #3, #5, #8 | Planned (G2) |
| Ugyldig verdi for <poengtype> stoppes | #3, #5, #8 | Planned |
| Ikke alle fag kan velges bort | #4 | Planned (backend: `kanEndreValg`) |
| Studiekompetansefag kan ikke fjernes etter 23/6-regelen | #4 | Planned (backend) |
| Velge hvordan matematikk på Vg2-nivå dekkes etter 23/6-regelen | #4, #8 | Planned (backend) |
| Studiekompetansefag fra andre dokumenter … under tilleggsfag | — | L4a (`@ref-OPT-BEH-BEH-023`) |
| Alle studiekompetansefag i kalkulatoren … uten elektronisk vitnemål | — | L4b (`@ref-OPT-BEH-BEH-037`) |
