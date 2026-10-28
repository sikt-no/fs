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
│   ├── README.md                  # Slik jobber vi med krav (konvensjonene, forsiden i vieweren)
│   ├── 01 Utdanning/
│   ├── 02 Opptak/
│   ├── 03 Gjennomføre studier/
│   ├── 04 Kompetanse/
│   ├── 05 Opplysninger om person/
│   ├── 07 Brukeradministrasjon og tilgangsstyring/
│   ├── 08 Teknisk/
│   ├── 09 Organisasjon/
│   ├── 10 Felleskrav/
│   ├── _Flyter/                   # Flyter på tvers av domener (pilot, se «Flyter» i krav/README.md)
│   └── 99 Demo/                   # Demo/test features
├── cdp-tester/                    # Varige tester for den agentiske funksjonstesten (Gherkin som en agent kjører i Chrome mot testmiljø), lages fra krav/ (se cdp-tester/README.md)
├── akseptansetest/                # Testplaner, testcaser og rapporter for testfasene, og kjøringene av den agentiske testen (se akseptansetest/README.md)
├── tester/                        # All testkode og konfigurasjon (for utviklere)
│   ├── .mise.toml                 # Mise: Node.js versjon (lts)
│   ├── package.json               # Node.js avhengigheter
│   ├── tsconfig.json              # TypeScript konfigurasjon
│   ├── playwright.config.ts       # Playwright + playwright-bdd konfigurasjon
│   ├── steps/                     # Step definitions
│   ├── fixtures/                  # Test fixtures og hjelpefunksjoner
│   └── .features-gen/             # Genererte testfiler (gitignored)
├── fs-kravforvaltning/            # FS Kravforvaltning: krav i nettleser og desktop-app (Vite + Preact, Electron)
├── kom-i-gang.html                # Innføring i kravarbeidet og akseptansetesten, steg for steg (se .claude/rules/kom-i-gang-sync.md)
├── README.md
└── claude.md
```

### Separasjon av krav og kode

- **`krav/`**: Kun `.feature`-filer som kan leses av alle. Ingen kode.
  Konvensjonene for kravfilene (språk, filnavn, mappestruktur, tags, terminologi) står i [`krav/README.md`](krav/README.md). `.claude/rules/gherkin-conventions.md` importerer den med `@../../krav/README.md` (bare når Claude jobber med `.feature`-filer eller `krav/**/*.md`), så det finnes bare én versjon. Bruk import, ikke symlenke: Git for Windows sjekker ut symlenker som tekstfiler med bare målstien.
- **`tester/`**: All teknisk konfigurasjon og kode. Utviklere jobber her.

## Kjøre tester

Alle kommandoer kjøres fra `tester/` mappen med mise:

```bash
cd tester

# Generer og kjør alle tester
~/.local/bin/mise exec -- npm test

# Kun generere testfiler fra features
~/.local/bin/mise exec -- npx bddgen

# Kjør tester med synlig browser
~/.local/bin/mise exec -- npx playwright test --headed

# Kjør spesifikke tags
~/.local/bin/mise exec -- npx playwright test --grep @demo

