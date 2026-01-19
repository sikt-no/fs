import { Page } from '@playwright/test'
import { FsAdminLoginPage } from '../pages/FsAdminLoginPage'

export class FsAdminActions {
  private fsAdminPage: FsAdminLoginPage

  constructor(page: Page) {
    this.fsAdminPage = new FsAdminLoginPage(page)
  }

  async gåTilFsAdmin() {
    await this.fsAdminPage.goto()
  }

  async hentInnloggetBrukernavn(navn: string): Promise<string | null> {
    return await this.fsAdminPage.hentBrukernavnTekst(navn)
  }

  async hentOverstyrtBruker(): Promise<string> {
    return await this.fsAdminPage.hentOverstyrtBrukerVerdi()
  }
}
