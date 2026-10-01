# language: no
# GitHub: #596
@OPT-OPT-UTD-007 @must @draft
Egenskap: Sette antall studieplasser og antall tilbud per utdanningstilbud
  Som opptaksforvalter
  ønsker jeg å sette hvor mange studieplasser vi har og hvor mange tilbud som skal gis per utdanningstilbud
  slik at vi ikke tar opp flere studenter enn vi kan følge opp eller har finansiering for.

  # Kilde: GitHub #398 (brukerhistorie og akseptansekriterium om tilleggsdata) og #596.
  # Opptaksforvalter ved deltakende organisasjon setter tallene for egne utdanningstilbud.
  # Opptaksforvalter ved forvaltende organisasjon kan sette tallene for alle utdanningstilbud.
  # Fordelingen mellom utdanningskvoter settes i opptaksinnstillinger_utdanningstilbud.feature.
  # Hvordan plasstildelingen bruker tallene per runde, er beskrevet i
  # 14 Plasstildeling/02 Tildelingsinnstillinger/antall_tilbud_som_skal_gis.feature.

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at utdanningstilbudet "Sykepleie, høst 2027" er lagt til i opptaket "Samordna opptak 2027"

  Regel: Opptaksforvalter setter antall studieplasser

    Scenario: Sette antall studieplasser
      Når opptaksforvalter setter antall studieplasser til 200 for utdanningstilbudet "Sykepleie, høst 2027"
      Så har utdanningstilbudet 200 studieplasser

  Regel: Opptaksforvalter setter totalt antall tilbud som skal gis

    Scenario: Sette antall tilbud
      Når opptaksforvalter setter antall tilbud som skal gis til 278 for utdanningstilbudet "Sykepleie, høst 2027"
      Så gir plasstildelingen inntil 278 tilbud totalt for dette utdanningstilbudet
      Og antall tilbud per utdanningskvote beregnes fra den relative fordelingen

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Kan antall tilbud som skal gis, være lavere enn antall studieplasser?
    Scenario: Antall tilbud er høyere enn antall studieplasser
      Gitt at utdanningstilbudet har 200 studieplasser
      Når opptaksforvalter setter antall tilbud som skal gis til 278
      Så er antall tilbud som skal gis lagret

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Er «tak for ja-svar» (#398) det samme som «antall ønsket ja-svar» i
  #   antall_tilbud_som_skal_gis.feature, eller et eget tall som gjelder hele opptaket?
  # - Hva skjer når taket er nådd: stopper plasstildelingen å gi nye tilbud?
  Regel: Opptaksforvalter kan sette tak for ja-svar

    Scenario: Sette tak for ja-svar
      Når opptaksforvalter setter tak for ja-svar til 220 for utdanningstilbudet "Sykepleie, høst 2027"
      Så gir ikke plasstildelingen nye tilbud når 220 søkere har svart ja

# ÅPNE SPØRSMÅL:
# - #398 nevner «kapasitet, tilbud som skal gis, tak for ja-svar +++». Hvilke andre tilleggsdata trengs?
# - Må antall studieplasser og antall tilbud være satt før søknadsåpning?
# - Hvordan forholder antall studieplasser her seg til «antall planlagte studieplasser» som vises i
#   antall_tilbud_som_skal_gis.feature? Er det samme tall?
