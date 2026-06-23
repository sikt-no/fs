# language: no
# GitHub: #492
# Kilde: Brukerhistorie BH6 (temp/brukerhistorier.md)
@BRU-PER-ROL-002 @draft
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

# ÅPNE SPØRSMÅL:
# - Skal det være mulig å legge til/fjerne flere brukere i én batch-operasjon?
# - Hvilke valideringer kjøres (organisasjonstilhørighet, taushetserklæring, eksisterende konfliktrolle)?
# - Skal stedkoder og tidsbegrensning settes per bruker, eller arves fra rollen?
# - Hva skjer hvis rollen er "delt" (BRU-PER-DEL-001) — kan vi legge til brukere fra andre organisasjoner?
# - Forholdet til BRU-PER-GRU-003 — overlapper administrasjon fra rolle-siden med tildeling fra bruker-siden? Skal det være konsistent UX?
