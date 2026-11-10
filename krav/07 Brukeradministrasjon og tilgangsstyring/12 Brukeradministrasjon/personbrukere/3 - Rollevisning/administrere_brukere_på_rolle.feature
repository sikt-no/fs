# language: no
# GitHub: #492
# Kilde: Brukerhistorie BH6 (temp/brukerhistorier.md)
@BRU-PER-ROL-002 @in-progress
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

  @in-progress
  Scenario: Fjerne en tildeling fra rollens oversiktsside
    # AVKLART 10.11.2026 (Kjetil): Rollen gis og fjernes for én person om gangen. Å gi eller fjerne
    # for flere i én operasjon kommer i et senere krav.
    Gitt at brukeradministrator er på rollens oversiktsside
    Og en bruker har rollen aktivt tildelt for en organisasjon og et miljø
    Når brukeradministrator velger «Fjern tildeling» på raden for tildelingen
    Så er rollen ikke lenger tildelt brukeren for organisasjonen og miljøet
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

  @in-progress
  Regel: Rader med arvet rolle har også «Fjern tildeling»
    # AVKLART 10.11.2026 (Kjetil): Også en rad der rollen er arvet gjennom en annen rolle, har
    # «Fjern tildeling».

    Scenario: En rad med arvet rolle har «Fjern tildeling»
      Gitt at en bruker har rollen arvet gjennom en annen rolle for en organisasjon og et miljø
      Når brukeradministrator ser raden for tildelingen på rollens oversiktsside
      Så har raden «Fjern tildeling»

  @in-progress @depends-on-BRU-PER-GRU-005 @depends-on-BRU-PER-GRU-006
  Regel: Stedkoder og tidsbegrensning settes alltid per bruker
    # AVKLART 10.11.2026 (Kjetil): Alt settes alltid per bruker. Rollen har ingen stedkoder eller
    # tidsbegrensning som brukerne arver.

    Scenario: Rollen gis fra rollesiden uten stedkoder og tidsbegrensning
      Gitt at brukeradministrator er på rollens oversiktsside
      Når brukeradministrator gir rollen til en person for en organisasjon og et miljø og oppgir fødselsnummeret
      Så settes verken stedkoder eller tidsbegrensning for tildelingen i operasjonen

    Scenario: Stedkoder og tidsbegrensning settes på detaljsiden for personen
      Gitt at brukeradministrator har gitt rollen til en person fra rollens oversiktsside
      Når brukeradministrator åpner detaljsiden for personen
      Så kan brukeradministrator sette stedkoder og tidsbegrensning for tildelingen der
