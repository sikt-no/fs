# language: no
# GitHub: #216
@OPT-PLA-RUN-002 @must @draft @scope-plasstildeling-2027 @depends-on-OPT-PLA-RUN-001
Egenskap: Listevisning og søk i plasstildelingsrunder
  Som opptaksforvalter
  ønsker jeg en oversikt over plasstildelingsrundene i opptaket, med mulighet for søk og filtrering
  slik at jeg raskt kan finne og følge opp riktig plasstildelingsrunde.

  # Kilde: produkteier 2026-11-04. Oversikten viser perioden for å endre antall tilbud, svarfristen for søkerne,
  # om plasstildelingsrunden er publisert, og om lærestedet har en oppgave i runden.
  # Plasstildelingsrundene, perioden, svarfristen, statusen og lærestedets oppgave står i forvalte_runder.feature.
  # Opptakets forvalter og lærestedene ser alle plasstildelingsrundene i opptaket (forvalte_runder.feature), så
  # oversikten har ingen egen regel for synlighet. Hvilke runder lærestedet kan åpne, står også der.

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at opptaket "Samordna opptak 2027" har plasstildelingsrundene "Hovedrunde", "Supplering 1" og "Etterfylling 1"

  Regel: Liste over alle plasstildelingsrunder

    # AVKLART 2026-11-04 (produkteier): Listen er sortert etter svarfristen, tidligste først, når oversikten åpnes,
    # og kan sorteres på svarfristen, statusen for publisering og perioden for å endre antall tilbud. Statusene
    # sorteres i rekkefølgen i filteret. Listen viser 50 plasstildelingsrunder om gangen, som mønsteret.
    # Opptakets forvalter og lærestedene ser oppgaven for lærestedet.
    Scenario: Se liste over plasstildelingsrunder
      Når opptaksforvalter åpner oversikten over plasstildelingsrunder
      Så ser opptaksforvalter disse opplysningene for hver plasstildelingsrunde
        | felt                                |
        | Navn                                |
        | Rundetype                           |
        | Periode for å endre antall tilbud   |
        | Svarfrist for søkere                |
        | Status                              |
        | Oppgave for lærestedet              |

    Scenario: Opptakets forvalter ser oppgaven for lærestedet
      Gitt at perioden for å endre antall tilbud som skal gis er åpen i plasstildelingsrunden "Supplering 1"
      Når opptaksforvalter ved organisasjonen som forvalter opptaket, åpner oversikten over plasstildelingsrunder
      Så ser opptaksforvalter oppgaven "Gå gjennom antall tilbud" for plasstildelingsrunden "Supplering 1"

    Scenario: Listen er sortert etter svarfristen
      Gitt at plasstildelingsrunden "Hovedrunde" har svarfrist "2027-07-20 23:59"
      Og at plasstildelingsrunden "Supplering 1" har svarfrist "2027-08-10 23:59"
      Når opptaksforvalter åpner oversikten over plasstildelingsrunder
      Så vises plasstildelingsrundene sortert etter svarfrist for søkere i stigende rekkefølge

    Scenariomal: Velge sorteringsretning for <felt>
      Gitt at opptaksforvalter ser listen over plasstildelingsrunder
      Når opptaksforvalter velger å sortere på <felt> i <retning> rekkefølge
      Så vises plasstildelingsrundene sortert etter <felt> i <retning> rekkefølge

      Eksempler:
        | felt                              | retning  |
        | svarfrist for søkere              | stigende |
        | svarfrist for søkere              | synkende |
        | status                            | stigende |
        | status                            | synkende |
        | periode for å endre antall tilbud | stigende |
        | periode for å endre antall tilbud | synkende |

    Scenario: Liste viser de 50 første plasstildelingsrunder
      Gitt at opptaket har 60 plasstildelingsrunder
      Når opptaksforvalter åpner oversikten over plasstildelingsrunder
      Så ser opptaksforvalter totalt antall treff og antall som er lastet
      Og listen viser de 50 første plasstildelingsrundene

    Scenario: Laste inn 50 flere plasstildelingsrunder
      Gitt at opptaket har 120 plasstildelingsrunder
      Og at opptaksforvalter ser listen over plasstildelingsrunder
      Når opptaksforvalter velger å laste inn flere
      Så lastes de neste 50 plasstildelingsrundene inn i listen

    Scenario: Alle plasstildelingsrunder er lastet inn
      Gitt at alle plasstildelingsrundene i opptaket er lastet inn i listen
      Så er muligheten til å laste inn flere ikke tilgjengelig

    Scenario: Navigere til detaljside for plasstildelingsrunde
      Gitt at opptaksforvalter ser listen over plasstildelingsrunder
      Når opptaksforvalter velger plasstildelingsrunden "Supplering 1"
      Så ser opptaksforvalter detaljsiden for plasstildelingsrunden "Supplering 1"

  Regel: Søk og filtrering av plasstildelingsrunder

    Scenario: Fritekst-søk på navn
      Gitt at opptaksforvalter ser listen over plasstildelingsrunder
      Når opptaksforvalter søker med fritekst på navnet "Supplering"
      Så filtreres listen til plasstildelingsrundene som matcher søket

    Scenario: Tilgjengelige rundetyper i filter
      Når opptaksforvalter åpner rundetype-filteret
      Så inneholder filteret rundetypene
        | Rundetype       |
        | Alle rundetyper |
        | Hovedtildeling  |
        | Supplering      |
        | Etterfylling    |
      Og "Alle rundetyper" er valgt som standard

    Scenario: Filtrere på rundetype
      Når opptaksforvalter velger rundetypen "Supplering" som filter
      Så vises bare plasstildelingsrundene med rundetypen "Supplering"

    Scenario: Tilgjengelige statuser i filter
      Når opptaksforvalter åpner status-filteret
      Så inneholder filteret statusene
        | Status               |
        | Alle statuser        |
        | Ikke publisert       |
        | Publisert for søkere |
      Og "Alle statuser" er valgt som standard

    Scenario: Filtrere på status
      Når opptaksforvalter velger statusen "Ikke publisert" som filter
      Så vises bare plasstildelingsrundene som ikke er publisert til søker

    Scenario: Tilgjengelige perioder i filter
      Når opptaksforvalter åpner periode-filteret
      Så inneholder filteret periodene for å endre antall tilbud
        | Periode        |
        | Alle perioder  |
        | Ikke satt      |
        | Åpner          |
        | Åpen           |
        | Utløpt         |
      Og "Alle perioder" er valgt som standard

    Scenario: Filtrere på periode
      Når opptaksforvalter velger perioden "Åpen" som filter
      Så vises bare plasstildelingsrundene der perioden for å endre antall tilbud er åpen

    Scenario: Kombinere filtre
      Når opptaksforvalter kombinerer fritekst-søk med ett eller flere filter
      Så vises bare plasstildelingsrundene som matcher alle kriteriene
