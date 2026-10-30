# language: no
# GitHub: #482
@BRU-PER-GRU-004 @must @deprecated
Egenskap: Aktivere og deaktivere en personbrukers samlede tilganger
  Som brukeradministrator
  ønsker jeg å deaktivere og senere reaktivere en personbrukers samlede tilganger og roller
  slik at personbrukeren ikke har tilgang på FS-data i deaktivert tilstand, uten at jeg må fjerne tildelingene enkeltvis.

  Status, aktivering og deaktivering av brukere avvikles, for både personbrukere og Feide-brukere (beslutning 26.10.2026).

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
      Og det lagres når deaktiveringen skjedde og hvem som gjorde den

    Scenario: Reaktivere en deaktivert personbruker
      Gitt en personbruker er deaktivert
      Når jeg reaktiverer personbrukeren
      Så blir personbrukerens status «Aktiv»
      Og de tidligere tildelte tilgangene og rollene blir aktive igjen
      Og tildelinger som hadde utløpt på grunn av tidsbegrensning før deaktiveringen, blir ikke automatisk aktive

  Regel: Skille mellom deaktivering og fjerning

    Scenario: Deaktivering skiller seg fra fjerning av tildelinger
      Gitt jeg står på detaljsiden for en personbruker med aktive tildelinger
      Når jeg deaktiverer personbrukeren i stedet for å fjerne tildelingene enkeltvis
      Så beholdes alle tildelingene knyttet til personbrukeren
      Og tildelingene blir aktive igjen ved reaktivering uten at jeg må tildele dem på nytt
