# language: no
# GitHub: #480
@BRU-PER-GRU-002 @must @planned
Egenskap: Se en personbrukers tilganger og roller
  Som brukeradministrator
  ønsker jeg å se hvilke tilganger og roller en personbruker har
  slik at jeg har oversikt før jeg gjør endringer.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en personbruker

  Regel: Visning av tildelte roller og tilganger

    Scenario: Se brukerens roller
      Når jeg ser på personbrukerens detaljside
      Så ser jeg en seksjon med personbrukerens tildelte roller
      Og hver rolle viser følgende informasjon:
        | felt          |
        | Navn          |
        | Organisasjon  |
        | Tildelt av    |
        | Tildelt dato  |

    Scenario: Se brukerens tilganger
      Når jeg ser på personbrukerens detaljside
      Så ser jeg en seksjon med personbrukerens tildelte tilganger
      Og hver tilgang viser følgende informasjon:
        | felt          |
        | Navn          |
        | Organisasjon  |
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

  Regel: Filtrering av tildelte tilganger og roller

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

    Scenario: Kombinere filtre
      Når jeg kombinerer flere filtre
      Så vises kun tildelinger som matcher alle kriteriene

# ÅPNE SPØRSMÅL:
# - Skal direkte tildelte tilganger skilles fra tilganger som kommer via en rolle, eller presenteres samlet med kilde-merking? Avklares i designfasen.
# - Skal sammensatte roller kunne foldes ut for å vise hvilke tilganger rollen gir, eller henvises administrator til rolle-detaljsiden? Henger sammen med beslutningen over.
# - Skal filtrene virke separat på roller-seksjonen og tilganger-seksjonen (hvert sitt filtersett), eller samlet på begge?
# - Skal listen være sorterbar (per organisasjon, navn, tildelt dato)?
# - Skal stedkode-visningen folde ut hierarkiet, eller liste enkeltkoder?