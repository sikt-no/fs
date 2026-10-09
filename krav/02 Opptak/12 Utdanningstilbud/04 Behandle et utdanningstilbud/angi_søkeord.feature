# language: no
# Jira: SHI-695
@OPT-OPT-UTD-017 @must @draft
Egenskap: Angi søkeord på utdanningstilbudet
  Som opptaksforvalter
  ønsker jeg å angi søkeord på utdanningstilbudet
  slik at søkere lettere finner tilbud som har ukjente navn i Min kompetanse.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  Regel: Søkeord kan angis på utdanningstilbudet

    Scenario: Legge til søkeord på utdanningstilbud
      Når opptaksforvalter legger til søkeordet "Lege" på utdanningstilbudet
      Så lagres søkeordet på utdanningstilbudet

    Scenario: Legge til flere søkeord på samme utdanningstilbud
      Når opptaksforvalter legger til søkeordene "Lege" og "Design" på utdanningstilbudet
      Så lagres begge søkeordene på utdanningstilbudet

    Scenario: Fjerne søkeord fra utdanningstilbud
      Gitt at utdanningstilbudet har søkeordet "Design"
      Når opptaksforvalter fjerner søkeordet "Design"
      Så er søkeordet ikke lenger lagret på utdanningstilbudet

  Regel: Søkeord hjelper søkeren å finne utdanningstilbud i Min kompetanse

    Scenario: Søker finner utdanningstilbud via søkeord
      Gitt at utdanningstilbudet har søkeordet "Lege"
      Når søkeren søker på "Lege" i Min kompetanse
      Så vises utdanningstilbudet i søkeresultatet

# ÅPNE SPØRSMÅL:
# - Er søkeord fritekst, eller velges de fra en forhåndsdefinert liste?
# - Finnes det begrensninger på antall søkeord eller format (f.eks. med/uten "#")?
