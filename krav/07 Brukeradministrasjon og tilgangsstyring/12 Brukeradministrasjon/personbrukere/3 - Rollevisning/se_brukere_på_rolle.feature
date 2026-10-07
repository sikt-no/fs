# language: no
# GitHub: #491
# Kilde: Brukerhistorie BH5 (temp/brukerhistorier.md)
@BRU-PER-ROL-001 @draft
Egenskap: Se brukere som har en spesifikk rolle
  Som brukeradministrator
  ønsker jeg å finne fram én spesifikk rolle og se hvilke brukere som har den
  slik at jeg får oversikt over rollens omfang og kan vurdere konsekvens av endringer.

  Scenarioene merket @must er minimum for å kunne gi en person tilgang med fødselsnummer,
  D-nummer eller SNR fra rollesiden (BRU-PER-ROL-002), slik at personen blir synlig for
  brukeradministratoren.

  @must @openquestion
  Scenario: Åpne en rolle fra rolleoversikten
    # ÅPNE SPØRSMÅL:
    # - Hvilke roller vises i rolleoversikten: alle roller, eller bare rollene brukeradministratoren
    #   har rett til å tildele?
    Gitt at brukeradministrator er i rolleoversikten
    Når brukeradministrator velger en rolle
    Så åpnes rollens oversiktsside

  @must @openquestion
  Scenario: Vise brukere som har en aktiv rolle
    # ÅPNE SPØRSMÅL:
    # - Vises bare brukerne brukeradministratoren ellers kan se, det vil si brukere med en aktiv
    #   tildeling av rollen i en organisasjon og et miljø brukeradministratoren administrerer?
    Gitt at en rolle er tildelt flere brukere
    Når brukeradministrator åpner rollens oversiktsside
    Så skal alle brukere med rollen aktivt tildelt vises

  Scenario: Søke fram en rolle
    Gitt at brukeradministrator er i rolleoversikten
    Når brukeradministrator søker på rollenavn
    Så skal matchende roller vises i søkeresultatet

# ÅPNE SPØRSMÅL:
# - Skal man kunne se brukere som har rollen indirekte (via en sammensatt rolle), eller bare direkte tildelte?
# - Skal listen være filtrerbar på organisasjon, stedkode, eller status (aktiv/inaktiv)?
# - Skal man kunne se brukere som har hatt rollen historisk (ikke bare aktive)? Eller skal det gå via BRU-PER-HIS-002?
# - Hvilke felt vises per bruker i listen — navn, Feide-ID, organisasjon, tildelt dato?
# - Skal listen kunne eksporteres?
