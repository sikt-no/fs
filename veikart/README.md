# Veikart

Dette er en lettvekts arbeidsflate for team i FS som vil kjøre trunk-based utvikling med artefakter versjonert i git. Hvert team eier sin egen undermappe og tilpasser prosessen der.

## Struktur

```
veikart/
├── README.md                    # Dette dokumentet (felles)
├── mal/                         # Felles maler som team kan kopiere
│   ├── oppgave.md
│   ├── design.md
│   ├── plan.md
│   └── review.md
└── <team-navn>/                 # Én mappe per team
    ├── README.md                # Team-info (medlemmer, konvensjoner)
    ├── roadmap.md               # Veikart med aktive og ferdige oppgaver
    └── oppgaver/
        └── <slug>/              # Én mappe per oppgave
            ├── oppgave.md       # Metadata, statuslogg, lenker
            ├── design.md        # Opprettes ved todo → design
            ├── plan-<lag>.md    # Ett per lag som må endres
            └── review/
                ├── r01-todo-til-design.md
                └── r02-design-til-planning.md
```

## Forholdet til GitHub issues og projects

Veikartet *erstatter ikke* GitHub issues eller project-boards. Fordelingen er:

- **GitHub issue**: kanonisk ID, kort beskrivelse, labels, prioritet, milestone, status, start-/ferdigdato. Synlig for produktledere og eksterne.
- **`oppgave.md`**: referanse til issue, eier, reviewers, lenker til design/plan/review, append-only statuslogg. Internt for teamet.
- **`roadmap.md`**: teamets egen linse på aktivt og ferdig arbeid.

Én oppgave ≙ én GitHub issue. ID-en er issue-nummeret (f.eks. `#36`); vi lager ikke lokal nummerering. Mappenavn er en lesbar slug.

### Mapping mellom faser og issue-status

| Fase i veikart | Status på issue i project  |
|----------------|----------------------------|
| todo           | Prioritert                 |
| design         | Behovsanalyse              |
| planning       | Løsningsalternativ         |
| implementation | Utvikling                  |
| done           | Innføring → Levert         |

Oppgaver tas inn i veikartet først når issuet er Prioritert. Oppgaver i `done` blir liggende i roadmap-arkivet selv når issuet er Levert.

## Faser og review-for-improvement

En oppgave går gjennom: **todo → design → planning → implementation → done**.

Mellom hver fase skal en tredjepart gjøre et **review for improvement** — målet er å forbedre resultatet, ikke å godkjenne/avvise. Dette skjer som en PR-review på trunk-based vis:

1. Eier lager en PR som flytter oppgaven videre (oppretter/endrer artefakter, oppdaterer `roadmap.md` og `oppgave.md`).
2. Reviewer ser etter feil og muligheter for forbedring, og legger inn kommentarer/suggestions.
3. Utfall:
   - **Ingen verdifulle forbedringer**: PR merges, fase oppdateres, issue-status justeres.
   - **Forbedringer foreslått**: PR stenges eller blir liggende mens eier følger opp; oppgaven forblir i samme fase; en *annen* tredjepart gjør neste review. `oppgave.md` fører liste over hvem som allerede har reviewet.

### Hva som produseres per faseovergang

| Overgang                    | Produkt                                                         |
|-----------------------------|-----------------------------------------------------------------|
| todo → design               | `design.md`                                                     |
| design → planning           | Ett `plan-<lag>.md` for hvert lag som må endres                 |
| planning → implementation   | PR(er) som leverer på plan; planfiler får avkryssede bokser     |
| implementation → done       | Alle planbokser avkrysset; lenker til relevante PRs i `oppgave.md` |

## Legge til et nytt team

1. Kopier `mal/` til `veikart/<ditt-team>/` om dere vil avvike fra fellesmalene, eller bare opprett `veikart/<ditt-team>/` og lenk til `veikart/mal/`.
2. Opprett `README.md` (team-info) og en tom `roadmap.md`.
3. Lag `oppgaver/`-mappen og begynn å plukke oppgaver fra GitHub issues.

Team kan ha sine egne konvensjoner innenfor sin mappe, så lenge mapping til issue-status og faseoverganger er forutsigbar.
