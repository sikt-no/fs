# language: no
# GitHub: #572
@OPT-SØK-SØK-003 @must @planned
Egenskap: Veilede søker om hvilken dokumentasjon som skal lastes opp
  Som søker
  ønsker jeg å vite hvilken dokumentasjon søknaden min krever
  slik at jeg ikke sender inn opplysninger som ikke skal behandles.

  Bakgrunn:
    Gitt jeg er innlogget på personflaten
    Og jeg har startet en søknad på et opptak

  Regel: Søker får vite hvilken dokumentasjon søknaden krever

    @openquestion
    Scenario: Søker ser hvilken dokumentasjon som er etterspurt
      Når jeg skal laste opp dokumentasjon på søknaden
      Så ser jeg hvilken dokumentasjon som er etterspurt for denne søknaden
      # ÅPNE SPØRSMÅL:
      # - Hvor kommer listen over etterspurt dokumentasjon fra? Er den knyttet
      #   til opptaket, til utdanningstilbudet, eller til hva søkeren søker på
      #   grunnlag av (dispensasjon, tidlig opptak, realkompetanse)? Det finnes
      #   ingen krav som beskriver denne sammenhengen i dag.
      #   Delsvar 08.10.2026: For tidlig opptak er dokumentasjonskravet knyttet til
      #   begrunnelsen søkeren velger, og settes per opptak (søke_om_tidlig_opptak.feature).
      #   Dispensasjon og realkompetanse er ikke avklart.

    Scenario: Søker får vite at uetterspurt dokumentasjon kan bli slettet
      Når jeg skal laste opp dokumentasjon på søknaden
      Så får jeg vite at dokumentasjon som ikke er etterspurt kan bli slettet

  Regel: Søker velger dokumenttype ved opplasting

    Scenariomal: Søker angir hva dokumentet er
      Når jeg laster opp et dokument
      Og jeg angir at dokumentet er av typen <dokumenttype>
      Så er dokumentet registrert med typen <dokumenttype>

      Eksempler:
        | dokumenttype                    |
        | Vitnemål eller karakterutskrift |
        | Legeerklæring                   |
        | Politiattest                    |
        | Annen dokumentasjon             |

  Regel: Personopplysninger fra autoritative kilder skal ikke dokumenteres

    # Resultater søkeren allerede har registrert — fra videregående skole og
    # fra høyere utdanning — eies av @OPT-SØK-SØK-004
    # (se_digitale_resultater_i_søknad.feature, #604). Snittet mellom kravene:
    # dette kravet dekker hva søkeren må laste opp, #604 dekker hva søkeren
    # slipper å laste opp.
    # TODO: Personopplysninger fra folkeregisteret er en annen datakilde enn
    # resultatene i #604 og bør på sikt skilles ut som eget krav.

    Scenario: Søker slipper å dokumentere personopplysninger
      Gitt personopplysningene mine er hentet fra folkeregisteret
      Når jeg fyller ut søknaden
      Så blir jeg ikke bedt om å dokumentere navn, fødselsnummer eller adresse

  @draft
  Regel: Søkeren kan laste opp dokumentasjon bare når opptaket åpner for det
    # Virkningen av innstillingen for opplasting av dokumentasjon som opptaksforvalter setter i
    # 11 Opprette og vedlikeholde opptak/03 Innstillinger/innstillinger.feature.
    # Lagt til 2026-10-19 etter akseptansetesten av opprette og vedlikeholde opptak.
    # AVKLART 2026-10-27 (produkteier, etter akseptansetesten): Det er bare innstillingen som stenger for
    # opplasting, ikke informasjonsdatoen for dokumentasjon eller ettersendingsfristen.

    # AVKLART 2026-10-15 (Q1, TAKE-413): Standardverdien er at søkerne kan laste opp dokumentasjon.
    Scenario: Søker kan laste opp dokumentasjon når opptaksforvalter ikke har stengt for det
      Gitt opptaksforvalter ikke har stengt opptaket for opplasting av dokumentasjon
      Når jeg laster opp et dokument på søknaden
      Så er dokumentet lastet opp på søknaden

    Scenario: Søker kan ikke laste opp eller ettersende dokumentasjon når opptaket har stengt for opplasting
      Gitt opptaket har stengt for opplasting av dokumentasjon
      Når jeg vil laste opp et dokument på søknaden
      Så kan jeg ikke laste opp dokumentet
      Og jeg kan ikke ettersende dokumentasjon på søknaden

    # AVKLART 2026-10-15 (Q17, TAKE-413): Saksbehandler kan fortsatt registrere dokumentasjon på søknaden.
    Scenario: Saksbehandler kan registrere dokumentasjon på søknaden når opptaket har stengt for opplasting
      Gitt opptaket har stengt for opplasting av dokumentasjon
      Når saksbehandleren registrerer et dokument på søknaden min
      Så er dokumentet registrert på søknaden

  @draft @openquestion
  Regel: Søkeren ser informasjonsdatoen for dokumentasjon i opptaket
    # ÅPNE SPØRSMÅL:
    # - Hva skal søkeren få vite om ettersendingsfristen, når den ikke stenger for opplasting? Er den en frist
    #   for mangler, eller en informasjonsdato (11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature)?

    # Virkningen av informasjonsdatoen for dokumentasjon som opptaksforvalter setter i
    # 11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature.
    # Lagt til 2026-10-19 etter akseptansetesten av opprette og vedlikeholde opptak.
    # AVKLART 2026-10-15 (Q14, TAKE-411): Datoen er informasjon om når dokumentasjonen bør være lastet opp.
    # AVKLART 2026-10-27 (produkteier, etter akseptansetesten): Ingen dato stenger for opplasting. Det gjør bare
    # innstillingen for opplasting, se regelen over.

    Scenario: Søker ser informasjonsdatoen for dokumentasjon
      Gitt informasjonsdatoen for dokumentasjon i opptaket er "2027-04-15 23:59"
      Og jeg har en utdanningsbakgrunn uten avvikende frister
      Når jeg skal laste opp dokumentasjon på søknaden
      Så ser jeg at dokumentasjonen bør være lastet opp innen "2027-04-15 23:59"

    Scenario: Søker kan laste opp dokumentasjon etter informasjonsdatoen
      Gitt informasjonsdatoen for dokumentasjon i opptaket er "2027-04-15 23:59"
      Og opptaket er åpent for opplasting av dokumentasjon
      Når jeg laster opp et dokument på søknaden "2027-05-02"
      Så er dokumentet lastet opp på søknaden

# ÅPNE SPØRSMÅL:
# - Ordlyden i veiledningen er ikke fastsatt her. Konkret tekst, plassering og
#   utforming hører i en <feature>.design.md ved siden av denne fila, jf.
#   fs-implementasjonsdetaljer-skillen. Steffen Andre Marstein har en åpen oppgave
#   om UX for dokumentopplasting fra møtet 28.08.2026.
# - Løsningen begrenser ikke hva søkeren kan laste opp — det er en bevisst
#   beslutning. Juristens tiltak om å begrense dokumentkategorier er derfor
#   ikke dekket av dette kravet.
