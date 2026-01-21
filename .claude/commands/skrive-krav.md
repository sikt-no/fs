---
name: skrive-krav
description: Skriv BDD-krav i Gherkin-format. Veileder brukeren gjennom prosessen og finner gjenbrukbare steps.
---

# /skrive-krav

Skriv nye BDD-krav i Gherkin-format.

## Arbeidsflyt

### 1. Forstå behovet

Spør brukeren:
- Hva skal funksjonaliteten gjøre?
- Hvem er aktørene?
- Hvilke ord/uttrykk skal brukes?

### 2. Finn eksisterende steps

Spawn `finn-steps` agenten via Task-verktøyet for å finne gjenbrukbare steps.

### 3. Definer scenarios

For hvert scenario, spør om:
- Forutsetning (Gitt)
- Handling (Når)
- Forventet resultat (Så)

**ALDRI anta feilmeldinger eller forretningslogikk - spør!**

### 4. Generer feature-fil

Spawn `lag-feature` agenten via Task-verktøyet.

### 5. Oppdater oversikt

Informer brukeren om å kjøre `/oppdater-oversikt`.

## Referanser

- Se `gherkin-bdd` skill for BDD beste praksis
- Se `rules/gherkin-conventions.md` for prosjektspesifikke regler
