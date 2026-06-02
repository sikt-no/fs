# Plan: Applikasjon-tilgangsstyring — justeringer (ansvarlig-fjerning + filter-scope)

> **Krav-delta:** [`spec-changes-2026-06-01-11ce66c..40f04cb.md`](spec-changes-2026-06-01-11ce66c..40f04cb.md) — commits `11ce66c..40f04cb` på `sikt-no/fs` branch `fruitbat`.
> **Analyse:** [`analysis-applikasjon-tilgangsstyring-justeringer.md`](analysis-applikasjon-tilgangsstyring-justeringer.md) — alle 6 åpne spørsmål besluttet (Q1–Q6).
> **MR-strategi:** Én sammenhengende MR (Q6-beslutning). Tasks under er planning-granularitet — reviewer leser dem som 15 verifiserbare akseptanse-kriterier; developer ruller dem til én commit-historikk.

## Proposed Solution

### Architecture Approach

To ortogonale akser i krav-deltaen håndteres som *én* sammenhengende endring:

1. **Ansvarlig-fjerning** — `ansvarlig`-rollen er borte fra kravspekken. Datamodellen, mutations, error-typer, dialog-komponenter, fragment-felter og ~25 i18n-nøkler rives ut atomisk. Dette er netto kompleksitets-reduksjon, ikke teknisk gjeld.
2. **Filter-scope-utvidelse** — miljø- og organisasjons-filtrene på applikasjonsoversikten og tilganger-fanen flyttes fra "*det som faktisk er i lista*" til "*alt brukeren / applikasjonen potensielt kan ha å gjøre med*". Dette krever **nye datakilder** på schemaet:
   - `Applikasjon.potensielleMiljoer` + `Applikasjon.potensielleTildelendeOrganisasjoner` (direkte-felt på Applikasjon, jf. Q3).
   - `Query.megSomApplikasjonsadministrator { organisasjoner, miljoer }` (ny semantisk persona-type, jf. Q2).

**Sekvenserings-strategi (codegen-betinget):**

- **Fase A — Mock-schema-revisjon (atomisk).** Hele schema-deltaen (fjerninger + tillegg + V*-kollaps) lander som én logisk operasjon i `src/mocks/schema/applikasjoner.graphql` + tilhørende mock-types + fixtures + handlers/resolvers. Real-time codegen genererer om `src/__generated__/graphql.ts` umiddelbart; klient-build-en er midlertidig brukken inntil Fase B er gjennomført.
- **Fase B — Klient-koden følger codegen.** Alle TypeScript-feil som oppstår etter Fase A representerer enten (a) referanser til fjernede typer/felt som må fjernes fra klient-koden, eller (b) nye felter som må konsumeres. Tasks 6–13 utfører dette arbeidet samlet — build går grønt igjen etter siste.
- **Fase C — i18n + tester + opprydning.** ~25 ansvarlig-i18n-nøkler fjernes, beskrivelses-streng for domene-index-siden justeres, a11y- og unit-tester oppdateres / slettes for komponenter som er endret eller fjernet.

I praksis lander alle tre fasene i samme MR; sekvenseringen er for å holde commit-historikken lesbar internt i grenen og for å gi reviewer en mental kjøreplan.

### Key Technical Decisions

1. **Kollapser `opprettApplikasjon` til én unversionert mutation (Q1).**
   - Hvorfor: mock-skjemaet har ingen ekstern konsument å bevare bakoverkompatibilitet for. V1/V2/V3-suffikser er meningsfulle kun når reelle klienter må holdes kjørende på gammel shape mens nye lander; her er det rent støy.
   - Alternativer vurdert: (a) reverse til V1, (b) gjør `ansvarligId` valgfri på V2, (c) introduser V3. Forkastet — alle tre videreførte versjons-suffiks-kompleksitet uten gevinst.
   - Producer-side må fortsatt følge normal `@deprecated`-rytme; det er flagget som cross-agent hand-off til `backend`.

2. **Direkte-felt for potential-scope-sett (Q3).**
   - `Applikasjon.potensielleMiljoer: [Miljo!]!` og `Applikasjon.potensielleTildelendeOrganisasjoner: [ApplikasjonOrganisasjon!]!` — direkte på Applikasjon-typen, ikke paginerte sub-queries.
   - Hvorfor: settene er små (`Miljo`-enum har 4 medlemmer; tildelende-organisasjoner forventes ≤ 10). Levetiden følger applikasjonen; ingen grunn til egen lazy-load.
   - Alternativ vurdert: paginerte Connection-typer. Forkastet — feiler `fs-sikt-no-producer-best-practice §Paginering`-tommelfingerregelen (paginering kun når > 10 elementer).

3. **Ny semantisk persona-type `MegSomApplikasjonsadministrator` (Q2).**
   - Top-level query `megSomApplikasjonsadministrator: MegSomApplikasjonsadministrator!` returnerer `{ organisasjoner: [ApplikasjonOrganisasjon!]!, miljoer: [Miljo!]! }`.
   - Hvorfor: gjenbruk av `useMineLaresteder()`/`megVedLarested` er **feil kilde** for kravet "organisasjoner brukeren har applikasjonsadministrator-rolle for" — lærested-affiliasjon ≠ applikasjonsadministrator-rolle (analyse Q2-konklusjon). Egen kilde er nødvendig.
   - Server-side aggregering av miljø-unionen ("alle miljøer på tvers av admin-organisasjonene") fremfor klient-side union-ing av per-org-data: enklere konsumkontrakt, færre wire-trips.
   - Følger `fs-sikt-no-producer-schema-design §Vi innfører gjerne egne felt og typer for semantisk nyttige data-uttrekk` — speiler eksempelet `megSomSoker` fra referansen.

4. **Etabler fragment colocation der vi uansett skriver om filter-komponentene.**
   - `ApplikasjonerMiljoFilter` og `ApplikasjonerOrganisasjonFilter` får colocate-de fragmenter på `MegSomApplikasjonsadministrator`-typen, komponert i en ny screen-level query `GET_APPLIKASJONER_FILTER_OPTIONS`.
   - Hvorfor: per `graphql-golden-path-fragment-colocation` + `graphql-golden-path-query-componentization` er colocation default for ny kode. Filter-komponentene skrives uansett om når dakilden byttes — det koster ingenting ekstra å gjøre det riktig.
   - `OpprettApplikasjonDialog/mutation.ts` beholder flat shape (ikke kolokert) — endringen der er liten nok til at refactor ikke svarer seg; eksplisitt avviks-notat ligger i GraphQL-seksjonens Lag C.

5. **Sletter `Applikasjon/components/SettAnsvarligDialog/`-mappa i sin helhet.**
   - Inkluderer både `SettAnsvarligDialog.tsx`, `searchAnsvarligKandidater.ts`, `settApplikasjonAnsvarligMutation.ts`, tilhørende a11y-tester, og `AnsvarligSearch.tsx` (frittstående komponent i `OpprettApplikasjonDialog/`).
   - Hvorfor: hele ansvarlig-rollen er borte fra kravspekken; det finnes ingen redusert eller omdøpt variant.

6. **Én atomisk MR (Q6, [[feedback_one_mr_per_krav_delta]]).**
   - Hvorfor: aksene ansvarlig-fjerning og filter-scope-utvidelse er konseptuelt ortogonale, men delta-en er avgrenset til én feature-mappe + ett mock-skjema-fil + én i18n-fil. Split gir mer overhead enn den sparer; én MR bevarer "én krav-delta → én MR"-sporbarhet.

### File Changes Overview

**Mock-skjema og fixtures (Fase A):**

- `src/mocks/schema/applikasjoner.graphql` — atomisk fjerning av ansvarlig-overflaten + V2-kollaps + 2 nye felt på `Applikasjon` + 1 ny query + 1 ny type. Detaljer i `## GraphQL-endringer` nedenfor.
- `src/mocks/types/applikasjoner.ts` — speiler schema-typer; fjern `Ansvarlig`, `AnsvarligType`, `AnsvarligIkkeIApplikasjonsOrganisasjon`, `AnsvarligPaakrevdVedOpprettelse`, `OpprettApplikasjonInputV2`, `SettApplikasjonAnsvarligInput`, `FjernApplikasjonAnsvarligInput`. Legg til `MegSomApplikasjonsadministrator`.
- `src/mocks/fixtures/applikasjoner/ansvarlige.ts` — slettes (hele fila).
- `src/mocks/fixtures/applikasjoner/applikasjoner.ts:181-360` — fjern `personaIsAnsvarlig`-flagget og `PERSONA_ANSVARLIG_APP_IDS`-konstanten; den realiserte den nå-fjernede "Synlighet via ansvarlig-relasjon"-regelen. Legg til `potensielleMiljoer` + `potensielleTildelendeOrganisasjoner` per applikasjon i fiksturen.
- `src/mocks/fixtures/applikasjoner/megSomApplikasjonsadministrator.ts` *(ny)* — fixture for persona-scoped admin-organisasjoner + admin-miljøer.
- `src/mocks/handlers/applikasjoner/queries.ts` — fjern `ansvarligKandidater`-resolver; legg til `megSomApplikasjonsadministrator`-resolver + `Applikasjon.potensielleMiljoer`/`Applikasjon.potensielleTildelendeOrganisasjoner`-resolvers.
- `src/mocks/handlers/applikasjoner/mutations.ts` — fjern `settApplikasjonAnsvarlig` + `fjernApplikasjonAnsvarlig` + `opprettApplikasjonV2`-resolvers; flat ut `opprettApplikasjon` til den nye unversionerte shape-en.

