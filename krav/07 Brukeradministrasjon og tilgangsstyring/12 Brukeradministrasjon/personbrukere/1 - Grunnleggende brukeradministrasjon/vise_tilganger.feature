# language: no
# GitHub: #480
@BRU-PER-GRU-002 @must @planned
Egenskap: Se en personbrukers tilganger
  Som brukeradministrator
  ønsker jeg å se hvilke tilganger en personbruker har, og hvor tilgangene kommer fra
  slik at jeg har oversikt før jeg gjør endringer.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en personbruker

  Regel: Visning av tilganger

    Scenario: Se brukerens tilganger
      Når jeg ser på personbrukerens detaljside
      Så ser jeg en seksjon med personbrukerens tilganger
      Og seksjonen inneholder både tilganger som er tildelt direkte og tilganger som følger av personbrukerens roller
      Og hver tilgang viser følgende informasjon:
        | felt          |
        | Navn          |
        | Organisasjon  |
        | Miljø         |
        | Fra rolle     |
        | Tildelt av    |
        | Tildelt dato  |

    Scenario: Se hvilken rolle en tilgang kommer fra
      Gitt personbrukeren har en tilgang som følger av én eller flere roller
      Når jeg ser på personbrukerens detaljside
      Så ser jeg alle rollene tilgangen kommer fra

    Scenario: Se at en tilgang er tildelt direkte
      Gitt personbrukeren har en tilgang som er tildelt direkte
      Når jeg ser på personbrukerens detaljside
      Så ser jeg "Tildelt direkte" som rolle for tilgangen

    Scenario: Se en tilgang som kommer fra flere kilder
      Gitt personbrukeren har en tilgang som både er tildelt direkte og følger av én eller flere roller
      Når jeg ser på personbrukerens detaljside
      Så ser jeg tilgangen én gang
      Og jeg ser alle rollene tilgangen kommer fra, etterfulgt av "Tildelt direkte"

    @draft
    Scenario: Se tidsbegrensning på en tilgang
      Gitt personbrukeren har en tilgang med start- og/eller sluttidspunkt
      Når jeg ser på personbrukerens detaljside
      Så ser jeg gyldighetstidsrommet for tilgangen

    @draft
    Scenario: Se stedkoder på en tilgang
      Gitt personbrukeren har en tilgang som er begrenset til bestemte stedkoder
      Når jeg ser på personbrukerens detaljside
      Så ser jeg hvilke stedkoder tilgangen gjelder for

  Regel: Filtrering av tilganger

    Scenario: Filtrere på navn
      Når jeg skriver inn tekst i navne-filteret
      Så vises kun tilganger der navnet inneholder den innskrevne teksten

    Scenario: Tilgjengelige organisasjoner i filter
      Når jeg åpner organisasjonsfilteret
      Så inneholder filteret alle organisasjoner som er representert i den ufiltrerte listen
      Og hver organisasjon vises kun én gang
      Og organisasjonene er sortert alfabetisk
      Og "Alle organisasjoner" er valgt som standard

    Scenario: Filtrere på organisasjon
      Når jeg velger en organisasjon som filter
      Så vises kun tilganger knyttet til den valgte organisasjonen

    Scenario: Tilgjengelige miljøer i filter
      Når jeg åpner miljøfilteret
      Så inneholder filteret alle miljøer som er representert i den ufiltrerte listen
      Og hvert miljø vises kun én gang
      Og miljøene er sortert alfabetisk
      Og "Alle miljøer" er valgt som standard

    Scenario: Filtrere på miljø
      Når jeg velger et miljø som filter
      Så vises kun tilganger i det valgte miljøet

    Scenario: Kombinere filtre
      Når jeg kombinerer flere filtre
      Så vises kun tilganger som matcher alle kriteriene

# ÅPNE SPØRSMÅL:
# - For en tilgang som følger av en rolle: er "Tildelt av" og "Tildelt dato" den som tildelte rollen og datoen rollen ble tildelt?
# - Skal "Fra rolle" også være et filter, slik at man kan se alle tilganger som kommer fra én bestemt rolle?
# - Skal listen være sorterbar (per navn, organisasjon, tildelt dato)?
# - Skal stedkode-visningen folde ut hierarkiet, eller liste enkeltkoder?
