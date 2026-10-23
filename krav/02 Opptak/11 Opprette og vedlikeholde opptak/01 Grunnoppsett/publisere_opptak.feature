# language: no
# GitHub: #211
@OPT-OVO-GRU-002 @must @draft @ref-OPT-SØK-SØK-001
Egenskap: Publisere opptak
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg at opptaket publiseres og avpubliseres etter fristene i opptaket
  slik at søkerne bare ser opptaket i søknadsperioden.

  Et nytt opptak er upublisert. Opptaket blir publisert når søknaden åpner, og avpublisert
  når alle søknadsfristene i opptaket har gått ut. Statusen følger datoene, og settes ikke for hånd.
  Publiseringen styrer ikke hva deltakerne i opptaket ser eller kan gjøre.

  # Virkningen for søkerne står der den brukes:
  # - søke_på_opptak.feature: søkeren kan begynne på og sende inn en søknad bare når søknaden har åpnet.
  # - finne_studier.feature (Regel «Synlighet via søknadsperioden i opptaket»): søkeren ser bare
  #   utdanningstilbud som er åpne for søknad. Etter den ordinære søknadsfristen er det bare utdanningstilbud
  #   som er åpne for søknad på ledige studieplasser.
  #   Feature-ID-en (@OPT-SØK-SØK-013) brukes av to filer, så den står ikke som tag her.

  # ÅPNE SPØRSMÅL:
  # - Åpner søknaden på ledige studieplasser etter at alle de andre fristene har gått ut, er opptaket
  #   avpublisert en periode. Blir det publisert igjen når søknaden på ledige studieplasser åpner?

  Regel: Et nytt opptak er upublisert

    Scenario: Nytt opptak er upublisert
      Når opptaksforvalter oppretter opptaket "Samordna opptak 2027"
      Så er opptaket "Samordna opptak 2027" upublisert

  @depends-on-OPT-OVO-FRI-001
  Regel: Opptaket blir publisert når søknaden åpner
    # Datoen settes i «Åpner for søking» (Opptaksforvalter ved forvaltende organisasjon må kunne åpne for søkning).

    Scenario: Opptaket er upublisert før søknaden åpner
      Gitt at søknaden i opptaket "Samordna opptak 2027" åpner "2027-02-01"
      Når det er "2027-01-31"
      Så er opptaket "Samordna opptak 2027" upublisert

    Scenario: Opptaket blir publisert når søknaden åpner
      Gitt at søknaden i opptaket "Samordna opptak 2027" åpner "2027-02-01"
      Når det er "2027-02-01"
      Så er opptaket "Samordna opptak 2027" publisert

    Scenario: Opptaket er upublisert når det ikke er satt når søknaden åpner
      Gitt at det ikke er satt når søknaden åpner i opptaket "Samordna opptak 2027"
      Så er opptaket "Samordna opptak 2027" upublisert

  @depends-on-OPT-OVO-FRI-001
  Regel: Opptaket blir avpublisert når alle søknadsfristene i opptaket har gått ut
    # Fristene settes i frister_og_hendelser.feature: den ordinære søknadsfristen, søknadsfristen for tidlig opptak,
    # avvikende søknadsfrister per utdanningsbakgrunn, og når søknaden på ledige studieplasser stenger.

    Scenario: Opptaket er publisert når en søknadsfrist ikke har gått ut
      Gitt at den ordinære søknadsfristen i opptaket "Samordna opptak 2027" er "2027-04-15 23:59"
      Og at søknaden på ledige studieplasser i opptaket stenger "2027-09-01 00:00"
      Når det er "2027-08-01"
      Så er opptaket "Samordna opptak 2027" publisert

    Scenario: Opptaket blir avpublisert når alle søknadsfristene har gått ut
      Gitt at den ordinære søknadsfristen i opptaket "Samordna opptak 2027" er "2027-04-15 23:59"
      Og at søknaden på ledige studieplasser i opptaket stenger "2027-09-01 00:00"
      Når det er "2027-09-01 00:00"
      Så er opptaket "Samordna opptak 2027" avpublisert

    Scenario: Opptak uten ledige studieplasser blir avpublisert etter den ordinære søknadsfristen
      Gitt at den ordinære søknadsfristen i opptaket "Samordna opptak 2027" er "2027-04-15 23:59"
      Og at opptaket ikke tilbyr søknad på ledige studieplasser
      Og at ingen utdanningsbakgrunn i opptaket har en senere søknadsfrist
      Når det er "2027-04-16 00:00"
      Så er opptaket "Samordna opptak 2027" avpublisert

  @ref-OPT-OVO-SAM-001
  Regel: Deltakerne i opptaket ser opptaket selv om det er upublisert
    # Organisasjoner som ikke deltar, ser ikke opptaket. Det står i samordna_opptak.feature.

    Scenario: Deltakende organisasjon ser et upublisert opptak
      Gitt at "Norges teknisk-naturvitenskapelige universitet" deltar i opptaket "Samordna opptak 2027"
      Og at opptaket "Samordna opptak 2027" er upublisert
      Når opptaksforvalter ved Norges teknisk-naturvitenskapelige universitet åpner oversikten over opptak
      Så ser opptaksforvalteren opptaket "Samordna opptak 2027"

  @depends-on-OPT-OPT-UTD-002
  Regel: Publiseringen styrer ikke når deltakerne kan legge til utdanningstilbud
    # Det styres av perioden opptaket er åpent for redigering
    # (Deltakende organisasjoner kan knytte til og redigere utdanningstilbud bare i perioden opptaket er åpent for redigering).

    Scenario: Deltakende organisasjon kan legge til utdanningstilbud i et upublisert opptak
      Gitt at "Norges teknisk-naturvitenskapelige universitet" deltar i opptaket "Samordna opptak 2027"
      Og at opptaket "Samordna opptak 2027" er upublisert
      Og at opptaket er åpent for redigering av utdanningstilbud
      Når opptaksforvalter ved Norges teknisk-naturvitenskapelige universitet legger til utdanningstilbudet "Sykepleie, høst 2027" i opptaket
      Så er utdanningstilbudet "Sykepleie, høst 2027" lagt til i opptaket
