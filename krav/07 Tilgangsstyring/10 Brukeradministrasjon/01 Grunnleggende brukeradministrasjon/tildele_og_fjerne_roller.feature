# language: no
@TIL-BRU-GRU-003 @must @draft
Egenskap: Tildele og fjerne roller
  Som en brukeradministrator
  ønsker jeg å tildele og fjerne roller hos en Feide-bruker
  slik at brukeren får riktige tilganger til FS-data.

  Bakgrunn:
    Gitt at brukeradministratoren er logget inn i FS Admin
    Og brukeradministratoren har søkt opp en Feide-bruker

  Regel: Brukeradministratoren kan tildele en rolle

    Scenario: Tildele en rolle til bruker
      Når brukeradministratoren tildeler rollen "Saksbehandler" til brukeren
      Så har brukeren rollen "Saksbehandler"

  Regel: Brukeradministratoren kan fjerne en rolle

    Scenario: Fjerne en rolle fra bruker
      Gitt at brukeren har rollen "Saksbehandler"
      Når brukeradministratoren fjerner rollen "Saksbehandler" fra brukeren
      Så har brukeren ikke lenger rollen "Saksbehandler"
