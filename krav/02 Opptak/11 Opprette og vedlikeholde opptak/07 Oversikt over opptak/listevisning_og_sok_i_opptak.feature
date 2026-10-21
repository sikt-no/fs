# language: no
# GitHub: #211
@OPT-OVO-OVE-001 @must @implemented @scope-opprette-opptak-2027 @ref-OPT-OVO-SAM-001
Egenskap: Listevisning og søk i opptak
  Som opptaksforvalter
  ønsker jeg en oversikt over opptak jeg har tilgang til, med mulighet for søk og filtrering
  slik at jeg raskt kan finne og følge opp riktig opptak.

  # Kilde: akseptansetesten 19.10.2026. Oversikten over opptak finnes i FS Admin (https://test-fsadmin.sikt.no/opptak),
  # men hadde ikke noe krav. HK-dir ba om å filtrere og sortere på opptakstype og navn, og å åpne detaljene i et opptak.
  # AVKLART 2026-10-21 (produkteier): Kravet beskriver lista slik den er bygget.
  # AVKLART 2026-10-21 (produkteier): Status er ikke med i lista, i sorteringen eller i filtrene. Det er ennå ikke forskjell
  # på aktive og deaktiverte opptak, og å deaktivere et opptak kommer senere (01 Grunnoppsett/opprett_opptak.feature).
  # HK-dir ønsker også å sortere på navn. Det er ikke med i kravet nå.
  # Hvilke opptak en organisasjon som ikke deltar, ser, står i samordna_opptak.feature
  # (Regel: Organisasjoner som ikke deltar, kan ikke se opptaket).

  Bakgrunn:
    Gitt opptaksforvalter er innlogget i løsningen

  Regel: Liste over alle opptak

    Scenario: Se liste over opptak
      Når opptaksforvalter åpner opptaksoversikten
      Så ser opptaksforvalter en liste over opptak
      Og hvert innslag viser følgende informasjon:
        | felt                    |
        | Navn                    |
        | Type                    |
        | Organisasjon            |
        | Opprettet               |
        | Antall utdanningstilbud |

    Scenario: Liste er sortert etter når opptaket ble opprettet som standard
      Når opptaksforvalter åpner opptaksoversikten
      Så vises opptakene sortert etter opprettet i synkende rekkefølge

    Scenariomal: Velge sorteringsretning for <felt>
      Gitt opptaksforvalter ser listen over opptak
      Når opptaksforvalter velger å sortere på <felt> i <retning> rekkefølge
      Så vises opptakene sortert etter <felt> i <retning> rekkefølge

      Eksempler:
        | felt         | retning  |
        | opprettet    | stigende |
        | opprettet    | synkende |
        | type         | stigende |
        | type         | synkende |
        | organisasjon | stigende |
        | organisasjon | synkende |

    Scenario: Liste viser de 50 første opptakene
      Når opptaksforvalter åpner opptaksoversikten
      Så ser opptaksforvalter totalt antall treff og antall som er lastet
      Og listen viser de 50 første opptakene

    Scenario: Laste inn 50 flere opptak
      Gitt opptaksforvalter ser listen over opptak
      Og det finnes flere opptak enn det som er lastet inn
      Når opptaksforvalter velger å laste inn flere
      Så lastes de neste 50 opptakene inn i listen

    Scenario: Alle opptak er lastet inn
      Gitt opptaksforvalter ser listen over opptak
      Og alle opptak er lastet inn
      Så er muligheten til å laste inn flere ikke tilgjengelig

    Scenario: Navigere til detaljside for opptak
      Gitt opptaksforvalter ser listen over opptak
      Når opptaksforvalter velger et opptak
      Så ser opptaksforvalter detaljsiden for valgt opptak

  Regel: Søk og filtrering av opptak

    Scenario: Fritekst-søk på navn
      Gitt opptaksforvalter ser listen over opptak
      Når opptaksforvalter søker med fritekst på navn
      Så filtreres listen til opptak som matcher søket

    # AVKLART 2026-10-21 (produkteier): Som i løsningen er ingen opptakstype valgt når filteret åpnes, og da vises
    # opptak av alle typer. Filteret har ikke valget «Alle opptakstyper» som listevisningsmønsteret beskriver.
    Scenario: Tilgjengelige opptakstyper i filter
      Gitt opptaksforvalter ser listen over opptak
      Når opptaksforvalter åpner opptakstype-filteret
      Så inneholder filteret alle opptakstypene
      Og opptakstypene er sortert alfabetisk
      Og ingen opptakstype er valgt som standard

    Scenario: Filtrere på opptakstype
      Gitt opptaksforvalter ser listen over opptak
      Når opptaksforvalter velger en opptakstype som filter
      Så vises kun opptak med den valgte opptakstypen

    Scenario: Kombinere filtre
      Gitt opptaksforvalter ser listen over opptak
      Når opptaksforvalter kombinerer fritekst-søk med ett eller flere filter
      Så vises kun opptak som matcher alle kriteriene
