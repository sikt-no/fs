# language: no
@OPT-OPT-TEK-001 @won´t @draft
# Dette kan vente til senere, ikke viktig for 2027-opptak. Tekstene trenger ikke kunne redigeres, bare vises studenten. 
Egenskap: Fellestekster for opptak
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å sette tekster som vises til søkere
  slik at de får relevant informasjon om opptaket og søknadsprosessen.

  # I samordna opptak kan kun opptaksforvalter ved forvaltende organisasjon endre fellestekster.
  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet

  Regel: Opptaksforvalter ved forvaltende organisasjon kan sette tekster for opptaket

    Scenario: Sette informasjon om prioritering av søknadsalternativer
      Når opptaksforvalter setter tekst om prioritering av søknadsalternativer
      Så vises teksten slik at søker vet hvordan hen prioriterer og hva det betyr

    Scenario: Sette informasjon om utdanningsbakgrunn
      Når opptaksforvalter setter tekst om utdanningsbakgrunn
      Så vises teksten slik at søker forstår hva utdanningsbakgrunn innebærer

    Scenario: Sette informasjon om påkrevd dokumentasjon
      Når opptaksforvalter setter tekst om påkrevd dokumentasjon
      Så vises teksten slik at søker vet hva som må lastes opp

    Scenario: Sette oppsummeringstekst
      Når opptaksforvalter setter oppsummeringstekst med informasjon om søknaden
      Så vises teksten som en oppsummering av søknaden for søker

    Scenario: Sette kvitteringstekst
      Når opptaksforvalter setter kvitteringstekst for opptaket
      Så vises kvitteringsteksten etter at søker har sendt inn søknad

  Regel: Tekster som eksponeres til søkere må kunne angis på flere språk

    Scenario: Angi fellestekster på flere språk
      Når opptaksforvalter setter fellestekster på bokmål, nynorsk, engelsk og samisk
      Så er tekstene tilgjengelige på alle fire språk
