# language: no
# GitHub: #398
@OPT-OPT-UTD-001 @must @in-progress @scope-utdanningstilbud-i-opptak-2027
Egenskap: Listevisning og søk i utdanningstilbud i opptaket
  Som opptaksforvalter
  ønsker jeg en oversikt over relevante utdanningstilbud i opptaket, med mulighet for søk og filtrering
  slik at jeg raskt kan finne og følge opp riktig utdanningstilbud.

  # ÅPNE SPØRSMÅL:
  # - Kravet følger ikke mønsteret for listevisning (Liste / Søk og filtrering / Synlighet). Det mangler «Se liste over utdanningstilbud» med kolonnene i en tabell, sortering, paginering (de 50 første, laste inn flere, alle er lastet inn), navigering til detaljsiden, «Tilgjengelige … i filter» med «Alle …» som standard for hvert filter, «Kombinere filtre», og akronym og søk i organisasjonsfilteret. Skal kravet skrives om etter mønsteret?
  # - Mønsteret for listevisning skriver stegene i første person («jeg»), mens kravene i Opptak skriver «opptaksforvalter». Skal Opptak følge mønsteret, eller er det et bevisst unntak?

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet med deltakende organisasjoner

  @implemented
  Regel: Grunndata fra utdanningsregisteret vises tydelig

    Scenario: Se grunndata om utdanning
      Gitt at utdanningstilbudet "Sykepleie, UiO, høst 2027" er lagt til i opptaket
      Når opptaksforvalter åpner utdanningstilbudet
      Så ser opptaksforvalter grunndata fra utdanningsregisteret (navn, studiepoeng, nivå, campus)
      Og det er tydelig hvilke data som kommer fra utdanningsregisteret

  Regel: Opptaksforvalter ser campus for utdanningstilbudene i opptaket

    Scenario: Se campus i listen over utdanningstilbud i opptaket
      Gitt at utdanningstilbudet "Sykepleie, høst 2027" er lagt til i opptaket på campusene "Blindern" og "Kjeller"
      Når opptaksforvalter åpner oversikten over utdanningstilbud
      Så ser opptaksforvalter to utdanningstilbud "Sykepleie, høst 2027"
      Og campus vises for hvert av utdanningstilbudene

  @implemented
  Regel: Opptaksforvalter ved forvaltende organisasjon kan filtrere på organisasjon

    Scenario: Filtrere på organisasjon som opptaksforvalter ved forvaltende organisasjon
      Gitt at opptaksforvalter er ved forvaltende organisasjon
      Når opptaksforvalter filtrerer på organisasjonen "Universitetet i Oslo"
      Så ser opptaksforvalter kun utdanningstilbud fra Universitetet i Oslo

  Regel: Opptaksforvalter ved deltakende organisasjon ser kun utdanningstilbud organisasjonen tilbyr

    Scenario: Deltakende organisasjon ser kun utdanningstilbudene sine
      Gitt at opptaksforvalter er ved en deltakende organisasjon
      Når opptaksforvalter åpner oversikten over utdanningstilbud
      Så ser opptaksforvalter kun utdanningstilbud fra organisasjonen opptaksforvalter er ved

    # AVKLART 2026-10-16 (produktleder): Saksbehandlere ser søknadene de skal behandle i søknadsbehandlingen,
    # ikke gjennom utdanningstilbudene i opptaket. Flyttet hit fra samordna_opptak.feature 2026-10-19.
    Scenario: Deltakende organisasjon ser ikke utdanningstilbud en annen organisasjon tilbyr
      Gitt at organisasjonene "Universitetet i Oslo" og "Universitetet i Bergen" er lagt til som deltakere
      Og at "Universitetet i Bergen" har knyttet utdanningstilbudet "Medisin, høst 2027" til opptaket
      Når opptaksforvalter ved Universitetet i Oslo ser listen over utdanningstilbud i opptaket
      Så ser ikke opptaksforvalter utdanningstilbudet "Medisin, høst 2027"

  @implemented
  Regel: Opptaksforvalter kan filtrere på starttermin og startår

    Scenario: Filtrere på starttermin og startår
      Når opptaksforvalter filtrerer på starttermin "høst" og startår "2027"
      Så ser opptaksforvalter kun utdanningstilbud med oppstart høst 2027

  @implemented
  Regel: Opptaksforvalter kan filtrere på navn på studieprogram

    Scenario: Fritekst-søk på studieprogramnavn
      Når opptaksforvalter søker på "sykepleie"
      Så filtreres listen til utdanningstilbud som matcher søket

  Regel: Opptaksforvalter kan filtrere på utdanningstilbud med ufullstendige opplysninger

    @implemented
    Scenario: Filtrere på utdanningstilbud som mangler kompetanseregelverk
      Når opptaksforvalter filtrerer på utdanningstilbud med ufullstendige opplysninger
      Så ser opptaksforvalter utdanningstilbud som mangler kompetanseregelverk

    @implemented
    Scenario: Filtrere på utdanningstilbud som mangler rangeringsregelverk
      Når opptaksforvalter filtrerer på utdanningstilbud med ufullstendige opplysninger
      Så ser opptaksforvalter utdanningstilbud som mangler rangeringsregelverk

    @openquestion
    Scenario: Filtrere på utdanningstilbud som mangler kvoter, kvoteprioritet eller plassflyt
      # ÅPNE SPØRSMÅL:
      # - Delvis levert (verify 2026-10-22): «Har mangler» tar med utdanningstilbud uten kvoter, men ikke dem som mangler kvoteprioritet eller plassflyt. Skal kvoteprioritet og plassflyt tas med i «Har mangler»?
      Når opptaksforvalter filtrerer på utdanningstilbud med ufullstendige opplysninger
      Så ser opptaksforvalter utdanningstilbud som mangler kvoter, kvoteprioritet eller plassflyt

    Scenario: Filtrere på utdanningstilbud som mangler opplysninger om tilbudsgaranti
      Når opptaksforvalter filtrerer på utdanningstilbud med ufullstendige opplysninger
      Så ser opptaksforvalter utdanningstilbud som mangler opplysninger om hvor tilbudsgarantier skal tas fra

    # AVKLART 08.10.2026: Fristene for tidlig opptak er felles for opptaket, og svaret på
    # tidlig opptak publiseres for hele opptaket. Utdanningstilbudet har derfor ingen egen
    # dato for tidlig opptak. Det som kan mangle på et utdanningstilbud som tilbyr tidlig
    # opptak, er poenggrensen. Tidlig søknadsfrist settes fritt per utdanningstilbud.
    @depends-on-OPT-OPT-UTD-025 @ref-OPT-OVO-FRI-001
    Scenario: Filtrere på utdanningstilbud som mangler dato for tidlig søknadsfrist
      Gitt at et utdanningstilbud er markert med tidlig søknadsfrist
      Når opptaksforvalter filtrerer på utdanningstilbud med ufullstendige opplysninger
      Så ser opptaksforvalter utdanningstilbud der dato for tidlig søknadsfrist ikke er satt

    @depends-on-OPT-OPT-UTD-010 @ref-OPT-BEH-BEH-014
    Scenario: Filtrere på utdanningstilbud som mangler poenggrense for tidlig opptak
      Gitt at et utdanningstilbud tilbyr tidlig opptak
      Når opptaksforvalter filtrerer på utdanningstilbud med ufullstendige opplysninger
      Så ser opptaksforvalter utdanningstilbud der poenggrensen for tidlig opptak ikke er satt