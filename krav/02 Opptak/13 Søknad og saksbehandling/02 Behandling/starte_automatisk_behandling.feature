# language: no
@OPT-BEH-BEH-032 @must @draft @ref-OPT-BEH-BEH-025
Egenskap: Starte automatisk behandling
  Som saksbehandler
  ønsker jeg at den automatiske behandlingen starter av seg selv for hver ny sak
  slik at sakene som kan behandles helautomatisk, blir ferdig behandlet uten at jeg gjør noe.

  Den automatiske behandlingen er en fortsettelse av saksbehandlertildelingen. Hver ny sak
  behandles automatisk når søkerens resultater er importert fra KREG. En jobb sjekker om det har
  kommet nye vitnemål i KREG, og har det det, kjører behandlingen for saken. Hvor ofte
  saksbehandlertildelingen og jobben for nye vitnemål kjører, konfigureres på samme måte.
  Saksbehandleren og opptaksforvalteren kan i tillegg starte behandlingen selv, for én sak eller
  flere saker. Automatikken kjører så lenge det kan opprettes saker i opptaket. Hva behandlingen
  gjør med saken, står i kravene flyten FLY-OPT-AUT-001 bygger på.

  # Kode i dag: saksbehandleren kan starte behandlingen for én sak med knappen «Start automatisk
  # behandling» i FS Admin. Ingenting starter behandlingen når saken er opprettet, og ingen jobb
  # sjekker om det har kommet nye vitnemål. Resultatene hentes fra KREG når sakene er opprettet,
  # men behandlingen starter ikke etterpå.

  # ÅPNE SPØRSMÅL:
  # - Hvilke saker er med når behandlingen starter? Domeneeksperten har nevnt at det som kan
  #   behandles automatisk, skal behandles automatisk. Gjelder det også saker som er under
  #   behandling eller ferdig behandlet, og når saksbehandleren starter behandlingen selv?
  #   Spørsmålet om ferdig behandlede saker står også i OPT-BEH-BEH-025.

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" forvaltes av HK-dir
    Og at "Universitetet i Oslo" deltar i opptaket

  @depends-on-OPT-BEH-BEH-011 @depends-on-OPT-BEH-BEH-030
  # OPT-BEH-BEH-011: «Søknadsalternativene fordeles når søknaden sendes inn eller endres, og fordelingen ligger fast»
  # OPT-BEH-BEH-030: «Resultatene hentes når søknaden kommer inn»
  Regel: Behandlingen kjører for hver ny sak saksbehandlertildelingen oppretter

    Scenario: Den nye saken behandles automatisk når saksbehandlertildelingen har opprettet den
      Gitt at "Kari Nordmann" har sendt inn søknaden
      Og at "Kari Nordmann" har et vitnemål i KREG
      Når saksbehandlertildelingen har opprettet saken hos "Universitetet i Oslo"
      Så behandles saken hos "Universitetet i Oslo" automatisk når vitnemålet er importert

  @depends-on-OPT-BEH-BEH-030 @ref-FLY-OPT-VIT-001
  # OPT-BEH-BEH-030: «Endringer i KREG importeres gjennom et abonnement»
  Regel: Behandlingen kjører når jobben for nye vitnemål finner et nytt vitnemål

    Scenario: Saken behandles automatisk når jobben finner et nytt vitnemål
      Gitt at "Kari Nordmann" har levert søknaden uten å ha et vitnemål i KREG
      Og at saken hos "Universitetet i Oslo" ikke er ferdig behandlet
      Og at "Kari Nordmann" har fått et vitnemål i KREG
      Når jobben for nye vitnemål i KREG kjører
      Så behandles saken hos "Universitetet i Oslo" automatisk når vitnemålet er importert

    Scenario: Saken behandles ikke når jobben ikke finner nye vitnemål
      Gitt at saken hos "Universitetet i Oslo" er behandlet automatisk
      Og at "Kari Nordmann" ikke har fått nye vitnemål i KREG
      Når jobben for nye vitnemål i KREG kjører
      Så behandles ikke saken hos "Universitetet i Oslo" på nytt

  Regel: Saksbehandleren og opptaksforvalteren kan starte behandlingen for én sak eller flere saker

    Scenariomal: <aktør> starter behandlingen for <saker>
      Gitt at søknadene til "Kari Nordmann" og "Ola Nordmann" har saker hos "Universitetet i Oslo"
      Når <aktør> starter den automatiske behandlingen for <saker>
      Så behandles <saker> automatisk

      Eksempler:
        | aktør                                    | saker                                        |
        | saksbehandleren ved Universitetet i Oslo | saken til "Kari Nordmann"                    |
        | saksbehandleren ved Universitetet i Oslo | sakene til "Kari Nordmann" og "Ola Nordmann" |
        | opptaksforvalteren ved HK-dir            | saken til "Kari Nordmann"                    |
        | opptaksforvalteren ved HK-dir            | sakene til "Kari Nordmann" og "Ola Nordmann" |

    @depends-on-OPT-BEH-BEH-011
    # OPT-BEH-BEH-011: «Saksbehandlende organisasjon ser bare saker hos organisasjonen»
    Scenario: Saksbehandleren starter bare behandlingen for saker hos organisasjonen
      Gitt at søknaden til "Kari Nordmann" har en sak hos "Universitetet i Bergen"
      Når saksbehandleren ved Universitetet i Oslo vil starte den automatiske behandlingen
      Så kan saksbehandleren ikke starte behandlingen for saken hos "Universitetet i Bergen"

  @depends-on-OPT-BEH-BEH-025
  # OPT-BEH-BEH-025: «Den automatiske behandlingen setter saken til ferdig behandlet når alt er avgjort»
  Regel: Det fremgår at saken er behandlet automatisk

    Scenario: Saken som er ferdig behandlet automatisk, viser at den er behandlet automatisk
      Gitt at søknaden til "Kari Nordmann" har en sak hos "Universitetet i Oslo"
      Og at "Kari Nordmann" har ett vitnemål med påstanden at søkeren har GSK
      Når søknaden behandles automatisk
      Så er saken hos "Universitetet i Oslo" ferdig behandlet
      Og saksbehandleren ved Universitetet i Oslo ser at saken er behandlet automatisk

  Regel: Automatikken kjører så lenge det kan opprettes saker i opptaket

    Scenario: Saken behandles automatisk etter søknadsfristen
      Gitt at søknadsfristen i "Samordna opptak 2027" er passert
      Og at "Kari Nordmann" har et vitnemål i KREG
      Når saksbehandleren registrerer søknaden på vegne av "Kari Nordmann"
      Så behandles saken hos "Universitetet i Oslo" automatisk når vitnemålet er importert

  @openquestion
  Regel: Opptaksforvalteren ser at behandlingen kjører og om den har feilet
    # ÅPNE SPØRSMÅL:
    # - Hva skjer med saken når kjøringen feiler av andre grunner enn en feil i regelverket, f.eks.
    #   at KREG ikke svarer? Ingen jobb tar sakene som ikke ble behandlet. Det er ikke nok at
    #   feilen står i loggene: det må komme fram at jobbene kjører, og om de har feilet. Hvem ser
    #   det, og hvor?

    Scenario: Opptaksforvalteren ser at behandlingen har feilet
      Gitt at den automatiske behandlingen feilet for saken til "Kari Nordmann" fordi KREG ikke svarte
      Når opptaksforvalteren ved HK-dir ser på den automatiske behandlingen i opptaket
      Så ser opptaksforvalteren at behandlingen har feilet for saken til "Kari Nordmann"
