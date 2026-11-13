# Analysis: Gi en person tilgang med nummer fra rollesiden

Analysert 07.10.2026 mot fs-plattform `origin/main` `c285371f1`, !6014
(`tilgangsstyring/personsubjekt-inflight-migrering`, `bdba9d2f3`), !6015
(`tilgangsstyring/personsubjekt-api`, `3629e0141`), !6067 (`tilgangsstyring/BAT-262-identitetsfunksjoner`)
og !6064 (`tilgangsstyring/BAT-228-fjern-syntetisk-tabeller`), og fs-admin `origin/main` `24c76aa7`.
Kravene er lest på `sikt-no/fs`, gren `krav/personbrukere-uten-feide-konto`, `9527781`. Den har to
endringer etter spec-en (`23939eb`): `265163b` og `9527781` (se «Kravendringer etter spec-en»).

Forkortelser: `CL` = `tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog`,
`SCH` = `tilgangsstyring/tilgangsstyring-app/src/main/resources/schema/features`,
`SVC` = `tilgangsstyring/tilgangsstyring-service/src/main/java/no/sikt/fs/tilgangsstyring_service`,
`TS` (fs-admin) = `src/domains/tilgangsstyring/features`.

## Problem Statement

Spec-en ([`spec-gi-tilgang-med-nummer-fra-rollesiden.md`](../spec/spec-gi-tilgang-med-nummer-fra-rollesiden.md))
er fasiten for hva som bygges. Sett fra koden er problemet dette:

- En person blir synlig for en brukeradministrator bare gjennom en tildeling, eller, med !6014,
  gjennom hjemorganisasjonen til en koblet Feide-bruker. Det finnes ingen operasjon som gir en person
  brukeradministratoren ikke ser, den første tildelingen. `tildelPersonsubjektTilganger` (!6015) krever
  at personen alt er synlig. `opprett_person` krever navn og avslører om personen finnes.
- FS Admin har ingen rolleoversikt, ingen rolleside og ingen støtte for personsubjekter. Kravet sier at
  tilgang med nummer gis fra rollesiden, at en rad på rollesiden åpner brukersiden, og at flere roller
  gis der.

## Current State

### Database (fs-plattform, `tilgangsstyring`)

- **Personsubjektet** finnes på `main`: `CL/0085-personsubjekt.sql:119-167`. `fodselsnummer` er
  `UNIQUE` (`:132`) og har `CHECK auth.er_gyldig_fodselsnummer` (`:138`). Funksjonen (`:37-48`) sjekker
  elleve sifre og mod 11. `er_syntetisk` er generert fra `auth.er_tenor_serie(fodselsnummer)` (`:124`),
  og triggeren `klassifisering_endres_aldri` (`:169-183`) stopper en endring som snur den.
- **Person-privilegiene** `BRUKERADMIN_PERSON_LES/_SKRIV/_TILDELING_SKRIV` (`CL/0085:51-69`) er
  implisert fra `BRUKERADMINISTRASJON_LES/_SKRIV/_TILDELING`. Delegeringstaket er speilet fra
  Feide-privilegiene (`:71-117`). Alle brukeradministratorer har dem, så det trengs ingen egen
  rettighet (GRU-013).
- **Synlighet**: `personsubjekt_les` (`CL/0085:222-236`) bygger på
  `personer_i_mine_person_les_organisasjoner()` (`:186-202`). Personen er synlig ved en tildeling, aktiv
  eller ikke, i et (miljø, organisasjon) der kalleren har `BRUKERADMIN_PERSON_LES`. !6014 legger til en
  gren for hjemorganisasjonen til en koblet Feide-bruker, bare i miljøer klassifisert som personen
  (!6014 `CL/0086-personsubjekt-inflight-migrering.sql:435-487`).
- **Tildelingspolicyene** på `subjektrolletildeling` velger privilegium etter aktørledd, også `person`
  (`CL/0085:266-401`).
- **`opprett_person(fnr, fornavn, etternavn)`** (`CL/0085:560-596`) er `SECURITY INVOKER`:
  - Den krever navn (`personnavn.fornavn/etternavn NOT NULL` og `ck_personnavn_navn_ikke_tomt`,
    `CL/0085:430-458`).
  - Den gir ingen tildeling.
  - Den gir 23505 når nummeret finnes og 23514 når det er ugyldig.

  De eneste som kaller den, er testpersonaene i samme fil (`:598-653`) og pgTAP 73.
