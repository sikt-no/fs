# Spørsmål og svar — `fs-specify` (2026-10-07)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

Kjøringen gikk som en agent uten mulighet til å spørre Kjetil underveis. Svarene under er
Kjetils svar gitt på forhånd, eller agentens forslag der det står det. Forslagene må bekreftes.

---

## 1. Skisser

**Spørsmål:** Finnes det skisser (mockups, wireframes, Figma, bilder, PDF) for kravene i denne spec-en?

**Alternativer:**
- Ja — skissene kobles til kravene og valideres
- Nei — spec-en får «Ingen skisse: <grunn>»

**Svar:** Nei

**Fritekst:** Ingen skisser. Implementasjonsdetaljene bygger på eksisterende mønstre i FS Admin (Kjetil, 07.10.2026).

---

## 2. Kodesjekk: rollens oversiktsside viser direkte eller også arvede tildelinger

**Spørsmål:** Kravet `BRU-PER-ROL-001` sier «brukerne med rollen aktivt tildelt». Filteret `roller` på `feideBrukere` og `personsubjekter` treffer brukere som har rollen «aktivt, direkte eller arvet». Hva skal vi gjøre?

**Alternativer:**
- Kravet er riktig, koden skal endres — rollens oversiktsside viser direkte tildelinger
- Kravet må endres — holdes tilbake
- Vet ikke — holdes tilbake

**Svar:** Koden er riktig: rollens oversiktsside viser direkte og arvede tildelinger. «Aktivt tildelt» betyr at rollen er aktiv nå, ikke at den er direkte tildelt. Kravet er presisert (Kjetil, 07.10.2026).

---

## 3. Kodesjekk: opprett_person krever navn og avslører om personen finnes

**Spørsmål:** Kravet `BRU-PER-GRU-013` sier at navnet kommer fra første pålogging, og at svaret er det samme uansett om personen fantes. `tilgangsstyring.opprett_person(fodselsnummer, fornavn, etternavn)` krever navn, gir ingen tildeling, og gir 23505 når personen finnes. Hva skal vi gjøre?

**Alternativer:**
- Kravet er riktig, koden skal endres
- Kravet må endres — holdes tilbake
- Vet ikke — holdes tilbake

**Svar:** Kravet er riktig, koden skal endres (følger av Kjetils beslutninger 07.10.2026: navn fra første pålogging, samme svar uansett)

---

## 4. Kodesjekk: synlighet gjennom lukkede tildelinger

**Spørsmål:** Kravene sier at en person er synlig gjennom en aktiv tildeling. RLS-policyen `personsubjekt_les` gir synlighet også gjennom en lukket tildeling, med vilje. Hva skal vi gjøre?

**Alternativer:**
- Kravet er riktig, koden skal endres
- Kravet må endres — holdes tilbake
- Vet ikke — holdes tilbake

**Svar:** Kravet er riktig og gjelder synlighet i applikasjonen. Det løses med et filter i GraphQL-spørringen. RLS står, fordi historikk senere trenger tilgang til inaktive tildelinger (Kjetil, 07.10.2026).
