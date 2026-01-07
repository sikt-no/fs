# language: no
@skip @støtteprosesser @sikkerhet
Egenskap: Tilgangsstyring ansatt-bruker
  Som systemadministrator ved organisasjon som bruker FS til studieadministrasjon, trenger jeg å vite at det kun er aktive, autoriserte brukere som får tilgang til å se data om våre søkere og studenter (tidligere og aktive), for å sikre deres data/opplysninger og personvern, sikkerhet og personvern.
  
  # Person-bruker skal alltlid ha tilgang til sine egne data via personbrukerflaten. Mulig at ansatte skal ha tilgang til å se data registrert om seg via FS Admin, men det er ikke utforsket ennå.

  Bakgrunn:
    Gitt at bruker er på startsiden i FS Admin
    Gitt at bruker er systemadministrator for organisasjon
    #må se på hva som er gitt her...

  Scenario: bruker er ikke systemadministrator
    Når bruker ikke er systemadministrator
    Så får person ikke se tilgangsstyring
    #ta bort? nødvendig? rollespesifikasjon

  Scenariomal: systemadministrator får se organisasjonens integrasjonsbrukere med tilganger
    Når "<systemadministrator>" er på "<en side>"
    Så får systemadministrator se "<integrasjonsbrukere>" "<med tilganger>" og "<tilgangsperiode>"

    Eksempler:
      | systemadministrator | en side   | integrasjonsbrukere                                                                                                            | med tilganger |
      | Ada Utløpt Nilsen   | startside | Din FS-bruker er utløpt 12.03.2024. Du har ikke lenger tilgang til FS Admin ved Sikthøyskolen                                  | bla           |
      | Abel Låst Hansen    | personsøk | Din FS-bruker er låst 01.06.2023 på grunn av manglende passordbytte. Du har ikke lenger tilgang til FS Admin ved Sikthøyskolen | bla           |

  Scenario: systemadministrator kan legge til ny integrasjonsbruker
    Når systemadmin står på side
    Så får systemadmin legge til ny integrasjonsbruker
    Så får systemadmin sette aktiv periode for integrasjonsbruker

  Scenario: systemadministrator får endre integrasjonsbruker (flere ulike scenarier??)

  Scenario: systemadministrator får deaktivere integrasjonsbruker

  Scenario: motta forespørsel om tilgang fra API-brukere

  Scenario: avslå forespørsel om tilgang-brukere
    Sikt kan administrere
    selvbetjening ved læresteder som tredje scenario

  Scenario: godta forespørsel om tilgang fra API-brukere
