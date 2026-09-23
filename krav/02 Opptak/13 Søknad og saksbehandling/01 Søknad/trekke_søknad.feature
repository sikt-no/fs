# language: no
@OPT-SØK-SØK-008 @must @implemented
Egenskap: Trekke egen søknad
  Som en søker
  ønsker jeg å trekke en søknad jeg har levert
  slik at jeg ikke blir vurdert i et opptak jeg ikke lenger vil delta i.

  Bakgrunn:
    Gitt at søkeren er innlogget i Min kompetanse
    Og søkeren har en levert søknad i et opptak

  Regel: Søkeren bekrefter før søknaden trekkes

    Scenario: Søkeren trekker søknaden
      Når søkeren velger å trekke søknaden
      Og søkeren bekrefter at søknaden skal trekkes
      Så er søknaden trukket
      Og ingen søknadsalternativer står igjen på søknaden

    Scenario: Søkeren avbryter trekkingen
      Når søkeren velger å trekke søknaden
      Og søkeren avbryter bekreftelsen
      Så er søknaden fortsatt levert

    Scenario: Søkeren får vite at det er mulig å søke på nytt før fristen
      Gitt at søknadsfristen for opptaket ikke har gått ut
      Når søkeren velger å trekke søknaden
      Så opplyses søkeren om søknadsfristen i bekreftelsen

  Regel: En søknad kan ikke trekkes etter at opptaket har kjørt

    Scenario: Opptaket har kjørt plasstildeling
      Gitt at opptaket har kjørt plasstildeling
      Når søkeren forsøker å trekke søknaden
      Så avvises trekkingen fordi opptaket har kjørt
      Og søkeren henvises til å svare nei på tilbudet i stedet

    Scenario: Søknadsfristen har gått ut, men opptaket har ikke kjørt
      Gitt at søknadsfristen for opptaket har gått ut
      Og opptaket ikke har kjørt plasstildeling
      Når søkeren trekker søknaden
      Så er søknaden trukket

  Regel: Trukne søknader vises som trukket

    Scenario: Søkeren ser en trukket søknad i oversikten
      Gitt at søkeren har trukket en søknad
      Når søkeren åpner oversikten over egne søknader
      Så vises søknaden som trukket
