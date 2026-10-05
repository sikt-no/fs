---
name: fs-specify
description: Spec / kravarbeid for én konkret feature i dette repoet. Henter `@planned`-krav fra lokale `.feature`-filer under `krav/`, retagger dem `@planned` → `@in-progress` på `Egenskap:`-linja (og på `Regel:`/`Scenario:`-linja for `@planned`-deler i leverte krav som endres), og plukker også opp `@deprecated`-krav (egenskaper og `Regel:`/`Scenario:`) for å fjerne koden (de beholder `@deprecated`), spør via AskUserQuestion om det finnes skisser (Figma, bilder, PDF), kobler skisser til krav, persisterer Figma-artefakter via Figma MCP, validerer skisser mot krav og spør brukeren ved avvik. Skriver `spec-<feature>.md`, `krav-input/` og `spec.log.md` i oppgavemappas krav-undermappe `tasks/<domene>/<slug>/spec/` (se `tasks/README.md`). Idempotent — spec-dokumentet skrives over på plass. Trigges av "spesifiser feature X", "hent krav fra lokale .feature-filer", "lag spec for oppgave Y", "koble skisser til krav", "hent krav inn i tasks", "fjerne deprecated krav", "spec for å fjerne avviklede krav".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, WebFetch, AskUserQuestion, Skill
---

# Specify

## Task

$ARGUMENTS

## Din rolle

Du samler krav. Du henter kravene fra `.feature`-filene under `krav/`, kobler dem til eventuelle skisser, validerer at skisser og krav stemmer overens, og skriver et kort spec-dokument som kan brukes som fasit for hva som skal bygges.

**Ikke analyser kodebaser, ikke foreslå løsninger, ikke skriv kode.** Spec-en beskriver *hva*, ikke *hvordan*.

**Bare `@planned`/`@in-progress`-krav skal med.** `@draft` og utaggede `Egenskap:`-blokker er fortsatt under arbeid og må gjennom `fs-krav` først. Det samme gjelder `@draft`-deler (`Regel:`/`Scenario:`) inne i et `@planned` krav — de holdes utenfor scope. `@deprecated`-krav og -deler tas med, men som noe som skal **fjernes**, ikke bygges. I et `@implemented` krav som endres, er det `@planned`/`@in-progress`-delene som skal bygges. Se _Filter_ nedenfor.

**Input er en mappe eller et sett med krav.** Er input en endring (branch, commit, test-fil eller markdown), eller skal spec-en vise hva som er endret i et krav, bruk `fs-specify-delta`. Tag-reglene er de samme i begge.

**Spesifikasjon laget i FS Kravforvaltning.** I visningen «Spesifikasjoner» plukker brukeren hele krav og skriver omfang og skisser selv, og vieweren skriver `tasks/<domene>/<slug>/spec/spec-<slug>.md`. Peker invokasjonen på en slik fil (eller gir en liste med feature-filer):

- Oppgavemappa er mappa fila ligger i, og spec-filnavnet beholdes.
- Kravene er feature-filene under `## Krav` (slått opp på Feature-ID). Ta med alt som er `@planned` eller `@deprecated` i hver fil, etter filteret under. Spør ikke etter mappe eller filer.
- Skissene og «Ingen skisse» står under `## Skisser`. Spør ikke om det finnes skisser; hent Figma-artefakter og valider skissene mot kravene som vanlig.
- `## Omfang`, `## Rute` og skissene brukeren har skrevet, beholdes når spec-en skrives over.
- I Claude-panelet i FS Kravforvaltning finnes ikke `AskUserQuestion`: still spørsmålene i svaret, og vent på brukeren.

## Finn oppgavemappa (gjør dette FØRST)

Alt denne skillen skriver havner i krav-undermappa til én oppgave: **`<spec>/` = `tasks/<domene>/<slug>/spec/`**. Strukturen og reglene er beskrevet i [`tasks/README.md`](../../../tasks/README.md) — den er autoritativ.

