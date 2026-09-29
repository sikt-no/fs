---
name: fs-verify
description: Verifiserer krav mot koden i dette repoet. Tar en `krav/`-sti eller en oppgave (`tasks/<domene>/<slug>`) og lokale kloner av kode-repoene. For hvert `@in-progress`-krav leter skillen etter implementasjonen av hvert scenario i koden, viser bevis (`fil:linje`), og retagger `@in-progress` → `@implemented` på `Egenskap:`-linja når alt er funnet og brukeren bekrefter. For hvert `@deprecated`-krav (egenskap eller `Regel:`/`Scenario:`) leter skillen etter spor i koden. Er koden borte og brukeren bekrefter, slettes fila eller blokken; finnes den fortsatt, listes stedene. Skriver rapport i chat, og i `tasks/<domene>/<slug>/spec/verify-<YYYY-MM-DD>.md` når en oppgave er gitt. Kjører aldri git add/commit/push. Trigges av "verifiser kravene", "er kravene implementert", "tagg kravene som implementert", "sjekk om deprecated-krav kan slettes", "rydd i deprecated", "finnes koden fortsatt", "fs-verify".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
---

# Verify

## Task

$ARGUMENTS

## Din rolle

Du sammenligner kravene med koden, og lukker løkka tilbake til kravene. Du eier to steg på statusaksen i `krav/README.md`:

`@in-progress` →(**`fs-verify`**)→ `@implemented` →(`fs-krav`)→ `@deprecated` →(**`fs-verify`**)→ slettet

- **Ikke skriv eller rett applikasjonskode.** Mangler noe, rapporterer du det.
- **Ikke endre kravinnhold.** Du bytter bare statustaggen på `Egenskap:`-linja, og sletter filer eller blokker som er `@deprecated`.
- **Påstå aldri mer enn du har sett.** Bevis er et konkret sted i koden (`fil:linje`) som du har lest. Et søk uten treff er ikke bevis for at koden er borte, bare at du ikke fant den. Derfor bekrefter brukeren alle retagginger og slettinger.

## Finn scope og kode (gjør dette FØRST)

1. **Krav.** Oppga brukeren en `krav/`-sti (fil eller mappe), bruk den. Oppga brukeren en oppgave (`tasks/<domene>/<slug>`, eller bare slug — slå opp med `Glob` `tasks/*/<slug>/`), les kravene fra `<oppgave>/spec/krav-input/**/*.feature`, og finn de autoritative filene under `krav/` på feature-ID (`@DOM-SUB-KAP-NNN`), ikke filnavn. 0 treff → «ikke funnet under krav/», mer enn 1 → «duplisert feature-ID». Mangler begge, spør.
2. **Kode.** Spør (`AskUserQuestion`) om stien til de lokale klonene av kode-repoene. Foreslå repoer fra `oppgave.md` (lenker), `<lag>/plan-*.md` og `<lag>/task-*-completion.md` når en oppgave er gitt. Sjekk at stiene finnes. Uten kode kan ingenting verifiseres: stopp og si det. Skriv aldri `.claude/spec.local.md`.
3. **Hint.** Når en oppgave er gitt: les `design.md`, `<lag>/plan-*.md` og `<lag>/task-*-completion.md`. Filstier, komponentnavn, GraphQL-felt og ruter derfra er de beste stedene å lete.

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
| `@implemented` uten `@deprecated`-deler | Allerede levert — rapporter, ingen endring |
| `@draft`, `@planned`, ingen status | Ikke klar for verifisering — rapporter, og henvis til `fs-krav` / `fs-specify` |
| To statustagger på `Egenskap:` | Stopp for denne fila og rapporter |

Vis oversikten til brukeren før du gjør noe.

## Verifisere implementasjon (`@in-progress`)

**Gating-sett** = alle `Scenario:`/`Scenariomal:` under `Egenskap:`, minus de som er (selv eller via `Regel:`) tagget `@draft`, `@deprecated`, `@openquestion` eller `@demo`. `Bakgrunn:` er ikke et eget punkt.

Ett krav om gangen:

