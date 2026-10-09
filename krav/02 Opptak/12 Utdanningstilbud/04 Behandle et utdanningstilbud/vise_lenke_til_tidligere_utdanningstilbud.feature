# language: no
# Jira: SHI-700
@OPT-OPT-UTD-021 @could @draft
Egenskap: Vise lenke til tidligere utdanningstilbud
  Som opptaksforvalter
  ønsker jeg å sette og se en lenke til tidligere utdanningstilbud
  slik at sammenhengen mellom årets og tidligere tilbud er synlig.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  Regel: Lenke til tidligere utdanningstilbud kan settes og vises

    Scenario: Sette lenke til tidligere utdanningstilbud
      Når opptaksforvalter setter en lenke til et tidligere utdanningstilbud
      Så lagres lenken på utdanningstilbudet

    Scenario: Se lenke til tidligere utdanningstilbud
      Gitt at utdanningstilbudet har en lenke til et tidligere utdanningstilbud
      Så vises lenken til det tidligere utdanningstilbudet

# ÅPNE SPØRSMÅL:
# - Dette er merket "draft:" i Jira. Hva menes med "tidligere utdanningstilbud" — fjorårets tilbud, eller et tilbud som er erstattet?
# - Settes lenken manuelt, eller utledes den automatisk?
# - Skal lenken framvises for opptaksforvalter, for søkeren, eller begge?
