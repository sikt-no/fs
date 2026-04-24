# language: no
# GitHub: #438
@BRU-APP-API-001 @must @planned
Egenskap: Listevisning og søk i API-brukere
  Som bruker
  ønsker jeg en oversikt over alle API-brukere med mulighet for søk og filtrering
  slik at jeg raskt kan finne og følge opp riktig API-bruker.

  # Krav fra Confluence: K1 Liste over alle API-brukere, K2 Søk og filtrering

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
