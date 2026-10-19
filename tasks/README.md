# Oppgaver

Dette er arbeidsflaten for team i FS som kjører trunk-based utvikling med artefakter versjonert i git. Én mappe per oppgave, delt av alle som jobber på den — mennesker og agenter, på tvers av repoer og maskiner.

Mappa erstatter den gamle `veikart/<team>/oppgaver/`-strukturen. Alle team er migrert, og `veikart/` er fjernet.

## Struktur

```
tasks/
├── README.md                     # dette dokumentet
├── mal/                          # felles maler — kopier når du starter en oppgave
│   ├── oppgave.md
│   ├── scope.md
│   ├── design.md
│   ├── plan.md
│   └── review.md
└── <domene>/                     # én mappe per domene (se domenelista under)
    ├── README.md                 # eierteam, konvensjoner
    ├── roadmap.md                # valgfri: teamets visning (brukes av fs-oppgave utenfor repoet)
    ├── scope-<slug>.md           # ett per initiativ: mål, avgrensning, oppgavene og kravene deres (se Scope)
    └── <slug>/                   # én mappe per oppgave
        ├── oppgave.md            # metadata, statuslogg, lenker
        ├── design.md             # valgfri
        ├── reviews/              # valgfri
        │   └── rNN-<fra>-til-<til>.md
        ├── flow.md               # valgfri: BAT-pipeline (eies av alfred)
        ├── memory.md             # valgfri: agent-journal
        ├── utforing.md           # valgfri: spesifikasjonene på veien gjennom kode-repoene (se Utføring)
        ├── spec/                 # krav: spec-*.md, krav-input/, spec.log.md, verify-*.md, verify-<dato>-<HHMM>/ (skjermbilder)
        └── <lag>/                # ett per lag/rolle: frontend, backend, subgraph, tester …
            ├── analysis-<slug>.md
            ├── plan-<slug>.md
            ├── task-N-completion.md
            └── verification-<slug>.md
```

## Domener

Domenet er kebab-slug av toppnivået i [`krav/`](../krav/), uten tallprefiks og med æ/ø/å skrevet som ae/o/a:

| Domene | Tilsvarer `krav/` |
|--------|-------------------|
| `utdanning` | `01 Utdanning` |
| `opptak` | `02 Opptak` |
| `gjennomfore-studier` | `03 Gjennomføre studier` |
| `kompetanse` | `04 Kompetanse` |
| `opplysninger-om-person` | `05 Opplysninger om person` |
| `brukeradministrasjon-og-tilgangsstyring` | `07 Brukeradministrasjon og tilgangsstyring` |
| `teknisk` | `08 Teknisk` |
| `organisasjon` | `09 Organisasjon` |
| `felleskrav` | `10 Felleskrav` |

Dette er den autoritative lista. Får `krav/` et nytt toppnivå, legges domenet til her først. `99 Demo` og `_Interne prosesser` er ikke oppgavedomener.

Slug-en må være unik innenfor domenet, ikke globalt. Den er en lesbar kebab-case-beskrivelse — ikke issue-nummeret.

## Fire regler

1. **Aldri `spec-*.md`, `analysis-*.md`, `plan-*.md` eller `verification-*.md` i oppgave-rota.** Dette er ikke stil, det er mekanikk: BAT-verktøyene globber nøyaktig disse mønstrene for å avgjøre hvilket steg som er ferdig. En håndskrevet `plan-krav.md` i rota blir lest som et fullført plansteg og hopper over resten av flyten. *(sjekkes automatisk)*
2. **Lag = rolle.** En plan for et lag hører hjemme i lagets egen undermappe: `<lag>/plan-<slug>.md`, ikke `plan-<lag>.md` i rota. Typiske lag: `spec` (krav), `frontend`, `backend`, `subgraph`, `tester`, `db`, `dokumentasjon`. Bruk bare de lagene oppgaven faktisk rører. *(`plan-<lag>.md` i rota sjekkes automatisk)*
3. **`spec/` er reservert** for kravene. Det er dit `fs-specify` og `fs-specify-delta` alltid skriver, slik at hvem som helst kan peke på `tasks/<domene>/<slug>/spec/` uten å vite hvilken rolle som produserte resten. *(`spec-*.md` og `krav-input/` utenfor `spec/` sjekkes automatisk)*
4. **`mal/` er reservert på domene-nivå** — det er ikke et domene. Malfilene heter `plan.md`, ikke `plan-lag.md`, nettopp for ikke å treffe globbene i regel 1. *(sjekkes automatisk, sammen med domener som ikke står i domenetabellen)*

