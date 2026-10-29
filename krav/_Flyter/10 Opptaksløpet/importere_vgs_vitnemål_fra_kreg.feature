# language: no
@FLY-OPT-VIT-001 @must @draft @e2e
Egenskap: Importere VGS-vitnemål fra KREG
  Fra KREG får et nytt eller annullert vitnemål fra videregående skole, til søknadene søkeren
  har i opptak som ikke er avsluttet, har fått GSK-konklusjonen fra vitnemålet, eller
  konklusjonen er trukket tilbake. En jobbplanlegger starter importen. Importen leser
  hendelsesloggen i KREG, og gjelder en hendelse minst én aktiv søker i opptakssystemet, leses
  alle VGS-dokumentene søkeren har i KREG, også annulleringene. Et vitnemål som ikke finnes fra
  før, importeres. Er det ikke annullert, beregnes påstanden om GSK for vitnemålet, og
  GSK-beregningen startes for hvert opptak søkeren har søknad i. Et vitnemål som finnes fra før
  og er annullert i KREG, oppdateres som annullert. Et annullert vitnemål håndteres etter
  reglene for annullerte vitnemål.

  # Fasene er etter prosesstegningen «Importer VGS-vitnemål fra KREG» (2026-10-29).
  # Underprosessen «Håndter annullert vitnemål» er ikke tegnet.
  # Et vitnemål som finnes fra før og ikke er annullert i KREG, endres ikke. Det gjelder også
  # når KREG har opphevet en annullering (se OPT-BEH-BEH-030).

  # ÅPNE SPØRSMÅL:
  # - Tegningen leser alle VGS-dokumentene, men går gjennom vitnemålene. Importeres
  #   kompetansebevisene også i denne flyten? De får ingen påstand om GSK (OPT-BEH-BEH-015).

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Kravet til jobbplanleggeren er ikke skrevet. Det kommer som et eget krav, og fasen får
  #   @depends-on- til det.
  Regel: Jobbplanleggeren starter importen av VGS-vitnemål fra KREG

    Scenario: Importen starter når jobbplanleggeren kjører jobben
      Gitt at jobben for import av VGS-vitnemål fra KREG er satt opp i jobbplanleggeren
      Når jobbplanleggeren starter jobben
      Så leser importen hendelsesloggen fra KREG

  @depends-on-OPT-BEH-BEH-030 @openquestion
  # OPT-BEH-BEH-030: «Endringer i KREG importeres gjennom et abonnement»
  # ÅPNE SPØRSMÅL:
  # - Hva er en aktiv søker i opptakssystemet: en søker med søknad i et opptak som ikke er
  #   avsluttet? OPT-BEH-BEH-030 har det samme spørsmålet om abonnementet.
  Regel: Bare hendelser for aktive søkere gir import

    Scenario: Hendelsen gjelder en aktiv søker
      Gitt at "Kari Nordmann" har en søknad i et opptak som ikke er avsluttet
      Og at hendelsesloggen i KREG har en hendelse for "Kari Nordmann"
      Når importen av VGS-vitnemål fra KREG kjører
      Så leses alle VGS-dokumentene "Kari Nordmann" har i KREG, også annulleringene

    Scenario: Hendelsen gjelder ingen aktiv søker
      Gitt at "Ola Nordmann" ikke har noen søknad i et opptak som ikke er avsluttet
      Og at hendelsesloggen i KREG har en hendelse for "Ola Nordmann"
      Når importen av VGS-vitnemål fra KREG kjører
      Så importeres ingen vitnemål for "Ola Nordmann"

  @depends-on-OPT-BEH-BEH-030
  # OPT-BEH-BEH-030: «Alle vitnemål og kompetansebevis søkeren har i KREG, importeres»
  Regel: Vitnemål som ikke finnes fra før, importeres

    Scenario: Nytt vitnemål i KREG importeres
      Gitt at "Kari Nordmann" har en søknad i et opptak som ikke er avsluttet
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

    Scenario: Det nye vitnemålet får påstanden om GSK
      Gitt at "Kari Nordmann" har fått et vitnemål i KREG som gir generell studiekompetanse
      Når importen av VGS-vitnemål fra KREG har importert vitnemålet
      Så har vitnemålet påstanden at søkeren har generell studiekompetanse

  @depends-on-OPT-BEH-BEH-015 @openquestion
  # OPT-BEH-BEH-015: «Konklusjon på søknaden fra vitnemålet»
  # Tegningen starter underprosessen «GSK-beregning for gitt opptak» for hvert opptak søkeren
  # har søknad i.
  # ÅPNE SPØRSMÅL:
  # - Beregnes GSK-konklusjonen bare for søknaden til søkeren vitnemålet er utstedt til, eller
  #   for alle søknadene i opptaket?
  Regel: Søknadene til søkeren får GSK-konklusjonen fra det nye vitnemålet

    Scenario: Hver søknad uten GSK-konklusjon får konklusjonen
      Gitt at "Kari Nordmann" har søknader i to opptak som ikke er avsluttet
      Og at ingen av søknadene har noen GSK-konklusjon
      Og at vitnemålet til "Kari Nordmann" har påstanden at søkeren har GSK
      Når GSK-beregningen er startet for hvert opptak "Kari Nordmann" har søknad i
      Så får begge søknadene en positiv GSK-konklusjon

  @depends-on-OPT-BEH-BEH-030 @depends-on-OPT-BEH-BEH-015 @openquestion
  # OPT-BEH-BEH-030: «Et vitnemål som er annullert i KREG, er annullert i opptakssystemet»
  # OPT-BEH-BEH-015: «Annullert vitnemål»
  # ÅPNE SPØRSMÅL:
  # - Underprosessen «Håndter annullert vitnemål» er ikke tegnet. Gjør den mer enn å trekke
  #   tilbake GSK-konklusjonen (OPT-BEH-BEH-015)? Behandles søknaden på nytt, eller varsles
  #   saksbehandleren? Spørsmålet står også i OPT-BEH-BEH-030.
  Regel: Annullerte vitnemål håndteres

    Scenario: Vitnemålet som er annullert etter importen, blir annullert
      Gitt at vitnemålet til "Kari Nordmann" er importert
      Og at søknaden har en automatisk GSK-konklusjon som bygger på vitnemålet
      Og at vitnemålet er annullert i KREG etter importen
      Når importen av VGS-vitnemål fra KREG kjører
      Så er det importerte vitnemålet annullert
      Og GSK-konklusjonen på søknaden er ikke lenger positiv

    Scenario: Nytt vitnemål som er annullert, importeres uten påstand om GSK
      Gitt at "Kari Nordmann" har et annullert vitnemål i KREG som ikke er importert
      Når importen av VGS-vitnemål fra KREG kjører
      Så er vitnemålet importert som annullert
      Og vitnemålet har ingen påstand om generell studiekompetanse
