# language: no
@OPT-OPT-INN-001 @must @draft
Egenskap: Grunnleggende innstillinger for opptak
  Som opptaksforvalter
  ønsker jeg å sette grunnleggende innstillinger for opptaket
  slik at opptaket har riktige rammer for søknad, saksbehandling og plasstildeling.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at opptaket "Samordna opptak 2027" er opprettet

  Regel: Opptaksforvalter setter standard poenglikhetsregel for opptaket

    Scenario: Sette standard poenglikhetsregel
      Når jeg setter standard poenglikhetsregel til "loddtrekning"
      Så brukes loddtrekning i rangeringen av søkere med lik poengsum
      Og regelen gjelder for alle utdanningstilbud i opptaket som default

  # Løses av teamet som jobber med utdanningstilbud
  Regel: Opptaksforvalter setter kriterier for hvilke typer og nivåer av utdanninger som kan delta i opptaket

    Scenario: Begrense UHG-opptak til relevante utdanningsnivåer og -typer
      Når jeg setter at opptaket kun skal ha studieprogram
      Og jeg setter at NKR-nivåene bachelor, årsenheter og 5-6-årige integrerte master og profesjonsstudier er tillatt
      Så er det kun studieprogram på disse nivåene som kan legges til som utdanningstilbud i opptaket

    Scenario: Begrense HYU-opptak til fagskoleutdanninger
      Når jeg setter at opptaket kun skal ha studieprogram
      Og jeg setter at NKR-nivået for 1-2-årige fagskoleutdanninger er tillatt
      Så er det kun fagskoleutdanninger av typen studieprogram som kan legges til som utdanningstilbud

    Scenario: Utdanninger utenfor kriteriene er ikke tilgjengelige
      Gitt at opptaket kun tillater studieprogram på bachelornivå
      Så dukker ikke emner opp som mulige utdanningstilbud
      Og studieprogram på masternivå dukker ikke opp som mulige utdanningstilbud

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Jobbes med av et annet team. Hvilke valgmuligheter finnes for fordeling
  #   av saker til saksbehandlere/saksbehandlerorganisasjoner?
  Regel: Opptaksforvalter kan sette innstillinger for saksbehandlertildeling

    Scenario: Sette innstillinger for saksbehandlertildeling
      Når jeg setter innstillinger for saksbehandlertildeling
      Så fordeles sakene til riktige saksbehandlerorganisasjoner