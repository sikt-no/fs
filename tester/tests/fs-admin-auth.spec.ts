import { test, expect } from '../fixtures/pages';
import 'dotenv/config';

test.describe('FS-Admin tests', () => {
  test('should be logged in', async ({ page, fsAdminLoginPage }) => {
    // Navigate to admin interface
    await fsAdminLoginPage.goto()

    // Verify we are logged in (not redirected to login page)
    await expect(page).not.toHaveURL(/login/)

    // Add a simple verification that user is authenticated
    // TODO: Replace with actual element that shows you're logged in
    await expect(page).toHaveTitle(/.*/)
  })
})
