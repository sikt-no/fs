# language: no
@OPP-SØK-SØK-001 @must @nightly
Egenskap: Personsøk
  Som en administrator
  ønsker jeg å søke etter personer i systemet
  slik at jeg raskt kan finne og administrere personopplysninger.

  Personsøk lar administrator søke på tvers av flere identifikatorer
  i ett enkelt søkefelt: navn, fødselsnummer, studentnummer,
  Feide-brukernavn, e-post eller telefonnummer.

  Bakgrunn:
    Gitt at jeg er logget inn med tilgang til å lese personopplysninger
    Og at jeg er på personsøksiden

  Regel: Eksakt treff gir direkte navigering til personprofil

    @implemented
    Scenario: Søk på fullt navn gir direktetreff
      Når jeg søker etter "Økologisk Badering"
      Så skal jeg se personprofilen til "Økologisk Badering"

    @implemented
    Scenario: Søk på fødselsnummer gir direktetreff
      Når jeg søker etter "22820998719"
      Så skal jeg se personprofilen til "Økologisk Badering"

    @implemented
    Scenario: Søk på Feide-brukernavn gir direktetreff
      Når jeg søker etter "no310236284_elev_4_10a@testusers.feide.no"
      Så skal jeg se personprofilen til "Økologisk Badering"

    @implemented
    Scenario: Søk på e-post gir direktetreff
      Når jeg søker etter "no310236284_elev_4_10a@testusers.feide.no"
      Så skal jeg se personprofilen til "Økologisk Badering"

    @implemented
    Scenario: Søk på telefonnummer gir direktetreff
      Når jeg søker etter "99999912"
      Så skal jeg se personprofilen til "Økologisk Badering"

    @implemented
    Scenario: Søk på studentnummer gir direktetreff
      Når jeg søker etter "000002"
      Så skal jeg se personprofilen til "Økologisk Badering"

  Regel: Delvis treff gir liste med resultater

    @implemented
    Scenario: Søk på deler av navn gir liste
      Når jeg søker etter "Ba"
      Så skal jeg se en liste med søkeresultater
      Og listen skal inneholde "Økologisk Badering"
      Og listen skal inneholde "Familiær Bane"
      Og listen skal inneholde "Oppjaget Bas"

  Regel: Søk er case-insensitivt

    @implemented
    Scenariomal: Søk ignorerer store og små bokstaver
      Når jeg søker etter "<input>"
      Så skal jeg se personprofilen til "Økologisk Badering"

      Eksempler:
        | input              |
        | økologisk badering |
        | ØKOLOGISK BADERING |
        | ØkoLoGiSk BaDeRiNg |

  Regel: Søk gir tilbakemelding ved ingen treff

    @implemented
    Scenario: Søk uten treff viser informativ melding
      Når jeg søker etter "XyzFinnesIkke123"
      Så skal jeg se ingen resultater
