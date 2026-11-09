# Task #5 Completion Report: `idporten_applikasjon`, taket og tilgangsfunksjonen (0082–0083)

## Status: ✅ COMPLETED

**Date Completed**: 2026-09-25
**Task**: `idporten_applikasjon`, taket og tilgangsfunksjonen (0082–0083)
**Priority**: High
**Size**: L

## Summary
En ID-porten-klient er nå en egen applikasjon (`idporten_applikasjon`, nøklet på `client_id`) med eget
delegeringstak i `applikasjon_brukerdelegering`. FK-en fra taket er løsnet fra `feide_applikasjon` til en
kompositt-FK mot `subjekt` med CHECK på de to apptypene, og `applikasjon_er_deaktivert` kjenner den nye
tabellen. `tilganger_for_idporten_bruker(env, client_id, fnr)` er coprocessorens ene oppslag og regner
tilgangene med `tilganger_for_bruker` uendret. GraphQL-stien for `FeideApplikasjon.brukerdelegeringer` og
forvaltningsservicen går nå eksplisitt via `subjekt_type = 'feide_applikasjon'`.

## Files Created
### 1. `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0082-idporten-applikasjon.sql` (~230 linjer)
Sju changesets:
- `0082-subjekttype-idporten-applikasjon`: typen, `aktorledd = 'applikasjon'`.
- `0082-create-idporten_applikasjon`: tabellen i samme form som `maskinporten_applikasjon` etter 0017/0024/0026/0041. Den har pk, unik `navn` og `client_id`, kompositt-FK mot subjekt og typesperre, eierorganisasjon og ansvarlig, begge sporingsledd for opprettet/endret, `deaktivert_tidspunkt`, generert `status`, deaktivert-av-ledd med par-CHECK, `er_gyldig_navn` og triggerne `set_opprettet_av`/`set_endret`. Den har ikke `iso6523_actorid_upis` og ikke `beskrivelse`.
- `0082-idporten_applikasjon-rls`: RLS på, `_les` (0023-form) og `_skriv` FOR ALL (0019-form).
- `0082-brukerdelegering-subjekttype` (`lock_timeout = '2s'`): `subjekt_type TEXT NOT NULL DEFAULT 'feide_applikasjon'` (fyller eksisterende rader), `ck_applikasjon_brukerdelegering_subjekt_type IN ('feide_applikasjon','idporten_applikasjon')` og `fk_applikasjon_brukerdelegering_subjekt (subjekt_id, subjekt_type) → subjekt`. `fk_applikasjon_brukerdelegering_app` er droppet. Tabellkommentaren er omskrevet med REGEL-teksten fra 0043 ordrett. Kommentaren på `feide_applikasjoner_eid_av_mine_les_organisasjoner_per_miljo` er rettet, fordi den begrunnet seg med FK-en som er borte.
- `0082-applikasjon-er-deaktivert-idporten`: `CREATE OR REPLACE` med en fjerde gren.
- `eksempeldata-0082-idporten_applikasjon` (`context:@eksempeldata`): -27 og -28, med taket kopiert fra Feide-appene med 0059-vaktene (katalog-EXISTS, NOT EXISTS mot aktive, DISTINCT). Oppslaget går på `service_id` → `client_id`, ikke på subjekt_id.

### 2. `…/db/changelog/0083-tilganger-for-idporten-bruker.sql` (~50 linjer)
`tilganger_for_idporten_bruker(p_env, p_client_id, p_fodselsnummer)` er SQL, STABLE, SECURITY DEFINER og har fast search_path. Formen er som `tilganger_for_feidetjeneste_og_bruker` (0063): `tilganger_for_bruker(env, personsubjekt på fnr, idporten_applikasjon på client_id, NULL)`, filtrert på `subgrafrolle`. Den har ingen egen gulvlogikk. `REVOKE ALL FROM PUBLIC` og `GRANT EXECUTE` bare til `${coprocessor_role}`.

