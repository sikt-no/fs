# language: no
@OPT-OPT-UTD-003 @must @draft
Egenskap: Trekke utdanningstilbud fra opptak
  Som opptaksforvalter
  ønsker jeg å kunne trekke utdanningstilbud fra opptaket
  slik at utdanninger som ikke lenger skal ha opptak blir håndtert riktig.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at opptaket "Samordna opptak 2027" har utdanningstilbud

  Regel: Opptaksforvalter ved deltakende organisasjon eller eierorganisasjon kan trekke utdanningstilbud

    Scenario: Deltakende organisasjon trekker eget utdanningstilbud
      Gitt at jeg er opptaksforvalter ved en deltakende organisasjon
      Når jeg velger å trekke utdanningstilbudet "Sykepleie, høst 2027"
      Så varsles jeg om konsekvensen av å trekke
      Og utdanningstilbudet trekkes fra opptaket

    Scenario: Opptakseier trekker utdanningstilbud
      Gitt at jeg er opptaksforvalter ved eierorganisasjonen
      Når jeg velger å trekke utdanningstilbudet "Sykepleie, UiO, høst 2027"
      Så varsles jeg om konsekvensen av å trekke
      Og utdanningstilbudet trekkes fra opptaket

  Regel: Trekking før søknadsåpning fjerner utdanningstilbudet fra listen

    Scenario: Trekke utdanningstilbud før søknadsåpning
      Gitt at søknadsperioden ikke har startet
      Når jeg trekker utdanningstilbudet "Sykepleie, høst 2027"
      Så fjernes utdanningstilbudet fra listen over utdanningstilbud i opptaket

  Regel: Trekking etter søknadsåpning gir tydeligere varsel og varsler søkere

    Scenario: Trekke utdanningstilbud etter søknadsåpning
      Gitt at søknadsperioden har startet
      Og at søkere har søkt på utdanningstilbudet "Sykepleie, høst 2027"
      Når jeg velger å trekke utdanningstilbudet
      Så får jeg et tydelig varsel om konsekvensen for søkere som har søkt
      Og søkere som har søkt varsles
      Og utdanningstilbudet blir liggende på opptaket, tydelig markert som trukket

  Regel: Trekking er ikke mulig etter trekkfristen

    Scenario: Forsøke å trekke etter trekkfristen
      Gitt at trekkfristen for utdanningstilbud er passert
      Så kan jeg ikke trekke utdanningstilbud fra opptaket