# language: no
@skip @støtteprosesser
Egenskap: Oversikt over samtykker og informasjon om datadeling
  Som administrator trenger jeg å kunne se hvilke samtykker en person har gitt min organisasjon, fordi dette kan være med å belyse saker om hvorfor en person har eller ikke har tilgang til en tjeneste.
Som administrator skal jeg aldri kunne endre på samtykker for person. Det er kun lesetilgang som er aktuelt.

  Bakgrunn:
    Gitt administratoren er logget inn
    Gitt at administrator er inne på personsøket

  Scenariomal: Navigere til fanen samtykker (egentlig egen feature for navigasjon rundt personprofilen??? ligger opprinnelig under søknad)
    Gitt at administrator åpner personprofilen til "<input>"
    Når administrator klikker på "<fanen>"
    Så kommer administrator inn på "<fanen>"
    Eksempler:
      |input           |fanen    |fanen    |
      |hermione granger|samtykker|samtykker|

  Scenario: Se om en person har samtykket til å dele data med europeisk studentbevis (ESC-router)
    Gitt at jeg ser på en persons profil
    Når jeg går til delen for samtykker
    Så skal jeg se om personen har samtykket til å dele data med europeisk studentbevis (ESC-router)
    Og andre samtykkker ...

  Scenariomal: Se en persons samtykker og datadeling ved administrators organisasjon
    Gitt at administrator er på fanen "samtykker"
    Når administrator ser på samtykker til "<person>"
    Så ser administrator "<samtykketype>", "<svar på samtykke>" "<periode for samtykke>" "<samtykketekst>"
    Eksempler:
      |person          |samtykketype                 |svar på samtykke|periode for samtykke     |samtykketekst|
      |førstegangssøker|datadeling etter hjemmel §   |ikke aktuelt    |fra dato til dato        |her kommer teksten personen ser       |
      |andregangssøker |europeisk studentbevis       |ja              |fra dato til dato        |masse tekst som personen ser|
      |tredjegangssøker|dele bilde                   |nei             |fra dato -ingen utl      |enda mer tekst som personen ser   |