- **Tildeling til en synlig person**: !6015 `CL/0087-tildeling-til-personsubjekt.sql` bytter målvakten
  i `tildel_brukertilgang`/`fjern_brukertilgang` til `krev_person` (`:21-47`). Tildelingsretten velges
  etter aktørledd (`krev_person_tildelingsrett`, `:49-75`; `tildel_brukertilgang`, `:77-131`).
  Målvakten (P0002) kommer før retten (42501), så et usynlig mål gir alltid P0002.
- **Koblingen Feide-bruker til person** (!6014 `CL/0086:40-100`, `:213-305`): coprocessoren finner eller
  oppretter personen på fødselsnummeret ved tokenutstedelse. Navnet kopieres fra `subjektnavn` bare når
  personen opprettes der (`:282-290`). En person brukeradministratoren har opprettet, får ikke navn når
  Feide-brukeren kobles senere. FS-genererte numre kobles ikke (`auth.er_fs_generert_serie`, `:22-38`;
  `kan_knyttes_til_person`, `:167-187`).
- **Klassifisering av miljø**: `miljo.er_syntetisk` finnes på `main`
  (`CL/0088-klassifisering-syntetisk-ekte.sql:9-19`, !6040). I4 («et syntetisk subjekt kan heller ikke
  tildeles tilganger [i et ekte miljø]») er ikke håndhevet for tildelinger
  (`tilgangsstyring/docs/syntetiske-og-ekte-data.md`, tabellen «Hvor reglene håndheves», rad I4).
- **Tildelbare roller**: `tildelbare_tilgangskoder(org, miljø)`
  (`CL/0057-tildelinger-splittes-etter-subjekttype.sql:405-431`) gir hele katalogen når kalleren har
  applikasjons- eller Feide-tildelingsretten i paret, ellers ingenting. `mine_tildelingsorganisasjoner()`
  (`:433-447`) er unionen av de samme to rettene. Ingen av dem teller `BRUKERADMIN_PERSON_TILDELING_SKRIV`.
  Modellen har ingen rett per rolle: «den som har [tildelingsretten] kan tildele alle roller i katalogen,
  `BRUKERADMIN`-privilegier inkludert» (`tilgangsstyring/docs/tilgangsmodell.md`, «RLS — ENABLE uten
  FORCE», punktet om tildeling).
- **Feilkoder**: `TS2xx` er serien for syntetiske og ekte data (`tilgangsstyring/CLAUDE.md`). `main` har
  `TS201` og `TS202`, og !6067 tar `TS203`.

### GraphQL (fs-plattform, Graphitron `10.0.0-RC38` på `main`, !6014 og !6015)

- Kildene for valglistene:
  - `Query.mineTildelingsorganisasjoner` og `Query.tildelbareTilgangskoder(organisasjonId, miljoId)`
    (`SCH/experimental/schema_exp.graphqls:1-28`)
  - `Query.mineSynligeMiljoer`, som gir alle miljøer (`SCH/stable/applikasjoner.graphqls:42-43`)
  - `Query.tilgangsroller`, som gir hele katalogen (`SCH/stable/rollekatalog.graphqls:1-21`)

  Ingen av dem svarer på «hvilke roller kan jeg tildele» på tvers av par, eller «hvilke miljøer
  administrerer jeg».
- !6015 (`SCH/experimental/schema_personsubjekt.graphqls`) har:
  - `Personsubjekt` (`typeId 20022`, `:23-64`)
  - `Query.personsubjekter(filter: {navnContains, organisasjoner, roller, miljoer})` (`:75-94`, `:98-122`)
  - `tildelPersonsubjektTilganger(input: [TildelPersonsubjektTilgangerInput!]!)` (`:147-219`). Den er
    allerede en bulkmutasjon: listeinput, alt-eller-ingenting i `ctx.transactionResult`, og
    `tilganger: [FeideBrukerTilgang]` i samme rekkefølge som input. Feilene er
    `ManglerTildelingsrett | PersonsubjektIkkeFunnet | TilgangskodeIkkeFunnet`. En usynlig, ukjent eller
    feiltypet person-id gir samme `PersonsubjektIkkeFunnet`.

  Servicen er !6015 `SVC/PersonsubjektTilgangService.java`, filtrene
  !6015 `SVC/PersonsubjekterFilterConditions.java`.
- Filteret `roller` på `personsubjekter` treffer personer med rollen aktivt, direkte eller arvet, i en
  tildeling kalleren ser (`harAktivTildeling` går gjennom `subjektrolletildeling_les`;
  !6015 `PersonsubjekterFilterConditions.java:68-79`). Det er semantikken ROL-001 ber om.
