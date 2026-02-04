import { createBdd } from 'playwright-bdd'
import { test, expect } from '../fixtures/user-context'

const { Given, When, Then } = createBdd(test)

/**
 * Navigerer til personsøk-siden i FS Admin.
 */
Given('at jeg er på personsøksiden', async ({ userContext }) => {
  await userContext.currentPage.getByRole('link', { name: 'Personsøk' }).click()
  await userContext.currentPage.waitForLoadState('networkidle')
  // Vent på at søkefeltet er synlig før vi fortsetter
  await userContext.currentPage.getByRole('searchbox', { name: /Søk etter person/ }).waitFor({ state: 'visible' })
})

/**
 * Utfører et søk i personsøk-feltet.
 */
When('jeg søker etter {string}', async ({ userContext }, søkeord: string) => {
  const searchBox = userContext.currentPage.getByRole('searchbox', { name: /Søk etter person/ })
  await searchBox.click()
  await searchBox.fill(søkeord)
  await userContext.currentPage.getByRole('button', { name: 'Søk på person' }).click()
  await userContext.currentPage.waitForLoadState('networkidle')
})

/**
 * Verifiserer at vi er på personprofilen til en spesifikk person.
 */
Then('skal jeg se personprofilen til {string}', async ({ userContext }, personnavn: string) => {
  await expect(userContext.currentPage.getByRole('heading', { name: personnavn })).toBeVisible()
})

/**
 * Verifiserer at søkeresultatet viser en liste (ikke direktetreff).
 */
Then('skal jeg se en liste med søkeresultater', async ({ userContext }) => {
  // Liste vises med rowheader for hver person
  const rowheaders = userContext.currentPage.getByRole('rowheader')
  await expect(rowheaders.first()).toBeVisible()
})

/**
 * Verifiserer at en person vises i søkeresultatlisten.
 */
Then('listen skal inneholde {string}', async ({ userContext }, personnavn: string) => {
  await expect(userContext.currentPage.getByRole('rowheader', { name: personnavn })).toBeVisible()
})

/**
 * Verifiserer at en tekst er synlig på siden.
 */
Then('skal jeg se {string}', async ({ userContext }, tekst: string) => {
  await expect(userContext.currentPage.getByText(tekst)).toBeVisible()
})

/**
 * Verifiserer at "ingen resultater" vises.
 */
Then('skal jeg se ingen resultater', async ({ userContext }) => {
  await expect(userContext.currentPage.getByRole('rowheader', { name: 'Ingen resultater for søket:' })).toBeVisible()
})
