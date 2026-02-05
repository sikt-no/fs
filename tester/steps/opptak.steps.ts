import { createBdd } from 'playwright-bdd'
import { test, expect } from '../fixtures/user-context'
import { selectFromCombobox } from '../helpers/combobox'
import { opprettOpptak, opprettUtdanningstilbud, oppdaterUtdanningstilbud } from '../graphql/client'
import type { OpprettOpptakInput, OpprettUtdanningstilbudInput, OppdaterUtdanningstilbudV2Input } from '../graphql/types'

const { Given, When, Then } = createBdd(test)

Given('at jeg er på opptakssiden', async ({ userContext }) => {
  await userContext.currentPage.getByRole('link', { name: 'Opptak' }).click()
  await userContext.currentPage.waitForLoadState('networkidle')
  // Vent på at tabellen er lastet (skeleton forsvinner)
  await userContext.currentPage.getByRole('table').waitFor({ state: 'visible' })
})

Given('at opptaket {string} er publisert', async ({ userContext, testData }, opptakNavn: string) => {
  testData.opptakNavn = `${opptakNavn} - ${Date.now()}`

  // Datoer: idag (T+0) og 2 uker frem (T+14)
  const idag = new Date()
  idag.setHours(23, 0, 0, 0)
  const toUkerFrem = new Date(idag)
  toUkerFrem.setDate(toUkerFrem.getDate() + 14)

  const input: OpprettOpptakInput = {
    navn: testData.opptakNavn,
    hendelser: [
      {
        opptakshendelsestypeKode: 'SOKING_APNER',
        hendelseTidspunkt: idag.toISOString(),
      },
      {
        opptakshendelsestypeKode: 'FRIST_OMPRIORITERING',
        hendelseTidspunkt: toUkerFrem.toISOString(),
      },
      {
        opptakshendelsestypeKode: 'FRIST_VURDERINGSGRUNNLAG',
        hendelseTidspunkt: idag.toISOString(),
      },
      {
        opptakshendelsestypeKode: 'FRIST_REALKOMPETANSE',
        hendelseTidspunkt: idag.toISOString(),
      },
      {
        opptakshendelsestypeKode: 'PUBLISERING_RESULTAT',
        hendelseTidspunkt: idag.toISOString(),
      },
      {
        opptakshendelsestypeKode: 'FRIST_ETTERSENDING',
        hendelseTidspunkt: toUkerFrem.toISOString(),
      },
      {
        opptakshendelsestypeKode: 'SOKNADSFRIST_ORDINAER',
        hendelseTidspunkt: toUkerFrem.toISOString(),
      },
      {
        opptakshendelsestypeKode: 'PUBLISERING_OPPTAK',
        hendelseTidspunkt: idag.toISOString(),
      },
      {
        opptakshendelsestypeKode: 'FRIST_ORDINAER_OPPLASTING',
        hendelseTidspunkt: toUkerFrem.toISOString(),
      },
    ],
    opptaksstatusKode: 'PUBLISERT',
    opptakstypeKode: 'YTo1OiJMT0si',
    runder: [],
  }

  // Opprett opptak via GraphQL API (med admin auth)
  await userContext.switchTo('administrator')
  const result = await opprettOpptak(userContext.currentPage.request, input)

  // Legg til Jordmor utdanningstilbud
  const utdanningstilbudInput: OpprettUtdanningstilbudInput = {
    opptakId: result.opptak!.id,
    utdanningsinstansId: 'YToxMDc6eyJvcmdhbmlzYXNqb25za29kZSI6IjE4NiIsInV0ZGFubmluZ3NtdWxpZ2hldEtvZGUiOiJNLUpPUkRNT1IiLCJwZXJpb2Rla29kZSI6IjIwMjUgVsOFUi4uMjAyNiBIw5hTVCJ9',
    antallStudieplasser: 10,
    erKansellert: false,
    harTidligSoknadsfrist: false,
    tilboedLedigeStudieplasserForrigeOpptaksrunde: false,
    tilbyrLedigeStudieplasser: false,
    tilbyrTidligOpptak: false,
  }

  const tilbudResult = await opprettUtdanningstilbud(userContext.currentPage.request, utdanningstilbudInput)

  // Konfigurer utdanningstilbudet med kompetanseregelverk, rangeringsregelverk og kvoter
  const oppdaterInput: OppdaterUtdanningstilbudV2Input = {
    utdanningstilbudId: tilbudResult.utdanningstilbud!.id,
    kompetanseregelverkId: 'YToxMTk6IktNMzEwMiI=', // KM3102
    rangeringsregelverkKode: 'YToxNToiUk0zMTAyIg==', // RM3102
    kvoter: [
      {
        kvotetypeId: 'YToyNjoiT1JEIg==', // ORD - Ordinær kvote
        onsketAntallDeltakere: 10,
        kvoteprioritet: 1,
        erTilbudsgarantikvote: true,
      },
    ],
    antallStudieplasser: 10,
    visPoenggrenseForSoker: false,
    visVentelistenummerForSoker: false,
  }

  await oppdaterUtdanningstilbud(userContext.currentPage.request, oppdaterInput)

  // Bytt tilbake til person-kontekst for videre testing
  await userContext.switchTo('person')
})

When('jeg oppretter et nytt lokalt opptak', async ({ userContext }) => {
  const lokaltOpptakLink = userContext.currentPage.getByRole('link', { name: 'Velg Lokalt opptak' })
  await lokaltOpptakLink.waitFor({ state: 'visible' })
  await lokaltOpptakLink.click()
})

