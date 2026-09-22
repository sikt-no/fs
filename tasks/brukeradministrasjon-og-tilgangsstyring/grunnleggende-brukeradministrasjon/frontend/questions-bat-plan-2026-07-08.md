# Spørsmål og svar — `bat-plan` (2026-07-08)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. GraphQL-seksjon via bat-graphql-dev?

**Spørsmål:** Analysen flagger at 100 % av personbruker-API-et mangler — skal jeg kjøre bat-graphql-dev for å skissere mock-SDL-en (queries, mutasjoner, delvis-suksess-konvolutt) som egen GraphQL-seksjon i planen?

**Alternativer:**
- Ja, kjør bat-graphql-dev (Anbefalt) — Planen får en «GraphQL-endringer»-seksjon med typet skjemaskisse + operasjoner — blir også føring for subgraph-plan-steget i fs-plattform.
- Nei, uten GraphQL-seksjon — Planen nøyer seg med å referere analysens funn; skjemadesignet overlates helt til subgraph-plan-steget.

**Svar:** Ja, kjør bat-graphql-dev (Anbefalt)

---

## 2. Struktur for tildel/fjern-modalene

**Spørsmål:** Skissen har fire tildel/fjern-modaler (tilgang + rolle × tildel + fjern) med identisk form (Organisasjon → Miljø → fler-valg av navn). Hvordan skal modalene struktureres i koden?

**Alternativer:**
- Separate per entitet (Anbefalt) — TildelTilgangModal/FjernTilgangModal + TildelRolleModal/FjernRolleModal — følger applikasjoner-idiomet, egne queries/mutasjoner per komponent, ingen prematur abstraksjon.
- Felles parameteriserte modaler — Én TildelModal og én FjernModal med type-prop (tilgang/rolle) — mindre duplisering, men mer kompleks props/query-håndtering.

**Svar:** Separate per entitet (Anbefalt)
