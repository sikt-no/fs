# GitHub-oppsett for FS

Dette dokumentet beskriver hvordan vi bruker GitHub Issues, prosjekter, labels, templates og workflows for å administrere utviklingssaker for FS.

## 📋 Innholdsfortegnelse

- [Prosjektstruktur](#-prosjektstruktur)
- [Issues og saksbehandling](#-issues-og-saksbehandling)  
- [Labels og kategorisering](#-labels-og-kategorisering)
- [Issue Templates](#-issue-templates)
- [Automatiske workflows](#-automatiske-workflows)
- [Hvordan bidra](#-hvordan-bidra)

---

## 🏗️ Prosjektstruktur

Vi bruker to parallelle prosjekter som inneholder de samme sakene:

### FS Offentlig saksoversikt
- **Formål**: Åpen produktbacklog synlig for alle
- **Innhold**: Saker under arbeid, i kø for utvikling, til vurdering og ferdigstilte
- **Tilgang**: Offentlig tilgjengelig
- **Link**: [FS Offentlig saksoversikt](https://github.com/orgs/sikt-no/projects/4/views/3)

### FS Saksoversikt (intern)
- **Formål**: Intern oppfølging og rapportering  
- **Innhold**: Samme saker som offentlig, men med tilleggsinformasjon:
  - Startdato og ferdigdato
  - Estimert tid (ansattimer)
  - Seksjonsinformasjon
- **Tilgang**: Kun Sikt-ansatte

---

## 🎫 Issues og saksbehandling

### Hva er en sak?
Hver issue i saksoversikten skal være:
- **Verdifull** i seg selv for kunder eller brukere
- **Komplett problem/leveranse/behov** (ikke delt opp i tekniske komponenter)
- **Prioriterbar** i forhold til andre saker

### Hvem kan opprette saker?
- Brukerstøtte
- Produktteam  
- Andre Sikt-interne team
- Eksterne team (planlagt for fremtiden)

### Saksflyt
```
Ny sak → Til vurdering → I kø → Under arbeid → Ferdig
```

**Viktig**: Produksjonskritiske feil har alltid forrang og kan komme rett til under arbeid!

---

## 🏷️ Labels og kategorisering

### Type-labels (obligatoriske)
Hver issue må ha én av disse ved oppretting:

- `type:feature` - Ny funksjonalitet
- `type:enhancement` - Forbedringer av eksisterende funksjonalitet  
- `type:maintenance` - Teknisk gjeld, refaktorering, oppgraderinger
- `type:bug` - Feilrettinger

### Prioritetslabels
Brukes for å vise viktighetsgrad:

| Label                 | Beskrivelse                           | Brukseksempler                                                              |
|-----------------------|---------------------------------------|-----------------------------------------------------------------------------|
| `priority:critical`   | **KRITISK** - Må løses umiddelbart   | Produksjonsfeil, sikkerhetshull, systemkrasj, juridiske krav med deadline |
| `priority:high`       | **HØY** - Svært viktig for roadmap   | Sentrale features, viktige kundekrav, arkitektoniske endringer             |
| `priority:medium`     | **MEDIUM** - Normal prioritering     | Vanlige features, refaktorering, mindre UX-forbedringer                    |
| `priority:low`        | **LAV** - Nice-to-have               | Optimalisering, eksperimentelle ideer                                      |

**Merk**: `priority:critical` brukes sjelden og kun for akutte situasjoner!

### Statuslabels (automatiske)
Disse settes automatisk av workflows:
- `under arbeid` - Sak er startet
- `ferdig` - Sak er fullført

---

## 📝 Issue Templates

Vi bruker standardiserte templates for å sikre kvalitet og fullstendighet:

### Tilgjengelige templates
- **Issue Report** (`issue_form.yml`) - Strukturert skjema for nye saker
  - Type-kategorisering (feature/bug/enhancement/maintenance)
  - Detaljert beskrivelse
  - Akseptansekriterier (valgfritt)

### Template-konfigurasjon
- **Blank issues**: Deaktivert for å sikre strukturert rapportering
- **Konfigurasjon**: `.github/ISSUE_TEMPLATE/config.yml`

---

## ⚙️ Automatiske workflows

Vi har tre aktive workflows som automatiserer saksadministrasjon:

### 1. Automatisk startdato
- **Fil**: `update-start-date.yml`
- **Trigger**: Issue flyttes til "Under arbeid" eller får `under arbeid` label
- **Handling**: Legger til startdato i issue-beskrivelsen

### 2. Automatisk ferdigdato  
- **Fil**: `update-completion-date.yml`
- **Trigger**: Issue flyttes til "Ferdig" eller lukkes
- **Handling**: Legger til ferdigdato i issue-beskrivelsen

### 3. Automatisk prosjekt-tilknytning
- **Fil**: `sync-issues-to-projects.yml` 
- **Trigger**: Nye issues opprettes
- **Handling**: 
  - Legger automatisk til i både offentlig og intern saksoversikt
  - Kommenterer på issue om tilknytning

### Workflow-triggere
Følgende kolonnenavn aktiverer workflows:

**Startdato-workflow:**
- "under arbeid", "in progress", "doing"

**Ferdigdato-workflow:**  
- "ferdig", "done", "complete", "finished"

---

## 🤝 Hvordan bidra

### For Sikt-ansatte
1. Opprett issue via GitHub issue template
2. Velg riktig type-label og prioritet
3. Issues legges automatisk til begge prosjekter
4. Produktledere prioriterer i dialog med team

### For eksterne bidragsytere  
1. Opprett issue via GitHub issue template
2. Issues legges automatisk til offentlig saksoversikt
3. Sikt-team vurderer og prioriterer

### Produktansvar
- **Produktledere** har ansvar for prioritering av produktbacklog
- **Prioritering** skjer i dialog med team og eksterne interessenter
- **Produksjonsfeil** kan alltid forsere køen

---

## 📁 Filstruktur

```
.github/
├── README.md                           # Dette dokumentet
├── ISSUE_TEMPLATE/
│   ├── issue_form.yml                  # Strukturert issue-skjema
│   └── config.yml                      # Template-konfigurasjon
├── workflows/
│   ├── update-start-date.yml           # Automatisk startdato
│   ├── update-completion-date.yml      # Automatisk ferdigdato
│   └── sync-issues-to-projects.yml     # Prosjekt-synkronisering
└── scripts/
    └── copy-issues-to-internal-project.js  # Skript for issue-kopiering
```

---

## 🔧 Tekniske detaljer

### Issue-format
Workflows legger til metadata i følgende format:

```markdown
## Startdato
2024-01-15

## Ferdig dato  
2024-01-20

## Beskrivelse
[opprinnelig innhold]
```

### Nødvendige tillatelser
Workflows krever standard GitHub Actions-tillatelser for:
- Lesing av project boards
- Oppdatering av issues  
- Håndtering av labels