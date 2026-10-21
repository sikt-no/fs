---
name: fs-verify
description: Verifiserer krav mot koden i dette repoet. Tar en `krav/`-sti, et scope (`@scope-<slug>`) eller en oppgave (`tasks/<domene>/<slug>`) og lokale kloner av kode-repoene. For hvert `@in-progress`-krav leter skillen etter implementasjonen av hvert scenario i koden, får resultatet kontrollert (av subagenten `fs-verify-kontroll` når Agent-verktøyet finnes, ellers manuelt), viser bevis (`fil:linje`), og retagger `@in-progress` → `@implemented` på `Egenskap:`-linja når alt er funnet og brukeren bekrefter. En `@in-progress`-del (`Regel:`/`Scenario:`) i et levert krav som endres, verifiseres på samme måte, og da fjernes `@in-progress` fra delen. For hvert `@deprecated`-krav (egenskap eller `Regel:`/`Scenario:`) leter skillen etter spor i koden. Er koden borte og brukeren bekrefter, slettes fila eller blokken, sammen med referansene (`@depends-on-`, `@ref-`) til kravet; finnes den fortsatt, listes stedene. Verifiserer også flyter i `krav/_Flyter/`: fremdriften fra kravene fasene bygger på, og at overleveringene mellom kravene virker i koden (stedet der tilstanden lages og stedet der den brukes), og gir flyten `@planned` → `@implemented`. Skriver rapport i chat, og i `tasks/<domene>/<slug>/spec/verify-<YYYY-MM-DD>-<HHMM>.md` når en oppgave er gitt, ellers rett ved siden av kravet som `verify-<feature-fil>-<YYYY-MM-DD>-<HHMM>.md` (eller `verify-<mappenavn>-<YYYY-MM-DD>-<HHMM>.md` for en hel mappe), og i `akseptansetest/<scope-slug>/` for et scope, med tidspunkt så kjøringer kan sammenlignes. Er steg 1 i akseptansetesten: rapporten er grunnlaget for testplanen (`fs-testplan`). Tar også en testplan (`akseptansetest/<slug>`) som scope når verifiseringen kjøres på nytt, og spør da etter rapporten om resultatet skal legges som en underside til testplanen i Confluence. Kjører aldri git add/commit/push. Trigges av "verifiser kravene", "er kravene implementert", "tagg kravene som implementert", "sjekk om deprecated-krav kan slettes", "rydd i deprecated", "finnes koden fortsatt", "verifiser testplanen", "legg verifiseringen i Confluence", "verifiser flyten", "virker overleveringene", "fs-verify".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
---

# Verify

## Task

$ARGUMENTS

## Din rolle

Du sammenligner kravene med koden, og lukker løkka tilbake til kravene. Du eier to steg på statusaksen i `krav/README.md`:

`@in-progress` →(**`fs-verify`**)→ `@implemented` →(`fs-krav`)→ `@deprecated` →(**`fs-verify`**)→ slettet

Ber brukeren om å verifisere en egenskap eller en regel *uansett status* («Verifiser» i FS Kravforvaltning), kan du også gi `@draft` og `@planned` statusen `@implemented`. Se *Verifisere uansett status*.

En flyt i `krav/_Flyter/` går `@planned` →(**`fs-verify`**)→ `@implemented`, uten `@in-progress`. Se *Verifisere flyt*.

- **Ikke skriv eller rett applikasjonskode.** Mangler noe, rapporterer du det.
- **Ikke endre kravinnhold.** Du bytter bare statustaggen på `Egenskap:`-linja, fjerner `@in-progress` fra deler i leverte krav som endres, sletter filer eller blokker som er `@deprecated`, og fjerner referansene (`@depends-on-`, `@ref-`) til det du sletter.
- **Påstå aldri mer enn du har sett.** Bevis er et konkret sted i koden (`fil:linje`) som du har lest. Et søk uten treff er ikke bevis for at koden er borte, bare at du ikke fant den. Derfor bekrefter brukeren alle retagginger og slettinger.

## I FS Kravforvaltning

I Claude-panelet i FS Kravforvaltning har du ikke Bash:

- Kodeklonene (fs-admin, fs-plattform, min-kompetanse) står i systemprompten. Bruk dem i stedet for å spørre, og spør bare hvis de mangler.
- `AskUserQuestion` virker: brukeren får spørsmålet som et kort med valgene. Hopper brukeren over, still spørsmålet i svaret, og vent på brukeren.
- Du kan ikke slette filer. Skal en `@deprecated`-fil slettes, si hvilken, så sletter brukeren den selv. Blokker fjernes med `Edit`.
- Lesende git går ikke. Bruk `Grep` og `Glob` i klonene. Branchene i kravrepoet og klonene blir derfor ikke sjekket mot origin (*Sjekk branchen*): skriv `ikke sjekket (Claude-panelet)` i `- **Kode:**` i rapporten.
- Skjermbilder tas med chrome-devtools-MCP. `navigate_page`, `click` og `press_key` er godkjent på forhånd når fs-verify kjøres, sammen med verktøyene som bare leser (`take_screenshot`, `take_snapshot`, `wait_for` …). Andre kall, f.eks. `new_page` og `fill`, må godkjennes i panelet (se *Skjermbilder*).
- Du har ikke Agent-verktøyet, så du kan ikke starte kontrolløren (`fs-verify-kontroll`). Du gjør kontrollen selv (*Kontroll*), og den er ikke uavhengig. **Si det til brukeren før du begynner å lete**, med denne setningen: «Kontrollen av resultatene gjøres manuelt i Claude-panelet: jeg sjekker mine egne funn, uten en uavhengig kontrollør. Les bevisene i rapporten før du sier ja til endringene. Vil du ha uavhengig kontroll, kjør Verifiser i terminalen.» Skriv `- **Kontroll:** manuell (Claude-panelet)` i rapporten.

