# language: no
# GitHub: #398
@OPT-OPT-UTD-001 @must @draft
Egenskap: Listevisning og filtrering av utdanningstilbud i opptak
  Som opptaksforvalter
  ønsker jeg en oversikt over relevante utdanningstilbud i opptaket, med mulighet for filtrering
  slik at opptaksforvalter raskt kan finne og følge opp riktig utdanningstilbud.

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet med kriterier for utdanningstyper og -nivåer

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

  Regel: Opptaksforvalter ved deltakende organisasjon ser kun egne utdanningstilbud

    Scenario: Deltakende organisasjon ser kun sine egne
      Gitt at opptaksforvalter er ved en deltakende organisasjon
      Når opptaksforvalter åpner oversikten over utdanningstilbud
      Så ser opptaksforvalter kun utdanningstilbud fra egen organisasjon

  Regel: Opptaksforvalter kan filtrere på starttermin og startår

    Scenario: Filtrere på starttermin og startår
      Når opptaksforvalter filtrerer på starttermin "høst" og startår "2027"
      Så ser opptaksforvalter kun utdanningstilbud med oppstart høst 2027

  Regel: Opptaksforvalter kan filtrere på navn på studieprogram

    Scenario: Søke på studieprogramnavn
      Når opptaksforvalter søker på "sykepleie"
      Så filtreres listen til utdanningstilbud som matcher søket

  Regel: Opptaksforvalter kan filtrere på utdanningstilbud med ufullstendige opplysninger

    Scenario: Filtrere på utdanningstilbud som mangler kompetanseregelverk
      Når opptaksforvalter filtrerer på utdanningstilbud med ufullstendige opplysninger
      Så ser opptaksforvalter utdanningstilbud som mangler kompetanseregelverk

    Scenario: Filtrere på utdanningstilbud som mangler rangeringsregelverk
      Når opptaksforvalter filtrerer på utdanningstilbud med ufullstendige opplysninger
      Så ser opptaksforvalter utdanningstilbud som mangler rangeringsregelverk

    Scenario: Filtrere på utdanningstilbud som mangler kvoter eller kvoteprioritering
      Når opptaksforvalter filtrerer på utdanningstilbud med ufullstendige opplysninger
      Så ser opptaksforvalter utdanningstilbud som mangler kvoter, kvoteprioritering eller plassflyt

    Scenario: Filtrere på utdanningstilbud som mangler opplysninger om tilbudsgaranti
      Når opptaksforvalter filtrerer på utdanningstilbud med ufullstendige opplysninger
      Så ser opptaksforvalter utdanningstilbud som mangler opplysninger om hvor tilbudsgarantier skal tas fra

    # AVKLART 08.10.2026: Fristene for tidlig opptak er felles for opptaket
    # (frister_og_hendelser.feature), og publiseringsdatoen for svar på tidlig opptak
    # settes per opptak (publisere_svar_på_tidlig_opptak.feature). Utdanningstilbudet har
    # derfor ingen egen dato for tidlig tilbud. Det som kan mangle på et utdanningstilbud
    # med tidlig tilbud, er poenggrensen. Tidlig søknadsfrist settes fritt per
    # utdanningstilbud (opptaksinnstillinger_utdanningstilbud.feature).
    Scenario: Filtrere på utdanningstilbud som mangler dato for tidlig søknadsfrist
      Gitt at utdanningstilbudet er markert med tidlig søknadsfrist
      Når opptaksforvalter filtrerer på utdanningstilbud med ufullstendige opplysninger
      Så ser opptaksforvalter utdanningstilbud der dato for tidlig søknadsfrist ikke er satt

    Scenario: Filtrere på utdanningstilbud som mangler poenggrense for tidlig tilbud
      Gitt at utdanningstilbudet er markert for tidlig tilbud
      Når opptaksforvalter filtrerer på utdanningstilbud med ufullstendige opplysninger
      Så ser opptaksforvalter utdanningstilbud der poenggrensen for tidlig tilbud ikke er satt