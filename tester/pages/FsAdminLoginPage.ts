import { Page, Locator } from '@playwright/test'
import { BaseFeideLoginPage } from './BaseFeideLoginPage'

export class FsAdminLoginPage extends BaseFeideLoginPage {
  readonly overstyrtBrukerSelect: Locator

  constructor(page: Page) {
    super(page)
    this.overstyrtBrukerSelect = page.getByLabel('Overstyrt bruker')
  }

  async goto() {
    await this.page.goto(process.env.FS_ADMIN_URL!)
    await this.page.waitForLoadState('networkidle')
  }

  async hentBrukernavnTekst(navn: string): Promise<string | null> {
    const brukerElement = this.page.getByText(navn).first()
    return await brukerElement.textContent()
  }

  async hentOverstyrtBrukerVerdi(): Promise<string> {
    return await this.overstyrtBrukerSelect.inputValue()
  }

  async login(username: string, password: string, overstyrtBruker?: string) {
    await this.clickLoginWithFeide()
    await this.clickFeideTestUsers()
    await this.fillCredentials(username, password)
    await this.clickLogin()

    if (overstyrtBruker) {
      await this.overstyrtBrukerSelect.selectOption(overstyrtBruker)
      await this.page.waitForLoadState('networkidle')
    }
  }
}