1. **Let etter hvert gating-scenario i koden.** Bruk hintene fra oppgaven, og søk etter begreper fra scenarioet (tekster i `Så`-stegene, feltnavn i tabellene, handlingen i `Når`). Les treffene. Et scenario er **funnet** når koden du har lest, gjør det scenarioet beskriver. En `Scenariomal:` er funnet når alle radene i `Eksempler:` er dekket.
2. **Se etter tester.** Finnes step definitions i `tester/steps/` for scenarioet, eller tester i kode-repoet som dekker det, nevn dem som ekstra bevis.
3. **Vis resultatet** i chat: feature-ID, tittel, sti, og per scenario `funnet` (med `fil:linje` og én setning om hva koden gjør) / `ikke funnet` / `usikker` (med hvorfor). List scenarioene utenfor gating-settet for seg.
4. **Spør én gang per krav** (`AskUserQuestion`, `multiSelect: false`): «Stemmer vurderingen for `<feature-ID> — <tittel>`?»
   - **Stemmer** — vurderingen er riktig.
   - **Noe mangler** — brukeren vet om noe som ikke virker (spør hva i fritekst).
   - **Kunne ikke verifisere** — ikke mulig å avgjøre nå.
   - **Avbryt** — stopp her.
5. **Retagg `@in-progress` → `@implemented`** bare når gating-settet ikke er tomt, **alle** gating-scenarioer er `funnet`, brukeren svarte **Stemmer**, og ingen `@openquestion` står igjen i fila. Én `Edit` på `Egenskap:`-tag-linja; bare statustaggen byttes: `@OPT-SOK-VIS-001 @must @in-progress` → `@OPT-SOK-VIS-001 @must @implemented`. `@draft`- og `@deprecated`-deler står urørt.

Ellers står kravet som `@in-progress`, og det som mangler, kommer i rapporten.

## Verifisere at koden er borte (`@deprecated`)

Ett krav eller én del om gangen:

1. **Let etter spor.** Feature-ID, scenariotitler, tekster fra `Så`-stegene, feltnavn fra tabellene, og navn fra `design.md`/planer (komponenter, ruter, GraphQL-felt, tabeller). Les treffene, og skill ekte kode fra tilfeldige ordlikheter.
2. **Vis resultatet**: `finnes fortsatt` (med `fil:linje` og hvorfor du mener det er denne funksjonaliteten) eller `ingen spor funnet` (med hva du søkte etter, og i hvilke repoer).
3. **Ingen spor funnet:** spør (`AskUserQuestion`): «Fant ingen spor av `<feature-ID> — <tittel/del>` i `<repoer>`. Slette kravet?» — **Slett** / **Behold** / **Avbryt**. Ved **Slett**:
   - `@deprecated` på `Egenskap:` → slett fila (`rm "<sti>"`). Blir kapabilitetsmappa tom, si fra (ikke slett mappa).
   - `@deprecated` på `Regel:`/`Scenario:` → fjern blokken med én `Edit`: tag-linja, kommentarene rett over og under nøkkelordlinja, og alt til neste blokk på samme eller høyere nivå. Resten av fila står urørt. Les fila etterpå og sjekk at den fortsatt er gyldig Gherkin.
4. **Finnes fortsatt:** kravet blir stående. Det kommer på lista over `@deprecated` som fortsatt finnes i koden.

## Etter endringene

- **Foreldreløse step definitions.** For slettede scenarioer: søk i `tester/steps/` etter stegtekstene. Steg som ikke lenger brukes av noen `.feature`-fil, listes. Ikke slett dem.
- **Tester.** Et `@deprecated` scenario som fortsatt har step definitions, vil feile når koden fjernes. Nevn det.

## Rapport

Skriv rapporten i chat. Når en oppgave er gitt, skriv den også til `<oppgave>/spec/verify-<YYYY-MM-DD>.md` (`-2`, `-3` … hvis fila finnes). Ikke kall den `verification-*.md`: det mønsteret er reservert for `<lag>/` (se *Fire regler* i `tasks/README.md`).

```markdown
# Verifisering: <scope>

- **Dato:** YYYY-MM-DD
- **Krav:** `<krav-sti eller oppgave>`
- **Kode:** `<repo 1>`, `<repo 2>`

## Oppsummering

- Retagget `@in-progress` → `@implemented`: N
- Fortsatt `@in-progress`: N
- Slettet (`@deprecated`): N filer, N regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: N

## Retagget til @implemented

| Feature-ID | Egenskap | Fil | Gating funnet |
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
- **`fs-specify` / `fs-specify-delta`** — setter `@in-progress`.
