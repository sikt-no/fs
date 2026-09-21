# language: no
@OPT-OPT-TEK-001 @should @draft
Egenskap: Fellestekster for opptak
  Som opptaksforvalter
  ønsker jeg å sette tekster som vises til søkere
  slik at de får relevant informasjon om opptaket og søknadsprosessen.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at opptaket "Samordna opptak 2027" er opprettet

  Regel: Opptaksforvalter kan sette tekster for opptaket

    Scenario: Sette informasjon om prioritering av søknadsalternativer
      Når jeg setter tekst om prioritering av søknadsalternativer
      Så vises teksten slik at søker vet hvordan hen prioriterer og hva det betyr

    Scenario: Sette informasjon om utdanningsbakgrunn
      Når jeg setter tekst om utdanningsbakgrunn
      Så vises teksten slik at søker forstår hva utdanningsbakgrunn innebærer

    Scenario: Sette informasjon om påkrevd dokumentasjon
      Når jeg setter tekst om påkrevd dokumentasjon
      Så vises teksten slik at søker vet hva som må lastes opp

    Scenario: Sette oppsummeringstekst
      Når jeg setter oppsummeringstekst med informasjon om søknaden
      Så vises teksten som en oppsummering av søknaden for søker

    Scenario: Sette kvitteringstekst
      Når jeg setter kvitteringstekst for opptaket
      Så vises kvitteringsteksten etter at søker har sendt inn søknad

  Regel: Tekster som eksponeres til søkere må kunne angis på flere språk

    Scenario: Angi fellestekster på flere språk
      Når jeg setter fellestekster på bokmål, nynorsk, engelsk og samisk
      Så er tekstene tilgjengelige på alle fire språk