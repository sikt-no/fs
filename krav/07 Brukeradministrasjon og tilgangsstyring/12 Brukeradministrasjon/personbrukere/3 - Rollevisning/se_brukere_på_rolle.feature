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

  @must
  Scenario: Brukere brukeradministratoren ellers ikke kan se, vises ikke
    Gitt at rollen er aktivt tildelt en bruker brukeradministratoren ikke kan se i brukeroversikten
    Når brukeradministrator åpner rollens oversiktsside
    Så vises ikke brukeren

  @draft
  Scenario: Søke fram en rolle
    Gitt at brukeradministrator er i rolleoversikten
    Når brukeradministrator søker på rollenavn
    Så skal matchende roller vises i søkeresultatet

# ÅPNE SPØRSMÅL:
# Scenarioene merket @must viser brukere med rollen direkte og aktivt tildelt. Spørsmålene under
# gjelder utvidelser av listen.
# - Skal man kunne se brukere som har rollen indirekte (via en sammensatt rolle), eller bare direkte tildelte?
# - Skal listen være filtrerbar på organisasjon, stedkode, eller status (aktiv/inaktiv)?
# - Skal man kunne se brukere som har hatt rollen historisk (ikke bare aktive)? Eller skal det gå via BRU-PER-HIS-002?
# - Hvilke felt vises per bruker i listen — navn, Feide-ID, organisasjon, tildelt dato? Forslaget
#   står i se_brukere_på_rolle.design.md.
# - Skal listen kunne eksporteres?
