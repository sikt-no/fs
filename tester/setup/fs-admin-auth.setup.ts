/**
 * Setup: FS-Admin Autentisering
 *
 * Autentiserer én gang og lagrer session state for gjenbruk i tester.
 * Bruker domain-objekter med norsk språk.
 */

import { test as setup } from '@playwright/test'
import { Brukerøkt } from '../domain'
import 'dotenv/config'

const authFile = 'playwright/.auth/fs-admin.json'

setup('authenticate as FS-Admin', async ({ page }) => {
  const brukerøkt = new Brukerøkt(page)

  await brukerøkt.loggInnMedFeide(
    process.env.FS_ADMIN_USERNAME!,
    process.env.FS_ADMIN_PASSWORD!,
    process.env.FS_ADMIN_OVERSTYRT_BRUKER
  )

  // Lagre innlogget tilstand
  await page.context().storageState({ path: authFile })
})
