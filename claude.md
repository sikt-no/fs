# FS Krav og Tester

Dette repositoriet inneholder BDD-baserte kravspesifikasjoner og automatiserte tester for FS-systemet.

## Konsept

Repositoriet bruker Behavior-Driven Development (BDD) for å oppnå to mål:

1. **Levende dokumentasjon**: Gherkin feature-filer fungerer som lesbare kravspesifikasjoner som både domeneeksperter og utviklere kan forstå
2. **Automatiserte tester**: De samme feature-filene driver integrasjons- og ende-til-ende-tester

### Arbeidsflyt

- **Domeneeksperter** skriver og vedlikeholder Gherkin-scenarioer som kravspesifikasjoner
- **Utviklere** implementerer step definitions i TypeScript som kobler scenarioene til kjørbar testkode

## Mappestruktur

```
fs/
├── krav/                          # Gherkin feature-filer (lesbart for alle)
│   ├── README.md                  # Slik jobber vi med krav (konvensjonene, forsiden i vieweren)
│   ├── 01 Utdanning/
│   ├── 02 Opptak/
│   ├── 03 Gjennomføre studier/
│   ├── 04 Kompetanse/
│   ├── 05 Opplysninger om person/
│   ├── 07 Brukeradministrasjon og tilgangsstyring/
│   ├── 08 Teknisk/
│   ├── 09 Organisasjon/
│   ├── 10 Felleskrav/
│   ├── _Interne prosesser/
│   └── 99 Demo/                   # Demo/test features
├── tester/                        # All testkode og konfigurasjon (for utviklere)
│   ├── .mise.toml                 # Mise: Node.js versjon (lts)
│   ├── package.json               # Node.js avhengigheter
│   ├── tsconfig.json              # TypeScript konfigurasjon
│   ├── playwright.config.ts       # Playwright + playwright-bdd konfigurasjon
│   ├── steps/                     # Step definitions
│   ├── fixtures/                  # Test fixtures og hjelpefunksjoner
│   └── .features-gen/             # Genererte testfiler (gitignored)
├── fs-kravforvaltning/            # FS Kravforvaltning: krav i nettleser og desktop-app (Vite + Preact, Electron)
├── README.md
└── claude.md
```

### Separasjon av krav og kode

- **`krav/`**: Kun `.feature`-filer som kan leses av alle. Ingen kode.
  Konvensjonene for kravfilene (språk, filnavn, mappestruktur, tags, terminologi) står i [`krav/README.md`](krav/README.md). `.claude/rules/gherkin-conventions.md` importerer den med `@../../krav/README.md` (bare når Claude jobber med `.feature`-filer eller `krav/**/*.md`), så det finnes bare én versjon. Bruk import, ikke symlenke: Git for Windows sjekker ut symlenker som tekstfiler med bare målstien.
- **`tester/`**: All teknisk konfigurasjon og kode. Utviklere jobber her.

## Kjøre tester

Alle kommandoer kjøres fra `tester/` mappen med mise:

```bash
cd tester

# Generer og kjør alle tester
~/.local/bin/mise exec -- npm test

# Kun generere testfiler fra features
~/.local/bin/mise exec -- npx bddgen

# Kjør tester med synlig browser
~/.local/bin/mise exec -- npx playwright test --headed

# Kjør spesifikke tags
~/.local/bin/mise exec -- npx playwright test --grep @demo

# Vis HTML-rapport med trace
~/.local/bin/mise exec -- npx playwright show-report
```

### npm scripts

| Script | Beskrivelse |
|--------|-------------|
| `npm test` | Generer og kjør alle tester |
| `npm run bddgen` | Generer testfiler fra features |
| `npm run test:headed` | Kjør med synlig browser |
| `npm run test:integration` | Kun @integration tester |
| `npm run test:e2e` | Kun @e2e tester |

## Live-visning av krav

`fs-kravforvaltning/` (**FS Kravforvaltning**) er en Vite-dev-server som viser hele `krav/`-treet og oppdaterer visningen straks en `.feature`-fil lagres (parse-feil vises som banner over sist gyldige versjon):

