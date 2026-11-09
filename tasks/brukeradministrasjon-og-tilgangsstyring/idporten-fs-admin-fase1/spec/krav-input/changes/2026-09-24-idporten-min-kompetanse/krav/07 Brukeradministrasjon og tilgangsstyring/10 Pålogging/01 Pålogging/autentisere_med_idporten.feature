# language: no
# GitHub: #476
@TIL-PÅL-PÅL-003 @must @integration @in-progress
Egenskap: Autentisere mot FS GraphQL API med ID-porten
  Som en saksbehandler ved en fagskole uten Feide-konto
  ønsker jeg at forespørsler FS Admin gjør på mine vegne godtas når jeg er innlogget med ID-porten
  slik at jeg kan bruke FS Admin uten å ha en Feide-identitet.

  Bakgrunn:
    Gitt at saksbehandleren har et gyldig token utstedt av ID-porten

  Regel: ID-porten er en egen utsteder i coprocessoren, uavhengig av Feide

    Scenario: Gyldig ID-porten-token godtas
      Når FS Admin sender en forespørsel til FS GraphQL API med saksbehandlerens ID-porten-token
      Så autentiseres forespørselen
      Og det utstedes et internt token med saksbehandlerens identitet
      Og autentiseringsmetoden i det interne tokenet er "idporten"

    Scenario: Token med ugyldig signatur eller utløpt gyldighet avvises
      Gitt at ID-porten-tokenet er utløpt eller har ugyldig signatur
      Når FS Admin sender en forespørsel til FS GraphQL API med tokenet
      Så avvises forespørselen som uautentisert
      Og forespørselen når ikke subgrafene

  Regel: Tokenet må være utstedt for FS GraphQL API

    Scenario: Token utstedt for en annen tjeneste avvises
      Gitt at ID-porten-tokenet er utstedt med en annen audiens enn FS GraphQL API
      Når FS Admin sender en forespørsel til FS GraphQL API med tokenet
      Så avvises forespørselen som uautentisert
      Og forespørselen når ikke subgrafene

  Regel: Autentiseringsnivået (acr) bæres videre, men håndheves ikke i fase 1

    Scenariomal: Autentiseringsnivå fra ID-porten bæres i det interne tokenet
      Gitt at ID-porten-tokenet har autentiseringsnivå "<acr>"
      Når FS Admin sender en forespørsel til FS GraphQL API med tokenet
      Så autentiseres forespørselen
      Og det interne tokenet bærer autentiseringsnivå "<acr>"

      Eksempler:
        | acr                      |
        | idporten-loa-substantial |
        | idporten-loa-high        |
        | selfregistered-email     |

  Regel: Tilgangssettet følger personens tildelinger

    Scenario: Innlogget med ID-porten uten tildelte roller
      Gitt at saksbehandleren ikke er registrert som bruker i tilgangsstyring
      Når FS Admin sender en forespørsel til FS GraphQL API med saksbehandlerens ID-porten-token
      Så autentiseres forespørselen
      Og det interne tokenet inneholder ingen organisasjonstilganger
      Og saksbehandleren har kun tilgang til det som er åpent for alle innloggede brukere

    Scenario: Innlogget med ID-porten med tildelte roller
      Gitt at saksbehandleren er registrert som bruker og har fått tildelt en rolle
      Når FS Admin sender en forespørsel til FS GraphQL API med saksbehandlerens ID-porten-token
      Så autentiseres forespørselen
      Og det interne tokenet inneholder organisasjonstilgangene rollen gir

  Regel: ID-portens testmiljø kan brukes i utvikling og test

    Scenario: Token fra ID-portens testmiljø godtas i syntetiske datamiljøer
      Gitt at saksbehandleren har et gyldig token utstedt av ID-portens testmiljø
      Når FS Admin sender en forespørsel til FS GraphQL API mot et syntetisk datamiljø
      Så autentiseres forespørselen

    Scenario: Token fra ID-portens testmiljø avvises mot produksjonsdata
      Gitt at saksbehandleren har et gyldig token utstedt av ID-portens testmiljø
      Når FS Admin sender en forespørsel til FS GraphQL API mot et miljø med produksjonsdata
      Så avvises forespørselen som uautentisert
      Og forespørselen når ikke subgrafene

# ÅPNE SPØRSMÅL:
# - Forutsetning utenfor kravet: Sikt må være registrert klient hos Digdir (fase 0). Ikke bestilt
#   per 18.09.2026.
