---
name: fs-specify-delta
description: Spec / kravarbeid der inputen er en endring, ikke greenfield krav. Tar inn én av fire kildetyper — test-fil(er) (typisk `.feature`), markdown-dokument(er), én commit eller to (`A...B`), eller en branch (diffet mot main) — og henter diff og filinnhold med lokal `git`. For commit/branch utledes `Lagt til` / `Endret` / `Fjernet` direkte fra diff-status. Tar med `@planned`/`@in-progress`-krav og retagger `@planned` → `@in-progress` i `krav/` der fila ligger på disk, også `@planned`-deler (`Regel:`/`Scenario:`) i leverte krav som endres. Tar også med `@deprecated`-krav og -deler i endringen, under «Skal fjernes», uten å bytte taggen, så spec-en kan brukes til å fjerne avviklede krav fra koden sammen med endringene rundt. Samme tag-regler som `fs-specify`; forskjellen er inputen (en endring i stedet for en mappe) og at spec-en viser før og etter. Spør om skisser og persisterer Figma-artefakter via Figma MCP, og kjører `fs-implementasjonsdetaljer` når implementasjonsdetaljene (`<feature>.design.md`) mangler eller ikke har tekstene fra skissene. Kopierer ikke kravene: før og etter er git-referanser (festede SHA-er) med lenker til GitHub. Skriver `spec-changes-<YYYY-MM-DD>-<ref>.md` og `krav-input/changes/<YYYY-MM-DD>-<ref>/` (manifest og skisser) i oppgavemappas krav-undermappe `tasks/<domene>/<slug>/spec/` (én fil per kjøring, ingen overskriving). Leser ingen tidligere spec — kilden er autoritativ; eksisterende krav som ikke nevnes i delta-en forblir gjeldende. Trigges av "kravendring fra commit <sha>", "krav fra A...B", "fang endringene på branch <navn>", "krav fra denne markdown", "krav fra denne test-fila", "delta-spec for <noe>", "fjern avviklede krav på branch <navn>".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, WebFetch, AskUserQuestion, Skill
---

# Specify-delta

## Task

$ARGUMENTS

## Din rolle

Brukeren har en **endring** — en commit, to commits, en branch, en test-fil eller en markdown — og du lager et selvstendig spec-dokument som fanger kravene i endringen.

- **Ikke analyser kode, ikke foreslå løsninger.** Unntaket er den korte sjekken av kravene mot koden før retaggingen (se _Sjekk mot koden_).
- **Ikke les eller sammenlign med tidligere `spec-*.md`.** Endringskilden er autoritativ alene. At eksisterende krav som ikke nevnes forblir gjeldende, er noe du *skriver* i dokumentet — ikke en sammenligning du gjør.
- **Bare `@planned`/`@in-progress`-`.feature`-krav skal bygges, og `@deprecated`-krav og -deler skal fjernes.** Markdown og kode-tester har ingen Gherkin-tag og filtreres ikke. Se _Filter_.
- **Samme tag-regler som `fs-specify`.** Skillene skiller seg på input: `fs-specify` tar en mappe eller et sett med krav, denne tar en endring og viser hva som er lagt til, endret og fjernet.

## Finn oppgavemappa (gjør dette FØRST)

