import { expect } from '@playwright/test'
import { createBdd } from 'playwright-bdd'
import { StudentActions } from '../domain/StudentActions'
import { readFileSync } from 'fs'
import { join } from 'path'
import 'dotenv/config'

const { Given, When, Then, Before } = createBdd()

Before({ tags: '@student-auth-test' }, async ({ context }) => {
  const authData = JSON.parse(
    readFileSync(join(process.cwd(), 'playwright/.auth/student.json'), 'utf-8')
  )
  await context.addCookies(authData.cookies)
})

Given('at jeg er innlogget som Student', async ({ page }) => {
  // Autentisering er allerede gjort i setup
})

When('jeg går til Min Kompetanse', async ({ page }) => {
  const studentActions = new StudentActions(page)
  await studentActions.gåTilMinKompetanse()
})

Then('skal jeg se riktig profil-lenke', async ({ page }) => {
  const forventetBrukernavn = process.env.TEST_USER_DISPLAY_NAME!
  const profilTekst = `Profil: ${forventetBrukernavn.split(' ')[0]}`
  const studentActions = new StudentActions(page)
  const erSynlig = await studentActions.erProfilLenkeSynlig(profilTekst)
  expect(erSynlig).toBe(true)
})

Then('valgt testsøker skal være korrekt', async ({ page }) => {
  const forventetTestsøker = process.env.STUDENT_TEST_USER!
  const studentActions = new StudentActions(page)
  const valgtTestsøker = await studentActions.hentValgtTestsøker()
  expect(valgtTestsøker).toContain(forventetTestsøker)
})
