# language: no
@BRU-APP-API-008 @must @planned
Egenskap: Fjerne rolle fra API-bruker
  Som intern brukerstøtte
  ønsker jeg å fjerne en rolle fra en API-bruker
  slik at API-brukeren mister tilgang til data den ikke lenger skal ha.

  # Krav fra Confluence: K7 Fjerne rolle fra API-bruker

  Regel: Bruker kan kun fjerne roller de har rettigheter til å fjerne

    Scenario: Fjerne en rolle
      Gitt jeg er på detaljsiden for en API-bruker
      Og API-brukeren har en rolle jeg har rettighet til å fjerne
      Når jeg fjerner rollen
      Så har API-brukeren ikke lenger den valgte rollen
