# language: no
# GitHub: #453
@BRU-APP-API-016 @must @draft
Egenskap: Endringslogg for API-bruker
  Som bruker med administrasjonsrettigheter for en API-bruker
  ønsker jeg å se en endringslogg over hvem som har gjort hva på API-brukeren
  slik at jeg kan spore historikken og ha grunnlag for feilsøking og kontroll.

  # Krav fra Confluence: K16 Se endringslogg

  Bakgrunn:
    Gitt jeg er på detaljsiden for en API-bruker

  Regel: Endringsloggen er kun tilgjengelig for brukere med administrasjonsrettigheter

    Scenario: Api-brukeradministrator ser endringslogg for API-brukere i egne organisasjoner
      Gitt jeg har api-brukeradministrator-rollen for organisasjonen API-brukeren tilhører
      Når jeg åpner endringsloggen
      Så ser jeg loggen over endringer på API-brukeren

    Scenario: Endringslogg er ikke tilgjengelig uten administrasjonsrettigheter
      Gitt jeg ikke har administrasjonsrettigheter for API-brukeren
      Så er muligheten til å se endringsloggen ikke tilgjengelig

    Scenario: Api-superbrukeradministrator ser endringslogg for alle API-brukere
      Gitt jeg har api-superbrukeradministrator-rollen
      Når jeg åpner endringsloggen
      Så ser jeg loggen uavhengig av organisasjon

  @openquestion
  Scenario: AVKLAR hvilke handlinger som skal loggføres
    # ÅPNE SPØRSMÅL:
    # - Skal alle administrative handlinger logges (opprettelse, navn/beskrivelse,
    #   ansvarlig, passordbytte, rolle-tilordning/fjerning, deaktivering,
    #   reaktivering, evt. sletting), eller kun de sensitive (passord, roller,
    #   deaktivering)?
    # - Skal autentiseringshistorikk (sist brukt, feilede forsøk) inngå i samme
    #   logg, eller holdes atskilt? (jf. punkt 4 — autentiseringshistorikk)
    Gitt spørsmålet er åpent

  @openquestion
  Scenario: AVKLAR hva en loggpost inneholder
    # ÅPNE SPØRSMÅL:
    # - Skal loggposten kun vise hvem + tidspunkt + type endring, eller også
    #   før/etter-verdier?
    # - Hvis før/etter-verdier: hvordan håndteres sensitive felter (passord)?
    #   Skal disse maskeres, utelates helt, eller logges kun som "passord
    #   endret" uten verdi?
    Gitt spørsmålet er åpent

  @openquestion
  Scenario: AVKLAR retention på endringsloggen
    # ÅPNE SPØRSMÅL:
    # - Hvor lenge beholdes loggen? Evig, tidsbegrenset (1, 2, 5 år), eller
    #   styres av generell plattform-policy for audit-logg?
    # - Hva skjer med loggen hvis API-brukeren slettes permanent?
    Gitt spørsmålet er åpent

  @openquestion
  Scenario: AVKLAR rekkefølge, paginering og filtrering
    # ÅPNE SPØRSMÅL:
    # - Nyeste først er antatt standard. Bekreft.
    # - Trengs paginering ("last inn flere 50 av gangen") som for andre lister,
    #   eller holder en enkel liste?
    # - Skal loggen kunne filtreres på type endring eller person som utførte?
    Gitt spørsmålet er åpent
