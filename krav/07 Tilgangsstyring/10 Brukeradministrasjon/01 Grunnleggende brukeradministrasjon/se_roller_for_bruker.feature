# language: no
@TIL-BRU-GRU-002 @must @draft
Egenskap: Se roller for bruker
  Som en brukeradministrator
  ønsker jeg å se hvilke roller en bruker har
  slik at jeg kan vurdere om brukerens tilganger er korrekte.

  Bakgrunn:
    Gitt at brukeradministratoren er logget inn i FS Admin
    Og brukeradministratoren har søkt opp en Feide-bruker

  Regel: Oversikten viser alle roller brukeren har

    Scenario: Bruker med flere roller
      Gitt at brukeren har rollene "Saksbehandler" og "Opptaksmedarbeider"
      Når brukeradministratoren åpner brukerprofilen
      Så vises rollen "Saksbehandler" i rollelisten
      Og rollen "Opptaksmedarbeider" vises i rollelisten

    Scenario: Bruker uten roller
      Gitt at brukeren ikke har noen roller
      Når brukeradministratoren åpner brukerprofilen
      Så vises en melding om at brukeren ikke har noen roller
