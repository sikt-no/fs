---
name: lage-steps
description: >
  Lag Playwright step-definisjoner for BDD-tester. Veileder brukeren gjennom
  prosessen med å bruke codegen, strukturere steps, og gjenbruke eksisterende kode.
  Bruk når brukeren vil implementere tester, lage steps, eller automatisere scenarios.
---

# Lage Steps

Skill for å lage Playwright step-definisjoner fra Gherkin-scenarios.

## Arbeidsflyt

### 1. Identifiser scenarios

Spør brukeren:
- Hvilken feature-fil skal implementeres?
- Hvilke scenarios skal automatiseres?

Les feature-filen og list opp steps som trenger implementasjon.

### 2. Finn eksisterende steps

Søk etter gjenbrukbare steps i `tester/steps/**/*.ts`:

```bash
# Eksempel søk
grep -r "Given\|When\|Then" tester/steps/
```

**Presenter funn:**
```markdown
## Eksisterende steps som kan gjenbrukes
- `at jeg er logget inn som {word}` - bruker-kontekst.steps.ts:25
- `skal jeg se {string} på siden` - bruker-kontekst.steps.ts:55

## Steps som må lages
- `jeg oppretter en ny søknad`
- `skal søknaden være lagret`
```

### 3. Bruk Playwright Codegen

For å fange opp interaksjoner, bruk codegen med norsk locale:

**FS-Admin (administrator):**
```bash
npx playwright codegen --lang no-Nb $FS_ADMIN_URL
```

**MinKompetanse (person/søker):**
```bash
npx playwright codegen --lang no-Nb $MIN_KOMPETANSE_URL
```

**Instruksjoner til brukeren:**
1. Kjør kommandoen over i terminalen
2. Logg inn manuelt (bruk Feide testbruker)
3. Utfør handlingene fra scenarioet
4. Kopier den genererte koden
5. Lim inn koden her, så hjelper jeg med å strukturere den

### 4. Strukturer steps

Når brukeren limer inn codegen-output:

1. **Ekstraher gjenbrukbare deler** - Identifiser mønstre som kan bli generelle steps
2. **Bruk riktig fixture** - `userContext` for multi-rolle, `page` for enkelt-rolle
3. **Følg navnekonvensjoner** - Filnavn: `[domene].steps.ts`
4. **Legg til JSDoc** - Dokumenter hva steget gjør

**Eksempel transformasjon:**

Fra codegen:
```typescript
await page.getByRole('link', { name: 'Opptak' }).click()
await page.getByRole('button', { name: 'Nytt opptak' }).click()
await page.getByLabel('Navn').fill('Test opptak')
```

Til strukturert step:
```typescript
When('jeg oppretter et nytt opptak med navn {string}', async ({ userContext }, navn: string) => {
  const page = userContext.currentPage
  await page.getByRole('link', { name: 'Opptak' }).click()
  await page.getByRole('button', { name: 'Nytt opptak' }).click()
  await page.getByLabel('Navn').fill(navn)
})
```

### 5. Plasser i riktig fil

**Filstruktur:**
```
tester/
├── steps/
│   ├── bruker-kontekst.steps.ts  # Innlogging, rollebytte
│   ├── feide-innlogging.steps.ts # Auth setup
│   ├── opptak.steps.ts           # Opptak-domene
│   └── [domene].steps.ts         # Nye domener
├── fixtures/
│   └── user-context.ts           # userContext fixture
├── helpers/
│   └── combobox.ts               # Gjenbrukbare hjelpefunksjoner
└── pages/
    └── [side]/                   # Page Object Model (valgfritt)
```

**Velg fil basert på domene:**
- Opptak-relatert → `opptak.steps.ts`
- Person/profil → `person.steps.ts`
- Generell navigasjon → `navigasjon.steps.ts`

---

## Step-mønster

### Grunnleggende struktur

```typescript
import { createBdd } from 'playwright-bdd'
import { test, expect } from '../fixtures/user-context'

const { Given, When, Then } = createBdd(test)

/**
 * Beskrivelse av hva steget gjør.
 */
Given('at jeg er på {string}', async ({ userContext }, side: string) => {
  await userContext.currentPage.goto(side)
})
```

### Med parametere

```typescript
// String parameter
When('jeg fyller inn {string} i feltet {string}',
  async ({ userContext }, verdi: string, felt: string) => {
    await userContext.currentPage.getByLabel(felt).fill(verdi)
  }
)

// Word parameter (uten anførselstegn i Gherkin)
Given('at jeg er logget inn som {word}', async ({ userContext }, rolle: string) => {
  await userContext.switchTo(rolle as UserRole)
})
```

### Med datatabell

```typescript
When('jeg fyller ut skjemaet:', async ({ userContext }, dataTable: DataTable) => {
  const data = dataTable.rowsHash()
  for (const [felt, verdi] of Object.entries(data)) {
    await userContext.currentPage.getByLabel(felt).fill(verdi)
  }
})
```

---

## Beste Praksis

### Gjenbruk fixtures

Bruk `userContext` for tester med flere roller:
```typescript
Given('at jeg er logget inn som {word}', async ({ userContext }, rolle: string) => {
  await userContext.switchTo(rolle as UserRole)
})
```

### Vent på nettverksaktivitet

```typescript
await page.waitForLoadState('networkidle')
```

### Bruk robuste selektorer

Prioriter i denne rekkefølgen:
1. `getByRole()` - Beste praksis
2. `getByLabel()` - For skjemafelt
3. `getByText()` - For synlig tekst
4. `getByTestId()` - Siste utvei

### Håndter asynkrone elementer

```typescript
// Vent på at element er synlig
await page.getByRole('button', { name: 'Lagre' }).waitFor({ state: 'visible' })

// Vent med timeout
const element = page.getByText('Lastet')
if (await element.isVisible({ timeout: 2000 }).catch(() => false)) {
  await element.click()
}
```

---

## Eksempel

Se [examples/step-example.ts](examples/step-example.ts) for et komplett eksempel på godt strukturerte steps.
