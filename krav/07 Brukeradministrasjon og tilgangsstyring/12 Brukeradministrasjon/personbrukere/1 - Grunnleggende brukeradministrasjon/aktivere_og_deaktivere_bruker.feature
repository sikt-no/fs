# language: no
# GitHub: #482
# Kilde: Brukerhistorie BH2 (temp/brukerhistorier.md)
@BRU-PER-GRU-004 @draft
Egenskap: Aktivere og deaktivere en Feide-brukers samlede tilganger
  Som brukeradministrator
  ønsker jeg å deaktivere og senere reaktivere en Feide-bruker sine samlede tilganger og roller
  slik at brukeren ikke har tilgang på FS-data i deaktivert tilstand, uten at jeg må fjerne tilgangene enkeltvis.

  Scenario: Deaktivere en brukers samlede tilganger
    Gitt at en bruker har flere aktive tilganger og roller
    Når brukeradministrator deaktiverer brukeren
    Så skal alle brukerens tilganger og roller bli inaktive
    Og brukeren skal ikke kunne nå FS-data ved neste innloggingsforsøk
    Og tilstanden skal være sporbar i historikk

  Scenario: Reaktivere en deaktivert bruker
    Gitt at en bruker er deaktivert
    Når brukeradministrator reaktiverer brukeren
    Så skal de tidligere tildelte tilgangene være aktive igjen
    Og endringen skal være sporbar i historikk

# ÅPNE SPØRSMÅL:
# - Skiller deaktivering seg fra det å fjerne alle tilganger? (sannsynligvis ja — tildelingene beholdes, bare frosset)
# - Hva er forskjellen på "deaktivert av administrator" og "automatisk deaktivert ved stillingsslutt" (BRU-PER-ETT-005)?
# - Skal aktive sesjoner termineres umiddelbart ved deaktivering, eller utløpe naturlig?
# - Skal det være en grunn-/notat-felt ved deaktivering for sporbarhet?
# - Skal det være tidsbegrenset deaktivering (suspender til dato)?
