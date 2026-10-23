# language: no
# Jira: STEK-253
@OPT-BEH-BEH-017 @must @draft
Egenskap: Behandlingsstatus
  Som saksbehandler ved saksbehandlende organisasjon
  ønsker jeg at hver sak har en behandlingsstatus
  slik at bare søkere i ferdig behandlede saker er med i tilbudskjøringen, og arbeidet kan følges opp.

  Behandlingsstatusen viser hvor langt saksbehandlingen har kommet. En sak har én av tre
  statuser: «Ikke behandlet», «Under behandling» eller «Behandlet».

  Statusen avgjør hvilke søkere som er med i tilbudskjøringen. Bare saker som er «Behandlet»,
  er med. Statusen viser også saksbehandlerne hvilke saker ingen har begynt på, hvilke som er
  i arbeid, og hvilke som er ferdige, så arbeidet kan fordeles og følges opp.

  Behandlingsstatusen erstatter dokumentasjonsstatusen i dagens løsning. Mangelkodene som lå
  i dokumentasjonsstatusen, er mangler i saken (se @OPT-BEH-BEH-008).

  # ÅPNE SPØRSMÅL:
  # - Skal saksbehandleren kunne finne saker på mangelkode, slik som med dokumentasjonsstatusen
  #   i dag? Hører det i så fall hjemme her eller i søknadsmangler?

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" forvaltes av HK-dir
    Og at "Universitetet i Oslo" deltar i opptaket
    Og at søkeren har en sak hos "Universitetet i Oslo"

  Regel: En ny sak er Ikke behandlet

    Scenario: Ny sak er Ikke behandlet
      Når søknaden blir til en sak hos "Universitetet i Oslo"
      Så har saken behandlingsstatusen "Ikke behandlet"

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

  Regel: Saken kan bare bli Behandlet når den har minst én mangel eller ett grunnlag

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

  Regel: Mangler som ikke er publisert, publiseres når saken settes til Behandlet

    Scenario: Saksbehandleren blir advart om at manglene blir publisert
      Gitt at saken har mangelen "KNN" som ikke er publisert
      Når saksbehandleren ved Universitetet i Oslo setter saken til "Behandlet"
      Så ser saksbehandleren at mangelen "KNN" blir publisert hvis saken settes til "Behandlet"
      Og avbryt er valgt som standard

    Scenario: Manglene publiseres når saksbehandleren fortsetter
      Gitt at saksbehandleren ved Universitetet i Oslo er advart om at mangelen "KNN" blir publisert
      Når saksbehandleren fortsetter
      Så har saken behandlingsstatusen "Behandlet"
      Og søkeren ser mangelen "KNN" i Min kompetanse
      Og søkeren har mottatt en melding av typen MANGEL

    Scenario: Avbryte for å endre manglene før de publiseres
      Gitt at saken har behandlingsstatusen "Under behandling"
      Og at saksbehandleren ved Universitetet i Oslo er advart om at mangelen "KNN" blir publisert
      Når saksbehandleren avbryter
      Så har saken fortsatt behandlingsstatusen "Under behandling"
      Og mangelen "KNN" er ikke publisert
      Og saksbehandleren kan endre eller slette mangelen "KNN"

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

    Scenariomal: Behandlingsstatusen endres ikke når saksbehandleren <handling>
      Gitt at saken har behandlingsstatusen "Behandlet"
      Når saksbehandleren ved Universitetet i Oslo <handling>
      Så har saken fortsatt behandlingsstatusen "Behandlet"

      Eksempler:
        | handling                                   |
        | skriver en merknad                         |
        | tilordner saken til en annen saksbehandler |

    Scenario: Ny dokumentasjon endrer ikke behandlingsstatusen
      Gitt at saken har behandlingsstatusen "Behandlet"
      Når det kommer ny dokumentasjon i saken
      Så har saken fortsatt behandlingsstatusen "Behandlet"

  @openquestion
  Regel: Den automatiske behandlingen setter saken til Behandlet
    # ÅPNE SPØRSMÅL:
    # - Mangelen for generell studiekompetanse som fullføres i vår settes automatisk når søkeren
    #   sender søknaden (@OPT-BEH-BEH-008). Skal den alene gjøre saken «Behandlet»? I så fall er
    #   saken ferdig før noen saksbehandler har sett på den.

    Scenariomal: Saken blir Behandlet når den automatiske behandlingen gir <innhold>
      Gitt at saken har behandlingsstatusen "Ikke behandlet"
      Når den automatiske behandlingen gir saken <innhold>
      Så har saken behandlingsstatusen "Behandlet"

      Eksempler:
        | innhold     |
        | et grunnlag |
        | en mangel   |

    Scenario: Saken blir Behandlet selv om ikke alle søknadsalternativene er vurdert automatisk
      Gitt at saken har behandlingsstatusen "Ikke behandlet"
      Og at saken har søknadsalternativene "Informatikk, UiO" og "Historie, UiO"
      Når den automatiske behandlingen gir grunnlag for "Informatikk, UiO", men ikke for "Historie, UiO"
      Så har saken behandlingsstatusen "Behandlet"

    Scenariomal: Den automatiske behandlingen endrer ikke behandlingsstatusen når saken er <status>
      Gitt at saken har behandlingsstatusen "<status>"
      Når den automatiske behandlingen gir saken et grunnlag
      Så har saken fortsatt behandlingsstatusen "<status>"

      Eksempler:
        | status           |
        | Under behandling |
        | Behandlet        |

  Regel: Bare saker som er Behandlet, er med i tilbudskjøringen

    Scenariomal: Sak som er <status>, i tilbudskjøringen
      Gitt at saken har behandlingsstatusen "<status>"
      Når tilbudskjøringen kjøres
      Så <resultat> i tilbudskjøringen for søknadsalternativene i saken

      Eksempler:
        | status           | resultat            |
        | Behandlet        | deltar søkeren      |
        | Under behandling | deltar ikke søkeren |
        | Ikke behandlet   | deltar ikke søkeren |

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
        | den automatiske behandlingen gir saken et grunnlag                           | Behandlet        | den automatiske behandlingen var ferdig |
