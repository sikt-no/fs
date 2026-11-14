# language: no
@FLY-OPT-FLE-001 @must @draft @e2e @ref-FLY-OPT-VAL-001
Egenskap: Behandle søknad med flere vitnemål i vitnemålsbehandleren
  Fra søkeren med flere digitale vitnemål fra KREG har en sak som ikke er behandlet, til
  saksbehandleren har satt saken til ferdig behandlet. Saken behandles ikke helautomatisk, og
  beholder behandlingsstatusen «Ikke behandlet». Saksbehandleren behandler vitnemålene i
  vitnemålsbehandleren: velger grunnlaget, og vitnemålet og fagene for hver poengvariant, og ser at
  poengene og kravelementene blir registrert. GSK-konklusjonen bygger på vitnemålet saksbehandleren
  har valgt. Saksbehandleren behandler så resten av søknaden (tilleggspoeng og kvotespørsmål), og
  setter saken til ferdig behandlet.

  # ÅPNE SPØRSMÅL:
  # - Skal saksbehandleren kunne velge et vitnemål og behandle saken automatisk på det
  #   («behandle vitnemål automatisk») i vitnemålsbehandleren? Muligheten er levert (regelen «Har
  #   søkeren flere vitnemål, behandles saken automatisk på vitnemålet saksbehandleren velger» i
  #   OPT-BEH-BEH-039 er @implemented, og står i FLY-OPT-VAL-001), men kravet sier ikke hvor den
  #   finnes. Ja: fasen legges til i flyten, med @depends-on-OPT-BEH-BEH-039. Nei: det avklares om
  #   muligheten skal avvikles (fs-krav, modus C).

  Bakgrunn:
    Gitt at søkeren har vitnemålene "Vitnemål 2024" og "Vitnemål 2025" fra KREG, som begge gir GSK

  @depends-on-OPT-BEH-BEH-025
  # OPT-BEH-BEH-025: «Bare saker der søkeren har ett vitnemål, og vitnemålet gir GSK, behandles helautomatisk»
  Regel: Saken behandles ikke automatisk når søkeren har flere vitnemål

    Scenario: Saken med flere vitnemål er ikke behandlet etter den automatiske behandlingen
      Gitt at saken har behandlingsstatusen "Ikke behandlet"
      Når søknaden behandles automatisk
      Så behandles ikke saken helautomatisk
      Og saken har fortsatt behandlingsstatusen "Ikke behandlet"

  @depends-on-OPT-BEH-BEH-019 @depends-on-OPT-BEH-BEH-029
  # OPT-BEH-BEH-019: «Grunnlag som saksbehandleren har valgt, endres ikke av automatikken»
  # OPT-BEH-BEH-029: «Saken blir Under behandling når saksbehandleren endrer vurderingen»
  Regel: Saksbehandleren velger grunnlaget

    Scenario: Saken er under behandling når saksbehandleren har valgt grunnlaget
      Gitt at saken har behandlingsstatusen "Ikke behandlet"
      Når saksbehandleren hos behandleren registrerer et grunnlag
      Så har saken behandlingsstatusen "Under behandling"

  @depends-on-OPT-BEH-BEH-005 @depends-on-OPT-BEH-BEH-004 @depends-on-OPT-BEH-BEH-022 @depends-on-OPT-BEH-BEH-020
  # OPT-BEH-BEH-005: «Søkerens elektroniske vitnemål vises»
  # OPT-BEH-BEH-004: «Poengene beregnes og lagres når saksbehandleren bruker dem»
  # OPT-BEH-BEH-022: «Vitnemålet kan velges per poengvariant», «Fagvalget gjøres per poengvariant»
  # OPT-BEH-BEH-020: «Når grunnlaget endres, vurderes kravene på nytt»
  Regel: Saksbehandleren velger vitnemål og fag per poengvariant i vitnemålsbehandleren

    Scenario: Poengene og kravelementene er registrert fra vitnemålet saksbehandleren har valgt
      Gitt at saken har et grunnlag
      Når saksbehandleren legger "Vitnemål 2025" til grunn for poengvarianten grunnlaget bruker
      Og saksbehandleren velger hvilke fag som skal telle
      Og saksbehandleren velger å bruke poengene
      Så er poengene for poengvarianten lagret fra "Vitnemål 2025"
      Og kravelementene er vurdert mot "Vitnemål 2025"

    @openquestion
    Scenariomal: Vitnemålsbehandleren gir poeng for poengvarianten til grunnlaget <grunnlag>
      # ÅPNE SPØRSMÅL:
      # - Hvilke grunnlag og poengvarianter (VPL) skal eksemplene ha? Bare grunnlag som gir et annet
      #   utfall i vitnemålsbehandleren, bør stå (for eksempel førstegangsvitnemål mot ordinær kvote,
      #   eller to søknadsalternativer med ulike spesielle opptakskrav).
      Gitt at saken har grunnlaget <grunnlag>
      Når saksbehandleren legger "Vitnemål 2025" til grunn for poengvarianten <poengvariant>
      Og saksbehandleren velger å bruke poengene
      Så er poengene for poengvarianten <poengvariant> lagret fra "Vitnemål 2025"

      Eksempler:
        | grunnlag | poengvariant |

  @openquestion
  Regel: GSK-konklusjonen bygger på vitnemålet saksbehandleren har valgt
    # ÅPNE SPØRSMÅL:
    # - Kravet mangler. Det er en ny måte å vurdere en søknad med flere vitnemål fra KREG på:
    #   saksbehandleren velger vitnemålet ut fra hvordan søknaden skal behandles, og
    #   GSK-konklusjonen følger valget. I dag setter OPT-BEH-BEH-015 («Konklusjon på søknaden fra
    #   vitnemålet») konklusjonen ved importen fra KREG, på vitnemålet med senest utstedelsesdato,
    #   og OPT-BEH-BEH-022 sier at GSK og poeng kan bygge på ulike vitnemål. Kravene må endres, og
    #   @depends-on- settes når regelen er skrevet.
    # - Hvilket valg avgjør konklusjonen når saksbehandleren har valgt ulike vitnemål for ulike
    #   poengvarianter?
    # - Erstattes en konklusjon som allerede er satt ved importen, når saksbehandleren velger et
    #   annet vitnemål?

    Scenario: GSK-konklusjonen fylles ut fra vitnemålet saksbehandleren har valgt
      Gitt at saken har behandlingsstatusen "Under behandling"
      Når saksbehandleren legger "Vitnemål 2024" til grunn
      Og saksbehandleren velger å bruke poengene
      Så bygger søknadens GSK-konklusjon på "Vitnemål 2024"

  @depends-on-OPT-BEH-BEH-012
  # OPT-BEH-BEH-012: «Søkeren plasseres i en kvote med kvotespørsmål når alle kvotespørsmålene er besvart ja», «Saksbehandleren tar stilling til kvotespørsmål, ikke til kvotetyper»
  Regel: Saksbehandleren svarer på kvotespørsmålene

    Scenario: Søkeren er plassert i kvoten når saksbehandleren har svart ja på kvotespørsmålet
      Gitt at saken har behandlingsstatusen "Under behandling"
      Og at grunnlaget er koblet til en kvote med et kvotespørsmål uten algoritme
      Når saksbehandleren besvarer kvotespørsmålet med ja
      Så plasseres søkeren i kvoten

  @openquestion
  Regel: Saksbehandleren legger inn tilleggspoeng
    # ÅPNE SPØRSMÅL:
    # - Kravet mangler. OPT-BEH-BEH-028 (automatiske_tilleggspoeng.feature) har bare at
    #   saksbehandleren kan overstyre tilleggspoeng automatikken har satt («Saksbehandleren kan
    #   overstyre poeng automatikken har satt»). Hvilket krav skal eie at saksbehandleren legger
    #   inn tilleggspoeng som ikke regnes ut automatisk, og hvilke tilleggspoeng gjelder det?

    Scenario: Søknaden har tilleggspoengene saksbehandleren har lagt inn
      Gitt at saken har behandlingsstatusen "Under behandling"
      Når saksbehandleren legger inn tilleggspoeng på søknaden
      Så har søknaden tilleggspoengene saksbehandleren la inn

  @depends-on-OPT-BEH-BEH-029 @depends-on-OPT-BEH-BEH-025
  # OPT-BEH-BEH-029: «Saken kan bare bli Behandlet når den har minst én mangel eller ett grunnlag»
  # OPT-BEH-BEH-025: «Saksbehandleren setter saken til ferdig behandlet når den automatiske behandlingen ikke har fullført»
  Regel: Saksbehandleren setter saken til ferdig behandlet

    Scenario: Saken er ferdig behandlet på vitnemålet saksbehandleren har valgt
      Gitt at saken har behandlingsstatusen "Under behandling"
      Og at saken har et grunnlag med poeng fra "Vitnemål 2025"
      Når saksbehandleren setter saken til "Behandlet"
      Så har saken behandlingsstatusen "Behandlet"
