# language: no
# GitHub: #480
@BRU-PER-GRU-002 @must @planned
Egenskap: Se en personbrukers roller og resulterende tilganger
  Som brukeradministrator
  ønsker jeg å se hvilke roller en personbruker har, og hvilke tilganger rollene gir
  slik at jeg har oversikt før jeg gjør endringer.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en personbruker

  Regel: Visning av roller og resulterende tilganger

    Scenario: Se brukerens roller
      Når jeg ser på personbrukerens detaljside
      Så ser jeg en seksjon med personbrukerens tildelte roller
      Og hver rolle viser følgende informasjon:
        | felt          |
        | Navn          |
        | Organisasjon  |
        | Miljø         |
        | Tildelt av    |
        | Tildelt dato  |

    @draft
    Scenario: Se brukerens tilganger
      Når jeg ser på personbrukerens detaljside
      Så ser jeg en seksjon med tilgangene personbrukeren har gjennom sine roller
      Og hver tilgang viser følgende informasjon:
        | felt          |
        | Navn          |
        | Organisasjon  |
        | Miljø         |
        | Tildelt av    |
        | Tildelt dato  |

    @draft
    Scenario: Se tidsbegrensning på en tildeling
      Gitt personbrukeren har en tilgang eller rolle med start- og/eller sluttidspunkt
      Når jeg ser på personbrukerens detaljside
      Så ser jeg gyldighetstidsrommet for tildelingen

    @draft
    Scenario: Se stedkoder på en tildeling
      Gitt personbrukeren har en tilgang eller rolle som er begrenset til bestemte stedkoder
      Når jeg ser på personbrukerens detaljside
      Så ser jeg hvilke stedkoder tildelingen gjelder for

  Regel: Filtrering av roller og tilganger

    Scenario: Filtrere på navn
      Når jeg skriver inn tekst i navne-filteret
      Så vises kun tildelinger der navnet inneholder den innskrevne teksten

    Scenario: Tilgjengelige organisasjoner i filter
      Når jeg åpner organisasjonsfilteret
      Så inneholder filteret alle organisasjoner som er representert i den ufiltrerte listen
      Og hver organisasjon vises kun én gang
      Og organisasjonene er sortert alfabetisk
      Og "Alle organisasjoner" er valgt som standard

    Scenario: Filtrere på organisasjon
      Når jeg velger en organisasjon som filter
      Så vises kun tildelinger knyttet til den valgte organisasjonen

    Scenario: Tilgjengelige miljøer i filter
      Når jeg åpner miljøfilteret
      Så inneholder filteret alle miljøer som er representert i den ufiltrerte listen
      Og hvert miljø vises kun én gang
      Og miljøene er sortert alfabetisk
      Og "Alle miljøer" er valgt som standard

    Scenario: Filtrere på miljø
      Når jeg velger et miljø som filter
      Så vises kun tildelinger i det valgte miljøet

    Scenario: Kombinere filtre
      Når jeg kombinerer flere filtre
      Så vises kun tildelinger som matcher alle kriteriene

# ÅPNE SPØRSMÅL:
# - Feltlisten for en tilgang har "Tildelt av" og "Tildelt dato". Tilganger tildeles ikke direkte, de følger av en rolle — skal disse feltene erstattes av hvilken rolle tilgangen kommer fra?
# - Skal sammensatte roller kunne foldes ut for å vise hvilke tilganger rollen gir, eller henvises administrator til rolle-detaljsiden?
# - Skal filtrene virke separat på roller-seksjonen og tilganger-seksjonen (hvert sitt filtersett), eller samlet på begge?
# - Skal listen være sorterbar (per organisasjon, navn, tildelt dato)?
# - Skal stedkode-visningen folde ut hierarkiet, eller liste enkeltkoder?