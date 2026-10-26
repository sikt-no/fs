# language: no
@OPT-BEH-BEH-025 @must @draft
Egenskap: Ferdigbehandle en sak
  Som saksbehandler
  ønsker jeg at saker som kan behandles helt automatisk, blir ferdig behandlet uten at jeg gjør noe
  slik at jeg bare trenger å behandle sakene den automatiske behandlingen ikke kunne fullføre.

  En sak er søknaden slik den ligger hos én saksbehandlende organisasjon. Saken behandles
  helautomatisk når søkeren har ett vitnemål med positiv GSK-konklusjon, eller når
  saksbehandleren har valgt vitnemålet. Den automatiske behandlingen avgjør grunnlaget,
  poengene, kravelementene og kvoten, og setter saken til ferdig behandlet når alt er avgjort. Kan den ikke avgjøre et steg, gjør den stegene
  som ikke bygger på det, og saken blir stående under behandling. Saksbehandleren gjør resten,
  og setter saken til ferdig behandlet. Bare saker som er ferdig behandlet, er med i
  plasstildelingen.

  # Flyttet hit fra starte_plasstildeling.feature (OPT-PLA-TIL-001) 2026-10-26: «Automatisk
  # saksbehandling gjør saken ferdig behandlet».
  # Kode i dag: den automatiske behandlingen (AutomatiskSaksbehandlingService) setter ikke saken
  # til ferdig behandlet. Bare saksbehandleren gjør det (EndreStatusService).
  # Søkere uten et vitnemål med positiv GSK-konklusjon, behandles ikke automatisk
  # (OPT-BEH-BEH-015, -018, -019 og -020), og blir ferdig behandlet av saksbehandleren.
  # Kode i dag: den automatiske behandlingen setter GSK-konklusjonen selv, og stopper når
  # søkeren har flere vitnemål.

  # ÅPNE SPØRSMÅL:
  # - Hvordan får opptaksforvalteren vite om en feil i regelverket som stopper den automatiske
  #   behandlingen?
  # - Hvilke feil i regelverket kan stoppe et steg? Koden kjenner disse: poengformelen mangler,
  #   viser til seg selv eller er ugyldig, og et kvotespørsmål har en algoritme koden ikke kjenner.
  # - Når kjører den automatiske behandlingen? Samme spørsmål står i OPT-BEH-BEH-018, -019 og -020.
  # - Hva skjer med en sak som er ferdig behandlet, når søkeren får et nytt vitnemål?

  Bakgrunn:
    Gitt at søknaden til "Kari Nordmann" har en sak hos "Universitetet i Oslo"

  @depends-on-OPT-BEH-BEH-015 @ref-FLY-OPT-AUT-001
  # OPT-BEH-BEH-015: «Konklusjon fra vitnemålet»
  Regel: Bare saker med ett vitnemål med positiv GSK-konklusjon behandles helautomatisk

    Scenario: Saken behandles helautomatisk når søkeren har ett vitnemål med positiv GSK-konklusjon
      Gitt at "Kari Nordmann" har ett vitnemål
      Og at vitnemålet har en positiv GSK-konklusjon
      Når søknaden behandles automatisk
      Så behandles saken hos "Universitetet i Oslo" helautomatisk på vitnemålet

    Scenario: Saken behandles ikke helautomatisk når ingen vitnemål har positiv GSK-konklusjon
      Gitt at ingen av vitnemålene til "Kari Nordmann" har en positiv GSK-konklusjon
      Når søknaden behandles automatisk
      Så behandles ikke saken hos "Universitetet i Oslo" helautomatisk

    Scenario: Saken behandles ikke helautomatisk før saksbehandleren har valgt vitnemål
      Gitt at "Kari Nordmann" har to vitnemål med positiv GSK-konklusjon
      Når søknaden behandles automatisk
      Så behandles ikke saken hos "Universitetet i Oslo" helautomatisk

    Scenario: Saksbehandleren velger vitnemålet saken behandles helautomatisk på
      Gitt at "Kari Nordmann" har et vitnemål fra 2024 og et vitnemål fra 2025 med positiv GSK-konklusjon
      Når saksbehandleren ved Universitetet i Oslo velger vitnemålet fra 2025 for helautomatisk behandling
      Så behandles saken hos "Universitetet i Oslo" helautomatisk på vitnemålet fra 2025

    @openquestion
    Scenario: Søker med flere vitnemål der bare ett har positiv GSK-konklusjon
      # ÅPNE SPØRSMÅL:
      # - Hvis en søker har to eller flere vitnemål, men bare ett har en positiv GSK-konklusjon,
      #   skal saken gå gjennom den helautomatiske flyten eller ikke?
      Gitt at "Kari Nordmann" har to vitnemål
      Og at bare ett av vitnemålene har en positiv GSK-konklusjon
      Når søknaden behandles automatisk
      Så behandles saken hos "Universitetet i Oslo" helautomatisk på vitnemålet med positiv GSK-konklusjon

  @ref-FLY-OPT-AUT-001
  Regel: Den automatiske behandlingen setter saken til ferdig behandlet når alt er avgjort

    Bakgrunn:
      Gitt at "Kari Nordmann" har ett vitnemål med positiv GSK-konklusjon

    Scenario: Saken er ferdig behandlet når den automatiske behandlingen har avgjort alt
      Gitt at den automatiske behandlingen kan avgjøre alle stegene for saken
      Når søknaden behandles automatisk
      Så er saken hos "Universitetet i Oslo" ferdig behandlet

    @depends-on-OPT-BEH-BEH-008
    Scenario: Saken er ferdig behandlet selv om kravelementene ga mangel
      Gitt at "Informatikk, UiO" har kravelementet "Matematikk R2"
      Og at vitnemålet ikke har "Matematikk R2"
      Når søknaden behandles automatisk
      Så har saken en automatisk mangel som viser at "Matematikk R2" ikke er oppfylt
      Og saken hos "Universitetet i Oslo" er ferdig behandlet

  Regel: Steg som bygger på et steg som ikke kan avgjøres, hoppes over

    Bakgrunn:
      Gitt at "Kari Nordmann" har ett vitnemål med positiv GSK-konklusjon

    Scenariomal: Det som kan avgjøres, blir avgjort når <steg> ikke kan avgjøres
      Gitt at <steg> for "Informatikk, UiO" ikke kan avgjøres på grunn av en feil i regelverket
      Når søknaden behandles automatisk
      Så er <avgjort> avgjort for "Informatikk, UiO"
      Men <ikke avgjort> er ikke avgjort for "Informatikk, UiO"

      Eksempler:
        | steg           | avgjort                                                 | ikke avgjort                              |
        | poengene       | grunnlaget, kravelementene, kvalifiseringen og kvoten   | poengene                                  |
        | kravelementene | grunnlaget og poengene                                  | kravelementene, kvalifiseringen og kvoten |
        | kvoten         | grunnlaget, poengene, kravelementene og kvalifiseringen | kvoten                                    |

    Scenario: Saken blir stående under behandling når et steg ikke kan avgjøres
      Gitt at poengene for "Informatikk, UiO" ikke kan avgjøres på grunn av en feil i regelverket
      Når søknaden behandles automatisk
      Så er saken hos "Universitetet i Oslo" under behandling

  Regel: Saksbehandleren setter saken til ferdig behandlet når den automatiske behandlingen ikke har fullført

    Bakgrunn:
      Gitt at "Kari Nordmann" har ett vitnemål med positiv GSK-konklusjon

    Scenario: Saksbehandleren ferdigbehandler saken etter å ha gjort resten
      Gitt at saken hos "Universitetet i Oslo" er under behandling fordi poengene for "Informatikk, UiO" ikke kunne avgjøres automatisk
      Og at saksbehandleren ved Universitetet i Oslo har satt poengene for "Informatikk, UiO"
      Når saksbehandleren setter saken til "Ferdig behandlet"
      Så er saken hos "Universitetet i Oslo" ferdig behandlet

    Scenario: Saken blir ikke ferdig behandlet av seg selv når saksbehandleren har gjort resten
      Gitt at saken hos "Universitetet i Oslo" er under behandling fordi poengene for "Informatikk, UiO" ikke kunne avgjøres automatisk
      Når saksbehandleren ved Universitetet i Oslo setter poengene for "Informatikk, UiO"
      Så er saken hos "Universitetet i Oslo" fortsatt under behandling
