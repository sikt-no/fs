# Spørsmål og svar — `bat-verify` (2026-08-25)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Hvilket omfang skal verifiseres — spec-ens 2 krav eller alle 9 i iterasjon 2 og 3?

**Spørsmål:** Spec-en dekker bare 2 av de 9 kravene i iterasjon 2 og 3. Hvilket omfang skal jeg verifisere?

**Alternativer:**
- Alle 9 krav (101 scenarier) — Iterasjon 2 (API-001/002/003/004/006, 59 scenarier) + iterasjon 3 (API-007/008/009/010, 42 scenarier). fs-admin har flater for alle ni. Stor nettleserkjøring. Merk: opprette_applikasjon (API-009) har 4 @openquestion og kan aldri retagges uansett utfall.
- Spec-omfang: 2 krav (34 scenarier) — Kun @BRU-APP-API-001 (listevisning, 20) og @BRU-APP-API-003 (vise_tilganger, 14) — det delta-spec-en faktisk dekker. Skill-korrekt: omfang = spec. De 7 andre rapporteres som utenfor scope med peker til bat-specify.
- Iterasjon 2 først (5 krav, 59 scenarier) — Alle fem krav i iterasjon 2, inkludert de tre uten spec-dekning. Iterasjon 3 tas i en egen kjøring etterpå.

**Svar:** Alle 9 krav (101 scenarier)

**Merknad:** Kjøringen ble stoppet før verifikasjonsløkken startet — ingen browser-automatiserings-MCP
var tilkoblet, og alle 9 krav i scope er UI-krav. Omfangsvalget står ved lag for neste kjøring.

---
