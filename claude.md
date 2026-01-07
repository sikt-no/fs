# FS Krav og Tester

Dette repositoriet inneholder BDD-baserte kravspesifikasjoner og automatiserte tester for FS-systemet.

## Konsept

Repositoriet bruker Behavior-Driven Development (BDD) for å oppnå to mål:

1. **Levende dokumentasjon**: Gherkin feature-filer fungerer som lesbare kravspesifikasjoner som både domeneeksperter og utviklere kan forstå
2. **Automatiserte tester**: De samme feature-filene driver integrasjons- og ende-til-ende-tester

### Arbeidsflyt

- **Domeneeksperter** skriver og vedlikeholder Gherkin-scenarioer som kravspesifikasjoner
- **Utviklere** implementerer step definitions i TypeScript som kobler scenarioene til kjørbar testkode

## Mappestruktur

```
fs/
├── krav/                          # Gherkin feature-filer (lesbart for alle)
│   ├── 00 Personas/               # Persona-definisjoner
│   ├── 01 Forberede studier/      # Domene: Studieforberedelse
│   ├── 02 Opptak/                 # Domene: Opptak
│   │   ├── 01 Forberede opptak/
│   │   ├── 02 Registrere søknader/
│   │   ├── 03 Søknadsbehandling/
│   │   └── 04 Opptakskjøring/
│   ├── 03 Gjennomføre studier/
│   ├── 04 Kompetanse/
│   ├── 05 Opplysninger om person/
│   ├── 07 Tilgangstyring/
│   ├── 08 Teknisk/
│   ├── 09 Kommunikasjon/
│   └── 10 Felleskrav/
├── tester/                        # All testkode og konfigurasjon (for utviklere)
│   ├── .mise.toml                 # Mise verktøyversjonskonfigurasjon
│   ├── package.json               # Node.js avhengigheter
│   ├── playwright.config.ts       # Playwright konfigurasjon
│   ├── steps/                     # Step definitions
│   └── fixtures/                  # Test fixtures og hjelpefunksjoner
├── README.md                      # Generell introduksjon til repoet
└── claude.md                      # Kontekst for Claude
```

### Separasjon av krav og kode

Repoet er designet for å være tilgjengelig for alle:

- **`krav/`**: Inneholder kun `.feature`-filer som kan leses og forstås av domeneeksperter, produkteiere og andre ikke-tekniske bidragsytere. Ingen kode her.
- **`tester/`**: Inneholder all teknisk konfigurasjon og kode. Utviklere jobber primært her for å implementere step definitions og vedlikeholde testinfrastruktur.

## Teknologier

| Verktøy | Formål |
|---------|--------|
| **mise** | Versjonsadministrasjon for Node.js og andre verktøy |
| **Playwright** | Browser-automatisering og API-testing |
| **playwright-bdd** | Kobler Gherkin-scenarioer til Playwright-tester |
| **Gherkin** | Språk for å skrive lesbare kravspesifikasjoner |

## Testtyper og tags

Feature-filer inneholder scenarioer tagget etter testtype:

| Tag | Beskrivelse | Kjøremiljø |
|-----|-------------|------------|
| `@integration` | Integrasjonstester mot GraphQL API | Playwright API-testing |
| `@e2e` | Ende-til-ende-tester gjennom browser | Playwright browser mot Next.js |

Andre vanlige tags:
- `@ci` - Kjøres i CI/CD pipeline
- `@fsadmin` - Tester for admin-grensesnittet
- Domene-spesifikke tags (f.eks. `@opptakspilot`)

## Gherkin-språk

Alle feature-filer skrives på **norsk**. Hver fil må starte med:

```gherkin
# language: no
```

Norske Gherkin-nøkkelord:
- `Egenskap:` (Feature)
- `Scenario:` (Scenario)
- `Gitt` (Given)
- `Når` (When)
- `Og` (And)
- `Så` (Then)

## Målmiljøer

Testene kan kjøres mot flere miljøer:
- Lokal utviklingsserver
- Staging/testmiljø
- Produksjonsmiljø (med forsiktighet)

Miljø velges via miljøvariabler eller Playwright-konfigurasjon.

## CI/CD

- **GitHub Actions**: Bygger Docker-image med testmiljø
- **GitLab**: Kjører testene fra Docker-imaget i bedriftens CI/CD

## Konvensjoner for Claude

### Når du jobber med feature-filer
- Bruk alltid `# language: no` på toppen
- Følg eksisterende mappestruktur basert på domene
- Bruk beskrivende scenario-navn på norsk
- Inkluder relevante tags for testtype og domene

### Når du jobber med step definitions
- Skriv i TypeScript
- Plasser step definitions i `tester/steps/`
- Plasser fixtures og hjelpefunksjoner i `tester/fixtures/`
- Følg playwright-bdd sin syntaks og mønstre
- All konfigurasjon (mise, package.json, playwright.config.ts) ligger i `tester/`

### Testutførelse
- `@integration` tester: Bruker `request` fixture for API-kall
- `@e2e` tester: Bruker `page` fixture for browser-interaksjon
