# GitHub Actions Workflows

## Automatiske arbeidsflyter (worksflows) i FS saksoversikt/produktbacklog

Her finner du filer som beskriver automatiske arbeidsflyter som er satt i FS-saksoversikt/produktbacklog. 

Pr. 6. august 2025 har den tre aktive arbeidsflyter:
- Arbeidsflyt 1 - setter automatisk startdato på issues når de flyttes til "Under arbeid"-status.
- Arbeidsflyt 2 - setter automatisk ferdigdato på issues når de flyttes til "Ferdig"-status
- Arbeidsflyt 3 - legger automatisk nye issues til både FS Offentlig saksoversikt og FS Saksoversikt (intern)

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
- `sync-issues-to-projects.yml` - Automatisk prosjekt-tilknytning

## Automatisk Prosjekt-tilknytning Workflow

Denne workflowen legger automatisk alle nye issues til både offentlig og intern saksoversikt.

### Funksjonalitet

- **Trigger**: Aktiveres når nye issues opprettes
- **Automatisk handling**:
  - Legger til issue i "FS Offentlig saksoversikt" 
  - Legger til issue i "FS Saksoversikt (intern)"
  - Legger til kommentar på issue om prosjekt-tilknytning

### Kopiering av eksisterende issues

For å kopiere alle eksisterende issues fra offentlig til intern saksoversikt:

```bash
# Sett GitHub token som environment variabel
export GITHUB_TOKEN=your_token_here

# Kjør kopieringsskript
node .github/scripts/copy-issues-to-internal-project.js
```

Skriptet vil:
- Opprette "FS Saksoversikt (intern)" prosjekt hvis det ikke finnes
- Kopiere alle issues fra offentlig til intern saksoversikt
- Beholde kolonne-tilknytning der mulig

### Tillatelser

Workflowen trenger standard GitHub Actions tillatelser for å:
- Lese project boards
- Oppdatere issues
- Legge til labels