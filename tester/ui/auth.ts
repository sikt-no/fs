/**
 * UI Adapter: Authentication
 *
 * Pure Playwright selectors and interactions for authentication flows.
 * NO business logic - only "how" to interact with UI elements.
 */

import { Page } from '@playwright/test'

export async function navigateToFsAdmin(page: Page): Promise<void> {
  await page.goto(process.env.FS_ADMIN_URL!)
}

export async function clickLoginWithFeide(page: Page): Promise<void> {
  await page.getByRole('button', { name: 'Logg inn med Feide' }).click()
}

export async function clickFeideTestUsers(page: Page): Promise<void> {
  await page.getByRole('link', { name: /Feide testbrukere/ }).click()
}

export async function fillUsername(page: Page, username: string): Promise<void> {
  await page.getByLabel('Brukernavn').fill(username)
}

export async function fillPassword(page: Page, password: string): Promise<void> {
  await page.getByLabel('Passord', { exact: true }).fill(password)
}

export async function clickLoginButton(page: Page): Promise<void> {
  await page.getByRole('button', { name: 'Logg inn', exact: true }).click()
}

export async function selectOverstyrtBruker(page: Page, bruker: string): Promise<void> {
  await page.getByLabel('Overstyrt bruker').selectOption(bruker)
}

export async function waitForNetworkIdle(page: Page): Promise<void> {
  await page.waitForLoadState('networkidle')
}
