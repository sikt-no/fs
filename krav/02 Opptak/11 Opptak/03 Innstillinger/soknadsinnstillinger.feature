# language: no
@OPT-OPT-INN-002 @must @draft
Egenskap: Søknadsinnstillinger for opptak
  Som opptaksforvalter
  ønsker jeg å sette innstillinger som styrer hvordan søkere kan søke
  slik at søknader i opptaket følger riktige regler.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at opptaket "Samordna opptak 2027" er opprettet

  @wont
  # Ikke viktig for samordna opptak 2027
  Regel: Opptaksforvalter kan styre om søkere kan laste opp dokumentasjon

    Scenario: Åpne for dokumentasjonsopplasting
      Når jeg angir at søkere kan laste opp dokumentasjon
      Så kan søkere laste opp dokumentasjon som del av søknaden

    Scenario: Stenge for dokumentasjonsopplasting
      Når jeg angir at søkere ikke kan laste opp dokumentasjon
      Så kan ikke søkere laste opp dokumentasjon

  Regel: Søknadsnummerserien må være unik for opptaket

    Scenario: Sette nummerserie for opptak
      Når jeg setter søknadsnummerserie med startnummer 100000
      Så får søknader i opptaket løpende nummer fra 100000
      Og søknadsnumrene er unike for dette opptaket

  Regel: Opptaksforvalter kan sette tak for antall søknadsalternativer

    Scenario: Sette maks antall søknadsalternativer
      Når jeg setter maks antall søknadsalternativer til 10
      Så kan ikke en søker legge til flere enn 10 prioriterte søknadsalternativer i sin søknad

  Regel: Opptaksforvalter kan åpne for tidlig opptak

    Scenario: Aktivere tidlig opptak
      Når jeg aktiverer tidlig opptak
      Og jeg setter frist for tidlig opptak
      Så kan søkere som oppfyller visse kriterier få svar før vanlig publiseringsfrist

    Scenario: Tidlig opptak krever egen frist
      Når jeg aktiverer tidlig opptak
      Men jeg setter ikke frist for tidlig opptak
      Så varsles jeg om at frist for tidlig opptak må settes

  Regel: Opptaksforvalter kan sette hvilke utdanningsbakgrunner søkere kan bli vurdert på i opptaket

    Scenario: Sette utdanningsbakgrunner for opptaket
      Når jeg setter at søkere kan bli vurdert på utdanningsbakgrunnene
        | Utdanningsbakgrunn        |
        | Norsk videregående skole  |
        | Realkompetanse            |
        | Utenlandsk utdanning      |
        | Steinerskole              |
      Så kan søkere med disse utdanningsbakgrunnene bli vurdert i opptaket