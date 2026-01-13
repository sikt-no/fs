import { Page, Locator } from '@playwright/test'

export class FsAdminLoginPage {
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

  async goto() {
    await this.page.goto(process.env.FS_ADMIN_URL!)
  }

  async login(username: string, password: string) {
    await this.loginWithFeideButton.click()
    await this.feideTestUsersOption.click()
    await this.usernameInput.fill(username)
    await this.passwordInput.fill(password)
    await this.loginButton.click()
    await this.page.waitForLoadState('networkidle')
  }
}