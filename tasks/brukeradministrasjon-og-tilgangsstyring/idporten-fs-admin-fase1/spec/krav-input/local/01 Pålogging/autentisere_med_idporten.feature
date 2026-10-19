# language: no
# GitHub: #476
@TIL-PÅL-PÅL-003 @must @integration @planned
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

  Regel: Tilgangssettet er tomt inntil ikke-Feide-brukere er innført i tilgangsstyring

    Scenario: Innlogget med ID-porten uten tildelte roller
      Gitt at saksbehandleren ikke er registrert som bruker i tilgangsstyring
      Når FS Admin sender en forespørsel til FS GraphQL API med saksbehandlerens ID-porten-token
      Så autentiseres forespørselen
      Og det interne tokenet inneholder ingen organisasjonstilganger
      Og saksbehandleren har kun tilgang til det som er åpent for alle innloggede brukere

  Regel: ID-portens testmiljø kan brukes i utvikling og test

    @openquestion
    Scenario: Token fra ID-portens testmiljø godtas i syntetiske datamiljøer
      # ÅPNE SPØRSMÅL:
      # - Skal testutstederen behandles som test-Maskinporten, altså kun godtas mot syntetiske
      #   datamiljøer og avvises mot produksjonsdata?
      Gitt at saksbehandleren har et gyldig token utstedt av ID-portens testmiljø
      Når FS Admin sender en forespørsel til FS GraphQL API mot et syntetisk datamiljø
      Så autentiseres forespørselen

# ÅPNE SPØRSMÅL:
# - Audiens: hvilken audiens skal coprocessoren kreve på ID-porten-tokenet? Kan FS GraphQL API
#   settes som audiens i autorisasjonsflyten fs-admin starter, eller trengs token exchange som
#   for Feide? Confluence (fase 1) forutsetter direkte validering uten exchange.
# - Hva blir subjektet i det interne tokenet for en ID-porten-bruker: fødselsnummer (pid) eller
#   ID-portens egen sub?
# - Forutsetning utenfor kravet: Sikt må være registrert klient hos Digdir (fase 0). Ikke bestilt
#   per 18.09.2026.
