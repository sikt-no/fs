# Spørsmål og svar — `fs-specify` (2026-11-02)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Hva betyr «ikke avsluttet»?

**Spørsmål:** Kravet om annullerte vitnemål gjelder bare saker i opptak som «ikke er avsluttet». Opptakssystemet har ikke noe som heter «avsluttet». Et opptak har bare tre statuser: publisert, upublisert og arkivert. Hva betyr «ikke avsluttet»?

**Alternativer:**
- Ikke arkivert (anbefalt) — Alle opptak som ikke har statusen arkivert. Det kan bygges med det som finnes i dag.
- Plasstildelingen har ikke kjørt — Bare opptak der plasstildelingen ikke har kjørt ennå. Etter tildelingen merkes ingen saker.
- Noe annet — En egen dato eller status for når opptaket er avsluttet. Det må lages nytt.

**Svar:** Other

**Fritekst:** Det betyr at opptaket er aktivt og ikke ferdig.

---

## 2. Hvordan ser systemet at et opptak er ferdig?

**Spørsmål:** Hvordan skal systemet se at et opptak er ferdig? Systemet kjenner i dag bare til at et opptak er publisert, upublisert eller arkivert. Det vet også om plasstildelingen har kjørt.

**Alternativer:**
- Når det er arkivert (anbefalt) — Opptaket er ferdig når opptaksforvalteren arkiverer det. Alt før det regnes som aktivt. Kan bygges i dag.
- Ikke avklart ennå — Vi bruker «ikke arkivert» nå, og skriver et åpent spørsmål i kravet om hva «ferdig» betyr.
- En egen sluttdato — Opptaket får en ny dato for når det er ferdig. Det må lages nytt, og først skrives som eget krav.

**Svar:** Other

**Fritekst:** Publisert

---

## 3. Merknad fra systemet

**Spørsmål:** Kravet sier at saken skal få en merknad om at vitnemålet er annullert, og hva det er brukt til. I dag kan bare en innlogget person skrive en merknad på saken. Systemet kan ikke. Hva gjør vi?

**Alternativer:**
- Systemet kan skrive merknad (anbefalt) — Vi lager støtte for merknader fra systemet. De vises som skrevet av «Opptakssystemet». Det krever en endring i databasen og i visningen i fs-admin.
- Ingen merknad — Saken får bare taggen og statusendringen. At vitnemålet er annullert, vises på vitnemålet i vitnemålsbehandlingen (chhas MR). Kravet endres.
- Merknad senere — Vi bygger tagg og status nå. Merknaden blir et eget steg, og står som utkast i kravet til vi har løsningen.

**Svar:** Merknad senere

---
