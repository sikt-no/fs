# language: no
@OPT-BEH-BEH-025 @must @in-progress @scope-automatisk-ferdigbehandling @ref-OPT-BEH-BEH-004 @ref-OPT-BEH-BEH-018 @ref-OPT-BEH-BEH-019 @ref-OPT-BEH-BEH-020 @ref-OPT-BEH-BEH-032 @ref-OPT-BEH-BEH-035
Egenskap: Ferdigbehandle en sak
  Som saksbehandler
  ønsker jeg at saker som kan behandles helt automatisk, blir ferdig behandlet uten at jeg gjør noe
  slik at jeg bare trenger å behandle sakene den automatiske behandlingen ikke kunne fullføre.

  En sak er søknaden slik den ligger hos én saksbehandlende organisasjon. Saken behandles
  helautomatisk når søkeren har ett vitnemål, og vitnemålet gir GSK. Den automatiske
  behandlingen avgjør da grunnlaget, poengene, kravelementene og kvoten, og setter saken til
  ferdig behandlet når alt er avgjort. Har søkeren flere vitnemål, behandles saken automatisk på
  vitnemålet saksbehandleren velger (OPT-BEH-BEH-039).
  Kan den automatiske behandlingen ikke avgjøre et steg, gjør den stegene
  som ikke bygger på det, og saken blir stående som ikke behandlet. Saksbehandleren gjør resten,
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
  # stopper et steg, som for mangelkoden for GSK som fullføres i vår (OPT-BEH-BEH-036).

  # Avklart 30.10.2026: feilene i regelverket som kan stoppe et steg, står i scenariomalen
  # «<feil i regelverket> stopper <steg>». Nye feil legges til i tabellen når de oppdages.

  # Avklart 29.10.2026: når den automatiske behandlingen starter, står i OPT-BEH-BEH-032. Et nytt
  # vitnemål i en sak som er ferdig behandlet, gir saken nye resultater (OPT-BEH-BEH-035). Saken
  # behandles ikke automatisk på nytt, men saksbehandleren finner den blant sakene med nye
  # resultater, og kan starte behandlingen på det nye vitnemålet.

  Bakgrunn:
    Gitt at søkeren har en sak hos den saksbehandlende organisasjonen

  @depends-on-OPT-BEH-BEH-015 @ref-FLY-OPT-AUT-001 @implemented
  # OPT-BEH-BEH-015: «Vitnemålet gir GSK når det har GSK OK fra KREG»
  Regel: Bare saker der søkeren har ett vitnemål, og vitnemålet gir GSK, behandles helautomatisk
    # Et kompetansebevis teller ikke som vitnemål (se OPT-BEH-BEH-019).

    Scenario: Saken behandles helautomatisk når søkeren har ett vitnemål, og vitnemålet gir GSK
      Gitt at søkeren har ett vitnemål
      Og at vitnemålet gir GSK
      Når søknaden behandles automatisk
      Så behandles saken helautomatisk på vitnemålet

    Scenario: Saken behandles ikke helautomatisk når ingen vitnemål gir GSK
      Gitt at ingen av vitnemålene til søkeren gir GSK
      Når søknaden behandles automatisk
      Så behandles ikke saken helautomatisk

    Scenario: Saken behandles ikke helautomatisk før saksbehandleren har valgt vitnemål
      Gitt at søkeren har to vitnemål som gir GSK
      Når søknaden behandles automatisk
      Så behandles ikke saken helautomatisk

    Scenario: Saken behandles ikke helautomatisk når søkeren har flere vitnemål, og bare ett gir GSK
      # Avklart 30.10.2026: det andre vitnemålet kan ha fag som gir søkeren flere poeng, så
      # saksbehandleren velger vitnemålet. Søknaden får likevel GSK-konklusjonen fra vitnemålet
      # som gir GSK (OPT-BEH-BEH-015, «Konklusjon på søknaden fra vitnemålet»).
      Gitt at søkeren har to vitnemål
      Og at bare ett av vitnemålene gir GSK
      Når søknaden behandles automatisk
      Så behandles ikke saken helautomatisk

  @ref-FLY-OPT-AUT-001 @ref-OPT-BEH-BEH-032
  Regel: Den automatiske behandlingen setter saken til ferdig behandlet når alt er avgjort

    Bakgrunn:
      Gitt at søkeren har ett vitnemål, og vitnemålet gir GSK

    @implemented
    Scenario: Saken er ferdig behandlet når den automatiske behandlingen har avgjort alt
      Gitt at den automatiske behandlingen kan avgjøre alle stegene for saken
      Når søknaden behandles automatisk
      Så er saken ferdig behandlet

    @depends-on-OPT-BEH-BEH-008 @depends-on-OPT-BEH-BEH-036 @implemented
    # OPT-BEH-BEH-008: «Mangler hindrer ikke kvalifiseringen eller at saken blir ferdig behandlet»
    # OPT-BEH-BEH-036: «Saken får automatiske mangeltekster når søkeren ikke er kvalifisert»
    Scenario: Saken er ferdig behandlet selv om kravelementene ga mangeltekst
      Gitt at søknadsalternativet har kravelementet "Matematikk R2"
      Og at vitnemålet ikke har "Matematikk R2"
      Når søknaden behandles automatisk
      Så har saken en automatisk mangeltekst som viser at "Matematikk R2" ikke er oppfylt
      Og saken er ferdig behandlet

    @depends-on-OPT-BEH-BEH-008
    # OPT-BEH-BEH-008: «Søkeren ser bare manglene som er publisert, og får melding om dem»
    Scenario: Den automatiske behandlingen publiserer manglene når saken blir ferdig behandlet
      # Avklart 2026-10-26 i review av PR #818: saksbehandleren gjør ingenting i saken, så
      # automatikken publiserer manglene når den setter saken til ferdig behandlet.
      Gitt at søknadsalternativet har kravelementene "Matematikk R2" og "Fysikk 2"
      Og at vitnemålet verken har "Matematikk R2" eller "Fysikk 2"
      Når søknaden behandles automatisk
      Så er saken ferdig behandlet
      Og søkeren ser de automatiske manglene for "Matematikk R2" og "Fysikk 2" i Min kompetanse
      Og søkeren har mottatt én melding om mangler

  @ref-OPT-BEH-BEH-016
  Regel: Saksbehandleren ser hva den automatiske behandlingen har gjort i saken
    # Avklart 2026-11-03: saksbehandleren skal alltid kunne åpne en sak som er behandlet
    # automatisk, og se hva den automatiske behandlingen har gjort, og når. Saksbehandleren skal
    # ikke måtte ta stilling til noe, og det skal ikke stoppe noe. Det gjelder også varselet om at
    # opptakssystemet er uenig med skolen om GSK.
    # At GSK-konklusjonen er satt automatisk, står i OPT-BEH-BEH-015 («Sporbarhet»). At den
    # automatiske behandlingen satte saken til ferdig behandlet, og når, står i OPT-BEH-BEH-029
    # («Saksloggen viser endringene i behandlingsstatusen»). At statusen ikke endres når
    # saksbehandleren åpner saken, står også i OPT-BEH-BEH-029.
    # Avklart 2026-11-03: hvor saksbehandleren ser det (hendelsesloggen for saken i
    # OPT-BEH-BEH-016, ved hvert steg i saken, eller begge steder), er et designspørsmål, og
    # hører hjemme i implementasjonsdetaljene.

    Bakgrunn:
      Gitt at søkeren har ett vitnemål, og vitnemålet gir GSK
      Og at saken er satt til ferdig behandlet av den automatiske behandlingen

    Scenario: Saksbehandleren ser hva den automatiske behandlingen har avgjort
      Når saksbehandleren åpner saken
      Så ser saksbehandleren at grunnlaget, poengene, kravelementene og kvoten er avgjort av den automatiske behandlingen

    Scenario: Saksbehandleren ser når den automatiske behandlingen avgjorde hvert steg
      Når saksbehandleren åpner saken
      Så ser saksbehandleren når den automatiske behandlingen avgjorde hvert steg

    @depends-on-OPT-BEH-BEH-015 @depends-on-OPT-BEH-BEH-029 @implemented
    # OPT-BEH-BEH-015: «Saksbehandleren får varsel når opptakssystemet er uenig med skolen»
    # OPT-BEH-BEH-029: «Saken blir Under behandling når saksbehandleren endrer vurderingen eller markerer et dokument som lest»
    Scenario: Varselet om uenighet om GSK krever ikke at saksbehandleren gjør noe
      Gitt at opptakssystemet er uenig med skolen om GSK for vitnemålet
      Når saksbehandleren åpner saken
      Så ser saksbehandleren et varsel ved vitnemålet om at opptakssystemet er uenig med skolen om GSK
      Og saken er fortsatt ferdig behandlet

  Regel: Steg som bygger på et steg som ikke kan avgjøres, hoppes over

    Bakgrunn:
      Gitt at søkeren har ett vitnemål, og vitnemålet gir GSK

    Scenariomal: Det som kan avgjøres, blir avgjort når <steg> ikke kan avgjøres
      Gitt at <steg> for søknadsalternativet ikke kan avgjøres på grunn av en feil i regelverket
      Når søknaden behandles automatisk
      Så er <avgjort> avgjort for søknadsalternativet
      Men <ikke avgjort> er ikke avgjort for søknadsalternativet

      Eksempler:
        | steg           | avgjort                                                 | ikke avgjort                              |
        | poengene       | grunnlaget, kravelementene, kvalifiseringen og kvoten   | poengene                                  |
        | kravelementene | grunnlaget og poengene                                  | kravelementene, kvalifiseringen og kvoten |
        | kvoten         | grunnlaget, poengene, kravelementene og kvalifiseringen | kvoten                                    |

    @implemented
    Scenario: Saken blir stående som ikke behandlet når et steg ikke kan avgjøres
      # Avklart 2026-11-02: den automatiske behandlingen endrer ikke behandlingsstatusen, bortsett
      # fra å sette saken til ferdig behandlet. Saken blir Under behandling når saksbehandleren
      # gjør noe med den (OPT-BEH-BEH-029).
      Gitt at poengene for søknadsalternativet ikke kan avgjøres på grunn av en feil i regelverket
      Når søknaden behandles automatisk
      Så har saken behandlingsstatusen "Ikke behandlet"

    Scenario: Opptaksforvalteren får varsel første gang en feil i regelverket stopper et steg
      Gitt at poengene for søknadsalternativet ikke kan avgjøres på grunn av en feil i regelverket
      Når søknaden behandles automatisk
      Så får opptaksforvalteren ved organisasjonen som forvalter opptaket, et varsel om feilen
      Og varselet viser hvilken feil det er, og hvilket regelverk den gjelder

    Scenario: Opptaksforvalteren får varselet om feilen bare første gang
      Gitt at opptaksforvalteren ved organisasjonen som forvalter opptaket, har fått varsel om en feil i regelverket
      Når en annen søknad stoppes av den samme feilen i regelverket
      Så får ikke opptaksforvalteren et nytt varsel om feilen

    Scenariomal: <feil i regelverket> stopper <steg>
      Gitt at <feil i regelverket> for søknadsalternativet
      Når søknaden behandles automatisk
      Så er ikke <steg> avgjort for søknadsalternativet
      Og saken har behandlingsstatusen "Ikke behandlet"

      Eksempler:
        | feil i regelverket                                | steg        |
        | poengformelen mangler                             | poengene    |
        | poengformelen viser til seg selv                  | poengene    |
        | poengformelen er ugyldig                          | poengene    |
        | kvotespørsmålet har en algoritme som ikke finnes  | kvoten      |
        | poengtypen har en algoritme som ikke finnes       | poengene    |
        | to grunnlag passer like godt                      | grunnlaget  |
        | opptaket mangler dato for aldersberegning         | grunnlaget  |

  @implemented
  Regel: Saksbehandleren setter saken til ferdig behandlet når den automatiske behandlingen ikke har fullført

    Bakgrunn:
      Gitt at søkeren har ett vitnemål, og vitnemålet gir GSK

    Scenario: Saksbehandleren ferdigbehandler saken etter å ha gjort resten
      Gitt at saken ikke er ferdig behandlet fordi poengene for søknadsalternativet ikke kunne avgjøres automatisk
      Og at saksbehandleren har satt poengene for søknadsalternativet
      Når saksbehandleren setter saken til "Behandlet"
      Så er saken ferdig behandlet

    Scenario: Saken blir ikke ferdig behandlet av seg selv når saksbehandleren har gjort resten
      Gitt at saken ikke er ferdig behandlet fordi poengene for søknadsalternativet ikke kunne avgjøres automatisk
      Når saksbehandleren setter poengene for søknadsalternativet
      Så har saken behandlingsstatusen "Under behandling"
