# Task #3 Completion Report: Personsubjektet på egne nøkler (0080)

## Status: ✅ COMPLETED

**Date Completed**: 2026-09-24
**Task**: Personsubjektet på egne nøkler (0080)
**Priority**: High
**Size**: M

## Summary
`0080-personsubjekt.sql` er skrevet om, så RLS på `personsubjekt` nå går på personnøklene
(`brukere_i_mine_person_les/_skriv_organisasjoner()`, parmatch på (miljø, org)), med `WITH CHECK`
på `BRUKERADMIN_PERSON_SKRIV`. `opprett_personsubjekt` og GRANT-en dens er fjernet, REVOKE
INSERT/UPDATE står, og DELETE beholdes. Changeset-id-ene heter nå `0080-*`. pgTAP 69 er skrevet om
til å feste synligheten på personnøklene, atskillelsen fra Feide i begge retninger og paret
(29 assertions, plan-tallet stemmer). Sett 71 DEL 4 bruker ikke lenger Feide-nøkkelen. Hele suiten
er grønn.

## Files Created
Ingen.

## Files Modified
### 1. `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0080-personsubjekt.sql`
- Changeset-id-ene har fått nytt navn, fra `tilgangsstyring:0078-*` til `tilgangsstyring:0080-*`.
- `0080-personsubjekt-rls`: `personsubjekt_les` bruker `brukere_i_mine_person_les_organisasjoner()`, og
  `personsubjekt_skriv` bruker `brukere_i_mine_person_skriv_organisasjoner()` med
  `WITH CHECK (auth.har_tilgang('BRUKERADMIN_PERSON_SKRIV'))`. Innledningen og policykommentarene
  sier ikke lenger at Feide-nøklene er et bevisst valg. De sier nå at rettighetene er atskilt, at
  (miljø, org)-paret gjelder, og at WITH CHECK er dybdeforsvar fordi `registrer_person` er DEFINER.
- `0080-fn-opprett-personsubjekt` og `0080-grant-opprett-personsubjekt` er fjernet.
- `0080-revoke-skriv`: kommentaren nevner `registrer_person` som eneste inngang. DELETE beholdes
  som en opprydningssti utenfor API-et (beslutning 10).
- I innledningen står det at `registrer_person` oppretter og tildeler i samme operasjon. Et
  «(0078)» er fjernet fra kommentaren på `subjektnavn`.

### 2. `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/db-changelog-root.xml`
Kommentaren ved 0080-includen lister avhengighetene på nytt: 0024, 0071, 0078 (personnøklene og
oppslagsfunksjonene) og 0079 (typesplitten). Før pekte den på 0053.

### 3. `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/test/sql/69_personsubjekt.sql` (29 assertions)
Skrevet om, `plan(29)`:
- DEL 1, formen: uendret, 6 assertions.
- DEL 2, synligheten på personnøklene: med PERSON_LES i paret ser kalleren nøyaktig personene som
  har tildeling der. En person uten tildeling er usynlig. En annen org gir ikke innsyn, og heller
  ikke **riktig org i et annet miljø**. En rolle alene er ikke nok, og PERSON_SKRIV gir innsyn (FOR ALL).
- DEL 3, atskilt: en Feide-administrator med FEIDEBRUKER_LES og _SKRIV ser feide-brukeren
  (kontroll), men ingen personer. En personadministrator ser ikke feide-brukeren, og personflatens
  oppslag tar den ikke med. Ingen policy på `personsubjekt` leser Feide-nøklene, og WITH CHECK er
  PERSON_SKRIV (`pg_policies`).
- DEL 4, skrivesiden: INSERT og UPDATE gir 42501 også med PERSON_SKRIV. FEIDEBRUKER_SKRIV sletter
  0 rader, PERSON_LES sletter 0, og PERSON_SKRIV sletter 1. `hasnt_function('opprett_personsubjekt')`.
- DEL 5, subjektnavn: navnet er synlig når personen er det, usynlig i en annen org, og usynlig med
  Feide-nøkkelen. CHECK-en er uendret.
- Fiksturen skrives som eier, forbi RLS og REVOKE-en, med `OVERRIDING SYSTEM VALUE`, som før. Den
  har fått en feide-bruker F (-9806) og en slettbar person D (-9807).

### 4. `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/test/sql/71_tildelinger_person_gren.sql`
I DEL 4 er `BRUKERADMIN_FEIDEBRUKER_LES` fjernet fra claimet til personadministratoren, og
kommentaren er slettet. `krev_personsubjekt` leser nå personnøklene, og test 28–40 er grønne med
personnøklene alene.

Justeringene i 26 og 62 er ikke rørt.

## Key Features Implemented
### ✅ Personsubjektet på egne nøkler, med paret (miljø, org)
### ✅ Atskilt fra Feide i begge retninger (policyene, WITH CHECK og oppslagene)
### ✅ Ingen offentlig opprettelsesinngang før `registrer_person` (Task #4)
### ✅ DELETE for app-rollen beholdt, og skopet av `personsubjekt_skriv`

