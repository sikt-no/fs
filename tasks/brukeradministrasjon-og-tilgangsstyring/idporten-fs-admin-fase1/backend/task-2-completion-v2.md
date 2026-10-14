# Task #2 Completion Report: Typesplitt i tildelingspolicyene og persontildeling (0079)

## Status: ✅ COMPLETED

**Date Completed**: 2026-09-24
**Task**: Typesplitt i tildelingspolicyene og persontildeling (0079)
**Priority**: High
**Size**: L

## Summary
Ny migrering `0079-tildelinger-typesplitt-person.sql` gir de fire policyene på
`subjektrolletildeling` tre nøkkelgrener: ikke-menneske, `feide_bruker` og `person`. En menneskelig
type uten egen gren treffer ingen nøkkel. Migreringen legger også til `krev_personsubjekt`,
`tildel_persontilgang` / `fjern_persontilgang` og en persongren i pickerne. pgTAP-sett 71 er nytt,
og i sett 66 er én antagelse oppdatert. Hele suiten er grønn (1321 tester). Planformen er
uendret, og policyene er raskere enn før.

## Files Created
### 1. `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0079-tildelinger-typesplitt-person.sql` (~400 linjer)
Fem changesets:
- `0079-fn-subjekt-er-av-type`: `subjekt_er_av_type(subjekt_id, typekode)` (SQL, STABLE,
  INVOKER, leser `subjekt`) og GRANT. Kommentaren på `subjekt_er_person` er rettet. Den sa at
  en ny persontype arver Feide-policyene.
- `0079-tildelingspolicyer-typegrener`: `SET LOCAL lock_timeout = '2s'`, DROP + CREATE av
  `_les`, `_skriv`, `_tildeling_insert` og `_tildeling_lukk`. Ett changeset for den ene tabellen.
  Eier-grenen og saksbehandlergrenen i `_les` er ordrett som i 0075.
- `0079-fn-krev-personsubjekt`: P0002 «personen finnes ikke, eller er ikke tilgjengelig for deg».
- `0079-fn-tildel-og-fjern-persontilgang`: 0057-kroppene med `krev_person_tildelingsrett` og
  `krev_personsubjekt`. Meldingene, feilkodene, valideringsrekkefølgen og idempotensen er de samme.
- `0079-pickers-persongren`: `tildelbare_tilgangskoder` og `mine_tildelingsorganisasjoner` med
  `orger_med_person_tildelingsrett()` i unionen (0057-formen).

### 2. `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/test/sql/71_tildelinger_person_gren.sql` (43 assertions)
- DEL 1: for hver av de seks typene fra sett 66 slipper alle fire policyene inn det samme som før.
  Personnøklene når ingen av dem.
- DEL 2: personen har egne nøkler, og de er atskilt fra Feide- og applikasjonsnøklene i begge
  retninger (les, tildel og lukk).
- DEL 3: en syntetisk menneskelig type (`pgtap_menneske71`) avvises med alle nøklene. Testen ser
  på oppførselen, og i tillegg evalueres hvert policypredikat alene (les, skriv, insert, lukk USING
  og lukk WITH CHECK). Da kan ikke én policy skjule en åpning i en annen.
- DEL 4: `tildel_/fjern_persontilgang`: ny tildeling, idempotens begge veier, arvet tilgang (23001),
  P0002 for feide-bruker, applikasjon, usynlig person og ukjent id, 23502, og 42501 med den felles
  meldingen. Atskillelsen gjelder begge veier: Feide-retten åpner ikke `tildel_persontilgang`,
  og personretten åpner ikke `tildel_brukertilgang`. Pickerne gir personretten alene, og er
  fortsatt fail-closed.

## Files Modified
### 1. `tilgangsstyring-new-db/src/main/resources/db/changelog/db-changelog-root.xml`
Include for 0079 mellom 0078 og 0080, med en begrunnelse for rekkefølgen.

### 2. `tilgangsstyring-new-db/src/test/sql/66_subjekt_er_person.sql`
Antagelsen «personnøkkelen viser tildelingen til en person av den nye typen» er snudd til
`is_empty`. Nå viser Feide-nøkkelen ikke tildelingen, fordi typen mangler egen gren. Overskriften
og seksjonstittelen er oppdatert. Assertion-antallet er uendret. Sett 51 trengte ingen endring.

