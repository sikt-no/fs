import { test, expect } from '../fixtures/pages';
import 'dotenv/config';

test.describe('Student innloggingstest', () => {
  test.use({ storageState: 'playwright/.auth/student.json' });

  test('skal være innlogget med riktig testsøker', async ({ studentActions }) => {
    await studentActions.gåTilMinKompetanse()

    const profilNavn = `Profil: ${process.env.TEST_USER_DISPLAY_NAME!.split(' ')[0]}`
    const erProfilSynlig = await studentActions.erProfilLenkeSynlig(profilNavn)
    expect(erProfilSynlig).toBe(true)

    const valgtTestsøker = await studentActions.hentValgtTestsøker()
    expect(valgtTestsøker).toContain(process.env.STUDENT_TEST_USER!)
  })
})
