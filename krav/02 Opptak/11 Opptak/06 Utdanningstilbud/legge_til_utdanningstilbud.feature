# language: no
@OPT-OPT-UTD-002 @must @draft
Egenskap: Legge til utdanningstilbud i opptak
  Som opptaksforvalter
  ønsker jeg å legge til utdanningstilbud i opptaket
  slik at søkere kan søke på utdanningene.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at opptaket "Samordna opptak 2027" er opprettet med deltakende organisasjoner

  Regel: Opptaksforvalter ved deltakende organisasjon kan legge til alle sine utdanningstilbud

    Scenario: Legge til alle utdanningstilbud fra min organisasjon
      Gitt at jeg er opptaksforvalter ved en deltakende organisasjon
      Når jeg velger å legge til alle utdanningstilbud fra min organisasjon som matcher opptakets kriterier
      Så legges alle relevante utdanningstilbud fra min organisasjon til i opptaket

  Regel: Opptaksforvalter ved deltakende organisasjon kan legge til enkelttilbud

    Scenario: Legge til enkelttilbud fra min organisasjon
      Gitt at jeg er opptaksforvalter ved en deltakende organisasjon
      Når jeg velger å legge til utdanningstilbudet "Sykepleie, høst 2027" fra min organisasjon
      Så legges utdanningstilbudet til i opptaket

  Regel: Opptakseier kan legge til utdanningstilbud for alle deltakende organisasjoner

    Scenario: Opptakseier legger til utdanningstilbud for en annen organisasjon
      Gitt at jeg er opptaksforvalter ved eierorganisasjonen
      Når jeg velger å legge til utdanningstilbud fra organisasjonen "Universitetet i Oslo"
      Så legges utdanningstilbudene fra Universitetet i Oslo til i opptaket

  Regel: Kun utdanningstilbud fra deltakende organisasjoner kan legges til

    Scenario: Organisasjon som ikke deltar kan ikke legge til utdanningstilbud
      Gitt at organisasjonen "NTNU" ikke er lagt til som deltaker i opptaket
      Så kan ikke utdanningstilbud fra NTNU legges til i opptaket

  Regel: Kun utdanningstilbud som matcher opptakets kriterier kan legges til

    Scenario: Utdanning som ikke matcher kriteriene kan ikke legges til
      Gitt at opptaket kun tillater studieprogram på bachelornivå
      Så kan ikke et emne legges til som utdanningstilbud
      Og et studieprogram på masternivå kan ikke legges til