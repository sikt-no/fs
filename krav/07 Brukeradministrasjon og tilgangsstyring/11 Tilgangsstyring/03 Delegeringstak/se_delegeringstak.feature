# language: no
@BRU-TIL-DEL-001 @could @draft
Egenskap: Se delegeringstaket for en applikasjon
  Som administrator for en organisasjon
  ønsker jeg å se hva en applikasjon kan gjøre på vegne av brukerne våre
  slik at jeg kan etterprøve hvilken myndighet vi har lånt ut, og forklare hvorfor en bruker
  ikke får det hun forventer når hun jobber gjennom applikasjonen.

  Et delegeringstak er den øvre grensen for hva en applikasjon kan gjøre PÅ VEGNE AV en
  innlogget bruker. Det er en annen ting enn tilgangene applikasjonen har SOM SEG SELV, som er
  beskrevet i BRU-APP-API-003: taket gir applikasjonen ingenting alene, det sier bare hvor mye
  av en brukers egen myndighet applikasjonen får lov til å bære. Taket er derfor en
  sikkerhetsgrense, og å utvide det er å øke hva applikasjonen kan utføre i en brukers navn.

  Grensen virker som et snitt: en bruker får gjennom en applikasjon bare det hun selv har OG
  taket bærer. Snittet regnes ut per organisasjon og tilgang, i ett miljø. Konsekvensen er at
  taket er usynlig når det virker og usynlig når det ikke virker: en tilgang taket mangler
  forsvinner uten feilmelding, og bare for brukere som går gjennom en applikasjon. Erfaring har
  vist at dette er den vanligste årsaken til at en flate svarer tomt for en bruker som beviselig
  har tilgangen — den nye tilgangen ble innført, men ikke lagt inn i taket. Denne egenskapen
  handler om å gjøre grensen synlig; BRU-TIL-DEL-002 handler om å endre den.

  Datamodellen for delegeringstak finnes og er i produksjonsløypa, med miljødimensjon og full
  historikk. Det som ikke finnes er noen flate: taket kan i dag bare leses og skrives av
  databaseforvaltningen, og innslagene legges inn manuelt.

  # ÅPNE SPØRSMÅL:
  # - Hvilken leserettighet skal kreves for å se taket — samme lesetilgang som resten av
  #   applikasjonsbildet, eller en egen rettighet fordi taket forteller hvor mye myndighet
  #   organisasjonen har lånt ut?
  # - Skal visningen av effektiv formidlingsevne ligge på applikasjonen, på brukeren, eller
  #   begge steder? Spørsmålet er hvem som oppdager et hull først.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen

  Regel: Delegeringstaket er en egen liste, ikke applikasjonens egne tilganger

    Scenario: Se delegeringstaket for en applikasjon
      Gitt jeg er på detaljsiden for en applikasjon
      Når jeg åpner visningen av delegeringstaket
      Så ser jeg en liste over hva applikasjonen kan utøve på vegne av brukere
      Og hvert innslag viser følgende informasjon:
        | felt          |
        | Tilgangskode  |
        | Organisasjon  |
        | Miljø         |
        | Gyldig fra    |
      Og det fremgår at listen er en øvre grense, ikke tilganger applikasjonen har selv

    Scenario: Taket forveksles ikke med applikasjonens egne tilganger
      Gitt en applikasjon har både egne tilganger og et delegeringstak
      Når jeg åpner detaljsiden for applikasjonen
      Så vises de egne tilgangene og delegeringstaket som to ulike lister
      Og det fremgår for hver liste om den gjelder applikasjonen selv eller brukere gjennom den

    Scenario: Bare applikasjoner brukere logger inn i har et delegeringstak
      Gitt en applikasjon autentiserer seg som seg selv og ikke på vegne av en innlogget bruker
      Når jeg åpner detaljsiden for applikasjonen
      Så vises ingen visning av delegeringstak
      Og det fremgår at applikasjonen ikke kan opptre på vegne av brukere

  Regel: Lesing er skopet til organisasjonene jeg administrerer

    # Et innslag i taket navngir organisasjonen applikasjonen kan opptre innenfor — ikke
    # organisasjonen som eier applikasjonen. Lesingen følger derfor den berørte organisasjonen:
    # den som har lånt ut myndighet er den som skal kunne se det.

    Scenario: Administrator ser takinnslagene som gjelder egne organisasjoner
      Gitt jeg administrerer én eller flere organisasjoner
      Når jeg åpner delegeringstaket for en applikasjon
      Så ser jeg innslagene som gjelder organisasjonene jeg administrerer

    Scenario: Administrator ser ikke takinnslag for andre organisasjoner
      Gitt jeg administrerer én organisasjon
      Og applikasjonen har innslag i taket for flere organisasjoner
      Når jeg åpner delegeringstaket for applikasjonen
      Så ser jeg bare innslagene som gjelder min organisasjon

    Scenario: Taket er lesbart for min organisasjon selv om applikasjonen tilhører en annen
      Gitt en applikasjon tilhører en annen organisasjon enn den jeg administrerer
      Og applikasjonen kan opptre på vegne av brukere i min organisasjon
      Når jeg åpner delegeringstaket for applikasjonen
      Så ser jeg innslagene som gjelder min organisasjon

    Scenario: Lesing alene gir ingen handlinger for å endre taket
      Gitt jeg kan lese applikasjonsbildet for en organisasjon jeg administrerer
      Og jeg har ikke rettighet til å endre delegeringstaket for applikasjonen
      Når jeg åpner delegeringstaket for applikasjonen
      Så ser jeg innslagene som gjelder min organisasjon
      Men jeg ser ingen handling for å legge til eller fjerne et innslag

  Regel: Effektiv formidlingsevne skal være synlig

    # Invarianten kravene skal sikre: et tomt eller avskåret snitt skal aldri se ut som at
    # brukeren mangler tilgangen. Det er forskjellen mellom en forklart tilstand og en tom
    # liste ingen kan feilsøke.

    Scenario: Tilgang brukeren har, men taket ikke bærer, vises som avskåret
      Gitt en bruker har en tilgang i en organisasjon
      Og applikasjonens delegeringstak mangler den tilgangen for den organisasjonen
      Når jeg ser hva brukeren kan gjøre gjennom applikasjonen
      Så fremgår det at tilgangen ikke formidles gjennom applikasjonen
      Og det fremgår at årsaken er delegeringstaket, ikke brukerens egne tilganger

    Scenario: Tomt snitt vises som en forklart tilstand
      Gitt en bruker har tilganger i en organisasjon
      Og applikasjonens delegeringstak bærer ingen av dem for den organisasjonen
      Når brukeren jobber i organisasjonen gjennom applikasjonen
      Så fremgår det at applikasjonen ikke kan formidle noen av brukerens tilganger der
      Og meldingen skiller dette fra at brukeren mangler tilgang

    Scenario: Taket sier ingenting om hva brukeren har utenfor applikasjonen
      Gitt applikasjonens delegeringstak mangler en tilgang brukeren har
      Når brukeren bruker en annen applikasjon der taket bærer tilgangen
      Så formidles tilgangen der

    Scenario: Tilganger som gjelder alle er ikke begrenset av taket
      # Tilganger som er åpne for alle legges til etter at snittet er tatt. Taket er altså en
      # grense for brukerens egne tilganger, ikke for alt applikasjonen kan vise.
      Gitt en tilgang gjelder alle brukere i en organisasjon
      Og applikasjonens delegeringstak nevner ikke den tilgangen
      Når en bruker jobber i organisasjonen gjennom applikasjonen
      Så gjelder tilgangen likevel

    Scenario: Deaktivert applikasjon formidler ingenting
      Gitt en applikasjon er deaktivert
      Og applikasjonen har et delegeringstak
      Når en bruker forsøker å jobbe gjennom applikasjonen
      Så formidles ingen av brukerens tilganger
      Og brukerens egne tilganger er uendret

  Regel: Historikken for taket er sporbar

    Scenario: Se når en delegering ble lagt inn og av hvem
      Gitt en applikasjon har et innslag i delegeringstaket for min organisasjon
      Når jeg åpner innslaget
      Så ser jeg tidspunktet delegeringen ble gyldig fra
      Og jeg ser hvem som la den inn

    Scenario: Se avsluttede delegeringer
      Gitt en delegering til en applikasjon er avsluttet
      Når jeg åpner historikken for applikasjonens delegeringstak
      Så ser jeg den avsluttede delegeringen med tidspunktet den startet og tidspunktet den ble avsluttet
      Og jeg ser hvem som la den inn og hvem som avsluttet den

    Scenario: Se taket slik det var på et gitt tidspunkt
      Gitt en applikasjons delegeringstak er endret over tid
      Når jeg ser taket slik det var på et gitt tidspunkt
      Så ser jeg de delegeringene som var gyldige på det tidspunktet
      Og jeg kan se hva applikasjonen kunne formidle den gangen

    Scenario: Gjeninnføring gir en ny delegering
      Gitt en delegering til en applikasjon er avsluttet
      Når den samme delegeringen legges inn på nytt
      Så gjelder delegeringen fra og med tidspunktet den ble lagt inn på nytt
      Og den tidligere delegeringen står fortsatt i historikken
