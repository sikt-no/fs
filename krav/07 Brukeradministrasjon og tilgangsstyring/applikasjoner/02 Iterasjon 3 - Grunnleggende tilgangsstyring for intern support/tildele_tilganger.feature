# language: no
# GitHub: #444, #450
@BRU-APP-API-007 @must @planned
Egenskap: Tildele tilganger til en applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å tildele en tilgang til en applikasjon for et gitt miljø og en gitt organisasjon
  slik at applikasjonen får tilgang til de dataene den trenger i riktig miljø.

  # Krav fra Confluence: K6 Tilordne rolle til API-bruker, K13 Tilordne rolle til API-bruker (selvbetjening)

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en applikasjon

  Regel: En tildeling gjelder én tilgang i ett eksplisitt valgt miljø

    Scenario: Tildele en tilgang i valgt organisasjon og miljø
      Når jeg velger en organisasjon, et miljø og en tilgang jeg har rettighet til å tildele
      Så er tilgangen tildelt applikasjonen for den valgte kombinasjonen av organisasjon og miljø
      Og det fremgår tydelig hvilken organisasjon og hvilket miljø tildelingen gjelder

    Scenario: Tildele flere tilganger samtidig i valgt organisasjon og miljø
      Når jeg velger en organisasjon, et miljø og flere tilganger jeg har rettighet til å tildele
      Så er tilgangene tildelt applikasjonen for den valgte kombinasjonen av organisasjon og miljø

    Scenario: Tildele tilgang til en eksisterende FS-applikasjon
      Gitt applikasjonen har FS som identitetsleverandør
      Når jeg velger en organisasjon, et miljø og en tilgang jeg har rettighet til å tildele
      Så er tilgangen tildelt applikasjonen for den valgte kombinasjonen av organisasjon og miljø

  Regel: Tilgangstildeling gjelder en organisasjon administratoren har rettighet for (K13)

    Scenario: Organisasjon er implisitt når administrator har tilgang til kun én organisasjon
      Gitt jeg har tilgang til kun én organisasjon
      Når jeg velger et miljø og en tilgang jeg har rettighet til å tildele
      Så er tilgangen tildelt applikasjonen i det valgte miljøet for min organisasjon

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

  Regel: Tilganger kan tildeles selv om applikasjonen er deaktivert

    Scenario: Tildele tilgang til deaktivert applikasjon
      Gitt applikasjonen er deaktivert
      Når jeg tildeler en tilgang
      Så er tilgangen registrert på applikasjonen

# ÅPNE SPØRSMÅL:
# - Hvordan skal delvis suksess håndteres når flere tilganger tildeles i én operasjon og bare noen av dem lykkes? Skal de gyldige tildelingene gjennomføres, eller skal hele operasjonen avvises? BRU-PER-GRU-009 spesifiserer delvis gjennomføring for personbrukere, mens opprettelsen av maskinbruker-applikasjoner er besluttet alt-eller-ingenting. De to bør samkjøres.
# - Er tildeling av tilgang sporbar i endringsloggen? BRU-PER-GRU-009 slår fast at hver tildeling er sporbar i historikk, mens BRU-APP-API-016 fortsatt har det som åpent spørsmål hvilke handlinger som skal loggføres.
