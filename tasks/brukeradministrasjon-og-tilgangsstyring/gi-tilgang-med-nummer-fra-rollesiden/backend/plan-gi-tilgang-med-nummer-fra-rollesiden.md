# Plan: Gi en person tilgang med nummer fra rollesiden

Bygger på [`analysis-gi-tilgang-med-nummer-fra-rollesiden.md`](analysis-gi-tilgang-med-nummer-fra-rollesiden.md)
og spec-en [`spec-gi-tilgang-med-nummer-fra-rollesiden.md`](../spec/spec-gi-tilgang-med-nummer-fra-rollesiden.md),
med kravendringene `265163b` og `9527781` på `krav/personbrukere-uten-feide-konto`. Planen dekker to repoer:
fs-plattform (`tilgangsstyring`) og fs-admin.

Planen ble skrevet av en agent som ikke kunne spørre Kjetil underveis. Der skillen ville spurt, er det tatt
et valg. Valgene står i «Valg tatt i stedet for spørsmål» og er merket **[valg]** der de brukes.

## Proposed Solution

### Architecture Approach

Brukeradministratoren åpner en rolle i rolleoversikten, ser personene som har rollen, og gir rollen til en
person med nummeret. Flere roller gis etterpå på brukersiden for personen. Fire byggesteiner:

1. **Én inngang i basen for den første tildelingen.** En ny `SECURITY DEFINER`-funksjon tar nummer, rolle,
   organisasjon og miljø. Den gjør alle avvisningene som kan avgjøres uten å slå opp personen (rett,
   tilgangskode, nummer, testperson mot ekte miljø), finner eller oppretter personen uten navn, og gir
   tildelingen gjennom den eksisterende `tildel_brukertilgang`. Svaret er personens `subjekt_id` uansett
   utgangspunkt, så funksjonen kan ikke brukes til å finne ut om en person finnes.
2. **En bulkmutasjon over funksjonen**, `tildelPersonsubjektTilgangerMedFodselsnummer`, med listeinput og
   alt-eller-ingenting. Svaret er de nå synlige personene, én per element. Dialogen på rollesiden sender en
   liste med ett element.
3. **Kilder for skjermene**: rolleoversikten (`mineTildelbareTilgangsroller`), valglistene i dialogen
   (`mineTildelingsorganisasjoner` med personretten, ny `mineTildelingsmiljoer`), radene på rollesiden (eksakt
   tilgangsfilter på `tilganger`), brukeroversikten for personer (`skjulInaktiveFraAndreOrganisasjoner` på
   `personsubjekter`), og Feide-brukerne som er koblet til en person (`Personsubjekt.feideBrukere`).
4. **FS Admin**: ny rolleoversikt og rolleside, dialogen «Gi rollen til en person», brukeroversikten over
   personer, og brukersiden for en person med «Tildel roller» over `tildelPersonsubjektTilganger` (!6015).

I4 («syntetiske subjekter tildeles ikke tilganger i et ekte miljø») håndheves i `tildel_brukertilgang` for
personer, så både den nye mutasjonen og `tildelPersonsubjektTilganger` avviser en testperson i et ekte miljø
med samme feil.

### Key Technical Decisions

1. **Decision: Ny `SECURITY DEFINER`-funksjon `tildel_person_med_fodselsnummer`, ikke en utvidelse av
   `tildel_brukertilgang` eller `opprett_person`.**
   - Why: kalleren ser ikke personen før tildelingen finnes. En INVOKER-funksjon kan verken finne en
     eksisterende person eller unngå 23505. Under DEFINER må funksjonen selv sjekke retten
     (`krev_person_tildelingsrett`, som leser sesjonsclaimene) før den rører `personsubjekt`.
   - Alternative considered: en `SECURITY DEFINER`-variant av `krev_person`. Forkastet: da ville
     `tildelPersonsubjektTilganger` på et usynlig `subjekt_id` lykkes, og «usynlig er lik ukjent» i !6015
     ryker.
2. **Decision: Sjekkene står i en fast rekkefølge, og ingen av dem slår opp personen:** påkrevde verdier,
   tildelingsrett, tilgangskode, nummerets form og kontrollsifre, FS-generert serie **[valg Q1]** og testperson
   mot ekte miljø. Personen slås opp eller opprettes først etter dem.
   - Why: da kan bare suksess følge et oppslag (GRU-013 «Svaret avslører ikke om personen fantes fra før»).
     Et `RAISE` ruller tilbake alt, så en opprettet person forsvinner hvis tildelingen feiler.
3. **Decision: `opprett_person` godtar et nummer uten navn, og den nye funksjonen kaller den.**
   - Why: én vei for å opprette en person, og den avgjorte beslutningen sier at navnet kommer fra første
     pålogging. Testpersonaene sender fortsatt navn.
   - Alternative considered: en egen INSERT i den nye funksjonen. Forkastet: to veier for samme rad.
4. **Decision: Kappløp om samme nummer løses med `pg_advisory_xact_lock(hashtextextended(fnr, 0))` før
   oppslaget.**
   - Why: to samtidige kall med samme nummer skal gi én person. Låsen gjør oppslag og opprettelse atomisk
     uten å fange 23505 (som også ville bære nummeret i feilteksten).
   - Alternative considered: `EXCEPTION WHEN unique_violation` og nytt oppslag. Forkastet av samme grunn.
5. **Decision: I4 håndheves i `tildel_brukertilgang` for mål med aktørledd `person` **[valg Q6]**, med
   `TS204`.**
   - Why: basen er autoritativ (I3), og alle veier til en tildeling på en person dekkes. Feide-grenen er
     uendret, fordi kravet gjelder personer og en endring der kan treffe eksisterende data.
   - Alternative considered: bare i den nye funksjonen. Forkastet: `tildelPersonsubjektTilganger` ville sluppet
     testpersonen gjennom.
6. **Decision: Bulk betyr alt-eller-ingenting med én typet feil.** Graphitron fører én exception ut av en
   `@service` (`fsp-mutation-standards` §3). Feilene avgjøres før personen slås opp, og `errors[].path` har
   ingen indeks, så ingen feil skiller mellom elementer med og uten eksisterende person. fs-admin får utfall
   per rad med ett alias-rotfelt per rad (`batchTildeling.ts`) når den sender flere, men dialogen sender ett.
7. **Decision: Ny backend-gren `tilgangsstyring/personsubjekt-tilgang-med-nummer` stablet på !6015**, i egen
   MR (MR A). Filteret som skjuler inaktive og `Personsubjekt.feideBrukere` trenger koblingstabellen fra !6014
   og går i en egen MR (MR B), stablet på MR A med !6014 flettet inn, eller rebaset på `main` når !6014 er
   flettet.
   - Why: !6015 er iterasjon 3 og et utkast. Iterasjon 4 i samme MR gjør den for stor å reviewe. !6014 er ute
     av utkast med reviewere, og skal ikke få nye ting.
   - Alternative considered: alt i !6015. Forkastet: størrelse og review. Alt på `main`: umulig, fordi
     `Personsubjekt` og `krev_person_tildelingsrett` bare finnes i !6015.
8. **Decision: Rolleoversikten viser `rolletype` ROLLE fra `mineTildelbareTilgangsroller` **[valg Q3]**.**
   Kilden gir hele katalogen når kalleren har `BRUKERADMIN_PERSON_TILDELING_SKRIV` i minst ett par, og ellers
   en tom liste. Filteret `rolletype` gjør det mulig å endre valget uten skjemaendring.
9. **Decision: Rollesiden og brukeroversikten viser bare personer **[valg Q4]**,** i tråd med den avgjorte
   beslutningen om brukeroversikten. Feide-brukere med rollen på Feide-brukeren kommer med når
   migreringsskriptet i !6014 har flyttet rollene.
10. **Decision: `/tilgangsstyring/personbrukere/[id]` velger visning etter nodetype.** `Personsubjekt` gir den
    nye brukersiden for en person. `FeideBruker` gir dagens side, som fortsatt nås fra Feide-brukerne som er
    koblet til en person.

### File Changes Overview

`CL`, `SCH` og `SVC` som i analysen. Nummerne er det første ledige per 07.10.2026: migrering 0090 og 0091,
pgTAP 78 og 79, feilkode TS204. De sjekkes på nytt mot `main` og åpne MR-er før skrivingen.

**fs-plattform, MR A (`tilgangsstyring/personsubjekt-tilgang-med-nummer`, stablet på !6015)**

- Ny `CL/0090-tildeling-med-fodselsnummer.sql`:
  - `opprett_person` uten navn
  - `tildel_person_med_fodselsnummer`
  - I4 for personer i `tildel_brukertilgang`
  - personretten i `mine_tildelingsorganisasjoner` og `tildelbare_tilgangskoder`
  - ny `mine_tildelingsmiljoer(organisasjonskode)`
- `CL/db-changelog-root.xml`: include med rekkefølgekommentar.
- Ny `tilgangsstyring/tilgangsstyring-new-db/src/test/sql/78_tildeling_med_fodselsnummer.sql`.
- Ny `SCH/experimental/schema_personsubjekt_tilgang_med_nummer.graphqls`:
  - mutasjonen, input, payload og feiltyper
  - `mineTildelbareTilgangsroller`
  - `mineTildelingsmiljoer`
- Endret !6015 `SCH/experimental/schema_personsubjekt.graphqls`: `SyntetiskPersonIEktMiljo` i
  `TildelPersonsubjektTilgangerError`.
- Endret `SCH/experimental/schema_brukeradmin.graphqls`: `FeideBrukerTilgangerFilterInput.tilganger`.
- Endret `SCH/stable/feil.graphqls` eller ny feilfil i experimental: `UgyldigFodselsnummer` og
  `SyntetiskPersonIEktMiljo`. Nye feiltyper hører i experimental (`fsp-graphql-standards`).
