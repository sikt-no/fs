# language: no
# GitHub: #583
@OPT-PLA-INN-001 @must @draft @scope-plasstildeling-2027
Egenskap: Antall tilbud som skal gis per utdanningskvote (sette opptaksparametere)
  Som opptaksforvalter
  ønsker jeg å bestemme hvor mange tilbud som skal gis i hver utdanningskvote i en plasstildelingsrunde
  slik at plasstildelingen fyller studieplassene uten å gi for mange eller for få tilbud.

  # Kilde: tasks/opptak/plasstildeling/oppgave.md (oppgave 2), design.md (begrepsforklaringer),
  # Confluence «2026-09-08 Raffinering plasstildeling» (oppgave 2) og raffinering 2026-10-07.
  # Antall tilbud som skal gis settes per utdanningskvote, og er et samlet tall for opptaket (endret 2026-10-30).
  # Opptaksforvalter ved lærestedet setter tallene for egne utdanningstilbud innenfor perioden
  # som er satt på plasstildelingsrunden (se 01 Runder/forvalte_runder.feature).
  # Opptakets forvalter kan endre tallene også utenfor perioden.
  # Begrep (avklart 2026-10-08): «antall tilbud som skal gis». «Måltall» og «antall ønsket ja-svar» brukes ikke.
  # Endret 2026-10-30 (produkteier): «Kvoteplasser» er studieplassene i en utdanningskvote, satt på utdanningstilbudet
  # (12 Utdanningstilbud/03 Opptaksinnstillinger/sette_antall_studieplasser_per_kvote.feature). Det er måltallet HK-dir
  # snakker om. «Overbooking» er antall tilbud som skal gis minus kvoteplassene, og er ikke noe som settes.
  # Brukerne kaller i dag handlingen å «sette opptaksparametere». Det ordet skjuler at det bare er
  # én ting som settes, nemlig antall tilbud som skal gis. Det står derfor bare i parentes i tittelen
  # og i denne kommentaren, og brukes ikke i scenarioene.
  # Søk, sortering, varsel ved overskridelse og opptakets forvalters kontroll står i kontrollere_antall_tilbud.feature
  # (@should). Varselet til lærestedene når perioden åpner, står i 05 Svar/varsler_og_meldinger_i_plasstildelingen.feature.
  # AVKLART 2026-10-28 (produkteier, spørsmål fra brukertesten med HK-dir 2026-10-27): Også antall tilbud som skal
  # gis i hovedtildelingen settes i perioden for å endre antall tilbud på plasstildelingsrunden. Det hentes ikke
  # fra utdanningstilbudet, som bare har studieplassene og kvoteplassene (12 Utdanningstilbud/03 Opptaksinnstillinger).

  Bakgrunn:
    Gitt at opptaksforvalter ved lærestedet er innlogget
    Og at opptaket "Samordna opptak 2027" har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"
    Og at utdanningstilbudet "Sykepleie, høst 2027" har utdanningskvotene "Førstegangsvitnemål" og "Ordinær"

  Regel: Opptaksforvalter setter antall tilbud som skal gis per utdanningskvote

    # Opptaksforvalter slår opp siden for å sette antall tilbud som skal gis og ser
    # en liste over utdanningstilbud med sine utdanningskvoter.
    # Tallet settes direkte i utdanningskvoten. Totalt antall tilbud som skal gis
    # for utdanningstilbudet beregnes automatisk som summen av utdanningskvotene.

    Scenario: Sette antall tilbud i en utdanningskvote for plasstildelingsrunden
      Når opptaksforvalter setter antall tilbud som skal gis i utdanningskvoten "Ordinær" til 150 for plasstildelingsrunden "Hovedrunde"
      Og opptaksforvalter setter antall tilbud som skal gis i utdanningskvoten "Førstegangsvitnemål" til 128 for plasstildelingsrunden "Hovedrunde"
      Så gir plasstildelingen inntil 150 tilbud i utdanningskvoten "Ordinær"
      Og totalt antall tilbud som skal gis for utdanningstilbudet vises som 278

  Regel: Antall tilbud som skal gis er et samlet tall for opptaket, og følger med til neste plasstildelingsrunde

    # AVKLART 2026-10-30 (produkteier, HK-10158 og brukertesten med HK-dir, oktober 2026): Erstatter avklaringen fra
    # 2026-10-08 om at tallet bare gjaldt plasstildelingsrunden det var satt for. Tallet er hvor mange tilbud
    # utdanningskvoten skal gi i opptaket. En plasstildelingsrunde gir det som gjenstår: antall tilbud som skal gis
    # minus tilbudene som er gitt i tidligere plasstildelingsrunder. Trenger ikke lærestedet å gi flere tilbud
    # senere, legges det ikke inn nye tall i neste plasstildelingsrunde. Koden gjør det slik («Plasstildelingsløpet
    # i Opptak», kap. 1 og A11).
    Scenario: Plasstildelingsrunden gir det som gjenstår av antall tilbud som skal gis
      Gitt at antall tilbud som skal gis i utdanningskvoten "Ordinær" er 50
      Og at plasstildelingen i "Hovedrunde" har gitt 30 tilbud i utdanningskvoten "Ordinær"
      Og at opptaket har plasstildelingsrunden "Suppleringsrunde" med rundetype "Supplering"
      Og at opptaksforvalter ikke har endret antall tilbud som skal gis i utdanningskvoten "Ordinær"
      Når plasstildelingen i "Suppleringsrunde" gjennomføres
      Så gir plasstildelingen inntil 20 nye tilbud i utdanningskvoten "Ordinær"

    Scenario: Lærestedet øker antall tilbud som skal gis før neste plasstildelingsrunde
      Gitt at antall tilbud som skal gis i utdanningskvoten "Ordinær" er 50
      Og at plasstildelingen i "Hovedrunde" har gitt 50 tilbud i utdanningskvoten "Ordinær"
      Og at opptaket har plasstildelingsrunden "Suppleringsrunde" med rundetype "Supplering"
      Når opptaksforvalter ved lærestedet endrer antall tilbud som skal gis i utdanningskvoten "Ordinær" til 60 i perioden for "Suppleringsrunde"
      Og plasstildelingen i "Suppleringsrunde" gjennomføres
      Så gir plasstildelingen inntil 10 nye tilbud i utdanningskvoten "Ordinær"

    # Gap mot koden («Plasstildelingsløpet i Opptak», kap. 1 og 3): mangler tallet, bruker koden
    # kvotens «ønsket antall deltakere» (kvoteplassene) i stedet for 0. Bekreftet 2026-10-08 at kravet gjelder.
    Scenario: Default er null
      Gitt at opptaksforvalter ikke har satt antall tilbud som skal gis i utdanningskvotene
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

    # AVKLART 2026-10-28 (produkteier, etter brukertesten med HK-dir 2026-10-27): Et utdanningstilbud der minst én
    # utdanningskvote mangler tall, hører til «Mangler antall tilbud i utdanningskvotene».
    Scenariomal: Filtrere på antall tilbud
      Gitt at "Sykepleie, høst 2027" har antall tilbud som skal gis i alle utdanningskvotene for plasstildelingsrunden "Hovedrunde"
      Og at "Vernepleie, høst 2027" mangler antall tilbud som skal gis i alle utdanningskvotene for plasstildelingsrunden "Hovedrunde"
      Og at "Barnevern, høst 2027" mangler antall tilbud som skal gis i én av utdanningskvotene for plasstildelingsrunden "Hovedrunde"
      Når opptaksforvalter velger "<filter>" som filter
      Så vises bare <utdanningstilbud> i listen

      Eksempler:
        | filter                                    | utdanningstilbud                                   |
        | Har antall tilbud i utdanningskvotene     | "Sykepleie, høst 2027"                             |
        | Mangler antall tilbud i utdanningskvotene | "Vernepleie, høst 2027" og "Barnevern, høst 2027"  |

  Regel: Et utdanningstilbud gir ingen nye tilbud når alle tilbudene som skal gis, er gitt

    # AVKLART 2026-10-08: Det finnes ingen egen innstilling for å holde et utdanningstilbud utenfor en
    # plasstildelingsrunde, og rundetypen avgjør det ikke.
    # AVKLART 2026-10-30 (produkteier): Antall tilbud følger med til neste plasstildelingsrunde. Lærestedet holder et
    # utdanningstilbud utenfor en senere runde ved å sette antall tilbud som skal gis ned til antall tilbud som er gitt.
    Scenario: Utdanningstilbud uten flere tilbud å gi i plasstildelingsrunden
      Gitt at opptaket har plasstildelingsrunden "Suppleringsrunde" med rundetype "Supplering"
      Og at plasstildelingen i "Hovedrunde" har gitt 50 tilbud i utdanningskvoten "Ordinær" på "Sykepleie, høst 2027"
      Og at antall tilbud som skal gis i utdanningskvoten "Ordinær" på "Sykepleie, høst 2027" er 50
      Når plasstildelingen i "Suppleringsrunde" gjennomføres
      Så får ingen søkere nye tilbud i utdanningskvoten "Ordinær" på "Sykepleie, høst 2027"
      Og søkere på venteliste i utdanningskvoten "Ordinær" får beskjed om at opptaksvedtaket er endelig

  Regel: Lærestedene kan endre antall tilbud bare innenfor perioden som er satt på plasstildelingsrunden

    # Flyttet hit fra 01 Runder 2026-10-09. Perioden settes på plasstildelingsrunden, se 01 Runder/forvalte_runder.feature.
    # AVKLART 2026-10-15 (domeneekspert): Perioden gjelder også tilbud til alle kvalifiserte, men ikke
    # saksbehandlingen. Etter perioden melder lærestedene feil til opptakets forvalter på e-post.
    # AVKLART 2026-10-28 (produkteier, etter brukertesten med HK-dir): Opptakets forvalter åpner ikke for endring for
    # ett lærested etter perioden. Forvalteren endrer tallene selv, eller utvider perioden for alle.
    # Gap mot koden (verifisert 2026-10-09): perioden håndheves ikke. Alle med tilgang til å endre
    # opptaket kan endre antall tilbud når som helst.
    Scenario: Lærested kan ikke endre antall tilbud utenfor perioden
      Gitt at perioden for å endre antall tilbud som skal gis i plasstildelingsrunden "Hovedrunde" er "2027-06-01 08:00" – "2027-07-10 16:00"
      Og klokka er "2027-07-10 16:01"
      Så kan opptaksforvalter ved lærestedene ikke lenger endre antall tilbud som skal gis for plasstildelingsrunden

    Scenario: Opptakets forvalter kan endre antall tilbud utenfor perioden
      Gitt at perioden for å endre antall tilbud som skal gis i plasstildelingsrunden "Hovedrunde" er "2027-06-01 08:00" – "2027-07-10 16:00"
      Og klokka er "2027-07-10 16:01"
      Så kan opptakets forvalter fortsatt endre antall tilbud som skal gis for plasstildelingsrunden

    # AVKLART 2026-10-16 (produktleder): Perioden virker som en åpningsdato. Er den ikke satt, holder den stengt.
    Scenario: Lærested kan ikke sette antall tilbud når perioden ikke er satt
      Gitt at det ikke er satt periode for å endre antall tilbud som skal gis i plasstildelingsrunden "Hovedrunde"
      Så kan opptaksforvalter ved lærestedene ikke legge inn antall tilbud som skal gis for plasstildelingsrunden

    Scenario: Siste lagrede tall er korrekt uavhengig av hvem som satte det
      Gitt at opptaksforvalter ved lærestedet satte antall tilbud som skal gis i utdanningskvoten "Ordinær" til 100
      Når opptakets forvalter endrer antall tilbud til 120
      Så er antall tilbud som skal gis i utdanningskvoten "Ordinær" 120

  Regel: Antall tilbud kan ikke endres når plasstildelingsrunden er publisert

    # AVKLART 2026-10-14 (designarbeidet i FS-Admin): Svarbrevene er sendt. For å gi flere tilbud må
    # opptaksforvalter legge til en ny plasstildelingsrunde.
    Scenario: Antall tilbud låses når plasstildelingsrunden er publisert
      Gitt at plasstildelingsrunden "Hovedrunde" er publisert
      Når opptakets forvalter ser antall tilbud som skal gis i "Hovedrunde"
      Så kan opptaksforvalter ikke endre antall tilbud som skal gis i "Hovedrunde"

  Regel: Minst én plasstildelingsrunde må finnes før antall tilbud kan settes

    # Flyttet hit fra 01 Runder 2026-10-09.

    Scenario: Opptak uten plasstildelingsrunder
      Gitt at opptaket ikke har noen plasstildelingsrunder
      Så kan opptaksforvalter ikke sette antall tilbud som skal gis på utdanningstilbudene i opptaket

  Regel: Opptaksforvalter ser grunnlaget for å sette antall tilbud

    # AVKLART 2026-10-08: Opptaksforvalter ser tallene gjennomgående, på tvers av plasstildelingsrundene.
    # Antall studieplasser og kvoteplassene kommer fra utdanningstilbudet.
    # Endret 2026-10-30 (produkteier): Kvoteplassene og overbookingen vises per utdanningskvote, ved siden av antall
    # tilbud som skal gis, så lærestedet ser dem når tallet registreres. De andre tallene vises for utdanningstilbudet
    # som helhet.
    Scenario: Se antall tilbud per utdanningskvote
      Når opptaksforvalter ser antall tilbud som skal gis for utdanningstilbudet "Sykepleie, høst 2027"
      Så ser opptaksforvalter disse opplysningene for hver utdanningskvote
        | Opplysning                 |
        | Kvoteplasser               |
        | Antall tilbud som skal gis |
        | Overbooking                |

    Scenario: Overbooking i en utdanningskvote
      Gitt at utdanningstilbudet "Bachelor i klassiske språk, høst 2028" har 30 studieplasser
      Og at utdanningskvoten "Ordinær kvote (ORD)" har 15 kvoteplasser
      Og at utdanningskvoten "Førstegangsvitnemål (ORDF)" har 15 kvoteplasser
      Når opptaksforvalter ved lærestedet setter antall tilbud som skal gis i utdanningskvoten "Ordinær kvote (ORD)" til 50
      Så er overbookingen i utdanningskvoten "Ordinær kvote (ORD)" 35

    Scenario: Se grunnlag for utdanningstilbudet
      Når opptaksforvalter ser antall tilbud som skal gis for utdanningstilbudet "Sykepleie, høst 2027"
      Så ser opptaksforvalter disse opplysningene for utdanningstilbudet
        | Opplysning                                 |
        | Antall studieplasser                       |
        | Totalt antall tilbud som skal gis          |
        | Totalt antall tilbud gitt i opptaket       |
        | Antall tilbud akseptert                    |
        | Antall tilbud som venter på svar           |
        | Netto tilbud                               |
        | Ledige plasser å gi tilbud til             |
        | Antall søkere på venteliste                |
        | Antall søkere med tilbudsgaranti           |
        | Antall tilbudsgarantier som har gitt tilbud |

    # Antall tilbud gitt, antall aksepterte, netto tilbud og antall på venteliste oppdateres
    # etterhvert som publisering av tilbud er gjort og svar begynner å komme inn fra søkere.

    Scenario: Totalt antall tilbud gitt på tvers av plasstildelingsrunder
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

    # AVKLART 2026-10-14 (designarbeidet i FS-Admin): Ledige plasser å gi tilbud til er en avledet verdi:
    # studieplasser minus netto tilbud (akseptert og venter på svar).
    # AVKLART 2026-10-30 (produkteier, åpne spørsmål fra designarbeidet nr. 7): Søkere med tilbudsgaranti som ikke har
    # fått tilbud ennå, trekkes også fra, fordi de skal ha plass.
    Scenario: Ledige plasser å gi tilbud til
      Gitt at "Sykepleie, høst 2027" har 100 studieplasser
      Og at netto tilbud for "Sykepleie, høst 2027" er 58
      Og at 4 søkere med tilbudsgaranti på "Sykepleie, høst 2027" ikke har fått tilbud ennå
      Når opptaksforvalter ser antall tilbud som skal gis for utdanningstilbudet "Sykepleie, høst 2027"
      Så er ledige plasser å gi tilbud til 38

  Regel: Et utdanningstilbud kan gi tilbud til alle kvalifiserte

    # Opptaksforvalter kan velge dette i stedet for å sette tall i utdanningskvotene.
    Scenario: Tilbud til alle kvalifiserte på utdanningstilbudet
      Når opptaksforvalter angir at utdanningstilbudet "Sykepleie, høst 2027" skal gi tilbud til alle kvalifiserte
      Så får alle kvalifiserte søkere tilbud uavhengig av poengsum
      Og utdanningstilbudet har ingen poenggrense

  @depends-on-OPT-REG-RUN-001 @openquestion
  Regel: Antall tilbud kan være negativt når rundetypen har kompensasjonstilbud ved opprykk

    # ÅPNE SPØRSMÅL:
    # - Regelen er skrevet for ett tall per plasstildelingsrunde. Når antall tilbud er et samlet tall for opptaket
    #   (endret 2026-10-30), retter lærestedet opp for mange tilbud ved å sette tallet lavere enn antall tilbud som er
    #   gitt. Trengs negative tall fortsatt, eller skal regelen skrives om til det?
    # - Kanskje trengs det heller en måte for lærestedet å markere at det ikke ønsker å gi nye tilbud
    #   (produkteier 2026-10-30). Henger sammen med regelen «Et utdanningstilbud gir ingen nye tilbud når alle
    #   tilbudene som skal gis, er gitt».
    # - Et alternativ er at lærestedet setter antall tilbud som skal gis til 0 for å ikke gi flere tilbud, og at
    #   endringen logges, så lærestedet kan se hva tallet var før (produkteier 2026-10-30). Ulempen er at det samlede
    #   tallet og overbookingen da ikke lenger viser det som gjelder for opptaket.

    # Endret 2026-10-24: Et negativt tall stopper kompensasjonstilbudene til lærestedet er nede på riktig nivå,
    # og har bare en virkning når rundetypen har kompensasjonstilbud ved opprykk. I samordna opptak er det Supplering.
    # AVKLART 2026-10-08: Har lærestedet gitt for mange tilbud i hovedrunden, kan det sette et negativt
    # tall i suppleringsrunden. Da gis det ikke kompensasjonstilbud før antall tilbud er kommet ned på
    # et bedre nivå enn først estimert. Negative tall er ikke lov i hovedtildeling eller etterfylling.
    # De første plassene som frigjøres, dekker det negative tallet. Resten gis som kompensasjonstilbud.
    Scenario: Negativt antall tilbud med kompensasjonstilbud
      Gitt at opptaket har plasstildelingsrunden "Suppleringsrunde" med rundetype "Supplering"
      Og at rundetypen "Supplering" har innstillingen "Kompensasjonstilbud ved opprykk"
      Og at antall tilbud som skal gis i utdanningskvoten "Ordinær" er -5 for plasstildelingsrunden "Suppleringsrunde"
      Og at 7 tilbud i utdanningskvoten "Ordinær" er frigjort ved opprykk eller avslag
      Når plasstildelingen i "Suppleringsrunde" gjennomføres
      Så gis det 2 kompensasjonstilbud i utdanningskvoten "Ordinær"

    # AVKLART 2026-10-14: Negative tall er heller ikke lov i hovedtildeling. Der finnes ingen tidligere
    # plasstildelingsrunde med for mange tilbud å rette opp.
    Scenariomal: Negativt antall tilbud uten kompensasjonstilbud
      Gitt at rundetypen "<rundetype>" ikke har innstillingen "Kompensasjonstilbud ved opprykk"
      Og at opptaket har plasstildelingsrunden "<plasstildelingsrunde>" med rundetype "<rundetype>"
      Når opptaksforvalter setter antall tilbud som skal gis i utdanningskvoten "Ordinær" til -3 for plasstildelingsrunden "<plasstildelingsrunde>"
      Så blir antall tilbud ikke lagret
      Og opptaksforvalter får beskjed om at antall tilbud bare kan være negativt når plasstildelingsrunden har kompensasjonstilbud ved opprykk

      Eksempler:
        | plasstildelingsrunde | rundetype      |
        | Hovedrunde           | Hovedtildeling |
        | Etterfylling         | Etterfylling   |

  @depends-on-OPT-REG-RUN-001
  Regel: Uten kompensasjonstilbud ved opprykk gis nøyaktig det som gjenstår av antall tilbud som skal gis

    # Kilde: Confluence «Samordnet plasstildeling» (mai 2026).
    # AVKLART 2026-10-30 (produkteier): Plasstildelingen kompenserer ikke for frafall i en plasstildelingsrunde uten
    # kompensasjonstilbud ved opprykk, og lærestedet regner selv inn forventet frafall når antall tilbud settes.
    # Det følger av innstillingene i rundetypen, og trenger ingen egen innstilling. I samordna opptak er det Etterfylling.
    Scenario: Etterfylling gir det som gjenstår av antall tilbud som skal gis
      Gitt at opptaket har plasstildelingsrunden "Etterfylling" med rundetype "Etterfylling"
      Og at rundetypen "Etterfylling" ikke har innstillingen "Kompensasjonstilbud ved opprykk"
      Og at antall tilbud som skal gis i utdanningskvoten "Ordinær" er 60
      Og at tidligere plasstildelingsrunder har gitt 50 tilbud i utdanningskvoten "Ordinær"
      Når plasstildelingen i "Etterfylling" gjennomføres
      Så gir plasstildelingen 10 nye tilbud i utdanningskvoten "Ordinær"
      Og plasstildelingen kompenserer ikke for frafall