- `personsubjekter` mangler motstykket til `FeideBrukereFilterInput.skjulInaktiveFraAndreOrganisasjoner`
  (`SCH/experimental/schema_brukeradmin.graphqls:173-187`, `SVC/FeideBrukereFilterConditions.java:208-223`).
  Uten det viser brukeroversikten personer som bare har inaktive tildelinger hos kalleren.
- `FeideBrukerTilgang` (`SCH/experimental/schema_brukeradmin.graphqls:408-436`) har `organisasjon` og
  `miljo`. `FeideBrukerTilgangerFilterInput` (`:461-475`) kan filtrere på organisasjoner, miljøer og
  `tilgangskodeContains`, som er en delstreng. Det kan ikke filtrere på én bestemt tilgangskode.
- Grafen har ingen kobling mellom `Personsubjekt` og `FeideBruker`. !6015-spec-en sier at feltet kommer med
  iterasjon 2 (!6015 `tilgangsstyring/docs/specs/personsubjekt-api/spec-personsubjekt-api.md`,
  «Avgrensninger»), men !6014 har ingen skjemaendring.
- Ingen mutasjon tar fødselsnummer. Iterasjon 4 i !6015-spec-en («Avklart 06.10.2026») er «en mutasjon som
  tar inn fødselsnummer, tildeler den første rollen og returnerer den nå synlige personen».

### FS Admin (`origin/main` `24c76aa7`)

Den lokale klonen (`C:/Users/kjetihoy/dev/fs-admin`) står på en lokal `main` som har divergert
(2769 foran og 13 bak `origin/main`, seks endrede filer). Alt under er lest fra `origin/main`.

- **Ruter**: `src/app/tilgangsstyring/{personbrukere,applikasjoner}/` har tynne `layout.tsx`/`page.tsx`.
  `personbrukere/layout.tsx:14-15` har brødsmuler (`PageHeaderWrapper`) og
  `WithRole permittedRoles={['BRUKERADMINISTRASJON_LES']}`. `personbrukere/page.tsx:8-18` og
  `[id]/page.tsx:19-37` ligger bak Unleash-flagget `tilgangsstyring-brukeradministrasjon`. Typede ruter
  ligger i `src/common/types/generated/routes.d.ts` (`npm run generate:routes`).
- **Meny**: `src/features/Header/Menu/Menu.tsx:87-126` har undermenypunkter med `featureFlag` og
  `rollekoder`. Indekssiden `src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.tsx:55-113`
  har ett kort per område.
- **Brukeroversikten**: `TS/PersonbrukereOverview/`.
  - Spørringen er `GET_FEIDE_BRUKERE` (`hooks/useGetPersonbrukere.tsx:27-45`), med
    `filter: {…, roller, skjulInaktiveFraAndreOrganisasjoner: true}` (`:94-111`).
  - Listen bruker `NavigationList`/`ListItemCell`
    (`components/PersonbrukereResultList/PersonbrukereResultList.tsx:92-168`).
  - Pagineringen ligger i `useDataListQuery`, og hver connection har en cache-policy
    (`src/common/lib/apollo/cacheConfig.ts:89`).
- **Brukersiden**: `TS/PersonbrukerDetails/PersonbrukerDetails.tsx:65-146` gjelder bare `FeideBruker`
  (`hooks/useGetPersonbruker.tsx`, `node(id){… on FeideBruker}`).
  - «Tildel roller» er `components/PersonbrukerRoller/…/TildelRolleModal/TildelRolleModal.tsx`
    (484 linjer), bygget med `useState` og uten skjemabibliotek.
  - Organisasjon kommer fra `mineTildelingsorganisasjoner` (låst når det er én, `:124-130`), miljø fra
    `mineSynligeMiljoer` og kodene fra `tildelbareTilgangskoder`.
  - Feilrutingen går på `__typename` (`:259-271`), og snackbaren vises etter at dialogen er lukket
    (`:320-334`).
  - Skrivingen er `hooks/useTildelFeideBrukerTilganger.tsx`, med ett alias-rotfelt per rad
    (`batchTildeling.ts`), slik at hver rad får sitt eget utfall fra en alt-eller-ingenting-mutasjon.
  - Knappen er gatet på `BRUKERADMINISTRASJON_TILDELING` og på at `mineTildelingsorganisasjoner` ikke er
    tom (`PersonbrukerRoller.tsx:72`, `PersonbrukerRollerActionbar.tsx:52-60`).
