# language: no
# GitHub: #440
@BRU-APP-API-003 @must @planned
Egenskap: Vise tilganger for applikasjon
  Som bruker
  ønsker jeg å se hvilke tilganger en applikasjon har
  slik at jeg forstår hvilke rettigheter og miljøtilgang applikasjonen er tildelt.

  # Krav fra Confluence: K4 Se roller for API-bruker

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon
    Og jeg har åpnet tab-en for tilganger

  Scenario: Se tilganger for en applikasjon
    Så ser jeg en liste over alle tilganger applikasjonen har
    Og hvert innslag viser tilgangskode, beskrivelse, organisasjon og miljøet tilgangen gjelder for

  Scenario: Filtrere tilgangsliste på miljø
    Når jeg filtrerer tilgangslisten på miljø
    Så vises kun tilganger i de valgte miljøene
    Og filtervalget er begrenset til miljøer applikasjonen har tilganger i

  Scenario: Filtrere tilgangsliste på organisasjon
    Når jeg filtrerer tilgangslisten på organisasjon
    Så vises kun tilganger knyttet til den valgte organisasjonen
    Og filtervalget er begrenset til organisasjoner applikasjonen har tilganger hos

  Scenario: Filtrere tilgangsliste på tilgang
    Når jeg filtrerer tilgangslisten på tilgang
    Så vises kun de valgte tilgangene
    Og filtervalget er begrenset til tilganger applikasjonen er tildelt

  Scenario: Sortere tilgangsliste
    Når jeg sorterer tilgangslisten på miljø eller tilgangskode
    Så vises tilgangene i valgt sorteringsrekkefølge

  Scenario: Laste flere tilganger
    Gitt applikasjonen har flere enn 50 tilganger
    Og de 50 første tilgangene er lastet inn
    Når jeg velger å laste inn flere
    Så lastes de neste tilgangene inn i listen

  Regel: Arvede tilganger kan skjules fra listen

    Scenario: Arvet tilgang er merket med opphav
      Gitt applikasjonen har en arvet tilgang
      Så er tilgangen merket som arvet
      Og det fremgår hvilken tilgang arven stammer fra

    Scenario: Skjule arvede tilganger
      Gitt arvede tilganger vises
      Når jeg skjuler arvede tilganger
      Så vises kun direkte tildelte tilganger i listen

    Scenario: Vise arvede tilganger
      Gitt arvede tilganger er skjult
      Når jeg velger å vise arvede tilganger
      Så vises alle tilganger i listen, inkludert arvede
