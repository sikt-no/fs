# Plan: ID-porten-autentisering og personer uten Feide (iterasjon 2)

Bygger på [`analysis-idporten-fs-admin-fase1-v2.md`](analysis-idporten-fs-admin-fase1-v2.md) og
delta-spec-en [`spec-changes-2026-09-23-idporten-personsubjekt.md`](../spec/spec-changes-2026-09-23-idporten-personsubjekt.md)
(TIL-PÅL-PÅL-003 endret, BRU-PER-GRU-013 ny). Iterasjon 1 ([`plan-idporten-fs-admin-fase1.md`](plan-idporten-fs-admin-fase1.md),
Task #1–#7) er levert og står.

Planen er skrevet etter at branchen `BAT-239-idporten-coprocessor` ble rebaset på main 2026-09-24.
Main hadde fått `0072`–`0076`, og det flyttet to premisser fra analysen. Begge er tatt inn her:

- **0075 klassifiserer mennesker datadrevet.** `subjekt_er_person()` er sann for alle typer med
  `aktorledd = 'bruker'`, og policyene gir dem Feide-nøklene. Uten et grep arver `person` dermed
  Feide-rettighetene. Navnet `subjekt_er_person` er også tatt, med betydningen «menneske».
- **0076 matcher synlighet på paret (miljø, organisasjon).** Personsynligheten må følge samme regel.

I tillegg er **Min Kompetanse tatt inn i scope som noe planen skal legge til rette for**
(2026-09-24). Studenter og sluttbrukere skal logge inn med ID-porten, uten lagrede tildelinger, og
bare få gulvet. Det bekrefter beslutning (c) i analysen, egen `idporten_applikasjon` med eget tak.
Taket kopieres fra den tilsvarende Feide-appen og lagres i `applikasjon_brukerdelegering`. Se
beslutning 3 og 4, og gjennomgangen i `questions-bat-plan-2026-09-24.md` (blokk 5–10).

**Oppdatert 2026-09-24 (iterasjon 3)** mot [`analysis-idporten-fs-admin-fase1-v3.md`](analysis-idporten-fs-admin-fase1-v3.md)
og delta-spec-en [`spec-changes-2026-09-24-idporten-min-kompetanse.md`](../spec/spec-changes-2026-09-24-idporten-min-kompetanse.md),
som tar TIL-PÅL-PÅL-004 inn i flyten. Arkitekturen står uendret. Tilgangsformelen gir allerede 004,
og planen legger til tester og tre presiseringer i Task #5, #7, #8 og #12:

- en registrert person via Min Kompetanse får rollene sine begrenset av taket, pluss gulvet,
- en deaktivert ID-porten-app gir tomt resultat,
- og kommentarene som kaller åpne roller for «gulvet», rettes.

Ved rebasen fikk `0072-apne-roller-uten-tildelinger.sql` nummer `0077`, og den ucommittede
personsubjekt-migreringen ble `0078` (test `69_personsubjekt.sql`). Numrene under er forslag som
fortsetter derfra.

## Proposed Solution

### Architecture Approach

Tre flater endres, og alle står i `fs-plattform/tilgangsstyring`:

1. **Rettighetsmodellen** (`tilgangsstyring-new-db`). Personer uten Feide får en egen
   privilegiefamilie, `BRUKERADMIN_PERSON_LES/_SKRIV/_TILDELING_SKRIV`. Tildelingspolicyene
   velger nøkkelsett per menneskelig subjekttype og er lukket for ukjente typer. Personsubjektet
   (dagens 0078) skrives om til å bruke personnøklene. En definer-funksjon `registrer_person`
   blir den eneste inngangen for å registrere og tildele.
2. **Innloggingen** (`tilgangsstyring-app`, coprocessoren). Ved ID-porten-innlogging slås
   personen opp på `pid` og appen på ID-porten-`client_id` i `idporten_applikasjon`. Tilgangen
   regnes deretter nøyaktig som for Feide-brukere, med `tilganger_for_bruker`:
   `(tak ∩ (tildelinger ∪ gulv)) ∪ åpne − nekt`. Audiensen håndheves, og en manglende verdi
   stopper oppstarten.
3. **Grafflaten** (`tilgangsstyring-service` + `schema_brukeradmin.graphqls`). Typen `IdPortenBruker`
   får en parallell flate til `FeideBruker`: søk, tilgangsliste, registrering og tildel/fjern.
   Det finnes ingen slett-mutasjon.

Rekkefølgen i databasen er styrt: **typesplitten i policyene lander før typen `person` finnes.**
Da er splitten en ren refaktorering mens den er beviselig uten effekt, samme argument som 0075
selv bruker. Legges `person` inn først, gir den stille Feide-nøkler.

### Key Technical Decisions

1. **Personnøkler velges per type, lukket.** Policyene på `subjektrolletildeling` får tre grener:
   `NOT subjekt_er_person` gir applikasjonsnøklene (uendret), `subjekt_type = 'feide_bruker'` gir
   `FEIDEBRUKER_*`, og `subjekt_type = 'person'` gir `PERSON_*`. En menneskelig type uten egen
   gren treffer ingen nøkkel og avvises.
   - *Hvorfor:* kravet om atskilte rettigheter (BRU-PER-GRU-013) gjelder begge retninger.
     Lukket for ukjente typer tar vare på poenget med 0075: en ny persontype kan ikke få
     rettigheter stille. Hun får ingen i stedet for Feide-rettighetene.
   - *Vurdert:* en datadrevet familie via en kolonne på `subjekttype`. Det er ny mekanikk for to
     typer. Fire kopier av samme grenpar løses med én hjelpefunksjon per privilegieledd (se
     Task #2).

2. **Egen privilegiefamilie og egne forretningsroller** (0052–0059-mønsteret).
   - Privilegier: `BRUKERADMIN_PERSON_LES`, `_SKRIV`, `_TILDELING_SKRIV` (navnerom `tilgangsstyring`).
   - Forretningsroller, foreslåtte navn som bekreftes i Task #1: `PERSONADMINISTRATOR` (`fs`),
     som impliserer `PERSONADMINISTRASJON` (`fs-admin`), som igjen impliserer
     `PERSONADMINISTRASJON_LES/_SKRIV/_TILDELING`, som impliserer privilegiene.
   - Rollene impliseres **ikke** av `BRUKERADMINISTRASJON_*` (beslutning (a) i analysen).
   - Rollene legges i FS Admins delegeringstak (0059-mønsteret). Uten det er de døde i flaten,
     fordi `tilganger_for_bruker` snitter med taket.

3. **Egen `idporten_applikasjon`, med tak i `applikasjon_brukerdelegering`.** Dette bekrefter
   (c) i analysen.
   - `idporten_applikasjon` er en ny apptype og subjekttype (`aktorledd = 'applikasjon'`), som
     `maskinporten_applikasjon`. Den har én rad per app og ID-porten-miljø: «FS Admin (test)»,
     «Min kompetanse (test)», og prod-radene når Digdir-klientene finnes. Raden er nøklet på
     ID-portens `client_id` (unik) og har navn, eierorganisasjon, ansvarlig, sporing og deaktivering.
   - Coprocessoren slår opp appen på `client_id`, på samme måte som Feide-stien slår opp på
     `service_id`. Tokenet har ikke noen annen appidentitet. ID-porten støtter ikke token exchange
     og har ikke `act` (docs.digdir.no), og `aud` og `consumer` er like for begge appene.
   - Taket lagres i `applikasjon_brukerdelegering`. FK-en løsnes fra `feide_applikasjon` til en
     kompositt-FK `(subjekt_id, subjekt_type)` mot `subjekt`, med
     `CHECK (subjekt_type IN ('feide_applikasjon', 'idporten_applikasjon'))`.
     `raa_delegeringstilganger` og `tilganger_for_bruker` er uendret. `applikasjon_er_deaktivert`
     får en gren for den nye tabellen.
   - Taket til en `idporten_applikasjon` kopieres fra den tilsvarende Feide-appen i migreringen som
     oppretter raden (0059-mønsteret, oppslag på `service_id`). Deretter er de to takene uavhengige.
     Det er med vilje: de skal sannsynligvis være like, men de skilles for ordens skyld.
   - Forvaltnings-API-et for taket (0048) forblir Feide-only. ID-porten-taket endres via migrering
     til forvaltningen er avklart (se åpent punkt T1).
   - En ukjent `client_id` gir ingen app, altså tomt tak og bare åpne roller, som en ukjent
     Feide-`service_id`. Det logges som advarsel og telles i metrikken.
   - *Vurdert:* konfigurasjonskart `client_id` → `service_id` (legger appidentitet utenfor
     tilgangsmodellen, og FS Admin og Min Kompetanse får ikke egne tak), en kolonne
     `idporten_client_id` på `feide_applikasjon` (samme innvending), og en egen taktabell (to
     eksemplarer av takmekanismen).

4. **Ingen særregel for uregistrerte personer: taket avgjør.** En ukjent person gir `NULL` som bruker
   i `tilganger_for_bruker`, altså `(tak ∩ gulv) ∪ åpne`, akkurat som en ukjent Feide-bruker.
   - Gulvet er miljøvidt (`bruker_grunntilgang` har ikke noe subjekt). Det finnes altså ett gulv, og
     appen påvirker det bare gjennom taket.
   - FS Admins tak inneholder ikke gulvrollene (eksempeldata: `saksbehandler` mot gulvet `student`),
     så en uregistrert FS Admin-bruker får bare åpne roller, som TIL-PÅL-PÅL-003 krever. Kopien av
     taket til ID-porten-appen arver det.
   - Min Kompetanse har `student` i taket, så studenter og sluttbrukere via ID-porten får gulvet uten
     at noe lagres om dem.
   - *Konsekvens:* at en uregistrert person ikke får organisasjonstilganger i FS Admin, hviler på at
     FS Admins tak aldri får gulvroller. Regelen dokumenteres. Den festes bevisst ikke med noen
     test eller sperre (besluttet 2026-09-24), og den samme risikoen gjelder Feide-taket i dag.
   - *Vurdert:* å avskjære gulvet for uregistrerte i funksjonen. Det ville gjort Min Kompetanse feil
     og gitt ID-porten en annen formel enn Feide.
   - *Registrert person via Min Kompetanse* (delta-beslutning 2, 2026-09-24): samme formel med personen
     som bruker gir `(MK-tak ∩ (tildelinger ∪ gulv)) ∪ åpne − nekt`. En saksbehandler med roller fra
     FS Admin får altså bare det Min Kompetanses tak bærer. Det trengs ingen egen logikk, bare tester
     (Task #5 og #7). Scenariet er ikke skrevet inn i 004 ennå (analyse v3, spørsmål 2).
   - *Deaktivert ID-porten-app* gir tomt resultat, ikke åpne roller, samme veto som for Feide-apper
     (analyse v3, spørsmål 1). En ukjent `client_id` gir derimot åpne roller (004 regel 3).
   - *Begrepet:* «gulvet» er `bruker_grunntilgang` (grunntilgangen i 004). De åpne rollene er en egen
     dimensjon utenfor taket (delta-beslutning 1).

5. **`registrer_person` er én definer-operasjon med ubetinget portsjekk først.**
   - Signaturen er `registrer_person(fnr, fornavn, etternavn, rollekode, organisasjonskode, miljokode)`.
   - Funksjonen krever både `_SKRIV` og `_TILDELING_SKRIV` i (org, miljø) **før** fødselsnummeret
     slås opp. Så finner eller oppretter den personen, og tildeler i samme transaksjon.
   - For en kjent person ignoreres navnet. `23505` når aldri kalleren.
   - Den erstatter `opprett_personsubjekt`.
   - *Hvorfor:* utfallet er det samme for ny og kjent person, så det finnes ikke noe orakel.

6. **Egne tildelingsfunksjoner for personer.** `tildel_persontilgang` / `fjern_persontilgang`
   speiler 0057-kroppene med `krev_person_tildelingsrett` + `krev_personsubjekt`.
   `tildel_brukertilgang` / `fjern_brukertilgang` blir uendret og Feide-only.
   - *Hvorfor:* en parallell flate uten gjenbruk av Feide-grenen, og feilkontrakten (42501,
     P0002, meldingene) beholdes for den nye grafflaten.

7. **Fødselsnummervalideringen i service-laget, med en delt `Fodselsnummer`.** Klassen flyttes fra
   `tilgangsstyring-app/…/coprocessor` til `tilgangsstyring-service`.
   - Godtatt: ordinære fødselsnumre og D-numre med gyldige kontrollsifre, og Tenor-serien
     (måned + 80).
   - Avvist: FS-genererte numre (måned + 50) og alt annet.
   - Databasen beholder formsjekken.

8. **Audiens: påkrevd og fail-closed, ID-porten av i produksjon.**
   - `quarkus.oidc.idporten(-test).token.audience` settes fra en påkrevd verdi.
   - `tilgangsstyring.issuer.idporten` blir `Optional`, som `-test`. Er utstederen satt uten
     audiens, stopper oppstarten.
   - `application-platon-production.properties` får ingen ID-porten-tenant før Digdir-verdien finnes.

9. **Navn: basen navngir subjektet, API-et navngir bruksområdet.** Basen beholder `person`,
   `personsubjekt` og `BRUKERADMIN_PERSON_*`. API-et bruker `IdPortenBruker`. Typetesten for
   `person` heter **ikke** `subjekt_er_person` (tatt av 0075), men testes inline på `subjekt_type`
   i grenen, eller som `subjekt_er_personsubjekt`. Skillet dokumenteres i `docs/tilgangsmodell.md`.

10. **Ingen slett-mutasjon.** App-rollen beholder DELETE på `personsubjekt`, som en opprydningssti
    utenfor API-et. En administrator fjerner bare tildelinger.

### File Changes Overview

**`tilgangsstyring-new-db`, nye migreringer (numre fortsetter etter 0077):**

- `0078-privilegier-person.sql`: privilegiene, forretningsrollene, navnerom, implikasjoner,
  chokepoint-funksjonene og FS Admin-taket. **Ny.** Dagens ucommittede `0078-personsubjekt.sql`
  flyttes til 0080.
- `0079-tildelinger-typesplitt-person.sql`: DROP + CREATE av de fire
  `subjektrolletildeling`-policyene med typegrener, `tildel_persontilgang` / `fjern_persontilgang`,
  og persongren i `tildelbare_tilgangskoder` / `mine_tildelingsorganisasjoner`.
- `0080-personsubjekt.sql`: dagens 0078, omskrevet. RLS på PERSON-nøklene med (miljø, org)-par,
  og `opprett_personsubjekt` fjernet.
- `0081-registrer-person.sql`: `registrer_person` + GRANT.
- `0082-idporten-applikasjon.sql`: subjekttypen og tabellen `idporten_applikasjon`, den løsnede
  FK-en på `applikasjon_brukerdelegering`, en gren i `applikasjon_er_deaktivert`, og eksempeldata
  for FS Admin (test) og Min Kompetanse (test) med taket kopiert fra Feide-appen.
- `0083-tilganger-for-idporten-bruker.sql`: `tilganger_for_idporten_bruker(env, client_id, fnr)`
  med GRANT til coprocessor-rollen.
- `db-changelog-root.xml`: includes.
- `src/test/sql/`: `69_personsubjekt.sql` justeres, pluss nye `70_`–`74_`. Justeringene i 26 og 62
  beholdes.

**`tilgangsstyring-new-jooq`:** regenereres, uten kodeendring.

**`tilgangsstyring-service`:**

- `BrukerdelegeringForvaltningService.java`: setter `SUBJEKT_TYPE = 'feide_applikasjon'` eksplisitt
  ved innsetting, eller lener seg på DEFAULT. Oppførselen er ellers uendret.

- `Fodselsnummer.java`, flyttet fra app (+ test).
- Nye filer: `IdPortenBrukerRegistreringService.java`, `IdPortenBrukerTilgangService.java`,
  `IdPortenBrukereFilterConditions.java`, `IdPortenBrukerIkkeFunnetException.java`,
  `UgyldigFodselsnummerException.java`.

**`tilgangsstyring-app`:**

- `coprocessor/CoprocessorService.java`: ID-porten-grenen kaller personoppslaget.
- `coprocessor/TilgangsstyringDataTilgangerService.java`: `tilgangerForIdportenBruker(env, clientId, nin)`.
- `coprocessor/BearerTokenAuthenticator.java`: `idporten`-utstederen blir `Optional`.
- Oppstartsvalidering for audiens: ny klasse, eller i `BearerTokenAuthenticator`.
- `application*.properties`: audiens. Produksjonsprofilen mister ID-porten-tenantene.
- `schema/features/experimental/schema_delegeringstak.graphqls`: stien i
  `FeideApplikasjon.brukerdelegeringer` (linje 174) legges om fra
  `fk_applikasjon_brukerdelegering_app` til den nye kompositt-FK-en via `subjekt`.
- `schema/features/experimental/schema_brukeradmin.graphqls`: ny sone for `IdPortenBruker`
  (se GraphQL-endringer).
- Tester: `IdportenCoprocessorTest`, `CoprocessorResourceTest`, nye GraphQL-tester for flaten.

**`docs/`:** `tilgangsmodell.md` (subjekttypen `person`, typesplitten, ID-porten som innloggingsmåte
med egen `idporten_applikasjon` og kopiert tak, taket som port for uregistrerte, restlekkasjen ved gjenregistrering,
begrensninger) og `tidsbudsjett.md` (hvis målingen gir grunn til det).

## GraphQL-endringer

> **Premiss:** konservativ. En parallell flate til `FeideBruker` med samme mønstre og ingen nye
> abstraksjoner.
> **Domeneterm:** `IdPortenBruker` (besluttet 2026-09-23 i analysen). Basen sier `person` /
> `personsubjekt`, se beslutning 9.
> **Følger fra:** [`analysis-idporten-fs-admin-fase1-v2.md`](analysis-idporten-fs-admin-fase1-v2.md),
> funn 3, 4, 5, 10 og 11 og beslutningen om GraphQL-form.
> **Mottaker:** skjemaet er tilgangsstyring-subgrafens eget (experimental). Konsumenten er fs-admin.

### Sammendrag

- 1 ny query (`idPortenBrukere`) + 1 nytt connection-felt (`IdPortenBruker.tilganger`)
- 3 nye mutations (`registrerIdPortenBruker`, `tildelIdPortenBrukerTilganger`, `fjernIdPortenBrukerTilganger`)
- 2 nye Node-typer (`IdPortenBruker`, `IdPortenBrukerTilgang`), 2 nye feiltyper (`UgyldigFodselsnummer`,
  `IdPortenBrukerIkkeFunnet`), og nye inputs, payloads og error-unioner
- 3 åpne spørsmål (se nederst)

### Operasjoner

#### Op #1: `idPortenBrukere` — søk og oversikt

**Dekker krav:** BRU-PER-GRU-013 (synlighet: «finner personen», «uten rettighet finner ingen»)
**Implementeres av:** Task #9

##### Lag A — Schema-tillegg

```graphql
"""
En person uten Feide-konto som logger inn med ID-porten. Registreres av en administrator på
fødselsnummer før første innlogging. Synlig for deg når personen har minst én tildeling i en
(organisasjon, miljø) der du har lesetilgang til personadministrasjon. En person uten
tildelinger er ikke synlig for noen.
"""
type IdPortenBruker implements Node
    @table(name: "personsubjekt")
    @node(typeId: "20022", keyColumns: ["SUBJEKT_ID"]) {
  id: ID! @nodeId
  "Fornavnet slik det ble registrert første gang."
  fornavn: String      # via gjeldende subjektnavn-rad, se Task #9
  "Etternavnet slik det ble registrert første gang."
  etternavn: String
}

extend type Query {
  """
  Personene uten Feide du har innsyn i. Paginert, og sortert på etternavn om ikke annet er
  oppgitt. Synligheten håndheves i databasen (personsubjekt_les).
  """
  idPortenBrukere(
      filter: IdPortenBrukereFilterInput
      orderBy: IdPortenBrukereOrderByInput @orderBy
  ): [IdPortenBruker] @asConnection(defaultFirstValue: 100) @defaultOrder(...)
}

input IdPortenBrukereFilterInput {
  "Eksakt treff på fødselsnummer eller D-nummer (11 sifre). Nummeret returneres aldri."
  fodselsnummer: String @condition(... IdPortenBrukereFilterConditions.fodselsnummer ...)
  "Fornavn eller etternavn inneholder søketeksten (uavhengig av store og små bokstaver)."
  navnContains: String @condition(... IdPortenBrukereFilterConditions.navnContains ...)
  "Kun personer med tildelinger i disse organisasjonene."
  organisasjoner: [ID!] @nodeId(typeName: "Organisasjon")
  "Kun personer med tildelinger i disse miljøene."
  miljoer: [ID!] @nodeId(typeName: "Miljo")
}
# + IdPortenBrukereOrderByInput / IdPortenBrukereOrderByFieldInput { ETTERNAVN }
```

##### Lag B — fs-admin call-site

```ts
// src/domains/brukeradministrasjon/components/IdPortenBrukerRad.tsx
export const ID_PORTEN_BRUKER_RAD_FRAGMENT = gql(/* GraphQL */ `
  fragment IdPortenBrukerRadFields on IdPortenBruker {
    id
    fornavn
    etternavn
  }
`)
```

```ts
// src/domains/brukeradministrasjon/features/IdPortenBrukere/queries.ts
export const GET_ID_PORTEN_BRUKERE = gql(/* GraphQL */ `
  query GetIdPortenBrukere($filter: IdPortenBrukereFilterInput, $first: Int, $after: String) {
    idPortenBrukere(filter: $filter, first: $first, after: $after) {
      totalCount
      pageInfo { endCursor hasNextPage }
      nodes { ...IdPortenBrukerRadFields }
    }
  }
`)
// Skisse: const { data } = useQuery(GET_ID_PORTEN_BRUKERE, { variables: { filter } })
// Raden: const bruker = useFragment(ID_PORTEN_BRUKER_RAD_FRAGMENT, props.bruker)
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-PER-GRU-013, regelen om synlighet.
- **Form:** en egen type over `personsubjekt` i stedet for gjenbruk av `FeideBruker`, som besluttet
  i analysen. Synligheten ligger i RLS, så `totalCount` og `pageInfo` gjenspeiler innsynet uten
  filterkode, slik `feideBrukere` gjør. Søk på fødselsnummer er eksakt og returnerer ikke nummeret,
  så API-et kan ikke brukes til å bla i fødselsnumre.
- **Colocation-status:** etablerer colocation for den nye skjermen. Eksisterende Feide-skjermer
  beholdes uendret, per `graphql-golden-path-fragment-colocation §Implementation notes` og
  `graphql-golden-path-query-componentization §Why this should be default`. fs-admin-stiene er
  antatte, fordi fs-admin-repoet ikke er sjekket ut her.
- **Konvensjoner sitert:**
  - Relay-connection per `fs-sikt-no-producer-schema-design §Vi følger Cursor Connections Specification for paginering`
    og `fs-sikt-no-producer-best-practice §Paginering`.
  - `Node` per `fs-sikt-no-producer-schema-design §Vi følger Global Object Identification-spesifikasjonen`.
  - Nullable navnefelt per `fs-sikt-no-producer-best-practice §Nullability`.
  - `fodselsnummer` / `navnContains` per `fs-sikt-no-producer-naming §Unngå forkortelser`.
    `Contains` følger det etablerte `brukernavnContains`.
- **Bevisst utelatt:** `registrertAv` / `registrertTidspunkt`. Navneraden kan være skrevet av en
  administrator i en annen organisasjon, og å vise den ville røpe den registreringen, som kravet
  sier ikke skal røpes.
- **Alternativer vurdert:** `fodselsnummer: String` som felt på typen ble forkastet foreløpig
  (åpent spørsmål 1). Et felles interface med `FeideBruker` ble forkastet i analysen.

#### Op #2: `IdPortenBruker.tilganger` — tilgangslisten

**Dekker krav:** BRU-PER-GRU-013 (ser rollene hun selv har tildelt, fjerning), TIL-PÅL-PÅL-003 (rollen gir orgtilganger)
**Implementeres av:** Task #9

##### Lag A — Schema-tillegg

```graphql
"""En tilgang eller rolle en ID-porten-bruker er tildelt, direkte eller arvet."""
type IdPortenBrukerTilgang implements Node
    @table(name: "subjektrolletildeling_med_arv")
    @node(typeId: "20023", keyColumns: ["SUBJEKT_ID", "ROLLEKODE", "ORGANISASJONSKODE", "MILJOKODE"]) {
  id: ID! @nodeId
  tilgangskode: String! @field(name: "ROLLEKODE")
  beskrivelse: String       # som FeideBrukerTilgang
  rolletype: Rolletype!
  tilknytning: Tilknytning!
  arvetFra: [String!]
  fraRoller: [String!]
  organisasjon: Organisasjon
  miljo: Miljo
  tildeltAv: FeideBruker
  tildeltTidspunkt: DateTime
  gyldigFra: DateTime
  gyldigTil: DateTime
}

extend type IdPortenBruker {
  tilganger(
      filter: IdPortenBrukerTilgangerFilterInput
      orderBy: IdPortenBrukerTilgangerOrderByInput @orderBy
  ): [IdPortenBrukerTilgang] @asConnection(defaultFirstValue: 10) @splitQuery
     @reference(path: [{key: "personsubjekt__fk_personsubjekt_subjekt"}, {key: "subjektrolletildeling_med_arv__fk_srt_med_arv_subjekt"}])
}
# IdPortenBrukerTilgangerFilterInput / -OrderByInput: samme felt som Feide-varianten
```

##### Lag B — fs-admin call-site

```ts
// src/domains/brukeradministrasjon/components/IdPortenBrukerTilgangRad.tsx
export const ID_PORTEN_BRUKER_TILGANG_RAD_FRAGMENT = gql(/* GraphQL */ `
  fragment IdPortenBrukerTilgangRadFields on IdPortenBrukerTilgang {
    id tilgangskode beskrivelse rolletype tilknytning
    organisasjon { id navn } miljo { id }
  }
`)
// features/IdPortenBruker/queries.ts
export const GET_ID_PORTEN_BRUKER = gql(/* GraphQL */ `
  query GetIdPortenBruker($id: ID!) {
    node(id: $id) {
      ... on IdPortenBruker {
        ...IdPortenBrukerRadFields
        tilganger(first: 50) { nodes { ...IdPortenBrukerTilgangRadFields } }
      }
    }
  }
`)
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-PER-GRU-013, reglene om synlighet og fjerning. Listen viser bare
  tildelinger kalleren kan lese (`subjektrolletildeling_les`, persongrenen fra Task #2), så
  tildelinger fra andre organisasjoner er usynlige, som kravet sier.
- **Form:** felt for felt det samme som `FeideBrukerTilgang`, men som egen type, slik analysen
  besluttet. `tildeltAv: FeideBruker` er riktig type, fordi administratorer er Feide-brukere
  (funn 9).
- **Colocation-status:** følger colocation. Tilgangsraden eier sitt fragment, og detaljspørringen
  komponerer.
- **Konvensjoner sitert:** paginering og `Node` som i Op #1. Feltnavnene er arvet fra
  `FeideBrukerTilgang` for gjenkjennelse.
- **Merk:** `IdPortenBrukerTilgang`, `FeideBrukerTilgang` og `ApplikasjonTilgang` ligger over samme
  view-record. Tildelingsinputene kan derfor ikke bruke `@nodeId` for bruker-id-en, som i dag
  (åpent spørsmål 3).

#### Op #3: `registrerIdPortenBruker` — registrer og tildel i én operasjon

**Dekker krav:** BRU-PER-GRU-013 (ny person med rolle, allerede registrert → rolle på eksisterende, ugyldig fnr avvises, navn lagres, ikke-røping)
**Implementeres av:** Task #10

##### Lag A — Schema-tillegg

```graphql
"""En ansatt uten Feide som skal registreres, og rollen hun skal ha."""
input RegistrerIdPortenBrukerInput {
  "Fødselsnummer eller D-nummer, 11 sifre."
  fodselsnummer: String!
  fornavn: String!
  etternavn: String!
  tilgangId: ID! @nodeId(typeName: "Tilgangsrolle")
  organisasjonId: ID! @nodeId(typeName: "Organisasjon")
  miljoId: ID! @nodeId(typeName: "Miljo")
}

"""
Resultatet av registreringen. Utfallet er det samme enten personen var registrert fra før eller
ikke. Er fødselsnummeret kjent, legges rollen på den eksisterende personen, og navnet som ble
oppgitt brukes ikke.
"""
type RegistrerIdPortenBrukerPayload {
  "Personen slik du ser henne etter tildelingen. Null uten lesetilgang i organisasjonen og miljøet."
  idPortenBruker: IdPortenBruker
  errors: [RegistrerIdPortenBrukerError]
}

union RegistrerIdPortenBrukerError =
    UgyldigFodselsnummer
  | ManglerTildelingsrett
  | TilgangskodeIkkeFunnet

"""Fødselsnummeret er ikke et gyldig fødselsnummer eller D-nummer. Nummeret gjentas ikke i meldingen."""
type UgyldigFodselsnummer implements Error
    @error(handlers: [{ handler: GENERIC, className: "no.sikt.fs.tilgangsstyring_service.UgyldigFodselsnummerException", ... }]) {
  path: [String!]!
  message: String!
}

extend type Mutation {
  registrerIdPortenBruker(input: RegistrerIdPortenBrukerInput!): RegistrerIdPortenBrukerPayload
      @service(service: {className: "no.sikt.fs.tilgangsstyring_service.IdPortenBrukerRegistreringService", method: "registrerIdPortenBruker"})
}
```

##### Lag B — fs-admin call-site

```ts
// features/RegistrerIdPortenBruker/queries.ts
export const REGISTRER_ID_PORTEN_BRUKER = gql(/* GraphQL */ `
  mutation RegistrerIdPortenBruker($input: RegistrerIdPortenBrukerInput!) {
    registrerIdPortenBruker(input: $input) {
      idPortenBruker { id ...IdPortenBrukerRadFields }
      errors { __typename ... on Error { message path } }
    }
  }
`)
// Skisse: const [registrer] = useMutation(REGISTRER_ID_PORTEN_BRUKER)
// errors tom → naviger til node-id; UgyldigFodselsnummer → feltfeil på fødselsnummer
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-PER-GRU-013, alle reglene under «Fødselsnummer identifiserer personen», og
  reglene om navn og om ikke å røpe registreringer.
- **Form:** én mutasjon, ikke opprett + tildel, fordi en nyopprettet person er usynlig til hun har
  en tildeling (funn 3). Det finnes bevisst **ingen** `IdPortenBrukerAlleredeRegistrert`-feil: den
  ville vært orakelet funn 4 beskriver. Blankt navn fanges av `@NotBlank`-validering i servicen, som
  gir en ordinær valideringsfeil, eller eventuelt en typet `UgyldigNavn` hvis fs-admin trenger det.
- **Colocation-status:** følger colocation. Suksessraden gjenbruker `IdPortenBrukerRadFields`.
- **Konvensjoner sitert:**
  - Endring bare via toppnivåfelt på `Mutation` per `fs-sikt-no-producer-best-practice §Bare felt på Mutation-typen kan utføre endringer`.
  - Formålsbygd mutasjon med non-null input per `graphql-learn-mutations §Purpose-built mutations`.
  - Error-unionen er i **entall** (`…Error`). Det avviker fra skillets flertallsdefault, men speiler
    skjemaet (`TildelFeideBrukerTilgangerError`, `OpprettFeideBrukerError`), og konsistens innad i
    subgrafen går foran.
- **Alternativer vurdert:** batch-input som `tildelFeideBrukerTilganger` ble forkastet, fordi
  registrering gjelder én person og en batch ville gjort feilstien for fødselsnummer uklar.

#### Op #4 og #5: `tildelIdPortenBrukerTilganger` / `fjernIdPortenBrukerTilganger`

**Dekker krav:** BRU-PER-GRU-013 (fjerning via tildelinger, andre organisasjoners tildelinger beholdes), TIL-PÅL-PÅL-003 (rollen gir orgtilganger)
**Implementeres av:** Task #11

##### Lag A — Schema-tillegg

```graphql
input TildelIdPortenBrukerTilgangerInput {
  idPortenBrukerId: ID!                       # uten @nodeId, se Op #2
  tilgangId: ID! @nodeId(typeName: "Tilgangsrolle")
  organisasjonId: ID! @nodeId(typeName: "Organisasjon")
  miljoId: ID! @nodeId(typeName: "Miljo")
}
input FjernIdPortenBrukerTilgangerInput { idPortenBrukerTilgangId: ID! }

type TildelIdPortenBrukerTilgangerPayload {
  tilganger: [IdPortenBrukerTilgang]
  errors: [TildelIdPortenBrukerTilgangerError]
}
type FjernIdPortenBrukerTilgangerPayload {
  fjernedeTilganger: [FjernetIdPortenBrukerTilgang]
  errors: [FjernIdPortenBrukerTilgangerError]
}
type FjernetIdPortenBrukerTilgang {
  idPortenBrukerTilgangId: ID!
  fortsattEffektiv: IdPortenBrukerTilgang
}

union TildelIdPortenBrukerTilgangerError = ManglerTildelingsrett | IdPortenBrukerIkkeFunnet | TilgangskodeIkkeFunnet
union FjernIdPortenBrukerTilgangerError  = ManglerTildelingsrett | IdPortenBrukerIkkeFunnet | TilgangskodeIkkeFunnet | ArvetTilgangKanIkkeFjernes

"""Personen finnes ikke, er ikke synlig for deg, eller du mangler tilgang. Uskjelnelig med vilje."""
type IdPortenBrukerIkkeFunnet implements Error @error(handlers: [ GENERIC IdPortenBrukerIkkeFunnetException,
    GENERIC «Decoded NodeId did not match», DATABASE P0002 «personen» ]) { path: [String!]! message: String! }

extend type Mutation {
  tildelIdPortenBrukerTilganger(input: [TildelIdPortenBrukerTilgangerInput!]!): TildelIdPortenBrukerTilgangerPayload
      @service(service: {className: "no.sikt.fs.tilgangsstyring_service.IdPortenBrukerTilgangService", method: "tildelIdPortenBrukerTilganger"})
  fjernIdPortenBrukerTilganger(input: [FjernIdPortenBrukerTilgangerInput!]!): FjernIdPortenBrukerTilgangerPayload
      @service(service: {className: "no.sikt.fs.tilgangsstyring_service.IdPortenBrukerTilgangService", method: "fjernIdPortenBrukerTilganger"})
}
```

##### Lag B — fs-admin call-site

```ts
export const TILDEL_ID_PORTEN_BRUKER_TILGANGER = gql(/* GraphQL */ `
  mutation TildelIdPortenBrukerTilganger($input: [TildelIdPortenBrukerTilgangerInput!]!) {
    tildelIdPortenBrukerTilganger(input: $input) {
      tilganger { ...IdPortenBrukerTilgangRadFields }
      errors { __typename ... on Error { message path } }
    }
  }
`)
export const FJERN_ID_PORTEN_BRUKER_TILGANGER = gql(/* GraphQL */ `
  mutation FjernIdPortenBrukerTilganger($input: [FjernIdPortenBrukerTilgangerInput!]!) {
    fjernIdPortenBrukerTilganger(input: $input) {
      fjernedeTilganger { idPortenBrukerTilgangId fortsattEffektiv { ...IdPortenBrukerTilgangRadFields } }
      errors { __typename ... on Error { message path } }
    }
  }
`)
```

##### Lag C — Begrunnelse

- **Dekker krav:** BRU-PER-GRU-013, regelen om fjerning. Kravet om at den siste tildelingen gjør
  personen usynlig følger av RLS. TIL-PÅL-PÅL-003: en tildeling gir orgtilganger ved neste innlogging.
- **Form:** ordrett speiling av Feide-mutasjonene. Batch, alt-eller-ingenting, idempotens og
  feilkontrakten er de samme, så fs-admin kan gjenbruke logikken fra Feide-skjermen. DB-portene er
  `tildel_persontilgang` / `fjern_persontilgang` (Task #2).
- **Colocation-status:** følger colocation, med resultatet spredt fra tilgangsradens fragment.
- **Konvensjoner sitert:** som Op #3. Entall i unionene speiler skjemaet.
- **Ingen slett-mutasjon:** beslutning 10. Fjerning av personen er fjerning av alle tildelinger.

### Tverrgående schema-bekymringer

#### Permission-modell

Rettighetene sjekkes i databasen og ingen andre steder.

- **Lesing:** RLS (`personsubjekt_les`, persongrenen på `subjektrolletildeling_les`).
- **Skriving:** definer-funksjonene sjekker selv, og `tildel/fjern_persontilgang` er SECURITY
  INVOKER bak RLS.
- **Feil:** 42501 rutes til `ManglerTildelingsrett`, med samme melding for alle retter (0057-kontrakten).
- **Ikke-funnet:** P0002 rutes til `IdPortenBrukerIkkeFunnet`, uskjelnelig fra usynlig.

Det finnes ingen `Me`-felt for personrettigheten. fs-admin leser den fra `mineTilganger` som i dag.

#### Error-union-medlemmer

| Mutation | Error-union | Medlemmer |
|---|---|---|
| `registrerIdPortenBruker` | `RegistrerIdPortenBrukerError` | `UgyldigFodselsnummer` (ny), `ManglerTildelingsrett`, `TilgangskodeIkkeFunnet` |
| `tildelIdPortenBrukerTilganger` | `TildelIdPortenBrukerTilgangerError` | `ManglerTildelingsrett`, `IdPortenBrukerIkkeFunnet` (ny), `TilgangskodeIkkeFunnet` |
| `fjernIdPortenBrukerTilganger` | `FjernIdPortenBrukerTilgangerError` | `ManglerTildelingsrett`, `IdPortenBrukerIkkeFunnet`, `TilgangskodeIkkeFunnet`, `ArvetTilgangKanIkkeFjernes` |

#### Sporings-felter

`tildeltAv` / `tildeltTidspunkt` står på tilgangen, som for Feide. Det finnes ingen `registrertAv`
på personen, fordi det ville røpe en registrering i en annen organisasjon (Op #1).

#### Versjonering

Alt er nytt i experimental, så det trengs ingen `V2`, per
`fs-sikt-no-producer-schema-design §Endringer i API bør ikke ødelegge for klienter` (eksperimentelt
nivå). Flytting til stable er ikke en del av denne planen.

### Åpne spørsmål

- [ ] **Vise fødselsnummer.** Trenger fs-admin å vise nummeret, for eksempel sladdet («010190*****»)
      eller fødselsdato, for å skille to personer med samme navn? Anbefalingen for fase 1 er
      ingen visning, bare eksakt søk. Blokkerer ikke backend. **Eier:** fs-admin.
- [ ] **Paritet med `FeideBruker`.** Skal `IdPortenBruker` få `tildelingerOrganisasjoner` /
      `tildelingerMiljoer` (DISTINCT-viewene fra 0023) til oversiktskolonnene? Det er billig å legge
      til, men er utelatt til fs-admin ber om det. **Eier:** fs-admin.
- [ ] **Node-id for tilgangsradene.** Tre typer over `subjektrolletildeling_med_arv` betyr at
      `@nodeId` på bruker-id-en i tildelingsinputen ikke kan brukes. Bruk samme løsning som
      `feideBrukerId` (dekoding i servicen). Verifiseres i Task #11.

## Implementation Tasks

### Task #1: Privilegiefamilie, forretningsroller og FS Admin-tak for personer (0078) ✅ ([task-1-completion-v2.md](task-1-completion-v2.md))

**Priority**: High
**Size**: M
**Dependencies**: None
**Addresses Requirements**: BRU-PER-GRU-013 (atskilt fra Feide-flyten)

**Acceptance Criteria**:

- [ ] Ny `0078-privilegier-person.sql`. Den ucommittede `0078-personsubjekt.sql` er flyttet til `0080`.
- [ ] Nye privilegier `BRUKERADMIN_PERSON_LES`, `_SKRIV` og `_TILDELING_SKRIV` i navnerom `tilgangsstyring`.
- [ ] Nye forretningsroller i `fs` / `fs-admin` med implikasjoner ned til privilegiene. De impliseres
      ikke av `BRUKERADMINISTRASJON_*`, og `BRUKERADMINISTRASJON_*` impliserer ikke dem.
- [ ] Chokepoint-funksjonene `orger_med_person_tildelingsrett()`, `krev_person_tildelingsrett(org, miljo)`
      og `brukere_i_mine_person_les_organisasjoner()` / `_skriv_organisasjoner()` finnes.
      Brukeroppslagene matcher (miljø, org)-paret som 0076.
- [ ] De nye rollene er speilet inn i FS Admins delegeringstak (0059-mønsteret, `service_id IN ('2196456', 'dev-brukeradmin')`).
- [ ] pgTAP `70_privilegier_person.sql`: rollegrafen, ingen implikasjon mellom Feide- og personfamilien
      i noen retning, og at taket inneholder rollene i dev.

**Implementation Notes**:
Rollenavnene er forslag (beslutning 2), og implementøren bekrefter dem mot `docs/begrepsbruk.md`.
Brukeroppslagene leser `subjektrolletildeling` + `subjekt.subjekt_type = 'person'`, **ikke**
`personsubjekt`, for å unngå RLS-rekursjonen fra 0023/0057.

### Task #2: Typesplitt i tildelingspolicyene og persontildeling (0079) ✅ ([task-2-completion-v2.md](task-2-completion-v2.md))

**Priority**: High
**Size**: L
**Dependencies**: Task #1
**Addresses Requirements**: BRU-PER-GRU-013 (atskilt i begge retninger, synlighet, fjerning)

**Acceptance Criteria**:

- [ ] De fire policyene på `subjektrolletildeling` er DROP + CREATE med tre grener: ikke-person →
      WSBRUKER-nøkler, `feide_bruker` → FEIDEBRUKER-nøkler, `person` → PERSON-nøkler. En menneskelig
      type uten gren treffer ingen. Den eksisterende eier-grenen og saksbehandler-grenen i `_les`
      (0069) er ordrett bevart.
- [ ] Ett changeset per tabell med `SET LOCAL lock_timeout = '2s'`, som 0075.
- [ ] `tildel_persontilgang` / `fjern_persontilgang` speiler 0057-kroppene med
      `krev_person_tildelingsrett` + `krev_personsubjekt` (P0002 «personen»). Meldinger og
      idempotens er de samme.
- [ ] `tildelbare_tilgangskoder` / `mine_tildelingsorganisasjoner` får en persongren (union, 0057-formen).
- [ ] pgTAP `71_tildelinger_person_gren.sql` viser at migreringen er uten effekt før `person` finnes
      (de seks typene fra sett 66), og at en syntetisk menneskelig testtype avvises i alle fire
      policyene.
- [ ] Settene 51/66 er grønne. Endrede antagelser er oppdatert, ikke fjernet.

**Implementation Notes**:
Grenen for `person` kan skrives før typen finnes, fordi den tester tekstkoden. For å unngå fire
kopier av grenparet: vurder hjelpefunksjoner per ledd, for eksempel
`menneske_har_tildelingsrett(subjekt_id, miljo, org)`, men ikke hvis det bryter planformen fra
`50_ytelse_planform.sql`. Mål før og etter.

### Task #3: Personsubjektet på egne nøkler (0080) ✅ ([task-3-completion-v2.md](task-3-completion-v2.md))

**Priority**: High
**Size**: M
**Dependencies**: Task #2
**Addresses Requirements**: BRU-PER-GRU-013 (synlighet, navn og sporing, atskilt)

**Acceptance Criteria**:

- [ ] `0080-personsubjekt.sql` er dagens 0078 med `personsubjekt_les` / `_skriv` på
      `brukere_i_mine_person_*`, og `WITH CHECK` på `BRUKERADMIN_PERSON_SKRIV`.
- [ ] `opprett_personsubjekt` er fjernet. `registrer_person` (Task #4) er eneste inngang, og
      REVOKE INSERT/UPDATE står. DELETE for app-rollen beholdes (beslutning 10).
- [ ] Kommentarene er rettet der de beskriver Feide-nøklene som bevisst valg.
- [ ] `69_personsubjekt.sql` viser at en Feide-administrator ikke ser en person, at en
      personadministrator ikke ser en Feide-bruker via personflaten, og at synligheten krever
      (miljø, org)-paret.

**Implementation Notes**:
Filen er ucommittet og har aldri kjørt noe sted, så den redigeres direkte. Justeringene i test 26
og 62 fra 0078-arbeidet beholdes.

### Task #4: `registrer_person` (0081) ✅ ([task-4-completion-v2.md](task-4-completion-v2.md))

**Priority**: High
**Size**: M
**Dependencies**: Task #3
**Addresses Requirements**: BRU-PER-GRU-013 (ny person, allerede registrert, navn, ikke-røping)

**Acceptance Criteria**:

- [ ] `registrer_person(p_fodselsnummer, p_fornavn, p_etternavn, p_rollekode, p_organisasjonskode, p_miljokode)`
      er SECURITY DEFINER og returnerer `subjekt_id` som tabellrad (`@routine`-kravet).
- [ ] Første setning krever både `BRUKERADMIN_PERSON_SKRIV` og `_TILDELING_SKRIV` i (org, miljø),
      ellers 42501. Sjekken skjer før fødselsnummeret slås opp.
- [ ] Funksjonen finner eller oppretter på fødselsnummer. For en ny person skrives `subjekt` +
      `personsubjekt` + `subjektnavn`. For en kjent person skrives ingen navnerad. Tildelingen er
      idempotent som `tildel_persontilgang`.
- [ ] Et race på samme nye nummer (`23505`) håndteres i funksjonen, for eksempel med
      `ON CONFLICT DO NOTHING` + nytt oppslag, og når aldri kalleren.
- [ ] pgTAP `72_registrer_person.sql` viser at ny og kjent person gir identisk resultatform, at
      navnet for en kjent person er uendret, at manglende rett gir 42501 også for et kjent nummer,
      og at en tildeling fra en annen organisasjon står urørt og er usynlig for kalleren.

### Task #5: `idporten_applikasjon`, taket og tilgangsfunksjonen (0082–0083) ✅ ([task-5-completion-v2.md](task-5-completion-v2.md))

**Priority**: High
**Size**: L
**Dependencies**: Task #3
**Addresses Requirements**: TIL-PÅL-PÅL-003 (tilgangssett med og uten tildelte roller), BRU-PER-GRU-013 (før første innlogging), TIL-PÅL-PÅL-004 (gulvet via Min Kompetanse, ukjent klient)

**Acceptance Criteria**:

- [ ] `0082-idporten-applikasjon.sql`:
  - Subjekttypen `idporten_applikasjon` (`aktorledd = 'applikasjon'`), så den havner i
    applikasjonsgrenen i tildelingspolicyene.
  - Tabellen `idporten_applikasjon` etter mønsteret fra `maskinporten_applikasjon`: `client_id`
    (unik), navn, eierorganisasjon, ansvarlig, sporing, `deaktivert_tidspunkt` / status, og RLS
    som for de andre applikasjonstabellene.
  - `applikasjon_brukerdelegering`: ny kolonne `subjekt_type` (DEFAULT `'feide_applikasjon'`,
    fylt for eksisterende rader), kompositt-FK mot `subjekt(subjekt_id, subjekt_type)` og CHECK
    på de to typene. `fk_applikasjon_brukerdelegering_app` droppes. Tabellkommentaren om at
    delegering gjelder kun Feide-apper, rettes.
  - `applikasjon_er_deaktivert` har en gren for `idporten_applikasjon`.
  - Eksempeldata (`context:@eksempeldata`): «FS Admin (test)» og «Min kompetanse (test)» med
    testklient-id-er. Taket kopieres fra Feide-radene (-22 og -21) med 0059-vaktene (katalog-EXISTS,
    NOT EXISTS, DISTINCT).
- [ ] `0083-tilganger-for-idporten-bruker.sql`: `tilganger_for_idporten_bruker(p_env, p_client_id, p_fodselsnummer)`
      er SECURITY DEFINER og har samme form som `tilganger_for_feidetjeneste_og_bruker` (0063):
      `tilganger_for_bruker(env, (personsubjekt på fnr), (idporten_applikasjon på client_id), NULL)`
      filtrert på `subgrafrolle`. Den har ingen egen gulvlogikk. GRANT EXECUTE bare til `${coprocessor_role}`.
- [ ] `FeideApplikasjon.brukerdelegeringer` i `schema_delegeringstak.graphqls` bruker den nye FK-stien.
      De eksisterende GraphQL-testene for delegeringstaket er grønne, og forvaltnings-API-et (0048)
      virker for Feide-apper som før.
- [ ] pgTAP `73_idporten_applikasjon.sql` og `74_tilganger_for_idporten_bruker.sql` dekker:
  - uregistrert person via FS Admin (test) gir bare åpne roller,
  - registrert person med rolle gir rollens orgtilganger innenfor taket,
  - en rolle utenfor taket gir ingenting,
  - uregistrert person via Min Kompetanse (test) gir `student` fra gulvet,
  - **samme** uregistrerte person via FS Admin (test) gir ikke `student`, altså at resultatet
    faktisk avhenger av `client_id` (analyse v3, funn 2),
  - registrert person med `saksbehandler` via Min Kompetanse (test) gir `student` fra gulvet, men
    ikke `saksbehandler`, fordi rollen ligger utenfor Min Kompetanses tak (delta-beslutning 2),
  - ukjent `client_id` og `client_id = NULL` gir bare åpne roller,
  - deaktivert ID-porten-app gir tomt, heller ikke åpne roller (analyse v3, spørsmål 1),
  - og `CHECK`-en avviser en takrad for en annen apptype.
- [ ] De eksisterende settene for delegeringstaket og 0048 er grønne.

**Implementation Notes**:
Ett kall per innlogging, innenfor tidsbudsjettet (`docs/tidsbudsjett.md`). Policyene fra 0048 slår
opp eierorganisasjonen i `feide_applikasjon`. For en ID-porten-takrad blir oppslaget tomt, og
forvaltningen feiler lukket, slik det er ment til T1 er avklart. Kontroller at
`BrukerdelegeringForvaltningService` og GraphQL-flaten for taket ikke viser ID-porten-rader under
en Feide-app. Samme `subjekt_id` kan ikke finnes i begge tabellene, men et filter på `subjekt_type`
i spørringen gjør det eksplisitt.

### Task #6: Del `Fodselsnummer` med service-laget ✅ ([task-6-completion-v2.md](task-6-completion-v2.md))

**Priority**: Medium
**Size**: S
**Dependencies**: None
**Addresses Requirements**: BRU-PER-GRU-013 (ugyldig fødselsnummer eller D-nummer avvises)

**Acceptance Criteria**:

- [ ] `Fodselsnummer` og `FodselsnummerTest` er flyttet til `tilgangsstyring-service`. Coprocessoren
      bruker den derfra, og ingen oppførsel er endret.
- [ ] Ny metode, for eksempel `erGyldigForRegistrering()`: kontrollsifre gyldige, ordinært nummer
      eller D-nummer (måned 01–12) eller Tenor (måned + 80). FS-genererte numre gir false. Den
      testes med nummer fra hver serie.

**Implementation Notes**:
Bekreft at `tilgangsstyring-app` avhenger av `tilgangsstyring-service` i pom-en. Hvis ikke, legg
klassen i en felles modul.

### Task #7: Coprocessoren slår opp personen ved ID-porten-innlogging ✅ ([task-7-completion-v2.md](task-7-completion-v2.md))

**Priority**: High
**Size**: M
**Dependencies**: Task #5
**Addresses Requirements**: TIL-PÅL-PÅL-003 (med og uten tildelte roller), BRU-PER-GRU-013 (gjenkjent ved første innlogging), TIL-PÅL-PÅL-004 (alle regler)

**Acceptance Criteria**:

- [ ] `TilgangsstyringDataTilgangerService.tilgangerForIdportenBruker(env, clientId, nin)` kaller
      `tilganger_for_idporten_bruker` med tokenets `client_id` og `pid`.
- [ ] ID-porten-grenen i `CoprocessorService.hentActualOrgTilganger` bruker den. Grenen
      `tilgangerForApneRoller` fra iterasjon 1 er borte, og `tilganger_for_apne_roller` (0077)
      fjernes hvis den ikke har andre kallere.
- [ ] En ukjent `client_id` gir bare åpne roller (ikke 401), logges som advarsel med `client_id` og
      telles i coprocessormetrikken.
- [ ] Testklientene fra eksempeldataene (Task #5) brukes i testprofilen.
- [ ] `IdportenCoprocessorTest` har scenarioene «registrert med rolle gir rollens orgtilganger»,
      «uregistrert via FS Admin gir bare åpne», «uregistrert via Min Kompetanse gir gulvet» og
      «ukjent client_id gir bare åpne».
- [ ] JWKS-stubben kan utstede tokens med ulik `client_id` for samme `pid`. Testen sender **samme**
      person via Min Kompetanse (test) og FS Admin (test) og viser at det interne tokenet er ulikt.
      Uten det kan scenariene for FS Admin og ukjent klient være grønne selv om grenen ignorerer
      `client_id` (analyse v3, funn 2).
- [ ] Scenario for registrert person via Min Kompetanse: tildelte roller utenfor taket er ikke med,
      men gulvet er det (delta-beslutning 2). Testen sporer til beslutningen og ikke til et scenario i 004.
- [ ] Scenario for deaktivert ID-porten-app: forespørselen autentiseres, og `orgtilganger` er tomt.
- [ ] Testen for 004 regel 2 viser at det ikke finnes noen `personsubjekt`-rad for `pid` etter
      innloggingen via Min Kompetanse.
- [ ] Kommentarene er rettet: `CoprocessorService.java:744-747` («bare modellens gulv») beskriver den
      nye grenen, og hvis `tilgangerForApneRoller` blir stående, kaller ikke javadoc-en de åpne
      rollene for gulvet. Headeren i `0077` står (analyse v3, spørsmål 4).
- [ ] Fødselsnummeret logges sladdet (`Fodselsnummer.sladd`).

**Implementation Notes**:
Om advarselen for ukjent klient skal være egen `resultat`-verdi eller egen tagg i metrikken, avgjøres
mot `docs/coprocessor-metrikker.md` og taggtaket (`CoprocessorTaggtak`).

### Task #8: Audiens fail-closed og ID-porten av i produksjon ✅ ([task-8-completion-v2.md](task-8-completion-v2.md))

**Priority**: High
**Size**: M
**Dependencies**: None
**Addresses Requirements**: TIL-PÅL-PÅL-003 (token utstedt for en annen tjeneste avvises)

**Acceptance Criteria**:

- [ ] `quarkus.oidc.idporten.token.audience` og `…idporten-test.token.audience` settes fra en
      påkrevd verdi i alle profiler som har tenanten. Det er én verdi: ressursserveren FS GraphQL API,
      som både FS Admin og Min Kompetanse ber om tokens for.
- [ ] `tilgangsstyring.issuer.idporten` er `Optional<String>`, som `-test`. Er utstederen satt uten
      audiens, feiler oppstarten med en tydelig melding.
- [ ] `application-platon-production.properties` har ingen ID-porten-tenant eller -utsteder, og
      appen starter. Det står en merknad om at den legges inn når Digdir-verdien finnes.
- [ ] `application-test.properties` har en testaudiens. En test viser at feil audiens gir
      uautentisert, og at forespørselen ikke når subgrafene.
- [ ] Avvisningen gjelder uavhengig av `client_id`. Testen kjøres med testklienten for både
      FS Admin og Min Kompetanse (delta-beslutning 3: 003-reglene gjelder alle ID-porten-klienter).

**Implementation Notes**:
Se beslutning (a) i iterasjon 1 og analysens avsnitt om audiens. Hvordan fs-admin får et token med
riktig audiens (token exchange eller `resource`) er fs-admins sak og avklares i deres task.

### Task #9: GraphQL, lesing: `IdPortenBruker`, `idPortenBrukere` og `tilganger` ✅ ([task-9-completion-v2.md](task-9-completion-v2.md))

**Priority**: High
**Size**: L
**Dependencies**: Task #3 (+ jOOQ-regenerering)
**Addresses Requirements**: BRU-PER-GRU-013 (synlighet)

**Acceptance Criteria**:

- [ ] Op #1 og Op #2 fra GraphQL-endringer er implementert i en ny sone i `schema_brukeradmin.graphqls`.
- [ ] Navnet leses fra gjeldende `subjektnavn`-rad. Trengs det, legges et view med én rad per
      subjekt til i 0080 (security_invoker), så RLS gjelder.
- [ ] `IdPortenBrukereFilterConditions`: `fodselsnummer` (eksakt) og `navnContains`.
- [ ] GraphQL-tester viser at en personadministrator ser egne tildelinger, at en
      Feide-administrator ikke ser personen, og at en tildeling i en annen organisasjon ikke vises.

### Task #10: GraphQL, `registrerIdPortenBruker` ✅ ([task-10-completion-v2.md](task-10-completion-v2.md))

**Priority**: High
**Size**: M
**Dependencies**: Task #4, Task #6, Task #9
**Addresses Requirements**: BRU-PER-GRU-013 (fødselsnummer identifiserer, ugyldig avvises, navn, ikke-røping)

**Acceptance Criteria**:

- [ ] Op #3 er implementert. `IdPortenBrukerRegistreringService` validerer med `Fodselsnummer` før
      DB-kallet og kaster `UgyldigFodselsnummerException`, med en melding uten nummeret.
- [ ] 42501 gir `ManglerTildelingsrett`, og ukjent kode gir `TilgangskodeIkkeFunnet`.
- [ ] Tester: ny person med rolle, kjent nummer fra en annen organisasjon (samme payload-form, bare
      egen tildeling synlig, navnet uendret), ugyldig nummer, D-nummer, Tenor-nummer og FS-generert
      nummer (avvist).

### Task #11: GraphQL, tildel og fjern tilganger ✅ ([task-11-completion-v2.md](task-11-completion-v2.md))

**Priority**: Medium
**Size**: M
**Dependencies**: Task #2, Task #9
**Addresses Requirements**: BRU-PER-GRU-013 (fjerning)

**Acceptance Criteria**:

- [ ] Op #4 og Op #5 er implementert via `tildel_persontilgang` / `fjern_persontilgang`.
- [ ] `IdPortenBrukerIkkeFunnet` gjelder ukjent, usynlig og feiltypet id likt.
- [ ] Tester: når personens siste tildeling fjernes, er hun usynlig. Tildelinger fra en annen
      organisasjon beholdes. En arvet tilgang kan ikke fjernes. En Feide-administrator med bare
      Feide-rett får `ManglerTildelingsrett`.

### Task #12: Dokumentasjon ✅ ([task-12-completion-v2.md](task-12-completion-v2.md))

**Priority**: Medium
**Size**: S
**Dependencies**: Task #1–#11
**Addresses Requirements**: —

**Acceptance Criteria**:

- [ ] `docs/tilgangsmodell.md` beskriver subjekttypen `person` og navneskillet mot `IdPortenBruker`,
      typesplitten og den lukkede grenen, og personfamilien. Den beskriver også `idporten_applikasjon`
      som apptype med eget tak, kopiert fra Feide-appen og deretter uavhengig. Den nye FK-en på
      `applikasjon_brukerdelegering` erstatter garantien om at delegering gjelder kun Feide-apper.
      Taket avgjør om en uregistrert bruker får gulvet (FS Admin nei, Min Kompetanse ja), og regelen
      om at FS Admins tak ikke har gulvroller, står uten test.
- [ ] Kjente begrensninger er dokumentert: personer kan ikke være aktører i sporingen (funn 9),
      har ingen saksbehandlergren (0069) og ingen hjemorganisasjon (0073). Sudo med `sudoUsername`
      gir tomt resultat for en ID-porten-bruker (analyse v3, funn 11, utenfor scope).
- [ ] Forskjellen på ukjent og deaktivert ID-porten-app er beskrevet: ukjent gir åpne roller,
      deaktivert gir tomt.
- [ ] Restlekkasjen ved gjenregistrering er dokumentert: det lagrede navnet vises.
- [ ] `schema_delegeringstak.graphqls`, kommentaren «HVORFOR KUN FeideApplikasjon», er rettet til
      det som nå gjelder.
- [ ] Teksten følger RETNINGSLINJER, «Dokumentasjon og kommentarer».

## Forutsetninger og åpne punkter

### Forutsetning: krav for Min Kompetanse via ID-porten

Kravet er skrevet 2026-09-24 som `TIL-PÅL-PÅL-004`
(`krav/07 …/10 Pålogging/01 Pålogging/autentisere_person_med_idporten.feature`, `@should`), uten
GitHub-issue. Issuet opprettes når Min Kompetanse-integrasjonen planlegges. Kravet er tatt inn i flyten
med `bat-specify-delta` samme dag, og er nå `@in-progress`.

**Utestående kravpunkter** (skal inn i kravfilene via `bat-krav`, blokkerer ikke implementasjonen):

- 004: ordlyden må skille «grunntilgangen» (gulvet) fra «åpent for alle innloggede» (delta-beslutning 1).
- 004: et scenario for registrert person via Min Kompetanse (delta-beslutning 2). Frem til det er skrevet,
  dekkes beslutningen bare av testene i Task #5 og #7, og `bat-verify` har ikke noe scenario å sjekke.
- 003: reglene om signatur, audiens, acr og testmiljø kan formuleres for alle ID-porten-klienter
  (delta-beslutning 3).

### T1 (TODO): forvaltning av to tak per app

FS Admin og Min Kompetanse har nå to tak hver, ett for Feide-appen og ett for ID-porten-appen.
Gulvet er felles og miljøvidt. Takene skal sannsynligvis være like, men er skilt for ordens skyld.
Det må bestemmes:

- om forvaltnings-API-et (0048, `leggTilBrukerdelegeringer` / `fjernBrukerdelegeringer`) skal dekke
  `idporten_applikasjon`, og med hvilken eierregel,
- om en endring i det ene taket skal speiles til det andre, eller om de forvaltes hver for seg,
- og hvor dette vises i fs-admin.

Blokkerer ikke fase 1. Inntil T1 er avklart, endres ID-porten-takene bare via migrering.

## Risk Assessment

### Technical Risks

- **Risiko:** `person` lander før typesplitten og får stille Feide-nøkler.
  - **Tiltak:** nummerrekkefølgen er 0079 før 0080, og pgTAP 71 viser lukket gren for en syntetisk
    type. Samme commit-rekkefølge i MR-en.
- **Risiko:** DROP + CREATE av policyene i en «hot path» tar lås.
  - **Tiltak:** ett changeset per tabell og `lock_timeout = '2s'`, som 0075/0069.
- **Risiko:** de tre grenene endrer planformen i tilgangs- og synlighetsspørringene.
  - **Tiltak:** kjør `50_ytelse_planform.sql`, og mål før og etter på `feideBrukere` og
    `tilganger_for_bruker`.
- **Risiko:** FS Admins tak inneholder brukeradministrasjonsroller. Tildeles en person en av dem,
  feiler skrivingen hennes på sporings-FK-ene (funn 9).
  - **Tiltak:** dokumenteres (Task #12). Ingen sperre i fase 1. Tildelingen er et administrativt valg.
- **Risiko:** de to takene per app (Feide og ID-porten) glir fra hverandre, fordi et tak endres
  gjennom API-et og det andre ikke gjør det.
  - **Tiltak:** åpent punkt T1. Inntil det er avklart, endres ID-porten-taket bare via migrering.
- **Risiko:** noen legger en gulvrolle i FS Admins tak. Da får alle uregistrerte ID-porten-brukere
  gulvet i FS Admin (beslutning 4).
  - **Tiltak:** dokumentert (Task #12). Ingen test eller sperre, etter beslutning. Den samme
    risikoen gjelder allerede for ukjente Feide-brukere.
- **Risiko:** løsningen av `fk_applikasjon_brukerdelegering_app` bryter Graphitron-stier og
  antagelser i 0048 om at taket peker på `feide_applikasjon`.
  - **Tiltak:** stien i `FeideApplikasjon.brukerdelegeringer` legges om i Task #5, og testene for
    delegeringstaket og 0048 skal være grønne. Eieroppslaget i 0048 feiler lukket for ID-porten-rader.
- **Risiko:** prod-radene i `idporten_applikasjon` finnes ikke før Digdir-klientene er registrert.
  - **Tiltak:** en egen migrering per app når `client_id` finnes. Den kopierer taket fra Feide-appen
    på samme måte som eksempeldataene.
- **Risiko:** Digdir-registreringen er ikke bestilt, og uten den er ID-porten av i produksjon.
  - **Tiltak:** alt testes mot JWKS-stubben og `demo/idporten`. Prod-verdien legges inn i en egen
    endring.
- **Risiko:** den omnummererte `0077` (tidligere 0072) kjøres på nytt i et miljø der BAT-244 alt
  er kjørt.
  - **Tiltak:** branchen har ikke kjørt Liquibase i noe delt miljø, som bekreftet ved rebasen.
    Sjekk review-miljøer før merge.
- **Risiko:** testene for 004 blir grønne uten at `client_id` brukes, fordi FS Admin og ukjent klient
  i dag gir det samme som alle andre ID-porten-innlogginger (analyse v3, funn 2).
  - **Tiltak:** testen med samme `pid` via to klienter i Task #5 og #7.
- **Risiko:** den nye apptabellen blir ikke med i `applikasjon_er_deaktivert`, og en deaktivert
  ID-porten-app fortsetter å gi tak og gulv (analyse v3, funn 4).
  - **Tiltak:** grenen er et akseptansekriterium i Task #5, og testen for deaktivert app i Task #5 og #7.
- **Risiko:** fødselsnummer i feilmeldinger eller logger.
  - **Tiltak:** `Fodselsnummer.sladd` overalt. `UgyldigFodselsnummer` gjentar ikke nummeret, og
    testene sjekker meldingsteksten.

### Testing Requirements

- pgTAP for hver ny migrering (sett 70–73) og justert 69. De eksisterende settene 51/66 skal være grønne.
- Enhetstester for `Fodselsnummer.erGyldigForRegistrering` per nummerserie.
- Coprocessortester (`IdportenCoprocessorTest`) for tilgangssettet med og uten tildeling, og for audiens.
- GraphQL-tester for alle fem operasjonene, inkludert kryssorganisatorisk ikke-røping.
- `mise run build` med nullstilt base før MR. `RollekatalogForvaltningGraphqlTest` fra main er ikke
  idempotent mot en gjenbrukt base.

## Success Criteria

- [ ] Alle akseptansekriterier er oppfylt
- [ ] Alle tester er grønne (`mise run build`)
- [ ] Koden følger prosjektkonvensjonene (chokepoint-disiplin, feilkontrakt, RETNINGSLINJER)
- [ ] Alle regler i TIL-PÅL-PÅL-003, TIL-PÅL-PÅL-004 og BRU-PER-GRU-013 er dekket, bortsett fra ekte
      ende-til-ende mot ID-porten, som venter på Digdir
- [ ] Delta-beslutning 2 (registrert person via Min Kompetanse) og deaktivert ID-porten-app er dekket
      av tester

## Requirements Traceability

| Krav / regel | Oppsummering | Task(s) | Status |
|---|---|---|---|
| TIL-PÅL-PÅL-003: egen utsteder | Gyldig og ugyldig token | Iterasjon 1 | Levert |
| TIL-PÅL-PÅL-003: audiens | Token for en annen tjeneste avvises | #8 | Planlagt |
| TIL-PÅL-PÅL-003: acr | Bæres, håndheves ikke | Iterasjon 1 | Levert |
| TIL-PÅL-PÅL-003: uten tildelte roller | Bare åpne roller (FS Admins tak har ingen gulvroller) | #5, #7 | Planlagt |
| TIL-PÅL-PÅL-003: med tildelte roller | Rollens orgtilganger | #1, #5, #7 | Planlagt |
| TIL-PÅL-PÅL-003: testmiljø | Syntetisk ja, produksjon nei | Iterasjon 1 | Levert |
| BRU-PER-GRU-013: fødselsnummer identifiserer | Ny, kjent, ugyldig | #4, #6, #10 | Planlagt |
| BRU-PER-GRU-013: atskilt fra Feide | Begge retninger | #1, #2, #3 | Planlagt |
| BRU-PER-GRU-013: før første innlogging | Gjenkjent ved innlogging | #5, #7 | Planlagt |
| BRU-PER-GRU-013: navn og sporing | Navnet lagres, opprettelsen er sporbar | #3, #4 | Planlagt |
| BRU-PER-GRU-013: synlighet | Følger tildelinger, ikke-røping | #2, #3, #4, #9 | Planlagt |
| BRU-PER-GRU-013: fjerning | Via tildelinger, andre beholdes | #2, #11 | Planlagt |
| TIL-PÅL-PÅL-004: tilgangene følger appen | Gulvet via Min Kompetanse, ingenting via FS Admin | #5, #7 | Planlagt |
| TIL-PÅL-PÅL-004: ingen registrering | Innlogging registrerer ikke personen | #7 | Planlagt |
| TIL-PÅL-PÅL-004: ukjent klient | Bare åpne roller | #5, #7 | Planlagt |
| 004, delta-beslutning 1 | Gulvet (grunntilgang) ≠ åpne roller, også i kommentarene | #7, #12 | Planlagt |
| 004, delta-beslutning 2 | Registrert person via Min Kompetanse: roller ∩ tak, pluss gulvet | #5, #7 | Planlagt (bare test, ikke i kravfila) |
| 004, delta-beslutning 3 | 003-reglene gjelder alle ID-porten-klienter | #8 | Planlagt |
| Analyse v3, spørsmål 1 | Deaktivert ID-porten-app gir tomt | #5, #7, #12 | Planlagt |

## Cross-contributor

- **fs-admin (frontend):** skjermbildene for registrering, søk, visning og fjerning mot Op #1–#5.
  De må ta stilling til åpent spørsmål 1 og 2 under GraphQL-endringer. De eier også
  audiensmekanismen i innloggingsflaten (NextAuth), og den blokkerer ende-til-ende.
- **Rolleforvaltning:** hvem som får de nye personrollene i test og produksjon. Det skjer via
  tildeling, ikke i kode.
- **Eierne av 0075/0076 (main):** bør se Task #2. Den bygger på 0075-argumentet, men gjør
  menneskegrenen typestyrt og lukket, og det endrer forventningen i kommentaren til 0075 om at en
  ny persontype arver Feide-policyene.
- **Digdir (eksternt):** klientregistrering for ID-porten gir `client_id` og audiens. Ikke bestilt.
- **Min Kompetanse:** trenger en egen ID-porten-klient hos Digdir, og deretter en migrering med
  `idporten_applikasjon`-raden og kopi av taket. Modellen dekker dem uten kodeendring: gulvet via
  taket, og ingen tildelinger lagres. Kravet (004) er i flyten, og tre kravpunkter står igjen
  (se Forutsetninger). Innloggingen med ID-porten og tokenforespørselen mot FS GraphQL API-audiensen
  er Min Kompetanses egen del.
