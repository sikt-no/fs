# language: no
@TIL-BRU-GRU-001 @must @draft
Egenskap: Søke opp bruker
  Som en brukeradministrator
  ønsker jeg å søke opp en bruker
  slik at jeg kan administrere brukerens roller.

  Bakgrunn:
    Gitt at brukeradministratoren er logget inn i FS Admin

  Regel: Brukeradministratoren kan søke etter brukere

    Scenario: Søke etter bruker med navn
      Når brukeradministratoren søker etter "Kari Nordmann"
      Så vises brukeren "Kari Nordmann" i søkeresultatet

    Scenario: Søke etter bruker med Feide-ID
      Når brukeradministratoren søker etter "kari@uio.no"
      Så vises brukeren med Feide-ID "kari@uio.no" i søkeresultatet

    Scenario: Søk som ikke gir treff
      Når brukeradministratoren søker etter "XYZ999FINNESIKKE"
      Så vises en melding om at ingen brukere ble funnet
