# language: no
@BRU-APP-API-003 @must @planned
Egenskap: Vise roller for API-bruker
  Som bruker
  ønsker jeg å se hvilke roller en API-bruker har
  slik at jeg forstår hvilke rettigheter og miljøtilgang API-brukeren er tildelt.

  # Krav fra Confluence: K4 Se roller for API-bruker

  Scenario: Se alle roller for en API-bruker
    Gitt at tab for å vise roller er aktiv
    Så ser jeg en liste med alle roller tilknyttet API-brukeren
    Og liste viser rollekode
    Og liste viser hvilket miljø rollen gjelder for
    Og det skal være mulig å filtrere listen på miljø
    Og det skal være mulig å filtrere listen på roller
    Og filter for miljø skal gjøre det mulig å filtrere på de miljøene som er tilknyttet brukeren
    Og filter for roller skal gjøre det mulig å filtrere på de rollene som er tilknyttet brukeren
    Og det skal være mulig å sortere listen på miljø
    Og det skal være mulig å sortere listen på rollekode
    Og dersom listen er mer enn 50 resultater lang så skal det være mulig å laste inn et nytt datasett
