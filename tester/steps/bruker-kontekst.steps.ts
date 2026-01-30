import { createBdd } from 'playwright-bdd'
import { test, UserRole } from '../fixtures/user-context'

const { Given, When, Then } = createBdd(test)

const VALID_ROLES: UserRole[] = ['administrator', 'person']

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
 * Alternativ formulering for kontekst-bytte midt i et scenario.
 * Brukes typisk etter en "Så" for å skifte perspektiv.
 */
Then('hvis jeg logger inn som {word}', async ({ userContext }, role: string) => {
  await userContext.switchTo(validateRole(role))
})
