# language: no
# GitHub: #570
@OPT-BEH-DOK-001 @must @draft
Egenskap: Skjerme dokumentasjon med særlige kategorier av personopplysninger
  Som søker
  ønsker jeg at dokumentasjon jeg laster opp kun er tilgjengelig for de som behandler søknaden min
  slik at opplysningene mine ikke er synlige for uvedkommende.

  Bakgrunn:
    Gitt jeg er innlogget i FS Admin

  Regel: Tilgang til søknadsdokumentasjon krever tjenstlig behov

    Scenario: Saksbehandler på opptaket ser dokumentasjonen
      Gitt jeg er saksbehandler for opptaket søknaden gjelder
      Når jeg åpner søknaden
      Så ser jeg dokumentasjonen som er lastet opp på søknaden

    Scenario: Saksbehandler uten tilknytning til opptaket ser ikke dokumentasjonen
      Gitt jeg er saksbehandler ved organisasjonen som behandler søknaden
      Men jeg er ikke saksbehandler for opptaket søknaden gjelder
      Når jeg åpner søknaden
      Så ser jeg ikke dokumentasjonen som er lastet opp på søknaden

    Scenario: Bruker ved annen organisasjon ser ikke dokumentasjonen
      Gitt jeg er saksbehandler ved en annen organisasjon enn den som behandler søknaden
      Når jeg åpner søknaden
      Så ser jeg ikke dokumentasjonen som er lastet opp på søknaden

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

    Scenario: Saksbehandler markerer et dokument som sensitivt
      Gitt søkeren har lastet opp et dokument av typen "Annen dokumentasjon"
      Og jeg er saksbehandler for opptaket søknaden gjelder
      Når jeg markerer dokumentet som sensitivt
      Så er dokumentet markert som sensitivt for alle som behandler søknaden

    @openquestion
    Scenario: Feilaktig markering kan fjernes
      Gitt et dokument er markert som sensitivt
      Når jeg fjerner markeringen
      Så er dokumentet ikke lenger markert som sensitivt
      # ÅPNE SPØRSMÅL:
      # - Skal markeringen kunne fjernes, og av hvem? Å fjerne en markering
      #   svekker vernet, så det bør kanskje kreve samme rolle som sletting.

  Regel: Politiattest skal oppbevares utilgjengelig for uvedkommende

    @openquestion
    Scenario: Politiattest er skjermet også fra saksbehandlere på opptaket
      Gitt søkeren har lastet opp et dokument av typen "Politiattest"
      Og jeg er saksbehandler for opptaket søknaden gjelder
      Når jeg åpner søknaden
      Så ser jeg at en politiattest er levert
      Men jeg ser ikke innholdet i politiattesten
      # ÅPNE SPØRSMÅL:
      # - Politiregisterforskriften § 37-2 krever at attesten oppbevares
      #   utilgjengelig for uvedkommende. Er en saksbehandler på opptaket
      #   "vedkommende", eller skal kun den som gjennomfører vandelskontroll
      #   se innholdet? Juristen navngir ikke rollen.

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
