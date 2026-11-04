# language: no
# Jira: TOT-2597
# Bakgrunn: https://sikt.atlassian.net/wiki/spaces/PFS/pages/5151653925
#
# Scenarioene om å se, laste opp og slette dokumentasjon er flyttet hit fra
# søke_på_opptak.feature (@OPT-SØK-SØK-001), der de sto som utkast.
#
# Ikke med her:
# - Hvilken dokumentasjon søkeren må laste opp (@OPT-SØK-SØK-003).
# - Digitale resultater systemet har hentet (@OPT-SØK-SØK-004).
# - Sikkerheten i dokumenthåndteringen, som kryptering og tilgang (TOT-2378).
@OPT-SØK-SØK-019 @must @draft
Egenskap: Håndtere dokumentasjon i søknaden
  Som søker
  ønsker jeg å se, laste opp, gjenbruke og slette dokumentasjonen på søknadene mine
  slik at jeg vet hva saksbehandleren ser, og slipper å laste opp den samme dokumentasjonen flere ganger.

  # ÅPNE SPØRSMÅL:
  # - Tilhører dokumentasjonen søkeren eller søknaden? Akseptansekriteriene sier begge
  #   deler, og ingen beslutning er funnet (TOT-2590).
  # - Skal søkeren se all dokumentasjonen sin samlet på profilen, eller bare inne i hver
  #   søknad (spørsmål fra HK-dir etter demo)?

  Bakgrunn:
    Gitt jeg er innlogget på personflaten

  @ref-OPT-SØK-SØK-009 @openquestion
  Regel: Søkeren ser dokumentasjonen som er knyttet til søknaden
    # ÅPNE SPØRSMÅL:
    # - Skal søkeren se hvem som har lastet opp dokumentasjonen (søkeren eller saksbehandleren)?
    # - Ser søkeren dokumentasjon som Samordna opptak eller resultatutvekslingen har lastet
    #   opp på profilen (RT 519687)?

    Scenario: Søker ser dokumentasjonen søkeren har lastet opp
      Gitt jeg har lastet opp dokumentasjon på søknaden
      Når jeg åpner søknaden
      Så ser jeg dokumentasjonen jeg har lastet opp på søknaden

    Scenario: Søker ser dokumentasjonen saksbehandleren har lastet opp
      Gitt saksbehandleren har lastet opp dokumentasjon på søknaden
      Når jeg åpner søknaden
      Så ser jeg dokumentasjonen saksbehandleren har lastet opp på søknaden

  @ref-OPT-SØK-SØK-003 @openquestion
  Regel: Søkeren kan laste opp dokumentasjon før og etter at søknaden er sendt inn
    # Når opptaket er åpent for opplasting, står i veilede_om_dokumentasjon.feature.
    # ÅPNE SPØRSMÅL:
    # - Skal søkeren kunne laste opp den samme fila flere ganger, eller skal duplikatet
    #   avvises? Avvises det, hva får søkeren vite (RT 554975, 548611, 528808)?
    # - Skal søkeren få en bekreftelse på at dokumentasjonen er lagret (RT 510829,
    #   brukertester 2025)?

    Scenario: Søker laster opp dokumentasjon før søknaden er sendt inn
      Gitt jeg har startet en søknad på et opptak
      Når jeg laster opp dokumentasjon på søknaden
      Så ser jeg dokumentasjonen på søknaden

    Scenario: Søker laster opp dokumentasjon etter at søknaden er sendt inn
      Gitt jeg har sendt inn en søknad på et opptak
      Når jeg laster opp dokumentasjon på søknaden
      Så ser jeg dokumentasjonen på søknaden
      Og saksbehandleren ser dokumentasjonen på søknaden

  @openquestion
  Regel: Søkeren kan knytte dokumentasjon søkeren har lastet opp tidligere, til søknaden
    # ÅPNE SPØRSMÅL:
    # - Gjelder gjenbruken søknader i samme opptaksår, eller også fra år til år?
    # - Blir det ett dokument med flere koblinger, eller kopier? Det henger sammen med
    #   krypteringen per fil (TOT-2378).
    # - Hva ser saksbehandleren når søkeren senere fjerner dokumentasjon som er knyttet
    #   til søknaden?
    # - Kan søkeren knytte dokumentasjon før søknaden finnes (RT 548591, 548699)?
    # - Hva skjer med dokumentasjonen når søkeren trekker søknaden og søker på nytt i
    #   samme opptak, og saken gjenbrukes (S16)?

    Scenario: Søker knytter dokumentasjon fra en søknad i et annet opptak til søknaden
      Gitt jeg har lastet opp et vitnemål på søknaden i "Lokalt opptak A"
      Og jeg har startet en søknad i "Lokalt opptak B"
      Når jeg velger vitnemålet blant dokumentasjonen jeg har lastet opp tidligere
      Så ser jeg vitnemålet på søknaden i "Lokalt opptak B"

    Scenario: Dokumentasjon lastet opp på én søknad knyttes ikke til de andre søknadene
      Gitt jeg har søknader i "Lokalt opptak A" og "Lokalt opptak B"
      Når jeg laster opp en opptaksprøve på søknaden i "Lokalt opptak A"
      Så ser jeg ikke opptaksprøven på søknaden i "Lokalt opptak B"

    Scenario: Saksbehandleren ser bare dokumentasjonen som er knyttet til søknaden
      Gitt jeg har lastet opp et vitnemål på søknaden i "Lokalt opptak A"
      Og jeg har lastet opp en opptaksprøve på søknaden i "Lokalt opptak B"
      Når saksbehandleren åpner søknaden i "Lokalt opptak A"
      Så ser saksbehandleren vitnemålet
      Men saksbehandleren ser ikke opptaksprøven

  @ref-OPT-SØK-SØK-003 @openquestion
  Regel: Søkeren kan slette dokumentasjon søkeren har lastet opp
    # ÅPNE SPØRSMÅL:
    # - Hva betyr «slettet»: borte for søkeren, borte for saksbehandleren, eller borte fra
    #   lagringen? Det må stemme med TOT-2584.
    # - Kan søkeren slette dokumentasjon saksbehandleren har lastet opp, eller dokumentasjon
    #   som er brukt i saksbehandlingen?
    # - Er dokumentasjonen knyttet til flere søknader: slettes den fra søknaden, eller fra
    #   alle søknadene?
    # - Skal søkeren få en advarsel før dokumentasjonen slettes (RT 510829)?

    Scenario: Søker sletter dokumentasjon før søknaden er sendt inn
      Gitt jeg har lastet opp dokumentasjon på en søknad som ikke er sendt inn
      Når jeg sletter dokumentasjonen
      Så ser jeg ikke lenger dokumentasjonen på søknaden

    @openquestion
    Scenario: Søker sletter dokumentasjon etter at søknaden er sendt inn
      # ÅPNE SPØRSMÅL:
      # - Kan søkeren slette etter innsending? Til hvilken frist, og hva ser
      #   saksbehandleren etterpå?
      Gitt jeg har lastet opp dokumentasjon på en søknad som er sendt inn
      Når jeg sletter dokumentasjonen
      Så ser jeg ikke lenger dokumentasjonen på søknaden
      Og saksbehandleren ser ikke lenger dokumentasjonen på søknaden
