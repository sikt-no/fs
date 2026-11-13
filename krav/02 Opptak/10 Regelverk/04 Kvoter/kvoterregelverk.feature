# language: no
# GitHub: #376
@OPT-REG-KVO-001 @must @implemented @scope-regelverk-2027
Egenskap: Kvotetype
  Som opptaksforvalter
  ønsker jeg å definere kvotetyper i regelverkssamlingen
  slik at plasser kan reserveres for bestemte grupper søkere.

  Bakgrunn:
    Gitt at opptaksforvalteren er innlogget
    Og at regelverkssamlingen "UHG2027" er opprettet

  Regel: Opptaksforvalter kan opprette en kvotetype med kode, navn og rangeringsmetode

    Scenario: Opprette ordinær kvote
      Når opptaksforvalteren oppretter en kvotetype med kode "ORD"
      Og opptaksforvalteren angir navn "Ordinær kvote" på bokmål
      Og opptaksforvalteren setter kvoterangering til "KP" (konkurransepoeng)
      Så er kvotetypen "ORD" opprettet i regelverkssamlingen

    Scenario: Opprette førstegangsvitnemålskvote
      Når opptaksforvalteren oppretter en kvotetype med kode "ORDF"
      Og opptaksforvalteren angir navn "Førstegangsvitnemål" på bokmål
      Og opptaksforvalteren setter kvoterangering til "SP" (skolepoeng)
      Så er kvotetypen "ORDF" opprettet i regelverkssamlingen

  Regel: Kvotetyper har navn på flere språk

    Scenario: Flerspråklig navn på kvotetype
      Når opptaksforvalteren oppretter kvotetypen "ORD"
      Og opptaksforvalteren angir navn på bokmål, nynorsk, engelsk og samisk
      Så er navnene på kvotetypen "ORD" lagret på alle fire språk

  @ref-FLY-OPT-AUT-001 @ref-OPT-BEH-BEH-031
  Regel: En kvotetype kan ha en default poengformel

    Scenario: Sette default poengformel
      Gitt at poengformelen "KONKURRANSEPOENG" finnes
      Når opptaksforvalteren oppretter kvotetypen "ORD" med default poengformel "KONKURRANSEPOENG"
      Så brukes poengformelen "KONKURRANSEPOENG" som standard for kvotetypen "ORD"

  # Reglene om kvoteprioritet og default plassflyt på kvotetypen er fjernet 2026-10-14 (retrofitting).
  # fs-admin har dem ikke på kvotetypen. Kvoteprioriteten og standard plassflyt settes for hele
  # regelverkssamlingen (avklart 2026-10-21), se sette_kvoteprioritet.feature og sette_plassflyt.feature.

  @ref-OPT-BEH-BEH-012
  Regel: En kvotetype gjelder for grunnlagene den er koblet til

    Scenario: Koble grunnlag til kvotetype
      Når opptaksforvalteren kobler grunnlagene "VES" og "PRA" til kvotetypen "ORD"
      Så kan søkere som er kvalifisert på grunnlaget "VES" eller "PRA", plasseres i kvotetypen "ORD"

    Scenario: Aldersgrensen følger grunnlaget
      Gitt at grunnlaget "PRA" har aldersgrensen større enn 22 år
      Når opptaksforvalteren kobler grunnlaget "PRA" til kvotetypen "ORD"
      Så gjelder aldersgrensen på grunnlaget "PRA" også for kvotetypen "ORD"

    Scenario: Kvotetype uten grunnlag og kvotespørsmål
      Gitt at kvotetypen "TestKvote" verken har grunnlag eller kvotespørsmål
      Når søknadene i opptaket behandles
      Så plasseres ingen søkere automatisk i kvotetypen "TestKvote"

  @scope-spesialvurdering-2027
  Regel: En kvotetype kan være uten plasser
    # Ny regel 2026-11-06 (TAKE-492). At kvotetypen ikke kan være hovedkvote, motta plassflyt eller få
    # antall studieplasser, står i sette_plassflyt.feature og sette_antall_studieplasser_per_kvote.feature.
    # AVKLART 2026-11-13 (produkteier, etter fs-verify): Det er ingen sperre mot at hovedkvoten settes uten
    # plasser. En hovedkvote som tar imot ledige plasser, stoppes av scenarioet om plassflyt under, men den eneste
    # kvotetypen i en regelverkssamling (som er hovedkvoten) kan settes uten plasser. Det er dumt, men vi ser om det
    # blir et problem før kravet eventuelt gjøres strengere. Scenarioet «Hovedkvoten kan ikke være uten plasser»
    # er fjernet.

    Scenario: Kvotetypen har plasser som standard
      Når opptaksforvalteren oppretter kvotetypen "Ordinær kvote (ORD)"
      Så har kvotetypen "Ordinær kvote (ORD)" plasser

    Scenario: Opprette kvotetype uten plasser
      Når opptaksforvalteren oppretter kvotetypen "Ventekvote (VENT)" uten plasser
      Så har kvotetypen "Ventekvote (VENT)" ikke plasser

    Scenario: En kvotetype som mottar plassflyt, kan ikke være uten plasser
      Gitt at "Samisk førstegangsvitnemål (SAMF)" sender ledige plasser til "Førstegangsvitnemål (ORDF)" i standard plassflyt
      Når opptaksforvalteren vil sette kvotetypen "Førstegangsvitnemål (ORDF)" til å være uten plasser
      Så blir kvotetypen "Førstegangsvitnemål (ORDF)" ikke endret
      Og opptaksforvalteren ser at en kvotetype som mottar plassflyt, må ha plasser

  @scope-spesialvurdering-2027
  Regel: En kvotetype kan være standardkvote for utdanningstilbudene
    # Ny regel 2026-11-06 (TAKE-492). At nye utdanningstilbud får standardkvoten, står i
    # opptaksinnstillinger_utdanningstilbud.feature.
    # AVKLART 2026-11-06 (produkteier): Standardkvoten legges på utdanningstilbudet når det legges til i
    # opptaket. Utdanningstilbud som allerede er i opptaket, får den ikke. Når kvotetypen ikke lenger er
    # standardkvote, blir kvoten stående på utdanningstilbudene som har den.

    Scenario: Kvotetypen er ikke standardkvote som standard
      Når opptaksforvalteren oppretter kvotetypen "Førstegangsvitnemål (ORDF)"
      Så er kvotetypen "Førstegangsvitnemål (ORDF)" ikke standardkvote

    Scenario: Utdanningstilbud som legges til i opptaket, får standardkvoten
      Gitt at kvotetypen "Ventekvote (VENT)" er standardkvote
      Og at opptaket "Samordna opptak 2027" bruker regelverkssamlingen "UHG2027"
      Når utdanningstilbudet "Sykepleie, høst 2027" legges til i opptaket "Samordna opptak 2027"
      Så har utdanningstilbudet "Sykepleie, høst 2027" utdanningskvoten "Ventekvote (VENT)"

    Scenario: Utdanningstilbud som allerede er i opptaket, får ikke standardkvoten
      Gitt at opptaket "Samordna opptak 2027" bruker regelverkssamlingen "UHG2027"
      Og at utdanningstilbudet "Sykepleie, høst 2027" er i opptaket uten utdanningskvoten "Ventekvote (VENT)"
      Når opptaksforvalteren setter kvotetypen "Ventekvote (VENT)" som standardkvote
      Så har utdanningstilbudet "Sykepleie, høst 2027" fortsatt ikke utdanningskvoten "Ventekvote (VENT)"

    Scenario: Kvoten blir stående når kvotetypen ikke lenger er standardkvote
      Gitt at kvotetypen "Ventekvote (VENT)" er standardkvote
      Og at utdanningstilbudet "Sykepleie, høst 2027" har utdanningskvoten "Ventekvote (VENT)"
      Når opptaksforvalteren setter at kvotetypen "Ventekvote (VENT)" ikke er standardkvote
      Så har utdanningstilbudet "Sykepleie, høst 2027" fortsatt utdanningskvoten "Ventekvote (VENT)"
      Men utdanningstilbud som legges til i opptaket etterpå, får ikke utdanningskvoten "Ventekvote (VENT)"

  @scope-spesialvurdering-2027
  Regel: En standardkvote kan stenges for fjerning fra utdanningstilbudet
    # Ny regel 2026-11-06 (TAKE-492). At kvoten ikke kan fjernes fra utdanningstilbudet, står i
    # opptaksinnstillinger_utdanningstilbud.feature.
    # AVKLART 2026-11-06 (produkteier): Innstillingen gjelder alle. Kvotetypen er enten stengt eller åpen for
    # fjerning, og opptaksforvalter ved organisasjonen som eier opptaket, kan ikke overstyre den.
    # AVKLART 2026-11-13 (produkteier, etter fs-admin): Det er bare aktuelt å stenge en kvotetype for fjerning
    # når den er standardkvote. Slutter kvotetypen å være standardkvote, er den åpen for fjerning igjen.
    # Erstatter at alle kvotetyper kan stenges for fjerning. Regelen het «En kvotetype kan stenges for fjerning
    # fra utdanningstilbudet».

    Scenario: Kvotetypen er åpen for fjerning som standard
      Når opptaksforvalteren oppretter kvotetypen "Førstegangsvitnemål (ORDF)"
      Så kan kvotetypen "Førstegangsvitnemål (ORDF)" fjernes fra utdanningstilbudene

    Scenario: Stenge standardkvoten for fjerning
      Gitt at kvotetypen "Ventekvote (VENT)" er standardkvote
      Når opptaksforvalteren stenger kvotetypen "Ventekvote (VENT)" for fjerning fra utdanningstilbudene
      Så kan kvotetypen "Ventekvote (VENT)" ikke fjernes fra utdanningstilbudene

    Scenario: En kvotetype som ikke er standardkvote, kan ikke stenges for fjerning
      Gitt at kvotetypen "Førstegangsvitnemål (ORDF)" ikke er standardkvote
      Når opptaksforvalteren endrer kvotetypen "Førstegangsvitnemål (ORDF)"
      Så kan opptaksforvalteren ikke stenge kvotetypen "Førstegangsvitnemål (ORDF)" for fjerning fra utdanningstilbudene

    Scenario: Kvotetypen åpnes for fjerning når den ikke lenger er standardkvote
      Gitt at kvotetypen "Ventekvote (VENT)" er standardkvote
      Og at kvotetypen "Ventekvote (VENT)" er stengt for fjerning fra utdanningstilbudene
      Når opptaksforvalteren setter at kvotetypen "Ventekvote (VENT)" ikke er standardkvote
      Så kan kvotetypen "Ventekvote (VENT)" fjernes fra utdanningstilbudene

    Scenario: Organisasjonen som eier opptaket, kan ikke overstyre stengingen
      Gitt at kvotetypen "Ventekvote (VENT)" er stengt for fjerning fra utdanningstilbudene
      Og at utdanningstilbudet "Sykepleie, høst 2027" har utdanningskvoten "Ventekvote (VENT)"
      Når opptaksforvalter ved organisasjonen som eier opptaket vil fjerne "Ventekvote (VENT)" fra "Sykepleie, høst 2027"
      Så har utdanningstilbudet "Sykepleie, høst 2027" fortsatt utdanningskvoten "Ventekvote (VENT)"

  @draft @openquestion
  Regel: En kvotetype kan ha fire ulike rangeringsmetoder
    # ÅPNE SPØRSMÅL:
    # - Kvoterangeringen lagres, men brukes ikke i rangeringen (verifisert 2026-10-14). Skal den brukes?
    # - IH betyr «Sivilingeniør, ingeniørhøgskole» i kodeverket, ikke «individuell helhetsvurdering». Hva er riktig?
    # - Koden for «individuell vurdering (uten poengberegning)» er ikke bestemt (IV i eksempelet). Erstatter den
    #   SPEV («Spesiell vurdering/ikke poengberegning») i kodeverket, eller er den en ny kode?
    # AVKLART 2026-11-06 (produkteier): SPEV erstattes av rangeringsmetoden «individuell vurdering (uten
    # poengberegning)», for søkere som ikke har vanlige konkurransepoeng. Funksjonen SPEV-kvoten har hatt, er en
    # kvotetype uten plasser med skjulte poeng, se opprette_ventekvote.feature.

    Scenariomal: Kvoterangering
      Når opptaksforvalteren oppretter en kvotetype med kvoterangering "<metode>"
      Så rangeres søkere i kvoten etter <beskrivelse>

      Eksempler:
        | metode | beskrivelse                                 |
        | KP     | konkurransepoeng                            |
        | SP     | skolepoeng                                  |
        | IV     | individuell vurdering (uten poengberegning) |
        | IH     | individuell helhetsvurdering                |

  @scope-spesialvurdering-2027
  Regel: En kvotetype kan skjule poengene for søkeren
    # AVKLART 2026-11-11 (produkteier): Om søkeren ser poengene, kan avhenge av kvoten, ikke bare grunnlaget.
    # Søkeren kan bli vurdert på samme grunnlag i en kvote som skjuler poengene (ventekvoten) og i en kvote
    # som viser dem (opptaksprøvepoeng). Innstillingen på grunnlaget finnes fortsatt, se grunnlag.feature.
    # Søkeren ser poengene i svaret når resultatet av plasstildelingen er publisert, se
    # 14 Plasstildeling/04 Resultat/publisere_resultat.feature.

    Scenario: Kvotetypen viser poengene for søkeren som standard
      Når opptaksforvalteren oppretter kvotetypen "Førstegangsvitnemål (ORDF)"
      Så vises poengene i kvotetypen "Førstegangsvitnemål (ORDF)" for søkeren

    Scenario: Skjule poengene i kvotetypen for søkeren
      Når opptaksforvalteren angir at poengene i kvotetypen "Ventekvote (VENT)" skal skjules for søkeren
      Så er kvotetypen "Ventekvote (VENT)" lagret med skjulte poeng

  Regel: En kvotetype kan slettes når den ikke er i bruk

    Scenario: Slette kvotetype
      Gitt at kvotetypen "TestKvote" ikke er knyttet til noe utdanningstilbud
      Når opptaksforvalteren sletter kvotetypen "TestKvote"
      Så er kvotetypen "TestKvote" slettet

    Scenario: Kan ikke slette kvotetype som er i bruk
      Gitt at kvotetypen "ORD" er knyttet til utdanningstilbud
      Når opptaksforvalteren forsøker å slette kvotetypen "ORD"
      Så blir kvotetypen "ORD" ikke slettet
      Og opptaksforvalteren får beskjed om at kvotetypen "ORD" ikke kunne slettes
