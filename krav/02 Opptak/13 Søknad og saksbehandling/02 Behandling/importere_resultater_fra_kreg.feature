# language: no
# Utledet fra koden i fs-plattform (opptak), sjekket mot main 2026-10-28: SoknadshendelseJobb
# henter resultatene etter at sakene er opprettet, KregKlient (kompetanseoppnaelseByNasjonalId),
# KregVgsParser og VgsLagringService lagrer dem i kompetanse.vgs_dokument med fag,
# programområder og merknader. Hva som gjøres med resultatene etterpå (GSK, poeng, grunnlag og
# kravelementer), står i kravene i @ref-taggene.
@OPT-BEH-BEH-029 @must @draft @ref-OPT-BEH-BEH-015 @ref-OPT-BEH-BEH-018 @ref-OPT-BEH-BEH-019 @ref-OPT-BEH-BEH-020
Egenskap: Importere resultater fra KREG
  Som saksbehandler
  ønsker jeg at søkerens resultater fra videregående skole hentes fra KREG når søknaden kommer inn
  slik at søknaden behandles på resultatene søkeren har, uten at jeg må hente dem selv.

  KREG (Nasjonal vitnemålsdatabase) har søkerens vitnemål og kompetansebevis fra videregående
  skole. Opptakssystemet henter dem med søkerens fødselsnummer og lagrer dem på søkeren, så de gjelder
  alle søknadene søkeren har. Saksbehandlingen og den automatiske behandlingen bygger på det
  som er lagret.

  # ÅPNE SPØRSMÅL:
  # - Skal resultater fra høyere utdanning (Vitnemålsportalen) importeres på samme måte?
  #   Tilleggspoeng for høyere utdanning (OPT-BEH-BEH-028) trenger dem.
  # - Skal saksbehandleren kunne hente resultatene på nytt for én søker?

  @ref-FLY-OPT-AUT-001
  Regel: Resultatene hentes når søknaden kommer inn

    Scenario: Resultatene hentes når søkeren sender inn søknaden
      Gitt at søkeren har et vitnemål i KREG
      Når søkeren sender inn søknaden
      Så er vitnemålet importert

    Scenario: Resultatene hentes når søknaden registreres på vegne av søkeren
      Gitt at søkeren har et vitnemål i KREG
      Når saksbehandleren registrerer søknaden på vegne av søkeren
      Så er vitnemålet importert

    @openquestion
    Scenario: Resultatene hentes på nytt når søkeren endrer søknaden
      # ÅPNE SPØRSMÅL:
      # - Koden henter resultatene på nytt hver gang søknaden fordeles på nytt, også når søkeren
      #   endrer søknaden. Det følger av fordelingen, og er ikke beskrevet som et mål. Skal
      #   resultatene hentes på nytt når søknaden endres, eller er det nok med abonnementet?
      Gitt at søkerens vitnemål fra 2024 er importert
      Og at søkeren har fått et vitnemål fra 2025 i KREG
      Når søkeren endrer søknaden
      Så er vitnemålet fra 2025 importert

    @openquestion
    Scenario: Resultatene hentes før søknaden er fordelt
      # ÅPNE SPØRSMÅL:
      # - I dag hentes resultatene først når sakene er opprettet. Mangler opptaket regler for å
      #   fordele søknadene, venter hentingen også. Skal resultatene hentes uansett?
      Gitt at opptaket mangler saksbehandlertildelingsregel
      Og at søkeren har et vitnemål i KREG
      Når søkeren sender inn søknaden
      Så er vitnemålet importert

  @ref-FLY-OPT-AUT-001
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
        | påstanden fra KREG om generell studiekompetanse |
        | fagene med karakterer                           |
        | programområdene                                 |
        | merknadene                                      |

    Scenario: Søker med flere vitnemål får alle importert
      Gitt at søkeren har to vitnemål i KREG, ett fra 2024 og ett fra 2025
      Når søkerens resultater importeres
      Så er begge vitnemålene importert

    Scenario: Kompetansebevis importeres
      Gitt at søkeren har et kompetansebevis i KREG
      Når søkerens resultater importeres
      Så er kompetansebeviset importert

    Scenario: Vitnemål som er importert fra før, importeres ikke på nytt
      Gitt at søkerens vitnemål er importert
      Når søkerens resultater importeres på nytt
      Så har søkeren vitnemålet én gang
      Og det importerte vitnemålet er uendret

  Regel: Et vitnemål som er annullert i KREG, er annullert i opptakssystemet

    Scenario: Annullert vitnemål importeres som annullert
      Gitt at søkeren har et annullert vitnemål i KREG
      Når søkerens resultater importeres
      Så er vitnemålet importert som annullert

    @ref-OPT-BEH-BEH-015
    Scenario: Vitnemål som annulleres etter importen, blir annullert
      # Hva annulleringen gjør med GSK-konklusjonen, står i OPT-BEH-BEH-015.
      Gitt at søkerens vitnemål er importert
      Og at vitnemålet er annullert i KREG etter importen
      Når søkerens resultater importeres på nytt
      Så er det importerte vitnemålet annullert

    @openquestion
    Scenario: Vitnemålet blir stående som annullert når KREG opphever annulleringen
      # ÅPNE SPØRSMÅL:
      # - Koden gjør dette med vilje. Er det riktig, eller skal opphevingen tas inn?
      Gitt at søkerens importerte vitnemål er annullert
      Og at KREG har opphevet annulleringen
      Når søkerens resultater importeres på nytt
      Så er det importerte vitnemålet fortsatt annullert

  Regel: Søknaden behandles videre når resultatene ikke kan hentes

    @openquestion
    Scenario: Søker uten fødselsnummer får ingen resultater importert
      # ÅPNE SPØRSMÅL:
      # - Skal søkere med D-nummer slås opp i KREG?
      Gitt at søkeren ikke har fødselsnummer
      Når søkeren sender inn søknaden
      Så er ingen resultater importert fra KREG

    @openquestion
    Scenario: Resultatene hentes når KREG svarer igjen
      # ÅPNE SPØRSMÅL:
      # - I dag logges feilen, og hentingen prøves ikke igjen før søknaden endres. Skal den prøves
      #   igjen av seg selv? Skal saksbehandleren se at importen feilet?
      Gitt at KREG ikke svarte da søkeren sendte inn søknaden
      Når KREG svarer igjen
      Så er søkerens vitnemål importert

  @openquestion @ref-OPT-BEH-BEH-021
  Regel: Endringer i KREG importeres gjennom et abonnement
    # ÅPNE SPØRSMÅL:
    # - Hvordan abonnementet skal virke, er ikke avklart, og hører til KREG-teamet.
    # - Hvilke søkere abonnerer opptaket på, og hvor lenge? Alle med aktive søknader, eller
    #   bare til opptaket er avsluttet?
    # - Hvilke endringer skal komme: nytt vitnemål, annullering, opphevet annullering?
    # Varselet til saksbehandleren om nytt vitnemål står i OPT-BEH-BEH-021.

    Scenario: Nytt vitnemål i KREG importeres uten at søkeren endrer søknaden
      Gitt at søkeren har en søknad i et opptak som ikke er avsluttet
      Når KREG får et nytt vitnemål for søkeren
      Så er vitnemålet importert uten at søkeren har endret søknaden

    Scenario: Annullering i KREG importeres uten at søkeren endrer søknaden
      Gitt at søkerens vitnemål er importert
      Og at søkeren har en søknad i et opptak som ikke er avsluttet
      Når vitnemålet annulleres i KREG
      Så er det importerte vitnemålet annullert uten at søkeren har endret søknaden
