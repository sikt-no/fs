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
    baseURL: process.env.FS_ADMIN_URL,
    locale: 'nb-NO',
    viewport: { width: 1920, height: 1080 },
    trace: 'on',
    video: 'on',
  },
  projects: [
    // Setup - logger inn og lagrer auth state for både admin og student
    {
      name: 'setup',
      testDir: './setup',
      testMatch: '**/*.setup.ts',
    },
    // Auth verification tests - verifiserer at setup fungerte
    {
      name: 'auth-tests',
      testDir: './tests',
      testMatch: '**/*-auth.spec.ts',
      use: {
        ...devices['Desktop Chrome'],
      },
      dependencies: ['setup'],
    },
    // BDD tests - kjører med lagret auth
    {
      name: 'bdd',
      testDir,
      use: {
        ...devices['Desktop Chrome'],
        storageState: 'playwright/.auth/fs-admin.json',
      },
      dependencies: ['setup'],
    },
  ],
});
