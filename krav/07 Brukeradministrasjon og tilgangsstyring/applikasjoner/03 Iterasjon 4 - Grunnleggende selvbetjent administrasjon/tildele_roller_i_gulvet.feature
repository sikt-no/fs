# language: no
@BRU-APP-API-019 @must @draft
Egenskap: Tildele roller i gulvet til en Feide-applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å tildele roller i gulvet til en Feide-applikasjon for en organisasjon og et miljø
  slik at alle brukerne av applikasjonen får de rollene de skal ha, også brukere uten egne roller.

  # Gulvet er det applikasjonen gir alle brukere, også ukjente. Se tilgangsstyring/docs/malarkitektur.md
  # og tilgangsstyring/docs/tilgangsmodell.md i fs-plattform.
  # Innspill 03.11.2026: to nye faner på applikasjonssiden for Feide-applikasjoner, én for taket
  # (BRU-APP-API-018) og én for gulvet.

  # ÅPNE SPØRSMÅL:
  # - Gulvet per applikasjon finnes ikke i dag. I tilgangsmodell.md er gulvet per organisasjon og
  #   miljø, uten applikasjon, og gulvet ligger inne i snittet med taket: taket ∩ (brukerroller ∪ gulvet).
  #   Målarkitekturen sier at gulvet er per applikasjon og per miljø, uten å nevne organisasjon, og at
  #   gulvet legges ved siden av snittet. Innspillet sier per applikasjon og organisasjon. Kravet er skrevet
  #   etter målarkitekturen, med organisasjon. Er det riktig?
  # - Skal applikasjonsadministrator-rollen være nok til å tildele roller i gulvet? Gulvet gir rollene til
  #   alle brukere, også ukjente. Å registrere en åpen rolle krever et eget privilegium av samme grunn, og
  #   et tidligere utkast krevde rettighet hos Sikt for å forvalte taket fordi taket kunne formidle en rolle
  #   i gulvet.
  # - Hvilke roller kan legges i gulvet: forretningsroller, tilganger eller begge?
  # - Skal applikasjonsadministratoren også kunne fjerne roller fra gulvet? Innspillet sier tildele.
  #   For personbrukere og applikasjoner er tildeling og fjerning egne krav (BRU-PER-GRU-012, BRU-APP-API-008).
  # - Hvem ser fanen for gulvet uten rettighet til å tildele? Og ser brukere med andre roller som gir
  #   tilgang til applikasjoner (BRU-APP-API-003), fanen?
  # - Hva skjer med brukere som er innlogget i applikasjonen når en rolle tas ut av gulvet?
  # - Gulvet har en gyldighetsperiode, slik som taket. Skal fanen vise gulv som er avsluttet eller starter
  #   senere, og skal applikasjonsadministratoren kunne sette en gyldighetsperiode ved tildeling?
  # - Syntetiske og ekte miljøer: test og demo forvaltes fra produksjon, og målarkitekturen sier at
  #   FS Admin må gjøre det vanskelig å endre tilganger i feil miljø. Hvordan skal fanen vise hvilket
  #   miljø en tildeling gjelder, og hvordan skal syntetiske applikasjoner behandles?
  # - Miljøet `local` skal ha det samme gulvet som `test`, som en kopi. Skal en tildeling i `test` også
  #   gjøres i `local`, eller er det utenfor dette kravet?
  # - Nekt slår også gulvet. Hører nekt hjemme på applikasjonssiden, eller bare på personbrukeren? Og
  #   søkere uten personsubjekt kan ikke nektes (åpent spørsmål i målarkitekturen).
  # - Skal Feide-applikasjoner ha fanen for gulvet, eller også applikasjoner brukere logger inn i med
  #   ID-porten, slik som Min kompetanse?
  # - Hvilke felter skal listen i fanen ha utover rolle, organisasjon og miljø, og trengs filtrering,
  #   sortering og innlasting av flere, slik som i listen over tilganger (BRU-APP-API-003)?
  # - Er tildeling i gulvet sporbar i endringsloggen (BRU-APP-API-016)?
  # - Hvordan skal delvis suksess håndteres når flere roller tildeles i én operasjon? Jf. det
  #   tilsvarende spørsmålet i BRU-APP-API-007.

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

  Regel: Fanen for gulvet viser rollene i gulvet til applikasjonen

    Scenario: Se rollene i gulvet til applikasjonen
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for gulvet
      Så ser jeg en liste over rollene i gulvet til applikasjonen
      Og hvert innslag viser følgende informasjon:
        | felt         |
        | Rolle        |
        | Organisasjon |
        | Miljø        |

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

  Regel: Tildelingen krever applikasjonsadministrator-rollen for applikasjonseieren og for organisasjonen gulvet gjelder
    # Samme regel som for taket (BRU-APP-API-018), jf. innspillet: «for applikasjoner og organisasjoner
    # hun er applikasjonsadministrator for».

    Scenario: Valglisten for organisasjon er begrenset til organisasjoner jeg administrerer
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har applikasjonsadministrator-rollen for applikasjonseieren
      Og jeg har applikasjonsadministrator-rollen for flere organisasjoner
      Og jeg har åpnet fanen for gulvet
      Når jeg åpner valglisten for organisasjon
      Så ser jeg kun organisasjoner jeg har applikasjonsadministrator-rollen for

    Scenario: Valglisten for miljø avhenger av valgt organisasjon
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for gulvet
      Og jeg har valgt en organisasjon
      Når jeg åpner valglisten for miljø
      Så ser jeg bare miljøene der jeg har applikasjonsadministrator-rollen både for applikasjonseieren og for den valgte organisasjonen

    Scenario: Tildeling i gulvet er ikke tilgjengelig uten applikasjonsadministrator-rollen for applikasjonseieren
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har ikke applikasjonsadministrator-rollen for applikasjonseieren
      Og jeg har applikasjonsadministrator-rollen for en annen organisasjon
      Når jeg åpner fanen for gulvet
      Så er muligheten til å tildele roller i gulvet ikke tilgjengelig

  Regel: En rolle som allerede er i gulvet for samme organisasjon og miljø kan ikke tildeles på nytt

    Scenario: Rolle som allerede er i gulvet vises som ikke-valgbar
      Gitt applikasjonen har Feide som identitetsleverandør
      Og applikasjonen har en rolle i gulvet for en kombinasjon av organisasjon og miljø
      Og jeg har åpnet fanen for gulvet
      Når jeg velger roller å tildele i gulvet for samme kombinasjon av organisasjon og miljø
      Så vises rollen som allerede er i gulvet, som ikke valgbar
      Og det fremgår at rollen allerede er i gulvet

  Regel: Alle brukere av applikasjonen får rollene i gulvet
    # Effektiv tilgang gjennom applikasjonen er (personbrukerens roller ∩ taket) ∪ gulvet ∪ åpne roller,
    # minus nekt (malarkitektur.md). Se første åpne spørsmål om forskjellen fra dagens modell.

    Scenario: Bruker uten egne roller får rollene i gulvet
      Gitt applikasjonen har Feide som identitetsleverandør
      Og rollen "LEVER_SOKNAD" er i gulvet til applikasjonen for "Universitetet i Stavanger" i miljøet "Produksjon"
      Og en bruker har ingen roller for "Universitetet i Stavanger"
      Når brukeren bruker applikasjonen i miljøet "Produksjon"
      Så får brukeren rollen "LEVER_SOKNAD" for "Universitetet i Stavanger"

    Scenariomal: Rollen i gulvet gjelder bare for organisasjonen og miljøet i gulvet
      Gitt applikasjonen har Feide som identitetsleverandør
      Og rollen "LEVER_SOKNAD" er i gulvet til applikasjonen for "Universitetet i Stavanger" i miljøet "Produksjon"
      Og en bruker har ingen roller
      Når brukeren bruker applikasjonen i miljøet <miljø>
      Så <får> brukeren rollen "LEVER_SOKNAD" for <organisasjon>

      Eksempler:
        | organisasjon                | miljø        | får      |
        | "Universitetet i Stavanger" | "Produksjon" | får      |
        | "Universitetet i Stavanger" | "Test"       | får ikke |
        | "Universitetet i Bergen"    | "Produksjon" | får ikke |
