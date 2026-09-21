# language: no
# GitHub: #479
@BRU-PER-GRU-001 @must @planned
Egenskap: Listevisning og søk i personbrukere
  Som brukeradministrator
  ønsker jeg en oversikt over personbrukere jeg har tilgang til, med mulighet for søk og filtrering
  slik at jeg raskt kan finne og følge opp riktig bruker.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen

  Regel: Liste over alle personbrukere

    Scenario: Se liste over personbrukere
      Når jeg åpner brukeroversikten
      Så ser jeg en liste over alle personbrukere
      Og listen er sortert etter navn i stigende rekkefølge
      Og hvert innslag viser følgende informasjon:
        | felt             |
        | Navn             |
        | Feide-ID         |
        | Hjemorganisasjon |
        | Status           |

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

  Regel: Tie-break ved sortering

    Scenario: Navn er tie-break når to personbrukere har lik verdi i sorteringsfeltet
      Gitt jeg sorterer listen over personbrukere på et felt som ikke er navn
      Når to eller flere personbrukere har lik verdi i sorteringsfeltet
      Så sorteres de innbyrdes alfabetisk på navn i stigende rekkefølge

    Scenario: Feide-ID er tie-break når navn er likt
      Gitt jeg sorterer listen over personbrukere
      Når to eller flere personbrukere har likt navn
      Så sorteres de innbyrdes alfabetisk på Feide-ID i stigende rekkefølge

  Regel: Søk og filtrering av personbrukere

    Scenario: Fritekst-søk på navn
      Gitt jeg ser listen over personbrukere
      Når jeg søker med fritekst på navn
      Så filtreres listen til personbrukere der navn inneholder søketeksten

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

    Scenario: Kombinere søk og filtre
      Gitt jeg ser listen over personbrukere
      Når jeg kombinerer søk i navn- og Feide-ID-feltene med ett eller flere filter
      Så vises kun personbrukere som matcher alle kriteriene

  Regel: Synlighet via administrasjonsrettigheter

    Scenario: Brukeradministrator ser personbrukere med hjemorganisasjon i egne organisasjoner
      Gitt jeg har brukeradministrator-rollen for én eller flere organisasjoner
      Og en personbruker har hjemorganisasjon i en av dem
      Når jeg åpner brukeroversikten
      Så ser jeg personbrukeren i listen
      Og jeg ser personbrukeren uavhengig av hvilket miljø administrasjonsrettigheten min gjelder for

    Scenario: Brukeradministrator ser personbrukere med datatilgang fra egne organisasjoner
      Gitt jeg har brukeradministrator-rollen for én eller flere organisasjoner
      Og en personbruker har hjemorganisasjon utenfor de organisasjonene jeg administrerer
      Men personbrukeren har en aktiv tildeling som gir tilgang til data fra en av dem
      Og tildelingen gjelder i et miljø jeg har brukeradministrator-rollen i
      Når jeg åpner brukeroversikten
      Så ser jeg personbrukeren i listen
      Og hjemorganisasjonen som vises er personbrukerens egen, ikke organisasjonen tildelingen gjelder for

    Scenario: Personbrukere uten tilknytning til egne organisasjoner er ikke synlige
      Gitt jeg har brukeradministrator-rollen for én eller flere organisasjoner
      Og en personbruker har hjemorganisasjon utenfor de organisasjonene jeg administrerer
      Og personbrukeren har ingen tildelinger som gir tilgang til data fra dem
      Når jeg åpner brukeroversikten
      Så ser jeg ikke personbrukeren i listen

    Scenario: Personbrukere med kun inaktiv datatilgang fra egne organisasjoner er ikke synlige
      Gitt jeg har brukeradministrator-rollen for én eller flere organisasjoner
      Og en personbruker har hjemorganisasjon utenfor de organisasjonene jeg administrerer
      Og personbrukerens eneste tildeling som gir tilgang til data fra dem er inaktiv
      Når jeg åpner brukeroversikten
      Så ser jeg ikke personbrukeren i listen

    Scenario: Personbrukere med datatilgang i et miljø jeg ikke administrerer er ikke synlige
      Gitt jeg har brukeradministrator-rollen for en organisasjon i ett miljø
      Og en personbruker har hjemorganisasjon utenfor de organisasjonene jeg administrerer
      Og personbrukerens eneste aktive tildeling som gir tilgang til data fra dem gjelder i et annet miljø
      Når jeg åpner brukeroversikten
      Så ser jeg ikke personbrukeren i listen

    Scenario: Super-brukeradministrator ser alle personbrukere
      Gitt jeg har super-brukeradministrator-rollen
      Når jeg åpner brukeroversikten
      Så ser jeg alle personbrukere uavhengig av hjemorganisasjon og tildelinger

  @draft
  Regel: Sist brukt-kolonne og sortering (planlagt etter v1)

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
# - Rolle-navn: "brukeradministrator" og "super-brukeradministrator" er valgt. Sjekk at rolledefinisjonene i "4 - Opprette og administrere roller" bruker samme navn.
# - Brukere uten Feide-ID er nå modellert i egne krav: BRU-PER-GRU-013 (registrere en personbruker uten Feide-konto) og BRU-PER-GRU-014 (forvalte en personbruker uten Feide-konto). De har alltid en hjemorganisasjon, satt eksplisitt ved registrering, og følger synlighetsreglene over uendret.
# - Gjenstår: skal brukere med flere identiteter modelleres her, eller i et eget krav?