I terminalen i FS Kravforvaltning («Verifiser i terminal …») og i Claude Code i terminalen har du Agent-verktøyet, og kontrolløren kjøres som vanlig.

## Finn scope og kode (gjør dette FØRST)

0. **Sjekk branchen** i dette repoet mot origin og main, som beskrevet i [`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md). Er den bak, spør før du henter.
1. **Krav.** Oppga brukeren en spesifikasjon (`tasks/<domene>/<slug>/spec/spec-*.md`, typisk fra «Verifiser» på tavla «Oppgaver» i FS Kravforvaltning), er scope bare feature-filene under `## Krav` i den (slått opp på feature-ID). Oppga brukeren et scope (`scope-<slug>`, `@scope-<slug>` eller `tasks/<domene>/scope-<slug>.md`), er scope alle kravene og delene med taggen `@scope-<slug>`, funnet og sjekket mot scope-tabellen som i *Scope* i [`.claude/references/akseptansetest/krav-fra-testplan.md`](../../references/akseptansetest/krav-fra-testplan.md). Oppga brukeren en testplan (`akseptansetest/<slug>`, eller `testplan.md` i den), er scope kravene i «Omfang» og «Venter på verifisering» i testplanen, slått opp på Feature-ID (*Kravene i de andre skillene* i [`.claude/references/akseptansetest/krav-fra-testplan.md`](../../references/akseptansetest/krav-fra-testplan.md)). Oppga brukeren en `krav/`-sti (fil eller mappe), bruk den. En sti under `krav/_Flyter/`, eller en `@FLY-`-ID, er en flyt (*Verifisere flyt*). Flyter er bare med når de er valgt selv: et scope, en oppgave, en spesifikasjon eller en testplan tar dem ikke med. Oppga brukeren en oppgave (`tasks/<domene>/<slug>`, eller bare slug — slå opp med `Glob` `tasks/*/<slug>/`), les Feature-ID-ene fra `## Krav` i alle `<oppgave>/spec/spec-*.md` (ikke det som står under *Utenfor scope*), og finn de autoritative filene under `krav/` på feature-ID (`@DOM-SUB-KAP-NNN`), ikke filnavn. Les ikke kopiene i `spec/krav-input/`: de finnes bare i eldre oppgaver, og kan være utdaterte. 0 treff → «ikke funnet under krav/», mer enn 1 → «duplisert feature-ID». Mangler begge, spør.
2. **Kode.** Spør (`AskUserQuestion`) om stien til de lokale klonene av kode-repoene (se *Kodeklonene*). Foreslå repoer fra `oppgave.md` (lenker), `<lag>/plan-*.md` og `<lag>/task-*-completion.md` når en oppgave er gitt. Sjekk at stiene finnes, og sjekk branchen i hver klone ([`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md)): det er koden på branchen som verifiseres. Uten kode kan ingenting verifiseres: stopp og si det. Skriv aldri `.claude/spec.local.md`.
3. **Skjermbilder.** Har prompten ikke sagt om det skal tas skjermbilder («Ta skjermbilder» eller «Ingen skjermbilder»), spør med `AskUserQuestion` før du begynner å lete: «Skal jeg ta skjermbilder fra https://test-fsadmin.sikt.no/?», med valgene «Ja» og «Nei». Hopper brukeren over, regn det som «Nei», og si det i rapporten. Se *Skjermbilder*.
4. **Hint.** Når en oppgave er gitt: les `design.md`, `<lag>/plan-*.md` og `<lag>/task-*-completion.md`. Filstier, komponentnavn, GraphQL-felt og ruter derfra er de beste stedene å lete.
5. **Tidspunkt.** Ta tidspunktet for kjøringen nå (*Tidspunkt*), og si det til brukeren sammen med navnet rapporten får.

### Kodeklonene

Hvert kode-repo har en bokstav som brukes i `Bevis` i rapporten (se `references/rapportmal.md`). I rapporten skrives repoene med navn, ikke som lag (ikke «backend» eller «frontend»):

| Repo | Bokstav | Hva det dekker |
| --- | --- | --- |
| `fs-plattform` | P | API (GraphQL-subgrafene), tjenestene og databasen |
| `fs-admin` | A | Det saksbehandlere og forvaltere ser og gjør |
| `min-kompetanse` | M | Det søkeren ser og gjør: søknaden, Min kompetanse |

Let etter hvert scenario i repoet det gjelder: et scenario der søkeren ser eller gjør noe, finnes i min-kompetanse (og i fs-plattform), ikke i fs-admin. Mangler klonen et scenario trenger, er det repoet ikke sjekket: skriv det under *Ikke sjekket* i `## Oppfølging`, og resultatet er `usikker`, ikke `ikke funnet`.

## Logg kjøringen

Når en oppgave er gitt, skrives én `started`-linje og én `ended`-linje til `<oppgave>/spec/spec.log.md`, i formatet fra [`fs-specify` → *Logg kjøringen*](../fs-specify/SKILL.md#logg-kjøringen-gjør-dette-andre). Bruk bare Read og Write.

```
- 2026-09-29 — `fs-verify` started — 3 @in-progress, 2 @deprecated
- 2026-09-29 — `fs-verify` ended (success) — 2 retagget @implemented, 1 fil og 1 regel slettet, 1 @deprecated finnes fortsatt i koden
```

`AskUserQuestion`-kall logges til `<oppgave>/spec/questions-fs-verify-<YYYY-MM-DD>.md` etter [`fs-specify/references/askuserquestion-logging.md`](../fs-specify/references/askuserquestion-logging.md). Uten oppgave logges ingenting til fil.

## Klassifiser

Les hver `.feature`-fil i scope og sorter:

| Funn | Håndtering |
|------|------------|
| `@in-progress` på `Egenskap:` | *Verifisere implementasjon* |
| `@deprecated` på `Egenskap:` | *Verifisere at koden er borte* (hele fila) |
| `@deprecated` på `Regel:`/`Scenario:` (under `@implemented` eller `@in-progress`) | *Verifisere at koden er borte* (blokken) |
| `@in-progress` på `Regel:`/`Scenario:` (under `@implemented`) | *Verifisere implementasjon* (delen), se *Deler i leverte krav som endres* |
| `@planned` på `Regel:`/`Scenario:` (under `@implemented`) | Ikke hentet inn i en oppgave — rapporter, og henvis til `fs-specify` |
| `@implemented` uten `@in-progress`-, `@planned`- eller `@deprecated`-deler | Allerede levert — rapporter, ingen endring |
| `@draft`, `@planned`, ingen status | Ikke klar for verifisering — rapporter, og henvis til `fs-krav` / `fs-specify` |
| To statustagger på `Egenskap:` | Stopp for denne fila og rapporter |
| Flyt (`krav/_Flyter/`) med `@planned` eller `@in-progress` | *Verifisere flyt* |
| Flyt med `@draft` | Bare fremdriften (*Verifisere flyt*, steg 1). Henvis til `fs-krav` for validering |

Ber prompten om å verifisere *uansett status*, gjelder ikke tabellen for egenskapen eller regelen i scope: se *Verifisere uansett status*.

Vis oversikten til brukeren før du gjør noe.

## Verifisere implementasjon (`@in-progress`)

**Gating-sett** = alle `Scenario:`/`Scenariomal:` under `Egenskap:`, minus de som er (selv eller via `Regel:`) tagget `@draft`, `@deprecated`, `@openquestion` eller `@demo`. `Bakgrunn:` er ikke et eget punkt. Den samme definisjonen står i `gating` i `fs-kravforvaltning/src/specboard.ts` (fremdriften på kortene i Spesifikasjoner); endres den ene, endres den andre i samme endring.

For hvert krav:

1. **Let etter hvert gating-scenario i koden.** Bruk hintene fra oppgaven, og søk etter begreper fra scenarioet (tekster i `Så`-stegene, feltnavn i tabellene, handlingen i `Når`). Les treffene. Et scenario er **funnet** når koden du har lest, gjør det scenarioet beskriver. En `Scenariomal:` er funnet når alle radene i `Eksempler:` er dekket. Før du skriver `ikke funnet`, følg *Negative søk*.
2. **Se etter tester.** Finnes step definitions i `tester/steps/` for scenarioet, eller tester i kode-repoet som dekker det, nevn dem som ekstra bevis i chat. De står ikke i rapporten.
3. **Kontroller resultatet** etter *Kontroll*, før du viser det til brukeren.

Spør ikke underveis. Når alle kravene i scope er kontrollert, går du videre til *Rapport og endringer*.

**Kan leveres** når gating-settet ikke er tomt, **alle** gating-scenarioer er `funnet` etter kontrollen, og ingen `@openquestion` står igjen i fila. Retaggingen er én `Edit` på `Egenskap:`-tag-linja; bare statustaggen byttes: `@OPT-SOK-VIS-001 @must @in-progress` → `@OPT-SOK-VIS-001 @must @implemented`. `@draft`- og `@deprecated`-deler står urørt.

Ellers står kravet som `@in-progress`, og det som mangler, står i rapporten.

### Skjermbilder

Skjermbilder av appen som kjører, er ekstra bevis for scenarioer som har en skjerm (lister, skjemaer, detaljsider). De erstatter ikke `fil:linje`: et scenario er fortsatt `funnet` bare når du har lest koden.

1. **Bare når brukeren har sagt ja** (*Finn scope og kode*, steg 3). Adressen er alltid `https://test-fsadmin.sikt.no/`. Spør ikke om den.
2. **Bruk chrome-devtools-MCP** (`navigate_page` i siden som er åpen, `click`, `press_key` og `take_screenshot`, som er godkjent på forhånd i FS Kravforvaltning; `new_page` bare når det ikke finnes noen side). Finnes den ikke, si at brukeren må legge den til og starte den én gang med den lokale Claude Code-CLI-en i terminalen: `claude mcp add --scope user chrome-devtools -- npx chrome-devtools-mcp@latest`. Bruk navnet `chrome-devtools`, for det er navnet FS Kravforvaltning tar med. Gå videre uten skjermbilder. Avviser brukeren et kall, prøv ikke igjen uten å spørre. Krever appen innlogging, be brukeren logge inn i nettleservinduet chrome-devtools åpner, og vent.
3. **Ta ett skjermbilde per scenario** som har en skjerm. Gjør det som står i `Gitt`/`Når` så langt det går uten å endre data, og ta bildet av det `Så` beskriver. Endrer et scenario data (opprette, endre, slette), ta bare bildet av skjemaet eller siden før handlingen, og si det.
4. **Lagre bildet** når en oppgave er gitt, som `<oppgave>/spec/verify-<YYYY-MM-DD>-<HHMM>/<NN>-<scenario-kebab>.png` (`NN` = to sifre; mappa har samme navn som rapporten, uten `.md`, også med `-2`-suffiks):
   - I FS Kravforvaltning: `take_screenshot` uten `filePath`, og rett etter `mcp__kravforvaltning__save_sketch` med `path` (uten `tool_use_id` lagres det siste bildet).
   - I terminalen: `take_screenshot` med `filePath` satt til stien.

   Uten oppgave lagres ingenting. Vis bildet i chat og si hva det viser.
5. **Lenk bildet** fra `Bevis`-kolonnen i `## Scenarioer`, etter `fil:linje`: `` `<repo>/<fil>:<linje>` · [skjermbilde](verify-<YYYY-MM-DD>-<HHMM>/<NN>-<scenario-kebab>.png) ``. Viser skjermbildet noe annet enn scenarioet sier, er scenarioet `usikker`, og avviket står i beviset.

### Deler i leverte krav som endres

Når et levert krav endres, står egenskapen som `@implemented`, og statusen på delen (se *Endring av levert krav* i `krav/README.md`). En `@in-progress`-del verifiseres som et krav, med disse forskjellene:

- **Gating-sett** = scenarioene i delen (for en `Regel:`: alle scenarioene under den), minus de som er tagget `@openquestion` eller `@demo`.
- I forslaget og spørsmålene står delen med tittel: `<feature-ID> — Regel: <tittel>`.
- **Når delen kan leveres og brukeren har sagt ja:** fjern `@in-progress` fra `Regel:`-/`Scenario:`-linja med én `Edit`. Andre tagger på linja står urørt. Blir linja tom, fjern hele linja. Delen arver da `@implemented` fra egenskapen. `Egenskap:`-linja endres ikke.
- Erstatter delen en `@deprecated`-del, verifiser den `@deprecated`-delen i samme kjøring (*Verifisere at koden er borte*). Den nye koden kan være på plass selv om den gamle ikke er fjernet enda, og da blir den `@deprecated`-delen stående.

### Verifisere uansett status

«Verifiser» på en egenskap eller en regel i FS Kravforvaltning ber deg verifisere den *uansett status*. Prompten sier hvilken egenskap eller regel (med linja), og statusen på regelen og egenskapen. Kodeklonene og skjermbildene er som ellers (*Finn scope og kode*).

- **Scope** er egenskapen eller regelen, ikke resten av fila.
- **Gating-sett** = scenarioene i scope, også det som er `@draft` eller `@planned`, minus `@demo`. `@deprecated`-deler følger *Verifisere at koden er borte*.
- Let og kontroller som i *Verifisere implementasjon*, steg 1–3. Rapporten og spørsmålet kommer etterpå (*Rapport og endringer*).
- **Ny status foreslås** bare når hele gating-settet er `funnet` og ingen `@openquestion` står igjen i scope. Endringen gjøres bare når brukeren har sagt ja (*Rapport og endringer*):
  - **Egenskap** med `@draft`, `@planned` eller `@in-progress`: bytt statustaggen på `Egenskap:`-linja med `@implemented`. `@draft`-deler under den står urørt, og er fortsatt ikke levert.
  - **Egenskap** som er `@implemented`: ingen endring. Har den `@draft`-, `@planned`- eller `@in-progress`-deler, si at de verifiseres hver for seg.
  - **Regel** under en `@implemented` egenskap, med `@draft`, `@planned` eller `@in-progress`: fjern statustaggen fra `Regel:`-linja, som i *Deler i leverte krav som endres*. Regelen arver `@implemented`. Erstatter regelen en `@deprecated`-del, verifiser den også.
  - **Regel** uten egen status under en `@implemented` egenskap: den er allerede levert, ingen endring.
  - **Regel** under en egenskap som ikke er `@implemented`: ingen endring. En del kan ikke være levert når egenskapen ikke er det. Si at hele egenskapen må verifiseres.
- Mangler noe, blir statusen stående, og det som mangler, står i rapporten. Bytt aldri en status nedover (f.eks. `@implemented` → `@planned`).

## Verifisere flyt

En flyt (`krav/_Flyter/`, se *Flyter* i `krav/README.md`) beskriver et løp på tvers av domener. Hver `Regel:` er en fase, og `@depends-on-` på fasen peker på kravene den bygger på. Flyten har to statuser: fremdriften, som kommer fra kravene, og sin egen status, som sier at overleveringene mellom kravene virker. Testene for hvert krav setter opp tilstanden selv, så de kan gå grønt selv om det ene kravet aldri får det det andre lager. Det er det du ser etter her.

1. **Fremdrift.** For hver fase: slå opp hver `@depends-on-<ID>` (`Grep "^\s*@(.*\s@)?<ID>\b"` i `krav/**/*.feature`) og les statusen på `Egenskap:`. Fasen er levert når alle kravene er `@implemented` (for en `@depends-on-FLY-…`: når den flyten er `@implemented`). En fase uten `@depends-on-` er `mangler krav`. Dette leser bare tagger, og endrer ingenting.
2. **Overleveringene.** Gating-settet er som i *Verifisere implementasjon*. For hvert scenario: finn i koden både stedet der tilstanden i `Gitt` lages, og stedet der den brukes til det `Så` sier. Scenarioet er **funnet** bare når du har lest begge (to `fil:linje`, i samme repo eller i forskjellige), og det som brukes, er det samme som det som lages: samme tabell, felt, hendelse eller API. At kravene i fasene er levert hver for seg, er ikke bevis. Eksempel: tilbudsgarantien lages i tidligopptaket, men plasstildelingen i hovedopptaket leser den ikke. Da er scenarioet `ikke funnet`, selv om begge kravene er `@implemented`. *Negative søk* og *Kontroll* gjelder som ellers. Finnes en `@e2e`-test for flyten, nevn den i chat.
3. **Ny status** foreslås bare når alle fasene er levert og hele gating-settet er `funnet`: `@planned` eller `@in-progress` → `@implemented` på `Egenskap:`-linja, når brukeren sier ja (*Rapport og endringer*). Er en fase ikke levert, står flyten under *Blir stående*, med fasene som mangler. Mangler en overlevering, foreslå i `## Oppfølging` at bruddet skrives som kjent brudd i flyten med `fs-krav` (modus E). Du skriver ikke kommentaren selv.

Rapporten får `## Fremdrift for flyter` (se `[flyt]` i [`references/rapportmal.md`](references/rapportmal.md)), og scenarioene står i `## Scenarioer` med begge bevisene.

## Verifisere at koden er borte (`@deprecated`)

For hvert krav eller hver del:

1. **Let etter spor.** Feature-ID, scenariotitler, tekster fra `Så`-stegene, feltnavn fra tabellene, og navn fra `design.md`/planer (komponenter, ruter, GraphQL-felt, tabeller), etter sjekklista i *Negative søk*. Les treffene, og skill ekte kode fra tilfeldige ordlikheter.
2. **Kontroller resultatet** etter *Kontroll*. «Ingen spor funnet» fører til sletting, så kontrollen er ekstra viktig her.
3. **Resultatet** er `finnes fortsatt` (med `fil:linje` og hvorfor du mener det er denne funksjonaliteten) eller `ingen spor funnet` (med hva du og kontrollen søkte etter, og i hvilke repoer). Det vises i rapporten.
4. **Ingen spor funnet:** kravet (eller delen) **kan slettes**. Det slettes bare når brukeren har sagt ja (*Rapport og endringer*):
   - `@deprecated` på `Egenskap:` → slett fila (`rm "<sti>"`). Blir kapabilitetsmappa tom, si fra (ikke slett mappa).
   - `@deprecated` på `Regel:`/`Scenario:` → fjern blokken med én `Edit`: tag-linja, kommentarene rett over og under nøkkelordlinja, og alt til neste blokk på samme eller høyere nivå. Resten av fila står urørt. Les fila etterpå og sjekk at den fortsatt er gyldig Gherkin.
   - **Referansene til kravet:** `Grep "@(depends-on|ref)-<ID>\b"` i `krav/` (også `krav/_Flyter/`). Slettes hele fila, gjelder alle treffene. Slettes en del, gjelder de som handler om delen, ut fra kommentaren under taggen. Er det uklart, spør. Referansene står med i forslaget under *Kan slettes*, og fjernes i samme endring: taggen tas bort fra tag-linja (står den alene, hele linja), og en kommentar under taggen som bare forklarer referansen, tas bort. Krav og flyter med `@depends-on-` til kravet listes i `## Oppfølging` med «sjekk med `fs-krav`»: de bygde på noe som nå er borte.
5. **Finnes fortsatt:** kravet blir stående. Det kommer på lista over `@deprecated` som fortsatt finnes i koden.

## Negative søk

Et søk uten treff er svakt bevis: det kan bety at koden heter noe annet. Før et scenario blir `ikke funnet` (eller en `@deprecated`-del blir `ingen spor funnet`), skal du ha søkt i alt dette, i alle kodeklonene:

1. **Fagbegrepet** fra scenarioet, med og uten æ/ø/å (`søkeord`, `sokeord`, `soekeord`), i entall og flertall.
2. **Kodenavnene** begrepet kan ha: camelCase og snake_case (`studieavgift`, `STUDIEAVGIFT`), engelske navn (`tuition`, `keyword`), og forkortelser.
3. **Tekstene brukeren ser:** oversettelsesfilene (i fs-admin `src/common/messages/**/*.json`, og tilsvarende i min-kompetanse). En etikett der leder til komponenten som bruker den.
4. **Kodeverk og databasen:** migrasjonene (`**/db/migration/*.sql`) og kodeverkstabellene. Et begrep kan finnes som kodeverdi (`POLITI_ATTEST`) uten å være koblet til det scenarioet gjelder.
5. **API-et:** GraphQL-skjemaene (`*.graphqls`, `*.graphql`) i alle subgrafene, ikke bare den du venter.

Søk med `git -C <repo> grep -i` (eller Grep), som tar alle filtyper. Skill ekte kode fra genererte filer (`generated/`). List søkeordene og stedene i beviset. Finner du noe som ligner, men ikke dekker scenarioet, skriv det i beviset også: da er resultatet `ikke funnet`, men leseren ser hva som finnes.

## Kontroll

Den som har lett, ser lett det den venter å se. Før resultatet vises til brukeren, kontrolleres det av en som ikke har lett.

**Med Agent-verktøyet** (Claude Code i terminalen, også terminalen i FS Kravforvaltning): start subagenten `fs-verify-kontroll` (`.claude/agents/fs-verify-kontroll.md`) for hver feature-fil, gjerne flere parallelt. Gi den stien til feature-fila, kodeklonene og resultattabellen, ikke hvordan du lette. Den svarer med `bekreftet` / `avkreftet` / `usikker` per rad og et forslag til resultat.

**Uten Agent-verktøyet** (Claude-panelet i FS Kravforvaltning): gjør kontrollen selv, og si til brukeren at den er manuell (se *I FS Kravforvaltning*):

1. Les `fil:linje` på nytt for hvert `funnet`, og sjekk koden mot `Når` og `Så`, ikke mot det du skrev.
2. Søk på nytt for hvert `ikke funnet` med søkeord du ikke har brukt, etter *Negative søk*.

**Når kontrollen er uenig:** les det kontrollen viser til. Har kontrollen rett, bruk det nye resultatet. Er dere fortsatt uenige, blir resultatet `usikker`, med begge synene i beviset, og brukeren avgjør. Et `funnet` som kontrollen avkrefter, kan aldri brukes til retagging.

## Tidspunkt

Hver kjøring har ett tidspunkt, `YYYY-MM-DD HH:MM` i lokal tid, som brukes i navnet på rapporten (`<YYYY-MM-DD>-<HHMM>`, uten kolon, fordi Windows ikke tillater det i filnavn), i `- **Dato:**` og i mappa med skjermbilder. Ta det **når du starter**, før du leter, og bruk det samme gjennom hele kjøringen:

1. Står tidspunktet i systemteksten («Tidspunktet nå er …», i Claude-panelet og terminalen i FS Kravforvaltning), bruk det.
2. Ellers, med Bash: `date '+%Y-%m-%d %H:%M'`.
3. Ellers: spør brukeren hva klokka er. Gjett aldri.

## Rapport og endringer

Når alle kravene i scope er kontrollert, viser du rapporten først, og spør etterpå. Brukeren skal aldri få et spørsmål om et resultat de ikke har sett.

1. **Vis rapporten i chat**, etter malen (*Rapport*), med seksjonene som ikke avhenger av svaret: metadataene, `## Oversikt per krav` (når den er med), `## Scenarioer`, `## Kontroll`, `## @deprecated som fortsatt finnes i koden` og `## Oppfølging`. Scenarioene utenfor gating-settet listes for seg under tabellen.
2. **Vis forslaget** rett under, som `## Forslag til endringer` (bare i chat, ikke i fila):
   - **Kan leveres:** `<feature-ID> — <tittel>` (`<fil>`, `<status>` → `@implemented`, <n>/<n> funnet), og deler som `<feature-ID> — Regel: <tittel>` (`@in-progress` fjernes).
   - **Kan slettes:** `<feature-ID> — <tittel eller del>` (`<fil>`, hele fila eller blokken), med repoene det er søkt i, og referansene til kravet som fjernes (`<fil>`: `@depends-on-<ID>` | `@ref-<ID>`).
   - **Blir stående:** kravene og delene som ikke kan leveres, med `<n>/<N> funnet` og hvorfor.
3. **Er forslaget tomt** (ingenting kan leveres eller slettes): ikke spør. Gå til steg 5.
4. **Spør én gang** (`AskUserQuestion`, `multiSelect: false`). Spørsmålet nevner kravene, så det kan leses uten resten av chatten: «Rapporten står over. `<feature-ID> — <tittel>` (<n>/<n>) og `<feature-ID> — <tittel>` (<n>/<n>) kan leveres, og `<feature-ID> — <tittel>` kan slettes (ingen spor i <repoer>). Hva vil du gjøre?» Er det mer enn fem, skriv antallet og «se Forslag til endringer over». Valgene:
   - **Gjør endringene** — lever og slett alt under *Kan leveres* og *Kan slettes*.
   - **Gå gjennom krav for krav** — se under.
   - **Ikke endre noe** — alle kravene blir stående som de er, og det står i rapporten.

   Brukeren kan også skrive i «Annet», f.eks. at noe ikke virker. Les det, og gjør resultatet for det kravet om til `usikker` eller `ikke funnet` når brukeren sier at noe mangler. Spør igjen med det nye forslaget.

   **Gå gjennom krav for krav:** ett `AskUserQuestion` per krav eller del i forslaget, i rekkefølgen i rapporten. Vis resultattabellen for kravet i chat rett før, og la spørsmålet stå alene: «`<feature-ID> — <tittel>` (`<fil>`): <n>/<n> scenarioer funnet, bl.a. `<repo>/<fil>:<linje>` (<hva koden gjør>). Kontrollen <bekreftet alle | endret <n>>. Skal kravet bli `@implemented`?» (for en del: «Skal delen leveres?») — **Ja** / **Nei, noe mangler** (spør hva i fritekst) / **Avbryt** (stopp, og la resten stå). For en sletting: «Fant ingen spor av `<feature-ID> — <tittel eller del>` i <repoer> (søkt etter «<ord>», «<ord>»). Slette <fila | blokken>?» — **Slett** / **Behold** / **Avbryt**.
5. **Gjør endringene** brukeren sa ja til (retagging i *Verifisere implementasjon*, *Deler i leverte krav som endres* og *Verifisere uansett status*, sletting i *Verifisere at koden er borte*, steg 4).
6. **Skriv rapporten til fil** (*Rapport*), med alle seksjonene, og vis `## Oppsummering`, `## Levert`, `## Ikke levert` og `## Slettet` i chat, med stien til rapporten. Fila skrives først nå, fordi tavla «Oppgaver» leser den: en rapport der alt er funnet, flytter kortet til «Verifisert».

## Etter endringene

Si dette i chat. Det står ikke i rapporten.

- **Foreldreløse step definitions.** For slettede scenarioer: søk i `tester/steps/` etter stegtekstene. Steg som ikke lenger brukes av noen `.feature`-fil, listes. Ikke slett dem.
- **Tester.** Et `@deprecated` scenario som fortsatt har step definitions, vil feile når koden fjernes. Nevn det.

## Rapport

Rapporten vises i chat før spørsmålet, og skrives til fil når endringene er gjort (*Rapport og endringer*). Fila ligger etter hva scope er. Filnavnet har alltid dato og klokkeslett (`<YYYY-MM-DD>-<HHMM>`, se *Tidspunkt*), så kjøringer samme dag kan sammenlignes og ikke skriver over hverandre:

- **Oppgave eller spesifikasjon:** `<oppgave>/spec/verify-<YYYY-MM-DD>-<HHMM>.md` (`verify-2026-10-09-1432.md`; `-2`, `-3` … hvis fila finnes).
- **Bare en `krav/`-sti:** rett ved siden av det som ble verifisert. For én fil: `verify-<feature-fil>-<YYYY-MM-DD>-<HHMM>.md` i samme mappe som fila, der `<feature-fil>` er filnavnet uten `.feature` (`fjerne_roller.feature` → `verify-fjerne_roller-2026-10-07-0915.md`). For en mappe: `verify-<mappenavn>-<YYYY-MM-DD>-<HHMM>.md` inne i mappa, sammen med kravene den gjelder (`…/12 Brukeradministrasjon/personbrukere/` → `…/12 Brukeradministrasjon/personbrukere/verify-personbrukere-2026-10-07-0915.md`). `-2`, `-3` … hvis fila finnes. Linja `- **Spec:**` utelates.

- **Scope:** `akseptansetest/<scope-slug>/verify-<YYYY-MM-DD>-<HHMM>.md`, i mappa testplanen for scopet får (*Struktur* i [`akseptansetest/README.md`](../../../akseptansetest/README.md)). Lag mappa hvis den ikke finnes. `- **Spec:**` utelates, og `- **Krav:**` er `@scope-<slug>` (<N> feature-filer).
- **Testplan:** gjelder testplanen én oppgave, som for en oppgave (`<oppgave>/spec/verify-…`). Ellers (et scope, en mappe eller feature-filer) i testplanmappa: `akseptansetest/<slug>/verify-<YYYY-MM-DD>-<HHMM>.md`. `- **Spec:**` utelates, og `- **Krav:**` er kilden i testplanen (`@scope-<slug>`, `krav/<sti>/` eller filene, <N> feature-filer).

Skriv aldri over en tidligere rapport, og endre den ikke: den er det du sammenligner med neste gang. Unntaket er linja `- **Confluence:**`, som skrives inn i samme kjøring (*Confluence*).

Skriv aldri rapporten noe annet sted under `krav/`. Ikke kall den `verification-*.md`: det mønsteret er reservert for `<lag>/` (se *Fire regler* i `tasks/README.md`).

**Formatet står i [`references/rapportmal.md`](references/rapportmal.md).** Les malen før du skriver rapporten, og følg den nøyaktig: alle seksjonene, i samme rekkefølge, med de faste tekstene. Det er det som gjør at to kjøringer kan sammenlignes. FS Kravforvaltning leser `- **Dato:**`, `- **Spec:**` og tabellen `## Scenarioer`, og viser resultatet på kortet i Spesifikasjoner.

**Tall regnes ut, de telles ikke.** Alle tall i rapporten (scenarioer funnet per krav, i alt, og i *Oppsummering*) regnes ut fra tabellen `## Scenarioer` og fra endringene du har gjort, f.eks. med `awk` på rapportfila når du har Bash. Uten Bash: tell radene i tabellen én gang til, krav for krav, før du skriver tallene.

`- **Kontroll:**` sier hvem som kontrollerte: `fs-verify-kontroll` (uavhengig) eller `manuell (Claude-panelet)`. `## Kontroll` lister radene der kontrollen endret resultatet, så leseren ser hva den første letingen bommet på.

**`utforing.md`.** Når scope er en spesifikasjon som er sendt (har en seksjon i `<oppgave>/utforing.md`, se *Utføring* i `tasks/README.md`): mangler noe (`ikke funnet` eller `usikker` etter kontrollen, eller brukeren har sagt at noe mangler), sett steget i repoet der koden mangler, tilbake til `- **Status**: pågår`, legg til `- **Tilbake**: <YYYY-MM-DD>`, og en linje i `Logg` (`<dato> — fs-verify — <n> ikke funnet, <n> usikker · tilbake til <repo>`). Er alt funnet, legg bare til en linje i `Logg` (`alt funnet · verifisert`); kortet står i «Verifisert» når kravene er `@implemented`.

## Confluence

Verifiseringen er steg 1 i akseptansetesten (se [`akseptansetest/README.md`](../../../akseptansetest/README.md)), før testplanen, som i [teststrategien](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5117902850). Resultatet kan legges som en underside til testplanen i Confluence, så testflyten har verifiseringen på samme sted som testcasene og testrapportene. Gjør dette etter at rapporten er skrevet. Retaggingen og rapporten endres ikke av det.

0. **Finnes testplanen?** Se etter testplanen etter *Finn testplanen* i [`.claude/references/akseptansetest/confluence.md`](../../references/akseptansetest/confluence.md): testplanen i scope, eller `Grep` etter kilden (scope-id-en, oppgaven, mappa eller fila) i `akseptansetest/*/testplan.md`. Finnes ingen testplan med `- **Confluence**:`, er dette den første verifiseringen: spør ikke om Confluence. Si at neste steg er `fs-testplan` med den samme kilden, og at den bygger på rapporten og legger den som underside når testplanen opprettes. Slutt der. Finnes testplanen, fortsett.
1. **Spør** (`AskUserQuestion`): «Legg resultatet i Confluence?», med valgene «Ja, som utkast» (anbefalt), «Ja, publiser» og «Nei». Spør ikke når prompten allerede har sagt det («Legg resultatet i Confluence» eller «Ikke Confluence»). Finnes ingen Atlassian-MCP i økta, eller er den ikke logget inn, spør ikke: si det, og at rapporten står i fila. Hopper brukeren over, regn det som «Nei».
2. **Testplanen** er den du fant i steg 0.
3. **Lag undersiden** «Verifisering – <leveranse> – <YYYY-MM-DD HH:MM>» (tidspunktet for kjøringen, *Tidspunkt*) under testplanen, med `status: "draft"` ved «Ja, som utkast». Innholdet er rapporten fra og med metadataene: `## Oversikt per krav` (når den finnes), `## Oppsummering`, `## Scenarioer` og `## Levert`, med tabellene som i fila. Stiene i `Bevis` blir lenker til GitHub på commiten i `- **Kode:**` (`https://github.com/sikt-no/<repo>/blob/<sha>/<sti>#L<linje>`). Følg *Fra fila til siden* i `confluence.md`.
4. **Oppdater testplanen:** raden «1. Verifisering (`fs-verify`)» i «Status i flyten», med lenken, «Alt funnet» eller «<N> ikke funnet, <N> usikker», og datoen (*«Status i flyten» på testplanen* i `confluence.md`). Oppdater raden i `testplan.md` også. Andre deler av testplanen rører du ikke.
5. **Skriv lenken** i metadataene i rapportfila: `- **Confluence:** <url>` (`<url> (utkast)` for et utkast), etter `- **Skjermbilder:**` (variant `[confluence]` i rapportmalen).
6. **Si hva som er neste steg:** `fs-testrapport` for verifiseringen, med testplanen. Er det kommet krav i «Omfang» som var i «Venter på verifisering», foreslå også å kjøre `fs-testplan` på nytt, så de står i «Omfang».

Skjermbildene fra *Skjermbilder* lastes ikke opp. Siden lenker til mappa på GitHub når den er committet.

## Git

Ikke `git add`, `commit`, `push`, `checkout` eller `stash` i noe repo. Lesende git-kommandoer (`git -C <repo> log`, `grep`, `ls-files`) er lov. Brukeren commiter endringene i `krav/`, eller lager PR med «Lag PR» i FS Kravforvaltning.

## Referanser

- **`krav/README.md`** — statusaksen, *Delvis utkast* og *Avvikling*.
- **[`tasks/README.md`](../../../tasks/README.md)** — oppgavestrukturen og reglene for `spec/`.
- **`fs-krav`** — setter `@deprecated` når et levert krav skal fjernes.
- **`fs-specify` / `fs-specify-delta`** — setter `@in-progress`, på egenskaper og på deler i leverte krav som endres.
- **`.claude/agents/fs-verify-kontroll.md`** — kontrolløren som sjekker resultatene uavhengig (*Kontroll*).
- **[`.claude/references/akseptansetest/`](../../references/akseptansetest/)** — scope som kilde, testplanen som scope, og Confluence-steget (*Confluence*).
- **`fs-testplan`** — neste steg i akseptansetesten, og bygger på rapporten.
