---
issue: sikt-no/fs#31
slug: applikasjoner-visning-delta
krav_path: krav/07 Brukeradministrasjon og tilgangsstyring/applikasjoner
pipeline:
  - { repo: fs,           skill: /bat-specify-delta, artifact: "spec-changes-*.md" }
  - { repo: fs-admin,     skill: /bat-analyze,       artifact: "analysis-*.md" }
  - { repo: fs-admin,     skill: /bat-plan,          artifact: "plan-*.md" }
  - { repo: fs-plattform, skill: /subgraph-plan,     artifact: "subgraph-plan-*.md" }
  - { repo: fs-admin,     skill: /bat-execute,       artifact: "task-*-completion.md" }
  - { repo: fs-plattform, skill: /subgraph-expand,   artifact: "subgraph-expansion-*.md" }
---

# applikasjoner-visning-delta — flyt

Delta-iterasjon på applikasjoner-visning under tilgangsstyring (sikt-no/fs#31).
Krav-spec leses som endringsinput i fs, deretter analyse/plan/execute i fs-admin
med subgraph-halespor i fs-plattform.
