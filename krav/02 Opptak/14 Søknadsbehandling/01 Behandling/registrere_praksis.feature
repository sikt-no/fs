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
      # - Merk at det er avklart at samme praksis kan knyttes til flere ulike
      #   kravelementer, og at ulike kravelementer kan ha ulike krav til hva
      #   som er relevant praksis. Det betyr at relevans sannsynligvis ikke
      #   kan være ett flagg per periode, slik det er i FS i dag, men må
      #   gjelde per kombinasjon av periode og kravelement. Se «AVKLAR om et
      #   utvalg av praksisperiodene kan knyttes per kravelement» — de to
      #   spørsmålene er samme datamodellvalg sett fra to sider.

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

    @openquestion
    Scenario: AVKLAR om praksis fram i tid kan registreres
      # ÅPNE SPØRSMÅL:
      # - Skal perioder som strekker seg inn i framtiden kunne registreres?
      #   FS-klienten hindrer det ikke, og spørsmålet er ikke besluttet.
      # - Tilfellet er reelt: en søker i fast stilling kan dokumentere et
      #   arbeidsforhold som løper forbi søknadsfristen. Skal praksisen
      #   regnes til søknadsfristen, til dagens dato, eller til den oppgitte
      #   sluttdatoen selv om den er fram i tid?
      # - Se også «Registrere praksisperiode uten sluttdato» over — der er
      #   dagens svar at perioden ikke gir noen beregnet praksis i det hele
      #   tatt. De to tilfellene bør besluttes sammen.
      Gitt spørsmålet er åpent

    @openquestion
    Scenario: Knytte praksisperioden til dokumentasjon på søknaden
      Gitt søkeren har lagt ved dokumentasjon på et arbeidsforhold i søknaden
      Når jeg knytter dokumentasjonen til praksisperioden
      Så ser jeg hvilken dokumentasjon praksisperioden bygger på
      Og jeg kan åpne dokumentasjonen fra praksisperioden
      # ÅPENT SPØRSMÅL:
      # - Er dette i scope for første leveranse?
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
      # AVKLART 16.09.2026:
      #
      # Tidsenhet: kalendertiden regnes som antall hele kalendermåneder
      # mellom start- og sluttdato, pluss den gjenstående delen av en måned
      # som en brøk. Månedene deles på 12 for å få år, og ganges med
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
      # Visningen avrundes til to desimaler, som i eksemplene. Merk at
      # avrunding oppover i visningen kan vise «2,00 år» for en sum på 1,996
      # — om visningen skal avkorte nedover i stedet, bør besluttes sammen
      # med hvordan opptakskravet vurderes.

    @openquestion
    Scenario: AVKLAR hvordan en delvis måned regnes
      # ÅPNE SPØRSMÅL:
      # - Hele kalendermåneder er entydig. Restdagene er ikke. En periode fra
      #   01.02.2020 til 15.02.2020 er 15 dager — men hvor stor brøkdel av en
      #   måned er det?
      # - FS-klienten deler alltid restdagene på 31, fordi det er slik Oracles
      #   MONTHS_BETWEEN virker. Det er en teknisk konvensjon, ikke en
      #   domenebeslutning: 15 dager i februar blir 0,484 måneder, mens de
      #   samme 15 dagene er 0,536 av den faktiske måneden. Ingen av
      #   eksemplene i Scenariomalen over treffer dette, fordi de alle gir
      #   hele måneder.
      # - Alternativene er å dele restdagene på 31 (som i dag), på den
      #   faktiske månedens lengde, eller å regne hele perioden i dager mot
      #   et fast antall dager per år. De gir ulike svar, og forskjellen kan
      #   avgjøre et grensetilfelle.
      # - Spørsmålet er nytt, oppdaget da regneregelen ble formulert
      #   uavhengig av Oracle.
      Gitt spørsmålet er åpent

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

    Scenario: Knytte samme praksis til flere ulike kravelementer
      Gitt søknaden har søknadsalternativer med ulike opptakskrav som krever praksis
      Når jeg knytter den registrerte praksisen til flere ulike kravelementer
      Så er praksisen lagt til grunn for hvert av de valgte kravelementene
      # AVKLART 16.09.2026: samme praksis kan knyttes til flere ulike
      # kravelementer, ikke bare til samme kravelement på flere
      # søknadsalternativer.

    @openquestion
    Scenario: AVKLAR om et utvalg av praksisperiodene kan knyttes per kravelement
      # ÅPNE SPØRSMÅL:
      # - Gjelder knytningen alltid *all* registrert praksis, eller kan et
      #   utvalg av periodene knyttes til ett kravelement og et annet utvalg
      #   til et annet?
      # - Avklaringen om at samme praksis kan knyttes til flere ulike
      #   kravelementer gjør dette spørsmålet skarpere, ikke mindre viktig.
      #   Løsningsforslaget sier at «vanlegaste forskjellen er vel kva
      #   praksis som reknast for å vere relevant» — ulike kravelementer kan
      #   altså ha ulike krav til hva som teller. Da kan relevans ikke være
      #   ett flagg per praksisperiode, slik det er i FS i dag; den må være
      #   per kombinasjon av periode og kravelement.
      # - Henger derfor direkte sammen med «Markere om en praksisperiode er
      #   relevant» tidligere i featuren. De to må besluttes sammen — svaret
      #   avgjør datamodellen, og det er det siste store strukturelle
      #   spørsmålet i featuren.
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

  # AVKLART 16.09.2026: rollen heter **opptakssaksbehandler**. Det er det
  # autoritative navnet, og featuren bruker det konsekvent.
  #
  # Konsekvens utenfor denne featuren: behandle_søknad.feature bruker
  # «saksbehandler for opptak», og aktørlisten i
  # .claude/rules/gherkin-conventions.md lister bare «saksbehandler». Begge
  # bør rettes opp mot «opptakssaksbehandler», men det hører ikke i denne
  # PR-en — se kommentaren nederst i filen.

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

# OPPFØLGING UTENFOR DENNE FEATUREN
# Rollenavnet «opptakssaksbehandler» er avklart som det autoritative. To
# steder i repoet bruker andre navn på det som skal være samme rolle, og bør
# rettes i en egen endring:
# - behandle_søknad.feature (@OPT-BEH-BEH-001) bruker «saksbehandler for
#   opptak».
# - Aktørlisten i .claude/rules/gherkin-conventions.md lister «administrator,
#   søker, student, saksbehandler» — «opptakssaksbehandler» mangler.
# Det er ikke gjort her, fordi endringer i felles konvensjoner og i en annen
# feature ville utvide denne PR-en utover praksisberegning.
