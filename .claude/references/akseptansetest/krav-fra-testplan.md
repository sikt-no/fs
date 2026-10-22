# Kravene i en testplan

Felles for skillene i testflyten. Verifiseringen (`fs-verify` eller `fs-verify-agent-teams`) kjøres først, på kilden, og setter `@implemented` på kravene der koden er funnet. `fs-testplan` finner så kravene fra den samme kilden, og skriver dem i «Omfang» i testplanen. De andre skillene leser kravene derfra, med Feature-ID, så alle trinnene tester de samme kravene, også om det kommer nye krav i mappa eller scopet etterpå.

**Det som testes, er det som er `@implemented`.** Krav og deler med en annen status står i testplanen, men ikke i testcasene. Unntaket er en levert fase i en flyt som ikke er `@implemented` ennå (se *Flyter*).

## Leveransen

En testplan gjelder én av fire kilder. En testplan kan ha flere kilder av samme slag (flere scope, mapper eller filer):

| Leveranse | Input | Kravene |
|---|---|---|
| Scope | `scope-<slug>`, `@scope-<slug>`, eller `tasks/<domene>/scope-<slug>.md` | Alle krav og deler med taggen `@scope-<slug>` |
| Oppgave | `tasks/<domene>/<slug>`, eller bare slug (`Glob` `tasks/*/<slug>/`) | Oppgavens rader i scope-tabellen. Uten scope: `## Krav` i `spec/spec-*.md` i oppgaven |
| Mappe | En mappe under `krav/` (domene, sub-domene eller kapabilitet) | Alle `.feature`-filer under mappa |
| Feature-fil | Én eller flere `.feature`-filer under `krav/` | Filene |

Er det uklart hva brukeren mener (for eksempel en slug som både er et scope og en oppgave), spør.

En flyt i `krav/_Flyter/` er ikke en egen leveranse. Flytene som går gjennom kravene, kommer med i tillegg, uansett kilde (se *Flyter*).

## Finn kravene

### Scope

1. `grep -rl "@scope-<slug>" krav/ --include=*.feature`. Uten Bash: `Grep` med samme mønster.
2. Les hver fil. Taggen står på `Egenskap:`-linja (hele kravet hører til scopet), eller på en `Regel:` / `Scenario:` under en `@implemented` egenskap (bare den delen hører til scopet, se *Scope* i `krav/README.md`).
3. Sjekk mot oppgavetabellen i `tasks/<domene>/scope-<slug>.md`. Kravene i tabellen og kravene med taggen skal være de samme:
   - **Krav i tabellen uten taggen:** si fra, og ta det med (tabellen er kilden til hvilke krav oppgaven har).
   - **Krav med taggen som ikke er i tabellen:** si fra, og ta det med. Foreslå `fs-scope`.
   - **Krav i tabellen som ikke finnes under `krav/`:** list det i «Ikke med i denne testen» med grunnen «Kravet finnes ikke ennå».
4. Grupper kravene per oppgave, i den rekkefølgen oppgavene står i tabellen. `(ikke tildelt)` er en egen gruppe til slutt.

Et initiativ som går over flere domener, har ett scope per domene. Da har testplanen flere scope-id-er, og kravene er alle kravene med en av dem.

### Oppgave

Oppgavens rader i scope-tabellen, slått opp på Feature-ID under `krav/`. Uten `Scope:` i `oppgave.md`: Feature-ID-ene under `## Krav` i `spec/spec-*.md` (ikke det som står under *Utenfor scope*). Les ikke kopiene i `spec/krav-input/`.

### Mappe

1. `Glob` `<mappe>/**/*.feature`. Mappa kan være på alle tre nivåene i `krav/` (domene, sub-domene, kapabilitet).
2. Grupper kravene per kapabilitetsmappe, i rekkefølgen i `krav/` (tallprefiksene), og filene i hver mappe alfabetisk.
3. Er mappa stor (mer enn 15 feature-filer, eller flere sub-domener), vis antallet per mappe og spør om alt skal med, eller bare noen av mappene.

### Feature-fil

Filene brukeren oppga, i den rekkefølgen brukeren oppga dem. Én gruppe.

### For alle kildene

