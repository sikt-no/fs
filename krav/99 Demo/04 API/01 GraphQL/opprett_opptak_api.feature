# language: no
@demo @integration @planned
Egenskap: Opprette opptak via API
  Som system administrator
  Ønsker jeg å opprette opptak via API
  Slik at jeg kan opprette nye opptak med hendelser programmatisk

  @planned @must
  Scenario: Opprette et nytt opptak med hendelser
    Når jeg oppretter et opptak via API
    Så skal opptaket være opprettet uten feil
    Og opptaket skal ha en gyldig ID
    Og opptaket skal ha alle opprettede hendelser
