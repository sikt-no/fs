# language: no
# GitHub: #632
#
# Del av initiativ #215 Utdanningsbakgrunn i søknad om opptak.
# Kilder: Confluence PFS 4408344578 «Utdanningsbakgrunn» og
# PFS 3940188262 «2025-08-15: Utdanningsbakgrunn - Møte med HK-dir».
# Figma: Min kompetanse, node 20670-24098. Team Tind-epic TOT-1738.
#
# Hvilke utdanningsbakgrunner som finnes og hvordan de er satt opp, står i
# utdanningsbakgrunn.feature (@OPT-OPT-UBG-001). Frist for å endre
# utdanningsbakgrunn står i frister_og_tidsperioder.feature.
#
@OPT-SØK-SØK-005 @must @draft
Egenskap: Velge utdanningsbakgrunn i søknad
  Som søker
  ønsker jeg å oppgi hvilken utdanningsbakgrunn jeg har
  slik at søknaden min behandles av riktig instans og etter riktige regler.

  Bakgrunn:
    Gitt at søkeren er innlogget i Min kompetanse
    Og at søkeren har startet en søknad i opptaket "Samordna opptak 2027"
    Og at opptaket bruker utdanningsbakgrunn
    Og at opptaket har de aktive utdanningsbakgrunnene
      | utdanningsbakgrunn      |
      | Norsk videregående      |
      | Utenlandsk videregående |
      | Steinerskole            |
      | Realkompetanse          |

  Regel: Søker velger blant utdanningsbakgrunnene som er aktive i opptaket

    Scenario: Velge utdanningsbakgrunn
      Når søkeren velger utdanningsbakgrunnen "Steinerskole"
      Så er "Steinerskole" registrert som utdanningsbakgrunn på søknaden

    Scenario: Deaktivert utdanningsbakgrunn kan ikke velges
      Gitt at utdanningsbakgrunnen "IB" er deaktivert i opptaket
      Så kan ikke søkeren velge "IB"

    Scenario: Utdanningsbakgrunn velges per søknad
      Gitt at søkeren har valgt "Steinerskole" i søknaden til "Samordna opptak 2027"
      Når søkeren starter en søknad i opptaket "Lokalt opptak høst 2027"
      Så er ikke "Steinerskole" registrert som utdanningsbakgrunn på den nye søknaden

  Regel: Søker må oppgi utdanningsbakgrunn når opptaket bruker det

    Scenario: Utdanningsbakgrunn mangler
      Gitt at søkeren ikke har valgt utdanningsbakgrunn
      Så kan ikke søkeren sende inn søknaden
      Og søkeren får forklart at utdanningsbakgrunn må velges

    Scenario: Opptak som ikke bruker utdanningsbakgrunn
      Gitt at opptaket "Lokalt opptak høst 2027" ikke bruker utdanningsbakgrunn
      Når søkeren starter en søknad i opptaket "Lokalt opptak høst 2027"
      Så blir ikke søkeren bedt om å oppgi utdanningsbakgrunn

  Regel: Søker oppgir utdanningsland når utdanningsbakgrunnen krever det

    Scenario: Oppgi utdanningsland
      Gitt at utdanningsbakgrunnen "Utenlandsk videregående" krever utdanningsland
      Når søkeren velger utdanningsbakgrunnen "Utenlandsk videregående"
      Og søkeren velger utdanningslandet "Tyskland"
      Så er "Tyskland" registrert som utdanningsland på søknaden

    Scenario: Nordiske land kan velges som utdanningsland
      Gitt at utdanningsbakgrunnen "Utenlandsk videregående" krever utdanningsland
      Når søkeren velger utdanningsbakgrunnen "Utenlandsk videregående"
      Så kan søkeren velge "Sverige" som utdanningsland

    Scenario: Påkrevd utdanningsland mangler
      Gitt at utdanningsbakgrunnen "Utenlandsk videregående" krever utdanningsland
      Og at søkeren har valgt "Utenlandsk videregående" uten å oppgi utdanningsland
      Så kan ikke søkeren sende inn søknaden
      Og søkeren får forklart at utdanningsland må oppgis

  Regel: Utdanningsbakgrunn og utdanningsland preutfylles fra søkerens GSK-konklusjon eller vitnemål

    Scenario: Utdanningsbakgrunn preutfylles fra GSK-konklusjon
      Gitt at GSK-konklusjonen "BAC" er koblet til utdanningsbakgrunnen "Utenlandsk videregående"
      Og at søkeren har GSK-konklusjonen "BAC" fra et tidligere opptak
      Så er "Utenlandsk videregående" preutfylt som utdanningsbakgrunn på søknaden

    Scenario: Utdanningsland preutfylles fra GSK-konklusjon
      Gitt at søkeren har GSK-konklusjonen "BAC" fra et tidligere opptak
      Så er "Frankrike" preutfylt som utdanningsland på søknaden

    Scenario: Siste GSK-konklusjon styrer utdanningsland
      Gitt at søkeren fikk en GSK-konklusjon med utdanningslandet "Tyskland" i "Samordna opptak 2025"
      Og at søkeren fikk GSK-konklusjonen "BAC" i "Samordna opptak 2026"
      Så er "Frankrike" preutfylt som utdanningsland på søknaden

    Scenario: Utdanningsbakgrunn preutfylles fra vitnemål
      Gitt at vitnemålstypen "Studieforberedende" er koblet til utdanningsbakgrunnen "Norsk videregående"
      Og at søkeren har et studieforberedende vitnemål i kompetanseregisteret
      Så er "Norsk videregående" preutfylt som utdanningsbakgrunn på søknaden

    Scenario: Søker kan endre preutfylt utdanningsbakgrunn
      Gitt at "Utenlandsk videregående" er preutfylt som utdanningsbakgrunn på søknaden
      Når søkeren velger utdanningsbakgrunnen "Steinerskole"
      Så er "Steinerskole" registrert som utdanningsbakgrunn på søknaden

  Regel: Søker med GSK-konklusjon kan ikke velge utdanningsbakgrunner som er sperret for dem

    Scenario: Søker med GSK-konklusjon kan ikke velge realkompetanse
      Gitt at utdanningsbakgrunnen "Realkompetanse" ikke kan velges av søkere med GSK-konklusjon
      Og at søkeren har en GSK-konklusjon fra et tidligere opptak
      Så kan ikke søkeren velge "Realkompetanse"

    Scenario: Søker uten GSK-konklusjon kan velge realkompetanse
      Gitt at utdanningsbakgrunnen "Realkompetanse" ikke kan velges av søkere med GSK-konklusjon
      Og at søkeren ikke har en GSK-konklusjon
      Når søkeren velger utdanningsbakgrunnen "Realkompetanse"
      Så er "Realkompetanse" registrert som utdanningsbakgrunn på søknaden

  @could
  Regel: Utdanningsland fra en tidligere søknad foreslås

    Scenario: Utdanningsland fra tidligere søknad preutfylles
      Gitt at søkeren oppga utdanningslandet "Tyskland" i en søknad til "Samordna opptak 2026"
      Og at søkeren ikke har en GSK-konklusjon som gir utdanningsland
      Når søkeren velger utdanningsbakgrunnen "Utenlandsk videregående"
      Så er "Tyskland" preutfylt som utdanningsland på søknaden

    Scenario: GSK-konklusjon går foran tidligere søknad
      Gitt at søkeren oppga utdanningslandet "Tyskland" i en søknad til "Samordna opptak 2026"
      Og at søkeren har GSK-konklusjonen "BAC" fra et tidligere opptak
      Så er "Frankrike" preutfylt som utdanningsland på søknaden

# ÅPNE SPØRSMÅL:
# - Skal søker få en forklaring på hvorfor en utdanningsbakgrunn er preutfylt,
#   eller hvorfor realkompetanse ikke kan velges? HK-dir-møtet peker på at god
#   informasjon om hvorfor er viktig.
