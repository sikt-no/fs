import { test, expect } from '../fixtures/pages';
import 'dotenv/config';

test.describe('FS-Admin innloggingstest', () => {
  test.use({ storageState: 'playwright/.auth/fs-admin.json' });

  test('skal være innlogget som Kari Nilsen med overstyrt bruker', async ({ page, fsAdminLoginPage }) => {
    await fsAdminLoginPage.goto()
    await page.waitForLoadState('networkidle')

    // Verifiser at brukernavnet vises (Kari Nilsen er innlogget)
    await expect(page.getByText('Kari Nilsen').first()).toBeVisible()

    // Verifiser at overstyrt bruker er valgt
    const overstyrtBrukerSelect = page.getByLabel('Overstyrt bruker')
    await expect(overstyrtBrukerSelect).toHaveValue(process.env.FS_ADMIN_OVERSTYRT_BRUKER!)
  })
})
