# language: no
@FLY-OPT-SAK-001 @must @planned @e2e
Egenskap: Saksbehandlertildeling
  Fra opptaket settes opp, til riktig organisasjon har saken. Opptaksforvalteren ved forvaltende
  organisasjon setter opp tildelingsreglene for opptaket, og hvert utdanningstilbud får en
  saksbehandlertildelingsregel. Når søkeren sender inn søknaden, fordeles søknadsalternativene,
  og søknaden blir én sak hos hver saksbehandlende organisasjon. Endres utdanningsbakgrunnen
  til en bakgrunn med unntak før fristen opptaket har satt, flyttes søknadsalternativene.

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" forvaltes av HK-dir
    Og at "Universitetet i Oslo", "UiT Norges arktiske universitet", "NTNU" og "Høgskulen på Vestlandet" deltar i opptaket
    Og at opptaket har en standard saksbehandlertildelingsregel med «Alle som deltar i opptaket»

  @depends-on-OPT-OVO-SAM-001 @depends-on-OPT-BEH-BEH-011
  # OPT-OVO-SAM-001: lærestedene som deltar i opptaket.
  # OPT-BEH-BEH-011: «Opptaksforvalteren ved forvaltende organisasjon setter opp tildelingsreglene for opptaket»
  # og «Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket».
  Regel: Tildelingsreglene settes for opptaket

    Scenario: Lærestedene kan velge saksbehandlertildelingsregelen opptaket har satt opp
      Når opptaksforvalteren ved HK-dir oppretter den aktive saksbehandlertildelingsregelen "SPE" med «Bare tilbyderen – bare dette studieønsket»
      Så kan opptaksforvalteren ved NTNU velge "SPE" for utdanningstilbudene ved NTNU i opptaket

  @depends-on-OPT-OPT-UTD-004
  # «Opptaksforvalter kan velge saksbehandlertildelingsregel per utdanningstilbud»
  Regel: Utdanningstilbudet får saksbehandlertildelingsregel

    Scenario: Utdanningstilbudet får saksbehandlertildelingsregelen fra opptaket
      Gitt at saksbehandlertildelingsregelen "SPE" er aktiv i opptaket
      Når opptaksforvalteren ved NTNU velger "SPE" for utdanningstilbudet "Utøvende musikk, NTNU"
      Så har "Utøvende musikk, NTNU" saksbehandlertildelingsregelen "SPE"

  @depends-on-OPT-BEH-BEH-011
  # «Søknadsalternativene fordeles når søknaden sendes inn eller endres, og fordelingen ligger fast»
  Regel: Søknadsalternativene fordeles når søknaden sendes

    Scenario: Søknaden blir én sak hos hver saksbehandlende organisasjon
      Gitt at "Utøvende musikk, NTNU" har saksbehandlertildelingsregelen "SPE"
      Og at "Informatikk, UiO" og "Historie, UiT" ikke har egen saksbehandlertildelingsregel
      Når søkeren sender inn søknaden med "Informatikk, UiO", "Utøvende musikk, NTNU" og "Historie, UiT" i den rekkefølgen
      Så er "Universitetet i Oslo" saksbehandlende organisasjon for "Informatikk, UiO" og "Historie, UiT"
      Og "NTNU" er saksbehandlende organisasjon for "Utøvende musikk, NTNU"
      Og søknaden har én sak hos "Universitetet i Oslo" og én sak hos "NTNU"

    Scenario: Organisasjonen som saksbehandler på vegne av lærestedet får saken
      Gitt at "OsloMet" saksbehandler på vegne av "Arkitektur- og designhøgskolen i Oslo" i opptaket
      Når søkeren sender inn søknaden med "Arkitektur, AHO"
      Så har søknaden én sak hos "OsloMet"

  @depends-on-OPT-BEH-BEH-011 @depends-on-OPT-BEH-BEH-010
  # OPT-BEH-BEH-011: «Saksbehandlende organisasjon ser bare saker hos organisasjonen» og
  # «Tilbyderen ser saksbehandlingen når en annen organisasjon saksbehandler utdanningstilbudet».
  # OPT-BEH-BEH-010: tilbudsgarantien tilbyderen setter.
  Regel: Den saksbehandlende organisasjonen ser saken

    Scenario: Saksbehandleren ved den saksbehandlende organisasjonen ser saken
      Gitt at søknaden har saker hos "Universitetet i Oslo" og "NTNU"
      Når saksbehandleren ved Universitetet i Oslo åpner søknaden
      Så ser saksbehandleren saken hos "Universitetet i Oslo"

    Scenario: Tilbyderen kan sette tilbudsgaranti på søknadsalternativet som en annen organisasjon saksbehandler
      Gitt at "Historie, UiT" er fordelt til "Universitetet i Oslo"
      Når saksbehandleren ved UiT Norges arktiske universitet setter tilbudsgaranti på "Historie, UiT"
      Så har "Historie, UiT" tilbudsgaranti

  @depends-on-OPT-OVO-FRI-001 @depends-on-OPT-BEH-BEH-011
  # OPT-OVO-FRI-001: «Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for endring av utdanningsbakgrunn»
  # OPT-BEH-BEH-011: «Søknadsalternativene flyttes når utdanningsbakgrunnen endres til en bakgrunn med unntak»
  Regel: Søknadsalternativene flyttes når utdanningsbakgrunnen endres

    Scenario: Søknadsalternativene flyttes til HK-dir før fristen for endring av utdanningsbakgrunn
      Gitt at opptakets frist for endring av utdanningsbakgrunn ikke har gått ut
      Og at søkerens søknadsalternativer er fordelt til "Universitetet i Oslo"
      Når saksbehandleren ved Universitetet i Oslo endrer søkerens utdanningsbakgrunn til "Utenlandsk"
      Så er "HK-dir" saksbehandlende organisasjon for alle søknadsalternativene

    Scenario: Søknadsalternativene blir hos organisasjonen etter fristen for endring av utdanningsbakgrunn
      Gitt at opptakets frist for endring av utdanningsbakgrunn har gått ut
      Og at søkerens søknadsalternativer er fordelt til "Universitetet i Oslo"
      Når saksbehandleren ved Universitetet i Oslo endrer søkerens utdanningsbakgrunn til "Utenlandsk"
      Så er "Universitetet i Oslo" fortsatt saksbehandlende organisasjon for alle søknadsalternativene
