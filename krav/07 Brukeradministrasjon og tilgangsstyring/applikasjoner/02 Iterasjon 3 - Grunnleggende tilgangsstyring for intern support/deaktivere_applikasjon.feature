# language: no
# GitHub: #447
@BRU-APP-API-010 @must @planned
Egenskap: Deaktivere applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å deaktivere en applikasjon
  slik at en applikasjon som ikke lenger er i bruk ikke kan benyttes.

  # Krav fra Confluence: K9 Deaktivere API-bruker

  Regel: Deaktivering krever bekreftelse og hindrer autentisering

    Scenario: Bekreftelsesdialog vises før deaktivering
      Gitt jeg er på detaljsiden for en aktiv applikasjon jeg kan administrere
      Når jeg velger å deaktivere applikasjonen
      Så vises en bekreftelsesdialog før deaktiveringen gjennomføres

    Scenario: Bekrefte deaktivering
      Gitt jeg har åpnet bekreftelsesdialogen for å deaktivere en applikasjon
      Når jeg bekrefter deaktiveringen
      Så er applikasjonen ikke lenger aktiv
      Og applikasjonen kan ikke benyttes til autentisering

    Scenario: Avbryte deaktivering
      Gitt jeg har åpnet bekreftelsesdialogen for å deaktivere en applikasjon
      Når jeg avbryter
      Så er applikasjonen fortsatt aktiv

  Regel: Deaktivering er reversibel og bevarer tilgangene

    Scenario: Deaktivert applikasjon beholder sine tilganger
      Gitt en applikasjon nettopp har blitt deaktivert
      Så er tilgangene som var tildelt fortsatt knyttet til applikasjonen
      Men tilgangene gir ikke faktisk tilgang så lenge applikasjonen er deaktivert

  Regel: Reaktivering krever bekreftelse og gjenoppretter applikasjonens tilganger

    Scenario: Bekreftelsesdialog vises før reaktivering
      Gitt jeg er på detaljsiden for en deaktivert applikasjon jeg kan administrere
      Når jeg velger å reaktivere applikasjonen
      Så vises en bekreftelsesdialog før reaktiveringen gjennomføres

    Scenario: Bekrefte reaktivering
      Gitt jeg har åpnet bekreftelsesdialogen for å reaktivere en applikasjon
      Når jeg bekrefter reaktiveringen
      Så er applikasjonen aktiv igjen
      Og tilgangene som var tildelt før deaktivering gjelder igjen

  Regel: Rettighet til å deaktivere og reaktivere følger administrasjonsrettighetene

    Scenario: Applikasjonsadministrator kan deaktivere applikasjoner i egne organisasjoner
      Gitt jeg har applikasjonsadministrator-rollen for en organisasjon
      Og applikasjonen tilhører den organisasjonen
      Så har jeg mulighet til å deaktivere og reaktivere applikasjonen

    Scenario: Super-applikasjonsadministrator kan deaktivere alle applikasjoner
      Gitt jeg har super-applikasjonsadministrator-rollen
      Så har jeg mulighet til å deaktivere og reaktivere enhver applikasjon uavhengig av organisasjon
