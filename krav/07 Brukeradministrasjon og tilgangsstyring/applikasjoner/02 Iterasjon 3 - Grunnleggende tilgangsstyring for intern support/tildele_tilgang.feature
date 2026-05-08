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

    Scenario: Tildele en tilgang i et valgt miljø
      Når jeg velger et miljø og en tilgang jeg har rettighet til å tildele
      Så har applikasjonen fått den valgte tilgangen i det valgte miljøet
      Og det fremgår tydelig hvilket miljø og hvilken organisasjon tildelingen gjelder

    Scenario: Tildele flere tilganger samtidig i ett valgt miljø
      Når jeg velger et miljø og flere tilganger jeg har rettighet til å tildele
      Så har applikasjonen fått alle de valgte tilgangene i det valgte miljøet

  Regel: Bruker kan kun tildele tilganger de selv har rettighet til å tildele

    Scenario: Valglisten viser kun tilganger jeg har rettighet til å tildele
      Når jeg åpner valglisten for å tildele en tilgang
      Så ser jeg kun tilganger jeg har rettighet til å tildele

  Regel: En tilgang som allerede er tildelt i valgt miljø kan ikke tildeles på nytt

    Scenario: Allerede tildelt tilgang vises som ikke-valgbar
      Gitt applikasjonen har en tilgang tildelt i et miljø
      Når jeg åpner valglisten for å tildele tilganger i samme miljø
      Så vises den allerede tildelte tilgangen gråtonet og ikke valgbar
      Og det fremgår at tilgangen allerede er tildelt

  Regel: Tilgangstildeling gjelder en organisasjon administratoren har rettighet for (K13)

    Scenario: Organisasjon er implisitt når administrator har tilgang til kun én organisasjon
      Gitt jeg har tilgang til kun én organisasjon
      Når jeg velger et miljø og en tilgang jeg har rettighet til å tildele
      Så er tilgangen tildelt applikasjonen i det valgte miljøet for min organisasjon

    Scenario: Organisasjon velges når administrator har tilgang til flere organisasjoner
      Gitt jeg har tilgang til flere organisasjoner
      Når jeg velger et miljø, en organisasjon og en tilgang jeg har rettighet til å tildele
      Så er tilgangen tildelt applikasjonen i det valgte miljøet for den valgte organisasjonen

    Scenario: Valglisten for organisasjon er begrenset til organisasjoner jeg administrerer
      Gitt jeg har tilgang til flere organisasjoner
      Når jeg åpner valglisten for organisasjon
      Så ser jeg kun organisasjoner jeg har applikasjonsadministrator-rollen for

  Regel: En applikasjon kan ha tilganger i flere miljøer

    Scenario: Tildeling i nytt miljø gjør applikasjonen aktiv i miljøet
      Gitt applikasjonen ikke har tilganger i et gitt miljø
      Når jeg tildeler en tilgang i det miljøet
      Så er applikasjonen aktiv i miljøet
      Og applikasjonen autentiserer seg i det miljøet med sin valgte autentiseringstype
