# language: no
@FLY-OPT-SAM-001 @must @draft @e2e
Egenskap: Automatisk saksbehandling på sammensatt vitnemål
  Fra saksbehandleren har satt sammen et vitnemål i vitnemålsbehandleren, til saken er ferdig
  behandlet og er med i plasstildelingen. Saksbehandleren setter sammen vitnemålet av fag fra
  flere av søkerens vitnemål og kompetansebevis, og starter den automatiske behandlingen med det
  sammensatte vitnemålet. Resten av løpet er det samme som i den automatiske saksbehandlingen
  (FLY-OPT-AUT-001), på det sammensatte vitnemålet. Et sammensatt vitnemål er aldri et
  førstegangsvitnemål.

  Bakgrunn:
    Gitt at søknaden til "Kari Nordmann" har en sak hos "Universitetet i Oslo"
    Og at "Kari Nordmann" har et vitnemål fra 2024 og et kompetansebevis fra 2025

  @openquestion
  Regel: Saksbehandleren setter sammen et vitnemål i vitnemålsbehandleren
    # ÅPNE SPØRSMÅL:
    # - Kravet mangler. Hva er et sammensatt vitnemål, og hvordan løses det best? Det er
    #   trolig ulik poengsum per søknadsalternativ (VPL i FS, «Søkeren kan få ulik poengsum til
    #   ulike søknadsalternativer» i OPT-BEH-BEH-022), og det kan brukes til 23/6-regelen
    #   («Hente studiekompetansefag fra flere dokumenter etter 23/6-regelen» i OPT-BEH-BEH-022).
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
  # OPT-BEH-BEH-025: «Har søkeren flere vitnemål med påstanden GSK, behandles saken automatisk på vitnemålet saksbehandleren velger»
  Regel: Saksbehandleren starter den automatiske behandlingen for saken
    # Saksbehandleren må si at den automatiske behandlingen skal kjøre med det sammensatte
    # vitnemålet (avklart 2026-10-29). Hvordan det gjøres, er et åpent spørsmål i OPT-BEH-BEH-025.
    # Å starte behandlingen for én sak står i OPT-BEH-BEH-032 (PR #862, ikke merget 2026-10-29).

    Scenario: Saken behandles helautomatisk på det sammensatte vitnemålet
      Gitt at "Kari Nordmann" har et sammensatt vitnemål
      Når saksbehandleren starter den automatiske behandlingen med det sammensatte vitnemålet for saken hos "Universitetet i Oslo"
      Så behandles saken hos "Universitetet i Oslo" helautomatisk på det sammensatte vitnemålet

  @depends-on-OPT-BEH-BEH-019
  # OPT-BEH-BEH-019: «Grunnlaget velges ut fra egenskapene regelverket har gitt det»
  Regel: Søknaden får ikke grunnlaget for førstegangsvitnemål på det sammensatte vitnemålet
    # Fasen er en del av «Søknaden får grunnlag fra vitnemålet» i FLY-OPT-AUT-001, og står for seg
    # fordi et sammensatt vitnemål aldri er et førstegangsvitnemål.

    Scenario: Søknaden på det sammensatte vitnemålet får ikke grunnlaget som krever førstegangsvitnemål
      Gitt at saken hos "Universitetet i Oslo" behandles helautomatisk på det sammensatte vitnemålet
      Og at søkeren er 21 år på datoen for aldersberegning
      Når søknaden behandles automatisk
      Så får søknaden ikke grunnlaget som krever førstegangsvitnemål

  @depends-on-FLY-OPT-AUT-001
  # FLY-OPT-AUT-001: «Den automatiske behandlingen setter GSK-konklusjonen der den mangler», «Søknaden får grunnlag fra vitnemålet», «Poengene beregnes fra grunnlaget og rangeringsregelverket», «Søknaden får tilleggspoeng når grunnlaget er satt», «Kravelementene vurderes mot vitnemålet når poengene er beregnet», «Kvotespørsmålene med algoritme besvares automatisk», «Kvalifiseringen oppdateres når kravelementene er vurdert», «Søkeren fordeles på kvoter når kvalifiseringen og kvotesvarene er satt», «Søkeren får poengsum per kvote når søkeren er fordelt på kvoter», «Saken får mangler når kravelementene er vurdert», «Mangelen for GSK som fullføres i vår sjekkes ut før saken blir ferdig behandlet», «Saken blir ferdig behandlet og er med i plasstildelingen», «Søknadsalternativene beregnes på nytt når regelverket er rettet»
  Regel: Resten av saken behandles som i den automatiske saksbehandlingen

    Scenario: Saken er ferdig behandlet på det sammensatte vitnemålet
      Gitt at saken hos "Universitetet i Oslo" behandles helautomatisk på det sammensatte vitnemålet
      Når den automatiske behandlingen er ferdig
      Så har søknaden grunnlag fra det sammensatte vitnemålet
      Og saken hos "Universitetet i Oslo" er ferdig behandlet
