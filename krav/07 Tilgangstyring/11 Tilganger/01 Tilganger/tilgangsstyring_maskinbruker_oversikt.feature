# language: no
@TIL-TIL-TIL-004 @skip @støtteprosesser @sikkerhet
Egenskap: Tilgangsstyring - Oversikt over API-brukere
  Som systemadministrator ved organisasjon som bruker FS til studieadministrasjon, trenger jeg å vite hvilke maskinbrukere
  som  til enhver tid har tilgang til å se data om våre utdanninger, studenter og søkere, for å sikre våre virksomhetsdata og personvern for personer registrert hos oss.

  Bakgrunn:
    Gitt at bruker er systemadministrator for organisasjon
    Gitt at systemadministrator er på oversiktsside for tilgangsstyring av APIer

  Scenariomal: systemadministrator ser oversikt over maskinbrukere
    Når "<systemadministrator>" er på oversiktsside for tilgangsstyring
    Så ser systemadministrator en oversikt (liste) over "<maskinbrukere>"
    Så ser systemadministrator "<beskrivelse>" av hvilken organsisasjon (hvem) som bruker maskinbrukeren til hva
    Så ser systemadministrator "<kontaktperson>" for maskinbrukeren
    Så ser systemadministrator "<eierorganisasjon>" som har lagt til maskinbrukeren
    Så ser systemadministrator en mulighet til å navigere til en enkelt maskinbruker

    Eksempler:
      | systemadministrator | maskinbrukere | beskrivelse                    | kontaktperson | eierorganisasjon |
      | Cal-El Superman     | SIOBRUKER     | SiO Studentsamskipnaden i Oslo | Ola Johansen  | Sikt  KTL        |
      | Cal-El Supermann    |    7777BRUKER | Lånekassen                     | Frodo Baggins | Sikt THS         |
      | CaL-EL Supermann    | RUTERBRUKER   | UiO Universitetet i Oslo       | Bilbo Baggins | Sikt THS         |
      | Cal-EL Supermann    |    7778BRUKER | Sopra Steria                   | Samwise Gamgi | Universitet 2    |

  Scenariomal: studieadministrator søker etter registrerte maskinbrukerkontoer
    Når "<systemadministrator>" søker etter "<maskinbruker>"
    Så får systemadministrator "<output>"

    Eksempler:
      | systemadministrator | maskinbruker | output                 |
      | Cal-El Superman     | UIABRUKER    | ingen resultater       |
      | Cal-El Superman     |          777 | 7777BRUKER, 7778BRUKER |
      | Cal-El Superman     | RUTER        | RUTERBRUKER            |

  Scenario: systemadministrator velger maskinbrukerprofil
    Når systemadministrator klikker på maskinbruker "SIOBruker"
    Så kommer systemadministrator over til maskinbrukerprofilen til "SIOBruker"

    #Filtrering av maskinbrukersøk

  Scenariomal: systemadministrator filtrerer oversikt over maskinbrukere på API
    Når "<systemadministrator>" er på oversiktsside for tilgangsstyring
    Når "<systemadministrator>" velger hvilke "<API>" som maskinbrukere filtreres på
    Så oppdateres maskinbrukeroversikten til å vise "<maskinbrukere>" som er gyldige for "<API>"

    Eksempler:
      |systemadministrator|API       |maskinbrukere                               |
      | Cal-El Superman   |FS-GraphQL| maskinbruker1, maskinbruker2, maskinbruker3|

  Scenariomal: Sikts systemadministratorer filtrerer oversikt over maskinbrukere på eierorganisasjon
    Gitt at "<systemadministrator>" jobber for Sikt
    Når "<systemadministrator>" er på oversiktsside for tilgangsstyring
    Når "<systemadministrator>" velger eierorgansiasjon "<eierorgansiasjon>"
    Så oppdateres maskinbrukeroversikten til å vise "<maskinbrukere>" som er gyldige for "<eierorganisasjon>"

    Eksempler:
      |systemadministrator|eierorganisasjon|maskinbrukere                               |
      | Cal-El Superman   |HVL             | maskinbruker1, maskinbruker2, maskinbruker3|



