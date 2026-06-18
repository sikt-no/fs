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

  Scenario: Tilgjengelige miljøer i filter
    Når jeg åpner miljøfilteret
    Så inneholder filteret alle miljøer applikasjonen kan tilordnes tilganger i
    Og hvert miljø vises kun én gang
    Og miljøene er sortert alfabetisk
    Og "Alle miljøer" er valgt som standard

  Scenario: Filtrere tilgangsliste på miljø
    Når jeg velger et miljø som filter
    Så vises kun tilganger i det valgte miljøet

  Scenario: Tilgjengelige organisasjoner i filter
    Når jeg åpner organisasjonsfilteret
    Så inneholder filteret alle organisasjoner som kan gi applikasjonen en tilgang
    Og hver organisasjon vises kun én gang
    Og organisasjonene er sortert alfabetisk
    Og "Alle organisasjoner" er valgt som standard

  Scenario: Filtrere tilgangsliste på organisasjon
    Når jeg velger en organisasjon som filter
    Så vises kun tilganger knyttet til den valgte organisasjonen

  Scenario: Filtrere tilgangsliste på tilgangskode
    Når jeg skriver inn tekst i tilgangskode-filteret
    Så vises kun tilganger der tilgangskoden inneholder den innskrevne teksten

  Scenario: Sortere tilgangsliste
    Når jeg sorterer tilgangslisten på tilgangskode
    Så vises tilgangene i valgt sorteringsrekkefølge

  Scenario: Laste flere tilganger
    Gitt applikasjonen har flere enn 50 tilganger
    Og de 50 første tilgangene er lastet inn
    Når jeg velger å laste inn flere
    Så lastes de neste tilgangene inn i listen

  Regel: Filtrering på tilknytning

    Scenario: Tilgjengelige tilknytninger i filter
      Når jeg åpner tilknytningsfilteret
      Så kan jeg velge mellom følgende tilknytninger:
        | Tilknytning        |
        | Alle tilknytninger |
        | Direkte            |
        | Arvet              |
      Og "Alle tilknytninger" er valgt som standard

    Scenario: Filtrere tilgangsliste på tilknytning
      Når jeg velger en tilknytning som filter
      Så vises kun tilganger med den valgte tilknytningen

    Scenario: Arvet tilgang er merket med opphav
      Gitt applikasjonen har en arvet tilgang
      Så er tilgangen merket som arvet
      Og det fremgår hvilke tilganger arven stammer fra

    Scenario: Arvet tilgang med flere opphav listes kun én gang
      Gitt applikasjonen har to eller flere direkte tilganger som gir den samme arvede tilgangen
      Så vises den arvede tilgangen kun én gang i listen
      Og det fremgår at den arvede tilgangen stammer fra alle de direkte tilgangene
