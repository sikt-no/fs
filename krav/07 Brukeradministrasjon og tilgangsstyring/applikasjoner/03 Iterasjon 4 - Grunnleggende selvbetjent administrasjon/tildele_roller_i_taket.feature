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

  # ÅPNE SPØRSMÅL:
  # - Hvilke roller kan legges i taket: bare forretningsroller, slik som rollene personbrukere kan
  #   tildeles (BRU-PER-GRU-003), eller også tilganger?
  # - Skal applikasjonsadministratoren også kunne fjerne roller fra taket? Innspillet sier tildele.
  #   For personbrukere og applikasjoner er tildeling og fjerning egne krav (BRU-PER-GRU-012, BRU-APP-API-008).
  # - Hvem ser fanen for taket uten rettighet til å tildele? Kan en applikasjonsadministrator i en
  #   organisasjon som taket gjelder, se taket når hen ikke administrerer applikasjonseieren, og omvendt?
  #   Og ser brukere med andre roller som gir tilgang til applikasjoner (BRU-APP-API-003), fanen?
  # - Hva skjer med personbrukere som har en rolle når rollen tas ut av taket? Tildelingen til
  #   personbrukeren står, men får ingen effekt gjennom applikasjonen. Skal det vises eller varsles?
  # - Taket kan i dag også gjelde en organisasjonssamling. Skal fanen vise og tildele tak for
  #   organisasjonssamlinger (jf. BRU-PER-GRU-003, «Taket for en organisasjonssamling gjelder
  #   organisasjonene i samlingen»)?
  # - Taket har en gyldighetsperiode. Skal fanen vise tak som er avsluttet eller starter senere, og
  #   skal applikasjonsadministratoren kunne sette en gyldighetsperiode ved tildeling?
  # - Syntetiske og ekte miljøer: test og demo forvaltes fra produksjon, og målarkitekturen sier at
  #   FS Admin må gjøre det vanskelig å endre tilganger i feil miljø. Hvordan skal fanen vise hvilket
  #   miljø en tildeling gjelder, og hvordan skal syntetiske applikasjoner behandles?
  # - Miljøet `local` skal ha de samme takene som `test`, som en kopi. Skal en tildeling i `test`
  #   også gjøres i `local`, eller er det utenfor dette kravet?
  # - Hører nekt hjemme på applikasjonssiden, eller bare på personbrukeren?
  # - Hvilke felter skal listen i fanen ha utover rolle, organisasjon og miljø, og trengs filtrering,
  #   sortering og innlasting av flere, slik som i listen over tilganger (BRU-APP-API-003)?
  # - Er tildeling i taket sporbar i endringsloggen (BRU-APP-API-016)?
  # - Hvordan skal delvis suksess håndteres når flere roller tildeles i én operasjon? Jf. det
  #   tilsvarende spørsmålet i BRU-APP-API-007.

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

  Regel: Fanen for taket viser rollene i taket til applikasjonen

    Scenario: Se rollene i taket til applikasjonen
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for taket
      Så ser jeg en liste over rollene i taket til applikasjonen
      Og hvert innslag viser følgende informasjon:
        | felt         |
        | Rolle        |
        | Organisasjon |
        | Miljø        |

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