**Klient-kode — applikasjonsliste (Fase B):**

- `src/domains/support/features/Applikasjoner/hooks/useGetApplikasjoner.tsx:26-62` — fjern `ansvarlig`-utvelger fra `GET_APPLIKASJONER`-spørringen.
- `src/domains/support/features/Applikasjoner/components/ApplikasjonerResultList.tsx` — fjern `Ansvarlig`-cellen (linje 58 + 112-115); kolonneliste går fra 6 til 5.
- `src/domains/support/features/Applikasjoner/components/filter/ApplikasjonerMiljoFilter/ApplikasjonerMiljoFilter.tsx` — fjern hardkodet `MILJO_OPTIONS = [Produksjon, Demo, Test, Utvikling]` (linje 18). Konsumer `ApplikasjonerMiljoFilterFields`-fragmentet med ref via prop.
- `src/domains/support/features/Applikasjoner/components/filter/ApplikasjonerOrganisasjonFilter/ApplikasjonerOrganisasjonFilter.tsx` — bytt ut `useMineLaresteder()`-konsum (linje 42) med konsum av `ApplikasjonerOrganisasjonFilterFields`-fragmentet via prop.
- `src/domains/support/features/Applikasjoner/hooks/useGetApplikasjonerFilterOptions.tsx` *(ny)* — `GET_APPLIKASJONER_FILTER_OPTIONS`-query som komponer de to filter-fragmentene.
- `src/domains/support/features/Applikasjoner/Applikasjoner.tsx` — wire opp ny filter-options-query; pass fragment-ref ned til de to filtrene.

**Klient-kode — applikasjon-detalj (Fase B):**

- `src/domains/support/features/Applikasjon/components/ApplikasjonInformation.tsx` — fjern `ansvarlig`-union (linje 57-77) + `kanAdministrereAnsvarlig`-felt (linje 88) fra `ApplikasjonInformationFields`-fragmentet. Fjern `Ansvarlig`-`OutputField` (linje 233-256). Bytt seksjons-overskrift fra "Miljøer og ansvarlig" til "Miljøer".
- `src/domains/support/features/Applikasjon/components/RedigerDetaljer/RedigerDetaljerForm.tsx` — fjern `currentAnsvarlig`/`ansvarligDialogMode`-state, `SettAnsvarligDialog`-importen og dirty-tracking-leg-en for ansvarlig (linje 19-22, 187-205). Lagre-handleren går fra 3-vei `Promise.allSettled` til 2-vei (navn + beskrivelse). `kanRedigereDetaljer = kanRedigereNavn || kanRedigereBeskrivelse` (uten `|| kanAdministrereAnsvarlig`).
- `src/domains/support/features/Applikasjon/components/SettAnsvarligDialog/` — **hele mappa slettes** (komponent, mutation, søk-query, a11y-tester, module.css).
- `src/domains/support/features/Applikasjon/components/ApplikasjonTilganger.tsx` — legg `potensielleMiljoer` + `potensielleTildelendeOrganisasjoner` på `ApplikasjonTilgangerFields`-fragmentet (linje 66-78). Fjern `useApolloClient` + `APPLIKASJON_TILGANG_ROW_FRAGMENT` cache-readback + `useMemo`-dedup (linje 131-145). Bytt `availableMiljoer = applikasjon.miljoer` (linje 247) → `availableMiljoer = applikasjon.potensielleMiljoer`. Vurder å reversere lift-up-en av `useApplikasjonTilganger` til Inner-laget — den er ikke lenger nødvendig nå som org-options ikke deriveres fra resultat-radene.

**Klient-kode — opprett-flyt (Fase B):**

- `src/domains/support/features/Applikasjoner/components/OpprettApplikasjonDialog/OpprettApplikasjonDialog.tsx` — fjern `ansvarligId`-felt, ansvarlig-state, ansvarlig-validering, og hele ansvarlig-FieldSet-en. Submit-handler kaller den nye unversionerte `opprettApplikasjon`-mutation-en.
- `src/domains/support/features/Applikasjoner/components/OpprettApplikasjonDialog/mutation.ts:21-57` — bytt `OpprettApplikasjonV2($input: OpprettApplikasjonInputV2!)` til `OpprettApplikasjon($input: OpprettApplikasjonInput!)`. Fjern `AnsvarligPaakrevdVedOpprettelse` fra error-handlingen.
- `src/domains/support/features/Applikasjoner/components/OpprettApplikasjonDialog/AnsvarligSearch.tsx` — **fil slettes** (sammen med `AnsvarligSearch.module.css`).

**i18n + tekst (Fase C):**

- `src/common/messages/nb/support.json` — fjern ~25 `ansvarlig`-nøkler fordelt på fire seksjoner (`OpprettApplikasjonDialog`-blokken linje 79-91 nøkler, `Applikasjon`-blokken linje 107-126 nøkler, `RedigerDetaljerForm`-blokken linje 158-165 nøkler, `SettAnsvarligDialog`-blokken linje 389-403 hele blokken). Juster `applikasjonerDescription` (linje 468) så ordet "ansvarlige" fjernes.

**Tester (Fase C):**

- a11y-tester for endrede komponenter oppdateres: `ApplikasjonerResultList.a11y.test.tsx`, `ApplikasjonerMiljoFilter.a11y.test.tsx`, `ApplikasjonerOrganisasjonFilter.a11y.test.tsx`, `ApplikasjonInformation.a11y.test.tsx`, `ApplikasjonTilganger.a11y.test.tsx`, `OpprettApplikasjonDialog.a11y.test.tsx`, `RedigerDetaljerForm.a11y.test.tsx`.
- a11y-tester for slettede komponenter slettes med dem: `SettAnsvarligDialog.a11y.test.tsx`, `AnsvarligSearch.a11y.test.tsx`.
- Unit-tester / Storybook-stories tilsvarende.

## GraphQL-endringer

> **Premiss:** konservativ — minst mulig schema-endring som dekker krav-deltaen, men med eksplisitt brudd på normal V2-utfasing der Q1-beslutningen krever det.
> **Domeneterm:** `Applikasjon` (uendret); `MegSomApplikasjonsadministrator` (ny semantisk type per `fs-sikt-no-producer-schema-design §Vi innfører gjerne egne felt og typer for semantisk nyttige data-uttrekk`).
> **Følger fra:** [`analysis-applikasjon-tilgangsstyring-justeringer.md`](analysis-applikasjon-tilgangsstyring-justeringer.md) — Findings F1, F3, F4 + besluttede Open Questions Q1, Q2, Q3.

### Sammendrag

- **1 ny query** (`megSomApplikasjonsadministrator`) + **1 ny semantisk type** (`MegSomApplikasjonsadministrator`).
- **1 endret mutation** (`opprettApplikasjon` — kollapser V1 + V2 til én unversionert form).
- **2 nye felt på eksisterende `Applikasjon`** (`potensielleMiljoer`, `potensielleTildelendeOrganisasjoner`).
- **Betydelige fjerninger** av hele ansvarlig-overflaten (1 union, 1 enum, 2 mutations, 1 query, 3 inputs, 2 error-typer, 2 payloads, 1 boolean permission-felt) — listet i egen *Schema-fjerninger*-subseksjon.
- **2 åpne spørsmål** til producer-team (begge cross-agent).

### Schema-fjerninger

Disse deklarasjonene fjernes fra `src/mocks/schema/applikasjoner.graphql` (og deres tilsvar i ekte producer-schema, jf. cross-agent hand-off i *Risk Assessment*):

