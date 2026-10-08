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

  # AVKLART 2026-10-08: Prosentfordeling mellom utdanningskvoter utgår. Antall tilbud som skal gis settes
  # som absolutte tall per utdanningskvote for hvert utdanningstilbud i hver runde.

# ÅPNE SPØRSMÅL:
# - Er en standardinnstilling en mal som utdanningstilbudene arver, slik at en endring slår gjennom
#   på alle som ikke har egen innstilling? Eller er det en engangsoppdatering av de valgte tilbudene?
# - Kan et enkelt utdanningstilbud avvike fra standardinnstillingen?
# - Hvilke innstillinger kan settes som standard (regelverk, plassflyt, runder, tilbudsgaranti)?
# - Gjelder standarden for hele opptaket, for en organisasjon, eller for et utvalg tilbud?
