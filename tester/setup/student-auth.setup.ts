import { test as setup } from '@playwright/test';
import { StudentLoginPage } from '../pages/StudentLoginPage';
import 'dotenv/config';

const authFile = 'playwright/.auth/student.json'

setup('autentiser som Student', async ({ page }) => {
  const loginPage = new StudentLoginPage(page)

  await loginPage.goto()
  await loginPage.login(
    process.env.STUDENT_USERNAME!,
    process.env.STUDENT_PASSWORD!,
    'FIN SÅPE'
  )

  // Lagre innlogget tilstand (cookies vil bli brukt for tester)
  await page.context().storageState({ path: authFile })
})
