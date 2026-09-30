# language: no
@OPT-OPT-FRI-001 @must @in-progress
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

    Scenario: Opptaksforvalter må kunne stenge for tilknytning, redigering og trekking av utdanningstilbud
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

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frister for tidlig opptak

    Scenario: Sette søknadsfrist for tidlig opptak
      Gitt at opptaket har aktivert tidlig opptak
      Når opptaksforvalter setter søknadsfrist for tidlig opptak til "2027-03-01 23:59"
      Så kan søkere søke om tidlig opptak fram til denne fristen
      Og etter fristen behandles søknaden i det ordinære opptaket

    Scenario: Sette dokumentasjonsfrist for tidlig opptak
      Gitt at opptaket har aktivert tidlig opptak
      Når opptaksforvalter setter dokumentasjonsfrist for tidlig opptak til "2027-03-01 23:59"
      Så informeres søkere om at de skal laste opp dokumentasjon innen denne fristen

    Scenario: Sette frist for poenggrenser for tidlig opptak
      Gitt at opptaket har aktivert tidlig opptak
      Når opptaksforvalter setter frist for å sette poenggrenser for tidlig opptak til "2027-02-15 23:59"
      Så må deltagende organisasjoner sette poenggrenser for tidlig opptak innen denne fristen

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette informasjonsdatoer for opptaksresultat
    # Faktiske svarfrister og publiseringstidspunkter settes per plasstildelingsrunde

    Scenario: Sette dato for når hovedopptaket publiseres og søker kan forvente svar
      Når opptaksforvalter setter dato for når hovedopptaket publiseres til "2027-07-15"
      Så informeres søkere om når de kan forvente svar på søknaden fra første opptaksrunde

    Scenario: Sette første svarfrist som informasjon til søkere
      Når opptaksforvalter setter første svarfrist til "2027-07-20 23:59"
      Så kan søkere se når de senest må svare på et eventuelt tilbud

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for endring av utdanningsbakgrunn

    Scenario: Sette frist for at saksbehandler kan endre søkers utdanningsbakgrunn
      Når opptaksforvalter setter frist for endring av utdanningsbakgrunn til "2027-05-01 23:59"
      Så kan saksbehandlere endre søkers utdanningsbakgrunn fram til denne fristen
      Og etter fristen kan saksbehandler ikke endre søkers utdanningsbakgrunn

  Regel: Opptaksforvalter kan legge til utdanningsbakgrunner med avvikende frister
    # Opptaksforvalter legger eksplisitt til utdanningsbakgrunner som skal ha
    # egne søknads- og dokumentasjonsfrister. Utdanningsbakgrunner uten avvikende
    # frister trenger ikke registreres — søkere følger da opptakets generelle frister.
    # At søker faktisk får riktig frist basert på utdanningsbakgrunn er et krav
    # til søknad og saksbehandling (se 13 Søknad og saksbehandling/).

    Scenario: Legge til utdanningsbakgrunn med avvikende frister
      Når opptaksforvalter legger til utdanningsbakgrunnen "Realkompetanse" i opptaket
      Og opptaksforvalter setter søknadsfrist til "2027-03-01 23:59"
      Og opptaksforvalter setter dokumentasjonsfrist til "2027-03-01 23:59"
      Så får søkere med utdanningsbakgrunnen "Realkompetanse" egne søknads- og dokumentasjonsfrister i opptaket

    Scenario: Søker uten registrert utdanningsbakgrunn følger ordinære frister
      Gitt at det ikke er lagt til utdanningsbakgrunn for norsk videregående skole i opptaket
      Når en søker søker med norsk videregående skole som utdanningsbakgrunn
      Så gjelder de generelle fristene i opptaket
