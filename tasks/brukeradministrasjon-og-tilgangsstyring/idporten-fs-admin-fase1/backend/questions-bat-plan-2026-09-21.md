# Spørsmål og svar — `bat-plan` (2026-09-21)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Sti-gating i BearerTokenAuthenticator

**Spørsmål:** Hvordan skal `BearerTokenAuthenticator` skille mellom coprocessor-stien og subgraf-stien?

**Alternativer:**
- To navngitte metoder (Anbefalt) — `authenticateForCoprocessor(...)` og `authenticateForSubgraf(...)` over en felles privat kjerne som tar settet av tillatte utstedere. Kallstedet navngir stien; ingen boolean-parameter å misforstå.
- Parameter på authenticate — Ett ekstra argument (enum `Sti` e.l.) på dagens metode. Minst diff, men stien blir en verdi som kan glemmes eller sendes feil.
- Tillatte utstedere injiseres per kaller — Kallerne holder hvert sitt sett av godtatte utstedere og sender det inn. Mest fleksibelt, men flytter policyen ut av authenticatoren og sprer den på to steder.

**Svar:** To navngitte metoder (Anbefalt)