1. **Oppga brukeren en sti eller slug** i invokasjonen (`tasks/opptak/registrere-praksis`, `registrere-praksis`, eller en full sti til `.../spec/`), bruk den. En slug slås opp med `Glob` `tasks/*/<slug>/`; gir den mer enn ett treff, spør hvilken.
2. **Ellers:** list oppgavemappene `tasks/<domene>/<slug>/` (alle mapper på det nivået, unntatt `mal/`; de fleste har `oppgave.md`) og vis oppgavene som finnes via `AskUserQuestion` (de mest relevante, gjerne filtrert på domenet brukeren nevner), pluss **«Ny oppgave»**.
3. **Ny oppgave:** spør om `domene` — bare verdier fra domenetabellen i `tasks/README.md` er gyldige — og en kebab-case `slug` (lesbar beskrivelse, ikke issue-nummer; unik innenfor domenet). Opprett bare `tasks/<domene>/<slug>/spec/`. **Skriv ikke `oppgave.md`** — si til brukeren at den lages med `fs-oppgave` (fra [`tasks/mal/oppgave.md`](../../../tasks/mal/oppgave.md)).
4. **Opprett `<spec>/`** hvis den ikke finnes.

Regler fra `tasks/README.md` som denne skillen må følge:

- **Aldri `spec-*.md` i oppgave-rota** — kun i `spec/`. Andre verktøy globber mønsteret for å avgjøre hvilke steg som er gjort.
- **`spec/` er reservert for krav.** Skillen skriver bare i `<spec>/` (og retagger kravfiler under `krav/`); den rører ikke andre undermapper i oppgava.

## Logg kjøringen (gjør dette ANDRE)

Hver kjøring skriver en `started`-linje til `<spec>/spec.log.md` når den begynner og en `ended`-linje før den avslutter. Loggen er et artefakt andre leser for å se hva som har kjørt og hvordan det endte.

Bruk **bare Read og Write** — ikke `bash`, `printf`, `date` eller `>>`. Prosedyren skal virke likt på macOS, Linux og Windows.

### Format

```markdown
# Spec log

History of skill invocations for this spec. Append-only — never edit past entries.

## Invocations

- 2026-05-22 — `fs-specify` started — krav/07 …/applikasjoner
- 2026-05-22 — `fs-specify` ended (success) — wrote spec-applikasjoner.md, 3 .feature files, 3 retagged @in-progress, 2 sketches linked
```

Hver linje: `- <YYYY-MM-DD> — \`<skill-navn>\` <event> — <notat>` (notatet er valgfritt for `started`, påkrevd for `ended`). Events: `started`, `ended (success)`, `ended (aborted)`, `ended (error)`. Datoen er kun dato; linjerekkefølgen gir rekkefølgen innenfor en dag. Formatet er delt med andre verktøy som skriver til samme logg — ikke endre det.

**Start:** Read `<spec>/spec.log.md`. Finnes den ikke, start med scaffoldet over (uten linjer). Legg til `started`-linja med dagens dato fra samtalekonteksten (`# currentDate`) og Write hele innholdet tilbake.

**Slutt:** samme Read → append → Write med `ended (success)` og et kort resultat. Bruk `ended (aborted)` hvis brukeren avbrøt, og `ended (error)` ved manglende forutsetning. **Er krav allerede retagget `@in-progress` før et avbrudd, si det i linja** — retaggen rulles ikke tilbake. **Logg alltid slutten.**

## Logg `AskUserQuestion`-kall

Hvert `AskUserQuestion`-kall i kjøringen appendes til `<spec>/questions-fs-specify-<YYYY-MM-DD>.md` (`-2`, `-3`, … hvis fila finnes fra før i dag). Filnavnet bestemmes én gang, rett etter `started`-linja; fila opprettes først ved første spørsmål. Format og prosedyre: [`references/askuserquestion-logging.md`](references/askuserquestion-logging.md).

## Krav-input fra lokale filer

