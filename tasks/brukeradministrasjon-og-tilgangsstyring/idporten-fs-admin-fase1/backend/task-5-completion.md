# Task #5 Completion Report: Åpne roller for bruker uten tildelinger

## Status: ✅ COMPLETED

**Date Completed**: 2026-09-22
**Task**: Åpne roller for bruker uten tildelinger
**Priority**: High
**Size**: M

## Summary

En ID-porten-bruker havner ikke lenger under modellens gulv: ny databasefunksjon
`tilgangsstyring.tilganger_for_apne_roller(p_env)` gir de åpne rollene i miljøet —
rolleekspandert, uten identitet, uten tildelinger — og coprocessoren kaller den for utstederen
`idporten`. Feides fail-closed (`externalServiceId == null → EMPTY`) er uendret og er nå festet
av en egen påstand i testen som allerede dekket den.

Funksjonen fikk ett ledd planen ikke navnga: claim-filteret fra `0063`. Se
[Technical Decisions](#1-funksjonen-filtrerer-på-subgrafrolle-selv-om-planen-ikke-nevnte-det).

## Files Created

### 1. `tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0072-apne-roller-uten-tildelinger.sql` (47 linjer)

To changesets. `0072-fn-tilganger-for-apne-roller` oppretter
`tilgangsstyring.tilganger_for_apne_roller(p_env TEXT)` — `LANGUAGE sql`, `STABLE SECURITY
DEFINER`, `SET search_path TO 'tilgangsstyring', 'pg_temp'` — med `utvidede_apne_roller(p_env)`
som kropp, filtrert på viewet `subgrafrolle`. `COMMENT ON FUNCTION` navngir hva den gir og hva
den ikke leser. `0072-grant-apne-roller` gjør `REVOKE ALL … FROM PUBLIC` og
`GRANT EXECUTE … TO ${coprocessor_role}`, etter mønsteret i `0061-grant-sudo-innganger`.

### 2. `tilgangsstyring/tilgangsstyring-new-db/src/test/sql/63_apne_roller_uten_tildelinger.sql` (139 linjer)

pgTAP-test med 10 påstander: innholdet (DEL 1) og rettighetsgrensen (DEL 2). `63` var det
neste ledige nummeret i katalogen, slik planen gjettet.

## Files Modified

### 1. `tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/db-changelog-root.xml`

Include for `0072`, med kommentar om at den MÅ stå etter `0061` (eier `utvidede_apne_roller`)
og etter `0063` (eier viewet `subgrafrolle`), og at nummeret gir den rekkefølgen av seg selv.

### 2. `tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/coprocessor/TilgangsstyringDataTilgangerService.java`

Ny `tilgangerForApneRoller(String env)` med `@Retry(maxRetries = 1, delay = 100)`, samme form
som de øvrige oppslagene (`selectFrom(TILGANGER_FOR_APNE_ROLLER.call(env))` →
`fetchGroups` → `Orgtilganger`). Javadoc-en sier hvorfor en flyt uten identitet gjør et
oppslag i det hele tatt.

### 3. `tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/coprocessor/CoprocessorService.java`

`hentActualOrgTilganger`: `AuthorizationCodeResult`-armen binder nå `issuer` og kaller
`tilgangerForApneRoller` når den er `"idporten"`. Resten av armen er uendret, inkludert
`externalServiceId != null ? … : Orgtilganger.EMPTY`.

### 4. `tilgangsstyring/tilgangsstyring-app/src/test/java/no/sikt/fs/tilgangsstyring/coprocessor/CoprocessorResourceTest.java`

- Ny `idportenAuthorizationCode_faarApneRoller`: et ID-porten-token gir `amr = ["idporten"]`
  og `orgtilganger` fra `tilgangerForApneRoller("test")`, og gjør ingen Feide-oppslag.
- `feideAuthorizationCodeWithoutServiceId_deniesAccess` fikk én påstand til:
  `verify(…, never()).tilgangerForApneRoller(any())`. Den er hele poenget med at koblingen er
  skopet på utstederen og ikke på at service-id-en mangler.

## Key Features Implemented

### ✅ `tilganger_for_apne_roller(env)` — gulvet uten identitet

Ren `SELECT` fra `utvidede_apne_roller`. Ingen `kombiner_tildelinger`: det finnes verken tak,
nekt eller bruker å regne med, og svaret er likt for alle kallere i samme miljø.

### ✅ DEFINER + grant kun til coprocessorrollen

Samme begrunnelse som står i `0061`: `utvidede_apne_roller` er INVOKER, og coprocessorrollen
har ingen tabellrettigheter (`0007`/`0009`). Funksjonen er derfor DEFINER, og `REVOKE ALL FROM
PUBLIC` + `GRANT EXECUTE TO ${coprocessor_role}` er det som holder den nye lesekanalen lukket.

### ✅ Utsteder-skopet oppslag i coprocessoren

`"idporten".equals(issuer)` — ikke `externalServiceId == null`. Feide uten `act`-claim gir
fortsatt tomt sett uten databasetreff.

### ✅ jOOQ regenerert

`TILGANGER_FOR_APNE_ROLLER.call(String)` finnes i
`tilgangsstyring-new-jooq/target/generated-sources/jooq/…/tilgangsstyring/tables/TilgangerForApneRoller.java`.
Generert kode ligger under `target/` og er ikke en del av arbeidstreet.

## Project skills consulted

Repoets egne skills (`/home/skurtveito/dev/sikt/fs-plattform/.claude/skills/`) er
`fs-testdata-creation` og `graphql-ytelsesanalyse`; `tilgangsstyring/` har ingen egen
`.claude/skills/`. Ingen av de to dekker denne oppgaven — den oppretter ingen testdata i
utviklingsdatabasen (pgTAP-fiksturen lever i en transaksjon som rulles tilbake) og rører ikke
GraphQL-ytelse eller subgrafens skjema. Konvensjonene er hentet fra `CLAUDE.md`,
`RETNINGSLINJER.md` → «Dokumentasjon og kommentarer», `tilgangsstyring/CLAUDE.local.md` og
`docs/tilgangsmodell.md`, og formen på SQL-en er kopiert fra `0061-sudo-orgtilganger.sql` og
`0063-subgrafroller-i-claim.sql`.

## Test Results

Kjørt fra `/home/skurtveito/dev/sikt/fs-plattform/tilgangsstyring` (Maven og Java via mise):

```
mise run migrate      # mvn -pl :tilgangsstyring-new-db clean install
  → BUILD SUCCESS. Liquibase: 2 nye changesets kjørt (0072-fn-tilganger-for-apne-roller,
    0072-grant-apne-roller) mot den lokale PostgreSQL-en. Ingen nullstilling, ingen compose-
    operasjoner.
  → pgTAP: Tests run: 1110, Failures: 0, Errors: 0 — inkludert de 10 nye påstandene fra
    63_apne_roller_uten_tildelinger.sql

mise run jooq         # mvn -pl :tilgangsstyring-new-jooq clean install
  → BUILD SUCCESS, TilgangerForApneRoller generert

mise exec -- mvn -o -pl :tilgangsstyring-app test -Dtest=CoprocessorResourceTest
  → Tests run: 70, Failures: 0, Errors: 0 (69 fra før + den nye)

mise exec -- mvn -o -pl :tilgangsstyring-app test
  → Tests run: 444, Failures: 2, Errors: 0, Skipped: 5
```

### De to feilene er den kjente, urelaterte akkumuleringen

`SamlingstildelingerGraphqlTest.samlingTilgangerFilterKanter` er dokumentert som pre-eksisterende
på denne maskinen. `DelegeringstakGraphqlTest.lesefeltet` er samme fenomen og samme familie:
begge påstår at en forventet rad ligger på første side, begge lister ti akkumulerte
`IT_*_BATCH_*`-rader i feilmeldingen, og testene er append-only mot en langlevd lokal database.

At dette ikke er min endring, er observert direkte: `DelegeringstakGraphqlTest` var grønn
(`Tests run: 14, Failures: 0`) i første kjøring av den fulle suiten og rød i den neste, med
identisk kode — den vippet fordi kjøringen selv la til rader. Ingen av de to testene berører
åpne roller, coprocessoren eller ID-porten. Databasen er ikke nullstilt.

### Den nye testen er beviselig lastbærende

Med `"idporten"` midlertidig endret til `"idporten-IKKE"` i `hentActualOrgTilganger`:

```
CoprocessorResourceTest.idportenAuthorizationCode_faarApneRoller
  Claim 'orgtilganger' mismatch: [{"op":"remove","path":"/7777"}] ==> expected: <true> but was: <false>
```

Literalen ble umiddelbart satt tilbake.

## Technical Decisions

### 1. Funksjonen filtrerer på `subgrafrolle`, selv om planen ikke nevnte det

**Why**: `0063` slår fast at claim-filteret ligger «i de sju rutinene `${coprocessor_role}` har
EXECUTE på, og bare der» — filteret er en egenskap ved *selektorene*, ikke ved en bestemt
beregning. `tilganger_for_apne_roller` er den åttende slike rutinen. Uten leddet ville en åpen
rolle i et «forretning»- eller «frontend»-navnerom nådd `orgtilganger`-claimet gjennom den ene
selektoren som manglet det, og invarianten fra `0063` ville vært brutt av en funksjon lagt til
etterpå. Kroppen er fortsatt `utvidede_apne_roller(p_env)` — filteret er ett `WHERE`-ledd, og
test 6 i pgTAP-fila fester at det ikke er kommet noe mer inn i kroppen.

### 2. `"idporten".equals(issuer)` og ikke `switch (issuer)`

**Why**: en `switch` over `String` kaster NPE på `null`, og den sudo-fakede kopien i
`hentOrgTilganger` konstruerer nettopp en `AuthorizationCodeResult` med `issuer = null`.
`equals` på literalen er null-trygg, og `AuthorizationCodeResult`-armen beholder dermed dagens
oppførsel for sudo-stien (faller til Feide-grenen → `EMPTY`, fail closed).

### 3. Én positiv coprocessortest her, ikke hele scenariosettet

**Why**: Task #6 eier ende-til-ende-testene for kravets fire regler. Uten en positiv test her
ville koblingen mellom utstederen og det nye oppslaget vært utestet fram til da, så
`CoprocessorResourceTest` fikk én test som fester nettopp den koblingen. Den ligger i den
eksisterende klassen og gjenbruker Quarkus-oppstarten som allerede kjører.

### 4. `is`-påstander på `has_function_privilege`, ikke `throws_ok` alene, for granten

**Why**: kopiert fra DEL 3 i `54_sudo_orgtilganger.sql`. Den positive påstanden (coprocessor
kaller og får svar) beviser både EXECUTE og at DEFINER gir kroppen tabelltilgangen den trenger,
siden coprocessorrollen ikke har tabellrettigheter i det hele tatt; den negative
(`42501` for app-rollen) skiller «nektet» fra «tomt svar».

## Build Status

✅ **Build successful** — `mise run migrate`, `mise run jooq` og
`mise exec -- mvn -o -pl :tilgangsstyring-app test` kompilerer rent
✅ **No new linter warnings** — ingen nye advarsler fra javac
✅ **All imports resolved correctly** — `TILGANGER_FOR_APNE_ROLLER` kommer fra den eksisterende
`import static …Tables.*`

## Integration Points

- **`CoprocessorService.hentActualOrgTilganger`**: eneste kaller av `tilgangerForApneRoller`.
  Feide, Maskinporten og basic auth går uendret.
- **`tilgangsstyring-new-db` → `tilgangsstyring-new-jooq`**: funksjonen er en tabellfunksjon og
  genereres som `TilgangerForApneRoller` med `call(String)`.
- **Sudo-stien**: urørt. En sudo-forespørsel over en ID-porten-autentisering treffer fortsatt
  `externalServiceId == null → EMPTY`, som er fail closed og ligger utenfor kravet.
- **Task #6**: scenarioet «Innlogget uten tildelte roller» kan nå peke på både databasetesten og
  `idportenAuthorizationCode_faarApneRoller`.
- **Task #7**: `docs/tilgangsmodell.md` skal ha `tilganger_for_apne_roller` inn i tabellen over
  tilgangsfunksjoner — inkludert at den er filtrert på samme akse som de sju øvrige.

## Acceptance Criteria Met

- ✅ Ny migrering med `tilganger_for_apne_roller(p_env TEXT)`, `STABLE SECURITY DEFINER`,
  `SET search_path TO 'tilgangsstyring', 'pg_temp'`, kropp = `utvidede_apne_roller(p_env)` —
  Evidence: `0072-apne-roller-uten-tildelinger.sql:22-32` (kroppen har ett filterledd i tillegg,
  se Technical Decisions #1)
- ✅ `REVOKE ALL … FROM PUBLIC` + `GRANT EXECUTE … TO ${coprocessor_role}` som
  `0061-grant-sudo-innganger` — Evidence: `0072-apne-roller-uten-tildelinger.sql:41-46`
- ✅ `COMMENT ON FUNCTION` navngir hva den gir: de åpne rollene i miljøet, ingen identitet, ingen
  tildelinger — Evidence: `0072-apne-roller-uten-tildelinger.sql:34-38`
- ✅ Include i `db-changelog-root.xml` med kommentar om rekkefølgekravet — Evidence:
  `db-changelog-root.xml` (siste include, kommentar navngir `0061` og `0063`)
- ✅ DB-test: funksjonen returnerer de åpne rollene for miljøet, og `coprocessor_role` er den
  eneste rollen med EXECUTE — Evidence: `63_apne_roller_uten_tildelinger.sql`, 10 påstander,
  alle grønne i `mise run migrate`
- ✅ `TilgangsstyringDataTilgangerService.tilgangerForApneRoller(String env)` med `@Retry`, samme
  form som de øvrige — Evidence: `TilgangsstyringDataTilgangerService.java:69-85`
- ✅ `hentActualOrgTilganger` kaller den kun når `issuer == "idporten"`; Feides
  `externalServiceId == null → EMPTY` uendret — Evidence: `CoprocessorService.java:523-535`;
  `CoprocessorResourceTest.feideAuthorizationCodeWithoutServiceId_deniesAccess` med
  `verify(…, never()).tilgangerForApneRoller(any())`
- ✅ jOOQ regenerert — Evidence: `mise run migrate` → `mise run jooq`, begge BUILD SUCCESS;
  `TilgangerForApneRoller.call(String)` generert

## Next Steps

- **Task #6**: ende-til-ende coprocessortest for kravets fire regler, inkludert scenarioet
  «Innlogget uten tildelte roller» med sin egen `QuarkusTestProfile`.
- **Task #7**: `tilganger_for_apne_roller` inn i funksjonstabellen i `docs/tilgangsmodell.md`,
  og `idporten` inn i `sti`-verdimengden i `CoprocessorMetrikker`-javadocen.
- Ytelse: oppslaget er ett nytt databasekall på en sti som i dag ikke har noe. Det er billigere
  enn de øvrige (ingen join mot bruker eller applikasjon), men bør måles før produksjonssetting
  hvis `docs/tidsbudsjett.md` skal oppdateres.

## Conclusion

Gulvet i tilgangsmodellen gjelder nå også for en innlogget bruker uten tildelinger, og den nye
lesekanalen er lukket for alle andre enn coprocessorrollen. Feides fail-closed står urørt og er
festet av en påstand som ville falt om koblingen ble gjort generell. Klar for review og for
Task #6.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
