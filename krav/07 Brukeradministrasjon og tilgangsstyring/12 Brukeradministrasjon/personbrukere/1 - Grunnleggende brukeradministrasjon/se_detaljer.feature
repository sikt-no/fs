# language: no
# GitHub: TBD
@BRU-PER-GRU-007 @must @implemented
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

    @openquestion
    Scenario: Hjemorganisasjonen er ukjent
      # ÅPNE SPØRSMÅL:
      # - Er hjemorganisasjonen også ukjent for en personbruker som ikke er koblet til noen Feide-bruker?
      # - Hva vises for en personbruker som er koblet til flere Feide-brukere med ulike hjemorganisasjoner?
      Gitt domenet i personbrukerens Feide-ID ikke er registrert på noen organisasjon
      Så ser jeg at personbrukeren ikke har en hjemorganisasjon
      Men organisasjonene personbrukerens tildelinger gjelder for, vises ikke som hjemorganisasjon

    @openquestion
    Scenario: Se status
      # ÅPNE SPØRSMÅL:
      # - En personbruker har ingen status (beslutning 23.10.2026), så scenarioet gjelder bare detaljsiden for en Feide-bruker. Skal den fortsatt vise status? Det avhenger av om Feide-brukere fortsatt skal kunne deaktiveres (BRU-PER-GRU-004).
      Så ser jeg om personbrukeren er aktiv eller deaktivert

    @planned
    Scenario: Personbrukeren har ingen status
      Så ser jeg ingen status for personbrukeren

  @draft @openquestion
  Regel: Sist brukt (planlagt etter v1)
    # ÅPNE SPØRSMÅL:
    # - Backend har ikke støtte for dette: tidspunktet personbrukeren sist brukte løsningen lagres ikke. Hvordan og hvor skal det registreres?

    Scenario: Se sist brukt
      Så ser jeg tidspunktet personbrukeren sist brukte løsningen
