# language: no
@OPT-BEH-BEH-026 @must @planned @scope-beregne-automatisk-pa-nytt
Egenskap: Beregne automatisk på nytt
  Som opptaksforvalter
  ønsker jeg å kjøre den automatiske behandlingen på nytt for søknadsalternativene en feil har rammet
  slik at søkerne får riktig grunnlag, kvalifisering, poeng og kvote når feilen er rettet.

  En feil i regelverket eller i kontrollmotoren for vitnemål kan gi feil resultat i den
  automatiske behandlingen for mange søkere på en gang. Når feilen er rettet, velger
  opptaksforvalteren søknadsalternativene feilen gjaldt, og hele den automatiske behandlingen
  kjøres på nytt for dem. Det saksbehandleren har låst, endres ikke, men resten av
  søknadsalternativet beregnes på nytt. Saker som er ferdig behandlet, forblir ferdig behandlet.
  Beregningen gjelder fra neste plasstildeling.

  # I FS-klienten gjøres dette med rutinen FS158.001. I fs-plattform kjører den automatiske
  # behandlingen én sak om gangen (AutomatiskSaksbehandlingService), og ingenting kjører den for
  # mange saker.

  # Avklart 30.10.2026: en feil i kontrollmotoren rettes av utviklerne, og de sier fra (for
  # eksempel i endringsloggen) hvilke kravelementer rettingen gjelder. Løsningen viser det ikke.

  # Avklart 30.10.2026: søkeren får ingen egen melding når kvalifiseringen, poengene eller kvoten
  # endres. Søkeren ser det som er endret, i Min kompetanse.

  # Avklart 30.10.2026: søkeren ser de automatiske mangeltekstene når saken er ferdig behandlet
  # (OPT-BEH-BEH-036). Gir beregningen på nytt en ny mangeltekst i en sak som er ferdig
  # behandlet, ser søkeren den med en gang. Ingen trenger å publisere den.

  # Avklart 30.10.2026: beregningen kjører som en jobb i bakgrunnen, etter det samme mønsteret
  # som de andre jobbene i opptak (OPT-BEH-BEH-033, kjøre_jobbene_i_opptak.feature).
  # Når kravet er merget, får regelen «Beregningen kjører i bakgrunnen» @depends-on- til det.

  Bakgrunn:
    Gitt at opptaksforvalteren ved HK-dir er innlogget
    Og at "Informatikk, UiO" og "Historie, UiT" er med i opptaket "Samordna opptak 2027"

  @openquestion
  Regel: Hele den automatiske behandlingen kjøres på nytt for søknadsalternativene feilen gjaldt
    # Avklart 03.11.2026: hele den automatiske behandlingen kjøres på nytt, ikke bare stegene det
    # som ble rettet, gjelder. Behandlingen gir samme resultat når dataene er de samme, og det
    # saksbehandleren har låst, endres ikke uansett. Opptaksforvalteren velger hvilke
    # søknadsalternativer feilen gjaldt, ikke hva som ble rettet.
    # ÅPNE SPØRSMÅL:
    # - Den automatiske behandlingen bruker resultatene fra KREG som er importert når den kjører.
    #   Er det riktig at beregningen på nytt også tar med resultater som er kommet etter at saken
    #   ble behandlet, og at saken da ikke lenger har nye resultater (OPT-BEH-BEH-035)?

    Scenariomal: Opptaksforvalteren beregner på nytt etter en feil i <rettet>
      Gitt at opptaksforvalteren har rettet en feil i <rettet>
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med <utvalg>
      Så er den automatiske behandlingen kjørt på nytt for søknadsalternativene med <utvalg>

      Eksempler:
        | rettet                             | utvalg                              |
        | kontrollmotoren for vitnemål       | kravelementet "Matematikk R1"       |
        | kompetanseregelverket              | kompetanseregelverket som er rettet |
        | rangeringsregelverket              | rangeringsregelverket som er rettet |
        | grunnlagene                        | grunnlaget som er rettet            |
        | kvotetypene eller kvotespørsmålene | kvotetypen "Ordinær kvote"          |

    Scenario: Søknadsalternativer feilen ikke gjaldt, beregnes ikke på nytt
      Gitt at "Informatikk, UiO" har kravelementet "Matematikk R1"
      Og at "Historie, UiT" ikke har kravelementet "Matematikk R1"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kravelementet "Matematikk R1"
      Så er den automatiske behandlingen kjørt på nytt for "Informatikk, UiO"
      Men den automatiske behandlingen er ikke kjørt på nytt for "Historie, UiT"

  @depends-on-OPT-BEH-BEH-018 @depends-on-OPT-BEH-BEH-019 @depends-on-OPT-BEH-BEH-020
  Regel: Det saksbehandleren har satt, endres ikke
    # Låsen gjelder ett kravelement eller ett poeng, ikke hele saken (OPT-BEH-BEH-018 og
    # OPT-BEH-BEH-020). Det som ikke er låst, beregnes på nytt, og bygger på det som er låst.

    Scenario: Kravelementet saksbehandleren har vurdert, beregnes ikke på nytt
      Gitt at saksbehandleren ved Universitetet i Oslo har vurdert "Matematikk R1" for "Kari Nordmann" på "Informatikk, UiO"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kravelementet "Matematikk R1"
      Så er vurderingen saksbehandleren ved Universitetet i Oslo har gjort av "Matematikk R1" for "Kari Nordmann", uendret

    Scenario: Resten av søknadsalternativet beregnes på nytt når saksbehandleren har låst et kravelement
      Gitt at saksbehandleren ved Universitetet i Oslo har vurdert "Matematikk R1" for "Kari Nordmann" på "Informatikk, UiO"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket som er rettet
      Så har "Informatikk, UiO" poengsum for "Kari Nordmann" etter det rettede rangeringsregelverket
      Og vurderingen saksbehandleren ved Universitetet i Oslo har gjort av "Matematikk R1" for "Kari Nordmann", er uendret

    Scenario: Opptaksforvalteren ser hvor mange låste kravelementer og poeng som ikke ble beregnet på nytt
      Gitt at saksbehandleren ved Universitetet i Oslo har vurdert "Matematikk R1" for "Kari Nordmann" på "Informatikk, UiO"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kravelementet "Matematikk R1"
      Så ser opptaksforvalteren at 1 kravelement ikke ble beregnet på nytt fordi saksbehandleren har låst det

  @draft @openquestion
  Regel: Saker med låste kravelementer eller poeng i utvalget merkes for saksbehandleren
    # Det saksbehandleren har låst, kan bygge på det som var feil. Automatikken endrer det ikke,
    # så saksbehandleren må se på det.
    # ÅPNE SPØRSMÅL:
    # - Skal saken merkes når et låst kravelement eller poeng er i utvalget, eller bare når
    #   beregningen på nytt ville gitt et annet resultat enn det som er låst?
    # - Når er saken ikke lenger merket: når saksbehandleren har sett på den, eller når saken er
    #   behandlet på nytt?
    # - Skal merket være et filter i sakene, som nye resultater (OPT-BEH-BEH-035), eller et varsel?

    Scenario: Saken er merket når et låst kravelement er i utvalget
      Gitt at saksbehandleren ved Universitetet i Oslo har vurdert "Matematikk R1" for "Kari Nordmann" på "Informatikk, UiO"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kravelementet "Matematikk R1"
      Så er saken til "Kari Nordmann" hos "Universitetet i Oslo" merket for gjennomgang etter beregningen på nytt

    Scenario: Saksbehandleren finner sakene som er merket for gjennomgang
      Gitt at saken til "Kari Nordmann" hos "Universitetet i Oslo" er merket for gjennomgang etter beregningen på nytt
      Når saksbehandleren ved Universitetet i Oslo filtrerer sakene på merket for gjennomgang
      Så ser saksbehandleren ved Universitetet i Oslo saken til "Kari Nordmann"

  @depends-on-OPT-BEH-BEH-025
  Regel: Saker som er ferdig behandlet, forblir ferdig behandlet

    Scenario: Saken er fortsatt ferdig behandlet etter at poengene er beregnet på nytt
      Gitt at saken til "Kari Nordmann" hos "Universitetet i Oslo" er ferdig behandlet
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket som er rettet
      Så har "Informatikk, UiO" poengsum for "Kari Nordmann" etter det rettede rangeringsregelverket
      Og saken til "Kari Nordmann" hos "Universitetet i Oslo" er fortsatt ferdig behandlet

    @depends-on-OPT-BEH-BEH-036
    # OPT-BEH-BEH-036: «Saken får automatiske mangeltekster når søkeren ikke er kvalifisert»
    Scenario: Søkeren ser den nye mangelteksten i en sak som er ferdig behandlet
      Gitt at saken til "Kari Nordmann" hos "Universitetet i Oslo" er ferdig behandlet
      Og at "Kari Nordmann" er kvalifisert for "Informatikk, UiO"
      Og at en feil i kontrollmotoren er rettet, så vitnemålet til "Kari Nordmann" ikke lenger oppfyller "Matematikk R2"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kravelementet "Matematikk R2"
      Så er "Kari Nordmann" ikke lenger kvalifisert for "Informatikk, UiO"
      Og "Kari Nordmann" ser den automatiske mangelteksten for "Matematikk R2" i Min kompetanse
      Og saken til "Kari Nordmann" hos "Universitetet i Oslo" er fortsatt ferdig behandlet

  @depends-on-OPT-BEH-BEH-025
  Regel: En sak som ikke ble ferdig behandlet på grunn av feilen, blir ferdig behandlet når alt kan avgjøres
    # Avklart 30.10.2026. Saken kunne vært behandlet helautomatisk om regelverket hadde vært
    # riktig. Har saksbehandleren gjort noe i saken, blir den stående under behandling.
    # Avklart 2026-11-02: saken står som ikke behandlet når den automatiske behandlingen ikke
    # fullførte (OPT-BEH-BEH-025).

    Scenario: Saken blir ferdig behandlet når feilen er rettet
      Gitt at saken til "Kari Nordmann" hos "Universitetet i Oslo" har behandlingsstatusen "Ikke behandlet" fordi poengene for "Informatikk, UiO" ikke kunne avgjøres på grunn av en feil i rangeringsregelverket
      Og at saksbehandleren ikke har gjort noe i saken
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket som er rettet
      Så er saken til "Kari Nordmann" hos "Universitetet i Oslo" ferdig behandlet

    Scenario: Saken blir stående under behandling når saksbehandleren har gjort noe i den
      Gitt at saken til "Kari Nordmann" hos "Universitetet i Oslo" er under behandling fordi poengene for "Informatikk, UiO" ikke kunne avgjøres på grunn av en feil i rangeringsregelverket
      Og at saksbehandleren ved Universitetet i Oslo har vurdert et kravelement i saken
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket som er rettet
      Så er saken til "Kari Nordmann" hos "Universitetet i Oslo" fortsatt under behandling

  Regel: Beregningen kjører i bakgrunnen

    Scenario: Opptaksforvalteren ser når beregningen er ferdig
      Gitt at opptaksforvalteren har startet en beregning på nytt for søknadsalternativene med kravelementet "Matematikk R1"
      Når beregningen er ferdig
      Så ser opptaksforvalteren at beregningen er ferdig
      Og opptaksforvalteren ser hvor mange søknadsalternativer som ble beregnet på nytt
      Og opptaksforvalteren ser hvor mange låste kravelementer og poeng som ikke ble beregnet på nytt

  @depends-on-OPT-PLA-TIL-001
  Regel: Beregningen gjelder fra neste plasstildeling

    Scenario: En plasstildeling som er kjørt, endres ikke
      Gitt at en plasstildeling i plasstildelingsrunden "Hovedrunde" er kjørt
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket som er rettet
      Så er resultatet av plasstildelingen som er kjørt, uendret

    Scenario: Neste plasstildeling bruker det som er beregnet på nytt
      Gitt at opptaksforvalteren har beregnet på nytt for søknadsalternativene med rangeringsregelverket som er rettet
      Når opptaksforvalteren starter en plasstildeling i plasstildelingsrunden "Hovedrunde"
      Så bruker plasstildelingen poengsummene som er beregnet på nytt
