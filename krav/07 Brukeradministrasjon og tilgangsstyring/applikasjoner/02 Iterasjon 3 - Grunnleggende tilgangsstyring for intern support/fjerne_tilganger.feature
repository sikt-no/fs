# language: no
# GitHub: #445, #451
@BRU-APP-API-008 @must @planned
Egenskap: Fjerne tilganger fra en applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å fjerne en tilgang fra en applikasjon
  slik at applikasjonen mister tilgang til data den ikke lenger skal ha.

  # Krav fra Confluence: K7 Fjerne rolle fra API-bruker, K14 Fjerne rolle fra API-bruker (selvbetjening)

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en applikasjon
    Og jeg ser tilgangslisten applikasjonen har

  Regel: Fjerning av tilganger skjer via dialog

    Scenario: Velge tilganger å fjerne
      Når jeg åpner dialogen for å fjerne tilganger
      Og velger organisasjon og miljø
      Så ser jeg en liste over tilganger jeg har rettighet til å fjerne for den valgte kombinasjonen

    Scenario: Bekrefte fjerning av valgte tilganger
      Gitt jeg har valgt organisasjon, miljø og én eller flere tilganger i fjerningsdialogen
      Når jeg bekrefter fjerningen
      Så har applikasjonen ikke lenger de valgte tilgangene for den valgte kombinasjonen av organisasjon og miljø

    Scenario: Avbryte fjerning
      Gitt jeg har åpnet fjerningsdialogen
      Når jeg avbryter
      Så er ingen endringer gjort på applikasjonens tilganger

  Regel: Bruker kan kun fjerne tilganger de har rettighet til å fjerne

    Scenario: Fjerning er ikke tilgjengelig for tilganger uten rettighet
      Gitt applikasjonen har en tilgang jeg ikke har rettighet til å fjerne
      Så er muligheten til å fjerne den tilgangen ikke tilgjengelig

  Regel: Arvede tilganger kan ikke fjernes direkte

    Scenario: Arvet tilgang kan ikke fjernes
      Gitt applikasjonen har en arvet tilgang
      Så er muligheten til å fjerne den arvede tilgangen ikke tilgjengelig

  Regel: Tilganger kan fjernes selv om applikasjonen er deaktivert

    Scenario: Fjerne tilgang fra deaktivert applikasjon
      Gitt applikasjonen er deaktivert
      Og applikasjonen har en tilgang jeg har rettighet til å fjerne
      Når jeg bekrefter fjerningen
      Så har applikasjonen ikke lenger den tilgangen

# ÅPNE SPØRSMÅL:
# - Hvordan skal delvis suksess håndteres når flere tilganger fjernes i én operasjon og bare noen av dem lykkes? Skal de gyldige fjerningene gjennomføres, eller skal hele operasjonen avvises? Spørsmålet henger sammen med det tilsvarende spørsmålet i BRU-APP-API-007.
# - Er fjerning av tilgang sporbar i endringsloggen? BRU-PER-GRU-011 slår fast at hver fjerning er sporbar i historikk, mens BRU-APP-API-016 fortsatt har det som åpent spørsmål hvilke handlinger som skal loggføres.