### 3. `…/src/test/sql/73_idporten_applikasjon.sql` (30 assertions)
Apptypen (aktorledd, ikke-person i policyene, pk/unik/FK, typesperre, navnesjekk, RLS og policyinventar, synlighet i og utenfor eierorganisasjonen). Taket: den gamle FK-en er borte, kompositt-FK-en og DEFAULT finnes, og alle rader peker på en app av sin egen type. **CHECK-en avviser en takrad for en maskinporten-app (23514)**, og FK-en avviser en ID-porten-app merket som Feide (23503). Eksempeldataene: begge takene er like Feide-kildene, en ny Feide-rad speiles ikke over, og radene er merket med riktig type. Forvaltningen feiler lukket: `kan_forvalte_delegering(-27, …)` er false der `(-22, …)` er true, og en direkte INSERT gir 42501. Deaktiveringsvetoet ser appen.

### 4. `…/src/test/sql/74_tilganger_for_idporten_bruker.sql` (26 assertions)
Fiksturen legger inn en åpen rolle i test (`T74_APEN` @ 97401), så «bare åpne roller» ikke er det samme som tomt. Settet dekker alle punktene i akseptansekriteriet:
- Uregistrert person via FS Admin (test) gir bare åpne roller.
- Registrert person (saksbehandler @ 7777) gir rollens orgtilgang og ikke 7778.
- En rolle utenfor taket (`T74_UTENFOR`) gir ingenting.
- Uregistrert person via Min kompetanse (test) gir student @ 7777/7778 pluss åpne roller.
- **Samme** uregistrerte person via FS Admin gir ikke student.
- Registrert person med saksbehandler via Min kompetanse gir student, men ikke saksbehandler.
- Ukjent `client_id`, `NULL` og Feide-`service_id` som `client_id` gir bare åpne roller. Testen kjøres med en registrert person, så et tak tolket som ubegrenset ville vist saksbehandler (NULL-fella, funn 5).
- **Deaktivert -27 gir tomt, også uten åpne roller**, mens -28 fortsatt svarer.

I tillegg: `fnr = NULL` er det samme som uregistrert, ingen `personsubjekt` opprettes, production gir ingenting fra test-taket, SECURITY DEFINER, kroppen er lik kjernen filtrert på subgrafrolle, og en forretningsrolle slipper ikke ut. Rettighetene: coprocessoren kan kalle funksjonen uten tabellrettigheter, og app- og replikeringsrollen har ikke EXECUTE (42501).

## Files Modified
### 1. `…/db/changelog/db-changelog-root.xml`
Includes for 0082 og 0083 med avhengighetskommentarer.
### 2. `…/src/test/sql/26_sporing_delte_aktorkolonner.sql`
Subjekttype-inventaret har fått `idporten_applikasjon`. Sporingstellingene er 20/11/9, opp fra 19/10/9, og kommentaren forklarer hvorfor.
### 3. `fs-plattform/tilgangsstyring/tilgangsstyring-service/src/main/java/no/sikt/fs/tilgangsstyring_service/BrukerdelegeringForvaltningService.java`
Konstanten `FEIDE_APPLIKASJON`. INSERT-en setter `SUBJEKT_TYPE` eksplisitt, og `delegeringen(...)`, som brukes av både idempotensoppslaget og UPDATE-en ved tilbaketrekking, filtrerer på `SUBJEKT_TYPE = 'feide_applikasjon'`. En ID-porten-takrad kan dermed aldri treffes eller lukkes gjennom Feide-API-et.
### 4. `fs-plattform/tilgangsstyring/tilgangsstyring-app/src/main/resources/schema/features/experimental/schema_delegeringstak.graphqls`
`FeideApplikasjon.brukerdelegeringer`: `@reference(path: [{key: "feide_applikasjon__fk_feide_applikasjon_subjekt"}, {key: "applikasjon_brukerdelegering__fk_applikasjon_brukerdelegering_subjekt"}])`. Kommentaren rett under feltet, som beskrev det gamle enhoppet, er rettet. Headeren «HVORFOR KUN FeideApplikasjon» (linje 11–15) er ikke rørt, fordi den hører til Task #12. Den nevner nå en FK som ikke finnes lenger.

