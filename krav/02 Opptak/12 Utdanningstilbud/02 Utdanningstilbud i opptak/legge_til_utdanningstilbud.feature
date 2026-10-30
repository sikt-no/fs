# language: no
# GitHub: #594
@OPT-OPT-UTD-002 @must @in-progress @scope-utdanningstilbud-i-opptak-2027
Egenskap: Legge til utdanningstilbud i opptak
  Som opptaksforvalter
  ønsker jeg å legge til utdanningstilbud i opptaket
  slik at søkere kan søke på utdanningene.

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet med deltakende organisasjoner

  @implemented
  Regel: Opptaksforvalter ved deltakende organisasjon kan legge til enkelttilbud

    Scenario: Legge til enkelttilbud fra organisasjonen opptaksforvalter er ved
      Gitt at opptaksforvalter er ved en deltakende organisasjon
      Når opptaksforvalter velger å legge til utdanningstilbudet "Sykepleie, høst 2027" fra organisasjonen opptaksforvalter er ved
      Så legges utdanningstilbudet til i opptaket

  Regel: Opptaksforvalter kan legge til flere utdanningstilbud av gangen

    @implemented
    Scenario: Legge til flere utdanningstilbud av gangen
      Gitt at opptaksforvalter er ved en deltakende organisasjon
      Når opptaksforvalter velger å legge til utdanningstilbudene "Sykepleie, høst 2027" og "Vernepleie, høst 2027"
      Så legges begge utdanningstilbudene til i opptaket

    @openquestion
    Scenario: Legge til alle utdanningstilbudene i en filtrert liste
      # ÅPNE SPØRSMÅL:
      # - Delvis levert (verify 2026-10-22): «Velg alle» i fs-admin velger bare radene som er lastet (50 om gangen), så med flere enn 50 treff må opptaksforvalter laste inn alle først. Er det godt nok, eller skal «velg alle» ta med alle treffene i den filtrerte listen?
      Gitt at opptaksforvalter har filtrert listen over utdanningstilbud som kan legges til
      Når opptaksforvalter velger alle utdanningstilbudene i listen og legger dem til i opptaket
      Så legges alle utdanningstilbudene i den filtrerte listen til i opptaket

  @depends-on-OPT-OPT-UTD-005
  Regel: Opptaksforvalter ser campus for utdanningstilbudene som kan legges til

    Scenario: Se campus i listen over utdanningstilbud som kan legges til
      Gitt at utdanningsregisteret har bachelorprogrammet "Sykepleie" med studiestart høst 2027 på campusene "Blindern" og "Kjeller"
      Når opptaksforvalter åpner listen over utdanningstilbud som kan legges til i opptaket
      Så ser opptaksforvalter to utdanningstilbud "Sykepleie, høst 2027"
      Og campus vises for hvert av utdanningstilbudene

    Scenario: Legge til utdanningstilbudet på én campus
      Gitt at utdanningsregisteret har bachelorprogrammet "Sykepleie" med studiestart høst 2027 på campusene "Blindern" og "Kjeller"
      Når opptaksforvalter legger til utdanningstilbudet "Sykepleie, høst 2027" på campus "Kjeller"
      Så legges utdanningstilbudet "Sykepleie, høst 2027" på campus "Kjeller" til i opptaket
      Og utdanningstilbudet "Sykepleie, høst 2027" på campus "Blindern" kan fortsatt legges til

  @implemented
  Regel: Opptaksforvalter ved forvaltende organisasjon kan legge til utdanningstilbud for alle deltakende organisasjoner

    Scenario: Opptaksforvalter ved forvaltende organisasjon legger til utdanningstilbud for en annen organisasjon
      Gitt at opptaksforvalter er ved forvaltende organisasjon
      Når opptaksforvalter velger å legge til utdanningstilbud fra organisasjonen "Universitetet i Oslo"
      Så legges utdanningstilbudene fra Universitetet i Oslo til i opptaket

  @implemented
  Regel: Kun utdanningstilbud fra deltakende organisasjoner kan legges til

    # AVKLART 2026-10-22: Det holder at utdanningstilbud fra organisasjoner som ikke deltar, ikke kan velges.
    Scenario: Organisasjon som ikke deltar kan ikke legge til utdanningstilbud
      Gitt at organisasjonen "NTNU" ikke er lagt til som deltaker i opptaket
      Så kan ikke utdanningstilbud fra NTNU legges til i opptaket

  @depends-on-OPT-OPT-UTD-005 @ref-FLY-OPT-KLA-001
  Regel: Opptaksforvalter ser kun utdanningstilbud som matcher opptakets kriterier

    Scenario: Se relevante utdanningstilbud
      Gitt at opptaket tillater studieprogram på bachelornivå
      Når opptaksforvalter åpner listen over utdanningstilbud som kan legges til i opptaket
      Så ser opptaksforvalter kun studieprogram på bachelornivå fra deltakende organisasjoner

  @openquestion
  Regel: Opptaksforvalter kan filtrere på utdanningstype og studienivå når utdanningstilbud legges til
    # ÅPNE SPØRSMÅL:
    # - Delvis levert (verify 2026-10-22): utdanningsregisteret har filter på NKR-kode og studienivå, men ikke på utdanningstype. fs-admin har studienivåfilteret Høgskolekandidat/Bachelor/Master (NKR 6.1, 6.2 og 7), men ikke filter på utdanningstype eller NKR 5.1/5.2, og sender ikke NKR-kode-filteret. Skal filteret på utdanningstype og NKR 5.1/5.2 bygges i utdanningsregisteret og fs-admin?

    Scenario: Filtrere på utdanningstype
      Når opptaksforvalter filtrerer på utdanningstype studieprogram
      Så vises kun studieprogram som mulige utdanningstilbud

    Scenario: Filtrere på NKR-nivå for UHG-opptak
      Når opptaksforvalter filtrerer på utdanningstype studieprogram
      Og opptaksforvalter filtrerer på NKR-nivåene 6.1 Høgskolekandidat, 6.2 Bachelor, 7 Master
      Så vises kun studieprogram på NKR-nivåene 6.1, 6.2 og 7 som mulige utdanningstilbud

    Scenario: Filtrere på NKR-nivå for HYU-opptak
      Når opptaksforvalter filtrerer på utdanningstype studieprogram
      Og opptaksforvalter filtrerer på NKR-nivåene 5.1 fagskole og 5.2 fagskole
      Så vises kun fagskoleutdanninger av typen studieprogram som mulige utdanningstilbud

    Scenario: Utdanninger utenfor filteret vises ikke
      Gitt at opptaksforvalter har filtrert på studieprogram på 6.2 bachelornivå
      Så vises ikke emner som mulige utdanningstilbud
      Og studieprogram på 7 masternivå vises ikke som mulige utdanningstilbud

  @depends-on-OPT-OVO-FRI-001 @ref-OPT-OPT-UTD-007 @ref-OPT-OPT-UTD-003 @ref-FLY-OPT-KLA-001
  Regel: Deltakende organisasjoner kan knytte til og redigere utdanningstilbud bare i perioden opptaket er åpent for redigering
    # Virkningen av når redigering av utdanningstilbud åpner og stenger, som opptaksforvalter setter i fristene for opptaket.
    # Lagt til 2026-10-19 etter akseptansetesten av opprette og vedlikeholde opptak.
    # AVKLART 2026-10-15 (Q4, Q5 og Q13, TAKE-410): Fristen stenger alt deltakende organisasjoner endrer på
    # utdanningstilbudet, unntatt antall studieplasser. I et lokalt
    # opptak er lærestedet selv forvaltende organisasjon, så fristen begrenser ikke lærestedet.
    # AVKLART 2026-10-15 (Q3, TAKE-410): En åpningsdato som ikke er satt, holder redigeringen stengt.

    @implemented
    Scenario: Kan ikke knytte utdanningstilbud til opptaket før redigering åpner
      Gitt at redigering av utdanningstilbud i opptaket åpner "2026-10-01"
      Og at opptaksforvalter er ved en deltakende organisasjon
      Når opptaksforvalter vil legge til utdanningstilbudet "Sykepleie, høst 2027" i opptaket "2026-09-30"
      Så kan opptaksforvalter ikke legge til utdanningstilbudet "Sykepleie, høst 2027"

    Scenario: Redigering er stengt når åpningsdatoen ikke er satt
      Gitt at det ikke er satt når redigering av utdanningstilbud i opptaket åpner
      Og at opptaksforvalter er ved en deltakende organisasjon
      Når opptaksforvalter vil legge til utdanningstilbudet "Sykepleie, høst 2027" i opptaket
      Så kan opptaksforvalter ikke legge til utdanningstilbudet "Sykepleie, høst 2027"

    @implemented
    Scenario: Kan knytte til og redigere utdanningstilbud i perioden opptaket er åpent for redigering
      Gitt at redigering av utdanningstilbud i opptaket åpner "2026-10-01" og stenger "2027-06-06"
      Og at opptaksforvalter er ved en deltakende organisasjon
      Når opptaksforvalter legger til utdanningstilbudet "Sykepleie, høst 2027" i opptaket "2026-10-15"
      Så legges utdanningstilbudet "Sykepleie, høst 2027" til i opptaket
      Og opptaksforvalter kan redigere utdanningstilbudet "Sykepleie, høst 2027"

    @implemented
    # AVKLART 2026-10-22: Det holder at muligheten skjules for deltakende organisasjoner.
    Scenario: Kan ikke knytte til eller redigere utdanningstilbud etter at redigering stenger
      Gitt at redigering av utdanningstilbud i opptaket stenger "2027-06-06"
      Og at opptaksforvalter er ved en deltakende organisasjon
      Og at utdanningstilbudet "Vernepleie, høst 2027" er lagt til i opptaket
      Når opptaksforvalter åpner opptaket "2027-06-07"
      Så kan opptaksforvalter ikke legge til utdanningstilbud i opptaket
      Og opptaksforvalter kan ikke redigere utdanningstilbudet "Vernepleie, høst 2027"
      Men opptaksforvalter kan fortsatt endre antall studieplasser for utdanningstilbudet "Vernepleie, høst 2027"

    @implemented
    Scenario: Opptaksforvalter ved forvaltende organisasjon kan redigere utdanningstilbud etter at redigering stenger
      Gitt at redigering av utdanningstilbud i opptaket stengte "2027-06-06"
      Og at opptaksforvalter er ved forvaltende organisasjon
      Når opptaksforvalter redigerer utdanningstilbudet "Sykepleie, høst 2027" "2027-06-10"
      Så er endringen på utdanningstilbudet "Sykepleie, høst 2027" lagret

    @openquestion
    Scenario: Endringer fra utdanningsregisteret oppdateres etter at redigering stenger
      # ÅPNE SPØRSMÅL:
      # - Delvis levert (verify 2026-10-22): dataene fra utdanningsregisteret kopieres inn bare når utdanningstilbudet legges til eller oppdateres, og ingen jobb oppdaterer utdanningstilbudene etter at redigering stenger. Skal oppdateringen bygges som en jobb i fs-plattform?
      Gitt at redigering av utdanningstilbud i opptaket stengte "2027-06-06"
      Og at utdanningstilbudet "Sykepleie, høst 2027" er lagt til i opptaket
      Når utdanningen til "Sykepleie, høst 2027" endres i utdanningsregisteret "2027-06-10"
      Så oppdateres utdanningstilbudet "Sykepleie, høst 2027" i opptaket med endringen

  Regel: Opptaksforvalter ved deltakende organisasjon kan bare redigere utdanningstilbud organisasjonen tilbyr
    # Jira: SHI-747

    Scenario: Deltakende organisasjon kan ikke redigere utdanningstilbud en annen organisasjon tilbyr
      Gitt at opptaksforvalter er ved deltakende organisasjon "Universitetet i Oslo"
      Og at redigering av utdanningstilbud er åpen i opptaket
      Når det sendes en forespørsel om å redigere utdanningstilbudet "Vernepleie, høst 2027", som "Universitetet i Bergen" tilbyr
      Så avvises forespørselen
      Og utdanningstilbudet "Vernepleie, høst 2027" er ikke endret
