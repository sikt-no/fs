# Task #4 Completion Report: `registrer_person` (0081)

## Status: ✅ COMPLETED

**Date Completed**: 2026-09-24
**Task**: `registrer_person` (0081)
**Priority**: High
**Size**: M

## Summary
Ny migrering `0081-registrer-person.sql` legger til `registrer_person`, som nå er eneste inngang
for å opprette en person uten Feide. Funksjonen er SECURITY DEFINER og krever `BRUKERADMIN_PERSON_SKRIV`
og `_TILDELING_SKRIV` i (org, miljø) i første setning. Deretter finner eller oppretter den personen
på fødselsnummeret, og tildeler gjennom `tildel_persontilgang`. Returverdien er `TABLE(subjekt_id)`.
En ny person får `subjekt`, `personsubjekt` og `subjektnavn`. En kjent person får bare tildelingen.
Et kappløp på samme nye nummer når aldri kalleren som 23505. Nytt pgTAP-sett 72 har 45 assertions,
og hele suiten er grønn (1370/1370).

## Files Created
### 1. `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0081-registrer-person.sql` (~120 linjer)
Ett changeset, `tilgangsstyring:0081-fn-registrer-person`, med funksjonen, en COMMENT, `REVOKE ALL … FROM PUBLIC`
og `GRANT EXECUTE … TO ${app_role}`. Rekkefølgen i kroppen:
1. Porten, i én setning: `auth.orger_med_tilgang('BRUKERADMIN_PERSON_SKRIV')` og
   `orger_med_person_tildelingsrett()` matches begge på paret. Mangler en av dem, reises 42501 med
   den felles meldingen «mangler rettighet til å tildele tilganger i denne organisasjonen og dette miljøet».
2. Validering, lik for ny og kjent person: NULL gir 23502, feil form på nummeret og tomt navn gir
   23514, og ukjent tilgangskode gir P0002 (`krev_tilgangskode`).
3. Oppslag i `personsubjekt` på fødselsnummeret. Funksjonen kjører som eier, så RLS gjelder ikke.
4. Ny person: `INSERT subjekt` → `INSERT personsubjekt … ON CONFLICT (fodselsnummer) DO NOTHING`.
   Tapes kappløpet, slettes det foreldreløse subjektet og oppslaget gjøres på nytt. Vinnes det,
   skrives `subjektnavn`.
5. `tildel_persontilgang(...)`, og så `RETURN QUERY SELECT v_subjekt_id`.

### 2. `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/test/sql/72_registrer_person.sql` (45 assertions)
- DEL 1, formen: funksjonen finnes, er DEFINER, returnerer `TABLE(subjekt_id bigint)`, har fast
  search_path, og app-rollen har EXECUTE mens PUBLIC ikke har det.
- DEL 2, ny person: én resultatrad. Subjektet er av typen person, personsubjektet er synlig for
  kalleren etter tildelingen, og det er skrevet én navnerad og én tildeling. Tildelingen har samme
  sporing som en tildeling fra `tildel_persontilgang` og er sporet til kalleren, ikke til eieren.
  Navneraden har samme sporing som tildelingen. En ny registrering er idempotent: samme resultat,
  ingen ny tildeling og ingen ny navnerad.
- DEL 3, kjent person: gir den eksisterende id-en, med identisk resultatform (nøkler og type) som
  for en ny person. Navnet er uendret, og det er ikke skrevet noen ny navnerad. Tildelingen fra den
  andre organisasjonen står urørt (periode og sporing) og er usynlig for kalleren. Det er ikke
  skrevet noen ny personrad.
- DEL 4, porten: bare tildelingsrett gir 42501, og bare skriverett gir 42501, i begge tilfeller
  for både kjent og ukjent nummer. Feil org, feil miljø og Feide-rettene gir også 42501. Porten
  kommer før valideringen, så ugyldig input uten rett gir 42501. Et avvist kall skriver ingen person.
- DEL 5, validering: 23514 for form og tomt navn, også for en kjent person. 23502 for NULL og P0002
  for ukjent tilgangskode. Ingen melding, detalj eller hint i fire feilkall inneholder nummeret.
- DEL 6, kappløp: en test-trigger på `subjekt` skriver en konkurrerende person med samme nummer
  etter oppslaget. Kallet gir vinnerens id uten 23505. Tildelingen havner på vinneren, det blir
  ikke igjen noe foreldreløst subjekt, og taperen skriver ingen navnerad.

## Files Modified
### 1. `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/db-changelog-root.xml`
Include for 0081 etter 0080, med avhengighetene 0080 og 0079.

## Key Features Implemented
### ✅ Ubetinget port først
Begge rettene sjekkes i én setning før nummeret slås opp. Resultatet er samme 42501 for kjent og
ukjent nummer, så porten fungerer ikke som orakel.
### ✅ Finn eller opprett, navnet bare for nye personer
### ✅ Tildelingen går gjennom `tildel_persontilgang`
Raden, sporingen og idempotensen er de samme som ved en vanlig persontildeling.
### ✅ Kappløpet håndteres i funksjonen
`ON CONFLICT DO NOTHING`, sletting av det foreldreløse subjektet og nytt oppslag.
### ✅ Fødselsnummeret står aldri i en feil
Formen og navnet valideres før skrivingen, fordi en CHECK-feil ville gjentatt raden i DETAIL.

## Project skills consulted
Ingen passet. Oppgaven er en Liquibase-migrering med pgTAP, uten GraphQL-skjema, Graphitron eller
lokal testdata. Mønstrene er hentet fra 0016 (`RETURNS TABLE(subjekt_id)` for `@routine`), 0028
(DEFINER med egen rettighetssjekk, fast search_path, REVOKE fra PUBLIC), 0078 (porten og meldingen),
0079 (`tildel_persontilgang`) og 0080, og fra pgTAP 69 og 71.

