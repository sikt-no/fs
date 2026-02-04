# language: no
@DEM-OPT-OPT-003 @demo @e2e @must @planned @nightly
Egenskap: Søke etter opptak
  Som søker ønsker jeg å finne publiserte opptak
  slik at jeg kan søke på aktuelle studieplasser.

  @e2e @planned
  Scenario: Søke etter et publisert opptak
    Gitt at jeg er logget inn som person
    Og at opptaket "Vårsøknad 2025" er publisert
    Når jeg søker etter "Jordmor" på finn studier
    Og jeg legger til alle studier i kurven
    Og jeg går til studiekurven
    Så skal opptaket være synlig
