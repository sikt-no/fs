# Oppgaver

Dette er arbeidsflaten for team i FS som kjører trunk-based utvikling med artefakter versjonert i git. Én mappe per oppgave, delt av alle som jobber på den — mennesker og agenter, på tvers av repoer og maskiner.

Mappa erstatter den gamle `veikart/<team>/oppgaver/`-strukturen. `veikart/opptak/` og `veikart/utdanning/` har fortsatt gammel form inntil de teamene migrerer selv.

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
        ├── spec/                 # krav: spec-*.md, krav-input/, spec.log.md
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

1. **Aldri `spec-*.md`, `analysis-*.md`, `plan-*.md` eller `verification-*.md` i oppgave-rota.** Dette er ikke stil, det er mekanikk: BAT-verktøyene globber nøyaktig disse mønstrene for å avgjøre hvilket steg som er ferdig. En håndskrevet `plan-krav.md` i rota blir lest som et fullført plansteg og hopper over resten av flyten.
2. **Lag = rolle.** En plan for et lag hører hjemme i lagets egen undermappe: `<lag>/plan-<slug>.md`, ikke `plan-<lag>.md` i rota. Typiske lag: `spec` (krav), `frontend`, `backend`, `subgraph`, `tester`, `db`, `dokumentasjon`. Bruk bare de lagene oppgaven faktisk rører.
3. **`spec/` er reservert** for kravene. Det er dit `fs-specify` og `fs-specify-delta` alltid skriver, slik at hvem som helst kan peke på `tasks/<domene>/<slug>/spec/` uten å vite hvilken rolle som produserte resten.
4. **`mal/` er reservert på domene-nivå** — det er ikke et domene. Malfilene heter `plan.md`, ikke `plan-lag.md`, nettopp for ikke å treffe globbene i regel 1.

`oppgave.md`, `design.md`, `memory.md` og `reviews/` treffer ingen glob og hører hjemme i oppgave-rota.

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
| innføring | Innføring | `<lag>/verification-*.md` | `bat-verify` | `@implemented` |
| levert | Levert | – | – | `@implemented` |

Oppgaver tas inn først når issuet er Prioritert. Oppgaver i `levert` blir liggende i roadmap-arkivet.

**Krav-tag-kolonnen** viser hvor `Egenskap:`-taggen i `.feature`-fila står gjennom løpet. Hvert steg på aksen har én eier:

`@draft` →(`fs-krav`)→ `@planned` →(`fs-specify` / `fs-specify-delta`)→ `@in-progress` →(verifisering)→ `@implemented`

Se [`.claude/rules/gherkin-conventions.md`](../.claude/rules/gherkin-conventions.md) for den autoritative definisjonen av taggene.

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

[`mal/`](mal/) inneholder `oppgave.md`, `design.md`, `plan.md` og `review.md`. Kopier dem inn i oppgavemappa og fyll ut. Team som vil avvike, kan legge egne maler i sitt domene — men mapping til issue-status og faseoverganger skal være forutsigbar på tvers.
