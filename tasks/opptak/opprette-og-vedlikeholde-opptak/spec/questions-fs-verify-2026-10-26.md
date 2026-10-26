# Spørsmål og svar — `fs-verify` (2026-10-26)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Kodeklonene er bak origin/main

**Spørsmål:** Kodeklonene ligger bak origin/main: fs-admin 48 commits, fs-plattform 6. Begge er på main uten lokale endringer. Det er koden på branchen som verifiseres. Skal jeg hente det nyeste først (git pull --ff-only)?

**Alternativer:**
- Ja, hent begge (Recommended) — Verifiserer mot det som er på main nå. Ingen lokale endringer blir berørt.
- Nei, bruk det som er lokalt — Verifiserer mot commitene som ligger lokalt (fs-admin d621cc969, fs-plattform 691b56aa6b).

**Svar:** Ja, hent begge (Recommended)

---

## 2. Skjermbilder

**Spørsmål:** Skal jeg ta skjermbilder fra https://test-fsadmin.sikt.no/?

**Alternativer:**
- Nei — Bare bevis fra koden (fil:linje).
- Ja — Ett skjermbilde per scenario med en skjerm, som ekstra bevis. Krever chrome-devtools-MCP og innlogging.

**Svar:** Nei

---

## 3. Startnummeret er 1 når det ikke er satt

**Spørsmål:** @OPT-OVO-INN-001 «Startnummeret er 1 når opptaksforvalter ikke har satt det» (innstillinger.feature:75): fs-admin fyller inn 1 i et nytt opptak (emptyObjectGenerators.ts:30). Feltet er ikke påkrevd og kan tømmes (OpptakSettings.tsx:277-288), og da lagres null (OpprettOpptakMutations.java:94). Kolonnen har ingen standardverdi (V280__opptak_v2_skjema.sql:230). Dekker koden scenarioet?

**Alternativer:**
- Ja, funnet — Forhåndsutfyllingen med 1 er nok. Hele regelen om startnummer får @implemented.
- Nei, ikke funnet — Et tømt felt skal også gi 1.
- Vet ikke — Blir stående som usikker.

**Svar:** Ja, funnet

---

## 4. Levere @OPT-OVO-INN-001

**Spørsmål:** @OPT-OVO-INN-001 — Innstillinger for opptak (innstillinger.feature:2): 24/24 scenarioer er funnet. Kontrolløren bekreftet alle radene. Fem regler holdes bare i fs-admin og ikke i API-et. Regelen om krav om studierett er @draft og står urørt. Skal kravet bli @implemented?

**Alternativer:**
- Ja — @in-progress → @implemented på Egenskap-linja.
- Nei, noe mangler — Kravet blir stående som @in-progress.
- Avbryt — Ingen endringer i kravet.

**Svar:** Ja
