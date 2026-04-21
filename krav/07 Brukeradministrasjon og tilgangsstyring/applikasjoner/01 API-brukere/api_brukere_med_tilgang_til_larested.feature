# language: no
@BRU-APP-API-012 @must @planned
Egenskap: API-brukere med tilgang til lærestedets data
  Som brukeradministrator på lærested
  ønsker jeg å se hvilke API-brukere som har tilgang til mitt lærested sine data
  slik at jeg har kontroll over hvem som har tilgang.

  # Krav fra Confluence: K12 Se API-brukere med tilgang til lærestedets data

  Scenario: Se API-brukere med tilgang til eget lærested
    Gitt jeg er innlogget som brukeradministrator på lærested
    Når jeg søker opp API-brukere med tilgang til mitt lærested
    Så ser jeg alle API-brukere som har tilgang til mitt lærested sine data
