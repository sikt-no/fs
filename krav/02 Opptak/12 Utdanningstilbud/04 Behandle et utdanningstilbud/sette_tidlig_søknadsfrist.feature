# language: no
# Jira: SHI-708
@OPT-OPT-UTD-025 @must @draft
Egenskap: Sette tidlig søknadsfrist og dokumentasjonsfrist på utdanningstilbudet
  Som opptaksforvalter
  ønsker jeg å sette tidlig søknadsfrist og tidlig dokumentasjonsfrist per utdanningstilbud
  slik at utdanningstilbud som trenger det, kan ha tidligere frister enn opptakets generelle frister.

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at opptaket "Samordna opptak 2027" har utdanningstilbud

  Regel: Opptaksforvalter kan sette tidlig søknadsfrist per utdanningstilbud

    Scenario: Sette tidlig søknadsfrist
      Gitt at opptaket åpner for at tidlig søknadsfrist kan angis per utdanningstilbud
      Når opptaksforvalter setter tidlig søknadsfrist for utdanningstilbudet "Politihøyskolen, høst 2027"
      Så har utdanningstilbudet en tidligere søknadsfrist enn opptakets generelle frist

    Scenario: Sette tidlig dokumentasjonsfrist
      Gitt at opptaket åpner for at tidlig søknadsfrist kan angis per utdanningstilbud
      Når opptaksforvalter setter tidlig dokumentasjonsfrist til "2027-03-01 23:59" for utdanningstilbudet "Politihøyskolen, høst 2027"
      Så må søkere til utdanningstilbudet laste opp dokumentasjon innen dokumentasjonsfristen
