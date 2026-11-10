# language: no
@OPT-BEH-BEH-043 @must @draft @ref-OPT-BEH-BEH-011 @ref-OPT-BEH-DOK-001 @ref-OPT-REG-SAM-002
Egenskap: Innsyn i søknader for førstelinjen
  Som førstelinje
  ønsker jeg å se søknadene og behandlingen til søkerne organisasjonen jeg er ansatt ved har ansvar for
  slik at jeg kan svare søkerne uten å sende dem videre til saksbehandlerne.

  # Rollen er OPPTAK_INNSYN (rolleforslaget 2026-10-12, TAKE-469). Avklart i møte 2026-11-10.
  # Erstatter kort_om_søknad (@OPT-BEH-BEH-002), som avvikles.
  # Brukerrollen tildeles ved en organisasjon. Hva den gir i et opptak, avhenger av om organisasjonen er
  # forvalter, tilbyder eller behandler der (se begreper.md og tilgang.md). I et lokalt opptak er én organisasjon alle tre.
  # Koden i dag (TAKE-469): SE_SØKNAD ved én organisasjon gir lesing av alle søknader i alle opptak.

  Bakgrunn:
    Gitt førstelinjen har rollen OPPTAK_INNSYN ved organisasjonen sin

  @tilgang
  Regel: Førstelinjen ser søknadene der organisasjonen er forvalter, tilbyder eller behandler

    Scenariomal: Se søknader ut fra organisasjonens rolle i opptaket
      Gitt førstelinjen er ansatt ved <organisasjon>
      Og søkeren har søkt Sykepleie ved NTNU i et samordnet opptak HK-dir forvalter
      Og UiO behandler søknadsalternativet
      Når førstelinjen søker opp søkeren
      Så <ser> førstelinjen søknaden

      Eksempler:
        | organisasjon | ser      |
        | HK-dir       | ser      |
        | NTNU         | ser      |
        | UiO          | ser      |
        | UiB          | ser ikke |

    Scenario: Se søknader i et lokalt opptak ved organisasjonen
      Gitt førstelinjen er ansatt ved NTNU
      Og søkeren har søkt i et lokalt opptak NTNU forvalter
      Når førstelinjen søker opp søkeren
      Så ser førstelinjen søknaden

    Scenario: Ser ikke søknader i et lokalt opptak ved en annen organisasjon
      Gitt førstelinjen er ansatt ved UiO
      Og søkeren har bare søkt i et lokalt opptak NTNU forvalter
      Når førstelinjen søker opp søkeren
      Så finner ikke førstelinjen søkeren

    Scenario: Tilbyderen ser hele søknaden
      Gitt førstelinjen er ansatt ved NTNU
      Og søkeren har søkt ett alternativ ved NTNU og ett ved UiO i et samordnet opptak
      Når førstelinjen åpner søknaden
      Så ser førstelinjen begge alternativene og prioriteringen mellom dem

  @tilgang
  Regel: Førstelinjen ser bare personer som har en søknad førstelinjen ser

    Scenario: Finner ikke personer uten søknad
      Gitt at en person ikke har noen søknad
      Når førstelinjen søker etter personen
      Så finner ikke førstelinjen personen

    Scenario: Fortrolig adresse vises ikke
      Gitt søkeren har fortrolig adresse
      Når førstelinjen åpner søknaden
      Så ser ikke førstelinjen adressen til søkeren

  @tilgang
  Regel: Førstelinjen ser søknaden med dokumentasjon og digitale resultater

    Scenario: Se innholdet i søknaden
      Når førstelinjen åpner søknaden
      Så ser førstelinjen opptaket, søknadsnummeret og søknadsalternativene med prioritering
      Og førstelinjen ser utdanningsbakgrunnen søkeren har valgt
      Og førstelinjen ser dokumentasjonen søkeren har lastet opp
      Og førstelinjen ser de digitale resultatene i søknaden

    Scenario: Innsyn i dokumentasjon logges
      Når førstelinjen åpner et dokument søkeren har lastet opp
      Så logges det at førstelinjen har sett dokumentet

    Scenario: Ser at politiattesten er levert, men ikke innholdet
      Gitt søkeren har lastet opp en politiattest
      Når førstelinjen åpner søknaden
      Så ser førstelinjen at politiattesten er levert
      Og førstelinjen kan ikke åpne politiattesten

  @tilgang
  Regel: Førstelinjen ser alt i søknadsbehandlingen

    Scenario: Se behandlingen av søknadsalternativene
      Når førstelinjen åpner søknaden
      Så ser førstelinjen behandlingsstatusen og hvilken organisasjon som behandler hvert søknadsalternativ
      Og førstelinjen ser poengsummen og kvalifiseringen
      Og førstelinjen ser praksiskalkulatoren

    Scenario: Se delte merknader og mangler
      Gitt UiO behandler søknadsalternativet
      Og UiO har registrert en delt merknad og en delt mangel i saken
      Og førstelinjen er ansatt ved NTNU, som tilbyr alternativet
      Når førstelinjen åpner søknaden
      Så ser førstelinjen merknaden og mangelen

    Scenariomal: Interne merknader og mangler ses bare ved organisasjonen som registrerte dem
      Gitt UiO behandler søknadsalternativet
      Og UiO har registrert en intern merknad og en intern mangel i saken
      Og førstelinjen er ansatt ved <organisasjon>
      Når førstelinjen åpner søknaden
      Så <ser> førstelinjen merknaden og mangelen

      Eksempler:
        | organisasjon | ser      |
        | UiO          | ser      |
        | NTNU         | ser ikke |
        | HK-dir       | ser ikke |

  @tilgang
  Regel: Førstelinjen ser de samme meldingene til søkeren som saksbehandlerne ved organisasjonen

    Scenariomal: Meldinger fra andre organisasjoner ses når de er delt
      Gitt UiO har sendt en <type> melding til søkeren
      Og førstelinjen er ansatt ved NTNU, som tilbyr et av søknadsalternativene
      Når førstelinjen åpner søknaden
      Så <ser> førstelinjen meldingen

      Eksempler:
        | type   | ser      |
        | delt   | ser      |
        | intern | ser ikke |

  @tilgang
  Regel: Førstelinjen ser resultatet først når det er publisert

    Scenario: Se tilbud og ventelistenummer etter publisering
      Gitt plasstildelingsrunden er publisert
      Og søkeren har fått tilbud på ett alternativ og står på venteliste på et annet
      Når førstelinjen åpner søknaden
      Så ser førstelinjen tilbudet, ventelistenummeret og svaret søkeren har gitt

    Scenario: Ser ikke resultatet før det er publisert
      Gitt plasstildelingen er kjørt, men ikke publisert
      Når førstelinjen åpner søknaden
      Så ser ikke førstelinjen resultatet

  @tilgang
  Regel: Førstelinjen kan ikke endre noe

    Scenariomal: Ingen endringer i søknad eller sak
      Når førstelinjen åpner søknaden
      Så kan ikke førstelinjen <handling>

      Eksempler:
        | handling                                |
        | levere eller endre søknaden for søkeren |
        | trekke søknaden eller et alternativ     |
        | laste opp eller slette dokumentasjon    |
        | svare på tilbud for søkeren             |
        | endre saken eller behandlingsstatusen   |
        | gi tilbudsgaranti                       |
        | endre kontaktinformasjonen til søkeren  |
        | ta ut sakslista                         |

    Scenario: Endringer avvises også i API-et
      Gitt en applikasjon handler for førstelinjen
      Når applikasjonen forsøker å endre søknaden gjennom API-et
      Så avvises endringen
