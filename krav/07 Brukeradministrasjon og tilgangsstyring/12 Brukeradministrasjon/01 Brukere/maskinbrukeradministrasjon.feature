      # language: no
      @TIL-TIL-TIL-004 @must @støtteprosesser @sikkerhet
      Egenskap: Administrasjon av maskinbrukere
      Som en administrator med ansvar for maskinbrukere
      ønsker jeg å ha oversikt over og kunne administrere maskinbrukere
      slik at jeg kan sikre kontroll over API-tilganger til organisasjonens data.

      Bakgrunn:
      Gitt følgende roller finnes:
      | rolle                      | scope | rettigheter             |
      | BRUKERADMIN_WSBRUKER_LES   | org   | Lesetilgang             |
      | BRUKERADMIN_WSBRUKER_SKRIV | org   | Lese, opprette og endre |
      | ADMIN_LES                  | alle  | Lesetilgang             |
      | ADMIN_FULL                 | alle  | Full tilgang            |
      Og følgende maskinbrukere finnes:
      | maskinbruker       | beskrivelse              | kontaktperson | administrerende org | benyttende org | miljø      |
      | LAANEKASSEN_BRUKER | Lånekassens integrasjon  | Kari Hansen   | Sikt                | Lånekassen     | produksjon |
      | SIO_BRUKER         | SiO studentsamskipnaden  | Per Olsen     | Sikt                | SiO            | produksjon |
      | UIO_INTEGRASJON    | UiOs interne integrasjon | Erik Berg     | UiO                 | UiO            | produksjon |
      | FELLES_RAPPORT     | Rapportering på tvers    | Liv Dahl      | Sikt                | NTNU, UiO      | produksjon |
      | UIO_TEST           | UiOs testintegrasjon     | Erik Berg     | UiO                 | UiO            | demo       |

  @must
  Regel: Aktører ser maskinbrukere innenfor sitt organisasjonsscope

  Org-scopede roller ser maskinbrukere der organisasjonen er
  administrerende eller benyttende. ADMIN-roller ser alle maskinbrukere.

  @must @planned
  Scenario: Bruker med tildelt BRUKERADMIN_WSBRUKER_LES ser maskinbrukere for tildelt organisasjon
      Gitt bruker med tildelt rolle "BRUKERADMIN_WSBRUKER_LES" for "UiO"
      Når brukeren åpner maskinbrukeroversikten
      Så ser brukeren følgende maskinbrukere:
      | maskinbruker    |
      | UIO_INTEGRASJON |
      | UIO_TEST        |
      | FELLES_RAPPORT  |

  @must @planned
  Scenario: Bruker med tildelt ADMIN_LES ser alle maskinbrukere
  Gitt bruker med tildelt rolle "ADMIN_LES"
  Når brukeren åpner maskinbrukeroversikten
  Så ser brukeren alle maskinbrukere

  @must @planned
  Scenario: Maskinbrukeroversikten viser nøkkelinformasjon
      Gitt bruker med tildelt rolle "ADMIN_LES"
      Når brukeren åpner maskinbrukeroversikten
      Så vises følgende informasjon for hver maskinbruker:
      | felt                         |
      | Navn                         |
      | Beskrivelse                  |
      | Kontaktperson                |
      | Administrerende organisasjon |
      | Benyttende organisasjoner    |
      | Miljø                        |
      | Handling kreves              |

      @should
      Regel: Aktører kan søke og filtrere i maskinbrukerlisten

      @should @planned
      Scenariomal: Søk etter maskinbruker på <felt>
      Gitt bruker med tildelt rolle "ADMIN_LES"
      Og brukeren er på maskinbrukeroversikten
      Når brukeren søker etter "<søketerm>" i maskinbrukerlisten
      Så vises "<resultat>" i listen

      Eksempler:
      | felt          | søketerm    | resultat                   |
      | navn          | LAANE       | LAANEKASSEN_BRUKER         |
      | beskrivelse   | integrasjon | UIO_INTEGRASJON            |
      | kontaktperson | Kari Hansen | LAANEKASSEN_BRUKER         |
      | ingen treff   | XYZ         | Ingen maskinbrukere funnet |

  @should @planned
  Scenario: Filtrere maskinbrukerlisten på API
      Gitt bruker med tildelt rolle "ADMIN_LES"
      Og brukeren er på maskinbrukeroversikten
      Når brukeren filtrerer listen på API "FS-GraphQL"
      Så vises kun maskinbrukere med tilgang til "FS-GraphQL" i listen

      @should @planned
      Scenariomal: Filtrere maskinbrukerlisten på miljø
      Gitt bruker med tildelt rolle "ADMIN_LES"
      Og brukeren er på maskinbrukeroversikten
      Når brukeren filtrerer listen på miljø "<miljø>"
      Så vises kun maskinbrukere i "<miljø>" i listen

      Eksempler:
      | miljø      |
      | produksjon |
      | demo       |

  @should @planned
  Scenario: Filtrere maskinbrukerlisten på administrerende organisasjon
  Gitt bruker med tildelt rolle "ADMIN_LES"
    Og brukeren er på maskinbrukeroversikten
    Når brukeren filtrerer listen på administrerende organisasjon "Sikt"
    Så vises kun maskinbrukere administrert av "Sikt" i listen

  @should @planned
  Scenario: Filtrere maskinbrukerlisten på handling kreves
    Gitt bruker med tildelt rolle "ADMIN_LES"
    Og brukeren er på maskinbrukeroversikten
    Når brukeren filtrerer listen på "Krever passordbytte"
    Så vises kun maskinbrukere som krever passordbytte i listen

  @must
  Regel: Detaljvisning viser maskinbrukerens datatilganger

  @must @planned
  Scenario: Aktør åpner detaljvisning for en maskinbruker
      Gitt bruker med tildelt rolle "ADMIN_LES"
      Og brukeren er på maskinbrukeroversikten
      Når brukeren åpner detaljvisningen for "LAANEKASSEN_BRUKER"
      Så vises maskinbrukerens datatilganger med følgende informasjon:
      | felt         |
      | API          |
      | Rolle        |
      | Organisasjon |

  @must @planned
  Scenario: Detaljvisning viser alle datatilganger for maskinbruker med tilgang til flere organisasjoner
    Gitt bruker med tildelt rolle "ADMIN_LES"
    Når brukeren åpner detaljvisningen for "LAANEKASSEN_BRUKER"
    Så vises datatilganger for alle organisasjoner maskinbrukeren har tilgang til

  @must
  Regel: Kun aktører med skriverettigheter kan bytte passord, begrenset til administrerende organisasjon

  Passordbytte krever BRUKERADMIN_WSBRUKER_SKRIV eller ADMIN_FULL.
  Org-scopede aktører kan kun bytte passord der tildelt organisasjon
  er administrerende organisasjon for maskinbrukeren.

  @must @planned
  Scenario: Nytt passord vises kun én gang ved passordbytte
    Gitt bruker med tildelt rolle "BRUKERADMIN_WSBRUKER_SKRIV" for "UiO"
    Når brukeren bytter passord for "UIO_INTEGRASJON"
    Så vises det nye passordet én gang
    Og passordet er ikke tilgjengelig etter at brukeren navigerer bort

  @must @planned
  Scenario: Bruker med tildelt BRUKERADMIN_WSBRUKER_SKRIV bytter passord for maskinbruker administrert av tildelt organisasjon
    Gitt bruker med tildelt rolle "BRUKERADMIN_WSBRUKER_SKRIV" for "UiO"
    Når brukeren bytter passord for "UIO_INTEGRASJON"
    Så bekreftes det at passordet er endret

  @must @planned
  Scenario: Bruker med tildelt BRUKERADMIN_WSBRUKER_SKRIV kan ikke bytte passord utenfor tildelt organisasjon
    Gitt bruker med tildelt rolle "BRUKERADMIN_WSBRUKER_SKRIV" for "UiO"
    Når brukeren forsøker å bytte passord for "SIO_BRUKER"
    Så avvises handlingen med beskjed om manglende tilgang

  @must @planned
  Scenario: Bruker med tildelt BRUKERADMIN_WSBRUKER_SKRIV kan ikke bytte passord for maskinbruker den kun benytter
    Gitt bruker med tildelt rolle "BRUKERADMIN_WSBRUKER_SKRIV" for "UiO"
    Når brukeren forsøker å bytte passord for "FELLES_RAPPORT"
    Så avvises handlingen med beskjed om manglende tilgang

  @must @planned
  Scenario: Bruker med tildelt ADMIN_FULL bytter passord for vilkårlig maskinbruker
    Gitt bruker med tildelt rolle "ADMIN_FULL"
    Når brukeren bytter passord for "LAANEKASSEN_BRUKER"
    Så bekreftes det at passordet er endret

  @must @planned
  Scenario: Aktør med kun lesetilgang kan ikke bytte passord
    Gitt bruker med tildelt rolle "BRUKERADMIN_WSBRUKER_LES" for "UiO"
    Når brukeren forsøker å bytte passord for "UIO_INTEGRASJON"
    Så avvises handlingen med beskjed om manglende tilgang

  @must @planned
  Scenario: Detaljvisning viser at maskinbruker krever passordbytte
    Gitt bruker med tildelt rolle "BRUKERADMIN_WSBRUKER_LES" for "UiO"
    Og maskinbrukeren "UIO_INTEGRASJON" krever passordbytte
    Når brukeren åpner detaljvisningen for "UIO_INTEGRASJON"
    Så vises det tydelig at maskinbrukeren krever passordbytte

  @must @planned
  Scenario: Bruker med tildelt BRUKERADMIN_WSBRUKER_SKRIV bytter passord fra detaljvisningen
    Gitt bruker med tildelt rolle "BRUKERADMIN_WSBRUKER_SKRIV" for "UiO"
    Og maskinbrukeren "UIO_INTEGRASJON" krever passordbytte
    Når brukeren åpner detaljvisningen for "UIO_INTEGRASJON"
    Og brukeren bytter passord for maskinbrukeren
    Så vises det nye passordet én gang
    Og maskinbrukeren krever ikke lenger passordbytte
