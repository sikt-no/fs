# language: no
# GitHub: #441
@BRU-APP-API-004 @must @planned
Egenskap: Passordbytte for applikasjon
  Som bruker
  ønsker jeg å sette nytt passord på en applikasjon jeg har rettighet til å administrere
  slik at jeg kan hjelpe med passordbytte.

  applikasjonen autentiserer seg med basic auth og har alltid kun ett
  aktivt passord om gangen. Passordet genereres av systemet.

  # Krav fra Confluence: K5 Sette nytt passord på API-bruker

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon

  Regel: Bruker kan kun endre passord på applikasjoner de har rettighet til å administrere

    Scenario: Passordbytte ikke tilgjengelig uten rettighet
      Gitt jeg ikke har rettighet til å endre passord på denne applikasjonen
      Så er muligheten til å sette nytt passord ikke tilgjengelig

  Regel: Nytt passord genereres av systemet

    Scenario: Generere nytt passord
      Gitt jeg har rettighet til å endre passord på denne applikasjonen
      Når jeg velger å generere et nytt passord
      Så genererer systemet et nytt passord for applikasjonen
      Og det nye passordet er lagret

  Regel: Det genererte passordet vises én gang og kan kopieres

    Scenario: Passordet er skjult som standard
      Gitt systemet nettopp har generert et nytt passord
      Så vises passordet skjult med mulighet for å velge å vise det
      Og passordet kan kopieres

    Scenario: Passordet kan ikke hentes opp igjen etter at dialogen er lukket
      Gitt systemet har generert et nytt passord som jeg har sett
      Når jeg lukker dialogen
      Så er passordet ikke lenger tilgjengelig
      Og jeg må generere et nytt passord dersom jeg trenger å se det på nytt

  Regel: Kun ett passord er aktivt om gangen

    Scenario: Nytt passord erstatter det gamle umiddelbart
      Gitt applikasjonen har et aktivt passord
      Når et nytt passord genereres
      Så fungerer ikke det gamle passordet lenger
      Og applikasjonen må autentisere seg med det nye passordet
