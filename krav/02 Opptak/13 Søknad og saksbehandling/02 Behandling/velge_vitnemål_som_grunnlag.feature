# language: no
# GitHub: #608
#
# Leveranse L2 av seks i initiativet #607 Vitnemålsbehandling. Skilt ut fra
# vitnemålsbehandling.feature 08.10.2026, og beholder Feature-ID-en derfra.
# Kilder, bakgrunn, avgrensninger og oversikten over leveransene står i
# vitnemålsbehandling.md i samme mappe.
#
# Dette er leveransen som fjerner blokkeringen: etter L2 kan
# beregnPoengAutomatisk og vurderKravelementerAutomatisk kjøre på søkere med
# flere vitnemål. Mønsteret finnes å kopiere — settGskKonklusjonFraVitnemaal
# gjør nøyaktig dette for GSK.
#
@OPT-BEH-BEH-004 @must @draft
Egenskap: Velge vitnemål som grunnlag for poengberegningen
  Som saksbehandler i opptak
  ønsker jeg å velge hvilket vitnemål som legges til grunn for poengberegningen
  slik at søkere med flere vitnemål blir poengberegnet.

  Den automatiske saksbehandlingen stopper når søkeren har flere vitnemål.
  Denne leveransen lar saksbehandleren peke ut ett vitnemål som grunnlag for
  hele saken, og viser poengene Team Puffs beregning gir tilbake. Et valgt
  grunnlag låser poengene mot automatisk reberegning.

  Valget gjelder ett vitnemål for hele saken. Å velge vitnemål og fag per
  poengvariant kommer i L3 (velge_fag_per_poengvariant.feature), og manuell
  inntasting av fag i L4 (legge_inn_og_endre_fag.feature). Visningen av
  vitnemålene er L1 (vise_elektroniske_vitnemål.feature).

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg kan se og endre søknadsbehandling for organisasjonen som behandler saken
    Og jeg er inne på søknaden til en søker

  Regel: Saksbehandleren velger hvilket vitnemål som legges til grunn

    Scenario: Velge vitnemålet som skal legges til grunn
      Gitt søkeren har flere elektroniske vitnemål
      Når jeg velger ett av vitnemålene
      Så er det valgte vitnemålet grunnlaget for poengberegningen
      # Skilt ut 08.10.2026: steget «Så vises fagene på det valgte vitnemålet»
      # er tatt ut her, fordi visningen av fagene hører til L3 (regelen
      # «Fagene på det valgte vitnemålet vises» i
      # velge_fag_per_poengvariant.feature).

    Scenario: Automatikken har ikke beregnet poeng når søkeren har flere vitnemål
      Gitt søkeren har flere elektroniske vitnemål
      Og den automatiske poengberegningen ikke har konkludert
      Når jeg åpner grunnlaget på søknaden
      Så fremgår det at poengene ikke er beregnet automatisk
      Og det fremgår at årsaken er at søkeren har flere vitnemål
      # Verifisert i ny stack: vurderKravelementerAutomatisk hopper over saken
      # «uten entydig vitnemål», og behandleSakAutomatisk kan returnere
      # FlereVitnemaalException. I dag får saksbehandleren ingen forklaring på
      # hvorfor poengene mangler — det er nettopp den stillheten featuren
      # skal fjerne.

    Scenario: Bytte til et annet vitnemål
      Gitt jeg har lagt et vitnemål til grunn
      Når jeg velger et annet vitnemål
      Så beregnes poengene på nytt fra det nye vitnemålet
      Og det fremgår hvilket vitnemål poengene nå bygger på

    Scenario: Søker med individuell vurdering har ingen poeng å behandle
      Gitt søkeren har grunnlaget HUP
      Når jeg åpner grunnlaget på søknaden
      Så ser jeg ikke muligheten til å velge vitnemål eller fag som grunnlag for poengberegningen
      # AVKLART 08.10.2026: en søker med HUP («helt uten poeng») skal ikke
      # poengberegnes. Vitnemålene vises fortsatt, jf.
      # vise_elektroniske_vitnemål.feature (@OPT-BEH-BEH-005). HUP og VES kan
      # ikke gjelde samtidig, se avgrensningen om valg av grunnlag i
      # vitnemålsbehandling.md.

  Regel: Poeng beregnes fra det valgte grunnlaget

    # Poengberegningen eies av Team Puff. Vitnemålsbehandleren kaller
    # endepunktene deres med grunnlaget saksbehandleren har valgt, og viser
    # resultatet. Hvordan poengene regnes ut (hvilke karakterer som teller,
    # avrunding, satser og tak) hører ikke til dette kravet.
    #
    # I L2 er grunnlaget det valgte vitnemålet. L3 og L4 utvider grunnlaget
    # med fagvalg og manuelt innlagte fag, og de samme scenarioene gjelder da
    # for dem.

    Scenario: Poeng beregnes når grunnlaget endres
      Gitt jeg har lagt et vitnemål til grunn
      Når jeg endrer grunnlaget
      Så er poengene beregnet på nytt fra det endrede grunnlaget

    Scenario: Endringen avvises når poengberegningen feiler
      Gitt jeg har lagt et vitnemål til grunn
      Og poengberegningen feiler eller ikke svarer
      Når jeg endrer grunnlaget
      Så er grunnlaget uendret
      Og jeg ser at endringen ikke ble gjennomført
      # AVKLART 08.10.2026: grunnlaget lagres ikke når kallet til Team Puffs
      # endepunkt feiler. Saksbehandleren må gjøre endringen på nytt senere.
      # Grunnlag og poeng er dermed aldri ute av takt. Samme hensyn som
      # KregUtilgjengeligFeil i ny stack, som stopper behandlingen «for å
      # unngå behandling på mulig utdatert grunnlag». Utformingen av
      # beskjeden hører i velge_vitnemål_som_grunnlag.design.md.

    Scenario: Se de beregnede poengene
      Gitt jeg har lagt et vitnemål til grunn
      Når poengene er beregnet
      Så ser jeg de beregnede poengene for hver poengvariant

    Scenario: Legge inn realfagspoeng på en poengvariant
      Gitt jeg har lagt et vitnemål til grunn
      Når jeg legger inn realfagspoeng selv på en poengvariant
      Så er realfagspoengene jeg la inn, brukt for den poengvarianten
      Og det fremgår at poengene er satt av en saksbehandler
      Og poengene er låst mot automatisk reberegning
      # AVKLART 07.10.2026: saksbehandleren kan legge inn realfagspoeng selv
      # på poengvarianten, i tillegg til å markere fag med forsøkskode (L4).
      # Poengene låses på samme måte som når grunnlaget velges, og kan låses
      # opp med «Låse opp et poeng».

    Scenario: Se hvilket vitnemål et poeng bygger på
      Gitt poengene er beregnet fra et vitnemål
      Når jeg ser poengene
      Så ser jeg hvilket vitnemål hvert poeng er beregnet fra
      Og jeg ser om poenget er beregnet automatisk eller satt av en saksbehandler
      # Verifisert i ny stack: Poeng har vitnemaalsnummer,
      # statusAutomatiskUtregnet og merknadAutomatisk, der den siste sier
      # «hvilken automatisk beregning som satte verdien, og hvilket vitnemål
      # som lå til grunn». Sporbarheten finnes allerede — kravet er at den
      # skal vises.

    Scenario: Valget av grunnlag låser poenget mot automatisk reberegning
      Gitt jeg har lagt et vitnemål til grunn
      Når den automatiske poengberegningen kjøres
      Så beregnes ikke poenget på nytt
      Og poenget bygger fortsatt på grunnlaget jeg valgte
      # AVKLART 21.09.2026: å velge grunnlag låser de berørte poengradene,
      # slik lagring i kalkulatoren allerede gjør. Skilt ut 08.10.2026: het
      # «Fagvalget låser poenget mot automatisk reberegning». I L2 er det
      # valget av vitnemål som låser; fagvalget i L3 låser på samme måte.
      #
      # Verifisert i ny stack: LagreVitnemalUtregningService.skrivPoeng setter
      # LA_STAA = true og STATUS_AUTOMATISK_UTREGNET = false ved innsetting, og
      # bevarer la_staa ved oppdatering. Javadoc begrunner det slik: «en fersk
      # kalkulatorverdi er en manuell saksbehandler-handling og skal ikke
      # overskrives av automatisk poengberegning».
      #
      # Begge automatikk-tjenestene respekterer låsen med WHERE-guard:
      # AutomatiskPoengberegningService filtrerer på SAK_POENG.LA_STAA = false,
      # og AutomatiskKravelementVurderingService på
      # SAK_KVALIFISERING_KRAVELEMENT.LA_STAA = false. Schema-teksten
      # «Eksisterende poeng overskrives med nyberegnet verdi» er upresis på
      # dette punktet.

    Scenario: Låse opp et poeng
      Gitt et poeng er låst av grunnlaget jeg valgte
      Når jeg låser opp poenget
      Så beregnes poenget av den automatiske poengberegningen igjen
      # Opplåsing finnes allerede: settPoengV4(laStaa: false). Kalkulatoren
      # låser ikke raden igjen ved neste lagring — se javadoc-sitatet over.

  Regel: Muligheten til å endre styres av rettighet, ikke av hvem som har tatt saken

    # Innsyn er skilt ut til vise_elektroniske_vitnemål.feature
    # (@OPT-BEH-BEH-005): hvem som ser vitnemålene, hvem som ikke gjør det, og
    # at tilordning ikke er en innsynsgrense. Den fila har også den fulle
    # begrunnelsen med kildereferanser. Regelen her dekker det som først kan
    # etterprøves når det finnes noe å endre, og gjelder også endringene i
    # L3 og L4.

    Scenario: Saksbehandler med endringsrettighet kan behandle vitnemål
      Gitt jeg kan endre søknadsbehandling for organisasjonen som behandler saken
      Når jeg åpner søknaden til en søker
      Så kan jeg velge hvilket vitnemål som legges til grunn
      # Skilt ut 08.10.2026: steget sa «Så kan jeg velge vitnemål, velge fag og
      # legge inn fag manuelt». Fagvalg og manuell inntasting kommer i L3 og
      # L4, så i L2 er det valget av vitnemål som kan etterprøves.

    Scenario: Saksbehandler med kun leserettighet ser grunnlaget
      Gitt jeg kan se, men ikke endre, søknadsbehandling for organisasjonen som behandler saken
      Når jeg åpner søknaden til en søker
      Så ser jeg søkerens vitnemål, det valgte grunnlaget og de beregnede poengene
      Men jeg ser ikke muligheten til å endre dem
      # At lesetilgang gir innsyn uten endringsmulighet er i tråd med
      # design-patterns-for-krav.md: det er *muligheten til å endre* som
      # skjules, ikke opplysningene. En saksbehandler som ser et poeng må
      # kunne se hva det bygger på.

    Scenario: Tilordning hindrer ikke at jeg behandler saken
      Gitt saken er tilordnet en annen saksbehandler
      Og jeg kan endre søknadsbehandling for organisasjonen som behandler saken
      Når jeg åpner søknaden til en søker
      Så kan jeg behandle vitnemålet
      # AVKLART 21.09.2026: tilgang styres av rettighet og organisasjon, ikke
      # av tilordning. Full begrunnelse i vise_elektroniske_vitnemål.feature.
