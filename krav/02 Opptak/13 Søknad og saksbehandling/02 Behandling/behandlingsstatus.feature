# language: no
# Jira: STEK-253
@OPT-BEH-BEH-029 @must @in-progress @scope-automatisk-ferdigbehandling @ref-OPT-BEH-BEH-008 @ref-OPT-BEH-BEH-025 @ref-OPT-PLA-TIL-001
Egenskap: Behandlingsstatus
  Som saksbehandler ved saksbehandlende organisasjon
  ønsker jeg at hver sak har en behandlingsstatus
  slik at arbeidet med sakene kan fordeles og følges opp, og bare ferdig behandlede saker er med i plasstildelingen.

  Behandlingsstatusen viser hvor langt saksbehandlingen har kommet. En sak har én av tre
  statuser:
  - «Ikke behandlet»: ingen har sett på eller gjort noe med saken ennå.
  - «Under behandling»: noen har sett på eller gjort noe med saken.
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
    Gitt at opptaket "Samordna opptak 2027" forvaltes av HK-dir
    Og at "Universitetet i Oslo" deltar i opptaket
    Og at søkeren har en sak hos "Universitetet i Oslo"

  @implemented
  Regel: En ny sak er Ikke behandlet

    Scenario: Ny sak er Ikke behandlet
      Når søknaden blir til en sak hos "Universitetet i Oslo"
      Så har saken behandlingsstatusen "Ikke behandlet"

  @ref-OPT-BEH-BEH-032 @implemented
  Regel: Saksbehandleren kan sette behandlingsstatusen

    Scenariomal: Endre behandlingsstatus fra <fra> til <til>
      Gitt at saken har behandlingsstatusen "<fra>"
      Når saksbehandleren ved Universitetet i Oslo setter saken til "<til>"
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
      Når saksbehandleren ved Universitetet i Oslo setter saken til "Behandlet"
      Så har saken behandlingsstatusen "Behandlet"

      Eksempler:
        | fra              | innhold     |
        | Ikke behandlet   | en mangel   |
        | Under behandling | et grunnlag |

    Scenario: Saken kan ikke bli Behandlet uten mangel eller grunnlag
      Gitt at saken har behandlingsstatusen "Under behandling"
      Og at saken verken har mangler eller grunnlag
      Når saksbehandleren ved Universitetet i Oslo setter saken til "Behandlet"
      Så har saken fortsatt behandlingsstatusen "Under behandling"
      Og saksbehandleren ser at saken må ha minst én mangel eller ett grunnlag for å bli "Behandlet"

  @ref-OPT-BEH-BEH-032
  Regel: Saken blir Under behandling når saksbehandleren endrer vurderingen eller leser et dokument

    Scenariomal: Saken blir Under behandling når saksbehandleren <handling>
      Gitt at saken har behandlingsstatusen "<fra>"
      Når saksbehandleren ved Universitetet i Oslo <handling>
      Så har saken behandlingsstatusen "Under behandling"
      Og saksbehandleren ser at behandlingsstatusen er endret til "Under behandling"

      Eksempler:
        | fra            | handling                  |
        | Ikke behandlet | registrerer et grunnlag   |
        | Behandlet      | endrer kvalifiseringen    |
        | Behandlet      | endrer poengene           |
        | Behandlet      | endrer kvoteplasseringen  |
        | Ikke behandlet | registrerer en mangel     |
        | Ikke behandlet | leser et dokument i saken |
        | Behandlet      | leser et dokument i saken |

    @implemented
    Scenariomal: Behandlingsstatusen endres ikke når saksbehandleren <handling>
      Gitt at saken har behandlingsstatusen "Behandlet"
      Når saksbehandleren ved Universitetet i Oslo <handling>
      Så har saken fortsatt behandlingsstatusen "Behandlet"

      Eksempler:
        | handling                                   |
        | skriver en merknad                         |
        | tilordner saken til en annen saksbehandler |

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
        | hendelse                                                                     | til              | årsak                                   |
        | saksbehandleren ved Universitetet i Oslo setter saken til "Under behandling" | Under behandling | saksbehandleren endret statusen         |
        | saksbehandleren ved Universitetet i Oslo leser et dokument i saken           | Under behandling | saksbehandleren leste et dokument       |
        | den automatiske behandlingen setter saken til ferdig behandlet               | Behandlet        | den automatiske behandlingen var ferdig |
