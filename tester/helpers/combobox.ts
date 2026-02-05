import { Page } from '@playwright/test'

interface ComboboxOptions {
  /** Option som skal velges */
  select: string | RegExp
  /** Knapp inne i option som skal klikkes (f.eks. "Legg til"). Hvis utelatt, klikkes option direkte. */
  actionButton?: string
  /** Combobox label for å identifisere riktig combobox på siden */
  comboboxLabel?: string
  /** Knappnavn for å åpne combobox (default: "Vis forslag"). Sett til null for å klikke på input. */
  openButton?: string | null
  /** Timeout i millisekunder (default: 10000) */
  timeout?: number
}

/**
 * Åpner en SDS combobox, finner riktig option og velger den.
 *
 * @example
 * // Velg option direkte (klikk på option)
 * await selectFromCombobox(page, {
 *   comboboxLabel: 'Kvoter',
 *   openButton: null,
 *   select: 'Ordinær kvote'
 * })
 *
 * // Velg option med "Legg til" knapp inne i option
 * await selectFromCombobox(page, {
 *   select: /Mastergrad i jordmorfag/,
 *   actionButton: 'Legg til'
 * })
 *
 * // Åpne via "Vis forslag" knapp (default) og velg
 * await selectFromCombobox(page, { select: 'Alternativ 1' })
 */
export async function selectFromCombobox(
  page: Page,
  options: ComboboxOptions
): Promise<void> {
  const { select, actionButton, openButton = 'Vis forslag', comboboxLabel, timeout = 10000 } = options

  // Åpne combobox
  if (openButton === null) {
    // Klikk direkte på combobox-input
    const combobox = page.getByRole('combobox', { name: comboboxLabel })
    await combobox.click()
  } else if (comboboxLabel) {
    // Klikk på knapp innenfor en spesifikk combobox
    const combobox = page.getByRole('combobox', { name: comboboxLabel })
    await combobox.getByRole('button', { name: openButton }).click()
  } else {
    // Klikk på "Vis forslag" knapp (default)
    await page.getByRole('button', { name: openButton }).click()
  }

  // Vent på at listbox har minst én option
  const listbox = page.getByRole('listbox')
  await listbox.getByRole('option').first().waitFor({ state: 'visible', timeout })

  // Finn og velg option
  const option = listbox.getByRole('option', { name: select }).first()
  await option.waitFor({ state: 'visible', timeout })

  if (actionButton) {
    // Klikk på knapp inne i option (f.eks. "Legg til")
    await option.getByRole('button', { name: actionButton }).click()
  } else {
    // Klikk direkte på option
    await option.click()
  }
}

/** @deprecated Bruk selectFromCombobox i stedet */
export const openCombobox = selectFromCombobox
