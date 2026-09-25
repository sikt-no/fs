# language: no
@OPT-OPT-FRI-001 @must @draft
Egenskap: Frister og hendelser for opptak
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å sette frister som styrer tidsrammene for opptaket
  slik at søkere, saksbehandlere og læresteder vet hva som gjelder når.

  # Disse fristene gjelder for alle utdanningstilbud og alle søkere i opptaket,
  # med mindre det er satt avvikende frister på utdanningstilbud eller utdanningsbakgrunn.
  # I samordna opptak kan kun opptaksforvalter ved forvaltende organisasjon endre frister for opptaket.

  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne åpne og stenge for redigering av utdanningstilbud

    Scenario: Opptaksforvalter må kunne åpne for tilknytning og redigering av utdanningstilbud
      Når opptaksforvalter setter at redigering av utdanningstilbud åpner "2026-10-01"
      Så kan deltakende organisasjoner redigere sine utdanningstilbud fra denne dagen
      Og deltakende organisasjoner kan knytte sine utdanningstilbud til opptak fra denne dagen
      Og deltakende organisasjoner kan trekke sine utdanningstilbud fra opptak fra denne dagen

    Scenario: Opptaksforvalter må kunne stenge for tilknytning og redigering av utdanningstilbud
      Når opptaksforvalter setter at redigering av utdanningstilbud stenger "2027-06-06"
      Så kan deltakende organisasjoner ikke lenger redigere sine utdanningstilbud
      Og deltakende organisasjoner kan ikke lenger knytte sine utdanningstilbud til opptaket
      Og deltakende organisasjoner kan ikke lenger trekke sine utdanningstilbud fra opptaket
      Men antall studieplasser kan fortsatt redigeres fram til første plasstildelingsrunde kjøres
      Og kun opptaksforvalter ved forvaltende organisasjon kan trekke utdanningstilbud etter stengingsdato

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne åpne for søkning

    Scenario: Sette søknadsdato
      Når opptaksforvalter setter at søknaden åpner "2027-02-01"
      Så kan søkere opprette og sende inn søknader fra denne datoen
      Og utdanningstilbudene i opptaket er synlige for søkere

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette generell søknadsfrist for opptaket

    Scenario: Sette ordinær søknadsfrist
      Når opptaksforvalter setter ordinær søknadsfrist til "2027-04-15 23:59"
      Så kan søkere sende inn nye søknader fram til denne fristen
      Og etter fristen er det ikke lenger mulig å sende inn nye søknader

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette omprioriteringsfrist

    Scenario: Sette omprioriteringsfrist
      Når opptaksforvalter setter omprioriteringsfrist til "2027-04-15 23:59"
      Så kan søkere endre prioritering av søknadsalternativer fram til denne fristen
      Og etter fristen er rekkefølgen på søknadsalternativene låst

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for sletting av søknadsalternativer

    Scenario: Sette frist for sletting av søknadsalternativer
      Når opptaksforvalter setter frist for sletting av søknadsalternativer til "2027-04-15 23:59"
      Så kan søkere slette søknadsalternativer fra søknaden sin fram til denne fristen
      Og etter fristen kan ikke søkere slette søknadsalternativer

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette dokumentasjonsfrister

    Scenario: Sette ordinær dokumentasjonsfrist
      Når opptaksforvalter setter ordinær dokumentasjonsfrist til "2027-04-15 23:59"
      Så kan søkere laste opp dokumentasjon fram til denne fristen
      Og etter fristen kan ikke søkere laste opp ny dokumentasjon

    Scenario: Sette tidlig dokumentasjonsfrist for søkere med tidlig søknadsfrist
      Når opptaksforvalter setter tidlig dokumentasjonsfrist til "2027-03-01 23:59"
      Så kan søkere med tidlig søknadsfrist laste opp dokumentasjon fram til denne fristen
      Og etter fristen kan ikke disse søkerne laste opp ny dokumentasjon

    Scenario: Sette ettersendingsfrist
      Når opptaksforvalter setter ettersendingsfrist til "2027-07-01 23:59"
      Så kan søkere ettersende dokumentasjon fram til denne fristen
      Og etter fristen kan ikke søkere ettersende dokumentasjon

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette informasjonsdatoer for ledige studieplasser

    Scenario: Sette informasjonsfrist for ledige studieplasser
      Gitt at opptaket tilbyr søknad på ledige studieplasser
      Når opptaksforvalter setter informasjonsfrist for ledige studieplasser til "2027-07-20"
      Så kan søkere se når restplasser legges ut

    Scenario: Sette dato for når ledige studieplasser kan søkes
      Gitt at opptaket tilbyr søknad på ledige studieplasser
      Når opptaksforvalter setter at ledige studieplasser kan søkes fra "2027-07-25"
      Så kan søkere søke på ledige studieplasser fra denne datoen

    Scenario: Sette dato for når ledige studieplasser stenger for søkning
      Gitt at opptaket tilbyr søknad på ledige studieplasser
      Når opptaksforvalter setter at ledige studieplasser stenger for søkning "2027-09-01"
      Så kan søkere ikke lenger søke på ledige studieplasser etter denne datoen

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Er frister for tidlig opptak generelle frister på opptaksnivå,
  #   eller er de unntak per utdanningstilbud/utdanningsbakgrunn?
  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frister for tidlig opptak

    Scenario: Sette søknadsfrist for tidlig opptak
      Gitt at opptaket har aktivert tidlig opptak
      Når opptaksforvalter setter søknadsfrist for tidlig opptak til "2027-03-01 23:59"
      Så kan søkere søke om tidlig opptak fram til denne fristen
      Og etter fristen behandles søknaden i det ordinære opptaket

    Scenario: Sette dokumentasjonsfrist for tidlig opptak
      Gitt at opptaket har aktivert tidlig opptak
      Når opptaksforvalter setter dokumentasjonsfrist for tidlig opptak til "2027-03-01 23:59"
      Så må søkere som søker tidlig opptak laste opp dokumentasjon innen denne fristen
      Og etter fristen kan ikke disse søkerne laste opp ny dokumentasjon for tidlig opptak

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette informasjonsdatoer for opptaksresultat

    Scenario: Sette dato for når hovedopptaket kjøres
      Når opptaksforvalter setter dato for når hovedopptaket kjøres til "2027-07-15"
      Så informeres søkere om når tilbud og ventelisteplasser tildeles

    Scenario: Sette dato for når søker kan forvente svar
      Når opptaksforvalter setter dato for når søker kan forvente svar til "2027-07-15"
      Så kan søkere se når de kan forvente svar på søknaden

    # Faktiske svarfrister og publiseringstidspunkter settes per plasstildelingsrunde
    Scenario: Sette første svarfrist som informasjon til søkere
      Når opptaksforvalter setter første svarfrist til "2027-07-20 23:59"
      Så kan søkere se når de senest må svare på et eventuelt tilbud

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Gjelder selvbetjent endring av utdanningsbakgrunn for søker (student)
  #   eller for saksbehandler? Eller begge?
  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for endring av utdanningsbakgrunn

    Scenario: Sette frist for selvbetjent endring av utdanningsbakgrunn
      Når opptaksforvalter setter frist for endring av utdanningsbakgrunn til "2027-05-01 23:59"
      Så kan søkere endre sin utdanningsbakgrunn selv fram til denne fristen
      Og etter fristen kan ikke søkere endre utdanningsbakgrunn selv

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - I dag kan læresteder trekke egne utdanningstilbud fram til en satt dato
  #   (f.eks. 6. juni for samordna opptak). Etter denne datoen kan kun opptakseier trekke.
  #   Skal vi videreføre denne begrensningen, eller skal det være åpent for at
  #   lærestedene håndterer det selv?
  # - Bør trekkfristen være en informasjonsfrist (forvaltningsfrist uten faktisk
  #   stengeeffekt) i stedet for en hard sperre?
  Regel: Opptaksforvalter ved forvaltende organisasjon kan sette trekkfrist for utdanningstilbud

    Scenario: Sette trekkfrist for utdanningstilbud
      Når opptaksforvalter setter trekkfrist for utdanningstilbud til "2027-06-06"
      Så kan læresteder trekke egne utdanningstilbud fram til denne datoen
      Og etter denne datoen kan kun opptaksforvalter ved forvaltende organisasjon trekke utdanningstilbud

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne deaktivere et opptak

    Scenario: Deaktivere opptak
      Når opptaksforvalter deaktiverer opptaket
      Så settes opptaket til utløpt
      Og det er ikke lenger mulig å gjøre endringer på opptaket
      Og det er ikke lenger mulig å utføre søknadsbehandling eller plasstildeling i opptaket
      Men opptaket kan brukes som grunnlag for å opprette et nytt opptak

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Design.md beskriver interne saksbehandlingsfrister som ikke er dekket her:
  #   opptakskomite, opptaksprøver, utenlandsk utdanning, generell saksbehandlingsfrist.
  #   Skal disse settes som generelle frister i opptaket, eller hører de hjemme
  #   i saksbehandlingsdomenet?
  # - Mangler det andre frister som bør settes på opptaksnivå?
  Regel: Opptaksforvalter ved forvaltende organisasjon kan sette interne saksbehandlingsfrister

    Scenario: Sette generell saksbehandlingsfrist
      Når opptaksforvalter setter generell saksbehandlingsfrist for opptaket
      Så kan ikke saksbehandlere gjøre endringer på søknader etter denne fristen