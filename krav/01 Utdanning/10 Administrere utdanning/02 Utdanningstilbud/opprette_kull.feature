# language: no

@FOR-ADM-TIL-002
Egenskap: Opprette kull
Som studieplanlegger trenger jeg å fortelle fra når i tid en utdanning blir tilbudt til søkere og studenter, og for å kunne følge opp studenter som følger samme studieplan i studieløpet knyttet til et studieprogram, så bruker jeg kull som uttrykk for utdanningsinstansen.

Bakgrunn:
  Gitt at studieplanlegger er logget inn i FS Admin
  Og studieplanlegger har navigert til studieprogramsiden
  Og studieplanlegger har klikket på fanen for kull

@versjon1
  Scenario: Se eksisterende kull
    Når studieplanlegger ser på kull-oversikten
    Så kan studieplanlegger se hvilke kull som er registrert
    Og studieplanlegger kan se kullets startdato
    Og studieplanlegger kan se hvilket campus kullet tilhører

@versjon1
  Scenariomal: Opprette nytt kull
    Gitt at studieprogram "<studieprogram>" er opprettet
    Når studieplanlegger oppretter nytt kull for "<studieprogram>"
    Og studieplanlegger setter startdato til "<startdato>"
    Og studieplanlegger setter campus til "<campus>"
    Så lagres nytt kull i systemet
    Og kullet får tildelt en entydig ID
    Og kullet vises i kull-oversikten

    Eksempler:
    |studieprogram                   |startdato  |campus    |
    |HFB-ANT Antikkens kultur        |2025-08-15 |Bergen    |
    |MPED Pedagogikk                 |2025-01-15 |Oslo      |
    |BIT Informasjonsteknologi       |2025-08-20 |Trondheim |

@versjon1
  Scenario: Opprette kull krever obligatoriske felter
    Gitt at studieplanlegger prøver å opprette nytt kull
    Når studieplanlegger ikke har fylt ut startdato
    Så får studieplanlegger feilmelding "Startdato er påkrevd"
    Og kullet blir ikke opprettet

@versjon1
  Scenario: Opprette kull krever gyldig campus
    Gitt at studieplanlegger prøver å opprette nytt kull
    Når studieplanlegger ikke har fylt ut campus
    Så får studieplanlegger feilmelding "Campus er påkrevd"
    Og kullet blir ikke opprettet

@versjon2
  Scenariomal: Kull knyttes til studieplan
    Gitt at kull "<kull>" er opprettet for studieprogram "<studieprogram>"
    Når studieplanlegger følger opp studenter i kullet
    Så kan studieplanlegger se alle studenter som følger samme studieplan
    Og studieplanlegger kan spore studentenes progresjon i studieløpet

    Eksempler:
    |studieprogram                    |kull                               |
    |HFB-ANT Antikkens kultur        |HFB-ANT Antikkens kultur HØST 2025 |
    |MPED Pedagogikk                 |MPED Pedagogikk VÅR 2025          |