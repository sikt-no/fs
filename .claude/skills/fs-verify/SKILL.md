---
name: fs-verify
description: Verifiserer krav mot koden i dette repoet. Tar en `krav/`-sti eller en oppgave (`tasks/<domene>/<slug>`) og lokale kloner av kode-repoene. For hvert `@in-progress`-krav leter skillen etter implementasjonen av hvert scenario i koden, får resultatet kontrollert (av subagenten `fs-verify-kontroll` når Agent-verktøyet finnes, ellers manuelt), viser bevis (`fil:linje`), og retagger `@in-progress` → `@implemented` på `Egenskap:`-linja når alt er funnet og brukeren bekrefter. En `@in-progress`-del (`Regel:`/`Scenario:`) i et levert krav som endres, verifiseres på samme måte, og da fjernes `@in-progress` fra delen. For hvert `@deprecated`-krav (egenskap eller `Regel:`/`Scenario:`) leter skillen etter spor i koden. Er koden borte og brukeren bekrefter, slettes fila eller blokken; finnes den fortsatt, listes stedene. Skriver rapport i chat, og i `tasks/<domene>/<slug>/spec/verify-<YYYY-MM-DD>-<HHMM>.md` når en oppgave er gitt, ellers rett ved siden av kravet som `verify-<feature-fil>-<YYYY-MM-DD>-<HHMM>.md` (eller `verify-<mappenavn>-<YYYY-MM-DD>-<HHMM>.md` for en hel mappe), med tidspunkt så kjøringer kan sammenlignes. Kjører aldri git add/commit/push. Trigges av "verifiser kravene", "er kravene implementert", "tagg kravene som implementert", "sjekk om deprecated-krav kan slettes", "rydd i deprecated", "finnes koden fortsatt", "fs-verify".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
---

# Verify

## Task

$ARGUMENTS

## Din rolle

Du sammenligner kravene med koden, og lukker løkka tilbake til kravene. Du eier to steg på statusaksen i `krav/README.md`:

`@in-progress` →(**`fs-verify`**)→ `@implemented` →(`fs-krav`)→ `@deprecated` →(**`fs-verify`**)→ slettet

Ber brukeren om å verifisere en egenskap eller en regel *uansett status* («Verifiser» i FS Kravforvaltning), kan du også gi `@draft` og `@planned` statusen `@implemented`. Se *Verifisere uansett status*.

- **Ikke skriv eller rett applikasjonskode.** Mangler noe, rapporterer du det.
- **Ikke endre kravinnhold.** Du bytter bare statustaggen på `Egenskap:`-linja, fjerner `@in-progress` fra deler i leverte krav som endres, og sletter filer eller blokker som er `@deprecated`.
- **Påstå aldri mer enn du har sett.** Bevis er et konkret sted i koden (`fil:linje`) som du har lest. Et søk uten treff er ikke bevis for at koden er borte, bare at du ikke fant den. Derfor bekrefter brukeren alle retagginger og slettinger.

## I FS Kravforvaltning

I Claude-panelet i FS Kravforvaltning har du ikke Bash:

- Kodeklonene (fs-admin, fs-plattform) står i systemprompten. Bruk dem i stedet for å spørre, og spør bare hvis de mangler.
- `AskUserQuestion` virker: brukeren får spørsmålet som et kort med valgene. Hopper brukeren over, still spørsmålet i svaret, og vent på brukeren.
- Du kan ikke slette filer. Skal en `@deprecated`-fil slettes, si hvilken, så sletter brukeren den selv. Blokker fjernes med `Edit`.
- Lesende git går ikke. Bruk `Grep` og `Glob` i klonene.
- Skjermbilder tas med chrome-devtools-MCP. `navigate_page`, `click` og `press_key` er godkjent på forhånd når fs-verify kjøres, sammen med verktøyene som bare leser (`take_screenshot`, `take_snapshot`, `wait_for` …). Andre kall, f.eks. `new_page` og `fill`, må godkjennes i panelet (se *Skjermbilder*).
- Du har ikke Agent-verktøyet, så du kan ikke starte kontrolløren (`fs-verify-kontroll`). Du gjør kontrollen selv (*Kontroll*), og den er ikke uavhengig. **Si det til brukeren før du begynner å lete**, med denne setningen: «Kontrollen av resultatene gjøres manuelt i Claude-panelet: jeg sjekker mine egne funn, uten en uavhengig kontrollør. Les bevisene før du svarer «Stemmer». Vil du ha uavhengig kontroll, kjør Verifiser i terminalen.» Skriv `- **Kontroll:** manuell (Claude-panelet)` i rapporten.

