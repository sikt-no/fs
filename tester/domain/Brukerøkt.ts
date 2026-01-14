/**
 * Domain: Brukerøkt
 *
 * Representerer en brukersesjon med autentisering og rollebasert tilgang.
 * Bruker NORSK domenespråk.
 */

import { Page } from '@playwright/test'
import * as ui from '../ui'

export class Brukerøkt {
  private brukernavn?: string
  private rolle?: string

  constructor(private readonly side: Page) {}

  /**
   * Logger inn med Feide testbrukere.
   */
  async loggInnMedFeide(
    brukernavn: string,
    passord: string,
    overstyrtBruker?: string
  ): Promise<void> {
    this.brukernavn = brukernavn

    await ui.auth.navigateToFsAdmin(this.side)
    await ui.auth.clickLoginWithFeide(this.side)
    await ui.auth.clickFeideTestUsers(this.side)
    await ui.auth.fillUsername(this.side, brukernavn)
    await ui.auth.fillPassword(this.side, passord)
    await ui.auth.clickLoginButton(this.side)
    await ui.auth.waitForNetworkIdle(this.side)

    if (overstyrtBruker) {
      await ui.auth.selectOverstyrtBruker(this.side, overstyrtBruker)
      await ui.auth.waitForNetworkIdle(this.side)
    }
  }

  /**
   * Logger inn som en forhåndsdefinert rolle.
   */
  async loggInnSom(rolle: 'administrator'): Promise<void> {
    this.rolle = rolle

    const brukernavn = process.env.FS_ADMIN_USERNAME!
    const passord = process.env.FS_ADMIN_PASSWORD!
    const overstyrtBruker = process.env.FS_ADMIN_OVERSTYRT_BRUKER

    await this.loggInnMedFeide(brukernavn, passord, overstyrtBruker)
  }

  /**
   * Henter gjeldende brukernavn.
   */
  hentBrukernavn(): string | undefined {
    return this.brukernavn
  }

  /**
   * Henter gjeldende rolle.
   */
  hentRolle(): string | undefined {
    return this.rolle
  }
}
