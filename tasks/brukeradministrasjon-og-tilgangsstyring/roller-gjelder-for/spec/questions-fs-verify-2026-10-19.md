# Spørsmål og svar — `fs-verify` (2026-10-19)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Kode, @planned-delen og skjermbilder

**Spørsmål:** Hvilken kode skal verifiseres?

**Alternativer:**
- origin/main (Recommended) — Leser fs-admin og fs-plattform på origin/main med git grep/show. Klonene og branchene røres ikke.
- Branchene som er sjekket ut — fs-admin på poc/brukerveiledninger og fs-plattform på lokal main (78 bak).

**Svar:** origin/main (Recommended)

**Spørsmål:** «Se brukerens roller med «Gjelder for»» er @planned, ikke @in-progress. Skal den verifiseres uansett status, så @planned kan fjernes hvis alt er funnet?

**Alternativer:**
- Ja, uansett status (Recommended) — Er scenarioet funnet og den gamle kolonnen borte, foreslår jeg å fjerne @planned (delen blir levert) og slette @deprecated-blokken.
- Nei, bare rapporter — Jeg verifiserer og rapporterer, men foreslår ingen endring på @planned-delen. Den må gå via fs-specify.

**Svar:** Ja, uansett status (Recommended)

**Spørsmål:** Skal jeg ta skjermbilder fra https://test-fsadmin.sikt.no/?

**Alternativer:**
- Nei — Bare bevis i koden (fil:linje).
- Ja — Ett skjermbilde av Roller-fanen på en personbruker, med chrome-devtools.

**Svar:** Ja

---

## 2. Endringer

**Spørsmål:** Rapporten står over. `@BRU-PER-GRU-008` — Scenario: Se brukerens roller med «Gjelder for» (1/1) kan leveres (@planned fjernes), og `@BRU-PER-GRU-008` — Scenario: Se brukerens roller (@deprecated, kolonnen «Organisasjon») kan slettes (ingen spor i fs-admin og fs-plattform). Hva vil du gjøre?

**Alternativer:**
- Gjør endringene — Fjern @planned fra «Se brukerens roller med «Gjelder for»» og slett @deprecated-blokken «Se brukerens roller» i vise_roller.feature.
- Gå gjennom krav for krav — Ett spørsmål for leveringen og ett for slettingen.
- Ikke endre noe — Begge delene blir stående som de er, og det står i rapporten.

**Svar:** Gjør endringene

---
