# language: no
# GitHub: TBD
@BRU-PER-GRU-007 @must @implemented
Egenskap: Se detaljer for personbruker
  Som brukeradministrator
  ønsker jeg å se detaljer for en personbruker, organisert i logiske datagrupper,
  slik at jeg har oversikt over personbrukeren.

  Hjemorganisasjonen er organisasjonen personbrukeren hører hjemme i, hentet fra Feide, og
  den er personbrukerens ansettelsesrelasjon. Den er noe annet enn organisasjonen en tildeling
  gjelder for. En personbruker kan være koblet til flere Feide-brukere, og har da én
  hjemorganisasjon for hver av dem. Tildelingene kan gjelde ved andre organisasjoner enn
  hjemorganisasjonene. Hjemorganisasjonen til en Feide-bruker kan ikke endres.

  Bakgrunn:
    Gitt jeg er på detaljsiden for en personbruker

  Regel: Detaljer organiseres i logiske datagrupper

    Scenario: Se navn
      Så ser jeg personbrukerens navn

    Scenario: Se Feide-ID
      Så ser jeg personbrukerens Feide-ID

    Scenario: Se hjemorganisasjon
      Så ser jeg personbrukerens hjemorganisasjon

    @draft
    Scenariomal: Se <felt> for en personbruker med flere Feide-brukere
      Gitt personbrukeren er koblet til flere Feide-brukere
      Så viser «<felt>» <verdi>, kommaseparert

      Eksempler:
        | felt             | verdi                                       |
        | Feide-ID         | Feide-ID-ene til alle Feide-brukerne        |
        | Hjemorganisasjon | hjemorganisasjonene til alle Feide-brukerne |

    @draft
    Scenario: Se en personbruker uten Feide-bruker
      Gitt personbrukeren ikke er koblet til noen Feide-bruker
      Så viser «Feide-ID» «-»
      Og «Hjemorganisasjon» viser «-»

    @draft
    Scenario: Se miljø
      Så ser jeg miljøene personbrukeren har tildelinger i

    Scenario: Hjemorganisasjonen er ukjent
      Gitt domenet i personbrukerens Feide-ID ikke er registrert på noen organisasjon
      Så ser jeg at personbrukeren ikke har en hjemorganisasjon
      Men organisasjonene personbrukerens tildelinger gjelder for, vises ikke som hjemorganisasjon

    @deprecated
    Scenario: Se status
      Så ser jeg om personbrukeren er aktiv eller deaktivert

  @draft
  Regel: Oppsummeringen øverst på detaljsiden viser aktive roller og miljøer
    # Oppsummeringen står over fanene, og vises både i «Detaljer» og «Roller».

    Scenario: Se antall aktive roller i oppsummeringen
      Så viser oppsummeringen hvor mange aktive roller personbrukeren har
      Og serveren avgjør hva som er en aktiv rolle

    Scenario: Se miljøene i oppsummeringen
      Så viser oppsummeringen miljøene personbrukeren har tildelinger i

  @draft @openquestion
  Regel: Sist brukt (planlagt etter v1)
    # ÅPNE SPØRSMÅL:
    # - Backend har ikke støtte for dette: tidspunktet personbrukeren sist brukte løsningen lagres ikke. Hvordan og hvor skal det registreres?

    Scenario: Se sist brukt
      Så ser jeg tidspunktet personbrukeren sist brukte løsningen
