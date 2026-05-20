# language: no
# GitHub: #438, #448, #449
@BRU-APP-API-001 @must @planned
Egenskap: Listevisning og søk i applikasjoner
  Som bruker
  ønsker jeg en oversikt over applikasjoner jeg har tilgang til, med mulighet for søk og filtrering
  slik at jeg raskt kan finne og følge opp riktig applikasjon.

  # Krav fra Confluence: K1 Liste over alle API-brukere, K2 Søk og filtrering, K11 Oversikt over egne API-brukere, K12 Se API-brukere med tilgang til lærestedets data

  Bakgrunn:
    Gitt jeg er innlogget i løsningen

  Regel: Liste over alle applikasjoner (K1)

    Scenario: Se liste over applikasjoner
      Når jeg åpner applikasjonsoversikten
      Så ser jeg en liste over alle applikasjoner
      Og listen er sortert etter navn i stigende rekkefølge
      Og hvert innslag viser følgende informasjon:
        | felt            |
        | Navn            |
        | Beskrivelse     |
        | Miljøer         |
        | Ansvarlig       |
        | Organisasjon    |
        | Antall tilganger|
        | Status          |

    Scenariomal: Velge sorteringsretning for navn
      Gitt jeg ser listen over applikasjoner
      Når jeg velger å sortere på navn i <retning> rekkefølge
      Så vises applikasjonene sortert etter navn i <retning> rekkefølge

      Eksempler:
        | retning  |
        | stigende |
        | synkende |

    Scenario: Liste viser de 50 første applikasjonene
      Når jeg åpner applikasjonsoversikten
      Så ser jeg totalt antall treff og antall som er lastet
      Og listen viser de 50 første applikasjonene

    Scenario: Laste inn 50 flere applikasjoner
      Gitt jeg ser listen over applikasjoner
      Og det finnes flere applikasjoner enn det som er lastet inn
      Når jeg velger å laste inn flere
      Så lastes de neste 50 applikasjonene inn i listen

    Scenario: Alle applikasjoner er lastet inn
      Gitt jeg ser listen over applikasjoner
      Og alle applikasjoner er lastet inn
      Så er muligheten til å laste inn flere ikke tilgjengelig

    Scenario: Navigere til detaljside for applikasjon
      Gitt jeg ser listen over applikasjoner
      Når jeg velger en applikasjon
      Så ser jeg detaljsiden for valgt applikasjon

    Scenario: Listen inkluderer eksisterende FS-applikasjoner
      Når jeg åpner applikasjonsoversikten
      Så ser jeg også applikasjoner med FS som identitetsleverandør
      Og disse vises på lik linje med Feide- og Maskinporten-applikasjoner

  Regel: Søk og filtrering av applikasjoner (K2)

    Scenario: Fritekst-søk på navn
      Gitt jeg ser listen over applikasjoner
      Når jeg søker med fritekst på navn
      Så filtreres listen til applikasjoner som matcher søket

    Scenario: Filtrere på miljø
      Gitt jeg ser listen over applikasjoner
      Når jeg velger et miljø som filter
      Så vises kun applikasjoner som er aktive i det valgte miljøet

    Scenario: Filtrere på organisasjon
      Gitt jeg ser listen over applikasjoner
      Når jeg velger en organisasjon som filter
      Så vises kun applikasjoner tilknyttet valgt organisasjon

    @could
    Scenario: Filtrere på tilgang
      Gitt jeg ser listen over applikasjoner
      Når jeg velger en tilgang som filter
      Så vises kun applikasjoner som har den valgte tilgangen

    Scenario: Filtrere på status
      Gitt jeg ser listen over applikasjoner
      Når jeg velger en status som filter
      Så vises kun applikasjoner med valgt status

    Scenario: Kombinere filtre
      Gitt jeg ser listen over applikasjoner
      Når jeg kombinerer fritekst-søk med ett eller flere filter
      Så vises kun applikasjoner som matcher alle kriteriene

  Regel: Synlighet via administrasjonsrettigheter (K11, K12)

    Scenario: Applikasjonsadministrator ser applikasjoner fra egne organisasjoner
      Gitt jeg har applikasjonsadministrator-rollen for én eller flere organisasjoner
      Når jeg åpner applikasjonsoversikten
      Så ser jeg applikasjoner tilknyttet de organisasjonene jeg administrerer

    Scenario: Applikasjonsadministrator ser også applikasjoner med tilganger i egne organisasjoner
      Gitt jeg har applikasjonsadministrator-rollen for én eller flere organisasjoner
      Og en applikasjon tilhører en annen organisasjon, men har tilganger som gir tilgang til data i en av mine organisasjoner
      Når jeg åpner applikasjonsoversikten
      Så ser jeg denne applikasjonen i listen
      Og det fremgår hvilken organisasjon applikasjonen tilhører

    Scenario: Super-applikasjonsadministrator ser alle applikasjoner
      Gitt jeg har super-applikasjonsadministrator-rollen
      Når jeg åpner applikasjonsoversikten
      Så ser jeg alle applikasjoner uavhengig av organisasjon
      Og jeg ser også applikasjoner som ikke er tilknyttet noen organisasjon

  Regel: Synlighet via ansvarlig-relasjon

    Scenario: Bruker som er registrert som ansvarlig ser applikasjonen
      Gitt jeg er registrert som ansvarlig for en applikasjon
      Og jeg har ikke applikasjonsadministrator-rollen for organisasjonen applikasjonen tilhører
      Når jeg åpner applikasjonsoversikten
      Så ser jeg applikasjonen i listen
      Og det fremgår hvilken organisasjon applikasjonen tilhører

    @could
    Scenario: Bruker som er ansvarlig via feide-gruppe ser applikasjonen
      Gitt jeg er medlem av en feide-gruppe som er registrert som ansvarlig for en applikasjon
      Og jeg har ikke applikasjonsadministrator-rollen for organisasjonen applikasjonen tilhører
      Når jeg åpner applikasjonsoversikten
      Så ser jeg applikasjonen i listen
      Og det fremgår hvilken organisasjon applikasjonen tilhører