1. **Bekreft mappen/filen** med brukeren før du leser — vis foreslått sti under `krav/` og spør hvis den ikke er entydig. Mangler sti helt, spør om den (bruk `krav/krav-oversikt.md` for å hjelpe brukeren å finne riktig kapabilitet). Er input en liste med feature-filer eller en spesifikasjon fra FS Kravforvaltning, er filene gitt: hopp over dette.
2. **List filene** under stien som matcher `**/*.feature` (eller bruk lista).
3. **Filtrer** — se _Filter_ nedenfor.
4. **Lagre råkopier** av filene som passerte under `<spec>/krav-input/local/<repo-relativ-sti>.feature` (samme stistruktur som i `krav/`), slik at spec-en er reproduserbar selv om kildefilene endres senere.
5. **Skriv `<spec>/krav-input/manifest.md`**: kildemappe (repo-relativ), liste over filer som er med, hentet-tidspunkt, og — hvis Figma-skisser hentes — Figma-URL, `fileKey`/`nodeId`, hvilke artefakter som ble lagret og hvilke som ble hoppet over (med grunn). Manifestet speiler **gjeldende** scope; filer som ble filtrert bort nevnes ikke.

## Filter: bare krav klare til arbeid (`@planned` / `@in-progress`)

En `.feature`-fil passerer hvis `Egenskap:`-tag-linja har **`@planned` eller `@in-progress`**, eller hvis kravet er avviklet (se _`@deprecated`-krav og -deler_ under). Andre tags på enkelt-`Regel:`/`Scenario:` påvirker ikke om fila passerer — med unntak av `@draft` og `@deprecated`, se _`@draft`-deler_ og _`@deprecated`-deler_ under.

- `@in-progress` må passere fordi skillen selv setter den (se _Retagg_). Ellers ville en ny kjøring mot samme krav filtrert bort alt.
- `@implemented` passerer **ikke** — kravet er levert; en ny iterasjon går via `fs-krav` (modus D). Unntak: har fila `@planned`-, `@in-progress`- eller `@deprecated`-deler, passerer den med bare de delene (se _Deler i leverte krav som endres_ under).
- `@deprecated` passerer — kravet er avviklet, og spec-en er en bestilling om å fjerne koden (se *Avvikling* i `krav/README.md`).
- `@draft` og utaggede passerer ikke.

**Ingen filer passerer:** rapporter hvilke filer som ble vurdert og hvilken tag de hadde, logg `ended (aborted)`, og foreslå `fs-krav` for å ferdigstille kravene først.

### `@draft`-deler i krav som passerer

Et `@planned`/`@in-progress` krav kan bevisst ha enkelte `Regel:`- eller `Scenario:`/`Scenariomal:`-blokker tagget `@draft @openquestion` (se *Delvis utkast* i `krav/README.md`). Disse delene er **ikke validert** og holdes utenfor spec-ens scope:

- `@draft` på en `Regel:` gjelder alle scenarioene under den. `@draft` på et scenario gjelder bare det scenarioet.
- Råkopien under `krav-input/local/` lagres fortsatt **uendret og komplett** — filtreringen skjer i spec-dokumentet, ikke i råkopien.
- Delene listes under `### Utenfor scope (@draft)` i spec-ens `## Krav`, med tittel og spørsmålene fra `# ÅPNE SPØRSMÅL:` under delen. De legges **ikke** under spec-ens `## Åpne spørsmål` — de avklares i `fs-krav`, ikke her.
- Retaggingen til `@in-progress` gjelder `Egenskap:` som vanlig. `@draft`-taggene på delene står urørt.
- Er **alle** regler/scenarioer i fila `@draft`, er det ingenting igjen i scope: behandle fila som om den ikke passerte (ingen råkopi, ingen retagging), og nevn den i rapporten med forslag om `fs-krav`.

### `@deprecated`-krav og -deler

Et krav som er `@deprecated` på `Egenskap:`, eller en `Regel:`/`Scenario:`/`Scenariomal:` tagget `@deprecated` under en `@implemented`/`@in-progress` egenskap, var levert, men skal fjernes (se *Avvikling* i `krav/README.md`). De er med i scope, men som noe som skal **fjernes**:

- `@deprecated` på en `Regel:` gjelder alle scenarioene under den. Råkopien lagres uendret og komplett.
- De listes under `### Skal fjernes (@deprecated)` i spec-ens `## Krav`, med tittel. Scenarioene beskriver det som skal bort, ikke det som skal bygges.
- **Retagges aldri.** `@deprecated` blir stående til `fs-verify` har vist at koden er borte, og sletter kravet eller delen. En `@implemented` egenskap som bare er med på grunn av `@deprecated`-deler, blir også stående som `@implemented`.
- Er alle delene i et `@planned`/`@in-progress` krav `@draft` eller `@deprecated`, er det ingenting å bygge: ingen retagging til `@in-progress`, men `@deprecated`-delene er med under _Skal fjernes_.

