# language: no
# GitHub: #441
@BRU-APP-API-004 @must @draft
Egenskap: Passordbytte for API-bruker
  Som bruker
  ønsker jeg å sette nytt passord på en API-bruker jeg har rettighet til å administrere
  slik at jeg kan hjelpe med passordbytte.

  # Krav fra Confluence: K5 Sette nytt passord på API-bruker

  Regel: Bruker kan kun endre passord på API-brukere de har rettighet til å administrere

    Scenario: Sette nytt passord
      Gitt jeg er på detaljsiden for en API-bruker
      Og jeg har rettighet til å endre passord på denne API-brukeren
      Når jeg setter et nytt passord
      Så er det nye passordet lagret for API-brukeren

    Scenario: Passordbytte ikke tilgjengelig uten rettighet
      Gitt jeg er på detaljsiden for en API-bruker
      Og jeg ikke har rettighet til å endre passord på denne API-brukeren
      Så er muligheten til å sette nytt passord ikke tilgjengelig
