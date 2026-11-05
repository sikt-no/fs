# language: no
@OPT-BEH-BEH-033 @must @planned @scope-automatisk-import-og-start @ref-OPT-BEH-BEH-011 @ref-OPT-BEH-BEH-030 @ref-OPT-BEH-BEH-032 @ref-OPT-BEH-BEH-038
Egenskap: Kjøre jobbene i opptak
  Som opptaksforvalter
  ønsker jeg at jobbene i opptaket kjører av seg selv
  slik at søknadene blir fordelt, vitnemålene importert og sakene behandlet uten at noen starter det.

  Tre jobber kjører fast i opptaket: saksbehandlertildelingen, importen av VGS-vitnemål fra
  KREG og importen av resultater fra høyere utdanning, som hentes fra en annen tjeneste enn KREG
  (OPT-BEH-BEH-038). Har importen fra KREG hentet vitnemålene til en søker som ikke hadde
  vitnemål, starter den automatiske behandlingen (OPT-BEH-BEH-032). En jobbplanlegger starter
  jobbene. Hvor ofte hver jobb kjører, står i applikasjonsinnstillingene. Ingen bruker endrer det
  i FS Admin. Feiler en jobb for en søker fordi KREG ikke svarer, prøves den på nytt. Hvor mange
  ganger, og hvor lenge, står også i applikasjonsinnstillingene. Feilen skrives i
  applikasjonsloggen, og Sikt får et varsel. Saksbehandleren ser ikke tekniske feil.

  # Avklart med domeneeksperten 29.10.2026: to jobber dekker alt. Tekniske feil vises ikke for
  # brukerne, men skrives i applikasjonsloggen, og Sikt får et varsel. Hvordan det fremgår at
  # jobbene kjører, avklares senere.
  # Kode i dag: saksbehandlertildelingen kjører som en jobb. Vitnemålene hentes fra KREG etter
  # tildelingen, og en feil blir ikke prøvd igjen. Det finnes ingen jobb som importerer nye
  # vitnemål fra KREG.
  # Avklart 04.11.2026: resultatene fra høyere utdanning hentes fra en annen tjeneste enn KREG,
  # med en egen jobb. Det erstatter at to jobber dekker alt.
  # ÅPNE SPØRSMÅL:
  # - Hva heter tjenesten for resultater fra høyere utdanning?

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" forvaltes av HK-dir
    Og at "Universitetet i Oslo" deltar i opptaket

  @ref-FLY-OPT-VIT-001
  Regel: Jobbplanleggeren starter jobbene i opptaket

    Scenariomal: Jobbplanleggeren starter <jobb>
      Gitt at <jobb> er satt opp i jobbplanleggeren
      Når det er tid for neste kjøring av <jobb>
      Så starter jobbplanleggeren <jobb>

      Eksempler:
        | jobb                                        |
        | saksbehandlertildelingen                    |
        | importen av VGS-vitnemål fra KREG           |
        | importen av resultater fra høyere utdanning |

  @openquestion
  Regel: Hvor ofte en jobb kjører, står i applikasjonsinnstillingene
    # Importen av VGS-vitnemål fra KREG gjør ett oppslag i KREG per aktiv søker hver gang den
    # kjører. Vi har dialog med KREG-teamet om belastningen (30.10.2026).
    # Avklart 05.11.2026: KREG synkroniseres med Nasjonal vitnemålsdatabase (NVB) bare én gang i
    # døgnet, i en nattjobb. Importen trenger derfor ikke kjøre oftere enn én gang i døgnet.
    # Avklart 05.11.2026: opptaksforvalteren starter ikke jobbene selv. Har KREG vært nede, holder
    # det at importen kjører neste natt.
    # ÅPNE SPØRSMÅL:
    # - Holder det å kjøre importen én gang i døgnet, etter nattjobben i KREG, eller må den kjøre
    #   oftere for annulleringer? Belastningen testes med KREG-teamet.

    Scenario: Jobben kjører så ofte som applikasjonsinnstillingene sier
      Gitt at applikasjonsinnstillingene sier hvor ofte importen av VGS-vitnemål fra KREG kjører
      Når tiden i applikasjonsinnstillingene har gått siden forrige kjøring
      Så starter jobbplanleggeren importen av VGS-vitnemål fra KREG

    Scenario: Opptaksforvalteren endrer ikke hvor ofte jobben kjører
      Når opptaksforvalteren ved HK-dir ser på jobbene i "Samordna opptak 2027"
      Så kan opptaksforvalteren ikke endre hvor ofte jobbene kjører

  Regel: Jobbene kjører så lenge opptaket er i gang
    # Avklart 2026-11-03 (OPT-BEH-BEH-032): hendelsene for den automatiske saksbehandlingen gjelder
    # ikke jobbene. Jobbene kjører til opptaket er avsluttet.

    Scenario: Jobbene kjører ikke for et avsluttet opptak
      Gitt at "Samordna opptak 2026" er avsluttet
      Når jobbplanleggeren starter importen av VGS-vitnemål fra KREG
      Så importeres ingen vitnemål for søknadene i "Samordna opptak 2026"

  @ref-OPT-BEH-BEH-030
  Regel: En søker jobben feilet for, prøves på nytt

    Scenario: Vitnemålene importeres når KREG svarer igjen
      Gitt at importen av VGS-vitnemål fra KREG feilet for "Kari Nordmann" fordi KREG ikke svarte
      Når KREG svarer igjen innenfor tiden i applikasjonsinnstillingene
      Så er vitnemålene til "Kari Nordmann" importert

  Regel: Jobben fortsetter med de andre søkerne når den feiler for én søker

    Scenario: Importen fortsetter med de andre søkerne når den feiler for én søker
      Gitt at importen av VGS-vitnemål fra KREG feiler for "Kari Nordmann"
      Og at "Ola Nordmann" har fått et vitnemål i KREG som ikke er importert
      Når importen av VGS-vitnemål fra KREG kjører
      Så er vitnemålet til "Ola Nordmann" importert

  Regel: Tekniske feil skrives i applikasjonsloggen, og Sikt får et varsel
    # Avklart 05.11.2026: Sikt får ett samlet varsel per kjøring, ikke ett per søker. Er KREG
    # nede, kan importen feile for titusenvis av søkere i hovedopptaket.

    Scenario: Sikt får ett varsel per kjøring når importen feiler
      Gitt at KREG ikke svarer
      Når importen av VGS-vitnemål fra KREG kjører
      Så er feilen for hver søker skrevet i applikasjonsloggen
      Og Sikt får ett varsel med antall søkere importen feilet for

    Scenario: Saksbehandleren ser ikke tekniske feil
      Gitt at importen av VGS-vitnemål fra KREG feilet for "Kari Nordmann" fordi KREG ikke svarte
      Når saksbehandleren ved Universitetet i Oslo åpner saken til "Kari Nordmann"
      Så ser saksbehandleren ingen feilmelding om KREG på saken

  @draft @openquestion
  Regel: Det fremgår at jobbene kjører
    # ÅPNE SPØRSMÅL:
    # - Hvordan, og for hvem, det fremgår at jobbene kjører? Avklart 29.10.2026 at det tas
    #   senere.
    # - Ser opptaksforvalteren ved en deltakende organisasjon også status for jobbene?

    Scenario: Opptaksforvalteren ser når jobben kjørte sist
      Gitt at importen av VGS-vitnemål fra KREG kjørte sist 29.10.2026 kl. 10.15
      Når opptaksforvalteren ved HK-dir ser på jobbene i "Samordna opptak 2027"
      Så ser opptaksforvalteren at importen kjørte sist 29.10.2026 kl. 10.15
