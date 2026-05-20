# language: no
# GitHub: #444, #450
@BRU-APP-API-007 @must @planned
Egenskap: Tildele tilgang til applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å tildele en tilgang til en applikasjon for et gitt miljø og en gitt organisasjon
  slik at applikasjonen får tilgang til de dataene den trenger i riktig miljø.

  # Krav fra Confluence: K6 Tilordne rolle til API-bruker, K13 Tilordne rolle til API-bruker (selvbetjening)

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon

  Regel: En tildeling gjelder én tilgang i ett eksplisitt valgt miljø

    Scenario: Tildele en tilgang i valgt organisasjon og miljø
      Når jeg velger organisasjon, miljø og en tilgang jeg har rettighet til å tildele
      Så har applikasjonen fått den valgte tilgangen for den valgte kombinasjonen av organisasjon og miljø
      Og det fremgår tydelig hvilken organisasjon og hvilket miljø tildelingen gjelder

    Scenario: Tildele flere tilganger samtidig i valgt organisasjon og miljø
      Når jeg velger organisasjon, miljø og flere tilganger jeg har rettighet til å tildele
      Så har applikasjonen fått alle de valgte tilgangene for den valgte kombinasjonen av organisasjon og miljø

    Scenario: Tildele tilgang til en eksisterende FS-applikasjon
      Gitt applikasjonen har FS som identitetsleverandør
      Når jeg velger organisasjon, miljø og en tilgang jeg har rettighet til å tildele
      Så har applikasjonen fått den valgte tilgangen for den valgte kombinasjonen av organisasjon og miljø

  Regel: Bruker kan kun tildele tilganger de selv har rettighet til å tildele

    Scenario: Valglisten for tilgangskode avhenger av valgt organisasjon og miljø
      Gitt jeg har valgt organisasjon og miljø
      Når jeg åpner valglisten for tilgangskode
      Så vises kun tilgangskoder jeg har rettighet til å tildele for den valgte kombinasjonen av organisasjon og miljø

  Regel: En tilgang som allerede er tildelt for valgt kombinasjon av organisasjon og miljø kan ikke tildeles på nytt

    Scenario: Allerede tildelt tilgang vises som ikke-valgbar
      Gitt applikasjonen har en tilgang tildelt for en kombinasjon av organisasjon og miljø
      Når jeg åpner valglisten for å tildele tilganger for samme kombinasjon av organisasjon og miljø
      Så vises den allerede tildelte tilgangen som ikke valgbar
      Og det fremgår at tilgangen allerede er tildelt

  Regel: Tilgangstildeling gjelder en organisasjon administratoren har rettighet for (K13)

    Scenario: Organisasjon er implisitt når administrator har tilgang til kun én organisasjon
      Gitt jeg har tilgang til kun én organisasjon
      Når jeg velger et miljø og en tilgang jeg har rettighet til å tildele
      Så er tilgangen tildelt applikasjonen i det valgte miljøet for min organisasjon

    Scenario: Organisasjon velges når administrator har tilgang til flere organisasjoner
      Gitt jeg har tilgang til flere organisasjoner
      Når jeg velger en organisasjon, et miljø og en tilgang jeg har rettighet til å tildele
      Så er tilgangen tildelt applikasjonen for den valgte kombinasjonen av organisasjon og miljø

    Scenario: Valglisten for organisasjon er begrenset til organisasjoner jeg administrerer
      Gitt jeg har tilgang til flere organisasjoner
      Når jeg åpner valglisten for organisasjon
      Så ser jeg kun organisasjoner jeg har applikasjonsadministrator-rollen for

  Regel: En applikasjon kan ha tilganger i flere miljøer

    Scenario: Tildeling i nytt miljø gjør applikasjonen aktiv i miljøet
      Gitt applikasjonen ikke har tilganger i et gitt miljø
      Når jeg tildeler en tilgang i det miljøet
      Så er applikasjonen aktiv i miljøet
      Og applikasjonen autentiserer seg i det miljøet med sin identitetsleverandør

  Regel: Tilganger kan tildeles selv om applikasjonen er deaktivert

    Scenario: Tildele tilgang til deaktivert applikasjon
      Gitt applikasjonen er deaktivert
      Når jeg tildeler en tilgang
      Så er tilgangen registrert på applikasjonen
