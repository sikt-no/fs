/**
 * Eksempel på godt strukturerte Playwright BDD step-definisjoner.
 *
 * Dette eksempelet viser:
 * - Riktig import-struktur
 * - Bruk av userContext fixture for multi-rolle tester
 * - JSDoc-dokumentasjon
 * - Parameteriserte steps
 * - Robust ventelogikk
 */

import { createBdd } from 'playwright-bdd'
import { test, expect } from '../fixtures/user-context'

const { Given, When, Then } = createBdd(test)

// ============ Gitt-steps (forutsetninger) ============

/**
 * Navigerer til en spesifikk side i applikasjonen.
 *
 * Eksempel bruk i Gherkin:
 *   Gitt at jeg er på opptakssiden
 */
Given('at jeg er på opptakssiden', async ({ userContext }) => {
  await userContext.currentPage.getByRole('link', { name: 'Opptak' }).click()
  await userContext.currentPage.waitForLoadState('networkidle')
})

/**
 * Verifiserer at et element eksisterer før vi fortsetter.
 *
 * Eksempel bruk:
 *   Gitt at opptaket "Høstopptak 2024" finnes
 */
Given('at opptaket {string} finnes', async ({ userContext }, opptakNavn: string) => {
  const opptak = userContext.currentPage.getByRole('cell', { name: opptakNavn })
  await expect(opptak).toBeVisible()
})

// ============ Når-steps (handlinger) ============

/**
 * Klikker på en knapp med gitt tekst.
 *
 * Eksempel bruk:
 *   Når jeg klikker på "Lagre"
 */
When('jeg klikker på {string}', async ({ userContext }, knappTekst: string) => {
  await userContext.currentPage.getByRole('button', { name: knappTekst }).click()
})

/**
 * Fyller ut et skjemafelt identifisert med label.
 *
 * Eksempel bruk:
 *   Når jeg fyller inn "Test opptak" i feltet "Navn"
 */
When(
  'jeg fyller inn {string} i feltet {string}',
  async ({ userContext }, verdi: string, feltLabel: string) => {
    await userContext.currentPage.getByLabel(feltLabel).fill(verdi)
  }
)

/**
 * Velger en verdi fra en dropdown/select.
 *
 * Eksempel bruk:
 *   Når jeg velger "Lokalt opptak" fra "Type opptak"
 */
When(
  'jeg velger {string} fra {string}',
  async ({ userContext }, verdi: string, feltLabel: string) => {
    await userContext.currentPage.getByLabel(feltLabel).selectOption({ label: verdi })
  }
)

/**
 * Håndterer asynkrone operasjoner med venting.
 *
 * Eksempel bruk:
 *   Når jeg lagrer opptaket
 */
When('jeg lagrer opptaket', async ({ userContext }) => {
  await userContext.currentPage.getByRole('button', { name: 'Lagre' }).click()
  await userContext.currentPage.waitForLoadState('networkidle')
})

// ============ Så-steps (forventninger) ============

/**
 * Verifiserer at tekst er synlig på siden.
 *
 * Eksempel bruk:
 *   Så skal jeg se "Opptaket er lagret"
 */
Then('skal jeg se {string}', async ({ userContext }, forventetTekst: string) => {
  await expect(userContext.currentPage.getByText(forventetTekst)).toBeVisible()
})

/**
 * Verifiserer at et element IKKE er synlig.
 *
 * Eksempel bruk:
 *   Så skal jeg ikke se "Feilmelding"
 */
Then('skal jeg ikke se {string}', async ({ userContext }, tekst: string) => {
  await expect(userContext.currentPage.getByText(tekst)).not.toBeVisible()
})

/**
 * Verifiserer at vi er på en spesifikk URL.
 *
 * Eksempel bruk:
 *   Så skal jeg være på siden "/opptak/123"
 */
Then('skal jeg være på siden {string}', async ({ userContext }, urlDel: string) => {
  await expect(userContext.currentPage).toHaveURL(new RegExp(urlDel))
})

/**
 * Verifiserer innhold i en tabell.
 *
 * Eksempel bruk:
 *   Så skal tabellen inneholde "Høstopptak 2024"
 */
Then('skal tabellen inneholde {string}', async ({ userContext }, celleTekst: string) => {
  const tabell = userContext.currentPage.getByRole('table')
  await expect(tabell.getByRole('cell', { name: celleTekst })).toBeVisible()
})

// ============ Hjelpefunksjoner ============

/**
 * Eksempel på hjelpefunksjon som kan gjenbrukes på tvers av steps.
 * Plasser slike i tester/helpers/ mappen.
 */
async function ventPåLasting(page: import('@playwright/test').Page) {
  await page.waitForLoadState('networkidle')
  // Vent på at eventuell skeleton/loader forsvinner
  const loader = page.getByRole('progressbar')
  if (await loader.isVisible({ timeout: 100 }).catch(() => false)) {
    await loader.waitFor({ state: 'hidden' })
  }
}
