# language: no
@OPT-BEH-BEH-025 @must @draft @ref-OPT-BEH-BEH-004 @ref-OPT-BEH-BEH-018 @ref-OPT-BEH-BEH-019 @ref-OPT-BEH-BEH-020
Egenskap: Ferdigbehandle en sak
  Som saksbehandler
  ønsker jeg at saker som kan behandles helt automatisk, blir ferdig behandlet uten at jeg gjør noe
  slik at jeg bare trenger å behandle sakene den automatiske behandlingen ikke kunne fullføre.

  En sak er søknaden slik den ligger hos én saksbehandlende organisasjon. Saken behandles
  helautomatisk når søkeren har ett vitnemål, og vitnemålet har påstanden at søkeren har GSK. Den automatiske
  behandlingen avgjør da grunnlaget, poengene, kravelementene og kvoten, og setter saken til
  ferdig behandlet når alt er avgjort. Har søkeren flere vitnemål med påstanden GSK, velger
  saksbehandleren vitnemålet, og beregner poengene i vitnemålsbehandlingen (OPT-BEH-BEH-004).
  Saken behandles da automatisk på vitnemålet, og den automatiske behandlingen avgjør resten.
  Kan den automatiske behandlingen ikke avgjøre et steg, gjør den stegene
  som ikke bygger på det, og saken blir stående under behandling. Saksbehandleren gjør resten,
  og setter saken til ferdig behandlet. Bare saker som er ferdig behandlet, er med i
  plasstildelingen.

  # Flyttet hit fra starte_plasstildeling.feature (OPT-PLA-TIL-001) 2026-10-26: «Automatisk
  # saksbehandling gjør saken ferdig behandlet».
  # Kode i dag: den automatiske behandlingen (AutomatiskSaksbehandlingService) setter ikke saken
  # til ferdig behandlet. Bare saksbehandleren gjør det (EndreStatusService).
  # Søkere uten et vitnemål med påstanden at søkeren har GSK, behandles ikke automatisk
  # (OPT-BEH-BEH-015, -018, -019 og -020), og blir ferdig behandlet av saksbehandleren.
  # Kode i dag: den automatiske behandlingen setter GSK-konklusjonen selv, og stopper når
  # søkeren har flere vitnemål.

  # ÅPNE SPØRSMÅL:
  # - Hvordan får opptaksforvalteren vite om en feil i regelverket som stopper den automatiske
  #   behandlingen?
  # - Hvilke feil i regelverket kan stoppe et steg? Koden kjenner disse: poengformelen mangler,
  #   viser til seg selv eller er ugyldig, og et kvotespørsmål har en algoritme koden ikke kjenner.

  # Avklart 29.10.2026: når den automatiske behandlingen starter, står i OPT-BEH-BEH-032. Et nytt
  # vitnemål i en sak som er ferdig behandlet, er ny dokumentasjon. Saken behandles ikke
  # automatisk på nytt, men saksbehandleren ser at den har fått ny dokumentasjon, og kan starte
  # behandlingen på det nye vitnemålet.

  Bakgrunn:
    Gitt at søknaden til "Kari Nordmann" har en sak hos "Universitetet i Oslo"

  @depends-on-OPT-BEH-BEH-015 @ref-FLY-OPT-AUT-001
  # OPT-BEH-BEH-015: «Opptakssystemets påstand om GSK på vitnemålet»
  Regel: Bare saker der søkeren har ett vitnemål, med påstanden GSK, behandles helautomatisk

    Scenario: Saken behandles helautomatisk når søkeren har ett vitnemål, med påstanden GSK
      Gitt at "Kari Nordmann" har ett vitnemål
      Og at vitnemålet har påstanden at søkeren har GSK
      Når søknaden behandles automatisk
      Så behandles saken hos "Universitetet i Oslo" helautomatisk på vitnemålet

    Scenario: Saken behandles ikke helautomatisk når ingen vitnemål har påstanden GSK
      Gitt at ingen av vitnemålene til "Kari Nordmann" har påstanden at søkeren har GSK
      Når søknaden behandles automatisk
      Så behandles ikke saken hos "Universitetet i Oslo" helautomatisk

    Scenario: Saken behandles ikke helautomatisk før saksbehandleren har valgt vitnemål
      Gitt at "Kari Nordmann" har to vitnemål med påstanden at søkeren har GSK
      Når søknaden behandles automatisk
      Så behandles ikke saken hos "Universitetet i Oslo" helautomatisk

    @openquestion
    Scenario: Søker med flere vitnemål der bare ett har påstanden GSK
      # ÅPNE SPØRSMÅL:
      # - Hvis en søker har to eller flere vitnemål, men bare ett har påstanden at søkeren har GSK,
      #   skal saken gå gjennom den helautomatiske flyten eller ikke? Søknaden får GSK-konklusjonen
      #   fra vitnemålet med påstanden (OPT-BEH-BEH-015, «Konklusjon på søknaden fra vitnemålet»).
      #   Det som står igjen, er om grunnlaget og poengene kan bygge på det vitnemålet uten at
      #   saksbehandleren har valgt. Det andre vitnemålet kan ha fag som gir søkeren flere poeng.
      #   Svaret endrer også raden «søkeren har flere elektroniske vitnemål …» i OPT-BEH-BEH-018
      #   og OPT-BEH-BEH-019.
      Gitt at "Kari Nordmann" har to vitnemål
      Og at bare ett av vitnemålene har påstanden at søkeren har GSK
      Når søknaden behandles automatisk
      Så behandles saken hos "Universitetet i Oslo" helautomatisk på vitnemålet med påstanden at søkeren har GSK

  @ref-OPT-BEH-BEH-015
  # OPT-BEH-BEH-015: «Konklusjon på søknaden fra vitnemålet»
  Regel: Har søkeren flere vitnemål med påstanden GSK, behandles saken automatisk på vitnemålet saksbehandleren velger

    Scenario: Saksbehandleren velger vitnemålet saken behandles automatisk på
      # Vitnemålet saksbehandleren velger, kan være et annet enn vitnemålet GSK-konklusjonen på
      # søknaden bygger på (det med senest utstedelsesdato). Begge vitnemålene gir GSK, og
      # konklusjonen endres ikke av valget.
      Gitt at "Kari Nordmann" har to vitnemål med påstanden at søkeren har GSK, ett fra 2024 og ett fra 2025
      Når saksbehandleren ved Universitetet i Oslo velger vitnemålet fra 2025 for automatisk behandling
      Så behandles saken hos "Universitetet i Oslo" automatisk på vitnemålet fra 2025

  @ref-FLY-OPT-AUT-001
  Regel: Den automatiske behandlingen setter saken til ferdig behandlet når alt er avgjort

    Bakgrunn:
      Gitt at "Kari Nordmann" har ett vitnemål med påstanden at søkeren har GSK

    Scenario: Saken er ferdig behandlet når den automatiske behandlingen har avgjort alt
      Gitt at den automatiske behandlingen kan avgjøre alle stegene for saken
      Når søknaden behandles automatisk
      Så er saken hos "Universitetet i Oslo" ferdig behandlet

    @depends-on-OPT-BEH-BEH-008
    # OPT-BEH-BEH-008: «Kategorien til mangelkoden avgjør hva mangelen hindrer» og «Saken får mangler for kravelementene søkeren ikke oppfyller»
    Scenario: Saken er ferdig behandlet selv om kravelementene ga mangel
      Gitt at "Informatikk, UiO" har kravelementet "Matematikk R2"
      Og at vitnemålet ikke har "Matematikk R2"
      Når søknaden behandles automatisk
      Så har saken en automatisk mangel som viser at "Matematikk R2" ikke er oppfylt
      Og saken hos "Universitetet i Oslo" er ferdig behandlet

    @depends-on-OPT-BEH-BEH-008
    # OPT-BEH-BEH-008: «Søkeren ser bare manglene som er publisert, og får melding om dem»
    Scenario: Den automatiske behandlingen publiserer manglene når saken blir ferdig behandlet
      # Avklart 2026-10-26 i review av PR #818: saksbehandleren gjør ingenting i saken, så
      # automatikken publiserer manglene når den setter saken til ferdig behandlet.
      Gitt at "Informatikk, UiO" har kravelementene "Matematikk R2" og "Fysikk 2"
      Og at vitnemålet verken har "Matematikk R2" eller "Fysikk 2"
      Når søknaden behandles automatisk
      Så er saken hos "Universitetet i Oslo" ferdig behandlet
      Og søkeren ser de automatiske manglene for "Matematikk R2" og "Fysikk 2" i Min kompetanse
      Og søkeren har mottatt én melding om mangler

  @ref-FLY-OPT-AUT-001
  Regel: Steg som bygger på et steg som ikke kan avgjøres, hoppes over

    Bakgrunn:
      Gitt at "Kari Nordmann" har ett vitnemål med påstanden at søkeren har GSK

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
      Gitt at "Kari Nordmann" har ett vitnemål med påstanden at søkeren har GSK

    Scenario: Saksbehandleren ferdigbehandler saken etter å ha gjort resten
      Gitt at saken hos "Universitetet i Oslo" er under behandling fordi poengene for "Informatikk, UiO" ikke kunne avgjøres automatisk
      Og at saksbehandleren ved Universitetet i Oslo har satt poengene for "Informatikk, UiO"
      Når saksbehandleren setter saken til "Ferdig behandlet"
      Så er saken hos "Universitetet i Oslo" ferdig behandlet

    Scenario: Saken blir ikke ferdig behandlet av seg selv når saksbehandleren har gjort resten
      Gitt at saken hos "Universitetet i Oslo" er under behandling fordi poengene for "Informatikk, UiO" ikke kunne avgjøres automatisk
      Når saksbehandleren ved Universitetet i Oslo setter poengene for "Informatikk, UiO"
      Så er saken hos "Universitetet i Oslo" fortsatt under behandling
