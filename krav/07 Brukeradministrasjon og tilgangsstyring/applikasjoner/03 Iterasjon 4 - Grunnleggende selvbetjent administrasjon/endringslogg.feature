# language: no
# GitHub: #453
@BRU-APP-API-016 @must @draft
Egenskap: Endringslogg for applikasjon
  Som bruker med administrasjonsrettigheter for en applikasjon
  ønsker jeg å se en endringslogg over hvem som har gjort hva på applikasjonen
  slik at jeg kan spore historikken og ha grunnlag for feilsøking og kontroll.

  # Krav fra Confluence: K16 Se endringslogg

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon

  Regel: Endringsloggen er kun tilgjengelig for brukere med administrasjonsrettigheter

    Scenario: Applikasjonsadministrator ser endringslogg for applikasjoner i egne organisasjoner
      Gitt jeg har applikasjonsadministrator-rollen for organisasjonen applikasjonen tilhører
      Når jeg åpner endringsloggen
      Så ser jeg loggen over endringer på applikasjonen

    Scenario: Endringslogg er ikke tilgjengelig uten administrasjonsrettigheter
      Gitt jeg ikke har administrasjonsrettigheter for applikasjonen
      Så er muligheten til å se endringsloggen ikke tilgjengelig

    Scenario: Super-applikasjonsadministrator ser endringslogg for alle applikasjoner
      Gitt jeg har super-applikasjonsadministrator-rollen
      Når jeg åpner endringsloggen
      Så ser jeg loggen uavhengig av organisasjon

  @openquestion
  Scenario: AVKLAR hvilke handlinger som skal loggføres
    # ÅPNE SPØRSMÅL:
    # - Skal alle administrative handlinger logges (opprettelse, navn/beskrivelse,
    #   passordbytte, tildeling/fjerning av tilgang, deaktivering, reaktivering,
    #   evt. sletting), eller kun de sensitive (passord, tilganger, deaktivering)?
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
    # - Hva skjer med loggen hvis applikasjonen slettes permanent?
    Gitt spørsmålet er åpent

  @openquestion
  Scenario: AVKLAR rekkefølge, paginering og filtrering
    # ÅPNE SPØRSMÅL:
    # - Nyeste først er antatt standard. Bekreft.
    # - Trengs paginering ("last inn flere 50 av gangen") som for andre lister,
    #   eller holder en enkel liste?
    # - Skal loggen kunne filtreres på type endring eller person som utførte?
    Gitt spørsmålet er åpent
