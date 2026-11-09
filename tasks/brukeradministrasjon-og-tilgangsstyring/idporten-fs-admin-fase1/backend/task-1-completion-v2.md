# Task #1 Completion Report: Privilegiefamilie, forretningsroller og FS Admin-tak for personer (0078)

## Status: ✅ COMPLETED

**Date Completed**: 2026-09-24
**Task**: Privilegiefamilie, forretningsroller og FS Admin-tak for personer (0078)
**Priority**: High
**Size**: M

## Summary
Ny migrering `0078-privilegier-person.sql` legger inn personfamilien: tre privilegier
`BRUKERADMIN_PERSON_*` (navnerom `tilgangsstyring`), forretningsrollen `PERSONADMINISTRATOR` (`fs`)
og fire flateroller `PERSONADMINISTRASJON*` (`fs-admin`), med implikasjoner ned til privilegiene.
Den legger også inn chokepoint-funksjonene, der brukeroppslagene matcher paret (miljø, org), og
FS Admins delegeringstak. Den ucommittede personsubjekt-migreringen er flyttet til `0080` med
uendret innhold. pgTAP-sett 70 er nytt, og settene 37 og 55 har fått personfamilien i inventarene
sine. Hele suiten er grønn.

## Files Created
### 1. `tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0078-privilegier-person.sql` (~190 linjer)
Fire changesets:
- `0078-seed-roller-person`: åtte roller med `navneromskode` og `rolletype`, og sju implikasjonskanter.
- `0078-fn-person-tildelingsrett`: `orger_med_person_tildelingsrett()` og
  `krev_person_tildelingsrett(org, miljo)`. Meldingen og 42501 er de samme som hos søstrene.
  GRANT til app-rollen.
- `0078-fn-brukere-i-mine-person-organisasjoner`: `brukere_i_mine_person_les_organisasjoner()` og
  `brukere_i_mine_person_skriv_organisasjoner()`. De er SECURITY DEFINER og matcher
  `(miljokode, organisasjonskode)` som 0076. De filtrerer på `subjekt.subjekt_type = 'person'`, ikke
  via `personsubjekt`. REVOKE fra PUBLIC og GRANT til app-rollen (0069-mønsteret).
- `0078-delegeringstak-person`: 0059-mønsteret, `service_id IN ('2196456', 'dev-brukeradmin')`.
  Lesesidene speiles fra taket for `WSBRUKER_LES`, skrivesidene fra taket for `WSBRUKER_SKRIV`.

### 2. `tilgangsstyring/tilgangsstyring-new-db/src/test/sql/70_privilegier_person.sql` (19 assertions)
Dekker katalogen, kantene, atskillelsen i begge retninger (i grafen og i ekspansjonen),
koblingsfunksjonene (parmatch, typefilter, at kalleren ikke tas med, at Feide-nøklene ikke åpner
noe, og 42501-kontrakten), chokepoint-vakten og rettighetene. Til slutt kommer taket i dev og at
snittet i `tilganger_for_bruker` slipper rollen gjennom.

## Files Modified
### 1. `tilgangsstyring-new-db/src/main/resources/db/changelog/0078-personsubjekt.sql` → `0080-personsubjekt.sql`
Flyttet med `mv`, og innholdet er uendret. Å skrive om filen hører til Task #3.

### 2. `tilgangsstyring-new-db/src/main/resources/db/changelog/db-changelog-root.xml`
Ny include for `0078-privilegier-person.sql` foran `0080-personsubjekt.sql`, begge med
begrunnelse for rekkefølgen.

### 3. `tilgangsstyring-new-db/src/test/sql/37_delegeringstak_nye_roller.sql`
Det uttømmende takinventaret, de to invariantene (lese- og skrivesider) og 8887-vakten har fått
personfamilien. Headeren er oppdatert.

### 4. `tilgangsstyring-new-db/src/test/sql/55_subgrafroller_i_claim.sql`
Inventaret over privilegier i navnerommet `tilgangsstyring` har fått de tre nye.

De ucommittede endringene i `26_…`, `62_…` og `69_personsubjekt.sql` er ikke rørt.

## Key Features Implemented
### ✅ Egen privilegiefamilie og egne roller
`PERSONADMINISTRATOR ⇒ PERSONADMINISTRASJON ⇒ _LES/_SKRIV/_TILDELING ⇒ BRUKERADMIN_PERSON_*`.
Ingen kant går til eller fra `BRUKERADMINISTRASJON*` eller `BRUKERADMIN_FEIDEBRUKER_*`.
### ✅ Chokepoint-funksjoner
`BRUKERADMIN_PERSON_TILDELING_SKRIV` navngis bare i `orger_med_person_tildelingsrett`, og pgTAP
fester det.
### ✅ FS Admin-tak
I dev: lesesidene i 7777, 7778 og 8887, skrivesidene i 7777 og 7778.

## Project skills consulted
Ingen passet. `fs-testdata-creation` gjelder lagring av testrader i en lokal utviklingsbase, men
denne oppgaven er en Liquibase-migrering med pgTAP, og takradene er migreringsdata. Mønsteret er
hentet fra migreringene 0052–0054, 0058, 0059, 0065 (seed med `navneromskode`), 0069
(REVOKE/GRANT på DEFINER) og 0076 (parmatch), og fra pgTAP 37, 52 og 67.

