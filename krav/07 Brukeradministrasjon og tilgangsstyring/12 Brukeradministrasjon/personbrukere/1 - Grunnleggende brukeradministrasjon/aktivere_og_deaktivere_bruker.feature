# language: no
# GitHub: #482
@BRU-PER-GRU-004 @must @implemented
Egenskap: Aktivere og deaktivere en personbrukers samlede tilganger
  Som brukeradministrator
  ønsker jeg å deaktivere og senere reaktivere en personbrukers samlede tilganger og roller
  slik at personbrukeren ikke har tilgang på FS-data i deaktivert tilstand, uten at jeg må fjerne tildelingene enkeltvis.

  En personbruker har ingen status og kan ikke deaktiveres (beslutning 23.10.2026).
  Reglene om deaktivering og reaktivering ble skrevet for Feide-brukere, og gjelder bare dem.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en personbruker

  @planned
  Regel: En personbruker kan ikke deaktiveres

    Scenario: Personbrukeren kan ikke deaktiveres
      Så kan jeg ikke deaktivere personbrukeren

  @openquestion
  Regel: Deaktivering fryser tildelingene
    # ÅPNE SPØRSMÅL:
    # - Regelen gjelder bare Feide-brukere, siden en personbruker ikke kan deaktiveres. Skal Feide-brukere fortsatt kunne deaktiveres, når tilgang gis til personen og ikke til Feide-brukeren?

    Scenario: Deaktivere en personbruker med aktive tildelinger
      Gitt personbrukeren har flere aktive tilganger og roller
      Når jeg deaktiverer personbrukeren
      Så blir personbrukerens status «Deaktivert»
      Og alle personbrukerens tildelinger blir inaktive
      Og tildelingene beholdes — de fjernes ikke
      Og personbrukeren kan ikke nå FS-data ved neste innloggingsforsøk
      Og det lagres når deaktiveringen skjedde og hvem som gjorde den

    @planned @scope-grunnleggende-brukeradministrasjon
    Scenario: Reaktivere en deaktivert personbruker
      Gitt en personbruker er deaktivert
      Når jeg reaktiverer personbrukeren
      Så blir personbrukerens status «Aktiv»
      Og de tidligere tildelte tilgangene og rollene blir aktive igjen
      Og tildelinger som hadde utløpt på grunn av tidsbegrensning før deaktiveringen, blir ikke automatisk aktive
      Og det lagres når reaktiveringen skjedde og hvem som gjorde den
      Og det som ble lagret om den tidligere deaktiveringen, beholdes

  @openquestion
  Regel: Skille mellom deaktivering og fjerning
    # ÅPNE SPØRSMÅL:
    # - Regelen gjelder bare Feide-brukere, siden en personbruker ikke kan deaktiveres. Den avhenger av om Feide-brukere fortsatt skal kunne deaktiveres (se «Deaktivering fryser tildelingene»).

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
# - Hva skjer med Feide-brukere som ikke er koblet til en person: skal de fortsatt kunne deaktiveres?