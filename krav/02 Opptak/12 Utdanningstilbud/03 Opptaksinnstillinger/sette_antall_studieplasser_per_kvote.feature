# language: no
@OPT-OPT-UTD-032 @must @draft @scope-utdanningstilbud-2027 @depends-on-OPT-OPT-UTD-007
Egenskap: Sette antall studieplasser per utdanningskvote
  Som opptaksforvalter
  ønsker jeg å fordele studieplassene på utdanningstilbudet mellom utdanningskvotene
  slik at det er klart hvor mange studieplasser hver utdanningskvote har.

  # Skrevet 2026-10-21 fra koden, som allerede har det (fs-admin: «Ant. kvoteplasser» på
  # utdanningstilbudet; fs-plattform: onsketAntallDeltakere på kvoten). Antall studieplasser for
  # utdanningstilbudet står i sette_studieplasser_og_antall_tilbud.feature.

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at utdanningstilbudet "Sykepleie, høst 2027" har 200 studieplasser
    Og at utdanningstilbudet har utdanningskvotene "Førstegangsvitnemål" og "Ordinær"

  Regel: Opptaksforvalter setter antall studieplasser per utdanningskvote

    Scenario: Sette antall studieplasser i en utdanningskvote
      Når opptaksforvalter setter antall studieplasser i utdanningskvoten "Førstegangsvitnemål" til 100
      Så har utdanningskvoten "Førstegangsvitnemål" 100 studieplasser
      Og andelen av studieplassene på utdanningstilbudet vises som 50 %

  Regel: Opptaksforvalter varsles når summen av utdanningskvotene ikke er lik antall studieplasser

    Scenario: Summen av utdanningskvotene avviker fra antall studieplasser
      Gitt at utdanningskvoten "Førstegangsvitnemål" har 100 studieplasser
      Når opptaksforvalter setter antall studieplasser i utdanningskvoten "Ordinær" til 80
      Så varsles opptaksforvalter om at utdanningskvotene summerer til 180, men at utdanningstilbudet har 200 studieplasser
      Og antall studieplasser i utdanningskvotene lagres likevel

# ÅPNE SPØRSMÅL:
# - Er tallet per kvote et måltall (koden kaller det «ønsket antall deltakere») eller et fast antall studieplasser?
# - Skal lagring stoppes når summen ikke stemmer, eller er et varsel nok?
# - Hvem kan endre tallene, og når (samme regler som antall studieplasser i UTD-007)?
