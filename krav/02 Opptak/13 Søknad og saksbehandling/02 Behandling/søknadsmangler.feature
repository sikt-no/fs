# language: no
# GitHub: #413
@OPT-BEH-BEH-008 @must @in-progress
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

  Mangler lages også automatisk: de automatiske mangeltekstene og mangelen for generell
  studiekompetanse som fullføres i vår. De står i automatiske mangler (se @OPT-BEH-BEH-036).

  Mangler hører til saken, det vil si søknadsalternativene én saksbehandlende organisasjon har
  (se @OPT-BEH-BEH-011). Hver mangelkode hører til en kategori:
  - Generelle krav: mangelen gjelder alle søknadsalternativene i saken.
  - Spesielle krav: mangelen knyttes til et kompetanseregelverk, og gjelder søknadsalternativene
    med kompetanseregelverket.
  - Poeng: mangelen gjelder grunnlag for poeng, og gjelder alle søknadsalternativene i saken.
  - Kvote: mangelen knyttes til et kvotespørsmål, og gjelder søknadsalternativene med kvoten.

  En mangel hindrer ikke at søkeren blir kvalifisert. Kvalifiseringen beregnes fra
  kravelementene. En mangelkode kan stoppe for opptak, og da får ikke søkeren tilbud om
  studieplass. Det står i OPT-PLA-TIL-001.

  Kravet har fem deler:
  1. Mangelkoder – opptaksforvalteren forvalter mangelkodene og tekstene.
  2. Registrering – saksbehandleren registrerer, sjekker ut og sletter mangler i saken.
  3. Publisering og melding – søkeren får se manglene og får melding om dem, med frist.
  4. Søkerens visning – søkeren ser manglene og laster opp dokumentasjon på dokumentasjonssiden.
  5. Innsyn – hvem som ser manglene i sakene, og hvordan saksbehandleren finner sakene med en
     bestemt mangelkode.

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" forvaltes av HK-dir
    Og at opptaket bruker regelverkssamlingen "UHG 2027"
    Og at "Universitetet i Oslo" og "UiT Norges arktiske universitet" deltar i opptaket

  # ── 1. Mangelkoder ───────────────────────────────────────────

  @implemented
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

  # ── 2. Registrering ──────────────────────────────────────────

  @implemented
  Regel: Mangler hindrer ikke kvalifiseringen eller at saken blir ferdig behandlet
    # Avklart 2026-11-02 i gjennomgangen av flyten automatisk saksbehandling: kvalifiseringen
    # beregnes fra kravelementene, og leser ikke manglene. At en mangelkode som stopper for
    # opptak hindrer tilbud om studieplass, står i OPT-PLA-TIL-001.

    Scenariomal: Søkeren er kvalifisert selv om saken har en mangel i kategorien <kategori>
      Gitt at søkeren oppfyller kravelementene til "Informatikk, UiO"
      Og at saken hos "Universitetet i Oslo" har en mangel i kategorien "<kategori>"
      Når kvalifiseringen beregnes
      Så er søkeren kvalifisert til "Informatikk, UiO"

      Eksempler:
        | kategori       |
        | Generelle krav |
        | Spesielle krav |
        | Poeng          |
        | Kvote          |

    @ref-OPT-BEH-BEH-025
    Scenario: Saken kan behandles ferdig selv om den har mangler
      Gitt at saken hos "Universitetet i Oslo" har mangelen "KAR"
      Når saksbehandleren ved Universitetet i Oslo har behandlet saken så langt dokumentasjonen rekker
      Så kan saksbehandleren sette saken til "Behandlet"

  Regel: Saksbehandlende organisasjon registrerer mangler i saken sin

    @implemented
    Scenario: Registrere mangel på spesielle krav
      Når saksbehandleren ved Universitetet i Oslo registrerer en mangel i saken med følgende opplysninger
        | felt                | verdi                                                      |
        | Mangelkode          | KAR                                                        |
        | Kompetanseregelverk | Regelverk B                                                |
        | Kommentar           | Du mangler karakter i R2. Dokumenter ett av kravene under. |
      Så har saken mangelen "KAR" på kompetanseregelverket "Regelverk B"

    @implemented
    Scenario: Saksbehandleren velger blant mangelkodene i regelverkssamlingen til opptaket
      Gitt at regelverkssamlingen "UHG 2027" har mangelkodene "KAR" og "STEMPEL"
      Og at en annen regelverkssamling har mangelkoden "ATT"
      Når saksbehandleren ved Universitetet i Oslo velger mangelkode for en mangel
      Så kan saksbehandleren velge "KAR" og "STEMPEL"
      Og saksbehandleren kan ikke velge "ATT"

    @implemented
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

    @implemented
    Scenario: Kommentaren til søkeren er valgfri
      Når saksbehandleren ved Universitetet i Oslo registrerer en mangel uten kommentar
      Så har saken mangelen

    @implemented
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

    @implemented
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

    @implemented
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
    # Avklart 2026-11-02:
    # - Manglene saksbehandleren registrerer, publiserer saksbehandleren når saksbehandleren
    #   vil. Saken kan ikke settes til «Behandlet» uten at manglene publiseres.
    # - De automatiske mangeltekstene fra kompetanseregelverket publiseres når saken settes til
    #   «Behandlet», eller når saksbehandleren publiserer manglene.
    # - Mangelen for generell studiekompetanse som fullføres i vår, publiseres alltid
    #   automatisk, uten egen melding (se «Mangelen for generell studiekompetanse som fullføres
    #   i vår settes og sjekkes ut automatisk»).

    @implemented
    Scenario: Registrering av mangel publiserer ikke mangelen
      Når saksbehandleren ved Universitetet i Oslo registrerer mangelen "KAR"
      Så ser ikke søkeren mangelen "KAR" i Min kompetanse
      Og søkeren har ikke mottatt en melding om mangler

    @implemented
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
      # Avklart 2026-11-02: de automatiske mangeltekstene publiseres når saksbehandleren
      # publiserer manglene, og ellers når saken settes til «Behandlet».
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
      Når saksbehandleren ved Universitetet i Oslo setter saken til "Behandlet"
      Så ser saksbehandleren at søkeren ikke ser mangelen "KNN" i Min kompetanse

    Scenario: Publisere manglene når saken settes til ferdig behandlet
      Gitt at saksbehandleren ved Universitetet i Oslo er advart om at mangelen "KNN" ikke er publisert
      Når saksbehandleren velger å publisere manglene og sette saken til "Behandlet"
      Så er saken "Behandlet"
      Og søkeren ser mangelen "KNN" i Min kompetanse
      Og søkeren har mottatt en melding om mangler

    Scenario: Avbryte når saken har mangler som ikke er publisert
      Gitt at saksbehandleren ved Universitetet i Oslo er advart om at mangelen "KNN" ikke er publisert
      Når saksbehandleren avbryter
      Så er ikke saken satt til "Behandlet"

    @implemented
    Scenario: Søkeren får én melding om manglene som publiseres i saken
      Gitt at saken hos "Universitetet i Oslo" har manglene "KAR" og "STEMPEL"
      Når manglene "KAR" og "STEMPEL" publiseres
      Så mottar søkeren én melding om mangler

    @implemented
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

    Scenario: Meldingen viser ettersendingsfristen og de tidligere fristene som gjelder manglene
      Gitt at ettersendingsfristen i opptaket er "2027-07-01 23:59"
      Og at "Lektorutdanning, UiO" har tidlig dokumentasjonsfrist "2027-03-20 23:59"
      Og at saken hos "Universitetet i Oslo" har søknadsalternativene "Lektorutdanning, UiO" og "Informatikk, UiO"
      Og at saken har en mangel i kategorien "Generelle krav" som ble publisert 2027-03-10
      Når søkeren åpner meldingen om mangel
      Så ser søkeren den tidlige dokumentasjonsfristen "2027-03-20 23:59" for "Lektorutdanning, UiO"
      Og søkeren ser ettersendingsfristen "2027-07-01 23:59" for "Informatikk, UiO"

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

    @implemented
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

    @implemented
    Scenario: Søkeren ser kommentaren fra saksbehandleren
      Gitt at den publiserte mangelen "KAR" har en kommentar fra saksbehandleren
      Når søkeren ser manglene for "Informatikk, UiO"
      Så ser søkeren kommentaren fra saksbehandleren

    Scenariomal: Mangel på <kategori> vises under alle søknadsalternativene i saken
      Gitt at saken hos "Universitetet i Oslo" har søknadsalternativene "Informatikk, UiO" og "Historie, UiO"
      Og at saken hos "UiT Norges arktiske universitet" har søknadsalternativet "Fiskeri, UiT"
      Og at saken hos "Universitetet i Oslo" har en publisert mangel i kategorien "<kategori>"
      Når søkeren åpner dokumentasjonssiden
      Så er "Informatikk, UiO" og "Historie, UiO" merket med at dokumentasjon mangler
      Og "Fiskeri, UiT" er ikke merket med at dokumentasjon mangler

      Eksempler:
        | kategori       |
        | Generelle krav |
        | Poeng          |

    Scenario: Mangel på kvote vises under søknadsalternativene med kvoten
      Gitt at kvotene til "Informatikk, UiO" har kvotespørsmålet "Bosted i Nord-Norge"
      Og at kvotene til "Historie, UiO" ikke har kvotespørsmålet "Bosted i Nord-Norge"
      Og at saken har den publiserte mangelen "BOS" på kvotespørsmålet "Bosted i Nord-Norge"
      Når søkeren åpner dokumentasjonssiden
      Så er "Informatikk, UiO" merket med at dokumentasjon mangler
      Og "Historie, UiO" er ikke merket med at dokumentasjon mangler

    @implemented
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

    @implemented
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