- Slå opp hvert krav på Feature-ID (`@DOM-SUB-KAP-NNN`). 0 treff: «ikke funnet under krav/». Mer enn 1: «duplisert feature-ID». Begge står i «Ikke med i denne testen».
- **Scope-id-ene:** les `@scope-<slug>`-taggene på kravene, også ved en mappe eller fil. De står i testplanen (`- **Scope**:`), så testplanen kan knyttes til scopet og de automatiske testene. Har ingen av kravene en scope-tagg, er det `- **Scope**: –`.

## Hvilke scenarioer som er med

**Gating-settet** er det samme som i `fs-verify` og *Utføring* i `tasks/README.md`: alle `Scenario:`/`Scenariomal:` som ikke er tagget `@draft`, `@deprecated` eller `@demo`, selv eller via `Regel:`.

**Åpne spørsmål.** En del med bare `@openquestion` (uten `@draft`) er klar til implementasjon (*Oppfølging* i `krav/README.md`), og er i gating-settet. Er den levert, testes den som det står, og spørsmålet står som merknad: i «Omfang» i testplanen, og under tabellen for regelen i testcasene. En del med `@draft @openquestion` er utkast, og er ikke med.

**Testcasene lages bare for det som er levert:** scenarioer i gating-settet under en `@implemented` egenskap, uten `@planned` eller `@in-progress` på delen.

| Status | I testplanen | I testcasene |
|---|---|---|
| `@implemented` på `Egenskap:` | «Omfang» | Med |
| `@implemented`, med `@planned`- eller `@in-progress`-deler (levert krav som endres) | «Omfang». Delene som endres, står i «Venter på verifisering» | De leverte delene. Er leveransen et scope, bare delene som er levert i scopet (se under) |
| `@in-progress` på `Egenskap:` | «Venter på verifisering» | Ikke med før `fs-verify` har satt `@implemented` |
| `@planned`, `@draft`, uten status | «Ikke med i denne testen», med taggen | Ikke med |
| `@deprecated` (egenskap eller del) | «Ikke med i denne testen» («skal fjernes») | Ikke med |
| `@wont` på `Egenskap:` | «Ikke med i denne testen» («skal ikke lages») | Ikke med |

**Endrede krav i et scope.** Er leveransen et scope eller en oppgave med scope, og har et `@implemented` krav taggen `@scope-<slug>` bare på enkelte deler, er det bare de delene som testes (delene som er levert i scopet). Resten av kravet ble levert og testet før. Ved en mappe eller fil testes hele det leverte kravet, med mindre brukeren sier noe annet.

Er ingen av kravene `@implemented`, si det før testplanen skrives: testplanen kan lages, men det er ingenting å lage testcaser for ennå. Er verifiseringen ikke kjørt, foreslå `fs-verify` på kilden først.

Det som faller ut, listes i «Ikke med i denne testen» med grunnen: taggen, og det åpne spørsmålet når delen er `@draft @openquestion`. På testsidene skrives grunnen med vanlige ord, uten tagger.

## Flyter

En flyt (`krav/_Flyter/`, se *Flyter* i `krav/README.md`) beskriver et løp på tvers av domener. Hver `Regel:` er en fase, og `@depends-on-` på fasen peker på kravene fasen bygger på. Testene for hvert krav setter opp tilstanden selv, så bare flyten tester at det ett krav lager, blir brukt av det neste. Er et krav i leveransen med i en flyt, testes derfor også overleveringene i flyten.

### Finn flytene

1. For hver Feature-ID i kilden (i «Omfang» når testplanen finnes): `grep -rlE "@depends-on-<ID>\b" krav/_Flyter/`. Uten Bash: `Grep` med samme mønster.
2. Ta også med flytene med en av scope-id-ene i testplanen (`@scope-<slug>`).
3. En flyt som bare nås gjennom en annen flyt (`@depends-on-FLY-…`, typisk oversiktsflyten), tas ikke med av seg selv.
4. En flyt som er `@draft`, `@deprecated` eller `@wont`, står i «Ikke med i denne testen», med taggen.

### Fasene

For hver fase (`Regel:`) i flyten:

