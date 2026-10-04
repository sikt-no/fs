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
│   ├── _Interne prosesser/
│   └── 99 Demo/                   # Demo/test features
├── tester/                        # All testkode og konfigurasjon (for utviklere)
│   ├── .mise.toml                 # Mise: Node.js versjon (lts)
│   ├── package.json               # Node.js avhengigheter
│   ├── tsconfig.json              # TypeScript konfigurasjon
│   ├── playwright.config.ts       # Playwright + playwright-bdd konfigurasjon
│   ├── steps/                     # Step definitions
│   ├── fixtures/                  # Test fixtures og hjelpefunksjoner
│   └── .features-gen/             # Genererte testfiler (gitignored)
├── fs-kravforvaltning/            # FS Kravforvaltning: krav i nettleser og desktop-app (Vite + Preact, Electron)
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

## Live-visning av krav

`fs-kravforvaltning/` (**FS Kravforvaltning**) er en Vite-dev-server som viser hele `krav/`-treet og oppdaterer visningen straks en `.feature`-fil lagres (parse-feil vises som banner over sist gyldige versjon):

```bash
cd fs-kravforvaltning
npm install
npm run dev
npm run dev:oppgaver   # med Oppgaver-modusen (tasks/)
npm run app:dev        # desktop-appen (electron-vite)
npm run app:dev:oppgaver  # desktop-appen med Oppgaver-modusen
npm run app:dist       # pakket desktop-app i fs-kravforvaltning/release/
npx changeset          # changeset for en endring i appen (versjon og endringslogg)
```

Versjonen styres med Changesets (`fs-kravforvaltning/.changeset/`). `.github/workflows/kravforvaltning-release.yml` holder en versjons-PR oppdatert mens det finnes changesets. Når den er merget, bygges desktop-appen for macOS, Windows og Linux og publiseres som GitHub-release `fs-kravforvaltning-v<versjon>` med endringene fra `CHANGELOG.md`. Client ID kommer fra repo-variabelen `KRAV_GITHUB_CLIENT_ID`. En endring i appen som brukerne merker, skal ha en changeset i samme PR. Se `fs-kravforvaltning/docs/release.md`.

Vieweren husker hvor brukeren var (`kravforvaltning:hash` i localStorage), og går tilbake dit når den åpnes uten hash. Det gjelder alltid når desktop-appen starter, og i en ny fane. En fil som er borte, gir forsiden.

