# Spørsmål og svar — `fs-specify` (2026-11-02)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Hvilket scope?

**Spørsmål:** fs-specify må legge spesifikasjonen i et scope (en mappe under tasks/opptak/). 015 og 027 har ikke noe scope ennå. Jøran laget et scope for hele den automatiske saksbehandlingen i #895, men lukket PR-en i dag fordi scope-formatet ble endret (#897). Han har ikke laget det på nytt. Hva gjør vi?

**Alternativer:**
- Eget GSK-scope nå (anbefalt) — Vi lager scopet automatisk-gsk-konklusjon for 015 og 027, med STEK-249, og kan starte utviklingen i dag. Jøran kan vise til det fra scopet for hele flyten, så blir det ikke dobbelt.
- Vent på Jøran — Vi venter til Jøran har laget scopet for hele flyten på nytt, og kjører fs-specify på GSK-delen der. Det kan ta litt tid.
- Hele flyten selv — Vi lager scopet for hele flyten selv, etter Jørans forslag i #895, men spesifiserer bare GSK nå. Det kan krasje med det Jøran holder på med.

**Svar:** Eget GSK-scope nå (anbefalt)

---
