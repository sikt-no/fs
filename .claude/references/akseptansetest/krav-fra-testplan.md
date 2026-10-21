# Kravene i en testplan

Felles for skillene i testflyten. Verifiseringen (`fs-verify` eller `fs-verify-agent-teams`) kjøres først, på kilden, og setter `@implemented` på kravene der koden er funnet. `fs-testplan` finner så kravene fra den samme kilden, og skriver dem i «Omfang» i testplanen. De andre skillene leser kravene derfra, med Feature-ID, så alle trinnene tester de samme kravene, også om det kommer nye krav i mappa eller scopet etterpå.

**Det som testes, er det som er `@implemented`.** Krav og deler med en annen status står i testplanen, men ikke i testcasene.

## Leveransen

En testplan gjelder én av fire kilder. En testplan kan ha flere kilder av samme slag (flere scope, mapper eller filer):

| Leveranse | Input | Kravene |
|---|---|---|
| Scope | `scope-<slug>`, `@scope-<slug>`, eller `tasks/<domene>/scope-<slug>.md` | Alle krav og deler med taggen `@scope-<slug>` |
| Oppgave | `tasks/<domene>/<slug>`, eller bare slug (`Glob` `tasks/*/<slug>/`) | Oppgavens rader i scope-tabellen. Uten scope: `## Krav` i `spec/spec-*.md` i oppgaven |
| Mappe | En mappe under `krav/` (domene, sub-domene eller kapabilitet) | Alle `.feature`-filer under mappa |
| Feature-fil | Én eller flere `.feature`-filer under `krav/` | Filene |

Er det uklart hva brukeren mener (for eksempel en slug som både er et scope og en oppgave), spør.

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

**Gating-settet** er det samme som i `fs-verify` og *Utføring* i `tasks/README.md`: alle `Scenario:`/`Scenariomal:` som ikke er tagget `@draft`, `@deprecated`, `@openquestion` eller `@demo`, selv eller via `Regel:`.

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

Det som faller ut, listes i «Ikke med i denne testen» med grunnen: taggen, og det åpne spørsmålet når delen er `@openquestion`. På testsidene skrives grunnen med vanlige ord, uten tagger.

## Kravene i de andre skillene

`fs-testcaser-intern`, `fs-testcaser-ekstern`, `fs-testrapport`, og `fs-verify` når den kjøres på nytt med testplanen, bruker Feature-ID-ene i «Omfang» og «Venter på verifisering» i testplanen, og slår dem opp under `krav/`. De finner ikke kravene på nytt fra kilden. Har et krav fått ny status siden testplanen ble laget (for eksempel `@implemented` etter `fs-verify`), gjelder statusen i kravfila. Er det kommet nye krav i kilden, si fra, og foreslå å kjøre `fs-testplan` på nytt.

## Commit

Kravene leses fra det som står på disk. Skriv commiten de ble lest fra i metadataene (`git rev-parse --short HEAD`, og `git status --short krav/` for å se om noe ikke er committet). Uten Bash: skriv `commit ikke sjekket (Claude-panelet)`. Lenkene til GitHub bruker commiten, så de viser kravet slik det var da testplanen ble laget.

## De automatiske testene

Kommandoen står i testplanen, så teamet kan kjøre de automatiske testene av de samme kravene før akseptansetesten:

- Med scope-id: `npx playwright test --grep @scope-<slug>` (*Scope* i `krav/README.md`).
- Uten scope-id, eller når kravene ikke er hele scopet: `npx playwright test --grep "@<ID-1>|@<ID-2>"`, med Feature-ID-ene i «Omfang».