`npm run build` lager et statisk bygg i `fs-kravforvaltning/dist/` med hele `krav/`-snapshotet bakt inn (relative stier, hash-routing). `.github/workflows/deploy-viewer.yml` publiserer det til GitHub Pages (<https://sikt-no.github.io/fs/>) ved push til `main`. I statisk bygg er git-data `null`, så «Endringer»-modusen skjules. Oppgaver-modusen er av som standard, både i dev og i bygget, og slås på med `--mode oppgaver` (`npm run dev:oppgaver`, `npm run app:dev:oppgaver`, `npm run build -- --mode oppgaver`) eller `OPPGAVER=1`. Uten den leses ikke `tasks/`, `virtual:krav-tasks` er `null`, og knappen og `#/oppgaver`-rutene skjules.

- `core/` er serverlogikken i ren Node, felles for dev-serveren og desktop-appen: `workspace.ts` (leser, parser og overvåker `krav/` og `tasks/`, og sender `krav:update`/`krav:git`/`krav:tasks`), `api.ts` (kallene rendereren kan gjøre, typene i `shared/api.ts`), `save.ts` (skriver krav-filer, bare `.feature`/`.md` under `krav/`), `auth.ts` (GitHub-innlogging med device flow, eller `gh auth token` i dev) og `vcs.ts` med to git-backender: `vcs-cli.ts` (git og gh på maskinen) og `vcs-isogit.ts` (isomorphic-git, uten git-installasjon). Testet i `core/*.test.ts`, isomorphic-git mot en lokal `git http-backend`
- `server/kravPlugin.ts` kobler `core/` til Vite: `virtual:krav*`-modulene, Vites watcher og websocket, og middlewares for `POST /__krav/focus` og `POST /__krav/api/<kall>` (bare fra vieweren selv, sjekket med `Origin`). `VCS=isogit` bytter til isomorphic-git-backenden
- `src/markdown.ts` + `src/MarkdownView.tsx` viser `.md`-filer formatert (overskrifter, nestede lister og sjekklister, sitater, skillelinjer, kodeblokker med «Kopier», tabeller, lenkekort, frontmatter, og fet, kursiv, gjennomstreket og `kode` i teksten; testet i `src/markdown.test.ts`), med bryter til rå markdown. Relative lenker til filer i vieweren åpnes internt
- `server/parse.ts` parser med `@cucumber/gherkin` til modellen i `shared/model.ts`, og sjekker konvensjonene i `krav/README.md` (importert i `.claude/rules/gherkin-conventions.md`). Reglene som sjekkes er merket *(sjekkes automatisk)* i README-en, og testes i `server/parse.test.ts` (`npm test`). Bruddene vises som et statusbånd («Fila følger ikke konvensjonene») under metalinja i feature-visningen, og som `!` i treet. **Hold dem i synk:** endres en merket regel, eller kommer det en ny regel som kan sjekkes, skal `parse.ts`, testene og merkingen i README-en oppdateres i samme endring, og omvendt. Framgangsmåten står i `.claude/rules/krav-readme-parser-sync.md`, som lastes når Claude jobber med README-en eller parseren
- `shared/rules.ts` har ID, alvorlighetsgrad (feil/advarsel), README-seksjon og forklaring for hver regel parseren sjekker. Hvert avvik (`Lint`) har `rule` og `sev` derfra
- **Avvik**-modusen (`#/avvik`, bryteren «Krav | Avvik» i toppfeltet) er et dashbord over avvikene i hele `krav/`, portet fra designet «Gherkin Viewer v2» (Claude Design): nøkkeltall, avvik per regel, status og prioritet, «Regel × mappe» med drill-down, fil- og regeldetaljer med «Kopier agent-prompt», og lista over filer med avvik. Klikk på et avvik åpner fila på linja, og «Les regelen» hopper til seksjonen i README-en. Aggregeringen er rene funksjoner i `src/health.ts` (testet i `src/health.test.ts`), visningen i `src/Avvik.tsx`. Rettes et avvik i editoren, viser statuslinja «↻ … rettet i …»
- **Oppgaver**-modusen (`#/oppgaver`, tredje knapp i «Krav | Avvik | Oppgaver») viser oppgavemappene i `tasks/`, portet fra designet «Oppgaver» (Claude Design, runde 2). «Mappe / Tavle» bytter mellom oppgavemappa (fasespor, gate før neste fase med «Neste steg» og «Kopier prompt til agent», lag, krav, reviews, statuslogg og filtre) og en tavle med én kolonne per fase. Valgt oppgave følger med (`#/oppgaver/<domene>/<slug>`, `#/oppgaver/tavle/<domene>/<slug>`). `server/tasks.ts` leser rådataene (`virtual:krav-tasks`, pushes som `krav:tasks`), `shared/tasks.ts` tolker `oppgave.md`, planbokser og reviews og sjekker reglene i `tasks/README.md` (merket *(sjekkes automatisk)*, testet i `shared/tasks.test.ts`), og `src/oppgaveflyt.ts` har gate, neste steg, krav-kobling og agent-prompt (testet i `src/oppgaveflyt.test.ts`). Hold `tasks/README.md` og `shared/tasks.ts` i synk på samme måte som krav-README-en og parseren
- `server/git.ts` leser endringer under `krav/` (ucommitted mot HEAD, og committet siden merge-base med `main`). Pluginen eksponerer dem som `virtual:krav-git`, pusher `krav:git` ved endringer i krav-filer eller i `.git` (HEAD, index, reflog), og sidebaren viser dem i «Endringer»-modus
- `src/` er Preact-komponentene, portet fra designet «Gherkin Viewer» (Claude Design)
- `src/search.ts` bygger en Fuse.js-indeks over filer og scenarioer for søket i treet; scenariotreff hopper til scenarioet via samme `focus`-state som VS Code-utvidelsen bruker
- **Søk i fila** (Cmd/Ctrl+F i en `.feature`-fil, portet fra designet «Gherkin Viewer v2»): søkefeltet ligger øverst i innholdspanelet til høyre (`src/Outline.tsx`), som vises og skjules med knappen «Vis innhold / Skjul innhold» i toppfeltet (`kravforvaltning:tocHidden` i localStorage). Søket går i modellen, ikke i DOM-en, så det finner også tekst i scenarioer som er foldet sammen. Rene funksjoner i `src/find.ts` (testet i `src/find.test.ts`): `findRanges` treffer hvert ord i søket som delstreng, og ord på minst 4 tegn også fuzzy med Fuse.js, med de samme innstillingene som søket i treet (`FUSE_OPTS` i `src/search.ts`); `'ord` gir bare eksakt treff. Med flere ord må alle treffe i samme tekstbit, og ord som står etter hverandre (eller hele frasen), blir ett treff, så en innlimt scenariotittel gir ett treff på tittelen. Fuse søker i de unike ordene i fila (`wordIndex`, bygget én gang per versjon av fila), ikke i hele tekster, så et treff er et helt ord som kan markeres. `findHits` går gjennom modellen i samme rekkefølge som `FeatureView` tegner, og gir hvert treff en tekstbit (`loc`) som `FeatureView` markerer (`.hit`, `.hit.cur`, `data-hit`). Lukkede scenarioer med treff åpnes («åpnet av søk») uten å endre brukerens folding, og lukker brukeren et av dem under søket, blir det lukket til søket endres. Trefflista er gruppert per blokk. Enter / Shift+Enter og Cmd/Ctrl+G / Shift+Cmd/Ctrl+G går mellom treffene, og visningen hopper til gjeldende treff. Esc tømmer søket
- **Markert tekst** i feature-visningen (portet fra designet «Marker tekst», variant c, Claude Design): når tekst markeres, legger en meny seg under der markeringen slutter (`src/SelectionMenu.tsx`), med linjene markeringen dekker (`L12–14`), «Kopier» og «Legg i samtalen». Linjene som blir med, markeres i margen. Linjene kommer fra `data-ln` på radene i `FeatureView` (steg, tabell- og eksempelrader, beskrivelse, kommentarer og spørsmål, hodene, taggene og metalinja på egenskapen, og avvikene i statusbåndet); modellen har derfor `ln` på egenskapen og beskrivelseslinjene, `tagLn`, `issueLn` og `langLn`, og `lns` på eksempelradene. Teksten bygges fra tekstnodene, uten det som har `user-select: none` (linjenumre, merker, kopier-ikoner), med mellomrom etter nøkkelordet, ` | ` mellom tabellceller og `data-sep` mellom elementer som står side om side (taggene, metalinja, meldingen og forklaringen i et avvik); Cmd/Ctrl+C gir den samme teksten. «Kopier» kopierer bare teksten. «Legg i samtalen» legger den som sitat i inputfeltet i Claude-panelet, med fila og linjene først (`` `krav/…/fil.feature:12–14` `` og `> ` foran hver linje), og brukeren sender selv (`insert` i `src/claudeBridge.ts`; rene funksjoner i `src/selection.ts`, testet i `src/selection.test.ts`). Valget er deaktivert når panelet er lukket. Esc fjerner markeringen
- `vscode/` er en liten VS Code-utvidelse (ren JS, uten bygg) som poster aktiv fil og markørlinje til `POST /__krav/focus`; pluginen videresender det som `krav:focus`, og vieweren bytter fil og scroller til scenarioet. Installeres med `npm run vscode:install` (symlink til `~/.vscode/extensions`), og adressen settes med `kravViewer.url`
- **Redigering og PR** (dev-serveren og desktop-appen, ikke GitHub Pages): «Rediger» på en fil åpner `src/Editor.tsx`, med felt for status, prioritet og `Egenskap:`-tittel (rene funksjoner i `src/edit.ts`, testet i `src/edit.test.ts`) og hele teksten. Lagring skriver fila, og parseren og avvikene oppdateres som ved lagring i en editor. Går brukeren til en annen fil eller visning (også med tilbake-knappen eller «Hent siste»), lagres ulagrede endringer først, og «Lukk» lagrer og lukker. «Forkast» henter versjonen på disk. «Slett kravfil» i feature-visningen sletter fila fra disk etter bekreftelse (kallet `remove`, `deleteFile` i `core/save.ts`) og viser forsiden; slettingen sendes med «Lag PR» i «Endringer». «Lag PR» i «Endringer»-modus, og ved «Rediger» i markdown- og editorvisningen når fila har endringer (da med fila valgt, og editoren lagrer først), åpner PR-visningen i detaljvinduet (`src/PrDialog.tsx`), der fila ellers vises. Den lukkes med «Lukk» eller når en fil velges i treet, og lager en ny branch `krav/<slug>` fra `origin/main` med de valgte filene slik de er på disk, pusher og oppretter PR-en via GitHub REST. Arbeidskatalogen og branchen din røres ikke: CLI-backenden bruker en midlertidig `git worktree`, isomorphic-git bygger committen direkte i objektdatabasen. Valgte filer, tittel, branch og beskrivelse lagres som utkast (`kravforvaltning:prDraft` i localStorage) til PR-en er opprettet, så visningen kan lukkes og åpnes igjen senere; en fil den åpnes fra, legges til i utkastet (`draftPicked` i `src/edit.ts`). «Tøm utkast» starter på nytt
- **Claude-panelet** (knappen «Claude» i toppfeltet, dev-serveren og desktop-appen) ligger til høyre i alle visningene, så samtalen følger med mellom Krav, Avvik og Oppgaver. Innholdspanelet i Krav blir stående ved siden av (det har sin egen knapp). Skills og fil-kontekst følger visningen (`CLAUDE_SKILLS_BY_MODE` i `main.tsx`): Krav tillater `fs-krav`, `fs-krav-avvik` og `fs-verify`, Avvik `fs-krav` og `fs-krav-avvik`, og Oppgaver `fs-krav`, `fs-specify`, `fs-specify-delta` og `fs-verify`. Mens panelet er åpent, er «Kopier agent-prompt» i Avvik og Oppgaver byttet ut med «Send til Claude Code» (`src/AgentButton.tsx`, via `src/claudeBridge.ts`), som sender prompten som melding i samtalen som er åpen. Panelet er en samtale med brukerens lokale Claude Code. `core/claude.ts` finner `claude` (PATH, vanlige installasjonssteder, innloggingsskallet, eller `KRAV_CLAUDE_PATH`) og kjører `claude -p --output-format stream-json --verbose` med repoet som arbeidsmappe. Meldingen går på stdin, og samtalen fortsetter med `--resume`. Med `--permission-mode dontAsk` og `--allowedTools` (`CLAUDE_TOOLS`) kan Claude lese og endre filer og bruke skills, men ikke kjøre kommandoer eller gå på nettet. Endringene vises straks i vieweren og sendes med «Lag PR». Claude kan ikke lage PR selv, men foreslår en når brukeren ber om det, også med knappen «Lag forslag til PR» etter «Endret i samtalen» (`PR_PROMPT` i `src/prProposal.ts`, vist kort som `preset: 'pr'`), men ikke av seg selv når den har endret filer. Forslaget er en kodeblokk med språket `krav-pr` og JSON (`title`, `branch`, `body`, `paths` under `krav/`), tolket av `parsePrProposal` i `src/prProposal.ts` (testet i `src/prProposal.test.ts`). Stier som `publish` ikke tar (utenfor `krav/`, som `tasks/`), vises på kortet som «Kan ikke tas med». `ChatMarkdown` viser forslaget som et kort, portet fra designet «PR-forslag» (Claude Design): tittel, gren, beskrivelse og filene med endringen fra git («ingen endring» betyr at fila ikke kommer med), og «Generated with Claude Code»-linja som metadata nederst (`splitGenerated`; PR-en får hele beskrivelsen). «Åpne i «Lag PR»», som lagrer det som PR-utkast (`proposeDraft` i `src/PrDialog.tsx`) og åpner PR-visningen i Krav, utfylt. Brukeren sender selv. En ugyldig blokk vises som vanlig kode. Hendelsene går som `krav:claude`; samtalen tolkes i `src/claudeChat.ts` (testet i `src/claudeChat.test.ts`) og vises i `src/ClaudePanel.tsx`. Svarene er markdown og vises med `src/ChatMarkdown.tsx`, som bruker den samme parseren som .md-filene (`parseMd`). Lenker og `kode` som peker på krav-filer, åpner fila i vieweren. Det kan være flere samtaler («Samtaler», «Ny», «Slett»). De lagres i localStorage (`kravforvaltning:claudeChats`) og overlever omlasting og omstart. localStorage er per origin, så portene er faste (`strictPort`): 5173 for dev-serveren, 5273 for desktop-appen i dev. En kjøring som pågår, fortsetter i backenden, og vieweren kobler seg på igjen (`claudeActive`). Panelet kan gjøres bredere eller smalere ved å dra i venstre kant. Fila brukeren ser på, sendes med som kontekst og vises som en badge nede i inputfeltet. ✕ sender uten fila til brukeren åpner en annen fil. Med `@` i inputfeltet søkes filer og mapper i `krav/` opp med det samme Fuse-søket som treet (`makeMentionIndex`/`searchMentions` i `src/search.ts`), og legges ved neste melding som badges ved siden av fila (`src/MentionPicker.tsx`, rene funksjoner i `src/mention.ts`, testet i `src/mention.test.ts`). Mappene kommer først, Tab merker flere, og en mappe dekker det som ligger under den. Stiene sendes som `mentions` i `claudeRun` og står i systemteksten (`contextPrompt`). Uten søketekst vises de sist brukte (`kravforvaltning:claudeMentions` i localStorage). Utkastet i inputfeltet (teksten, vedleggene, ✕ på fila og skillvalget før første samtale) lagres i `kravforvaltning:claudeDraft` (`src/claudeDraft.ts`, testet i `src/claudeDraft.test.ts`), så det overlever «Hent siste», omlasting og at panelet lukkes. Det tømmes når meldingen sendes. Under samtaletittelen vises modellen Claude Code brukte i siste svar (`model` fra init-meldingen, med kort navn fra `modelLabel` i `src/claudeChat.ts`; den kan ikke endres i panelet, den følger innstillingene i Claude Code), hvor mye kontekst samtalen bruker (fra `usage` i siste svar, og `contextWindow` i `modelUsage`), og hvilke skills som er lastet (med `/<skill>`, eller med Skill-verktøyet uten å bli stoppet). Over inputfeltet velges skill for samtalen (`src/ClaudeSkills.tsx`): `fs-krav`, `fs-krav-avvik`, `fs-specify`, `fs-specify-delta` eller `fs-verify` (`CLAUDE_SKILLS` i `shared/api.ts`). I Krav og Avvik er det alltid én valgt (`fs-krav` som standard); skills som ikke er tillatt der, vises deaktivert, og en samtale som hadde en av dem, bytter til `fs-krav` med neste melding (`effectiveSkill` i `src/claudeChat.ts`). I Oppgaver er ingen valgt på forhånd («Ingen»), og da lastes ingen skill før Claude velger selv. Valget er et forslag: den valgte lastes med neste melding (`/<skill>`), men hele lista for visningen tillates alltid med `Skill(<navn>)` i `--allowedTools`, så Claude kan bytte skill når oppgaven krever det (f.eks. fra `fs-verify` til `fs-krav` for å endre kravteksten). Alle andre kjente skills (prosjektets fra disk, og plugins og personlige fra Claudes init-melding, husket i localStorage) avvises med `Skill(<navn>)` i `--disallowedTools`, fordi `dontAsk` alene slipper gjennom enkelte skills. Valget lagres per samtale, og en ny samtale starter uten valg. Hver skill i `.claude/skills/` har en versjon: `hash` (sha1 over filene i mappa, også `references/`) fra `skillHash` i `core/claude.ts`, med i `claudeSkills`. Vieweren henter skillene på nytt etter «Hent siste», når vinduet får fokus og før hver melding (`refreshSkills` i `src/ClaudeSkills.tsx`). Samtalen husker versjonen hver skill hadde da den ble lastet (`loadedVersions`), og `staleSkills` i `src/claudeChat.ts` gir de som er endret siden. Samtaler fra før versjonene ble lagret, regnes som utdaterte når skillen er endret på disk (`changedAt`, nyeste mtime i skillmappa, fra `skillChangedAt`) etter at samtalen ble startet. «Hent siste» og `git pull` skriver bare om filene som er endret, så tidspunktet stemmer. Da viser panelet et bånd over inputfeltet («… er oppdatert siden den ble lastet i denne samtalen»), portet fra designet «Skill oppdatert» (Claude Design), med «Oppsummer samtalen» og «Ny samtale», `↻` på skillen i «Lastet:», markøren «utdatert skill» i samtalelista, og skillvelgeren låst, så den nye versjonen ikke lastes inn i den gamle samtalen. «Oppsummer samtalen» sender en fast melding (`SUMMARY_PROMPT`, vist kort som `preset: 'summary'`, uten å laste skillen). Claude svarer med en kodeblokk med språket `krav-oppsummering` og JSON (`mal`, `gjort`, `beslutninger`, `apneSporsmal`, `nesteSteg`, `paths`), tolket av `parseSummary` i `src/chatSummary.ts` (testet i `src/chatSummary.test.ts`) og vist som kort i `ChatMarkdown`, med «Kopier» og «Start ny samtale med oppsummeringen». Den nye samtalen får samme skill og `continuesFrom` (tom samtale viser «Fortsetter fra «…». Åpne den gamle samtalen»), og oppsummeringen (`summaryDraft`) og krav-filene legges i utkastet. Brukeren sender selv. I Krav og Oppgaver kan Claude lese kodeklonene `fs-admin` og `fs-plattform` («Kodemapper» over inputfeltet, `src/CodeDirs.tsx`), som `fs-verify` trenger. Standardstien er `KRAV_FS_ADMIN` / `KRAV_FS_PLATTFORM`, ellers mappa ved siden av repoet (`codeDirs` i `core/claude.ts`, kallet `claudeDirs`). Stien kan overstyres i panelet (`kravforvaltning:claudeDirs` i localStorage). Desktop-appen har ingen standardsti ved siden av repoet (det er appens egen klone): brukeren velger sine lokale kopier med mappevelgeren (`pickDir`), og appen laster ikke ned kode-repoene. Uten valgte kodemapper er `fs-verify` gråtonet i desktop-appen. Mapper som finnes, får `--add-dir`, og `Edit(//<sti>/**)` i `--disallowedTools`, så Claude kan lese koden, men ikke endre den. Uten Bash kan ikke `fs-verify` slette filer i panelet; den sier hvilke, og brukeren sletter selv. Claude bruker brukerens egen innlogging
- `src/transport.ts` er rendererens eneste forbindelse til backenden: Vites websocket og `fetch` i dev, snapshotet bakt inn i statisk bygg, og IPC via `window.krav` (preload) i desktop-appen. `main.tsx` venter på `transport.boot()` før den tegner
- **Desktop-appen** (`electron/`, `electron.vite.config.ts`, `electron-builder.yml`): electron-vite 6 (beta, fordi stabil 5 ikke støtter Vite 8). Ved første oppstart klones `sikt-no/fs` (grunn klone av main) til appens datamappe med isomorphic-git, så brukerne trenger ikke git. «Hent siste» henter main og oppdaterer filene som ikke er endret lokalt. Appen sjekker ved oppstart, hvert tiende minutt og når vinduet får fokus om main på GitHub er nyere enn klonen (`mainStatus` i `vcs-isogit.ts`, som bare leser refs). Er den det, hentes antall commits, endrede `.feature`-filer under `krav/` og siste forfatter fra GitHub compare (`compareCommits` i `core/vcs.ts`; feiler kallet, vises banneret uten tallene). Da vises banneret «Det finnes en ny versjon av main» under toppfeltet (`src/MainBanner.tsx`, tekst og synlighet i `src/mainStatus.ts`, testet i `src/mainStatus.test.ts`), og knappen «Ny versjon av main · Hent siste» i toppfeltet. «Senere» skjuler banneret til main får en ny commit (`kravforvaltning:mainLater` i localStorage). Mens «Hent siste» pågår, viser knappene en spinner og kan ikke klikkes. Innloggingen bruker device flow og krever en OAuth-app i `sikt-no` (`KRAV_GITHUB_CLIENT_ID` ved kjøring, eller `MAIN_VITE_KRAV_GITHUB_CLIENT_ID` ved bygg). Tokenet lagres kryptert med `safeStorage`. `KRAV_REPO=<sti>` bruker en eksisterende klone i stedet for appens egen

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
- `fs-krav` — kravarbeid: nye `.feature`-filer (enkeltstående eller for et initiativ), ferdigstilling av en mappe (`@draft` → `@planned`), fjerning av krav (leverte krav får `@deprecated`, resten slettes), og endring av leverte krav (egenskapen blir `@implemented`, den nye delen får `@planned` når den er validert, og delen den erstatter får `@deprecated`)
- `fs-krav-avvik` — ser etter avvik fra konvensjonene som krever skjønn, og som FS Kravforvaltning ikke sjekker automatisk (f.eks. «egne» og «dem», terminologi, listevisningsmønsteret), i en mappe eller fil under `krav/`. Rapporterer med `fil:linje` og forslag, retter bare ren ordlyd etter at brukeren har sagt ja, og endrer aldri tagger
- `fs-specify` — henter `@planned`-krav inn i en oppgave: `tasks/<domene>/<slug>/spec/` (`@planned` → `@in-progress`, også på `@planned`-deler i leverte krav som endres). Plukker også opp `@deprecated`-krav, og lager en spec for å fjerne koden
- `fs-specify-delta` — det samme, men for en endring (commit, branch, test-fil eller markdown), med samme tag-regler, også for `@deprecated`
- `fs-verify` — verifiserer kravene mot koden i lokale kloner av kode-repoene: `@in-progress` → `@implemented` (på deler i leverte krav: `@in-progress` fjernes), og sletter `@deprecated`-krav når koden er borte (ellers lister den hvor koden fortsatt finnes)
- `lage-steps` — step definitions i `tester/steps/` for kravene
- `fs-oppgave` — oppgavemappa `tasks/<domene>/<slug>/` ut fra malene i `tasks/mal/`: ny oppgave (`oppgave.md` og rad i `roadmap.md`), faseoverganger (`design.md`, `<lag>/plan-<slug>.md`) og review-filer

Typisk flyt: `fs-krav` → `fs-oppgave` (ny oppgave) → `fs-specify` / `fs-specify-delta` → `lage-steps` → `fs-verify`, med `fs-oppgave` for hver faseovergang og review. Se [`tasks/README.md`](tasks/README.md) for oppgavestrukturen. `.claude/rules/tasks-conventions.md` importerer den med `@../../tasks/README.md` når Claude jobber i `tasks/**`.

## CI/CD

- **GitHub Actions**: Bygger Docker-image med testmiljø
- **GitLab**: Kjører testene fra Docker-imaget i bedriftens CI/CD
