# language: no
@BRU-TIL-SAM-002 @must @planned
Egenskap: Tildele tilgang til en applikasjon mot en organisasjonssamling
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å tildele en tilgang til en applikasjon mot en organisasjonssamling i et gitt miljø
  slik at applikasjonen får tilgangen i alle organisasjonene i samlingen uten at den må tildeles
  én gang per organisasjon.

  En organisasjonssamling er en navngitt mengde organisasjoner. Å tildele mot samlingen er den
  samme handlingen som å tildele mot én organisasjon — bare uttrykt mot en mengde: tilgangen får
  virkning i hver organisasjon som er aktivt medlem av samlingen i det samme miljøet. Det er
  tildelingens form, ikke tilgangens navn, som gjør virkningen bred.

  Tildelingen gjelder ett miljø, og virkningen krysser aldri miljø: både tildelingen og
  medlemskapet må gjelde i miljøet det slås opp i. En samling kan derfor ha ulike medlemmer i
  test og i produksjon uten at et testmedlemskap noensinne gir tilgang i produksjon.

  Egenskapen speiler tildel- og fjern-flyten for enkeltorganisasjoner, BRU-APP-API-007 og
  BRU-APP-API-008, og den er uavhengig av hvordan samlingene selv forvaltes: reglene under
  gjelder enten medlemslistene vedlikeholdes gjennom løsningen eller av databaseforvaltningen.
  Forvaltningen av samlinger og medlemskap er en egen kravdiskusjon, jf. BRU-TIL-SAM-001.

  # Spørsmålet om en tilgang som følger av en samling skal vises i applikasjonens egen
  # tilgangsliste, er besvart av implementasjonen 13.11.2026. Se regelen «En tilgang gitt
  # gjennom en samling vises i applikasjonens tilgangsliste, men fjernes ikke der».
  #
  # ÅPNE SPØRSMÅL:
  # - Skal brukere, og ikke bare applikasjoner, kunne være mottaker av en tildeling mot en
  #   samling? Behovet er bare kjent for applikasjoner. Implementasjonen 13.11.2026 skiller:
  #   API-et for å tildele og trekke tilbake mot en samling tar bare applikasjoner, mens
  #   rollelistene for personbrukere og siden for en rolle allerede viser roller en person har
  #   fått gjennom en samling (BRU-PER-ROL-001). Det finnes ingen flate for å gi en person en
  #   tilgang mot en samling. Med personer som mottaker følger også spørsmålene fra utkastet i
  #   #546: om et rollenekt på personen slår tilgangen fra samlingen, og hvordan det fremgår i
  #   visningen av mine tilganger at en tilgang følger av en samling.
  # - Skal delegeringstaket til en applikasjon kunne utvides mot en samling fra løsningen?
  #   Delegeringstaket har fått en egen samlingsform, som vises i applikasjonens delegeringstak
  #   og gjelder valglisten for roller (BRU-PER-GRU-003), men det finnes ingen flate i løsningen
  #   for å skrive den. Det er en annen mengde enn tilgangene i denne egenskapen: å
  #   tildele en tilgang mot en samling endrer ikke applikasjonens delegeringstak.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og det finnes en organisasjonssamling med medlemsorganisasjoner i et miljø

  Regel: En tildeling gjelder én tilgang, én applikasjon, én samling og ett miljø

    Scenario: Tildele en tilgang mot en samling
      Gitt jeg har rettighet til å tildele tilgangen i hver av samlingens medlemsorganisasjoner i miljøet
      Når jeg tildeler tilgangen til en applikasjon mot samlingen i det miljøet
      Så er tilgangen gitt mot samlingen for det miljøet
      Og det fremgår hvilken samling og hvilket miljø tildelingen gjelder

    Scenario: Tilgangen får virkning i hver medlemsorganisasjon i miljøet
      Gitt jeg har rettighet til å tildele tilgangen i hver av samlingens medlemsorganisasjoner i miljøet
      Når jeg tildeler tilgangen til en applikasjon mot samlingen i det miljøet
      Så har applikasjonen tilgangen i hver organisasjon som er aktivt medlem av samlingen i miljøet
      Og applikasjonen har ikke tilgangen i organisasjoner som ikke er medlem

    Scenario: Tildeling i ett miljø gir ingen virkning i et annet
      Gitt samlingen har medlemsorganisasjoner i både testmiljøet og produksjonsmiljøet
      Og jeg har rettighet til å tildele tilgangen i hver av medlemsorganisasjonene i testmiljøet
      Når jeg tildeler tilgangen til en applikasjon mot samlingen i testmiljøet
      Så har applikasjonen tilgangen i medlemsorganisasjonene i testmiljøet
      Og applikasjonen har ikke tilgangen i produksjonsmiljøet

    Scenario: Tilgangen drar med seg de tilgangene den omfatter
      Gitt tilgangen omfatter svakere tilganger
      Når tilgangen er gitt til en applikasjon mot samlingen i et miljø
      Så har applikasjonen også de svakere tilgangene i medlemsorganisasjonene i miljøet

    Scenario: Tildele flere tilganger mot flere samlinger i samme forespørsel
      Gitt jeg har rettighet til å tildele tilgangene i hver medlemsorganisasjon i de aktuelle samlingene og miljøene
      Når jeg tildeler flere tilganger mot flere samlinger i samme forespørsel
      Så er hver tilgang gitt mot den samlingen og det miljøet den ble sendt inn for

    Scenario: Tilgang kan gis til en deaktivert applikasjon
      Gitt applikasjonen er deaktivert
      Og jeg har rettighet til å tildele tilgangen i hver av samlingens medlemsorganisasjoner i miljøet
      Når jeg tildeler tilgangen mot samlingen i det miljøet
      Så er tilgangen registrert mot samlingen
      Og deaktiveringen er uendret

  Regel: Tildeling mot en samling krever rettighet til å tildele i hver av medlemsorganisasjonene

    # Dette er egenskapens kjerneregel, og den er en anti-eskaleringsregel. Én tildeling mot en
    # samling gir tilgangen i hver aktive medlemsorganisasjon. Holdt det å ha rettigheten i én
    # av dem, kunne en administrator ved ett lærested gitt en applikasjon tilgang ved alle de
    # andre ved å gå gjennom en samling lærestedet er medlem av. Rekkevidden av det man skriver
    # skal ligge innenfor rekkevidden av det man selv har rettighet til.
    #
    # Rettigheten er den samme som for å tildele mot én organisasjon, jf. BRU-APP-API-007 — det
    # er ikke en ny rettighet, og ingen egen samlingsrolle kreves. Den er per organisasjon og
    # per miljø, som ellers.

    Scenario: Tildeling avvises når rettigheten mangler i én medlemsorganisasjon
      Gitt jeg har rettighet til å tildele tilgangen i alle samlingens medlemsorganisasjoner i miljøet unntatt én
      Når jeg forsøker å tildele tilgangen til en applikasjon mot samlingen i det miljøet
      Så avvises tildelingen
      Og ingen tilgang er gitt mot samlingen
      Og det fremgår at rettigheten kreves for hver av medlemsorganisasjonene

    Scenario: Tildeling gjennomføres når rettigheten dekker alle medlemsorganisasjonene
      Gitt jeg har rettighet til å tildele tilgangen i hver av samlingens medlemsorganisasjoner i miljøet
      Og jeg har rettigheten også i organisasjoner utenfor samlingen
      Når jeg tildeler tilgangen til en applikasjon mot samlingen i det miljøet
      Så er tilgangen gitt mot samlingen

    Scenario: Rettigheten vurderes per miljø
      Gitt jeg har rettighet til å tildele tilgangen i hver av samlingens medlemsorganisasjoner i testmiljøet
      Og jeg har ikke rettigheten i produksjonsmiljøet
      Når jeg forsøker å tildele tilgangen mot samlingen i produksjonsmiljøet
      Så avvises tildelingen

    Scenario: Ingenting skrives når ett innslag i forespørselen avvises
      Gitt jeg sender flere tildelinger i samme forespørsel
      Og jeg mangler rettigheten i én medlemsorganisasjon for ett av innslagene
      Når jeg forsøker å utføre forespørselen
      Så avvises hele forespørselen
      Og ingen av tildelingene er gitt

    Scenario: Samling uten aktive medlemmer i miljøet krever likevel tildelingsmyndighet i miljøet
      Gitt en samling ikke har aktive medlemsorganisasjoner i et miljø
      Og jeg har ikke rettighet til å tildele tilganger i noen organisasjon i det miljøet
      Når jeg forsøker å tildele en tilgang mot samlingen i det miljøet
      Så avvises tildelingen

    Scenario: Tilgang gitt mot en samling uten aktive medlemmer har ingen virkning
      Gitt en samling ikke har aktive medlemsorganisasjoner i et miljø
      Og jeg har rettighet til å tildele tilganger i det miljøet
      Når jeg tildeler en tilgang til en applikasjon mot samlingen i det miljøet
      Så er tilgangen gitt mot samlingen
      Men applikasjonen har ikke tilgangen i noen organisasjon

  Regel: En utgått tilgang kan ikke tildeles mot en samling

    # AVKLART 13.11.2026 (fra implementasjonen): API-et avviser at en utgått tilgang tildeles mot
    # en samling, med feilen at tilgangskoden er utgått (fs-plattform !6766, BAT-257). Det er den
    # samme regelen som for de andre tildelingsveiene, jf. «Utgåtte roller kan ikke tildeles» i
    # BRU-PER-GRU-003. Tilgangen kan fortsatt trekkes tilbake. Å tildele en utgått tilgang som alt
    # gjelder mot samlingen og miljøet, er suksess uten endring, som for andre tilganger.

    Scenario: Tildeling av en utgått tilgang mot en samling avvises
      Gitt en tilgang er markert som utgått i rollekatalogen
      Og jeg har rettighet til å tildele i hver av samlingens medlemsorganisasjoner i miljøet
      Når jeg forsøker å tildele den utgåtte tilgangen til en applikasjon mot samlingen i det miljøet
      Så avvises tildelingen
      Og det fremgår at tilgangen er utgått

    Scenario: Utgåtte tilganger er ikke blant tilgangene som kan tildeles mot en samling
      # Kommer med fs-plattform !6773 (BAT-434), som var åpen 13.11.2026. Til den er flettet,
      # står utgåtte tilganger i listen over tilganger som kan tildeles mot samlingen.
      Gitt en tilgang er markert som utgått i rollekatalogen
      Og jeg har rettighet til å tildele i hver av samlingens medlemsorganisasjoner i miljøet
      Når jeg velger tilganger å tildele mot samlingen
      Så vises ikke den utgåtte tilgangen

    Scenario: En tilgang som er blitt utgått, kan trekkes tilbake mot samlingen
      Gitt en tilgang er gitt til en applikasjon mot en samling i et miljø
      Og tilgangen er senere markert som utgått i rollekatalogen
      Og jeg har rettighet til å tildele i hver av samlingens medlemsorganisasjoner i miljøet
      Når jeg trekker tilbake tilgangen mot samlingen i det miljøet
      Så har applikasjonen ikke lenger tilgangen i medlemsorganisasjonene i miljøet

  Regel: Å gi en tilgang som alt er gitt, eller trekke tilbake en som ikke gjelder, er suksess

    Scenario: Tildele en tilgang som alt gjelder mot samlingen
      Gitt en tilgang er gitt til en applikasjon mot en samling i et miljø
      Når jeg tildeler den samme tilgangen mot den samme samlingen og det samme miljøet på nytt
      Så er tildelingen registrert som utført
      Og tidspunktet tilgangen opprinnelig ble gitt er uendret
      Og det finnes fortsatt bare én gjeldende tildeling for kombinasjonen

    Scenario: Trekke tilbake en tilgang som ikke gjelder
      Gitt en applikasjon ikke har en gjeldende tilgang mot en samling i et miljø
      Når jeg trekker tilbake den tilgangen mot samlingen i det miljøet
      Så er tilbaketrekkingen registrert som utført
      Og historikken er uendret

  Regel: En tilgang trekkes tilbake ved at gyldigheten lukkes, og historikken består

    Scenario: Trekke tilbake en tilgang gitt mot en samling
      Gitt en tilgang er gitt til en applikasjon mot en samling i et miljø
      Og jeg har rettighet til å tildele tilgangen i hver av samlingens medlemsorganisasjoner i miljøet
      Når jeg trekker tilbake tilgangen mot samlingen i det miljøet
      Så har applikasjonen ikke lenger tilgangen i medlemsorganisasjonene i miljøet
      Og tilgangen gjelder fortsatt i de øvrige miljøene den er gitt i

    Scenario: Den tilbaketrukne tilgangen står i historikken
      Gitt en tilgang er trukket tilbake mot en samling i et miljø
      Når jeg åpner tilgangene for samlingen
      Så ser jeg den tilbaketrukne tilgangen med tidspunktet den ble gitt og tidspunktet den ble trukket tilbake
      Og jeg ser hvem som ga den og hvem som trakk den tilbake

    Scenario: Se hvilke tilganger som gjelder nå
      Gitt en samling har både gjeldende og tilbaketrukne tilganger
      Når jeg åpner tilgangene for samlingen og velger å se kun de gjeldende
      Så ser jeg tilgangene som gjelder nå
      Og de tilbaketrukne er ikke med i utvalget

  Regel: Tilbaketrekking berører ikke tilgang som består på annen vei

    Scenario: Tilgang tildelt direkte i en medlemsorganisasjon består
      Gitt en applikasjon har en tilgang både mot en samling og tildelt direkte i en medlemsorganisasjon
      Når jeg trekker tilbake tilgangen mot samlingen
      Så har applikasjonen fortsatt tilgangen i den organisasjonen
      Og den direkte tildelingen står uendret i applikasjonens egen tilgangsliste

    Scenario: Tilgang gitt gjennom en annen samling består
      Gitt en organisasjon er medlem av to samlinger som begge har den samme tilgangen gitt mot seg
      Når jeg trekker tilbake tilgangen mot den ene samlingen
      Så har applikasjonen fortsatt tilgangen i organisasjonen gjennom den andre samlingen

    Scenario: Å fjerne en direkte tildeling fjerner ikke tilgangen som følger av samlingen
      # AVKLART 13.11.2026 (fra implementasjonen): FS Admin sier etter fjerningen at
      # applikasjonen fortsatt har tilgangen, med tilgangskoden. API-et svarer at tilgangen
      # fortsatt gjelder gjennom samlingen.
      Gitt en applikasjon har en tilgang både mot en samling og tildelt direkte i en medlemsorganisasjon
      Når jeg fjerner den direkte tildelingen i organisasjonen
      Så er den direkte tildelingen fjernet
      Og applikasjonen har fortsatt tilgangen i organisasjonen fordi organisasjonen er medlem av samlingen
      Og det fremgår at applikasjonen fortsatt har tilgangen
      Og tildelingen mot samlingen står uendret

  Regel: En tilgang gitt gjennom en samling vises i applikasjonens tilgangsliste, men fjernes ikke der

    # AVKLART 13.11.2026 (fra implementasjonen): Tilgangslisten på applikasjonen viser en
    # tilgang gitt gjennom en samling som en rad i hver organisasjon som er aktivt medlem av
    # samlingen i miljøet, med «Via samlingen …» og navnet på samlingen. Tilgangene den omfatter,
    # står som arvede rader. Listen kan filtreres på tilknytningen «Via samling». I dialogen for
    # å fjerne tilganger kan raden ikke velges, med forklaringen «Via samling … — kan bare
    # trekkes tilbake for hele samlingen». API-et avviser også å fjerne den for én organisasjon.
    # Kilde: fs-admin (BAT-308 og BAT-311) og tilgangsstyringen på fs-plattform main.
    # Det besvarer det åpne spørsmålet om visningen i applikasjonens egen tilgangsliste.

    Scenario: Tilgangen vises i hver medlemsorganisasjon med samlingen den er gitt gjennom
      Gitt en tilgang er gitt til en applikasjon mot en samling i et miljø
      Når jeg åpner tilgangslisten på applikasjonen
      Så ser jeg tilgangen i hver organisasjon som er aktivt medlem av samlingen i miljøet
      Og det fremgår hvilken samling tilgangen er gitt gjennom

    Scenario: Filtrere tilgangslisten på tilganger gitt gjennom en samling
      Gitt applikasjonen har tilganger både tildelt direkte og gitt gjennom en samling
      Når jeg filtrerer tilgangslisten på tilknytningen «Via samling»
      Så ser jeg bare tilgangene som er gitt gjennom en samling

    Scenario: En tilgang gitt gjennom en samling kan ikke fjernes for én organisasjon
      Gitt applikasjonen har en tilgang i en medlemsorganisasjon bare gjennom en samling
      Når jeg velger tilganger å fjerne for organisasjonen og miljøet
      Så kan jeg ikke velge tilgangen som er gitt gjennom samlingen
      Og det fremgår at tilgangen bare kan trekkes tilbake for hele samlingen

  Regel: Virkningen følger medlemslisten

    # Dekningskravet vurderes når tildelingen gis. Endres medlemslisten etterpå, endres
    # virkningen med den, uten at tildelingen berøres — å melde en organisasjon inn i en samling
    # som alt har tildelinger, utvider de tildelingene til organisasjonen. Det er grunnen til at
    # forvaltningen av medlemskapene er en egen og strengere gatet handling enn tildelingen, jf.
    # BRU-TIL-SAM-001, og det er der en eventuell revalidering hører hjemme.

    Scenario: Ny medlemsorganisasjon omfattes av tildelingen
      Gitt en tilgang er gitt til en applikasjon mot en samling i et miljø
      Når en organisasjon meldes inn i samlingen i det miljøet
      Så har applikasjonen tilgangen også i den organisasjonen
      Og tildelingen mot samlingen står uendret

    Scenario: Organisasjon som meldes ut mister tilgangen
      Gitt en tilgang er gitt til en applikasjon mot en samling i et miljø
      Og en organisasjon er aktivt medlem av samlingen i det miljøet
      Når organisasjonen meldes ut av samlingen i det miljøet
      Så har applikasjonen ikke lenger tilgangen i den organisasjonen
      Og tildelingen mot samlingen står uendret

    Scenario: Endring i medlemslisten i ett miljø endrer ikke virkningen i et annet
      Gitt en tilgang er gitt til en applikasjon mot en samling i både testmiljøet og produksjonsmiljøet
      Når en organisasjon meldes ut av samlingen i testmiljøet
      Så har applikasjonen fortsatt tilgangen i organisasjonen i produksjonsmiljøet

  @openquestion
  Regel: Tildelingene mot en samling er skjermet, mens katalogen og medlemslisten er åpen

    # ÅPNE SPØRSMÅL:
    # - Implementasjonen 13.11.2026 skjermer listen over tildelingene mot samlingen slik regelen
    #   sier, både på samlingen og på applikasjonen. Men raden i tilgangslisten på applikasjonen
    #   (regelen over) vises for alle som ville sett en direkte tildeling til applikasjonen i den
    #   organisasjonen og det miljøet, med navnet på samlingen. En administrator i én
    #   medlemsorganisasjon ser altså at applikasjonen har tilgangen gjennom samlingen, men får en
    #   tom liste over tildelingene mot samlingen. Er det slik vi vil ha det? Rollesiden gjør det
    #   samme for personer (BRU-PER-ROL-001, avklart av Kjetil).

    @openquestion
    Scenario: Se tildelingene mot en samling jeg kan tildele mot
      # ÅPNE SPØRSMÅL:
      # - I implementasjonen 13.11.2026 ser jeg tildelingen, men ikke hvilken applikasjon den er
      #   gitt til, når jeg mangler innsyn i applikasjonen (lesetilgang i organisasjonen som eier
      #   applikasjonen). Raden viser da tilgang, miljø og gyldighet. Skal kravet si det, eller
      #   skal retten til å tildele mot samlingen også gi innsyn i applikasjonen?
      Gitt jeg har rettighet til å tildele tilganger i hver av samlingens medlemsorganisasjoner i miljøet
      Når jeg åpner tilgangene for samlingen
      Så ser jeg hvilke applikasjoner som har fått hvilke tilganger, i hvilket miljø

    Scenario: Tildelingene er ikke synlige uten rettigheten
      Gitt en samling har tilganger gitt mot seg i et miljø
      Og jeg mangler rettigheten til å tildele i én av samlingens medlemsorganisasjoner i miljøet
      Når jeg åpner tilgangene for samlingen
      Så ser jeg ingen tildelinger
      Og det fremgår at en tom liste ikke betyr at samlingen er uten tildelinger

    Scenario: Katalogen og medlemslisten er synlig uten rettigheten
      Gitt jeg ikke har rettighet til å tildele tilganger i noen av samlingens medlemsorganisasjoner
      Når jeg åpner samlingen
      Så ser jeg samlingens navn, beskrivelse og medlemsorganisasjoner per miljø
      Men jeg ser ingen handling for å tildele en tilgang mot samlingen

    Scenario: Medlemslisten forklarer et avslag
      Gitt en tildeling mot en samling er avvist fordi rettigheten mangler i en medlemsorganisasjon
      Når jeg åpner medlemslisten for samlingen i miljøet
      Så ser jeg hvilke organisasjoner rettigheten kreves for