`oppgave.md`, `design.md`, `memory.md`, `utforing.md` og `reviews/` treffer ingen glob og hører hjemme i oppgave-rota. `scope-<slug>.md` ligger på domenenivå, ved siden av oppgavemappene, og treffer heller ingen glob.

## Scope

Et scope er planen for et initiativ: mål, avgrensning, kilder, og oppgavene initiativet deles i, med kravene hver oppgave har. Det står i `tasks/<domene>/scope-<slug>.md`, og lages og endres med skillen `fs-scope` (malen er [`mal/scope.md`](mal/scope.md)). Kravene kobles til scopet med taggen `@scope-<slug>` (se *Scope* i [`krav/README.md`](../krav/README.md)).

```markdown
# Scope: <tittel>

- **Slug**: <slug>
- **Initiativ**: [#NNN](https://github.com/sikt-no/fs/issues/NNN) | –
- **Eier**: @… | –
- **Siste oppdatering**: <dato>

## Mål
## Ikke-mål
## Kilder
## Oppgaver

| Oppgave | Krav | MoSCoW | Skisse | Issue | Kommentar |
|---|---|---|---|---|---|
| [plasstildeling](plasstildeling/) | `@OPT-PLA-RUN-001` [runder.feature](../../krav/…) | Must | [Runder](https://figma.com/…?node-id=…) | [BAT-…](https://sikt.atlassian.net/browse/BAT-…) | |
| (ikke tildelt) | `@OPT-PLA-RUN-002` [….feature](../../krav/…) | Could | – | – | |

## Åpne spørsmål
```

- Én rad per krav. Kravet står med Feature-ID. En del av et levert krav skrives `` `@DOM-SUB-KAP-NNN` — Regel: <tittel> ``.
- Status står ikke i tabellen. Den leses fra taggene i kravene.
- `Skisse` er lenken til rammen som dekker kravet. `fs-specify` bruker den som skissen til kravet.
- Slugen i `- **Slug**:` er den samme som i filnavnet. *(sjekkes automatisk)*
- Slugen er unik på tvers av domener, siden taggen ikke har domene. *(sjekkes automatisk)*
- Oppgavene i tabellen ligger som mapper i samme domene som scope-fila. Et initiativ som går over flere domener, får ett scope per domene. *(sjekkes automatisk)*

`oppgave.md` får feltet `- **Scope**: [scope-<slug>](../scope-<slug>.md)`. En oppgave hører til høyst ett scope, scopet finnes, og oppgaven står i tabellen i scopet. *(sjekkes automatisk)* Har oppgaven scope, er scope-raden kilden til kravene, og `oppgave.md` lenker ikke til kravene i tillegg.

FS Kravforvaltning (`fs-kravforvaltning/`, tavla «Oppgaver») sjekker reglene som er merket *(sjekkes automatisk)*, og viser brudd som avvik på oppgaven. Den sjekker også at `oppgave.md` finnes, og at `Slug` og `Domene` i metadataene stemmer med mappa. `Fase` og `roadmap.md` sjekkes ikke. Sjekkene står i `fs-kravforvaltning/shared/tasks.ts` og er testet i `fs-kravforvaltning/shared/tasks.test.ts`. Endrer du en merket regel, eller legger du til en regel som kan sjekkes, må koden og testene oppdateres i samme endring.

