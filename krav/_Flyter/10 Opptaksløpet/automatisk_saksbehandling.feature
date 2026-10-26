# language: no
@FLY-OPT-AUT-001 @must @draft @e2e @depends-on-FLY-OPT-SAK-001
Egenskap: Automatisk saksbehandling
  Fra søknaden er blitt en sak hos den saksbehandlende organisasjonen, til saken er ferdig
  behandlet og er med i plasstildelingen, uten at en saksbehandler har gjort noe. GSK beregnes
  for hvert vitnemål når søknaden kommer inn, før flyten. Flyten gjelder søkere med ett vitnemål
  med positiv GSK-konklusjon, og søkere der saksbehandleren har valgt vitnemålet. Den automatiske
  behandlingen setter grunnlaget, poengene, vurderingen av kravelementene og kvoten, i den
  rekkefølgen, og setter saken til ferdig behandlet når alt er avgjort. Andre søkere behandles
  manuelt, og er ikke med i flyten. Rettes en feil i regelverket, beregner opptaksforvalteren
  søknadsalternativene feilen gjaldt, på nytt.

  # Kjent brudd: den automatiske behandlingen setter ikke saken til ferdig behandlet, og
  # plasstildelingen krever ikke at saken er ferdig behandlet (se OPT-BEH-BEH-025 og OPT-PLA-TIL-001).
  # Kjent brudd: den automatiske behandlingen setter GSK-konklusjonen selv, og GSK lagres ikke på
  # vitnemålet (se OPT-BEH-BEH-015).

  Bakgrunn:
    Gitt at søknaden til "Kari Nordmann" har en sak hos "Universitetet i Oslo"

  @depends-on-OPT-BEH-BEH-015 @depends-on-OPT-BEH-BEH-025
  # OPT-BEH-BEH-015: «Konklusjon fra vitnemålet»
  # OPT-BEH-BEH-025: «Bare saker med ett vitnemål med positiv GSK-konklusjon behandles helautomatisk»
  Regel: Vitnemålet med positiv GSK-konklusjon avgjør om saken behandles helautomatisk

    Scenario: Saken behandles helautomatisk på vitnemålet med positiv GSK-konklusjon
      Gitt at "Kari Nordmann" har ett vitnemål, og det fikk en positiv GSK-konklusjon da søknaden kom inn
      Når søknaden behandles automatisk
      Så behandles saken hos "Universitetet i Oslo" helautomatisk på vitnemålet

    Scenario: Saken behandles helautomatisk på vitnemålet saksbehandleren har valgt
      Gitt at "Kari Nordmann" har et vitnemål fra 2024 og et vitnemål fra 2025 med positiv GSK-konklusjon
      Og at saksbehandleren ved Universitetet i Oslo har valgt vitnemålet fra 2025
      Når søknaden behandles automatisk
      Så behandles saken hos "Universitetet i Oslo" helautomatisk på vitnemålet fra 2025

  @depends-on-OPT-BEH-BEH-019
  Regel: Søknaden får grunnlag fra vitnemålet

    Scenario: Søknaden får grunnlag
      Gitt at saken hos "Universitetet i Oslo" behandles helautomatisk på vitnemålet
      Når søknaden behandles automatisk
      Så har søknaden grunnlag

  @depends-on-OPT-BEH-BEH-018 @depends-on-OPT-REG-RAN-002 @openquestion
  Regel: Poengene beregnes fra grunnlaget og rangeringsregelverket
    # ÅPNE SPØRSMÅL:
    # - Bygger poengene på vitnemålet eller på grunnlaget? I OPT-BEH-BEH-018 er «grunnlaget»
    #   dokumentasjonen poengene beregnes fra, og i OPT-BEH-BEH-019 er det kvalifikasjonsgrunnlaget
    #   (VOV, VES). OPT-BEH-BEH-018 sier ikke at poengene trenger grunnlaget. Bygger de på
    #   vitnemålet, er det ingen overlevering fra fasen for grunnlag, og fasen heter «Poengene
    #   beregnes fra vitnemålet».

    Scenario: Søknadsalternativet får poengsum
      Gitt at søknaden har grunnlag
      Når søknaden behandles automatisk
      Så har "Informatikk, UiO" poengsum for søknaden

  @depends-on-OPT-BEH-BEH-020 @depends-on-OPT-BEH-BEH-008
  # OPT-BEH-BEH-008: «Saken får mangler for kravelementene søkeren ikke oppfyller»
  Regel: Kravelementene avgjør om søkeren er kvalifisert

    Scenario: Søkeren er kvalifisert når vitnemålet oppfyller kravelementene
      Gitt at søknaden har grunnlag
      Og at "Informatikk, UiO" har kravelementet "Matematikk R1"
      Og at vitnemålet saken behandles helautomatisk på, har "Matematikk R1"
      Når søknaden behandles automatisk
      Så er søkeren kvalifisert for "Informatikk, UiO"


  @depends-on-OPT-BEH-BEH-012
  Regel: Søkeren plasseres i kvote

    Scenario: Den kvalifiserte søkeren plasseres i kvoten grunnlaget er koblet til
      Gitt at søkeren er kvalifisert for "Informatikk, UiO"
      Og at grunnlaget er koblet til kvotetypen "Ordinær kvote"
      Når søknaden behandles automatisk
      Så er søkeren plassert i "Ordinær kvote" for "Informatikk, UiO"

  @depends-on-OPT-BEH-BEH-025 @depends-on-OPT-PLA-TIL-001
  # OPT-BEH-BEH-025: «Den automatiske behandlingen setter saken til ferdig behandlet når alt er avgjort»
  Regel: Saken blir ferdig behandlet og er med i plasstildelingen

    Scenario: Saken er med i plasstildelingen når den automatiske behandlingen har avgjort alt
      Gitt at søkeren er kvalifisert for "Informatikk, UiO"
      Og at "Informatikk, UiO" har poengsum for søknaden
      Og at søkeren er plassert i kvote for "Informatikk, UiO"
      Når den automatiske behandlingen er ferdig
      Så er saken hos "Universitetet i Oslo" ferdig behandlet
      Og saken hos "Universitetet i Oslo" er med når opptaksforvalteren starter en plasstildeling

    Scenario: Søkeren ser mangelen fra kravelementene når saken er ferdig behandlet
      Gitt at saken har en automatisk mangel som viser at "Matematikk R2" ikke er oppfylt
      Når den automatiske behandlingen er ferdig
      Så er saken hos "Universitetet i Oslo" ferdig behandlet
      Og søkeren ser mangelen for "Matematikk R2" i Min kompetanse

    Scenario: Saken er ikke med i plasstildelingen når poengene ikke kan beregnes
      Gitt at poengene for "Informatikk, UiO" ikke kan beregnes på grunn av en feil i rangeringsregelverket
      Når den automatiske behandlingen er ferdig
      Så er saken hos "Universitetet i Oslo" ikke med når opptaksforvalteren starter en plasstildeling

  @depends-on-OPT-BEH-BEH-026
  Regel: Søknadsalternativene beregnes på nytt når regelverket er rettet

    Scenario: Poengene beregnes på nytt når rangeringsregelverket er rettet
      Gitt at saken hos "Universitetet i Oslo" er ferdig behandlet
      Og at opptaksforvalteren har rettet rangeringsregelverket for "Informatikk, UiO"
      Når opptaksforvalteren beregner poengene på nytt for "Informatikk, UiO"
      Så har "Informatikk, UiO" poengsum etter det rettede rangeringsregelverket
      Og saken hos "Universitetet i Oslo" er fortsatt ferdig behandlet
