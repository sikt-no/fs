# language: no
@OPT-BEH-BEH-025 @must @planned @ref-OPT-BEH-BEH-004 @ref-OPT-BEH-BEH-018 @ref-OPT-BEH-BEH-019 @ref-OPT-BEH-BEH-020 @ref-OPT-BEH-BEH-032
Egenskap: Ferdigbehandle en sak
  Som saksbehandler
  ønsker jeg at saker som kan behandles helt automatisk, blir ferdig behandlet uten at jeg gjør noe
  slik at jeg bare trenger å behandle sakene den automatiske behandlingen ikke kunne fullføre.

  En sak er søknaden slik den ligger hos én saksbehandlende organisasjon. Saken behandles
  helautomatisk når søkeren har ett vitnemål, og vitnemålet gir GSK. Den automatiske
  behandlingen avgjør da grunnlaget, poengene, kravelementene og kvoten, og setter saken til
  ferdig behandlet når alt er avgjort. Har søkeren flere vitnemål, velger
  saksbehandleren vitnemålet, og beregner poengene i vitnemålsbehandlingen (OPT-BEH-BEH-004).
  Saken behandles da automatisk på vitnemålet, og den automatiske behandlingen avgjør resten.
  Kan den automatiske behandlingen ikke avgjøre et steg, gjør den stegene
  som ikke bygger på det, og saken blir stående under behandling. Saksbehandleren gjør resten,
  og setter saken til ferdig behandlet. Bare saker som er ferdig behandlet, er med i
  plasstildelingen.

  # Flyttet hit fra starte_plasstildeling.feature (OPT-PLA-TIL-001) 2026-10-26: «Automatisk
  # saksbehandling gjør saken ferdig behandlet».
  # Kode i dag: den automatiske behandlingen (AutomatiskSaksbehandlingService) setter ikke saken
  # til ferdig behandlet. Bare saksbehandleren gjør det (EndreStatusService).
  # Søkere uten et vitnemål som gir GSK, behandles ikke automatisk
  # (OPT-BEH-BEH-015, -018, -019 og -020), og blir ferdig behandlet av saksbehandleren.
  # Kode i dag: den automatiske behandlingen setter GSK-konklusjonen selv, og stopper når
  # søkeren har flere vitnemål.

  # Avklart 30.10.2026: opptaksforvalteren får et varsel første gang en feil i regelverket
  # stopper et steg, som for mangelkoden for GSK som fullføres i vår (OPT-BEH-BEH-008).

  # Avklart 30.10.2026: feilene i regelverket som kan stoppe et steg, står i scenariomalen
  # «<feil i regelverket> stopper <steg>». Nye feil legges til i tabellen når de oppdages.

  # Avklart 29.10.2026: når den automatiske behandlingen starter, står i OPT-BEH-BEH-032. Et nytt
  # vitnemål i en sak som er ferdig behandlet, er ny dokumentasjon. Saken behandles ikke
  # automatisk på nytt, men saksbehandleren ser at den har fått ny dokumentasjon, og kan starte
  # behandlingen på det nye vitnemålet.

  Bakgrunn:
    Gitt at søknaden til "Kari Nordmann" har en sak hos "Universitetet i Oslo"

  @depends-on-OPT-BEH-BEH-015 @ref-FLY-OPT-AUT-001
  # OPT-BEH-BEH-015: «Vitnemålet gir GSK når minst én av de tre påstandene er ja»
  Regel: Bare saker der søkeren har ett vitnemål, og vitnemålet gir GSK, behandles helautomatisk

    Scenario: Saken behandles helautomatisk når søkeren har ett vitnemål, og vitnemålet gir GSK
      Gitt at "Kari Nordmann" har ett vitnemål
      Og at vitnemålet gir GSK
      Når søknaden behandles automatisk
      Så behandles saken hos "Universitetet i Oslo" helautomatisk på vitnemålet

    Scenario: Saken behandles ikke helautomatisk når ingen vitnemål gir GSK
      Gitt at ingen av vitnemålene til "Kari Nordmann" gir GSK
      Når søknaden behandles automatisk
      Så behandles ikke saken hos "Universitetet i Oslo" helautomatisk

    Scenario: Saken behandles ikke helautomatisk før saksbehandleren har valgt vitnemål
      Gitt at "Kari Nordmann" har to vitnemål som gir GSK
      Når søknaden behandles automatisk
      Så behandles ikke saken hos "Universitetet i Oslo" helautomatisk

    Scenario: Saken behandles ikke helautomatisk når søkeren har flere vitnemål, og bare ett gir GSK
      # Avklart 30.10.2026: det andre vitnemålet kan ha fag som gir søkeren flere poeng, så
      # saksbehandleren velger vitnemålet. Søknaden får likevel GSK-konklusjonen fra vitnemålet
      # som gir GSK (OPT-BEH-BEH-015, «Konklusjon på søknaden fra vitnemålet»).
      Gitt at "Kari Nordmann" har to vitnemål
      Og at bare ett av vitnemålene gir GSK
      Når søknaden behandles automatisk
      Så behandles ikke saken hos "Universitetet i Oslo" helautomatisk

  @ref-OPT-BEH-BEH-015 @ref-FLY-OPT-VAL-001 @ref-FLY-OPT-SAM-001 @ref-OPT-BEH-BEH-032
  # OPT-BEH-BEH-015: «Konklusjon på søknaden fra vitnemålet»
  Regel: Har søkeren flere vitnemål, behandles saken automatisk på vitnemålet saksbehandleren velger
    # Saksbehandleren velger vitnemålet når den automatiske behandlingen startes på det. Å starte
    # behandlingen på et vitnemål står i OPT-BEH-BEH-032.

    Scenario: Saksbehandleren velger vitnemålet saken behandles automatisk på
      # Vitnemålet saksbehandleren velger, kan være et annet enn vitnemålet GSK-konklusjonen på
      # søknaden bygger på (det med senest utstedelsesdato). Begge vitnemålene gir GSK, og
      # konklusjonen endres ikke av valget.
      Gitt at "Kari Nordmann" har vitnemålene "Vitnemål 2024" og "Vitnemål 2025", som begge gir GSK
      Når saksbehandleren ved Universitetet i Oslo starter den automatiske behandlingen på "Vitnemål 2025"
      Så behandles saken hos "Universitetet i Oslo" automatisk på "Vitnemål 2025"

    @draft @openquestion
    Scenario: Saken behandles automatisk på et sammensatt vitnemål
      # ÅPNE SPØRSMÅL:
      # - Ingen krav beskriver hva et sammensatt vitnemål er, eller hvordan saksbehandleren
      #   setter det sammen (se FLY-OPT-SAM-001).
      Gitt at "Kari Nordmann" har et sammensatt vitnemål
      Når saksbehandleren ved Universitetet i Oslo starter den automatiske behandlingen på det sammensatte vitnemålet
      Så behandles saken hos "Universitetet i Oslo" automatisk på det sammensatte vitnemålet

  @ref-FLY-OPT-AUT-001 @ref-OPT-BEH-BEH-032
  Regel: Den automatiske behandlingen setter saken til ferdig behandlet når alt er avgjort

    Bakgrunn:
      Gitt at "Kari Nordmann" har ett vitnemål, og vitnemålet gir GSK

    Scenario: Saken er ferdig behandlet når den automatiske behandlingen har avgjort alt
      Gitt at den automatiske behandlingen kan avgjøre alle stegene for saken
      Når søknaden behandles automatisk
      Så er saken hos "Universitetet i Oslo" ferdig behandlet

    @depends-on-OPT-BEH-BEH-008
    # OPT-BEH-BEH-008: «Kategorien til mangelkoden avgjør hva mangelen hindrer» og «Saken får automatiske mangeltekster når søkeren ikke er kvalifisert»
    Scenario: Saken er ferdig behandlet selv om kravelementene ga mangeltekst
      Gitt at "Informatikk, UiO" har kravelementet "Matematikk R2"
      Og at vitnemålet ikke har "Matematikk R2"
      Når søknaden behandles automatisk
      Så har saken en automatisk mangeltekst som viser at "Matematikk R2" ikke er oppfylt
      Og saken hos "Universitetet i Oslo" er ferdig behandlet

    @depends-on-OPT-BEH-BEH-008
    # OPT-BEH-BEH-008: «Søkeren ser bare manglene som er publisert, og får melding om dem»
    Scenario: Den automatiske behandlingen publiserer manglene når saken blir ferdig behandlet
      # Avklart 2026-10-26 i review av PR #818: saksbehandleren gjør ingenting i saken, så
      # automatikken publiserer manglene når den setter saken til ferdig behandlet.
      Gitt at "Informatikk, UiO" har kravelementene "Matematikk R2" og "Fysikk 2"
      Og at vitnemålet verken har "Matematikk R2" eller "Fysikk 2"
      Når søknaden behandles automatisk
      Så er saken hos "Universitetet i Oslo" ferdig behandlet
      Og søkeren ser de automatiske manglene for "Matematikk R2" og "Fysikk 2" i Min kompetanse
      Og søkeren har mottatt én melding om mangler

  @ref-FLY-OPT-AUT-001
  Regel: Steg som bygger på et steg som ikke kan avgjøres, hoppes over

    Bakgrunn:
      Gitt at "Kari Nordmann" har ett vitnemål, og vitnemålet gir GSK

    Scenariomal: Det som kan avgjøres, blir avgjort når <steg> ikke kan avgjøres
      Gitt at <steg> for "Informatikk, UiO" ikke kan avgjøres på grunn av en feil i regelverket
      Når søknaden behandles automatisk
      Så er <avgjort> avgjort for "Informatikk, UiO"
      Men <ikke avgjort> er ikke avgjort for "Informatikk, UiO"

      Eksempler:
        | steg           | avgjort                                                 | ikke avgjort                              |
        | poengene       | grunnlaget, kravelementene, kvalifiseringen og kvoten   | poengene                                  |
        | kravelementene | grunnlaget og poengene                                  | kravelementene, kvalifiseringen og kvoten |
        | kvoten         | grunnlaget, poengene, kravelementene og kvalifiseringen | kvoten                                    |

    Scenario: Saken blir stående under behandling når et steg ikke kan avgjøres
      Gitt at poengene for "Informatikk, UiO" ikke kan avgjøres på grunn av en feil i regelverket
      Når søknaden behandles automatisk
      Så er saken hos "Universitetet i Oslo" under behandling

    Scenario: Opptaksforvalteren får varsel første gang en feil i regelverket stopper et steg
      Gitt at poengene for "Informatikk, UiO" ikke kan avgjøres på grunn av en feil i regelverket
      Når søknaden behandles automatisk
      Så får opptaksforvalteren ved organisasjonen som forvalter opptaket, et varsel om feilen
      Og varselet viser hvilken feil det er, og hvilket regelverk den gjelder

    Scenario: Opptaksforvalteren får varselet om feilen bare første gang
      Gitt at opptaksforvalteren ved organisasjonen som forvalter opptaket, har fått varsel om en feil i regelverket
      Når en annen søknad stoppes av den samme feilen i regelverket
      Så får ikke opptaksforvalteren et nytt varsel om feilen

    @could
    Scenariomal: <feil i regelverket> stopper <steg>
      Gitt at <feil i regelverket> for "Informatikk, UiO"
      Når søknaden behandles automatisk
      Så er ikke <steg> avgjort for "Informatikk, UiO"
      Og saken hos "Universitetet i Oslo" er under behandling

      Eksempler:
        | feil i regelverket                                | steg        |
        | poengformelen mangler                             | poengene    |
        | poengformelen viser til seg selv                  | poengene    |
        | poengformelen er ugyldig                          | poengene    |
        | kvotespørsmålet har en algoritme som ikke finnes  | kvoten      |
        | poengtypen har en algoritme som ikke finnes       | poengene    |
        | to grunnlag passer like godt                      | grunnlaget  |
        | opptaket mangler dato for aldersberegning         | grunnlaget  |

  Regel: Saksbehandleren setter saken til ferdig behandlet når den automatiske behandlingen ikke har fullført

    Bakgrunn:
      Gitt at "Kari Nordmann" har ett vitnemål, og vitnemålet gir GSK

    Scenario: Saksbehandleren ferdigbehandler saken etter å ha gjort resten
      Gitt at saken hos "Universitetet i Oslo" er under behandling fordi poengene for "Informatikk, UiO" ikke kunne avgjøres automatisk
      Og at saksbehandleren ved Universitetet i Oslo har satt poengene for "Informatikk, UiO"
      Når saksbehandleren setter saken til "Ferdig behandlet"
      Så er saken hos "Universitetet i Oslo" ferdig behandlet

    Scenario: Saken blir ikke ferdig behandlet av seg selv når saksbehandleren har gjort resten
      Gitt at saken hos "Universitetet i Oslo" er under behandling fordi poengene for "Informatikk, UiO" ikke kunne avgjøres automatisk
      Når saksbehandleren ved Universitetet i Oslo setter poengene for "Informatikk, UiO"
      Så er saken hos "Universitetet i Oslo" fortsatt under behandling