## Utføring

En spesifikasjon fra `fs-specify` eller `fs-specify-delta` (`spec/spec-*.md`) samler hele krav: én eller flere feature-filer, med alt som er `@planned` eller `@deprecated` i dem. Spesifikasjonen går så gjennom kode-repoene, typisk fs-plattform (subgraph og backend) og så fs-admin (frontend), før `fs-verify` bekrefter at kravene er implementert. FS Kravforvaltning viser dette på tavla «Oppgaver», med én kolonne per repo (se *Tavla*).

Spesifikasjonen har disse seksjonene i tillegg til dem `fs-specify` alltid skriver:

- `## Omfang`: 2–5 setninger om hva spesifikasjonen dekker og ikke dekker.
- `## Skisser`: minst én `### Skisse:`, eller linja `Ingen skisse: <grunn>`.
- `## Rute` (valgfri): forslag til rekkefølgen på repoene, `fs-plattform → fs-admin`. Den fjernes når spesifikasjonen sendes, og ruta står da i `utforing.md`.

En spesifikasjon er klar til utvikling når den har tittel, omfang, minst én feature-fil, skisse (eller «Ingen skisse»), ingen åpne spørsmål, og alle kravene er hentet inn (`@in-progress`, eller `@deprecated` som skal fjernes).

### utforing.md

Tilstanden står i `utforing.md` i oppgave-rota, med én `##`-seksjon per spesifikasjon og én `###` per repo på ruta. Fila merges til `main` med PR, som kravene. Det trengs ingen synk i sanntid: et steg regnes som tatt når endringen er på `main`.

```markdown
# Utføring

## spec/spec-opprette-og-vedlikeholde-opptak.md

- **Rute**: fs-plattform → fs-admin
- **Logg**:
  - 2026-09-28 — @mats — sendte til fs-plattform
  - 2026-10-01 — agent:subgraph — levert i fs-plattform (#123)

### fs-plattform

- **Status**: levert
- **Tatt av**: agent:subgraph
- **PR**:
  - https://github.com/sikt-no/fs-plattform/pull/123
- **Overlevering**:
  - Ny mutation `opprettOpptak(input: OpprettOpptakInput!)`
- **Blokkert**: –

### fs-admin

- **Status**: pågår
- **Tatt av**: agent:frontend
- **PR**: –
- **Overlevering**: –
- **Blokkert**: –
```

- `Status` er `venter`, `pågår` eller `levert`. Kortet står i kolonnen til det første repoet som ikke er levert, og i «Til verifisering» når alle er levert.
- `Tatt av` er `@person` eller `agent:<rolle>`.
- `levert` krever minst én `PR`.
- `Overlevering` er det neste repo trenger å vite: nye felt, queries og mutations, endepunkter, kjente avvik.
- `Blokkert` har grunnen, eller `–`.
- `Tilbake: <dato>` settes av `fs-verify` når den sender steget tilbake.
- `Logg` er append-only.

### Protokoll for den som utfører et steg

Det kan være en person, en Claude Code-økt i repoet, eller en utførekjøring fra FS Kravforvaltning («Utfør i <repo>»).

1. Hent siste `main` i `sikt-no/fs`-klonen.
2. Finn et steg der ditt repo er det første som ikke er levert, og som står som `venter`.
3. Sett `Status: pågår` og `Tatt av` under `### <repo>`, og legg til en linje i `Logg`.
4. Implementer ut fra spesifikasjonen, feature-filene, skissene og overleveringen fra forrige steg, med repoets egne skills.
5. Lever: `Status: levert`, `PR` og `Overlevering`. Er du blokkert, sett `Blokkert` med grunn i stedet.
6. Lag PR med endringen i `utforing.md` (eller ta den med i en PR du lager uansett).

Kommer to PR-er som tar samme steg, gir git en konflikt i seksjonen, og den siste løses for hånd.

