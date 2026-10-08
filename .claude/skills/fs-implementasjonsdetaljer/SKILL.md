---
name: fs-implementasjonsdetaljer
description: Utdyp en eksisterende .feature-fil med UI- og design-patterns i en fil med implementasjonsdetaljer (<feature>.design.md). Bruk når brukeren vil "utdype implementasjon", "legge til designdetaljer", "beskrive UI for en feature", "lage designnotater" eller "skrive implementasjonsdetaljer" knyttet til et konkret krav. Skillen holder .feature-filen ren BDD (hva) og legger hvordan-detaljer ved siden av. Verifiserer også at hjelpetekster, feilmeldinger og andre tekster med variasjoner står i implementasjonsdetaljene, ikke bare i skissene. Trigges også av "sjekk tekstene i skissene", "flytt tekstene til design.md", "mangler feilmeldingene i implementasjonsdetaljene".
---

# Implementasjonsdetaljer

Skriv implementasjonsdetaljene for en eksisterende `.feature`-fil: UI/design-patterns og tekster, i `<feature-navn>.design.md` i samme mappe. Feature-filen forblir uendret.

## Når denne skillen brukes

- Brukeren refererer til en konkret `.feature`-fil og vil utdype hvordan den skal se ut / oppføre seg i UI
- Domeneeksperter har skrevet hva-et; nå trenger utviklere hvordan-et
- `fs-specify` eller `fs-specify-delta` kjører den når implementasjonsdetaljene mangler, eller ikke har tekstene fra skissene

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

### 3. Verifiser tekstene i skissene
Tekster med variasjoner hører hjemme i implementasjonsdetaljene, ikke i skissene. En skisse viser én tilstand, blir fort utdatert, og kan ikke søkes i eller endres i en PR. Implementasjonsdetaljene er fasiten for tekstene; skissen viser bare hvor de står.

**Finn skissene** til feature-fila:
- Skisser brukeren peker på (Figma-lenke, bilde, PDF), eller som `fs-specify` / `fs-specify-delta` gir når de kjører skillen. Da er skissene allerede hentet og validert mot kravene: bruk dem, og let ikke etter flere.
- Spesifikasjoner som har med feature-fila: `grep -l "<feature-navn>.feature" tasks/*/*/spec/spec-*.md`. Skissene står under `## Skisser`, og filene under `tasks/<domene>/<slug>/spec/krav-input/sketches/` (Figma-artefaktene i `figma/<sketch-slug>/`, med `design-context.md` og skjermbilder).
- Figma-lenker som ikke er persistert, leses med Figma-MCP (`get_design_context`, `get_screenshot`) når den er koblet til. Er den ikke det, be brukeren om skjermbilde eller å beskrive tekstene.

Finnes det ingen skisser, hopp over steget og si det.

**Les tekstene** i hver skisse (`Read` på bilder og `design-context.md`), og finn dem som er implementasjonsdetaljer:
- hjelpetekster, plassholdere og verktøytips
- feilmeldinger og valideringsmeldinger
- bekreftelser, kvitteringer og varsler (suksess, advarsel)
- tom tilstand og lastetekster
- tekster som varierer: etter status, rolle, antall (entall/flertall), delvis suksess, eller med verdier som settes inn (`«{antall} tilganger ble fjernet»`)

Overskrifter, feltetiketter og knappetekster som står fast, trenger ikke være med, med mindre de varierer.

**Sammenlign** med implementasjonsdetaljene, og klassifiser hver tekst som **én** av:
- **OK**: teksten står i `## Tekster`, med de samme variasjonene.
- **Mangler**: teksten står bare i skissen. Den skal inn i implementasjonsdetaljene.
- **Avvik**: implementasjonsdetaljene og skissen har ulik tekst.
- **Ufullstendig**: skissen viser én variant, men kravet har flere (f.eks. en feilmelding, mens scenarioene har flere feiltilfeller). De andre variantene mangler.

For **Mangler**: legg teksten inn i `## Tekster` ordrett fra skissen, med når den vises og hvilket scenario den hører til. For **Avvik** og **Ufullstendig**: spør med `AskUserQuestion`, én tekst om gangen (hvilken tekst er riktig, og hva de andre variantene skal være). Gjett ikke tekst. Det som ikke blir avklart, går til «Åpne designspørsmål».

Skissene endres ikke. Er en skisse utdatert, noter det under «Åpne designspørsmål».

Rapporter til slutt i chat: hvor mange tekster som ble funnet, og hvilke som ble lagt inn, avklart eller står åpne, med skissen hver tekst kom fra.

### 4. Still målrettede spørsmål
Bruk `AskUserQuestion` for å avklare. Eksempler:
- "Hvilken layout brukes for listevisningen — tabell, kort, eller liste?"
- "Hvor utløses primærhandlingen — toppen av siden, ved hver rad, eller begge?"
- "Hva skjer ved tom tilstand?"

Spør om én ting av gangen. Ikke gjett — be om svar når noe er uklart. I Claude-panelet i FS Kravforvaltning virker `AskUserQuestion`: brukeren får spørsmålet som et kort med valgene. Hopper brukeren over, still spørsmålene i svaret, og vent på brukeren.

### 5. Skriv implementasjonsdetaljene
Lagre som `<feature-navn>.design.md` i samme mappe som `.feature`-filen.

Mal:

```markdown
# Implementasjonsdetaljer: <Feature-tittel>

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

## Tekster

Hjelpetekster, feilmeldinger, bekreftelser og andre tekster med variasjoner. Dette er fasiten for tekstene, også når en skisse viser noe annet.

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| <felt, dialog, side> | <tilstand eller hendelse> | «<tekst>» | <f.eks. entall/flertall, per status, `{antall}`> | <scenarionavn> |

**Skisser:** <hvilke skisser tekstene er sjekket mot, med sti eller lenke>

## Per-scenario detaljer

### Scenario: <navn fra feature-filen>
<UI-spesifikke notater som utdyper akkurat dette scenarioet>

## Åpne designspørsmål

- [ ] <spørsmål>
```

## Konvensjoner

- **Ikke endre `.feature`-filen.** Implementasjonsdetaljene er et rent tillegg.
- **Bruk relative lenker** til feature-filen.
- **Hold det kort.** Notatene skal være lesbare, ikke uttømmende.
- **Tekster står i implementasjonsdetaljene, ikke bare i skissene.** Hjelpetekster, feilmeldinger og tekster med variasjoner skrives i `## Tekster`, med alle variantene. Skissen viser bare hvor de står.
- **Marker uavklarte ting** under "Åpne designspørsmål" — ikke gjett.
- **Følg terminologi-reglene** i `krav/README.md` (organisasjon vs. lærested, osv.)