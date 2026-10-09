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
  # Antall studieplasser står i sette_studieplasser_og_antall_tilbud.feature (#596).
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

  # Kilde for kvoteregelen: GitHub #597.
  # AVKLART 2026-10-08: Prosentfordeling mellom utdanningskvoter utgår. Antall tilbud som skal gis settes
  # som absolutte tall per utdanningskvote for hvert utdanningstilbud i hver runde, se
  # 14 Plasstildeling/02 Tildelingsinnstillinger/antall_tilbud_som_skal_gis.feature.
  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Kan opptaksforvalter legge til eller fjerne utdanningskvoter som ikke følger av regelverkssamlingen?
  Regel: Utdanningskvotene følger av regelverkssamlingen

    Scenario: Utdanningskvotene følger av regelverkssamlingen
      Gitt at regelverkssamlingen "UHG 2027" har kvotetypene "Ordinær" og "Førstegangsvitnemål"
      Når opptaksforvalter velger utdanningstilbudet "Sykepleie, høst 2027"
      Så har utdanningstilbudet utdanningskvotene "Ordinær" og "Førstegangsvitnemål"

  # Hva plasstildelingen gjør med plassflyten, og vernet mot sirkulær plassflyt (#598), står i
  # 14 Plasstildeling/02 Tildelingsinnstillinger/plassflyt.feature.
  Regel: Opptaksforvalter kan sette plassflyt mellom utdanningskvoter

    Scenario: Sette plassflyt
      Når opptaksforvalter setter plassflyt for utdanningstilbudet "Sykepleie, høst 2027"
      Og opptaksforvalter setter at ledige plasser i førstegangsvitnemålskvoten flyter til ordinær kvote
      Så omfordeler plasstildelingen ubrukte plasser fra førstegangsvitnemålskvoten til ordinær kvote

  Regel: Opptaksforvalter kan markere at et utdanningstilbud tilbyr tidlig opptak

    Scenario: Markere at utdanningstilbudet tilbyr tidlig opptak
      Gitt at opptaket åpner for tidlig opptak
      Når opptaksforvalter markerer at utdanningstilbudet "Sykepleie, høst 2027" tilbyr tidlig opptak
      Så kan søkere som oppfyller kriteriene få tidlig svar på dette utdanningstilbudet
      # Publiseringsdatoen for svar på tidlig opptak settes per opptak, ikke per
      # utdanningstilbud, se publisere_svar_på_tidlig_opptak.feature (avklart 25.09.2026).

    Scenario: Sette poenggrense for tidlig opptak
      Gitt utdanningstilbudet "Sykepleie, høst 2027" tilbyr tidlig opptak
      Når opptaksforvalter setter poenggrensen for tidlig opptak til 50 for utdanningstilbudet "Sykepleie, høst 2027"
      Så får søkere som deltar i tidligopptaket og har minst 50 poeng, tilbudsgaranti på "Sykepleie, høst 2027"
      # Se gi_tilbudsgaranti_ved_tidlig_opptak.feature. En egen verdi beregnet fra fjorårets
      # opptak kommer eventuelt senere (STEK-352).

    # Lenken til informasjon om tidlig opptak settes per opptak, ikke per
    # utdanningstilbud, se 11 Opprette og vedlikeholde opptak/03 Innstillinger/
    # innstillinger.feature (avklart 09.10.2026, review av PR #654).

  Regel: Opptaksforvalter kan sette tidlig søknadsfrist per utdanningstilbud

    Scenario: Sette tidlig søknadsfrist
      Gitt at opptaket åpner for at tidlig søknadsfrist kan angis per utdanningstilbud
      Når opptaksforvalter setter tidlig søknadsfrist for utdanningstilbudet "Politihøyskolen, høst 2027"
      Så har dette utdanningstilbudet en tidligere søknadsfrist enn opptakets generelle frist

    Scenario: Sette tidlig dokumentasjonsfrist
      Gitt at opptaket åpner for at tidlig søknadsfrist kan angis per utdanningstilbud
      Når opptaksforvalter setter tidlig dokumentasjonsfrist til "2027-03-01 23:59" for utdanningstilbudet "Politihøyskolen, høst 2027"
      Så må søkere til dette utdanningstilbudet laste opp dokumentasjon innen denne fristen

  # AVKLART 2026-10-08: Det finnes ingen innstilling for hvilke runder utdanningstilbudet deltar i.
  # Et utdanningstilbud er ute av en runde når det ikke er satt antall tilbud som skal gis for runden,
  # se 14 Plasstildeling/02 Tildelingsinnstillinger/antall_tilbud_som_skal_gis.feature.

  # Hvordan søknadsalternativene fordeles etter regelen, står i tildele_saksbehandlende_organisasjon.feature (@OPT-BEH-BEH-011).
  Regel: Opptaksforvalter kan velge saksbehandlertildelingsregel per utdanningstilbud

    Scenario: Velge saksbehandlertildelingsregel for et utdanningstilbud
      Når opptaksforvalter velger saksbehandlertildelingsregelen "SPE" for utdanningstilbudet "Sykepleie, høst 2027"
      Så fordeles søknadsalternativene til "Sykepleie, høst 2027" etter "SPE"

    Scenario: Utdanningstilbud uten egen saksbehandlertildelingsregel følger opptakets standardregel
      Når opptaksforvalter lagrer utdanningstilbudet "Sykepleie, høst 2027" uten å velge saksbehandlertildelingsregel
      Så fordeles søknadsalternativene til "Sykepleie, høst 2027" etter opptakets standard tildelingsregel

    Scenario: Kun aktive saksbehandlertildelingsregler i opptaket kan velges
      Gitt at saksbehandlertildelingsregelen "TRA" er inaktiv
      Når opptaksforvalter velger saksbehandlertildelingsregel for utdanningstilbudet "Sykepleie, høst 2027"
      Så kan opptaksforvalter kun velge blant de aktive saksbehandlertildelingsreglene i opptaket
      Og ser ikke opptaksforvalter "TRA" blant valgene

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