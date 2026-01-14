# Claude AI – Arkitekturregler for Playwright / Cucumber

Dette dokumentet beskriver arkitektur- og designregler for testkode, med mål om **minimalistisk POM 2.0**, domain-driven design og **norsk domenespråk**.

---

## 1. Mål

1. Erstatt klassisk Page Object Model (POM) med domain-drevet arkitektur.
2. Sørg for at tester beskriver **intensjon**, ikke UI-klikk.
3. Bruk **norsk domenespråk** for klassenavn og metode-navn i domain-laget.
4. Reduser unødvendige E2E-tester (~70%) ved å flytte logikk til domain, API- eller komponenttester.
5. Dokumentet fungerer som AI / team guardrail for fremtidige endringer.

---

## 2. Folder-struktur

```
/tests      → Steg / orkestrering / assertions
/domain     → Business flows / domain-objekter (norsk språk, klasser med state)
/ui         → Stateless UI-adaptere med Playwright selectors og handlinger
/assertions → Valgfrie eksplisitte forventninger
```

---

## 3. Hard Rules

1. **Ingen PageObjects** i test- eller domain-filer.
2. **Domain-objekter er klasser**, ikke funksjoner.
3. **Domain-objekter bruker NORSK domenespråk** (Brukerøkt, Opptaksflyt, etc.).
4. Domain-lag må **aldri** bruke selectors eller Playwright API direkte.
5. UI-adaptere skal være:
   - Funksjoner (ingen klasser)
   - Stateless
   - Kun ansvarlige for selectors og UI-handlinger
6. Steg-filer skal kun orkestrere domain-objekter, ikke UI.
7. **Ingen globale variabler for teststate** - state holdes i domain-objekter.

---

## 4. Eksempel på domain-lag med norsk språk

```typescript
// domain/Opptaksflyt.ts
export class Opptaksflyt {
  private sisteOpptakNavn?: string

  constructor(private readonly side: Page) {}

  async opprettLokaltOpptak() {
    await ui.admission.navigerTilOpptak(this.side)
    await ui.admission.klikkOpprettLokalt(this.side)
  }

  async settNavn(navn: string) {
    this.sisteOpptakNavn = `${navn} - ${Date.now()}`
    await ui.admission.fyllNavn(this.side, this.sisteOpptakNavn)
  }

  hentSisteOpptakNavn(): string | undefined {
    return this.sisteOpptakNavn
  }
}
```

```typescript
// domain/Brukerøkt.ts
export class Brukerøkt {
  private brukernavn?: string
  private rolle?: string

  constructor(private readonly side: Page) {}

  async loggInnMedFeide(brukernavn: string, passord: string) {
    this.brukernavn = brukernavn
    await ui.auth.clickLoginWithFeide(this.side)
    await ui.auth.fillUsername(this.side, brukernavn)
    await ui.auth.fillPassword(this.side, passord)
    await ui.auth.clickLoginButton(this.side)
  }

  hentBrukernavn(): string | undefined {
    return this.brukernavn
  }
}
```

---

## 5. Eksempel på UI-lag (stateless funksjoner)

```typescript
// ui/admission.ts
export async function navigerTilOpptak(page: Page): Promise<void> {
  await page.goto('/opptak')
}

export async function klikkOpprettLokalt(page: Page): Promise<void> {
  await page.getByRole('link', { name: 'Velg Lokalt opptak' }).click()
}

export async function fyllNavn(page: Page, navn: string): Promise<void> {
  await page.getByRole('textbox', { name: 'Navn på opptaket' }).fill(navn)
}
```

---

## 6. Eksempel på steg-fil med domain-objekter

```typescript
// steps/opptak.steps.ts
import { createBdd } from 'playwright-bdd'
import { expect } from '@playwright/test'
import { Opptaksflyt } from '../domain'

const { Before, Given, When, Then } = createBdd()

let opptaksflyt: Opptaksflyt

// Opprett domain-objekt én gang per scenario (IKKE per steg)
Before(async ({ page }) => {
  opptaksflyt = new Opptaksflyt(page)
})

Given('at jeg er på opptakssiden', async () => {
  await opptaksflyt.gåTilOpptakssiden()
})

When('jeg oppretter et nytt lokalt opptak', async () => {
  await opptaksflyt.opprettLokaltOpptak()
})

When('jeg setter navn til {string}', async ({}, navn: string) => {
  await opptaksflyt.settNavn(navn)
})

Then('skal opptaket være publisert', async () => {
  const navn = opptaksflyt.hentSisteOpptakNavn()
  expect(navn).toBeDefined()

  const erSynlig = await opptaksflyt.erOpptakSynlig(navn!)
  expect(erSynlig).toBe(true)
})
```

