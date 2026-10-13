# Spørsmål og svar — `bat-plan` (2026-06-17)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Skal `bat-graphql-dev` kjøres før plan-fila skrives?

**Spørsmål:** Analysen flagger fire schema-endringer (to nye queries, to nye Applikasjon-felter, ett serverside rolle-filter). Skal jeg kalle bat-graphql-dev for å produsere ## GraphQL-endringer-seksjonen før jeg skriver plan-fila?

**Alternativer:**
- Ja, kjør bat-graphql-dev først (Anbefalt) — Planen får en sitert schema-skisse med begrunnelse mot producer-guidelines. Hand-off til fs-plattform blir konkret.
- Nei, skriv plan uten GraphQL-seksjon — Jeg nøyer meg med å referere endringene i Task-listen og lar fs-plattform-producer ta detaljerings-runden.
- Skriv plan først, deretter bat-graphql-dev — Planen skrives nå med GraphQL-endringer-placeholder. Bat-graphql-dev fyller inn seksjonen i en egen runde etterpå.

**Svar:** Ja, kjør bat-graphql-dev først (Anbefalt)

---
