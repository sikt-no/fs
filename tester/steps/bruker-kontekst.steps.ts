import { createBdd } from 'playwright-bdd'
import { test, UserRole } from '../fixtures/user-context'

const { Given, When, Then } = createBdd(test)

const VALID_ROLES: UserRole[] = ['administrator', 'person', 'personsok-administrator']

function validateRole(role: string): UserRole {
  if (!VALID_ROLES.includes(role as UserRole)) {
    throw new Error(
      `Ugyldig rolle: "${role}". Gyldige roller er: ${VALID_ROLES.join(', ')}`
    )
  }
  return role as UserRole
}

/**
 * Step for å bytte brukerkontekst.
 * Alle påfølgende steps som bruker userContext.currentPage vil bruke denne rollen.
 *
 * Eksempel:
 *   Gitt at jeg er logget inn som administrator
 *   Gitt at jeg er logget inn som person
 */
Given('at jeg er logget inn som {word}', async ({ userContext }, role: string) => {
  await userContext.switchTo(validateRole(role))
})

/**
 * Logger inn som personsøk-administrator med tilgang til personopplysninger.
 * Brukes i personsøk-scenarioer hvor produktleder ønsker en mer beskrivende formulering.
 */
Given('at jeg er logget inn med tilgang til å lese personopplysninger', async ({ userContext }) => {
  await userContext.switchTo('personsok-administrator')
})

/**
 * Alternativ formulering for kontekst-bytte midt i et scenario.
 * Brukes typisk etter en "Så" for å skifte perspektiv.
 */
Then('hvis jeg logger inn som {word}', async ({ userContext }, role: string) => {
  await userContext.switchTo(validateRole(role))
})

/**
 * Bytter til en annen rolle midt i et scenario.
 */
When('jeg bytter til {word}', async ({ userContext }, role: string) => {
  await userContext.switchTo(validateRole(role))
})

/**
 * Verifiserer at tekst er synlig i menyen (administrator).
 */
Then('skal jeg se {string} i menyen', async ({ userContext }, tekst: string) => {
  const { expect } = await import('@playwright/test')
  await expect(userContext.currentPage.getByRole('navigation').getByText(tekst)).toBeVisible()
})

/**
 * Verifiserer at tekst er synlig på siden.
 */
Then('skal jeg se {string} på siden', async ({ userContext }, tekst: string) => {
  const { expect } = await import('@playwright/test')
  await expect(userContext.currentPage.getByText(tekst)).toBeVisible()
})

/**
 * Verifiserer at vi er på adminflaten basert på URL.
 */
Then('skal jeg være på adminflaten', async ({ userContext }) => {
  const { expect } = await import('@playwright/test')
  await expect(userContext.currentPage).toHaveURL(/fs-admin/)
})

/**
 * Verifiserer at vi er på personflaten basert på URL.
 */
Then('skal jeg være på personflaten', async ({ userContext }) => {
  const { expect } = await import('@playwright/test')
  await expect(userContext.currentPage).toHaveURL(/minkompetanse/)
})
