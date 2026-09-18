# language: no
# GitHub: TBD
@BRU-PER-GRU-007 @must @planned
Egenskap: Se detaljer for personbruker
  Som brukeradministrator
  ønsker jeg å se detaljer for en personbruker, organisert i logiske datagrupper,
  slik at jeg har oversikt over personbrukeren.

  Hjemorganisasjonen er organisasjonen personbrukeren hører hjemme i, hentet fra Feide, og
  den er personbrukerens ansettelsesrelasjon. Den er noe annet enn organisasjonen en tildeling
  gjelder for: en personbruker har én hjemorganisasjon, men kan ha tildelinger ved flere
  organisasjoner. Hjemorganisasjonen kan ikke endres — bytter en person arbeidssted, slettes
  personbrukeren og opprettes på nytt med ny Feide-ID og ny hjemorganisasjon.

  Bakgrunn:
    Gitt jeg er på detaljsiden for en personbruker

  Regel: Detaljer organiseres i logiske datagrupper

    Scenario: Se navn
      Så ser jeg personbrukerens navn

    Scenario: Se Feide-ID
      Så ser jeg personbrukerens Feide-ID

    Scenario: Se hjemorganisasjon
      Så ser jeg personbrukerens hjemorganisasjon

    Scenario: Se status
      Så ser jeg om personbrukeren er aktiv eller deaktivert

  @draft
  Regel: Sist brukt (planlagt etter v1)

    Scenario: Se sist brukt
      Så ser jeg tidspunktet personbrukeren sist brukte løsningen

# ÅPNE SPØRSMÅL:
# - Hva vises når personbrukeren ikke har en hjemorganisasjon i Feide, eller når hjemorganisasjonen ikke finnes som organisasjon i FS? Henger sammen med det åpne spørsmålet i BRU-PER-GRU-001 om brukere uten Feide-ID eller med flere identiteter. Spørsmålet er skarpere nå som hjemorganisasjon bærer ansettelsesrelasjonen: en bruker uten hjemorganisasjon har heller ingen stilling som kan opphøre.
