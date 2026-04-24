# language: no
# GitHub: #446
@BRU-APP-API-009 @must @planned
Egenskap: Opprette API-bruker
  Som bruker med api-brukeradministrator-rollen
  ønsker jeg å opprette en ny API-bruker
  slik at nye integrasjoner kan konfigureres.

  # Krav fra Confluence: K8 Opprette ny API-bruker

  Regel: Opprettelse krever navn og organisasjon for en vanlig api-brukeradministrator

    Scenario: Opprette API-bruker når administrator har tilgang til kun én organisasjon
      Gitt jeg har tilgang til kun én organisasjon
      Når jeg oppretter en ny API-bruker med et navn
      Så er API-brukeren opprettet med det valgte navnet og min organisasjon

    Scenario: Opprette API-bruker når administrator har tilgang til flere organisasjoner
      Gitt jeg har tilgang til flere organisasjoner
      Når jeg oppretter en ny API-bruker med et navn og velger en av mine organisasjoner
      Så er API-brukeren opprettet med det valgte navnet og den valgte organisasjonen

  Regel: Api-superbrukeradministrator kan opprette API-bruker uten organisasjon

    Scenario: Opprette API-bruker uten organisasjon
      Gitt jeg har api-superbrukeradministrator-rollen
      Når jeg oppretter en ny API-bruker med et navn og uten å velge en organisasjon
      Så er API-brukeren opprettet uten organisasjon
      Og API-brukeren kan kun administreres av andre api-superbrukeradministratorer

  Regel: Nyopprettet API-bruker kan ikke brukes før passord er satt og rolle er tildelt

    Scenario: Nyopprettet API-bruker har ikke passord
      Gitt jeg har opprettet en ny API-bruker
      Så har API-brukeren ikke satt passord
      Og API-brukeren kan ikke benyttes til autentisering før passord settes via passordbytte

    Scenario: Nyopprettet API-bruker er ikke aktiv i noen miljøer
      Gitt jeg har opprettet en ny API-bruker
      Så er API-brukeren ikke aktiv i noen miljøer
      Og API-brukeren blir først aktiv i et miljø når den får tildelt sin første rolle i det miljøet

  @openquestion
  Scenario: AVKLAR status på nyopprettet API-bruker uten passord og roller
    # ÅPNE SPØRSMÅL:
    # - Skal en nyopprettet API-bruker vises som "ikke aktiv" (eller tilsvarende
    #   status) i lista og på detaljsiden inntil den har fått passord og/eller
    #   sin første rolle, eller må den aktiveres eksplisitt?
    # - Hvordan forholder dette seg til "Deaktivere API-bruker" (K9)?
    #   Er "nyopprettet uten passord/roller" og "deaktivert" samme tilstand,
    #   eller to distinkte tilstander?
    Gitt spørsmålet er åpent