- **Personsubjekter**: fs-admin har ingen treff på `personsubjekt`. Det publiserte SDL-et
  (`fs.sikt.no/api/schema/{test,production}/experimental`) har heller ingen `Personsubjekt`.
- **Codegen-skjemaet** er det publiserte SDL-et fra `production/experimental`
  (`graphqlSchemaLocation.ts:22`, `codegen.ts:31`). Det kan overstyres med `GRAPHQL_SCHEMA_LOCATION` eller
  `scripts/merge-subgraph-schema.mjs`. CI kan bruke en `local-supergraph.graphql` fra en fs-plattform-gren
  (`.gitlab/ci/ci-supergraph-helpers.yml`).
- **Fødselsnummer**: `src/domains/person/utils/formatFodselsnummer.ts:1-5` formaterer bare. Mod 11 finnes
  bare i en test (`src/common/lib/persona/constants/testPersonas.test.ts:19-26`).
- **Snackbar** (`src/common/components/Snackbar/useSnackbar.tsx:8-44`): ren tekst og én valgfri
  handlingsknapp (`actionFunction`, `actionFunctionLabel`). Den kan ikke vise en lenke.
- **Tekster**: bare `nb` (`src/common/messages/nb/domains.json`, `tilgangsstyring.<Komponent>`;
  `PersonbrukerTildelRolleModal` på `:157-184`).
- **Tester**:
  - Jest 30 og jest-axe; en `*.a11y.test.tsx` er påbudt for hver komponent.
  - Apollo `MockedProvider` med importerte dokumenter (`TildelRolleModal.test.tsx`).
  - En integrasjonstest fra liste til detalj
    (`src/domains/tilgangsstyring/integration/PersonbrukerMasterDetail.integration.test.tsx`).
  - Ingen e2e.
- **Rettigheter i klienten**: `Query.mineTilganger` gjennom `useTilganger()`, og `WithRole`/`useWithRole`
  (`src/features/WithRole/`). Rollekodene `BRUKERADMINISTRASJON_LES/_SKRIV/_TILDELING` er generert i
  `src/common/types/generated/tilgangsroller.ts`.

## Key Findings

1. **Kjerneoperasjonen finnes ikke.** Ingen funksjon eller mutasjon tar (nummer, rolle, organisasjon,
   miljø), finner eller oppretter personen, tildeler og svarer likt. Den kan ikke bygges på
   `tildel_brukertilgang` slik den er, fordi målvakten `krev_person` (SECURITY INVOKER) ikke ser en person
   kalleren ikke ser fra før. Den kan heller ikke bygges på `opprett_person`, som gir 23505 for en
   eksisterende person og ikke kan se raden den kolliderer med (RLS).
2. **En person uten navn er lovlig i skjemaet.** `personnavn` er en egen tabell, og en person uten rad der
   er gyldig: `Personsubjekt.navn` er nullbar, og sorteringen faller tilbake på `subjekt_id`. Det er bare
   `opprett_person` som krever navn.
3. **Rekkefølgen på sjekkene avgjør om operasjonen blir et eksistensorakel.** Disse sjekkene kan alle
   avgjøres uten å slå opp personen:
   - retten (42501)
   - tilgangskoden (P0002 «tilgangskoden …»)
   - nummerets form og kontrollsifre
   - testperson mot ekte miljø: personens klassifisering avledes av nummeret (`auth.er_tenor_serie`), og
     miljøets står i `miljo.er_syntetisk`

   Når de er passert, er suksess det eneste utfallet som gjenstår. Det gjelder hvert element i en bulk:
   ingen feil kan avhenge av om personen fantes.
4. **«Roller brukeradministratoren har rett til å tildele» er hele katalogen** i dagens modell, når kalleren
   har tildelingsretten for personer i minst ett par. Scenarioet «har rett til å tildele noen roller, men
   ikke alle» kan ikke settes opp før modellen har rett per rolle. Se «Requirements Impact».
5. **Valglistene i dialogen mangler kilder.** `mineTildelingsorganisasjoner` teller ikke personretten, og
   `mineSynligeMiljoer` gir alle miljøer. Dialogen skal bare vise miljøene brukeradministratoren
   administrerer.
6. **Rollesiden kan bygges på `personsubjekter(filter: {roller})`** fra !6015. Radene, én per bruker og
   tildeling, trenger tildelingene av akkurat rollen. `tilgangskodeContains` er en delstreng og treffer
   også andre koder: `X` treffer `X_LES`.
