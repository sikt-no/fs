# language: no
# GitHub: #216, #598
@OPT-REG-KVO-003 @must @planned @scope-kvoter-i-opptaket-2027 @ref-OPT-PLA-INN-002 @ref-OPT-OPT-UTD-004
Egenskap: Sette standard plassflyt i regelverkssamlingen
  Som regelverksforvalter ved organisasjonen som eier regelverkssamlingen
  ønsker jeg å sette én standard plassflyt i regelverkssamlingen
  slik at ledige plasser i opptak som bruker regelverkssamlingen går videre til riktig utdanningskvote på alle utdanningstilbud i opptakene som bruker regelverkssamlingen.

  # AVKLART 2026-10-21 (produkteier): Plassflyten er en del av regelverket, ikke en innstilling på opptaket.
  # Den settes på regelverkssamlingen, og gjelder alle opptak som bruker regelverkssamlingen. Opptaket setter den
  # ikke. Det erstatter avklaringene 2026-10-13 og 2026-10-15 om at plassflyten settes på opptaket, og at
  # regelverkssamlingen bare har kvotetypene.
  # Flyttet hit 2026-10-21 fra 11 Opprette og vedlikeholde opptak/03 Innstillinger/sette_plassflyt.feature.
  # Feature-ID-en var @OPT-OVO-INN-002.
  # AVKLART 2026-10-16 (produktleder): Bare organisasjonen som har opprettet regelverket, kan endre det.
  #
  # AVKLART 2026-10-13: Det finnes nøyaktig én hovedkvote (i UHG: Ordinær), og en kjede av kvoter kan lede fram
  # til den. Hvilke kvoter som finnes, varierer mellom utdanningstilbudene, men rekkefølgen i kjeden og hovedkvoten
  # er den samme.
  # AVKLART 2026-10-15 (som skissen): Hver kvote har én mottaker, og flere kvoter kan ha samme mottaker.
  # Det HK-dir beskrev som flere mottakere i prioritert rekkefølge, er en kjede: Samisk til Nordland,
  # Troms og Finnmark, Nordland, Troms og Finnmark til Nordnorsk, og Nordnorsk til Ordinær.
  # AVKLART 2026-10-15: Plassflyten kan ikke overstyres per utdanningstilbud, og settes ikke per plasstildeling.
  # Utdanningstilbudet viser plassflyten mellom utdanningskvotene som er knyttet til det, se
  # 12 Utdanningstilbud/03 Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature.
  #
  # Vernet mot sirkulær plassflyt kommer fra GitHub #598.
  # Kvoteprioriteten settes også i regelverkssamlingen, se sette_kvoteprioritet.feature.
  # AVKLART 2026-10-19 (produkteier): Kravet her beskriver at plassflyten settes og finnes i regelverkssamlingen.
  # Hva plasstildelingen gjør med den, står i 14 Plasstildeling/02 Tildelingsinnstillinger/plassflyt.feature,
  # og skal løses senere.
  # Skisse (gjeldende, prototyp v1.13, seksjonen «Kvoter» i opprett opptak, før plassflyten ble flyttet til
  # regelverket): https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---Gjeldende-skisser?node-id=5299-11637
  # Eldre skisse: https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=22410-106608

  Bakgrunn:
    Gitt at regelverksforvalter ved organisasjonen som eier regelverkssamlingen er innlogget
    Og at regelverkssamlingen "UHG 2027" er opprettet

  Regel: Standard plassflyt settes i regelverkssamlingen

    Scenario: Sette standard plassflyt i regelverkssamlingen
      Når regelverksforvalter setter standard plassflyt i regelverkssamlingen "UHG 2027"
      Og regelverksforvalter lagrer plassflyten
      Så har regelverkssamlingen "UHG 2027" standard plassflyt

  # AVKLART 2026-10-19 (gjeldende skisse): Hovedkvoten velges for seg, og er kvoten ledige plasser til slutt
  # havner i. Kvotene som er koblet, sender ledige plasser videre i en kjede som ender i hovedkvoten.
  Regel: Regelverkssamlingen har én hovedkvote

    Scenario: Velge hovedkvote i regelverkssamlingen
      Når regelverksforvalter velger "Ordinær kvote (ORD)" som hovedkvote i standard plassflyt i regelverkssamlingen
      Og regelverksforvalter lagrer plassflyten
      Så er "Ordinær kvote (ORD)" hovedkvote i standard plassflyt i regelverkssamlingen
      Og "Ordinær kvote (ORD)" sender ikke ledige plasser videre

    Scenario: Plassflyten kan ikke lagres uten hovedkvote
      Gitt at hovedkvoten ikke er valgt i standard plassflyt i regelverkssamlingen
      Når regelverksforvalter lagrer plassflyten
      Så blir plassflyten ikke lagret
      Og regelverksforvalter får beskjed om at regelverkssamlingen må ha en hovedkvote

  # AVKLART 2026-10-19 (produkteier): Utdanningstilbudene bruker bare noen av kvotene, og flyten skal kunne
  # gjenbrukes, så alle kvotetypene må være knyttet inn i flyten før de kan brukes. Teksten i den gjeldende skissen
  # («Ledige plasser i disse kvotene flyttes ikke til andre kvoter.») er feil.
  # AVKLART 2026-10-21 (produkteier): Plassflyten kan lagres selv om kvotetyper ikke er koblet, som kvoteprioriteten.
  # Kvotetypen får et varsel om at plassflyten mangler, og kan ikke brukes av utdanningstilbud eller i
  # plasstildelingen før den er koblet. Det erstatter at plassflyten ikke blir lagret (avklart 2026-10-15).
  Regel: Plassflyten kan lagres med kvotetyper som ikke er koblet

    Scenario: Varsel om kvotetyper som ikke er koblet til plassflyten
      Gitt at regelverkssamlingen "UHG 2027" har kvotetypen "Idrett (IDRETT)"
      Og at kvotetypen "Idrett (IDRETT)" ikke er koblet til plassflyten
      Når regelverksforvalter lagrer plassflyten
      Så er plassflyten lagret
      Og regelverksforvalter ser et varsel på kvotetypen "Idrett (IDRETT)" om at plassflyten mangler

  # AVKLART 2026-10-21 (produkteier): En SPEV-kvote er en kvotetype med rangeringsmetoden SPEV (spesiell vurdering,
  # se kvoterregelverk.feature). Den er et venterom for søkere som får tilbudsgaranti, har ingen egne plasser, og
  # tilbudene i den tas fra hovedkvoten. Hva plasstildelingen gjør, står i
  # 14 Plasstildeling/03 Tildeling/gjennomføre_plasstildeling.feature.
  Regel: En SPEV-kvote kan bare ha hovedkvoten som mottaker

    Scenario: Koble en SPEV-kvote til hovedkvoten
      Gitt at kvotetypen "Spesiell vurdering (SPEV)" har rangeringsmetoden SPEV
      Og at "Ordinær kvote (ORD)" er hovedkvoten i standard plassflyt i regelverkssamlingen
      Når regelverksforvalter kobler "Spesiell vurdering (SPEV)" til "Ordinær kvote (ORD)"
      Og regelverksforvalter lagrer plassflyten
      Så sender "Spesiell vurdering (SPEV)" ledige plasser til "Ordinær kvote (ORD)" i standard plassflyt

    Scenario: En SPEV-kvote kan ikke kobles til en annen kvote enn hovedkvoten
      Gitt at kvotetypen "Spesiell vurdering (SPEV)" har rangeringsmetoden SPEV
      Og at "Ordinær kvote (ORD)" er hovedkvoten i standard plassflyt i regelverkssamlingen
      Når regelverksforvalter vil koble "Spesiell vurdering (SPEV)" til "Førstegangsvitnemål (ORDF)"
      Så kan regelverksforvalter ikke koble "Spesiell vurdering (SPEV)" til "Førstegangsvitnemål (ORDF)"
      Og regelverksforvalter ser at en SPEV-kvote bare kan kobles til hovedkvoten

  Regel: Plassflyten kan ikke gå i ring

    # AVKLART 2026-10-15: Scenarioet blir stående, fordi det er mulig å lage en ring i dag. Kravet om én
    # hovedkvote, som alle kjeder ender i, skal utelukke at ringen oppstår.

    Scenario: Sirkulær plassflyt
      Gitt at ledige plasser i "Førstegangsvitnemål (ORDF)" flyter til "Ordinær kvote (ORD)" i standard plassflyt i regelverkssamlingen
      Når regelverksforvalter setter at ledige plasser i "Ordinær kvote (ORD)" skal flyte til "Førstegangsvitnemål (ORDF)"
      Så blir plassflyten ikke lagret
      Og regelverksforvalter får beskjed om at plassflyten ikke kan gå i ring
