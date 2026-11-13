# language: no
# GitHub: #491
# Kilde: Brukerhistorie BH5 (temp/brukerhistorier.md)
@BRU-PER-ROL-001 @in-progress
Egenskap: Se brukere som har en spesifikk rolle
  Som brukeradministrator
  ønsker jeg å finne fram én spesifikk rolle og se hvilke brukere som har den
  slik at jeg får oversikt over rollens omfang og kan vurdere konsekvens av endringer.

  Scenarioene merket @must er minimum for å kunne gi en person tilgang med fødselsnummer,
  D-nummer eller SNR fra rollesiden (BRU-PER-ROL-002), slik at personen blir synlig for
  brukeradministratoren.
  «Aktivt tildelt» betyr at rollen er aktiv nå, enten den er tildelt direkte, gitt gjennom en
  organisasjonssamling eller arvet gjennom en annen rolle.

  Rollens oversiktsside viser tildelingene av rollen, ikke brukerne: én rad per tildeling. En
  bruker som har rollen for flere organisasjoner eller i flere miljøer, står på én rad for hver
  tildeling.

  En brukeradministrator med bare leserett ser rolleoversikten, rollens oversiktsside, listen og
  filtrene, men kan ikke gi rollen eller fjerne tildelinger (BRU-PER-ROL-002).

  @must
  Scenario: Åpne en rolle fra rolleoversikten
    Gitt at brukeradministrator er i rolleoversikten
    Når brukeradministrator velger en rolle
    Så åpnes rollens oversiktsside

  @must
  Scenario: Rolleoversikten viser bare roller i delegeringstaket
    # AVKLART 05.11.2026 (Kjetil, fs-admin !3046): Rolleoversikten har ikke filter på
    # organisasjon og miljø.
    # AVKLART 13.11.2026 (Kjetil): Rollesiden begrenses av delegeringstaket, som valglisten i
    # «Tildel roller» (BRU-PER-GRU-003).
    Gitt at en rolle ikke er i delegeringstaket til noen applikasjon i organisasjonene og miljøene brukeradministrator administrerer
    Når brukeradministrator åpner rolleoversikten
    Så vises ikke rollen

  @must
  Scenario: Brukeradministrator med bare leserett ser rollene
    # AVKLART 13.11.2026 (Kjetil): En brukeradministrator med bare leserett ser rollene,
    # tildelingene og filtrene, men kan ikke gi rollen eller fjerne tildelinger.
    Gitt at brukeradministrator har bare leserett i brukeradministrasjonen
    Når brukeradministrator åpner rolleoversikten
    Så vises rollene i delegeringstaket
    Og brukeradministrator kan åpne rollens oversiktsside og se tildelingene der

  @must
  Scenario: Vise tildelingene av en rolle
    # AVKLART 13.11.2026 (Kjetil): Listen viser tildelinger til personer. En Feide-bruker som har
    # rollen, står ikke i listen før tildelingene er flyttet til personen (BRU-PER-GRU-014).
    Gitt at en rolle er aktivt tildelt flere brukere
    Når brukeradministrator åpner rollens oversiktsside
    Så vises én rad for hver aktive tildeling av rollen til brukere brukeradministratoren ellers kan se
    Og tildelinger der rollen er arvet gjennom en annen rolle, vises også
    Og tildelinger der rollen er gitt gjennom en organisasjonssamling, vises også
    Og hver rad viser følgende informasjon:
      | felt                     |
      | Navn                     |
      | Gjelder for organisasjon |
      | Miljø                    |

  @must
  Scenario: Brukere brukeradministratoren ellers ikke kan se, vises ikke
    Gitt at rollen er aktivt tildelt en bruker brukeradministratoren ikke kan se i brukeroversikten
    Når brukeradministrator åpner rollens oversiktsside
    Så vises ikke brukeren

  Scenario: Tildelinger i en organisasjon brukeradministratoren ikke administrerer, vises ikke
    # Som BRU-PER-GRU-013, scenarioet «Tildelinger i andre organisasjoner vises ikke».
    Gitt at en bruker har rollen aktivt tildelt for en organisasjon brukeradministrator administrerer
    Og brukeren har rollen aktivt tildelt for en organisasjon brukeradministrator ikke administrerer
    Når brukeradministrator åpner rollens oversiktsside
    Så står brukeren bare på raden for organisasjonen brukeradministrator administrerer

  @in-progress
  Scenario: En bruker med rollen for to organisasjoner står på to rader
    Gitt at en bruker har rollen aktivt tildelt for to organisasjoner brukeradministratoren administrerer
    Når brukeradministrator åpner rollens oversiktsside
    Så står brukeren på to rader, én for hver organisasjon tildelingen gjelder for

  @in-progress
  Scenario: Antallet på rollens oversiktsside teller tildelinger
    Gitt at rollen bare er tildelt én bruker
    Og brukeren har rollen aktivt tildelt for to organisasjoner brukeradministratoren administrerer
    Når brukeradministrator åpner rollens oversiktsside
    Så viser rollens oversiktsside 2 som antall treff

  @in-progress
  Scenario: Filtrere tildelingene på organisasjon
    Gitt at brukeradministrator er på rollens oversiktsside
    Når brukeradministrator velger en organisasjon i organisasjonsfilteret
    Så vises bare tildelingene som gjelder for den valgte organisasjonen

  @in-progress
  Scenario: Filtrere tildelingene på miljø uten å velge organisasjon
    Gitt at brukeradministrator er på rollens oversiktsside
    Og brukeradministrator har ikke valgt noen organisasjon i organisasjonsfilteret
    Når brukeradministrator velger et miljø i miljøfilteret
    Så vises bare tildelingene i det valgte miljøet

  @in-progress
  Scenario: Miljøfilteret tilbyr miljøene som er synlige i listen
    # AVKLART 10.11.2026 (Kjetil): Miljøfilteret tilbyr alle miljøene som er synlige i listen, ikke
    # alle miljøene rollen har tildelinger i.
    Gitt at tildelingene brukeradministrator ser på rollens oversiktsside, gjelder i miljøene test og review
    Og rollen har også en tildeling i miljøet production som brukeradministrator ikke kan se
    Når brukeradministrator åpner miljøfilteret på rollens oversiktsside
    Så kan brukeradministrator velge test og review
    Men brukeradministrator kan ikke velge production

  Scenario: Organisasjonsfilteret tilbyr organisasjonene som er synlige i listen
    # AVKLART 13.11.2026 (Kjetil): Organisasjonsfilteret er som miljøfilteret, også for den som
    # bare kan lese.
    Gitt at tildelingene brukeradministrator ser på rollens oversiktsside, gjelder for to organisasjoner
    Og rollen har også en tildeling for en tredje organisasjon som brukeradministrator ikke kan se
    Når brukeradministrator åpner organisasjonsfilteret på rollens oversiktsside
    Så kan brukeradministrator velge de to organisasjonene
    Men brukeradministrator kan ikke velge den tredje organisasjonen

  Scenario: Søke på navn i tildelingene
    # AVKLART 13.11.2026 (Kjetil): Søket på navn beholdes.
    Gitt at brukeradministrator er på rollens oversiktsside
    Når brukeradministrator søker på en del av navnet til en bruker
    Så vises bare tildelingene til brukere der navnet inneholder søketeksten

  @draft @openquestion
  Scenario: Søke fram en rolle
    # ÅPNE SPØRSMÅL:
    # - Søket er bygget i fs-admin !3046 (fra !3210) og treffer både rollekoden og beskrivelsen.
    #   Er det riktig, så @draft kan fjernes?
    Gitt at brukeradministrator er i rolleoversikten
    Når brukeradministrator søker på en del av rollekoden eller beskrivelsen
    Så vises bare rollene der rollekoden eller beskrivelsen inneholder søketeksten

  Scenario: Utgåtte roller vises ikke i rolleoversikten som standard
    # AVKLART 13.11.2026 (Kjetil): Utgåtte roller er skjult som standard, og valget om å vise dem
    # beholdes. En utgått rolle kan ses, men ikke gis (BRU-PER-ROL-002, BRU-PER-GRU-003).
    Gitt at en rolle er utgått
    Når brukeradministrator åpner rolleoversikten
    Så vises ikke den utgåtte rollen

  Scenario: En utgått rolle er merket når utgåtte roller vises
    # AVKLART 05.11.2026 (Kjetil, fs-admin !3046): Utgåtte roller merkes.
    Gitt at en rolle er utgått
    Og brukeradministrator har valgt å vise utgåtte roller i rolleoversikten
    Når brukeradministrator ser rolleoversikten
    Så er den utgåtte rollen merket som utgått

# ÅPNE SPØRSMÅL:
# Scenarioene merket @must viser tildelinger som er aktive nå, direkte eller arvet. Spørsmålene
# under gjelder utvidelser av listen.
# - Skal listen også være filtrerbar på stedkode eller status (aktiv/inaktiv)? Filter på
#   organisasjon og miljø er AVKLART 10.11.2026 (Kjetil), se scenarioene over.
# - Skal man kunne se brukere som har hatt rollen historisk (ikke bare aktive)? Eller skal det gå via BRU-PER-HIS-002?
# - Skal listen kunne eksporteres?
