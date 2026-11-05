# language: no
@OPT-BEH-BEH-026 @must @planned @scope-beregne-automatisk-pa-nytt
Egenskap: Beregne automatisk på nytt
  Som opptaksforvalter
  ønsker jeg å beregne sakene på nytt for regelverkene en feil har rammet
  slik at søkerne får riktig kvalifisering, poeng og kvote når feilen er rettet.

  En feil i regelverket eller i kontrollmotoren for vitnemål kan gi feil resultat i den
  automatiske behandlingen for mange søkere på en gang. Når feilen er rettet, velger
  opptaksforvalteren kompetanse- og rangeringsregelverkene feilen gjaldt, og sakene som er ferdig
  behandlet, beregnes på nytt. I saker den automatiske behandlingen har behandlet, beregnes
  kravelementene og poengene på nytt, bortsett fra det saksbehandleren har vurdert eller satt. I
  saker saksbehandleren har behandlet, regnes bare kvalifiseringen, poengsummen og kvoten ut på
  nytt, og sakene får taggen «Regelverk endret», så saksbehandleren kan se på dem. Sakene forblir
  ferdig behandlet. Beregningen gjelder fra neste plasstildeling.

  # I FS-klienten gjøres dette med rutinen FS158.001. I fs-plattform kjører den automatiske
  # behandlingen én sak om gangen (AutomatiskSaksbehandlingService), og ingenting kjører den for
  # mange saker.

  # Avklart 30.10.2026: en feil i kontrollmotoren rettes av utviklerne, og de sier fra (for
  # eksempel i endringsloggen) hvilke regelverk rettingen gjelder. Løsningen viser det ikke.

  # Avklart 30.10.2026: søkeren får ingen egen melding når kvalifiseringen, poengene eller kvoten
  # endres. Søkeren ser det som er endret, i Min kompetanse.

  # Avklart 30.10.2026: søkeren ser de automatiske mangeltekstene når saken er ferdig behandlet
  # (OPT-BEH-BEH-036). Gir beregningen på nytt en ny mangeltekst i en sak som er ferdig
  # behandlet, ser søkeren den med en gang. Ingen trenger å publisere den.

  # Avklart 30.10.2026: beregningen kjører som en jobb i bakgrunnen, etter det samme mønsteret
  # som de andre jobbene i opptak.

  Bakgrunn:
    Gitt at opptaksforvalteren ved HK-dir er innlogget
    Og at "Informatikk, UiO" og "Historie, UiT" er med i opptaket "Samordna opptak 2027"

  @openquestion
  Regel: Opptaksforvalteren velger regelverkene feilen gjaldt
    # Utvalget er regelverkene i regelverkssamlingen på opptaket. En sak er med når minst ett av
    # søknadsalternativene i saken har ett av regelverkene opptaksforvalteren har valgt.
    # ÅPNE SPØRSMÅL:
    # - Hører kvotetypene og kvotespørsmålene til et kompetanse- eller rangeringsregelverk? Hvis
    #   ikke, må opptaksforvalteren velge alle regelverkene når en kvotetype er endret.

    Scenariomal: Opptaksforvalteren beregner på nytt for søknadsalternativene med <utvalg>
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med <utvalg>
      Så er sakene beregnet på nytt for søknadsalternativene med <utvalg>

      Eksempler:
        | utvalg                                    |
        | kompetanseregelverket "Informatikk"       |
        | rangeringsregelverket "Ordinær rangering" |
        | alle kompetanseregelverkene               |
        | alle rangeringsregelverkene               |

    Scenario: Saker med søknadsalternativer med andre regelverk, beregnes ikke på nytt
      Gitt at "Informatikk, UiO" har rangeringsregelverket "Ordinær rangering"
      Og at "Historie, UiT" har rangeringsregelverket "Rangering etter opptaksprøve"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket "Ordinær rangering"
      Så er sakene beregnet på nytt for "Informatikk, UiO"
      Men sakene er ikke beregnet på nytt for "Historie, UiT"

    Scenario: Saker med ett av regelverkene som er valgt, beregnes på nytt
      Gitt at "Informatikk, UiO" har kompetanseregelverket "Informatikk"
      Og at "Historie, UiT" har rangeringsregelverket "Ordinær rangering"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kompetanseregelverket "Informatikk" og rangeringsregelverket "Ordinær rangering"
      Så er sakene beregnet på nytt for "Informatikk, UiO" og "Historie, UiT"

    Scenario: Opptaksforvalteren ser hvor mange saker som beregnes på nytt, før beregningen starter
      Når opptaksforvalteren velger rangeringsregelverket "Ordinær rangering"
      Så ser opptaksforvalteren hvor mange saker som blir beregnet på nytt

    Scenario: Regelverkene opptaksforvalteren kan velge, er regelverkene i opptaket
      Når opptaksforvalteren velger regelverkene feilen gjaldt
      Så kan opptaksforvalteren bare velge regelverkene i regelverkssamlingen på opptaket "Samordna opptak 2027"

  @depends-on-OPT-BEH-BEH-018 @depends-on-OPT-BEH-BEH-020 @ref-FLY-OPT-AUT-001
  Regel: I saker den automatiske behandlingen har behandlet, beregnes kravelementene og poengene på nytt
    # Saken er behandlet av den automatiske behandlingen når den automatiske behandlingen har kjørt
    # på saken, også når saksbehandleren har endret saken etterpå. Kravelementene saksbehandleren
    # har vurdert, og poengene saksbehandleren har satt, beregnes ikke på nytt.
    # Grunnlaget velges ikke på nytt.

    Scenario: Kravelementene og poengene beregnes på nytt i en sak den automatiske behandlingen har behandlet
      Gitt at den automatiske behandlingen har behandlet saken til "Kari Nordmann" hos "Universitetet i Oslo"
      Og at opptaksforvalteren har rettet en feil i kompetanseregelverket "Informatikk"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kompetanseregelverket "Informatikk"
      Så er kravelementene og poengene for "Kari Nordmann" på "Informatikk, UiO" beregnet på nytt etter det rettede kompetanseregelverket
      Og kvalifiseringen, poengsummen og kvoten for "Kari Nordmann" på "Informatikk, UiO" er regnet ut på nytt

    Scenario: Kravelementet saksbehandleren har vurdert, beregnes ikke på nytt
      Gitt at den automatiske behandlingen har behandlet saken til "Kari Nordmann" hos "Universitetet i Oslo"
      Og at saksbehandleren ved Universitetet i Oslo har vurdert "Matematikk R1" for "Kari Nordmann" på "Informatikk, UiO"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kompetanseregelverket "Informatikk"
      Så er vurderingen saksbehandleren ved Universitetet i Oslo har gjort av "Matematikk R1" for "Kari Nordmann", uendret

    Scenario: Poengene saksbehandleren har satt, beregnes ikke på nytt
      Gitt at den automatiske behandlingen har behandlet saken til "Kari Nordmann" hos "Universitetet i Oslo"
      Og at saksbehandleren ved Universitetet i Oslo har satt poengene for "Kari Nordmann" på "Informatikk, UiO"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket "Ordinær rangering"
      Så er poengene saksbehandleren ved Universitetet i Oslo har satt for "Kari Nordmann", uendret

  @depends-on-OPT-BEH-BEH-018 @depends-on-OPT-BEH-BEH-020 @ref-FLY-OPT-AUT-001
  Regel: Saker saksbehandleren har behandlet, får regnet ut kvalifiseringen, poengsummen og kvoten på nytt og blir merket
    # Saken er behandlet av saksbehandleren når den automatiske behandlingen ikke har kjørt på
    # saken. Kvalifiseringen, poengsummen og kvoten regnes ut på nytt fra det som står i saken.
    # Kravelementene og poengene beregnes ikke på nytt. Saken får taggen «Regelverk endret», fordi
    # det saksbehandleren har satt, kan bygge på det som var feil. Saksbehandleren fjerner taggen
    # når saken er sett på.

    Scenario: Poengsummen regnes ut på nytt i en sak saksbehandleren har behandlet
      Gitt at saksbehandleren ved Universitetet i Oslo har behandlet saken til "Kari Nordmann"
      Og at opptaksforvalteren har rettet en feil i rangeringsregelverket "Ordinær rangering"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket "Ordinær rangering"
      Så har "Informatikk, UiO" poengsum for "Kari Nordmann" etter det rettede rangeringsregelverket

    Scenario: Kravelementet saksbehandleren har vurdert, er uendret
      Gitt at saksbehandleren ved Universitetet i Oslo har behandlet saken til "Kari Nordmann"
      Og at saksbehandleren ved Universitetet i Oslo har vurdert "Matematikk R1" for "Kari Nordmann" på "Informatikk, UiO"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kompetanseregelverket "Informatikk"
      Så er vurderingen saksbehandleren ved Universitetet i Oslo har gjort av "Matematikk R1" for "Kari Nordmann", uendret

    Scenario: Saken saksbehandleren har behandlet, får taggen "Regelverk endret"
      Gitt at saksbehandleren ved Universitetet i Oslo har behandlet saken til "Kari Nordmann"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kompetanseregelverket "Informatikk"
      Så får saken til "Kari Nordmann" hos "Universitetet i Oslo" taggen "Regelverk endret"

    Scenario: Saken den automatiske behandlingen har behandlet, får ikke taggen "Regelverk endret"
      Gitt at den automatiske behandlingen har behandlet saken til "Kari Nordmann" hos "Universitetet i Oslo"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kompetanseregelverket "Informatikk"
      Så får saken til "Kari Nordmann" hos "Universitetet i Oslo" ikke taggen "Regelverk endret"

    Scenario: Saksbehandleren finner sakene med taggen "Regelverk endret"
      Gitt at saken til "Kari Nordmann" hos "Universitetet i Oslo" har taggen "Regelverk endret"
      Når saksbehandleren ved Universitetet i Oslo filtrerer sakene på taggen "Regelverk endret"
      Så ser saksbehandleren ved Universitetet i Oslo saken til "Kari Nordmann"

  @depends-on-OPT-BEH-BEH-025 @ref-FLY-OPT-AUT-001
  Regel: Bare saker som er ferdig behandlet, beregnes på nytt
    # Saker som ikke er behandlet eller er under behandling, beregnes ikke på nytt. De blir
    # beregnet når de blir behandlet. Saker som er ferdig behandlet, forblir ferdig behandlet.

    Scenario: Saken er fortsatt ferdig behandlet etter at poengene er beregnet på nytt
      Gitt at saken til "Kari Nordmann" hos "Universitetet i Oslo" er ferdig behandlet
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket "Ordinær rangering"
      Så har "Informatikk, UiO" poengsum for "Kari Nordmann" etter det rettede rangeringsregelverket
      Og saken til "Kari Nordmann" hos "Universitetet i Oslo" er fortsatt ferdig behandlet

    Scenariomal: En sak med behandlingsstatusen "<status>" beregnes ikke på nytt
      Gitt at saken til "Kari Nordmann" hos "Universitetet i Oslo" har behandlingsstatusen "<status>"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket "Ordinær rangering"
      Så er saken til "Kari Nordmann" hos "Universitetet i Oslo" ikke beregnet på nytt

      Eksempler:
        | status           |
        | Ikke behandlet   |
        | Under behandling |

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

  @openquestion @depends-on-OPT-BEH-BEH-033
  Regel: Beregningen kjører i bakgrunnen
    # ÅPNE SPØRSMÅL:
    # - Hva skjer når opptaksforvalteren starter en ny beregning før den forrige er ferdig, eller
    #   starter en beregning mens en plasstildeling kjører? Forslag: bare én beregning per opptak
    #   om gangen, og ingen beregning mens en plasstildeling kjører.
    # - Kan opptaksforvalteren beregne på nytt etter siste plasstildelingsrunde, eller etter at
    #   resultatet er publisert?
    # - Opptaksforvalteren ved HK-dir starter beregningen, men sakene er hos andre organisasjoner.
    #   Hvem står som den som endret, i endringsloggen? Forslag: den automatiske behandlingen, og
    #   det lagres hvem som startet beregningen.

    Scenario: Opptaksforvalteren ser når beregningen er ferdig
      Gitt at opptaksforvalteren har startet en beregning på nytt for søknadsalternativene med rangeringsregelverket "Ordinær rangering"
      Når beregningen er ferdig
      Så ser opptaksforvalteren at beregningen er ferdig

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
