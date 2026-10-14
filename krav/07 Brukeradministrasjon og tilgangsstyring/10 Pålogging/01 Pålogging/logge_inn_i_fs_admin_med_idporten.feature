# language: no
# GitHub: #476
@TIL-PÅL-PÅL-005 @must @e2e @planned
Egenskap: Logge inn i FS Admin med ID-porten
  Som en administrator ved en fagskole uten Feide-konto
  ønsker jeg å logge inn i FS Admin med ID-porten
  slik at jeg får tilgangene jeg er tildelt uten å ha en Feide-identitet.

  Bakgrunn:
    Gitt at administratoren er på innloggingssiden til adminflaten

  Regel: En registrert person får tilgangene sine ved innlogging med ID-porten

    Scenario: Innlogget med ID-porten med tildelte roller
      Gitt at administratoren er registrert som person med fødselsnummer og har fått tildelt en rolle
      Når administratoren logger inn med ID-porten
      Så skal administratoren være innlogget
      Og administratoren ser tilgangene rollen gir

    Scenario: Innlogget med ID-porten uten tildelte roller
      Gitt at administratoren ikke er registrert som bruker i tilgangsstyring
      Når administratoren logger inn med ID-porten
      Så skal administratoren være innlogget
      Og administratoren har grunntilgangen FS Admin gir

  Regel: Brukeren velger selv innloggingsmetode

    Scenario: Feide og ID-porten tilbys som innloggingsmetoder
      Når administratoren velger å logge inn
      Så kan administratoren velge mellom å logge inn med Feide og å logge inn med ID-porten

  Regel: Avbrutt innlogging gir ingen økt

    Scenario: Administrator avbryter innloggingen hos ID-porten
      Når administratoren velger å logge inn med ID-porten
      Og administratoren avbryter innloggingen hos ID-porten
      Så er administratoren tilbake på innloggingssiden til adminflaten
      Og administratoren er ikke innlogget

  Regel: Utlogging avslutter også økten hos ID-porten

    Scenario: Administrator logger ut etter innlogging med ID-porten
      Gitt at administratoren er innlogget med ID-porten
      Når administratoren logger ut
      Så er administratoren ikke innlogget i FS Admin
      Og økten hos ID-porten er avsluttet
