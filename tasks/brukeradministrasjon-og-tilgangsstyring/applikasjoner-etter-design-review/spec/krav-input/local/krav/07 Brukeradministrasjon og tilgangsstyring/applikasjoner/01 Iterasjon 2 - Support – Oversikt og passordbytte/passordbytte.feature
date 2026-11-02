# language: no
# GitHub: #441
@BRU-APP-API-004 @must @implemented
Egenskap: Passordbytte for applikasjon
  Som bruker
  ønsker jeg å sette nytt passord på en applikasjon jeg har rettighet til å administrere
  slik at jeg kan hjelpe med passordbytte.

  Passordbytte gjelder kun applikasjoner med FS som identitetsleverandør.
  De autentiserer seg med basic auth, mens Feide- og Maskinporten-
  applikasjoner autentiserer seg mot sin egen identitetsleverandør og har
  ikke passord i FS Admin.

  Passordet genereres av systemet, og settes per miljø: applikasjonen har
  samme identitet i alle miljøer, men ett eget passord i hvert av dem.
  Innenfor ett miljø er kun ett passord aktivt om gangen. Passordet er
  uavhengig av tilganger — en applikasjon kan ha passord i et miljø den
  ikke har tilganger i.

  # Krav fra Confluence: K5 Sette nytt passord på API-bruker

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon

  Regel: Passordbytte gjelder kun applikasjoner med FS som identitetsleverandør

    Scenario: Passordbytte er tilgjengelig for FS-applikasjoner
      Gitt applikasjonen har FS som identitetsleverandør
      Og jeg har rettighet til å endre passord på denne applikasjonen
      Så har jeg mulighet til å sette nytt passord

    Scenario: Passordbytte er ikke tilgjengelig for Feide- og Maskinporten-applikasjoner
      Gitt applikasjonen har Feide eller Maskinporten som identitetsleverandør
      Så er muligheten til å sette nytt passord ikke tilgjengelig

  Regel: Bruker kan kun endre passord på applikasjoner de har rettighet til å administrere

    Scenario: Passordbytte ikke tilgjengelig uten rettighet
      Gitt jeg ikke har rettighet til å endre passord på denne applikasjonen
      Så er muligheten til å sette nytt passord ikke tilgjengelig

  @deprecated
  Regel: Nytt passord genereres av systemet

    Scenario: Generere nytt passord
      Gitt jeg har rettighet til å endre passord på denne applikasjonen
      Når jeg velger å generere et nytt passord
      Så genererer systemet et nytt passord for applikasjonen
      Og det nye passordet er lagret

  @planned
  Regel: Nytt passord genereres av systemet for ett valgt miljø

    Scenario: Generere nytt passord for et miljø
      Gitt jeg har rettighet til å endre passord på denne applikasjonen
      Når jeg velger et miljø og velger å generere et nytt passord
      Så genererer systemet et nytt passord for applikasjonen i det valgte miljøet
      Og det nye passordet er lagret for det miljøet

    Scenario: Passord i ett miljø påvirker ikke de andre
      Gitt applikasjonen har et aktivt passord i flere miljøer
      Når jeg genererer et nytt passord i ett av miljøene
      Så er passordene i de øvrige miljøene uendret

    Scenario: Passord kan settes for et miljø applikasjonen ikke har tilganger i
      Gitt applikasjonen ikke har tilganger i et miljø
      Når jeg genererer et nytt passord for det miljøet
      Så er passordet lagret for miljøet

  Regel: Det genererte passordet vises én gang og kan kopieres

    Scenario: Passordet er skjult som standard
      Gitt systemet nettopp har generert et nytt passord
      Så vises passordet skjult med mulighet for å velge å vise det
      Og passordet kan kopieres

    Scenario: Passordet kan ikke hentes opp igjen etter at visningen er lukket
      Gitt systemet har generert et nytt passord som jeg har sett
      Når jeg lukker visningen av passordet
      Så er passordet ikke lenger tilgjengelig
      Og jeg må generere et nytt passord dersom jeg trenger å se det på nytt

  @deprecated
  Regel: Kun ett passord er aktivt om gangen

    Scenario: Nytt passord erstatter det gamle umiddelbart
      Gitt applikasjonen har et aktivt passord
      Når et nytt passord genereres
      Så fungerer ikke det gamle passordet lenger
      Og applikasjonen må autentisere seg med det nye passordet

  @planned
  Regel: Kun ett passord er aktivt per miljø om gangen

    Scenario: Nytt passord erstatter det gamle i samme miljø
      Gitt applikasjonen har et aktivt passord i et miljø
      Når et nytt passord genereres for det miljøet
      Så fungerer ikke det gamle passordet lenger i det miljøet
      Og applikasjonen må autentisere seg med det nye passordet i det miljøet
