# language: no
# GitHub: #595
# Jira: SHI-709
@OPT-OPT-UTD-003 @must @draft @scope-utdanningstilbud-2027
Egenskap: Trekke utdanningstilbud fra opptak
  Som opptaksforvalter
  ønsker jeg å kunne trekke utdanningstilbud fra opptaket
  slik at utdanninger som ikke lenger skal ha opptak blir håndtert riktig.

  # Trekkfristen settes av opptakseier (#595).
  # Når en utdanningsinstans deaktiveres i utdanningsregisteret, får opptaksforvalter beskjed om at
  # utdanningstilbudet kan trekkes, se 01 Hente fra utdanningsregisteret/fange_opp_endringer_fra_utdanningsregisteret.feature.

  # ÅPNE SPØRSMÅL:
  # - Skal kravet få @ref-OPT-OPT-UTD-006 (fange_opp_endringer_fra_utdanningsregisteret.feature), som kommentaren over viser til?

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at opptaket "Samordna opptak 2027" har utdanningstilbud

  Regel: Opptaksforvalter ved deltakende organisasjon eller forvaltende organisasjon kan trekke utdanningstilbud

    Scenario: Opptaksforvalter ved deltakende organisasjon trekker utdanningstilbud organisasjonen tilbyr
      Gitt at opptaksforvalter er ved en deltakende organisasjon
      Når opptaksforvalter velger å trekke utdanningstilbudet "Sykepleie, høst 2027"
      Så varsles opptaksforvalter om konsekvensen av å trekke
      Og utdanningstilbudet trekkes fra opptaket

    Scenario: Opptaksforvalter ved forvaltende organisasjon trekker utdanningstilbud
      Gitt at opptaksforvalter er ved forvaltende organisasjon
      Når opptaksforvalter velger å trekke utdanningstilbudet "Sykepleie, UiO, høst 2027"
      Så varsles opptaksforvalter om konsekvensen av å trekke
      Og utdanningstilbudet trekkes fra opptaket

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - fjerne_utdanningstilbud.feature sier at utdanningstilbud fjernes før opptaket åpner for søknad, og bare kan trekkes etter. Er trekking før søknadsåpning det samme som å fjerne utdanningstilbudet? Hører regelen i så fall hjemme der?
  # - Kravet sier «søknadsperioden har startet», mens fjerne_utdanningstilbud.feature sier «opptaket har åpnet for søknad». Er det det samme, og hvilken formulering skal brukes?
  Regel: Trekking før søknadsåpning fjerner utdanningstilbudet fra listen

    Scenario: Trekke utdanningstilbud før søknadsåpning
      Gitt at søknadsperioden ikke har startet
      Når opptaksforvalter trekker utdanningstilbudet "Sykepleie, høst 2027"
      Så fjernes utdanningstilbudet fra listen over utdanningstilbud i opptaket

  @openquestion
  Regel: Trekking etter søknadsåpning gir tydeligere varsel og varsler søkere
    # ÅPNE SPØRSMÅL:
    # - Hva skal skje når et utdanningstilbud trekkes etter publisering? Det er ikke spesifisert, og skal avklares sammen med Tind og Puff (SHI-685).
    # - Hvem har ansvaret for avklaringen, funksjonell design eller domene og design (SHI-685)?

    Scenario: Trekke utdanningstilbud etter søknadsåpning
      Gitt at søknadsperioden har startet
      Og at søkere har søkt på utdanningstilbudet "Sykepleie, høst 2027"
      Når opptaksforvalter velger å trekke utdanningstilbudet
      Så får opptaksforvalter et tydelig varsel om konsekvensen for søkere som har søkt
      Og søkere som har søkt varsles
      Og utdanningstilbudet blir liggende på opptaket, tydelig markert som trukket

  Regel: Trekking er ikke mulig etter trekkfristen for deltakende organisasjoner

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Etter trekkfristen har opptaksforvalter ved deltakende organisasjon ikke lov til å trekke. Skal muligheten til å trekke da være skjult (som i fjerne_utdanningstilbud.feature)? Tittelen sier «forsøker», og «kan ikke» sier ikke om muligheten vises.
    Scenario: Opptaksforvalter ved deltakende organisasjon forsøker å trekke etter trekkfristen
      Gitt at trekkfristen for utdanningstilbud er passert
      Og at opptaksforvalter er ved en deltakende organisasjon
      Så kan opptaksforvalter ikke trekke utdanningstilbud fra opptaket