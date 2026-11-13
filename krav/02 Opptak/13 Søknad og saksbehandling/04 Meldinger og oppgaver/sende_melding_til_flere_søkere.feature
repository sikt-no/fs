# language: no
@OPT-SØK-MEL-005 @should @draft @scope-meldinger-til-flere-sokere
Egenskap: Sende melding til flere søkere
  Som opptaksforvalter ved organisasjonen som forvalter opptaket
  ønsker jeg å sende en melding til et utvalg av søkerne eller til alle søkerne
  slik at søkerne som berøres, får vite det i tide.

  Saksbehandleren og lærestedet som tilbyr utdanningstilbudet kan også sende til et utvalg
  av søkerne. Meldingen til én søker står i sende_melding_til_søker.feature.

  # Kilde: workshop om meldinger 2026-11-09 (Miro), K6, K7, K9, K10, K11 og svar 4 og 6.

  # ÅPNE SPØRSMÅL:
  # - Hvem ved lærestedet som tilbyr utdanningstilbudet sender meldingen?
  #   Er det en egen rolle, eller saksbehandleren ved lærestedet? (Samme spørsmål
  #   som i sende_melding_til_søker.feature.)

  Regel: Opptaksforvalteren sender melding til et utvalg av søkerne eller til alle søkerne i opptaket

    Scenario: Opptaksforvalteren sender melding til et utvalg av søkerne
      Gitt at opptaksforvalteren har valgt et utvalg av søkerne i opptaket
      Når opptaksforvalteren sender en melding til søkerne som er valgt
      Så mottar søkerne som er valgt, meldingen
      Men søkerne som ikke er valgt, mottar ikke meldingen

    Scenario: Opptaksforvalteren sender melding til alle søkerne i opptaket
      Når opptaksforvalteren sender en melding til alle søkerne i opptaket
      Så mottar alle søkerne i opptaket meldingen

  Regel: Saksbehandleren og lærestedet som tilbyr utdanningstilbudet sender melding til et utvalg av søkerne, men ikke til alle
    # Rollen er T, B eller F i søknaden (svar 4).

    Scenariomal: <avsender> kan ikke sende melding til alle søkerne
      Når <avsender> velger mottakere for en melding
      Så finner ikke <avsender> muligheten til å sende til alle søkerne i opptaket

      Eksempler:
        | avsender                                 |
        | saksbehandleren                          |
        | lærestedet som tilbyr utdanningstilbudet |

    Scenario: Bare søkere lærestedet har en rolle til, får meldingen
      Gitt at lærestedet har en rolle i søknaden til den ene av to søkere
      Når saksbehandleren ved lærestedet sender en melding til et utvalg med begge søkerne
      Så mottar søkeren lærestedet har en rolle i søknaden til, meldingen
      Men den andre søkeren mottar ikke meldingen

  Regel: Søkerne til et utdanningstilbud med opptaksprøve får informasjon om opptaksprøven

    Scenariomal: Søkerne får informasjon om <opptaksprøve>
      Gitt at et utdanningstilbud har opptaksprøve
      Når saksbehandleren sender informasjon om <opptaksprøve> til søkerne til utdanningstilbudet
      Så mottar søkerne som har utdanningstilbudet som søknadsalternativ, informasjonen
      Men søkere som ikke har søkt på utdanningstilbudet, mottar ikke informasjonen

      Eksempler:
        | opptaksprøve                |
        | oppmøte på opptaksprøven    |
        | innsending av opptaksprøven |

  Regel: Søkerne i en søkergruppe får informasjon om dokumentasjonskravene for gruppen

    Scenariomal: Søkerne som er <søkergruppe>, får informasjon om dokumentasjonskravene
      Gitt at saksbehandleren har valgt søkerne som er <søkergruppe>
      Når saksbehandleren sender informasjon om dokumentasjonskravene for søkergruppen
      Så mottar søkerne som er valgt, informasjonen

      Eksempler:
        | søkergruppe                     |
        | søkere med utenlandsk utdanning |
        | realkompetansesøkere            |

  @openquestion
  Regel: Opptaksforvalteren forvalter dokumentasjonskravene, og søkeren ser dem i Min kompetanse
    # ÅPNE SPØRSMÅL:
    # - Løsningen er ikke valgt (K7-0). Workshopen ville se på andre måter å løse det på.
    # - Hvor i FS Admin skal opptaksforvalteren forvalte dokumentasjonskravene?

  Regel: Søkerne til et utdanningstilbud som er avlyst, får melding om avlysningen
    # Opptaksforvalteren sender alltid meldingen når et utdanningstilbud er avlyst.

    Scenario: Lærestedet varsler opptaksforvalteren om avlysningen
      Gitt at lærestedet som tilbyr utdanningstilbudet har avlyst utdanningstilbudet
      Når lærestedet varsler opptaksforvalteren om avlysningen
      Så mottar opptaksforvalteren varselet om avlysningen

    Scenario: Opptaksforvalteren sender melding om avlysningen
      Gitt at opptaksforvalteren har fått varsel om at et utdanningstilbud er avlyst
      Når opptaksforvalteren sender melding om avlysningen
      Så mottar søkerne som har utdanningstilbudet som søknadsalternativ, meldingen

  Regel: Søkerne til et utdanningstilbud med store endringer i studieplanen får melding om endringene
    # Opptaksforvalteren vurderer om endringen er stor nok til at søkerne skal få melding (svar 6).

    Scenario: Lærestedet varsler opptaksforvalteren om en stor endring i studieplanen
      Gitt at studieplanen for et utdanningstilbud er endret
      Når lærestedet som tilbyr utdanningstilbudet varsler opptaksforvalteren om endringen
      Så mottar opptaksforvalteren varselet om endringen

    Scenario: Opptaksforvalteren sender melding om endringen
      Gitt at opptaksforvalteren har fått varsel om en stor endring i studieplanen
      Når opptaksforvalteren vurderer at søkerne skal få melding
      Så mottar søkerne som har utdanningstilbudet som søknadsalternativ, melding om hva som er endret

    Scenario: Opptaksforvalteren vurderer at søkerne ikke skal få melding
      Gitt at opptaksforvalteren har fått varsel om en endring i studieplanen
      Når opptaksforvalteren vurderer at søkerne ikke skal få melding
      Så sendes ingen melding til søkerne som har utdanningstilbudet som søknadsalternativ
