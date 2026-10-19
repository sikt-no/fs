# language: no
# GitHub: #560
#
# TILFØYD 16.09.2026: sju av de opprinnelige åpne spørsmålene er lukket ved å
# lese ut dagens implementasjon fra FS-klientens kildekode
# (gitlab.sikt.no/fs/fs-klient, master @ 64d1e0b, PowerBuilder). Regnereglene,
# datamodellen og overlappslogikken er dokumentert med filreferanser i
# registrere_praksis.dagens-løsning-i-fs-klienten.md, som ligger ved siden av
# denne filen. Hver lukket avklaring under viser til den.
#
# Valg av enhet (år), overlappsløsningen med to summer, og strukturen for
# øvrig er beholdt som den ble godkjent — tilføyelsene er regneregler og
# avklaringer, ikke omskriving.
#
# VIKTIG OM BRUKEN AV FS-KLIENTEN SOM KILDE: den er kilde til *regler* —
# hvordan praksis faktisk regnes ut i dag — og ikke en mal for hvordan dette
# skal bygges. Ny funksjonalitet hører i brukerflaten FS Admin, ikke i
# FS-klienten. Referanser til tabeller, kolonner og Oracle-funksjoner står
# her for at påstandene skal kunne etterprøves, aldri som føring for
# datamodell eller teknologi. Der dagens løsning gjør noe fordi teknologien
# tilfeldigvis gjør det slik, er det flagget som et åpent spørsmål framfor å
# bli arvet.
#
# TILFØYD 29.09.2026: de åpne spørsmålene er besluttet i avklaringsmøte
# (beslutningssiden «Registrere og beregne praksis: åpne spørsmål», med
# innspill fra Jøran). Situasjonene A–F og spørsmål 1–8 der er ført inn her
# som AVKLART-kommentarer ved scenarioet de gjelder. Ett nytt spørsmål kom fram
# under innføringen (standardverdi for relevans), og er avklart samme dag:
# en ny praksisperiode er relevant som standard.
#
# ENDRET 02.10.2026 etter tilbakemeldinger på kravet: praksiskalkulatoren har
# ingen tilknytning til dokumentasjon (scenarioet er @wont), antall timer er
# påkrevd når omfanget oppgis i timer, og relevansmarkeringen heter nå
# «Inkluder». AVKLART-kommentarer fra før 02.10.2026 bruker det gamle ordet
# «relevant» om det samme valget. Praksistype er fortsatt en del av denne
# kapabiliteten (besluttet i teamet 06.10.2026).
#
@OPT-BEH-BEH-003 @must @in-progress
Egenskap: Registrere og beregne praksis for søker
  Som saksbehandler i opptak
  ønsker jeg å registrere søkerens praksisperioder og få dem summert
  slik at jeg kan avgjøre om søkeren oppfyller opptakskrav som krever praksis.

  Praksisberegningen er relevant når et utdanningstilbud har relevant praksis
  som opptakskrav, eller i vurdering av realkompetanse. Master i
  anestesisykepleie krever for eksempel bachelorgrad i sykepleie,
  autorisasjon som sykepleier og minimum to års arbeidserfaring som
  sykepleier. Dokumentasjonen som kreves er typisk
  bekreftelse fra arbeidsgiver.

  Utregningen er knotete å gjøre manuelt fordi søkeren ofte har dokumentert
  flere arbeidsforhold med ulik stillingsprosent, og fordi arbeidsgivere
  dokumenterer omfanget enten som stillingsprosent eller som et antall timer.
  Saksbehandleren registrerer derfor hvert dokumenterte arbeidsforhold med
  periode og omfang, og systemet regner ut hvor mange års praksis det
  tilsvarer til sammen. Om søkeren oppfyller opptakskravet, vurderer
  saksbehandleren. Kobling til opptakskrav er beskrevet i
  knytte_praksis_til_opptakskrav.feature (@OPT-BEH-BEH-006).

  Praksis beregnes proporsjonalt: periodens kalendertid ganget med
  stillingsprosenten. To år i 50 % stilling gir ett år praksis. Perioder
  oppgitt i timer beregnes som antall timer delt på antall timer per årsverk.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg har rollen søknadsbehandler
    Og jeg behandler en sak på søknaden til en søker

  Regel: Praksisperioder registreres manuelt på saken

    Scenario: Registrere en praksisperiode
      Når jeg registrerer en praksisperiode med type, startdato og sluttdato
      Så er praksisperioden lagret på saken
      Og praksisperioden inngår i den samlede praksisberegningen

    Scenario: Praksisperioder hører til saken de er registrert på
      Gitt søknaden til søkeren har to saker
      Og jeg har registrert en praksisperiode på den ene saken
      Når jeg åpner praksisberegningen på den andre saken
      Så inngår ikke praksisperioden i praksisberegningen på den saken
      # AVKLART 23.09.2026: praksisperioder registreres på saken, ikke på
      # personen eller søknaden, jf. innspill i løsningsforslaget (Confluence
      # PFS 4996071435): «hugs at ein søknad kan ha fleire saker med ulike
      # saksbehandlarar». Dette er en endring fra FS-klienten, der
      # PERSONPRAKSIS er nøklet på person.

    Scenario: Praksis fra andre saker vises ikke
      Gitt det er registrert praksisperioder på en annen sak for samme søker
      Når jeg åpner praksisberegningen på denne saken
      Så inngår ingen av praksisperiodene fra den andre saken
      Og det fremgår ikke at det finnes praksis på andre saker
      # AVKLART 29.09.2026 (situasjon C): alternativ (a) — en tom kalkulator,
      # uten tegn til at praksis er registrert andre steder — i denne
      # leveransen. Gjelder både en annen sak på samme søknad og en sak i et
      # senere opptak.
      #
      # Innspill fra Jøran: alternativ (c) — hente inn perioder fra en annen
      # sak som en egen kopi — er ønskelig, og flyttes ut i en egen sak.
      # Alternativ (b) og (c) kan da justeres til at saksbehandleren kan hente
      # opplysningene bare hvis hen har tilgang til å lese den andre saken.
      # Alternativ (d), felles registrering på tvers av saker, er forkastet:
      # det bryter med at saker behandles hver for seg, og med klagebehovet.

    Scenario: Registrert praksis ligger fast på saken
      Gitt jeg har registrert praksisperioder på saken
      Og jeg har valgt hvilke praksisperioder som er inkludert
      Når jeg åpner praksisberegningen på den samme saken senere
      Så ser jeg de samme praksisperiodene med samme omfang og samme valg av hvilke som er inkludert
      Og samlet praksis er den samme som da jeg forlot saken
      # AVKLART 29.09.2026 (situasjon A): bekreftet.

    Scenario: Se registrerte praksisperioder
      Gitt saken har registrerte praksisperioder
      Når jeg åpner praksisberegningen
      Så ser jeg hver praksisperiode med følgende opplysninger
        | felt             |
        | Arbeidsgiver     |
        | Type             |
        | Startdato        |
        | Sluttdato        |
        | Omfang           |
        | Beregnet praksis |

    Scenario: Velge praksistype for en praksisperiode
      Når jeg registrerer en praksisperiode
      Så kan jeg velge blant alle praksistyper som gjelder for søkere
      # AVKLART 16.09.2026: typene er en fast kodeliste — det felles
      # praksistypekodeverket. Valglisten er alle typer med
      # status_gjelder_soker = J, uten ytterligere filtrering. Det inkluderer
      # typer som beskriver studiepraksis i et utdanningsløp
      # («Grunnskolepraksis 1-7», «Praksis i psykiatri - medisinstudiet») og
      # ikke arbeidserfaring.
      #
      # Begrunnelse: løsningen skal være generell. Kalkulatoren skal kunne
      # brukes til ulike beregninger — både spesielle opptakskrav og
      # realkompetanse — og hva som er *relevant* praksis for det enkelte
      # kravet er saksbehandlerens vurdering, ikke systemets.
      #
      # Typen har ingen betydning for beregningen; den dokumenterer hva
      # praksisen besto i. Verifisert i FS-klienten: beregningen bruker bare
      # datoer, stillingsprosent og timer.
      #
      # Merk at status_valgbar_sokere = N for samtlige typer i kodeverket, så
      # det er saksbehandleren og ikke søkeren som velger type.

    Scenario: Inkludere en praksisperiode i praksisberegningen
      Gitt jeg har registrert en praksisperiode
      Når jeg inkluderer praksisperioden
      Så inngår praksisperioden i den samlede praksisberegningen
      # ENDRET 02.10.2026: markeringen heter «Inkluder», ikke «relevant»
      # (tilbakemelding på kravet). Det er det samme valget som
      # relevansflagget i avklaringene under: ett valg per periode, som
      # filtrerer før overlappsberegningen. Om praksisen er relevant for et
      # bestemt opptakskrav, hører til knytte_praksis_til_opptakskrav.feature.
      #
      # AVKLART 29.09.2026 (spørsmål 4): alternativ (1) — ett relevansflagg
      # per periode, som filtrerer *før* overlappsberegningen. Da blir det to
      # summer, oppgitt og justert for overlapp, og begge regnes bare av de
      # relevante periodene. Alternativ (2), ingen relevansmarkering, og (3),
      # relevant og total sum i tillegg til overlappssummene, er forkastet.
      #
      # Bakgrunn: PERSONPRAKSIS i FS-klienten har status_relevant (J/N), og
      # relevansmarkeringen lar saksbehandleren regne ut praksis for ulike
      # formål uten å slette rader.
      #
      # AVKLART 29.09.2026 (situasjon D): kalkulatoren knyttes ikke til
      # opptakskrav i denne omgangen. Det er én relevansmarkering per periode,
      # ikke én per opptakskrav. Relevans for et bestemt opptakskrav hører til
      # knytte_praksis_til_opptakskrav.feature.

    Scenario: Praksisperioder som ikke er inkludert, telles ikke med
      Gitt saken har følgende praksisperioder
        | startdato  | sluttdato  | omfang | inkludert |
        | 01.01.2020 | 31.12.2020 | 100 %  | ja        |
        | 01.01.2021 | 31.12.2021 | 100 %  | nei       |
      Når jeg åpner praksisberegningen
      Så er samlet praksis 1,00 år

    Scenario: Overlapp beregnes bare mellom inkluderte praksisperioder
      Gitt saken har følgende praksisperioder
        | startdato  | sluttdato  | omfang | inkludert |
        | 01.01.2020 | 31.12.2020 | 50 %   | ja        |
        | 01.01.2020 | 31.12.2020 | 60 %   | nei       |
      Når jeg åpner praksisberegningen
      Så er sum av oppgitte perioder 0,50 år
      Og sum justert for overlapp er 0,50 år

    Scenario: En ny praksisperiode er inkludert som standard
      Når jeg registrerer en praksisperiode
      Så er praksisperioden inkludert
      Og praksisperioden inngår i den samlede praksisberegningen
      # AVKLART 29.09.2026: en ny praksisperiode er markert som relevant når
      # den registreres. Saksbehandleren fjerner markeringen for perioder
      # som ikke skal telle. Da gir en glemt markering aldri for lav sum.

    Scenario: Startdato og sluttdato er obligatorisk
      Når jeg registrerer en praksisperiode
      Så må jeg oppgi startdato
      Og jeg må oppgi sluttdato
      Men praksistype er valgfri
      # AVKLART 16.09.2026: verifisert i FS-klienten — kun praksistypekode og
      # dato_fra er obligatoriske felt. Sluttdato, stillingsprosent og
      # omfang kan alle stå tomme.
      #
      # ENDRET 29.09.2026: praksistype er valgfri, besluttet ved validering
      # av skissen «Skisse til claude» (spec-registrere-praksis.md, avvik 1,
      # og beslutningspunkt 1). Dette er en endring fra FS-klienten, der
      # praksistype er obligatorisk.
      #
      # ENDRET 29.09.2026: sluttdato er obligatorisk (spørsmål 8). Se
      # «Praksisperiode uten sluttdato kan ikke lagres».

    Scenario: Oppgi arbeidsgiver for en praksisperiode
      Når jeg registrerer en praksisperiode
      Så kan jeg oppgi arbeidsgiver
      Men arbeidsgiver er valgfri
      # AVKLART 29.09.2026: arbeidsgiver legges til som valgfritt felt, i
      # registreringen og i listen over registrerte praksisperioder.
      # Besluttet ved validering av skissen «Skisse til claude»
      # (spec-registrere-praksis.md, avvik 2, og beslutningspunkt 2).

    Scenario: Praksisperiode uten sluttdato kan ikke lagres
      Gitt jeg registrerer en praksisperiode
      Når jeg ikke oppgir sluttdato
      Så får jeg en feilmelding om at sluttdato må oppgis
      Og praksisperioden kan ikke lagres
      # ENDRET 29.09.2026 (spørsmål 8): en praksisperiode kan ikke lagres uten
      # sluttdato, fordi en periode uten sluttdato kompliserer mye. Dette
      # erstatter de tidligere scenarioene «Registrere praksisperiode uten
      # sluttdato» og «Varsel når praksisperioden lagres uten sluttdato».
      #
      # Konsekvens for løpende arbeidsforhold: saksbehandleren må oppgi en
      # sluttdato for å få registrert perioden. Sluttdato fram i tid er
      # tillatt, se «Sluttdato fram i tid regnes som oppgitt».
      #
      # Dette er en endring fra FS-klienten, der perioden kan lagres uten
      # sluttdato og da ikke får noen beregnet praksis.

    Scenario: Sluttdato før startdato kan ikke lagres
      Gitt jeg registrerer en praksisperiode
      Når jeg oppgir en sluttdato som er før startdatoen
      Så får jeg en feilmelding om at sluttdatoen ikke kan være før startdatoen
      Og praksisperioden kan ikke lagres

    Scenario: Ugyldig dato kan ikke lagres
      Gitt jeg registrerer en praksisperiode
      Når jeg oppgir en dato som ikke finnes
      Så får jeg en feilmelding om at datoen er ugyldig
      Og praksisperioden kan ikke lagres
      # AVKLART 16.09.2026: ugyldige datoer og sluttdato før startdato skal
      # varsles med feilmelding, og registreringen skal ikke kunne lagres.
      #
      # Dette er en endring fra dagens løsning. Verifisert i FS-klienten
      # valideres bare at de obligatoriske feltene *finnes* — ikke at datoene
      # er i rekkefølge. Negativ varighet er altså mulig i FS i dag.
      #
      # Merk at startdato lik sluttdato fortsatt er gyldig; det gir én dag
      # praksis. Det er bare sluttdato *før* startdato som avvises.

    Scenario: Sluttdato fram i tid regnes som oppgitt
      Gitt dagens dato er 23.09.2026
      Når jeg registrerer en praksisperiode fra 01.01.2026 til 31.12.2026
      Og jeg oppgir omfanget som stillingsprosent 100 %
      Så beregnes praksisperioden til 1,00 år
      # AVKLART 23.09.2026: dagens adferd videreføres. En sluttdato fram i
      # tid avvises ikke, og perioden regnes fram til den oppgitte
      # sluttdatoen — ikke til dagens dato eller til søknadsfristen. Det er
      # saksbehandlerens ansvar å vurdere om framtidig praksis skal legges
      # til grunn.
      #
      # 29.09.2026: sluttdato er nå obligatorisk. For et løpende
      # arbeidsforhold er en sluttdato fram i tid måten å registrere perioden
      # på.

    @wont
    Scenario: Knytte praksisperioden til dokumentasjon på søknaden
      Gitt søkeren har lagt ved dokumentasjon på et arbeidsforhold i søknaden
      Når jeg knytter dokumentasjonen til praksisperioden
      Så ser jeg hvilken dokumentasjon praksisperioden bygger på
      Og jeg kan åpne dokumentasjonen fra praksisperioden
      # ENDRET 02.10.2026: praksiskalkulatoren skal ikke ha noen tilknytning
      # til dokumentasjon (tilbakemelding på kravet). Prioriteten er endret
      # fra @could til @wont. Scenarioet beholdes som dokumentert ønske, men
      # skal ikke implementeres.
      #
      # UTSATT 23.09.2026: ikke med i første leveranse. Scenarioet beholdes
      # her som krav med lavere prioritet, og tas med i en senere leveranse.
      #
      # Avklart 16.09.2026 om innholdet: dersom praksis skal kunne knyttes
      # til dokumentasjon, er det dokumentasjon som er lagt ved *søknaden* —
      # det søkeren selv har lastet opp. Koblingen er valgfri; en
      # praksisperiode kan registreres uten. Jira ADMI-45 «Koble
      # dokumentasjon på yrkespraksis til praksiskalkulator» ber om nettopp
      # dette.
      #
      # Merk at FS-klienten har en tilsvarende kobling
      # (PERSONPRAKSIS.dokumentnr mot DOKUMENTARKIV). Det er *ikke* et
      # argument for hvordan dette skal løses — ny funksjonalitet bygges i
      # brukerflaten FS Admin, ikke i FS-klienten, og dokumentmodellen der er
      # søknadsdokumentasjon.

    # FJERNET 29.09.2026 (spørsmål 8): scenarioet «Se hvem som registrerte en
    # praksisperiode» er tatt ut. Hvem som opprettet og sist endret en
    # periode, og når, håndteres globalt av en sporingslogg, og er ikke et
    # eget krav til praksiskalkulatoren. FS-klienten har feltene
    # saksbehinit_opprettet, saksbehinit_endret, dato_opprettet og
    # dato_endret på PERSONPRAKSIS.

  Regel: Omfanget av en praksisperiode oppgis som stillingsprosent eller som antall timer

    Scenariomal: Praksis beregnes proporsjonalt med stillingsprosenten
      Gitt jeg registrerer en praksisperiode fra <startdato> til <sluttdato>
      Når jeg oppgir omfanget som stillingsprosent <stillingsprosent>
      Så beregnes praksisperioden til <praksis>

      Eksempler:
        | startdato  | sluttdato  | stillingsprosent | praksis |
        | 01.01.2020 | 31.12.2021 | 100 %            | 2,00 år |
        | 01.01.2020 | 31.12.2021 | 50 %             | 1,00 år |
        | 01.01.2020 | 30.06.2020 | 80 %             | 0,40 år |
        | 01.01.2020 | 31.12.2021 | 0 %              | 0,00 år |

    Scenariomal: Timebasert praksis beregnes mot oppgitt årsverk
      Gitt jeg registrerer en praksisperiode
      Når jeg oppgir omfanget som <timer> timer
      Og jeg oppgir at et årsverk er <årsverk> timer
      Så beregnes praksisperioden til <praksis>

      Eksempler:
        | timer | årsverk | praksis |
        | 1 650 | 1 650   | 1,00 år |
        | 825   | 1 650   | 0,50 år |
        | 600   | 1 500   | 0,40 år |

    Scenario: Antall timer per årsverk har en standardverdi
      Gitt jeg registrerer en praksisperiode med omfang oppgitt i timer
      Når jeg ikke oppgir antall timer per årsverk
      Så brukes standardverdien på 1 650 timer

    Scenario: Saksbehandleren kan justere antall timer per årsverk
      Gitt jeg registrerer en praksisperiode med omfang oppgitt i timer
      Og standardverdien på 1 650 timer per årsverk er forhåndsutfylt
      Når jeg endrer antall timer per årsverk til 1 700
      Så beregnes praksisperioden mot 1 700 timer per årsverk

    Scenario: Antall timer per årsverk oppgis per praksisperiode
      Gitt søkeren har to arbeidsforhold med ulik arbeidstidsnorm
      Når jeg oppgir antall timer per årsverk på hver av praksisperiodene
      Så beregnes hver praksisperiode mot sitt eget årsverk
      Og antall timer per årsverk er lagret på praksisperioden
      # AVKLART 16.09.2026: årsverket oppgis **per praksisperiode**, har en
      # forhåndsutfylt standardverdi, og lagres på perioden.
      #
      # Begrunnelse: verifisert i FS-klienten skriver saksbehandleren inn
      # «Antall timer pr måned» selv, og verdien lagres i *brukerprofilen*
      # (PRAKSIS_MNDTIME) — ikke på perioden. To saksbehandlere kan dermed
      # komme til ulikt resultat på identisk dokumentasjon, og det er ikke
      # mulig å se i ettertid hvilket tall som ble brukt: bare resultatet
      # lagres, pluss «Antall timer: N» som fritekst i et merknadsfelt. Det
      # videreføres ikke. Per periode er nødvendig fordi arbeidsforhold kan
      # ha ulik arbeidstidsnorm; lagring på perioden gjør beregningen
      # etterprøvbar.
      #
      # AVKLART 23.09.2026: standardverdien er 1 650 timer per årsverk.
      # Det er standarden som hittil er brukt i UHG-opptaket, i
      # praksisberegningen for 23/5-regelen (som nå utgår). Timer per
      # årsverk kan variere, og saksbehandleren kan justere verdien på den
      # enkelte praksisperioden.

    Scenario: Omfanget oppgis på én av måtene per praksisperiode
      Gitt jeg registrerer en praksisperiode
      Når jeg velger å oppgi omfanget som stillingsprosent
      Så kan jeg ikke samtidig oppgi omfanget som antall timer

    Scenario: Praksisperiode med omfang i timer kan ikke lagres uten antall timer
      Gitt jeg registrerer en praksisperiode
      Og jeg velger å oppgi omfanget som antall timer
      Når jeg ikke oppgir antall timer i perioden
      Så får jeg en feilmelding om at antall timer i perioden må oppgis
      Og praksisperioden kan ikke lagres
      # AVKLART 02.10.2026: når omfanget oppgis i timer, er antall timer i
      # perioden påkrevd (tilbakemelding på kravet). Dette er en endring fra
      # FS-klienten, der omfang kan stå tomt.

    Scenariomal: Stillingsprosent utenfor 0–100 % kan ikke lagres
      Gitt jeg registrerer en praksisperiode
      Når jeg oppgir omfanget som stillingsprosent <stillingsprosent>
      Så får jeg en feilmelding om at stillingsprosenten må være mellom 0 og 100 %
      Og praksisperioden kan ikke lagres

      Eksempler:
        | stillingsprosent |
        | -10 %            |
        | 101 %            |
      # AVKLART 29.09.2026: stillingsprosenten må være fra og med 0 % til og
      # med 100 %. Begge grensene er gyldige; 0 % gir 0,00 år praksis, se
      # «Praksis beregnes proporsjonalt med stillingsprosenten».
      #
      # Gjennomgangen av FS-klienten (registrere_praksis.dagens-løsning-i-fs-
      # klienten.md) viser ingen grenseverdier for stillingsprosenten; bare at
      # en tom stillingsprosent settes til 100.

    Scenariomal: Timer som gir mer praksis enn kalendertiden i perioden, kan ikke lagres
      Gitt jeg registrerer en praksisperiode fra <startdato> til <sluttdato>
      Og jeg oppgir at et årsverk er 1 650 timer
      Når jeg oppgir omfanget som <timer> timer
      Så får jeg en feilmelding om at antall timer ikke kan gi mer praksis enn kalendertiden i perioden
      Og praksisperioden kan ikke lagres

      Eksempler:
        | startdato  | sluttdato  | timer |
        | 01.01.2020 | 31.12.2020 | 1 651 |
        | 01.01.2020 | 30.06.2020 | 826   |
      # Grensen regnes ut som timer / timer per årsverk ≤ kalendertiden for
      # perioden i år, der kalendertiden regnes på samme måte som i «Praksis
      # beregnes med full presisjon» og «En delvis måned regnes med 30 dager».
      #
      # AVKLART 06.10.2026: grensen er inklusiv. Timer som gir nøyaktig
      # kalendertiden, kan lagres: 1 650 timer for 01.01.2020–31.12.2020 gir
      # 1,00 år. Det tilsvarer at 100 % er gyldig for stillingsprosent.

    Scenariomal: Endring som gir mer praksis enn kalendertiden i perioden, kan ikke lagres
      Gitt saken har en praksisperiode fra 01.01.2020 til 31.12.2020 med omfang 1 650 timer
      Og et årsverk er 1 650 timer på praksisperioden
      Når jeg endrer <felt> på praksisperioden til <verdi>
      Så får jeg en feilmelding om at antall timer ikke kan gi mer praksis enn kalendertiden i perioden
      Og endringen av praksisperioden kan ikke lagres

      Eksempler:
        | felt                     | verdi      |
        | sluttdato                | 30.06.2020 |
        | antall timer per årsverk | 1 500      |
      # AVKLART 06.10.2026: grensen gjelder alltid, også når datoene eller
      # antall timer per årsverk endres etter at timene er oppgitt. Endringen
      # avvises med samme feilmelding; det holder ikke med et varsel.

    Scenariomal: Antall timer på 0 eller mindre kan ikke lagres
      Gitt jeg registrerer en praksisperiode
      Når jeg oppgir omfanget som <timer> timer
      Så får jeg en feilmelding om at antall timer må være mer enn 0
      Og praksisperioden kan ikke lagres

      Eksempler:
        | timer |
        | 0     |
        | -10   |
      # AVKLART 06.10.2026: antall timer må være mer enn 0. Det skiller seg
      # fra stillingsprosent, der 0 % er gyldig.

    Scenario: Timebasert omfang overskrives ikke når datoene endres
      Gitt en praksisperiode har omfanget oppgitt i timer
      Når jeg endrer sluttdatoen på praksisperioden
      Så beholdes den timebaserte beregningen
      # AVKLART 16.09.2026: saksbehandleren velger én av måtene per periode,
      # og valget er et eksplisitt felt på perioden.
      #
      # Begrunnelse: verifisert i FS-klienten løses dette i dag med et hack —
      # prosentberegningen kjøres på nytt hver gang datoer eller
      # stillingsprosent endres, og hoppes over hvis merknadsfeltet inneholder
      # delstrengen «Antall timer:». Forretningsregelen ligger altså som fri
      # tekst i et 250-tegns merknadsfelt, og forsvinner hvis noen redigerer
      # merknaden. Det videreføres ikke: hvilket grunnlag omfanget har skal
      # være et eget felt.

  Regel: Praksisperioder kan oppdateres og slettes

    Scenario: Oppdatere en praksisperiode
      Gitt saken har en registrert praksisperiode
      Når jeg endrer arbeidsgiver, type, datoer eller omfang på praksisperioden
      Så er endringen lagret på praksisperioden
      Og den samlede praksisberegningen er oppdatert

    Scenario: Slette en praksisperiode
      Gitt saken har en registrert praksisperiode
      Når jeg sletter praksisperioden
      Så er praksisperioden ikke lenger registrert på saken
      Og praksisperioden inngår ikke i den samlede praksisberegningen

  Regel: Systemet summerer praksisperiodene automatisk

    # Eksemplene i denne regelen forutsetter at alle praksisperiodene er
    # inkludert, slik nye perioder er som standard. Se
    # «En ny praksisperiode er inkludert som standard».
    #
    # AVKLART 29.09.2026 (spørsmål 7): samlet praksis vises bare i år, ikke i
    # timer. Timer brukes bare som omfang på den enkelte praksisperioden.

    Scenario: Samlet praksis summeres på tvers av perioder
      Gitt et årsverk er 1 650 timer
      Og saken har følgende praksisperioder
        | startdato  | sluttdato  | omfang    | beregnet praksis |
        | 01.01.2020 | 31.12.2021 | 100 %     | 2,00 år          |
        | 01.01.2022 | 31.12.2023 | 50 %      | 1,00 år          |
        | 01.01.2024 | 30.06.2024 | 825 timer | 0,50 år          |
      Når jeg åpner praksisberegningen
      Så er samlet praksis 3,50 år

    Scenario: Samlet praksis justeres når en praksisperiode legges til
      Gitt samlet praksis på saken er 3,50 år
      Når jeg registrerer en praksisperiode som beregnes til 0,50 år
      Så er samlet praksis 4,00 år

    Scenario: Samlet praksis justeres når en praksisperiode slettes
      Gitt samlet praksis på saken er 3,50 år
      Og en av praksisperiodene er beregnet til 1,00 år
      Når jeg sletter den praksisperioden
      Så er samlet praksis 2,50 år

    Scenario: Sluttdatoen regnes med i perioden
      Gitt jeg registrerer en praksisperiode fra 01.01.2020 til 31.12.2020
      Når jeg oppgir omfanget som stillingsprosent 100 %
      Så beregnes praksisperioden til 1,00 år

    Scenario: Summen avkortes til to desimaler i visningen
      Gitt sakens praksisperioder gir til sammen 1,996 år
      Når jeg åpner praksisberegningen
      Så vises samlet praksis som 1,99 år

    Scenario: Praksis beregnes med full presisjon
      Gitt saken har flere praksisperioder som hver gir en brøkdel av et år
      Når jeg åpner praksisberegningen
      Så er hver praksisperiode beregnet med full presisjon
      Og avkortingen til to desimaler skjer først når summen vises
      # AVKLART 16.09.2026:
      #
      # Tidsenhet: kalendertiden regnes som antall hele kalendermåneder
      # mellom start- og sluttdato, pluss de gjenstående dagene som en brøk
      # av en måned på 30 dager (se «En delvis måned regnes med 30 dager»).
      # Månedene deles på 12 for å få år, og ganges med
      # stillingsprosenten:
      #   år = kalendermåneder / 12 * stillingsprosent / 100
      #
      # Inklusive datoer: ja. Sluttdatoen regnes med, slik at
      # 01.01.2020–31.12.2020 gir presis 1,00 år og 01.01.2020–30.06.2020 gir
      # presis 6 måneder. Eksemplene i Scenariomalen over stemmer med dette.
      #
      # Regelen er utledet fra FS-klienten, som bruker Oracles
      # MONTHS_BETWEEN(sluttdato + 1, startdato). Det er kilden til regelen,
      # ikke en føring for implementasjonen — ny funksjonalitet bygges i
      # FS Admin og er ikke bundet til Oracle-funksjoner.
      #
      # Avrunding: FS-klienten avkorter hver periode for seg til én desimal
      # måned (truncate, altså alltid nedover). Det videreføres ikke. Det gir
      # en systematisk skjevhet — en søker med tolv korte arbeidsforhold kan
      # tape merkbart mot en søker med ett langt, på ellers identisk praksis,
      # og nær et toårskrav kan det avgjøre utfallet. Full presisjon internt
      # koster ingenting å bygge.
      #
      # AVKLART 23.09.2026: visningen avkorter nedover til to desimaler, slik
      # at 1,996 år vises som 1,99 år og ikke «2,00 år». Visningen skal aldri
      # vise mer praksis enn søkeren faktisk har. Avkortingen gjelder bare
      # visningen — beregningen skjer med full presisjon.

    Scenariomal: En delvis måned regnes med 30 dager
      Gitt jeg registrerer en praksisperiode fra <startdato> til <sluttdato>
      Når jeg oppgir omfanget som stillingsprosent 100 %
      Så beregnes kalendertiden til <måneder> måneder
      Og praksisperioden vises som <praksis>

      Eksempler:
        | startdato  | sluttdato  | måneder | praksis |
        | 01.02.2020 | 15.02.2020 | 0,5     | 0,04 år |
        | 01.01.2020 | 15.02.2020 | 1,5     | 0,12 år |
      # AVKLART 29.09.2026 (spørsmål 5): en måned er alltid 30 dager. Hele
      # kalendermåneder telles som før; dagene som er igjen, deles på 30.
      # 15 dager er altså en halv måned, uansett hvilken måned det er.
      #
      # Dette er en endring fra FS-klienten, som deler restdagene på 31
      # fordi det er slik Oracles MONTHS_BETWEEN virker — en teknisk
      # konvensjon, ikke en faglig beslutning. Visningen avkorter til to
      # desimaler: 0,5/12 = 0,0416… år vises som 0,04 år, og 1,5/12 = 0,125
      # år vises som 0,12 år.

  Regel: Overlappende praksisperioder varsles og vises med to summer

    Scenario: Overlappende praksisperioder varsles
      Gitt saken har følgende praksisperioder
        | startdato  | sluttdato  | omfang |
        | 01.01.2020 | 31.12.2020 | 50 %   |
        | 01.01.2020 | 31.12.2020 | 60 %   |
      Når jeg åpner praksisberegningen
      Så fremgår det at praksisperiodene overlapper i tid
      Og det fremgår hvilken periode overlappet gjelder

    Scenario: Både oppgitt og justert sum vises ved overlapp
      Gitt saken har følgende praksisperioder
        | startdato  | sluttdato  | omfang |
        | 01.01.2020 | 31.12.2020 | 50 %   |
        | 01.01.2020 | 31.12.2020 | 60 %   |
      Når jeg åpner praksisberegningen
      Så er sum av oppgitte perioder 1,10 år
      Og sum justert for overlapp er 1,00 år

    Scenario: Justert sum kan ikke overstige kalendertiden i perioden
      Gitt saken har flere samtidige praksisperioder som til sammen overstiger 100 % stilling
      Når jeg åpner praksisberegningen
      Så er den justerte summen begrenset til kalendertiden i den overlappende perioden
      Og det fremgår at praksisperiodene til sammen overstiger 100 % stilling
      # AVKLART 29.09.2026 (situasjon F): i perioder der flere
      # praksisperioder til sammen overstiger 100 % stilling, regnes det
      # ikke mer enn 100 %. Saksbehandleren skal likevel få et varsel om det.

    Scenario: Overlappssummene beregnes kun på inkluderte praksisperioder
      Når jeg legger inn følgende praksisperioder
        | startdato  | sluttdato  | omfang | inkludert |
        | 01.01.2020 | 31.12.2020 | 50 %   | Ja        |
        | 01.01.2020 | 31.12.2020 | 60 %   | Ja        |
        | 01.01.2020 | 31.12.2020 | 40 %   | Nei       |
      Så er sum av oppgitte perioder 1,10 år
      Og sum justert for overlapp er 1,00 år
      #  AVKLART 29.09.2026: perioder som ikke er inkludert
      # (40 %) filtreres bort før overlappsberegningen, og påvirker derfor
      # ingen av summene.

    # FLYTTET 23.09.2026: valg av hvilken sum som legges til grunn for et
    # opptakskrav, og hva som gjelder uten aktivt valg, er flyttet til
    # knytte_praksis_til_opptakskrav.feature. Kalkulatoren viser begge
    # summene; saksbehandleren vurderer selv hvilken som gjelder.

  # AVKLART 07.10.2026: rollen heter **søknadsbehandler**, som i koden
  # (SØKNADSBEHANDLER i opptak, FS-ADMIN_OPPTAK_SØKNADSBEHANDLER i FS Admin).
  # Dette erstatter avklaringen 16.09.2026 om «opptakssaksbehandler», som
  # ikke finnes som rolle. Besluttet ved kodesjekken i fs-specify
  # (tasks/opptak/registrere-praksis). Se kommentaren nederst i filen om
  # andre krav som bruker andre navn.

  Regel: Kun brukere med søknadsbehandler-rollen kan registrere praksis

    Scenario: Søknadsbehandler kan registrere praksis
      Gitt jeg har rollen søknadsbehandler
      Når jeg åpner en sak på søknaden til en søker
      Så kan jeg registrere, oppdatere og slette praksisperioder

    Scenario: Bruker uten søknadsbehandler-rollen ser ikke praksisregistreringen
      Gitt en bruker uten rollen søknadsbehandler er innlogget
      Når brukeren åpner en sak på søknaden til en søker
      Så ser brukeren ikke muligheten til å registrere praksis

    Scenario: Bruker uten søknadsbehandler-rollen ser ikke registrert praksis
      Gitt en bruker uten rollen søknadsbehandler er innlogget
      Og saken har registrerte praksisperioder
      Når brukeren åpner en sak på søknaden til en søker
      Så ser brukeren ikke praksisberegningen

    Scenario: Saksbehandlere i andre opptak ser ikke praksisen
      Gitt det er registrert praksisperioder på en sak i ett opptak
      Når en søknadsbehandler i et annet opptak slår opp søkeren
      Så ser saksbehandleren ikke praksisperiodene fra det andre opptaket
      # AVKLART 29.09.2026 (situasjon E og spørsmål 6): «Nei. Ingen i andre
      # opptak skal kunne se praksisen.» Hele praksisdelen er skjult for dem
      # som ikke har rollen søknadsbehandler — også den registrerte
      # praksisen og summen, ikke bare muligheten til å registrere.

# OPPFØLGING UTENFOR DENNE FEATUREN
# Rollenavnet «søknadsbehandler» er avklart 07.10.2026. Andre krav bruker
# andre navn på det som skal være samme rolle, og bør rettes i en egen
# endring:
# - behandle_søknad.feature (@OPT-BEH-BEH-001) bruker «saksbehandler for
#   opptak».
# - knytte_praksis_til_opptakskrav.feature og vitnemålsbehandling.feature
#   bruker «opptakssaksbehandler».
# - Aktørlisten i krav/README.md lister «administrator, søker, student,
#   saksbehandler». «søknadsbehandler» mangler.
# Det er ikke gjort her, fordi endringer i felles konvensjoner og i andre
# krav ville utvide endringen utover praksisberegning.
