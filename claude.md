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
├── viewer/                        # Live-visning av krav i nettleser (Vite + Preact)
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

`viewer/` er en Vite-dev-server som viser hele `krav/`-treet og oppdaterer visningen straks en `.feature`-fil lagres (parse-feil vises som banner over sist gyldige versjon):

```bash
cd viewer
npm install
npm run dev
```

`npm run build` lager et statisk bygg i `viewer/dist/` med hele `krav/`-snapshotet bakt inn (relative stier, hash-routing). `.github/workflows/deploy-viewer.yml` publiserer det til GitHub Pages (<https://sikt-no.github.io/fs/>) ved push til `main`. I statisk bygg er git-data `null`, så «Endringer»-modusen skjules.

- `server/kravPlugin.ts` leser og overvåker `krav/` (med `krav/README.md` som forside), og sender `krav:update` over Vites websocket
- `src/markdown.ts` + `src/MarkdownView.tsx` viser `.md`-filer formatert (overskrifter, lister, kodeblokker med «Kopier», tabeller, lenkekort), med bryter til rå markdown. Relative lenker til filer i vieweren åpnes internt
- `server/parse.ts` parser med `@cucumber/gherkin` til modellen i `shared/model.ts`, og sjekker konvensjonene i `krav/README.md` (importert i `.claude/rules/gherkin-conventions.md`). Reglene som sjekkes er merket *(sjekkes i vieweren)* i README-en, og testes i `server/parse.test.ts` (`npm test`). Bruddene vises som «Avvik fra konvensjoner» i feature-visningen og som `!` i treet. **Hold dem i synk:** endres en merket regel, eller kommer det en ny regel som kan sjekkes, skal `parse.ts`, testene og merkingen i README-en oppdateres i samme endring, og omvendt. Framgangsmåten står i `.claude/rules/krav-readme-parser-sync.md`, som lastes når Claude jobber med README-en eller parseren
- `shared/rules.ts` har ID, alvorlighetsgrad (feil/advarsel), README-seksjon og forklaring for hver regel parseren sjekker. Hvert avvik (`Lint`) har `rule` og `sev` derfra
- **Avvik**-modusen (`#/avvik`, bryteren «Krav | Avvik» i toppfeltet) er et dashbord over avvikene i hele `krav/`, portet fra designet «Gherkin Viewer v2» (Claude Design): nøkkeltall, avvik per regel, status og prioritet, «Regel × mappe» med drill-down, fil- og regeldetaljer med «Kopier agent-prompt», og lista over filer med avvik. Klikk på et avvik åpner fila på linja, og «Les regelen» hopper til seksjonen i README-en. Aggregeringen er rene funksjoner i `src/health.ts` (testet i `src/health.test.ts`), visningen i `src/Avvik.tsx`. Rettes et avvik i editoren, viser statuslinja «↻ … rettet i …»
- `server/git.ts` leser endringer under `krav/` (ucommitted mot HEAD, og committet siden merge-base med `main`). Pluginen eksponerer dem som `virtual:krav-git`, pusher `krav:git` ved endringer i krav-filer eller i `.git` (HEAD, index, reflog), og sidebaren viser dem i «Endringer»-modus
- `src/` er Preact-komponentene, portet fra designet «Gherkin Viewer» (Claude Design)
- `src/search.ts` bygger en Fuse.js-indeks over filer og scenarioer for søket i treet; scenariotreff hopper til scenarioet via samme `focus`-state som VS Code-utvidelsen bruker
- `vscode/` er en liten VS Code-utvidelse (ren JS, uten bygg) som poster aktiv fil og markørlinje til `POST /__krav/focus`; pluginen videresender det som `krav:focus`, og vieweren bytter fil og scroller til scenarioet. Installeres med `npm run vscode:install` (symlink til `~/.vscode/extensions`), og adressen settes med `kravViewer.url`

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

Typisk flyt: `fs-krav` → `fs-specify` / `fs-specify-delta` → `lage-steps`. Se [`tasks/README.md`](tasks/README.md) for oppgavestrukturen.

## CI/CD

- **GitHub Actions**: Bygger Docker-image med testmiljø
- **GitLab**: Kjører testene fra Docker-imaget i bedriftens CI/CD