7. **Brukeroversikten for personer trenger filteret som skjuler inaktive.** Det ble vedtatt for
   Feide-brukere 25.09.2026, og for personer i spec-en. For personer betyr «hører hjemme hos meg»
   hjemorganisasjonen til en koblet Feide-bruker (!6014), ikke et domene på personen.
8. **I4 for tildelinger må håndheves på nytt.** `miljo.er_syntetisk` og `personsubjekt.er_syntetisk` finnes,
   men ingen tildelingsfunksjon sammenligner dem. Håndheves det i `tildel_brukertilgang`, gjelder det også
   `tildelPersonsubjektTilganger` og Feide-brukere. Tabellen i `syntetiske-og-ekte-data.md` skal da
   oppdateres i samme MR.
9. **Navnet etter første pålogging er ikke på plass.** !6014 kopierer navnet bare når coprocessoren
   oppretter personen (`CL/0086:282-290`). En person brukeradministratoren har opprettet, får ikke navn når
   hen logger inn med Feide. Regelen «Navnet hentes fra påloggingen» er `@draft`, men uten den står alle
   personer gitt med nummer uten navn i listene.
10. **Migrerings- og feilkodenumrene er nesten oppbrukt.**
    - Migreringer: `main` har 0085 og 0088. !6014 har 0086 og !6015 har 0087. Både !6064 og !6067 har
      0089, så de to kolliderer med hverandre.
    - pgTAP: `main` har 73 og 76. !6014 har 74, !6015 har 75 og !6067 har 77.
    - Første ledige er migrering 0090, pgTAP 78 og feilkode TS204.
11. **!6014 og !6015 er søsken, ikke en stabel.** Begge går mot `main`: !6015 fra `e1cd7938f`, !6014 fra
    `c285371f1`. !6014 er ute av utkast og har reviewere (alfle, mask). !6015 er utkast uten reviewere.
    Begge endrer `tilgangsstyring/docs/tilgangsmodell.md` og `db-changelog-root.xml`.
12. **FS Admin kan ikke kompilere mot et skjema som ikke er publisert i `production/experimental`.**
    Codegen og typesjekken i CI bruker det publiserte SDL-et. Personsubjekt-flaten og den nye mutasjonen må
    derfor være deployet i produksjon før fs-admin-MR-ene kan bli grønne, med mindre CI pekes mot en
    `local-supergraph.graphql` fra fs-plattform-grenen.
13. **Snackbaren kan ikke lenke.** Designforslaget om «Åpne personen» i snackbaren kan bare lages som
    handlingsknappen (`actionFunction` med `router.push`).
14. **En bulkmutasjon gir én feil for hele kallet.** For en `@service` fører Graphitron nøyaktig én
    exception ut i `errors`, så det første elementet som feiler, stopper kallet, og feil per element kan
    ikke representeres (`fsp-mutation-standards` §3). Bulk betyr her alt-eller-ingenting med én typet
    feil, slik `tildelPersonsubjektTilganger` allerede er. fs-admin får utfall per rad ved å sende ett
    alias-rotfelt per rad (`batchTildeling.ts`).

## Technical Constraints

- **`tilgangsstyring/CLAUDE.md`**:
  - Basen er autoritativ (I3).
  - Bruk kolonnen direkte (`er_syntetisk`), ikke generelle `subjekt_*`-oppslag.
  - Skriv en SQL-funksjon bare når en join ikke holder, eller når den er et
    `SECURITY DEFINER`-inngangspunkt.
  - Et `RAISE` ruller tilbake hele kallet.
  - Additivt før subtraktivt.
  - Sjekk åpne MR-er før `CREATE OR REPLACE`.
  - Migrerings- og pgTAP-nummer er det første ledige på `main` og i åpne MR-er.
  - Feilkodene ligger i `TS`-serien.
- **`syntetiske-og-ekte-data.md`** er autoritativ. MR-en som endrer håndhevingen, oppdaterer tabellen
  «Hvor reglene håndheves».
- **RLS uten FORCE, eieren går forbi** (`tilgangsmodell.md`). En `SECURITY DEFINER`-funksjon eid av
  migreringsrollen leser forbi RLS. Den må derfor sjekke retten selv og ha `SET search_path`.
  `auth.orger_med_tilgang` leser sesjonsclaimene og virker også under DEFINER, slik
  `personer_i_mine_person_les_organisasjoner` viser.
- **Fødselsnummeret er ikke en del av grafen** (!6015-spec-en): ingen felt, intet filter og intet oppslag.
  En mutasjon kan ta det inn, men svaret kan ikke speile det.
