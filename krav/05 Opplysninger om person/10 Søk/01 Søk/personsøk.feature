# language: no
@OPP-SØK-SØK-001 @must @nightly
Egenskap: Personsøk
  Som en administrator
  ønsker jeg å søke etter personer i systemet
  slik at jeg raskt kan finne og administrere personopplysninger.

  # ÅPNE SPØRSMÅL:
  # - Trenger ny Feide-bruker for personsøk-tester (annen enn eksisterende)

  Personsøk lar administrator søke på tvers av flere identifikatorer
  i ett enkelt søkefelt: navn, fødselsnummer, studentnummer,
  Feide-brukernavn, e-post eller telefonnummer.

  Bakgrunn:
    Gitt at jeg er logget inn som administrator
    Og at jeg er på personsøksiden

  Regel: Eksakt treff gir direkte navigering til personprofil

    @planned
    Scenario: Søk på fullt navn gir direktetreff
      Når jeg søker etter "Økologisk Badering"
      Så skal jeg se personprofilen til "Økologisk Badering"

    @planned
    Scenario: Søk på fødselsnummer gir direktetreff
      Når jeg søker etter "22820998719"
      Så skal jeg se personprofilen til "Økologisk Badering"

    @planned
    Scenario: Søk på Feide-brukernavn gir direktetreff
      Når jeg søker etter "no310236284_elev_4_10a@testusers.feide.no"
      Så skal jeg se personprofilen til "Økologisk Badering"

    @planned
    Scenario: Søk på e-post gir direktetreff
      Når jeg søker etter "no310236284_elev_4_10a@testusers.feide.no"
      Så skal jeg se personprofilen til "Økologisk Badering"

    @planned
    Scenario: Søk på telefonnummer gir direktetreff
      Når jeg søker etter "99999912"
      Så skal jeg se personprofilen til "Økologisk Badering"

    @planned
    Scenario: Søk på studentnummer gir direktetreff
      Når jeg søker etter "000002"
      Så skal jeg se personprofilen til "Økologisk Badering"

  Regel: Delvis treff gir liste med resultater

    @planned
    Scenario: Søk på deler av navn gir liste
      Når jeg søker etter "Badering"
      Så skal jeg se en liste med søkeresultater
      Og listen skal inneholde "Økologisk Badering"

    @planned
    Scenario: Søk med flere treff viser alle i liste
      Når jeg søker etter "Ba"
      Så skal jeg se en liste med søkeresultater
      Og listen skal inneholde "Økologisk Badering"

  Regel: Søk er case-insensitivt

    @planned
    Scenariomal: Søk ignorerer store og små bokstaver
      Når jeg søker etter "<input>"
      Så skal jeg se personprofilen til "Økologisk Badering"

      Eksempler:
        | input              |
        | økologisk badering |
        | ØKOLOGISK BADERING |
        | ØkoLoGiSk BaDeRiNg |

  Regel: Søk gir tilbakemelding ved ingen eller for mange treff

    @planned
    Scenario: Søk uten treff viser informativ melding
      Når jeg søker etter "XyzFinnesIkke123"
      Så skal jeg se "Ingen personer funnet"

    @planned
    Scenario: Søk med for mange treff ber om å begrense søket
      Når jeg søker etter "A"
      Så skal jeg se "For mange treff"
      Og jeg skal bli bedt om å begrense søket
