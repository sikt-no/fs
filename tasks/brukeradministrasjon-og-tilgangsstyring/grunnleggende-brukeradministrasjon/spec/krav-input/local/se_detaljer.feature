# language: no
# GitHub: TBD
@BRU-PER-GRU-007 @must @planned
Egenskap: Se detaljer for personbruker
  Som brukeradministrator
  ønsker jeg å se detaljer for en personbruker, organisert i logiske datagrupper,
  slik at jeg har oversikt over personbrukeren.

  Bakgrunn:
    Gitt jeg er på detaljsiden for en personbruker

  Regel: Detaljer organiseres i logiske datagrupper

    Scenario: Se navn
      Så ser jeg personbrukerens navn

    Scenario: Se Feide-ID
      Så ser jeg personbrukerens Feide-ID

    Scenario: Se organisasjon
      Så ser jeg hvilke organisasjoner personbrukerens tilganger gjelder for

    Scenario: Se status
      Så ser jeg om personbrukeren er aktiv eller deaktivert

  @draft
  Regel: Sist brukt (planlagt etter v1)

    Scenario: Se sist brukt
      Så ser jeg tidspunktet personbrukeren sist brukte løsningen
