import { test, expect } from '../fixtures/pages';
import 'dotenv/config';

test.describe('FS-Admin innloggingstest', () => {
  test('skal være innlogget', async ({ page, fsAdminLoginPage }) => {
    // Naviger til admin-grensesnittet
    await fsAdminLoginPage.goto()

    // Verifiser at vi er innlogget (ikke omdirigert til innloggingsside)
    await expect(page).not.toHaveURL(/login/)

    // Enkel verifisering at bruker er autentisert
    // TODO: Erstatt med faktisk element som viser at du er innlogget
    await expect(page).toHaveTitle(/.*/)
  })
})
