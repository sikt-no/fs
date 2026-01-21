---
name: gherkin-bdd
description: >
  BDD/Gherkin kunnskapsskill. Aktiveres automatisk når brukeren jobber med
  .feature filer, krav, eller BDD-relaterte oppgaver. Gir Claude forståelse
  av Gherkin-syntaks og BDD beste praksis.
---

# BDD/Gherkin Beste Praksis

## Grunnprinsipp: ALDRI ANTA

Når du skriver krav, ALDRI anta eller finn opp:
- Feilmeldinger
- Valideringsregler
- Forretningslogikk
- Entity-attributter

ALLTID spør brukeren om detaljer som mangler.

## Ett Scenario = Én Atferd

Hvert scenario skal teste én spesifikk atferd. Hvis du trenger flere When-Then par, lag separate scenarios.

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

## Deklarativ vs Imperativ

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

## Bruk Scenario Outline for Variasjoner

Når samme scenario gjentas med ulike verdier:

```gherkin
Scenariomal: Validering av input
  Når bruker skriver "<input>"
  Så ser bruker "<resultat>"

  Eksempler:
    | input    | resultat        |
    | gyldig   | Suksess         |
    | ugyldig  | Feilmelding     |
    | tom      | Påkrevd felt    |
```

## Bruk Regel-seksjoner

Grupper relaterte scenarios under forretningsregler:

```gherkin
Regel: Kun aktive brukere kan logge inn

  Scenario: Aktiv bruker logger inn
    ...

  Scenario: Deaktivert bruker nektes tilgang
    ...
```

## Bakgrunn for Felles Setup

Flytt gjentatte Gitt-steg til Bakgrunn:

```gherkin
Bakgrunn:
  Gitt bruker er logget inn
  Og bruker er på dashboard

Scenario: Se statistikk
  Når bruker klikker statistikk
  Så ...
```

## Konkrete Eksempler

Bruk spesifikke, realistiske verdier:

```gherkin
# FEIL - generisk
Gitt en bruker finnes
Når bruker søker på noe

# RIKTIG - konkret
Gitt brukeren "Ola Nordmann" finnes
Når bruker søker på "informatikk"
```

## Gherkin Nøkkelord

| Engelsk | Norsk | Formål |
|---------|-------|--------|
| Feature | Egenskap | Overordnet funksjonalitet |
| Rule | Regel | Forretningsregel (grupperer scenarios) |
| Background | Bakgrunn | Felles forutsetninger |
| Scenario | Scenario | Konkret testcase |
| Scenario Outline | Scenariomal | Parametrisert testcase |
| Examples | Eksempler | Data for Scenario Outline |
| Given | Gitt | Forutsetning (kontekst) |
| When | Når | Handling (trigger) |
| Then | Så | Forventet resultat |
| And/But | Og/Men | Fortsettelse av forrige step |

## Ressurser

### examples/perfekt-gherkin-eksempel.feature

Komplett eksempel som demonstrerer alle beste praksis:
- Norsk Gherkin-syntaks med `# language: no`
- Flere Regel-seksjoner som organiserer scenarios etter forretningsregler
- Bakgrunn for felles setup med datatabeller
- MoSCoW-prioritering og status-tags (`@must`, `@should`, `@implemented`, `@planned`)
- Scenariomal med Eksempler-tabell for parameteriserte tester
- Doc strings for komplekse meldinger
- Åpne spørsmål dokumentert med `# ÅPNE SPØRSMÅL:` kommentarer under feature-beskrivelsen
- Deklarativ stil (fokus på "hva", ikke "hvordan")
- Konkrete, spesifikke eksempler med realistiske verdier

Les dette eksempelet når du trenger en mal for nye feature-filer.

## Åpne Spørsmål

Dokumenter uklarheter med kommentarer, **IKKE tags**:

```gherkin
Egenskap: Min egenskap
  Som en bruker...

  # ÅPNE SPØRSMÅL:
  # - Spørsmål 1
  # - Spørsmål 2

  Bakgrunn:
    ...
```

## Tags (FS-prosjektet)

Se `rules/gherkin-conventions.md` for fullstendig liste. Hovedkategorier:

| Kategori | Tags |
|----------|------|
| Prioritet (MoSCoW) | `@must`, `@should`, `@could`, `@wont` |
| Status | `@implemented`, `@in-progress`, `@planned` |
| Type | `@e2e`, `@integration`, `@demo` |
