import { Page } from '@playwright/test'

interface ComboboxOptions {
  /** Option som skal velges (valgfritt - hvis utelatt, åpnes bare combobox) */
  select?: string | RegExp
  /** Knappnavn for å åpne combobox (default: "Vis forslag"). Sett til null for å klikke på input direkte. */
  buttonName?: string | null
  /** Label på combobox-feltet (kreves når buttonName er null) */
  comboboxLabel?: string
  /** Timeout i millisekunder (default: 10000) */
  timeout?: number
}

/**
 * Åpner en SDS combobox og venter på at options lastes.
 * Kan også velge en spesifikk option hvis `select` er satt.
 *
 * @example
 * // Åpne via "Vis forslag" knapp (default)
 * await openCombobox(page)
 *
 * // Åpne ved å klikke på combobox-input direkte
 * await openCombobox(page, { comboboxLabel: 'Kvoter', buttonName: null, select: 'Ordinær kvote' })
 *
 * // Åpne og velge en option
 * await openCombobox(page, { select: 'Ordinær kvote' })
 */
export async function openCombobox(
  page: Page,
  options: ComboboxOptions = {}
): Promise<void> {
  const { select, buttonName = 'Vis forslag', comboboxLabel, timeout = 10000 } = options

  // Vent på at GraphQL-data er lastet før vi åpner combobox
  await page.waitForLoadState('networkidle')

  // Åpne combobox
  if (buttonName === null) {
    // Klikk direkte på combobox-input
    const combobox = page.getByRole('combobox', { name: comboboxLabel })
    await combobox.click()
  } else if (comboboxLabel) {
    // Klikk på knapp innenfor en spesifikk combobox
    const combobox = page.getByRole('combobox', { name: comboboxLabel })
    await combobox.getByRole('button', { name: buttonName }).click()
  } else {
    // Klikk på "Vis forslag" knapp (default)
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
