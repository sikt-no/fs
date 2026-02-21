import { defineConfig, devices } from '@playwright/test'
import { defineBddConfig } from 'playwright-bdd'
import 'dotenv/config'

const testDir = defineBddConfig({
  featuresRoot: '../krav',
  features: '../krav/**/*.feature',
  steps: ['./steps/**/*.ts', './fixtures/**/*.ts'],
  language: 'no',
  missingSteps: 'skip-scenario',
  tags: process.env.BDD_TAGS || '@smoke',
})

export default defineConfig({
  testDir,
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 4 : undefined,
  timeout: 60000,
  reporter: [
    ['list'],
    ['html'],
    ['json', { outputFile: 'test-results/results.json' }],
    ['junit', { outputFile: 'test-results/junit.xml' }],
  ],
  use: {
    locale: 'nb-NO',
    viewport: { width: 1920, height: 1080 },
    trace: 'on',
    video: 'on',
  },
  projects: [
    // Login - runs first, no auth state, generates auth files
    {
      name: 'login',
      testMatch: '**/feide_innlogging*',
      use: {
        ...devices['Desktop Chrome'],
      },
    },
    // BDD tests - runs after login
    {
      name: 'bdd',
      testIgnore: '**/feide_innlogging*',
      use: {
        ...devices['Desktop Chrome'],
      },
      dependencies: ['login'],
    },
  ],
})
