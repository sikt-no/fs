# language: no
# Skrevet 2026-11-13 fra saksoversikten i fs-admin (SakOverviewView) og avklaringene med produkteier samme dag.
# Skisse: «Liste over søknader» i Figma (node 16526-67036).
#
# Ikke med her:
# - Handlinger på flere saker samtidig (tagger og tilordne saksbehandler). Det blir et eget krav.
# - Uttrekk av sakslista til fil (@OPT-BEH-BEH-045).
@OPT-BEH-BEH-046 @must @draft
Egenskap: Listevisning og søk i saker
  Som saksbehandler, opptaksforvalter eller opptaksinformatør
  ønsker jeg en oversikt over sakene i opptaket jeg har tilgang til, med mulighet for søk og filtrering
  slik at jeg raskt kan finne og følge opp riktig sak.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen

  @ref-OPT-BEH-BEH-029
  Regel: Liste over alle saker
    # Behandlingsstatusene står i behandlingsstatus.feature.

    Scenario: Se liste over saker
      Når jeg åpner saksoversikten for opptaket
      Så ser jeg følgende felt for hver sak:
        | felt               |
        | Søknadsnummer      |
        | Levert tidspunkt   |
        | Utdanningsbakgrunn |
        | Status             |
        | Tagger             |
        | Saksbehandler      |

    Scenariomal: Statusen viser at saken <tilstand>
      Gitt saken <tilstand>
      Når jeg åpner saksoversikten for opptaket
      Så viser statusen for saken "<merke>"

      Eksempler:
        | tilstand                              | merke                |
        | ikke er behandlet                     | Ikke behandlet       |
        | er under behandling                   | Under behandling     |
        | er behandlet                          | Behandlet            |
        | har dokumentasjon som ikke er lest    | Ny dokumentasjon     |
        | er behandlet automatisk               | Behandlet automatisk |
        | hører til en søknad som er trukket    | Trukket              |

    Scenario: Sakene er sortert på søknadsnummer som standard
      Når jeg åpner saksoversikten for opptaket
      Så vises sakene sortert etter søknadsnummer i stigende rekkefølge

    @openquestion
    Scenariomal: Velge sorteringsretning for <felt>
      # ÅPNE SPØRSMÅL:
      # - En sak kan ha flere tagger. Hva betyr sortering på tagger: navnet på den første taggen, antall tagger, eller noe annet?
      # - Gjelder sorteringen alle sakene som treffer, ikke bare sakene som er lastet inn? I FS Admin sorteres i dag
      #   bare sakene som er lastet inn, og bare på levert tidspunkt.
      Gitt jeg ser listen over saker
      Når jeg velger å sortere på <felt> i <retning> rekkefølge
      Så vises sakene sortert etter <felt> i <retning> rekkefølge

      Eksempler:
        | felt               | retning  |
        | søknadsnummer      | stigende |
        | søknadsnummer      | synkende |
        | levert tidspunkt   | stigende |
        | levert tidspunkt   | synkende |
        | utdanningsbakgrunn | stigende |
        | utdanningsbakgrunn | synkende |
        | status             | stigende |
        | status             | synkende |
        | tagger             | stigende |
        | tagger             | synkende |
        | saksbehandler      | stigende |
        | saksbehandler      | synkende |

    Scenario: Liste viser de 50 første sakene
      Når jeg åpner saksoversikten for opptaket
      Så ser jeg totalt antall treff og antall som er lastet
      Og listen viser de 50 første sakene

    Scenario: Laste inn 50 flere saker
      Gitt jeg ser listen over saker
      Og flere enn 50 saker treffer
      Når jeg velger å laste inn flere
      Så lastes de neste 50 sakene inn i listen

    Scenario: Alle saker er lastet inn
      Gitt jeg ser listen over saker
      Og alle sakene som treffer, er lastet inn
      Så er muligheten til å laste inn flere ikke tilgjengelig

    Scenario: Navigere til detaljside for sak
      Gitt jeg ser listen over saker
      Når jeg velger en sak
      Så ser jeg detaljsiden for valgt sak

  @ref-OPT-BEH-BEH-009 @ref-OPT-BEH-BEH-035 @openquestion
  Regel: Søk og filtrering av saker
    # Filteret for tidlig opptak står i finne_søknader_om_tidlig_opptak.feature, og filteret for nye
    # resultater fra høyere utdanning i finne_saker_med_nye_resultater.feature.
    # Tekstene i rollefilteret er «Behandler (B-rolle)» og «Tilbyder (T-rolle)» (avklart 2026-11-13).
    # ÅPNE SPØRSMÅL:
    # - Hvordan kombineres filtrene? Det vanlige er ELLER mellom valgene i samme filter, og OG mellom filtrene
    #   og fritekstsøket. Det avgjøres i fs-plattform, og må sjekkes der.
    # - Hvilke filtre mangler i saksoversikten?
    # - Er hurtigfilteret riktig: «Mine søknader», ubehandlet opplastet dokumentasjon, ubehandlede resultater
    #   fra høyere utdanning og «Har søkt tidlig opptak»?
    # - Skal verdier uten treff skjules i filtrene, som i dag?
    # - Skal rollefilteret bare vises i samordna opptak, som i dag?

    Scenariomal: Fritekst-søk på <felt>
      Gitt jeg ser listen over saker
      Når jeg søker med fritekst på <felt>
      Så filtreres listen til saker som matcher søket

      Eksempler:
        | felt                 |
        | søknadsnummer        |
        | søkerens navn        |
        | søkerens fødselsnummer |
        | søkerens telefonnummer |
        | søkerens e-postadresse |

    Scenariomal: Tilgjengelige verdier i <filter>-filteret
      Gitt jeg ser listen over saker
      Når jeg åpner <filter>-filteret
      Så inneholder filteret <verdier>
      Og filteret viser hvor mange saker som treffer hver verdi
      Og ingen verdier er valgt som standard

      Eksempler:
        | filter             | verdier                                                                                                                                                                  |
        | behandlingsstatus  | Ikke behandlet, Under behandling og Behandlet                                                                                                                            |
        | dokumentasjon      | Ubehandlet opplastet dokumentasjon, Opplastet dokumentasjon, Har ikke opplastet dokumentasjon, Har elektronisk vitnemål, Har ikke elektronisk vitnemål, Har resultater og Har ikke resultater |
        | kvalifisering      | Kvalifiserte, Ikke kvalifiserte og Mangler ved søknad                                                                                                                    |
        | utdanningsbakgrunn | utdanningsbakgrunnene til sakene                                                                                                                                         |
        | utdanningsland     | utdanningslandene til sakene                                                                                                                                             |
        | GSK-konklusjon     | GSK-konklusjonene til sakene                                                                                                                                             |
        | grunnlag           | grunnlagene til sakene                                                                                                                                                   |
        | kvote              | kvotene til sakene                                                                                                                                                       |
        | studium            | utdanningstilbudene sakene gjelder                                                                                                                                       |
        | saksbehandler      | saksbehandlerne for sakene                                                                                                                                               |
        | søknadsstatus      | Aktiv, Trukket, Tilbud, Avslag og Svar                                                                                                                                   |
        | rolle              | behandler og tilbyder                                                                                                                                                    |
        | annet              | Overstyrt utdanningsbakgrunn som ikke er flyttet                                                                                                                         |
        | tagger             | taggene i opptaket                                                                                                                                                       |

    Scenariomal: Filtrere på <filter>
      Gitt jeg ser listen over saker
      Når jeg velger en verdi i <filter>-filteret
      Så vises kun saker som har den valgte verdien

      Eksempler:
        | filter             |
        | behandlingsstatus  |
        | dokumentasjon      |
        | kvalifisering      |
        | utdanningsbakgrunn |
        | utdanningsland     |
        | GSK-konklusjon     |
        | grunnlag           |
        | kvote              |
        | studium            |
        | saksbehandler      |
        | søknadsstatus      |
        | annet              |

    Scenario: Filtrere på saker jeg er saksbehandler for
      Gitt jeg ser listen over saker
      Når jeg velger "Mine søknader" i hurtigfilteret
      Så vises kun sakene jeg er saksbehandler for

    Scenariomal: Filtrere på at organisasjonen er <rolle>
      Gitt jeg er saksbehandler i et samordna opptak
      Og jeg ser listen over saker
      Når jeg filtrerer på at organisasjonen er <rolle>
      Så vises kun sakene der organisasjonen jeg er ansatt ved, er <rolle>

      Eksempler:
        | rolle     |
        | behandler |
        | tilbyder  |

    Scenario: Saker for søknader som er trukket, er skjult som standard
      Når jeg åpner saksoversikten for opptaket
      Så vises ikke sakene for søknader som er trukket

    Scenario: Filtrere på søknader som er trukket
      Gitt jeg ser listen over saker
      Når jeg velger "Trukket" i søknadsstatusfilteret
      Så vises sakene for søknader som er trukket

    Scenariomal: Kombinere tagger med <modus>
      Gitt jeg ser listen over saker
      Når jeg velger to tagger og kombinerer taggene med "<modus>"
      Så vises <utfall>

      Eksempler:
        | modus | utfall                                 |
        | Og    | kun saker som har begge taggene        |
        | Eller | saker som har minst én av taggene      |

    Scenario: Kombinere filtre
      Gitt jeg ser listen over saker
      Når jeg kombinerer fritekst-søk med ett eller flere filter
      Så vises kun saker som matcher alle kriteriene

  @depends-on-OPT-BEH-BEH-011 @ref-OPT-BEH-BEH-043 @openquestion
  Regel: Synlighet via organisasjonens rolle i opptaket
    # Hvem som ser hvilke saker, står i tildele_saksbehandlende_organisasjon.feature og se_søknaden_til_en_søker.feature.
    # ÅPNE SPØRSMÅL:
    # - Skal regelen ha egne scenarioer per rolle, eller holder det med henvisningen til OPT-BEH-BEH-011 og OPT-BEH-BEH-043?

    Scenariomal: Se sakene ut fra rollen og organisasjonens rolle i opptaket
      Gitt jeg er <rolle> hos <organisasjonens rolle> i opptaket
      Når jeg åpner saksoversikten for opptaket
      Så ser jeg <saker>

      Eksempler:
        | rolle             | organisasjonens rolle | saker                                                                                     |
        | saksbehandler     | behandleren           | sakene organisasjonen behandler                                                           |
        | saksbehandler     | tilbyderen            | sakene for utdanningstilbudene organisasjonen tilbyr, også når en annen organisasjon behandler dem |
        | opptaksforvalter  | forvalteren           | alle sakene i opptaket                                                                    |
        | opptaksinformatør | behandleren           | sakene organisasjonen behandler                                                           |
