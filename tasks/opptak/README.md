# Domene: Opptak

Oppgaver og arbeidsartefakter for opptak i FS.

**Eierteam:** Shiitake (opptak, regelverk), Shinkansen (utdanningstilbud).

## Innhold

- [`roadmap.md`](roadmap.md) — aktive og ferdige oppgaver med lenker til issues og artefakter
- Én undermappe per oppgave (kebab-case slug), med `oppgave.md`, `design.md`, `spec/`, `<lag>/` og `reviews/`

Struktur, domeneliste, faser og regler er felles og beskrevet i [`../README.md`](../README.md). Maler ligger i [`../mal/`](../mal/).

## Relevante krav og issues

- Krav: [`krav/02 Opptak/`](../../krav/02%20Opptak/)
- Issues i GitHub: filtrer på label `Opptak`
- Confluence: [T3 2026 Forberede opptak og etterbehandling](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/4981817377)

## Teamkonvensjoner

- Vi følger faseflyten og review-for-improvement som beskrevet i [`../README.md`](../README.md).
- Mappenavn er kebab-case slug (ikke issue-nummer).
- **Lag = undermappe.** Kravene ligger i `spec/`; en plan for et lag ligger som `<lag>/plan-<slug>.md`, aldri som `plan-<lag>.md` i oppgave-rota (se regel 1 og 2 i [`../README.md`](../README.md#fire-regler)). Lag vi typisk bruker: `spec` (Gherkin-krav), `frontend`, `backend`, `subgraph`, `db`. Bruk bare de lagene oppgaven faktisk rører.