I terminalen i FS Kravforvaltning («Verifiser i terminal …») og i Claude Code i terminalen har du Agent-verktøyet, og kontrolløren kjøres som vanlig.

## Finn scope og kode (gjør dette FØRST)

1. **Krav.** Oppga brukeren en spesifikasjon (`tasks/<domene>/<slug>/spec/spec-*.md`, typisk fra «Verifiser» i Spesifikasjoner i FS Kravforvaltning), er scope bare feature-filene under `## Krav` i den (slått opp på feature-ID). Oppga brukeren en `krav/`-sti (fil eller mappe), bruk den. Oppga brukeren en oppgave (`tasks/<domene>/<slug>`, eller bare slug — slå opp med `Glob` `tasks/*/<slug>/`), les Feature-ID-ene fra `## Krav` i alle `<oppgave>/spec/spec-*.md` (ikke det som står under *Utenfor scope*), og finn de autoritative filene under `krav/` på feature-ID (`@DOM-SUB-KAP-NNN`), ikke filnavn. Les ikke kopiene i `spec/krav-input/`: de finnes bare i eldre oppgaver, og kan være utdaterte. 0 treff → «ikke funnet under krav/», mer enn 1 → «duplisert feature-ID». Mangler begge, spør.
2. **Kode.** Spør (`AskUserQuestion`) om stien til de lokale klonene av kode-repoene. Foreslå repoer fra `oppgave.md` (lenker), `<lag>/plan-*.md` og `<lag>/task-*-completion.md` når en oppgave er gitt. Sjekk at stiene finnes. Uten kode kan ingenting verifiseres: stopp og si det. Skriv aldri `.claude/spec.local.md`.
3. **Skjermbilder.** Har prompten ikke sagt om det skal tas skjermbilder («Ta skjermbilder» eller «Ingen skjermbilder»), spør med `AskUserQuestion` før du begynner å lete: «Skal jeg ta skjermbilder fra https://test-fsadmin.sikt.no/?», med valgene «Ja» og «Nei». Hopper brukeren over, regn det som «Nei», og si det i rapporten. Se *Skjermbilder*.
4. **Hint.** Når en oppgave er gitt: les `design.md`, `<lag>/plan-*.md` og `<lag>/task-*-completion.md`. Filstier, komponentnavn, GraphQL-felt og ruter derfra er de beste stedene å lete.
5. **Tidspunkt.** Ta tidspunktet for kjøringen nå (*Tidspunkt*), og si det til brukeren sammen med navnet rapporten får.

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

Ber prompten om å verifisere *uansett status*, gjelder ikke tabellen for egenskapen eller regelen i scope: se *Verifisere uansett status*.

Vis oversikten til brukeren før du gjør noe.

## Verifisere implementasjon (`@in-progress`)

**Gating-sett** = alle `Scenario:`/`Scenariomal:` under `Egenskap:`, minus de som er (selv eller via `Regel:`) tagget `@draft`, `@deprecated`, `@openquestion` eller `@demo`. `Bakgrunn:` er ikke et eget punkt. Den samme definisjonen står i `gating` i `fs-kravforvaltning/src/specboard.ts` (fremdriften på kortene i Spesifikasjoner); endres den ene, endres den andre i samme endring.

Ett krav om gangen:

1. **Let etter hvert gating-scenario i koden.** Bruk hintene fra oppgaven, og søk etter begreper fra scenarioet (tekster i `Så`-stegene, feltnavn i tabellene, handlingen i `Når`). Les treffene. Et scenario er **funnet** når koden du har lest, gjør det scenarioet beskriver. En `Scenariomal:` er funnet når alle radene i `Eksempler:` er dekket. Før du skriver `ikke funnet`, følg *Negative søk*.
2. **Se etter tester.** Finnes step definitions i `tester/steps/` for scenarioet, eller tester i kode-repoet som dekker det, nevn dem som ekstra bevis.
3. **Kontroller resultatet** etter *Kontroll*, før du viser det til brukeren.
4. **Vis resultatet** i chat: feature-ID, tittel, sti, og per scenario `funnet` (med `fil:linje` og én setning om hva koden gjør) / `ikke funnet` / `usikker` (med hvorfor). Si hva kontrollen endret. List scenarioene utenfor gating-settet for seg.
5. **Spør én gang per krav** (`AskUserQuestion`, `multiSelect: false`): «Stemmer vurderingen for `<feature-ID> — <tittel>`?»
   - **Stemmer** — vurderingen er riktig.
   - **Noe mangler** — brukeren vet om noe som ikke virker (spør hva i fritekst).
   - **Kunne ikke verifisere** — ikke mulig å avgjøre nå.
   - **Avbryt** — stopp her.
