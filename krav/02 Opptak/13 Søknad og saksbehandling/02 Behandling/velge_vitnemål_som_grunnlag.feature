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
  Denne leveransen lar saksbehandleren legge et vitnemål til grunn for hver
  poengvariantskombinasjon (poengvariant, kompetansekrav og grunnlag) i saken, og viser
  poengene som er beregnet fra det. Poengvariantskombinasjonene kan bygge på ulike
  vitnemål. Valget lagres når saksbehandleren velger å bruke poengene, og
  låser poengene mot automatisk reberegning.

  Valget gjelder hele vitnemålet. Å velge fag kommer i L3
  (velge_fag_per_poengvariant.feature), endring av fag i L4a
  (endre_fag_i_grunnlaget.feature), og manuell inntasting av fag i L4b
  (legge_inn_vitnemål_manuelt.feature). Visningen av vitnemålene er L1
  (vise_elektroniske_vitnemål.feature).

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

    # AVKLART 13.11.2026 (etter verify-rapporten 12.11.2026): vitnemålet
    # legges til grunn per poengvariantskombinasjon (poengvariant, kompetansekrav og
    # grunnlag), ikke ett vitnemål for hele saken. Saksbehandleren velger
    # vitnemålet og hvilke poengvariantskombinasjoner det gjelder. To poengvariantskombinasjoner med
    # samme poengvariant kan bygge på ulike vitnemål, og poengene lagres per
    # poengvariantskombinasjon.

    Scenario: Velge vitnemålet som skal legges til grunn
      Gitt søkeren har flere elektroniske vitnemål
      Når jeg velger ett av vitnemålene
      Og jeg velger hvilke poengvariantskombinasjoner vitnemålet skal legges til grunn for
      Så er det valgte vitnemålet grunnlaget for poengberegningen i poengvariantskombinasjonene jeg valgte
      Og poengene er beregnet fra det valgte vitnemålet
      Men valget er ikke lagret før jeg velger å bruke poengene
      # Skilt ut 08.10.2026: steget «Så vises fagene på det valgte vitnemålet»
      # er tatt ut her, fordi visningen av fagene hører til L3 (regelen
      # «Fagene på det valgte vitnemålet vises» i
      # velge_fag_per_poengvariant.feature).

    Scenario: Bytte til et annet vitnemål
      Gitt jeg har lagt et vitnemål til grunn for en poengvariantskombinasjon
      Når jeg legger et annet vitnemål til grunn for poengvariantskombinasjonen
      Så er det nye vitnemålet grunnlaget for poengberegningen i poengvariantskombinasjonen
      Og poengene er beregnet fra det nye vitnemålet
      Men valget er ikke lagret før jeg velger å bruke poengene
      # AVKLART 11.11.2026 (gjennomgang med domeneekspertene): poengene for
      # vitnemålet vises med en gang, fordi de er kjent fra vitnemålslisten
      # (L1), men valget lagres først når saksbehandleren velger å bruke
      # poengene («Poengene beregnes og lagres når saksbehandleren bruker
      # dem»). Erstatter avklaringen 30.10.2026 om at valget lagres med en
      # gang. Steget «Og det fremgår hvilket vitnemål poengene nå bygger på»
      # er tatt ut, fordi det er dekket av «Se hvilket vitnemål et poeng
      # bygger på».

    Scenario: Legge ulikt vitnemål til grunn for ulike poengvariantskombinasjoner
      Gitt søkeren har to elektroniske vitnemål
      Når jeg legger det ene vitnemålet til grunn for én poengvariantskombinasjon
      Og jeg legger det andre vitnemålet til grunn for en annen poengvariantskombinasjon
      Så er poengene i hver poengvariantskombinasjon beregnet fra vitnemålet som er lagt til grunn for poengvariantskombinasjonen
      # AVKLART 13.11.2026: gjelder også poengvariantskombinasjoner med samme
      # poengvariant. Koden for L2 velger allerede vitnemålet per poengvariantskombinasjon
      # (verify-rapporten 12.11.2026, «Kravet er bak koden»). Hvordan fagvalget
      # følger vitnemålet i hver poengvariantskombinasjon, står i L3
      # (velge_fag_per_poengvariant.feature).

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
    # at noe lagres. Når og hvordan poengene beregnes og lagres, står i regelen
    # «Poengene beregnes og lagres når saksbehandleren bruker dem». Hvordan
    # poengene regnes ut (hvilke karakterer som teller, avrunding, satser og
    # tak) hører ikke til dette kravet.
    #
    # Endret 11.11.2026: reglene for beregning og lagring er flyttet tilbake
    # hit fra L3, i en egen regel.
    #
    # Endret 30.10.2026: scenarioene «Poengene er tomme til jeg beregner dem»,
    # «Beregne poengene fra det endrede grunnlaget» og «Advarsel om endringer
    # som ikke er lagret» er flyttet til L3. «Endringen avvises når
    # poengberegningen feiler» er fjernet: poengberegningen er ikke en ekstern
    # tjeneste som kan la være å svare.

    Bakgrunn:
      Gitt jeg har rettighet til å se og endre søknadsbehandling ved organisasjonen som behandler saken

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - FS-klienten viser både karakterpoeng og karakterpoeng med
    #   forbedring, når søkeren konkurrerer både med det opprinnelige og det
    #   forbedrede vitnemålet (teknisk beskrivelse av vitnemålsbehandling,
    #   G. M. Vangen). Er det dekket av at hver poengvariant har sine egne
    #   poeng, eller skal karakterpoeng med forbedring vises som eget felt?
    #   Svaret avgjør også avviket mot feltene «Poeng fra vitnemål» i
    #   skissen.
    Scenario: Se de beregnede poengene
      Gitt jeg har lagt et vitnemål til grunn
      Og poengene er beregnet
      Når jeg åpner grunnlaget på søknaden
      Så ser jeg disse poengene hver for seg for hver poengvariantskombinasjon
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
      # AVKLART 10.11.2026 (svar 20): behandlerne ser vurderingen og poengene i hverandres saker på samme søknad,
      # men i saken hos den andre organisasjonen, ikke i grunnlaget i sin egen sak. Scenarioet over står derfor.
      # Innsynet står i @OPT-BEH-BEH-011, regelen «Saksbehandlende organisasjoner på samme søknad ser vurderingen
      # og poengene i hverandres saker».

    Scenario: Se hvilket vitnemål et poeng bygger på
      Gitt poengene er beregnet fra et vitnemål
      Når jeg ser poengene
      Så ser jeg hvilket vitnemål poengene i hver poengvariantskombinasjon er beregnet fra
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

  Regel: Poengene beregnes og lagres når saksbehandleren bruker dem

    # Poengene beregnes av kontrollmotoren i opptak, i samme løsning.
    # Saksbehandleren setter sammen grunnlaget (vitnemål, og fra L3
    # poengvariant, fag, forbedringer og tilleggsfag), og har to handlinger:
    # å beregne poengene, som viser poengene uten å lagre, og å bruke
    # poengene, som kontrollerer grunnlaget med kontrollmotoren, beregner
    # poengene og lagrer grunnlaget og poengene. Sakens poeng bygger dermed
    # aldri på et grunnlag som er halvveis satt sammen.
    #
    # AVKLART 11.11.2026 (gjennomgang av L3 og L4 med domeneekspertene): to
    # handlinger, som «Beregn» og «Bruk BeregnP» i FS-klienten (teknisk
    # beskrivelse av vitnemålsbehandling, G. M. Vangen). Regelen er flyttet
    # tilbake hit fra L3 (velge_fag_per_poengvariant.feature), og gjelder også
    # L3, L4a og L4b. Erstatter avklaringen 04.11.2026 om at poengene beregnes
    # fortløpende hver gang grunnlaget endres. Navnene på handlingene hører i
    # velge_vitnemål_som_grunnlag.design.md.
    #
    # Historikk: regelen ble flyttet fra L2 til L3 30.10.2026, og endret
    # 04.11.2026 til fortløpende beregning.

    Bakgrunn:
      Gitt jeg har rettighet til å se og endre søknadsbehandling ved organisasjonen som behandler saken

    Scenario: Beregne poengene uten å lagre
      Gitt jeg har endret grunnlaget for en poengvariantskombinasjon
      Når jeg velger å beregne poengene
      Så ser jeg poengene beregnet fra det endrede grunnlaget
      Men grunnlaget og poengene er ikke lagret ennå

    Scenario: De lagrede poengene vises til jeg beregner på nytt
      Gitt jeg har endret grunnlaget for en poengvariantskombinasjon
      Og jeg har ikke beregnet poengene etter endringen
      Når jeg ser poengene på poengvariantskombinasjonen
      Så ser jeg de sist lagrede poengene uendret
      # AVKLART 11.11.2026 (gjennomgang med domeneekspertene): poengene
      # endres ikke før saksbehandleren beregner dem, og de merkes ikke som
      # utdaterte. Erstatter avklaringen 21.10.2026 om at poengene står tomme
      # til saksbehandleren beregner dem.

    Scenario: Bruke poengene
      Gitt jeg har endret grunnlaget for en poengvariantskombinasjon
      Når jeg velger å bruke poengene
      Så er grunnlaget kontrollert av kontrollmotoren
      Og poengene er beregnet fra grunnlaget
      Og grunnlaget og poengene er lagret på poengvariantskombinasjonen

    Scenario: Advarsel om endringer som ikke er lagret
      Gitt jeg har endret grunnlaget for en poengvariantskombinasjon
      Og jeg har ikke brukt poengene etter endringen
      Når jeg går fra saken
      Så blir jeg advart om at endringen i grunnlaget ikke er lagret
      Og jeg kan velge å bli på saken
      # AVKLART 21.10.2026: saksbehandleren skal advares før de forlater
      # saken med endringer som ikke er lagret. Utformingen av advarselen
      # hører i implementasjonsdetaljene.
      #
      # Endret 11.11.2026: endringen lagres når saksbehandleren velger å
      # bruke poengene.

    Scenario: Grunnlaget kontrolleres mot vitnemålskravene når poengene brukes
      Gitt jeg har endret grunnlaget
      Og grunnlaget oppfyller ikke vitnemålskravene
      Når jeg velger å bruke poengene
      Så ser jeg at grunnlaget ikke oppfyller vitnemålskravene
      Og jeg kan velge å bruke poengene likevel
      # Forslag fra FS-klienten (teknisk beskrivelse av vitnemålsbehandling,
      # G. M. Vangen, lest 03.11.2026): «Bruk BeregnP» kjører NVB-kontrollen
      # på vitnemålet slik saksbehandleren har endret det, og spør om
      # poengene skal lagres når kontrollen feiler.
      #
      # AVKLART 04.11.2026: grunnlaget kontrolleres mot vitnemålskravene når
      # saksbehandleren lagrer det. Feiler kontrollen, ser saksbehandleren
      # hvorfor, og kan velge å lagre grunnlaget likevel, for eksempel ved
      # dispensasjon. Het «Grunnlaget kontrolleres mot vitnemålskravene når
      # det lagres» til 11.11.2026.

    Scenario: Kontrollere grunnlaget mot vitnemålskravene uten å lagre
      Gitt jeg har endret grunnlaget
      Når jeg velger å kontrollere grunnlaget mot vitnemålskravene
      Så ser jeg om grunnlaget oppfyller vitnemålskravene
      Men endringen i grunnlaget er ikke lagret ennå
      # AVKLART 04.11.2026: saksbehandleren kan kontrollere grunnlaget med en
      # egen handling, uten å lagre, som med «NVB-kontroll» i FS-klienten
      # (teknisk beskrivelse av vitnemålsbehandling, G. M. Vangen).

    Scenario: Advarsel om vitnemål med dispensasjon
      Gitt søkeren har et vitnemål som er utstedt med dispensasjon
      Når jeg legger vitnemålet til grunn
      Så ser jeg at vitnemålet er utstedt med dispensasjon
      Og jeg kan bruke poengene
      # Forslag fra FS-klienten (samme kilde): et vitnemål med dispensasjon
      # gir advarselen «Dette er et vitnemål med dispensasjon», og
      # behandlingen fortsetter.
      #
      # AVKLART 04.11.2026: saksbehandleren advares når vitnemålet er utstedt
      # med dispensasjon, men advarselen stopper ingenting. Den forklarer
      # hvorfor kontrollen mot vitnemålskravene kan feile. Teksten hører i
      # implementasjonsdetaljene.

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
      # er det å velge og bytte vitnemål, beregne og bruke poengene og låse
      # opp poeng. Fra L3 og L4 kommer fagvalg, poeng saksbehandleren legger
      # inn selv, og manuelt innlagte eller endrede fag i tillegg (endret
      # 13.11.2026: å legge inn poeng selv er flyttet til L3 11.11.2026).

    Scenario: Saksbehandler med kun leserettighet ser grunnlaget
      Gitt jeg har rettighet til å se, men ikke til å endre, søknadsbehandling ved organisasjonen som behandler saken
      Når jeg åpner søknaden til en søker
      Så ser jeg søkerens vitnemål, det valgte grunnlaget og de beregnede poengene
      Og jeg ser hvilke valg som er gjort i grunnlaget, men kan ikke endre dem
      Men jeg ser ikke muligheten til å beregne eller bruke poengene
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
