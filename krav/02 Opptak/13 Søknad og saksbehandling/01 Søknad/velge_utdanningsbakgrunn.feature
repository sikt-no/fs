# language: no
# GitHub: #632, #215, #413
#
# Kilder: Confluence PFS 4408344578 «Utdanningsbakgrunn» og
# PFS 3940188262 «2025-08-15: Utdanningsbakgrunn - Møte med HK-dir», og
# PFS 5146017797 «2026-10-27: Utdanningsbakgrunn – planlegging av videre implementasjon».
# Figma: Min kompetanse, node 20670-24098. Team Tind-epic TOT-1738.
@OPT-SØK-SØK-017 @must @draft @ref-OPT-SØK-SØK-001 @ref-OPT-BEH-BEH-011
Egenskap: Velge utdanningsbakgrunn i søknad
  Som søker
  ønsker jeg å oppgi hvilken utdanningsbakgrunn jeg har
  slik at søknaden min behandles av riktig instans og etter riktige regler.
  # Fristene som følger utdanningsbakgrunnen, står i @OPT-SØK-SØK-001, og fordelingen
  # av søknader etter utdanningsbakgrunn står i @OPT-BEH-BEH-011.

  Bakgrunn:
    Gitt at søkeren er innlogget i Min kompetanse
    Og at søkeren har startet en søknad i opptaket "Samordna opptak 2027"

  @depends-on-OPT-OVO-INN-001
  Regel: Søkeren velger utdanningsbakgrunn blant utdanningsbakgrunnene i opptaket
    # Utdanningsbakgrunnene i opptaket legges til av opptaksforvalter.
    # Flyttet hit fra søke_på_opptak.feature 2026-10-26.

    Scenario: Søkeren velger blant utdanningsbakgrunnene i opptaket
      Gitt at opptaket har utdanningsbakgrunnene "Realkompetanse", "Utenlandsk videregående skole" og "Rudolf Steinerskole"
      Når søkeren skal velge utdanningsbakgrunn i søknaden
      Så kan søkeren velge mellom "Realkompetanse", "Utenlandsk videregående skole" og "Rudolf Steinerskole"

    Scenario: En utdanningsbakgrunn som er fjernet fra opptaket, kan ikke velges
      Gitt at opptaksforvalter har fjernet utdanningsbakgrunnen "Rudolf Steinerskole" fra opptaket
      Når søkeren skal velge utdanningsbakgrunn i søknaden
      Så kan søkeren ikke velge "Rudolf Steinerskole"

    @openquestion
    Scenario: Utdanningsbakgrunnen velges per søknad
      # ÅPNE SPØRSMÅL:
      # - Skal alle opptak ha utdanningsbakgrunn, eller bare UHG-opptak (samordna opptak)?
      #   Avklares i TOT-2586. Gjelder det bare UHG, blir ikke søkeren spurt om
      #   utdanningsbakgrunn i "Lokalt opptak høst 2027", og scenarioet må skrives om.
      Gitt at søkeren har valgt "Rudolf Steinerskole" i søknaden til "Samordna opptak 2027"
      Når søkeren starter en søknad i opptaket "Lokalt opptak høst 2027"
      Så er ingen utdanningsbakgrunn valgt i søknaden til "Lokalt opptak høst 2027"

    # AVKLART 2026-10-19 (S4): Det skal ikke være mulig å registrere en søknad uten utdanningsbakgrunn.
    @openquestion
    Scenario: Søknaden kan ikke sendes inn uten utdanningsbakgrunn
      # ÅPNE SPØRSMÅL:
      # - Skal alle opptak ha utdanningsbakgrunn, eller bare UHG-opptak (samordna opptak)?
      #   Avklares i TOT-2586. Gjelder det bare UHG, blir ikke søkeren spurt om
      #   utdanningsbakgrunn i andre opptak.
      Gitt at søkeren ikke har valgt utdanningsbakgrunn i søknaden
      Når søkeren vil sende inn søknaden
      Så kan søkeren ikke sende inn søknaden
      Og søkeren får beskjed om å velge utdanningsbakgrunn

  @openquestion
  Regel: Søkeren kan endre utdanningsbakgrunn etter at søknaden er sendt inn
    # ÅPNE SPØRSMÅL:
    # - Skal søkeren selv kunne endre utdanningsbakgrunnen etter at søknaden er sendt inn,
    #   eller er det bare saksbehandleren som kan det?
    # - Hvis søkeren kan det: til hvilken frist? Søknadsfristen, fristen for endring av
    #   utdanningsbakgrunn (@OPT-OVO-FRI-001), eller en annen frist?
    # Kilde: HK-Dir-historiene 9467 «Endre utdanningsbakgrunn» og 9448 «Endre innsendt søknad».
    # Saksbehandlerens endring hører til søknadsbehandlingen. Hvilken organisasjon som
    # saksbehandler søknaden etter endringen, står i @OPT-BEH-BEH-011.

    Scenario: Søkeren endrer utdanningsbakgrunn i en innsendt søknad
      Gitt at søkeren har sendt inn søknaden med utdanningsbakgrunnen "Utenlandsk videregående skole"
      Når søkeren endrer utdanningsbakgrunnen til "Rudolf Steinerskole"
      Så er "Rudolf Steinerskole" registrert som utdanningsbakgrunn i søknaden

  Regel: Søkeren oppgir utdanningsland når utdanningsbakgrunnen krever det
    # AVKLART 2026-10-27 (planleggingsmøte): Hvilke utdanningsbakgrunner som krever utdanningsland,
    # er en forretningsregel som ligger fast i backend. Søkeren oppgir land både for
    # «Utenlandsk videregående skole» og «Nordisk videregående skole». De nordiske landene
    # hører til «Nordisk videregående skole» (skissen og HK-dir).

    Scenariomal: Søkeren oppgir utdanningsland for <utdanningsbakgrunn>
      Når søkeren velger utdanningsbakgrunnen "<utdanningsbakgrunn>"
      Og søkeren velger utdanningslandet "<land>"
      Så er "<land>" registrert som utdanningsland i søknaden

      Eksempler:
        | utdanningsbakgrunn            | land     |
        | Utenlandsk videregående skole | Tyskland |
        | Nordisk videregående skole    | Sverige  |

    Scenario: Søkeren med nordisk videregående skole velger blant de nordiske landene
      Når søkeren velger utdanningsbakgrunnen "Nordisk videregående skole"
      Så kan søkeren velge utdanningsland blant
        | land     |
        | Danmark  |
        | Finland  |
        | Færøyene |
        | Grønland |
        | Island   |
        | Sverige  |

    Scenario: Nordiske land kan ikke velges for utenlandsk videregående skole
      Når søkeren velger utdanningsbakgrunnen "Utenlandsk videregående skole"
      Så kan søkeren ikke velge "Sverige" som utdanningsland

    Scenario: Søknaden kan ikke sendes inn uten påkrevd utdanningsland
      Gitt at utdanningsbakgrunnen "Utenlandsk videregående skole" krever utdanningsland
      Og at søkeren har valgt "Utenlandsk videregående skole" uten å oppgi utdanningsland
      Når søkeren vil sende inn søknaden
      Så kan søkeren ikke sende inn søknaden
      Og søkeren får beskjed om å oppgi utdanningsland

  @openquestion @ref-OPT-BEH-BEH-008
  Regel: Søkeren oppgir at norsk videregående opplæring fullføres i vår
    # Flyttet hit fra oppgi_at_generell_studiekompetanse_fullføres_i_vår.feature 2026-10-28.
    # Feature-ID-en var @OPT-SØK-SØK-013, som også brukes av finne_studier.feature.
    # Det betyr at vitnemålet kommer senere. Alle sakene i søknaden får da automatisk mangelen
    # for generell studiekompetanse som fullføres i vår (DUA), og mangelen sjekkes ut når saken
    # er behandlet helautomatisk.
    # AVKLART 2026-10-28: Søkeren kan oppgi det uansett hvilken utdanningsbakgrunn som er valgt.
    # AVKLART 2026-10-28: «Norsk videregående opplæring fullføres i vår» (skissen: «Jeg fullfører
    # norsk videregående i løpet av denne våren») og «generell studiekompetanse fullføres i vår»
    # (søknadsmangler.feature) betyr det samme.
    # ÅPNE SPØRSMÅL:
    # - Hvilke ord skal kravene bruke: «norsk videregående opplæring fullføres i vår», som i
    #   skissen, eller «generell studiekompetanse fullføres i vår», som i søknadsmangler.feature?

    Scenariomal: Søkeren med <utdanningsbakgrunn> oppgir at norsk videregående opplæring fullføres i vår
      Når søkeren velger utdanningsbakgrunnen "<utdanningsbakgrunn>"
      Og søkeren oppgir at norsk videregående opplæring fullføres i vår
      Og søkeren sender inn søknaden
      Så står det i søknaden at norsk videregående opplæring fullføres i vår

      Eksempler:
        | utdanningsbakgrunn            |
        | Norsk videregående skole      |
        | Utenlandsk videregående skole |
        | Realkompetanse                |

  @openquestion
  Regel: Søkeren kan endre frem til søknadsfristen at norsk videregående opplæring fullføres i vår
    # ÅPNE SPØRSMÅL:
    # - Kan søkeren endre dette etter at søknaden er sendt inn? Henger sammen med regelen
    #   «Søkeren kan endre utdanningsbakgrunn etter at søknaden er sendt inn». HK-dir
    #   (Ingrids liste for DUA) sier at mangelen fjernes når søkeren fjerner krysset innen søknadsfristen.
    # Endres det etter innsending, må endringen gi en hendelse på søknaden, så den automatiske
    # mangelen kan settes eller slettes (@OPT-BEH-BEH-008, Geir V 2026-10-27).

    Scenario: Søkeren endrer før søknadsfristen at norsk videregående opplæring fullføres i vår
      Gitt at søkeren har sendt inn søknaden og oppgitt at norsk videregående opplæring fullføres i vår
      Og at søknadsfristen i "Samordna opptak 2027" ikke har gått ut
      Når søkeren endrer søknaden til at norsk videregående opplæring ikke fullføres i vår
      Så står det ikke lenger i søknaden at norsk videregående opplæring fullføres i vår

    Scenario: Søkeren kan ikke endre etter søknadsfristen at norsk videregående opplæring fullføres i vår
      Gitt at søkeren har sendt inn søknaden og oppgitt at norsk videregående opplæring fullføres i vår
      Og at søknadsfristen i "Samordna opptak 2027" har gått ut
      Når søkeren åpner søknaden
      Så ser ikke søkeren muligheten til å endre at norsk videregående opplæring fullføres i vår

  @openquestion
  Regel: Søkeren med GSK-konklusjon velger ikke utdanningsbakgrunn
    # AVKLART 2026-10-27 (planleggingsmøte): Steget hoppes over når søkeren har GSK-konklusjon.
    # GSK-konklusjonen er utdanningsbakgrunnen «Norsk videregående skole». Søkere med utenlandsk
    # utdanning har ikke GSK-konklusjon. Søkeren får ingen forklaring, siden steget ikke vises.
    # ÅPNE SPØRSMÅL:
    # - Registreres «Norsk videregående skole» som utdanningsbakgrunn i søknaden når steget
    #   hoppes over, eller hoppes steget bare over?

    Scenario: Søkeren med GSK-konklusjon blir ikke spurt om utdanningsbakgrunn
      Gitt at søkeren har en GSK-konklusjon fra et tidligere opptak
      Når søkeren går gjennom søknaden
      Så blir søkeren ikke spurt om utdanningsbakgrunn

  @openquestion
  Regel: Utdanningsbakgrunn preutfylles fra søkerens vitnemål
    # AVKLART 2026-10-27 (planleggingsmøte): Hvilke vitnemålstyper som gir hvilken
    # utdanningsbakgrunn, er en forretningsregel som ligger fast i backend. Opptaksforvalteren
    # bestemmer det ikke.
    # ÅPNE SPØRSMÅL:
    # - Trengs preutfylling fra vitnemål, når GSK beregnes ved vitnemålsimport
    #   (@OPT-BEH-BEH-027) og steget da hoppes over?

    Scenario: Utdanningsbakgrunn preutfylles fra vitnemål
      Gitt at vitnemålstypen "Studieforberedende" er koblet til utdanningsbakgrunnen "Norsk videregående skole"
      Og at søkeren har et studieforberedende vitnemål i kompetanseregisteret
      Når søkeren skal velge utdanningsbakgrunn i søknaden
      Så er "Norsk videregående skole" preutfylt som utdanningsbakgrunn i søknaden

    Scenario: Søkeren kan endre preutfylt utdanningsbakgrunn
      Gitt at "Norsk videregående skole" er preutfylt som utdanningsbakgrunn i søknaden
      Når søkeren velger utdanningsbakgrunnen "Rudolf Steinerskole"
      Så er "Rudolf Steinerskole" registrert som utdanningsbakgrunn i søknaden

  @could
  Regel: Utdanningsland fra en tidligere søknad foreslås

    Scenario: Utdanningsland fra en tidligere søknad preutfylles
      Gitt at søkeren oppga utdanningslandet "Tyskland" i en søknad til "Samordna opptak 2026"
      Når søkeren velger utdanningsbakgrunnen "Utenlandsk videregående skole"
      Så er "Tyskland" preutfylt som utdanningsland i søknaden
