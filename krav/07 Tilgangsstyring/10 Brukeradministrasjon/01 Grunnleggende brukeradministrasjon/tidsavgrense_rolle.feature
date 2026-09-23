# language: no
@TIL-BRU-GRU-006 @must @draft
Egenskap: Tidsavgrense rolle
  Som en brukeradministrator
  ønsker jeg å sette start- og sluttidspunkt for en rolle
  slik at tilgangen automatisk aktiveres og utløper til riktig tid.

  Bakgrunn:
    Gitt at brukeradministratoren er logget inn i FS Admin
    Og brukeradministratoren har søkt opp en Feide-bruker

  Regel: En enkelt rolle kan tidsavgrenses

    Scenario: Sette sluttdato for en rolle
      Gitt at brukeren har rollen "Saksbehandler"
      Når brukeradministratoren setter sluttdato "2026-12-31" for rollen "Saksbehandler"
      Så utløper rollen "Saksbehandler" den "2026-12-31"

    Scenario: Sette startdato for en rolle
      Når brukeradministratoren tildeler rollen "Opptaksmedarbeider" med startdato "2026-10-01"
      Så aktiveres rollen "Opptaksmedarbeider" fra "2026-10-01"

  Regel: Alle roller for en bruker kan tidsavgrenses samlet

    Scenario: Sette sluttdato for alle brukerens roller
      Gitt at brukeren har rollene "Saksbehandler" og "Opptaksmedarbeider"
      Når brukeradministratoren setter sluttdato "2026-12-31" for alle brukerens roller
      Så utløper alle brukerens roller den "2026-12-31"

# ÅPNE SPØRSMÅL:
# - Skal tidsavgrensning kunne settes både på enkeltnivå og samlet for alle roller, eller kun per rolle?
