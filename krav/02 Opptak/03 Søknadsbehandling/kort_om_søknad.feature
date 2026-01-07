# language: no
@skip @søknad @opptak
Egenskap: Kort om søknad
  Som administrator trenger jeg å se en persons søknad for å kunne informere og veilede søkere, og skjerme saksbehandlere i opptak for unødige henvendelser.

  Bakgrunn:
    Gitt administratoren er logget inn
    Gitt at administrator er inne på personsøket

  Scenario: Fanen Søknader er den eneste med informasjon
    Når administrator åpner personprofilen til "Førstegangssøker Søkassen-Grønnskolling"
    Så ser administrator innholdet i fanen søknader

  Scenariomal: Navigere til fanen Søknader (egentlig egen feature for navigasjon rundt personprofilen???)
    Gitt at administrator åpner personprofilen til "<en som allerede er student>"
    Når administrator klikker på "<fanen>"
    Så kommer administrator inn på "<fanen>"
    Eksempler:
    |en som allerede er student|fanen |
    |Astrid Oline Aga          |søknad|

  Scenariomal: Søknadsvisning
    Gitt at administrator er på fanen "søknad"
    Når administrator ser på søknaden til "<søker>"
    Så ser administrator "<navn på opptak>"
    Så ser administrator "<søknadsnummer>"
    #søkernr i FS, sakskode i admissio
    Så ser administrator "<antall valgte utdanningstilbud>"
    Så ser administrator "<behandlingsstatus>" hvis den finnes for søknad
    # siste linje vil alltid være tom for FS-søknader

    Eksempler:
    |søker           |navn på opptak        |søknadsnummer|antall valgte utdanningstilbud|behandlingsstatus|
    |førstegangssøker|FS Programopptak      |UHG430404    |10 valgte alternativer        |behandlet        |
    |andregangssøker |Admissio Programopptak|MAS15667     |3 valgte alternativer         |under behandling |
    |tredjegangssøker|FS Emneopptak         |ENK010111    |1 valgte alternativer         |ikke behandlet   |

  Scenariomal: Navigere til behandling av søknad (kun for admissiosøknader)
    Gitt at administrator er "<saksbehandler>" i opptak
    Når administrator klikker på gå til søknad for "<søker>"
    Så kommer administrator inn på søkers søknad til behandling
    Eksempler:
      |saksbehandler|søker|
      |Borghild Aga |Astrid Oline Aga|

    Scenario: Utvide søknadsvisning
      Gitt at administrator er på fanen "søknad"
      Når administrator klikker på nedtrekksmenyen
      Så ser administrator utvidet søknadsvisning

  Scenario: Utvidet søknadsvisning
    # ikke prioritert mm vi har datagrunnlag for det
    Gitt at administrator utvidet søknadsvisning
    Når administrator ser på utvidet søknadsvisning
    Så ser administrator valgte utdanningstilbud
    Så ser administrator behandlerorganisasjon
    Så ser administrator saksbehandler
    Så ser administrator tidslinje for søknadsprosessen
