# language: no
# GitHub: #560
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

    @openquestion
    Scenario: AVKLAR hvilke praksistyper som kan velges
      # ÅPNE SPØRSMÅL:
      # - Praksisperioden registreres med «angitt type», men det er ikke
      #   avklart hvilke typer som finnes. Er typene en fast kodeliste
      #   (f.eks. arbeidsforhold, verneplikt, omsorgsarbeid), hentes de fra
      #   kravelementet i kompetanseregelverket, eller skriver
      #   saksbehandleren inn fritekst?
      # - Har typen betydning for beregningen, eller er den kun
      #   dokumentasjon av hva praksisen besto i?
      Gitt spørsmålet er åpent

    @openquestion
    Scenario: AVKLAR validering av datoene i en praksisperiode
      # ÅPNE SPØRSMÅL:
      # - Skal registreringen avvises når sluttdatoen er før startdatoen, og
      #   hva skal i så fall fremgå for saksbehandleren?
      # - Kan en praksisperiode registreres uten sluttdato når
      #   arbeidsforholdet fortsatt løper, og regnes den da til dagens dato
      #   eller til søknadsfristen?
      # - Skal perioder som strekker seg inn i framtiden kunne registreres?
      Gitt spørsmålet er åpent

    @openquestion
    Scenario: AVKLAR kobling mellom praksisperiode og dokumentasjon
      # ÅPNE SPØRSMÅL:
      # - Praksisen bygger på bekreftelse fra arbeidsgiver som søkeren har
      #   lastet opp. Skal den enkelte praksisperioden kunne knyttes til det
      #   opplastede dokumentet den er basert på, eller registreres perioden
      #   uavhengig av dokumentasjonen?
      Gitt spørsmålet er åpent

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

    @openquestion
    Scenario: AVKLAR hvor antall timer per årsverk oppgis
      # ÅPNE SPØRSMÅL:
      # - Antall timer per årsverk skal kunne oppgis, men det er ikke avklart
      #   hvor. Oppgis det per praksisperiode (slik at arbeidsforhold med
      #   ulikt årsverk kan behandles hver for seg), én gang per beregning
      #   for søkeren, eller defineres det på kravelementet i
      #   kompetanseregelverket?
      # - Hvis det oppgis av saksbehandleren: finnes det en forhåndsutfylt
      #   standardverdi, og skal verdien lagres sammen med beregningen slik
      #   at den kan etterprøves?
      Gitt spørsmålet er åpent

    @openquestion
    Scenario: AVKLAR om omfanget kan oppgis på begge måter for samme periode
      # ÅPNE SPØRSMÅL:
      # - Skal saksbehandleren velge én av måtene per praksisperiode, eller
      #   kan både stillingsprosent og timeantall registreres på samme
      #   periode? Hvis begge kan registreres: hvilket omfang legges til
      #   grunn i beregningen?
      Gitt spørsmålet er åpent

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

    @openquestion
    Scenario: AVKLAR avrunding og tidsenhet i beregningen
      # ÅPNE SPØRSMÅL:
      # - Regnes periodens kalendertid i dager, måneder eller år, og hvordan
      #   håndteres skuddår og måneder med ulik lengde?
      # - Hvor mange desimaler oppgis samlet praksis med, og rundes det av
      #   per praksisperiode eller først på totalsummen?
      # - Er start- og sluttdato inklusive, slik at 01.01.2020–31.12.2020
      #   utgjør ett helt år?
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
