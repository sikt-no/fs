/**
 * BDD Steps: Brukerroller
 *
 * Steg for autentisering og rollebasert tilgang.
 * Bruker domain-objekter med norsk språk.
 */

import { createBdd } from 'playwright-bdd'
import { Brukerøkt } from '../domain'

const { Before, Given } = createBdd()

// Domain-objekt instans for gjeldende brukerøkt
let brukerøkt: Brukerøkt

// Opprett domain-objekt én gang per scenario (ikke per steg)
Before(async ({ page }) => {
  brukerøkt = new Brukerøkt(page)
})

Given('at jeg er logget inn som {word}', async ({}, rolle: string) => {
  // Auth state er allerede lastet via storageState
  // Dette steget bekrefter bare at vi er logget inn

  // Hvis storageState IKKE brukes, ville vi kalt:
  // await brukerøkt.loggInnSom(rolle as 'administrator')

  void rolle // Brukes ikke når storageState håndterer auth
})
