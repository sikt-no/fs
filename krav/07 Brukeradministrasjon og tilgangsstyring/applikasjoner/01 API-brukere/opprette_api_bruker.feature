# language: no
@BRU-APP-API-009 @must @planned
Egenskap: Opprette API-bruker
  Som bruker
  ønsker jeg å opprette en ny API-bruker
  slik at nye integrasjoner kan konfigureres.

  # Krav fra Confluence: K8 Opprette ny API-bruker

  Scenario: Opprette en ny API-bruker uten ansvarlig
    Gitt jeg er innlogget i løsningen
    Når jeg oppretter en ny API-bruker med navn
    Så er den nye API-brukeren registrert i systemet

  Scenario: Opprette en ny API-bruker med ansvarlig
    Gitt jeg er innlogget i løsningen
    Når jeg oppretter en ny API-bruker og setter en ansvarlig
    Så er API-brukeren registrert med den valgte feide-brukeren som ansvarlig
