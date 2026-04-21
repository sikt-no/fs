# language: no
@BRU-APP-API-011 @must @planned
Egenskap: Oversikt over egne API-brukere
  Som brukeradministrator på lærested
  ønsker jeg en oversikt over mine API-brukere
  slik at jeg kan administrere dem.

  # Krav fra Confluence: K11 Oversikt over egne API-brukere

  Scenario: Se API-brukere tilknyttet eget lærested
    Gitt jeg er innlogget som brukeradministrator på lærested
    Når jeg åpner oversikten over API-brukere
    Så ser jeg kun API-brukere tilknyttet mitt lærested
