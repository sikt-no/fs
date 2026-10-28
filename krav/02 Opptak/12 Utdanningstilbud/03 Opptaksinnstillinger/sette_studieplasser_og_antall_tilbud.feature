# language: no
# GitHub: #596
@OPT-OPT-UTD-007 @must @draft @scope-utdanningstilbud-2027
Egenskap: Sette antall studieplasser per utdanningstilbud
  Som opptaksforvalter
  ønsker jeg å sette hvor mange studieplasser vi har per utdanningstilbud
  slik at vi ikke tar opp flere studenter enn vi kan følge opp eller har finansiering for.

  # Kilde: GitHub #398 (brukerhistorie og akseptansekriterium om tilleggsdata) og #596.
  # Opptaksforvalter ved deltakende organisasjon setter tallene for egne utdanningstilbud.
  # Opptaksforvalter ved forvaltende organisasjon kan sette tallene for alle utdanningstilbud.
  # AVKLART 2026-10-08: Antall tilbud som skal gis settes ikke for utdanningstilbudet her. Det settes
  # som absolutte tall per utdanningskvote for hvert utdanningstilbud i hver plasstildelingsrunde, se
  # 14 Plasstildeling/02 Tildelingsinnstillinger/antall_tilbud_som_skal_gis.feature.
  # Antall studieplasser vises der som grunnlag.

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at utdanningstilbudet "Sykepleie, høst 2027" er lagt til i opptaket "Samordna opptak 2027"

  Regel: Opptaksforvalter setter antall studieplasser

    Scenario: Sette antall studieplasser
      Når opptaksforvalter setter antall studieplasser til 200 for utdanningstilbudet "Sykepleie, høst 2027"
      Så har utdanningstilbudet 200 studieplasser

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Trengs «tak for ja-svar» (#398)? Begrepet «antall ønsket ja-svar» er tatt ut (2026-10-08),
  #   og antall tilbud som skal gis settes per plasstildelingsrunde i 14 Plasstildeling.
  # - Hva skjer når taket er nådd: stopper plasstildelingen å gi nye tilbud?
  Regel: Opptaksforvalter kan sette tak for ja-svar

    Scenario: Sette tak for ja-svar
      Når opptaksforvalter setter tak for ja-svar til 220 for utdanningstilbudet "Sykepleie, høst 2027"
      Så gir ikke plasstildelingen nye tilbud når 220 søkere har svart ja

  Regel: Deltakende organisasjoner kan endre antall studieplasser til første plasstildelingsrunde er publisert
    # Virkningen av når redigering av utdanningstilbud stenger, som opptaksforvalter setter i
    # 11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature.
    # Lagt til 2026-10-19 etter akseptansetesten av opprette og vedlikeholde opptak.
    # AVKLART 2026-10-15 (Q4, Q5 og Q13, TAKE-410): Antall studieplasser er unntatt fra fristen for redigering
    # av utdanningstilbud, og kan endres til første plasstildelingsrunde er publisert. Plasstildelinger som bare
    # er kjørt for kontroll, låser det ikke.

    Scenario: Endre antall studieplasser etter at redigering av utdanningstilbud har stengt
      Gitt at redigering av utdanningstilbud i opptaket har stengt
      Og at ingen plasstildelingsrunde i opptaket er publisert
      Når opptaksforvalter ved deltakende organisasjon setter antall studieplasser til 180 for utdanningstilbudet "Sykepleie, høst 2027"
      Så har utdanningstilbudet 180 studieplasser

    Scenario: Endre antall studieplasser etter en plasstildeling som bare er kjørt for kontroll
      Gitt at en plasstildeling i opptaket er kjørt for kontroll, men ikke publisert
      Når opptaksforvalter setter antall studieplasser til 180 for utdanningstilbudet "Sykepleie, høst 2027"
      Så har utdanningstilbudet 180 studieplasser

    Scenario: Deltakende organisasjon kan ikke endre antall studieplasser etter at første plasstildelingsrunde er publisert
      Gitt at første plasstildelingsrunde i opptaket er publisert
      Når opptaksforvalter ved deltakende organisasjon vil endre antall studieplasser for utdanningstilbudet "Sykepleie, høst 2027"
      Så kan opptaksforvalter ved deltakende organisasjon ikke endre antall studieplasser for utdanningstilbudet "Sykepleie, høst 2027"

    # AVKLART 2026-10-19 (produkteier): Låsen gjelder ikke opptaksforvalter ved forvaltende organisasjon, foreløpig.
    # På sikt bør antall studieplasser komme fra antall plasser som er registrert på kullet i SIS, men det er en
    # standardisering vi ikke er klare for ennå.
    Scenario: Forvaltende organisasjon kan endre antall studieplasser etter at første plasstildelingsrunde er publisert
      Gitt at første plasstildelingsrunde i opptaket er publisert
      Når opptaksforvalter ved forvaltende organisasjon setter antall studieplasser til 180 for utdanningstilbudet "Sykepleie, høst 2027"
      Så har utdanningstilbudet "Sykepleie, høst 2027" 180 studieplasser

# ÅPNE SPØRSMÅL:
# - #398 nevner «kapasitet, tilbud som skal gis, tak for ja-svar +++». Hvilke andre tilleggsdata trengs?
# - Må antall studieplasser være satt før søknadsåpning?
