# language: no
@OPT-OPT-UBG-001 @must @draft
Egenskap: Utdanningsbakgrunn i opptak
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å legge til utdanningsbakgrunner fra regelverket i opptaket og sette egne frister
  slik at søkere med spesielle utdanningsbakgrunner får riktige søknads- og dokumentasjonsfrister.

  # Utdanningsbakgrunnstyper defineres i regelverket (se 10 Regelverk/06 Utdanningsbakgrunn).
  # Her velger opptaksforvalter hvilke som gjelder for dette opptaket og setter frister.

  # I samordna opptak kan kun opptaksforvalter ved forvaltende organisasjon legge til utdanningsbakgrunner.
  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet
    Og at opptaket tillater avvikende søknadsfrister per utdanningsbakgrunn

  Regel: Opptaksforvalter kan legge til utdanningsbakgrunner fra regelverket i opptaket

    Scenario: Legge til utdanningsbakgrunn med avvikende frister
      Gitt at utdanningsbakgrunnstypen "Realkompetanse" finnes i regelverket
      Når opptaksforvalter legger til "Realkompetanse" i opptaket
      Og opptaksforvalter setter søknadsfrist til "2027-03-01 23:59"
      Og opptaksforvalter setter dokumentasjonsfrist til "2027-03-01 23:59"
      Så finnes utdanningsbakgrunnen "Realkompetanse" i opptaket
      Og søkere med denne utdanningsbakgrunnen har egne frister

    Scenario: Legge til utdanningsbakgrunn for utenlandsk utdanning
      Gitt at utdanningsbakgrunnstypen "Utenlandsk utdanning" finnes i regelverket
      Når opptaksforvalter legger til "Utenlandsk utdanning" i opptaket
      Og opptaksforvalter setter søknadsfrist til "2027-03-01 23:59"
      Og opptaksforvalter setter dokumentasjonsfrist til "2027-03-15 23:59"
      Så finnes utdanningsbakgrunnen "Utenlandsk utdanning" i opptaket

  Regel: Søkere med utdanningsbakgrunn som har avvikende frister vurderes etter bakgrunnens frister

    Scenario: Søker med realkompetanse får avvikende frist
      Gitt at utdanningsbakgrunnen "Realkompetanse" har søknadsfrist "2027-03-01 23:59"
      Og at den generelle søknadsfristen er "2027-04-15 23:59"
      Når en søker søker med utdanningsbakgrunn "Realkompetanse"
      Så gjelder søknadsfristen "2027-03-01 23:59" for denne søkeren

  Regel: Utdanningsbakgrunner uten avvikende frister trenger ikke registreres i opptaket

    # Norsk videregående skole har ingen avvikende frister og trenger
    # ikke legges til som utdanningsbakgrunn i opptaket.
    Scenario: Søker med norsk vgs følger ordinære frister
      Gitt at det ikke er lagt til utdanningsbakgrunn for norsk videregående skole i opptaket
      Når en søker søker med norsk videregående skole som utdanningsbakgrunn
      Så gjelder de generelle fristene i opptaket