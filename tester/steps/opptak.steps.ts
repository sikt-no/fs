import { createBdd } from 'playwright-bdd'
import { test, expect } from '../fixtures/logged-in-states'

const { Given, When, Then } = createBdd(test)

// Lagrer sist opprettede opptak-navn for bruk i assertions
let sisteOpptakNavn: string

Given('at jeg er på opptakssiden', async ({ adminPage }) => {
  await adminPage.goto('/opptak')
})

Given('at opptaket {string} er publisert', async ({ adminPage }, opptakNavn: string) => {
  // TODO: Implementer sjekk eller opprett opptak
  await adminPage.goto('/opptak')
})

When('jeg oppretter et nytt lokalt opptak', async ({ adminPage }) => {
  await adminPage.getByRole('link', { name: 'Velg Lokalt opptak' }).click()
})

When('jeg setter navn til {string}', async ({ adminPage }, navn: string) => {
  sisteOpptakNavn = `${navn} - ${Date.now()}`
  await adminPage.getByRole('textbox', { name: 'Navn på opptaket (bokmål)' }).click()
  await adminPage.getByRole('textbox', { name: 'Navn på opptaket (bokmål)' }).fill(sisteOpptakNavn)
})

When('jeg setter type til {string}', async ({ adminPage }, type: string) => {
  // TODO: Map type-navn til value - nå hardkodet til "LOS"
  await adminPage.getByLabel('Hvilken type lokalt opptak?').selectOption('YTo1OiJMT0si')
})

When('jeg setter søknadsfrist til {string}', async ({ adminPage }, frist: string) => {
  // TODO: Implementer sett søknadsfrist
})

When('jeg setter oppstartsdato til {string}', async ({ adminPage }, dato: string) => {
  // TODO: Implementer sett oppstartsdato
})

When('jeg publiserer opptaket', async ({ adminPage }) => {
  await adminPage.getByRole('button', { name: 'Lagre' }).click()
  await adminPage.getByRole('link', { name: 'Avbryt' }).click()
})

When('jeg tilknytter utdanningstilbudet {string} til opptaket', async ({ adminPage }, utdanning: string) => {
  // TODO: Implementer tilknytning
})

Then('skal opptaket {string} være publisert', async ({ adminPage }, _opptakNavn: string) => {
  await adminPage.goto('/opptak')
  await expect(adminPage.getByRole('cell', { name: sisteOpptakNavn })).toBeVisible()
})

Then('skal {string} være søkbart for søkere', async ({ adminPage }, utdanning: string) => {
  // TODO: Implementer verifisering
})