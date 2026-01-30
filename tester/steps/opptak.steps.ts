import { createBdd } from 'playwright-bdd'
import { test, expect } from '../fixtures/user-context'

const { Given, When, Then } = createBdd(test)

// Lagrer sist opprettede opptak-navn for bruk i assertions
let sisteOpptakNavn: string

Given('at jeg er på opptakssiden', async ({ userContext }) => {
  await userContext.currentPage.goto('/opptak')
})

Given('at opptaket {string} er publisert', async ({ userContext }, opptakNavn: string) => {
  // TODO: Implementer sjekk eller opprett opptak
  await userContext.currentPage.goto('/opptak')
})

When('jeg oppretter et nytt lokalt opptak', async ({ userContext }) => {
  await userContext.currentPage.getByRole('link', { name: 'Velg Lokalt opptak' }).click()
})

When('jeg setter navn til {string}', async ({ userContext }, navn: string) => {
  sisteOpptakNavn = `${navn} - ${Date.now()}`
  await userContext.currentPage.getByRole('textbox', { name: 'Navn på opptaket (bokmål)' }).click()
  await userContext.currentPage.getByRole('textbox', { name: 'Navn på opptaket (bokmål)' }).fill(sisteOpptakNavn)
})

When('jeg setter type til {string}', async ({ userContext }, type: string) => {
  // TODO: Map type-navn til value - nå hardkodet til "LOS"
  await userContext.currentPage.getByLabel('Hvilken type lokalt opptak?').selectOption('YTo1OiJMT0si')
})

When('jeg setter søknadsfrist til {string}', async ({ userContext }, frist: string) => {
  // TODO: Implementer sett søknadsfrist
})

When('jeg setter oppstartsdato til {string}', async ({ userContext }, dato: string) => {
  // TODO: Implementer sett oppstartsdato
})

When('jeg publiserer opptaket', async ({ userContext }) => {
  await userContext.currentPage.getByRole('button', { name: 'Lagre' }).click()
  await userContext.currentPage.getByRole('link', { name: 'Avbryt' }).click()
})

When('jeg tilknytter utdanningstilbudet {string} til opptaket', async ({ userContext }, utdanning: string) => {
  // TODO: Implementer tilknytning
})

Then('skal opptaket {string} være publisert', async ({ userContext }, _opptakNavn: string) => {
  await userContext.currentPage.goto('/opptak')
  await expect(userContext.currentPage.getByRole('cell', { name: sisteOpptakNavn })).toBeVisible()
})

Then('skal {string} være søkbart for søkere', async ({ userContext }, utdanning: string) => {
  // TODO: Implementer verifisering
})
