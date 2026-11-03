# language: no
@BRU-APP-API-019 @must @draft
Egenskap: Tildele roller i gulvet til en Feide-applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å tildele roller i gulvet til en Feide-applikasjon for et miljø
  slik at alle brukerne av applikasjonen får de rollene de skal ha, også brukere uten egne roller.

  # Gulvet er det applikasjonen gir alle brukere, også ukjente. Se tilgangsstyring/docs/malarkitektur.md
  # og tilgangsstyring/docs/tilgangsmodell.md i fs-plattform.
  # Innspill 03.11.2026: to nye faner på applikasjonssiden for Feide-applikasjoner, én for taket
  # (BRU-APP-API-018) og én for gulvet.
  # AVKLART 03.11.2026: Gulvet er per applikasjon og miljø, uten organisasjon, slik målarkitekturen sier.
  # Applikasjonsadministrator-rollen for applikasjonseieren er nok til å tildele, uten eget privilegium.
  # Bare Feide-applikasjoner har fanen for gulvet. Syntetiske og ekte miljøer, test og demo behandles som
  # ved tildeling av roller til personbrukere (BRU-PER-GRU-003). Nekt og endringslogg er utenfor kravet
  # foreløpig.

  # ÅPNE SPØRSMÅL:
  # - Gulvet har ingen organisasjon, men en rolle gjelder alltid for en organisasjon. For hvilken organisasjon får brukerne rollen i gulvet: applikasjonseieren, alle organisasjoner, eller organisasjonene der applikasjonen har tak?
  # - I dag er gulvet per organisasjon og miljø, uten applikasjon, og ligger inne i snittet med taket (tilgangsmodell.md). Gulvet per applikasjon, ved siden av snittet, må bygges først. Hva skjer med gulvet som finnes i dag?
  # - Skal applikasjonsadministratoren også kunne fjerne roller fra gulvet? Innspillet sier tildele, og brukerne mister tilgangen når en rolle tas ut av gulvet. For personbrukere og applikasjoner er tildeling og fjerning egne krav (BRU-PER-GRU-012, BRU-APP-API-008).
  # - Skal applikasjonsadministratoren kunne sette en gyldighetsperiode når en rolle tildeles i gulvet?

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
        | felt  |
        | Rolle |
        | Miljø |

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

  Regel: En tildeling i gulvet gjelder én rolle for et miljø

    Scenario: Tildele en rolle i gulvet for valgt miljø
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for gulvet
      Når jeg velger et miljø og en rolle jeg har rettighet til å tildele i gulvet
      Så er rollen i gulvet til applikasjonen for det valgte miljøet
      Og det fremgår hvilket miljø tildelingen gjelder

    Scenario: Organisasjon velges ikke ved tildeling i gulvet
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for gulvet
      Når jeg velger å tildele roller i gulvet
      Så er det ingen valgliste for organisasjon

    Scenario: Tildele flere roller i gulvet samtidig
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for gulvet
      Når jeg velger et miljø og flere roller jeg har rettighet til å tildele i gulvet
      Så er rollene i gulvet til applikasjonen for det valgte miljøet

    Scenario: Delvis suksess ved samtidig tildeling av roller i gulvet
      # Samme mønster som ved tildeling av roller til personbrukere (BRU-PER-GRU-003).
      Gitt jeg har valgt flere roller å tildele i gulvet
      Når noen av tildelingene ikke kan gjennomføres
      Så gjennomføres de tildelingene som er gyldige
      Og jeg ser tydelig hvilke tildelinger som ikke ble gjennomført, og hvorfor

  Regel: Bare forretningsroller kan tildeles i gulvet

    Scenario: Valglisten for rolle i gulvet viser bare forretningsroller
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for gulvet
      Og jeg har valgt miljø
      Når jeg åpner valglisten for roller
      Så vises bare forretningsroller
      Men brukerflateroller og privilegier vises ikke

  Regel: Tildelingen krever applikasjonsadministrator-rollen for applikasjonseieren

    Scenario: Valglisten for miljø viser miljøene der jeg administrerer applikasjonseieren
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har åpnet fanen for gulvet
      Når jeg åpner valglisten for miljø
      Så ser jeg bare miljøene der jeg har applikasjonsadministrator-rollen for applikasjonseieren

    Scenario: Tildeling i gulvet er ikke tilgjengelig uten applikasjonsadministrator-rollen for applikasjonseieren
      Gitt applikasjonen har Feide som identitetsleverandør
      Og jeg har ikke applikasjonsadministrator-rollen for applikasjonseieren
      Og jeg har applikasjonsadministrator-rollen for en annen organisasjon
      Når jeg åpner fanen for gulvet
      Så er muligheten til å tildele roller i gulvet ikke tilgjengelig

  Regel: En rolle som allerede er i gulvet for samme miljø kan ikke tildeles på nytt

    Scenario: Rolle som allerede er i gulvet vises som ikke-valgbar
      Gitt applikasjonen har Feide som identitetsleverandør
      Og applikasjonen har en rolle i gulvet for et miljø
      Og jeg har åpnet fanen for gulvet
      Når jeg velger roller å tildele i gulvet for samme miljø
      Så vises rollen som allerede er i gulvet, som ikke valgbar
      Og det fremgår at rollen allerede er i gulvet

  Regel: Alle brukere av applikasjonen får rollene i gulvet
    # Effektiv tilgang gjennom applikasjonen er (personbrukerens roller ∩ taket) ∪ gulvet ∪ åpne roller,
    # minus nekt (malarkitektur.md). Hvilken organisasjon rollen gjelder for, er et åpent spørsmål.

    Scenariomal: Bruker uten egne roller får rollene i gulvet for miljøet i gulvet
      Gitt applikasjonen har Feide som identitetsleverandør
      Og forretningsrollen "OPPTAK_SAKSBEHANDLER" er i gulvet til applikasjonen i miljøet "Produksjon"
      Og en bruker har ingen roller
      Når brukeren bruker applikasjonen i miljøet <miljø>
      Så <får> brukeren forretningsrollen "OPPTAK_SAKSBEHANDLER"

      Eksempler:
        | miljø        | får      |
        | "Produksjon" | får      |
        | "Test"       | får ikke |

    Scenariomal: Brukeren mister rollen når rollen ikke lenger er i gulvet
      Gitt applikasjonen har Feide som identitetsleverandør
      Og forretningsrollen "OPPTAK_SAKSBEHANDLER" er i gulvet til applikasjonen i miljøet "Produksjon"
      Og en bruker har ingen roller
      Når <hendelse>
      Og brukeren bruker applikasjonen i miljøet "Produksjon"
      Så får brukeren ikke forretningsrollen "OPPTAK_SAKSBEHANDLER"

      Eksempler:
        | hendelse                                          |
        | rollen tas ut av gulvet                           |
        | gyldighetsperioden for rollen i gulvet avsluttes |