`0080-personsubjekt.sql`, `69_personsubjekt.sql`, 26 og 62 er ikke rørt.

## Key Features Implemented
### ✅ Lukket typesplitt
`NOT subjekt_er_person` → WSBRUKER-settet, `subjekt_er_av_type(…,'feide_bruker')` → FEIDEBRUKER-settet
og `subjekt_er_av_type(…,'person')` → PERSON-settet (`BRUKERADMIN_PERSON_LES` /
`orger_med_person_tildelingsrett()`).
### ✅ Egne tildelingsfunksjoner for personer
`tildel_persontilgang` og `fjern_persontilgang` er SECURITY INVOKER. `tildel_brukertilgang` og
`fjern_brukertilgang` er uendret og gjelder bare Feide.
### ✅ Pickerne kjenner personretten

## Project skills consulted
Ingen passet. Oppgaven er en Liquibase-migrering med pgTAP, uten GraphQL, Graphitron eller testdata
i en lokal base. Mønstrene er hentet fra migreringene 0057 (kroppene og pickerne), 0075 (policyformen
og `lock_timeout`), 0069 (saksbehandlergrenen), 0036 (`krev_feide_bruker`) og 0078 (personnøklene),
og fra pgTAP 33, 51 og 66.

## Test Results
- Kommando: `cd fs-plattform/tilgangsstyring && mise exec -- mvn -q -pl :tilgangsstyring-new-db test`
  (Testcontainers + pgTAP, alle migreringer med `eksempeldata,rds`).
- Resultat: `tests="1321" errors="0" skipped="0" failures="0"`. Før oppgaven var tallet 1278. Sett
  71 har alle 43 grønne, og 50, 51 og 66 er grønne.
- Meldingen «Looks like you planned 21 tests but ran 25» fra `69_personsubjekt.sql` var der fra før
  og hører til Task #3.

### Planform og måling (før og etter)
`50_ytelse_planform.sql` er grønn. Den går ikke gjennom disse policyene. Derfor ble en midlertidig
målefil kjørt i suiten og slettet etterpå. Den hadde 50-fiksturen for tildelinger, 29 400 synlige
rader, og tok median av 9 kjøringer med `EXPLAIN ANALYZE` som app-rollen. «Før» er kjørt med
0079-includen kommentert ut.

| Spørring | Før (0075) | 0079, typetest først | 0079, parmatch først (levert) | Planform |
|---|---|---|---|---|
| alle tildelinger, full innsikt | 1019 ms | 1016 ms | **417 ms** | uendret |
| `subjektrolletildeling_med_arv` én bruker | 1057 ms | 1052 ms | **453 ms** | uendret |
| verste fall, ingen synlige (bare PERSON_LES) | 1120 ms | 1218 ms | **134 ms** | uendret |
| `feide_bruker` (feideBrukere) | 24 ms | 24 ms | 24 ms | uendret |
| tildelinger i én org | 23 ms | 23 ms | 20 ms | uendret |

Nodetypene er identiske i alle kolonnene.

## Technical Decisions
### 1. Parmatchen i policyen, ingen hjelpefunksjon per ledd
**Why**: Som IN-delspørring beregnes nøkkelsettet én gang per spørring. En
`menneske_har_tildelingsrett(subjekt_id, miljo, org)` ville beregnet `orger_med_tilgang` per rad,
som er bruddet planen advarer mot. Dupliseringen er i stedet redusert til én typetest,
`subjekt_er_av_type`. Typekoden står synlig i hver gren, og det er «inline på `subjekt_type`» fra
beslutning 9.
### 2. Parmatchen står foran typetesten i hver gren
**Why**: Målt. Et oppslag i det hashede settet er billigere enn et funksjonskall, og en gren
kalleren mangler nøkkelen til, koster da ingen typetest. Med typetesten først ble verste fall 9 %
tregere enn før. Med parmatchen først er alle spørringene 2,3–8 ganger raskere enn før.
### 3. Én generisk `subjekt_er_av_type` i stedet for å gjenbruke `subjekt_er_feide_bruker`
**Why**: 0075 har avløst `subjekt_er_feide_bruker`, og sett 66 fester at ingen policy leser den.
Én funksjon for begge menneskegrenene gir én mekanikk og gjør typekoden eksplisitt.
`subjekt_er_personsubjekt` ble ikke laget. Den ville vært en tredje kopi av samme spørring.
### 4. `krev_personsubjekt` leser `personsubjekt` med kallerens øyne, ikke den globale `subjekt`
**Why**: Dette avviker fra oppdragsteksten, som foreslo `subjekt` (`subjekt_type = 'person'`).
Task #11 krever at `IdPortenBrukerIkkeFunnet` gjelder ukjent, **usynlig** og feiltypet id likt, og
analysen (funn 3) forutsetter at en usynlig person ikke nås av tildel-funksjonen. Et oppslag i den
globale `subjekt` ville latt en usynlig person passere som kjent. Det blir ingen RLS-rekursjon,
fordi funksjonen kalles fra en INVOKER-funksjon og ikke fra en policy. `personsubjekt_les` leser
subjektrolletildeling via DEFINER-funksjoner. Dette er det samme mønsteret som `krev_feide_bruker`
(0036). Tabellen opprettes først i 0080. plpgsql slår den opp ved kjøring, og ingen kaller
funksjonen før tabellen finnes.
### 5. Samlingspolicyen er urørt
**Why**: `NOT subjekt_er_person` stenger alle mennesker ute, også `person`. Det er riktig.