- **Mutasjoner er bulkmutasjoner** (Kjetil, 07.10.2026: «For backend, we want mutations to be bulk
  mutations, to support reuse»): listeinput, og en payload med én rad per element i samme rekkefølge. Et
  enkelt valg i grensesnittet sendes som en liste med ett element.
- **Mutasjonskonvensjonene** (`fsp-mutation-standards`, `fsp-mutasjonskonvensjoner`):
  - `@service` når skrivingen berører flere tabeller.
  - `ctx.transactionResult` inne i servicen, og en test for delvis feil.
  - Ikke noe `errors`-felt i payload-klassen.
  - `@error`-handlere bare for feil som kan nås.
  - Rettighetssjekken kommer før skrivingen og blir ikke et id-orakel.
  - Testene dekker tom input, null input og blandet batch.
  - `api-design-review` kjøres på skjemaformen.
  - Graphitron-versjonen er RC38 på `main`, !6014 og !6015. Liste-av-interface i payload virker fra RC36.
    Tom input er versjonsbundet og må verifiseres for `@service` på RC38. RC40 (!6050) er i utkast med
    kjente feil.
- **Nytt skjema legges i experimental** (`fsp-graphql-standards`), med `@asConnection` og
  `defaultFirstValue`, i søsterfiler per tema. Ledige typeId-er sjekkes mot alle `*.graphqls` og åpne
  grener.
- **Klienten gater på roller fra `mineTilganger`**, ikke på `kan*`-flagg fra serveren (`tilgangsmodell.md`,
  «Rettighetsgating skjer klientside»). Det gjelder fs-admin `WithRole`/`useWithRole`.
- **fs-admin, `CLAUDE.md` og `graphql-consumer`**:
  - Sidene i `src/app` er tynne.
  - Fragmenter og operasjoner ligger sammen med komponenten (`gql` fra `@/__generated__`).
  - En mutasjon tar én `$input` og velger alltid `errors { ... on Error { message path } }`.
  - `refetchQueryNames(...)` brukes ved ny henting.
  - Hver ny paginert rot trenger en `cacheConfig`-policy.
  - Eksperimentelle felt sendes med headeren `Feature-Flags: experimental`.
  - Hver komponent har en `.a11y.test.tsx`.
  - Endringer brukeren ser, trenger et changeset.
  - Dialoger bruker `FSModal` (`fs-admin-modal`).
  - Listesider følger `fs-admin-list-pages`, detaljsider `fs-admin-detail-pages`.
- **Ikke bruk den lokale hovedklonens database eller `mise run build`** i denne fasen. Utførelsen
  verifiserer mot en egen Postgres med fast Quarkus-testport.
- **Ordbruk**: modellens egne begreper (person, personsubjekt, Feide-bruker, tildeling, rolle,
  brukeradministrator). Tekstene i designfilene er forslag som Kjetil må godkjenne.

## Dependencies

- **Internt (fs-plattform)**
  - !6015, personsubjekt-API-et: `Personsubjekt`, `personsubjekter`, `tildelPersonsubjektTilganger`,
    `krev_person` og `krev_person_tildelingsrett`. Alt i denne featuren bygger på det.
  - !6014, koblingen og hjemorganisasjonsgrenen. Den trengs for scenarioet «personen har logget inn med
    Feide tidligere», der personen alt finnes og er koblet, og for filteret som skjuler inaktive
    (hjemorganisasjonsgrenen). Kjerneoperasjonen trenger den ikke.
  - !6067, BAT-262 (Martin Skurtveit): `identitet_for_*` i `0089`. Den rører ikke `personsubjekt`,
    `opprett_person` eller tildelingsfunksjonene, og tar `TS203`. Den overlapper med denne featuren i
    `db-changelog-root.xml`, `syntetiske-og-ekte-data.md` og nummerserien.
  - !6064, BAT-228 subtraktiv: `0089` kolliderer med !6067. Det er ikke vårt å løse, men rekkefølgen
    på `main` avgjør hvilke numre som er ledige når vi merger.
  - Migreringsskriptet i !6014 (`scripts/personsubjekt-migrering/`) skal kjøres «etter at FS Admin kan vise
    og tildele roller til personsubjekter». Det er denne featuren som gjør FS Admin i stand til det.
- **Eksternt**
  - Graphitron 10.0.0-RC38. !6050 oppgraderer til RC40 og er i utkast.
  - Apollo-supergrafen og skjemasjekken. fs-admin bruker det publiserte SDL-et (Key Finding 12).
  - Unleash-flagg for de nye rutene, eller gjenbruk av `tilgangsstyring-brukeradministrasjon`.
