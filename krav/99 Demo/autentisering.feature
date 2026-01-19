# language: no
Egenskap: Autentisering
  Som en bruker av systemet
  Ønsker jeg å verifisere at autentisering fungerer korrekt
  Slik at jeg kan være sikker på at brukere er riktig innlogget

  @demo @admin-auth-test
  Scenario: FS-Admin bruker er innlogget med overstyrt bruker
    Gitt at jeg er innlogget som FS-Admin
    Når jeg går til FS-Admin
    Så skal jeg se riktig brukernavn
    Og overstyrt bruker skal være korrekt

  @demo @student-auth-test
  Scenario: Student bruker er innlogget med riktig testsøker
    Gitt at jeg er innlogget som Student
    Når jeg går til Min Kompetanse
    Så skal jeg se riktig profil-lenke
    Og valgt testsøker skal være korrekt
