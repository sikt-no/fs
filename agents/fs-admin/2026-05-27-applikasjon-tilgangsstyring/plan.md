# Plan (delta): Applikasjon-tilgangsstyring — Iteration 2

> **Scope:** Iter-2-runde av initiativ [#31](https://github.com/sikt-no/fs/issues/31). Denne planen beskriver **bare endringene** mot iter-1-planen ([`docs/ACTIVE-ITERATION-2/plan-applikasjon-tilgangsstyring.md`](../ACTIVE-ITERATION-2/plan-applikasjon-tilgangsstyring.md)). Iter-1-tasks (#1–#22) er ferdigstilt og fungerer som fundament. Punkter som er uendret er **ikke** gjentatt.
>
> **Analysegrunnlag:** [`analysis-iteration-2-applikasjon-tilgangsstyring.md`](analysis-iteration-2-applikasjon-tilgangsstyring.md) (alle 7 åpne spørsmål er avklart 2026-05-27). Krav på `fruitbat`-snapshot i [`krav-input/manifest.md`](krav-input/manifest.md).

## Proposed Solution

### Architecture Approach

Iter 2 endrer **ikke** den overordnede arkitekturen fra iter 1: `ListPageLayout` for `/tilgangsstyring/applikasjoner`, `DetailPageLayout` for `/tilgangsstyring/applikasjoner/[id]`, `DomainIndexPattern` for `/tilgangsstyring`. Tre delta-områder ligger oppå:

1. **In-place edit-modus på Detaljer-fanen.** Tre dialog-baserte edit-flyter (`RedigerBeskrivelseDialog`, `SettAnsvarligDialog`, og en hypotetisk `RedigerNavnDialog`) erstattes av én _in-place_ rediger-modus på selve Detaljer-fanen, drevet av eksisterende `ViewEditTextField` / `ViewEditTextArea` / `ViewEditSelect`-familien. Lokal `useState` på Detaljer-fane-komponenten eier `editMode`-flagget; lokal state dør med ruten, så krav-regelen "ulagrede endringer forkastes ved navigasjon / fane-bytte" oppfylles automatisk.

2. **Bulk-fjern-modal speilet på `TildelTilgangerDialog`.** Iter-1 `FjernTilgangerDialog/` ble bygd som per-rad-fjerning + bekreftelsesdialog. Iter-2-krav omarbeider dette til en bulk-modal med `(organisasjon, miljø)`-velger + multi-select av kandidater. Filstruktur kopieres fra eksisterende `TildelTilgangerDialog/` (`Button.tsx`, `Dialog.tsx`, `query.ts`, `mutation.ts`).

3. **Tredje fane "Endringslogg" på detaljsiden.** Mønster lånt fra `src/domains/soknadsbehandling/features/AuditLogCard/` — Relay-cursor-paginering med "Last inn flere 50", `Surface`-card med `AuditLogItem`-rader. UI-shell bygges nå; konkrete loggpost-felter ferdigstilles når åpne backend-spørsmål er besvart (Q6-decision: UI shell now, content later).

Tre mindre tilleggs-områder:

4. **Listevisning får `Antall tilganger`-kolonne** + ny `Miljø`-filter.
5. **`Arvet`-merke + `Tilknytning`-filter** på Tilganger-fanen.
6. **POC-fjerning** (var åpent spørsmål i iter-1) håndteres som egen "Fase X — POC-fjerning" når Unleash-flagget `tilgangsstyring-applikasjoner` er aktivert i prod og vi har minst én uke uten regresjon-meldinger. **Ikke i scope for denne planen.**

### Key Technical Decisions

1. **Edit-modus eier state lokalt med `useState`, ikke `nuqs`-URL-state.**
   - Hvorfor: krav-regelen "ulagrede endringer forkastes ved navigasjon / fane-bytte" tilsier at editMode ikke er delbart view-state. Lokal state lever én rute-mount.
   - Alternativ vurdert: URL-state. Forkastet fordi en delbar URL i edit-modus ville bevart endringer ved tilbake-knapp/refresh — i strid med kravet.
   - Implementasjons-mønster: `OpptakSettings.tsx` ([`src/domains/opptak/features/OpptakManagement/OpptakSettings/OpptakSettings.tsx`](../../src/domains/opptak/features/OpptakManagement/OpptakSettings/OpptakSettings.tsx)) tar `editMode: boolean` som prop, parent eier state.

2. **Atomisk `redigerApplikasjonDetaljer`-mutasjon over tre separate.**
   - Hvorfor: UI-en har én Lagre-knapp som lagrer navn + beskrivelse + ansvarlig samtidig. Tre serielle mutations ville krevd rollback ved delfeil.
   - Alternativ vurdert: beholde `redigerApplikasjonBeskrivelse` + `settApplikasjonAnsvarlig` + ny `redigerApplikasjonNavn`. Forkastet — komplisert og semantisk skjev.
   - `redigerApplikasjonBeskrivelse` deprecated med sluttdato 31. desember 2026.

3. **`FjernTilgangerDialog` rives og bygges på nytt etter `TildelTilgangerDialog`-malen.**
   - Hvorfor: iter-1-implementasjonen er per-rad-fjerning + confirm; iter-2 er bulk-modal med org+miljø-velger først, så multi-select. Strukturelt ulikt nok at en in-place refactor er mer arbeid enn en rewrite.
   - iter-1-koden under `src/domains/support/features/Applikasjon/components/FjernTilgangerDialog/` slettes; ny dialog speilet på `TildelTilgangerDialog/`.
   - Alternativ vurdert: utvide eksisterende dialog. Forkastet — det meste av iter-1-koden er hooks og UI som ikke gjelder lenger.

4. **`Tilknytning`-filter rendret som `Select` med tre verdier (ALLE/DIREKTE/ARVET), ikke `ToggleSwitch`.**
   - Hvorfor: Q5-decision (sketch wins). Skissens default "Alle tilknytninger" + to alternativer passer naturlig i en `Select`. Toggle dekker bare to verdier.
   - URL-state via `useDataListState`/`nuqs` (gjelder de andre filterne på Tilganger-fanen også).

5. **Endringslogg-fanen bygger ny `ApplikasjonEndringsloggItem`-variant, ikke gjenbruker `AuditLogItem` direkte.**
   - Hvorfor: `AuditLogItem` i soknadsbehandling er sterkt knyttet til `Sak`-domenet. Mønsteret gjenbrukes, ikke koden.
   - UI-shell først; felt-utvalg utvides når åpne spørsmål om loggpost-innhold er besvart (Q6-decision).

6. **Legacy FS-applikasjoner med `ansvarlig = null`: Force-pick on first edit.**
   - Hvorfor: Q4-decision. Ingen big-bang-backfill — UI viser advarsel + blokkerer save inntil ansvarlig settes.
   - Backend tillater `Applikasjon.ansvarlig: Ansvarlig` (nullable) for legacy; nye applikasjoner krever ansvarlig i opprett-input.

7. **Visningsnavn + navn som to separate felter på `Applikasjon`.**
   - Hvorfor: Q3-decision. `visningsnavn` er idP-autoritativt og globalt unikt (K8); `navn` er brukerredigerbart alias.
   - Eksisterende `Applikasjon.navn` fortolkes som den brukerredigerbare verdien (uten endring av navngivning). Nytt `visningsnavn: String!` legges til.

### File Changes Overview

**Slettes (rives ned):**
- `src/domains/support/features/Applikasjon/components/RedigerBeskrivelseDialog/` (iter-1 leveranse — erstattes av in-place edit-modus)
- `src/domains/support/features/Applikasjon/components/SettAnsvarligDialog/` (samme — innabsorbert i Detaljer-fanens edit-modus)
- `src/domains/support/features/Applikasjon/components/FjernTilgangerDialog/` (iter-1 per-rad-flyt — erstattes av bulk-modal)

**Endres:**
- `src/domains/support/features/Applikasjon/features/ApplikasjonDetaljer/ApplikasjonDetaljer.tsx` (eller tilsvarende fil-sti fra iter-1) — får edit-modus, ViewEditX-felter, lokal `useState` for `editMode`, Lagre/Avbryt-knapper
- `src/domains/support/features/Applikasjon/components/ApplikasjonInformation/ApplikasjonInformation.tsx` — TopBar utvides med `Antall tilganger` og `Deaktiver`-knapp
- `src/domains/support/features/Applikasjoner/components/ApplikasjonerResultList/ApplikasjonerResultList.tsx` — ny `Antall tilganger`-kolonne
- `src/domains/support/features/Applikasjoner/components/ApplikasjonerFilter/ApplikasjonerFilter.tsx` — nytt `Miljø`-filter
- `src/domains/support/features/Applikasjon/features/ApplikasjonTilganger/ApplikasjonTilganger.tsx` — fjern multi-select på rader (flytt til bulk-modalen), legg til `Arvet`-badge-rendring, `Tilknytning`-filter, `Tilgangskode`-fritekst-filter, `Organisasjon`-filter
- `src/domains/support/features/Applikasjon/components/TildelTilgangerDialog/tildelbareQuery.ts` — verifiser at den passerer `(applikasjonsId, organisasjonsId, miljo)`
- `src/domains/support/features/Applikasjon/Applikasjon.tsx` (detaljside-host) — legg til tredje `DetailPageTabbedContentPanel` for Endringslogg
- `src/common/messages/nb/support.json` — nye i18n-nøkler (se Task #-listen)
- Apollo-cache: oppdatert `update`-funksjon i `redigerApplikasjonDetaljer` slik at `Applikasjon`-cachen oppdateres atomisk

**Net-nye filer:**
- `src/domains/support/features/Applikasjon/components/FjernTilgangerDialog/` (ny — speilet på TildelTilgangerDialog):
  - `FjernTilgangerButton.tsx`
  - `FjernTilgangerDialog.tsx`
  - `FjernTilgangerDialog.module.css`
  - `FjernTilgangerDialog.a11y.test.tsx`
  - `fjernbareQuery.ts`
  - `mutation.ts`
- `src/domains/support/features/Applikasjon/features/ApplikasjonEndringslogg/`:
  - `ApplikasjonEndringslogg.tsx`
  - `ApplikasjonEndringslogg.module.css`
  - `ApplikasjonEndringslogg.a11y.test.tsx`
  - `query.ts`
  - `components/ApplikasjonEndringsloggItem/ApplikasjonEndringsloggItem.tsx`
- `src/domains/support/features/Applikasjon/components/ArvetTilgangBadge/` — liten `Tag`-wrapper med opphavs-tekst-tooltip
- Codegen-artefakter regenereres automatisk når schema oppdateres.

**Filer som forblir uendret (men leveres på av denne planen):**
- `src/common/components/inputs/ViewEdit*` — gjenbrukes som-er
- `src/domains/support/features/Applikasjon/components/TildelTilgangerDialog/` — mal for `FjernTilgangerDialog` (kopier-og-tilpass), ingen kode-endring i kilden
- `src/domains/soknadsbehandling/features/AuditLogCard/` — referanse-mønster, ingen endring

## GraphQL-endringer

**Skopering:** delta vs iter-1-planen (`docs/ACTIVE-ITERATION-2/plan-applikasjon-tilgangsstyring.md` §GraphQL-endringer, Operasjon 1–12). Operasjon 1 (`applikasjoner`), 2 (`applikasjon`), 4 (`ansvarligKandidater`), 6 (`byttApplikasjonPassord`), 12 (`UserAction`-enum) er **uendret** og spesifiseres ikke på nytt. Operasjon 3 (`tilganger`), 5 (`opprettApplikasjon`), 7 (`settAnsvarlig`), 8 (`redigerBeskrivelse`), 9 (`tildelTilganger`), 10 (`fjernTilganger`), 11 (`deaktiver`/`reaktiver`) får endringer beskrevet under. Tre net-nye operasjoner: `Query.fjernbareTilganger`, `Applikasjon.endringslogg`, samt felt-tillegg på `Applikasjon` (`visningsnavn`, `antallTilganger`, `kanRedigereNavn`, `kanSeEndringslogg`) og `ApplikasjonTilgang` (`arvetFra`).

**Premiss:** konservativt. Ingen om-versjonering av eksisterende stabile felt; tillegg gjøres via nye felt og nye mutasjoner. `redigerApplikasjonBeskrivelse` fases ut til fordel for `redigerApplikasjonDetaljer` — det er et bakoverinkompatibelt løft som er nødvendig fordi UI-en ikke lenger har en isolert beskrivelse-redigering. Per `fs-sikt-no-producer-schema-design §Endringer i API bør ikke ødelegge for klienter` markeres det gamle feltet `@deprecated` heller enn å fjernes umiddelbart.

**Domeneterm:** `Applikasjon` (uendret fra iter-1). Bekreftet mot eksisterende `schema.graphql`: `type Applikasjon`, `type ApplikasjonTilgang`, `enum ApplikasjonStatus`, `union Ansvarlig = FeideBruker | FeideGruppe`, `enum AnsvarligType { FEIDE_BRUKER, FEIDE_GRUPPE }`.

**Error-konvensjon:** følg eksisterende mønster på Applikasjon-mutasjoner — `errors: [Error!]`-array i payload, error-medlemmer implementerer `interface Error { message, path }`. Schemaet har én `Errors`-union for Applikasjon (`ReaktiverApplikasjonError`) som per i dag ikke brukes — vi viderefører array-konvensjonen for konsistens med `OpprettApplikasjonPayload`, `TildelApplikasjonTilgangerPayload` osv. (verifisert ved `grep -A 5 "^type Tildel.*Payload" schema.graphql`).

---

### Operasjon A — `Applikasjon`-typen utvides

#### Lag A — Schema-tillegg

```graphql
extend type Applikasjon {
  """
  IdP-autoritativt visningsnavn hentet ved opprettelse. Globalt unikt (jf. K8). Låst i FS Admin.
  """
  visningsnavn: String!

  """
  Antall tilganger på applikasjonen. Brukes i listevisningens kolonne og i detalj-topbarens
  "Antall tilganger"-nøkkel. Kan også leses som `tilganger.totalCount` — feltet er en read-shortcut
  for listevisning-queryen som ikke fetcher hele connection-en.
  """
  antallTilganger: Int!

  """
  Brukeren kan redigere applikasjonens `navn`-felt via `redigerApplikasjonDetaljer`. Speilet med
  de eksisterende `kanRedigereBeskrivelse` / `kanAdministrereAnsvarlig`-flaggene.
  """
  kanRedigereNavn: Boolean!

  """
  Brukeren har rettighet til å se endringsloggen for denne applikasjonen (Iter 4, K16).
  """
  kanSeEndringslogg: Boolean!
}
```

Eksisterende `Applikasjon.navn: String!` beholdes — det er nå **brukerredigerbart alias** (mappes til skissens "Navn"-felt i Detaljer-fanen). `Applikasjon.ansvarlig: Ansvarlig` forblir nullable for å støtte legacy FS-applikasjoner uten ansvarlig (Q4-decision: force-pick on first edit).

#### Lag B — fs-admin call-site

Felt-tilleggene konsumeres som del av eksisterende Operasjon 1 (`GET_APPLIKASJONER` for listevisning) og Operasjon 2 (`GET_APPLIKASJON` for detaljside). Ingen ny query — bare flere felt i selection-set:

```ts
// Utvidelse av GET_APPLIKASJONER (Operasjon 1) for listevisningens nye kolonne
export const GET_APPLIKASJONER = gql(/* GraphQL */ `
  query GetApplikasjoner($filter: ApplikasjonFilter, $first: Int, $after: String) {
    applikasjoner(filter: $filter, first: $first, after: $after) {
      nodes {
        id
        navn
        visningsnavn
        beskrivelse
        organisasjon { id navn }
        ansvarlig { ... on FeideBruker { id navn } ... on FeideGruppe { id navn } }
        miljoer
        status
        antallTilganger  # NY — drives Antall tilganger-kolonnen
      }
      pageInfo { hasNextPage endCursor }
      totalCount
    }
  }
`)
```

```ts
// Utvidelse av GET_APPLIKASJON (Operasjon 2) for TopBar + Detaljer-fane + nye kan-flagg
export const GET_APPLIKASJON = gql(/* GraphQL */ `
  query GetApplikasjon($id: ID!) {
    applikasjon(id: $id) {
      id
      navn
      visningsnavn       # NY
      beskrivelse
      status
      miljoer
      organisasjon { id navn }
      ansvarlig { ... on FeideBruker { id navn } ... on FeideGruppe { id navn } }
      antallTilganger    # NY — TopBar
      opprettetTidspunkt opprettetAv { id navn }
      endretTidspunkt    endretAv    { id navn }
      identitetsleverandor
      kanRedigereNavn        # NY
      kanRedigereBeskrivelse
      kanAdministrereAnsvarlig
      kanEndrePassord
      kanTildeleTilganger
      kanFjerneTilganger
      kanDeaktivere
      kanSeEndringslogg       # NY
    }
  }
`)
```

#### Lag C — Begrunnelse

- **Dekker krav:** BRU-APP-API-001 (`listevisning_og_sok.feature` rad `| Antall tilganger |`), BRU-APP-API-002 (`se_detaljer.feature` "Se identitetsleverandør", "Se organisasjon", "Se status"), BRU-APP-API-006 (`rediger_detaljer.feature` rettighetsregler for navn — krever `kanRedigereNavn`), BRU-APP-API-009 (`opprette_applikasjon.feature` to navne-konsepter, finding #7 i analyse).
- **Visningsnavn vs navn:** to felter er valgt over alias-på-ett-felt fordi K8s globale unikhets-krav holder på idP-navnet, mens brukeren skal kunne redigere et lokalt navn fritt. Per `fs-sikt-no-producer-schema-design §Vi innfører gjerne egne felt og typer for semantisk nyttige data-uttrekk` er det riktigere å gi separate semantiske felt enn å bake to betydninger inn i ett `navn`.
- **`antallTilganger` som read-shortcut:** alternativ var å la frontend hente `tilganger(first: 0).totalCount`. Forkastet fordi det betyr at hver applikasjon-rad i listevisningen må kjøre en sub-query (N+1) eller at gateway-en må magisk-aggregere. Et direkte felt er enklere både for konsument og produsent. Boolean-felt navngitt med verb-prefiks (`kanRedigereNavn`, `kanSeEndringslogg`) per `fs-sikt-no-producer-naming §Boolean-felt navngis med verb`.
- **`ansvarlig` forblir nullable:** Q4-decision (force-pick on first edit). Per `fs-sikt-no-producer-best-practice §Nullability` er det riktige å la feltet være nullable når legacy-data faktisk har null, selv om nye applikasjoner alltid har en ansvarlig.
- **Implementeres av:** Task #1 (queries-utvidelse), Task #2 (listevisning + TopBar-konsum), Task #4 (Detaljer-fane-konsum), Task #9 (Endringslogg-flagg-konsum).

---

### Operasjon B — `Mutation.redigerApplikasjonDetaljer` (erstatter `redigerApplikasjonBeskrivelse`)

#### Lag A — Schema-tillegg

```graphql
extend type Mutation {
  """
  Atomisk redigering av brukerredigerbare detaljer på en applikasjon: navn, beskrivelse, ansvarlig.
  Alle tre lagres som én operasjon fra Detaljer-fanens edit-modus.
  """
  redigerApplikasjonDetaljer(input: RedigerApplikasjonDetaljerInput!): RedigerApplikasjonDetaljerPayload!

  redigerApplikasjonBeskrivelse(input: RedigerApplikasjonBeskrivelseInput!): RedigerApplikasjonBeskrivelsePayload!
    @deprecated(reason: "Erstattes av redigerApplikasjonDetaljer som dekker navn, beskrivelse og ansvarlig atomisk. Fjernes etter 31. desember 2026.")
}

input RedigerApplikasjonDetaljerInput {
  applikasjonsId: ID!

  """Nytt navn. Obligatorisk; kan ikke være tom streng."""
  navn: String!

  """
  Ny beskrivelse. Sett til `null` for å tømme. Sett til strengen som skal lagres ellers.
  """
  beskrivelse: String

  """
  Ny ansvarlig. Obligatorisk — ansvarlig kan ikke fjernes (jf. `administrere_ansvarlig.feature`
  regel "Ansvarlig er obligatorisk og kan ikke fjernes"). For legacy-applikasjoner som starter
  med `ansvarlig = null` må feltet settes ved første lagring.
  """
  ansvarligId: ID!
  ansvarligType: AnsvarligType!
}

type RedigerApplikasjonDetaljerPayload {
  applikasjon: Applikasjon
  errors: [Error!]
}

"""
Feilmedlem: lagring av tomt navn er avvist.
"""
type ApplikasjonNavnObligatorisk implements Error {
  applikasjonsId: ID!
  message: String!
  path: [String!]!
}
```

#### Lag B — fs-admin call-site

```ts
export const REDIGER_APPLIKASJON_DETALJER = gql(/* GraphQL */ `
  mutation RedigerApplikasjonDetaljer($input: RedigerApplikasjonDetaljerInput!) {
    redigerApplikasjonDetaljer(input: $input) {
      applikasjon {
        id
        navn
        beskrivelse
        ansvarlig {
          ... on FeideBruker { id navn }
          ... on FeideGruppe { id navn }
        }
        endretTidspunkt
        endretAv { id navn }
      }
      errors {
        message
        path
        ... on ApplikasjonNavnObligatorisk { applikasjonsId }
        ... on AnsvarligIkkeIApplikasjonsOrganisasjon { ansvarligId applikasjonsOrganisasjonsId }
      }
    }
  }
`)
```

```ts
// Sketch — i Detaljer-fanens edit-modus-host:
const [redigerDetaljer, { loading, error }] = useMutation(REDIGER_APPLIKASJON_DETALJER)
const onLagre = async (values: { navn: string; beskrivelse: string | null; ansvarligId: string; ansvarligType: AnsvarligType }) => {
  const { data } = await redigerDetaljer({ variables: { input: { applikasjonsId, ...values } } })
  if (data?.redigerApplikasjonDetaljer.errors?.length) { /* vis feil */ return }
  exitEditMode() // lokal useState — krav: ulagrede endringer forkastes ved navigasjon
}
```

#### Lag C — Begrunnelse

- **Dekker krav:** BRU-APP-API-005 (`administrere_ansvarlig.feature` — obligatorisk ansvarlig), BRU-APP-API-006 (`rediger_detaljer.feature` — navn obligatorisk, beskrivelse + navn + ansvarlig lagres sammen).
- **Atomisk i stedet for tre mutasjoner:** alternativet var å beholde `redigerApplikasjonBeskrivelse` + `settApplikasjonAnsvarlig` + en ny `redigerApplikasjonNavn`. Forkastet fordi (a) UI-en lagrer alltid alle tre samtidig fra én Lagre-knapp, (b) tre serielle kall ville krevd kompenserende rollback ved delfeil, (c) per `fs-sikt-no-producer-schema-design §Vi innfører gjerne egne felt og typer for semantisk nyttige data-uttrekk` er det riktig å speile forretnings-operasjonen ("redigere applikasjonens detaljer") i ett felt.
- **`redigerApplikasjonBeskrivelse` deprecated, ikke fjernet:** følger `fs-sikt-no-producer-schema-design §Endringer i API bør ikke ødelegge for klienter` — bakoverkompatibel utfasing med `@deprecated` + sluttdato. Bør koordineres med backend-eier slik at fjerningsfristen samkjøres med fs-admin-utfasingen.
- **`settApplikasjonAnsvarlig`-mutasjonen:** skal **ikke** dropp'es av denne planen. Backend kan beholde den som lavnivå-bygge-blokk; fs-admin slutter å bruke den. `fjernApplikasjonAnsvarlig` skal heller ikke eksistere — bekreft at den ikke har blitt opprettet i mellomtiden (verifisert via `grep fjernApplikasjonAnsvarlig schema.graphql` → 0 treff).
- **Nullability:** `beskrivelse: String` er nullable per `fs-sikt-no-producer-best-practice §Nullability` — null betyr eksplisitt "ingen beskrivelse", som er en gyldig tilstand.
- **Implementeres av:** Task #4 (Detaljer-fanen edit-modus med ViewEditX), Task #5 (mutation-integrasjon).

---

### Operasjon C — `Mutation.opprettApplikasjon` utvides

#### Lag A — Schema-tillegg

```graphql
extend input OpprettApplikasjonInput {
  """
  Navn på applikasjonen. Obligatorisk. Settes til samme verdi som idP-visningsnavnet ved
  opprettelse om brukeren ikke oppgir noe avvikende — backend kan fylle inn default.
  """
  navn: String!

  """Ansvarlig for applikasjonen. Obligatorisk ved opprettelse."""
  ansvarligId: ID!
  ansvarligType: AnsvarligType!
}
```

Eksisterende felt (`eksternId`, `identitetsleverandor`, `organisasjonsId`) beholdes. Status settes server-side til `AKTIV` ved opprettelse — ikke et input-felt.

#### Lag B — fs-admin call-site

```ts
export const OPPRETT_APPLIKASJON = gql(/* GraphQL */ `
  mutation OpprettApplikasjon($input: OpprettApplikasjonInput!) {
    opprettApplikasjon(input: $input) {
      applikasjon {
        id
        navn
        visningsnavn
        status
        organisasjon { id navn }
      }
      errors {
        message
        path
        ... on ApplikasjonNavnObligatorisk { applikasjonsId }
      }
    }
  }
`)
```

#### Lag C — Begrunnelse

- **Dekker krav:** BRU-APP-API-009 (`opprette_applikasjon.feature` regel "Opprettelse krever et navn", regel "Opprettelse krever en ansvarlig", regel "Nyopprettet applikasjon har status Aktiv").
- **Status håndteres ikke i input:** alternativ var å eksponere `status: ApplikasjonStatus = AKTIV` i input. Forkastet — brukeren har ingen grunn til å opprette en INAKTIV applikasjon, og default-i-input er støy. Per `fs-sikt-no-producer-best-practice §Bare felt på Mutation-typen kan utføre endringer` er det helt rimelig at server setter side-effekt-verdier.
- **Navn obligatorisk i input men kan defaultes til visningsnavn på backend:** alternativ var å la frontend duplisere logikken "fyll inn visningsnavn som default i opprettelses-dialogen". Forkastet fordi visningsnavnet ikke er kjent før idP-en har verifisert eksternId — så frontend kan ikke gjøre det. Backend må håndtere defaultingen post-idP-verifikasjon.
- **Implementeres av:** Task #10 (OpprettApplikasjonDialog-utvidelse).

---

### Operasjon D — `Mutation.fjernApplikasjonTilganger` utvides

#### Lag A — Schema-tillegg

```graphql
extend input FjernApplikasjonTilgangerInput {
  """
  Organisasjon tilgangene gjelder for. Obligatorisk: en fjern-operasjon adresserer alltid
  en bestemt (org, miljø)-kombinasjon (jf. `fjerne_tilgang.feature` regel "Fjerning av
  tilganger skjer via modal").
  """
  organisasjonsId: ID!
}

"""
Feilmedlem: bruker forsøkte å fjerne en arvet tilgang direkte. Arvede tilganger må fjernes
gjennom opphavs-tilgangen — backend håndhever regelen fordi vi i tillegg dropper arvede
tilganger fra `Query.fjernbareTilganger`-resultatet (defense in depth).
"""
type ArvetTilgangIkkeFjernbar implements Error {
  tilgangsId: ID!
  message: String!
  path: [String!]!
}
```

Eksisterende felt (`applikasjonsId`, `miljo`, `tilgangIds`) beholdes uendret. Eksisterende `FjernApplikasjonTilgangerPayload` (`applikasjon`, `errors`, `fjernedeTilgangIds`) er fortsatt riktig form.

#### Lag B — fs-admin call-site

```ts
export const FJERN_APPLIKASJON_TILGANGER = gql(/* GraphQL */ `
  mutation FjernApplikasjonTilganger($input: FjernApplikasjonTilgangerInput!) {
    fjernApplikasjonTilganger(input: $input) {
      applikasjon { id antallTilganger }
      fjernedeTilgangIds
      errors {
        message
        path
        ... on ArvetTilgangIkkeFjernbar { tilgangsId }
      }
    }
  }
`)
```

```ts
// Sketch — i FjernTilgangerDialog (lokal useState for valgte ID-er):
const [fjern, { loading }] = useMutation(FJERN_APPLIKASJON_TILGANGER)
const onBekreft = async () => {
  await fjern({ variables: { input: { applikasjonsId, organisasjonsId, miljo, tilgangIds: valgteTilgangIds } } })
  closeDialog()
}
```

#### Lag C — Begrunnelse

- **Dekker krav:** BRU-APP-API-008 (`fjerne_tilgang.feature` — bulk-modal med org+miljø, INAKTIV-blokkerer-ikke, arvede-kan-ikke-fjernes).
- **`organisasjonsId` er nytt obligatorisk felt:** bryter ikke eksisterende klienter fordi iter-1-implementasjonen ennå ikke er prod-deployet, og er en nødvendig konsekvens av at (org, miljø) nå er et eksplisitt par i UI-en. Per `fs-sikt-no-producer-schema-design §Endringer i API bør ikke ødelegge for klienter` er dette en bakoverinkompatibel endring, men siden mutasjonen er på _eksperimentelt_ stabilitetsnivå (POC) er det tillatt uten varsel.
- **`ArvetTilgangIkkeFjernbar`-error som "defense in depth":** primær håndheving skjer ved at `Query.fjernbareTilganger` _ekskluderer_ arvede rader — så UI-en aldri tilbyr dem som valg. Errormedlemmet dekker race / direct-API-kall.
- **Implementeres av:** Task #7 (FjernTilgangerDialog).

---

### Operasjon E — `Query.fjernbareTilganger` (net-ny)

#### Lag A — Schema-tillegg

```graphql
extend type Query {
  """
  Returnerer tilgangene som kan fjernes fra applikasjonen for en gitt (organisasjon, miljø)-kombinasjon.
  Brukes som kildedata i FjernTilgangerDialog (multi-select-listen). Resultatet er **filtrert**:
  - Bare tilganger den autentiserte brukeren har rettighet til å fjerne.
  - Bare _direkte_ tilganger — arvede tilganger ekskluderes (jf. `fjerne_tilgang.feature`
    regel "Arvede tilganger kan ikke fjernes direkte").
  """
  fjernbareTilganger(input: FjernbareTilgangerInput!): [ApplikasjonTilgang!]!
}

input FjernbareTilgangerInput {
  applikasjonsId: ID!
  organisasjonsId: ID!
  miljo: Miljo!
}
```

#### Lag B — fs-admin call-site

```ts
export const FJERNBARE_TILGANGER = gql(/* GraphQL */ `
  query FjernbareTilganger($input: FjernbareTilgangerInput!) {
    fjernbareTilganger(input: $input) {
      id
      tilgangskode
      tilgangsbeskrivelse
      miljo
      organisasjon { id navn }
    }
  }
`)
```

```ts
// Sketch — i FjernTilgangerDialog, etter at (org, miljø) er valgt:
const { data, loading } = useQuery(FJERNBARE_TILGANGER, {
  variables: { input: { applikasjonsId, organisasjonsId, miljo } },
  skip: !organisasjonsId || !miljo,
})
```

#### Lag C — Begrunnelse

- **Dekker krav:** BRU-APP-API-008 (`fjerne_tilgang.feature` scenario "Velge tilganger å fjerne — så ser jeg en liste over tilganger jeg har rettighet til å fjerne for den valgte kombinasjonen").
- **Returnerer flat liste, ikke connection:** lista vil typisk være < 50 elementer (samme applikasjons tilganger i én org+miljø). Per `fs-sikt-no-producer-best-practice §Paginering` er paginering anbefalt over 10 — vi velger likevel flat liste fordi (a) listen er kontekst-bundet (per applikasjon, per org, per miljø) og forblir kort i praksis, (b) modal-UI-en er ikke designet for paginering, (c) `tildelbareTilganger` (iter-1) er allerede flat liste — konsistens. Hvis backend mener listen kan vokse stort må vi heller pagineres med Cursor Connections.
- **Frontend stoler på filtreringen:** UI-en gjør ingen klient-side ekskludering av arvede rader — backend leverer ferdig filtrert liste. Per `fs-sikt-no-producer-schema-design §Vi innfører gjerne egne felt og typer for semantisk nyttige data-uttrekk` er "fjernbare" en semantisk forretnings-konsept (med tre filtre: rettighet + direkte + tilstede) som hører hjemme i schema-laget.
- **Implementeres av:** Task #7 (FjernTilgangerDialog).

---

### Operasjon F — `Mutation.tildelApplikasjonTilganger` (uendret schema, verifisering)

#### Lag A — Schema-tillegg

Ingen — eksisterende `TildelApplikasjonTilgangerInput { applikasjonsId, miljo, organisasjonsId, tilgangskoder }` har allerede den iter-2-formen krav-fila krever. Verifisert via `grep -A 5 "^input TildelApplikasjonTilgangerInput" schema.graphql`.

#### Lag B — fs-admin call-site

Ingen ny `gql`-skisse. iter-1 har `TildelTilgangerDialog/tildelbareQuery.ts` + `mutation.ts` som allerede bruker `(organisasjonsId, miljo, tilgangskoder)`-trippelen. Verifiser at koden faktisk passerer alle tre argumentene (Task #8 — refactor-pass for å bekrefte iter-2-konsistens).

#### Lag C — Begrunnelse

- **Dekker krav:** BRU-APP-API-007 (`tildele_tilgang.feature` — verifisering, ikke ny utvikling).
- **Implementeres av:** Task #8 (TildelTilgangerDialog refactor-pass + INAKTIV-godkjenningstest).

---

### Operasjon G — `Applikasjon.tilganger` utvides

#### Lag A — Schema-tillegg

```graphql
extend type ApplikasjonTilgang {
  """
  Hvis denne tilgangen er **arvet** fra en eller flere andre tilganger, lister `arvetFra` opphavene.
  Tom liste betyr direkte tildelt. Backend deduplifiserer: hvis samme arvede tilgang har flere
  opphav, returneres én node med `arvetFra = [opphav1, opphav2, ...]` — ikke flere noder.
  """
  arvetFra: [ApplikasjonTilgangOpphav!]!
}

"""
Lett-vekt-referanse til en opphavs-tilgang. Ikke en full `ApplikasjonTilgang` fordi opphavet
kan høre til en annen applikasjon, og vi vil ikke åpne for utilsiktet rekursiv ekspansjon.
"""
type ApplikasjonTilgangOpphav {
  applikasjon: ApplikasjonOpphavReferanse!
  tilgangskode: String!
  miljo: Miljo!
}

type ApplikasjonOpphavReferanse {
  id: ID!
  navn: String!
}

extend input ApplikasjonTilgangerFilter {
  """
  Begrenser resultatet til direkte, arvede eller alle tilganger. Default `ALLE`.
  """
  tilknytning: Tilknytning = ALLE

  """
  Fritekst-søk på tilgangskoden (contains-match, case-insensitive).
  """
  tilgangskode: String

  """
  Begrenser resultatet til tilganger som hører til den oppgitte organisasjonen.
  """
  organisasjonsId: ID
}

enum Tilknytning {
  """Vis alle tilganger, både direkte og arvede."""
  ALLE
  """Vis kun direkte tildelte tilganger."""
  DIREKTE
  """Vis kun arvede tilganger."""
  ARVET
}
```

#### Lag B — fs-admin call-site

```ts
// Utvidelse av Operasjon 3 (Applikasjon.tilganger) fra iter-1
export const GET_APPLIKASJON_TILGANGER = gql(/* GraphQL */ `
  query GetApplikasjonTilganger(
    $id: ID!
    $filter: ApplikasjonTilgangerFilter
    $orderBy: ApplikasjonTilgangerOrderBy
    $first: Int
    $after: String
  ) {
    applikasjon(id: $id) {
      id
      tilganger(filter: $filter, orderBy: $orderBy, first: $first, after: $after) {
        nodes {
          id
          tilgangskode
          tilgangsbeskrivelse
          miljo
          organisasjon { id navn }
          arvetFra {
            tilgangskode
            miljo
            applikasjon { id navn }
          }
        }
        pageInfo { hasNextPage endCursor }
        totalCount
      }
    }
  }
`)
```

#### Lag C — Begrunnelse

- **Dekker krav:** BRU-APP-API-003 (`vise_tilganger.feature` — fire filtre, `Arvet`-merke, dedup, skjul/vis arvede).
- **`Tilknytning` enum over `skjulArvede: Boolean`:** Q5-decision (sketch wins). Tre-verdis tilstand passer ikke i en boolean. Per `fs-sikt-no-producer-naming §Boolean-felt navngis med verb` hadde et boolean uansett heter `skjulArvede` eller `visKunArvede` — begge er enaksede; enum er klarere.
- **`ApplikasjonTilgangOpphav` separat type, ikke `ApplikasjonTilgang`-rekursjon:** unngår at en arvet rad blåser opp til en hel under-tilgang-graf. Per `fs-sikt-no-producer-schema-design §Vi innfører gjerne egne felt og typer for semantisk nyttige data-uttrekk` er "opphav" en distinkt semantisk form.
- **Dedup er backend-ansvar:** krav-tekst eksplisitt: "Arvet tilgang med flere opphav listes kun én gang ... Og det fremgår at den arvede tilgangen stammer fra begge". Frontend gjør ingen dedup.
- **Filter-tillegg (`tilgangskode`, `organisasjonsId`):** speiler de fire skisse-filterne (`Tilgangskode`-fritekst, `Miljø`, `Organisasjon`, `Tilknytning`). `Miljø` finnes allerede på filteret fra iter-1.
- **Implementeres av:** Task #6 (vise_tilganger-utvidelse + ApplikasjonTilgangerFilter UI).

---

### Operasjon H — `Applikasjon.endringslogg` (net-ny, Iter 4)

#### Lag A — Schema-tillegg

```graphql
extend type Applikasjon {
  """
  Endringslogg for applikasjonen. Tilgjengelig kun for brukere med `kanSeEndringslogg = true`
  (jf. K16 / BRU-APP-API-016). Skjema-formen her er en **placeholder** — backend skal forfine
  `handlingstype` til en enum og potensielt utvide loggposten med før/etter-verdier når
  åpne spørsmål i kravarbeidet er avklart.
  """
  endringslogg(first: Int, after: String): ApplikasjonEndringsloggConnection!
}

type ApplikasjonEndringsloggConnection {
  nodes: [ApplikasjonEndringsloggItem!]!
  edges: [ApplikasjonEndringsloggEdge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type ApplikasjonEndringsloggEdge {
  cursor: String!
  node: ApplikasjonEndringsloggItem!
}

type ApplikasjonEndringsloggItem implements Node {
  id: ID!

  """Tidspunktet endringen skjedde."""
  tidspunkt: String!

  """Bruker som utførte endringen."""
  utfortAv: ApplikasjonPerson!

  """
  Maskinlesbar type-identifikator for endringen. **Placeholder** — backend definerer endelig enum
  når åpent spørsmål 1 (hva som logges) er avklart.
  """
  handlingstype: String!

  """Menneskelesbar beskrivelse av endringen."""
  beskrivelse: String!
}
```

#### Lag B — fs-admin call-site

```ts
export const GET_APPLIKASJON_ENDRINGSLOGG = gql(/* GraphQL */ `
  query GetApplikasjonEndringslogg($id: ID!, $first: Int!, $after: String) {
    applikasjon(id: $id) {
      id
      endringslogg(first: $first, after: $after) {
        nodes {
          id
          tidspunkt
          utfortAv { id navn }
          handlingstype
          beskrivelse
        }
        pageInfo { hasNextPage endCursor }
        totalCount
      }
    }
  }
`)
```

```ts
// Sketch — i ApplikasjonEndringsloggTab (tredje fane):
const { data, loading, fetchMore } = useQuery(GET_APPLIKASJON_ENDRINGSLOGG, {
  variables: { id: applikasjonId, first: 50 },
  notifyOnNetworkStatusChange: true,
})
```

#### Lag C — Begrunnelse

- **Dekker krav:** BRU-APP-API-016 (`endringslogg.feature` — tre rettighetsscenarier; fire `@openquestion`-scenarier dekkes UI-først per Q6-decision).
- **Cursor Connection per `fs-sikt-no-producer-schema-design §Vi følger Cursor Connections Specification for paginering`:** logger kan vokse uten øvre grense, så cursor-paginering er obligatorisk. `first = 50` er konsistent med iter-1s "last inn flere"-mønster (Q9-decision iter-1).
- **`handlingstype: String!` som placeholder, ikke en enum nå:** Q6-decision (UI shell now, content later). Backend skal definere enum når åpent spørsmål 1 er besvart. fs-admin viser feltet som-er inntil videre; når enumen kommer, oppdaterer vi til `enum ApplikasjonEndringsloggHandlingstype { ... }`. Per `fs-sikt-no-producer-schema-design §Endringer i API bør ikke ødelegge for klienter` er det en bakoverinkompatibel endring fra `String!` til enum — derfor flagger vi at backend bør **starte med enum direkte** hvis det er praktisk mulig, for å unngå deprecation-syklusen.
- **`ApplikasjonEndringsloggItem implements Node`:** loggposter er entitets-aktige (de har stabil ID og kan refereres senere — f.eks. fra et eventuelt audit-detalj-popup). Per `fs-sikt-no-producer-schema-design §Vi følger Global Object Identification-spesifikasjonen`.
- **`utfortAv: ApplikasjonPerson!`:** gjenbruker eksisterende `ApplikasjonPerson`-type. Konsistent med `opprettetAv`/`endretAv` på `Applikasjon` (verifisert i schema).
- **Implementeres av:** Task #9 (Endringslogg-tab + ApplikasjonEndringsloggItem-komponent).

---

### Tverrgående schema-bekymringer

**Permission-modell:** fortsetter iter-1-mønsteret — per-applikasjon-rettigheter eksponeres som `kanXxx: Boolean!`-flagg på `Applikasjon`. Iter-2 legger til `kanRedigereNavn` og `kanSeEndringslogg`. UI viser/skjuler Rediger-knapp og Endringslogg-fane basert på flaggene. Top-level `USER_ACTION.SE_APPLIKASJONER` (Operasjon 12 iter-1) er fortsatt nødvendig for menu-/route-gating. Per `fs-sikt-no-producer-best-practice §Nullability` er disse `Boolean!` (ikke nullable) fordi de er **alltid** evaluert — null ville ikke ha semantisk mening.

**Error-konvensjon (presisering):** vi viderefører `errors: [Error!]`-array på alle Applikasjon-mutasjoner. Den eksisterende `union ReaktiverApplikasjonError`-flekken i schemaet (`= IngenRettighetTilApplikasjon`) brukes ikke av tilhørende payload — det er en utilsiktet rest. fs-admin-team bør be backend om å enten knytte unionen til payloaden (om de vil bryte konvensjonen) eller fjerne den. Følges opp via krav-eier eller backend-agent.

**Versjonering:** kun ett `@deprecated`-felt i denne runden — `redigerApplikasjonBeskrivelse`. Sluttdato `31. desember 2026` foreslås; bekreft med backend-eier at det matcher deres rytme. Per `fs-sikt-no-producer-schema-design §Endringer i API bør ikke ødelegge for klienter` skal sluttdato være med i deprecation-reason.

**Sporings-felter:** ingen endring. `opprettetAv`/`endretAv`/`opprettetTidspunkt`/`endretTidspunkt` finnes allerede på `Applikasjon` (verifisert) og brukes som de er.

---

### Åpne spørsmål til schema-eier

- **`reaktiverApplikasjon`-error-union:** den ubrukte `union ReaktiverApplikasjonError = IngenRettighetTilApplikasjon` — skal den binde seg til payloaden (`errors: [ReaktiverApplikasjonError!]`), eller fjernes? Påvirker ikke iter-2-leveransen, men bør avklares for konsistens. *Eier:* backend-agent / schema-eier.
- **`handlingstype: String!` vs enum:** kan backend starte med enum direkte, eller må vi gå String → enum via deprecation? *Eier:* backend-agent.
- **`navn` defaulting i `opprettApplikasjon`:** backend må klargjøre om de defaulter `navn = visningsnavn` post-idP-verifikasjon, eller om frontend må fylle inn navn synkront. *Eier:* backend-agent.
- **`Tilknytning`-enum-verdier:** `ALLE / DIREKTE / ARVET` er forslag fra fs-admin. Bekreft at backend kan implementere alle tre filtrene effektivt (særlig `ARVET`-modus krever join til opphavs-tabellen). *Eier:* backend-agent.

## Implementation Tasks

> Task-nummerering starter på #1 lokalt for iter-2. iter-1-tasks (#1–#22 i forrige plan) refereres via prefix `iter1-#N` der relevant.

### Fase A — Felt-konsum og listevisning

#### Task #1: Utvide `GET_APPLIKASJONER` + `GET_APPLIKASJON`-queries med nye felt

**Priority**: High
**Size**: S
**Dependencies**: Backend må først ha lagt til `visningsnavn`, `antallTilganger`, `kanRedigereNavn`, `kanSeEndringslogg` på `Applikasjon`-typen (cross-agent — Task # below or hand-off).
**Addresses Requirements**: BRU-APP-API-001 (Antall tilganger-kolonne), BRU-APP-API-002 (Se identitetsleverandør/organisasjon/status), BRU-APP-API-006 (kanRedigereNavn).

**Acceptance Criteria**:
- [ ] Selection set i `GET_APPLIKASJONER`-queryen (iter1-#5 levering) utvides med `visningsnavn`, `antallTilganger`.
- [ ] Selection set i `GET_APPLIKASJON`-queryen (iter1-#11 levering) utvides med `visningsnavn`, `antallTilganger`, `kanRedigereNavn`, `kanSeEndringslogg`.
- [ ] Codegen regenererer typer (`npm run compile`) uten feil.
- [ ] Alle a11y-tester for berørte komponenter passerer fortsatt.

**Implementation Notes**:
- Hvis backend ikke har feltene klare, gjøres dette mot mock-API (Task iter1-#22). Når reelt schema kommer, kjøres codegen på nytt.

---

#### Task #2: Legge til `Antall tilganger`-kolonne i `ApplikasjonerResultList`

**Priority**: High
**Size**: S
**Dependencies**: Task #1
**Addresses Requirements**: BRU-APP-API-001

**Acceptance Criteria**:
- [ ] Ny kolonne `Antall tilganger` plasseres mellom `Organisasjon` og `Status` i `ApplikasjonerResultList`.
- [ ] i18n-nøkkel `support.Applikasjoner.kolonner.antallTilganger` opprettes.
- [ ] Verdien rendres som tall (formatering: ren `Intl.NumberFormat("nb-NO")` for konsistens med andre tall-kolonner).
- [ ] `ScreenReaderPause` separasjon mellom kolonner verifisert.
- [ ] `ApplikasjonerResultList.a11y.test.tsx` oppdateres med ny kolonne i mock-data.

**Implementation Notes**:
- Se [`src/common/components/lists/NavigationList/CLAUDE.md`](../../src/common/components/lists/NavigationList/CLAUDE.md) for celletyper.

---

#### Task #3: Legge til `Miljø`-filter i `ApplikasjonerFilter`

**Priority**: High
**Size**: S
**Dependencies**: Task #1
**Addresses Requirements**: BRU-APP-API-001 (`listevisning_og_sok.feature` scenario "Filtrere på miljø")

**Acceptance Criteria**:
- [ ] Nytt `Select`-filter for `Miljø` i `ApplikasjonerFilter` med opsjoner basert på `Miljo`-enum (`DEMO`, `PROD`).
- [ ] Default-verdi: "Alle miljøer" (filteret er ikke aktivt).
- [ ] URL-state via `useGetApplikasjonerState`/`useDataListState` med nuqs.
- [ ] Filter-chip vises over result-list når aktivt; rensing fjerner chip + URL-param.
- [ ] `ApplikasjonerFilter.a11y.test.tsx` utvides.

**Implementation Notes**:
- Følg mønsteret fra eksisterende filter (`Organisasjon`, `Status`) i samme fil.

---

### Fase B — Detaljer-fanen edit-modus

#### Task #4: Konvertere `ApplikasjonInformation` til ny enkel-`Surface`-form (5-kolonners grid)

**Priority**: High
**Size**: M
**Dependencies**: Task #1
**Addresses Requirements**: BRU-APP-API-002

**Acceptance Criteria**:
- [ ] Detaljer-fanen rendres som **én** `Surface`-seksjon (ikke flere som iter-1) med felter i en 5-kolonners `Grid`.
- [ ] Lese-modus viser: rad 1 (Navn, Beskrivelse, Organisasjon, Opprettet av, Sist endret av), rad 2 (Status, Ansvarlig, Tidspunkt for opprettelse), rad 3 (Miljø, Identitetsleverandør, Tidspunkt for sist endring) — per skissen [`skisser/applikasjon-detaljevisning-aktiv-tab-detaljer-lese-modus.png`](skisser/applikasjon-detaljevisning-aktiv-tab-detaljer-lese-modus.png).
- [ ] Hver verdi rendres med `ReadOnlyTextField` eller passende lese-presentasjon (Tags for Status/Miljø).
- [ ] Visningsnavn vises (read-only) i tillegg til Navn — separat felt eller som sekundær linje under Navn (skissen viser bare "Navn", men kravet om to felter krever begge skal vises et sted; bestem konkret plassering i task-utførelse).
- [ ] Responsivt: ved smal skjerm reduseres grid til færre kolonner per `Grid`-CSS-modul.
- [ ] `ApplikasjonInformation.a11y.test.tsx` oppdateres.

**Implementation Notes**:
- Referanse-impl for lese-modus: `OpptakSettings.tsx` (men der er det fieldset i edit-modus; her er det `ReadOnlyTextField` i lese-modus).
- TopBar-info (Status, Miljø, Organisasjon, Ansvarlig, Antall tilganger, Deaktiver-knapp) ligger fortsatt **utenfor** Detaljer-fanen — i `DetailPageTopBar`. Ikke duplisere.

---

#### Task #5: Implementere edit-modus-toggle på Detaljer-fanen + `redigerApplikasjonDetaljer`-mutasjon

**Priority**: High
**Size**: L
**Dependencies**: Task #4, schema-tillegg `redigerApplikasjonDetaljer` fra backend.
**Addresses Requirements**: BRU-APP-API-005 (administrere_ansvarlig), BRU-APP-API-006 (rediger_detaljer)

**Acceptance Criteria**:
- [ ] Lokal `useState` i `ApplikasjonInformation` (eller en `ApplikasjonInformationDetails`-komponent) for `editMode: boolean`.
- [ ] Når `editMode = false`: "Rediger"-knapp synlig i Surface-seksjonshodet, kun hvis `kanRedigereNavn || kanRedigereBeskrivelse || kanAdministrereAnsvarlig`. Klikk → `editMode = true`.
- [ ] Når `editMode = true`: knappen erstattes av "Avbryt" + "Lagre". Redigerbare felter (Navn, Beskrivelse, Ansvarlig) bytter til `ViewEditTextField` / `ViewEditTextArea` / `ViewEditSelect` (Ansvarlig søkbar via `ansvarligKandidater`-query fra iter-1, gjenbruk hook fra `SettAnsvarligDialog/` som så slettes).
- [ ] Ikke-redigerbare felter (Status, Miljø, Organisasjon, Identitetsleverandør, alle "tidspunkt" og "av"-felter) forblir lese-felt i edit-modus.
- [ ] "Avbryt" tilbakestiller form-state og setter `editMode = false`.
- [ ] "Lagre" kaller `REDIGER_APPLIKASJON_DETALJER`-mutasjon. Ved suksess: `editMode = false`, Snackbar "Endringene er lagret". Ved feil: feilmelding ved riktig felt (Navn-tom = ved Navn; ansvarlig-feil = ved Ansvarlig).
- [ ] Krav-regel "ulagrede endringer forkastes ved navigasjon / fane-bytte": når komponenten unmounter (router-navigasjon eller bytte til Tilganger-/Endringslogg-fane), trigger `DetailPageTabbedContentPanel` automatisk unmount → lokal state dør → ingen ekstra logikk nødvendig. **Verifiseres manuelt** i task-utførelse: kjør gjennom flyten og bekreft.
- [ ] Validering: tomt navn-felt blokkerer Lagre-knappen + viser inline-feil "Navn er obligatorisk".
- [ ] Legacy-applikasjoner med `ansvarlig = null`: Lagre-knappen er deaktivert i ALLE save-flyter inntil ansvarlig settes; en `LayoutMessage severity="warning"` vises på toppen av detaljsiden ("Mangler ansvarlig — må settes ved neste redigering").
- [ ] `ApplikasjonInformation.a11y.test.tsx` dekker både lese- og rediger-modus.
- [ ] Slett `RedigerBeskrivelseDialog/` (iter1-#16 leveranse) og `SettAnsvarligDialog/` (iter1-#15 leveranse) — referanser oppdateres.

**Implementation Notes**:
- Referanse: `src/domains/opptak/features/OpptakManagement/OpptakSettings/OpptakSettings.tsx` + `OpptakManagementPage.tsx`.
- Hold form-state i `useState` (eller `useReducer` hvis det blir mer enn 3 felter), ikke `react-hook-form` — vi har ikke det biblioteket i prosjektet.
- Apollo-cache: returner full `Applikasjon`-payload fra mutation; cache merger automatisk via `id`.

---

### Fase C — Tilganger-fanen utvidelse

#### Task #6: Utvide `ApplikasjonTilganger` med `Arvet`-badge, `Tilknytning`-filter, fritekst- og org-filter

**Priority**: High
**Size**: L
**Dependencies**: Schema-tillegg `ApplikasjonTilgang.arvetFra`, `ApplikasjonTilgangerFilter`-utvidelser (cross-agent).
**Addresses Requirements**: BRU-APP-API-003

**Acceptance Criteria**:
- [ ] `GET_APPLIKASJON_TILGANGER`-queryen utvides med `arvetFra { tilgangskode, miljo, applikasjon { id, navn } }` per rad.
- [ ] Hver tilgang-rad rendrer en `ArvetTilgangBadge`-komponent når `arvetFra.length > 0`: en `@sikt/sds-tag` med tekst "Arvet" + `@sikt/sds-tooltip` som viser opphavs-listen ("Arvet fra: minapplikasjon (emne-les1), …").
- [ ] `ApplikasjonTilgangerFilter` utvides med:
  - **`Tilgangskode`** (`TextInput`-fritekst, contains-match) — URL-param `tilgangskode`.
  - **`Organisasjon`** (`Select`, default "Alle organisasjoner") — URL-param `organisasjonsId`.
  - **`Tilknytning`** (`Select` med 3 verdier: "Alle tilknytninger" / "Kun direkte" / "Kun arvede") — URL-param `tilknytning`, mappes til `Tilknytning`-enum.
  - Eksisterende `Miljø`-filter beholdes.
- [ ] `ApplikasjonTilgangerResultList`: kolonner = tilgangskode (med badges Demo/Prod + Arvet), beskrivelse, organisasjon.
- [ ] Multi-select-checkboxer på rader (iter1-#19) **fjernes** — fjerning skjer nå via modal (Task #7). Sjekk at ingen andre features avhenger av checkbox-modusen før fjerning.
- [ ] Sorter-dropdown forenkles til kun `Tilgangskode` (krav fjernet `miljø` som sort-alternativ).
- [ ] i18n-nøkler: `support.ApplikasjonTilganger.filter.tilknytning.alle/direkte/arvede`, `support.ApplikasjonTilganger.arvet/arvetFraOpphav`.
- [ ] `ApplikasjonTilganger.a11y.test.tsx` dekker badge + filter-kombinasjoner.

**Implementation Notes**:
- `ArvetTilgangBadge/`-komponenten er en liten wrapper; vurder å plassere den under `src/common/components/` hvis den potensielt kan gjenbrukes, ellers under `src/domains/support/features/Applikasjon/components/`.

---

#### Task #7: Erstatte `FjernTilgangerDialog` med ny bulk-modal (org+miljø-velger + multi-select)

**Priority**: High
**Size**: L
**Dependencies**: Schema-tillegg `Query.fjernbareTilganger`, `FjernApplikasjonTilgangerInput.organisasjonsId` (cross-agent). Task #6 (multi-select på rader må fjernes først).
**Addresses Requirements**: BRU-APP-API-008

**Acceptance Criteria**:
- [ ] Slett iter1-#19-implementasjonen av `FjernTilgangerDialog/` (per-rad-flyt). Rebuild ny mappe speilet på `TildelTilgangerDialog/`:
  - `FjernTilgangerButton.tsx` — knapp i top-right av Tilganger-fanen, kun synlig hvis `applikasjon.kanFjerneTilganger`.
  - `FjernTilgangerDialog.tsx` — modal med (org, miljø)-velger først, deretter multi-select-liste over fjernbare kandidater.
  - `FjernTilgangerDialog.module.css`
  - `FjernTilgangerDialog.a11y.test.tsx`
  - `fjernbareQuery.ts` — `FJERNBARE_TILGANGER`-queryen.
  - `mutation.ts` — `FJERN_APPLIKASJON_TILGANGER`-mutasjonen.
- [ ] Modal-flyt:
  1. Bruker åpner modalen → ser to selects: `Organisasjon` (begrenset til orgs hvor bruker har fjern-rettighet for denne applikasjonen — backend filtrerer) og `Miljø`.
  2. Velg org → miljø-listen oppdateres (bare miljøer der org har tilganger).
  3. Velg miljø → `useQuery(FJERNBARE_TILGANGER, { variables, skip: !org || !miljo })` kjører → liste over kandidater rendres med checkboxer.
  4. Multi-select: bruker huker av valgte rader. "Bekreft fjerning"-knapp deaktivert til minst én er valgt.
  5. Klikk "Bekreft fjerning" → `FJERN_APPLIKASJON_TILGANGER`-mutasjon → ved suksess: lukk modal, Snackbar "N tilganger fjernet", invalider/refetch `GET_APPLIKASJON_TILGANGER`-queryen.
  6. Klikk "Avbryt" eller esc → lukk uten endring.
- [ ] Lokal `useState` for valgte ID-er (ikke URL-state — modalen er midlertidig).
- [ ] Krav: "Tilganger kan fjernes selv om applikasjonen er deaktivert" — knapp/modal må fungere når `applikasjon.status === INAKTIV`. Verifiser med a11y-test/mock.
- [ ] Krav: "Arvede tilganger kan ikke fjernes direkte" — kandidatene fra backend ekskluderer arvede; UI behøver ikke filtrere. Defense-in-depth: hvis backend returnerer en `ArvetTilgangIkkeFjernbar`-feil, vis den ved relevant rad.
- [ ] i18n-nøkler: `support.ApplikasjonFjernTilgangerDialog.{tittel,velgOrg,velgMiljo,velgTilganger,bekreft,avbryt,ingenKandidater}`.

**Implementation Notes**:
- Kopier filstruktur fra `src/domains/support/features/Applikasjon/components/TildelTilgangerDialog/` og tilpass mutation + tekst.

---

#### Task #8: Verifiser/refactor `TildelTilgangerDialog` til iter-2-kontrakt

**Priority**: Medium
**Size**: S
**Dependencies**: Ingen (schemaet har allerede iter-2-form).
**Addresses Requirements**: BRU-APP-API-007

**Acceptance Criteria**:
- [ ] Verifiser at `tildelbareQuery.ts` passerer `(applikasjonsId, organisasjonsId, miljo)` til `Query.tildelbareTilganger`.
- [ ] Verifiser at `mutation.ts` passerer `(applikasjonsId, organisasjonsId, miljo, tilgangskoder)` til `Mutation.tildelApplikasjonTilganger`.
- [ ] Hvis enten query eller mutation mangler `organisasjonsId`: legg det til, oppdater UI-flyten slik at bruker velger organisasjon før miljø (samme rekkefølge som `FjernTilgangerDialog` for konsistens).
- [ ] Krav: "Tilganger kan tildeles selv om applikasjonen er deaktivert" — verifiser via test.
- [ ] `TildelTilgangerDialog.a11y.test.tsx` oppdateres hvis flyten endres.

---

### Fase D — Endringslogg-fanen (Iter 4)

#### Task #9: Implementere `ApplikasjonEndringslogg`-fane som tredje `DetailPageTabbedContentPanel`

**Priority**: Medium
**Size**: M
**Dependencies**: Schema-tillegg `Applikasjon.endringslogg`, `Applikasjon.kanSeEndringslogg` (cross-agent). Task #1 (kanSeEndringslogg i selection set).
**Addresses Requirements**: BRU-APP-API-016 (K16)

**Acceptance Criteria**:
- [ ] Ny mappe `src/domains/support/features/Applikasjon/features/ApplikasjonEndringslogg/`:
  - `ApplikasjonEndringslogg.tsx` (host).
  - `query.ts` (`GET_APPLIKASJON_ENDRINGSLOGG`).
  - `components/ApplikasjonEndringsloggItem/ApplikasjonEndringsloggItem.tsx` (rad-presentasjon: tidspunkt, utfortAv, handlingstype, beskrivelse).
  - `ApplikasjonEndringslogg.a11y.test.tsx`.
  - `ApplikasjonEndringslogg.module.css`.
- [ ] Tredje fane "Endringslogg" lagt til i `Applikasjon.tsx` (detaljside-host):
  ```tsx
  <DetailPageTabbedContentPanel id="endringslogg" label={t("endringsloggLabel")} icon={<ClockIcon aria-hidden />}>
    <ApplikasjonEndringslogg applikasjonId={id} />
  </DetailPageTabbedContentPanel>
  ```
- [ ] Fanen er **gated på `applikasjon.kanSeEndringslogg`** — hvis false, render ikke panelet (bare to faner).
- [ ] Bruk `Surface`-card som container med `ApplikasjonEndringsloggItem`-rader.
- [ ] "Last inn flere" (50 ad gangen) via `fetchMore`, mønster fra `AuditLogCard.tsx`.
- [ ] Tom-tilstand: "Ingen endringer registrert".
- [ ] Loading-skeleton vises ved første hent.
- [ ] i18n-nøkler: `support.ApplikasjonEndringslogg.{tittel,tomTilstand,lastInnFlere,handlingstype,utfortAv,tidspunkt}`.

**Implementation Notes**:
- Referanse: [`src/domains/soknadsbehandling/features/AuditLogCard/AuditLogCard.tsx`](../../src/domains/soknadsbehandling/features/AuditLogCard/AuditLogCard.tsx) og [`AuditLogItem/AuditLogItem.tsx`](../../src/domains/soknadsbehandling/features/AuditLogCard/AuditLogItem/AuditLogItem.tsx).
- `INITIAL_ENTRIES = 50`, `ENTRIES_PER_PAGE = 50` (avvik fra referansen som har 3/10 — applikasjon-endringslogg antas å være rikere).
- Placeholder-data-shape (Q6): bruk `handlingstype` som `String!` — når backend forfiner til enum, oppdateres komponenten.

---

### Fase E — Opprett-flyt (iter-3-task fra iter-1, oppdatering)

#### Task #10: Utvide `OpprettApplikasjonDialog` med navn- og ansvarlig-felter

**Priority**: High
**Size**: M
**Dependencies**: Schema-tillegg `OpprettApplikasjonInput.navn`, `ansvarligId`, `ansvarligType` (cross-agent).
**Addresses Requirements**: BRU-APP-API-009

**Acceptance Criteria**:
- [ ] `OpprettApplikasjonDialog` (iter1-#17 leveranse) får to nye felter mellom Identitetsleverandør og Opprett-knappen:
  - **Navn** — `TextInput`, obligatorisk. Inline-feilmelding "Navn er obligatorisk" ved tom.
  - **Ansvarlig** — `Select`/`Combobox` med søk via `ansvarligKandidater(organisasjonsId)`-queryen (iter1-#15 levering, gjenbrukes). Begrenset til valgt organisasjons feide-brukere/-grupper. Obligatorisk.
- [ ] Mutation `OPPRETT_APPLIKASJON` får utvidet input med `navn`, `ansvarligId`, `ansvarligType`.
- [ ] Ved suksess: navigerer fortsatt til detaljsiden + Snackbar.
- [ ] Test: tom navn ELLER tom ansvarlig blokkerer Opprett-knappen.
- [ ] `OpprettApplikasjonDialog.a11y.test.tsx` dekker validering av begge nye felter.
- [ ] i18n-nøkler: `support.OpprettApplikasjon.{navnLabel,navnObligatorisk,ansvarligLabel,ansvarligObligatorisk}`.

**Implementation Notes**:
- Backend defaulter `navn = visningsnavn` post-idP-verifisering (per åpent spørsmål 3 over) — men UI-en sender alltid det brukeren har skrevet inn. Hvis backend overstyrer ved tom: ikke UI-ens problem.

---

### Fase F — Sletting av deprecated kode

#### Task #11: Slette ubrukte iter-1 dialog-komponenter

**Priority**: Low
**Size**: S
**Dependencies**: Task #5 (ny edit-flow ferdig), Task #7 (ny FjernTilgangerDialog ferdig).
**Addresses Requirements**: ikke direkte; oppryddings-arbeid.

**Acceptance Criteria**:
- [ ] Slett `src/domains/support/features/Applikasjon/components/RedigerBeskrivelseDialog/` (iter1-#16).
- [ ] Slett `src/domains/support/features/Applikasjon/components/SettAnsvarligDialog/` (iter1-#15). MERK: hvis Task #5 ikke har klart å gjenbruke `ansvarligKandidater`-queryen direkte derfra, må den queryen flyttes til en delt fil før dialogen slettes — `src/domains/support/features/Applikasjon/queries/ansvarligKandidater.ts` foreslås.
- [ ] Slett iter-1-versjonen av `FjernTilgangerDialog/` (iter1-#19) — gjort som del av Task #7, sjekk at intet henger igjen.
- [ ] Søk i kodebasen etter ubrukte imports og knip-kjøring (`npm run unusedcheck`) for verifisering.
- [ ] i18n-nøkler for de slettede dialogene fjernes fra `src/common/messages/nb/support.json`.

**Implementation Notes**:
- Sjekk at iter1-completion-filer (iter1-#15, iter1-#16, iter1-#19) ikke har "open follow-ups" som blokkerer sletting.

---

### Fase G — Schema- og backend-koordinering

#### Task #12: Backend-hand-off — iter-2 schema-tillegg

**Priority**: Critical (blokkerer Fase A–E)
**Size**: N/A (hand-off, ikke kode-task)
**Dependencies**: Ingen
**Addresses Requirements**: All iter-2 features

**Acceptance Criteria**:
- [ ] Cross-agent-issue åpnet i `sikt-no/fs` mot backend-agenten med lenke til `agents/fs-admin/2026-05-27-applikasjon-tilgangsstyring/plan.md`.
- [ ] Hand-off-issuet refererer eksplisitt til `## GraphQL-endringer`-seksjonen og lister alle 8 operasjoner (A–H).
- [ ] Backend bekrefter mottak og estimerer leveringstidspunkt for hver operasjon.
- [ ] Iterasjonsplan justeres hvis backend ikke kan levere alle samtidig — Fase A–D kan delvis frigjøres bak mock-API (iter1-#22).

**Implementation Notes**:
- Filer via `agent-coord` etter at planen er publisert til coord-repo.

---

## Risk Assessment

### Technical Risks

- **Risk:** `DetailPageTabbedContentPanel` re-monter ikke nødvendigvis ved fane-bytte; lokal `useState` for `editMode` overlever.
  - **Mitigation:** Verifiser oppførselen ved å sjekke implementasjonen av `DetailPageTabbedContent` mot `nuqs`-state — hvis state vedvarer, må vi eksplisitt `cancel()` editMode på `useEffect`-rensing. Task #5 inkluderer manuell verifisering.
- **Risk:** Apollo-cache merger ikke `redigerApplikasjonDetaljer`-payload-en med eksisterende `Applikasjon`-cache slik forventet (f.eks. hvis returtype mangler `__typename` eller `id`).
  - **Mitigation:** Mutasjons-payload må alltid returnere `applikasjon { id ... }`; backend skal følge dette mønsteret. Skriv en Apollo-cache-integrasjonstest i Task #5.
- **Risk:** `Antall tilganger`-tall kan komme out-of-sync etter en bulk-fjern (`fjernApplikasjonTilganger`-payload må returnere oppdatert `applikasjon.antallTilganger`).
  - **Mitigation:** Task #7-mutation-payload inkluderer `applikasjon { id antallTilganger }`. Apollo merger automatisk.
- **Risk:** Schema-utvidelser fra backend forsinkes; iter-2-utvikling blokkeres.
  - **Mitigation:** Mock-API-laget (iter1-#22) kan utvides til å returnere iter-2-formen. Task #12 (backend hand-off) eskaleres tidlig.

### Open Questions Still Hanging Over The Plan

Iter-1 åpne spørsmål gjelder fortsatt og er ikke gjentatt her (se [iter-1-plan §Open Questions Still Hanging Over The Plan](../ACTIVE-ITERATION-2/plan-applikasjon-tilgangsstyring.md)):
- POC-rydde-PR-timing
- `NyTilgangButton`-skjebne
- USER_ACTION-enum-utvidelse-vs-Unleash-gating
- Backend-agentens reelle aktivitet

Nye åpne spørsmål reist av iter-2-deltaen:
- 4 schema-eier-spørsmål (se `## GraphQL-endringer §Åpne spørsmål til schema-eier`)
- **GitHub-struktur:** #453 (endringslogg) har fortsatt `parent = #437` (Nice to have) — `bat-krav` må flytte den til et nytt iter-4-paraply-issue. Ikke en blokker for utvikling, men en før-deploy-konsistens-sjekk.
- **`Tilknytning`-filter-scenarier:** krav-fila har "skjul/vis arvede"-toggle, ikke `Tilknytning`-select. Krav-eier må synkronisere skissen og krav-fila.

### Testing Requirements

- Unit-tester for nye komponenter: ikke obligatorisk (per CLAUDE.md), men anbefalt for `FjernTilgangerDialog` (modal-flyt) og edit-modus i `ApplikasjonInformation` (state-overganger).
- A11y-tester (`ComponentName.a11y.test.tsx`): obligatorisk for hver ny komponent, oppdatert for hver endret komponent.
- Manuell test: krav-regel om at fane-bytte forkaster ulagrede endringer (Task #5 acceptance).
- Manuell test: legacy-applikasjon med `ansvarlig = null` blokkerer Lagre, viser warning (Task #5 acceptance).
- Manuell test: bulk-fjern fungerer mens applikasjon er INAKTIV (Task #7 acceptance).

## Success Criteria

- [ ] Alle 12 iter-2-tasks ferdigstilt.
- [ ] `npm run lint` + `npm run test:typecheck` + `npm run test:a11y` passerer på branch.
- [ ] Krav fra `01 Iterasjon 2/*.feature` og `02 Iterasjon 3/*.feature` (iter-2-versjonene) er manuelt verifisert.
- [ ] `03 Iterasjon 4/endringslogg.feature` rettighets-scenariene (1, 2, 3) er manuelt verifisert; `@openquestion`-scenarier (4, 5, 6, 7) er ikke i scope.
- [ ] iter-1 `RedigerBeskrivelseDialog`, `SettAnsvarligDialog`, gamle `FjernTilgangerDialog` er slettet.
- [ ] Apollo-cache opdaterer atomisk ved `redigerApplikasjonDetaljer` (no stale data observed manually).
- [ ] Mock-API gir riktige iter-2-typer (hvis backend-schema ikke er klart, fallback dekker test-bruk).
- [ ] Cross-agent-issue mot backend åpnet (Task #12) og status synlig i agents-readme.

## Requirements Traceability

| Krav (Feature-ID) | Krav-fil                              | Iter | Tasks               | Status   |
| ----------------- | ------------------------------------- | ---- | ------------------- | -------- |
| BRU-APP-API-001   | `listevisning_og_sok.feature`         | 2    | #1, #2, #3          | Planned  |
| BRU-APP-API-002   | `se_detaljer.feature`                 | 2    | #1, #4              | Planned  |
| BRU-APP-API-003   | `vise_tilganger.feature`              | 2    | #6                  | Planned  |
| BRU-APP-API-005   | `administrere_ansvarlig.feature`      | 2    | #5                  | Planned  |
| BRU-APP-API-006   | `rediger_detaljer.feature`            | 2    | #5                  | Planned  |
| BRU-APP-API-007   | `tildele_tilgang.feature`             | 3    | #8                  | Planned  |
| BRU-APP-API-008   | `fjerne_tilgang.feature`              | 3    | #7                  | Planned  |
| BRU-APP-API-009   | `opprette_applikasjon.feature`        | 3    | #10                 | Planned  |
| BRU-APP-API-016   | `endringslogg.feature`                | 4    | #9                  | Planned  |
| _(støtte-task)_   | Schema-hand-off                       | —    | #12                 | Planned  |
| _(oppryddings)_   | Slette ubrukte iter-1-dialoger        | —    | #11                 | Planned  |
| BRU-APP-API-004   | `passordbytte.feature`                | 2    | iter1-#14 (ferdig)  | Inherited|
| BRU-APP-API-010   | `deaktivere_applikasjon.feature`      | 3    | iter1-#20 (ferdig)  | Inherited|

## Cross-Agent Hand-offs (candidates — NOT filed from this plan)

Konkrete kandidater identifisert ved planlegging:

1. **Backend / SuperGraf-schema-agent** (`sikt-no/fs` agents/backend/ — kanskje sammen med en utvidet "Applikasjon-schema-eier").
   - **Hva trengs:** 8 schema-operasjoner spesifisert i `## GraphQL-endringer §Operasjon A–H` over.
   - **Hvorfor blokkerer:** Fase A–D av denne planen avhenger av at backend leverer/utvider de nevnte typene og mutasjonene. Mock-API (iter1-#22) kan ta noe av trykket, men eksperimentell prod-kontrakt må stamme fra backend.
   - **Følger med i hand-off-issuet:** lenke til hele feature-mappa `agents/fs-admin/2026-05-27-applikasjon-tilgangsstyring/`.

2. **Krav-eier / `bat-krav`-bruker** — to follow-ups som ikke blokkerer utvikling:
   - Flytte #453 (endringslogg) fra parent #437 til et nytt iter-4-paraply-issue, så GitHub-strukturen stemmer med krav-mappens "03 Iterasjon 4".
   - Justere `vise_tilganger.feature` slik at scenariene refererer til `Tilknytning`-filter i stedet for "skjul arvede"-toggle.

3. **Identitets-/Feide-/Maskinporten-koblings-eier** (uendret fra iter-1) — `navn`-defaulting post-idP-verifisering (åpent spørsmål 3).

Disse er **kandidater**. Brukeren bekrefter hvilke som skal files som hand-off-issues før `agent-coord` invoke'es.

