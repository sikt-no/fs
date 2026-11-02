# Spørsmål og svar — `fs-specify` (2026-10-19)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Maks antall søknadsalternativer er ikke påkrevd i koden

**Spørsmål:** Kravet @OPT-OVO-GRU-001 sier at opptaket ikke kan lagres uten maks antall søknadsalternativer. Koden har det ikke påkrevd: fs-admin krever ikke feltet, og fs-plattform bruker 10 når det er utelatt (OpprettOpptakMutations.java:90-91). Hva skal vi gjøre?

**Alternativer:**
- Kravet gjelder, koden endres — Feltet blir påkrevd i fs-admin. Kravet hentes inn som det står, og avviket står under Kodesjekk, så utviklerne vet det. Det kan legges i TAKE-431 sammen med taket.
- Forhåndsutfylt med 10 — Feltet er påkrevd, men forhåndsutfylt med 10, som API-et bruker i dag. Kravet må da endres med fs-krav før regelen hentes inn, så regelen blir stående som @planned.
- Ikke påkrevd, standard 10 — Maks antall søknadsalternativer tas ut av regelen om obligatoriske felt, og 10 er standardverdien. Kravet må endres med fs-krav først.

**Svar:** Kravet gjelder, koden endres

---

## 2. Implementasjonsdetaljer for opprett_opptak.feature

**Spørsmål:** opprett_opptak.feature har ikke implementasjonsdetaljer (opprett_opptak.design.md). Regelen om obligatoriske felt gir tekster for felt som mangler. Skal jeg kjøre fs-implementasjonsdetaljer nå, med Figma-skissen som finnes?

**Alternativer:**
- Vent — Jeg henter inn regelen nå, og legger «Implementasjonsdetaljer mangler for opprett_opptak.feature» under Åpne spørsmål i spesifikasjonen. fs-admin har allerede tekstene for felt som mangler (missingFields i opptak.json), så det haster ikke.
- Kjør nå — Jeg kjører fs-implementasjonsdetaljer for opprett_opptak.feature før regelen hentes inn. Det tar en egen runde med spørsmål om tekstene.

**Svar:** Vent

---
