# language: no
@FLY-OPT-AUT-001 @must @draft @e2e @depends-on-FLY-OPT-SAK-001
Egenskap: Automatisk saksbehandling
  Fra søknaden er blitt en sak hos den saksbehandlende organisasjonen, til saken er ferdig
  behandlet og er med i plasstildelingen, uten at en saksbehandler har gjort noe. Søkerens
  vitnemål importeres fra KREG til opptakssystemet når saken er opprettet (OPT-BEH-BEH-030).
  Påstanden om GSK beregnes for hvert vitnemål når vitnemålet importeres fra KREG, og søknaden
  får GSK-konklusjonen da (OPT-BEH-BEH-015). «Importeres» betyr i flyten alltid at
  opptakssystemet henter vitnemålet fra KREG, ikke at vitnemålet kommer inn i KREG.
  Den automatiske behandlingen går gjennom alle søkerne. Som første steg setter den
  GSK-konklusjonen på søknadene som ikke har en. Flyten gjelder søkere med ett vitnemål,
  med påstanden at søkeren har GSK. Andre søkere hoppes over, og behandles ikke helautomatisk
  (se OPT-BEH-BEH-025). For søkerne i flyten setter den automatiske behandlingen grunnlaget,
  poengene, vurderingen av kravelementene og svarene på kvotespørsmålene, i den rekkefølgen.
  Det oppdaterer kvalifiseringen, kvotene, poengene per kvote og manglene. Til slutt sjekker den
  automatiske behandlingen ut mangelen for GSK som fullføres i vår, og setter saken til ferdig
  behandlet. Rettes en feil i regelverket, beregner opptaksforvalteren søknadsalternativene
  feilen gjaldt, på nytt.

  # Kjent brudd: den automatiske behandlingen setter ikke saken til ferdig behandlet, og
  # plasstildelingen krever ikke at saken er ferdig behandlet (se OPT-BEH-BEH-025 og OPT-PLA-TIL-001).
  # Kjent brudd: koden beregner GSK bare i den automatiske behandlingen, ikke når vitnemålet
  # importeres fra KREG, og påstanden lagres ikke på vitnemålet (se OPT-BEH-BEH-015).
  # Fasene er etter prosesstegningen for automatisk saksbehandling (2026-10-29). Kvalifiseringen,
  # kvotene, poengene per kvote og manglene er ikke egne steg: de oppdateres automatisk ut fra
  # stegene før, og er gule i tegningen. Tegningen har kravelementene før poengene. Det er
  # unøyaktig: poengene beregnes først (OPT-BEH-BEH-020).

  Bakgrunn:
    Gitt at søknaden til "Kari Nordmann" har en sak hos "Universitetet i Oslo"

  @depends-on-OPT-BEH-BEH-030
  # OPT-BEH-BEH-030: «Resultatene hentes når søknaden kommer inn», «Alle vitnemål og kompetansebevis søkeren har i KREG, importeres»
  Regel: Søkerens resultater importeres fra KREG når søknaden kommer inn

    Scenario: Vitnemålet fra KREG er klart for behandlingen når saken er opprettet
      Gitt at "Kari Nordmann" har et vitnemål i KREG
      Når saken hos "Universitetet i Oslo" er opprettet
      Så er vitnemålet importert
      Og GSK kan beregnes for vitnemålet

  @depends-on-OPT-BEH-BEH-015
  # OPT-BEH-BEH-015: «Opptakssystemets påstand om GSK på vitnemålet», «Konklusjon på søknaden fra vitnemålet», «Konklusjon fra tidligere opptak», «Automatikken setter bare positive konklusjoner, og bare der ingen finnes»
  Regel: Søknaden får GSK-konklusjonen når vitnemålet importeres fra KREG

    Scenario: Søknaden får GSK-konklusjonen fra vitnemålet som er importert fra KREG
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at "Kari Nordmann" har et vitnemål i KREG som gir generell studiekompetanse
      Når vitnemålet importeres fra KREG
      Så har vitnemålet påstanden at søkeren har generell studiekompetanse
      Og søknaden får en positiv GSK-konklusjon

  @depends-on-OPT-BEH-BEH-015
  # OPT-BEH-BEH-015: «GSK-konklusjonen settes også når den automatiske behandlingen kjører»
  Regel: Den automatiske behandlingen setter GSK-konklusjonen der den mangler
    # Påstanden på vitnemålet beregnes ikke på nytt i kjøringen.

    Scenario: Søknaden uten GSK-konklusjon får konklusjonen i kjøringen
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at "Kari Nordmann" har ett vitnemål med påstanden at søkeren har GSK
      Når søknaden behandles automatisk
      Så får søknaden en positiv GSK-konklusjon

  @depends-on-OPT-BEH-BEH-015 @depends-on-OPT-BEH-BEH-025
  # OPT-BEH-BEH-015: «Opptakssystemets påstand om GSK på vitnemålet»
  # OPT-BEH-BEH-025: «Bare saker der søkeren har ett vitnemål, med påstanden GSK, behandles helautomatisk»
  Regel: Vitnemålet med påstanden GSK avgjør om saken behandles helautomatisk

    Scenario: Saken behandles helautomatisk på vitnemålet med påstanden GSK
      Gitt at "Kari Nordmann" har ett vitnemål med påstanden at søkeren har GSK
      Når søknaden behandles automatisk
      Så behandles saken hos "Universitetet i Oslo" helautomatisk på vitnemålet

    Scenario: Søkeren hoppes over når ingen vitnemål har påstanden GSK
      Gitt at ingen av vitnemålene til "Kari Nordmann" har påstanden at søkeren har GSK
      Når søknaden behandles automatisk
      Så behandles ikke saken hos "Universitetet i Oslo" helautomatisk

  @depends-on-OPT-BEH-BEH-019
  # OPT-BEH-BEH-019: «Grunnlaget velges ut fra egenskapene regelverket har gitt det», «Ingen automatisk grunnlag uten ett vitnemål som gir generell studiekompetanse», «Grunnlaget settes når den automatiske behandlingen kjører»
  Regel: Søknaden får grunnlag fra vitnemålet

    Scenario: Søknaden får grunnlag
      Gitt at saken hos "Universitetet i Oslo" behandles helautomatisk på vitnemålet
      Når søknaden behandles automatisk
      Så har søknaden grunnlag

  @depends-on-OPT-BEH-BEH-018 @depends-on-OPT-REG-RAN-001 @depends-on-OPT-REG-RAN-002
  # OPT-BEH-BEH-018: «Karakterpoeng, realfagspoeng og språkpoeng beregnes fra søkerens eneste vitnemål», «Skolepoeng settes sammen av karakterpoeng, realfagspoeng og språkpoeng», «Ingen automatisk beregning uten ett entydig vitnemål»
  Regel: Poengene beregnes fra grunnlaget og rangeringsregelverket
    # Overleveringen: grunnlaget avgjør hvilke poengtyper søknaden har (rangeringsregelverket
    # kobler grunnlag til poengtyper), og poengene i dem beregnes fra vitnemålet.
    # Avklart 2026-10-27 i review av PR #818, fra koden i fs-plattform (PoengRadOppdateringService).

    Scenario: Søknadsalternativet får poengsum
      Gitt at søknaden har grunnlag
      Når søknaden behandles automatisk
      Så har "Informatikk, UiO" poengsum for søknaden

  @depends-on-OPT-BEH-BEH-028
  # OPT-BEH-BEH-028: «Alderspoeng regnes ut fra søkerens alder», «Kjønnspoeng regnes ut fra søkerens kjønn», «Poeng for høyere utdanning regnes ut fra søkerens studiepoeng», «Tilleggspoengene settes uansett hvem som velger grunnlaget»
  Regel: Søknaden får tilleggspoeng når grunnlaget er satt

    Scenario: Søknaden får tilleggspoengene for grunnlaget
      Gitt at søknaden har grunnlag
      Når søknaden behandles automatisk
      Så har søknaden tilleggspoengene rangeringsregelverket gir for grunnlaget

  @depends-on-OPT-BEH-BEH-020
  # OPT-BEH-BEH-020: «Kravelementer som er koblet til vitnemålet, vurderes automatisk», «Kravelementene vurderes bare mot ett entydig vitnemål», «Kravelementene vurderes i den automatiske behandlingen»
  Regel: Kravelementene vurderes mot vitnemålet når poengene er beregnet

    Scenario: Kravelementet er vurdert mot vitnemålet
      Gitt at søknaden har grunnlag
      Og at "Informatikk, UiO" har kravelementet "Matematikk R1"
      Når søknaden behandles automatisk
      Så er kravelementet vurdert mot vitnemålet

  @depends-on-OPT-BEH-BEH-012 @depends-on-OPT-REG-KVO-002
  # OPT-BEH-BEH-012: «Kvotespørsmål med algoritme besvares automatisk og kan ikke endres av saksbehandleren»
  Regel: Kvotespørsmålene med algoritme besvares automatisk

    Scenario: Kvotespørsmålet er besvart automatisk
      Gitt at søknaden har grunnlag
      Og at grunnlaget er koblet til en kvotetype med kvotespørsmålet "ER-KVINNE"
      Og at kvotespørsmålet "ER-KVINNE" er koblet til algoritmen "Er kvinne"
      Når søknaden behandles automatisk
      Så er kvotespørsmålet "ER-KVINNE" besvart automatisk

  @depends-on-OPT-BEH-BEH-020
  # OPT-BEH-BEH-020: «Om søkeren er kvalifisert, avgjøres per grunnlag»
  # Oppdateres automatisk ut fra vurderingen av kravelementene.
  Regel: Kvalifiseringen oppdateres når kravelementene er vurdert

    Scenario: Søkeren er kvalifisert når vitnemålet oppfyller kravelementene
      Gitt at søknaden har grunnlag
      Og at "Informatikk, UiO" har kravelementet "Matematikk R1"
      Og at vitnemålet saken behandles helautomatisk på, har "Matematikk R1"
      Når søknaden behandles automatisk
      Så er søkeren kvalifisert for "Informatikk, UiO"

  @depends-on-OPT-BEH-BEH-012
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

  @openquestion @depends-on-OPT-REG-KVO-001 @depends-on-OPT-REG-RAN-002
  # OPT-REG-KVO-001: «En kvotetype kan ha en default poengformel»
  Regel: Søkeren får poengsum per kvote når søkeren er fordelt på kvoter
    # ÅPNE SPØRSMÅL:
    # - Ingen krav i behandlingen beskriver at poengsummen per kvote beregnes. Hvilket krav skal
    #   eie regelen: OPT-BEH-BEH-012, OPT-BEH-BEH-018 eller et nytt krav?
    # Oppdateres automatisk ut fra kvotene og poengene.

    Scenario: Søkeren har poengsum i kvoten
      Gitt at søkeren er plassert i "Ordinær kvote" for "Informatikk, UiO"
      Og at "Informatikk, UiO" har poengsum for søknaden
      Når søknaden behandles automatisk
      Så har søkeren poengsum etter poengformelen til "Ordinær kvote" for "Informatikk, UiO"

  @depends-on-OPT-BEH-BEH-008
  # OPT-BEH-BEH-008: «Saken får mangler for kravelementene søkeren ikke oppfyller»
  # Oppdateres automatisk ut fra vurderingen av kravelementene.
  Regel: Saken får mangler når kravelementene er vurdert

    Scenario: Saken får mangel for kravelementet vitnemålet ikke oppfyller
      Gitt at "Informatikk, UiO" har kravelementet "Matematikk R2"
      Og at vitnemålet saken behandles helautomatisk på, ikke har "Matematikk R2"
      Når søknaden behandles automatisk
      Så har saken en automatisk mangel som viser at "Matematikk R2" ikke er oppfylt

  @depends-on-OPT-BEH-BEH-008
  # OPT-BEH-BEH-008: «Mangelen for generell studiekompetanse som fullføres i vår settes og sjekkes ut automatisk»
  Regel: Mangelen for GSK som fullføres i vår sjekkes ut før saken blir ferdig behandlet

    Scenario: Mangelen sjekkes ut når saken er behandlet helautomatisk
      Gitt at saken hos "Universitetet i Oslo" har den automatiske mangelen "DUA"
      Når den automatiske behandlingen har behandlet saken helautomatisk
      Så er mangelen "DUA" sjekket ut før saken er ferdig behandlet

  @depends-on-OPT-BEH-BEH-025 @depends-on-OPT-PLA-TIL-001
  # OPT-BEH-BEH-025: «Den automatiske behandlingen setter saken til ferdig behandlet når alt er avgjort», «Steg som bygger på et steg som ikke kan avgjøres, hoppes over»
  Regel: Saken blir ferdig behandlet og er med i plasstildelingen

    Scenario: Saken er med i plasstildelingen når den automatiske behandlingen har avgjort alt
      Gitt at søkeren er kvalifisert for "Informatikk, UiO"
      Og at "Informatikk, UiO" har poengsum for søknaden
      Og at søkeren er plassert i en kvote for "Informatikk, UiO"
      Når den automatiske behandlingen er ferdig
      Så er saken hos "Universitetet i Oslo" ferdig behandlet
      Og saken hos "Universitetet i Oslo" er med når opptaksforvalteren starter en plasstildeling

    Scenario: Søkeren ser mangelen fra kravelementene når saken er ferdig behandlet
      Gitt at saken har en automatisk mangel som viser at "Matematikk R2" ikke er oppfylt
      Når den automatiske behandlingen er ferdig
      Så er saken hos "Universitetet i Oslo" ferdig behandlet
      Og søkeren ser mangelen for "Matematikk R2" i Min kompetanse

    Scenario: Saken er ikke med i plasstildelingen når poengene ikke kan avgjøres
      Gitt at poengene for "Informatikk, UiO" ikke kan avgjøres på grunn av en feil i regelverket
      Når den automatiske behandlingen er ferdig
      Så er saken hos "Universitetet i Oslo" ikke med når opptaksforvalteren starter en plasstildeling

  @depends-on-OPT-BEH-BEH-026
  Regel: Søknadsalternativene beregnes på nytt når regelverket er rettet

    Scenario: Poengene beregnes på nytt når rangeringsregelverket er rettet
      Gitt at saken hos "Universitetet i Oslo" er ferdig behandlet
      Og at opptaksforvalteren har rettet en feil i rangeringsregelverket
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket som er rettet
      Så har "Informatikk, UiO" poengsum etter det rettede rangeringsregelverket
      Og saken hos "Universitetet i Oslo" er fortsatt ferdig behandlet
