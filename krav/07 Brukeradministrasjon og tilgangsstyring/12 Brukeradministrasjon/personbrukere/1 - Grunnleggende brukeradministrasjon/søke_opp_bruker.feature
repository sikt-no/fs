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
        | felt           |
        | Navn           |
        | Feide-ID       |
        | Organisasjon   |
        | Status         |
        | Sist innlogget |

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

    Scenario: Fritekst-søk på navn og Feide-ID
      Gitt jeg ser listen over personbrukere
      Når jeg søker med fritekst
      Så filtreres listen til personbrukere der navn eller Feide-ID inneholder søketeksten

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

    Scenario: Tilgjengelige organisasjoner i filter
      Gitt jeg ser listen over personbrukere
      Når jeg åpner organisasjonsfilteret
      Så inneholder filteret alle organisasjoner jeg har personadministrator-rollen for
      Og hver organisasjon vises kun én gang
      Og organisasjonene er sortert alfabetisk
      Og "Alle organisasjoner" er valgt som standard

    Scenario: Filtrere på organisasjon
      Gitt jeg ser listen over personbrukere
      Når jeg velger en organisasjon som filter
      Så vises kun personbrukere som har minst én tilgang ved den valgte organisasjonen

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

    Scenario: Kombinere filtre
      Gitt jeg ser listen over personbrukere
      Når jeg kombinerer fritekst-søk med ett eller flere filter
      Så vises kun personbrukere som matcher alle kriteriene

  Regel: Synlighet via administrasjonsrettigheter

    Scenario: Personadministrator ser personbrukere i organisasjoner jeg administrerer
      Gitt jeg har personadministrator-rollen for én eller flere organisasjoner
      Når jeg åpner brukeroversikten
      Så ser jeg personbrukere som har minst én tilgang ved en av de organisasjonene jeg administrerer

    Scenario: Personbruker med tilganger i flere organisasjoner
      Gitt jeg har personadministrator-rollen for organisasjon A
      Og en personbruker har tilganger ved både organisasjon A og organisasjon C
      Når jeg åpner brukeroversikten
      Så ser jeg personbrukeren i listen
      Og det fremgår hvilke organisasjoner personbrukerens tilganger gjelder for

    Scenario: Super-personadministrator ser alle personbrukere
      Gitt jeg har super-personadministrator-rollen
      Når jeg åpner brukeroversikten
      Så ser jeg alle personbrukere uavhengig av organisasjon

# ÅPNE SPØRSMÅL:
# - Filnavn: bør "søke_opp_bruker.feature" omdøpes til "listevisning_og_sok.feature" for konsistens med mønsteret? Tittelendring på #479 må i så fall følges opp via fs-github.
# - Rolle-navn: "personadministrator" / "super-personadministrator" er valgt som arbeids-titler. Bekreft eller justér mot rolledefinisjonene i "4 - Opprette og administrere roller".
# - Skal kant-tilfeller som brukere uten Feide-ID, eller brukere med flere identiteter, modelleres her — eller hører de hjemme i et eget krav?