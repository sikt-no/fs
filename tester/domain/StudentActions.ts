import { Page } from '@playwright/test'
import { StudentLoginPage } from '../pages/StudentLoginPage'

export class StudentActions {
  private studentPage: StudentLoginPage

  constructor(page: Page) {
    this.studentPage = new StudentLoginPage(page)
  }

  async gåTilMinKompetanse() {
    await this.studentPage.goto()
  }

  async erProfilLenkeSynlig(profilNavn: string): Promise<boolean> {
    return await this.studentPage.erProfilLenkeSynlig(profilNavn)
  }

  async hentValgtTestsøker(): Promise<string | null> {
    // Åpne meny for å se testsøker-select
    await this.studentPage.clickMeny()

    // Hent valgt testsøker
    return await this.studentPage.hentTestsøkerTekst()
  }
}
