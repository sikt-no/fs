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
        | Status        |
        | Organisasjon  |
        | Tildelt av    |
        | Tildelt dato  |

    Scenario: Se brukerens tilganger
      Når jeg ser på personbrukerens detaljside
      Så ser jeg en seksjon med personbrukerens tildelte tilganger
      Og hver tilgang viser følgende informasjon:
        | felt          |
        | Navn          |
        | Status        |
        | Organisasjon  |
        | Tildelt av    |
        | Tildelt dato  |

    Scenario: Se tidsbegrensning på en tildeling
      Gitt personbrukeren har en tilgang eller rolle med start- og/eller sluttidspunkt
      Når jeg ser på personbrukerens detaljside
      Så ser jeg gyldighetstidsrommet for tildelingen

    Scenario: Se stedkoder på en tildeling
      Gitt personbrukeren har en tilgang eller rolle som er begrenset til bestemte stedkoder
      Når jeg ser på personbrukerens detaljside
      Så ser jeg hvilke stedkoder tildelingen gjelder for

    Scenario: Skille mellom aktive og inaktive tildelinger
      Når jeg ser på personbrukerens detaljside
      Så ser jeg tydelig hvilke tildelinger som er aktive og hvilke som er inaktive

# ÅPNE SPØRSMÅL:
# - Skal direkte tildelte tilganger skilles fra tilganger som kommer via en rolle, eller presenteres samlet med kilde-merking? Avklares i designfasen.
# - Skal sammensatte roller kunne foldes ut for å vise hvilke tilganger rollen gir, eller henvises administrator til rolle-detaljsiden? Henger sammen med beslutningen over.
# - Hvordan skal "inaktiv på grunn av tidsbegrensning" presenteres vs. "deaktivert av administrator" — to separate statuser, eller én felles "Inaktiv" med årsaks-tekst? Avklares i designfasen.
# - Skal listen være sorterbar/filtrerbar (per organisasjon, status, kilde)? Hvis ja, bør den følge listevisning-mønsteret med eget krav.
# - Skal stedkode-visningen folde ut hierarkiet, eller liste enkeltkoder?