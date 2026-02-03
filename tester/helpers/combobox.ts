import { Page } from '@playwright/test'

interface OpenComboboxOptions {
  /** Label på combobox-feltet for å scope søket (valgfritt) */
  comboboxLabel?: string
  /** Timeout i millisekunder (default: 10000) */
  timeout?: number
}

/**
 * Åpner en SDS combobox ved å klikke "Vis forslag" og venter på at options lastes.
 * Venter først på at GraphQL-data er lastet (networkidle), deretter klikker og venter på options.
 */
export async function openComboboxAndWaitForOptions(
  page: Page,
  buttonName: string = 'Vis forslag',
  options: OpenComboboxOptions = {}
): Promise<void> {
  const { comboboxLabel, timeout = 10000 } = options

  // Vent på at GraphQL-data er lastet før vi åpner combobox
  await page.waitForLoadState('networkidle')

  // Finn og klikk knappen, evt. scopet til en bestemt combobox
  if (comboboxLabel) {
    const combobox = page.getByRole('combobox', { name: comboboxLabel })
    await combobox.getByRole('button', { name: buttonName }).click()
  } else {
    await page.getByRole('button', { name: buttonName }).click()
  }

  // Vent på at listbox har minst én option
  await page
    .locator('[role="listbox"] [role="option"]')
    .first()
    .waitFor({ state: 'visible', timeout })
}

/**
 * Velger en option fra en åpen combobox listbox.
 */
export async function selectComboboxOption(
  page: Page,
  optionName: string | RegExp
): Promise<void> {
  const option = page.getByRole('option', { name: optionName }).first()
  await option.waitFor({ state: 'visible' })
  await option.click()
}

/**
 * Åpner combobox, venter på options, og velger en spesifikk option.
 * Kombinerer openComboboxAndWaitForOptions og selectComboboxOption.
 */
export async function selectFromCombobox(
  page: Page,
  optionName: string | RegExp,
  buttonName: string = 'Vis forslag',
  options: OpenComboboxOptions = {}
): Promise<void> {
  await openComboboxAndWaitForOptions(page, buttonName, options)
  await selectComboboxOption(page, optionName)
}
