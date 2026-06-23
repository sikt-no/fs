# language: no
# GitHub: #480
# Kilde: Brukerhistorie BHGB1 (temp/brukerhistorier.md)
@BRU-PER-GRU-002 @draft
Egenskap: Se en brukers tilganger og roller
  Som brukeradministrator
  ønsker jeg å se hvilke tilganger og roller en bruker har
  slik at jeg har oversikt før jeg gjør endringer.

  Scenario: Vise samlet oversikt over brukerens tilganger og roller
    Gitt at brukeradministrator har funnet en bruker
    Når brukeradministrator åpner brukerens detaljside
    Så skal alle tildelte tilganger vises
    Og alle tildelte roller vises
    Og det skal være tydelig hvilke som er aktive og hvilke som er inaktive

  Scenario: Vise stedkoder og tidsbegrensning per tilgang
    Gitt at en bruker har en tilgang med stedkoder og tidsbegrensning
    Når brukeradministrator ser på brukerens tilganger
    Så skal stedkodene være synlige for tilgangen
    Og evt. start- og sluttidspunkt skal være synlige

# ÅPNE SPØRSMÅL:
# - Skal sammensatte roller foldes ut slik at man kan se hvilke tilganger rollen gir?
# - Skal man kunne skille mellom direkte tildelte tilganger og tilganger som kommer via en rolle?
# - Hvordan presenteres en tilgang som er "inaktiv på grunn av tidsbegrensning" vs. "deaktivert av administrator"?
# - Skal listen være sorterbar/filtrerbar (per organisasjon, per type, per kilde)?
# - Skal visning være rolle-først eller tilgang-først som default?
