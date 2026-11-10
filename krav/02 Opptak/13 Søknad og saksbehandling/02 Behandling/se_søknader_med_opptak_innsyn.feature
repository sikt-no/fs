# language: no
@OPT-BEH-BEH-043 @must @draft @ref-OPT-BEH-BEH-011 @ref-OPT-BEH-DOK-001 @ref-OPT-REG-SAM-002
Egenskap: Se søknader med OPPTAK_INNSYN
  Som bruker med rollen OPPTAK_INNSYN
  ønsker jeg å se søknadene og behandlingen til søkerne organisasjonen jeg er ansatt ved har ansvar for
  slik at jeg kan svare søkerne uten å sende dem videre til saksbehandlerne.

  # Rollen er OPPTAK_INNSYN (rolleforslaget 2026-10-12, TAKE-469). Avklart i møte 2026-11-10.
  # Erstatter kort_om_søknad (@OPT-BEH-BEH-002), som avvikles.
  # Brukerrollen tildeles ved en organisasjon. Hva den gir i et opptak, avhenger av om organisasjonen er
  # forvalter, tilbyder eller behandler der (se begreper.md). I et lokalt opptak er én organisasjon alle tre.
  # Koden i dag (TAKE-469): SE_SØKNAD ved én organisasjon gir lesing av alle søknader i alle opptak.

  Bakgrunn:
    Gitt brukeren har rollen OPPTAK_INNSYN ved organisasjonen sin

  Regel: Brukeren med OPPTAK_INNSYN ser søknadene der organisasjonen er forvalter, tilbyder eller behandler

    Scenariomal: Se søknader ut fra organisasjonens rolle i opptaket
      Gitt søkeren har søkt et alternativ i et samordna opptak der tilbyderen og behandleren er ulike organisasjoner
      Og brukeren med OPPTAK_INNSYN er ansatt ved <organisasjon>
      Når brukeren med OPPTAK_INNSYN søker opp søkeren
      Så <ser> brukeren med OPPTAK_INNSYN søknaden

      Eksempler:
        | organisasjon                          | ser      |
        | forvalteren av opptaket               | ser      |
        | tilbyderen av søknadsalternativet     | ser      |
        | behandleren av søknadsalternativet    | ser      |
        | en organisasjon uten rolle i opptaket | ser ikke |

    Scenario: Se søknader i et lokalt opptak ved organisasjonen
      Gitt søkeren har søkt i et lokalt opptak
      Og brukeren med OPPTAK_INNSYN er ansatt ved organisasjonen som forvalter det lokale opptaket
      Når brukeren med OPPTAK_INNSYN søker opp søkeren
      Så ser brukeren med OPPTAK_INNSYN søknaden

    Scenario: Ser ikke søknader i et lokalt opptak ved en annen organisasjon
      Gitt søkeren har bare søkt i et lokalt opptak
      Og brukeren med OPPTAK_INNSYN er ansatt ved en annen organisasjon enn den som forvalter det lokale opptaket
      Når brukeren med OPPTAK_INNSYN søker opp søkeren
      Så finner ikke brukeren med OPPTAK_INNSYN søkeren

    Scenario: Tilbyderen ser hele søknaden
      Gitt søkeren har søkt to alternativer i et samordna opptak, og alternativene tilbys av to ulike organisasjoner
      Og brukeren med OPPTAK_INNSYN er ansatt ved tilbyderen av det ene søknadsalternativet
      Når brukeren med OPPTAK_INNSYN åpner søknaden
      Så ser brukeren med OPPTAK_INNSYN begge alternativene og prioriteringen mellom dem

  Regel: Brukeren med OPPTAK_INNSYN ser bare personer som har en søknad brukeren ser

    Scenario: Finner ikke personer uten søknad
      Gitt at en person ikke har noen søknad
      Når brukeren med OPPTAK_INNSYN søker etter personen
      Så finner ikke brukeren med OPPTAK_INNSYN personen

    Scenario: Fortrolig adresse vises ikke
      Gitt søkeren har fortrolig adresse
      Når brukeren med OPPTAK_INNSYN åpner søknaden
      Så ser ikke brukeren med OPPTAK_INNSYN adressen til søkeren

  Regel: Brukeren med OPPTAK_INNSYN ser søknaden med dokumentasjon og digitale resultater

    Scenario: Se innholdet i søknaden
      Når brukeren med OPPTAK_INNSYN åpner søknaden
      Så ser brukeren med OPPTAK_INNSYN opptaket, søknadsnummeret og søknadsalternativene med prioritering
      Og brukeren med OPPTAK_INNSYN ser utdanningsbakgrunnen søkeren har valgt
      Og brukeren med OPPTAK_INNSYN ser dokumentasjonen søkeren har lastet opp
      Og brukeren med OPPTAK_INNSYN ser de digitale resultatene i søknaden

    Scenario: Innsyn i dokumentasjon logges
      Når brukeren med OPPTAK_INNSYN åpner et dokument søkeren har lastet opp
      Så logges det at brukeren med OPPTAK_INNSYN har sett dokumentet

    Scenario: Ser at politiattesten er levert, men ikke innholdet
      Gitt søkeren har lastet opp en politiattest
      Når brukeren med OPPTAK_INNSYN åpner søknaden
      Så ser brukeren med OPPTAK_INNSYN at politiattesten er levert
      Og brukeren med OPPTAK_INNSYN ser ikke muligheten til å åpne politiattesten

  Regel: Brukeren med OPPTAK_INNSYN ser alt i søknadsbehandlingen

    Scenario: Se behandlingen av søknadsalternativene
      Når brukeren med OPPTAK_INNSYN åpner søknaden
      Så ser brukeren med OPPTAK_INNSYN behandlingsstatusen og hvilken organisasjon som behandler hvert søknadsalternativ
      Og brukeren med OPPTAK_INNSYN ser poengsummen og kvalifiseringen
      Og brukeren med OPPTAK_INNSYN ser praksiskalkulatoren

    Scenario: Se delte merknader og mangler
      Gitt søkeren har søkt et alternativ i et samordna opptak der tilbyderen og behandleren er ulike organisasjoner
      Og behandleren har registrert en delt merknad og en delt mangel i saken
      Og brukeren med OPPTAK_INNSYN er ansatt ved tilbyderen av søknadsalternativet
      Når brukeren med OPPTAK_INNSYN åpner søknaden
      Så ser brukeren med OPPTAK_INNSYN merknaden og mangelen

    Scenariomal: Interne merknader og mangler ses bare ved organisasjonen som registrerte dem
      Gitt søkeren har søkt et alternativ i et samordna opptak der tilbyderen og behandleren er ulike organisasjoner
      Og behandleren har registrert en intern merknad og en intern mangel i saken
      Og brukeren med OPPTAK_INNSYN er ansatt ved <organisasjon>
      Når brukeren med OPPTAK_INNSYN åpner søknaden
      Så <ser> brukeren med OPPTAK_INNSYN merknaden og mangelen

      Eksempler:
        | organisasjon                       | ser      |
        | behandleren av søknadsalternativet | ser      |
        | tilbyderen av søknadsalternativet  | ser ikke |
        | forvalteren av opptaket            | ser ikke |

  Regel: Brukeren med OPPTAK_INNSYN ser de samme meldingene til søkeren som saksbehandlerne ved organisasjonen

    Scenariomal: Meldinger fra andre organisasjoner ses når de er delt
      Gitt søkeren har søkt et alternativ i et samordna opptak der tilbyderen og behandleren er ulike organisasjoner
      Og behandleren har sendt en <type> melding til søkeren
      Og brukeren med OPPTAK_INNSYN er ansatt ved tilbyderen av søknadsalternativet
      Når brukeren med OPPTAK_INNSYN åpner søknaden
      Så <ser> brukeren med OPPTAK_INNSYN meldingen

      Eksempler:
        | type   | ser      |
        | delt   | ser      |
        | intern | ser ikke |

  Regel: Brukeren med OPPTAK_INNSYN ser resultatet først når det er publisert

    Scenario: Se tilbud og ventelistenummer etter publisering
      Gitt plasstildelingsrunden er publisert
      Og søkeren har fått tilbud på ett alternativ og står på venteliste på et annet
      Når brukeren med OPPTAK_INNSYN åpner søknaden
      Så ser brukeren med OPPTAK_INNSYN tilbudet, ventelistenummeret og svaret søkeren har gitt

    Scenario: Ser ikke resultatet før det er publisert
      Gitt plasstildelingen er kjørt, men ikke publisert
      Når brukeren med OPPTAK_INNSYN åpner søknaden
      Så ser ikke brukeren med OPPTAK_INNSYN resultatet

  Regel: Brukeren med OPPTAK_INNSYN kan ikke endre noe

    Scenariomal: Ingen endringer i søknad eller sak
      Når brukeren med OPPTAK_INNSYN åpner søknaden
      Så ser ikke brukeren med OPPTAK_INNSYN muligheten til å <handling>

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
      Gitt en applikasjon handler for brukeren med OPPTAK_INNSYN
      Når applikasjonen forsøker å endre søknaden gjennom API-et
      Så avvises endringen
