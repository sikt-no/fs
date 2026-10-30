# language: no
@OPT-BEH-BEH-026 @must @draft
Egenskap: Beregne automatisk på nytt
  Som opptaksforvalter
  ønsker jeg å kjøre den automatiske behandlingen på nytt for søknadsalternativene en feil har rammet
  slik at søkerne får riktig grunnlag, kvalifisering, poeng og kvote når feilen er rettet.

  En feil i regelverket eller i kontrollmotoren for vitnemål kan gi feil resultat i den
  automatiske behandlingen for mange søkere på en gang. Når feilen er rettet, velger
  opptaksforvalteren hva som ble rettet, og den automatiske behandlingen kjøres på nytt for
  søknadsalternativene feilen gjaldt. Det som ble rettet, avgjør hvilke steg som beregnes på nytt,
  og stegene som bygger på dem, beregnes også på nytt. Det saksbehandleren har satt, endres ikke.
  Saker som er ferdig behandlet, forblir ferdig behandlet. Beregningen gjelder fra neste
  plasstildeling.

  # I FS-klienten gjøres dette med rutinen FS158.001. I fs-plattform kjører den automatiske
  # behandlingen én sak om gangen (AutomatiskSaksbehandlingService), og ingenting kjører den for
  # mange saker.

  # Avklart 30.10.2026: en feil i kontrollmotoren rettes av utviklerne, og de sier fra (for
  # eksempel i endringsloggen) hvilke kravelementer rettingen gjelder. Løsningen viser det ikke.

  # Avklart 30.10.2026: søkeren får ingen egen melding når kvalifiseringen, poengene eller kvoten
  # endres. Søkeren ser det som er endret, i Min kompetanse.

  # Avklart 30.10.2026: søkeren ser de automatiske mangeltekstene når saken er ferdig behandlet
  # (OPT-BEH-BEH-008). Gir beregningen på nytt en ny mangeltekst i en sak som er ferdig
  # behandlet, ser søkeren den med en gang. Ingen trenger å publisere den.

  # Avklart 30.10.2026: beregningen kjører som en jobb i bakgrunnen, etter det samme mønsteret
  # som de andre jobbene i opptak (OPT-BEH-BEH-033, kjøre_jobbene_i_opptak.feature, PR #864).
  # Når kravet er merget, får regelen «Beregningen kjører i bakgrunnen» @depends-on- til det.

  Bakgrunn:
    Gitt at opptaksforvalteren ved HK-dir er innlogget
    Og at "Informatikk, UiO" og "Historie, UiT" er med i opptaket "Samordna opptak 2027"

  Regel: Det som ble rettet, avgjør hvilke steg som beregnes på nytt

    Scenariomal: Opptaksforvalteren beregner på nytt etter en feil i <rettet>
      Gitt at opptaksforvalteren har rettet en feil i <rettet>
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med <utvalg>
      Så beregnes <steg> på nytt for søknadsalternativene med <utvalg>

      Eksempler:
        | rettet                             | utvalg                              | steg                                                            |
        | kontrollmotoren for vitnemål       | kravelementet "Matematikk R1"       | kravelementene, kvalifiseringen og kvoten                       |
        | kompetanseregelverket              | kompetanseregelverket som er rettet | kravelementene, kvalifiseringen og kvoten                       |
        | rangeringsregelverket              | rangeringsregelverket som er rettet | poengene                                                        |
        | grunnlagene                        | grunnlaget som er rettet            | grunnlaget, kravelementene, kvalifiseringen, poengene og kvoten |
        | kvotetypene eller kvotespørsmålene | kvotetypen "Ordinær kvote"          | kvoten                                                          |

    Scenario: Søknadsalternativer feilen ikke gjaldt, beregnes ikke på nytt
      Gitt at "Informatikk, UiO" har kravelementet "Matematikk R1"
      Og at "Historie, UiT" ikke har kravelementet "Matematikk R1"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kravelementet "Matematikk R1"
      Så er kravelementene for "Informatikk, UiO" beregnet på nytt
      Men kravelementene for "Historie, UiT" er ikke beregnet på nytt

  @depends-on-OPT-BEH-BEH-018 @depends-on-OPT-BEH-BEH-019 @depends-on-OPT-BEH-BEH-020
  Regel: Det saksbehandleren har satt, endres ikke

    Scenario: Kravelementet saksbehandleren har vurdert, beregnes ikke på nytt
      Gitt at saksbehandleren ved Universitetet i Oslo har vurdert "Matematikk R1" for "Kari Nordmann" på "Informatikk, UiO"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kravelementet "Matematikk R1"
      Så er vurderingen saksbehandleren ved Universitetet i Oslo har gjort av "Matematikk R1" for "Kari Nordmann", uendret

    Scenario: Opptaksforvalteren ser hvor mange søknadsalternativer som ble hoppet over
      Gitt at saksbehandleren ved Universitetet i Oslo har vurdert "Matematikk R1" for "Kari Nordmann" på "Informatikk, UiO"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kravelementet "Matematikk R1"
      Så ser opptaksforvalteren at 1 søknadsalternativ ikke ble beregnet på nytt fordi saksbehandleren har vurdert det

  @depends-on-OPT-BEH-BEH-025
  Regel: Saker som er ferdig behandlet, forblir ferdig behandlet

    Scenario: Saken er fortsatt ferdig behandlet etter at poengene er beregnet på nytt
      Gitt at saken til "Kari Nordmann" hos "Universitetet i Oslo" er ferdig behandlet
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med rangeringsregelverket som er rettet
      Så har "Informatikk, UiO" poengsum for "Kari Nordmann" etter det rettede rangeringsregelverket
      Og saken til "Kari Nordmann" hos "Universitetet i Oslo" er fortsatt ferdig behandlet

    @depends-on-OPT-BEH-BEH-008
    Scenario: Søkeren ser den nye mangelteksten i en sak som er ferdig behandlet
      Gitt at saken til "Kari Nordmann" hos "Universitetet i Oslo" er ferdig behandlet
      Og at "Kari Nordmann" er kvalifisert for "Informatikk, UiO"
      Når opptaksforvalteren beregner på nytt for søknadsalternativene med kravelementet "Matematikk R2"
      Og "Kari Nordmann" ikke lenger er kvalifisert for "Informatikk, UiO"
      Så ser "Kari Nordmann" den automatiske mangelteksten for "Matematikk R2" i Min kompetanse
      Og saken til "Kari Nordmann" hos "Universitetet i Oslo" er fortsatt ferdig behandlet

  @depends-on-OPT-BEH-BEH-025
  Regel: En sak som ble stående under behandling på grunn av feilen, blir ferdig behandlet når alt kan avgjøres
    # Avklart 30.10.2026. Saken kunne vært behandlet helautomatisk om regelverket hadde vært
    # riktig. Har saksbehandleren gjort noe i saken, blir den stående under behandling.

    Scenario: Saken blir ferdig behandlet når feilen er rettet
      Gitt at saken til "Kari Nordmann" hos "Universitetet i Oslo" er under behandling fordi poengene for "Informatikk, UiO" ikke kunne avgjøres på grunn av en feil i rangeringsregelverket
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
      Og opptaksforvalteren ser hvor mange søknadsalternativer som ble beregnet på nytt, og hvor mange som ble hoppet over

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