- Nye klasser i `SVC/`:
  - `PersonsubjektTilgangMedFodselsnummerService.java`
  - `records/TildelPersonsubjektTilgangerMedFodselsnummerInput.java` og
    `records/TildelPersonsubjektTilgangerMedFodselsnummerPayload.java`
  - `UgyldigFodselsnummerException.java` og `SyntetiskPersonIEktMiljoException.java`
  - `TildelbareTilgangsrollerConditions.java`, hvis utvalget legges som `@condition`
- Endret `SVC/FeideBrukerTilgangerFilterConditions.java`, hvis det eksakte tilgangsfilteret ikke kan være en
  ren `@field`/`@nodeId`-mapping.
- Endret !6015 `SVC/PersonsubjektTilgangService.java`: oversetter TS204.
- Nye tester i `tilgangsstyring/tilgangsstyring-app/src/test/java/no/sikt/fs/tilgangsstyring/`:
  - `PersonsubjektTilgangMedFodselsnummerGraphqlTest.java`
  - `TildelbareRollerOgMiljoerQueryTest.java`
- Dokumentasjon:
  - `tilgangsstyring/docs/syntetiske-og-ekte-data.md`: rad I4 i «Hvor reglene håndheves»
  - `tilgangsstyring/docs/tilgangsmodell.md`: avsnittet om personsubjektet, `opprett_person` og den nye
    inngangen
  - `tilgangsstyring/docs/specs/personsubjekt-api/spec-personsubjekt-api.md`: iterasjon 4 er levert

**fs-plattform, MR B (`tilgangsstyring/personsubjekt-oversikt`, krever !6014 og MR A)**

- Ny `CL/0091-personsubjekt-oversikt.sql`: en `SECURITY DEFINER`-mengdefunksjon for gjeldende koblinger
  kalleren ser begge sider av, og en mengdefunksjon for personer som hører hjemme hos kalleren.
- Ny `tilgangsstyring/tilgangsstyring-new-db/src/test/sql/79_personsubjekt_oversikt.sql`.
- Endret !6015 `SCH/experimental/schema_personsubjekt.graphqls`:
  - `PersonsubjekterFilterInput.skjulInaktiveFraAndreOrganisasjoner`
  - `Personsubjekt.feideBrukere`
- Endret !6015 `SVC/PersonsubjekterFilterConditions.java`: `skjulInaktiveFraAndreOrganisasjoner`.
- jOOQ-oppsettet (`tilgangsstyring/tilgangsstyring-new-jooq/pom.xml`): syntetisk nøkkel om feltet går gjennom
  et view.
- Tester i `PersonsubjekterQueryTest.java`.
- `tilgangsmodell.md`: synligheten i oversikten.

**fs-admin (egne grener fra `origin/main`, se «MR-rekkefølge»)**

- Nye ruter:
  - `src/app/tilgangsstyring/roller/{layout.tsx,page.tsx}`
  - `src/app/tilgangsstyring/roller/[id]/{layout.tsx,page.tsx}`
  - `page.a11y.test.tsx` for begge
- Nye features:
  - `src/domains/tilgangsstyring/features/RollerOverview/`: listen, hook og tester
  - `src/domains/tilgangsstyring/features/RolleDetails/`: topplinjen, personlisten og dialogen
    `GiRollenTilPersonModal` med hook, util og tester
- Ny util `src/domains/tilgangsstyring/utils/fodselsnummer.ts` med `.test.ts`: elleve sifre og mod 11.
- Endret `src/domains/tilgangsstyring/features/PersonbrukereOverview/`: spørringen går mot `personsubjekter`,
  og filtrene og radene blir for personer.
- Endret `src/app/tilgangsstyring/personbrukere/[id]/page.tsx` og ny
  `src/domains/tilgangsstyring/features/PersonDetails/`:
  - topplinjen, fanene «Detaljer» og «Roller»
  - Feide-brukerne som er koblet til personen
  - `TildelRolleModal` og `FjernRolleModal` for en person
- Endret:
  - `src/features/Header/Menu/Menu.tsx`: menypunktet «Roller»
  - `src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.tsx`: kortet «Roller»
  - `src/common/lib/apollo/cacheConfig.ts`: `personsubjekter` og `mineTildelbareTilgangsroller`
  - `src/common/lib/apollo/refetchQueryNames` med nye navn
  - `src/common/messages/nb/domains.json`, `features.json` og `support.json`: tekstene fra designfilene
  - `src/common/types/generated/routes.d.ts`, regenerert
- `.changeset/*.md` per MR.

## GraphQL-endringer

> **Premiss:** konservativt. Flaten speiler `tildelPersonsubjektTilganger` og søsknene `mine*`, og alle
> mutasjoner er bulkmutasjoner (Kjetil, 07.10.2026).
> **Domeneterm:** `Personsubjekt` i skjemaet, «person» i grensesnittet (!6015, besluttet 06.10.2026).
> **Følger fra:** [`analysis-gi-tilgang-med-nummer-fra-rollesiden.md`](analysis-gi-tilgang-med-nummer-fra-rollesiden.md),
> Key Findings 1, 4-7, 12 og 14.
> **Repo-konvensjon:** feilunionene i tilgangsstyring heter `<Mutasjon>Error` i entall
> (`TildelPersonsubjektTilgangerError`). Planen følger repoet, ikke malens `Errors` i flertall.

### Sammendrag

- 3 nye queries (`mineTildelbareTilgangsroller`, `mineTildelingsmiljoer` og `Personsubjekt.feideBrukere`) og
  2 endrede (`mineTildelingsorganisasjoner` tar med personretten, `personsubjekter` får et filter)
- 1 ny mutasjon (`tildelPersonsubjektTilgangerMedFodselsnummer`) og 1 endret (`tildelPersonsubjektTilganger`
  får en ny feil)
- 2 nye feiltyper, 3 nye input-/payload-typer og 2 nye filterfelt
- 3 åpne spørsmål (se nederst)

### Operasjoner

#### Op #1: `TildelPersonsubjektTilgangerMedFodselsnummer`, den første tildelingen med nummer

**Dekker krav:** BRU-PER-GRU-013 (reglene «Den første tildelingen …», «Svaret avslører ikke …», «Nummeret
må ha gyldige kontrollsifre», «En testperson kan ikke få tilgang i et ekte miljø» og «Brukeradministratoren
kan bare gi roller hen har rett til å tildele»), BRU-PER-ROL-002 (regelen «Gi rollen til en person med
fødselsnummer, D-nummer eller SNR»)
**Implementeres av:** Task #1, Task #2 (backend), Task #9 (fs-admin)

##### Lag A — Schema-tillegg

```graphql
"""Én rolle eller tilgang som skal gis en person identifisert med nummer."""
input TildelPersonsubjektTilgangerMedFodselsnummerInput {
  "Personens fødselsnummer, D-nummer eller SNR: elleve sifre. Vises aldri i svaret."
  fodselsnummer: String!
  tilgangId: ID! @nodeId(typeName: "Tilgangsrolle")
  organisasjonId: ID! @nodeId(typeName: "Organisasjon")
  miljoId: ID! @nodeId(typeName: "Miljo")
}

"""
Personene som fikk tildelingen, ett element per element i input og i samme rekkefølge. Svaret er det
samme uansett om personen fantes fra før. Innholdet følger lesereglene: uten lesetilgang i organisasjonen
og miljøet er elementet null, selv om tildelingen gikk gjennom.
"""
type TildelPersonsubjektTilgangerMedFodselsnummerPayload {
  personsubjekter: [Personsubjekt]
}

union TildelPersonsubjektTilgangerMedFodselsnummerError =
    ManglerTildelingsrett
  | TilgangskodeIkkeFunnet
  | UgyldigFodselsnummer
  | SyntetiskPersonIEktMiljo

"""
Nummeret er ikke et gyldig fødselsnummer, D-nummer eller SNR. Meldingen gjentar aldri nummeret.
"""
type UgyldigFodselsnummer implements Error
    @error(handlers: [{ handler: DATABASE, sqlState: "22023", matches: "fødselsnummeret er ugyldig",
                        description: "Nummeret er ikke et gyldig fødselsnummer, D-nummer eller SNR." }]) {
  path: [String!]!
  message: String!
}

"""En testperson (syntetisk person) kan ikke få tilgang i et ekte miljø."""
type SyntetiskPersonIEktMiljo implements Error
    @error(handlers: [{ handler: DATABASE, sqlState: "TS204",
                        description: "En testperson kan ikke få tilgang i et ekte miljø." }]) {
  path: [String!]!
  message: String!
}

extend type Mutation {
  """
  Gi personer tilganger og roller, og identifiser hver person med fødselsnummer, D-nummer eller SNR.
  Personen opprettes uten navn hvis hen ikke finnes, og blir synlig for deg gjennom tildelingen. Svaret er
  det samme uansett om personen fantes. Krever rettighet til å tildele (BRUKERADMIN_PERSON_TILDELING_SKRIV)
  i hver kombinasjon. Alt eller ingenting: feiler ett element, skrives ingen av dem. Idempotent: en tilgang
  personen alt har direkte, skrives ikke på nytt. En tom liste gir et tomt svar.
  """
  tildelPersonsubjektTilgangerMedFodselsnummer(
    input: [TildelPersonsubjektTilgangerMedFodselsnummerInput!]!
  ): TildelPersonsubjektTilgangerMedFodselsnummerPayload
    @service(service: {className: "no.sikt.fs.tilgangsstyring_service.PersonsubjektTilgangMedFodselsnummerService",
                       method: "tildelPersonsubjektTilgangerMedFodselsnummer"})
}
```

