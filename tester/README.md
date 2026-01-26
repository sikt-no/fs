# Tester

E2E-tester for FS med Playwright og playwright-bdd.

## Oppsett

```bash
mise install           # Installerer Node og Java
npm install
npx playwright install
cp .env.example .env   # Konfigurer miljøvariabler
```

## Kjøre tester

```bash
# Standard (kjører @demo-taggede tester)
npm test

# Med synlig nettleser
npm run test:headed

# Spesifikke tags
npm run test:ci           # @ci (samme som CI-pipeline)
npm run test:integration  # @integration
npm run test:e2e          # @e2e

# Egendefinert tag-filter
BDD_TAGS='@my-tag' npm test
```

## Rapporter

```bash
# Generer Allure-rapport
npm run allure:generate

# Åpne Allure-rapport
npm run allure:open

# Kjør tester og generer rapport
npm run test:allure
```

## Mappestruktur

```
tester/
├── fixtures/       # Playwright fixtures og helpers
├── pages/          # Page Object Models
├── steps/          # Gherkin step definitions
├── graphql/        # GraphQL queries og generert kode
└── playwright/     # Playwright auth states
```

Feature-filer ligger i `../krav/` og følger strukturen beskrevet i `.claude/rules/gherkin-conventions.md`.

## Tags

| Tag | Beskrivelse |
|-----|-------------|
| `@demo` | Demo-tester (standard lokalt) |
| `@ci` | Kjøres automatisk i CI |
| `@e2e` | End-to-end brukerreiser |
| `@integration` | API-integrasjonstester |

## CI

CI-pipeline kjører kun tester med `@ci`-tag. For å simulere CI lokalt:

```bash
npm run test:ci
```
