# language: no
@OPT-BEH-BEH-001 @skip @opptakspilot @focus
Egenskap: Saksbehandler behandler søknader

    Bakgrunn:
    Gitt administratoren er på hovedsiden til adminflaten
    Og administratoren er en saksbehandler for opptak
    Og administratoren går inn på søknadsbehandlingssiden


  @nih
  Scenario: Saksbehandler finner alle søknader på et opptak
    Når administratoren velger et opptak
    Så skal administratoren se søknaden

  @nih
  Scenario: Saksbehandler kan se kontaktinformasjon til søker
    Og administratoren velger et opptak
    Når administratoren velger en søknad
    Så skal administratoren se kontaktinformasjon om søker

  Scenario: Saksbehandler kan se opplastet dokumentasjon på søknad
    Og administratoren velger et opptak
    Når administratoren velger en søknad
    Så skal administrator få se opplastet dokumentasjon på søknaden
    # Så skal administrator kunne åpne dokumentasjonen på søknaden
    # Vi er usikre på om dokumentasjon er/bør være knyttet til søknad eller person

  Scenario: Saksbehandler kan se laste opp dokumentasjon på vegne av søker
  Gitt adminstratoren er inne på en søknad
  Når administratoren laster opp et nytt dokument knyttet til søknaden
  Så skal personenen se dette hvis de går inn på Mine Søknader

  Scenario: Saksbehandler kan se søkers resultater og kvalifikasjoner
    Og administratoren velger et opptak
    Når administratoren velger en søknad
    Så skal administrator se resultater fra videregående skole
    Så skal administrator se resultater fra høyere utdanning

  @nih
  Scenario: Saksbehandler kan manuelt angi at søker er kvalifisert for de kravelementene i det opptaket de har søkt på
    Og administratoren velger et opptak
    Og administratoren velger en søknad
    Når saksbehandler velger å manuelt angi at en søker er kvalifisert
    Så blir personen kvalifisert for utdanningstilbudet og kan se at søknaden er behandlet

  @nih
  Scenario: Saksbehandler kan manuelt angi at søker IKKE er kvalifisert de kravelementene i det opptaket de har søkt på
    Og administratoren velger et opptak
    Og administratoren velger en søknad
    Når saksbehandler velger å manuelt angi at en søker IKKE er kvalifisert
    Så blir søkeren IKKE kvalifisert for utdanningstilbudet

  Scenario: Saksbehandler kan manuelt angi poeng til beregning for rangeringsgrunnlag
    Og administratoren velger et opptak
    Og administratoren velger en søknad
    Når saksbehandler manuelt angir poeng for rangeringsgrunnlag
    Så skal poengene lagres med søknaden og bli synlig i listen over søknader i opptaket

  Scenario: Saksbehandler kan angi kvoteplassering (hvis det foreligger dokumentasjon)

  Scenario: Saksbehandler har oversikt over kvalifiserte og ikke kvalifiserte søkere (MVP)

  Scenario: Saksbehandlere kan se oversikt over søkere som har tilbudsgaranti

  Scenario: Søknadsbehandler skal kunne sette grunnlag basert på hvilke grunnlag som er relevant for alle utdanningstilbudene søknaden gjelder for