## Project skills consulted
Ingen passet. Oppgaven er en Liquibase-migrering med pgTAP, uten GraphQL, Graphitron eller
lokal testdata. Mønstrene er hentet fra 0053 og 0076 (feide_bruker-policyene), 0078
(oppslagsfunksjonene) og 0079, og fra pgTAP 67, 70 og 71.

## Test Results
- Kommando: `cd fs-plattform/tilgangsstyring && mise exec -- mvn -q -pl :tilgangsstyring-new-db test`
  (Testcontainers + pgTAP, alle migreringer fra en tom base).
- Resultat: `tests="1325" errors="0" skipped="0" failures="0"`. Før oppgaven var tallet 1321, og
  sett 69 gikk fra 25 til 29 assertions. Loggen har ingen «not ok» og ingen «Looks like you planned …».
- Sett 71 (43) er grønt uten Feide-nøkkelen i claimet, også `tildel_/fjern_persontilgang` via
  `krev_personsubjekt` (carry-over 5).

### Referanser til `opprett_personsubjekt`
`grep` over `tilgangsstyring/` (java, graphqls, sql, md, xml) finner ingen treff i kildekode. Treffene
er bare i genererte eller byggede artefakter under `target/`: jOOQ-klassene `OpprettPersonsubjekt*`,
`Routines/Tables/Tilgangsstyring.java`, `target/classes` og surefire-rapporten. De forsvinner ved
neste jOOQ-generering. Sett 69 har `hasnt_function`.

## Technical Decisions
### 1. Fiksturene lager personer som eier, uten ny inngang
**Why**: Carry-over 4. Settene 69 og 71 skrev allerede fiksturene som eier. Det var bare DEL 4 i
69 som brukte `opprett_personsubjekt`. De testene er erstattet av skrivesidetester og
`hasnt_function`. Invarianten «ny person gir navnerad» festes i sett 72 med `registrer_person`
(Task #4).
### 2. WITH CHECK og Feide-fraværet testes via `pg_policies`
**Why**: WITH CHECK kan ikke nås av app-rollen, fordi INSERT og UPDATE er trukket tilbake. Uten
inventartesten kunne en Feide-nøkkel i WITH CHECK ligget skjult.
### 3. Ingen persongren i `subjekt_insert`
**Why**: `registrer_person` er SECURITY DEFINER og går ikke gjennom policyen. Kommentaren på
`personsubjekt_skriv` sier det.
### 4. Slettetestene bruker en egen person (D)
**Why**: Da påvirker ikke slettingen synlighetstestene. Det viser også at DELETE fortsatt er mulig
(beslutning 10).

## Build Status
✅ **pgTAP-suiten for `tilgangsstyring-new-db` er grønn** (1325/1325, Testcontainers).
⚠️ **`mise run build` / `migrate` ble ikke kjørt**, etter instruks. Den lokale basen har kjørt den
gamle 0080, og endringen gir en checksum-avvik der. Brukeren nullstiller. Oppgaven endrer ingen
Java-kode. Ved neste jOOQ-generering forsvinner `OpprettPersonsubjekt` fra de genererte klassene,
og ingen kildekode bruker den.

## Integration Points
- Task #4 (`registrer_person`, 0081): skal være eneste inngang. Den må være DEFINER og skrive
  `subjekt` + `personsubjekt` + `subjektnavn`. Changeset-teksten i 0080 viser allerede til den.
- `krev_personsubjekt` (0079) bruker nå personnøklene, så `tildel_/fjern_persontilgang` er ren
  personflate.
- Task #9 (`IdPortenBruker`-søk): `@table(name: "personsubjekt")` får synligheten
  «tildeling i (org, miljø) der du har PERSON_LES» direkte fra policyen.
- Task #12 (docs): `docs/tilgangsmodell.md` bør beskrive at personsubjektet har egne nøkler og
  ingen domenegren.

## Acceptance Criteria Met
- ✅ `personsubjekt_les` og `_skriv` bruker `brukere_i_mine_person_*`, og WITH CHECK er
  `BRUKERADMIN_PERSON_SKRIV`. Evidens: changeset `0080-personsubjekt-rls` og sett 69 test 17–18.
- ✅ `opprett_personsubjekt` er fjernet, REVOKE INSERT/UPDATE står, og DELETE er beholdt. Evidens:
  changeset `0080-revoke-skriv` og sett 69 test 19–24.
- ✅ Kommentarene er rettet. Evidens: innledningen, policykommentarene, revoke-kommentaren og root-XML.
- ✅ Sett 69 viser at en Feide-administrator ikke ser en person (test 14), at en
  personadministrator ikke ser en Feide-bruker via personflaten (test 15–16), og at synligheten
  krever paret (test 9–10).
- ✅ Carry-over: id-ene heter `0080-*`, plan-tallet stemmer (29), Feide-nøkkelen er fjernet fra 71
  DEL 4, fiksturene er ærlige, og `krev_personsubjekt` er verifisert.

## Next Steps
- Task #4: `registrer_person` (0081) og sett 72.
- Lokalt: nullstill basen, og kjør deretter `migrate` og `jooq` på nytt.

## Conclusion
Task #3 er ferdig. Personsubjektet er gatet på egne nøkler og (miljø, org)-paret, og har ingen
offentlig opprettelsesvei før Task #4. Klar for review.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