When('jeg setter navn til {string}', async ({ userContext, testData }, navn: string) => {
  testData.opptakNavn = `${navn} - ${Date.now()}`
  await userContext.currentPage.getByRole('textbox', { name: 'Navn på opptaket (bokmål)' }).click()
  await userContext.currentPage.getByRole('textbox', { name: 'Navn på opptaket (bokmål)' }).fill(testData.opptakNavn)
})

When('jeg setter type til {string}', async ({ userContext }, type: string) => {
  // TODO: Map type-navn til value - nå hardkodet til "LOS"
  await userContext.currentPage.getByLabel('Hvilken type lokalt opptak?').selectOption('YTo1OiJMT0si')
  // Vent på at Frister-seksjonen er lastet inn (h2 "Frister" og h3 kategori-overskrift)
  await userContext.currentPage.getByRole('heading', { name: 'Frister', level: 2 }).waitFor({ state: 'visible' })
  // Vent på at frist-kategoriene er lastet (h3 overskrift betyr at data er hentet)
  await userContext.currentPage.getByRole('heading', { level: 3 }).first().waitFor({ state: 'visible' })
})

When('jeg setter søknadsfrist til {string}', async ({ userContext }, frist: string) => {
  // TODO: Implementer sett søknadsfrist
})

When('jeg setter oppstartsdato til {string}', async ({ userContext }, dato: string) => {
  // TODO: Implementer sett oppstartsdato
})

When('jeg lagrer opptaket', async ({ userContext }) => {
  await userContext.currentPage.getByRole('button', { name: 'Lagre' }).click()
  await userContext.currentPage.waitForLoadState('networkidle')
})

When('jeg tilknytter utdanningstilbud til opptaket', async ({ userContext }) => {
  await userContext.currentPage.getByRole('button', { name: 'Tilknytt utdanningstilbud' }).click()
  await userContext.currentPage.waitForLoadState('networkidle')
  await userContext.currentPage.getByRole('tab', { name: 'Legg til nytt studiealternativ' }).click()
  await userContext.currentPage.waitForLoadState('networkidle')
  await selectFromCombobox(userContext.currentPage, {
    select: /Mastergrad i jordmorfag/,
    actionButton: 'Legg til',
  })
  await userContext.currentPage.getByText('Utdanningstilbud ble lagt til').waitFor({ state: 'visible' })
  await userContext.currentPage.keyboard.press('Escape')
  await userContext.currentPage.waitForLoadState('networkidle')
})

When('jeg konfigurerer studiealternativet', async ({ userContext }) => {
  await userContext.currentPage.waitForLoadState('networkidle')
  const visButton = userContext.currentPage.getByRole('button', { name: 'Vis', exact: true })
  await visButton.waitFor({ state: 'visible' })
  await visButton.scrollIntoViewIfNeeded()
  await visButton.click()
  await userContext.currentPage.getByLabel('Kompetanseregelverk (Kravkode').selectOption('YToxMTk6IktNMzEwMiI=')
  await userContext.currentPage.getByLabel('RangeringsregelverkIkke valgt').selectOption('YToxNToiUk0zMTAyIg==')
  await userContext.currentPage.waitForLoadState('networkidle')
  const kvoterText = userContext.currentPage.getByText('KvoterTabell over')
  await kvoterText.scrollIntoViewIfNeeded()
  await expect(kvoterText).toBeVisible()
  await selectFromCombobox(userContext.currentPage, {
    comboboxLabel: 'Kvoter',
    openButton: null,
    select: 'Ordinær kvote',
  })
  await userContext.currentPage.waitForLoadState('networkidle')
  await userContext.currentPage.getByRole('button', { name: 'Lagre' }).click()
})

When('jeg publiserer opptaket', async ({ userContext }) => {
  await userContext.currentPage.getByRole('button', { name: 'Lagre' }).click()
  await userContext.currentPage.getByRole('link', { name: 'Avbryt' }).click()
})

When('jeg tilknytter utdanningstilbudet {string} til opptaket', async ({ userContext }, utdanning: string) => {
  // TODO: Implementer med spesifikt utdanningstilbud
})

Then('skal opptaket {string} være publisert', async ({ userContext, testData }, _opptakNavn: string) => {
  await userContext.currentPage.goto(`${process.env.FS_ADMIN_URL}/opptak`)
  await expect(userContext.currentPage.getByRole('cell', { name: testData.opptakNavn })).toBeVisible()
})

Then('skal {string} være søkbart for søkere', async ({ userContext }, utdanning: string) => {
  // TODO: Implementer verifisering
})

When('jeg søker etter {string} på finn studier', async ({ userContext }, søkeord: string) => {
  await userContext.currentPage.goto(`${process.env.MIN_KOMPETANSE_URL}/utforsk-studier?resultsPerPage=75&sort=studiesDesc&q=${encodeURIComponent(søkeord)}`)
  await userContext.currentPage.waitForLoadState('networkidle')
  await userContext.currentPage.getByRole('button', { name: 'Legg til' }).first().waitFor({ state: 'visible', timeout: 10000 })
})

When('jeg legger til alle studier i kurven', async ({ userContext }) => {
  const addToCartButtons = userContext.currentPage.getByRole('button', { name: 'Legg til' })
  const buttonCount = await addToCartButtons.count()

  for (let i = 0; i < buttonCount; i++) {
    await addToCartButtons.first().click()
    await userContext.currentPage.waitForLoadState('networkidle')
  }
})

When('jeg går til studiekurven', async ({ userContext }) => {
  await userContext.currentPage.getByRole('link', { name: 'studier i kurv Til studiekurv' }).click()
})

Then('skal opptaket være synlig', async ({ userContext, testData }) => {
  await expect(userContext.currentPage.getByText(testData.opptakNavn!)).toBeVisible()
})
