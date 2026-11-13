# language: no
@FLY-OPT-DOK-001 @must @draft @e2e @depends-on-FLY-OPT-AUT-001
Egenskap: Automatisk saksbehandling med opplastet dokumentasjon
  Fra søkeren med ett digitalt vitnemål har lastet opp dokumentasjon på søknaden, til saksbehandleren
  har lest dokumentet. Søkeren har ett vitnemål fra KREG, og vitnemålet gir GSK. Saken behandles
  helautomatisk som i den automatiske saksbehandlingen (FLY-OPT-AUT-001), og blir ferdig behandlet.
  Den opplastede dokumentasjonen hindrer ikke den automatiske behandlingen, og den automatiske
  behandlingen leser ikke dokumentet. Dokumentet er ubehandlet til saksbehandleren har lest det.
  Saksbehandleren finner saken med filteret for ubehandlet opplastet dokumentasjon, leser dokumentet,
  og endrer saken når dokumentet gir grunn til det.

  # Avklart 2026-11-13: «ubehandlet» dokumentasjon er det samme som dokumentasjon som ikke er lest
  # («Ny dokumentasjon» i saksoversikten). Saksbehandleren behandler dokumentet ved å lese det.

  Bakgrunn:
    Gitt at søkeren har ett vitnemål fra KREG, og vitnemålet gir GSK

  @depends-on-OPT-SØK-SØK-019
  # OPT-SØK-SØK-019: «Søkeren kan laste opp dokumentasjon før og etter at søknaden er sendt inn»
  Regel: Søkeren laster opp dokumentasjon på søknaden

    Scenario: Søkeren laster opp et dokument på søknaden
      Gitt at søkeren har begynt på en søknad
      Når søkeren laster opp et dokument på søknaden
      Så ser søkeren dokumentet på søknaden

  @depends-on-FLY-OPT-AUT-001 @depends-on-OPT-BEH-BEH-018 @depends-on-OPT-BEH-BEH-025
  # OPT-BEH-BEH-018: «Ingen automatisk beregning uten ett entydig vitnemål»
  # OPT-BEH-BEH-025: «Bare saker der søkeren har ett vitnemål, og vitnemålet gir GSK, behandles helautomatisk»
  Regel: Saken blir ferdig behandlet automatisk selv om søkeren har lastet opp dokumentasjon

    Scenario: Saken med opplastet dokumentasjon blir ferdig behandlet automatisk
      Gitt at søkeren har lastet opp et dokument på søknaden
      Når den automatiske behandlingen er ferdig
      Så er saken ferdig behandlet
      Og dokumentet søkeren har lastet opp, er ikke lest

  @openquestion
  Regel: Saksbehandleren finner saken med ubehandlet opplastet dokumentasjon
    # ÅPNE SPØRSMÅL:
    # - Filteret står i listevisning_og_søk_i_saker.feature, men Feature-ID-en OPT-BEH-BEH-046 er også
    #   brukt i behandle_yrkesfaglig_vitnemål_med_påbygging.feature. @depends-on-OPT-BEH-BEH-046 settes
    #   når ID-en er ryddet.

    Scenario: Filteret finner saken som er ferdig behandlet med ubehandlet opplastet dokumentasjon
      Gitt at saken er ferdig behandlet automatisk
      Og at dokumentet søkeren har lastet opp, ikke er lest
      Når saksbehandleren hos behandleren filtrerer saksoversikten på ubehandlet opplastet dokumentasjon
      Så finner saksbehandleren saken

  @openquestion
  Regel: Dokumentet er behandlet når saksbehandleren har lest det
    # ÅPNE SPØRSMÅL:
    # - Kravet mangler. At FS Admin merker dokumentet som lest når saksbehandleren åpner det, står bare
    #   i en kommentar i behandlingsstatus.feature (OPT-BEH-BEH-029). Hvilket krav skal eie regelen?

    Scenario: Saken er ikke med i filteret når saksbehandleren har lest dokumentet
      Gitt at saken er ferdig behandlet automatisk
      Og at dokumentet søkeren har lastet opp, ikke er lest
      Når saksbehandleren åpner dokumentet
      Så er dokumentet lest
      Og filteret for ubehandlet opplastet dokumentasjon finner ikke saken

  @depends-on-OPT-BEH-BEH-029
  # OPT-BEH-BEH-029: «Saksbehandleren kan sette behandlingsstatusen», og reglene for når behandlingsstatusen endres
  Regel: Saksbehandleren endrer saken når dokumentet gir grunn til det

    Scenario: Saken er fortsatt ferdig behandlet når dokumentet ikke endrer noe
      Gitt at saken er ferdig behandlet automatisk
      Når saksbehandleren har lest dokumentet søkeren har lastet opp, uten å endre saken
      Så har saken fortsatt behandlingsstatusen "Behandlet"

    Scenario: Saken er ferdig behandlet igjen når saksbehandleren har endret saken ut fra dokumentet
      Gitt at saken er ferdig behandlet automatisk
      Og at saksbehandleren har lest dokumentet søkeren har lastet opp
      Når saksbehandleren endrer saken ut fra dokumentet og setter behandlingsstatusen til "Behandlet"
      Så har saken behandlingsstatusen "Behandlet"
