import { createBdd } from 'playwright-bdd'
import { test, expect } from '../fixtures/user-context'

const { Given, When, Then } = createBdd(test)

// Lagrer sist opprettede opptak-navn for bruk i assertions
let sisteOpptakNavn: string

Given('at jeg er på opptakssiden', async ({ userContext }) => {
  await userContext.currentPage.getByRole('link', { name: 'Opptak' }).click()
})

Given('at opptaket {string} er publisert', async ({ userContext }, opptakNavn: string) => {
  // TODO: Implementer sjekk eller opprett opptak
  await userContext.currentPage.goto(`${process.env.FS_ADMIN_URL}/opptak`)
})

When('jeg oppretter et nytt lokalt opptak', async ({ userContext }) => {
  await userContext.currentPage.getByRole('link', { name: 'Velg Lokalt opptak' }).click()
})

When('jeg setter navn til {string}', async ({ userContext }, navn: string) => {
  sisteOpptakNavn = `Test ${Date.now()}`
  await userContext.currentPage.getByRole('textbox', { name: 'Navn på opptaket (bokmål)' }).click()
  await userContext.currentPage.getByRole('textbox', { name: 'Navn på opptaket (bokmål)' }).fill(sisteOpptakNavn)
})

When('jeg setter type til {string}', async ({ userContext }, type: string) => {
  // TODO: Map type-navn til value - nå hardkodet til "LOS"
  await userContext.currentPage.getByLabel('Hvilken type lokalt opptak?').selectOption('YTo1OiJMT0si')
  // Vent på at frister og andre data lastes inn
  await userContext.currentPage.waitForLoadState('networkidle')
})

When('jeg setter søknadsfrist til {string}', async ({ userContext }, frist: string) => {
  // TODO: Implementer sett søknadsfrist
})

When('jeg setter oppstartsdato til {string}', async ({ userContext }, dato: string) => {
  // TODO: Implementer sett oppstartsdato
})

When('jeg lagrer opptaket', async ({ userContext }) => {
  await userContext.currentPage.getByRole('button', { name: 'Lagre' }).click()
  await userContext.currentPage.waitForTimeout(2000)
})

When('jeg tilknytter utdanningstilbud til opptaket', async ({ userContext }) => {
  await userContext.currentPage.getByRole('button', { name: 'Tilknytt utdanningstilbud' }).click()
  await userContext.currentPage.waitForLoadState('networkidle')
  await userContext.currentPage.getByRole('tab', { name: 'Legg til nytt studiealternativ' }).click()
  await userContext.currentPage.waitForLoadState('networkidle')

  // Klikk på "Vis forslag" knappen
  await userContext.currentPage.getByRole('button', { name: 'Vis forslag' }).click()

  // Vent på at option vises i listen
  const option = userContext.currentPage.getByRole('option', { name: /Mastergrad i jordmorfag/ }).first()
  await option.waitFor({ state: 'visible' })
  await option.getByRole('button', { name: 'Legg til' }).click()

  // Lukk combobox ved å trykke Escape
  await userContext.currentPage.keyboard.press('Escape')
  await userContext.currentPage.waitForLoadState('networkidle')
})

When('jeg konfigurerer studiealternativet', async ({ userContext }) => {
  await userContext.currentPage.waitForLoadState('networkidle')
  const visButton = userContext.currentPage.getByRole('button', { name: 'Vis', exact: true })
  await visButton.waitFor({ state: 'visible' })
  await visButton.scrollIntoViewIfNeeded()
  await visButton.click()
  await userContext.currentPage.getByLabel('Kompetanseregelverk (Kravkode').selectOption('YToxMTk6IktNMzEwMiI=')
  await userContext.currentPage.getByLabel('RangeringsregelverkIkke valgt').selectOption('YToxNToiUk0zMTAyIg==')
  await userContext.currentPage.waitForLoadState('networkidle')
  const kvoterText = userContext.currentPage.getByText('KvoterTabell over')
  await kvoterText.scrollIntoViewIfNeeded()
  await expect(kvoterText).toBeVisible()
  await userContext.currentPage.getByRole('button', { name: 'Vis forslag' }).click()
  await userContext.currentPage.waitForTimeout(1000)
  await userContext.currentPage.getByRole('option', { name: 'Ordinær kvote' }).click()
  await userContext.currentPage.keyboard.press('Escape')
  await userContext.currentPage.waitForLoadState('networkidle')
  await userContext.currentPage.getByRole('button', { name: 'Lagre' }).click()
})

When('jeg publiserer opptaket', async ({ userContext }) => {
  await userContext.currentPage.getByRole('button', { name: 'Lagre' }).click()
  await userContext.currentPage.getByRole('link', { name: 'Avbryt' }).click()
})

When('jeg tilknytter utdanningstilbudet {string} til opptaket', async ({ userContext }, utdanning: string) => {
  // TODO: Implementer med spesifikt utdanningstilbud
})

Then('skal opptaket {string} være publisert', async ({ userContext }, _opptakNavn: string) => {
  await userContext.currentPage.goto(`${process.env.FS_ADMIN_URL}/opptak`)
  await expect(userContext.currentPage.getByRole('cell', { name: sisteOpptakNavn })).toBeVisible()
})

Then('skal {string} være søkbart for søkere', async ({ userContext }, utdanning: string) => {
  // TODO: Implementer verifisering
})

When('jeg søker etter {string} på finn studier', async ({ userContext }, søkeord: string) => {
  await userContext.currentPage.goto(`${process.env.MIN_KOMPETANSE_URL}/utforsk-studier?resultsPerPage=75&sort=studiesDesc&q=${encodeURIComponent(søkeord)}`)
  await userContext.currentPage.waitForLoadState('networkidle')
  await userContext.currentPage.getByRole('button', { name: 'Legg til' }).first().waitFor({ state: 'visible', timeout: 10000 })
})

When('jeg legger til alle studier i kurven', async ({ userContext }) => {
  const addToCartButtons = userContext.currentPage.getByRole('button', { name: 'Legg til' })
  const buttonCount = await addToCartButtons.count()

  for (let i = 0; i < buttonCount; i++) {
    await addToCartButtons.first().click()
    await userContext.currentPage.waitForTimeout(500)
  }
})

When('jeg går til studiekurven', async ({ userContext }) => {
  // Lukk informasjonskapsler-dialog hvis den vises
  const cookieButton = userContext.currentPage.getByRole('button', { name: 'Avvis informasjonskapsler' })
  if (await cookieButton.isVisible({ timeout: 2000 }).catch(() => false)) {
    await cookieButton.click()
  }
  await userContext.currentPage.getByRole('link', { name: 'studier i kurv Til studiekurv' }).click()
})

Then('skal opptaket {string} være synlig', async ({ userContext }, _opptakNavn: string) => {
  // Bruker sisteOpptakNavn som ble satt da opptaket ble opprettet
  await expect(userContext.currentPage.getByText(sisteOpptakNavn)).toBeVisible()
})
