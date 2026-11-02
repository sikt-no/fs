# language: no
@FLY-OPT-AUT-001 @must @planned @e2e @depends-on-FLY-OPT-SAK-001
Egenskap: Automatisk saksbehandling
  Fra søknaden er blitt en sak hos den saksbehandlende organisasjonen, til saken er ferdig
  behandlet og klar til å være med i plasstildelingen, uten at en saksbehandler har gjort noe.
  Plasstildelingen er ikke en del av flyten. Søkerens
  vitnemål importeres fra KREG til opptakssystemet når saken er opprettet (OPT-BEH-BEH-030).
  Opptakssystemets påstand om GSK beregnes for hvert vitnemål når vitnemålet importeres fra KREG.
  Vitnemålet gir GSK når minst én av de tre påstandene, skolens, KREGs og opptakssystemets, er ja,
  og søknaden får GSK-konklusjonen da (OPT-BEH-BEH-015). «Importeres» betyr i flyten alltid at
  opptakssystemet henter vitnemålet fra KREG, ikke at vitnemålet kommer inn i KREG.
  Den automatiske behandlingen fortsetter saksbehandlertildelingen: hver ny sak behandles når
  vitnemålet er importert, eller når jobben for nye vitnemål i KREG finner søkerens første
  vitnemål. Opptaksforvalteren kan skru automatikken av for opptaket (OPT-BEH-BEH-032).
  Som første steg setter den GSK-konklusjonen på søknadene som ikke har en.
  Flyten gjelder søkere med ett vitnemål, der vitnemålet gir GSK. Andre søkere
  hoppes over, og behandles ikke helautomatisk
  (se OPT-BEH-BEH-025). For søkerne i flyten setter den automatiske behandlingen grunnlaget,
  poengene, vurderingen av kravelementene og svarene på kvotespørsmålene, i den rekkefølgen.
  Det oppdaterer kvalifiseringen, kvotene, poengene per kvote og mangeltekstene. Til slutt sjekker den
  automatiske behandlingen ut mangelen for GSK som fullføres i vår, og setter saken til ferdig
  behandlet. Rettes en feil i regelverket, beregner opptaksforvalteren søknadsalternativene
  feilen gjaldt, på nytt.

  # Kjent brudd: den automatiske behandlingen setter ikke saken til ferdig behandlet (se OPT-BEH-BEH-025).
  # Kjent brudd: koden beregner GSK bare i den automatiske behandlingen, ikke når vitnemålet
  # importeres fra KREG, og opptakssystemets påstand lagres ikke på vitnemålet (se OPT-BEH-BEH-015).
  # Kjent brudd: koden krever at KREG sier GSK, og bruker ikke skolens påstand (se OPT-BEH-BEH-015).
  # Kjent brudd: ingenting starter den automatiske behandlingen når resultatene er importert.
  # Bare saksbehandleren starter den, for én sak om gangen (se OPT-BEH-BEH-032).
  # Fasene er etter prosesstegningen for automatisk saksbehandling (2026-10-29). Kvalifiseringen,
  # kvotene, poengene per kvote og mangeltekstene er ikke egne steg: de oppdateres automatisk ut fra
  # stegene før, og er gule i tegningen. Tegningen har kravelementene før poengene. Det er
  # unøyaktig: poengene beregnes først (OPT-BEH-BEH-020).
  # To faser er med i flyten, men er utenfor scope i første fase (@wont): to identiske vitnemål
  # som reknes som ett vitnemål, og automatisk dobbeltrangering etter 23/5-regelen i 2027.
  # De står her så de blir med i neste fase.

  Bakgrunn:
    Gitt at søknaden til "Kari Nordmann" har en sak hos "Universitetet i Oslo"

  @depends-on-OPT-BEH-BEH-030
  # OPT-BEH-BEH-030: «Resultatene hentes når saken er opprettet», «Alle vitnemål og kompetansebevis søkeren har i KREG, importeres»
  Regel: Søkerens resultater importeres fra KREG når saken er opprettet

    Scenario: Vitnemålet fra KREG er klart for behandlingen når saken er opprettet
      Gitt at "Kari Nordmann" har et vitnemål i KREG
      Når saken hos "Universitetet i Oslo" er opprettet
      Så er vitnemålet importert
      Og GSK kan beregnes for vitnemålet

  @depends-on-OPT-BEH-BEH-032
  # OPT-BEH-BEH-032: «Behandlingen kjører for hver ny sak saksbehandlertildelingen oppretter», «Behandlingen kjører når søkeren får det første vitnemålet»
  Regel: Den automatiske behandlingen starter når søkerens resultater er importert

    Scenario: Saken behandles automatisk når vitnemålet er importert
      Gitt at saken hos "Universitetet i Oslo" er opprettet
      Når vitnemålet til "Kari Nordmann" er importert fra KREG
      Så behandles saken automatisk

  @depends-on-OPT-BEH-BEH-015 @depends-on-OPT-BEH-BEH-027
  # OPT-BEH-BEH-015: «Opptakssystemets påstand om GSK på vitnemålet», «Vitnemålet gir GSK når minst én av de tre påstandene er ja», «Konklusjon på søknaden fra vitnemålet», «Konklusjon fra tidligere opptak», «Automatikken setter bare positive konklusjoner, og bare der ingen finnes»
  # Opptakssystemets påstand om GSK beregnes med kontrollmotoren, som er beskrevet i hele OPT-BEH-BEH-027.
  Regel: Søknaden får GSK-konklusjonen når vitnemålet importeres fra KREG

    Scenario: Søknaden får GSK-konklusjonen fra vitnemålet som er importert fra KREG
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at "Kari Nordmann" har et vitnemål i KREG som består seksfagskontrollen
      Når vitnemålet importeres fra KREG
      Så er opptakssystemets påstand at søkeren har generell studiekompetanse
      Og vitnemålet gir GSK
      Og søknaden får en positiv GSK-konklusjon

  @depends-on-OPT-BEH-BEH-015 @ref-FLY-OPT-VAL-001 @ref-FLY-OPT-SAM-001
  # OPT-BEH-BEH-015: «GSK-konklusjonen settes også når den automatiske behandlingen kjører»
  Regel: Den automatiske behandlingen setter GSK-konklusjonen der den mangler
    # Påstandene på vitnemålet beregnes ikke på nytt i kjøringen.

    Scenario: Søknaden uten GSK-konklusjon får konklusjonen i kjøringen
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at "Kari Nordmann" har ett vitnemål, og vitnemålet gir GSK
      Når søknaden behandles automatisk
      Så får søknaden en positiv GSK-konklusjon

  @depends-on-OPT-BEH-BEH-015 @depends-on-OPT-BEH-BEH-025
  # OPT-BEH-BEH-015: «Vitnemålet gir GSK når minst én av de tre påstandene er ja»
  # OPT-BEH-BEH-025: «Bare saker der søkeren har ett vitnemål, og vitnemålet gir GSK, behandles helautomatisk»
  Regel: Vitnemålet som gir GSK, avgjør om saken behandles helautomatisk

    Scenario: Saken behandles helautomatisk på vitnemålet som gir GSK
      Gitt at "Kari Nordmann" har ett vitnemål, og vitnemålet gir GSK
      Når søknaden behandles automatisk
      Så behandles saken hos "Universitetet i Oslo" helautomatisk på vitnemålet

    Scenario: Søkeren hoppes over når ingen vitnemål gir GSK
      Gitt at ingen av vitnemålene til "Kari Nordmann" gir GSK
      Når søknaden behandles automatisk
      Så behandles ikke saken hos "Universitetet i Oslo" helautomatisk

  @wont @openquestion
  Regel: To identiske vitnemål reknes som ett vitnemål
    # ÅPNE SPØRSMÅL:
    # - Utenfor scope i første fase. Fasen er med for å huske den til neste fase.
    # - Ingen krav beskriver når to vitnemål er identiske, eller hvilket av dem saken
    #   behandles helautomatisk på. Hvilket krav skal eie regelen: OPT-BEH-BEH-025 eller et nytt krav?

    Scenario: Saken behandles helautomatisk når søkeren har to identiske vitnemål
      Gitt at "Kari Nordmann" har to identiske vitnemål som gir GSK
      Når søknaden behandles automatisk
      Så behandles saken hos "Universitetet i Oslo" helautomatisk på vitnemålet

  @depends-on-OPT-BEH-BEH-019 @ref-FLY-OPT-VAL-001 @ref-FLY-OPT-SAM-001
  # OPT-BEH-BEH-019: «Grunnlaget velges ut fra egenskapene regelverket har gitt det», «Ingen automatisk grunnlag uten ett vitnemål som gir generell studiekompetanse», «Grunnlaget settes når den automatiske behandlingen kjører»
  Regel: Saken får grunnlag fra vitnemålet

    Scenario: Saken får grunnlag
      Gitt at saken hos "Universitetet i Oslo" behandles helautomatisk på vitnemålet
      Når søknaden behandles automatisk
      Så har saken grunnlag

  @depends-on-OPT-BEH-BEH-018 @depends-on-OPT-REG-RAN-001 @depends-on-OPT-REG-RAN-002 @ref-FLY-OPT-VAL-001 @ref-FLY-OPT-SAM-001
  # OPT-BEH-BEH-018: «Karakterpoeng, realfagspoeng og språkpoeng beregnes fra søkerens eneste vitnemål», «Skolepoeng settes sammen av karakterpoeng, realfagspoeng og språkpoeng», «Ingen automatisk beregning uten ett entydig vitnemål»
  Regel: Poengene beregnes fra grunnlaget og rangeringsregelverket
    # Overleveringen: grunnlaget avgjør hvilke poengtyper søknaden har (rangeringsregelverket
    # kobler grunnlag til poengtyper), og poengene i dem beregnes fra vitnemålet.
    # Avklart 2026-10-27 i review av PR #818, fra koden i fs-plattform (PoengRadOppdateringService).

    Scenario: Søknadsalternativet får poengsum
      Gitt at saken har grunnlag
      Når søknaden behandles automatisk
      Så har "Informatikk, UiO" poengsum for søknaden

  @depends-on-OPT-BEH-BEH-028 @ref-FLY-OPT-VAL-001 @ref-FLY-OPT-SAM-001
  # OPT-BEH-BEH-028: «Alderspoeng regnes ut fra søkerens alder», «Kjønnspoeng regnes ut fra søkerens kjønn», «Poeng for høyere utdanning regnes ut fra søkerens studiepoeng», «Tilleggspoengene settes uansett hvem som velger grunnlaget»
  Regel: Søknaden får tilleggspoeng når grunnlaget er satt

    Scenario: Søknaden får tilleggspoengene for grunnlaget
      Gitt at saken har grunnlag
      Når søknaden behandles automatisk
      Så har saken tilleggspoengene rangeringsregelverket gir for grunnlaget

  @wont @openquestion
  Regel: Søknaden dobbeltrangeres automatisk etter 23/5-regelen
    # ÅPNE SPØRSMÅL:
    # - Utenfor scope i første fase. Fasen er med for å huske den til neste fase.
    # - Det er ikke beskrevet hvordan den automatiske dobbeltrangeringen (poengberegningen) skal
    #   gjøres. I opptakssystemet som finnes i dag, er den en manuell operasjon. Hvilket krav
    #   skal eie regelen: OPT-BEH-BEH-018 eller et nytt krav?
    # - 23/5-regelen heter 23/6-regelen fra 1. januar 2027 (se OPT-BEH-BEH-022). Hvilket navn
    #   skal fasen ha?

  @depends-on-OPT-BEH-BEH-020 @ref-FLY-OPT-VAL-001 @ref-FLY-OPT-SAM-001
  # OPT-BEH-BEH-020: «Kravelementer som er koblet til vitnemålet, vurderes automatisk», «Kravelementene vurderes bare mot ett entydig vitnemål», «Kravelementene vurderes i den automatiske behandlingen»
  Regel: Kravelementene vurderes mot vitnemålet når poengene er beregnet

    Scenario: Kravelementet er vurdert mot vitnemålet
      Gitt at saken har grunnlag
      Og at "Informatikk, UiO" har kravelementet "Matematikk R1"
      Når søknaden behandles automatisk
      Så er kravelementet vurdert mot vitnemålet

  @depends-on-OPT-BEH-BEH-012 @depends-on-OPT-REG-KVO-002 @ref-FLY-OPT-VAL-001 @ref-FLY-OPT-SAM-001
  # OPT-BEH-BEH-012: «Kvotespørsmål med algoritme besvares automatisk og kan ikke endres av saksbehandleren»
  Regel: Kvotespørsmålene med algoritme besvares automatisk

    Scenario: Kvotespørsmålet er besvart automatisk
      Gitt at saken har grunnlag
      Og at grunnlaget er koblet til en kvotetype med kvotespørsmålet "ER-KVINNE"
      Og at kvotespørsmålet "ER-KVINNE" er koblet til algoritmen "Er kvinne"
      Når søknaden behandles automatisk
      Så er kvotespørsmålet "ER-KVINNE" besvart automatisk

  @depends-on-OPT-BEH-BEH-020 @ref-FLY-OPT-VAL-001 @ref-FLY-OPT-SAM-001
  # OPT-BEH-BEH-020: «Om søkeren er kvalifisert, avgjøres per grunnlag»
  # Oppdateres automatisk ut fra vurderingen av kravelementene.
  Regel: Kvalifiseringen oppdateres når kravelementene er vurdert

    Scenario: Søkeren er kvalifisert når vitnemålet oppfyller kravelementene
      Gitt at saken har grunnlag
      Og at "Informatikk, UiO" har kravelementet "Matematikk R1"
      Og at vitnemålet saken behandles helautomatisk på, har "Matematikk R1"
      Når søknaden behandles automatisk
      Så er søkeren kvalifisert for "Informatikk, UiO"

  @depends-on-OPT-BEH-BEH-012 @ref-FLY-OPT-VAL-001 @ref-FLY-OPT-SAM-001
  # OPT-BEH-BEH-012: «Søkeren plasseres automatisk i en kvote uten kvotespørsmål», «Søkeren plasseres i en kvote med kvotespørsmål når alle kvotespørsmålene er besvart ja»
  # Oppdateres automatisk ut fra kvalifiseringen og svarene på kvotespørsmålene.
  Regel: Søkeren fordeles på kvoter når kvalifiseringen og kvotesvarene er satt

    Scenario: Den kvalifiserte søkeren plasseres i kvoten grunnlaget er koblet til
      Gitt at søkeren er kvalifisert for "Informatikk, UiO"
      Og at grunnlaget er koblet til kvotetypen "Ordinær kvote"
      Når søknaden behandles automatisk
      Så er søkeren plassert i "Ordinær kvote" for "Informatikk, UiO"

    Scenario: Søkeren plasseres i kvoten når kvotespørsmålet er besvart ja automatisk
      Gitt at søkeren er kvalifisert for "Informatikk, UiO"
      Og at grunnlaget er koblet til kvotetypen "Jenter" med kvotespørsmålet "ER-KVINNE"
      Og at kvotespørsmålet "ER-KVINNE" er besvart ja automatisk
      Når søknaden behandles automatisk
      Så er søkeren plassert i "Jenter" for "Informatikk, UiO"

  @depends-on-OPT-BEH-BEH-031 @depends-on-OPT-REG-KVO-001 @depends-on-OPT-REG-RAN-002 @ref-FLY-OPT-VAL-001 @ref-FLY-OPT-SAM-001
  # OPT-BEH-BEH-031: «Søkeren får en poengsum for hver kvote og hvert grunnlag kvoten er koblet til», «Poengsummen regnes ut med poengformelen til kvotetypen», «Poengsummen regnes ut på nytt når det den bygger på, endres», «Bare grunnlag søkeren er kvalifisert på, gir poengsum», «En poengsum som ikke kan regnes ut, stopper ikke de andre», «Saksbehandleren ser den høyeste poengsummen per kvote for hvert søknadsalternativ»
  # OPT-REG-KVO-001: «En kvotetype kan ha en default poengformel»
  Regel: Søkeren får poengsum per kvote når søkeren er fordelt på kvoter
    # Oppdateres automatisk ut fra kvotene og poengene.

    Scenario: Søkeren har poengsum i kvoten
      Gitt at søkeren er plassert i "Ordinær kvote" for "Informatikk, UiO"
      Og at "Informatikk, UiO" har poengsum for søknaden
      Når søknaden behandles automatisk
      Så har søkeren poengsum etter poengformelen til "Ordinær kvote" for "Informatikk, UiO"

  @depends-on-OPT-BEH-BEH-008 @ref-FLY-OPT-VAL-001 @ref-FLY-OPT-SAM-001
  # OPT-BEH-BEH-008: «Saken får automatiske mangeltekster når søkeren ikke er kvalifisert»
  # Oppdateres automatisk ut fra vurderingen av kravelementene.
  Regel: Saken får mangeltekster når kravelementene er vurdert

    Scenario: Saken får mangeltekst for kravelementet vitnemålet ikke oppfyller
      Gitt at "Informatikk, UiO" har kravelementet "Matematikk R2"
      Og at vitnemålet saken behandles helautomatisk på, ikke har "Matematikk R2"
      Når søknaden behandles automatisk
      Så har saken en automatisk mangeltekst som viser at "Matematikk R2" ikke er oppfylt

  @depends-on-OPT-BEH-BEH-008 @ref-FLY-OPT-VAL-001 @ref-FLY-OPT-SAM-001
  # OPT-BEH-BEH-008: «Opptaksforvalteren merker én mangelkode for generell studiekompetanse som fullføres i vår», «Mangelen for generell studiekompetanse som fullføres i vår settes og sjekkes ut automatisk»
  Regel: Mangelen for GSK som fullføres i vår sjekkes ut før saken blir ferdig behandlet

    Scenario: Saken med mangelen for GSK som fullføres i vår blir ferdig behandlet
      Gitt at søkeren har oppgitt i søknaden at generell studiekompetanse fullføres i vår
      Og at saken hos "Universitetet i Oslo" har den automatiske mangelen "DUA"
      Når den automatiske behandlingen har behandlet saken helautomatisk
      Så er saken hos "Universitetet i Oslo" ferdig behandlet
      Og mangelen "DUA" er sjekket ut

  @depends-on-OPT-BEH-BEH-025 @depends-on-OPT-BEH-BEH-029 @ref-OPT-PLA-TIL-001 @ref-FLY-OPT-VAL-001 @ref-FLY-OPT-SAM-001
  # OPT-BEH-BEH-025: «Den automatiske behandlingen setter saken til ferdig behandlet når alt er avgjort», «Steg som bygger på et steg som ikke kan avgjøres, hoppes over»
  # OPT-BEH-BEH-029: «Saken kan bare bli Ferdig behandlet når den har minst én mangel eller ett grunnlag», «Saksloggen viser endringene i behandlingsstatusen»
  # Bare saker som er ferdig behandlet, er med i plasstildelingen. Det står i OPT-PLA-TIL-001.
  Regel: Saken blir ferdig behandlet og er klar til å være med i plasstildelingen

    Scenario: Saken er ferdig behandlet når den automatiske behandlingen har avgjort alt
      Gitt at søkeren er kvalifisert for "Informatikk, UiO"
      Og at "Informatikk, UiO" har poengsum for søknaden
      Og at søkeren er plassert i en kvote for "Informatikk, UiO"
      Når den automatiske behandlingen er ferdig
      Så er saken hos "Universitetet i Oslo" ferdig behandlet

    Scenario: Søkeren ser mangelteksten fra kravelementene når saken er ferdig behandlet
      Gitt at saken har en automatisk mangeltekst som viser at "Matematikk R2" ikke er oppfylt
      Når den automatiske behandlingen er ferdig
      Så er saken hos "Universitetet i Oslo" ferdig behandlet
      Og søkeren ser mangelteksten for "Matematikk R2" i Min kompetanse

    Scenario: Saken blir ikke ferdig behandlet når poengene ikke kan avgjøres
      Gitt at poengene for "Informatikk, UiO" ikke kan avgjøres på grunn av en feil i regelverket
      Når den automatiske behandlingen er ferdig
      Så er saken hos "Universitetet i Oslo" under behandling

  @depends-on-OPT-BEH-BEH-026 @ref-FLY-OPT-VAL-001 @ref-FLY-OPT-SAM-001
  # OPT-BEH-BEH-026: «Det som ble rettet, avgjør hvilke steg som beregnes på nytt», «Det saksbehandleren har satt, endres ikke», «Saker som er ferdig behandlet, forblir ferdig behandlet»
  Regel: Søknadsalternativene beregnes på nytt når regelverket er rettet

    Scenario: Poengene beregnes på nytt når rangeringsregelverket er rettet
      Gitt at saken hos "Universitetet i Oslo" er ferdig behandlet
      Og at opptaksforvalteren har rettet en feil i rangeringsregelverket
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket som er rettet
      Så har "Informatikk, UiO" poengsum etter det rettede rangeringsregelverket
      Og saken hos "Universitetet i Oslo" er fortsatt ferdig behandlet