##### Lag B — fs-admin call-site

```ts
// src/domains/tilgangsstyring/features/RolleDetails/components/GiRollenTilPersonModal/hooks/useGiRollenTilPerson.tsx
export const TILDEL_PERSONSUBJEKT_TILGANGER_MED_FODSELSNUMMER = gql(/* GraphQL */ `
  mutation TildelPersonsubjektTilgangerMedFodselsnummer($input: [TildelPersonsubjektTilgangerMedFodselsnummerInput!]!) {
    tildelPersonsubjektTilgangerMedFodselsnummer(input: $input) {
      personsubjekter { id }
      errors { ... on Error { message path } }
    }
  }
`)
// Skisse — én rad fra rollesiden:
// mutate({ variables: { input: [{ fodselsnummer, tilgangId: rolle.id, organisasjonId, miljoId }] },
//   context: { headers: { 'Feature-Flags': 'experimental' } } })
// Suksess: lukk dialogen, slett nummeret fra state, snackbar «Personen har fått rollen {rollekode}.»,
//   refetchQueries(refetchQueryNames('rollePersonsubjekter')).
// Feil: UgyldigFodselsnummer og SyntetiskPersonIEktMiljo vises som feltfeil, resten i FSModalFeedback.
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-PER-GRU-013 og BRU-PER-ROL-002, som over.
- **Form:** listeinput, fordi mutasjoner skal være bulk (Kjetil, 07.10.2026). Svaret er `[Personsubjekt]`, så
  klienten finner personen igjen uten å slå opp på nummeret (!6015-spec-en, «Avklart 06.10.2026»). Svaret har
  ikke nummeret, og ingen feilmelding gjentar det. Mutasjonen ligger på `Mutation` per
  `fs-sikt-no-producer-best-practice §Bare felt på Mutation-typen kan utføre endringer`.
- **Ingen `PersonsubjektIkkeFunnet`:** et mål som ikke finnes, opprettes, og et usynlig mål tildeles. Unionen
  har bare feil som avgjøres før oppslaget. Dermed kan intet element avsløre om personen finnes.
- **Nullability:** `personsubjekter: [Personsubjekt]` med nullbare elementer, fordi lesereglene kan gi null per
  element (`fs-sikt-no-producer-best-practice §Nullability`).
- **Navn:** `fodselsnummer` er norsk domenebegrep uten æøå per
  `fs-sikt-no-producer-naming §Bruk norsk for domenebegreper og dagligspråk, engelsk for tekniske begreper`,
  og samme feltnavn som `Sudo-Fodselsnr` i dokumentasjonen.
- **Colocation-status:** Ikke best practice. Mutasjonen velger bare `id`, fordi dialogen ikke rendrer
  personen, men laster listen på nytt. Det finnes ikke noe komponentfragment å spre.
- **Alternativer vurdert:**
  - Utvide `tildelPersonsubjektTilganger` med `@oneOf { personsubjektId | fodselsnummer }`. Forkastet: feilen
    `PersonsubjektIkkeFunnet` må finnes for id-grenen og ikke for nummergrenen, og én union kan ikke uttrykke
    det.
  - En egen `opprettPersonsubjekt`. Forkastet: en person uten tildeling er usynlig (beslutning 25.09.2026).

#### Op #2: `TildelPersonsubjektTilganger` (finnes i !6015): flere roller fra brukersiden

**Dekker krav:** BRU-PER-GRU-013 «Flere tilganger legges til fra brukersiden etter den første rollen»,
BRU-PER-ROL-001 «Åpne brukersiden fra rollens oversiktsside», BRU-PER-ROL-002 «Flere roller gis etterpå fra
detaljsiden for personen»
**Implementeres av:** Task #1 (feilen), Task #12 (fs-admin)

##### Lag A — Schema-tillegg

```graphql
# Mutasjonen er alt en bulkmutasjon (input: [TildelPersonsubjektTilgangerInput!]!). Bare unionen endres:
union TildelPersonsubjektTilgangerError =
    ManglerTildelingsrett
  | PersonsubjektIkkeFunnet
  | TilgangskodeIkkeFunnet
  | SyntetiskPersonIEktMiljo
```

##### Lag B — fs-admin call-site

```ts
// src/domains/tilgangsstyring/features/PersonDetails/components/PersonRoller/hooks/useTildelPersonsubjektTilganger.tsx
// Speiler useTildelFeideBrukerTilganger: ett alias-rotfelt per valgt rolle (byggAliasBatch), så hver rad får sitt utfall.
export const TILDEL_PERSONSUBJEKT_TILGANGER = gql(/* GraphQL */ `
  mutation TildelPersonsubjektTilganger($input: [TildelPersonsubjektTilgangerInput!]!) {
    tildelPersonsubjektTilganger(input: $input) {
      tilganger { id tilgangskode tilknytning }
      errors { ... on Error { message path } }
    }
  }
`)
```

##### Lag C — Begrunnelse

- **Form:** !6015 har alt listeinput, alt-eller-ingenting og `tilganger` i samme rekkefølge som input. Det
  oppfyller bulkkravet uten endring. `SyntetiskPersonIEktMiljo` kommer med fordi I4 håndheves i
  `tildel_brukertilgang`, som mutasjonen bruker.
- **Orakel per element:** målvakten `krev_person` kommer før retten, og en usynlig, ukjent eller feiltypet id gir
  samme `PersonsubjektIkkeFunnet`. TS204 avgjøres først når målet er synlig, og avslører dermed ikke noe
  kalleren ikke alt ser.
- **Colocation-status:** Ikke best practice. Speiler det eksisterende mønsteret i
  `useTildelFeideBrukerTilganger` med alias-batch, så Feide- og personvarianten av «Tildel roller» kan dele
  feilvisningen.
- **Versjonering:** et nytt medlem i unionen er additivt per
  `fs-sikt-no-producer-schema-design §Endringer i API bør ikke ødelegge for klienter`, og flaten er
  experimental.

#### Op #3: `GetMineTildelbareTilgangsroller`, rolleoversikten

**Dekker krav:** BRU-PER-ROL-001 «Rolleoversikten viser bare roller brukeradministratoren har rett til å
tildele», «Åpne en rolle fra rolleoversikten»
**Implementeres av:** Task #3 (backend), Task #7 (fs-admin)

##### Lag A — Schema-tillegg

```graphql
extend type Query {
  """
  Rollene og tilgangene du kan tildele personer. Det er rollekatalogen når du har rettighet til å tildele
  (BRUKERADMIN_PERSON_TILDELING_SKRIV) i minst én kombinasjon av organisasjon og miljø, ellers en tom liste.
  Hvilke kombinasjoner rettigheten gjelder i, viser `mineTildelingsorganisasjoner` og `mineTildelingsmiljoer`.
  Sortert på kode.
  """
  mineTildelbareTilgangsroller(filter: MineTildelbareTilgangsrollerFilterInput): [Tilgangsrolle]
    @asConnection(defaultFirstValue: 100) @defaultOrder(fields: [{name: "ROLLEKODE"}])
}