6. **Retagg `@in-progress` → `@implemented`** bare når gating-settet ikke er tomt, **alle** gating-scenarioer er `funnet`, brukeren svarte **Stemmer**, og ingen `@openquestion` står igjen i fila. Én `Edit` på `Egenskap:`-tag-linja; bare statustaggen byttes: `@OPT-SOK-VIS-001 @must @in-progress` → `@OPT-SOK-VIS-001 @must @implemented`. `@draft`- og `@deprecated`-deler står urørt.

Ellers står kravet som `@in-progress`, og det som mangler, kommer i rapporten.

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
- Spørsmålet i steg 5 gjelder delen: «Stemmer vurderingen for `<feature-ID> — <tittel på delen>`?»
- **Når alt er funnet og brukeren svarte Stemmer:** fjern `@in-progress` fra `Regel:`-/`Scenario:`-linja med én `Edit`. Andre tagger på linja står urørt. Blir linja tom, fjern hele linja. Delen arver da `@implemented` fra egenskapen. `Egenskap:`-linja endres ikke.
- Erstatter delen en `@deprecated`-del, verifiser den `@deprecated`-delen i samme kjøring (*Verifisere at koden er borte*). Den nye koden kan være på plass selv om den gamle ikke er fjernet enda, og da blir den `@deprecated`-delen stående.

### Verifisere uansett status

«Verifiser» på en egenskap eller en regel i FS Kravforvaltning ber deg verifisere den *uansett status*. Prompten sier hvilken egenskap eller regel (med linja), og statusen på regelen og egenskapen. Kodeklonene og skjermbildene er som ellers (*Finn scope og kode*).

- **Scope** er egenskapen eller regelen, ikke resten av fila.
- **Gating-sett** = scenarioene i scope, også det som er `@draft` eller `@planned`, minus `@demo`. `@deprecated`-deler følger *Verifisere at koden er borte*.
- Let, kontroller, vis resultatet og spør som i *Verifisere implementasjon*, steg 1–5. Rapporten skrives som ellers (*Rapport*).
- **Ny status tilbys** bare når hele gating-settet er `funnet`, ingen `@openquestion` står igjen i scope, og brukeren svarte **Stemmer**. Spør med `AskUserQuestion` før du endrer: «Alt er funnet. Skal `<feature-ID> — <tittel>` bli levert?» — **Ja** / **Nei**.
  - **Egenskap** med `@draft`, `@planned` eller `@in-progress`: bytt statustaggen på `Egenskap:`-linja med `@implemented`. `@draft`-deler under den står urørt, og er fortsatt ikke levert.
  - **Egenskap** som er `@implemented`: ingen endring. Har den `@draft`-, `@planned`- eller `@in-progress`-deler, si at de verifiseres hver for seg.
  - **Regel** under en `@implemented` egenskap, med `@draft`, `@planned` eller `@in-progress`: fjern statustaggen fra `Regel:`-linja, som i *Deler i leverte krav som endres*. Regelen arver `@implemented`. Erstatter regelen en `@deprecated`-del, verifiser den også.
  - **Regel** uten egen status under en `@implemented` egenskap: den er allerede levert, ingen endring.
  - **Regel** under en egenskap som ikke er `@implemented`: ingen endring. En del kan ikke være levert når egenskapen ikke er det. Si at hele egenskapen må verifiseres.
- Mangler noe, blir statusen stående, og det som mangler, står i rapporten. Bytt aldri en status nedover (f.eks. `@implemented` → `@planned`).

## Verifisere at koden er borte (`@deprecated`)

Ett krav eller én del om gangen:

