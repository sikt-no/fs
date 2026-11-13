# language: no
# GitHub: #632, #215
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

    # AVKLART 2026-11-09 (TOT-2586): Alle opptak har minst én utdanningsbakgrunn, også lokale opptak.
    Scenario: Utdanningsbakgrunnen velges per søknad
      Gitt at søkeren har valgt "Rudolf Steinerskole" i søknaden til "Samordna opptak 2027"
      Når søkeren starter en søknad i opptaket "Lokalt opptak høst 2027"
      Så er ingen utdanningsbakgrunn valgt i søknaden til "Lokalt opptak høst 2027"

    # AVKLART 2026-11-12 (TOT-2635): Ingen utdanningsbakgrunn er valgt på forhånd, fordi vi ikke
    # vet utdanningsbakgrunnen fra før. Søkeren velger selv. Unntaket er preutfylling fra
    # elektronisk vitnemål, se «Utdanningsbakgrunn preutfylles fra søkerens vitnemål».
    Scenario: Ingen utdanningsbakgrunn er valgt på forhånd
      Gitt at søkeren ikke har elektronisk vitnemål fra norsk videregående opplæring
      Når søkeren skal velge utdanningsbakgrunn i søknaden
      Så er ingen utdanningsbakgrunn valgt i søknaden

    # AVKLART 2026-10-19 (S4): Det skal ikke være mulig å registrere en søknad uten utdanningsbakgrunn.
    # AVKLART 2026-11-09 (TOT-2586): Det gjelder alle opptak.
    Scenario: Søknaden kan ikke sendes inn uten utdanningsbakgrunn
      Gitt at søkeren ikke har valgt utdanningsbakgrunn i søknaden
      Når søkeren vil sende inn søknaden
      Så kan søkeren ikke sende inn søknaden
      Og søkeren får beskjed om å velge utdanningsbakgrunn

  Regel: Søkeren kan endre utdanningsbakgrunn frem til søknadsfristen
    # AVKLART 2026-11-12 (TOT-2635): Søkeren kan selv endre utdanningsbakgrunnen i en innsendt
    # søknad frem til søknadsfristen, men ikke etter.
    # Kilde: HK-Dir-historiene 9467 «Endre utdanningsbakgrunn» og 9448 «Endre innsendt søknad».
    # Saksbehandlerens endring hører til søknadsbehandlingen. Hvilken organisasjon som
    # saksbehandler søknaden etter endringen, står i @OPT-BEH-BEH-011.

    Scenario: Søkeren endrer utdanningsbakgrunn i en innsendt søknad
      Gitt at søkeren har sendt inn søknaden med utdanningsbakgrunnen "Utenlandsk videregående skole"
      Når søkeren endrer utdanningsbakgrunnen til "Rudolf Steinerskole"
      Så er "Rudolf Steinerskole" registrert som utdanningsbakgrunn i søknaden

    Scenario: Søkeren kan ikke endre utdanningsbakgrunn etter søknadsfristen
      Gitt at søkeren har sendt inn søknaden med utdanningsbakgrunnen "Utenlandsk videregående skole"
      Og at søknadsfristen har gått ut
      Når søkeren vil endre utdanningsbakgrunnen i søknaden
      Så kan søkeren ikke endre utdanningsbakgrunnen

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

  @could @depends-on-OPT-BEH-BEH-015
  Regel: Søkeren med GSK-konklusjon velger ikke utdanningsbakgrunn
    # AVKLART 2026-10-27 (planleggingsmøte): Steget hoppes over når søkeren har GSK-konklusjon.
    # Søkeren får ingen forklaring, siden steget ikke vises.
    # AVKLART 2026-11-09 (TOT-2586): GSK-konklusjonen er en konklusjon fra et tidligere opptak
    # i gjenbruksbasen, se «Konklusjon fra tidligere opptak».
    # Søkere med utenlandsk utdanning kan ha GSK-konklusjon, og søkeren med GSK-konklusjon får
    # ikke automatisk «Norsk videregående skole», siden søknaden da havner feil i
    # saksbehandlertildelingen.
    # AVKLART 2026-11-12 (TOT-2635): Å ta utgangspunkt i GSK-konklusjonen er nytt, trenger
    # detaljerte krav, og er nice-to-have som ikke løses nå. Søkeren som blir spurt, får ingen
    # utdanningsbakgrunn valgt på forhånd fra GSK-konklusjonen.

    Scenario: Søkeren med GSK-konklusjon blir ikke spurt om utdanningsbakgrunn
      Gitt at søkeren har en positiv GSK-konklusjon fra et tidligere opptak
      Når søkeren går gjennom søknaden
      Så blir søkeren ikke spurt om utdanningsbakgrunn

  Regel: Utdanningsbakgrunn preutfylles fra søkerens vitnemål
    # AVKLART 2026-10-27 (planleggingsmøte): Hvilke vitnemålstyper som gir hvilken
    # utdanningsbakgrunn, er en forretningsregel som ligger fast i backend. Opptaksforvalteren
    # bestemmer det ikke.
    # AVKLART 2026-11-12 (TOT-2635): Har søkeren elektronisk vitnemål fra norsk videregående
    # opplæring, er «Norsk videregående skole» preutfylt.

    Scenario: Utdanningsbakgrunn preutfylles fra vitnemål
      Gitt at søkeren har elektronisk vitnemål fra norsk videregående opplæring
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
