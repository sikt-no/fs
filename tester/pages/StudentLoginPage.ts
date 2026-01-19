import { Page, Locator } from '@playwright/test'
import { BaseFeideLoginPage } from './BaseFeideLoginPage'

export class StudentLoginPage extends BaseFeideLoginPage {
  readonly mainContentLoginLink: Locator
  readonly menuButton: Locator
  readonly testUserSelect: Locator

  constructor(page: Page) {
    super(page)
    this.mainContentLoginLink = page.locator('#main-content').getByRole('link', { name: 'Logg inn' }).describe('Logg inn lenke i hovedinnhold')
    this.menuButton = page.getByRole('button', { name: 'Meny' }).describe('Meny knapp')
    this.testUserSelect = page.getByLabel('Velg testsøker').last().describe('Velg testsøker')
  }

  async goto() {
    await this.page.goto(process.env.MIN_KOMPETANSE_URL!)
    await this.page.waitForLoadState('networkidle')
  }

  async erProfilLenkeSynlig(profilNavn: string): Promise<boolean> {
    const profilLenke = this.page.getByRole('link', { name: new RegExp(profilNavn, 'i') })
    return await profilLenke.isVisible()
  }

  async clickMeny() {
    await this.menuButton.click()
  }

  async hentTestsøkerTekst(): Promise<string | null> {
    return await this.testUserSelect.textContent()
  }

  async clickLoginLink() {
    await this.mainContentLoginLink.click()
  }

  async selectTestUser(userLabel: string) {
    await this.menuButton.click()
    await this.testUserSelect.selectOption({ label: userLabel })
    await this.page.waitForLoadState('networkidle')
  }

  async login(username: string, password: string, testUser: string) {
    await this.clickLoginLink()
    await this.clickLoginWithFeide()
    await this.clickFeideTestUsers()
    await this.fillCredentials(username, password)
    await this.clickLogin()
    await this.selectTestUser(testUser)
  }
}