- **På tvers av bidragsytere**
  - **Frontend (fs-admin)**: rolleoversikten, rollesiden, dialogen «Gi rollen til en person», og
    personvarianten av brukeroversikten og brukersiden med «Tildel roller». Arbeidet blokkeres av skjemaet
    i fs-plattform, som må være publisert i `production/experimental` eller tilgjengelig som lokal
    supergraf i CI.
  - **Kjetil (produkt og krav)**: godkjenning av tekstene og de åpne designspørsmålene i de tre
    designfilene.
  - **Martin Skurtveit (BAT-262)**: koordinering av migreringsnumre og endringer i
    `syntetiske-og-ekte-data.md`.

## Requirements Impact

Kravene er `@BRU-PER-ROL-001` (se brukere på rolle), `@BRU-PER-ROL-002` (regelen «Gi rollen til en person
med fødselsnummer, D-nummer eller SNR») og `@BRU-PER-GRU-013` (reglene som ikke er `@draft`).

### Kravendringer etter spec-en

- `265163b`: scenariet «Flere roller gis i samme operasjon …» (`@draft`) er erstattet av
  «Flere tilganger legges til fra brukersiden etter den første rollen». Det står i regelen «Den første
  tildelingen …», som ikke er `@draft`. Ingen inngang oppretter med flere roller. Flere roller gis med
  «Tildel roller» på brukersiden for personen, over `tildelPersonsubjektTilganger`.
- `9527781`: nytt `@must`-scenario i ROL-001, «Åpne brukersiden fra rollens oversiktsside». Raden i listen
  åpner brukersiden, og der kan brukeradministratoren tildele flere roller.

### Krav som er dekket i koden i dag

- GRU-013 «Brukeradministrator gir tilgang med nummer uten egen rettighet»: privilegiene er implisert fra
  brukeradministrator-rollen (`CL/0085:51-69`).
- GRU-013 «Nummer med ugyldige kontrollsifre avvises»: CHECK-en i basen (`CL/0085:138`), men API-et har
  ingen feiltype for det.
- GRU-013 «Nummeret vises ikke etterpå»: grafen eksponerer ikke fødselsnummeret (!6015).
- ROL-001 «Vise brukere som har en aktiv rolle» og «Brukere brukeradministratoren ellers ikke kan se,
  vises ikke»: `personsubjekter(filter: {roller})` (!6015) har den semantikken.

### Krav som ikke er dekket (koden skal bygges eller endres)

- GRU-013 og ROL-002, alle scenarioene i «Den første tildelingen …» og «Svaret avslører ikke …»: den nye
  operasjonen (Key Findings 1, 3 og 14).
- GRU-013 «En testperson kan ikke få tilgang i et ekte miljø»: I4 for tildelinger (Key Finding 8).
- GRU-013 «Personen kan ikke legges til uten en rolle» og «Rolle brukeradministratoren ikke har rett til å
  tildele»: følger av at operasjonen krever alle fire verdiene og sjekker retten før personen opprettes.
- ROL-001 «Rolleoversikten viser bare roller …»: en kilde for rollene på tvers av par (Key Finding 4).
- ROL-002, valglistene for organisasjon og miljø: nye kilder (Key Finding 5).
- ROL-001 «Åpne brukersiden …» og GRU-013 «Flere tilganger legges til fra brukersiden …»: brukersiden for
  en person i FS Admin, med «Tildel roller» over `tildelPersonsubjektTilganger`.
- GRU-013 «… ser personen i brukeroversikten»: brukeroversikten må vise personer, med filteret som skjuler
  inaktive (Key Finding 7).

### Krav i faresonen

- **ROL-001 «Rolleoversikten viser bare roller brukeradministratoren har rett til å tildele»**: i dagens
  modell er utvalget hele katalogen eller ingenting, så «noen, men ikke alle» kan ikke reproduseres.
  Implementasjonen kan følge modellen, men `bat-verify` kan ikke bekrefte scenarioet slik det er skrevet.
- **GRU-013, scenariomalen med SNR**: SNR passerer mod 11 og har måned + 50. Kravet sier at SNR har en
  egen personnummerserie, men det er ikke bekreftet. Overlapper SNR med FS-generatorens serie (måned + 50,
  pnr fra 70000), kan løsningen ikke skille dem, og en regel som avviser FS-genererte numre vil også
  avvise SNR.
