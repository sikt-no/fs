---
name: skrive-krav
description: >
  This skill should be used when the user asks to "skrive krav", "lag feature-fil",
  "skriv BDD-scenario", "definer krav", "lag Gherkin", "skriv en feature",
  "nytt scenario", or wants to create BDD requirements in Gherkin format.
  Guides the user through defining requirements, finding reusable steps, and
  generating feature files.
---

# Skrive Krav

Skill for å skrive BDD-krav i Gherkin-format.

## Arbeidsflyt

### 1. Forstå behovet

Start med å spørre brukeren:
- Hva skal funksjonaliteten gjøre?
- Hvem er aktørene? (administrator, søker, student, saksbehandler)
- Hvilke ord/uttrykk brukes i domenet?

### 2. Les konvensjoner

Les `.claude/rules/gherkin-conventions.md` for:
- Mappestruktur (Domene → Sub-domene → Kapabilitet)
- Feature-ID format (`@DOM-SUB-KAP-NNN`)
- Tags (prioritet, status, type)

### 3. Finn eksisterende steps

Søk etter gjenbrukbare steps:

**Søk i:**
- `krav/**/*.feature` - eksisterende scenarios
- `tester/steps/**/*.ts` - implementerte step-definisjoner

**Presenter funn gruppert:**
```markdown
## Gitt-steps (forutsetninger)
- `at jeg er logget inn som {word}` - bruker-kontekst.steps.ts

## Når-steps (handlinger)
- `jeg oppretter et nytt opptak` - opptak.steps.ts

## Så-steps (forventninger)
- `skal jeg se {string} på siden` - bruker-kontekst.steps.ts
```

### 4. Definer scenarios

For hvert scenario, avklar:
- **Gitt** - Forutsetning/kontekst
- **Når** - Handling som utføres
- **Så** - Forventet resultat

**VIKTIG: ALDRI anta feilmeldinger, valideringsregler eller forretningslogikk - spør!**

### 5. Les BDD beste praksis

Før generering av feature-filen, les relevante referansefiler i `references/bddpanda/`:
- **`writing-good-gherkin.md`** - Hovedregler: Golden Rule, deklarativ vs imperativ, gyldig syntaks
- **`anti-patterns.md`** - Vanlige feil: punktlister, kondisjonell logikk, implementasjonsdetaljer
- **`features-and-scenarios.md`** - Feature-struktur, one scenario one behavior, scenariomal
- **`scenario-titles.md`** - Retningslinjer for gode scenariotitler
- **`step-phrasing.md`** - Person, tempus og formulering av steps
- **`test-data.md`** - Håndtering av testdata i BDD

### 6. Generer feature-fil

**Plassering:**
```
krav/[NN] [Domene]/[NN] [Sub-domene]/[NN] [Kapabilitet]/feature-navn.feature
```

**Format:**
```gherkin
# language: no
@[Feature-ID] @[prioritet]
Egenskap: [Navn]
  Som en [aktør]
  ønsker jeg å [handling]
  slik at [verdi].

  # ÅPNE SPØRSMÅL:
  # - [Dokumenter uklarheter her]

  Bakgrunn:
    Gitt [felles forutsetning]

  Regel: [Forretningsregel]

    @[status]
    Scenario: [Beskrivende navn]
      Gitt [forutsetning]
      Når [handling]
      Så [forventet resultat]
```

### 7. Oppdater oversikt

Etter at feature-filen er lagret:
```bash
cd krav-parser && npm run generate-overview
```

---

## Gherkin Nøkkelord

| Engelsk | Norsk | Formål |
|---------|-------|--------|
| Feature | Egenskap | Overordnet funksjonalitet |
| Rule | Regel | Forretningsregel |
| Background | Bakgrunn | Felles forutsetninger |
| Scenario | Scenario | Konkret testcase |
| Scenario Outline | Scenariomal | Parametrisert testcase |
| Examples | Eksempler | Data for Scenariomal |
| Given | Gitt | Forutsetning |
| When | Når | Handling |
| Then | Så | Forventet resultat |
| And/But | Og/Men | Fortsettelse |

---

## Tags

### Feature-ID (påkrevd)
Format: `@DOM-SUB-KAP-NNN`
- Eksempel: `@OPT-REG-GRU-001`

### Prioritet (MoSCoW)
`@must` / `@should` / `@could` / `@wont`

### Status
`@implemented` / `@in-progress` / `@planned`

### Type
`@e2e` / `@integration` / `@demo`

### Automatisk kjøring
`@smoke` / `@nightly`

---

## Eksempel

Se [examples/gherkin-eksempel.feature](examples/gherkin-eksempel.feature) for et komplett eksempel som demonstrerer alle beste praksis.