Samme prosedyre som [`fs-specify` → _Finn oppgavemappa_](../fs-specify/SKILL.md#finn-oppgavemappa-gjør-dette-først): resultatet er **`<spec>/` = `tasks/<domene>/<slug>/spec/`**, og reglene i `tasks/README.md` gjelder (ingen `spec-*.md` i oppgave-rota, `spec/` er reservert for krav, ikke skriv `oppgave.md` — det gjør `fs-oppgave`).

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

## Git-referanser i stedet for kopier

Skillen kopierer ikke filer som ligger i git. Før og etter er festede SHA-er, og innholdet leses med `git show <sha>:<sti>`. Spec-en lenker til fila på GitHub på den SHA-en, `https://github.com/sikt-no/fs/blob/<sha>/<sti>` (stien URL-kodet, mellomrom blir `%20`), og viser hvordan endringen hentes lokalt: `git diff <før-sha>...<etter-sha> -- "<sti>"`. Kopier blir utdaterte og gir leseren feil krav; en SHA endres ikke.

Hver krav-bullet har Feature-ID, og slutter med lenken til fila under `krav/` i working tree, relativ fra `spec/` (`../../../../krav/<sti>`). Det er Feature-ID-en `fs-verify` og FS Kravforvaltning slår opp på. For en fil som er fjernet, er før-lenken den siste.

Bare filer som ikke ligger i dette repoet (markdown eller kode-tester fra et annet sted), kopieres til `<spec>/krav-input/changes/<YYYY-MM-DD>-<ref>/<filnavn>`, fordi de ikke har noen git-referanse.

## Endrings-input fra test-fil(er)

1. **Bekreft filene** med brukeren.
2. **`<ref>`-slug:** for én fil, filnavnet uten extension i kebab-case. For flere, spør om en kort beskrivelse. Reserve: `tests`.
3. **Fest HEAD:** `git rev-parse HEAD`. Sjekk om fila har endringer som ikke er committet (`git status --porcelain -- "<sti>"`); i så fall står det i `## Kilde` at kravet slik det er på disk, kommer med i samme PR som spec-en. Filer utenfor repoet kopieres (se over).
4. **`.feature`-filer:** filtrer (se _Filter_). Kravene listes som **Krav**, uten lagt-til/endret-skille.
5. **Kode-tester:** marker som `test-kode`. Hver test er et indirekte krav — beskriv oppførselen.

## Endrings-input fra markdown-dokument(er)

1. **Bekreft filene.**
2. **`<ref>`-slug** fra filnavnet eller brukerens beskrivelse.
3. **Fest HEAD** for filer i repoet, som for test-filer. Filer utenfor repoet kopieres (se over).
4. **Trekk ut konkrete krav** — overskrifter, punktlister, før/etter-tabeller. Er dokumentet for fritt formulert, be brukeren peke ut punktene.

## Endrings-input fra commit(s)

Spør: **«Én commit»** / **«To commits (A...B)»**.

### Én commit

1. **Fest SHA:** `git rev-parse <sha>` → full 40-tegns SHA. `<ref>` = de første 7 tegnene.
2. **Endringsliste:** `git show --name-status --format= <sha>`.
3. **Avgrens** til relevante filer (typisk `krav/**/*.feature` og test-filer). Er lista lang, vis den og spør om noe skal ut.
4. **Fest parent:** `git rev-parse <sha>^` → før-SHA.
5. **Innhold:** etter = `git show <sha>:<sti>`; før (bare `M`/`D`) = `git show <før-sha>:<sti>`. Innholdet leses, ikke lagres.
6. **Filtrer** (se _Filter_).

### To commits (A...B)

Som over, men: fest begge SHA-er, `<ref>` = `<A-kort>..<B-kort>`, endringsliste med `git diff --name-status <A>...<B>`, etter leses på `<B>` og før på `<A>`.

## Endrings-input fra branch

1. **Bekreft branch.**
2. **Fest SHA-er** før noe hentes: `git rev-parse <branch>` og `git rev-parse origin/main`.
3. **`<ref>`** = sanert branch-navn (fjern `<bruker>/`-prefiks, erstatt ikke-alfanumeriske tegn med `-`, slå sammen gjentakelser, trim).
4. **Endringsliste:** `git diff --name-status <main-sha>...<branch-sha>`.
5. **Innhold:** etter på branch-SHA, før (`M`/`D`) på main-SHA.
6. **Filtrer** som for commit. Noter begge SHA-er i manifest og dokument.

## Manifest

Skriv `<spec>/krav-input/changes/<YYYY-MM-DD>-<ref>/manifest.md`:

```markdown
# Manifest — delta <YYYY-MM-DD>-<ref>

- **Type:** `test` / `markdown` / `commit` / `commits` / `branch`
- **Kilde:**
  - test/markdown: kildefiler (repo-relative stier), HEAD-SHA, og om filene har endringer som ikke er committet
  - commit: full SHA, parent-SHA
  - commits: A-SHA, B-SHA
  - branch: branch-navn, branch-SHA, main-SHA
- **Filer:**
  - `<sti>` (`@DOM-SUB-KAP-NNN`) — `<added/modified/removed>`
  - `<filnavn>` — kopiert hit (bare filer utenfor repoet)
- **Skisser:** (hvis noen) URL, `fileKey`/`nodeId`, lagrede artefakter inkl. sub-frame-filnavn, hoppet over (med grunn)
- **Hentet:** `<YYYY-MM-DD HH:MM>`
```

## Filter: bare krav klare til arbeid (`@planned` / `@in-progress`)

Samme regel som [`fs-specify` → _Filter_](../fs-specify/SKILL.md#filter-bare-krav-klare-til-arbeid-planned--in-progress): `Egenskap:`-tag-linja må ha `@planned` eller `@in-progress`, eller kravet er `@deprecated` (se _`@deprecated`-krav og -deler_ under). `@draft`, utaggede og `@implemented` uten `@planned`-, `@in-progress`- eller `@deprecated`-deler faller utenfor. Filteret gjelder bare `.feature`-filer.

Endringen avgjør hvilke filer som vurderes. `@deprecated`-krav som ikke er med i endringen, kommer ikke med. Skal de tas inn uten en endring, bruk `fs-specify` på mappa.

Hvilken tilstand som styrer per diff-status:

- `added` → **etter**-tilstand. En ny fil med bare `@draft` faller utenfor.
- `modified` → **etter**-tilstand. `@draft` → `@planned` er en gyldig «Endret» (før/etter-lenkene viser overgangen). `@planned` → `@draft` er en degradering og faller utenfor.
- `removed` → **før**-tilstand. En slettet `@draft`-fil er opprydding, ikke et bortfalt krav. Det samme er en slettet `@deprecated`-fil: kravet ble avviklet før, og `fs-verify` har slettet det fordi koden er borte.

Test-fil-kilde (uten diff): tag-en på fila slik den er.

**`@draft`-deler** (`Regel:`/`Scenario:` tagget `@draft` inne i et krav som passerer) håndteres som i [`fs-specify` → _`@draft`-deler_](../fs-specify/SKILL.md#draft-deler-i-krav-som-passerer): delene holdes utenfor scope og listes under `### Utenfor scope (@draft)`. Er alle delene `@draft`, faller fila utenfor. For diff-kilder gjelder **etter**-tilstanden per del:

- En del som går fra `@draft` til uten `@draft` er validert, og regnes som «Endret» (eller «Lagt til» hvis den er ny).
- En del som får `@draft` (fra uten) er tatt ut av scope — list den under _Utenfor scope_, ikke under «Endret» eller «Fjernet».
- En ny del som legges til med `@draft`, listes bare under _Utenfor scope_.
- Under en `@implemented` egenskap er en del validert når den går fra `@draft` til `@planned` (se under).

**`@deprecated`-krav og -deler** håndteres som i [`fs-specify` → _`@deprecated`-krav og -deler_](../fs-specify/SKILL.md#deprecated-krav-og--deler): de listes under `### Skal fjernes (@deprecated)`, retagges aldri, og `fs-verify` sletter dem når koden er borte. For diff-kilder gjelder **etter**-tilstanden:

- Et krav eller en del som *blir* `@deprecated` i endringen, listes med lenke til før-tilstanden, så det er tydelig hva som var levert.
- Et krav eller en del som allerede var `@deprecated`, og ligger i en fil som er med i endringen, listes også. Da trengs ingen før-lenke.
- En `@implemented` fil i endringen passerer bare med sine `@deprecated`-deler, og med `@planned`-/`@in-progress`-deler (se under).

**Deler i leverte krav som endres** håndteres som i [`fs-specify` → _Deler i leverte krav som endres_](../fs-specify/SKILL.md#deler-i-leverte-krav-som-endres): egenskapen står som `@implemented`, `@planned`/`@in-progress`-deler skal bygges, og `@deprecated`-delen de erstatter, skal fjernes. For diff-kilder gjelder **etter**-tilstanden per del:

- En del som *blir* `@planned` i endringen (ny, eller fra `@draft`), listes under «Lagt til» (ny blokk) med «erstatter `<tittel>`» når en del samtidig blir `@deprecated`. Den `@deprecated`-delen listes under _Skal fjernes_ med «erstattes av `<tittel>`», og med før-lenke.
- En del som allerede var `@planned`/`@in-progress`, og ligger i en fil som er med i endringen, listes også.
- Resten av fila er levert, og er ikke med i scope selv om fila er med i endringen.

Bare filer som passerer, nevnes i manifestet og spec-en. **Ingen `.feature`-filer passerer** (og det finnes ingen markdown/kode-test å falle tilbake på): rapporter hvilke filer som ble vurdert og hvilken tag de hadde, logg `ended (aborted)`, og foreslå `fs-krav`.

## Sjekk mot koden

Følg [`fs-specify` → _Sjekk mot koden_](../fs-specify/SKILL.md#sjekk-mot-koden) for kravene i delta-en som skal bygges (Lagt til, Endret og `@planned`-deler i leverte krav), ikke for dem som er Fjernet eller bare skal fjernes. Markdown- og kode-test-kilder har ingen Gherkin-krav, og sjekkes ikke. Krav som holdes tilbake, retagges ikke, og står under `## Kodesjekk`.

## Retagg krav til `@in-progress`

Samme regler som [`fs-specify` → _Retagg_](../fs-specify/SKILL.md#retagg-krav-til-in-progress): bare `Egenskap:`-tag-linja (eller `Regel:`-/`Scenario:`-linja for `@planned`-deler i et `@implemented` krav), én `Edit`, `@planned` → `@in-progress`, idempotent, ingen rollback. `@deprecated`-krav og -deler retagges aldri.

**Når:** etter at scope er låst og koden er sjekket, før delta-dokumentet skrives. Krav som holdes tilbake etter kodesjekken, retagges ikke.

| Kilde | Hva skjer |
|---|---|
| Test-fil(er) | Retagg fila direkte |
| Markdown / kode-test | Ingen tag — ingen retagg |
| Commit / commits / branch | Retagg fila i working tree **bare hvis** den finnes der og innholdet er det samme som `git show <etter-sha>:<sti>` (typisk når HEAD er den commiten/branchen). Ellers: sjekkliste under *Retagging utestående* |

For sjekklista: skriv ref-relativ sti og eksakt tag-linje før → etter, så brukeren kan gjøre endringen der branchen er sjekket ut. Skillen sjekker aldri ut branchen selv.

## Skisser

Spør: «Finnes det skisser (mockups, wireframes, Figma, bilder, PDF) knyttet til denne endringen?» — **Ja** / **Nei**.

Ved **Nei**: spør hvorfor (kort), og skriv `Ingen skisse: <grunn>` under `## Skisser`. Uten skisse eller «Ingen skisse» står delta-spec-en som utkast i FS Kravforvaltning (Spesifikasjoner).

Ved **Ja**: følg [`fs-specify` → _Skisser — kobling og validering_](../fs-specify/SKILL.md#skisser--kobling-og-validering), inkludert Figma-henting med sub-frames og avviksspørsmålene, men koble skissene til kravene i *denne* delta-en. Lagre under `<spec>/krav-input/changes/<YYYY-MM-DD>-<ref>/sketches/` (Figma under `sketches/figma/<sketch-slug>/`), og registrer dem i delta-manifestet.

## Implementasjonsdetaljer

Følg [`fs-specify` → _Implementasjonsdetaljer_](../fs-specify/SKILL.md#implementasjonsdetaljer--kjør-fs-implementasjonsdetaljer) for feature-filene i delta-en som skal bygges (Lagt til, Endret og `@planned`-deler i leverte krav), ikke for dem som er Fjernet eller bare skal fjernes. Gi `fs-implementasjonsdetaljer` skissene under `<spec>/krav-input/changes/<YYYY-MM-DD>-<ref>/sketches/`. Kjøres etter skissene, før retaggingen og delta-spec-en.

## Deliverable: `<spec>/spec-changes-<YYYY-MM-DD>-<ref>.md`

Én fil per kjøring — aldri overskriv eller rediger en tidligere delta-fil. Trenger du å kjøre på nytt mot samme kilde samme dag, bruk `-v2` på `<ref>`.

```markdown
# Delta-spec: <kort tittel> — <YYYY-MM-DD>-<ref>

> Eksisterende krav som ikke er nevnt i denne delta-en forblir gjeldende. Endringer her erstatter eller utvider tidligere krav på de berørte områdene.

## Kilde

- **Oppgave:** `tasks/<domene>/<slug>/`
- **Type:** `test` / `markdown` / `commit` / `commits` / `branch`
- **Test/markdown:** kildefiler (lenker til fila i repoet, eller til kopien under `krav-input/changes/<YYYY-MM-DD>-<ref>/` for filer utenfor repoet), HEAD-SHA, og om filene har endringer som ikke er committet
- **Commit:** full SHA (lenke til `https://github.com/sikt-no/fs/commit/<sha>`), parent-SHA
- **Commits:** A-SHA og B-SHA (lenke til `https://github.com/sikt-no/fs/compare/<A>...<B>`)
- **Branch:** navn, branch-SHA, main-SHA (lenke til `https://github.com/sikt-no/fs/compare/<main-sha>...<branch-sha>`)
- **Lokalt:** `git diff <før-sha>...<etter-sha> -- krav/` (bare commit/commits/branch)
- **Hentet:** `<YYYY-MM-DD HH:MM>`

## Omfang

[2–5 setninger om hva endringen dekker og ikke dekker. Vises på kortet i FS Kravforvaltning og i handoff-prompten til kode-repoene.]

## Krav

[Commit/commits/branch: underseksjonene under, basert på diff-status; utelat tomme. Test/markdown: én flat `### Krav`-liste. Før- og etter-lenkene går til GitHub på festet SHA; den siste lenken i hver bullet går til fila under `krav/` i working tree (for `removed`: før-lenken). `<sti>` er URL-kodet i lenkene.]

### Lagt til _(diff-status: `added`)_

- **`<feature-fil>`** (`@DOM-SUB-KAP-NNN`) — hva kravet dekker. ([etter](https://github.com/sikt-no/fs/blob/<etter-sha>/<sti>)) ([<sti>](../../../../<sti>))

### Endret _(diff-status: `modified`)_

- **`<feature-fil>` — scenario `<scenario>`** (`@DOM-SUB-KAP-NNN`) — hva som er endret. ([før](https://github.com/sikt-no/fs/blob/<før-sha>/<sti>)) · ([etter](https://github.com/sikt-no/fs/blob/<etter-sha>/<sti>)) ([<sti>](../../../../<sti>))

### Fjernet _(diff-status: `removed`)_

- **`<feature-fil>`** (`@DOM-SUB-KAP-NNN`) — hva som er fjernet, og hva som var spesifisert. ([før](https://github.com/sikt-no/fs/blob/<før-sha>/<sti>))

### Skal fjernes (`@deprecated`)

[Krav og regler/scenarioer som er `@deprecated` i etter-tilstanden (eller i test-fila). De var levert, og koden skal fjernes. `fs-verify` sletter dem når koden er borte. Utelat hvis tom.]

- **`<feature-fil>`** (`@DOM-SUB-KAP-NNN`) — hele kravet. Ble avviklet i endringen: ([før](https://github.com/sikt-no/fs/blob/<før-sha>/<sti>)) ([<sti>](../../../../<sti>))
- **`<feature-fil>` — regel/scenario `<tittel>`** (`@DOM-SUB-KAP-NNN`) ([<sti>](../../../../<sti>))

### Krav _(test/markdown-kilde)_

- **`<fil eller scenario>`** (`@DOM-SUB-KAP-NNN` for `.feature`) — kravet. ([<sti>](../../../../<sti>), eller kopien under `krav-input/changes/<YYYY-MM-DD>-<ref>/` for filer utenfor repoet)

### Utenfor scope (`@draft`)

[Regler/scenarioer tagget `@draft` i etter-tilstanden. Ikke validert — avklares i `fs-krav`. Utelat hvis tom.]

- **`<feature-fil>` — regel/scenario `<tittel>`** — venter på: <spørsmål fra `# ÅPNE SPØRSMÅL:`>

## Skisser

[Én underseksjon per skisse, samme felter som i `fs-specify`, eller linja `Ingen skisse: <grunn>`.]

## Implementasjonsdetaljer

[Som i `fs-specify`: én linje per feature-fil som har implementasjonsdetaljer. Utelat seksjonen hvis ingen har det.]

- **`<feature-fil>`** — [<feature-navn>.design.md](../../../../krav/<sti>.design.md)

## Kodesjekk

[Som i `fs-specify`: repoene som ble sjekket, eller `Ikke sjekket: <grunn>`, og ett punkt per avvik med beslutningen.]

## Retagging

[Minst én linje om hva som skjedde. Markdown- og kode-test-kilder nevnes ikke.]

| Fil | Før | Etter |
|---|---|---|
| `krav/07 …/opprette_bruker.feature` | `@BRU-ADM-OPP-001 @must @planned` | `@BRU-ADM-OPP-001 @must @in-progress` |
| `krav/07 …/eksportere.feature` — Regel: Eksport til Excel | `@planned` | `@in-progress` |

### Retagging utestående

- [ ] `krav/…/x.feature`: `@… @must @planned` → `@… @must @in-progress`

## Åpne spørsmål

- [ ] Spørsmål 1

## Rute

[Valgfri. Forslag til rekkefølgen på kode-repoene, som i `fs-specify`. Se *Utføring* i `tasks/README.md`.]
```

## Etter delta-spec-en

Spør via `AskUserQuestion`:

- **«Gå gjennom åpne spørsmål»** — ett om gangen; oppdater delta-dokumentet med beslutning og begrunnelse, merk `[x]`.
- **«Stopp her»** — avslutt med oppsummering (sti, antall lagt til / endret / fjernet, retagginger, åpne spørsmål).

Minn brukeren på at endringene i `tasks/` og `krav/` ikke er committet.

## Gjør ikke

- Analyserer ikke kode, foreslår ikke løsninger og skriver ikke kode.
- Leser eller sammenligner ikke tidligere `spec-*.md`.
- Oppretter, endrer eller lukker ikke GitHub-issues.
- Kjører aldri git-kommandoer som endrer tilstand (`add`, `commit`, `push`, `checkout`, `fetch`, `stash`).
- Skriver ikke utenfor `<spec>/` og `Egenskap:`-tag-linjene under `krav/`, bortsett fra implementasjonsdetaljene (`<feature-navn>.design.md`), som `fs-implementasjonsdetaljer` skriver. Fjerner aldri `@draft` fra en `Regel:`/`Scenario:`.

## Retningslinjer

- **Kilden er autoritativ.** Ikke gjett mot kode, ikke sammenlign med tidligere spec.
- **Klassifikasjon kommer fra diff-status** (`A` → Lagt til, `M` → Endret, `D` → Fjernet). Ikke regn den ut manuelt.
- Test/markdown: ikke klassifiser, bare list kravene.
- Hver krav-bullet har Feature-ID, før/etter som GitHub-lenker på festet SHA, og lenke til fila under `krav/`. Kopier bare filer utenfor repoet.
- Vær ærlig om validering: kan du ikke lese en Figma-ramme, skriv `Uavklart`.
- Ett spørsmål om gangen ved skisseavvik.
