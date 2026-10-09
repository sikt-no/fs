# language: no
# Jira: SHI-694
@OPT-OPT-UTD-016 @must @draft
Egenskap: Angi beskrivelse av utdanningstilbudet til Min kompetanse
  Som opptaksforvalter
  ønsker jeg å angi en beskrivelse av utdanningstilbudet på flere språk
  slik at søkeren får beskrivelsen presentert i Min kompetanse på sitt språk.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  Regel: Beskrivelse til Min kompetanse kan angis per språk

    Scenariomal: Angi beskrivelse på <språk>
      Når opptaksforvalter angir en beskrivelse på <språk>
      Så lagres beskrivelsen på <språk> for utdanningstilbudet

      Eksempler:
        | språk    |
        | bokmål   |
        | nynorsk  |
        | engelsk  |
        | samisk   |

  Regel: Beskrivelsen framvises søkeren i Min kompetanse

    Scenario: Søker ser beskrivelsen i Min kompetanse
      Gitt at utdanningstilbudet har en angitt beskrivelse
      Så framvises beskrivelsen for søkeren i Min kompetanse

# ÅPNE SPØRSMÅL:
# - Hvilke språk nøyaktig? Jira nevner "no, nb, eng, samisk" — "no" og "nb" overlapper; menes bokmål og nynorsk? Og hvilken samisk-variant?
# - Er beskrivelse påkrevd på alle språk, eller valgfritt per språk?
# - Hvilket språk framvises hvis beskrivelse på søkerens språk mangler?
