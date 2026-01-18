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