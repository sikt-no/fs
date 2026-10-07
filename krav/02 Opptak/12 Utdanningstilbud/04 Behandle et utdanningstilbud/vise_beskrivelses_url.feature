# language: no
# Jira: SHI-687
@OPT-OPT-UTD-009 @must @draft
Egenskap: Vise URL til beskrivelse av utdanningstilbudet
  Som opptaksforvalter
  ønsker jeg å se URL-en til beskrivelsen av utdanningstilbudet
  slik at jeg og søkeren kan finne mer informasjon om utdanningen.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  Regel: URL til beskrivelse hentes fra utdanningsregisteret og vises

    Scenario: Se URL til beskrivelse av utdanningstilbudet
      Gitt at utdanningstilbudet har en beskrivelses-URL i utdanningsregisteret
      Så vises URL-en til beskrivelsen av utdanningstilbudet

    Scenario: Utdanningstilbud uten beskrivelses-URL
      Gitt at utdanningstilbudet ikke har en beskrivelses-URL i utdanningsregisteret
      Så vises ingen beskrivelses-URL

# ÅPNE SPØRSMÅL:
# - Skal URL-en vises som klikkbar lenke, og eventuelt åpnes i ny fane?
# - Kan opptaksforvalter overstyre eller registrere URL-en manuelt, eller er den kun hentet fra utdanningsregisteret?
