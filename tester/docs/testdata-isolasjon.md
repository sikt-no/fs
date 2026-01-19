# Testdata og isolasjon

Dette dokumentet beskriver beste praksis for håndtering av testdata i våre automatiserte akseptansetester.

## Problemstilling

Når flere scenarioer deler en felles `Bakgrunn:` i Gherkin, oppstår utfordringer:

```gherkin
Bakgrunn:
  Gitt at det finnes et opptak som heter "UHG 2025"

Scenario: Endre opptaksnavn
  ...

Scenario: Slette opptak
  ...

Scenario: Publisere opptak
  ...
```

**Problemer med statisk testdata:**
1. **Parallellkjøring** - Flere scenarioer kan prøve å opprette/endre/slette samme data samtidig
2. **Cleanup-timing** - Ett scenarios teardown kan slette data som et annet scenario bruker
3. **Rekkefølgeavhengighet** - Tester blir avhengige av at andre tester har kjørt først

## Anbefalt løsning: Unik data per scenario + global cleanup

### 1. Generer unike identifikatorer

Hver test skal opprette sin egen testdata med unike navn. I stedet for statiske navn som "UHG 2025", generer unike navn med UUID eller timestamp:

```gherkin
Bakgrunn:
  Gitt at det finnes et opptak med unikt navn
```

Step definition genererer for eksempel:
- `"TEST-UHG-2025-1737043200123"` (med timestamp)
- `"TEST-UHG-2025-f47ac10b"` (med kort UUID)

**Fordeler:**
- Scenarioer deler aldri data
- Parallellkjøring fungerer uten konflikter
- Cleanup er trygt - hvert scenario eier sin egen data

### 2. Prefiks for testdata

All testdata bør ha et gjenkjennelig prefiks (f.eks. `TEST-`) slik at:
- Det er enkelt å identifisere testdata vs. reell data
- Global cleanup kan finne og slette all testdata
- Debugging blir enklere

### 3. Global cleanup fremfor per-scenario teardown

I stedet for å rydde opp etter hvert scenario, bruk global cleanup:

**Før testkjøring:**
- Slett all data som matcher `TEST-*` mønsteret
- Alternativt: Slett data eldre enn X timer

**Nattlig jobb:**
- Rydd opp data som ble liggende igjen fra feilede kjøringer

**Fordeler med global cleanup:**
- Enklere - ingen teardown-logikk per scenario
- Raskere - færre API-kall under testkjøring
- Tryggere - ingen race conditions under cleanup
- Debug-vennlig - data blir liggende hvis en test feiler, så du kan inspisere

### 4. Worker index for parallelle kjøringer (Playwright)

Playwright tildeler hver parallelle worker en unik `workerIndex`. Dette kan brukes for deterministisk dataisolasjon:

```typescript
// Worker 0 bruker "TEST-UHG-2025-W0"
// Worker 1 bruker "TEST-UHG-2025-W1"
const testDataSuffix = `W${testInfo.workerIndex}`;
```

## Implementasjon

### Scenario context

Generer unikt navn i Bakgrunn og lagre i scenario context:

```typescript
Given('at det finnes et opptak med unikt navn', async function() {
  const uniqueName = `TEST-UHG-${Date.now()}`;
  this.opptakNavn = uniqueName;
  await createOpptak(uniqueName);
});

When('jeg endrer opptaksnavnet', async function() {
  // Bruker this.opptakNavn fra Bakgrunn
  await editOpptak(this.opptakNavn);
});
```

### Global cleanup script

```typescript
// setup/cleanup.ts
async function cleanupTestData() {
  // Slett alle opptak som starter med TEST-
  const testOpptak = await findOpptakByPrefix('TEST-');
  for (const opptak of testOpptak) {
    await deleteOpptak(opptak.id);
  }
}
```

### Kjør cleanup før testsuite

I `playwright.config.ts`:

```typescript
export default defineConfig({
  globalSetup: './setup/global-setup.ts',
  // ...
});
```

```typescript
// setup/global-setup.ts
export default async function globalSetup() {
  await cleanupTestData();
}
```

## Gherkin-lesbarhet

Domeneksperter skal kunne lese Gherkin uten å tenke på UUIDs. Hold tekniske detaljer i step definitions:

**Lesbart for alle:**
```gherkin
Bakgrunn:
  Gitt at det finnes et opptak

Scenario: Endre opptaksnavn
  Når jeg endrer navnet til "Høstopptak 2026"
  Så skal opptaket hete "Høstopptak 2026"
```

**Teknisk implementasjon skjult:**
```typescript
Given('at det finnes et opptak', async function() {
  // Genererer unikt navn bak kulissene
  this.opptak = await createUniqueOpptak();
});
```

## Oppsummering

| Praksis | Beskrivelse |
|---------|-------------|
| Unik data per scenario | Bruk UUID/timestamp for å unngå konflikter |
| TEST-prefiks | Gjør testdata lett identifiserbar |
| Global cleanup | Rydd opp før testsuite, ikke etter hvert scenario |
| Scenario context | Del data mellom Bakgrunn og Scenario via context |
| Lesbar Gherkin | Hold tekniske detaljer i step definitions |

## Ressurser

- [Playwright Best Practices](https://playwright.dev/docs/best-practices)
- [A Test Data Strategy for Parallel Automation in Playwright](https://ultimateqa.com/a-test-data-strategy-for-parallel-automation-in-playwright/)
- [Cucumber State Management](https://cucumber.io/docs/cucumber/state/)
- [Test Setup and Teardown in Cucumber](https://johnfergusonsmart.com/test-setup-and-teardown-in-cucumber-and-serenity-bdd/)
