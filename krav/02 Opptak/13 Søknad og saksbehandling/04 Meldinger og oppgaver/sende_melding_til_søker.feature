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
