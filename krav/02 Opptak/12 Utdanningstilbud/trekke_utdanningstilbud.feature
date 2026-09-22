# language: no
@OPT-OPT-UTD-003 @must @draft
Egenskap: Trekke utdanningstilbud fra opptak
  Som opptaksforvalter
  ønsker jeg å kunne trekke utdanningstilbud fra opptaket
  slik at utdanninger som ikke lenger skal ha opptak blir håndtert riktig.

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at opptaket "Samordna opptak 2027" har utdanningstilbud

  Regel: Opptaksforvalter ved deltakende organisasjon eller forvaltende organisasjon kan trekke utdanningstilbud

    Scenario: Opptaksforvalter ved deltakende organisasjon trekker eget utdanningstilbud
      Gitt at opptaksforvalter er ved en deltakende organisasjon
      Når opptaksforvalter velger å trekke utdanningstilbudet "Sykepleie, høst 2027"
      Så varsles opptaksforvalter om konsekvensen av å trekke
      Og utdanningstilbudet trekkes fra opptaket

    Scenario: Opptaksforvalter ved forvaltende organisasjon trekker utdanningstilbud
      Gitt at opptaksforvalter er ved forvaltende organisasjon
      Når opptaksforvalter velger å trekke utdanningstilbudet "Sykepleie, UiO, høst 2027"
      Så varsles opptaksforvalter om konsekvensen av å trekke
      Og utdanningstilbudet trekkes fra opptaket

  Regel: Trekking før søknadsåpning fjerner utdanningstilbudet fra listen

    Scenario: Trekke utdanningstilbud før søknadsåpning
      Gitt at søknadsperioden ikke har startet
      Når opptaksforvalter trekker utdanningstilbudet "Sykepleie, høst 2027"
      Så fjernes utdanningstilbudet fra listen over utdanningstilbud i opptaket

  Regel: Trekking etter søknadsåpning gir tydeligere varsel og varsler søkere

    Scenario: Trekke utdanningstilbud etter søknadsåpning
      Gitt at søknadsperioden har startet
      Og at søkere har søkt på utdanningstilbudet "Sykepleie, høst 2027"
      Når opptaksforvalter velger å trekke utdanningstilbudet
      Så får opptaksforvalter et tydelig varsel om konsekvensen for søkere som har søkt
      Og søkere som har søkt varsles
      Og utdanningstilbudet blir liggende på opptaket, tydelig markert som trukket

  Regel: Trekking er ikke mulig etter trekkfristen for deltakende organisasjoner

    Scenario: Opptaksforvalter ved deltakende organisasjon forsøker å trekke etter trekkfristen
      Gitt at trekkfristen for utdanningstilbud er passert
      Og at opptaksforvalter er ved en deltakende organisasjon
      Så kan opptaksforvalter ikke trekke utdanningstilbud fra opptaket