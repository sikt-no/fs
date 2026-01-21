# language: no
@DEM-OPT-OPT-001 @demo @implemented @must
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
      Og jeg setter type til "Lokalt opptak"
      Og jeg setter søknadsfrist til "15.04.2025"
      Og jeg setter oppstartsdato til "15.08.2025"
      Og jeg publiserer opptaket
      Så skal opptaket "Høstopptak 2025" være publisert

    @e2e @in-progress @should
    Scenario: Tilknytte utdanningstilbud til et opptak
      Gitt at opptaket "Våropptak 2025" er publisert
      Når jeg tilknytter utdanningstilbudet "Bachelorprogram i informatikk" til opptaket
      Så skal "Bachelorprogram i informatikk" være søkbart for søkere
