# language: no
@OPT-SØK-SØK-015 @must @draft @ref-OPT-SØK-SØK-013
Egenskap: Se detaljer om et utdanningstilbud
  Som søker
  ønsker jeg å se detaljene om et utdanningstilbud
  slik at jeg vet hva som kreves før jeg søker.

  # Søkeren kommer til detaljsiden fra listen i «Finn studier».
  # Opplysningene registreres av opptaksforvalter på utdanningstilbudet.

  # Attestene registreres i registrere_påkrevde_attester.feature.
  @depends-on-OPT-OPT-UTD-014
  Regel: Søkeren ser hvilke attester utdanningstilbudet krever

    Scenario: Se attestene utdanningstilbudet krever
      Gitt at utdanningstilbudet "Sykepleie, høst 2027" krever politiattest og medisinsk attest
      Når søkeren ser detaljsiden for utdanningstilbudet "Sykepleie, høst 2027"
      Så ser søkeren at utdanningstilbudet krever politiattest og medisinsk attest

  # Studieavgiften registreres i angi_studieavgift.feature.
  @depends-on-OPT-OPT-UTD-022
  Regel: Søkeren ser om utdanningstilbudet har studieavgift

    Scenario: Se at utdanningstilbudet har studieavgift
      Gitt at utdanningstilbudet "Sykepleie, høst 2027" har studieavgift
      Når søkeren ser detaljsiden for utdanningstilbudet "Sykepleie, høst 2027"
      Så ser søkeren at utdanningstilbudet har studieavgift

# ÅPNE SPØRSMÅL:
# - Hva vises når utdanningstilbudet ikke krever attest, eller ikke har studieavgift?
# - Skal beskrivelsen (UTD-016) og poenggrensen og ventelistenummeret (UTD-029) også stå i dette kravet?
# - Hvilket scope hører kravet til?
