# language: no
# GitHub: #595
# Jira: SHI-709
@OPT-OPT-UTD-003 @must @in-progress @scope-utdanningstilbud-2027 @ref-OPT-OPT-UTD-006
Egenskap: Trekke utdanningstilbud fra opptak
  Som opptaksforvalter
  ønsker jeg å kunne trekke utdanningstilbud fra opptaket
  slik at utdanninger som ikke lenger skal ha opptak blir håndtert riktig.

  # Trekkfristen settes av opptakseier (#595).
  # Når en utdanningsinstans deaktiveres i utdanningsregisteret, får opptaksforvalter beskjed om at
  # utdanningstilbudet kan trekkes.
  # AVKLART 2026-10-22: Før opptaket åpner for søknad fjernes utdanningstilbud i stedet for å trekkes,
  # se fjerne_utdanningstilbud.feature.

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at opptaket "Samordna opptak 2027" har utdanningstilbud

  Regel: Opptaksforvalter ved deltakende organisasjon eller forvaltende organisasjon kan trekke utdanningstilbud

    @openquestion
    Scenario: Opptaksforvalter ved deltakende organisasjon trekker utdanningstilbud organisasjonen tilbyr
      # ÅPNE SPØRSMÅL:
      # - Delvis levert (verify 2026-10-22): fs-plattform lar deltakende organisasjon trekke bare mens redigeringen er åpen, mens fs-admin viser trekk-knappen bare for forvaltende organisasjon og bare når redigeringen er stengt. Når skal deltakende organisasjon kunne trekke, og skal fs-admin og fs-plattform endres?
      Gitt at opptaksforvalter er ved en deltakende organisasjon
      Når opptaksforvalter velger å trekke utdanningstilbudet "Sykepleie, høst 2027"
      Så varsles opptaksforvalter om konsekvensen av å trekke
      Og utdanningstilbudet trekkes fra opptaket

    @implemented
    Scenario: Opptaksforvalter ved forvaltende organisasjon trekker utdanningstilbud
      Gitt at opptaksforvalter er ved forvaltende organisasjon
      Når opptaksforvalter velger å trekke utdanningstilbudet "Sykepleie, UiO, høst 2027"
      Så varsles opptaksforvalter om konsekvensen av å trekke
      Og utdanningstilbudet trekkes fra opptaket

    @implemented
    Scenario: Deltakende organisasjon kan ikke trekke utdanningstilbud en annen organisasjon tilbyr
      # Jira: SHI-747
      Gitt at opptaksforvalter er ved deltakende organisasjon "Universitetet i Oslo"
      Når det sendes en forespørsel om å trekke utdanningstilbudet "Vernepleie, høst 2027", som "Universitetet i Bergen" tilbyr
      Så avvises forespørselen
      Og utdanningstilbudet "Vernepleie, høst 2027" er ikke trukket

  Regel: Utdanningstilbud som trekkes etter søknadsåpning, blir liggende på opptaket

    @openquestion
    Scenario: Trekke utdanningstilbud etter søknadsåpning
      # ÅPNE SPØRSMÅL:
      # - Delvis levert (verify 2026-10-22): utdanningstilbudet blir liggende på opptaket, markert som trukket, men fs-plattform krever at opptaket er publisert, og fs-admin viser trekk-knappen når redigeringen er stengt, ikke ut fra søknadsåpningen. Skal muligheten til å trekke styres av søknadsåpningen?
      Gitt at opptaket har åpnet for søknad
      Når opptaksforvalter velger å trekke utdanningstilbudet "Sykepleie, høst 2027"
      Så varsles opptaksforvalter om konsekvensen av å trekke
      Og utdanningstilbudet "Sykepleie, høst 2027" blir liggende på opptaket, markert som trukket

    @draft @openquestion
    # ÅPNE SPØRSMÅL:
    # - Hva skal skje med søkere som har søkt på utdanningstilbudet? Avklares med Tind og Puff (SHI-685).
    # - Hvem har ansvaret for avklaringen, funksjonell design eller domene og design (SHI-685)?
    Scenario: Søkere varsles når utdanningstilbudet de har søkt på, trekkes
      Gitt at opptaket har åpnet for søknad
      Og at søkere har søkt på utdanningstilbudet "Sykepleie, høst 2027"
      Når opptaksforvalter velger å trekke utdanningstilbudet "Sykepleie, høst 2027"
      Så får opptaksforvalter et tydelig varsel om konsekvensen for søkere som har søkt
      Og søkere som har søkt på utdanningstilbudet "Sykepleie, høst 2027", varsles

  @implemented
  Regel: Trekking er ikke mulig etter trekkfristen for deltakende organisasjoner

    Scenario: Opptaksforvalter ved deltakende organisasjon forsøker å trekke etter trekkfristen
      Gitt at trekkfristen for utdanningstilbud er passert
      Og at opptaksforvalter er ved en deltakende organisasjon
      Så kan opptaksforvalter ikke trekke utdanningstilbud fra opptaket