# language: no
# GitHub: #216
@OPT-PLA-RUN-001 @must @draft
Egenskap: Legge til runder for plasstildeling i et opptak
  Som opptaksforvalter
  ønsker jeg å legge til runder for plasstildeling i et opptak
  slik at studieplasser kan fordeles i flere omganger med riktige regler for hver runde.

  # Kilde: tasks/opptak/plasstildeling/design.md (oppgave 1) og Confluence
  # «2026-09-08 Raffinering plasstildeling», «Opprette og konfigurere opptakskjøringsrunde»
  # og raffinering 2026-10-07.
  # Opptaksforvalter ved forvaltende organisasjon legger til runder. I samordna opptak er det
  # Samordna opptak (HK-dir). I lokale opptak er lærestedet den eneste organisasjonen og forvalter selv.
  # En runde er vinduet der plasser fordeles. Plasstildelingen er beregningen som gjøres i runden,
  # og én runde kan ha mange plasstildelinger (se 03 Tildeling).

  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet

  Regel: Opptaksforvalter legger til en runde med navn, rundetype og svarfrist

    Scenario: Legge til første runde
      Når opptaksforvalter legger til runden "Hovedrunde" med rundetype "Hovedtildeling" og svarfrist "2027-07-20 23:59"
      Så har opptaket runden "Hovedrunde"
      Og søkere som får tilbud i runden må svare innen "2027-07-20 23:59"

    Scenario: Legge til en etterfølgende runde
      Gitt at opptaket har runden "Hovedrunde" med rundetype "Hovedtildeling"
      Når opptaksforvalter legger til runden "Suppleringsrunde" med rundetype "Supplering" og svarfrist "2027-08-10 23:59"
      Så har opptaket runden "Suppleringsrunde"
      Og søkere som får tilbud i runden må svare innen "2027-08-10 23:59"

    Scenariomal: Runde mangler obligatorisk opplysning
      Når opptaksforvalter legger til en runde uten <opplysning>
      Så blir runden ikke lagt til
      Og opptaksforvalter får beskjed om at <opplysning> mangler

      Eksempler:
        | opplysning |
        | navn       |
        | rundetype  |
        | svarfrist  |

    Scenario: Sette påminnelse om svarfrist
      Gitt at runden "Hovedrunde" har svarfrist "2027-07-20 23:59"
      Når opptaksforvalter setter påminnelse om svarfrist til "2027-07-18"
      Så får søkere med ubesvart tilbud i runden en påminnelse "2027-07-18"

  Regel: Et opptak har én hovedtildeling, men kan ha flere runder av andre typer

    Scenario: Tilgjengelige rundetyper
      Når opptaksforvalter legger til en runde
      Så kan opptaksforvalter velge mellom disse rundetypene
        | Rundetype        |
        | Hovedtildeling   |
        | Supplering       |
        | Etterfylling     |

    # AVKLART 2026-10-07: Ledige studieplasser er en egenskap ved etterfylling,
    # ikke en egen rundetype. En etterfyllingsrunde kan åpne for nye søknader
    # på ledige plasser (se 03 Tildeling/gjennomføre_plasstildeling.feature).

    Scenario: Hovedtildeling kan bare finnes én gang
      Gitt at opptaket har runden "Hovedrunde" med rundetype "Hovedtildeling"
      Når opptaksforvalter legger til en ny runde med rundetype "Hovedtildeling"
      Så blir runden ikke lagt til
      Og opptaksforvalter får beskjed om at opptaket allerede har en hovedtildeling

    Scenario: Flere runder av samme type etter hovedtildelingen
      Gitt at opptaket har runden "Hovedrunde" med rundetype "Hovedtildeling"
      Og at opptaket har runden "Suppleringsrunde 1" med rundetype "Supplering"
      Når opptaksforvalter legger til runden "Suppleringsrunde 2" med rundetype "Supplering" og svarfrist "2027-09-01 23:59"
      Så har opptaket to runder med rundetype "Supplering"

    Scenario: Kjøre plasstildeling flere ganger i samme runde
      Gitt at runden "Hovedrunde" har en plasstildeling som ikke er publisert
      Når opptaksforvalter starter en ny plasstildeling i runden "Hovedrunde"
      Så har runden to plasstildelinger
      Og opptaket har fortsatt bare én runde med rundetype "Hovedtildeling"

    Scenario: Hovedtildeling er første runde i opptaket
      Gitt at opptaket ikke har noen runder
      Når opptaksforvalter legger til runder i opptaket
      Så er den første runden av rundetype "Hovedtildeling"

    Scenario: Valgfri rekkefølge på rundetyper etter hovedtildelingen
      Gitt at opptaket har runden "Hovedrunde" med rundetype "Hovedtildeling"
      Når opptaksforvalter legger til runden "Etterfylling" med rundetype "Etterfylling"
      Så kan etterfyllingsrunden komme før en eventuell suppleringsrunde

  Regel: Navn og svarfrist kan alltid endres

    Scenario: Endre navn og svarfrist på en runde
      Gitt at opptaket har runden "Hovedrunde" med rundetype "Hovedtildeling"
      Når opptaksforvalter endrer navnet på runden til "Hovedtildeling 2027"
      Og opptaksforvalter endrer svarfristen til "2027-07-25 23:59"
      Så heter runden "Hovedtildeling 2027"
      Og søkere som får tilbud i runden må svare innen "2027-07-25 23:59"

  Regel: Rundetypen kan ikke endres etter at runden er lagt til

    # Rundetypen er en del av det som identifiserer runden. Feil rundetype rettes ved å
    # slette runden og legge den til på nytt.
    Scenario: Endre rundetype på eksisterende runde
      Gitt at opptaket har runden "Hovedrunde" med rundetype "Hovedtildeling"
      Når opptaksforvalter endrer runden "Hovedrunde"
      Så kan opptaksforvalter endre navn og svarfrist
      Men rundetypen kan ikke endres

  Regel: En runde kan slettes så lenge den ikke er publisert til søker

    Scenario: Slette en runde som ikke er publisert
      Gitt at opptaket har runden "Suppleringsrunde" med rundetype "Supplering"
      Og at runden ikke er publisert til søker
      Når opptaksforvalter sletter runden "Suppleringsrunde"
      Så har opptaket ikke lenger runden "Suppleringsrunde"

    Scenario: Kan ikke slette en runde som er publisert til søker
      Gitt at opptaket har runden "Hovedrunde" med rundetype "Hovedtildeling"
      Og at runden er publisert til søker
      Når opptaksforvalter forsøker å slette runden "Hovedrunde"
      Så blir runden ikke slettet
      Og opptaksforvalter får beskjed om at en publisert runde ikke kan slettes

  Regel: Opptaksforvalter ser status på runden

    Scenario: Runde som ikke er publisert
      Gitt at opptaket har runden "Hovedrunde" med rundetype "Hovedtildeling"
      Og at runden ikke er publisert til søker
      Så ser opptaksforvalter at runden har status "Ikke publisert"

    Scenario: Runde som er publisert
      Gitt at opptaket har runden "Hovedrunde" med rundetype "Hovedtildeling"
      Og at runden er publisert til søker
      Så ser opptaksforvalter at runden har status "Publisert"

  Regel: Rundetypen styrer hvordan plasstildelingen i runden oppfører seg

    # Selve oppførselen beskrives i 03 Tildeling. Her beskrives bare hva rundetypen innebærer.
    # AVKLART 2026-10-08: Kravet gjelder. Rundetypen skal styre oppførselen.
    # Gap mot koden («Plasstildelingsløpet i Opptak», kap. 2): ingen logikk skiller på rundetype i dag.
    # Om en kjøring bygger på en tidligere runde, avgjøres av om opptaket har en publisert runde fra før.
    # Bortfall gis alltid, og en søker får høyst ett ordinært tilbud. Etterfylling må bygges.
    # Kodeverket har rundetypene TIDLIG og LEDIGE_STUDIEPLASSER, som ikke er rundetyper i kravet.
    Scenariomal: Regler som følger av rundetypen
      Gitt at runden har rundetype "<rundetype>"
      Så gjelder disse reglene for plasstildelingen i runden
        | Regel                                                    | Verdi           |
        | Søker som får tilbud mister lavere prioriteter           | <bortfall>      |
        | Frigjort plass ved opprykk gis til neste på ventelisten  | <kompensasjonstilbud>  |
        | Søker kan ha flere tilbud samtidig     | <flere_tilbud>  |
        | Bygger på forrige publiserte runde     | <arv>           |
        | Utdanningstilbud kan ekskluderes       | <ekskludering>  |
        | Rangering                              | <rangering>     |

      Eksempler:
        | rundetype        | bortfall | kompensasjonstilbud | flere_tilbud     | arv | ekskludering | rangering          |
        | Hovedtildeling   | ja       | nei                 | nei              | nei | nei          | poeng og rangering |
        | Supplering       | ja       | ja                  | nei              | ja  | ja           | poeng og rangering |
        | Etterfylling     | nei      | nei                 | ja, må velge ett | ja  | ja           | poeng og rangering |

  Regel: Opptaksforvalter setter periode for når lærestedene kan endre antall tilbud som skal gis

    # Antall tilbud som skal gis (i databasen: opptaksparametere) settes per utdanningskvote
    # per runde, se 02 Tildelingsinnstillinger/antall_tilbud_som_skal_gis.feature.
    # Her settes vinduet: startdato og sluttdato for når lærestedene kan endre tallet.

    Scenario: Sette periode for å endre antall tilbud som skal gis
      Når opptaksforvalter setter perioden for å endre antall tilbud som skal gis i runden "Hovedrunde" til "2027-06-01" – "2027-07-10"
      Så kan opptaksforvalter ved lærestedene endre antall tilbud som skal gis for runden fra "2027-06-01" til "2027-07-10"

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

  Regel: Opptakets informasjonsdatoer for publisering påvirker ikke runden

    # Fristene for når resultatet i hovedrunden kan forventes publisert, som settes i
    # 11 Opptak/04 Frister/frister_og_hendelser.feature, er ren informasjon til søker.
    # Opptaksforvalter setter ingen eksplisitt publiseringsdato på runden.
    # Publiseringsdato styres av når publiseringen faktisk finner sted.

    Scenario: Runden har ingen eksplisitt publiseringsdato
      Gitt at opptaket har runden "Hovedrunde" med rundetype "Hovedtildeling"
      Når opptaksforvalter ser på runden "Hovedrunde"
      Så har runden ingen publiseringsdato
      Og runden publiseres når opptaksforvalter velger å publisere resultatet

  Regel: Minst én runde må finnes før plasstildelingen kan forberedes

    Scenario: Opptak uten runder
      Gitt at opptaket ikke har noen runder
      Så kan opptaksforvalter ikke sette antall tilbud som skal gis på utdanningstilbudene i opptaket

# AVKLARTE SPØRSMÅL (raffinering 2026-10-07):
# - Ledige studieplasser er en egenskap ved etterfylling, ikke en egen rundetype.
# - Runder kan slettes så lenge de ikke er publisert til søker.
# - Navn og svarfrist kan alltid endres.
# - Opptaksforvalter setter ingen eksplisitt publiseringsdato. Publisering skjer når den skjer.
# - Opptaksforvalter ved forvaltende organisasjon kan endre antall tilbud utenfor lærestedenes periode.
# - Tidligopptak er ikke en rundetype (avklart tidligere).