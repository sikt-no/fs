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
@OPT-BEH-BEH-003 @must @draft
Egenskap: Registrere og beregne praksis for søker
  Som saksbehandler i opptak
  ønsker jeg å registrere søkerens praksisperioder og få dem summert
  slik at jeg kan avgjøre om søkeren oppfyller opptakskrav som krever praksis.

  Praksisberegningen er relevant når et utdanningstilbud har relevant praksis
  som opptakskrav. Master i anestesisykepleie krever for eksempel
  bachelorgrad i sykepleie, autorisasjon som sykepleier og minimum to års
  arbeidserfaring som sykepleier. Dokumentasjonen som kreves er typisk
  bekreftelse fra arbeidsgiver.

  Utregningen er knotete å gjøre manuelt fordi søkeren ofte har dokumentert
  flere arbeidsforhold med ulik stillingsprosent, og fordi arbeidsgivere
  dokumenterer omfanget enten som stillingsprosent eller som et antall timer.
  Saksbehandleren registrerer derfor hvert dokumenterte arbeidsforhold med
  periode og omfang, og systemet regner ut hvor mange års praksis det
  tilsvarer til sammen og om søkeren oppfyller opptakskravet.

  Praksis beregnes proporsjonalt: periodens kalendertid ganget med
  stillingsprosenten. To år i 50 % stilling gir ett år praksis. Perioder
  oppgitt i timer beregnes som antall timer delt på antall timer per årsverk.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg har rollen opptakssaksbehandler
    Og jeg er inne på søknaden til en søker

  Regel: Praksisperioder registreres manuelt på søkeren

    Scenario: Registrere en praksisperiode
      Når jeg registrerer en praksisperiode med type, startdato og sluttdato
      Så er praksisperioden lagret på søkeren
      Og praksisperioden inngår i den samlede praksisberegningen

    Scenario: Se registrerte praksisperioder
      Gitt søkeren har registrerte praksisperioder
      Når jeg åpner praksisberegningen
      Så ser jeg hver praksisperiode med følgende opplysninger
        | felt             |
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

    @openquestion
    Scenario: Markere om en praksisperiode er relevant
      Gitt jeg har registrert en praksisperiode
      Når jeg markerer praksisperioden som relevant
      Så inngår den i summen for relevant praksis
      # ÅPENT SPØRSMÅL — NY, oppdaget ved gjennomgang av FS-klienten:
      # - Verifisert: PERSONPRAKSIS har et felt status_relevant (J/N), og
      #   praksisbildet viser to summer i footeren — «Sum relevant praksis»
      #   (kun rader med status_relevant = J) og «Sum totalt» (alle rader).
      #   Relevansmarkeringen er mekanismen saksbehandleren bruker for å
      #   skille relevant praksis fra resten, og den blir viktigere nå som
      #   praksistypene er besluttet å være generelle.
      # - Uavklart: hvordan kombineres dette med de to summene for overlapp
      #   («sum av oppgitte perioder» og «sum justert for overlapp»)? To
      #   uavhengige akser gir fire summer, og fire summer på skjermen er
      #   ikke til hjelp for noen. Enten må relevansfiltreringen ligge
      #   *foran* overlappsberegningen — altså at bare relevante perioder
      #   inngår, og at de to overlappssummene beregnes på dem — eller
      #   relevansmarkeringen må erstattes av noe annet.
      # - Anbefaling: relevans filtrerer først, overlapp beregnes på det som
      #   står igjen. Da forblir det to summer å velge mellom.

    Scenario: Praksistype og startdato er obligatorisk
      Når jeg registrerer en praksisperiode
      Så må jeg oppgi praksistype
      Og jeg må oppgi startdato
      # AVKLART 16.09.2026: verifisert i FS-klienten — kun praksistypekode og
      # dato_fra er obligatoriske felt. Sluttdato, stillingsprosent og
      # omfang kan alle stå tomme.

    Scenario: Registrere praksisperiode uten sluttdato
      Gitt søkeren har et løpende arbeidsforhold
      Når jeg registrerer en praksisperiode uten sluttdato
      Så er praksisperioden lagret på søkeren
      Men praksisperioden får ingen beregnet praksis
      # AVKLART 16.09.2026: perioden kan lagres uten sluttdato, men
      # beregningen krever begge datoer og kjører derfor ikke. Perioden
      # regnes altså ikke til dagens dato eller til søknadsfristen — den får
      # ingen verdi før saksbehandleren fyller inn sluttdato. Verifisert i
      # FS-klienten.
      #
      # Merk konsekvensen: en søker med et løpende arbeidsforhold får ikke
      # den praksisen regnet med i det hele tatt. Om det er ønsket adferd
      # eller en mangel ved dagens løsning, bør produkteier ta stilling til.

    @openquestion
    Scenario: AVKLAR validering av ugyldige og framtidige datoer
      # ÅPNE SPØRSMÅL:
      # - Skal registreringen avvises når sluttdatoen er før startdatoen, og
      #   hva skal i så fall fremgå for saksbehandleren? Verifisert i
      #   FS-klienten: den validerer bare at feltene *finnes*, ikke at
      #   datoene er i rekkefølge. Negativ varighet er altså mulig i dag.
      # - Skal perioder som strekker seg inn i framtiden kunne registreres?
      #   FS-klienten hindrer det ikke.
      # - Dette er de to delene av det opprinnelige datospørsmålet som
      #   FS-klienten ikke gir svar på, fordi den ikke gjør noen slik
      #   validering. De må besluttes.
      Gitt spørsmålet er åpent

    Scenario: Knytte et dokument til en praksisperiode
      Gitt søkeren har dokumentert et arbeidsforhold
      Når jeg knytter dokumentet til praksisperioden
      Så ser jeg hvilket dokument praksisperioden bygger på
      Og jeg kan åpne dokumentet fra praksisperioden
      # AVKLART 16.09.2026: koblingen finnes i FS i dag og videreføres.
      # Verifisert: PERSONPRAKSIS har dokumentnr mot DOKUMENTARKIV, og
      # praksisbildet har en knapp som åpner dokumentet. Koblingen er
      # valgfri — perioden kan registreres uten.
      #
      # Gjenstår å sjekke: Jira ADMI-45 «Koble dokumentasjon på yrkespraksis
      # til praksiskalkulator» ber om samme kobling. Gjelder den
      # søkeropplastet dokumentasjon, som er noe annet enn dokumentarkivet?

    Scenario: Se hvem som registrerte en praksisperiode
      Gitt jeg ser en registrert praksisperiode
      Så ser jeg hvem som opprettet den og når
      Og jeg ser hvem som sist endret den og når
      # Verifisert i FS-klienten: PERSONPRAKSIS har saksbehinit_opprettet,
      # saksbehinit_endret, dato_opprettet og dato_endret. Videreføres.

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

    Scenariomal: Timebasert praksis beregnes mot oppgitt årsverk
      Gitt jeg registrerer en praksisperiode
      Når jeg oppgir omfanget som <timer> timer
      Og jeg oppgir at et årsverk er <årsverk> timer
      Så beregnes praksisperioden til <praksis>

      Eksempler:
        | timer | årsverk | praksis |
        | 1 700 | 1 700   | 1,00 år |
        | 850   | 1 700   | 0,50 år |
        | 600   | 1 500   | 0,40 år |

    Scenario: Antall timer per årsverk har en standardverdi
      Gitt jeg registrerer en praksisperiode med omfang oppgitt i timer
      Når jeg ikke oppgir antall timer per årsverk
      Så brukes standardverdien på 1 700 timer

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
      # Standardverdien 1 700 timer er den som brukes i eksemplene over.
      # Gjenstår å bekrefte mot sektoren: 1 750 timer er en vanlig norm for
      # nettoårsverk i Norge, og valget mellom 1 700 og 1 750 flytter
      # grensen for hvem som oppfyller et krav. Nord universitets
      # Excel-regneark for realkompetanse (Confluence PFS 4885217297) kan
      # vise hva som faktisk er i bruk.

    Scenario: Omfanget oppgis på én av måtene per praksisperiode
      Gitt jeg registrerer en praksisperiode
      Når jeg velger å oppgi omfanget som stillingsprosent
      Så kan jeg ikke samtidig oppgi omfanget som antall timer

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
      Gitt søkeren har en registrert praksisperiode
      Når jeg endrer type, datoer eller omfang på praksisperioden
      Så er endringen lagret på praksisperioden
      Og den samlede praksisberegningen er oppdatert

    Scenario: Slette en praksisperiode
      Gitt søkeren har en registrert praksisperiode
      Når jeg sletter praksisperioden
      Så er praksisperioden ikke lenger registrert på søkeren
      Og praksisperioden inngår ikke i den samlede praksisberegningen

  Regel: Systemet summerer praksisperiodene automatisk

    Scenario: Samlet praksis summeres på tvers av perioder
      Gitt et årsverk er 1 700 timer
      Og søkeren har følgende praksisperioder
        | startdato  | sluttdato  | omfang    | beregnet praksis |
        | 01.01.2020 | 31.12.2021 | 100 %     | 2,00 år          |
        | 01.01.2022 | 31.12.2023 | 50 %      | 1,00 år          |
        | 01.01.2024 | 30.06.2024 | 850 timer | 0,50 år          |
      Når jeg åpner praksisberegningen
      Så er samlet praksis 3,50 år

    Scenario: Samlet praksis justeres når en praksisperiode legges til
      Gitt samlet praksis for søkeren er 3,50 år
      Når jeg registrerer en praksisperiode som beregnes til 0,50 år
      Så er samlet praksis 4,00 år

    Scenario: Samlet praksis justeres når en praksisperiode slettes
      Gitt samlet praksis for søkeren er 3,50 år
      Og en av praksisperiodene er beregnet til 1,00 år
      Når jeg sletter den praksisperioden
      Så er samlet praksis 2,50 år

    Scenario: Sluttdatoen regnes med i perioden
      Gitt jeg registrerer en praksisperiode fra 01.01.2020 til 31.12.2020
      Når jeg oppgir omfanget som stillingsprosent 100 %
      Så beregnes praksisperioden til 1,00 år

    Scenario: Praksis beregnes med full presisjon og avrundes bare i visningen
      Gitt søkeren har flere praksisperioder som hver gir en brøkdel av et år
      Når jeg åpner praksisberegningen
      Så er hver praksisperiode beregnet med full presisjon
      Og avrundingen til to desimaler skjer først når summen vises
      # AVKLART 16.09.2026, verifisert mot FS-klienten:
      #
      # Tidsenhet: kalendertiden regnes i måneder med Oracles
      # MONTHS_BETWEEN(sluttdato + 1, startdato). Brøkdelen av en måned
      # regnes som dager delt på 31. Månedslengde og skuddår håndteres altså
      # av MONTHS_BETWEEN, ikke av egen logikk. Måneder deles på 12 for å få
      # år. Formelen er:
      #   år = MONTHS_BETWEEN(sluttdato + 1, startdato) / 12 * prosent / 100
      # Eksemplene i Scenariomalen over stemmer med denne formelen.
      #
      # Inklusive datoer: ja. «+ 1» på sluttdatoen gjør den inklusiv, slik at
      # 01.01.2020–31.12.2020 gir presis 1,00 år.
      #
      # Avrunding: FS-klienten avkorter hver periode for seg til én desimal
      # måned (truncate, altså alltid nedover). Det videreføres ikke. Det gir
      # en systematisk skjevhet — en søker med tolv korte arbeidsforhold kan
      # tape merkbart mot en søker med ett langt, på ellers identisk praksis,
      # og nær et toårskrav kan det avgjøre utfallet. Full presisjon internt
      # koster ingenting å bygge.
      #
      # Visningen avrundes til to desimaler, som i eksemplene. Merk at
      # avrunding oppover i visningen kan vise «2,00 år» for en sum på 1,996
      # — om visningen skal avkorte nedover i stedet, bør besluttes sammen
      # med hvordan opptakskravet vurderes.

  Regel: Overlappende praksisperioder varsles og vises med to summer

    Scenario: Overlappende praksisperioder varsles
      Gitt søkeren har følgende praksisperioder
        | startdato  | sluttdato  | omfang |
        | 01.01.2020 | 31.12.2020 | 50 %   |
        | 01.01.2020 | 31.12.2020 | 60 %   |
      Når jeg åpner praksisberegningen
      Så fremgår det at praksisperiodene overlapper i tid
      Og det fremgår hvilken periode overlappet gjelder

    Scenario: Både oppgitt og justert sum vises ved overlapp
      Gitt søkeren har følgende praksisperioder
        | startdato  | sluttdato  | omfang |
        | 01.01.2020 | 31.12.2020 | 50 %   |
        | 01.01.2020 | 31.12.2020 | 60 %   |
      Når jeg åpner praksisberegningen
      Så er sum av oppgitte perioder 1,10 år
      Og sum justert for overlapp er 1,00 år

    Scenario: Justert sum kan ikke overstige kalendertiden i perioden
      Gitt søkeren har flere samtidige praksisperioder som til sammen overstiger 100 % stilling
      Når jeg åpner praksisberegningen
      Så er den justerte summen begrenset til kalendertiden i den overlappende perioden

    Scenario: Saksbehandleren velger hvilken sum som legges til grunn
      Gitt søkeren har overlappende praksisperioder
      Og både sum av oppgitte perioder og sum justert for overlapp er vist
      Når jeg velger hvilken av summene som skal legges til grunn
      Så er den valgte summen lagt til grunn for vurderingen av opptakskravet

    @openquestion
    Scenario: AVKLAR hvilken sum som gjelder når saksbehandleren ikke velger
      # ÅPNE SPØRSMÅL:
      # - Saksbehandleren velger hvilken sum som legges til grunn ved
      #   overlapp. Hva gjelder når det ikke er gjort et aktivt valg — er
      #   den justerte summen forhåndsvalgt, eller kan opptakskravet ikke
      #   vurderes før valget er tatt?
      # - Skal valget og begrunnelsen kunne etterprøves i ettertid?
      Gitt spørsmålet er åpent

  Regel: Praksis knyttes til opptakskrav på ett eller flere søknadsalternativer

    Scenario: Knytte praksis til et opptakskrav på et søknadsalternativ
      Gitt søknaden har et søknadsalternativ med et opptakskrav som krever praksis
      Når jeg knytter den registrerte praksisen til opptakskravet
      Så er praksisen lagt til grunn for det opptakskravet på søknadsalternativet

    Scenario: Knytte samme praksis til flere søknadsalternativer
      Gitt søknaden har flere søknadsalternativer med opptakskrav som krever praksis
      Når jeg knytter den registrerte praksisen til opptakskravet på flere av søknadsalternativene
      Så er praksisen lagt til grunn for opptakskravet på hvert av de valgte søknadsalternativene

    Scenario: Praksis uten knytning påvirker ikke opptakskrav
      Gitt søkeren har registrerte praksisperioder
      Og praksisen ikke er knyttet til et opptakskrav
      Når jeg åpner søknadsalternativene
      Så er ingen opptakskrav vurdert på grunnlag av praksisen

    @openquestion
    Scenario: AVKLAR om praksis kan knyttes til flere ulike kravelementer
      # ÅPNE SPØRSMÅL:
      # - Praksisen knyttes til ett opptakskrav (kravelement) på ett eller
      #   flere søknadsalternativer. Kan den samme praksisen knyttes til
      #   flere ulike kravelementer, for eksempel når søknadsalternativene
      #   har forskjellige praksiskrav?
      # - Kan et utvalg av praksisperiodene knyttes til ett kravelement, og
      #   et annet utvalg til et annet — eller gjelder knytningen alltid all
      #   registrert praksis?
      Gitt spørsmålet er åpent

  # MERK 16.09.2026: reglene under er NY funksjonalitet, ikke videreføring.
  # Verifisert i FS-klienten finnes det ingen kobling mellom praksisperioder
  # og kravelement. Praksis og fagprofil (kravelementkode + status_bestatt)
  # ligger som uavhengige faner i samme vindu, og saksbehandleren leser
  # summen og setter status manuelt. Løsningsforslaget beskriver dagens FS som
  # at systemet «sjekkar om søkar oppfyller opptakskravet» — det stemmer ikke.
  # Se registrere_praksis.dagens-løsning-i-fs-klienten.md, avsnittet «Kobling
  # til kravelement: finnes ikke». Det betyr at reglene under trenger mer
  # avklaring enn resten av featuren, og at sporbarhet for en automatisk satt
  # status må designes fra bunnen.

  Regel: Opptakskravet registreres automatisk som oppfylt når praksiskravet er nådd

    Scenario: Opptakskravet registreres som oppfylt
      Gitt et søknadsalternativ har et opptakskrav som krever 2 år praksis
      Og praksisen er knyttet til det opptakskravet
      Når samlet praksis som legges til grunn er 2,00 år
      Så registreres opptakskravet som oppfylt

    Scenario: Opptakskravet registreres ikke som oppfylt når praksisen er for kort
      Gitt et søknadsalternativ har et opptakskrav som krever 2 år praksis
      Og praksisen er knyttet til det opptakskravet
      Når samlet praksis som legges til grunn er 1,50 år
      Så registreres opptakskravet ikke som oppfylt

    @openquestion
    Scenario: AVKLAR hvor praksiskravet hentes fra
      # ÅPNE SPØRSMÅL:
      # - Opptakskravet vurderes mot et krav om antall år praksis. Hentes
      #   dette fra minimumskravet på kravelementet i kompetanseregelverket,
      #   eller oppgis det et annet sted?
      # - Kompetanseregelverket uttrykker minimumskrav som karakter og
      #   bestått/ikke bestått. Skal praksiskrav uttrykkes i samme
      #   minimumskrav-felt som antall år, eller trenger kravelementet et
      #   eget felt for praksisomfang?
      Gitt spørsmålet er åpent

    @openquestion
    Scenario: AVKLAR om oppfylt opptakskrav reverseres
      # ÅPNE SPØRSMÅL:
      # - Praksisberegningen justeres automatisk når en praksisperiode legges
      #   til eller slettes. Skal et opptakskrav som er registrert som
      #   oppfylt settes tilbake til ikke oppfylt når samlet praksis faller
      #   under kravet, eller består statusen til saksbehandleren endrer den
      #   manuelt?
      # - Skal saksbehandleren varsles når en endring i praksisperiodene
      #   endrer statusen på et opptakskrav?
      Gitt spørsmålet er åpent

    @openquestion
    Scenario: AVKLAR forholdet til manuell kvalifisering
      # ÅPNE SPØRSMÅL:
      # - Saksbehandleren kan i dag manuelt angi at en søker er kvalifisert
      #   for kravelementene i et opptak. Hva skjer når den automatiske
      #   praksisberegningen og den manuelle angivelsen er uenige — hvilken
      #   av dem gjelder?
      Gitt spørsmålet er åpent

  Regel: Kun brukere med opptakssaksbehandler-rollen kan registrere praksis

    Scenario: Opptakssaksbehandler kan registrere praksis
      Gitt jeg har rollen opptakssaksbehandler
      Når jeg åpner søknaden til en søker
      Så kan jeg registrere, oppdatere og slette praksisperioder

    Scenario: Bruker uten opptakssaksbehandler-rollen ser ikke praksisregistreringen
      Gitt en bruker uten rollen opptakssaksbehandler er innlogget
      Når brukeren åpner søknaden til en søker
      Så ser brukeren ikke muligheten til å registrere praksis

    @openquestion
    Scenario: AVKLAR om praksisen er synlig uten registreringsrettighet
      # ÅPNE SPØRSMÅL:
      # - Muligheten til å registrere praksis er skjult for brukere uten
      #   rollen. Skal den registrerte praksisen og den samlede beregningen
      #   likevel være synlig for andre saksbehandlere på søknaden, eller er
      #   hele praksisseksjonen skjult?
      Gitt spørsmålet er åpent

    @openquestion
    Scenario: AVKLAR navnet på rollen
      # ÅPNE SPØRSMÅL:
      # - Rollen omtales som «opptakssaksbehandler» i omfanget, mens
      #   behandle_søknad.feature bruker «saksbehandler for opptak» og
      #   aktørlisten i konvensjonene bruker «saksbehandler». Hvilket navn
      #   er det autoritative, og er det den samme rollen?
      Gitt spørsmålet er åpent
