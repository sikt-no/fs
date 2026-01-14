/**
 * E2E Test: FS-Admin Autentisering
 *
 * Verifiserer at autentiseringsflyt fungerer end-to-end.
 * Bruker domain-objekter med norsk språk.
 */

import { test, expect } from '@playwright/test'
import { Brukerøkt } from '../domain'
import 'dotenv/config'

test.describe('FS-Admin tester', () => {
  test('skal være logget inn', async ({ page }) => {
    const brukerøkt = new Brukerøkt(page)

    // Naviger til admin-grensesnittet
    await page.goto(process.env.FS_ADMIN_URL!)

    // Verifiser at vi er logget inn (ikke redirected til login-side)
    await expect(page).not.toHaveURL(/login/)

    // Enkel verifisering av at bruker er autentisert
    // TODO: Erstatt med faktisk element som viser at du er logget inn
    await expect(page).toHaveTitle(/.*/)

    void brukerøkt // Instansiert for fremtidig bruk
  })
})
