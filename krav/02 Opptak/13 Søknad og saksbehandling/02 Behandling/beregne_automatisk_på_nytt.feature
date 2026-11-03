# language: no
@OPT-BEH-BEH-026 @must @planned @scope-beregne-automatisk-pa-nytt
Egenskap: Beregne automatisk på nytt
  Som opptaksforvalter
  ønsker jeg å kjøre den automatiske behandlingen på nytt for søknadsalternativene en feil har rammet
  slik at søkerne får riktig grunnlag, kvalifisering, poeng og kvote når feilen er rettet.

  En feil i regelverket eller i kontrollmotoren for vitnemål kan gi feil resultat i den
  automatiske behandlingen for mange søkere på en gang. Når feilen er rettet, velger
  opptaksforvalteren søknadsalternativene feilen gjaldt, og sakene beregnes på nytt. I saker
  saksbehandleren ikke har endret, kjøres hele den automatiske behandlingen på nytt. I saker
  saksbehandleren har endret, regnes bare kvalifiseringen, poengsummen og kvoten ut på nytt fra
  det som står i saken, og sakene merkes så saksbehandleren kan se på dem. Saker som er ferdig
  behandlet, forblir ferdig behandlet. Beregningen gjelder fra neste plasstildeling.

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

  Regel: Opptaksforvalteren velger søknadsalternativene feilen gjaldt
    # Avklart 03.11.2026: opptaksforvalteren velger hvilke søknadsalternativer feilen gjaldt, ikke
    # hva som ble rettet. Behandlingen gir samme resultat når dataene er de samme.
    # Avklart 03.11.2026: utvalget gjelder regelverket til søknadsalternativet. «Søknadsalternativene
    # med grunnlaget» er søknadsalternativene der grunnlaget er i regelverket, ikke sakene der
    # grunnlaget er valgt. Ellers kommer ikke saker med der feilen gjorde at grunnlaget ikke ble valgt.

    Scenariomal: Opptaksforvalteren beregner på nytt for søknadsalternativene med <utvalg>
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med <utvalg>
      Så er sakene beregnet på nytt for søknadsalternativene med <utvalg>

      Eksempler:
        | utvalg                                    |
        | kravelementet "Matematikk R1"             |
        | kompetanseregelverket "Informatikk"       |
        | rangeringsregelverket "Ordinær rangering" |
        | poengtypen "Karakterpoeng"                |
        | grunnlaget "Vitnemål fra videregående"    |
        | kvotetypen "Ordinær kvote"                |
        | kvotespørsmålet "Førstegangsvitnemål"     |

    Scenario: Søknadsalternativer feilen ikke gjaldt, beregnes ikke på nytt
      Gitt at "Informatikk, UiO" har kravelementet "Matematikk R1"
      Og at "Historie, UiT" ikke har kravelementet "Matematikk R1"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kravelementet "Matematikk R1"
      Så er sakene beregnet på nytt for "Informatikk, UiO"
      Men sakene er ikke beregnet på nytt for "Historie, UiT"

  @openquestion
  Regel: Hele den automatiske behandlingen kjøres på nytt i saker saksbehandleren ikke har endret
    # Avklart 03.11.2026: saksbehandleren har endret saken når saksbehandleren har vurdert et
    # kravelement, satt poeng eller valgt grunnlaget. At saken er tildelt en saksbehandler, eller
    # at saksbehandleren har skrevet en mangeltekst, teller ikke.
    # Avklart 03.11.2026: den automatiske behandlingen bruker resultatene fra KREG som er importert
    # når den kjører, også resultater som er kommet etter at saken ble behandlet. Saken har da ikke
    # lenger nye resultater (OPT-BEH-BEH-035, «Den automatiske behandlingen behandler saken på nytt»).
    # ÅPNE SPØRSMÅL:
    # - Den automatiske behandlingen sjekker ut mangelen for generell studiekompetanse som fullføres
    #   i vår bare når søkeren har vitnemål fra videregående da behandlingen startet
    #   (OPT-BEH-BEH-025). Gjelder det samme ved beregning på nytt?

    Scenario: Grunnlag, kvalifisering, poeng og kvote beregnes på nytt i en sak saksbehandleren ikke har endret
      Gitt at saksbehandleren ikke har endret saken til "Kari Nordmann" hos "Universitetet i Oslo"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med grunnlaget "Vitnemål fra videregående"
      Så er grunnlaget, kvalifiseringen, poengene og kvoten for "Kari Nordmann" på "Informatikk, UiO" beregnet på nytt

  @depends-on-OPT-BEH-BEH-018 @depends-on-OPT-BEH-BEH-019 @depends-on-OPT-BEH-BEH-020
  Regel: I saker saksbehandleren har endret, regnes bare kvalifiseringen, poengsummen og kvoten ut på nytt
    # Avklart 03.11.2026: den automatiske behandlingen kjøres ikke. Kvalifiseringen, poengsummen og
    # kvoten regnes ut på nytt fra grunnlaget og kravelementene som står i saken. Grunnlaget byttes
    # ikke, og kravelementene vurderes ikke på nytt, heller ikke de saksbehandleren ikke har vurdert.
    # Det som bygger på feilen, blir stående, og saken merkes for saksbehandleren.

    Scenario: Grunnlaget saksbehandleren har valgt, byttes ikke
      Gitt at saksbehandleren ved Universitetet i Oslo har valgt grunnlaget for "Kari Nordmann" på "Informatikk, UiO"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med grunnlaget "Vitnemål fra videregående"
      Så er grunnlaget saksbehandleren ved Universitetet i Oslo har valgt for "Kari Nordmann", uendret

    Scenario: Kravelementet saksbehandleren har vurdert, beregnes ikke på nytt
      Gitt at saksbehandleren ved Universitetet i Oslo har vurdert "Matematikk R1" for "Kari Nordmann" på "Informatikk, UiO"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kravelementet "Matematikk R1"
      Så er vurderingen saksbehandleren ved Universitetet i Oslo har gjort av "Matematikk R1" for "Kari Nordmann", uendret

    Scenario: Poengsummen regnes ut på nytt i en sak saksbehandleren har endret
      Gitt at saksbehandleren ved Universitetet i Oslo har vurdert "Matematikk R1" for "Kari Nordmann" på "Informatikk, UiO"
      Og at opptaksforvalteren har rettet en feil i rangeringsregelverket "Ordinær rangering"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket "Ordinær rangering"
      Så har "Informatikk, UiO" poengsum for "Kari Nordmann" etter det rettede rangeringsregelverket
      Og vurderingen saksbehandleren ved Universitetet i Oslo har gjort av "Matematikk R1" for "Kari Nordmann", er uendret

  @draft @openquestion
  Regel: Saker saksbehandleren må se på etter beregningen, merkes
    # Avklart 03.11.2026: to slags saker merkes. Sakene saksbehandleren har endret, merkes, fordi
    # det saksbehandleren har satt, kan bygge på det som var feil. Saker saksbehandleren ikke har
    # endret, merkes når de ikke kan avgjøres automatisk etter beregningen. Saksbehandleren finner
    # begge med det samme filteret.
    # ÅPNE SPØRSMÅL:
    # - Når er saken ikke lenger merket: når saksbehandleren har sett på den, eller når saken er
    #   behandlet på nytt?
    # - Skal merket være et filter i sakene, som nye resultater (OPT-BEH-BEH-035), eller et varsel?

    Scenario: Saken saksbehandleren har endret, er merket for gjennomgang
      Gitt at saksbehandleren ved Universitetet i Oslo har vurdert "Matematikk R1" for "Kari Nordmann" på "Informatikk, UiO"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kravelementet "Matematikk R1"
      Så er saken til "Kari Nordmann" hos "Universitetet i Oslo" merket for gjennomgang etter beregningen på nytt

    Scenario: Saken som ikke kan avgjøres automatisk etter beregningen, er merket for gjennomgang
      Gitt at saken til "Kari Nordmann" hos "Universitetet i Oslo" er ferdig behandlet
      Og at saksbehandleren ikke har endret saken til "Kari Nordmann" hos "Universitetet i Oslo"
      Og at en feil i kontrollmotoren er rettet, så "Matematikk R1" for "Kari Nordmann" på "Informatikk, UiO" må vurderes manuelt
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kravelementet "Matematikk R1"
      Så er saken til "Kari Nordmann" hos "Universitetet i Oslo" merket for gjennomgang etter beregningen på nytt
      Og saken til "Kari Nordmann" hos "Universitetet i Oslo" er fortsatt ferdig behandlet

    Scenario: Saksbehandleren finner sakene som er merket for gjennomgang
      Gitt at saken til "Kari Nordmann" hos "Universitetet i Oslo" er merket for gjennomgang etter beregningen på nytt
      Når saksbehandleren ved Universitetet i Oslo filtrerer sakene på merket for gjennomgang
      Så ser saksbehandleren ved Universitetet i Oslo saken til "Kari Nordmann"

  @depends-on-OPT-BEH-BEH-025
  Regel: Saker som er ferdig behandlet, forblir ferdig behandlet

    Scenario: Saken er fortsatt ferdig behandlet etter at poengene er beregnet på nytt
      Gitt at saken til "Kari Nordmann" hos "Universitetet i Oslo" er ferdig behandlet
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket "Ordinær rangering"
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

    @depends-on-OPT-BEH-BEH-036
    # OPT-BEH-BEH-036: «Saken får automatiske mangeltekster når søkeren ikke er kvalifisert»
    Scenario: Den automatiske mangelteksten slettes når søkeren blir kvalifisert etter beregningen
      Gitt at saken til "Kari Nordmann" hos "Universitetet i Oslo" er ferdig behandlet
      Og at saken har en automatisk mangeltekst for "Matematikk R2" fordi "Kari Nordmann" ikke er kvalifisert for "Informatikk, UiO"
      Og at en feil i kontrollmotoren er rettet, så vitnemålet til "Kari Nordmann" oppfyller "Matematikk R2"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kravelementet "Matematikk R2"
      Så er "Kari Nordmann" kvalifisert for "Informatikk, UiO"
      Og "Kari Nordmann" ser ikke lenger den automatiske mangelteksten for "Matematikk R2" i Min kompetanse
      Og saken til "Kari Nordmann" hos "Universitetet i Oslo" er fortsatt ferdig behandlet

  @depends-on-OPT-BEH-BEH-025
  Regel: En sak som ikke ble ferdig behandlet på grunn av feilen, blir ferdig behandlet når alt kan avgjøres
    # Avklart 30.10.2026. Saken kunne vært behandlet helautomatisk om regelverket hadde vært
    # riktig. Har saksbehandleren endret saken, blir den stående under behandling.
    # Avklart 2026-11-02: saken står som ikke behandlet når den automatiske behandlingen ikke
    # fullførte (OPT-BEH-BEH-025).

    Scenario: Saken blir ferdig behandlet når feilen er rettet
      Gitt at saken til "Kari Nordmann" hos "Universitetet i Oslo" har behandlingsstatusen "Ikke behandlet" fordi poengene for "Informatikk, UiO" ikke kunne avgjøres på grunn av en feil i rangeringsregelverket
      Og at saksbehandleren ikke har endret saken til "Kari Nordmann" hos "Universitetet i Oslo"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket "Ordinær rangering"
      Så er saken til "Kari Nordmann" hos "Universitetet i Oslo" ferdig behandlet

    Scenario: Saken blir stående under behandling når saksbehandleren har endret den
      Gitt at saken til "Kari Nordmann" hos "Universitetet i Oslo" er under behandling fordi poengene for "Informatikk, UiO" ikke kunne avgjøres på grunn av en feil i rangeringsregelverket
      Og at saksbehandleren ved Universitetet i Oslo har vurdert et kravelement i saken
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket "Ordinær rangering"
      Så er saken til "Kari Nordmann" hos "Universitetet i Oslo" fortsatt under behandling

  @openquestion
  Regel: Beregningen kjører i bakgrunnen
    # ÅPNE SPØRSMÅL:
    # - Hva skjer når opptaksforvalteren starter en ny beregning før den forrige er ferdig, eller
    #   starter en beregning mens en plasstildeling kjører?
    # - Kan opptaksforvalteren beregne på nytt etter siste plasstildelingsrunde, eller etter at
    #   resultatet er publisert?
    # - Opptaksforvalteren ved HK-dir starter beregningen, men sakene er hos andre organisasjoner.
    #   Står opptaksforvalteren eller den automatiske behandlingen som den som endret, i
    #   endringsloggen?

    Scenario: Opptaksforvalteren ser når beregningen er ferdig
      Gitt at opptaksforvalteren har startet en beregning på nytt for søknadsalternativene med kravelementet "Matematikk R1"
      Når beregningen er ferdig
      Så ser opptaksforvalteren at beregningen er ferdig
      Og opptaksforvalteren ser hvor mange saker som ble behandlet automatisk på nytt
      Og opptaksforvalteren ser hvor mange saker der bare kvalifiseringen, poengsummen og kvoten ble regnet ut på nytt
      Og opptaksforvalteren ser hvor mange saker som er merket for gjennomgang

  @depends-on-OPT-PLA-TIL-001
  Regel: Beregningen gjelder fra neste plasstildeling

    Scenario: En plasstildeling som er kjørt, endres ikke
      Gitt at en plasstildeling i plasstildelingsrunden "Hovedrunde" er kjørt
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket "Ordinær rangering"
      Så er resultatet av plasstildelingen som er kjørt, uendret

    Scenario: Neste plasstildeling bruker det som er beregnet på nytt
      Gitt at opptaksforvalteren har beregnet på nytt for søknadsalternativene med rangeringsregelverket "Ordinær rangering"
      Når opptaksforvalteren starter en plasstildeling i plasstildelingsrunden "Hovedrunde"
      Så bruker plasstildelingen poengsummene som er beregnet på nytt
