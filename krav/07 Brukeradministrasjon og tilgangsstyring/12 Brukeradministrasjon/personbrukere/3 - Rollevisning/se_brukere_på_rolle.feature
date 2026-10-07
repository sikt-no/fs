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
  Scenario: Vise brukere som har en aktiv rolle
    Gitt at en rolle er tildelt flere brukere
    Når brukeradministrator åpner rollens oversiktsside
    Så vises brukerne med rollen aktivt tildelt som brukeradministratoren ellers kan se
    Og brukere som har rollen arvet gjennom en annen rolle, vises også

  @must
  Scenario: Brukere brukeradministratoren ellers ikke kan se, vises ikke
    Gitt at rollen er aktivt tildelt en bruker brukeradministratoren ikke kan se i brukeroversikten
    Når brukeradministrator åpner rollens oversiktsside
    Så vises ikke brukeren

  @must
  Scenario: Åpne brukersiden fra rollens oversiktsside
    Gitt at brukeradministrator ser en bruker i listen på rollens oversiktsside
    Når brukeradministrator velger brukeren
    Så åpnes brukersiden for brukeren
    Og brukeradministrator kan tildele brukeren flere roller der

  @draft
  Scenario: Søke fram en rolle
    Gitt at brukeradministrator er i rolleoversikten
    Når brukeradministrator søker på rollenavn
    Så skal matchende roller vises i søkeresultatet

# ÅPNE SPØRSMÅL:
# Scenarioene merket @must viser brukere som har rollen aktiv nå, direkte eller arvet. Spørsmålene under
# gjelder utvidelser av listen.
# - Skal listen være filtrerbar på organisasjon, stedkode, eller status (aktiv/inaktiv)?
# - Skal man kunne se brukere som har hatt rollen historisk (ikke bare aktive)? Eller skal det gå via BRU-PER-HIS-002?
# - Hvilke felt vises per bruker i listen — navn, Feide-ID, organisasjon, tildelt dato? Forslaget
#   står i se_brukere_på_rolle.design.md.
# - Skal listen kunne eksporteres?
