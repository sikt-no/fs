# language: no
# GitHub: #445, #451
@BRU-APP-API-008 @must @planned
Egenskap: Fjerne tilgang fra applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å fjerne en tilgang fra en applikasjon
  slik at applikasjonen mister tilgang til data den ikke lenger skal ha.

  # Krav fra Confluence: K7 Fjerne rolle fra API-bruker, K14 Fjerne rolle fra API-bruker (selvbetjening)

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon
    Og jeg ser tilgangslisten applikasjonen har

  Regel: Fjerning av tilganger skjer via modal

    Scenario: Velge tilganger å fjerne
      Når jeg åpner modalen for å fjerne tilganger
      Og velger organisasjon og miljø
      Så ser jeg en liste over tilganger jeg har rettighet til å fjerne for den valgte kombinasjonen

    Scenario: Bekrefte fjerning av valgte tilganger
      Gitt jeg har valgt organisasjon, miljø og én eller flere tilganger i fjerningsmodalen
      Når jeg bekrefter fjerningen
      Så har applikasjonen ikke lenger de valgte tilgangene for den valgte kombinasjonen av organisasjon og miljø

    Scenario: Avbryte fjerning
      Gitt jeg har åpnet fjerningsmodalen
      Når jeg avbryter
      Så er ingen endringer gjort på applikasjonens tilganger

  Regel: Bruker kan kun fjerne tilganger de har rettighet til å fjerne

    Scenario: Fjerning er ikke tilgjengelig for tilganger uten rettighet
      Gitt applikasjonen har en tilgang jeg ikke har rettighet til å fjerne
      Så er muligheten til å fjerne den tilgangen ikke tilgjengelig

  Regel: Tilganger kan fjernes selv om applikasjonen er deaktivert

    Scenario: Fjerne tilgang fra deaktivert applikasjon
      Gitt applikasjonen er deaktivert
      Og applikasjonen har en tilgang jeg har rettighet til å fjerne
      Når jeg bekrefter fjerningen
      Så har applikasjonen ikke lenger den tilgangen

  Regel: Arvede tilganger kan ikke fjernes direkte

    Scenario: Arvet tilgang kan ikke fjernes
      Gitt applikasjonen har en arvet tilgang
      Så er muligheten til å fjerne den arvede tilgangen ikke tilgjengelig
