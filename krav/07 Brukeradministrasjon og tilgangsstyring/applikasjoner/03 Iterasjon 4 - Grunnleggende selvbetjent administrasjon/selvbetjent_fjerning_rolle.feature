# language: no
# GitHub: #451
@BRU-APP-API-014 @must @draft
Egenskap: Selvbetjent fjerning av rolle
  Som brukeradministrator
  ønsker jeg å fjerne en rolle fra en API-bruker
  slik at roller som ikke lenger er nødvendige blir ryddet bort.

  # Krav fra Confluence: K14 Fjerne rolle fra API-bruker (selvbetjening)

  Regel: Brukeradministrator kan kun fjerne roller de har rettigheter til

    Scenario: Fjerne rolle som brukeradministrator
      Gitt jeg er innlogget som brukeradministrator på lærested
      Og API-brukeren har en rolle jeg har rettighet til å fjerne
      Når jeg fjerner rollen
      Så har API-brukeren ikke lenger den valgte rollen
