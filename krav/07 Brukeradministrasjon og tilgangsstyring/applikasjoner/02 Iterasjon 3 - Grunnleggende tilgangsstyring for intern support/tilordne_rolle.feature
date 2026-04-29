# language: no
# GitHub: #444, #450
@BRU-APP-API-007 @must @planned
Egenskap: Tilordne rolle til applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å tilordne en rolle til en applikasjon for et gitt miljø og en gitt organisasjon
  slik at applikasjonen får tilgang til de dataene den trenger i riktig miljø.

  # Krav fra Confluence: K6 Tilordne rolle til API-bruker, K13 Tilordne rolle til API-bruker (selvbetjening)

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon

  Regel: En tilordning gjelder én rolle i ett eksplisitt valgt miljø

    Scenario: Tilordne en rolle i et valgt miljø
      Når jeg velger et miljø og en rolle jeg har rettighet til å tildele
      Så har applikasjonen fått den valgte rollen i det valgte miljøet
      Og det fremgår tydelig hvilket miljø og hvilken organisasjon tilordningen gjelder

    Scenario: Tilordne flere roller samtidig i ett valgt miljø
      Når jeg velger et miljø og flere roller jeg har rettighet til å tildele
      Så har applikasjonen fått alle de valgte rollene i det valgte miljøet

  Regel: Bruker kan kun tildele roller de selv har rettighet til å tildele

    Scenario: Valglisten viser kun roller jeg har rettighet til å tildele
      Når jeg åpner valglisten for å tilordne en rolle
      Så ser jeg kun roller jeg har rettighet til å tildele

  Regel: En rolle som allerede er tildelt i valgt miljø kan ikke tilordnes på nytt

    Scenario: Allerede tildelt rolle vises som ikke-valgbar
      Gitt applikasjonen har en rolle tildelt i et miljø
      Når jeg åpner valglisten for å tilordne roller i samme miljø
      Så vises den allerede tildelte rollen gråtonet og ikke valgbar
      Og det fremgår at rollen allerede er tildelt

  Regel: Rolletildeling gjelder en organisasjon administratoren har rettighet for (K13)

    Scenario: Organisasjon er implisitt når administrator har tilgang til kun én organisasjon
      Gitt jeg har tilgang til kun én organisasjon
      Når jeg velger et miljø og en rolle jeg har rettighet til å tildele
      Så er rollen tildelt applikasjonen i det valgte miljøet for min organisasjon

    Scenario: Organisasjon velges når administrator har tilgang til flere organisasjoner
      Gitt jeg har tilgang til flere organisasjoner
      Når jeg velger et miljø, en organisasjon og en rolle jeg har rettighet til å tildele
      Så er rollen tildelt applikasjonen i det valgte miljøet for den valgte organisasjonen

    Scenario: Valglisten for organisasjon er begrenset til organisasjoner jeg administrerer
      Gitt jeg har tilgang til flere organisasjoner
      Når jeg åpner valglisten for organisasjon
      Så ser jeg kun organisasjoner jeg har applikasjonsadministrator-rollen for

  Regel: En applikasjon kan ha roller i flere miljøer

    Scenario: Tildeling i nytt miljø gjør applikasjonen aktiv i miljøet
      Gitt applikasjonen ikke har roller i et gitt miljø
      Når jeg tildeler en rolle i det miljøet
      Så er applikasjonen aktiv i miljøet
      Og applikasjonen autentiserer seg i det miljøet med sin valgte autentiseringstype
