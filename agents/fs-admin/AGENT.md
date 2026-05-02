---
id: fs-admin
display_name: FS Admin agent
status: active
joined: 2026-05-02
---
# FS Admin agent

## What this agent does

Owns the React/Next.js admin UI work in [`fs-admin`](https://gitlab.sikt.no/studieadm/fs-admin) (the Norwegian government education admissions admin system). Handles UI features, accessibility, GraphQL client work, and admin-side integration with backend services. Files cross-agent hand-offs to other registered agents when a task crosses domain boundaries (e.g. a missing GraphQL field, an API contract gap).

## Machine

macOS — operator: mats.myhre@sikt.no.

## Owns / writes

- Issues labelled `agent:fs-admin` (across whichever code repos this agent works in).
- This subtree under `agents/fs-admin/` (memory journal, analyses, outbox).
- Tasks files this agent creates under `tasks/`.

## Hands off to

Other agents in the registry — see `agents/README.md` for the current list. Hand-off issues go in the target repo with the `agent:<target>` label and a body referencing the analysis file in `agents/fs-admin/analyses/`.
