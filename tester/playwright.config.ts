import { defineConfig, devices } from '@playwright/test';
import { defineBddConfig } from 'playwright-bdd';
import 'dotenv/config';

const testDir = defineBddConfig({
  featuresRoot: '../krav',
  features: '../krav/**/*.feature',
  steps: './steps/**/*.ts',
  language: 'no',
  missingSteps: 'skip-scenario',
  tags: '@demo',
});

export default defineConfig({
  testDir,
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:3000',
    locale: 'nb-NO',
    viewport: { width: 1920, height: 1080 },
    trace: 'on',
    video: 'on',
  },
  projects: [
    // Setup project - runs first
    {
      name: 'fs-admin-setup',
      testDir: './setup',
      testMatch: '**/*.setup.ts',
    },
    // BDD tests with authentication
    {
      name: 'chromium',
      testDir,
      use: {
        ...devices['Desktop Chrome'],
        storageState: 'playwright/.auth/fs-admin.json',
      },
      dependencies: ['fs-admin-setup'],
    },
    // Regular Playwright tests with authentication
    {
      name: 'fs-admin-tests',
      testDir: './tests',
      testMatch: '**/*.spec.ts',
      use: {
        ...devices['Desktop Chrome'],
        storageState: 'playwright/.auth/fs-admin.json',
      },
      dependencies: ['fs-admin-setup'],
    },
  ],
});
