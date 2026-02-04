import { createBdd } from 'playwright-bdd'
import { expect } from '@playwright/test'
import { FsAdminLoginPage } from '../pages/fs-admin/FsAdminLoginPage'
import { MinKompetanseLoginPage } from '../pages/min-kompetanse/MinKompetanseLoginPage'
import 'dotenv/config'

const { Given, When, Then } = createBdd()

const ADMIN_AUTH_FILE = 'playwright/.auth/fs-admin.json'
const PERSON_AUTH_FILE = 'playwright/.auth/person.json'

// ============ Administrator steps ============

Given('at administratoren er på innloggingssiden til adminflaten', async ({ page }) => {
  await page.goto(process.env.FS_ADMIN_URL!)
})

When('administratoren logger inn med Feide testbruker', async ({ page }) => {
  const loginPage = new FsAdminLoginPage(page)
  await loginPage.loginWithFeideButton.click()
  await loginPage.feideTestUsersOption.click()
  await loginPage.usernameInput.fill(process.env.FS_ADMIN_USERNAME!)
  await loginPage.passwordInput.fill(process.env.FS_ADMIN_PASSWORD!)
  await loginPage.loginButton.click()
  await page.waitForLoadState('networkidle')
})

When('administratoren velger overstyrt bruker', async ({ page }) => {
  if (process.env.FS_ADMIN_OVERSTYRT_BRUKER) {
    const loginPage = new FsAdminLoginPage(page)
    await loginPage.overstyrtBrukerSelect.selectOption(process.env.FS_ADMIN_OVERSTYRT_BRUKER)
    await page.waitForLoadState('networkidle')
  }
})

Then('skal administratoren være innlogget', async ({ page }) => {
  await expect(page).not.toHaveURL(/login/)
})

Then('innloggingstilstanden skal lagres for adminflaten', async ({ page }) => {
  await page.context().storageState({ path: ADMIN_AUTH_FILE })
})

// ============ Person steps ============

Given('at personen er på innloggingssiden til MinKompetanse', async ({ page }) => {
  await page.goto(process.env.MIN_KOMPETANSE_URL!)
})

When('personen logger inn med Feide testbruker', async ({ page }) => {
  const loginPage = new MinKompetanseLoginPage(page)
  await loginPage.loginLink.click()
  await loginPage.loginWithFeideButton.click()
  await loginPage.feideTestUsersOption.click()
  await loginPage.usernameInput.fill(process.env.FS_ADMIN_USERNAME!)
  await loginPage.passwordInput.fill(process.env.FS_ADMIN_PASSWORD!)
  await loginPage.loginButton.click()
  await page.waitForLoadState('networkidle')

  // Accept consent if present
  try {
    await loginPage.acceptConsentButton.click({ timeout: 1000 })
  } catch {
    // Consent screen not shown, continue
  }
})

When('personen velger en testsøker', async ({ page }) => {
  // Avvis informasjonskapsler hvis dialogen vises
  const cookieButton = page.getByRole('button', { name: 'Avvis informasjonskapsler' })
  if (await cookieButton.isVisible({ timeout: 2000 }).catch(() => false)) {
    await cookieButton.click()
  }

  const loginPage = new MinKompetanseLoginPage(page)
  await loginPage.menuButton.click()
  await loginPage.testsokerSelect.selectOption('YTo5NToiZTRjZTdiNGItZjU5NC00YmI0LWFkYjctMzI2OTUzMjE1ZTQwIg==')
  await page.waitForLoadState('networkidle')
})

Then('skal personen se {string}', async ({ page }, expectedText: string) => {
  await expect(page.getByText(expectedText)).toBeVisible()
})

Then('innloggingstilstanden skal lagres for personflaten', async ({ page }) => {
  await page.context().storageState({ path: PERSON_AUTH_FILE })
})
