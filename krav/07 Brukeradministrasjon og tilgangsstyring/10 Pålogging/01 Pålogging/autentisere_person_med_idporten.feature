# language: no
# GitHub: mangler — opprettes når Min Kompetanse-integrasjonen planlegges
@TIL-PÅL-PÅL-004 @should @integration @in-progress
Egenskap: Autentisere personer mot FS GraphQL API med ID-porten
  Som en person som bruker Min Kompetanse
  ønsker jeg at forespørsler Min Kompetanse gjør på mine vegne godtas når jeg er innlogget med ID-porten
  slik at jeg kan bruke Min Kompetanse uten å ha en Feide-identitet.

  Bakgrunn:
    Gitt at personen har et gyldig token utstedt av ID-porten for FS GraphQL API
    Og at personen ikke er registrert som bruker i tilgangsstyring

  Regel: Tilgangene følger applikasjonen personen er innlogget gjennom

    Scenario: Person får grunntilgangen via Min Kompetanse
      Når Min Kompetanse sender en forespørsel til FS GraphQL API med personens ID-porten-token
      Så autentiseres forespørselen
      Og det interne tokenet inneholder grunntilgangen alle brukere har

    Scenario: Samme person får ingen organisasjonstilganger via FS Admin
      Når FS Admin sender en forespørsel til FS GraphQL API med personens ID-porten-token
      Så autentiseres forespørselen
      Og det interne tokenet inneholder ingen organisasjonstilganger
      Og personen har kun tilgang til det som er åpent for alle innloggede brukere

  Regel: Personen trenger ingen registrering i tilgangsstyring

    Scenario: Innlogging via Min Kompetanse registrerer ikke personen
      Når Min Kompetanse sender en forespørsel til FS GraphQL API med personens ID-porten-token
      Så er personen fortsatt ikke registrert som bruker i tilgangsstyring

  Regel: En applikasjon som ikke er registrert for ID-porten, får bare det som er åpent

    Scenario: Token utstedt til en ukjent klient
      Gitt at ID-porten-tokenet er utstedt til en klient som ikke er registrert som applikasjon i tilgangsstyring
      Når klienten sender en forespørsel til FS GraphQL API med personens ID-porten-token
      Så autentiseres forespørselen
      Og det interne tokenet inneholder ingen organisasjonstilganger
      Og personen har kun tilgang til det som er åpent for alle innloggede brukere

# ÅPNE SPØRSMÅL:
# - GitHub-issue mangler. Det opprettes når Min Kompetanse-integrasjonen planlegges.
# - Forutsetning utenfor kravet: Min Kompetanse må være registrert klient hos Digdir.
