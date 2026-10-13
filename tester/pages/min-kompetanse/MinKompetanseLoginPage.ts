import { Page, Locator } from '@playwright/test'

export class MinKompetanseLoginPage {
  readonly page: Page
  readonly loginLink: Locator
  readonly loginWithFeideButton: Locator
  readonly feideTestUsersOption: Locator
  readonly usernameInput: Locator
  readonly passwordInput: Locator
  readonly loginButton: Locator
  readonly acceptConsentButton: Locator
  readonly menuButton: Locator
  readonly testsokerInput: Locator

  constructor(page: Page) {
    this.page = page
    this.loginLink = page.locator('#main-content').getByRole('link', { name: 'Logg inn' })
    this.loginWithFeideButton = page.getByRole('button', { name: 'Logg inn med Feide' })
    this.feideTestUsersOption = page.getByLabel('Feide testbrukere')
    this.usernameInput = page.getByLabel('Brukernavn')
    this.passwordInput = page.getByLabel('Passord', { exact: true })
    this.loginButton = page.getByRole('button', { name: 'Logg inn', exact: true })
    this.acceptConsentButton = page.getByRole('button', { name: 'Godta og fortsett' })
    this.menuButton = page.getByTestId('menu-button-desktop')
    this.testsokerInput = page.getByRole('textbox', { name: 'Velg testsøker' })
  }

  async velgTestsoker(navn: string) {
    await this.testsokerInput.waitFor({ state: 'visible' })
    const inputId = await this.testsokerInput.getAttribute('id')
    const input = this.page.locator(`#${inputId}`)
    await input.click()
    await input.pressSequentially(navn, { delay: 50 })
    const option = this.page.locator('[role="option"]:visible').filter({ hasText: navn })
    await option.first().click()
  }
}
