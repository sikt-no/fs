# language: no
# GitHub: #447
@BRU-APP-API-010 @must @planned
Egenskap: Deaktivere API-bruker
  Som bruker med api-brukeradministrator-rollen
  ønsker jeg å deaktivere en API-bruker
  slik at en API-bruker som ikke lenger er i bruk ikke kan benyttes.

  # Krav fra Confluence: K9 Deaktivere API-bruker

  Regel: Deaktivering krever bekreftelse og hindrer autentisering

    Scenario: Bekreftelsesdialog vises før deaktivering
      Gitt jeg er på detaljsiden for en aktiv API-bruker jeg kan administrere
      Når jeg velger å deaktivere API-brukeren
      Så vises en bekreftelsesdialog før deaktiveringen gjennomføres

    Scenario: Bekrefte deaktivering
      Gitt jeg har åpnet bekreftelsesdialogen for å deaktivere en API-bruker
      Når jeg bekrefter deaktiveringen
      Så er API-brukeren ikke lenger aktiv
      Og API-brukeren kan ikke benyttes til autentisering

    Scenario: Avbryte deaktivering
      Gitt jeg har åpnet bekreftelsesdialogen for å deaktivere en API-bruker
      Når jeg avbryter
      Så er API-brukeren fortsatt aktiv

  Regel: Deaktivering er reversibel og bevarer rollene

    Scenario: Deaktivert API-bruker beholder sine roller
      Gitt en API-bruker nettopp har blitt deaktivert
      Så er rollene som var tildelt fortsatt knyttet til API-brukeren
      Men rollene gir ikke tilgang så lenge API-brukeren er deaktivert

  Regel: Reaktivering krever bekreftelse og gjenoppretter API-brukerens tilganger

    Scenario: Bekreftelsesdialog vises før reaktivering
      Gitt jeg er på detaljsiden for en deaktivert API-bruker jeg kan administrere
      Når jeg velger å reaktivere API-brukeren
      Så vises en bekreftelsesdialog før reaktiveringen gjennomføres

    Scenario: Bekrefte reaktivering
      Gitt jeg har åpnet bekreftelsesdialogen for å reaktivere en API-bruker
      Når jeg bekrefter reaktiveringen
      Så er API-brukeren aktiv igjen
      Og rollene som var tildelt før deaktivering gir igjen tilgang

  Regel: Rettighet til å deaktivere og reaktivere følger administrasjonsrettighetene

    Scenario: Api-brukeradministrator kan deaktivere API-brukere i egne organisasjoner
      Gitt jeg har api-brukeradministrator-rollen for en organisasjon
      Og API-brukeren tilhører den organisasjonen
      Så har jeg mulighet til å deaktivere og reaktivere API-brukeren

    Scenario: Api-superbrukeradministrator kan deaktivere alle API-brukere
      Gitt jeg har api-superbrukeradministrator-rollen
      Så har jeg mulighet til å deaktivere og reaktivere enhver API-bruker uavhengig av organisasjon