# AVKLARTE SPØRSMÅL (raffinering 2026-10-07):
# - Opptakets forvalter kan endre antall tilbud også utenfor
#   lærestedenes periode. Se 01 Runder/forvalte_runder.feature.
# - Siste lagrede tall er korrekt uavhengig av hvem som satte det.
# - Standard plassflyt er en del av regelverket. Avklart 2026-10-21: standard plassflyt settes i
#   regelverkssamlingen og gjelder alle utdanningskvoter, se 10 Regelverk/04 Kvoter/sette_plassflyt.feature.
# - Antall tilbud som skal gis settes direkte per utdanningskvote.
#   Totalt antall tilbud er utledet (summen av utdanningskvotene), ikke satt eksplisitt.
# - Default i utdanningskvotene er null. Endret 2026-10-08: ikke varsel, men filter på
#   utdanningstilbud som har eller mangler antall tilbud.
# - Avklart 2026-10-08: Antall tilbud som skal gis gjelder bare plasstildelingsrunden det er satt for.
#   Endret 2026-10-30: tallet er et samlet tall for opptaket, og følger med til neste plasstildelingsrunde.
# - Avklart 2026-10-08: Antall tilbud settes som hele tall per utdanningskvote. Det utledes ikke fra
#   standard kvotefordeling, så det trengs ingen avrunding.
# - Avklart 2026-10-08: Negative tall er lov i supplering, ikke i etterfylling. Avklart 2026-10-14: heller ikke i hovedtildeling.
