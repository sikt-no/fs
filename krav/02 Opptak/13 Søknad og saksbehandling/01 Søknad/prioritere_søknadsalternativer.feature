# language: no
@OPT-SØK-SØK-006 @must @implemented
Egenskap: Prioritere søknadsalternativer
  Som en søker
  ønsker jeg å bestemme rekkefølgen på utdanningstilbudene jeg søker på
  slik at jeg får tilbud om den studieplassen jeg helst vil ha.

  Bakgrunn:
    Gitt at søkeren er innlogget i Min kompetanse
    Og søkeren har utdanningstilbud i studiekurven for et opptak

  Regel: Søkeren bestemmer rekkefølgen på søknadsalternativene

    Scenario: Søkeren endrer rekkefølgen på søknadsalternativene
      Gitt at søkeren er i prioriteringssteget i søknaden
      Når søkeren flytter et søknadsalternativ til en annen plassering
      Så vises søknadsalternativene i den nye rekkefølgen

    Scenario: Rekkefølgen lagres på søknadskladden
      Gitt at søkeren har endret rekkefølgen på søknadsalternativene
      Når søkeren lagrer prioriteringen
      Så har søknadskladden den nye rekkefølgen

    Scenario: Søkeren fjerner et søknadsalternativ i prioriteringssteget
      Gitt at søkeren har flere søknadsalternativer i søknaden
      Når søkeren fjerner et søknadsalternativ
      Så inngår ikke utdanningstilbudet lenger i søknaden
      Og de gjenværende søknadsalternativene beholder innbyrdes rekkefølge

    Scenario: Søkeren har ingen søknadsalternativer igjen
      Gitt at søkeren er i prioriteringssteget i søknaden
      Når søkeren fjerner det siste søknadsalternativet
      Så får søkeren beskjed om at søknaden er tom
      Og søkeren tilbys å legge til utdanningstilbud

  Regel: Prioriteringen kan endres på en levert søknad

    Scenario: Søkeren endrer prioritering på en levert søknad
      Gitt at søkeren har levert en søknad i et opptak
      Og søknadsfristen for opptaket ikke har gått ut
      Når søkeren endrer prioriteringen og lagrer den
      Så har søknaden den nye prioriteringen

    Scenario: Søkeren forkaster endringer i en levert søknad
      Gitt at søkeren har endret prioriteringen på en levert søknad uten å levere på nytt
      Når søkeren velger å forkaste endringene
      Så har søknaden prioriteringen fra sist levering
