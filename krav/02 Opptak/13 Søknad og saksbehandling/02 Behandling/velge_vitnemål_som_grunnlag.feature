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
@OPT-BEH-BEH-004 @must @in-progress
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
    Og jeg er inne på søknaden til en søker

  # AVKLART 21.10.2026: rettighetene gjelder saksbehandleren som person, ikke
  # organisasjonen. En saksbehandler med bare leserettighet skal ikke kunne
  # endre. Rettigheten står derfor i Bakgrunn under de to første reglene, og
  # ikke i Bakgrunn for hele egenskapen, så scenarioet om leserettighet ikke
  # motsies.

  Regel: Saksbehandleren velger hvilket vitnemål som legges til grunn

    Bakgrunn:
      Gitt jeg har rettighet til å se og endre søknadsbehandling ved organisasjonen som behandler saken

    Scenario: Velge vitnemålet som skal legges til grunn
      Gitt søkeren har flere elektroniske vitnemål
      Når jeg velger ett av vitnemålene
      Så er det valgte vitnemålet grunnlaget for poengberegningen
      # Skilt ut 08.10.2026: steget «Så vises fagene på det valgte vitnemålet»
      # er tatt ut her, fordi visningen av fagene hører til L3 (regelen
      # «Fagene på det valgte vitnemålet vises» i
      # velge_fag_per_poengvariant.feature).

    Scenario: Bytte til et annet vitnemål
      Gitt jeg har lagt et vitnemål til grunn
      Når jeg velger et annet vitnemål
      Så er det nye vitnemålet grunnlaget for poengberegningen
      Og poengene vises tomme til jeg velger å beregne dem
      # Endret 21.10.2026: poengene beregnes ikke av seg selv ved bytte, se
      # «Poengene er tomme til jeg beregner dem». Steget «Og det fremgår
      # hvilket vitnemål poengene nå bygger på» er tatt ut, fordi det er
      # dekket av «Se hvilket vitnemål et poeng bygger på».

    Scenario: Endringer på et vitnemål gjelder ikke for et annet vitnemål
      Gitt jeg har lagt et vitnemål til grunn
      Og jeg har gjort endringer i grunnlaget for vitnemålet
      Når jeg velger et annet vitnemål
      Så er endringene jeg gjorde for det forrige vitnemålet, ikke brukt i grunnlaget
      # AVKLART 21.10.2026: hver redigering hører til vitnemålet den er gjort
      # for. I L2 er det poeng saksbehandleren har lagt inn selv
      # («Legge inn <poengtype> selv på en poengvariant»). Fra L3 og L4 gjelder
      # det samme for fagvalg og manuelt innlagte eller endrede fag.

    Scenario: Endringer på et vitnemål huskes når jeg bytter tilbake
      Gitt jeg har gjort endringer i grunnlaget for et vitnemål
      Og jeg har byttet til et annet vitnemål
      Når jeg velger det forrige vitnemålet igjen
      Så er endringene jeg gjorde for det forrige vitnemålet, brukt i grunnlaget igjen
      # AVKLART 21.10.2026: redigeringene skal huskes når saksbehandleren
      # bytter vitnemål, så de ikke må gjøres på nytt.

    Scenario: Et annullert vitnemål kan ikke legges til grunn
      Gitt søkeren har et annullert vitnemål
      Og det annullerte vitnemålet er brukt i en beregning på dette opptaket
      Når jeg velger hvilket vitnemål som skal legges til grunn
      Så ser jeg ikke muligheten til å legge det annullerte vitnemålet til grunn
      # AVKLART 08.10.2026: et annullert vitnemål kan ikke legges til grunn
      # for en ny beregning. L1 (vise_elektroniske_vitnemål.feature, «Annullert
      # vitnemål som er brukt i en beregning vises») viser vitnemålet markert
      # som annullert, og plasserer denne begrensningen i L2.
      #
      # Steget «er brukt i en beregning» står med fordi det bare er da
      # vitnemålet vises. Et annullert vitnemål som ikke er brukt, vises ikke
      # i det hele tatt (L1, «Annullert vitnemål som ikke er brukt i en
      # beregning vises ikke»).

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

    Bakgrunn:
      Gitt jeg har rettighet til å se og endre søknadsbehandling ved organisasjonen som behandler saken

    Scenario: Poengene er tomme til jeg beregner dem
      Gitt jeg har lagt et vitnemål til grunn
      Når jeg endrer grunnlaget
      Så er poengene ikke beregnet på nytt
      Og poengene vises tomme
      Og endringen i grunnlaget er ikke lagret ennå
      # AVKLART 21.10.2026: poengene beregnes ikke av seg selv når grunnlaget
      # endres. Saksbehandleren må velge å beregne dem, og fram til da står
      # feltene tomme. Endringen lagres først når poengene er beregnet uten
      # feil. Hvordan saksbehandleren velger å beregne, hører i
      # velge_vitnemål_som_grunnlag.design.md.

    Scenario: Beregne poengene fra det endrede grunnlaget
      Gitt jeg har lagt et vitnemål til grunn
      Og jeg har endret grunnlaget
      Når jeg velger å beregne poengene
      Så er poengene beregnet på nytt fra det endrede grunnlaget
      Og endringen i grunnlaget er lagret

    Scenario: Advarsel om endringer som ikke er lagret
      Gitt jeg har endret grunnlaget
      Og jeg har ikke beregnet poengene etter endringen
      Når jeg går fra saken
      Så blir jeg advart om at endringen i grunnlaget ikke er lagret
      Og jeg kan velge å bli på saken
      # AVKLART 21.10.2026: endringen lagres først når poengene er beregnet
      # uten feil. Saksbehandleren skal derfor advares før de forlater saken
      # med endringer som ikke er lagret. Utformingen av advarselen hører i
      # velge_vitnemål_som_grunnlag.design.md.

    Scenario: Endringen avvises når poengberegningen feiler
      Gitt jeg har lagt et vitnemål til grunn
      Og jeg har endret grunnlaget
      Og poengberegningen feiler eller ikke svarer
      Når jeg velger å beregne poengene
      Så er det lagrede grunnlaget uendret
      Og jeg ser at endringen ikke ble gjennomført
      # AVKLART 08.10.2026: grunnlaget lagres ikke når kallet til Team Puffs
      # endepunkt feiler. Saksbehandleren må gjøre endringen på nytt senere.
      # Grunnlag og poeng er dermed aldri ute av takt.
      #
      # Endret 21.10.2026: kallet skjer når saksbehandleren velger å beregne
      # poengene, ikke når grunnlaget endres. Samme hensyn som
      # KregUtilgjengeligFeil i ny stack, som stopper behandlingen «for å
      # unngå behandling på mulig utdatert grunnlag». Utformingen av
      # beskjeden hører i velge_vitnemål_som_grunnlag.design.md.

    Scenario: Se de beregnede poengene
      Gitt jeg har lagt et vitnemål til grunn
      Og poengene er beregnet
      Når jeg åpner grunnlaget på søknaden
      Så ser jeg disse poengene hver for seg for hver poengvariant
        | poeng          |
        | Karakterpoeng  |
        | Realfagspoeng  |
        | Språkpoeng     |
      # AVKLART 21.10.2026: karakterpoeng, realfagspoeng og språkpoeng vises,
      # og hvert av dem har sitt eget felt. Alderspoeng og kjønnspoeng er ikke
      # relevante i vitnemålsbehandleren, og vises ikke her.

    Scenario: Bare poengvariantene for søknadsalternativene i saken vises
      Gitt søkeren har søknadsalternativer i flere saker
      Og poengene er beregnet
      Når jeg åpner grunnlaget på søknaden
      Så ser jeg bare poengvariantene som gjelder søknadsalternativene i saken
      # AVKLART 21.10.2026: bare poengvariantene som gjelder
      # søknadsalternativene i saken, skal vises. Simuleringen fant at poeng
      # fra andre saker i samme søknad ble vist (F1, STEK-593).

    Scenariomal: Legge inn <poengtype> selv på en poengvariant
      Gitt jeg har lagt et vitnemål til grunn
      Og jeg har lagt inn <poengtype> selv på en poengvariant
      Når jeg velger å beregne poengene
      Så er verdien jeg la inn for <poengtype>, brukt for poengvarianten
      Og alle poengene på poengvarianten er låst mot automatisk reberegning

      Eksempler:
        | poengtype     |
        | karakterpoeng |
        | realfagspoeng |
        | språkpoeng    |
      # AVKLART 07.10.2026: saksbehandleren kan legge inn realfagspoeng selv
      # på poengvarianten, i tillegg til å markere fag med forsøkskode (L4).
      # Poengene låses på samme måte som når grunnlaget velges, og kan låses
      # opp med «Låse opp et poeng».
      #
      # AVKLART 21.10.2026: utvidet fra bare realfagspoeng til alle tre
      # poengtypene som vises. Verdien saksbehandleren legger inn, er en
      # endring i grunnlaget, og lagres først når poengene er beregnet uten
      # feil. Det er alle poengene på poengvarianten som låses, ikke bare
      # poengtypen saksbehandleren la inn. Steget «Og det fremgår at
      # <poengtype> er satt av en saksbehandler» er tatt ut, se «Se hvilket
      # vitnemål et poeng bygger på».

    Scenariomal: Ugyldig verdi for <poengtype> stoppes
      Gitt jeg har lagt et vitnemål til grunn
      Når jeg legger inn en ugyldig verdi for <poengtype> på en poengvariant
      Så ser jeg at verdien er ugyldig
      Og jeg kan ikke beregne poengene før verdien er rettet

      Eksempler:
        | poengtype     |
        | realfagspoeng |
        | språkpoeng    |
      # AVKLART 21.10.2026: skjemaet skal stoppe ugyldige verdier, både for
      # realfagspoeng og språkpoeng. Grensene, for eksempel taket på
      # realfagspoeng, eies av Team Puff, så skjemaet må få dem derfra.
      # Utformingen av beskjeden hører i
      # velge_vitnemål_som_grunnlag.design.md.

    Scenario: Se hvilket vitnemål et poeng bygger på
      Gitt poengene er beregnet fra et vitnemål
      Når jeg ser poengene
      Så ser jeg hvilket vitnemål hvert poeng er beregnet fra
      # Verifisert i ny stack: Poeng har vitnemaalsnummer,
      # statusAutomatiskUtregnet og merknadAutomatisk, der den siste sier
      # «hvilken automatisk beregning som satte verdien, og hvilket vitnemål
      # som lå til grunn». Sporbarheten finnes allerede — kravet er at den
      # skal vises.
      #
      # AVKLART 21.10.2026: saksbehandleren trenger ikke se om et poeng er
      # beregnet automatisk eller satt av en saksbehandler. Steget «Og jeg ser
      # om poenget er beregnet automatisk eller satt av en saksbehandler» er
      # tatt ut.

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

    Scenario: Saksbehandler med endringsrettighet kan endre alt på saken
      Gitt jeg har rettighet til å endre søknadsbehandling ved organisasjonen som behandler saken
      Når jeg åpner søknaden til en søker
      Så kan jeg endre alt på saken
      # Skilt ut 08.10.2026: steget sa «Så kan jeg velge vitnemål, velge fag og
      # legge inn fag manuelt». Fagvalg og manuell inntasting kommer i L3 og
      # L4, så i L2 er det valget av vitnemål som kan etterprøves.
      #
      # AVKLART 21.10.2026: rettigheten til å endre søknadsbehandling
      # (MODIFISERE_SØKNADSBEHANDLING) gir lov til å endre alt på saken. I L2
      # er det å velge og bytte vitnemål, legge inn poeng selv, beregne
      # poengene og låse opp poeng. Fra L3 og L4 kommer fagvalg og manuelt
      # innlagte eller endrede fag i tillegg.

    Scenario: Saksbehandler med kun leserettighet ser grunnlaget
      Gitt jeg har rettighet til å se, men ikke til å endre, søknadsbehandling ved organisasjonen som behandler saken
      Når jeg åpner søknaden til en søker
      Så ser jeg søkerens vitnemål, det valgte grunnlaget og de beregnede poengene
      Men jeg ser ikke muligheten til å endre dem
      # At lesetilgang gir innsyn uten endringsmulighet er i tråd med
      # design-patterns-for-krav.md: det er *muligheten til å endre* som
      # skjules, ikke opplysningene. En saksbehandler som ser et poeng må
      # kunne se hva det bygger på.

    Scenario: Tilordning hindrer ikke at jeg behandler saken
      Gitt saken er tilordnet en annen saksbehandler
      Og jeg har rettighet til å endre søknadsbehandling ved organisasjonen som behandler saken
      Når jeg åpner søknaden til en søker
      Så kan jeg behandle vitnemålet
      # AVKLART 21.09.2026: tilgang styres av rettighet og organisasjon, ikke
      # av tilordning. Full begrunnelse i vise_elektroniske_vitnemål.feature.
      #
      # AVKLART 21.10.2026: endrer to saksbehandlere grunnlaget i samme sak
      # samtidig, gjelder den siste endringen. Hvem som har endret hva,
      # ivaretas med logging.
