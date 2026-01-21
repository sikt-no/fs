# language: no
@DEM-PER-PER-001 @demo
Egenskap: Personsøk
  Som en administrator av FS-systemet
  ønsker jeg å søke etter personer i personregisteret
  slik at jeg raskt kan finne og administrere personopplysninger.

  Bakgrunn:
    Gitt at administrator er inne på personsøket

  Regel: Eksakt søk gir direktetreff til personprofil

    Scenario: Søk på fullt navn gir direktetreff
      Når administrator søker på "Erik Nordmann"
      Så ser administrator personprofilen til "Erik Nordmann"

    Scenario: Søk på fødselsnummer gir direktetreff
      Når administrator søker på "12345678901"
      Så ser administrator personprofilen til personen

  Regel: Delvis søk gir liste med treff

    Scenario: Søk på deler av navn gir liste med treff
      Når administrator søker på "Nord"
      Så får administrator se en liste med treff

  Regel: Søk gir tilbakemelding ved ingen eller for mange treff

    Scenario: Søk uten treff gir informativ melding
      Når administrator søker på "XyzFinnesIkke123"
      Så ser administrator "Ingen personer funnet"

    Scenario: Søk med for mange treff ber om å begrense søket
      Når administrator søker på "A"
      Så ser administrator "For mange treff. Vennligst begrens søket."
