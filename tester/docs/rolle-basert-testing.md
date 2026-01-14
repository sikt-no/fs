# Rolle-basert testing med Playwright-BDD

## Konsept

I ende-til-ende-tester trenger vi ofte å verifisere systemet fra forskjellige brukerperspektiver. For eksempel:

- En **administrator** oppretter et opptak
- En **søker** skal kunne se og søke på opptaket

Dette krever at vi kan bytte mellom ulike autentiserte contexts i samme test eller mellom tester.

## Arkitektur

```
┌─────────────────────────────────────────────────────────────┐
│                     Setup Projects                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │ admin-setup │  │ soker-setup │  │ anonym      │         │
│  │             │  │             │  │ (ingen)     │         │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘         │
│         │                │                │                 │
│         ▼                ▼                ▼                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │ admin.json  │  │ soker.json  │  │   (ingen)   │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                     Rolle Fixture                           │
│                                                             │
│   brukRolle('administrator') → Page med admin auth          │
│   brukRolle('søker')         → Page med søker auth          │
│   brukRolle('anonym')        → Page uten auth               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                     BDD Steg                                │
│                                                             │
│   "Gitt at jeg er logget inn som administrator"             │
│   "Gitt at jeg er logget inn som søker"                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Komponenter

### 1. Setup Projects

Hver rolle har et setup-prosjekt som autentiserer og lagrer session state til en JSON-fil.

**Filstruktur:**
```
setup/
├── admin-auth.setup.ts
├── soker-auth.setup.ts
└── ...
playwright/.auth/
├── admin.json
├── soker.json
└── ...
```

**Eksempel setup:**
```typescript
// setup/admin-auth.setup.ts
import { test as setup } from '@playwright/test';

setup('authenticate as admin', async ({ page }) => {
  await page.goto('/login');
  await page.fill('[name="username"]', process.env.ADMIN_USERNAME!);
  await page.fill('[name="password"]', process.env.ADMIN_PASSWORD!);
  await page.click('button[type="submit"]');

  await page.context().storageState({ path: 'playwright/.auth/admin.json' });
});
```

### 2. Rolle Fixture

En fixture som gir testene tilgang til å opprette pages med ulike roller.

**Nøkkelfunksjonalitet:**
- `brukRolle(rolle)` - Returnerer en Page med riktig auth state
- Automatisk cleanup av contexts etter hver test
- Støtte for å bytte rolle midt i en test

```typescript
// fixtures/roller.ts
import { test as base, Page, BrowserContext } from '@playwright/test';

type Rolle = 'administrator' | 'søker' | 'anonym';

const authFiles: Record<Rolle, string | null> = {
  'administrator': 'playwright/.auth/admin.json',
  'søker': 'playwright/.auth/soker.json',
  'anonym': null,
};

type RolleFixtures = {
  brukRolle: (rolle: Rolle) => Promise<Page>;
};

export const test = base.extend<RolleFixtures & { _contexts: BrowserContext[] }>({
  _contexts: async ({}, use) => {
    const contexts: BrowserContext[] = [];
    await use(contexts);
    // Cleanup etter test
    for (const ctx of contexts) {
      await ctx.close();
    }
  },

  brukRolle: async ({ browser, _contexts }, use) => {
    const brukRolle = async (rolle: Rolle): Promise<Page> => {
      const authFile = authFiles[rolle];
      const context = await browser.newContext(
        authFile ? { storageState: authFile } : {}
      );
      _contexts.push(context);
      return await context.newPage();
    };

    await use(brukRolle);
  },
});
```

### 3. BDD Steg

Steg som bruker fixture til å sette riktig rolle.

```typescript
// steps/rolle.steps.ts
import { createBdd } from 'playwright-bdd';
import { test } from '../fixtures/roller';
import { Page } from '@playwright/test';

const { Given, When, Then } = createBdd(test);

// Holder på aktiv side for bruk i andre steg
let currentPage: Page;

export function getPage(): Page {
  if (!currentPage) {
    throw new Error('Ingen aktiv side. Bruk "Gitt at jeg er logget inn som..." først.');
  }
  return currentPage;
}

Given('at jeg er logget inn som {word}', async ({ brukRolle }, rolle: string) => {
  currentPage = await brukRolle(rolle as Rolle);
});

Given('at jeg er på opptakssiden', async () => {
  await getPage().goto('/opptak');
});
```

### 4. Playwright Config

Konfigurer alle setup-prosjekter som dependencies.

```typescript
// playwright.config.ts
import { defineConfig } from '@playwright/test';

export default defineConfig({
  projects: [
    // Setup projects - kjører først
    {
      name: 'admin-setup',
      testDir: './setup',
      testMatch: 'admin-auth.setup.ts',
    },
    {
      name: 'soker-setup',
      testDir: './setup',
      testMatch: 'soker-auth.setup.ts',
    },

    // Hovedtester - avhenger av at alle roller er satt opp
    {
      name: 'e2e',
      dependencies: ['admin-setup', 'soker-setup'],
    },
  ],
});
```

## Bruk i Feature-filer

### Enkel test med én rolle

```gherkin
Scenario: Opprette og publisere et opptak
  Gitt at jeg er logget inn som administrator
  Og at jeg er på opptakssiden
  Når jeg oppretter et nytt lokalt opptak
  Og jeg setter navn til "Høstopptak 2025"
  Og jeg publiserer opptaket
  Så skal opptaket "Høstopptak 2025" være publisert
```

### Test som bytter rolle

```gherkin
Scenario: Søker kan se publisert opptak
  # Admin oppretter
  Gitt at jeg er logget inn som administrator
  Og at jeg er på opptakssiden
  Når jeg oppretter og publiserer opptak "Høstopptak 2025"

  # Søker verifiserer
  Gitt at jeg er logget inn som søker
  Når jeg går til søknadssiden
  Så skal jeg se "Høstopptak 2025"
```

### Verifisere fra anonym perspektiv

```gherkin
Scenario: Anonym bruker ser offentlig informasjon
  Gitt at jeg er logget inn som anonym
  Når jeg går til forsiden
  Så skal jeg se "Velkommen til opptakssystemet"
```

## Fordeler

1. **Deklarativ** - Feature-filene beskriver tydelig hvilken rolle som brukes
2. **Isolert** - Hver rolle har sin egen browser context
3. **Gjenbrukbar** - Setup kjører én gang, gjenbrukes av alle tester
4. **Fleksibel** - Kan bytte rolle midt i en test ved behov
5. **Lesbar** - "Gitt at jeg er logget inn som X" er naturlig språk

## Miljøvariabler

Legg til credentials for alle roller i `.env`:

```env
# Administrator
ADMIN_USERNAME=admin@example.com
ADMIN_PASSWORD=secret

# Søker
SOKER_USERNAME=soker@example.com
SOKER_PASSWORD=secret
```

## Utvidelse

For å legge til en ny rolle:

1. Opprett `setup/ny-rolle-auth.setup.ts`
2. Legg til rolle i `authFiles` i fixtures
3. Legg til setup-prosjekt i config med dependency
4. Legg til miljøvariabler for credentials
