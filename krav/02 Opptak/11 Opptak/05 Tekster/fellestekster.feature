# language: no
@OPT-OPT-TEK-001 @should @draft
Egenskap: Fellestekster for opptak
  Som opptaksforvalter
  ønsker jeg å sette tekster som vises til søkere og saksbehandlere
  slik at de får relevant informasjon om opptaket.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at opptaket "Samordna opptak 2027" er opprettet

  Regel: Opptaksforvalter kan sette tekster for opptaket

    Scenario: Sette introtekst
      Når jeg setter introtekst for opptaket
      Så vises introteksten når søker åpner opptaket for å søke

    Scenario: Sette beskrivelse
      Når jeg setter beskrivelse for opptaket
      Så vises beskrivelsen i opptaksoversikten og søknadsskjemaet

    Scenario: Sette kvitteringstekst
      Når jeg setter kvitteringstekst for opptaket
      Så vises kvitteringsteksten etter at søker har sendt inn søknad

    Scenario: Sette kvitteringstekst etter avsluttet søknadsperiode
      Når jeg setter kvitteringstekst etter avsluttet søknadsperiode
      Så vises denne teksten hvis søker forsøker å nå opptaket etter at søknadsfristen er utløpt

  Regel: Tekster som eksponeres til søkere må kunne angis på flere språk

    Scenario: Angi fellestekster på flere språk
      Når jeg setter introtekst på bokmål, nynorsk, engelsk og samisk
      Så er tekstene tilgjengelige på alle fire språk
