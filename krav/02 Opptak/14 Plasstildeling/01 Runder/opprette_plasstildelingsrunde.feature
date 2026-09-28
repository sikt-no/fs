# language: no
# GitHub: #216
@OPT-PLA-RUN-001 @must @draft
Egenskap: Opprette plasstildelingsrunde
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å opprette første plasstildelingsrunde med datoene jeg har satt for opptaksresultatet
  slik at søkerne får svar og svarfrist på de datoene de er informert om.

  # Datoene settes blant de generelle fristene i opptaket
  # (se 11 Opptak/04 Frister/frister_og_hendelser.feature).
  # Runden opprettes ikke automatisk. Opptaksforvalter oppretter den som en egen
  # oppgave etter at opptaket er laget.

  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet
    Og at opptaksforvalter har satt dato for når hovedopptaket publiseres til "2027-07-15"
    Og at opptaksforvalter har satt første svarfrist til "2027-07-20 23:59"

  Regel: Første plasstildelingsrunde får datoene for opptaksresultat fra opptaket

    Scenario: Opprette første plasstildelingsrunde
      Når opptaksforvalter oppretter første plasstildelingsrunde i opptaket
      Så publiseres runden for søkere "2027-07-15"
      Og runden har svarfrist "2027-07-20 23:59"

    Scenario: Datoene for første plasstildelingsrunde kan ikke endres i runden
      Gitt at første plasstildelingsrunde er opprettet i opptaket
      Når opptaksforvalter ser på første plasstildelingsrunde
      Så kan ikke publiseringsdato og svarfrist endres i runden
      Og datoene kan bare endres blant fristene for opptaket

    Scenario: Første plasstildelingsrunde følger endrede datoer i opptaket
      Gitt at første plasstildelingsrunde er opprettet i opptaket
      Og at runden ikke er publisert
      Når opptaksforvalter endrer dato for når hovedopptaket publiseres til "2027-07-16"
      Og opptaksforvalter endrer første svarfrist til "2027-07-21 23:59"
      Så publiseres runden for søkere "2027-07-16"
      Og runden har svarfrist "2027-07-21 23:59"
