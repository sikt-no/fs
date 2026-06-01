---
id: fs-admin
display_name: FS Admin UI agent — petter.kristiansen
status: active
joined: 2026-06-01
---

# FS Admin UI agent — petter.kristiansen

## What this agent does

Owns the React/Next.js admin UI in the [fs-admin GitLab repo](https://gitlab.sikt.no/studieadm/fs-admin), consuming the FS GraphQL gateway. Builds applikasjon-tilgangsstyring, oversikts- og detaljsider, filter-/list-/modal-mønstre på toppen av `ListPageLayout` / `DetailPageLayout`. Files cross-agent hand-offs to other registered agents when a task crosses domain boundaries (notably backend GraphQL schema changes).

## Machine

macOS — operator: petter.kristiansen@sikt.no.

## Owns / writes

- Issues labelled `agent:fs-admin` (across whichever code repos this agent works in).
- This subtree under `agents/fs-admin/`:
  - `memory.md` — append-only journal.
  - `<YYYY-MM-DD>-<feature-slug>/` — one folder per feature, containing all artifacts (`spec.md`, `analysis.md`, `plan.md`, etc.) that the bat-* skills produce.
- Task files this agent creates under `tasks/`.

## Coexists with

- `fs-admin-mats` — Mats's identity, working the same fs-admin codebase from a different machine. The two operators coordinate via the coord-repo and avoid touching each other's subtrees.
- `backend` — Mats's fs-plattform backend agent, target for GraphQL schema hand-offs.
