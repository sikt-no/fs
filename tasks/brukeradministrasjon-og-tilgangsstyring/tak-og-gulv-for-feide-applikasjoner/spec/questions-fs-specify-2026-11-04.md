# Spørsmål og svar — `fs-specify` (2026-11-04)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen. Spørsmålene ble stilt via koordinatoren, og svarene er Kjetils.

---

## 1. Skisser

**Spørsmål:** Finnes det skisser (mockups, wireframes, Figma, bilder, PDF) for kravene i denne spec-en?

**Alternativer:**
- Ja
- Nei

**Svar:** Nei

**Fritekst:** Fanene for tak og gulv følger mønsteret fra rollefanen for personbrukere og applikasjoner i FS Admin.

---

## 2. Gulvet har ingen skrivemulighet i tilgangsstyring

**Spørsmål:** Kravet `BRU-APP-API-019` sier at applikasjonsadministratoren kan tildele og fjerne roller i gulvet, koden har bare en lesepolicy på `applikasjon_brukergrunntilgang`, og 0099 sier at gulvet skal få et eget privilegium (`fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0099-gulv-per-applikasjon.sql:99`). Hva skal vi gjøre?

**Alternativer:**
- Kravet er riktig, koden skal endres
- Kravet må endres
- Vet ikke

**Svar:** Kravet er riktig, koden skal endres

**Fritekst:** Privilegiet er applikasjonsadministrator-rollen både for applikasjonseieren og for organisasjonen på raden, som besluttet. Kommentaren i 0099 om eget privilegium følges ikke.

---

## 3. Tak fra organisasjonssamlinger er ikke synlige i grafen

**Spørsmål:** Kravet `BRU-APP-API-018` sier at tak fra en organisasjonssamling vises per organisasjon, koden leser bare direkte rader i `applikasjon_brukerdelegering` (`fs-plattform/tilgangsstyring/docs/tilgangsmodell.md:627`). Hva skal vi gjøre?

**Alternativer:**
- Kravet er riktig, koden skal endres
- Kravet må endres
- Vet ikke

**Svar:** Kravet er riktig, koden skal endres

---
