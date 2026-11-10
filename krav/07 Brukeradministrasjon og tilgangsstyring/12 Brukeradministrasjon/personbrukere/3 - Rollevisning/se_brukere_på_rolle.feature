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
  «Aktivt tildelt» betyr at rollen er aktiv nå, enten den er tildelt direkte eller arvet gjennom en
  annen rolle.

  Rollens oversiktsside viser tildelingene av rollen, ikke brukerne: én rad per tildeling. En
  bruker som har rollen for flere organisasjoner eller i flere miljøer, står på én rad for hver
  tildeling.

  @must
  Scenario: Åpne en rolle fra rolleoversikten
    Gitt at brukeradministrator er i rolleoversikten
    Når brukeradministrator velger en rolle
    Så åpnes rollens oversiktsside

  @must
  Scenario: Rolleoversikten viser bare roller brukeradministratoren har rett til å tildele
    Gitt at brukeradministrator har rett til å tildele noen roller, men ikke alle
    Når brukeradministrator åpner rolleoversikten
    Så vises bare rollene brukeradministratoren har rett til å tildele

  @must
  Scenario: Vise tildelingene av en rolle
    Gitt at en rolle er aktivt tildelt flere brukere
    Når brukeradministrator åpner rollens oversiktsside
    Så vises én rad for hver aktive tildeling av rollen til brukere brukeradministratoren ellers kan se
    Og tildelinger der rollen er arvet gjennom en annen rolle, vises også
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

  @draft
  Scenario: Søke fram en rolle
    Gitt at brukeradministrator er i rolleoversikten
    Når brukeradministrator søker på rollenavn
    Så skal matchende roller vises i søkeresultatet

# ÅPNE SPØRSMÅL:
# Scenarioene merket @must viser tildelinger som er aktive nå, direkte eller arvet. Spørsmålene
# under gjelder utvidelser av listen.
# - Skal listen også være filtrerbar på stedkode eller status (aktiv/inaktiv)? Filter på
#   organisasjon og miljø er AVKLART 10.11.2026 (Kjetil), se scenarioene over.
# - Skal man kunne se brukere som har hatt rollen historisk (ikke bare aktive)? Eller skal det gå via BRU-PER-HIS-002?
# - Skal listen kunne eksporteres?
