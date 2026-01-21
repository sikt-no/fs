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
  When bruker logger inn
  Then ser bruker velkommen-melding
  When bruker klikker dashboard
  Then ser bruker statistikk

# RIKTIG - ett scenario per atferd
Scenario: Vellykket innlogging
  When bruker logger inn
  Then ser bruker velkommen-melding

Scenario: Navigere til dashboard
  Given bruker er logget inn
  When bruker klikker dashboard
  Then ser bruker statistikk
```

## Deklarativ vs Imperativ

Skriv HVA som skal skje, ikke HVORDAN.

```gherkin
# FEIL - imperativ (hvordan)
When jeg klikker på brukernavn-feltet
And jeg skriver "test@example.com"
And jeg klikker på passord-feltet
And jeg skriver "password123"
And jeg klikker på logg-inn-knappen

# RIKTIG - deklarativ (hva)
When jeg logger inn med "test@example.com"
```

## Bruk Scenario Outline for Variasjoner

Når samme scenario gjentas med ulike verdier:

```gherkin
Scenario Outline: Validering av input
  When bruker skriver "<input>"
  Then ser bruker "<resultat>"

  Examples:
    | input    | resultat        |
    | gyldig   | Suksess         |
    | ugyldig  | Feilmelding     |
    | tom      | Påkrevd felt    |
```

## Bruk Regel-seksjoner

Grupper relaterte scenarios under forretningsregler:

```gherkin
Rule: Kun aktive brukere kan logge inn

  Scenario: Aktiv bruker logger inn
    ...

  Scenario: Deaktivert bruker nektes tilgang
    ...
```

## Bakgrunn for Felles Setup

Flytt gjentatte Gitt-steg til Bakgrunn:

```gherkin
Background:
  Given bruker er logget inn
  And bruker er på dashboard

Scenario: Se statistikk
  When bruker klikker statistikk
  Then ...
```

## Konkrete Eksempler

Bruk spesifikke, realistiske verdier:

```gherkin
# FEIL - generisk
Given en bruker finnes
When bruker søker på noe

# RIKTIG - konkret
Given brukeren "Ola Nordmann" finnes
When bruker søker på "informatikk"
```

## Gherkin Nøkkelord

| Engelsk | Formål |
|---------|--------|
| Feature | Overordnet funksjonalitet |
| Rule | Forretningsregel (grupperer scenarios) |
| Background | Felles forutsetninger |
| Scenario | Konkret testcase |
| Scenario Outline | Parametrisert testcase |
| Examples | Data for Scenario Outline |
| Given | Forutsetning (kontekst) |
| When | Handling (trigger) |
| Then | Forventet resultat |
| And/But | Fortsettelse av forrige step |
