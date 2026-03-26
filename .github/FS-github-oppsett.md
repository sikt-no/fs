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

Vi bruker to parallelle prosjekter:

### FS Offentlig saksoversikt
- **Formål**: Åpen oversikt over initiativer og saker synlig for alle interessenter
- **Innhold**: Offentlig veikart med initiativer og offentlig saksoversikt med initiativer og saker
- **Tilgang**: Offentlig tilgjengelig
- **Link**: [FS Offentlig saksoversikt](https://github.com/orgs/sikt-no/projects/4/views/3)

### FS Saksoversikt (intern)
- **Formål**: Intern planlegging, oppfølging og status  
- **Innhold**: Samme saker som offentlig, men med tilleggsinformasjon
  - Planlagt startdato og planlagt ferdigdato
  - Estimert tid (ansattimer)
  - Seksjonsinformasjon, teaminformasjon
- **Tilgang**: Kun Sikt-ansatte

---

## 🎫 Issues og saksbehandling

### Produktansvar og redaksjonelt ansvar for saksoversikten
- **Produktledere** har ansvar for prioritering og innhold
- **Prioritering** skjer i dialog med team og eksterne interessenter
- **Produksjonsfeil** kan alltid forsere køen

### Hvem kan opprette issues?
- Brukerstøtte
- Produktteam  
- Andre Sikt-interne team
- Eksterne team (planlagt for fremtiden)

### Team som jobber med å løse en sak kan holde innholdet i saken ved like
Dersom det er spørsmål om vesentlig endring av omfang eller tidsbruk, så skal produktleder involveres

### Hva er issuetypene sak og initiativ?
Ethvert issue (sak eller initiativ) i saksoversikten skal være:
- **Verdifull** i seg selv for kunder eller brukere
- **Komplett problem/leveranse/behov** (ikke delt opp i tekniske komponenter)
- **Prioriterbar** i forhold til andre saker
- Et initiativ kan bestå av flere enkeltsaker, men det er kun initiativer som ligger i veikartet vi kommuniserer som vår mer langsiktige plan framover til sektor.

### Saksflyt
Happy path gjennom vår utviklingsmodell: https://fs.sikt.no/utviklerhandbok/utviklingsmodell/
```
Ny sak → Til vurdering → Prioritert → Behovsanalyse → Løsningsalternativer → Utvikling → Ferdig
```

**Viktig**: Produksjonskritiske feil har alltid forrang og kan komme rett til under arbeid!

---

## 🏷️ Labels og kategorisering

### Type-labels (obligatoriske)
Hver issue må ha én av disse ved oppretting:

- `type:feature` - Ny eller forbedret funksjonalitet 
- `type:maintenance` - Vedlikehold, teknisk gjeld, refaktorering, oppgraderinger
- `type:bug` - Feilrettinger
- `type:task` - Annen type oppgave

### Prioritetslabels
Brukes for å vise viktighetsgrad:

| Label                 | Beskrivelse                           | Brukseksempler                                                              |
|-----------------------|---------------------------------------|-----------------------------------------------------------------------------|
| `priority:critical`   | **KRITISK** - Må løses umiddelbart   | Produksjonsfeil, sikkerhetshull, systemkrasj, juridiske krav med deadline  |
| `priority:high`       | **HØY** - Svært viktig for roadmap   | Sentrale features, viktige kundekrav, arkitektoniske endringer             |
| `priority:medium`     | **MEDIUM** - Normal prioritering     | Vanlige features, refaktorering, mindre UX-forbedringer                    |
| `priority:low`        | **LAV** - Nice-to-have               | Optimalisering, eksperimentelle ideer                                      |

**Merk**: `priority:critical` brukes sjelden og kun for akutte situasjoner!

### Status på saker i intern backlog skal følge utviklingsmodellen vår
https://fs.sikt.no/utviklerhandbok/utviklingsmodell/ 
- `Til vurdering` - Sak er opprettet med grunnleggende beskrivelse, kan analyseres for prioritering (sak ikke i utviklingsprosess ennå)
- `Prioritert` - Sak er prioritert for arbeid og er klar nok til at et team kan begynne med behovsanalyse og kravspesifikasjon
- `Behovsanalyse` - Arbeid på sak er startet med behovsanalyse, kravspesifikasjon, eller utforskning av løsningsalternativer
- `Løsningsalternativ` - Arbeid på sak er startet med behovsanalyse, kravspesifikasjon, eller utforskning av løsningsalternativer
- `Utvikling` - Saken er under utvikling med løpende planlegging og brukermedvirkning
- `Innføring` - Sak er fullført mht utvikling, men vi har et overgangsløp hvor er i tettere kontakt med brukere/samarbeidspartnere og kan gjøre justeringer
- `Levert` - Sak er enten levert eller lukket (som duplikat, eller vi gjør ikke noe med den) (saken er ferdig i utviklingsprosessen)
  
Standard status for innkomne saker er "til vurdering". Unntaket er bugs som blir markert med prioritetsnivå kritisk og en seksjon. Disse går rett til "Utforskning" og skal håndteres med en gang.
Vi prøver å begrense antall saker i arbeidskø og under arbeid for å holde mengden arbeid i gang nede og heller ha fokus på å sluttføre sakerfør vi tar inn nye. Saker starter ofte som større entiteter og deles opp i mindre biter jo nærmere og mer inn i utviklingen vi kommer. 

### Prosesslabels
Kategorisering ut fra hvilket funksjons- eller prosessområde som FS støtter som en gitt sak gjelder. Eksempler: person, organisasjon, planlegge utdanning, opptak, studiegjennomføring, kompetanse, teknisk. 

I denne kategorien har vi også
- `Uplanlagt arbeid` - for å skille ut saker vi må jobbe med som vi ikke har planlagt (typisk, feil som må rettes)
- `Trenger innhold` - Sak som ikke er godt nok beskrevet til å bli arbeidet med, men som allikevel har kommet seg inn i arbeidskø eller til arbeid

### Interne labels
Vi har også labels på seksjon og team, som vi kun bruker i den interne saksoversikten. 

### Milestones (milepæler)
Vi bruker milestones til:
- Årsmål for ÅR med startdato og sluttdato
- Prosjektfinansiering med startdato og sluttdato
- Felles samlemilepæl uten start og sluttdato for løpende vedlikehold og feilrettinger

---

## 📝 Issue Templates

Vi bruker standardiserte templates for å sikre kvalitet og fullstendighet:

### Tilgjengelige templates
- **Issue Report** (`issue_form.yml`) - Strukturert skjema for nye saker
  - Type-kategorisering (feature/bug/maintenance)
  - Beskrivelse av sak se template

### Template-konfigurasjon
- **Blank issues**: Deaktivert for å sikre strukturert rapportering
- **Konfigurasjon**: `.github/ISSUE_TEMPLATE/config.yml`

---

## ⚙️ Automatiske workflows med triggere

Vi har fire aktive workflows som automatiserer saksadministrasjon i FS-repoet:

### 1. Automatisk prosjekt-tilknytning
- **Fil**: `sync-issues-to-projects.yml`
- **Trigger**: Nye issues opprettes
- **Handling**: 
  - Saken knyttes til intern saksoversikt for FS
  - Når en sak er klar til å deles i ekstern oversikt, så må du foreta et aktivt valg om å legge den til.

### 2. Automatisk statustildeling ved opprettelse  
- **Fil**: `auto-status-assignment.yml` *(ønsket workflow)*
- **Trigger**: Nye issues opprettes
- **Handling**: 
  - **Standard**: Tildeler status "til vurdering"
  - **Unntak**: Issues med `type:bug` + `priority:critical` + tilordnet seksjon → status "behovsanalyse"

### 3. Automatisk startdato
- **Fil**: `update-start-date.yml`
- **Trigger**: Issue i  FS Saksoversikt (intern) flyttes til kolonne med navn som inneholder arbeidsstatus "Behovsanalyse"
- **Handling**: 
  - Legger til dagens dato som startdato i issue-beskrivelsen for både  FS Saksoversikt (intern) og FS Offentlig saksoversikt

### 4. Automatisk ferdigdato
- **Fil**: `update-completion-date.yml`  
- **Trigger**: Issue lukkes fordi den er ferdig (issue closed reason completed)
- **Handling**: 
  - Legger til dagens dato som ferdigdato på saken
  - Setter status `Levert`
  - Synkroniserer til begge saksoversikter for både  FS Saksoversikt (intern) og FS Offentlig saksoversikt

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