- **I leveransen:** et av kravene i `@depends-on-` er i «Omfang».
- **Levert:** alle kravene i `@depends-on-` er `@implemented` (for en `@depends-on-FLY-…`: flyten er `@implemented`). Det er det samme som steg 1 i *Verifisere flyt* i `fs-verify`.
- **Mangler krav:** fasen har ingen `@depends-on-`.

### Hele eller deler av flyten

Overleveringen står i scenarioet i fasen: tilstanden i `Gitt` lages ett sted, og brukes til det `Så` sier. Et scenario i en flyt kan testes når det er i gating-settet (se *Hvilke scenarioer som er med*), og overleveringen er verifisert:

- **Flyten er `@implemented`:** statusen er beviset. `fs-verify` satte den bare da alle overleveringene var funnet, og verifiserer ikke en levert flyt på nytt, så den har ingen rader i nyere verify-rapporter.
- **Flyten er ikke `@implemented`:** fasen er levert, og verify-rapporten har scenarioet som `funnet`.

- **Hele flyten** når flyten er `@implemented`. Det er standard, også når leveransen bare berører én fase: en endring i ett krav kan bryte overleveringer i flere faser, og en flyt har få scenarioer. Har flyten flere enn fem faser, eller berører leveransen bare én fase, spør `fs-testplan` om hele flyten skal testes, eller bare fasene i leveransen, og anbefaler hele.
- **Deler av flyten** når flyten ikke er `@implemented`: de leverte fasene i leveransen, der scenarioet er funnet. En levert fase i en `@planned` flyt testes, selv om flyten ikke er `@implemented`, fordi kravene fasen bygger på, er levert, og overleveringen er funnet i koden.
- Det som ikke testes, står i «Ikke med i denne testen», med grunnen: «fasen er ikke levert», «fasen mangler krav», «overleveringen er ikke funnet», eller «fasen er ikke i leveransen» (når teamet har valgt deler).
- **Kjent brudd:** står det `# Kjent brudd:` i flyten, står bruddet i «Forutsetninger» i testplanen, og overleveringen det gjelder, testes ikke før bruddet er løst.

### Kravene i de andre fasene

Kravene en fase bygger på som ikke er i «Omfang», står bare i kolonnen «Bygger på» i «Flyter» i testplanen, med status. De blir aldri testcaser selv. `fs-testcaser-intern` og `fs-testcaser-ekstern` kan lese dem for å skrive stegene som lager tilstanden i `Gitt`.

## Kravene i de andre skillene

`fs-testcaser-intern`, `fs-testcaser-ekstern`, `fs-testrapport`, og `fs-verify` når den kjøres på nytt med testplanen, bruker Feature-ID-ene i «Omfang» og «Venter på verifisering» i testplanen, og flyt-ID-ene i «Flyter», og slår dem opp under `krav/`. De finner ikke kravene og flytene på nytt fra kilden. Unntaket er kravene i de andre fasene i en flyt, som leses for å sette opp tilstanden (se *Flyter*). Har et krav eller en flyt fått ny status siden testplanen ble laget (for eksempel `@implemented` etter `fs-verify`), gjelder statusen i kravfila. Er det kommet nye krav i kilden, si fra, og foreslå å kjøre `fs-testplan` på nytt.

## Commit

Kravene leses fra det som står på disk. Skriv commiten de ble lest fra i metadataene (`git rev-parse --short HEAD`, og `git status --short krav/` for å se om noe ikke er committet). Uten Bash: skriv `commit ikke sjekket (Claude-panelet)`. Lenkene til GitHub bruker commiten, så de viser kravet slik det var da testplanen ble laget.

## De automatiske testene

Kommandoen står i testplanen, så teamet kan kjøre de automatiske testene av de samme kravene før akseptansetesten:

- Med scope-id: `npx playwright test --grep @scope-<slug>` (*Scope* i `krav/README.md`).
- Uten scope-id, eller når kravene ikke er hele scopet: `npx playwright test --grep "@<ID-1>|@<ID-2>"`, med Feature-ID-ene i «Omfang».
- Flytene i «Flyter»: legg flyt-ID-ene til (`--grep "@scope-<slug>|@FLY-<ID>"`), så overleveringene kjøres sammen med kravene.
