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

---

# POM 2.0: Minimalist Test Architecture

## Hvorfor denne arkitekturen eksisterer

Dette dokumentet etablerer arkitektoniske guardrails for å forhindre regresjon tilbake til klassisk Page Object Model (POM) og test spaghetti.

**Klassisk POM er bevisst unngått fordi:**
- Den skaper tett kobling mellom tester og UI-implementasjon
- Den oppmuntrer til one-class-per-page abstraksjoner som blåser opp kodebasen
- Den skjuler forretningshensikt bak mekaniske UI-operasjoner
- Den gjør tester skjøre og dyre å vedlikeholde

## Kjerneprinsipper

1. **Tester beskriver forretningshensikt, ikke UI-mekanikk**
   - Bra: `await brukerøkt.loggInnSom('administrator')`
   - Dårlig: `await loginPage.usernameInput.fill('admin')`

2. **UI-kunnskap er isolert og behandlet som adapter**
   - Selectors og Playwright APIs lever KUN i `ui/`
   - UI-adaptere er stateless, funksjonsbaserte, og fokuserer på "hvordan"

3. **Domenekonsepter har strukturell tyngdekraft**
   - Domain-objekter er klasser med state
   - Bruker NORSK domenespråk (Brukerøkt, Opptaksflyt, etc.)
   - Ingen flytende utility-funksjoner

4. **Determinisme og debuggbarhet over kløkt**
   - Eksplisitt er bedre enn abstrakt
   - Kjedelig kode er vedlikeholdbar kode

## Katalogansvar

```
/tests
  Formål: Orkestrering + assertions KUN
  Innhold: Test-scenarioer som beskriver forretningshensikt
  Forbudt: Selectors, locators, Playwright page APIs

/domain
  Formål: Forretningsflyter og domeneobjekter
  Innhold: Brukerøkt, Opptaksflyt, osv. (NORSK språk)
  Type: Klasser med state (IKKE funksjoner)
  Tillatt: Orkestrere UI-adaptere, forretningslogikk, holde state
  Forbudt: Direkte selector-referanser, Playwright APIs

/ui
  Formål: Rene Playwright adapter-funksjoner
  Innhold: Alle selectors og Playwright-interaksjoner
  Tillatt: page.locator(), page.click(), page.fill()
  Forbudt: Forretningslogikk, domenekonsepter

/assertions (valgfritt)
  Formål: Eksplisitte, lesbare forventninger
  Innhold: Domenespesifikke assertion-hjelpere
```

## Harde regler (ikke-forhandlingsbare)

### 1. Selector-isolasjon
```typescript
// ❌ FORBUDT i tests/ og domain/
await page.getByRole('button', { name: 'Lagre' }).click()

// ✅ PÅKREVD: Selectors kun i ui/
// ui/admission.ts
export function clickSaveButton(page: Page) {
  return page.getByRole('button', { name: 'Lagre' }).click()
}
```

### 2. Domain-objekter er klasser, UI-adaptere er funksjoner
```typescript
// ❌ FORBUDT: Page Object-klasser med UI-logikk
export class LoginPage {
  readonly loginButton: Locator
  constructor(readonly page: Page) {}
  async login(user: string) { ... }
}

// ✅ PÅKREVD: Domain-klasser (norsk språk) + UI-funksjoner
// domain/Brukerøkt.ts
export class Brukerøkt {
  constructor(private readonly side: Page) {}

  async loggInnMedFeide(brukernavn: string, passord: string) {
    await ui.auth.clickLoginWithFeide(this.side)
    await ui.auth.fillUsername(this.side, brukernavn)
    // ...
  }
}

// ui/auth.ts
export async function fillUsername(page: Page, username: string) {
  await page.getByLabel('Brukernavn').fill(username)
}
```

