# language: no
@OPT-BEH-BEH-032 @must @in-progress @scope-automatisk-import-og-start @ref-OPT-BEH-BEH-025 @ref-OPT-BEH-BEH-033
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
  kan sette når den automatiske saksbehandlingen starter og avsluttes i opptaket.
  Hva behandlingen gjør med saken, står i kravene flyten FLY-OPT-AUT-001 bygger på.

  # Avklart med domeneeksperten 29.10.2026.
  # Kode i dag: saksbehandleren kan starte behandlingen for én sak med knappen «Start automatisk
  # behandling» i FS Admin, uten å velge vitnemål. Ingenting starter behandlingen når saken er
  # opprettet, og ingen jobb sjekker om det har kommet nye vitnemål. Opptaket har ingen hendelser for
  # når den automatiske saksbehandlingen starter og avsluttes.
  # Hvor ofte jobbene kjører, står i OPT-BEH-BEH-033.
  # Saksbehandleren velger vitnemålet når søkeren har flere vitnemål, i
  # OPT-BEH-BEH-025.

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" forvaltes av HK-dir
    Og at "Universitetet i Oslo" deltar i opptaket
    Og at den automatiske saksbehandlingen pågår i "Samordna opptak 2027"

  @depends-on-OPT-BEH-BEH-011 @depends-on-OPT-BEH-BEH-030 @ref-FLY-OPT-AUT-001
  # OPT-BEH-BEH-011: «Søknadsalternativene fordeles når søknaden sendes inn eller endres, og fordelingen ligger fast»
  # OPT-BEH-BEH-030: «Resultatene hentes når saken er opprettet»
  Regel: Behandlingen kjører for hver ny sak saksbehandlertildelingen oppretter

    Scenario: Den nye saken behandles automatisk når saksbehandlertildelingen har opprettet den
      Gitt at "Kari Nordmann" har sendt inn søknaden
      Og at "Kari Nordmann" har et vitnemål i KREG
      Når saksbehandlertildelingen har opprettet saken hos "Universitetet i Oslo"
      Så behandles saken hos "Universitetet i Oslo" automatisk når vitnemålet er importert

  @depends-on-OPT-BEH-BEH-030 @ref-FLY-OPT-VIT-001 @ref-FLY-OPT-AUT-001
  # OPT-BEH-BEH-030: «Nye og annullerte vitnemål i KREG importeres for aktive søkere»
  Regel: Behandlingen kjører når søkeren får det første vitnemålet

    Scenario: Saken behandles automatisk når jobben finner søkerens første vitnemål
      Gitt at "Kari Nordmann" har levert søknaden uten å ha et vitnemål i KREG
      Og at "Kari Nordmann" har fått et vitnemål i KREG
      Når jobben for nye vitnemål i KREG kjører
      Så behandles saken hos "Universitetet i Oslo" automatisk når vitnemålet er importert

  Regel: Behandlingen starter av seg selv bare for saker som ikke er behandlet
    # Avklart 2026-11-02: har saksbehandleren begynt på saken, eller er saken ferdig behandlet,
    # starter ikke behandlingen av seg selv. Saksbehandleren kan starte den (se «Saksbehandleren
    # starter den automatiske behandlingen på vitnemålet som er valgt»).

    Scenariomal: Saken med behandlingsstatusen <status> behandles ikke automatisk når søkeren får det første vitnemålet
      Gitt at saken hos "Universitetet i Oslo" har behandlingsstatusen "<status>"
      Og at "Kari Nordmann" har fått det første vitnemålet i KREG
      Når jobben for nye vitnemål i KREG kjører
      Så behandles ikke saken hos "Universitetet i Oslo" automatisk

      Eksempler:
        | status           |
        | Under behandling |
        | Behandlet        |

  @openquestion @depends-on-OPT-BEH-BEH-030 @ref-OPT-BEH-BEH-021 @ref-OPT-BEH-BEH-029
  # OPT-BEH-BEH-030: «Nye og annullerte vitnemål i KREG importeres for aktive søkere»
  Regel: Et nytt vitnemål i en sak med vitnemål er ny dokumentasjon
    # ÅPNE SPØRSMÅL:
    # - Er «ny dokumentasjon» i sakslisten en behandlingsstatus (OPT-BEH-BEH-029), eller en egen
    #   markering ved siden av? OPT-BEH-BEH-029 sier at ny dokumentasjon ikke endrer
    #   behandlingsstatusen.
    # - Er «ny dokumentasjon» den samme markeringen som «nye resultater» i OPT-BEH-BEH-035 og
    #   taggen «Vitnemål annullert» i OPT-BEH-BEH-034? Alle tre merker saken når
    #   søkeren får et nytt eller annullert vitnemål.
    # - Er varselet om nytt vitnemål det samme som i OPT-BEH-BEH-021?

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
  # OPT-BEH-BEH-025: «Har søkeren flere vitnemål, behandles saken automatisk på vitnemålet saksbehandleren velger»
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

    # Avklart 2026-11-02: den automatiske behandlingen starter ikke på en sak som er ferdig
    # behandlet.

    @depends-on-OPT-BEH-BEH-011 @implemented
    # OPT-BEH-BEH-011: «Saksbehandlende organisasjon ser bare saker hos organisasjonen»
    Scenario: Saksbehandleren starter bare behandlingen for saker hos organisasjonen
      Gitt at søknaden til "Kari Nordmann" har en sak hos "Universitetet i Bergen"
      Når saksbehandleren ved Universitetet i Oslo vil starte den automatiske behandlingen
      Så kan saksbehandleren ikke starte behandlingen for saken hos "Universitetet i Bergen"

  @ref-OPT-BEH-BEH-019 @ref-OPT-BEH-BEH-020 @ref-OPT-BEH-BEH-018 @implemented
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
      Og at "Kari Nordmann" har ett vitnemål, og vitnemålet gir GSK
      Når søknaden behandles automatisk
      Så er saken hos "Universitetet i Oslo" ferdig behandlet
      Og saksbehandleren ved Universitetet i Oslo ser at saken er behandlet automatisk

  @draft @depends-on-OPT-OVO-FRI-001
  # OPT-OVO-FRI-001: «Opptaksforvalter kan sette når den automatiske saksbehandlingen starter og avsluttes»
  Regel: Saken behandles automatisk bare mens den automatiske saksbehandlingen pågår i opptaket
    # Avklart 2026-11-03: hendelsene «Automatisk saksbehandling starter» og «Automatisk saksbehandling
    # avsluttes» settes på opptaket, og er valgfrie. Er de ikke satt, pågår den automatiske
    # saksbehandlingen til opptaket er historisk. Hendelsene er de samme som i OPT-BEH-BEH-015.
    # Erstatter at opptaksforvalteren skrur automatikken av og på. Gjelder for ett opptak, ikke for
    # hele systemet.
    # Avklart 2026-11-03: hendelsene gjelder ikke importen av vitnemål. Importen kjører uansett
    # (OPT-BEH-BEH-030, OPT-BEH-BEH-033).
    # Avklart 2026-11-03: hendelsene gjelder bare når behandlingen starter av seg selv. Saksbehandleren
    # kan starte behandlingen, med knappen eller ved å velge vitnemålet som skal brukes, også utenfor
    # perioden.

    Scenario: Saken behandles ikke automatisk før den automatiske saksbehandlingen starter
      Gitt at «Automatisk saksbehandling starter» er "2027-04-16 08:00" i "Samordna opptak 2027"
      Og at klokken er 2027-04-15 kl. 10:00
      Og at "Kari Nordmann" har et vitnemål i KREG
      Når saksbehandlertildelingen har opprettet saken hos "Universitetet i Oslo"
      Så behandles ikke saken hos "Universitetet i Oslo" automatisk

    Scenario: Saken behandles ikke automatisk etter at den automatiske saksbehandlingen er avsluttet
      Gitt at «Automatisk saksbehandling avsluttes» er "2027-07-15 12:00" i "Samordna opptak 2027"
      Og at klokken er 2027-07-15 kl. 12:01
      Når saksbehandlertildelingen har opprettet saken hos "Universitetet i Oslo"
      Så behandles ikke saken hos "Universitetet i Oslo" automatisk

    Scenario: Den automatiske saksbehandlingen pågår til opptaket er historisk når hendelsene ikke er satt
      Gitt at "Samordna opptak 2027" ikke har hendelsene for den automatiske saksbehandlingen
      Og at "Samordna opptak 2027" ikke er historisk
      Og at "Kari Nordmann" har et vitnemål i KREG
      Når saksbehandlertildelingen har opprettet saken hos "Universitetet i Oslo"
      Så behandles saken hos "Universitetet i Oslo" automatisk når vitnemålet er importert

    Scenario: Hendelsene i ett opptak påvirker ikke andre opptak
      Gitt at «Automatisk saksbehandling avsluttes» er "2027-07-15 12:00" i "Samordna opptak 2027"
      Og at "Lokalt opptak UiO 2027" ikke har hendelsene for den automatiske saksbehandlingen
      Og at klokken er 2027-07-15 kl. 12:01
      Når saksbehandlertildelingen har opprettet en sak i "Lokalt opptak UiO 2027"
      Så behandles saken automatisk

    Scenario: Saksbehandleren starter den automatiske behandlingen etter at den automatiske saksbehandlingen er avsluttet
      Gitt at «Automatisk saksbehandling avsluttes» er "2027-07-15 12:00" i "Samordna opptak 2027"
      Og at klokken er 2027-07-15 kl. 12:01
      Og at saken hos "Universitetet i Oslo" er under behandling
      Når saksbehandleren ved Universitetet i Oslo starter den automatiske behandlingen
      Så behandles saken hos "Universitetet i Oslo" automatisk

  @ref-OPT-BEH-BEH-030
  Regel: Saken viser hvorfor den ikke kunne behandles automatisk
    # Den automatiske behandlingen henter ikke vitnemål fra KREG, men bruker vitnemålene som er
    # importert. Når KREG ikke svarer, prøves importen på nytt (OPT-BEH-BEH-030).

    Scenario: Saken viser at den ikke kunne behandles automatisk fordi søkeren ikke har vitnemål
      Gitt at "Kari Nordmann" ikke har noe vitnemål i KREG
      Når saksbehandlertildelingen har opprettet saken hos "Universitetet i Oslo"
      Så ser saksbehandleren ved Universitetet i Oslo på saken at den ikke kunne behandles automatisk fordi søkeren ikke har vitnemål
