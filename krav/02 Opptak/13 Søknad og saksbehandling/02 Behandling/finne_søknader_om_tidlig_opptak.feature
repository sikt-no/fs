# language: no
# GitHub: #456
#
# KILDER
#
# Del av initiativet #456 Behandle søknader om tidlig opptak. Behovet kom fra
# kravgjennomgangen 08.10.2026: saksbehandleren må finne sakene der søkeren har
# søkt om tidlig opptak, for å vurdere dem i tide.
#
# Vurderingen og konklusjonen står i vurdere_søknad_om_tidlig_opptak.feature
# (OPT-BEH-BEH-013). Hva søkeren gjør, står i søke_om_tidlig_opptak.feature
# (OPT-SØK-SØK-011).
#
# Det finnes ikke noe krav for selve sakslisten i saksbehandlingen ennå. Dette
# kravet beskriver bare filtrene for tidlig opptak. Sakslisten får ingen egen
# kolonne for tidlig opptak (avklart 08.10.2026). Kolonnene hører hjemme i et
# eget krav for sakslisten.
#
# AVKLART 09.10.2026 (review av PR #654)
#
# - Kravet beskriver hva saksbehandleren kan filtrere på, ikke hvordan filtrene
#   ser ut eller hva de heter. Det hører hjemme i implementasjonsdetaljene.
# - Det er to egenskaper som kan filtreres hver for seg og kombineres med de
#   andre filtrene i sakslisten: om søkeren har søkt om tidlig opptak, og
#   konklusjonen for tidlig opptak. Ingen av filtrene tar med andre betingelser
#   i det skjulte.
# - Dette erstatter filteret «Tidlig opptak ikke ferdig behandlet» (08.10.2026),
#   som kombinerte søkt, konklusjon og ferdig behandlet i ett valg.
#
# Koden (fs-plattform main, 07.10.2026) har ikke filtre for tidlig opptak:
# SakFilterV2Input i saksbehandling/sak.graphqls filtrerer på status,
# utdanningsbakgrunn, levert tidspunkt med mer, men ikke på tidlig opptak.
# Statusfilteret finnes.
#
@OPT-BEH-BEH-009 @must @in-progress
Egenskap: Finne søknader om tidlig opptak
  Som saksbehandler
  ønsker jeg å filtrere sakene på om søkeren har søkt om tidlig opptak, og på konklusjonen for tidlig opptak
  slik at jeg raskt finner sakene som må behandles før tidligopptaket gjennomføres.

  Bakgrunn:
    Gitt saksbehandler er innlogget i løsningen
    Og saksbehandler ser listen over saker i opptaket "Samordna opptak 2027"

  Regel: Søk og filtrering av saker på tidlig opptak
    En søker er med i tidligopptaket bare når saksbehandleren har konkludert med
    at søkeren deltar, og saken er ferdig behandlet. Med filtrene for tidlig opptak
    og statusfilteret finner saksbehandleren sakene der noe av dette mangler, slik
    at ingen søker faller ut av tidligopptaket uten at saksbehandleren har bestemt det.

    Scenario: Filtrene for tidlig opptak er ikke i bruk som standard
      Gitt opptaket har følgende saker:
        | søker         | søkt om tidlig opptak |
        | Kari Nordmann | ja                    |
        | Ola Nordmann  | nei                   |
      Når saksbehandler åpner sakslisten
      Så ser saksbehandler sakene til "Kari Nordmann" og "Ola Nordmann"

    Scenario: Filtrere på søkt om tidlig opptak
      Gitt opptaket har følgende saker:
        | søker         | søkt om tidlig opptak |
        | Kari Nordmann | ja                    |
        | Ola Nordmann  | nei                   |
      Når saksbehandler filtrerer på saker der søkeren har søkt om tidlig opptak
      Så vises kun saken til "Kari Nordmann"

    Scenariomal: Filtrere på konklusjonen for tidlig opptak
      Gitt opptaket har følgende saker:
        | søker         | konklusjon for tidlig opptak |
        | Kari Nordmann | deltar                       |
        | Per Hansen    | ingen                        |
        | Anne Lie      | deltar ikke                  |
      Når saksbehandler filtrerer på saker der konklusjonen for tidlig opptak er <konklusjon>
      Så vises kun saken til "<søker>"

      Eksempler:
        | konklusjon  | søker         |
        | deltar      | Kari Nordmann |
        | ingen       | Per Hansen    |
        | deltar ikke | Anne Lie      |

    Scenario: Kombinere filtrene for tidlig opptak med andre filtre
      Når saksbehandler kombinerer filtrene for tidlig opptak med ett eller flere andre filtre
      Så vises kun saker som matcher alle kriteriene

    Scenariomal: Finne saker som faller ut av tidligopptaket
      Gitt opptaket har følgende saker:
        | søker         | søkt om tidlig opptak | konklusjon for tidlig opptak | ferdig behandlet |
        | Kari Nordmann | ja                    | deltar                       | ja               |
        | Per Hansen    | ja                    | ingen                        | nei              |
        | Lise Berg     | ja                    | ingen                        | ja               |
        | Nils Dahl     | ja                    | deltar                       | nei              |
        | Anne Lie      | ja                    | deltar ikke                  | nei              |
        | Ola Nordmann  | nei                   | ingen                        | nei              |
      Når saksbehandler filtrerer på <filtre>
      Så vises kun <saker>

      Eksempler:
        | filtre                                                    | saker                                  |
        | konklusjonen ingen                                        | sakene til "Per Hansen" og "Lise Berg" |
        | konklusjonen deltar og saker som ikke er ferdig behandlet | saken til "Nils Dahl"                  |
