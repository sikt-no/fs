# language: no
@OPT-OPT-LOG-001 @should @draft
Egenskap: Hendelseslogg for opptak
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg en logg over hvem som har gjort hvilke endringer på opptaket og når
  slik at jeg kan følge opp og etterprøve endringer.

  # Bygger på en generell revisjonsmekanisme som gjelder på tvers av FS.
  # Opptaket definerer hva som skal logges, mekanismen definerer hvordan.

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" er opprettet
    Og at opptaksforvalter ved forvaltende organisasjon er innlogget

  Regel: Alle endringer på opptakets innstillinger logges

    Scenario: Endre opptakstype
      Når opptaksforvalter endrer opptakstype for opptaket
      Så logges endringen med hvem som utførte den, fra hvilken organisasjon og når

    Scenario: Endre regelverkssamling
      Når opptaksforvalter endrer regelverkssamlingen for opptaket
      Så logges endringen med hvem som utførte den, fra hvilken organisasjon og når

    Scenario: Endre standard poenglikhetsregel
      Når opptaksforvalter endrer standard poenglikhetsregel for opptaket
      Så logges endringen med hvem som utførte den, fra hvilken organisasjon og når

    Scenario: Endre tak for antall tilbud per tildelingsrunde
      Når opptaksforvalter endrer tak for antall tilbud per tildelingsrunde
      Så logges endringen med hvem som utførte den, fra hvilken organisasjon og når

    Scenario: Endre maks antall søknadsalternativer
      Når opptaksforvalter endrer maks antall søknadsalternativer
      Så logges endringen med hvem som utførte den, fra hvilken organisasjon og når

    Scenario: Aktivere eller deaktivere tidlig opptak
      Når opptaksforvalter endrer innstillingen for tidlig opptak
      Så logges endringen med hvem som utførte den, fra hvilken organisasjon og når

    Scenario: Aktivere eller deaktivere ledige studieplasser
      Når opptaksforvalter endrer innstillingen for ledige studieplasser
      Så logges endringen med hvem som utførte den, fra hvilken organisasjon og når

  Regel: Alle endringer på opptakets frister logges

    Scenario: Endre søknadsfrist
      Når opptaksforvalter endrer ordinær søknadsfrist
      Så logges endringen med gammel og ny verdi, hvem som utførte den, fra hvilken organisasjon og når

    Scenario: Endre dokumentasjonsfrist
      Når opptaksforvalter endrer en dokumentasjonsfrist
      Så logges endringen med gammel og ny verdi, hvem som utførte den, fra hvilken organisasjon og når

    Scenario: Endre omprioriteringsfrist
      Når opptaksforvalter endrer omprioriteringsfrist
      Så logges endringen med gammel og ny verdi, hvem som utførte den, fra hvilken organisasjon og når

    Scenario: Endre dato for når søker kan forvente svar
      Når opptaksforvalter endrer dato for når søker kan forvente svar
      Så logges endringen med gammel og ny verdi, hvem som utførte den, fra hvilken organisasjon og når

    Scenario: Endre svarfrist
      Når opptaksforvalter endrer første svarfrist
      Så logges endringen med gammel og ny verdi, hvem som utførte den, fra hvilken organisasjon og når

  Regel: Endringer på samordning logges

    Scenario: Legge til organisasjon i samordnet opptak
      Når opptaksforvalter legger til en organisasjon som deltaker
      Så logges hendelsen med hvilken organisasjon som ble lagt til, hvem som utførte den og når

    Scenario: Fjerne organisasjon fra samordnet opptak
      Når opptaksforvalter fjerner en organisasjon som deltaker
      Så logges hendelsen med hvilken organisasjon som ble fjernet, hvem som utførte den og når

  Regel: Endringer på utdanningsbakgrunn i opptaket logges

    Scenario: Legge til utdanningsbakgrunn
      Når opptaksforvalter legger til en utdanningsbakgrunn i opptaket
      Så logges hendelsen med hvilken utdanningsbakgrunn som ble lagt til, hvem som utførte den og når

    Scenario: Endre frister for utdanningsbakgrunn
      Når opptaksforvalter endrer frister for en utdanningsbakgrunn
      Så logges endringen med gammel og ny verdi, hvem som utførte den, fra hvilken organisasjon og når

  Regel: Livssyklushendelser for opptaket logges

    Scenario: Opprette opptak
      Når opptaksforvalter oppretter et opptak
      Så logges opprettelsen med hvem som utførte den, fra hvilken organisasjon og når

    Scenario: Deaktivere opptak
      Når opptaksforvalter deaktiverer opptaket
      Så logges deaktiveringen med hvem som utførte den, fra hvilken organisasjon og når

  Regel: Opptaksforvalter kan se hendelsesloggen for opptaket

    Scenario: Se hendelseslogg
      Når opptaksforvalter åpner hendelsesloggen for opptaket
      Så ser opptaksforvalter en kronologisk liste over alle endringer
      Og hver hendelse viser hva som ble endret, hvem som endret, fra hvilken organisasjon og tidspunkt