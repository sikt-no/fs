# Plan: Utdanningsbakgrunner med avvikende frister på opptak (frontend)

- **Jira:** [TAKE-384](https://sikt.atlassian.net/browse/TAKE-384) (frontend-delsak av [TAKE-381](https://sikt.atlassian.net/browse/TAKE-381))
- **Bygger på:** [`analysis-utdanningsbakgrunner.md`](analysis-utdanningsbakgrunner.md), med beslutning 1–8 fra 2026-10-09
- **Repo / rolle:** fs-admin / frontend
- **Dato:** 2026-10-09

## Proposed Solution

### Architecture Approach

Opptaksskjemaet (`OpptakManagementPage`, brukt både på `/opptak/opprett/[type]` og `/opptak/[id]/rediger`) får to nye deler:

1. **Chip-listen «Godkjente utdanningsbakgrunner»** i `OpptakSettings`. Den er en `FSCombobox` med `multiple` og `wrap`, og bestemmer hvilke bakgrunner søkere kan velge i opptaket. Feltet er påkrevd, med minst én bakgrunn (beslutning 4).
2. **Seksjon 05 «Utdanningsbakgrunner med avvikende frister»**, en ny komponent under den generelle fristseksjonen. «Legg til ny utdanningsbakgrunn» velger fra **hele** tabellen over typer, uavhengig av chipsene (beslutning 2). Hvert kort har to valgfrie datofelt, «Søknadsfrist» og «Frist dokumentasjon» (beslutning 7), og en «Fjern»-knapp som bare fjerner avviket (beslutning 3).

Siden har allerede en egen tilstand for samordnede organisasjoner (`samordnaOrgs`), og utdanningsbakgrunnene får det samme: en egen tilstand i `OpptakManagementPage`. Den fylles fra `Opptak.utdanningsbakgrunner` når et eksisterende opptak lastes. Ved lagring gjøres den om til `OpptakUtdanningsbakgrunnInput[]` av rene hjelpefunksjoner. Alt sendes i den eksisterende `opprettOpptakV3`/`oppdaterOpptak`, i samme lagring som resten av skjemaet (beslutning 6).

**Midlertidig sperre for «kort uten chip».** Et kort for en bakgrunn som ikke er valgt i chip-listen, kan ikke lagres riktig før backend har et flagg for det (se GraphQL Op #5). Til da viser kortet en melding om at bakgrunnen må legges til i listen over, og «Lagre» er sperret (beslutning fra bat-plan 2026-10-09). Når flagget finnes, gjør Task #8 sperren om til ren infotekst.

### Key Technical Decisions

1. **Decision:** Egen skjematilstand for utdanningsbakgrunner, `UtdanningsbakgrunnerSkjema`, i `OpptakManagementPage`. Den er ikke en del av `OpptakFormState`.
   - **Why:** Chips og kort er to uavhengige utvalg som backend lagrer i én liste. En egen modell (`valgteTypeIder` + `avvik[]` + `eksisterende` per type-id) gjør det mulig å se «kort uten chip» og å bevare `beskrivelse`/`utloserTidligFrist` på eksisterende rader. Samme mønster som `samordnaOrgs` på siden.
   - **Alternative considered:** Bruke `opptak.utdanningsbakgrunner` direkte fra den utledede `OpptakFormState`. Forkastet, fordi formen fra backend (én liste) ikke kan uttrykke «kort uten chip», og fordi to UI-er da må redigere samme array.

2. **Decision:** Fristkodene ligger i én konstant, `AVVIKENDE_FRIST_KODER = { soknadsfrist: OpptakshendelsestypeKode.SoknadsfristOrdinaer, dokumentasjonsfrist: OpptakshendelsestypeKode.FristOrdinaerOpplasting }`, i `utils/utdanningsbakgrunnUtils.ts`.
   - **Why:** Beslutning 1 er ikke bekreftet av backend ennå. Et annet svar blir da en endring på én linje. `HendelseInput` bruker ASCII-enumen, både ved lesing og skriving, så `normalizeKode` trengs ikke.
   - **Alternative considered:** Hente kodene fra `GET_OPPTAKHENDELSETYPER` per kategori. Forkastet, fordi det ikke finnes noen kategori for bakgrunnsfrister.

3. **Decision:** `OpptakDeadlineInput` får valgfrie props: `label`, `helpText`, `isRequired` (standard `true`) og `validityKey` (standard `hendelse.type.kode`). Uten `isRequired` kan feltet tømmes.
   - **Why:** Logikken for ufullstendig dato gjenbrukes, og eksisterende kall endres ikke. `validityKey` hindrer at kort med samme fristkode overskriver hverandres gyldighet i `ugyldigeHendelseKoder` (analysens Key Findings). Komponenten ligger i `src/domains/opptak/`, så endringen holder seg innenfor domenet.
   - **Alternative considered:** Bruke `InputDatepicker` direkte i det nye kortet. Forkastet, fordi det dupliserer håndteringen av ufullstendig dato og blur-logikken.

4. **Decision:** «Legg til ny utdanningsbakgrunn» åpner en `PopoverMenu` med én knapp per type som ikke allerede har kort. Presedens: `PersonaliaCardAddTag`.
   - **Why:** Lettvekts, tilgjengelig for tastatur, og listen er kort (rundt 10 typer). Figma viser bare knappen, ikke hva som skjer ved klikk.
   - **Alternative considered:** `FSModal` med en select. Forkastet, fordi det er tyngre enn nødvendig for ett valg. Interaksjonen står på designsjekklisten i analysen.

5. **Decision:** `OppdaterOpptak` velger `opptak { id utdanningsbakgrunner { … } }` i svaret.
   - **Why:** `GET_OPPTAK_FROM_ID` bruker cache-first. Uten feltene i svaret viser en ny åpning av `/rediger` gamle bakgrunner fra cachen.
   - **Alternative considered:** `refetchQueries: refetchQueryNames('GetOpptakFromId')`. Det er et ekstra kall, og det trengs ikke når normalisert cache oppdateres fra svaret.

6. **Decision:** Gridet med kort bruker en fast streng i `gridTemplateColumns` (`'repeat(auto-fit, minmax(300px, 1fr))'`), ikke et responsivt objekt.
   - **Why:** Et responsivt objekt går via `useBreakpoints` og kan gi avvik mellom server- og klientrendering. En `auto-fit`-streng er responsiv uten JS.

### File Changes Overview

Alt ligger under `src/domains/opptak/`, med unntak av oversettelser og changeset.

- `features/OpptakManagement/queries.ts`: `GET_OPPTAK_FROM_ID` får `utdanningsbakgrunner` (Op #1), og `OPPDATER_OPPTAK` velger `utdanningsbakgrunner` i svaret (Op #4).
- `features/OpptakManagement/types.ts`: ny type `UtdanningsbakgrunnerSkjema`, og avledet type `OpptakUtdanningsbakgrunnData`.
- `features/OpptakManagement/utils/emptyObjectGenerators.ts`: `utdanningsbakgrunner: []` i `emptyOpptakData()`, og ny `emptyUtdanningsbakgrunnerSkjema()`.
- `features/OpptakManagement/utils/convertDataToInput.tsx`: tar imot `UtdanningsbakgrunnerSkjema` og sender `utdanningsbakgrunner` ved både opprettelse og oppdatering.
- `features/OpptakManagement/OpptakSettings/OpptakSettings.tsx`: chip-listen, og `opptakUtdanningsbakgrunnstyper` i den eksisterende `GET_OPPTAKSTYPER_REGELVERKSAMLINGER` (Op #2).
- `features/OpptakManagement/OpptakManagementPage.tsx`: ny tilstand, utfylling fra eksisterende opptak, ny seksjon, nye regler i `saveDisabled`, og ny input i konverteringen.
- `components/OpptakDeadlineInputs/OpptakDeadlineInput.tsx`: valgfrie props (Key Decision 3).
- `src/common/messages/nb/opptak.json` (det finnes bare `nb`): nye nøkler under `OpptakSettings` og `UtdanningsbakgrunnerAvvikendeFrister`.
- `.changeset/<navn>.md`: changeset for opptak.

**Nye filer:**
- `features/OpptakManagement/utils/utdanningsbakgrunnUtils.ts` og `utdanningsbakgrunnUtils.test.ts`: `fraOpptak()`, `tilInput()`, `kortUtenChip()` og `AVVIKENDE_FRIST_KODER`.
- `features/OpptakManagement/UtdanningsbakgrunnerAvvikendeFrister/UtdanningsbakgrunnerAvvikendeFrister.tsx`, samt `.test.tsx` og `.a11y.test.tsx`: seksjon 05 med egen query (Op #3).
- `features/OpptakManagement/UtdanningsbakgrunnerAvvikendeFrister/components/AvvikendeFristKort/AvvikendeFristKort.tsx`, samt `.test.tsx` og `.a11y.test.tsx`: ett kort.

## GraphQL-endringer

> **Premiss:** konservativ. API-et dekker alt frontend trenger nå. Eneste forslag til backend er ett nytt felt (Op #5).
> **Domeneterm:** `utdanningsbakgrunn` / `OpptakUtdanningsbakgrunn` (som i schemaet), og «avvikende frist» om fristene per bakgrunn (som i kravet `@OPT-OVO-FRI-001`).
> **Følger fra:** [`analysis-utdanningsbakgrunner.md`](analysis-utdanningsbakgrunner.md), under Key Findings, Dependencies → Backend og beslutning 1–8.

### Sammendrag

- 1 ny query (Op #3), 2 utvidede queries (Op #1, Op #2)
- 0 nye mutasjoner. 2 eksisterende får ny input-mapping (Op #4), og `OppdaterOpptak` velger flere felt i svaret.
- 1 forslag til backend: nytt felt `erValgbarForSoker` (Op #5)
- 2 åpne spørsmål (se nederst)

### Operasjoner

#### Op #1: `GetOpptakFromId` — hent opptakets utdanningsbakgrunner med frister

**Dekker krav:** `@OPT-OVO-INN-001` Regel «Opptaksforvalter kan legge til utdanningsbakgrunner som gjelder for opptaket», og `@OPT-OVO-FRI-001` Regel «Opptaksforvalter kan legge til utdanningsbakgrunner med avvikende frister», ved redigering.
**Implementeres av:** Task #1

##### Lag A — Schema-tillegg

Ingen. `Opptak.utdanningsbakgrunner: [OpptakUtdanningsbakgrunn!]` finnes i det eksperimentelle schemaet.

##### Lag B — fs-admin call-site

```ts
// src/domains/opptak/features/OpptakManagement/queries.ts — utvidelse av eksisterende operasjon
export const GET_OPPTAK_FROM_ID = gql(/* GraphQL */ `
  query GetOpptakFromId($opptakId: ID!) {
    opptak(filter: { opptaksIDer: [$opptakId] }) {
      id
      # … eksisterende felt uendret …
      utdanningsbakgrunner {
        id
        beskrivelse
        utloserTidligFrist
        type {
          id
          kode
          navn
        }
        hendelser {
          id
          hendelseTidspunkt
          type {
            id
            kode
          }
        }
      }
    }
  }
`)
```

```ts
// Skisse — IKKE for build. OpptakManagementPage, i den eksisterende utfyllings-useEffecten
setUtdanningsbakgrunner(fraOpptak(currentOpptak.utdanningsbakgrunner ?? []))
```

##### Lag C — Begrunnelse

- **Form:** `type.navn` brukes som overskrift på kortet og som etikett på chipen. `hendelser.type.kode` (ASCII-enumen `OpptakshendelsestypeKode`) styrer hvilket felt i kortet datoen hører til. `hendelser.type.navn` hentes ikke, fordi etikettene kommer fra i18n. `id` hentes på alle typer som implementerer `Node`, for normalisering i cachen, per `fs-sikt-no-producer-schema-design §Vi følger Global Object Identification-spesifikasjonen`.
- **Colocation-status:** Ikke best practice. Det speiler det eksisterende, ikke-kolokerte mønsteret i `OpptakManagement`, der `OpptakFormState` utledes fra hele `GetOpptakFromId`. Det er akseptert fordi dataene eies av siden og brukes av tre deler (`OpptakSettings`, seksjon 05 og `convertDataToInput`). Et kolokert fragment med `@unmask` ville ikke gitt lokal resonnering her. Colocation for skjemaet er en egen refaktorering (`graphql-golden-path-fragment-colocation §Implementation notes`).
- **Konvensjoner sitert:** Ingen paginering, fordi listen er per opptak og liten (under 10 typer), per `fs-sikt-no-producer-best-practice §Paginering` («svært god kontroll på at antallet elementer … er lavt»).
- **Alternativer vurdert:** En egen query for utdanningsbakgrunner på opptaket. Forkastet, fordi den ville gitt en ekstra runde og to queries som ventes på hver for seg på samme side.

#### Op #2: `GetOpptakstyper` — typer for chip-listen i Innstillinger

**Dekker krav:** `@OPT-OVO-INN-001`, scenariene «Legge til utdanningsbakgrunner fra godkjent liste» og «Legge til flere utdanningsbakgrunner».
**Implementeres av:** Task #3

##### Lag A — Schema-tillegg

Ingen. `Query.opptakUtdanningsbakgrunnstyper: [OpptakUtdanningsbakgrunnstype!]` finnes.

##### Lag B — fs-admin call-site

```ts
// src/domains/opptak/features/OpptakManagement/OpptakSettings/OpptakSettings.tsx — utvidelse
export const GET_OPPTAKSTYPER_REGELVERKSAMLINGER = gql(/* GraphQL */ `
  query GetOpptakstyper($organisasjonIds: [ID!]!) {
    opptakstyper { … }               # uendret
    regelverksamlingerV2(…) { … }    # uendret
    opptakUtdanningsbakgrunnstyper {
      id
      kode
      navn
      kanVelgesAvSoker
    }
  }
`)
```

```ts
// Skisse — IKKE for build
const utdanningsbakgrunnOptions = (data?.opptakUtdanningsbakgrunnstyper ?? [])
  .filter((type) => type.kanVelgesAvSoker)
  .map((type) => ({ value: type.id, label: type.navn }))
```

##### Lag C — Begrunnelse

- **Form:** `kanVelgesAvSoker` hentes for å filtrere bort typer backend avviser (f.eks. DISP). Det følger av schema-beskrivelsen av `opptakUtdanningsbakgrunnstyper`.
- **Colocation-status:** Ikke best practice. Det speiler det eksisterende mønsteret, der `OpptakSettings` samler kodelistene sine i én query. Akseptert fordi det er et lite tillegg i en eksisterende query som eies av samme komponent. CLAUDE.md («queries close to the component») er oppfylt.
- **Konvensjoner sitert:** Ingen paginering for en liten og avgrenset kodeliste, per `fs-sikt-no-producer-best-practice §Paginering`.

#### Op #3: `GetUtdanningsbakgrunnstyperForAvvik` — typer for «Legg til ny utdanningsbakgrunn» i seksjon 05

**Dekker krav:** `@OPT-OVO-FRI-001`, scenariet «Legge til utdanningsbakgrunn med avvikende frister».
**Implementeres av:** Task #5

##### Lag A — Schema-tillegg

Ingen.

##### Lag B — fs-admin call-site

```ts
// src/domains/opptak/features/OpptakManagement/UtdanningsbakgrunnerAvvikendeFrister/UtdanningsbakgrunnerAvvikendeFrister.tsx
export const GET_UTDANNINGSBAKGRUNNSTYPER_FOR_AVVIK = gql(/* GraphQL */ `
  query GetUtdanningsbakgrunnstyperForAvvik {
    opptakUtdanningsbakgrunnstyper {
      id
      navn
      kanVelgesAvSoker
    }
  }
`)
```

```ts
// Skisse — IKKE for build
const { data, loading, error } = useQuery(GET_UTDANNINGSBAKGRUNNSTYPER_FOR_AVVIK)
const tilgjengelige = (data?.opptakUtdanningsbakgrunnstyper ?? []).filter(
  (type) => type.kanVelgesAvSoker && !avvik.some((a) => a.typeId === type.id),
)
```

##### Lag C — Begrunnelse

- **Form:** Egen operasjon i komponenten som bruker dataene, i stedet for å gjenbruke Op #2, per CLAUDE.md («Do NOT reuse queries between different components»). Feltet er det samme, så Apollo leverer svaret fra den normaliserte cachen uten et nytt kall når Op #2 allerede er lastet.
- **Colocation-status:** Følger colocation. Operasjonen ligger i komponenten som bruker hvert felt den henter, per `graphql-golden-path-query-componentization §Why this should be default`.
- **Alternativer vurdert:** Sende typelisten som prop fra `OpptakSettings` via siden. Forkastet, fordi det kobler to søskenkomponenter gjennom siden (prop drilling).

#### Op #4: `CreateOpptak` / `OppdaterOpptak` — send `utdanningsbakgrunner`

**Dekker krav:** `@OPT-OVO-INN-001` (alle tre scenariene) og `@OPT-OVO-FRI-001` «Legge til utdanningsbakgrunn med avvikende frister».
**Implementeres av:** Task #2 (mapping) og Task #6 (kobling og svar)

##### Lag A — Schema-tillegg

Ingen. `OpprettOpptakV3Input.utdanningsbakgrunner` og `OppdaterOpptakInput.utdanningsbakgrunner: [OpptakUtdanningsbakgrunnInput!]` finnes, og det gjør `HendelseInput` også.

##### Lag B — fs-admin call-site

```ts
// src/domains/opptak/features/OpptakManagement/queries.ts — bare svaret på OPPDATER_OPPTAK utvides
export const OPPDATER_OPPTAK = gql(/* GraphQL */ `
  mutation OppdaterOpptak($input: OppdaterOpptakInput!) {
    oppdaterOpptak(input: $input) {
      errors {
        ... on Error {
          message
        }
      }
      opptak {
        id
        utdanningsbakgrunner {
          id
          beskrivelse
          utloserTidligFrist
          type {
            id
            kode
            navn
          }
          hendelser {
            id
            hendelseTidspunkt
            type {
              id
              kode
            }
          }
        }
      }
    }
  }
`)
```

```ts
// Skisse — IKKE for build. utils/utdanningsbakgrunnUtils.ts
export const tilInput = (
  skjema: UtdanningsbakgrunnerSkjema,
  typer: { id: string; navn: string }[],
): OpptakUtdanningsbakgrunnInput[] =>
  skjema.valgteTypeIder.map((typeId) => {
    const avvik = skjema.avvik.find((a) => a.typeId === typeId)
    const eksisterende = skjema.eksisterende[typeId]
    return {
      utdanningsbakgrunnTypeId: typeId,
      beskrivelse: eksisterende?.beskrivelse ?? typer.find((t) => t.id === typeId)?.navn ?? '',
      utloserTidligFrist: eksisterende?.utloserTidligFrist ?? false,
      hendelser: [
        avvik?.soknadsfrist && {
          opptakshendelsestypeKode: AVVIKENDE_FRIST_KODER.soknadsfrist,
          hendelseTidspunkt: formatToUTC(avvik.soknadsfrist),
        },
        avvik?.dokumentasjonsfrist && {
          opptakshendelsestypeKode: AVVIKENDE_FRIST_KODER.dokumentasjonsfrist,
          hendelseTidspunkt: formatToUTC(avvik.dokumentasjonsfrist),
        },
      ].filter(Boolean),
    }
  })
// Kort uten chip kommer aldri med her. Lagring sperres så lenge slike kort finnes (Task #6),
// og når backend-flagget kommer, sendes de med erValgbarForSoker: false (Task #8).
```

##### Lag C — Begrunnelse

- **Form:**
  - Listen sendes **alltid**. En tom liste er umulig, fordi `saveDisabled` krever minst én valgt bakgrunn (beslutning 4).
  - `hendelser` sendes alltid eksplisitt, også som `[]`. Ved oppdatering betyr en utelatt liste «urørt», mens kortene er fasiten for avvikene. «Fjern» skal derfor gi `[]` (beslutning 3).
  - `beskrivelse` og `utloserTidligFrist` bevares for eksisterende rader og utledes for nye (beslutning 5).
- **Colocation-status:** Ikke best practice. Det speiler det eksisterende mønsteret, med flate mutasjonsdokumenter i `queries.ts`. Akseptert fordi bare svaret utvides, for å holde cachen oppdatert.
- **Konvensjoner sitert:** Endringer bare via toppnivåfelt på `Mutation`, som de eksisterende `opprettOpptakV3`/`oppdaterOpptak`, per `fs-sikt-no-producer-best-practice §Bare felt på Mutation-typen kan utføre endringer`. Feilhåndteringen bruker den eksisterende unionen `OppdaterOpptakError` via `useGetMutationErrors`.
- **Alternativer vurdert:** `settUtdanningsbakgrunnHendelser` per bakgrunn. Forkastet i beslutning 6, fordi den trenger en bakgrunns-id før første lagring og gir flere transaksjoner.

#### Op #5 (forslag til backend): `erValgbarForSoker` på `OpptakUtdanningsbakgrunn`

**Dekker krav:** `@OPT-OVO-FRI-001` «Legge til utdanningsbakgrunn med avvikende frister», sammen med beslutning 2 (seksjon 05 velger fra hele tabellen, uavhengig av chipsene).
**Implementeres av:** backend (TAKE-383-oppfølging, Tuva Hassel Stang). Frontend-delen er Task #8.

##### Lag A — Schema-tillegg

```graphql
extend type OpptakUtdanningsbakgrunn {
  """
  Om søkere kan velge utdanningsbakgrunnen i opptaket. `false` betyr at bakgrunnen bare
  er registrert for å bære avvikende frister, og at den ikke tilbys søkere. Søkerflaten
  (`megSomSoker`/`utdanningsbakgrunner`) og saksbehandlerens valg skal filtrere bort
  bakgrunner med `false`.
  """
  erValgbarForSoker: Boolean
}

extend input OpptakUtdanningsbakgrunnInput {
  """
  Om søkere kan velge utdanningsbakgrunnen i opptaket. Utelatt gir `true`, slik at
  eksisterende klienter beholder dagens oppførsel.
  """
  erValgbarForSoker: Boolean
}
```

##### Lag B — fs-admin call-site

```ts
// Skisse — IKKE for build. Etter backend-endringen (Task #8)
// Op #1 og Op #4 får:  utdanningsbakgrunner { … erValgbarForSoker }
// fraOpptak():  valgteTypeIder = rader der erValgbarForSoker !== false
// tilInput():   kort uten chip sendes med erValgbarForSoker: false og hendelsene sine
```

##### Lag C — Begrunnelse

- **Form:**
  - Feltet er additivt og valgfritt i input, med standard `true`. Det er bakoverkompatibelt per `fs-sikt-no-producer-schema-design §Endringer i API bør ikke ødelegge for klienter`, selv om kontrakten er eksperimentell.
  - Boolean med verb-prefiks per `fs-sikt-no-producer-naming §Boolean-felt navngis med verb`. Navnet speiler den eksisterende `kanVelgesAvSoker` på typen, men gjelder per opptak.
  - Nullable i output per `fs-sikt-no-producer-best-practice §Nullability`.
- **Colocation-status:** Ikke relevant, fordi dette er et schema-forslag. Kallene i frontend er beskrevet i Task #8.
- **Alternativer vurdert:**
  - En egen liste `Opptak.utdanningsbakgrunnFristavvik` med eget input. Det skiller frister fra valgbarhet tydeligere, men krever en ny koblingstabell og dupliserer `utdanningsbakgrunn_hendelse`. Forkastet med konservativt premiss.
  - At frontend legger til chipen automatisk. Forkastet av utvikler i beslutning 2 («helst ikke så mye automatikk»).
- **Konsekvens for andre:** Søkerflaten (TOT-1733, team Tind) må filtrere på `erValgbarForSoker` når den går over til `opptak_v2.utdanningsbakgrunn`.

### Tverrgående schema-bekymringer

#### Permission-modell

Uendret. Rutene krever `FS-ADMIN_MODIFISERE_OPPTAK` (`WithRole`), og `/rediger` krever i tillegg eierorganisasjonen. Backend avviser med `OppdaterOpptakFinnesIkkeFeil` / `OpptakUgyldigInput`. Ingen nye rettighetsfelt.

#### Error-union-medlemmer

| Mutation | Error-union | Medlemmer |
|----------|-------------|-----------|
| `oppdaterOpptak` (eksisterende) | `OppdaterOpptakError` | `OppdaterOpptakFinnesIkkeFeil`, `OpptakAlleredeFinnesFeil`, `OpptakUgyldigInput`, `OpptakUgyldigReferanseFeil` |
| `opprettOpptakV3` (eksisterende) | uendret | uendret |

Ingen nye unioner. Ugyldige bakgrunner (duplikat-type, ikke-velgbar type) kommer som `OpptakUgyldigInput` og vises med den eksisterende snackbaren for `message`.

#### Sporings-felter

Ikke aktuelt. Opptaket har allerede `endretTidspunkt`.

#### Versjonering

Ingen nye versjoner (`V2`). Alt er eksperimentelt, og Op #5 er additivt.

### Åpne spørsmål

- [ ] **Header for eksperimentelle mutasjoner:** Krever gatewayen `Feature-Flags: experimental` for de eksperimentelle `utdanningsbakgrunner`-feltene i input og svar på `opprettOpptakV3`/`oppdaterOpptak`? `GET_OPPTAK_FROM_ID` sender headeren, mutasjonene gjør det ikke. Verifiseres i Task #6 mot test, og headeren legges til i `context` hvis feltene ellers ignoreres eller avvises. Spørsmålet står også på sjekklisten i analysen.
- [ ] **Op #5 må godkjennes av backend:** navn, nullability og at søkerflaten filtrerer. Blokkerer bare Task #8.

## Implementation Tasks

### Task #1: Hent utdanningsbakgrunner i opptaksskjemaet og legg til skjematilstand

**Priority**: High
**Size**: S
**Dependencies**: None
**Addresses Requirements**: `@OPT-OVO-INN-001`, `@OPT-OVO-FRI-001` (redigering)

**Acceptance Criteria**:

- [ ] `GET_OPPTAK_FROM_ID` henter `utdanningsbakgrunner` som i Op #1. `npm run compile` er kjørt, og `src/__generated__` er oppdatert.
- [ ] `types.ts` eksporterer `OpptakUtdanningsbakgrunnData` og `UtdanningsbakgrunnerSkjema = { valgteTypeIder: string[]; avvik: { typeId: string; typeNavn: string; soknadsfrist: string | null; dokumentasjonsfrist: string | null }[]; eksisterende: Record<string, { beskrivelse: string; utloserTidligFrist: boolean }> }`.
- [ ] `emptyOpptakData()` har `utdanningsbakgrunner: []`, og den nye `emptyUtdanningsbakgrunnerSkjema()` returnerer tomme verdier. `emptyObjectGenerators.test.ts` er oppdatert.
- [ ] `utils/utdanningsbakgrunnUtils.ts` har `AVVIKENDE_FRIST_KODER` og `fraOpptak()`:
  - alle rader gir `valgteTypeIder`;
  - rader med minst én hendelse med en kode fra `AVVIKENDE_FRIST_KODER` gir `avvik` med ISO-datoer;
  - `beskrivelse` og `utloserTidligFrist` legges i `eksisterende`.
- [ ] `utdanningsbakgrunnUtils.test.ts` dekker: tom liste, bakgrunn uten hendelser, bakgrunn med én av to frister, og hendelser med andre koder, som ignoreres.

**Implementation Notes**:
Hendelser med andre koder enn de to fra `AVVIKENDE_FRIST_KODER` (lagt inn av andre klienter) beholdes ikke av `tilInput()`, fordi vi sender hele settet. Dette er notert som risiko. Alternativt kan `fraOpptak()` legge dem i `eksisterende`, slik at `tilInput()` sender dem videre uendret. Velg det siste hvis det ikke gjør `tilInput` mye mer komplisert.

### Task #2: Send utdanningsbakgrunner ved opprettelse og oppdatering

**Priority**: High
**Size**: M
**Dependencies**: Task #1
**Addresses Requirements**: `@OPT-OVO-INN-001` (alle scenariene), `@OPT-OVO-FRI-001` «Legge til utdanningsbakgrunn med avvikende frister»

**Acceptance Criteria**:

- [ ] `tilInput(skjema, typer)` i `utdanningsbakgrunnUtils.ts` gir `OpptakUtdanningsbakgrunnInput[]` for `valgteTypeIder`, som skissert i Op #4:
  - `hendelser` er alltid med, også som `[]`;
  - datoene går gjennom `formatToUTC`, som flyttes fra `convertDataToInput.tsx` eller eksporteres derfra;
  - kodene er enum-verdier, ikke rå strenger.
- [ ] `kortUtenChip(skjema)` returnerer type-id-ene som har kort, men ikke chip.
- [ ] `convertOpptakDataToOpprettOpptakV3Input` og `convertOpptakDataToOppdaterOpptakInput` tar imot `UtdanningsbakgrunnerSkjema` og typelisten, og setter alltid `utdanningsbakgrunner`.
- [ ] `convertDataToInput.test.tsx` og `utdanningsbakgrunnUtils.test.ts` dekker:
  - ny bakgrunn med utledet `beskrivelse`/`utloserTidligFrist: false`;
  - eksisterende bakgrunn der verdiene bevares;
  - kort med én frist;
  - kort uten frister (`[]`);
  - chip uten kort (`[]`);
  - at kort uten chip ikke kommer med.

**Implementation Notes**:
Typelisten trengs bare for å utlede `beskrivelse` på nye rader. Hvis det er enklere, kan `UtdanningsbakgrunnerSkjema` ta vare på `typeNavn` for valgte chips, slik at konverteringen ikke trenger typelisten.

### Task #3: Chip-listen «Godkjente utdanningsbakgrunner» i Innstillinger

**Priority**: High
**Size**: M
**Dependencies**: Task #1
**Addresses Requirements**: `@OPT-OVO-INN-001` «Legge til utdanningsbakgrunner fra godkjent liste», «Legge til flere utdanningsbakgrunner», «Fjerne en utdanningsbakgrunn fra opptaket»

**Acceptance Criteria**:

- [ ] `GET_OPPTAKSTYPER_REGELVERKSAMLINGER` henter `opptakUtdanningsbakgrunnstyper` (Op #2), og typer med `kanVelgesAvSoker: false` vises ikke.
- [ ] `OpptakSettings` får nye props `valgteUtdanningsbakgrunnTypeIder: string[]` og `onUtdanningsbakgrunnerChange: (typeIder: string[]) => void`, og rendrer `FSCombobox` med `multiple`, `wrap`, `fullWidth` og `required`:
  - label er `t('labelUtdanningsbakgrunner')`, «Godkjente utdanningsbakgrunner»;
  - `helperText` er teksten fra Figma, om at valget styrer hva søkere kan velge;
  - feltet er `disabled` mens data lastes.
- [ ] Plassering som i Figma: hele bredden av venstre kolonne, under paret opptakstype/regelverksamling. Layouten lages med `Flex`/`Grid` rundt feltet, uten egen CSS på komboboksen.
- [ ] Når ingenting er valgt og feltet har vært i bruk, vises `errorText`, for eksempel «Velg minst én utdanningsbakgrunn».
- [ ] `OpptakSettings.test.tsx` dekker: viser filtrerte valg, kaller `onUtdanningsbakgrunnerChange`, og fjerner en chip. `OpptakSettings.a11y.test.tsx` passerer med chip-listen.
- [ ] Nye i18n-nøkler ligger under `OpptakSettings` i `opptak.json` (`fs-admin-i18n-structure`).

**Implementation Notes**:
`FSCombobox` sin `label` er `string`. Påkrevd markeres derfor med `required`-propen (viser `RequiredBadge`), ikke med `RequiredFieldLabel`. Mocken for `GET_OPPTAKSTYPER_REGELVERKSAMLINGER` i `OpptakManagementPage.test.tsx` må få det nye feltet.

### Task #4: `OpptakDeadlineInput` får egen etikett, valgfrie felt og egen nøkkel for gyldighet

**Priority**: High
**Size**: S
**Dependencies**: None
**Addresses Requirements**: `@OPT-OVO-FRI-001` (beslutning 7)

**Acceptance Criteria**:

- [ ] Nye valgfrie props:
  - `label?: string`, som overstyrer `hendelseNavn`;
  - `helpText?: string`;
  - `isRequired?: boolean`, med standard `true`;
  - `validityKey?: string`, med standard `hendelse.type?.kode`, som brukes i `onValidityChange`.
- [ ] Med `isRequired={false}` gir et tomt felt ved blur `onHendelseChange(kode, undefined)` og nullstiller `incomplete`. Feltet tilbakestilles ikke. Et delvis utfylt felt gir fortsatt feilmeldingen om ufullstendig dato.
- [ ] Eksisterende kall (`OpptakDeadlinesSamordna`) oppfører seg likt. Eksisterende tester er grønne uten endringer.
- [ ] `OpptakDeadlineInput.test.tsx` har nye tilfeller for valgfritt felt: tømme et satt felt, delvis utfylt felt, og `validityKey`.

**Implementation Notes**:
Gjenbruk aldersberegning-grenen (L104–108), som allerede støtter tomt felt. Hold endringen lokal i komponenten.

### Task #5: Seksjon 05 «Utdanningsbakgrunner med avvikende frister»

**Priority**: High
**Size**: L
**Dependencies**: Task #1, Task #4
**Addresses Requirements**: `@OPT-OVO-FRI-001` «Legge til utdanningsbakgrunn med avvikende frister»

**Acceptance Criteria**:

- [ ] Ny `UtdanningsbakgrunnerAvvikendeFrister` med props `avvik`, `valgteTypeIder`, `onAvvikChange` og `onValidityChange`:
  - overskrift (`Heading level 2`, kalenderikon som i Figma) og beskrivelse (de to setningene fra Figma-node `21751:285722`);
  - knappen «Legg til ny utdanningsbakgrunn».
- [ ] «Legg til ny utdanningsbakgrunn» åpner en `PopoverMenu` som viser typene fra `GET_UTDANNINGSBAKGRUNNSTYPER_FOR_AVVIK` (Op #3):
  - typer med `kanVelgesAvSoker` og uten kort fra før vises;
  - et valg legger til et tomt kort og lukker menyen;
  - knappen er `disabled` mens data lastes eller når alle typer har kort.
- [ ] Ny `AvvikendeFristKort` (`Surface`, `Heading level 3` med typenavnet) har:
  - en «Fjern»-knapp med `aria-label` «Fjern avvikende frister for {navn}», som fjerner kortet fra `avvik`;
  - to `OpptakDeadlineInput` med `isRequired={false}`, label og helpText fra Figma, og `validityKey={`${typeId}:${kode}`}`.
- [ ] Når `typeId` ikke er i `valgteTypeIder`, viser kortet en melding (`Alert` med `severity="warning"`, eller tilsvarende i common): «{navn} er ikke valgt i «Godkjente utdanningsbakgrunner». Legg den til i listen over før du kan lagre.»
- [ ] Kortene vises i `Grid` med `gridTemplateColumns="repeat(auto-fit, minmax(300px, 1fr))"` (Key Decision 6). Ingen `display: flex/grid` i CSS.
- [ ] Tom liste og feil ved lasting av typer vises tydelig: «Ingen avvikende frister» / feilmelding.
- [ ] `.test.tsx` dekker: legge til kort, fjerne kort, sette og tømme frist, melding for kort uten chip, og at knappen er `disabled` når alle typer er brukt. `.a11y.test.tsx` er grønn for seksjonen og kortet.
- [ ] i18n under toppnøkkelen `UtdanningsbakgrunnerAvvikendeFrister`. Knappetekstene følger `fs-admin-buttons` («Legg til ny utdanningsbakgrunn», «Fjern»).

**Implementation Notes**:
- **Presedens for menyen:** `PersonaliaCardAddTag` (soknadsbehandling).
- **Presedens for kortet:** `OrganisasjonCard`.
- **Hvordan «Legg til» åpner (meny eller dialog)** står på designsjekklisten i analysen. Hvis design vil ha en dialog, byttes `PopoverMenu` ut med `FSModal` (`fs-admin-modal`).

### Task #6: Koble alt sammen i `OpptakManagementPage`

**Priority**: High
**Size**: M
**Dependencies**: Task #2, Task #3, Task #5
**Addresses Requirements**: `@OPT-OVO-INN-001`, `@OPT-OVO-FRI-001`, redigering (beslutning 6 og 8)

**Acceptance Criteria**:

- [ ] Ny tilstand `const [utdanningsbakgrunner, setUtdanningsbakgrunner] = useState(emptyUtdanningsbakgrunnerSkjema())`, fylt med `fraOpptak()` i den eksisterende utfyllings-`useEffect`.
- [ ] `OpptakSettings` får de valgte type-id-ene og en handler. Seksjon 05 rendres etter `OpptakDeadlinesSamordna`, med `<Divider />` imellom og **utenfor** `<fieldset disabled={editMode}>`.
- [ ] `saveDisabled` utvides med tre regler:
  - `valgteTypeIder.length === 0` (beslutning 4);
  - `kortUtenChip(...).length > 0` (midlertidig sperre);
  - ugyldige datoer i kortene, via `onValidityChange` med `validityKey` og et eget sett ved siden av `ugyldigeHendelseKoder`.
- [ ] `saveOpptak` sender `utdanningsbakgrunner` både ved opprettelse og oppdatering (Task #2).
- [ ] `OPPDATER_OPPTAK` velger `utdanningsbakgrunner` i svaret (Op #4). Det er verifisert at en ny åpning av `/rediger` etter lagring viser de nye verdiene.
- [ ] **Experimental-header:** Det er verifisert mot test om mutasjonene trenger `context: { headers: { 'Feature-Flags': 'experimental' } }`. Headeren legges til hvis det trengs, og funnet noteres i PR-beskrivelsen.
- [ ] `OpptakManagementPage.test.tsx` dekker:
  - opprettelse sender `utdanningsbakgrunner` med avvik;
  - redigering fyller chips og kort;
  - lagring er sperret uten valgt bakgrunn;
  - lagring er sperret med kort uten chip;
  - lagring er sperret med ufullstendig dato i et kort;
  - redigering sender `hendelser: []` etter «Fjern».
- [ ] `OpptakManagementPage.a11y.test.tsx` er grønn.

**Implementation Notes**:
Mockene i `OpptakManagementPage.test.tsx` må få de nye feltene. Importer dokumentene fra komponentfilene, og ikke deklarer operasjonene på nytt (CLAUDE.md).

### Task #7: Changeset og sluttsjekk

**Priority**: Medium
**Size**: S
**Dependencies**: Task #6
**Addresses Requirements**: —

**Acceptance Criteria**:

- [ ] Changeset skrevet med skillen `fs-admin-changesets`, med prefikset `Opptak:` og tilstandsbeskrivelse, for eksempel «Opptak: Det er nå mulig å velge utdanningsbakgrunner for opptaket og sette avvikende søknads- og dokumentasjonsfrister per utdanningsbakgrunn.» Om flagget `opptak-opprett-samordna` skal nevnes, avgjøres i skillen.
- [ ] Hele kjeden er grønn: `npm run lint`, type-sjekk, tester og prettier.
- [ ] Skillen `sikt-a11y` er kjørt på de endrede komponentene. Manuelle sjekker (tastatur i `PopoverMenu`, skjermleser for chips og melding på kort) er gjort.

### Task #8 (blokkert av backend): Erstatt sperren med infotekst når `erValgbarForSoker` finnes

**Priority**: Medium
**Size**: S
**Dependencies**: Backend-flagget fra Op #5, Task #6
**Addresses Requirements**: `@OPT-OVO-FRI-001`, beslutning 2 (kort uten chip lagres)

**Acceptance Criteria**:

- [ ] Op #1 og Op #4 henter `erValgbarForSoker`. Codegen er kjørt på nytt.
- [ ] `fraOpptak()` setter `valgteTypeIder` til rader der `erValgbarForSoker !== false`.
- [ ] `tilInput()` sender også kort uten chip, med `erValgbarForSoker: false` og hendelsene sine.
- [ ] `kortUtenChip` sperrer ikke lagring lenger. Meldingen på kortet blir en infotekst («… gjelder ikke før bakgrunnen legges til i listen over») med `severity="info"`.
- [ ] Når en chip fjernes for en bakgrunn som har kort, blir kortet stående og lagres med `erValgbarForSoker: false` (beslutning 3).
- [ ] Testene i Task #2, #5 og #6 er oppdatert.

## Risk Assessment

### Technical Risks

- **Risk:** Backend endrer fristkodene for bakgrunnsavvik (beslutning 1 er ikke bekreftet).
  - **Mitigation:** Kodene ligger i `AVVIKENDE_FRIST_KODER`, så en endring er én linje. Bekreft med Tuva før Task #2 merges.
- **Risk:** Gatewayen ignorerer eller avviser eksperimentelle felt i mutasjonene uten headeren `Feature-Flags: experimental`.
  - **Mitigation:** Verifiseres eksplisitt i Task #6 mot test, og headeren legges til i `context` ved behov.
- **Risk:** `tilInput()` sender hele hendelsessettet per bakgrunn, så hendelser med andre koder fra andre klienter kan slettes.
  - **Mitigation:** Task #1 vurderer å bevare dem via `eksisterende`. Ellers dokumenteres det som kjent begrensning.
- **Risk:** Et tomt kort lagres som `hendelser: []` og kommer ikke tilbake etter ny innlasting (det ser ut som en chip uten avvik).
  - **Mitigation:** Akseptert etter beslutning 7. Atferden dokumenteres i testene.
- **Risk:** Det som lagres, vises ikke i søknadsbehandling. `Query.utdanningsbakgrunner` leser den gamle tabellen `soknad_v2` til TOT-1733 er levert.
  - **Mitigation:** Ingen frontend-tiltak i TAKE-384. Nevnes i PR-beskrivelsen og for Tind.
- **Risk:** Avvik mellom server- og klientrendering hvis gridet med kort bruker responsivt `Grid` med `useBreakpoints`.
  - **Mitigation:** Fast `auto-fit`-streng (Key Decision 6).
- **Risk:** `FSCombobox` er «POC v1», så API-et kan endre seg.
  - **Mitigation:** Bruk bare de dokumenterte propene (`multiple`, `wrap`, `required`, `errorText`, `helperText`, `fullWidth`, `disabled`).

### Testing Requirements

- Enhetstester for `utdanningsbakgrunnUtils.ts`:
  - `fraOpptak`, `tilInput` og `kortUtenChip`;
  - ny og eksisterende bakgrunn, én eller ingen frist, og andre koder.
- Enhetstester for `convertDataToInput` (opprettelse og oppdatering med `utdanningsbakgrunner`) og for `OpptakDeadlineInput` (valgfritt felt, `validityKey`).
- Komponenttester for `OpptakSettings` (chip-listen), `UtdanningsbakgrunnerAvvikendeFrister` og `AvvikendeFristKort`.
- Integrasjonstester i `OpptakManagementPage.test.tsx` for opprettelse, redigering og alle sperrene for lagring.
- `*.a11y.test.tsx` for hver ny og endret komponent (CLAUDE.md).

## Success Criteria

- [ ] All acceptance criteria met (Task #1–#7; Task #8 når backend er klar)
- [ ] All tests passing
- [ ] Code follows project conventions (CLAUDE.md, `fs-admin-inputs`, `fs-admin-buttons`, `fs-admin-grid-and-flex`, `graphql-consumer`, `fs-admin-i18n-structure`)
- [ ] All must-have requirements addressed (`@OPT-OVO-INN-001`- og `@OPT-OVO-FRI-001`-reglene om utdanningsbakgrunner)
- [ ] Et opptak kan opprettes og redigeres med utdanningsbakgrunner og avvikende frister, og verdiene vises igjen etter ny innlasting
- [ ] Sjekklisten «Å sjekke med design og backend» i analysen er tatt opp med Tuva og designer

## Requirements Traceability

| Requirement ID | Requirement Summary | Addressed by Task(s) | Status |
| --- | --- | --- | --- |
| `@OPT-OVO-INN-001` — «Legge til utdanningsbakgrunner fra godkjent liste» | Velge blant godkjente typer | Task #3 (Op #2), Task #6 | Planned |
| `@OPT-OVO-INN-001` — «Legge til flere utdanningsbakgrunner» | Flere bakgrunner i opptaket; søkere kan velge blant dem | Task #3, Task #2, Task #6 | Planned. Søkerdelen er avhengig av TOT-1733. |
| `@OPT-OVO-INN-001` — «Fjerne en utdanningsbakgrunn fra opptaket» | Fjerne bakgrunn | Task #3, Task #2, Task #6, Task #8 | Planned |
| `@OPT-OVO-FRI-001` — «Legge til utdanningsbakgrunn med avvikende frister» | Egen søknads- og dokumentasjonsfrist per bakgrunn | Task #4, Task #5, Task #2, Task #6; Task #8 for kort uten chip | Planned. Kort uten chip er blokkert av backend. |
| `@OPT-OVO-FRI-001` — «Søker uten registrert utdanningsbakgrunn følger ordinære frister» | Generelle frister gjelder uten avvik | Task #2 (ingen tomme avvik for chips uten kort) | Planned. Selve oppførselen hører til søknad og saksbehandling. |
| Beslutning 4 — minst én bakgrunn påkrevd | Ikke i kravet ennå | Task #3, Task #6 | Planned. Bør inn i `innstillinger.feature`. |
| Beslutning 6/8 — redigering på `/rediger` | Bakgrunner og avvik kan redigeres | Task #1, Task #6 | Planned |