### 3. Domain-objekter med state i step-filer
```typescript
// ❌ FORBUDT: Direkte UI-kall i step-filer
When('jeg oppretter et nytt lokalt opptak', async ({ page }) => {
  await page.getByRole('link', { name: 'Velg Lokalt opptak' }).click()
})

// ❌ FORBUDT: Funksjonsbasert domain uten state
export function createLocalAdmission(page: Page) { ... }

// ✅ PÅKREVD: Domain-klasse med state (norsk språk)
// domain/Opptaksflyt.ts
export class Opptaksflyt {
  private sisteOpptakNavn?: string

  constructor(private readonly side: Page) {}

  async opprettLokaltOpptak() {
    await ui.admission.clickCreateLocal(this.side)
  }

  async settNavn(navn: string) {
    this.sisteOpptakNavn = `${navn} - ${Date.now()}`
    await ui.admission.fillName(this.side, this.sisteOpptakNavn)
  }

  hentSisteOpptakNavn(): string | undefined {
    return this.sisteOpptakNavn
  }
}

// steps/opptak.steps.ts
let opptaksflyt: Opptaksflyt

Given('at jeg er på opptakssiden', async ({ page }) => {
  opptaksflyt = new Opptaksflyt(page)
  await opptaksflyt.gåTilOpptakssiden()
})

When('jeg oppretter et nytt lokalt opptak', async () => {
  await opptaksflyt.opprettLokaltOpptak()
})

When('jeg setter navn til {string}', async ({}, navn: string) => {
  await opptaksflyt.settNavn(navn)
})
```

### 4. Ingen arvehierarkier, norsk domenespråk
```typescript
// ❌ FORBUDT: Arvehierarkier og engelsk domain-språk
class BasePage { ... }
class LoginPage extends BasePage { ... }
class UserSession { ... }  // Engelsk

// ✅ PÅKREVD: Komposisjon + norsk domenespråk
import * as ui from '../ui'
import { Brukerøkt, Opptaksflyt } from '../domain'

let brukerøkt: Brukerøkt
let opptaksflyt: Opptaksflyt
```

### 5. Ingen globale variabler for state
```typescript
// ❌ FORBUDT: Global state utenfor domain-objekter
let sisteOpptakNavn: string  // Global variabel

When('jeg setter navn', async () => {
  sisteOpptakNavn = 'Mitt opptak'
})

// ✅ PÅKREVD: State i domain-objekter
class Opptaksflyt {
  private sisteOpptakNavn?: string  // State i klassen

  settNavn(navn: string) {
    this.sisteOpptakNavn = navn
  }
}
```

## E2E Test Reduction Strategy

### Prinsipp: E2E-tester er dyre og skjøre
Bruk kun E2E-tester for:
1. **Kritiske brukerreiser** (innlogging, utsjekking, kjernearbeidsflyter)
2. **Integrasjonsverifisering** (frontend + backend + database)
3. **Visuell/UX-validering** (layout, responsivt design)

### Erstatt E2E med raskere alternativer:

| Testtype | Bruk når | Eksempel |
|----------|----------|----------|
| **API-tester** | Verifisering av backend-logikk via UI | GraphQL-spørringer, REST-endepunkter |
| **Komponenttester** | Validering av UI-atferd isolert | Formvalidering, knappetilstander |
| **Kontraktstester** | Sikring av API-kompatibilitet | Skjemavalidering, mock-responser |
| **Fixtures/Seeding** | Oppsett av testdata | Database-seeding i stedet for UI-klikk |

### Røde flagg for unødvendige E2E:
- ❌ Test verifiserer kun backend-respons (bruk API-test)
- ❌ Test setter opp data via UI-klikk (bruk fixtures/API-seeding)
- ❌ Test gjentar samme oppsettstrinn (ekstraher til storageState)
- ❌ Test validerer GraphQL-skjema (bruk kontrakttest)

## Sjekkliste for ny kode

Før commit, verifiser:

- [ ] Ingen selectors eller Playwright APIs i `tests/` eller `domain/`
- [ ] Alle UI-interaksjoner er i `ui/` adapter-funksjoner
- [ ] Domain-objekter er klasser (IKKE funksjoner)
- [ ] Domain-objekter bruker NORSK domenespråk (Brukerøkt, Opptaksflyt)
- [ ] State holdes i domain-objekter, ikke i globale variabler
- [ ] Step-filer instansierer domain-objekter: `let opptaksflyt: Opptaksflyt`
- [ ] Domenekode representerer forretningskonsepter, ikke UI-mekanikk
- [ ] Testfiler leser som forretningskrav
- [ ] Ingen `BasePage`, `AbstractFlow`, eller arvehierarkier

## Håndhevelse

Denne arkitekturen håndheves av:
1. **Code review**: Reviewere må avvise PRer som bryter disse reglene
2. **AI-assistanse**: Claude og andre AI-verktøy refererer til dette dokumentet
3. **Linting (fremtidig)**: Vurder ESLint-regler for å forby imports av `@playwright/test` utenfor `ui/`
