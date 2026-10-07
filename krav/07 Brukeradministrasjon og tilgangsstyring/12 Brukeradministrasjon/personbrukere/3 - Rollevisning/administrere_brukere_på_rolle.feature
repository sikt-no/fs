# language: no
# GitHub: #492
# Kilde: Brukerhistorie BH6 (temp/brukerhistorier.md)
@BRU-PER-ROL-002 @planned
Egenskap: Administrere brukere på en spesifikk rolle
  Som brukeradministrator
  ønsker jeg å finne fram én spesifikk rolle og kunne legge til eller fjerne brukere på rollen
  slik at jeg kan tildele eller trekke tilbake rollen effektivt fra rolle-siden istedenfor å gå via hver bruker.

  Rollesiden er stedet der brukeradministratoren gir tilgang til en person som ikke finnes i
  løsningen, eller som brukeradministratoren ikke kan se. Det skjer ikke fra brukeroversikten.
  Reglene for selve tildelingen står i BRU-PER-GRU-013. Regelen merket @must er minimum for å
  implementere det.

  Fra rollesiden gis bare rollen på siden. Flere roller gis etterpå fra detaljsiden for personen
  (BRU-PER-GRU-003). Organisasjon og miljø velges på samme måte som når roller tildeles fra
  detaljsiden for en personbruker.

  @draft @openquestion
  Scenario: Legge til en bruker på en rolle
    # ÅPNE SPØRSMÅL:
    # - Skal det være mulig å legge til flere brukere i én batch-operasjon?
    # - Hvilke valideringer kjøres (organisasjonstilhørighet, taushetserklæring, eksisterende konfliktrolle)?
    # - Skal stedkoder og tidsbegrensning settes per bruker, eller arves fra rollen?
    # - Hva skjer hvis rollen er "delt" (BRU-PER-DEL-001) — kan vi legge til brukere fra andre organisasjoner?
    Gitt at brukeradministrator er på rollens oversiktsside
    Når brukeradministrator legger til en bruker
    Så skal rollen være tildelt brukeren
    Og endringen skal være sporbar i både bruker- og rollehistorikk

  @draft @openquestion
  Scenario: Fjerne en bruker fra en rolle
    # ÅPNE SPØRSMÅL:
    # - Skal det være mulig å fjerne flere brukere i én batch-operasjon?
    Gitt at brukeradministrator er på rollens oversiktsside
    Og brukeren har rollen aktivt tildelt
    Når brukeradministrator fjerner brukeren fra rollen
    Så skal rollen ikke lenger være tildelt brukeren
    Og endringen skal være sporbar

  @must
  Regel: Gi rollen til en person med fødselsnummer, D-nummer eller SNR

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
      Og det opprettes ikke en ny person i databasen

    Scenario: Valglisten for organisasjon er begrenset til organisasjoner brukeradministratoren administrerer
      Gitt at brukeradministrator administrerer flere organisasjoner
      Og brukeradministrator er på rollens oversiktsside
      Når brukeradministrator skal gi rollen til en person med fødselsnummer
      Så kan brukeradministrator bare velge organisasjoner brukeradministratoren har brukeradministrator-rollen for

    Scenario: Organisasjonen er gitt når brukeradministratoren administrerer én organisasjon
      Gitt at brukeradministrator administrerer bare én organisasjon
      Og brukeradministrator er på rollens oversiktsside
      Når brukeradministrator gir rollen til en person for et miljø og oppgir fødselsnummeret
      Så har personen rollen i det valgte miljøet for brukeradministratorens organisasjon

    Scenario: Valglisten for miljø er begrenset til miljøer brukeradministratoren administrerer
      Gitt at brukeradministrator er på rollens oversiktsside
      Når brukeradministrator skal gi rollen til en person med fødselsnummer
      Så kan brukeradministrator bare velge miljøer brukeradministratoren har brukeradministrator-rollen i

    Scenario: Bare rollen på siden gis
      Gitt at brukeradministrator er på rollens oversiktsside
      Når brukeradministrator gir rollen til en person for en organisasjon og et miljø og oppgir fødselsnummeret
      Så har personen fått bare denne rollen i operasjonen

    Scenario: Flere roller gis etterpå fra detaljsiden for personen
      Gitt at brukeradministrator har gitt rollen til en person fra rollens oversiktsside
      Når brukeradministrator åpner detaljsiden for personen
      Så kan brukeradministrator tildele personen flere roller der

# ÅPNE SPØRSMÅL:
# - Forholdet til BRU-PER-GRU-003 — overlapper administrasjon fra rolle-siden med tildeling fra
#   bruker-siden? Skal det være konsistent UX? Avklart for regelen merket @must: organisasjon og
#   miljø velges som på detaljsiden. Gjelder fortsatt for å legge til og fjerne andre brukere.
