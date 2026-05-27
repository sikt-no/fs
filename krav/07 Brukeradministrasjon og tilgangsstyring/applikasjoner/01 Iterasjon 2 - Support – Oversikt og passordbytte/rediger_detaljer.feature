# language: no
# GitHub: #443
@BRU-APP-API-006 @must @planned
Egenskap: Redigere detaljer for applikasjon
  Som bruker
  ønsker jeg å redigere detaljer for en applikasjon
  slik at informasjonen er oppdatert og korrekt.

  # Krav fra Confluence: K19 Redigere beskrivelse for API-bruker

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon

  Regel: Redigering av navn krever rettighet over applikasjonens organisasjon

    Scenario: Oppdatere navn
      Gitt jeg har rettighet til å administrere applikasjonen
      Når jeg oppdaterer navnet
      Så er det nye navnet lagret på applikasjonen

    Scenario: Applikasjonsadministrator kan redigere navn for applikasjoner i egne organisasjoner
      Gitt jeg har applikasjonsadministrator-rollen for organisasjonen applikasjonen tilhører
      Så har jeg mulighet til å redigere navnet

    Scenario: Redigering av navn er ikke tilgjengelig for applikasjoner fra andre organisasjoner
      Gitt jeg har applikasjonsadministrator-rollen, men ikke for organisasjonen applikasjonen tilhører
      Så er muligheten til å redigere navnet ikke tilgjengelig

    Scenario: Super-applikasjonsadministrator kan redigere navn for alle applikasjoner
      Gitt jeg har super-applikasjonsadministrator-rollen
      Så har jeg mulighet til å redigere navnet uavhengig av organisasjon

  Regel: Navn er obligatorisk og kan ikke lagres tomt

    Scenario: Lagring avvises når navn er tomt
      Gitt jeg har rettighet til å administrere applikasjonen
      Når jeg forsøker å lagre et tomt navn
      Så avvises lagringen
      Og det fremgår at navn er obligatorisk

  Regel: Redigering av beskrivelse krever rettighet over applikasjonens organisasjon

    Scenario: Oppdatere beskrivelse
      Gitt jeg har rettighet til å administrere applikasjonen
      Når jeg oppdaterer beskrivelsen
      Så er den nye beskrivelsen lagret på applikasjonen

    Scenario: Applikasjonsadministrator kan redigere beskrivelse for applikasjoner i egne organisasjoner
      Gitt jeg har applikasjonsadministrator-rollen for organisasjonen applikasjonen tilhører
      Så har jeg mulighet til å redigere beskrivelsen

    Scenario: Redigering av beskrivelse er ikke tilgjengelig for applikasjoner fra andre organisasjoner
      Gitt jeg har applikasjonsadministrator-rollen, men ikke for organisasjonen applikasjonen tilhører
      Så er muligheten til å redigere beskrivelsen ikke tilgjengelig

    Scenario: Super-applikasjonsadministrator kan redigere beskrivelse for alle applikasjoner
      Gitt jeg har super-applikasjonsadministrator-rollen
      Så har jeg mulighet til å redigere beskrivelsen uavhengig av organisasjon
