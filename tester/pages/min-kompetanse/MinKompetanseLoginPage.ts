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
  readonly testsokerSelect: Locator

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
    this.testsokerSelect = page.locator('[id="_R_b6lkmivb_"]')
  }
}
