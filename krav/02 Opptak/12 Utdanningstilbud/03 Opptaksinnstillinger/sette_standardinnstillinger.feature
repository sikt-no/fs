# language: no
# GitHub: #599
@OPT-OPT-UTD-008 @must @draft
Egenskap: Sette standardinnstillinger for flere utdanningstilbud
  Som opptaksforvalter
  ønsker jeg å sette innstillinger som gjelder for flere utdanningstilbud av gangen
  slik at jeg ikke må sette opp hvert utdanningstilbud for seg.

  # Kilde: GitHub #599. Scenarioene om flere utdanningstilbud av gangen er flyttet hit fra
  # opptaksinnstillinger_utdanningstilbud.feature.
  # Opptaksforvalter ved deltakende organisasjon kan sette innstillinger på egne utdanningstilbud.
  # Opptaksforvalter ved forvaltende organisasjon kan sette innstillinger på alle utdanningstilbud.

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at opptaket "Samordna opptak 2027" har utdanningstilbud

  Regel: Opptaksforvalter kan sette innstillinger for flere utdanningstilbud av gangen

    Scenario: Sette regelverk på flere utdanningstilbud av gangen
      Når opptaksforvalter velger flere utdanningstilbud
      Og opptaksforvalter setter kompetanseregelverk og rangeringsregelverk for alle valgte
      Så bruker alle de valgte utdanningstilbudene det angitte regelverket i søknadsbehandling og rangering

    Scenario: Sette prosentfordeling på flere utdanningstilbud av gangen
      Når opptaksforvalter velger flere utdanningstilbud
      Og opptaksforvalter setter kvotefordelingen til 50 % ordinær og 50 % førstegangsvitnemål for alle valgte
      Så bruker alle de valgte utdanningstilbudene denne prosentfordelingen i plasstildelingen

  Regel: Et enkelt utdanningstilbud kan avvike fra standardinnstillingen

    Scenario: Sette spesiell prosentfordeling på enkelttilbud
      Gitt at opptaksforvalter har satt standard kvotefordeling på flere utdanningstilbud
      Når opptaksforvalter velger utdanningstilbudet "Sykepleie, høst 2027"
      Og opptaksforvalter endrer kvotefordelingen til 40 % ordinær, 50 % førstegangsvitnemål og 10 % samisk kvote
      Så bruker dette utdanningstilbudet den spesielle fordelingen i stedet for standardfordelingen

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Er en standardinnstilling en mal som utdanningstilbudene arver, slik at en endring slår gjennom
  #   på alle som ikke har egen innstilling? Eller er det en engangsoppdatering av de valgte tilbudene?
  # - Hvilke innstillinger kan settes som standard (regelverk, kvotefordeling, plassflyt, runder, tilbudsgaranti)?
  # - Gjelder standarden for hele opptaket, for en organisasjon, eller for et utvalg tilbud?
  Regel: Endringer i standardinnstillingen

    Scenario: Endre standard kvotefordeling
      Gitt at opptaksforvalter har satt standard kvotefordeling 50 % ordinær og 50 % førstegangsvitnemål
      Og at utdanningstilbudet "Sykepleie, høst 2027" har spesiell fordeling
      Når opptaksforvalter endrer standard kvotefordeling til 60 % ordinær og 40 % førstegangsvitnemål
      Så bruker utdanningstilbudene uten spesiell fordeling den nye standardfordelingen
      Og utdanningstilbudet "Sykepleie, høst 2027" beholder sin spesielle fordeling
