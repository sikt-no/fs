# language: no
@OPT-BEH-BEH-044 @must @draft @ref-OPT-BEH-BEH-011 @ref-OPT-BEH-BEH-043
Egenskap: Skrive merknader i saken
  Som saksbehandler
  ønsker jeg å skrive merknader i saken, enten til de andre organisasjonene på søknaden eller bare til kollegene mine
  slik at det som er vurdert, er dokumentert for dem som trenger det.

  # Bygger på R6 i spec-en «Krav til RLS» og svar 10 i avklaringsmøtet 2026-11-10.
  # Saken har to slags merknader: delte, som forvalteren, tilbyderen og behandleren på søknaden ser, og interne,
  # som bare organisasjonen som skrev dem ser. Søkeren ser ingen merknader.
  # I dag kan merknader skrives på saker hos andre organisasjoner, og hvem som skrev merknaden, kan settes fritt.
  # Det samme skillet mellom intern og delt gjelder mangler (@OPT-BEH-BEH-008) og meldinger (@OPT-SØK-MEL-001).

  Regel: En merknad er delt med organisasjonene på søknaden, med mindre den er merket som intern

    Scenariomal: Se en merknad behandleren har skrevet
      Gitt søknaden er i et samordna opptak der tilbyderen og behandleren er ulike organisasjoner
      Og saksbehandleren ved behandleren har skrevet en <type> merknad i saken
      Og jeg er <rolle> ved <organisasjon>
      Når jeg åpner saken
      Så <ser> jeg merknaden

      Eksempler:
        | type   | rolle             | organisasjon                          | ser      |
        | delt   | saksbehandler     | tilbyderen av søknadsalternativet     | ser      |
        | delt   | opptaksforvalter  | forvalteren av opptaket               | ser      |
        | intern | saksbehandler     | behandleren av søknadsalternativet    | ser      |
        | intern | opptaksinformatør | behandleren av søknadsalternativet    | ser      |
        | intern | saksbehandler     | tilbyderen av søknadsalternativet     | ser ikke |
        | intern | opptaksforvalter  | forvalteren av opptaket               | ser ikke |

  Regel: Søkeren ser ingen merknader

    Scenario: Søkeren ser ikke merknadene i saken
      Gitt saksbehandleren ved behandleren har skrevet en delt merknad i saken
      Når søkeren ser søknaden sin i Min kompetanse
      Så ser søkeren ikke merknaden

  Regel: Bare organisasjonen som behandler saken, skriver merknader i den

    Scenariomal: Skrive en merknad i saken
      Gitt jeg er saksbehandler ved <organisasjon>
      Når jeg vil skrive en merknad i saken behandleren har
      Så <utfall>

      Eksempler:
        | organisasjon                       | utfall                                         |
        | behandleren av søknadsalternativet | kan jeg skrive merknaden                       |
        | tilbyderen av søknadsalternativet  | ser jeg ikke muligheten til å skrive merknaden |

    Scenario: Merknaden står på saksbehandleren som skrev den
      Gitt jeg er saksbehandler ved behandleren av søknadsalternativet
      Når jeg skriver en merknad i saken
      Så står merknaden på meg
      Og ingen andre kan endre merknaden

    Scenario: En merknad i en annen organisasjons sak avvises i API-et
      Gitt en integrasjon har rollen saksbehandler ved tilbyderen av søknadsalternativet
      Når integrasjonen forsøker å skrive en merknad i saken behandleren har, gjennom API-et
      Så avvises det
