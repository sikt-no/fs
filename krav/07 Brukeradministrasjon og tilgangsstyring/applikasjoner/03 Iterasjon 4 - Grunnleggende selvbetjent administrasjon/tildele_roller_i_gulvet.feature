# language: no
@BRU-APP-API-019 @must @draft
Egenskap: Forvalte roller i gulvet til en Feide-applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å tildele og fjerne roller i gulvet til en Feide-applikasjon for en organisasjon og et miljø
  slik at alle brukerne av applikasjonen får de rollene de skal ha, også brukere uten egne roller.

  # Gulvet er det applikasjonen gir alle brukere, også ukjente. Se tilgangsstyring/docs/malarkitektur.md
  # og tilgangsstyring/docs/tilgangsmodell.md i fs-plattform.
  # Innspill 03.11.2026: to nye faner på applikasjonssiden for Feide-applikasjoner, én for taket
  # (BRU-APP-API-018) og én for gulvet.
  # Implementasjonsdetaljer: tildele_roller_i_gulvet.design.md.
  # AVKLART 03.11.2026 (koden er fasit): Gulvet er per applikasjon, organisasjon og miljø, og brukerne
  # får rollen for organisasjonen gulvet gjelder. Det erstatter det tidligere svaret om at gulvet ikke
  # har organisasjon.
  # AVKLART 03.11.2026: Bare forretningsroller. Bare Feide-applikasjoner har fanen for gulvet. Fanen skal
  # også la applikasjonsadministratoren fjerne roller. Syntetiske og ekte miljøer, test og demo behandles
  # som ved tildeling av roller til personbrukere (BRU-PER-GRU-003). Nekt og endringslogg er utenfor
  # kravet foreløpig.
  # AVKLART 04.11.2026: Applikasjonsadministrator-rollen er nok til å forvalte gulvet, uten eget
  # privilegium, men den kreves både for applikasjonseieren og for organisasjonen gulvet gjelder, i samme
  # miljø. Det som legges i gulvet, utvider tilgangene til eksisterende brukere.
  # AVKLART 04.11.2026: Gyldighetsperioden er skopet ned til det vi har for personbrukere og
  # applikasjoner. Vi har den i databasen, men FS Admin kan ikke sette den for personbrukere eller
  # applikasjoner (BRU-PER-GRU-006 er @draft). Fanen setter derfor ikke gyldighetsperiode, men viser
  # gyldighetstidsrommet slik rollelisten for personbrukere gjør (BRU-PER-GRU-008).

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en applikasjon

  Regel: Applikasjonssiden har en fane for gulvet bare for Feide-applikasjoner

    Scenariomal: Fanen for gulvet vises ut fra identitetsleverandøren
      Gitt applikasjonen har <identitetsleverandør> som identitetsleverandør
      Så <vises> fanen for gulvet

      Eksempler:
        | identitetsleverandør | vises      |
        | Feide                | vises      |
        | Maskinporten         | vises ikke |
        | FS                   | vises ikke |

  Regel: Alle som kan se applikasjonen, ser fanen for gulvet

    Scenario: Bruker uten applikasjonsadministrator-rollen ser fanen for gulvet
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg kan se applikasjonen
      Og jeg har ikke applikasjonsadministrator-rollen for applikasjonseieren
      Så vises fanen for gulvet

  Regel: Fanen for gulvet viser rollene i gulvet til applikasjonen som gjelder nå

    Scenario: Se rollene i gulvet til applikasjonen
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for gulvet
      Så ser jeg en liste over rollene i gulvet til applikasjonen
      Og hvert innslag viser følgende informasjon:
        | felt              |
        | Rolle             |
        | Organisasjon      |
        | Miljø             |
        | Gyldighetstidsrom |

    Scenariomal: Bare gulv som gjelder nå, vises
      Gitt applikasjonen har Feide som identitetsleverandør
      Og applikasjonen har en rolle i gulvet med en gyldighetsperiode som <periode>
      Når jeg åpner fanen for gulvet
      Så <vises> rollen i listen

      Eksempler:
        | periode        | vises      |
        | gjelder nå     | vises      |
        | er avsluttet   | vises ikke |
        | starter senere | vises ikke |

    @ref-BRU-PER-GRU-008
    Scenario: Se gyldighetstidsrommet for en rolle i gulvet
      Gitt applikasjonen har Feide som identitetsleverandør
      Og applikasjonen har en rolle i gulvet med et sluttidspunkt
      Når jeg åpner fanen for gulvet
      Så ser jeg gyldighetstidsrommet for rollen

  Regel: En tildeling i gulvet gjelder én rolle for en organisasjon og et miljø

    Scenario: Tildele en rolle i gulvet for valgt organisasjon og miljø
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for gulvet
      Når jeg velger en organisasjon, et miljø og en rolle jeg har rettighet til å tildele i gulvet
      Så er rollen i gulvet til applikasjonen for den valgte kombinasjonen av organisasjon og miljø
      Og det fremgår hvilken organisasjon og hvilket miljø tildelingen gjelder

    Scenario: Tildele flere roller i gulvet samtidig
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for gulvet
      Når jeg velger en organisasjon, et miljø og flere roller jeg har rettighet til å tildele i gulvet
      Så er rollene i gulvet til applikasjonen for den valgte kombinasjonen av organisasjon og miljø

    Scenario: Delvis suksess ved samtidig tildeling av roller i gulvet
      Gitt jeg har valgt flere roller å tildele i gulvet
      Når noen av tildelingene ikke kan gjennomføres
      Så gjennomføres de tildelingene som er gyldige
      Og jeg ser tydelig hvilke tildelinger som ikke ble gjennomført, og hvorfor

  Regel: En fjerning fra gulvet gjelder én rolle for en organisasjon og et miljø

    Scenario: Fjerne en rolle fra gulvet for valgt organisasjon og miljø
      Gitt applikasjonen har Feide som identitetsleverandør
      Og applikasjonen har den samme rollen i gulvet for flere kombinasjoner av organisasjon og miljø
      Og jeg har åpnet fanen for gulvet
      Når jeg fjerner rollen fra gulvet for én av kombinasjonene
      Så er rollen ikke lenger i gulvet til applikasjonen for den kombinasjonen
      Og rollen består i gulvet for de øvrige kombinasjonene

    Scenario: Fjerne flere roller fra gulvet samtidig
      Gitt applikasjonen har Feide som identitetsleverandør
      Og applikasjonen har flere roller i gulvet
      Og jeg har åpnet fanen for gulvet
      Når jeg velger flere roller og fjerner dem fra gulvet i én operasjon
      Så er alle de valgte rollene fjernet fra gulvet

  Regel: Bare forretningsroller kan tildeles i gulvet

    Scenario: Valglisten for rolle i gulvet viser bare forretningsroller
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for gulvet
      Og jeg har valgt organisasjon og miljø
      Når jeg åpner valglisten for roller
      Så vises bare forretningsroller
      Men brukerflateroller og privilegier vises ikke

  Regel: Forvaltning av gulvet krever applikasjonsadministrator-rollen for applikasjonseieren og for organisasjonen gulvet gjelder, i samme miljø

    Scenariomal: Tildeling og fjerning i gulvet krever applikasjonsadministrator-rollen for begge organisasjonene i samme miljø
      Gitt applikasjonen har Feide som identitetsleverandør
      Og "Universitetet i Stavanger" er applikasjonseier
      Og jeg har applikasjonsadministrator-rollen for "Universitetet i Stavanger" i miljøet <miljø for applikasjonseieren>
      Og jeg har applikasjonsadministrator-rollen for "Universitetet i Bergen" i miljøet <miljø for organisasjonen>
      Når jeg vil <handling> en rolle i gulvet for "Universitetet i Bergen" i miljøet "Produksjon"
      Så <kan> jeg <handling> rollen

      Eksempler:
        | handling | miljø for applikasjonseieren | miljø for organisasjonen | kan      |
        | tildele  | "Produksjon"                 | "Produksjon"             | kan      |
        | tildele  | "Produksjon"                 | "Test"                   | kan ikke |
        | tildele  | "Test"                       | "Produksjon"             | kan ikke |
        | fjerne   | "Produksjon"                 | "Produksjon"             | kan      |
        | fjerne   | "Produksjon"                 | "Test"                   | kan ikke |
        | fjerne   | "Test"                       | "Produksjon"             | kan ikke |

    Scenario: Gulv for applikasjonseieren selv krever bare rollen for applikasjonseieren
      Gitt applikasjonen har Feide som identitetsleverandør
      Og "Universitetet i Stavanger" er applikasjonseier
      Og jeg har applikasjonsadministrator-rollen for "Universitetet i Stavanger" i miljøet "Produksjon"
      Når jeg vil tildele en rolle i gulvet for "Universitetet i Stavanger" i miljøet "Produksjon"
      Så kan jeg tildele rollen

    Scenario: Valglisten for organisasjon i gulvet er begrenset til organisasjoner jeg administrerer
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har applikasjonsadministrator-rollen for applikasjonseieren
      Og jeg har applikasjonsadministrator-rollen for flere organisasjoner
      Og jeg har åpnet fanen for gulvet
      Når jeg åpner valglisten for organisasjon
      Så ser jeg kun organisasjoner jeg har applikasjonsadministrator-rollen for

    Scenario: Valglisten for miljø i gulvet avhenger av valgt organisasjon
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for gulvet
      Og jeg har valgt en organisasjon
      Når jeg åpner valglisten for miljø
      Så ser jeg bare miljøene der jeg har applikasjonsadministrator-rollen både for applikasjonseieren og for den valgte organisasjonen

    Scenario: Forvaltning av gulvet er ikke tilgjengelig uten applikasjonsadministrator-rollen for applikasjonseieren
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har ikke applikasjonsadministrator-rollen for applikasjonseieren
      Og jeg har applikasjonsadministrator-rollen for en annen organisasjon
      Når jeg åpner fanen for gulvet
      Så er muligheten til å tildele og fjerne roller i gulvet ikke tilgjengelig

    Scenario: Fjerning fra gulvet er begrenset til organisasjoner jeg administrerer
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har applikasjonsadministrator-rollen for applikasjonseieren
      Og applikasjonen har roller i gulvet for flere organisasjoner
      Når jeg åpner fanen for gulvet
      Så er muligheten til å fjerne tilgjengelig kun for roller i gulvet for organisasjoner jeg har applikasjonsadministrator-rollen for

  Regel: En rolle som allerede er i gulvet for samme organisasjon og miljø kan ikke tildeles på nytt

    Scenario: Rolle som allerede er i gulvet vises som ikke-valgbar
      Gitt applikasjonen har Feide som identitetsleverandør
      Og applikasjonen har en rolle i gulvet for en kombinasjon av organisasjon og miljø
      Og jeg har åpnet fanen for gulvet
      Når jeg velger roller å tildele i gulvet for samme kombinasjon av organisasjon og miljø
      Så vises rollen som allerede er i gulvet, som ikke valgbar
      Og det fremgår at rollen allerede er i gulvet

  Regel: Alle brukere av applikasjonen får rollene i gulvet for organisasjonen og miljøet i gulvet

    Scenariomal: Bruker uten egne roller får rollen i gulvet
      Gitt applikasjonen har Feide som identitetsleverandør
      Og forretningsrollen "OPPTAK_SAKSBEHANDLER" er i gulvet til applikasjonen for "Universitetet i Stavanger" i miljøet "Produksjon"
      Og en bruker har ingen roller
      Når brukeren bruker applikasjonen i miljøet <miljø>
      Så <får> brukeren forretningsrollen "OPPTAK_SAKSBEHANDLER" for <organisasjon>

      Eksempler:
        | organisasjon                | miljø        | får      |
        | "Universitetet i Stavanger" | "Produksjon" | får      |
        | "Universitetet i Stavanger" | "Test"       | får ikke |
        | "Universitetet i Bergen"    | "Produksjon" | får ikke |

    Scenario: Rollen i gulvet gjelder selv om rollen ikke er i taket
      Gitt applikasjonen har Feide som identitetsleverandør
      Og forretningsrollen "OPPTAK_SAKSBEHANDLER" er i gulvet til applikasjonen for "Universitetet i Stavanger" i miljøet "Produksjon"
      Og forretningsrollen "OPPTAK_SAKSBEHANDLER" er ikke i taket til applikasjonen for "Universitetet i Stavanger" i miljøet "Produksjon"
      Når en bruker bruker applikasjonen i miljøet "Produksjon"
      Så får brukeren forretningsrollen "OPPTAK_SAKSBEHANDLER" for "Universitetet i Stavanger"

    Scenariomal: Brukeren mister rollen når rollen ikke lenger er i gulvet
      Gitt applikasjonen har Feide som identitetsleverandør
      Og forretningsrollen "OPPTAK_SAKSBEHANDLER" er i gulvet til applikasjonen for "Universitetet i Stavanger" i miljøet "Produksjon"
      Og en bruker har ingen roller
      Når <hendelse>
      Og brukeren bruker applikasjonen i miljøet "Produksjon"
      Så får brukeren ikke forretningsrollen "OPPTAK_SAKSBEHANDLER" for "Universitetet i Stavanger"

      Eksempler:
        | hendelse                                          |
        | rollen fjernes fra gulvet                         |
        | gyldighetsperioden for rollen i gulvet avsluttes |
