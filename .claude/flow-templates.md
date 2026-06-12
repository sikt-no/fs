---
templates:
  - id: full-bat
    name: Full BAT-flyt
    desc: Spesifiser kravene, gjør hovedendringen i ett repo og speil den i et avhengig repo.
    pipeline:
      - { repo: fs,           skill: /bat-specify,     artifact: "spec-*.md" }
      - { repo: fs-admin,     skill: /bat-analyze,     artifact: "analysis-*.md" }
      - { repo: fs-admin,     skill: /bat-plan,        artifact: "plan-*.md" }
      - { repo: fs-plattform, skill: /subgraph-plan,   artifact: "subgraph-plan-*.md" }
      - { repo: fs-admin,     skill: /bat-execute,     artifact: "task-*-completion.md" }
      - { repo: fs-plattform, skill: /subgraph-expand, artifact: "subgraph-expansion-*.md" }
---

# Pipeline-templates

Maler for `flow.md`-pipelines. Alfred leser `templates:` i frontmatter når en ny task
startes og kopierer valgt `pipeline` inn i den nye feature-folderens `flow.md`.
Malene er referansemateriale — `flow.md` er alltid kjørende fasit.

Stegformat: `{ repo, skill, artifact }`. `repo` må finnes i `repos:`-mappet i
`.claude/flow.local.md`. `artifact`-globben matches mot feature-folderen for å avgjøre
om steget er ferdig — første steg uten treff er gjeldende steg.

Merk at `plan-*.md` ikke matcher `subgraph-plan-*.md` (glob matcher hele filnavnet),
så de to plan-stegene er entydige i samme folder.
