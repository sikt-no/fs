import { test, expect } from '@playwright/test';
import 'dotenv/config';

test.describe('Student innloggingstest', () => {
  test.use({ storageState: 'playwright/.auth/student.json' });

  test('skal være innlogget som FIN SÅPE', async ({ page }) => {
    // Naviger til Min Kompetanse
    await page.goto(process.env.MIN_KOMPETANSE_URL!)

    // Verifiser at vi er innlogget (ikke omdirigert til innloggingsside)
    await expect(page).not.toHaveURL(/logg-inn/)

    // Verifiser at vi er på Min Kompetanse siden
    await expect(page).toHaveURL(new RegExp(process.env.MIN_KOMPETANSE_URL!))

    // Enkel verifisering at bruker er autentisert
    // TODO: Erstatt med faktisk element som viser at du er innlogget som FIN SÅPE
    await expect(page).toHaveTitle(/.+/)
  })
})
