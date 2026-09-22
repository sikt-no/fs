# language: no
@OPT-OPT-UBG-001 @must @draft
Egenskap: Utdanningsbakgrunn i opptak
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å opprette utdanningsbakgrunner med avvikende frister i opptaket
  slik at søkere med spesielle utdanningsbakgrunner får riktige søknads- og dokumentasjonsfrister.

  # I samordna opptak kan kun opptaksforvalter ved forvaltende organisasjon opprette utdanningsbakgrunner.
  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet
    Og at opptaket tillater avvikende søknadsfrister per utdanningsbakgrunn

  Regel: Opptaksforvalter ved forvaltende organisasjon kan opprette utdanningsbakgrunner i opptaket

    Scenario: Opprette utdanningsbakgrunn med avvikende frister
      Når opptaksforvalter oppretter utdanningsbakgrunnen "Realkompetanse" i opptaket
      Og opptaksforvalter setter søknadsfrist til "2027-03-01 23:59"
      Og opptaksforvalter setter dokumentasjonsfrist til "2027-03-01 23:59"
      Så finnes utdanningsbakgrunnen "Realkompetanse" i opptaket
      Og søkere med denne utdanningsbakgrunnen har egne frister

    Scenario: Opprette utdanningsbakgrunn for utenlandsk utdanning
      Når opptaksforvalter oppretter utdanningsbakgrunnen "Utenlandsk utdanning" i opptaket
      Og opptaksforvalter setter søknadsfrist til "2027-03-01 23:59"
      Og opptaksforvalter setter dokumentasjonsfrist til "2027-03-15 23:59"
      Så finnes utdanningsbakgrunnen "Utenlandsk utdanning" i opptaket

    Scenario: Opprette utdanningsbakgrunn for steinerskole
      Når opptaksforvalter oppretter utdanningsbakgrunnen "Steinerskole" i opptaket
      Og opptaksforvalter setter søknadsfrist til "2027-03-01 23:59"
      Og opptaksforvalter setter dokumentasjonsfrist til "2027-03-01 23:59"
      Så finnes utdanningsbakgrunnen "Steinerskole" i opptaket

  Regel: Utdanningsbakgrunn er ikke hardkodet — opptaksforvalter ved forvaltende organisasjon kan opprette nye

    Scenario: Opprette en ny utdanningsbakgrunn
      Når opptaksforvalter oppretter en ny utdanningsbakgrunn med navn "23/5-regelen"
      Og opptaksforvalter setter søknadsfrist og dokumentasjonsfrist
      Så finnes den nye utdanningsbakgrunnen i opptaket

  Regel: Søkere med utdanningsbakgrunn som har avvikende frister vurderes etter bakgrunnens frister

    Scenario: Søker med realkompetanse får avvikende frist
      Gitt at utdanningsbakgrunnen "Realkompetanse" har søknadsfrist "2027-03-01 23:59"
      Og at den generelle søknadsfristen er "2027-04-15 23:59"
      Når en søker søker med utdanningsbakgrunn "Realkompetanse"
      Så gjelder søknadsfristen "2027-03-01 23:59" for denne søkeren

  Regel: Utdanningsbakgrunner uten avvikende frister trenger ikke registreres

    # Norsk videregående skole har ingen avvikende frister og trenger
    # ikke opprettes som utdanningsbakgrunn i opptaket.
    Scenario: Søker med norsk vgs følger ordinære frister
      Gitt at det ikke er opprettet utdanningsbakgrunn for norsk videregående skole
      Når en søker søker med norsk videregående skole som utdanningsbakgrunn
      Så gjelder de generelle fristene i opptaket