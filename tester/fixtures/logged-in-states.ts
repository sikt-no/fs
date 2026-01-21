import { test as base } from 'playwright-bdd'
import { Page } from '@playwright/test'
import 'dotenv/config'

export const test = base.extend<{
  adminPage: Page
  personPage: Page
}>({
  adminPage: async ({ browser }, use) => {
    const context = await browser.newContext({ storageState: 'playwright/.auth/fs-admin.json' })
    const page = await context.newPage()
    await page.goto(process.env.FS_ADMIN_URL!)
    await use(page)
    await context.close()
  },
  personPage: async ({ browser }, use) => {
    const context = await browser.newContext({ storageState: 'playwright/.auth/person.json' })
    const page = await context.newPage()
    await page.goto(process.env.MIN_KOMPETANSE_URL!)
    await use(page)
    await context.close()
  },
})

export { expect } from '@playwright/test'
