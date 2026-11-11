# language: no
# BEGREPER (2026-11-10): Bytt «opptakets forvalter» med «forvalter» når fila likevel endres. Se krav/02 Opptak/begreper.md.
# GitHub: #216
@OPT-PLA-RUN-001 @must @in-progress @scope-plasstildeling-2027
Egenskap: Plasstildelingsrunder i et opptak
  Som opptaksforvalter
  ønsker jeg å legge til og forvalte plasstildelingsrunder i et opptak
  slik at studieplasser kan fordeles i flere omganger med riktige regler for hver plasstildelingsrunde.

  # Kilde: tasks/opptak/plasstildeling-2027/design.md (oppgave 1) og Confluence
  # «2026-09-08 Raffinering plasstildeling», «Opprette og konfigurere opptakskjøringsrunde»
  # og raffinering 2026-10-07.
  # Opptakets forvalter legger til plasstildelingsrunder. I samordna opptak er det
  # Samordna opptak (HK-dir). I lokale opptak er lærestedet den eneste organisasjonen og forvalter selv.
  # En plasstildelingsrunde er vinduet der plasser fordeles. Plasstildelingen er beregningen som gjøres i plasstildelingsrunden,
  # og én plasstildelingsrunde kan ha mange plasstildelinger (se 03 Tildeling).

  Bakgrunn:
    Gitt at opptakets forvalter er innlogget
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

  Regel: Navnet på plasstildelingsrunden er unikt i opptaket

    # AVKLART 2026-11-04 (produkteier, kodesjekken i fs-specify): Navnet er unikt i opptaket uten hensyn til
    # store og små bokstaver, og er høyst 100 tegn. Gjelder også når navnet endres.
    Scenario: Navnet er brukt i opptaket fra før
      Gitt at opptaket har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"
      Når opptaksforvalter legger til plasstildelingsrunden "hovedrunde" med rundetype "Supplering" og svarfrist "2027-08-10 23:59"
      Så blir plasstildelingsrunden ikke lagt til
      Og opptaksforvalter får beskjed om at opptaket allerede har en plasstildelingsrunde med navnet "hovedrunde"

    Scenario: Samme navn i et annet opptak
      Gitt at opptaket "Samordna opptak 2026" har plasstildelingsrunden "Hovedrunde"
      Når opptaksforvalter legger til plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling" og svarfrist "2027-07-20 23:59"
      Så har opptaket "Samordna opptak 2027" plasstildelingsrunden "Hovedrunde"

    Scenario: Navnet er for langt
      Når opptaksforvalter legger til en plasstildelingsrunde med et navn på 101 tegn
      Så blir plasstildelingsrunden ikke lagt til
      Og opptaksforvalter får beskjed om at navnet kan være høyst 100 tegn

  @depends-on-OPT-REG-RUN-001
  Regel: Rundetypene avgjør hvilke plasstildelingsrunder opptaket kan ha

    # Endret 2026-11-04: Rundetypene og innstillingene er felles for alle opptak, og ikke en del av
    # regelverkssamlingen (10 Regelverk/06 Rundetyper/bruke_rundetyper.feature).
    # At et samordna opptak har én hovedtildeling, og at den er først, følger av innstillingene.
    # Kodeverket har også TIDLIG, LEDIGE_STUDIEPLASSER og TEST, som ikke er rundetyper i kravet,
    # og fs-admin lar bare opptaksforvalter velge HOVED (verifisert 2026-10-09).
    Scenario: Tilgjengelige rundetyper
      Når opptaksforvalter legger til en plasstildelingsrunde
      Så kan opptaksforvalter velge mellom rundetypene
        | Rundetype      |
        | Hovedtildeling |
        | Supplering     |
        | Etterfylling   |

    # AVKLART 2026-10-07, endret 2026-10-08: Ledige studieplasser er en egenskap ved plasstildelingsrunden,
    # ikke en egen rundetype. Endret 2026-10-24: Rundetypen sier om plasstildelingsrunden kan åpnes for
    # ledige studieplasser (se regelen om ledige studieplasser under).

    Scenario: Rundetype som bare kan finnes én gang
      Gitt at rundetypen "Hovedtildeling" har innstillingen "Bare én i opptaket"
      Og at opptaket har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"
      Når opptaksforvalter legger til en ny plasstildelingsrunde med rundetype "Hovedtildeling"
      Så blir plasstildelingsrunden ikke lagt til
      Og opptaksforvalter får beskjed om at opptaket allerede har en plasstildelingsrunde med rundetype "Hovedtildeling"

    Scenario: Flere plasstildelingsrunder av samme rundetype
      Gitt at opptaket har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"
      Og at opptaket har plasstildelingsrunden "Suppleringsrunde 1" med rundetype "Supplering"
      Når opptaksforvalter legger til plasstildelingsrunden "Suppleringsrunde 2" med rundetype "Supplering" og svarfrist "2027-09-01 23:59"
      Så har opptaket to plasstildelingsrunder med rundetype "Supplering"

    Scenario: Rundetype som bygger på forrige plasstildelingsrunde, kan ikke være først
      Gitt at opptaket ikke har noen plasstildelingsrunder
      Og at rundetypen "Supplering" har innstillingen "Bygger på forrige publiserte plasstildelingsrunde"
      Når opptaksforvalter legger til en plasstildelingsrunde med rundetype "Supplering"
      Så blir plasstildelingsrunden ikke lagt til
      Og opptaksforvalter får beskjed om at opptaket må ha en plasstildelingsrunde fra før

    Scenario: Valgfri rekkefølge på rundetyper etter hovedtildelingen
      Gitt at opptaket har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"
      Når opptaksforvalter legger til plasstildelingsrunden "Etterfylling" med rundetype "Etterfylling"
      Så kan etterfyllingsrunden komme før en eventuell suppleringsrunde

  Regel: Navn og svarfrist kan alltid endres
    # Hva søkeren merker når svarfristen flyttes, står i 05 Svar/håndtere_svar_fra_søker.feature, og meldingen
    # til søkeren i 05 Svar/varsler_og_meldinger_i_plasstildelingen.feature. Der står også påminnelsen om svarfrist.

    Scenario: Endre navn og svarfrist på en plasstildelingsrunde
      Gitt at opptaket har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"
      Når opptaksforvalter endrer navnet på plasstildelingsrunden til "Hovedtildeling 2027"
      Og opptaksforvalter endrer svarfristen til "2027-07-25 23:59"
      Så heter plasstildelingsrunden "Hovedtildeling 2027"
      Og søkere som får tilbud i plasstildelingsrunden må svare innen "2027-07-25 23:59"

  @depends-on-OPT-REG-RUN-001
  Regel: Plasstildelingsrunden har innstillingene fra rundetypen

    # AVKLART 2026-10-24: Innstillingene kan ikke justeres på plasstildelingsrunden.
    # AVKLART 2026-11-04 (produkteier): Hovedtildeling, supplering og etterfylling er tilgjengelige for brukerne fra
    # start (10 Regelverk/06 Rundetyper/bruke_rundetyper.feature). Å forvalte rundetypene er foreløpig ute av scopet
    # (10 Regelverk/06 Rundetyper/forvalte_rundetyper.feature, @could).
    Scenariomal: Se innstillingene på plasstildelingsrunden
      Gitt at opptaket har plasstildelingsrunden "<plasstildelingsrunde>" med rundetype "<rundetype>"
      Når opptaksforvalter ser plasstildelingsrunden "<plasstildelingsrunde>"
      Så ser opptaksforvalter innstillingene fra rundetypen "<rundetype>"
        | Innstilling                                       | Verdi          |
        | Tilbud gir bortfall på lavere prioriteter         | <bortfall>     |
        | Kompensasjonstilbud ved opprykk                   | <kompensasjon> |
        | Bygger på forrige publiserte plasstildelingsrunde | <arv>          |
        | Bare én i opptaket                                | <én>           |
        | Kan åpnes for ledige studieplasser                | <ledige>       |

      Eksempler:
        | plasstildelingsrunde | rundetype      | bortfall | kompensasjon | arv | én  | ledige |
        | Hovedrunde           | Hovedtildeling | ja       | nei          | nei | ja  | ja     |
        | Suppleringsrunde     | Supplering     | ja       | ja           | ja  | nei | ja     |
        | Etterfylling         | Etterfylling   | nei      | nei          | ja  | nei | ja     |

    Scenario: Innstillingene kan ikke endres på plasstildelingsrunden
      Gitt at opptaket har plasstildelingsrunden "Suppleringsrunde" med rundetype "Supplering"
      Når opptaksforvalter endrer plasstildelingsrunden "Suppleringsrunde"
      Så ser opptaksforvalter ikke muligheten til å endre innstillingene fra rundetypen

  Regel: Rundetypen kan ikke endres etter at plasstildelingsrunden er lagt til

    # Rundetypen er en del av det som identifiserer plasstildelingsrunden. Feil rundetype rettes ved å
    # slette plasstildelingsrunden og legge den til på nytt.
    # AVKLART 2026-10-28 (produkteier, HK-9759): Regelen gjelder. Rundetypene er stabile («har ikke vært endret
    # på lenge», brukertesten med HK-dir 2026-10-27), og sletting og ny runde dekker behovet.
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

  Regel: Opptaksforvalter setter tak for antall tilbud per søker i plasstildelingsrunden

    # AVKLART 2026-11-04 (produkteier): Taket har en standardverdi per rundetype når plasstildelingsrunden legges til,
    # og opptaksforvalter kan endre den.
    # AVKLART 2026-11-02 (domeneekspert): Taket gjelder de ordinære tilbudene, og vises og kan endres på alle
    # plasstildelingsrunder. Tilbud på ledige studieplasser kommer i tillegg, med eget tak (regelen under).
    # I samordna opptak er taket 1 i hovedtildeling og supplering, og opptil 10 i etterfylling.
    # Søkeren kan likevel bare ha ett ja-svar om gangen, og får bare én studieplass i et samordna opptak
    # (05 Svar/håndtere_svar_fra_søker.feature).
    # Til senere: søkere kan trenge flere studieplasser, for eksempel på deltidsstudier, PPU og enkeltemner.
    # AVKLART 2026-11-04 (produkteier, tilbakemelding på PR #907): Taket gjelder også i rundetyper der tilbud gir bortfall.
    # Bortfallet gjelder da prioritetene under det laveste tilbudet når søkeren har fått så mange tilbud som taket sier
    # (03 Tildeling/gjennomføre_plasstildeling.feature).
    Scenariomal: Standardverdi for taket for antall tilbud per søker
      Når opptaksforvalter legger til plasstildelingsrunden "<plasstildelingsrunde>" med rundetype "<rundetype>"
      Så er taket for antall tilbud per søker i plasstildelingsrunden "<plasstildelingsrunde>" <tak>
      Og kan en søker få høyst <tak> tilbud i plasstildelingsrunden "<plasstildelingsrunde>"

      Eksempler:
        | plasstildelingsrunde | rundetype      | tak |
        | Hovedrunde           | Hovedtildeling | 1   |
        | Suppleringsrunde     | Supplering     | 1   |
        | Etterfylling         | Etterfylling   | 10  |

    Scenario: Endre taket for antall tilbud per søker
      Gitt at taket for antall tilbud per søker i plasstildelingsrunden "Etterfylling" er 10
      Når opptaksforvalter endrer taket for antall tilbud per søker i plasstildelingsrunden "Etterfylling" til 5
      Så kan en søker få høyst 5 tilbud i plasstildelingsrunden "Etterfylling"

  Regel: Opptaksforvalter setter tak for antall tilbud på ledige studieplasser per søker i plasstildelingsrunden

    # Flyttet hit 2026-10-26 fra 11 Opprette og vedlikeholde opptak/03 Innstillinger/innstillinger.feature, der
    # regelen «Opptaksforvalter setter tak for antall tilbud per tildelingsrunde» er @deprecated.
    # AVKLART 2026-10-28 (produkteier, etter brukertesten med HK-dir 2026-10-27): Taket settes på plasstildelingsrunden,
    # ikke i rundetypen, og gjelder tilbud på ledige studieplasser når runden er åpnet for ledige studieplasser.
    # I samordna opptak kan en søker få opptil 10 tilbud på ledige studieplasser i supplering og etterfylling, i tillegg
    # til de ordinære tilbudene (domeneekspert 2026-11-02). Hvordan tilbud på ledige studieplasser gis,
    # står i 03 Tildeling/gjennomføre_plasstildeling.feature.
    # AVKLART 2026-10-30 (produkteier): Om en søker kan få studieplass mer enn ett sted, kommer an på opptaket, og
    # henger sammen med hvor mange tilbud søkeren kan få og takke ja til. Det har ingen egen regel, men styres av taket.
    # AVKLART 2026-11-04 (produkteier): Taket har standardverdien 10 når plasstildelingsrunden åpnes for ledige
    # studieplasser, og opptaksforvalter kan endre den. Erstatter avklaringen fra 2026-10-30 om at taket ikke har
    # en standardverdi og må settes.
    # AVKLART 2026-11-04 (produkteier, tilbakemelding på PR #907): Standardverdien er 10 i alle tre rundetypene, også
    # hovedtildelingen, som kan åpnes for ledige studieplasser (regelen under). Domeneeksperten nevnte bare supplering
    # og etterfylling 2026-11-02.
    Scenariomal: Standardverdi for taket for antall tilbud på ledige studieplasser per søker
      Gitt at opptaket har plasstildelingsrunden "<plasstildelingsrunde>" med rundetype "<rundetype>"
      Når opptaksforvalter åpner plasstildelingsrunden "<plasstildelingsrunde>" for ledige studieplasser
      Så er taket for antall tilbud på ledige studieplasser per søker i plasstildelingsrunden "<plasstildelingsrunde>" 10
      Og kan en søker få høyst 10 tilbud på ledige studieplasser i plasstildelingsrunden "<plasstildelingsrunde>"

      Eksempler:
        | plasstildelingsrunde | rundetype      |
        | Hovedrunde           | Hovedtildeling |
        | Suppleringsrunde     | Supplering     |
        | Etterfylling         | Etterfylling   |

    Scenario: Endre taket for antall tilbud på ledige studieplasser per søker
      Gitt at plasstildelingsrunden "Etterfylling" er åpnet for ledige studieplasser
      Og at taket for antall tilbud på ledige studieplasser per søker i plasstildelingsrunden "Etterfylling" er 10
      Når opptaksforvalter endrer taket for antall tilbud på ledige studieplasser per søker i plasstildelingsrunden "Etterfylling" til 5
      Så kan en søker få høyst 5 tilbud på ledige studieplasser i plasstildelingsrunden "Etterfylling"

  Regel: Opptaksforvalter kan åpne en plasstildelingsrunde for ledige studieplasser

    # AVKLART 2026-10-08: Egenskapen kan settes på alle rundetyper, også hovedtildelingen.
    # Endret 2026-10-24: Den kan settes når rundetypen har innstillingen «Kan åpnes for ledige studieplasser».
    # I samordna opptak har alle tre rundetypene den.
    # Den kan bare settes når opptaket tilbyr søknad på ledige studieplasser
    # (se 11 Opprette og vedlikeholde opptak/03 Innstillinger/innstillinger.feature).
    # Hvordan plasstildelingen rangerer søkerne, står i 03 Tildeling/gjennomføre_plasstildeling.feature.
    # AVKLART 2026-10-15 (domeneekspert): Når runden er åpnet for ledige studieplasser, tar utdanningstilbud
    # som tilbyr ledige studieplasser, imot nye søknader til behandling, og søknadene kan få tilbud i runden
    # etter reglene for ledige studieplasser.
    Scenariomal: Åpne plasstildelingsrunden for ledige studieplasser
      Gitt at opptaket tilbyr søknad på ledige studieplasser
      Og at rundetypen "<rundetype>" har innstillingen "Kan åpnes for ledige studieplasser"
      Og at opptaket har plasstildelingsrunden "<plasstildelingsrunde>" med rundetype "<rundetype>"
      Når opptaksforvalter åpner plasstildelingsrunden "<plasstildelingsrunde>" for ledige studieplasser
      Så tar utdanningstilbud som tilbyr ledige studieplasser, imot nye søknader til behandling
      Og søknader på ledige studieplasser kan få tilbud i plasstildelingsrunden "<plasstildelingsrunde>" etter reglene for ledige studieplasser

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

    # Fjernet 2026-11-04 (tilbakemelding på PR #907): scenarioet «Rundetypen kan ikke åpnes for ledige studieplasser».
    # Alle tre rundetypene har innstillingen, og innstillingene kan ikke endres. Det kommer tilbake når rundetypene
    # kan forvaltes (10 Regelverk/06 Rundetyper/forvalte_rundetyper.feature).

  Regel: Opptaksforvalter setter periode for når lærestedene kan endre antall tilbud som skal gis

    # Antall tilbud som skal gis (i databasen: opptaksparametere) settes per utdanningskvote
    # per plasstildelingsrunde, se 02 Tildelingsinnstillinger/antall_tilbud_som_skal_gis.feature.
    # Her settes vinduet: startdato og sluttdato for når lærestedene kan endre tallet.
    # Hvem som kan endre tallet innenfor og utenfor perioden, står i antall_tilbud_som_skal_gis.feature.

    # Endret 2026-10-28 etter brukertesten med HK-dir 2026-10-27: perioden settes med dato og klokkeslett.
    Scenario: Sette periode for å endre antall tilbud som skal gis
      Når opptaksforvalter setter perioden for å endre antall tilbud som skal gis i plasstildelingsrunden "Hovedrunde" til "2027-06-01 08:00" – "2027-07-10 16:00"
      Så kan opptaksforvalter ved lærestedene endre antall tilbud som skal gis for plasstildelingsrunden fra "2027-06-01 08:00" til "2027-07-10 16:00"

    # AVKLART 2026-10-09: Perioden kan alltid endres.
    # Gap mot koden: fs-admin har perioden bare i skjemaet for ny plasstildelingsrunde, ikke i redigeringsskjemaet.
    Scenario: Endre perioden for å endre antall tilbud som skal gis
      Gitt at perioden for å endre antall tilbud som skal gis i plasstildelingsrunden "Hovedrunde" er "2027-06-01 08:00" – "2027-07-10 16:00"
      Når opptaksforvalter endrer perioden til "2027-06-01 08:00" – "2027-07-15 16:00"
      Så kan opptaksforvalter ved lærestedene endre antall tilbud som skal gis for plasstildelingsrunden fram til "2027-07-15 16:00"

    # AVKLART 2026-11-02 (produkteier, prototypen v88): Svarfristen må komme etter at perioden for lærestedene er slutt.
    Scenario: Svarfristen kommer før perioden er slutt
      Gitt at plasstildelingsrunden "Hovedrunde" har svarfrist "2027-07-20 23:59"
      Når opptaksforvalter setter perioden for å endre antall tilbud som skal gis i plasstildelingsrunden "Hovedrunde" til "2027-06-01 08:00" – "2027-07-25 16:00"
      Så blir perioden ikke lagret
      Og opptaksforvalter får beskjed om at svarfristen må komme etter at perioden for å endre antall tilbud er slutt

  Regel: Lærestedene kan bare åpne plasstildelingsrunden der perioden for å endre antall tilbud er åpen

    # AVKLART 2026-11-02 (produkteier, prototypen v88): Lærestedet ser alle plasstildelingsrundene, og hva det skal
    # gjøre i hver av dem, men kan bare åpne runden der perioden er åpen. Da finner lærestedet riktig runde, som det
    # ikke gjorde i SODB.
    # Hvor lærestedet ser resultatet av plasstildelingen etter perioden, er et åpent spørsmål i
    # 04 Resultat/vise_resultat.feature (tilbakemelding på PR #907, 2026-11-04).
    # AVKLART 2026-11-04 (produkteier): Runder der perioden er stengt, forblir stengt for lærestedet. I runden der
    # perioden er åpen, kan lærestedet sammenligne med tidligere plasstildelingsrunder. Endringer mellom rundene blir
    # synlige for brukerne når løsningen får endringslogg.
    # Hvordan en runde som ikke kan åpnes, vises, står i implementasjonsdetaljene.
    Scenario: Lærestedet ser alle plasstildelingsrundene
      Gitt at opptaket har plasstildelingsrundene "Hovedrunde" og "Supplering 1"
      Når opptaksforvalter ved et lærested som deltar i opptaket, åpner plasstildelingsrundene i opptaket
      Så ser opptaksforvalter ved lærestedet plasstildelingsrundene "Hovedrunde" og "Supplering 1"

    Scenario: Lærestedet kan åpne plasstildelingsrunden der perioden er åpen
      Gitt at perioden for å endre antall tilbud som skal gis er åpen i plasstildelingsrunden "Supplering 1"
      Når opptaksforvalter ved et lærested som deltar i opptaket, åpner plasstildelingsrundene i opptaket
      Så kan opptaksforvalter ved lærestedet åpne plasstildelingsrunden "Supplering 1"

    Scenario: Lærestedet kan ikke åpne plasstildelingsrunden der perioden er stengt
      Gitt at perioden for å endre antall tilbud som skal gis er stengt i plasstildelingsrunden "Hovedrunde"
      Når opptaksforvalter ved et lærested som deltar i opptaket, åpner plasstildelingsrundene i opptaket
      Så kan opptaksforvalter ved lærestedet ikke åpne plasstildelingsrunden "Hovedrunde"

    Scenariomal: Lærestedet ser hva det skal gjøre i plasstildelingsrunden
      Gitt at perioden for å endre antall tilbud som skal gis i plasstildelingsrunden "Hovedrunde" <periode>
      Når opptaksforvalter ved et lærested som deltar i opptaket, åpner plasstildelingsrundene i opptaket
      Så ser opptaksforvalter ved lærestedet oppgaven "<oppgave>" for plasstildelingsrunden "Hovedrunde"

      Eksempler:
        | periode        | oppgave                                           |
        | ikke er satt   | Perioden er ikke satt ennå                        |
        | ikke har åpnet | Perioden åpner                                    |
        | er åpen        | Gå gjennom antall tilbud                          |
        | er utløpt      | Perioden for å gå gjennom antall tilbud er utløpt |

    Scenario: Lærestedet ser plasstildelingsrundene det har en oppgave i
      Gitt at perioden for å endre antall tilbud som skal gis er åpen i plasstildelingsrunden "Supplering 1"
      Og at perioden for å endre antall tilbud som skal gis er stengt i plasstildelingsrunden "Hovedrunde"
      Når opptaksforvalter ved et lærested som deltar i opptaket, åpner plasstildelingsrundene i opptaket
      Så ser opptaksforvalter ved lærestedet at det har en oppgave i plasstildelingsrunden "Supplering 1"

    Scenario: Opptaksforvalter ved organisasjonen som forvalter opptaket, ser alle plasstildelingsrundene
      Gitt at opptaket har plasstildelingsrundene "Hovedrunde" og "Supplering 1"
      Og at perioden for å endre antall tilbud som skal gis er åpen i plasstildelingsrunden "Supplering 1"
      Når opptaksforvalter ved organisasjonen som forvalter opptaket, åpner plasstildelingsrundene i opptaket
      Så ser opptaksforvalter plasstildelingsrundene "Hovedrunde" og "Supplering 1"

  Regel: Opptakets informasjonsdatoer for publisering påvirker ikke plasstildelingsrunden

    # Fristene for når resultatet i hovedrunden kan forventes publisert, som settes i
    # 11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature, er ren informasjon til søker.
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
