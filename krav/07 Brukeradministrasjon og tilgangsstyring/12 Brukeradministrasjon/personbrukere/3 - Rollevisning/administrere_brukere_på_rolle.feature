# language: no
# GitHub: #492
# Kilde: Brukerhistorie BH6 (temp/brukerhistorier.md)
@BRU-PER-ROL-002 @must @in-progress
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

  Scenario: «Fjern tildeling» vises bare der brukeradministratoren har rett til å tildele
    # AVKLART 13.11.2026 (Kjetil): «Fjern tildeling» vises bare når brukeradministratoren har rett
    # til å tildele i både organisasjonen og miljøet på raden.
    Gitt at en bruker har rollen tildelt direkte for en organisasjon og et miljø
    Og brukeradministrator har rett til å tildele i organisasjonen, men ikke i miljøet
    Når brukeradministrator ser raden for tildelingen på rollens oversiktsside
    Så har raden ikke «Fjern tildeling»

  Scenario: Brukeradministrator med bare leserett kan ikke gi eller fjerne
    # AVKLART 13.11.2026 (Kjetil): En brukeradministrator med bare leserett ser rollesiden, men kan
    # ikke gi rollen eller fjerne tildelinger.
    Gitt at brukeradministrator har bare leserett i brukeradministrasjonen
    Når brukeradministrator åpner rollens oversiktsside
    Så kan brukeradministrator ikke gi rollen til en person
    Og ingen rader har «Fjern tildeling»

  @must
  Regel: Gi rollen til en person med fødselsnummer, D-nummer eller SNR
    # AVKLART 13.11.2026 (Kjetil): Valgene for organisasjon og miljø er begrenset av
    # delegeringstaket, som valglisten i «Tildel roller» (BRU-PER-GRU-003). En utgått rolle kan
    # aldri gis, heller ikke fra rollesiden, men den kan ses (regelen «En utgått rolle kan ikke gis
    # fra siden for rollen»).

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

    Scenario: Organisasjon og miljø kan bare velges der rollen er i delegeringstaket
      Gitt at brukeradministrator er på rollens oversiktsside
      Og rollen er ikke i delegeringstaket til noen applikasjon for en organisasjon og et miljø brukeradministrator administrerer
      Når brukeradministrator skal gi rollen til en person med fødselsnummer
      Så kan brukeradministrator ikke velge den organisasjonen og det miljøet sammen

    Scenario: Bare rollen på siden gis
      Gitt at brukeradministrator er på rollens oversiktsside
      Når brukeradministrator gir rollen til en person for en organisasjon og et miljø og oppgir fødselsnummeret
      Så har personen fått bare denne rollen i operasjonen

    Scenario: Flere roller gis etterpå fra detaljsiden for personen
      Gitt at brukeradministrator har gitt rollen til en person fra rollens oversiktsside
      Når brukeradministrator åpner detaljsiden for personen
      Så kan brukeradministrator tildele personen flere roller der

  @in-progress
  Regel: Rader med arvet rolle har ikke «Fjern tildeling»
    En arvet rolle fjernes der den er gitt: ved å fjerne rollen den arves gjennom.
    # AVKLART 10.11.2026 (Kjetil): En rad der rollen er arvet gjennom en annen rolle, har ikke
    # «Fjern tildeling».

    Scenario: En rad med arvet rolle har ikke «Fjern tildeling»
      Gitt at en bruker har rollen arvet gjennom en annen rolle for en organisasjon og et miljø
      Når brukeradministrator ser raden for tildelingen på rollens oversiktsside
      Så har raden ikke «Fjern tildeling»

  @in-progress
  Regel: Rader med rolle gitt gjennom en organisasjonssamling har ikke «Fjern tildeling»
    En tildeling gitt gjennom en organisasjonssamling trekkes tilbake for hele samlingen, der den
    er gitt, ikke for én organisasjon fra rollesiden.
    # AVKLART 10.11.2026 (Kjetil): En rad der rollen er gitt gjennom en organisasjonssamling, har
    # ikke «Fjern tildeling».

    Scenario: En rad med rolle gitt gjennom en organisasjonssamling har ikke «Fjern tildeling»
      Gitt at en bruker har rollen gjennom en organisasjonssamling som organisasjonen er med i
      Når brukeradministrator ser raden for tildelingen på rollens oversiktsside
      Så har raden ikke «Fjern tildeling»

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

  @ref-BRU-PER-GRU-003 @openquestion
  Regel: En utgått rolle kan ikke gis fra siden for rollen
    # Det samme gjelder i valglisten på personbrukerens side (BRU-PER-GRU-003).
    # AVKLART 13.11.2026 (Kjetil): En utgått rolle kan aldri gis, heller ikke fra rollesiden, men
    # den kan ses: rollens oversiktsside og tildelingene vises som for andre roller.
    # ÅPNE SPØRSMÅL:
    # - Skal API-et også avvise at en utgått rolle gis, eller gjelder regelen bare i skjermbildet? (fs-admin MR !3431 skjuler valget, og avvisningen i API-et er varslet i en senere MR)

    Scenario: Siden for en utgått rolle sier at rollen er utgått
      Gitt en forretningsrolle er markert som utgått i rollekatalogen
      Når brukeradministrator åpner rollens oversiktsside
      Så ser brukeradministrator at rollen er utgått
      Og brukeradministrator kan ikke gi rollen til en person
      Men brukeradministrator ser tildelingene av rollen

    Scenario: Tildelingene en utgått rolle har, kan fjernes
      Gitt at brukeradministrator er på rollens oversiktsside
      Og rollen er markert som utgått i rollekatalogen
      Og brukeren har rollen aktivt tildelt
      Når brukeradministrator fjerner brukeren fra rollen
      Så skal rollen ikke lenger være tildelt brukeren

# AVKLART 13.11.2026:
# - Brukere legges til og fjernes fra rollen én om gangen, ikke flere i én operasjon.
# - Det kjøres ingen valideringer (organisasjonstilhørighet, taushetserklæring eller konfliktrolle) når en bruker legges til på rollen.
