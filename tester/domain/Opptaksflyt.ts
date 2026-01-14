/**
 * Domain: Opptaksflyt
 *
 * Orkestrerer forretningsflyt for opprettelse og publisering av opptak.
 * Bruker NORSK domenespråk og holder state.
 */

import { Page } from '@playwright/test'
import * as ui from '../ui'

export interface LokaltOpptakParams {
  navn: string
  type?: 'LOS'
  søknadsfrist?: string
  oppstartsdato?: string
}

export class Opptaksflyt {
  private sisteOpptakNavn?: string
  private gjeldeneOpptakId?: string

  constructor(private readonly side: Page) {}

  /**
   * Navigerer til opptakssiden.
   */
  async gåTilOpptakssiden(): Promise<void> {
    await ui.admission.navigateToAdmissionPage(this.side)
  }

  /**
   * Oppretter et nytt lokalt opptak.
   */
  async opprettLokaltOpptak(): Promise<void> {
    await ui.admission.clickCreateLocalAdmission(this.side)
  }

  /**
   * Setter navn på opptaket (med timestamp for unikhet).
   */
  async settNavn(navn: string): Promise<void> {
    this.sisteOpptakNavn = `${navn} - ${Date.now()}`
    await ui.admission.fillAdmissionNameBokmaal(this.side, this.sisteOpptakNavn)
  }

  /**
   * Setter type på opptaket.
   * TODO: Map domenetype til UI-verdi eksternt
   */
  async settType(type: string): Promise<void> {
    // Hardkodet mapping - bør flyttes til konfigurasjon
    if (type === 'LOS') {
      await ui.admission.selectAdmissionType(this.side, 'YTo1OiJMT0ki')
    }
  }

  /**
   * Publiserer opptaket (lagrer og avbryter).
   */
  async publiserOpptak(): Promise<void> {
    await ui.admission.clickSaveButton(this.side)
    await ui.admission.clickCancelLink(this.side)
  }

  /**
   * Komplett flyt: Opprett og publiser lokalt opptak.
   */
  async opprettOgPubliserLokaltOpptak(params: LokaltOpptakParams): Promise<string> {
    await this.gåTilOpptakssiden()
    await this.opprettLokaltOpptak()

    const uniktNavn = `${params.navn} - ${Date.now()}`
    this.sisteOpptakNavn = uniktNavn
    await ui.admission.fillAdmissionNameBokmaal(this.side, uniktNavn)

    if (params.type) {
      await this.settType(params.type)
    }

    // TODO: Implementer søknadsfrist og oppstartsdato

    await this.publiserOpptak()

    return uniktNavn
  }

  /**
   * Henter navnet på sist opprettede opptak.
   */
  hentSisteOpptakNavn(): string | undefined {
    return this.sisteOpptakNavn
  }

  /**
   * Verifiserer at opptak er synlig i listen.
   */
  async erOpptakSynlig(opptakNavn: string): Promise<boolean> {
    await this.gåTilOpptakssiden()
    const cell = await ui.admission.getAdmissionCell(this.side, opptakNavn)
    try {
      await cell.waitFor({ state: 'visible', timeout: 5000 })
      return true
    } catch {
      return false
    }
  }
}
