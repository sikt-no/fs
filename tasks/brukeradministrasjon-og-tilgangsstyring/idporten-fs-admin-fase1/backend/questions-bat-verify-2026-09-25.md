# Spørsmål og svar — `bat-verify` (2026-09-25)

Append-only logg over `AskUserQuestion`-kall i denne kjøringen. Hver blokk er ett kall;
rekkefølgen i fila er kallrekkefølgen.

## 1. Sjekk `@TIL-PÅL-PÅL-003 — Autentisere mot FS GraphQL API med ID-porten` i appen. Hvordan gikk det?

- Alternativer: Alle bestått · Noen feilet · Kunne ikke verifisere · Avbryt
- **Svar:** Alle bestått

## 2. Sjekk `@BRU-PER-GRU-013 — Opprette person uten Feide-konto` i appen. Hvordan gikk det?

- Alternativer: Alle bestått · Noen feilet · Kunne ikke verifisere · Avbryt
- **Svar:** Alle bestått

## 3. Sjekk `@TIL-PÅL-PÅL-004 — Autentisere personer mot FS GraphQL API med ID-porten` i appen. Hvordan gikk det?

- Alternativer: Alle bestått · Noen feilet · Kunne ikke verifisere · Avbryt
- **Svar:** Kunne ikke verifisere

> Etter kall 3 presiserte brukeren at FS Admin mangler ID-porten-klient. Svaret på kall 1 (003) er derfor endret til «Kunne ikke verifisere».

## 4. BRU-PER-GRU-013 scenario 06 (første innlogging med ID-porten) krever en ID-porten-innlogging. Ble det faktisk verifisert?

- Alternativer: Ikke verifisert · Verifisert på annen måte
- **Svar:** Ikke verifisert
