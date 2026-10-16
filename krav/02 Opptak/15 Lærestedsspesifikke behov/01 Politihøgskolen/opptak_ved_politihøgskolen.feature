# language: no
@OPT-LÆR-POL-001 @must @draft
Egenskap: Opptak ved Politihøgskolen
  Som saksbehandler ved Politihøgskolen
  ønsker jeg at bare personer som har samtykket til registersøk, kan søke, og at søkere som ikke har levert
  politiattest og legeerklæring, holdes utenfor den videre behandlingen
  slik at Politihøgskolen bare går gjennom søkere som kan bli kvalifisert.

  # Kilde: notater om tilleggsbehov ved Politihøgskolen (PHS), 2026-10-16, og underlaget «Politihøgskolen og
  # behov til FS Admin», oversendt fra PHS før møtet 2026-10-16, og nettsidene til Politihøgskolen:
  # https://www.politihogskolen.no/studier/politiutdanning/soknad-og-opptak/index.html og
  # https://www.politihogskolen.no/studier/politiutdanning/soknad-og-opptak/opptakskrav/ og
  # https://www.politihogskolen.no/studier/politiutdanning/soknad-og-opptak/faq/index.html
  # Prosessen og fristene etter nettsidene: søknad i Samordna opptak innen 1. mars, følgebrev, politiattest og
  # legeerklæring via Digipost innen 20. mars (samtykket skal heretter gis i søknaden, se første regel),
  # digitale tester og videointervju i april, fysisk opptaksprøve,
  # egnethetsvurdering, frist for poengdokumentasjon 1. juli, tilbud 20. juli og svarfrist 24. juli.
  # Kravet holdes foreløpig for seg
  # selv, så det ikke blandes med de pågående kravene i 13 Søknad og saksbehandling og 14 Plasstildeling.
  # Beslektede krav:
  # - 12 Utdanningstilbud/04 Behandle et utdanningstilbud/registrere_påkrevde_attester.feature (krav om
  #   politiattest på utdanningstilbudet)
  # - 12 Utdanningstilbud/04 Behandle et utdanningstilbud/sette_tidlig_søknadsfrist.feature (tidlig søknadsfrist
  #   og dokumentasjonsfrist per utdanningstilbud)
  # - 13 Søknad og saksbehandling/03 Dokumentasjon/skjerme_dokumentasjon.feature (politiattest og legeerklæring
  #   er skjermet)
  # Politihøgskolen bruker sitt eget system Opptaksadmin til opptaksprøvene og til brev med sensitive
  # opplysninger. De digitale testene (personlighetstesten ADEPT-15 og kognitive tester) og videointervjuet
  # leveres av Aon Assessment. Politihøgskolen tilbyr studieplasser i Oslo, Stavern, Bodø og Alta
  # (nordnorsk kvote). Politihøgskolen behandler bare sine egne søkere, ikke søknadsalternativer til andre
  # læresteder.
  # Opptaksprøver: individuell vurdering av søkeren på ulike faglige grunnlag, for eksempel egnethet, fysikk,
  # eller praktisk eller utøvende kompetanse (avklart 2026-10-16, se begreper.md). Typiske eksempler er
  # Politihøgskolen og musikkhøgskolene. Hos PHS er opptaksprøvene digitale tester og videointervju, fysisk
  # opptaksprøve og egnethetsvurdering, og vurderingen skjer i Opptaksadmin. Prosessen er beskrevet som
  # individuell opptaksvurdering på https://fs.sikt.no/domenekunnskap/prosesser/individuell_opptaksvurdering/
  # Presentasjonen «Opptaksprosessen» fra Politihøgskolen, 2026-10-16:
  # - Mars: reelle søkere (BES). April: de reelle søkerne gjennomfører digitale tester og videointervju.
  #   Fra mars til juni: saksbehandling av de formelle kravene og poengrangering.
  # - Konkurranse om plass på opptaksprøvene, etter konkurransepoengsummen per 1. mars. Et utvalg søkere blir
  #   innkalt (INN/MØT). Søkerne melder seg på og gjennomfører de fysiske testene i mai og juni.
  # - Egnethetsvurdering: nemndene gjør en grunnvurdering (trinn 1), og et utvidet intervju (trinn 2) når de er i
  #   tvil, for søkere som har bestått de fysiske testene.
  # - Juli: vedtak og endelig poengrangering registreres. 20. juli: hovedopptaket i Samordna opptak, så
  #   suppleringsopptak ved behov, og studiestart i august.
  # - Hvem gjør hva: registersøk av Kripos, vandelskravet av jurist i seksjonen, de medisinske kravene av
  #   opptaksleger, og egnetheten av opptaksnemndene.
  # - Formelle krav (PHS): førerkort, norsk statsborgerskap, plettfri vandel og helsekrav. I tillegg generell
  #   studiekompetanse og karakterkrav i norsk, fysiske tester og egnethetsvurdering.
  # - Opptaksadmin er utviklet av seksjonen og Avdeling for strategi og virksomhetsstyring ved PHS. Formålet er
  #   å administrere opptaksprøvene og søkerflyten, støtte aktørene i opptaksprosessen, gi søkerne
  #   selvbetjening, og legge til rette for statistikk, rapportering og oppfølging.
  # Reglene etter «Opptaksadmin henter søkerne fra FS» er behov fra underlaget som også gjelder andre læresteder.
  # De står her foreløpig, merket som må- eller bør-behov, med kravet som bør utvides.
  #
  # ÅPNE SPØRSMÅL:
  # - Hva gjør saksbehandleren ved PHS, juristen, opptakslegene og opptaksnemndene i FS, og hva i Opptaksadmin?
  # - Hvilke kvalifiseringskrav vurderes i FS, og hvilke i Opptaksadmin?
  # - Hvor registreres resultatet av de digitale testene, videointervjuet, den fysiske opptaksprøven og
  #   egnethetsvurderingen: i FS eller i Opptaksadmin?

  Bakgrunn:
    Gitt at utdanningstilbudet "Politiutdanning, PHS" har søknadsfrist "2027-03-01 23:59"
    Og at utdanningstilbudet "Politiutdanning, PHS" har dokumentasjonsfrist "2027-03-20 23:59"

  Regel: Søkeren må samtykke til registersøk og bekrefte informasjonen om opptaket for å søke Politihøgskolen

    # AVKLART 2026-10-16: Samtykket og bekreftelsen er en grunnforutsetning for å søke. Politihøgskolen vil bare ha
    # søkere som har samtykket til registersøk og satt seg inn i informasjonen i følgebrevet og på nettsidene.
    # Samtykket og bekreftelsen gis derfor når søkeren legger til søknadsalternativet, ikke i følgebrevet etterpå.
    # I dag skiller følgebrevet reelle søkere fra ikke-reelle.
    # Erklæringene står i dag under «Samtykke og ansvarsbekreftelse» i følgebrevet, som søkeren signerer.
    Scenario: Søker må samtykke og bekrefte for å legge til politiutdanningen
      Når søkeren legger til "Politiutdanning, PHS" som søknadsalternativ
      Så må søkeren erklære dette:
        | erklæring                                                                                                                |
        | Politihøgskolen har rett til å innhente opplysninger fra politiets registre etter politiloven § 24 b                     |
        | søkeren er selv ansvarlig for at dokumentene som er sendt inn og lastet opp, er riktige                                  |
        | søkeren vet at uriktige, mangelfulle eller misvisende opplysninger kan føre til tap av retten til å fullføre utdanningen |
        | søkeren er kjent med at dokumentforfalskning blir politianmeldt                                                          |
        | søkeren har lest og forstått informasjonen på https://www.politihogskolen.no/sokerinfo                                   |

    Scenariomal: Søker som ikke samtykker eller bekrefter, kan ikke legge til politiutdanningen
      Gitt at søkeren ikke har <mangler>
      Når søkeren legger til "Politiutdanning, PHS" som søknadsalternativ
      Så er "Politiutdanning, PHS" ikke lagt til som søknadsalternativ

      Eksempler:
        | mangler                                                           |
        | samtykket til at registersøk gjennomføres                         |
        | bekreftet å ha lest informasjonen om opptaket ved Politihøgskolen |

  @openquestion
  Regel: Søkeren opplyser om domfellelser og forelegg
    # ÅPNE SPØRSMÅL:
    # - Skal spørsmålet om vandel stilles i søknaden, når søkeren legger til politiutdanningen, eller fortsatt
    #   i følgebrevet?
    # - Hvor laster søkeren opp kopien av dommen eller forelegget: i søknaden, eller i Digipost som i dag?

    # Fra følgebrevet («Om vandel»): «Har du blitt domfelt for, eller fått forelegg for straffbare handlinger?»
    # Søkeren kan legge ved en forklaring om søkeren ønsker. Forenklede forelegg legges det ikke vekt på, og
    # søkeren skal ikke opplyse om dem.
    Scenario: Søker som har blitt domfelt eller fått forelegg, må legge ved kopi
      Når søkeren svarer ja på at søkeren har blitt domfelt eller fått forelegg for straffbare handlinger
      Så må søkeren legge ved kopi av dommen eller forelegget
      Og søkeren kan legge ved en forklaring

    Scenario: Søker som ikke har blitt domfelt eller fått forelegg, legger ikke ved noe
      Når søkeren svarer nei på at søkeren har blitt domfelt eller fått forelegg for straffbare handlinger
      Så trenger ikke søkeren å legge ved kopi av dom eller forelegg

  @openquestion
  Regel: Når søkeren har samtykket, sjekkes søkeren i registrene
    # ÅPNE SPØRSMÅL:
    # - Hvem sender forespørselen til Kripos, Folkeregisteret og Statens vegvesen, og hvor kommer svaret:
    #   i FS eller i Opptaksadmin?
    # - Er henting av statsborgerskap fra Folkeregisteret et generelt behov, slik at statsborgerskapet hentes
    #   for alle søkere, og ikke bare for søkere til Politihøgskolen? I dag hentes statsborgerskapet bare for
    #   dem som blir studenter.

    Scenario: Kripos sjekker søkeren i sine registre
      Gitt at søkeren har samtykket til registersøk
      Når søkeren sjekkes i registrene
      Så sjekker Kripos opplysningene om søkeren i sine registre

    # Politihøgskolen krever bare at søkeren er norsk statsborger. Dobbelt statsborgerskap er godkjent.
    # Etter FAQ-en til PHS: søkeren må være registrert som norsk statsborger innen 1. mars i søknadsåret.
    Scenariomal: Folkeregisteret sjekker om søkeren er norsk statsborger
      Gitt at søkeren har samtykket til registersøk
      Og at søkeren er registrert med statsborgerskap <statsborgerskap> i Folkeregisteret per 1. mars 2027
      Når statsborgerskapet til søkeren hentes fra Folkeregisteret
      Så <oppfyller> søkeren kravet om norsk statsborgerskap

      Eksempler:
        | statsborgerskap | oppfyller      |
        | norsk           | oppfyller      |
        | norsk og svensk | oppfyller      |
        | svensk          | oppfyller ikke |

    # Studentene må ha hatt førerkort i minst to år når de skal ut i praksis i andre studieår.
    # Etter nettsidene til PHS: førerkort klasse B senest 1. august året før søkeren søker.
    Scenariomal: Statens vegvesen sjekker om søkeren har hatt førerkort klasse B siden 1. august året før
      Gitt at søkeren har samtykket til registersøk
      Og at søkeren søker opptak høsten 2027
      Og at søkeren fikk førerkort klasse B "<dato>"
      Når Statens vegvesen sjekker førerkortet til søkeren
      Så <oppfyller> søkeren kravet om førerkort

      Eksempler:
        | dato       | oppfyller      |
        | 2026-06-15 | oppfyller      |
        | 2026-08-01 | oppfyller      |
        | 2026-08-02 | oppfyller ikke |
        | 2027-01-10 | oppfyller ikke |

  Regel: Søkeren må levere politiattest og legeerklæring innen fristen for å bli invitert til de digitale opptaksprøvene

    # AVKLART 2026-10-16: Søkeren som har levert politiattest og legeerklæring, er en reell søker, og blir
    # invitert til de digitale opptaksprøvene: digitale tester og videointervju i Opptaksadmin, Politihøgskolens
    # system. Mangler en av dem, får søkeren ikke tilgang til de digitale opptaksprøvene, og blir registrert som
    # ikke kvalifisert.
    Scenario: Søker som har levert attestene, blir invitert til digitale tester og videointervju
      Gitt at søkeren har levert politiattest innen "2027-03-20 23:59"
      Og at søkeren har levert legeerklæring innen "2027-03-20 23:59"
      Så er søkeren vurdert som reell søker
      Og søkeren blir invitert til digitale tester og videointervju i Opptaksadmin

    Scenariomal: Søker som mangler en attest, blir ikke invitert til testene
      Gitt at søkeren ikke har levert <mangler> innen "2027-03-20 23:59"
      Når dokumentasjonsfristen er ute
      Så er søkeren ikke vurdert som reell søker
      Og søkeren blir ikke invitert til digitale tester og videointervju i Opptaksadmin
      Og søkeren er registrert som ikke kvalifisert for opptak ved Politihøgskolen

      Eksempler:
        | mangler       |
        | politiattest  |
        | legeerklæring |

  Regel: Søkere uten politiattest og legeerklæring innen fristen behandles ikke videre

    Scenario: Søker som ikke har levert innen dokumentasjonsfristen, får avslag
      Gitt at søkeren ikke har levert legeerklæring innen "2027-03-20 23:59"
      Når dokumentasjonsfristen er ute
      Så behandler Politihøgskolen ikke søknaden videre
      Og søkeren får avslag som ikke kvalifisert i plasstildelingen
      Og søkeren får beskjed om at avslaget skyldes at dokumentasjonen ikke er mottatt

    Scenario: Søkeren får ikke purring
      Gitt at søkeren ikke har levert politiattest
      Når dokumentasjonsfristen nærmer seg
      Så får søkeren ingen purring

    @openquestion
    Scenario: Saksbehandler slipper å gå gjennom søkere uten politiattest og legeerklæring
      # ÅPNE SPØRSMÅL:
      # - Skal søkerne skjules, filtreres bort, eller få avslag automatisk når fristen er ute?
      Gitt at søkeren ikke har levert politiattest og legeerklæring innen dokumentasjonsfristen
      Når saksbehandler ved Politihøgskolen går gjennom søknadene til "Politiutdanning, PHS"
      Så trenger ikke saksbehandleren å vurdere søknaden

  @openquestion
  Regel: Saksbehandler registrerer at følgebrevet er mottatt, før søknaden saksbehandles
    # ÅPNE SPØRSMÅL:
    # - Trengs følgebrevet og registreringen fortsatt når samtykket, bekreftelsen og spørsmålet om vandel gis i
    #   søknaden?

    # Følgebrevet («Følgebrev for søkere til bachelor – politiutdanning») har i dag disse delene:
    # - Søkernummer, navn, fødselsnummer, mobilnummer og e-post. Dette finnes allerede i søknaden.
    # - «Om innsending av dokumentasjon»: søkeren bekrefter å vite at signert følgebrev, komplett utfylt
    #   legeerklæring og uttømmende og utvidet politiattest skal sendes til «Politihøgskolen - opptak» i Digipost
    #   senest 20. mars for å kunne være med i opptaket. Annen dokumentasjon lastes opp i søknaden.
    # - «Om vandel»: se regelen «Søkeren opplyser om domfellelser og forelegg».
    # - «Samtykke og ansvarsbekreftelse»: se den første regelen.
    # - Obligatorisk dato og signatur.

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

  Regel: Politiattesten og legeerklæringen må oppfylle kravene til Politihøgskolen

    # Etter FAQ-en til PHS: Politiattesten skal være uttømmende og utvidet, med formålet «Student -
    # Politihøgskolen», og utstedt etter 1. februar i søknadsåret. Legeerklæringen skal være på skjemaet til
    # Politihøgskolen, signert av søkeren og en lege med norsk autorisasjon, og høyst 6 måneder gammel når den
    # sendes. Begge sendes via Digipost til «Politihøgskolen - opptak» innen 20. mars.
    Scenariomal: Politiattest eller legeerklæring som ikke oppfyller kravene
      Gitt at søkeren har levert <dokument> som <avvik>
      Så oppfyller ikke <dokument> kravene til Politihøgskolen

      Eksempler:
        | dokument      | avvik                                   |
        | politiattest  | er utstedt før 1. februar søknadsåret   |
        | legeerklæring | er mer enn 6 måneder gammel             |
        | legeerklæring | ikke er på skjemaet til Politihøgskolen |

    # Etter FAQ-en til PHS: Politiattest med merknad vurderes individuelt. Søkere med merknad kan bli godkjent
    # etter en konkret vurdering.
    Scenario: Politiattest med merknad vurderes individuelt
      Gitt at politiattesten til søkeren har en merknad
      Så vurderes vandelen til søkeren individuelt

  Regel: Hvert kvalifiseringstrinn godkjenner sine kravelementer

    # AVKLART 2026-10-16: Kvalifiseringen skjer i trinn, og hvert trinn godkjenner ulike kravelementer i
    # kompetansekravene. Et godkjent trinn gir tilgang til neste trinn. Søkeren er kvalifisert for studiet først
    # når alle kravene er oppfylt.
    Scenariomal: Søker som har fått godkjent kravelementene i et trinn, går videre
      Gitt at søkeren har fått godkjent <kravelementer>
      Så får søkeren <tilgang>

      Eksempler:
        | kravelementer                                                   | tilgang                                             |
        | samtykke til registersøk og bekreftet informasjonen om opptaket | søke "Politiutdanning, PHS"                         |
        | levert politiattest og legeerklæring                            | tilgang til digitale tester og videointervju        |
        | gjennomført digitale tester og videointervju                    | mulighet til å bli kalt inn til fysisk opptaksprøve |
        | bestått den fysiske opptaksprøven                               | egnethetsvurdering av opptaksnemnda                 |

    Scenario: Søker som har fått godkjent ett trinn, er ikke kvalifisert for studiet
      Gitt at søkeren har bestått den fysiske opptaksprøven
      Og at søkeren ikke er vurdert som egnet av opptaksnemnda ennå
      Så er søkeren ikke kvalifisert for opptak ved Politihøgskolen

  Regel: Søkeren er kvalifisert når alle kravene er oppfylt

    # Etter FAQ-en til PHS: Generell studiekompetanse må være oppnådd innen 1. mars i søknadsåret. Kravet i
    # norsk er gjennomsnittet av standpunkt og eksamen i norsk hovedmål skriftlig, minst 3,0. Det kan også
    # dekkes med minst 20 studiepoeng i norsk med gjennomsnitt D eller bedre, eller en godkjent test for søkere
    # med utenlandsk utdanning. Søkere med realkompetanse må fylle minst 25 år i søknadsåret og ha minst 5 års
    # relevant praksis. Dette hører hjemme i kompetanseregelverket (10 Regelverk).

    Scenario: Søker som oppfyller alle kravene, er kvalifisert
      Gitt at søkeren oppfyller disse kravene:
        | krav                                                                 |
        | er norsk statsborger                                                 |
        | har samtykket til at registersøk gjennomføres                        |
        | har levert politiattest                                              |
        | har levert legeerklæring                                             |
        | har generell studiekompetanse med minst 3 i norsk hovedmål skriftlig |
        | har hatt førerkort klasse B siden 1. august året før                 |
        | har plettfri vandel                                                  |
        | oppfyller helsekravene                                               |
        | har gjennomført digitale tester og videointervju                     |
        | har fått godkjent den fysiske opptaksprøven                          |
        | er vurdert som egnet av opptaksnemnda                                |
      Så er søkeren kvalifisert for opptak ved Politihøgskolen

    Scenariomal: Søker som ikke oppfyller ett av kravene, er ikke kvalifisert
      Gitt at søkeren oppfyller alle kravene unntatt "<krav>"
      Så er søkeren ikke kvalifisert for opptak ved Politihøgskolen

      Eksempler:
        | krav                                                                 |
        | er norsk statsborger                                                 |
        | har generell studiekompetanse med minst 3 i norsk hovedmål skriftlig |
        | har hatt førerkort klasse B siden 1. august året før                 |
        | har plettfri vandel                                                  |
        | oppfyller helsekravene                                               |
        | har fått godkjent den fysiske opptaksprøven                          |
        | er vurdert som egnet av opptaksnemnda                                |

  @openquestion
  Regel: Søkeren må ha gjennomført digitale tester og videointervju innen fristen
    # ÅPNE SPØRSMÅL:
    # - Hvor settes fristen for den enkelte søkeren: i FS eller i Opptaksadmin?
    # AVKLART (FAQ-en til PHS): Søkeren får en individuell frist når søkeren blir innkalt. Testene og intervjuet
    # tar omtrent 1,5 timer, og kan ikke gjentas.
    # Kravet er gjennomført eller ikke gjennomført. Testene og intervjuet gjennomføres i Opptaksadmin.

    Scenario: Søker som ikke har gjennomført digitale tester og videointervju innen fristen
      Gitt at søkeren ikke har gjennomført de digitale testene innen den individuelle fristen
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
    # Etter presentasjonen: søkerne konkurrerer om plass på opptaksprøvene, og et utvalg søkere blir innkalt.
    # AVKLART 2026-10-16: Søkerne rangeres på poeng to ganger: her, når flere søkere er kvalifisert for å bli
    # kalt inn til fysisk opptaksprøve enn Politihøgskolen vil kalle inn, og etter egnethetsvurderingen, i den
    # vanlige plasstildelingen (se «Kvalifiserte søkere rangeres og får tilbud …»).
    # Søkerne rangeres etter konkurransepoengene per 1. mars.
    Scenario: De lavest rangerte søkerne over taket får avslag
      Gitt at 1300 søkere oppfyller kravene før den fysiske opptaksprøven
      Og at Politihøgskolen innkaller 1000 søkere til fysisk opptaksprøve
      Når søkerne rangeres etter konkurransepoengene per 1. mars
      Så innkalles de 1000 høyest rangerte søkerne til fysisk opptaksprøve
      Og de 300 lavest rangerte søkerne får avslag med begrunnelsen at de er for lavt rangert på poengsum

  @openquestion
  Regel: Beståtte opptaksprøver godkjenner kravelementene for opptaksprøvene
    # ÅPNE SPØRSMÅL:
    # - Egnethet («er vurdert som egnet av opptaksnemnda») godkjennes for seg, etter den fysiske opptaksprøven
    #   (nettsidene til PHS). Hvor registreres den?

    # AVKLART 2026-10-16: Bestått fysisk opptaksprøve godkjenner kravelementet, men søkeren er først kvalifisert
    # når alle kravene er oppfylt, også egnetheten (se «Hvert kvalifiseringstrinn godkjenner sine kravelementer»).
    # Da behandles søkeren som ellers i opptaket. Presentasjonen fra PHS (trinn 8): «Bli funnet egnet, og
    # konkurrere om studieplass».
    # AVKLART 2026-10-16: Når søkeren har bestått opptaksprøvene, godkjennes de to kravene «har gjennomført
    # digitale tester og videointervju» og «har fått godkjent den fysiske opptaksprøven». Resultatet bør overføres
    # fra Opptaksadmin til FS gjennom API-et, se regelen «Opptaksadmin henter søkerne fra FS». I dag sendes det
    # som Excel-lister.
    Scenario: Beståtte opptaksprøver godkjenner kravene om tester og fysisk opptaksprøve
      Når søkeren har bestått opptaksprøvene
      Så er kravet «har gjennomført digitale tester og videointervju» godkjent
      Og kravet «har fått godkjent den fysiske opptaksprøven» er godkjent

    Scenario: Søker som ikke har bestått den fysiske opptaksprøven, er ikke kvalifisert
      Gitt at søkeren ikke har fått godkjent den fysiske opptaksprøven
      Så er søkeren ikke kvalifisert for opptak ved Politihøgskolen

  Regel: Opptaksnemnda vurderer om søkeren er egnet, etter den fysiske opptaksprøven

    # Etter FAQ-en til PHS: Vurderingen bygger på de digitale testene, videointervjuet og opplysningene fra
    # politiets registre. Er nemnda usikker, kan søkeren bli kalt inn til et utvidet intervju på Teams, på
    # omtrent 45 minutter. Søkere som ikke består opptaksprøvene, må gjennomføre egnethetsvurderingen på nytt
    # hvis de søker igjen, med unntak for dem som fikk reservasjon tidligere år.
    # Etter presentasjonen: Opptaksnemndene vurderer søkerne i to trinn: en grunnvurdering, og et utvidet intervju
    # når nemnda er i tvil.
    Scenario: Opptaksnemnda gjør en grunnvurdering av søkere som har bestått de fysiske testene
      Gitt at søkeren har bestått den fysiske opptaksprøven
      Så gjør opptaksnemnda en grunnvurdering av om søkeren er egnet

    Scenario: Søkeren blir kalt inn til utvidet intervju når opptaksnemnda er i tvil
      Gitt at opptaksnemnda er i tvil etter grunnvurderingen av søkeren
      Så blir søkeren kalt inn til et utvidet intervju

    Scenario: Søker som ikke er vurdert som egnet, får avslag i begynnelsen av juli
      Gitt at opptaksnemnda har vurdert at søkeren ikke er egnet
      Så får søkeren avslag i løpet av den første uka i juli

    Scenario: Søker som er vurdert som egnet, får svar i hovedopptaket
      Gitt at opptaksnemnda har vurdert at søkeren er egnet
      Så får ikke søkeren egen beskjed om egnetheten
      Og søkeren får svar på søknaden i hovedopptaket 20. juli

  Regel: Kvalifiserte søkere rangeres og får tilbud når de når opp i plasstildelingen

    # AVKLART 2026-10-16: Etter egnethetsvurderingen er plasstildelingen som vanlig. De kvalifiserte søkerne
    # rangeres på poenggrunnlaget fra videregående skole, og det gis tilbud til det antallet Politihøgskolen har
    # satt per utdanningskvote, i plasstildelingsrundene som ellers.
    Scenario: Kvalifisert søker rangeres på poenggrunnlaget fra videregående skole
      Gitt at søkeren er kvalifisert for opptak ved Politihøgskolen
      Når plasstildelingen gjennomføres
      Så rangeres søkeren på poenggrunnlaget fra videregående skole, på samme måte som andre kvalifiserte søkere

    Scenario: Tilbud gis til antallet Politihøgskolen har satt per utdanningskvote
      Gitt at Politihøgskolen har satt antall tilbud som skal gis per utdanningskvote for "Politiutdanning, PHS"
      Når plasstildelingsrunden gjennomføres
      Så får de høyest rangerte kvalifiserte søkerne i hver utdanningskvote tilbud, opp til antallet som er satt

    Scenario: Kvalifisert søker med nok rangeringspoeng får tilbud
      Gitt at søkeren er kvalifisert for opptak ved Politihøgskolen
      Og at søkeren har nok rangeringspoeng til å nå opp i konkurransen
      Når plasstildelingen gjennomføres
      Så får søkeren tilbud om studieplass på "Politiutdanning, PHS"

  @openquestion
  Regel: Klager på vedtak behandles av arbeidsutvalget til styret ved Politihøgskolen
    # ÅPNE SPØRSMÅL:
    # - Registreres klagen og klagevedtaket i FS, og hvordan?

    # Etter presentasjonen: klagebehandlingen skjer i Styrets arbeidsutvalg, i to omganger: først om de formelle
    # kravene, og så om egnethetsvurderingen og poengberegningen.
    Scenariomal: Søkeren klager på vedtaket
      Gitt at søkeren har fått vedtak om <vedtaket gjelder>
      Når søkeren klager på vedtaket
      Så behandles klagen av arbeidsutvalget til styret ved Politihøgskolen

      Eksempler:
        | vedtaket gjelder                             |
        | de formelle kravene, med helsekrav og vandel |
        | egnethetsvurderingen og poengberegningen     |

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

  # Bør-behov fra underlaget. Antatt et generelt behov i saksbehandlingen, se
  # 13 Søknad og saksbehandling/02 Behandling/hendelseslogg_for_saksbehandling.feature.
  Regel: Saksbehandler kan se hvilke endringer som er gjort på en søker

    Scenario: Saksbehandler ser endringene på søkeren
      Gitt at en annen saksbehandler har endret statusen på søkeren
      Når saksbehandler ved Politihøgskolen åpner søkeren
      Så ser saksbehandleren hvem som endret statusen, og når
