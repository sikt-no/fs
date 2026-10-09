# language: no
# GitHub: #583
@OPT-PLA-INN-001 @must @draft
Egenskap: Antall tilbud som skal gis per utdanningskvote (sette opptaksparametere)
  Som opptaksforvalter
  ønsker jeg å bestemme hvor mange tilbud som skal gis i hver utdanningskvote i en runde
  slik at plasstildelingen fyller studieplassene uten å gi for mange eller for få tilbud.

  # Kilde: tasks/opptak/plasstildeling/oppgave.md (oppgave 2), design.md (begrepsforklaringer),
  # Confluence «2026-09-08 Raffinering plasstildeling» (oppgave 2) og raffinering 2026-10-07.
  # Antall tilbud som skal gis settes per utdanningskvote for den enkelte runde.
  # Opptaksforvalter ved lærestedet setter tallene for egne utdanningstilbud innenfor perioden
  # som er satt på runden (se 01 Runder/forvalte_runder.feature).
  # Opptaksforvalter ved forvaltende organisasjon kan endre tallene også utenfor perioden.
  # Begrep (avklart 2026-10-08): «antall tilbud som skal gis». «Overbooking», «måltall» og
  # «antall ønsket ja-svar» brukes ikke.
  # Brukerne kaller i dag handlingen å «sette opptaksparametere». Det ordet skjuler at det bare er
  # én ting som settes, nemlig antall tilbud som skal gis. Det står derfor bare i parentes i tittelen
  # og i denne kommentaren, og brukes ikke i scenarioene.

  Bakgrunn:
    Gitt at opptaksforvalter ved lærestedet er innlogget
    Og at opptaket "Samordna opptak 2027" har runden "Hovedrunde" med rundetype "Hovedtildeling"
    Og at utdanningstilbudet "Sykepleie, høst 2027" har utdanningskvotene "Førstegangsvitnemål" og "Ordinær"

  Regel: Opptaksforvalter setter antall tilbud som skal gis per utdanningskvote for runden

    # Opptaksforvalter slår opp siden for å sette antall tilbud som skal gis og ser
    # en liste over utdanningstilbud med sine utdanningskvoter.
    # Tallet settes direkte i utdanningskvoten. Totalt antall tilbud som skal gis
    # for utdanningstilbudet beregnes automatisk som summen av utdanningskvotene.

    Scenario: Sette antall tilbud i en utdanningskvote for runden
      Når opptaksforvalter setter antall tilbud som skal gis i utdanningskvoten "Ordinær" til 150 for runden "Hovedrunde"
      Og opptaksforvalter setter antall tilbud som skal gis i utdanningskvoten "Førstegangsvitnemål" til 128 for runden "Hovedrunde"
      Så gir plasstildelingen i runden inntil 150 tilbud i utdanningskvoten "Ordinær"
      Og totalt antall tilbud som skal gis for utdanningstilbudet vises som 278

    # AVKLART 2026-10-08: Antall tilbud som skal gis gjelder bare runden det er satt for. Tallet er
    # antall nye tilbud i runden, ikke et samlet tall for opptaket. Hver runde får sine egne tall.
    # Gap mot koden («Plasstildelingsløpet i Opptak», kap. 1 og A11): koden bruker tallet som et
    # samlet tall for kvoten, og tilbud fra tidligere runder teller mot det.
    Scenariomal: Antall tilbud gjelder bare runden det er satt for
      Gitt at antall tilbud som skal gis i "Sykepleie, høst 2027" er satt slik
        | Runde            | Ordinær | Førstegangsvitnemål |
        | Hovedrunde       | 30      | 30                  |
        | Suppleringsrunde | 5       | 5                   |
        | Etterfylling     | 3       | 1                   |
      Når plasstildelingen i "<runde>" gjennomføres
      Så gir plasstildelingen inntil <ordinær> nye tilbud i utdanningskvoten "Ordinær"
      Og inntil <førstegangsvitnemål> nye tilbud i utdanningskvoten "Førstegangsvitnemål"

      Eksempler:
        | runde            | ordinær | førstegangsvitnemål |
        | Hovedrunde       | 30      | 30                  |
        | Suppleringsrunde | 5       | 5                   |
        | Etterfylling     | 3       | 1                   |

    # Gap mot koden («Plasstildelingsløpet i Opptak», kap. 1 og 3): mangler tallet, bruker koden
    # kvotens «ønsket antall deltakere» i stedet for 0. Bekreftet 2026-10-08 at kravet gjelder.
    Scenario: Default er null
      Gitt at opptaksforvalter ikke har satt antall tilbud som skal gis i utdanningskvotene for runden
      Så er antall tilbud som skal gis i hver utdanningskvote 0

  Regel: Opptaksforvalter kan filtrere utdanningstilbudene på om antall tilbud er satt

    # AVKLART 2026-10-08: Det trengs ikke varsel når antall tilbud mangler. I stedet kan listen over
    # utdanningstilbud filtreres på om utdanningskvotene har tall, for å lette arbeidet.
    Scenario: Tilgjengelige verdier i filter for antall tilbud
      Når opptaksforvalter åpner filteret for antall tilbud som skal gis
      Så kan opptaksforvalter velge mellom disse verdiene
        | Antall tilbud                             |
        | Alle utdanningstilbud                     |
        | Har antall tilbud i utdanningskvotene     |
        | Mangler antall tilbud i utdanningskvotene |
      Og "Alle utdanningstilbud" er valgt som standard

    @openquestion
    Scenariomal: Filtrere på antall tilbud
      # ÅPNE SPØRSMÅL:
      # - Et utdanningstilbud med tall i noen utdanningskvoter, men ikke i alle: hører det til «Har»,
      #   til «Mangler», eller trengs en egen verdi?
      Gitt at "Sykepleie, høst 2027" har antall tilbud som skal gis i alle utdanningskvotene for runden "Hovedrunde"
      Og at "Vernepleie, høst 2027" mangler antall tilbud som skal gis i alle utdanningskvotene for runden "Hovedrunde"
      Når opptaksforvalter velger "<filter>" som filter
      Så vises bare "<utdanningstilbud>" i listen

      Eksempler:
        | filter                                    | utdanningstilbud      |
        | Har antall tilbud i utdanningskvotene     | Sykepleie, høst 2027  |
        | Mangler antall tilbud i utdanningskvotene | Vernepleie, høst 2027 |

  Regel: Et utdanningstilbud uten antall tilbud som skal gis, gir ingen nye tilbud i runden

    # AVKLART 2026-10-08: Et utdanningstilbud ekskluderes fra en runde ved at opptaksforvalter ved
    # lærestedet ikke setter antall tilbud som skal gis for runden. Det finnes ingen egen innstilling
    # for å ekskludere, og rundetypen avgjør det ikke.
    Scenario: Utdanningstilbud uten antall tilbud i runden
      Gitt at opptaket har runden "Suppleringsrunde" med rundetype "Supplering"
      Og at det ikke er satt antall tilbud som skal gis for "Sykepleie, høst 2027" i runden "Suppleringsrunde"
      Når plasstildelingen i "Suppleringsrunde" gjennomføres
      Så får ingen søkere nye tilbud på "Sykepleie, høst 2027"
      Og søkere på venteliste får beskjed om at opptaksvedtaket er endelig

  Regel: Lærestedene kan endre antall tilbud bare innenfor perioden som er satt på runden

    # Flyttet hit fra 01 Runder 2026-10-09. Perioden settes på runden, se 01 Runder/forvalte_runder.feature.
    # Gap mot koden (verifisert 2026-10-09): perioden håndheves ikke. Alle med tilgang til å endre
    # opptaket kan endre antall tilbud når som helst.
    Scenario: Lærested kan ikke endre antall tilbud utenfor perioden
      Gitt at perioden for å endre antall tilbud som skal gis i runden "Hovedrunde" er "2027-06-01" – "2027-07-10"
      Og dagens dato er "2027-07-11"
      Så kan opptaksforvalter ved lærestedene ikke lenger endre antall tilbud som skal gis for runden

    Scenario: Opptakseier kan endre antall tilbud utenfor perioden
      Gitt at perioden for å endre antall tilbud som skal gis i runden "Hovedrunde" er "2027-06-01" – "2027-07-10"
      Og dagens dato er "2027-07-11"
      Så kan opptaksforvalter ved forvaltende organisasjon fortsatt endre antall tilbud som skal gis for runden

    Scenario: Siste lagrede tall er korrekt uavhengig av hvem som satte det
      Gitt at opptaksforvalter ved lærestedet satte antall tilbud som skal gis i utdanningskvoten "Ordinær" til 100
      Når opptaksforvalter ved forvaltende organisasjon endrer antall tilbud til 120
      Så er antall tilbud som skal gis i utdanningskvoten "Ordinær" 120

  Regel: Minst én runde må finnes før antall tilbud kan settes

    # Flyttet hit fra 01 Runder 2026-10-09.

    Scenario: Opptak uten runder
      Gitt at opptaket ikke har noen runder
      Så kan opptaksforvalter ikke sette antall tilbud som skal gis på utdanningstilbudene i opptaket

  Regel: Opptaksforvalter ser grunnlaget for å sette antall tilbud

    # AVKLART 2026-10-08: Opptaksforvalter ser tallene gjennomgående, på tvers av rundene.
    # Antall studieplasser kommer fra utdanningstilbudet.
    # AVKLART 2026-10-08: Bare antall tilbud som skal gis registreres og vises per utdanningskvote.
    # De andre tallene vises for utdanningstilbudet som helhet.
    Scenario: Se antall tilbud per utdanningskvote
      Når opptaksforvalter ser antall tilbud som skal gis for utdanningstilbudet "Sykepleie, høst 2027"
      Så ser opptaksforvalter antall tilbud som skal gis i runden for hver utdanningskvote

    Scenario: Se grunnlag for utdanningstilbudet
      Når opptaksforvalter ser antall tilbud som skal gis for utdanningstilbudet "Sykepleie, høst 2027"
      Så ser opptaksforvalter disse opplysningene for utdanningstilbudet
        | Opplysning                                 |
        | Antall studieplasser                       |
        | Totalt antall tilbud som skal gis i runden |
        | Totalt antall tilbud gitt i opptaket       |
        | Antall tilbud akseptert                    |
        | Netto tilbud                               |
        | Antall søkere på venteliste                |
        | Antall søkere med tilbudsgaranti           |

    # Antall tilbud gitt, antall aksepterte, netto tilbud og antall på venteliste oppdateres
    # etterhvert som publisering av tilbud er gjort og svar begynner å komme inn fra søkere.

    Scenario: Totalt antall tilbud gitt på tvers av runder
      Gitt at "Sykepleie, høst 2027" har gitt 60 tilbud i "Hovedrunde" og 10 tilbud i "Suppleringsrunde"
      Når opptaksforvalter ser antall tilbud som skal gis for utdanningstilbudet "Sykepleie, høst 2027"
      Så er totalt antall tilbud gitt i opptaket 70

    Scenario: Netto tilbud
      # Netto tilbud er aksepterte tilbud pluss gitte tilbud der svarfristen ikke er ute.
      Gitt at "Sykepleie, høst 2027" har gitt 70 tilbud i opptaket
      Og at 50 av tilbudene er akseptert
      Og at 8 av tilbudene ikke er besvart, og svarfristen ikke er ute
      Og at 12 av tilbudene er avslått eller ikke besvart innen svarfristen
      Når opptaksforvalter ser antall tilbud som skal gis for utdanningstilbudet "Sykepleie, høst 2027"
      Så er netto tilbud 58

  Regel: Et utdanningstilbud kan gi tilbud til alle kvalifiserte

    # Opptaksforvalter kan velge dette i stedet for å sette tall i utdanningskvotene.
    Scenario: Tilbud til alle kvalifiserte på utdanningstilbudet
      Når opptaksforvalter angir at utdanningstilbudet "Sykepleie, høst 2027" skal gi tilbud til alle kvalifiserte
      Så får alle kvalifiserte søkere tilbud uavhengig av poengsum
      Og utdanningstilbudet har ingen poenggrense

  Regel: I supplering kan antall tilbud som skal gis være negativt

    # AVKLART 2026-10-08: Har lærestedet gitt for mange tilbud i hovedrunden, kan det sette et negativt
    # tall i suppleringsrunden. Da gis det ikke kompensasjonstilbud før antall tilbud er kommet ned på
    # et bedre nivå enn først estimert. Negative tall er ikke lov i etterfylling.
    # De første plassene som frigjøres, dekker det negative tallet. Resten gis som kompensasjonstilbud.
    Scenario: Negativt antall tilbud i supplering
      Gitt at opptaket har runden "Suppleringsrunde" med rundetype "Supplering"
      Og at antall tilbud som skal gis i utdanningskvoten "Ordinær" er -5 for runden "Suppleringsrunde"
      Og at 7 tilbud i utdanningskvoten "Ordinær" er frigjort ved opprykk eller avslag
      Når plasstildelingen i "Suppleringsrunde" gjennomføres
      Så gis det 2 kompensasjonstilbud i utdanningskvoten "Ordinær"

    Scenario: Negativt antall tilbud i etterfylling
      Gitt at opptaket har runden "Etterfylling" med rundetype "Etterfylling"
      Når opptaksforvalter setter antall tilbud som skal gis i utdanningskvoten "Ordinær" til -3 for runden "Etterfylling"
      Så blir antall tilbud ikke lagret
      Og opptaksforvalter får beskjed om at antall tilbud ikke kan være negativt i etterfylling

  @openquestion
  Regel: I etterfylling gis nøyaktig det antallet tilbud som er satt

    # ÅPNE SPØRSMÅL:
    # - Kommer fra Confluence «Samordnet plasstildeling» (mai 2026), ikke bekreftet i design.md.
    #   Stemmer det at lærestedet selv må regne inn forventet frafall i etterfylling?
    Scenario: Etterfylling gir det antallet tilbud som er satt
      Gitt at opptaket har runden "Etterfylling" med rundetype "Etterfylling"
      Når opptaksforvalter setter antall tilbud som skal gis i utdanningskvoten "Ordinær" til 10 for runden "Etterfylling"
      Så gir plasstildelingen 10 nye tilbud i utdanningskvoten "Ordinær"
      Og plasstildelingen kompenserer ikke for frafall

