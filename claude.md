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
│   ├── 00 Personas/               # Persona-definisjoner
│   ├── 01 Forberede studier/      # Domene: Studieforberedelse
│   ├── 02 Opptak/                 # Domene: Opptak
│   ├── 03 Gjennomføre studier/
│   ├── 04 Kompetanse/
│   ├── 05 Opplysninger om person/
│   ├── 07 Tilgangstyring/
│   ├── 08 Teknisk/
│   ├── 09 Kommunikasjon/
│   ├── 10 Felleskrav/
│   └── 99 Demo/                   # Demo/test features
├── tester/                        # All testkode og konfigurasjon (for utviklere)
│   ├── .mise.toml                 # Mise: Node.js versjon (lts)
│   ├── package.json               # Node.js avhengigheter
│   ├── tsconfig.json              # TypeScript konfigurasjon
│   ├── playwright.config.ts       # Playwright + playwright-bdd konfigurasjon
│   ├── steps/                     # Step definitions
│   ├── fixtures/                  # Test fixtures og hjelpefunksjoner
│   └── .features-gen/             # Genererte testfiler (gitignored)
├── README.md
└── claude.md
```

### Separasjon av krav og kode

- **`krav/`**: Kun `.feature`-filer som kan leses av alle. Ingen kode.
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

## Gherkin-språk (Norsk)

Alle feature-filer skrives på **norsk**. Hver fil må starte med:

```gherkin
# language: no
```

### Norske nøkkelord

| Norsk | Engelsk |
|-------|---------|
| `Egenskap:` | Feature |
| `Bakgrunn:` | Background |
| `Scenario:` | Scenario |
| `Scenariomal:` | Scenario Outline |
| `Eksempler:` | Examples |
| `Gitt` | Given |
| `Når` | When |
| `Så` | Then |
| `Og` | And |
| `Men` | But |

### Gherkin-syntaksregler

**Datatabeller** - brukes for å sende data til et steg:
```gherkin
Gitt at tabellen har følgende kolonner
  | Kolonne       |
  | Navn          |
  | Fødselsdato   |
```

**Scenariomal med Eksempler** - for parameteriserte tester:
```gherkin
Scenariomal: Velge antall per side
  Når brukeren velger <antall> visninger per side
  Så skal brukeren se <antall> rader

  Eksempler:
    | antall |
    | 50     |
    | 100    |
```

**Viktig**: `Eksempler:` skal KUN brukes med `Scenariomal:`, ikke med vanlig `Scenario:`.

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
- Bruk alltid `# language: no` på toppen
- Følg eksisterende mappestruktur basert på domene
- Bruk beskrivende scenario-navn på norsk
- Inkluder relevante tags for testtype og domene
- Bruk `Scenariomal:` (ikke `Scenario:`) når du bruker `Eksempler:`

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

## CI/CD

- **GitHub Actions**: Bygger Docker-image med testmiljø
- **GitLab**: Kjører testene fra Docker-imaget i bedriftens CI/CD
