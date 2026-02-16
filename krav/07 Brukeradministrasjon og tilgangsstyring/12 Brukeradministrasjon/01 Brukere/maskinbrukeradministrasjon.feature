# language: no
@TIL-TIL-TIL-004 @must @støtteprosesser @sikkerhet
Egenskap: Administrasjon av maskinbrukere
  Som en administrator med ansvar for maskinbrukere
  ønsker jeg å ha oversikt over og kunne administrere maskinbrukere
  slik at jeg kan sikre kontroll over API-tilganger til organisasjonens data.

  # Roller:
  # - BRUKERADMIN_WSBRUKER_LES (org-scoped): Lesetilgang til maskinbrukere
  # - BRUKERADMIN_WSBRUKER_SKRIV (org-scoped): Lese, opprette og endre maskinbrukere
  # - ADMIN_LES (ikke org-scoped): Lesetilgang til alle maskinbrukere
  # - ADMIN_FULL (ikke org-scoped): Full tilgang til alle maskinbrukere

  Bakgrunn:
    Gitt følgende maskinbrukere finnes:
      | maskinbruker       | beskrivelse             | kontaktperson | adm. org | benyttende org | tilgang            |
      | LAANEKASSEN_BRUKER | Lånekassens integrasjon | Kari Hansen   | Sikt     | Lånekassen     | Alle org, alle API |
      | SIO_BRUKER         | SiO studentsamskipnaden | Per Olsen     | Sikt     | SiO            | Studentdata SiO    |
      | UIO_INTEGRASJON    | UiOs interne integrasjon| Erik Berg     | UiO      | UiO            | Egne data UiO      |
      | FELLES_RAPPORT     | Rapportering på tvers   | Liv Dahl      | Sikt     | NTNU, UiO      | Rapportdata        |

  @must
  Regel: Aktører ser maskinbrukere innenfor sitt organisasjonsscope

    Org-scopede roller ser maskinbrukere der organisasjonen er
    administrerende eller benyttende. ADMIN-roller ser alle maskinbrukere.

    @must @planned
    Scenario: Organisasjonsadmin ser maskinbrukere knyttet til sin organisasjon
      Gitt aktøren har rollen "BRUKERADMIN_WSBRUKER_LES" for "UiO"
      Når aktøren åpner maskinbrukeroversikten
      Så ser aktøren følgende maskinbrukere:
        | maskinbruker    |
        | UIO_INTEGRASJON |
        | FELLES_RAPPORT  |

    @must @planned
    Scenario: Sikt-admin ser alle maskinbrukere
      Gitt aktøren har rollen "ADMIN_LES"
      Når aktøren åpner maskinbrukeroversikten
      Så ser aktøren alle maskinbrukere

    @must @planned
    Scenario: Maskinbrukeroversikten viser nøkkelinformasjon
      Gitt aktøren har rollen "ADMIN_LES"
      Når aktøren åpner maskinbrukeroversikten
      Så vises følgende informasjon for hver maskinbruker:
        | felt                         |
        | Navn                         |
        | Beskrivelse                  |
        | Kontaktperson                |
        | Administrerende organisasjon |
        | Benyttende organisasjoner    |

  @should
  Regel: Aktører kan søke og filtrere i maskinbrukerlisten

    @should @planned
    Scenariomal: Søk etter maskinbruker på <felt>
      Gitt aktøren har rollen "ADMIN_LES"
      Og aktøren er på maskinbrukeroversikten
      Når aktøren søker etter "<søketerm>" i maskinbrukerlisten
      Så vises "<resultat>" i listen

      Eksempler:
        | felt          | søketerm    | resultat                   |
        | navn          | LAANE       | LAANEKASSEN_BRUKER         |
        | beskrivelse   | integrasjon | UIO_INTEGRASJON            |
        | kontaktperson | Kari Hansen | LAANEKASSEN_BRUKER         |
        | ingen treff   | XYZ         | Ingen maskinbrukere funnet |

    @should @planned
    Scenario: Filtrere maskinbrukerlisten på API
      Gitt aktøren har rollen "ADMIN_LES"
      Og aktøren er på maskinbrukeroversikten
      Når aktøren filtrerer listen på API "FS-GraphQL"
      Så vises kun maskinbrukere med tilgang til "FS-GraphQL" i listen

    @should @planned
    Scenario: Filtrere maskinbrukerlisten på administrerende organisasjon
      Gitt aktøren har rollen "ADMIN_LES"
      Og aktøren er på maskinbrukeroversikten
      Når aktøren filtrerer listen på administrerende organisasjon "Sikt"
      Så vises kun maskinbrukere administrert av "Sikt" i listen

  @must
  Regel: Kun aktører med skriverettigheter kan bytte passord, begrenset til administrerende organisasjon

    Passordbytte krever BRUKERADMIN_WSBRUKER_SKRIV eller ADMIN_FULL.
    Org-scopede aktører kan kun bytte passord der sin organisasjon
    er administrerende organisasjon for maskinbrukeren.

    @must @planned
    Scenario: Organisasjonsadmin bytter passord for maskinbruker sin org administrerer
      Gitt aktøren har rollen "BRUKERADMIN_WSBRUKER_SKRIV" for "UiO"
      Når aktøren bytter passord for "UIO_INTEGRASJON"
      Så bekreftes det at passordet er endret

    @must @planned
    Scenario: Organisasjonsadmin kan ikke bytte passord utenfor sin administrerende organisasjon
      Gitt aktøren har rollen "BRUKERADMIN_WSBRUKER_SKRIV" for "UiO"
      Når aktøren forsøker å bytte passord for "SIO_BRUKER"
      Så avvises handlingen med beskjed om manglende tilgang

    @must @planned
    Scenario: Organisasjonsadmin kan ikke bytte passord for maskinbruker den kun benytter
      Gitt aktøren har rollen "BRUKERADMIN_WSBRUKER_SKRIV" for "UiO"
      Når aktøren forsøker å bytte passord for "FELLES_RAPPORT"
      Så avvises handlingen med beskjed om manglende tilgang

    @must @planned
    Scenario: Sikt-admin bytter passord for vilkårlig maskinbruker
      Gitt aktøren har rollen "ADMIN_FULL"
      Når aktøren bytter passord for "LAANEKASSEN_BRUKER"
      Så bekreftes det at passordet er endret

    @must @planned
    Scenario: Aktør med kun lesetilgang kan ikke bytte passord
      Gitt aktøren har rollen "BRUKERADMIN_WSBRUKER_LES" for "UiO"
      Når aktøren forsøker å bytte passord for "UIO_INTEGRASJON"
      Så avvises handlingen med beskjed om manglende tilgang
