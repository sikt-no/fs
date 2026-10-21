# language: no
# GitHub: #216
@OPT-REG-KVO-004 @must @planned @scope-kvoter-i-opptaket-2027 @ref-OPT-PLA-TIL-002 @ref-OPT-OPT-UTD-004
Egenskap: Sette kvoteprioritet i regelverkssamlingen
  Som regelverksforvalter ved organisasjonen som eier regelverkssamlingen
  ønsker jeg å rangere kvotetypene i regelverkssamlingen med kvoteprioritet
  slik at søkere som konkurrerer i flere kvoter, først får tilbud i kvoten som er høyest prioritert.

  # AVKLART 2026-10-21 (produkteier): Kvoteprioriteten er en del av regelverket, ikke en innstilling på opptaket.
  # Den settes på regelverkssamlingen, og gjelder alle opptak som bruker regelverkssamlingen. Opptaket setter den
  # ikke. Det erstatter avklaringene 2026-10-15 og 2026-10-16 om at kvoteprioriteten settes på opptaket, og at
  # regelverkssamlingen bare sier hvilke kvotetyper som er tilgjengelige.
  # Flyttet hit 2026-10-21 fra 11 Opprette og vedlikeholde opptak/03 Innstillinger/sette_kvoteprioritet.feature.
  # Feature-ID-en var @OPT-OVO-INN-003.
  # AVKLART 2026-10-16 (produktleder): Bare organisasjonen som har opprettet regelverket, kan endre det.
  #
  # Kilde: skissen «Kvoter», fanen «Kvoteprioritet» (Figma node 22399:113465):
  # https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=22399-113465
  # og mockupen v12: https://fs.sikt.no/design-sketches/plassflyt-v1.12.html#kvoteprioritet
  # AVKLART 2026-10-15: Kvoteprioriteten er en rangering av kvotetypene i regelverkssamlingen, og alle er med.
  # Hver kvotetype har sitt eget tall, fra 1 til antall kvotetyper i regelverkssamlingen. Likt tall og
  # loddtrekning gjelder ikke, og grensen 0–25 i mockupen v12 gjelder ikke.
  # Kvoteprioriteten settes sammen med plassflyten, se sette_plassflyt.feature.
  # AVKLART 2026-10-15: Kvoteprioriteten kan ikke overstyres per utdanningstilbud. Utdanningstilbudet viser
  # kvoteprioriteten for utdanningskvotene som er knyttet til det, se
  # 12 Utdanningstilbud/03 Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature.
  # AVKLART 2026-10-16 (tilbakemelding fra HK-dir): HK-dir ønsker å kunne overstyre rekkefølgen for
  # enkeltutdanninger hvis det kommer endringer fra politisk hold. Det tas stilling til når behovet oppstår, og er
  # ikke en del av kravet nå.
  # Teksten øverst i skissen om loddtrekning ved likt kvoteprioritetstall er hentet fra SODA, og skal fjernes,
  # siden to kvotetyper ikke kan ha samme kvoteprioritet.
  # AVKLART 2026-10-19 (produkteier): Kravet her beskriver at kvoteprioriteten settes og finnes i
  # regelverkssamlingen. Hva plasstildelingen gjør med den, står i
  # 14 Plasstildeling/03 Tildeling/gjennomføre_plasstildeling.feature (Regel «Søkeren prøves i utdanningskvotene
  # etter kvoteprioritet»), og skal løses senere.
  # Gjeldende skisse (prototyp v1.13, seksjonen «Kvoter», fanen «Kvoteprioritet», før kvoteprioriteten ble flyttet
  # til regelverket): https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---Gjeldende-skisser?node-id=5299-11637

  Bakgrunn:
    Gitt at regelverksforvalter ved organisasjonen som eier regelverkssamlingen er innlogget
    Og at regelverkssamlingen "UHG 2027" har kvotetypene "Samisk førstegangsvitnemål (SAMF)", "Førstegangsvitnemål (ORDF)" og "Ordinær kvote (ORD)"

  Regel: Kvoteprioriteten settes i regelverkssamlingen

    Scenario: Alle kvotetypene i regelverkssamlingen rangeres
      Når regelverksforvalter åpner kvoteprioriteten i regelverkssamlingen "UHG 2027"
      Så ser regelverksforvalter kvotetypene "Samisk førstegangsvitnemål (SAMF)", "Førstegangsvitnemål (ORDF)" og "Ordinær kvote (ORD)"

    # AVKLART 2026-10-21 (produkteier): Første gang står kvotetypene uten nummer, ikke i tilfeldig rekkefølge.
    Scenario: Første gang står kvotetypene uten kvoteprioritet
      Gitt at kvoteprioriteten i regelverkssamlingen ikke er satt
      Når regelverksforvalter åpner kvoteprioriteten i regelverkssamlingen "UHG 2027"
      Så står kvotetypene "Samisk førstegangsvitnemål (SAMF)", "Førstegangsvitnemål (ORDF)" og "Ordinær kvote (ORD)" uten kvoteprioritet
      Og regelverksforvalter må sette kvoteprioriteten for hver kvotetype

    # AVKLART 2026-10-21 (produkteier): En ny kvotetype kommer inn uten nummer, ikke nederst i rekkefølgen.
    # Regelverksforvalter må aktivt ta stilling til hvilken kvoteprioritet kvotetypen skal ha.
    Scenario: Ny kvotetype i regelverkssamlingen kommer inn uten kvoteprioritet
      Gitt at kvoteprioriteten er 1 for "Samisk førstegangsvitnemål (SAMF)", 2 for "Førstegangsvitnemål (ORDF)" og 3 for "Ordinær kvote (ORD)"
      Når kvotetypen "Idrett (IDRETT)" legges til i regelverkssamlingen "UHG 2027"
      Så har "Idrett (IDRETT)" ingen kvoteprioritet i regelverkssamlingen
      Og regelverksforvalter må sette kvoteprioriteten for "Idrett (IDRETT)"

    Scenario: Sette kvoteprioritet i regelverkssamlingen
      Når regelverksforvalter setter kvoteprioritet 1 for "Samisk førstegangsvitnemål (SAMF)", 2 for "Førstegangsvitnemål (ORDF)" og 3 for "Ordinær kvote (ORD)"
      Og regelverksforvalter lagrer kvoteprioriteten
      Så har regelverkssamlingen "UHG 2027" kvoteprioritet 1 for "Samisk førstegangsvitnemål (SAMF)", 2 for "Førstegangsvitnemål (ORDF)" og 3 for "Ordinær kvote (ORD)"

  # AVKLART 2026-10-21 (produkteier): Kvoteprioriteten kan lagres selv om kvotetyper står uten kvoteprioritet,
  # men regelverkseieren må få et varsel om det som mangler. Det er kvotetypene som lagres, ikke
  # regelverkssamlingen.
  # AVKLART 2026-10-21 (produkteier): Varselet står på kvotetypen. En kvotetype uten kvoteprioritet kan ikke brukes
  # av utdanningstilbud eller i plasstildelingen. Det står i
  # 12 Utdanningstilbud/03 Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature og
  # 14 Plasstildeling/03 Tildeling/gjennomføre_plasstildeling.feature.
  Regel: Kvoteprioriteten kan lagres med kvotetyper uten kvoteprioritet

    Scenario: Varsel om kvotetyper uten kvoteprioritet
      Gitt at "Idrett (IDRETT)" ikke har kvoteprioritet i regelverkssamlingen "UHG 2027"
      Når regelverksforvalter lagrer kvotetypen
      Så er kvotetypen lagret uten kvoteprioritet
      Og regelverksforvalter ser et varsel på kvotetypen "Idrett (IDRETT)" om at kvoteprioritet mangler

  # Regelen «Søkeren får tilbud i kvoten som er høyest prioritert i opptaket» er flyttet 2026-10-19 til
  # 14 Plasstildeling/03 Tildeling/gjennomføre_plasstildeling.feature, der virkningen av kvoteprioriteten står.

  Regel: Kvotetypene rangeres fra 1 til antall kvotetyper i regelverkssamlingen

    # AVKLART 2026-10-16: En kvotetype har aldri samme prioritet som en annen. Den står alltid over eller under,
    # aldri ved siden av.
    # AVKLART 2026-10-21 (produkteier): Tar en kvotetype prioriteringsplassen til en annen, skyves kvotetypen som
    # er fratatt plassen, ett trinn ned. Det erstatter at kvoteprioriteten ikke blir lagret.

    Scenario: Kvotetypen som mister plassen, skyves ett trinn ned
      Gitt at kvoteprioriteten er 1 for "Samisk førstegangsvitnemål (SAMF)", 2 for "Førstegangsvitnemål (ORDF)" og 3 for "Ordinær kvote (ORD)"
      Når regelverksforvalter setter kvoteprioritet 1 for "Førstegangsvitnemål (ORDF)"
      Så er kvoteprioriteten i regelverkssamlingen
        | kvotetype                         | kvoteprioritet |
        | Førstegangsvitnemål (ORDF)        | 1              |
        | Samisk førstegangsvitnemål (SAMF) | 2              |
        | Ordinær kvote (ORD)               | 3              |

    Scenariomal: Ugyldig kvoteprioritet
      Når regelverksforvalter setter kvoteprioritet <verdi> for "Ordinær kvote (ORD)"
      Så blir kvoteprioriteten ikke lagret

      Eksempler:
        | verdi |
        | 0     |
        | 4     |
        | 2,5   |