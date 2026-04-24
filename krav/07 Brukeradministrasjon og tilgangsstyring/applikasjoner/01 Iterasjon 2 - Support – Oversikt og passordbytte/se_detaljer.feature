# language: no
# GitHub: #439
@BRU-APP-API-002 @must @planned
Egenskap: Se detaljer for API-bruker
  Som bruker
  ønsker jeg å se detaljer for en API-bruker, organisert i logiske datagrupper,
  slik at jeg har oversikt over API-brukeren.

  # Krav fra Confluence: K3 Se detaljer for API-bruker

  Bakgrunn:
    Gitt jeg ser detaljer for en API-bruker

  Regel: Detaljer organiseres i logiske datagrupper

    Scenario: Se grunnleggende informasjon
      Så ser jeg navn og beskrivelse

    Scenario: Se sporingsinfo
      Så ser jeg opprettet av, opprettet tidspunkt, endret av og endret tidspunkt

    Scenario: Se miljøer
      Så ser jeg hvilke miljøer API-brukeren er aktiv i

    Scenario: Se ansvarlig
      Så ser jeg hvem som er ansvarlig for API-brukeren
