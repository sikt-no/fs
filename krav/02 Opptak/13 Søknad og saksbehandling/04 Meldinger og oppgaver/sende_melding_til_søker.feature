# language: no
# BEGREPER (2026-11-10): Bytt «saksbehandlende organisasjon» med «behandler» når fila likevel endres. Se krav/02 Opptak/begreper.md.
@OPT-SØK-MEL-001 @must @draft @scope-meldinger-varslinger-og-oppgaver
Egenskap: Sende melding til søker
  Som saksbehandler ved saksbehandlende organisasjon
  ønsker jeg å sende en melding til en søker om søknaden
  slik at søkeren har det som trengs for å gjøre alt riktig med søknaden.

  Som forvaltningsorgan har lærestedet ansvar for at søkerne har forutsetningene for å gjøre
  alt riktig med søknaden, og det er viktig i klagebehandlingen. Saksbehandleren,
  opptaksforvalteren og lærestedet som tilbyr utdanningstilbudet kan sende en melding til én søker.
  Utsending til et utvalg av søkerne eller til alle står i sende_melding_til_flere_søkere.feature.

  # Kilde: workshop om meldinger 2026-11-09 (Miro), K11 og svar 4.
  # Meldingene søkeren ser i Min kompetanse, står i
  # 01 Søknad/mine_meldinger.feature (@OPT-SØK-SØK-010).

  Regel: Avsenderen sender melding til søkere lærestedet har en rolle i søknaden til
    # Rollen er T, B eller F i søknaden (svar 4).

    Scenario: Saksbehandleren sender melding til en søker
      Gitt at saksbehandlerens organisasjon er saksbehandlende organisasjon for et søknadsalternativ i søkerens søknad
      Når saksbehandleren sender en melding til søkeren
      Så mottar søkeren meldingen

    @openquestion
    Scenario: Lærestedet som tilbyr utdanningstilbudet sender melding til en søker
      # ÅPNE SPØRSMÅL:
      # - Hvem ved lærestedet som tilbyr utdanningstilbudet sender meldingen?
      #   Er det en egen rolle, eller saksbehandleren ved lærestedet?
      Gitt at søkeren har søkt på et utdanningstilbud lærestedet tilbyr
      Når lærestedet som tilbyr utdanningstilbudet sender en melding til søkeren
      Så mottar søkeren meldingen

    Scenario: Opptaksforvalteren sender melding til en søker i opptaket
      Gitt at søkeren har en søknad i opptaket opptaksforvalteren forvalter
      Når opptaksforvalteren sender en melding til søkeren
      Så mottar søkeren meldingen

    Scenario: Søker uten rolle til lærestedet kan ikke velges som mottaker
      Gitt at lærestedet ikke har en rolle i søkerens søknad
      Når saksbehandleren ved lærestedet velger mottaker for en melding
      Så finner ikke saksbehandleren søkeren blant mottakerne

  Regel: Meldingen vises i søkerens meldinger i Min kompetanse
    # Søkeren kan ikke svare på meldingen nå. Løsningen skal legge til rette for
    # at søkeren kan svare senere.

    Scenario: Søkeren ser meldingen i Min kompetanse
      Gitt at saksbehandleren har sendt en melding til søkeren
      Når søkeren åpner meldingsoversikten i Min kompetanse
      Så vises meldingen i listen

    Scenario: Søkeren kan ikke svare på meldingen
      Gitt at søkeren har mottatt en melding fra saksbehandleren
      Når søkeren åpner meldingen
      Så ser ikke søkeren muligheten til å svare på meldingen

  @openquestion
  Regel: Avsenderen velger om meldingen også sendes på e-post og SMS
    # ÅPNE SPØRSMÅL:
    # - Varsling på e-post og SMS lages av et annet team. Dette scopet skal bare
    #   legge til rette for kanalvalget, ikke lage det. Hva må være på plass her
    #   for at varslingen kan kobles på senere?

  @openquestion
  Regel: Opptaksforvalteren forvalter tekstene til meldingene

  # Avklart 2026-11-10 (svar 22): valget gjelder per melding. Standard er at meldingen er delt med de andre
  # organisasjonene på søknaden. Søkeren ser meldingen uansett.
  Regel: Avsenderen velger om meldingen er intern

    Scenario: En melding er delt som standard
      Gitt søknaden er i et samordna opptak der tilbyderen og behandleren er ulike organisasjoner
      Og jeg er saksbehandler ved behandleren av søknadsalternativet
      Når jeg sender en melding til søkeren uten å merke den som intern
      Så ser saksbehandleren ved tilbyderen meldingen
      Og opptaksforvalteren ved forvalteren ser meldingen

    Scenario: En intern melding ses bare av organisasjonen som sendte den
      Gitt søknaden er i et samordna opptak der tilbyderen og behandleren er ulike organisasjoner
      Og jeg er saksbehandler ved behandleren av søknadsalternativet
      Når jeg sender en melding til søkeren og merker den som intern
      Så ser ikke saksbehandleren ved tilbyderen meldingen
      Men søkeren ser meldingen

  # Avklart 2026-11-10 (R16, svar 31): forvalteren endrer alle tekstene i opptaket. Tilbyderen og behandleren endrer
  # bare tekstene som gjelder det organisasjonen tilbyr eller behandler.
  @openquestion
  Regel: Hvem som endrer tekstene til søkerne, følger organisasjonens rolle i opptaket
    # ÅPNE SPØRSMÅL:
    # - Hvem ser og endrer generiske tekster, som ikke gjelder bestemte søkere eller utdanningstilbud (svar 31)?

    Scenariomal: Endre tekstene til søkerne ut fra organisasjonens rolle
      Gitt jeg er opptaksforvalter ved <organisasjon>
      Når jeg vil endre <tekst>
      Så <utfall>

      Eksempler:
        | organisasjon                     | tekst                                                     | utfall                                       |
        | forvalteren av opptaket          | teksten om et utdanningstilbud en annen organisasjon tilbyr | kan jeg endre teksten                        |
        | tilbyderen av utdanningstilbudet | teksten om utdanningstilbudet organisasjonen tilbyr       | kan jeg endre teksten                        |
        | tilbyderen av utdanningstilbudet | teksten om et utdanningstilbud en annen organisasjon tilbyr | ser jeg ikke muligheten til å endre teksten |
