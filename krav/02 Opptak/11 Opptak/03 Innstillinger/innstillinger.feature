# language: no
@OPT-OPT-INN-001 @must @draft
Egenskap: Innstillinger for opptak
  Som opptaksforvalter
  ønsker jeg å sette innstillinger for opptaket
  slik at opptaket har riktige rammer for søknad, saksbehandling og plasstildeling.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at opptaket "Samordna opptak 2027" er opprettet

  Regel: Opptaksforvalter kan endre opptakstype

    Scenario: Endre opptakstype
      Når jeg endrer opptakstype for opptaket
      Så er opptakstypen oppdatert

  Regel: Opptaksforvalter kan endre regelverkssamling

    Scenario: Endre regelverkssamling
      Når jeg endrer regelverkssamlingen til "UHG 2027 v2"
      Så er reglene i den nye regelverkssamlingen tilgjengelige for utdanningstilbud i opptaket

  # Løses av teamet som jobber med utdanningstilbud
  Regel: Opptaksforvalter setter kriterier for hvilke typer og nivåer av utdanninger som kan delta i opptaket

    Scenario: Sette utdanningstype
      Når jeg setter at opptaket kun skal ha studieprogram
      Så er det kun studieprogram som kan legges til som utdanningstilbud

    Scenario: Sette NKR-nivåer for UHG-opptak
      Når jeg setter at opptaket kun skal ha studieprogram
      Og jeg setter at NKR-nivåene bachelor, årsenheter og 5-6-årige integrerte master og profesjonsstudier er tillatt
      Så er det kun studieprogram på disse nivåene som kan legges til som utdanningstilbud i opptaket

    Scenario: Sette NKR-nivåer for HYU-opptak
      Når jeg setter at opptaket kun skal ha studieprogram
      Og jeg setter at NKR-nivået for 1-2-årige fagskoleutdanninger er tillatt
      Så er det kun fagskoleutdanninger av typen studieprogram som kan legges til som utdanningstilbud

    Scenario: Utdanninger utenfor kriteriene er ikke tilgjengelige
      Gitt at opptaket kun tillater studieprogram på bachelornivå
      Så dukker ikke emner opp som mulige utdanningstilbud
      Og studieprogram på masternivå dukker ikke opp som mulige utdanningstilbud

  Regel: Opptaksforvalter setter standard poenglikhetsregel for opptaket

    Scenario: Sette standard poenglikhetsregel
      Når jeg setter standard poenglikhetsregel til "loddtrekning"
      Så brukes loddtrekning i rangeringen av søkere med lik poengsum
      Og regelen gjelder for alle utdanningstilbud i opptaket som default

  Regel: Opptaksforvalter kan sette startnummer for søknadsnummerserien

    Scenario: Sette nummerserie for opptak
      Når jeg setter søknadsnummerserie med startnummer 100000
      Så får søknader i opptaket løpende nummer fra 100000
      Og søknadsnumrene er unike for dette opptaket

  Regel: Opptaksforvalter kan sette tak for antall søknadsalternativer

    Scenario: Sette maks antall søknadsalternativer
      Når jeg setter maks antall søknadsalternativer til 10
      Så kan ikke en søker legge til flere enn 10 prioriterte søknadsalternativer i sin søknad

  Regel: Opptaksforvalter kan sette tak for antall tilbud per tildelingsrunde

    Scenario: Sette tak for antall tilbud per runde
      Når jeg setter tak for antall tilbud per tildelingsrunde til 500
      Så kan ikke plasstildelingen gi flere enn 500 tilbud i en enkelt runde

  Regel: Opptaksforvalter kan åpne for tidlig opptak

    Scenario: Aktivere tidlig opptak
      Når jeg aktiverer tidlig opptak
      Så kan søkere som oppfyller visse kriterier få svar før vanlig publiseringsfrist

  Regel: Opptaksforvalter kan åpne for søknad på ledige studieplasser

    Scenario: Aktivere ledige studieplasser
      Når jeg angir at opptaket tilbyr søknad på ledige studieplasser
      Så kan restplasser legges ut til søkere etter ordinær plasstildeling

  Regel: Opptaksforvalter kan angi om det er lov å sette avvikende søknadsfrister

    Scenario: Tillate avvikende søknadsfrister per utdanningstilbud
      Når jeg angir at det er lov å sette tidligere søknadsfrister per utdanningstilbud
      Så kan opptaksforvalter ved deltakende organisasjon sette egne søknadsfrister på sine utdanningstilbud

    Scenario: Tillate avvikende søknadsfrister per utdanningsbakgrunn
      Når jeg angir at det er lov å sette avvikende søknadsfrister per utdanningsbakgrunn
      Så kan opptaksforvalter opprette utdanningsbakgrunner med egne søknads- og dokumentasjonsfrister

  @wont
  # Ikke viktig for samordna opptak 2027
  Regel: Opptaksforvalter kan styre om søkere kan laste opp dokumentasjon

    Scenario: Åpne for dokumentasjonsopplasting
      Når jeg angir at søkere kan laste opp dokumentasjon
      Så kan søkere laste opp dokumentasjon som del av søknaden

  @wont
  # Ikke relevant for samordna opptak
  Regel: Opptaksforvalter kan sette krav om studierett for å søke

    Scenario: Kreve studierett
      Når jeg angir at det kreves studierett for å søke
      Så kan kun studenter med studierett ved lærestedet søke

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Jobbes med av et annet team. Hvilke valgmuligheter finnes for fordeling
  #   av saker til saksbehandlere/saksbehandlerorganisasjoner?
  Regel: Opptaksforvalter kan sette innstillinger for saksbehandlertildeling

    Scenario: Sette innstillinger for saksbehandlertildeling
      Når jeg setter innstillinger for saksbehandlertildeling
      Så fordeles sakene til riktige saksbehandlerorganisasjoner