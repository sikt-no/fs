# language: no
@OPT-LÆR-POL-001 @must @draft
Egenskap: Opptak ved Politihøgskolen
  Som saksbehandler ved Politihøgskolen
  ønsker jeg at søkere som ikke har samtykket til registersøk eller levert politiattest og legeerklæring,
  holdes utenfor den videre behandlingen
  slik at Politihøgskolen bare går gjennom søkere som kan bli kvalifisert.

  # Kilde: notater om tilleggsbehov ved Politihøgskolen (PHS), 2026-10-16, og underlaget «Politihøgskolen og
  # behov til FS Admin», oversendt fra PHS før møtet 2026-10-16. Kravet holdes foreløpig for seg
  # selv, så det ikke blandes med de pågående kravene i 13 Søknad og saksbehandling og 14 Plasstildeling.
  # Beslektede krav:
  # - 12 Utdanningstilbud/04 Behandle et utdanningstilbud/registrere_påkrevde_attester.feature (krav om
  #   politiattest på utdanningstilbudet)
  # - 12 Utdanningstilbud/04 Behandle et utdanningstilbud/sette_tidlig_søknadsfrist.feature (tidlig søknadsfrist
  #   og dokumentasjonsfrist per utdanningstilbud)
  # - 13 Søknad og saksbehandling/03 Dokumentasjon/skjerme_dokumentasjon.feature (politiattest og legeerklæring
  #   er skjermet)
  # Politihøgskolen bruker Opptaksadmin (Eon assessment) til digitale tester, videointervju og brev med
  # sensitive opplysninger. Politihøgskolen behandler bare sine egne søkere, ikke søknadsalternativer til andre
  # læresteder.
  # Opptaksprøver: individuell vurdering av søkeren på ulike faglige grunnlag, for eksempel egnethet, fysikk,
  # eller praktisk eller utøvende kompetanse (avklart 2026-10-16, se begreper.md). Typiske eksempler er
  # Politihøgskolen og musikkhøgskolene. Hos PHS er opptaksprøvene digitale tester og videointervju, fysisk
  # opptaksprøve og egnethetsvurdering, og vurderingen skjer i Opptaksadmin. Prosessen er beskrevet som
  # individuell opptaksvurdering på https://fs.sikt.no/domenekunnskap/prosesser/individuell_opptaksvurdering/
  # Reglene etter «Opptaksadmin henter søkerne fra FS» er behov fra underlaget som også gjelder andre læresteder.
  # De står her foreløpig, merket som må- eller bør-behov, med kravet som bør utvides.
  #
  # ÅPNE SPØRSMÅL:
  # - Hvem gjør hva: saksbehandler ved PHS, opptaksnemnd og fagspesialister (helse, vandel, egnethet)?
  # - Hvilke kvalifiseringskrav vurderes i FS, og hvilke i Opptaksadmin?
  # - Hvor registreres resultatet av de digitale testene, videointervjuet, den fysiske opptaksprøven og
  #   egnethetsvurderingen: i FS eller i Opptaksadmin?

  Bakgrunn:
    Gitt at utdanningstilbudet "Politiutdanning, PHS" har søknadsfrist "2027-03-01 23:59"
    Og at utdanningstilbudet "Politiutdanning, PHS" har dokumentasjonsfrist "2027-03-20 23:59"

  Regel: Søkere til Politihøgskolen må samtykke til registersøk og levere politiattest og legeerklæring

    # AVKLART 2026-10-16: Søkeren samtykker til registersøk ved å levere følgebrevet. I følgebrevet samtykker
    # søkeren til søk i politiets systemer og registre, og bekrefter å ha lest og forstått informasjonen om
    # opptaket på nettsidene til Politihøgskolen, blant annet fristene.
    Scenario: Søker som søker Politihøgskolen, må samtykke og levere attester
      Når søkeren legger til "Politiutdanning, PHS" som søknadsalternativ
      Så må søkeren levere følgebrevet med samtykke til at registersøk gjennomføres
      Og søkeren må levere politiattest og legeerklæring innen dokumentasjonsfristen

    Scenario: Søkeren bekrefter i følgebrevet å ha lest informasjonen om opptaket
      Når søkeren leverer følgebrevet
      Så bekrefter søkeren å ha lest og forstått informasjonen om opptaket på nettsidene til Politihøgskolen

  @openquestion
  Regel: Når søkeren har samtykket, sjekkes søkeren i registrene
    # ÅPNE SPØRSMÅL:
    # - Hvem sender forespørselen til Kripos, Folkeregisteret og Statens vegvesen, og hvor kommer svaret:
    #   i FS eller i Opptaksadmin?
    # - Hvilken dag i august gjelder for førerkortet?

    Scenario: Kripos sjekker søkeren i sine registre
      Gitt at søkeren har levert følgebrevet med samtykke til registersøk
      Når søkeren sjekkes i registrene
      Så sjekker Kripos opplysningene om søkeren i sine registre

    Scenario: Folkeregisteret sjekker statsborgerskapet til søkeren
      Gitt at søkeren har levert følgebrevet med samtykke til registersøk
      Når søkeren sjekkes i registrene
      Så sjekker Folkeregisteret om søkeren er norsk statsborger

    # Studentene må ha hatt førerkort i minst to år når de skal ut i praksis i andre studieår.
    Scenariomal: Statens vegvesen sjekker om søkeren har hatt førerkort siden august året før opptaket
      Gitt at søkeren har levert følgebrevet med samtykke til registersøk
      Og at søkeren søker opptak høsten 2027
      Og at søkeren fikk førerkort "<dato>"
      Når Statens vegvesen sjekker førerkortet til søkeren
      Så <oppfyller> søkeren kravet om førerkort

      Eksempler:
        | dato       | oppfyller      |
        | 2026-06-15 | oppfyller      |
        | 2027-01-10 | oppfyller ikke |

  Regel: Søkere uten samtykke og dokumentasjon innen fristen behandles ikke videre

    Scenario: Søker som ikke har levert innen dokumentasjonsfristen
      Gitt at søkeren ikke har levert legeerklæring innen "2027-03-20 23:59"
      Når dokumentasjonsfristen er ute
      Så behandler Politihøgskolen ikke søknaden videre
      Og søkeren går ikke videre til digitale tester og videointervju
      Og søkeren får avslag som ikke kvalifisert i plasstildelingen
      Og søkeren får beskjed om at avslaget skyldes at dokumentasjonen ikke er mottatt

    Scenario: Søkeren får ikke purring
      Gitt at søkeren ikke har levert politiattest
      Når dokumentasjonsfristen nærmer seg
      Så får søkeren ingen purring

    @openquestion
    Scenario: Saksbehandler slipper å gå gjennom søkere uten samtykke og dokumentasjon
      # ÅPNE SPØRSMÅL:
      # - Skal søkerne skjules, filtreres bort, eller få avslag automatisk når fristen er ute?
      Gitt at søkeren ikke har samtykket til registersøk innen dokumentasjonsfristen
      Når saksbehandler ved Politihøgskolen går gjennom søknadene til "Politiutdanning, PHS"
      Så trenger ikke saksbehandleren å vurdere søknaden

  Regel: Søker som har samtykket og levert attestene, er en reell søker og får gjennomføre testene

    # AVKLART 2026-10-16: Har søkeren samtykket til registersøk (levert følgebrevet), levert politiattest og levert
    # legeerklæring, er søkeren vurdert som reell. En reell søker får tilgang til digitale tester og
    # videointervju i Opptaksadmin, Politihøgskolens system.
    Scenario: Reell søker får tilgang til digitale tester og videointervju
      Gitt at søkeren har levert følgebrevet med samtykke til registersøk
      Og at søkeren har levert politiattest
      Og at søkeren har levert legeerklæring
      Så er søkeren vurdert som reell søker
      Og søkeren får tilgang til digitale tester og videointervju i Opptaksadmin

    Scenariomal: Søker som mangler samtykke eller en attest, får ikke tilgang til testene
      Gitt at søkeren har levert alt unntatt "<mangler>"
      Så er søkeren ikke vurdert som reell søker
      Og søkeren får ikke tilgang til digitale tester og videointervju i Opptaksadmin

      Eksempler:
        | mangler                                  |
        | følgebrevet med samtykke til registersøk |
        | politiattest                             |
        | legeerklæring                            |

  Regel: Saksbehandler registrerer at følgebrevet er mottatt, før søknaden saksbehandles

    # Fra underlaget: I dag har alle søkere «Mottatt følgeskjema» = nei når de overføres til FS i begynnelsen av
    # mars. Følgebrevet kommer via Digipost, og saksbehandleren registrerer at det er mottatt. Følgebrevet skiller
    # reelle søkere fra ikke-reelle, så registreringen må skje før saksbehandleren vurderer kravelementer og grunnlag.
    Scenario: Følgebrevet er ikke registrert som mottatt når søkeren kommer inn
      Når søkeren har søkt på "Politiutdanning, PHS"
      Så er følgebrevet fra søkeren registrert som ikke mottatt

    Scenario: Saksbehandler registrerer at følgebrevet er mottatt
      Gitt at søkeren har sendt følgebrevet
      Når saksbehandler ved Politihøgskolen registrerer at følgebrevet fra søkeren er mottatt
      Så er følgebrevet fra søkeren registrert som mottatt

    Scenario: Søknad uten mottatt følgebrev saksbehandles ikke
      Gitt at følgebrevet fra søkeren ikke er registrert som mottatt
      Når saksbehandler ved Politihøgskolen går gjennom søknadene til "Politiutdanning, PHS"
      Så vurderer ikke saksbehandleren kravelementer og grunnlag for søknaden

  @openquestion
  Regel: Saksbehandler setter status på søkeren etter hvor søkeren er i opptaksprosessen
    # ÅPNE SPØRSMÅL:
    # - Er dette alle statusene, og settes de av saksbehandleren, eller av FS når søkeren oppfyller et krav?
    # - Kan statusen settes for mange søkere samtidig?

    # Fra underlaget: I dag brukes opptaksprøvestatus i FS: BES for tilgang til digitale tester og videointervju,
    # og INN og MØT for innkalling til og oppmøte på fysisk opptaksprøve.
    Scenariomal: Saksbehandler setter status på søkeren
      Når saksbehandler ved Politihøgskolen setter statusen "<status>" på søkeren
      Så har søkeren statusen "<status>"

      Eksempler:
        | status                                       |
        | tilgang til digitale tester og videointervju |
        | innkalt til fysisk opptaksprøve              |
        | møtt til fysisk opptaksprøve                 |

    Scenario: Bare reelle søkere får tilgang til digitale tester og videointervju
      Gitt at søkeren ikke er vurdert som reell søker
      Når saksbehandler ved Politihøgskolen vil gi søkeren statusen "tilgang til digitale tester og videointervju"
      Så får søkeren ikke statusen

  Regel: Søkeren er kvalifisert når alle kravene er oppfylt

    Scenario: Søker som oppfyller alle kravene, er kvalifisert
      Gitt at søkeren oppfyller disse kravene:
        | krav                                              |
        | er norsk statsborger                              |
        | har samtykket til at registersøk gjennomføres     |
        | har levert politiattest                           |
        | har levert legeerklæring                          |
        | har generell studiekompetanse med minst 3 i norsk |
        | har hatt førerkort siden august året før opptaket |
        | har plettfri vandel                               |
        | oppfyller helsekravene                            |
        | har gjennomført digitale tester og videointervju  |
        | har fått godkjent den fysiske opptaksprøven       |
        | er vurdert som egnet av opptaksnemnda             |
      Så er søkeren kvalifisert for opptak ved Politihøgskolen

    Scenariomal: Søker som ikke oppfyller ett av kravene, er ikke kvalifisert
      Gitt at søkeren oppfyller alle kravene unntatt "<krav>"
      Så er søkeren ikke kvalifisert for opptak ved Politihøgskolen

      Eksempler:
        | krav                                              |
        | er norsk statsborger                              |
        | har generell studiekompetanse med minst 3 i norsk |
        | har hatt førerkort siden august året før opptaket |
        | har plettfri vandel                               |
        | oppfyller helsekravene                            |
        | har fått godkjent den fysiske opptaksprøven       |
        | er vurdert som egnet av opptaksnemnda             |

  @openquestion
  Regel: Søkeren må ha gjennomført digitale tester og videointervju innen fristen
    # ÅPNE SPØRSMÅL:
    # - Hvilken dato i april er fristen, og hvor settes den?
    # Kravet er gjennomført eller ikke gjennomført. Testene og intervjuet gjennomføres i Opptaksadmin.

    Scenario: Søker som ikke har gjennomført digitale tester og videointervju innen fristen
      Gitt at søkeren ikke har gjennomført de digitale testene innen fristen i april
      Så er søkeren ikke kvalifisert for opptak ved Politihøgskolen

  Regel: Søkere som har gjennomført digitale tester og videointervju, kan kalles inn til fysisk opptaksprøve

    Scenario: Søker som har gjennomført testene, kan kalles inn til fysisk opptaksprøve
      Gitt at søkeren har gjennomført de digitale testene og videointervjuet
      Så kan søkeren kalles inn til fysisk opptaksprøve

    Scenario: Søker som ikke har gjennomført testene, kalles ikke inn til fysisk opptaksprøve
      Gitt at søkeren ikke har gjennomført videointervjuet
      Så kalles søkeren ikke inn til fysisk opptaksprøve

  @openquestion
  Regel: Politihøgskolen kan sette et tak for hvor mange som innkalles til fysisk opptaksprøve
    # ÅPNE SPØRSMÅL:
    # - Hvem setter taket, og hvor: i FS eller i Opptaksadmin?
    # - Hva skjer ved lik poengsum ved taket?

    # De siste årene har Politihøgskolen tatt inn alle som oppfyller kravene. Av og til trengs et tak.
    # Søkerne rangeres etter konkurransepoengene per 1. mars.
    Scenario: De lavest rangerte søkerne over taket får avslag
      Gitt at 1300 søkere oppfyller kravene før den fysiske opptaksprøven
      Og at Politihøgskolen innkaller 1000 søkere til fysisk opptaksprøve
      Når søkerne rangeres etter konkurransepoengene per 1. mars
      Så innkalles de 1000 høyest rangerte søkerne til fysisk opptaksprøve
      Og de 300 lavest rangerte søkerne får avslag med begrunnelsen at de er for lavt rangert på poengsum

  @openquestion
  Regel: Søker som har bestått den fysiske opptaksprøven, er kvalifisert og rangeres i plasstildelingen
    # ÅPNE SPØRSMÅL:
    # - Egnethet («er vurdert som egnet av opptaksnemnda») godkjennes for seg. Når vurderes den, og hvor
    #   registreres den?

    # AVKLART 2026-10-16: Etter at søkeren har gjennomført og fått godkjent den fysiske opptaksprøven,
    # behandles søkeren som ellers i opptaket.
    # AVKLART 2026-10-16: Når søkeren har bestått opptaksprøvene, godkjennes de to kravene «har gjennomført
    # digitale tester og videointervju» og «har fått godkjent den fysiske opptaksprøven». Resultatet bør overføres
    # fra Opptaksadmin til FS gjennom API-et, se regelen «Opptaksadmin henter søkerne fra FS». I dag sendes det
    # som Excel-lister.
    Scenario: Beståtte opptaksprøver godkjenner kravene om tester og fysisk opptaksprøve
      Når søkeren har bestått opptaksprøvene
      Så er kravet «har gjennomført digitale tester og videointervju» godkjent
      Og kravet «har fått godkjent den fysiske opptaksprøven» er godkjent

    Scenario: Søker som har bestått den fysiske opptaksprøven, rangeres i plasstildelingen
      Gitt at søkeren har gjennomført den fysiske opptaksprøven
      Og at søkeren har fått godkjent den fysiske opptaksprøven
      Så er søkeren kvalifisert for opptak ved Politihøgskolen
      Og søkeren rangeres i plasstildelingen på samme måte som andre kvalifiserte søkere

    Scenario: Søker som ikke har bestått den fysiske opptaksprøven, er ikke kvalifisert
      Gitt at søkeren ikke har fått godkjent den fysiske opptaksprøven
      Så er søkeren ikke kvalifisert for opptak ved Politihøgskolen

  Regel: Kvalifiserte søkere får tilbud når de når opp i plasstildelingen

    Scenario: Kvalifisert søker med nok rangeringspoeng får tilbud
      Gitt at søkeren er kvalifisert for opptak ved Politihøgskolen
      Og at søkeren har nok rangeringspoeng til å nå opp i konkurransen
      Når plasstildelingen gjennomføres
      Så får søkeren tilbud om studieplass på "Politiutdanning, PHS"

  @openquestion
  Regel: Opptaksadmin henter søkerne fra FS
    # ÅPNE SPØRSMÅL:
    # - Hvilke opplysninger om søkerne skal Opptaksadmin hente?

    Scenario: Opptaksadmin henter søkerne til Politihøgskolen
      Når Opptaksadmin henter søkerne til "Politiutdanning, PHS" fra FS gjennom et API
      Så har Opptaksadmin søkerne til "Politiutdanning, PHS"

    # AVKLART 2026-10-16: Resultatet av opptaksprøvene bør overføres fra Opptaksadmin til FS gjennom API-et.
    # I dag sendes det som Excel-lister. Bare resultatet av de to opptaksprøvene (digitale tester og videointervju,
    # og fysisk opptaksprøve) skrives tilbake til FS.
    Scenario: Opptaksadmin overfører resultatet av opptaksprøvene til FS
      Gitt at søkeren har bestått opptaksprøvene i Opptaksadmin
      Når Opptaksadmin overfører resultatet til FS gjennom API-et
      Så er kravet «har gjennomført digitale tester og videointervju» godkjent i FS
      Og kravet «har fått godkjent den fysiske opptaksprøven» er godkjent i FS

    # Fra underlaget: Opptaksadmin må kunne finne hvilke søkere som skal overføres. Løsningen bør avklares tidlig.
    Scenario: Opptaksadmin henter hvem som er reelle søkere og statusen til søkerne
      Gitt at søkeren er vurdert som reell søker
      Og at søkeren har statusen "innkalt til fysisk opptaksprøve"
      Når Opptaksadmin henter søkerne til "Politiutdanning, PHS" fra FS gjennom et API
      Så får Opptaksadmin vite at søkeren er reell søker
      Og Opptaksadmin får statusen "innkalt til fysisk opptaksprøve" for søkeren

    Scenario: Brev med sensitive opplysninger sendes fra Opptaksadmin
      Når Politihøgskolen sender brev til søkerne om opptaksprosessen
      Så sendes brevet fra Opptaksadmin, og ikke fra FS

  @openquestion
  Regel: Saksbehandlere og opptaksnemnda kan dele dokumentasjonen om søkeren
    # ÅPNE SPØRSMÅL:
    # - Hvilken dokumentasjon skal deles, og med hvem: saksbehandlere ved PHS, opptaksnemnda og
    #   fagspesialistene for helse, vandel og egnethet?
    # - Skal delingen skje i FS eller i Opptaksadmin?

    Scenario: Fagspesialist for helse ser legeerklæringen
      Gitt at søkeren har levert legeerklæring
      Når fagspesialisten for helse vurderer helsekravene for søkeren
      Så ser fagspesialisten legeerklæringen

  # Må-behov fra underlaget. Bør utvides i 13 Søknad og saksbehandling/01 Søknad/veilede_om_dokumentasjon.feature
  # og 13 Søknad og saksbehandling/03 Dokumentasjon/skjerme_dokumentasjon.feature.
  Regel: Søkeren kan laste opp dokumenter i særlige kategorier, og saksbehandleren ser dem

    Scenario: Saksbehandler ser legeerklæringen søkeren har lastet opp
      Gitt at søkeren har lastet opp legeerklæringen i Min kompetanse
      Når saksbehandler ved Politihøgskolen åpner søknaden
      Så ser saksbehandleren legeerklæringen

  # Må-behov fra underlaget. Finnes ikke i kravene i dag.
  Regel: Saksbehandler kan legge til interne dokumenter og arbeidsnotater som søkeren ikke ser

    Scenario: Saksbehandler laster opp et vurderingsskjema for realkompetanse
      Når saksbehandler ved Politihøgskolen laster opp et vurderingsskjema for realkompetanse på søknaden
      Så følger vurderingsskjemaet søknaden
      Men søkeren ser ikke vurderingsskjemaet

    Scenario: Saksbehandler skriver et arbeidsnotat
      Når saksbehandler ved Politihøgskolen skriver et arbeidsnotat på søknaden
      Så ser andre saksbehandlere arbeidsnotatet
      Men søkeren ser ikke arbeidsnotatet

  # Må-behov fra underlaget. Bør utvides i 13 Søknad og saksbehandling/03 Dokumentasjon/skjerme_dokumentasjon.feature.
  Regel: Opptakslegen får lesetilgang til utvalgte dokumenter for utvalgte søkere

    Scenario: Opptakslegen ser bare dokumentene som er delt
      Gitt at saksbehandler ved Politihøgskolen har gitt opptakslegen lesetilgang til legeerklæringen til søkeren
      Når opptakslegen åpner søknaden
      Så ser opptakslegen legeerklæringen
      Men opptakslegen ser ikke de andre dokumentene søkeren har lastet opp

    Scenario: Opptakslegen skriver et internt arbeidsnotat
      Når opptakslegen skriver et arbeidsnotat om helsekravene for søkeren
      Så ser saksbehandlerne ved Politihøgskolen arbeidsnotatet
      Men søkeren ser ikke arbeidsnotatet

  # Må-behov fra underlaget. Finnes ikke i kravene i dag.
  Regel: Saksbehandler ser den midlertidige konkurransepoengsummen, også når søkeren ikke er kvalifisert

    Scenario: Saksbehandler ser poengsummen til en søker som ikke er kvalifisert ennå
      Gitt at søkeren ikke er kvalifisert ennå
      Når saksbehandler ved Politihøgskolen åpner søknaden
      Så ser saksbehandleren den midlertidige konkurransepoengsummen til søkeren

  # Må-behov fra underlaget. Bør utvides i 10 Regelverk/02 Krav/kravelement.feature.
  Regel: Kravelementer vurderes også for søkere med realkompetanse

    Scenario: Saksbehandler vurderer kravelementene for en søker med realkompetanse
      Gitt at søkeren søker på grunnlag av realkompetanse
      Når saksbehandler ved Politihøgskolen vurderer søknaden
      Så kan saksbehandleren registrere kravelementene som oppfylt eller ikke oppfylt

  # Må-behov fra underlaget. Bør utvides i 10 Felleskrav/10 Tabellvisninger/01 Tabeller/eksport.feature.
  Regel: Saksbehandler kan hente ut søkerlister til Excel

    Scenario: Saksbehandler henter ut en søkerliste som skal sendes til Kripos
      Gitt at saksbehandler ved Politihøgskolen har valgt de reelle søkerne
      Når saksbehandleren henter ut søkerlisten til Excel
      Så får saksbehandleren en Excel-fil med de reelle søkerne

  # Må-behov fra underlaget. Finnes ikke i kravene i dag.
  Regel: Saksbehandler kan sende e-post til et utvalg søkere samtidig

    Scenario: Saksbehandler sender innkalling til fysisk opptaksprøve
      Gitt at saksbehandler ved Politihøgskolen har valgt søkerne med statusen "innkalt til fysisk opptaksprøve"
      Når saksbehandleren sender en e-post med innkallingen til søkerne
      Så får hver av søkerne e-posten

  # Må-behov fra underlaget. Bør utvides i 13 Søknad og saksbehandling/02 Behandling/søknadsmangler.feature.
  Regel: Opptakskravene kan registreres som oppfylt på ulike tidspunkt

    # Søkerne oppfyller først de formelle kravene, og deretter kravene til fysisk opptaksprøve og egnethet.
    # Vedtak på opptakskravene registreres fra mars og april til juni og juli.
    Scenario: Saksbehandler registrerer de formelle kravene før den fysiske opptaksprøven
      Gitt at saksbehandler ved Politihøgskolen registrerte de formelle kravene som oppfylt i april
      Når saksbehandleren registrerer kravet om fysisk opptaksprøve som oppfylt i juni
      Så er både de formelle kravene og kravet om fysisk opptaksprøve registrert som oppfylt

  # Bør-behov fra underlaget. Finnes ikke i kravene i dag.
  Regel: Saksbehandler kan forhåndsvise dokumentene søkeren har lastet opp

    Scenario: Saksbehandler forhåndsviser politiattesten
      Gitt at søkeren har lastet opp politiattest
      Når saksbehandler ved Politihøgskolen åpner politiattesten
      Så ser saksbehandleren politiattesten uten å laste den ned

  # Bør-behov fra underlaget. Bør utvides i 13 Søknad og saksbehandling/02 Behandling/tildele_saksbehandlende_organisasjon.feature.
  Regel: Søknader kan tildeles saksbehandlere i grupper, og omfordeles

    Scenario: Saksbehandler omfordeler en gruppe søknader
      Gitt at en gruppe søknader er tildelt saksbehandleren "Kari Nordmann"
      Når søknadene omfordeles til saksbehandleren "Ola Nordmann"
      Så er søknadene tildelt "Ola Nordmann"

  # Bør-behov fra underlaget. Bør utvides i 11 Opprette og vedlikeholde opptak/06 Hendelseslogg/hendelseslogg.feature.
  Regel: Saksbehandler kan se hvilke endringer som er gjort på en søker

    Scenario: Saksbehandler ser endringene på søkeren
      Gitt at en annen saksbehandler har endret statusen på søkeren
      Når saksbehandler ved Politihøgskolen åpner søkeren
      Så ser saksbehandleren hvem som endret statusen, og når