```graphql
# --- Felt på Applikasjon ---
type Applikasjon {
  ansvarlig: Ansvarlig                   # FJERN
  kanAdministrereAnsvarlig: Boolean!     # FJERN
  # (øvrige felt urørt)
}

# --- Typer / unions / enums ---
union Ansvarlig = FeideBruker | FeideGruppe   # FJERN
enum AnsvarligType { FEIDE_BRUKER FEIDE_GRUPPE }  # FJERN

# --- Error-typer ---
type AnsvarligIkkeIApplikasjonsOrganisasjon implements Error { ... }   # FJERN
type AnsvarligPaakrevdVedOpprettelse implements Error { ... }          # FJERN

# --- Inputs ---
input OpprettApplikasjonInputV2 { ... }              # FJERN (kollapses inn i nytt OpprettApplikasjonInput, se Op #1)
input SettApplikasjonAnsvarligInput { ... }          # FJERN
input FjernApplikasjonAnsvarligInput { ... }         # FJERN

# --- Query-felt ---
extend type Query {
  ansvarligKandidater(applikasjonsId: ID!, soketekst: String): [Ansvarlig!]!   # FJERN
}

# --- Mutation-felt + payloads / dokumentasjons-unions ---
extend type Mutation {
  opprettApplikasjonV2(input: OpprettApplikasjonInputV2!): OpprettApplikasjonPayload!   # FJERN
  settApplikasjonAnsvarlig(input: SettApplikasjonAnsvarligInput!): SettApplikasjonAnsvarligPayload!   # FJERN
  fjernApplikasjonAnsvarlig(input: FjernApplikasjonAnsvarligInput!): FjernApplikasjonAnsvarligPayload!   # FJERN
}
type SettApplikasjonAnsvarligPayload { ... }         # FJERN
type FjernApplikasjonAnsvarligPayload { ... }        # FJERN
union SettApplikasjonAnsvarligError = ...            # FJERN
union FjernApplikasjonAnsvarligError = ...           # FJERN

# --- Justering i eksisterende dokumentasjons-union for opprettApplikasjon ---
union OpprettApplikasjonError =
  | IdentitetsleverandorIdIkkeFunnet
  | IdentitetsleverandorIdAlleredeIBruk
  | VisningsnavnAlleredeIBruk
  | NavnAlleredeIBruk
  # | AnsvarligPaakrevdVedOpprettelse   <-- FJERN dette medlemmet
  | UgyldigInput
```

**Begrunnelse:**
- F1 / F5 i analysen + krav-delta `11ce66c` fjerner hele ansvarlig-rollen som distinkt entitet — det finnes ingen redusert variant å bevare. Schema-kontrakten skal speile kravspekken.
- Versjonering-merknad: normalt vil `opprettApplikasjonV2` og dens input-type vært `@deprecated`-merket i en periode per `fs-sikt-no-producer-schema-design §Endringer i API bør ikke ødelegge for klienter`. **Vi avviker bevisst** — mock-skjemaet har ingen ekstern konsument og ingen produksjons-trafikk å bevare bakoverkompatibilitet for (Q1-beslutning + memory `feedback_no_schema_versioning_in_mocks`). For produsent-siden gjelder normal utfasings-rytme; cross-agent hand-off til `backend` klargjør dette.

### Operasjoner

#### Op #1: `opprettApplikasjon` — kollapse V1 + V2 til én unversionert mutation

**Dekker krav:** BRU-APP-API-009 (`opprette_applikasjon.feature`, iter 3).
**Implementeres av:** Task #2 (schema-side) og Task #11 (klient-side).

##### Lag A — Schema-tillegg

```graphql
# Erstatter både eksisterende OpprettApplikasjonInput (V1, deprecated) og
# OpprettApplikasjonInputV2 — Q1-beslutning: ingen V*-suffiks i mock-skjemaet.
input OpprettApplikasjonInput {
  identitetsleverandor: IdentitetsleverandorType!
  eksternId: String!
  organisasjonsId: ID!
  navn: String!
  # `ansvarligId` er bevisst utelatt — krav-delta fjerner ansvarlig-rollen.
  # `beskrivelse` er fortsatt utelatt — settes via redigerApplikasjonBeskrivelse
  # etter opprettelsen, samme kontrakt som V2 hadde.
}

# Payload urørt — beholder `applikasjon: Applikasjon` + `errors: [Error!]`.
# Eneste endring er at AnsvarligPaakrevdVedOpprettelse forsvinner fra
# dokumentasjons-unionen (se Schema-fjerninger over).

extend type Mutation {
  opprettApplikasjon(input: OpprettApplikasjonInput!): OpprettApplikasjonPayload!
}
```

##### Lag B — fs-admin call-site

Området `OpprettApplikasjonDialog/` har i dag flat shape (én topp-level mutation uten fragment-spread). For *ny* kode default-er vi til colocation, men her er endringen så liten (én mutation, payload bare brukt til router-redirect på applikasjonens `id`) at vi speiler eksisterende stil og noterer avviket eksplisitt i Lag C.

```ts
// src/domains/support/features/Applikasjoner/components/OpprettApplikasjonDialog/mutation.ts
export const OPPRETT_APPLIKASJON = gql(/* GraphQL */ `
  mutation OpprettApplikasjon($input: OpprettApplikasjonInput!) {
    opprettApplikasjon(input: $input) {
      applikasjon {
        id
      }
      errors {
        __typename
        ... on Error {
          message
          path
        }
        ... on NavnAlleredeIBruk {
          konfliktMedApplikasjonId
        }
        ... on IdentitetsleverandorIdAlleredeIBruk {
          eksisterendeApplikasjon {
            id
            navn
          }
        }
      }
    }
  }
`)
```

