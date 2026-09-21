# language: no
@OPT-OPT-FRI-001 @must @draft
Egenskap: Frister og tidsperioder for opptak
  Som opptaksforvalter
  ønsker jeg å sette frister som styrer tidsrammene for opptaket
  slik at søkere, saksbehandlere og læresteder vet hva som gjelder når.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at opptaket "Samordna opptak 2027" er opprettet

  Regel: Opptaksforvalter må kunne åpne for søkning

    Scenario: Åpne opptaket for søkning
      Når jeg åpner opptaket for søkning
      Så kan søkere begynne å sende inn søknader

  Regel: Opptaksforvalter må kunne sette dato for når søker kan forvente svar på søknad i opptaket

    Scenario: Sette informasjonsfrist
      Når jeg setter dato for når søker kan forvente svar til "2027-07-15"
      Så kan søkere se når de kan forvente svar på søknaden

  Regel: Opptaksforvalter må kunne sette generell søknadsfrist for opptaket

    Scenario: Sette generell søknadsfrist
      Når jeg setter generell søknadsfrist til "2027-04-15 23:59"
      Så gjelder fristen for alle utdanningstilbud i opptaket

    Scenario: Utdanningstilbud med unntaksfrist
      Gitt at den generelle søknadsfristen er "2027-04-15 23:59"
      Og at utdanningstilbudet "Politihøyskolen, høst 2027" har en tidligere søknadsfrist
      Så gjelder unntaksfristen for det utdanningstilbudet
      Og den generelle fristen gjelder for alle andre utdanningstilbud

  Regel: Opptaksforvalter må kunne sette spesielle søknadsfrister for søkere med gitte utdanningsbakgrunner

    Scenario: Sette frist for realkompetansesøkere
      Når jeg setter søknadsfrist for utdanningsbakgrunnen "Realkompetanse" til "2027-03-01 23:59"
      Så gjelder denne fristen for søkere som søker med realkompetanse
      Og fristen kan være tidligere enn den generelle søknadsfristen fordi vurderingen krever mer saksbehandlingstid

    Scenario: Sette frist for søkere med utenlandsk utdanning
      Når jeg setter søknadsfrist for utdanningsbakgrunnen "Utenlandsk utdanning" til "2027-03-01 23:59"
      Så gjelder denne fristen for søkere som søker med utenlandsk utdanning

  Regel: Opptaksforvalter må kunne sette frist for ettersending av dokumentasjon

    Scenario: Sette ettersendingsfrist
      Når jeg setter ettersendingsfrist til "2027-07-01 23:59"
      Så kan søkere ettersende dokumentasjon fram til denne fristen
      Og dokumentasjon mottatt etter fristen er ikke garantert hensyntatt

  Regel: Opptaksforvalter må kunne sette frist for omprioritering av søknad

    Scenario: Sette omprioriteringsfrist
      Når jeg setter omprioriteringsfrist til "2027-04-15 23:59"
      Så kan søkere endre prioritering av søknadsalternativer fram til denne fristen

  Regel: Opptaksforvalter må kunne sette frist for å svare på tilbud

    Scenario: Sette svarfrist
      Når jeg setter svarfrist for søkere til "2027-07-20 23:59"
      Så mister søkere som ikke har svart innen fristen tilbudet sitt

  Regel: Opptaksforvalter må kunne sette frist for endring av svar

    Scenario: Sette frist for endring av svar
      Når jeg setter frist for endring av svar til "2027-08-01 23:59"
      Så kan søkere endre et allerede avgitt svar fram til denne fristen

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