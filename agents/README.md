# Agent coordination layout

Two-agent coordination per `docs/INGEST/Agent Coordination Spec.md` (in the `admissio-soknadsbehandling` repo, to be canonicalized here later).

## Write discipline (load-bearing)

- An agent writes **only** under `agents/$AGENT_ID/`.
- Files in `tasks/` are **created**, never modified, by the agent that opens them. Filenames use the issue number (atomic from GitHub) so collisions are mechanically impossible.
- `shared/` changes go through PR, not direct push.

This is enforced by convention here, but mechanical guarantees come from the per-agent subtree split + atomic issue-number filenames. Don't break the discipline.

## Layout

```
agents/
  frontend/
    memory.md         # append-only journal, frontend writes only
    analyses/         # one .md per topic, immutable from backend's POV
    outbox/           # drafts/notes intended for backend
  backend/
    memory.md
    analyses/
    outbox/
shared/
  glossary.md
  architecture.md
tasks/
  {issue-number}.md   # richer spec when issue body isn't enough
```

## Identity

Per machine, in `~/.config/agent-coord.env`:

```
AGENT_ID=frontend       # or backend
COORD_REPO=/abs/path/to/local/clone/of/this/repo
OTHER_AGENT=backend     # or frontend
```

The `agent-coord` skill reads these via the env or the file. The `UserPromptSubmit` hook handles the per-turn `git pull`.
