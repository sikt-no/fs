import { Page, Locator } from '@playwright/test'

export class FsAdminLoginPage {
  readonly page: Page
  readonly feideTestUsersOption: Locator
  readonly usernameInput: Locator
  readonly passwordInput: Locator
  readonly loginButton: Locator
  readonly overstyrtBrukerSelect: Locator

  constructor(page: Page) {
    this.page = page
    this.feideTestUsersOption = page.getByRole('link', { name: /Feide testbrukere/ })
    this.usernameInput = page.getByLabel('Brukernavn')
    this.passwordInput = page.getByLabel('Passord', { exact: true })
    this.loginButton = page.getByRole('button', { name: 'Logg inn', exact: true })
    this.overstyrtBrukerSelect = page.getByLabel('Overstyrt bruker')
  }

  async velgOverstyrtBruker(brukerId: string) {
    const options = this.overstyrtBrukerSelect.locator('option')
    await options.nth(1).waitFor({ state: 'attached' })
    const values: string[] = await options.evaluateAll(opts => opts.map(o => (o as HTMLOptionElement).value))
    const match = values.find(v => v === brukerId || v.startsWith(`${brukerId}:`))
    if (!match) {
      throw new Error(
        `Fant ingen overstyrt bruker som matcher "${brukerId}". Tilgjengelige verdier: ${values.filter(Boolean).join(' | ')}`,
      )
    }
    await this.overstyrtBrukerSelect.selectOption(match)
  }
}