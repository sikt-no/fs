# language: no
# BEGREPER (2026-11-10): Bytt «saksbehandlende organisasjon» med «behandler» når fila likevel endres. Se krav/02 Opptak/begreper.md.
# Jira: STEK-253
@OPT-BEH-BEH-029 @must @in-progress @scope-automatisk-ferdigbehandling @ref-OPT-BEH-BEH-008 @ref-OPT-PLA-TIL-001
Egenskap: Behandlingsstatus
  Som saksbehandler ved saksbehandlende organisasjon
  ønsker jeg at hver sak har en behandlingsstatus
  slik at arbeidet med sakene kan fordeles og følges opp, og bare ferdig behandlede saker er med i plasstildelingen.

  Behandlingsstatusen viser hvor langt saksbehandlingen har kommet. En sak har én av tre
  statuser:
  - «Ikke behandlet»: ingen saksbehandler har gjort noe med saken ennå. Den
    automatiske behandlingen endrer ikke statusen, bortsett fra å sette saken til ferdig
    behandlet.
  - «Under behandling»: noen har gjort noe med saken.
  - «Behandlet»: saksbehandleren har gjort det som kan gjøres i saken. Saken er enten
    ferdig, eller venter på ny informasjon fra søkeren.

  Behandlingsstatusen er ikke det samme som konklusjonen i saken. En sak kan være ferdig
  behandlet selv om søkeren ikke er kvalifisert, eller saken har mangler.

  Statusen viser saksbehandlerne hvilke saker ingen har begynt på, hvilke som er i arbeid, og
  hvilke som er ferdige. Bare saker som er ferdig behandlet, er med i plasstildelingen. Det står
  i kravet til plasstildelingen. Når den automatiske behandlingen setter saken til ferdig
  behandlet, står i kravet om å ferdigbehandle en sak.

  Behandlingsstatusen erstatter dokumentasjonsstatusen i dagens løsning. Mangelkodene som lå
  i dokumentasjonsstatusen, er mangler i saken. Varselet om mangler som ikke er publisert når
  saken settes til «Behandlet», står i kravet til søknadsmangler.

  # Å finne saker på mangelkode, slik som med dokumentasjonsstatusen i dag, står i
  # OPT-BEH-BEH-008 («Saksbehandleren finner sakene med en bestemt mangelkode»). Avklart 30.10.2026.

  Bakgrunn:
    Gitt at søkeren har en sak hos den saksbehandlende organisasjonen

  @implemented
  Regel: En ny sak er Ikke behandlet

    Scenario: Ny sak er Ikke behandlet
      Når søknaden blir til en sak hos den saksbehandlende organisasjonen
      Så har saken behandlingsstatusen "Ikke behandlet"

  @ref-OPT-BEH-BEH-032 @implemented
  Regel: Saksbehandleren kan sette behandlingsstatusen

    Scenariomal: Endre behandlingsstatus fra <fra> til <til>
      Gitt at saken har behandlingsstatusen "<fra>"
      Når saksbehandleren setter saken til "<til>"
      Så har saken behandlingsstatusen "<til>"

      Eksempler:
        | fra              | til              |
        | Ikke behandlet   | Under behandling |
        | Under behandling | Ikke behandlet   |
        | Behandlet        | Under behandling |
        | Behandlet        | Ikke behandlet   |

  @ref-FLY-OPT-AUT-001
  Regel: Saken kan bare bli Behandlet når den har minst én mangel eller ett grunnlag

    @implemented
    Scenariomal: Sette saken til Behandlet fra <fra> når saken har <innhold>
      Gitt at saken har behandlingsstatusen "<fra>"
      Og at saken har <innhold>
      Når saksbehandleren setter saken til "Behandlet"
      Så har saken behandlingsstatusen "Behandlet"

      Eksempler:
        | fra              | innhold     |
        | Ikke behandlet   | en mangel   |
        | Under behandling | et grunnlag |

    Scenario: Saken kan ikke bli Behandlet uten mangel eller grunnlag
      Gitt at saken har behandlingsstatusen "Under behandling"
      Og at saken verken har mangler eller grunnlag
      Når saksbehandleren setter saken til "Behandlet"
      Så har saken fortsatt behandlingsstatusen "Under behandling"
      Og saksbehandleren ser at saken må ha minst én mangel eller ett grunnlag for å bli "Behandlet"

  @ref-OPT-BEH-BEH-032 @ref-OPT-BEH-BEH-025
  Regel: Saken blir Under behandling når saksbehandleren endrer vurderingen
    # Avklart 2026-11-03: behandlingsstatusen endres ikke før saksbehandleren gjør en endring i
    # saken. Å se på saken eller et dokument er ikke en endring.
    # Avklart 09.11.2026: å markere et dokument som lest er heller ikke en endring. FS Admin
    # markerer dokumentet som lest når saksbehandleren åpner det. Kode i dag:
    # SettSaksdokumentErLestService endrer statusen fra Ikke behandlet til Under behandling.
    # Avklart 09.11.2026: saksbehandleren endrer kvoteplasseringen ved å svare på kvotespørsmålene.

    Scenariomal: Saken blir Under behandling når saksbehandleren <handling>
      Gitt at saken har behandlingsstatusen "<fra>"
      Når saksbehandleren <handling>
      Så har saken behandlingsstatusen "Under behandling"
      Og saksbehandleren ser at behandlingsstatusen er endret til "Under behandling"

      Eksempler:
        | fra            | handling                              |
        | Ikke behandlet | registrerer et grunnlag               |
        | Behandlet      | endrer kvalifiseringen                |
        | Behandlet      | endrer poengene                       |
        | Behandlet      | endrer svaret på et kvotespørsmål     |
        | Ikke behandlet | registrerer en mangel                 |

    @implemented
    Scenariomal: Behandlingsstatusen endres ikke når saksbehandleren <handling>
      Gitt at saken har behandlingsstatusen "Behandlet"
      Når saksbehandleren <handling>
      Så har saken fortsatt behandlingsstatusen "Behandlet"

      Eksempler:
        | handling                                   |
        | skriver en merknad                         |
        | tilordner saken til en annen saksbehandler |

    @implemented
    Scenario: Å markere et dokument som lest endrer ikke statusen på en sak som er Behandlet
      Gitt at saken har behandlingsstatusen "Behandlet"
      Når saksbehandleren markerer et dokument i saken som lest
      Så har saken fortsatt behandlingsstatusen "Behandlet"

    Scenario: Å markere et dokument som lest endrer ikke statusen på en sak som ikke er behandlet
      Gitt at saken har behandlingsstatusen "Ikke behandlet"
      Når saksbehandleren markerer et dokument i saken som lest
      Så har saken fortsatt behandlingsstatusen "Ikke behandlet"

    @implemented
    Scenariomal: Behandlingsstatusen <status> endres ikke når saksbehandleren åpner saken
      Gitt at saken har behandlingsstatusen "<status>"
      Når saksbehandleren åpner saken
      Så har saken fortsatt behandlingsstatusen "<status>"

      Eksempler:
        | status         |
        | Ikke behandlet |
        | Behandlet      |

    @implemented
    Scenario: Ny dokumentasjon endrer ikke behandlingsstatusen
      Gitt at saken har behandlingsstatusen "Behandlet"
      Når det kommer ny dokumentasjon i saken
      Så har saken fortsatt behandlingsstatusen "Behandlet"

  @ref-OPT-BEH-BEH-016 @ref-FLY-OPT-AUT-001
  Regel: Saksloggen viser endringene i behandlingsstatusen

    Scenariomal: Saksloggen viser endring av behandlingsstatus når <årsak>
      Gitt at saken har behandlingsstatusen "Ikke behandlet"
      Når <hendelse>
      Så viser saksloggen at behandlingsstatusen ble endret fra "Ikke behandlet" til "<til>"
      Og saksloggen viser når endringen skjedde, og at årsaken var at <årsak>

      Eksempler:
        | hendelse                                                       | til              | årsak                                         |
        | saksbehandleren setter saken til "Under behandling"            | Under behandling | saksbehandleren endret statusen               |
        | den automatiske behandlingen setter saken til ferdig behandlet | Behandlet        | den automatiske behandlingen var ferdig       |
