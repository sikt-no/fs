# GitHub Actions Workflows

## Automatiske arbeidsflyter (worksflows) i FS saksoversikt/produktbacklog

Her finner du filer som beskriver automatiske arbeidsflyter som er satt i FS-saksoversikt/produktbacklog. 

Pr. 6. august 2025 har den to aktive arbeidsflyter:
- Arbeidsflyt 1 - setter automatisk startdato på issues når de flyttes til "Under arbeid"-status.
- Arbeidsflyt 2 - setter automatisk ferdigdato på issues når de flyttes til "Ferdig"-status

### Funksjonalitet

- **Trigger**: Aktiveres når:
  - Et project card flyttes mellom kolonner
  - En issue får label "under arbeid"

- **Automatisk handling**:
  - Sjekker om issue er i "Under arbeid" kolonne eller har "under arbeid" label
  - Legger til dagens dato som "Startdato" i issue beskrivelsen
  - Legger til "under arbeid" label hvis den ikke finnes

### Kolonnenavn som triggrer workflowen

Workflowen aktiveres for kolonner med navn som inneholder:
- "under arbeid"
- "in progress" 
- "doing"

### Issue format

Workflowen legger til startdato i følgende format:

```markdown
## Startdato
2024-01-15

## Beskrivelse
[eksisterende innhold]
```

## Automatisk Ferdigdato Workflow

Denne workflowen automatisk setter ferdigdato på issues når de flyttes til "Ferdig" status eller lukkes.

### Funksjonalitet

- **Trigger**: Aktiveres når:
  - Et project card flyttes mellom kolonner
  - En issue lukkes
  - En issue får label "ferdig"

- **Automatisk handling**:
  - Sjekker om issue er i "Ferdig" kolonne, er lukket, eller har "ferdig" label
  - Legger til dagens dato som "Ferdig dato" i issue beskrivelsen
  - Legger til "ferdig" label hvis den ikke finnes

### Kolonnenavn som triggrer ferdigdato workflowen

Workflowen aktiveres for kolonner med navn som inneholder:
- "ferdig"
- "done"
- "complete" 
- "finished"

### Issue format for ferdigdato

Workflowen legger til ferdigdato i følgende format:

```markdown
## Startdato
2024-01-10

## Ferdig dato
2024-01-15
```

### Konfigurasjon

Filene ligger i `.github/workflows/` mappen:
- `update-start-date.yml` - Automatisk startdato
- `update-completion-date.yml` - Automatisk ferdigdato

### Tillatelser

Workflowen trenger standard GitHub Actions tillatelser for å:
- Lese project boards
- Oppdatere issues
- Legge til labels