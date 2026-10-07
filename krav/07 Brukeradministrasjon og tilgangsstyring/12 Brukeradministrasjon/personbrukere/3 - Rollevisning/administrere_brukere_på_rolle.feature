# language: no
# GitHub: #492
# Kilde: Brukerhistorie BH6 (temp/brukerhistorier.md)
@BRU-PER-ROL-002 @draft
Egenskap: Administrere brukere på en spesifikk rolle
  Som brukeradministrator
  ønsker jeg å finne fram én spesifikk rolle og kunne legge til eller fjerne brukere på rollen
  slik at jeg kan tildele eller trekke tilbake rollen effektivt fra rolle-siden istedenfor å gå via hver bruker.

  Rollesiden er stedet der brukeradministratoren gir tilgang til en person som ikke finnes i
  løsningen, eller som brukeradministratoren ikke kan se. Det skjer ikke fra brukeroversikten.
  Reglene for selve tildelingen står i BRU-PER-GRU-013. Regelen merket @must er minimum for å
  implementere det.

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

  @must @openquestion
  Regel: Gi rollen til en person med fødselsnummer, D-nummer eller SNR
    # ÅPNE SPØRSMÅL:
    # - Hvordan velger brukeradministratoren organisasjon og miljø for tildelingen på rollesiden?
    # - Workshopen besluttet at flere roller kan gis i samme operasjon (BRU-PER-GRU-013). Gjelder
    #   det også her, der operasjonen starter fra én rolle?

    Scenario: Personen finnes ikke i løsningen
      Gitt at brukeradministrator er på rollens oversiktsside
      Og det finnes ingen person med fødselsnummeret i løsningen
      Når brukeradministrator gir rollen til personen for en organisasjon og et miljø og oppgir fødselsnummeret
      Så har personen rollen for organisasjonen og miljøet
      Og brukeradministrator ser personen på rollens oversiktsside
      Og brukeradministrator ser personen i brukeroversikten

    Scenario: Personen finnes, men brukeradministratoren ser hen ikke
      Gitt at brukeradministrator er på rollens oversiktsside
      Og personen har tildelinger bare i organisasjoner brukeradministratoren ikke administrerer
      Når brukeradministrator gir rollen til personen for en organisasjon og et miljø og oppgir fødselsnummeret
      Så har personen rollen for organisasjonen og miljøet
      Og brukeradministrator ser personen på rollens oversiktsside
      Og brukeradministrator ser personen i brukeroversikten
      Og det opprettes ikke en ny person

# ÅPNE SPØRSMÅL:
# - Skal det være mulig å legge til/fjerne flere brukere i én batch-operasjon?
# - Hvilke valideringer kjøres (organisasjonstilhørighet, taushetserklæring, eksisterende konfliktrolle)?
# - Skal stedkoder og tidsbegrensning settes per bruker, eller arves fra rollen?
# - Hva skjer hvis rollen er "delt" (BRU-PER-DEL-001) — kan vi legge til brukere fra andre organisasjoner?
# - Forholdet til BRU-PER-GRU-003 — overlapper administrasjon fra rolle-siden med tildeling fra bruker-siden? Skal det være konsistent UX?
