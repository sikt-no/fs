---
issue: sikt-no/fs#31
domain: brukeradministrasjon-og-tilgangsstyring
slug: applikasjoner-visning-delta
krav_path: krav/07 Brukeradministrasjon og tilgangsstyring/applikasjoner
pipeline:
  - { repo: fs,           dir: spec,     skill: /bat-specify-delta, artifact: "spec-changes-*.md" }
  - { repo: fs-admin,     dir: frontend, skill: /bat-analyze,       artifact: "analysis-*.md" }
  - { repo: fs-admin,     dir: frontend, skill: /bat-plan,          artifact: "plan-*.md" }
  - { repo: fs-plattform, dir: subgraph, skill: /subgraph-plan,     artifact: "subgraph-plan-*.md" }
  - { repo: fs-admin,     dir: frontend, skill: /bat-execute,       artifact: "task-*-completion.md" }
  - { repo: fs-plattform, dir: subgraph, skill: /subgraph-expand,   artifact: "subgraph-expansion-*.md" }
---

# applikasjoner-visning-delta — flyt

Delta-iterasjon på applikasjoner-visning under tilgangsstyring (sikt-no/fs#31).
Krav-spec leses som endringsinput i fs, deretter analyse/plan/execute i fs-admin
med subgraph-halespor i fs-plattform.

Artefaktene ligger delt etter produsent: krav i `spec/`, fs-admin-arbeidet i `frontend/`.
Menneske-artefaktene (`oppgave.md`, `design.md`, `reviews/`) ligger i task-rota.
