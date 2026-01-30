# language: no
@DEM-KON-BYT-001 @demo @implemented
Egenskap: Bytte mellom brukerkontekster
  Som tester ønsker jeg å kunne bytte mellom administrator og person
  slik at jeg kan verifisere data på tvers av roller.

  @e2e @implemented
  Scenario: Verifiser at kontekst-bytte fungerer
    Gitt at jeg er logget inn som administrator
    Så skal jeg være på adminflaten

    Når jeg bytter til person
    Så skal jeg være på personflaten
