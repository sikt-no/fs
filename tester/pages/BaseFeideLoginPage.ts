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
    this.loginWithFeideButton = page.getByRole('button', { name: 'Logg inn med Feide' }).describe('Logg inn med Feide knapp')
    this.feideTestUsersOption = page.getByRole('link', { name: /Feide testbrukere/ }).describe('Feide testbrukere lenke')
    this.usernameInput = page.getByLabel('Brukernavn').describe('Brukernavn inputfelt')
    this.passwordInput = page.getByLabel('Passord', { exact: true }).describe('Passord inputfelt')
    this.loginButton = page.getByRole('button', { name: 'Logg inn', exact: true }).describe('Logg inn knapp')
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
