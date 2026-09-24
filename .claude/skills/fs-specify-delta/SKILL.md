---
name: fs-specify-delta
description: Spec / kravarbeid der inputen er en endring, ikke greenfield krav. Tar inn én av fire kildetyper — test-fil(er) (typisk `.feature`), markdown-dokument(er), én commit eller to (`A...B`), eller en branch (diffet mot main) — og henter diff og filinnhold med lokal `git`. For commit/branch utledes `Lagt til` / `Endret` / `Fjernet` direkte fra diff-status. Tar bare med `@planned`/`@in-progress`-krav og retagger `@planned` → `@in-progress` i `krav/` der fila ligger på disk. Spør om skisser og persisterer Figma-artefakter via Figma MCP. Skriver `spec-changes-<YYYY-MM-DD>-<ref>.md` og `krav-input/changes/<YYYY-MM-DD>-<ref>/` i oppgavemappas krav-undermappe `tasks/<domene>/<slug>/spec/` (én fil per kjøring, ingen overskriving). Leser ingen tidligere spec — kilden er autoritativ; eksisterende krav som ikke nevnes i delta-en forblir gjeldende. Trigges av "kravendring fra commit <sha>", "krav fra A...B", "fang endringene på branch <navn>", "krav fra denne markdown", "krav fra denne test-fila", "delta-spec for <noe>".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, WebFetch, AskUserQuestion, Skill
---

# Specify-delta

## Task

$ARGUMENTS

## Din rolle

Brukeren har en **endring** — en commit, to commits, en branch, en test-fil eller en markdown — og du lager et selvstendig spec-dokument som fanger kravene i endringen.

- **Ikke analyser kode, ikke foreslå løsninger.**
- **Ikke les eller sammenlign med tidligere `spec-*.md`.** Endringskilden er autoritativ alene. At eksisterende krav som ikke nevnes forblir gjeldende, er noe du *skriver* i dokumentet — ikke en sammenligning du gjør.
- **Bare `@planned`/`@in-progress`-`.feature`-krav skal med.** Markdown og kode-tester har ingen Gherkin-tag og filtreres ikke. Se _Filter_.

## Finn oppgavemappa (gjør dette FØRST)

