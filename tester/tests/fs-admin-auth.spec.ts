import { test, expect } from '../fixtures/pages';
import 'dotenv/config';

test.describe('FS-Admin innloggingstest', () => {
  test.use({ storageState: 'playwright/.auth/fs-admin.json' });

  test('skal være innlogget med overstyrt bruker', async ({ fsAdminActions }) => {
    await fsAdminActions.gåTilFsAdmin()

    const brukernavn = await fsAdminActions.hentInnloggetBrukernavn(process.env.TEST_USER_DISPLAY_NAME!)
    expect(brukernavn).toContain(process.env.TEST_USER_DISPLAY_NAME!)

    const overstyrtBruker = await fsAdminActions.hentOverstyrtBruker()
    expect(overstyrtBruker).toBe(process.env.FS_ADMIN_OVERSTYRT_BRUKER!)
  })
})
