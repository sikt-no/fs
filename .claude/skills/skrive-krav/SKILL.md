---
name: skrive-krav
description: >
  Skriv BDD-krav i Gherkin-format. Veileder brukeren gjennom prosessen med å
  definere krav, finner gjenbrukbare steps, og genererer feature-filer.
  Bruk når brukeren vil skrive nye krav, lage feature-filer, eller jobbe med BDD.
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

### 5. Generer feature-fil

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

### 6. Oppdater oversikt

Etter at feature-filen er lagret:
```bash
cd krav-parser && npm run generate-overview
```

---

## Gherkin Beste Praksis

### Ett Scenario = Én Atferd

Hvert scenario skal teste én spesifikk atferd.

```gherkin
# FEIL - tester to ting
Scenario: Bruker logger inn og ser dashboard
  Når bruker logger inn
  Så ser bruker velkommen-melding
  Når bruker klikker dashboard
  Så ser bruker statistikk

# RIKTIG - ett scenario per atferd
Scenario: Vellykket innlogging
  Når bruker logger inn
  Så ser bruker velkommen-melding

Scenario: Navigere til dashboard
  Gitt bruker er logget inn
  Når bruker klikker dashboard
  Så ser bruker statistikk
```

### Deklarativ vs Imperativ

Skriv HVA som skal skje, ikke HVORDAN.

```gherkin
# FEIL - imperativ (hvordan)
Når jeg klikker på brukernavn-feltet
Og jeg skriver "test@example.com"
Og jeg klikker på passord-feltet
Og jeg skriver "password123"
Og jeg klikker på logg-inn-knappen

# RIKTIG - deklarativ (hva)
Når jeg logger inn med "test@example.com"
```

### Bruk Scenariomal for Variasjoner

```gherkin
Scenariomal: Validering av input
  Når bruker skriver "<input>"
  Så ser bruker "<resultat>"

  Eksempler:
    | input    | resultat    |
    | gyldig   | Suksess     |
    | ugyldig  | Feilmelding |
```

### Bruk Regel-seksjoner

Grupper relaterte scenarios under forretningsregler:

```gherkin
Regel: Kun aktive brukere kan logge inn

  Scenario: Aktiv bruker logger inn
    ...

  Scenario: Deaktivert bruker nektes tilgang
    ...
```

### Bakgrunn for Felles Setup

```gherkin
Bakgrunn:
  Gitt bruker er logget inn
  Og bruker er på dashboard

Scenario: Se statistikk
  Når bruker klikker statistikk
  Så ...
```

### Konkrete Eksempler

Bruk spesifikke, realistiske verdier:

```gherkin
# FEIL - generisk
Gitt en bruker finnes
Når bruker søker på noe

# RIKTIG - konkret
Gitt brukeren "Ola Nordmann" finnes
Når bruker søker på "informatikk"
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
