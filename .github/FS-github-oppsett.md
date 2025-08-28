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
  - Planlagt startdato og planlagt ferdigdato
  - Estimert tid (ansattimer)
  - Seksjonsinformasjon, teaminformasjon
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
- `type:maintenance` - Vedlikehold, teknisk gjeld, refaktorering, oppgraderinger
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

### Status på saker
- `Til vurdering` - Sak er opprettet og kan ses på/analyseres/utfleskes
- `Arbeidskø` - Sak er prioritert for utvikling og klar til at et team tar den på seg.
- `Under arbeid` - Arbeid på sak er startet
- `Ferdig` - Sak er fullført
- `Parkert` - Sak er satt på hold, eller vi har bestemt oss for å ikke gjøre noe med den
  
Standard status for innkomne saker er "til vurdering". Unntaket er bugs som blir markert med prioritetsnivå kritisk og en seksjon. Disse går rett til "arbeidskøen" og skal håndteres med en gang.
Vi prøver å begrense antall saker i arbeidskø og under arbeid for å holde mengden arbeid i gang nede og heller ha fokus på å sluttføre sakerfør vi tar inn nye. Saker starter ofte som større entiteter og deles opp i mindre biter jo nærmere og mer inn i utviklingen vi kommer. 

### Prosesslabels
Kategorisering ut fra hvilket funksjons- eller prosessområde som FS støtter som en gitt sak gjelder. Eksempler: person, organisasjon, planlegge utdanning, opptak, studiegjennomføring, kompetanse, teknisk. 

I denne kategorien har vi også
- `Uplanlagt arbeid` - for å skille ut saker vi må jobbe med som vi ikke har planlagt (typisk, feil som må rettes)
- `Trenger innhold` - Sak som ikke er godt nok beskrevet til å bli arbeidet med, men som allikevel har kommet seg inn i arbeidskø eller til arbeid

### Interne labels
Vi har også labels på seksjon og team, som vi kun bruker i den interne saksoversikten. 

### Milestones (milepæler)
Vi bruker milestones med datoer når vi har prosjektfinansiering med startdato og sluttdato. Issues knyttes til riktig prosjekt. 
- Fremtidens opptak 
- Utdanningsregister (ut 2025)

Vi bruker også milestones til:
- Årsmål for ÅR (Eksempel 2026: Modernisering og legacyavvikling), alle nye features (som ikke er på prosjekt) bør knyttes til og lede oss i retning av årsmålet. Årsmålet skifter hvert år (februar-januar) og må ikke tolkes som at alt skal være ferdig til dato, så her setter vi nok ikke sluttdato, men startdato. 
- Stabilitet, sikkerhet og ytelse, en KPI-milestone som vi samler saker som i hovedsak gjelder bugfikser på ting i produksjon, planlagte vedlikeholds- og sikkerhetsoppgaver, samt stabilitets- og ytelsesforbedringer

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

Vi har fire aktive workflows som automatiserer saksadministrasjon:

### 1. Automatisk prosjekt-tilknytning
- **Fil**: `sync-issues-to-projects.yml`
- **Trigger**: Nye issues opprettes
- **Handling**: 
  - Legger saken til både offentlig og intern saksoversikt
  - Kommenterer på issue om prosjekt-tilknytning

### 2. Automatisk statustildeling ved opprettelse  
- **Fil**: `auto-status-assignment.yml` *(ønsket workflow)*
- **Trigger**: Nye issues opprettes
- **Handling**: 
  - **Standard**: Tildeler status "til vurdering"
  - **Unntak**: Issues med `type:bug` + `priority:critical` + tilordnet seksjon → status "arbeidskø"

### 3. Automatisk startdato
- **Fil**: `update-start-date.yml`
- **Trigger**: Issue flyttes til kolonne med navn som inneholder arbeidsstatus
- **Handling**: 
  - Legger til dagens dato som startdato i issue-beskrivelsen
  - Setter label `under arbeid`
  - Synkroniserer til begge saksoversikter

### 4. Automatisk ferdigdato
- **Fil**: `update-completion-date.yml`  
- **Trigger**: Issue flyttes til kolonne med ferdigstatus eller lukkes
- **Handling**: 
  - Legger til dagens dato som ferdigdato i issue-beskrivelsen
  - Setter label `ferdig`
  - Synkroniserer til begge saksoversikter

### Workflow-triggere

**Kolonnenavn som aktiverer startdato-workflow:**
- "arbeidskø", "under arbeid", "in progress", "doing"

**Kolonnenavn som aktiverer ferdigdato-workflow:**
- "ferdig", "done", "complete", "finished"

---

## 🤝 Hvordan bidra

### For Sikt-ansatte som jobber med FS
1. Opprett issue via GitHub issue template
2. Velg riktig issue type
3. Issues legges automatisk til begge prosjekter
4. Produktledere prioriterer i dialog med team

### For eksterne bidragsytere  
1. Opprett issue via GitHub issue template, meld inn sak via RT eller som tilbakemeldinger direkte fra brukerflatene
2. Issue opprettes "til vurdering"
3. Sikt-team vurderer og prioriterer
4. Hvis saken krever modning konverteres saken til discussion/ide

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

## Ferdigdato  
2024-01-20

## Beskrivelse
[opprinnelig innhold]
```

### Nødvendige tillatelser
Workflows krever standard GitHub Actions-tillatelser for:
- Lesing av project boards
- Oppdatering av issues  
- Håndtering av labels
