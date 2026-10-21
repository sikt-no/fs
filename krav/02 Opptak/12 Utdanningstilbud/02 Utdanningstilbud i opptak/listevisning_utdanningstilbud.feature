# language: no
# GitHub: #398
@OPT-OPT-UTD-001 @must @draft @scope-utdanningstilbud-i-opptak-2027
Egenskap: Listevisning og søk i utdanningstilbud i opptaket
  Som opptaksforvalter
  ønsker jeg en oversikt over relevante utdanningstilbud i opptaket, med mulighet for søk og filtrering
  slik at jeg raskt kan finne og følge opp riktig utdanningstilbud.

  # ÅPNE SPØRSMÅL:
  # - Kravet følger ikke mønsteret for listevisning (Liste / Søk og filtrering / Synlighet). Det mangler «Se liste over utdanningstilbud» med kolonnene i en tabell, sortering, paginering (de 50 første, laste inn flere, alle er lastet inn), navigering til detaljsiden, «Tilgjengelige … i filter» med «Alle …» som standard for hvert filter, «Kombinere filtre», og akronym og søk i organisasjonsfilteret. Skal kravet skrives om etter mønsteret?
  # - «Se grunndata om utdanning» handler om detaljsiden til utdanningstilbudet, ikke om lista. Hører regelen hjemme i dette kravet?
  # - Mønsteret for listevisning skriver stegene i første person («jeg»), mens kravene i Opptak skriver «opptaksforvalter». Skal Opptak følge mønsteret, eller er det et bevisst unntak?

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet med kriterier for utdanningstyper og -nivåer

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Kravet har tre ulike steg for å åpne lista: «åpner oversikten over tilgjengelige utdanningstilbud», «åpner oversikten over utdanningstilbud» og «ser listen over utdanningstilbud i opptaket». Er «tilgjengelige utdanningstilbud» her lista over utdanningstilbud som kan legges til i opptaket (som filtrene i legge_til_utdanningstilbud.feature), eller den samme lista som utdanningstilbudene i opptaket?
  Regel: Opptaksforvalter ser kun utdanningstilbud som matcher opptakets kriterier

    Scenario: Se relevante utdanningstilbud
      Gitt at opptaket tillater studieprogram på bachelornivå
      Når opptaksforvalter åpner oversikten over tilgjengelige utdanningstilbud
      Så ser opptaksforvalter kun studieprogram på bachelornivå fra deltakende organisasjoner

  Regel: Grunndata fra utdanningsregisteret vises tydelig

    Scenario: Se grunndata om utdanning
      Gitt at utdanningstilbudet "Sykepleie, UiO, høst 2027" er lagt til i opptaket
      Når opptaksforvalter åpner utdanningstilbudet
      Så ser opptaksforvalter grunndata fra utdanningsregisteret (navn, studiepoeng, nivå, campus)
      Og det er tydelig hvilke data som kommer fra utdanningsregisteret

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

  Regel: Opptaksforvalter kan filtrere på starttermin og startår

    Scenario: Filtrere på starttermin og startår
      Når opptaksforvalter filtrerer på starttermin "høst" og startår "2027"
      Så ser opptaksforvalter kun utdanningstilbud med oppstart høst 2027

  Regel: Opptaksforvalter kan filtrere på navn på studieprogram

    Scenario: Fritekst-søk på studieprogramnavn
      Når opptaksforvalter søker på "sykepleie"
      Så filtreres listen til utdanningstilbud som matcher søket

  Regel: Opptaksforvalter kan filtrere på utdanningstilbud med ufullstendige opplysninger

    Scenario: Filtrere på utdanningstilbud som mangler kompetanseregelverk
      Når opptaksforvalter filtrerer på utdanningstilbud med ufullstendige opplysninger
      Så ser opptaksforvalter utdanningstilbud som mangler kompetanseregelverk

    Scenario: Filtrere på utdanningstilbud som mangler rangeringsregelverk
      Når opptaksforvalter filtrerer på utdanningstilbud med ufullstendige opplysninger
      Så ser opptaksforvalter utdanningstilbud som mangler rangeringsregelverk

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Begrepslista har «kvoteprioritet», ikke «kvoteprioritering». Er det kvoteprioritet som menes?
    Scenario: Filtrere på utdanningstilbud som mangler kvoter, kvoteprioritering eller plassflyt
      Når opptaksforvalter filtrerer på utdanningstilbud med ufullstendige opplysninger
      Så ser opptaksforvalter utdanningstilbud som mangler kvoter, kvoteprioritering eller plassflyt

    Scenario: Filtrere på utdanningstilbud som mangler opplysninger om tilbudsgaranti
      Når opptaksforvalter filtrerer på utdanningstilbud med ufullstendige opplysninger
      Så ser opptaksforvalter utdanningstilbud som mangler opplysninger om hvor tilbudsgarantier skal tas fra

    # AVKLART 08.10.2026: Fristene for tidlig opptak er felles for opptaket
    # (frister_og_hendelser.feature), og svaret på tidlig opptak publiseres for hele
    # opptaket (publisere_svar_på_tidlig_opptak.feature). Utdanningstilbudet har
    # derfor ingen egen dato for tidlig opptak. Det som kan mangle på et utdanningstilbud
    # som tilbyr tidlig opptak, er poenggrensen. Tidlig søknadsfrist settes fritt per
    # utdanningstilbud (opptaksinnstillinger_utdanningstilbud.feature).
    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Skal scenarioet få @ref-OPT-OPT-UTD-004 (opptaksinnstillinger_utdanningstilbud.feature) og @ref-OPT-OVO-FRI-001 (frister_og_hendelser.feature), som kommentaren over viser til?
    Scenario: Filtrere på utdanningstilbud som mangler dato for tidlig søknadsfrist
      Gitt at et utdanningstilbud er markert med tidlig søknadsfrist
      Når opptaksforvalter filtrerer på utdanningstilbud med ufullstendige opplysninger
      Så ser opptaksforvalter utdanningstilbud der dato for tidlig søknadsfrist ikke er satt

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Skal scenarioet få @ref-OPT-BEH-BEH-014 (publisere_svar_på_tidlig_opptak.feature) og @ref-OPT-OVO-FRI-001 (frister_og_hendelser.feature), som kommentaren over forrige scenario viser til?
    Scenario: Filtrere på utdanningstilbud som mangler poenggrense for tidlig opptak
      Gitt at et utdanningstilbud tilbyr tidlig opptak
      Når opptaksforvalter filtrerer på utdanningstilbud med ufullstendige opplysninger
      Så ser opptaksforvalter utdanningstilbud der poenggrensen for tidlig opptak ikke er satt