# language: no
# GitHub: #603
@OPT-SØK-SØK-011 @must @draft
Egenskap: Listevisning og søk i utdanningstilbud
  Som søker
  ønsker jeg en oversikt over utdanningstilbud jeg kan søke på, med mulighet for søk og filtrering
  slik at jeg raskt kan finne riktig utdanningstilbud, selv om jeg ikke kjenner det offisielle navnet.

  # Siden heter «Finn studier» i Min kompetanse. Den er åpen for alle, og innlogging trengs først
  # for å legge et utdanningstilbud i studiekurven (studiekurv.feature).
  #
  # Kilder:
  # - Confluence: Min kompetanse: Finn studier (PFS 5056593964)
  # - Confluence: Søkefelt på «Finn studier» (PFS 4816568327), FK-01–FK-22
  # - Figma: Min Kompetanse 2026, node 498-3818 (gjeldende skisse)
  # - Jira: TOT-2286
  #
  # GJENNOMGANG (fs-krav, påbegynt 2026-10-08):
  # Gjennomgått: synlighet, innlogging og studiekurv, feltene i listen, sortering, sideinndeling.
  # Ikke gjennomgått ennå: tidligere poenggrenser, forklaring av forkortelser, fritekst-søk,
  # søkeforslag, filtrene, nullstilling, ingen treff og deling av søket. Scenarioene for disse
  # bygger på Confluence og skissen, og skal gjennomgås før kravet kan bli @planned.
  # Neste spørsmål: hvilke poenggrenser vises (kvoter, år, plasstildelingsrunde)?

  Regel: Liste over alle utdanningstilbud

    @openquestion
    Scenario: Se liste over utdanningstilbud
      # ÅPNE SPØRSMÅL:
      # - Skal studieformen bare vises når utdanningstilbudet ikke har undervisning ved lærestedet?
      #   I skissen står den bare på noen rader, for eksempel «Årsstudium, samlingsbasert, høst».
      Når søkeren åpner Finn studier
      Så ser søkeren en liste over utdanningstilbud med disse feltene:
        | felt                               |
        | Navn på utdanningstilbudet         |
        | Studienivå, progresjon og oppstart |
        | Studieform                         |
        | Opptakskrav                        |
        | Lærested                           |
        | Studiested                         |
        | Tidligere poenggrenser             |

    Scenario: Listen er sortert alfabetisk på navn uten søketekst
      Gitt at søkeren ikke har skrevet noe i søkefeltet
      Når søkeren åpner Finn studier
      Så vises utdanningstilbudene sortert etter navn i stigende rekkefølge

    Scenariomal: Velge sorteringsretning for navn på utdanningstilbudet
      Gitt at søkeren ser listen over utdanningstilbud
      Når søkeren velger å sortere på navn i <retning> rekkefølge
      Så vises utdanningstilbudene sortert etter navn i <retning> rekkefølge

      Eksempler:
        | retning  |
        | stigende |
        | synkende |

    # Finn studier bruker sider med 25, 50 eller 100 treff i stedet for «last inn flere».
    # Søkerne blar i lange lister og skal kunne gå direkte til en bestemt side (skissen, node 498-3818).
    Scenario: Listen viser de 50 første utdanningstilbudene
      Når søkeren åpner Finn studier
      Så ser søkeren totalt antall utdanningstilbud som matcher søket og filtrene
      Og listen viser de 50 første utdanningstilbudene

    Scenariomal: Velge antall treff per side
      Gitt at søkeren ser listen over utdanningstilbud
      Når søkeren velger <antall> treff per side
      Så viser listen <antall> utdanningstilbud per side

      Eksempler:
        | antall |
        | 25     |
        | 50     |
        | 100    |

    Scenario: Bla til neste side
      Gitt at det finnes flere utdanningstilbud enn det er plass til på én side
      Når søkeren velger neste side
      Så viser listen de neste utdanningstilbudene

    @openquestion
    Scenario: Søkeren endrer søket, et filter eller antall treff per side
      # ÅPNE SPØRSMÅL:
      # - Kommer søkeren tilbake til side 1 når søket, et filter eller antall treff per side endres?
      #   Eller blir søkeren stående på siden med de samme treffene når antall treff per side endres?
      Gitt at søkeren står på side 3 i listen
      Når søkeren endrer søket
      Så viser listen side 1

    Scenario: Søkeren ser at resultatene hentes
      Gitt at søkeren ser listen over utdanningstilbud
      Når søkeren endrer søket
      Så ser søkeren at resultatene hentes
      Og antall treff og listen oppdateres uten at siden lastes på nytt

    @openquestion
    Scenario: Se tidligere poenggrenser
      # ÅPNE SPØRSMÅL:
      # - Hvilke poenggrenser vises: ordinær kvote (ORD) og førstegangsvitnemål (ORDF) fra
      #   hovedopptaket året før, alle kvotene, eller fra en annen plasstildelingsrunde eller flere år?
      # - Hva betyr «Alle (ORD)» i skissen: at alle kvalifiserte søkere i kvoten fikk tilbud?
      Gitt at utdanningstilbudet "Sykepleie, høst 2027" hadde opptak året før
      Når søkeren åpner Finn studier
      Så ser søkeren de tidligere poenggrensene for utdanningstilbudet per kvote

    Scenario: Utdanningstilbud uten tidligere poenggrenser
      Gitt at utdanningstilbudet "Sykepleie, høst 2027" ikke hadde opptak året før
      Når søkeren åpner Finn studier
      Så står det "Nytt i år" i stedet for tidligere poenggrenser for utdanningstilbudet

    Scenario: Forkortelser for opptakskrav og kvoter forklares
      Gitt at søkeren ser listen over utdanningstilbud
      Når søkeren ser nærmere på opptakskravet "GENS"
      Så forklares det at "GENS" betyr generell studiekompetanse

    Scenario: Navigere til detaljside for utdanningstilbud
      Gitt at søkeren ser listen over utdanningstilbud
      Når søkeren velger et utdanningstilbud
      Så ser søkeren detaljsiden for valgt utdanningstilbud

  Regel: Søk og filtrering av utdanningstilbud

    Scenario: Fritekst-søk på navn, lærested og studiested
      Når søkeren søker med fritekst på "Bergen"
      Så filtreres listen til utdanningstilbud der navnet, lærestedet eller studiestedet matcher søket

    Scenario: Fritekst-søk på stikkord
      # Stikkordene settes av opptaksforvalter (opptaksinnstillinger_utdanningstilbud.feature).
      Gitt at utdanningstilbudet "Profesjonsstudiet i medisin, høst 2027" har stikkordet "lege"
      Når søkeren søker med fritekst på "lege"
      Så vises utdanningstilbudet "Profesjonsstudiet i medisin, høst 2027" i listen

    Scenario: Treff som matcher flest søkeord, vises først
      Når søkeren søker med fritekst på "sykepleie Bergen"
      Så vises utdanningstilbud som matcher både "sykepleie" og "Bergen" før utdanningstilbud som bare matcher ett av ordene

    @openquestion
    Scenariomal: Søket tåler skrivemåter som avviker fra navnet
      # ÅPNE SPØRSMÅL:
      # - Hører reglene for hvordan søket matcher tekst (store og små bokstaver, æ/ø/å, bøyningsformer
      #   og skrivefeil) hjemme i 10 Felleskrav, slik at de gjelder alle søk?
      Når søkeren søker med fritekst på "<søketekst>"
      Så vises utdanningstilbudet "<utdanningstilbud>" i listen

      Eksempler:
        | søketekst  | utdanningstilbud              |
        | SYKEPLEIE  | Sykepleie, høst 2027          |
        | okonomi    | Økonomi og administrasjon     |
        | sykepleier | Sykepleie, høst 2027          |
        | sykepleir  | Sykepleie, høst 2027          |

    Scenario: Tomt søkefelt viser alle utdanningstilbud
      Gitt at søkeren har valgt filtre
      Når søkeren tømmer søkefeltet
      Så vises alle utdanningstilbud som matcher de valgte filtrene

    Scenario: Ingen utdanningstilbud matcher søket
      Når søkeren søker med fritekst på "xyzxyz"
      Så får søkeren beskjed om at ingen utdanningstilbud matcher søket
      Og søkeren får forslag til hvordan søket kan endres

    Scenario: Tilgjengelige studienivåer i filter
      Når søkeren åpner filteret for studienivå
      Så inneholder filteret disse studienivåene:
        | Studienivå            |
        | Bachelor              |
        | Kandidat              |
        | Mastergrad            |
        | Profesjonsstudium     |
        | Yrkesutdanning        |
        | Årsstudium            |
        | Fagskolestudium       |
        | Fagskolegrad          |
        | Høyere fagskolegrad   |
      Og ingen studienivåer er valgt som standard

    Scenario: Tilgjengelige oppstartssemestre i filter
      Når søkeren åpner filteret for oppstart
      Så inneholder filteret disse semestrene:
        | Oppstart     |
        | Høstsemester |
        | Vårsemester  |
      Og ingen semestre er valgt som standard

    Scenario: Tilgjengelige progresjoner i filter
      Når søkeren åpner filteret for progresjon
      Så inneholder filteret disse progresjonene:
        | Progresjon |
        | Heltid     |
        | Deltid     |
      Og ingen progresjoner er valgt som standard

    Scenario: Tilgjengelige studieformer i filter
      Når søkeren åpner filteret for studieform
      Så inneholder filteret disse studieformene:
        | Studieform     |
        | Samlingsbasert |
        | Desentralisert |
        | Nettstudium    |
      Og hver studieform har en forklaring
      Og ingen studieformer er valgt som standard

    @openquestion
    Scenario: Tilgjengelige studiesteder i filter
      # ÅPNE SPØRSMÅL:
      # - Inneholder filteret bare studiestedene til utdanningstilbudene i listen, eller alle studiesteder?
      Når søkeren åpner filteret for studiested
      Så inneholder filteret studiestedene til utdanningstilbudene i listen
      Og hvert studiested vises kun én gang
      Og studiestedene er sortert alfabetisk
      Og "Alle" er valgt som standard

    @openquestion
    Scenario: Tilgjengelige læresteder i filter
      # ÅPNE SPØRSMÅL:
      # - Inneholder filteret bare lærestedene til utdanningstilbudene i listen, eller alle læresteder?
      Når søkeren åpner filteret for lærested
      Så inneholder filteret lærestedene til utdanningstilbudene i listen
      Og hvert lærested vises kun én gang
      Og lærestedene er sortert alfabetisk
      Og "Alle" er valgt som standard

    Scenariomal: Filtrere på <filter>
      Når søkeren velger "<verdi>" som filter for <filter>
      Så vises kun utdanningstilbud med <filter> "<verdi>"

      Eksempler:
        | filter     | verdi          |
        | studienivå | Bachelor       |
        | oppstart   | Høstsemester   |
        | progresjon | Deltid         |
        | studieform | Nettstudium    |
        | studiested | Trondheim      |
        | lærested   | NTNU           |

    @openquestion
    Scenario: Velge flere verdier i samme filter
      # ÅPNE SPØRSMÅL:
      # - Når søkeren krysser av for flere verdier i samme filter, vises utdanningstilbud som har
      #   minst én av verdiene? Dette er ikke avklart.
      Når søkeren velger "Bachelor" og "Mastergrad" som filter for studienivå
      Så vises utdanningstilbud med studienivå "Bachelor" eller "Mastergrad"

    Scenario: Kombinere filtre
      Når søkeren kombinerer fritekst-søk med ett eller flere filter
      Så vises kun utdanningstilbud som matcher alle kriteriene

    Scenario: Søketeksten beholdes når et filter endres
      Gitt at søkeren har søkt med fritekst på "sykepleie"
      Når søkeren velger "Deltid" som filter for progresjon
      Så står søketeksten "sykepleie" fortsatt i søkefeltet

    Scenario: Filtrene beholdes når søket endres
      Gitt at søkeren har valgt "Deltid" som filter for progresjon
      Når søkeren søker med fritekst på "sykepleie"
      Så er "Deltid" fortsatt valgt som filter for progresjon

    Scenario: Nullstille filtrene
      Gitt at søkeren har valgt filtre
      Når søkeren velger å nullstille filtrene
      Så er ingen filtre valgt
      Og alle utdanningstilbud som matcher søket, vises

    Scenario: Skjule filtrene
      Gitt at søkeren ser filtrene
      Når søkeren velger å skjule filtrene
      Så ser søkeren listen over utdanningstilbud uten filtrene

  Regel: Søkeforslag mens søkeren skriver

    Scenario: Søkeren får forslag mens søkeren skriver
      Når søkeren skriver "sy" i søkefeltet
      Så får søkeren forslag til utdanningstilbud, læresteder og studiesteder som matcher teksten
      Og hvert forslag viser om det er et utdanningstilbud, et lærested eller et studiested

    Scenario: Søkeren velger et forslag
      Gitt at søkeren får forslag i søkefeltet
      Når søkeren velger forslaget "Sykepleie, høst 2027"
      Så filtreres listen etter forslaget uten at søkeren må søke på nytt

    @openquestion
    Scenario: Antall forslag er begrenset
      # ÅPNE SPØRSMÅL:
      # - Confluence anbefaler forslag etter 2 tegn og maks 8 forslag (FK-07, FK-11). Er det besluttet?
      Når søkeren skriver "sy" i søkefeltet
      Så får søkeren høyst 8 forslag

  Regel: Synlighet via søknadsperioden i opptaket

    Scenario: Søkeren ser utdanningstilbud i opptak med åpen søknadsperiode
      Gitt at søknaden i opptaket "Samordna opptak 2027" har åpnet
      Og at søknadsfristen i opptaket "Samordna opptak 2027" ikke har gått ut
      Når søkeren åpner Finn studier
      Så vises utdanningstilbudene i opptaket "Samordna opptak 2027" i listen

    Scenario: Søkeren ser ikke utdanningstilbud i opptak der søknaden ikke har åpnet
      Gitt at søknaden i opptaket "Samordna opptak 2027" ikke har åpnet
      Når søkeren åpner Finn studier
      Så vises ikke utdanningstilbudene i opptaket "Samordna opptak 2027" i listen

    @openquestion
    Scenario: Søkeren ser ikke utdanningstilbud der søknadsfristen har gått ut
      # ÅPNE SPØRSMÅL:
      # - Hvilken frist styrer når utdanningstilbudet forsvinner fra listen: fristen for opptaket,
      #   den tidlige søknadsfristen for utdanningstilbudet (opptaksinnstillinger_utdanningstilbud.feature),
      #   eller fristen som gjelder for utdanningsbakgrunnen til søkeren (frister_og_hendelser.feature)?
      Gitt at søknadsfristen for utdanningstilbudet "Sykepleie, høst 2027" har gått ut
      Når søkeren åpner Finn studier
      Så vises ikke utdanningstilbudet "Sykepleie, høst 2027" i listen

    @openquestion
    Scenario: Søkeren ser ikke et trukket utdanningstilbud
      # ÅPNE SPØRSMÅL:
      # - Skal et utdanningstilbud som er trukket etter at søknaden har åpnet, skjules fra listen,
      #   eller vises merket som trukket uten mulighet til å legge det i studiekurven?
      #   Se trekke_utdanningstilbud.feature.
      Gitt at utdanningstilbudet "Sykepleie, høst 2027" er trukket etter at søknaden i opptaket har åpnet
      Når søkeren åpner Finn studier
      Så vises ikke utdanningstilbudet "Sykepleie, høst 2027" i listen

  Regel: Søkeren kan legge utdanningstilbud i studiekurven fra listen

    Scenario: Innlogget søker legger et utdanningstilbud i studiekurven
      Gitt at søkeren er innlogget
      Når søkeren velger å legge utdanningstilbudet "Sykepleie, høst 2027" i studiekurven
      Så ligger utdanningstilbudet "Sykepleie, høst 2027" i studiekurven
      Og antallet utdanningstilbud i studiekurven oppdateres

    Scenario: Søkeren som ikke er innlogget, blir bedt om å logge inn
      Gitt at søkeren ikke er innlogget
      Når søkeren velger å legge utdanningstilbudet "Sykepleie, høst 2027" i studiekurven
      Så blir søkeren bedt om å logge inn

    Scenario: Utdanningstilbudet legges i studiekurven etter innlogging
      Gitt at søkeren ikke er innlogget
      Og at søkeren har valgt å legge utdanningstilbudet "Sykepleie, høst 2027" i studiekurven
      Når søkeren logger inn
      Så ligger utdanningstilbudet "Sykepleie, høst 2027" i studiekurven
      Og søkeren er tilbake på Finn studier med samme søk, filtre og side som før

  # Deling av søket er et bør-krav i #603 (FK-22).
  Regel: Søket kan deles og bokmerkes

    Scenario: Dele et søk
      Gitt at søkeren har søkt med fritekst på "sykepleie" og valgt "Deltid" som filter for progresjon
      Når en annen person åpner lenken til søket
      Så ser personen listen med søketeksten "sykepleie" og filteret "Deltid"

    Scenario: Tilbakeknappen i nettleseren viser forrige søk
      Gitt at søkeren har søkt med fritekst på "sykepleie"
      Og søkeren har søkt med fritekst på "jus"
      Når søkeren går tilbake i nettleseren
      Så viser listen treffene for søketeksten "sykepleie"
