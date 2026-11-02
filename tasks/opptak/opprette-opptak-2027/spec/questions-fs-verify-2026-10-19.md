# Spørsmål og svar — `fs-verify` (2026-10-19)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. fs-admin er bak origin/main

**Spørsmål:** fs-admin (~/fs-admin) er 23 commits bak origin/main (siste lokale commit er fra 15.10). Skal jeg hente siste main før verifiseringen?

**Alternativer:**
- Ja, hent (Recommended) — Jeg kjører git pull --ff-only i ~/fs-admin. Det endrer bare din lokale kopi, og går bare hvis du ikke har lokale endringer som kommer i veien.
- Nei, bruk versjonen fra 15.10 — Jeg verifiserer mot det som ligger lokalt, og skriver i rapporten at fs-admin er 23 commits bak.

**Svar:** Ja, hent (Recommended)

---

## 2. Skjermbilder

**Spørsmål:** Skal jeg ta skjermbilder fra https://test-fsadmin.sikt.no/?

**Alternativer:**
- Nei — Bevisene blir fil:linje i koden. Det går raskere, og krever ingen innlogging.
- Ja — Jeg tar ett skjermbilde per scenario som har en skjerm, med chrome-devtools. Du må kanskje logge inn i nettleservinduet.

**Svar:** Nei

---
