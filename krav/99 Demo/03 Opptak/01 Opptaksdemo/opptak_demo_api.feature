# language: no
@DEM-OPT-OPT-002 @demo @integration @planned @should
Egenskap: Opprette opptak via API
  Som system administrator ønsker jeg å kunne opprette opptak programmatisk
  slik at jeg kan automatisere opprettelse av opptak i bulk.
  
  @planned @must
  Scenario: Opprette et nytt opptak med grunnleggende informasjon
    Når jeg oppretter et opptak med gyldig informasjon
    Så skal opptaket være opprettet
    Og opptaket skal ha riktig navn
    Og opptaket skal ha riktig søknadsfrist
    Og opptaket skal ha riktig oppstartsdato

  @planned @could
  Scenario: Opprette et opptak med ugyldig søknadsfrist
    Når jeg forsøker å opprette et opptak med søknadsfrist i fortiden
    Så skal opprettelsen feile
    Og jeg skal få en feilmelding om ugyldig dato