### Deler i leverte krav som endres

Når et levert krav endres, blir egenskapen stående som `@implemented`, og statusen står på delen (se *Endring av levert krav* i `krav/README.md`):

- `@planned`- og `@in-progress`-deler skal **bygges**. De listes under `## Krav` med fil og tittel på delen. Resten av fila er levert og er ikke med i scope.
- `@deprecated`-deler skal **fjernes**, som over. Erstatter en ny del en `@deprecated`-del, nevn det på begge linjene («erstatter …» / «erstattes av …»), så det er tydelig at de hører sammen.
- `@draft`-deler holdes utenfor scope, som i et `@planned` krav.
- `@planned`-delene retagges til `@in-progress` (se _Retagg_). `Egenskap:`-taggen står urørt.

## Retagg krav til `@in-progress`

Når et krav hentes inn i en spec, retagges den **autoritative** fila under `krav/` fra `@planned` til `@in-progress` på `Egenskap:`-tag-linja (se tag-aksen i `krav/README.md`).

For `@planned`-deler i et `@implemented` krav retagges `Regel:`-/`Scenario:`-linja i stedet (se under).

**Når:** etter at scope er låst og råkopiene er lagret under `krav-input/`, men **før** spec-dokumentet skrives.

**Regler:**

- **Bare `Egenskap:`-tag-linja endres**, med én `Edit`. `@planned` byttes med `@in-progress`; Feature-ID, MoSCoW-tag og øvrige tags står urørt. Eksempel: `@BRU-ADM-OPP-001 @must @planned` → `@BRU-ADM-OPP-001 @must @in-progress`.
- **Deler i leverte krav:** `@planned` byttes med `@in-progress` på `Regel:`-/`Scenario:`/`Scenariomal:`-linja, med én `Edit` per del. Andre tags på linja står urørt, og `Egenskap:`-linja endres ikke. Eksempel: `  @planned` → `  @in-progress` over `Regel: Eksport til Excel`.
- **`krav-input/`-kopiene retagges aldri.** De viser kravet slik det var ved henting.
- **Idempotent.** En fil som allerede er `@in-progress` hoppes over og telles som «allerede i arbeid».
- **Ingen rollback** ved senere avbrudd — kravet *er* plukket opp. Si det i `ended`-linja.

## Skisser — kobling og validering

En spesifikasjon skal ha minst én skisse, eller `Ingen skisse: <grunn>` under `## Skisser` (f.eks. «bare API», «batchjobb»). Uten det står den som utkast i FS Kravforvaltning. Står skissene allerede i spesifikasjonen (laget i vieweren), spør ikke på nytt: gå rett til henting og validering.

Ellers, etter at kravene er hentet, spør (`AskUserQuestion`):

> "Finnes det skisser (mockups, wireframes, Figma, bilder, PDF) for kravene i denne spec-en?"

Options: **Ja** / **Nei**. `multiSelect: false`. "Other" som "vet ikke — sjekk Figma-prosjektet vårt" behandles som ja med oppfølgingsspørsmål. Ved **Nei**, spør hvorfor (kort), og skriv `Ingen skisse: <grunn>`.

### Hvis «Ja»

Spør hva slags skisser: **Figma-lenke(r)** / **Lokal fil (bilde/PDF)** / **Begge**. "Other" (Miro, Confluence, …) registreres med URL.

For hver skisse, samle inn:

- **Type**: `figma` / `lokal-bilde` / `lokal-pdf` / `annet`
- **Referanse**: URL eller sti
- **Tittel**: kort menneskelig referanse (spør hvis det ikke er åpenbart)
- **Hvilke krav den dekker**: én eller flere `.feature`-filer eller scenarier. Foreslå koblinger ut fra titler og scenario-overskrifter hvis brukeren ikke vet, men la brukeren bekrefte.

Lokale skissefiler kopieres til `<spec>/krav-input/sketches/<filnavn>` (`cp` via Bash). Andre URL-skisser registreres bare med URL.

### Figma-skisser — hent og lagre via Figma MCP

