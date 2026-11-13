# language: no
# BEGREPER (2026-11-10): Bytt «opptaksforvalter ved forvaltende organisasjon» med «opptaksforvalter hos forvalteren», «saksbehandlende organisasjon» med «behandler» når fila likevel endres. Se krav/02 Opptak/begreper.md.
@OPT-BEH-BEH-032 @must @in-progress @scope-automatisk-import-og-start @ref-OPT-BEH-BEH-025 @ref-OPT-BEH-BEH-033 @ref-OPT-BEH-BEH-035
Egenskap: Starte automatisk behandling
  Som saksbehandler
  ønsker jeg at den automatiske behandlingen starter av seg selv for hver ny sak
  slik at sakene som kan behandles helautomatisk, blir ferdig behandlet uten at jeg gjør noe.

  Den automatiske behandlingen er en fortsettelse av saksbehandlertildelingen. Hver ny sak
  behandles automatisk når søkerens resultater er importert fra KREG. Har søkeren ikke noe
  vitnemål når saken opprettes, starter behandlingen når importen av VGS-vitnemål fra KREG har hentet
  alle vitnemålene søkeren har fått i KREG. Et nytt vitnemål etter at saken er behandlet, gir
  saken nye resultater (OPT-BEH-BEH-035): behandlingen starter ikke av seg selv, og
  saksbehandleren finner saken blant sakene med nye resultater. Saksbehandleren kan starte den automatiske behandlingen for en sak, også på
  vitnemålet saksbehandleren velger når søkeren har flere vitnemål (OPT-BEH-BEH-039). Det saksbehandleren har gjort i saken, endres aldri av automatikken. Opptaksforvalteren
  kan sette når den automatiske saksbehandlingen starter og avsluttes i opptaket.
  Hva behandlingen gjør med saken, står i kravene flyten FLY-OPT-AUT-001 bygger på.

  # Avklart med domeneeksperten 29.10.2026.
  # Kode i dag: saksbehandleren kan starte behandlingen for én sak med knappen «Start automatisk
  # behandling» i FS Admin, uten å velge vitnemål. Ingenting starter behandlingen når saken er
  # opprettet, og ingen jobb sjekker om det har kommet nye vitnemål. Opptaket har ingen hendelser for
  # når den automatiske saksbehandlingen starter og avsluttes.
  # Hvor ofte jobbene kjører, står i OPT-BEH-BEH-033.
  # Saksbehandleren velger vitnemålet når søkeren har flere vitnemål, i
  # OPT-BEH-BEH-039.

  @depends-on-OPT-BEH-BEH-011 @depends-on-OPT-BEH-BEH-030 @ref-FLY-OPT-AUT-001 @implemented
  # OPT-BEH-BEH-011: «Søknadsalternativene fordeles når søknaden sendes inn eller endres, og fordelingen ligger fast»
  # OPT-BEH-BEH-030: «Resultatene hentes når saken er opprettet»
  Regel: Behandlingen kjører for hver ny sak saksbehandlertildelingen oppretter

    Scenario: Den nye saken behandles automatisk når saksbehandlertildelingen har opprettet den
      Gitt at den automatiske saksbehandlingen pågår i opptaket
      Og at søkeren har sendt inn søknaden
      Og at søkeren har et vitnemål i KREG
      Når saksbehandlertildelingen har opprettet saken
      Så behandles saken automatisk når resultatene er importert

  @depends-on-OPT-BEH-BEH-030 @ref-FLY-OPT-VIT-001 @ref-FLY-OPT-AUT-001 @ref-OPT-BEH-BEH-025 @implemented
  # OPT-BEH-BEH-030: «Nye og annullerte vitnemål i KREG importeres for aktive søkere»
  Regel: Behandlingen kjører når importen har hentet vitnemålene til en søker uten vitnemål
    # Avklart 05.11.2026 (Geir, #951): behandlingen starter når importen har hentet alle
    # vitnemålene søkeren har i KREG, ikke ved det første vitnemålet. Den bruker vitnemålene
    # som finnes i KREG når importen kjører. Har søkeren to eller flere vitnemål, uansett om de
    # gir GSK, behandles saken ikke helautomatisk (OPT-BEH-BEH-025). Et vitnemål som kommer
    # etter at saken er behandlet, gir saken nye resultater (OPT-BEH-BEH-035).
    # Avklart 10.11.2026 (Sondre): med to eller flere vitnemål settes bare GSK-konklusjonen
    # (OPT-BEH-BEH-015), og resten av den automatiske behandlingen starter ikke (OPT-BEH-BEH-025).

    Scenario: Saken behandles automatisk når importen har hentet søkerens vitnemål
      Gitt at den automatiske saksbehandlingen pågår i opptaket
      Og at søkeren har levert søknaden uten å ha et vitnemål i KREG
      Og at søkeren har fått et vitnemål i KREG
      Når importen av VGS-vitnemål fra KREG kjører
      Så behandles saken automatisk når vitnemålet er importert

  @implemented
  Regel: Behandlingen starter av seg selv bare for saker som ikke er behandlet
    # Avklart 2026-11-02: har saksbehandleren begynt på saken, eller er saken ferdig behandlet,
    # starter ikke behandlingen av seg selv. Saksbehandleren kan starte den (se «Saksbehandleren
    # starter den automatiske behandlingen for en sak»).

    Scenariomal: Saken med behandlingsstatusen <status> behandles ikke automatisk når importen henter søkerens vitnemål
      Gitt at den automatiske saksbehandlingen pågår i opptaket
      Og at saken har behandlingsstatusen "<status>"
      Og at søkeren har fått et vitnemål i KREG
      Når importen av VGS-vitnemål fra KREG kjører
      Så behandles ikke saken automatisk

      Eksempler:
        | status           |
        | Under behandling |
        | Behandlet        |

  @depends-on-OPT-BEH-BEH-030 @ref-OPT-BEH-BEH-021 @ref-OPT-BEH-BEH-029 @ref-OPT-BEH-BEH-035
  # OPT-BEH-BEH-030: «Nye og annullerte vitnemål i KREG importeres for aktive søkere»
  # OPT-BEH-BEH-035: «Saken har nye resultater når resultater importeres etter at saken er behandlet»
  Regel: Et nytt vitnemål etter at saken er behandlet, gir saken nye resultater
    # Avklart 06.11.2026 (økt med fagfolk): saken får nye resultater (OPT-BEH-BEH-035), ikke en egen
    # markering. «Ny dokumentasjon» i sakslisten gjelder dokumentene søkeren laster opp
    # (OPT-BEH-BEH-008). Taggen «Vitnemål
    # annullert» (OPT-BEH-BEH-034) og varselet om at grunnlaget saksbehandleren har valgt, er
    # utdatert (OPT-BEH-BEH-021), kommer i tillegg, fordi de sier noe mer.

    @implemented
    Scenario: Saken behandles ikke automatisk på nytt når det kommer et nytt vitnemål
      Gitt at den automatiske saksbehandlingen pågår i opptaket
      Og at saken er behandlet automatisk på søkerens vitnemål
      Og at søkeren har fått et nytt vitnemål i KREG
      Når importen av VGS-vitnemål fra KREG kjører
      Så behandles ikke saken automatisk på nytt

  @implemented
  Regel: Saksbehandleren starter den automatiske behandlingen for en sak
    # Avklart 29.10.2026: det trengs ingen mulighet til å velge flere saker i sakslisten og
    # starte behandlingen for dem. Behandlingen starter av seg selv.
    # Å starte behandlingen på vitnemålet saksbehandleren velger når søkeren har flere vitnemål,
    # står i OPT-BEH-BEH-039 (skilt ut 04.11.2026).

    # Avklart 2026-11-02: den automatiske behandlingen starter ikke på en sak som er ferdig
    # behandlet.

    @depends-on-OPT-BEH-BEH-011
    # OPT-BEH-BEH-011: «Saksbehandlende organisasjon ser bare saker hos organisasjonen»
    Scenario: Saksbehandleren starter bare behandlingen for saker hos organisasjonen
      Gitt at søknaden har en sak hos en organisasjon saksbehandleren ikke er ved
      Når saksbehandleren vil starte den automatiske behandlingen
      Så kan saksbehandleren ikke starte behandlingen for saken

  @ref-OPT-BEH-BEH-019 @ref-OPT-BEH-BEH-020 @ref-OPT-BEH-BEH-018 @implemented
  Regel: Det saksbehandleren har gjort, endres ikke av automatikken
    # Reglene for hvert steg står i kravene til grunnlaget, poengene og kravelementene.

    Scenario: Grunnlaget saksbehandleren har valgt, står når behandlingen startes
      Gitt at saken har behandlingsstatusen "Under behandling"
      Og at saksbehandleren har valgt grunnlaget for saken
      Når saksbehandleren starter den automatiske behandlingen på søkerens vitnemål
      Så har saken fortsatt grunnlaget saksbehandleren valgte

  @depends-on-OPT-BEH-BEH-025 @implemented
  # OPT-BEH-BEH-025: «Den automatiske behandlingen setter saken til ferdig behandlet når alt er avgjort»
  Regel: Det fremgår at saken er behandlet automatisk

    Scenario: Saken som er ferdig behandlet automatisk, viser at den er behandlet automatisk
      Gitt at søknaden har en sak
      Og at søkeren har ett vitnemål, og vitnemålet gir GSK
      Når søknaden behandles automatisk
      Så er saken ferdig behandlet
      Og saksbehandleren ser at saken er behandlet automatisk

  @draft @depends-on-OPT-OVO-FRI-001
  # OPT-OVO-FRI-001: «Opptaksforvalter kan sette når den automatiske saksbehandlingen starter og avsluttes»
  Regel: Saken behandles automatisk bare mens den automatiske saksbehandlingen pågår i opptaket
    # Avklart 2026-11-03: hendelsene «Automatisk saksbehandling starter» og «Automatisk saksbehandling
    # avsluttes» settes på opptaket, og er valgfrie. Hendelsene er de samme som i OPT-BEH-BEH-015.
    # Avklart 2026-11-05: den automatiske saksbehandlingen pågår bare mens opptaket er publisert.
    # Hendelsene avgrenser perioden. Er de ikke satt, pågår den så lenge opptaket er publisert. Et
    # upublisert eller historisk opptak behandles ikke automatisk.
    # Avklart 2026-11-05: publiseres opptaket igjen etter at det er avpublisert, behandles sakene som
    # skulle vært behandlet automatisk mens opptaket var upublisert, når den automatiske
    # saksbehandlingen pågår etter hendelsene (eller hendelsene ikke er satt).
    # Erstatter at opptaksforvalteren skrur automatikken av og på. Gjelder for ett opptak, ikke for
    # hele systemet.
    # Avklart 2026-11-03: hendelsene gjelder ikke importen av vitnemål. Importen kjører uansett
    # (OPT-BEH-BEH-030, OPT-BEH-BEH-033).
    # Avklart 2026-11-03: hendelsene gjelder bare når behandlingen starter av seg selv. Saksbehandleren
    # kan starte behandlingen, med knappen eller ved å velge vitnemålet som skal brukes, også utenfor
    # perioden.

    Scenario: Saken behandles ikke automatisk før den automatiske saksbehandlingen starter
      Gitt at «Automatisk saksbehandling starter» er "2027-04-16 08:00" i opptaket
      Og at klokken er 2027-04-15 kl. 10:00
      Og at søkeren har et vitnemål i KREG
      Når saksbehandlertildelingen har opprettet saken
      Så behandles ikke saken automatisk

    Scenario: Saken behandles ikke automatisk etter at den automatiske saksbehandlingen er avsluttet
      Gitt at «Automatisk saksbehandling avsluttes» er "2027-07-15 12:00" i opptaket
      Og at klokken er 2027-07-15 kl. 12:01
      Når saksbehandlertildelingen har opprettet saken
      Så behandles ikke saken automatisk

    Scenario: Den automatiske saksbehandlingen pågår mens opptaket er publisert når hendelsene ikke er satt
      Gitt at opptaket ikke har hendelsene for den automatiske saksbehandlingen
      Og at opptaket er publisert
      Og at søkeren har et vitnemål i KREG
      Når saksbehandlertildelingen har opprettet saken
      Så behandles saken automatisk når vitnemålet er importert

    Scenario: Saken behandles ikke automatisk når opptaket er upublisert
      Gitt at opptaket ikke har hendelsene for den automatiske saksbehandlingen
      Og at opptaket er upublisert
      Og at søkeren har et vitnemål i KREG
      Når saksbehandlertildelingen har opprettet saken
      Så behandles ikke saken automatisk

    Scenario: Saken behandles ikke automatisk når opptaket er historisk
      Gitt at opptaket ikke har hendelsene for den automatiske saksbehandlingen
      Og at opptaket er historisk
      Og at søkeren har et vitnemål i KREG
      Når saksbehandlertildelingen har opprettet saken
      Så behandles ikke saken automatisk

    Scenario: Saken behandles automatisk når opptaket publiseres igjen
      Gitt at opptaket ikke har hendelsene for den automatiske saksbehandlingen
      Og at opptaket er avpublisert
      Og at saksbehandlertildelingen har opprettet saken mens opptaket var upublisert
      Og at søkeren har et vitnemål i KREG
      Når opptaksforvalter ved forvaltende organisasjon publiserer opptaket
      Så behandles saken automatisk

    Scenario: Saken behandles ikke automatisk når opptaket publiseres igjen etter at den automatiske saksbehandlingen er avsluttet
      Gitt at «Automatisk saksbehandling avsluttes» er "2027-07-15 12:00" i opptaket
      Og at opptaket er avpublisert
      Og at saksbehandlertildelingen har opprettet saken mens opptaket var upublisert
      Og at klokken er 2027-07-15 kl. 12:01
      Når opptaksforvalter ved forvaltende organisasjon publiserer opptaket
      Så behandles ikke saken automatisk

    Scenario: Hendelsene i ett opptak påvirker ikke andre opptak
      Gitt at «Automatisk saksbehandling avsluttes» er "2027-07-15 12:00" i opptaket
      Og at et annet opptak ikke har hendelsene for den automatiske saksbehandlingen
      Og at det andre opptaket er publisert
      Og at klokken er 2027-07-15 kl. 12:01
      Når saksbehandlertildelingen har opprettet en sak i det andre opptaket
      Så behandles saken automatisk

    Scenario: Saksbehandleren starter den automatiske behandlingen etter at den automatiske saksbehandlingen er avsluttet
      Gitt at «Automatisk saksbehandling avsluttes» er "2027-07-15 12:00" i opptaket
      Og at klokken er 2027-07-15 kl. 12:01
      Og at saken er under behandling
      Når saksbehandleren starter den automatiske behandlingen
      Så behandles saken automatisk
