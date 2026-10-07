# language: no
# GitHub: #597
@OPT-OPT-UTD-004 @must @draft
Egenskap: Opptaksinnstillinger per utdanningstilbud
  Som opptaksforvalter
  ønsker jeg å sette opptaksinnstillinger per utdanningstilbud
  slik at hvert utdanningstilbud har riktige regler for søknadsbehandling og plasstildeling.

  # Opptaksforvalter ved deltakende organisasjon kan sette innstillinger på egne utdanningstilbud.
  # Opptaksforvalter ved forvaltende organisasjon kan sette innstillinger på alle utdanningstilbud.
  # Innstillinger for flere utdanningstilbud av gangen står i sette_standardinnstillinger.feature (#599).
  # Antall studieplasser og antall tilbud står i sette_studieplasser_og_antall_tilbud.feature (#596).
  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at opptaket "Samordna opptak 2027" har utdanningstilbud

  Regel: Opptaksforvalter kan sette kompetanseregelverk og rangeringsregelverk

    Scenario: Sette regelverk på ett utdanningstilbud
      Når opptaksforvalter velger utdanningstilbudet "Sykepleie, høst 2027"
      Og opptaksforvalter setter kompetanseregelverk til "GSK"
      Og opptaksforvalter setter rangeringsregelverk til "Ordinær rangering"
      Så vurderes søkere til dette utdanningstilbudet etter GSK-kravene
      Og søkere rangeres etter reglene i "Ordinær rangering"

    Scenario: Kun regelverk fra opptakets regelverkssamling kan velges
      Når opptaksforvalter setter regelverk for et utdanningstilbud
      Så kan opptaksforvalter kun velge blant regelverkene i opptakets regelverkssamling

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Skal kun opptaksforvalter ved forvaltende organisasjon få lov å opprette nye
    #   kompetanseregelverk og rangeringsregelverk? Skal opptaksforvalter ved deltakende
    #   organisasjon bare få bruke eksisterende regelverk i samordna opptak?
    Scenario: Rettigheter for oppretting av nye regelverk
      Gitt at opptaksforvalter er ved en deltakende organisasjon i samordna opptak
      Når opptaksforvalter skal sette regelverk for et utdanningstilbud
      Så kan opptaksforvalter velge blant eksisterende regelverk i regelverkssamlingen

  # Kilde for kvoteregelen: GitHub #597. Absolutte kvoter finnes i dag. Relativ fordeling gjenstår.
  Regel: Opptaksforvalter kan sette utdanningskvoter med relativ fordeling

    Scenario: Utdanningskvotene følger av regelverkssamlingen
      Gitt at regelverkssamlingen "UHG 2027" har kvotetypene "Ordinær" og "Førstegangsvitnemål"
      Når opptaksforvalter velger utdanningstilbudet "Sykepleie, høst 2027"
      Så har utdanningstilbudet utdanningskvotene "Ordinær" og "Førstegangsvitnemål"

    Scenario: Sette prosentfordeling mellom utdanningskvoter
      Når opptaksforvalter velger utdanningstilbudet "Sykepleie, høst 2027"
      Og opptaksforvalter setter kvotefordelingen til 50 % ordinær og 50 % førstegangsvitnemål
      Så fordeler plasstildelingen tilbudene mellom kvotene etter denne prosentfordelingen

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Må summen av prosentfordelingen være 100 %? Hva skjer hvis den ikke er det?
    # - Kan opptaksforvalter legge til eller fjerne utdanningskvoter som ikke følger av regelverkssamlingen?
    Scenario: Alle utdanningskvoter settes som prosent
      Når opptaksforvalter setter kvotefordelingen for utdanningstilbudet "Sykepleie, høst 2027"
      Så angis hver utdanningskvote som en prosentandel av antall tilbud som skal gis

  # Hva plasstildelingen gjør med plassflyten, og vernet mot sirkulær plassflyt (#598), står i
  # 14 Plasstildeling/02 Tildelingsinnstillinger/plassflyt.feature.
  Regel: Opptaksforvalter kan sette plassflyt mellom utdanningskvoter

    Scenario: Sette plassflyt
      Når opptaksforvalter setter plassflyt for utdanningstilbudet "Sykepleie, høst 2027"
      Og opptaksforvalter setter at ledige plasser i førstegangsvitnemålskvoten flyter til ordinær kvote
      Så omfordeler plasstildelingen ubrukte plasser fra førstegangsvitnemålskvoten til ordinær kvote

  Regel: Opptaksforvalter kan markere utdanningstilbud for tidlig tilbud

    Scenario: Markere utdanningstilbud for tidlig tilbud
      Gitt at opptaket åpner for tidlig opptak
      Når opptaksforvalter markerer utdanningstilbudet "Sykepleie, høst 2027" for tidlig tilbud
      Og opptaksforvalter setter dato for når svar sendes til søkere
      Så kan søkere som oppfyller kriteriene få tidlig svar på dette utdanningstilbudet

  Regel: Opptaksforvalter kan sette tidlig søknadsfrist per utdanningstilbud

    Scenario: Sette tidlig søknadsfrist
      Gitt at opptaket åpner for at tidlig søknadsfrist kan angis per utdanningstilbud
      Når opptaksforvalter setter tidlig søknadsfrist for utdanningstilbudet "Politihøyskolen, høst 2027"
      Så har dette utdanningstilbudet en tidligere søknadsfrist enn opptakets generelle frist

    Scenario: Sette tidlig dokumentasjonsfrist
      Gitt at opptaket åpner for at tidlig søknadsfrist kan angis per utdanningstilbud
      Når opptaksforvalter setter tidlig dokumentasjonsfrist til "2027-03-01 23:59" for utdanningstilbudet "Politihøyskolen, høst 2027"
      Så må søkere til dette utdanningstilbudet laste opp dokumentasjon innen denne fristen

  Regel: Opptaksforvalter kan velge hvilke plasstildelingsrunder utdanningstilbudet deltar i

    Scenario: Ekskludere utdanningstilbud fra etterfylling
      Gitt at opptaket har runder for hovedtildeling, supplering og etterfylling
      Når opptaksforvalter angir at utdanningstilbudet "Sykepleie, høst 2027" ikke skal delta i etterfylling
      Så deltar utdanningstilbudet ikke i etterfyllingsrunder

    # AVKLART 2026-10-07: Ledige studieplasser er en egenskap ved etterfylling,
    # ikke en egen rundetype. Ekskludering fra etterfylling dekker også ledige studieplasser.

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Hva er saksbehandlertildelingsregel i kontekst av utdanningstilbud?
  # - Hvordan velger opptaksforvalter blant reglene som er satt på opptaket?
  Regel: Opptaksforvalter kan sette saksbehandlertildelingsregel per utdanningstilbud

    Scenario: Sette saksbehandlertildelingsregel
      Når opptaksforvalter setter saksbehandlertildelingsregel for utdanningstilbudet "Sykepleie, høst 2027"
      Så fordeles søknadssaker for dette utdanningstilbudet til saksbehandlerorganisasjoner etter den angitte regelen

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Er det lov å overstyre visning av poenggrenser og ventelistenummer
  #   for søkere i samordna opptak? Bør dette være opptaksinnstillinger i stedet?
  Regel: Opptaksforvalter kan styre visning av poenggrense og ventelistenummer

    Scenario: Velge å vise poenggrense for søker
      Når opptaksforvalter angir at poenggrense skal vises for søkere på utdanningstilbudet "Sykepleie, høst 2027"
      Så kan søkere se poenggrensen for dette utdanningstilbudet

    Scenario: Velge å vise ventelistenummer for søker
      Når opptaksforvalter angir at ventelistenummer skal vises for søkere på utdanningstilbudet "Sykepleie, høst 2027"
      Så kan søkere se sitt ventelistenummer for dette utdanningstilbudet

  Regel: Opptaksforvalter kan sette tags med assosiative termer

    Scenario: Sette tags på utdanningstilbud
      Når opptaksforvalter setter tags "medisin, lege" på utdanningstilbudet "Profesjonsstudiet i medisin, høst 2027"
      Så kan søkere finne utdanningstilbudet ved å søke på "lege"

    Scenario: Sette tags for rettsvitenskap
      Når opptaksforvalter setter tags "advokat, jus, jurist" på utdanningstilbudet "Masterstudiet i rettsvitenskap, høst 2027"
      Så kan søkere finne utdanningstilbudet ved å søke på "advokat"

  Regel: Opptaksforvalter kan sette opplysninger om tilbudsgaranti

    Scenario: Sette hvor tilbudsgarantier tas fra
      Når opptaksforvalter angir at tilbudsgarantier for utdanningstilbudet "Sykepleie, høst 2027" skal tas fra ordinær kvote
      Så tas tilbudsgarantier fra ordinær kvote i plasstildelingen