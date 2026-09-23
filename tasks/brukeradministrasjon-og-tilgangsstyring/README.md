# Domene: Brukeradministrasjon og tilgangsstyring

Oppgaver og arbeidsartefakter for brukeradministrasjon og tilgangsstyring i FS.

**Eierteam:** Tilgangsstyring.

## Innhold

- [`roadmap.md`](roadmap.md) — aktive og ferdige oppgaver med lenker til issues og artefakter
- Én undermappe per oppgave (kebab-case slug), med `oppgave.md`, `design.md`, `spec/`, `<lag>/` og `reviews/`

Struktur, domeneliste, faser og regler er felles og beskrevet i [`../README.md`](../README.md). Maler ligger i [`../mal/`](../mal/).

## Relevante krav og issues

- Krav: [`krav/07 Brukeradministrasjon og tilgangsstyring/`](../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/)
- Issues i GitHub: filtrer på label `Brukeradministrasjon og tilgangsstyring`
- Domenekunnskap: https://fs.sikt.no/domenekunnskap/prosesser/tilgangsstyring-og-tilgangskontroll/

## Teamkonvensjoner

- Vi følger faseflyten og review-for-improvement som beskrevet i [`../README.md`](../README.md).
- Mappenavn er kebab-case slug (ikke issue-nummer).
- **Lag = undermappe.** Kravene ligger i `spec/`; en plan for et lag ligger som `<lag>/plan-<slug>.md`, aldri som `plan-<lag>.md` i oppgave-rota (se regel 1 og 2 i [`../README.md`](../README.md#fire-regler)). Lag vi typisk bruker: `spec` (Gherkin-krav), `tester` (Playwright), `backend`, `frontend`, `subgraph`, `db`. Bruk bare de lagene oppgaven faktisk rører.
- En oppgave skal ha minst én reviewer som ikke er eier før den flyttes mellom faser.
- Hvis en reviewer finner verdifulle forbedringer, må *en annen* gjøre neste review. Vi fører reviewer-historikk i `oppgave.md`.

## Teammedlemmer

Vi er et team på 6. Fyll inn med GitHub-brukernavn og rolle etter hvert.

- @ — produktledelse
- @ — utvikling
- @ — utvikling
- @ — utvikling
- @ — design/UX
- @ — domene/krav
