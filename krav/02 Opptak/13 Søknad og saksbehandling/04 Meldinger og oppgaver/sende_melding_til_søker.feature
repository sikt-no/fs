# language: no
# BEGREPER (2026-11-10): Bytt «saksbehandlende organisasjon» med «behandler» når fila likevel endres. Se krav/02 Opptak/begreper.md.
@OPT-SØK-MEL-001 @must @draft @scope-meldinger-varslinger-og-oppgaver
Egenskap: Sende melding til søker
  Som saksbehandler ved saksbehandlende organisasjon
  ønsker jeg å sende en melding til en søker om søknaden
  slik at søkeren har det som trengs for å gjøre alt riktig med søknaden.

  Som forvaltningsorgan har lærestedet ansvar for at søkerne har forutsetningene for å gjøre
  alt riktig med søknaden, og det er viktig i klagebehandlingen. Saksbehandleren,
  opptaksforvalteren og de ansatte ved tilbyderen kan sende en melding til én søker. Utsending til et utvalg
  av søkerne eller til alle står i sende_melding_til_flere_søkere.feature.

  # Kilde: workshop om meldinger 2026-11-09 (Miro), K11 og beslutning 2, 4 og 8.
  # Meldingene søkeren ser i Min kompetanse, står i
  # 01 Søknad/mine_meldinger.feature (@OPT-SØK-SØK-010).

  # ÅPNE SPØRSMÅL:
  # - Tilbyderen er lærestedet som tilbyr utdanningstilbudet (begreper.md), ikke en rolle.
  #   Hvilken rolle har de ansatte ved tilbyderen som sender meldinger?
  # - Kan søkeren svare på en melding? Beslutning 9 nevner kommunikasjon «inn og ut».
  # - Hvilken meldingstype får meldingen i filteret i mine_meldinger.feature?
  # - Beslutning 8 (tekstene forvaltes av forvalteren) strider mot fellestekster.feature
  #   (@OPT-OVO-TEK-001, @wont), der kvitteringen er en standardtekst.

  Regel: Saksbehandleren, opptaksforvalteren og de ansatte ved tilbyderen sender melding til søkere organisasjonen har en rolle i søknaden til

  Regel: Meldingen vises i søkerens meldinger i Min kompetanse

  Regel: Avsenderen velger om meldingen også sendes på e-post og SMS

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
