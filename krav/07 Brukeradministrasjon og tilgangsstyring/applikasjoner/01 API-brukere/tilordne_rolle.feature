# language: no
@BRU-APP-API-007 @must @planned
Egenskap: Tilordne rolle til API-bruker
  Som intern brukerstøtte
  ønsker jeg å tilordne en rolle til en API-bruker fra en liste over roller jeg har rettigheter til å tildele
  slik at API-brukeren får tilgang til de dataene den trenger.

  # Krav fra Confluence: K6 Tilordne rolle til API-bruker

  Regel: Bruker kan kun tildele roller de selv har rettigheter til å tildele

    Scenario: Tilordne en rolle
      Gitt jeg er på detaljsiden for en API-bruker
      Og jeg ser listen over roller jeg har rettighet til å tildele
      Når jeg tilordner en rolle til API-brukeren
      Så har API-brukeren fått den valgte rollen

    Scenario: Tilordne flere roller
      Gitt jeg er på detaljsiden for en API-bruker
      Når jeg tilordner flere roller til API-brukeren
      Så har API-brukeren fått alle de valgte rollene
