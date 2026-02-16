# language: no
@TIL-TIL-TIL-004 @must @støtteprosesser @sikkerhet
Egenskap: Administrasjon av maskinbrukere
  Som en administrator med ansvar for maskinbrukere
  ønsker jeg å ha oversikt over og kunne administrere maskinbrukere
  slik at jeg kan sikre kontroll over API-tilganger til organisasjonens data.

  # Til senere:
  # - Flere rolle typer. Mule teamet. Benyttende org.
  # - Kanskje ikke det må være org, men kan være team. Tilgangsgruppe?
  # - Hva med reglen om å ha flere passord samtidig med overlapp?
  # - Legacy Passord vs Nytt passord

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
  Regel: Brukere ser maskinbrukere innenfor sitt organisasjonsscope

    Org-scopede roller ser maskinbrukere der organisasjonen er
    administrerende eller benyttende. ADMIN-roller ser alle maskinbrukere.

    @must @planned
    Scenario: Bruker med tildelt BRUKERADMIN_WSBRUKER_LES ser maskinbrukere for tildelt organisasjon
      Gitt bruker med tildelt rolle "BRUKERADMIN_WSBRUKER_LES" for "UiO"
      Når brukeren ser i listen over maskinbrukere
      Så ser brukeren følgende maskinbrukere:
        | maskinbruker    |
        | UIO_INTEGRASJON |
        | UIO_TEST        |
        | FELLES_RAPPORT  |

    @must @planned
    Scenario: Bruker med tildelt ADMIN_LES ser alle maskinbrukere
      Gitt bruker med tildelt rolle "ADMIN_LES"
      Når brukeren ser i listen over maskinbrukere
      Så ser brukeren alle maskinbrukere

    @must @planned
    Scenario: Maskinbrukeroversikten viser nøkkelinformasjon
      Gitt bruker med tildelt rolle "ADMIN_LES"
      Når brukeren ser i listen over maskinbrukere
      Så vises følgende informasjon for hver maskinbruker:
        | felt                                   |
        | Navn                                   |
        | Kontaktperson                          |
        | Administrerende organisasjon           |
        | APIene maskinbruker har tilgang til     |
        | Miljø                                  |
        | Handling kreves                        |

  @should
  Regel: Brukere kan søke og filtrere i maskinbrukerlisten

    @should @planned
    Scenariomal: Søk etter maskinbruker på <felt>
      Gitt brukeren ser i listen over maskinbrukere
      Når brukeren søker etter "<søketerm>" i maskinbrukerlisten
      Så vises "<resultat>" i listen

      Eksempler:
        | felt                         | søketerm    | resultat                   |
        | navn                         | LAANE       | LAANEKASSEN_BRUKER         |
        | kontaktperson                | Kari Hansen | LAANEKASSEN_BRUKER         |
        | administrerende organisasjon | Sikt        | LAANEKASSEN_BRUKER         |
        | API                          | FS-GraphQL  | LAANEKASSEN_BRUKER         |
        | miljø                        | demo        | UIO_TEST                   |
        | ingen treff                  | XYZ         | Ingen maskinbrukere funnet |

    @should @planned
    Scenariomal: Filtrere maskinbrukerlisten på <filter>
      Når brukeren filtrerer listen på <filter> "<verdi>"
      Så vises kun maskinbrukere som matcher "<verdi>" i listen

      Eksempler:
        | filter                       | verdi               |
        | API                          | FS-GraphQL          |
        | miljø                        | produksjon          |
        | miljø                        | demo                |
        | administrerende organisasjon | Sikt                |
        | handling kreves              | Krever passordbytte |

  @must
  Regel: Detaljvisning viser maskinbrukerens datatilganger

    @must @planned
    Scenario: Bruker åpner detaljvisning for en maskinbruker
      Gitt bruker med tildelt rolle "ADMIN_LES"
      Og brukeren ser i listen over maskinbrukere
      Når brukeren åpner detaljvisningen for "LAANEKASSEN_BRUKER"
      Så vises kontaktpersonens kontaktinformasjon:
        | felt          |
        | Epost         |
        | Telefonnummer |
      Og vises maskinbrukerens datatilganger med følgende informasjon:
        | felt                     |
        | API tilganger            |
        | Datatilgangsroller       |
        | Beskrivelse av tilgangen |
        | Organisasjon             |

    @must @planned
    Scenario: Detaljvisning viser alle datatilgangsroller for maskinbruker med tilgang til flere organisasjoner
      Gitt bruker med tildelt rolle "ADMIN_LES"
      Når brukeren åpner detaljvisningen for "LAANEKASSEN_BRUKER"
      Så vises datatilgangsroller for alle organisasjoner maskinbrukeren har tilgang til

  @must
  Regel: Kun brukere med skriverettigheter kan bytte passord, begrenset til administrerende organisasjon

    Passordbytte krever BRUKERADMIN_WSBRUKER_SKRIV eller ADMIN_FULL.
    Org-scopede brukere kan kun bytte passord der tildelt organisasjon
    er administrerende organisasjon for maskinbrukeren.

    @must @planned
    Scenario: Bruker med tildelt BRUKERADMIN_WSBRUKER_SKRIV bytter passord for maskinbruker administrert av tildelt organisasjon
      Gitt bruker med tildelt rolle "BRUKERADMIN_WSBRUKER_SKRIV" for "UiO"
      Når brukeren bytter passord for "UIO_INTEGRASJON"
      Så bekreftes det at passordet er endret

    # TODO: Skrive om denne
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
    Scenario: Nytt passord vises kun én gang ved passordbytte
      Gitt bruker med tildelt rolle "BRUKERADMIN_WSBRUKER_SKRIV" for "UiO"
      Når brukeren bytter passord for "UIO_INTEGRASJON"
      Så vises det nye passordet én gang
      Og passordet er ikke tilgjengelig etter at brukeren navigerer bort

    @must @planned
    Scenario: Bruker med tildelt ADMIN_FULL bytter passord for vilkårlig maskinbruker
      Gitt bruker med tildelt rolle "ADMIN_FULL"
      Når brukeren bytter passord for "LAANEKASSEN_BRUKER"
      Så bekreftes det at passordet er endret

    @must @planned
    Scenario: Bruker med kun lesetilgang kan ikke bytte passord
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
