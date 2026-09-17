# language: no
@OPT-OPT-INN-002 @must @draft
Egenskap: Søknadsinnstillinger for opptak
  Som opptaksforvalter
  ønsker jeg å sette innstillinger som styrer hvordan søkere kan søke
  slik at søknader i opptaket følger riktige regler.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at opptaket "Samordna opptak 2027" er opprettet

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

  Regel: Opptaksforvalter kan åpne for tidlig behandling og tilbud

    Scenario: Aktivere tidlig behandling og tilbud
      Når jeg aktiverer tidlig behandling og tilbud
      Og jeg setter frist for tidlig tilbud
      Så kan søkere som oppfyller visse kriterier få svar før vanlig publiseringsfrist

    Scenario: Tidlig behandling krever egen frist
      Når jeg aktiverer tidlig behandling og tilbud
      Men jeg setter ikke frist for tidlig tilbud
      Så varsles jeg om at frist for tidlig tilbud må settes

  Regel: Opptaksforvalter kan begrense opptaket til enkelte søkergrupper

    # Ikke prioritert for samordna opptak 2027 — alle søkergrupper skal kunne søke
    Scenario: Begrense opptak til søkergrupper
      Når jeg begrenser opptaket til søkergruppen "EU/EØS-borgere"
      Så er utdanningstilbud i opptaket kun tilgjengelige for EU/EØS-borgere