- **GRU-013 «Personen har logget inn med Feide tidligere»**: forutsetter at fødselsnummeret er kjent fra
  koblingen (!6014). Uten kobling oppretter operasjonen en ny person, og Feide-brukeren kobles til den ved
  neste pålogging (`koble_feide_bruker_til_person` finner personen på nummeret). Scenarioet er oppfylt så
  lenge !6014 er i drift.
- **Navnet i listene** (ROL-001-designet, «Bruker uten navn»): uten navnekopiering ved kobling (Key
  Finding 9) står personer gitt med nummer uten navn, også etter at de har logget inn med Feide.
- **Brukeroversikten viser bare personer** (avgjort). Feide-brukere med rollene på Feide-brukeren
  forsvinner fra oversikten til migreringsskriptet i !6014 har flyttet rollene. Skriptet krever at FS Admin
  kan vise personer, så rekkefølgen er gitt, men vinduet mellom deploy og kjøring av skriptet må være
  kort.
- **Svaret som eksistensorakel i bulk**: payloaden gir den nå synlige personen. Feltet `navn` er satt for
  en person som har logget inn før, og tomt for en ny. Klienten skal ikke vise navnet i beskjeden. Lista
  viser det likevel etter ny henting, og det er det åpne spørsmålet i den `@draft`-merkede regelen
  «Navnet hentes fra påloggingen».

### Mangler i kravene oppdaget i analysen

- Hva skjer med et FS-generert nummer (måned + 50, pnr fra 70000)? `tilgangsstyringsidentitet.md` sier at
  slike numre «kan ikke nøkle en person», og !6014 kobler dem ikke. Kravet nevner dem bare i forklaringen
  til SNR.
- Skal rolleoversikten vise atomære tilganger (`rolletype` TILGANG) eller bare sammensatte roller (ROLLE)?
  Designet har kolonnene «Rolle» og «Beskrivelse» og sier ikke noe om det.
- Skal rollesiden vise Feide-brukere som har rollen på Feide-brukeren? Det er et åpent designspørsmål i
  `se_brukere_på_rolle.design.md`.

## Krav-input referanse

Kravene ligger i en annen mappe enn analysen (`spec_dir` i `.claude/spec.local.md`). Lenkene er relative
til den publiserte kopien i
`tasks/brukeradministrasjon-og-tilgangsstyring/gi-tilgang-med-nummer-fra-rollesiden/backend/`:

- **Spec-dokument:** [`spec-gi-tilgang-med-nummer-fra-rollesiden.md`](../spec/spec-gi-tilgang-med-nummer-fra-rollesiden.md)
- **Krav-input-manifest:** [`krav-input/manifest.md`](../spec/krav-input/manifest.md)

## Open Questions

Analysen ble kjørt av en agent som ikke kunne spørre Kjetil underveis. Spørsmålene står derfor åpne.
`bat-plan` velger et utgangspunkt for hvert av dem, og valgene står i planen.

- [ ] **Q1. FS-genererte numre.** Skal operasjonen avvise et nummer i FS-generatorens serie (måned + 50,
      pnr fra 70000)? Alternativer: (a) avvise med samme feil som et ugyldig nummer, (b) avvise med en
      egen feil, (c) godta. Svaret avhenger av om SNR har en egen serie.
- [ ] **Q2. Ekte person i et testmiljø.** Skal tildelingen avvises (I5/I1), eller godtas uten å gi
      tilgang? Det er et åpent spørsmål i GRU-013.
- [ ] **Q3. Rolleoversiktens utvalg.** Alternativer: (a) hele katalogen når kalleren har personretten i
      minst ett par, (b) bare `rolletype` ROLLE, (c) vente på rett per rolle. Valget påvirker også
      `bat-verify` av ROL-001.
- [ ] **Q4. Feide-brukere på rollesiden.** Skal rollesiden vise bare personer, eller også Feide-brukere med
      rollen på Feide-brukeren til migreringsskriptet er kjørt?
- [ ] **Q5. Navn ved kobling.** Skal koblingen i !6014 kopiere navnet fra Feide-brukeren til en person som
      mangler navn? Regelen «Navnet hentes fra påloggingen» er `@draft`.
- [ ] **Q6. Hvor I4 håndheves.** I `tildel_brukertilgang`, som dekker alle veier (også Feide-brukere og
      `tildelPersonsubjektTilganger`), eller bare i den nye operasjonen?
- [ ] **Q7. Tekster.** Tekstene i de tre designfilene er forslag som må godkjennes.