**Viktig:** Legg merke til at:
- Domain-objektet opprettes **én gang per scenario** i `Before`-hook
- `opptaksflyt` er en **instans** av domain-klassen
- State (som `sisteOpptakNavn`) holdes **i domain-objektet**, ikke som global variabel
- Step-funksjoner kaller **metoder på domain-objektet**, ikke UI-funksjoner direkte
- Given-steg **ikke lenger oppretter** nye instanser - de bruker eksisterende

---

## 7. DO / DO NOT

### ✅ DO

- Bruk domain-objekter (klasser) for forretningsflyt
- Hold state i domain-objekter, ikke globale variabler
- Ha UI-adaptere som isolert lag (funksjoner)
- Bruk **norsk domenespråk** for alle domain-klasser og metoder
- **Instansier domain-objekter i Before-hook** (én gang per scenario)
- Flytt E2E-testlogikk til API / komponent der det gir mening

### ❌ DO NOT

- Bruk PageObjects eller BasePage-klasser
- Bruk funksjonsbasert domain-lag (domain MÅ være klasser)
- Bruk engelsk i domain-laget (bruk norsk)
- **Opprett domain-objekter i Given-steg** (bruk Before-hook)
- Ha UI-logikk i steg- eller domain-filer
- Bruk globale variabler for state (f.eks. `let sisteOpptakNavn: string`)
- La testene være UI-avhengige der det ikke er nødvendig

---

## 8. Forskjell: Domain-klasser vs. Page Objects

| Konsept | Page Object (❌ FORBUDT) | Domain-objekt (✅ PÅKREVD) |
|---------|--------------------------|----------------------------|
| **Fokus** | UI-struktur (sider/komponenter) | Forretningsprosesser |
| **Språk** | Engelsk, UI-orientert | Norsk domenespråk |
| **Innhold** | Locators + UI-handlinger | Forretningslogikk + state |
| **State** | Sjelden (eller global) | Holder scenario-state |
| **Navn** | LoginPage, DashboardPage | Brukerøkt, Opptaksflyt |
| **Metoder** | clickLoginButton() | loggInnMedFeide() |

**Eksempel:**

```typescript
// ❌ Page Object (FORBUDT)
class LoginPage {
  readonly loginButton = page.locator('#login')  // Locator i klassen

  constructor(readonly page: Page) {}

  async clickLogin() {
    await this.loginButton.click()  // Direkte UI-handling
  }
}

// ✅ Domain-objekt (PÅKREVD)
class Brukerøkt {
  private brukernavn?: string  // State

  constructor(private readonly side: Page) {}

  async loggInnMedFeide(brukernavn: string, passord: string) {
    this.brukernavn = brukernavn
    // Orkestrerer UI-adaptere (ingen direkte selectors)
    await ui.auth.clickLoginButton(this.side)
  }

  hentBrukernavn(): string | undefined {
    return this.brukernavn  // Eksponerer state
  }
}
```

---

## 9. State Management og Instansiering

**VIKTIG:**
1. Alle scenario-state MÅ holdes i domain-objekter, ikke som globale variabler.
2. Domain-objekter MÅ opprettes i Before-hook, ikke i Given-steg.

### ❌ FEIL (Global state + instansiering i Given):
```typescript
let sisteOpptakNavn: string  // ❌ Global variabel

Given('at jeg er på opptakssiden', async ({ page }) => {
  // ❌ Opprett ny instans i hvert Given-steg
  opptaksflyt = new Opptaksflyt(page)
})

When('jeg setter navn til {string}', async ({}, navn: string) => {
  sisteOpptakNavn = `${navn} - ${Date.now()}`
  await ui.admission.fyllNavn(page, sisteOpptakNavn)
})
```

