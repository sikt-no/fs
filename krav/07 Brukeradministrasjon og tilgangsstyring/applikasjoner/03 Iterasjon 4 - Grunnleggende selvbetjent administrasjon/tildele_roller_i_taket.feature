# language: no
@BRU-APP-API-018 @must @draft
Egenskap: Tildele roller i taket til en Feide-applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å tildele roller i taket til en Feide-applikasjon for en organisasjon og et miljø
  slik at brukerne av applikasjonen bare kan bruke de rollene applikasjonen skal formidle.

  # Taket sier, per applikasjon, organisasjon og miljø, hvilke av personbrukerens egne roller
  # applikasjonen får bruke på vegne av personbrukeren. Se tilgangsstyring/docs/malarkitektur.md
  # og tilgangsstyring/docs/tilgangsmodell.md i fs-plattform.
  # Innspill 03.11.2026: to nye faner på applikasjonssiden for Feide-applikasjoner,
  # én for taket og én for gulvet (gulvet: BRU-APP-API-019).
  # AVKLART 03.11.2026: Syntetiske og ekte miljøer, test og demo behandles som ved tildeling av
  # roller til personbrukere (BRU-PER-GRU-003). Nekt og endringslogg er utenfor kravet foreløpig.

  # ÅPNE SPØRSMÅL:
  # - Skal applikasjonsadministratoren også kunne fjerne roller fra taket? Innspillet sier tildele, og brukerne mister tilgangen når en rolle tas ut av taket. For personbrukere og applikasjoner er tildeling og fjerning egne krav (BRU-PER-GRU-012, BRU-APP-API-008).
  # - Skal applikasjonsadministratoren kunne sette en gyldighetsperiode når en rolle tildeles i taket?

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en applikasjon

  @openquestion
  Regel: Applikasjonssiden har en fane for taket bare for Feide-applikasjoner
    # ÅPNE SPØRSMÅL:
    # - Bekreft at fanen for taket bare gjelder Feide-applikasjoner, slik som fanen for gulvet. Taket kan i dag bare registreres for Feide-applikasjoner.

    Scenariomal: Fanen for taket vises ut fra identitetsleverandøren
      Gitt applikasjonen har <identitetsleverandør> som identitetsleverandør
      Så <vises> fanen for taket

      Eksempler:
        | identitetsleverandør | vises      |
        | Feide                | vises      |
        | Maskinporten         | vises ikke |
        | FS                   | vises ikke |

  Regel: Alle som kan se applikasjonen, ser fanen for taket

    Scenario: Bruker uten applikasjonsadministrator-rollen ser fanen for taket
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg kan se applikasjonen
      Og jeg har ikke applikasjonsadministrator-rollen for applikasjonseieren
      Så vises fanen for taket

  Regel: Fanen for taket viser rollene i taket til applikasjonen som gjelder nå
    # Et tak gjelder nå når gyldighetsperioden inneholder tidspunktet nå, og taket ikke er ugyldiggjort
    # (jf. tildele_roller.design.md for personbrukere). Tak som er avsluttet eller starter senere,
    # filtreres bort i spørringen, ikke med RLS, slik som for personbrukere og applikasjoner.

    Scenario: Se rollene i taket til applikasjonen
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for taket
      Så ser jeg en liste over rollene i taket til applikasjonen
      Og hvert innslag viser følgende informasjon:
        | felt         |
        | Rolle        |
        | Organisasjon |
        | Miljø        |

    Scenariomal: Bare tak som gjelder nå, vises
      Gitt applikasjonen har Feide som identitetsleverandør
      Og applikasjonen har en rolle i taket med en gyldighetsperiode som <periode>
      Når jeg åpner fanen for taket
      Så <vises> rollen i listen

      Eksempler:
        | periode        | vises      |
        | gjelder nå     | vises      |
        | er avsluttet   | vises ikke |
        | starter senere | vises ikke |

  @openquestion
  Regel: Tak for en organisasjonssamling vises som tak for hver organisasjon i samlingen
    # AVKLART 03.11.2026: Tak for organisasjonssamlinger vises, men kan ikke administreres ennå.
    # ÅPNE SPØRSMÅL:
    # - Regnes en rolle som er i taket gjennom en organisasjonssamling, som «allerede i taket» for en organisasjon i samlingen, slik at den ikke kan tildeles på nytt for organisasjonen?
    # - Skal det fremgå i listen at taket kommer fra en organisasjonssamling?

    Scenario: Tak for en organisasjonssamling vises per organisasjon
      Gitt applikasjonen har Feide som identitetsleverandør
      Og forretningsrollen "OPPTAK_SAKSBEHANDLER" er i taket til applikasjonen for en organisasjonssamling i miljøet "Produksjon"
      Og "Universitetet i Stavanger" og "Universitetet i Bergen" er med i organisasjonssamlingen
      Når jeg åpner fanen for taket
      Så vises forretningsrollen "OPPTAK_SAKSBEHANDLER" i taket for "Universitetet i Stavanger" i miljøet "Produksjon"
      Og forretningsrollen "OPPTAK_SAKSBEHANDLER" vises i taket for "Universitetet i Bergen" i miljøet "Produksjon"

    Scenario: Tak for en organisasjonssamling kan ikke tildeles
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for taket
      Når jeg åpner valglisten for organisasjon
      Så kan jeg ikke velge en organisasjonssamling

  Regel: En tildeling i taket gjelder én rolle for en organisasjon og et miljø

    Scenario: Tildele en rolle i taket for valgt organisasjon og miljø
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for taket
      Når jeg velger en organisasjon, et miljø og en rolle jeg har rettighet til å tildele i taket
      Så er rollen i taket til applikasjonen for den valgte kombinasjonen av organisasjon og miljø
      Og det fremgår hvilken organisasjon og hvilket miljø tildelingen gjelder

    Scenario: Tildele flere roller i taket samtidig
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for taket
      Når jeg velger en organisasjon, et miljø og flere roller jeg har rettighet til å tildele i taket
      Så er rollene i taket til applikasjonen for den valgte kombinasjonen av organisasjon og miljø

    Scenario: Delvis suksess ved samtidig tildeling av roller i taket
      # Samme mønster som ved tildeling av roller til personbrukere (BRU-PER-GRU-003).
      Gitt jeg har valgt flere roller å tildele i taket
      Når noen av tildelingene ikke kan gjennomføres
      Så gjennomføres de tildelingene som er gyldige
      Og jeg ser tydelig hvilke tildelinger som ikke ble gjennomført, og hvorfor

  Regel: Bare forretningsroller kan tildeles i taket

    Scenario: Valglisten for rolle i taket viser bare forretningsroller
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for taket
      Og jeg har valgt organisasjon og miljø
      Når jeg åpner valglisten for roller
      Så vises bare forretningsroller
      Men brukerflateroller og privilegier vises ikke

  Regel: Tildelingen krever applikasjonsadministrator-rollen for applikasjonseieren og for organisasjonen taket gjelder
    # Applikasjonseieren forvalter taket til applikasjonen sin. Gjelder taket en annen organisasjon
    # enn applikasjonseieren, må applikasjonsadministratoren ha rollen for begge, i samme miljø.

    Scenario: Valglisten for organisasjon er begrenset til organisasjoner jeg administrerer
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har applikasjonsadministrator-rollen for applikasjonseieren
      Og jeg har applikasjonsadministrator-rollen for flere organisasjoner
      Og jeg har åpnet fanen for taket
      Når jeg åpner valglisten for organisasjon
      Så ser jeg kun organisasjoner jeg har applikasjonsadministrator-rollen for

    Scenario: Valglisten for miljø avhenger av valgt organisasjon
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for taket
      Og jeg har valgt en organisasjon
      Når jeg åpner valglisten for miljø
      Så ser jeg bare miljøene der jeg har applikasjonsadministrator-rollen både for applikasjonseieren og for den valgte organisasjonen

    Scenario: Tildeling i taket er ikke tilgjengelig uten applikasjonsadministrator-rollen for applikasjonseieren
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har ikke applikasjonsadministrator-rollen for applikasjonseieren
      Og jeg har applikasjonsadministrator-rollen for en annen organisasjon
      Når jeg åpner fanen for taket
      Så er muligheten til å tildele roller i taket ikke tilgjengelig

  Regel: En rolle som allerede er i taket for samme organisasjon og miljø kan ikke tildeles på nytt

    Scenario: Rolle som allerede er i taket vises som ikke-valgbar
      Gitt applikasjonen har Feide som identitetsleverandør
      Og applikasjonen har en rolle i taket for en kombinasjon av organisasjon og miljø
      Og jeg har åpnet fanen for taket
      Når jeg velger roller å tildele i taket for samme kombinasjon av organisasjon og miljø
      Så vises rollen som allerede er i taket, som ikke valgbar
      Og det fremgår at rollen allerede er i taket

  @ref-BRU-PER-GRU-003
  Regel: Taket begrenser hvilke av personbrukerens roller brukeren får gjennom applikasjonen
    # Effektiv tilgang gjennom applikasjonen er (personbrukerens roller ∩ taket) ∪ gulvet ∪ åpne roller,
    # minus nekt (malarkitektur.md). Taket brukes også i valglisten for rolle på personbrukere.

    Scenariomal: Personbrukerens rolle gjelder gjennom applikasjonen bare når rollen er i taket
      Gitt applikasjonen har Feide som identitetsleverandør
      Og personbrukeren har forretningsrollen "OPPTAK_SAKSBEHANDLER" for "Universitetet i Stavanger" i miljøet "Produksjon"
      Og forretningsrollen "OPPTAK_SAKSBEHANDLER" er i taket til applikasjonen for <organisasjon> i miljøet <miljø>
      Når personbrukeren bruker applikasjonen i miljøet "Produksjon"
      Så <får> personbrukeren forretningsrollen "OPPTAK_SAKSBEHANDLER" for "Universitetet i Stavanger"

      Eksempler:
        | organisasjon                | miljø        | får      |
        | "Universitetet i Stavanger" | "Produksjon" | får      |
        | "Universitetet i Stavanger" | "Test"       | får ikke |
        | "Universitetet i Bergen"    | "Produksjon" | får ikke |

    Scenariomal: Personbrukeren mister rollen gjennom applikasjonen når rollen ikke lenger er i taket
      Gitt applikasjonen har Feide som identitetsleverandør
      Og personbrukeren har forretningsrollen "OPPTAK_SAKSBEHANDLER" for "Universitetet i Stavanger" i miljøet "Produksjon"
      Og forretningsrollen "OPPTAK_SAKSBEHANDLER" er i taket til applikasjonen for "Universitetet i Stavanger" i miljøet "Produksjon"
      Når <hendelse>
      Og personbrukeren bruker applikasjonen i miljøet "Produksjon"
      Så får personbrukeren ikke forretningsrollen "OPPTAK_SAKSBEHANDLER" for "Universitetet i Stavanger"

      Eksempler:
        | hendelse                                         |
        | rollen tas ut av taket                           |
        | gyldighetsperioden for rollen i taket avsluttes |
