# language: no
@FLY-OPT-VAL-001 @must @draft @e2e @ref-OPT-BEH-BEH-004
Egenskap: Automatisk saksbehandling på vitnemålet saksbehandleren velger
  Fra saksbehandleren starter den automatiske behandlingen på vitnemålet saksbehandleren velger,
  til saken er ferdig behandlet og klar til å være med i plasstildelingen. Søkeren har flere
  vitnemål som gir GSK, og saken behandles derfor ikke helautomatisk
  (FLY-OPT-AUT-001).
  Saksbehandleren starter den automatiske behandlingen på ett av vitnemålene. Resten av løpet er
  det samme som i den automatiske saksbehandlingen, på vitnemålet saksbehandleren valgte:
  GSK-konklusjonen, grunnlaget, poengene, tilleggspoengene, kravelementene, kvotene,
  poengsummen per kvote og manglene, til saken er ferdig behandlet.

  # Avklart 2026-10-29: saksbehandleren velger vitnemålet før den automatiske behandlingen
  # starter, og før grunnlaget velges. Det er ikke det samme valget som valget av vitnemål som
  # grunnlag i OPT-BEH-BEH-004.
  # Å starte den automatiske behandlingen på et vitnemål står i OPT-BEH-BEH-032 (PR #862, ikke
  # merget 2026-10-30). Den første fasen får @depends-on-OPT-BEH-BEH-032 når kravet er merget.

  Bakgrunn:
    Gitt at søknaden til "Kari Nordmann" har en sak hos "Universitetet i Oslo"
    Og at "Kari Nordmann" har vitnemålene "Vitnemål 2024" og "Vitnemål 2025", som begge gir GSK

  @depends-on-OPT-BEH-BEH-025
  # OPT-BEH-BEH-025: «Har søkeren flere vitnemål, behandles saken automatisk på vitnemålet saksbehandleren velger»
  Regel: Saksbehandleren starter den automatiske behandlingen på vitnemålet saksbehandleren velger

    Scenario: Saken behandles automatisk på vitnemålet saksbehandleren velger
      Gitt at saken hos "Universitetet i Oslo" ikke er behandlet helautomatisk
      Når saksbehandleren ved Universitetet i Oslo starter den automatiske behandlingen på "Vitnemål 2025"
      Så behandles saken hos "Universitetet i Oslo" automatisk på "Vitnemål 2025"

  @depends-on-FLY-OPT-AUT-001
  # FLY-OPT-AUT-001: «Den automatiske behandlingen setter GSK-konklusjonen der den mangler», «Søknaden får grunnlag fra vitnemålet», «Poengene beregnes fra grunnlaget og rangeringsregelverket», «Søknaden får tilleggspoeng når grunnlaget er satt», «Kravelementene vurderes mot vitnemålet når poengene er beregnet», «Kvotespørsmålene med algoritme besvares automatisk», «Kvalifiseringen oppdateres når kravelementene er vurdert», «Søkeren fordeles på kvoter når kvalifiseringen og kvotesvarene er satt», «Søkeren får poengsum per kvote når søkeren er fordelt på kvoter», «Saken får mangler når kravelementene er vurdert», «Mangelen for GSK som fullføres i vår sjekkes ut før saken blir ferdig behandlet», «Saken blir ferdig behandlet og er klar til å være med i plasstildelingen», «Søknadsalternativene beregnes på nytt når regelverket er rettet»
  Regel: Resten av saken behandles som i den automatiske saksbehandlingen

    Scenario: Saken er ferdig behandlet på det valgte vitnemålet
      Gitt at saken hos "Universitetet i Oslo" behandles automatisk på "Vitnemål 2025"
      Når den automatiske behandlingen er ferdig
      Så har søknaden grunnlag fra "Vitnemål 2025"
      Og saken hos "Universitetet i Oslo" er ferdig behandlet
