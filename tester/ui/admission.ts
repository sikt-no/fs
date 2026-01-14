/**
 * UI Adapter: Admission (Opptak)
 *
 * Pure Playwright selectors and interactions for admission management.
 * NO business logic - only "how" to interact with UI elements.
 */

import { Page } from '@playwright/test'

export async function navigateToAdmissionPage(page: Page): Promise<void> {
  await page.goto('/opptak')
}

export async function clickCreateLocalAdmission(page: Page): Promise<void> {
  await page.getByRole('link', { name: 'Velg Lokalt opptak' }).click()
}

export async function fillAdmissionNameBokmaal(page: Page, name: string): Promise<void> {
  const input = page.getByRole('textbox', { name: 'Navn på opptaket (bokmål)' })
  await input.click()
  await input.fill(name)
}

export async function selectAdmissionType(page: Page, typeValue: string): Promise<void> {
  await page.getByLabel('Hvilken type lokalt opptak?').selectOption(typeValue)
}

export async function clickSaveButton(page: Page): Promise<void> {
  await page.getByRole('button', { name: 'Lagre' }).click()
}

export async function clickCancelLink(page: Page): Promise<void> {
  await page.getByRole('link', { name: 'Avbryt' }).click()
}

export async function getAdmissionCell(page: Page, admissionName: string) {
  return page.getByRole('cell', { name: admissionName })
}

// TODO: Add selectors for:
// - setSøknadsfrist
// - setOppstartsdato
// - tilknyttUtdanningstilbud
