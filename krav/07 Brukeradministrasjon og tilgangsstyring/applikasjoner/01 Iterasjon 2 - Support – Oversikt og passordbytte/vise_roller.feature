# language: no
# GitHub: #440
@BRU-APP-API-003 @must @planned
Egenskap: Vise roller for API-bruker
  Som bruker
  ønsker jeg å se hvilke roller en API-bruker har
  slik at jeg forstår hvilke rettigheter og miljøtilgang API-brukeren er tildelt.

  # Krav fra Confluence: K4 Se roller for API-bruker

  Bakgrunn:
    Gitt jeg er på detaljsiden for en API-bruker
    Og jeg har åpnet tab-en for roller

  Scenario: Se roller for en API-bruker
    Så ser jeg en liste over alle roller tilknyttet API-brukeren
    Og hvert innslag viser rollekode og miljøet rollen gjelder for

  Scenario: Filtrere rolleliste på miljø
    Når jeg filtrerer rollelisten på miljø
    Så vises kun roller i de valgte miljøene
    Og filtervalget er begrenset til miljøer API-brukeren har roller i

  Scenario: Filtrere rolleliste på rolle
    Når jeg filtrerer rollelisten på rolle
    Så vises kun de valgte rollene
    Og filtervalget er begrenset til roller API-brukeren er tildelt

  Scenario: Sortere rolleliste
    Når jeg sorterer rollelisten på miljø eller rollekode
    Så vises rollene i valgt sorteringsrekkefølge

  Scenario: Laste flere roller
    Gitt API-brukeren har flere enn 50 roller
    Og de 50 første rollene er lastet inn
    Når jeg velger å laste inn flere
    Så lastes de neste rollene inn i listen