## Key Features Implemented
### ✅ Egen apptype med eget tak
### ✅ Løsnet FK med typesperre (kompositt-FK + CHECK), DEFAULT for eksisterende rader
### ✅ Deaktiveringsvetoet dekker ID-porten-appen (tomt, ikke åpne roller)
### ✅ Ett oppslag per innlogging: `tilganger_for_idporten_bruker`
### ✅ Testklienter i eksempeldata, med kopiert tak

**Testklient-id-er til Task #7 (coprocessorens testprofil):**

| subjekt_id | navn | `client_id` | tak (kopiert fra) |
|---|---|---|---|
| -27 | FS Admin (test) | `idporten-test-fs-admin` | saksbehandler @ 7777/7778 test (fra Feide -22) |
| -28 | Min kompetanse (test) | `idporten-test-min-kompetanse` | student @ 7777/7778 test (fra Feide -21) |

Gulvet i test er student @ 7777/7778. Åpne roller finnes i eksempeldataene bare i `demo` (`apne_emnedata`), så i
`test` gir «bare åpne roller» tomt, med mindre testen legger inn en åpen rolle. `IdportenCoprocessorTest`
bruker i dag `CLIENT_ID = "fs-admin"`. Det må byttes til id-ene over i Task #7.

## Project skills consulted
- `sta-fso-bat-utilitybelt:subgraph-expand`: endringen er et 1:1-treff på et mønster repoet alt bruker, toleddssti via subjekt-ankeret som i `FeideApplikasjon.tilganger`/`miljoer` i `features/stable/applikasjoner.graphqls:180-186`. Derfor trengtes ingen `subgraph-plan`. Skillen ber om logging i `spec.log.md` og en egen `subgraph-expansion-*.md`. Begge er utelatt, fordi agentgrensen forbyr å skrive `spec.log.md`, og oppsummeringen står i denne rapporten.
- `fs-testdata-creation` er vurdert, men ikke brukt: eksempeldataene er en del av migreringen (`context:@eksempeldata`), ikke lokal testdata.

## Test Results
- pgTAP (Testcontainers, alle migreringer mot tom base): `cd fs-plattform/tilgangsstyring && mise exec -- mvn -q -pl :tilgangsstyring-new-db test`. Resultat: `tests="1426" errors="0" skipped="0" failures="0"`, opp fra 1370, altså +30 (73) og +26 (74). Sett 37 (delegeringstak), 42 (0048-forvaltningen), 01, 26, 51 og 66 er grønne.
- Lokal base: `mise run migrate` og `mise run jooq` ga BUILD SUCCESS. -27/-28 og takene deres finnes lokalt.
- `mise exec -- mvn -pl :tilgangsstyring-app test -Dtest=DelegeringstakGraphqlTest` ga 14/14 grønne.
- Hele service og app: `mise exec -- mvn -pl :tilgangsstyring-service,:tilgangsstyring-app test` ga 518 tester, 1 feil og 5 hoppet over. Feilen er `RollekatalogForvaltningGraphqlTest.tildelingKunITestAvvises` (`TilgangsrolleFinnesAllerede`), en kjent ikke-idempotens mot gjenbrukt base (se planen, Testing Requirements). Den er uavhengig av denne endringen.

