# language: no
# Jira: SHI-703
@OPT-OPT-UTD-024 @must @draft
Egenskap: Angi kontaktinformasjon for utdanningstilbudet
  Som opptaksforvalter
  ønsker jeg at kontaktinformasjon til saksbehandler eller opptakskontor påføres eller utledes etter saksbehandlertildelingen
  slik at søkeren kan se hvem de skal kontakte i Min kompetanse.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  Regel: Kontaktinformasjon kan påføres eller utledes etter saksbehandlertildeling

    Scenario: Kontaktinformasjon utledes fra saksbehandlertildelingen
      Gitt at utdanningstilbudet har en saksbehandlertildeling
      Så utledes kontaktinformasjonen fra saksbehandlertildelingen

    Scenario: Påføre kontaktinformasjon manuelt
      Når opptaksforvalter påfører kontaktinformasjon på utdanningstilbudet
      Så lagres kontaktinformasjonen på utdanningstilbudet

  Regel: Kontaktinformasjon vises til søkeren i Min kompetanse

    Scenario: Søker ser kontaktinformasjon i Min kompetanse
      Gitt at utdanningstilbudet har kontaktinformasjon
      Så vises kontaktinformasjonen for søkeren i Min kompetanse

# ÅPNE SPØRSMÅL:
# - Når utledes kontaktinformasjon automatisk fra tildelingen, og når påføres den manuelt?
# - Er det saksbehandlerens eller opptakskontorets kontaktinformasjon som vises?
# - Hvilke felt inngår (navn, e-post, telefon, …)?