### ✅ RIKTIG (State i domain-objekt + Before-hook):
```typescript
let opptaksflyt: Opptaksflyt  // Instans

// ✅ Opprett én gang per scenario
Before(async ({ page }) => {
  opptaksflyt = new Opptaksflyt(page)
})

Given('at jeg er på opptakssiden', async () => {
  // ✅ Bruker eksisterende instans
  await opptaksflyt.gåTilOpptakssiden()
})

When('jeg setter navn til {string}', async ({}, navn: string) => {
  await opptaksflyt.settNavn(navn)  // State holdes i Opptaksflyt
})

Then('skal opptaket være synlig', async () => {
  const navn = opptaksflyt.hentSisteOpptakNavn()  // Henter state fra objekt
  const erSynlig = await opptaksflyt.erOpptakSynlig(navn!)
  expect(erSynlig).toBe(true)
})
```

---

## 10. Norsk domenespråk - Eksempler

| Engelsk (❌) | Norsk (✅) |
|--------------|-----------|
| UserSession | Brukerøkt |
| AdmissionWorkflow | Opptaksflyt |
| login() | loggInn() |
| createAdmission() | opprettOpptak() |
| setName() | settNavn() |
| publish() | publiser() |
| getLastAdmissionName() | hentSisteOpptakNavn() |

**Konsistent bruk:**
- Klasser: `Brukerøkt`, `Opptaksflyt`, `Søknadsbehandling`
- Metoder: `loggInn()`, `opprettOpptak()`, `settNavn()`
- Variabler: `opptaksflyt`, `brukerøkt`, `søknad`

---

## 11. E2E-reduksjon

- Flytt alt som kan testes via API eller komponenttester
- Behold kun kritiske brukerflyter som tynn E2E-verifisering
- Dette kan redusere ~70% av E2E-testene

**Strategi:**
- GraphQL-tester → API-tester
- Auth-flow → 1 smoke test + API-tester
- Opptak-opprettelse → API fixtures + 1 visuell test
- Form-validering → Komponenttester

---

## 12. Sjekkliste for ny kode

Før commit, verifiser:

- [ ] Domain-objekter er **klasser** (ikke funksjoner)
- [ ] Domain-objekter bruker **norsk** domenespråk
- [ ] State holdes i domain-objekter, ikke globale variabler
- [ ] Domain-objekter instansieres i **Before-hook** (ikke i Given-steg)
- [ ] Step-filer deklarerer variabel: `let opptaksflyt: Opptaksflyt`
- [ ] Ingen selectors eller Playwright APIs i `domain/`
- [ ] Alle UI-interaksjoner er i `ui/` adapter-funksjoner (stateless)
- [ ] Ingen Page Objects eller arvehierarkier
- [ ] Testfiler leser som forretningskrav

---

## 13. Vanlige feil å unngå

1. ❌ **Funksjonsbasert domain**
   ```typescript
   export function opprettOpptak(page: Page) { ... }  // FEIL
   ```
   ✅ Bruk klasser: `class Opptaksflyt { ... }`

2. ❌ **Engelsk i domain**
   ```typescript
   class AdmissionWorkflow { ... }  // FEIL
   ```
   ✅ Bruk norsk: `class Opptaksflyt { ... }`

3. ❌ **Global state**
   ```typescript
   let sisteOpptakNavn: string  // FEIL
   ```
   ✅ State i klassen: `private sisteOpptakNavn?: string`

4. ❌ **Instansiering i Given-steg**
   ```typescript
   Given('at jeg er på siden', async ({ page }) => {
     opptaksflyt = new Opptaksflyt(page)  // FEIL
   })
   ```
   ✅ Bruk Before-hook: `Before(async ({ page }) => { ... })`

5. ❌ **UI-kall i step-filer**
   ```typescript
   When('jeg klikker', async ({ page }) => {
     await page.getByRole('button').click()  // FEIL
   })
   ```
   ✅ Bruk domain: `await opptaksflyt.publiser()`

---

**Sist oppdatert:** 2026-01-14
**Status:** Aktive arkitekturregler for team og AI-assistanse
**Håndheves av:** Code review + AI-referanse (Claude, GitHub Copilot)