input MineTildelbareTilgangsrollerFilterInput {
  "Vis kun atomære tilganger (TILGANG) eller kun sammensatte roller (ROLLE)."
  rolletype: RolletypeInput @field(name: "ROLLETYPE")
}
```

##### Lag B — fs-admin call-site

```ts
// src/domains/tilgangsstyring/features/RollerOverview/components/RollerResultList/RollerResultList.tsx
export const ROLLER_RESULT_LIST_FRAGMENT = gql(/* GraphQL */ `
  fragment RollerResultListFields on Tilgangsrolle { id kode beskrivelse }
`)
// src/domains/tilgangsstyring/features/RollerOverview/hooks/useGetMineTildelbareRoller.tsx
export const GET_MINE_TILDELBARE_TILGANGSROLLER = gql(/* GraphQL */ `
  query GetMineTildelbareTilgangsroller($first: Int, $after: String) {
    mineTildelbareTilgangsroller(first: $first, after: $after, filter: { rolletype: ROLLE }) {
      nodes { ...RollerResultListFields @unmask }
      totalCount
      pageInfo { endCursor hasNextPage }
    }
  }
`)
```

##### Lag C — Begrunnelse

- **Form:** et eget rotfelt i experimental, ikke et filter på det stabile `tilgangsroller`. Et nytt
  argument på et stabilt felt måtte vært tagget for seg. Paginert per
  `fs-sikt-no-producer-best-practice §Paginering` og
  `fs-sikt-no-producer-schema-design §Vi følger Cursor Connections Specification for paginering`, fordi
  katalogen har mer enn ti roller.
- **Utvalget** følger modellen: tildelingsretten gjelder hele katalogen (`tilgangsmodell.md`). «Noen, men ikke
  alle» kan ikke uttrykkes før modellen har rett per rolle (analysen, Key Finding 4). Navnet `mine*` følger
  søsknene `mineTildelingsorganisasjoner` og `mineSynligeBrukerroller`.
- **Colocation-status:** Følger colocation per `graphql-golden-path-fragment-colocation §Implementation notes`.
  `@unmask` brukes som i `PersonbrukereResultList`, fordi radene rendres inline.

#### Op #4: `GetMineTildelingsmiljoer` og `mineTildelingsorganisasjoner`: valglistene i dialogen

**Dekker krav:** BRU-PER-ROL-002 «Valglisten for organisasjon er begrenset …», «Organisasjonen er gitt når
brukeradministratoren administrerer én organisasjon», «Valglisten for miljø er begrenset …»
**Implementeres av:** Task #3 (backend), Task #9 (fs-admin)

##### Lag A — Schema-tillegg

```graphql
extend type Query {
  """
  Miljøene du har rettighet til å tildele og fjerne tilganger på brukere i, for organisasjonen. Egner seg
  som kilde for miljøvelgeren når organisasjonen er valgt. Tom liste når du ikke har rettigheten i
  organisasjonen.
  """
  mineTildelingsmiljoer(organisasjonId: ID!): [Miljo] @defaultOrder(fields: [{name: "NAVN"}])
}
# mineTildelingsorganisasjoner: uendret signatur. Funksjonen tar med BRUKERADMIN_PERSON_TILDELING_SKRIV i unionen,
# og beskrivelsen oppdateres. tildelbareTilgangskoder får samme utvidelse.
```

##### Lag B — fs-admin call-site

```ts
// .../GiRollenTilPersonModal/hooks/useGetMineTildelingsmiljoer.tsx
export const GET_MINE_TILDELINGSMILJOER = gql(/* GraphQL */ `
  query GetMineTildelingsmiljoer($organisasjonId: ID!) {
    mineTildelingsmiljoer(organisasjonId: $organisasjonId) { id kode navn }
  }
`)
// useQuery(..., { skip: !organisasjonId, context: experimental-header }). Organisasjonene fra den eksisterende
// useGetMineTildelingsorganisasjoner (låst når det er én).
```

##### Lag C — Begrunnelse

- **Form:** et argument, ikke en liste over par. Dialogen velger organisasjon først, som «Tildel roller». Listen
  er kort (få miljøer), så den pagineres ikke (`fs-sikt-no-producer-best-practice §Paginering`, unntaket for
  korte lister). Argumentet er en rå `ID!` som dekodes i servicen eller betingelsen, som på
  `tildelbareTilgangskoder` (`@nodeId` på `@routine`-argumenter er en kjent felle, `fsp-mutasjonskonvensjoner`
  §3).
- **Colocation-status:** Ikke best practice. Felt for en valgliste uten egen komponent, som de eksisterende
  `useGetMineSynligeMiljoer` og `useGetMineTildelingsorganisasjoner`.
- **Alternativ vurdert:** gjenbruke `mineSynligeMiljoer` og la `tildelbareTilgangskoder` være porten.
  Forkastet: designet krever at valglisten bare viser miljøene brukeradministratoren administrerer.

#### Op #5: `personsubjekter` og `Personsubjekt` (finnes i !6015): rollesiden, brukeroversikten og brukersiden

**Dekker krav:** BRU-PER-ROL-001 «Vise brukere som har en aktiv rolle», «Brukere brukeradministratoren
ellers ikke kan se, vises ikke», «Åpne brukersiden …»; BRU-PER-GRU-013 «… ser personen i brukeroversikten»,
«Tildelinger i andre organisasjoner vises ikke»
**Implementeres av:** Task #3 (tilgangsfilteret), Task #5 (MR B), Task #8, #11 og #13 (fs-admin)

##### Lag A — Schema-tillegg

```graphql
extend input FeideBrukerTilgangerFilterInput {   # i praksis: nytt felt i inputen i schema_brukeradmin.graphqls
  "Vis kun tildelinger av disse tilgangskodene, direkte eller arvet."
  tilganger: [ID!] @nodeId(typeName: "Tilgangsrolle")
}

extend input PersonsubjekterFilterInput {        # MR B
  """
  Skjul personer fra andre organisasjoner som ikke har noe aktivt hos deg. En person beholdes når hen har
  minst én aktiv tildeling i en kombinasjon der du har BRUKERADMIN_PERSON_LES, eller er koblet til en
  Feide-bruker med hjemmeorganisasjon der du har privilegiet, i et miljø klassifisert som personen. `false`
  eller utelatt filtrerer ikke.
  """
  skjulInaktiveFraAndreOrganisasjoner: Boolean
}

