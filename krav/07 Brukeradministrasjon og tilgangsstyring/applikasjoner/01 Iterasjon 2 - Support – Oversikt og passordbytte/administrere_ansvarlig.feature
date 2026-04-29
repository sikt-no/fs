# language: no
# GitHub: #442
@BRU-APP-API-005 @must @planned
Egenskap: Administrere ansvarlig for applikasjon
  Som bruker
  ønsker jeg å sette og endre ansvarlig for en applikasjon
  slik at det alltid er klart hvem som er ansvarlig for applikasjonen.

  En ansvarlig er alltid en feide-bruker eller feide-gruppe, og er den
  som eventuelt har kontakt med tredjeparten som benytter applikasjonen.
  Ansvarlig arver muligheten til å endre passord på applikasjonen.

  # Krav fra Confluence: K18 Administrere ansvarlig for API-bruker

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon

  Regel: Ansvarlig kan settes, endres og fjernes

    Scenario: Sette ansvarlig
      Gitt applikasjonen har ingen ansvarlig
      Når jeg søker opp og velger en feide-bruker fra applikasjonens organisasjon
      Så er den valgte feide-brukeren registrert som ansvarlig for applikasjonen

    Scenario: Endre ansvarlig
      Gitt applikasjonen har en ansvarlig
      Når jeg søker opp og velger en annen feide-bruker fra applikasjonens organisasjon
      Så er den nye feide-brukeren registrert som ansvarlig for applikasjonen

    Scenario: Fjerne ansvarlig
      Gitt applikasjonen har en ansvarlig
      Når jeg fjerner den ansvarlige
      Så har applikasjonen ikke lenger en ansvarlig registrert

  Regel: Søk etter ansvarlig er avgrenset til applikasjonens organisasjon

    Scenario: Kun treff fra applikasjonens egen organisasjon vises
      Gitt jeg velger å sette ansvarlig
      Når jeg søker etter en ansvarlig
      Så vises kun treff fra applikasjonens organisasjon

  Regel: En feide-gruppe kan settes som ansvarlig som alternativ til feide-bruker

    @could
    Scenario: Sette en feide-gruppe som ansvarlig
      Gitt applikasjonen har ingen ansvarlig
      Når jeg søker opp og velger en feide-gruppe fra applikasjonens organisasjon
      Så er den valgte feide-gruppen registrert som ansvarlig for applikasjonen

    @could
    Scenario: Søkeresultat inkluderer feide-grupper
      Gitt jeg velger å sette ansvarlig
      Når jeg søker etter en ansvarlig
      Så vises feide-grupper fra applikasjonens organisasjon i tillegg til feide-brukere

  Regel: Administrasjon av ansvarlig krever rettighet over applikasjonens organisasjon

    Scenario: Applikasjonsadministrator kan administrere ansvarlig for applikasjoner i egne organisasjoner
      Gitt jeg har applikasjonsadministrator-rollen for organisasjonen applikasjonen tilhører
      Så har jeg mulighet til å sette, endre og fjerne ansvarlig

    Scenario: Administrasjon av ansvarlig er ikke tilgjengelig for applikasjoner fra andre organisasjoner
      Gitt jeg har applikasjonsadministrator-rollen, men ikke for organisasjonen applikasjonen tilhører
      Så er muligheten til å sette, endre og fjerne ansvarlig ikke tilgjengelig

    Scenario: Super-applikasjonsadministrator kan administrere ansvarlig for alle applikasjoner
      Gitt jeg har super-applikasjonsadministrator-rollen
      Så har jeg mulighet til å sette, endre og fjerne ansvarlig uavhengig av organisasjon
