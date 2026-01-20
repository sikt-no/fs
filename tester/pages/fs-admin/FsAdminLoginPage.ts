import { Page, Locator } from '@playwright/test'

export class FsAdminLoginPage {
  readonly page: Page
  readonly loginWithFeideButton: Locator
  readonly feideTestUsersOption: Locator
  readonly usernameInput: Locator
  readonly passwordInput: Locator
  readonly loginButton: Locator
  readonly overstyrtBrukerSelect: Locator

  constructor(page: Page) {
    this.page = page
    this.loginWithFeideButton = page.getByRole('button', { name: 'Logg inn med Feide' })
    this.feideTestUsersOption = page.getByRole('link', { name: /Feide testbrukere/ })
    this.usernameInput = page.getByLabel('Brukernavn')
    this.passwordInput = page.getByLabel('Passord', { exact: true })
    this.loginButton = page.getByRole('button', { name: 'Logg inn', exact: true })
    this.overstyrtBrukerSelect = page.getByLabel('Overstyrt bruker')
  }
}