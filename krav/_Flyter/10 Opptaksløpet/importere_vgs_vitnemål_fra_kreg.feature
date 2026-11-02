# language: no
@FLY-OPT-VIT-001 @must @draft @e2e
Egenskap: Importere VGS-vitnemål fra KREG
  Fra KREG får et nytt eller annullert vitnemål fra videregående skole, til søknadene søkeren
  har i opptak som ikke er avsluttet, har fått GSK-konklusjonen fra vitnemålet, eller sakene
  som bruker det annullerte vitnemålet, er merket for saksbehandleren. En jobbplanlegger starter
  importen. Importen går gjennom alle aktive søkere i opptakssystemet, og leser alle
  VGS-dokumentene hver søker har i KREG, også annulleringene. Et vitnemål som ikke finnes fra
  før, importeres. Er det ikke annullert, beregnes opptakssystemets påstand om GSK for vitnemålet, og
  GSK-beregningen startes for hvert opptak søkeren har søknad i. Et vitnemål som finnes fra før
  og er annullert i KREG, oppdateres som annullert. Et annullert vitnemål håndteres etter
  reglene for annullerte vitnemål.

  # Fasene er etter prosesstegningen «Importer VGS-vitnemål fra KREG» (2026-10-29).
  # Underprosessen «Håndter annullert vitnemål» er ikke tegnet.
  # Endret 30.10.2026: den første versjonen går gjennom alle aktive søkere hver gang importen
  # kjører, og henter vitnemålene fra KREG for hver søker. Om noe er nytt eller annullert, ses
  # ved å sammenligne med vitnemålene som er importert. I neste versjon leser importen
  # hendelsesloggen i KREG, og henter bare vitnemålene for søkerne KREG har hendelser for.
  # Det kommer som en endring av flyten når hendelsesloggen i KREG er klar.
  # Et vitnemål som finnes fra før og ikke er annullert i KREG, endres ikke. Det gjelder også
  # når KREG har opphevet en annullering (se OPT-BEH-BEH-030).
  # Flyten beskriver vitnemålene. Kompetansebevis søkeren har i KREG, importeres på samme
  # måte (OPT-BEH-BEH-030), men får ingen påstand fra opptakssystemet om GSK (OPT-BEH-BEH-015).

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Kravet til jobbplanleggeren er ikke skrevet. Det kommer som et eget krav, og fasen får
  #   @depends-on- til det.
  Regel: Jobbplanleggeren starter importen av VGS-vitnemål fra KREG

    Scenario: Importen starter når jobbplanleggeren kjører jobben
      Gitt at jobben for import av VGS-vitnemål fra KREG er satt opp i jobbplanleggeren
      Når jobbplanleggeren starter jobben
      Så går importen gjennom alle aktive søkere i opptakssystemet

  @depends-on-OPT-BEH-BEH-030 @openquestion
  # OPT-BEH-BEH-030: «Nye og annullerte vitnemål i KREG importeres for aktive søkere»
  # En aktiv søker har en søknad som ikke er trukket, i et opptak som ikke er avsluttet.
  # Importen gjør ett oppslag i KREG per aktiv søker hver gang den kjører. Vi har dialog med
  # KREG-teamet om belastningen (30.10.2026).
  # ÅPNE SPØRSMÅL:
  # - Hvor ofte er det ansvarlig å kjøre importen, i hovedopptaket med mange søkere? Det skal
  #   testes sammen med KREG-teamet. Svaret settes i OPT-BEH-BEH-033, som har hvor ofte
  #   jobbene kjører.
  Regel: Vitnemålene hentes fra KREG for alle aktive søkere

    Scenario: Vitnemålene hentes for den aktive søkeren
      Gitt at "Kari Nordmann" har en søknad som ikke er trukket, i et opptak som ikke er avsluttet
      Når importen av VGS-vitnemål fra KREG kjører
      Så leses alle VGS-dokumentene "Kari Nordmann" har i KREG, også annulleringene

    Scenario: Vitnemålene hentes for søkeren med søknader i flere opptak bare én gang
      Gitt at "Kari Nordmann" har søknader i to opptak som ikke er avsluttet
      Når importen av VGS-vitnemål fra KREG kjører
      Så leses VGS-dokumentene til "Kari Nordmann" i KREG én gang

    Scenario: Vitnemålene hentes ikke for søkeren som ikke er aktiv
      Gitt at "Ola Nordmann" ikke har noen søknad som ikke er trukket, i et opptak som ikke er avsluttet
      Når importen av VGS-vitnemål fra KREG kjører
      Så leses ingen VGS-dokumenter for "Ola Nordmann" i KREG

  @depends-on-OPT-BEH-BEH-030
  # OPT-BEH-BEH-030: «Alle vitnemål og kompetansebevis søkeren har i KREG, importeres»
  Regel: Vitnemål som ikke finnes fra før, importeres

    Scenario: Nytt vitnemål i KREG importeres
      Gitt at "Kari Nordmann" har en søknad som ikke er trukket, i et opptak som ikke er avsluttet
      Og at "Kari Nordmann" har fått et vitnemål i KREG som ikke er importert
      Når importen av VGS-vitnemål fra KREG kjører
      Så er vitnemålet importert

    Scenario: Vitnemål som finnes fra før, er uendret
      Gitt at vitnemålet til "Kari Nordmann" er importert
      Og at vitnemålet ikke er annullert i KREG
      Når importen av VGS-vitnemål fra KREG kjører
      Så er det importerte vitnemålet uendret

  @depends-on-OPT-BEH-BEH-015
  # OPT-BEH-BEH-015: «Opptakssystemets påstand om GSK på vitnemålet»
  Regel: Påstanden om GSK beregnes når det nye vitnemålet er importert

    Scenario: Det nye vitnemålet får opptakssystemets påstand om GSK
      Gitt at "Kari Nordmann" har fått et vitnemål i KREG som består seksfagskontrollen
      Når importen av VGS-vitnemål fra KREG har importert vitnemålet
      Så er opptakssystemets påstand at søkeren har generell studiekompetanse

  @depends-on-OPT-BEH-BEH-015
  # OPT-BEH-BEH-015: «Konklusjon på søknaden fra vitnemålet»
  # Tegningen starter underprosessen «GSK-beregning for gitt opptak» for hvert opptak søkeren
  # har søknad i.
  Regel: Søknadene til søkeren får GSK-konklusjonen fra det nye vitnemålet

    Scenario: Hver søknad uten GSK-konklusjon får konklusjonen
      Gitt at "Kari Nordmann" har søknader i to opptak som ikke er avsluttet
      Og at ingen av søknadene har noen GSK-konklusjon
      Og at vitnemålet til "Kari Nordmann" gir GSK
      Når GSK-beregningen er startet for hvert opptak "Kari Nordmann" har søknad i
      Så får begge søknadene en positiv GSK-konklusjon

  @depends-on-OPT-BEH-BEH-030 @depends-on-OPT-BEH-BEH-015 @depends-on-OPT-BEH-BEH-034
  # OPT-BEH-BEH-030: «Et vitnemål som er annullert i KREG, er annullert i opptakssystemet»
  # OPT-BEH-BEH-015: «Annullert vitnemål»
  # OPT-BEH-BEH-034: «Saken merkes når et vitnemål som er i bruk, blir annullert», «En ferdig behandlet sak settes tilbake til under behandling»
  # Avklart 29.10.2026: underprosessen «Håndter annullert vitnemål» er OPT-BEH-BEH-034. Saken
  # merkes og settes tilbake til under behandling. Søknaden behandles ikke på nytt, og
  # GSK-konklusjonen trekkes ikke tilbake automatisk.
  Regel: Annullerte vitnemål håndteres

    Scenario: Vitnemålet som er annullert etter importen, blir annullert
      Gitt at vitnemålet til "Kari Nordmann" er importert
      Og at søknaden har en automatisk GSK-konklusjon som bygger på vitnemålet
      Og at vitnemålet er annullert i KREG etter importen
      Når importen av VGS-vitnemål fra KREG kjører
      Så er det importerte vitnemålet annullert
      Og GSK-konklusjonen på søknaden er uendret

    Scenario: Den ferdig behandlede saken settes tilbake når vitnemålet blir annullert
      Gitt at saken til "Kari Nordmann" hos "Universitetet i Oslo" er behandlet på vitnemålet
      Og at saken er ferdig behandlet
      Og at vitnemålet er annullert i KREG etter importen
      Når importen av VGS-vitnemål fra KREG kjører
      Så har saken taggen "Vitnemål annullert"
      Og saken har behandlingsstatusen "Under behandling"

    Scenario: Nytt vitnemål som er annullert, importeres uten påstand fra opptakssystemet om GSK
      Gitt at "Kari Nordmann" har et annullert vitnemål i KREG som ikke er importert
      Når importen av VGS-vitnemål fra KREG kjører
      Så er vitnemålet importert som annullert
      Og vitnemålet har ingen påstand fra opptakssystemet om generell studiekompetanse