extend type Personsubjekt {                       # MR B
  "Feide-brukerne som er koblet til personen og som du kan se. Koblingen opprettes ved pålogging med Feide."
  feideBrukere: [FeideBruker]
}
```

##### Lag B — fs-admin call-site

```ts
// RolleDetails: personene med rollen, én rad per tildeling av rollen
export const ROLLE_PERSON_LIST_FRAGMENT = gql(/* GraphQL */ `
  fragment RollePersonListFields on Personsubjekt {
    id
    navn { fornavn etternavn }
    tilganger(filter: { tilganger: [$rolleId] }, first: 50) {
      nodes { id organisasjon { id forkortelse navnAlleSprak { nb } } miljo { id navn } }
    }
  }
`)
export const GET_ROLLE_PERSONSUBJEKTER = gql(/* GraphQL */ `
  query GetRollePersonsubjekter($rolleId: ID!, $first: Int, $after: String) {
    personsubjekter(filter: { roller: [$rolleId] }, first: $first, after: $after) {
      nodes { ...RollePersonListFields @unmask }
      totalCount
      pageInfo { endCursor hasNextPage }
    }
  }
`)
// PersonbrukereOverview: personsubjekter(filter: { navnContains, roller, skjulInaktiveFraAndreOrganisasjoner: true })
// PersonDetails: node(id) { ... on Personsubjekt { id erSyntetisk navn {…} tildelingerOrganisasjoner {…} feideBrukere { id brukernavn } } }
```

##### Lag C — Begrunnelse

- **Rollesiden:** `roller` på `personsubjekter` har alt semantikken «aktiv nå, direkte eller arvet, i en
  tildeling du ser» (analysen, Current State). Det eksakte `tilganger`-filteret gir radene per tildeling.
  `tilgangskodeContains` er en delstreng og ville gitt falske rader. En variabel inne i et fragment krever at
  operasjonen deklarerer `$rolleId`. Det er lov i GraphQL, men skal verifiseres mot codegen-oppsettet.
- **Brukeroversikten:** filteret speiler `FeideBrukereFilterInput.skjulInaktiveFraAndreOrganisasjoner` med
  samme navn, så klienten koder det fast som for Feide-brukere (beslutning 25.09.2026).
- **`feideBrukere`:** koblingstabellen er lukket for app-rollen (!6014). Feltet må derfor gå gjennom en
  `SECURITY DEFINER`-mengdefunksjon som bare gir koblinger der kalleren ser både personen og Feide-brukeren.
  Elementene er `FeideBruker` per
  `fs-sikt-no-producer-schema-design §Vi følger Global Object Identification-spesifikasjonen`.
- **Colocation-status:** Følger colocation for rollesiden, som er en ny skjerm. Brukeroversikten speiler det
  eksisterende mønsteret i `PersonbrukereOverview` og bytter bare rotfelt og fragmenttype.

### Tverrgående schema-bekymringer

#### Rettighetsmodell

Basen avgjør alt (I3). Klienten gater på roller fra `mineTilganger` (`BRUKERADMINISTRASJON_LES` for sidene,
`BRUKERADMINISTRASJON_TILDELING` for knappene) og på at valglistene ikke er tomme. Serveren leverer ingen
`kan*`-flagg (`tilgangsmodell.md`, «Rettighetsgating skjer klientside»).

#### Feilunioner

| Mutasjon | Feilunion | Medlemmer |
|----------|-----------|-----------|
| `tildelPersonsubjektTilgangerMedFodselsnummer` | `TildelPersonsubjektTilgangerMedFodselsnummerError` | `ManglerTildelingsrett`, `TilgangskodeIkkeFunnet`, `UgyldigFodselsnummer`, `SyntetiskPersonIEktMiljo` |
| `tildelPersonsubjektTilganger` (!6015) | `TildelPersonsubjektTilgangerError` | som i !6015, pluss `SyntetiskPersonIEktMiljo` |

#### Sporingsfelt

Legges ikke til. Tildelingen har alt `tildeltAv` og `tildeltTidspunkt`. Hvem som opprettet personen står i
`personsubjekt.opprettet_av_*`, men eksponeres ikke, fordi det ville vise hvem som så personen først.

#### Versjonering

Alt er nytt eller additivt i experimental. Ingen `V2`.

### Åpne spørsmål

- [ ] Kan en variabel (`$rolleId`) brukes i et kolokert fragment med codegen-oppsettet i fs-admin? Ellers flyttes
      `tilganger(filter:)` inn i operasjonen. Avgjøres i Task #8.
- [ ] Ruter Graphitron RC38 `sqlState: "TS204"` med en DATABASE-handler? Det finnes forbilde: `OrganisasjonManglerFsDatakilde` ruter `sqlState: "TS001"` (`SCH/stable/feil.graphqls:127`), mens `TS201`/`TS202` ikke har noen
      graf-handler i dag. Ellers oversetter servicen TS204 til `SyntetiskPersonIEktMiljoException` med en
      GENERIC-handler, slik `PersonsubjektTilgangService.oversett` gjør. Avgjøres i Task #2.
- [ ] Hva gjør en `@service`-mutasjon på RC38 med tom input? Det er versjonsbundet
      (`fsp-mutasjonskonvensjoner` §3). Planen lover «tom liste gir tomt svar». Testen i Task #2 pinner det.

## Implementation Tasks

Repo og MR står på hver task. Rekkefølgen på MR-ene står i «MR-rekkefølge og grenstrategi» under.

### Task #1: Basen: den første tildelingen med nummer, og I4 for personer

**Repo/MR**: fs-plattform, MR A (`tilgangsstyring/personsubjekt-tilgang-med-nummer`, stablet på !6015)
**Priority**: High
**Size**: L
**Dependencies**: !6015 (grenen)
**Addresses Requirements**: BRU-PER-GRU-013 (alle reglene som ikke er `@draft`), BRU-PER-ROL-002

**Acceptance Criteria**:

- [ ] `CL/0090-tildeling-med-fodselsnummer.sql`, med include i `db-changelog-root.xml` og en
      rekkefølgekommentar etter 0087. Nummeret er sjekket ledig mot `main` og åpne MR-er rett før skrivingen.
- [ ] `opprett_person` godtar `NULL` for fornavn og etternavn. Da skrives ingen `personnavn`-rad. Testpersonaene
      og pgTAP 73 er uendret grønne.
- [ ] `tildel_person_med_fodselsnummer(p_fodselsnummer, p_rollekode, p_organisasjonskode, p_miljokode)
      RETURNS TABLE(subjekt_id BIGINT)` er `SECURITY DEFINER` med `SET search_path = tilgangsstyring, pg_temp`
      og `GRANT EXECUTE` til `${app_role}`. Sjekkene står i denne rekkefølgen:
      1. Påkrevde verdier (23502).
      2. `krev_person_tildelingsrett` (42501).
      3. `krev_tilgangskode` (P0002 «tilgangskoden …»).
      4. `auth.er_gyldig_fodselsnummer` og ikke `auth.er_fs_generert_serie` **[valg Q1]**: 22023 med meldingen
         «fødselsnummeret er ugyldig», uten nummeret.
      5. `auth.er_tenor_serie(fnr) AND NOT miljo.er_syntetisk`: TS204.
      6. Låsen `pg_advisory_xact_lock`, deretter oppslag, eller `opprett_person(fnr, NULL, NULL)`.
      7. `tildel_brukertilgang(...)`.
- [ ] `tildel_brukertilgang` (`CREATE OR REPLACE` av !6015-versjonen) avviser et mål med aktørledd `person` og
      `er_syntetisk` i et miljø med `er_syntetisk = false`, med TS204. Feide-grenen er uendret. Åpne MR-er som
      redefinerer funksjonen, er sjekket (`glab mr list`, grep i grenene).
- [ ] Ingen `RAISE`, `NOTICE` eller `WARNING` inneholder nummeret.
- [ ] pgTAP `78_tildeling_med_fodselsnummer.sql`, der summen av `plan(...)` stemmer, dekker:
  - de fem utgangspunktene i scenariomalen «Svaret er det samme …», som gir samme resultat (samme form, én
    rad, én tildeling)
  - at det ikke opprettes en ny person når hen finnes (også usynlig, også bare med inaktive tildelinger)
  - ugyldige kontrollsifre for fødselsnummer, D-nummer og et SNR-lignende nummer (ingen person, ingen
    tildeling)
  - at et FS-generert nummer avvises
  - testperson i `production` (avvist, ingen person opprettet) og i `test` (godtatt)
  - manglende rett og ukjent rolle (ingen person opprettet)
  - idempotens (samme kall to ganger gir én rad)
  - at `tildel_brukertilgang` avviser en synlig testperson i `production` med TS204

**Implementation Notes**:
Bruk kolonnene direkte (`miljo.er_syntetisk`, ikke en ny hjelpefunksjon). `krev_person_tildelingsrett` og
`krev_tilgangskode` er INVOKER-funksjoner. Under DEFINER leser de fortsatt sesjonsclaimene gjennom
`auth.orger_med_tilgang`, og det skal en pgTAP-test vise. Sporingen (`trig_set_opprettet_av`) leser
sesjonens innstillinger og får kalleren også under DEFINER. Verifiser at `opprettet_av_bruker` er
brukeradministratoren. Feilkoden TS204 legges i serien i `tilgangsstyring/CLAUDE.md`. Ikke bruk hovedklonens
database. Kjør pgTAP mot en egen Postgres.

### Task #2: Grafen: bulkmutasjonen `tildelPersonsubjektTilgangerMedFodselsnummer`

**Repo/MR**: fs-plattform, MR A
**Priority**: High
**Size**: L
**Dependencies**: Task #1
**Addresses Requirements**: BRU-PER-GRU-013, BRU-PER-ROL-002

**Acceptance Criteria**:

- [ ] SDL som i Op #1, i `SCH/experimental/schema_personsubjekt_tilgang_med_nummer.graphqls`, med
      `UgyldigFodselsnummer` og `SyntetiskPersonIEktMiljo` i experimental.
- [ ] `PersonsubjektTilgangMedFodselsnummerService`:
  - kjører hele batchen i `ctx.transactionResult`
  - kaller funksjonen per element
  - leser `personsubjekt` etter skrivingen under kallerens RLS og returnerer hele rader (gjelder et `@service`
    på toppnivå)
  - oversetter feil med samme mønster som `PersonsubjektTilgangService.oversett`
  - beskriver alt-eller-ingenting, idempotens og at nummeret aldri logges, i javadoc-en
- [ ] Nummeret logges ikke: jOOQ `executeLogging` er slått av for kallet, og ingen exception-melding bærer det.
- [ ] Records på toppnivå i `records/`. `toString` er overstyrt på input-recorden og maskerer nummeret.
- [ ] `TildelPersonsubjektTilgangerError` (!6015) får `SyntetiskPersonIEktMiljo`, og
      `PersonsubjektTilgangService` oversetter TS204.
- [ ] Graphql-testene dekker:
  - de fem utgangspunktene, med JSON-svarene sammenlignet uten id-er: like
  - delvis feil (element 2 av 3 ugyldig gir ingen rader skrevet, også ingen person opprettet for element 1)
  - tom input og null input
  - en blandet batch (ny, eksisterende og samme nummer to ganger gir to elementer med samme person)
  - rundtur: `personsubjekter[0].id` brukes i `tildelPersonsubjektTilganger`
  - en kaller uten lesetilgang får `null`-element, men tildelingen er skrevet
  - testperson i `production` gir `SyntetiskPersonIEktMiljo` både her og i `tildelPersonsubjektTilganger`
- [ ] `api-design-review` er kjørt på formen. Funnene er rettet eller begrunnet i MR-en.

**Implementation Notes**:
`@nodeId` på `tilgangId`, `organisasjonId` og `miljoId` med `@service` virker i !6015 på RC38
(`enkelt.getTilgangId().getRollekode()`). Speil det. TS204 med en DATABASE-handler er et åpent spørsmål; har
ikke Graphitron støtte for egendefinert SQLSTATE, rut via en exception med en GENERIC-handler. Ikke legg et
`errors`-felt i payload-klassen.

### Task #3: Kilder for rolleoversikten, valglistene og radene på rollesiden

**Repo/MR**: fs-plattform, MR A
**Priority**: High
**Size**: M
**Dependencies**: Task #1 (samme migrering)
**Addresses Requirements**: BRU-PER-ROL-001 (rolleoversikten, radene), BRU-PER-ROL-002 (valglistene)

**Acceptance Criteria**:

- [ ] I 0090: `mine_tildelingsorganisasjoner()` og `tildelbare_tilgangskoder(org, miljø)` tar med
      `orger_med_person_tildelingsrett()` i unionen. Ny `mine_tildelingsmiljoer(p_organisasjonskode)` gir
      miljøene med Feide- eller persontildelingsrett i organisasjonen.
- [ ] `Query.mineTildelbareTilgangsroller(filter: {rolletype})` som i Op #3: hele katalogen med personretten i
      minst ett par, ellers tom. Paginert, sortert på kode.
- [ ] `Query.mineTildelingsmiljoer(organisasjonId: ID!)` som i Op #4. En id av feil type eller en ukjent id gir en
      tom liste, ikke en feil som skiller dem.
- [ ] `FeideBrukerTilgangerFilterInput.tilganger: [ID!]` gir eksakt treff på tilgangskode, både direkte og arvet.
- [ ] Testene dekker:
  - en kaller uten rett får tom rolleliste og tomme valglister
  - en kaller med rett bare i `test` får `test` og ikke `production`
  - filteret `rolletype: ROLLE`
  - at `tilganger` ikke treffer en kode som bare inneholder den søkte (`X` mot `X_LES`)

**Implementation Notes**:
Følg «En relasjon er alt en funksjon» i `tilgangsstyring/CLAUDE.md`: rolleutvalget kan være en `@condition`
med `EXISTS` mot `orger_med_person_tildelingsrett()`, og trenger ikke en ny SQL-funksjon. `mine_tildelingsmiljoer`
eksponeres med en `@service` eller en `@condition` på `miljo` som dekoder `organisasjonId` selv, ikke med `@routine`, som binder node-id-en rått (`fsp-mutasjonskonvensjoner` §3). Sjekk at ingen åpen MR redefinerer `mine_tildelingsorganisasjoner` eller
`tildelbare_tilgangskoder`; per 07.10.2026 gjør ingen det.

### Task #4: Dokumentasjon og klargjøring av MR A

**Repo/MR**: fs-plattform, MR A
**Priority**: High
**Size**: S
**Dependencies**: Task #1–#3
**Addresses Requirements**: (dokumentasjon av GRU-013-håndhevingen)

**Acceptance Criteria**:

- [ ] `syntetiske-og-ekte-data.md`: rad I4 i «Hvor reglene håndheves» sier at `tildel_brukertilgang` håndhever
      I4 for personsubjekter (TS204) og at Feide-brukere og applikasjoner ikke er dekket ennå, med pgTAP 78 som
      test.
- [ ] `tilgangsmodell.md`, avsnittet om personsubjektet: `opprett_person` uten navn, den nye inngangen og
      rekkefølgen på sjekkene (intensjonen først, detaljene etter, ifølge RETNINGSLINJER.md). Kildene for
      valglistene oppdateres.
- [ ] `spec-personsubjekt-api.md` (!6015): iterasjon 4 er levert av MR A, med lenke.
- [ ] Utkast-MR mot !6015-grenen (target `tilgangsstyring/personsubjekt-api`), tildelt Kjetil. Jira-referansen
      står øverst i beskrivelsen, se «Blokkere».
- [ ] CI er grønn. «Tests run»-linjene er lest (`fsp-verify`), ikke bare BUILD SUCCESS.

### Task #5: Brukeroversikten og brukersiden for personer: filteret som skjuler inaktive, og koblede Feide-brukere

**Repo/MR**: fs-plattform, MR B (`tilgangsstyring/personsubjekt-oversikt`)
**Priority**: Medium
**Size**: M
**Dependencies**: !6014, MR A
**Addresses Requirements**: BRU-PER-GRU-013 «… ser personen i brukeroversikten», og den avgjorte beslutningen
om at detaljsiden viser koblede Feide-brukere

**Acceptance Criteria**:

- [ ] `PersonsubjekterFilterInput.skjulInaktiveFraAndreOrganisasjoner` (Op #5) beholder en person når:
  - hen har en aktiv tildeling i et par der kalleren har `BRUKERADMIN_PERSON_LES`, eller
  - hen er koblet til en Feide-bruker med domene i en organisasjon der kalleren har privilegiet, i et miljø
    klassifisert som personen.

  Uten filteret er listen uendret.
- [ ] `Personsubjekt.feideBrukere` gir bare gjeldende koblinger der kalleren ser både personen og
      Feide-brukeren. Koblingen lekker ikke til en kaller som bare ser den ene siden.
- [ ] `CL/0091` og pgTAP 79, der nummeret er sjekket ledig, og testene i `PersonsubjekterQueryTest.java`.
- [ ] `tilgangsmodell.md` oppdatert.

**Implementation Notes**:
Hjemmegrenen gjenbruker formen i !6014 `personer_i_mine_person_les_organisasjoner()` (`CL/0086:440-470`), men med
`gyldig_periode @> now()` på tildelingsgrenen. Filteret er et API-filter, og RLS står (beslutning 25.09.2026).
Hvis !6014 er flettet til `main` før arbeidet starter, rebases MR B på `main` og MR A. Ellers flettes !6014-grenen
inn i MR B.

### Task #6: fs-admin: sjekk av fødselsnummer, D-nummer og SNR i klienten

**Repo/MR**: fs-admin, MR 2
**Priority**: High
**Size**: S
**Dependencies**: None
**Addresses Requirements**: BRU-PER-GRU-013 «Nummer med ugyldige kontrollsifre avvises»

**Acceptance Criteria**:

- [ ] `src/domains/tilgangsstyring/utils/fodselsnummer.ts` med `erGyldigFodselsnummer(verdi)`: elleve sifre og to
      mod 11-kontrollsifre, som `auth.er_gyldig_fodselsnummer`. Den skiller ikke nummertypene.
- [ ] Unit-tester med testpersonaene, et D-nummer, et nummer med feil kontrollsiffer, ti sifre og tolv sifre.
      Mod 11-implementasjonen i `testPersonas.test.ts` byttes til utilen.

**Implementation Notes**:
Klienten avviser ikke FS-genererte numre. Det gjør API-et **[valg Q1]**, og feilen vises da som feltfeil.

### Task #7: fs-admin: rolleoversikten

**Repo/MR**: fs-admin, MR 2
**Priority**: High
**Size**: M
**Dependencies**: Task #3 (skjemaet tilgjengelig for codegen, se Task #10)
**Addresses Requirements**: BRU-PER-ROL-001 «Åpne en rolle fra rolleoversikten», «Rolleoversikten viser bare
roller …»

**Acceptance Criteria**:

- [ ] Ruten `/tilgangsstyring/roller`: tynne `layout.tsx` (brødsmule «Roller», `WithRole
      ['BRUKERADMINISTRASJON_LES']`) og `page.tsx` bak Unleash-flagget `tilgangsstyring-brukeradministrasjon`
      **[valg]**.
- [ ] `RollerOverview` lister `mineTildelbareTilgangsroller(filter: {rolletype: ROLLE})` med
      `NavigationList`/`ListItemCell`, kolonnene «Rolle» og «Beskrivelse», sortert på kode. Hele raden lenker til
      `/tilgangsstyring/roller/[id]`.
- [ ] Tom liste gir «Du har ingen roller du kan tildele.» (foreslått tekst). Lasting og feil som i
      personbrukere-listen.
- [ ] Menypunktet «Roller» i `Menu.tsx` (rollekode `BRUKERADMINISTRASJON_LES`, samme flagg) og et kort i
      `TilgangsstyringIndex`.
- [ ] `cacheConfig`-policy for `mineTildelbareTilgangsroller`, `routes.d.ts` regenerert, `.a11y.test.tsx` for
      komponentene og ruten, og unit-tester med `MockedProvider` og importerte dokumenter.

**Implementation Notes**:
Følg `fs-admin-list-pages`. Søk på rollenavn er `@draft` og bygges ikke.

### Task #8: fs-admin: rollens oversiktsside

**Repo/MR**: fs-admin, MR 2
**Priority**: High
**Size**: M
**Dependencies**: Task #3, Task #7, Task #13 (brukersiden for en person, som radene lenker til)
**Addresses Requirements**: BRU-PER-ROL-001 «Vise brukere som har en aktiv rolle», «Brukere
brukeradministratoren ellers ikke kan se, vises ikke», «Åpne brukersiden fra rollens oversiktsside»

**Acceptance Criteria**:

- [ ] Ruten `/tilgangsstyring/roller/[id]` og `RolleDetails`:
  - overskriften er rollekoden, med beskrivelsen under
  - knappen «Gi rollen til en person» er gatet på `BRUKERADMINISTRASJON_TILDELING` og på at
    `mineTildelingsorganisasjoner` ikke er tom, som `PersonbrukerRollerActionbar`
- [ ] Listen er `personsubjekter(filter: {roller: [id]})` med én rad per person og tildeling av rollen
      (`tilganger(filter: {tilganger: [id]})`), med kolonnene «Navn», «Organisasjon» og «Miljø». Personer uten navn
      vises med «Ikke logget inn ennå» (foreslått tekst).
- [ ] Hele raden åpner `/tilgangsstyring/personbrukere/[id]` for personen, der flere roller gis.
- [ ] Tom liste gir «Ingen brukere du har tilgang til, har denne rollen.» (foreslått tekst), og knappen vises
      fortsatt.
- [ ] Ingen nummer hentes eller vises. Ingen antall eller hint om brukere som ikke vises.
- [ ] Tester og a11y som for Task #7, og en integrasjonstest fra rolleoversikten via rollesiden til brukersiden.

**Implementation Notes**:
Følg `fs-admin-detail-pages`. Rollen hentes med `node(id) { ... on Tilgangsrolle { kode beskrivelse } }`. Et
fragment med variabel (`$rolleId`) er et åpent spørsmål i GraphQL-seksjonen; flytt filteret inn i operasjonen hvis
codegen klager.

### Task #9: fs-admin: dialogen «Gi rollen til en person»

**Repo/MR**: fs-admin, MR 2
**Priority**: High
**Size**: L
**Dependencies**: Task #2, Task #3, Task #6, Task #8
**Addresses Requirements**: BRU-PER-ROL-002 (hele regelen), BRU-PER-GRU-013 «Svaret avslører ikke …»,
«Nummeret vises ikke etterpå», «Nummer med ugyldige kontrollsifre avvises», «En testperson kan ikke få tilgang i
et ekte miljø», «Rolle brukeradministratoren ikke har rett til å tildele», «Personen kan ikke legges til uten en
rolle»

**Acceptance Criteria**:

- [ ] `GiRollenTilPersonModal` (`FSModal size="small"`), med overskriften «Gi rollen til en person» og «Rolle:
      {rollekode}». Feltene:
  - Organisasjon (`FSCombobox`, `mineTildelingsorganisasjoner`, låst når det er én)
  - Miljø (`FSCombobox`, `mineTildelingsmiljoer(organisasjonId)`, låst til organisasjon er valgt)
  - «Fødselsnummer, D-nummer eller SNR» (SDS `TextInput`, `inputMode="numeric"`, `autoComplete="off"`, med
    hjelpeteksten fra designet)
- [ ] Validering ved innsending:
  - «Velg organisasjon og miljø.»
  - «Oppgi fødselsnummer, D-nummer eller SNR.»
  - «Nummeret må ha 11 siffer.»
  - kontrollsifre gir «Nummeret er ikke et gyldig fødselsnummer, D-nummer eller SNR. Sjekk at det er skrevet
    riktig.»

  Alle tekstene er foreslåtte.
- [ ] «Gi rollen» sender `tildelPersonsubjektTilgangerMedFodselsnummer` med en liste med ett element.
- [ ] Ved suksess lukkes dialogen, nummeret slettes fra state, snackbaren viser «Personen har fått rollen
      {rollekode}.» uten navn, og listen lastes på nytt (`refetchQueryNames`).
- [ ] `UgyldigFodselsnummer` og `SyntetiskPersonIEktMiljo` vises som feltfeil under nummerfeltet.
      `ManglerTildelingsrett` gir «Du har ikke rettighet til å tildele i denne kombinasjonen av organisasjon og
      miljø.», og andre feil gir «Kunne ikke gi rollen. Prøv igjen senere.» i `FSModalFeedback`. Ved feil blir
      dialogen stående med verdiene.
- [ ] Nummeret havner ikke i URL, snackbar, `console` eller Apollo-cache. Mutasjonen sendes med
      `fetchPolicy: 'no-cache'`, og svaret velger bare `id`.
- [ ] Unit-tester for alle tilstandene i designet, og a11y-test.

**Implementation Notes**:
Snackbaren får ingen handlingsknapp «Åpne personen» **[valg]**. Designspørsmålet er åpent, og snackbaren kan
bare ha en knapp, ikke en lenke. Nummerfeltet vises som vanlig tekst, ikke maskert **[valg]**, som designets
tilstander forutsetter. Begge kan endres når Kjetil har svart.

### Task #10: fs-admin: codegen mot skjema som ikke er publisert

**Repo/MR**: fs-admin, MR 1 (og gjenbrukt i MR 2 og MR 3)
**Priority**: High
**Size**: S
**Dependencies**: MR A og MR B pushet
**Addresses Requirements**: (forutsetning for Task #7–#13)

**Acceptance Criteria**:

- [ ] Lokalt: `scripts/merge-subgraph-schema.mjs` mot `schema_personsubjekt*.graphqls` fra fs-plattform-grenene, og
      `GRAPHQL_SCHEMA_LOCATION=./.merged-schema.graphql npm run compile`. Fremgangsmåten står i MR-beskrivelsen.
- [ ] CI: typesjekken kjører mot en `local-supergraph.graphql` fra fs-plattform-grenen
      (`.gitlab/ci/ci-supergraph-helpers.yml`), eller så står MR-en i utkast til skjemaet er i
      `production/experimental`. Det velges når MR 1 åpnes.

**Implementation Notes**:
Utkast-MR-ene kan ikke flettes før backend er deployet til produksjon, fordi codegen bruker
`production/experimental`.

### Task #11: fs-admin: brukeroversikten viser personer

**Repo/MR**: fs-admin, MR 3
**Priority**: Medium
**Size**: M
**Dependencies**: Task #5, Task #13
**Addresses Requirements**: BRU-PER-GRU-013 «… ser personen i brukeroversikten» (alle scenarioene i «Den
første tildelingen …»), og den avgjorte beslutningen om at brukeroversikten viser personer direkte

**Acceptance Criteria**:

- [ ] `useGetPersonbrukere` spør `personsubjekter(filter: {navnContains, roller,
      skjulInaktiveFraAndreOrganisasjoner: true})`, med `cacheConfig`-policy for `personsubjekter`.
- [ ] Radene viser navn, eller «Ikke logget inn ennå», og organisasjonene. Feide-filtrene brukernavn,
      hjemmeorganisasjon og status fjernes fra oversikten. Det gjør også MSW-/testdataene for dem.
- [ ] En rad åpner `/tilgangsstyring/personbrukere/[id]` med personens id.
- [ ] Testene, integrasjonstesten fra liste til detalj og a11y er oppdatert.

**Implementation Notes**:
MR 3 slippes sammen med kjøringen av migreringsskriptet i !6014, miljø for miljø. Uten skriptet forsvinner
Feide-brukere med roller på Feide-brukeren fra oversikten. Avtal kjøringen med den som eier skriptet.

### Task #12: fs-admin: «Tildel roller» og «Fjern roller» for en person

**Repo/MR**: fs-admin, MR 1
**Priority**: High
**Size**: M
**Dependencies**: Task #13, !6015 (og `SyntetiskPersonIEktMiljo` fra Task #2)
**Addresses Requirements**: BRU-PER-GRU-013 «Flere tilganger legges til fra brukersiden etter den første
rollen», BRU-PER-ROL-001 «Åpne brukersiden …» (andre del), BRU-PER-ROL-002 «Flere roller gis etterpå fra
detaljsiden for personen»

**Acceptance Criteria**:

- [ ] `TildelRolleModal` og `FjernRolleModal` tar et mål som er enten en Feide-bruker eller en person. For en
      person bruker de `tildelPersonsubjektTilganger` (alias-batch som i `useTildelFeideBrukerTilganger`) og
      `fjernFeideBrukerTilganger` (felles for begge). Feide-varianten er uendret.
- [ ] Feilrutingen tar med `PersonsubjektIkkeFunnet` og `SyntetiskPersonIEktMiljo`. Tekstene er de eksisterende
      i `PersonbrukerTildelRolleModal`, pluss teksten om testperson fra GRU-013-designet.
- [ ] Etter tildeling og fjerning lastes personens tilganger på nytt (`refetchQueryNames`).
- [ ] Testene for modalene dekker personvarianten. Feide-testene er uendret grønne.

### Task #13: fs-admin: brukersiden for en person

**Repo/MR**: fs-admin, MR 1
**Priority**: High
**Size**: M
**Dependencies**: !6015 (MR B for de koblede Feide-brukerne)
**Addresses Requirements**: BRU-PER-ROL-001 «Åpne brukersiden fra rollens oversiktsside», BRU-PER-GRU-013
«Tildelinger i andre organisasjoner vises ikke», «Nummeret vises ikke etterpå» (detaljsiden)

**Acceptance Criteria**:

- [ ] `/tilgangsstyring/personbrukere/[id]` slår opp `node(id)` og viser `PersonDetails` for `Personsubjekt` og
      dagens `PersonbrukerDetails` for `FeideBruker`. Ukjent eller usynlig id gir `NotFoundError`.
- [ ] `PersonDetails` (`DetailPageLayout`):
  - topplinjen viser navn, eller «Ikke logget inn ennå», og eventuelt merket for testperson (`erSyntetisk`)
  - fanen «Detaljer» viser organisasjoner og miljøer fra tildelingene
  - fanen «Roller» gjenbruker rollelisten over `Personsubjekt.tilganger` med handlingslinjen fra Task #12
  - Feide-brukerne som er koblet til personen, vises og lenker til Feide-siden, når `Personsubjekt.feideBrukere`
    finnes (MR B). Før det vises seksjonen ikke.
- [ ] Ingen nummer hentes eller vises. Bare tildelinger kalleren ser, vises (RLS).
- [ ] Tester og a11y.

**Implementation Notes**:
Gjenbruk komponentene i `PersonbrukerDetails` der de bare leser `FeideBrukerTilgang`, og skill ut det som er
Feide-spesifikt (brukernavn, status, deaktivering). Personen har ingen deaktivering.

## MR-rekkefølge og grenstrategi

| # | Repo | Gren | Mål | Innhold | Forutsetter |
|---|------|------|-----|---------|-------------|
| 1 | fs-plattform | `tilgangsstyring/personsubjekt-inflight-migrering` (!6014) | `main` | koblingen og hjemorganisasjonsgrenen | |
| 2 | fs-plattform | `tilgangsstyring/personsubjekt-api` (!6015) | `main` | personsubjekt-API-et | |
| 3 | fs-plattform | `tilgangsstyring/personsubjekt-tilgang-med-nummer` (MR A) | !6015-grenen, så `main` | Task #1–#4 | 2 |
| 4 | fs-plattform | `tilgangsstyring/personsubjekt-oversikt` (MR B) | MR A-grenen, så `main` | Task #5 | 1, 3 |
| 5 | fs-admin | `tilgangsstyring/personsubjekt-brukerside` (MR 1) | `main` | Task #10, #13, #12 | 2 og 3 i `production/experimental` |
| 6 | fs-admin | `tilgangsstyring/rolleside` (MR 2) | `main` | Task #6–#9 | 3, MR 1 |
| 7 | fs-admin | `tilgangsstyring/personbrukere-personer` (MR 3) | `main` | Task #11 | 4, MR 1, kjøring av migreringsskriptet |

- MR A og MR B stables og målrettes mot grenen under, og målet byttes til `main` når grenen under er flettet.
  !6014 og !6015 er søsken. Er de fortsatt åpne, flettes !6014 inn i MR B-grenen.
- !6014 og !6015 endrer begge `tilgangsmodell.md` og `db-changelog-root.xml`. Den som flettes sist, rebaser.
  Etter hver rebase sjekkes det at grenens egne filer er bit-identiske med forrige hode
  (`fsp-mutasjonskonvensjoner` §6).
- Migreringsnumrene (0090, 0091) og pgTAP-numrene (78, 79) sjekkes på nytt før hver MR. !6064 og !6067 kolliderer
  på 0089 og kan flytte seg.
- Alt arbeid ender i utkast-MR-er tildelt Kjetil. Grenene er nye. Ingen push til `main`.

## Risk Assessment

### Technical Risks

- **Risiko: Operasjonen blir et eksistensorakel** gjennom feilrekkefølge, ulik svartid, ulik svarform eller
  feilmeldinger.
  - **Tiltak**: alle avvisninger avgjøres før oppslaget. Testene sammenligner JSON-svarene for de fem
    utgangspunktene. Feilene har konstante meldinger. Svartiden er ikke målt; et oppslag mot en unik indeks
    gir ubetydelig forskjell, men det er ikke bevist.
- **Risiko: Nummeret lekker til logger** (jOOQ-bindverdier, exception-meldinger, Quarkus-logg, Apollo-cache i
  klienten).
  - **Tiltak**: Task #2 slår av `executeLogging` for kallet og maskerer `toString`. Task #9 bruker `no-cache` og
    rydder state. Revieweren sjekker logg-nivåene i `application.properties`.
- **Risiko: `SECURITY DEFINER` gir mer enn tiltenkt.**
  - **Tiltak**: funksjonen sjekker retten først med den samme `krev_person_tildelingsrett` som !6015, har
    `SET search_path`, og gir bare tilbake `subjekt_id`. Tildelingen går gjennom `tildel_brukertilgang`, slik at
    rett og I4 måles to ganger. pgTAP viser at en kaller uten rett ikke oppretter noe.
- **Risiko: Bulk gir én feil for hele kallet** (Graphitron `@service`).
  - **Tiltak**: dokumentert i mutasjonsbeskrivelsen og i javadoc-en, og bevist med en test for delvis feil.
    fs-admin sender ett element fra rollesiden, og alias-batch fra brukersiden.
- **Risiko: Graphitron RC38: tom input, `@nodeId` med `@service`, egendefinert SQLSTATE i en DATABASE-handler.**
  - **Tiltak**: testene pinner oppførselen. Faller noe, brukes exception-ruten. RC40 (!6050) er ikke en forutsetning
    og skal ikke trekkes inn.
- **Risiko: SNR overlapper FS-generatorens serie, og avvisningen av FS-genererte numre **[valg Q1]** avviser da SNR.**
  - **Tiltak**: regelen står på én linje i funksjonen, og testene har et SNR-lignende nummer utenfor serien.
    Kjetil bekrefter serien før MR A er klar for review.
- **Risiko: Brukeroversikten mister Feide-brukere** mellom MR 3 og kjøringen av migreringsskriptet.
  - **Tiltak**: MR 3 slippes sammen med skriptkjøringen per miljø (Task #11).
- **Risiko: Personer gitt med nummer får ikke navn når de logger inn med Feide** (!6014 kopierer navnet bare når
  den oppretter personen).
  - **Tiltak**: utenfor kravene (`@draft`). Anbefaling: en oppfølger i !6014 eller en egen MR som kopierer navnet
    når en person uten navn kobles (Q5). Til da viser listene «Ikke logget inn ennå».
- **Risiko: fs-admin kan ikke flettes før backend er i produksjon** (codegen mot `production/experimental`).
  - **Tiltak**: Task #10. Utkast-MR-er med lokal supergraf.
- **Risiko: Kollisjon med !6067 og !6064** på `db-changelog-root.xml`, `syntetiske-og-ekte-data.md` og numrene.
  - **Tiltak**: avtal med Martin Skurtveit (!6067) og forfatteren av !6064 (alfle) før skrivingen. Rebase og nummersjekk før hver push.
- **Risiko: ROL-001 «noen, men ikke alle» kan ikke verifiseres** (modellen har ingen rett per rolle).
  - **Tiltak**: flagget i analysen. `bat-verify` merker scenarioet som ikke reproduserbart til modellen har rett
    per rolle.

### Testing Requirements

- pgTAP 78 (Task #1) og 79 (Task #5), der summen av `plan(...)` stemmer med totalen.
- Graphql-tester i Quarkus (Task #2, #3, #5) mot en egen Postgres og fast testport, ikke hovedklonens database:
  - de fem utgangspunktene
  - delvis feil
  - tom og null input
  - blandet batch
  - rundtur
  - kaller uten lesetilgang
  - testperson i ekte miljø i begge mutasjonene
- fs-admin: Jest-unit-tester, `*.a11y.test.tsx` for hver ny komponent og rute, og integrasjonstesten fra
  rolleoversikten via rollesiden til brukersiden. Codegen og typesjekk mot skjemaet fra Task #10.
- Manuell sjekk i et testmiljø før `bat-verify`: gi rollen med et syntetisk nummer i `test`, og forsøk i
  `production` med en testperson.

## Success Criteria

- [ ] Alle akseptansekriteriene er oppfylt.
- [ ] Alle tester er grønne, og «Tests run»-linjene er lest (`fsp-verify`).
- [ ] Koden følger `tilgangsstyring/CLAUDE.md`, RETNINGSLINJER.md, mutasjonskonvensjonene og fs-admin `CLAUDE.md`.
- [ ] Alle `@must`-scenarioene i ROL-001, regelen `@must` i ROL-002 og reglene i GRU-013 som ikke er `@draft`, har
      en task. «Noen, men ikke alle» i ROL-001 er bare dekket så langt modellen rekker (se risikoene).
- [ ] `api-design-review` er kjørt på MR A og MR B.
- [ ] Tekstene er godkjent av Kjetil før fs-admin-MR-ene går ut av utkast.

## Requirements Traceability

| Krav | Scenario / regel | Task(s) | Status |
|------|------------------|---------|--------|
| BRU-PER-ROL-001 | Åpne en rolle fra rolleoversikten | #3, #7 | Planned |
| BRU-PER-ROL-001 | Rolleoversikten viser bare roller brukeradministratoren har rett til å tildele | #3, #7 | Planned (begrenset av modellen) |
| BRU-PER-ROL-001 | Vise brukere som har en aktiv rolle (direkte og arvet) | #3, #8 | Planned |
| BRU-PER-ROL-001 | Brukere brukeradministratoren ellers ikke kan se, vises ikke | #8 (RLS i !6015) | Planned |
| BRU-PER-ROL-001 | Åpne brukersiden fra rollens oversiktsside | #8, #12, #13 | Planned |
| BRU-PER-ROL-002 | Personen finnes ikke / finnes, men brukeradministratoren ser hen ikke | #1, #2, #9 | Planned |
| BRU-PER-ROL-002 | Valglistene for organisasjon og miljø; organisasjonen er gitt når det er én | #3, #9 | Planned |
| BRU-PER-ROL-002 | Bare rollen på siden gis | #9 | Planned |
| BRU-PER-ROL-002 | Flere roller gis etterpå fra detaljsiden for personen | #12, #13 | Planned |
| BRU-PER-GRU-013 | Den første tildelingen …: alle scenarioene og scenariomalen for nummertype | #1, #2, #9, #11 | Planned |
| BRU-PER-GRU-013 | Flere tilganger legges til fra brukersiden etter den første rollen (`265163b`) | #12, #13 | Planned |
| BRU-PER-GRU-013 | Personen kan ikke legges til uten en rolle | #1, #9 | Planned |
| BRU-PER-GRU-013 | Svaret avslører ikke om personen fantes fra før; tildelinger i andre organisasjoner vises ikke | #1, #2, #9, #13 | Planned |
| BRU-PER-GRU-013 | Nummeret vises ikke etterpå | #2, #8, #9, #11, #13 | Planned |
| BRU-PER-GRU-013 | Nummeret må ha gyldige kontrollsifre | #1, #2, #6, #9 | Planned |
| BRU-PER-GRU-013 | En testperson kan ikke få tilgang i et ekte miljø | #1, #2, #9, #12 | Planned |
| BRU-PER-GRU-013 | Brukeradministratoren kan bare gi roller hen har rett til å tildele | #1, #2 | Planned |
| (avgjort) | Brukeroversikten viser personer direkte, og detaljsiden viser koblede Feide-brukere | #5, #11, #13 | Planned |

## Valg tatt i stedet for spørsmål

`bat-analyze` og `bat-plan` ville ha spurt om disse. Kjørt som agent uten tilgang til Kjetil.

1. **`spec.local.md`**: `folder` byttet fra `docs/specs/idporten-brukere-i-tilgangsstyring` til denne featuren,
   med `domain`, `spec_dir` og `role: backend`. Analysen og planen dekker begge repoer, og publiseres under
   `backend/`.
2. **Etter analysen**: de åpne spørsmålene ble ikke gått gjennom med brukeren. Valgene står her.
3. **Q1, FS-genererte numre**: avvises med samme feil som et ugyldig nummer. Begrunnelsen er
   `tilgangsstyringsidentitet.md` («kan ikke nøkle en person») og !6014. Det kan endres til (c), godta, hvis SNR
   viser seg å ligge i serien.
4. **Q2, ekte person i et testmiljø**: avvises ikke nå. Det står åpent i kravet, og I1 holder den ekte personen
   ute av tokenet i syntetiske miljøer uansett.
5. **Q3, rolleoversikten**: `rolletype` ROLLE fra hele katalogen med personretten.
6. **Q4, Feide-brukere på rollesiden**: bare personer.
7. **Q5, navn ved kobling**: utenfor planen. Anbefalt som oppfølger.
8. **Q6, I4**: i `tildel_brukertilgang`, bare for personer.
9. **Q7, tekster**: designforslagene brukes som de står og er merket «foreslått tekst».
10. **Snackbaren**: ingen «Åpne personen»-knapp. **Nummerfeltet**: ikke maskert.
11. **Feature-flagg**: gjenbruk `tilgangsstyring-brukeradministrasjon` for rollesidene, ikke et nytt Unleash-flagg.
12. **Grenstrategi**: ny gren stablet på !6015 (MR A), og en egen MR B for det som trenger !6014.
13. **Bulk**: alt-eller-ingenting med én typet feil, fordi Graphitron ikke kan gi feil per element fra en
    `@service`.

## Blokkere

- **Jira-referanse**: CLAUDE.md krever en sak øverst i MR-beskrivelsen. !6014 og !6015 bruker BAT-257
  (iterasjon 2 og 3). Bruker iterasjon 4 også BAT-257, eller får den en egen BAT-sak? Avklares før MR A åpnes.
- **fs-admin-klonen**: den lokale `main` i `C:/Users/kjetihoy/dev/fs-admin` har divergert (2769 foran og 13 bak
  `origin/main`) og har seks endrede filer. Arbeidet må gjøres i en egen worktree eller en ny klone fra
  `origin/main`, ikke på den lokale `main`.
- **Codegen**: fs-admin-MR-ene kan ikke bli grønne i CI før backend er i `production/experimental`, eller CI pekes
  mot en lokal supergraf (Task #10).
- **Ikke blokkerende, men avklares før review**: SNR-serien (Q1) og tekstene (Q7).

## Cross-contributor

- **frontend (fs-admin)**: Task #6–#13. Blokkeres av MR A og MR B i et skjema codegen kan lese.
- **Martin Skurtveit (BAT-262, !6067)**: migreringsnummer og `syntetiske-og-ekte-data.md` deles. Blokkerer ikke, men
  må koordineres før push.
- **Eieren av migreringsskriptet i !6014**: kjøringen per miljø må følge MR 3 (Task #11).
- **Kjetil**: tekstene, Q1–Q6 og Jira-saken.
