# language: no
@skip @ci
Egenskap: Opplysninger om betalt semesteravgift
  Som administrator trenger jeg raskt å se om en person har betalt semesteravgift for inneværende semester, siden dette ofte er en kritisk betingelse for å få tilgang til utdanning og ulike tjenester ved lærestedet.

  Bakgrunn:
    Gitt at administrator søker opp en person
    Og at administrator får, eller velger, ett treff
    Og at administrator ser person- og kontaktopplysninger i en personprofil

  Scenario: Personen har ikke betalt semesteravgift inneværende termin
    Når "Økologisk Badering" ikke har betalt semesteravgift
    Så ser administrator merknaden "ikke betalt semesteravgift"

  Scenario: Personen har betalt semesteravgift inneværende termin
    Når "Misfornøyd Ambassade" har betalt semesteravgift for inneværende semester
    Så ser administrator merknaden "betalt semesteravgift"

  Scenario: Personen har registrert fritak for betaling av semesteravgift inneværende termin
    Når utvekslingsstudent "Uemosjonell Betaling" har registrert fritak for betaling av semesteravgift
    Så ser administrator merknaden "betalt semesteravgift"