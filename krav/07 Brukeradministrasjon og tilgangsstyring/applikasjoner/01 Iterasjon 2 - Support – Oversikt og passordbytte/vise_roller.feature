# language: no
# GitHub: #440
@BRU-APP-API-003 @must @planned
Egenskap: Vise roller for applikasjon
  Som bruker
  ønsker jeg å se hvilke roller en applikasjon har
  slik at jeg forstår hvilke rettigheter og miljøtilgang applikasjonen er tildelt.

  # Krav fra Confluence: K4 Se roller for API-bruker

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon
    Og jeg har åpnet tab-en for roller

  Scenario: Se roller for en applikasjon
    Så ser jeg en liste over alle roller tilknyttet applikasjonen
    Og hvert innslag viser rollekode og miljøet rollen gjelder for

  Scenario: Filtrere rolleliste på miljø
    Når jeg filtrerer rollelisten på miljø
    Så vises kun roller i de valgte miljøene
    Og filtervalget er begrenset til miljøer applikasjonen har roller i

  Scenario: Filtrere rolleliste på rolle
    Når jeg filtrerer rollelisten på rolle
    Så vises kun de valgte rollene
    Og filtervalget er begrenset til roller applikasjonen er tildelt

  Scenario: Sortere rolleliste
    Når jeg sorterer rollelisten på miljø eller rollekode
    Så vises rollene i valgt sorteringsrekkefølge

  Scenario: Laste flere roller
    Gitt applikasjonen har flere enn 50 roller
    Og de 50 første rollene er lastet inn
    Når jeg velger å laste inn flere
    Så lastes de neste rollene inn i listen
