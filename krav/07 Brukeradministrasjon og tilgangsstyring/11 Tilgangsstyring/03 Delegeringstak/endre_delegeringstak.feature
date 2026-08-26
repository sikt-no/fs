# language: no
@BRU-TIL-DEL-002 @could @draft
Egenskap: Endre delegeringstaket for en applikasjon
  Som applikasjonsadministrator
  ønsker jeg å legge til og avslutte delegeringer i en applikasjons delegeringstak
  slik at taket kan følge tilgangene som faktisk skal brukes gjennom applikasjonen, uten at
  endringen må gå gjennom databaseforvaltningen.

  Å utvide et delegeringstak er ikke å gi applikasjonen en tilgang — det er å gi den lov til å
  bære en tilgang brukerne allerede har. Utvidelsen øker likevel hva applikasjonen kan utføre i
  en brukers navn, og et takinnslag navngir organisasjonen applikasjonen får opptre innenfor —
  ikke nødvendigvis den som eier applikasjonen.

  Endringen har derfor inntil to berørte parter, og rettigheten følger dem: å endre taket krever
  applikasjonsadministrator for organisasjonen som eier applikasjonen, og — når takinnslaget
  gjelder en annen organisasjon — for den organisasjonen i tillegg. Rettigheten er den ordinære
  applikasjonsadministratorrollen, den samme som forvalter applikasjoner ellers, og den er
  skopet til organisasjonene man administrerer. Ingen kan altså utvide et tak inn i en
  organisasjon de ikke administrerer.

  Lesing er bredere, jf. BRU-TIL-DEL-001: organisasjonen som har lånt ut myndighet skal kunne se
  det, uten at lesingen alene gir rett til å endre.

  Én endring gjelder én tilgang, i én organisasjon, i ett miljø. En delegering avsluttes ved at
  gyldigheten lukkes, ikke ved at innslaget fjernes, slik at historikken består.

  Datamodellen finnes og er i produksjonsløypa. Det som mangler er endringsflaten: i dag legges
  delegeringer inn manuelt av databaseforvaltningen, og ingen del av løsningen skriver til taket.

  # ÅPNE SPØRSMÅL:
  # - Skal taket for løsningens egne administrasjonsflater følge tilgangskatalogen automatisk,
  #   eller forvaltes manuelt som alle andre tak? Se designnotatet.
  # - Skal en organisasjon kunne be om en utvidelse den ikke selv kan utføre — fordi den mangler
  #   rettigheten i den andre av de to organisasjonene — eller er forespørselen en oppgave for
  #   support utenfor løsningen?

  Bakgrunn:
    Gitt jeg er innlogget i løsningen

  Regel: Endring krever applikasjonsadministrator i de organisasjonene endringen berører

    # Rettigheten er ikke en egen takrettighet, og den er ikke forbeholdt Sikt: det er den
    # ordinære applikasjonsadministratorrollen, skopet til organisasjonene man administrerer.
    # Det særegne for taket er at et innslag kan berøre TO organisasjoner — applikasjonens
    # eierorganisasjon, og organisasjonen innslaget gir applikasjonen lov til å opptre innenfor.
    # Når de to er forskjellige, kreves rollen i begge. Da kan verken eieren av en applikasjon
    # skaffe seg myndighet i en organisasjon de ikke administrerer, eller en administrator
    # utvide en annen parts applikasjon uten å ha ansvar for den.

    Scenario: Administrator for eierorganisasjonen legger til en delegering i samme organisasjon
      Gitt jeg er applikasjonsadministrator for organisasjonen som eier applikasjonen
      Når jeg legger til en delegering for applikasjonen med en tilgang, den samme organisasjonen og et miljø
      Så er delegeringen gyldig fra endringstidspunktet
      Og applikasjonen kan formidle tilgangen for brukere i den organisasjonen i det miljøet

    Scenario: Et innslag for en annen organisasjon krever rollen i begge organisasjonene
      Gitt jeg er applikasjonsadministrator for organisasjonen som eier applikasjonen
      Og jeg er applikasjonsadministrator for en annen organisasjon
      Når jeg legger til en delegering for applikasjonen i den andre organisasjonen
      Så er delegeringen gyldig fra endringstidspunktet
      Og applikasjonen kan formidle tilgangen for brukere i den andre organisasjonen

    Scenario: Rollen i bare den berørte organisasjonen er ikke nok
      Gitt jeg er applikasjonsadministrator for organisasjonen et takinnslag skal gjelde
      Og jeg er ikke applikasjonsadministrator for organisasjonen som eier applikasjonen
      Når jeg forsøker å legge til delegeringen
      Så avvises endringen
      Og det fremgår at endringen krever rettigheten i begge de berørte organisasjonene

    Scenario: Rollen i bare eierorganisasjonen er ikke nok for en annen organisasjon
      Gitt jeg er applikasjonsadministrator for organisasjonen som eier applikasjonen
      Og jeg er ikke applikasjonsadministrator for organisasjonen takinnslaget skal gjelde
      Når jeg forsøker å legge til delegeringen for den andre organisasjonen
      Så avvises endringen
      Og det fremgår at endringen krever rettigheten i begge de berørte organisasjonene

    Scenario: Uten rettigheten vises ingen endringshandlinger
      Gitt jeg kan lese delegeringstaket for en organisasjon jeg administrerer
      Og jeg er ikke applikasjonsadministrator for organisasjonen som eier applikasjonen
      Når jeg åpner delegeringstaket for applikasjonen
      Så ser jeg ingen handling for å legge til en delegering
      Og jeg ser ingen handling for å avslutte en delegering

    Scenario: Å avslutte en delegering krever den samme rettigheten som å legge den til
      Gitt en delegering gjelder for en applikasjon i en organisasjon og et miljø
      Og jeg mangler rettigheten i én av de organisasjonene endringen berører
      Når jeg forsøker å avslutte delegeringen
      Så avvises endringen
      Og delegeringen gjelder fortsatt

  Regel: En endring gjelder én tilgang, én organisasjon og ett miljø

    Scenario: Delegering i ett miljø gir ingen formidlingsevne i et annet
      Gitt jeg har rettighet til å endre delegeringstaket for en applikasjon
      Når jeg legger til en delegering for applikasjonen i testmiljøet
      Så kan applikasjonen formidle tilgangen i testmiljøet
      Og applikasjonen kan ikke formidle tilgangen i produksjonsmiljøet

    Scenario: Delegering i én organisasjon gir ingen formidlingsevne i en annen
      Gitt jeg har rettighet til å endre delegeringstaket for en applikasjon
      Når jeg legger til en delegering for applikasjonen i én organisasjon
      Så kan applikasjonen formidle tilgangen for brukere i den organisasjonen
      Og applikasjonen kan ikke formidle tilgangen for brukere i andre organisasjoner

    Scenario: Å legge til en delegering som allerede gjelder endrer ingenting
      Gitt jeg har rettighet til å endre delegeringstaket for en applikasjon
      Og en delegering gjelder allerede for applikasjonen i en organisasjon og et miljø
      Når jeg legger til den samme delegeringen på nytt
      Så er delegeringen fortsatt gyldig fra det opprinnelige tidspunktet
      Og historikken får ingen ny oppføring

    Scenario: Flere delegeringer kan legges til i én endring
      Gitt jeg har rettighet til å endre delegeringstaket for en applikasjon
      Når jeg legger til flere delegeringer for applikasjonen i samme endring
      Så er hver delegering gyldig fra endringstidspunktet
      Og det fremgår hvilke delegeringer som ble lagt til

    Scenario: Et innslag jeg mangler rettigheten for stopper hele endringen
      Gitt jeg har rettighet til å endre delegeringstaket for en applikasjon
      Og ett av innslagene jeg sender inn gjelder en organisasjon jeg ikke administrerer
      Når jeg forsøker å utføre endringen
      Så avvises endringen
      Og ingen av delegeringene er lagt til

  Regel: Taket trekkes tilbake ved å avslutte delegeringen

    Scenario: Avslutte en delegering
      Gitt jeg har rettighet til å endre delegeringstaket for en applikasjon
      Og en delegering gjelder for applikasjonen i en organisasjon og et miljø
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
      Gitt jeg har rettighet til å endre delegeringstaket for en applikasjon
      Og en delegering er allerede avsluttet
      Når jeg avslutter den samme delegeringen på nytt
      Så er utfallet uendret
      Og historikken får ingen ny oppføring

    Scenario: Endringen bekreftes med hvem den treffer
      Gitt jeg har rettighet til å endre delegeringstaket for en applikasjon
      Når jeg forsøker å avslutte en delegering
      Så får jeg se hvilken organisasjon, tilgang og hvilket miljø endringen gjelder
      Og jeg må bekrefte før endringen utføres

  Regel: Taket må følge tilgangskatalogen

    # Regelen kravene finnes for: en tilgang som skal brukes gjennom en applikasjon må også
    # ligge i applikasjonens delegeringstak, ellers finnes den ikke for en innlogget bruker.
    # Erfaring har vist at dette er lett å glemme, fordi snittet ikke gir noen feilmelding —
    # den nye tilgangen bare uteblir, og bare for brukere som går gjennom en applikasjon.

    Scenario: Ny tilgang som skal brukes gjennom en applikasjon krever et takinnslag
      Gitt jeg har rettighet til å endre delegeringstaket for en applikasjon
      Og en ny tilgang er innført i tilgangskatalogen
      Og tilgangen skal kunne brukes gjennom applikasjonen
      Når jeg ser applikasjonens delegeringstak
      Så fremgår det at taket ikke bærer den nye tilgangen
      Og jeg kan legge den inn for de organisasjonene og miljøene jeg har rettighet i

    @openquestion
    Scenario: Taket for løsningens egne administrasjonsflater følger katalogen
      # ÅPENT SPØRSMÅL: Skal taket for løsningens egen administrasjonsflate holdes i takt med
      # tilgangskatalogen automatisk, slik at en ny administrasjonstilgang virker med én gang,
      # eller skal også den forvaltes manuelt? Automatikk fjerner den vanligste feilklassen,
      # men gjør samtidig taket til noe som utvides uten en beslutning per gang.
      Gitt en ny tilgang for applikasjonsforvaltning er innført i tilgangskatalogen
      Når tilgangen tas i bruk i løsningens egen administrasjonsflate
      Så bærer flatens delegeringstak tilgangen for de organisasjonene og miljøene flaten dekker
