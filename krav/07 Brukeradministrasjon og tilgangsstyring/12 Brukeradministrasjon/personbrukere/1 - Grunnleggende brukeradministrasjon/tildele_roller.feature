# language: no
# GitHub: #481
@BRU-PER-GRU-003 @must @in-progress @scope-restanser-etter-onboarding
Egenskap: Tildele roller til en personbruker
  Som brukeradministrator
  ønsker jeg å tildele roller til en personbruker
  slik at personbrukeren har det riktige settet av tilganger til enhver tid.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en personbruker

  Regel: En tildeling gjelder én rolle for en organisasjon og et miljø

    Scenario: Tildele en rolle for valgt organisasjon og miljø
      Når jeg velger en organisasjon, et miljø og en rolle jeg har rettighet til å tildele
      Så er rollen tildelt personbrukeren for den valgte kombinasjonen av organisasjon og miljø
      Og det fremgår hvilken organisasjon og hvilket miljø tildelingen gjelder

  Regel: Tildelingen gjelder en organisasjon administratoren har rettighet for

    Scenario: Organisasjon er implisitt når administrator administrerer kun én organisasjon
      Gitt jeg administrerer kun én organisasjon
      Når jeg velger et miljø og en rolle jeg har rettighet til å tildele
      Så er rollen tildelt personbrukeren i det valgte miljøet for organisasjonen jeg administrerer

    Scenario: Valglisten for organisasjon er begrenset til organisasjoner jeg administrerer
      Gitt jeg administrerer flere organisasjoner
      Når jeg åpner valglisten for organisasjon
      Så ser jeg kun organisasjoner jeg har brukeradministrator-rollen for

    Scenario: Personbrukerens hjemorganisasjon er forhåndsvalgt
      Gitt jeg administrerer flere organisasjoner
      Og personbrukerens hjemorganisasjon er blant organisasjonene jeg administrerer
      Når jeg velger å tildele en rolle
      Så er personbrukerens hjemorganisasjon valgt som organisasjon
      Og jeg kan velge en annen av organisasjonene jeg administrerer

    Scenariomal: Ingen organisasjon er forhåndsvalgt uten en hjemorganisasjon jeg administrerer
      Gitt jeg administrerer flere organisasjoner
      Og personbrukerens hjemorganisasjon er <hjemorganisasjon>
      Når jeg velger å tildele en rolle
      Så er ingen organisasjon valgt

      Eksempler:
        | hjemorganisasjon                                 |
        | ukjent                                           |
        | ikke blant organisasjonene jeg administrerer     |

  Regel: En eller flere roller kan tildeles i én operasjon

    Scenario: Tildele en rolle til en personbruker
      Når jeg tildeler en rolle til personbrukeren
      Så legges rollen til i personbrukerens tildelinger
      Og rollen er aktiv fra tildelingstidspunktet
      Og endringen er sporbar i historikk

    Scenario: Tildele flere roller samtidig
      Når jeg velger flere roller og tildeler dem i én operasjon
      Så legges alle de valgte rollene til hos personbrukeren
      Og hver tildeling er sporbar individuelt i historikk

    Scenario: Delvis suksess ved samtidig tildeling av roller
      Gitt jeg har valgt flere roller å tildele
      Når noen av tildelingene ikke kan gjennomføres
      Så gjennomføres de tildelingene som er gyldige
      Og jeg ser tydelig hvilke tildelinger som ikke ble gjennomført, og hvorfor

  Regel: Bruker kan kun tildele roller de selv har rettighet til å tildele

    Scenario: Valglisten for rolle avhenger av valgt organisasjon og miljø
      Gitt jeg har valgt organisasjon og miljø
      Når jeg åpner valglisten for roller
      Så vises kun roller jeg har rettighet til å tildele for den valgte kombinasjonen av organisasjon og miljø

  Regel: Bare forretningsroller kan tildeles som rolle

    Scenario: Valglisten for rolle viser bare forretningsroller
      Gitt jeg har valgt organisasjon og miljø
      Når jeg åpner valglisten for roller
      Så vises bare forretningsroller
      Men brukerflateroller og privilegier vises ikke

    @draft @openquestion
    Scenario: Tildeling av en rolle som ikke er en forretningsrolle avvises
      # ÅPNE SPØRSMÅL:
      # - Regelen skal også håndheves når rollen tildeles, ikke bare i valglisten. Når skal det bygges?
      # - Finnes det direkte tildelinger av brukerflateroller fra før (f.eks. FS-ADMIN_OPPTAK_*), og skal de ryddes?
      Når en rolle som ikke er en forretningsrolle tildeles personbrukeren
      Så avvises tildelingen
      Og personbrukeren har ikke fått rollen

  Regel: Valglisten for rolle viser bare roller som er i taket til en applikasjon i valgt organisasjon og miljø
    # Taket sier, per applikasjon, organisasjon og miljø, hvilke roller applikasjonen kan bruke
    # for brukerne sine. En rolle som ikke er i taket til noen applikasjon i organisasjonen og
    # miljøet, får ingen effekt for personbrukeren der. Brukere har meldt at de ser slike roller
    # i tildelingsdialogen (produkteier, 29.10.2026).
    # AVKLART 29.10.2026 (produkteier): Regelen gjelder bare forretningsroller som tildeles
    # personbrukere. Den gjelder ikke tilganger (BRU-PER-GRU-009), og ikke tildeling til
    # applikasjoner (BRU-APP-API-007). Den gjelder når roller legges til, ikke når de fjernes.
    # Taket begrenser bare valglisten; en tildeling av en rolle utenfor taket avvises ikke.

    Scenariomal: Rollen vises bare når en applikasjon har den i taket for valgt organisasjon og miljø
      Gitt jeg har valgt organisasjonen "Universitetet i Stavanger" og miljøet "Produksjon"
      Og forretningsrollen "OPPTAK_SAKSBEHANDLER" er i taket til en applikasjon for <organisasjon> i miljøet <miljø>
      Når jeg åpner valglisten for roller
      Så <vises> forretningsrollen "OPPTAK_SAKSBEHANDLER"

      Eksempler:
        | organisasjon                | miljø        | vises      |
        | "Universitetet i Stavanger" | "Produksjon" | vises      |
        | "Universitetet i Stavanger" | "Test"       | vises ikke |
        | "Universitetet i Bergen"    | "Produksjon" | vises ikke |

    Scenario: Rolle som ikke er i taket til noen applikasjon vises ikke
      Gitt jeg har valgt organisasjon og miljø
      Og ingen applikasjon har forretningsrollen i taket for den valgte organisasjonen og miljøet
      Når jeg åpner valglisten for roller
      Så vises ikke forretningsrollen

    Scenario: Taket for en organisasjonssamling gjelder organisasjonene i samlingen
      Gitt jeg har valgt organisasjonen "Universitetet i Stavanger" og miljøet "Produksjon"
      Og "Universitetet i Stavanger" er med i en organisasjonssamling
      Og forretningsrollen "OPPTAK_SAKSBEHANDLER" er i taket til en applikasjon for organisasjonssamlingen i miljøet "Produksjon"
      Når jeg åpner valglisten for roller
      Så vises forretningsrollen "OPPTAK_SAKSBEHANDLER"

    Scenario: En rolle som en rolle i taket gir, vises
      Gitt jeg har valgt organisasjon og miljø
      Og en applikasjon har en forretningsrolle i taket for den valgte organisasjonen og miljøet
      Og forretningsrollen i taket gir en annen forretningsrolle
      Når jeg åpner valglisten for roller
      Så vises forretningsrollen som rollen i taket gir

    Scenario: Valglisten for rolle er tom når ingen applikasjon har tak i organisasjonen og miljøet
      Gitt jeg har valgt organisasjon og miljø
      Og ingen applikasjon har tak for den valgte organisasjonen og miljøet
      Når jeg åpner valglisten for roller
      Så er valglisten for roller tom

    @ref-BRU-PER-GRU-012
    Scenario: En rolle som ikke er i noe tak kan fortsatt fjernes
      # Taket begrenser bare hvilke roller som kan legges til.
      Gitt personbrukeren har en forretningsrolle for en organisasjon og et miljø
      Og ingen applikasjon har forretningsrollen i taket for organisasjonen og miljøet
      Når jeg fjerner forretningsrollen fra personbrukeren
      Så er forretningsrollen fjernet fra personbrukeren

  Regel: Utgåtte roller kan ikke tildeles

    Scenario: Utgåtte roller vises ikke i valglisten for rolle
      Gitt en forretningsrolle er markert som utgått i rollekatalogen
      Når jeg åpner valglisten for roller
      Så vises ikke den utgåtte forretningsrollen

  Regel: En rolle som allerede er tildelt for samme organisasjon og miljø kan ikke tildeles på nytt

    Scenario: Allerede tildelt rolle vises som ikke-valgbar
      Gitt personbrukeren har en rolle tildelt for en kombinasjon av organisasjon og miljø
      Når jeg velger roller å tildele for samme kombinasjon av organisasjon og miljø
      Så vises den allerede tildelte rollen som ikke valgbar
      Og det fremgår at rollen allerede er tildelt

# ÅPNE SPØRSMÅL:
# - Autorisasjon: regelen sier at brukeren kun kan tildele roller de har rettighet til å tildele, men ikke hva rettigheten består i. Forslag: bare roller som (a) gjelder ved en organisasjon administratoren administrerer, og (b) administratoren selv har eller kan administrere. Henger sammen med rolledefinisjons-arbeidet i "4 - Opprette og administrere roller".
# - Skal varsel sendes til personbrukeren ved endringer i roller? Avklares sammen med BRU-PER-HIS-003.
# - Krever tildeling at brukeren har godkjent bruksvilkår / signert taushetserklæring først? Henger sammen med "1 - Bruksvilkår".
# - Kan en sammensatt rolle gi personbrukeren en rolle hen ikke er tildelt direkte? BRU-PER-GRU-008 har et åpent spørsmål om utfolding av sammensatte roller; hvis roller kan arves, trenger dette kravet et opphavs-begrep slik tilgangssiden har.
