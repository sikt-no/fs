# language: no
@OPT-SØK-SØK-014 @must @draft
Egenskap: Søke på ledige studieplasser
  Som søker
  ønsker jeg å søke på ledige studieplasser i opptaket
  slik at jeg kan få studieplass etter hovedopptaket.

  # Opptaket bestemmer om det tilbyr søknad på ledige studieplasser, og setter datoene for det, i
  # 11 Opprette og vedlikeholde opptak (03 Innstillinger/innstillinger.feature og
  # 04 Frister/frister_og_hendelser.feature). Plasstildelingsrundene for ledige studieplasser står i
  # 14 Plasstildeling/01 Runder/forvalte_runder.feature.
  # Lagt til 2026-10-19 etter akseptansetesten av opprette og vedlikeholde opptak.

  Bakgrunn:
    Gitt at søkeren er innlogget i Min kompetanse

  Regel: Søkeren kan søke på ledige studieplasser bare når opptaket tilbyr det
    # Virkningen av innstillingen for ledige studieplasser som opptaksforvalter setter i
    # 11 Opprette og vedlikeholde opptak/03 Innstillinger/innstillinger.feature.
    # Lagt til 2026-10-19 etter akseptansetesten av opprette og vedlikeholde opptak.

    Scenario: Søkeren kan søke på ledige studieplasser når opptaket tilbyr det
      Gitt at opptaket "Samordna opptak 2027" tilbyr søknad på ledige studieplasser
      Og at søknaden på ledige studieplasser i opptaket "Samordna opptak 2027" har åpnet
      Når søkeren ser på opptaket "Samordna opptak 2027"
      Så ser søkeren muligheten til å søke på ledige studieplasser

    Scenario: Søkeren kan ikke søke på ledige studieplasser når opptaket ikke tilbyr det
      Gitt at opptaket "Samordna opptak 2027" ikke tilbyr søknad på ledige studieplasser
      Når søkeren ser på opptaket "Samordna opptak 2027"
      Så ser ikke søkeren muligheten til å søke på ledige studieplasser

  Regel: Søkeren ser når ledige studieplasser legges ut
    # Virkningen av informasjonsfristen for ledige studieplasser som opptaksforvalter setter i
    # 11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature.
    # Lagt til 2026-10-19 etter akseptansetesten av opprette og vedlikeholde opptak.

    Scenario: Søkeren ser når ledige studieplasser legges ut
      Gitt at opptaket "Samordna opptak 2027" tilbyr søknad på ledige studieplasser
      Og at informasjonsfristen for ledige studieplasser i opptaket "Samordna opptak 2027" er "2027-07-20"
      Når søkeren ser på opptaket "Samordna opptak 2027"
      Så ser søkeren at ledige studieplasser legges ut "2027-07-20"

  Regel: Søkeren kan søke på ledige studieplasser i perioden opptaket har satt
    # Virkningen av datoene for når ledige studieplasser kan søkes og stenger, som opptaksforvalter setter i
    # 11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature.
    # Lagt til 2026-10-19 etter akseptansetesten av opprette og vedlikeholde opptak.
    # AVKLART 2026-10-15 (Q3, TAKE-410 og TAKE-411): En åpningsdato som ikke er satt, holder søknaden på
    # ledige studieplasser stengt.

    Scenario: Søkeren kan søke på ledige studieplasser fra datoen opptaket har satt
      Gitt at ledige studieplasser i opptaket "Samordna opptak 2027" kan søkes fra "2027-07-25"
      Og at ledige studieplasser i opptaket "Samordna opptak 2027" stenger for søkning "2027-09-01"
      Når søkeren søker på en ledig studieplass i opptaket "Samordna opptak 2027" "2027-07-25"
      Så har søkeren søkt på den ledige studieplassen

    Scenario: Søkeren kan ikke søke på ledige studieplasser etter at søkingen har stengt
      Gitt at ledige studieplasser i opptaket "Samordna opptak 2027" stenger for søkning "2027-09-01"
      Når søkeren vil søke på en ledig studieplass i opptaket "Samordna opptak 2027" "2027-09-02"
      Så kan søkeren ikke søke på ledige studieplasser i opptaket "Samordna opptak 2027"