## Test Results
- Kommando: `cd tilgangsstyring && mise exec -- mvn -q -pl :tilgangsstyring-new-db test`
  (Testcontainers + pgTAP, alle migreringer med `eksempeldata,rds`).
- Resultat: `Tests run: 1278, Failures: 0, Errors: 0, Skipped: 0`. Alle 19 i sett 70 er grønne.
- Første kjøring feilet på `55_subgrafroller_i_claim.sql` test 2, et inventar over privilegier i
  `tilgangsstyring`. Det er oppdatert med de tre nye kodene.
- Merk: `69_personsubjekt.sql` (ucommittet, Task #3) sier `plan(21)`, men kjører 25 («Looks like you
  planned 21 tests but ran 25»). Runneren regner ikke dette som feil. Det var der fra før, er ikke
  rørt her, og bør rettes i Task #3.

## Technical Decisions
### 1. Rollenavnene `PERSONADMINISTRATOR` / `PERSONADMINISTRASJON*` er beholdt
**Why**: `docs/begrepsbruk.md` finnes ikke i repoet. Navnene er derfor sjekket mot navnekonvensjonen
i `docs/navnerom-for-roller.md` («Tre lag i praksis»): `<X>ADMINISTRATOR` i `fs` og
`<X>ADMINISTRASJON[_LES|_SKRIV|_TILDELING]` i `fs-admin`. Planens forslag følger den.
### 2. Ingen `PERSONINNSYN`
**Why**: planen nevner den ikke. Den kan legges til senere som en ny seed, slik `BRUKERINNSYN` er for Feide.
### 3. Typefilter i brukeroppslagene
**Why**: planens implementasjonsnotat. Filteret leser `subjekt` (globalt lesbar) og ikke
`personsubjekt`, for å unngå RLS-rekursjonen. Filteret tester tekstkoden `'person'`, så 0078
trenger ikke at subjekttypen finnes. Den kommer i 0080.
### 4. Takkilden er WSBRUKER_LES/_SKRIV, som i 0059
**Why**: det gir samme (org, miljø)-par som Feide-familien, og invariantene i sett 37 kunne
utvides direkte.
### 5. Ingen katalogvakt (`rolle`-EXISTS) i tak-INSERT-en
**Why**: rollene seedes ubetinget i samme fil, så vakten kan aldri slå til.

## Build Status
✅ **pgTAP-suiten for `tilgangsstyring-new-db` er grønn** (Liquibase mot en fersk Testcontainers-base).
⚠️ **`mise run build` ble ikke kjørt.** Den kjører `db-down --volumes` på brukerens lokale base, og
den lokale basen har allerede kjørt den gamle `0078-personsubjekt.sql`. Etter at filen er flyttet,
må basen uansett nullstilles (`mise run build`) før `migrate` og `jooq` virker lokalt. Det er
overlatt til brukeren. Task #1 endrer ingen Java-kode. jOOQ får nye rutiner, men ingen eksisterende
kode endres.

## Integration Points
- Task #2 (0079): policyene og `tildel_persontilgang`/`fjern_persontilgang` bruker
  `orger_med_person_tildelingsrett` / `krev_person_tildelingsrett`.
- Task #3 (0080): `personsubjekt_les/_skriv` skal peke på `brukere_i_mine_person_*`, og
  `WITH CHECK` på `BRUKERADMIN_PERSON_SKRIV`.
- Task #4: `registrer_person` kan gate på `krev_person_tildelingsrett`.
- Taket gjør rollene formidlingsbare for FS Admin i `tilganger_for_bruker`.

## Acceptance Criteria Met
- ✅ Ny `0078-privilegier-person.sql`, og `0078-personsubjekt.sql` er flyttet til `0080`. Evidens: changelog-katalogen og db-changelog-root.xml.
- ✅ `BRUKERADMIN_PERSON_LES/_SKRIV/_TILDELING_SKRIV` i `tilgangsstyring`. Evidens: 70 test 1, og 55 test 2.
- ✅ Forretningsroller i `fs`/`fs-admin` med implikasjoner, uten kryssimplikasjon mot Feide i noen retning. Evidens: 70 test 3–7.
- ✅ Chokepoint-funksjonene finnes, og brukeroppslagene matcher (miljø, org). Evidens: 70 test 8–17.
- ✅ Rollene er speilet inn i FS Admins tak (`service_id IN ('2196456', 'dev-brukeradmin')`). Evidens: 70 test 18–19, og 37 test 2–5.
- ✅ pgTAP `70_privilegier_person.sql` finnes og er grønn.

## Next Steps
- Task #2: typesplitt i tildelingspolicyene (0079).
- Task #3: skrive om 0080. Merk at changeset-id-ene i `0080-personsubjekt.sql` fortsatt heter
  `0078-*`, fordi innholdet skulle stå uendret. De kolliderer ikke med de nye id-ene i
  `0078-privilegier-person.sql`, og Liquibase nøkler uansett på filsti. Task #3 bør likevel gi dem
  navnet `0080-*` og rette `plan(21)` i `69_personsubjekt.sql`.

## Conclusion
Task #1 er ferdig, og suiten er grønn. Personfamilien finnes, men gir ingen tilgang før Task #2
og #3 kobler policyene til den.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
