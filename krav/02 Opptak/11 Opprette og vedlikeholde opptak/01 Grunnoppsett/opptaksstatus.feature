# language: no
@OPT-OVO-GRU-004 @must @draft
Egenskap: Status på opptaket
  Som opptaksforvalter
  ønsker jeg å styre når søkerne ser opptaket, og når opptaket ikke lenger er i bruk
  slik at søkerne bare ser utdanningstilbud de kan søke på, og et avsluttet opptak ikke endres.

  Opptaksforvalter publiserer opptaket når søkerne skal se utdanningstilbudene i opptaket og kunne søke
  i Min kompetanse, og kan avpublisere det igjen. Når opptaket er ferdig, gjør opptaksforvalter det historisk.

  # Kilde: produkteier 2026-10-28. Svarer til HK-9846 og HK-9847 (publisering) og HK-9848 (Arkivert, her historisk).
  # Regelen om å deaktivere opptaket er flyttet hit fra opprett_opptak.feature.
  # Feature-ID-en er 004, fordi 002 ble brukt om et forslag om publisering av opptak.

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget

  Regel: Opptaksforvalter ved forvaltende organisasjon publiserer opptaket
    # Hva søkerne ser, står i finne_studier.feature og søke_på_opptak.feature.

    Scenario: Opptaket er upublisert når det er opprettet
      Når opptaksforvalter oppretter et nytt opptak med alle obligatoriske verdier
      Og opptaksforvalter lagrer opptaket
      Så er opptaket upublisert

    Scenario: Publisere opptaket
      Gitt at opptaket "Samordna opptak 2027" er upublisert
      Når opptaksforvalter ved forvaltende organisasjon publiserer opptaket
      Så er opptaket "Samordna opptak 2027" publisert

    Scenario: Opptaksforvalter ved deltakende organisasjon kan ikke publisere opptaket
      Gitt at organisasjonen "UiB" deltar i opptaket "Samordna opptak 2027"
      Når opptaksforvalter ved "UiB" åpner opptaket "Samordna opptak 2027"
      Så ser opptaksforvalteren ikke muligheten til å publisere opptaket

  Regel: Opptaksforvalter ved forvaltende organisasjon kan avpublisere opptaket
    # Avpublisering er en nødbrems hvis noe kritisk oppdages etter publisering. Opptaket blir upublisert,
    # og kan publiseres igjen. Trengs mer tid, forlenger opptaksforvalter søknadsfristen i innstillingene.

    Scenario: Avpublisere opptaket
      Gitt at opptaket "Samordna opptak 2027" er publisert
      Når opptaksforvalter ved forvaltende organisasjon avpubliserer opptaket
      Så er opptaket "Samordna opptak 2027" upublisert

  Regel: Opptaket er aktivt når det er opprettet

    Scenario: Opptaket er aktivt når det er lagret
      Når opptaksforvalter oppretter et nytt opptak med alle obligatoriske verdier
      Og opptaksforvalter lagrer opptaket
      Så er opptaket aktivt

    @ref-OPT-OVO-SAM-001
    Scenario: Deltakende organisasjon ser et aktivt opptak før det er publisert
      Gitt at opptaket "Samordna opptak 2027" er aktivt
      Og at opptaket "Samordna opptak 2027" er upublisert
      Og at organisasjonen "UiB" deltar i opptaket "Samordna opptak 2027"
      Når saksbehandler ved "UiB" åpner opptaksoversikten
      Så ser saksbehandleren opptaket "Samordna opptak 2027"

  @openquestion
  Regel: Opptaksforvalter ved forvaltende organisasjon kan gjøre opptaket historisk
    # ÅPNE SPØRSMÅL:
    # - Kan et historisk opptak gjøres aktivt igjen?
    # - Når er opptaket ferdig nok til å gjøres historisk: etter siste tildelingsrunde, etter siste svarfrist,
    #   eller når klagene er behandlet?

    Scenario: Gjøre opptaket historisk
      Gitt at plasstildelingen i opptaket "Samordna opptak 2027" er ferdig
      Når opptaksforvalter ved forvaltende organisasjon gjør opptaket historisk
      Så er opptaket "Samordna opptak 2027" historisk

    Scenario: Opptaket kan ikke gjøres historisk før plasstildelingen er ferdig
      Gitt at plasstildelingen i opptaket "Samordna opptak 2027" ikke er ferdig
      Når opptaksforvalter ved forvaltende organisasjon vil gjøre opptaket historisk
      Så kan opptaket ikke gjøres historisk

    Scenario: Opptaksforvalter ved deltakende organisasjon kan ikke gjøre opptaket historisk
      Gitt at organisasjonen "UiB" deltar i opptaket "Samordna opptak 2027"
      Når opptaksforvalter ved "UiB" åpner opptaket "Samordna opptak 2027"
      Så ser opptaksforvalteren ikke muligheten til å gjøre opptaket historisk

  @openquestion
  Regel: Et historisk opptak kan bare ses og søkes i
    # ÅPNE SPØRSMÅL:
    # - Vises historiske opptak i opptaksoversikten, og skal lista kunne filtreres på aktiv og historisk?
    # - Kan et historisk opptak brukes som grunnlag for et nytt opptak (gjenbruk i opprett_opptak.feature)?

    Scenario: Innstillingene kan ikke endres i et historisk opptak
      Gitt at opptaket "Samordna opptak 2027" er historisk
      Når opptaksforvalter åpner innstillingene for opptaket "Samordna opptak 2027"
      Så kan opptaksforvalteren ikke endre innstillingene

    Scenariomal: Oppgaver kan ikke utføres i et historisk opptak
      Gitt at opptaket "Samordna opptak 2027" er historisk
      Når <rolle> vil <oppgave> i opptaket "Samordna opptak 2027"
      Så kan oppgaven ikke utføres

      Eksempler:
        | rolle            | oppgave                        |
        | opptaksforvalter | knytte til et utdanningstilbud |
        | saksbehandler    | behandle en søknad             |
        | opptaksforvalter | gjennomføre plasstildeling     |

    Scenario: Saksbehandler kan søke etter søknader i et historisk opptak
      Gitt at opptaket "Samordna opptak 2027" er historisk
      Når saksbehandler søker etter en søknad i opptaket "Samordna opptak 2027"
      Så finner saksbehandleren søknaden
