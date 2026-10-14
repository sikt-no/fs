# language: no
# GitHub: #476
@TIL-PÅL-PÅL-005 @must @e2e @draft
Egenskap: Logge inn i FS Admin med ID-porten
  Som en saksbehandler ved en fagskole uten Feide-konto
  ønsker jeg å kunne logge inn i FS Admin med ID-porten
  slik at jeg kan bruke FS Admin uten å ha en Feide-identitet.

  Bakgrunn:
    Gitt at administratoren er på innloggingssiden til adminflaten

  Regel: Brukeren velger selv innloggingsmetode

    Scenario: Feide og ID-porten tilbys som innloggingsmetoder
      Når administratoren velger å logge inn
      Så kan administratoren velge mellom å logge inn med Feide og å logge inn med ID-porten

  Regel: Innlogging med ID-porten gir en innlogget økt i FS Admin

    Scenario: Saksbehandler logger inn med ID-porten
      Når administratoren logger inn med ID-porten
      Så skal administratoren være innlogget
      Og administratoren er innlogget med ID-porten

    Scenario: Innlogget med ID-porten uten tildelte roller
      Gitt at saksbehandleren ikke er registrert som bruker i tilgangsstyring
      Når administratoren logger inn med ID-porten
      Så skal administratoren være innlogget
      Og administratoren har kun tilgang til det som er åpent for alle innloggede brukere

  Regel: Avbrutt innlogging gir ingen økt

    Scenario: Saksbehandler avbryter innloggingen hos ID-porten
      Når administratoren velger å logge inn med ID-porten
      Og administratoren avbryter innloggingen hos ID-porten
      Så er administratoren tilbake på innloggingssiden til adminflaten
      Og administratoren er ikke innlogget

  Regel: Utlogging avslutter også økten hos ID-porten

    Scenario: Saksbehandler logger ut etter innlogging med ID-porten
      Gitt at administratoren er innlogget med ID-porten
      Når administratoren logger ut
      Så er administratoren ikke innlogget i FS Admin
      Og økten hos ID-porten er avsluttet

# ÅPNE SPØRSMÅL:
# - Forutsetning utenfor kravet: Sikt må være registrert klient hos Digdir (fase 0). Ikke bestilt
#   per 18.09.2026. Til da kan innloggingen bare testes mot ID-portens testmiljø.
# - Audiens: FS Admin må be om et token med FS GraphQL API som audiens, slik at det godtas etter
#   TIL-PÅL-PÅL-003. Hvordan dette settes i autorisasjonsflyten er ikke avklart.
