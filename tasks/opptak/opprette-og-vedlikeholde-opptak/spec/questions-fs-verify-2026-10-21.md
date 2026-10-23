# Spørsmål og svar — `fs-verify` (2026-10-21)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Kodeklonene og skjermbilder

**Spørsmål:** Kodeklonene er bak origin/main (fs-plattform 106, fs-admin 32, min-kompetanse 7 commits), og har ingen lokale endringer. Skal jeg hente siste main i alle tre før verifiseringen?

**Alternativer:**
- Ja, hent alle tre (Recommended) — git pull --ff-only i hver klone. Det endrer bare de lokale kopiene dine. Verifiseringen sjekker da koden slik den er på main nå.
- Nei, bruk det som ligger lokalt — Jeg verifiserer mot versjonene fra 19.10, og skriver i rapporten hvor langt bak de er.

**Svar:** Ja, hent alle tre (Recommended)

**Spørsmål:** Skal jeg ta skjermbilder fra https://test-fsadmin.sikt.no/?

**Alternativer:**
- Nei — Bevisene blir fil:linje i koden.
- Ja — Ett skjermbilde per scenario som har en skjerm, med chrome-devtools. Du må kanskje logge inn.

**Svar:** Ja (chrome-devtools-MCP finnes ikke i økta, så det ble ingen skjermbilder)

---

## 21:42 — Sortering på organisasjon i listevisningen (@OPT-OVO-OVE-001)

**Spørsmål:** Lista sorteres på organisasjonskoden når man velger «Organisasjon», men kolonnen viser forkortelsen. Er det godt nok?

- Godt nok, lever kravet
- Ta organisasjon ut av kravet
- Ikke godt nok

**Svar:** Godt nok, lever kravet

---
