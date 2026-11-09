# Spørsmål og svar — `bat-specify-delta` (2026-09-23)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Valg av endringskilde

**Spørsmål:** Hvilken endringskilde skal delta-spec-en bygge på?

**Alternativer:**
- Stopp — bat-krav først (Anbefalt) — Personsubjekt-beslutningen finnes ikke som krav. Skriv den som .feature via bat-krav (draft → planned), og kom tilbake hit. Da blir delta-en et ekte krav-delta, ikke en omvendt utledning fra tester.
- Test-filer: pgTAP 64 + 62 + 26 — Fanger personsubjekt som test-kode-krav fra 64_personsubjekt.sql og de endrede pgTAP-filene. Rask, men spesifiserer fra implementasjonen.
- Commit bce34fbe60 (BAT-243) — Bare gate-refaktoreringen: flyttet ID-porten-gaten til subgraf-stiens kallsted og rettet begrunnelsen. Ingen ny kravflate.
- Branch BAT-239-idporten-coprocessor — Alle 8 commits diffet mot main. Fanger ikke det ucommittede 0073-arbeidet.

**Svar:** Stopp — bat-krav først (Anbefalt)

---