## Build Status
✅ **pgTAP-suiten for `tilgangsstyring-new-db` er grønn** (1321/1321, Liquibase mot en fersk Testcontainers-base)
⚠️ **`mise run build` ble ikke kjørt**, etter instruks, fordi den nullstiller brukerens lokale base. Task #2 endrer ingen Java-kode. jOOQ får nye rutiner (`subjekt_er_av_type`, `krev_personsubjekt`, `tildel_persontilgang`, `fjern_persontilgang`) ved neste generering.

## Integration Points
- Task #3 (0080): når `personsubjekt_les` går over til `brukere_i_mine_person_les_organisasjoner`,
  bruker `krev_personsubjekt` den synligheten automatisk. **Merk:** DEL 4 i sett 71 gir kalleren
  `BRUKERADMIN_FEIDEBRUKER_LES` bare fordi dagens `personsubjekt_les` leser Feide-nøkkelen.
  Linjen har en kommentar. Task #3 bør fjerne nøkkelen fra claimet og slette kommentaren.
- Task #4 (`registrer_person`): kan tildele via samme sjekk som `tildel_persontilgang`.
- Task #9 og #11: persongrenen i `subjektrolletildeling_les` bærer `IdPortenBruker.tilganger`, og
  `tildel_/fjern_persontilgang` er DB-portene for Op #4 og #5. P0002-meldingen begynner med
  «personen».
- Task #12: `docs/tilgangsmodell.md` bør beskrive den lukkede typesplitten og `subjekt_er_av_type`.

## Acceptance Criteria Met
- ✅ Fire policyer, DROP + CREATE med tre grener. En menneskelig type uten gren treffer ingen. Eier- og saksbehandlergrenen er ordrett bevart. Evidens: `0079-…sql`, changeset `0079-tildelingspolicyer-typegrener`, og sett 71 test 20–26.
- ✅ Ett changeset per tabell med `SET LOCAL lock_timeout = '2s'`. Evidens: samme changeset, første setning. Ingen andre tabeller får policyendringer.
- ✅ `tildel_persontilgang` / `fjern_persontilgang` speiler 0057 med `krev_person_tildelingsrett` + `krev_personsubjekt` (P0002 «personen»). Meldingene og idempotensen er de samme. Evidens: sett 71 test 28–40.
- ✅ Pickerne har persongren (union). Evidens: sett 71 test 41–43.
- ✅ pgTAP 71 viser ingen virkning for de seks typene fra sett 66 (test 1–10), og at den syntetiske menneskelige typen avvises i alle fire policyene (test 20–26).
- ✅ Settene 51 og 66 er grønne. Antagelsen i 66 er oppdatert, ikke fjernet (test 16).

## Next Steps
- Task #3: skrive om 0080 til personnøklene, og fjerne `BRUKERADMIN_FEIDEBRUKER_LES` fra claimet i sett 71 DEL 4.
- Eierne av 0075/0076 bør se endringen i kommentaren til `subjekt_er_person` (Cross-contributor i planen).

## Conclusion
Task #2 er ferdig. Typesplitten er lukket og ligger foran personsubjektet i rekkefølgen. Den er
uten virkning for de eksisterende typene, og den gjør tildelingspolicyene raskere. Klar for Task #3.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
