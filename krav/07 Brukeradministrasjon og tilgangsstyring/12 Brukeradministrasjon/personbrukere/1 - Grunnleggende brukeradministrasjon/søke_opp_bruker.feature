# language: no
# GitHub: #479
@BRU-PER-GRU-001 @must @implemented
Egenskap: Listevisning og søk i personbrukere
  Som brukeradministrator
  ønsker jeg en oversikt over personbrukere jeg har tilgang til, med mulighet for søk og filtrering
  slik at jeg raskt kan finne og følge opp riktig bruker.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen

  Regel: Liste over alle personbrukere

    Scenario: Se liste over personbrukere (avvikles)
      Når jeg åpner brukeroversikten
      Så ser jeg en liste over alle personbrukere
      Og listen er sortert etter navn i stigende rekkefølge
      Og hvert innslag viser følgende informasjon:
        | felt             |
        | Navn             |
        | Feide-ID         |
        | Hjemorganisasjon |
        | Status           |

    @draft @openquestion
    Scenario: Se liste over personbrukere
      # ÅPNE SPØRSMÅL:
      # - En person som er koblet til en Feide-bruker, har hjemorganisasjonen fra Feide. Hva står i
      #   kolonnen «Hjemorganisasjon» for en person uten Feide-bruker, og for en person koblet til
      #   flere Feide-brukere med ulike hjemorganisasjoner?
      # - Skal kolonnen «Feide-ID» beholdes for personer som er koblet til en Feide-bruker?
      # - Skal testpersoner merkes med en egen kolonne eller ved navnet? Se «En testperson er
      #   merket i listen».
      # - Personer kan ikke deaktiveres i API-et ennå. Skal status vises for personer før det er på
      #   plass?
      # - I overgangsperioden vises også Feide-brukere med Feide-ID og hjemorganisasjon, se
      #   BRU-PER-GRU-015.
      Når brukeradministratoren åpner brukeroversikten
      Så ser brukeradministratoren en liste over alle personbrukere
      Og listen er sortert etter navn i stigende rekkefølge
      Og hvert innslag viser følgende informasjon:
        | felt   |
        | Navn   |
        | Status |

    @draft @openquestion
    Scenario: Fødselsnummer vises ikke i listen
      # ÅPNE SPØRSMÅL:
      # - Er det riktig at brukeradministratoren ikke skal kunne finne en person i listen med
      #   fødselsnummer, D-nummer eller SNR? Nummeret er ikke tilgjengelig i API-et, verken som
      #   felt eller som filter. En person finnes med nummeret bare ved å gi hen tilgang
      #   (BRU-PER-GRU-013).
      Når brukeradministratoren åpner brukeroversikten
      Så vises ikke personbrukernes fødselsnummer, D-nummer eller SNR
      Og brukeradministratoren kan ikke søke på fødselsnummer, D-nummer eller SNR

    @draft @openquestion
    Scenario: En testperson er merket i listen
      # ÅPNE SPØRSMÅL:
      # - Hvordan merkes testpersonen: egen kolonne, merkelapp ved navnet, eller et filter?
      # - Skal testpersoner vises i listen i et ekte miljø, der de ikke kan få tilgang?
      Gitt en personbruker er en testperson
      Når brukeradministratoren åpner brukeroversikten
      Så fremgår det av listen at personbrukeren er en testperson

    @draft @openquestion
    # ÅPNE SPØRSMÅL:
    # - API-et støtter ikke sortering på navn ennå, og UI-kontrollen er derfor fjernet. Når skal dette komme på plass, og hvem følger opp på API-siden?
    Scenariomal: Velge sorteringsretning for navn
      Gitt jeg ser listen over personbrukere
      Når jeg velger å sortere på navn i <retning> rekkefølge
      Så vises personbrukerne sortert etter navn i <retning> rekkefølge

      Eksempler:
        | retning  |
        | stigende |
        | synkende |

    Scenario: Liste viser de 50 første personbrukerne
      Når jeg åpner brukeroversikten
      Så ser jeg totalt antall treff og antall som er lastet
      Og listen viser de 50 første personbrukerne

    Scenario: Laste inn 50 flere personbrukere
      Gitt jeg ser listen over personbrukere
      Og det finnes flere personbrukere enn det som er lastet inn
      Når jeg velger å laste inn flere
      Så lastes de neste 50 personbrukerne inn i listen

    Scenario: Alle personbrukere er lastet inn
      Gitt jeg ser listen over personbrukere
      Og alle personbrukere er lastet inn
      Så er muligheten til å laste inn flere ikke tilgjengelig

    Scenario: Navigere til detaljside for personbruker
      Gitt jeg ser listen over personbrukere
      Når jeg velger en personbruker
      Så ser jeg detaljsiden for valgt personbruker

  Regel: Søk og filtrering av personbrukere

    Scenario: Fritekst-søk på navn
      Gitt jeg ser listen over personbrukere
      Når jeg søker med fritekst på navn
      Så filtreres listen til personbrukere der navn inneholder søketeksten

    # FORSLAG TIL WORKSHOP: fjernes (får @deprecated når de nye delene er validert), fordi
    # personbrukeren er personen og har ingen Feide-ID. I overgangsperioden kan søket fortsatt
    # trengs for Feide-brukerne, se BRU-PER-GRU-015.
    Scenario: Fritekst-søk på Feide-ID
      Gitt jeg ser listen over personbrukere
      Når jeg søker med fritekst på Feide-ID
      Så filtreres listen til personbrukere der Feide-ID inneholder søketeksten

    Scenario: Tilgjengelige statuser i filter
      Gitt jeg ser listen over personbrukere
      Når jeg åpner statusfilteret
      Så kan jeg velge mellom følgende statuser:
        | Status        |
        | Alle statuser |
        | Aktiv         |
        | Deaktivert    |
      Og "Alle statuser" er valgt som standard

    Scenario: Filtrere på status
      Gitt jeg ser listen over personbrukere
      Når jeg velger en status som filter
      Så vises kun personbrukere med den valgte statusen

    Scenario: Tilgjengelige hjemorganisasjoner i filter
      Gitt jeg ser listen over personbrukere
      Når jeg åpner hjemorganisasjonsfilteret
      Så inneholder filteret alle hjemorganisasjoner som er representert i den ufiltrerte listen
      Og hver hjemorganisasjon vises kun én gang
      Og hjemorganisasjonene er sortert alfabetisk
      Og "Alle hjemorganisasjoner" er valgt som standard

    Scenario: Filtrere på hjemorganisasjon
      Gitt jeg ser listen over personbrukere
      Når jeg velger en hjemorganisasjon som filter
      Så vises kun personbrukere med den valgte hjemorganisasjonen

    @draft @openquestion
    Scenario: Filtrere på organisasjon tildelingene gjelder for
      # ÅPNE SPØRSMÅL:
      # - Skal filteret komme i tillegg til hjemorganisasjonsfilteret, som er @in-progress?
      #   Personer koblet til en Feide-bruker har hjemorganisasjon, mens personer som bare logger
      #   inn med ID-porten, ikke har det.
      # - Skal det også være et filter på miljø? API-et for personer har det.
      # - Hvilke organisasjoner skal filteret tilby, når API-et ennå ikke har en liste over
      #   organisasjonene blant de synlige personene?
      Gitt brukeradministratoren ser listen over personbrukere
      Når brukeradministratoren velger en organisasjon som filter
      Så vises kun personbrukere med minst én aktiv tildeling i den valgte organisasjonen

    Scenario: Tilgjengelige roller i filter
      Gitt jeg ser listen over personbrukere
      Når jeg åpner rollefilteret
      Så inneholder filteret alle roller som er tildelt minst én personbruker i listen
      Og hver rolle vises kun én gang
      Og rollene er sortert alfabetisk
      Og "Alle roller" er valgt som standard

    Scenario: Filtrere på rolle
      Gitt jeg ser listen over personbrukere
      Når jeg velger en rolle som filter
      Så vises kun personbrukere som har den valgte rollen

    Scenario: Kombinere søk og filtre (avvikles)
      Gitt jeg ser listen over personbrukere
      Når jeg kombinerer søk i navn- og Feide-ID-feltene med ett eller flere filter
      Så vises kun personbrukere som matcher alle kriteriene

    @draft @openquestion
    Scenario: Kombinere søk og filtre
      # ÅPNE SPØRSMÅL:
      # - Feide-ID-feltet foreslås fjernet. Gjelder det først når Feide-brukerne er flyttet over til
      #   personer, eller allerede i overgangsperioden?
      Gitt brukeradministratoren ser listen over personbrukere
      Når brukeradministratoren kombinerer søk på navn med ett eller flere filter
      Så vises kun personbrukere som matcher alle kriteriene

  Regel: Synlighet via administrasjonsrettigheter

    Scenario: Brukeradministrator ser personbrukere med hjemorganisasjon i organisasjonene jeg administrerer
      Gitt jeg har brukeradministrator-rollen for én eller flere organisasjoner
      Og en personbruker har hjemorganisasjon i en av organisasjonene jeg administrerer
      Når jeg åpner brukeroversikten
      Så ser jeg personbrukeren i listen
      Og jeg ser personbrukeren uavhengig av hvilket miljø administrasjonsrettigheten min gjelder for

    @deprecated
    Scenario: Brukeradministrator ser personbrukere med datatilgang fra egne organisasjoner
      Gitt jeg har brukeradministrator-rollen for én eller flere organisasjoner
      Og en personbruker har hjemorganisasjon utenfor de organisasjonene jeg administrerer
      Men personbrukeren har en aktiv tildeling som gir tilgang til data fra en av dem
      Og tildelingen gjelder i et miljø jeg har brukeradministrator-rollen i
      Når jeg åpner brukeroversikten
      Så ser jeg personbrukeren i listen
      Og hjemorganisasjonen som vises er personbrukerens egen, ikke organisasjonen tildelingen gjelder for

    @planned
    Scenario: Brukeradministrator ser personbrukere fra andre organisasjoner med aktiv rolle i organisasjonene jeg administrerer
      Gitt jeg har brukeradministrator-rollen for én eller flere organisasjoner
      Og en personbruker har hjemorganisasjon utenfor organisasjonene jeg administrerer
      Men personbrukeren har en aktiv rolle i en av organisasjonene jeg administrerer, i et miljø jeg administrerer
      Når jeg åpner brukeroversikten
      Så ser jeg personbrukeren i listen
      Og hjemorganisasjonen som vises er personbrukerens egen

    @deprecated
    Scenario: Personbrukere uten tilknytning til egne organisasjoner er ikke synlige
      Gitt jeg har brukeradministrator-rollen for én eller flere organisasjoner
      Og en personbruker har hjemorganisasjon utenfor de organisasjonene jeg administrerer
      Og personbrukeren har ingen tildelinger som gir tilgang til data fra dem
      Når jeg åpner brukeroversikten
      Så ser jeg ikke personbrukeren i listen

    @deprecated
    Scenario: Personbrukere med kun inaktiv datatilgang fra egne organisasjoner er ikke synlige
      Gitt jeg har brukeradministrator-rollen for én eller flere organisasjoner
      Og en personbruker har hjemorganisasjon utenfor de organisasjonene jeg administrerer
      Og personbrukerens eneste tildeling som gir tilgang til data fra dem er inaktiv
      Når jeg åpner brukeroversikten
      Så ser jeg ikke personbrukeren i listen

    @planned
    Scenario: Personbrukere med annen hjemorganisasjon er ikke synlige uten aktiv rolle i organisasjonene jeg administrerer
      Gitt jeg har brukeradministrator-rollen for én eller flere organisasjoner
      Og en personbruker har hjemorganisasjon utenfor organisasjonene jeg administrerer
      Og personbrukeren har ingen aktive roller i organisasjonene jeg administrerer
      Når jeg åpner brukeroversikten
      Så ser jeg ikke personbrukeren i listen

    @deprecated
    Scenario: Personbrukere med datatilgang i et miljø jeg ikke administrerer er ikke synlige
      Gitt jeg har brukeradministrator-rollen for en organisasjon i ett miljø
      Og en personbruker har hjemorganisasjon utenfor de organisasjonene jeg administrerer
      Og personbrukerens eneste aktive tildeling som gir tilgang til data fra dem gjelder i et annet miljø
      Når jeg åpner brukeroversikten
      Så ser jeg ikke personbrukeren i listen

    @planned
    Scenario: Personbrukere med annen hjemorganisasjon er ikke synlige når rollen gjelder i et miljø jeg ikke administrerer
      Gitt jeg har brukeradministrator-rollen for en organisasjon i ett miljø
      Og en personbruker har hjemorganisasjon utenfor organisasjonen jeg administrerer
      Og personbrukerens eneste aktive rolle i organisasjonen jeg administrerer gjelder i et annet miljø
      Når jeg åpner brukeroversikten
      Så ser jeg ikke personbrukeren i listen

  @draft @openquestion
  Regel: Synlighet for personer følger av hjemorganisasjon og aktive tildelinger
    En person som logger inn med Feide, er koblet til Feide-brukeren sin og har hjemorganisasjonen
    fra Feide. Brukeradministratoren ser personen gjennom den hjemorganisasjonen, på samme måte som
    en Feide-bruker, eller gjennom en aktiv tildeling.

    # ÅPNE SPØRSMÅL:
    # - En person kan være koblet til flere Feide-brukere med ulike hjemorganisasjoner. Gir hver av
    #   dem synlighet?
    # - API-et viser i dag en person som har en tildeling, aktiv eller ikke, i en organisasjon og
    #   et miljø brukeradministratoren har lesetilgang i. Beslutningen er aktiv tildeling. Hva skal
    #   gjelde, og hvordan blir en deaktivert person synlig for den som skal reaktivere hen?
    # - Grensesnittet skjuler i dag Feide-brukere fra andre organisasjoner som bare har inaktive
    #   roller i organisasjonene brukeradministratoren administrerer. Skal det samme gjelde for
    #   personer?

    Scenario: Brukeradministrator ser personer med hjemorganisasjon i organisasjonene jeg administrerer
      Gitt brukeradministratoren har brukeradministrator-rollen for en organisasjon
      Og en person er koblet til en Feide-bruker med hjemorganisasjon i organisasjonen
      Når brukeradministratoren åpner brukeroversikten
      Så ser brukeradministratoren personen i listen
      Og brukeradministratoren ser personen uavhengig av hvilket miljø administrasjonsrettigheten gjelder for

    Scenario: Brukeradministrator ser personer med aktiv tildeling i organisasjonene jeg administrerer
      Gitt brukeradministratoren har brukeradministrator-rollen for en organisasjon i et miljø
      Og en person har en aktiv tildeling i organisasjonen i miljøet
      Når brukeradministratoren åpner brukeroversikten
      Så ser brukeradministratoren personen i listen

    Scenario: Personer med tildeling bare i et miljø brukeradministratoren ikke administrerer er ikke synlige
      Gitt brukeradministratoren har brukeradministrator-rollen for en organisasjon i ett miljø
      Og personen har ikke hjemorganisasjon i organisasjonen
      Og personens eneste aktive tildeling i organisasjonen gjelder i et annet miljø
      Når brukeradministratoren åpner brukeroversikten
      Så ser ikke brukeradministratoren personen i listen

    Scenario: Personer uten tildelinger og uten hjemorganisasjon er ikke synlige for noen
      Gitt en person har ingen tildelinger
      Og personen er ikke koblet til en Feide-bruker med hjemorganisasjon
      Når brukeradministratoren åpner brukeroversikten
      Så ser ikke brukeradministratoren personen i listen

  @draft @openquestion
  Regel: Sist brukt-kolonne og sortering (planlagt etter v1)
    # ÅPNE SPØRSMÅL:
    # - Backend har ikke støtte for dette: tidspunktet personbrukeren sist brukte løsningen lagres ikke. Hvordan og hvor skal det registreres?

    Scenario: Kolonnen "Sist brukt" vises i listen
      Gitt jeg ser listen over personbrukere
      Så vises tidspunktet personbrukeren sist brukte løsningen i en egen kolonne "Sist brukt"

    Scenariomal: Velge sorteringsretning for sist brukt
      Gitt jeg ser listen over personbrukere
      Når jeg velger å sortere på sist brukt i <retning> rekkefølge
      Så vises personbrukerne sortert etter tidspunkt for sist brukt i <retning> rekkefølge
      Og personbrukere som aldri har brukt løsningen behandles som om de sist brukte løsningen uendelig lenge siden

      Eksempler:
        | retning  |
        | stigende |
        | synkende |

# ÅPNE SPØRSMÅL:
# - Filnavn: bør "søke_opp_bruker.feature" omdøpes til "listevisning_og_sok.feature" for konsistens med mønsteret? Tittelendring på #479 må i så fall følges opp via fs-github.
# - Rolle-navn: "brukeradministrator" er valgt. Sjekk at rolledefinisjonene i "4 - Opprette og administrere roller" bruker samme navn.
# - Brukere uten Feide-ID er nå modellert i egne krav: BRU-PER-GRU-013 (gi en person tilgang med fødselsnummer, D-nummer eller SNR) og BRU-PER-GRU-014 (forvalte en person i brukeradministrasjonen). En person som er koblet til en Feide-bruker, har hjemorganisasjonen fra Feide og er synlig gjennom den, slik synlighetsreglene over sier. En person som bare logger inn med ID-porten, er synlig gjennom de aktive tildelingene sine.
# - Gjenstår: skal brukere med flere identiteter modelleres her, eller i et eget krav? Personbrukeren er nå personen, og Feide og ID-porten er påloggingsmåter, så spørsmålet kan være besvart.
# - De nye @draft-delene er skrevet i tredjeperson, mens de leverte delene bruker «jeg». Skal fila skrives om til tredjeperson samlet?
