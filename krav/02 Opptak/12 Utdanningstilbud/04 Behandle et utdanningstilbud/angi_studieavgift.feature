# language: no
# Jira: SHI-701
@OPT-OPT-UTD-022 @must @draft
Egenskap: Angi informasjon om studieavgift
  Som opptaksforvalter
  ønsker jeg å angi informasjon om eventuell studieavgift for utdanningstilbudet
  slik at søkeren vet om og hvor mye studieavgift som gjelder.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  Regel: Informasjon om studieavgift kan angis på utdanningstilbudet

    Scenario: Registrere informasjon om studieavgift
      Når opptaksforvalter registrerer informasjon om studieavgift
      Så lagres informasjonen om studieavgift på utdanningstilbudet

    Scenario: Se informasjon om studieavgift
      Gitt at utdanningstilbudet har registrert informasjon om studieavgift
      Så vises informasjonen om studieavgift

# ÅPNE SPØRSMÅL:
# - Hentes studieavgift fra en kilde, eller registreres den direkte? Dette må utredes.
# - Hvilke felt inngår (beløp, valuta, eventuelle fritak, periode)?
# - Skal studieavgift framvises for søkeren i Min kompetanse?
