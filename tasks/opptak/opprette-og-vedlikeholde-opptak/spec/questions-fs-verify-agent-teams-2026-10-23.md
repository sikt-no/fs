# Spørsmål og svar — `fs-verify-agent-teams` (2026-10-23)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Scope, omfang, avhengigheter og skjermbilder

**Spørsmål:** Hvilke krav skal verifiseres? (Kodeklonene blir fs-plattform, fs-admin og min-kompetanse under ~/Documents/dev/sikt/.)
**Svar:** Oppgaven + 12/03 Opptaksinnstillinger (GRU-001, SAM-001, INN-001, FRI-001 og UTD-004/007/008/032)

**Spørsmål:** Hva skal verifiseres?
**Svar:** @in-progress, Flyter, Alle uansett status

**Spørsmål:** Hvor langt skal @depends-on- følges?
**Svar:** 1 nivå, bare status

**Spørsmål:** Skal jeg ta skjermbilder fra https://test-fsadmin.sikt.no/?
**Svar:** Nei

---

## 2. Oppdatere kodeklonene

**Spørsmål:** Kodeklonene er bak origin/main: fs-plattform 250 commits, fs-admin 8, min-kompetanse 14. Skal jeg hente med git pull --ff-only før verifiseringen?
**Svar:** Ja, hent alle

---

## 3. Usikre scenarioer

**Spørsmål:** @OPT-OVO-SAM-001 «Organisasjon som ikke deltar, ser ikke opptaket» (samordna_opptak.feature:33) — filteret står bak Unleash-flagget opptak-filter-organisasjon (av). Dekker koden scenarioet?
**Svar:** Vet ikke

**Spørsmål:** @OPT-OVO-SAM-001 «Se og navigere til saksbehandlertildelingen for opptaket» (samordna_opptak.feature:131) — lenken er bare på redigeringssiden. Dekker koden scenarioet?
**Svar:** Vet ikke

**Spørsmål:** @OPT-OVO-INN-001 «Startnummeret er 1 når opptaksforvalter ikke har satt det» (innstillinger.feature:75) — forhåndsutfylt 1 i fs-admin, tømt felt lagres som null. Dekker koden scenarioet?
**Svar:** Ja, funnet

**Spørsmål:** @OPT-OPT-UTD-004 «Lærestedet kan ikke endre plassflyten eller kvoteprioriteten» (opptaksinnstillinger_utdanningstilbud.feature:185) — ingen kontroll, men fjerning av kvote nummererer prioritetene på nytt. Dekker koden scenarioet?
**Svar:** Vet ikke

---

## 4. Usikkert scenario

**Spørsmål:** @OPT-OPT-UTD-004 «Velge å vise poenggrense for søker» (opptaksinnstillinger_utdanningstilbud.feature:263) — innstillingen lagres, men ingen leser den. Dekker koden scenarioet?
**Svar:** Vet ikke

---

## 5. Kan leveres

**Spørsmål:** @OPT-OVO-GRU-001 — Regel om obligatoriske innstillinger (opprett_opptak.feature:60), 1/1. Skal @in-progress fjernes?
**Svar:** Ja

**Spørsmål:** @OPT-OPT-UTD-008, 1/1. Skal kravet bli @implemented?
**Svar:** Ja

**Spørsmål:** @OPT-OPT-UTD-032, 2/2, bygger på @OPT-OPT-UTD-007 (@draft). Skal kravet bli @implemented?
**Svar:** Ja

**Spørsmål:** @OPT-OVO-SAM-001, 11/15. Delvis levert?
**Svar:** Ja

---

## 6. Delvis levert

**Spørsmål:** @OPT-OVO-INN-001, 24/25. Delvis levert?
**Svar:** Ja

**Spørsmål:** @OPT-OVO-FRI-001, 23/25. Delvis levert?
**Svar:** Ja

**Spørsmål:** @OPT-OPT-UTD-004, 13/25. @draft → @in-progress, delene @implemented?
**Svar:** Ja

**Spørsmål:** @OPT-OPT-UTD-007, 5/6. @draft → @in-progress, reglene @implemented?
**Svar:** Ja
