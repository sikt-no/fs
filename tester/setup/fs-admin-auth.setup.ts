import { test as setup } from '@playwright/test';
import { FsAdminLoginPage } from '../pages/FsAdminLoginPage';
import 'dotenv/config';

const authFile = 'playwright/.auth/fs-admin.json'

setup('autentiser som FS-Admin', async ({ page }) => {
  const loginPage = new FsAdminLoginPage(page)

  await loginPage.goto()
  await loginPage.login(
    process.env.FS_ADMIN_USERNAME!,
    process.env.FS_ADMIN_PASSWORD!,
    process.env.FS_ADMIN_OVERSTYRT_BRUKER
  )

  // Save signed-in state (cookies will be used for GraphQL API calls)
  await page.context().storageState({ path: authFile })
})