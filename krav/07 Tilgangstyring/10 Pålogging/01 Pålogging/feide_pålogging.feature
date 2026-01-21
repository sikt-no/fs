# language: no
@TIL-PÅL-PÅL-001 @opptakspilot @focus @ci @opplysning
Egenskap: Feide
Brukere skal kunne logge på med feide i alle nye brukerflater

  @opptakspilotkritisk
  Scenario: Administrator logger på med feide
    Gitt administratoren er på hovedsiden til adminflaten
    Når administratoren velger å logge inn med feide
    Så skal administratoren være innlogget med feide

  @opptakspilotkritisk
  Scenario: Person logger på med feide
    Gitt personen er på hovedsiden til personflaten
    Og personen velger å logge inn med feide
    Så skal personen være innlogget med feide
