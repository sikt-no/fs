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
# (OPT-SØK-SØK-011). Hvilke saker som er med når tidligopptaket gjennomføres, står i
# gi_tilbudsgaranti_ved_tidlig_opptak.feature (OPT-BEH-BEH-007).
#
# Det finnes ikke noe krav for selve sakslisten i saksbehandlingen ennå. Dette
# kravet beskriver bare filtrene for tidlig opptak. Sakslisten får ingen egen
# kolonne for tidlig opptak (avklart 08.10.2026).
#
# AVKLART 09.10.2026 (review av PR #654)
#
# - Kravet beskriver hva saksbehandleren kan filtrere på, ikke hvordan filtrene
#   ser ut eller hva de heter. Det hører hjemme i implementasjonsdetaljene.
#
# AVKLART 23.10.2026 (kravet følger det som leveres i STEK-561 og STEK-268)
#
# - Filteret for tidlig opptak har tre valg: søkt om tidlig opptak, mangler
#   konklusjon og har konklusjon. Filteret kombineres med de andre filtrene i
#   sakslisten med «og», som de andre filtrene.
# - (Endret 27.10.2026, etter koden fra STEK-561.) De to valgene for konklusjon
#   kombineres med «eller». Valget søkt om tidlig opptak kombineres med valgene for
#   konklusjon med «og». Erstatter at alle valgene i filteret kombineres med «eller».
# - Valgene for konklusjon gjelder bare saker der søkeren har søkt om tidlig opptak.
#   En sak der søkeren ikke har søkt, mangler ikke konklusjon.
# - Det filtreres ikke på hvilken konklusjon saken har, eller på om søkeren deltar.
#   Erstatter filteret på konklusjonen (deltar, deltar ikke, ingen) fra 09.10.2026.
# - Filteret for tidlig opptak er uavhengig av saksbehandlingsstatusen. Hvilke saker
#   som er med i tidligopptaket, avgjøres når det gjennomføres (OPT-BEH-BEH-007), og
#   filtrene skal ikke gi det samme utvalget som prøvekjøringen.
#
@OPT-BEH-BEH-009 @must @implemented
Egenskap: Finne søknader om tidlig opptak
  Som saksbehandler
  ønsker jeg å filtrere sakene på om søkeren har søkt om tidlig opptak, og på om saken har konklusjon for tidlig opptak
  slik at jeg raskt finner sakene som må behandles før tidligopptaket gjennomføres.

  Bakgrunn:
    Gitt saksbehandler er innlogget i løsningen
    Og opptaket "Samordna opptak 2027" har følgende saker:
      | søker         | søkt om tidlig opptak | konklusjon for tidlig opptak                   | saksbehandlingsstatus |
      | Kari Nordmann | ja                    | KFF – Kan få tidlig opptak, har godkjent grunn | ferdig behandlet      |
      | Per Hansen    | ja                    | ingen                                          | ubehandlet            |
      | Anne Lie      | ja                    | KIF – Kan ikke få tidlig opptak, mangler grunn | under behandling      |
      | Ola Nordmann  | nei                   | ingen                                          | ubehandlet            |

  Regel: Søk og filtrering av saker på tidlig opptak
    Saksbehandleren kan filtrere på om søkeren har søkt om tidlig opptak, og på om
    saken mangler eller har konklusjon for tidlig opptak. Valgene for konklusjon
    gjelder bare saker der søkeren har søkt.

    Scenario: Filteret for tidlig opptak er ikke i bruk som standard
      Når saksbehandler åpner sakslisten i opptaket "Samordna opptak 2027"
      Så ser saksbehandler sakene til "Kari Nordmann", "Per Hansen", "Anne Lie" og "Ola Nordmann"

    Scenariomal: Filtrere på tidlig opptak
      Når saksbehandler filtrerer på saker der <valg>
      Så vises kun <saker>

      Eksempler:
        | valg                                   | saker                                                  |
        | søkeren har søkt om tidlig opptak      | sakene til "Kari Nordmann", "Per Hansen" og "Anne Lie" |
        | konklusjonen for tidlig opptak mangler | saken til "Per Hansen"                                 |
        | saken har konklusjon for tidlig opptak | sakene til "Kari Nordmann" og "Anne Lie"               |

    Scenario: Saker der søkeren ikke har søkt, mangler ikke konklusjon
      Når saksbehandler filtrerer på saker der konklusjonen for tidlig opptak mangler
      Så vises ikke saken til "Ola Nordmann"

    Scenario: Valgene for konklusjon kombineres med eller
      Når saksbehandler filtrerer på saker der konklusjonen for tidlig opptak mangler eller saken har konklusjon for tidlig opptak
      Så vises kun sakene til "Kari Nordmann", "Per Hansen" og "Anne Lie"

    Scenario: Søkt om tidlig opptak kombineres med valgene for konklusjon med og
      Når saksbehandler filtrerer på saker der søkeren har søkt om tidlig opptak og konklusjonen for tidlig opptak mangler
      Så vises kun saken til "Per Hansen"

    Scenario: Filteret for tidlig opptak kombineres med saksbehandlingsstatus
      Når saksbehandler filtrerer på saker der saken har konklusjon for tidlig opptak
      Og saksbehandler filtrerer på saksbehandlingsstatusen "under behandling"
      Så vises kun saken til "Anne Lie"