Når alle steg er levert, kjøres `fs-verify` avgrenset til spesifikasjonen. Den skriver `spec/verify-<dato>-<HHMM>.md` (med klokkeslett, så kjøringer kan sammenlignes) med `- **Spec:** spec/spec-<x>.md` og tabellen `## Scenarioer` (`| Feature-ID | Scenario | Resultat | Bevis |`). Er alt funnet, blir kravene `@implemented`, og spesifikasjonen er verifisert. Mangler noe, settes steget i repoet der koden mangler, tilbake til `pågår` med `Tilbake: <dato>`.

Scenarioene `fs-verify` sjekker (gating-settet), er alle `Scenario:`/`Scenariomal:` som ikke er tagget `@draft`, `@deprecated`, `@openquestion` eller `@demo`, selv eller via `Regel:`. I et levert krav som endres, er det bare `@planned`- og `@in-progress`-delene, og `@deprecated`-delene sjekkes for at koden er borte. Den samme definisjonen står i `fs-kravforvaltning/src/specboard.ts` (`gating`), og de to holdes i synk.

## Forholdet til Jira og GitHub

Oppgavemappa *erstatter ikke* Jira-saker, GitHub issues eller project-boards. Fordelingen er:

- **Jira-sak**: oppgaven teamet løser. Kanonisk ID, status, sprint og den som jobber med den.
- **GitHub issue**: initiativet og kravarbeidet (`Initiativ` i scope-fila, `# GitHub:` i kravfila). Synlig for produktledere og eksterne.
- **`scope-<slug>.md`**: initiativet delt i oppgaver, med kravene hver oppgave har.
- **`oppgave.md`**: referanse til Jira-saken, eier, scope, lenker, append-only statuslogg. Internt for teamet.
- **Tavla «Oppgaver»** i FS Kravforvaltning: hvor hver oppgave er, utledet fra kravene og spesifikasjonene.
- **`roadmap.md`** (valgfri): teamets egen linse på aktivt og ferdig arbeid.

Én oppgave ≙ én Jira-sak. ID-en er saksnøkkelen (f.eks. `BAT-268`), og står i `Issue` i `oppgave.md` og i scope-tabellen; vi lager ikke lokal nummerering. Mappenavnet er en lesbar slug. Oppgaver fra før kan fortsatt peke på et GitHub issue.

