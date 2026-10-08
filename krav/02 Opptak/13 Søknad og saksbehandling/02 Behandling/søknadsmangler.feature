# language: no
# GitHub: #413
@OPT-BEH-BEH-008 @must @draft
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

  Mangler hører til saken, det vil si søknadsalternativene én saksbehandlende organisasjon har
  (se @OPT-BEH-BEH-007). Hver mangelkode hører til en kategori, og kategorien avgjør hva
  mangelen hindrer:
  - Generelle krav: saksbehandleren kan ikke sette søkeren som kvalifisert til noen av
    søknadsalternativene i saken. En mangelkode i denne kategorien kan også sperre for opptak,
    slik at søkeren ikke deltar i tilbudskjøringen.
  - Spesielle krav: mangelen knyttes til et kompetanseregelverk, og saksbehandleren kan ikke
    sette søkeren som kvalifisert til søknadsalternativene med kompetanseregelverket.
  - Poeng: hindrer ikke kvalifisering.
  - Kvote: mangelen knyttes til et kvotespørsmål, og hindrer ikke kvalifisering.

  Kravet har seks deler:
  1. Mangelkoder – opptaksforvalteren forvalter mangelkodene og tekstene.
  2. Registrering – saksbehandleren registrerer, sjekker ut og sletter mangler i saken.
  3. Publisering og melding – søkeren får se manglene og får melding om dem, med frist.
  4. Søkerens visning – søkeren ser manglene på dokumentasjonssiden.
  5. Innsyn – hvem som ser manglene i sakene.
  6. Automatikk – mangler som settes og sjekkes ut automatisk.

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" forvaltes av HK-dir
    Og at opptaket bruker regelverkssamlingen "UHG 2027"
    Og at "Universitetet i Oslo" og "UiT Norges arktiske universitet" deltar i opptaket

  # ── 1. Mangelkoder ───────────────────────────────────────────

  @openquestion
  Regel: Opptaksforvalteren forvalter mangelkodene i regelverkssamlingen
    # ÅPNE SPØRSMÅL:
    # - Hvilke opplysninger har en mangelkode, og ligger mangelkodene i regelverkssamlingen?
    #   Forslaget i «Opprette mangelkode» er satt sammen av Figma (FS-Admin, regelverkssamlingen
    #   «UHG 2027», fanen Mangelkoder) og datamodellen i STEK-174 (Sperrer opptak, Aktiv).

    Scenario: Opprette mangelkode
      Når opptaksforvalteren ved HK-dir oppretter en mangelkode i regelverkssamlingen "UHG 2027" med følgende opplysninger
        | felt                                   | verdi                                       |
        | Kode                                   | KAR                                         |
        | Kategori                               | Spesielle krav                              |
        | Kort beskrivelse                       | Mangler karakter                            |
        | Informasjon til søker i Min kompetanse | Du mangler karakter i et fag som kreves.    |
        | Tekst til vedtaksbrev                  | Søkeren mangler karakter i et fag som kreves. |
        | Sperrer opptak                         | Nei                                         |
        | Aktiv                                  | Ja                                          |
      Så finnes mangelkoden "KAR" i regelverkssamlingen "UHG 2027"

    Scenario: Tilgjengelige kategorier for mangelkoder
      Når opptaksforvalteren ved HK-dir velger kategori for en mangelkode
      Så kan opptaksforvalteren velge mellom følgende kategorier
        | Kategori       |
        | Generelle krav |
        | Spesielle krav |
        | Poeng          |
        | Kvote          |

    Scenariomal: Sperrer opptak kan <tillatt> settes på en mangelkode i kategorien <kategori>
      Når opptaksforvalteren ved HK-dir oppretter en mangelkode i kategorien "<kategori>"
      Så kan opptaksforvalteren <tillatt> velge at mangelkoden sperrer opptak

      Eksempler:
        | kategori       | tillatt |
        | Generelle krav | også    |
        | Spesielle krav | ikke    |
        | Poeng          | ikke    |
        | Kvote          | ikke    |

    Scenariomal: Opptaksforvalteren ved <organisasjon> forvalter mangelkodene i <opptak>
      Gitt at opptaket "<opptak>" forvaltes av "<organisasjon>"
      Når opptaksforvalteren ved <organisasjon> åpner mangelkodene i regelverkssamlingen til "<opptak>"
      Så kan opptaksforvalteren opprette og endre mangelkodene

      Eksempler:
        | opptak                  | organisasjon         |
        | Samordna opptak 2027    | HK-dir               |
        | Lokalt opptak høst 2027 | Universitetet i Oslo |

  # ── 2. Registrering ──────────────────────────────────────────

  @openquestion
  Regel: Kategorien til mangelkoden avgjør hva mangelen hindrer
    # ÅPNE SPØRSMÅL:
    # - Hva skjer ellers med saken når en mangel hindrer saksbehandleren i å vurdere om søkeren er
    #   kvalifisert? Påvirker det behandlingsstatusen eller vedtaket?

    Scenario: Mangel på generelle krav hindrer kvalifisering til alle søknadsalternativene i saken
      Gitt at saken hos "Universitetet i Oslo" har søknadsalternativene "Informatikk, UiO" og "Historie, UiO"
      Og at saken har en mangel i kategorien "Generelle krav"
      Når saksbehandleren ved Universitetet i Oslo vurderer kvalifiseringen
      Så kan ikke saksbehandleren sette søkeren som kvalifisert til noen av søknadsalternativene i saken

    Scenario: Mangel på spesielle krav hindrer kvalifisering bare til søknadsalternativene med kompetanseregelverket
      Gitt at saken hos "Universitetet i Oslo" har følgende søknadsalternativer
        | søknadsalternativ | kompetanseregelverk |
        | Informatikk, UiO  | GSK-UHG, MATR2      |
        | Historie, UiO     | GSK-UHG             |
      Og at saken har en mangel i kategorien "Spesielle krav" på kompetanseregelverket "MATR2"
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

    Scenario: Mangel som sperrer opptak holder søkeren utenfor tilbudskjøringen
      Gitt at saken hos "Universitetet i Oslo" har en mangel med en mangelkode som sperrer opptak
      Når tilbudskjøringen kjøres
      Så deltar ikke søkeren i tilbudskjøringen

  Regel: Saksbehandlende organisasjon registrerer mangler i saken sin

    Scenario: Registrere mangel på spesielle krav
      Når saksbehandleren ved Universitetet i Oslo registrerer en mangel i saken med følgende opplysninger
        | felt                | verdi                                                      |
        | Mangelkode          | KAR                                                        |
        | Kompetanseregelverk | MATR2                                                      |
        | Kommentar           | Du mangler karakter i R2. Dokumenter ett av kravene under. |
      Så har saken mangelen "KAR" på kompetanseregelverket "MATR2"

    Scenario: Saksbehandleren velger blant kompetanseregelverkene til søknadsalternativene i saken
      Gitt at søknadsalternativene i saken hos "Universitetet i Oslo" har kompetanseregelverkene "GSK-UHG" og "MATR2"
      Når saksbehandleren ved Universitetet i Oslo velger kompetanseregelverk for en mangel
      Så kan saksbehandleren velge "GSK-UHG" og "MATR2"
      Og saksbehandleren kan ikke velge andre kompetanseregelverk

    Scenario: Registrere mangel på kvote
      Når saksbehandleren ved Universitetet i Oslo registrerer mangelen "BOS" i kategorien "Kvote" på kvotespørsmålet "Bosted i Nord-Norge"
      Så har saken mangelen "BOS" på kvotespørsmålet "Bosted i Nord-Norge"

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

  @openquestion
  Regel: Saksbehandleren sjekker ut mangelen når søkeren har dokumentert på nytt
    # ÅPNE SPØRSMÅL:
    # - Hva heter det at saksbehandleren har sjekket ut mangelen? «Sjekket ut» er et arbeidsnavn.

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
      Gitt at saken hos "Universitetet i Oslo" har mangelen "KAR" på kompetanseregelverket "MATR2"
      Og at mangelen "KAR" er sjekket ut
      Når saksbehandleren ved Universitetet i Oslo vurderer kvalifiseringen
      Så kan saksbehandleren sette søkeren som kvalifisert til søknadsalternativene med "MATR2"

    Scenario: Saksbehandleren ser om søkeren har sett mangelen
      Gitt at mangelen "KAR" er publisert
      Og at søkeren har sett mangelen "KAR" i Min kompetanse
      Når saksbehandleren ved Universitetet i Oslo ser manglene i saken
      Så ser saksbehandleren at søkeren har sett mangelen "KAR"

  # ── 3. Publisering og melding ────────────────────────────────

  @openquestion
  Regel: Søkeren ser bare manglene saksbehandleren har publisert, og får melding om dem
    # ÅPNE SPØRSMÅL:
    # - Sendes meldingen når manglene publiseres, eller er det et eget steg?
    # - Sender hver saksbehandlende organisasjon sin egen melding?

    Scenario: Registrering av mangel publiserer ikke mangelen
      Når saksbehandleren ved Universitetet i Oslo registrerer mangelen "KAR"
      Så ser ikke søkeren mangelen "KAR" i Min kompetanse
      Og søkeren har ikke mottatt en melding av typen MANGEL

    Scenario: Saksbehandleren publiserer mangelen
      Gitt at saken hos "Universitetet i Oslo" har mangelen "KAR"
      Når saksbehandleren ved Universitetet i Oslo markerer mangelen "KAR" som klar til publisering
      Så ser søkeren mangelen "KAR" i Min kompetanse

    Scenario: Søkeren får én melding om manglene som er publisert
      Gitt at saksbehandleren ved Universitetet i Oslo har publisert manglene "KAR" og "STEMPEL"
      Når søkeren får melding om manglene
      Så mottar søkeren én melding av typen MANGEL

    Scenario: Søkeren åpner meldingen om mangel
      Gitt at søkeren har mottatt en melding av typen MANGEL
      Når søkeren åpner meldingen
      Så ser søkeren at det er registrert mangler i søknaden
      Og søkeren ser fristen for å laste opp dokumentasjon
      Og søkeren kan gå til dokumentasjonssiden

  @openquestion
  Regel: Fristen er dokumentasjonsfristen som gjelder søknadsalternativet
    # ÅPNE SPØRSMÅL:
    # - Hvilken frist vises når manglene gjelder søknadsalternativer med ulike frister?

    Scenariomal: Fristen når utdanningstilbudet <tidlig>
      Gitt at ettersendingsfristen i opptaket er "2027-07-01 23:59"
      Og at "Politiutdanning, PHS" <tidlig>
      Og at saken har en mangel på kompetanseregelverket til "Politiutdanning, PHS"
      Når søkeren åpner meldingen om mangel
      Så er fristen "<frist>"

      Eksempler:
        | tidlig                                            | frist            |
        | har tidlig dokumentasjonsfrist "2027-03-01 23:59" | 2027-03-01 23:59 |
        | ikke har tidlig dokumentasjonsfrist               | 2027-07-01 23:59 |

  # ── 4. Søkerens visning ──────────────────────────────────────

  Regel: Søkeren ser manglene på dokumentasjonssiden

    Scenario: Mangel på spesielle krav vises under søknadsalternativene med kompetanseregelverket
      Gitt at "Informatikk, UiO" har kompetanseregelverket "MATR2"
      Og at "Historie, UiO" ikke har kompetanseregelverket "MATR2"
      Og at saken har den publiserte mangelen "KAR" på kompetanseregelverket "MATR2"
      Når søkeren åpner dokumentasjonssiden
      Så er "Informatikk, UiO" merket med at dokumentasjon mangler
      Og "Historie, UiO" er ikke merket med at dokumentasjon mangler

    Scenario: Søkeren ser kravene i kompetanseregelverket mangelen gjelder
      Gitt at saken har den publiserte mangelen "KAR" på kompetanseregelverket "MATR2"
      Når søkeren ser manglene for "Informatikk, UiO"
      Så ser søkeren informasjonen til søker for mangelkoden "KAR"
      Og søkeren ser kravelementene i "MATR2"

    Scenario: Søkeren ser kommentaren fra saksbehandleren
      Gitt at den publiserte mangelen "KAR" har en kommentar fra saksbehandleren
      Når søkeren ser manglene for "Informatikk, UiO"
      Så ser søkeren kommentaren fra saksbehandleren

    Scenariomal: Mangel på <kategori> vises øverst på dokumentasjonssiden
      Gitt at saken har en publisert mangel i kategorien "<kategori>"
      Når søkeren åpner dokumentasjonssiden
      Så vises mangelen øverst på dokumentasjonssiden
      Og mangelen vises ikke under søknadsalternativene

      Eksempler:
        | kategori |
        | Poeng    |
        | Kvote    |

    Scenario: Mangel som er sjekket ut vises ikke for søkeren
      Gitt at den publiserte mangelen "KAR" er sjekket ut
      Når søkeren åpner dokumentasjonssiden
      Så ser ikke søkeren mangelen "KAR"

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

  @openquestion
  Regel: Mangelen for vitnemål som kommer i år settes og sjekkes ut automatisk
    # ÅPNE SPØRSMÅL:
    # - Hvilken mangelkode og hvilket kompetanseregelverk får den automatiske mangelen, og gjelder
    #   den alle sakene i søknaden?
    # - Hva betyr det at automatisk behandling overskriver en mangel som er satt manuelt, og hvor
    #   angis det at en mangelkode kan overskrives? Det står verken i Figma eller i STEK-174.

    Scenario: Saken får mangel når søkeren oppgir at vitnemålet kommer i år
      Når søkeren oppgir i søknaden at vitnemålet kommer i år
      Så får saken automatisk mangelen for vitnemål som kommer i år

    Scenario: Mangelen sjekkes ut når vitnemålet behandles automatisk
      Gitt at saken har den automatiske mangelen for vitnemål som kommer i år
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
