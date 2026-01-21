# language: no
@demo

Egenskap: Organisasjonssøk
  Som en administrator av FS-systemet
  ønsker jeg å søke etter organisasjoner
  slik at jeg raskt kan finne og se informasjon om læresteder, fakulteter og institutter.

  Bakgrunn:
    Gitt at administrator er inne på organisasjonssøket

  Regel: Eksakt søk gir direktetreff til organisasjonsprofil

    Scenario: Søk på organisasjonsnavn gir direktetreff
      Når administrator søker på "Universitetet i Oslo"
      Så ser administrator organisasjonsprofilen til "Universitetet i Oslo"
      Og profilen viser navn, type og adresse

    Scenario: Søk på organisasjonsnummer gir direktetreff
      Når administrator søker på "971035854"
      Så ser administrator organisasjonsprofilen til organisasjonen

    Scenario: Søk på kortnavn gir direktetreff
      Når administrator søker på "UiO"
      Så ser administrator organisasjonsprofilen til "Universitetet i Oslo"

  Regel: Delvis søk gir liste med treff

    Scenario: Søk på deler av navn gir liste med treff
      Når administrator søker på "Universitet"
      Så får administrator se en liste med organisasjoner

  Regel: Søk gir tilbakemelding ved ingen treff

    Scenario: Søk uten treff gir informativ melding
      Når administrator søker på "XyzFinnesIkke123"
      Så ser administrator "Ingen organisasjoner funnet"
