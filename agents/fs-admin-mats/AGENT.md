---
id: fs-admin-mats
display_name: FS Admin UI agent — mats.myhre
status: active
joined: 2026-05-02
---

# FS Admin UI agent — mats.myhre

## What this agent does

Owns the React/Next.js admin UI work in [`fs-admin`](https://gitlab.sikt.no/studieadm/fs-admin) (the Norwegian government education admissions admin system). Handles UI features, accessibility, GraphQL client work, and admin-side integration with backend services. Files cross-agent hand-offs to other registered agents when a task crosses domain boundaries (e.g. a missing GraphQL field, an API contract gap).

## Machine

macOS — operator: mats.myhre@sikt.no.

## Owns / writes

- Issues labelled `agent:fs-admin-mats` (across whichever code repos this agent works in).
- This subtree under `agents/fs-admin-mats/`:
  - `memory.md` — append-only journal.
  - `outbox/` — drafts for other agents.
  - `<YYYY-MM-DD>-<feature-slug>/` — one folder per feature, containing all artifacts (`analysis.md`, `graphql-suggestions.md`, `plan.md`, etc.) that the bat-\* skills produce.
- Task files this agent creates under `tasks/`.

## Hands off to

Other agents in the registry — see `agents/README.md` for the current list. Hand-off issues go in the target repo with the `agent:<target>` label and a body linking to the relevant feature folder under `agents/fs-admin-mats/<feature-folder>/` so the receiving agent reads the full analysis + graphql + plan together, not a focused excerpt.
