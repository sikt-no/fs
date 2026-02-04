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

  @implemented
  Regel: Det er mulig å søke på navn

    Scenario: Søk på fullt navn
      Når jeg søker etter "Økologisk Badering"
      Så skal jeg se personprofilen til "Økologisk Badering"

    Scenario: Søk på fornavn
      Når jeg søker etter "Økologisk"
      Så skal jeg se personprofilen til "Økologisk Badering"

    Scenario: Søk på etternavn
      Når jeg søker etter "Badering"
      Så skal jeg se personprofilen til "Økologisk Badering"

    Scenario: Søk på deler av navn
      Når jeg søker etter "Ba"
      Så skal jeg se en liste med søkeresultater
      Og listen skal inneholde "Økologisk Badering"
      Og listen skal inneholde "Familiær Bane"
      Og listen skal inneholde "Oppjaget Bas"

  @implemented
  Regel: Det er mulig å søke på fødselsnummer

    Scenario: Søk på fullt fødselsnummer
      Når jeg søker etter "22820998719"
      Så skal jeg se personprofilen til "Økologisk Badering"

  @implemented
  Regel: Det er mulig å søke på Feide-brukernavn

    Scenario: Søk på fullt Feide-brukernavn
      Når jeg søker etter "no310236284_elev_4_10a@testusers.feide.no"
      Så skal jeg se personprofilen til "Økologisk Badering"

  @implemented
  Regel: Det er mulig å søke på e-postadresse

    Scenario: Søk på full e-postadresse
      Når jeg søker etter "no310236284_elev_4_10a@testusers.feide.no"
      Så skal jeg se personprofilen til "Økologisk Badering"

  @implemented
  Regel: Det er mulig å søke på telefonnummer

    Scenario: Søk på telefonnummer
      Når jeg søker etter "99999912"
      Så skal jeg se personprofilen til "Økologisk Badering"

  @implemented
  Regel: Det er mulig å søke på studentnummer

    Scenario: Søk på studentnummer
      Når jeg søker etter "000002"
      Så skal jeg se personprofilen til "Økologisk Badering"

  @implemented
  Regel: Søk er case-insensitivt

    Scenariomal: Søk ignorerer store og små bokstaver
      Når jeg søker etter "<input>"
      Så skal jeg se personprofilen til "Økologisk Badering"

      Eksempler:
        | input              |
        | økologisk badering |
        | ØKOLOGISK BADERING |
        | ØkoLoGiSk BaDeRiNg |

  @implemented
  Regel: Søk gir tilbakemelding ved ingen treff

    Scenario: Søk uten treff viser informativ melding
      Når jeg søker etter "XyzFinnesIkke123"
      Så skal jeg se ingen resultater
