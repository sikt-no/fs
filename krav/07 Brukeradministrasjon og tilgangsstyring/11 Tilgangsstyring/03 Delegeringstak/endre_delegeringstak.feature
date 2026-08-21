# language: no
@BRU-TIL-DEL-002 @could @draft
Egenskap: Endre delegeringstaket for en applikasjon
  Som applikasjonsadministrator hos Sikt
  ønsker jeg å legge til og avslutte delegeringer i en applikasjons delegeringstak
  slik at taket kan følge tilgangene som faktisk skal brukes gjennom applikasjonen, uten at
  endringen må gå gjennom databaseforvaltningen.

  Å utvide et delegeringstak er ikke å gi applikasjonen en tilgang — det er å gi den lov til å
  bære en tilgang brukerne allerede har. Utvidelsen øker likevel hva applikasjonen kan utføre i
  en brukers navn, i en organisasjon som ikke selv er part i endringen. Det er derfor den mest
  inngripende handlingen i applikasjonsforvaltningen, og den er gatet strengere enn resten:
  endring krever applikasjonsadministrator hos Sikt. Lesing er bredere, jf. BRU-TIL-DEL-001 —
  organisasjonen som har lånt ut myndighet skal kunne se det, uten å kunne endre det.

  Én endring gjelder én tilgang, i én organisasjon, i ett miljø. En delegering avsluttes ved at
  gyldigheten lukkes, ikke ved at innslaget fjernes, slik at historikken består.

  Datamodellen finnes og er i produksjonsløypa. Det som mangler er endringsflaten: i dag legges
  delegeringer inn manuelt av databaseforvaltningen, og ingen del av løsningen skriver til taket.

  # ÅPNE SPØRSMÅL:
  # - Skal taket for Sikts egne administrasjonsflater følge tilgangskatalogen automatisk, eller
  #   forvaltes manuelt som alle andre tak? Se designnotatet.
  # - Skal en organisasjon kunne be om en utvidelse den ikke selv kan utføre, eller er
  #   forespørselen en oppgave for support utenfor løsningen?

  Bakgrunn:
    Gitt jeg er innlogget i løsningen

  Regel: Bare applikasjonsadministrator hos Sikt kan endre et delegeringstak

    # Gatingen er besluttet, og er et bevisst avvik fra mønsteret i resten av
    # applikasjonsforvaltningen, der en administrator forvalter det som hører til sine egne
    # organisasjoner. Grunnen er at et takinnslag ikke er organisasjonens eget valg: det gir en
    # applikasjon lov til å opptre i organisasjonens navn, og applikasjonen tilhører ofte en
    # annen part.

    Scenario: Applikasjonsadministrator hos Sikt legger til en delegering
      Gitt jeg har applikasjonsadministrator-rollen for Sikt
      Når jeg legger til en delegering for en applikasjon med en tilgang, en organisasjon og et miljø
      Så er delegeringen gyldig fra endringstidspunktet
      Og applikasjonen kan formidle tilgangen for brukere i den organisasjonen i det miljøet

    Scenario: Administrator for organisasjonen kan ikke endre taket
      Gitt jeg har applikasjonsadministrator-rollen for en organisasjon som ikke er Sikt
      Når jeg åpner delegeringstaket for en applikasjon
      Så ser jeg ingen handling for å legge til en delegering
      Og jeg ser ingen handling for å avslutte en delegering

    Scenario: Å administrere applikasjonen gir ikke rett til å endre taket
      Gitt jeg har applikasjonsadministrator-rollen for organisasjonen som eier applikasjonen
      Og organisasjonen er ikke Sikt
      Når jeg åpner delegeringstaket for applikasjonen
      Så ser jeg ingen handling for å legge til en delegering

    Scenario: Å administrere den berørte organisasjonen gir ikke rett til å utvide taket
      Gitt jeg har applikasjonsadministrator-rollen for en organisasjon som ikke er Sikt
      Og en applikasjon kan opptre på vegne av brukere i organisasjonen
      Når jeg åpner delegeringstaket for applikasjonen
      Så kan jeg lese innslagene som gjelder organisasjonen
      Men jeg kan ikke legge til nye innslag for organisasjonen

    Scenario: Forsøk på endring uten rettigheten avvises
      Gitt jeg ikke har applikasjonsadministrator-rollen for Sikt
      Når jeg forsøker å legge til en delegering for en applikasjon
      Så avvises endringen
      Og det fremgår at endring av delegeringstak krever applikasjonsadministrator hos Sikt

  Regel: En endring gjelder én tilgang, én organisasjon og ett miljø

    Scenario: Delegering i ett miljø gir ingen formidlingsevne i et annet
      Gitt jeg har applikasjonsadministrator-rollen for Sikt
      Når jeg legger til en delegering for en applikasjon i testmiljøet
      Så kan applikasjonen formidle tilgangen i testmiljøet
      Og applikasjonen kan ikke formidle tilgangen i produksjonsmiljøet

    Scenario: Delegering i én organisasjon gir ingen formidlingsevne i en annen
      Gitt jeg har applikasjonsadministrator-rollen for Sikt
      Når jeg legger til en delegering for en applikasjon i én organisasjon
      Så kan applikasjonen formidle tilgangen for brukere i den organisasjonen
      Og applikasjonen kan ikke formidle tilgangen for brukere i andre organisasjoner

    Scenario: Å legge til en delegering som allerede gjelder endrer ingenting
      Gitt jeg har applikasjonsadministrator-rollen for Sikt
      Og en delegering gjelder allerede for en applikasjon i en organisasjon og et miljø
      Når jeg legger til den samme delegeringen på nytt
      Så er delegeringen fortsatt gyldig fra det opprinnelige tidspunktet
      Og historikken får ingen ny oppføring

    Scenario: Flere delegeringer kan legges til i én endring
      Gitt jeg har applikasjonsadministrator-rollen for Sikt
      Når jeg legger til flere delegeringer for en applikasjon i samme endring
      Så er hver delegering gyldig fra endringstidspunktet
      Og det fremgår hvilke delegeringer som ble lagt til

  Regel: Taket trekkes tilbake ved å avslutte delegeringen

    Scenario: Avslutte en delegering
      Gitt jeg har applikasjonsadministrator-rollen for Sikt
      Og en delegering gjelder for en applikasjon i en organisasjon og et miljø
      Når jeg avslutter delegeringen
      Så kan applikasjonen ikke lenger formidle tilgangen der
      Og delegeringen står i historikken med tidspunktet den ble avsluttet

    Scenario: Å avslutte en delegering tar ingen tilgang fra brukeren
      Gitt en bruker har en tilgang i en organisasjon
      Og en applikasjon kan formidle tilgangen der
      Når delegeringen avsluttes
      Så har brukeren fortsatt tilgangen
      Men tilgangen formidles ikke lenger gjennom den applikasjonen

    Scenario: Å avslutte en delegering som ikke gjelder endrer ingenting
      Gitt jeg har applikasjonsadministrator-rollen for Sikt
      Og en delegering er allerede avsluttet
      Når jeg avslutter den samme delegeringen på nytt
      Så er utfallet uendret
      Og historikken får ingen ny oppføring

    Scenario: Endringen bekreftes med hvem den treffer
      Gitt jeg har applikasjonsadministrator-rollen for Sikt
      Når jeg forsøker å avslutte en delegering
      Så får jeg se hvilken organisasjon, tilgang og hvilket miljø endringen gjelder
      Og jeg må bekrefte før endringen utføres

  Regel: Taket må følge tilgangskatalogen

    # Regelen kravene finnes for: en tilgang som skal brukes gjennom en applikasjon må også
    # ligge i applikasjonens delegeringstak, ellers finnes den ikke for en innlogget bruker.
    # Erfaring har vist at dette er lett å glemme, fordi snittet ikke gir noen feilmelding —
    # den nye tilgangen bare uteblir, og bare for brukere som går gjennom en applikasjon.

    Scenario: Ny tilgang som skal brukes gjennom en applikasjon krever et takinnslag
      Gitt jeg har applikasjonsadministrator-rollen for Sikt
      Og en ny tilgang er innført i tilgangskatalogen
      Og tilgangen skal kunne brukes gjennom en applikasjon
      Når jeg ser applikasjonens delegeringstak
      Så fremgår det at taket ikke bærer den nye tilgangen
      Og jeg kan legge den inn for de organisasjonene og miljøene applikasjonen dekker

    @openquestion
    Scenario: Taket for Sikts egne administrasjonsflater følger katalogen
      # ÅPENT SPØRSMÅL: Skal taket for løsningens egen administrasjonsflate holdes i takt med
      # tilgangskatalogen automatisk, slik at en ny administrasjonstilgang virker med én gang,
      # eller skal også den forvaltes manuelt? Automatikk fjerner den vanligste feilklassen,
      # men gjør samtidig taket til noe som utvides uten en beslutning per gang.
      Gitt en ny tilgang for applikasjonsforvaltning er innført i tilgangskatalogen
      Når tilgangen tas i bruk i Sikts egen administrasjonsflate
      Så bærer flatens delegeringstak tilgangen for de organisasjonene og miljøene flaten dekker
