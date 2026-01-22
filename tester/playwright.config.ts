import { defineConfig, devices } from '@playwright/test'
import { defineBddConfig } from 'playwright-bdd'
import 'dotenv/config'

const testDir = defineBddConfig({
  featuresRoot: '../krav',
  features: '../krav/**/*.feature',
  steps: ['./steps/**/*.ts', './fixtures/**/*.ts'],
  language: 'no',
  missingSteps: 'skip-scenario',
  tags: '@demo',
})

export default defineConfig({
  testDir,
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['list'],
    ['html'],
    ['junit', { outputFile: 'test-results/junit.xml' }],
    ['allure-playwright', {
      resultsDir: 'allure-results',
      environmentInfo: {
        Environment: process.env.CI ? 'CI' : 'Local',
        BaseURL: process.env.FS_ADMIN_URL || 'not set',
        NodeVersion: process.version,
      },
      categories: [
        {
          name: 'Authentication failures',
          messageRegex: /auth|login|session|token/i,
          matchedStatuses: ['failed', 'broken'],
        },
        {
          name: 'Timeout issues',
          messageRegex: /timeout|timed out/i,
          matchedStatuses: ['failed', 'broken'],
        },
        {
          name: 'Element not found',
          messageRegex: /locator|element|selector|not found|no element/i,
          matchedStatuses: ['failed'],
        },
        {
          name: 'Network errors',
          messageRegex: /network|fetch|request failed|ECONNREFUSED/i,
          matchedStatuses: ['failed', 'broken'],
        },
      ],
    }],
  ],
  use: {
    baseURL: process.env.FS_ADMIN_URL,
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
