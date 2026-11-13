# language: no
@FLY-OPT-TID-001 @must @draft @e2e
Egenskap: Behandle søknad om tidlig opptak
  Fra søkeren har sendt inn søknaden og søkt om tidlig opptak, til søkeren har fått tilbudsgaranti
  fra tidligopptaket, eller tilbyderen har satt en tilbudsgaranti for tidlig opptak. Søknaden fordeles
  til forvalteren, tilbyderen og behandleren som i «Fra søknad til lærestedet» (FLY-OPT-SØK-001).
  Søkeren søker om tidlig opptak med en begrunnelse. Når søkeren har søkt om tidlig opptak, er det
  første steget i saksbehandlingen at saksbehandleren hos behandleren vurderer om søkeren har grunn
  for tidlig opptak. Søknaden om opptak behandles på vanlig måte, som i flytene for automatisk og
  manuell saksbehandling. Er søkeren kvalifisert, men kan ikke poengberegnes, setter tilbyderen en
  tilbudsgaranti for tidlig opptak som gir eller ikke gir tilbud. Til slutt gjennomfører
  opptaksforvalteren tidligopptaket, og søkerne som deltar, er kvalifisert og når poenggrensen,
  får tilbudsgaranti.
  # Ikke med: publiseringen av svaret (OPT-BEH-BEH-014), svaret i Min kompetanse (OPT-SØK-SØK-012)
  # og tilbudet i hovedopptaket.
  # ÅPNE SPØRSMÅL:
  # - Skal fasene ha ankre (@ref-FLY-OPT-TID-001) på reglene de bygger på i kravene? Nå står
  #   regeltitlene i «…» under taggene.

  Bakgrunn:
    Gitt at "Sykepleie, høst 2027" tilbyr tidlig opptak med poenggrense 50

  @depends-on-FLY-OPT-SØK-001
  # FLY-OPT-SØK-001: «Søknadsalternativene fordeles til behandleren når søknaden sendes inn»
  Regel: Søknaden fordeles til behandleren når søkeren sender den inn

    Scenario: Søknaden med et søknadsalternativ som tilbyr tidlig opptak blir en sak hos behandleren
      Gitt at søknaden har søknadsalternativet "Sykepleie, høst 2027"
      Når søkeren sender inn søknaden
      Så har søknaden en sak hos behandleren

  @depends-on-OPT-SØK-SØK-011
  # OPT-SØK-SØK-011: «Søkeren ber om tidlig opptak etter at søknaden er sendt», «Søkeren kan søke om tidlig opptak når opptaket tilbyr det», «Søkeren velger én begrunnelse fra opptakets liste»
  Regel: Søkeren søker om tidlig opptak med en begrunnelse

    Scenario: Saksbehandleren ser begrunnelsen søkeren har søkt om tidlig opptak med
      Gitt at søkeren har sendt inn søknaden med "Sykepleie, høst 2027"
      Når søkeren søker om tidlig opptak med begrunnelsen "Fullført videregående opplæring"
      Så ser saksbehandleren hos behandleren at søkeren har søkt om tidlig opptak
      Og saksbehandleren ser begrunnelsen "Fullført videregående opplæring"

  @depends-on-OPT-BEH-BEH-009 @depends-on-OPT-BEH-BEH-013
  # OPT-BEH-BEH-009: «Søk og filtrering av saker på tidlig opptak»
  # OPT-BEH-BEH-013: «Saksbehandler ser søkerens grunnlag for tidlig opptak», «Saksbehandler konkluderer om søkeren deltar i tidligopptaket»
  Regel: Saksbehandleren vurderer søknaden om tidlig opptak først
    # Når søkeren har søkt om tidlig opptak, er dette det første steget i saksbehandlingen.

    Scenario: Saksbehandleren finner sakene som mangler konklusjon for tidlig opptak
      Gitt at søkeren har søkt om tidlig opptak
      Når saksbehandleren hos behandleren filtrerer på saker der konklusjonen for tidlig opptak mangler
      Så finner saksbehandleren saken

    Scenariomal: Saksbehandleren konkluderer om søkeren har grunn for tidlig opptak
      Gitt at søkeren har søkt om tidlig opptak med begrunnelsen "Fullført videregående opplæring"
      Når saksbehandleren hos behandleren konkluderer med "<konklusjon>"
      Så <deltar> søkeren i tidligopptaket

      Eksempler:
        | konklusjon                                     | deltar      |
        | KFF – Kan få tidlig opptak, har godkjent grunn | deltar      |
        | KIF – Kan ikke få tidlig opptak, mangler grunn | deltar ikke |

  @depends-on-FLY-OPT-AUT-001 @depends-on-FLY-OPT-DOK-001 @depends-on-FLY-OPT-FLE-001 @depends-on-FLY-OPT-MAN-001 @openquestion
  Regel: Søknaden om opptak behandles på vanlig måte
    # Behandlingen er den samme som for søkere som ikke har søkt om tidlig opptak. Hvilken av
    # flytene som gjelder, avhenger av vitnemålet og dokumentasjonen søkeren har.
    # ÅPNE SPØRSMÅL:
    # - Scenarioet er generelt, fordi flytene for automatisk og manuell saksbehandling viser
    #   detaljene. Skal steget «eller saken har en mangel» bli stående, eller skal scenarioet
    #   bare si at saken er ferdig behandlet og søkeren kvalifisert?

    Scenario: Saken er ferdig behandlet når søkeren har søkt om tidlig opptak
      Gitt at søkeren har søkt om tidlig opptak
      Når saken behandles på vanlig måte
      Så har saken behandlingsstatusen "Behandlet"
      Og søkeren er kvalifisert til "Sykepleie, høst 2027", eller saken har en mangel

  @depends-on-OPT-BEH-BEH-010 @openquestion
  # OPT-BEH-BEH-010: «Saksbehandler, tilbyder og opptaksforvalter kan sette tilbudsgaranti manuelt»
  Regel: Tilbyderen setter tilbudsgaranti for tidlig opptak når søkeren ikke kan poengberegnes
    # At tilbyderen bare gir tilbudsgaranti for tidlig opptak til søkere med godkjent grunn, er
    # praksis, ikke en regel i systemet (avklart 12.10.2026, se OPT-BEH-BEH-007).
    # ÅPNE SPØRSMÅL:
    # - I dagens løsning er typene FOP og FAL. Er FOP en tilbudsgaranti for tidlig opptak som gir
    #   tilbud, og FAL en som ikke gir tilbud? Kravene nevner FAL bare som en kode.

    Scenariomal: Tilbyderen setter en tilbudsgaranti for tidlig opptak som <utfall>
      Gitt at søkeren deltar i tidligopptaket
      Og at søkeren er kvalifisert til "Sykepleie, høst 2027"
      Og at søknaden ikke kan poengberegnes
      Når saksbehandleren hos tilbyderen setter en tilbudsgaranti for tidlig opptak som <utfall> på "Sykepleie, høst 2027"
      Så har søkeren en tilbudsgaranti for tidlig opptak som <utfall> på "Sykepleie, høst 2027"

      Eksempler:
        | utfall          |
        | gir tilbud      |
        | ikke gir tilbud |

  @depends-on-OPT-BEH-BEH-007
  # OPT-BEH-BEH-007: «Opptaksforvalter gjennomfører tidligopptaket»
  Regel: Opptaksforvalteren gjennomfører tidligopptaket

    Scenario: Søkeren som deltar og når poenggrensen, får tilbudsgaranti
      Gitt at søkeren deltar i tidligopptaket
      Og at saken har behandlingsstatusen "Behandlet"
      Og at søkeren er kvalifisert til "Sykepleie, høst 2027"
      Og at søkeren har 55 poeng til "Sykepleie, høst 2027"
      Når opptaksforvalteren gjennomfører tidligopptaket
      Så får søkeren tilbudsgaranti på "Sykepleie, høst 2027"

    Scenario: Tidligopptakstilbudet fra tilbyderen står når tidligopptaket gjennomføres
      Gitt at søknaden ikke kan poengberegnes
      Og at tilbyderen har gitt tidligopptakstilbud på "Sykepleie, høst 2027"
      Når opptaksforvalteren gjennomfører tidligopptaket
      Så har søkeren fortsatt tidligopptakstilbud på "Sykepleie, høst 2027"
