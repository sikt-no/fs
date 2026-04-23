# language: no
# GitHub: #447
@BRU-APP-API-010 @must @draft
Egenskap: Deaktivere API-bruker
  Som bruker
  ønsker jeg å deaktivere en API-bruker
  slik at en API-bruker som ikke lenger er i bruk ikke kan benyttes.

  # Krav fra Confluence: K9 Deaktivere API-bruker

  Scenario: Deaktivere en aktiv API-bruker
    Gitt jeg er på detaljsiden for en aktiv API-bruker
    Når jeg deaktiverer API-brukeren
    Så er API-brukeren ikke lenger aktiv
    Og API-brukeren kan ikke benyttes til autentisering
