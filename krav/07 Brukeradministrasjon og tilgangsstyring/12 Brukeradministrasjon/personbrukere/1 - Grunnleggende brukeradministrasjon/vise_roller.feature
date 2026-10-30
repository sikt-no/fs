# language: no
# GitHub: #480
@BRU-PER-GRU-008 @must @implemented
Egenskap: Se en personbrukers roller
  Som brukeradministrator
  ønsker jeg å se hvilke roller en personbruker har
  slik at jeg har oversikt før jeg gjør endringer.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en personbruker

  Regel: Visning av roller

    @scope-synlighet-og-gjelder-for
    Scenario: Se brukerens roller med «Gjelder for»
      Når jeg ser på personbrukerens detaljside
      Så ser jeg en seksjon med personbrukerens tildelte roller
      Og hver rolle viser følgende informasjon:
        | felt          |
        | Navn          |
        | Beskrivelse   |
        | Gjelder for   |
        | Miljø         |
        | Tildelt av    |
        | Tildelt dato  |

    @draft
    Scenario: Se brukerens roller
      Når jeg ser på personbrukerens detaljside
      Så ser jeg en seksjon med personbrukerens tildelte roller
      Og rollene er sortert etter navn
      Og hver rolle viser følgende informasjon:
        | felt                     |
        | Navn                     |
        | Beskrivelse              |
        | Miljø                    |
        | Gjelder for organisasjon |
        | Tildelt av               |
        | Tildelt dato             |
      Og «Navn» viser rollekoden fra rollekatalogen
      Og «Tildelt av» viser navnet på den som tildelte rollen

    @draft @openquestion
    Scenario: Se tidsbegrensning på en rolle
      # ÅPNE SPØRSMÅL:
      # - Kravspesifiseringen er utsatt. Når skal tidsbegrensning på roller spesifiseres?
      Gitt personbrukeren har en rolle med start- og/eller sluttidspunkt
      Når jeg ser på personbrukerens detaljside
      Så ser jeg gyldighetstidsrommet for rollen

    @draft @openquestion
    Scenario: Se stedkoder på en rolle
      # ÅPNE SPØRSMÅL:
      # - Kravspesifiseringen er utsatt. Når skal stedkoder på roller spesifiseres?
      # - Skal stedkode-visningen folde ut hierarkiet, eller liste enkeltkoder?
      Gitt personbrukeren har en rolle som er begrenset til bestemte stedkoder
      Når jeg ser på personbrukerens detaljside
      Så ser jeg hvilke stedkoder rollen gjelder for

  Regel: Filtrering av roller

    Scenario: Filtrere på navn
      Når jeg skriver inn tekst i navne-filteret
      Så vises kun roller der navnet inneholder den innskrevne teksten

    Scenario: Tilgjengelige miljøer i filter
      Når jeg åpner miljøfilteret
      Så inneholder filteret alle miljøer som er representert i den ufiltrerte listen
      Og hvert miljø vises kun én gang
      Og miljøene er sortert alfabetisk
      Og "Alle miljøer" er valgt som standard

    Scenario: Filtrere på miljø
      Når jeg velger et miljø som filter
      Så vises kun roller i det valgte miljøet

    Scenario: Tilgjengelige organisasjoner i filter
      Når jeg åpner filteret «Gjelder for organisasjon»
      Så inneholder filteret alle organisasjoner som er representert i den ufiltrerte listen
      Og hver organisasjon vises kun én gang
      Og organisasjonene er sortert alfabetisk
      Og "Alle organisasjoner" er valgt som standard

    Scenario: Filtrere på organisasjon
      Når jeg velger en organisasjon i filteret «Gjelder for organisasjon»
      Så vises kun roller knyttet til den valgte organisasjonen

    @planned @scope-restanser-etter-onboarding
    Scenario: Organisasjonene i filteret vises med akronym
      Når jeg åpner filteret «Gjelder for organisasjon»
      Så vises akronymet under navnet på hver organisasjon
      Men organisasjonskoden vises når organisasjonen ikke har akronym

    @planned @scope-restanser-etter-onboarding
    Scenario: Søke i organisasjonsfilteret
      Når jeg skriver inn tekst i filteret «Gjelder for organisasjon»
      Så viser filteret bare organisasjonene der navnet eller akronymet inneholder den innskrevne teksten

    Scenario: Kombinere filtre
      Når jeg kombinerer flere filtre
      Så vises kun roller som matcher alle kriteriene

# ÅPNE SPØRSMÅL:
# - Skal sammensatte roller kunne foldes ut for å vise hvilke tilganger rollen gir, eller henvises administrator til rolle-detaljsiden?
# - Skal listen også kunne sorteres på organisasjon eller tildelt dato? Skissen viser sortering på navn, og det står i «Se brukerens roller».
