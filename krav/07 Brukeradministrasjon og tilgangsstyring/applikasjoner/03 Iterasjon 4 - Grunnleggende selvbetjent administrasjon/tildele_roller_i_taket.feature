# language: no
@BRU-APP-API-018 @must @in-progress @scope-tak-og-gulv-for-feide-applikasjoner
Egenskap: Forvalte roller i taket til en Feide-applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å tildele og fjerne roller i taket til en Feide-applikasjon for en organisasjon og et miljø
  slik at brukerne av applikasjonen bare kan bruke de rollene applikasjonen skal formidle.

  # Taket sier, per applikasjon, organisasjon og miljø, hvilke av personbrukerens egne roller
  # applikasjonen får bruke på vegne av personbrukeren. Se tilgangsstyring/docs/malarkitektur.md
  # og tilgangsstyring/docs/tilgangsmodell.md i fs-plattform.
  # Innspill 03.11.2026: to nye faner på applikasjonssiden for Feide-applikasjoner,
  # én for taket og én for gulvet (gulvet: BRU-APP-API-019).
  # Implementasjonsdetaljer: tildele_roller_i_taket.design.md.
  # AVKLART 03.11.2026: Syntetiske og ekte miljøer, test og demo behandles som ved tildeling av
  # roller til personbrukere (BRU-PER-GRU-003). Nekt og endringslogg er utenfor kravet foreløpig.
  # AVKLART 03.11.2026: Bare Feide-applikasjoner har fanen for taket. Fanen skal også la
  # applikasjonsadministratoren fjerne roller.
  # AVKLART 04.11.2026: Gyldighetsperioden er skopet ned til det vi har for personbrukere og
  # applikasjoner. Vi har den i databasen, men FS Admin kan ikke sette den for personbrukere eller
  # applikasjoner (BRU-PER-GRU-006 er @draft). Fanen setter derfor ikke gyldighetsperiode, men viser
  # gyldighetstidsrommet slik rollelisten for personbrukere gjør (BRU-PER-GRU-008).

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en applikasjon

  Regel: Applikasjonssiden har en fane for taket bare for Feide-applikasjoner

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

    Scenario: Se rollene i taket til applikasjonen
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for taket
      Så ser jeg en liste over rollene i taket til applikasjonen
      Og hvert innslag viser følgende informasjon:
        | felt              |
        | Rolle             |
        | Organisasjon      |
        | Miljø             |
        | Gyldighetstidsrom |

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

    @ref-BRU-PER-GRU-008
    Scenario: Se gyldighetstidsrommet for en rolle i taket
      Gitt applikasjonen har Feide som identitetsleverandør
      Og applikasjonen har en rolle i taket med et sluttidspunkt
      Når jeg åpner fanen for taket
      Så ser jeg gyldighetstidsrommet for rollen

  Regel: Tak for en organisasjonssamling vises som tak for hver organisasjon i samlingen
    # AVKLART 03.11.2026: Tak for organisasjonssamlinger vises, men kan ikke administreres ennå. En rolle
    # i taket gjennom en organisasjonssamling regnes som allerede i taket for organisasjonene i samlingen,
    # og listen viser om taket gjelder organisasjonen selv eller kommer fra organisasjonssamlingen.

    Scenario: Tak for en organisasjonssamling vises per organisasjon
      Gitt applikasjonen har Feide som identitetsleverandør
      Og forretningsrollen "OPPTAK_SAKSBEHANDLER" er i taket til applikasjonen for en organisasjonssamling i miljøet "Produksjon"
      Og "Universitetet i Stavanger" og "Universitetet i Bergen" er med i organisasjonssamlingen
      Når jeg åpner fanen for taket
      Så vises forretningsrollen "OPPTAK_SAKSBEHANDLER" i taket for "Universitetet i Stavanger" i miljøet "Produksjon"
      Og forretningsrollen "OPPTAK_SAKSBEHANDLER" vises i taket for "Universitetet i Bergen" i miljøet "Produksjon"

    Scenariomal: Listen viser hvor taket kommer fra
      Gitt applikasjonen har Feide som identitetsleverandør
      Og "Universitetet i Stavanger" er med i en organisasjonssamling
      Og forretningsrollen "OPPTAK_SAKSBEHANDLER" er i taket til applikasjonen for <tildelt for> i miljøet "Produksjon"
      Når jeg åpner fanen for taket
      Så fremgår det at taket for "Universitetet i Stavanger" kommer fra <kilde>

      Eksempler:
        | tildelt for                 | kilde                  |
        | "Universitetet i Stavanger" | organisasjonen selv    |
        | organisasjonssamlingen      | organisasjonssamlingen |

    Scenario: Organisasjonssamling kan ikke velges ved tildeling i taket
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for taket
      Når jeg åpner valglisten for organisasjon
      Så kan jeg ikke velge en organisasjonssamling

    Scenario: Tak fra en organisasjonssamling kan ikke fjernes
      Gitt applikasjonen har Feide som identitetsleverandør
      Og forretningsrollen "OPPTAK_SAKSBEHANDLER" er i taket til applikasjonen for en organisasjonssamling i miljøet "Produksjon"
      Når jeg åpner fanen for taket
      Så er muligheten til å fjerne taket som kommer fra organisasjonssamlingen, ikke tilgjengelig

    Scenario: Rolle i taket gjennom en organisasjonssamling regnes som allerede i taket
      Gitt applikasjonen har Feide som identitetsleverandør
      Og "Universitetet i Stavanger" er med i en organisasjonssamling
      Og forretningsrollen "OPPTAK_SAKSBEHANDLER" er i taket til applikasjonen for organisasjonssamlingen i miljøet "Produksjon"
      Og jeg har åpnet fanen for taket
      Når jeg velger roller å tildele i taket for "Universitetet i Stavanger" i miljøet "Produksjon"
      Så vises forretningsrollen "OPPTAK_SAKSBEHANDLER" som ikke valgbar
      Og det fremgår at rollen allerede er i taket

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
      Gitt jeg har valgt flere roller å tildele i taket
      Når noen av tildelingene ikke kan gjennomføres
      Så gjennomføres de tildelingene som er gyldige
      Og jeg ser tydelig hvilke tildelinger som ikke ble gjennomført, og hvorfor

  Regel: En fjerning fra taket gjelder én rolle for en organisasjon og et miljø

    Scenario: Fjerne en rolle fra taket for valgt organisasjon og miljø
      Gitt applikasjonen har Feide som identitetsleverandør
      Og applikasjonen har den samme rollen i taket for flere kombinasjoner av organisasjon og miljø
      Og jeg har åpnet fanen for taket
      Når jeg fjerner rollen fra taket for én av kombinasjonene
      Så er rollen ikke lenger i taket til applikasjonen for den kombinasjonen
      Og rollen består i taket for de øvrige kombinasjonene

    Scenario: Fjerne flere roller fra taket samtidig
      Gitt applikasjonen har Feide som identitetsleverandør
      Og applikasjonen har flere roller i taket
      Og jeg har åpnet fanen for taket
      Når jeg velger flere roller og fjerner dem fra taket i én operasjon
      Så er alle de valgte rollene fjernet fra taket

  Regel: Bare forretningsroller kan tildeles i taket

    Scenario: Valglisten for rolle i taket viser bare forretningsroller
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for taket
      Og jeg har valgt organisasjon og miljø
      Når jeg åpner valglisten for roller
      Så vises bare forretningsroller
      Men brukerflateroller og privilegier vises ikke

  Regel: Forvaltning av taket krever applikasjonsadministrator-rollen for applikasjonseieren og for organisasjonen taket gjelder, i samme miljø

    Scenariomal: Tildeling og fjerning i taket krever applikasjonsadministrator-rollen for begge organisasjonene i samme miljø
      Gitt applikasjonen har Feide som identitetsleverandør
      Og "Universitetet i Stavanger" er applikasjonseier
      Og jeg har applikasjonsadministrator-rollen for "Universitetet i Stavanger" i miljøet <miljø for applikasjonseieren>
      Og jeg har applikasjonsadministrator-rollen for "Universitetet i Bergen" i miljøet <miljø for organisasjonen>
      Når jeg vil <handling> en rolle i taket for "Universitetet i Bergen" i miljøet "Produksjon"
      Så <kan> jeg <handling> rollen

      Eksempler:
        | handling | miljø for applikasjonseieren | miljø for organisasjonen | kan      |
        | tildele  | "Produksjon"                 | "Produksjon"             | kan      |
        | tildele  | "Produksjon"                 | "Test"                   | kan ikke |
        | tildele  | "Test"                       | "Produksjon"             | kan ikke |
        | fjerne   | "Produksjon"                 | "Produksjon"             | kan      |
        | fjerne   | "Produksjon"                 | "Test"                   | kan ikke |
        | fjerne   | "Test"                       | "Produksjon"             | kan ikke |

    Scenario: Tak for applikasjonseieren selv krever bare rollen for applikasjonseieren
      Gitt applikasjonen har Feide som identitetsleverandør
      Og "Universitetet i Stavanger" er applikasjonseier
      Og jeg har applikasjonsadministrator-rollen for "Universitetet i Stavanger" i miljøet "Produksjon"
      Når jeg vil tildele en rolle i taket for "Universitetet i Stavanger" i miljøet "Produksjon"
      Så kan jeg tildele rollen

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

    Scenario: Forvaltning av taket er ikke tilgjengelig uten applikasjonsadministrator-rollen for applikasjonseieren
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har ikke applikasjonsadministrator-rollen for applikasjonseieren
      Og jeg har applikasjonsadministrator-rollen for en annen organisasjon
      Når jeg åpner fanen for taket
      Så er muligheten til å tildele og fjerne roller i taket ikke tilgjengelig

    Scenario: Fjerning fra taket er begrenset til organisasjoner jeg administrerer
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har applikasjonsadministrator-rollen for applikasjonseieren
      Og applikasjonen har roller i taket for flere organisasjoner
      Når jeg åpner fanen for taket
      Så er muligheten til å fjerne tilgjengelig kun for roller i taket for organisasjoner jeg har applikasjonsadministrator-rollen for

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
        | rollen fjernes fra taket                         |
        | gyldighetsperioden for rollen i taket avsluttes |