## Test Results
- Kommando: `cd fs-plattform/tilgangsstyring && mise exec -- mvn -q -pl :tilgangsstyring-new-db test`
  (Testcontainers + pgTAP, alle migreringer mot en tom base).
- Resultat: `tests="1370" errors="0" skipped="0" failures="0"`. Før oppgaven var tallet 1325, og sett
  72 bidrar med 45. Loggen har ingen «not ok» og ingen «Looks like you planned …».

## Technical Decisions
### 1. Tildelingen kalles gjennom `tildel_persontilgang`, ikke en kopi
**Why**: Planen krever samme radform, sporing og idempotens. `tildel_persontilgang` er INVOKER.
Kalt fra DEFINER kjører den som eier, så `krev_personsubjekt` ser den nye personen, som kalleren
ennå ikke ser. Sporingen kommer fra claims, ikke fra rollen, og sett 72 test 12–13 bekrefter at
tildelingen er sporet til kalleren. Portsjekken i `tildel_persontilgang` kjører en gang til, og det
er ufarlig.
### 2. Skriveretten sjekkes inline mot `auth.orger_med_tilgang`, uten ny chokepoint-funksjon
**Why**: Det finnes ingen `orger_med_person_skriverett()`, og én bruker rettferdiggjør ikke en ny
offentlig funksjon. Tildelingsretten går gjennom `orger_med_person_tildelingsrett()`. Meldingen er
den felles 0057-meldingen for begge rettene, som planen sier («samme melding for alle retter»).
### 3. Validering før oppslaget, og navnet valideres også for kjente personer
**Why**: En feil som bare kom for nye personer (tomt navn, CHECK-feil), ville røpet om nummeret er
registrert. Egne sjekker før skrivingen hindrer også at CHECK-feilens DETAIL gjentar nummeret.
### 4. `ON CONFLICT DO NOTHING` + sletting, ikke en EXCEPTION-blokk
**Why**: Begge løsningene er korrekte. Med ON CONFLICT kan kappløpet testes i én sesjon: en
konkurrent skrevet av en trigger overlever, mens en savepoint-rollback ville tatt den med seg. Det
foreldreløse subjektet slettes eksplisitt. `subjekt` har ingen triggere som hindrer det.
### 5. Ugyldig form gir 23514 fra funksjonen
**Why**: Service-laget (Task #10) validerer fødselsnummeret og gir `UgyldigFodselsnummer`, så
databasesjekken er dybdeforsvar. Meldingen «fødselsnummeret må være elleve sifre» gjentar ikke
nummeret.

## Build Status
✅ **pgTAP-suiten for `tilgangsstyring-new-db` er grønn** (1370/1370, Testcontainers).
⚠️ **`mise run build` / `migrate` / `jooq` ble ikke kjørt**, etter instruks. Den lokale basen har
en kjent checksum-avvik på 0080, og brukeren nullstiller den. Ingen Java-kode er endret. Ved neste
jOOQ-generering kommer `RegistrerPerson` som tabellverdi-rutine, og Task #10 bruker den.

## Integration Points
- Task #10 (`registrerIdPortenBruker`): `@routine`/servicen kaller
  `registrer_person(fnr, fornavn, etternavn, rollekode, org, miljø)` og følger `subjekt_id` videre
  til `personsubjekt`. Feilruting: 42501 → `ManglerTildelingsrett` (samme melding), P0002
  «tilgangskoden finnes ikke» → `TilgangskodeIkkeFunnet`. 23514 og 23502 skal ikke nå hit, fordi
  service-laget validerer først. Personen er synlig i payloaden bare med `BRUKERADMIN_PERSON_LES`
  i paret, som skjemaet sier.
- Task #12 (docs): restlekkasjen skal dokumenteres. Etter tildelingen ser administratoren det
  lagrede navnet (sett 72 test 22).

## Acceptance Criteria Met
- ✅ Signaturen `registrer_person(p_fodselsnummer, p_fornavn, p_etternavn, p_rollekode, p_organisasjonskode, p_miljokode)`,
  SECURITY DEFINER, returnerer `TABLE(subjekt_id bigint)`. Evidens: `0081-registrer-person.sql` og sett 72 test 1–3.
- ✅ Første setning krever begge rettene i (org, miljø), ellers 42501, og det skjer før nummeret slås
  opp. Evidens: den første IF-en i kroppen og sett 72 test 26–33.
- ✅ Funksjonen finner eller oppretter på fødselsnummer. En ny person får subjekt, personsubjekt og
  subjektnavn, en kjent person får ingen navnerad, og tildelingen er idempotent. Evidens: sett 72
  test 6–10, 15–17 og 23–25.
- ✅ Et kappløp gir aldri 23505. Evidens: sett 72 test 42–45.
- ✅ Sett 72 viser identisk resultatform (test 18–20), uendret navn for en kjent person (test 23),
  42501 også for et kjent nummer (test 26 og 28), og at en tildeling fra en annen organisasjon står
  urørt (test 24) og er usynlig for kalleren (test 21).

## Next Steps
- Task #10: GraphQL-mutasjonen `registrerIdPortenBruker` over `registrer_person`.
- Lokalt: nullstill basen og kjør `migrate` og `jooq` på nytt.

## Conclusion
Task #4 er ferdig. `registrer_person` er eneste inngang for å registrere en person og gir samme
utfall for ny og kjent person. Klar for review.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
