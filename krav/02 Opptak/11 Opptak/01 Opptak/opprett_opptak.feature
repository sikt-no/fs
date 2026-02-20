# language: no
@DEM-OPT-OPT-001 @demo @implemented @must @nightly
Egenskap: Opprette et opptak
  Som administrator ønsker jeg å kunne opprette et opptak og publisere det
  slik at det blir tilgjengelig for personer som ønsker å søke.

  Bakgrunn:
    Gitt at jeg er logget inn som administrator
    Og at jeg er på opptakssiden

  @implemented @must
  Regel: Et opptak må være publisert og ha utdanningstilbud for å være søkbart

    @e2e @implemented
    Scenario: Opprette og publisere et opptak
      Når jeg oppretter et nytt lokalt opptak
      Og jeg setter navn til "Høstopptak 2025"
      Og jeg setter type til "Lokale opptak"
      Og jeg lagrer opptaket
      Og jeg tilknytter utdanningstilbud til opptaket
      Og jeg konfigurerer studiealternativet
      Så hvis jeg logger inn som person
      Og jeg søker etter "Jordmor" på finn studier
      Og jeg legger til alle studier i kurven
      Og jeg går til studiekurven
      Så skal opptaket være synlig
