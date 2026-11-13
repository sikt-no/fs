# language: no
@OPT-SØK-SØK-021 @must @draft @ref-OPT-BEH-BEH-043
Egenskap: Søkerens kontaktopplysninger og målform
  Som søker
  ønsker jeg at opptak bruker kontaktopplysningene og målformen jeg har registrert i Kontakt- og reservasjonsregisteret (KRR)
  slik at jeg får meldinger, SMS og e-post på riktig sted og på målformen jeg foretrekker, uten å registrere det flere steder.

  # Kilder:
  # - Tina Lund Ravndal 10.11.2026: KRR brukes for SMS/e-post, reservasjon mot e-kommunikasjon og foretrukket målform.
  #   https://sikt-no.slack.com/archives/C0BVBHA9E2H/p1793969853950889
  # - Tina Lund Ravndal 13.11.2026: søkere uten KRR registrerer målform manuelt ved registrering av bruker, og søkere
  #   med KRR får målformen derfra. https://sikt-no.slack.com/archives/D0AL20V0L6Q/p1794563089173179
  # - Kjetil Røse Høybråten 13.11.2026: gjelder ikke bare egenregistrerte brukere, men også en del ID-porten-brukere.
  #
  # I dag synkroniserer opptak e-post, mobilnummer og reservasjon fra KRR hver 30. dag (KrrSyncTask i fs-plattform),
  # men henter ikke målform, og viser ikke opplysningene for søkeren i Min kompetanse.
  # Planen for ID-porten i Min kompetanse (fs-plattform !6503) har «KRR-henting ved innlogging» som ikke med.
  # KRR har ikke personer uten fødselsnummer (selvregistrert med e-post og eIDAS, TIL-PÅL-PÅL-006 i sikt-no/fs#894).
  # Registreringen av søkeren står i OPT-SØK-SØK-020 (bli_søker.feature) i sikt-no/fs#965. Ingen av dem er på main.
  # Saksbehandlerens visning av kontaktinformasjonen står i OPT-BEH-BEH-043 (se_søknaden_til_en_søker.feature).
  # Svarer til HK-9433 (innhenting og informasjon om personopplysninger for ID-porten-søker).

  @openquestion
  Regel: Kontaktopplysningene og målformen hentes fra KRR når søkeren logger inn
    # ÅPNE SPØRSMÅL:
    # - Hvor ferske må opplysningene være når SMS og e-post sendes til søkere som ikke har logget inn nylig?
    #   I dag synkroniseres de hver 30. dag. FS-klienten slår i tillegg opp i KRR ved utsending.


    Scenario: Søkeren som finnes i KRR, får kontaktopplysningene og målformen fra KRR
      Gitt at søkeren finnes i KRR med målform nynorsk
      Når søkeren logger inn i Min kompetanse
      Så er søkeren registrert med målformen nynorsk
      Og søkeren er registrert med e-postadressen og mobilnummeret fra KRR
      Og søkeren er registrert med reservasjonen mot elektronisk kommunikasjon fra KRR

    Scenario: Endringer i KRR gjelder fra neste innlogging
      Gitt at søkeren er registrert med målformen bokmål fra KRR
      Og at søkeren har endret målformen til nynorsk i KRR
      Når søkeren logger inn i Min kompetanse
      Så er søkeren registrert med målformen nynorsk

  Regel: Søkeren som finnes i KRR, endrer kontaktopplysningene og målformen i KRR

    Scenario: Søkeren i KRR velger ikke målform selv
      Gitt at søkeren finnes i KRR
      Når søkeren ser på kontaktopplysningene og målformen sin i Min kompetanse
      Så ser søkeren målformen og kontaktopplysningene fra KRR
      Og søkeren ser ikke muligheten til å endre målformen eller kontaktopplysningene
      Og søkeren ser hvordan målformen og kontaktopplysningene endres i KRR

  @openquestion
  Regel: Søkeren som ikke finnes i KRR, velger målform ved registrering
    # ÅPNE SPØRSMÅL:
    # - Søkere med fødselsnummer (ID-porten, Feide) som ikke finnes i KRR, har ikke noe registreringssteg i
    #   OPT-SØK-SØK-020 (#965). Hvor velger de målform?
    # - Er målform et obligatorisk felt ved registrering, eller har den en standardverdi?
    #
    # AVKLART (Tina Lund Ravndal 13.11.2026): valgene er bokmål og nynorsk. Engelsk er ikke et valg i de samordna
    # opptakene, og samisk trengs ikke.

    Scenario: Søkeren som ikke finnes i KRR, velger målform ved registrering
      Gitt at søkeren ikke finnes i KRR
      Når søkeren registrerer seg som søker
      Så må søkeren velge målform

    Scenario: Målformene søkeren kan velge
      Gitt at søkeren ikke finnes i KRR
      Når søkeren velger målform ved registrering
      Så kan søkeren velge mellom målformene:
        | Målform |
        | Bokmål  |
        | Nynorsk |

  @openquestion
  Regel: Søkeren som ikke finnes i KRR, kan endre målformen og kontaktopplysningene
    # ÅPNE SPØRSMÅL:
    # - Registrerer søkeren uten KRR e-postadresse og mobilnummer selv, ved registrering eller senere?
    # - Skal søkeren uten KRR kunne reservere seg mot elektronisk kommunikasjon?

    Scenario: Søkeren endrer målformen søkeren valgte ved registrering
      Gitt at søkeren ikke finnes i KRR
      Og at søkeren valgte målformen bokmål ved registrering
      Når søkeren endrer målformen til nynorsk
      Så er søkeren registrert med målformen nynorsk

    Scenario: Søkeren som senere finnes i KRR, får målformen fra KRR
      Gitt at søkeren valgte målformen bokmål ved registrering
      Og at søkeren senere er registrert i KRR med målform nynorsk
      Når søkeren logger inn i Min kompetanse
      Så er søkeren registrert med målformen nynorsk
      Og søkeren ser ikke muligheten til å endre målformen