For overordnet prioritering på tvers av FS, se [FS Offentlig saksoversikt](https://github.com/orgs/sikt-no/projects/4/views/3).

## Tavla

FS Kravforvaltning viser oppgavene på tavla «Oppgaver», med ett kort per oppgavemappe fra den opprettes til kravene er verifisert. Kolonnen utledes alltid av kravene og spesifikasjonene, og settes ikke for hånd. `Fase` i `oppgave.md` leses ikke.

| Kolonne | Betyr | Krav-tag | Skill som flytter oppgaven videre |
|---------|-------|----------|------------------------------------|
| I scope | Oppgaven er avgrenset. Kravene er skjeletter, eller finnes ikke ennå | `@draft` (skjelett) | `fs-scope`, så `fs-krav` |
| Kravarbeid | Kravene skrives og valideres. Noen har scenarioer og er `@draft` | `@draft` | `fs-krav` |
| Spesifiseres | Kravene er `@planned`, men spesifikasjonen finnes ikke, mangler tittel, omfang eller skisse, har åpne spørsmål, eller kravene er ikke hentet inn | `@planned` | `fs-specify` / `fs-specify-delta` |
| Klart til utvikling | Spesifikasjonen er komplett, og kravene er hentet inn. Ingen rute er satt ennå | `@in-progress` | Sendes til første repo i FS Kravforvaltning |
| fs-plattform, fs-admin, … | Spesifikasjonen er i repoet (se *Utføring*) | `@in-progress` | Den som utfører steget |
| Til verifisering | Alle stegene på ruta er levert | `@in-progress` | `fs-verify` |
| Verifisert | Kravene er `@implemented` (eller slettet, for `@deprecated`), eller verify-rapporten har alt funnet | `@implemented` | – |

Kolonnen for en oppgave:

- **Uten spesifikasjon:** har oppgaven ingen krav, eller er alle kravene skjeletter, står den i *I scope*. Har noen krav scenarioer og er `@draft`, står den i *Kravarbeid*. Er alle kravene `@planned` (eller lenger), står den i *Spesifiseres*, med «Mangler spesifikasjon».
- **Med spesifikasjoner:** hver spesifikasjon har sin kolonne, og oppgaven står der den tidligste av spesifikasjonene som ikke er verifisert, står. Krav i scopet som ikke er i noen spesifikasjon, gir et flagg på kortet («3 krav uten spesifikasjon»).
- **Verifisert:** alle spesifikasjonene er verifisert, og ingen krav i scope-raden står uten spesifikasjon og uten `@implemented`. Uten scope: alle spesifikasjonene er verifisert, og kravene fra krav-lenken er levert.
- Krav med `@wont` teller ikke for kolonnen, og gir ikke flagg.

Kravene til en oppgave er kravene i scope-raden når oppgaven har scope, ellers kravene i spesifikasjonene, ellers feature-filene under mappa i «Krav (Gherkin)» i `oppgave.md`. En lenke til et helt domene (`krav/07 …/`) sier ikke hvilke krav oppgaven har, og brukes ikke: en slik oppgave står i *I scope* til den får scope eller spesifikasjon.

Hvert steg på tag-aksen har én eier:

`@draft` →(`fs-krav`)→ `@planned` →(`fs-specify` / `fs-specify-delta`)→ `@in-progress` →(`fs-verify`)→ `@implemented` →(`fs-krav`)→ `@deprecated` →(`fs-verify`)→ slettet

Endres et krav som er levert, blir `Egenskap:` stående som `@implemented`, og den samme aksen går på delen (`Regel:`/`Scenario:`) som endres: den nye delen går `@draft` → `@planned` → `@in-progress` → levert, og delen den erstatter, får `@deprecated`. Se *Endring av levert krav* i `krav/README.md`.

Se [`krav/README.md`](../krav/README.md) for den autoritative definisjonen av taggene.

Review skjer i PR-en som endrer oppgavemappa eller kravene. BAT-stegene (`bat-analyze`, `bat-plan`, `bat-execute`, `bat-verify`) er valgfrie, og skriver i `<lag>/`. `Fase` i `oppgave.md`, `roadmap.md`, `design.md` og `reviews/` er valgfrie. De brukes av `fs-oppgave` utenfor dette repoet, og leses ikke av FS Kravforvaltning.

## Legge til et nytt domene

1. Sjekk at domenet finnes som toppnivå i [`krav/`](../krav/) — oppgavestrukturen speiler kravstrukturen, den finner ikke på egne inndelinger.
2. Legg domenet til i tabellen over.
3. Opprett `tasks/<domene>/` med `README.md` (eierteam og konvensjoner). `roadmap.md` er valgfri.
4. Kopier fra [`mal/`](mal/) når første oppgave opprettes.

Et domene kan eies av ett team, og et team kan eie flere domener. Skriv hvilket team som eier domenet i domenets `README.md`.

## Maler

[`mal/`](mal/) inneholder `oppgave.md`, `scope.md`, `design.md`, `plan.md` og `review.md`.

- `fs-scope` bruker `scope.md` og `oppgave.md` når et initiativ deles i oppgaver.
- `fs-specify` og `fs-specify-delta` («Ny oppgave») og «+ Ny oppgave» på tavla i FS Kravforvaltning skriver en minimal `oppgave.md` fra malen: tittel, domene, slug, issue og eier, og `–` i resten.
- `design.md`, `plan.md` og `review.md`, og `Fase` i `oppgave.md`, står for dem som bruker `fs-oppgave` fra et annet sted. FS Kravforvaltning leser dem ikke.

Team som vil avvike, kan legge egne maler i sitt domene.
