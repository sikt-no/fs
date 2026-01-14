/**
 * BDD Steps: Opptak
 *
 * Steg for opptaksflyt - bruker domain-objekter med state.
 * Følger POM 2.0 arkitektur med norsk domenespråk.
 */

import { createBdd } from 'playwright-bdd'
import { expect } from '@playwright/test'
import { Opptaksflyt } from '../domain'

const { Before, Given, When, Then } = createBdd()

// Domain-objekt instans for gjeldende scenario
let opptaksflyt: Opptaksflyt

// Opprett domain-objekt én gang per scenario (ikke per steg)
Before(async ({ page }) => {
  opptaksflyt = new Opptaksflyt(page)
})

Given('at jeg er på opptakssiden', async () => {
  await opptaksflyt.gåTilOpptakssiden()
})

Given('at opptaket {string} er publisert', async ({}, opptakNavn: string) => {
  // TODO: Implementer sjekk eller opprett opptak via domain
  await opptaksflyt.gåTilOpptakssiden()
  void opptakNavn
})

When('jeg oppretter et nytt lokalt opptak', async () => {
  await opptaksflyt.opprettLokaltOpptak()
})

When('jeg setter navn til {string}', async ({}, navn: string) => {
  await opptaksflyt.settNavn(navn)
})

When('jeg setter type til {string}', async ({}, type: string) => {
  await opptaksflyt.settType(type)
})

When('jeg setter søknadsfrist til {string}', async ({}, frist: string) => {
  // TODO: Implementer i Opptaksflyt
  void frist
})

When('jeg setter oppstartsdato til {string}', async ({}, dato: string) => {
  // TODO: Implementer i Opptaksflyt
  void dato
})

When('jeg publiserer opptaket', async () => {
  await opptaksflyt.publiserOpptak()
})

When('jeg tilknytter utdanningstilbudet {string} til opptaket', async ({}, utdanning: string) => {
  // TODO: Implementer i Opptaksflyt
  void utdanning
})

Then('skal opptaket {string} være publisert', async ({}, _opptakNavn: string) => {
  const sisteNavn = opptaksflyt.hentSisteOpptakNavn()
  expect(sisteNavn).toBeDefined()

  const erSynlig = await opptaksflyt.erOpptakSynlig(sisteNavn!)
  expect(erSynlig).toBe(true)
})

Then('skal {string} være søkbart for søkere', async ({}, utdanning: string) => {
  // TODO: Implementer verifisering
  void utdanning
})
