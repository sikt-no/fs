# language: no
# GitHub: #438, #448, #449
@BRU-APP-API-001 @must @planned
Egenskap: Listevisning og søk i API-brukere
  Som bruker
  ønsker jeg en oversikt over API-brukere jeg har tilgang til, med mulighet for søk og filtrering
  slik at jeg raskt kan finne og følge opp riktig API-bruker.

  # Krav fra Confluence: K1 Liste over alle API-brukere, K2 Søk og filtrering, K11 Oversikt over egne API-brukere, K12 Se API-brukere med tilgang til lærestedets data

  Bakgrunn:
    Gitt jeg er innlogget i løsningen

  Regel: Liste over alle API-brukere (K1)

    Scenario: Se liste over API-brukere
      Når jeg åpner API-brukeroversikten
      Så ser jeg en liste over alle API-brukere
      Og listen er sortert etter navn i stigende rekkefølge
      Og hvert innslag viser følgende informasjon:
        | felt                |
        | Navn                |
        | Beskrivelse         |
        | Miljøer             |
        | Ansvarlig           |
        | Organisasjon        |
        | Type API-bruker     |
        | Oppfølgningsstatus  |

    Scenario: Liste viser de 50 første API-brukerne
      Når jeg åpner API-brukeroversikten
      Så ser jeg totalt antall treff og antall som er lastet
      Og listen viser de 50 første API-brukerne

    Scenario: Laste inn 50 flere API-brukere
      Gitt jeg ser listen over API-brukere
      Og det finnes flere API-brukere enn det som er lastet inn
      Når jeg velger å laste inn flere
      Så lastes de neste 50 API-brukerne inn i listen

    Scenario: Alle API-brukere er lastet inn
      Gitt jeg ser listen over API-brukere
      Og alle API-brukere er lastet inn
      Så er muligheten til å laste inn flere ikke tilgjengelig

    Scenario: Navigere til detaljside for API-bruker
      Gitt jeg ser listen over API-brukere
      Når jeg velger en API-bruker
      Så ser jeg detaljsiden for valgt API-bruker

  Regel: Søk og filtrering av API-brukere (K2)

    Scenario: Fritekst-søk på navn
      Gitt jeg ser listen over API-brukere
      Når jeg søker med fritekst på navn
      Så filtreres listen til API-brukere som matcher søket

    Scenario: Filtrere på organisasjon
      Gitt jeg ser listen over API-brukere
      Når jeg velger en organisasjon som filter
      Så vises kun API-brukere tilknyttet valgt organisasjon

    @could
    Scenario: Filtrere på rolle
      Gitt jeg ser listen over API-brukere
      Når jeg velger en rolle som filter
      Så vises kun API-brukere som har den valgte rollen

    Scenario: Kombinere filtre
      Gitt jeg ser listen over API-brukere
      Når jeg kombinerer fritekst-søk med ett eller flere filter
      Så vises kun API-brukere som matcher alle kriteriene

  Regel: Synlighet styres av administrasjonsrettigheter (K11, K12)

    Scenario: Api-brukeradministrator ser API-brukere fra egne organisasjoner
      Gitt jeg har api-brukeradministrator-rollen for én eller flere organisasjoner
      Når jeg åpner API-brukeroversikten
      Så ser jeg API-brukere tilknyttet de organisasjonene jeg administrerer

    Scenario: Api-brukeradministrator ser også API-brukere med roller i egne organisasjoner
      Gitt jeg har api-brukeradministrator-rollen for én eller flere organisasjoner
      Og en API-bruker tilhører en annen organisasjon, men har roller som gir tilgang til data i en av mine organisasjoner
      Når jeg åpner API-brukeroversikten
      Så ser jeg denne API-brukeren i listen
      Og det fremgår hvilken organisasjon API-brukeren tilhører

    Scenario: Api-superbrukeradministrator ser alle API-brukere
      Gitt jeg har api-superbrukeradministrator-rollen
      Når jeg åpner API-brukeroversikten
      Så ser jeg alle API-brukere uavhengig av organisasjon
      Og jeg ser også API-brukere som ikke er tilknyttet noen organisasjon