```bash
cd fs-kravforvaltning
npm install
npm run dev
npm run dev:oppgaver   # med Oppgaver-modusen (tasks/)
npm run app:dev        # desktop-appen (electron-vite)
npm run app:dist       # pakket desktop-app i fs-kravforvaltning/release/
```

Vieweren husker hvor brukeren var (`krav-viewer:hash` i localStorage), og går tilbake dit når den åpnes uten hash. Det gjelder alltid når desktop-appen starter, og i en ny fane. En fil som er borte, gir forsiden.

`npm run build` lager et statisk bygg i `fs-kravforvaltning/dist/` med hele `krav/`-snapshotet bakt inn (relative stier, hash-routing). `.github/workflows/deploy-viewer.yml` publiserer det til GitHub Pages (<https://sikt-no.github.io/fs/>) ved push til `main`. I statisk bygg er git-data `null`, så «Endringer»-modusen skjules. Oppgaver-modusen er av som standard, både i dev og i bygget, og slås på med `--mode oppgaver` (`npm run dev:oppgaver`, `npm run build -- --mode oppgaver`) eller `OPPGAVER=1`. Uten den leses ikke `tasks/`, `virtual:krav-tasks` er `null`, og knappen og `#/oppgaver`-rutene skjules.

- `core/` er serverlogikken i ren Node, felles for dev-serveren og desktop-appen: `workspace.ts` (leser, parser og overvåker `krav/` og `tasks/`, og sender `krav:update`/`krav:git`/`krav:tasks`), `api.ts` (kallene rendereren kan gjøre, typene i `shared/api.ts`), `save.ts` (skriver krav-filer, bare `.feature`/`.md` under `krav/`), `auth.ts` (GitHub-innlogging med device flow, eller `gh auth token` i dev) og `vcs.ts` med to git-backender: `vcs-cli.ts` (git og gh på maskinen) og `vcs-isogit.ts` (isomorphic-git, uten git-installasjon). Testet i `core/*.test.ts`, isomorphic-git mot en lokal `git http-backend`
- `server/kravPlugin.ts` kobler `core/` til Vite: `virtual:krav*`-modulene, Vites watcher og websocket, og middlewares for `POST /__krav/focus` og `POST /__krav/api/<kall>` (bare fra vieweren selv, sjekket med `Origin`). `VCS=isogit` bytter til isomorphic-git-backenden
- `src/markdown.ts` + `src/MarkdownView.tsx` viser `.md`-filer formatert (overskrifter, lister, kodeblokker med «Kopier», tabeller, lenkekort), med bryter til rå markdown. Relative lenker til filer i vieweren åpnes internt
- `server/parse.ts` parser med `@cucumber/gherkin` til modellen i `shared/model.ts`, og sjekker konvensjonene i `krav/README.md` (importert i `.claude/rules/gherkin-conventions.md`). Reglene som sjekkes er merket *(sjekkes automatisk)* i README-en, og testes i `server/parse.test.ts` (`npm test`). Bruddene vises som et statusbånd («Fila følger ikke konvensjonene») under metalinja i feature-visningen, og som `!` i treet. **Hold dem i synk:** endres en merket regel, eller kommer det en ny regel som kan sjekkes, skal `parse.ts`, testene og merkingen i README-en oppdateres i samme endring, og omvendt. Framgangsmåten står i `.claude/rules/krav-readme-parser-sync.md`, som lastes når Claude jobber med README-en eller parseren
- `shared/rules.ts` har ID, alvorlighetsgrad (feil/advarsel), README-seksjon og forklaring for hver regel parseren sjekker. Hvert avvik (`Lint`) har `rule` og `sev` derfra
- **Avvik**-modusen (`#/avvik`, bryteren «Krav | Avvik» i toppfeltet) er et dashbord over avvikene i hele `krav/`, portet fra designet «Gherkin Viewer v2» (Claude Design): nøkkeltall, avvik per regel, status og prioritet, «Regel × mappe» med drill-down, fil- og regeldetaljer med «Kopier agent-prompt», og lista over filer med avvik. Klikk på et avvik åpner fila på linja, og «Les regelen» hopper til seksjonen i README-en. Aggregeringen er rene funksjoner i `src/health.ts` (testet i `src/health.test.ts`), visningen i `src/Avvik.tsx`. Rettes et avvik i editoren, viser statuslinja «↻ … rettet i …»
- **Oppgaver**-modusen (`#/oppgaver`, tredje knapp i «Krav | Avvik | Oppgaver») viser oppgavemappene i `tasks/`, portet fra designet «Oppgaver» (Claude Design, runde 2). «Mappe / Tavle» bytter mellom oppgavemappa (fasespor, gate før neste fase med «Neste steg» og «Kopier prompt til agent», lag, krav, reviews, statuslogg og filtre) og en tavle med én kolonne per fase. Valgt oppgave følger med (`#/oppgaver/<domene>/<slug>`, `#/oppgaver/tavle/<domene>/<slug>`). `server/tasks.ts` leser rådataene (`virtual:krav-tasks`, pushes som `krav:tasks`), `shared/tasks.ts` tolker `oppgave.md`, planbokser og reviews og sjekker reglene i `tasks/README.md` (merket *(sjekkes automatisk)*, testet i `shared/tasks.test.ts`), og `src/oppgaveflyt.ts` har gate, neste steg, krav-kobling og agent-prompt (testet i `src/oppgaveflyt.test.ts`). Hold `tasks/README.md` og `shared/tasks.ts` i synk på samme måte som krav-README-en og parseren
- `server/git.ts` leser endringer under `krav/` (ucommitted mot HEAD, og committet siden merge-base med `main`). Pluginen eksponerer dem som `virtual:krav-git`, pusher `krav:git` ved endringer i krav-filer eller i `.git` (HEAD, index, reflog), og sidebaren viser dem i «Endringer»-modus
- `src/` er Preact-komponentene, portet fra designet «Gherkin Viewer» (Claude Design)
- `src/search.ts` bygger en Fuse.js-indeks over filer og scenarioer for søket i treet; scenariotreff hopper til scenarioet via samme `focus`-state som VS Code-utvidelsen bruker
- `vscode/` er en liten VS Code-utvidelse (ren JS, uten bygg) som poster aktiv fil og markørlinje til `POST /__krav/focus`; pluginen videresender det som `krav:focus`, og vieweren bytter fil og scroller til scenarioet. Installeres med `npm run vscode:install` (symlink til `~/.vscode/extensions`), og adressen settes med `kravViewer.url`
- **Redigering og PR** (dev-serveren og desktop-appen, ikke GitHub Pages): «Rediger» på en fil åpner `src/Editor.tsx`, med felt for status, prioritet og `Egenskap:`-tittel (rene funksjoner i `src/edit.ts`, testet i `src/edit.test.ts`) og hele teksten. Lagring skriver fila, og parseren og avvikene oppdateres som ved lagring i en editor. «Lag PR» i «Endringer»-modus (`src/PrDialog.tsx`) lager en ny branch `krav/<slug>` fra `origin/main` med de valgte filene slik de er på disk, pusher og oppretter PR-en via GitHub REST. Arbeidskatalogen og branchen din røres ikke: CLI-backenden bruker en midlertidig `git worktree`, isomorphic-git bygger committen direkte i objektdatabasen
- **Claude-panelet** (knappen «Claude» i toppfeltet, dev-serveren og desktop-appen) ligger til høyre i alle visningene, så samtalen følger med mellom Krav, Avvik og Oppgaver. Skills og fil-kontekst følger visningen (`CLAUDE_SKILLS_BY_MODE` i `main.tsx`): Krav og Avvik tillater bare `fs-krav`, Oppgaver også `fs-specify` og `fs-specify-delta`. Mens panelet er åpent, er «Kopier agent-prompt» i Avvik og Oppgaver byttet ut med «Send til Claude Code» (`src/AgentButton.tsx`, via `src/claudeBridge.ts`), som sender prompten som melding i samtalen som er åpen. Panelet er en samtale med brukerens lokale Claude Code. `core/claude.ts` finner `claude` (PATH, vanlige installasjonssteder, innloggingsskallet, eller `KRAV_CLAUDE_PATH`) og kjører `claude -p --output-format stream-json --verbose` med repoet som arbeidsmappe. Meldingen går på stdin, og samtalen fortsetter med `--resume`. Med `--permission-mode dontAsk` og `--allowedTools` (`CLAUDE_TOOLS`) kan Claude lese og endre filer og bruke skills, men ikke kjøre kommandoer eller gå på nettet. Endringene vises straks i vieweren og sendes med «Lag PR». Hendelsene går som `krav:claude`; samtalen tolkes i `src/claudeChat.ts` (testet i `src/claudeChat.test.ts`) og vises i `src/ClaudePanel.tsx`. Svarene er markdown og vises med `src/ChatMarkdown.tsx`, som bruker den samme parseren som .md-filene (`parseMd`). Lenker og `kode` som peker på krav-filer, åpner fila i vieweren. Det kan være flere samtaler («Samtaler», «Ny», «Slett»). De lagres i localStorage (`krav-viewer:claudeChats`) og overlever omlasting og omstart. En kjøring som pågår, fortsetter i backenden, og vieweren kobler seg på igjen (`claudeActive`). Panelet kan gjøres bredere eller smalere ved å dra i venstre kant. Fila brukeren ser på, sendes med som kontekst og vises som en badge nede i inputfeltet. ✕ sender uten fila til brukeren åpner en annen fil. Under samtaletittelen vises hvor mye kontekst samtalen bruker (fra `usage` i siste svar, og `contextWindow` i `modelUsage`), og hvilke skills som er lastet (med `/<skill>`, eller med Skill-verktøyet uten å bli stoppet). Over inputfeltet velges én skill for samtalen (`src/ClaudeSkills.tsx`): `fs-krav`, `fs-specify` eller `fs-specify-delta` (`CLAUDE_SKILLS` i `shared/api.ts`). Det er alltid én valgt. I Krav og Avvik er bare `fs-krav` tillatt; specify-skillene vises deaktivert, og en samtale som hadde en av dem, bytter til `fs-krav` med neste melding (`effectiveSkill` i `src/claudeChat.ts`). Den valgte lastes med neste melding (`/<skill>`) og tillates med `Skill(<navn>)` i `--allowedTools`. Alle andre kjente skills (prosjektets fra disk, og plugins og personlige fra Claudes init-melding, husket i localStorage) avvises med `Skill(<navn>)` i `--disallowedTools`, fordi `dontAsk` alene slipper gjennom enkelte skills. Valget lagres per samtale, og en ny samtale starter med sist brukte. Claude bruker brukerens egen innlogging
- `src/transport.ts` er rendererens eneste forbindelse til backenden: Vites websocket og `fetch` i dev, snapshotet bakt inn i statisk bygg, og IPC via `window.krav` (preload) i desktop-appen. `main.tsx` venter på `transport.boot()` før den tegner
- **Desktop-appen** (`electron/`, `electron.vite.config.ts`, `electron-builder.yml`): electron-vite 6 (beta, fordi stabil 5 ikke støtter Vite 8). Ved første oppstart klones `sikt-no/fs` (grunn klone av main) til appens datamappe med isomorphic-git, så brukerne trenger ikke git. «Hent siste» henter main og oppdaterer filene som ikke er endret lokalt. Innloggingen bruker device flow og krever en OAuth-app i `sikt-no` (`KRAV_GITHUB_CLIENT_ID` ved kjøring, eller `MAIN_VITE_KRAV_GITHUB_CLIENT_ID` ved bygg). Tokenet lagres kryptert med `safeStorage`. `KRAV_REPO=<sti>` bruker en eksisterende klone i stedet for appens egen

## Teknologier

| Verktøy | Formål |
|---------|--------|
| **mise** | Versjonsadministrasjon for Node.js |
| **Playwright** | Browser-automatisering og API-testing |
| **playwright-bdd** | Kobler Gherkin-scenarioer til Playwright-tester |
| **Gherkin** | Språk for lesbare kravspesifikasjoner |

## Testtyper og tags

| Tag | Beskrivelse | Kjøremiljø |
|-----|-------------|------------|
| `@integration` | Integrasjonstester mot GraphQL API | Playwright API-testing |
| `@e2e` | Ende-til-ende-tester gjennom browser | Playwright browser |
| `@demo` | Demo-tester for å verifisere oppsett | Browser |

Andre vanlige tags:
- `@ci` - Kjøres i CI/CD pipeline
- `@fsadmin` - Tester for admin-grensesnittet
- Domene-spesifikke tags (f.eks. `@opptakspilot`)

## Gherkin-språk og konvensjoner

Feature-filene skrives på norsk Gherkin. Nøkkelord, gode scenarioer, filnavn, mappestruktur, tags og terminologi står i [`krav/README.md`](krav/README.md).

## playwright-bdd konfigurasjon

Konfigurasjon i `tester/playwright.config.ts`:

```typescript
const testDir = defineBddConfig({
  featuresRoot: '../krav',
  features: '../krav/**/*.feature',
  steps: './steps/**/*.ts',
  language: 'no',                    // Norsk Gherkin
  missingSteps: 'skip-scenario',     // Hopp over scenarioer uten steps
  tags: '@demo',                     // Filtrer på tags (valgfritt)
});
```

### Debugging

Playwright er konfigurert med:
- `trace: 'on'` - Full trace for hvert steg
- `screenshot: 'on'` - Screenshots underveis
- `video: 'on'` - Video av hele testen

Se trace i HTML-rapporten: `npx playwright show-report`

## Konvensjoner for Claude

### Når du jobber med feature-filer
- Følg konvensjonene i [`krav/README.md`](krav/README.md)
- Bruk beskrivende scenario-navn på norsk

### Når du jobber med step definitions
- Skriv i TypeScript
- Plasser step definitions i `tester/steps/`
- Bruk `createBdd()` fra playwright-bdd
- Importer `expect` fra `@playwright/test`

Eksempel step definition:
```typescript
import { expect } from '@playwright/test';
import { createBdd } from 'playwright-bdd';

const { Given, When, Then } = createBdd();

Given('at brukeren er på siden', async ({ page }) => {
  await page.goto('https://example.com');
});

When('brukeren skriver {string} i feltet', async ({ page }, tekst: string) => {
  await page.locator('input').fill(tekst);
});

Then('skal {string} vises', async ({ page }, tekst: string) => {
  await expect(page.locator('text=' + tekst)).toBeVisible();
});
```

### Testutførelse
- `@integration` tester: Bruker `request` fixture for API-kall
- `@e2e` tester: Bruker `page` fixture for browser-interaksjon

### Skills for kravarbeid (`.claude/skills/`)
- `fs-krav` — kravarbeid: nye `.feature`-filer (enkeltstående eller for et initiativ), og ferdigstilling av en mappe (`@draft` → `@planned`)
- `fs-specify` — henter `@planned`-krav inn i en oppgave: `tasks/<domene>/<slug>/spec/` (`@planned` → `@in-progress`)
- `fs-specify-delta` — det samme, men for en endring (commit, branch, test-fil eller markdown)
- `lage-steps` — step definitions i `tester/steps/` for kravene
- `fs-oppgave` — oppgavemappa `tasks/<domene>/<slug>/` ut fra malene i `tasks/mal/`: ny oppgave (`oppgave.md` og rad i `roadmap.md`), faseoverganger (`design.md`, `<lag>/plan-<slug>.md`) og review-filer

Typisk flyt: `fs-krav` → `fs-oppgave` (ny oppgave) → `fs-specify` / `fs-specify-delta` → `lage-steps`, med `fs-oppgave` for hver faseovergang og review. Se [`tasks/README.md`](tasks/README.md) for oppgavestrukturen. `.claude/rules/tasks-conventions.md` importerer den med `@../../tasks/README.md` når Claude jobber i `tasks/**`.

## CI/CD

- **GitHub Actions**: Bygger Docker-image med testmiljø
- **GitLab**: Kjører testene fra Docker-imaget i bedriftens CI/CD
