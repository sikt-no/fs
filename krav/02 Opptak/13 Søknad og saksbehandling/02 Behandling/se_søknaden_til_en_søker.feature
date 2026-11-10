# language: no
@OPT-BEH-BEH-043 @must @draft @ref-OPT-BEH-BEH-011 @ref-OPT-BEH-DOK-001 @ref-OPT-SØK-SØK-002
Egenskap: Se søknaden til en søker
  Som opptaksforvalter, saksbehandler eller opptaksinformatør
  ønsker jeg å se søknaden og behandlingen til søkerne organisasjonen jeg er ansatt ved har ansvar for
  slik at jeg kan behandle søknaden eller svare søkeren.

  # Bygger på R1 og R2 i spec-en «Krav til RLS» og svarene i avklaringsmøtet 2026-11-10 (svar 1–3, 5–15, 19).
  # Erstatter kort_om_søknad (@OPT-BEH-BEH-002), som avvikles.
  # Brukerrollen tildeles ved en organisasjon. Hva den gir i et opptak, avhenger av om organisasjonen er
  # forvalter, tilbyder eller behandler der (se begreper.md). I et lokalt opptak er én organisasjon alle tre.
  # Rollekodene står i tabellen «Brukerroller i opptak» i begreper.md. Opptaksinformatør er OPPTAK_INNSYN,
  # for ansatte i førstelinjen som svarer søkere om opptak (TAKE-469).
  # Koden i dag: SE_ eller MODIFISERE_SØKNADSBEHANDLING og SE_SØKNAD ved én organisasjon gir lesing av alle
  # søknader og personer i alle opptak.
  # Å søke opp personer uten søknad, og å handle på søkerens vegne, står i @OPT-SØK-SØK-002.

  Regel: En ansatt ser søknaden bare når organisasjonen er forvalter, tilbyder eller behandler på søknaden

    Scenariomal: Se søknaden ut fra rollen og organisasjonens rolle i opptaket
      Gitt søkeren har søkt et alternativ i et samordna opptak der tilbyderen og behandleren er ulike organisasjoner
      Og jeg er <rolle> ved <organisasjon>
      Når jeg søker opp søkeren
      Så <ser> jeg søknaden

      Eksempler:
        | rolle             | organisasjon                          | ser      |
        | opptaksforvalter  | forvalteren av opptaket               | ser      |
        | opptaksinformatør | forvalteren av opptaket               | ser      |
        | saksbehandler     | behandleren av søknadsalternativet    | ser      |
        | opptaksinformatør | behandleren av søknadsalternativet    | ser      |
        | saksbehandler     | tilbyderen av søknadsalternativet     | ser      |
        | opptaksinformatør | tilbyderen av søknadsalternativet     | ser      |
        | opptaksforvalter  | en organisasjon uten rolle i opptaket | ser ikke |
        | saksbehandler     | en organisasjon uten rolle i opptaket | ser ikke |
        | opptaksinformatør | en organisasjon uten rolle i opptaket | ser ikke |

    Scenario: En rolle i ett opptak gir ikke tilgang til søknader i et annet opptak
      Gitt jeg er saksbehandler ved behandleren i et samordna opptak
      Og søkeren har bare søkt i et lokalt opptak ved en annen organisasjon
      Når jeg søker opp søkeren
      Så finner jeg ikke søkeren

    Scenario: Se søknaden i et lokalt opptak ved organisasjonen
      Gitt søkeren har søkt i et lokalt opptak
      Og jeg er saksbehandler ved organisasjonen som forvalter det lokale opptaket
      Når jeg søker opp søkeren
      Så ser jeg søknaden

    Scenario: Tilbyderen ser hele søknaden
      Gitt søkeren har søkt to alternativer i et samordna opptak, og alternativene tilbys av to ulike organisasjoner
      Og jeg er saksbehandler ved tilbyderen av det ene søknadsalternativet
      Når jeg åpner søknaden
      Så ser jeg begge alternativene og prioriteringen mellom dem

    Scenario: En integrasjon får ikke mer enn de ansatte med de samme rollene
      Gitt en integrasjon har rollen saksbehandler ved en organisasjon uten rolle i opptaket
      Når integrasjonen henter søknaden gjennom API-et
      Så får integrasjonen ikke søknaden

  Regel: Personopplysningene følger søknaden

    Scenario: Finner ikke personer uten en søknad organisasjonen har tilknytning til
      Gitt en person har bare søknader i opptak der organisasjonen verken er forvalter, tilbyder eller behandler
      Og jeg er saksbehandler ved organisasjonen
      Når jeg søker etter personen
      Så finner jeg ikke personen

    Scenariomal: Fortrolig adresse vises ikke for ansatte
      Gitt søkeren har fortrolig adresse
      Og jeg er <rolle> ved forvalteren av opptaket
      Når jeg åpner søknaden
      Så ser jeg ikke adressen til søkeren

      Eksempler:
        | rolle             |
        | opptaksforvalter  |
        | saksbehandler     |
        | opptaksinformatør |

    Scenario: Kontaktinformasjonen kommer fra Folkeregisteret og KRR
      Gitt søkeren finnes i Folkeregisteret og KRR
      Og jeg er opptaksforvalter ved forvalteren av opptaket
      Når jeg åpner søknaden
      Så ser jeg kontaktinformasjonen fra Folkeregisteret og KRR
      Og jeg ser ikke muligheten til å endre kontaktinformasjonen

    Scenario: Opptaksforvalteren endrer kontaktinformasjonen til en søker som ikke finnes i Folkeregisteret
      Gitt søkeren finnes ikke i Folkeregisteret
      Og jeg er opptaksforvalter ved forvalteren av opptaket
      Når jeg endrer e-postadressen til søkeren
      Så er e-postadressen endret

  Regel: Opptaksinformatøren ser søknaden med dokumentasjon og digitale resultater

    Scenario: Se innholdet i søknaden
      Når opptaksinformatøren åpner søknaden
      Så ser opptaksinformatøren opptaket, søknadsnummeret og søknadsalternativene med prioritering
      Og opptaksinformatøren ser utdanningsbakgrunnen søkeren har valgt
      Og opptaksinformatøren ser dokumentasjonen søkeren har lastet opp
      Og opptaksinformatøren ser de digitale resultatene i søknaden

    Scenario: Innsyn i dokumentasjon logges
      Når opptaksinformatøren åpner et dokument søkeren har lastet opp
      Så logges det at opptaksinformatøren har sett dokumentet

    Scenario: Ser at politiattesten er levert, men ikke innholdet
      Gitt søkeren har lastet opp en politiattest
      Når opptaksinformatøren åpner søknaden
      Så ser opptaksinformatøren at politiattesten er levert
      Og opptaksinformatøren ser ikke muligheten til å åpne politiattesten

  Regel: Opptaksinformatøren ser alt i søknadsbehandlingen

    Scenario: Se behandlingen av søknadsalternativene
      Når opptaksinformatøren åpner søknaden
      Så ser opptaksinformatøren behandlingsstatusen og hvilken organisasjon som behandler hvert søknadsalternativ
      Og opptaksinformatøren ser poengsummen og kvalifiseringen
      Og opptaksinformatøren ser praksiskalkulatoren

    Scenario: Se delte merknader og mangler
      Gitt søkeren har søkt et alternativ i et samordna opptak der tilbyderen og behandleren er ulike organisasjoner
      Og behandleren har registrert en delt merknad og en delt mangel i saken
      Og opptaksinformatøren er ansatt ved tilbyderen av søknadsalternativet
      Når opptaksinformatøren åpner søknaden
      Så ser opptaksinformatøren merknaden og mangelen

    Scenariomal: Interne merknader og mangler ses bare ved organisasjonen som registrerte dem
      Gitt søkeren har søkt et alternativ i et samordna opptak der tilbyderen og behandleren er ulike organisasjoner
      Og behandleren har registrert en intern merknad og en intern mangel i saken
      Og opptaksinformatøren er ansatt ved <organisasjon>
      Når opptaksinformatøren åpner søknaden
      Så <ser> opptaksinformatøren merknaden og mangelen

      Eksempler:
        | organisasjon                       | ser      |
        | behandleren av søknadsalternativet | ser      |
        | tilbyderen av søknadsalternativet  | ser ikke |
        | forvalteren av opptaket            | ser ikke |

  Regel: Opptaksinformatøren ser de samme meldingene til søkeren som saksbehandlerne ved organisasjonen

    Scenariomal: Meldinger fra andre organisasjoner ses når de er delt
      Gitt søkeren har søkt et alternativ i et samordna opptak der tilbyderen og behandleren er ulike organisasjoner
      Og behandleren har sendt en <type> melding til søkeren
      Og opptaksinformatøren er ansatt ved tilbyderen av søknadsalternativet
      Når opptaksinformatøren åpner søknaden
      Så <ser> opptaksinformatøren meldingen

      Eksempler:
        | type   | ser      |
        | delt   | ser      |
        | intern | ser ikke |

  Regel: Opptaksinformatøren ser resultatet først når det er publisert

    Scenario: Se tilbud og ventelistenummer etter publisering
      Gitt plasstildelingsrunden er publisert
      Og søkeren har fått tilbud på ett alternativ og står på venteliste på et annet
      Når opptaksinformatøren åpner søknaden
      Så ser opptaksinformatøren tilbudet, ventelistenummeret og svaret søkeren har gitt

    Scenario: Ser ikke resultatet før det er publisert
      Gitt plasstildelingen er kjørt, men ikke publisert
      Når opptaksinformatøren åpner søknaden
      Så ser ikke opptaksinformatøren resultatet

  Regel: Opptaksinformatøren kan ikke endre noe

    Scenariomal: Ingen endringer i søknad eller sak
      Når opptaksinformatøren åpner søknaden
      Så ser ikke opptaksinformatøren muligheten til å <handling>

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
      Gitt en applikasjon handler for opptaksinformatøren
      Når applikasjonen forsøker å endre søknaden gjennom API-et
      Så avvises endringen
