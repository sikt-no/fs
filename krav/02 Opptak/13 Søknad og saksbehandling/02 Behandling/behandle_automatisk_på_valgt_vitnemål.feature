# language: no
# GitHub: #199
#
# Skilt ut 04.11.2026 fra OPT-BEH-BEH-025 (regelen «Har søkeren flere vitnemål, behandles saken
# automatisk på vitnemålet saksbehandleren velger»), OPT-BEH-BEH-019 («Grunnlag fra vitnemålet
# saksbehandleren har valgt» og «Sammensatt vitnemål gir ikke grunnlaget som krever
# førstegangsvitnemål»), OPT-BEH-BEH-020 («Kravelementene vurderes mot vitnemålet
# saksbehandleren har valgt») og OPT-BEH-BEH-032 («Saken som er under behandling, behandles
# automatisk på vitnemålet saksbehandleren velger»). Delene var validert, og er samlet her
# uendret.
@OPT-BEH-BEH-039 @must @planned @ref-OPT-BEH-BEH-004 @ref-OPT-BEH-BEH-025 @ref-OPT-BEH-BEH-032
Egenskap: Behandle automatisk på vitnemålet saksbehandleren velger
  Som saksbehandler
  ønsker jeg at saken behandles automatisk på vitnemålet jeg velger når søkeren har flere vitnemål
  slik at jeg ikke trenger å behandle saken manuelt fordi søkeren har mer enn ett vitnemål.

  Saken behandles helautomatisk bare når søkeren har ett vitnemål, og vitnemålet gir GSK
  (OPT-BEH-BEH-025). Har søkeren flere vitnemål, velger saksbehandleren vitnemålet og starter
  den automatiske behandlingen på det. Den automatiske behandlingen avgjør da grunnlaget,
  poengene, kravelementene og resten av saken på vitnemålet saksbehandleren valgte, som i den
  automatiske saksbehandlingen.

  # Avklart 2026-10-29: saksbehandleren velger vitnemålet før den automatiske behandlingen
  # starter, og før grunnlaget velges. Det er ikke det samme valget som valget av vitnemål som
  # grunnlag for poengberegningen i vitnemålsbehandleren (OPT-BEH-BEH-004).
  # Å starte den automatiske behandlingen står i OPT-BEH-BEH-032.

  Bakgrunn:
    Gitt at søknaden til "Kari Nordmann" har en sak hos "Universitetet i Oslo"
    Og at "Kari Nordmann" har vitnemålene "Vitnemål 2024" og "Vitnemål 2025", som begge gir GSK

  @ref-OPT-BEH-BEH-015 @ref-FLY-OPT-VAL-001 @ref-FLY-OPT-SAM-001
  # OPT-BEH-BEH-015: «Konklusjon på søknaden fra vitnemålet»
  Regel: Har søkeren flere vitnemål, behandles saken automatisk på vitnemålet saksbehandleren velger
    # Saksbehandleren velger vitnemålet når den automatiske behandlingen startes på det.

    Scenario: Saksbehandleren velger vitnemålet saken behandles automatisk på
      # Vitnemålet saksbehandleren velger, kan være et annet enn vitnemålet GSK-konklusjonen på
      # søknaden bygger på (det med senest utstedelsesdato). Begge vitnemålene gir GSK, og
      # konklusjonen endres ikke av valget.
      Når saksbehandleren ved Universitetet i Oslo starter den automatiske behandlingen på "Vitnemål 2024"
      Så behandles saken hos "Universitetet i Oslo" automatisk på "Vitnemål 2024"

    @depends-on-OPT-BEH-BEH-029
    # OPT-BEH-BEH-029: «Saksbehandleren kan sette behandlingsstatusen»
    Scenario: Saken som er under behandling, behandles automatisk på vitnemålet saksbehandleren velger
      Gitt at saken har behandlingsstatusen "Under behandling"
      Når saksbehandleren ved Universitetet i Oslo starter den automatiske behandlingen på "Vitnemål 2025"
      Så behandles saken automatisk på "Vitnemål 2025"

    @draft @openquestion
    Scenario: Saken behandles automatisk på et sammensatt vitnemål
      # ÅPNE SPØRSMÅL:
      # - Ingen krav beskriver hva et sammensatt vitnemål er, eller hvordan saksbehandleren
      #   setter det sammen (se FLY-OPT-SAM-001).
      Gitt at "Kari Nordmann" har et sammensatt vitnemål
      Når saksbehandleren ved Universitetet i Oslo starter den automatiske behandlingen på det sammensatte vitnemålet
      Så behandles saken hos "Universitetet i Oslo" automatisk på det sammensatte vitnemålet

  @depends-on-OPT-BEH-BEH-019 @depends-on-OPT-BEH-BEH-020
  # OPT-BEH-BEH-019: «Grunnlaget velges ut fra egenskapene regelverket har gitt det»
  # OPT-BEH-BEH-020: «Kravelementene vurderes bare mot ett entydig vitnemål»
  Regel: Grunnlaget og kravelementene avgjøres på vitnemålet saksbehandleren har valgt

    Scenario: Grunnlag fra vitnemålet saksbehandleren har valgt
      Gitt at saksbehandleren har valgt "Vitnemål 2025"
      Når søknaden behandles automatisk
      Så får saken grunnlaget ut fra "Vitnemål 2025"

    Scenario: Kravelementene vurderes mot vitnemålet saksbehandleren har valgt
      # Ikke bygget i dag: koden vurderer bare når søkeren har ett vitnemål.
      Gitt at saksbehandleren har valgt "Vitnemål 2025"
      Og at søknaden har et kravelement som er koblet til vitnemålet
      Når søknaden behandles automatisk
      Så er kravelementet vurdert mot "Vitnemål 2025"

    @ref-FLY-OPT-SAM-001
    Scenario: Sammensatt vitnemål gir ikke grunnlaget som krever førstegangsvitnemål
      # Avklart 2026-10-29: et sammensatt vitnemål er aldri et førstegangsvitnemål.
      Gitt at regelverket har et grunnlag som krever førstegangsvitnemål og har aldersgrensen under 22 år
      Og at regelverket har et grunnlag som krever et vitnemål
      Og at søkeren er 21 år på datoen for aldersberegning
      Og at saken behandles automatisk på et sammensatt vitnemål
      Når søknaden behandles automatisk
      Så får saken grunnlaget som krever et vitnemål
      Men saken får ikke grunnlaget som krever førstegangsvitnemål
