---
issue: sikt-no/fs#476
slug: idporten-fs-admin-fase1
krav_path: krav/07 Brukeradministrasjon og tilgangsstyring/10 Pålogging
pipeline:
  - { repo: fs,           skill: /bat-specify, artifact: "spec-*.md" }
  - { repo: fs-plattform, skill: /bat-analyze, artifact: "analysis-*.md" }
  - { repo: fs-plattform, skill: /bat-plan,    artifact: "plan-*.md" }
  - { repo: fs-plattform, skill: /bat-execute, artifact: "task-*-completion.md" }
---

# idporten-fs-admin-fase1 — flyt

Fase 1 av sikt-no/fs#476 (Innlogging til FS Admin for fagskoleansatte): ID-porten som utsteder i coprocessoren.
Avklaringsissue om betaling og avtaler: sikt-no/fs#514.
Ytterligere spec: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5022777363

Denne tasken dekker coprocessor-tilpasningen i `fs-plattform/tilgangsstyring`
(tilgangsstyring-app). Krav og specify i fs, analyse/plan/execute i fs-plattform.
Innloggingsflaten i fs-admin (NextAuth) tas som egen task etterpå.

Åpne spørsmål som analysen skal avgjøre:

- Hvordan kjøre coprocessor lokalt mot ID-porten (test) for å prøve flyten ende til ende.
- Hvordan fs-admin sender autentisering videre til FS GraphQL API når tokenet er
  utstedt til fs-admin men audiens skal være FS GraphQL: token exchange (slik Feide
  løses i dag) eller audiens/`resource` satt direkte i ID-porten-flyten.
