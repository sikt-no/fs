# language: no
@FLY-OPT-SAM-001 @must @draft @e2e
Egenskap: Automatisk saksbehandling på sammensatt vitnemål
  Fra saksbehandleren har satt sammen et vitnemål i vitnemålsbehandleren, til saken er ferdig
  behandlet og klar til å være med i plasstildelingen. Saksbehandleren setter sammen vitnemålet
  av fag fra flere av søkerens vitnemål og kompetansebevis, og starter den automatiske behandlingen på det
  sammensatte vitnemålet. Resten av løpet er det samme som i den automatiske saksbehandlingen
  (FLY-OPT-AUT-001), på det sammensatte vitnemålet. Et sammensatt vitnemål er aldri et
  førstegangsvitnemål.

  Bakgrunn:
    Gitt at søknaden til "Kari Nordmann" har en sak hos "Universitetet i Oslo"
    Og at "Kari Nordmann" har et vitnemål fra 2024 og et kompetansebevis fra 2025

  @openquestion
  Regel: Saksbehandleren setter sammen et vitnemål i vitnemålsbehandleren
    # Avklart 2026-10-30: et sammensatt vitnemål er prinsipielt VPL, ulik poengsum per
    # søknadsalternativ («Søkeren kan få ulik poengsum til ulike søknadsalternativer» i
    # OPT-BEH-BEH-022). Det må også dekke 23/6-regelen.
    # ÅPNE SPØRSMÅL:
    # - Kravet mangler. Hvordan settes et sammensatt vitnemål sammen?
    # - OPT-BEH-BEH-022 sier at fag bare kan hentes fra flere dokumenter etter 23/6-regelen
    #   («Hente studiekompetansefag fra flere dokumenter etter 23/6-regelen»). Med VPL hentes fag
    #   fra flere dokumenter også utenfor 23/6-regelen. Må OPT-BEH-BEH-022 endres?
    # - Får det sammensatte vitnemålet påstanden om GSK? Påstanden beregnes når vitnemålet
    #   importeres fra KREG (OPT-BEH-BEH-015), og det sammensatte vitnemålet importeres ikke.
    #   Svaret må kontrolleres mot kravene for GSK (OPT-BEH-BEH-015 og OPT-BEH-BEH-027). Det er
    #   ikke sikkert at påstanden skal beregnes.

    Scenario: Saksbehandleren setter sammen et vitnemål av fag fra flere dokumenter
      Når saksbehandleren ved Universitetet i Oslo setter sammen et vitnemål av fag fra vitnemålet fra 2024 og kompetansebeviset fra 2025
      Så har "Kari Nordmann" et sammensatt vitnemål

    Scenario: Det sammensatte vitnemålet er ikke et førstegangsvitnemål
      Når saksbehandleren ved Universitetet i Oslo setter sammen et vitnemål
      Så er det sammensatte vitnemålet ikke et førstegangsvitnemål

    Scenario: Det sammensatte vitnemålet har bare resultater søkeren har
      # Avklart 2026-10-29: saksbehandleren setter ikke sammen et vitnemål søkeren ikke har.
      Når saksbehandleren ved Universitetet i Oslo setter sammen et vitnemål
      Så har det sammensatte vitnemålet bare fag og karakterer fra vitnemål og kompetansebevis "Kari Nordmann" har

  @depends-on-OPT-BEH-BEH-025
  # OPT-BEH-BEH-025: «Har søkeren flere vitnemål, behandles saken automatisk på vitnemålet saksbehandleren velger»
  Regel: Saksbehandleren starter den automatiske behandlingen på det sammensatte vitnemålet
    # Avklart 2026-10-29: saksbehandleren må si at den automatiske behandlingen skal kjøre med det
    # sammensatte vitnemålet. Å starte behandlingen på et vitnemål står i OPT-BEH-BEH-032 (PR #862,
    # ikke merget 2026-10-30). Fasen får @depends-on-OPT-BEH-BEH-032 når kravet er merget.

    Scenario: Saken behandles automatisk på det sammensatte vitnemålet
      Gitt at "Kari Nordmann" har et sammensatt vitnemål
      Når saksbehandleren ved Universitetet i Oslo starter den automatiske behandlingen på det sammensatte vitnemålet
      Så behandles saken hos "Universitetet i Oslo" automatisk på det sammensatte vitnemålet

  @depends-on-OPT-BEH-BEH-019
  # OPT-BEH-BEH-019: «Grunnlaget velges ut fra egenskapene regelverket har gitt det»
  Regel: Søknaden får ikke grunnlaget for førstegangsvitnemål på det sammensatte vitnemålet
    # Fasen er en del av «Søknaden får grunnlag fra vitnemålet» i FLY-OPT-AUT-001, og står for seg
    # fordi et sammensatt vitnemål aldri er et førstegangsvitnemål.

    Scenario: Søknaden på det sammensatte vitnemålet får ikke grunnlaget som krever førstegangsvitnemål
      Gitt at saken hos "Universitetet i Oslo" behandles automatisk på det sammensatte vitnemålet
      Og at søkeren er 21 år på datoen for aldersberegning
      Når søknaden behandles automatisk
      Så får søknaden ikke grunnlaget som krever førstegangsvitnemål

  @depends-on-FLY-OPT-AUT-001
  # FLY-OPT-AUT-001: «Den automatiske behandlingen setter GSK-konklusjonen der den mangler», «Søknaden får grunnlag fra vitnemålet», «Poengene beregnes fra grunnlaget og rangeringsregelverket», «Søknaden får tilleggspoeng når grunnlaget er satt», «Kravelementene vurderes mot vitnemålet når poengene er beregnet», «Kvotespørsmålene med algoritme besvares automatisk», «Kvalifiseringen oppdateres når kravelementene er vurdert», «Søkeren fordeles på kvoter når kvalifiseringen og kvotesvarene er satt», «Søkeren får poengsum per kvote når søkeren er fordelt på kvoter», «Saken får mangeltekster når kravelementene er vurdert», «Mangelen for GSK som fullføres i vår sjekkes ut før saken blir ferdig behandlet», «Saken blir ferdig behandlet og er klar til å være med i plasstildelingen», «Søknadsalternativene beregnes på nytt når regelverket er rettet»
  Regel: Resten av saken behandles som i den automatiske saksbehandlingen

    Scenario: Saken er ferdig behandlet på det sammensatte vitnemålet
      Gitt at saken hos "Universitetet i Oslo" behandles automatisk på det sammensatte vitnemålet
      Når den automatiske behandlingen er ferdig
      Så har søknaden grunnlag fra det sammensatte vitnemålet
      Og saken hos "Universitetet i Oslo" er ferdig behandlet
