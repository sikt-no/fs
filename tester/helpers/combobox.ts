import { Page } from '@playwright/test'

interface ComboboxOptions {
  /** Option som skal velges (valgfritt - hvis utelatt, åpnes bare combobox) */
  select?: string | RegExp
  /** Knappnavn for å åpne combobox (default: "Vis forslag") */
  buttonName?: string
  /** Label på combobox-feltet for å scope søket (valgfritt) */
  comboboxLabel?: string
  /** Timeout i millisekunder (default: 10000) */
  timeout?: number
}

/**
 * Åpner en SDS combobox og venter på at options lastes.
 * Kan også velge en spesifikk option hvis `select` er satt.
 *
 * @example
 * // Bare åpne combobox og vente på options
 * await openCombobox(page)
 *
 * // Åpne og velge en option
 * await openCombobox(page, { select: 'Ordinær kvote' })
 *
 * // Med regex-match
 * await openCombobox(page, { select: /Mastergrad/ })
 */
export async function openCombobox(
  page: Page,
  options: ComboboxOptions = {}
): Promise<void> {
  const { select, buttonName = 'Vis forslag', comboboxLabel, timeout = 10000 } = options

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

  // Velg option hvis spesifisert
  if (select) {
    const option = page.getByRole('option', { name: select }).first()
    await option.waitFor({ state: 'visible' })
    await option.click()
  }
}
