# Plan: Applikasjoner-visning delta (filterkilder + synlighet for tilganger)

Plan for delta-iterasjonen som presiserer hvor filterkildene i applikasjoner-listevisningen og tilganger-tab-en kommer fra, og som innfører den nye `Regel: Synlighet for tilganger`. Bygger på [`spec-changes-2026-06-16-b0e8de5.md`](spec-changes-2026-06-16-b0e8de5.md) og [`analysis-applikasjoner-visning-delta.md`](analysis-applikasjoner-visning-delta.md). Greenfield-rammeverket (Task #1–#16 i [`docs/specs/31-grunnleggende-selvbetjent-tilgangsstyring/plan-applikasjoner.md`](https://github.com/sikt-no/fs-admin) i fs-admin-repoet) er på plass og uberørt av denne iterasjonen.

## Proposed Solution

### Architecture Approach

Endringen er **datakildebytte**, ikke layout-arbeid. De fire `Select`-komponentene (to på listevisning, to på tilganger-tab) beholder shape, label-tekst, `"Alle X"`-defaults og chip-rendering — bare hvor `options`-arrayet kommer fra endres. Tre nye datakilder introduseres:

1. **Listevisning** (rolle-utledet): to nye TRANSITIONAL-hooks `useGetMineSynligeOrganisasjoner` og `useGetMineSynligeMiljoer` parallelt med eksisterende `useGetMineApplikasjonsAdminOrganisasjoner`. Den eksisterende hooken beholdes uendret som kilde for `Opprett applikasjon`-gating på fire kall-steder (analyse-beslutning #3).
2. **Tilganger-tab** (innhold-utledet): nye server-felter `Applikasjon.tilgangerMiljoer` og `Applikasjon.tilgangerOrganisasjoner` derives på serveren fra det samme rolle-filtrerte tilgangs-settet som connection-queryen allerede returnerer. Frontend prop-driller listene fra tab-container ned til `ApplikasjonTilgangerFilter` og videre til miljø-/organisasjon-filter-komponentene.
3. **`Regel: Synlighet for tilganger`** (autorisasjons-grense): server-side WHERE-clause på `Applikasjon.tilganger`-resolveren — eier-admin ser alt, kryss-org-admin ser kun tilganger inn i egne data. Ingen schema-endring, ingen frontend-UI-endring (avklart "ingen markering" i spec).

Hele kjeden er TRANSITIONAL: ingen ny code-path migreres til fragment-colocation / codegen-typer i denne iterasjonen — refactor til kolokerte fragmenter skjer som én batch når producer-schemaet for applikasjon-tilgangsstyring lander (jf. eksisterende TRANSITIONAL-kommentar-blokker i feature-folderen).

### Key Technical Decisions

1. **Decision: To separate queries `mineSynligeOrganisasjoner` + `mineSynligeMiljoer` for listevisning, behold `mineApplikasjonsAdminOrganisasjoner` uendret.**
   - Why: De to bruksområdene er semantisk forskjellige — `mineApplikasjonsAdminOrganisasjoner` representerer *redigeringsrett* (Opprett-knapp-gating), `mineSynligeOrganisasjoner` representerer *innsynsscope* (filter-kilde). Sammenslåing ville koblet to uavhengige forretningsregler i samme felt og ført til drift når én av reglene endres.
   - Alternative considered: Utvide eksisterende query til union (a)+(b) — forkastet (analyse § Open Question #1).
2. **Decision: Server-side felter `Applikasjon.tilgangerMiljoer` / `tilgangerOrganisasjoner` for tilganger-tab-filter, ikke client-side derivasjon.**
   - Why: Client-side derivasjon fra `tilganger.nodes` ville stille-skjult organisasjoner/miljøer som ligger lenger ned i paginert connection (default `first: 50`). Silent failure er verre enn én ekstra felt-evaluering på serveren — særlig når serveren allerede har det rolle-filtrerte settet i hånda fra connection-queryens WHERE-clause.
   - Alternative considered: Client-side derivasjon, separat `Query.applikasjonTilgangerOrganisasjoner(id: ID!)` — begge forkastet (analyse § Open Question #2).
3. **Decision: Rolle-filter på `Applikasjon.tilganger` implementeres som autorisasjons-grense i resolveren, ikke som valgfri filter-input.**
   - Why: Filteret er en `forbidden-by-policy`-grense, ikke en `narrowed-by-preference`-grense. En `null`/`false`-verdi ville implisitt be om data brukeren ikke har rett til.
   - Alternative considered: `ApplikasjonTilgangerFilter.onlyMyOrgs: Boolean` — forkastet (misforstår autorisasjon som brukervalg).
4. **Decision: Ingen ny Apollo-cache-invalidering ved rolle/persona-bytte.**
   - Why: `usePersonaOverride.applyPersonaChange` (`src/common/lib/persona/hooks/usePersonaOverride.ts:32-53`) wiper allerede hele cachen og re-fetcher alle aktive queries atomisk via `apolloClient.refetchQueries({ include: 'active', updateCache: cache.reset })`. Dekker både `mineSynlige*`-hookene og `Applikasjon.tilganger*`-feltene som alt annet.
   - Alternative considered: `cache.evict` på `Applikasjon:id.tilganger` — forkastet (analyse § Open Question #4).
5. **Decision: Implementer rolle-filter i mock-API (`src/mocks/applikasjoner/`) parallelt med schema-skissen.**
   - Why: ~15 linjer kode + 1 test gjør `Regel: Synlighet for tilganger` testbart end-to-end uten producer-rundtur. Konsistent med hvordan `SYNLIGE_APPLIKASJONER` (`fixtures/applikasjoner.ts:572`) allerede modellerer synlighet på listevisnings-nivå.
   - Alternative considered: La mock-en være "ufiltrert" og vente på ekte backend — forkastet (analyse § Open Question #5).
6. **Decision: Beholde TRANSITIONAL flat-`gql`-mønster i feature-folderen for denne iterasjonen.**
   - Why: Hele feature-folderen for applikasjon-tilgangsstyring er i en TRANSITIONAL-fase mens producer-schemaet ikke er merget — flat `gql` fra `@apollo/client` + manuelle typer + `'!src/mocks/**/*'`-codegen-exclusion. Å introdusere fragment-colocation for to nye hooks midt i en TRANSITIONAL-batch ville gi inkonsistente call-sites og forsinke den endelige codegen-migrasjonen. Refactor gjøres som én samlet batch når producer-schemaet lander (jf. eksisterende TRANSITIONAL-kommentar-blokker i `useGetMineApplikasjonsAdminOrganisasjoner.tsx:1-12` og `useGetApplikasjonTilganger.tsx:1-10`).
   - Alternative considered: Etablere fragment-colocation for de nye hookene nå — forkastet (avviksbegrunnelse i hver Lag C av `## GraphQL-endringer` nedenfor).

### File Changes Overview

**Endrede filer (8):**

- `src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/filter/ApplikasjonerMiljoFilter/ApplikasjonerMiljoFilter.tsx` — bytt hardkodet `[demo, prod]`-konstant mot `useGetMineSynligeMiljoer`. Legg til `disabled` per fs-admin-inputs §10. Oppdater TRANSITIONAL-kommentar.
- `src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/filter/ApplikasjonerOrganisasjonFilter/ApplikasjonerOrganisasjonFilter.tsx` — bytt import fra `useGetMineApplikasjonsAdminOrganisasjoner` til `useGetMineSynligeOrganisasjoner`. Oppdater kommentar (fjern "intentionally does not show every org…"-tekst).
- `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/components/ApplikasjonTilgangerFilter/filter/ApplikasjonTilgangerMiljoFilter/ApplikasjonTilgangerMiljoFilter.tsx` — bytt hardkodet liste mot `miljoer` + `loading` props. Oppdater kommentar.
- `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/components/ApplikasjonTilgangerFilter/filter/ApplikasjonTilgangerOrganisasjonFilter/ApplikasjonTilgangerOrganisasjonFilter.tsx` — fjern import av `useGetMineApplikasjonsAdminOrganisasjoner`. Bytt til `organisasjoner` + `loading` props. Oppdater kommentar.
- `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/components/ApplikasjonTilgangerFilter/ApplikasjonTilgangerFilter.tsx` — ta inn `miljoer`/`organisasjoner`/`loading` som props fra parent og prop-drill til de to filter-barna.
- `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/ApplikasjonTilganger.tsx` — hent nye filter-options via ny hook (eller via utvidet detail-query — se Task #4 for valg) og prop-drill til `ApplikasjonTilgangerFilter`.
- `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/hooks/useGetApplikasjonTilgangerTypes.ts` — legg til `tilgangerMiljoer`/`tilgangerOrganisasjoner` på `ApplikasjonTilgangerOwner` (manuelle typer).
- `src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetMineApplikasjonsAdminOrganisasjoner.tsx` — oppdater dokumentasjons-kommentar (forklar at hooken nå *kun* brukes til redigeringsrett-gating, ikke filter-kilde; nevne søsken-hookene `useGetMineSynlige*`).

**Nye filer (4 + tester):**

- `src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetMineSynligeOrganisasjoner.tsx` — ny TRANSITIONAL hook (speil av `useGetMineApplikasjonsAdminOrganisasjoner`-mønster).
- `src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetMineSynligeMiljoer.tsx` — ny TRANSITIONAL hook for miljø-liste.
- *Hvis Task #4 velger separat hook-mønster:* `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/hooks/useGetApplikasjonTilgangerFilterOptions.tsx` — lett vekt-hook for å hente bare `tilgangerMiljoer` + `tilgangerOrganisasjoner` per applikasjon. Alternativ: utvid `useGetApplikasjonTilganger` selection-set; ingen ny hook-fil. Task #4 avgjør.
- A11y-tester for alle nye/endrede komponenter — minst én test må re-valideres når kilden byttes (eksisterende `*.a11y.test.tsx` for hver av de fire filter-komponentene fanger ikke nødvendigvis loading-tilstand fra ny hook).

**Endrede filer i mock-API (4):**

- `src/mocks/applikasjoner/types.ts` — legg til `tilgangerMiljoer: Miljo[]` og `tilgangerOrganisasjoner: Organisasjon[]` på `Applikasjon`-typen.
- `src/mocks/applikasjoner/handlers/queries.ts` — legg til `mineSynligeOrganisasjoner`- og `mineSynligeMiljoer`-handlers. Utvid `buildApplikasjonMedTilgangerResponse` med rolle-filter og populer de to nye feltene fra rolle-filtrert sett.
- `src/mocks/applikasjoner/fixtures/organisasjoner.ts` — legg til derived `MINE_SYNLIGE_ORGANISASJONER` (union av `MINE_ADMIN_ORGANISASJONER` + organisasjoner som eier applikasjoner med tilganger inn i admin-egne data).
- `src/mocks/applikasjoner/fixtures/miljoer.ts` — legg til derived `MINE_SYNLIGE_MILJOER` (union av miljøer i synlige applikasjoners `miljoer`-felt og miljøer i deres tilganger).

**Translation-filer:**

- `src/common/messages/nb/domains.json` § `ApplikasjonerFilter` og § `ApplikasjonTilgangerFilter` — `miljoDemo`/`miljoProd`-keys kan beholdes (defensiv) eller fjernes (de er ikke lenger statisk referert etter Task #3/#4); behold for nå siden mock-`Miljo.navn` allerede gir "Demo"/"Prod" direkte fra server-svaret.

## GraphQL-endringer

> **Premiss:** konservativ — minst mulig schema-endring som lukker gap-listen i analysen. Eksisterende `mineApplikasjonsAdminOrganisasjoner`-query og `applikasjon(id) { tilganger(...) }`-connection beholdes uendret i form.
> **Domeneterm:** `Applikasjon` (besluttet ved greenfield-iterasjonen, jf. `docs/specs/31-grunnleggende-selvbetjent-tilgangsstyring`).
> **Følger fra:** [`analysis-applikasjoner-visning-delta.md`](analysis-applikasjoner-visning-delta.md) — gap-listen i Key Findings (4 filterkilder + 1 rolle-filter) og Dependencies → Cross-contributor (fs-plattform producer).

### Sammendrag

- 2 nye Query-felter (`mineSynligeOrganisasjoner`, `mineSynligeMiljoer`)
- 2 nye Applikasjon-felter (`tilgangerOrganisasjoner`, `tilgangerMiljoer`)
- 0 nye mutations
- 1 autorisasjons-grense på eksisterende `Applikasjon.tilganger` (ikke en schema-endring, men en kontrakt-endring som må implementeres i resolveren)
- 0 åpne spørsmål — alle 5 spørsmål i analysens walkthrough er avklart

### Operasjoner

#### Op #1: `mineSynligeOrganisasjoner` — listevisnings-filter-kilde for organisasjon

**Dekker krav:** `Tilgjengelige organisasjoner i filter` (listevisning) — `listevisning_og_sok.feature`, endret-bullet i [`spec-changes-2026-06-16-b0e8de5.md`](spec-changes-2026-06-16-b0e8de5.md) § Endret.
**Implementeres av:** Task #1 (mock-handler) + Task #2 (hook) + Task #3 (call-site).

##### Lag A — Schema-tillegg

```graphql
# Nytt Query-felt. Returnerer unionen av (a) organisasjoner admin har applikasjons-
# administrator-rollen for, og (b) organisasjoner som eier applikasjoner med tilganger
# inn i data admin administrerer. Hver organisasjon listes én gang, alfabetisk etter navn.
extend type Query {
  """
  Organisasjoner brukeren har innsynsscope på i applikasjoner-listen. Settet er rolle-
  utledet fra påloggede admin-roller og er ment som kilde for filter-dropdowns i
  applikasjoner-oversikten. Ikke det samme som `mineApplikasjonsAdminOrganisasjoner`,
  som beskriver hvilke organisasjoner brukeren kan opprette / redigere applikasjoner i.
  """
  mineSynligeOrganisasjoner: [Organisasjon!]!
}
```

##### Lag B — fs-admin call-site

```ts
// src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetMineSynligeOrganisasjoner.tsx
// TRANSITIONAL: speiler eksisterende `useGetMineApplikasjonsAdminOrganisasjoner`-mønster
// inntil producer-schemaet lander og codegen overtar (se § Migration i den hooken).
import { gql, type TypedDocumentNode } from '@apollo/client'
import { useQuery } from '@apollo/client/react'

export interface MineSynligOrganisasjon {
  __typename: 'Organisasjon'
  id: string
  navn: string
}

interface MineSynligeOrganisasjonerData {
  mineSynligeOrganisasjoner: MineSynligOrganisasjon[]
}

export const GET_MINE_SYNLIGE_ORGANISASJONER = gql`
  query mineSynligeOrganisasjoner {
    mineSynligeOrganisasjoner {
      id
      navn
    }
  }
` as TypedDocumentNode<MineSynligeOrganisasjonerData, Record<string, never>>

export function useGetMineSynligeOrganisasjoner() {
  const { data, loading, error } = useQuery(GET_MINE_SYNLIGE_ORGANISASJONER, {
    fetchPolicy: 'cache-first',
  })
  return {
    organisasjoner: data?.mineSynligeOrganisasjoner ?? [],
    loading,
    error,
  }
}
```

```ts
// src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/filter/ApplikasjonerOrganisasjonFilter/ApplikasjonerOrganisasjonFilter.tsx
// Bytter kilde fra useGetMineApplikasjonsAdminOrganisasjoner til useGetMineSynligeOrganisasjoner.
// Admin-hooken beholdes uendret for Opprett-knapp-gating (analyse-beslutning #3).
const { organisasjoner, loading } = useGetMineSynligeOrganisasjoner()
```

##### Lag C — Begrunnelse

- **Dekker krav:** `Tilgjengelige organisasjoner i filter` (listevisning) — punkt 2 i delta-spec § Endret.
- **Form:** Eget semantisk Query-felt (ikke filter-input på `mineApplikasjonsAdminOrganisasjoner`) per `fs-sikt-no-producer-schema-design §"Vi innfører gjerne egne felt og typer for semantisk nyttige data-uttrekk"`. Sammenslåing ville koblet `redigeringsrett` (Opprett-gating) og `innsynsscope` (filter) til samme felt — to uavhengige forretningsregler vil drifte fra hverandre på sikt. Speiler `mineSoknader`-eksempelet i producer-doc-en.
- **Colocation-status:** Ikke best practice — speiler eksisterende ikke-kolokert mønster i `src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/`. Feature-folderen er i en TRANSITIONAL-fase mens producer-schemaet for applikasjon-tilgangsstyring ikke er merget; alle hooks i området bruker flat `gql` fra `@apollo/client` + manuelle typer (se kommentar-block i `useGetMineApplikasjonsAdminOrganisasjoner.tsx:1-12`). Refactor til fragment-colocation + codegen-typer skjer som én batch når schemaet lander.
- **Konvensjoner sitert:**
  - Norsk feltnavn, lowerCamelCase, ingen forkortelser per `fs-sikt-no-producer-naming §"Bruk norsk for domenebegreper"` + `§"Bruk lowerCamelCase"`.
  - Ingen Cursor-paginering: listen er bounded-by-admin-role (typisk 5–50 entries) og brukes til å fylle en `Select`-dropdown der hele settet trengs samtidig. Per `fs-sikt-no-producer-best-practice §Paginering` ("Man kan fravike bruk av paginering i tilfeller der man har svært god kontroll på at antallet elementer som kan returneres er lavt"). Speiler eksisterende `mineApplikasjonsAdminOrganisasjoner`-mønster i samme schema-område.
  - Non-null liste + non-null elementer (`[Organisasjon!]!`): speiler eksisterende producer-kontrakt for `mineApplikasjonsAdminOrganisasjoner` (jf. mock-handler-returverdi `Organisasjon[]`). Tom liste → `[]`, aldri `null`.
- **Alternativer vurdert:**
  - Utvide `mineApplikasjonsAdminOrganisasjoner` til å returnere union (a)+(b) — forkastet: bryter den semantiske kontrakten "administrerbare organisasjoner" som fortsatt brukes til Opprett-gating på fire kall-steder (analyse-beslutning #3).
  - Filter-input på eksisterende query (`mineApplikasjonsAdminOrganisasjoner(scope: SYNLIG | ADMINISTRERBAR)`) — forkastet: dropper type-sikkerhet på returverdien og koder forretningsregelen i et argument i stedet for i selve navnet.

#### Op #2: `mineSynligeMiljoer` — listevisnings-filter-kilde for miljø

**Dekker krav:** `Tilgjengelige miljøer i filter` (listevisning) — `listevisning_og_sok.feature`, endret-bullet i delta-spec § Endret.
**Implementeres av:** Task #1 (mock-handler) + Task #2 (hook) + Task #3 (call-site).

##### Lag A — Schema-tillegg

```graphql
extend type Query {
  """
  Miljøer brukeren har innsynsscope på i applikasjoner-listen. Settet er unionen av
  (a) miljøer der applikasjoner i administrerte organisasjoner kan tilordnes tilganger,
  og (b) miljøer der andre organisasjoner sine applikasjoner har tilganger inn i data
  admin administrerer. Hvert miljø listes én gang, alfabetisk etter `navn`.
  """
  mineSynligeMiljoer: [Miljo!]!
}
```

##### Lag B — fs-admin call-site

```ts
// src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetMineSynligeMiljoer.tsx
// TRANSITIONAL: samme TRANSITIONAL-mønster som useGetMineSynligeOrganisasjoner.
import { gql, type TypedDocumentNode } from '@apollo/client'
import { useQuery } from '@apollo/client/react'

export interface MineSynligMiljo {
  __typename: 'Miljo'
  kode: string
  navn: string
}

interface MineSynligeMiljoerData {
  mineSynligeMiljoer: MineSynligMiljo[]
}

export const GET_MINE_SYNLIGE_MILJOER = gql`
  query mineSynligeMiljoer {
    mineSynligeMiljoer {
      kode
      navn
    }
  }
` as TypedDocumentNode<MineSynligeMiljoerData, Record<string, never>>

export function useGetMineSynligeMiljoer() {
  const { data, loading, error } = useQuery(GET_MINE_SYNLIGE_MILJOER, {
    fetchPolicy: 'cache-first',
  })
  return {
    miljoer: data?.mineSynligeMiljoer ?? [],
    loading,
    error,
  }
}
```

```ts
// src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/filter/ApplikasjonerMiljoFilter/ApplikasjonerMiljoFilter.tsx
// Erstatter hardkodet [demo, prod]-konstant med hentet liste.
const { miljoer, loading } = useGetMineSynligeMiljoer()
const options = miljoer.map((m) => ({ value: m.kode, label: m.navn }))
// disabled={loading || options.length === 0} på Select, per fs-admin-inputs §10
```

##### Lag C — Begrunnelse

- **Dekker krav:** `Tilgjengelige miljøer i filter` (listevisning) — punkt 1 i delta-spec § Endret.
- **Form:** Egen `Query.mineSynligeMiljoer`-felt parallelt med `mineSynligeOrganisasjoner` — samme semantiske mønster (rolle-utledet innsynsscope) og samme producer-guidance per `fs-sikt-no-producer-schema-design §"Vi innfører gjerne egne felt og typer"`. Returnerer hele `Miljo`-typen (`kode` + `navn`) slik at frontend kan vise menneskelig navn i dropdown og bruke `kode` som filter-verdi mot `ApplikasjonerFilter.miljoKode`.
- **Colocation-status:** Ikke best practice — speiler eksisterende ikke-kolokert mønster i samme TRANSITIONAL feature-folder (se Op #1 Lag C).
- **Konvensjoner sitert:**
  - Norsk feltnavn, lowerCamelCase per `fs-sikt-no-producer-naming`. "Miljoer" (uten Æ) per `fs-sikt-no-producer-naming §"ÆØÅ oversettes til AOA"`.
  - Ingen paginering: miljø-listen er domene-bounded (typisk ≤ 5 — i dag `demo`, `prod`, mulig `test`/`utvikling` i fremtiden) per `fs-sikt-no-producer-best-practice §Paginering`-unntaket.
  - Non-null liste + non-null elementer (`[Miljo!]!`): tom liste betyr "admin har ingen miljø-innsyn" og skal kunne uttrykkes som `[]`, ikke `null`. Konsumenten disabler `Select` når listen er tom (`fs-admin-inputs §10`).
- **Alternativer vurdert:**
  - Returnere `[String!]!` (bare kode) — forkastet: tvinger frontend til å oversette `kode` → `navn` med egen i18n-fil; redundant med eksisterende `Miljo`-typen.
  - Eksponere som `Me.synligeMiljoer` — forkastet for nå: vi har ikke en `Me`-type i schemaet i dag, og introduksjon av en hører hjemme i et bredere "meg som ..."-arbeid (jf. `MegSomSoker`-eksempelet i producer-doc-en), ikke i denne delta-en.

#### Op #3: `Applikasjon.tilgangerOrganisasjoner` — content-derived filter-kilde for tilganger-tab

**Dekker krav:** `Tilgjengelige organisasjoner i filter` (tilganger-tab) — `vise_tilganger.feature`, endret-bullet i delta-spec § Endret.
**Implementeres av:** Task #1 (mock-felt + handler-derivasjon) + Task #4 (query-utvidelse + call-site).

##### Lag A — Schema-tillegg

```graphql
# Nye felter på eksisterende Applikasjon-type. Begge derives på server-siden fra
# det SAMME rolle-filtrerte tilgangs-sett som Applikasjon.tilganger-connection
# allerede returnerer — samme autorisasjons-WHERE-clause i resolveren.
extend type Applikasjon {
  """
  Distinkte organisasjoner representert i den (rolle-filtrerte) tilgangslisten for
  denne applikasjonen. Alfabetisk sortert etter `navn`. Ment som kilde for filter-
  dropdown på tilganger-fanen. Bruker samme rolle-filter som
  `Applikasjon.tilganger`-feltet — eier-admin ser alle, kryss-org-admin ser kun
  organisasjoner hvis tilgang gir innsyn i egne data.
  """
  tilgangerOrganisasjoner: [Organisasjon!]!
}
```

##### Lag B — fs-admin call-site

```ts
// src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/hooks/useGetApplikasjonTilgangerTypes.ts
// Utvider eksisterende ApplikasjonTilgangerOwner-type (manuell mirror).
export interface ApplikasjonTilgangerOwner {
  __typename: 'Applikasjon'
  id: string
  tilganger: ApplikasjonTilgangerConnection
  tilgangerMiljoer: ApplikasjonTilgangerListMiljo[]              // ny, jf. Op #4
  tilgangerOrganisasjoner: ApplikasjonTilgangerListOrganisasjon[] // ny
}
```

```ts
// src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/hooks/useGetApplikasjonTilganger.tsx
// Utvider EKSISTERENDE applikasjonMedTilganger-query med de to nye Applikasjon-feltene
// (ingen ny round-trip — samme operasjon henter filter-kildene sammen med listen).
export const GET_APPLIKASJON_TILGANGER = gql`
  query applikasjonMedTilganger(
    $id: ID!
    $first: Int
    $after: String
    $filter: ApplikasjonTilgangerFilter
    $orderBy: ApplikasjonTilgangerOrderBy
  ) {
    applikasjon(id: $id) {
      id
      # Nye filter-kilder. Server-side rolle-filtrert (samme WHERE som `tilganger`).
      tilgangerOrganisasjoner {
        id
        navn
      }
      tilgangerMiljoer {
        kode
        navn
      }
      tilganger(first: $first, after: $after, filter: $filter, orderBy: $orderBy) {
        # ... uendret fra Task #10 i greenfield-planen
      }
    }
  }
` as TypedDocumentNode<ApplikasjonTilgangerQueryData, ApplikasjonTilgangerQueryVariables>
```

```ts
// src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/components/ApplikasjonTilgangerFilter/filter/ApplikasjonTilgangerOrganisasjonFilter/ApplikasjonTilgangerOrganisasjonFilter.tsx
// Bytter kilde fra useGetMineApplikasjonsAdminOrganisasjoner (admin-hook,
// feil semantikk) til props som leveres ned fra ApplikasjonTilganger-laget,
// hvor det rolle-filtrerte settet allerede er tilgjengelig i query-svaret.
interface ApplikasjonTilgangerOrganisasjonFilterProps {
  value: string
  onChange: (value: string) => void
  renderAsChip?: boolean
  organisasjoner: ApplikasjonTilgangerListOrganisasjon[] // ny prop
  loading: boolean                                        // ny prop
}
```

##### Lag C — Begrunnelse

- **Dekker krav:** `Tilgjengelige organisasjoner i filter` (tilganger-tab) — punkt 5 i delta-spec § Endret.
- **Form:** Server-side felt på `Applikasjon`-typen (ikke client-side derivasjon fra `tilganger.nodes`) per analyse-beslutning #2: client-side derivasjon ville stille-skjult organisasjoner som ligger lenger ned i den paginerte connection (default `first: 50`, en applikasjon med >50 tilganger kan spenne flere organisasjoner enn de første 50 viser) — silent failure, ikke synlig feil. Server-side delt med samme rolle-filter/WHERE som connection gjør autorisasjonsgrensen konsistent. Per `fs-sikt-no-producer-schema-design §"Vi innfører gjerne egne felt og typer"` — semantisk felt på domenetypen for et konkret bruksbehov (filter-kilde).
- **Colocation-status:** Ikke best practice — feltene legges på EKSISTERENDE `applikasjonMedTilganger`-query som ikke kolokerer. Speiler eksisterende TRANSITIONAL-mønster i `useGetApplikasjonTilganger.tsx`. Bruker prop-drilling fra `ApplikasjonTilganger.tsx` ned til filter-komponentene som midlertidig erstatning for `useFragment`-mønsteret — fragment-refactor utsettes til codegen-batchen.
- **Konvensjoner sitert:**
  - Felt på eksisterende type, ikke ny query. Ingen ekstra round-trip per `fs-sikt-no-producer-schema-design §"Vi innfører gjerne egne felt og typer"` (semantisk felt for konkret bruksbehov).
  - Norsk feltnavn `tilgangerOrganisasjoner` (naturlig ordrekkefølge, eier-kategori først) per `fs-sikt-no-producer-naming §"Bruk naturlig ordrekkefølge"`.
  - Non-null liste, non-null elementer per samme regel som Op #1.
  - Ingen paginering: lista er content-bounded av tilgangs-listen for én enkelt applikasjon (typisk ≤ 10 distinkte organisasjoner per applikasjon). `fs-sikt-no-producer-best-practice §Paginering`-unntaket.
- **Alternativer vurdert:**
  - Client-side derivasjon fra `tilganger.nodes`-svaret — forkastet (analyse-beslutning #2, silent-failure-risiko ved paginert connection).
  - Egen `Query.applikasjonTilgangerOrganisasjoner(id: ID!)`-query — forkastet: krever ekstra round-trip og dupliserer autorisasjons-checken i to resolvere.
  - `Connection`-typert returverdi — forkastet per paginerings-unntaket over.

#### Op #4: `Applikasjon.tilgangerMiljoer` — content-derived filter-kilde for tilganger-tab

**Dekker krav:** `Tilgjengelige miljøer i filter` (tilganger-tab) — `vise_tilganger.feature`, endret-bullet i delta-spec § Endret.
**Implementeres av:** Task #1 (mock) + Task #4 (call-site).

##### Lag A — Schema-tillegg

```graphql
extend type Applikasjon {
  """
  Distinkte miljøer representert i den (rolle-filtrerte) tilgangslisten for denne
  applikasjonen. Alfabetisk sortert etter `navn`. Samme rolle-filter som
  `Applikasjon.tilganger` og `Applikasjon.tilgangerOrganisasjoner`.
  """
  tilgangerMiljoer: [Miljo!]!
}
```

##### Lag B — fs-admin call-site

Felt-tillegg gjenbruker `GET_APPLIKASJON_TILGANGER`-operasjonen vist i Op #3 — `tilgangerMiljoer { kode, navn }` legges til i samme selection-set. `ApplikasjonTilgangerMiljoFilter` får `miljoer`- og `loading`-props på samme måte som `ApplikasjonTilgangerOrganisasjonFilter`:

```ts
interface ApplikasjonTilgangerMiljoFilterProps {
  value: string
  onChange: (value: string) => void
  renderAsChip?: boolean
  miljoer: ApplikasjonTilgangerListMiljo[]
  loading: boolean
}
```

##### Lag C — Begrunnelse

- **Dekker krav:** `Tilgjengelige miljøer i filter` (tilganger-tab) — punkt 4 i delta-spec § Endret.
- **Form:** Samme begrunnelse som Op #3 — server-side felt på `Applikasjon`-typen, samme query-roundtrip, samme rolle-filter. Erstatter den hardkodede `[demo, prod]`-konstanten i `ApplikasjonTilgangerMiljoFilter`.
- **Colocation-status:** Ikke best practice — samme grunn som Op #3.
- **Konvensjoner sitert:** Identisk med Op #3 (felt-pair på `Applikasjon`).
- **Alternativer vurdert:** Samme som Op #3 (client-side derivasjon, egen query, Connection-form — alle forkastet av samme grunner).

#### Op #5: Autorisasjons-grense på `Applikasjon.tilganger`

**Dekker krav:** `Regel: Synlighet for tilganger` (begge scenarier) og presisert formulering i `Se tilganger for en applikasjon` — `vise_tilganger.feature`, ny `Regel`-block + formulerings-endring i delta-spec § Endret.
**Implementeres av:** Task #1 (mock-side rolle-filter i `buildApplikasjonMedTilgangerResponse`). Producer-side: cross-contributor → fs-plattform.

##### Lag A — Schema-tillegg

Ingen tillegg i SDL — kontrakten er en endring i resolverens autorisasjons-WHERE-clause for det eksisterende `Applikasjon.tilganger`-feltet:

```graphql
# Ingen SDL-endring. Dokumentert som autorisasjons-regel i field-resolveren:
#
#   Applikasjon.tilganger:
#     - Hvis innlogget bruker har applikasjons-admin-rolle for applikasjonens
#       eier-organisasjon → returner alle tilganger (uendret).
#     - Ellers → returner kun tilganger hvor `tilgang.organisasjon.id` er i settet av
#       organisasjoner brukeren har applikasjons-admin-rolle for ("kryss-org-admin").
#     - Filter/orderBy/pagination-parametrene er uendret; filteret er en autorisasjons-
#       grense, ikke et brukervalg.
#
# Konsekvens for `totalCount` / `pageInfo` / `nodes`: alle reflekterer det rolle-
# filtrerte settet (totalCount er count etter rolle-filter + frivillig brukerfilter).
```

##### Lag B — fs-admin call-site

Ingen call-site-endring i fs-admin. `GET_APPLIKASJON_TILGANGER`-operasjonens signatur (variabler, returnerte felter) er uendret; bare hva resolveren INKLUDERER i resultatet endres.

Persona-bytte i fs-admin (`usePersonaOverride.applyPersonaChange`, `src/common/lib/persona/hooks/usePersonaOverride.ts:32-53`) wiper Apollo-cachen og re-fetcher alle aktive queries — så cache-konsistens på tvers av rolle-skifte er allerede dekket (analyse-beslutning #4).

##### Lag C — Begrunnelse

- **Dekker krav:** `Regel: Synlighet for tilganger` + presisert formulering "liste over tilganger" (i stedet for "alle tilganger") i `Se tilganger for en applikasjon`-scenariet. Begge i `vise_tilganger.feature`.
- **Form:** Autorisasjons-grense i resolveren — IKKE en valgfri filter-input. Brukervalg-filtre tillater "alt"-verdier (`null`); autorisasjons-grenser gjør det ikke. Skillet er semantisk viktig — det er en `forbidden-by-policy`-grense, ikke en `narrowed-by-preference`-grense. Per `fs-sikt-no-producer-schema-design §"Vi innfører gjerne egne felt og typer"` — autorisasjon hører hjemme i resolveren, ikke i schemaet.
- **Colocation-status:** Ikke relevant — ingen ny call-site.
- **Konvensjoner sitert:**
  - Ingen `@directive` for rolle-sjekk i SDL: resolver-nivå autorisasjon speiler eksisterende mønster for `applikasjoner`-listen, hvor `SYNLIGE_APPLIKASJONER`-grensen er resolver-implementert (jf. mock-implementasjon `fixtures/applikasjoner.ts:572` + handler `queries.ts:197-211`).
  - Frontend mottar ingen rolle-context-signal og må ikke vise UI-signal (spec § Åpne spørsmål, avklart "ingen markering"). `totalCount` reflekterer det rolle-filtrerte settet, ikke det ufiltrerte — så "Last inn flere"-paginering, antall-visning og lignende konsumenter ser konsistente tall.
- **Alternativer vurdert:**
  - Valgfri filter-input på `ApplikasjonTilgangerFilter` (`onlyMyOrgs: Boolean`) — forkastet: misforstår autorisasjon som brukervalg. En `false`-verdi ville implisitt be om data brukeren ikke har rett til.
  - Separat query (`applikasjonTilgangerInnsyn`) ved siden av eksisterende — forkastet: krever frontend å vite hvilken man skal kalle, dupliserer paginerings-logikken.
  - UI-signal i fs-admin ("Filtrert pga. din rolle") — forkastet for nå (spec-beslutning). Kan legges til senere uten schema-endring.

### Tverrgående schema-bekymringer

#### Autorisasjons-modell

Alle fem operasjonene leser settet av "organisasjoner brukeren har applikasjons-administrator-rolle for" fra session/JWT-context. Resolverne kombinerer dette settet med eier-organisasjonen til hver applikasjon for å avgjøre synlighets-rules:

- `mineSynligeOrganisasjoner` / `mineSynligeMiljoer`: returnerer kun ressurser i unionen (a)+(b) — i.e. settet av admin-roller + transitivt via tilganger-relasjonen.
- `Applikasjon.tilganger` / `tilgangerOrganisasjoner` / `tilgangerMiljoer`: samme rolle-filter, applied i samme WHERE-clause for konsistens.

Speiler eksisterende `applikasjoner: SYNLIGE_APPLIKASJONER` (mock og forventet producer-implementasjon).

#### Cache-konsistens ved rolle/persona-bytte

Per analyse-beslutning #4: ingen ny invalidering kreves. `usePersonaOverride.applyPersonaChange` (`src/common/lib/persona/hooks/usePersonaOverride.ts:32-53`) kjører `apolloClient.refetchQueries({ include: 'active', updateCache: cache.reset })` ved persona-bytte — dekker både `mineSynlige*`-queries og `Applikasjon.tilganger*`-feltene som alt annet. Plan-fasen bør likevel verifisere at `usePersonaOverride` er aktivert i alle miljøer hvor tilgangsstyring brukes (Task #5).

#### Sporings-felter

Ikke relevant for denne delta-en. Ingen nye entity-typer som trenger `opprettetAv`/`endretAv`. Felter på `Applikasjon` er reine read-models av domenetilstand.

#### Versjonering

Ingen `xV2`-versjonering nødvendig — alle endringene er bakoverkompatible tillegg (nye felter, nye queries). `mineApplikasjonsAdminOrganisasjoner` beholdes uendret. Per `fs-sikt-no-producer-schema-design §"Endringer i API bør ikke ødelegge for klienter"`.

#### Mock-API speiling

Mock-API-en (`src/mocks/applikasjoner/`) må speile schema-endringene parallelt, slik at fs-admin kan utvikle og teste hele flyten end-to-end før producer-schemaet lander. Detaljer i Task #1.

### Åpne spørsmål

Ingen åpne spørsmål blokkerer planen. Alle fem spørsmål i analyse-walkthrough-en er avklart (jf. `spec.log.md` 2026-06-16-entry og analysens § Open Questions). Schemaet over kodifiserer alle fem beslutninger.

## Implementation Tasks

### Task #1: Utvid mock-API med rolle-filter og nye filter-kilder

**Priority**: High
**Size**: M
**Dependencies**: None
**Addresses Requirements**: `Tilgjengelige miljøer i filter` (begge scenarier), `Tilgjengelige organisasjoner i filter` (begge scenarier), `Regel: Synlighet for tilganger`.

**Acceptance Criteria**:

- [ ] `mineSynligeOrganisasjonerHandler` og `mineSynligeMiljoerHandler` lagt til i `src/mocks/applikasjoner/handlers/queries.ts` og registrert i `queryHandlers`-arrayet.
- [ ] Begge handlers returnerer alfabetisk sorterte lister; verdiene derives fra fixtures (`MINE_ADMIN_ORGANISASJONER` ∪ organisasjoner i tilganger som krysser inn til admin-data; tilsvarende for miljøer).
- [ ] `Applikasjon`-typen i `src/mocks/applikasjoner/types.ts` har feltene `tilgangerMiljoer: Miljo[]` og `tilgangerOrganisasjoner: Organisasjon[]`.
- [ ] `buildApplikasjonMedTilgangerResponse` rolle-filtrerer `a.tilganger` mot `MINE_ADMIN_ORG_IDS`: hvis `a.organisasjon?.id ∈ MINE_ADMIN_ORG_IDS` → behold alle; ellers → behold kun tilganger der `t.organisasjon.id ∈ MINE_ADMIN_ORG_IDS`.
- [ ] `tilgangerMiljoer` / `tilgangerOrganisasjoner` på Applikasjon-objektet populeres fra det rolle-filtrerte settet (distinkt på `miljo.kode` / `organisasjon.id`, alfabetisk på `navn`).
- [ ] `applyTilgangerFilter` og `sortTilganger` opererer ETTER rolle-filteret (uendret rekkefølge: rolle → bruker-filter → sort → paginate).
- [ ] Eksisterende handler for `applikasjon(id)` (uten paginerte tilganger) trenger ikke endring — den returnerer hele `Applikasjon`-objektet inkludert de nye feltene fra storen.
- [ ] Følger fs-admin-mock-api-with-data-skillet — type-varied fixtures, ingen "alle har samme tilstand".
- [ ] Unit-test: nytt test-tilfelle i `src/mocks/applikasjoner/handlers/queries.test.ts` (eller tilsvarende test-fil) som bekrefter rolle-filter for både eier-admin og kryss-org-admin-scenarier, og at `tilgangerMiljoer`/`tilgangerOrganisasjoner` stemmer overens med det filtrerte settet.

**Implementation Notes**:

`MINE_ADMIN_ORG_IDS` brukes som rolle-proxy (samme `Set<string>` som `SYNLIGE_APPLIKASJONER` (`fixtures/applikasjoner.ts:572`) allerede leser fra). Hvis det blir flere persona-cases i fremtiden, kan mocken eksponere et persona-velger-felt; for denne iterasjonen er én persona nok. Helper-funksjonen kan se ut som:

```ts
function filterTilgangerForPersona(
  a: Applikasjon,
  tilganger: ApplikasjonTilgang[],
): ApplikasjonTilgang[] {
  if (a.organisasjon && MINE_ADMIN_ORG_IDS.has(a.organisasjon.id)) return tilganger
  return tilganger.filter((t) => MINE_ADMIN_ORG_IDS.has(t.organisasjon.id))
}
```

Husk: `applikasjon` med `organisasjon === null` (super-admin-tilfellet) — behandle som "eier-admin" (returner alle). Konsistent med hvordan `SYNLIGE_APPLIKASJONER` allerede inkluderer `app.organisasjon === null`.

`MINE_SYNLIGE_ORGANISASJONER` og `MINE_SYNLIGE_MILJOER` kan deriveres i fixtures-filene som rene konstanter (`new Set` + sort).

---

### Task #2: Nye TRANSITIONAL hooks for listevisnings-filter-kilder

**Priority**: High
**Size**: S
**Dependencies**: Task #1
**Addresses Requirements**: `Tilgjengelige miljøer i filter` (listevisning), `Tilgjengelige organisasjoner i filter` (listevisning).

**Acceptance Criteria**:

- [ ] `src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetMineSynligeOrganisasjoner.tsx` opprettet med samme TRANSITIONAL-kommentar-blokk som `useGetMineApplikasjonsAdminOrganisasjoner.tsx` (1–12).
- [ ] `src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetMineSynligeMiljoer.tsx` opprettet med samme mønster.
- [ ] Begge hooks bruker flat `gql` fra `@apollo/client` + `useQuery` med `fetchPolicy: 'cache-first'`.
- [ ] Begge hooks returnerer `{ organisasjoner | miljoer, loading, error }` med default `[]` på data-felt for å speile eksisterende mønster.
- [ ] Manuelle TypeScript-typer (`MineSynligOrganisasjon`, `MineSynligMiljo`) deklarert lokalt; `__typename` med eksplisitt literal-type.
- [ ] Følger `graphql-consumer`-skillen: operation-navn matcher mock-handler-navn (`mineSynligeOrganisasjoner` / `mineSynligeMiljoer`).
- [ ] A11y-test ikke nødvendig på selve hookene (rent data-lag).
- [ ] Unit-test (Jest, ikke a11y): hver hook re-rendres med data fra MSW-mock; verifiser `loading` → `false` og array-content matcher fixture.

**Implementation Notes**:

Hookene er nesten en kopi av `useGetMineApplikasjonsAdminOrganisasjoner.tsx` — bytt operasjons-navn, type-navn og return-shape. TRANSITIONAL-kommentaren MÅ inkludere migrasjons-stegene (re-run codegen, swap `gql`-import, slett lokal type) slik at fremtidig refactor er sporbar uten å lese skillen.

---

### Task #3: Refaktorer listevisnings-filter til å bruke nye kilder

**Priority**: High
**Size**: S
**Dependencies**: Task #2
**Addresses Requirements**: Samme som Task #2.

**Acceptance Criteria**:

- [ ] `ApplikasjonerMiljoFilter.tsx`: hardkodet `options: MiljoOption[] = [...]`-konstant fjernet; `miljoer, loading` hentes fra `useGetMineSynligeMiljoer`. `options`-array bygget som `miljoer.map((m) => ({ value: m.kode, label: m.navn }))`. `disabled={loading || options.length === 0}` lagt til på `Select` (per fs-admin-inputs §10).
- [ ] `ApplikasjonerOrganisasjonFilter.tsx`: import bytt fra `useGetMineApplikasjonsAdminOrganisasjoner` til `useGetMineSynligeOrganisasjoner`. Kommentar-blokk oppdatert — fjern "intentionally does not show every org…"-tekst, erstatt med kort note om at hooken returnerer `innsynsscope` (rolle-utledet union (a)+(b)).
- [ ] TRANSITIONAL-kommentar-blokker oppdatert med ny situasjon (fjern "demo / prod-stub" i miljø, fjern "intentionally does not show"-tekst i organisasjon).
- [ ] Eksisterende `*.a11y.test.tsx` for begge komponentene grønne — MSW returnerer nye queries automatisk via handlers fra Task #1.
- [ ] Storybook-stories (hvis de finnes) oppdatert: bytt mock fra hardkodet `[demo, prod]` til MSW-handler-svar (samme rigg som andre tilgangsstyring-stories).
- [ ] Chip-rendering uendret — `getLabel(value)` finner `miljoer.find((o) => o.value === selected)?.label`.

**Implementation Notes**:

Husk at chip-mode-grenen bruker `options.find()` mot full `options`-array. Etter byttet er `options` ikke lenger en konstant — den re-evalueres på hver render. Det er OK; arrayet er lite, og chip vises bare når en verdi er valgt.

`ApplikasjonerStatusFilter` og `ApplikasjonerNavnFilter` er IKKE påvirket av denne delta-en — ikke rør dem.

---

### Task #4: Utvid `applikasjonMedTilganger`-query med filter-kilder og refaktorer tilganger-tab-filter

**Priority**: High
**Size**: M
**Dependencies**: Task #1
**Addresses Requirements**: `Tilgjengelige miljøer i filter` (tilganger-tab), `Tilgjengelige organisasjoner i filter` (tilganger-tab), `Regel: Synlighet for tilganger` (frontend-side: ingen UI-signal, men data-flow bekreftet).

**Acceptance Criteria**:

- [ ] **Designvalg avklart i kode-review:** valg mellom (a) utvide `GET_APPLIKASJON_TILGANGER`-selection-set + prop-drill fra `ApplikasjonTilgangerResultList`-hooken til filter-komponentene, eller (b) introdusere `useGetApplikasjonTilgangerFilterOptions(applikasjonId)` som egen hook. **Anbefalt: (b)** — separasjon av filter-kilde-data fra paginert connection-data gjør hver hook smal og tydelig; Apollo's normaliserte cache deler `Applikasjon:id`-felter mellom de to queriene gratis. Begrunn valget i PR-en.
- [ ] `useGetApplikasjonTilgangerTypes.ts` utvidet med `tilgangerMiljoer: ApplikasjonTilgangerListMiljo[]` og `tilgangerOrganisasjoner: ApplikasjonTilgangerListOrganisasjon[]` på `ApplikasjonTilgangerOwner`-interfacet.
- [ ] Ny operasjon (variant b) eller utvidet selection-set (variant a) henter `tilgangerMiljoer { kode, navn }` og `tilgangerOrganisasjoner { id, navn }` fra `applikasjon(id)`.
- [ ] `ApplikasjonTilganger.tsx` (tab-container): henter filter-options + loading, prop-driller dem til `ApplikasjonTilgangerFilter`.
- [ ] `ApplikasjonTilgangerFilter.tsx`: tar inn nye props `miljoer`, `organisasjoner`, `loading`; prop-driller videre til de to filter-barna.
- [ ] `ApplikasjonTilgangerMiljoFilter.tsx`: hardkodet `[demo, prod]`-konstant fjernet; `miljoer, loading` brukes fra props. `disabled={loading || options.length === 0}`.
- [ ] `ApplikasjonTilgangerOrganisasjonFilter.tsx`: import av `useGetMineApplikasjonsAdminOrganisasjoner` fjernet; `organisasjoner, loading` brukes fra props.
- [ ] TRANSITIONAL-kommentarer oppdatert i begge filter-komponentene (fjern "Reuses the same hook as the list-page filter" og "Options are kept inline (demo / prod)").
- [ ] Eksisterende `*.a11y.test.tsx` for `ApplikasjonTilgangerMiljoFilter` og `ApplikasjonTilgangerOrganisasjonFilter` oppdatert til å sende inn `miljoer`/`organisasjoner`/`loading` props eksplisitt (de er ikke lenger hook-baserte i isolert test).
- [ ] Manuell verifikasjon: tilganger-tab på en applikasjon der persona er eier-admin → ser alle miljøer/organisasjoner. På en applikasjon der persona er kryss-org-admin → ser kun miljøer/organisasjoner som er representert i de rolle-filtrerte tilgangene.
- [ ] `Applikasjon.fields.tilganger` cache-key i `cacheConfig.ts` uendret (`['filter', 'orderBy']`); fungerer fortsatt riktig fordi rolle-filter er server-side og ikke en query-argument.

**Implementation Notes**:

Variant (b) — ny `useGetApplikasjonTilgangerFilterOptions(applikasjonId)` — vil typisk se sånn ut i grovskisse:

```ts
const GET_APPLIKASJON_TILGANGER_FILTER_OPTIONS = gql`
  query applikasjonTilgangerFilterOptions($id: ID!) {
    applikasjon(id: $id) {
      id
      tilgangerMiljoer { kode navn }
      tilgangerOrganisasjoner { id navn }
    }
  }
`
```

NB: denne queryen MÅ bruke et annet operation-navn enn `applikasjonMedTilganger` (graphql-codegen avviser duplikater) — operation-navn må også registreres som ny handler i mock-API-en (eller deles via shared response-builder, som `applikasjonFjernbareTilganger` allerede gjør, jf. `queries.ts:262-267`).

Variant (a) — prop-drilling fra ResultList opp til Filter — er enklere mock-handler-side (én operasjon) men krever en data-flow-refactor på tvers av tab-container, Filter og ResultList. Hvis det er mye lift-state-up-arbeid involvert, foretrekk (b).

`useDataListQuery` skal IKKE pakkes inn — den fortsetter å håndtere paginerings-state for `tilganger`-connection.

---

### Task #5: Verifiser persona-override cache-flush dekker nye queries

**Priority**: Medium
**Size**: S
**Dependencies**: Task #2, Task #4
**Addresses Requirements**: `Regel: Synlighet for tilganger` (cache-konsistens på tvers av rolle-skifte).

**Acceptance Criteria**:

- [ ] Manuell verifikasjon i development-build: åpne applikasjoner-listevisning, bytt persona via persona-override-UI (`src/common/lib/persona/...`), bekreft at filter-dropdowns oppdateres med ny persona's `mineSynligeOrganisasjoner`/`mineSynligeMiljoer`.
- [ ] Samme verifikasjon på en applikasjons tilganger-tab: bytt persona, bekreft at både listen og filter-dropdowns reflekterer den nye personaens rolle-filter.
- [ ] Dokumenter i en kort prosa-note (i Task-completion-doc) at `usePersonaOverride.applyPersonaChange` (`src/common/lib/persona/hooks/usePersonaOverride.ts:32-53`) håndterer cache-flush korrekt for de nye queriene, og at ingen ny `cache.evict` er nødvendig.
- [ ] Hvis verifikasjon avdekker at en query ikke re-fetches (f.eks. fordi `fetchPolicy: 'cache-first'` på admin-hooken trumfer reset i én sjelden race) → åpne en separat task; ikke bake fix inn i denne.

**Implementation Notes**:

Hooken bruker `apolloClient.refetchQueries({ include: 'active', updateCache: (cache) => cache.reset() })`. `include: 'active'` re-fetcher alle observerte queries; `cache.reset()` invaliderer normalized cache. Sammen bør de dekke begge bruksmønstre. Dokumenter manuell test-prosedyre i completion-doc-en.

Hvis persona-override-UI ikke finnes i prod-bygg, bekreft i stedet via dev-only persona-cookie eller via direkte JS-eval i devtools (`window.__APOLLO_CLIENT__.refetchQueries(...)`).

---

### Task #6: Cross-contributor hand-off til fs-plattform-producer

**Priority**: Medium
**Size**: S
**Dependencies**: Task #4 (helst — så frontend-call-sites er stabilt nok å sitere)
**Addresses Requirements**: Alle fem krav på producer-siden.

**Acceptance Criteria**:

- [ ] GitHub-issue åpnet i fs-plattform-repoet (eller hvor producer-arbeidet spores) som peker tilbake til denne planens `## GraphQL-endringer`-seksjon og sikt-no/fs#31.
- [ ] Issue-bodyen oppsummerer: 2 nye Query-felter, 2 nye `Applikasjon`-felter, 1 autorisasjons-grense på `Applikasjon.tilganger`-resolveren. Inkluderer Lag A-SDL fra hver Op.
- [ ] Issue-bodyen flagger eksplisitt: rolle-filter må implementeres i WHERE-clause på databasen (autorisasjons-grense, ikke en filter-input), JWT/session-context er allerede tilgjengelig i `applikasjoner`-listen-resolveren og forventes tilgjengelig i `Applikasjon.tilganger`-resolveren.
- [ ] Producer-task ikke implementert i denne fs-admin-planen — kun handoff. Når producer-schemaet lander, åpnes en separat plan for å migrere de fire TRANSITIONAL-hookene + de fire filter-komponentene til codegen + fragment-colocation.
- [ ] Issue krysslinkes i denne planens completion-doc (`task-6-completion.md`) og i fs-admin-CHANGELOG-en der relevant.

**Implementation Notes**:

Bruk `artifact-coord`-skillen for å publisere denne plan-fila til coord-repoet før hand-off, slik at fs-plattform-folk leser samme dokument. Hand-off-issue er IKKE et bat-execute-deliverable; det er en koordinerings-handling som tas manuelt etter at planen er publisert.

Inkluder gjerne et "Hvordan teste" -avsnitt i issue-en som peker på mock-API-implementasjonen (Task #1) som "live spec" som producer kan diff'e mot.

---

## Risk Assessment

### Technical Risks

- **Risk**: Variant (a) i Task #4 — prop-drilling fra ResultList opp til Filter — kan introdusere unødvendig kompleksitet i tab-containerens data-flow og gjøre Storybook-stories tyngre å sette opp (filter-komponentene må ha realistiske props i isolert story-render).
  - **Mitigation**: Default til variant (b) (egen hook) hvis ikke det er tunge ytelseshensyn. Apollo's normaliserte cache deler `Applikasjon:id`-felter mellom de to queriene automatisk, så det er ikke en ekstra round-trip i praksis utenfor kald cache.

- **Risk**: Mock-API rolle-filter kan introdusere regresjoner i eksisterende a11y-tester / unit-tester som forutsetter "alle tilganger synes alltid".
  - **Mitigation**: Eksisterende `MINE_ADMIN_ORG_IDS` inkluderer `sikt`, `uio`, `ntnu`; persona er eier-admin for disse. Hvis testene primært bruker applikasjoner eid av `org-sikt`/`org-uio`/`org-ntnu` blir tilgangs-listen uendret. Kjør hele suite-en etter Task #1 og fix eventuelle regresjoner som dukker opp (skal være 0 hvis fixtures er sane).

- **Risk**: TRANSITIONAL-mønsteret introduserer to nye hooks som vil måtte rives og bygges på nytt når producer-schemaet lander.
  - **Mitigation**: TRANSITIONAL-kommentar-blokken (Task #2) MÅ være på plass på begge nye hooks med eksplisitte migrasjons-steg. Inkluder også et søk-stikkord (f.eks. `// TRANSITIONAL_APPLIKASJON_TILGANGSSTYRING`) som gjør at codegen-batchen kan finne alle treff med ett grep.

- **Risk**: `Apollo.fields.tilganger` cache-key i `cacheConfig.ts` bygger på `['filter', 'orderBy']`, IKKE på persona/rolle. Hvis to brukere med ulik rolle deler samme klient-instans innad i en session (persona-bytte uten reload), kan cache krysskontaminere — kort vindu.
  - **Mitigation**: `usePersonaOverride.applyPersonaChange` cache.reset() håndterer dette i normal flyt (analyse-beslutning #4). Task #5 verifiserer dette manuelt. Hvis verifikasjonen feiler, vurder å legge `__role` (eller tilsvarende persona-discriminator) til cache-key-args — men det er ikke planlagt for denne delta-en.

- **Risk**: Variant (a) i Task #4 — utvide `applikasjonMedTilganger` med to nye selection-felter — kan øke svarstørrelsen og response-tiden marginalt. Mock-API: ubetydelig. Producer-side: avhengig av hvordan resolveren computer distinkte sett (hvis det krever en separat query mot tilganger-tabellen, kan det bli en N+1 — men det er producer-teamets bekymring).
  - **Mitigation**: Schema-seksjonen flagger dette implisitt ved å si "samme WHERE som connection". Hand-off-issue (Task #6) bør be producer eksplisitt verifisere at de to nye feltene deler underlying query med connection (ikke duplikat database-roundtrip).

### Testing Requirements

- Unit-tester for mock-handlers (Task #1): begge persona-grener (eier-admin og kryss-org-admin) + tom-resultat-grener (admin uten noen tilganger i scope).
- Unit-tester for nye hooks (Task #2): MSW returnerer mock-data; hookene re-rendres riktig.
- A11y-tester for de fire endrede filter-komponentene (Task #3, #4): grønne. Hvis test-rigg-en isolerer komponenter uten Apollo provider, må mocks legges til (`MockedProvider` eller MSW).
- Manuell e2e-verifikasjon (Task #5): persona-bytte → filter-dropdowns oppdateres.
- Storybook-stories oppdatert (Task #3, #4): MSW-handlere fra Task #1 brukes som data-kilde; ingen hardkodede story-arguments for filter-options.

## Success Criteria

- [ ] Alle krav i delta-spec § Endret er addressert av minst én Task — verifisert via traceability-tabellen under.
- [ ] `Regel: Synlighet for tilganger` implementert på mock-side; producer-side er handoff'et via Task #6.
- [ ] `mineApplikasjonsAdminOrganisasjoner` og dens fire eksisterende kall-steder (`ApplikasjonerOverview.tsx:47`, `OpprettApplikasjonModal.tsx:72`, `TildelTilgangModal.tsx:77`, `FjernTilgangModal.tsx:94`) er UENDRET — kun semantikk i dokumentasjons-kommentaren er oppdatert (Task #3 kommentar-cleanup).
- [ ] Alle nye/endrede komponenter har grønn `.a11y.test.tsx`.
- [ ] Type-check (`npm run test:typecheck`) passerer.
- [ ] Lint (`npm run lint`) passerer.
- [ ] TRANSITIONAL-mønsteret er konsekvent: ingen nye hooks importerer fra `@/__generated__` — alle bruker flat `gql` fra `@apollo/client` + manuelle typer.

## Requirements Traceability

| Requirement (delta-spec § Endret) | Addresses Tasks | Status |
| --------------------------------- | --------------- | ------ |
| `Tilgjengelige miljøer i filter` (listevisning) — `listevisning_og_sok.feature` | Task #1, Task #2, Task #3 | Planned |
| `Tilgjengelige organisasjoner i filter` (listevisning) — `listevisning_og_sok.feature` | Task #1, Task #2, Task #3 | Planned |
| `Se tilganger for en applikasjon` — formuleringsendring "alle tilganger" → "tilganger" — `vise_tilganger.feature` | Task #1, Task #4 (server-side rolle-filter gir presisjonen formuleringen åpner for) | Planned |
| `Tilgjengelige miljøer i filter` (tilganger-tab) — `vise_tilganger.feature` | Task #1, Task #4 | Planned |
| `Tilgjengelige organisasjoner i filter` (tilganger-tab) — `vise_tilganger.feature` | Task #1, Task #4 | Planned |
| `Regel: Synlighet for tilganger` — eier-admin-scenario — `vise_tilganger.feature` | Task #1 (mock), Task #6 (producer hand-off), Task #5 (cache-konsistens) | Planned |
| `Regel: Synlighet for tilganger` — kryss-org-admin-scenario — `vise_tilganger.feature` | Task #1, Task #6, Task #5 | Planned |

Alle krav addressert. Greenfield-krav som ikke nevnes i delta-spec-en (status-filter, tilknytning-filter, paginering, sortering, arvet-badge) forblir uendret per spec-ens innledende kontrakt.

## Cross-contributor Dependencies

- **fs-plattform (producer-team)** — schema-implementasjon på fs-sikt-no-supergrafen:
  - Implementer `Query.mineSynligeOrganisasjoner` og `Query.mineSynligeMiljoer` (Op #1, #2 i § GraphQL-endringer).
  - Legg til felter `Applikasjon.tilgangerOrganisasjoner` og `Applikasjon.tilgangerMiljoer` (Op #3, #4).
  - Implementer rolle-filter i WHERE-clause på `Applikasjon.tilganger`-resolveren (Op #5).
  - **Why it blocks:** Når producer-schemaet er merget kan fs-admin migrere de fire TRANSITIONAL-hookene + de fire filter-komponentene til codegen + fragment-colocation. Inntil det er fs-admin dekket av mock-API-en (Task #1) for hele delta-en.
  - Hand-off skjer i Task #6 (issue-opprettelse). Selve producer-implementasjonen er ikke en del av denne planen.

- **fs-admin-codegen-batch (intern oppfølging når producer lander)** — egen plan, ikke en del av denne:
  - Fjern `'!src/mocks/**/*'`-codegen-exclusion.
  - Bytt alle TRANSITIONAL flat-`gql`-konstanter til `import { gql } from '@/__generated__'`.
  - Erstatt manuelle typer (`MineSynligOrganisasjon`, `MineSynligMiljo`, `ApplikasjonTilgangerListMiljo`, etc.) med codegen-genererte.
  - Refaktorer til fragment-colocation der det gir mening (jf. greenfield Task #1–#16 i `docs/specs/31-…`).
  - Slett `src/mocks/applikasjoner/`-scaffoldet per dens egen `teardown-applikasjoner.md`.
  - **Why it blocks:** Ingenting — dette er teknisk gjeld som ryddes opp etter at producer er på plass. Denne delta-en gjør gjelden litt større (to nye hooks, to nye queries), men også litt mer ensartet (alt TRANSITIONAL i samme folder migreres samtidig).
