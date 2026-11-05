# language: no
# GitHub: #597
@OPT-OPT-UTD-004 @must @draft @scope-utdanningstilbud-2027
Egenskap: Opptaksinnstillinger per utdanningstilbud
  Som opptaksforvalter
  ønsker jeg å sette opptaksinnstillinger per utdanningstilbud
  slik at hvert utdanningstilbud har riktige regler for søknadsbehandling og plasstildeling.

  # Opptaksforvalter ved deltakende organisasjon kan sette innstillinger på egne utdanningstilbud.
  # Opptaksforvalter ved forvaltende organisasjon kan sette innstillinger på alle utdanningstilbud.
  # Innstillinger for flere utdanningstilbud av gangen står i sette_innstillinger_for_flere_utdanningstilbud.feature (#599).
  # Antall studieplasser står i sette_studieplasser_og_antall_tilbud.feature (#596).
  # Tidlig søknadsfrist og dokumentasjonsfrist står i 04 Behandle et utdanningstilbud/sette_tidlig_søknadsfrist.feature (SHI-708).
  # ÅPNE SPØRSMÅL:
  # - Kommentarene over viser til tre krav i fritekst. Skal de bli referanser på Egenskap-linja:
  #   @ref-OPT-OPT-UTD-008 (sette_innstillinger_for_flere_utdanningstilbud.feature),
  #   @ref-OPT-OPT-UTD-007 (sette_studieplasser_og_antall_tilbud.feature) og
  #   @ref-OPT-OPT-UTD-025 (sette_tidlig_søknadsfrist.feature)?
  # - Kommentaren mellom regelen om poenggrensen og regelen om behandlertildelingsregel viser til
  #   antall_tilbud_som_skal_gis.feature. Skal den bli @ref-OPT-PLA-INN-001, og på hvilken del?

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at opptaket "Samordna opptak 2027" har utdanningstilbud

  @openquestion
  Regel: Opptaksforvalter kan sette kompetanseregelverk og rangeringsregelverk
    # ÅPNE SPØRSMÅL:
    # - Kommentaren om at regelverkssamlingen ikke kan byttes, viser til innstillinger.feature i fritekst.
    #   Skal regelen ha @ref-OPT-OVO-INN-001?

    Scenario: Sette regelverk på ett utdanningstilbud
      Når opptaksforvalter velger utdanningstilbudet "Sykepleie, høst 2027"
      Og opptaksforvalter setter kompetanseregelverk til "GSK"
      Og opptaksforvalter setter rangeringsregelverk til "Ordinær rangering"
      Så vurderes søkere til "Sykepleie, høst 2027" etter GSK-kravene
      Og søkere rangeres etter reglene i "Ordinær rangering"

    Scenario: Kun regelverk fra opptakets regelverkssamling kan velges
      Når opptaksforvalter setter regelverk for et utdanningstilbud
      Så kan opptaksforvalter kun velge blant regelverkene i opptakets regelverkssamling

    # Opptakets regelverkssamling kan ikke byttes når utdanningstilbud er knyttet til opptaket (avklart 2026-10-21,
    # 11 Opprette og vedlikeholde opptak/03 Innstillinger/innstillinger.feature).

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
  # som absolutte tall per utdanningskvote for hvert utdanningstilbud i hver plasstildelingsrunde, se
  # 14 Plasstildeling/02 Tildelingsinnstillinger/antall_tilbud_som_skal_gis.feature.
  # AVKLART 2026-10-16 (produktleder): Bare organisasjonen som har opprettet regelverket, kan endre det.
  # I samordna opptak kan forvaltende organisasjon legge til kvoter i regelverkssamlingen som er knyttet
  # til opptaket.
  # AVKLART 2026-10-21 (produkteier): Lærestedet velger hvilke av kvotetypene i regelverkssamlingen som gjelder
  # for utdanningstilbudene sine, og kan legge til og fjerne utdanningskvoter. Utdanningstilbudet får ikke alle
  # kvotetypene automatisk. Det erstatter avklaringen 2026-10-16 om at deltakende organisasjoner verken kan legge
  # til eller fjerne utdanningskvoter.
  @openquestion
  Regel: Lærestedet velger utdanningskvotene blant kvotetypene i regelverkssamlingen
    # ÅPNE SPØRSMÅL:
    # - Avklaringene viser til antall_tilbud_som_skal_gis.feature og plassflyt.feature i fritekst. Skal
    #   regelen ha @ref-OPT-PLA-INN-001 og @ref-OPT-PLA-INN-002 (eller @depends-on-, hvis den må sjekkes
    #   når de endres)?

    Scenario: Legge til utdanningskvoter fra regelverkssamlingen
      Gitt at opptaket bruker regelverkssamlingen "UHG 2027"
      Og at regelverkssamlingen "UHG 2027" har kvotetypene "Samisk førstegangsvitnemål (SAMF)", "Førstegangsvitnemål (ORDF)" og "Ordinær kvote (ORD)"
      Når opptaksforvalter ved lærestedet legger til "Førstegangsvitnemål (ORDF)" og "Ordinær kvote (ORD)" på utdanningstilbudet "Sykepleie, høst 2027"
      Så har utdanningstilbudet "Sykepleie, høst 2027" utdanningskvotene "Førstegangsvitnemål (ORDF)" og "Ordinær kvote (ORD)"

    # AVKLART 2026-10-21 (produkteier): Alle utdanningstilbud i opptak som bruker regelverkssamlingen, må ha
    # hovedkvoten. De andre kvotetypene er valgfrie, og flytretningen gjelder likevel, se
    # 14 Plasstildeling/02 Tildelingsinnstillinger/plassflyt.feature.
    Scenario: Utdanningstilbudet må ha hovedkvoten
      Gitt at "Ordinær kvote (ORD)" er hovedkvoten i regelverkssamlingen for opptaket
      Og at utdanningstilbudet "Sykepleie, høst 2027" ikke har utdanningskvoten "Ordinær kvote (ORD)"
      Når opptaksforvalter ved lærestedet lagrer utdanningstilbudet
      Så blir utdanningstilbudet ikke lagret
      Og opptaksforvalter ser at utdanningstilbudet må ha hovedkvoten "Ordinær kvote (ORD)"

    Scenario: Hovedkvoten kan ikke fjernes fra utdanningstilbudet
      Gitt at "Ordinær kvote (ORD)" er hovedkvoten i regelverkssamlingen for opptaket
      Og at utdanningstilbudet "Sykepleie, høst 2027" har utdanningskvoten "Ordinær kvote (ORD)"
      Når opptaksforvalter ved lærestedet vil fjerne "Ordinær kvote (ORD)" fra utdanningstilbudet
      Så kan opptaksforvalter ikke fjerne "Ordinær kvote (ORD)"

    Scenario: Fjerne en utdanningskvote fra utdanningstilbudet
      Gitt at utdanningstilbudet "Sykepleie, høst 2027" har utdanningskvotene "Førstegangsvitnemål (ORDF)" og "Ordinær kvote (ORD)"
      Når opptaksforvalter ved lærestedet fjerner "Førstegangsvitnemål (ORDF)" fra utdanningstilbudet
      Så har utdanningstilbudet "Sykepleie, høst 2027" bare utdanningskvoten "Ordinær kvote (ORD)"

    Scenario: Kvotetyper som ikke er i regelverkssamlingen, kan ikke legges til
      Gitt at kvotetypen "Samisk språkkompetanse (SAM)" ikke er med i regelverkssamlingen for opptaket
      Når opptaksforvalter ved lærestedet vil legge til "Samisk språkkompetanse (SAM)" på utdanningstilbudet "Sykepleie, høst 2027"
      Så avvises forespørselen

    # AVKLART 2026-10-21 (produkteier): En kvotetype kan ikke brukes av utdanningstilbud før den har
    # kvoteprioritet og er koblet til plassflyten i regelverkssamlingen.
    Scenariomal: Kvotetype uten <mangler> kan ikke legges til
      Gitt at kvotetypen "Idrett (IDRETT)" i regelverkssamlingen for opptaket mangler <mangler>
      Når opptaksforvalter ved lærestedet vil legge til "Idrett (IDRETT)" på utdanningstilbudet "Idrett, høst 2027"
      Så kan opptaksforvalter ikke legge til "Idrett (IDRETT)" på utdanningstilbudet

      Eksempler:
        | mangler         |
        | kvoteprioritet  |
        | plassflyt       |

    Scenario: Regelverksforvalter legger til en kvotetype i regelverkssamlingen
      Gitt at regelverksforvalter er ved forvaltende organisasjon "HK-dir"
      Og at HK-dir har opprettet regelverkssamlingen "UHG 2027"
      Når regelverksforvalter legger til kvotetypen "Samisk språkkompetanse (SAM)" i regelverkssamlingen "UHG 2027"
      Så har regelverkssamlingen "UHG 2027" kvotetypen "Samisk språkkompetanse (SAM)"

  # AVKLART 2026-10-21 (produkteier): Utdanningskvotene følger kvoteprioriteten og plassflyten som er satt i
  # regelverkssamlingen opptaket bruker. Lærestedet setter dem ikke selv.
  @depends-on-OPT-REG-KVO-003 @depends-on-OPT-REG-KVO-004
  Regel: Utdanningskvotene følger kvoteprioriteten og plassflyten i regelverkssamlingen

    Scenario: Utdanningskvotene får kvoteprioriteten fra regelverkssamlingen
      Gitt at kvoteprioriteten i regelverkssamlingen "UHG 2027" er 1 for "Samisk førstegangsvitnemål (SAMF)", 2 for "Førstegangsvitnemål (ORDF)" og 3 for "Ordinær kvote (ORD)"
      Og at opptaket bruker regelverkssamlingen "UHG 2027"
      Når opptaksforvalter ved lærestedet legger til "Førstegangsvitnemål (ORDF)" og "Ordinær kvote (ORD)" på utdanningstilbudet "Sykepleie, høst 2027"
      Så har utdanningskvotene på utdanningstilbudet kvoteprioriteten fra regelverkssamlingen
        | utdanningskvote            | kvoteprioritet |
        | Førstegangsvitnemål (ORDF) | 2              |
        | Ordinær kvote (ORD)        | 3              |

    Scenario: Utdanningskvotene følger plassflyten i regelverkssamlingen
      Gitt at standard plassflyt i regelverkssamlingen "UHG 2027" sender "Førstegangsvitnemål (ORDF)" til "Ordinær kvote (ORD)"
      Og at opptaket bruker regelverkssamlingen "UHG 2027"
      Når opptaksforvalter ved lærestedet legger til "Førstegangsvitnemål (ORDF)" og "Ordinær kvote (ORD)" på utdanningstilbudet "Sykepleie, høst 2027"
      Så går ledige plasser i "Førstegangsvitnemål (ORDF)" til "Ordinær kvote (ORD)" på utdanningstilbudet

  # Hva plasstildelingen gjør med plassflyten, og vernet mot sirkulær plassflyt (#598), står i
  # 14 Plasstildeling/02 Tildelingsinnstillinger/plassflyt.feature.
  # AVKLART 2026-10-15: Plassflyten kan ikke settes eller overstyres per utdanningstilbud. Regelen
  # «Opptaksforvalter kan sette plassflyt mellom utdanningskvoter» er fjernet. Utdanningstilbudet viser
  # bare plassflyten mellom utdanningskvotene som er knyttet til det.
  @depends-on-OPT-REG-KVO-003 @depends-on-OPT-REG-KVO-004 @openquestion
  Regel: Lærestedene ser plassflyten og kvoteprioriteten for utdanningstilbudene sine
    # ÅPNE SPØRSMÅL:
    # - Kommentaren over regelen viser til plassflyt.feature i fritekst. Skal regelen ha
    #   @ref-OPT-PLA-INN-002?

    # Ønske meldt 2026-10-13, utvidet med kvoteprioriteten 2026-10-15. Plassflyten og kvoteprioriteten settes i
    # regelverkssamlingen (endret 2026-10-21), se 10 Regelverk/04 Kvoter/sette_plassflyt.feature og
    # sette_kvoteprioritet.feature. Lærestedet ser dem på utdanningstilbudet, så de forstår sammenhengen mellom
    # utdanningskvotene.

    Scenario: Se plassflyten for et utdanningstilbud
      Gitt at standard plassflyt i regelverkssamlingen sender "Samisk førstegangsvitnemål (SAMF)" og "Førstegangsvitnemål (ORDF)" til "Ordinær kvote (ORD)"
      Og at utdanningstilbudet "Sykepleie, høst 2027" har utdanningskvotene "Samisk førstegangsvitnemål (SAMF)", "Førstegangsvitnemål (ORDF)" og "Ordinær kvote (ORD)"
      Når opptaksforvalter ved lærestedet ser utdanningstilbudet "Sykepleie, høst 2027"
      Så ser opptaksforvalter plassflyten mellom utdanningskvotene på utdanningstilbudet
        | fra                               | til                 |
        | Samisk førstegangsvitnemål (SAMF) | Ordinær kvote (ORD) |
        | Førstegangsvitnemål (ORDF)        | Ordinær kvote (ORD) |

    Scenario: Kvoter som ikke er på utdanningstilbudet, vises ikke i plassflyten
      Gitt at standard plassflyt i regelverkssamlingen har kvoten "Nordnorsk (NN)"
      Og at utdanningstilbudet "Sykepleie, høst 2027" ikke har utdanningskvoten "Nordnorsk (NN)"
      Når opptaksforvalter ved lærestedet ser utdanningstilbudet "Sykepleie, høst 2027"
      Så vises ikke "Nordnorsk (NN)" i plassflyten for utdanningstilbudet

    Scenario: Se kvoteprioriteten for et utdanningstilbud
      Gitt at kvoteprioriteten i regelverkssamlingen er 1 for "Samisk førstegangsvitnemål (SAMF)", 4 for "Førstegangsvitnemål (ORDF)" og 12 for "Ordinær kvote (ORD)"
      Og at utdanningstilbudet "Sykepleie, høst 2027" har utdanningskvotene "Samisk førstegangsvitnemål (SAMF)", "Førstegangsvitnemål (ORDF)" og "Ordinær kvote (ORD)"
      Når opptaksforvalter ved lærestedet ser utdanningstilbudet "Sykepleie, høst 2027"
      Så ser opptaksforvalter kvoteprioriteten for utdanningskvotene på utdanningstilbudet
        | utdanningskvote                   | kvoteprioritet |
        | Samisk førstegangsvitnemål (SAMF) | 1              |
        | Førstegangsvitnemål (ORDF)        | 4              |
        | Ordinær kvote (ORD)               | 12             |

    Scenario: Lærestedet kan ikke endre plassflyten eller kvoteprioriteten
      Når opptaksforvalter ved lærestedet ser utdanningstilbudet "Sykepleie, høst 2027"
      Så ser opptaksforvalter ikke muligheten til å endre plassflyten eller kvoteprioriteten

  @depends-on-OPT-OVO-INN-001 @openquestion
  Regel: Opptaksforvalter kan markere at et utdanningstilbud tilbyr tidlig opptak
    # ÅPNE SPØRSMÅL:
    # - Kommentarene i regelen viser til publisere_svar_på_tidlig_opptak.feature og
    #   gi_tilbudsgaranti_ved_tidlig_opptak.feature i fritekst. Skal regelen ha @ref-OPT-BEH-BEH-014 og
    #   @ref-OPT-BEH-BEH-007, eller skal scenarioet om poenggrensen ha @depends-on-OPT-BEH-BEH-007?

    Scenario: Markere at utdanningstilbudet tilbyr tidlig opptak
      Gitt at opptaket åpner for tidlig opptak
      Når opptaksforvalter markerer at utdanningstilbudet "Sykepleie, høst 2027" tilbyr tidlig opptak
      Så kan søkere som oppfyller kriteriene få tidlig svar på "Sykepleie, høst 2027"
      # Svaret på tidlig opptak publiseres for hele opptaket når tidligopptaket
      # gjennomføres, ikke per utdanningstilbud, se publisere_svar_på_tidlig_opptak.feature
      # (avklart 25.09.2026, uten egen publiseringsdato fra 09.10.2026).

    Scenario: Sette poenggrense for tidlig opptak
      Gitt utdanningstilbudet "Sykepleie, høst 2027" tilbyr tidlig opptak
      Når opptaksforvalter setter poenggrensen for tidlig opptak til 50 for utdanningstilbudet "Sykepleie, høst 2027"
      Så får søkere som deltar i tidligopptaket og har minst 50 poeng, tilbudsgaranti på "Sykepleie, høst 2027"
      # Se gi_tilbudsgaranti_ved_tidlig_opptak.feature. En egen verdi beregnet fra fjorårets
      # opptak kommer eventuelt senere (STEK-352).

    # Lenken til informasjon om tidlig opptak settes per opptak, ikke per
    # utdanningstilbud, se 11 Opprette og vedlikeholde opptak/03 Innstillinger/
    # innstillinger.feature (avklart 09.10.2026, review av PR #654).

  @openquestion
  Regel: Deltakende organisasjon kan ikke endre poenggrensen for tidlig opptak etter fristen
    # ÅPNE SPØRSMÅL:
    # - Regelen bruker fristen for å sette poenggrenser fra frister_og_hendelser.feature. Skal den ha
    #   @depends-on-OPT-OVO-FRI-001?

    # Virkningen av fristen for å sette poenggrenser for tidlig opptak, som opptaksforvalter setter i
    # 11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature.
    # Lagt til 2026-10-19 etter akseptansetesten av opprette og vedlikeholde opptak.
    # AVKLART 2026-10-15 (Q12, TAKE-409): Fristen hindrer deltakende organisasjoner i å endre poenggrensene
    # etter fristen. Forvaltende organisasjon kan fortsatt endre poenggrensene.

    Scenario: Lærestedet kan ikke endre poenggrensen for tidlig opptak etter fristen
      Gitt at opptaket har aktivert tidlig opptak
      Og at fristen for å sette poenggrenser for tidlig opptak er "2027-02-15 23:59"
      Og at fristen er ute
      Når opptaksforvalter ved deltakende organisasjon vil endre poenggrensen for tidlig opptak på "Sykepleie, høst 2027"
      Så kan opptaksforvalter ved deltakende organisasjon ikke endre poenggrensen
      Men opptaksforvalter ved forvaltende organisasjon kan fortsatt endre poenggrensen

  # AVKLART 2026-10-08: Det finnes ingen innstilling for hvilke plasstildelingsrunder utdanningstilbudet deltar i.
  # Et utdanningstilbud er ute av en plasstildelingsrunde når det ikke er satt antall tilbud som skal gis for plasstildelingsrunden,
  # se 14 Plasstildeling/02 Tildelingsinnstillinger/antall_tilbud_som_skal_gis.feature.

  @depends-on-OPT-BEH-BEH-011 @ref-FLY-OPT-SAK-001
  Regel: Opptaksforvalter kan velge behandlertildelingsregel per utdanningstilbud
    # Reglene, og om de er aktive, settes der. Hvordan søknadsalternativene fordeles etter regelen, står også der.

    Scenario: Velge behandlertildelingsregel for et utdanningstilbud
      Når opptaksforvalter velger behandlertildelingsregelen "SPE" for utdanningstilbudet "Sykepleie, høst 2027"
      Så fordeles søknadsalternativene til "Sykepleie, høst 2027" etter "SPE"

    Scenario: Utdanningstilbud uten egen behandlertildelingsregel følger opptakets standardregel
      Når opptaksforvalter lagrer utdanningstilbudet "Sykepleie, høst 2027" uten å velge behandlertildelingsregel
      Så fordeles søknadsalternativene til "Sykepleie, høst 2027" etter opptakets standard behandlertildelingsregel

    Scenario: Kun aktive behandlertildelingsregler i opptaket kan velges
      Gitt at behandlertildelingsregelen "TRA" er inaktiv
      Når opptaksforvalter velger behandlertildelingsregel for utdanningstilbudet "Sykepleie, høst 2027"
      Så kan opptaksforvalter kun velge blant de aktive behandlertildelingsreglene i opptaket
      Men opptaksforvalter ser ikke "TRA" blant valgene

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Er det lov å overstyre visning av poenggrenser og ventelistenummer
  #   for søkere i samordna opptak? Bør dette være opptaksinnstillinger i stedet?
  Regel: Opptaksforvalter kan styre visning av poenggrense og ventelistenummer

    Scenario: Velge å vise poenggrense for søker
      Når opptaksforvalter angir at poenggrense skal vises for søkere på utdanningstilbudet "Sykepleie, høst 2027"
      Så kan søkere se poenggrensen for "Sykepleie, høst 2027"

    Scenario: Velge å vise ventelistenummer for søker
      Når opptaksforvalter angir at ventelistenummer skal vises for søkere på utdanningstilbudet "Sykepleie, høst 2027"
      Så kan søkere se sitt ventelistenummer for "Sykepleie, høst 2027"

  Regel: Opptaksforvalter kan sette opplysninger om tilbudsgaranti

    Scenario: Sette hvor tilbudsgarantier tas fra
      Når opptaksforvalter angir at tilbudsgarantier for utdanningstilbudet "Sykepleie, høst 2027" skal tas fra ordinær kvote
      Så tas tilbudsgarantier fra ordinær kvote i plasstildelingen