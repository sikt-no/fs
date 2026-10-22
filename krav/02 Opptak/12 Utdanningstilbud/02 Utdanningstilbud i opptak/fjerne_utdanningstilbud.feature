# language: no
# Jira: SHI-710
@OPT-OPT-UTD-026 @must @implemented @scope-utdanningstilbud-i-opptak-2027
Egenskap: Fjerne utdanningstilbud fra opptak
  Som opptaksforvalter
  ønsker jeg å fjerne utdanningstilbud som er lagt til i opptaket ved en feil, før opptaket åpner for søknad
  slik at opptaket bare har utdanningstilbudene som skal ha opptak.

  # AVKLART 2026-10-16 (produktleder): «Publisert» betyr her at opptaket har åpnet for søknad.
  # Etter at opptaket har åpnet for søknad, kan utdanningstilbud bare trekkes,
  # se trekke_utdanningstilbud.feature.

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at opptaket "Samordna opptak 2027" har utdanningstilbud

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Kan ett og ett utdanningstilbud fjernes, eller bare flere av gangen? Jira nevner bare handlingen for flere av gangen.
  Regel: Utdanningstilbud kan fjernes før opptaket åpner for søknad

    Scenario: Fjerne utdanningstilbud før søknadsåpning
      Gitt at opptaket ikke har åpnet for søknad
      Når opptaksforvalter fjerner utdanningstilbudet "Sykepleie, høst 2027" fra opptaket
      Så er utdanningstilbudet ikke lenger med i opptaket

    Scenario: Fjerne flere utdanningstilbud av gangen før søknadsåpning
      Gitt at opptaket ikke har åpnet for søknad
      Når opptaksforvalter fjerner utdanningstilbudene "Sykepleie, høst 2027" og "Vernepleie, høst 2027" fra opptaket
      Så er begge utdanningstilbudene ikke lenger med i opptaket

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Skal regelen få @ref-OPT-OPT-UTD-003 (trekke_utdanningstilbud.feature), siden utdanningstilbud bare kan trekkes etter at opptaket har åpnet for søknad?
  Regel: Utdanningstilbud kan ikke fjernes etter at opptaket har åpnet for søknad

    @in-progress
    Scenario: Muligheten til å fjerne utdanningstilbud vises ikke etter søknadsåpning
      Gitt at opptaket har åpnet for søknad
      Når opptaksforvalter ser listen over utdanningstilbud i opptaket
      Så ser ikke opptaksforvalter muligheten til å fjerne utdanningstilbud

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Scenarioet beskriver at et kall til serveren avvises, ikke noe opptaksforvalteren gjør. Skal det stå i kravet, eller i implementasjonsdetaljene (design.md) og spesifikasjonen?
    Scenario: Fjerning av utdanningstilbud etter søknadsåpning avvises
      Gitt at opptaket har åpnet for søknad
      Når det sendes en forespørsel om å fjerne utdanningstilbudet "Sykepleie, høst 2027" fra opptaket
      Så avvises forespørselen
      Og utdanningstilbudet er fortsatt med i opptaket

  # AVKLART 2026-10-16 (produktleder): Lærestedet fjerner egne utdanningstilbud fram til redigeringsfristen
  # for utdanningstilbud (11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature).
  # Forvaltende organisasjon kan fjerne alle utdanningstilbud også etter redigeringsfristen, fram til
  # opptaket åpner for søknad.
  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Skal regelen få @depends-on-OPT-OVO-FRI-001 (frister_og_hendelser.feature), siden den bygger på redigeringsfristen som settes der?
  Regel: Opptaksforvalter ved deltakende organisasjon kan fjerne utdanningstilbud organisasjonen tilbyr, fram til redigeringsfristen

    Scenario: Deltakende organisasjon fjerner eget utdanningstilbud før redigeringsfristen
      Gitt at opptaksforvalter er ved deltakende organisasjon "Universitetet i Oslo"
      Og at redigering av utdanningstilbud er åpen i opptaket
      Når opptaksforvalter fjerner utdanningstilbudet "Sykepleie, høst 2027", som "Universitetet i Oslo" tilbyr
      Så er utdanningstilbudet ikke lenger med i opptaket

    @in-progress @openquestion
    # ÅPNE SPØRSMÅL:
    # - Etter redigeringsfristen har opptaksforvalteren ikke lov til å fjerne utdanningstilbudet. Skal muligheten til å fjerne da være skjult (som etter søknadsåpning), i stedet for at forespørselen avvises? «forespørselen» viser heller ikke til noe i stegene foran.
    Scenario: Deltakende organisasjon kan ikke fjerne eget utdanningstilbud etter redigeringsfristen
      Gitt at opptaksforvalter er ved deltakende organisasjon "Universitetet i Oslo"
      Og at redigering av utdanningstilbud er stengt i opptaket
      Når opptaksforvalter vil fjerne utdanningstilbudet "Sykepleie, høst 2027", som "Universitetet i Oslo" tilbyr
      Så avvises forespørselen

    @in-progress @openquestion
    # ÅPNE SPØRSMÅL:
    # - Etter listevisning_utdanningstilbud.feature ser opptaksforvalter ved deltakende organisasjon ikke utdanningstilbud en annen organisasjon tilbyr. Skal scenarioet heller si at utdanningstilbudet ikke vises, i stedet for at forespørselen avvises?
    Scenario: Deltakende organisasjon kan ikke fjerne utdanningstilbud en annen organisasjon tilbyr
      Gitt at opptaksforvalter er ved deltakende organisasjon "Universitetet i Oslo"
      Når opptaksforvalter vil fjerne utdanningstilbudet "Medisin, høst 2027", som "Universitetet i Bergen" tilbyr
      Så avvises forespørselen

  Regel: Opptaksforvalter ved forvaltende organisasjon kan fjerne utdanningstilbud etter redigeringsfristen

    @in-progress
    Scenario: Forvaltende organisasjon fjerner utdanningstilbud etter redigeringsfristen
      Gitt at opptaksforvalter er ved forvaltende organisasjon "HK-dir"
      Og at redigering av utdanningstilbud er stengt i opptaket
      Og at opptaket ikke har åpnet for søknad
      Når opptaksforvalter fjerner utdanningstilbudet "Sykepleie, høst 2027", som "Universitetet i Oslo" tilbyr
      Så er utdanningstilbudet ikke lenger med i opptaket