1. **Let etter spor.** Feature-ID, scenariotitler, tekster fra `Så`-stegene, feltnavn fra tabellene, og navn fra `design.md`/planer (komponenter, ruter, GraphQL-felt, tabeller), etter sjekklista i *Negative søk*. Les treffene, og skill ekte kode fra tilfeldige ordlikheter.
2. **Kontroller resultatet** etter *Kontroll*. «Ingen spor funnet» fører til sletting, så kontrollen er ekstra viktig her.
3. **Vis resultatet**: `finnes fortsatt` (med `fil:linje` og hvorfor du mener det er denne funksjonaliteten) eller `ingen spor funnet` (med hva du og kontrollen søkte etter, og i hvilke repoer).
4. **Ingen spor funnet:** spør (`AskUserQuestion`): «Fant ingen spor av `<feature-ID> — <tittel/del>` i `<repoer>`. Slette kravet?» — **Slett** / **Behold** / **Avbryt**. Ved **Slett**:
   - `@deprecated` på `Egenskap:` → slett fila (`rm "<sti>"`). Blir kapabilitetsmappa tom, si fra (ikke slett mappa).
   - `@deprecated` på `Regel:`/`Scenario:` → fjern blokken med én `Edit`: tag-linja, kommentarene rett over og under nøkkelordlinja, og alt til neste blokk på samme eller høyere nivå. Resten av fila står urørt. Les fila etterpå og sjekk at den fortsatt er gyldig Gherkin.
5. **Finnes fortsatt:** kravet blir stående. Det kommer på lista over `@deprecated` som fortsatt finnes i koden.

## Negative søk

Et søk uten treff er svakt bevis: det kan bety at koden heter noe annet. Før et scenario blir `ikke funnet` (eller en `@deprecated`-del blir `ingen spor funnet`), skal du ha søkt i alt dette, i alle kodeklonene:

1. **Fagbegrepet** fra scenarioet, med og uten æ/ø/å (`søkeord`, `sokeord`, `soekeord`), i entall og flertall.
2. **Kodenavnene** begrepet kan ha: camelCase og snake_case (`studieavgift`, `STUDIEAVGIFT`), engelske navn (`tuition`, `keyword`), og forkortelser.
3. **Tekstene brukeren ser:** oversettelsesfilene (i fs-admin `src/common/messages/**/*.json`). En etikett der leder til komponenten som bruker den.
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

## Etter endringene

- **Foreldreløse step definitions.** For slettede scenarioer: søk i `tester/steps/` etter stegtekstene. Steg som ikke lenger brukes av noen `.feature`-fil, listes. Ikke slett dem.
- **Tester.** Et `@deprecated` scenario som fortsatt har step definitions, vil feile når koden fjernes. Nevn det.

## Rapport

Skriv rapporten i chat, og til fil etter hva scope er. Filnavnet har alltid dato og klokkeslett (`<YYYY-MM-DD>-<HHMM>`, se *Tidspunkt*), så kjøringer samme dag kan sammenlignes og ikke skriver over hverandre:

- **Oppgave eller spesifikasjon:** `<oppgave>/spec/verify-<YYYY-MM-DD>-<HHMM>.md` (`verify-2026-10-09-1432.md`; `-2`, `-3` … hvis fila finnes).
- **Bare en `krav/`-sti:** rett ved siden av det som ble verifisert. For én fil: `verify-<feature-fil>-<YYYY-MM-DD>-<HHMM>.md` i samme mappe som fila, der `<feature-fil>` er filnavnet uten `.feature` (`fjerne_roller.feature` → `verify-fjerne_roller-2026-10-07-0915.md`). For en mappe: `verify-<mappenavn>-<YYYY-MM-DD>-<HHMM>.md` i mappa over, ved siden av mappa (`…/12 Brukeradministrasjon/personbrukere/` → `…/12 Brukeradministrasjon/verify-personbrukere-2026-10-07-0915.md`). `-2`, `-3` … hvis fila finnes. Linja `- **Spec:**` utelates.

Skriv aldri over en tidligere rapport, og endre den ikke: den er det du sammenligner med neste gang.

Skriv aldri rapporten noe annet sted under `krav/`. Ikke kall den `verification-*.md`: det mønsteret er reservert for `<lag>/` (se *Fire regler* i `tasks/README.md`).

FS Kravforvaltning leser `- **Spec:**` og tabellen `## Scenarioer` (én rad per scenario i gating-settet, med `funnet` / `ikke funnet` / `usikker` og beviset), og viser resultatet på kortet i Spesifikasjoner. Hold formatet nøyaktig: Feature-ID med `@`, scenariotittelen slik den står i fila, og `Resultat` med små bokstaver. Resultatet i tabellen er resultatet etter kontrollen.