# Vis HTML-rapport med trace
~/.local/bin/mise exec -- npx playwright show-report
```

### npm scripts

| Script | Beskrivelse |
|--------|-------------|
| `npm test` | Generer og kjør alle tester |
| `npm run bddgen` | Generer testfiler fra features |
| `npm run test:headed` | Kjør med synlig browser |
| `npm run test:integration` | Kun @integration tester |
| `npm run test:e2e` | Kun @e2e tester |

## FS Kravforvaltning

`fs-kravforvaltning/` (**FS Kravforvaltning**) viser hele `krav/`-treet i nettleseren og som desktop-app, med avvik fra konvensjonene, redigering og PR, oppgavene i `tasks/`, spesifikasjonene og et Claude-panel. Den statiske versjonen publiseres til GitHub Pages (<https://sikt-no.github.io/fs/>) ved push til `main`.

```bash
cd fs-kravforvaltning
npm install
npm run dev
```

Hvordan appen er bygget, kommandoene, release og reglene for å jobbe i den står i [`fs-kravforvaltning/CLAUDE.md`](fs-kravforvaltning/CLAUDE.md). Claude leser den når den jobber med filer i mappa. En endring i appen som brukerne merker, skal ha en changeset i samme PR.

## Teknologier

| Verktøy | Formål |
|---------|--------|
| **mise** | Versjonsadministrasjon for Node.js |
| **Playwright** | Browser-automatisering og API-testing |
| **playwright-bdd** | Kobler Gherkin-scenarioer til Playwright-tester |
| **Gherkin** | Språk for lesbare kravspesifikasjoner |

## Testtyper og tags

| Tag | Beskrivelse | Kjøremiljø |
|-----|-------------|------------|
| `@integration` | Integrasjonstester mot GraphQL API | Playwright API-testing |
| `@e2e` | Ende-til-ende-tester gjennom browser | Playwright browser |
| `@demo` | Demo-tester for å verifisere oppsett | Browser |

Andre vanlige tags:
- `@ci` - Kjøres i CI/CD pipeline
- `@fsadmin` - Tester for admin-grensesnittet
- Domene-spesifikke tags (f.eks. `@opptakspilot`)
- `@scope-<slug>` - Kobler kravet til et scope (`tasks/<domene>/scope-<slug>.md`) og oppgavene i det. Settes av `fs-scope`. Kjør kravene i et scope med `npx playwright test --grep @scope-<slug>`
- `@depends-on-<Feature-ID>` - Delen bygger på et annet krav, og må sjekkes når det endres. Finn kravene som bygger på et krav med `grep -rn "@depends-on-<ID>" krav/`
- `@ref-<Feature-ID>` - Henvisning til et annet krav for den som leser. Se *Referanser* i [`krav/README.md`](krav/README.md)

## Gherkin-språk og konvensjoner

Feature-filene skrives på norsk Gherkin. Nøkkelord, gode scenarioer, filnavn, mappestruktur, tags og terminologi står i [`krav/README.md`](krav/README.md).

## playwright-bdd konfigurasjon

Konfigurasjon i `tester/playwright.config.ts`:

```typescript
const testDir = defineBddConfig({
  featuresRoot: '../krav',
  features: '../krav/**/*.feature',
  steps: './steps/**/*.ts',
  language: 'no',                    // Norsk Gherkin
  missingSteps: 'skip-scenario',     // Hopp over scenarioer uten steps
  tags: '@demo',                     // Filtrer på tags (valgfritt)
});
```

### Debugging

Playwright er konfigurert med:
- `trace: 'on'` - Full trace for hvert steg
- `screenshot: 'on'` - Screenshots underveis
- `video: 'on'` - Video av hele testen

Se trace i HTML-rapporten: `npx playwright show-report`

## Konvensjoner for Claude

### Når du jobber med feature-filer
- Følg konvensjonene i [`krav/README.md`](krav/README.md)
- Bruk beskrivende scenario-navn på norsk

### Når du jobber med step definitions
- Skriv i TypeScript
- Plasser step definitions i `tester/steps/`
- Bruk `createBdd()` fra playwright-bdd
- Importer `expect` fra `@playwright/test`

Eksempel step definition:
```typescript
import { expect } from '@playwright/test';
import { createBdd } from 'playwright-bdd';

const { Given, When, Then } = createBdd();

Given('at brukeren er på siden', async ({ page }) => {
  await page.goto('https://example.com');
});

When('brukeren skriver {string} i feltet', async ({ page }, tekst: string) => {
  await page.locator('input').fill(tekst);
});

