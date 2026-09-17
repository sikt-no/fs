# language: no
@OPT-OPT-INN-001 @must @draft
Egenskap: Grunnleggende innstillinger for opptak
  Som opptaksforvalter
  ønsker jeg å sette grunnleggende innstillinger for opptaket
  slik at opptaket har riktige rammer for søknad, saksbehandling og plasstildeling.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at opptaket "Samordna opptak 2027" er opprettet

  Regel: Opptaksforvalter må angi hvor lenge opptaket er tilgjengelig

    Scenario: Sette opptaksperiode
      Når jeg setter opptaksperioden fra "2027-01-01" til "2027-12-31"
      Så vet søkere i hvilket tidsrom de kan søke
      Og saksbehandlere vet i hvilket tidsrom de kan saksbehandle
      Og opptaksforvalter vet hvor lenge opptaket kan endres

  Regel: Opptaksforvalter må sette minst en plasstildelingsrunde

    Scenario: Sette plasstildelingsrunde
      Når jeg legger til en plasstildelingsrunde av typen "hovedtildeling"
      Og jeg setter svarfrist og publiseringstidspunkt for runden
      Så kan plasstildelingen kjøres for denne runden

    Scenario: Opptak uten plasstildelingsrunde kan ikke kjøre plasstildeling
      Gitt at opptaket ikke har noen plasstildelingsrunder
      Så kan ikke en plasstildeling startes

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
  Regel: Opptaksforvalter kan sette innstillinger for fordeling av søknadssaker

    Scenario: Sette fordeling av saker til saksbehandlerorganisasjoner
      Når jeg setter innstillinger for fordeling av søknadssaker
      Så fordeles sakene til riktige saksbehandlerorganisasjoner
