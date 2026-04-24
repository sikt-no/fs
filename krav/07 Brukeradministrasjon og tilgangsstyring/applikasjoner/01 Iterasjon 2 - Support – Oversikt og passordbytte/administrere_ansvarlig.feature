# language: no
# GitHub: #442
@BRU-APP-API-005 @must @planned
Egenskap: Administrere ansvarlig for API-bruker
  Som bruker
  ønsker jeg å sette og endre ansvarlig for en API-bruker
  slik at det alltid er klart hvem som er ansvarlig for API-brukeren.

  En ansvarlig er alltid en feide-bruker eller feide-gruppe, og er den
  som eventuelt har kontakt med tredjeparten som benytter API-brukeren.
  Ansvarlig arver muligheten til å endre passord på API-brukeren.

  # Krav fra Confluence: K18 Administrere ansvarlig for API-bruker

  Bakgrunn:
    Gitt jeg er på detaljsiden for en API-bruker

  Regel: Ansvarlig kan settes, endres og fjernes

    Scenario: Sette ansvarlig
      Gitt API-brukeren har ingen ansvarlig
      Når jeg søker opp og velger en feide-bruker fra API-brukerens organisasjon
      Så er den valgte feide-brukeren registrert som ansvarlig for API-brukeren

    Scenario: Endre ansvarlig
      Gitt API-brukeren har en ansvarlig
      Når jeg søker opp og velger en annen feide-bruker fra API-brukerens organisasjon
      Så er den nye feide-brukeren registrert som ansvarlig for API-brukeren

    Scenario: Fjerne ansvarlig
      Gitt API-brukeren har en ansvarlig
      Når jeg fjerner den ansvarlige
      Så har API-brukeren ikke lenger en ansvarlig registrert

  Regel: Søk etter ansvarlig er avgrenset til API-brukerens organisasjon

    Scenario: Kun treff fra API-brukerens egen organisasjon vises
      Gitt jeg velger å sette ansvarlig
      Når jeg søker etter en ansvarlig
      Så vises kun treff fra API-brukerens organisasjon

  Regel: En feide-gruppe kan settes som ansvarlig som alternativ til feide-bruker

    @could
    Scenario: Sette en feide-gruppe som ansvarlig
      Gitt API-brukeren har ingen ansvarlig
      Når jeg søker opp og velger en feide-gruppe fra API-brukerens organisasjon
      Så er den valgte feide-gruppen registrert som ansvarlig for API-brukeren

    @could
    Scenario: Søkeresultat inkluderer feide-grupper
      Gitt jeg velger å sette ansvarlig
      Når jeg søker etter en ansvarlig
      Så vises feide-grupper fra API-brukerens organisasjon i tillegg til feide-brukere

  Regel: Administrasjon av ansvarlig krever rettighet over API-brukerens organisasjon

    Scenario: Api-brukeradministrator kan administrere ansvarlig for API-brukere i egne organisasjoner
      Gitt jeg har api-brukeradministrator-rollen for organisasjonen API-brukeren tilhører
      Så har jeg mulighet til å sette, endre og fjerne ansvarlig

    Scenario: Administrasjon av ansvarlig er ikke tilgjengelig for API-brukere fra andre organisasjoner
      Gitt jeg har api-brukeradministrator-rollen, men ikke for organisasjonen API-brukeren tilhører
      Så er muligheten til å sette, endre og fjerne ansvarlig ikke tilgjengelig

    Scenario: Api-superbrukeradministrator kan administrere ansvarlig for alle API-brukere
      Gitt jeg har api-superbrukeradministrator-rollen
      Så har jeg mulighet til å sette, endre og fjerne ansvarlig uavhengig av organisasjon
