# Spørsmål og svar — `fs-verify` (2026-10-13)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

---

## 1. Skjermbilder

**Spørsmål:** Skal jeg ta skjermbilder fra https://test-fsadmin.sikt.no/?

**Alternativer:**
- Ja — Ett skjermbilde per scenario med skjerm, lagret i spec/verify-2026-10-13-1449/.
- Nei — Bare bevis fra koden (fil:linje).

**Svar:** Ja

---

## 2. Vurderingen for @BRU-APP-API-003

**Spørsmål:** Stemmer vurderingen for `@BRU-APP-API-003 — Vise tilganger for applikasjon`?

**Alternativer:**
- Stemmer — Vurderingen er riktig.
- Noe mangler — Du vet om noe som ikke virker (skriv hva).
- Kunne ikke verifisere — Ikke mulig å avgjøre nå.
- Avbryt — Stopp her.

**Svar:** Stemmer

---

## 3. Vurderingen for @BRU-APP-API-001

**Spørsmål:** Stemmer vurderingen for `@BRU-APP-API-001 — Listevisning og søk i applikasjoner`?

**Alternativer:**
- Stemmer — Vurderingen er riktig.
- Noe mangler — Du vet om noe som ikke virker (skriv hva).
- Kunne ikke verifisere — Ikke mulig å avgjøre nå.
- Avbryt — Stopp her.

**Svar:** Stemmer

---

## 4. Vurderingen for @BRU-APP-API-002

**Spørsmål:** Stemmer vurderingen for `@BRU-APP-API-002 — Se detaljer for applikasjon`?

**Alternativer:**
- Stemmer — Vurderingen er riktig.
- Noe mangler — Du vet om noe som ikke virker (skriv hva).
- Kunne ikke verifisere — Ikke mulig å avgjøre nå.
- Avbryt — Stopp her.

**Svar:** Stemmer

---

## 5. Slette «Se intern ID»

**Spørsmål:** Fant ingen spor av `@BRU-APP-API-002 — Scenario: Se intern ID` i fs-admin og fs-plattform. Slette kravet?

**Alternativer:**
- Slett — Fjern @deprecated-scenarioet «Se intern ID» fra se_detaljer.feature.
- Behold — La scenarioet stå.
- Avbryt — Stopp her.

**Svar:** Slett

---

## 6. Vurderingen for @BRU-APP-API-004

**Spørsmål:** Stemmer vurderingen for `@BRU-APP-API-004 — Passordbytte for applikasjon` (begge `@in-progress`-reglene)? Ved «Stemmer» fjernes `@in-progress` fra de to reglene, så de er levert.

**Alternativer:**
- Stemmer — Vurderingen er riktig.
- Noe mangler — Du vet om noe som ikke virker (skriv hva).
- Kunne ikke verifisere — Ikke mulig å avgjøre nå.
- Avbryt — Stopp her.

**Svar:** Stemmer

---

## 7. Slette de to @deprecated-reglene i passordbytte

**Spørsmål:** Fant ingen spor av `@BRU-APP-API-004 — Regel: Nytt passord genereres av systemet` og `Regel: Kun ett passord er aktivt om gangen` i fs-admin og fs-plattform. Slette de to reglene?

**Alternativer:**
- Slett — Fjern de to @deprecated-reglene fra passordbytte.feature.
- Behold — La reglene stå.
- Avbryt — Stopp her.

**Svar:** Slett

---

## 8. Vurderingen for @BRU-APP-API-009

**Spørsmål:** Stemmer vurderingen for `@BRU-APP-API-009 — Opprette applikasjon`?

**Alternativer:**
- Stemmer — Vurderingen er riktig.
- Noe mangler — Du vet om noe som ikke virker (skriv hva).
- Kunne ikke verifisere — Ikke mulig å avgjøre nå.
- Avbryt — Stopp her.

**Svar:** Stemmer

---

## 9. Slette tre @deprecated-scenarioer i opprette_applikasjon

**Spørsmål:** Fant ingen spor av tre `@deprecated`-scenarioer i `@BRU-APP-API-009`: «Velge identitetsleverandør ved opprettelse (avvikles)», «FS er ikke en valgbar identitetsleverandør» og «Nyopprettet applikasjon kan autentisere umiddelbart». Slette dem?

**Alternativer:**
- Slett — Fjern de tre @deprecated-scenarioene fra opprette_applikasjon.feature.
- Behold — La dem stå.
- Avbryt — Stopp her.

**Svar:** Slett

---

## 10. @in-progress tilbake på autentiserings-scenarioene

**Spørsmål:** De to autentiserings-scenarioene som ble satt som levert ved mergen, er usikre, fordi en ny applikasjon får åpne roller uten tildelte tilganger (i demo). Skal de få `@in-progress` tilbake?

**Alternativer:**
- Ja, @in-progress tilbake — Rett opp det jeg satte for tidlig ved mergen. Spesifikasjonen oppdateres tilsvarende.
- Nei, la dem stå som levert — Åpne roller regnes ikke som «tilgang til data» i kravet.

**Svar:** Ja, @in-progress tilbake

---
