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

  Mangler lages også automatisk. Når kravelementene i saken vurderes, av den automatiske
  behandlingen eller av saksbehandleren, får saken mangler for kravelementene søkeren ikke
  oppfyller. En automatisk mangel sjekkes ut når kravelementet er oppfylt.

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
  1. Mangelkoder – opptaksforvalteren forvalter mangelkodene og tekstene.
  2. Registrering – saksbehandleren registrerer, sjekker ut og sletter mangler i saken.
  3. Publisering og melding – søkeren får se manglene og får melding om dem, med frist.
  4. Søkerens visning – søkeren ser manglene og laster opp dokumentasjon på dokumentasjonssiden.
  5. Innsyn – hvem som ser manglene i sakene.
  6. Automatikk – mangler som settes og sjekkes ut automatisk.

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" forvaltes av HK-dir
    Og at opptaket bruker regelverkssamlingen "UHG 2027"
    Og at "Universitetet i Oslo" og "UiT Norges arktiske universitet" deltar i opptaket

  # ── 1. Mangelkoder ───────────────────────────────────────────

  Regel: Opptaksforvalteren forvalter mangelkodene i regelverkssamlingen

    Scenario: Opprette mangelkode
      Når opptaksforvalteren ved HK-dir oppretter en mangelkode i regelverkssamlingen "UHG 2027" med følgende opplysninger
        | felt                                     | verdi                                    |
        | Kode                                     | KAR                                      |
        | Kategori                                 | Spesielle krav                           |
        | Kort beskrivelse                         | Mangler karakter                         |
        | Informasjon til søker i Min kompetanse   | Du mangler karakter i et fag som kreves. |
        | Stopper for opptak                       | Nei                                      |
        | Kan overskrives av automatisk behandling | Nei                                      |
        | Aktiv                                    | Ja                                       |
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
  Regel: Søkeren ser bare manglene saksbehandleren har publisert, og får melding om dem

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
      # Kode i dag: «Oppdater mangel i Min kompetanse» kan ikke brukes når saken bare har
      # automatiske mangler.
      Gitt at saken hos "Universitetet i Oslo" bare har den automatiske mangelen for "Matematikk R2"
      Når saksbehandleren ved Universitetet i Oslo publiserer manglene i saken
      Så ser søkeren den automatiske mangelen for "Matematikk R2" i Min kompetanse

    @draft @openquestion
    Scenario: Den automatiske behandlingen publiserer manglene når saken blir ferdig behandlet
      # ÅPNE SPØRSMÅL:
      # - Tittelen på regelen sier at saksbehandleren publiserer. Skal den si «manglene som er
      #   publisert», nå som den automatiske behandlingen også publiserer (OPT-BEH-BEH-025)?
      Gitt at saken hos "Universitetet i Oslo" har den automatiske mangelen for "Matematikk R2"
      Når den automatiske behandlingen setter saken til ferdig behandlet
      Så ser søkeren den automatiske mangelen for "Matematikk R2" i Min kompetanse
      Og søkeren mottar én melding om mangler

    @draft @openquestion
    Scenariomal: Saksbehandleren ser at endringene ikke er publisert når <endring>
      # ÅPNE SPØRSMÅL:
      # - Må også en ny mangel, og en mangel som sjekkes ut, publiseres på nytt?
      Gitt at saksbehandleren ved Universitetet i Oslo har publisert mangelen "KAR" og den automatiske mangelen for "Matematikk R2"
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

  # ── 6. Automatikk ────────────────────────────────────────────

  @draft @openquestion @depends-on-OPT-BEH-BEH-020 @ref-FLY-OPT-AUT-001 @ref-OPT-BEH-BEH-025
  Regel: Saken får mangler for kravelementene søkeren ikke oppfyller

    Manglene lages når kravelementene i saken vurderes, av den automatiske behandlingen eller av
    saksbehandleren i steget «Spesielle opptakskrav». Saksbehandleren kan gjøre det samme med en
    automatisk mangel som med en mangel saksbehandleren har registrert.

    # ÅPNE SPØRSMÅL:
    # - Hva er én automatisk mangel: én per kravelement som ikke er oppfylt, én per
    #   kompetanseregelverk søkeren ikke er kvalifisert til, eller én per kravliste?
    # - Hvor kommer teksten til søkeren fra? Raffineringen sier at tekstene hentes fra
    #   opptakskravene og forvaltes der. I dag står teksten på mangelkoden («Informasjon til søker
    #   i Min kompetanse»), og kravelementene har ingen tekst til søkeren (@OPT-REG-KRA-002).

    Scenariomal: Saken får mangel når <vurdert av> vurderer at et kravelement ikke er oppfylt
      Gitt at søknadsalternativene i saken hos "Universitetet i Oslo" har kravelementet "Matematikk R2"
      Når <vurdert av> vurderer at "Matematikk R2" ikke er oppfylt
      Så har saken en automatisk mangel som viser at "Matematikk R2" ikke er oppfylt

      Eksempler:
        | vurdert av                               |
        | den automatiske behandlingen             |
        | saksbehandleren ved Universitetet i Oslo |

    Scenariomal: Den automatiske mangelen sjekkes ut når <vurdert av> vurderer at kravelementet er oppfylt
      Gitt at saken hos "Universitetet i Oslo" har en automatisk mangel som viser at "Matematikk R2" ikke er oppfylt
      Når <vurdert av> vurderer at "Matematikk R2" er oppfylt
      Så er den automatiske mangelen for "Matematikk R2" sjekket ut
      Og saken har fortsatt den automatiske mangelen for "Matematikk R2"

      Eksempler:
        | vurdert av                               |
        | den automatiske behandlingen             |
        | saksbehandleren ved Universitetet i Oslo |

    Scenariomal: Saksbehandleren ser <mangel> sammen med de registrerte manglene
      Gitt at saken hos "Universitetet i Oslo" har <mangel>
      Og at saksbehandleren ved Universitetet i Oslo har registrert mangelen "STEMPEL"
      Når saksbehandleren åpner manglene i saken
      Så ser saksbehandleren <mangel> og mangelen "STEMPEL"
      Og saksbehandleren ser teksten søkeren får for <mangel>

      Eksempler:
        | mangel                                                                     |
        | den automatiske mangelen for "Matematikk R2"                               |
        | den automatiske mangelen for generell studiekompetanse som fullføres i vår |

    Scenariomal: Saksbehandleren kan <handling> en automatisk mangel
      Gitt at saken hos "Universitetet i Oslo" har den automatiske mangelen for "Matematikk R2"
      Når saksbehandleren ved Universitetet i Oslo åpner manglene i saken
      Så kan saksbehandleren <handling> den automatiske mangelen for "Matematikk R2"

      Eksempler:
        | handling   |
        | kommentere |
        | sjekke ut  |
        | slette     |

    Scenariomal: Automatisk mangel som er <handling>, <utfall> når mangelkoden <overskrivbar>
      Gitt at saksbehandleren ved Universitetet i Oslo har <handling> den automatiske mangelen for "Matematikk R2"
      Og at mangelkoden til mangelen <overskrivbar>
      Og at "Matematikk R2" fortsatt ikke er oppfylt
      Når kravelementene i saken vurderes på nytt
      Så <resultat>

      Eksempler:
        | handling   | overskrivbar                                  | utfall              | resultat                                                                          |
        | slettet    | kan overskrives av automatisk behandling      | kommer tilbake      | har saken igjen en automatisk mangel som viser at "Matematikk R2" ikke er oppfylt |
        | slettet    | ikke kan overskrives av automatisk behandling | kommer ikke tilbake | har saken ikke en automatisk mangel for "Matematikk R2"                           |
        | sjekket ut | kan overskrives av automatisk behandling      | kommer tilbake      | har saken igjen en automatisk mangel som viser at "Matematikk R2" ikke er oppfylt |
        | sjekket ut | ikke kan overskrives av automatisk behandling | kommer ikke tilbake | er den automatiske mangelen for "Matematikk R2" fortsatt sjekket ut               |

  @draft @openquestion
  Regel: Mangelen for generell studiekompetanse som fullføres i vår settes og sjekkes ut automatisk

    Den automatiske mangelen gjelder bare søkere som oppgir at generell studiekompetanse fullføres
    i vår. Den sjekkes ut når vitnemålet behandles automatisk, eller av saksbehandleren når søkeren
    har dokumentert vitnemålet på annen måte, for eksempel ved å laste det opp. Oppgir ikke søkeren
    at generell studiekompetanse fullføres i vår, kontrollerer saksbehandleren vitnemålet i
    søknaden og registrerer en mangel hvis det mangler, som for de andre opptakskravene.

    # ÅPNE SPØRSMÅL:
    # - Hvilken mangelkode og hvilket kompetanseregelverk får den automatiske mangelen, og gjelder
    #   den alle sakene i søknaden? Trolig begge deler: en mangel i kategorien «Generelle krav» i alle
    #   sakene (uten kompetanseregelverk), og en mangel i kategorien «Spesielle krav» på
    #   kompetanseregelverket for generell studiekompetanse i sakene som har det. Ikke bekreftet.
    #   Koden har ikke den automatiske mangelen (sjekket 2026-10-09).
    # - Hvordan vet løsningen hvilken mangelkode som settes automatisk? Forslag etter raffineringen:
    #   et kryss eller et felt som kobler mangelkoden til søkerspørsmålet under «Utdanningsbakgrunn»,
    #   så mangelkoden DUA ikke må hardkodes.
    # - Er «vitnemålet kommer senere», som søkeren svarer på, det samme som at generell
    #   studiekompetanse fullføres i vår, eller noe bredere? Gjelder også @OPT-SØK-SØK-013.
    # - Regelen bygger på at søkeren kan oppgi at generell studiekompetanse fullføres i vår (@OPT-SØK-SØK-013),
    #   og det kravet er ikke avklart.
    # - Skal søkeren få melding når den automatiske mangelen er publisert, og slettes fordi søkeren
    #   endrer søknaden?

    Scenario: Saken får mangel når søkeren oppgir at generell studiekompetanse fullføres i vår
      Når søkeren oppgir i søknaden at generell studiekompetanse fullføres i vår
      Så får saken automatisk mangelen for generell studiekompetanse som fullføres i vår

    Scenario: Mangelen slettes når søkeren endrer søknaden før søknadsfristen
      Gitt at saken har den automatiske mangelen for generell studiekompetanse som fullføres i vår
      Og at søknadsfristen i "Samordna opptak 2027" ikke har gått ut
      Når søkeren endrer søknaden til at generell studiekompetanse ikke fullføres i vår
      Så har saken ikke lenger mangelen for generell studiekompetanse som fullføres i vår
      Og saksloggen viser at mangelen ble slettet fordi søkeren endret søknaden

    Scenario: Mangelen sjekkes ut når vitnemålet behandles automatisk
      Gitt at saken har den automatiske mangelen for generell studiekompetanse som fullføres i vår
      Når vitnemålet behandles automatisk
      Så er mangelen sjekket ut
      Og saksloggen viser at mangelen ble sjekket ut av automatisk behandling

    Scenariomal: Automatisk behandling overskriver manuelt satt mangel når mangelkoden <overskrivbar>
      Gitt at saksbehandleren har registrert en mangel med en mangelkode som <overskrivbar>
      Når automatisk behandling setter en mangel i saken
      Så <resultat>

      Eksempler:
        | overskrivbar         | resultat                          |
        | kan overskrives      | overskrives mangelen              |
        | ikke kan overskrives | står mangelen fra saksbehandleren |
