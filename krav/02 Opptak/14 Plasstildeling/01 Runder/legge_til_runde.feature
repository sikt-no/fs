# language: no
# GitHub: #216
@OPT-PLA-RUN-001 @must @draft
Egenskap: Legge til runder for plasstildeling i et opptak
  Som opptaksforvalter
  ønsker jeg å legge til runder for plasstildeling i et opptak
  slik at studieplasser kan fordeles i flere omganger med riktige regler for hver runde.

  # Kilde: tasks/opptak/plasstildeling/design.md (oppgave 1) og Confluence
  # «2026-09-08 Raffinering plasstildeling» og «Opprette og konfigurere opptakskjøringsrunde».
  # Opptaksforvalter ved forvaltende organisasjon legger til runder. I samordna opptak er det
  # Samordna opptak (HK-dir). I lokale opptak er lærestedet den eneste organisasjonen og forvalter selv.
  # En runde er vinduet der plasser fordeles. Plasstildelingen er beregningen som gjøres i runden,
  # og én runde kan ha mange plasstildelinger (se 03 Tildeling).

  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet

  Regel: Første runde arver publiseringsdato og svarfrist fra opptakets frister

    # Første runde er hovedtildelingen. Datoene for publisering og svarfrist er
    # satt blant fristene i opptaket (se 11 Opptak/04 Frister/frister_og_hendelser.feature),
    # fordi de er kommunisert til søker. Runden arver dem, og de endres bare i opptakets frister.
    # Etterfølgende runder har egne datoer (se regelen under).

  Regel: Opptaksforvalter legger til en runde med navn, rundetype og svarfrist

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

    Scenario: Legge til første runde
      Gitt at opptaksforvalter har satt dato for når hovedopptaket publiseres til "2027-07-15"
      Og at opptaksforvalter har satt første svarfrist til "2027-07-20 23:59"
      Når opptaksforvalter legger til runden "Hovedrunde" med rundetype "Hovedtildeling"
      Så har opptaket runden "Hovedrunde"
      Og runden publiseres for søkere "2027-07-15"
      Og runden har svarfrist "2027-07-20 23:59"

    Scenario: Publiseringsdato og svarfrist for første runde kan ikke endres i runden
      Gitt at opptaket har runden "Hovedrunde" med rundetype "Hovedtildeling"
      Når opptaksforvalter ser på runden "Hovedrunde"
      Så kan ikke publiseringsdato og svarfrist endres i runden
      Og datoene kan bare endres blant fristene for opptaket

    Scenario: Første runde følger endrede datoer i opptaket
      Gitt at opptaket har runden "Hovedrunde" med rundetype "Hovedtildeling"
      Og at runden ikke er publisert
      Når opptaksforvalter endrer dato for når hovedopptaket publiseres til "2027-07-16"
      Og opptaksforvalter endrer første svarfrist til "2027-07-21 23:59"
      Så publiseres runden for søkere "2027-07-16"
      Og runden har svarfrist "2027-07-21 23:59"

  Regel: Et opptak har én hovedtildeling, men kan ha flere runder av andre typer

    Scenario: Tilgjengelige rundetyper
      Når opptaksforvalter legger til en runde
      Så kan opptaksforvalter velge mellom disse rundetypene
        | Rundetype             |
        | Hovedtildeling        |
        | Supplering            |
        | Etterfylling          |
        | Ledige studieplasser  |

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

  Regel: Rundetypen kan ikke endres etter at runden er lagt til
    # Rundetypen er en del av det som identifiserer runden. Feil rundetype rettes ved å
    # fjerne runden og legge den til på nytt (se åpne spørsmål nederst).

    Scenario: Endre rundetype på eksisterende runde
      Gitt at opptaket har runden "Hovedrunde" med rundetype "Hovedtildeling"
      Når opptaksforvalter endrer runden "Hovedrunde"
      Så kan opptaksforvalter endre navn og datoer
      Men rundetypen kan ikke endres

  Regel: Rundetypen styrer hvordan plasstildelingen i runden oppfører seg
      # Selve oppførselen beskrives i 03 Tildeling. Her beskrives bare hva rundetypen innebærer.

    Scenariomal: Regler som følger av rundetypen
      Gitt at runden har rundetype "<rundetype>"
      Så gjelder disse reglene for plasstildelingen i runden
        | Regel                                  | Verdi           |
        | Bortfall på lavere prioriteter         | <bortfall>      |
        | Kompensasjonstilbud ved opprykk        | <kompensasjon>  |
        | Søker kan ha flere tilbud samtidig     | <flere_tilbud>  |
        | Bygger på forrige publiserte runde     | <arv>           |
        | Utdanningstilbud kan ekskluderes       | <ekskludering>  |
        | Rangering                              | <rangering>     |

      Eksempler:
        | rundetype            | bortfall | kompensasjon | flere_tilbud     | arv | ekskludering | rangering           |
        | Hovedtildeling       | ja       | nei          | nei              | nei | nei          | poeng og rangering  |
        | Supplering           | ja       | ja           | nei              | ja  | ja           | poeng og rangering  |
        | Etterfylling         | nei      | nei          | ja, må velge ett | ja  | ja           | poeng og rangering  |
        | Ledige studieplasser | nei      | nei          | ja, må velge ett | ja  | ja           | søknadstidspunkt    |

  @openquestion
  Regel: Etterfølgende runder har egne datoer for publisering og for når lærestedene kan endre antall tilbud
    # ÅPNE SPØRSMÅL:
    # - Er publiseringsdato og periode for å endre antall tilbud obligatoriske når runden legges til,
    #   eller kan de settes senere? Automatisk publisering på dato er avgrenset bort for 2027,
    #   så publiseringsdatoen er foreløpig informasjon og planlegging, ikke en utløser.

    # Første runde arver datoene fra opptakets frister (se regelen over).
    # Etterfølgende runder (supplering, etterfylling, ledige studieplasser) har egne datoer.
    Scenario: Sette publiseringsdato på etterfølgende runde
      Gitt at opptaket har runden "Hovedrunde" med rundetype "Hovedtildeling"
      Når opptaksforvalter setter publiseringsdato for runden "Suppleringsrunde" til "2027-08-01 08:00"
      Så vises "2027-08-01 08:00" som planlagt tidspunkt for når søkerne får svar i runden

    Scenario: Sette periode for når lærestedene kan endre antall tilbud som skal gis
      Når opptaksforvalter setter perioden for å endre antall tilbud som skal gis i runden "Hovedrunde" til "2027-06-01" – "2027-07-10"
      Så kan opptaksforvalter ved lærestedene endre antall tilbud som skal gis for runden fra "2027-06-01" til "2027-07-10"

    Scenario: Endre antall tilbud utenfor perioden
      Gitt at perioden for å endre antall tilbud som skal gis i runden "Hovedrunde" er "2027-06-01" – "2027-07-10"
      Og dagens dato er "2027-07-11"
      Så kan opptaksforvalter ved lærestedene ikke lenger endre antall tilbud som skal gis for runden

  Regel: En runde for ledige studieplasser har en egen søknadsperiode

    Scenario: Sette søknadsperiode for ledige studieplasser
      Når opptaksforvalter legger til runden "Ledige studieplasser" med rundetype "Ledige studieplasser"
      Og opptaksforvalter setter søknadsperioden til "2027-08-01" – "2027-08-20"
      Så kan søkere søke på ledige studieplasser fra "2027-08-01" til "2027-08-20"

  Regel: Minst én runde må finnes før plasstildelingen kan forberedes

    Scenario: Opptak uten runder
      Gitt at opptaket ikke har noen runder
      Så kan opptaksforvalter ikke sette antall tilbud som skal gis på utdanningstilbudene i opptaket

# ÅPNE SPØRSMÅL:
# - AVKLART: Tidligopptak er ikke en rundetype. Søker søker om tidlig opptak, vurderes individuelt, og
#   kan gis tilbudsgaranti. Forutsetter at lærestedet har satt minimum rangeringspoeng for tidlig tilbud.
#   Tilbudsgarantien gir tilbud i hovedtildelingen (se gjennomføre_plasstildeling.feature).
# - design.md kaller ledige studieplasser både en egen rundetype og «en egenskap ved en etterfyllingsrunde».
#   Hvilken av dem gjelder?
# - Kan en runde fjernes? Siden rundetypen ikke kan endres, er fjerning eneste måte å rette feil rundetype.
#   Forslag: runden kan fjernes så lenge ingen plasstildeling er kjørt i den.
# - Kan navn og datoer på runden endres etter at en plasstildeling er publisert i den?
# - Kan opptaksforvalter ved forvaltende organisasjon endre antall tilbud utenfor lærestedenes periode?
