# language: no
# GitHub: #594
@OPT-OPT-UTD-002 @must @draft
Egenskap: Legge til utdanningstilbud i opptak
  Som opptaksforvalter
  ønsker jeg å legge til utdanningstilbud i opptaket
  slik at søkere kan søke på utdanningene.

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet med deltakende organisasjoner

  Regel: Opptaksforvalter ved deltakende organisasjon kan legge til alle sine utdanningstilbud

    Scenario: Legge til alle utdanningstilbud fra egen organisasjon
      Gitt at opptaksforvalter er ved en deltakende organisasjon
      Når opptaksforvalter velger å legge til alle utdanningstilbud fra egen organisasjon som matcher opptakets kriterier
      Så legges alle relevante utdanningstilbud fra organisasjonen til i opptaket

  Regel: Opptaksforvalter ved deltakende organisasjon kan legge til enkelttilbud

    Scenario: Legge til enkelttilbud fra egen organisasjon
      Gitt at opptaksforvalter er ved en deltakende organisasjon
      Når opptaksforvalter velger å legge til utdanningstilbudet "Sykepleie, høst 2027" fra egen organisasjon
      Så legges utdanningstilbudet til i opptaket

  Regel: Opptaksforvalter kan legge til flere utdanningstilbud av gangen

    Scenario: Legge til flere utdanningstilbud av gangen
      Gitt at opptaksforvalter er ved en deltakende organisasjon
      Når opptaksforvalter velger å legge til utdanningstilbudene "Sykepleie, høst 2027" og "Vernepleie, høst 2027"
      Så legges begge utdanningstilbudene til i opptaket

  Regel: Opptaksforvalter ved forvaltende organisasjon kan legge til utdanningstilbud for alle deltakende organisasjoner

    Scenario: Opptaksforvalter ved forvaltende organisasjon legger til utdanningstilbud for en annen organisasjon
      Gitt at opptaksforvalter er ved forvaltende organisasjon
      Når opptaksforvalter velger å legge til utdanningstilbud fra organisasjonen "Universitetet i Oslo"
      Så legges utdanningstilbudene fra Universitetet i Oslo til i opptaket

  Regel: Kun utdanningstilbud fra deltakende organisasjoner kan legges til

    Scenario: Organisasjon som ikke deltar kan ikke legge til utdanningstilbud
      Gitt at organisasjonen "NTNU" ikke er lagt til som deltaker i opptaket
      Så kan ikke utdanningstilbud fra NTNU legges til i opptaket

  Regel: Opptaksforvalter kan filtrere på utdanningstype og studienivå når utdanningstilbud legges til

    Scenario: Filtrere på utdanningstype
      Når opptaksforvalter filtrerer på utdanningstype studieprogram
      Så vises kun studieprogram som mulige utdanningstilbud

    Scenario: Filtrere på NKR-nivå for UHG-opptak
      Når opptaksforvalter filtrerer på utdanningstype studieprogram
      Og opptaksforvalter filtrerer på NKR-nivåene 6.1 Høgskolekandidat, 6.2 Bachelor, 7 Master
      Så vises kun studieprogram på disse nivåene som mulige utdanningstilbud

    Scenario: Filtrere på NKR-nivå for HYU-opptak
      Når opptaksforvalter filtrerer på utdanningstype studieprogram
      Og opptaksforvalter filtrerer på NKR-nivåene 5.1 fagskole og 5.2 fagskole
      Så vises kun fagskoleutdanninger av typen studieprogram som mulige utdanningstilbud

    Scenario: Utdanninger utenfor filteret vises ikke
      Gitt at opptaksforvalter har filtrert på studieprogram på 6.2 bachelornivå
      Så vises ikke emner som mulige utdanningstilbud
      Og studieprogram på 7 masternivå vises ikke som mulige utdanningstilbud