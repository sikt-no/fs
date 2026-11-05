# language: no
@OPT-BEH-BEH-034 @must @in-progress @scope-automatisk-gsk-konklusjon @ref-OPT-BEH-BEH-004 @ref-OPT-BEH-BEH-015 @ref-OPT-BEH-BEH-021 @ref-OPT-BEH-BEH-029
Egenskap: Håndtere annullert vitnemål
  Som saksbehandler
  ønsker jeg å bli gjort oppmerksom på saker der et vitnemål som er i bruk, blir annullert
  slik at søkeren ikke får grunnlag, poeng eller kravelementer ut fra et vitnemål som ikke lenger gjelder.

  Et vitnemål kan bli annullert etter at det er brukt i saksbehandlingen. Vitnemålet kan da
  være lagt til grunn for poengene, for vurderingen av kravelementer eller for GSK-konklusjonen
  i saken. Annulleringen kommer fra KREG når vitnemålene importeres. Løsningen sjekker da om
  vitnemålet er i bruk i en sak. Er det i bruk, får saken en tagg om at vitnemålet er
  annullert. Er saken ferdig behandlet, og søkeren ikke er med i en plasstildelingsrunde som er
  publisert, settes den tilbake til under behandling, slik at den ikke er med i
  plasstildelingen før saksbehandleren har sett på den igjen.

  Løsningen endrer ikke poengene, kravelementene eller GSK-konklusjonen selv. Saksbehandleren
  vurderer saken og retter det som må rettes.

  # Krav fra brukeren 29.10.2026. Åpne spørsmål avklart 29.10.2026.
  # Behandlingsstatusene står i OPT-BEH-BEH-029. Bare saker som er ferdig behandlet, er med i
  # plasstildelingen. Et annullert vitnemål gir ikke GSK (OPT-BEH-BEH-015), og
  # teller ikke i den automatiske behandlingen (OPT-BEH-BEH-019).
  # Avklart: saksbehandleren får ikke et eget varsel. Merknaden, taggen og statusen er nok,
  # i motsetning til ved nytt vitnemål (OPT-BEH-BEH-021).
  # Avklart: bare annullering ved import fra KREG. Saksbehandleren annullerer ikke vitnemål.
  # Avklart 29.10.2026: GSK-konklusjonen trekkes ikke tilbake automatisk. OPT-BEH-BEH-015
  # («Annullert vitnemål») er endret til dette kravet.
  # Avklart 29.10.2026: bare saker i opptak som ikke er avsluttet, slik som i OPT-BEH-BEH-015
  # og importen (FLY-OPT-VIT-001).
  # Avklart 2026-11-02: er søkeren med i en plasstildelingsrunde som er publisert, har søkeren
  # fått resultatet, og historiske data endres ikke. Saken får taggen, men behandlingsstatusen
  # endres ikke. Erstatter avklaringen 29.10.2026 om at saker i avsluttede opptak ikke merkes.
  # Avklart 2026-11-02: merknaden kommer senere. I dag kan bare en innlogget person skrive en
  # merknad på saken, ikke systemet. Taggen og statusen bygges først.
  # Avklart 2026-11-04: poengene og vurderingen av et kravelement hører til én sak. Da får bare
  # saken hos samme organisasjon taggen. GSK-konklusjonen gjelder hele opptaket. Da får alle
  # søkerens saker i opptaket taggen.
  # Avklart 2026-11-04: saker på trukne søknader får også taggen. Da står taggen klar hvis
  # søknaden blir gjenopprettet.

  Bakgrunn:
    Gitt at søkeren har en sak hos "Universitetet i Oslo"
    Og at søkeren har et vitnemål fra 2025

  @ref-FLY-OPT-VIT-001
  Regel: Saken merkes når et vitnemål som er i bruk, blir annullert

    Scenariomal: Vitnemålet er brukt i <bruk>
      Gitt at vitnemålet fra 2025 er brukt i <bruk> i saken
      Når vitnemålet fra 2025 importeres fra KREG som annullert
      Så får saken taggen "Vitnemål annullert"

      Eksempler:
        | bruk                          |
        | poengene                      |
        | vurderingen av et kravelement |
        | GSK-konklusjonen              |

    Scenario: Vitnemål som ikke er i bruk, endrer ikke saken
      Gitt at vitnemålet fra 2025 ikke er brukt i saken
      Når vitnemålet fra 2025 importeres fra KREG som annullert
      Så får saken ikke taggen "Vitnemål annullert"
      Og behandlingsstatusen til saken er uendret

    Scenario: Alle sakene som bruker vitnemålet, blir merket
      Gitt at søkeren også har en sak hos "Universitetet i Bergen"
      Og at vitnemålet fra 2025 er brukt i begge sakene
      Når vitnemålet fra 2025 importeres fra KREG som annullert
      Så får saken hos "Universitetet i Oslo" taggen "Vitnemål annullert"
      Og saken hos "Universitetet i Bergen" får taggen "Vitnemål annullert"

    Scenario: Saken får taggen også når søkeren er med i en publisert plasstildelingsrunde
      # Avklart 2026-11-03: dette gjelder også når søkeren kan være med i en ny plasstildelingsrunde,
      # for eksempel med ledige studieplasser. Statusen endres ikke, men saksbehandleren ser taggen i
      # sakslisten og avgjør selv hva som skal gjøres.
      Gitt at vitnemålet fra 2025 er brukt i saken
      Og at søkeren er med i en plasstildelingsrunde som er publisert
      Når vitnemålet fra 2025 importeres fra KREG som annullert
      Så får saken taggen "Vitnemål annullert"
      Og saksbehandleren ser taggen "Vitnemål annullert" på saken i sakslisten

  @draft @openquestion
  Regel: Saken får en merknad om det annullerte vitnemålet
    # ÅPNE SPØRSMÅL:
    # - Hvordan skal systemet skrive en merknad på saken? I dag kan bare en innlogget person
    #   skrive merknader. Skal merknaden vises som skrevet av «Opptakssystemet»?

    Scenario: Merknaden viser vitnemålet og hva det er brukt til
      Gitt at vitnemålet fra 2025 er brukt i poengene og GSK-konklusjonen i saken
      Når vitnemålet fra 2025 importeres fra KREG som annullert
      Så viser merknaden på saken at vitnemålet fra 2025 er annullert
      Og merknaden viser at vitnemålet er brukt i poengene og GSK-konklusjonen

  Regel: Løsningen endrer ikke det som bygger på vitnemålet

    Scenario: Poeng, kravelementer og GSK-konklusjon står uendret
      Gitt at vitnemålet fra 2025 er brukt i poengene, kravelementene og GSK-konklusjonen i saken
      Når vitnemålet fra 2025 importeres fra KREG som annullert
      Så er poengene i saken uendret
      Og vurderingen av kravelementene i saken er uendret
      Og GSK-konklusjonen i saken er uendret

  @ref-OPT-PLA-TIL-001 @ref-FLY-OPT-VIT-001
  Regel: En ferdig behandlet sak settes tilbake til under behandling

    Scenario: Ferdig behandlet sak settes tilbake til Under behandling
      Gitt at vitnemålet fra 2025 er brukt i saken
      Og at saken har behandlingsstatusen "Behandlet"
      Og at søkeren ikke er med i en plasstildelingsrunde som er publisert
      Når vitnemålet fra 2025 importeres fra KREG som annullert
      Så har saken behandlingsstatusen "Under behandling"

    Scenario: Saken beholder statusen når søkeren er med i en publisert plasstildelingsrunde
      Gitt at vitnemålet fra 2025 er brukt i saken
      Og at saken har behandlingsstatusen "Behandlet"
      Og at søkeren er med i en plasstildelingsrunde som er publisert
      Når vitnemålet fra 2025 importeres fra KREG som annullert
      Så har saken behandlingsstatusen "Behandlet"

    Scenario: Sak under behandling beholder statusen
      Gitt at vitnemålet fra 2025 er brukt i saken
      Og at saken har behandlingsstatusen "Under behandling"
      Når vitnemålet fra 2025 importeres fra KREG som annullert
      Så har saken behandlingsstatusen "Under behandling"


  Regel: Saksbehandleren fjerner taggen

    Scenario: Saksbehandleren fjerner taggen etter at saken er sett på
      Gitt at saken har taggen "Vitnemål annullert"
      Når saksbehandleren ved Universitetet i Oslo fjerner taggen "Vitnemål annullert"
      Så har saken ikke taggen "Vitnemål annullert"

    Scenario: Taggen blir stående til saksbehandleren fjerner den
      Gitt at saken har taggen "Vitnemål annullert"
      Når saksbehandleren velger et annet vitnemål som grunnlag i saken
      Så har saken fortsatt taggen "Vitnemål annullert"
