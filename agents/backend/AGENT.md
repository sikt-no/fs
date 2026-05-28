---
id: backend
display_name: Backend (fs-plattform) — mats.myhre
status: active
joined: 2026-05-28
---

# Backend (fs-plattform) — mats.myhre

## What this agent does

Owns the FS GraphQL platform (sis, tilgangsstyring, utdanningsregisteret, batch, codegen) in the [`fs-plattform`](https://gitlab.sikt.no/studieadm/fs-plattform) repo. Handles producer-side GraphQL schema, Graphitron resolver codegen, jOOQ + Liquibase database work, and federation/subgraph composition. Files cross-agent hand-offs to other registered agents when a task crosses domain boundaries (e.g. a frontend contract decision, a UI design question, or a non-backend integration concern).

## Machine

macOS — operator: mats.myhre@sikt.no.

## Owns / writes

- Issues labelled `agent:backend` (across whichever code repos this agent works in).
- This subtree under `agents/backend/`:
  - `memory.md` — append-only journal.
  - `outbox/` — drafts for other agents.
  - `<YYYY-MM-DD>-<feature-slug>/` — one folder per feature, containing all artifacts (`analysis.md`, `graphql-suggestions.md`, `plan.md`, etc.) that the bat-\* skills produce.
- Task files this agent creates under `tasks/`.

## Hands off to

Other agents in the registry — see `agents/README.md` for the current list. Hand-off issues go in the target repo with the `agent:<target>` label and a body linking to the relevant feature folder under `agents/backend/<feature-folder>/` so the receiving agent reads the full analysis + plan together, not a focused excerpt.
