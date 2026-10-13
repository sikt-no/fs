---
issue: sikt-no/fs#143
initiativ: sikt-no/fs#350
domain: brukeradministrasjon-og-tilgangsstyring
slug: grunnleggende-brukeradministrasjon
krav_path: krav/07 Brukeradministrasjon og tilgangsstyring/12 Brukeradministrasjon/personbrukere/1 - Grunnleggende brukeradministrasjon
pipeline:
  - { repo: fs,           dir: spec,     skill: /bat-specify,     artifact: "spec-*.md" }
  - { repo: fs-admin,     dir: frontend, skill: /bat-analyze,     artifact: "analysis-*.md" }
  - { repo: fs-admin,     dir: frontend, skill: /bat-plan,        artifact: "plan-*.md" }
  - { repo: fs-plattform, dir: subgraph, skill: /subgraph-plan,   artifact: "subgraph-plan-*.md" }
  - { repo: fs-admin,     dir: frontend, skill: /bat-execute,     artifact: "task-*-completion.md" }
  - { repo: fs-plattform, dir: subgraph, skill: /subgraph-expand, artifact: "subgraph-expansion-*.md" }
---

# grunnleggende-brukeradministrasjon — flyt

Greenfield-feature for grunnleggende brukeradministrasjon av personbrukere
(sikt-no/fs#143, under initiativet sikt-no/fs#350). Krav og spec i fs, analyse/plan/execute
i fs-admin, med subgraph-halespor i fs-plattform for schema-endringene.

Artefaktene ligger delt etter produsent: krav i `spec/`, fs-admin-arbeidet i `frontend/`.
Menneske-artefaktene (`oppgave.md`, `design.md`, `reviews/`) ligger i task-rota.
