# Oppgaver

Dette er arbeidsflaten for team i FS som kjører trunk-based utvikling med artefakter versjonert i git. Én mappe per oppgave, delt av alle som jobber på den — mennesker og agenter, på tvers av repoer og maskiner.

Mappa erstatter den gamle `veikart/<team>/oppgaver/`-strukturen. Alle team er migrert, og `veikart/` er fjernet.

## Struktur

```
tasks/
├── README.md                     # dette dokumentet
├── mal/                          # felles maler — kopier når du starter en oppgave
│   ├── oppgave.md
│   ├── design.md
│   ├── plan.md
│   └── review.md
└── <domene>/                     # én mappe per domene (se domenelista under)
    ├── README.md                 # eierteam, konvensjoner
    ├── roadmap.md                # teamets visning: aktive og ferdige oppgaver
    └── <slug>/                   # én mappe per oppgave
        ├── oppgave.md            # metadata, statuslogg, lenker
        ├── design.md             # opprettes i utforskningsfasen
        ├── reviews/
        │   └── rNN-<fra>-til-<til>.md
        ├── flow.md               # valgfri: BAT-pipeline (eies av alfred)
        ├── memory.md             # valgfri: agent-journal
        ├── utforing.md           # valgfri: spesifikasjonene på veien gjennom kode-repoene (se Utføring)
        ├── spec/                 # krav: spec-*.md, krav-input/, spec.log.md, verify-*.md, verify-<dato>/ (skjermbilder)
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

`oppgave.md`, `design.md`, `memory.md`, `utforing.md` og `reviews/` treffer ingen glob og hører hjemme i oppgave-rota.

FS Kravforvaltning (`fs-kravforvaltning/`, modusen «Oppgaver») sjekker reglene som er merket *(sjekkes automatisk)*, og viser brudd som avvik på oppgaven. Den sjekker også at `oppgave.md` finnes og har en gyldig `Fase`, at `Slug` og `Domene` i metadataene stemmer med mappa, og at fasen i domenets `roadmap.md` er den samme som i `oppgave.md`. Sjekkene står i `fs-kravforvaltning/shared/tasks.ts` og er testet i `fs-kravforvaltning/shared/tasks.test.ts`. Endrer du en merket regel, eller legger du til en regel som kan sjekkes, må koden og testene oppdateres i samme endring.

## Utføring

En spesifikasjon fra `fs-specify` eller `fs-specify-delta` (`spec/spec-*.md`) samler hele krav: én eller flere feature-filer, med alt som er `@planned` eller `@deprecated` i dem. Spesifikasjonen går så gjennom kode-repoene, typisk fs-plattform (subgraph og backend) og så fs-admin (frontend), før `fs-verify` bekrefter at kravene er implementert. FS Kravforvaltning viser dette i visningen «Spesifikasjoner», med én kolonne per repo. Oppgavefasene over påvirker ikke den.

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

Når alle steg er levert, kjøres `fs-verify` avgrenset til spesifikasjonen. Den skriver `spec/verify-<dato>.md` med `- **Spec:** spec/spec-<x>.md` og tabellen `## Scenarioer` (`| Feature-ID | Scenario | Resultat | Bevis |`). Er alt funnet, blir kravene `@implemented`, og kortet står i «Verifisert». Mangler noe, settes steget i repoet der koden mangler, tilbake til `pågår` med `Tilbake: <dato>`.

Scenarioene `fs-verify` sjekker (gating-settet), er alle `Scenario:`/`Scenariomal:` som ikke er tagget `@draft`, `@deprecated`, `@openquestion` eller `@demo`, selv eller via `Regel:`. I et levert krav som endres, er det bare `@planned`- og `@in-progress`-delene, og `@deprecated`-delene sjekkes for at koden er borte. Den samme definisjonen står i `fs-kravforvaltning/src/specboard.ts` (`gating`), og de to holdes i synk.

## Forholdet til GitHub issues og projects

Oppgavemappa *erstatter ikke* GitHub issues eller project-boards. Fordelingen er:

- **GitHub issue**: kanonisk ID, kort beskrivelse, labels, prioritet, milestone, status, start-/ferdigdato. Synlig for produktledere og eksterne.
- **`oppgave.md`**: referanse til issue, eier, reviewers, lenker til design/plan/review, append-only statuslogg. Internt for teamet.
- **`roadmap.md`**: teamets egen linse på aktivt og ferdig arbeid.

Én oppgave ≙ én GitHub issue. ID-en er issue-nummeret (f.eks. `#36`); vi lager ikke lokal nummerering. Mappenavnet er en lesbar slug.

