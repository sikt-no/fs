# Spørsmål og svar — `bat-specify-delta` (2026-09-23, kjøring 2)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Valg av endringskilde

**Spørsmål:** Hvilken endringskilde skal delta-spec-en bygge på?

**Alternativer:**
- Begge test-filene (Anbefalt) — autentisere_med_idporten.feature (TIL-PÅL-PÅL-003, endret i dag) + opprette_person_uten_feide.feature (BRU-PER-GRU-013, ny). Begge @planned.
- Kun ID-porten-kravet — Bare autentisere_med_idporten.feature; personsubjekt-kravet tas som egen task.
- Kun personsubjekt-kravet — Bare opprette_person_uten_feide.feature.
- Commit eller branch — Bygg delta fra en commit/branch i stedet (filene er ucommittet i fs i dag).

**Svar:** Begge test-filene (Anbefalt)

---

## 2. Ref-slug

**Spørsmål:** Hvilken kort ref-slug skal delta-en få (brukes i filnavnet spec-changes-2026-09-23-<ref>.md)?

**Alternativer:**
- idporten-personsubjekt (Anbefalt) — Dekker begge kravene: ID-porten-autentisering og personsubjekt uten Feide.
- tests — Standard-fallback når flere filer inngår.

**Svar:** idporten-personsubjekt (Anbefalt)

---

## 3. Skisser

**Spørsmål:** Finnes det skisser (mockups, wireframes, Figma, bilder, PDF) knyttet til denne endringen?

**Alternativer:**
- Nei — Ingen skisser; begge kravene er integrasjons-/tilgangskrav.
- Ja — Jeg peker på skissene og kobler dem til kravene.

**Svar:** Nei

---

## 4. Videre etter delta-spec

**Spørsmål:** Delta-spec-en er skrevet. Hva vil du gjøre nå?

**Alternativer:**
- Fortsett til bat-analyze (Anbefalt) — Analyserer koden mot delta-en, blant annet eksisterende 0073-personsubjekt og ID-porten-coprocessoren.
- Gå gjennom åpne spørsmål — Avklarer de 4 åpne spørsmålene ett om gangen og oppdaterer delta-dokumentet.
- Stopp her — Avslutt; kjør /alfred senere for neste steg.

**Svar:** Gå gjennom åpne spørsmål

---

## 5. Åpent spørsmål 1/4 — personnøkkel

**Spørsmål:** BRU-PER-GRU-013 sier at fødselsnummeret identifiserer personen, og at en ID-porten-innlogging gjenkjennes som den registrerte personen. Det åpne spørsmålet om «pid eller ID-portens sub» er fjernet fra TIL-PÅL-PÅL-003 siden 18.09. Er det avgjort kravmessig at pid (fødselsnummer/D-nummer) er nøkkelen?

**Alternativer:**
- Ja, pid er nøkkelen — Avgjort i workshopen: pid fra ID-porten matches mot fødselsnummeret på personsubjektet. Analysen tar bare den tekniske løsningen.
- La analysen avgjøre — Kravet sier bare at personen gjenkjennes; valget av nøkkel tas i bat-analyze.
- Utsett — La spørsmålet stå åpent i delta-dokumentet.

**Svar:** Ja, pid er nøkkelen

---

## 6. Åpent spørsmål 2/4 — ny rettighet

**Spørsmål:** BRU-PER-GRU-013 krever en ny rettighet, «administrere personer uten Feide-konto», som er atskilt fra Feide-rettigheten. Kravet sier ikke hva den heter eller hvem som tildeler den. Hvordan vil du håndtere det?

**Alternativer:**
- La analysen foreslå — bat-analyze ser på hvordan eksisterende rettigheter for Feide-administrasjon er modellert, og foreslår en parallell rettighet.
- Jeg oppgir navn og tildeler — Du skriver inn rettighetens navn og hvem som tildeler den, så føres det inn som beslutning.
- Utsett — La spørsmålet stå åpent i delta-dokumentet.

**Svar:** La analysen foreslå

---

## 7. Åpent spørsmål 3/4 — scope

**Spørsmål:** BRU-PER-GRU-013 beskriver en administrasjonsflyt med registrering, søk, visning og fjerning. Hva ligger i scope for denne tasken (fs-plattform/tilgangsstyring)?

**Alternativer:**
- Backend her, flate i fs-admin — Denne tasken dekker DB, API og mutasjoner i tilgangsstyring. Skjermbildene i fs-admin kommer i fs-admin-tasken etterpå.
- Bare personsubjekt-modellen — Bare datamodellen og gjenkjenning ved innlogging (0073). Registrerings-API tas som egen task.
- Hele flyten her — Alt i BRU-PER-GRU-013 håndteres innenfor denne tasken.
- Utsett — La spørsmålet stå åpent i delta-dokumentet.

**Svar:** Backend her, flate i fs-admin

---

## 8. Åpent spørsmål 4/4 — Digdir-registrering

**Spørsmål:** Fase 0-forutsetningen for TIL-PÅL-PÅL-003 er at Sikt må være registrert klient hos Digdir. Per 18.09 var den ikke bestilt. Hva er status?

**Alternativer:**
- Fortsatt ikke bestilt — Står åpent som en ekstern avhengighet. Blokkerer ikke analysen, men hindrer ende-til-ende-test mot ekte ID-porten.
- Bestilt / pågår — Registreringen er bestilt, men ikke ferdig. Markeres som følges opp.
- Registrert — Sikt er registrert klient. Forutsetningen er oppfylt.

**Svar:** Fortsatt ikke bestilt

---

## 9. Videre etter åpne spørsmål

**Spørsmål:** Tre av fire åpne spørsmål er avklart. Digdir-registreringen står åpen som ekstern avhengighet. Hva vil du gjøre nå?

**Alternativer:**
- Fortsett til bat-analyze (Anbefalt) — Analyserer koden mot delta-en, blant annet eksisterende 0073-personsubjekt og ID-porten-coprocessoren.
- Stopp her — Avslutt; kjør /alfred senere for neste steg.

**Svar:** Fortsett til bat-analyze (Anbefalt)

---
