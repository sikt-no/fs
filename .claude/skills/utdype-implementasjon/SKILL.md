---
name: utdype-implementasjon
description: Utdyp en eksisterende .feature-fil med UI- og design-patterns i en sidecar-fil (<feature>.design.md). Bruk når brukeren vil "utdype implementasjon", "legge til designdetaljer", "beskrive UI for en feature", eller "lage designnotater" knyttet til et konkret krav. Skillen holder .feature-filen ren BDD (hva) og legger hvordan-detaljer ved siden av.
---

# Utdype implementasjon

Lag en sidecar-fil `<feature-navn>.design.md` som beskriver UI/design-patterns for en eksisterende `.feature`-fil. Feature-filen forblir uendret.

## Når denne skillen brukes

- Brukeren refererer til en konkret `.feature`-fil og vil utdype hvordan den skal se ut / oppføre seg i UI
- Domeneeksperter har skrevet hva-et; nå trenger utviklere hvordan-et

## Arbeidsflyt

### 1. Forstå utgangspunktet
- Les `.feature`-filen som ble pekt ut
- Identifiser scenarioene og hvilke UI-elementer de implisitt forutsetter (knapper, lister, skjemaer, navigasjon)
- Sjekk om det finnes en eksisterende `<feature-navn>.design.md` — i så fall, oppdater i stedet for å overskrive

### 2. Identifiser hull
For hvert scenario, vurder hva som mangler av UI-detaljer:
- Hvilken sidetype/komponent? (liste, detaljside, modal, wizard)
- Hva er primær handling? Sekundære handlinger?
- Hvilke felter vises, og i hvilken rekkefølge?
- Hvordan håndteres tom tilstand, lasting, feil?
- Hvilke navigasjons- eller filtreringsmønstre forventes?
- Hvordan kobles dette til eksisterende komponenter?

### 3. Still målrettede spørsmål
Bruk `AskUserQuestion` for å avklare. Eksempler:
- "Hvilken layout brukes for listevisningen — tabell, kort, eller liste?"
- "Hvor utløses primærhandlingen — toppen av siden, ved hver rad, eller begge?"
- "Hva skjer ved tom tilstand?"

Spør om én ting av gangen. Ikke gjett — be om svar når noe er uklart.

### 4. Skriv sidecar-filen
Lagre som `<feature-navn>.design.md` i samme mappe som `.feature`-filen.

Mal:

```markdown
# Designnotater: <Feature-tittel>

**Relatert feature:** [`<feature-navn>.feature`](./<feature-navn>.feature)

## Overordnet UI-mønster

<Sidetype, hovedlayout, plassering i applikasjonen>

## Komponenter og layout

<Hvilke komponenter, struktur, hierarki — kort og presist>

## Interaksjonsmønstre

### Primærhandling
<Hva, hvor, hvordan utløses>

### Sekundære handlinger
<Liste>

### Navigasjon
<Hvordan kommer brukeren hit, hvor går de videre>

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Tom | ... |
| Laster | ... |
| Feil | ... |
| Suksess | ... |

## Per-scenario detaljer

### Scenario: <navn fra feature-filen>
<UI-spesifikke notater som utdyper akkurat dette scenarioet>

## Åpne designspørsmål

- [ ] <spørsmål>
```

## Konvensjoner

- **Ikke endre `.feature`-filen.** Sidecar-filen er rent tillegg.
- **Bruk relative lenker** til feature-filen.
- **Hold det kort.** Notatene skal være lesbare, ikke uttømmende.
- **Marker uavklarte ting** under "Åpne designspørsmål" — ikke gjett.
- **Følg terminologi-reglene** i `.claude/rules/gherkin-conventions.md` (organisasjon vs. lærested, osv.)