# Gherkin-syntaks (norsk)

Denne fila beskriver **kun formen** — hvordan Gherkin ser ut. Den sier ingenting om hvilke domener, aktører, tags eller Feature-ID-er et prosjekt bruker. Det er prosjektkonvensjoner, og de eies av repoets egen `krav/README.md`.

## Språk og nøkkelord

Norsk Gherkin aktiveres med `# language: no` på **første linje** i fila. Uten den tolkes nøkkelordene som engelske.

| Norsk | Engelsk | Rolle |
|-------|---------|-------|
| `Egenskap:` | `Feature:` | Toppnivå. Én per fil (flere er lov, men uvanlig) |
| `Bakgrunn:` | `Background:` | Felles forutsetninger for alle scenarios i fila |
| `Regel:` | `Rule:` | Grupperer scenarios under én forretningsregel |
| `Scenario:` | `Scenario:` | Ett konkret eksempel |
| `Scenariomal:` | `Scenario Outline:` | Samme scenario kjørt med flere datasett |
| `Eksempler:` | `Examples:` | Datatabellen som hører til en `Scenariomal:` |
| `Gitt` | `Given` | Forutsetning / utgangstilstand |
| `Når` | `When` | Handlingen som utføres |
| `Så` | `Then` | Forventet resultat |
| `Og` / `Men` | `And` / `But` | Fortsetter forrige ledd |

`Og` og `Men` arver typen fra linja over: `Gitt … / Og …` er to forutsetninger, `Så … / Og …` er to forventninger.

## Blokkstruktur og innrykk

Innrykk er ikke syntaktisk påkrevd, men konsekvent innrykk er konvensjon og gjør filene lesbare. Vanlig mønster: to mellomrom per nivå.

```gherkin
# language: no
@tag-på-egenskapen
Egenskap: Kort tittel
  Som en {aktør}
  ønsker jeg å {handling}
  slik at {verdi}.

  Bakgrunn:
    Gitt {felles forutsetning}

  Regel: {forretningsregel}

    Scenario: {navn}
      Gitt {forutsetning}
      Når {handling}
      Så {forventet resultat}
      Og {ytterligere forventning}
```

Linjene rett under `Egenskap:` er fri tekst (brukerhistorien) — Gherkin tolker dem ikke, de er dokumentasjon.

## Tags

En tag er `@ord` uten mellomrom. Tags står på **linja rett over** elementet de gjelder, og flere tags skilles med mellomrom:

```gherkin
@min-id @must @planned
Egenskap: …

  @openquestion
  Scenario: …
```

Tags kan stå over `Egenskap:`, `Regel:`, `Scenario:` og `Scenariomal:`. En tag på `Egenskap:` gjelder alt i fila; en tag på et enkelt-`Scenario:` gjelder bare det. *Hvilke* tags som er i bruk, og hva de betyr, står i prosjektets konvensjonsfil.

## Scenariomal og Eksempler

Bruk `Scenariomal:` når samme atferd skal verifiseres med flere konkrete dataverdier. Parametere skrives `<navn>` i stegene og som kolonneoverskrifter i tabellen.

```gherkin
  Scenariomal: {navn på variasjonen}
    Gitt at feltet har verdien <input>
    Når skjemaet lagres
    Så vises meldingen "<melding>"

    Eksempler:
      | input    | melding              |
      | tom      | Feltet er påkrevd    |
      | 12345678 | Lagret               |
```

**`Eksempler:` skal aldri stå alene** — den hører alltid til en `Scenariomal:` over seg. Et vanlig `Scenario:` kan ikke ha `Eksempler:`.

Tabellceller skilles med `|`. Omkringliggende mellomrom trimmes, så kolonnene kan justeres for lesbarhet.

## Kommentarer

`#` starter en kommentar, og må være det første ikke-blanke tegnet på linja. Det finnes ingen blokk-kommentar.

```gherkin
# Dette er en kommentar
Scenario: …
  # TODO: avklar med produkteier
  Gitt …
```

Kommentarer brukes blant annet til `# language: no`, til å bære referanser (f.eks. saksnummer) og til å notere åpne spørsmål. Konvensjonene for *hvilke* kommentar-markører prosjektet bruker står i konvensjonsfila.

## Doc strings og datatabeller i steg

Et steg kan ta med seg en flerlinjes tekst (`"""`) eller en tabell:

```gherkin
  Scenario: …
    Gitt følgende brukere:
      | navn  | rolle         |
      | Ada   | administrator |
      | Bjørn | søker         |
    Når meldingen sendes:
      """
      Flerlinjes tekst
      som hører til steget over.
      """
    Så …
```

Begge deler hører til steget rett over, og rykkes inn under det.