```ts
// Skisse i OpprettApplikasjonDialog.tsx — IKKE for build, kun for reviewer
const [opprett, { loading }] = useMutation(OPPRETT_APPLIKASJON, {
  onCompleted: (data) => {
    if (data.opprettApplikasjon.errors.length === 0 && data.opprettApplikasjon.applikasjon) {
      router.push(`/tilgangsstyring/applikasjoner/${data.opprettApplikasjon.applikasjon.id}`)
    }
  },
})
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-APP-API-009 — "Opprettelse krever et navn / valg av identitetsleverandør / en organisasjon" (per `opprette_applikasjon.feature` Regel-blokken). Ansvarlig-Regel er fjernet, så input mister sitt `ansvarligId`-felt.
- **Form:** Én mutation uten V*-suffiks. Mutasjonsfelt på toppnivå-`Mutation` per `fs-sikt-no-producer-best-practice §Bare felt på Mutation-typen kan utføre endringer`. Felt-navn `navn`/`organisasjonsId`/`identitetsleverandor` følger lowerCamelCase + norsk-for-domene per `fs-sikt-no-producer-naming §Bruk norsk for domenebegreper og dagligspråk, engelsk for tekniske begreper` + `§Bruk lowerCamelCase for å skille mellom ord`.
- **Nullability:** `navn`, `organisasjonsId`, `identitetsleverandor`, `eksternId` er `!` fordi opprettelsen ikke gir mening uten — typen ville måtte settes til null hvis et felt mangler, og kravet er at alle fire er obligatoriske. Per `fs-sikt-no-producer-best-practice §Nullability`.
- **Colocation-status:** *Ikke best practice — speiler eksisterende ikke-kolokert mønster i `OpprettApplikasjonDialog/`*. Mutation-payloaden brukes kun til redirect + envelope-error-håndtering; ingen rad-komponent som leser applikasjons-felt etter opprettelse. Refactor til colocation kan legges inn som separat Task hvis ønsket, men gir liten gevinst her.
- **Konvensjons-avvik (versjonering):** Ingen `@deprecated` på V1/V2 før fjerning. Per `fs-sikt-no-producer-schema-design §Endringer i API bør ikke ødelegge for klienter` er det normalt påkrevd, men dette er **mock-only**-skjema uten produksjons-konsumenter (Q1-beslutning, `feedback_no_schema_versioning_in_mocks`-memory). Producer-side følger normal utfasings-rytme — flagget som Open Question 1 nedenfor.
- **Alternativer vurdert (jf. analyse F3):**
  - **(a)** Reverse til V1 (`opprettApplikasjon` uten `navn`) — forkastet: V2's strammere kontrakt (`navn` obligatorisk) er fortsatt kravet.
  - **(b)** Gjør `ansvarligId` valgfri på V2 — forkastet: holder V*-suffiks for ingen reell gevinst i mock-only-skjemaet.
  - **(c)** Introduser V3 — forkastet: dobbel deprecation-load uten konsumenter å beskytte.
- **Error-union:** Dokumentasjons-`OpprettApplikasjonError` får ett medlem mindre (`AnsvarligPaakrevdVedOpprettelse` fjernes). Den selve `errors: [Error!]`-overflate-typen på payloaden er uendret — fortsatt interface-form per eksisterende mock-konvensjon (avvik fra ref-tabellens "plural `Errors`-union" — eksisterende mønster gjelder, se *Tverrgående schema-bekymringer → Error-envelope-form*).

#### Op #2: `Applikasjon.potensielleMiljoer` + `Applikasjon.potensielleTildelendeOrganisasjoner` — felter for Tilganger-fanens filter-scope

**Dekker krav:** BRU-APP-API-003 (`vise_tilganger.feature` scenariene `Tilgjengelige miljøer i filter` + `Tilgjengelige organisasjoner i filter`).
**Implementeres av:** Task #3 (schema-side) og Task #12 (klient-side).

##### Lag A — Schema-tillegg

```graphql
extend type Applikasjon {
  """
  Miljøene applikasjonen kan tildeles tilganger i — uavhengig av om den
  faktisk *har* tilganger i miljøet ennå. Brukes som filter-option-set i
  Tilganger-fanens miljø-filter (BRU-APP-API-003). Settet er lite (typisk
  ≤ 4, samme størrelse som `Miljo`-enumet) og ustabilt ved drift, derfor
  un-paginert array fremfor Connection.
  """
  potensielleMiljoer: [Miljo!]!

  """
  Organisasjoner som kan gi denne applikasjonen tilganger — typisk
  applikasjonens eier-organisasjon pluss organisasjoner som har en
  delegert tildelings-rolle. Brukes som filter-option-set i Tilganger-fanens
  organisasjons-filter (BRU-APP-API-003). Settet forventes ≤ 10 i praksis.
  """
  potensielleTildelendeOrganisasjoner: [ApplikasjonOrganisasjon!]!
}
```

##### Lag B — fs-admin call-site

Området `Applikasjon/components/` colocate-r fragmenter i dag (`ApplikasjonInformationFields`, `ApplikasjonTilgangerFields`, `ApplikasjonTopBarFields`). De nye feltene legges på det eksisterende `ApplikasjonTilgangerFields`-fragmentet:

```ts
// src/domains/support/features/Applikasjon/components/ApplikasjonTilganger.tsx
export const APPLIKASJON_TILGANGER_FRAGMENT = gql(/* GraphQL */ `
  fragment ApplikasjonTilgangerFields on Applikasjon {
    id
    status
    miljoer
    organisasjon {
      id
      navn
    }
    kanTildeleTilganger
    kanFjerneTilganger
    # Nye felt — option-set for filter-sidebar + chips-row:
    potensielleMiljoer
    potensielleTildelendeOrganisasjoner {
      id
      navn
    }
  }
`)
```

```ts
// Skisse i ApplikasjonTilgangerInner — IKKE for build, kun for reviewer.
// Erstatter dagens client-side dedup via apolloClient.cache.readFragment
// (`ApplikasjonTilganger.tsx:131-145`) og dagens availableMiljoer-utledning
// (linje 247) fra `applikasjon.miljoer`.
const availableMiljoer = applikasjon.potensielleMiljoer
const availableOrganisasjoner = applikasjon.potensielleTildelendeOrganisasjoner
// Fjernes: useApolloClient + APPLIKASJON_TILGANG_ROW_FRAGMENT cache-readback,
// useMemo-dedup, og lift-up av useApplikasjonTilganger til Inner-laget bare
// for å fylle org-filteret. Tilganger-loaden kan bli result-list-only igjen.
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-APP-API-003 — den autoritative "potential scope"-lesningen (Q4-beslutning).
- **Form (array vs. Connection):** Un-paginert `[Miljo!]!` og `[ApplikasjonOrganisasjon!]!`. Per `fs-sikt-no-producer-best-practice §Paginering` er Connection-mønsteret default, men tommelfingerregelen "paginer om det kan være mer enn 10 elementer" gir grønt lys for arrays her: `Miljo`-enumet har 4 medlemmer ved konstruksjon, og "tildelende organisasjoner" pr. applikasjon forventes ≤ 10 (typisk eier-organisasjonen pluss et lite antall delegerings-relasjoner). Producer-team validerer settets typiske/maks størrelse — Open Question 2 nedenfor.
- **Nullability:** Begge er `[Type!]!` — listen er alltid definert (kan være tom). Per `fs-sikt-no-producer-best-practice §Nullability` lar vi normalt felt være nullable, men en filter-option-liste som forsvinner gir UI-tvetydighet ("er filteret tomt eller ukjent?"). Tom-liste vs. null-liste er forskjellige tilstander her, og kravet sier filteret skal vises alltid (default "Alle miljøer" / "Alle organisasjoner") — derfor non-null både utad og innad.
- **Plassering på `Applikasjon`-typen vs. sub-query:** Direkte felter (Q3-beslutning) fremfor egen `Query.potensielleMiljoerForApplikasjon(id: ID!)`-query. Begrunnelse: settene er bundet til applikasjonen som entitet, samme livssyklus, og leveres allerede sammen med Applikasjon-detalj-spørringen i samme `useGetApplikasjon`-call. Sub-query ville krevd egen lazy-load uten gevinst.
- **Colocation-status:** Følger colocation — feltene legges på det eksisterende `ApplikasjonTilgangerFields`-fragmentet som rendres ved siden av `ApplikasjonTilganger.tsx`-komponenten. Per `graphql-golden-path-fragment-colocation §Implementation notes` ("each fragment and operation belongs to a component") og `graphql-golden-path-query-componentization §Why this should be default`.
- **Anti-pattern fjernet:** Sletter dagens client-side dedup av `availableOrganisasjoner` via `apolloClient.cache.readFragment` (`ApplikasjonTilganger.tsx:131-145`) — den var en dokumentert svakhet (analyse `Technical Constraints → fs-admin-mønstrene`: DetailPageLayout-pattern §1 forbyr klient-deriverte filter-option-sett). Krav-endringen forenkler oss ut av den.
- **Navne-valg:** `potensielleMiljoer` er entydig (`potensielle` = "potential scope", `Miljoer` er etablert i schemaet). `potensielleTildelendeOrganisasjoner` er mer awkward (presens-participium "tildelende"); alternativer: `tildelendeOrganisasjoner`, `organisasjonerSomKanTildeleTilganger`, `mulige TildelerOrganisasjoner`. Speilet "potensielle"-prefiks gir leselig symmetri. Hvis producer-team foretrekker annet navn, ramler ikke implementasjonen — flagges i Open Question 2.

#### Op #3: `megSomApplikasjonsadministrator` — persona-scope-query for listevisning-filtre

**Dekker krav:** BRU-APP-API-001 (`listevisning_og_sok.feature` scenariene `Tilgjengelige miljøer i filter` + `Tilgjengelige organisasjoner i filter`).
**Implementeres av:** Task #4 (schema-side) og Task #6–7 (klient-side).

##### Lag A — Schema-tillegg

```graphql
"""
Persona-scopet datasett for den innloggede brukerens applikasjonsadministrator-
rolle. Bundler "min admin-organisasjoner" og "min admin-miljøer" på én
semantisk node slik at producer kan beregne unionen server-side. Mengdene
er små (≤ 10–20 i praksis) — un-paginert array er hensiktsmessig.

Følger samme mønster som eksisterende `megVedLarested: [PersonProfil]` — en
persona-scoped query — men returnerer en semantisk type fremfor en
applikasjons-uavhengig affiliasjons-liste.
"""
type MegSomApplikasjonsadministrator {
  """
  Organisasjonene brukeren har applikasjonsadministrator-rolle for.
  Brukes som option-set for applikasjonsoversiktens organisasjons-filter.
  """
  organisasjoner: [ApplikasjonOrganisasjon!]!

  """
  Unionen av miljøer applikasjoner kan tilordnes tilganger i, beregnet på
  tvers av brukerens admin-organisasjoner. Server-side aggregert for å
  unngå at klienten må fetche per-org og union-e selv. Brukes som option-set
  for applikasjonsoversiktens miljø-filter.
  """
  miljoer: [Miljo!]!
}

extend type Query {
  """
  Returnerer persona-scoped applikasjonsadministrator-data for den innloggede
  brukeren. Returnerer aldri null — en bruker uten admin-rolle får tomme
  arrays. Krever ingen argumenter; subjekt er den autentiserte brukeren.
  """
  megSomApplikasjonsadministrator: MegSomApplikasjonsadministrator!
}
```

##### Lag B — fs-admin call-site

Filter-komponentene (`ApplikasjonerMiljoFilter.tsx`, `ApplikasjonerOrganisasjonFilter.tsx`) er per i dag ikke colocate-d (de leser via en separat global-context-hook). Siden vi byter ut data-kilden uansett, etablerer vi colocation her — én fragment per filter-komponent + én komponert topp-level query som issuer det:

```ts
// src/domains/support/features/Applikasjoner/components/filter/ApplikasjonerMiljoFilter/ApplikasjonerMiljoFilter.tsx
export const APPLIKASJONER_MILJO_FILTER_FRAGMENT = gql(/* GraphQL */ `
  fragment ApplikasjonerMiljoFilterFields on MegSomApplikasjonsadministrator {
    miljoer
  }
`)
```

```ts
// src/domains/support/features/Applikasjoner/components/filter/ApplikasjonerOrganisasjonFilter/ApplikasjonerOrganisasjonFilter.tsx
export const APPLIKASJONER_ORGANISASJON_FILTER_FRAGMENT = gql(/* GraphQL */ `
  fragment ApplikasjonerOrganisasjonFilterFields on MegSomApplikasjonsadministrator {
    organisasjoner {
      id
      navn
    }
  }
`)
```

```ts
// src/domains/support/features/Applikasjoner/hooks/useGetApplikasjonerFilterOptions.tsx
// Topp-level query — issuer fragmentene som filter-komponentene definerer.
// Lever ved siden av useGetApplikasjoner (skjerm-nivå query for selve listen)
// fordi filter-options har egen livssyklus (caches lenger; orthogonal til
// liste-refetch ved filter-endring).
export const GET_APPLIKASJONER_FILTER_OPTIONS = gql(/* GraphQL */ `
  query GetApplikasjonerFilterOptions {
    megSomApplikasjonsadministrator {
      ...ApplikasjonerMiljoFilterFields
      ...ApplikasjonerOrganisasjonFilterFields
    }
  }
`)
```