**Tall regnes ut, de telles ikke.** Alle tall i rapporten (scenarioer funnet per krav, i alt, og i *Oppsummering*) regnes ut fra tabellen `## Scenarioer` og fra endringene du har gjort, f.eks. med `awk` på rapportfila når du har Bash. Uten Bash: tell radene i tabellen én gang til, krav for krav, før du skriver tallene.

`- **Kontroll:**` sier hvem som kontrollerte: `fs-verify-kontroll` (uavhengig) eller `manuell (Claude-panelet)`. `## Kontroll` lister radene der kontrollen endret resultatet, så leseren ser hva den første letingen bommet på.

**`utforing.md`.** Når scope er en spesifikasjon som er sendt (har en seksjon i `<oppgave>/utforing.md`, se *Utføring* i `tasks/README.md`): mangler noe (`ikke funnet` eller `usikker`, og brukeren svarte «Noe mangler»), sett steget i repoet der koden mangler, tilbake til `- **Status**: pågår`, legg til `- **Tilbake**: <YYYY-MM-DD>`, og en linje i `Logg` (`<dato> — fs-verify — <n> ikke funnet, <n> usikker · tilbake til <repo>`). Er alt funnet, legg bare til en linje i `Logg` (`alt funnet · verifisert`); kortet står i «Verifisert» når kravene er `@implemented`.

```markdown
# Verifisering: <scope>

- **Dato:** YYYY-MM-DD HH:MM
- **Krav:** `<krav-sti eller oppgave>`
- **Spec:** `spec/spec-<x>.md` (bare når scope er en spesifikasjon)
- **Kode:** `<repo 1>`, `<repo 2>`
- **Kontroll:** `fs-verify-kontroll` | manuell (Claude-panelet)

## Oppsummering

- Retagget `@in-progress` → `@implemented`: N
- Deler i leverte krav som er levert (`@in-progress` fjernet): N
- Fortsatt `@in-progress`: N
- Slettet (`@deprecated`): N filer, N regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: N

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | funnet | `<repo>/<fil>:<linje>` |
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | ikke funnet | <hva det ble søkt etter> |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@DOM-SUB-KAP-NNN` | <scenariotittel> | ikke funnet | usikker | `<repo>/<fil>:<linje>` — <hva kontrollen fant> |

(«Kontrollen endret ingen resultater» når tabellen er tom.)

## Retagget til @implemented

| Feature-ID | Egenskap | Fil | Gating funnet |
| --- | --- | --- | --- |

## Deler levert

| Feature-ID | Del | Fil | Gating funnet |
| --- | --- | --- | --- |

## Fortsatt @in-progress

- **`<feature-ID>` — <tittel>**: <scenario> — ikke funnet / usikker / brukeren: «…»

## Slettet

- `<fil>` (hele kravet)
- `<fil>` — regel/scenario `<tittel>`

## @deprecated som fortsatt finnes i koden

- **`<feature-ID>` — <tittel/del>** (`<fil>`)
  - `<repo>/<fil>:<linje>` — <hva som finnes>

## Oppfølging

- Step definitions som ikke lenger brukes: `tester/steps/<fil>.ts:<linje>` — «<steg>»
- Krav utenfor scope: <fil> (`@draft`/`@planned`) — <henvisning>
```

## Git

Ikke `git add`, `commit`, `push`, `checkout` eller `stash` i noe repo. Lesende git-kommandoer (`git -C <repo> log`, `grep`, `ls-files`) er lov. Brukeren commiter endringene i `krav/`, eller lager PR med «Lag PR» i FS Kravforvaltning.

## Referanser

- **`krav/README.md`** — statusaksen, *Delvis utkast* og *Avvikling*.
- **[`tasks/README.md`](../../../tasks/README.md)** — oppgavestrukturen og reglene for `spec/`.
- **`fs-krav`** — setter `@deprecated` når et levert krav skal fjernes.
- **`fs-specify` / `fs-specify-delta`** — setter `@in-progress`, på egenskaper og på deler i leverte krav som endres.
- **`.claude/agents/fs-verify-kontroll.md`** — kontrolløren som sjekker resultatene uavhengig (*Kontroll*).
