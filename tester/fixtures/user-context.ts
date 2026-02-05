import { test as base } from 'playwright-bdd'
import { Page, BrowserContext, expect } from '@playwright/test'
import 'dotenv/config'

/**
 * Tilgjengelige brukerroller i testsystemet.
 * Utvid denne typen når nye roller legges til.
 */
export type UserRole = 'administrator' | 'person' | 'personsok-administrator'

/**
 * Manager for å håndtere flere brukerkontekster i samme test.
 * Tillater dynamisk bytte mellom roller med lazy initialization.
 */
export type UserContextManager = {
  /** Bytter til angitt rolle og returnerer dens Page-objekt */
  switchTo: (role: UserRole) => Promise<Page>
  /** Nåværende aktive Page-objekt */
  readonly currentPage: Page
  /** Nåværende aktive rolle */
  readonly currentRole: UserRole
}

/**
 * Test-spesifikk data som deles mellom steps i samme scenario.
 * Automatisk ryddet opp mellom tester.
 */
export type TestData = {
  opptakNavn?: string
  // Legg til flere felt etter behov
}

const AUTH_FILES: Record<UserRole, string> = {
  administrator: 'playwright/.auth/fs-admin.json',
  person: 'playwright/.auth/person.json',
  'personsok-administrator': 'playwright/.auth/personsok-admin.json',
}

const BASE_URLS: Record<UserRole, string> = {
  administrator: process.env.FS_ADMIN_URL!,
  person: process.env.MIN_KOMPETANSE_URL!,
  'personsok-administrator': process.env.FS_ADMIN_URL!,
}

export const test = base.extend<{
  userContext: UserContextManager
  testData: TestData
}>({
  testData: async ({}, use) => {
    const data: TestData = {}
    await use(data)
    // Data ryddes automatisk opp mellom tester
  },

  userContext: async ({ browser }, use) => {
    const contexts = new Map<UserRole, BrowserContext>()
    const pages = new Map<UserRole, Page>()
    let currentPage: Page | null = null
    let currentRole: UserRole | null = null

    const manager: UserContextManager = {
      switchTo: async (role: UserRole) => {
        // Lazy initialization - opprett kontekst kun når den trengs
        if (!pages.has(role)) {
          const context = await browser.newContext({
            storageState: AUTH_FILES[role],
          })
          const page = await context.newPage()
          await page.goto(BASE_URLS[role])
          await page.waitForLoadState('networkidle')
          // Vent på at Sikt-logoen er synlig (siden er ferdig lastet)
          await expect(page.getByRole('link', { name: 'Sikt Kunnskapssektorens' })).toBeVisible()
          contexts.set(role, context)
          pages.set(role, page)
        }
        currentPage = pages.get(role)!
        currentRole = role
        return currentPage
      },
      get currentPage() {
        if (!currentPage) {
          throw new Error(
            'Ingen kontekst valgt. Bruk "Gitt at jeg logger inn som <rolle>" først.'
          )
        }
        return currentPage
      },
      get currentRole() {
        if (!currentRole) {
          throw new Error(
            'Ingen rolle valgt. Bruk "Gitt at jeg logger inn som <rolle>" først.'
          )
        }
        return currentRole
      },
    }

    await use(manager)

    // Cleanup - lukk alle kontekster
    for (const context of contexts.values()) {
      try {
        await context.close()
      } catch {
        // Konteksten kan allerede være lukket
      }
    }
  },
})

export { expect } from '@playwright/test'
