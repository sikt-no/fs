# language: no
@BRU-APP-API-005 @must @planned
Egenskap: Administrere ansvarlig for API-bruker
  Som bruker
  ønsker jeg å sette og endre ansvarlig for en API-bruker
  slik at det alltid er klart hvem som er ansvarlig for API-brukeren.

  # Krav fra Confluence: K18 Administrere ansvarlig for API-bruker

  # ÅPNE SPØRSMÅL:
  # - Feide-grupper som ansvarlig: Skal det være mulig å søke opp og sette en
  #   feide-gruppe som ansvarlig, som et alternativ til en feide-bruker?

  Scenario: Sette ansvarlig for API-bruker
    Gitt jeg er på detaljsiden for en API-bruker
    Og jeg velger å sette ansvarlig
    Når jeg søker opp og velger en feide-bruker fra API-brukerens organisasjon
    Så er den valgte feide-brukeren registrert som ansvarlig for API-brukeren

  Scenario: Endre ansvarlig for API-bruker
    Gitt jeg er på detaljsiden for en API-bruker
    Og API-brukeren har en ansvarlig
    Når jeg søker opp og velger en annen feide-bruker fra API-brukerens organisasjon
    Så er den nye feide-brukeren registrert som ansvarlig for API-brukeren

  Scenario: Fjerne ansvarlig fra API-bruker
    Gitt jeg er på detaljsiden for en API-bruker
    Og API-brukeren har en ansvarlig
    Når jeg fjerner den ansvarlige
    Så har API-brukeren ikke lenger en ansvarlig registrert

  Regel: Søk etter ansvarlig er avgrenset til API-brukerens organisasjon

    Scenario: Søkeresultat viser kun feide-brukere fra API-brukerens organisasjon
      Gitt jeg velger å sette ansvarlig på en API-bruker
      Når jeg søker etter en bruker
      Så vises kun feide-brukere fra API-brukerens organisasjon i søkeresultatet