```ts
// Skisse i Applikasjoner.tsx eller en wrapper — IKKE for build, kun for reviewer.
// Erstatter dagens hardkodede MILJO_OPTIONS (linje 18) og
// useMineLaresteder()-konsum i ApplikasjonerOrganisasjonFilter (linje 42).
const { data } = useQuery(GET_APPLIKASJONER_FILTER_OPTIONS)
// Pass fragment-ref ned til filtrene; de bruker useFragment for sin slice.
<ApplikasjonerMiljoFilter optionsRef={data?.megSomApplikasjonsadministrator} ... />
<ApplikasjonerOrganisasjonFilter optionsRef={data?.megSomApplikasjonsadministrator} ... />
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-APP-API-001 — den nye persona-scope-semantikken: miljø-filteret skal liste "alle miljøer applikasjoner kan tilordnes tilganger i, på tvers av organisasjonene brukeren har rettighet til"; organisasjons-filteret skal liste "alle organisasjoner brukeren har rettighet til".
- **Form (semantisk type vs. paret felter direkte på `Query`):** Egen `MegSomApplikasjonsadministrator`-type. Per `fs-sikt-no-producer-schema-design §Vi innfører gjerne egne felt og typer for semantisk nyttige data-uttrekk` — `MegSomApplikasjonsadministrator` følger samme mønster som referansens `MegSomSoker`-eksempel: persona-scoped data bundlet under én navngitt node, ikke spredt utover `Query`-typen som `mineAdminOrganisasjoner` + `mineAdminMiljoer`.
- **Form (array vs. Connection):** Un-paginerte arrays — administrator-organisasjoner og deres deriverte miljø-union forventes ≤ 10 i praksis. Per `fs-sikt-no-producer-best-practice §Paginering` (tommelfingerregel: paginering når > 10 elementer). Hvis producer-team finner at ≤ 10 ikke holder for super-administratorer, flyttes til Connection — Open Question 1.
- **Nullability:** Roten `megSomApplikasjonsadministrator: MegSomApplikasjonsadministrator!` er non-null fordi vi alltid kan returnere typen (tomme arrays for brukere uten admin-rolle). Per `fs-sikt-no-producer-best-practice §Nullability` — typen *gir mening* også for uautoriserte: arrays er tomme, UI viser "ingen organisasjoner" / fall-back. Begge felt-arrays er `[Type!]!` av samme grunn som Op #2.
- **Skiller fra `megVedLarested`:** `megVedLarested` modellerer en helt annen rolle (lærested-affiliasjon, ikke applikasjonsadministrator-rolle) — disse mengdene overlapper kanskje, men er ikke definert til å være like (analyse Q2-konklusjon). Egen kilde er korrekt; å gjenbruke `megVedLarested` ville videreført dagens feil.
- **Colocation-status:** Følger colocation per `graphql-golden-path-fragment-colocation §Implementation notes` ("each fragment and operation belongs to a component") + `graphql-golden-path-query-componentization §Why this should be default`. Vi *etablerer* colocation her — eksisterende code-paths (`ApplikasjonerMiljoFilter` med `MILJO_OPTIONS`-hardkode, `ApplikasjonerOrganisasjonFilter` med `useMineLaresteder()`) skrives uansett om, så det er gratis å gå rett til colocation.
- **Naming:** `megSomApplikasjonsadministrator` (én streng, lowerCamelCase, ÆØÅ→AOA, intet prefiks "min" — speiler `megVedLarested`-mønsteret). Per `fs-sikt-no-producer-naming §Bruk lowerCamelCase` + `§Bruk norsk for domenebegreper`.
- **Hvorfor egen query og ikke felt på en hypotetisk `Query.meg`:** Mock-skjemaet har i dag ikke en `meg`-rotstype — alle persona-felt er flat på `Query` (`megVedLarested`). Vi speiler eksisterende stil. Hvis producer-team innfører en `Meg`-aggregat-type senere kan `megSomApplikasjonsadministrator` flyttes inn på den uten å bryte konsumentene (det blir bakoverkompatibel flytting via alias-felt).

### Tverrgående schema-bekymringer

#### Permission-modell

`Applikasjon.kanAdministrereAnsvarlig: Boolean!` fjernes som del av Schema-fjerninger-blokken (det er ikke en separat operasjon, men en tverrgående konsekvens av ansvarlig-fjerningen — eksplisitt nevnt her så reviewer ikke leter etter den i Op-blokkene). Eksisterende `kanRedigereNavn`, `kanRedigereBeskrivelse`, `kanTildeleTilganger`, `kanFjerneTilganger` står urørt.

For Op #3 (`megSomApplikasjonsadministrator`): permission-modellen *er* selve query-en — den returnerer kun organisasjoner/miljøer brukeren har applikasjonsadministrator-rolle for. Server-side authorization, ikke et client-side flagg.

#### Error-envelope-form (avvik fra skill-tabellen)

Skill-tabellen anbefaler plural `<Verb><Substantiv>Errors`-union på payload. **Eksisterende mock-skjema** bruker derimot interface-form (`errors: [Error!]`) med en sibling dokumentasjons-`<Op>Error`-union (singular). Dette er det etablerte mønsteret — se headeren ved error-typene i `applikasjoner.graphql:368-371`. Vi speiler det. Ingen ny mutation introduseres, så avviket ligger kun på Op #1's payload, der vi beholder `[Error!]` urørt og bare oppdaterer dokumentasjons-unionen `OpprettApplikasjonError` (medlemmet `AnsvarligPaakrevdVedOpprettelse` fjernes). Producer-side bør beholde samme form for konsistens.

#### Sporings-felter

Ikke relevant for denne deltaen — `MegSomApplikasjonsadministrator` er persona-derivert og har ingen "opprettet av / endret av"-semantikk. `Applikasjon.opprettetAv`/`endretAv`/`opprettet`/`endret` (eksisterende) urørt.

#### Versjonering

Dekket i Op #1 Lag C + Schema-fjerninger-begrunnelsen. Hovedpunkt: vi avviker fra `fs-sikt-no-producer-schema-design §Endringer i API bør ikke ødelegge for klienter` *kun* fordi mock-skjemaet har ingen ekstern konsument. Producer-side følger normal `@deprecated`-rytme — det er en del av cross-agent hand-off til `backend`-agenten.

### Åpne spørsmål

- [ ] **Q1 (cross-agent: `backend`)** — **Versjonerings-strategi på produsent-siden.** Mock-skjemaet kollapser V1 + V2 til en unversionert `opprettApplikasjon` (per Q1-beslutning i analysen). På ekte produksjons-skjema må V2 antagelig deprecateres med varselperiode per `fs-sikt-no-producer-schema-design §Endringer i API bør ikke ødelegge for klienter`. Klienten kan operere på den nye unversionerte formen uavhengig av hvilken rytme producer velger — men vi trenger en bekreftelse på at producer beholder feltet selvkonsistent (samme `OpprettApplikasjonInput`-shape) når de lander det. **Blokkerer ikke** klient-implementasjonen mot mock, men må avklares før vi peker fs-admin på ekte producer.

- [ ] **Q2 (cross-agent: `backend`)** — **Navngiving + sett-størrelse for `potensielleTildelendeOrganisasjoner` og `MegSomApplikasjonsadministrator`.**
  - Producer-team eier domene-terminologi — er `potensielleTildelendeOrganisasjoner` det riktige navnet? Alternativer: `tildelendeOrganisasjoner` (uten "potensielle"-prefiks, semantisk implisitt), `organisasjonerSomKanTildeleTilganger` (mer beskrivende men lengre). Symmetri med `potensielleMiljoer` peker mot dagens valg.
  - Forventet maks-størrelse på `MegSomApplikasjonsadministrator.organisasjoner` for super-administratorer? Hvis > 10 i praksis, må vi flytte til Connection-mønster. Default-antagelse: ≤ 10 (un-paginert array). Implementasjon-impact på fs-admin er begrenset — Apollo-konsum endres minimalt om vi går til Connection senere.

## Implementation Tasks

> Tasks er gruppert i tre faser som matcher sekvenseringen i *Architecture Approach*. Innen en MR er fase-grensene logiske, ikke commit-grenser.

### Fase A — Mock-skjema og fixtures (atomisk)

#### Task #1: Fjern ansvarlig-overflaten fra mock-skjemaet

**Priority:** High
**Size:** M (3–4 h)
**Dependencies:** None
**Addresses Requirements:** BRU-APP-API-001 (kolonne), BRU-APP-API-002 (felt + scenario), BRU-APP-API-005 (hele kapabilitet fjernet)

**Acceptance Criteria:**

- [ ] `src/mocks/schema/applikasjoner.graphql` har ingen referanser til `ansvarlig`, `Ansvarlig`, `AnsvarligType`, `AnsvarligIkkeIApplikasjonsOrganisasjon`, `AnsvarligPaakrevdVedOpprettelse`, `kanAdministrereAnsvarlig`, `settApplikasjonAnsvarlig`, `fjernApplikasjonAnsvarlig`, `ansvarligKandidater`, `SettApplikasjonAnsvarligInput`, `FjernApplikasjonAnsvarligInput`, `SettApplikasjonAnsvarligPayload`, `FjernApplikasjonAnsvarligPayload`, `SettApplikasjonAnsvarligError`, `FjernApplikasjonAnsvarligError`.
- [ ] Dokumentasjons-unionen `OpprettApplikasjonError` har ikke lenger `AnsvarligPaakrevdVedOpprettelse` som medlem.
- [ ] `src/mocks/types/applikasjoner.ts` speiler schema (ingen ansvarlig-typer).
- [ ] `src/mocks/handlers/applikasjoner/mutations.ts` har ikke `settApplikasjonAnsvarlig`/`fjernApplikasjonAnsvarlig`-resolvers.
- [ ] `src/mocks/handlers/applikasjoner/queries.ts` har ikke `ansvarligKandidater`-resolver.
- [ ] `src/mocks/fixtures/applikasjoner/ansvarlige.ts` er slettet.
- [ ] `src/mocks/fixtures/applikasjoner/applikasjoner.ts` har ikke `personaIsAnsvarlig`-flagget eller `PERSONA_ANSVARLIG_APP_IDS`-konstanten (linje 181-360 i før-versjonen).

**Implementation Notes:**

- Real-time codegen i `npm run watch:codegen` regenererer `src/__generated__/graphql.ts` umiddelbart. Klient-build vil ha mange TypeScript-feil etter denne Tasken — det er forventet og rettes i Fase B.
- Tasken landes som én commit for å holde codegen-baseline-en konsistent.

#### Task #2: Kollapse `opprettApplikasjon`-mutation (V1 + V2 → unversionert)

**Priority:** High
**Size:** S (1–2 h)
**Dependencies:** Task #1 (samme schema-fil; landes typisk samme commit)
**Addresses Requirements:** BRU-APP-API-009 (`opprette_applikasjon.feature` iter 3)

**Acceptance Criteria:**

- [ ] `src/mocks/schema/applikasjoner.graphql` har **én** `opprettApplikasjon`-mutation-felt (ingen `opprettApplikasjonV2`, ingen `@deprecated`-V1).
- [ ] `input OpprettApplikasjonInput { identitetsleverandor, eksternId, organisasjonsId, navn }` — alle obligatoriske, ingen `ansvarligId`-felt.
- [ ] `input OpprettApplikasjonInputV2` er slettet.
- [ ] `src/mocks/handlers/applikasjoner/mutations.ts` har én flat `opprettApplikasjon`-resolver som mapper input → fixture-creation. Ingen V2-resolver.
- [ ] Resolveren validerer `navn` (obligatorisk, navn-unique på tvers av fixture-listen) og returnerer `NavnAlleredeIBruk`-error ved konflikt.

**Implementation Notes:**

- Følger Op #1 i GraphQL-seksjonen ordrett.
- Resolveren skal *ikke* validere `ansvarligId` (eksisterer ikke lenger som krav).

#### Task #3: Legg til `Applikasjon.potensielleMiljoer` + `Applikasjon.potensielleTildelendeOrganisasjoner`

**Priority:** High
**Size:** M (3–4 h)
**Dependencies:** Task #1
**Addresses Requirements:** BRU-APP-API-003 (`vise_tilganger.feature` — filter-scope-scenariene)

**Acceptance Criteria:**

- [ ] `Applikasjon`-typen i `src/mocks/schema/applikasjoner.graphql` har to nye felt: `potensielleMiljoer: [Miljo!]!` + `potensielleTildelendeOrganisasjoner: [ApplikasjonOrganisasjon!]!`.
- [ ] `src/mocks/types/applikasjoner.ts` speiler de nye feltene.
- [ ] `src/mocks/fixtures/applikasjoner/applikasjoner.ts` definerer realistiske verdier for de to feltene pr. applikasjon-fixture (typisk 2–4 miljøer + 1–3 organisasjoner).
- [ ] `src/mocks/handlers/applikasjoner/queries.ts` har resolvers for de to nye feltene som leser fra fixturen.
- [ ] Resolverne håndterer `null`-applikasjon gracefully (returnerer `[]` i error-state, ikke kaster).

**Implementation Notes:**

- Følger Op #2 i GraphQL-seksjonen.
- For fixtures: bruk eksisterende `Miljo`-enum + eksisterende `ApplikasjonOrganisasjon`-fixtures. Ingen nye typer trengs.

#### Task #4: Legg til `Query.megSomApplikasjonsadministrator` + `MegSomApplikasjonsadministrator`-type

**Priority:** High
**Size:** M (3–4 h)
**Dependencies:** Task #1
**Addresses Requirements:** BRU-APP-API-001 (`listevisning_og_sok.feature` — Tilgjengelige miljøer/organisasjoner i filter)

**Acceptance Criteria:**

- [ ] `type MegSomApplikasjonsadministrator { organisasjoner: [ApplikasjonOrganisasjon!]!, miljoer: [Miljo!]! }` finnes i `src/mocks/schema/applikasjoner.graphql`.
- [ ] `Query.megSomApplikasjonsadministrator: MegSomApplikasjonsadministrator!` finnes.
- [ ] `src/mocks/types/applikasjoner.ts` speiler den nye typen.
- [ ] `src/mocks/fixtures/applikasjoner/megSomApplikasjonsadministrator.ts` *(ny fil)* definerer realistisk persona-data: 2–4 admin-organisasjoner + et utvalg miljøer brukeren har rolle i.
- [ ] `src/mocks/handlers/applikasjoner/queries.ts` har en `megSomApplikasjonsadministrator`-resolver som returnerer fixturen.
- [ ] Resolveren returnerer alltid en non-null `MegSomApplikasjonsadministrator`-verdi (med tomme arrays for "uautorisert"-persona-variant).

**Implementation Notes:**

- Følger Op #3 i GraphQL-seksjonen.
- Verifiser at fixture-datasettet harmoniserer med `applikasjoner.ts`-fixturen — admin-organisasjoner i `megSomApplikasjonsadministrator` skal overlappe med organisasjons-id-ene som forekommer som `applikasjon.organisasjon.id` i applikasjons-fixturen, ellers blir filteret tomt i mocked UI.

### Fase B — Klient-koden følger codegen

#### Task #5: Fjern `ansvarlig`-utvelger fra `GET_APPLIKASJONER`-spørringen og kolonnen fra `ApplikasjonerResultList`

**Priority:** High
**Size:** S (1–2 h)
**Dependencies:** Task #1
**Addresses Requirements:** BRU-APP-API-001 (`listevisning_og_sok.feature` — kolonne `Ansvarlig` fjernet)

**Acceptance Criteria:**

- [ ] `useGetApplikasjoner.tsx:26-62` har ikke `ansvarlig`-utvelger i `GET_APPLIKASJONER`.
- [ ] `ApplikasjonerResultList.tsx` rendrer 5 kolonner (Navn/beskrivelse, Miljøer, Organisasjon, Antall tilganger, Status) — ikke 6.
- [ ] Linje 58 + 112-115 (Ansvarlig-cellen) er fjernet.
- [ ] Tabellens kolonne-header-rekkefølge er konsistent med rad-rekkefølgen.
- [ ] TypeScript-build går grønt for denne fila etter endringen.

#### Task #6: Refaktorer `ApplikasjonerMiljoFilter` til å konsumere `MegSomApplikasjonsadministrator.miljoer`

**Priority:** High
**Size:** M (3–4 h)
**Dependencies:** Task #4
**Addresses Requirements:** BRU-APP-API-001 (Tilgjengelige miljøer i filter — persona scope)

**Acceptance Criteria:**

- [ ] `ApplikasjonerMiljoFilter.tsx` har ikke `MILJO_OPTIONS`-hardkode (linje 18 i før-versjonen).
- [ ] Komponenten definerer `APPLIKASJONER_MILJO_FILTER_FRAGMENT` (fragment på `MegSomApplikasjonsadministrator` — felt `miljoer`).
- [ ] Komponenten tar inn fragment-ref via prop og bruker `useFragment` for sin slice.
- [ ] Hvis fragment-data ennå ikke har lastet (data === undefined): komponenten renderer en kort, dempet placeholder (ikke krasj, ikke tom).
- [ ] Hvis returnert array er tomt (bruker uten admin-rolle): hele filter-seksjonen skjules (`return null`).
- [ ] Chip-modus (når `renderAsChip` er sann) fungerer urørt.

**Implementation Notes:**

- Følger Op #3 Lag B ordrett — fragment-definisjonen lever ved siden av filter-komponenten.
- A11y-test (Task #14) skal nå mocke fragment-ref-en i stedet for `useMineLaresteder`.

#### Task #7: Refaktorer `ApplikasjonerOrganisasjonFilter` til å konsumere `MegSomApplikasjonsadministrator.organisasjoner`

**Priority:** High
**Size:** M (3–4 h)
**Dependencies:** Task #4
**Addresses Requirements:** BRU-APP-API-001 (Tilgjengelige organisasjoner i filter)

**Acceptance Criteria:**

- [ ] `ApplikasjonerOrganisasjonFilter.tsx` har ikke `useMineLaresteder()`-konsum (linje 42 i før-versjonen).
- [ ] Komponenten definerer `APPLIKASJONER_ORGANISASJON_FILTER_FRAGMENT` (fragment på `MegSomApplikasjonsadministrator` — felt `organisasjoner { id, navn }`).
- [ ] Konsumkontrakt og chip-modus tilsvarende Task #6.
- [ ] Sorteringen følger `navn` (norsk locale) som før.
- [ ] Filter-state-shape (URL-sync via `useDataListState`) er uendret — kun option-set-kilden endres.

#### Task #8: Wire opp ny `useGetApplikasjonerFilterOptions`-hook i applikasjonsoversikten

**Priority:** High
**Size:** S (1–2 h)
**Dependencies:** Task #6, Task #7
**Addresses Requirements:** BRU-APP-API-001 (Tilgjengelige miljøer/organisasjoner i filter)

**Acceptance Criteria:**

- [ ] `src/domains/support/features/Applikasjoner/hooks/useGetApplikasjonerFilterOptions.tsx` *(ny)* eksporterer `GET_APPLIKASJONER_FILTER_OPTIONS`-query + `useGetApplikasjonerFilterOptions`-hook.
- [ ] Query komponerer både `ApplikasjonerMiljoFilterFields` og `ApplikasjonerOrganisasjonFilterFields`-fragmentene.
- [ ] `Applikasjoner.tsx` issuer den nye query-en på toppnivå og passer fragment-ref-en ned til de to filtrene.
- [ ] Apollo-cache deler ikke noe med `GET_APPLIKASJONER` (separate cache-keys; egen livssyklus).

#### Task #9: Strip `ansvarlig` fra `ApplikasjonInformation`-fragmentet og seksjons-overskrift

**Priority:** High
**Size:** S (1–2 h)
**Dependencies:** Task #1
**Addresses Requirements:** BRU-APP-API-002 (scenario `Se ansvarlig` fjernet); BRU-APP-API-005 (kapabilitet fjernet)

**Acceptance Criteria:**

- [ ] `ApplikasjonInformation.tsx`'s `ApplikasjonInformationFields`-fragment har ikke `ansvarlig`-union (linje 57-77) eller `kanAdministrereAnsvarlig`-felt (linje 88).
- [ ] `Ansvarlig`-`OutputField` (linje 233-256) er fjernet.
- [ ] Seksjons-overskrift "Miljøer og ansvarlig" er endret til "Miljøer" (via i18n-nøkkel — gjennomføres i Task #13).
- [ ] Resten av Informasjon-fanen er pixel-uendret.

#### Task #10: Forenkle `RedigerDetaljerForm` — fjern ansvarlig-leg

**Priority:** High
**Size:** M (3–4 h)
**Dependencies:** Task #1
**Addresses Requirements:** BRU-APP-API-005 (kapabilitet fjernet); BRU-APP-API-002 (redigér-detaljer-flyt)

**Acceptance Criteria:**

- [ ] `currentAnsvarlig`/`ansvarligDialogMode`/`ansvarligEndret`-state er fjernet (linje 19-22, 187-205 i før-versjonen).
- [ ] `SettAnsvarligDialog`-importen er fjernet.
- [ ] Lagre-handleren bruker 2-vei `Promise.allSettled([redigerNavn, redigerBeskrivelse])` (ikke 3-vei).
- [ ] `kanRedigereDetaljer = kanRedigereNavn || kanRedigereBeskrivelse` (uten `|| kanAdministrereAnsvarlig`).
- [ ] Hele "ansvarlig"-FieldSet-et er fjernet fra render-treet.
- [ ] Navn- og beskrivelses-redigeringen fungerer uendret.

#### Task #11: Slett `Applikasjon/components/SettAnsvarligDialog/`-mappa

**Priority:** High
**Size:** S (1–2 h)
**Dependencies:** Task #10 (siste konsument av importer derifra fjernes der)
**Addresses Requirements:** BRU-APP-API-005 (kapabilitet fjernet)

**Acceptance Criteria:**

- [ ] Mappa `src/domains/support/features/Applikasjon/components/SettAnsvarligDialog/` er slettet i sin helhet — inkludert `SettAnsvarligDialog.tsx`, `SettAnsvarligDialog.module.css`, `SettAnsvarligDialog.a11y.test.tsx`, `searchAnsvarligKandidater.ts`, `settApplikasjonAnsvarligMutation.ts`, og evt. stories.
- [ ] Ingen referanser i resten av kodebasen til de slettede modulene (grep `SettAnsvarligDialog` + `searchAnsvarligKandidater` returnerer ingen treff).

#### Task #12: Skriv om `OpprettApplikasjonDialog` til kollapset `opprettApplikasjon`-mutation

**Priority:** High
**Size:** M (3–4 h)
**Dependencies:** Task #2
**Addresses Requirements:** BRU-APP-API-009 (`opprette_applikasjon.feature` — opprettelse uten ansvarlig)

**Acceptance Criteria:**

- [ ] `OpprettApplikasjonDialog/mutation.ts` issuer `mutation OpprettApplikasjon($input: OpprettApplikasjonInput!)` (én operation, ingen V2-suffiks).
- [ ] Mutation-payload-håndtering har ikke `AnsvarligPaakrevdVedOpprettelse`-grenen.
- [ ] `OpprettApplikasjonDialog.tsx` har ikke `ansvarligId`-felt i submit-input, og dialog-UI har ingen ansvarlig-`FieldSet`.
- [ ] `AnsvarligSearch.tsx` + `AnsvarligSearch.module.css` er slettet.
- [ ] Søknads-validering: dialog avviser submit hvis `navn` mangler/tom.
- [ ] Suksess-redirect til `/tilgangsstyring/applikasjoner/${id}` fungerer.
- [ ] `NavnAlleredeIBruk` + `IdentitetsleverandorIdAlleredeIBruk`-error-håndtering forblir (vises som inline-feilmelding på relevant felt).

#### Task #13: Rewire `ApplikasjonTilganger` til å konsumere `potensielleMiljoer` + `potensielleTildelendeOrganisasjoner`

**Priority:** High
**Size:** M (3–4 h)
**Dependencies:** Task #3
**Addresses Requirements:** BRU-APP-API-003 (`vise_tilganger.feature` — filter-scope-scenariene)

**Acceptance Criteria:**

- [ ] `APPLIKASJON_TILGANGER_FRAGMENT` (linje 66-78 i før-versjonen) inkluderer `potensielleMiljoer` + `potensielleTildelendeOrganisasjoner { id, navn }`.
- [ ] `availableMiljoer` (linje 247) leses fra `applikasjon.potensielleMiljoer` — ikke `applikasjon.miljoer`.
- [ ] `availableOrganisasjoner` (linje 131-145) leses direkte fra `applikasjon.potensielleTildelendeOrganisasjoner` — `useMemo`-dedup + `useApolloClient.cache.readFragment` er fjernet.
- [ ] Lift-up-en av `useApplikasjonTilganger` til Inner-laget er reversert (ikke lenger nødvendig). Tilganger-load-en kjører kun på result-list-nivå igjen.
- [ ] Filter-sidebar og chips-row deler fortsatt samme option-set (fra fragment-feltene, ikke fra cache-dedup).

**Implementation Notes:**

- Dette fjerner et dokumentert anti-pattern (klient-side filter-option-derivering, jf. analyse `Technical Constraints → fs-admin-mønstrene`).
- Validér at tomme `potensielleMiljoer`-arrays håndteres pent (filter-seksjonen skjuler seg).

### Fase C — i18n, tester og opprydning

#### Task #14: Fjern ~25 `ansvarlig`-i18n-nøkler + juster `applikasjonerDescription`

**Priority:** Medium
**Size:** S (1–2 h)
**Dependencies:** Task #9, Task #10, Task #11, Task #12 (alle konsumenter fjernet før nøklene slettes)
**Addresses Requirements:** Cross-cutting (tekst-vasking etter krav-delta)

**Acceptance Criteria:**

- [ ] `src/common/messages/nb/support.json` har ikke nøklene listet i analysens `### Oversetting`-seksjon:
  - `OpprettApplikasjonDialog`: `ansvarligLegend`, `ansvarligSearchLabel`, `ansvarligSearchPlaceholder`, `ansvarligEmptyResults`, `ansvarligHintMinLength`, `ansvarligHintVelgOrganisasjonFørst`, `errorAnsvarligRequired`, `errorAnsvarligPaakrevdVedOpprettelse`.
  - `Applikasjon`: `miljoerOgAnsvarligSectionTitle`, `ansvarligLabel`, `ansvarligEmpty`, `ansvarligTypeFeideBruker`, `ansvarligTypeFeideGruppe`, `settAnsvarligButton`, `endreAnsvarligButton`.
  - `RedigerDetaljerForm`: `ansvarligLabel`, `ansvarligPlaceholder`, `ansvarligReadOnlyHelp`, `errorAnsvarligRequired`.
  - `SettAnsvarligDialog`: hele blokken.