Then('skal {string} vises', async ({ page }, tekst: string) => {
  await expect(page.locator('text=' + tekst)).toBeVisible();
});
```

### Testutførelse
- `@integration` tester: Bruker `request` fixture for API-kall
- `@e2e` tester: Bruker `page` fixture for browser-interaksjon

### Skills for kravarbeid (`.claude/skills/`)
- `fs-scope` — avgrenser et initiativ og deler det i oppgaver: scope-fila `tasks/<domene>/scope-<slug>.md` (mål, ikke-mål, kilder, og oppgavene med kravene hver oppgave har), oppgavene (`oppgave.md` med `Scope:`), skjelett-krav (`@draft`, `Regel:`-titler uten scenarioer) og taggen `@scope-<slug>` på kravene. Kildene (GitHub, Confluence, Jira, Figma, filer, URL-er) er valgfrie. Kan kjøres på nytt når som helst, og `fs-krav` og `fs-specify` foreslår den når et krav ikke passer i scopet
- `fs-krav` — kravarbeid: nye `.feature`-filer og utfylling av skjelett-filer fra `fs-scope`, ferdigstilling av en mappe (`@draft` → `@planned`), fjerning av krav (leverte krav får `@deprecated`, resten slettes), endring av leverte krav (egenskapen blir `@implemented`, den nye delen får `@planned` når den er validert, og delen den erstatter får `@deprecated`), og flyter i `krav/_Flyter` (én `Regel:` per fase, med `@depends-on-` til kravene fasen bygger på)
- `fs-krav-avvik` — ser etter avvik fra konvensjonene som krever skjønn, og som FS Kravforvaltning ikke sjekker automatisk (f.eks. «egne» og «dem», terminologi, listevisningsmønsteret), i en mappe eller fil under `krav/`, i referansene (regeltitler under taggen som ikke finnes, og ankre som ikke stemmer med dem), og i flytene (faser uten krav, regler gjentatt i flyten). Rapporterer med `fil:linje` og forslag, retter bare ren ordlyd etter at brukeren har sagt ja, og endrer aldri tagger
- `fs-specify` — henter `@planned`-krav inn i en oppgave: `tasks/<domene>/<slug>/spec/` (`@planned` → `@in-progress`, også på `@planned`-deler i leverte krav som endres). Plukker også opp `@deprecated`-krav, og lager en spec for å fjerne koden
- `fs-specify-delta` — det samme, men for en endring (commit, branch, test-fil eller markdown), med samme tag-regler, også for `@deprecated`
- `fs-implementasjonsdetaljer` — implementasjonsdetaljene for et krav i `<feature>.design.md` ved siden av feature-fila: UI-mønstre, tilstander og tekstene. Sjekker at hjelpetekster, feilmeldinger og andre tekster med variasjoner står der, ikke bare i skissene. `fs-specify` og `fs-specify-delta` kjører den når implementasjonsdetaljene mangler
- `fs-verify` — verifiserer kravene mot koden i lokale kloner av kode-repoene. Spør først hva som skal verifiseres (`@in-progress`, `@deprecated`, flyter, alle krav uansett status, eller noe annet), og hvor mange nivåer med `@depends-on-` som skal følges, med status fra taggene eller verifisert i koden (avhengighetene retagges aldri). Spør ikke om det prompten fra FS Kravforvaltning allerede svarer på. Rapporten skrives til fil før oppfølgingsspørsmålene, og hvert spørsmål har med referansene det gjelder. Er noe av et krav levert, blir egenskapen `@in-progress` og de leverte delene `@implemented` (delvis levert). Gis en verify-rapport, går den gjennom resultatene med brukeren: usikre og ikke funne scenarioer, delvis leverte krav og åpne spørsmål, og skriver en ny rapport. `@in-progress` → `@implemented` (på deler i leverte krav: `@in-progress` fjernes), og sletter `@deprecated`-krav og referansene til dem når koden er borte (ellers lister den hvor koden fortsatt finnes). Er fase 1 i teststrategien (forslag): white-box, ingenting kjøres, og `@implemented` betyr bare at koden er funnet. Verifiserer i tillegg i koden at roller og tilganger er implementert slik kravet sier (roller × organisasjon × opprette/lese/endre/slette), og datakonsistensen, uten å teste dem. Tilgangsradene er grunnlaget for testbrukerne i testplanen. Rapporterer regler i koden uten scenario i kravet (input til testplanen og den agentiske testen), og teller åpne spørsmål per krav (de stopper ikke noe, men nevnes i testplanen). Rapporten har et felt for menneskelig kontroll som skillen aldri fyller ut. Verifiserer også flyter: fremdriften fra kravene, og at overleveringene mellom kravene virker i koden (`@planned` → `@implemented`). Med en spesifikasjon som scope skriver den `## Scenarioer` i `spec/verify-*.md` og sender steget tilbake i `utforing.md` når noe mangler. Før brukeren spørres, kontrolleres resultatet: av subagenten `fs-verify-kontroll` (`.claude/agents/`) når Agent-verktøyet finnes (terminalen, også i FS Kravforvaltning), ellers manuelt av skillen selv (Claude-panelet), og det sier den fra om
- `fs-verify-agent-teams` — det samme som `fs-verify`, med de samme spørsmålene, men med et agent team med to roller: finnere (agenttypen `fs-verify-krav` i `.claude/agents/`) leter i koden parallelt, én per feature-fil eller gruppe av filer, og kontrollører (`fs-verify-kontroll`) sjekker hvert svar uavhengig. Lead-en avgjør der de er uenige, spør, retagger og skriver rapporten, eventuelt med hva som gjenstår i hvert repo (fs-plattform, fs-admin og min-kompetanse). Krever `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`, og virker bare i en interaktiv økt: i terminalen, eller i terminalen i FS Kravforvaltning («I terminal med agent team»), ikke i Claude-panelet
- `lage-steps` — step definitions i `tester/steps/` for kravene
- `fs-testplan` — testplanen for en leveranse (et scope, en oppgave, en mappe under `krav/` eller feature-filer), etter teststrategien (forslag) i Confluence. Kjøres etter `fs-verify`, og bygger på verify-rapporten. Den planlegger, og lager ikke testcasene: hvilke krav og flyter som testes (det som er `@implemented`), omfanget av testcasene som skal lages («Testcaser som skal lages»: scenarioer, utledede testcaser og teknikk per regel i fase 2, flyter og oppgaver i fase 3), hvilke testdata testene trenger (hvordan de lages, er utenfor strategien), nummererte testbrukere ut fra tilgangsmatrisen fra `fs-verify`, avhengighetskart, åpne spørsmål per krav, reglene i koden uten scenario fra verify-rapporten, forutsetninger, når fasene er ferdige (kravene er kriteriene for godkjent), vedlegg og «Status i flyten». Kravene står med Feature-ID i «Omfang», og flytene i `krav/_Flyter` som går gjennom kravene, i «Flyter». Skriver `akseptansetest/<slug>/testplan.md`, og hovedsiden i Confluence når brukeren sier ja
- `fs-testcaser-cdp` — testcasene for fase 2, den agentiske funksjonstesten, som kjørbar Gherkin i `cdp-tester/` for `cdp`-skillen (installeres av hver bruker i `.claude/skills/cdp`, er ikke i repoet), mot et testmiljø: alle `@implemented` scenarioer i gating-settet, pluss testcaser agenten utleder fra reglene (også reglene `fs-verify` fant uten scenario), etter omfanget i testplanen, med positiv og negativ testing, testteknikk valgt og skrevet ned per regel, og alle obligatoriske felt testet tomt, med bare mellomrom og for lang verdi. Det lages ikke egne testcaser for roller og tilgang (verifisert i koden i fase 1), men scenarioene i kravet testes som de står. Testdataene er de testplanen lister, i utgangstilstanden der, og testbruker og testdata er nøkler (kolonnene `Nøkkel`, `Utgangstilstand`, `Brukes av` i testplanen). Referansene til kravene er `@depends-on-<Feature-ID>`, identiske titler og en header med commit og blob-hash, som gir en diff når kravet er endret. Overleveringene i flytene blir tester i `cdp-tester/_Løp/`. Utleder agenten et tilfelle kravet ikke dekker, blir det et funn av typen «Kravet dekker ikke», og skal avklares i kravet. Endrer aldri `krav/`. Bevisene (steg, input, faktisk resultat, skjermbilder, bildene er ignorert av git) ligger i `akseptansetest/<slug>/`
- `fs-testcaser-intern` — testcasene for fase 3, den interne akseptansetesten: flyter og avhengigheter, ikke enkeltfunksjoner (feltvalidering og feilsituasjoner er testet i fase 2, tilgang i fase 1). Vurderer per krav om det inngår i en flyt i `krav/_Flyter` og om flyten skal testes, og lager én testcase per flyt (eller per oppgave uten flyt, for krav som ikke hører til en flyt) i rekkefølgen arbeidsprosessen går, med hensikt, testdata, forventet resultat og avhengighetene som sjekkes underveis. Tar med regresjon av tidligere leverte flyter når leveransen endrer noe andre bygger på. Underside til testplanen
- `fs-testcaser-ekstern` — fase 4, den eksterne akseptansetesten: de eksterne partene har egne krav og lager eller eier testcasene sine, og skillen foreslår flyter som utgangspunkt (uten tekniske ord) og eksporterer flytbeskrivelsene til partene, sammen med rapportene fra fase 2 og 3. Funnene sorteres i «Feil (avvik fra kravene våre)» og «Endringsforslag (krav vi ikke har)», som går til kravarbeidet. Underside til testplanen
- `fs-testrapport` — testrapporten på fire nivåer: verifisering (fase 1), agentisk funksjonstest (fase 2), intern (fase 3) og ekstern akseptansetest (fase 4): teller resultatene, sorterer funnene etter alvorlighetsgrad, fase og type («Feil», «Kravet dekker ikke»), lister testcaser som er «Bestått» selv om faktisk resultat avviker, og foreslår et utfall. Testansvarlig skriver beslutningen, og agenten kan ikke godkjenne en leveranse. Underside til testplanen