## Technical Decisions
### 1. Eksempeldata-id-er -27/-28, `client_id` som lesbare plassholdere
**Why**: -27 og -28 er ledige i migreringer og tester. En lesbar id kan ikke forveksles med en Digdir-UUID, og den er lett å bruke i testprofilen.
### 2. Takkopien slår opp på `service_id` → `client_id`, ikke på subjekt_id
**Why**: samme form som en prod-migrering vil få når Digdir-klientene finnes (0059-mønsteret).
### 3. `subjekt_type` settes eksplisitt og filtreres i servicen, i tillegg til DEFAULT
**Why**: planen ga begge valg. Filteret gjør det eksplisitt at Feide-API-et ikke kan lese eller lukke en ID-porten-rad, uten å lene seg på at subjekt_id er unik på tvers av tabellene.
### 4. Tabellkommentaren beholder REGEL-teksten fra 0043 ordrett
**Why**: sett 37 fester at regelen står på objektet. Den er utvidet med at en app med to klienter har to tak.
### 5. App-rollens standardrettigheter på `idporten_applikasjon` er beholdt
**Why**: «RLS som for de andre applikasjonstabellene». Det finnes ingen skriveflate i API-et, og taket er uansett lukket for forvaltning via `kan_forvalte_delegering`.

## Build Status
✅ **Build successful**: new-db (pgTAP 1426/1426), migrate, jooq, service og app kompilerer, Graphitron godtar den nye stien.
✅ **No new linter warnings**
✅ **All imports resolved correctly**

## Integration Points
- Task #7: `TilgangsstyringDataTilgangerService.tilgangerForIdportenBruker` kaller `tilganger_for_idporten_bruker(env, client_id, pid)`. Testprofilen bruker `client_id`-ene over.
- Task #12: headeren i `schema_delegeringstak.graphqls` og `docs/tilgangsmodell.md`. Forskjellen på ukjent og deaktivert app er festet i sett 74 og kan beskrives derfra.
- T1: forvaltningen av ID-porten-taket er lukket (sett 73, DEL 4) til den er avklart.

## Acceptance Criteria Met
- ✅ Subjekttype med `aktorledd = 'applikasjon'`. Evidence: 0082 changeset 1 og sett 73 test 1–2.
- ✅ Tabellen etter maskinporten-mønsteret med RLS. Evidence: 0082 changeset 2–3 og sett 73 test 3–13.
- ✅ `subjekt_type` + DEFAULT + kompositt-FK + CHECK, gammel FK droppet, kommentaren rettet. Evidence: 0082 changeset 4 og sett 73 DEL 2.
- ✅ `applikasjon_er_deaktivert` har grenen. Evidence: 0082 changeset 5 og sett 73 DEL 5.
- ✅ Eksempeldata med tak kopiert med 0059-vaktene. Evidence: 0082 eksempeldata-changeset og sett 73 DEL 3.
- ✅ `tilganger_for_idporten_bruker` er DEFINER, har 0063-form og GRANT bare til coprocessor. Evidence: 0083 og sett 74 DEL 3.
- ✅ `FeideApplikasjon.brukerdelegeringer` bruker ny FK-sti. `DelegeringstakGraphqlTest` er 14/14, og 0048-API-et virker for Feide-apper (sett 42 grønt, sett 73 test 26).
- ✅ Alle punktene for sett 73/74 i akseptansekriteriet er dekket (se Files Created 3–4).
- ✅ De eksisterende settene for taket (37) og 0048 (42) er grønne.

## Next Steps
- Task #7: coprocessorgrenen og testprofilen med `idporten-test-fs-admin` / `idporten-test-min-kompetanse`.
- Task #12: rett headeren «HVORFOR KUN FeideApplikasjon» i `schema_delegeringstak.graphqls`, som nå nevner en FK som ikke finnes.
- 0082 og 0083 er kjørt mot den lokale basen og skal ikke redigeres (checksum).

## Conclusion
Task #5 er ferdig og testet. Databasemodellen gir TIL-PÅL-PÅL-003/004 og delta-beslutning 2 uten egen logikk. Det som gjenstår for ende-til-ende er coprocessorgrenen i Task #7.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
