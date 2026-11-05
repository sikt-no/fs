# Spørsmål og svar — `fs-specify` (2026-11-04)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Branchen er bak main

**Spørsmål:** krav/plasstildeling-prototype-v88 er 37 commits bak main (ingen av dem endrer kravene i denne spesifikasjonen, bare starte_plasstildeling.feature og to linjer i krav/README.md). Fortsette?

**Alternativer:**
- Fortsett (Recommended) — Spesifikasjonen lages på branchen som den er. Main merges ikke inn.
- Avbryt — Du oppdaterer branchen mot main selv først.

**Svar:** Fortsett (Recommended)

---

## 2. Prototypen v88 avviker fra oversikten

**Spørsmål:** Prototypen v88 avviker fra oversikten i @OPT-PLA-RUN-002: den har ikke filter eller sortering på perioden, sorterer i stedet på runde og rundetype, viser oppgaven bare for lærestedet, og har avkrysning med «Handlinger» for å slette flere runder samtidig. (Avvikene du allerede har sagt at prototypen skal rettes for, tak per søker på alle runder og varsling, registreres som «skissen er utdatert».) Hva gjør vi med oversikten?

**Alternativer:**
- Kravene er riktige — Prototypen er utdatert for oversikten. Avkrysning og sletting av flere runder er ikke med.
- Krav mangler: sletting av flere — Kravene er riktige ellers, men sletting av flere runder samtidig skal inn i kravet (fs-krav, åpent spørsmål).
- Vet ikke — Blir et åpent spørsmål i spesifikasjonen.

**Svar:** Krav mangler: sletting av flere

---

## 3. Rundetypene i regelverkssamlingen eller felles kodeverk

**Spørsmål:** Kravet @OPT-REG-RUN-001 sier at regelverkssamlingen har rundetypene, men i koden er rundetypene et felles kodeverk uten kobling til regelverkssamlingen (fs-plattform/opptak/opptak-migrations/.../V280__opptak_v2_skjema.sql:145, 1590-1596). Hva gjør vi?

**Alternativer:**
- Kravet er riktig — Koden skal endres, så rundetypene med innstillingene hører til regelverkssamlingen.
- Kravet må endres — Rundetypene er felles for alle opptak i første leveranse. REG-RUN-001 holdes tilbake (står som @planned) og rettes med fs-krav.
- Vet ikke — REG-RUN-001 holdes tilbake til det er avklart.

**Svar:** Kravet må endres

---

## 4. Unikt navn på plasstildelingsrunden

**Spørsmål:** Koden har en regel kravet ikke nevner: navnet på plasstildelingsrunden er unikt i opptaket, uten hensyn til store og små bokstaver, og er høyst 100 tegn (fs-plattform V280__opptak_v2_skjema.sql:390, opptaksrunde.graphqls:43-51). Hva gjør vi?

**Alternativer:**
- Kravet må endres — Regelen om unikt navn (og maks lengde) skal inn i @OPT-PLA-RUN-001 med fs-krav. Kravet holdes tilbake til da.
- Koden er grei, kravet trenger ikke regelen — Står under Kodesjekk som noe utviklerne vet. RUN-001 hentes inn som det er.
- Vet ikke — RUN-001 holdes tilbake til det er avklart.

**Svar:** Kravet må endres

---

## 5. Etter spesifikasjonen

**Spørsmål:** Skal vi gå gjennom de åpne spørsmålene og rette kravene nå (fs-krav), ett om gangen?

**Alternativer:**
- Gå gjennom åpne spørsmål — Rett REG-RUN-001, RUN-001 og RUN-002, og kjør fs-specify på nytt etterpå.
- Stopp her — Commit det som er gjort, og ta resten senere.

**Svar:** Gå gjennom åpne spørsmål

---
