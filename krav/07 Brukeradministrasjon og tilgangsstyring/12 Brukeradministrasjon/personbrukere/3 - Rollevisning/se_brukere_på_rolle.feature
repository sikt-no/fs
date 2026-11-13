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

  @must
  Scenario: Åpne en rolle fra rolleoversikten
    Gitt at brukeradministrator er i rolleoversikten
    Når brukeradministrator velger en rolle
    Så åpnes rollens oversiktsside

  @must @openquestion
  Scenario: Rolleoversikten viser bare roller brukeradministratoren har rett til å tildele
    # Retten til å tildele gjelder for en organisasjon og et miljø, ikke for en enkelt rolle
    # (BRU-PER-GRU-013). Den som har retten et sted, kan tildele alle rollene i rollekatalogen.
    # AVKLART 05.11.2026 (Kjetil, fs-admin !3046): Rolleoversikten har ikke filter på
    # organisasjon og miljø.
    # ÅPNE SPØRSMÅL:
    # - Rolleoversikten og valglistene i dialogen «Gi rollen til en person» er ikke begrenset av
    #   delegeringstaket, mens valglisten i «Tildel roller» er det (BRU-PER-GRU-003). En rolle
    #   utenfor delegeringstaket kan derfor gis fra rollesiden, men får ingen effekt der. Skal
    #   rollesiden også begrenses av delegeringstaket, og i så fall hvordan, når rollen er gitt
    #   og organisasjon og miljø velges i dialogen?
    Gitt at brukeradministrator har rett til å tildele i minst én organisasjon og ett miljø
    Når brukeradministrator åpner rolleoversikten
    Så vises rollene i rollekatalogen

  @must
  Scenario: Rolleoversikten er tom uten rett til å tildele
    Gitt at brukeradministrator ikke har rett til å tildele i noen organisasjon
    Når brukeradministrator åpner rolleoversikten
    Så vises ingen roller

  @must
  Scenario: Vise tildelingene av en rolle
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

  @openquestion
  Scenario: Organisasjonsfilteret tilbyr organisasjonene som er synlige i listen
    # ÅPNE SPØRSMÅL:
    # - Organisasjonsfilteret er bygget som miljøfilteret (fs-plattform !6706, 11.11.2026): det
    #   tilbyr organisasjonene til tildelingene brukeradministrator ser, også der hen bare kan
    #   lese. Er det riktig?
    Gitt at tildelingene brukeradministrator ser på rollens oversiktsside, gjelder for to organisasjoner
    Og rollen har også en tildeling for en tredje organisasjon som brukeradministrator ikke kan se
    Når brukeradministrator åpner organisasjonsfilteret på rollens oversiktsside
    Så kan brukeradministrator velge de to organisasjonene
    Men brukeradministrator kan ikke velge den tredje organisasjonen

  @draft @openquestion
  Scenario: Søke på navn i tildelingene
    # ÅPNE SPØRSMÅL:
    # - Søket på navn er bygget i fs-admin !3046 (fra !3210), men verken workshopen 09.–10.11
    #   eller andre avklaringer har tatt stilling til det. Skal det være med?
    # - En person uten kjent navn blir ikke funnet av søket. Er det akseptabelt?
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

  @draft @openquestion
  Scenario: Utgåtte roller vises ikke i rolleoversikten som standard
    # ÅPNE SPØRSMÅL:
    # - fs-admin !3046 skjuler utgåtte roller til brukeradministrator velger å vise dem. Skal
    #   standarden være slik, og trengs valget? (spørsmål 3 i fs-admin !3210)
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
# - Listen viser bare tildelinger til personer (fs-plattform !6706). En Feide-bruker som har
#   rollen, og som ikke har fått tildelingene flyttet til en person (BRU-PER-GRU-014), står ikke
#   i listen. Er det riktig til tildelingene er flyttet?
# - En brukeradministrator som bare kan lese, får en tom rolleoversikt og kommer ikke til rollens
#   oversiktsside derfra, selv om listen og filtrene der viser det hen kan lese. Skal
#   rolleoversikten også vise rollene for den som bare kan lese?
