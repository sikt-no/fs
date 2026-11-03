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
  hele saken, og viser poengene som er beregnet fra det. Valget lagres med en
  gang, og låser poengene mot automatisk reberegning.

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
      Og poengene er beregnet fra det valgte vitnemålet
      # Skilt ut 08.10.2026: steget «Så vises fagene på det valgte vitnemålet»
      # er tatt ut her, fordi visningen av fagene hører til L3 (regelen
      # «Fagene på det valgte vitnemålet vises» i
      # velge_fag_per_poengvariant.feature).

    Scenario: Bytte til et annet vitnemål
      Gitt jeg har lagt et vitnemål til grunn
      Når jeg velger et annet vitnemål
      Så er det nye vitnemålet grunnlaget for poengberegningen
      Og poengene er beregnet fra det nye vitnemålet
      # Endret 30.10.2026: poengene beregnes og lagres med en gang
      # saksbehandleren velger et vitnemål. Poengberegningen er en del av
      # opptak, og poengene for hvert vitnemål er kjent fra vitnemålslisten
      # (L1). Å beregne først når saksbehandleren sier at grunnlaget er klart,
      # hører til L3, der grunnlaget settes sammen i flere steg. Steget «Og
      # det fremgår hvilket vitnemål poengene nå bygger på» er tatt ut, fordi
      # det er dekket av «Se hvilket vitnemål et poeng bygger på».

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

  @ref-OPT-BEH-BEH-018 @ref-OPT-BEH-BEH-005
  Regel: Poeng beregnes fra det valgte grunnlaget

    # Poengene beregnes av kontrollmotoren i opptak, i samme løsning. Karakter-,
    # realfags- og språkpoengene for hvert vitnemål vises i vitnemålslisten uten
    # at noe lagres. Når saksbehandleren setter sammen grunnlaget (poengvariant,
    # fag, forbedringer og tilleggsfag), beregnes og lagres poengene først når
    # saksbehandleren sier at grunnlaget er klart, så sakens poeng aldri bygger
    # på et grunnlag som er halvveis satt sammen.
    #
    # I L2 er grunnlaget det valgte vitnemålet, og poengene beregnes og lagres
    # med en gang. Å beregne når grunnlaget er klart, står i L3
    # (velge_fag_per_poengvariant.feature). Hvordan poengene regnes ut
    # (hvilke karakterer som teller, avrunding, satser og tak) hører ikke til
    # dette kravet.
    #
    # Endret 30.10.2026: scenarioene «Poengene er tomme til jeg beregner dem»,
    # «Beregne poengene fra det endrede grunnlaget» og «Advarsel om endringer
    # som ikke er lagret» er flyttet til L3. «Endringen avvises når
    # poengberegningen feiler» er fjernet: poengberegningen er ikke en ekstern
    # tjeneste som kan la være å svare.

    Bakgrunn:
      Gitt jeg har rettighet til å se og endre søknadsbehandling ved organisasjonen som behandler saken

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
      Når jeg legger inn <poengtype> selv på en poengvariant
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
      # poengtypene som vises. Det er alle poengene på poengvarianten som låses, ikke bare
      # poengtypen saksbehandleren la inn. Steget «Og det fremgår at
      # <poengtype> er satt av en saksbehandler» er tatt ut, se «Se hvilket
      # vitnemål et poeng bygger på».
      #
      # Endret 30.10.2026: verdien lagres når saksbehandleren legger den inn,
      # som valget av vitnemål. Spørsmålet om en verdi saksbehandleren har
      # lagt inn selv, skal overskrives når poengene beregnes på nytt, er
      # flyttet til L3, sammen med beregningen.

    Scenariomal: Ugyldig verdi for <poengtype> stoppes
      Gitt jeg har lagt et vitnemål til grunn
      Når jeg legger inn en ugyldig verdi for <poengtype> på en poengvariant
      Så ser jeg at verdien er ugyldig
      Og verdien er ikke lagret

      Eksempler:
        | poengtype     |
        | realfagspoeng |
        | språkpoeng    |
      # AVKLART 21.10.2026: skjemaet skal stoppe ugyldige verdier, både for
      # realfagspoeng og språkpoeng. Grensene, for eksempel taket på
      # realfagspoeng, står på poengtypen i opptak, så skjemaet må få dem
      # derfra. Utformingen av beskjeden hører i
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
      Og jeg ser hvilke valg som er gjort i grunnlaget, men kan ikke endre dem
      Men jeg ser ikke muligheten til å beregne poengene eller legge inn poeng selv
      # At lesetilgang gir innsyn uten endringsmulighet er i tråd med
      # design-patterns-for-krav.md: det er *muligheten til å endre* som
      # skjules, ikke opplysningene. En saksbehandler som ser et poeng må
      # kunne se hva det bygger på.
      #
      # AVKLART 28.10.2026: valg som viser en tilstand (radioknapper og
      # avkrysningsbokser, f.eks. valgt vitnemål, poengvariant og fag), vises
      # for en saksbehandler med bare leserettighet, men kan ikke brukes.
      # Handlinger og felt for å legge inn eller endre verdier skjules, og de
      # lagrede verdiene vises som tekst. Avviker bevisst fra «manglende
      # tilgang skjuler elementet»: valgene er informasjon (de viser hva
      # poengene bygger på), og siden ser lik ut for alle. Gjelder hele
      # vitnemålsbehandlingen, L1–L6, se vitnemålsbehandling.md. Utformingen
      # står i velge_vitnemål_som_grunnlag.design.md.

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