Alle fs-*-skillene sjekker at branchen er oppdatert mot origin og main før de gjør noe, i dette repoet og i kodeklonene de leser. Er branchen bak, spør de før de henter (`git pull --ff-only`). I Claude-panelet hoppes sjekken over, siden det ikke har Bash. Prosedyren står i [`.claude/references/oppdatert-branch.md`](.claude/references/oppdatert-branch.md).

Typisk flyt: `fs-scope` → `fs-krav` → `fs-specify` / `fs-specify-delta` (med `fs-implementasjonsdetaljer`) → `lage-steps` → `fs-verify` (eller `fs-verify-agent-teams` når det er mange feature-filer). Akseptansetesten følger teststrategien (forslag) i Confluence, i fire faser: `fs-verify` (eller `fs-verify-agent-teams`), fase 1 → `fs-testplan` (bygger på verify-rapporten, og legger den i Confluence) → `fs-testcaser-cdp` og en CDP-kjøring, fase 2 (agentisk funksjonstest) → `fs-testrapport` (agentisk) → `fs-testcaser-intern`, fase 3 (flyter og avhengigheter) → `fs-testrapport` (intern) → `fs-testcaser-ekstern`, fase 4 → `fs-testrapport` (ekstern), med filene i [`akseptansetest/`](akseptansetest/README.md) og de varige gherkin-testene for fase 2 i [`cdp-tester/`](cdp-tester/README.md). Tavla «Oppgaver» i FS Kravforvaltning viser hvor hver oppgave er, utledet fra kravene og spesifikasjonene. Skillen `fs-oppgave` (faser, `roadmap.md` og review-filer) er ikke lenger i dette repoet, og kan brukes fra et annet sted. Se [`tasks/README.md`](tasks/README.md) for oppgavestrukturen. `.claude/rules/tasks-conventions.md` importerer den med `@../../tasks/README.md` når Claude jobber i `tasks/**`.

## CI/CD

- **GitHub Actions**: Bygger Docker-image med testmiljø
- **GitLab**: Kjører testene fra Docker-imaget i bedriftens CI/CD
