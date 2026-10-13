# language: no
# GitHub: #216
@OPT-PLA-RUN-001 @must @draft
Egenskap: Plasstildelingsrunder i et opptak
  Som opptaksforvalter
  ønsker jeg å legge til og forvalte plasstildelingsrunder i et opptak
  slik at studieplasser kan fordeles i flere omganger med riktige regler for hver plasstildelingsrunde.

  # Kilde: tasks/opptak/plasstildeling/design.md (oppgave 1) og Confluence
  # «2026-09-08 Raffinering plasstildeling», «Opprette og konfigurere opptakskjøringsrunde»
  # og raffinering 2026-10-07.
  # Opptaksforvalter ved forvaltende organisasjon legger til plasstildelingsrunder. I samordna opptak er det
  # Samordna opptak (HK-dir). I lokale opptak er lærestedet den eneste organisasjonen og forvalter selv.
  # En plasstildelingsrunde er vinduet der plasser fordeles. Plasstildelingen er beregningen som gjøres i plasstildelingsrunden,
  # og én plasstildelingsrunde kan ha mange plasstildelinger (se 03 Tildeling).

  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet

  Regel: Opptaksforvalter legger til en plasstildelingsrunde med navn, rundetype og svarfrist

    Scenario: Legge til første plasstildelingsrunde
      Når opptaksforvalter legger til plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling" og svarfrist "2027-07-20 23:59"
      Så har opptaket plasstildelingsrunden "Hovedrunde"
      Og søkere som får tilbud i plasstildelingsrunden må svare innen "2027-07-20 23:59"

    Scenario: Legge til en etterfølgende plasstildelingsrunde
      Gitt at opptaket har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"
      Når opptaksforvalter legger til plasstildelingsrunden "Suppleringsrunde" med rundetype "Supplering" og svarfrist "2027-08-10 23:59"
      Så har opptaket plasstildelingsrunden "Suppleringsrunde"
      Og søkere som får tilbud i plasstildelingsrunden må svare innen "2027-08-10 23:59"

    # Gap mot koden (verifisert 2026-10-09): fs-admin gir melding når navn mangler. Mangler rundetype,
    # er lagre-knappen deaktivert uten melding. Svarfrist får melding bare når feltet er rørt, og
    # plasstildelingsrunden kan lagres uten svarfrist.
    Scenariomal: Plasstildelingsrunde mangler obligatorisk opplysning
      Når opptaksforvalter legger til en plasstildelingsrunde uten <opplysning>
      Så blir plasstildelingsrunden ikke lagt til
      Og opptaksforvalter får beskjed om at <opplysning> mangler

      Eksempler:
        | opplysning |
        | navn       |
        | rundetype  |
        | svarfrist  |

    # Gap mot koden (verifisert 2026-10-09): påminnelse om svarfrist finnes ikke i fs-admin eller fs-plattform.
    Scenario: Sette påminnelse om svarfrist
      Gitt at plasstildelingsrunden "Hovedrunde" har svarfrist "2027-07-20 23:59"
      Når opptaksforvalter setter påminnelse om svarfrist til "2027-07-18"
      Så får søkere med ubesvart tilbud i plasstildelingsrunden en påminnelse "2027-07-18"

  Regel: Et opptak har én hovedtildeling, men kan ha flere plasstildelingsrunder av andre typer

    # Kodeverket har også TIDLIG, LEDIGE_STUDIEPLASSER og TEST, som ikke er rundetyper i kravet,
    # og fs-admin lar bare opptaksforvalter velge HOVED (verifisert 2026-10-09).
    Scenario: Tilgjengelige rundetyper
      Når opptaksforvalter legger til en plasstildelingsrunde
      Så kan opptaksforvalter velge mellom disse rundetypene
        | Rundetype        |
        | Hovedtildeling   |
        | Supplering       |
        | Etterfylling     |

    # AVKLART 2026-10-07, endret 2026-10-08: Ledige studieplasser er en egenskap ved plasstildelingsrunden,
    # ikke en egen rundetype. Opptaksforvalter kan åpne en plasstildelingsrunde av alle rundetyper
    # for nye søknader på ledige plasser (se 03 Tildeling/gjennomføre_plasstildeling.feature).

    Scenario: Hovedtildeling kan bare finnes én gang
      Gitt at opptaket har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"
      Når opptaksforvalter legger til en ny plasstildelingsrunde med rundetype "Hovedtildeling"
      Så blir plasstildelingsrunden ikke lagt til
      Og opptaksforvalter får beskjed om at opptaket allerede har en hovedtildeling

    Scenario: Flere plasstildelingsrunder av samme type etter hovedtildelingen
      Gitt at opptaket har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"
      Og at opptaket har plasstildelingsrunden "Suppleringsrunde 1" med rundetype "Supplering"
      Når opptaksforvalter legger til plasstildelingsrunden "Suppleringsrunde 2" med rundetype "Supplering" og svarfrist "2027-09-01 23:59"
      Så har opptaket to plasstildelingsrunder med rundetype "Supplering"

    Scenario: Hovedtildeling er første plasstildelingsrunde i opptaket
      Gitt at opptaket ikke har noen plasstildelingsrunder
      Når opptaksforvalter legger til plasstildelingsrunder i opptaket
      Så er den første plasstildelingsrunden av rundetype "Hovedtildeling"

    Scenario: Valgfri rekkefølge på rundetyper etter hovedtildelingen
      Gitt at opptaket har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"
      Når opptaksforvalter legger til plasstildelingsrunden "Etterfylling" med rundetype "Etterfylling"
      Så kan etterfyllingsrunden komme før en eventuell suppleringsrunde

  Regel: Navn og svarfrist kan alltid endres

    Scenario: Endre navn og svarfrist på en plasstildelingsrunde
      Gitt at opptaket har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"
      Når opptaksforvalter endrer navnet på plasstildelingsrunden til "Hovedtildeling 2027"
      Og opptaksforvalter endrer svarfristen til "2027-07-25 23:59"
      Så heter plasstildelingsrunden "Hovedtildeling 2027"
      Og søkere som får tilbud i plasstildelingsrunden må svare innen "2027-07-25 23:59"

  Regel: Rundetypen kan ikke endres etter at plasstildelingsrunden er lagt til

    # Rundetypen er en del av det som identifiserer plasstildelingsrunden. Feil rundetype rettes ved å
    # slette plasstildelingsrunden og legge den til på nytt.
    Scenario: Endre rundetype på eksisterende plasstildelingsrunde
      Gitt at opptaket har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"
      Når opptaksforvalter endrer plasstildelingsrunden "Hovedrunde"
      Så kan opptaksforvalter endre navn og svarfrist
      Men rundetypen kan ikke endres

  Regel: En plasstildelingsrunde kan slettes så lenge den ikke er publisert til søker

    Scenario: Slette en plasstildelingsrunde som ikke er publisert
      Gitt at opptaket har plasstildelingsrunden "Suppleringsrunde" med rundetype "Supplering"
      Og at plasstildelingsrunden ikke er publisert til søker
      Når opptaksforvalter sletter plasstildelingsrunden "Suppleringsrunde"
      Så har opptaket ikke lenger plasstildelingsrunden "Suppleringsrunde"

    # AVKLART 2026-10-09: Valget skjules for en publisert plasstildelingsrunde (design-patterns-for-krav.md).
    # Gap mot koden: fs-admin viser «Slett plasstildelingsrunde» også for publiserte plasstildelingsrunder, og backend avviser
    # slettingen med en feilmelding.
    Scenario: Kan ikke slette en plasstildelingsrunde som er publisert til søker
      Gitt at opptaket har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"
      Og at plasstildelingsrunden er publisert til søker
      Når opptaksforvalter ser plasstildelingsrunden "Hovedrunde"
      Så ser opptaksforvalter ikke muligheten til å slette plasstildelingsrunden

  Regel: Opptaksforvalter ser status på plasstildelingsrunden

    Scenario: Plasstildelingsrunde som ikke er publisert
      Gitt at opptaket har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"
      Og at plasstildelingsrunden ikke er publisert til søker
      Så ser opptaksforvalter at plasstildelingsrunden har status "Ikke publisert"

    Scenario: Plasstildelingsrunde som er publisert
      Gitt at opptaket har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"
      Og at plasstildelingsrunden er publisert til søker
      Så ser opptaksforvalter at plasstildelingsrunden har status "Publisert for søkere"

  Regel: Opptaksforvalter kan åpne en plasstildelingsrunde for ledige studieplasser

    # AVKLART 2026-10-08: Egenskapen kan settes på alle rundetyper, også hovedtildelingen.
    # Den kan bare settes når opptaket tilbyr søknad på ledige studieplasser
    # (se 11 Opprette og vedlikeholde opptak/03 Innstillinger/innstillinger.feature).
    # Hvordan plasstildelingen rangerer søkerne, står i 03 Tildeling/gjennomføre_plasstildeling.feature.
    Scenariomal: Åpne plasstildelingsrunden for ledige studieplasser
      Gitt at opptaket tilbyr søknad på ledige studieplasser
      Og at opptaket har plasstildelingsrunden "<plasstildelingsrunde>" med rundetype "<rundetype>"
      Når opptaksforvalter åpner plasstildelingsrunden "<plasstildelingsrunde>" for ledige studieplasser
      Så er plasstildelingsrunden "<plasstildelingsrunde>" åpen for ledige studieplasser

      Eksempler:
        | plasstildelingsrunde            | rundetype      |
        | Hovedrunde       | Hovedtildeling |
        | Suppleringsrunde | Supplering     |
        | Etterfylling     | Etterfylling   |

    Scenario: Opptaket tilbyr ikke søknad på ledige studieplasser
      Gitt at opptaket ikke tilbyr søknad på ledige studieplasser
      Og at opptaket har plasstildelingsrunden "Etterfylling" med rundetype "Etterfylling"
      Når opptaksforvalter endrer plasstildelingsrunden "Etterfylling"
      Så ser opptaksforvalter ikke muligheten til å åpne plasstildelingsrunden for ledige studieplasser

  Regel: Opptaksforvalter setter periode for når lærestedene kan endre antall tilbud som skal gis

    # Antall tilbud som skal gis (i databasen: opptaksparametere) settes per utdanningskvote
    # per plasstildelingsrunde, se 02 Tildelingsinnstillinger/antall_tilbud_som_skal_gis.feature.
    # Her settes vinduet: startdato og sluttdato for når lærestedene kan endre tallet.
    # Hvem som kan endre tallet innenfor og utenfor perioden, står i antall_tilbud_som_skal_gis.feature.

    Scenario: Sette periode for å endre antall tilbud som skal gis
      Når opptaksforvalter setter perioden for å endre antall tilbud som skal gis i plasstildelingsrunden "Hovedrunde" til "2027-06-01" – "2027-07-10"
      Så kan opptaksforvalter ved lærestedene endre antall tilbud som skal gis for plasstildelingsrunden fra "2027-06-01" til "2027-07-10"

    # AVKLART 2026-10-09: Perioden kan alltid endres.
    # Gap mot koden: fs-admin har perioden bare i skjemaet for ny plasstildelingsrunde, ikke i redigeringsskjemaet.
    Scenario: Endre perioden for å endre antall tilbud som skal gis
      Gitt at perioden for å endre antall tilbud som skal gis i plasstildelingsrunden "Hovedrunde" er "2027-06-01" – "2027-07-10"
      Når opptaksforvalter endrer perioden til "2027-06-01" – "2027-07-15"
      Så kan opptaksforvalter ved lærestedene endre antall tilbud som skal gis for plasstildelingsrunden fram til "2027-07-15"

  Regel: Opptakets informasjonsdatoer for publisering påvirker ikke plasstildelingsrunden

    # Fristene for når resultatet i hovedrunden kan forventes publisert, som settes i
    # 11 Opptak/04 Frister/frister_og_hendelser.feature, er ren informasjon til søker.
    # Opptaksforvalter setter ingen eksplisitt publiseringsdato på plasstildelingsrunden.
    # Publiseringsdato styres av når publiseringen faktisk finner sted.

    Scenario: Plasstildelingsrunden har ingen eksplisitt publiseringsdato
      Gitt at opptaket har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"
      Når opptaksforvalter ser på plasstildelingsrunden "Hovedrunde"
      Så har plasstildelingsrunden ingen publiseringsdato
      Og plasstildelingsrunden publiseres når opptaksforvalter velger å publisere resultatet

# AVKLARTE SPØRSMÅL (raffinering 2026-10-07):
# - Ledige studieplasser er en egenskap ved etterfylling, ikke en egen rundetype.
#   Endret 2026-10-08: egenskapen kan settes på alle rundetyper, også hovedtildelingen.
# - Plasstildelingsrunder kan slettes så lenge de ikke er publisert til søker.
# - Navn og svarfrist kan alltid endres.
# - Opptaksforvalter setter ingen eksplisitt publiseringsdato. Publisering skjer når den skjer.
# - Tidligopptak er ikke en rundetype (avklart tidligere). Bekreftet 2026-10-09: søkere som får
#   tilsagn på søknad om tidlig opptak, får tilbudsgaranti i plasstildelingsrundene som kjøres.