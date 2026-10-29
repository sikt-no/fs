# language: no
@OPT-SØK-SØK-001 @opptakspilot @implemented
Egenskap: Søke på opptak
    Som borger ønsker jeg å kunne søke på et opptak til et studie jeg ønsker å delta på slik at jeg kan få skoleplass

  @harTest @nih
  Scenario: Søker ser viktig informasjon om et opptak: "<info>"
    Gitt personen er på hovedsiden til personflaten
    Når personen går inn på velg opptak
    Og personen velger et opptak
    Så ser personen "<info>"
    Eksempler:
      | info             |
      | Studiestart      |
      | Studieplasser    |
      | Studiekode       |
      | Progresjon       |
      | Utdanningsområde |
      | Semestre         |
      | Studiepoeng      |
      | Kjønnspoeng      |

  @harTest @nih
  Scenario: En person søker på et opptak med kun ett studie
    Gitt personen er på hovedsiden til personflaten
    Gitt personen er en søker
    Når personen går inn på velg opptak
    Og personen velger et opptak
    Og personen starter søknad
    Og personen aksepterer deling av elektronisk dokumentasjon med saksbehandler
    Og personen laster opp dokumentasjon
    Og personen går til oppsummering
    Og personen sender inn søknad
    Så får personen se en kvittering på at søknaden er mottatt
    Så får personen får se et søknadsnummer

  @draft
  Scenario: En person får feilmelding på ikke mottatt kvittering på søknad
    Gitt at personen har forsøkt å søke på et opptak
    Når det skjer noe galt med innsending av søknaden
    Så skal personen få en forklaring på hvorfor

  @nih @draft
  Scenario: Søker kan finne utdanningstilbud i en ekstern studiekatalog hos aktuelt lærested og skal da kunne komme inn i en søknad i brukerflaten derfra
    Gitt personen er inne på hovedsiden til UiT
    Og personen er inne på UiT sin studiekatalog
    Når personen velger et utdanningstilbud fra studiekatalogen
    Og personen velger å søke på utdanningstilbudet
    Så blir personen sendt til utdanningstilbudet i personbrukerflaten

  @harTest
  Scenario: Søker kan se oversikt over alle sine søknader
    Gitt personen har søkt på et opptak
    Og personen er på hovedsiden til personflaten
    Når personen trykker på Mine Søknader
    Så skal personen se sine søknader i en liste

  @harTest
  Scenario: Søker kan se en spesifikk søknad etter innsending
    Gitt personen er på hovedsiden til personflaten
    Gitt personen har søkt på et opptak
    Når personen trykker på Mine Søknader
    Og personen trykker på en søknad
    Så skal personen kunne se informasjon om søknaden

  @harTest
  Scenario: Søker kan se at en søknad er mottatt etter innsending
    Gitt personen har søkt på et opptak
    Og personen er på hovedsiden til personflaten
    Når personen trykker på Mine Søknader
    Så skal personen kunne se mottatt i informasjon om søknaden

  @draft
  Scenario: Søker begynner på en søknad og lagrer den uten å sende inn
    Gitt personen er på hovedsiden til personflaten
    Gitt personen er en søker
    Når personen går inn på velg opptak
    Og personen velger et opptak
    Og personen starter søknad
    Og personen aksepterer deling av elektronisk dokumentasjon med saksbehandler
    Og personen laster opp dokumentasjon
    Og personen velger å lagre søknad til senere
    Så skal søknaden være mulig å fortsette på senere

  @draft
  Scenario: Søker ser oversikt over påbegynte søknader
    Gitt personen har startet på en søknad og lagret den til senere
    Og personen er på hovedsiden til personflaten
    Når personen trykker på Mine Søknader
    Så skal personen se en oversikt over alle påbegynte søknader

  @draft
  Scenario: Søker går inn på en påbegynt søknader og fullfører den
    Gitt personen har startet på en søknad og lagret den til senere
    Og personen er på hovedsiden til personflaten
    Og personen trykker på Mine Søknader
    Når personen velger en påbegynt søknad
    Så skal personen kunne fortsette søknaden sin som vanlig


  @draft
  Scenario: Søker ser oversikt over innsendte søknader

  @draft
  Scenario: Søker kan se egenopplastet dokumentasjon
    Gitt at personen har søkt på et opptak og lastet opp dokumentasjon
    Når personen går inn på søknaden
    Så skal personen se hvilken dokumentasjon de har lastet opp

  @draft
  Scenario: Søker kan se dokumentasjon lastet opp av saksbehandler
    Gitt at personen har søkt på et opptak og en saksbeandler har lastet opp dokumentasjon
    Når personen går inn på søknaden
    Så skal personen se hvilken dokumentasjon saksbehandler har lastet opp

  @draft
  Scenario: Søker kan laste opp ytterligere dokumentasjon etter innsending av søknad
    Gitt at personen har søkt på et opptak
    Og personen går inn på søknaden
    Når personen laster opp dokumentasjon
    Så skal dokumentasjonen blir tilgjengelig for administratoren


  @draft
  Scenario: Person sletter opplastet dokumentasjon før innsending av søknad
    Gitt En person har lastet opp dokumentasjon
    Når Personen sletter et dokument
    Så blir dokumentet fjernet fra listen

  @draft
  Scenario: Person sletter opplastet dokumentasjon etter innsending av søknad
    Gitt En person har lastet opp dokumentasjon
    Når Personen sletter et dokument
    Så blir dokumentet fjernet fra listen
    Og blir dokumentet ikke lengre tilgjengelig for administrator

  @draft
  Scenario: Person kan trekke søknaden

  @draft
  Scenario: Søker oppgir om de søker på grunnlag av realkompetanse

  @draft
  Scenario: Person kan svare på tilbud om studieplass
  @draft
  Scenario: Person kan endre svar på søknad mellom ja og nei før en gitt frist
  @draft
  Scenario: Saksbehandler kan svare på tilbud manuelt på vegne av søker
  @draft
  Scenario: Søker kan gi tilbakemelding om sin opplevelse

  @draft
  Regel: Søkeren kan begynne på og sende inn en søknad bare når søknaden i opptaket har åpnet
    # Virkningen av når søknaden åpner og den ordinære søknadsfristen, som opptaksforvalter setter i
    # 11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature.
    # Lagt til 2026-10-19 etter akseptansetesten av opprette og vedlikeholde opptak.

    # AVKLART 2026-10-19 (S1): Opptaket har ingen egen publiseringsdato. Søkerne kan ikke begynne på en søknad
    # eller se utdanningstilbudene før søknaden åpner. Synligheten står i finne_studier.feature
    # (Regel «Synlighet via søknadsperioden i opptaket»).
    Scenario: Søkeren kan ikke begynne på en søknad før søknaden åpner
      Gitt at søknaden i opptaket åpner "2027-02-01"
      Når søkeren vil begynne på en søknad "2027-01-15"
      Så kan søkeren ikke begynne på søknaden

    Scenario: Søkeren kan sende inn søknaden fra søknaden åpner
      Gitt at søknaden i opptaket åpner "2027-02-01"
      Og at søkeren har en søknad som er klar til å sendes inn
      Når søkeren sender inn søknaden "2027-02-01"
      Så er søknaden sendt inn

    # Flyttet fra frister_og_hendelser.feature. AVKLART 2026-10-15 (Q3, TAKE-410 og TAKE-411): En åpningsdato
    # som ikke er satt, holder søknaden stengt.
    Scenario: Søkeren kan ikke sende inn søknad når det ikke er satt når søknaden åpner
      Gitt at det ikke er satt når søknaden åpner
      Når en søker vil sende inn en søknad
      Så kan søkeren ikke sende inn søknaden

    Scenario: Søkeren kan ikke sende inn nye søknader etter ordinær søknadsfrist
      Gitt at den ordinære søknadsfristen i opptaket er "2027-04-15 23:59"
      Og at søkeren har en utdanningsbakgrunn uten avvikende frister
      Når søkeren vil sende inn en ny søknad "2027-04-16"
      Så kan søkeren ikke sende inn søknaden

  @draft @openquestion @depends-on-OPT-OVO-GRU-004
  Regel: Søkeren kan ikke begynne på eller endre en søknad i et avpublisert opptak
    # Virkningen av at opptaksforvalter avpubliserer opptaket (opptaksstatus.feature).
    # Lagt til 2026-10-28 (produkteier).
    # ÅPNE SPØRSMÅL:
    # - Avpublisering er en nødbrems. Hva skal skje med søknader som er påbegynt eller sendt inn
    #   mens opptaket er avpublisert? Skal søkeren kunne fortsette, og hvordan får søkeren vite det?
    #   I Min kompetanse brukes publiseringen i dag bare i Finn studier.

    Scenario: Søkeren kan ikke begynne på en søknad i et avpublisert opptak
      Gitt at opptaket "Samordna opptak 2027" er avpublisert
      Når søkeren vil begynne på en søknad i opptaket "Samordna opptak 2027"
      Så kan søkeren ikke begynne på søknaden

    Scenario: Søkeren kan ikke endre søknaden i et avpublisert opptak
      Gitt at søkeren har en søknad i opptaket "Samordna opptak 2027"
      Og at opptaket "Samordna opptak 2027" er avpublisert
      Når søkeren vil endre søknaden
      Så kan søkeren ikke endre søknaden

    Scenario: Søkeren ser søknaden i et avpublisert opptak
      Gitt at søkeren har en søknad i opptaket "Samordna opptak 2027"
      Og at opptaket "Samordna opptak 2027" er avpublisert
      Når søkeren åpner søknaden
      Så ser søkeren søknaden

  @draft
  Regel: Søknadsfristen og dokumentasjonsfristen følger søkerens utdanningsbakgrunn
    # Virkningen av de avvikende fristene per utdanningsbakgrunn som opptaksforvalter setter i
    # 11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature.
    # Lagt til 2026-10-19 etter akseptansetesten av opprette og vedlikeholde opptak.

    Scenario: Søker med en utdanningsbakgrunn med avvikende frister får fristene for utdanningsbakgrunnen
      Gitt at utdanningsbakgrunnen "Realkompetanse" har søknadsfrist "2027-03-01 23:59" og dokumentasjonsfrist "2027-03-01 23:59" i opptaket
      Og at den ordinære søknadsfristen er "2027-04-15 23:59"
      Og at søkeren har valgt utdanningsbakgrunnen "Realkompetanse"
      Når søkeren ser på søknaden
      Så er søknadsfristen for søkeren "2027-03-01 23:59"
      Og dokumentasjonsfristen for søkeren er "2027-03-01 23:59"

    # AVKLART 2026-10-19 (S4): Opptaksforvalter setter utdanningsbakgrunnene og fristene som gjelder i opptaket,
    # og søknaden bruker dem.
    Scenario: Søker med en utdanningsbakgrunn uten avvikende frister følger de ordinære fristene
      Gitt at utdanningsbakgrunnen "Norsk videregående skole" ikke har avvikende frister i opptaket
      Og at den ordinære søknadsfristen er "2027-04-15 23:59"
      Og at den ordinære dokumentasjonsfristen er "2027-04-15 23:59"
      Og at søkeren har valgt utdanningsbakgrunnen "Norsk videregående skole"
      Når søkeren ser på søknaden
      Så er søknadsfristen for søkeren "2027-04-15 23:59"
      Og dokumentasjonsfristen for søkeren er "2027-04-15 23:59"

    # Flyttet fra frister_og_hendelser.feature. AVKLART 2026-10-15 (Q7, TAKE-407): Bytter søkeren
    # utdanningsbakgrunn, gjelder fristene for den nye bakgrunnen.
    Scenario: Søker som bytter utdanningsbakgrunn, følger fristene for den nye bakgrunnen
      Gitt at utdanningsbakgrunnen "Realkompetanse" har søknadsfrist "2027-03-01 23:59"
      Og at den ordinære søknadsfristen er "2027-04-15 23:59"
      Og at søkeren har valgt utdanningsbakgrunnen "Realkompetanse"
      Når søkeren bytter til utdanningsbakgrunnen "Norsk videregående skole" "2027-03-20"
      Så kan søkeren sende inn søknaden fram til "2027-04-15 23:59"

  @draft
  Regel: Søknadsnummeret følger startnummeret i opptaket
    # Virkningen av startnummeret som opptaksforvalter setter i
    # 11 Opprette og vedlikeholde opptak/03 Innstillinger/innstillinger.feature.
    # Lagt til 2026-10-19 etter akseptansetesten av opprette og vedlikeholde opptak.

    # AVKLART 2026-10-15 (Q18, TAKE-413): Søkeren og saksbehandleren ser bare løpenummeret. Nummeret er unikt
    # i opptaket, men nummerserien kan ha hull.
    Scenario: Søknadene i opptaket får løpende nummer fra startnummeret
      Gitt at startnummeret for søknadene i opptaket er 1001
      Når søkerne sender inn søknader i opptaket
      Så får søknadene løpende nummer fra 1001
      Og søkeren og saksbehandleren ser bare løpenummeret
      Og søknadsnummeret er unikt i opptaket

    Scenario: Søknadene får løpende nummer fra 1 når startnummeret ikke er satt
      Gitt at startnummeret for søknadene i opptaket ikke er satt
      Når søkerne sender inn søknader i opptaket
      Så får søknadene løpende nummer fra 1