Er en Figma-MCP-server koblet til, persisteres artefaktene under `<spec>/krav-input/sketches/figma/<sketch-slug>/` så spec-en er reproduserbar uten Figma-tilgang.

**Ikke hardkod servernavnet.** Bruk serverens kapabiliteter (verktøy som `get_screenshot`, `get_design_context` / `get_metadata`, `get_variable_defs`, `download_assets`). Kallene står ikke i `allowed-tools`, så forvent en tillatelses-prompt første gang. I FS Kravforvaltning er det et kort i Claude-panelet («Tillat», «Tillat alltid i denne samtalen», «Avvis»). Avviser brukeren et kall, prøv ikke igjen uten å spørre.

1. **Parse URL-en** til `fileKey` og `nodeId` (`node-id`-parameteren med `-` byttet til `:`). Mangler `node-id`, hent på fil-/side-nivå.
2. **`<sketch-slug>`** = skissens tittel i kebab-case.
3. **Hent og lagre** (hopp over typer serveren ikke har, og noter det):
   - `get_screenshot` av root-noden → `screenshot.png`
   - `get_design_context` (eller `get_metadata`) → `design-context.md`. **Hent denne før sub-frames** — hierarkiet brukes til å finne dem.
   - **Sub-frames:** hver direkte child av root med type `FRAME`, `COMPONENT`, `COMPONENT_SET` eller `INSTANCE` og et meningsbærende navn (ikke `Frame 12`) hentes med `get_screenshot` til `sub-frames/<NN>-<node-navn-kebab>.png` (`NN` = to-sifret rekkefølge). Bare ett nivå dypt. Er root selv én enkelt frame uten meningsbærende children, hopp over sub-frames.
   - `get_variable_defs` → `variables.md` (eller `tokens.json`)
   - `download_assets` → `assets/`
   - **Bilder i FS Kravforvaltning:** finnes `mcp__kravforvaltning__save_sketch`, lagres hver PNG med den, med `tool_use_id` fra `get_screenshot`-kallet og stien over (relativ til repoet). Write kan ikke skrive binærdata. Uten den lagres bildene som før.
4. **Registrer** alt i `krav-input/manifest.md`.
5. **Ingen Figma-MCP tilkoblet** (ingen `mcp__*`-verktøy med `get_screenshot` eller `get_design_context`): stopp skissehentingen, og si til brukeren at Figma-MCP må legges til og logges inn én gang med den lokale Claude Code-CLI-en, i terminalen:
   1. `claude mcp add --transport http --scope user figma https://mcp.figma.com/mcp`
   2. `claude`, så `/mcp` → `figma` → logg inn i nettleseren.

   Bruk navnet `figma`: innloggingen er knyttet til navnet. Med `--scope user` gjelder den i alle mapper. FS Kravforvaltning tar den med av seg selv, også når den er lagt til i en annen mappe (uten `--scope user`). Spør så om brukeren vil gjøre det nå og kjøre skissesteget på nytt, eller fortsette uten: prøv da `WebFetch` på URL-en, ellers be brukeren beskrive innholdet, og noter i spec-en at artefaktene ikke kunne persisteres.
6. **Figma-MCP finnes, men er ikke logget inn** (kallet feiler med en feil om innlogging, eller FS Kravforvaltning viser at serveren må logges inn): si at brukeren må kjøre `claude` i terminalen og `/mcp` → `figma` → logg inn, én gang. Innlogging kan ikke startes fra FS Kravforvaltning eller fra `claude -p`. Gå så videre som i punkt 5.

### Validering — skisse vs. krav

Les hver skisse (lokale filer og persisterte Figma-artefakter via `Read`) og sammenlign med scenariene i de koblede `.feature`-filene. Klassifiser som **én** av:

- **OK** — skissen viser det samme som kravene.
- **Avvik** — skissen viser noe kravene ikke har, eller mangler noe kravene krever. Beskriv konkret.
- **Uavklart** — kan ikke vurderes (rammen er utilgjengelig, skissen er for grov). Beskriv hvorfor.

### Ved avvik — spør brukeren

Én skisse om gangen, via `AskUserQuestion`:

