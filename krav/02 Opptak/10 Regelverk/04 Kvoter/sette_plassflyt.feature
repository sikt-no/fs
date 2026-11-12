# language: no
# GitHub: #216, #598
@OPT-REG-KVO-003 @must @in-progress @scope-kvoter-i-opptaket-2027 @ref-OPT-PLA-INN-002 @ref-OPT-OPT-UTD-004
Egenskap: Sette standard plassflyt i regelverkssamlingen
  Som opptaksforvalter ved organisasjonen som eier regelverkssamlingen
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
    Gitt at opptaksforvalter ved organisasjonen som eier regelverkssamlingen er innlogget
    Og at regelverkssamlingen "UHG 2027" er opprettet

  Regel: Standard plassflyt settes i regelverkssamlingen

    Scenario: Sette standard plassflyt i regelverkssamlingen
      Når opptaksforvalter setter standard plassflyt i regelverkssamlingen "UHG 2027"
      Og opptaksforvalter lagrer plassflyten
      Så har regelverkssamlingen "UHG 2027" standard plassflyt

  # AVKLART 2026-11-11 (produkteier): Hovedkvoten er kvoten ledige plasser til slutt havner i. Kvotene som er
  # koblet, sender ledige plasser videre i en kjede som ender i hovedkvoten. Om hovedkvoten velges for seg eller
  # regnes ut fra kjedene, er en implementasjonsdetalj, se sette_plassflyt.design.md. Erstatter avklaringen
  # 2026-10-19 om at hovedkvoten velges for seg.
  Regel: Regelverkssamlingen har én hovedkvote

    Scenario: Hovedkvoten er kvoten kjedene ender i
      Gitt at "Førstegangsvitnemål (ORDF)" sender ledige plasser til "Ordinær kvote (ORD)" i standard plassflyt i regelverkssamlingen
      Og at "Ordinær kvote (ORD)" ikke sender ledige plasser videre
      Når opptaksforvalter lagrer plassflyten
      Så er "Ordinær kvote (ORD)" hovedkvote i standard plassflyt i regelverkssamlingen

    Scenario: Plassflyten kan ikke lagres uten hovedkvote
      Gitt at ingen kvoter sender ledige plasser videre i standard plassflyt i regelverkssamlingen
      Når opptaksforvalter lagrer plassflyten
      Så blir plassflyten ikke lagret
      Og opptaksforvalter får beskjed om at regelverkssamlingen må ha en hovedkvote

    Scenario: Plassflyten kan ikke lagres med flere hovedkvoter
      Gitt at "Førstegangsvitnemål (ORDF)" sender ledige plasser til "Ordinær kvote (ORD)" i standard plassflyt i regelverkssamlingen
      Og at "Samisk språkkompetanse (SAM)" sender ledige plasser til "Nordnorsk kvote (NN)" i standard plassflyt i regelverkssamlingen
      Og at verken "Ordinær kvote (ORD)" eller "Nordnorsk kvote (NN)" sender ledige plasser videre
      Når opptaksforvalter lagrer plassflyten
      Så blir plassflyten ikke lagret
      Og opptaksforvalter får beskjed om at plassflyten bare kan ha én hovedkvote

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
      Når opptaksforvalter lagrer plassflyten
      Så er plassflyten lagret
      Og opptaksforvalter ser et varsel på kvotetypen "Idrett (IDRETT)" om at plassflyten mangler

  # AVKLART 2026-11-11 (produkteier): En kvotetype uten plasser er ikke med i plassflyten. Den har ingen plasser
  # å avgi, og tilbudene i den tas fra hovedkvoten. Den sender ikke ledige plasser videre, kan ikke være
  # hovedkvote, og kan ikke ta imot ledige plasser. Erstatter avklaringen 2026-11-06 om at kvotetypen kobles
  # til hovedkvoten. Kravet bruker ikke SPEV som eksempel, se opprette_ventekvote.feature.
  # Hva plasstildelingen gjør, står i 14 Plasstildeling/03 Tildeling/gjennomføre_plasstildeling.feature.
  Regel: En kvotetype uten plasser er ikke med i plassflyten

    Scenario: En kvotetype uten plasser sender ikke ledige plasser videre
      Gitt at kvotetypen "Ventekvote (VENT)" er uten plasser
      Når opptaksforvalter setter standard plassflyt i regelverkssamlingen "UHG 2027"
      Så kan opptaksforvalter ikke velge mottaker for "Ventekvote (VENT)"

    Scenario: En kvotetype uten plasser kan ikke være hovedkvote
      Gitt at kvotetypen "Ventekvote (VENT)" er uten plasser
      Når opptaksforvalter setter standard plassflyt i regelverkssamlingen "UHG 2027"
      Så kan "Ventekvote (VENT)" ikke bli hovedkvote

    Scenario: En kvote kan ikke sende ledige plasser til en kvotetype uten plasser
      Gitt at kvotetypen "Ventekvote (VENT)" er uten plasser
      Når opptaksforvalter velger mottaker for "Førstegangsvitnemål (ORDF)" i standard plassflyt
      Så kan opptaksforvalter ikke velge "Ventekvote (VENT)" som mottaker

    Scenario: Ingen varsel om plassflyt for en kvotetype uten plasser
      Gitt at regelverkssamlingen "UHG 2027" har kvotetypen "Ventekvote (VENT)" uten plasser
      Når opptaksforvalter lagrer plassflyten
      Så er plassflyten lagret
      Og opptaksforvalter ser ikke et varsel på kvotetypen "Ventekvote (VENT)" om at plassflyten mangler

  Regel: Plassflyten kan ikke gå i ring

    # AVKLART 2026-10-15: Scenarioet blir stående, fordi det er mulig å lage en ring i dag. Kravet om én
    # hovedkvote, som alle kjeder ender i, skal utelukke at ringen oppstår.

    Scenario: Sirkulær plassflyt
      Gitt at ledige plasser i "Samisk språkkompetanse (SAM)" flyter til "Nordnorsk kvote (NN)" i standard plassflyt i regelverkssamlingen
      Når opptaksforvalter setter at ledige plasser i "Nordnorsk kvote (NN)" skal flyte til "Samisk språkkompetanse (SAM)"
      Så blir plassflyten ikke lagret
      Og opptaksforvalter får beskjed om at plassflyten ikke kan gå i ring
