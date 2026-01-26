# language: no
@GJE-STU-STA-001 @studieadministrasjon
Egenskap: Registrert inneværende semester
  Som administrator trenger jeg raskt å se om en person har registrert seg for inneværende periode, siden dette ofte er en kritisk betingelse for å få tilgang til utdanning og ulike tjenester ved lærestedet.

  Bakgrunn:
    Gitt at administrator søker opp en person
    Og at administrator får, eller velger, ett treff
    Og at administrator ser person- og kontaktopplysninger i en personprofil

  Scenario: Personen er ikke registrert
    Når "Kranglete Artisjokk" ikke har registrert seg for inneværende semester
    Så ser administrator merknaden "ikke registrert"

  Scenario: Personen er registrert
    Når "Misfornøyd Ambassade" har registrert seg for inneværende semester
    Så ser administrator merknaden "registrert"