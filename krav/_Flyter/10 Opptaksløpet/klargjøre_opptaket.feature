# language: no
@FLY-OPT-KLA-001 @must @draft @e2e
Egenskap: Klargjøre opptaket
  Fra et samordna opptak er opprettet, til utdanningstilbudene er klare når søknaden åpner.
  Opptaksforvalteren ved forvaltende organisasjon gjør lærestedene til deltakere, og åpner opptaket
  for redigering. Utdanningsinstansene fra utdanningsregisteret blir utdanningstilbud lærestedene kan
  legge til, og utdanningstilbudene får regelverk og utdanningskvoter fra regelverkssamlingen opptaket
  bruker. Når opptaket er publisert, ser søkerne utdanningstilbudene. Når søknaden har åpnet, kan
  utdanningstilbudene ikke lenger fjernes.

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" forvaltes av HK-dir

  @depends-on-OPT-OVO-SAM-001
  # «Opptaksforvalter ved forvaltende organisasjon kan legge til organisasjoner i et samordna opptak»
  # og «Kun organisasjoner som deltar i opptaket kan legge til utdanningstilbud»
  Regel: Lærestedene blir deltakere i opptaket

    Scenario: Lærestedet som deltar, kan knytte utdanningstilbud til opptaket
      Når opptaksforvalteren ved HK-dir legger til organisasjonen "Universitetet i Oslo" som deltaker i opptaket
      Så kan opptaksforvalteren ved Universitetet i Oslo knytte utdanningstilbud ved Universitetet i Oslo til opptaket

  @depends-on-OPT-OPT-UTD-005 @depends-on-OPT-OPT-UTD-002
  # OPT-OPT-UTD-005: «Utdanningsinstanser som møter opptakets kriterier blir tilgjengelige utdanningstilbud»
  # og «Nye utdanningsinstanser i utdanningsregisteret blir tilgjengelige»
  # OPT-OPT-UTD-002: «Opptaksforvalter ser kun utdanningstilbud som matcher opptakets kriterier»
  Regel: Utdanningsinstansene fra utdanningsregisteret blir utdanningstilbud som kan legges til

    Scenario: Utdanningsinstansen fra utdanningsregisteret kan legges til i opptaket
      Gitt at "Universitetet i Oslo" deltar i opptaket
      Og at utdanningsregisteret har en instans av bachelorprogrammet "Sykepleie" ved "Universitetet i Oslo" med studiestart høst 2027 på campus "Blindern"
      Når opptaket henter utdanninger fra utdanningsregisteret
      Så kan opptaksforvalteren ved Universitetet i Oslo legge til "Sykepleie, høst 2027" på campus "Blindern" i opptaket

    Scenario: En ny utdanningsinstans etter første henting kan legges til i opptaket
      Gitt at "Universitetet i Oslo" deltar i opptaket
      Og at opptaket har hentet utdanninger fra utdanningsregisteret
      Og at lærestedet "Universitetet i Oslo" registrerer en ny instans av bachelorprogrammet "Vernepleie" med studiestart høst 2027
      Når opptaket henter utdanninger fra utdanningsregisteret på nytt
      Så kan opptaksforvalteren ved Universitetet i Oslo legge til "Vernepleie, høst 2027" i opptaket

  @depends-on-OPT-OVO-FRI-001 @depends-on-OPT-OPT-UTD-002
  # OPT-OVO-FRI-001: «Opptaksforvalter ved forvaltende organisasjon må kunne åpne og stenge for redigering av utdanningstilbud»
  # OPT-OPT-UTD-002: «Deltakende organisasjoner kan knytte til og redigere utdanningstilbud bare i perioden opptaket er åpent for redigering»
  Regel: Lærestedene legger til utdanningstilbudene mens opptaket er åpent for redigering

    Scenario: Lærestedet legger til utdanningstilbudet i perioden opptaket er åpent for redigering
      Gitt at "Universitetet i Oslo" deltar i opptaket
      Og at opptaksforvalteren ved HK-dir har satt at redigering av utdanningstilbud åpner "2026-10-01" og stenger "2027-06-06"
      Når opptaksforvalteren ved Universitetet i Oslo legger til "Sykepleie, høst 2027" i opptaket "2026-10-15"
      Så er "Sykepleie, høst 2027" lagt til i opptaket

  @depends-on-OPT-OVO-INN-001 @depends-on-OPT-OPT-UTD-004 @depends-on-OPT-REG-KVO-003 @depends-on-OPT-REG-KVO-004
  # OPT-OVO-INN-001: «Opptaksforvalter kan endre regelverkssamling så lenge ingen utdanningstilbud er knyttet til opptaket»
  # OPT-OPT-UTD-004: «Opptaksforvalter kan sette kompetanseregelverk og rangeringsregelverk»,
  # «Lærestedet velger utdanningskvotene blant kvotetypene i regelverkssamlingen» og
  # «Utdanningskvotene følger kvoteprioriteten og plassflyten i regelverkssamlingen»
  # OPT-REG-KVO-003 og OPT-REG-KVO-004: plassflyten og kvoteprioriteten i regelverkssamlingen.
  Regel: Utdanningstilbudene får regelverk og utdanningskvoter fra regelverkssamlingen opptaket bruker

    Scenario: Lærestedet velger regelverk fra regelverkssamlingen opptaket bruker
      Gitt at opptaket bruker regelverkssamlingen "UHG 2027"
      Og at "Sykepleie, høst 2027" er lagt til i opptaket
      Når opptaksforvalteren ved Universitetet i Oslo setter regelverk for "Sykepleie, høst 2027"
      Så kan opptaksforvalteren bare velge blant regelverkene i regelverkssamlingen "UHG 2027"

    Scenario: Utdanningskvotene følger regelverkssamlingen opptaket bruker
      Gitt at opptaket bruker regelverkssamlingen "UHG 2027"
      Og at regelverkssamlingen "UHG 2027" har kvoteprioritet og plassflyt for "Førstegangsvitnemål (ORDF)" og "Ordinær kvote (ORD)"
      Når opptaksforvalteren ved Universitetet i Oslo legger til "Førstegangsvitnemål (ORDF)" og "Ordinær kvote (ORD)" på "Sykepleie, høst 2027"
      Så har utdanningskvotene på "Sykepleie, høst 2027" kvoteprioriteten og plassflyten fra regelverkssamlingen "UHG 2027"

    Scenario: Regelverkssamlingen kan ikke byttes når utdanningstilbud er knyttet til opptaket
      Gitt at "Sykepleie, høst 2027" er lagt til i opptaket
      Så kan opptaksforvalteren ved HK-dir ikke endre regelverkssamlingen for opptaket

  @depends-on-OPT-OVO-GRU-004 @depends-on-OPT-SØK-SØK-013
  # OPT-OVO-GRU-004: «Opptaksforvalter ved forvaltende organisasjon publiserer opptaket»
  # OPT-SØK-SØK-013: «Synlighet via publiseringen av opptaket»
  Regel: Søkerne ser utdanningstilbudene når opptaket er publisert

    Scenario: Søkeren ser utdanningstilbudet når opptaket er publisert
      Gitt at "Sykepleie, høst 2027" er lagt til i opptaket
      Når opptaksforvalteren ved HK-dir publiserer opptaket
      Så vises "Sykepleie, høst 2027" i listen når søkeren åpner Finn studier

  @depends-on-OPT-OVO-FRI-001 @depends-on-OPT-OPT-UTD-026
  # OPT-OVO-FRI-001: «Opptaksforvalter ved forvaltende organisasjon må kunne åpne for søkning»
  # OPT-OPT-UTD-026: «Utdanningstilbud kan ikke fjernes etter at opptaket har åpnet for søknad»
  Regel: Utdanningstilbudene kan ikke fjernes når søknaden har åpnet

    Scenario: Lærestedet kan ikke fjerne utdanningstilbudet etter at søknaden har åpnet
      Gitt at opptaksforvalteren ved HK-dir har satt at søknaden åpner "2027-02-01"
      Og at "Sykepleie, høst 2027" er lagt til i opptaket
      Når opptaksforvalteren ved Universitetet i Oslo vil fjerne "Sykepleie, høst 2027" fra opptaket "2027-02-02"
      Så er "Sykepleie, høst 2027" fortsatt med i opptaket
