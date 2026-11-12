# language: no
@OPT-BEH-BEH-045 @could @draft
Egenskap: Ta ut sakslista
  Som saksbehandler eller opptaksforvalter
  ønsker jeg å ta ut sakslista til en fil
  slik at jeg kan bruke den der saksbehandlingen eller kontrollen skjer utenfor FS, for eksempel hos Kripos.

  # Avklart i avklaringsmøtet 2026-11-10 (svar 25 og 30). Vi legger ikke til rette for Excel-uttrekk generelt,
  # men åpner for å ta ut sakslista. Lista inneholder bare sakene brukeren har tilgang til.
  #
  # ÅPNE SPØRSMÅL:
  # - Hvilket filformat, og hvilke felt er med?
  # - Hvor lenge skal formålet og valget om fødselsnummer logges, og hvem kan se loggen?

  Regel: Brukeren oppgir formålet og bekrefter at lista behandles sikkert før uttrekket

    Scenario: Ta ut sakslista
      Gitt jeg er saksbehandler ved behandleren av søknadsalternativene
      Når jeg vil ta ut sakslista
      Og jeg oppgir hva lista skal brukes til
      Og jeg bekrefter at lista lagres sikkert og ikke deles videre i ukrypterte formater
      Så får jeg sakslista
      Og formålet er logget

    Scenario: Uttrekket stopper uten formål og bekreftelse
      Gitt jeg er saksbehandler ved behandleren av søknadsalternativene
      Når jeg vil ta ut sakslista uten å oppgi formålet
      Så får jeg ikke sakslista

  Regel: Fødselsnummer er bare med når brukeren velger det

    Scenario: Sakslista er uten fødselsnummer som standard
      Gitt jeg er saksbehandler ved behandleren av søknadsalternativene
      Når jeg tar ut sakslista uten å velge fødselsnummer
      Så er fødselsnummeret ikke med i sakslista

    Scenario: Brukeren tar stilling til at fødselsnummer trengs
      Gitt jeg er saksbehandler ved behandleren av søknadsalternativene
      Når jeg velger å ta med fødselsnummer
      Og jeg bekrefter at fødselsnummeret trengs til formålet
      Så er fødselsnummeret med i sakslista
      Og valget er logget

  Regel: Saksbehandlere og opptaksforvaltere kan ta ut sakslista, ikke opptaksinformatører

    Scenariomal: Hvem som kan ta ut sakslista
      Gitt jeg er <rolle> ved <organisasjon>
      Når jeg åpner sakslista
      Så <utfall>

      Eksempler:
        | rolle             | organisasjon                        | utfall                                              |
        | saksbehandler     | behandleren av søknadsalternativene | ser jeg muligheten til å ta ut sakslista            |
        | opptaksforvalter  | forvalteren av opptaket             | ser jeg muligheten til å ta ut sakslista            |
        | opptaksinformatør | behandleren av søknadsalternativene | ser jeg ikke muligheten til å ta ut sakslista       |

    Scenario: Sakslista inneholder bare sakene brukeren har tilgang til
      Gitt jeg er saksbehandler ved behandleren av noen av søknadsalternativene i opptaket
      Når jeg tar ut sakslista
      Så inneholder sakslista bare sakene organisasjonen er forvalter, tilbyder eller behandler for
