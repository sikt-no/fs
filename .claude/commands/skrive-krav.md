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

Søk etter gjenbrukbare steps i kodebasen:

**Søk i:**
- `krav/**/*.feature` - eksisterende scenarios
- `tester/steps/**/*.ts` - implementerte step-definisjoner

**Grupper funn etter type:**

```markdown
## Gitt-steps
- `at jeg er logget inn som administrator` - feide-innlogging.steps.ts

## Når-steps
- `jeg oppretter et nytt opptak` - opptak.steps.ts

## Så-steps
- `skal opptaket være lagret` - opptak.steps.ts
```

Marker steps med parametere (`{string}`, `{int}`).

### 3. Definer scenarios

For hvert scenario, spør om:
- Forutsetning (Gitt)
- Handling (Når)
- Forventet resultat (Så)

**ALDRI anta feilmeldinger eller forretningslogikk - spør!**

### 4. Generer feature-fil

**Plassering:** Følg mappestrukturen i `rules/gherkin-conventions.md`:
```
krav/[NN] [Domene]/[NN] [Sub-domene]/[NN] [Kapabilitet]/feature-navn.feature
```

**Format:**
```gherkin
# language: no
@[tags]

Egenskap: [Navn]
  Som en [aktør]
  ønsker jeg å [handling]
  slik at [verdi].

  # ÅPNE SPØRSMÅL:
  # - [Eventuelle uklarheter dokumenteres her]

  Bakgrunn:
    Gitt [felles forutsetning]

  Regel: [Forretningsregel]

    Scenario: [Beskrivende navn]
      Gitt [forutsetning]
      Når [handling]
      Så [forventet resultat]
```

**Ved uklarheter:** Dokumenter med `# ÅPNE SPØRSMÅL:` rett under feature-beskrivelsen (etter "slik at...").

### 5. Oppdater oversikt

Oppdater `krav/krav-oversikt.md` med den nye feature-filen:

1. Scan `krav/**/*.feature`
2. Ekstraher feature-ID, feature-navn og status-tags
3. Grupper etter mappestruktur
4. Generer markdown-tabell med lenker
5. Skriv til `krav/krav-oversikt.md`

**Feature-ID:** Utledes fra mappestrukturen (Domene → Sub-domene → Kapabilitet):
- 3 første bokstaver fra hvert nivå (store bokstaver)
- Tall fra kapabilitetsnivået

Eksempel: `krav/05 Opplysninger om person/01 Personsøk/01 Grunnleggende/` → `OPP-PER-GRU-01`

**Output-format:**
```markdown
# Kravoversikt

## [Domene]

| ID | Feature | Status | Fil |
|----|---------|--------|-----|
| OPP-PER-GRU-01 | ... | ... | [link](...) |

## Statistikk

- Totalt: X
- Implementert: Y
- Under arbeid: Z
```

## Referanser

- Se `gherkin-bdd` skill for BDD beste praksis
- Se `rules/gherkin-conventions.md` for prosjektspesifikke regler
