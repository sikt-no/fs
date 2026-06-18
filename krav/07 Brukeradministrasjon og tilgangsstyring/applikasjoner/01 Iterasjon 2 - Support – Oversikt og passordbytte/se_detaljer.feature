# language: no
# GitHub: #439
@BRU-APP-API-002 @must @planned
Egenskap: Se detaljer for applikasjon
  Som bruker
  ønsker jeg å se detaljer for en applikasjon, organisert i logiske datagrupper,
  slik at jeg har oversikt over applikasjonen.

  # Krav fra Confluence: K3 Se detaljer for API-bruker

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon

  Regel: Detaljer organiseres i logiske datagrupper

    Scenario: Se grunnleggende informasjon
      Så ser jeg navn og beskrivelse

    Scenario: Se identitetsleverandør
      Så ser jeg applikasjonens identitetsleverandør

    Scenario: Se ekstern ID fra identitetsleverandør
      Gitt applikasjonen har en ekstern ID fra identitetsleverandøren
      Så ser jeg den eksterne ID-en

    Scenario: Se intern ID
      Så ser jeg applikasjonens interne ID

    Scenario: Se organisasjon
      Så ser jeg applikasjonens organisasjon

    Scenario: Se sporingsinfo
      Så ser jeg opprettet av, opprettet tidspunkt, endret av og endret tidspunkt

    Scenario: Se miljøer
      Så ser jeg hvilke miljøer applikasjonen er aktiv i

    Scenario: Se status
      Så ser jeg om applikasjonen er aktiv eller deaktivert

  Regel: Detaljer kan redigeres direkte fra detaljer-fanen

    Scenario: Aktivere redigering av detaljer
      Når jeg velger å redigere
      Så blir alle redigerbare felter i detaljer-fanen omgjort til inputfelter
