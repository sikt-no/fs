# language: no
@OPT-BEH-BEH-033 @must @draft @ref-OPT-BEH-BEH-011 @ref-OPT-BEH-BEH-030
Egenskap: Kjøre jobbene i opptak
  Som opptaksforvalter
  ønsker jeg at jobbene i opptaket kjører av seg selv
  slik at søknadene blir fordelt, vitnemålene importert og sakene behandlet uten at noen starter det.

  Tre jobber kjører fast i opptaket: saksbehandlertildelingen, importen av VGS-vitnemål fra KREG
  og jobben for nye vitnemål. En jobbplanlegger starter jobbene. Hvor ofte hver jobb kjører, står
  i oppsettet av systemet. Ingen bruker endrer det i FS Admin. Feiler en jobb for en søker,
  prøver neste kjøring igjen. Driften får alarm når en jobb feiler. Opptaksforvalteren ser i
  FS Admin når jobbene kjørte sist, og hvilke søkere de har feilet for.

  # Jobben for nye vitnemål står i OPT-BEH-BEH-032 (PR #862). Den er en annen jobb enn importen.
  # Kode i dag: saksbehandlertildelingen kjører som en jobb. Vitnemålene hentes fra KREG etter
  # tildelingen, og en feil blir ikke prøvd igjen. Det finnes ingen jobb for nye vitnemål.

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" forvaltes av HK-dir

  Regel: Jobbplanleggeren starter jobbene i opptaket

    Scenariomal: Jobbplanleggeren starter <jobb>
      Gitt at <jobb> er satt opp i jobbplanleggeren
      Når det er tid for neste kjøring av <jobb>
      Så starter jobbplanleggeren <jobb>

      Eksempler:
        | jobb                              |
        | saksbehandlertildelingen          |
        | importen av VGS-vitnemål fra KREG |
        | jobben for nye vitnemål           |

  Regel: Hvor ofte en jobb kjører, står i oppsettet av systemet

    Scenario: Jobben kjører så ofte som oppsettet sier
      Gitt at oppsettet av systemet sier hvor ofte importen av VGS-vitnemål fra KREG kjører
      Når tiden i oppsettet har gått siden forrige kjøring
      Så starter jobbplanleggeren importen av VGS-vitnemål fra KREG

    Scenario: Opptaksforvalteren endrer ikke hvor ofte jobben kjører
      Når opptaksforvalteren ved HK-dir ser på jobbene i "Samordna opptak 2027"
      Så kan opptaksforvalteren ikke endre hvor ofte jobbene kjører

  @openquestion
  Regel: Jobbene kjører så lenge opptaket er i gang
    # ÅPNE SPØRSMÅL:
    # - Når slutter jobbene å kjøre for et opptak? FLY-OPT-VIT-001 sier at importen gjelder
    #   opptak som ikke er avsluttet. OPT-BEH-BEH-032 sier at automatikken kjører så lenge det
    #   kan opprettes saker i opptaket.

    Scenario: Jobbene kjører ikke for et avsluttet opptak
      Gitt at "Samordna opptak 2026" er avsluttet
      Når jobbplanleggeren starter importen av VGS-vitnemål fra KREG
      Så importeres ingen vitnemål for søknadene i "Samordna opptak 2026"

  @openquestion
  Regel: Neste kjøring prøver igjen for søkeren jobben feilet for
    # ÅPNE SPØRSMÅL:
    # - Fortsetter jobben med de andre søkerne når den feiler for én søker?

    Scenario: Importen prøver igjen ved neste kjøring
      Gitt at importen av VGS-vitnemål fra KREG feilet for "Kari Nordmann" fordi KREG ikke svarte
      Når importen kjører neste gang
      Så prøver importen å importere vitnemålene til "Kari Nordmann" igjen

    Scenario: Søkeren er importert når KREG svarer igjen
      Gitt at importen har feilet for "Kari Nordmann" tre ganger
      Og at KREG svarer igjen
      Når importen kjører neste gang
      Så er vitnemålene til "Kari Nordmann" importert

  @openquestion
  Regel: Driften får alarm når en jobb feiler
    # ÅPNE SPØRSMÅL:
    # - Får driften alarm for hver feil, eller først når samme søker har feilet flere ganger?

    Scenario: Driften får alarm når importen feiler
      Gitt at KREG ikke svarer
      Når importen av VGS-vitnemål fra KREG kjører
      Så får driften en alarm om at importen har feilet

  @openquestion
  Regel: Opptaksforvalteren ser status for jobbene i opptaket
    # ÅPNE SPØRSMÅL:
    # - Ser opptaksforvalteren ved en deltakende organisasjon også status for jobbene?

    Scenario: Opptaksforvalteren ser når jobben kjørte sist
      Gitt at importen av VGS-vitnemål fra KREG kjørte sist 29.10.2026 kl. 10.15
      Når opptaksforvalteren ved HK-dir ser på jobbene i "Samordna opptak 2027"
      Så ser opptaksforvalteren at importen kjørte sist 29.10.2026 kl. 10.15

    Scenario: Opptaksforvalteren ser søkerne jobben har feilet for
      Gitt at importen av VGS-vitnemål fra KREG feilet for "Kari Nordmann" fordi KREG ikke svarte
      Når opptaksforvalteren ved HK-dir ser på jobbene i "Samordna opptak 2027"
      Så ser opptaksforvalteren at importen har feilet for "Kari Nordmann"

  @openquestion
  Regel: Opptaksforvalteren starter en jobb uten å vente på neste kjøring
    # ÅPNE SPØRSMÅL:
    # - Skal opptaksforvalteren kunne starte en jobb med en gang? Saksbehandleren og
    #   opptaksforvalteren kan starte den automatiske behandlingen for saker (OPT-BEH-BEH-032).

    Scenario: Opptaksforvalteren starter importen med en gang
      Når opptaksforvalteren ved HK-dir starter importen av VGS-vitnemål fra KREG
      Så starter importen uten å vente på neste kjøring
