# language: no
@OPT-LÆR-POL-001 @must @draft
Egenskap: Opptak ved Politihøgskolen
  Som saksbehandler ved Politihøgskolen
  ønsker jeg at søkere som ikke har samtykket til registersøk eller levert politiattest og legeerklæring,
  holdes utenfor den videre behandlingen
  slik at Politihøgskolen bare går gjennom søkere som kan bli kvalifisert.

  # Kilde: notater om tilleggsbehov ved Politihøgskolen (PHS), 2026-10-16. Kravet holdes foreløpig for seg
  # selv, så det ikke blandes med de pågående kravene i 13 Søknad og saksbehandling og 14 Plasstildeling.
  # Beslektede krav:
  # - 12 Utdanningstilbud/04 Behandle et utdanningstilbud/registrere_påkrevde_attester.feature (krav om
  #   politiattest på utdanningstilbudet)
  # - 12 Utdanningstilbud/04 Behandle et utdanningstilbud/sette_tidlig_søknadsfrist.feature (tidlig søknadsfrist
  #   og dokumentasjonsfrist per utdanningstilbud)
  # - 13 Søknad og saksbehandling/03 Dokumentasjon/skjerme_dokumentasjon.feature (politiattest og legeerklæring
  #   er skjermet)
  # Politihøgskolen bruker Opptaksadmin (Eon assessment) til digitale tester, videointervju og brev med
  # sensitive opplysninger.
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

    # AVKLART 2026-10-16: Søkeren samtykker til registersøk ved å levere følgebrevet.
    Scenario: Søker som søker Politihøgskolen, må samtykke og levere attester
      Når søkeren legger til "Politiutdanning, PHS" som søknadsalternativ
      Så må søkeren levere følgebrevet med samtykke til at registersøk gjennomføres
      Og søkeren må levere politiattest og legeerklæring innen dokumentasjonsfristen

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

    # AVKLART 2026-10-16: Har søkeren samtykket til datadeling (levert følgebrevet), levert politiattest og levert
    # legeerklæring, er søkeren vurdert som reell. En reell søker får tilgang til digitale tester og
    # videointervju i Opptaksadmin, Politihøgskolens system.
    Scenario: Reell søker får tilgang til digitale tester og videointervju
      Gitt at søkeren har levert følgebrevet med samtykke til datadeling
      Og at søkeren har levert politiattest
      Og at søkeren har levert legeerklæring
      Så er søkeren vurdert som reell søker
      Og søkeren får tilgang til digitale tester og videointervju i Opptaksadmin

    Scenariomal: Søker som mangler samtykke eller en attest, får ikke tilgang til testene
      Gitt at søkeren har levert alt unntatt "<mangler>"
      Så er søkeren ikke vurdert som reell søker
      Og søkeren får ikke tilgang til digitale tester og videointervju i Opptaksadmin

      Eksempler:
        | mangler                                 |
        | følgebrevet med samtykke til datadeling |
        | politiattest                            |
        | legeerklæring                           |

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
    # - Kvalifiseringskravene over har også «er vurdert som egnet av opptaksnemnda». Skjer
    #   egnethetsvurderingen før den fysiske opptaksprøven, eller etter?

    # AVKLART 2026-10-16: Etter at søkeren har gjennomført og fått godkjent den fysiske opptaksprøven,
    # behandles søkeren som ellers i opptaket.
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
    # - Når skal Opptaksadmin skrive resultater tilbake til FS, og hvilke?

    Scenario: Opptaksadmin henter søkerne til Politihøgskolen
      Når Opptaksadmin henter søkerne til "Politiutdanning, PHS" fra FS gjennom et API
      Så har Opptaksadmin søkerne til "Politiutdanning, PHS"
      Men Opptaksadmin skriver ikke tilbake til FS

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
