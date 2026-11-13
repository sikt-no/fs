# language: no
@OPT-BEH-BEH-026 @must @in-progress @scope-beregne-automatisk-pa-nytt
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
    Gitt at opptaksforvalteren er innlogget

  @implemented
  Regel: Opptaksforvalteren velger regelverkene feilen gjaldt
    # Utvalget er regelverkene i regelverkssamlingen på opptaket. En sak er med når minst ett av
    # søknadsalternativene i saken har ett av regelverkene opptaksforvalteren har valgt.
    # Avklart 05.11.2026: kvotetypene og kvotespørsmålene hører ikke til et kompetanse- eller
    # rangeringsregelverk, men ligger i regelverkssamlingen (OPT-REG-SAM-001). Er en
    # kvotetype eller et kvotespørsmål rettet, velger opptaksforvalteren alle regelverkene.
    # Kvotetypen er ikke et eget utvalg.

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
      Gitt at det ene søknadsalternativet har rangeringsregelverket "Ordinær rangering"
      Og at det andre søknadsalternativet har rangeringsregelverket "Rangering etter opptaksprøve"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket "Ordinær rangering"
      Så er sakene beregnet på nytt for det ene søknadsalternativet
      Men sakene er ikke beregnet på nytt for det andre søknadsalternativet

    Scenario: Saker med ett av regelverkene som er valgt, beregnes på nytt
      Gitt at det ene søknadsalternativet har kompetanseregelverket "Informatikk"
      Og at det andre søknadsalternativet har rangeringsregelverket "Ordinær rangering"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kompetanseregelverket "Informatikk" og rangeringsregelverket "Ordinær rangering"
      Så er sakene beregnet på nytt for begge søknadsalternativene

    Scenario: Opptaksforvalteren ser hvor mange saker som beregnes på nytt, før beregningen starter
      Når opptaksforvalteren velger et rangeringsregelverk
      Så ser opptaksforvalteren hvor mange saker som blir beregnet på nytt

    Scenario: Regelverkene opptaksforvalteren kan velge, er regelverkene i opptaket
      Når opptaksforvalteren velger regelverkene feilen gjaldt
      Så kan opptaksforvalteren bare velge regelverkene i regelverkssamlingen på opptaket

  @depends-on-OPT-BEH-BEH-018 @depends-on-OPT-BEH-BEH-020 @ref-FLY-OPT-AUT-001 @implemented
  Regel: I saker den automatiske behandlingen har behandlet, beregnes kravelementene og poengene på nytt
    # Saken er behandlet av den automatiske behandlingen når den automatiske behandlingen har kjørt
    # på saken, også når saksbehandleren har endret saken etterpå. Kravelementene saksbehandleren
    # har vurdert, og poengene saksbehandleren har satt, beregnes ikke på nytt.
    # Grunnlaget velges ikke på nytt.

    Scenario: Kravelementene og poengene beregnes på nytt i en sak den automatiske behandlingen har behandlet
      Gitt at den automatiske behandlingen har behandlet saken
      Og at opptaksforvalteren har rettet en feil i kompetanseregelverket
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kompetanseregelverket som er rettet
      Så er kravelementene og poengene for søkeren på søknadsalternativet beregnet på nytt etter det rettede kompetanseregelverket
      Og kvalifiseringen, poengsummen og kvoten for søkeren på søknadsalternativet er regnet ut på nytt

    Scenario: Kravelementet saksbehandleren har vurdert, beregnes ikke på nytt
      Gitt at den automatiske behandlingen har behandlet saken
      Og at saksbehandleren har vurdert et kravelement for søkeren på søknadsalternativet
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kompetanseregelverket som er rettet
      Så er vurderingen saksbehandleren har gjort av kravelementet for søkeren, uendret

    Scenario: Poengene saksbehandleren har satt, beregnes ikke på nytt
      Gitt at den automatiske behandlingen har behandlet saken
      Og at saksbehandleren har satt poengene for søkeren på søknadsalternativet
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket som er rettet
      Så er poengene saksbehandleren har satt for søkeren, uendret

  @depends-on-OPT-BEH-BEH-018 @depends-on-OPT-BEH-BEH-020 @ref-FLY-OPT-AUT-001 @implemented
  Regel: Saker saksbehandleren har behandlet, får regnet ut kvalifiseringen, poengsummen og kvoten på nytt og blir merket
    # Saken er behandlet av saksbehandleren når den automatiske behandlingen ikke har kjørt på
    # saken. Kvalifiseringen, poengsummen og kvoten regnes ut på nytt fra det som står i saken.
    # Kravelementene og poengene beregnes ikke på nytt. Saken får taggen «Regelverk endret», fordi
    # det saksbehandleren har satt, kan bygge på det som var feil. Saksbehandleren fjerner taggen
    # når saken er sett på.

    Scenario: Poengsummen regnes ut på nytt i en sak saksbehandleren har behandlet
      Gitt at saksbehandleren har behandlet saken
      Og at opptaksforvalteren har rettet en feil i rangeringsregelverket
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket som er rettet
      Så har søknadsalternativet poengsum for søkeren etter det rettede rangeringsregelverket

    Scenario: Kravelementet saksbehandleren har vurdert, er uendret
      Gitt at saksbehandleren har behandlet saken
      Og at saksbehandleren har vurdert et kravelement for søkeren på søknadsalternativet
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kompetanseregelverket som er rettet
      Så er vurderingen saksbehandleren har gjort av kravelementet for søkeren, uendret

    Scenario: Saken saksbehandleren har behandlet, får taggen "Regelverk endret"
      Gitt at saksbehandleren har behandlet saken
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kompetanseregelverket som er rettet
      Så får saken taggen "Regelverk endret"

    Scenario: Saken den automatiske behandlingen har behandlet, får ikke taggen "Regelverk endret"
      Gitt at den automatiske behandlingen har behandlet saken
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kompetanseregelverket som er rettet
      Så får saken ikke taggen "Regelverk endret"

    Scenario: Saksbehandleren finner sakene med taggen "Regelverk endret"
      Gitt at saken har taggen "Regelverk endret"
      Når saksbehandleren filtrerer sakene på taggen "Regelverk endret"
      Så ser saksbehandleren saken

  @depends-on-OPT-BEH-BEH-025 @ref-FLY-OPT-AUT-001 @implemented
  Regel: Bare saker som er ferdig behandlet, beregnes på nytt
    # Saker som ikke er behandlet eller er under behandling, beregnes ikke på nytt. De blir
    # beregnet når de blir behandlet. Saker som er ferdig behandlet, forblir ferdig behandlet.

    Scenario: Saken er fortsatt ferdig behandlet etter at poengene er beregnet på nytt
      Gitt at saken er ferdig behandlet
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket som er rettet
      Så har søknadsalternativet poengsum for søkeren etter det rettede rangeringsregelverket
      Og saken er fortsatt ferdig behandlet

    Scenariomal: En sak med behandlingsstatusen "<status>" beregnes ikke på nytt
      Gitt at saken har behandlingsstatusen "<status>"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket som er rettet
      Så er saken ikke beregnet på nytt

      Eksempler:
        | status           |
        | Ikke behandlet   |
        | Under behandling |

    @depends-on-OPT-BEH-BEH-036
    # OPT-BEH-BEH-036: «Saken får automatiske mangeltekster når søkeren ikke er kvalifisert»
    Scenario: Søkeren ser den nye mangelteksten i en sak som er ferdig behandlet
      Gitt at den automatiske behandlingen har satt saken til ferdig behandlet
      Og at søkeren er kvalifisert for søknadsalternativet
      Og at en feil i kontrollmotoren er rettet, så vitnemålet til søkeren ikke lenger oppfyller et kravelement
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kravelementet
      Så er søkeren ikke lenger kvalifisert for søknadsalternativet
      Og søkeren ser den automatiske mangelteksten for kravelementet i Min kompetanse
      Og saken er fortsatt ferdig behandlet

    @depends-on-OPT-BEH-BEH-036
    # OPT-BEH-BEH-036: «Saken får automatiske mangeltekster når søkeren ikke er kvalifisert»
    Scenario: Den automatiske mangelteksten slettes når søkeren blir kvalifisert etter beregningen
      Gitt at den automatiske behandlingen har satt saken til ferdig behandlet
      Og at saken har en automatisk mangeltekst for et kravelement fordi søkeren ikke er kvalifisert for søknadsalternativet
      Og at en feil i kontrollmotoren er rettet, så vitnemålet til søkeren oppfyller kravelementet
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kravelementet
      Så er søkeren kvalifisert for søknadsalternativet
      Og søkeren ser ikke lenger den automatiske mangelteksten for kravelementet i Min kompetanse
      Og saken er fortsatt ferdig behandlet

  @depends-on-OPT-BEH-BEH-033 @implemented
  Regel: Beregningen kjører i bakgrunnen

    Scenario: Opptaksforvalteren ser når beregningen er ferdig
      Gitt at opptaksforvalteren har startet en beregning på nytt for søknadsalternativene med rangeringsregelverket som er rettet
      Når beregningen er ferdig
      Så ser opptaksforvalteren at beregningen er ferdig

  @ref-OPT-PLA-TIL-001
  Regel: Bare én beregning eller plasstildeling i opptaket om gangen
    # Avklart 05.11.2026: bare én beregning per opptak om gangen, ingen beregning mens en
    # plasstildeling kjører, og ingen plasstildeling mens en beregning kjører. Den som prøver å
    # starte noe som ikke kan kjøre, får beskjed om hvorfor. At plasstildelingen ikke starter mens
    # en beregning kjører, står i kravet taggen peker på.

    @implemented
    Scenario: Opptaksforvalteren kan ikke starte en ny beregning før den forrige er ferdig
      Gitt at en beregning på nytt i opptaket ikke er ferdig
      Når opptaksforvalteren starter en ny beregning på nytt i opptaket
      Så starter ikke beregningen
      Og opptaksforvalteren får beskjed om at en beregning på nytt kjører

    Scenario: Opptaksforvalteren kan ikke beregne på nytt mens en plasstildeling kjører
      Gitt at en plasstildeling i opptaket kjører
      Når opptaksforvalteren starter en beregning på nytt i opptaket
      Så starter ikke beregningen
      Og opptaksforvalteren får beskjed om at en plasstildeling kjører

  Regel: Saksloggen viser at den automatiske behandlingen endret saken
    # Avklart 05.11.2026: i saksloggen står den automatiske behandlingen som den som endret saken,
    # og det står hvem som startet beregningen.

    Scenario: Saksloggen viser at den automatiske behandlingen endret saken, og hvem som startet beregningen
      Gitt at opptaksforvalteren har startet en beregning på nytt i opptaket
      Når beregningen endrer poengsummen i saken
      Så viser saksloggen at den automatiske behandlingen endret saken
      Og saksloggen viser hvilken opptaksforvalter som startet beregningen

  @depends-on-OPT-PLA-TIL-001
  Regel: Beregningen gjelder fra neste plasstildeling
    # Avklart 05.11.2026: etter at resultatet av siste plasstildelingsrunde er publisert, kan
    # opptaksforvalteren ikke beregne på nytt. Da finnes ingen neste plasstildeling, og
    # saksbehandleren retter enkeltsakene.

    @implemented
    Scenario: En plasstildeling som er kjørt, endres ikke
      Gitt at en plasstildeling er kjørt
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket som er rettet
      Så er resultatet av plasstildelingen som er kjørt, uendret

    @implemented
    Scenario: Neste plasstildeling bruker det som er beregnet på nytt
      Gitt at opptaksforvalteren har beregnet på nytt for søknadsalternativene med rangeringsregelverket som er rettet
      Når opptaksforvalteren starter en plasstildeling
      Så bruker plasstildelingen poengsummene som er beregnet på nytt

    Scenario: Opptaksforvalteren kan ikke beregne på nytt etter at resultatet av siste plasstildelingsrunde er publisert
      Gitt at resultatet av siste plasstildelingsrunde i opptaket er publisert
      Når opptaksforvalteren starter en beregning på nytt i opptaket
      Så starter ikke beregningen
      Og opptaksforvalteren får beskjed om at resultatet av siste plasstildelingsrunde er publisert