# AVKLARTE SPØRSMÅL (raffinering 2026-10-07):
# - Opptaksforvalter ved forvaltende organisasjon kan endre antall tilbud også utenfor
#   lærestedenes periode. Se 01 Runder/forvalte_runder.feature.
# - Siste lagrede tall er korrekt uavhengig av hvem som satte det.
# - Standard plassflyt for opptaket er en opptaksinnstilling, men løses som del av
#   arbeidet med å lage plasstildelingen. Gjenåpnet 2026-10-08: om plassflyten settes på opptaket
#   eller per utdanningstilbud er uavklart, se 02 Tildelingsinnstillinger/plassflyt.feature.
# - Antall tilbud som skal gis settes direkte per utdanningskvote.
#   Totalt antall tilbud er utledet (summen av utdanningskvotene), ikke satt eksplisitt.
# - Default i utdanningskvotene er null. Endret 2026-10-08: ikke varsel, men filter på
#   utdanningstilbud som har eller mangler antall tilbud.
# - Avklart 2026-10-08: Antall tilbud som skal gis gjelder bare runden det er satt for, og er
#   antall nye tilbud i runden. Hver runde får egne tall.
# - Avklart 2026-10-08: Antall tilbud settes som hele tall per utdanningskvote. Det utledes ikke fra
#   standard kvotefordeling, så det trengs ingen avrunding.
# - Avklart 2026-10-08: Negative tall er lov i supplering, ikke i etterfylling.
