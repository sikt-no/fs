import { Page, Locator } from '@playwright/test'

export abstract class BaseFeideLoginPage {
  readonly page: Page
  readonly loginWithFeideButton: Locator
  readonly feideTestUsersOption: Locator
  readonly usernameInput: Locator
  readonly passwordInput: Locator
  readonly loginButton: Locator

  constructor(page: Page) {
    this.page = page
    this.loginWithFeideButton = page.getByRole('button', { name: 'Logg inn med Feide' })
    this.feideTestUsersOption = page.getByRole('link', { name: /Feide testbrukere/ })
    this.usernameInput = page.getByLabel('Brukernavn')
    this.passwordInput = page.getByLabel('Passord', { exact: true })
    this.loginButton = page.getByRole('button', { name: 'Logg inn', exact: true })
  }

  abstract goto(): Promise<void>

  async clickLoginWithFeide() {
    await this.loginWithFeideButton.click()
  }

  async clickFeideTestUsers() {
    await this.feideTestUsersOption.click()
  }

  async fillCredentials(username: string, password: string) {
    await this.usernameInput.fill(username)
    await this.passwordInput.fill(password)
  }

  async clickLogin() {
    await this.loginButton.click()
    await this.page.waitForLoadState('networkidle')
  }
}
