# language: no
# Utledet fra koden i fs-plattform (opptak), sjekket mot main 2026-10-28: SoknadshendelseJobb
# henter resultatene etter at sakene er opprettet, KregKlient (kompetanseoppnaelseByNasjonalId),
# KregVgsParser og VgsLagringService lagrer dem i kompetanse.vgs_dokument med fag,
# programområder og merknader. Hva som gjøres med resultatene etterpå (GSK, poeng, grunnlag og
# kravelementer), står i kravene i @ref-taggene.
@OPT-BEH-BEH-030 @must @in-progress @scope-automatisk-import-og-start @ref-OPT-BEH-BEH-015 @ref-OPT-BEH-BEH-018 @ref-OPT-BEH-BEH-019 @ref-OPT-BEH-BEH-020 @ref-OPT-BEH-BEH-032
Egenskap: Importere resultater fra KREG
  Som saksbehandler
  ønsker jeg at søkerens resultater fra videregående skole hentes fra KREG når saken er opprettet
  slik at søknaden behandles på resultatene søkeren har, uten at jeg må hente dem selv.

  KREG (Nasjonal vitnemålsdatabase) har søkerens vitnemål og kompetansebevis fra videregående
  skole. Opptakssystemet henter dem med søkerens fødselsnummer, eller D-nummer når søkeren ikke
  har fødselsnummer, og lagrer dem på søkeren, så de gjelder alle søknadene søkeren har.
  Saksbehandlingen og den automatiske behandlingen bygger på det som er lagret.

  # Avklart 29.10.2026: saksbehandleren henter ikke resultatene på nytt for én søker. Jobben for
  # nye vitnemål (OPT-BEH-BEH-032) er nok.

  # Avklart 30.10.2026: resultater fra høyere utdanning importeres også, men i et eget krav
  # (OPT-BEH-BEH-038). Tilleggspoeng for høyere utdanning (OPT-BEH-BEH-028) trenger dem.

  @ref-FLY-OPT-AUT-001 @ref-OPT-BEH-BEH-032
  Regel: Resultatene hentes når saken er opprettet

    @implemented
    Scenario: Resultatene hentes når søkeren sender inn søknaden
      Gitt at søkeren har et vitnemål i KREG
      Når søkeren sender inn søknaden
      Så er vitnemålet importert

    @implemented
    Scenario: Resultatene hentes når søknaden registreres på vegne av søkeren
      Gitt at søkeren har et vitnemål i KREG
      Når saksbehandleren registrerer søknaden på vegne av søkeren
      Så er vitnemålet importert

    @implemented
    Scenario: Resultatene hentes når en endring av søknaden gir en ny sak
      # Avklart 03.11.2026: resultatene hentes på nytt hver gang søknaden endres, også når
      # endringen ikke gir en ny sak. Det dekker hullet til jobben for nye vitnemål
      # (OPT-BEH-BEH-032) er levert.
      Gitt at søkerens vitnemål fra 2024 er importert
      Og at søkeren har fått et vitnemål fra 2025 i KREG
      Når søkeren legger til et studieønske som saksbehandles hos en ny organisasjon
      Så er vitnemålet fra 2025 importert

    @implemented
    Scenario: Resultatene hentes først når saken er opprettet
      # Avklart 29.10.2026: uten sak er det ikke noe å behandle. Koden gjør dette i dag.
      Gitt at opptaket mangler behandlertildelingsregel
      Og at søkeren har et vitnemål i KREG
      Når søkeren sender inn søknaden
      Så er vitnemålet ikke importert før saken er opprettet

    Scenario: Resultatene hentes med D-nummer når søkeren ikke har fødselsnummer
      # Avklart 03.11.2026. Kode i dag: bare fødselsnummer slås opp. KREG tar imot D-nummer.
      # D-nummeret brukes også når resultatene hentes på nytt, i jobben for nye vitnemål
      # (OPT-BEH-BEH-032).
      Gitt at søkeren har D-nummer og ikke fødselsnummer
      Og at søkeren har et vitnemål i KREG
      Når søkeren sender inn søknaden
      Så er vitnemålet importert

  @ref-FLY-OPT-AUT-001 @ref-FLY-OPT-VIT-001
  Regel: Alle vitnemål og kompetansebevis søkeren har i KREG, importeres

    Scenario: Det importerte vitnemålet har opplysningene saksbehandlingen trenger
      Gitt at søkeren har et vitnemål i KREG
      Når søkerens resultater importeres
      Så har det importerte vitnemålet disse opplysningene:
        | opplysning                                      |
        | utstedelsesdato                                 |
        | reform                                          |
        | avgangsår                                       |
        | om det er førstegangsvitnemål                   |
        | «GSK OK» fra KREG (skolens påstand om GSK)      |
        | fagene med karakterer                           |
        | programområdene                                 |
        | merknadene                                      |

    @implemented
    Scenario: Søker med flere vitnemål får alle importert
      Gitt at søkeren har to vitnemål i KREG, ett fra 2024 og ett fra 2025
      Når søkerens resultater importeres
      Så er begge vitnemålene importert

    @implemented
    Scenario: Kompetansebevis importeres
      Gitt at søkeren har et kompetansebevis i KREG
      Når søkerens resultater importeres
      Så er kompetansebeviset importert

    @implemented
    Scenario: Vitnemål som er importert fra før, importeres ikke på nytt
      Gitt at søkerens vitnemål er importert
      Når søkerens resultater importeres på nytt
      Så har søkeren vitnemålet én gang
      Og det importerte vitnemålet er uendret

  @ref-FLY-OPT-VIT-001 @implemented
  Regel: Et vitnemål som er annullert i KREG, er annullert i opptakssystemet

    Scenario: Annullert vitnemål importeres som annullert
      Gitt at søkeren har et annullert vitnemål i KREG
      Når søkerens resultater importeres
      Så er vitnemålet importert som annullert

    @ref-OPT-BEH-BEH-015
    Scenario: Vitnemål som annulleres etter importen, blir annullert
      # Hva annulleringen gjør med GSK-konklusjonen, står i OPT-BEH-BEH-015, og hva den gjør
      # med saken, står i OPT-BEH-BEH-034.
      Gitt at søkerens vitnemål er importert
      Og at vitnemålet er annullert i KREG etter importen
      Når søkerens resultater importeres på nytt
      Så er det importerte vitnemålet annullert

    Scenario: Vitnemålet blir stående som annullert når KREG opphever annulleringen
      # Avklart 29.10.2026: opphevede annulleringer tas ikke inn. Koden gjør dette i dag.
      Gitt at søkerens importerte vitnemål er annullert
      Og at KREG har opphevet annulleringen
      Når søkerens resultater importeres på nytt
      Så er det importerte vitnemålet fortsatt annullert

  Regel: Søknaden behandles videre når resultatene ikke kan hentes

    @deprecated
    Scenario: Søker uten fødselsnummer får ingen resultater importert
      Gitt at søkeren ikke har fødselsnummer
      Når søkeren sender inn søknaden
      Så er ingen resultater importert fra KREG

    Scenario: Søker uten fødselsnummer og D-nummer får ingen resultater importert
      Gitt at søkeren verken har fødselsnummer eller D-nummer
      Når søkeren sender inn søknaden
      Så er ingen resultater importert fra KREG

    Scenario: Resultatene hentes når KREG svarer igjen
      # Avklart 29.10.2026: hentingen prøves på nytt. Hvor mange ganger, og hvor lenge, står i
      # applikasjonsinnstillingene. Feilen vises ikke for saksbehandleren, men skrives i
      # applikasjonsloggen, og Sikt varsles. Kode i dag: feilen logges, og hentingen prøves ikke
      # igjen før søknaden endres.
      Gitt at KREG ikke svarte da søkeren sendte inn søknaden
      Når KREG svarer igjen innenfor tiden i applikasjonsinnstillingene
      Så er søkerens vitnemål importert

  @ref-OPT-BEH-BEH-021 @ref-FLY-OPT-VIT-001 @ref-OPT-BEH-BEH-032
  Regel: Nye og annullerte vitnemål i KREG importeres for aktive søkere
    # Gjelder aktive søkere: søkere med en søknad som ikke er trukket, i et opptak som ikke er
    # avsluttet.
    # Avklart 29.10.2026: nytt vitnemål og annullering tas inn. Opphevet annullering og endringer i
    # et vitnemål som er importert, tas ikke inn.
    # Jobben for nye vitnemål (OPT-BEH-BEH-032) går gjennom alle aktive søkere, og henter
    # vitnemålene fra KREG for hver søker. Det som ikke er importert fra før, eller som er
    # annullert i KREG, er nytt.
    # Et nytt vitnemål i en sak som er behandlet, er ny dokumentasjon. Saken behandles ikke
    # automatisk på nytt (OPT-BEH-BEH-032). Når vitnemålet annulleres, gjelder OPT-BEH-BEH-034.
    # Varselet til saksbehandleren om nytt vitnemål står i OPT-BEH-BEH-021.

    Scenario: Søkeren får vitnemålet etter at søknaden er levert
      Gitt at søkeren har levert søknaden uten å ha et vitnemål i KREG
      Og at opptaket ikke er avsluttet
      Når KREG får et vitnemål for søkeren
      Så er vitnemålet importert uten at søkeren har endret søknaden

    Scenario: Vitnemålene hentes én gang for søkeren med søknader i flere opptak
      Gitt at søkeren har søknader i to opptak som ikke er avsluttet
      Når importen av VGS-vitnemål fra KREG kjører
      Så hentes søkerens VGS-dokumenter fra KREG én gang

    Scenario: Vitnemålene hentes ikke for søkeren som ikke er aktiv
      Gitt at søkeren ikke har noen søknad som ikke er trukket, i et opptak som ikke er avsluttet
      Når importen av VGS-vitnemål fra KREG kjører
      Så hentes ingen VGS-dokumenter for søkeren fra KREG

    Scenario: Vitnemålet annulleres og erstattes av et nytt etter at opptakssystemet har behandlet søknaden
      Gitt at opptakssystemet har behandlet søknaden på søkerens importerte vitnemål
      Og at opptaket ikke er avsluttet
      Når vitnemålet annulleres i KREG
      Og søkeren får et nytt vitnemål i KREG
      Så er det importerte vitnemålet annullert
      Og det nye vitnemålet er importert

    Scenario: Vitnemålet annulleres uten at det kommer et nytt, etter at opptakssystemet har behandlet søknaden
      Gitt at opptakssystemet har behandlet søknaden på søkerens importerte vitnemål
      Og at opptaket ikke er avsluttet
      Når vitnemålet annulleres i KREG
      Så er det importerte vitnemålet annullert
      Og søkeren har ikke noe importert vitnemål som ikke er annullert
