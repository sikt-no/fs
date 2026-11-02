# language: no
# GitHub: #413
@OPT-BEH-BEH-008 @must @planned
Egenskap: Søknadsmangler
  Som saksbehandler ved saksbehandlende organisasjon
  ønsker jeg å registrere mangler i saken og gi søkeren beskjed om manglene
  slik at søkeren laster opp riktig dokumentasjon for opptakskravene til søknadsalternativene sine.

  Under saksbehandlingen oppdager saksbehandleren ofte at søknaden er mangelfull: søkeren har
  ikke dokumentert et opptakskrav, dokumentet kan ikke brukes (mangler oversettelse, stempel
  eller signatur), eller søkeren har prøvd å dokumentere grunnlag for poeng eller en kvote uten
  å lykkes. Saksbehandleren registrerer da en mangel i saken. Mangelen er grunnlaget for
  meldingen til søkeren, og søkeren ser på dokumentasjonssiden i Min kompetanse hva som mangler,
  og kan laste opp dokumentasjonen der.

  Mangler lages også automatisk. Er søkeren ikke kvalifisert, får saken automatiske
  mangeltekster for kravelementene søkeren ikke oppfyller, og tekstene slettes automatisk når
  søkeren blir kvalifisert. Mangelen for generell studiekompetanse som fullføres i vår, settes og
  sjekkes ut automatisk.

  Mangler hører til saken, det vil si søknadsalternativene én saksbehandlende organisasjon har
  (se @OPT-BEH-BEH-011). Hver mangelkode hører til en kategori, og kategorien avgjør hva
  mangelen hindrer:
  - Generelle krav: saksbehandleren kan ikke sette søkeren som kvalifisert til noen av
    søknadsalternativene i saken.
  - Spesielle krav: mangelen knyttes til et kompetanseregelverk, og saksbehandleren kan ikke
    sette søkeren som kvalifisert til søknadsalternativene med kompetanseregelverket.
  - Poeng: hindrer ikke kvalifisering.
  - Kvote: mangelen knyttes til et kvotespørsmål, og hindrer ikke kvalifisering.

  Uansett kategori kan en mangelkode også stoppe for opptak.

  Kravet har seks deler:
  1. Mangelkoder – opptaksforvalteren forvalter mangelkodene og tekstene, og merker mangelkoden
     for generell studiekompetanse som fullføres i vår.
  2. Registrering – saksbehandleren registrerer, sjekker ut og sletter mangler i saken.
  3. Publisering og melding – søkeren får se manglene og får melding om dem, med frist.
  4. Søkerens visning – søkeren ser manglene og laster opp dokumentasjon på dokumentasjonssiden.
  5. Innsyn – hvem som ser manglene i sakene, og hvordan saksbehandleren finner sakene med en
     bestemt mangelkode.
  6. Automatikk – mangler som settes og sjekkes ut automatisk.

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" forvaltes av HK-dir
    Og at opptaket bruker regelverkssamlingen "UHG 2027"
    Og at "Universitetet i Oslo" og "UiT Norges arktiske universitet" deltar i opptaket

  # ── 1. Mangelkoder ───────────────────────────────────────────

  Regel: Opptaksforvalteren forvalter mangelkodene i regelverkssamlingen

    Scenario: Opprette mangelkode
      Når opptaksforvalteren ved HK-dir oppretter en mangelkode i regelverkssamlingen "UHG 2027" med følgende opplysninger
        | felt                                   | verdi                                    |
        | Kode                                   | KAR                                      |
        | Kategori                               | Spesielle krav                           |
        | Kort beskrivelse                       | Mangler karakter                         |
        | Informasjon til søker i Min kompetanse | Du mangler karakter i et fag som kreves. |
        | Stopper for opptak                     | Nei                                      |
        | Aktiv                                  | Ja                                       |
      Så finnes mangelkoden "KAR" i regelverkssamlingen "UHG 2027"

    Scenario: Tilgjengelige kategorier for mangelkoder
      Når opptaksforvalteren ved HK-dir velger kategori for en mangelkode
      Så kan opptaksforvalteren velge mellom følgende kategorier
        | Kategori       |
        | Generelle krav |
        | Spesielle krav |
        | Poeng          |
        | Kvote          |

    Scenariomal: Opptaksforvalteren ved <organisasjon> forvalter mangelkodene i <opptak>
      Gitt at opptaket "<opptak>" forvaltes av "<organisasjon>"
      Når opptaksforvalteren ved <organisasjon> åpner mangelkodene i regelverkssamlingen til "<opptak>"
      Så kan opptaksforvalteren opprette og endre mangelkodene

      Eksempler:
        | opptak                  | organisasjon         |
        | Samordna opptak 2027    | HK-dir               |
        | Lokalt opptak høst 2027 | Universitetet i Oslo |

  @draft @ref-FLY-OPT-AUT-001
  Regel: Opptaksforvalteren merker én mangelkode for generell studiekompetanse som fullføres i vår

    Mangelkoden som er merket, er den saken får automatisk når søkeren oppgir at generell
    studiekompetanse fullføres i vår (se «6. Automatikk»). Bare én mangelkode i
    regelverkssamlingen kan være merket, og den må være i kategorien «Generelle krav» og stoppe
    for opptak.
    # I det gamle systemet het mangelkoden DUA. Eksemplene bruker den koden.

    Scenario: Opptaksforvalteren merker mangelkoden for generell studiekompetanse som fullføres i vår
      Gitt at regelverkssamlingen "UHG 2027" har mangelkoden "DUA" i kategorien "Generelle krav", som stopper for opptak
      Når opptaksforvalteren ved HK-dir merker mangelkoden "DUA" for generell studiekompetanse som fullføres i vår
      Så er "DUA" mangelkoden for generell studiekompetanse som fullføres i vår i regelverkssamlingen "UHG 2027"

    Scenario: Bare én mangelkode i regelverkssamlingen kan være merket for generell studiekompetanse som fullføres i vår
      Gitt at regelverkssamlingen "UHG 2027" har mangelkodene "DUA" og "VIT"
      Og at mangelkoden "DUA" er merket for generell studiekompetanse som fullføres i vår
      Når opptaksforvalteren ved HK-dir merker mangelkoden "VIT" for generell studiekompetanse som fullføres i vår
      Så avvises endringen med melding om at mangelkoden "DUA" allerede er merket

    Scenariomal: Mangelkoden kan ikke merkes når den <avvik>
      Gitt at regelverkssamlingen "UHG 2027" har mangelkoden "VIT", som <avvik>
      Når opptaksforvalteren ved HK-dir merker mangelkoden "VIT" for generell studiekompetanse som fullføres i vår
      Så avvises endringen

      Eksempler:
        | avvik                            |
        | er i kategorien "Spesielle krav" |
        | ikke stopper for opptak          |

  # ── 2. Registrering ──────────────────────────────────────────

  Regel: Kategorien til mangelkoden avgjør hva mangelen hindrer

    Scenario: Mangel på generelle krav hindrer kvalifisering til alle søknadsalternativene i saken
      Gitt at saken hos "Universitetet i Oslo" har søknadsalternativene "Informatikk, UiO" og "Historie, UiO"
      Og at saken har en mangel i kategorien "Generelle krav"
      Når saksbehandleren ved Universitetet i Oslo vurderer kvalifiseringen
      Så kan ikke saksbehandleren sette søkeren som kvalifisert til noen av søknadsalternativene i saken

    Scenario: Mangel på spesielle krav hindrer kvalifisering bare til søknadsalternativene med kompetanseregelverket
      Gitt at saken hos "Universitetet i Oslo" har følgende søknadsalternativer
        | søknadsalternativ | kompetanseregelverk      |
        | Informatikk, UiO  | Regelverk A, Regelverk B |
        | Historie, UiO     | Regelverk A              |
      Og at saken har en mangel i kategorien "Spesielle krav" på kompetanseregelverket "Regelverk B"
      Når saksbehandleren ved Universitetet i Oslo vurderer kvalifiseringen
      Så kan ikke saksbehandleren sette søkeren som kvalifisert til "Informatikk, UiO"
      Men saksbehandleren kan sette søkeren som kvalifisert til "Historie, UiO"

    Scenariomal: Mangel på <kategori> hindrer ikke kvalifisering
      Gitt at saken hos "Universitetet i Oslo" har en mangel i kategorien "<kategori>"
      Og at saken ikke har mangler i kategoriene "Generelle krav" eller "Spesielle krav"
      Når saksbehandleren ved Universitetet i Oslo vurderer kvalifiseringen
      Så kan saksbehandleren sette søkeren som kvalifisert til søknadsalternativene i saken

      Eksempler:
        | kategori |
        | Poeng    |
        | Kvote    |

    @ref-OPT-BEH-BEH-025
    Scenario: Saken kan behandles ferdig selv om den har mangler
      Gitt at saken hos "Universitetet i Oslo" har mangelen "KAR"
      Når saksbehandleren ved Universitetet i Oslo har behandlet saken så langt dokumentasjonen rekker
      Så kan saksbehandleren sette saken til "Ferdig behandlet"

    @draft @openquestion
    Scenario: Mangel som sperrer opptak holder søkeren utenfor tilbudskjøringen
      # ÅPNE SPØRSMÅL:
      # - Hva gjør «Stopper for opptak»? Søkere med mangler er med i tilbudskjøringen, med
      #   status «ikke kvalifisert» (review i PR #700), og koden leser ikke `sperrer_opptak` i
      #   plasstildelingen eller tilbudskjøringen (verify 2026-10-08).
      Gitt at saken hos "Universitetet i Oslo" har en mangel med en mangelkode som sperrer opptak
      Når tilbudskjøringen kjøres
      Så deltar ikke søkeren i tilbudskjøringen

  Regel: Saksbehandlende organisasjon registrerer mangler i saken sin

    Scenario: Registrere mangel på spesielle krav
      Når saksbehandleren ved Universitetet i Oslo registrerer en mangel i saken med følgende opplysninger
        | felt                | verdi                                                      |
        | Mangelkode          | KAR                                                        |
        | Kompetanseregelverk | Regelverk B                                                |
        | Kommentar           | Du mangler karakter i R2. Dokumenter ett av kravene under. |
      Så har saken mangelen "KAR" på kompetanseregelverket "Regelverk B"

    Scenario: Saksbehandleren velger blant mangelkodene i regelverkssamlingen til opptaket
      Gitt at regelverkssamlingen "UHG 2027" har mangelkodene "KAR" og "STEMPEL"
      Og at en annen regelverkssamling har mangelkoden "ATT"
      Når saksbehandleren ved Universitetet i Oslo velger mangelkode for en mangel
      Så kan saksbehandleren velge "KAR" og "STEMPEL"
      Og saksbehandleren kan ikke velge "ATT"

    Scenario: Saksbehandleren velger blant kompetanseregelverkene til søknadsalternativene i saken
      Gitt at søknadsalternativene i saken hos "Universitetet i Oslo" har kompetanseregelverkene "Regelverk A" og "Regelverk B"
      Når saksbehandleren ved Universitetet i Oslo velger kompetanseregelverk for en mangel
      Så kan saksbehandleren velge "Regelverk A" og "Regelverk B"
      Og saksbehandleren kan ikke velge andre kompetanseregelverk

    Scenario: Registrere mangel på kvote
      Når saksbehandleren ved Universitetet i Oslo registrerer mangelen "BOS" i kategorien "Kvote" på kvotespørsmålet "Bosted i Nord-Norge"
      Så har saken mangelen "BOS" på kvotespørsmålet "Bosted i Nord-Norge"

    Scenario: Saksbehandleren velger blant kvotespørsmålene til søknadsalternativene i saken
      Gitt at kvotene til søknadsalternativene i saken hos "Universitetet i Oslo" har kvotespørsmålene "Bosted i Nord-Norge" og "Samisk tilhørighet"
      Når saksbehandleren ved Universitetet i Oslo velger kvotespørsmål for en mangel
      Så kan saksbehandleren velge "Bosted i Nord-Norge" og "Samisk tilhørighet"
      Og saksbehandleren kan ikke velge andre kvotespørsmål

    Scenariomal: En mangel i kategorien <kategori> <kobling>
      Når saksbehandleren ved Universitetet i Oslo registrerer en mangel i kategorien "<kategori>"
      Så <kobling>

      Eksempler:
        | kategori       | kobling                                                               |
        | Generelle krav | kan ikke mangelen knyttes til et kompetanseregelverk eller kvotespørsmål |
        | Spesielle krav | knyttes mangelen til et kompetanseregelverk                           |
        | Poeng          | kan ikke mangelen knyttes til et kompetanseregelverk eller kvotespørsmål |
        | Kvote          | knyttes mangelen til et kvotespørsmål                                 |

    Scenario: Kommentaren til søkeren er valgfri
      Når saksbehandleren ved Universitetet i Oslo registrerer en mangel uten kommentar
      Så har saken mangelen

    Scenario: En sak kan ha flere mangler
      Gitt at saken hos "Universitetet i Oslo" har mangelen "KAR"
      Når saksbehandleren ved Universitetet i Oslo registrerer mangelen "STEMPEL"
      Så har saken manglene "KAR" og "STEMPEL"

    Scenariomal: Samme mangelkode i kategorien <kategori> kan <tillatt> registreres flere ganger i saken
      Gitt at saken hos "Universitetet i Oslo" har en mangel med mangelkoden "<kode>" i kategorien "<kategori>"
      Når saksbehandleren ved Universitetet i Oslo registrerer mangelkoden "<kode>" på nytt
      Så <resultat>

      Eksempler:
        | kategori       | kode    | tillatt | resultat                                                    |
        | Spesielle krav | KAR     | også    | har saken to mangler med "KAR" på ulike kompetanseregelverk |
        | Kvote          | BOS     | også    | har saken to mangler med "BOS" på ulike kvotespørsmål       |
        | Generelle krav | GSK     | ikke    | avvises mangelen                                            |
        | Poeng          | STEMPEL | ikke    | avvises mangelen                                            |

    Scenario: Slette mangel som er registrert ved en feil
      Gitt at saken hos "Universitetet i Oslo" har mangelen "KAR"
      Når saksbehandleren ved Universitetet i Oslo sletter mangelen "KAR"
      Så har ikke saken mangelen "KAR"

    Scenariomal: Saksloggen viser at saksbehandleren <hendelse>
      Når saksbehandleren ved Universitetet i Oslo <hendelse>
      Så viser saksloggen hendelsen, hvem som utførte den og når

      Eksempler:
        | hendelse              |
        | registrerer en mangel |
        | endrer en mangel      |
        | sjekker ut en mangel  |
        | sletter en mangel     |

  Regel: Saksbehandleren sjekker ut mangelen når søkeren har dokumentert på nytt

    Når saksbehandleren har vurdert ny dokumentasjon og mener at mangelen er løst, sjekker
    saksbehandleren ut mangelen. En mangel som er sjekket ut, står fortsatt i saken, så det
    går an å se hva som har manglet, men den hindrer ikke lenger noe og vises ikke for søkeren.

    Scenario: Saksbehandleren ser at søkeren har lastet opp ny dokumentasjon
      Gitt at saken hos "Universitetet i Oslo" har mangelen "KAR"
      Når søkeren laster opp dokumentasjon
      Så ser saksbehandleren ved Universitetet i Oslo at det er kommet ny dokumentasjon i saken
      Og mangelen "KAR" er ikke sjekket ut

    Scenario: Saksbehandleren sjekker ut mangelen
      Gitt at saken hos "Universitetet i Oslo" har mangelen "KAR"
      Når saksbehandleren ved Universitetet i Oslo sjekker ut mangelen "KAR"
      Så er mangelen "KAR" sjekket ut
      Og saken har fortsatt mangelen "KAR"

    Scenario: Mangel som er sjekket ut hindrer ikke kvalifisering
      Gitt at saken hos "Universitetet i Oslo" har mangelen "KAR" på kompetanseregelverket "Regelverk B"
      Og at mangelen "KAR" er sjekket ut
      Når saksbehandleren ved Universitetet i Oslo vurderer kvalifiseringen
      Så kan saksbehandleren sette søkeren som kvalifisert til søknadsalternativene med "Regelverk B"

    Scenario: Saksbehandleren ser om søkeren har lest mangelen
      Gitt at mangelen "KAR" er publisert
      Og at søkeren har åpnet mangelen "KAR" i Min kompetanse
      Når saksbehandleren ved Universitetet i Oslo åpner manglene i saken
      Så er mangelen "KAR" merket med at søkeren har lest den

  # ── 3. Publisering og melding ────────────────────────────────

  @ref-OPT-BEH-BEH-025
  Regel: Søkeren ser bare manglene som er publisert, og får melding om dem
    # Den automatiske behandlingen publiserer manglene når den setter saken til ferdig
    # behandlet. Det står i OPT-BEH-BEH-025.

    Scenario: Registrering av mangel publiserer ikke mangelen
      Når saksbehandleren ved Universitetet i Oslo registrerer mangelen "KAR"
      Så ser ikke søkeren mangelen "KAR" i Min kompetanse
      Og søkeren har ikke mottatt en melding om mangler

    Scenario: Saksbehandleren publiserer mangelen
      Gitt at saken hos "Universitetet i Oslo" har mangelen "KAR"
      Når saksbehandleren ved Universitetet i Oslo markerer mangelen "KAR" som klar til publisering
      Så ser søkeren mangelen "KAR" i Min kompetanse

    @draft @openquestion
    Scenario: Saksbehandleren publiserer manglene i saken
      # ÅPNE SPØRSMÅL:
      # - Publiseringen er endret etter raffineringen: saksbehandleren publiserer alle manglene i
      #   saken samlet, og søkeren får melding hver gang. Ikke gått gjennom med teamet.
      # - Når publiseringen av hele saken er validert, fjernes «Saksbehandleren publiserer
      #   mangelen» og «Søkeren får én melding om manglene som publiseres i saken» i samme endring.
      Gitt at saken hos "Universitetet i Oslo" har manglene "KAR" og "STEMPEL"
      Når saksbehandleren ved Universitetet i Oslo publiserer manglene i saken
      Så ser søkeren manglene "KAR" og "STEMPEL" i Min kompetanse
      Og søkeren mottar én melding om mangler

    @draft @openquestion
    Scenario: Søkeren får melding hver gang saksbehandleren publiserer manglene
      # ÅPNE SPØRSMÅL:
      # - Publiseringen er endret etter raffineringen: saksbehandleren publiserer alle manglene i
      #   saken samlet, og søkeren får melding hver gang. Ikke gått gjennom med teamet.
      Gitt at saksbehandleren ved Universitetet i Oslo har publisert mangelen "KAR"
      Og at saksbehandleren har registrert mangelen "STEMPEL"
      Når saksbehandleren publiserer manglene i saken
      Så mottar søkeren en ny melding om mangler

    @draft @openquestion
    Scenario: Saksbehandleren publiserer en sak som bare har automatiske mangler
      # ÅPNE SPØRSMÅL:
      # - Publiseringen er endret etter raffineringen: saksbehandleren publiserer alle manglene i
      #   saken samlet, og søkeren får melding hver gang. Ikke gått gjennom med teamet.
      # - Skal de automatiske mangeltekstene for kompetanseregelverk publiseres på samme måte som
      #   manglene saksbehandleren registrerer? Saksbehandleren velger da å publisere, og
      #   publiseringen gjelder begge deler. Det er allerede et krav om at begge deler må være
      #   publisert når saken settes til «Ferdig behandlet».
      #   Merk: de automatiske mangeltekstene for kompetanseregelverk blir alltid publisert når
      #   saken settes til «Ferdig behandlet» (se «Søkeren ser de automatiske mangeltekstene når
      #   saken er ferdig behandlet»).
      # Kode i dag: «Oppdater mangel i Min kompetanse» kan ikke brukes når saken bare har
      # automatiske mangler.
      Gitt at saken hos "Universitetet i Oslo" bare har den automatiske mangelteksten for "Matematikk R2"
      Når saksbehandleren ved Universitetet i Oslo publiserer manglene i saken
      Så ser søkeren den automatiske mangelteksten for "Matematikk R2" i Min kompetanse

    @draft @openquestion
    Scenariomal: Saksbehandleren ser at endringene ikke er publisert når <endring>
      # ÅPNE SPØRSMÅL:
      # - Må også en ny mangel, og en mangel som sjekkes ut, publiseres på nytt?
      Gitt at saksbehandleren ved Universitetet i Oslo har publisert mangelen "KAR" og den automatiske mangelteksten for "Matematikk R2"
      Når <endring>
      Så ser saksbehandleren at endringene i manglene ikke er publisert

      Eksempler:
        | endring                                                          |
        | saksbehandleren sletter mangelen "KAR"                           |
        | saksbehandleren lagrer en kommentar på mangelen "KAR"            |
        | saksbehandleren vurderer at "Matematikk R2" er oppfylt           |

    Scenario: Saksbehandleren blir advart om mangler som ikke er publisert
      Gitt at saken hos "Universitetet i Oslo" har mangelen "KNN" som ikke er publisert
      Når saksbehandleren ved Universitetet i Oslo setter saken til "Ferdig behandlet"
      Så ser saksbehandleren at søkeren ikke ser mangelen "KNN" i Min kompetanse

    @draft @openquestion
    Scenario: Publisere manglene når saken settes til ferdig behandlet
      # ÅPNE SPØRSMÅL:
      # - Publiseringen er endret etter raffineringen: saksbehandleren publiserer alle manglene i
      #   saken samlet, og søkeren får melding hver gang. Settes saken til «Ferdig behandlet»,
      #   publiseres manglene, med mindre saksbehandleren velger å la være. Ikke gått gjennom med teamet.
      Gitt at saksbehandleren ved Universitetet i Oslo er advart om at mangelen "KNN" ikke er publisert
      Når saksbehandleren velger å publisere manglene og sette saken til "Ferdig behandlet"
      Så er saken "Ferdig behandlet"
      Og søkeren ser mangelen "KNN" i Min kompetanse
      Og søkeren har mottatt en melding om mangler

    Scenario: Sette saken til ferdig behandlet uten å publisere manglene
      Gitt at saksbehandleren ved Universitetet i Oslo er advart om at mangelen "KNN" ikke er publisert
      Når saksbehandleren velger å sette saken til "Ferdig behandlet" uten å varsle søkeren
      Så er saken "Ferdig behandlet"
      Og søkeren ser ikke mangelen "KNN" i Min kompetanse
      Og søkeren har ikke mottatt en melding om mangler

    Scenario: Avbryte når saken har mangler som ikke er publisert
      Gitt at saksbehandleren ved Universitetet i Oslo er advart om at mangelen "KNN" ikke er publisert
      Når saksbehandleren avbryter
      Så er ikke saken satt til "Ferdig behandlet"

    Scenario: Søkeren får én melding om manglene som publiseres i saken
      Gitt at saken hos "Universitetet i Oslo" har manglene "KAR" og "STEMPEL"
      Når manglene "KAR" og "STEMPEL" publiseres
      Så mottar søkeren én melding om mangler

    Scenario: Søkeren får melding fra hver saksbehandlende organisasjon som publiserer mangler
      Gitt at saksbehandleren ved Universitetet i Oslo har publisert mangelen "KAR"
      Når saksbehandleren ved UiT Norges arktiske universitet publiserer mangelen "STEMPEL"
      Så mottar søkeren en ny melding om mangelen "STEMPEL"

    Scenario: Søkeren åpner meldingen om mangel
      Gitt at søkeren har mottatt en melding om mangler
      Når søkeren åpner meldingen
      Så ser søkeren at det er registrert mangler i søknaden
      Og søkeren ser fristen for å laste opp dokumentasjon
      Og søkeren kan gå til dokumentasjonssiden

  Regel: Fristen for en mangel er ettersendingsfristen, med mindre en tidligere dokumentasjonsfrist ikke har gått ut

    Scenariomal: Fristen for en mangel publisert <publisert> når <situasjon>
      Gitt at ettersendingsfristen i opptaket er "2027-07-01 23:59"
      Og at <situasjon>
      Og at saken har en mangel på kompetanseregelverket til "<søknadsalternativ>"
      Og at mangelen ble publisert <publisert>
      Når søkeren åpner meldingen om mangel
      Så er fristen for "<søknadsalternativ>" "<frist>"

      Eksempler:
        | situasjon                                                                                                                                                              | søknadsalternativ    | publisert  | frist            |
        | ingen tidligere dokumentasjonsfrist gjelder                                                                                                                            | Informatikk, UiO     | 2027-03-10 | 2027-07-01 23:59 |
        | "Politiutdanning, PHS" har tidlig dokumentasjonsfrist "2027-03-20 23:59"                                                                                               | Politiutdanning, PHS | 2027-03-10 | 2027-03-20 23:59 |
        | "Politiutdanning, PHS" har tidlig dokumentasjonsfrist "2027-03-20 23:59"                                                                                               | Politiutdanning, PHS | 2027-05-10 | 2027-07-01 23:59 |
        | søkeren har utdanningsbakgrunnen "Realkompetanse" med dokumentasjonsfrist "2027-03-20 23:59"                                                                           | Informatikk, UiO     | 2027-03-10 | 2027-03-20 23:59 |
        | søkeren har utdanningsbakgrunnen "Realkompetanse" med dokumentasjonsfrist "2027-03-20 23:59"                                                                           | Informatikk, UiO     | 2027-05-10 | 2027-07-01 23:59 |
        | "Informatikk, UiO" er i tidlig opptak med dokumentasjonsfrist "2027-03-20 23:59"                                                                                       | Informatikk, UiO     | 2027-03-10 | 2027-03-20 23:59 |
        | "Informatikk, UiO" er i tidlig opptak med dokumentasjonsfrist "2027-03-20 23:59"                                                                                       | Informatikk, UiO     | 2027-05-10 | 2027-07-01 23:59 |
        | søkeren har utdanningsbakgrunnen "Realkompetanse" med dokumentasjonsfrist "2027-03-20 23:59", og "Sykepleie, OsloMet" har tidlig dokumentasjonsfrist "2027-03-10 23:59" | Sykepleie, OsloMet   | 2027-03-05 | 2027-03-10 23:59 |

    Scenario: Meldingen viser fristen for hvert søknadsalternativ med mangler
      Gitt at ettersendingsfristen i opptaket er "2027-07-01 23:59"
      Og at "Lektorutdanning, UiO" har tidlig dokumentasjonsfrist "2027-03-20 23:59"
      Og at saken hos "Universitetet i Oslo" har søknadsalternativene "Lektorutdanning, UiO" og "Informatikk, UiO"
      Og at saken har en mangel i kategorien "Generelle krav" som ble publisert 2027-03-10
      Når søkeren åpner meldingen om mangel
      Så ser søkeren fristen "2027-03-20 23:59" for "Lektorutdanning, UiO"
      Og søkeren ser fristen "2027-07-01 23:59" for "Informatikk, UiO"

    Scenario: Mangel på spesielle krav gir frist bare for søknadsalternativene med kompetanseregelverket
      Gitt at "Informatikk, UiO" har kompetanseregelverket "Regelverk B"
      Og at "Lektorutdanning, UiO" ikke har kompetanseregelverket "Regelverk B"
      Og at saken har en mangel i kategorien "Spesielle krav" på kompetanseregelverket "Regelverk B"
      Når søkeren åpner meldingen om mangel
      Så ser søkeren fristen for "Informatikk, UiO"
      Men søkeren ser ikke en frist for "Lektorutdanning, UiO"

    Scenariomal: Mangel på <kategori> har ettersendingsfristen
      Gitt at ettersendingsfristen i opptaket er "2027-07-01 23:59"
      Og at saken har en mangel i kategorien "<kategori>"
      Når søkeren åpner meldingen om mangel
      Så er fristen for mangelen "2027-07-01 23:59"

      Eksempler:
        | kategori |
        | Poeng    |
        | Kvote    |

  # ── 4. Søkerens visning ──────────────────────────────────────

  Regel: Søkeren ser manglene på dokumentasjonssiden

    Dokumentasjonssiden er siden i Min kompetanse der søkeren ser hvilken dokumentasjon som
    mangler for søknadsalternativene, og laster opp dokumentasjonen.

    Scenario: Mangel på spesielle krav vises under søknadsalternativene med kompetanseregelverket
      Gitt at "Informatikk, UiO" har kompetanseregelverket "Regelverk B"
      Og at "Historie, UiO" ikke har kompetanseregelverket "Regelverk B"
      Og at saken har den publiserte mangelen "KAR" på kompetanseregelverket "Regelverk B"
      Når søkeren åpner dokumentasjonssiden
      Så er "Informatikk, UiO" merket med at dokumentasjon mangler
      Og "Historie, UiO" er ikke merket med at dokumentasjon mangler

    Scenario: Søkeren ser kravene i kompetanseregelverket mangelen gjelder
      Gitt at saken har den publiserte mangelen "KAR" på kompetanseregelverket "Regelverk B"
      Når søkeren ser manglene for "Informatikk, UiO"
      Så ser søkeren informasjonen til søker for mangelkoden "KAR"
      Og søkeren ser kravelementene i "Regelverk B"

    Scenario: Søkeren ser kommentaren fra saksbehandleren
      Gitt at den publiserte mangelen "KAR" har en kommentar fra saksbehandleren
      Når søkeren ser manglene for "Informatikk, UiO"
      Så ser søkeren kommentaren fra saksbehandleren

    @draft @openquestion
    Scenariomal: Mangel på <kategori> gjelder ikke et bestemt søknadsalternativ
      # ÅPNE SPØRSMÅL:
      # - Gjelder mangler i kategoriene «Poeng» og «Kvote» søknaden som helhet, eller skal en
      #   kvotemangel gjelde søknadsalternativene med kvoten (forslag fra review i PR #700)?
      Gitt at saken har en publisert mangel i kategorien "<kategori>"
      Når søkeren åpner dokumentasjonssiden
      Så ser søkeren mangelen
      Men ingen av søknadsalternativene er merket med at dokumentasjon mangler

      Eksempler:
        | kategori |
        | Poeng    |
        | Kvote    |

    Scenario: Mangel som er sjekket ut vises ikke for søkeren
      Gitt at den publiserte mangelen "KAR" er sjekket ut
      Når søkeren åpner dokumentasjonssiden
      Så ser ikke søkeren mangelen "KAR"

  @draft @openquestion
  Regel: Søkeren laster opp dokumentasjon for manglene
    # ÅPNE SPØRSMÅL:
    # - Knyttes dokumentasjonen søkeren laster opp, til en bestemt mangel, slik at saksbehandleren
    #   ser hvilken mangel den er lastet opp for?
    # - Hva skjer når fristen for mangelen har gått ut? Kan søkeren fortsatt laste opp dokumentasjon?

    Scenario: Søkeren laster opp dokumentasjon for en mangel
      Gitt at saken har den publiserte mangelen "KAR" på kompetanseregelverket "Regelverk B"
      Når søkeren laster opp dokumentasjon på dokumentasjonssiden
      Så har søknaden dokumentasjonen søkeren lastet opp

    Scenario: Mangelen står til saksbehandleren har sjekket den ut
      Gitt at søkeren har lastet opp dokumentasjon for den publiserte mangelen "KAR"
      Og at saksbehandleren ikke har sjekket ut mangelen "KAR"
      Når søkeren åpner dokumentasjonssiden
      Så ser søkeren fortsatt mangelen "KAR"

  # ── 5. Innsyn ────────────────────────────────────────────────

  Regel: Organisasjonene som behandler søknaden ser manglene i alle sakene, men endrer bare manglene i saken sin

    Scenario: Saksbehandlende organisasjon ser manglene i saken hos en annen organisasjon
      Gitt at søknaden har saker hos "Universitetet i Oslo" og "UiT Norges arktiske universitet"
      Og at saken hos "UiT Norges arktiske universitet" har mangelen "KAR"
      Når saksbehandleren ved Universitetet i Oslo åpner søknaden
      Så ser saksbehandleren mangelen "KAR" i saken hos "UiT Norges arktiske universitet"

    Scenario: Saksbehandlende organisasjon kan ikke endre manglene i saken hos en annen organisasjon
      Gitt at saken hos "UiT Norges arktiske universitet" har mangelen "KAR"
      Når saksbehandleren ved Universitetet i Oslo ser mangelen "KAR"
      Så ser ikke saksbehandleren muligheten til å endre, sjekke ut eller slette mangelen "KAR"

    Scenario: Opptaksforvalteren ved forvaltende organisasjon ser manglene i alle sakene
      Gitt at sakene hos "Universitetet i Oslo" og "UiT Norges arktiske universitet" har mangler
      Når opptaksforvalteren ved HK-dir åpner søknaden
      Så ser opptaksforvalteren manglene i sakene hos "Universitetet i Oslo" og "UiT Norges arktiske universitet"

    Scenario: Tilbyderen ser manglene når en annen organisasjon saksbehandler utdanningstilbudet
      Gitt at "Historie, UiT" er fordelt til "Universitetet i Oslo"
      Og at saken hos "Universitetet i Oslo" har mangelen "KAR"
      Når saksbehandleren ved UiT Norges arktiske universitet ser "Historie, UiT"
      Så ser saksbehandleren mangelen "KAR"
      Men saksbehandleren ser ikke muligheten til å endre mangelen "KAR"

  @draft @openquestion
  Regel: Saksbehandleren finner sakene med en bestemt mangelkode

    Saksbehandleren må kunne finne sakene som har en bestemt mangel, for eksempel alle sakene
    der vitnemålet kommer senere, for å følge dem opp.

    # ÅPNE SPØRSMÅL:
    # - Det finnes ikke noe krav for listen over saker ennå. Filteret står her til det kravet er skrevet.
    # - Skal filteret ta med saker der mangelen er sjekket ut, eller bare saker der mangelen gjelder?
    # - Kan saksbehandleren velge flere mangelkoder samtidig?

    Scenario: Tilgjengelige mangelkoder i filter
      Gitt at regelverkssamlingen "UHG 2027" har mangelkodene "STEMPEL", "DUA" og "KAR"
      Og at mangelkoden "KAR" ikke er aktiv
      Når saksbehandleren ved Universitetet i Oslo åpner mangelkodefilteret i listen over saker i "Samordna opptak 2027"
      Så inneholder filteret mangelkodene i regelverkssamlingen "UHG 2027"
      Og filteret inneholder også mangelkoden "KAR", som ikke er aktiv
      Og mangelkodene er sortert alfabetisk
      Og "Alle mangelkoder" er valgt som standard

    Scenario: Filtrere på mangelkode
      Gitt at saken til søkeren "Kari Nordmann" hos "Universitetet i Oslo" har mangelen "DUA"
      Og at saken til søkeren "Ola Nordmann" hos "Universitetet i Oslo" ikke har mangelen "DUA"
      Når saksbehandleren ved Universitetet i Oslo velger "DUA" som filter i listen over saker
      Så vises saken til "Kari Nordmann"
      Men saken til "Ola Nordmann" vises ikke

  # ── 6. Automatikk ────────────────────────────────────────────

  @depends-on-OPT-BEH-BEH-020 @ref-FLY-OPT-AUT-001 @ref-OPT-BEH-BEH-025
  Regel: Saken får automatiske mangeltekster når søkeren ikke er kvalifisert

    De automatiske mangeltekstene følger kvalifiseringen. Er søkeren ikke kvalifisert på
    kompetanseregelverket, har saken én automatisk mangeltekst for hvert kravelement som ikke er
    oppfylt. Blir søkeren kvalifisert, slettes tekstene automatisk. Det gjelder uansett om
    kravelementene er vurdert av den automatiske behandlingen eller av saksbehandleren i steget
    «Spesielle opptakskrav». En automatisk mangeltekst har ingen mangelkode, og saksbehandleren
    kan ikke gjøre noe med den. Mener saksbehandleren at søkeren oppfyller kravet, vurderer
    saksbehandleren kravelementet som oppfylt.

    # Avklart 30.10.2026: den automatiske behandlingen lager ikke mangler med mangelkode, bare
    # automatiske mangeltekster. Teksten lages av navnet på kravelementet, etter et fast mønster
    # som står i implementasjonsdetaljene. Kravelementene får ingen egen tekst til søkeren. Det
    # avviker fra raffineringen, som sa at tekstene skulle hentes fra opptakskravene.
    # Avklart 30.10.2026: er søkeren ikke kvalifisert på noen kravliste, får alle kravelementene
    # som ikke er oppfylt, en mangeltekst, i alle kravlistene. Søkeren må kunne se at
    # kravlistene er alternativer. Hvordan, avgjøres i designet.
    # Avklart 30.10.2026: saksbehandleren kan ikke kommentere, sjekke ut eller slette en
    # automatisk mangeltekst.

    Scenariomal: Saken får en automatisk mangeltekst når <vurdert av> vurderer at et kravelement ikke er oppfylt
      Gitt at søknadsalternativene i saken hos "Universitetet i Oslo" har kravelementet "Matematikk R2"
      Når <vurdert av> vurderer at "Matematikk R2" ikke er oppfylt
      Så er søkeren ikke kvalifisert
      Og har saken en automatisk mangeltekst som viser at "Matematikk R2" ikke er oppfylt

      Eksempler:
        | vurdert av                               |
        | den automatiske behandlingen             |
        | saksbehandleren ved Universitetet i Oslo |

    Scenario: Saken får ikke mangeltekst når søkeren er kvalifisert på en annen kravliste
      Gitt at "Informatikk, UiO" har kravlisten "Matematikk R2" og kravlisten "Matematikk R1 og Fysikk 2"
      Og at vitnemålet har "Matematikk R1" og "Fysikk 2", men ikke "Matematikk R2"
      Når den automatiske behandlingen vurderer kravelementene
      Så er søkeren kvalifisert for "Informatikk, UiO"
      Og saken har ikke en automatisk mangeltekst for "Matematikk R2"

    Scenario: Saken får mangeltekster i alle kravlistene når søkeren ikke er kvalifisert på noen
      Gitt at "Informatikk, UiO" har kravlisten "Matematikk R2" og kravlisten "Matematikk R1 og Fysikk 2"
      Og at vitnemålet har "Matematikk R1", men ikke "Matematikk R2" og ikke "Fysikk 2"
      Når den automatiske behandlingen vurderer kravelementene
      Så har saken en automatisk mangeltekst for "Matematikk R2"
      Og saken har en automatisk mangeltekst for "Fysikk 2"

    Scenariomal: De automatiske mangeltekstene slettes når <vurdert av> vurderer at søkeren er kvalifisert
      Gitt at saken hos "Universitetet i Oslo" har en automatisk mangeltekst som viser at "Matematikk R2" ikke er oppfylt
      Når <vurdert av> vurderer at "Matematikk R2" er oppfylt
      Så er søkeren kvalifisert
      Og saken har ikke en automatisk mangeltekst for "Matematikk R2"

      Eksempler:
        | vurdert av                               |
        | den automatiske behandlingen             |
        | saksbehandleren ved Universitetet i Oslo |

    Scenario: Saksbehandleren ser de automatiske mangeltekstene sammen med de registrerte manglene
      Gitt at saken hos "Universitetet i Oslo" har en automatisk mangeltekst for "Matematikk R2"
      Og at saksbehandleren ved Universitetet i Oslo har registrert mangelen "STEMPEL"
      Når saksbehandleren åpner manglene i saken
      Så ser saksbehandleren den automatiske mangelteksten for "Matematikk R2" og mangelen "STEMPEL"

    Scenario: Søkeren ser de automatiske mangeltekstene når saken er ferdig behandlet
      # Avklart 30.10.2026. Ingen publiserer tekstene.
      Gitt at saken hos "Universitetet i Oslo" har en automatisk mangeltekst for "Matematikk R2"
      Når saken hos "Universitetet i Oslo" blir ferdig behandlet
      Så ser søkeren den automatiske mangelteksten for "Matematikk R2" i Min kompetanse

    Scenario: Søkeren ser ikke de automatiske mangeltekstene mens saken er under behandling
      Gitt at saken hos "Universitetet i Oslo" er under behandling
      Og at saken har en automatisk mangeltekst for "Matematikk R2"
      Når søkeren åpner dokumentasjonssiden i Min kompetanse
      Så ser ikke søkeren den automatiske mangelteksten for "Matematikk R2"

    Scenario: Søkeren ser mangeltekstene per søknadsalternativ
      Gitt at saken hos "Universitetet i Oslo" er ferdig behandlet
      Og at saken har en automatisk mangeltekst for "Matematikk R2" for "Informatikk, UiO"
      Når søkeren åpner dokumentasjonssiden i Min kompetanse
      Så ser søkeren mangelteksten for "Matematikk R2" under "Informatikk, UiO"

    Scenario: Søkeren ser ikke mangelteksten når søknadsalternativet er fjernet
      # Avklart 30.10.2026: mangelteksten slettes ikke, men vises ikke lenger.
      Gitt at saken hos "Universitetet i Oslo" har en automatisk mangeltekst for "Matematikk R2" for "Informatikk, UiO"
      Og at ingen andre søknadsalternativer i saken har kravelementet "Matematikk R2"
      Når søkeren fjerner "Informatikk, UiO" fra søknaden
      Så ser ikke søkeren mangelteksten for "Matematikk R2" i Min kompetanse
      Og saken har fortsatt den automatiske mangelteksten for "Matematikk R2"

    Scenario: Saksbehandleren kan ikke endre en automatisk mangeltekst
      Gitt at saken hos "Universitetet i Oslo" har en automatisk mangeltekst for "Matematikk R2"
      Når saksbehandleren ved Universitetet i Oslo åpner manglene i saken
      Så ser ikke saksbehandleren muligheten til å kommentere, sjekke ut eller slette den automatiske mangelteksten

  @ref-FLY-OPT-AUT-001 @depends-on-OPT-SØK-SØK-018 @ref-OPT-OVO-GRU-001
  Regel: Mangelen for generell studiekompetanse som fullføres i vår settes og sjekkes ut automatisk

    Søkere som fullfører videregående opplæring i vår, oppgir i søknaden at generell
    studiekompetanse fullføres i vår, det vil si at vitnemålet kommer senere. Alle sakene i
    søknaden får da automatisk en mangel med mangelkoden opptaksforvalteren har merket i
    regelverkssamlingen (se «1. Mangelkoder»). Mangelkoden er i kategorien «Generelle krav» og
    stopper for opptak. «Stopper for opptak» virker som for andre mangelkoder, og er ikke avklart
    ennå (se «Mangel som sperrer opptak holder søkeren utenfor tilbudskjøringen»).

    Mangelen er klar til publisering når den settes, så søkeren ser den i Min kompetanse, men
    søkeren får ikke egen melding om den. Endrer søkeren søknaden til at generell
    studiekompetanse ikke fullføres i vår, slettes mangelen hvis den ikke er sjekket ut.

    Når saken er behandlet helautomatisk, sjekker den automatiske behandlingen ut mangelen som et
    av de siste stegene før saken er ferdig behandlet. Saksbehandleren kan også sjekke
    ut mangelen, for eksempel når søkeren har dokumentert vitnemålet på annen måte.
    # I det gamle systemet het mangelkoden DUA. Eksemplene bruker den koden.

    # Avklart 30.10.2026: er ingen mangelkode merket, får opptaksforvalteren et varsel første
    # gang en søknad ikke får mangelen, og en advarsel allerede når opptaket opprettes
    # (OPT-OVO-GRU-001).
    # Avklart 30.10.2026: saksbehandleren kan sjekke ut mangelen, men ikke slette den. Bare
    # automatikken sletter den, når søkeren endrer søknaden.
    # Avklart 30.10.2026: en mangel som er sjekket ut, blir stående når søkeren endrer søknaden.

    Scenario: Alle sakene i søknaden får mangel når søkeren oppgir at generell studiekompetanse fullføres i vår
      Gitt at mangelkoden "DUA" i regelverkssamlingen "UHG 2027" er merket for generell studiekompetanse som fullføres i vår
      Og at søknaden har saker hos "Universitetet i Oslo" og "UiT Norges arktiske universitet"
      Når søkeren oppgir i søknaden at generell studiekompetanse fullføres i vår
      Så har sakene hos "Universitetet i Oslo" og "UiT Norges arktiske universitet" den automatiske mangelen "DUA"
      Og saksloggen viser at mangelen ble registrert fordi søkeren oppga at generell studiekompetanse fullføres i vår

    Scenario: Saken får ikke mangel når ingen mangelkode er merket
      Gitt at ingen mangelkode i regelverkssamlingen "UHG 2027" er merket for generell studiekompetanse som fullføres i vår
      Når søkeren oppgir i søknaden at generell studiekompetanse fullføres i vår
      Så har ikke saken hos "Universitetet i Oslo" en automatisk mangel for generell studiekompetanse som fullføres i vår
      Og opptaksforvalteren ved HK-dir får varsel om at ingen mangelkode er merket

    Scenario: Opptaksforvalteren får varselet bare første gang
      Gitt at ingen mangelkode i regelverkssamlingen "UHG 2027" er merket for generell studiekompetanse som fullføres i vår
      Og at opptaksforvalteren ved HK-dir har fått varsel om at ingen mangelkode er merket
      Når en ny søker oppgir i søknaden at generell studiekompetanse fullføres i vår
      Så får ikke opptaksforvalteren ved HK-dir et nytt varsel

    Scenario: Den automatiske mangelen hindrer kvalifisering til søknadsalternativene i saken
      Gitt at saken hos "Universitetet i Oslo" har den automatiske mangelen "DUA"
      Når saksbehandleren ved Universitetet i Oslo vurderer kvalifiseringen
      Så kan ikke saksbehandleren sette søkeren som kvalifisert til noen av søknadsalternativene i saken

    Scenario: Søkeren ser den automatiske mangelen i Min kompetanse
      Gitt at mangelkoden "DUA" i regelverkssamlingen "UHG 2027" er merket for generell studiekompetanse som fullføres i vår
      Når søkeren oppgir i søknaden at generell studiekompetanse fullføres i vår
      Så ser søkeren mangelen "DUA" i Min kompetanse

    Scenario: Søkeren får ikke egen melding om den automatiske mangelen
      Gitt at mangelkoden "DUA" i regelverkssamlingen "UHG 2027" er merket for generell studiekompetanse som fullføres i vår
      Når søkeren oppgir i søknaden at generell studiekompetanse fullføres i vår
      Så har søkeren ikke mottatt en melding om mangler

    Scenario: Mangelen slettes når søkeren endrer søknaden
      Gitt at saken hos "Universitetet i Oslo" har den automatiske mangelen "DUA"
      Og at mangelen "DUA" ikke er sjekket ut
      Når søkeren endrer søknaden til at generell studiekompetanse ikke fullføres i vår
      Så har ikke saken mangelen "DUA"
      Og saksloggen viser at mangelen ble slettet fordi søkeren endret søknaden

    Scenario: Mangel som er sjekket ut slettes ikke når søkeren endrer søknaden
      Gitt at saken hos "Universitetet i Oslo" har den automatiske mangelen "DUA"
      Og at mangelen "DUA" er sjekket ut
      Når søkeren endrer søknaden til at generell studiekompetanse ikke fullføres i vår
      Så har saken fortsatt mangelen "DUA"

    Scenario: Saksbehandleren kan sjekke ut mangelen, men ikke slette den
      Gitt at saken hos "Universitetet i Oslo" har den automatiske mangelen "DUA"
      Når saksbehandleren ved Universitetet i Oslo åpner manglene i saken
      Så kan saksbehandleren sjekke ut mangelen "DUA"
      Men saksbehandleren ser ikke muligheten til å slette mangelen "DUA"

    Scenario: Mangelen sjekkes ut når saken er behandlet helautomatisk
      Gitt at saken hos "Universitetet i Oslo" har den automatiske mangelen "DUA"
      Når den automatiske behandlingen har behandlet saken helautomatisk
      Så er mangelen "DUA" sjekket ut før saken er ferdig behandlet
      Og saksloggen viser at den automatiske behandlingen sjekket ut mangelen

    Scenario: Mangelen sjekkes ikke ut når saken ikke er behandlet helautomatisk
      Gitt at saken hos "Universitetet i Oslo" har den automatiske mangelen "DUA"
      Når den automatiske behandlingen sender saken til saksbehandleren
      Så er ikke mangelen "DUA" sjekket ut

    Scenario: Saksbehandleren sjekker ut mangelen når søkeren har dokumentert vitnemålet
      Gitt at saken hos "Universitetet i Oslo" har den automatiske mangelen "DUA"
      Og at søkeren har lastet opp vitnemålet
      Når saksbehandleren ved Universitetet i Oslo sjekker ut mangelen "DUA"
      Så er mangelen "DUA" sjekket ut
      Og saken har fortsatt mangelen "DUA"
