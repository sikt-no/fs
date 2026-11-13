# language: no
# GitHub: #492
# Kilde: Brukerhistorie BH6 (temp/brukerhistorier.md)
@BRU-PER-ROL-002 @must @in-progress
Egenskap: Administrere brukere på en spesifikk rolle
  Som brukeradministrator
  ønsker jeg å finne fram én spesifikk rolle og kunne legge til eller fjerne brukere på rollen
  slik at jeg kan tildele eller trekke tilbake rollen effektivt fra rolle-siden istedenfor å gå via hver bruker.

  Scenario: Legge til en bruker på en rolle
    Gitt at brukeradministrator er på rollens oversiktsside
    Når brukeradministrator legger til en bruker
    Så skal rollen være tildelt brukeren
    Og endringen skal være sporbar i både bruker- og rollehistorikk

  Scenario: Fjerne en bruker fra en rolle
    Gitt at brukeradministrator er på rollens oversiktsside
    Og brukeren har rollen aktivt tildelt
    Når brukeradministrator fjerner brukeren fra rollen
    Så skal rollen ikke lenger være tildelt brukeren
    Og endringen skal være sporbar

  @ref-BRU-PER-GRU-003 @openquestion
  Regel: En utgått rolle kan ikke gis fra siden for rollen
    # Det samme gjelder i valglisten på personbrukerens side (BRU-PER-GRU-003).
    # ÅPNE SPØRSMÅL:
    # - Skal API-et også avvise at en utgått rolle gis, eller gjelder regelen bare i skjermbildet? (fs-admin MR !3431 skjuler valget, og avvisningen i API-et er varslet i en senere MR)

    Scenario: Siden for en utgått rolle sier at rollen er utgått
      Gitt en forretningsrolle er markert som utgått i rollekatalogen
      Når brukeradministrator åpner rollens oversiktsside
      Så ser brukeradministrator at rollen er utgått
      Og brukeradministrator kan ikke gi rollen til en person

    Scenario: Tildelingene en utgått rolle har, kan fjernes
      Gitt at brukeradministrator er på rollens oversiktsside
      Og rollen er markert som utgått i rollekatalogen
      Og brukeren har rollen aktivt tildelt
      Når brukeradministrator fjerner brukeren fra rollen
      Så skal rollen ikke lenger være tildelt brukeren

# AVKLART 13.11.2026:
# - Brukere legges til og fjernes fra rollen én om gangen, ikke flere i én operasjon.
# - Det kjøres ingen valideringer (organisasjonstilhørighet, taushetserklæring eller konfliktrolle) når en bruker legges til på rollen.
