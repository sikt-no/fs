# language: no
@BRU-APP-API-002 @must @planned
Egenskap: Se detaljer for API-bruker
  Som bruker
  ønsker jeg å se detaljer for en API-bruker, organisert i logiske datagrupper,
  slik at jeg har oversikt over API-brukeren.

  # Krav fra Confluence: K3 Se detaljer for API-bruker

  Scenario: Se grunnleggende informasjon
    Gitt jeg ser detaljer for en API-bruker
    Så ser jeg navn og beskrivelse

  Scenario: Se sporingsinfo
    Gitt jeg ser detaljer for en API-bruker
    Så ser jeg opprettet av, opprettet tidspunkt, endret av og endret tidspunkt

  Scenario: Se miljøer
    Gitt jeg ser detaljer for en API-bruker
    Så ser jeg hvilke miljøer API-brukeren er aktiv i

  Scenario: Se ansvarlig
    Gitt jeg ser detaljer for en API-bruker
    Så ser jeg hvem som er ansvarlig for API-brukeren
