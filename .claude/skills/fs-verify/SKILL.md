---
name: fs-verify
description: Verifiserer krav mot koden i dette repoet. Tar en `krav/`-sti, et scope (`@scope-<slug>`) eller en oppgave (`tasks/<domene>/<slug>`) og lokale kloner av kode-repoene. Spør først hva som skal verifiseres (`@in-progress`, `@deprecated`, flyter, alle krav uansett status, eller noe annet), og hvor mange nivåer med `@depends-on-` som skal følges, med status fra taggene eller verifisert i koden (avhengighetene retagges aldri). For hvert `@in-progress`-krav leter skillen etter implementasjonen av hvert scenario i koden, får resultatet kontrollert (av subagenten `fs-verify-kontroll` når Agent-verktøyet finnes, ellers manuelt), viser bevis (`fil:linje`), og retagger `@in-progress` → `@implemented` på `Egenskap:`-linja når alt er funnet og brukeren bekrefter. En `@in-progress`-del (`Regel:`/`Scenario:`) i et levert krav som endres, verifiseres på samme måte, og da fjernes `@in-progress` fra delen. Er noe av et krav levert, men ikke alt, blir egenskapen `@in-progress` og de leverte delene `@implemented` (delvis levert). Gis en verify-rapport (`verify-*.md`), går skillen gjennom resultatene med brukeren: usikre og ikke funne scenarioer, delvis leverte krav, og åpne spørsmål (`@openquestion` fjernes når svaret ikke endrer kravet, ellers foreslås `fs-krav`), og skriver en ny rapport. For hvert `@deprecated`-krav (egenskap eller `Regel:`/`Scenario:`) leter skillen etter spor i koden. Er koden borte og brukeren bekrefter, slettes fila eller blokken, sammen med referansene (`@depends-on-`, `@ref-`) til kravet; finnes den fortsatt, listes stedene. Verifiserer også flyter i `krav/_Flyter/`: fremdriften fra kravene fasene bygger på, og at overleveringene mellom kravene virker i koden (stedet der tilstanden lages og stedet der den brukes), og gir flyten `@planned` → `@implemented`. Skriver rapporten til fil før den spør (i chat står bare et sammendrag, og hvert oppfølgingsspørsmål har med referansene det gjelder: `krav/…:linje` og `<repo>/<fil>:<linje>`), i `tasks/<domene>/<slug>/spec/verify-<YYYY-MM-DD>-<HHMM>.md` når en oppgave er gitt, ellers rett ved siden av kravet som `verify-<feature-fil>-<YYYY-MM-DD>-<HHMM>.md` (eller `verify-<mappenavn>-<YYYY-MM-DD>-<HHMM>.md` for en hel mappe), og i `akseptansetest/<scope-slug>/` for et scope, med tidspunkt så kjøringer kan sammenlignes. Er fase 1 i teststrategien (forslag): kravene sjekkes mot koden (white-box, ingenting kjøres), og rapporten er grunnlaget for testplanen (`fs-testplan`). Verifiserer også på kodenivå at roller og tilganger er implementert slik kravet sier (tester dem ikke), og datakonsistensen, og rapporterer regler i koden som ikke har et scenario i kravet, og antall åpne spørsmål per krav. `@implemented` betyr bare at koden er funnet. Tar også en testplan (`akseptansetest/<slug>`) som scope når verifiseringen kjøres på nytt, og spør da etter rapporten om resultatet skal legges som en underside til testplanen i Confluence. Kjører aldri git add/commit/push. Trigges av "verifiser kravene", "er kravene implementert", "tagg kravene som implementert", "sjekk om deprecated-krav kan slettes", "rydd i deprecated", "finnes koden fortsatt", "verifiser testplanen", "legg verifiseringen i Confluence", "verifiser flyten", "virker overleveringene", "sjekk tilgangsstyringen i koden", "regler uten scenario", "gå gjennom verify-rapporten", "forbedre verifiseringen", "avklar åpne spørsmål i verifiseringen", "delvis levert", "fs-verify".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
---

# Verify

## Task

$ARGUMENTS

## Din rolle

Du sammenligner kravene med koden, og lukker løkka tilbake til kravene. Du eier to steg på statusaksen i `krav/README.md`:

`@in-progress` →(**`fs-verify`**)→ `@implemented` →(`fs-krav`)→ `@deprecated` →(**`fs-verify`**)→ slettet

Hva du verifiserer, og hvor langt du følger `@depends-on-`, spør du om først (*Omfang og avhengigheter*). Ber brukeren om å verifisere *uansett status* («Verifiser» i FS Kravforvaltning, eller valget *alle krav uansett status*), kan du også gi `@draft` og `@planned` statusen `@implemented`. Se *Verifisere uansett status*.

En flyt i `krav/_Flyter/` går `@planned` →(**`fs-verify`**)→ `@implemented`, uten `@in-progress`. Se *Verifisere flyt*.

Er noe av et krav levert, men ikke alt, blir egenskapen `@in-progress` og delene som er levert, `@implemented` (*Delvis levert*). Gir brukeren en verify-rapport, går du gjennom resultatene i den sammen med brukeren (*Gjennomgang av en verify-rapport*): det som er usikkert eller ikke funnet, delvis leverte krav og åpne spørsmål.

Verifiseringen er fase 1 i [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326): white-box, der koden leses og sammenlignes med scenarioene, og ingenting kjøres. Den sier ikke om løsningen virker for brukeren. `@implemented` betyr bare at koden er funnet, og om leveransen er godkjent, står i sluttrapportene fra testene. Verifiseringen kommer i tillegg til teamets vanlige kvalitetssikring (enhetstester, automatiske tester i CI og universell utforming), og erstatter den ikke. I tillegg til scenarioene sjekker du tre ting som rapporten gir videre til testplanen: at roller og tilganger er implementert i koden, og datakonsistensen (*Tilgang og datakonsistens*), regler i koden uten scenario i kravet (*Regler uten scenario*, også input til den agentiske testen i fase 2), og de åpne spørsmålene (*Åpne spørsmål*), som ikke stopper leveransen, men nevnes i testplanen.

- **Ikke skriv eller rett applikasjonskode.** Mangler noe, rapporterer du det.
- **Ikke endre kravinnhold.** Du bytter bare statustaggen på `Egenskap:`-linja, fjerner `@in-progress` fra deler i leverte krav som endres, setter og fjerner `@implemented` på deler (*Delvis levert*), sletter filer eller blokker som er `@deprecated`, og fjerner referansene (`@depends-on-`, `@ref-`) til det du sletter. I *Gjennomgang av en verify-rapport* kan du også legge til eller fjerne `@openquestion` med `# ÅPNE SPØRSMÅL:`. Steg, titler og tabeller endres bare med `fs-krav`.
- **Påstå aldri mer enn du har sett.** Bevis er et konkret sted i koden (`fil:linje`) som du har lest. Et søk uten treff er ikke bevis for at koden er borte, bare at du ikke fant den. Derfor bekrefter brukeren alle retagginger og slettinger.

## I FS Kravforvaltning

I Claude-panelet i FS Kravforvaltning har du ikke Bash:

- Kodeklonene (fs-admin, fs-plattform, min-kompetanse) står i systemprompten. Bruk dem i stedet for å spørre, og spør bare hvis de mangler.
- `AskUserQuestion` virker: brukeren får spørsmålet som et kort med valgene. Hopper brukeren over, still spørsmålet i svaret, og vent på brukeren.
- Du kan ikke slette filer. Skal en `@deprecated`-fil slettes, si hvilken, så sletter brukeren den selv. Blokker fjernes med `Edit`.
- Lesende git går ikke. Bruk `Grep` og `Glob` i klonene. Branchene i kravrepoet og klonene blir derfor ikke sjekket mot origin (*Sjekk branchen*): skriv `ikke sjekket (Claude-panelet)` i `- **Kode:**` i rapporten. Åpne MR-er og brancher (*Åpne MR-er og brancher*) kan heller ikke sjekkes: skriv `ikke sjekket (Claude-panelet)` i `- **Åpne MR-er:**`.
- Skjermbilder tas med chrome-devtools-MCP. `navigate_page`, `click` og `press_key` er godkjent på forhånd når fs-verify kjøres, sammen med verktøyene som bare leser (`take_screenshot`, `take_snapshot`, `wait_for` …). Andre kall, f.eks. `new_page` og `fill`, må godkjennes i panelet (se *Skjermbilder*).
- Du har ikke Agent-verktøyet, så du kan ikke starte kontrolløren (`fs-verify-kontroll`). Du gjør kontrollen selv (*Kontroll*), og den er ikke uavhengig. **Si det til brukeren før du begynner å lete**, med denne setningen: «Kontrollen av resultatene gjøres manuelt i Claude-panelet: jeg sjekker mine egne funn, uten en uavhengig kontrollør. Les bevisene i rapporten før du sier ja til endringene. Vil du ha uavhengig kontroll, kjør Verifiser i terminalen.» Skriv `- **Kontroll:** manuell (Claude-panelet)` i rapporten.

