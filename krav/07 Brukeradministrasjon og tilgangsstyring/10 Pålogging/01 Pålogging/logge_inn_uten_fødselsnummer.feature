# language: no
# GitHub: #262, #40, #82
@TIL-PÅL-PÅL-006 @must @draft @depends-on-TIL-PÅL-PÅL-002
Egenskap: Logge inn i Min kompetanse uten fødselsnummer
  Som en søker uten norsk eID eller norsk fødselsnummer
  ønsker jeg å logge inn i Min kompetanse
  slik at jeg kan søke opptak, som søkere med norsk eID.

  # Kilde: beslutning 1.11.2026 (BAT-404). Søkeren logger inn gjennom ID-porten hos Digdir, med den samme klienten
  # som Min kompetanse bruker for ID-porten (TIL-PÅL-PÅL-002), ikke via Feide (beslutning 22.09.2026). Det finnes to måter:
  # - selvregistrert bruker med e-post (acr «selfregistered-email» hos Digdir)
  # - eIDAS, europeisk eID (acr «eidas-loa-substantial»)
  # Sikt har ingen egen identitetsleverandør for søkere uten norsk eID.
  # Ingen av innloggingene gir fødselsnummer. Om e-postadressen kommer med fra ID-porten, er ikke dokumentert.
  # Det testes i BAT-400 (#82).
  # Innlogging og søknad uten fødselsnummer hører til samme milepæl, med akseptansetest 18.12.2026.
  # Svarer til HK-9432 (alternativ innlogging som søker). Se også HK-10841 (redigere personopplysninger på en
  # selvregistrert søker), HK-9282 (elektronisk identifikasjon) og HK-9392 (sikker og brukervennlig innlogging).
  # #40 viste til en fil egenopprettet_bruker_pålogging.feature. Kravet står her.
  # Når personen senere får norsk eID, skal søkerprofilene kunne slås sammen (#565). Sammenslåingen spesifiseres
  # ikke her, men det søkeren uten fødselsnummer identifiseres med, må ikke hindre den.

  Regel: Søkeren uten norsk eID velger «Logg inn uten fødselsnummer»

    @openquestion
    Scenario: Søkeren velger å logge inn uten fødselsnummer
      # ÅPNE SPØRSMÅL:
      # - Velger søkeren mellom e-post og eIDAS i Min kompetanse, eller i ID-porten?
      Gitt at søkeren er på innloggingssiden til Min kompetanse
      Når søkeren velger «Logg inn uten fødselsnummer»
      Så sendes søkeren til ID-porten for innlogging uten norsk eID

  Regel: Søkeren kan logge inn med e-post eller med eIDAS

    Scenariomal: Søkeren logger inn med <innloggingsmåte>
      Gitt at søkeren har valgt «Logg inn uten fødselsnummer»
      Når søkeren logger inn i ID-porten med <innloggingsmåte>
      Så er søkeren innlogget i Min kompetanse
      Og søkeren er innlogget uten fødselsnummer

      Eksempler:
        | innloggingsmåte                  |
        | e-post som selvregistrert bruker |
        | eIDAS                            |

    @openquestion
    Scenario: Søkeren logger inn med eIDAS og finnes i Folkeregisteret
      # ÅPNE SPØRSMÅL:
      # - Ifølge Digdir kan ID-porten gi fødselsnummer ved eIDAS-innlogging når personen finnes i Folkeregisteret.
      #   Skal søkeren da regnes som søker med fødselsnummer, eller som søker uten fødselsnummer?
      Gitt at søkeren har valgt «Logg inn uten fødselsnummer»
      Og at søkeren finnes i Folkeregisteret
      Når søkeren logger inn i ID-porten med eIDAS
      Så er søkeren innlogget i Min kompetanse

  Regel: Første innlogging oppretter søkeren

    Scenariomal: Søkeren logger inn med <innloggingsmåte> for første gang
      Gitt at søkeren ikke har logget inn i Min kompetanse før
      Når søkeren logger inn i ID-porten med <innloggingsmåte>
      Så er søkeren opprettet som søker i opptak
      Og søkeren er ikke registrert med fødselsnummer

      Eksempler:
        | innloggingsmåte                  |
        | e-post som selvregistrert bruker |
        | eIDAS                            |

  @openquestion
  Regel: Senere innlogginger finner den samme søkeren
    # ÅPNE SPØRSMÅL:
    # - Hva identifiserer søkeren uten fødselsnummer i opptak: subjekt-ID-en fra tilgangsstyringen (BAT-262),
    #   eller utstederen og sub fra ID-porten? Svaret avgjør hva «den samme søkeren» betyr i scenarioene under.
    # - Er det samme søker når personen bytter e-postadresse hos ID-porten?
    # - Er det samme søker når personen logger inn én gang med e-post og en annen gang med eIDAS?

    Scenariomal: Søkeren logger inn igjen med <innloggingsmåte>
      Gitt at søkeren har logget inn i Min kompetanse med <innloggingsmåte> før
      Og at søkeren har en påbegynt søknad
      Når søkeren logger inn i ID-porten med <innloggingsmåte>
      Så er søkeren den samme søkeren som ved forrige innlogging
      Og søkeren ser den påbegynte søknaden

      Eksempler:
        | innloggingsmåte                  |
        | e-post som selvregistrert bruker |
        | eIDAS                            |

  @depends-on-OPT-SØK-SØK-001
  Regel: Søkeren uten fødselsnummer kan søke opptak
    # Søknaden sendes som for andre søkere (OPT-SØK-SØK-001). Saksbehandleren trenger ikke opprette søknaden
    # for søkeren (OPT-SØK-SØK-002).

    Scenario: Søkeren uten fødselsnummer sender inn en søknad
      Gitt at søkeren er innlogget i Min kompetanse uten fødselsnummer
      Når søkeren sender inn en søknad til et opptak
      Så får søkeren se en kvittering på at søknaden er mottatt

  Regel: Søkeren uten fødselsnummer får de samme tilgangene som søkere innlogget med ID-porten
    # Tilgangene er gulvet snittet med taket til Min kompetanse, som ved innlogging med ID-porten gjennom
    # Min kompetanse (TIL-PÅL-PÅL-002). Søkeren får ikke bare de åpne rollene.

    Scenario: Søkeren uten fødselsnummer får tilgangene til Min kompetanse
      Gitt at søkeren er innlogget i Min kompetanse uten fødselsnummer
      Når søkeren bruker Min kompetanse
      Så har søkeren de samme tilgangene som en søker innlogget med ID-porten gjennom Min kompetanse

    Scenario: Tilgangsstyringen lagrer ikke fødselsnummer for søkeren
      Gitt at søkeren har logget inn i Min kompetanse uten fødselsnummer
      Når søkeren bruker Min kompetanse
      Så er det ikke lagret noe fødselsnummer for søkeren i tilgangsstyringen

  @openquestion
  Regel: Personopplysningene til søkeren uten fødselsnummer
    # ÅPNE SPØRSMÅL:
    # - Hvilke personopplysninger registrerer søkeren selv ved første innlogging? HK-9432 lister navn, fødselsdato,
    #   kjønn, telefonnummer og e-postadresse som obligatoriske, og postadresse som valgfri.
    # - Hvilke personopplysninger kommer fra ID-porten? Ifølge Digdir gir eIDAS navn og fødselsdato. Om e-postadressen
    #   kommer med ved innlogging med e-post, testes i BAT-400 (#82).
    # - Kan søkeren endre personopplysningene sine etterpå, og hvilke?
    # - HK-10841: Skal forvalteren kunne redigere personopplysningene til en selvregistrert søker, og hvor hører det
    #   kravet hjemme (05 Opplysninger om person)?
