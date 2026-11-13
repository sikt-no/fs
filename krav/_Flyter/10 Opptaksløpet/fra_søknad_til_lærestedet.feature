# language: no
@FLY-OPT-SØK-001 @must @draft @e2e
Egenskap: Fra søknad til lærestedet
  Fra søkeren begynner på søknaden i Min kompetanse, til lærestedene finner søknaden i FS Admin.
  Søkeren ser opplysningene om seg selv, velger utdanningstilbud, ser resultatene og laster opp
  dokumentasjon, og sender inn søknaden. Søknadsalternativene fordeles til behandleren, og
  forvalteren, tilbyderen og behandleren ser søknaden med den samme dokumentasjonen som søkeren
  ser, og finner den med filtrene i saksoversikten.
  # Ikke med (2026-11-13): Samtykke til lagring av dokumentasjon er tatt ut av flyten. Det skal
  # avklares internt og med HK-dir før det tas inn igjen. Juristen har vurdert samtykke som lite
  # egnet behandlingsgrunnlag for dokumentasjon (se OPT-BEH-DOK-002).

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" forvaltes av HK-dir
    Og at "Universitetet i Oslo" og "UiT Norges arktiske universitet" deltar i opptaket
    Og at opptaket har en standard behandlertildelingsregel med «Alle som deltar i opptaket»
    Og at søknaden i opptaket har åpnet

  @openquestion
  Regel: Søkeren ser opplysningene om seg selv i søknaden
    # ÅPNE SPØRSMÅL:
    # - Kravet mangler. Personprofilen i personflaten (OPP-PRO-PRO-002) har ingen status, og sier
    #   ikke hva søkeren ser i søknaden. Skal fasen bygge på OPP-PRO-PRO-002, eller trengs et krav
    #   i 01 Søknad?
    # - Er overleveringen opplysningene fra Folkeregisteret og KRR, som saksbehandleren også ser
    #   (OPT-BEH-BEH-043)?

    Scenario: Søkeren ser opplysningene fra Folkeregisteret og KRR i søknaden
      Gitt at søkeren finnes i Folkeregisteret og KRR
      Når søkeren begynner på en søknad i "Samordna opptak 2027"
      Så ser søkeren opplysningene om seg selv fra Folkeregisteret og KRR

  @depends-on-OPT-SØK-SØK-013 @depends-on-OPT-SØK-SØK-005 @depends-on-OPT-SØK-SØK-006
  Regel: Søkeren velger utdanningstilbudene i søknaden

    Scenario: Utdanningstilbudene fra studiekurven blir søknadsalternativer
      Gitt at søkeren har lagt "Informatikk, UiO" og "Historie, UiT" i studiekurven
      Når søkeren legger "Informatikk, UiO" og "Historie, UiT" til i søknaden i den rekkefølgen
      Så har søknaden "Informatikk, UiO" som første og "Historie, UiT" som andre søknadsalternativ

  @depends-on-OPT-SØK-SØK-004 @depends-on-OPT-SØK-SØK-019
  Regel: Søkeren ser resultatene og laster opp dokumentasjon i søknaden

    Scenario: Søkeren ser de digitale resultatene i søknaden
      Gitt at søkeren har digitale resultater
      Når søkeren åpner steget «Dokumentasjon» i søknaden
      Så ser søkeren de digitale resultatene

    Scenario: Søkeren laster opp et vitnemål på søknaden
      Gitt at søkeren har begynt på en søknad i "Samordna opptak 2027"
      Når søkeren laster opp et vitnemål på søknaden
      Så ser søkeren vitnemålet på søknaden

  @depends-on-FLY-OPT-SAK-001 @depends-on-OPT-SØK-SØK-001
  # FLY-OPT-SAK-001: «Søknadsalternativene fordeles når søknaden sendes»
  # OPT-SØK-SØK-001: «Søkeren kan begynne på og sende inn en søknad bare når søknaden i opptaket har åpnet»
  Regel: Søknadsalternativene fordeles til behandleren når søknaden sendes inn

    Scenario: Søknaden blir én sak hos behandleren
      Gitt at søknaden har "Informatikk, UiO" og "Historie, UiT" i den rekkefølgen
      Når søkeren sender inn søknaden
      Så er "Universitetet i Oslo" behandler for "Informatikk, UiO" og "Historie, UiT"
      Og søknaden har én sak hos "Universitetet i Oslo"

  @depends-on-OPT-BEH-BEH-043 @depends-on-OPT-BEH-DOK-001
  Regel: Forvalteren, tilbyderen og behandleren ser dokumentasjonen fra søkeren

    Scenariomal: Organisasjonene med rolle i søknaden ser dokumentasjonen fra søkeren
      Gitt at søkeren har lastet opp et vitnemål på søknaden i Min kompetanse
      Og at søkeren har sendt inn søknaden med "Informatikk, UiO" og "Historie, UiT"
      Når <rolle> ved <organisasjon> åpner søknaden i FS Admin
      Så ser den ansatte vitnemålet søkeren har lastet opp
      Og den ansatte ser de digitale resultatene søkeren ser i søknaden

      Eksempler:
        | rolle            | organisasjon                      | organisasjonens rolle |
        | opptaksforvalter | "HK-dir"                          | forvalter             |
        | saksbehandler    | "Universitetet i Oslo"            | behandler             |
        | saksbehandler    | "UiT Norges arktiske universitet" | tilbyder              |

  @depends-on-OPT-BEH-BEH-046
  # Åpne spørsmål om saksoversikten (sortering, hvordan filtrene kombineres, filtre som mangler,
  # og synligheten) står i kravet.
  Regel: Lærestedet finner søknaden med filtrene i saksoversikten

    Scenariomal: Rollefilteret skiller sakene lærestedet behandler fra sakene et annet lærested behandler
      Gitt at søkeren har sendt inn søknaden med "Informatikk, UiO" og "Historie, UiT"
      Når saksbehandleren ved <organisasjon> filtrerer saksoversikten på at organisasjonen er <rolle>
      Så finner saksbehandleren søknaden

      Eksempler:
        | organisasjon                      | rolle     |
        | "Universitetet i Oslo"            | behandler |
        | "UiT Norges arktiske universitet" | tilbyder  |

    Scenario: Dokumentasjonsfilteret finner søknaden med ubehandlet dokumentasjon
      Gitt at søkeren har lastet opp et vitnemål etter at søknaden er sendt inn
      Når saksbehandleren ved Universitetet i Oslo filtrerer saksoversikten på ubehandlet opplastet dokumentasjon
      Så finner saksbehandleren søknaden

    Scenario: Studiumfilteret finner søknaden på søknadsalternativet
      Gitt at søkeren har sendt inn søknaden med "Informatikk, UiO" og "Historie, UiT"
      Når saksbehandleren ved UiT Norges arktiske universitet filtrerer saksoversikten på "Historie, UiT"
      Så finner saksbehandleren søknaden
