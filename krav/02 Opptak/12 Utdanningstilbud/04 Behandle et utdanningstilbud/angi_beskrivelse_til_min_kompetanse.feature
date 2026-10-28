# language: no
# Jira: SHI-694
@OPT-OPT-UTD-016 @must @implemented @scope-utdanningstilbud-2027
Egenskap: Angi beskrivelse av utdanningstilbudet til Min kompetanse
  Som opptaksforvalter
  ønsker jeg å angi en beskrivelse av utdanningstilbudet på flere språk
  slik at søkeren får beskrivelsen presentert i Min kompetanse på sitt språk.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  Regel: Beskrivelse til Min kompetanse kan angis per språk
    # AVKLART 2026-10-22: Beskrivelsen er valgfri på hvert språk.

    Scenariomal: Angi beskrivelse på <språk>
      Når opptaksforvalter angir en beskrivelse på <språk>
      Så lagres beskrivelsen på <språk> for utdanningstilbudet

      Eksempler:
        | språk      |
        | bokmål     |
        | nynorsk    |
        | engelsk    |
        | nordsamisk |

  @openquestion
  Regel: Beskrivelsen framvises søkeren i Min kompetanse
    # ÅPNE SPØRSMÅL:
    # - Hva ser søkeren når det ikke finnes noen beskrivelse på språket søkeren bruker: bokmål, den første av bokmål, nynorsk og engelsk som finnes, beskrivelsen fra utdanningsregisteret, eller ingen beskrivelse?

    @in-progress
    Scenario: Søker ser beskrivelsen i Min kompetanse
      Gitt at utdanningstilbudet har en angitt beskrivelse
      Så framvises beskrivelsen for søkeren i Min kompetanse
