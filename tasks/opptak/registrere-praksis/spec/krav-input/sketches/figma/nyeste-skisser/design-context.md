# Designkontekst — «Nyeste skisser»

- **Figma:** https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=20747-108803
- **fileKey:** `LmoNQlmAuE2FlE0fUo5GoO`, **nodeId:** `20747:108803` (seksjon «Nyeste skisser»)
- **Hentet:** 2026-10-06, med `get_metadata` (nodehierarki) og `get_screenshot`

`get_design_context` ble ikke brukt: hierarkiet fra `get_metadata` var nok til å finne rammene. Tekstene står som overstyringer i komponentinstansene, så lagnavnene er generiske («Label text», «Date input»). Tekstene under er lest av skjermbildene.

## Hierarki (ett nivå)

| # | Node | Type | Navn | Skjermbilde |
|---|---|---|---|---|
| 01 | `20610:102740` | INSTANCE | Sidelayout i FS Admin - Pattern | [01-sidelayout-i-fs-admin-pattern.png](sub-frames/01-sidelayout-i-fs-admin-pattern.png) |
| 02 | `21126:115199` | INSTANCE | ModalOnBackground | [02-dialog-legg-til-praksisperiode.png](sub-frames/02-dialog-legg-til-praksisperiode.png) |
| 03 | `21363:9533` | INSTANCE | ModalOnBackground | [03-dialog-sluttdato-for-startdato.png](sub-frames/03-dialog-sluttdato-for-startdato.png) |
| 04 | `21363:9774` | INSTANCE | ModalOnBackground | [04-dialog-mangler-datoer.png](sub-frames/04-dialog-mangler-datoer.png) |
| 05 | `21363:9938` | INSTANCE | ModalOnBackground | [05-dialog-ugyldig-dato.png](sub-frames/05-dialog-ugyldig-dato.png) |

Dialogene heter alle `ModalOnBackground` i Figma. Filnavnene beskriver tilstanden de viser.

## 01 — Sidevisning «Praksiskalkulator»

- Brødsmuler: «Hjem» › «Nivå 2» › «Samordna opptak 2025». Sidetittel: «Praksiskalkulator».
- Kort «Registrerte praksisperioder», undertekst «4 registrerte perioder».
- Tabell med kolonnene «Arbeidsgiver/praksistype», «Periode», «Omfang», «Beregnet praksis», «Inkluder», «Handlinger».
  - Arbeidsgiver i fet skrift, praksistype som «KODE – navn» under.
  - Periode som «01.01.2020–31.12.2020». Varselikon (gult) ved periodene som overlapper.
  - Omfang som «100%», «75%», «50%», eller «850 timer (av 1700)».
  - Beregnet praksis som «1,00 år».
  - Inkluder som avkrysningsboks.
  - Handlinger: «Rediger» (knapp) og «Slett» (med søppelbøtteikon).
- Eksempelrader:
  | Arbeidsgiver | Praksistype | Periode | Omfang | Beregnet | Inkluder |
  |---|---|---|---|---|---|
  | Oslo universitetssykehus | MEDLAB – Medisinsk laboratorium | 01.01.2020–31.12.2020 | 100% | 1,00 år | ja |
  | Legevakt Vest AS | MEDKIR – Praksis i kirurgi - medisinstudiet | 01.01.2021–31.12.2022 ⚠ | 75% | 1,50 år | ja |
  | Oslo universitetssykehus | RADIORAD – Radiologisk praksis | 01.07.2022–30.06.2023 ⚠ | 50% | 0,50 år | ja |
  | Haukeland Sykehus | SPLFOLK – Praksis i folkehelse - sykepleie | 01.07.2023–30.06.2024 | 850 timer (av 1700) | 0,50 år | nei |
- Varsel (gul bakgrunn) under tabellen: «Du har to perioder som overlapper med et samlet omfang >100% (01.07.2022–31.12.2022). Omfang over 100% blir ikke tatt med i beregningen.»
- To summkort: «Oppgitt relevant praksis» **3,00 år** og «Justert for overlapp» **2,87 år**.
- Sidepanel til høyre med registreringsskjemaet (samme innhold som dialogen i 02).

## 02 — Dialog «Legg til praksisperiode»

- Tittel «Legg til praksisperiode», med knapper for å minimere og lukke.
- «Beregningsgrunnlag»: segmentert valg «Stillingsprosent» (valgt) / «Timer i perioden».
- «Startdato» og «Sluttdato»: datofelt med plassholder «DD.MM.ÅÅÅÅ» og kalenderikon.
- «Omfang (Stillingsprosent)»: tallfelt med «%», eksempelverdi «50».
- «Beregnet varighet»: «= år» (fylles ut fortløpende).
- «Arbeidsgiver (valgfri)»: tekstfelt, eksempel «Ullevål sykehus».
- «Praksistype (valgfri)»: nedtrekksliste, plassholder «Valg».
- Knapper: «Avbryt» og «Bekreft».

Variant for «Timer i perioden» er ikke skissert.

## 03 — Feil: sluttdato før startdato

- Sluttdato markert rødt med teksten «Sluttdatoen kan ikke være før startdatoen.»

## 04 — Feil: datoer mangler

- Startdato: «Oppgi startdato.»
- Sluttdato: «Oppgi sluttdato.»

## 05 — Feil: ugyldig dato

- Startdato: «Oppgi en gyldig dato, for eksempel 01.07.2022.»
- Omfang (Stillingsprosent) er også markert rødt, med samme tekst: «Oppgi en gyldig dato, for eksempel 01.07.2022.»
- Nedtrekkslista for praksistype er åpen, med plassholderelementet «List Item».
