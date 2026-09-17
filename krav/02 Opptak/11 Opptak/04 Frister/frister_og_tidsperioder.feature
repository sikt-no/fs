# language: no
@OPT-OPT-FRI-001 @must @draft
Egenskap: Frister og tidsperioder for opptak
  Som opptaksforvalter
  ønsker jeg å sette frister som styrer tidsrammene for opptaket
  slik at søkere, saksbehandlere og læresteder vet hva som gjelder når.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at opptaket "Samordna opptak 2027" er opprettet

  Regel: Opptaksforvalter setter søknadsperiode for opptaket

    Scenario: Sette søknadsperiode
      Når jeg setter søknadsperioden fra "2027-02-01 00:00" til "2027-04-15 23:59"
      Så kan søkere sende inn søknader i denne perioden

  Regel: Trekkfrist bestemmer siste tidspunkt for å trekke utdanningstilbud

    Scenario: Sette trekkfrist for utdanningstilbud
      Når jeg setter trekkfrist for utdanningstilbud til "2027-06-15"
      Så kan læresteder ikke trekke utdanningstilbud etter denne datoen

  Regel: Ettersendingsfrist styrer når dokumentasjon kan ettersendes

    Scenario: Sette ettersendingsfrist
      Når jeg setter ettersendingsfrist til "2027-07-01 23:59"
      Så kan søkere ettersende dokumentasjon fram til denne fristen
      Og dokumentasjon mottatt etter fristen er ikke garantert hensyntatt

  Regel: Omprioriteringsfrist styrer når søker kan endre prioriteringer

    Scenario: Sette omprioriteringsfrist
      Når jeg setter omprioriteringsfrist til "2027-04-15 23:59"
      Så kan søkere endre prioritering av søknadsalternativer fram til denne fristen

    Scenario: Omprioriteringsfrist ikke satt bruker søknadsfristen
      Gitt at omprioriteringsfrist ikke er satt
      Så brukes søknadsfristens til-dato som omprioriteringsfrist

  Regel: Frist for realkompetansesøknad kan settes tidligere enn ordinær frist

    Scenario: Sette frist for realkompetansesøknad
      Når jeg setter frist for realkompetansesøknad til "2027-03-01 23:59"
      Så kan søkere med realkompetanse søke fram til denne fristen
      Og fristen er tidligere enn ordinær søknadsfrist fordi realkompetansevurdering krever mer saksbehandlingstid

  Regel: Svarfrist og publiseringstidspunkt settes per plasstildelingsrunde

    Scenario: Sette svarfrist for en runde
      Gitt at opptaket har en plasstildelingsrunde av typen "hovedtildeling"
      Når jeg setter svarfrist for runden til "2027-07-20 23:59"
      Så mister søkere som ikke har svart innen fristen tilbudet sitt

    Scenario: Sette publiseringstidspunkt for en runde
      Gitt at opptaket har en plasstildelingsrunde av typen "hovedtildeling"
      Når jeg setter publiseringstidspunkt til "2027-07-15 09:00"
      Så blir resultatet synlig for søkere på dette tidspunktet

  Regel: Frist for endring av svar settes for hele opptaket

    Scenario: Sette frist for endring av svar
      Når jeg setter frist for endring av svar til "2027-08-01 23:59"
      Så kan søkere endre et allerede avgitt svar fram til denne fristen
