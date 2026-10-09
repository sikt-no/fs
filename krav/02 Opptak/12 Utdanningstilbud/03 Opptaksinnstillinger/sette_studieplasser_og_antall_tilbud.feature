# language: no
# GitHub: #596
@OPT-OPT-UTD-007 @must @draft
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

# ÅPNE SPØRSMÅL:
# - #398 nevner «kapasitet, tilbud som skal gis, tak for ja-svar +++». Hvilke andre tilleggsdata trengs?
# - Må antall studieplasser være satt før søknadsåpning?
