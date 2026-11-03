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
  # AVKLART 03.11.2026 (koden er fasit): Gulvet er per applikasjon, organisasjon og miljø. Hver rad i
  # applikasjon_brukergrunntilgang (0099 i fs-plattform) har applikasjon, rolle, organisasjon, miljø og
  # gyldighetsperiode, og raa_grunntilganger(miljø, applikasjon) gir brukerne rollen for organisasjonen
  # på raden. Det erstatter det tidligere svaret om at gulvet ikke har organisasjon. For en bruker med
  # FS-fiktivt fødselsnummer begrenses gulvet til hjemorganisasjonen (tilganger_for_bruker).
  # AVKLART 03.11.2026: Applikasjonsadministrator-rollen for applikasjonseieren er nok til å forvalte gulvet,
  # uten eget privilegium. Bare forretningsroller. Bare Feide-applikasjoner har fanen for gulvet. Fanen skal
  # også la applikasjonsadministratoren fjerne roller og sette gyldighetsperiode. Syntetiske og ekte miljøer,
  # test og demo behandles som ved tildeling av roller til personbrukere (BRU-PER-GRU-003). Nekt og
  # endringslogg er utenfor kravet foreløpig.

  # ÅPNE SPØRSMÅL:
  # - Koden har ingen skriveflate for gulvet ennå: lesepolicyen er den eneste policyen, og 0099 sier at gulvet skal ha et eget privilegium fordi en rad i gulvet gir applikasjonen like mye makt som en åpen rolle. Svaret er at applikasjonsadministrator-rollen for applikasjonseieren er nok. Skal skriveflaten bygges slik, i strid med kommentaren i 0099?

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
    # Et gulv gjelder nå når gyldighetsperioden inneholder tidspunktet nå, og gulvet ikke er ugyldiggjort
    # (jf. tildele_roller.design.md for personbrukere). Gulv som er avsluttet eller starter senere,
    # filtreres bort i spørringen, ikke med RLS, slik som for personbrukere og applikasjoner.

    Scenario: Se rollene i gulvet til applikasjonen
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for gulvet
      Så ser jeg en liste over rollene i gulvet til applikasjonen
      Og hvert innslag viser følgende informasjon:
        | felt         |
        | Rolle        |
        | Organisasjon |
        | Miljø        |

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
      # Samme mønster som ved tildeling av roller til personbrukere (BRU-PER-GRU-003).
      Gitt jeg har valgt flere roller å tildele i gulvet
      Når noen av tildelingene ikke kan gjennomføres
      Så gjennomføres de tildelingene som er gyldige
      Og jeg ser tydelig hvilke tildelinger som ikke ble gjennomført, og hvorfor

  Regel: En fjerning fra gulvet gjelder én rolle for en organisasjon og et miljø
    # Samme mønster som ved fjerning av roller fra personbrukere (BRU-PER-GRU-012).

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

  Regel: Applikasjonsadministratoren kan sette gyldighetsperiode for en rolle i gulvet
    # Samme mønster som for tildelinger til personbrukere (BRU-PER-GRU-006). Start- og sluttidspunkt
    # angis med dato og tidspunkt (minutt-oppløsning) i tidssonen Europe/Oslo.

    Scenario: Sette sluttidspunkt på en rolle i gulvet
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for gulvet
      Når jeg setter et sluttidspunkt fram i tid på en rolle i gulvet
      Så er rollen i gulvet fram til sluttidspunktet
      Og rollen er automatisk ute av gulvet etter sluttidspunktet

    Scenario: Sette starttidspunkt fram i tid på en rolle i gulvet
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for gulvet
      Når jeg tildeler en rolle i gulvet med et starttidspunkt fram i tid
      Så er rollen ikke i gulvet fram til starttidspunktet
      Og rollen er automatisk i gulvet fra starttidspunktet

    Scenario: Sette både start- og sluttidspunkt på en rolle i gulvet
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for gulvet
      Når jeg tildeler en rolle i gulvet med både et starttidspunkt og et sluttidspunkt fram i tid
      Så er rollen i gulvet kun innenfor det angitte tidsrommet

    Scenario: Sluttidspunkt i fortiden avvises for en rolle i gulvet
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for gulvet
      Når jeg forsøker å sette et sluttidspunkt som ligger i fortiden på en rolle i gulvet
      Så lagres ikke endringen
      Og jeg ser en feilmelding som sier at sluttidspunkt ikke kan ligge i fortiden

    Scenario: Sluttidspunkt før starttidspunkt avvises for en rolle i gulvet
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for gulvet
      Og jeg setter både et starttidspunkt og et sluttidspunkt på en rolle i gulvet
      Når sluttidspunktet ligger før starttidspunktet
      Så lagres ikke endringen
      Og jeg ser en feilmelding som sier at sluttidspunkt må ligge etter starttidspunkt

  Regel: Bare forretningsroller kan tildeles i gulvet

    Scenario: Valglisten for rolle i gulvet viser bare forretningsroller
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for gulvet
      Og jeg har valgt organisasjon og miljø
      Når jeg åpner valglisten for roller
      Så vises bare forretningsroller
      Men brukerflateroller og privilegier vises ikke

  Regel: Forvaltning av gulvet krever applikasjonsadministrator-rollen for applikasjonseieren

    Scenario: Forvaltning av gulvet er ikke tilgjengelig uten applikasjonsadministrator-rollen for applikasjonseieren
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har ikke applikasjonsadministrator-rollen for applikasjonseieren
      Og jeg har applikasjonsadministrator-rollen for en annen organisasjon
      Når jeg åpner fanen for gulvet
      Så er muligheten til å tildele og fjerne roller i gulvet ikke tilgjengelig

    Scenario: Valglisten for miljø viser miljøene der jeg administrerer applikasjonseieren
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for gulvet
      Når jeg åpner valglisten for miljø
      Så ser jeg bare miljøene der jeg har applikasjonsadministrator-rollen for applikasjonseieren

    @openquestion
    Scenario: Valglisten for organisasjon i gulvet
      # ÅPNE SPØRSMÅL:
      # - Gulvet har organisasjon, og svaret er at rollen for applikasjonseieren er nok. Hvilke organisasjoner kan applikasjonsadministratoren da velge: alle, bare applikasjonseieren, eller bare organisasjoner hen også har applikasjonsadministrator-rollen for, slik som for taket?
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har applikasjonsadministrator-rollen for applikasjonseieren
      Og jeg har åpnet fanen for gulvet
      Når jeg åpner valglisten for organisasjon
      Så ser jeg organisasjonene jeg kan tildele roller i gulvet for

  Regel: En rolle som allerede er i gulvet for samme organisasjon og miljø kan ikke tildeles på nytt

    Scenario: Rolle som allerede er i gulvet vises som ikke-valgbar
      Gitt applikasjonen har Feide som identitetsleverandør
      Og applikasjonen har en rolle i gulvet for en kombinasjon av organisasjon og miljø
      Og jeg har åpnet fanen for gulvet
      Når jeg velger roller å tildele i gulvet for samme kombinasjon av organisasjon og miljø
      Så vises rollen som allerede er i gulvet, som ikke valgbar
      Og det fremgår at rollen allerede er i gulvet

  Regel: Alle brukere av applikasjonen får rollene i gulvet for organisasjonen og miljøet i gulvet
    # Effektiv tilgang gjennom applikasjonen er ((personbrukerens roller ∩ taket) ∪ gulvet ∪ åpne roller)
    # minus nekt (kombiner_tildelinger, 0099 i fs-plattform). Gulvet ligger utenfor taket.

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
