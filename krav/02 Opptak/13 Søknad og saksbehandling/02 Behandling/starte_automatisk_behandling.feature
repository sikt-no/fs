# language: no
@OPT-BEH-BEH-032 @must @draft @ref-OPT-BEH-BEH-025
Egenskap: Starte automatisk behandling
  Som saksbehandler
  ønsker jeg at den automatiske behandlingen starter av seg selv for hver ny sak
  slik at sakene som kan behandles helautomatisk, blir ferdig behandlet uten at jeg gjør noe.

  Den automatiske behandlingen er en fortsettelse av saksbehandlertildelingen. Hver ny sak
  behandles automatisk når søkerens resultater er importert fra KREG. Har søkeren ikke noe
  vitnemål når saken opprettes, starter behandlingen når jobben for nye vitnemål finner det
  første vitnemålet i KREG. Et nytt vitnemål i en sak som har vitnemål fra før, er ny
  dokumentasjon: behandlingen starter ikke av seg selv, og saksbehandleren ser at saken har fått
  ny dokumentasjon. Saksbehandleren kan velge et vitnemål og starte den automatiske behandlingen
  på det. Det saksbehandleren har gjort i saken, endres aldri av automatikken. Opptaksforvalteren
  skrur automatikken av og på for opptaket, og kan sette tidspunktet da automatikken stopper.
  Hva behandlingen gjør med saken, står i kravene flyten FLY-OPT-AUT-001 bygger på.

  # Avklart med domeneeksperten 29.10.2026.
  # Kode i dag: saksbehandleren kan starte behandlingen for én sak med knappen «Start automatisk
  # behandling» i FS Admin, uten å velge vitnemål. Ingenting starter behandlingen når saken er
  # opprettet, og ingen jobb sjekker om det har kommet nye vitnemål. Automatikken kan ikke skrus
  # av for et opptak.
  # Hvor ofte jobbene kjører, står i OPT-BEH-BEH-033 (PR #864).
  # Saksbehandleren velger vitnemålet når søkeren har flere vitnemål med påstanden GSK, i
  # OPT-BEH-BEH-025.

  # ÅPNE SPØRSMÅL:
  # - Er «ny dokumentasjon» i sakslisten en behandlingsstatus (OPT-BEH-BEH-029), eller en egen
  #   markering ved siden av? OPT-BEH-BEH-029 sier at ny dokumentasjon ikke endrer
  #   behandlingsstatusen.
  # - Er «ny dokumentasjon» den samme markeringen som «nye resultater» i OPT-BEH-BEH-035 og
  #   taggen «Vitnemål annullert» i OPT-BEH-BEH-034? Alle tre merker saken når
  #   søkeren får et nytt eller annullert vitnemål.
  # - Er varselet om nytt vitnemål det samme som i OPT-BEH-BEH-021?

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" forvaltes av HK-dir
    Og at "Universitetet i Oslo" deltar i opptaket
    Og at automatisk saksbehandling er skrudd på for "Samordna opptak 2027"

  @depends-on-OPT-BEH-BEH-011 @depends-on-OPT-BEH-BEH-030 @ref-FLY-OPT-AUT-001
  # OPT-BEH-BEH-011: «Søknadsalternativene fordeles når søknaden sendes inn eller endres, og fordelingen ligger fast»
  # OPT-BEH-BEH-030: «Resultatene hentes når søknaden kommer inn»
  Regel: Behandlingen kjører for hver ny sak saksbehandlertildelingen oppretter

    Scenario: Den nye saken behandles automatisk når saksbehandlertildelingen har opprettet den
      Gitt at "Kari Nordmann" har sendt inn søknaden
      Og at "Kari Nordmann" har et vitnemål i KREG
      Når saksbehandlertildelingen har opprettet saken hos "Universitetet i Oslo"
      Så behandles saken hos "Universitetet i Oslo" automatisk når vitnemålet er importert

  @depends-on-OPT-BEH-BEH-030 @ref-FLY-OPT-VIT-001 @ref-FLY-OPT-AUT-001
  # OPT-BEH-BEH-030: «Endringer i KREG importeres gjennom et abonnement»
  Regel: Behandlingen kjører når søkeren får det første vitnemålet

    Scenario: Saken behandles automatisk når jobben finner søkerens første vitnemål
      Gitt at "Kari Nordmann" har levert søknaden uten å ha et vitnemål i KREG
      Og at "Kari Nordmann" har fått et vitnemål i KREG
      Når jobben for nye vitnemål i KREG kjører
      Så behandles saken hos "Universitetet i Oslo" automatisk når vitnemålet er importert

  @depends-on-OPT-BEH-BEH-030 @ref-OPT-BEH-BEH-021 @ref-OPT-BEH-BEH-029
  # OPT-BEH-BEH-030: «Endringer i KREG importeres gjennom et abonnement»
  Regel: Et nytt vitnemål i en sak med vitnemål er ny dokumentasjon

    Scenario: Saksbehandleren ser at saken har fått ny dokumentasjon
      Gitt at saken hos "Universitetet i Oslo" er behandlet automatisk på vitnemålet til "Kari Nordmann"
      Og at "Kari Nordmann" har fått et nytt vitnemål i KREG
      Når jobben for nye vitnemål i KREG kjører
      Så ser saksbehandleren ved Universitetet i Oslo «Ny dokumentasjon» på saken i sakslisten

    Scenario: Saken behandles ikke automatisk på nytt når det kommer et nytt vitnemål
      Gitt at saken hos "Universitetet i Oslo" er behandlet automatisk på vitnemålet til "Kari Nordmann"
      Og at "Kari Nordmann" har fått et nytt vitnemål i KREG
      Når jobben for nye vitnemål i KREG kjører
      Så behandles ikke saken hos "Universitetet i Oslo" automatisk på nytt

  @depends-on-OPT-BEH-BEH-029 @depends-on-OPT-BEH-BEH-025
  # OPT-BEH-BEH-029: «Saksbehandleren kan sette behandlingsstatusen», «Saken blir Under behandling når saksbehandleren endrer vurderingen eller leser et dokument»
  # OPT-BEH-BEH-025: «Har søkeren flere vitnemål med påstanden GSK, behandles saken automatisk på vitnemålet saksbehandleren velger»
  # Valget av vitnemål står i OPT-BEH-BEH-025. Dette kravet har starten av behandlingen.
  Regel: Saksbehandleren starter den automatiske behandlingen på vitnemålet som er valgt
    # Avklart 29.10.2026: det trengs ingen mulighet til å velge flere saker i sakslisten og
    # starte behandlingen for dem. Behandlingen starter av seg selv.

    Bakgrunn:
      Gitt at søknaden til "Kari Nordmann" har en sak hos "Universitetet i Oslo"
      Og at "Kari Nordmann" har vitnemålene "Vitnemål 2025" og "Vitnemål 2026"

    Scenario: Saken som er under behandling, behandles automatisk på vitnemålet saksbehandleren velger
      Gitt at saken har behandlingsstatusen "Under behandling"
      Når saksbehandleren ved Universitetet i Oslo starter den automatiske behandlingen på "Vitnemål 2026"
      Så behandles saken automatisk på "Vitnemål 2026"

    Scenario: Saken som er ferdig behandlet, settes til Under behandling når behandlingen startes
      Gitt at saken har behandlingsstatusen "Ferdig behandlet"
      Og at den automatiske behandlingen ikke kan avgjøre alle stegene på "Vitnemål 2026"
      Når saksbehandleren ved Universitetet i Oslo starter den automatiske behandlingen på "Vitnemål 2026"
      Så har saken behandlingsstatusen "Under behandling"

    @depends-on-OPT-BEH-BEH-025
    # OPT-BEH-BEH-025: «Den automatiske behandlingen setter saken til ferdig behandlet når alt er avgjort»
    Scenario: Saken blir ferdig behandlet igjen når automatikken avgjør alt
      Gitt at saken har behandlingsstatusen "Ferdig behandlet"
      Og at den automatiske behandlingen kan avgjøre alle stegene på "Vitnemål 2026"
      Når saksbehandleren ved Universitetet i Oslo starter den automatiske behandlingen på "Vitnemål 2026"
      Så har saken behandlingsstatusen "Ferdig behandlet"
      Og saksbehandleren ser at saken er behandlet automatisk

    @depends-on-OPT-BEH-BEH-011
    # OPT-BEH-BEH-011: «Saksbehandlende organisasjon ser bare saker hos organisasjonen»
    Scenario: Saksbehandleren starter bare behandlingen for saker hos organisasjonen
      Gitt at søknaden til "Kari Nordmann" har en sak hos "Universitetet i Bergen"
      Når saksbehandleren ved Universitetet i Oslo vil starte den automatiske behandlingen
      Så kan saksbehandleren ikke starte behandlingen for saken hos "Universitetet i Bergen"

  @ref-OPT-BEH-BEH-019 @ref-OPT-BEH-BEH-020 @ref-OPT-BEH-BEH-018
  Regel: Det saksbehandleren har gjort, endres ikke av automatikken
    # Reglene for hvert steg står i kravene til grunnlaget, poengene og kravelementene.

    Scenario: Grunnlaget saksbehandleren har valgt, står når behandlingen startes
      Gitt at saken hos "Universitetet i Oslo" har behandlingsstatusen "Under behandling"
      Og at saksbehandleren ved Universitetet i Oslo har valgt grunnlaget for saken
      Når saksbehandleren starter den automatiske behandlingen på vitnemålet til "Kari Nordmann"
      Så har saken fortsatt grunnlaget saksbehandleren valgte

  @depends-on-OPT-BEH-BEH-025
  # OPT-BEH-BEH-025: «Den automatiske behandlingen setter saken til ferdig behandlet når alt er avgjort»
  Regel: Det fremgår at saken er behandlet automatisk

    Scenario: Saken som er ferdig behandlet automatisk, viser at den er behandlet automatisk
      Gitt at søknaden til "Kari Nordmann" har en sak hos "Universitetet i Oslo"
      Og at "Kari Nordmann" har ett vitnemål med påstanden at søkeren har GSK
      Når søknaden behandles automatisk
      Så er saken hos "Universitetet i Oslo" ferdig behandlet
      Og saksbehandleren ved Universitetet i Oslo ser at saken er behandlet automatisk

  Regel: Opptaksforvalteren skrur automatikken av og på for opptaket
    # Gjelder for ett opptak, ikke for hele systemet. Kode i dag: det finnes ingen innstilling for
    # dette.

    Scenario: Saken behandles ikke automatisk når automatikken er skrudd av
      Gitt at opptaksforvalteren ved HK-dir har skrudd av automatisk saksbehandling for "Samordna opptak 2027"
      Og at "Kari Nordmann" har et vitnemål i KREG
      Når saksbehandlertildelingen har opprettet saken hos "Universitetet i Oslo"
      Så behandles ikke saken hos "Universitetet i Oslo" automatisk

    Scenario: Automatikken stopper på tidspunktet opptaksforvalteren har satt
      Gitt at opptaksforvalteren ved HK-dir har satt at automatisk saksbehandling stopper 15.07.2027 kl. 12.00 for "Samordna opptak 2027"
      Og at klokken er 15.07.2027 kl. 12.01
      Når saksbehandlertildelingen har opprettet saken hos "Universitetet i Oslo"
      Så behandles ikke saken hos "Universitetet i Oslo" automatisk

    Scenario: Automatikken i ett opptak påvirker ikke andre opptak
      Gitt at opptaksforvalteren ved HK-dir har skrudd av automatisk saksbehandling for "Samordna opptak 2027"
      Og at automatisk saksbehandling er skrudd på for "Lokalt opptak UiO 2027"
      Når saksbehandlertildelingen har opprettet en sak i "Lokalt opptak UiO 2027"
      Så behandles saken automatisk

  Regel: Feil i saken vises på saken, og tekniske feil prøves på nytt
    # Hvor mange ganger behandlingen prøves på nytt, og hvor lenge, står i
    # applikasjonsinnstillingene. Hvordan jobbene vises, avklares senere.

    Scenario: Saken viser at den ikke kunne behandles automatisk fordi søkeren ikke har vitnemål
      Gitt at "Kari Nordmann" ikke har noe vitnemål i KREG
      Når saksbehandlertildelingen har opprettet saken hos "Universitetet i Oslo"
      Så ser saksbehandleren ved Universitetet i Oslo på saken at den ikke kunne behandles automatisk fordi søkeren ikke har vitnemål

    Scenario: Behandlingen prøves på nytt når KREG ikke svarer
      Gitt at den automatiske behandlingen feilet for saken til "Kari Nordmann" fordi KREG ikke svarte
      Når KREG svarer igjen innenfor tiden i applikasjonsinnstillingene
      Så behandles saken hos "Universitetet i Oslo" automatisk

    Scenario: Saksbehandleren ser ikke tekniske feil på saken
      Gitt at den automatiske behandlingen feilet for saken til "Kari Nordmann" fordi KREG ikke svarte
      Når saksbehandleren ved Universitetet i Oslo ser på saken
      Så ser saksbehandleren ingen feilmelding om KREG på saken

    Scenario: Sikt varsles om en teknisk feil
      Gitt at saken til "Kari Nordmann" skal behandles automatisk
      Når den automatiske behandlingen feiler fordi KREG ikke svarer
      Så får Sikt et varsel om at den automatiske behandlingen har feilet
