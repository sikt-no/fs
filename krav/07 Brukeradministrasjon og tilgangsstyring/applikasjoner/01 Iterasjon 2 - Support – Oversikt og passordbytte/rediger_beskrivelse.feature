# language: no
# GitHub: #443
@BRU-APP-API-006 @must @planned
Egenskap: Redigere beskrivelse for API-bruker
  Som bruker
  ønsker jeg å redigere beskrivelsen for en API-bruker
  slik at informasjonen er oppdatert og korrekt.

  # Krav fra Confluence: K19 Redigere beskrivelse for API-bruker

  Bakgrunn:
    Gitt jeg er på detaljsiden for en API-bruker

  Regel: Redigering av beskrivelse krever rettighet over API-brukerens organisasjon

    Scenario: Oppdatere beskrivelse
      Gitt jeg har rettighet til å administrere API-brukeren
      Når jeg oppdaterer beskrivelsen
      Så er den nye beskrivelsen lagret på API-brukeren

    Scenario: Api-brukeradministrator kan redigere beskrivelse for API-brukere i egne organisasjoner
      Gitt jeg har api-brukeradministrator-rollen for organisasjonen API-brukeren tilhører
      Så har jeg mulighet til å redigere beskrivelsen

    Scenario: Redigering av beskrivelse er ikke tilgjengelig for API-brukere fra andre organisasjoner
      Gitt jeg har api-brukeradministrator-rollen, men ikke for organisasjonen API-brukeren tilhører
      Så er muligheten til å redigere beskrivelsen ikke tilgjengelig

    Scenario: Api-superbrukeradministrator kan redigere beskrivelse for alle API-brukere
      Gitt jeg har api-superbrukeradministrator-rollen
      Så har jeg mulighet til å redigere beskrivelsen uavhengig av organisasjon