Samme prosedyre som [`fs-specify` → _Finn oppgavemappa_](../fs-specify/SKILL.md#finn-oppgavemappa-gjør-dette-først): resultatet er **`<spec>/` = `tasks/<domene>/<slug>/spec/`**, og reglene i `tasks/README.md` gjelder (ingen `spec-*.md` i oppgave-rota, `spec/` er reservert for krav, ikke skriv `oppgave.md`).

En delta hører normalt til en oppgave som finnes fra før. Foreslå derfor eksisterende oppgaver først; «Ny oppgave» er fortsatt et gyldig valg.

## Logg kjøringen

Følg formatet i [`fs-specify` → _Logg kjøringen_](../fs-specify/SKILL.md#logg-kjøringen-gjør-dette-andre) — bare Read og Write, ingen shell-konstruksjoner. Finnes ikke `<spec>/spec.log.md`, start med scaffoldet derfra.

```
- <YYYY-MM-DD> — `fs-specify-delta` started — <f.eks. "commit abc1234", "branch foo/bar", "test krav/x.feature">
- <YYYY-MM-DD> — `fs-specify-delta` ended (success) — <f.eks. "wrote spec-changes-2026-06-01-abc1234.md, 2 lagt til / 1 endret / 0 fjernet, 3 retagget @in-progress">
```

## Logg `AskUserQuestion`-kall

Hvert kall appendes til `<spec>/questions-fs-specify-delta-<YYYY-MM-DD>.md` (`-2`, `-3`, … ved flere kjøringer samme dag). Format og prosedyre: [`fs-specify/references/askuserquestion-logging.md`](../fs-specify/references/askuserquestion-logging.md).

## Velg endringskilde

Spør via `AskUserQuestion` hvis invokasjonen ikke allerede sier det:

1. **Test-fil(er)** — én eller flere filer (typisk `.feature`, men også kode-tester).
2. **Markdown-dokument(er)** — fri tekst som beskriver kravet.
3. **Commit(s)** — én commit (diff mot parent) eller to (`A...B`).
4. **Branch** — diff mot `origin/main`.

`multiSelect: false`. "Other" → spør oppfølgende, ikke gjett.

Alle git-kall er **lesende** og kjøres mot dette repoet (`git rev-parse`, `git show`, `git diff`, `git log`). Finnes ikke en ref lokalt, be brukeren kjøre `git fetch` selv — skillen kjører ikke `fetch`, `checkout` eller andre kommandoer som endrer git-tilstand.

## Endrings-input fra test-fil(er)

1. **Bekreft filene** med brukeren.
2. **`<ref>`-slug:** for én fil, filnavnet uten extension i kebab-case. For flere, spør om en kort beskrivelse. Reserve: `tests`.
3. **Les og lagre** hver fil under `<spec>/krav-input/changes/<YYYY-MM-DD>-<ref>/<repo-relativ-sti>`.
4. **`.feature`-filer:** filtrer (se _Filter_). Kravene listes som **Krav**, uten lagt-til/endret-skille.
5. **Kode-tester:** marker som `test-kode`. Hver test er et indirekte krav — beskriv oppførselen.

## Endrings-input fra markdown-dokument(er)

1. **Bekreft filene.**
2. **`<ref>`-slug** fra filnavnet eller brukerens beskrivelse.
3. **Les og lagre** under `<spec>/krav-input/changes/<YYYY-MM-DD>-<ref>/<repo-relativ-sti>`.
4. **Trekk ut konkrete krav** — overskrifter, punktlister, før/etter-tabeller. Er dokumentet for fritt formulert, be brukeren peke ut punktene.

## Endrings-input fra commit(s)

Spør: **«Én commit»** / **«To commits (A...B)»**.

### Én commit

1. **Fest SHA:** `git rev-parse <sha>` → full 40-tegns SHA. `<ref>` = de første 7 tegnene.
2. **Endringsliste:** `git show --name-status --format= <sha>`.
3. **Avgrens** til relevante filer (typisk `krav/**/*.feature` og test-filer). Er lista lang, vis den og spør om noe skal ut.
4. **Innhold:** etter = `git show <sha>:<sti>`; før (bare `M`/`D`) = `git show <sha>^:<sti>`.
5. **Filtrer** (se _Filter_).
6. **Lagre:** etter under `<spec>/krav-input/changes/<YYYY-MM-DD>-<ref>/<sti>`, før under `…/before/<sti>`.

### To commits (A...B)

Som over, men: fest begge SHA-er, `<ref>` = `<A-kort>..<B-kort>`, endringsliste med `git diff --name-status <A>...<B>`, etter hentes på `<B>` og før på `<A>`.

## Endrings-input fra branch

1. **Bekreft branch.**
2. **Fest SHA-er** før noe hentes: `git rev-parse <branch>` og `git rev-parse origin/main`.
3. **`<ref>`** = sanert branch-navn (fjern `<bruker>/`-prefiks, erstatt ikke-alfanumeriske tegn med `-`, slå sammen gjentakelser, trim).
4. **Endringsliste:** `git diff --name-status <main-sha>...<branch-sha>`.
5. **Innhold:** etter på branch-SHA, før (`M`/`D`) på main-SHA.
6. **Filtrer** og **lagre** som for commit. Noter begge SHA-er i manifest og dokument.

## Manifest

Skriv `<spec>/krav-input/changes/<YYYY-MM-DD>-<ref>/manifest.md`:

```markdown
# Manifest — delta <YYYY-MM-DD>-<ref>

- **Type:** `test` / `markdown` / `commit` / `commits` / `branch`
- **Kilde:**
  - test/markdown: kildefiler (repo-relative stier)
  - commit: full SHA, parent-SHA
  - commits: A-SHA, B-SHA
  - branch: branch-navn, branch-SHA, main-SHA
- **Hentede filer:**
  - `<sti>` — `<added/modified/removed>`
- **Skisser:** (hvis noen) URL, `fileKey`/`nodeId`, lagrede artefakter inkl. sub-frame-filnavn, hoppet over (med grunn)
- **Hentet:** `<YYYY-MM-DD HH:MM>`
```

## Filter: bare krav klare til arbeid (`@planned` / `@in-progress`)

Samme regel som [`fs-specify` → _Filter_](../fs-specify/SKILL.md#filter-bare-krav-klare-til-arbeid-planned--in-progress): `Egenskap:`-tag-linja må ha `@planned` eller `@in-progress`. `@draft`, utaggede og `@implemented` faller utenfor. Filteret gjelder bare `.feature`-filer.

Hvilken tilstand som styrer per diff-status:

- `added` → **etter**-tilstand. En ny fil med bare `@draft` faller utenfor.
- `modified` → **etter**-tilstand. `@draft` → `@planned` er en gyldig «Endret» (før/etter-lenkene viser overgangen). `@planned` → `@draft` er en degradering og faller utenfor.
- `removed` → **før**-tilstand. En slettet `@draft`-fil er opprydding, ikke et bortfalt krav.

Test-fil-kilde (uten diff): tag-en på fila slik den er.

**`@draft`-deler** (`Regel:`/`Scenario:` tagget `@draft` inne i et krav som passerer) håndteres som i [`fs-specify` → _`@draft`-deler_](../fs-specify/SKILL.md#draft-deler-i-krav-som-passerer): råkopiene lagres komplette, men delene holdes utenfor scope og listes under `### Utenfor scope (@draft)`. Er alle delene `@draft`, faller fila utenfor. For diff-kilder gjelder **etter**-tilstanden per del:

- En del som går fra `@draft` til uten `@draft` er validert, og regnes som «Endret» (eller «Lagt til» hvis den er ny).
- En del som får `@draft` (fra uten) er tatt ut av scope — list den under _Utenfor scope_, ikke under «Endret» eller «Fjernet».
- En ny del som legges til med `@draft`, listes bare under _Utenfor scope_.

Bare filer som passerer lagres og nevnes i manifestet. **Ingen `.feature`-filer passerer** (og det finnes ingen markdown/kode-test å falle tilbake på): rapporter hvilke filer som ble vurdert og hvilken tag de hadde, logg `ended (aborted)`, og foreslå `fs-krav`.

## Retagg krav til `@in-progress`

Samme regler som [`fs-specify` → _Retagg_](../fs-specify/SKILL.md#retagg-krav-til-in-progress): bare `Egenskap:`-tag-linja, én `Edit`, `@planned` → `@in-progress`, idempotent, ingen rollback. Råkopiene under `krav-input/changes/…` — også `before/` — retagges aldri.

**Når:** etter at scope er låst og råkopiene er lagret, før delta-dokumentet skrives.

| Kilde | Hva skjer |
|---|---|
| Test-fil(er) | Retagg fila direkte |
| Markdown / kode-test | Ingen tag — ingen retagg |
| Commit / commits / branch | Retagg fila i working tree **bare hvis** den finnes der og innholdet matcher det som ble hentet på den festede SHA-en (typisk når HEAD er den commiten/branchen). Ellers: sjekkliste under *Retagging utestående* |

For sjekklista: skriv ref-relativ sti og eksakt tag-linje før → etter, så brukeren kan gjøre endringen der branchen er sjekket ut. Skillen sjekker aldri ut branchen selv.

## Skisser

Spør: «Finnes det skisser (mockups, wireframes, Figma, bilder, PDF) knyttet til denne endringen?» — **Ja** / **Nei**.

Ved **Ja**: følg [`fs-specify` → _Skisser — kobling og validering_](../fs-specify/SKILL.md#skisser--kobling-og-validering), inkludert Figma-henting med sub-frames og avviksspørsmålene, men koble skissene til kravene i *denne* delta-en. Lagre under `<spec>/krav-input/changes/<YYYY-MM-DD>-<ref>/sketches/` (Figma under `sketches/figma/<sketch-slug>/`), og registrer dem i delta-manifestet.

## Deliverable: `<spec>/spec-changes-<YYYY-MM-DD>-<ref>.md`

Én fil per kjøring — aldri overskriv eller rediger en tidligere delta-fil. Trenger du å kjøre på nytt mot samme kilde samme dag, bruk `-v2` på `<ref>`.

```markdown
# Delta-spec: <kort tittel> — <YYYY-MM-DD>-<ref>

> Eksisterende krav som ikke er nevnt i denne delta-en forblir gjeldende. Endringer her erstatter eller utvider tidligere krav på de berørte områdene.

## Kilde

- **Oppgave:** `tasks/<domene>/<slug>/`
- **Type:** `test` / `markdown` / `commit` / `commits` / `branch`
- **Test/markdown:** kildefiler (lenker til `krav-input/changes/<YYYY-MM-DD>-<ref>/…`)
- **Commit:** full SHA (lenke til `https://github.com/sikt-no/fs/commit/<sha>`), parent-SHA
- **Commits:** A-SHA og B-SHA
- **Branch:** navn, branch-SHA, main-SHA
- **Hentet:** `<YYYY-MM-DD HH:MM>`

## Krav

[Commit/commits/branch: underseksjonene under, basert på diff-status; utelat tomme. Test/markdown: én flat `### Krav`-liste.]

### Lagt til _(diff-status: `added`)_

- **`<feature-fil>`** (`@DOM-SUB-KAP-NNN`) — hva kravet dekker. ([etter](krav-input/changes/<YYYY-MM-DD>-<ref>/<sti>))

### Endret _(diff-status: `modified`)_

- **`<feature-fil>` — scenario `<scenario>`** — hva som er endret.
  - Før: ([before/<sti>](krav-input/changes/<YYYY-MM-DD>-<ref>/before/<sti>))
  - Etter: ([<sti>](krav-input/changes/<YYYY-MM-DD>-<ref>/<sti>))

### Fjernet _(diff-status: `removed`)_

- **`<feature-fil>`** — hva som er fjernet, og hva som var spesifisert. ([before/<sti>](krav-input/changes/<YYYY-MM-DD>-<ref>/before/<sti>))

### Krav _(test/markdown-kilde)_

- **`<fil eller scenario>`** — kravet. ([<sti>](krav-input/changes/<YYYY-MM-DD>-<ref>/<sti>))

### Utenfor scope (`@draft`)

[Regler/scenarioer tagget `@draft` i etter-tilstanden. Ikke validert — avklares i `fs-krav`. Utelat hvis tom.]

- **`<feature-fil>` — regel/scenario `<tittel>`** — venter på: <spørsmål fra `# ÅPNE SPØRSMÅL:`>

## Skisser

[Én underseksjon per skisse, samme felter som i `fs-specify`, eller «Ingen skisser registrert».]

## Retagging

[Minst én linje om hva som skjedde. Markdown- og kode-test-kilder nevnes ikke.]

| Fil | Før | Etter |
|---|---|---|
| `krav/07 …/opprette_bruker.feature` | `@BRU-ADM-OPP-001 @must @planned` | `@BRU-ADM-OPP-001 @must @in-progress` |

### Retagging utestående

- [ ] `krav/…/x.feature`: `@… @must @planned` → `@… @must @in-progress`

## Åpne spørsmål

- [ ] Spørsmål 1
```

## Etter delta-spec-en

Spør via `AskUserQuestion`:

- **«Gå gjennom åpne spørsmål»** — ett om gangen; oppdater delta-dokumentet med beslutning og begrunnelse, merk `[x]`.
- **«Stopp her»** — avslutt med oppsummering (sti, antall lagt til / endret / fjernet, retagginger, åpne spørsmål).

Minn brukeren på at endringene i `tasks/` og `krav/` ikke er committet.

## Gjør ikke

- Analyserer ikke kode, foreslår ikke løsninger og skriver ikke kode.
- Leser eller sammenligner ikke tidligere `spec-*.md`.
- Oppretter, endrer eller lukker ikke GitHub-issues — det er `fs-krav`.
- Kjører aldri git-kommandoer som endrer tilstand (`add`, `commit`, `push`, `checkout`, `fetch`, `stash`).
- Skriver ikke utenfor `<spec>/` og `Egenskap:`-tag-linjene under `krav/`. Fjerner aldri `@draft` fra en `Regel:`/`Scenario:`.

## Retningslinjer

- **Kilden er autoritativ.** Ikke gjett mot kode, ikke sammenlign med tidligere spec.
- **Klassifikasjon kommer fra diff-status** (`A` → Lagt til, `M` → Endret, `D` → Fjernet). Ikke regn den ut manuelt.
- Test/markdown: ikke klassifiser, bare list kravene.
- Hver bullet peker til en konkret fil under `krav-input/changes/<YYYY-MM-DD>-<ref>/`.
- Vær ærlig om validering: kan du ikke lese en Figma-ramme, skriv `Uavklart`.
- Ett spørsmål om gangen ved skisseavvik.
