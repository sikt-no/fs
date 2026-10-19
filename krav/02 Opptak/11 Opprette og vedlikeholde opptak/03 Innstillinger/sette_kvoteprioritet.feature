# language: no
# GitHub: #216
@OPT-OVO-INN-003 @must @planned @scope-kvoter-i-opptaket-2027
Egenskap: Sette kvoteprioritet for opptaket
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å rangere kvotene i opptaket med kvoteprioritet
  slik at søkere som konkurrerer i flere kvoter, får tilbud i kvoten som er høyest prioritert i opptaket.

  # Kilde: skissen «Kvoter», fanen «Kvoteprioritet» (Figma node 22399:113465):
  # https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=22399-113465
  # og mockupen v12: https://fs.sikt.no/design-sketches/plassflyt-v1.12.html#kvoteprioritet
  # AVKLART 2026-10-15: Kvoteprioriteten er en rangering av kvotetypene i opptaket. Kvotetypene hentes fra
  # regelverkssamlingen som er knyttet til opptaket, og alle er med. Hver kvotetype har sitt eget tall,
  # fra 1 til antall kvotetyper i regelverkssamlingen. Likt tall og loddtrekning gjelder ikke,
  # og grensen 0–25 i mockupen v12 gjelder ikke.
  # Kvoteprioriteten settes sammen med plassflyten, se sette_plassflyt.feature. Hvordan plasstildelingen
  # bruker den, står i 14 Plasstildeling/03 Tildeling/gjennomføre_plasstildeling.feature.
  # I dag finnes kvoteprioriteten per utdanningskvote på utdanningstilbudet, og på kvotetypen i koden.
  # AVKLART 2026-10-15: Kvoteprioriteten settes bare på opptaket, og kan ikke overstyres per
  # utdanningstilbud. Utdanningstilbudet viser kvoteprioriteten for utdanningskvotene som er knyttet til det, se
  # 12 Utdanningstilbud/03 Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature.
  # AVKLART 2026-10-16 (tilbakemelding fra HK-dir): HK-dir er positive til å sette kvoteprioriteten på opptaket.
  # De ønsker å kunne overstyre rekkefølgen for enkeltutdanninger hvis det kommer endringer fra politisk hold.
  # Det tas stilling til når behovet oppstår, og er ikke en del av kravet nå.
  # Teksten øverst i skissen om loddtrekning ved likt kvoteprioritetstall er hentet fra SODA, og skal fjernes,
  # siden to kvotetyper ikke kan ha samme kvoteprioritet.
  # AVKLART 2026-10-19 (produkteier): Samme prinsipp som de andre innstillingene på opptaket. Kravet her beskriver
  # at kvoteprioriteten settes og finnes på opptaket. Hva plasstildelingen gjør med den, står i
  # 14 Plasstildeling/03 Tildeling/gjennomføre_plasstildeling.feature (Regel «Søkeren prøves i utdanningskvotene
  # etter kvoteprioritet»), og skal løses senere.
  # Gjeldende skisse (prototyp v1.13, seksjonen «Kvoter», fanen «Kvoteprioritet»):
  # https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---Gjeldende-skisser?node-id=5299-11637

  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet
    Og at regelverkssamlingen som er knyttet til opptaket, har kvotetypene "Samisk førstegangsvitnemål (SAMF)", "Førstegangsvitnemål (ORDF)" og "Ordinær kvote (ORD)"

  Regel: Kvoteprioriteten settes på opptaket

    Scenario: Alle kvotetypene i regelverkssamlingen rangeres
      Når opptaksforvalter åpner kvoteprioriteten for opptaket
      Så ser opptaksforvalter kvotetypene "Samisk førstegangsvitnemål (SAMF)", "Førstegangsvitnemål (ORDF)" og "Ordinær kvote (ORD)" fra regelverkssamlingen som er knyttet til opptaket

    # AVKLART 2026-10-16: Regelverkssamlingen sier bare hvilke kvotetyper som er tilgjengelige. Rangeringen
    # settes først i opptaket.
    Scenario: Første gang vises kvotetypene i tilfeldig rekkefølge
      Gitt at kvoteprioriteten for opptaket ikke er satt
      Når opptaksforvalter åpner kvoteprioriteten for opptaket
      Så vises kvotetypene "Samisk førstegangsvitnemål (SAMF)", "Førstegangsvitnemål (ORDF)" og "Ordinær kvote (ORD)" i tilfeldig rekkefølge
      Og opptaksforvalter må sette rekkefølgen

    Scenario: Ny kvotetype i regelverkssamlingen kommer nederst
      Gitt at kvoteprioriteten er 1 for "Samisk førstegangsvitnemål (SAMF)", 2 for "Førstegangsvitnemål (ORDF)" og 3 for "Ordinær kvote (ORD)"
      Når kvotetypen "Idrett (IDRETT)" legges til i regelverkssamlingen som er knyttet til opptaket
      Så vises "Idrett (IDRETT)" nederst i kvoteprioriteten for opptaket
      Og opptaksforvalter må ta stilling til hvor "Idrett (IDRETT)" skal stå i rekkefølgen

    Scenario: Sette kvoteprioritet for opptaket
      Når opptaksforvalter setter kvoteprioritet 1 for "Samisk førstegangsvitnemål (SAMF)", 2 for "Førstegangsvitnemål (ORDF)" og 3 for "Ordinær kvote (ORD)"
      Og opptaksforvalter lagrer opptaket
      Så har opptaket kvoteprioritet 1 for "Samisk førstegangsvitnemål (SAMF)", 2 for "Førstegangsvitnemål (ORDF)" og 3 for "Ordinær kvote (ORD)"

  # Regelen «Søkeren får tilbud i kvoten som er høyest prioritert i opptaket» er flyttet 2026-10-19 til
  # 14 Plasstildeling/03 Tildeling/gjennomføre_plasstildeling.feature, der virkningen av kvoteprioriteten står.

  Regel: Kvotetypene rangeres fra 1 til antall kvotetyper i regelverkssamlingen

    # AVKLART 2026-10-16: En kvotetype har aldri samme prioritet som en annen. Den står alltid over eller under,
    # aldri ved siden av.

    Scenario: To kvotetyper kan ikke ha samme kvoteprioritet
      Gitt at kvoteprioriteten er 1 for "Samisk førstegangsvitnemål (SAMF)"
      Når opptaksforvalter setter kvoteprioritet 1 for "Førstegangsvitnemål (ORDF)"
      Så blir kvoteprioriteten ikke lagret

    Scenariomal: Ugyldig kvoteprioritet
      Når opptaksforvalter setter kvoteprioritet <verdi> for "Ordinær kvote (ORD)"
      Så blir kvoteprioriteten ikke lagret

      Eksempler:
        | verdi |
        | 0     |
        | 4     |
        | 2,5   |
