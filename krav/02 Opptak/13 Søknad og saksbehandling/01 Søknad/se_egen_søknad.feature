# language: no
@OPT-SØK-SØK-009 @must @implemented
Egenskap: Se detaljer om egen søknad
  Som en søker
  ønsker jeg å se hva som står i søknaden min og hvor den er i prosessen
  slik at jeg vet om jeg må gjøre noe mer eller bare vente på svar.

  Bakgrunn:
    Gitt at søkeren er innlogget i Min kompetanse
    Og søkeren har en levert søknad i et opptak

  Regel: Søknaden viser identitet og status

    Scenario: Søkeren ser søknadsnummeret
      Når søkeren åpner søknaden
      Så vises søknadsnummeret

    Scenario: Søkeren ser hvor søknaden er i prosessen
      Når søkeren åpner søknaden
      Så vises hvilket steg søknaden er i

    Scenario: Søkeren ser når søknaden sist ble endret
      Når søkeren åpner søknaden
      Så vises tidspunktet søknaden sist ble endret

  Regel: Søknaden viser søknadsalternativene i prioritert rekkefølge

    Scenario: Søkeren ser søknadsalternativene
      Gitt at søknaden har flere søknadsalternativer
      Når søkeren åpner søknaden
      Så vises søknadsalternativene i prioritert rekkefølge
      Og hvert søknadsalternativ viser utdanningstilbudet og lærestedet

  Regel: Søknaden viser frister som gjelder søkeren

    Scenario: Søkeren ser søknadsfristen for opptaket
      Når søkeren åpner søknaden
      Så vises søknadsfristen for opptaket

    Scenario: Søkeren ser svarfristen når det finnes et tilbud å svare på
      Gitt at søkeren har et tilbud som kan besvares
      Når søkeren åpner søknaden
      Så vises svarfristen for opptaksrunden

  Regel: Søknaden viser dokumentasjon og kontaktopplysninger

    Scenario: Søkeren ser dokumentene som er levert på søknaden
      Gitt at det er lastet opp dokumentasjon på søknaden
      Når søkeren åpner søknaden
      Så vises dokumentene som er levert

    Scenario: Søknaden har ingen dokumenter
      Gitt at det ikke er lastet opp dokumentasjon på søknaden
      Når søkeren åpner søknaden
      Så får søkeren beskjed om at det ikke finnes dokumenter på søknaden

    Scenario: Søkeren ser kontaktopplysningene lærestedet kan nås på
      Når søkeren åpner søknaden
      Så vises kontaktopplysninger til lærestedet søknaden gjelder

  Regel: Søkeren ser bare egne søknader

    Scenario: Søkeren åpner en søknad som ikke er søkerens egen
      Når søkeren forsøker å åpne en søknad som tilhører en annen søker
      Så får søkeren ikke se søknaden
