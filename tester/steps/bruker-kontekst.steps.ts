import { createBdd } from 'playwright-bdd'
import { test, UserRole } from '../fixtures/user-context'

const { Given } = createBdd(test)

/**
 * Step for å bytte brukerkontekst.
 * Alle påfølgende steps som bruker userContext.currentPage vil bruke denne rollen.
 *
 * Eksempel:
 *   Gitt at jeg er logget inn som administrator
 *   Gitt at jeg er logget inn som person
 */
Given('at jeg er logget inn som {word}', async ({ userContext }, role: string) => {
  const validRoles: UserRole[] = ['administrator', 'person']

  if (!validRoles.includes(role as UserRole)) {
    throw new Error(
      `Ugyldig rolle: "${role}". Gyldige roller er: ${validRoles.join(', ')}`
    )
  }

  await userContext.switchTo(role as UserRole)
})
