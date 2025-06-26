# language: no
@skip @opptakspilot @ci @focus
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


  # Grunnlag
  Scenario: Saksbehandler skal alltid kunne velge grunnlaget "REA" (Realkompetanse) under saksbehandling

  Scenario: Grunnlaget "REA" skal aldri kreve at søker har "GSK"

  Scenario: Grunnlaget "PRA" skal aldri kreve at søker har "GSK"

  Scenario: Grunnlaget "PRA" skal kun velges når søker kan tildeles "GSK" på bakgrunn av praksis og 6-packen (delfag?)

  # Her må vi snakke om søker når ting skal vises
  Scenario: Saksbehandler skal se alle grunnlag knyttet til regelverket utdanningstilbudet søkeren har søkt på er koblet til 

  # Scenario: Saksbehandler skal ikke få opp grunnlag som krever at søker har bevist GSK før søkeren har bevist GSK

  #Poengberegning
  Scenario: Når saksbehandler krysser av for et grunnlag åpner det for poengtypene man kvalifiserer for 
      # her må vi definere et case


  # Rangering (må sjekkes. Dette er det jeg tror er dobbeltrangering. I det minste er det flre grunnlag på samme kvote -> Besr)
  Scenario: Saksbehandler skal dobbeltrangere søkeren til fordel for søkeren 
      Gitt Saksbehandler saksbehandler et opptak til en bachelorgrad
      Og Søker har gyldig vitnemål fra VGS som gir GSK
      Og søker er eldre enn 23 år
      Og Søker har 5 års praksis
      Og søker har delfag med bedre snitt enn skolepoeng fra Vitnemålet
      Når Saksbehandler rangerer søkeren med Grunnlagene VES og PRA
      Så skal søker rangeres i ordinær kvote med konkuransepoengene fra grunnlaget PRA

  # Automatisk poengberegning (vet ikke helt sikkert hvor mange poeng man får?)
  Scenario: Saksbehandler velger grunnlaget VES og VOV for en søknad
      Og Søker har gjennomført militæret
      Og Søker får kjønnspoeng
      Så skal Søker sine VES-poeng være 3-4 poeng høyere enn VOV-poengene

  Scenario: Saksbehandler velger grunnlaget VES og PRA
      Og Søker er eldre enn 23 år
      Og Søker har bedre snitt i delfagene sine enn på vitnemålet
      Så skal Søker sine PRA-poeng være høyere enn VES-poengene

  # GSK
  Scenario: En søker skal kun ha et gyldig GSK-vedtak om gangen

  Scenario: En søker har fått et nytt vitnemål men skal ikke få et nytt GSK vedtak

  Scenario: En saksbehandler må kunne annulere et tidligere fattet GSK-vedtak, men det skal fortsatt være gyldig i inneværende opptak


