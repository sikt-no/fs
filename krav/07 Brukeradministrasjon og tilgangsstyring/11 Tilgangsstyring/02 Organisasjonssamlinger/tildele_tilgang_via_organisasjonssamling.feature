# language: no
@BRU-TIL-SAM-002 @could @draft
Egenskap: Tildele tilgang via organisasjonssamling
  Som forvalter av tilgangsstyring i Sikt
  ønsker jeg å tildele en tilgang mot en organisasjonssamling i et gitt miljø
  slik at tilgangen gjelder alle organisasjonene i samlingen uten at den må tildeles én gang per
  organisasjon.

  En tildeling mot en samling er den samme handlingen som en tildeling mot én organisasjon —
  bare uttrykt mot en mengde. Det er tildelingens form, ikke rollens navn, som gjør tilgangen
  global. Tildelingen gjelder ett miljø, og den utvides til de organisasjonene som er medlem av
  samlingen i det samme miljøet. Autorisasjonen krysser aldri miljø.

  Denne egenskapen speiler tildel- og fjern-flyten for enkeltorganisasjoner, som er beskrevet i
  BRU-APP-API-007 og BRU-APP-API-008 for applikasjoner. Utvidelsen fra samling til
  medlemsorganisasjoner finnes i datamodellen (fs-plattform MR 5262); det er tildelingsflaten
  som mangler.

  # ÅPNE SPØRSMÅL:
  # - Hvem skal kunne være mottaker av en tildeling mot samling — brukere, applikasjoner eller
  #   begge? Modellen skiller ikke, men behovene er ikke like godt kjent.
  # - Skal tildelinger mot samling vises i samme oversikt som tildelinger mot én organisasjon,
  #   eller i en egen oversikt? Se proveniensspørsmålet nederst i filen.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg har global forvaltningsrettighet for organisasjonssamlinger

  Regel: En tilgang kan tildeles mot en organisasjonssamling i ett eksplisitt valgt miljø

    Scenario: Tildele en tilgang mot en samling
      Når jeg velger en organisasjonssamling, et miljø og en tilgang
      Så er tilgangen tildelt mot samlingen for det valgte miljøet
      Og det fremgår hvilken samling og hvilket miljø tildelingen gjelder

    Scenario: Tilgangen gjelder samlingens medlemmer i det samme miljøet
      Gitt en samling har medlemmer i det valgte miljøet
      Når jeg tildeler en tilgang mot samlingen i det miljøet
      Så gjelder tilgangen i hver av medlemsorganisasjonene i det miljøet

    Scenario: Tildeling i ett miljø gir ingen tilgang i et annet miljø
      Gitt en samling har medlemmer i både testmiljøet og produksjonsmiljøet
      Når jeg tildeler en tilgang mot samlingen i testmiljøet
      Så gjelder tilgangen bare i medlemsorganisasjonene i testmiljøet
      Og tilgangen gjelder ikke i produksjonsmiljøet

    Scenario: Nytt medlem omfattes av tildelingen
      Gitt en tilgang er tildelt mot en samling i et miljø
      Når en organisasjon meldes inn i samlingen i det miljøet
      Så gjelder tilgangen også i den organisasjonen

    Scenario: Organisasjon som fjernes fra samlingen mister tilgangen
      Gitt en tilgang er tildelt mot en samling i et miljø
      Og en organisasjon er medlem av samlingen i det miljøet
      Når organisasjonen fjernes fra samlingen i det miljøet
      Så gjelder tilgangen ikke lenger i den organisasjonen
      Og tildelingen mot samlingen står fortsatt

  Regel: Tildeling mot en samling krever den globale forvaltningsrettigheten

    Scenario: Administrator uten global forvaltningsrettighet kan ikke tildele mot samling
      Gitt jeg administrerer én eller flere organisasjoner
      Og jeg ikke har global forvaltningsrettighet for organisasjonssamlinger
      Når jeg tildeler en tilgang
      Så kan jeg bare velge en organisasjon jeg administrerer
      Og organisasjonssamling er ikke et valg

  Regel: En tildeling mot samling trekkes tilbake, og historikken består

    Scenario: Fjerne en tildeling mot en samling
      Gitt en tilgang er tildelt mot en samling i et miljø
      Når jeg fjerner tildelingen
      Så gjelder tilgangen ikke lenger i noen av medlemsorganisasjonene i det miljøet
      Og tildelingen står i historikken med tidspunktet den ble trukket tilbake og hvem som gjorde det

    Scenario: Fjerning berører ikke den samme tilgangen tildelt direkte på en organisasjon
      Gitt en bruker har en tilgang tildelt både mot en samling og direkte på en medlemsorganisasjon
      Når jeg fjerner tildelingen mot samlingen
      Så beholder brukeren tilgangen på den organisasjonen den er tildelt direkte på

    Scenario: Se når en tildeling mot samling ble gitt
      Gitt en tilgang er tildelt mot en samling i et miljø
      Når jeg åpner tildelingene for samlingen
      Så ser jeg når tildelingen ble gitt og hvem som ga den

  Regel: En tilgang tildelt via samling oppfører seg ellers som en direkte tildeling

    Scenario: Tilgangen drar med seg de tilgangene den omfatter
      Gitt en tilgang omfatter svakere tilganger
      Når tilgangen er tildelt mot en samling i et miljø
      Så gjelder også de svakere tilgangene i medlemsorganisasjonene i det miljøet

    Scenario: Et rollenekt på en bruker slår tilgangen som følger av samlingen
      Gitt en bruker har en tilgang som følger av en tildeling mot en samling
      Når den samme tilgangen nektes brukeren
      Så har brukeren ikke tilgangen i noen av medlemsorganisasjonene

    @openquestion
    Scenario: Delegering til en applikasjon kan ikke uttrykkes mot en samling
      # ÅPNE SPØRSMÅL: Delegering fra organisasjon til applikasjon er bevisst holdt utenfor
      # samlingsformen i første omgang — en applikasjon må delegeres tilgang per organisasjon.
      # Om delegering senere skal kunne uttrykkes mot en samling er ikke avklart, og svaret
      # avgjør om en samling kan brukes til å gi en applikasjon tilgang bredt.
      Gitt en applikasjon skal få tilgang til data i flere organisasjoner
      Når jeg delegerer tilgang til applikasjonen
      Så må delegeringen gjøres for hver organisasjon
      Og organisasjonssamling er ikke et valg i delegeringen

  Regel: Det fremgår hvorfor en bruker har en tilgang

    # ÅPNE SPØRSMÅL: En tilgang kan følge av tre ting: en direkte tildeling på organisasjonen, at
    # en sterkere tilgang omfatter den, eller at organisasjonen er medlem av en samling det er
    # tildelt mot. Skal samling være en egen tilknytningsverdi i visningen av mine tilganger, en
    # undertype av «arvet», eller ikke skilles fra en direkte tildeling i det hele tatt? Valget
    # avgjør både visningen og hva en administrator kan gjøre med tilgangen fra den visningen —
    # en samlingsderivert tilgang kan ikke fjernes på organisasjonen den vises på.

    @openquestion
    Scenario: Se at en tilgang følger av medlemskap i en samling
      Gitt jeg har en tilgang som følger av en tildeling mot en samling
      Når jeg åpner oversikten over mine tilganger
      Så fremgår det at tilgangen følger av at organisasjonen er medlem av samlingen
      Og det fremgår hvilken samling den følger av

    @openquestion
    Scenario: Samme tilgang både direkte og via samling vises én gang
      Gitt jeg har den samme tilgangen tildelt direkte på en organisasjon og via en samling
      Når jeg åpner oversikten over mine tilganger
      Så vises tilgangen én gang for den organisasjonen
