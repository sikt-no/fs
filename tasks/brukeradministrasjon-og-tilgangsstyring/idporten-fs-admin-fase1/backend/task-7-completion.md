# Task #7 Completion Report: Dokumentasjon og metrikk-kommentar

## Status: ✅ COMPLETED

**Date Completed**: 2026-09-22
**Task**: Dokumentasjon og metrikk-kommentar
**Priority**: Medium
**Size**: S

## Summary

De tre stedene Task #4 og #5 gjorde utdaterte er oppdatert: `sti`-verdimengden i
`CoprocessorMetrikker` og `docs/coprocessor-metrikker.md` har fått `idporten`,
`docs/tilgangsmodell.md` har `tilganger_for_apne_roller` i tabellen over tilgangsfunksjoner, og
`docs/en-instans-for-alle-miljo.md` har et eget kapittel om at utstedertilliten nå er sti-avhengig
og hvorfor.

To påstander i eksisterende dokumentasjon var blitt direkte usanne av Task #5 og er rettet i samme
slengen: antallet selektorer i `docs/navnerom-for-roller.md` og «de to sudo-inngangene er de eneste
… `GRANT`-et til `${coprocessor_role}` alene» i `docs/tilgangsmodell.md`. Se
[Deviations](#avvik-fra-planen).

Ingen kodeendring med oppførsel. Eneste endring i `.java` er javadoc.

## Files Created

Ingen.

## Files Modified

### 1. `tilgangsstyring/tilgangsstyring-app/src/main/java/no/sikt/fs/tilgangsstyring/coprocessor/CoprocessorMetrikker.java`

`sti`-punktet i klassejavadocen har fått `idporten`, pluss én setning om at test-utstederne ikke
har egne verdier.

### 2. `tilgangsstyring/docs/coprocessor-metrikker.md`

`idporten` inn i `sti`-raden i taggtabellen, og et avsnitt om at `maskinporten` og `idporten`
dekker både produksjons- og test-utstederen, og at `miljo` er det som skiller dem.

### 3. `tilgangsstyring/docs/tilgangsmodell.md`

- Ny rad i tabellen over tilgangsfunksjoner: `tilganger_for_apne_roller(env)` | innlogget bruker
  uten tildelinger (ID-porten) *(`0072`)* | åpne alene.
- Nytt avsnitt om at alle åtte selektorene er filtrert på `subgrafrolle` (`0063`), og at filteret
  er en egenskap ved selektorene og ikke ved beregningen.
- Nytt avsnitt om hvorfor en flyt uten identitet gjør et oppslag i det hele tatt (gulvet).
- Rettet: sudo-inngangene er ikke lenger de *eneste* som er `GRANT`-et til `${coprocessor_role}`
  alene — `tilganger_for_apne_roller` er den tredje. `krev_orgtilganger`-halvdelen av setningen
  står uendret.

### 4. `tilgangsstyring/docs/en-instans-for-alle-miljo.md`

- Innledningen sier nå «samme verifisering som coprocessoren — men ikke det samme settet
  utstedere», med lenke videre.
- Nytt kapittel «Utstedertillit er sti-avhengig»: hvilke utstedere hver sti godtar, at kallstedet
  velger inngang, og hvorfor ID-porten er utelatt på subgraf-stien.

### 5. `tilgangsstyring/docs/navnerom-for-roller.md`

«de sju `tilganger_for_*`-selektorene» → «de åtte».

## Key Features Implemented

### ✅ `sti`-verdimengden stemmer med koden

`CoprocessorService.sti()` returnerer `issuer` fra resultatet, og `IdportenAuthenticator`
konstruerer `AuthorizationCodeResult` med literalen `"idporten"` for **begge** tenantene
(`authenticate` og `authenticateTestIdporten` deler privat kropp). `idporten-test` når derfor
aldri taggen — det samme gjelder `maskinporten-test`, som `MaskinportenAuthenticator` har gjort
hele tiden. Dokumentasjonen sier dette eksplisitt i stedet for å la leseren gjette.

Et avvist ID-porten-token (f.eks. test-utstederen mot et ikke-syntetisk miljø) gir
`AuthenticationFailedResult` og dermed `sti = bearer` via `skjema(request)`, som før.

### ✅ `tilganger_for_apne_roller` står i funksjonstabellen med flyt og innhold

Raden følger formen på de sju øvrige (funksjon | flyt | innhold) og bærer migreringsnummeret i
samme stil som `0013`/`0061`-radene rundt.

### ✅ `subgrafrolle`-invarianten er navngitt der tabellen står

`docs/tilgangsmodell.md` nevnte ikke `0063` i det hele tatt før nå; invarianten var bare beskrevet
i `docs/navnerom-for-roller.md`. Uten leddet i tabellkapitlet ville neste selektor blitt lagt til
uten filteret, akkurat slik Task #5 nesten gjorde.

### ✅ Sti-avhengig utstedertillit er dokumentert med årsaken, ikke bare regelen

Kapitlet sier hva som skjer *uten* gaten: `auth.login_feide_bruker` provisjonerer bare når
`p_feide_id` ikke er NULL, så resultatet blir en sesjon uten subjekt → 200 med tom respons. Det er
den ikke-opplagte delen; at ID-porten er en utsteder er opplagt av koden.

## Project skills consulted

Repoets egne skills (`/home/skurtveito/dev/sikt/fs-plattform/.claude/skills/`) er
`fs-testdata-creation`, `graphql-ytelsesanalyse` og `sis-subgraph-expand`; `tilgangsstyring/` har
ingen egen `.claude/skills/`. Ingen av dem dekker denne oppgaven — den oppretter ingen testdata,
rører ikke GraphQL-ytelse og endrer ikke noe skjema (verken SIS' eller tilgangsstyrings).
Konvensjonene er hentet fra `CLAUDE.md`, `RETNINGSLINJER.md` → «Dokumentasjon og kommentarer» og
`tilgangsstyring/CLAUDE.local.md`.

## Test Results

Kjørt fra `/home/skurtveito/dev/sikt/fs-plattform/tilgangsstyring`:

```
mise exec -- mvn -o -pl :tilgangsstyring-app test
  → Tests run: 453, Failures: 2, Errors: 0, Skipped: 5
```

De to feilene er de kjente, pre-eksisterende på denne maskinen, begge oppgitt i oppdraget:

- `SamlingstildelingerGraphqlTest.samlingTilgangerFilterKanter`
- `DelegeringstakGraphqlTest.lesefeltet`

Begge lister akkumulerte `IT_*_BATCH_*`-rader i feilmeldingen — append-only-testdata i den
langlevde lokale PostgreSQL-en. Ingen av dem er rørt, og databasen er ikke nullstilt. Ingen
compose-operasjoner er kjørt.

Ingen nye tester: endringen er javadoc og markdown, og har ingen kjørbar oppførsel å feste. Kilden
for hver påstand er verifisert i koden framfor antatt — se
[Technical Decisions](#1-verdimengden-for-sti-er-lest-ut-av-koden-ikke-antatt).

## Technical Decisions

### 1. Verdimengden for `sti` er lest ut av koden, ikke antatt

**Why**: oppdraget spurte eksplisitt om `idporten-test` når taggen. Kjeden er
`CoprocessorService.sti()` → `AuthorizationCodeResult(var issuer, …) -> issuer` →
`IdportenAuthenticator.authenticate(rawToken, identityProvider)`, som setter `"idporten"` for
begge tenantene. Verdien er altså `idporten`, aldri `idporten-test`, og dokumentasjonen sier det
rett ut fordi mønsteret ellers inviterer til feil antagelse ved neste utsteder.

### 2. Rettet to påstander utenfor akseptansekriteriene

**Why**: begge var blitt usanne av Task #5 og ville ledet en leser feil. «De sju selektorene» og
«de to sudo-inngangene er de eneste `GRANT`-et til `${coprocessor_role}` alene» er nøyaktig de
setningene en som skulle lagt til selektor nummer ni ville støttet seg på. Rettelsene er én linje
hver, og de er dokumentasjon — oppdragets forbud mot oppførselsendring er intakt.

### 3. Ingen egen notis i `docs/coprocessor-metrikker.md` om at subgraf-stien avviser ID-porten

**Why**: telleren dekker bare coprocessoren, så stiskillet kan ikke observeres i den metrikken.
En setning der ville vært korrekt og verdiløs. Historien står ett sted:
`docs/en-instans-for-alle-miljo.md`.

### 4. Migreringsnummer i doktabellen, ikke i koden

**Why**: `RETNINGSLINJER.md` forbyr migreringsnumre og saksreferanser *i koden*.
`docs/tilgangsmodell.md` bruker allerede `*(`0013`)*`, `*(`0029`)*`, `*(`0061`)*` som en fast
kolonnekonvensjon i nettopp denne tabellen, og en rad uten nummeret ville stukket seg ut. Javadoc-
og kodeendringen bærer ingen numre eller saksreferanser.

## Build Status

✅ **Build successful** — `mise exec -- mvn -o -pl :tilgangsstyring-app test` kompilerer rent
(408 kilder + 41 testkilder); de to testfeilene er pre-eksisterende og urelaterte
✅ **No new linter warnings** — ingen nye advarsler fra javac
✅ **All imports resolved correctly** — ingen import-endringer

## Integration Points

- **`CoprocessorMetrikker` / `docs/coprocessor-metrikker.md`**: verdimengden for `sti` er nå den
  samme to steder, og begge stemmer med `CoprocessorService.sti()`. En Grafana-spørring på
  `sum by (sti)` trenger ingen endring — `idporten` dukker opp som en ny serie.
- **`docs/tilgangsmodell.md` / `docs/navnerom-for-roller.md`**: de to dokumentene refererer nå
  samme antall selektorer, og `subgrafrolle`-invarianten er navngitt begge steder.
- **`docs/en-instans-for-alle-miljo.md`**: eneste sted som forklarer hvorfor `SUBGRAF_UTSTEDERE`
  ikke er `COPROCESSOR_UTSTEDERE`. Javadocen på `BearerTokenAuthenticator.authenticateForSubgraf`
  sier det kort; dokumentet bærer den fulle historien, slik `RETNINGSLINJER.md` foreskriver.

## Acceptance Criteria Met

- ✅ `CoprocessorMetrikker`-javadoc: `sti`-verdimengden utvides med `idporten` — Evidence:
  `CoprocessorMetrikker.java:23-26`
- ✅ `docs/tilgangsmodell.md`: `tilganger_for_apne_roller` inn i tabellen over tilgangsfunksjoner,
  med flyt og innhold — Evidence: `docs/tilgangsmodell.md:355` (raden), `:357-366` (filteret på
  `subgrafrolle`, hvorfor funksjonen finnes, og den rettede GRANT-setningen)
- ✅ `docs/en-instans-for-alle-miljo.md`: at utstedertilliten nå er sti-avhengig, og hvorfor —
  Evidence: `docs/en-instans-for-alle-miljo.md:26-39` (kapitlet «Utstedertillit er sti-avhengig»),
  `:3-6` (innledningen peker dit)
- ✅ Ingen migreringsnumre eller issue-referanser i koden — Evidence: eneste `.java`-endring er
  javadoc-punktet for `sti`; ingen numre eller saksnøkler lagt til. (Den pre-eksisterende
  `FSP-1354`-referansen i samme javadoc er ikke rørt — å fjerne den er en egen vurdering utenfor
  denne oppgaven.)

## Avvik fra planen

1. **`docs/coprocessor-metrikker.md` oppdatert i tillegg til javadocen.** Oppdraget ba om å sjekke
   om filen også lister `sti`-verdiene. Det gjorde den (linje 15), så den fikk samme endring.
2. **`docs/navnerom-for-roller.md:183`: «de sju» → «de åtte».** Tallet var blitt feil av Task #5.
3. **`docs/tilgangsmodell.md`: GRANT-setningen rettet.** «De to sudo-inngangene er de eneste
   funksjonene i modellen som er `GRANT`-et til `${coprocessor_role}` alene» var sann fordi bare
   `0061` gjorde `REVOKE ALL … FROM PUBLIC` på en selektor. `0072` gjør det samme, så påstanden er
   nå usann. De fem selektorene fra `0011`/`0012` har aldri revokert PUBLIC og er derfor fortsatt
   ikke i denne gruppen.

Alle tre er rene dokumentasjonsrettelser uten oppførselsendring.

## Ingen defekter funnet

Ingenting under lesingen av `CoprocessorService`, `BearerTokenAuthenticator`,
`IdportenAuthenticator`, `0063` og `0072` så ut som en feil. Det eneste funnet verdt å nevne er at
`sti` og `amr` ikke skiller produksjons- og test-utsteder, verken for Maskinporten eller ID-porten.
Det er en bevisst arv fra Maskinporten-implementasjonen og ikke en regresjon — test-utstederne er
uansett gatet til syntetiske datamiljø, så `miljo`-taggen skiller dem. Det er nå dokumentert i
stedet for å være et skjult premiss.

## Next Steps

- Task #7 er siste oppgave i planen. Orkestratoren markerer den i `plan-*.md` og oppdaterer
  `spec.log.md`.
- Ytelsesnotatet fra Task #5 står fortsatt åpent: `docs/tidsbudsjett.md` er ikke oppdatert med
  kostnaden for `tilganger_for_apne_roller`, fordi tallet ikke er målt. Det er en egen oppgave, og
  en dokumentasjonsoppgave uten måling ville bare gjettet.

## Conclusion

Dokumentasjonen forteller nå det de seks kodeoppgavene gjorde sant: ID-porten er en sti coprocessoren
godtar og subgraf-stien avviser, gulvet i tilgangsmodellen gjelder også uten tildelinger, og
`subgrafrolle`-filteret er et krav til enhver selektor — ikke et trekk ved én migrering. To
påstander som var blitt usanne er rettet. Klar for review.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
