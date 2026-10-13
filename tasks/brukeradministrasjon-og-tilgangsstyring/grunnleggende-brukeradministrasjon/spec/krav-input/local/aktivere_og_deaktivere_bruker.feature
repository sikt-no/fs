# language: no
# GitHub: #482
@BRU-PER-GRU-004 @must @planned
Egenskap: Aktivere og deaktivere en personbrukers samlede tilganger
  Som brukeradministrator
  ønsker jeg å deaktivere og senere reaktivere en personbrukers samlede tilganger og roller
  slik at personbrukeren ikke har tilgang på FS-data i deaktivert tilstand, uten at jeg må fjerne tildelingene enkeltvis.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en personbruker

  Regel: Deaktivering fryser tildelingene

    Scenario: Deaktivere en personbruker med aktive tildelinger
      Gitt personbrukeren har flere aktive tilganger og roller
      Når jeg deaktiverer personbrukeren
      Så blir personbrukerens status «Deaktivert»
      Og alle personbrukerens tildelinger blir inaktive
      Og tildelingene beholdes — de fjernes ikke
      Og personbrukeren kan ikke nå FS-data ved neste innloggingsforsøk
      Og endringen er sporbar i historikk

    Scenario: Reaktivere en deaktivert personbruker
      Gitt en personbruker er deaktivert
      Når jeg reaktiverer personbrukeren
      Så blir personbrukerens status «Aktiv»
      Og de tidligere tildelte tilgangene og rollene blir aktive igjen
      Og tildelinger som hadde utløpt på grunn av tidsbegrensning før deaktiveringen, blir ikke automatisk aktive
      Og endringen er sporbar i historikk

  Regel: Skille mellom deaktivering og fjerning

    Scenario: Deaktivering skiller seg fra fjerning av tildelinger
      Gitt jeg står på detaljsiden for en personbruker med aktive tildelinger
      Når jeg deaktiverer personbrukeren i stedet for å fjerne tildelingene enkeltvis
      Så beholdes alle tildelingene knyttet til personbrukeren
      Og tildelingene blir aktive igjen ved reaktivering uten at jeg må tildele dem på nytt

# ÅPNE SPØRSMÅL:
# - Skal aktive sesjoner termineres umiddelbart ved deaktivering, eller utløpe naturlig? (Sikkerhetsbeslutning.)
# - Skal det være tidsbegrenset deaktivering (suspender til dato), eller kun manuell reaktivering?
# - Hvordan forholder manuell deaktivering seg til automatisk deaktivering ved stillingsslutt (BRU-PER-ETT-005)? Skal de vises likt i historikk, og kan en automatisk deaktivert bruker reaktiveres manuelt?
# - Skal brukeradministrator varsles når en bruker de har deaktivert prøver å logge inn?