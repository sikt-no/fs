# language: no
# Jira: SHI-708
@OPT-OPT-UTD-025 @must @in-progress @scope-utdanningstilbud-2027
Egenskap: Sette tidlig søknadsfrist og dokumentasjonsfrist på utdanningstilbudet
  Som opptaksforvalter
  ønsker jeg å sette tidlig søknadsfrist og tidlig dokumentasjonsfrist per utdanningstilbud
  slik at utdanningstilbud som trenger det, kan ha tidligere frister enn opptakets generelle frister.

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at opptaket "Samordna opptak 2027" har utdanningstilbud

  @openquestion
  Regel: Opptaksforvalter kan sette tidlig søknadsfrist per utdanningstilbud
    # ÅPNE SPØRSMÅL:
    # - Hva skjer med søkere som ikke har lastet opp dokumentasjon innen den tidlige dokumentasjonsfristen? Kan søkeren ikke laste opp etter fristen, eller merkes dokumentasjonen som levert for sent for saksbehandleren?
    # AVKLART 2026-10-22: Tidlig søknadsfrist settes fritt per utdanningstilbud. Opptaket trenger ingen egen innstilling for det.

    @implemented
    Scenario: Sette tidlig søknadsfrist
      Gitt at søknadsfristen for opptaket er "2027-04-15 23:59"
      Når opptaksforvalter setter tidlig søknadsfrist til "2027-03-01 23:59" for utdanningstilbudet "Politihøyskolen, høst 2027"
      Så har utdanningstilbudet "Politihøyskolen, høst 2027" tidlig søknadsfrist "2027-03-01 23:59"

    @openquestion
    Scenariomal: Tidlig søknadsfrist må være før søknadsfristen for opptaket
      # ÅPNE SPØRSMÅL:
      # - Ikke funnet i koden (verify 2026-10-22): verken fs-plattform eller fs-admin sjekker at tidlig søknadsfrist er før søknadsfristen for opptaket. Skal sjekken bygges, eller fjernes fra kravet?
      Gitt at søknadsfristen for opptaket er "2027-04-15 23:59"
      Når opptaksforvalter setter tidlig søknadsfrist til "<frist>" for utdanningstilbudet "Politihøyskolen, høst 2027"
      Så lagres ikke den tidlige søknadsfristen
      Og opptaksforvalter får beskjed om at tidlig søknadsfrist må være før søknadsfristen for opptaket

      Eksempler:
        | frist            |
        | 2027-04-15 23:59 |
        | 2027-04-20 23:59 |

    @implemented
    Scenario: Sette tidlig dokumentasjonsfrist
      Når opptaksforvalter setter tidlig dokumentasjonsfrist til "2027-03-01 23:59" for utdanningstilbudet "Politihøyskolen, høst 2027"
      Så har utdanningstilbudet "Politihøyskolen, høst 2027" tidlig dokumentasjonsfrist "2027-03-01 23:59"
