# language: no
# GitHub: #446
@BRU-APP-API-009 @must @planned
Egenskap: Opprette applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å opprette en ny applikasjon
  slik at nye integrasjoner kan konfigureres.

  # Krav fra Confluence: K8 Opprette ny API-bruker

  Regel: Opprettelse krever navn og organisasjon for en vanlig applikasjonsadministrator

    Scenario: Opprette applikasjon når administrator har tilgang til kun én organisasjon
      Gitt jeg har tilgang til kun én organisasjon
      Når jeg oppretter en ny applikasjon med et navn
      Så er applikasjonen opprettet med det valgte navnet og min organisasjon

    Scenario: Opprette applikasjon når administrator har tilgang til flere organisasjoner
      Gitt jeg har tilgang til flere organisasjoner
      Når jeg oppretter en ny applikasjon med et navn og velger en av mine organisasjoner
      Så er applikasjonen opprettet med det valgte navnet og den valgte organisasjonen

  Regel: Super-applikasjonsadministrator kan opprette applikasjon uten organisasjon

    Scenario: Opprette applikasjon uten organisasjon
      Gitt jeg har super-applikasjonsadministrator-rollen
      Når jeg oppretter en ny applikasjon med et navn og uten å velge en organisasjon
      Så er applikasjonen opprettet uten organisasjon
      Og applikasjonen kan kun administreres av andre super-applikasjonsadministratorer

  Regel: Nyopprettet applikasjon kan ikke brukes før passord er satt og rolle er tildelt

    Scenario: Nyopprettet applikasjon har ikke passord
      Gitt jeg har opprettet en ny applikasjon
      Så har applikasjonen ikke satt passord
      Og applikasjonen kan ikke benyttes til autentisering før passord settes via passordbytte

    Scenario: Nyopprettet applikasjon er ikke aktiv i noen miljøer
      Gitt jeg har opprettet en ny applikasjon
      Så er applikasjonen ikke aktiv i noen miljøer
      Og applikasjonen blir først aktiv i et miljø når den får tildelt sin første rolle i det miljøet

  @openquestion
  Scenario: AVKLAR status på nyopprettet applikasjon uten passord og roller
    # ÅPNE SPØRSMÅL:
    # - Skal en nyopprettet applikasjon vises som "ikke aktiv" (eller tilsvarende
    #   status) i lista og på detaljsiden inntil den har fått passord og/eller
    #   sin første rolle, eller må den aktiveres eksplisitt?
    # - Hvordan forholder dette seg til "Deaktivere applikasjon" (K9)?
    #   Er "nyopprettet uten passord/roller" og "deaktivert" samme tilstand,
    #   eller to distinkte tilstander?
    Gitt spørsmålet er åpent