- [ ] Ny nøkkel `Applikasjon.miljoerSectionTitle` (eller tilsvarende) med tekst "Miljøer" er lagt til.
- [ ] `applikasjonerDescription` (linje 468) har ikke ordet "ansvarlige".
- [ ] `npm run lint` rapporterer ikke ubrukte/unavngitte i18n-nøkler i de berørte filene.
- [ ] Storybook + jest-tester finner ingen `MISSING_MESSAGE`-warnings ved kjøring.

**Implementation Notes:**

- Tasken kjøres etter klient-koden er rensket (Tasks #9–12) for å unngå at slettede komponenter midlertidig viser `MISSING_MESSAGE`.

#### Task #15: Oppdater a11y/unit-tester for endrede komponenter og slett tester for fjernede

**Priority:** High
**Size:** M (3–4 h)
**Dependencies:** Tasks #5–13 (komponentene må være ferdig endret før testene oppdateres)
**Addresses Requirements:** Cross-cutting (CLAUDE.md krever a11y-test per komponent)

**Acceptance Criteria:**

- [ ] **Oppdaterte tester** for: `ApplikasjonerResultList.a11y.test.tsx` (5 kolonner), `ApplikasjonerMiljoFilter.a11y.test.tsx` (mocker fragment-ref, ikke `useMineLaresteder`), `ApplikasjonerOrganisasjonFilter.a11y.test.tsx` (samme), `ApplikasjonInformation.a11y.test.tsx` (ingen ansvarlig-`OutputField`), `ApplikasjonTilganger.a11y.test.tsx` (mocker `potensielle*`-felt), `OpprettApplikasjonDialog.a11y.test.tsx` (ingen ansvarlig-`FieldSet`), `RedigerDetaljerForm.a11y.test.tsx` (ingen ansvarlig-leg).
- [ ] **Slettede tester** for: `SettAnsvarligDialog.a11y.test.tsx`, `SettAnsvarligDialog.test.tsx`, `AnsvarligSearch.a11y.test.tsx` (hvis den finnes).
- [ ] `npm test` + `npm run test:a11y` går grønt.
- [ ] `npm run test:typecheck` går grønt.
- [ ] Coverage-tersklene i `jest.config.ts` (60% branches/functions/lines, 90% statements) overholdt på berørte filer.

**Implementation Notes:**

- Apollo-mocking i a11y-testene: bruk `MockedProvider` med `GET_APPLIKASJONER_FILTER_OPTIONS` mocket for filter-tester; `useGetApplikasjon` mocket med `potensielle*`-felt for Tilganger-tester.

## Risk Assessment

### Technical Risks

- **R1 — Codegen-vindu under utviklingen.** Mellom Fase A og fullført Fase B vil TypeScript-build feile. Risiko: developer commit-er midt i, eller annen utvikler på samme branch hindres.
  - **Mitigation:** Fase A landes som én commit (Tasks #1–4 sammen, eventuelt to commits hvis det blir for stort), og branchen merges først når Fase B også er ferdig. Use `npm run test:typecheck` lokalt som green-bar før push.

- **R2 — Mock-fixtures og persona-data harmonerer ikke etter rewrite.** Hvis `megSomApplikasjonsadministrator.organisasjoner` returnerer org-id-er som ikke matcher noen `applikasjon.organisasjon.id` i applikasjons-fixturen, blir org-filteret tomt eller velger ingenting når brukeren huker av en option.
  - **Mitigation:** Task #4's acceptance criterion krever overlapps-validering. Smoke-test i `npm run dev` etter Fase A: åpne `/tilgangsstyring/applikasjoner`, huk av en organisasjon, bekreft at lista filtreres riktig.

- **R3 — `useApplikasjonTilganger` lift-up-reversering kan endre Apollo-cache-oppførsel utilsiktet.** Dagens dobbel-subscription (Inner + Result List) er strengt tatt overflødig — Apollo dedupliserer wire-requesten, men begge subscriptions reagerer på cache-endringer.
  - **Mitigation:** Task #13's acceptance kriterium dekker reverseringen som en eksplisitt sub-task. Smoke-test: åpne en applikasjon-detalj-side, naviger til Tilganger-fanen, hak av et filter, bekreft at lista oppdateres uten dobbel-render eller layout-shift.

- **R4 — Producer-team velger annet navn enn `potensielleTildelendeOrganisasjoner`.** Hvis ekte API lander med f.eks. `tildelendeOrganisasjoner` (uten prefiks) eller `organisasjonerSomKanTildeleTilganger` (mer beskrivende), må klient-koden re-aliase ved switchover.
  - **Mitigation:** Open Question 2 i GraphQL-seksjonen fanger dette. Endringen er en find-and-replace + codegen-regen — lav-risiko og kan skje når fs-admin peker mot ekte producer.

### Testing Requirements

- Unit-tester for de nye reolverne i `src/mocks/handlers/applikasjoner/queries.ts` (resolvers for `megSomApplikasjonsadministrator`, `Applikasjon.potensielleMiljoer`, `Applikasjon.potensielleTildelendeOrganisasjoner`) — minst happy-path + tom-set-path.
- A11y-tester per CLAUDE.md-konvensjonen, dekket i Task #15.
- Manuell smoke-test i `npm run dev`:
  1. Logg inn som test-persona med admin-rolle, åpne `/tilgangsstyring/applikasjoner`. Bekreft at miljø-filteret kun viser persona-scoped miljøer, organisasjon-filteret viser persona-scoped organisasjoner.
  2. Åpne en applikasjon, gå til Tilganger-fanen. Bekreft at miljø-filteret viser `potensielleMiljoer` (kan være mer enn de miljøene applikasjonen *har* tilganger i), organisasjons-filteret viser `potensielleTildelendeOrganisasjoner`.
  3. Klikk "Opprett applikasjon"-knappen. Bekreft at dialogen ikke har noe ansvarlig-felt; oppretting med kun navn/identitetsleverandør/organisasjon fungerer.
  4. Åpne RedigerDetaljer på en applikasjon. Bekreft at det ikke finnes ansvarlig-felt, og at lagring av navn-/beskrivelses-endringer fungerer.

## Success Criteria

- [ ] Alle 15 Tasks' acceptance criteria oppfylt.
- [ ] `npm run lint` + `npm test` + `npm run test:a11y` + `npm run test:typecheck` + `npm run build` går grønt.
- [ ] Manuell smoke-test (Testing Requirements over) bekrefter at krav-deltaen er realisert.
- [ ] Alle krav i delta-spec-en (`spec-changes-2026-06-01-11ce66c..40f04cb.md`) er adressert; ingen "ansvarlig"-referanser igjen i berørte features (grep-verifisering).
- [ ] MR-en peker tilbake på `analysis-applikasjon-tilgangsstyring-justeringer.md` og denne plan-fila for kontekst.
- [ ] Cross-agent hand-off-issue til `backend`-agenten er åpnet (se *After plan: cross-agent hand-offs* i `bat-plan`-skillen — håndteres i en separat steg etter at planen er publisert).

## Requirements Traceability

| Krav-ID                                                | Krav-sammendrag                                                  | Adresseres av Task(s)             | Status  |
| ------------------------------------------------------ | ---------------------------------------------------------------- | --------------------------------- | ------- |
| BRU-APP-API-001 (kolonne `Ansvarlig` fjernet)          | Listevisning skal ikke vise ansvarlig-kolonne                   | Task #5                           | Planned |
| BRU-APP-API-001 (Tilgjengelige miljøer i filter)       | Persona-scoped miljø-filter på listevisning                      | Tasks #4, #6, #8                  | Planned |
| BRU-APP-API-001 (Tilgjengelige organisasjoner i filter)| Persona-scoped organisasjons-filter på listevisning              | Tasks #4, #7, #8                  | Planned |
| BRU-APP-API-001 (Synlighet via ansvarlig-relasjon fjernet)| Regel fjernet — fixtures slipper persona-ansvarlig-flagget    | Task #1                           | Planned |
| BRU-APP-API-002 (`Se ansvarlig`-scenario fjernet)      | Detalj-side viser ikke ansvarlig-felt                            | Task #9                           | Planned |
| BRU-APP-API-003 (Tilgjengelige miljøer/organisasjoner i filter — tilganger-fane)| Potential-scope-filter via fragment-felter | Tasks #3, #13                     | Planned |
| BRU-APP-API-005 (Administrere ansvarlig — kapabilitet fjernet)| Hele K18-kapabiliteten borte                              | Tasks #1, #9, #10, #11            | Planned |
| BRU-APP-API-009 (Opprette applikasjon uten ansvarlig)  | Mutation kollapset; dialog uten ansvarlig-felt                   | Tasks #2, #12                     | Planned |
| Krav-eier inkonsistens (vise_tilganger.feature Q4)     | "Potential scope"-lesning antas autoritativ                      | Tasks #3, #13 (rammet av valget)  | Planned |
| Cross-cutting — i18n + tester                          | i18n-nøkler ryddet, a11y-tester oppdatert                        | Tasks #14, #15                    | Planned |
