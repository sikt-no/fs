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
├── kom-i-gang.html                # Innføring i kravarbeidet, eksportert fra Claude Design (se .claude/rules/kom-i-gang-sync.md)
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

## FS Kravforvaltning

`fs-kravforvaltning/` (**FS Kravforvaltning**) viser hele `krav/`-treet i nettleseren og som desktop-app, med avvik fra konvensjonene, redigering og PR, oppgavene i `tasks/`, spesifikasjonene og et Claude-panel. Den statiske versjonen publiseres til GitHub Pages (<https://sikt-no.github.io/fs/>) ved push til `main`.

```bash
cd fs-kravforvaltning
npm install
npm run dev
```

Hvordan appen er bygget, kommandoene, release og reglene for å jobbe i den står i [`fs-kravforvaltning/CLAUDE.md`](fs-kravforvaltning/CLAUDE.md). Claude leser den når den jobber med filer i mappa. En endring i appen som brukerne merker, skal ha en changeset i samme PR.

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
- `fs-krav` — kravarbeid: nye `.feature`-filer (enkeltstående eller for et initiativ), ferdigstilling av en mappe (`@draft` → `@planned`), fjerning av krav (leverte krav får `@deprecated`, resten slettes), og endring av leverte krav (egenskapen blir `@implemented`, den nye delen får `@planned` når den er validert, og delen den erstatter får `@deprecated`)
- `fs-krav-avvik` — ser etter avvik fra konvensjonene som krever skjønn, og som FS Kravforvaltning ikke sjekker automatisk (f.eks. «egne» og «dem», terminologi, listevisningsmønsteret), i en mappe eller fil under `krav/`. Rapporterer med `fil:linje` og forslag, retter bare ren ordlyd etter at brukeren har sagt ja, og endrer aldri tagger
- `fs-specify` — henter `@planned`-krav inn i en oppgave: `tasks/<domene>/<slug>/spec/` (`@planned` → `@in-progress`, også på `@planned`-deler i leverte krav som endres). Plukker også opp `@deprecated`-krav, og lager en spec for å fjerne koden
- `fs-specify-delta` — det samme, men for en endring (commit, branch, test-fil eller markdown), med samme tag-regler, også for `@deprecated`
- `fs-implementasjonsdetaljer` — implementasjonsdetaljene for et krav i `<feature>.design.md` ved siden av feature-fila: UI-mønstre, tilstander og tekstene. Sjekker at hjelpetekster, feilmeldinger og andre tekster med variasjoner står der, ikke bare i skissene. `fs-specify` og `fs-specify-delta` kjører den når implementasjonsdetaljene mangler
- `fs-verify` — verifiserer kravene mot koden i lokale kloner av kode-repoene: `@in-progress` → `@implemented` (på deler i leverte krav: `@in-progress` fjernes), og sletter `@deprecated`-krav når koden er borte (ellers lister den hvor koden fortsatt finnes). Med en spesifikasjon som scope skriver den `## Scenarioer` i `spec/verify-*.md` og sender steget tilbake i `utforing.md` når noe mangler
- `lage-steps` — step definitions i `tester/steps/` for kravene
- `fs-oppgave` — oppgavemappa `tasks/<domene>/<slug>/` ut fra malene i `tasks/mal/`: ny oppgave (`oppgave.md` og rad i `roadmap.md`), faseoverganger (`design.md`, `<lag>/plan-<slug>.md`) og review-filer

Typisk flyt: `fs-krav` → `fs-oppgave` (ny oppgave) → `fs-specify` / `fs-specify-delta` (med `fs-implementasjonsdetaljer`) → `lage-steps` → `fs-verify`, med `fs-oppgave` for hver faseovergang og review. Se [`tasks/README.md`](tasks/README.md) for oppgavestrukturen. `.claude/rules/tasks-conventions.md` importerer den med `@../../tasks/README.md` når Claude jobber i `tasks/**`.

## CI/CD

- **GitHub Actions**: Bygger Docker-image med testmiljø
- **GitLab**: Kjører testene fra Docker-imaget i bedriftens CI/CD
