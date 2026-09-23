# language: no
@TIL-BRU-GRU-004 @must @draft
Egenskap: Deaktivere og aktivere bruker
  Som en brukeradministrator
  ønsker jeg å deaktivere en Feide-brukers samlede roller
  slik at brukeren ikke har tilgang til FS-data, og jeg kan reaktivere dem ved behov.

  Bakgrunn:
    Gitt at brukeradministratoren er logget inn i FS Admin
    Og brukeradministratoren har søkt opp en Feide-bruker

  Regel: Deaktivering fjerner all tilgang uten å slette rollene

    Scenario: Deaktivere en bruker
      Gitt at brukeren har rollene "Saksbehandler" og "Opptaksmedarbeider"
      Når brukeradministratoren deaktiverer brukeren
      Så har brukeren ikke tilgang til FS-data
      Og brukerens roller er bevart men inaktive

  Regel: Reaktivering gjenoppretter tilgang

    Scenario: Reaktivere en deaktivert bruker
      Gitt at brukeren er deaktivert
      Og brukeren hadde rollene "Saksbehandler" og "Opptaksmedarbeider"
      Når brukeradministratoren reaktiverer brukeren
      Så har brukeren igjen tilgang til FS-data
      Og rollene "Saksbehandler" og "Opptaksmedarbeider" er aktive
