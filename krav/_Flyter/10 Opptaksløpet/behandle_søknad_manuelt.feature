# language: no
@FLY-OPT-MAN-001 @must @draft @e2e @depends-on-FLY-OPT-SØK-001
Egenskap: Behandle søknad manuelt
  Fra søkeren uten digitalt vitnemål har sendt inn søknaden, til saksbehandleren har satt saken
  til ferdig behandlet. Søknaden fordeles til forvalteren, tilbyderen og behandleren som i
  «Fra søknad til lærestedet» (FLY-OPT-SØK-001). Saken behandles ikke helautomatisk, fordi
  søkeren ikke har et digitalt vitnemål fra KREG. Saksbehandleren finner saken i saksoversikten,
  leser dokumentene søkeren har lastet opp, og vurderer om søkeren er kvalifisert. Er søkeren
  kvalifisert til minst ett søknadsalternativ, registrerer saksbehandleren poengene og tar stilling
  til kvotespørsmålene. Er søkeren ikke kvalifisert, eller mangler det dokumentasjon for poeng
  eller kvote, registrerer saksbehandleren en mangel. Søkeren får en oppgave om mangelen i Min
  kompetanse, og blir varslet på SMS eller e-post. Til slutt setter saksbehandleren saken til ferdig behandlet.
  # Avklart 2026-11-13: flyten gjelder både norske og utenlandske vitnemål.
  # Ikke med (2026-11-13): søkeren som oppgir at vitnemålet kommer i vår (DUA-mangelen), er tatt ut
  # av flyten. Søkeren varsles når dokumentasjonsfristen nærmer seg (OPT-BEH-BEH-036, OPT-SØK-MEL-002).

  Bakgrunn:
    Gitt at søkeren ikke har et digitalt vitnemål fra KREG
    Og at søkeren har lastet opp et vitnemål på søknaden

  @depends-on-FLY-OPT-SØK-001
  # FLY-OPT-SØK-001: «Søknadsalternativene fordeles til behandleren når søknaden sendes inn»
  Regel: Søknaden fordeles til behandleren når søkeren sender den inn

    Scenario: Søknaden uten digitalt vitnemål blir en sak hos behandleren
      Når søkeren sender inn søknaden
      Så har søknaden en sak hos behandleren
      Og saken har behandlingsstatusen "Ikke behandlet"

  @depends-on-OPT-BEH-BEH-025
  # OPT-BEH-BEH-025: «Bare saker der søkeren har ett vitnemål, og vitnemålet gir GSK, behandles helautomatisk»
  Regel: Saken behandles ikke automatisk når søkeren ikke har et digitalt vitnemål

    Scenario: Saken uten digitalt vitnemål er ikke behandlet etter den automatiske behandlingen
      Gitt at saken har behandlingsstatusen "Ikke behandlet"
      Når søknaden behandles automatisk
      Så behandles ikke saken helautomatisk
      Og saken har fortsatt behandlingsstatusen "Ikke behandlet"

  @openquestion
  Regel: Saksbehandleren finner saken i saksoversikten
    # ÅPNE SPØRSMÅL:
    # - Kravet er listevisning_og_søk_i_saker.feature, men Feature-ID-en OPT-BEH-BEH-046 er også
    #   brukt i behandle_yrkesfaglig_vitnemål_med_påbygging.feature. @depends-on-OPT-BEH-BEH-046
    #   settes når ID-en er ryddet.
    # Avklart 2026-11-13: saksbehandleren finner de ubehandlede sakene med filteret for
    # behandlingsstatus.

    Scenario: Saksbehandleren finner saken som ikke er behandlet
      Gitt at saken har behandlingsstatusen "Ikke behandlet"
      Når saksbehandleren hos behandleren filtrerer saksoversikten på behandlingsstatusen "Ikke behandlet"
      Så finner saksbehandleren saken

  @depends-on-OPT-BEH-BEH-043 @openquestion
  Regel: Saksbehandleren leser dokumentene søkeren har lastet opp
    # ÅPNE SPØRSMÅL:
    # - Kravet for at dokumentet er lest når saksbehandleren har åpnet det, mangler (det samme
    #   spørsmålet står i FLY-OPT-DOK-001).

    Scenario: Dokumentet er lest når saksbehandleren har åpnet det
      Gitt at vitnemålet søkeren har lastet opp, ikke er lest
      Når saksbehandleren hos behandleren åpner vitnemålet
      Så er vitnemålet lest

  @openquestion
  Regel: Saksbehandleren vurderer om søkeren er kvalifisert
    # ÅPNE SPØRSMÅL:
    # - Kravet mangler for at saksbehandleren vurderer kvalifikasjonskravene manuelt. GSK står i
    #   sette_gsk_konklusjon_manuelt.feature, men Feature-ID-en OPT-BEH-BEH-042 er også brukt i
    #   gjenbruke_tilleggspoeng.feature. Spesielle opptakskrav står bare som at automatikken ikke
    #   endrer saksbehandlerens vurdering (OPT-BEH-BEH-020).

    Scenario: Søkeren er kvalifisert når saksbehandleren har vurdert at kravene er oppfylt
      Gitt at saken har behandlingsstatusen "Ikke behandlet"
      Når saksbehandleren hos behandleren vurderer at søkeren oppfyller kravene til et søknadsalternativ
      Så er søkeren kvalifisert til søknadsalternativet
      Og saken har behandlingsstatusen "Under behandling"

  @depends-on-OPT-BEH-BEH-037 @openquestion
  # OPT-BEH-BEH-037: «Saksbehandleren legger inn fagene i en kalkulator», «Kalkulatoren legges til grunn per poengvariant»
  Regel: Saksbehandleren registrerer poengene når søkeren er kvalifisert
    # ÅPNE SPØRSMÅL:
    # - Innspillet sier at poengene registreres i vitnemålsbehandleren eller i poeng-fanen. Kravet
    #   for å registrere poengene i poeng-fanen, og for utenlandske vitnemål, mangler. Hvilket krav
    #   skal eie det?

    Scenario: Søknaden har poengene fra vitnemålet saksbehandleren har lagt inn
      Gitt at søkeren er kvalifisert til minst ett søknadsalternativ
      Når saksbehandleren hos behandleren legger inn fagene fra vitnemålet i kalkulatoren
      Og saksbehandleren velger å bruke poengene
      Så har søknaden poengene fra vitnemålet saksbehandleren la inn

  @depends-on-OPT-BEH-BEH-012
  # OPT-BEH-BEH-012: «Søkeren plasseres i en kvote med kvotespørsmål når alle kvotespørsmålene er besvart ja», «Saksbehandleren tar stilling til kvotespørsmål, ikke til kvotetyper»
  Regel: Saksbehandleren svarer på kvotespørsmålene

    Scenario: Søkeren er plassert i kvoten når saksbehandleren har svart ja på kvotespørsmålet
      Gitt at søkeren er kvalifisert til minst ett søknadsalternativ
      Og at grunnlaget er koblet til en kvote med et kvotespørsmål uten algoritme
      Når saksbehandleren besvarer kvotespørsmålet med ja
      Så plasseres søkeren i kvoten

  @depends-on-OPT-BEH-BEH-008 @depends-on-OPT-SØK-SØK-010 @depends-on-OPT-SØK-MEL-003 @openquestion
  # OPT-BEH-BEH-008: «Saksbehandlende organisasjon registrerer mangler i saken sin», «Søkeren ser bare manglene som er publisert, og får melding om dem», «Søkeren ser manglene på dokumentasjonssiden»
  # OPT-SØK-SØK-010: «Mangelbrev viser hva søkeren må gjøre»
  # OPT-SØK-MEL-003: «Søkeren ser en oppgave når søknaden har mangler»
  Regel: Søkeren får en oppgave om mangelen saksbehandleren har registrert, og blir varslet om den
    # Avklart 2026-11-13: en mangel vises for søkeren som en oppgave i Min kompetanse. Oppgaven
    # gir et varsel på SMS og/eller e-post, ut fra kommunikasjonspreferansene søkeren har satt.
    # Varselet går når saksbehandleren har publisert mangelen i FS Admin.
    # ÅPNE SPØRSMÅL:
    # - Kravet for varselet på SMS og e-post ut fra søkerens kommunikasjonspreferanser skal skrives.
    #   @depends-on- settes når kravet finnes.

    Scenariomal: Søkeren får en oppgave om mangelen i kategorien <kategori>
      Gitt at <situasjon>
      Når saksbehandleren hos behandleren registrerer en mangel i kategorien "<kategori>"
      Og saksbehandleren publiserer mangelen
      Så ser søkeren en oppgave om mangelen i Min kompetanse
      Og søkeren mottar en melding om mangler
      Og søkeren blir varslet om oppgaven på SMS eller e-post når mangelen er publisert, ut fra kommunikasjonspreferansene sine

      Eksempler:
        | situasjon                                                    | kategori       |
        | søkeren ikke er kvalifisert til noen av søknadsalternativene | Spesielle krav |
        | vitnemålet ikke dokumenterer grunnlaget for poengene         | Poeng          |
        | søkeren ikke har dokumentert kvotespørsmålet                 | Kvote          |

  @depends-on-OPT-BEH-BEH-029 @depends-on-OPT-BEH-BEH-025
  # OPT-BEH-BEH-029: «Saksbehandleren kan sette behandlingsstatusen», «Saken kan bare bli Behandlet når den har minst én mangel eller ett grunnlag»
  # OPT-BEH-BEH-025: «Saksbehandleren setter saken til ferdig behandlet når den automatiske behandlingen ikke har fullført»
  Regel: Saksbehandleren setter saken til ferdig behandlet

    Scenariomal: Saken er ferdig behandlet når den har <innhold>
      Gitt at saken har behandlingsstatusen "Under behandling"
      Og at saken har <innhold>
      Når saksbehandleren setter saken til "Behandlet"
      Så har saken behandlingsstatusen "Behandlet"

      Eksempler:
        | innhold                                         |
        | et grunnlag med poengene saksbehandleren la inn |
        | en publisert mangel                             |
