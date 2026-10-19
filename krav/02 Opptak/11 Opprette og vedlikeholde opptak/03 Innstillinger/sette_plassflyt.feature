# language: no
# GitHub: #216, #598
@OPT-OVO-INN-002 @must @planned @scope-kvoter-i-opptaket-2027
Egenskap: Sette standard plassflyt for opptaket
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å sette én standard plassflyt for opptaket
  slik at ledige plasser går videre til riktig utdanningskvote på alle utdanningstilbud i opptaket.

  # Flyttet hit 2026-10-13 fra 14 Plasstildeling/02 Tildelingsinnstillinger/plassflyt.feature.
  # Hva plasstildelingen gjør med plassflyten, står der.
  # AVKLART 2026-10-13: Standard plassflyt settes på opptaket, og gjelder alle utdanningstilbud i opptaket
  # som har fått registrert utdanningskvoter. Det finnes nøyaktig én hovedkvote for hele opptaket (i UHG:
  # Ordinær), og en kjede av kvoter kan lede fram til den. Hvilke kvoter som finnes, varierer mellom
  # utdanningstilbudene, men rekkefølgen i kjeden og hovedkvoten er den samme.
  # AVKLART 2026-10-15 (som skissen): Hver kvote har én mottaker, og flere kvoter kan ha samme mottaker.
  # Det HK-dir beskrev som flere mottakere i prioritert rekkefølge, er en kjede: Samisk til Nordland,
  # Troms og Finnmark, Nordland, Troms og Finnmark til Nordnorsk, og Nordnorsk til Ordinær.
  #
  # AVKLART 2026-10-15: Plassflyten settes bare på opptaket. Den kan ikke overstyres per utdanningstilbud,
  # og settes ikke per plasstildeling. Den gjelder utdanningskvotene som er knyttet til utdanningstilbudene,
  # og brukes i plasstildelingen. Regelverkssamlingen har bare kvotetypene, ikke plassflyten.
  # Utdanningstilbudet viser plassflyten mellom utdanningskvotene som er knyttet til det, se
  # 12 Utdanningstilbud/03 Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature.
  #
  # Vernet mot sirkulær plassflyt kommer fra GitHub #598.
  # AVKLART 2026-10-15: Kvoteprioriteten settes også på opptaket, se sette_kvoteprioritet.feature.
  # AVKLART 2026-10-19 (produkteier): Samme prinsipp som de andre innstillingene på opptaket. Kravet her beskriver
  # at plassflyten settes og finnes på opptaket. Hva plasstildelingen gjør med den, står i
  # 14 Plasstildeling/02 Tildelingsinnstillinger/plassflyt.feature, og skal løses senere.
  # Skisse (gjeldende, prototyp v1.13, seksjonen «Kvoter» i opprett opptak):
  # https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---Gjeldende-skisser?node-id=5299-11637
  # Eldre skisse: https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=22410-106608

  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet

  Regel: Standard plassflyt settes på opptaket

    Scenario: Sette standard plassflyt for opptaket
      Når opptaksforvalter setter standard plassflyt for opptaket "Samordna opptak 2027"
      Og opptaksforvalter lagrer opptaket
      Så har opptaket "Samordna opptak 2027" standard plassflyt

  # AVKLART 2026-10-19 (gjeldende skisse): Hovedkvoten velges for seg, og er kvoten ledige plasser til slutt
  # havner i. Kvotene som er koblet, sender ledige plasser videre i en kjede som ender i hovedkvoten.
  Regel: Opptaket har nøyaktig én hovedkvote

    Scenario: Velge hovedkvote for opptaket
      Når opptaksforvalter velger "Ordinær kvote (ORD)" som hovedkvote i standard plassflyt for opptaket
      Og opptaksforvalter lagrer opptaket
      Så er "Ordinær kvote (ORD)" hovedkvote i standard plassflyt for opptaket
      Og "Ordinær kvote (ORD)" sender ikke ledige plasser videre

    Scenario: Plassflyten kan ikke lagres uten hovedkvote
      Gitt at hovedkvoten ikke er valgt i standard plassflyt for opptaket
      Når opptaksforvalter lagrer opptaket
      Så blir plassflyten ikke lagret
      Og opptaksforvalter får beskjed om at opptaket må ha en hovedkvote

  # AVKLART 2026-10-15 (skisse «Kvoter», Figma node 22410:106608): Opptaksforvalteren må ta aktivt stilling til
  # alle kvotetypene som gjelder for opptaket, og legge dem inn i plassflyten. «Ikke koblet» i skissen er
  # startverdien, ikke et gyldig valg.
  # AVKLART 2026-10-19 (produkteier): Gjelder fortsatt. Utdanningstilbudene bruker bare noen av kvotene, og
  # flyten skal kunne gjenbrukes, så alle kvotene i opptaket må være knyttet inn i flyten. Teksten i den
  # gjeldende skissen («Ledige plasser i disse kvotene flyttes ikke til andre kvoter.») er feil.
  Regel: Alle kvotene i opptaket må være koblet inn i plassflyten

    Scenario: Kvotetyper som ikke er koblet, hindrer lagring
      Gitt at kvotetypen "Idrett (IDRETT)" gjelder for opptaket "Samordna opptak 2027"
      Og at kvotetypen "Idrett (IDRETT)" ikke er koblet til plassflyten
      Når opptaksforvalter lagrer opptaket
      Så blir plassflyten ikke lagret
      Og opptaksforvalter ser at kvotetypen "Idrett (IDRETT)" må kobles til plassflyten

  Regel: Plassflyten kan ikke gå i ring

    # AVKLART 2026-10-15: Scenarioet blir stående, fordi det er mulig å lage en ring i dag. Kravet om én
    # hovedkvote, som alle kjeder ender i, skal utelukke at ringen oppstår.

    Scenario: Sirkulær plassflyt
      Gitt at ledige plasser i "Førstegangsvitnemål (ORDF)" flyter til "Ordinær kvote (ORD)" i standard plassflyt for opptaket
      Når opptaksforvalter setter at ledige plasser i "Ordinær kvote (ORD)" skal flyte til "Førstegangsvitnemål (ORDF)"
      Så blir plassflyten ikke lagret
      Og opptaksforvalter får beskjed om at plassflyten ikke kan gå i ring
