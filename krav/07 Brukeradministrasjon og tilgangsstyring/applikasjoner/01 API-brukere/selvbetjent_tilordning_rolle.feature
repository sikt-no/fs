# language: no
@BRU-APP-API-013 @must @planned
Egenskap: Selvbetjent tilordning av rolle
  Som brukeradministrator på lærested
  ønsker jeg å tilordne en rolle til en API-bruker fra en liste over roller jeg har rettigheter til å tildele.

  # Krav fra Confluence: K13 Tilordne rolle til API-bruker (selvbetjening)

  Regel: Brukeradministrator kan kun tildele roller de har rettigheter til

    Scenario: Tilordne rolle som brukeradministrator
      Gitt jeg er innlogget som brukeradministrator på lærested
      Og jeg er på detaljsiden for en API-bruker
      Når jeg tilordner en rolle fra listen over tilgjengelige roller
      Så har API-brukeren fått den valgte rollen
