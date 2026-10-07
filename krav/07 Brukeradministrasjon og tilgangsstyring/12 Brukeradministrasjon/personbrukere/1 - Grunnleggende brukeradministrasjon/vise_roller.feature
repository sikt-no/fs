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

    @deprecated
    Scenario: Se brukerens roller
      Når jeg ser på personbrukerens detaljside
      Så ser jeg en seksjon med personbrukerens tildelte roller
      Og hver rolle viser følgende informasjon:
        | felt          |
        | Navn          |
        | Beskrivelse   |
        | Organisasjon  |
        | Miljø         |
        | Tildelt av    |
        | Tildelt dato  |

    @planned
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

    @draft @openquestion
    Scenario: Se hvem som tildelte rollen
      # ÅPNE SPØRSMÅL:
      # - «Tildelt av» viser i dag Feide-ID-en til den som tildelte rollen, og API-et kan bare vise
      #   en Feide-bruker som tildeler. En brukeradministrator som logger inn med ID-porten, har
      #   ingen Feide-ID. Skal «Tildelt av» vise navnet på brukeradministratoren?
      # - Hva vises når rollen ble tildelt før tildelingene ble flyttet fra Feide-brukeren til
      #   personen?
      Gitt rollen ble tildelt av en annen brukeradministrator
      Når brukeradministratoren ser på personbrukerens detaljside
      Så ser brukeradministratoren navnet på brukeradministratoren som tildelte rollen

    @draft @openquestion
    Scenario: Se rollene til en person
      # ÅPNE SPØRSMÅL:
      # - I overgangsperioden kan den samme personen ha roller både som Feide-bruker og som person.
      #   Skal detaljsiden vise begge? Se BRU-PER-GRU-015.
      Gitt brukeradministratoren ser detaljsiden for en person
      Når brukeradministratoren ser på personens roller
      Så ser brukeradministratoren rollene personen er tildelt, med de samme feltene som for øvrige personbrukere

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

    Scenario: Tilgjengelige organisasjoner i filter
      Når jeg åpner organisasjonsfilteret
      Så inneholder filteret alle organisasjoner som er representert i den ufiltrerte listen
      Og hver organisasjon vises kun én gang
      Og organisasjonene er sortert alfabetisk
      Og "Alle organisasjoner" er valgt som standard

    Scenario: Filtrere på organisasjon
      Når jeg velger en organisasjon som filter
      Så vises kun roller knyttet til den valgte organisasjonen

    Scenario: Tilgjengelige miljøer i filter
      Når jeg åpner miljøfilteret
      Så inneholder filteret alle miljøer som er representert i den ufiltrerte listen
      Og hvert miljø vises kun én gang
      Og miljøene er sortert alfabetisk
      Og "Alle miljøer" er valgt som standard

    Scenario: Filtrere på miljø
      Når jeg velger et miljø som filter
      Så vises kun roller i det valgte miljøet

    Scenario: Kombinere filtre
      Når jeg kombinerer flere filtre
      Så vises kun roller som matcher alle kriteriene

# ÅPNE SPØRSMÅL:
# - Skal sammensatte roller kunne foldes ut for å vise hvilke tilganger rollen gir, eller henvises administrator til rolle-detaljsiden?
# - Skal listen være sorterbar (per navn, organisasjon, tildelt dato)?