> "Skissen `<tittel>` ser ut til å avvike fra kravene: `<beskrivelse>`. Hva skal vi gjøre?"

1. **Skissen er riktig — kravene mangler** → registreres som «krav mangler», åpent spørsmål for `fs-krav`.
2. **Kravene er riktige — skissen er utdatert** → skissen markeres som utdatert.
3. **Begge er riktige — ulikt scope** → koble skissen til riktig scope og noter at den ikke dekker hele kravet.
4. **Vet ikke** → åpent spørsmål uten beslutning.

**Uavklart**-skisser registreres som åpne spørsmål uten å blokkere.

## Idempotens — re-kjøring mot samme oppgave

Å kjøre skillen på nytt mot samme `<spec>/` er normalt. Resultatet er én stabil sti per artefakt:

- **`spec-<feature>.md` skrives over på plass** — aldri `-v2`. Andre kan alltid peke på `tasks/<domene>/<slug>/spec/spec-<feature>.md` for gjeldende krav. `## Omfang` og `## Rute` som finnes, beholdes (de kan være skrevet i FS Kravforvaltning). Skrives `## Omfang` for første gang, foreslå en tekst ut fra kravene og la brukeren bekrefte den.
- **`krav-input/manifest.md` og `krav-input/local/…` overskrives** så de beskriver gjeldende scope.
- **Figma-artefakter** på samme `<sketch-slug>` overskrives.
- **Retaggen** er idempotent.

Bevisste unntak: **`spec.log.md`** er append-only, og **`questions-fs-specify-<dato>[-N].md`** er én fil per kjøring.

## Deliverable: `<spec>/spec-<feature>.md`

```markdown
# Spec: <Feature Name>

## Kilde

- **Oppgave:** `tasks/<domene>/<slug>/`
- **Kilde-mappe:** `krav/<…>`
- **GitHub:** `#NNNN` (fra `# GitHub:`-linjene i kravfilene, klikkbare lenker til `sikt-no/fs`. Utelat linja hvis ingen kravfil har en)
- **Hentet:** `<YYYY-MM-DD HH:MM>`

## Omfang

[2–5 setninger om hva spesifikasjonen dekker og ikke dekker. Vises på kortet i FS Kravforvaltning og i handoff-prompten til kode-repoene.]

## Krav

[`@planned`/`@in-progress`-krav som skal bygges, og `@planned`/`@in-progress`-deler i leverte krav som endres. Én bullet per `.feature`-fil eller scenario, med lenke til råkopien. Ikke kopier feature-innhold inn her.]

- **`<feature-fil>`** (`@DOM-SUB-KAP-NNN`) — én linje om hva den dekker. ([krav-input/local/<sti>.feature](krav-input/local/<sti>.feature))
- **`<feature-fil>` — regel/scenario `<tittel>`** (`@DOM-SUB-KAP-NNN`, endring av levert krav) — én linje om hva den dekker. Erstatter `<tittel på @deprecated-del>`. ([krav-input/local/<sti>.feature](krav-input/local/<sti>.feature))

### Utenfor scope (`@draft`)

[Regler/scenarioer tagget `@draft` inne i kravene over. Ikke validert — skal ikke implementeres før de er avklart i `fs-krav`. Utelat seksjonen hvis det ikke finnes noen.]

- **`<feature-fil>` — regel/scenario `<tittel>`** — venter på: <spørsmål fra `# ÅPNE SPØRSMÅL:`>

### Skal fjernes (`@deprecated`)

[Krav og regler/scenarioer tagget `@deprecated`. De var levert, og koden skal fjernes. `fs-verify` sletter dem når koden er borte. Utelat seksjonen hvis det ikke finnes noen.]

- **`<feature-fil>`** (`@DOM-SUB-KAP-NNN`) — hele kravet. ([krav-input/local/<sti>.feature](krav-input/local/<sti>.feature))
- **`<feature-fil>` — regel/scenario `<tittel>`** ([krav-input/local/<sti>.feature](krav-input/local/<sti>.feature)). Erstattes av `<tittel på ny del>` (utelat hvis delen bare fjernes).

## Skisser

[Én underseksjon per skisse, eller linja `Ingen skisse: <grunn>`.]

### Skisse: `<tittel>`

