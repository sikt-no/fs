# language: no
@FLY-OPT-AUT-001 @must @draft @e2e @depends-on-FLY-OPT-SAK-001
Egenskap: Automatisk saksbehandling
  Fra søknaden er blitt en sak hos den saksbehandlende organisasjonen, til saken er ferdig
  behandlet og er med i plasstildelingen, uten at en saksbehandler har gjort noe. Søkerens
  vitnemål importeres fra KREG når saken er opprettet (OPT-BEH-BEH-030), og påstanden om GSK
  beregnes for hvert vitnemål når vitnemålet importeres (OPT-BEH-BEH-015).
  Flyten gjelder søkere med ett vitnemål, med påstanden at søkeren har GSK. Den automatiske
  behandlingen setter grunnlaget, poengene, vurderingen av kravelementene og kvoten, i den
  rekkefølgen, og setter saken til ferdig behandlet når alt er avgjort. Andre søkere behandles
  ikke helautomatisk, og er ikke med i flyten (se OPT-BEH-BEH-025). Rettes en feil i
  regelverket, beregner opptaksforvalteren søknadsalternativene feilen gjaldt, på nytt.

  # Kjent brudd: den automatiske behandlingen setter ikke saken til ferdig behandlet, og
  # plasstildelingen krever ikke at saken er ferdig behandlet (se OPT-BEH-BEH-025 og OPT-PLA-TIL-001).
  # Kjent brudd: koden beregner GSK i den automatiske behandlingen, ikke når vitnemålet importeres,
  # og påstanden lagres ikke på vitnemålet (se OPT-BEH-BEH-015).

  Bakgrunn:
    Gitt at søknaden til "Kari Nordmann" har en sak hos "Universitetet i Oslo"

  @depends-on-OPT-BEH-BEH-030
  # OPT-BEH-BEH-030: «Resultatene hentes når søknaden kommer inn», «Alle vitnemål og kompetansebevis søkeren har i KREG, importeres»
  Regel: Søkerens resultater importeres fra KREG når søknaden kommer inn

    Scenario: Vitnemålet fra KREG er klart for behandlingen når saken er opprettet
      Gitt at "Kari Nordmann" har et vitnemål i KREG
      Når saken hos "Universitetet i Oslo" er opprettet
      Så er vitnemålet importert
      Og GSK kan beregnes for vitnemålet

  @depends-on-OPT-BEH-BEH-015 @depends-on-OPT-BEH-BEH-025
  # OPT-BEH-BEH-015: «Opptakssystemets påstand om GSK på vitnemålet»
  # OPT-BEH-BEH-025: «Bare saker der søkeren har ett vitnemål, med påstanden GSK, behandles helautomatisk»
  Regel: Vitnemålet med påstanden GSK avgjør om saken behandles helautomatisk

    Scenario: Saken behandles helautomatisk på vitnemålet med påstanden GSK
      Gitt at "Kari Nordmann" har ett vitnemål med påstanden at søkeren har GSK
      Når søknaden behandles automatisk
      Så behandles saken hos "Universitetet i Oslo" helautomatisk på vitnemålet

  @depends-on-OPT-BEH-BEH-019
  # OPT-BEH-BEH-019: «Grunnlaget velges ut fra egenskapene regelverket har gitt det», «Ingen automatisk grunnlag uten ett vitnemål som gir generell studiekompetanse», «Grunnlaget settes når den automatiske behandlingen kjører»
  Regel: Søknaden får grunnlag fra vitnemålet

    Scenario: Søknaden får grunnlag
      Gitt at saken hos "Universitetet i Oslo" behandles helautomatisk på vitnemålet
      Når søknaden behandles automatisk
      Så har søknaden grunnlag

  @depends-on-OPT-BEH-BEH-018 @depends-on-OPT-REG-RAN-001 @depends-on-OPT-REG-RAN-002
  # OPT-BEH-BEH-018: «Karakterpoeng, realfagspoeng og språkpoeng beregnes fra søkerens eneste vitnemål», «Skolepoeng settes sammen av karakterpoeng, realfagspoeng og språkpoeng», «Ingen automatisk beregning uten ett entydig vitnemål»
  Regel: Poengene beregnes fra grunnlaget og rangeringsregelverket
    # Overleveringen: grunnlaget avgjør hvilke poengtyper søknaden har (rangeringsregelverket
    # kobler grunnlag til poengtyper), og poengene i dem beregnes fra vitnemålet.
    # Avklart 2026-10-27 i review av PR #818, fra koden i fs-plattform (PoengRadOppdateringService).

    Scenario: Søknadsalternativet får poengsum
      Gitt at søknaden har grunnlag
      Når søknaden behandles automatisk
      Så har "Informatikk, UiO" poengsum for søknaden

  @depends-on-OPT-BEH-BEH-028
  # OPT-BEH-BEH-028: «Alderspoeng regnes ut fra søkerens alder», «Kjønnspoeng regnes ut fra søkerens kjønn», «Poeng for høyere utdanning regnes ut fra søkerens studiepoeng», «Tilleggspoengene settes uansett hvem som velger grunnlaget»
  Regel: Søknaden får tilleggspoeng fra grunnlaget

    Scenario: Søknaden får tilleggspoengene for grunnlaget
      Gitt at søknaden har grunnlag
      Når søknaden behandles automatisk
      Så har søknaden tilleggspoengene rangeringsregelverket gir for grunnlaget

  @depends-on-OPT-BEH-BEH-020 @depends-on-OPT-BEH-BEH-008
  # OPT-BEH-BEH-020: «Kravelementer som er koblet til vitnemålet, vurderes automatisk», «Kravelementene vurderes bare mot ett entydig vitnemål», «Om søkeren er kvalifisert, avgjøres per grunnlag», «Kravelementene vurderes i den automatiske behandlingen»
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

    Scenario: Saken er ikke med i plasstildelingen når poengene ikke kan avgjøres
      Gitt at poengene for "Informatikk, UiO" ikke kan avgjøres på grunn av en feil i regelverket
      Når den automatiske behandlingen er ferdig
      Så er saken hos "Universitetet i Oslo" ikke med når opptaksforvalteren starter en plasstildeling

  @depends-on-OPT-BEH-BEH-026
  Regel: Søknadsalternativene beregnes på nytt når regelverket er rettet

    Scenario: Poengene beregnes på nytt når rangeringsregelverket er rettet
      Gitt at saken hos "Universitetet i Oslo" er ferdig behandlet
      Og at opptaksforvalteren har rettet en feil i rangeringsregelverket
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket som er rettet
      Så har "Informatikk, UiO" poengsum etter det rettede rangeringsregelverket
      Og saken hos "Universitetet i Oslo" er fortsatt ferdig behandlet
