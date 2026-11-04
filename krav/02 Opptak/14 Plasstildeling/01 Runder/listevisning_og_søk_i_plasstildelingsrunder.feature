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

  @openquestion
  Regel: Liste over alle plasstildelingsrunder

    # ÅPNE SPØRSMÅL:
    # - Hvilken rekkefølge har plasstildelingsrundene, og skal listen kunne sorteres? Rekkefølgen de er lagt til i,
    #   eller etter perioden eller svarfristen?
    # - Et opptak har få plasstildelingsrunder. Kan alle vises uten «last inn flere» (mønsteret har 50 per side)?
    # - Ser opptakets forvalter oppgaven til lærestedene i oversikten, eller er den bare for lærestedet?
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
