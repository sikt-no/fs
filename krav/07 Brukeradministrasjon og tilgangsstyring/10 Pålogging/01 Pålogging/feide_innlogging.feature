# language: no
@DEM-INN-FEI-001 @demo @ci @smoke
Egenskap: Feide-innlogging
  Som en bruker av FS-systemene
  ønsker jeg å logge inn med Feide
  slik at jeg får tilgang til mine funksjoner og data.

  Regel: Administrator må kunne logge inn i adminflaten med Feide

    Scenario: Administrator logger inn med Feide
      Gitt at administratoren er på innloggingssiden til adminflaten
      Når administratoren logger inn med Feide testbruker
      Og administratoren velger overstyrt bruker
      Så skal administratoren være innlogget
      Og innloggingstilstanden skal lagres for adminflaten

  Regel: Person må kunne logge inn i MinKompetanse med Feide

    Scenario: Person logger inn med Feide og velger testsøker
      Gitt at personen er på innloggingssiden til MinKompetanse
      Når personen logger inn med Feide testbruker
      Og personen velger en testsøker
      Så skal personen se "Du representerer nå testsøker"
      Og innloggingstilstanden skal lagres for personflaten
