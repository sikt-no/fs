# language: no
@OPT-OPT-FRI-001 @must @draft
Egenskap: Frister og tidsperioder for opptak
  Som opptaksforvalter
  ønsker jeg å sette frister som styrer tidsrammene for opptaket
  slik at søkere, saksbehandlere og læresteder vet hva som gjelder når.

  # Disse fristene gjelder for alle utdanningstilbud og alle søkere i opptaket,
  # med mindre det er satt avvikende frister på utdanningstilbud eller utdanningsbakgrunn.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at opptaket "Samordna opptak 2027" er opprettet

  Regel: Opptaksforvalter må kunne åpne og stenge for redigering av utdanningstilbud

    Scenario: Sette periode for redigering av utdanningstilbud
      Når jeg setter at redigering av utdanningstilbud åpner "2026-10-01" og stenger "2027-06-06"
      Så kan deltakende organisasjoner redigere sine utdanningstilbud i denne perioden

  Regel: Opptaksforvalter må kunne åpne for søkning

    Scenario: Sette søknadsdato
      Når jeg setter at søknaden åpner "2027-02-01"
      Så blir utdanningstilbudene i opptaket tilgjengelige for søkere fra denne datoen

  Regel: Opptaksforvalter må kunne sette generell søknadsfrist for opptaket

    Scenario: Sette ordinær søknadsfrist
      Når jeg setter ordinær søknadsfrist til "2027-04-15 23:59"
      Så gjelder fristen for alle utdanningstilbud og alle søkere i opptaket

  Regel: Opptaksforvalter må kunne sette omprioriteringsfrist

    Scenario: Sette omprioriteringsfrist
      Når jeg setter omprioriteringsfrist til "2027-04-15 23:59"
      Så kan søkere endre prioritering av søknadsalternativer fram til denne fristen

  Regel: Opptaksforvalter må kunne sette dokumentasjonsfrister

    Scenario: Sette ordinær dokumentasjonsfrist
      Når jeg setter ordinær dokumentasjonsfrist til "2027-04-15 23:59"
      Så må søkere laste opp dokumentasjon innen denne fristen

    Scenario: Sette tidlig dokumentasjonsfrist for søkere med tidlig søknadsfrist
      Når jeg setter tidlig dokumentasjonsfrist til "2027-03-01 23:59"
      Så gjelder denne fristen for søkere som har tidlig søknadsfrist

    Scenario: Sette ettersendingsfrist
      Når jeg setter ettersendingsfrist til "2027-07-01 23:59"
      Så kan søkere ettersende dokumentasjon fram til denne fristen
      Og dokumentasjon mottatt etter fristen er ikke garantert hensyntatt

  Regel: Opptaksforvalter må kunne sette informasjonsdatoer for ledige studieplasser

    Scenario: Sette informasjonsfrist for ledige studieplasser
      Gitt at opptaket tilbyr søknad på ledige studieplasser
      Når jeg setter informasjonsfrist for ledige studieplasser til "2027-07-20"
      Så kan søkere se når restplasser legges ut i Min kompetanse

    Scenario: Sette dato for når ledige studieplasser kan søkes
      Gitt at opptaket tilbyr søknad på ledige studieplasser
      Når jeg setter at ledige studieplasser kan søkes fra "2027-07-25"
      Så kan søkere søke på ledige studieplasser fra denne datoen

  Regel: Opptaksforvalter må kunne sette informasjonsdatoer for resultat

    Scenario: Sette dato for når søker kan forvente svar
      Når jeg setter dato for når søker kan forvente svar til "2027-07-15"
      Så kan søkere se når de kan forvente svar på søknaden

    # Faktiske svarfrister og publiseringstidspunkter settes per plasstildelingsrunde
    Scenario: Sette første svarfrist som informasjon til søkere
      Når jeg setter første svarfrist til "2027-07-20 23:59"
      Så kan søkere se når de senest må svare på et eventuelt tilbud

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - I dag kan læresteder trekke egne utdanningstilbud fram til en satt dato
  #   (f.eks. 6. juni for samordna opptak). Etter denne datoen kan kun opptakseier trekke.
  #   Skal vi videreføre denne begrensningen, eller skal det være åpent for at
  #   lærestedene håndterer det selv?
  # - Bør trekkfristen være en informasjonsfrist (forvaltningsfrist uten faktisk
  #   stengeeffekt) i stedet for en hard sperre?
  Regel: Opptaksforvalter kan sette trekkfrist for utdanningstilbud

    Scenario: Sette trekkfrist for utdanningstilbud
      Når jeg setter trekkfrist for utdanningstilbud til "2027-06-06"
      Så kan læresteder trekke egne utdanningstilbud fram til denne datoen
      Og etter denne datoen kan kun opptakseier trekke utdanningstilbud

  Regel: Opptaksforvalter må kunne avslutte et opptak

    Scenario: Avslutte opptak
      Når jeg avslutter opptaket
      Så er det ikke lenger mulig å gjøre endringer på opptaket
      Og det er ikke lenger mulig å utføre behandling på opptaket