For overordnet prioritering på tvers av FS, se [FS Offentlig saksoversikt](https://github.com/orgs/sikt-no/projects/4/views/3).

## Faser, issue-status og BAT-steg

En oppgave går gjennom: **prioritert → utforskning → utvikling → innføring → levert**.

| Fase i `oppgave.md` | Status på issue i project | Artefakt i oppgavemappa | BAT-steg | Krav-tag |
|---------------------|---------------------------|--------------------------|----------|----------|
| prioritert | Prioritert | `oppgave.md` | – | `@planned` |
| utforskning | Behovsanalyse → Løsningsalternativ | `design.md`, `spec/`, `<lag>/analysis-*.md`, `<lag>/plan-*.md` | `fs-specify` / `fs-specify-delta`, `bat-analyze`, `bat-plan` | `@in-progress` |
| utvikling | Utvikling | `<lag>/task-N-completion.md` | `bat-execute` | `@in-progress` |
| innføring | Innføring | `<lag>/verification-*.md` | `bat-verify`, `fs-verify` | `@implemented` |
| levert | Levert | – | – | `@implemented` |

Oppgaver tas inn først når issuet er Prioritert. Oppgaver i `levert` blir liggende i roadmap-arkivet.

**Krav-tag-kolonnen** viser hvor `Egenskap:`-taggen i `.feature`-fila står gjennom løpet. Hvert steg på aksen har én eier:

`@draft` →(`fs-krav`)→ `@planned` →(`fs-specify` / `fs-specify-delta`)→ `@in-progress` →(`fs-verify`)→ `@implemented` →(`fs-krav`)→ `@deprecated` →(`fs-verify`)→ slettet

Endres et krav som er levert, blir `Egenskap:` stående som `@implemented`, og den samme aksen går på delen (`Regel:`/`Scenario:`) som endres: den nye delen går `@draft` → `@planned` → `@in-progress` → levert, og delen den erstatter, får `@deprecated`. Se *Endring av levert krav* i `krav/README.md`.

Se [`krav/README.md`](../krav/README.md) for den autoritative definisjonen av taggene.

BAT-stegene er valgfrie. En oppgave kan kjøres helt for hånd — da er `flow.md`, `spec/` og `<lag>/`-artefaktene noe teamet skriver selv, og fasene betyr det samme.

## Review-for-improvement

Mellom hver fase skal en tredjepart gjøre et **review for improvement** — målet er å forbedre resultatet, ikke å godkjenne/avvise. Dette skjer som en PR-review på trunk-based vis:

1. Eier lager en PR som flytter oppgaven videre (oppretter/endrer artefakter, oppdaterer `roadmap.md` og `oppgave.md`).
2. Reviewer ser etter feil og muligheter for forbedring, og legger inn kommentarer/suggestions.
3. Utfall:
   - **Ingen verdifulle forbedringer**: PR merges, fase oppdateres, issue-status justeres.
   - **Forbedringer foreslått**: PR stenges eller blir liggende mens eier følger opp; oppgaven forblir i samme fase; en *annen* tredjepart gjør neste review. `oppgave.md` fører liste over hvem som allerede har reviewet.

### Hva som produseres per faseovergang

| Overgang | Produkt |
|----------|---------|
| prioritert → utforskning | `design.md` |
| utforskning → utvikling | Ett `<lag>/plan-<slug>.md` for hvert lag som må endres |
| utvikling → innføring | PR(er) som leverer på plan; planfiler får avkryssede bokser |
| innføring → levert | Alle planbokser avkrysset; lenker til relevante PRs i `oppgave.md` |

## Legge til et nytt domene

1. Sjekk at domenet finnes som toppnivå i [`krav/`](../krav/) — oppgavestrukturen speiler kravstrukturen, den finner ikke på egne inndelinger.
2. Legg domenet til i tabellen over.
3. Opprett `tasks/<domene>/` med `README.md` (eierteam og konvensjoner) og en `roadmap.md`.
4. Kopier fra [`mal/`](mal/) når første oppgave opprettes.

Et domene kan eies av ett team, og et team kan eie flere domener. Skriv hvilket team som eier domenet i domenets `README.md`.

## Maler

[`mal/`](mal/) inneholder `oppgave.md`, `design.md`, `plan.md` og `review.md`. Kopier dem inn i oppgavemappa og fyll ut, eller bruk skillen `fs-oppgave`, som kopierer malene, fyller inn metadata og holder `oppgave.md` og `roadmap.md` i synk ved hver faseovergang. Team som vil avvike, kan legge egne maler i sitt domene — men mapping til issue-status og faseoverganger skal være forutsigbar på tvers.
