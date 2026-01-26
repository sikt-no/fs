  # language: no
  @OPT-OPT-OPT-001 @opptakspilot @fsadmin
  Egenskap: Opprette et opptak
  Som administrator ønsker jeg å kunne opprette et opptak og publisere det slik at det blir tilgjengelig for personer som ønsker å søke. Det skal også være mulig å endre opptaket etter at det er opprettet.

  Bakgrunn:
  Gitt administratoren er på hovedsiden til adminflaten
  Gitt administratoren er en saksbehandler for opptak
  Gitt administratoren går til opptakssiden

  @harTest @levert @nih
  Scenario: Opprette et opptak med ett utdanningstilbud
  Når administratoren velger å lage lokalt opptak
  Og administratoren setter navn og type på opptak til universitet og høyskole grunnutdanning
  Og administratoren setter frister på opptaket
  Og administratoren tilknytter et utdanningstilbud til opptaket
  Så skal personen se opptaket som er laget og kunne søke på det

  @harTest @levert
  Scenario: Endre navn på et opptak
  Gitt at det finnes et opptak administrator har laget
  Når administratoren velger å endre et opptak
  Og administratoren endrer navn og lagrer endringene
  Så skal administratoren kunne opptaket med det nye navnet i listen over opptak

  @harTest @levert
  Scenario: Endre frist på et opptak
  Gitt at det finnes et opptak administrator har laget
  Når administratoren velger å endre et opptak
  Og administratoren endrer søknadsfrist og lagrer endringene
  Så skal personen se den endrede fristen i personflaten

  # Mulig å teste alle frister?

  Scenario: Endre utdanningstilbud på et opptak
  Når administratoren endrer utdanningstilbud og lagrer endringene
  Så skal administratoren kunne se opptaket i listen over opptak

  Scenario: Legge inn informasjonen på opptak søkere som får tilbud skal se

  Scenario: Legge inn informasjonen søkere som kommer på venteliste skal se
  
  Scenario: Legge inn informasjonen søkere som får avslag skal se

  @levert @nih
  Scenario: Sette kvoteplasser på utdanningstilbud

  @nih
  Scenario: Sette tekster som potensielle søkere får se