- **Type:** `figma` / `lokal-bilde` / `lokal-pdf` / `annet`
- **Referanse:** [URL eller sti]
- **Lagrede artefakter:** lenker til `screenshot.png`, `sub-frames/`, `design-context.md`, `variables.md`, `assets/` (utelat det som ikke ble hentet)
- **Dekker krav:** `<feature-fil>` (scenario: `<scenario>` hvis spesifikt). Flere filer skilles med komma på samme linje; detaljer om hvilke deler av skissen som dekker hvilken fil, kan stå som underpunkter.
- **Valideringsstatus:** `OK` / `Avvik: <beskrivelse>` / `Uavklart: <grunn>`
- **Beslutning ved avvik:** `<valgt alternativ>` — `<begrunnelse>`

## Retagging

[Minst én linje om hva som skjedde. Tabell for filene som ble retagget.]

| Fil | Før | Etter |
|---|---|---|
| `krav/07 …/opprette_bruker.feature` | `@BRU-ADM-OPP-001 @must @planned` | `@BRU-ADM-OPP-001 @must @in-progress` |
| `krav/07 …/eksportere.feature` — Regel: Eksport til Excel | `@planned` | `@in-progress` |

## Åpne spørsmål

[Skisseavvik markert «vet ikke», uavklarte koblinger og andre kravmessige uklarheter. Kravspørsmål, ikke tekniske spørsmål.]

- [ ] Spørsmål 1

## Rute

[Valgfri. Forslag til rekkefølgen på kode-repoene, f.eks. `fs-plattform → fs-admin` når kravene trenger API før skjermbilder, eller bare `fs-admin`. Brukeren endrer og sender i FS Kravforvaltning; ruta står da i `utforing.md` (se *Utføring* i `tasks/README.md`), og seksjonen fjernes.]

fs-plattform → fs-admin
```

## Etter spec-en

Når spec-dokumentet og `ended`-linja er skrevet, spør via `AskUserQuestion`:

- **«Gå gjennom åpne spørsmål»** — ett om gangen. Behold spørsmålet synlig, legg til beslutning og begrunnelse, og merk det `[x]`.
- **«Stopp her»** — avslutt med en oppsummering: sti til spec-en, antall krav, retagginger, skisser og åpne spørsmål.

Minn brukeren på at endringene i `tasks/` og `krav/` ikke er committet — det gjør brukeren selv.

## Gjør ikke

- Analyserer ikke kode, foreslår ikke løsninger og skriver ikke kode.
- Oppretter, endrer eller lukker ikke GitHub-issues.
- Endrer ikke kravinnhold — bare implementasjonsstatus-taggen `@planned` → `@in-progress` (på `Egenskap:`, eller på delen i et levert krav som endres). Fjerner aldri `@draft` fra en `Regel:`/`Scenario:`.
- Skriver ikke utenfor `<spec>/` og statustaggene under `krav/`. Skriver ikke `oppgave.md`, `roadmap.md` eller andre oppgaveartefakter.
- Kjører aldri `git add`, `commit`, `push` eller andre git-mutasjoner.

## Retningslinjer

- Hver krav-bullet peker til en konkret råkopi under `krav-input/`.
- Vær ærlig om validering: kan du ikke lese en Figma-ramme, skriv `Uavklart` — ikke gjett.
- Ett spørsmål om gangen ved oppfølging. Aldri batch beslutninger om skisseavvik.
- Forventer brukeren at `@draft`-krav eller `@draft`-deler skal med, henvis til `fs-krav` — ikke omgå filteret.

## Referanser

- **[`references/askuserquestion-logging.md`](references/askuserquestion-logging.md)** — format for `questions-<skill>-<dato>.md`. Brukes også av `fs-specify-delta`.
- **[`tasks/README.md`](../../../tasks/README.md)** — oppgavestrukturen, domenelista og reglene for `spec/`.
- **`krav/README.md`** — tag-aksen og Feature-ID-formatet.
- **`fs-krav`** — ferdigstiller krav (`@draft` → `@planned`), og avvikler leverte krav (`@implemented` → `@deprecated`).
- **`fs-verify`** — verifiserer koden: `@in-progress` → `@implemented`, og sletter `@deprecated`-krav når koden er borte.
