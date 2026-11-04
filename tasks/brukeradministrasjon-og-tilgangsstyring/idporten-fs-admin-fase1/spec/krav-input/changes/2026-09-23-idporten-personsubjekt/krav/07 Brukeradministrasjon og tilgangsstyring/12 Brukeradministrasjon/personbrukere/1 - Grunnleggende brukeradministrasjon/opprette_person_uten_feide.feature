# language: no
# GitHub: #629
@BRU-PER-GRU-013 @must @planned
Egenskap: Opprette person uten Feide-konto
  Som en administrator
  ønsker jeg å registrere en ansatt som ikke har Feide-konto og gi henne tilganger
  slik at hun kan bruke FS Admin fra første gang hun logger inn med ID-porten.

  Bakgrunn:
    Gitt at administratoren har rettighet til å administrere personer uten Feide-konto i en organisasjon

  Regel: Fødselsnummeret identifiserer personen

    Scenario: Registrere en ansatt som ikke finnes fra før
      Gitt at administratoren kjenner den ansattes fødselsnummer og navn
      Og den ansatte ikke er registrert som bruker fra før
      Når administratoren registrerer den ansatte og tildeler en rolle i sin egen organisasjon
      Så opprettes personen som bruker
      Og personen har den tildelte rollen

    Scenario: Registrere en ansatt som allerede er registrert
      Gitt at den ansatte allerede er registrert som bruker på sitt fødselsnummer
      Når administratoren registrerer den ansatte og tildeler en rolle i sin egen organisasjon
      Så opprettes ingen ny person
      Og den nye rollen legges til på den eksisterende personen

    Scenario: Fødselsnummeret er ikke gyldig
      Gitt at administratoren oppgir noe annet enn et gyldig fødselsnummer eller D-nummer
      Når administratoren forsøker å registrere den ansatte
      Så avvises registreringen
      Og ingen person opprettes

  Regel: Flyten er atskilt fra Feide-flyten

    Scenario: Rettighet for Feide-brukere gir ikke tilgang til denne flyten
      Gitt at administratoren kun har rettighet til å administrere Feide-brukere
      Når administratoren forsøker å registrere en ansatt uten Feide-konto
      Så avvises operasjonen

    Scenario: Rettighet for personer uten Feide gir ikke tilgang til Feide-flyten
      Gitt at administratoren kun har rettighet til å administrere personer uten Feide-konto
      Når administratoren forsøker å administrere en Feide-bruker
      Så avvises operasjonen

  Regel: Registreringen skjer før den ansatte har logget inn

    Scenario: Tilgangen gjelder ved første innlogging
      Gitt at administratoren har registrert den ansatte og tildelt en rolle
      Og den ansatte aldri har logget inn i FS Admin
      Når den ansatte logger inn med ID-porten for første gang
      Så gjenkjennes hun som den registrerte personen
      Og hun har tilgangene rollen gir

  Regel: Navnet følger personen

    Scenario: Navnet registreres sammen med personen
      Gitt at administratoren registrerer en ansatt som ikke finnes fra før
      Når personen opprettes
      Så lagres navnet administratoren oppga
      Og det er sporbart hvem som opprettet personen

  Regel: Synlighet følger tildelingene

    Scenario: Administratoren ser personen hun har gitt tilgang
      Gitt at administratoren har registrert en ansatt og tildelt en rolle i sin egen organisasjon
      Når administratoren søker opp den ansatte
      Så finner hun personen

    Scenario: Administratoren ser tilgangene hun har gitt
      Gitt at administratoren har tildelt den ansatte roller i sin egen organisasjon
      Når administratoren åpner den ansattes tilganger
      Så ser hun rollene hun har tildelt

    Scenario: En administrator i en annen organisasjon ser ikke personen
      Gitt at den ansatte kun har tildelinger i én organisasjon
      Når en administrator uten rettighet i den organisasjonen søker opp den ansatte
      Så finner hun ingen person

    Scenario: En registrering i en annen organisasjon røpes ikke
      Gitt at den ansatte er registrert med tildelinger kun i en organisasjon administratoren ikke har rettighet i
      Når administratoren registrerer den ansatte og tildeler en rolle i sin egen organisasjon
      Så legges rollen til på den eksisterende personen
      Og administratoren ser kun tildelingene hun selv har gitt

  Regel: En person fjernes ved at alle tildelinger fjernes

    Scenario: Personen mister tilgangen når tildelingen fjernes
      Gitt at den ansatte har én tildeling, gitt av administratoren
      Når administratoren fjerner tildelingen
      Så har den ansatte ingen organisasjonstilganger
      Og den ansatte er ikke lenger synlig for administratoren

    Scenario: Den ansatte beholder tilganger gitt av andre
      Gitt at den ansatte har tildelinger i to organisasjoner
      Når administratoren fjerner tildelingen i sin egen organisasjon
      Så beholder den ansatte tildelingen i den andre organisasjonen
