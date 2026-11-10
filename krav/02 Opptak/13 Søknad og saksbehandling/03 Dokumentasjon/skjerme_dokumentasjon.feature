# language: no
# GitHub: #570
@OPT-BEH-DOK-001 @must @draft
Egenskap: Skjerme dokumentasjon med særlige kategorier av personopplysninger
  Som søker
  ønsker jeg at dokumentasjon jeg laster opp kun er tilgjengelig for de som behandler søknaden min
  slik at opplysningene mine ikke er synlige for uvedkommende.

  Bakgrunn:
    Gitt jeg er innlogget i FS Admin

  # Avklart 2026-11-10 (R1, R4 og svar 15): dokumentasjonen følger søknaden. Rollene gis per organisasjon, ikke per
  # opptak, så scenarioet «Saksbehandler uten tilknytning til opptaket ser ikke dokumentasjonen» er tatt ut.
  Regel: Dokumentasjonen ses bare av organisasjonene som er forvalter, tilbyder eller behandler på søknaden

    Scenariomal: Se dokumentasjonen ut fra organisasjonens rolle i opptaket
      Gitt søkeren har lastet opp et dokument av typen "Vitnemål eller karakterutskrift"
      Og søknaden er i et samordna opptak der tilbyderen og behandleren er ulike organisasjoner
      Og jeg er <rolle> ved <organisasjon>
      Når jeg åpner søknaden
      Så <ser> jeg dokumentasjonen som er lastet opp på søknaden

      Eksempler:
        | rolle             | organisasjon                          | ser      |
        | saksbehandler     | behandleren av søknadsalternativet    | ser      |
        | saksbehandler     | tilbyderen av søknadsalternativet     | ser      |
        | opptaksforvalter  | forvalteren av opptaket               | ser      |
        | opptaksinformatør | forvalteren av opptaket               | ser      |
        | saksbehandler     | en organisasjon uten rolle i opptaket | ser ikke |

  Regel: Dokumenttype følger dokumentet

    Scenariomal: Saksbehandler ser hvilken type et dokument er
      Gitt søkeren har lastet opp et dokument av typen <dokumenttype>
      Og jeg er saksbehandler for opptaket søknaden gjelder
      Når jeg åpner søknaden
      Så ser jeg at dokumentet er av typen <dokumenttype>

      Eksempler:
        | dokumenttype                    |
        | Vitnemål eller karakterutskrift |
        | Legeerklæring                   |
        | Politiattest                    |
        | Annen dokumentasjon             |

  Regel: Saksbehandler kan markere dokumentasjon som sensitiv

    # Avklart (spørsmål 11 i spec-en «Krav til RLS»): markeringen styrer sletting, ikke hvem som ser dokumentet.
    Scenario: Saksbehandler markerer et dokument som sensitivt
      Gitt søkeren har lastet opp et dokument av typen "Annen dokumentasjon"
      Og jeg er saksbehandler for opptaket søknaden gjelder
      Når jeg markerer dokumentet som sensitivt
      Så er dokumentet markert som sensitivt for alle som behandler søknaden

    Scenario: Markeringen endrer ikke hvem som ser dokumentet
      Gitt et dokument er markert som sensitivt
      Og jeg er saksbehandler ved tilbyderen av søknadsalternativet
      Når jeg åpner søknaden
      Så ser jeg dokumentet

    @openquestion
    Scenario: Feilaktig markering kan fjernes
      Gitt et dokument er markert som sensitivt
      Når jeg fjerner markeringen
      Så er dokumentet ikke lenger markert som sensitivt
      # ÅPNE SPØRSMÅL:
      # - Skal markeringen kunne fjernes, og av hvem? Å fjerne en markering
      #   svekker vernet, så det bør kanskje kreve samme rolle som sletting.

  # Avklart 2026-11-10 (svar 12 og 28): innholdet i politiattesten ser bare behandleren, og tilbyderen der søkeren har
  # takket ja, fra ja-svaret er gitt. Opptaksforvalteren og opptaksinformatøren ser bare at den er levert.
  Regel: Politiattest skal oppbevares utilgjengelig for uvedkommende

    Scenariomal: Se politiattesten ut fra rollen og organisasjonens rolle
      Gitt søkeren har lastet opp et dokument av typen "Politiattest"
      Og søknaden er i et samordna opptak der tilbyderen og behandleren er ulike organisasjoner
      Og søkeren har <svar>
      Og jeg er <rolle> ved <organisasjon>
      Når jeg åpner søknaden
      Så ser jeg at en politiattest er levert
      Og <innhold>

      Eksempler:
        | svar                          | rolle             | organisasjon                       | innhold                                       |
        | ikke svart på tilbud          | saksbehandler     | behandleren av søknadsalternativet | ser jeg innholdet i politiattesten            |
        | ikke svart på tilbud          | saksbehandler     | tilbyderen av søknadsalternativet  | ser jeg ikke innholdet i politiattesten       |
        | takket ja til tilbudet        | saksbehandler     | tilbyderen av søknadsalternativet  | ser jeg innholdet i politiattesten            |
        | takket ja til tilbudet        | opptaksforvalter  | forvalteren av opptaket            | ser jeg ikke innholdet i politiattesten       |
        | takket ja til tilbudet        | opptaksinformatør | behandleren av søknadsalternativet | ser jeg ikke innholdet i politiattesten       |

  Regel: Bare dokumentforvalteren hos forvalteren laster opp og sletter dokumentasjon på søkerens vegne

    # Avklart 2026-11-10 (svar 21, TAKE-470): dokumentforvalter er rollen OPPTAK_DOKUMENTASJON.
    Scenariomal: Laste opp dokumentasjon på søkerens vegne
      Gitt jeg er <rolle> ved <organisasjon>
      Når jeg vil laste opp et dokument på søknaden på søkerens vegne
      Så <utfall>

      Eksempler:
        | rolle             | organisasjon                       | utfall                                               |
        | dokumentforvalter | forvalteren av opptaket            | kan jeg laste opp dokumentet                         |
        | saksbehandler     | behandleren av søknadsalternativet | ser jeg ikke muligheten til å laste opp dokumentet   |
        | opptaksforvalter  | forvalteren av opptaket            | ser jeg ikke muligheten til å laste opp dokumentet   |

    Scenario: Søkeren ser dokumentet dokumentforvalteren har lastet opp
      Gitt dokumentforvalteren ved forvalteren av opptaket har lastet opp et dokument på søknaden
      Når søkeren åpner søknaden i Min kompetanse
      Så ser søkeren dokumentet

  Regel: Innsyn i dokumentasjon logges

    @openquestion
    Scenario: Åpning av et dokument registreres
      Gitt jeg er saksbehandler for opptaket søknaden gjelder
      Når jeg åpner et dokument på søknaden
      Så registreres det at jeg har åpnet dokumentet
      # ÅPNE SPØRSMÅL:
      # - Eies dette kravet av fokusområdet tilrettelegging? Sporingslogg for
      #   innsyn arbeides frem i GitLab MR !5622 og bør ikke dubleres her.
      # - Kravet kan ikke innfris så lenge klienten laster ned direkte fra S3
      #   med signert URL — den som har bøttetilgang omgår all logging i
      #   Admissio. Avklares med Erlend / Team Tind.

# ÅPNE SPØRSMÅL:
# - Retensjon per dokumenttype er ikke avklart. Hvor lenge skal en legeerklæring
#   på en dispensasjonssøknad oppbevares etter at opptaket er avsluttet?
# - Barn under 18: juristen krever "egnede tiltak for særlig god sikkerhet" uten
#   å spesifisere hva. Skal det gjelde andre regler for søkere under 18?
# - Er dokumentasjon knyttet til søknaden eller til personen? Se
#   behandle_søknad.feature:27 — dette avgjør om skjerming og sletting kan
#   avgrenses per behandlingsansvarlig.
