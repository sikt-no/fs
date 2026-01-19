import { test, expect } from '@playwright/test';
import 'dotenv/config';

test.describe('Student innloggingstest', () => {
  test.use({ storageState: 'playwright/.auth/student.json' });

  test('skal være innlogget som FIN SÅPE', async ({ page }) => {
    await page.goto(process.env.MIN_KOMPETANSE_URL!)
    await page.waitForLoadState('networkidle')

    // Verifiser at profil-linken vises
    await expect(page.getByRole('link', { name: /Profil: Kari/i })).toBeVisible()

    // Åpne meny og verifiser at testsøker er valgt
    await page.getByRole('button', { name: 'Meny' }).click()
    const testUserSelect = page.getByLabel('Velg testsøker').last()
    await expect(testUserSelect).toContainText(process.env.STUDENT_TEST_USER!)
  })
})
