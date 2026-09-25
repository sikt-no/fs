# language: no
# GitHub: #631
#
# Del av initiativ #215 Utdanningsbakgrunn i søknad om opptak.
# Kilder: Confluence PFS 4408344578 «Utdanningsbakgrunn» og
# PFS 3940188262 «2025-08-15: Utdanningsbakgrunn - Møte med HK-dir».
#
# Søkerens valg: velge_utdanningsbakgrunn.feature (@OPT-SØK-SØK-005).
# Tildeling av saksbehandlende organisasjon:
# tildele_saksbehandlende_organisasjon.feature (@OPT-BEH-BEH-006).
# Frist for å endre utdanningsbakgrunn: frister_og_tidsperioder.feature.
#
# Utdanningsbakgrunner følger med når et opptak opprettes basert på et
# tidligere opptak, se opprett_opptak.feature (@OPT-OPT-OPT-001).
#
@OPT-OPT-UBG-001 @must @draft
Egenskap: Utdanningsbakgrunn i opptak
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å bestemme hvilke utdanningsbakgrunner søkere kan velge i opptaket
  slik at søknader behandles etter riktige regler og frister.

  # I samordna opptak kan kun opptaksforvalter ved forvaltende organisasjon forvalte utdanningsbakgrunner.
  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet

  Regel: Opptaksforvalter bestemmer om opptaket bruker utdanningsbakgrunn

    Scenario: Opptaket bruker utdanningsbakgrunn
      Når opptaksforvalter angir at opptaket bruker utdanningsbakgrunn
      Så må søkere i opptaket oppgi utdanningsbakgrunn

    Scenario: Opptaket bruker ikke utdanningsbakgrunn
      Når opptaksforvalter angir at opptaket ikke bruker utdanningsbakgrunn
      Så blir ikke søkere i opptaket bedt om å oppgi utdanningsbakgrunn

  Regel: Opptaksforvalter oppretter og endrer utdanningsbakgrunnene i opptaket

    Scenario: Opprette utdanningsbakgrunn
      Når opptaksforvalter oppretter utdanningsbakgrunnen "Utenlandsk videregående" med koden "UTLVGS" i opptaket
      Så finnes utdanningsbakgrunnen "Utenlandsk videregående" i opptaket

    Scenario: Endre navn på utdanningsbakgrunn
      Gitt at utdanningsbakgrunnen "Utenlandsk vgs" med koden "UTLVGS" finnes i opptaket
      Når opptaksforvalter endrer navnet på utdanningsbakgrunnen til "Utenlandsk videregående"
      Så finnes utdanningsbakgrunnen "Utenlandsk videregående" i opptaket
      Og koden er fortsatt "UTLVGS"

    Scenario: Kode kan ikke endres
      Gitt at utdanningsbakgrunnen "Utenlandsk videregående" med koden "UTLVGS" finnes i opptaket
      Så kan ikke opptaksforvalter endre koden til utdanningsbakgrunnen

  Regel: Opptaksforvalter kan deaktivere utdanningsbakgrunner fram til søknaden åpner

    Scenario: Deaktivere utdanningsbakgrunn før søknaden åpner
      Gitt at søknaden i opptaket åpner "2027-02-01"
      Og at utdanningsbakgrunnen "Steinerskole" er aktiv i opptaket
      Når opptaksforvalter deaktiverer utdanningsbakgrunnen "Steinerskole" "2027-01-15"
      Så kan ikke søkere i opptaket velge "Steinerskole"

    Scenario: Utdanningsbakgrunn kan ikke deaktiveres etter at søknaden har åpnet
      Gitt at søknaden i opptaket åpnet "2027-02-01"
      Og at utdanningsbakgrunnen "Steinerskole" er aktiv i opptaket
      Så kan ikke opptaksforvalter deaktivere utdanningsbakgrunnen "Steinerskole"

  Regel: Opptaksforvalter kan kreve at søker oppgir utdanningsland

    Scenario: Kreve utdanningsland for utdanningsbakgrunn
      Når opptaksforvalter angir at utdanningsbakgrunnen "Utenlandsk videregående" krever utdanningsland
      Så må søkere som velger "Utenlandsk videregående" oppgi utdanningsland

    Scenario: Utdanningsbakgrunn uten krav om utdanningsland
      Gitt at utdanningsbakgrunnen "Realkompetanse" ikke krever utdanningsland
      Så blir ikke søkere som velger "Realkompetanse" bedt om utdanningsland

  Regel: Opptaksforvalter kan sperre utdanningsbakgrunner for søkere med GSK-konklusjon

    Scenario: Sperre utdanningsbakgrunn for søkere med GSK-konklusjon
      Når opptaksforvalter angir at utdanningsbakgrunnen "Realkompetanse" ikke kan velges av søkere med GSK-konklusjon
      Så kan ikke søkere med GSK-konklusjon velge "Realkompetanse"

  Regel: Opptaksforvalter kobler grunnlag for preutfylling til utdanningsbakgrunner

    Scenario: Koble GSK-konklusjon til utdanningsbakgrunn
      Når opptaksforvalter kobler GSK-konklusjonen "BAC" til utdanningsbakgrunnen "Utenlandsk videregående"
      Så preutfylles "Utenlandsk videregående" for søkere med GSK-konklusjonen "BAC"

    Scenario: Koble vitnemålstype til utdanningsbakgrunn
      Når opptaksforvalter kobler vitnemålstypen "Studieforberedende" til utdanningsbakgrunnen "Norsk videregående"
      Så preutfylles "Norsk videregående" for søkere med et studieforberedende vitnemål i kompetanseregisteret

  Regel: Utdanningsbakgrunn kan ha avvikende frister når opptaket tillater det

    Scenariomal: Sette avvikende frister for utdanningsbakgrunn
      Gitt at opptaket tillater avvikende søknadsfrister per utdanningsbakgrunn
      Når opptaksforvalter setter søknadsfrist "<søknadsfrist>" og dokumentasjonsfrist "<dokumentasjonsfrist>" for utdanningsbakgrunnen "<utdanningsbakgrunn>"
      Så gjelder disse fristene for søkere med utdanningsbakgrunnen "<utdanningsbakgrunn>"

      Eksempler:
        | utdanningsbakgrunn      | søknadsfrist     | dokumentasjonsfrist |
        | Realkompetanse          | 2027-03-01 23:59 | 2027-03-01 23:59    |
        | Utenlandsk videregående | 2027-03-01 23:59 | 2027-03-15 23:59    |

    Scenario: Søker med realkompetanse får avvikende frist
      Gitt at utdanningsbakgrunnen "Realkompetanse" har søknadsfrist "2027-03-01 23:59"
      Og at den generelle søknadsfristen er "2027-04-15 23:59"
      Når en søker søker med utdanningsbakgrunnen "Realkompetanse"
      Så gjelder søknadsfristen "2027-03-01 23:59" for denne søkeren

    Scenario: Utdanningsbakgrunn uten egne frister følger opptakets frister
      Gitt at utdanningsbakgrunnen "Norsk videregående" ikke har egne frister
      Når en søker søker med utdanningsbakgrunnen "Norsk videregående"
      Så gjelder de generelle fristene i opptaket

# ÅPNE SPØRSMÅL:
# - Trenger lærestedene valideringsregler for utdanningsbakgrunn? (fra Confluence)
