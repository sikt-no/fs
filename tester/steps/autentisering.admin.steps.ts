import { expect } from '@playwright/test'
import { createBdd } from 'playwright-bdd'
import { FsAdminActions } from '../domain/FsAdminActions'
import { readFileSync } from 'fs'
import { join } from 'path'
import 'dotenv/config'

const { Given, When, Then, Before } = createBdd()

Before({ tags: '@admin-auth-test' }, async ({ context }) => {
  const authData = JSON.parse(
    readFileSync(join(process.cwd(), 'playwright/.auth/fs-admin.json'), 'utf-8')
  )
  await context.addCookies(authData.cookies)
})

Given('at jeg er innlogget som FS-Admin', async ({ page }) => {
  // Autentisering er allerede gjort i setup
})

When('jeg går til FS-Admin', async ({ page }) => {
  const fsAdminActions = new FsAdminActions(page)
  await fsAdminActions.gåTilFsAdmin()
})

Then('skal jeg se riktig brukernavn', async ({ page }) => {
  const forventetBrukernavn = process.env.TEST_USER_DISPLAY_NAME!
  const fsAdminActions = new FsAdminActions(page)
  const hentetBrukernavn = await fsAdminActions.hentInnloggetBrukernavn(forventetBrukernavn)
  expect(hentetBrukernavn).toContain(forventetBrukernavn)
})

Then('overstyrt bruker skal være korrekt', async ({ page }) => {
  const forventetOverstyrtBruker = process.env.FS_ADMIN_OVERSTYRT_BRUKER!
  const fsAdminActions = new FsAdminActions(page)
  const overstyrtBruker = await fsAdminActions.hentOverstyrtBruker()
  expect(overstyrtBruker).toBe(forventetOverstyrtBruker)
})
