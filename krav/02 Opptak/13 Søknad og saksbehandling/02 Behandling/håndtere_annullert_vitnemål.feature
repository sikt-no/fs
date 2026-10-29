# language: no
@OPT-BEH-BEH-034 @must @planned@ref-OPT-BEH-BEH-004 @ref-OPT-BEH-BEH-015 @ref-OPT-BEH-BEH-021 @ref-OPT-BEH-BEH-029
Egenskap: Håndtere annullert vitnemål
  Som saksbehandler
  ønsker jeg å bli gjort oppmerksom på saker der et vitnemål som er i bruk, blir annullert
  slik at søkeren ikke får grunnlag, poeng eller kravelementer ut fra et vitnemål som ikke lenger gjelder.

  Et vitnemål kan bli annullert etter at det er brukt i saksbehandlingen. Vitnemålet kan da
  være lagt til grunn for poengene, for vurderingen av kravelementer eller for GSK-konklusjonen
  i saken. Annulleringen kommer fra KREG når vitnemålene importeres. Løsningen sjekker da om
  vitnemålet er i bruk i en sak. Er det i bruk, får saken en merknad og en tagg om at
  vitnemålet er annullert. Er saken ferdig behandlet, settes den tilbake til under behandling,
  slik at den ikke er med i plasstildelingen før saksbehandleren har sett på den igjen.

  Løsningen endrer ikke poengene, kravelementene eller GSK-konklusjonen selv. Saksbehandleren
  vurderer saken og retter det som må rettes.

  # Krav fra brukeren 29.10.2026. Åpne spørsmål avklart 29.10.2026.
  # Behandlingsstatusene står i OPT-BEH-BEH-029. Bare saker som er ferdig behandlet, er med i
  # plasstildelingen. Et annullert vitnemål får ingen påstand om GSK (OPT-BEH-BEH-015), og
  # teller ikke i den automatiske behandlingen (OPT-BEH-BEH-019).
  # Avklart: saksbehandleren får ikke et eget varsel. Merknaden, taggen og statusen er nok,
  # i motsetning til ved nytt vitnemål (OPT-BEH-BEH-021).
  # Avklart: bare annullering ved import fra KREG. Saksbehandleren annullerer ikke vitnemål.

  Bakgrunn:
    Gitt at søkeren har en sak hos "Universitetet i Oslo"
    Og at søkeren har et vitnemål fra 2025

  Regel: Saken merkes når et vitnemål som er i bruk, blir annullert

    Scenariomal: Vitnemålet er brukt i <bruk>
      Gitt at vitnemålet fra 2025 er brukt i <bruk> i saken
      Når vitnemålet fra 2025 importeres fra KREG som annullert
      Så får saken en merknad om at vitnemålet er annullert
      Og saken får taggen "Vitnemål annullert"

      Eksempler:
        | bruk                          |
        | poengene                      |
        | vurderingen av et kravelement |
        | GSK-konklusjonen              |

    Scenario: Merknaden viser vitnemålet og hva det er brukt til
      Gitt at vitnemålet fra 2025 er brukt i poengene og GSK-konklusjonen i saken
      Når vitnemålet fra 2025 importeres fra KREG som annullert
      Så viser merknaden på saken at vitnemålet fra 2025 er annullert
      Og merknaden viser at vitnemålet er brukt i poengene og GSK-konklusjonen

    Scenario: Vitnemål som ikke er i bruk, endrer ikke saken
      Gitt at vitnemålet fra 2025 ikke er brukt i saken
      Når vitnemålet fra 2025 importeres fra KREG som annullert
      Så får saken ingen merknad om at vitnemålet er annullert
      Og saken får ikke taggen "Vitnemål annullert"
      Og behandlingsstatusen til saken er uendret

    Scenario: Alle sakene som bruker vitnemålet, blir merket
      Gitt at søkeren også har en sak hos "Universitetet i Bergen"
      Og at vitnemålet fra 2025 er brukt i begge sakene
      Når vitnemålet fra 2025 importeres fra KREG som annullert
      Så får saken hos "Universitetet i Oslo" taggen "Vitnemål annullert"
      Og saken hos "Universitetet i Bergen" får taggen "Vitnemål annullert"

  Regel: Løsningen endrer ikke det som bygger på vitnemålet

    Scenario: Poeng, kravelementer og GSK-konklusjon står uendret
      Gitt at vitnemålet fra 2025 er brukt i poengene, kravelementene og GSK-konklusjonen i saken
      Når vitnemålet fra 2025 importeres fra KREG som annullert
      Så er poengene i saken uendret
      Og vurderingen av kravelementene i saken er uendret
      Og GSK-konklusjonen i saken er uendret

  @ref-OPT-PLA-TIL-001
  Regel: En ferdig behandlet sak settes tilbake til under behandling

    Scenario: Ferdig behandlet sak settes tilbake til Under behandling
      Gitt at vitnemålet fra 2025 er brukt i saken
      Og at saken har behandlingsstatusen "Ferdig behandlet"
      Når vitnemålet fra 2025 importeres fra KREG som annullert
      Så har saken behandlingsstatusen "Under behandling"

    Scenario: Sak under behandling beholder statusen
      Gitt at vitnemålet fra 2025 er brukt i saken
      Og at saken har behandlingsstatusen "Under behandling"
      Når vitnemålet fra 2025 importeres fra KREG som annullert
      Så har saken behandlingsstatusen "Under behandling"

    Scenario: Søkeren med tilbud får saken satt tilbake til Under behandling
      Gitt at vitnemålet fra 2025 er brukt i saken
      Og at søkeren har fått tilbud på et søknadsalternativ i saken
      Når vitnemålet fra 2025 importeres fra KREG som annullert
      Så har saken behandlingsstatusen "Under behandling"
      Og saken får taggen "Vitnemål annullert"
      Og tilbudet til søkeren er uendret

  Regel: Saksbehandleren fjerner taggen

    Scenario: Saksbehandleren fjerner taggen etter at saken er sett på
      Gitt at saken har taggen "Vitnemål annullert"
      Når saksbehandleren ved Universitetet i Oslo fjerner taggen "Vitnemål annullert"
      Så har saken ikke taggen "Vitnemål annullert"
      Og saken har fortsatt merknaden om at vitnemålet er annullert

    Scenario: Taggen blir stående til saksbehandleren fjerner den
      Gitt at saken har taggen "Vitnemål annullert"
      Når saksbehandleren velger et annet vitnemål som grunnlag i saken
      Så har saken fortsatt taggen "Vitnemål annullert"
