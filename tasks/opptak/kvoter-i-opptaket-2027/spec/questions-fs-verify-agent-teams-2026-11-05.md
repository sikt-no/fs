# Spørsmål og svar — `fs-verify-agent-teams` (2026-11-05)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Kodekloner, omfang og skjermbilder

**Spørsmål:** Hvilke kodekloner skal kravene i scope-kvoter-i-opptaket-2027 (OPT-REG-KVO-003 plassflyt, OPT-REG-KVO-004 kvoteprioritet) verifiseres mot? Spesifikasjonen har ruta fs-plattform → fs-admin.

**Alternativer:**
- fs-plattform + fs-admin (Recommended) — ~/Dev/Sikt/fs-plattform og ~/Dev/Sikt/fs-admin. Vurderes hvert repo for seg (P og A).
- Alle tre — Også ~/Dev/Sikt/min-kompetanse (søkersiden, trolig ikke relevant).
- Bare fs-admin — ~/Dev/Sikt/fs-admin

**Svar:** fs-plattform + fs-admin (Recommended)

**Spørsmål:** Hva skal verifiseres i scope-kvoter-i-opptaket-2027? Standarden er @in-progress, @deprecated og flyter. Begge kravene er @in-progress, og det finnes ingen @deprecated eller flyter i scopet, så valgene gir det samme her.

**Alternativer:**
- @in-progress — Begge feature-filene.
- @deprecated — Ingen i scopet.
- Flyter — Ingen flyt i krav/_Flyter går gjennom kravene.
- Alle krav uansett status — Gir det samme som @in-progress her.

**Svar:** Alle krav uansett status

**Spørsmål:** Skal jeg ta skjermbilder fra https://test-fsadmin.sikt.no/ av scenarioene som har en skjerm (kvoteinnstillingene i regelverkssamlingen)?

**Alternativer:**
- Nei — Bare bevis i koden (fil:linje).
- Ja — Lead-en tar skjermbildene etter kontrollen, med chrome-devtools-MCP. Krever innlogging.

**Svar:** Nei

---

## 2. Oppdatere kodeklonene

**Spørsmål:** main i kodeklonene er bak origin: fs-plattform 42 commits, fs-admin 6 commits (bl.a. «regelverksamling-dialogene bruker valgt lærested» i fs-admin). Arbeidstrærne er rene. Hente dem med git pull --ff-only før verifiseringen?

**Alternativer:**
- Hent nå (Recommended) — git pull --ff-only i fs-plattform og fs-admin, så koden på main verifiseres.
- Fortsett uten — Verifiser koden slik den er lokalt, og skriv det i rapporten.
- Avbryt — Stopp kjøringen.

**Svar:** Hent nå (Recommended)

---