I terminalen i FS Kravforvaltning («Verifiser i terminal …») og i Claude Code i terminalen har du Agent-verktøyet, og kontrolløren kjøres som vanlig.

## Finn scope og kode (gjør dette FØRST)

0. **Sjekk branchen** i dette repoet mot origin og main, som beskrevet i [`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md). Er den bak, spør før du henter.
1. **Krav.** Oppga brukeren en verify-rapport (`verify-*.md`), følg *Gjennomgang av en verify-rapport* i stedet for resten av denne lista. Oppga brukeren en spesifikasjon (`tasks/<domene>/<slug>/spec/spec-*.md`, typisk fra «Verifiser» på tavla «Oppgaver» i FS Kravforvaltning), er scope bare feature-filene under `## Krav` i den (slått opp på feature-ID). Oppga brukeren et scope (`scope-<slug>`, `@scope-<slug>` eller `tasks/<domene>/scope-<slug>.md`), er scope alle kravene og delene med taggen `@scope-<slug>`, funnet og sjekket mot scope-tabellen som i *Scope* i [`.claude/references/akseptansetest/krav-fra-testplan.md`](../../references/akseptansetest/krav-fra-testplan.md). Oppga brukeren en testplan (`akseptansetest/<slug>`, eller `testplan.md` i den), er scope kravene i «Omfang» og «Venter på verifisering» i testplanen, slått opp på Feature-ID (*Kravene i de andre skillene* i [`.claude/references/akseptansetest/krav-fra-testplan.md`](../../references/akseptansetest/krav-fra-testplan.md)). Oppga brukeren en `krav/`-sti (fil eller mappe), bruk den. En sti under `krav/_Flyter/`, eller en `@FLY-`-ID, er en flyt (*Verifisere flyt*). Et scope, en oppgave eller en testplan tar også med flytene som går gjennom kravene, funnet som i *Finn flytene* i [`.claude/references/akseptansetest/krav-fra-testplan.md`](../../references/akseptansetest/krav-fra-testplan.md) (for en testplan: flytene i «Flyter»), så testplanen kan bygge på resultatet. En spesifikasjon tar dem ikke med: der er en flyt bare med når den er valgt selv. Oppga brukeren en oppgave (`tasks/<domene>/<slug>`, eller bare slug — slå opp med `Glob` `tasks/*/<slug>/`), les Feature-ID-ene fra `## Krav` i alle `<oppgave>/spec/spec-*.md` (ikke det som står under *Utenfor scope*), og finn de autoritative filene under `krav/` på feature-ID (`@DOM-SUB-KAP-NNN`), ikke filnavn. Les ikke kopiene i `spec/krav-input/`: de finnes bare i eldre oppgaver, og kan være utdaterte. 0 treff → «ikke funnet under krav/», mer enn 1 → «duplisert feature-ID». Mangler begge, spør.
2. **Kode.** Spør (`AskUserQuestion`) om stien til de lokale klonene av kode-repoene (se *Kodeklonene*). Foreslå repoer fra `oppgave.md` (lenker), `<lag>/plan-*.md` og `<lag>/task-*-completion.md` når en oppgave er gitt. Sjekk at stiene finnes, og sjekk branchen i hver klone ([`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md)): det er koden på branchen som verifiseres. Uten kode kan ingenting verifiseres: stopp og si det. Skriv aldri `.claude/spec.local.md`.
2b. **Åpne MR-er og brancher.** Finn MR-ene og branchene i hver klone som kan inneholde koden for kravene i scope (*Åpne MR-er og brancher*). Det gjøres uten spørsmål, og resultatet står i rapporten.
3. **Omfang og avhengigheter.** Spør hva som skal verifiseres, og hvor langt `@depends-on-` skal følges (*Omfang og avhengigheter* under). Spørsmålene stilles i ett `AskUserQuestion`-kall, sammen med spørsmålet om skjermbilder (steg 4) når det også skal stilles.
4. **Skjermbilder.** Har prompten ikke sagt om det skal tas skjermbilder («Ta skjermbilder» eller «Ingen skjermbilder»), spør med `AskUserQuestion` før du begynner å lete: «Skal jeg ta skjermbilder fra https://test-fsadmin.sikt.no/?», med valgene «Ja» og «Nei». Hopper brukeren over, regn det som «Nei», og si det i rapporten. Se *Skjermbilder*.
5. **Hint.** Når en oppgave er gitt: les `design.md`, `<lag>/plan-*.md` og `<lag>/task-*-completion.md`. Filstier, komponentnavn, GraphQL-felt og ruter derfra er de beste stedene å lete.
6. **Tidspunkt.** Ta tidspunktet for kjøringen nå (*Tidspunkt*), og si det til brukeren sammen med navnet rapporten får.

### Kodeklonene

Hvert kode-repo har en bokstav som brukes i `Bevis` i rapporten (se `references/rapportmal.md`). I rapporten skrives repoene med navn, ikke som lag (ikke «backend» eller «frontend»):

| Repo | Bokstav | Hva det dekker |
| --- | --- | --- |
| `fs-plattform` | P | API (GraphQL-subgrafene), tjenestene og databasen |
| `fs-admin` | A | Det saksbehandlere og forvaltere ser og gjør |
| `min-kompetanse` | M | Det søkeren ser og gjør: søknaden, Min kompetanse |

Let etter hvert scenario i repoet det gjelder: et scenario der søkeren ser eller gjør noe, finnes i min-kompetanse (og i fs-plattform), ikke i fs-admin. Mangler klonen et scenario trenger, er det repoet ikke sjekket: skriv det under *Ikke sjekket* i `## Oppfølging`, og resultatet er `usikker`, ikke `ikke funnet`.

### Omfang og avhengigheter

Skillen brukes ofte til å sjekke om en oppgave er levert, ikke bare til å flytte `@in-progress` → `@implemented`. Spør derfor hva som skal verifiseres, og hvor langt avhengighetene skal følges, før du leter. Still spørsmålene i ett `AskUserQuestion`-kall (høyst 4 spørsmål, også spørsmålet om skjermbilder):

1. **«Hva skal verifiseres?»** (`multiSelect: true`). Si i spørsmålet at standarden er de tre første.
   - **`@in-progress`**: egenskaper, og deler i leverte krav som endres (*Verifisere implementasjon*).
   - **`@deprecated`**: at koden er borte (*Verifisere at koden er borte*).
   - **Flyter**: flytene i scope, og flytene som går gjennom kravene (*Verifisere flyt*).
   - **Alle krav uansett status**: *Verifisere uansett status* for hver egenskap i scope, også `@draft`, `@planned` og `@implemented`.

   I «Annet» kan brukeren skrive noe annet, for eksempel bare én regel, bare det som er `@implemented` (for å se om noe har falt bort), eller én feature-ID. Tolk svaret, og si hva du har forstått før du leter. Hopper brukeren over, gjelder standarden, og det står i `- **Omfang:**` i rapporten.
2. **«Hvor mange nivåer med `@depends-on-` skal følges?»** — **1 nivå: de direkte avhengighetene** (anbefalt) / **Ingen** / **2 nivåer** / **Alle nivåer**. Et annet tall kan skrives i «Annet». Hopper brukeren over, gjelder 1 nivå.
3. **«Skal avhengighetene letes etter i koden?»** — **Nei, bare status fra taggene** (anbefalt) / **Ja, verifiser dem i koden**. Svaret brukes ikke når svaret på spørsmål 2 er «Ingen». Hopper brukeren over, gjelder «bare status».

**Spør ikke om det prompten allerede svarer på:**

- Ber prompten om å verifisere en egenskap eller en regel *uansett status* («Verifiser» i feature-visningen i FS Kravforvaltning), er omfanget *Verifisere uansett status* for den egenskapen eller regelen. Spørsmål 1 stilles ikke.
- Er scope en spesifikasjon («Verifiser» på tavla «Oppgaver»), er omfanget `@in-progress` og `@deprecated`. En spesifikasjon tar ikke med flytene (*Finn scope og kode*, steg 1). Spørsmål 1 stilles ikke.
- Sier prompten hva som skal verifiseres, eller hvor mange nivåer («Avhengigheter: 1 nivå, bare status»), stilles ikke det spørsmålet.

Ellers stilles spørsmål 2 og 3 alltid, også når spørsmål 1 ikke stilles. Svarene står i `- **Omfang:**` og `- **Avhengigheter:**` i rapporten, og i `started`-linja i loggen.

## Logg kjøringen

Når en oppgave er gitt, skrives én `started`-linje og én `ended`-linje til `<oppgave>/spec/spec.log.md`, i formatet fra [`fs-specify` → *Logg kjøringen*](../fs-specify/SKILL.md#logg-kjøringen-gjør-dette-andre). Bruk bare Read og Write.

```
- 2026-09-29 — `fs-verify` started — 3 @in-progress, 2 @deprecated · omfang: @in-progress, @deprecated · avhengigheter: 1 nivå, bare status
- 2026-09-29 — `fs-verify` ended (success) — 2 retagget @implemented, 1 fil og 1 regel slettet, 1 @deprecated finnes fortsatt i koden
```

`AskUserQuestion`-kall logges til `<oppgave>/spec/questions-fs-verify-<YYYY-MM-DD>.md` etter [`fs-specify/references/askuserquestion-logging.md`](../fs-specify/references/askuserquestion-logging.md). Uten oppgave logges ingenting til fil.

## Klassifiser

Les hver `.feature`-fil i scope og sorter:

| Funn | Håndtering |
|------|------------|
| `@in-progress` på `Egenskap:` | *Verifisere implementasjon* (også når noen deler er `@implemented`, *Delvis levert*) |
| `@deprecated` på `Egenskap:` | *Verifisere at koden er borte* (hele fila) |
| `@deprecated` på `Regel:`/`Scenario:` (under `@implemented` eller `@in-progress`) | *Verifisere at koden er borte* (blokken) |
| `@in-progress` på `Regel:`/`Scenario:` (under `@implemented`) | *Verifisere implementasjon* (delen), se *Deler i leverte krav som endres* |
| `@planned` på `Regel:`/`Scenario:` (under `@implemented`) | Ikke hentet inn i en oppgave — rapporter, og henvis til `fs-specify` |
| `@implemented` uten `@in-progress`-, `@planned`- eller `@deprecated`-deler | Allerede levert — rapporter, ingen endring |
| `@draft`, `@planned`, ingen status | Ikke klar for verifisering — rapporter, og henvis til `fs-krav` / `fs-specify`. Med *alle krav uansett status*: *Verifisere uansett status* |
| To statustagger på `Egenskap:` | Stopp for denne fila og rapporter |
| Flyt (`krav/_Flyter/`) med `@planned` eller `@in-progress` | *Verifisere flyt* |
| Flyt med `@draft` | Bare fremdriften (*Verifisere flyt*, steg 1). Henvis til `fs-krav` for validering |

Tabellen gjelder det som er valgt i *Omfang og avhengigheter*. En rad som ikke er valgt (f.eks. `@deprecated` når bare `@in-progress` er valgt), verifiseres ikke, og står i oversikten og i `## Oppfølging` som «ikke valgt i denne kjøringen». Er *alle krav uansett status* valgt, eller ber prompten om å verifisere *uansett status*, gjelder ikke tabellen for egenskapene og reglene i scope: se *Verifisere uansett status*.

Vis oversikten til brukeren før du gjør noe, med avhengighetene (*Avhengigheter*) når de skal følges.

## Verifisere implementasjon (`@in-progress`)

**Gating-sett** = alle `Scenario:`/`Scenariomal:` under `Egenskap:`, minus de som er (selv eller via `Regel:`) tagget `@draft`, `@deprecated` eller `@demo`. En del med bare `@openquestion` (uten `@draft`) er med: den er klar til implementasjon (*Oppfølging* i `krav/README.md`), og skal finnes i koden. `Bakgrunn:` er ikke et eget punkt. Den samme definisjonen står i `gating` i `fs-kravforvaltning/src/specboard.ts` (fremdriften på kortene i Spesifikasjoner); endres den ene, endres den andre i samme endring.

For hvert krav:

1. **Let etter hvert gating-scenario i koden.** Bruk hintene fra oppgaven, og søk etter begreper fra scenarioet (tekster i `Så`-stegene, feltnavn i tabellene, handlingen i `Når`). Les treffene. Et scenario er **funnet** når koden du har lest, gjør det scenarioet beskriver. En `Scenariomal:` er funnet når alle radene i `Eksempler:` er dekket. Før du skriver `ikke funnet`, følg *Negative søk*.
2. **Se etter tester.** Finnes step definitions i `tester/steps/` for scenarioet, eller tester i kode-repoet som dekker det, nevn dem som ekstra bevis i chat. De står ikke i rapporten.
3. **Kontroller resultatet** etter *Kontroll*, før du viser det til brukeren.

Spør ikke underveis. Når alle kravene i scope er kontrollert, går du videre til *Rapport og endringer*: rapporten skrives til fil før du spør.

**Kan leveres** når gating-settet ikke er tomt, **alle** gating-scenarioer er `funnet` etter kontrollen. Tilgangsavvik (*Tilgang og datakonsistens*) og regler uten scenario hindrer ikke forslaget, men står i spørsmålet. Åpne spørsmål stopper ikke leveransen: `@openquestion` på et scenario i gating-settet står i `## Oppfølging` med spørsmålet, og `@draft @openquestion`-deler er ikke levert (de er utenfor gating-settet). Retaggingen er én `Edit` på `Egenskap:`-tag-linja; bare statustaggen byttes: `@OPT-SOK-VIS-001 @must @in-progress` → `@OPT-SOK-VIS-001 @must @implemented`. `@draft`- og `@deprecated`-deler står urørt.

Ellers står kravet som `@in-progress`, og det som mangler, står i rapporten. Er noe av kravet funnet, foreslår du `@implemented` på delene som er levert (*Delvis levert*).

### Delvis levert

Er noen av scenarioene i gating-settet `funnet` etter kontrollen, men ikke alle, er kravet delvis levert (*Delvis levert* i `krav/README.md`):

- **Egenskapen** blir `@in-progress`. Var den `@draft` eller `@planned` (bare med *uansett status*), byttes statustaggen. Er kravet ikke i en spesifikasjon, står det i `## Oppfølging`: «delvis levert, men ikke i en spesifikasjon — hent det inn med `fs-specify`».
- **Delene som er levert,** får `@implemented`: på `Regel:` når alle gating-scenarioene i regelen er `funnet`, ellers på hvert scenario som er `funnet`. Har et scenario `@implemented` fra før under en regel som nå blir `@implemented`, fjernes det fra scenarioet. Andre tagger på linja står urørt.
- **Delene som ikke er levert,** får ingen statustag. I *Gjennomgang av en verify-rapport* spør du om de skal bygges, eller om de er uklare og skal få `@openquestion`.
- `@draft`-, `@deprecated`- og `@demo`-deler står urørt.
- **Når hele gating-settet er funnet,** blir egenskapen `@implemented`, og `@implemented` fjernes fra alle delene i samme endring (*Kan leveres*).
- En `@implemented` egenskap settes aldri tilbake til `@in-progress`. Mangler noe der, står det i `## Oppfølging`.

Delvis levert står i forslaget under *Delvis levert*, og gjøres bare når brukeren har sagt ja (*Rapport og endringer*).

### Skjermbilder

Skjermbilder av appen som kjører, er ekstra bevis for scenarioer som har en skjerm (lister, skjemaer, detaljsider). De erstatter ikke `fil:linje`: et scenario er fortsatt `funnet` bare når du har lest koden.

1. **Bare når brukeren har sagt ja** (*Finn scope og kode*, steg 4). Adressen er alltid `https://test-fsadmin.sikt.no/`. Spør ikke om den.
2. **Bruk chrome-devtools-MCP** (`navigate_page` i siden som er åpen, `click`, `press_key` og `take_screenshot`, som er godkjent på forhånd i FS Kravforvaltning; `new_page` bare når det ikke finnes noen side). Finnes den ikke, si at brukeren må legge den til og starte den én gang med den lokale Claude Code-CLI-en i terminalen: `claude mcp add --scope user chrome-devtools -- npx chrome-devtools-mcp@latest`. Bruk navnet `chrome-devtools`, for det er navnet FS Kravforvaltning tar med. Gå videre uten skjermbilder. Avviser brukeren et kall, prøv ikke igjen uten å spørre. Krever appen innlogging, be brukeren logge inn i nettleservinduet chrome-devtools åpner, og vent.
3. **Ta ett skjermbilde per scenario** som har en skjerm. Gjør det som står i `Gitt`/`Når` så langt det går uten å endre data, og ta bildet av det `Så` beskriver. Endrer et scenario data (opprette, endre, slette), ta bare bildet av skjemaet eller siden før handlingen, og si det.
4. **Lagre bildet** når en oppgave er gitt, som `<oppgave>/spec/verify-<YYYY-MM-DD>-<HHMM>/<NN>-<scenario-kebab>.png` (`NN` = to sifre; mappa har samme navn som rapporten, uten `.md`, også med `-2`-suffiks):
   - I FS Kravforvaltning: `take_screenshot` uten `filePath`, og rett etter `mcp__kravforvaltning__save_sketch` med `path` (uten `tool_use_id` lagres det siste bildet).
   - I terminalen: `take_screenshot` med `filePath` satt til stien.

   Uten oppgave lagres ingenting. Vis bildet i chat og si hva det viser.
5. **Lenk bildet** fra `Bevis`-kolonnen i `## Scenarioer`, etter `fil:linje`: `` `<repo>/<fil>:<linje>` · [skjermbilde](verify-<YYYY-MM-DD>-<HHMM>/<NN>-<scenario-kebab>.png) ``. Viser skjermbildet noe annet enn scenarioet sier, er scenarioet `usikker`, og avviket står i beviset.

### Deler i leverte krav som endres

Når et levert krav endres, står egenskapen som `@implemented`, og statusen på delen (se *Endring av levert krav* i `krav/README.md`). En `@in-progress`-del verifiseres som et krav, med disse forskjellene:

- **Gating-sett** = scenarioene i delen (for en `Regel:`: alle scenarioene under den), minus de som er tagget `@demo`. `@openquestion` på et scenario i delen står i `## Oppfølging`, som for et krav.
- I forslaget og spørsmålene står delen med tittel: `<feature-ID> — Regel: <tittel>`.
- **Når delen kan leveres og brukeren har sagt ja:** fjern `@in-progress` fra `Regel:`-/`Scenario:`-linja med én `Edit`. Andre tagger på linja står urørt. Blir linja tom, fjern hele linja. Delen arver da `@implemented` fra egenskapen. `Egenskap:`-linja endres ikke.
- Erstatter delen en `@deprecated`-del, verifiser den `@deprecated`-delen i samme kjøring (*Verifisere at koden er borte*). Den nye koden kan være på plass selv om den gamle ikke er fjernet enda, og da blir den `@deprecated`-delen stående.

### Verifisere uansett status

«Verifiser» på en egenskap eller en regel i FS Kravforvaltning ber deg verifisere den *uansett status*. Prompten sier hvilken egenskap eller regel (med linja), og statusen på regelen og egenskapen. Kodeklonene og skjermbildene er som ellers (*Finn scope og kode*). Det samme gjelder når brukeren har valgt *alle krav uansett status* i *Omfang og avhengigheter*: da verifiseres hver egenskap i scope på denne måten.

- **Scope** er egenskapen eller regelen, ikke resten av fila. Er *alle krav uansett status* valgt, er scope hver egenskap i scope, med alle reglene.
- **Gating-sett** = scenarioene i scope, også det som er `@draft` eller `@planned`, minus `@demo`. `@deprecated`-deler følger *Verifisere at koden er borte*.
- Let og kontroller som i *Verifisere implementasjon*, steg 1–3. Rapporten og spørsmålet kommer etterpå (*Rapport og endringer*).
- **Ny status foreslås** bare når hele gating-settet er `funnet`. `@openquestion` i scope står i `## Oppfølging`, og stopper ikke den nye statusen. Endringen gjøres bare når brukeren har sagt ja (*Rapport og endringer*):
  - **Egenskap** med `@draft`, `@planned` eller `@in-progress`: bytt statustaggen på `Egenskap:`-linja med `@implemented`, og fjern `@implemented` fra delene. `@draft`-deler under den står urørt, og er fortsatt ikke levert.
  - **Egenskap** som er `@implemented`: ingen endring. Har den `@draft`-, `@planned`- eller `@in-progress`-deler, si at de verifiseres hver for seg. Mangler et scenario som er levert, står det i `## Oppfølging` som «levert, men ikke funnet i koden», så teamet kan se på det.
  - **Regel** under en `@implemented` egenskap, med `@draft`, `@planned` eller `@in-progress`: fjern statustaggen fra `Regel:`-linja, som i *Deler i leverte krav som endres*. Regelen arver `@implemented`. Erstatter regelen en `@deprecated`-del, verifiser den også.
  - **Regel** uten egen status under en `@implemented` egenskap: den er allerede levert, ingen endring.
  - **Regel** under en egenskap som ikke er `@implemented`: ingen endring. En del kan ikke være levert når egenskapen ikke er det. Si at hele egenskapen må verifiseres.
- Mangler noe, blir statusen stående, og det som mangler, står i rapporten. Er noe av en egenskap som ikke er `@implemented`, funnet, foreslår du *Delvis levert*. Bytt aldri en status nedover (f.eks. `@implemented` → `@planned`).

## Verifisere flyt

En flyt (`krav/_Flyter/`, se *Flyter* i `krav/README.md`) beskriver et løp på tvers av domener. Hver `Regel:` er en fase, og `@depends-on-` på fasen peker på kravene den bygger på. Flyten har to statuser: fremdriften, som kommer fra kravene, og sin egen status, som sier at overleveringene mellom kravene virker. Testene for hvert krav setter opp tilstanden selv, så de kan gå grønt selv om det ene kravet aldri får det det andre lager. Det er det du ser etter her.

1. **Fremdrift.** For hver fase: slå opp hver `@depends-on-<ID>` (`Grep "^\s*@(.*\s@)?<ID>\b"` i `krav/**/*.feature`), finn delen fasen bygger på, og les statusen på den. Delen er regler og scenarioer i kravet med `@ref-<flytens ID>` (ankeret) som ligger i reglene i «…» i kommentaren under taggen i fasen (et scenario hører til regelen over). Står det ingen regeltitler fra kravet i «…», eller ligger ingen av ankrene i dem, er delen alle ankrene. Uten anker er delen reglene i «…» (alle, når det står flere), ellers hele kravet (*Anker* og *Flyter* i `krav/README.md`). Bygger flere faser på samme krav, er det «…» som skiller hvilke av ankrene hver fase venter på. Fasen er levert når delen av hvert krav er levert (for en `@depends-on-FLY-…`: når den flyten er `@implemented`). Hele kravet er levert når det er `@implemented`. En del er levert når kravet er `@in-progress` og delen er `@implemented` (en regel: alle scenarioene i den), eller når kravet er `@implemented` og delen ikke er `@planned` eller `@in-progress`. En `@draft`- eller `@deprecated`-del blir ikke levert: står ankeret på en slik del, er fasen ikke levert, og det står i `## Oppfølging`. Med flere deler med ankeret må alle være levert. En fase uten `@depends-on-` er `mangler krav`. Dette leser bare tagger, og endrer ingenting.
2. **Overleveringene.** Gating-settet er som i *Verifisere implementasjon*. Et scenario i en fase som ikke er levert (eller mangler krav), er `ikke funnet` uten søk, med «fasen er ikke levert» i `Bevis`: det er ingenting å finne før kravene er levert, og testplanen leser grunnen derfra. For de andre scenarioene: finn i koden både stedet der tilstanden i `Gitt` lages, og stedet der den brukes til det `Så` sier. Scenarioet er **funnet** bare når du har lest begge (to `fil:linje`, i samme repo eller i forskjellige), og det som brukes, er det samme som det som lages: samme tabell, felt, hendelse eller API. At kravene i fasene er levert hver for seg, er ikke bevis. Eksempel: tilbudsgarantien lages i tidligopptaket, men plasstildelingen i hovedopptaket leser den ikke. Da er scenarioet `ikke funnet`, selv om begge kravene er `@implemented`. *Negative søk* og *Kontroll* gjelder som ellers. Finnes en `@e2e`-test for flyten, nevn den i chat.
3. **Ny status** foreslås bare når alle fasene er levert og hele gating-settet er `funnet`: `@planned` eller `@in-progress` → `@implemented` på `Egenskap:`-linja, når brukeren sier ja (*Rapport og endringer*). Er en fase ikke levert, står flyten under *Blir stående*, med fasene som mangler. Mangler en overlevering i en levert fase, foreslå i `## Oppfølging` at bruddet skrives som kjent brudd i flyten med `fs-krav` (modus E). Du skriver ikke kommentaren selv.

Rapporten får `## Fremdrift for flyter` (se `[flyt]` i [`references/rapportmal.md`](references/rapportmal.md)), og scenarioene står i `## Scenarioer` med begge bevisene.

## Tilgang og datakonsistens

CRUD, tilgangsstyring og datakonsistens verifiseres bare her, på kodenivå. Du tester ikke rollene: du verifiserer i koden at rollene og tilgangene er implementert slik kravet sier, så opprette, lese, endre og slette potensielt er riktig. Den agentiske funksjonstesten (fase 2) tester ikke tilgang, og den interne testen gjør det heller ikke, så det du ikke ser etter her, blir ikke sjekket noe annet sted. Du kjører ingenting: du leser koden og sammenligner med kravet. Tilgangsradene er grunnlaget for tilgangsmatrisen og testbrukerne i testplanen (`fs-testplan`).

Gjelder kravene i scope som verifiseres (ikke avhengighetene), og bare for krav som har roller, organisasjoner eller data som opprettes, endres eller slettes. Et rent visningskrav uten tilgangsregler får ingen rader.

For hvert slikt krav, sjekk i koden (fs-plattform for tilgangssjekken i subgraph og backend, fs-admin og min-kompetanse for hva som vises og skjules):

1. **Tilgangsreglene.** Roller × organisasjon × opprette/lese/endre/slette. Finn tilgangssjekken for hver handling kravet har, og sammenlign med rollene i kravet (`Gitt`-stegene, `Regel:`-titlene og `Synlighet`-reglene). Mangler tilgangssjekk, eller er den et annet sted enn grensesnittet, skriv det.
2. **Organisasjonsgrensen.** Kan en bruker se eller endre data fra en annen organisasjon enn den hen har tilgang til? Se etter filter på organisasjon i spørringer og mutations, og at en id fra en annen organisasjon avvises.
3. **Sletting og endring.** Gir det foreldreløse eller motstridende data? Se etter fremmednøkler og kaskade, referanser fra andre tabeller eller krav (`@depends-on-`), og avhengige verdier som ikke oppdateres sammen.

Resultatet per sjekk er `stemmer` (koden gjør det kravet sier, lest på `fil:linje`), `avviker` (koden gjør noe annet, og hva), `ikke beskrevet` (kravet sier ikke noe om tilgangen, og koden har en regel: den er også en rad i *Regler uten scenario*), `ikke funnet` (ingen tilgangssjekk funnet, etter *Negative søk*) eller `usikker`. Kontrolløren sjekker radene på samme måte som scenarioene (*Kontroll*).

Radene står i `## Tilgang og datakonsistens` i rapporten, ikke i `## Scenarioer`: FS Kravforvaltning leser den tabellen som scenarioer. Et avvik endrer ikke kravet og stopper ikke forslaget i *Rapport og endringer*, men står i spørsmålet om å levere kravet, og i `## Oppfølging`. Foreslå `fs-krav` når kravet bør si noe om tilgangen.

## Regler uten scenario

Koden har ofte regler kravet ikke sier noe om: valideringer, obligatoriske felt og grenser, standardverdier, tilgangssjekker og tilstandsoverganger. De er input til testplanen og den agentiske testen (fase 2), som utleder testcaser fra reglene, og til kravarbeidet, når kravet bør ha dem.

For hvert krav du har lest koden for, list reglene du **så** mens du leste (ikke et fullstendig søk i hele repoet): valideringen i input-typen eller skjemaet, standardverdien i `emptyObjectGenerators`-filene, sperren i mutationen, og lignende. Ta bare med en regel som hører til funksjonaliteten kravet beskriver, og som ingen scenario i kravet dekker (også `@draft`-scenarioer: da står det «dekkes av `@draft`-scenario»). Hver regel står med `fil:linje`, hva den gjør (verdiene, grensene, meldingen), og et forslag: `legg til scenario med fs-krav` (kravet bør si det), `testes i fase 2` (en detalj testen utleder), eller `uklart om ønsket` (koden kan være feil). Du endrer ikke kravet.

Radene står i `## Regler uten scenario`. Kontrolløren sjekker at hver regel finnes og er uten scenario, og søker etter regler du bommet på.

## Åpne spørsmål

Rapporten teller åpne spørsmål per krav, så leseren og testplanen ser hvor kravet ikke er avklart. `@openquestion` gater ikke noe: en del med bare `@openquestion` er med i gating-settet og testes som den står, og `@draft @openquestion` er utenfor.

For hvert krav i scope, tell fra feature-fila (ikke fra koden):

- **Regler** med `@openquestion` på `Regel:`-linja
- **Scenarioer** med åpne spørsmål: `@openquestion` på scenarioet selv eller på regelen over, i gating-settet
- **Utenfor gating:** regler og scenarioer med `@draft @openquestion`

Tallene står i `## Åpne spørsmål`, og spørsmålene (fra `# ÅPNE SPØRSMÅL:`) i `## Oppfølging`. Tallene regnes ut, de telles ikke på øyemål (*Rapport*).

## Avhengigheter

Antall nivåer og om avhengighetene letes etter i koden, står i svaret på *Omfang og avhengigheter*. Med «Ingen» hopper du over denne seksjonen.

1. **Finn avhengighetene.** Nivå 1 er `@depends-on-<ID>` på kravene i scope: på `Egenskap:`, `Regel:` og `Scenario:`/`Scenariomal:`, men bare på delene som er med i verifiseringen. Nivå 2 er det kravene på nivå 1 bygger på, og så videre. Slå opp ID-en som i *Verifisere flyt*, steg 1 (`Grep "^\s*@(.*\s@)?<ID>\b"` i `krav/**/*.feature`). `@ref-` følges ikke: det er bare en henvisning (*Referanser* i `krav/README.md`).
   - Hvert krav tas med én gang, på det laveste nivået det finnes på. Et krav som er i scope, er ikke en avhengighet.
   - En ring (A → B → A) stopper der, og står i `## Oppfølging` som avvik (sjekk med `fs-krav-avvik`). En ID som ikke finnes, står med «finnes ikke».
   - For en flyt er nivå 1 kravene fasene bygger på, og statusen deres står allerede i fremdriften (*Verifisere flyt*, steg 1). Bruk den. En `@depends-on-FLY-…` er også et nivå.
2. **Bare status** (standard): les statusen på `Egenskap:`, og på delen referansen gjelder når kommentaren under taggen sier hvilken regel det er. Dette leser bare tagger.
3. **Verifisert i koden:** let og kontroller etter *Verifisere uansett status* (gating-settet, *Negative søk* og *Kontroll*), med hele egenskapen som scope. Resultatet står bare i rapporten (`### Scenarioer i avhengighetene`). Foreslå aldri ny status for en avhengighet, og slett ingenting. Skal avhengigheten få ny status, må den verifiseres med seg selv i scope.
4. **Levering mot avhengighetene.** En del som bygger på et krav, kan ikke leveres før kravet (*Referanser* i `krav/README.md`). Står et krav eller en del under *Kan leveres*, og bygger det (på nivå 1) på et krav som ikke er `@implemented`, skriv det bak kravet i forslaget («bygger på `@X`, som er `@planned`»), og i `## Oppfølging`. Det stopper ikke forslaget. Brukeren avgjør.

Rapporten får `## Avhengigheter` (se `[avhengigheter]` i [`references/rapportmal.md`](references/rapportmal.md)). `## Scenarioer` og `## Oppsummering` gjelder bare kravene i scope: tavla «Oppgaver», `fs-testplan` og `fs-testrapport` leser dem, og avhengighetene skal ikke telle med.

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
6. **Åpne MR-er og brancher** fra steg 2b (*Åpne MR-er og brancher*), med de samme søkeordene.

Søk med `git -C <repo> grep -i` (eller Grep), som tar alle filtyper. Skill ekte kode fra genererte filer (`generated/`). List søkeordene og stedene i beviset. Finner du noe som ligner, men ikke dekker scenarioet, skriv det i beviset også: da er resultatet `ikke funnet`, men leseren ser hva som finnes.

## Åpne MR-er og brancher

Koden for et krav er ofte skrevet, men ikke merget. Før et scenario står som `ikke funnet`, skal du derfor ha sett etter den i åpne MR-er og aktive brancher i kodeklonene. Det som bare finnes der, er ikke levert: scenarioet blir `ikke funnet` (og kravet retagges ikke), men beviset og rapporten sier hvor koden er, så leseren ser at den er på vei.

**Finn kandidatene** (steg 2b, én gang per klone, med Bash):

1. `git -C <repo> fetch origin --prune`. Det flytter ikke utsjekket branch eller filer.
2. Åpne MR-er: `glab mr list -R <gruppe/repo> -F json` (repoet fra `git -C <repo> remote get-url origin`, f.eks. `fs/fs-plattform` eller `studieadm/fs-admin`). Ta med utkast (`--draft`). Les `iid`, `title`, `source_branch`, `target_branch`, `author`, `draft`, `web_url`.
3. Brancher uten MR: bare de som navnet peker ut, `git -C <repo> branch -r --list '*<nøkkel>*'`. Repoene har tusenvis av brancher, så ikke list alle.

En MR eller branch er kandidat når nøkkelen står i branchnavnet, tittelen eller beskrivelsen (`glab mr view <iid> -R <repo>`): feature-ID-en (`OPT-OVO-INN-001`), `<slug>` fra scopet eller oppgaven, Jira-saken (`BAT-268`, fra `Issue` i `oppgave.md` og scope-tabellen), eller GitHub-issuet (`# GitHub:` i kravfila). Har du hint fra oppgaven (`<lag>/plan-*.md`, `task-*-completion.md`), bruk også filene og komponentene der: `glab mr diff <iid> -R <repo>` eller `git -C <repo> diff --name-only origin/<target>...origin/<source>` viser om MR-en rører dem. MR-er som ikke treffer noe, tas ikke med. Er det uklart om en MR hører til, ta den med og skriv «usikker kobling».

**Let i dem** uten å sjekke ut noe:

- `git -C <repo> grep -i -n "<ord>" origin/<source_branch> -- <sti>` og `git -C <repo> show origin/<source_branch>:<fil>`.
- Gjelder bare for scenarioer som ikke er funnet på den utsjekkede branchen. Søkeordene er de samme som i *Negative søk*.
- Er MR-en allerede merget, er koden på `main`: oppdater klonen (*Sjekk branchen*) i stedet for å lete i MR-en.

**Beviset** får et eget format, så det ikke kan forveksles med levert kode: `ikke funnet på <branch> — finnes i MR !<iid> (<åpen | utkast>, <repo>, <source_branch>): <fil>:<linje> — <hva koden gjør>`. Resultatet i `## Scenarioer` er fortsatt `ikke funnet`, og FS Kravforvaltning leser det slik. Retagging, `## Forslag til endringer` og tallene i `## Oppsummering` bygger bare på det som er på den utsjekkede branchen.

**Rapporten** får linja `- **Åpne MR-er:**` og seksjonen `## Åpne MR-er og brancher` (*rapportmal.md*), med MR-ene, hvilke krav de ser ut til å levere, og hvor mange scenarioer som er funnet der. Står en MR bak main eller har den konflikter (`glab mr view`), si det.

**Kontrollen** gjelder dem også: kontrolløren får listen over MR-er og branchene som ble lett i, og sjekker at et `finnes i MR` er riktig, og at det ikke finnes kode i en MR som er oversett.

## Kontroll

Den som har lett, ser lett det den venter å se. Før resultatet vises til brukeren, kontrolleres det av en som ikke har lett.

**Med Agent-verktøyet** (Claude Code i terminalen, også terminalen i FS Kravforvaltning): start subagenten `fs-verify-kontroll` (`.claude/agents/fs-verify-kontroll.md`) for hver feature-fil, gjerne flere parallelt. Gi den stien til feature-fila, kodeklonene og resultattabellen, tilgangsradene og reglene uten scenario, ikke hvordan du lette. Den svarer med `bekreftet` / `avkreftet` / `usikker` per rad og et forslag til resultat.

**Uten Agent-verktøyet** (Claude-panelet i FS Kravforvaltning): gjør kontrollen selv, og si til brukeren at den er manuell (se *I FS Kravforvaltning*):

1. Les `fil:linje` på nytt for hvert `funnet`, og sjekk koden mot `Når` og `Så`, ikke mot det du skrev.
2. Søk på nytt for hvert `ikke funnet` med søkeord du ikke har brukt, etter *Negative søk*.

Kontrollen gjelder også radene i `## Tilgang og datakonsistens` (leses på `fil:linje`, og `ikke funnet` søkes etter på nytt) og `## Regler uten scenario` (finnes regelen, og dekker et scenario i kravet den likevel? har kontrolløren funnet regler som mangler?). Det kontrollen endrer, står i `## Kontroll`.

**Kontroll er ikke menneskelig kontroll.** `fs-verify-kontroll` er en uavhengig agent, og «ferdig når» i fase 1 krever i tillegg at en annen person enn den som kjørte verifiseringen, har lest rapporten og bevisene. Det er et felt i rapporten (`- **Menneskelig kontroll:**`) som du aldri fyller ut: det står som `[Fylles ut: navn og dato]` til personen har skrevet det selv, i rapportfila (og på siden i Confluence når den finnes), og `fs-testrapport` (verifisering) leser det.

**Når kontrollen er uenig:** les det kontrollen viser til. Har kontrollen rett, bruk det nye resultatet. Er dere fortsatt uenige, blir resultatet `usikker`, med begge synene i beviset, og brukeren avgjør. Et `funnet` som kontrollen avkrefter, kan aldri brukes til retagging.

## Tidspunkt

Hver kjøring har ett tidspunkt, `YYYY-MM-DD HH:MM` i lokal tid, som brukes i navnet på rapporten (`<YYYY-MM-DD>-<HHMM>`, uten kolon, fordi Windows ikke tillater det i filnavn), i `- **Dato:**` og i mappa med skjermbilder. Ta det **når du starter**, før du leter, og bruk det samme gjennom hele kjøringen:

1. Står tidspunktet i systemteksten («Tidspunktet nå er …», i Claude-panelet og terminalen i FS Kravforvaltning), bruk det.
2. Ellers, med Bash: `date '+%Y-%m-%d %H:%M'`.
3. Ellers: spør brukeren hva klokka er. Gjett aldri.

## Rapport og endringer

Når alle kravene i scope er kontrollert, skriver du rapporten til fil **før** du spør. En hel rapport i chatten er umulig å lese i terminalen, og et spørsmål som viser til «rapporten over», er ute av kontekst. Derfor: rapporten står i fila, chatten får et kort sammendrag, og hvert spørsmål har med seg referansene det gjelder.

1. **Skriv rapporten til fil** (*Rapport*), med alle seksjonene, også `## Forslag til endringer`. `## Levert`, `## Ikke levert` og `## Slettet` får teksten «Venter på svar.» til brukeren har svart (steg 5). Forslaget har tre lister:
   - **Kan leveres:** `<feature-ID> — <tittel>` (`<fil>`, `<status>` → `@implemented`, <n>/<n> funnet), og deler som `<feature-ID> — Regel: <tittel>` (`@in-progress` fjernes). Bygger kravet på et krav som ikke er levert, står det bak: «bygger på `@<ID>`, som er `@<status>`» (*Avhengigheter*, steg 4).
   - **Delvis levert:** `<feature-ID> — <tittel>` (`<fil>`, `<status>` → `@in-progress`, <n>/<N> funnet), med delene som får `@implemented` (`Regel: <tittel>` eller `Scenario: <tittel>`, med linja).
   - **Kan slettes:** `<feature-ID> — <tittel eller del>` (`<fil>`, hele fila eller blokken), med repoene det er søkt i, og referansene til kravet som fjernes (`<fil>`: `@depends-on-<ID>` | `@ref-<ID>`).
   - **Blir stående:** kravene og delene som ikke kan leveres, med `<n>/<N> funnet` og hvorfor.
2. **Si kort fra i chat**, og vis ikke tabellene: lenken til rapportfila (som markdown-lenke, så den kan åpnes), linjene i `## Oppsummering`, og én linje per krav eller del i forslaget (`<feature-ID> — <tittel>`: kan leveres <n>/<n> | kan slettes | blir stående <n>/<N>), med antall avvik i tilgangen og regler uten scenario når det er noen. Scenarioene utenfor gating-settet nevnes med antall.
3. **Er det ingenting å spørre om** (ingen `usikker`, og ingenting kan leveres, leveres delvis eller slettes): ikke spør. Gå til steg 5.
4. **Still oppfølgingsspørsmålene** med `AskUserQuestion`, høyst 4 spørsmål per kall, i rekkefølgen i rapporten. Hvert spørsmål skal kunne leses alene, uten rapporten og uten chatten over:
   - Feature-ID, tittel og stien til kravet med linja (`krav/…/fil.feature:<linje>`) står i spørsmålet.
   - Bevisene står som faktiske referanser, `<repo>/<fil>:<linje>` med hva koden gjør, aldri som «se rapporten» eller «over».
   - Er det mer enn spørsmålsteksten rommer, legg resultattabellen for kravet (scenario → resultat → `<repo>/<fil>:<linje>` — hva koden gjør) i `preview` på det første valget. `preview` virker bare når `multiSelect` er `false`.

   Spørsmålene, i denne rekkefølgen:

   a. **Usikre scenarioer** (de som kan endre hva som kan leveres): «`<feature-ID>` «<scenario>» (`krav/…:<linje>`): `<repo>/<fil>:<linje>` <hva koden gjør>. Kontrollen: <hvorfor det er uklart>. Dekker koden scenarioet?» — **Ja, funnet** / **Nei, ikke funnet** / **Vet ikke** (blir `usikker`). Svaret skrives i `Bevis` («avgjort av brukeren: …»), og forslaget regnes ut på nytt før neste spørsmål.
   b. **Kan leveres**, ett spørsmål per krav eller del: «`<feature-ID> — <tittel>` (`krav/…:<linje>`): <n>/<n> scenarioer funnet, bl.a. «<scenario>» i `<repo>/<fil>:<linje>` (<hva koden gjør>). Kontrollen <bekreftet alle | endret <n>>. Skal kravet bli `@implemented`?» (for en del: «Skal delen leveres?»). Bygger kravet på et krav som ikke er levert, står det i spørsmålet. — **Ja** / **Nei, noe mangler** (spør hva i fritekst) / **Avbryt** (stopp, og la resten stå).
   b2. **Delvis levert**, ett spørsmål per krav: «`<feature-ID> — <tittel>` (`krav/…:<linje>`): <n>/<N> scenarioer funnet. Levert: `Regel: <tittel>` (`krav/…:<linje>`, bl.a. `<repo>/<fil>:<linje>`), … Ikke funnet: «<scenario>» (`krav/…:<linje>`), … Skal egenskapen bli `@in-progress`, og de leverte delene `@implemented`?» — **Ja** / **Nei** / **Avbryt**. Er det mange deler, står lista i `preview`.
   c. **Kan slettes**, ett spørsmål per krav eller del: «Fant ingen spor av `<feature-ID> — <tittel eller del>` (`krav/…:<linje>`) i <repoer>, søkt etter «<ord>», «<ord>». Referansene som fjernes: `<fil>`: `@depends-on-<ID>`. Slette <fila | blokken>?» — **Slett** / **Behold** / **Avbryt**.

   Er det mer enn 8 spørsmål i b og c til sammen, still først ett spørsmål: «<N> krav kan leveres og <N> kan slettes (lista står i forhåndsvisningen, rapporten i `<sti>`). Hvordan vil du gå fram?» — **Gå gjennom krav for krav** (anbefalt) / **Gjør alle endringene** / **Ikke endre noe**, med forslaget (feature-ID, tittel, `krav/…`-sti og <n>/<n>) i `preview`.

   Brukeren kan skrive i «Annet», f.eks. at noe ikke virker. Les det, og gjør resultatet for det kravet om til `usikker` eller `ikke funnet` når brukeren sier at noe mangler.
5. **Gjør endringene** brukeren sa ja til (retagging i *Verifisere implementasjon*, *Delvis levert*, *Deler i leverte krav som endres* og *Verifisere uansett status*, sletting i *Verifisere at koden er borte*, steg 4), og **oppdater rapportfila**: radene i `## Scenarioer` som brukeren avgjorde, `## Oppsummering`, og `## Levert`, `## Ikke levert` og `## Slettet` i stedet for «Venter på svar.». Regn ut tallene på nytt (*Rapport*). Avbryter brukeren, eller svarer ikke, står det som ikke er avgjort, under `## Ikke levert` med «Brukeren avbrøt gjennomgangen» eller «Ikke besvart».
6. **Si i chat** hva som er gjort (levert, slettet, blir stående), med lenken til rapportfila.

## Gjennomgang av en verify-rapport

Gir brukeren en verify-rapport (`…/verify-*.md`), er målet å gjøre resultatet bedre sammen med brukeren: avklare det som er usikkert eller ikke funnet, sette status på det som er levert eller delvis levert, og få avklart de åpne spørsmålene. Du verifiserer ikke alt på nytt, men går gjennom det som ikke er avgjort.

1. **Les rapporten:** kravene (`- **Krav:**`, `- **Spec:**`), kodeklonene (`- **Kode:**`), `- **Omfang:**`, `- **Avhengigheter:**`, `## Scenarioer`, `## Avhengigheter`, `## Oppfølging` og hva som ble levert. Omfang og avhengigheter tas fra rapporten, så du spør ikke om dem på nytt.
2. **Sjekk at grunnlaget fortsatt gjelder.** Sjekk branchen i kravrepoet og i klonene (*Finn scope og kode*, steg 0 og 2). Spør om kodeklonene bare når stiene i rapporten ikke finnes. Les kravfilene på nytt: er statusen endret, eller er det scenarioer som er nye, borte eller har fått ny tittel siden rapporten, si det, og ta de nye scenarioene med som ikke verifisert. Er koden endret siden commiten i `- **Kode:**` (`git -C <repo> log <sha>..HEAD --oneline`), si det, og les bevisene på nytt for radene som skal avklares.
3. **Lag lista over det som skal avklares,** i rekkefølgen i rapporten, og vis den kort i chat: antallet av hver type, med lenken til rapporten.
   - a. `usikker` og `ikke funnet` i `## Scenarioer`
   - b. krav som kan leveres eller er delvis levert, men ikke har fått ny status (brukeren sa nei, eller rapporten er fra før *Delvis levert*)
   - c. scenarioer som ikke er funnet i et krav som er delvis levert
   - d. åpne spørsmål: `@openquestion` i kravene i scope, og *Åpent spørsmål* i `## Oppfølging`
4. **Gå gjennom lista** med `AskUserQuestion`, høyst 4 spørsmål per kall. Reglene for referanser er de samme som i *Rapport og endringer*, steg 4: kravet med `krav/…:<linje>`, koden med `<repo>/<fil>:<linje>`, og aldri «se rapporten». Ta a først, siden svarene endrer b og c.
   - **a. Usikker eller ikke funnet:** «`<feature-ID>` «<scenario>» (`krav/…:<linje>`): <beviset eller søket fra rapporten>. Vet du hvor koden er?» — **Søk på nytt** (med søkeord som ikke står i beviset, etter *Negative søk*) / **Ikke bygget** (blir `ikke funnet`) / **Den er her** (stien, komponenten eller ruta skrives i «Annet»). Les det brukeren peker på, og vurder koden mot `Når` og `Så`. Et nytt `funnet` kontrolleres (*Kontroll*) før det brukes.
   - **b. Kan leveres eller delvis levert:** som b og b2 i *Rapport og endringer*, steg 4.
   - **c. Scenario som ikke er funnet:** «`<feature-ID>` «<scenario>» (`krav/…:<linje>`) er ikke funnet i koden (søkt etter «<ord>» i <repoer>). Hva gjelder?» — **Skal bygges** (kravet endres ikke) / **Uklart** (delen får `@openquestion` og `# ÅPNE SPØRSMÅL:`, med spørsmålet brukeren skriver i «Annet», ellers «Ikke funnet i koden. Skal <scenario> bygges, endres eller fjernes?») / **Skal ikke være med** (foreslå `fs-krav`, som sletter delen, eller gir den `@deprecated` når den er levert).
   - **d. Åpent spørsmål:** «`<feature-ID>` «<regel eller scenario>» (`krav/…:<linje>`) har spørsmålet «<spørsmålet>». <Hva koden gjør, med `<repo>/<fil>:<linje>`, når den sier noe om svaret.> Hva er svaret?» — **Besvart, kravet stemmer** (svaret i «Annet») / **Besvart, kravet må endres** (svaret i «Annet») / **Ikke avklart ennå**.
     - *Kravet stemmer:* fjern spørsmålet fra `# ÅPNE SPØRSMÅL:`, og hele kommentaren og `@openquestion` når det ikke er flere spørsmål igjen på delen. `@draft` fjerner du ikke: er delen `@draft @openquestion`, foreslå `fs-krav` for å validere den.
     - *Kravet må endres:* spørsmålet og taggen står. Svaret står i rapporten, og du foreslår `fs-krav` med svaret.
5. **Gjør endringene** brukeren sa ja til, som i *Rapport og endringer*, steg 5, og endringene i c og d. Les hver fil etterpå og sjekk at den fortsatt er gyldig Gherkin, og at hver `@openquestion` har en `# ÅPNE SPØRSMÅL:`.
6. **Skriv en ny rapport** med nytt tidspunkt (*Tidspunkt*) og variant `[gjennomgang]` i malen: `- **Bygger på:**` med den gamle rapporten, og `## Avklaringer` med hvert spørsmål og svaret. Radene som ikke ble gått gjennom, tas med uendret fra den gamle rapporten. Den gamle rapporten endres ikke. `utforing.md` og loggen oppdateres som ellers (*Rapport*, *Logg kjøringen*).
7. **Si i chat** hva som er endret, med lenken til den nye rapporten, og hva som gjenstår: spørsmål som ikke er avklart, og endringer som er foreslått for `fs-krav`.

## Etter endringene

Si dette i chat. Det står ikke i rapporten.

- **Foreldreløse step definitions.** For slettede scenarioer: søk i `tester/steps/` etter stegtekstene. Steg som ikke lenger brukes av noen `.feature`-fil, listes. Ikke slett dem.
- **Tester.** Et `@deprecated` scenario som fortsatt har step definitions, vil feile når koden fjernes. Nevn det.

## Rapport

Rapporten skrives til fil før spørsmålene, og oppdateres med svarene i samme kjøring (*Rapport og endringer*). I chat står bare et sammendrag og lenken. Fila ligger etter hva scope er. Filnavnet har alltid dato og klokkeslett (`<YYYY-MM-DD>-<HHMM>`, se *Tidspunkt*), så kjøringer samme dag kan sammenlignes og ikke skriver over hverandre:

- **Oppgave eller spesifikasjon:** `<oppgave>/spec/verify-<YYYY-MM-DD>-<HHMM>.md` (`verify-2026-10-09-1432.md`; `-2`, `-3` … hvis fila finnes).
- **Bare en `krav/`-sti:** rett ved siden av det som ble verifisert. For én fil: `verify-<feature-fil>-<YYYY-MM-DD>-<HHMM>.md` i samme mappe som fila, der `<feature-fil>` er filnavnet uten `.feature` (`fjerne_roller.feature` → `verify-fjerne_roller-2026-10-07-0915.md`). For en mappe: `verify-<mappenavn>-<YYYY-MM-DD>-<HHMM>.md` inne i mappa, sammen med kravene den gjelder (`…/12 Brukeradministrasjon/personbrukere/` → `…/12 Brukeradministrasjon/personbrukere/verify-personbrukere-2026-10-07-0915.md`). `-2`, `-3` … hvis fila finnes. Linja `- **Spec:**` utelates.

- **Scope:** `akseptansetest/<scope-slug>/verify-<YYYY-MM-DD>-<HHMM>.md`, i mappa testplanen for scopet får (*Struktur* i [`akseptansetest/README.md`](../../../akseptansetest/README.md)). Lag mappa hvis den ikke finnes. `- **Spec:**` utelates, og `- **Krav:**` er `@scope-<slug>` (<N> feature-filer).
- **Testplan:** gjelder testplanen én oppgave, som for en oppgave (`<oppgave>/spec/verify-…`). Ellers (et scope, en mappe eller feature-filer) i testplanmappa: `akseptansetest/<slug>/verify-<YYYY-MM-DD>-<HHMM>.md`. `- **Spec:**` utelates, og `- **Krav:**` er kilden i testplanen (`@scope-<slug>`, `krav/<sti>/` eller filene, <N> feature-filer).

Skriv aldri over en tidligere rapport, og endre den ikke: den er det du sammenligner med neste gang. Rapporten fra kjøringen som pågår, oppdateres med svarene (*Rapport og endringer*, steg 5) og linja `- **Confluence:**` (*Confluence*), og ikke etter at kjøringen er ferdig. Unntaket er `- **Menneskelig kontroll:**`, som personen som kontrollerer rapporten, fyller ut etterpå (*Kontroll*). Du fyller det aldri ut.

Skriv aldri rapporten noe annet sted under `krav/`. Ikke kall den `verification-*.md`: det mønsteret er reservert for `<lag>/` (se *Fire regler* i `tasks/README.md`).

**Formatet står i [`references/rapportmal.md`](references/rapportmal.md).** Les malen før du skriver rapporten, og følg den nøyaktig: alle seksjonene, i samme rekkefølge, med de faste tekstene. Det er det som gjør at to kjøringer kan sammenlignes. FS Kravforvaltning leser `- **Dato:**`, `- **Spec:**` og tabellen `## Scenarioer`, og viser resultatet på kortet i Spesifikasjoner.

**Tall regnes ut, de telles ikke.** Alle tall i rapporten (scenarioer funnet per krav, i alt, og i *Oppsummering*, og tallene i `## Åpne spørsmål`) regnes ut fra tabellen `## Scenarioer`, fra `@openquestion`-taggene i kravfilene og fra endringene du har gjort, f.eks. med `awk` på rapportfila når du har Bash. Uten Bash: tell radene i tabellen én gang til, krav for krav, før du skriver tallene.

`- **Kontroll:**` sier hvem som kontrollerte: `fs-verify-kontroll` (uavhengig) eller `manuell (Claude-panelet)`. `## Kontroll` lister radene der kontrollen endret resultatet, så leseren ser hva den første letingen bommet på. Kolonnen `Type` sier om raden er et scenario, en tilgangsrad eller en regel uten scenario.

**`utforing.md`.** Når scope er en spesifikasjon som er sendt (har en seksjon i `<oppgave>/utforing.md`, se *Utføring* i `tasks/README.md`): mangler noe (`ikke funnet` eller `usikker` etter kontrollen, eller brukeren har sagt at noe mangler), sett steget i repoet der koden mangler, tilbake til `- **Status**: pågår`, legg til `- **Tilbake**: <YYYY-MM-DD>`, og en linje i `Logg` (`<dato> — fs-verify — <n> ikke funnet, <n> usikker · tilbake til <repo>`). Er alt funnet, legg bare til en linje i `Logg` (`alt funnet · verifisert`); kortet står i «Verifisert» når kravene er `@implemented`.

## Confluence

Verifiseringen er fase 1 i akseptansetesten (se [`akseptansetest/README.md`](../../../akseptansetest/README.md)), før testplanen, som i [teststrategien](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326). Resultatet kan legges som en underside til testplanen i Confluence, så testflyten har verifiseringen på samme sted som testcasene og testrapportene. Gjør dette etter at rapporten er skrevet. Retaggingen og rapporten endres ikke av det.

0. **Finnes testplanen?** Se etter testplanen etter *Finn testplanen* i [`.claude/references/akseptansetest/confluence.md`](../../references/akseptansetest/confluence.md): testplanen i scope, eller `Grep` etter kilden (scope-id-en, oppgaven, mappa eller fila) i `akseptansetest/*/testplan.md`. Finnes ingen testplan med `- **Confluence**:`, er dette den første verifiseringen: spør ikke om Confluence. Si at neste steg er `fs-testplan` med den samme kilden, og at den bygger på rapporten og legger den som underside når testplanen opprettes. Slutt der. Finnes testplanen, fortsett.
1. **Spør** (`AskUserQuestion`): «Legg resultatet i Confluence?», med valgene «Ja, som utkast» (anbefalt), «Ja, publiser» og «Nei». Spør ikke når prompten allerede har sagt det («Legg resultatet i Confluence» eller «Ikke Confluence»). Finnes ingen Atlassian-MCP i økta, eller er den ikke logget inn, spør ikke: si det, og at rapporten står i fila. Hopper brukeren over, regn det som «Nei».
2. **Testplanen** er den du fant i steg 0.
3. **Lag undersiden** «Verifisering – <leveranse> – <YYYY-MM-DD HH:MM>» (tidspunktet for kjøringen, *Tidspunkt*) under testplanen, med `status: "draft"` ved «Ja, som utkast». Innholdet er rapporten fra og med metadataene: `## Oversikt per krav` (når den finnes), `## Oppsummering`, `## Scenarioer`, `## Tilgang og datakonsistens`, `## Regler uten scenario`, `## Åpne spørsmål` og `## Levert`, med tabellene som i fila. Stiene i `Bevis` blir lenker til GitHub på commiten i `- **Kode:**` (`https://github.com/sikt-no/<repo>/blob/<sha>/<sti>#L<linje>`). Følg *Fra fila til siden* i `confluence.md`.
4. **Oppdater testplanen:** raden «1. Verifisering (`fs-verify`)» i «Status i flyten», med lenken, «Alt funnet» eller «<N> ikke funnet, <N> usikker», og datoen (*«Status i flyten» på testplanen* i `confluence.md`). Oppdater raden i `testplan.md` også. Andre deler av testplanen rører du ikke.
5. **Skriv lenken** i metadataene i rapportfila: `- **Confluence:** <url>` (`<url> (utkast)` for et utkast), etter `- **Skjermbilder:**` (variant `[confluence]` i rapportmalen).
6. **Si hva som er neste steg:** `fs-testrapport` for verifiseringen, med testplanen (og at en annen person skal kontrollere rapporten, *Kontroll*), at tilgangsradene er grunnlaget for testbrukerne i testplanen, at reglene uten scenario er input til den agentiske testen (`fs-testcaser-cdp`), og at de åpne spørsmålene nevnes i testplanen, men ikke stopper leveransen. Er det kommet krav i «Omfang» som var i «Venter på verifisering», foreslå også å kjøre `fs-testplan` på nytt, så de står i «Omfang».

Skjermbildene fra *Skjermbilder* lastes ikke opp. Siden lenker til mappa på GitHub når den er committet.

## Git

Ikke `git add`, `commit`, `push`, `checkout` eller `stash` i noe repo. Lesende git-kommandoer (`git -C <repo> log`, `grep`, `ls-files`, `show`, `diff`, `fetch`) er lov, også mot andre refs (`origin/<branch>`). Det samme gjelder lesende `glab` (`glab mr list`, `view`, `diff`). Aldri `glab mr create`, `merge`, `note`, `approve`, `update` eller `close`. Brukeren commiter endringene i `krav/`, eller lager PR med «Lag PR» i FS Kravforvaltning.

## Referanser

- **`krav/README.md`** — statusaksen, *Delvis utkast*, *Avvikling* og *Referanser* (`@depends-on-` og `@ref-`).
- **[`tasks/README.md`](../../../tasks/README.md)** — oppgavestrukturen og reglene for `spec/`.
- **`fs-krav`** — setter `@deprecated` når et levert krav skal fjernes.
- **`fs-specify` / `fs-specify-delta`** — setter `@in-progress`, på egenskaper og på deler i leverte krav som endres.
- **`.claude/agents/fs-verify-kontroll.md`** — kontrolløren som sjekker resultatene uavhengig (*Kontroll*).
- **[`.claude/references/akseptansetest/`](../../references/akseptansetest/)** — scope som kilde, testplanen som scope, og Confluence-steget (*Confluence*).
- **`fs-testplan`** — neste steg i akseptansetesten, og bygger på rapporten: kravene, åpne spørsmål, reglene uten scenario og tilgangsradene.
