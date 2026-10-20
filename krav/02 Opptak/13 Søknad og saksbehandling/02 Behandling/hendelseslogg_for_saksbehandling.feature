# language: no
@OPT-BEH-BEH-016 @should @draft
Egenskap: Hendelseslogg for saksbehandling
  Som saksbehandler
  ønsker jeg en logg over hvem som har gjort hvilke endringer på søkeren og søknaden, og når
  slik at jeg kan følge opp og etterprøve saksbehandlingen.

  # Kilde: bør-behov fra Politihøgskolen (sporbarhet), se
  # 15 Lærestedsspesifikke behov/01 Politihøgskolen/opptak_ved_politihøgskolen.feature. Antatt et generelt
  # behov i saksbehandlingen, ikke bare for Politihøgskolen.
  # Tilsvarer 11 Opprette og vedlikeholde opptak/06 Hendelseslogg/hendelseslogg.feature, som gjelder
  # endringer på opptaket. Begge bygger på en generell revisjonsmekanisme som gjelder på tvers av FS.
  # Beslektede krav som allerede logger i endringsloggen for saken:
  # - søknadsmangler.feature (saksloggen viser mangler som er registrert og endret)
  # - automatisk_kvoteplassering.feature (endringsloggen viser at maskinbrukeren har plassert søkeren i kvoten)
  #
  # ÅPNE SPØRSMÅL:
  # - Hvilke endringer skal logges: status, kvalifisering, poeng, dokumentasjon, tildeling til saksbehandler?
  # - Er dette den samme endringsloggen for saken som finnes i dag, utvidet, eller en egen logg?
  # - Vises hvem som gjorde endringen som rolle og organisasjon, som i hendelsesloggen for opptak?

  Regel: Saksbehandler kan se hvilke endringer som er gjort på en søker

    Scenario: Saksbehandler ser endringene på søkeren
      Gitt at en annen saksbehandler har endret statusen på søkeren
      Når saksbehandleren åpner søkeren
      Så ser saksbehandleren hvem som endret statusen, og når
