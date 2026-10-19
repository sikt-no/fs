# language: no
# GitHub: #594
@OPT-OPT-UTD-002 @must @draft @scope-utdanningstilbud-i-opptak-2027
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

  Regel: Deltakende organisasjoner kan knytte til og redigere utdanningstilbud bare i perioden opptaket er åpent for redigering
    # Virkningen av når redigering av utdanningstilbud åpner og stenger, som opptaksforvalter setter i
    # 11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature.
    # Lagt til 2026-10-19 etter akseptansetesten av opprette og vedlikeholde opptak.
    # AVKLART 2026-10-15 (Q4, Q5 og Q13, TAKE-410): Fristen stenger alt deltakende organisasjoner endrer på
    # utdanningstilbudet, unntatt antall studieplasser (sette_studieplasser_og_antall_tilbud.feature). I et lokalt
    # opptak er lærestedet selv forvaltende organisasjon, så fristen begrenser ikke lærestedet.
    # AVKLART 2026-10-15 (Q3, TAKE-410): En åpningsdato som ikke er satt, holder redigeringen stengt.
    # Trekking står i trekke_utdanningstilbud.feature.

    Scenario: Kan ikke knytte utdanningstilbud til opptaket før redigering åpner
      Gitt at redigering av utdanningstilbud i opptaket åpner "2026-10-01"
      Og at opptaksforvalter er ved en deltakende organisasjon
      Når opptaksforvalter vil legge til utdanningstilbudet "Sykepleie, høst 2027" i opptaket "2026-09-30"
      Så kan opptaksforvalter ikke legge til utdanningstilbudet "Sykepleie, høst 2027"

    Scenario: Kan knytte til og redigere utdanningstilbud i perioden opptaket er åpent for redigering
      Gitt at redigering av utdanningstilbud i opptaket åpner "2026-10-01" og stenger "2027-06-06"
      Og at opptaksforvalter er ved en deltakende organisasjon
      Når opptaksforvalter legger til utdanningstilbudet "Sykepleie, høst 2027" i opptaket "2026-10-15"
      Så legges utdanningstilbudet "Sykepleie, høst 2027" til i opptaket
      Og opptaksforvalter kan redigere utdanningstilbudet "Sykepleie, høst 2027"

    Scenario: Kan ikke knytte til eller redigere utdanningstilbud etter at redigering stenger
      Gitt at redigering av utdanningstilbud i opptaket stenger "2027-06-06"
      Og at opptaksforvalter er ved en deltakende organisasjon
      Og at utdanningstilbudet "Vernepleie, høst 2027" er lagt til i opptaket
      Når opptaksforvalter åpner opptaket "2027-06-07"
      Så kan opptaksforvalter ikke legge til utdanningstilbud i opptaket
      Og opptaksforvalter kan ikke redigere utdanningstilbudet "Vernepleie, høst 2027"
      Men opptaksforvalter kan fortsatt endre antall studieplasser for utdanningstilbudet "Vernepleie, høst 2027"

    Scenario: Opptaksforvalter ved forvaltende organisasjon kan redigere utdanningstilbud etter at redigering stenger
      Gitt at redigering av utdanningstilbud i opptaket stengte "2027-06-06"
      Og at opptaksforvalter er ved forvaltende organisasjon
      Når opptaksforvalter redigerer utdanningstilbudet "Sykepleie, høst 2027" "2027-06-10"
      Så er endringen på utdanningstilbudet "Sykepleie, høst 2027" lagret

    Scenario: Endringer fra utdanningsregisteret oppdateres etter at redigering stenger
      Gitt at redigering av utdanningstilbud i opptaket stengte "2027-06-06"
      Og at utdanningstilbudet "Sykepleie, høst 2027" er lagt til i opptaket
      Når utdanningen til "Sykepleie, høst 2027" endres i utdanningsregisteret "2027-06-10"
      Så oppdateres utdanningstilbudet "Sykepleie, høst 2027" i opptaket med endringen
